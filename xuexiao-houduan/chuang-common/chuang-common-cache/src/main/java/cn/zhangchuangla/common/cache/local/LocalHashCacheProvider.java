package cn.zhangchuangla.common.cache.local;

import cn.zhangchuangla.common.cache.config.CacheProperties;
import cn.zhangchuangla.common.cache.core.HashCacheProvider;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * 基于 Caffeine 的本地 Hash 缓存提供者实现
 *
 * @author Chuang
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
public class LocalHashCacheProvider implements HashCacheProvider {

    /**
     * 存储 Hash 数据的缓存
     * key -> HashWrapper (包含 Map 数据和过期时间)
     */
    private final Cache<String, HashWrapper> cache;
    private final CacheProperties properties;

    public LocalHashCacheProvider(CacheProperties properties) {
        this.properties = properties;
        this.cache = Caffeine.newBuilder()
                .maximumSize(properties.getLocal().getMaxSize())
                .expireAfterWrite(properties.getLocal().getExpireSeconds(), TimeUnit.SECONDS)
                .build();
        log.info("LocalHashCacheProvider initialized");
    }

    @Override
    @SuppressWarnings("unchecked")
    public <HK, HV> void hPut(String key, HK field, HV value) {
        HashWrapper wrapper = getOrCreateWrapper(key);
        wrapper.getData().put(field, value);
        cache.put(key, wrapper);
    }

    @Override
    @SuppressWarnings("unchecked")
    public <HK, HV> void hPutAll(String key, Map<HK, HV> map) {
        if (map == null || map.isEmpty()) {
            return;
        }
        HashWrapper wrapper = getOrCreateWrapper(key);
        wrapper.getData().putAll(map);
        cache.put(key, wrapper);
    }

    @Override
    @SuppressWarnings("unchecked")
    public <HK, HV> HV hGet(String key, HK field) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            if (wrapper != null) {
                cache.invalidate(key);
            }
            return null;
        }
        return (HV) wrapper.getData().get(field);
    }

    @Override
    @SuppressWarnings("unchecked")
    public <HK, HV> Map<HK, HV> hGetAll(String key) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            if (wrapper != null) {
                cache.invalidate(key);
            }
            return new HashMap<>();
        }
        return new HashMap<>((Map<HK, HV>) wrapper.getData());
    }

    @Override
    @SuppressWarnings("unchecked")
    public <HK> Long hRemove(String key, HK... fields) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return 0L;
        }
        long count = 0;
        for (HK field : fields) {
            if (wrapper.getData().remove(field) != null) {
                count++;
            }
        }
        if (wrapper.getData().isEmpty()) {
            cache.invalidate(key);
        } else {
            cache.put(key, wrapper);
        }
        return count;
    }

    @Override
    public Boolean hExists(String key, Object field) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return false;
        }
        return wrapper.getData().containsKey(field);
    }

    @Override
    public Long hSize(String key) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return 0L;
        }
        return (long) wrapper.getData().size();
    }

    @Override
    @SuppressWarnings("unchecked")
    public <HK> Long hIncrement(String key, HK field, long delta) {
        HashWrapper wrapper = getOrCreateWrapper(key);
        Object current = wrapper.getData().get(field);
        long newValue;
        if (current == null) {
            newValue = delta;
        } else if (current instanceof Number) {
            newValue = ((Number) current).longValue() + delta;
        } else {
            throw new IllegalArgumentException("Field value is not a number: " + current);
        }
        wrapper.getData().put(field, newValue);
        cache.put(key, wrapper);
        return newValue;
    }

    @Override
    public Boolean expire(String key, long timeout, TimeUnit unit) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null) {
            return false;
        }
        long expireAtMillis = System.currentTimeMillis() + unit.toMillis(timeout);
        wrapper.setExpireAt(expireAtMillis);
        cache.put(key, wrapper);
        return true;
    }

    @Override
    public Long getExpire(String key) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null) {
            return -2L;
        }
        if (wrapper.isExpired()) {
            cache.invalidate(key);
            return -2L;
        }
        return wrapper.getTtlSeconds();
    }

    @Override
    public List<String> scanKeys(String pattern) {
        if (!StringUtils.hasText(pattern)) {
            return new ArrayList<>();
        }
        try {
            String regex = patternToRegex(pattern);
            return cache.asMap().keySet().stream()
                    .filter(key -> key.matches(regex))
                    .filter(key -> {
                        HashWrapper wrapper = cache.getIfPresent(key);
                        return wrapper != null && !wrapper.isExpired();
                    })
                    .collect(Collectors.toList());
        } catch (Exception e) {
            log.error("扫描 Hash 缓存键失败, pattern: {}", pattern, e);
            return new ArrayList<>();
        }
    }

    @Override
    public Map<String, Map<Object, Object>> scanKeysWithValues(String pattern) {
        if (!StringUtils.hasText(pattern)) {
            return new HashMap<>();
        }
        try {
            List<String> keys = scanKeys(pattern);
            Map<String, Map<Object, Object>> result = new HashMap<>();
            for (String key : keys) {
                Map<Object, Object> data = hGetAll(key);
                if (!data.isEmpty()) {
                    result.put(key, data);
                }
            }
            return result;
        } catch (Exception e) {
            log.error("扫描 Hash 缓存键值失败, pattern: {}", pattern, e);
            return new HashMap<>();
        }
    }

    private HashWrapper getOrCreateWrapper(String key) {
        HashWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            wrapper = new HashWrapper();
        }
        return wrapper;
    }

    private String patternToRegex(String pattern) {
        StringBuilder regex = new StringBuilder();
        for (char c : pattern.toCharArray()) {
            switch (c) {
                case '*':
                    regex.append(".*");
                    break;
                case '?':
                    regex.append(".");
                    break;
                case '.':
                case '(':
                case ')':
                case '[':
                case ']':
                case '{':
                case '}':
                case '\\':
                case '^':
                case '$':
                case '|':
                case '+':
                    regex.append("\\").append(c);
                    break;
                default:
                    regex.append(c);
            }
        }
        return regex.toString();
    }

    /**
     * Hash 数据包装类
     */
    @lombok.Data
    public static class HashWrapper {
        private Map<Object, Object> data = new ConcurrentHashMap<>();
        private Long expireAt;

        public boolean isExpired() {
            return expireAt != null && System.currentTimeMillis() > expireAt;
        }

        public long getTtlSeconds() {
            if (expireAt == null) {
                return -1;
            }
            long ttl = (expireAt - System.currentTimeMillis()) / 1000;
            return ttl > 0 ? ttl : -2;
        }
    }
}

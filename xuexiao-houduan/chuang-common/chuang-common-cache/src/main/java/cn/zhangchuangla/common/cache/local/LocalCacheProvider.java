package cn.zhangchuangla.common.cache.local;

import cn.zhangchuangla.common.cache.config.CacheProperties;
import cn.zhangchuangla.common.cache.core.CacheProvider;
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
 * 基于 Caffeine 的本地缓存提供者实现
 *
 * @author Chuang
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
public class LocalCacheProvider implements CacheProvider {

    private final Cache<String, CacheWrapper> cache;
    private final CacheProperties properties;

    public LocalCacheProvider(CacheProperties properties) {
        this.properties = properties;
        this.cache = Caffeine.newBuilder()
                .maximumSize(properties.getLocal().getMaxSize())
                .expireAfterWrite(properties.getLocal().getExpireSeconds(), TimeUnit.SECONDS)
                .recordStats()
                .build();
        log.info("LocalCacheProvider initialized with maxSize={}, expireSeconds={}",
                properties.getLocal().getMaxSize(), properties.getLocal().getExpireSeconds());
    }

    @Override
    public <T> void set(String key, T value) {
        cache.put(key, CacheWrapper.of(value));
    }

    @Override
    public <T> void set(String key, T value, long timeout, TimeUnit unit) {
        long expireAtMillis = System.currentTimeMillis() + unit.toMillis(timeout);
        cache.put(key, CacheWrapper.of(value, expireAtMillis));
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T get(String key) {
        try {
            CacheWrapper wrapper = cache.getIfPresent(key);
            if (wrapper == null) {
                return null;
            }
            if (wrapper.isExpired()) {
                cache.invalidate(key);
                return null;
            }
            return (T) wrapper.getValue();
        } catch (Exception e) {
            log.error("缓存获取失败, key: {}", key, e);
            return null;
        }
    }

    @Override
    public boolean delete(String key) {
        try {
            cache.invalidate(key);
            return true;
        } catch (Exception e) {
            log.error("缓存删除失败, key: {}", key, e);
            return false;
        }
    }

    @Override
    public long delete(Collection<String> keys) {
        if (keys == null || keys.isEmpty()) {
            return 0;
        }
        try {
            cache.invalidateAll(keys);
            return keys.size();
        } catch (Exception e) {
            log.error("批量缓存删除失败, keys: {}", keys, e);
            return 0;
        }
    }

    @Override
    public boolean expire(String key, long timeout, TimeUnit unit) {
        try {
            CacheWrapper wrapper = cache.getIfPresent(key);
            if (wrapper == null) {
                return false;
            }
            long expireAtMillis = System.currentTimeMillis() + unit.toMillis(timeout);
            wrapper.updateExpireAt(expireAtMillis);
            cache.put(key, wrapper);
            return true;
        } catch (Exception e) {
            log.error("设置过期时间失败, key: {}", key, e);
            return false;
        }
    }

    @Override
    public boolean exists(String key) {
        CacheWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null) {
            return false;
        }
        if (wrapper.isExpired()) {
            cache.invalidate(key);
            return false;
        }
        return true;
    }

    @Override
    public Long getExpire(String key) {
        return getExpire(key, TimeUnit.SECONDS);
    }

    @Override
    public Long getExpire(String key, TimeUnit unit) {
        CacheWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null) {
            return -2L;
        }
        if (wrapper.isExpired()) {
            cache.invalidate(key);
            return -2L;
        }
        long ttlMillis = wrapper.getTtlMillis();
        if (ttlMillis < 0) {
            return ttlMillis;
        }
        return unit.convert(ttlMillis, TimeUnit.MILLISECONDS);
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
                    .filter(this::exists)  // 过滤已过期的
                    .collect(Collectors.toList());
        } catch (Exception e) {
            log.error("扫描缓存键失败, pattern: {}", pattern, e);
            return new ArrayList<>();
        }
    }

    @Override
    public Map<String, Object> scanKeysWithValues(String pattern) {
        if (!StringUtils.hasText(pattern)) {
            return new HashMap<>();
        }
        try {
            List<String> keys = scanKeys(pattern);
            Map<String, Object> result = new HashMap<>();
            for (String key : keys) {
                Object value = get(key);
                if (value != null) {
                    result.put(key, value);
                }
            }
            return result;
        } catch (Exception e) {
            log.error("扫描缓存键值失败, pattern: {}", pattern, e);
            return new HashMap<>();
        }
    }

    @Override
    public boolean setIfAbsent(String key, Object value, long timeout, TimeUnit unit) {
        try {
            CacheWrapper existing = cache.getIfPresent(key);
            if (existing != null && !existing.isExpired()) {
                return false;
            }
            long expireAtMillis = System.currentTimeMillis() + unit.toMillis(timeout);
            cache.put(key, CacheWrapper.of(value, expireAtMillis));
            return true;
        } catch (Exception e) {
            log.error("setIfAbsent 失败, key: {}", key, e);
            return false;
        }
    }

    /**
     * 将通配符模式转换为正则表达式
     *
     * @param pattern 通配符模式（支持 * 和 ?）
     * @return 正则表达式
     */
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
     * 获取缓存统计信息
     *
     * @return 统计信息字符串
     */
    public String getStats() {
        return cache.stats().toString();
    }

    /**
     * 清空所有缓存
     */
    public void clear() {
        cache.invalidateAll();
    }

    /**
     * 获取缓存大小
     *
     * @return 缓存条目数量
     */
    public long size() {
        return cache.estimatedSize();
    }
}

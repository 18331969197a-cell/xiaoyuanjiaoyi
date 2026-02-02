package cn.zhangchuangla.common.cache.local;

import cn.zhangchuangla.common.cache.config.CacheProperties;
import cn.zhangchuangla.common.cache.core.ZSetCacheProvider;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.concurrent.ConcurrentSkipListMap;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * 基于 Caffeine 的本地 ZSet 缓存提供者实现
 *
 * @author Chuang
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
public class LocalZSetCacheProvider implements ZSetCacheProvider {

    private final Cache<String, ZSetWrapper> cache;
    private final CacheProperties properties;

    public LocalZSetCacheProvider(CacheProperties properties) {
        this.properties = properties;
        this.cache = Caffeine.newBuilder()
                .maximumSize(properties.getLocal().getMaxSize())
                .expireAfterWrite(properties.getLocal().getExpireSeconds(), TimeUnit.SECONDS)
                .build();
        log.info("LocalZSetCacheProvider initialized");
    }

    @Override
    public <T> void zAdd(String key, T value, double score) {
        ZSetWrapper wrapper = getOrCreateWrapper(key);
        wrapper.add(value, score);
        cache.put(key, wrapper);
    }

    @Override
    public <T> void zAdd(String key, T value, double score, long timeout, TimeUnit unit) {
        ZSetWrapper wrapper = getOrCreateWrapper(key);
        wrapper.add(value, score);
        wrapper.setExpireAt(System.currentTimeMillis() + unit.toMillis(timeout));
        cache.put(key, wrapper);
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> Long zRemove(String key, T... values) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return 0L;
        }
        long count = 0;
        for (T value : values) {
            if (wrapper.remove(value)) {
                count++;
            }
        }
        if (wrapper.isEmpty()) {
            cache.invalidate(key);
        } else {
            cache.put(key, wrapper);
        }
        return count;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> Set<T> zRange(String key, long start, long end) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return new LinkedHashSet<>();
        }
        return (Set<T>) wrapper.range(start, end);
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> Set<ScoredValue<T>> zRangeWithScores(String key, long start, long end) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return new LinkedHashSet<>();
        }
        // 需要先转为 Set 再转为目标类型，避免泛型类型转换错误
        Set<?> rawSet = wrapper.rangeWithScores(start, end);
        return (Set<ScoredValue<T>>) rawSet;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> Set<T> zRangeByScore(String key, double min, double max) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return new LinkedHashSet<>();
        }
        return (Set<T>) wrapper.rangeByScore(min, max);
    }

    @Override
    public Long zCount(String key, double min, double max) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return 0L;
        }
        return wrapper.countByScore(min, max);
    }

    @Override
    public Long zCard(String key) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return 0L;
        }
        return (long) wrapper.size();
    }

    @Override
    public <T> Double zScore(String key, T value) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return null;
        }
        return wrapper.getScore(value);
    }

    @Override
    public <T> Double zIncrementScore(String key, T value, double delta) {
        ZSetWrapper wrapper = getOrCreateWrapper(key);
        Double newScore = wrapper.incrementScore(value, delta);
        cache.put(key, wrapper);
        return newScore;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> Map<T, Double> zGetAllWithScores(String key) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            return new LinkedHashMap<>();
        }
        return (Map<T, Double>) wrapper.getAllWithScores();
    }

    @Override
    public Boolean expire(String key, long timeout, TimeUnit unit) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null) {
            return false;
        }
        wrapper.setExpireAt(System.currentTimeMillis() + unit.toMillis(timeout));
        cache.put(key, wrapper);
        return true;
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
                        ZSetWrapper wrapper = cache.getIfPresent(key);
                        return wrapper != null && !wrapper.isExpired();
                    })
                    .collect(Collectors.toList());
        } catch (Exception e) {
            log.error("扫描 ZSet 缓存键失败, pattern: {}", pattern, e);
            return new ArrayList<>();
        }
    }

    @Override
    public Map<String, Map<Object, Double>> scanKeysWithValues(String pattern) {
        if (!StringUtils.hasText(pattern)) {
            return new HashMap<>();
        }
        try {
            List<String> keys = scanKeys(pattern);
            Map<String, Map<Object, Double>> result = new HashMap<>();
            for (String key : keys) {
                Map<Object, Double> data = zGetAllWithScores(key);
                if (!data.isEmpty()) {
                    result.put(key, data);
                }
            }
            return result;
        } catch (Exception e) {
            log.error("扫描 ZSet 缓存键值失败, pattern: {}", pattern, e);
            return new HashMap<>();
        }
    }

    private ZSetWrapper getOrCreateWrapper(String key) {
        ZSetWrapper wrapper = cache.getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            wrapper = new ZSetWrapper();
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
     * ZSet 数据包装类
     */
    @Data
    public static class ZSetWrapper {
        // 按分数排序的 Map: score -> Set<value>
        private final ConcurrentSkipListMap<Double, Set<Object>> scoreToValues = new ConcurrentSkipListMap<>();
        // value -> score 的映射
        private final Map<Object, Double> valueToScore = new HashMap<>();
        private Long expireAt;

        public boolean isExpired() {
            return expireAt != null && System.currentTimeMillis() > expireAt;
        }

        public void add(Object value, double score) {
            // 如果已存在，先移除旧的
            Double oldScore = valueToScore.get(value);
            if (oldScore != null) {
                Set<Object> values = scoreToValues.get(oldScore);
                if (values != null) {
                    values.remove(value);
                    if (values.isEmpty()) {
                        scoreToValues.remove(oldScore);
                    }
                }
            }
            // 添加新的
            valueToScore.put(value, score);
            scoreToValues.computeIfAbsent(score, k -> new LinkedHashSet<>()).add(value);
        }

        public boolean remove(Object value) {
            Double score = valueToScore.remove(value);
            if (score != null) {
                Set<Object> values = scoreToValues.get(score);
                if (values != null) {
                    values.remove(value);
                    if (values.isEmpty()) {
                        scoreToValues.remove(score);
                    }
                }
                return true;
            }
            return false;
        }

        public Set<Object> range(long start, long end) {
            List<Object> allValues = new ArrayList<>();
            for (Set<Object> values : scoreToValues.values()) {
                allValues.addAll(values);
            }
            int size = allValues.size();
            if (start < 0) start = size + start;
            if (end < 0) end = size + end;
            if (start < 0) start = 0;
            if (end >= size) end = size - 1;
            if (start > end || start >= size) {
                return new LinkedHashSet<>();
            }
            return new LinkedHashSet<>(allValues.subList((int) start, (int) end + 1));
        }

        public Set<ScoredValue<Object>> rangeWithScores(long start, long end) {
            List<Map.Entry<Object, Double>> allEntries = new ArrayList<>();
            for (Map.Entry<Double, Set<Object>> entry : scoreToValues.entrySet()) {
                Double score = entry.getKey();
                for (Object value : entry.getValue()) {
                    allEntries.add(Map.entry(value, score));
                }
            }
            int size = allEntries.size();
            if (start < 0) start = size + start;
            if (end < 0) end = size + end;
            if (start < 0) start = 0;
            if (end >= size) end = size - 1;
            if (start > end || start >= size) {
                return new LinkedHashSet<>();
            }
            Set<ScoredValue<Object>> result = new LinkedHashSet<>();
            for (int i = (int) start; i <= end; i++) {
                Map.Entry<Object, Double> entry = allEntries.get(i);
                result.add(new ScoredValue<>(entry.getKey(), entry.getValue()));
            }
            return result;
        }

        public Set<Object> rangeByScore(double min, double max) {
            Set<Object> result = new LinkedHashSet<>();
            for (Map.Entry<Double, Set<Object>> entry : scoreToValues.subMap(min, true, max, true).entrySet()) {
                result.addAll(entry.getValue());
            }
            return result;
        }

        public long countByScore(double min, double max) {
            long count = 0;
            for (Set<Object> values : scoreToValues.subMap(min, true, max, true).values()) {
                count += values.size();
            }
            return count;
        }

        public Double getScore(Object value) {
            return valueToScore.get(value);
        }

        public Double incrementScore(Object value, double delta) {
            Double oldScore = valueToScore.get(value);
            double newScore = (oldScore != null ? oldScore : 0) + delta;
            add(value, newScore);
            return newScore;
        }

        public Map<Object, Double> getAllWithScores() {
            return new LinkedHashMap<>(valueToScore);
        }

        public int size() {
            return valueToScore.size();
        }

        public boolean isEmpty() {
            return valueToScore.isEmpty();
        }
    }
}

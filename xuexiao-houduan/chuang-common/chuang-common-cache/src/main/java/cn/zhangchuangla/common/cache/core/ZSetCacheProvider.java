package cn.zhangchuangla.common.cache.core;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * 有序集合（ZSet）缓存提供者接口
 *
 * @author Chuang
 */
public interface ZSetCacheProvider {

    /**
     * 带分数的值包装类
     *
     * @param <T> 值类型
     */
    class ScoredValue<T> {
        private final T value;
        private final Double score;

        public ScoredValue(T value, Double score) {
            this.value = value;
            this.score = score;
        }

        public T getValue() {
            return value;
        }

        public Double getScore() {
            return score;
        }
    }

    /**
     * 向有序集合添加元素
     *
     * @param key   缓存键
     * @param value 元素值
     * @param score 分数
     * @param <T>   值类型
     */
    <T> void zAdd(String key, T value, double score);

    /**
     * 向有序集合添加元素（带过期时间）
     *
     * @param key     缓存键
     * @param value   元素值
     * @param score   分数
     * @param timeout 过期时间
     * @param unit    时间单位
     * @param <T>     值类型
     */
    <T> void zAdd(String key, T value, double score, long timeout, TimeUnit unit);

    /**
     * 从有序集合移除元素
     *
     * @param key    缓存键
     * @param values 要移除的元素
     * @param <T>    值类型
     * @return 移除的元素数量
     */
    <T> Long zRemove(String key, T... values);

    /**
     * 按索引范围获取有序集合元素
     *
     * @param key   缓存键
     * @param start 起始索引
     * @param end   结束索引
     * @param <T>   值类型
     * @return 元素集合
     */
    <T> Set<T> zRange(String key, long start, long end);

    /**
     * 按索引范围获取有序集合元素及其分数
     *
     * @param key   缓存键
     * @param start 起始索引
     * @param end   结束索引
     * @param <T>   值类型
     * @return 带分数的元素集合
     */
    <T> Set<ScoredValue<T>> zRangeWithScores(String key, long start, long end);

    /**
     * 按分数范围获取有序集合元素
     *
     * @param key 缓存键
     * @param min 最小分数
     * @param max 最大分数
     * @param <T> 值类型
     * @return 元素集合
     */
    <T> Set<T> zRangeByScore(String key, double min, double max);

    /**
     * 统计分数范围内的元素数量
     *
     * @param key 缓存键
     * @param min 最小分数
     * @param max 最大分数
     * @return 元素数量
     */
    Long zCount(String key, double min, double max);

    /**
     * 获取有序集合的元素数量
     *
     * @param key 缓存键
     * @return 元素数量
     */
    Long zCard(String key);

    /**
     * 获取元素的分数
     *
     * @param key   缓存键
     * @param value 元素值
     * @param <T>   值类型
     * @return 分数，不存在返回 null
     */
    <T> Double zScore(String key, T value);

    /**
     * 增加元素的分数
     *
     * @param key   缓存键
     * @param value 元素值
     * @param delta 增量
     * @param <T>   值类型
     * @return 新的分数
     */
    <T> Double zIncrementScore(String key, T value, double delta);

    /**
     * 获取所有元素及其分数
     *
     * @param key 缓存键
     * @param <T> 值类型
     * @return 元素到分数的映射
     */
    <T> Map<T, Double> zGetAllWithScores(String key);

    /**
     * 设置过期时间
     *
     * @param key     缓存键
     * @param timeout 过期时间
     * @param unit    时间单位
     * @return 是否设置成功
     */
    Boolean expire(String key, long timeout, TimeUnit unit);

    /**
     * 扫描匹配的 ZSet 键
     *
     * @param pattern 匹配模式
     * @return 匹配的键列表
     */
    List<String> scanKeys(String pattern);

    /**
     * 扫描匹配的 ZSet 键并获取所有值
     *
     * @param pattern 匹配模式
     * @return 键到 ZSet 数据的映射
     */
    Map<String, Map<Object, Double>> scanKeysWithValues(String pattern);
}

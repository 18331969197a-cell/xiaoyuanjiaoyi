package cn.zhangchuangla.common.cache.core;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 缓存提供者接口
 * 定义统一的缓存操作方法，支持多种实现（本地缓存、数据库等）
 *
 * @author Chuang
 */
public interface CacheProvider {

    /**
     * 设置缓存对象（永不过期）
     *
     * @param key   缓存键
     * @param value 缓存值
     * @param <T>   值类型
     */
    <T> void set(String key, T value);

    /**
     * 设置缓存对象（带过期时间）
     *
     * @param key     缓存键
     * @param value   缓存值
     * @param timeout 过期时间
     * @param unit    时间单位
     * @param <T>     值类型
     */
    <T> void set(String key, T value, long timeout, TimeUnit unit);

    /**
     * 设置缓存对象（过期时间单位为秒）
     *
     * @param key            缓存键
     * @param value          缓存值
     * @param timeoutSeconds 过期时间（秒）
     * @param <T>            值类型
     */
    default <T> void set(String key, T value, long timeoutSeconds) {
        set(key, value, timeoutSeconds, TimeUnit.SECONDS);
    }

    /**
     * 获取缓存对象
     *
     * @param key 缓存键
     * @param <T> 值类型
     * @return 缓存值，不存在或已过期返回 null
     */
    <T> T get(String key);

    /**
     * 删除缓存对象
     *
     * @param key 缓存键
     * @return 是否删除成功
     */
    boolean delete(String key);

    /**
     * 批量删除缓存对象
     *
     * @param keys 缓存键集合
     * @return 删除的数量
     */
    long delete(Collection<String> keys);

    /**
     * 设置过期时间
     *
     * @param key     缓存键
     * @param timeout 过期时间
     * @param unit    时间单位
     * @return 是否设置成功
     */
    boolean expire(String key, long timeout, TimeUnit unit);

    /**
     * 设置过期时间（单位为秒）
     *
     * @param key            缓存键
     * @param timeoutSeconds 过期时间（秒）
     * @return 是否设置成功
     */
    default boolean expire(String key, long timeoutSeconds) {
        return expire(key, timeoutSeconds, TimeUnit.SECONDS);
    }

    /**
     * 判断 key 是否存在
     *
     * @param key 缓存键
     * @return 是否存在
     */
    boolean exists(String key);

    /**
     * 获取过期时间
     *
     * @param key 缓存键
     * @return 过期时间（秒），-1 表示永不过期，-2 表示不存在
     */
    Long getExpire(String key);

    /**
     * 获取过期时间
     *
     * @param key  缓存键
     * @param unit 时间单位
     * @return 过期时间
     */
    Long getExpire(String key, TimeUnit unit);

    /**
     * 扫描匹配的 key
     *
     * @param pattern 匹配模式（支持 * 通配符）
     * @return 匹配的 key 列表
     */
    List<String> scanKeys(String pattern);

    /**
     * 扫描匹配的 key 并获取值
     *
     * @param pattern 匹配模式
     * @return key-value 映射
     */
    Map<String, Object> scanKeysWithValues(String pattern);

    /**
     * 原子性设置（如果不存在则设置）
     *
     * @param key     缓存键
     * @param value   缓存值
     * @param timeout 过期时间
     * @param unit    时间单位
     * @return 是否设置成功（true 表示 key 不存在且设置成功）
     */
    boolean setIfAbsent(String key, Object value, long timeout, TimeUnit unit);

    /**
     * 判断 key 是否存在（别名方法）
     *
     * @param key 缓存键
     * @return 是否存在
     */
    default boolean hasKey(String key) {
        return exists(key);
    }
}

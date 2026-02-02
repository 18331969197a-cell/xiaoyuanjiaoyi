package cn.zhangchuangla.common.cache.core;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Hash 结构缓存提供者接口
 *
 * @author Chuang
 */
public interface HashCacheProvider {

    /**
     * 向 Hash 添加单个字段
     *
     * @param key   缓存键
     * @param field 字段名
     * @param value 字段值
     * @param <HK>  字段类型
     * @param <HV>  值类型
     */
    <HK, HV> void hPut(String key, HK field, HV value);

    /**
     * 向 Hash 批量添加字段
     *
     * @param key 缓存键
     * @param map 字段-值映射
     * @param <HK> 字段类型
     * @param <HV> 值类型
     */
    <HK, HV> void hPutAll(String key, Map<HK, HV> map);

    /**
     * 从 Hash 中获取单个字段
     *
     * @param key   缓存键
     * @param field 字段名
     * @param <HK>  字段类型
     * @param <HV>  值类型
     * @return 字段值，不存在返回 null
     */
    <HK, HV> HV hGet(String key, HK field);

    /**
     * 获取 Hash 的所有字段和值
     *
     * @param key  缓存键
     * @param <HK> 字段类型
     * @param <HV> 值类型
     * @return 字段-值映射
     */
    <HK, HV> Map<HK, HV> hGetAll(String key);

    /**
     * 从 Hash 中删除一个或多个字段
     *
     * @param key    缓存键
     * @param fields 要删除的字段
     * @param <HK>   字段类型
     * @return 删除的字段数量
     */
    <HK> Long hRemove(String key, HK... fields);

    /**
     * 判断 Hash 中是否存在某个字段
     *
     * @param key   缓存键
     * @param field 字段名
     * @return 是否存在
     */
    Boolean hExists(String key, Object field);

    /**
     * 获取 Hash 中字段的数量
     *
     * @param key 缓存键
     * @return 字段数量
     */
    Long hSize(String key);

    /**
     * 对 Hash 中的数值字段做增量操作
     *
     * @param key   缓存键
     * @param field 字段名
     * @param delta 增量（负值表示减）
     * @param <HK>  字段类型
     * @return 操作后的新值
     */
    <HK> Long hIncrement(String key, HK field, long delta);

    /**
     * 设置 Hash 的过期时间
     *
     * @param key     缓存键
     * @param timeout 过期时间
     * @param unit    时间单位
     * @return 是否设置成功
     */
    Boolean expire(String key, long timeout, TimeUnit unit);

    /**
     * 获取 Hash 的过期时间
     *
     * @param key 缓存键
     * @return 过期时间（秒）
     */
    Long getExpire(String key);

    /**
     * 扫描匹配的 Hash 键
     *
     * @param pattern 匹配模式
     * @return 匹配的键列表
     */
    List<String> scanKeys(String pattern);

    /**
     * 扫描匹配的 Hash 键并获取所有值
     *
     * @param pattern 匹配模式
     * @return 键到 Hash 数据的映射
     */
    Map<String, Map<Object, Object>> scanKeysWithValues(String pattern);
}

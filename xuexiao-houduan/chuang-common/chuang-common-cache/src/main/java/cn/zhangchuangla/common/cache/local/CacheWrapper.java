package cn.zhangchuangla.common.cache.local;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 缓存包装类，支持存储值和过期时间
 *
 * @author Chuang
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CacheWrapper {

    /**
     * 缓存值
     */
    private Object value;

    /**
     * 过期时间戳（毫秒），null 表示永不过期
     */
    private Long expireAt;

    /**
     * 创建永不过期的缓存包装
     *
     * @param value 缓存值
     * @return 缓存包装
     */
    public static CacheWrapper of(Object value) {
        return new CacheWrapper(value, null);
    }

    /**
     * 创建带过期时间的缓存包装
     *
     * @param value          缓存值
     * @param expireAtMillis 过期时间戳（毫秒）
     * @return 缓存包装
     */
    public static CacheWrapper of(Object value, long expireAtMillis) {
        return new CacheWrapper(value, expireAtMillis);
    }

    /**
     * 创建带过期时间的缓存包装
     *
     * @param value         缓存值
     * @param timeoutMillis 过期时间（毫秒）
     * @return 缓存包装
     */
    public static CacheWrapper withTimeout(Object value, long timeoutMillis) {
        return new CacheWrapper(value, System.currentTimeMillis() + timeoutMillis);
    }

    /**
     * 判断缓存是否已过期
     *
     * @return true 表示已过期
     */
    public boolean isExpired() {
        return expireAt != null && System.currentTimeMillis() > expireAt;
    }

    /**
     * 获取剩余存活时间（毫秒）
     *
     * @return 剩余时间，-1 表示永不过期，-2 表示已过期
     */
    public long getTtlMillis() {
        if (expireAt == null) {
            return -1;
        }
        long ttl = expireAt - System.currentTimeMillis();
        return ttl > 0 ? ttl : -2;
    }

    /**
     * 获取剩余存活时间（秒）
     *
     * @return 剩余时间（秒）
     */
    public long getTtlSeconds() {
        long ttlMillis = getTtlMillis();
        if (ttlMillis < 0) {
            return ttlMillis;
        }
        return ttlMillis / 1000;
    }

    /**
     * 更新过期时间
     *
     * @param expireAtMillis 新的过期时间戳（毫秒）
     */
    public void updateExpireAt(long expireAtMillis) {
        this.expireAt = expireAtMillis;
    }

    /**
     * 延长过期时间
     *
     * @param additionalMillis 延长的时间（毫秒）
     */
    public void extendExpireTime(long additionalMillis) {
        if (expireAt != null) {
            this.expireAt = expireAt + additionalMillis;
        }
    }
}

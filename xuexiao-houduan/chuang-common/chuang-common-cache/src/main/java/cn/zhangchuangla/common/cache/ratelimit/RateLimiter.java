package cn.zhangchuangla.common.cache.ratelimit;

/**
 * 限流器接口
 * 定义限流的统一操作方法
 *
 * @author Chuang
 */
public interface RateLimiter {

    /**
     * 尝试获取许可
     *
     * @param key           限流 key
     * @param maxCount      限制次数
     * @param windowSeconds 时间窗口（秒）
     * @return true 表示允许访问，false 表示被限流
     */
    boolean tryAcquire(String key, int maxCount, int windowSeconds);

    /**
     * 获取当前访问次数
     *
     * @param key 限流 key
     * @return 当前访问次数
     */
    long getCurrentCount(String key);

    /**
     * 重置限流计数
     *
     * @param key 限流 key
     */
    void reset(String key);
}

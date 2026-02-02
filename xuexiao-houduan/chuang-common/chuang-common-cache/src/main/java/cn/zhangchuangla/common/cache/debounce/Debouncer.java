package cn.zhangchuangla.common.cache.debounce;

/**
 * 防抖器接口
 * 定义防抖的统一操作方法
 *
 * @author Chuang
 */
public interface Debouncer {

    /**
     * 尝试获取许可（防抖检查）
     *
     * @param key          防抖 key
     * @param windowMillis 防抖时间窗口（毫秒）
     * @return true 表示允许执行，false 表示被防抖拒绝
     */
    boolean tryAcquire(String key, long windowMillis);

    /**
     * 释放防抖锁
     *
     * @param key 防抖 key
     */
    void release(String key);

    /**
     * 检查是否在防抖窗口内
     *
     * @param key 防抖 key
     * @return true 表示在防抖窗口内
     */
    boolean isLocked(String key);
}

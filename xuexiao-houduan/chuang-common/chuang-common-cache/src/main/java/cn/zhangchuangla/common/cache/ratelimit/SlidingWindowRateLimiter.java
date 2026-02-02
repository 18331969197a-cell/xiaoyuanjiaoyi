package cn.zhangchuangla.common.cache.ratelimit;

import cn.zhangchuangla.common.cache.core.CacheProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 基于滑动窗口算法的本地限流器实现
 *
 * @author Chuang
 */
@Slf4j
@RequiredArgsConstructor
public class SlidingWindowRateLimiter implements RateLimiter {

    private final CacheProvider cacheProvider;

    /**
     * 存储每个 key 的请求时间戳列表
     * key -> WindowData
     */
    private final ConcurrentHashMap<String, WindowData> windowDataMap = new ConcurrentHashMap<>();

    @Override
    public boolean tryAcquire(String key, int maxCount, int windowSeconds) {
        try {
            long now = System.currentTimeMillis();
            long windowStart = now - windowSeconds * 1000L;

            WindowData windowData = windowDataMap.computeIfAbsent(key, k -> new WindowData());

            synchronized (windowData) {
                // 清理窗口外的请求记录
                windowData.cleanExpired(windowStart);

                // 检查是否超过限制
                if (windowData.getCount() >= maxCount) {
                    log.debug("限流触发 - key: {}, 当前计数: {}, 限制: {}", key, windowData.getCount(), maxCount);
                    return false;
                }

                // 添加当前请求
                windowData.addRequest(now);
                return true;
            }
        } catch (Exception e) {
            log.error("限流判断失败, key: {}", key, e);
            // 限流失败时放行，避免影响正常业务
            return true;
        }
    }

    @Override
    public long getCurrentCount(String key) {
        WindowData windowData = windowDataMap.get(key);
        if (windowData == null) {
            return 0;
        }
        return windowData.getCount();
    }

    @Override
    public void reset(String key) {
        windowDataMap.remove(key);
    }

    /**
     * 滑动窗口数据
     */
    private static class WindowData {
        /**
         * 请求时间戳列表（使用简单的数组实现环形缓冲区）
         */
        private final long[] timestamps = new long[10000];
        private int head = 0;
        private int tail = 0;
        private final AtomicLong count = new AtomicLong(0);

        public void addRequest(long timestamp) {
            timestamps[tail] = timestamp;
            tail = (tail + 1) % timestamps.length;
            if (tail == head) {
                // 缓冲区满了，移动 head
                head = (head + 1) % timestamps.length;
            } else {
                count.incrementAndGet();
            }
        }

        public void cleanExpired(long windowStart) {
            while (head != tail && timestamps[head] < windowStart) {
                head = (head + 1) % timestamps.length;
                count.decrementAndGet();
            }
        }

        public long getCount() {
            return count.get();
        }
    }
}

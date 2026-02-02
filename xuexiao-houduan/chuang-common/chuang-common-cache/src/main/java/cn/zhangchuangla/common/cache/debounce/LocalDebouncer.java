package cn.zhangchuangla.common.cache.debounce;

import cn.zhangchuangla.common.cache.core.CacheProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.TimeUnit;

/**
 * 基于本地缓存的防抖器实现
 *
 * @author Chuang
 */
@Slf4j
@RequiredArgsConstructor
public class LocalDebouncer implements Debouncer {

    private static final String DEBOUNCE_PREFIX = "debounce:";
    private static final String LOCK_VALUE = "1";

    private final CacheProvider cacheProvider;

    @Override
    public boolean tryAcquire(String key, long windowMillis) {
        try {
            String cacheKey = DEBOUNCE_PREFIX + key;
            // 使用 setIfAbsent 实现原子性的防抖检查
            boolean acquired = cacheProvider.setIfAbsent(cacheKey, LOCK_VALUE, windowMillis, TimeUnit.MILLISECONDS);
            if (!acquired) {
                log.debug("防抖拒绝 - key: {}, 窗口: {}ms", key, windowMillis);
            }
            return acquired;
        } catch (Exception e) {
            log.error("防抖检查失败, key: {}", key, e);
            // 防抖失败时放行，避免影响正常业务
            return true;
        }
    }

    @Override
    public void release(String key) {
        try {
            String cacheKey = DEBOUNCE_PREFIX + key;
            cacheProvider.delete(cacheKey);
        } catch (Exception e) {
            log.error("释放防抖锁失败, key: {}", key, e);
        }
    }

    @Override
    public boolean isLocked(String key) {
        try {
            String cacheKey = DEBOUNCE_PREFIX + key;
            return cacheProvider.exists(cacheKey);
        } catch (Exception e) {
            log.error("检查防抖状态失败, key: {}", key, e);
            return false;
        }
    }
}

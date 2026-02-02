package cn.zhangchuangla.common.cache.security;

import cn.zhangchuangla.common.cache.core.CacheProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.TimeUnit;

/**
 * 基于本地缓存的密码重试存储实现
 *
 * @author Chuang
 */
@Slf4j
@RequiredArgsConstructor
public class LocalPasswordRetryStore implements PasswordRetryStore {

    private static final String RETRY_COUNT_PREFIX = "auth:password:retry:";
    private static final String LOCK_PREFIX = "auth:password:lock:";
    private static final long DEFAULT_RETRY_EXPIRE_SECONDS = 3600; // 1小时

    private final CacheProvider cacheProvider;

    @Override
    public int incrementRetryCount(String username) {
        String key = RETRY_COUNT_PREFIX + username;
        Integer count = cacheProvider.get(key);
        int newCount = (count == null ? 0 : count) + 1;
        cacheProvider.set(key, newCount, DEFAULT_RETRY_EXPIRE_SECONDS, TimeUnit.SECONDS);
        return newCount;
    }

    @Override
    public int getRetryCount(String username) {
        String key = RETRY_COUNT_PREFIX + username;
        Integer count = cacheProvider.get(key);
        return count == null ? 0 : count;
    }

    @Override
    public void clearRetryCount(String username) {
        String key = RETRY_COUNT_PREFIX + username;
        cacheProvider.delete(key);
    }

    @Override
    public void lockAccount(String username, long lockSeconds) {
        String key = LOCK_PREFIX + username;
        cacheProvider.set(key, System.currentTimeMillis(), lockSeconds, TimeUnit.SECONDS);
        log.info("账户已锁定 - 用户名: {}, 锁定时间: {}秒", username, lockSeconds);
    }

    @Override
    public boolean isAccountLocked(String username) {
        String key = LOCK_PREFIX + username;
        return cacheProvider.exists(key);
    }

    @Override
    public void unlockAccount(String username) {
        String key = LOCK_PREFIX + username;
        cacheProvider.delete(key);
        // 同时清除重试计数
        clearRetryCount(username);
        log.info("账户已解锁 - 用户名: {}", username);
    }

    @Override
    public long getLockRemainingSeconds(String username) {
        String key = LOCK_PREFIX + username;
        Long expire = cacheProvider.getExpire(key);
        return expire == null || expire <= 0 ? 0 : expire;
    }
}

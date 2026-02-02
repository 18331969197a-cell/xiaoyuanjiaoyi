package cn.zhangchuangla.common.cache.security;

import cn.zhangchuangla.common.cache.core.CacheProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.TimeUnit;

/**
 * 基于本地缓存的登录频率存储实现
 * 用于统计成功登录次数，防止频繁登录攻击
 *
 * @author Chuang
 */
@Slf4j
@RequiredArgsConstructor
public class LocalLoginFrequencyStore implements LoginFrequencyStore {

    private static final String HOURLY_SUCCESS_PREFIX = "auth:login:frequency:success:hour:";
    private static final String DAILY_SUCCESS_PREFIX = "auth:login:frequency:success:day:";

    private final CacheProvider cacheProvider;

    @Override
    public void incrementHourlySuccessCount(String username, long expireSeconds) {
        String key = HOURLY_SUCCESS_PREFIX + username;
        Integer count = cacheProvider.get(key);
        int newCount = (count == null ? 0 : count) + 1;
        cacheProvider.set(key, newCount, expireSeconds, TimeUnit.SECONDS);
    }

    @Override
    public void incrementDailySuccessCount(String username, long expireSeconds) {
        String key = DAILY_SUCCESS_PREFIX + username;
        Integer count = cacheProvider.get(key);
        int newCount = (count == null ? 0 : count) + 1;
        cacheProvider.set(key, newCount, expireSeconds, TimeUnit.SECONDS);
    }

    @Override
    public int getHourlySuccessCount(String username) {
        String key = HOURLY_SUCCESS_PREFIX + username;
        Integer count = cacheProvider.get(key);
        return count == null ? 0 : count;
    }

    @Override
    public int getDailySuccessCount(String username) {
        String key = DAILY_SUCCESS_PREFIX + username;
        Integer count = cacheProvider.get(key);
        return count == null ? 0 : count;
    }

    @Override
    public long getHourlyExpireSeconds(String username) {
        String key = HOURLY_SUCCESS_PREFIX + username;
        Long expire = cacheProvider.getExpire(key);
        return expire == null ? -1 : expire;
    }

    @Override
    public long getDailyExpireSeconds(String username) {
        String key = DAILY_SUCCESS_PREFIX + username;
        Long expire = cacheProvider.getExpire(key);
        return expire == null ? -1 : expire;
    }

    @Override
    public boolean isHourlyLimited(String username, int limit) {
        return getHourlySuccessCount(username) >= limit;
    }

    @Override
    public boolean isDailyLimited(String username, int limit) {
        return getDailySuccessCount(username) >= limit;
    }
}

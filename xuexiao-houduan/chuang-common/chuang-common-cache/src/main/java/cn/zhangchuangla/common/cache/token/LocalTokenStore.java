package cn.zhangchuangla.common.cache.token;

import cn.zhangchuangla.common.cache.constant.CacheConstants;
import cn.zhangchuangla.common.cache.core.CacheProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.TimeUnit;

/**
 * 基于本地缓存的 Token 存储实现
 *
 * @author Chuang
 * @param <T> 在线用户信息类型
 */
@Slf4j
@RequiredArgsConstructor
public class LocalTokenStore<T> implements TokenStore<T> {

    private final CacheProvider cacheProvider;

    /**
     * 访问令牌过期时间（秒）- 默认 2 小时
     */
    private long accessTokenExpireSeconds = 7200;

    /**
     * 刷新令牌过期时间（秒）- 默认 30 天
     */
    private long refreshTokenExpireSeconds = 2592000;

    /**
     * 设置访问令牌过期时间
     */
    public void setAccessTokenExpireSeconds(long seconds) {
        this.accessTokenExpireSeconds = seconds;
    }

    /**
     * 设置刷新令牌过期时间
     */
    public void setRefreshTokenExpireSeconds(long seconds) {
        this.refreshTokenExpireSeconds = seconds;
    }

    @Override
    public void setAccessToken(String accessTokenId, T onlineUser) {
        String key = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        cacheProvider.set(key, onlineUser, accessTokenExpireSeconds, TimeUnit.SECONDS);
    }

    @Override
    public void setRefreshToken(String refreshTokenId, String accessTokenId) {
        String key = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        cacheProvider.set(key, accessTokenId, refreshTokenExpireSeconds, TimeUnit.SECONDS);
    }

    @Override
    @SuppressWarnings("unchecked")
    public T getAccessToken(String accessTokenId) {
        String key = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        return cacheProvider.get(key);
    }

    @Override
    public String getRefreshToken(String refreshTokenId) {
        String key = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        return cacheProvider.get(key);
    }

    @Override
    public void deleteAccessToken(String accessTokenId) {
        String key = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        cacheProvider.delete(key);
    }

    @Override
    public void deleteRefreshToken(String refreshTokenId) {
        String key = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        cacheProvider.delete(key);
    }

    @Override
    public void deleteRefreshTokenAndAccessToken(String refreshTokenId) {
        String refreshKey = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        // 获取关联的访问令牌
        String accessTokenId = cacheProvider.get(refreshKey);
        if (accessTokenId != null) {
            String accessKey = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
            cacheProvider.delete(accessKey);
        }
        cacheProvider.delete(refreshKey);
    }

    @Override
    public boolean isValidAccessToken(String accessTokenId) {
        String key = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        return cacheProvider.exists(key);
    }

    @Override
    public boolean isValidRefreshToken(String refreshTokenId) {
        String key = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        return cacheProvider.exists(key);
    }

    @Override
    @SuppressWarnings("unchecked")
    public String getRefreshTokenIdByAccessTokenId(String accessTokenId) {
        String key = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        Object onlineUser = cacheProvider.get(key);
        if (onlineUser == null) {
            return null;
        }
        // 通过反射获取 refreshTokenId 字段
        try {
            java.lang.reflect.Method method = onlineUser.getClass().getMethod("getRefreshTokenId");
            return (String) method.invoke(onlineUser);
        } catch (Exception e) {
            log.error("获取 refreshTokenId 失败", e);
            return null;
        }
    }

    @Override
    public void mapRefreshTokenToAccessToken(String refreshTokenId, String newAccessTokenId) {
        String refreshKey = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        
        // 验证刷新令牌存在
        if (!cacheProvider.exists(refreshKey)) {
            throw new IllegalStateException("刷新令牌不存在或已过期");
        }

        // 获取旧的访问令牌
        String oldAccessTokenId = cacheProvider.get(refreshKey);
        if (oldAccessTokenId != null) {
            // 删除旧的访问令牌
            String oldAccessKey = CacheConstants.Auth.USER_ACCESS_TOKEN + oldAccessTokenId;
            cacheProvider.delete(oldAccessKey);
        }

        // 获取剩余过期时间
        Long ttlSeconds = cacheProvider.getExpire(refreshKey);
        if (ttlSeconds == null || ttlSeconds <= 0) {
            throw new IllegalStateException("刷新令牌已过期");
        }

        // 更新刷新令牌映射到新的访问令牌
        cacheProvider.set(refreshKey, newAccessTokenId, ttlSeconds, TimeUnit.SECONDS);
    }

    @Override
    @SuppressWarnings("unchecked")
    public boolean updateAccessTime(String accessTokenId) {
        String key = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        Object onlineUser = cacheProvider.get(key);
        
        if (onlineUser == null) {
            log.warn("尝试更新访问时间时，令牌不存在: {}", accessTokenId);
            return false;
        }

        Long expire = cacheProvider.getExpire(key);
        if (expire == null || expire <= 0) {
            log.warn("尝试更新访问时间时，令牌已过期: {}", accessTokenId);
            return false;
        }

        // 通过反射设置 accessTime 字段
        try {
            java.lang.reflect.Method method = onlineUser.getClass().getMethod("setAccessTime", Long.class);
            method.invoke(onlineUser, System.currentTimeMillis());
            cacheProvider.set(key, onlineUser, expire, TimeUnit.SECONDS);
            return true;
        } catch (Exception e) {
            log.error("更新访问时间失败", e);
            return false;
        }
    }
}

package cn.zhangchuangla.framework.security.token;

import cn.zhangchuangla.common.cache.constant.CacheConstants;
import cn.zhangchuangla.common.cache.core.CacheProvider;
import cn.zhangchuangla.common.cache.token.TokenStore;
import cn.zhangchuangla.common.core.enums.ResultCode;
import cn.zhangchuangla.common.core.exception.AuthorizationException;
import cn.zhangchuangla.common.core.utils.Assert;
import cn.zhangchuangla.framework.model.entity.OnlineLoginUser;
import cn.zhangchuangla.framework.security.property.SecurityProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * Token 存储操作（使用本地缓存）
 * 实现 TokenStore 接口，提供 Token 存储的统一操作
 *
 * @author Chuang
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class CacheTokenStore implements TokenStore<OnlineLoginUser> {

    private final CacheProvider cacheProvider;
    private final SecurityProperties securityProperties;

    @Override
    public void setAccessToken(String accessTokenId, OnlineLoginUser onlineLoginUser) {
        String accessTokenKey = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        cacheProvider.set(accessTokenKey, onlineLoginUser,
                securityProperties.getSession().getAccessTokenExpireTime(), TimeUnit.SECONDS);
    }

    @Override
    public void setRefreshToken(String refreshTokenId, String accessTokenId) {
        String refreshTokenKey = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        cacheProvider.set(refreshTokenKey, accessTokenId,
                securityProperties.getSession().getRefreshTokenExpireTime(), TimeUnit.SECONDS);
    }

    @Override
    public OnlineLoginUser getAccessToken(String accessTokenId) {
        String accessTokenKey = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        return cacheProvider.get(accessTokenKey);
    }

    @Override
    public String getRefreshToken(String refreshTokenId) {
        String refreshTokenKey = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        return cacheProvider.get(refreshTokenKey);
    }

    @Override
    public void deleteAccessToken(String accessTokenId) {
        String accessTokenKey = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        cacheProvider.delete(accessTokenKey);
    }

    @Override
    public void deleteRefreshToken(String refreshTokenId) {
        String refreshTokenKey = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        cacheProvider.delete(refreshTokenKey);
    }

    @Override
    public void deleteRefreshTokenAndAccessToken(String refreshTokenId) {
        String refreshTokenKey = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        // 删除关联的访问令牌
        String accessToken = cacheProvider.get(refreshTokenKey);
        if (accessToken != null) {
            String accessTokenKey = CacheConstants.Auth.USER_ACCESS_TOKEN + accessToken;
            cacheProvider.delete(accessTokenKey);
        }
        cacheProvider.delete(refreshTokenKey);
    }

    @Override
    public boolean isValidAccessToken(String accessTokenId) {
        return cacheProvider.exists(CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId);
    }

    @Override
    public boolean isValidRefreshToken(String refreshTokenId) {
        return cacheProvider.exists(CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId);
    }

    @Override
    public String getRefreshTokenIdByAccessTokenId(String accessTokenId) {
        Assert.hasText(accessTokenId, "访问令牌ID不能为空!");
        String accessTokenKey = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        OnlineLoginUser onlineLoginUser = cacheProvider.get(accessTokenKey);
        Assert.notNull(onlineLoginUser, "访问令牌不存在!");
        return onlineLoginUser.getRefreshTokenId();
    }

    @Override
    public void mapRefreshTokenToAccessToken(String refreshTokenId, String newAccessToken) {
        String refreshKey = CacheConstants.Auth.USER_REFRESH_TOKEN + refreshTokenId;
        // 1. 验证 refreshKey 存在
        if (!cacheProvider.exists(refreshKey)) {
            throw new AuthorizationException(ResultCode.REFRESH_TOKEN_INVALID);
        }

        // 2. 取出旧的 accessToken
        String oldAccessToken = cacheProvider.get(refreshKey);
        if (oldAccessToken == null) {
            throw new AuthorizationException(ResultCode.REFRESH_TOKEN_INVALID);
        }

        // 3. 拿到剩余 TTL
        Long ttlSeconds = cacheProvider.getExpire(refreshKey);
        if (ttlSeconds == null || ttlSeconds <= 0) {
            throw new AuthorizationException(ResultCode.REFRESH_TOKEN_INVALID);
        }

        // 4. 删除旧的双向映射
        String oldAccessKey = CacheConstants.Auth.USER_ACCESS_TOKEN + oldAccessToken;
        if (cacheProvider.exists(oldAccessKey)) {
            cacheProvider.delete(oldAccessKey);
        }
        // a) refresh → access
        cacheProvider.set(refreshKey, newAccessToken, ttlSeconds, TimeUnit.SECONDS);
    }

    @Override
    public boolean updateAccessTime(String accessTokenId) {
        String accessTokenKey = CacheConstants.Auth.USER_ACCESS_TOKEN + accessTokenId;
        OnlineLoginUser onlineLoginUser = cacheProvider.get(accessTokenKey);

        // 检查令牌是否存在
        if (onlineLoginUser == null) {
            log.warn("尝试更新访问时间时，令牌不存在: {}", accessTokenId);
            return false;
        }

        Long expire = cacheProvider.getExpire(accessTokenKey);
        if (expire == null || expire <= 0) {
            log.warn("尝试更新访问时间时，令牌已过期: {}", accessTokenId);
            return false;
        }

        onlineLoginUser.setAccessTime(System.currentTimeMillis());
        cacheProvider.set(accessTokenKey, onlineLoginUser, expire, TimeUnit.SECONDS);
        return true;
    }
}

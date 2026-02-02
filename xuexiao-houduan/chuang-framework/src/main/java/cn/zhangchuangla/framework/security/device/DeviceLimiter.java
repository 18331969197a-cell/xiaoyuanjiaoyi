package cn.zhangchuangla.framework.security.device;

import cn.zhangchuangla.common.cache.constant.CacheConstants;
import cn.zhangchuangla.common.cache.core.CacheProvider;
import cn.zhangchuangla.common.cache.core.HashCacheProvider;
import cn.zhangchuangla.common.cache.core.ZSetCacheProvider;
import cn.zhangchuangla.common.core.constant.SecurityConstants;
import cn.zhangchuangla.common.core.enums.DeviceType;
import cn.zhangchuangla.common.core.enums.ResultCode;
import cn.zhangchuangla.common.core.exception.AuthorizationException;
import cn.zhangchuangla.framework.model.dto.LoginDeviceDTO;
import cn.zhangchuangla.framework.security.property.SecurityProperties;
import cn.zhangchuangla.framework.security.token.CacheTokenStore;
import jakarta.validation.constraints.NotEmpty;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 登录数量限制
 *
 * @author Chuang
 * <p>
 * created on 2025/7/24 22:06
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DeviceLimiter {

    // 用户级别的锁，确保同一用户的设备信息操作是线程安全的
    private final ConcurrentHashMap<String, ReentrantLock> userLocks = new ConcurrentHashMap<>();
    private final CacheProvider cacheProvider;
    private final HashCacheProvider hashCacheProvider;
    private final ZSetCacheProvider zSetCacheProvider;
    private final SecurityProperties securityProperties;
    private final CacheTokenStore cacheTokenStore;

    /**
     * 获取用户对应的锁
     *
     * @param username 用户名
     * @return 用户对应的锁
     */
    private ReentrantLock getUserLock(String username) {
        return userLocks.computeIfAbsent(username, k -> new ReentrantLock());
    }


    /**
     * 检查登录设备数量限制并添加设备信息（原子操作）
     *
     * @param loginDeviceDTO 登录设备信息
     */
    public void checkLimitAndAddSession(@Validated LoginDeviceDTO loginDeviceDTO) {
        checkLimitAndAddSession(loginDeviceDTO, true);
    }

    /**
     * 检查登录设备数量限制并添加设备信息（原子操作）
     *
     * @param loginDeviceDTO 登录设备信息
     * @param needLock       是否需要加锁，true-加锁，false-不加锁
     */
    public void checkLimitAndAddSession(@Validated LoginDeviceDTO loginDeviceDTO, boolean needLock) {
        if (needLock) {
            ReentrantLock lock = getUserLock(loginDeviceDTO.getUsername());
            lock.lock();
            try {
                handelCheckLimitAndAddSession(loginDeviceDTO);
            } finally {
                lock.unlock();
            }
        } else {
            handelCheckLimitAndAddSession(loginDeviceDTO);
        }
    }

    /**
     * 执行检查限制和添加设备信息的核心逻辑
     *
     * @param loginDeviceDTO 登录设备信息
     */
    private void handelCheckLimitAndAddSession(@NotNull LoginDeviceDTO loginDeviceDTO) {
        // 先清理过期的设备信息
        cleanOldIndex(loginDeviceDTO.getUsername());

        // 检查是否允许多设备登录
        if (!securityProperties.getSession().isMultiDevice()) {
            // 单设备登录模式：清除用户所有现有会话
            clearAllUserSessions(loginDeviceDTO.getUsername());
            log.info("用户 {} 单设备登录模式，已清除所有现有会话", loginDeviceDTO.getUsername());
        } else {
            // 多设备登录模式：检查设备数量限制
            long limit = getLimit(loginDeviceDTO.getDeviceType());
            if (limit == 0) {
                throw new AuthorizationException(ResultCode.LOGIN_ERROR, String.format("暂不支持:%s 设备登录", loginDeviceDTO.getDeviceType()));
            }

            if (limit > 0) {
                // 统计当前设备数量
                long currentCount = countCurrentSessions(loginDeviceDTO.getUsername(), loginDeviceDTO.getDeviceType());
                if (currentCount >= limit) {
                    clearEarliestSession(loginDeviceDTO.getUsername());
                }
            }
        }

        // 检查通过后，立即添加设备信息
        addSessionInternal(loginDeviceDTO);
    }

    /**
     * 清除用户所有会话（单设备登录模式使用）
     *
     * @param username 用户名
     */
    private void clearAllUserSessions(String username) {
        String deviceIndexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        Set<ZSetCacheProvider.ScoredValue<String>> allDeviceIndexSet = zSetCacheProvider.zRangeWithScores(deviceIndexKey, 0, -1);

        if (allDeviceIndexSet != null && !allDeviceIndexSet.isEmpty()) {
            allDeviceIndexSet.forEach(scoredValue -> {
                String refreshTokenId = scoredValue.getValue();
                String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;

                if (refreshTokenId != null) {
                    // 删除刷新令牌和访问令牌
                    cacheTokenStore.deleteRefreshTokenAndAccessToken(refreshTokenId);
                    // 删除设备数据
                    cacheProvider.delete(deviceKey);
                }
            });

            // 清空索引
            cacheProvider.delete(deviceIndexKey);
            log.info("用户 {} 所有会话已清除，共清除 {} 个会话", username, allDeviceIndexSet.size());
        }
    }

    /**
     * 清除当前用户设备中最早的设备信息
     *
     * @param username 用户名
     */
    private void clearEarliestSession(String username) {
        String deviceIndexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        Set<ZSetCacheProvider.ScoredValue<String>> allDeviceIndexSet = zSetCacheProvider.zRangeWithScores(deviceIndexKey, 0, -1);

        if (allDeviceIndexSet != null && !allDeviceIndexSet.isEmpty()) {
            Optional<ZSetCacheProvider.ScoredValue<String>> earliestSession = allDeviceIndexSet.stream()
                    .min(Comparator.comparing(
                            ZSetCacheProvider.ScoredValue::getScore,
                            Comparator.nullsLast(Double::compareTo)
                    ));

            earliestSession.ifPresent(scoredValue -> {
                String refreshTokenId = scoredValue.getValue();
                Double score = scoredValue.getScore();
                String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;
                if (refreshTokenId != null && score != null) {
                    // 1.删除刷新令牌和访问令牌
                    cacheTokenStore.deleteRefreshTokenAndAccessToken(refreshTokenId);
                    // 2.删除设备的数据
                    cacheProvider.delete(deviceKey);
                    // 3.删除索引
                    zSetCacheProvider.zRemove(deviceIndexKey, refreshTokenId);
                }
            });
        }
    }


    /**
     * 清理旧索引
     *
     * @param username 用户名
     */
    public void cleanOldIndex(@NotEmpty String username) {
        long now = System.currentTimeMillis();
        long refreshTokenExpireTime = securityProperties.getSession().getRefreshTokenExpireTime();
        String deviceIndexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        // 删除旧数据
        Set<ZSetCacheProvider.ScoredValue<String>> allDeviceSet = zSetCacheProvider.zRangeWithScores(deviceIndexKey, 0, -1);
        // 转换为毫秒
        long needDeleteValue = now - refreshTokenExpireTime * 1000;
        if (allDeviceSet != null) {
            allDeviceSet.forEach(scoredValue -> {
                Double score = scoredValue.getScore();
                if (score != null && score <= needDeleteValue) {
                    String refreshTokenId = scoredValue.getValue();
                    String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;
                    // 同步删除对应的令牌，避免残留无索引的会话
                    try {
                        cacheTokenStore.deleteRefreshTokenAndAccessToken(refreshTokenId);
                    } catch (Exception ignore) {
                        // 容错：令牌可能已被删除
                    }
                    // 删除设备数据与索引
                    cacheProvider.delete(deviceKey);
                    zSetCacheProvider.zRemove(deviceIndexKey, refreshTokenId);
                }
            });
        }
    }

    /**
     * 统计当前有效设备信息数量
     *
     * @param username   用户名
     * @param deviceType 设备类型
     * @return 当前有效设备信息数量
     */
    private long countCurrentSessions(String username, String deviceType) {
        String deviceIndexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        Set<ZSetCacheProvider.ScoredValue<String>> allDeviceSet = zSetCacheProvider.zRangeWithScores(deviceIndexKey, 0, -1);
        AtomicLong count = new AtomicLong();
        // 转换为毫秒
        long effectiveTime = System.currentTimeMillis() - securityProperties.getSession().getRefreshTokenExpireTime() * 1000;
        if (allDeviceSet != null) {
            allDeviceSet.forEach(scoredValue -> {
                Double score = scoredValue.getScore();
                if (score != null && score >= effectiveTime) {
                    String refreshTokenId = scoredValue.getValue();
                    String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;
                    Map<String, String> deviceInfo = hashCacheProvider.hGetAll(deviceKey);
                    if (!deviceInfo.isEmpty()) {
                        String loginDeviceType = deviceInfo.get(SecurityConstants.DEVICE_TYPE);
                        if (deviceType.equals(loginDeviceType)) {
                            count.getAndIncrement();
                        }
                    } else {
                        // 如果设备信息为空，则删除索引
                        zSetCacheProvider.zRemove(deviceIndexKey, refreshTokenId);
                    }
                }
            });
        }

        return count.get();
    }

    /**
     * 获取登录数量限制
     *
     * @param deviceType 设备类型
     * @return 登录数量限制
     */
    private long getLimit(String deviceType) {
        SecurityProperties.SessionConfig.MaxSessionsPerClient maxSessionsPerClient = securityProperties.getSession().getMaxSessionsPerClient();
        Map<String, Long> limits = Map.of(
                DeviceType.PC.getValue(), maxSessionsPerClient.getPc(),
                DeviceType.MOBILE.getValue(), maxSessionsPerClient.getMobile(),
                DeviceType.WEB.getValue(), maxSessionsPerClient.getWeb(),
                DeviceType.MINI_PROGRAM.getValue(), maxSessionsPerClient.getMiniProgram(),
                DeviceType.UNKNOWN.getValue(), maxSessionsPerClient.getUnknown()
        );
        return limits.getOrDefault(deviceType, maxSessionsPerClient.getUnknown());
    }

    /**
     * 内部添加设备信息方法（不加锁，由调用方保证线程安全）
     *
     * @param loginDeviceDTO 登录设备信息
     */
    private void addSessionInternal(@NotNull LoginDeviceDTO loginDeviceDTO) {
        long now = System.currentTimeMillis();
        long refreshTokenExpireTime = securityProperties.getSession().getRefreshTokenExpireTime();

        Map<String, String> deviceInfo = Map.of(
                SecurityConstants.DEVICE_TYPE, loginDeviceDTO.getDeviceType(),
                SecurityConstants.DEVICE_NAME, loginDeviceDTO.getDeviceName(),
                SecurityConstants.LOGIN_TIME, String.valueOf(now),
                SecurityConstants.LOCATION, loginDeviceDTO.getLocation(),
                SecurityConstants.IP, loginDeviceDTO.getIp(),
                SecurityConstants.USER_ID, String.valueOf(loginDeviceDTO.getUserId()),
                SecurityConstants.USER_NAME, loginDeviceDTO.getUsername(),
                SecurityConstants.REFRESH_TOKEN_ID, loginDeviceDTO.getRefreshSessionId()
        );
        String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + loginDeviceDTO.getRefreshSessionId();
        hashCacheProvider.hPutAll(deviceKey, deviceInfo);
        // 设置设备信息有效期
        cacheProvider.expire(deviceKey, refreshTokenExpireTime, TimeUnit.SECONDS);
        // 写入ZSet索引
        String deviceIndexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + loginDeviceDTO.getUsername();
        zSetCacheProvider.zAdd(deviceIndexKey, loginDeviceDTO.getRefreshSessionId(), now);
        cacheProvider.expire(deviceIndexKey, refreshTokenExpireTime, TimeUnit.SECONDS);
    }
}

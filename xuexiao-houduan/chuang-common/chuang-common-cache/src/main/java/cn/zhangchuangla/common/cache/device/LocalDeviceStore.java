package cn.zhangchuangla.common.cache.device;

import cn.zhangchuangla.common.cache.constant.CacheConstants;
import cn.zhangchuangla.common.cache.core.CacheProvider;
import cn.zhangchuangla.common.cache.core.HashCacheProvider;
import cn.zhangchuangla.common.cache.core.ZSetCacheProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * 基于本地缓存的设备存储实现
 *
 * @author Chuang
 */
@Slf4j
@RequiredArgsConstructor
public class LocalDeviceStore implements DeviceStore {

    private final CacheProvider cacheProvider;
    private final HashCacheProvider hashCacheProvider;
    private final ZSetCacheProvider zSetCacheProvider;

    @Override
    public void saveDevice(String refreshTokenId, Map<String, Object> deviceInfo, long loginTime, long expireSeconds) {
        String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;
        
        // 保存设备详细信息到 Hash
        for (Map.Entry<String, Object> entry : deviceInfo.entrySet()) {
            hashCacheProvider.hPut(deviceKey, entry.getKey(), entry.getValue());
        }
        
        // 设置过期时间
        hashCacheProvider.expire(deviceKey, expireSeconds, TimeUnit.SECONDS);
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map<String, Object> getDevice(String refreshTokenId) {
        String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;
        Map<String, Object> result = hashCacheProvider.hGetAll(deviceKey);
        return result != null ? result : new HashMap<>();
    }

    @Override
    public boolean deleteDevice(String refreshTokenId) {
        String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;
        return cacheProvider.delete(deviceKey);
    }

    @Override
    public Map<String, Long> getDevicesByUser(String username) {
        String indexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        Map<Object, Double> allWithScores = zSetCacheProvider.zGetAllWithScores(indexKey);
        
        Map<String, Long> result = new LinkedHashMap<>();
        if (allWithScores != null) {
            for (Map.Entry<Object, Double> entry : allWithScores.entrySet()) {
                String refreshTokenId = String.valueOf(entry.getKey());
                Long loginTime = entry.getValue() != null ? entry.getValue().longValue() : 0L;
                result.put(refreshTokenId, loginTime);
            }
        }
        return result;
    }

    @Override
    public long countDevicesByUser(String username) {
        String indexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        Long count = zSetCacheProvider.zCard(indexKey);
        return count != null ? count : 0L;
    }

    @Override
    public void addDeviceToUserIndex(String username, String refreshTokenId, long loginTime, long expireSeconds) {
        String indexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        zSetCacheProvider.zAdd(indexKey, refreshTokenId, (double) loginTime, expireSeconds, TimeUnit.SECONDS);
    }

    @Override
    public void removeDeviceFromUserIndex(String username, String refreshTokenId) {
        String indexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        zSetCacheProvider.zRemove(indexKey, refreshTokenId);
    }

    @Override
    public String getOldestDevice(String username) {
        String indexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        // 获取分数最小的元素（最早登录的设备）
        Set<Object> oldest = zSetCacheProvider.zRange(indexKey, 0, 0);
        if (oldest != null && !oldest.isEmpty()) {
            return String.valueOf(oldest.iterator().next());
        }
        return null;
    }

    @Override
    public long deleteAllDevicesByUser(String username) {
        String indexKey = CacheConstants.Auth.SESSIONS_INDEX_KEY + username;
        
        // 获取所有设备
        Map<String, Long> devices = getDevicesByUser(username);
        long count = 0;
        
        // 删除每个设备的详细信息
        for (String refreshTokenId : devices.keySet()) {
            if (deleteDevice(refreshTokenId)) {
                count++;
            }
        }
        
        // 删除用户设备索引
        cacheProvider.delete(indexKey);
        
        return count;
    }

    @Override
    public List<String> getAllUserDeviceIndexKeys() {
        String pattern = CacheConstants.Auth.SESSIONS_INDEX_KEY + "*";
        return zSetCacheProvider.scanKeys(pattern);
    }

    @Override
    public boolean deviceExists(String refreshTokenId) {
        String deviceKey = CacheConstants.Auth.SESSIONS_DEVICE_KEY + refreshTokenId;
        return cacheProvider.exists(deviceKey);
    }
}

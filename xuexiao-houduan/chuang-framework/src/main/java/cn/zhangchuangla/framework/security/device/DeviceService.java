package cn.zhangchuangla.framework.security.device;

import cn.zhangchuangla.common.cache.device.DeviceStore;
import cn.zhangchuangla.common.cache.token.TokenStore;
import cn.zhangchuangla.common.core.constant.SecurityConstants;
import cn.zhangchuangla.common.core.entity.base.PageResult;
import cn.zhangchuangla.common.core.entity.security.SysUser;
import cn.zhangchuangla.common.core.enums.DeviceType;
import cn.zhangchuangla.common.core.enums.ResultCode;
import cn.zhangchuangla.common.core.exception.AccessDeniedException;
import cn.zhangchuangla.common.core.exception.ServiceException;
import cn.zhangchuangla.common.core.utils.Assert;
import cn.zhangchuangla.framework.model.entity.OnlineLoginUser;
import cn.zhangchuangla.framework.model.entity.SessionDevice;
import cn.zhangchuangla.framework.model.request.SessionDeviceQueryRequest;
import cn.zhangchuangla.system.core.service.SysUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;


/**
 * 登录设备管理服务类，提供设备会话的查询、删除和强制下线功能。
 * <p>
 * 该服务确保在删除设备信息时，自动清理相关的访问令牌和刷新令牌，以维护系统数据一致性。
 * </p>
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class DeviceService {

    private final DeviceStore deviceStore;
    private final TokenStore<OnlineLoginUser> tokenStore;
    private final SysUserService sysUserService;

    /**
     * 查询指定用户的登录设备列表
     *
     * @param username 用户名
     * @param request  查询参数
     * @return 登录设备列表
     */
    public PageResult<SessionDevice> getDeviceListByUsername(String username, SessionDeviceQueryRequest request) {
        Assert.isTrue(!username.isBlank(), "用户名不能为空");
        SysUser user = sysUserService.getUserInfoByUsername(username);
        Assert.isTrue(user != null, "用户不存在");

        Set<SessionDevice> deviceSet = new LinkedHashSet<>();
        Map<String, Long> allDevices = deviceStore.getDevicesByUser(username);

        // 获取用户设备的索引信息并转换为 SessionDevice
        allDevices.forEach((refreshTokenId, loginTime) -> {
            SessionDevice device = convertToSessionDevice(refreshTokenId, loginTime);
            if (device != null) {
                deviceSet.add(device);
            }
        });

        List<SessionDevice> sessionDevices = new ArrayList<>(deviceSet);
        return querySessionDevice(sessionDevices, request);
    }


    /**
     * 系统管理员或开发人员专用：根据刷新令牌会话ID，删除对应设备和会话。
     *
     * @param refreshTokenId 刷新令牌会话ID，不能为空
     * @return 删除是否成功
     */
    public boolean deleteDevice(String refreshTokenId) {
        Assert.hasText(refreshTokenId, "刷新令牌会话ID不能为空");

        Map<String, Object> deviceInfo = deviceStore.getDevice(refreshTokenId);
        if (deviceInfo.isEmpty()) {
            throw new ServiceException(ResultCode.RESULT_IS_NULL, "设备信息不存在!");
        }
        
        String username = (String) deviceInfo.get(SecurityConstants.USER_NAME);
        
        // 从用户索引中移除
        deviceStore.removeDeviceFromUserIndex(username, refreshTokenId);
        // 删除设备信息
        deviceStore.deleteDevice(refreshTokenId);
        // 删除对应会话
        tokenStore.deleteRefreshTokenAndAccessToken(refreshTokenId);
        
        return true;
    }

    /**
     * 终端用户专用：只能删除自己名下的设备。
     *
     * @param refreshTokenId 刷新令牌会话ID，不能为空
     * @param username       当前登录用户名，不能为空
     * @return 删除是否成功
     */
    public boolean deleteDeviceAsUser(String refreshTokenId, String username) {
        Assert.hasText(refreshTokenId, "刷新令牌会话ID不能为空");
        Assert.hasText(username, "用户名不能为空");

        if (!deviceStore.deviceExists(refreshTokenId)) {
            throw new ServiceException(ResultCode.RESULT_IS_NULL, "设备信息不存在");
        }
        
        Map<String, Object> info = deviceStore.getDevice(refreshTokenId);
        Assert.notEmpty(info, "设备信息不存在");
        
        String owner = (String) info.get(SecurityConstants.USER_NAME);
        // 只能删除自己的
        if (!username.equals(owner)) {
            throw new AccessDeniedException("您只能删除自己名下的设备");
        }

        removeDeviceSessions(refreshTokenId, username);
        return true;
    }

    /**
     * 删除设备会话
     *
     * @param refreshTokenId 刷新令牌会话ID
     * @param username       设备所属用户名，用于定位索引
     */
    private void removeDeviceSessions(String refreshTokenId, String username) {
        // 1. 从用户的 session 索引中移除这条记录
        deviceStore.removeDeviceFromUserIndex(username, refreshTokenId);

        // 2. 删除设备详情
        deviceStore.deleteDevice(refreshTokenId);

        // 3. 删除相关的刷新令牌和访问令牌
        tokenStore.deleteRefreshTokenAndAccessToken(refreshTokenId);
    }


    /**
     * 查询设备列表
     *
     * @param request 查询条件
     * @return 设备列表
     */
    public PageResult<SessionDevice> listDevice(SessionDeviceQueryRequest request) {
        // 获取所有用户的设备索引键
        List<String> indexKeys = deviceStore.getAllUserDeviceIndexKeys();

        Set<SessionDevice> deviceSet = new LinkedHashSet<>();
        for (String indexKey : indexKeys) {
            // 从索引键中提取用户名
            String username = extractUsernameFromIndexKey(indexKey);
            if (username == null) {
                continue;
            }
            
            Map<String, Long> devices = deviceStore.getDevicesByUser(username);
            for (Map.Entry<String, Long> entry : devices.entrySet()) {
                String refreshTokenId = entry.getKey();
                Long loginTime = entry.getValue();
                SessionDevice device = convertToSessionDevice(refreshTokenId, loginTime);
                if (device != null) {
                    deviceSet.add(device);
                }
            }
        }

        List<SessionDevice> sessionDevices = new ArrayList<>(deviceSet);
        return querySessionDevice(sessionDevices, request);
    }
    
    /**
     * 从索引键中提取用户名
     */
    private String extractUsernameFromIndexKey(String indexKey) {
        // 索引键格式: auth:session:index:{username}
        String prefix = "auth:session:index:";
        if (indexKey != null && indexKey.startsWith(prefix)) {
            return indexKey.substring(prefix.length());
        }
        return null;
    }


    /**
     * 查询会话设备
     *
     * @param sessionDevices 会话设备列表
     * @param request        查询参数
     * @return 查询结果
     */
    public PageResult<SessionDevice> querySessionDevice(List<SessionDevice> sessionDevices, SessionDeviceQueryRequest request) {
        // 关键字段过滤条件
        String nameKeyword = request.getDeviceName();
        DeviceType typeKeyword = request.getDeviceType();
        String ipKeyword = request.getIp();
        String locKeyword = request.getLocation();

        // 分页参数（-1 表示不分页）
        long pageNum = request.getPageNum();
        long pageSize = request.getPageSize();
        boolean noPaging = pageNum == -1 && pageSize == -1;

        // 构造过滤+排序流
        List<SessionDevice> filtered = sessionDevices.stream()
                // 名称模糊查询
                .filter(sd -> {
                    if (nameKeyword == null || nameKeyword.isBlank()) {
                        return true;
                    }
                    String n = sd.getDeviceName();
                    return n != null && !n.isBlank() && n.toLowerCase().contains(nameKeyword.toLowerCase());
                })
                // 类型匹配
                .filter(sd -> {
                    if (typeKeyword == null) {
                        return true;
                    }
                    return sd.getDeviceType() == typeKeyword;
                })
                // IP 模糊匹配
                .filter(sd -> {
                    if (ipKeyword == null || ipKeyword.isBlank()) {
                        return true;
                    }
                    String ip = sd.getIp();
                    return ip != null && !ip.isBlank() && ip.toLowerCase().contains(ipKeyword.toLowerCase());
                })
                // location 模糊匹配
                .filter(sd -> {
                    if (locKeyword == null || locKeyword.isBlank()) {
                        return true;
                    }
                    String loc = sd.getLocation();
                    return loc != null && !loc.isBlank() && loc.toLowerCase().contains(locKeyword.toLowerCase());
                })
                // 排序：按 loginTime 倒序（时间晚的排前面）
                .sorted(Comparator.comparing(
                        SessionDevice::getLoginTime,
                        Comparator.nullsLast(Comparator.reverseOrder())
                ))
                .toList();

        long total = filtered.size();
        List<SessionDevice> rows;

        if (noPaging) {
            // 不分页，返回所有
            rows = filtered;
        } else {
            // 正常分页
            long validPageNum = Math.max(pageNum, 1);
            long validPageSize = Math.max(pageSize, 1);
            long skip = (validPageNum - 1) * validPageSize;
            rows = filtered.stream()
                    .skip(skip)
                    .limit(validPageSize)
                    .toList();
        }

        return PageResult.<SessionDevice>builder()
                .pageNum(noPaging ? -1L : pageNum)
                .pageSize(noPaging ? -1L : pageSize)
                .total(total)
                .rows(rows)
                .build();
    }


    /**
     * 根据刷新令牌ID和登录时间转换为 SessionDevice 对象
     *
     * @param refreshTokenId 刷新令牌ID
     * @param loginTimestamp 登录时间戳
     * @return SessionDevice 对象或 null
     */
    private SessionDevice convertToSessionDevice(String refreshTokenId, Long loginTimestamp) {
        if (refreshTokenId == null || refreshTokenId.isEmpty()) {
            return null;
        }

        Map<String, Object> deviceInfo = deviceStore.getDevice(refreshTokenId);
        if (deviceInfo.isEmpty()) {
            return null;
        }

        DeviceType deviceType = null;
        Object typeObj = deviceInfo.get(SecurityConstants.DEVICE_TYPE);
        if (typeObj != null) {
            deviceType = DeviceType.getByValue(typeObj.toString());
        }
        
        String deviceName = Optional.ofNullable(deviceInfo.get(SecurityConstants.DEVICE_NAME))
                .map(Object::toString)
                .orElse(null);

        String username = Optional.ofNullable(deviceInfo.get(SecurityConstants.USER_NAME))
                .map(Object::toString)
                .orElse(null);

        Long userId = null;
        Object userIdObj = deviceInfo.get(SecurityConstants.USER_ID);
        if (userIdObj != null) {
            userId = Long.valueOf(userIdObj.toString());
        }

        String ip = Optional.ofNullable(deviceInfo.get(SecurityConstants.IP))
                .map(Object::toString)
                .orElse(null);
                
        String location = Optional.ofNullable(deviceInfo.get(SecurityConstants.LOCATION))
                .map(Object::toString)
                .orElse(null);

        // 获取登录时间
        Date loginDate = null;
        Object loginObj = deviceInfo.get(SecurityConstants.LOGIN_TIME);
        long timestamp;
        if (loginObj instanceof Number) {
            timestamp = ((Number) loginObj).longValue();
        } else if (loginObj instanceof String) {
            try {
                timestamp = Long.parseLong((String) loginObj);
            } catch (NumberFormatException e) {
                timestamp = 0L;
            }
        } else {
            timestamp = (loginTimestamp != null) ? loginTimestamp : 0L;
        }
        if (timestamp > 0) {
            loginDate = new Date(timestamp);
        }

        // 构建 SessionDevice
        return SessionDevice.builder()
                .deviceType(deviceType)
                .username(username)
                .refreshTokenId(refreshTokenId)
                .userId(userId)
                .deviceName(deviceName)
                .ip(ip)
                .location(location)
                .loginTime(loginDate)
                .build();
    }


    /**
     * 通过用户名删除全部设备信息，注意！删除设备信息后，用户将无法登录系统
     *
     * @param username 用户名
     * @return 操作结果
     */
    public boolean deleteDeviceByUsername(String username) {
        Assert.isTrue(!username.isBlank(), "用户名不能为空!");
        
        Map<String, Long> devices = deviceStore.getDevicesByUser(username);
        
        // 删除设备信息和访问令牌和刷新令牌信息
        for (String refreshTokenId : devices.keySet()) {
            tokenStore.deleteRefreshTokenAndAccessToken(refreshTokenId);
            deviceStore.deleteDevice(refreshTokenId);
        }
        
        // 删除设备索引
        deviceStore.deleteAllDevicesByUser(username);
        
        return true;
    }

    /**
     * 通过用户名和设备类型删除设备，删除设备之后也会删除会话
     *
     * @param username   用户名
     * @param deviceType 设备信息
     * @return 操作结果
     */
    public boolean deleteDeviceByUsername(String username, DeviceType deviceType) {
        Assert.isTrue(!username.isBlank(), "用户名不能为空!");
        Assert.notNull(deviceType, "设备类型不能为空!");

        Map<String, Long> devices = deviceStore.getDevicesByUser(username);
        Set<String> toDelete = new HashSet<>();

        // 筛选出指定设备类型的会话
        for (String refreshTokenId : devices.keySet()) {
            Map<String, Object> deviceInfo = deviceStore.getDevice(refreshTokenId);
            if (!deviceInfo.isEmpty()) {
                String loginDeviceType = (String) deviceInfo.get(SecurityConstants.DEVICE_TYPE);
                if (deviceType.getValue().equals(loginDeviceType)) {
                    toDelete.add(refreshTokenId);
                }
            }
        }

        // 删除指定设备类型的设备信息和令牌
        for (String refreshTokenId : toDelete) {
            // 删除刷新令牌和访问令牌
            tokenStore.deleteRefreshTokenAndAccessToken(refreshTokenId);
            // 删除设备信息
            deviceStore.deleteDevice(refreshTokenId);
            // 从索引中移除该设备
            deviceStore.removeDeviceFromUserIndex(username, refreshTokenId);
        }

        return !toDelete.isEmpty();
    }
}

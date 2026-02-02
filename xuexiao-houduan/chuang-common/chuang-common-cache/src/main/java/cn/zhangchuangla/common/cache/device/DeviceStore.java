package cn.zhangchuangla.common.cache.device;

import java.util.List;
import java.util.Map;

/**
 * 设备存储接口
 * 定义设备信息存储的统一操作方法
 *
 * @author Chuang
 */
public interface DeviceStore {

    /**
     * 保存设备信息
     *
     * @param refreshTokenId 刷新令牌ID（作为设备唯一标识）
     * @param deviceInfo     设备信息（包含用户名、设备类型、IP等）
     * @param loginTime      登录时间戳
     * @param expireSeconds  过期时间（秒）
     */
    void saveDevice(String refreshTokenId, Map<String, Object> deviceInfo, long loginTime, long expireSeconds);

    /**
     * 获取设备信息
     *
     * @param refreshTokenId 刷新令牌ID
     * @return 设备信息，不存在返回空 Map
     */
    Map<String, Object> getDevice(String refreshTokenId);

    /**
     * 删除设备信息
     *
     * @param refreshTokenId 刷新令牌ID
     * @return 是否删除成功
     */
    boolean deleteDevice(String refreshTokenId);

    /**
     * 获取用户的所有设备
     *
     * @param username 用户名
     * @return 设备列表（refreshTokenId -> loginTime）
     */
    Map<String, Long> getDevicesByUser(String username);

    /**
     * 统计用户的设备数量
     *
     * @param username 用户名
     * @return 设备数量
     */
    long countDevicesByUser(String username);

    /**
     * 添加设备到用户索引
     *
     * @param username       用户名
     * @param refreshTokenId 刷新令牌ID
     * @param loginTime      登录时间戳（作为排序分数）
     * @param expireSeconds  过期时间（秒）
     */
    void addDeviceToUserIndex(String username, String refreshTokenId, long loginTime, long expireSeconds);

    /**
     * 从用户索引中移除设备
     *
     * @param username       用户名
     * @param refreshTokenId 刷新令牌ID
     */
    void removeDeviceFromUserIndex(String username, String refreshTokenId);

    /**
     * 获取用户最早登录的设备
     *
     * @param username 用户名
     * @return 最早登录的设备 refreshTokenId，不存在返回 null
     */
    String getOldestDevice(String username);

    /**
     * 删除用户的所有设备
     *
     * @param username 用户名
     * @return 删除的设备数量
     */
    long deleteAllDevicesByUser(String username);

    /**
     * 获取所有用户的设备索引键
     *
     * @return 用户设备索引键列表
     */
    List<String> getAllUserDeviceIndexKeys();

    /**
     * 检查设备是否存在
     *
     * @param refreshTokenId 刷新令牌ID
     * @return 是否存在
     */
    boolean deviceExists(String refreshTokenId);
}

package cn.zhangchuangla.common.cache.token;

/**
 * Token 存储接口
 * 定义 Token 存储的统一操作方法
 *
 * @author Chuang
 * @param <T> 在线用户信息类型
 */
public interface TokenStore<T> {

    /**
     * 保存访问令牌
     *
     * @param accessTokenId 访问令牌ID
     * @param onlineUser    在线用户信息
     */
    void setAccessToken(String accessTokenId, T onlineUser);

    /**
     * 保存刷新令牌
     *
     * @param refreshTokenId 刷新令牌ID
     * @param accessTokenId  访问令牌ID
     */
    void setRefreshToken(String refreshTokenId, String accessTokenId);

    /**
     * 获取访问令牌对应的在线用户信息
     *
     * @param accessTokenId 访问令牌ID
     * @return 在线用户信息，不存在返回 null
     */
    T getAccessToken(String accessTokenId);

    /**
     * 获取刷新令牌对应的访问令牌ID
     *
     * @param refreshTokenId 刷新令牌ID
     * @return 访问令牌ID，不存在返回 null
     */
    String getRefreshToken(String refreshTokenId);

    /**
     * 删除访问令牌
     *
     * @param accessTokenId 访问令牌ID
     */
    void deleteAccessToken(String accessTokenId);

    /**
     * 删除刷新令牌
     *
     * @param refreshTokenId 刷新令牌ID
     */
    void deleteRefreshToken(String refreshTokenId);

    /**
     * 删除刷新令牌及其关联的访问令牌
     *
     * @param refreshTokenId 刷新令牌ID
     */
    void deleteRefreshTokenAndAccessToken(String refreshTokenId);

    /**
     * 验证访问令牌是否有效
     *
     * @param accessTokenId 访问令牌ID
     * @return true 表示有效
     */
    boolean isValidAccessToken(String accessTokenId);

    /**
     * 验证刷新令牌是否有效
     *
     * @param refreshTokenId 刷新令牌ID
     * @return true 表示有效
     */
    boolean isValidRefreshToken(String refreshTokenId);

    /**
     * 根据访问令牌ID获取刷新令牌ID
     *
     * @param accessTokenId 访问令牌ID
     * @return 刷新令牌ID
     */
    String getRefreshTokenIdByAccessTokenId(String accessTokenId);

    /**
     * 映射刷新令牌到新的访问令牌
     *
     * @param refreshTokenId  刷新令牌ID
     * @param newAccessTokenId 新的访问令牌ID
     */
    void mapRefreshTokenToAccessToken(String refreshTokenId, String newAccessTokenId);

    /**
     * 更新访问令牌的访问时间
     *
     * @param accessTokenId 访问令牌ID
     * @return 是否更新成功
     */
    boolean updateAccessTime(String accessTokenId);
}

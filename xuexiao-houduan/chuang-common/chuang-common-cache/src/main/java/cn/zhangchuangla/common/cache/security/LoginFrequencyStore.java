package cn.zhangchuangla.common.cache.security;

/**
 * 登录频率存储接口
 * 定义登录频率限制的统一操作方法
 * 支持成功登录次数统计，用于防止频繁登录攻击
 *
 * @author Chuang
 */
public interface LoginFrequencyStore {

    /**
     * 增加成功登录次数（小时级别）
     *
     * @param username      用户名
     * @param expireSeconds 过期时间（秒）
     */
    void incrementHourlySuccessCount(String username, long expireSeconds);

    /**
     * 增加成功登录次数（天级别）
     *
     * @param username      用户名
     * @param expireSeconds 过期时间（秒）
     */
    void incrementDailySuccessCount(String username, long expireSeconds);

    /**
     * 获取小时级别成功登录次数
     *
     * @param username 用户名
     * @return 当前小时内成功登录次数
     */
    int getHourlySuccessCount(String username);

    /**
     * 获取天级别成功登录次数
     *
     * @param username 用户名
     * @return 当前天内成功登录次数
     */
    int getDailySuccessCount(String username);

    /**
     * 获取小时级别计数的剩余过期时间
     *
     * @param username 用户名
     * @return 剩余秒数，-1 表示不存在或已过期
     */
    long getHourlyExpireSeconds(String username);

    /**
     * 获取天级别计数的剩余过期时间
     *
     * @param username 用户名
     * @return 剩余秒数，-1 表示不存在或已过期
     */
    long getDailyExpireSeconds(String username);

    /**
     * 检查是否被限制（小时级别）
     *
     * @param username 用户名
     * @param limit    限制次数
     * @return true 表示被限制
     */
    boolean isHourlyLimited(String username, int limit);

    /**
     * 检查是否被限制（天级别）
     *
     * @param username 用户名
     * @param limit    限制次数
     * @return true 表示被限制
     */
    boolean isDailyLimited(String username, int limit);
}

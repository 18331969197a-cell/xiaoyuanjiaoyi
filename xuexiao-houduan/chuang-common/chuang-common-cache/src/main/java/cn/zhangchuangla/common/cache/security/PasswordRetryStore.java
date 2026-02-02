package cn.zhangchuangla.common.cache.security;

/**
 * 密码重试存储接口
 * 定义密码重试限制的统一操作方法
 *
 * @author Chuang
 */
public interface PasswordRetryStore {

    /**
     * 增加重试次数
     *
     * @param username 用户名
     * @return 当前重试次数
     */
    int incrementRetryCount(String username);

    /**
     * 获取重试次数
     *
     * @param username 用户名
     * @return 当前重试次数
     */
    int getRetryCount(String username);

    /**
     * 清除重试计数
     *
     * @param username 用户名
     */
    void clearRetryCount(String username);

    /**
     * 锁定账户
     *
     * @param username    用户名
     * @param lockSeconds 锁定时间（秒）
     */
    void lockAccount(String username, long lockSeconds);

    /**
     * 检查账户是否被锁定
     *
     * @param username 用户名
     * @return true 表示被锁定
     */
    boolean isAccountLocked(String username);

    /**
     * 解锁账户
     *
     * @param username 用户名
     */
    void unlockAccount(String username);

    /**
     * 获取账户锁定剩余时间（秒）
     *
     * @param username 用户名
     * @return 剩余锁定时间，未锁定返回 0
     */
    long getLockRemainingSeconds(String username);
}

package cn.zhangchuangla.framework.security.login.limiter;

import cn.zhangchuangla.common.cache.security.PasswordRetryStore;
import cn.zhangchuangla.common.core.enums.ResultCode;
import cn.zhangchuangla.common.core.exception.AuthorizationException;
import cn.zhangchuangla.common.core.utils.Assert;
import cn.zhangchuangla.framework.security.property.SecurityProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * 密码重试限制器
 * <p>
 * 该组件用于控制用户密码重试次数，防止暴力破解攻击。
 * 当用户密码输入错误次数超过配置的最大重试次数时
 * </p>
 *
 * @author Chuang
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class PasswordRetryLimiter {

    private final PasswordRetryStore passwordRetryStore;
    private final SecurityProperties securityProperties;

    /**
     * 检查用户是否允许登录（检查是否被锁定）
     *
     * @param username 用户名
     * @throws AuthorizationException 如果用户被锁定则抛出异常
     */
    public void allowLogin(String username) {
        Assert.hasText(username, "用户名不能为空");

        boolean isLocked = passwordRetryStore.isAccountLocked(username);

        if (isLocked) {
            long remainingTime = passwordRetryStore.getLockRemainingSeconds(username);
            String message = remainingTime > 0
                    ? String.format("账号已被锁定，请在 %d 秒后重试", remainingTime)
                    : "账号已被锁定，请稍后重试";

            log.warn("用户 {} 尝试登录但账号已被锁定，剩余锁定时间: {} 秒", username, remainingTime);
            throw new AuthorizationException(ResultCode.LOGIN_ERROR, message);
        }
    }

    /**
     * 记录登录失败，增加重试次数
     *
     * @param username 用户名
     */
    public void recordFailure(String username) {
        Assert.hasText(username, "用户名不能为空");

        SecurityProperties.PasswordConfig passwordConfig = securityProperties.getPasswordConfig();
        if (passwordConfig == null) {
            log.warn("密码配置为空，跳过失败记录");
            return;
        }

        Integer maxRetryCount = passwordConfig.getMaxRetryCount();
        Integer lockTime = passwordConfig.getLockTime();

        // -1 表示不限制重试次数
        if (maxRetryCount == null || maxRetryCount == -1) {
            log.debug("用户 {} 密码重试次数不限制", username);
            return;
        }

        // 增加重试次数
        int currentRetryCount = passwordRetryStore.incrementRetryCount(username);

        log.info("用户 {} 登录失败，当前重试次数: {}/{}", username, currentRetryCount, maxRetryCount);

        // 检查是否达到最大重试次数
        if (currentRetryCount >= maxRetryCount) {
            lockUser(username, lockTime);
        }
    }

    /**
     * 清除用户的重试记录（登录成功时调用）
     *
     * @param username 用户名
     */
    public void clearRecord(String username) {
        Assert.hasText(username, "用户名不能为空");

        // 清除重试次数记录和锁定状态
        passwordRetryStore.clearRetryCount(username);
        passwordRetryStore.unlockAccount(username);

        log.info("用户 {} 登录成功，已清除重试记录和锁定状态", username);
    }

    /**
     * 锁定用户账号
     *
     * @param username 用户名
     * @param lockTime 锁定时间（秒）
     */
    private void lockUser(String username, Integer lockTime) {
        if (lockTime == null || lockTime <= 0) {
            log.warn("锁定时间配置无效，跳过锁定用户: {}", username);
            return;
        }

        // 设置锁定标记
        passwordRetryStore.lockAccount(username, lockTime);
        // 清除重试次数记录
        passwordRetryStore.clearRetryCount(username);

        log.warn("用户 {} 密码重试次数超限，账号已被锁定 {} 秒", username, lockTime);
    }

    /**
     * 获取用户当前重试次数
     *
     * @param username 用户名
     * @return 当前重试次数
     */
    public int getCurrentRetryCount(String username) {
        Assert.hasText(username, "用户名不能为空");
        return passwordRetryStore.getRetryCount(username);
    }

    /**
     * 检查用户是否被锁定
     *
     * @param username 用户名
     * @return true-被锁定，false-未被锁定
     */
    public boolean isLocked(String username) {
        Assert.hasText(username, "用户名不能为空");
        return passwordRetryStore.isAccountLocked(username);
    }

    /**
     * 获取用户剩余锁定时间
     *
     * @param username 用户名
     * @return 剩余锁定时间（秒），如果未被锁定则返回0
     */
    public long getRemainingLockTime(String username) {
        Assert.hasText(username, "用户名不能为空");

        if (!isLocked(username)) {
            return 0;
        }

        return passwordRetryStore.getLockRemainingSeconds(username);
    }
}

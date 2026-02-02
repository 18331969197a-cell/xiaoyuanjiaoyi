package cn.zhangchuangla.framework.interceptor;

import cn.zhangchuangla.common.cache.ratelimit.RateLimiter;
import cn.zhangchuangla.common.core.entity.security.SysUserDetails;
import cn.zhangchuangla.common.core.enums.AccessType;
import cn.zhangchuangla.common.core.enums.ResultCode;
import cn.zhangchuangla.common.core.exception.TooManyRequestException;
import cn.zhangchuangla.common.core.utils.SecurityUtils;
import cn.zhangchuangla.common.core.utils.client.IPUtils;
import cn.zhangchuangla.framework.annotation.AccessLimit;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import java.lang.reflect.Method;

/**
 * 接口访问限流拦截器
 * 基于本地缓存实现限流功能
 *
 * @author Chuang
 * <p>
 * created on 2025/4/7 21:00
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AccessLimitInterceptor implements HandlerInterceptor {

    private static final String ACCESS_LIMIT_IP = "access_limit:ip:";
    private static final String ACCESS_LIMIT_USER = "access_limit:user:";
    private static final String ACCESS_LIMIT_CUSTOM = "access_limit:custom:";

    private final RateLimiter rateLimiter;

    @Override
    public boolean preHandle(@NotNull HttpServletRequest request, @NotNull HttpServletResponse response,
                             @NotNull Object handler) {
        // 如果不是方法处理器，直接放行
        if (!(handler instanceof HandlerMethod handlerMethod)) {
            return true;
        }

        // 获取方法对象和AccessLimit注解
        Method method = handlerMethod.getMethod();
        AccessLimit accessLimit = method.getAnnotation(AccessLimit.class);

        // 如果没有AccessLimit注解，直接放行
        if (accessLimit == null) {
            return true;
        }

        // 获取注解中的限流参数
        int maxCount = accessLimit.maxCount();
        int limitPeriod = accessLimit.second();
        AccessType limitType = accessLimit.limitType();
        String message = accessLimit.message();

        // 根据限流类型构建限流 key
        String limitKey = buildLimitKey(request, method, limitType);

        try {
            // 执行限流判断
            boolean allowed = rateLimiter.tryAcquire(limitKey, maxCount, limitPeriod);

            // 如果不允许访问，表示超过访问限制
            if (!allowed) {
                String ip = IPUtils.getIpAddress(request);
                String uri = request.getRequestURI();
                log.warn("接口访问频率超限 - IP: {}, URI: {}, 限制: {}次/{}秒, 限流类型: {}",
                        ip, uri, maxCount, limitPeriod, limitType.getDescription());

                // 直接抛出异常，由全局异常处理器处理
                throw new TooManyRequestException(ResultCode.TOO_MANY_REQUESTS, message);
            }
        } catch (TooManyRequestException e) {
            // 直接将TooManyRequestException向上抛出
            throw e;
        } catch (Exception e) {
            // 限流异常时，为确保系统可用性，记录异常但放行请求
            log.error("限流功能异常，请求已放行: {}", e.getMessage(), e);
        }

        // 请求未超过限制，放行
        return true;
    }

    /**
     * 根据限流类型构建限流 key
     *
     * @param request   HTTP请求
     * @param method    限流的方法
     * @param limitType 限流类型枚举
     * @return 限流键
     */
    private String buildLimitKey(HttpServletRequest request, Method method, AccessType limitType) {
        StringBuilder keyBuilder = new StringBuilder(64);
        String className = method.getDeclaringClass().getName();
        String methodName = method.getName();
        String baseKey = className + ":" + methodName;

        // 根据限流类型选择不同的键前缀
        switch (limitType) {
            // IP限流模式
            case IP -> {
                String ipAddress = IPUtils.getIpAddress(request);
                keyBuilder.append(ACCESS_LIMIT_IP).append(baseKey).append(":").append(ipAddress);
            }
            // 用户ID限流模式
            case USER -> {
                // 尝试获取当前登录用户
                try {
                    SysUserDetails sysUserDetails = SecurityUtils.getLoginUser();
                    keyBuilder.append(ACCESS_LIMIT_USER).append(baseKey)
                            .append(":").append(sysUserDetails.getUserId());
                } catch (Exception e) {
                    // 未登录用户，默认降级为IP限流
                    String ipAddress = IPUtils.getIpAddress(request);
                    keyBuilder.append(ACCESS_LIMIT_IP).append(baseKey).append(":").append(ipAddress);
                    log.debug("用户未登录，降级为IP限流: {}", ipAddress);
                }
            }
            // 自定义参数限流模式（此处使用URI作为自定义参数）
            case CUSTOM -> {
                String uri = request.getRequestURI();
                keyBuilder.append(ACCESS_LIMIT_CUSTOM).append(baseKey).append(":").append(uri);
            }
            default -> {
                // 默认采用IP限流
                String ipAddress = IPUtils.getIpAddress(request);
                keyBuilder.append(ACCESS_LIMIT_IP).append(baseKey).append(":").append(ipAddress);
            }
        }

        return keyBuilder.toString();
    }
}

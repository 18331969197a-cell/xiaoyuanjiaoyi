package cn.zhangchuangla.framework.aspect;

import cn.zhangchuangla.common.cache.ratelimit.RateLimiter;
import cn.zhangchuangla.common.core.entity.security.SysUserDetails;
import cn.zhangchuangla.common.core.enums.AccessType;
import cn.zhangchuangla.common.core.enums.ResultCode;
import cn.zhangchuangla.common.core.exception.TooManyRequestException;
import cn.zhangchuangla.common.core.utils.SecurityUtils;
import cn.zhangchuangla.common.core.utils.client.IPUtils;
import cn.zhangchuangla.framework.annotation.AccessLimit;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;

/**
 * 访问限制切面
 * 通过AOP方式实现注解式接口限流功能
 * 与拦截器方式互为补充，可以同时使用或单独使用
 * 拦截器适合对Controller层接口限流，AOP适合对任意方法限流
 *
 * @author Chuang
 * <p>
 * created on 2025/4/7 21:30
 */
@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class AccessLimitAspect {

    private static final String ACCESS_LIMIT_IP = "access_limit:ip:";
    private static final String ACCESS_LIMIT_USER = "access_limit:user:";
    private static final String ACCESS_LIMIT_CUSTOM = "access_limit:custom:";

    private final RateLimiter rateLimiter;
    private final ExpressionParser spelParser = new SpelExpressionParser();

    /**
     * 环绕通知处理访问限制
     *
     * @param joinPoint   连接点
     * @param accessLimit 访问限制注解
     * @return 处理结果
     * @throws Throwable 执行原方法可能抛出的异常
     */
    @Around("@annotation(accessLimit)")
    public Object around(ProceedingJoinPoint joinPoint, AccessLimit accessLimit) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        AccessLimit classLevel = method.getDeclaringClass().getAnnotation(AccessLimit.class);
        AccessLimit effective = accessLimit != null ? accessLimit : classLevel;
        if (effective == null) {
            return joinPoint.proceed();
        }

        if (!effective.enable()) {
            return joinPoint.proceed();
        }

        // 获取注解中的限流参数
        int maxCount = effective.maxCount();
        int limitPeriod = effective.second();
        AccessType limitType = effective.limitType();
        String message = effective.message();

        // 获取请求信息
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();

        // 构建限流键
        String limitKey = buildLimitKey(attributes, joinPoint, limitType, effective.key());

        try {
            // 执行限流判断
            boolean allowed = rateLimiter.tryAcquire(limitKey, maxCount, limitPeriod);

            // 如果不允许访问，表示超过访问限制
            if (!allowed) {
                // 获取类名和方法名，用于日志记录
                String className = method.getDeclaringClass().getName();
                String methodName = method.getName();

                // 记录限流日志
                if (attributes != null) {
                    HttpServletRequest request = attributes.getRequest();
                    String ip = IPUtils.getIpAddress(request);
                    log.warn("AOP接口访问频率超限 - IP: {}, 方法: {}.{}, 限制: {}次/{}秒, 限流类型: {}",
                            ip, className, methodName, maxCount, limitPeriod, limitType.getDescription());
                } else {
                    log.warn("AOP接口访问频率超限 - 方法: {}.{}, 限制: {}次/{}秒, 限流类型: {}",
                            className, methodName, maxCount, limitPeriod, limitType.getDescription());
                }

                // 统一抛出TooManyRequestException，由全局异常处理器处理
                throw new TooManyRequestException(ResultCode.TOO_MANY_REQUESTS, message);
            }
        } catch (TooManyRequestException e) {
            // 直接抛出TooManyRequestException异常
            throw e;
        } catch (Exception e) {
            // 限流异常时，为确保系统可用性，记录异常但放行请求
            log.error("AOP限流功能异常，请求已放行: {}", e.getMessage(), e);
        }

        // 请求未超过限制，执行原方法
        return joinPoint.proceed();
    }

    /**
     * 根据限流类型构建限流 key
     *
     * @param attributes ServletRequestAttributes对象
     * @param joinPoint  切点
     * @param limitType  限流类型枚举
     * @return 限流键
     */
    private String buildLimitKey(ServletRequestAttributes attributes, ProceedingJoinPoint joinPoint,
                                 AccessType limitType, String customKeyExpr) {
        StringBuilder keyBuilder = new StringBuilder(64);

        // 获取方法签名
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        String className = method.getDeclaringClass().getName();
        String methodName = method.getName();
        String baseKey = className + ":" + methodName;

        HttpServletRequest request = null;
        if (attributes != null) {
            request = attributes.getRequest();
        }

        // 根据限流类型选择不同的键前缀
        switch (limitType) {
            // IP限流模式
            case IP -> {
                String ipAddress = (request != null) ? IPUtils.getIpAddress(request) : "non-web";
                keyBuilder.append(ACCESS_LIMIT_IP).append(baseKey).append(":").append(ipAddress);
            }
            // 用户ID限流模式
            case USER -> {
                try {
                    SysUserDetails sysUserDetails = SecurityUtils.getLoginUser();
                    keyBuilder.append(ACCESS_LIMIT_USER).append(baseKey)
                            .append(":").append(sysUserDetails.getUserId());
                } catch (Exception e) {
                    // 获取用户失败，降级为IP限流
                    String ipAddress = (request != null) ? IPUtils.getIpAddress(request) : "non-web";
                    keyBuilder.append(ACCESS_LIMIT_IP).append(baseKey).append(":").append(ipAddress);
                    log.debug("获取用户信息失败，降级为IP限流: {}", ipAddress);
                }
            }
            // 自定义参数限流模式
            case CUSTOM -> {
                String evaluated = null;
                if (customKeyExpr != null && !customKeyExpr.isBlank()) {
                    try {
                        StandardEvaluationContext context = new StandardEvaluationContext();
                        context.setVariable("args", joinPoint.getArgs());
                        context.setVariable("request", request);
                        try {
                            SysUserDetails user = SecurityUtils.getLoginUser();
                            context.setVariable("user", user);
                        } catch (Exception ignore) {
                        }
                        evaluated = String.valueOf(spelParser.parseExpression(customKeyExpr).getValue(context));
                    } catch (Exception e) {
                        log.warn("自定义限流Key SpEL解析失败，降级为URI: {}", e.getMessage());
                    }
                }
                if (evaluated == null || evaluated.isBlank()) {
                    evaluated = (request != null) ? request.getRequestURI() : "non-web";
                }
                keyBuilder.append(ACCESS_LIMIT_CUSTOM).append(baseKey).append(":").append(evaluated);
            }
            default -> {
                String ipAddress = (request != null) ? IPUtils.getIpAddress(request) : "non-web";
                keyBuilder.append(ACCESS_LIMIT_IP).append(baseKey).append(":").append(ipAddress);
            }
        }

        return keyBuilder.toString();
    }
}

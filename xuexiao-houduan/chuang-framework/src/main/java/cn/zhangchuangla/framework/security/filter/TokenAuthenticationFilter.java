package cn.zhangchuangla.framework.security.filter;

import cn.zhangchuangla.common.core.constant.SecurityConstants;
import cn.zhangchuangla.common.core.enums.ResultCode;
import cn.zhangchuangla.common.core.utils.ResponseUtils;
import cn.zhangchuangla.framework.annotation.Anonymous;
import cn.zhangchuangla.framework.security.property.SecurityProperties;
import cn.zhangchuangla.framework.security.token.TokenService;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Token认证拦截器
 *
 * @author Chuang
 */
@Slf4j
public class TokenAuthenticationFilter extends OncePerRequestFilter {


    @Autowired
    private SecurityProperties securityProperties;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private RequestMappingHandlerMapping requestMappingHandlerMapping;

    private volatile Set<String> anonymousUrls = new HashSet<>();

    @PostConstruct
    private void initAnonymousUrls() {
        try {
            Map<RequestMappingInfo, HandlerMethod> handlerMethods = requestMappingHandlerMapping.getHandlerMethods();
            Set<String> urls = new HashSet<>();
            for (Map.Entry<RequestMappingInfo, HandlerMethod> entry : handlerMethods.entrySet()) {
                HandlerMethod handlerMethod = entry.getValue();
                Anonymous methodAnonymous = AnnotationUtils.findAnnotation(handlerMethod.getMethod(), Anonymous.class);
                Anonymous classAnonymous = AnnotationUtils.findAnnotation(handlerMethod.getBeanType(), Anonymous.class);
                if (methodAnonymous != null || classAnonymous != null) {
                    Set<String> patterns = entry.getKey().getPatternValues();
                    if (!patterns.isEmpty()) {
                        urls.addAll(patterns);
                    }
                }
            }
            anonymousUrls = urls;
        } catch (Exception ex) {
            log.warn("Failed to load anonymous URLs", ex);
            anonymousUrls = new HashSet<>();
        }
    }

    /**
     * 校验Token，包括验签和是否过期
     *
     * @param request     请求参数
     * @param response    响应参数
     * @param filterChain 过滤器链
     */
    @Override
    protected void doFilterInternal(@NotNull HttpServletRequest request, @NotNull HttpServletResponse response,
                                    @NotNull FilterChain filterChain) throws ServletException, IOException {
        String header = securityProperties.getHeader();
        String token = request.getHeader(header);
        // 兼容标准 Authorization: Bearer <token>
        if (StringUtils.isBlank(token)) {
            String authHeader = request.getHeader(securityProperties.getHeader());
            if (StringUtils.isNotBlank(authHeader) && authHeader.startsWith(securityProperties.session.getTokenPrefix().trim() + " ")) {
                token = authHeader.substring(7).trim();
            }
        }
        try {
            if (StringUtils.isNotBlank(token)) {
                // 直接解析令牌（内部会做验签与有效性检查），避免重复解析
                Authentication authentication = tokenService.parseAccessToken(token);
                if (authentication == null) {
                    ResponseUtils.writeErrMsg(response, ResultCode.ACCESS_TOKEN_INVALID, HttpStatus.UNAUTHORIZED);
                    return;
                }
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception ex) {
            // 安全上下文清除保障（防止上下文残留）
            SecurityContextHolder.clearContext();
            ResponseUtils.writeErrMsg(response, ResultCode.ACCESS_TOKEN_INVALID, HttpStatus.UNAUTHORIZED);
            return;
        }

        // 继续后续过滤器链执行
        filterChain.doFilter(request, response);
    }

    /**
     * 此方法用于排除不需要过滤的请求，防止过滤器对某些请求进行处理。
     *
     * @param request current HTTP request
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();

        AntPathMatcher pathMatcher = new AntPathMatcher();

        // 检查普通白名单
        if (isPathMatchAny(path, SecurityConstants.WHITELIST, pathMatcher)) {
            return true;
        }

        // 检查静态资源白名单
        if (isPathMatchAny(path, SecurityConstants.STATIC_RESOURCES_WHITELIST, pathMatcher)) {
            return true;
        }

        // 检查匿名接口（@Anonymous）
        if (isAnonymousPath(path, pathMatcher)) {
            return true;
        }

        // 检查Swagger白名单
        return isPathMatchAny(path, SecurityConstants.SWAGGER_WHITELIST, pathMatcher);
    }

    /**
     * 检查路径是否匹配任一白名单规则
     *
     * @param path        请求路径
     * @param patterns    匹配模式数组
     * @param pathMatcher 路径匹配器
     * @return 是否匹配
     */
    private boolean isPathMatchAny(String path, String[] patterns, AntPathMatcher pathMatcher) {
        return Arrays.stream(patterns)
                .anyMatch(pattern -> pathMatcher.match(pattern, path.trim()));
    }

    /**
     * 检查路径是否匹配任一匿名接口模式
     *
     * @param path        请求路径
     * @param pathMatcher 路径匹配器
     * @return 是否匹配
     */
    private boolean isAnonymousPath(String path, AntPathMatcher pathMatcher) {
        if (anonymousUrls == null || anonymousUrls.isEmpty()) {
            return false;
        }
        String trimmedPath = path.trim();
        for (String pattern : anonymousUrls) {
            if (pathMatcher.match(pattern, trimmedPath)) {
                return true;
            }
        }
        return false;
    }

}

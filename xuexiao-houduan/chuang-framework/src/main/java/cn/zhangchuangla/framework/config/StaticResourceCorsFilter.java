package cn.zhangchuangla.framework.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 静态资源CORS过滤器
 * 专门为上传的静态资源（如图片）添加CORS头
 * 
 * @author Chuang
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class StaticResourceCorsFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        
        String requestUri = request.getRequestURI();
        
        // 只处理上传文件路径
        if (requestUri.startsWith("/uploads/")) {
            String origin = request.getHeader("Origin");
            if (origin != null) {
                response.setHeader("Access-Control-Allow-Origin", origin);
            } else {
                response.setHeader("Access-Control-Allow-Origin", "*");
            }
            response.setHeader("Access-Control-Allow-Methods", "GET, HEAD, OPTIONS");
            response.setHeader("Access-Control-Allow-Headers", "*");
            response.setHeader("Access-Control-Max-Age", "3600");
            response.setHeader("Access-Control-Allow-Credentials", "true");
            
            // 处理预检请求
            if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
                response.setStatus(HttpServletResponse.SC_OK);
                return;
            }
        }
        
        chain.doFilter(req, res);
    }
}

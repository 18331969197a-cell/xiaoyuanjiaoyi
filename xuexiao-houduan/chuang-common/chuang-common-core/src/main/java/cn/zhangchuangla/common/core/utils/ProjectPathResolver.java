package cn.zhangchuangla.common.core.utils;

import org.springframework.util.StringUtils;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 * 项目路径解析工具
 * <p>
 * 优先将上传目录解析到前端工程的 public 目录，方便整仓拷贝时静态资源一并带走。
 */
public final class ProjectPathResolver {

    private static final List<String> FRONTEND_PUBLIC_CANDIDATES = List.of(
            "xuexiao-qian/apps/web-antd/public",
            "../xuexiao-qian/apps/web-antd/public",
            "../../xuexiao-qian/apps/web-antd/public",
            "apps/web-antd/public"
    );

    private ProjectPathResolver() {
    }

    public static Path resolveFrontendPublicDir(String fallbackPath) {
        Path candidate = searchCandidate(FRONTEND_PUBLIC_CANDIDATES);
        if (candidate != null) {
            return candidate;
        }
        return normalizeFallback(fallbackPath);
    }

    public static Path resolveFrontendUploadsDir(String fallbackPath) {
        Path publicDir = resolveFrontendPublicDir(null);
        if (publicDir != null) {
            return publicDir.resolve("uploads").normalize();
        }
        return normalizeFallback(fallbackPath);
    }

    private static Path normalizeFallback(String fallbackPath) {
        if (StringUtils.hasText(fallbackPath)) {
            return Paths.get(fallbackPath).toAbsolutePath().normalize();
        }
        return Paths.get(System.getProperty("user.dir")).toAbsolutePath().normalize();
    }

    private static Path searchCandidate(List<String> candidates) {
        Path current = Paths.get(System.getProperty("user.dir")).toAbsolutePath().normalize();

        for (int depth = 0; depth < 5 && current != null; depth++) {
            for (String relativeCandidate : candidates) {
                Path candidate = current.resolve(relativeCandidate).normalize();
                if (Files.exists(candidate) && Files.isDirectory(candidate)) {
                    return candidate;
                }
            }
            current = current.getParent();
        }
        return null;
    }
}

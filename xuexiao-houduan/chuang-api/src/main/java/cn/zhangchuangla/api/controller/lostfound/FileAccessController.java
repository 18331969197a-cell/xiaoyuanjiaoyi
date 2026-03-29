package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.utils.ProjectPathResolver;
import cn.zhangchuangla.framework.annotation.Anonymous;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

/**
 * 文件访问接口
 * 提供上传文件的公开访问，绕过Spring Security认证
 *
 * @author Chuang
 */
@RestController
@RequestMapping("/file")
@Tag(name = "文件访问", description = "上传文件公开访问接口")
@Slf4j
@Anonymous
public class FileAccessController {

    @Value("${file.upload.path:C:/uploads/lostfound}")
    private String uploadPath;

    @Value("${file.upload.frontend-path:}")
    private String frontendPath;
    
    /**
     * 允许访问的文件扩展名白名单
     */
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"
    ));
    
    /**
     * 文件头魔数映射（用于检测真实文件类型）
     */
    private static final Map<String, byte[]> FILE_SIGNATURES = new HashMap<>();
    static {
        FILE_SIGNATURES.put("jpg", new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF});
        FILE_SIGNATURES.put("png", new byte[]{(byte) 0x89, 0x50, 0x4E, 0x47});
        FILE_SIGNATURES.put("gif", new byte[]{0x47, 0x49, 0x46, 0x38});
        FILE_SIGNATURES.put("bmp", new byte[]{0x42, 0x4D});
        FILE_SIGNATURES.put("webp", new byte[]{0x52, 0x49, 0x46, 0x46});
    }

    /**
     * 访问上传的文件
     * 路径格式: /file/uploads/posts/2025/12/31/xxx.png
     */
    @GetMapping("/uploads/**")
    @Operation(summary = "访问上传的文件")
    public ResponseEntity<Resource> getFile(HttpServletRequest request) {
        try {
            // 获取请求路径，去掉 /file/uploads 前缀
            String requestUri = request.getRequestURI();
            String relativePath = requestUri.substring("/file/uploads/".length());
            
            // 1. 安全检查：防止路径遍历攻击
            if (relativePath.contains("..") || relativePath.contains("\\") || 
                relativePath.contains("%2e") || relativePath.contains("%2E")) {
                log.warn("检测到路径遍历攻击尝试: {}", relativePath);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }
            
            // 2. 检查文件扩展名白名单
            String extension = getFileExtension(relativePath);
            if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
                log.warn("不允许访问的文件类型: {}", extension);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }
            
            // 构建完整文件路径（优先前端 public/uploads 目录）
            Path filePath = resolveExistingPath(relativePath);
            if (filePath == null) {
                return buildPlaceholderResponse(relativePath);
            }
            
            // 5. 验证文件头魔数（防止恶意文件伪装）
            if (!isValidImageByMagicNumber(filePath)) {
                log.warn("文件头魔数校验失败，可能是伪装文件: {}", filePath);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }
            
            // 获取文件MIME类型
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            
            // 6. 确保MIME类型是图片
            if (!contentType.startsWith("image/")) {
                log.warn("非图片MIME类型: {}", contentType);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }
            
            // 返回文件
            Resource resource = new FileSystemResource(filePath);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType(contentType));
            headers.setCacheControl("max-age=86400"); // 缓存1天
            // 添加安全头，防止XSS
            headers.set("X-Content-Type-Options", "nosniff");
            headers.set("Content-Disposition", "inline");
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource);
                    
        } catch (IOException e) {
            log.error("读取文件失败", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private Path resolveExistingPath(String relativePath) {
        List<Path> basePaths = new ArrayList<>();
        basePaths.add(ProjectPathResolver.resolveFrontendUploadsDir(frontendPath));
        basePaths.add(Paths.get(uploadPath).normalize());

        for (Path basePath : basePaths) {
            Path candidate = basePath.resolve(relativePath).normalize();
            if (!candidate.startsWith(basePath)) {
                log.warn("文件路径超出上传目录: {}", candidate);
                continue;
            }
            if (Files.exists(candidate) && Files.isRegularFile(candidate)) {
                return candidate;
            }
        }
        log.warn("文件不存在: {}", relativePath);
        return null;
    }

    private ResponseEntity<Resource> buildPlaceholderResponse(String relativePath) {
        log.info("使用占位图替代缺失资源: {}", relativePath);

        String svg = """
                <svg xmlns="http://www.w3.org/2000/svg" width="640" height="360" viewBox="0 0 640 360">
                  <defs>
                    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
                      <stop offset="0%" stop-color="#f3f4f6"/>
                      <stop offset="100%" stop-color="#e5e7eb"/>
                    </linearGradient>
                  </defs>
                  <rect width="640" height="360" fill="url(#bg)"/>
                  <g fill="#94a3b8" font-family="Arial, sans-serif" text-anchor="middle">
                    <circle cx="320" cy="140" r="42" fill="#cbd5e1"/>
                    <path d="M250 238c18-34 52-52 70-52s52 18 70 52" fill="none" stroke="#94a3b8" stroke-width="18" stroke-linecap="round"/>
                    <text x="320" y="300" font-size="24" fill="#64748b">图片暂不可用</text>
                  </g>
                </svg>
                """;

        ByteArrayResource resource = new ByteArrayResource(svg.getBytes(StandardCharsets.UTF_8));
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("image/svg+xml"));
        headers.setCacheControl("max-age=60");
        headers.set("X-Content-Type-Options", "nosniff");
        headers.set("Content-Disposition", "inline");
        return ResponseEntity.ok()
                .headers(headers)
                .body(resource);
    }
    
    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf("."));
    }
    
    /**
     * 通过文件头魔数验证是否为真实图片
     */
    private boolean isValidImageByMagicNumber(Path filePath) throws IOException {
        try (InputStream is = Files.newInputStream(filePath)) {
            byte[] header = new byte[12];
            int bytesRead = is.read(header);
            if (bytesRead < 2) {
                return false;
            }
            
            for (Map.Entry<String, byte[]> entry : FILE_SIGNATURES.entrySet()) {
                byte[] signature = entry.getValue();
                if (bytesRead >= signature.length && startsWith(header, signature)) {
                    return true;
                }
            }
            return false;
        }
    }
    
    /**
     * 检查字节数组是否以指定前缀开头
     */
    private boolean startsWith(byte[] data, byte[] prefix) {
        if (data.length < prefix.length) {
            return false;
        }
        for (int i = 0; i < prefix.length; i++) {
            if (data[i] != prefix[i]) {
                return false;
            }
        }
        return true;
    }
}

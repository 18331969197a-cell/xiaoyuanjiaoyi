package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.common.core.utils.ProjectPathResolver;
import cn.zhangchuangla.common.core.utils.SecurityUtils;
import cn.zhangchuangla.system.storage.model.entity.StorageFile;
import cn.zhangchuangla.system.storage.service.StorageFileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 本地文件上传接口
 * 用于帖子图片上传，保存到前端public目录
 *
 * @author Chuang
 */
@RestController
@RequestMapping("/lostfound/upload")
@Tag(name = "本地文件上传", description = "帖子图片本地上传接口")
@Slf4j
@RequiredArgsConstructor
public class LocalUploadController extends BaseController {

    private final StorageFileService storageFileService;

    @Value("${file.upload.path:uploads}")
    private String uploadPath;

    @Value("${file.upload.url-prefix:/uploads}")
    private String urlPrefix;
    
    /**
     * 前端public目录路径（用于保存上传文件）
     */
    @Value("${file.upload.frontend-path:}")
    private String frontendPath;
    
    /**
     * 允许的图片扩展名白名单
     */
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"
    ));
    
    /**
     * 允许的MIME类型白名单
     */
    private static final Set<String> ALLOWED_MIME_TYPES = new HashSet<>(Arrays.asList(
            "image/jpeg", "image/png", "image/gif", "image/bmp", "image/webp"
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
        FILE_SIGNATURES.put("webp", new byte[]{0x52, 0x49, 0x46, 0x46}); // RIFF header
    }

    private String resolveFrontendUploadRoot() {
        return ProjectPathResolver.resolveFrontendUploadsDir(
                (frontendPath != null && !frontendPath.isEmpty()) ? frontendPath : uploadPath
        ).toString();
    }

    /**
     * 上传图片到本地
     */
    @PostMapping("/image")
    @Operation(summary = "上传图片到本地")
    public AjaxResult<Map<String, Object>> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return error("请选择要上传的文件");
        }

        // 1. 检查文件扩展名白名单
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
            log.warn("文件扩展名不允许: {}", extension);
            return error("只允许上传以下格式的图片: jpg, jpeg, png, gif, bmp, webp");
        }

        // 2. 检查MIME类型白名单
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            log.warn("MIME类型不允许: {}", contentType);
            return error("文件类型不合法，只能上传图片文件");
        }

        // 3. 检查文件大小（最大5MB）
        if (file.getSize() > 5 * 1024 * 1024) {
            return error("图片大小不能超过5MB");
        }
        
        // 4. 检查文件头魔数（防止恶意文件伪装）
        try {
            if (!isValidImageByMagicNumber(file)) {
                log.warn("文件头魔数校验失败，可能是伪装文件: {}", originalFilename);
                return error("文件内容与扩展名不匹配，请上传真实的图片文件");
            }
        } catch (IOException e) {
            log.error("读取文件头失败", e);
            return error("文件校验失败");
        }

        try {
            // 生成文件名：日期目录 + UUID + 原扩展名
            String dateDir = new SimpleDateFormat("yyyy/MM/dd").format(new Date());
            String newFileName = UUID.randomUUID().toString().replace("-", "") + extension;
            
            // 创建目录 - 优先使用前端public目录
            String relativePath = "posts/" + dateDir;
            String actualUploadPath = resolveFrontendUploadRoot();
            Path dirPath = Paths.get(actualUploadPath, relativePath);
            Files.createDirectories(dirPath);
            
            // 保存文件
            Path filePath = dirPath.resolve(newFileName);
            file.transferTo(filePath.toFile());
            
            // 返回访问URL
            String fileUrl = urlPrefix + "/" + relativePath + "/" + newFileName;
            
            // 记录到存储文件表
            saveFileRecord(originalFilename, newFileName, contentType, file.getSize(), 
                          fileUrl, relativePath + "/" + newFileName, extension);
            
            Map<String, Object> result = new HashMap<>();
            result.put("url", fileUrl);
            result.put("name", originalFilename);
            
            log.info("文件上传成功: {}", fileUrl);
            return success(result);
            
        } catch (IOException e) {
            log.error("文件上传失败", e);
            return error("文件上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 上传头像到本地
     */
    @PostMapping("/avatar")
    @Operation(summary = "上传头像到本地")
    public AjaxResult<Map<String, Object>> uploadAvatar(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return error("请选择要上传的文件");
        }

        // 1. 检查文件扩展名白名单
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
            log.warn("文件扩展名不允许: {}", extension);
            return error("只允许上传以下格式的图片: jpg, jpeg, png, gif, bmp, webp");
        }

        // 2. 检查MIME类型白名单
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            log.warn("MIME类型不允许: {}", contentType);
            return error("文件类型不合法，只能上传图片文件");
        }

        // 3. 检查文件大小（头像最大2MB）
        if (file.getSize() > 2 * 1024 * 1024) {
            return error("头像大小不能超过2MB");
        }
        
        // 4. 检查文件头魔数
        try {
            if (!isValidImageByMagicNumber(file)) {
                log.warn("文件头魔数校验失败，可能是伪装文件: {}", originalFilename);
                return error("文件内容与扩展名不匹配，请上传真实的图片文件");
            }
        } catch (IOException e) {
            log.error("读取文件头失败", e);
            return error("文件校验失败");
        }

        try {
            // 生成文件名：日期目录 + UUID + 原扩展名
            String dateDir = new SimpleDateFormat("yyyy/MM/dd").format(new Date());
            String newFileName = UUID.randomUUID().toString().replace("-", "") + extension;
            
            // 创建目录 - 头像保存到avatars目录
            String relativePath = "avatars/" + dateDir;
            String actualUploadPath = resolveFrontendUploadRoot();
            Path dirPath = Paths.get(actualUploadPath, relativePath);
            Files.createDirectories(dirPath);
            
            // 保存文件
            Path filePath = dirPath.resolve(newFileName);
            file.transferTo(filePath.toFile());
            
            // 返回访问URL
            String fileUrl = urlPrefix + "/" + relativePath + "/" + newFileName;
            
            // 记录到存储文件表
            saveFileRecord(originalFilename, newFileName, contentType, file.getSize(), 
                          fileUrl, relativePath + "/" + newFileName, extension);
            
            Map<String, Object> result = new HashMap<>();
            result.put("url", fileUrl);
            result.put("name", originalFilename);
            
            log.info("头像上传成功: {}", fileUrl);
            return success(result);
            
        } catch (IOException e) {
            log.error("头像上传失败", e);
            return error("头像上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 保存文件记录到数据库
     */
    private void saveFileRecord(String originalName, String fileName, String contentType, 
                                Long fileSize, String fileUrl, String relativePath, String extension) {
        try {
            StorageFile storageFile = StorageFile.builder()
                    .originalName(originalName)
                    .fileName(fileName)
                    .contentType(contentType)
                    .fileSize(fileSize)
                    .originalFileUrl(fileUrl)
                    .originalRelativePath(relativePath)
                    .fileExtension(extension.replace(".", ""))
                    .storageType("LOCAL")
                    .uploaderId(SecurityUtils.getUserId())
                    .uploaderName(SecurityUtils.getUsername())
                    .uploadTime(new Date())
                    .isDeleted(0)
                    .isTrash(0)
                    .build();
            storageFileService.save(storageFile);
            log.info("文件记录保存成功: {}", fileName);
        } catch (Exception e) {
            log.error("保存文件记录失败", e);
            // 不影响上传结果，只记录日志
        }
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
    private boolean isValidImageByMagicNumber(MultipartFile file) throws IOException {
        try (InputStream is = file.getInputStream()) {
            byte[] header = new byte[12]; // 读取前12字节用于检测
            int bytesRead = is.read(header);
            if (bytesRead < 2) {
                return false;
            }
            
            // 检查是否匹配任一图片格式的魔数
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

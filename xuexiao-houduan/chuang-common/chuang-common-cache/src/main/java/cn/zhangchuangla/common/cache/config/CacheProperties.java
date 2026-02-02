package cn.zhangchuangla.common.cache.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 缓存配置属性
 *
 * @author Chuang
 */
@Data
@ConfigurationProperties(prefix = "cache")
public class CacheProperties {

    /**
     * 缓存模式: local(本地缓存), database(数据库)
     */
    private String mode = "local";

    /**
     * 本地缓存配置
     */
    private LocalCacheConfig local = new LocalCacheConfig();

    /**
     * 扫描批次大小
     */
    private int scanCount = 1000;

    /**
     * 本地缓存配置
     */
    @Data
    public static class LocalCacheConfig {
        /**
         * 默认最大容量
         */
        private long maxSize = 10000;

        /**
         * 默认过期时间（秒）
         */
        private long expireSeconds = 3600;

        /**
         * Token 缓存配置
         */
        private CacheRegionConfig token = new CacheRegionConfig(10000, 7200);

        /**
         * 字典缓存配置
         */
        private CacheRegionConfig dict = new CacheRegionConfig(1000, 86400);

        /**
         * 角色缓存配置
         */
        private CacheRegionConfig role = new CacheRegionConfig(5000, 3600);

        /**
         * 验证码缓存配置
         */
        private CacheRegionConfig captcha = new CacheRegionConfig(10000, 300);

        /**
         * 限流缓存配置
         */
        private CacheRegionConfig rateLimit = new CacheRegionConfig(100000, 60);

        /**
         * 设备缓存配置
         */
        private CacheRegionConfig device = new CacheRegionConfig(10000, 2592000);

        /**
         * 存储配置缓存
         */
        private CacheRegionConfig storage = new CacheRegionConfig(100, 86400);
    }

    /**
     * 缓存区域配置
     */
    @Data
    public static class CacheRegionConfig {
        /**
         * 最大容量
         */
        private long maxSize;

        /**
         * 过期时间（秒）
         */
        private long expireSeconds;

        public CacheRegionConfig() {
        }

        public CacheRegionConfig(long maxSize, long expireSeconds) {
            this.maxSize = maxSize;
            this.expireSeconds = expireSeconds;
        }
    }
}

package cn.zhangchuangla.system.lostfound.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

/**
 * 本地缓存配置
 * 使用 Caffeine 作为本地缓存实现
 *
 * @author Chuang
 */
@Configuration
@EnableCaching
public class CacheConfig {

    /**
     * 缓存名称常量
     */
    public static final String CACHE_CATEGORIES = "categories";
    public static final String CACHE_LOCATIONS = "locations";
    public static final String CACHE_GIFT_CATEGORIES = "giftCategories";
    public static final String CACHE_HOT_POSTS = "hotPosts";

    /**
     * 配置 Caffeine 缓存管理器
     */
    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.setCaffeine(Caffeine.newBuilder()
                // 初始容量
                .initialCapacity(100)
                // 最大容量
                .maximumSize(500)
                // 写入后过期时间（10分钟）
                .expireAfterWrite(10, TimeUnit.MINUTES)
                // 访问后过期时间（5分钟）
                .expireAfterAccess(5, TimeUnit.MINUTES)
                // 开启统计
                .recordStats()
        );
        return cacheManager;
    }
}

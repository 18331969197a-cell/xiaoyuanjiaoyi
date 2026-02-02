package cn.zhangchuangla.common.cache.local;

import cn.zhangchuangla.common.cache.config.CacheProperties;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

/**
 * 本地缓存管理器
 * 管理多个缓存区域，每个区域可以有不同的配置
 *
 * @author Chuang
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
public class LocalCacheManager {

    private final CacheProperties properties;
    private final Map<String, Cache<String, CacheWrapper>> caches = new ConcurrentHashMap<>();

    /**
     * 缓存区域名称常量
     */
    public static final String REGION_TOKEN = "token";
    public static final String REGION_DICT = "dict";
    public static final String REGION_ROLE = "role";
    public static final String REGION_CAPTCHA = "captcha";
    public static final String REGION_RATE_LIMIT = "rateLimit";
    public static final String REGION_DEVICE = "device";
    public static final String REGION_STORAGE = "storage";
    public static final String REGION_DEFAULT = "default";

    public LocalCacheManager(CacheProperties properties) {
        this.properties = properties;
    }

    @PostConstruct
    public void init() {
        CacheProperties.LocalCacheConfig local = properties.getLocal();

        // 初始化各缓存区域
        createCache(REGION_TOKEN, local.getToken());
        createCache(REGION_DICT, local.getDict());
        createCache(REGION_ROLE, local.getRole());
        createCache(REGION_CAPTCHA, local.getCaptcha());
        createCache(REGION_RATE_LIMIT, local.getRateLimit());
        createCache(REGION_DEVICE, local.getDevice());
        createCache(REGION_STORAGE, local.getStorage());
        createCache(REGION_DEFAULT, new CacheProperties.CacheRegionConfig(
                local.getMaxSize(), local.getExpireSeconds()));

        log.info("LocalCacheManager initialized with {} cache regions", caches.size());
    }

    /**
     * 创建缓存区域
     *
     * @param name   区域名称
     * @param config 区域配置
     */
    private void createCache(String name, CacheProperties.CacheRegionConfig config) {
        Cache<String, CacheWrapper> cache = Caffeine.newBuilder()
                .maximumSize(config.getMaxSize())
                .expireAfterWrite(config.getExpireSeconds(), TimeUnit.SECONDS)
                .recordStats()
                .build();
        caches.put(name, cache);
        log.debug("Created cache region: {} with maxSize={}, expireSeconds={}",
                name, config.getMaxSize(), config.getExpireSeconds());
    }

    /**
     * 获取指定区域的缓存
     *
     * @param region 区域名称
     * @return 缓存实例
     */
    public Cache<String, CacheWrapper> getCache(String region) {
        Cache<String, CacheWrapper> cache = caches.get(region);
        if (cache == null) {
            cache = caches.get(REGION_DEFAULT);
        }
        return cache;
    }

    /**
     * 获取默认缓存
     *
     * @return 默认缓存实例
     */
    public Cache<String, CacheWrapper> getDefaultCache() {
        return caches.get(REGION_DEFAULT);
    }

    /**
     * 设置缓存值
     *
     * @param region 区域名称
     * @param key    缓存键
     * @param value  缓存值
     */
    public void set(String region, String key, Object value) {
        getCache(region).put(key, CacheWrapper.of(value));
    }

    /**
     * 设置缓存值（带过期时间）
     *
     * @param region  区域名称
     * @param key     缓存键
     * @param value   缓存值
     * @param timeout 过期时间
     * @param unit    时间单位
     */
    public void set(String region, String key, Object value, long timeout, TimeUnit unit) {
        long expireAtMillis = System.currentTimeMillis() + unit.toMillis(timeout);
        getCache(region).put(key, CacheWrapper.of(value, expireAtMillis));
    }

    /**
     * 获取缓存值
     *
     * @param region 区域名称
     * @param key    缓存键
     * @param <T>    值类型
     * @return 缓存值
     */
    @SuppressWarnings("unchecked")
    public <T> T get(String region, String key) {
        CacheWrapper wrapper = getCache(region).getIfPresent(key);
        if (wrapper == null || wrapper.isExpired()) {
            if (wrapper != null) {
                getCache(region).invalidate(key);
            }
            return null;
        }
        return (T) wrapper.getValue();
    }

    /**
     * 删除缓存
     *
     * @param region 区域名称
     * @param key    缓存键
     */
    public void delete(String region, String key) {
        getCache(region).invalidate(key);
    }

    /**
     * 清空指定区域的缓存
     *
     * @param region 区域名称
     */
    public void clear(String region) {
        getCache(region).invalidateAll();
    }

    /**
     * 清空所有缓存
     */
    public void clearAll() {
        caches.values().forEach(Cache::invalidateAll);
    }

    /**
     * 获取缓存统计信息
     *
     * @param region 区域名称
     * @return 统计信息
     */
    public String getStats(String region) {
        return getCache(region).stats().toString();
    }

    /**
     * 获取所有区域的统计信息
     *
     * @return 统计信息映射
     */
    public Map<String, String> getAllStats() {
        Map<String, String> stats = new ConcurrentHashMap<>();
        caches.forEach((name, cache) -> stats.put(name, cache.stats().toString()));
        return stats;
    }
}

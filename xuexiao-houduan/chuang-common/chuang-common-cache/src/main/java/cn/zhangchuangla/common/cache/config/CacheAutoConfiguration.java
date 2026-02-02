package cn.zhangchuangla.common.cache.config;

import cn.zhangchuangla.common.cache.core.CacheProvider;
import cn.zhangchuangla.common.cache.core.HashCacheProvider;
import cn.zhangchuangla.common.cache.core.ZSetCacheProvider;
import cn.zhangchuangla.common.cache.debounce.Debouncer;
import cn.zhangchuangla.common.cache.debounce.LocalDebouncer;
import cn.zhangchuangla.common.cache.device.DeviceStore;
import cn.zhangchuangla.common.cache.device.LocalDeviceStore;
import cn.zhangchuangla.common.cache.local.LocalCacheManager;
import cn.zhangchuangla.common.cache.local.LocalCacheProvider;
import cn.zhangchuangla.common.cache.local.LocalHashCacheProvider;
import cn.zhangchuangla.common.cache.local.LocalZSetCacheProvider;
import cn.zhangchuangla.common.cache.ratelimit.RateLimiter;
import cn.zhangchuangla.common.cache.ratelimit.SlidingWindowRateLimiter;
import cn.zhangchuangla.common.cache.security.LocalLoginFrequencyStore;
import cn.zhangchuangla.common.cache.security.LocalPasswordRetryStore;
import cn.zhangchuangla.common.cache.security.LoginFrequencyStore;
import cn.zhangchuangla.common.cache.security.PasswordRetryStore;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 缓存自动配置类
 *
 * @author Chuang
 */
@Slf4j
@Configuration
@EnableConfigurationProperties(CacheProperties.class)
public class CacheAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean(CacheProvider.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public CacheProvider localCacheProvider(CacheProperties properties) {
        log.info("Initializing LocalCacheProvider with mode: local");
        return new LocalCacheProvider(properties);
    }

    @Bean
    @ConditionalOnMissingBean(HashCacheProvider.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public HashCacheProvider localHashCacheProvider(CacheProperties properties) {
        log.info("Initializing LocalHashCacheProvider");
        return new LocalHashCacheProvider(properties);
    }

    @Bean
    @ConditionalOnMissingBean(ZSetCacheProvider.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public ZSetCacheProvider localZSetCacheProvider(CacheProperties properties) {
        log.info("Initializing LocalZSetCacheProvider");
        return new LocalZSetCacheProvider(properties);
    }

    @Bean
    @ConditionalOnMissingBean(LocalCacheManager.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public LocalCacheManager localCacheManager(CacheProperties properties) {
        log.info("Initializing LocalCacheManager");
        return new LocalCacheManager(properties);
    }

    @Bean
    @ConditionalOnMissingBean(DeviceStore.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public DeviceStore localDeviceStore(CacheProvider cacheProvider, 
                                        HashCacheProvider hashCacheProvider,
                                        ZSetCacheProvider zSetCacheProvider) {
        log.info("Initializing LocalDeviceStore");
        return new LocalDeviceStore(cacheProvider, hashCacheProvider, zSetCacheProvider);
    }

    @Bean
    @ConditionalOnMissingBean(RateLimiter.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public RateLimiter slidingWindowRateLimiter(CacheProvider cacheProvider) {
        log.info("Initializing SlidingWindowRateLimiter");
        return new SlidingWindowRateLimiter(cacheProvider);
    }

    @Bean
    @ConditionalOnMissingBean(Debouncer.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public Debouncer localDebouncer(CacheProvider cacheProvider) {
        log.info("Initializing LocalDebouncer");
        return new LocalDebouncer(cacheProvider);
    }

    @Bean
    @ConditionalOnMissingBean(PasswordRetryStore.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public PasswordRetryStore localPasswordRetryStore(CacheProvider cacheProvider) {
        log.info("Initializing LocalPasswordRetryStore");
        return new LocalPasswordRetryStore(cacheProvider);
    }

    @Bean
    @ConditionalOnMissingBean(LoginFrequencyStore.class)
    @ConditionalOnProperty(name = "cache.mode", havingValue = "local", matchIfMissing = true)
    public LoginFrequencyStore localLoginFrequencyStore(CacheProvider cacheProvider) {
        log.info("Initializing LocalLoginFrequencyStore");
        return new LocalLoginFrequencyStore(cacheProvider);
    }
}

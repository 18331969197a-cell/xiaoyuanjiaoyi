package cn.zhangchuangla.system.storage.core.loader;

import cn.zhangchuangla.common.cache.core.CacheProvider;

/**
 * @author Chuang
 * <p>
 * created on 2025/6/27 07:21
 * <p>
 * 存储服务加载器接口
 */
public interface StorageLoader {

    /**
     * 获取存储类型
     *
     * @return 存储类型
     */
    String getStorageType();

    /**
     * 加载存储配置,将存储配置保存到缓存中
     *
     * @param json          存储配置JSON
     * @param cacheProvider 缓存提供者
     */
    void loadConfig(String json, CacheProvider cacheProvider);
}

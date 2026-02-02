package cn.zhangchuangla.system.lostfound.task;

import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 浏览量定时同步任务
 * 使用内存计数器累积浏览量，定时批量同步到数据库
 * 
 * @author Chuang
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ViewCountScheduleTask {

    private final BizPostMapper postMapper;
    
    /**
     * 内存中的浏览量计数器
     * key: 帖子ID, value: 累积的浏览量
     */
    private static final ConcurrentHashMap<Long, AtomicInteger> VIEW_COUNT_CACHE = new ConcurrentHashMap<>();

    /**
     * 增加帖子浏览量（内存累积）
     * 
     * @param postId 帖子ID
     */
    public static void incrementViewCount(Long postId) {
        if (postId == null) return;
        VIEW_COUNT_CACHE.computeIfAbsent(postId, k -> new AtomicInteger(0)).incrementAndGet();
    }

    /**
     * 定时同步浏览量到数据库
     * 每5分钟执行一次
     */
    @Scheduled(fixedRate = 5 * 60 * 1000)
    public void syncViewCountToDatabase() {
        if (VIEW_COUNT_CACHE.isEmpty()) {
            return;
        }
        
        log.info("开始同步浏览量到数据库，待同步帖子数: {}", VIEW_COUNT_CACHE.size());
        
        int successCount = 0;
        int failCount = 0;
        
        // 遍历并清空缓存
        for (Map.Entry<Long, AtomicInteger> entry : VIEW_COUNT_CACHE.entrySet()) {
            Long postId = entry.getKey();
            int count = entry.getValue().getAndSet(0);
            
            if (count > 0) {
                try {
                    // 批量更新浏览量
                    postMapper.incrementViewCountBatch(postId, count);
                    successCount++;
                } catch (Exception e) {
                    // 更新失败，将计数加回去
                    VIEW_COUNT_CACHE.computeIfAbsent(postId, k -> new AtomicInteger(0)).addAndGet(count);
                    failCount++;
                    log.warn("同步帖子浏览量失败: postId={}, count={}", postId, count, e);
                }
            }
            
            // 清理计数为0的条目
            VIEW_COUNT_CACHE.computeIfPresent(postId, (k, v) -> v.get() == 0 ? null : v);
        }
        
        if (successCount > 0 || failCount > 0) {
            log.info("浏览量同步完成，成功: {}, 失败: {}", successCount, failCount);
        }
    }

    /**
     * 获取缓存中的浏览量（用于实时显示）
     * 
     * @param postId 帖子ID
     * @return 缓存中的浏览量增量
     */
    public static int getCachedViewCount(Long postId) {
        if (postId == null) return 0;
        AtomicInteger count = VIEW_COUNT_CACHE.get(postId);
        return count != null ? count.get() : 0;
    }
}

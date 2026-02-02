package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.service.SearchService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

/**
 * 搜索服务实现
 * 使用内存统计热门搜索词
 *
 * @author Chuang
 */
@Slf4j
@Service
public class SearchServiceImpl implements SearchService {

    /**
     * 搜索词计数器
     * key: 搜索关键词, value: 搜索次数
     */
    private final ConcurrentHashMap<String, AtomicLong> searchCountMap = new ConcurrentHashMap<>();

    /**
     * 最大缓存关键词数量
     */
    private static final int MAX_KEYWORDS = 1000;

    @Override
    public void recordSearch(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return;
        }
        
        String normalizedKeyword = keyword.trim().toLowerCase();
        
        // 过滤过短或过长的关键词
        if (normalizedKeyword.length() < 2 || normalizedKeyword.length() > 50) {
            return;
        }
        
        // 限制缓存大小
        if (searchCountMap.size() >= MAX_KEYWORDS && !searchCountMap.containsKey(normalizedKeyword)) {
            // 移除计数最小的关键词
            cleanupLowCountKeywords();
        }
        
        searchCountMap.computeIfAbsent(normalizedKeyword, k -> new AtomicLong(0)).incrementAndGet();
    }

    @Override
    public List<String> getHotSearchKeywords(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        
        return searchCountMap.entrySet().stream()
                .sorted(Map.Entry.comparingByValue(Comparator.comparingLong(AtomicLong::get).reversed()))
                .limit(limit)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
    }

    @Override
    public void clearSearchStats() {
        searchCountMap.clear();
        log.info("搜索统计已清空");
    }

    /**
     * 清理低频关键词
     */
    private void cleanupLowCountKeywords() {
        // 找出计数最小的20%关键词并移除
        int removeCount = MAX_KEYWORDS / 5;
        
        List<String> toRemove = searchCountMap.entrySet().stream()
                .sorted(Map.Entry.comparingByValue(Comparator.comparingLong(AtomicLong::get)))
                .limit(removeCount)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
        
        toRemove.forEach(searchCountMap::remove);
        log.debug("清理了 {} 个低频搜索词", toRemove.size());
    }

    /**
     * 定时衰减搜索计数（每天凌晨3点）
     * 使计数逐渐衰减，保持热门搜索的时效性
     */
    @Scheduled(cron = "0 0 3 * * ?")
    public void decaySearchCounts() {
        log.info("开始衰减搜索计数...");
        
        List<String> toRemove = new ArrayList<>();
        
        searchCountMap.forEach((keyword, count) -> {
            // 衰减50%
            long newCount = count.get() / 2;
            if (newCount <= 0) {
                toRemove.add(keyword);
            } else {
                count.set(newCount);
            }
        });
        
        // 移除计数为0的关键词
        toRemove.forEach(searchCountMap::remove);
        
        log.info("搜索计数衰减完成，移除 {} 个过期关键词", toRemove.size());
    }
}

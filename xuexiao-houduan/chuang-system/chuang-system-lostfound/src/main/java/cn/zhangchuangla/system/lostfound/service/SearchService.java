package cn.zhangchuangla.system.lostfound.service;

import java.util.List;

/**
 * 搜索服务接口
 *
 * @author Chuang
 */
public interface SearchService {

    /**
     * 记录搜索关键词
     *
     * @param keyword 搜索关键词
     */
    void recordSearch(String keyword);

    /**
     * 获取热门搜索词
     *
     * @param limit 返回数量限制
     * @return 热门搜索词列表
     */
    List<String> getHotSearchKeywords(int limit);

    /**
     * 清空搜索统计
     */
    void clearSearchStats();
}

package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizFavorite;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * 收藏服务接口
 *
 * @author Chuang
 */
public interface FavoriteService {

    /**
     * 添加收藏
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     */
    void addFavorite(Long userId, Long postId);

    /**
     * 取消收藏
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     */
    void removeFavorite(Long userId, Long postId);

    /**
     * 检查是否已收藏
     *
     * @param userId 用户ID
     * @param postId 帖子ID
     * @return 是否已收藏
     */
    boolean isFavorited(Long userId, Long postId);

    /**
     * 获取用户收藏列表
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @return 收藏的帖子列表
     */
    Page<BizPost> getUserFavorites(Page<BizPost> page, Long userId);

    /**
     * 获取帖子收藏数
     *
     * @param postId 帖子ID
     * @return 收藏数
     */
    long getFavoriteCount(Long postId);
}

package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 帖子 Mapper
 *
 * @author Chuang
 */
public interface BizPostMapper extends BaseMapper<BizPost> {

    /**
     * 分页查询帖子（带关联信息）
     *
     * @param page       分页对象
     * @param userId     用户ID（可选）
     * @param status     状态（可选）
     * @param postType   类型（可选）
     * @param categoryId 分类ID（可选）
     * @param locationId 地点ID（可选）
     * @param keyword    关键词（可选）
     * @return 分页结果
     */
    Page<BizPost> selectPostPage(Page<BizPost> page,
                                  @Param("userId") Long userId,
                                  @Param("status") String status,
                                  @Param("postType") String postType,
                                  @Param("categoryId") Long categoryId,
                                  @Param("locationId") Long locationId,
                                  @Param("keyword") String keyword);

    /**
     * 增加浏览量
     *
     * @param postId 帖子ID
     * @return 影响行数
     */
    int incrementViewCount(@Param("postId") Long postId);

    /**
     * 增加收藏数
     *
     * @param postId 帖子ID
     * @param delta  变化量（正数增加，负数减少）
     * @return 影响行数
     */
    int updateFavCount(@Param("postId") Long postId, @Param("delta") int delta);

    /**
     * 增加评论数
     *
     * @param postId 帖子ID
     * @param delta  变化量（正数增加，负数减少）
     * @return 影响行数
     */
    int updateCommentCount(@Param("postId") Long postId, @Param("delta") int delta);

    /**
     * 查询单个帖子（带关联信息）
     *
     * @param postId 帖子ID
     * @return 帖子信息
     */
    BizPost selectPostById(@Param("postId") Long postId);

    /**
     * 批量查询帖子（带关联信息）
     *
     * @param postIds 帖子ID列表
     * @return 帖子列表
     */
    List<BizPost> selectPostsByIds(@Param("postIds") List<Long> postIds);

    /**
     * 批量增加浏览量
     *
     * @param postId 帖子ID
     * @param count  增加的数量
     * @return 影响行数
     */
    int incrementViewCountBatch(@Param("postId") Long postId, @Param("count") int count);
}

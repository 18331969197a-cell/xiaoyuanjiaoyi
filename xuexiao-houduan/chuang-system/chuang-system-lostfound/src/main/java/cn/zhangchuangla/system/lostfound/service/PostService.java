package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.PostTypeEnum;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.util.List;

/**
 * 帖子服务接口
 *
 * @author Chuang
 */
public interface PostService {

    /**
     * 创建帖子
     *
     * @param post   帖子信息
     * @param userId 用户ID
     * @return 帖子ID
     */
    Long createPost(BizPost post, Long userId);

    /**
     * 更新帖子
     *
     * @param post   帖子信息
     * @param userId 用户ID
     */
    void updatePost(BizPost post, Long userId);

    /**
     * 保存草稿
     *
     * @param post   帖子信息
     * @param userId 用户ID
     * @return 帖子ID
     */
    Long saveDraft(BizPost post, Long userId);

    /**
     * 提交草稿审核
     *
     * @param postId 帖子ID
     * @param userId 用户ID
     */
    void submitDraft(Long postId, Long userId);

    /**
     * 删除帖子（逻辑删除）
     *
     * @param postId 帖子ID
     * @param userId 用户ID
     */
    void deletePost(Long postId, Long userId);

    /**
     * 获取帖子详情
     *
     * @param postId 帖子ID
     * @return 帖子信息
     */
    BizPost getPostById(Long postId);

    /**
     * 分页查询帖子列表
     *
     * @param page       分页参数
     * @param postType   帖子类型
     * @param status     状态
     * @param categoryId 分类ID
     * @param locationId 地点ID
     * @param keyword    关键词
     * @return 帖子列表
     */
    Page<BizPost> queryPostList(Page<BizPost> page, PostTypeEnum postType, PostStatusEnum status,
                                Long categoryId, Long locationId, String keyword);

    /**
     * 搜索帖子
     *
     * @param page    分页参数
     * @param keyword 关键词
     * @return 帖子列表
     */
    Page<BizPost> searchPosts(Page<BizPost> page, String keyword);

    /**
     * 增加浏览量
     *
     * @param postId 帖子ID
     */
    void incrementViewCount(Long postId);

    /**
     * 获取用户发布的帖子
     *
     * @param page     分页参数
     * @param userId   用户ID
     * @param status   状态
     * @param postType 帖子类型
     * @return 帖子列表
     */
    Page<BizPost> getUserPosts(Page<BizPost> page, Long userId, PostStatusEnum status, PostTypeEnum postType);

    /**
     * 获取用户草稿
     *
     * @param userId 用户ID
     * @return 草稿列表
     */
    List<BizPost> getUserDrafts(Long userId);

    /**
     * 检测敏感词
     *
     * @param content 内容
     * @return 是否包含敏感词
     */
    boolean containsSensitiveWords(String content);

    /**
     * 审核通过
     *
     * @param postId  帖子ID
     * @param adminId 管理员ID
     */
    void approve(Long postId, Long adminId);

    /**
     * 审核拒绝
     *
     * @param postId  帖子ID
     * @param reason  拒绝原因
     * @param adminId 管理员ID
     */
    void reject(Long postId, String reason, Long adminId);

    /**
     * 下架帖子
     *
     * @param postId  帖子ID
     * @param adminId 管理员ID
     */
    void offline(Long postId, Long adminId);

    /**
     * 设置置顶
     *
     * @param postId 帖子ID
     * @param isTop  是否置顶
     */
    void setTop(Long postId, Boolean isTop);

    /**
     * 设置推荐
     *
     * @param postId      帖子ID
     * @param isRecommend 是否推荐
     */
    void setRecommend(Long postId, Boolean isRecommend);

    /**
     * 更新帖子状态
     *
     * @param postId 帖子ID
     * @param status 状态
     */
    void updateStatus(Long postId, PostStatusEnum status);
}

package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizComment;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * 评论服务接口
 *
 * @author Chuang
 */
public interface CommentService {

    /**
     * 创建评论
     *
     * @param comment 评论信息
     * @param userId  用户ID
     * @return 评论ID
     */
    Long createComment(BizComment comment, Long userId);

    /**
     * 删除评论
     *
     * @param commentId 评论ID
     * @param userId    用户ID
     */
    void deleteComment(Long commentId, Long userId);

    /**
     * 获取帖子评论列表
     *
     * @param page   分页参数
     * @param postId 帖子ID
     * @return 评论列表
     */
    Page<BizComment> getPostComments(Page<BizComment> page, Long postId);

    /**
     * 审核通过
     *
     * @param commentId 评论ID
     */
    void approve(Long commentId);

    /**
     * 审核拒绝
     *
     * @param commentId 评论ID
     */
    void reject(Long commentId);

    /**
     * 管理员获取评论列表
     *
     * @param page   分页参数
     * @param status 状态
     * @return 评论列表
     */
    Page<BizComment> adminList(Page<BizComment> page, Integer status);

    /**
     * 管理员删除评论
     *
     * @param commentId 评论ID
     */
    void adminDelete(Long commentId);

    /**
     * 检测敏感词
     *
     * @param content 内容
     * @return 是否包含敏感词
     */
    boolean containsSensitiveWords(String content);
}

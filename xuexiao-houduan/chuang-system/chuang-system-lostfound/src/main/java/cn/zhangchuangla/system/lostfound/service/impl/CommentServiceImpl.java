package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizCommentMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizComment;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.CommentService;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.regex.Pattern;

/**
 * 评论服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {

    private final BizCommentMapper commentMapper;
    private final BizPostMapper postMapper;
    @Lazy
    private final NotificationService notificationService;

    private static final Pattern PHONE_PATTERN = Pattern.compile("\\d{11}");
    private static final Pattern WECHAT_PATTERN = Pattern.compile("[a-zA-Z][\\w-]{5,19}");

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createComment(BizComment comment, Long userId) {
        if (containsSensitiveWords(comment.getContent())) {
            throw new BusinessException(ErrorCode.POST_SENSITIVE_CONTENT, "评论内容包含敏感信息");
        }
        comment.setUserId(userId);
        comment.setStatus("PUBLISHED");
        comment.setCreateTime(LocalDateTime.now());
        commentMapper.insert(comment);
        // 更新帖子评论数
        postMapper.updateCommentCount(comment.getPostId(), 1);
        
        // 发送评论通知给帖子发布者
        sendCommentNotification(comment, userId);
        
        return comment.getId();
    }

    /**
     * 发送评论通知给帖子发布者
     */
    private void sendCommentNotification(BizComment comment, Long commentUserId) {
        try {
            BizPost post = postMapper.selectById(comment.getPostId());
            if (post != null && !post.getCreatedBy().equals(commentUserId)) {
                // 不通知自己评论自己的帖子
                String contentPreview = comment.getContent();
                if (contentPreview != null && contentPreview.length() > 50) {
                    contentPreview = contentPreview.substring(0, 50) + "...";
                }
                notificationService.createNotification(
                    post.getCreatedBy(),
                    NotificationTypeEnum.COMMENT,
                    "新评论",
                    "您的帖子「" + post.getTitle() + "」收到了新评论：" + contentPreview,
                    "POST",
                    post.getId()
                );
            }
        } catch (Exception e) {
            // 通知发送失败不影响评论创建
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteComment(Long commentId, Long userId) {
        BizComment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "评论不存在");
        }
        if (!comment.getUserId().equals(userId)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权删除此评论");
        }
        commentMapper.deleteById(commentId);
        // 更新帖子评论数
        postMapper.updateCommentCount(comment.getPostId(), -1);
    }

    @Override
    public Page<BizComment> getPostComments(Page<BizComment> page, Long postId) {
        // 使用关联查询获取评论及用户名
        return commentMapper.selectPostCommentsWithUserName(page, postId, "PUBLISHED");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approve(Long commentId) {
        BizComment comment = new BizComment();
        comment.setId(commentId);
        comment.setStatus("PUBLISHED");
        commentMapper.updateById(comment);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reject(Long commentId) {
        BizComment comment = new BizComment();
        comment.setId(commentId);
        comment.setStatus("REJECTED");
        commentMapper.updateById(comment);
    }

    @Override
    public Page<BizComment> adminList(Page<BizComment> page, Integer status) {
        String statusStr = null;
        if (status != null) {
            statusStr = status == 0 ? "PENDING" : (status == 1 ? "PUBLISHED" : "REJECTED");
        }
        return commentMapper.selectAdminCommentsWithDetail(page, statusStr);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void adminDelete(Long commentId) {
        BizComment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "评论不存在");
        }
        commentMapper.deleteById(commentId);
        // 更新帖子评论数
        postMapper.updateCommentCount(comment.getPostId(), -1);
    }

    @Override
    public boolean containsSensitiveWords(String content) {
        if (!StringUtils.hasText(content)) {
            return false;
        }
        if (PHONE_PATTERN.matcher(content).find()) {
            return true;
        }
        return WECHAT_PATTERN.matcher(content).find();
    }
}

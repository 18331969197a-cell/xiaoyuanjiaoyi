package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.PostTypeEnum;
import cn.zhangchuangla.system.lostfound.enums.RewardStatusEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import cn.zhangchuangla.system.lostfound.service.PostService;
import cn.zhangchuangla.system.lostfound.service.VerificationService;
import cn.zhangchuangla.system.lostfound.util.SensitiveWordFilter;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.regex.Pattern;

/**
 * 帖子服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class PostServiceImpl implements PostService {

    private final BizPostMapper postMapper;
    private final SensitiveWordFilter sensitiveWordFilter;
    @Lazy
    private final NotificationService notificationService;
    @Lazy
    private final VerificationService verificationService;

    // 中国手机号正则（更精确：1开头，第二位3-9，共11位）
    private static final Pattern PHONE_PATTERN = Pattern.compile("1[3-9]\\d{9}");
    // 微信号正则（字母开头，6-20位，允许字母数字下划线减号）
    private static final Pattern WECHAT_PATTERN = Pattern.compile("[a-zA-Z][a-zA-Z0-9_-]{5,19}");
    // QQ号正则（5-11位数字，不以0开头）
    private static final Pattern QQ_PATTERN = Pattern.compile("[1-9]\\d{4,10}");
    // 邮箱正则
    private static final Pattern EMAIL_PATTERN = Pattern.compile("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}");
    
    // 常见联系方式关键词
    private static final Pattern CONTACT_KEYWORD_PATTERN = Pattern.compile(
            "(?i)(加我|联系我|私聊|加微|加v|加V|wx|WX|vx|VX|微信号|QQ号|扣扣|企鹅|手机号|电话号|联系方式)"
    );

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPost(BizPost post, Long userId) {
        // 检查用户是否已完成身份认证
        if (!verificationService.isVerified(userId)) {
            throw new BusinessException(ErrorCode.USER_NOT_VERIFIED);
        }
        // 检测敏感词
        if (containsSensitiveWords(post.getTitle()) || containsSensitiveWords(post.getDescription())) {
            throw new BusinessException(ErrorCode.POST_SENSITIVE_CONTENT);
        }
        // 设置默认值
        post.setCreatedBy(userId);
        post.setStatus(PostStatusEnum.PENDING);
        post.setViewCount(0);
        post.setFavCount(0);
        post.setCommentCount(0);
        post.setIsTop(false);
        post.setIsRecommend(false);
        initRewardStatus(post);
        postMapper.insert(post);
        return post.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePost(BizPost post, Long userId) {
        BizPost existing = postMapper.selectById(post.getId());
        if (existing == null) {
            throw new BusinessException(ErrorCode.POST_NOT_FOUND);
        }
        if (!existing.getCreatedBy().equals(userId)) {
            throw new BusinessException(ErrorCode.POST_NO_PERMISSION);
        }
        // 检测敏感词
        if (containsSensitiveWords(post.getTitle()) || containsSensitiveWords(post.getDescription())) {
            throw new BusinessException(ErrorCode.POST_SENSITIVE_CONTENT);
        }
        initRewardStatus(post);
        postMapper.updateById(post);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long saveDraft(BizPost post, Long userId) {
        post.setCreatedBy(userId);
        post.setStatus(PostStatusEnum.DRAFT);
        post.setViewCount(0);
        post.setFavCount(0);
        post.setCommentCount(0);
        post.setIsTop(false);
        post.setIsRecommend(false);
        initRewardStatus(post);
        if (post.getId() != null) {
            postMapper.updateById(post);
            return post.getId();
        } else {
            postMapper.insert(post);
            return post.getId();
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitDraft(Long postId, Long userId) {
        BizPost post = postMapper.selectById(postId);
        if (post == null) {
            throw new BusinessException(ErrorCode.POST_NOT_FOUND);
        }
        if (!post.getCreatedBy().equals(userId)) {
            throw new BusinessException(ErrorCode.POST_NO_PERMISSION);
        }
        if (post.getStatus() != PostStatusEnum.DRAFT) {
            throw new BusinessException(ErrorCode.POST_STATUS_ERROR, "只有草稿状态的帖子才能提交审核");
        }
        // 检测敏感词
        if (containsSensitiveWords(post.getTitle()) || containsSensitiveWords(post.getDescription())) {
            throw new BusinessException(ErrorCode.POST_SENSITIVE_CONTENT);
        }
        post.setStatus(PostStatusEnum.PENDING);
        postMapper.updateById(post);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePost(Long postId, Long userId) {
        BizPost post = postMapper.selectById(postId);
        if (post == null) {
            throw new BusinessException(ErrorCode.POST_NOT_FOUND);
        }
        if (!post.getCreatedBy().equals(userId)) {
            throw new BusinessException(ErrorCode.POST_NO_PERMISSION);
        }
        postMapper.deleteById(postId);
    }

    @Override
    public BizPost getPostById(Long postId) {
        // 使用带关联信息的查询（包含用户名、分类名、地点名）
        return postMapper.selectPostById(postId);
    }

    @Override
    public Page<BizPost> queryPostList(Page<BizPost> page, PostTypeEnum postType, PostStatusEnum status,
                                       Long categoryId, Long locationId, String keyword) {
        // 使用带关联信息的查询（包含用户名、分类名、地点名）
        String statusCode = status != null ? status.getCode() : null;
        String typeCode = postType != null ? postType.getCode() : null;
        return postMapper.selectPostPage(page, null, statusCode, typeCode, categoryId, locationId, keyword);
    }

    @Override
    public Page<BizPost> searchPosts(Page<BizPost> page, String keyword) {
        // 使用带关联信息的查询（包含用户名、分类名、地点名）
        return postMapper.selectPostPage(page, null, PostStatusEnum.PUBLISHED.getCode(), null, null, null, keyword);
    }

    @Override
    public void incrementViewCount(Long postId) {
        postMapper.incrementViewCount(postId);
    }

    @Override
    public Page<BizPost> getUserPosts(Page<BizPost> page, Long userId, PostStatusEnum status, PostTypeEnum postType) {
        String statusCode = status != null ? status.getCode() : null;
        String typeCode = postType != null ? postType.getCode() : null;
        return postMapper.selectPostPage(page, userId, statusCode, typeCode, null, null, null);
    }

    @Override
    public List<BizPost> getUserDrafts(Long userId) {
        LambdaQueryWrapper<BizPost> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizPost::getCreatedBy, userId);
        wrapper.eq(BizPost::getStatus, PostStatusEnum.DRAFT);
        wrapper.orderByDesc(BizPost::getCreateTime);
        return postMapper.selectList(wrapper);
    }

    /**
     * 初始化悬赏字段（兼容无悬赏的帖子）
     */
    private void initRewardStatus(BizPost post) {
        if (post.getRewardAmount() != null && post.getRewardAmount().compareTo(java.math.BigDecimal.ZERO) > 0) {
            if (post.getRewardStatus() == null) {
                post.setRewardStatus(RewardStatusEnum.HOLD);
            }
        } else {
            post.setRewardAmount(null);
            post.setRewardStatus(RewardStatusEnum.NONE);
        }
    }

    @Override
    public boolean containsSensitiveWords(String content) {
        if (!StringUtils.hasText(content)) {
            return false;
        }
        // 移除空格和特殊字符后检测（防止用户用空格分隔绕过检测）
        String normalizedContent = content.replaceAll("[\\s\\-_.]", "");
        
        // 使用DFA敏感词库检测
        if (sensitiveWordFilter.containsSensitiveWord(content) || 
            sensitiveWordFilter.containsSensitiveWord(normalizedContent)) {
            return true;
        }
        
        // 检测手机号（中国手机号：1开头，第二位3-9，共11位）
        if (PHONE_PATTERN.matcher(normalizedContent).find()) {
            return true;
        }
        // 检测QQ号（5-11位数字）
        if (QQ_PATTERN.matcher(normalizedContent).find()) {
            return true;
        }
        // 检测邮箱
        if (EMAIL_PATTERN.matcher(content).find()) {
            return true;
        }
        // 检测联系方式关键词
        if (CONTACT_KEYWORD_PATTERN.matcher(content).find()) {
            return true;
        }
        // 检测微信号（需要结合上下文，避免误判普通英文单词）
        // 只有当内容中包含"微信"、"wx"等关键词时才检测微信号格式
        if (content.toLowerCase().contains("微信") || content.toLowerCase().contains("wx") || 
            content.toLowerCase().contains("vx") || content.toLowerCase().contains("加v")) {
            if (WECHAT_PATTERN.matcher(content).find()) {
                return true;
            }
        }
        return false;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approve(Long postId, Long adminId) {
        BizPost existingPost = postMapper.selectById(postId);
        if (existingPost == null) {
            throw new BusinessException(ErrorCode.POST_NOT_FOUND);
        }
        
        BizPost post = new BizPost();
        post.setId(postId);
        post.setStatus(PostStatusEnum.PUBLISHED);
        post.setAuditBy(adminId);
        post.setAuditAt(LocalDateTime.now());
        postMapper.updateById(post);
        
        // 发送通知给帖子发布者
        if (notificationService != null) {
            notificationService.createNotification(
                existingPost.getCreatedBy(),
                NotificationTypeEnum.SYSTEM,
                "帖子审核通过",
                "您发布的「" + existingPost.getTitle() + "」已通过审核，现已发布。",
                "POST",
                postId
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reject(Long postId, String reason, Long adminId) {
        BizPost existingPost = postMapper.selectById(postId);
        if (existingPost == null) {
            throw new BusinessException(ErrorCode.POST_NOT_FOUND);
        }
        
        BizPost post = new BizPost();
        post.setId(postId);
        post.setStatus(PostStatusEnum.REJECTED);
        post.setAuditBy(adminId);
        post.setAuditAt(LocalDateTime.now());
        post.setAuditReason(reason);
        postMapper.updateById(post);
        
        // 发送通知给帖子发布者
        if (notificationService != null) {
            notificationService.createNotification(
                existingPost.getCreatedBy(),
                NotificationTypeEnum.SYSTEM,
                "帖子审核未通过",
                "您发布的「" + existingPost.getTitle() + "」未通过审核，原因：" + reason,
                "POST",
                postId
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void offline(Long postId, Long adminId) {
        BizPost existingPost = postMapper.selectById(postId);
        if (existingPost == null) {
            throw new BusinessException(ErrorCode.POST_NOT_FOUND);
        }
        
        BizPost post = new BizPost();
        post.setId(postId);
        post.setStatus(PostStatusEnum.OFFLINE);
        post.setAuditBy(adminId);
        post.setAuditAt(LocalDateTime.now());
        postMapper.updateById(post);
        
        // 发送下架通知给帖子发布者
        if (notificationService != null) {
            notificationService.createNotification(
                existingPost.getCreatedBy(),
                NotificationTypeEnum.POST,
                "帖子已下架",
                "您发布的「" + existingPost.getTitle() + "」已被管理员下架，如有疑问请联系管理员。",
                "POST",
                postId
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setTop(Long postId, Boolean isTop) {
        BizPost post = new BizPost();
        post.setId(postId);
        post.setIsTop(isTop);
        postMapper.updateById(post);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setRecommend(Long postId, Boolean isRecommend) {
        BizPost post = new BizPost();
        post.setId(postId);
        post.setIsRecommend(isRecommend);
        postMapper.updateById(post);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long postId, PostStatusEnum status) {
        BizPost existingPost = postMapper.selectById(postId);
        
        BizPost post = new BizPost();
        post.setId(postId);
        post.setStatus(status);
        postMapper.updateById(post);
        
        // 如果状态变为已解决，发送通知
        if (status == PostStatusEnum.CLOSED && existingPost != null && notificationService != null) {
            notificationService.createNotification(
                existingPost.getCreatedBy(),
                NotificationTypeEnum.POST,
                "帖子已解决",
                "您发布的「" + existingPost.getTitle() + "」已标记为已解决。",
                "POST",
                postId
            );
        }
    }
}

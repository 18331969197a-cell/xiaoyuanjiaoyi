package cn.zhangchuangla.system.lostfound.task;

import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 帖子定时任务
 * 
 * @author Chuang
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PostScheduleTask {

    private final BizPostMapper postMapper;
    private final NotificationService notificationService;
    
    /**
     * 过期帖子自动下架
     * 每天凌晨2点执行，将超过30天未更新的已发布帖子自动下架
     */
    @Scheduled(cron = "0 0 2 * * ?")
    @Transactional(rollbackFor = Exception.class)
    public void autoOfflineExpiredPosts() {
        log.info("开始执行过期帖子自动下架任务...");
        
        // 查询超过30天未更新的已发布帖子
        LocalDateTime expireTime = LocalDateTime.now().minusDays(30);
        
        LambdaQueryWrapper<BizPost> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(BizPost::getStatus, PostStatusEnum.PUBLISHED)
                .lt(BizPost::getUpdateTime, expireTime);
        
        List<BizPost> expiredPosts = postMapper.selectList(queryWrapper);
        
        if (expiredPosts.isEmpty()) {
            log.info("没有需要下架的过期帖子");
            return;
        }
        
        // 批量更新状态为下架
        for (BizPost post : expiredPosts) {
            LambdaUpdateWrapper<BizPost> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(BizPost::getId, post.getId())
                    .set(BizPost::getStatus, PostStatusEnum.OFFLINE);
            postMapper.update(null, updateWrapper);
            
            // 发送通知给帖子发布者
            try {
                notificationService.createNotification(
                    post.getCreatedBy(),
                    NotificationTypeEnum.POST,
                    "帖子已自动下架",
                    "您发布的「" + post.getTitle() + "」因超过30天未更新，已自动下架。如需继续展示，请重新发布。",
                    "POST",
                    post.getId()
                );
            } catch (Exception e) {
                log.warn("发送下架通知失败: postId={}", post.getId(), e);
            }
        }
        
        log.info("过期帖子自动下架任务完成，共下架 {} 条帖子", expiredPosts.size());
    }
}

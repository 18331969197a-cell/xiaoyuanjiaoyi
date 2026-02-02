package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.entity.security.SysUser;
import cn.zhangchuangla.common.websocket.constant.WebSocketDestinations;
import cn.zhangchuangla.common.websocket.service.WebSocketPublisher;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizNotificationMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizNotification;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 通知服务实现
 *
 * @author Chuang
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final BizNotificationMapper notificationMapper;

    @Autowired(required = false)
    private BaseMapper<SysUser> sysUserMapper;

    @Autowired(required = false)
    private WebSocketPublisher webSocketPublisher;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createNotification(Long userId, NotificationTypeEnum type, String title, String content,
                                   String relatedType, Long relatedId) {
        BizNotification notification = new BizNotification();
        notification.setUserId(userId);
        notification.setType(type);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setRelatedType(relatedType);
        notification.setRelatedId(relatedId);
        notification.setIsRead(0);
        notification.setCreateTime(LocalDateTime.now());
        notificationMapper.insert(notification);
        
        // 发送WebSocket实时通知
        pushNotificationToUser(userId, notification);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createBatchNotification(List<Long> userIds, NotificationTypeEnum type, String title,
                                        String content, String relatedType, Long relatedId) {
        if (userIds == null || userIds.isEmpty()) {
            return;
        }
        LocalDateTime now = LocalDateTime.now();
        
        // 构建批量插入的通知列表
        List<BizNotification> notifications = new java.util.ArrayList<>();
        for (Long userId : userIds) {
            BizNotification notification = new BizNotification();
            notification.setUserId(userId);
            notification.setType(type);
            notification.setTitle(title);
            notification.setContent(content);
            notification.setRelatedType(relatedType);
            notification.setRelatedId(relatedId);
            notification.setIsRead(0);
            notification.setCreateTime(now);
            notifications.add(notification);
        }
        
        // 批量插入（每批500条）
        int batchSize = 500;
        for (int i = 0; i < notifications.size(); i += batchSize) {
            int end = Math.min(i + batchSize, notifications.size());
            List<BizNotification> batch = notifications.subList(i, end);
            notificationMapper.batchInsert(batch);
        }
        
        // 发送WebSocket实时通知给所有用户
        for (Long userId : userIds) {
            pushNotificationCountToUser(userId);
        }
        
        log.info("批量创建通知成功，用户数: {}, 类型: {}, 标题: {}", userIds.size(), type, title);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createAnnouncementForAllUsers(String title, String content, boolean onlyVerified) {
        if (sysUserMapper == null) {
            log.warn("SysUserMapper未注入，无法发布公告");
            return;
        }
        
        // 查询所有用户（或仅已认证用户）
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUser::getStatus, "0"); // 正常状态的用户
        if (onlyVerified) {
            wrapper.eq(SysUser::getVerified, 1);
        }
        List<SysUser> users = sysUserMapper.selectList(wrapper);
        
        if (users.isEmpty()) {
            log.info("没有符合条件的用户，公告未发送");
            return;
        }
        
        // 为每个用户创建公告通知（使用批量插入）
        LocalDateTime now = LocalDateTime.now();
        List<BizNotification> notifications = new java.util.ArrayList<>();
        for (SysUser user : users) {
            BizNotification notification = new BizNotification();
            notification.setUserId(user.getUserId());
            notification.setType(NotificationTypeEnum.ANNOUNCEMENT);
            notification.setTitle(title);
            notification.setContent(content);
            notification.setRelatedType("ANNOUNCEMENT");
            notification.setRelatedId(null);
            notification.setIsRead(0);
            notification.setCreateTime(now);
            notifications.add(notification);
        }
        
        // 批量插入（每批500条）
        int batchSize = 500;
        for (int i = 0; i < notifications.size(); i += batchSize) {
            int end = Math.min(i + batchSize, notifications.size());
            List<BizNotification> batch = notifications.subList(i, end);
            notificationMapper.batchInsert(batch);
        }
        
        log.info("系统公告发布成功，通知用户数: {}, 标题: {}", users.size(), title);
    }

    @Override
    public Page<BizNotification> getUserNotifications(Page<BizNotification> page, Long userId,
                                                      NotificationTypeEnum type, Integer isRead) {
        LambdaQueryWrapper<BizNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizNotification::getUserId, userId);
        if (type != null) {
            wrapper.eq(BizNotification::getType, type);
        }
        if (isRead != null) {
            wrapper.eq(BizNotification::getIsRead, isRead);
        }
        wrapper.orderByDesc(BizNotification::getCreateTime);
        return notificationMapper.selectPage(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markAsRead(Long notificationId, Long userId) {
        BizNotification notification = notificationMapper.selectById(notificationId);
        if (notification == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "通知不存在");
        }
        if (!notification.getUserId().equals(userId)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权操作此通知");
        }
        notification.setIsRead(1);
        notification.setReadAt(LocalDateTime.now());
        notificationMapper.updateById(notification);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markAllAsRead(Long userId) {
        notificationMapper.markAllAsRead(userId);
    }

    @Override
    public int getUnreadCount(Long userId) {
        return notificationMapper.countUnread(userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteNotification(Long notificationId, Long userId) {
        BizNotification notification = notificationMapper.selectById(notificationId);
        if (notification == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "通知不存在");
        }
        if (!notification.getUserId().equals(userId)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权删除此通知");
        }
        notificationMapper.deleteById(notificationId);
    }

    /**
     * 推送通知到用户
     */
    private void pushNotificationToUser(Long userId, BizNotification notification) {
        if (webSocketPublisher == null) {
            return;
        }
        try {
            Map<String, Object> payload = new HashMap<>();
            payload.put("id", notification.getId());
            payload.put("type", notification.getType().name());
            payload.put("title", notification.getTitle());
            payload.put("content", notification.getContent());
            payload.put("relatedType", notification.getRelatedType());
            payload.put("relatedId", notification.getRelatedId());
            payload.put("createTime", notification.getCreateTime().toString());
            
            webSocketPublisher.sendToUser(userId, WebSocketDestinations.USER_QUEUE_LOSTFOUND_NOTIFICATION, payload);
            
            // 同时推送未读数量
            pushNotificationCountToUser(userId);
        } catch (Exception e) {
            log.warn("推送通知失败: userId={}, error={}", userId, e.getMessage());
        }
    }

    /**
     * 推送未读通知数量到用户
     */
    private void pushNotificationCountToUser(Long userId) {
        if (webSocketPublisher == null) {
            return;
        }
        try {
            int unreadCount = notificationMapper.countUnread(userId);
            Map<String, Object> payload = new HashMap<>();
            payload.put("unreadCount", unreadCount);
            
            webSocketPublisher.sendToUser(userId, WebSocketDestinations.USER_QUEUE_LOSTFOUND_NOTIFICATION_COUNT, payload);
        } catch (Exception e) {
            log.warn("推送通知数量失败: userId={}, error={}", userId, e.getMessage());
        }
    }

    @Override
    public List<BizNotification> getLatestAnnouncements(int limit) {
        LambdaQueryWrapper<BizNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizNotification::getType, NotificationTypeEnum.ANNOUNCEMENT)
               .orderByDesc(BizNotification::getCreateTime)
               .last("LIMIT " + limit);
        return notificationMapper.selectList(wrapper);
    }
}

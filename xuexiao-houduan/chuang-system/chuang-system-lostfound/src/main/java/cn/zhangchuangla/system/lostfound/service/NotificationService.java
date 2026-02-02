package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.model.entity.BizNotification;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.util.List;

/**
 * 通知服务接口
 *
 * @author Chuang
 */
public interface NotificationService {

    /**
     * 创建通知
     *
     * @param userId      用户ID
     * @param type        通知类型
     * @param title       标题
     * @param content     内容
     * @param relatedType 关联类型
     * @param relatedId   关联ID
     */
    void createNotification(Long userId, NotificationTypeEnum type, String title, String content,
                            String relatedType, Long relatedId);

    /**
     * 批量创建通知
     *
     * @param userIds     用户ID列表
     * @param type        通知类型
     * @param title       标题
     * @param content     内容
     * @param relatedType 关联类型
     * @param relatedId   关联ID
     */
    void createBatchNotification(List<Long> userIds, NotificationTypeEnum type, String title, 
                                 String content, String relatedType, Long relatedId);

    /**
     * 为所有用户创建公告通知
     *
     * @param title        标题
     * @param content      内容
     * @param onlyVerified 是否仅通知已认证用户
     */
    void createAnnouncementForAllUsers(String title, String content, boolean onlyVerified);

    /**
     * 获取用户通知列表
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @param type   通知类型
     * @param isRead 是否已读
     * @return 通知列表
     */
    Page<BizNotification> getUserNotifications(Page<BizNotification> page, Long userId,
                                               NotificationTypeEnum type, Integer isRead);

    /**
     * 标记通知为已读
     *
     * @param notificationId 通知ID
     * @param userId         用户ID
     */
    void markAsRead(Long notificationId, Long userId);

    /**
     * 标记所有通知为已读
     *
     * @param userId 用户ID
     */
    void markAllAsRead(Long userId);

    /**
     * 获取未读通知数
     *
     * @param userId 用户ID
     * @return 未读数
     */
    int getUnreadCount(Long userId);

    /**
     * 删除通知
     *
     * @param notificationId 通知ID
     * @param userId         用户ID
     */
    void deleteNotification(Long notificationId, Long userId);

    /**
     * 获取最新公告列表
     *
     * @param limit 数量限制
     * @return 公告列表
     */
    List<BizNotification> getLatestAnnouncements(int limit);
}

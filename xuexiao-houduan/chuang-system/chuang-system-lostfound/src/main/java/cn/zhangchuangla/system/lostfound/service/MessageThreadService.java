package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizMessage;
import cn.zhangchuangla.system.lostfound.model.entity.BizMsgThread;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.util.List;

/**
 * 消息会话服务接口
 *
 * @author Chuang
 */
public interface MessageThreadService {

    /**
     * 获取或创建会话
     *
     * @param postId  帖子ID
     * @param claimId 认领单ID
     * @param userA   用户A
     * @param userB   用户B
     * @return 会话ID
     */
    Long getOrCreateThread(Long postId, Long claimId, Long userA, Long userB);

    /**
     * 发送消息
     *
     * @param message  消息
     * @param senderId 发送者ID
     * @return 消息ID
     */
    Long sendMessage(BizMessage message, Long senderId);

    /**
     * 获取用户会话列表
     *
     * @param userId 用户ID
     * @return 会话列表
     */
    List<BizMsgThread> getUserThreads(Long userId);

    /**
     * 获取会话消息
     *
     * @param page     分页参数
     * @param threadId 会话ID
     * @param userId   用户ID
     * @return 消息列表
     */
    Page<BizMessage> getThreadMessages(Page<BizMessage> page, Long threadId, Long userId);

    /**
     * 标记已读
     *
     * @param threadId 会话ID
     * @param userId   用户ID
     */
    void markAsRead(Long threadId, Long userId);

    /**
     * 获取用户未读消息数
     *
     * @param userId 用户ID
     * @return 未读数
     */
    int getUnreadCount(Long userId);

    /**
     * 获取会话详情
     *
     * @param threadId 会话ID
     * @return 会话信息
     */
    BizMsgThread getThreadById(Long threadId);

    /**
     * 获取会话详情（包含对方用户信息）
     *
     * @param threadId 会话ID
     * @param userId   当前用户ID
     * @return 会话信息
     */
    BizMsgThread getThreadDetail(Long threadId, Long userId);
}

package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.entity.security.SysUser;
import cn.zhangchuangla.system.lostfound.enums.MessageTypeEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizMessageMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizMsgThreadMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizMessage;
import cn.zhangchuangla.system.lostfound.model.entity.BizMsgThread;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.MessageThreadService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 消息会话服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class MessageThreadServiceImpl implements MessageThreadService {

    private final BizMsgThreadMapper threadMapper;
    private final BizMessageMapper messageMapper;
    private final BizPostMapper postMapper;

    @Autowired(required = false)
    private BaseMapper<SysUser> sysUserMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long getOrCreateThread(Long postId, Long claimId, Long userA, Long userB) {
        // 查找已存在的会话
        BizMsgThread existing = threadMapper.findThread(postId, claimId, userA, userB);
        if (existing != null) {
            return existing.getId();
        }
        // 创建新会话
        BizMsgThread thread = new BizMsgThread();
        thread.setPostId(postId);
        thread.setClaimId(claimId);
        thread.setUserAId(userA);
        thread.setUserBId(userB);
        thread.setUserAUnread(0);
        thread.setUserBUnread(0);
        thread.setCreateTime(LocalDateTime.now());
        threadMapper.insert(thread);
        return thread.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long sendMessage(BizMessage message, Long senderId) {
        BizMsgThread thread = threadMapper.selectById(message.getThreadId());
        if (thread == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "会话不存在");
        }
        // 确定接收者
        Long receiverId = thread.getUserAId().equals(senderId) ? thread.getUserBId() : thread.getUserAId();
        message.setSenderId(senderId);
        message.setReceiverId(receiverId);
        if (message.getMsgType() == null) {
            message.setMsgType(MessageTypeEnum.TEXT);
        }
        message.setCreateTime(LocalDateTime.now());
        messageMapper.insert(message);
        // 更新会话最后消息
        thread.setLastMessageId(message.getId());
        thread.setLastMessageTime(message.getCreateTime());
        // 增加接收者未读数
        if (thread.getUserAId().equals(receiverId)) {
            thread.setUserAUnread(thread.getUserAUnread() + 1);
        } else {
            thread.setUserBUnread(thread.getUserBUnread() + 1);
        }
        thread.setUpdateTime(LocalDateTime.now());
        threadMapper.updateById(thread);
        return message.getId();
    }

    @Override
    public List<BizMsgThread> getUserThreads(Long userId) {
        LambdaQueryWrapper<BizMsgThread> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizMsgThread::getUserAId, userId)
                .or().eq(BizMsgThread::getUserBId, userId);
        wrapper.orderByDesc(BizMsgThread::getLastMessageTime);
        List<BizMsgThread> threads = threadMapper.selectList(wrapper);
        
        // 为每个会话填充扩展信息
        for (BizMsgThread thread : threads) {
            // 计算对方用户ID
            Long targetUserId = thread.getUserAId().equals(userId) ? thread.getUserBId() : thread.getUserAId();
            thread.setTargetUserId(targetUserId);
            
            // 获取对方用户信息
            if (sysUserMapper != null) {
                SysUser targetUser = sysUserMapper.selectById(targetUserId);
                if (targetUser != null) {
                    thread.setTargetUserName(targetUser.getUsername());
                    thread.setTargetUserAvatar(targetUser.getAvatar());
                }
            }
            
            // 计算当前用户未读数
            if (thread.getUserAId().equals(userId)) {
                thread.setUnreadCount(thread.getUserAUnread() != null ? thread.getUserAUnread() : 0);
            } else {
                thread.setUnreadCount(thread.getUserBUnread() != null ? thread.getUserBUnread() : 0);
            }
            
            // 获取最后消息内容
            if (thread.getLastMessageId() != null) {
                BizMessage lastMsg = messageMapper.selectById(thread.getLastMessageId());
                if (lastMsg != null) {
                    thread.setLastMessageContent(lastMsg.getContent());
                }
            }
            
            // 获取帖子标题
            if (thread.getPostId() != null) {
                BizPost post = postMapper.selectById(thread.getPostId());
                if (post != null) {
                    thread.setPostTitle(post.getTitle());
                }
            }
        }
        
        return threads;
    }

    @Override
    public Page<BizMessage> getThreadMessages(Page<BizMessage> page, Long threadId, Long userId) {
        LambdaQueryWrapper<BizMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizMessage::getThreadId, threadId);
        // 按时间正序排列，最早的消息在上面，最新的在下面
        wrapper.orderByAsc(BizMessage::getCreateTime);
        Page<BizMessage> result = messageMapper.selectPage(page, wrapper);
        
        // 为每条消息填充发送者信息
        if (sysUserMapper != null && result.getRecords() != null) {
            for (BizMessage msg : result.getRecords()) {
                if (msg.getSenderId() != null) {
                    SysUser sender = sysUserMapper.selectById(msg.getSenderId());
                    if (sender != null) {
                        msg.setSenderName(sender.getUsername());
                        msg.setSenderAvatar(sender.getAvatar());
                    }
                }
            }
        }
        
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markAsRead(Long threadId, Long userId) {
        // 标记消息为已读
        messageMapper.markAsRead(threadId, userId);
        // 重置未读数
        threadMapper.resetUnreadCount(threadId, userId);
    }

    @Override
    public int getUnreadCount(Long userId) {
        LambdaQueryWrapper<BizMsgThread> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizMsgThread::getUserAId, userId)
                .or().eq(BizMsgThread::getUserBId, userId);
        List<BizMsgThread> threads = threadMapper.selectList(wrapper);
        int total = 0;
        for (BizMsgThread thread : threads) {
            if (thread.getUserAId().equals(userId)) {
                total += thread.getUserAUnread() != null ? thread.getUserAUnread() : 0;
            } else {
                total += thread.getUserBUnread() != null ? thread.getUserBUnread() : 0;
            }
        }
        return total;
    }

    @Override
    public BizMsgThread getThreadById(Long threadId) {
        return threadMapper.selectById(threadId);
    }

    @Override
    public BizMsgThread getThreadDetail(Long threadId, Long userId) {
        BizMsgThread thread = threadMapper.selectById(threadId);
        if (thread == null) {
            return null;
        }
        // 计算对方用户ID
        Long targetUserId = thread.getUserAId().equals(userId) ? thread.getUserBId() : thread.getUserAId();
        thread.setTargetUserId(targetUserId);
        // 获取对方用户信息
        if (sysUserMapper != null) {
            SysUser targetUser = sysUserMapper.selectById(targetUserId);
            if (targetUser != null) {
                thread.setTargetUserName(targetUser.getUsername());
                thread.setTargetUserAvatar(targetUser.getAvatar());
            }
        }
        // 计算当前用户未读数
        if (thread.getUserAId().equals(userId)) {
            thread.setUnreadCount(thread.getUserAUnread() != null ? thread.getUserAUnread() : 0);
        } else {
            thread.setUnreadCount(thread.getUserBUnread() != null ? thread.getUserBUnread() : 0);
        }
        // 获取帖子标题
        if (thread.getPostId() != null) {
            BizPost post = postMapper.selectById(thread.getPostId());
            if (post != null) {
                thread.setPostTitle(post.getTitle());
            }
        }
        // 获取最后消息内容
        if (thread.getLastMessageId() != null) {
            BizMessage lastMsg = messageMapper.selectById(thread.getLastMessageId());
            if (lastMsg != null) {
                thread.setLastMessageContent(lastMsg.getContent());
            }
        }
        return thread;
    }
}

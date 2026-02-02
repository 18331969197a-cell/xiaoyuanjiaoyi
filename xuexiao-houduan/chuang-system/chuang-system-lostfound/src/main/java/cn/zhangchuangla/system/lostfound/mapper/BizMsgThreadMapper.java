package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizMsgThread;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * 消息会话 Mapper
 *
 * @author Chuang
 */
public interface BizMsgThreadMapper extends BaseMapper<BizMsgThread> {

    /**
     * 查找两个用户之间关于某个帖子/认领单的会话
     *
     * @param postId  帖子ID
     * @param claimId 认领单ID
     * @param userA   用户A
     * @param userB   用户B
     * @return 会话
     */
    BizMsgThread findThread(@Param("postId") Long postId, @Param("claimId") Long claimId,
                            @Param("userA") Long userA, @Param("userB") Long userB);

    /**
     * 更新用户未读数
     *
     * @param threadId 会话ID
     * @param userId   用户ID
     * @param delta    变化量
     * @return 影响行数
     */
    int updateUnreadCount(@Param("threadId") Long threadId, @Param("userId") Long userId, @Param("delta") int delta);

    /**
     * 重置用户未读数为0
     *
     * @param threadId 会话ID
     * @param userId   用户ID
     * @return 影响行数
     */
    int resetUnreadCount(@Param("threadId") Long threadId, @Param("userId") Long userId);
}

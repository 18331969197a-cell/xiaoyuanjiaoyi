package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizMessage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * 消息 Mapper
 *
 * @author Chuang
 */
public interface BizMessageMapper extends BaseMapper<BizMessage> {

    /**
     * 标记会话中某用户收到的消息为已读
     *
     * @param threadId   会话ID
     * @param receiverId 接收者ID
     * @return 影响行数
     */
    int markAsRead(@Param("threadId") Long threadId, @Param("receiverId") Long receiverId);
}

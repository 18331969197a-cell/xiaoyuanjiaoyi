package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizNotification;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 通知 Mapper
 *
 * @author Chuang
 */
public interface BizNotificationMapper extends BaseMapper<BizNotification> {

    /**
     * 标记用户所有通知为已读
     *
     * @param userId 用户ID
     * @return 影响行数
     */
    int markAllAsRead(@Param("userId") Long userId);

    /**
     * 统计用户未读通知数
     *
     * @param userId 用户ID
     * @return 未读数
     */
    int countUnread(@Param("userId") Long userId);
    
    /**
     * 批量插入通知
     *
     * @param notifications 通知列表
     * @return 影响行数
     */
    int batchInsert(@Param("list") List<BizNotification> notifications);
}

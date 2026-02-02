package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizComment;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 评论 Mapper
 *
 * @author Chuang
 */
public interface BizCommentMapper extends BaseMapper<BizComment> {

    /**
     * 分页查询帖子评论（带用户名）
     */
    Page<BizComment> selectPostCommentsWithUserName(Page<BizComment> page, @Param("postId") Long postId, @Param("status") String status);

    /**
     * 管理端分页查询评论（带用户名和帖子标题）
     */
    Page<BizComment> selectAdminCommentsWithDetail(Page<BizComment> page, @Param("status") String status);
}

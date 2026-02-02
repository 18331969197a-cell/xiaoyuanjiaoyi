package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

/**
 * 认领单 Mapper
 *
 * @author Chuang
 */
public interface BizClaimMapper extends BaseMapper<BizClaim> {

    /**
     * 分页查询用户发起的认领（带帖子信息）
     */
    Page<BizClaim> selectUserClaimsWithPost(Page<BizClaim> page,
                                             @Param("userId") Long userId,
                                             @Param("status") String status);

    /**
     * 分页查询用户收到的认领（带帖子信息）
     */
    Page<BizClaim> selectReceivedClaimsWithPost(Page<BizClaim> page,
                                                 @Param("userId") Long userId,
                                                 @Param("status") String status);

    /**
     * 管理员分页查询认领列表（带帖子信息）
     */
    Page<BizClaim> selectAdminClaimsWithPost(Page<BizClaim> page,
                                              @Param("status") String status);

    /**
     * 根据ID查询认领详情（带帖子信息）
     */
    BizClaim selectClaimDetailById(@Param("claimId") Long claimId);
}

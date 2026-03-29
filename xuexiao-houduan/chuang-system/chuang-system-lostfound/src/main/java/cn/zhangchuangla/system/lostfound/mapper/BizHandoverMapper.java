package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

/**
 * 交接记录 Mapper
 *
 * @author Chuang
 */
public interface BizHandoverMapper extends BaseMapper<BizHandover> {

    /**
     * 根据认领ID查询交接详情（带用户名）
     */
    BizHandover selectHandoverDetailByClaimId(@Param("claimId") Long claimId);

    /**
     * 查询用户相关交接列表（带用户名）
     */
    Page<BizHandover> selectUserHandoversWithDetail(Page<BizHandover> page,
                                                    @Param("userId") Long userId,
                                                    @Param("status") String status);
}

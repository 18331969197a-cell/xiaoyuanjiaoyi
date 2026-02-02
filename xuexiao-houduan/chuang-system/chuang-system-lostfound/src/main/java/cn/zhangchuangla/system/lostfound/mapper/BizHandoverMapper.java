package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
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
}

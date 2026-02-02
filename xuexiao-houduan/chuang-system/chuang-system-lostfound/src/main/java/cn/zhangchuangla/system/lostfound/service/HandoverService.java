package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;

/**
 * 交接服务接口
 *
 * @author Chuang
 */
public interface HandoverService {

    /**
     * 创建交接记录
     *
     * @param handover 交接信息
     * @param userId   用户ID
     * @return 交接ID
     */
    Long createHandover(BizHandover handover, Long userId);

    /**
     * 确认交接
     *
     * @param handoverId 交接ID
     * @param userId     用户ID
     */
    void confirmHandover(Long handoverId, Long userId);

    /**
     * 获取交接详情
     *
     * @param handoverId 交接ID
     * @return 交接信息
     */
    BizHandover getHandoverById(Long handoverId);

    /**
     * 根据认领单ID获取交接记录
     *
     * @param claimId 认领单ID
     * @return 交接信息
     */
    BizHandover getHandoverByClaimId(Long claimId);
}

package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

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
     * 取消交接
     *
     * @param handoverId 交接ID
     * @param reason     取消原因
     * @param userId     用户ID
     */
    void cancelHandover(Long handoverId, String reason, Long userId);

    /**
     * 提交线下完成回传
     *
     * @param handoverId 交接ID
     * @param handover   回传内容
     * @param userId     用户ID
     */
    void submitReceipt(Long handoverId, BizHandover handover, Long userId);

    /**
     * 确认线下完成回传
     *
     * @param handoverId 交接ID
     * @param userId     用户ID
     */
    void confirmReceipt(Long handoverId, Long userId);

    /**
     * 改约
     *
     * @param handoverId 交接ID
     * @param handover   新的时间地点
     * @param reason     改约原因
     * @param userId     用户ID
     */
    void reschedule(Long handoverId, BizHandover handover, String reason, Long userId);

    /**
     * 上报争议
     *
     * @param handoverId 交接ID
     * @param reason     争议原因
     * @param userId     用户ID
     */
    void raiseDispute(Long handoverId, String reason, Long userId);

    /**
     * 上报爽约
     *
     * @param handoverId 交接ID
     * @param reason     说明
     * @param userId     用户ID
     */
    void markNoShow(Long handoverId, String reason, Long userId);

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

    /**
     * 获取我的交接记录
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @param status 状态（可选）
     * @return 交接列表
     */
    Page<BizHandover> getMyHandovers(Page<BizHandover> page, Long userId, String status);
}

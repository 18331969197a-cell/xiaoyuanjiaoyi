package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizEvaluation;

import java.util.List;

/**
 * 评价服务接口
 *
 * @author Chuang
 */
public interface EvaluationService {

    /**
     * 创建评价
     *
     * @param evaluation 评价信息
     * @param userId     用户ID
     * @return 评价ID
     */
    Long createEvaluation(BizEvaluation evaluation, Long userId);

    /**
     * 获取认领单的评价列表
     *
     * @param claimId 认领单ID
     * @return 评价列表
     */
    List<BizEvaluation> getEvaluationsByClaimId(Long claimId);

    /**
     * 检查用户是否已评价
     *
     * @param claimId 认领单ID
     * @param userId  用户ID
     * @return 是否已评价
     */
    boolean hasEvaluated(Long claimId, Long userId);
}

package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizReport;
import cn.zhangchuangla.system.lostfound.model.entity.BizRiskEvent;
import cn.zhangchuangla.system.lostfound.model.vo.ChatRiskSummaryVO;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.time.LocalDateTime;

/**
 * 风险事件服务
 */
public interface RiskEventService {

    void upsertFromReport(BizReport report, String action, Long adminId);

    void createHandoverTimeoutEvent(Long handoverId, Long claimId, Long userId, String remark);

    void upsertHandoverRiskEvent(Long handoverId,
                                 Long claimId,
                                 String riskType,
                                 String actionType,
                                 Long operatorUserId,
                                 String remark);

    ChatRiskSummaryVO buildChatRiskSummary(Long targetUserId);

    Page<BizRiskEvent> listAdminEvents(Page<BizRiskEvent> page,
                                       String targetType,
                                       Long targetId,
                                       String eventStatus,
                                       String actionType,
                                       LocalDateTime startTime,
                                       LocalDateTime endTime);
}

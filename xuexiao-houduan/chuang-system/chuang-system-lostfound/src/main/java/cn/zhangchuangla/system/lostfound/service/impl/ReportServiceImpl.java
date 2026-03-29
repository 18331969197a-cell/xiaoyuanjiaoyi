package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.entity.security.SysUser;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.core.service.SysUserService;
import cn.zhangchuangla.system.core.model.entity.SysSecurityLog;
import cn.zhangchuangla.system.core.service.SysSecurityLogService;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.ReportStatusEnum;
import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizReportMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.model.entity.BizReport;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import cn.zhangchuangla.system.lostfound.service.RiskEventService;
import cn.zhangchuangla.system.lostfound.service.ReportService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * 举报服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {

    private final BizReportMapper reportMapper;
    private final BizPostMapper postMapper;
    private final SysUserService sysUserService;
    private final SysSecurityLogService sysSecurityLogService;
    @Lazy
    private final NotificationService notificationService;
    @Lazy
    private final RiskEventService riskEventService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createReport(BizReport report, Long reporterId) {
        report.setReporterId(reporterId);
        report.setStatus(ReportStatusEnum.PENDING);
        report.setCreateTime(LocalDateTime.now());
        reportMapper.insert(report);
        return report.getId();
    }

    @Override
    public Page<BizReport> getUserReports(Page<BizReport> page, Long userId) {
        LambdaQueryWrapper<BizReport> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizReport::getReporterId, userId);
        wrapper.orderByDesc(BizReport::getCreateTime);
        return reportMapper.selectPage(page, wrapper);
    }

    @Override
    public BizReport getReportById(Long reportId) {
        return reportMapper.selectById(reportId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void resolveReport(Long reportId, String result, String action, Long adminId) {
        BizReport report = reportMapper.selectById(reportId);
        if (report == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "举报不存在");
        }
        if (report.getStatus() != ReportStatusEnum.PENDING) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "举报已处理，请勿重复操作");
        }
        report.setStatus(ReportStatusEnum.RESOLVED);
        report.setResolveBy(adminId);
        report.setResolveAt(LocalDateTime.now());
        report.setResolveResult(result);
        report.setResolveAction(action);
        reportMapper.updateById(report);
        // 执行处理动作
        if ("offline_post".equals(action) && "POST".equals(report.getTargetType())) {
            BizPost post = new BizPost();
            post.setId(report.getTargetId());
            post.setStatus(PostStatusEnum.OFFLINE);
            postMapper.updateById(post);
        }
        if ("ban_user".equals(action) && "USER".equals(report.getTargetType())) {
            SysUser user = new SysUser();
            user.setUserId(report.getTargetId());
            user.setStatus(1);
            sysUserService.updateById(user);

            if (notificationService != null) {
                notificationService.createNotification(
                        report.getTargetId(),
                        NotificationTypeEnum.REPORT,
                        "账号触发风险处置",
                        "您的账号因举报核实被执行风险处置，请联系管理员了解详情。",
                        "REPORT",
                        report.getId()
                );
            }
        }
        // 举报处置统一沉淀到风险日志，避免风险告警口径分散
        createRiskAlertLog(report, action);
        if (riskEventService != null) {
            riskEventService.upsertFromReport(report, action, adminId);
        }

        if (notificationService != null) {
            notificationService.createNotification(
                    report.getReporterId(),
                    NotificationTypeEnum.REPORT,
                    "举报已处理",
                    "您提交的举报已处理，处理动作：" + resolveActionText(action),
                    "REPORT",
                    report.getId()
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectReport(Long reportId, String result, Long adminId) {
        BizReport report = reportMapper.selectById(reportId);
        if (report == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "举报不存在");
        }
        if (report.getStatus() != ReportStatusEnum.PENDING) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "举报已处理，请勿重复操作");
        }
        report.setStatus(ReportStatusEnum.REJECTED);
        report.setResolveBy(adminId);
        report.setResolveAt(LocalDateTime.now());
        report.setResolveResult(result);
        reportMapper.updateById(report);
        if (notificationService != null) {
            notificationService.createNotification(
                    report.getReporterId(),
                    NotificationTypeEnum.REPORT,
                    "举报已驳回",
                    "您提交的举报未通过，原因：" + (result == null || result.isBlank() ? "管理员已驳回" : result),
                    "REPORT",
                    report.getId()
            );
        }
    }

    @Override
    public Page<BizReport> listReports(Page<BizReport> page, String targetType, Long targetId, String status, String resolveAction,
                                       LocalDateTime startTime, LocalDateTime endTime) {
        return reportMapper.selectAdminReportsWithDetail(page, targetType, status, targetId, resolveAction, startTime, endTime);
    }

    @Override
    public Page<BizReport> getReportList(Page<BizReport> page, ReportStatusEnum status) {
        LambdaQueryWrapper<BizReport> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(BizReport::getStatus, status);
        }
        wrapper.orderByDesc(BizReport::getCreateTime);
        return reportMapper.selectPage(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void handleReport(Long reportId, String result, String action, Long adminId) {
        resolveReport(reportId, result, action, adminId);
    }

    private String resolveActionText(String action) {
        if (action == null || action.isBlank()) {
            return "已处理";
        }
        return switch (action) {
            case "ban_user" -> "封禁账号";
            case "mute" -> "禁言";
            case "offline_post" -> "删除内容";
            case "warning" -> "警告";
            default -> action;
        };
    }

    private void createRiskAlertLog(BizReport report, String action) {
        if (action == null || action.isBlank()) {
            return;
        }
        Long logUserId = "USER".equals(report.getTargetType()) ? report.getTargetId() : report.getReporterId();
        if (logUserId == null) {
            logUserId = report.getResolveBy() != null ? report.getResolveBy() : 0L;
        }
        SysSecurityLog securityLog = new SysSecurityLog();
        securityLog.setUserId(logUserId);
        securityLog.setTitle("风险告警-举报#" + report.getId() + "-" + resolveActionText(action));
        securityLog.setOperationType("RISK_ALERT");
        securityLog.setOperationRegion("LOSTFOUND");
        securityLog.setOperationIp("SYSTEM");
        securityLog.setOperationTime(new Date());
        sysSecurityLogService.save(securityLog);
    }
}

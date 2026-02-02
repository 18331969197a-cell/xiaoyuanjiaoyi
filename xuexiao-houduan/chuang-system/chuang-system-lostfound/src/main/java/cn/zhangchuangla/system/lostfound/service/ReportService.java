package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizReport;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * 举报服务接口
 *
 * @author Chuang
 */
public interface ReportService {

    /**
     * 创建举报
     *
     * @param report     举报信息
     * @param reporterId 举报人ID
     * @return 举报ID
     */
    Long createReport(BizReport report, Long reporterId);

    /**
     * 获取用户举报列表
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @return 举报列表
     */
    Page<BizReport> getUserReports(Page<BizReport> page, Long userId);

    /**
     * 获取举报详情
     *
     * @param reportId 举报ID
     * @return 举报信息
     */
    BizReport getReportById(Long reportId);

    /**
     * 处理举报
     *
     * @param reportId 举报ID
     * @param result   处理结果
     * @param action   处理动作
     * @param adminId  管理员ID
     */
    void resolveReport(Long reportId, String result, String action, Long adminId);

    /**
     * 驳回举报
     *
     * @param reportId 举报ID
     * @param result   驳回原因
     * @param adminId  管理员ID
     */
    void rejectReport(Long reportId, String result, Long adminId);

    /**
     * 分页查询举报列表（管理端）
     *
     * @param page       分页参数
     * @param targetType 目标类型
     * @param status     状态
     * @return 举报列表
     */
    Page<BizReport> listReports(Page<BizReport> page, String targetType, String status, String resolveAction);

    /**
     * 获取举报列表（按状态）
     *
     * @param page   分页参数
     * @param status 状态
     * @return 举报列表
     */
    Page<BizReport> getReportList(Page<BizReport> page, cn.zhangchuangla.system.lostfound.enums.ReportStatusEnum status);

    /**
     * 处理举报
     *
     * @param reportId 举报ID
     * @param result   处理结果
     * @param action   处理动作
     * @param adminId  管理员ID
     */
    void handleReport(Long reportId, String result, String action, Long adminId);
}

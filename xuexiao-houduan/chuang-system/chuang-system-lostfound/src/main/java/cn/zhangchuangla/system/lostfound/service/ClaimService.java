package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.util.List;

/**
 * 认领服务接口
 *
 * @author Chuang
 */
public interface ClaimService {

    /**
     * 发起认领
     *
     * @param claim      认领信息
     * @param claimantId 认领人ID
     * @return 认领ID
     */
    Long createClaim(BizClaim claim, Long claimantId);

    /**
     * 补充佐证
     *
     * @param claimId         认领ID
     * @param proofText       佐证说明
     * @param proofImagesJson 佐证图片
     * @param userId          用户ID
     */
    void appendProof(Long claimId, String proofText, List<String> proofImagesJson, Long userId);

    /**
     * 取消认领
     *
     * @param claimId 认领ID
     * @param userId  用户ID
     */
    void cancelClaim(Long claimId, Long userId);

    /**
     * 同意认领
     *
     * @param claimId  认领ID
     * @param posterId 发帖人ID
     */
    void approveClaim(Long claimId, Long posterId);

    /**
     * 拒绝认领
     *
     * @param claimId  认领ID
     * @param reason   拒绝原因
     * @param posterId 发帖人ID
     */
    void rejectClaim(Long claimId, String reason, Long posterId);

    /**
     * 完成认领
     *
     * @param claimId 认领ID
     */
    void completeClaim(Long claimId);

    /**
     * 线下确认悬赏发放
     *
     * @param claimId 认领ID
     * @param userId  发帖人ID
     */
    void confirmRewardPaid(Long claimId, Long userId);

    /**
     * 线下悬赏退款（撤销托管）
     *
     * @param claimId 认领ID
     * @param userId  发帖人ID
     */
    void refundReward(Long claimId, Long userId);

    /**
     * 获取认领详情
     *
     * @param claimId 认领ID
     * @return 认领信息
     */
    BizClaim getClaimById(Long claimId);

    /**
     * 获取用户发起的认领
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @param status 状态
     * @return 认领列表
     */
    Page<BizClaim> getUserClaims(Page<BizClaim> page, Long userId, ClaimStatusEnum status);

    /**
     * 获取用户收到的认领
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @param status 状态
     * @return 认领列表
     */
    Page<BizClaim> getReceivedClaims(Page<BizClaim> page, Long userId, ClaimStatusEnum status);

    /**
     * 获取帖子的认领列表
     *
     * @param postId 帖子ID
     * @return 认领列表
     */
    List<BizClaim> getClaimsByPostId(Long postId);

    /**
     * 管理员获取认领列表
     *
     * @param page   分页参数
     * @param status 状态
     * @return 认领列表
     */
    Page<BizClaim> adminList(Page<BizClaim> page, ClaimStatusEnum status);

    /**
     * 更新认领状态为交接中
     *
     * @param claimId 认领ID
     */
    void startHandover(Long claimId);

    /**
     * 交接取消后恢复为已通过状态
     *
     * @param claimId 认领ID
     */
    void reopenFromHandover(Long claimId);

    /**
     * 管理员审核通过认领
     *
     * @param claimId 认领ID
     * @param adminId 管理员ID
     */
    void adminApproveClaim(Long claimId, Long adminId);

    /**
     * 管理员拒绝认领
     *
     * @param claimId 认领ID
     * @param reason  拒绝原因
     * @param adminId 管理员ID
     */
    void adminRejectClaim(Long claimId, String reason, Long adminId);
}

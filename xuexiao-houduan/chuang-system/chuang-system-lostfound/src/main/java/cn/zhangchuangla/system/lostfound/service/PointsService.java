package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizPointsLog;
import cn.zhangchuangla.system.lostfound.model.vo.PointsInfoVO;
import cn.zhangchuangla.system.lostfound.model.vo.UserPointsVO;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * 积分服务接口
 *
 * @author Chuang
 */
public interface PointsService {

    /**
     * 奖励积分
     *
     * @param userId      用户ID
     * @param action      动作类型
     * @param delta       积分变化
     * @param relatedType 关联类型
     * @param relatedId   关联ID
     */
    void awardPoints(Long userId, String action, int delta, String relatedType, Long relatedId);

    /**
     * 扣除积分
     *
     * @param userId 用户ID
     * @param action 动作类型
     * @param delta  积分变化（正数）
     * @param reason 原因
     */
    void deductPoints(Long userId, String action, int delta, String reason);

    /**
     * 获取用户积分
     *
     * @param userId 用户ID
     * @return 积分
     */
    int getUserPoints(Long userId);

    /**
     * 获取用户完整积分信息
     *
     * @param userId 用户ID
     * @return 积分信息VO
     */
    PointsInfoVO getUserPointsInfo(Long userId);

    /**
     * 获取积分流水
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @return 积分流水列表
     */
    Page<BizPointsLog> getPointsLogs(Page<BizPointsLog> page, Long userId);

    /**
     * 计算用户等级
     *
     * @param points 积分
     * @return 等级
     */
    int calculateLevel(int points);

    /**
     * 计算下一等级所需积分
     *
     * @param level 当前等级
     * @return 下一等级所需积分
     */
    int getNextLevelPoints(int level);

    /**
     * 管理员调整积分
     *
     * @param userId  用户ID
     * @param delta   积分变化
     * @param reason  原因
     * @param adminId 管理员ID
     */
    void adminAdjustPoints(Long userId, int delta, String reason, Long adminId);

    /**
     * 获取积分排行榜
     *
     * @param limit 数量限制
     * @return 排行榜列表
     */
    java.util.List<java.util.Map<String, Object>> getPointsRanking(Integer limit);

    /**
     * 管理员获取所有用户积分列表
     *
     * @param page     分页参数
     * @param userName 用户名（可选）
     * @return 用户积分列表
     */
    Page<UserPointsVO> adminGetUserPointsList(Page<UserPointsVO> page, String userName);
}

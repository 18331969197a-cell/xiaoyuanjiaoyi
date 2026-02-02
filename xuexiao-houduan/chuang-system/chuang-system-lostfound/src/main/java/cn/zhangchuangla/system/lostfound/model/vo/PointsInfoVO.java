package cn.zhangchuangla.system.lostfound.model.vo;

import lombok.Data;

/**
 * 积分信息VO
 *
 * @author Chuang
 */
@Data
public class PointsInfoVO {

    /**
     * 当前积分
     */
    private Integer points;

    /**
     * 信誉等级
     */
    private Integer level;

    /**
     * 累计获得积分
     */
    private Integer totalEarned;

    /**
     * 累计消耗积分
     */
    private Integer totalSpent;

    /**
     * 下一等级所需积分
     */
    private Integer nextLevelPoints;
}

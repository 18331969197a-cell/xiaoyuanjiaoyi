package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizGift;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * 礼品 Mapper
 *
 * @author Chuang
 */
public interface BizGiftMapper extends BaseMapper<BizGift> {

    /**
     * 扣减库存
     *
     * @param giftId   礼品ID
     * @param quantity 扣减数量
     * @return 影响行数
     */
    int decreaseStock(@Param("giftId") Long giftId, @Param("quantity") Integer quantity);

    /**
     * 增加兑换数量
     *
     * @param giftId   礼品ID
     * @param quantity 增加数量
     * @return 影响行数
     */
    int increaseExchangeCount(@Param("giftId") Long giftId, @Param("quantity") Integer quantity);
}

package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizGift;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.util.List;

/**
 * 礼品服务接口
 *
 * @author Chuang
 */
public interface GiftService {

    /**
     * 创建礼品
     *
     * @param gift 礼品信息
     * @param userId 创建人ID
     * @return 礼品ID
     */
    Long createGift(BizGift gift, Long userId);

    /**
     * 更新礼品
     *
     * @param gift 礼品信息
     */
    void updateGift(BizGift gift);

    /**
     * 删除礼品
     *
     * @param id 礼品ID
     */
    void deleteGift(Long id);

    /**
     * 获取礼品详情
     *
     * @param id 礼品ID
     * @return 礼品信息
     */
    BizGift getGiftById(Long id);

    /**
     * 分页查询礼品列表（用户端，仅上架）
     *
     * @param page 分页参数
     * @param categoryId 分类ID
     * @param keyword 关键词
     * @return 礼品列表
     */
    Page<BizGift> listGiftsForUser(Page<BizGift> page, Long categoryId, String keyword);

    /**
     * 分页查询礼品列表（管理端，全部）
     *
     * @param page 分页参数
     * @param categoryId 分类ID
     * @param status 状态
     * @param keyword 关键词
     * @return 礼品列表
     */
    Page<BizGift> listGiftsForAdmin(Page<BizGift> page, Long categoryId, String status, String keyword);

    /**
     * 上架/下架礼品
     *
     * @param id 礼品ID
     * @param status 状态 ON/OFF
     */
    void updateStatus(Long id, String status);

    /**
     * 扣减库存
     *
     * @param giftId 礼品ID
     * @param quantity 数量
     * @return 是否成功
     */
    boolean decreaseStock(Long giftId, Integer quantity);

    /**
     * 增加兑换数量
     *
     * @param giftId 礼品ID
     * @param quantity 数量
     */
    void increaseExchangeCount(Long giftId, Integer quantity);

    /**
     * 检查礼品是否可兑换
     *
     * @param giftId 礼品ID
     * @param quantity 数量
     * @return 是否可兑换
     */
    boolean canExchange(Long giftId, Integer quantity);
}

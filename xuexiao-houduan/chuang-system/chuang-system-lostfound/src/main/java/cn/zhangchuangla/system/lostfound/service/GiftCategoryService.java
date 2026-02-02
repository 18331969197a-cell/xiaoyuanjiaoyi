package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizGiftCategory;

import java.util.List;

/**
 * 礼品分类服务接口
 *
 * @author Chuang
 */
public interface GiftCategoryService {

    /**
     * 创建分类
     *
     * @param category 分类信息
     * @return 分类ID
     */
    Long createCategory(BizGiftCategory category);

    /**
     * 更新分类
     *
     * @param category 分类信息
     */
    void updateCategory(BizGiftCategory category);

    /**
     * 删除分类
     *
     * @param id 分类ID
     */
    void deleteCategory(Long id);

    /**
     * 获取分类详情
     *
     * @param id 分类ID
     * @return 分类信息
     */
    BizGiftCategory getCategoryById(Long id);

    /**
     * 获取所有分类列表
     *
     * @return 分类列表
     */
    List<BizGiftCategory> listAllCategories();

    /**
     * 获取启用的分类列表
     *
     * @return 分类列表
     */
    List<BizGiftCategory> listEnabledCategories();

    /**
     * 启用/停用分类
     *
     * @param id     分类ID
     * @param status 状态
     */
    void updateStatus(Long id, Integer status);

    /**
     * 检查分类是否可以删除（没有关联礼品）
     *
     * @param id 分类ID
     * @return 是否可以删除
     */
    boolean canDelete(Long id);

    /**
     * 统计分类下的礼品数量
     *
     * @param categoryId 分类ID
     * @return 礼品数量
     */
    Integer countGiftsByCategoryId(Long categoryId);
}

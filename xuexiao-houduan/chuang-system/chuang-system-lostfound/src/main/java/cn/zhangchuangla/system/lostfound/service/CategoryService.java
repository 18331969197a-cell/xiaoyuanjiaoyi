package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizCategory;

import java.util.List;

/**
 * 物品分类服务接口
 *
 * @author Chuang
 */
public interface CategoryService {

    /**
     * 创建分类
     *
     * @param category 分类信息
     * @return 分类ID
     */
    Long createCategory(BizCategory category);

    /**
     * 更新分类
     *
     * @param category 分类信息
     */
    void updateCategory(BizCategory category);

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
    BizCategory getCategoryById(Long id);

    /**
     * 获取所有分类列表
     *
     * @return 分类列表
     */
    List<BizCategory> listAllCategories();

    /**
     * 获取启用的分类列表
     *
     * @return 分类列表
     */
    List<BizCategory> listEnabledCategories();

    /**
     * 根据筛选条件获取分类列表
     *
     * @param name 分类名称（模糊匹配）
     * @param status 状态
     * @return 分类列表
     */
    List<BizCategory> listCategoriesWithFilter(String name, Integer status);

    /**
     * 构建分类树形结构
     *
     * @param categories 分类列表
     * @return 树形结构
     */
    List<BizCategory> buildCategoryTree(List<BizCategory> categories);

    /**
     * 启用/停用分类
     *
     * @param id     分类ID
     * @param status 状态
     */
    void updateStatus(Long id, Integer status);

    /**
     * 检查分类是否可以删除（没有关联帖子）
     *
     * @param id 分类ID
     * @return 是否可以删除
     */
    boolean canDelete(Long id);
}

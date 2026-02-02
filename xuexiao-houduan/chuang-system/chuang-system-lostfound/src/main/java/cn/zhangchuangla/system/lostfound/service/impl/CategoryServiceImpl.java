package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.config.CacheConfig;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizCategoryMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizCategory;
import cn.zhangchuangla.system.lostfound.service.CategoryService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 物品分类服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final BizCategoryMapper categoryMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConfig.CACHE_CATEGORIES, allEntries = true)
    public Long createCategory(BizCategory category) {
        // 校验必填字段
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "分类名称不能为空");
        }
        // 设置默认值
        if (category.getParentId() == null) {
            category.setParentId(0L);
        }
        if (category.getSort() == null) {
            category.setSort(0);
        }
        if (category.getStatus() == null) {
            category.setStatus(1);
        }
        categoryMapper.insert(category);
        return category.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConfig.CACHE_CATEGORIES, allEntries = true)
    public void updateCategory(BizCategory category) {
        categoryMapper.updateById(category);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConfig.CACHE_CATEGORIES, allEntries = true)
    public void deleteCategory(Long id) {
        if (!canDelete(id)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "该分类下存在帖子，无法删除");
        }
        // 检查是否有子分类
        LambdaQueryWrapper<BizCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizCategory::getParentId, id);
        Long childCount = categoryMapper.selectCount(wrapper);
        if (childCount > 0) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "该分类下存在子分类，无法删除");
        }
        categoryMapper.deleteById(id);
    }

    @Override
    public BizCategory getCategoryById(Long id) {
        return categoryMapper.selectById(id);
    }

    @Override
    @Cacheable(value = CacheConfig.CACHE_CATEGORIES, key = "'all'")
    public List<BizCategory> listAllCategories() {
        LambdaQueryWrapper<BizCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(BizCategory::getSort);
        return categoryMapper.selectList(wrapper);
    }

    @Override
    @Cacheable(value = CacheConfig.CACHE_CATEGORIES, key = "'enabled'")
    public List<BizCategory> listEnabledCategories() {
        LambdaQueryWrapper<BizCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizCategory::getStatus, 1);
        wrapper.orderByAsc(BizCategory::getSort);
        return categoryMapper.selectList(wrapper);
    }

    @Override
    public List<BizCategory> listCategoriesWithFilter(String name, Integer status) {
        LambdaQueryWrapper<BizCategory> wrapper = new LambdaQueryWrapper<>();
        if (name != null && !name.trim().isEmpty()) {
            wrapper.like(BizCategory::getName, name.trim());
        }
        if (status != null) {
            wrapper.eq(BizCategory::getStatus, status);
        }
        wrapper.orderByAsc(BizCategory::getSort);
        return categoryMapper.selectList(wrapper);
    }

    @Override
    public List<BizCategory> buildCategoryTree(List<BizCategory> categories) {
        if (categories == null || categories.isEmpty()) {
            return new ArrayList<>();
        }
        // 按父ID分组
        Map<Long, List<BizCategory>> parentMap = categories.stream()
                .collect(Collectors.groupingBy(BizCategory::getParentId));
        // 获取顶级分类
        List<BizCategory> rootList = parentMap.getOrDefault(0L, new ArrayList<>());
        // 递归构建树
        for (BizCategory root : rootList) {
            buildChildren(root, parentMap);
        }
        return rootList;
    }

    private void buildChildren(BizCategory parent, Map<Long, List<BizCategory>> parentMap) {
        List<BizCategory> children = parentMap.get(parent.getId());
        if (children != null && !children.isEmpty()) {
            parent.setChildren(children);
            for (BizCategory child : children) {
                buildChildren(child, parentMap);
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConfig.CACHE_CATEGORIES, allEntries = true)
    public void updateStatus(Long id, Integer status) {
        BizCategory category = new BizCategory();
        category.setId(id);
        category.setStatus(status);
        categoryMapper.updateById(category);
    }

    @Override
    public boolean canDelete(Long id) {
        Integer postCount = categoryMapper.countPostsByCategoryId(id);
        return postCount == null || postCount == 0;
    }
}

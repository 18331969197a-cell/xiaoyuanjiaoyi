package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizGiftCategoryMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizGiftCategory;
import cn.zhangchuangla.system.lostfound.service.GiftCategoryService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 礼品分类服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class GiftCategoryServiceImpl implements GiftCategoryService {

    private final BizGiftCategoryMapper giftCategoryMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createCategory(BizGiftCategory category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "分类名称不能为空");
        }
        if (category.getSort() == null) {
            category.setSort(0);
        }
        if (category.getStatus() == null) {
            category.setStatus(1);
        }
        giftCategoryMapper.insert(category);
        return category.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateCategory(BizGiftCategory category) {
        giftCategoryMapper.updateById(category);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCategory(Long id) {
        if (!canDelete(id)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "该分类下存在礼品，无法删除");
        }
        giftCategoryMapper.deleteById(id);
    }

    @Override
    public BizGiftCategory getCategoryById(Long id) {
        return giftCategoryMapper.selectById(id);
    }

    @Override
    public List<BizGiftCategory> listAllCategories() {
        LambdaQueryWrapper<BizGiftCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(BizGiftCategory::getSort);
        return giftCategoryMapper.selectList(wrapper);
    }

    @Override
    public List<BizGiftCategory> listEnabledCategories() {
        LambdaQueryWrapper<BizGiftCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizGiftCategory::getStatus, 1);
        wrapper.orderByAsc(BizGiftCategory::getSort);
        return giftCategoryMapper.selectList(wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, Integer status) {
        BizGiftCategory category = new BizGiftCategory();
        category.setId(id);
        category.setStatus(status);
        giftCategoryMapper.updateById(category);
    }

    @Override
    public boolean canDelete(Long id) {
        Integer giftCount = countGiftsByCategoryId(id);
        return giftCount == null || giftCount == 0;
    }

    @Override
    public Integer countGiftsByCategoryId(Long categoryId) {
        return giftCategoryMapper.countGiftsByCategoryId(categoryId);
    }
}

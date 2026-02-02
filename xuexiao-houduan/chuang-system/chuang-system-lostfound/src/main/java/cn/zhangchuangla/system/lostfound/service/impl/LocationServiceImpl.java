package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.config.CacheConfig;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizLocationMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizLocation;
import cn.zhangchuangla.system.lostfound.service.LocationService;
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
 * 校园地点服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class LocationServiceImpl implements LocationService {

    private final BizLocationMapper locationMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConfig.CACHE_LOCATIONS, allEntries = true)
    public Long createLocation(BizLocation location) {
        // 校验必填字段
        if (location.getName() == null || location.getName().trim().isEmpty()) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "地点名称不能为空");
        }
        if (location.getParentId() == null) {
            location.setParentId(0L);
        }
        if (location.getSort() == null) {
            location.setSort(0);
        }
        if (location.getStatus() == null) {
            location.setStatus(1);
        }
        if (location.getIsPickupPoint() == null) {
            location.setIsPickupPoint(0);
        }
        locationMapper.insert(location);
        return location.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConfig.CACHE_LOCATIONS, allEntries = true)
    public void updateLocation(BizLocation location) {
        locationMapper.updateById(location);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConfig.CACHE_LOCATIONS, allEntries = true)
    public void deleteLocation(Long id) {
        if (!canDelete(id)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "该地点下存在帖子，无法删除");
        }
        LambdaQueryWrapper<BizLocation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizLocation::getParentId, id);
        Long childCount = locationMapper.selectCount(wrapper);
        if (childCount > 0) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "该地点下存在子地点，无法删除");
        }
        locationMapper.deleteById(id);
    }

    @Override
    public BizLocation getLocationById(Long id) {
        return locationMapper.selectById(id);
    }

    @Override
    @Cacheable(value = CacheConfig.CACHE_LOCATIONS, key = "'all'")
    public List<BizLocation> listAllLocations() {
        LambdaQueryWrapper<BizLocation> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(BizLocation::getSort);
        return locationMapper.selectList(wrapper);
    }

    @Override
    @Cacheable(value = CacheConfig.CACHE_LOCATIONS, key = "'enabled'")
    public List<BizLocation> listEnabledLocations() {
        LambdaQueryWrapper<BizLocation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizLocation::getStatus, 1);
        wrapper.orderByAsc(BizLocation::getSort);
        return locationMapper.selectList(wrapper);
    }

    @Override
    public List<BizLocation> listLocationsWithFilter(String name, Integer status, Integer isPickupPoint) {
        LambdaQueryWrapper<BizLocation> wrapper = new LambdaQueryWrapper<>();
        if (name != null && !name.trim().isEmpty()) {
            wrapper.like(BizLocation::getName, name.trim());
        }
        if (status != null) {
            wrapper.eq(BizLocation::getStatus, status);
        }
        if (isPickupPoint != null) {
            wrapper.eq(BizLocation::getIsPickupPoint, isPickupPoint);
        }
        wrapper.orderByAsc(BizLocation::getSort);
        return locationMapper.selectList(wrapper);
    }

    @Override
    @Cacheable(value = CacheConfig.CACHE_LOCATIONS, key = "'pickup'")
    public List<BizLocation> listPickupPoints() {
        LambdaQueryWrapper<BizLocation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizLocation::getIsPickupPoint, 1);
        wrapper.eq(BizLocation::getStatus, 1);
        wrapper.orderByAsc(BizLocation::getSort);
        return locationMapper.selectList(wrapper);
    }

    @Override
    public List<BizLocation> buildLocationTree(List<BizLocation> locations) {
        if (locations == null || locations.isEmpty()) {
            return new ArrayList<>();
        }
        Map<Long, List<BizLocation>> parentMap = locations.stream()
                .collect(Collectors.groupingBy(BizLocation::getParentId));
        List<BizLocation> rootList = parentMap.getOrDefault(0L, new ArrayList<>());
        for (BizLocation root : rootList) {
            buildChildren(root, parentMap);
        }
        return rootList;
    }

    private void buildChildren(BizLocation parent, Map<Long, List<BizLocation>> parentMap) {
        List<BizLocation> children = parentMap.get(parent.getId());
        if (children != null && !children.isEmpty()) {
            parent.setChildren(children);
            for (BizLocation child : children) {
                buildChildren(child, parentMap);
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, Integer status) {
        BizLocation location = new BizLocation();
        location.setId(id);
        location.setStatus(status);
        locationMapper.updateById(location);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setPickupPoint(Long id, Integer isPickupPoint, String openTime, String contact) {
        BizLocation location = new BizLocation();
        location.setId(id);
        location.setIsPickupPoint(isPickupPoint);
        location.setOpenTime(openTime);
        location.setContact(contact);
        locationMapper.updateById(location);
    }

    @Override
    public boolean canDelete(Long id) {
        Integer postCount = locationMapper.countPostsByLocationId(id);
        return postCount == null || postCount == 0;
    }
}

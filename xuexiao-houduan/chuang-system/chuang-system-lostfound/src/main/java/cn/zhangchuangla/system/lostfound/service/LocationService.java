package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizLocation;

import java.util.List;

/**
 * 校园地点服务接口
 *
 * @author Chuang
 */
public interface LocationService {

    /**
     * 创建地点
     *
     * @param location 地点信息
     * @return 地点ID
     */
    Long createLocation(BizLocation location);

    /**
     * 更新地点
     *
     * @param location 地点信息
     */
    void updateLocation(BizLocation location);

    /**
     * 删除地点
     *
     * @param id 地点ID
     */
    void deleteLocation(Long id);

    /**
     * 获取地点详情
     *
     * @param id 地点ID
     * @return 地点信息
     */
    BizLocation getLocationById(Long id);

    /**
     * 获取所有地点列表
     *
     * @return 地点列表
     */
    List<BizLocation> listAllLocations();

    /**
     * 获取启用的地点列表
     *
     * @return 地点列表
     */
    List<BizLocation> listEnabledLocations();

    /**
     * 根据筛选条件获取地点列表
     *
     * @param name 地点名称（模糊匹配）
     * @param status 状态
     * @param isPickupPoint 是否招领点
     * @return 地点列表
     */
    List<BizLocation> listLocationsWithFilter(String name, Integer status, Integer isPickupPoint);

    /**
     * 获取招领点列表
     *
     * @return 招领点列表
     */
    List<BizLocation> listPickupPoints();

    /**
     * 构建地点树形结构
     *
     * @param locations 地点列表
     * @return 树形结构
     */
    List<BizLocation> buildLocationTree(List<BizLocation> locations);

    /**
     * 启用/停用地点
     *
     * @param id     地点ID
     * @param status 状态
     */
    void updateStatus(Long id, Integer status);

    /**
     * 设置/取消招领点
     *
     * @param id            地点ID
     * @param isPickupPoint 是否招领点
     * @param openTime      开放时间
     * @param contact       联系方式
     */
    void setPickupPoint(Long id, Integer isPickupPoint, String openTime, String contact);

    /**
     * 检查地点是否可以删除（没有关联帖子）
     *
     * @param id 地点ID
     * @return 是否可以删除
     */
    boolean canDelete(Long id);
}

package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizLocation;
import cn.zhangchuangla.system.lostfound.service.LocationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 校园地点控制器
 *
 * @author Chuang
 */
@Tag(name = "校园地点管理")
@RestController
@RequestMapping("/lostfound/location")
@RequiredArgsConstructor
public class LocationController extends BaseController {

    private final LocationService locationService;

    @Operation(summary = "获取地点树")
    @GetMapping("/tree")
    public AjaxResult<List<BizLocation>> getLocationTree(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "isPickupPoint", required = false) Integer isPickupPoint) {
        List<BizLocation> locations = locationService.listLocationsWithFilter(name, status, isPickupPoint);
        List<BizLocation> tree = locationService.buildLocationTree(locations);
        return AjaxResult.success(tree);
    }

    @Operation(summary = "获取所有地点列表")
    @GetMapping("/list")
    public AjaxResult<List<BizLocation>> listAll() {
        return AjaxResult.success(locationService.listAllLocations());
    }

    @Operation(summary = "获取招领点列表")
    @GetMapping("/pickup-points")
    public AjaxResult<List<BizLocation>> listPickupPoints() {
        return AjaxResult.success(locationService.listPickupPoints());
    }

    @Operation(summary = "获取地点详情")
    @GetMapping("/{id}")
    public AjaxResult<BizLocation> getById(@PathVariable("id") Long id) {
        return AjaxResult.success(locationService.getLocationById(id));
    }

    @Operation(summary = "创建地点")
    @PostMapping
    @PreAuthorize("@ss.hasPermission('lostfound:location:add')")
    @OperationLog(title = "创建地点")
    public AjaxResult<Long> create(@RequestBody BizLocation location) {
        return AjaxResult.success(locationService.createLocation(location));
    }

    @Operation(summary = "更新地点")
    @PutMapping
    @PreAuthorize("@ss.hasPermission('lostfound:location:edit')")
    @OperationLog(title = "更新地点")
    public AjaxResult<Void> update(@RequestBody BizLocation location) {
        locationService.updateLocation(location);
        return AjaxResult.success();
    }

    @Operation(summary = "删除地点")
    @DeleteMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:location:delete')")
    @OperationLog(title = "删除地点")
    public AjaxResult<Void> delete(@PathVariable("id") Long id) {
        locationService.deleteLocation(id);
        return AjaxResult.success();
    }

    @Operation(summary = "更新地点状态")
    @PutMapping("/{id}/status/{status}")
    @PreAuthorize("@ss.hasPermission('lostfound:location:edit')")
    @OperationLog(title = "更新地点状态")
    public AjaxResult<Void> updateStatus(@PathVariable("id") Long id, @PathVariable("status") Integer status) {
        locationService.updateStatus(id, status);
        return AjaxResult.success();
    }

    @Operation(summary = "设置招领点")
    @PutMapping("/{id}/pickup-point")
    @PreAuthorize("@ss.hasPermission('lostfound:location:edit')")
    @OperationLog(title = "设置招领点")
    public AjaxResult<Void> setPickupPoint(@PathVariable("id") Long id,
                                           @RequestParam(value = "isPickupPoint") Integer isPickupPoint,
                                           @RequestParam(value = "openTime", required = false) String openTime,
                                           @RequestParam(value = "contact", required = false) String contact) {
        locationService.setPickupPoint(id, isPickupPoint, openTime, contact);
        return AjaxResult.success();
    }
}

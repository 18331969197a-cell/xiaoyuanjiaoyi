package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.model.entity.BizNotification;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 公告控制器
 *
 * @author Chuang
 */
@Tag(name = "公告管理")
@RestController
@RequestMapping("/lostfound")
@RequiredArgsConstructor
public class AnnouncementController extends BaseController {

    private final NotificationService notificationService;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 获取公告列表（公开接口，用于首页展示）
     * 同时读取 biz_notification 和 sys_notice 表的公告
     */
    @Operation(summary = "获取公告列表")
    @GetMapping("/announcement/list")
    public AjaxResult<List<Map<String, Object>>> list() {
        List<Map<String, Object>> result = new ArrayList<>();
        
        // 1. 获取失物招领模块的公告通知
        List<BizNotification> announcements = notificationService.getLatestAnnouncements(5);
        for (BizNotification n : announcements) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", n.getId());
            map.put("noticeTitle", n.getTitle());
            map.put("noticeContent", n.getContent());
            map.put("noticeType", "announcement");
            map.put("createTime", n.getCreateTime());
            map.put("source", "lostfound");
            result.add(map);
        }
        
        // 2. 获取系统公告（sys_notice表）
        try {
            String sql = "SELECT id, notice_title, notice_content, notice_type, create_time " +
                        "FROM sys_notice ORDER BY create_time DESC LIMIT 5";
            List<Map<String, Object>> sysNotices = jdbcTemplate.queryForList(sql);
            for (Map<String, Object> notice : sysNotices) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", "sys_" + notice.get("id"));
                map.put("noticeTitle", notice.get("notice_title"));
                map.put("noticeContent", notice.get("notice_content"));
                map.put("noticeType", "announcement");
                map.put("createTime", notice.get("create_time"));
                map.put("source", "system");
                result.add(map);
            }
        } catch (Exception e) {
            // 如果sys_notice表不存在或查询失败，忽略
        }
        
        // 3. 按创建时间排序，取最新5条
        result.sort((a, b) -> {
            Object timeA = a.get("createTime");
            Object timeB = b.get("createTime");
            if (timeA == null) return 1;
            if (timeB == null) return -1;
            return timeB.toString().compareTo(timeA.toString());
        });
        
        if (result.size() > 5) {
            result = result.subList(0, 5);
        }
        
        return AjaxResult.success(result);
    }

    /**
     * 发布系统公告（管理员接口）
     */
    @Operation(summary = "发布系统公告")
    @PostMapping("/admin/announcement/publish")
    public AjaxResult<Void> publish(@RequestBody Map<String, Object> params) {
        String title = (String) params.get("title");
        String content = (String) params.get("content");
        Boolean onlyVerified = (Boolean) params.getOrDefault("onlyVerified", false);
        
        if (title == null || title.trim().isEmpty()) {
            return AjaxResult.error("公告标题不能为空");
        }
        if (content == null || content.trim().isEmpty()) {
            return AjaxResult.error("公告内容不能为空");
        }
        
        notificationService.createAnnouncementForAllUsers(title, content, onlyVerified);
        return AjaxResult.success();
    }
}

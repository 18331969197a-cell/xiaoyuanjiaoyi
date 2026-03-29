package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.entity.security.SysUser;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizStudentRosterMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizStudentRoster;
import cn.zhangchuangla.system.lostfound.model.vo.StudentRosterDTO;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationRecordVO;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationRequest;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationStatus;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import cn.zhangchuangla.system.lostfound.service.VerificationService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 身份认证服务实现
 *
 * @author Chuang
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class VerificationServiceImpl implements VerificationService {

    private final BizStudentRosterMapper studentRosterMapper;
    
    /**
     * BCrypt密码编码器，用于安全加密身份证后6位
     */
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired(required = false)
    private BaseMapper<SysUser> sysUserMapper;
    
    @Lazy
    @Autowired(required = false)
    private NotificationService notificationService;

    /**
     * 加密身份证后6位（使用BCrypt）
     * BCrypt自动包含随机盐值，每次加密结果不同但可验证
     */
    private String encryptIdCardSuffix(String idCardSuffix) {
        return passwordEncoder.encode(idCardSuffix);
    }
    
    /**
     * 验证身份证后6位是否匹配（BCrypt验证）
     */
    private boolean matchesIdCardSuffix(String rawIdCardSuffix, String encodedIdCardSuffix) {
        // 兼容旧的MD5加密数据
        if (encodedIdCardSuffix != null && encodedIdCardSuffix.length() == 32) {
            // MD5加密结果为32位，进行MD5验证
            String md5Hash = DigestUtils.md5DigestAsHex(rawIdCardSuffix.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            return md5Hash.equals(encodedIdCardSuffix);
        }
        // BCrypt验证
        return passwordEncoder.matches(rawIdCardSuffix, encodedIdCardSuffix);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public VerificationStatus verify(Long userId, VerificationRequest request) {
        // 1. 检查用户是否已认证
        if (isVerified(userId)) {
            return VerificationStatus.builder()
                    .verified(true)
                    .message("您已完成身份认证，无需重复认证")
                    .build();
        }

        // 2. 根据学号和姓名查询学生（BCrypt不能直接用于SQL查询）
        BizStudentRoster student = studentRosterMapper.selectByStudentNoAndName(
                request.getStudentNo(),
                request.getRealName()
        );

        // 3. 验证学生是否存在
        if (student == null) {
            log.info("身份认证失败，学号或姓名不匹配: userId={}, studentNo={}", userId, request.getStudentNo());
            return VerificationStatus.builder()
                    .verified(false)
                    .message("认证失败，学号、姓名或身份证信息不匹配")
                    .build();
        }

        // 4. 验证身份证后6位（支持BCrypt和MD5兼容验证）
        if (!matchesIdCardSuffix(request.getIdCardSuffix(), student.getIdCardSuffix())) {
            log.info("身份认证失败，身份证信息不匹配: userId={}, studentNo={}", userId, request.getStudentNo());
            return VerificationStatus.builder()
                    .verified(false)
                    .message("认证失败，学号、姓名或身份证信息不匹配")
                    .build();
        }

        // 5. 检查学号是否已被其他用户绑定
        if (student.getBoundUserId() != null && !student.getBoundUserId().equals(userId)) {
            log.info("学号已被绑定: studentNo={}, boundUserId={}", request.getStudentNo(), student.getBoundUserId());
            return VerificationStatus.builder()
                    .verified(false)
                    .message("该学号已被其他用户绑定，如有疑问请联系管理员")
                    .build();
        }

        // 6. 更新学生名单绑定关系
        student.setBoundUserId(userId);
        student.setUpdateTime(LocalDateTime.now());
        studentRosterMapper.updateById(student);

        // 7. 更新用户认证状态
        updateUserVerificationStatus(userId, request.getStudentNo(), true);

        log.info("身份认证成功: userId={}, studentNo={}", userId, request.getStudentNo());

        // 发送认证成功通知
        sendVerificationNotification(userId, true, student.getRealName(), student.getStudentNo(), null);

        return VerificationStatus.builder()
                .verified(true)
                .studentNo(student.getStudentNo())
                .realName(student.getRealName())
                .college(student.getCollege())
                .major(student.getMajor())
                .className(student.getClassName())
                .verifiedTime(LocalDateTime.now())
                .message("身份认证成功")
                .build();
    }

    /**
     * 发送身份认证通知
     */
    private void sendVerificationNotification(Long userId, boolean success, String realName, String studentNo, String reason) {
        if (notificationService == null) {
            return;
        }
        try {
            String title;
            String content;
            if (success) {
                title = "身份认证成功";
                content = "恭喜您，身份认证已通过！学号：" + studentNo + "，姓名：" + realName;
            } else if (reason != null && reason.contains("撤销")) {
                title = "身份认证已撤销";
                content = "您的身份认证已被管理员撤销，如有疑问请联系管理员。";
            } else {
                title = "身份认证失败";
                content = "身份认证未通过" + (reason != null ? "，原因：" + reason : "，请检查信息后重试。");
            }
            notificationService.createNotification(userId, NotificationTypeEnum.VERIFICATION, title, content, "VERIFICATION", null);
        } catch (Exception e) {
            // 通知发送失败不影响主流程
        }
    }


    @Override
    public VerificationStatus getVerificationStatus(Long userId) {
        if (sysUserMapper == null) {
            return VerificationStatus.builder()
                    .verified(false)
                    .message("系统配置错误")
                    .build();
        }

        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            return VerificationStatus.builder()
                    .verified(false)
                    .message("用户不存在")
                    .build();
        }

        boolean verified = user.getVerified() != null && user.getVerified() == 1;

        if (!verified) {
            return VerificationStatus.builder()
                    .verified(false)
                    .message("您尚未完成身份认证，请先进行认证")
                    .build();
        }

        // 查询学生详细信息
        BizStudentRoster student = studentRosterMapper.selectByStudentNo(user.getVerifiedStudentNo());

        return VerificationStatus.builder()
                .verified(true)
                .studentNo(user.getVerifiedStudentNo())
                .realName(student != null ? student.getRealName() : null)
                .college(student != null ? student.getCollege() : null)
                .major(student != null ? student.getMajor() : null)
                .className(student != null ? student.getClassName() : null)
                .verifiedTime(user.getVerifiedTime())
                .message("已完成身份认证")
                .build();
    }

    @Override
    public boolean isVerified(Long userId) {
        if (sysUserMapper == null) {
            return false;
        }
        SysUser user = sysUserMapper.selectById(userId);
        return user != null && user.getVerified() != null && user.getVerified() == 1;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void revokeVerification(Long userId) {
        if (sysUserMapper == null) {
            return;
        }

        // 1. 解除学生名单绑定
        studentRosterMapper.unbindUser(userId);

        // 2. 更新用户认证状态
        updateUserVerificationStatus(userId, null, false);

        // 发送认证撤销通知
        sendVerificationNotification(userId, false, null, null, "撤销");

        log.info("撤销用户认证: userId={}", userId);
    }

    @Override
    public Page<BizStudentRoster> listStudentRoster(Page<BizStudentRoster> page, String keyword) {
        LambdaQueryWrapper<BizStudentRoster> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(BizStudentRoster::getStudentNo, keyword)
                    .or()
                    .like(BizStudentRoster::getRealName, keyword)
            );
        }
        wrapper.orderByDesc(BizStudentRoster::getCreateTime);
        return studentRosterMapper.selectPage(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int importStudentRoster(List<StudentRosterDTO> students) {
        if (students == null || students.isEmpty()) {
            return 0;
        }

        // 转换并加密身份证后6位
        List<BizStudentRoster> rosterList = new ArrayList<>();
        for (StudentRosterDTO dto : students) {
            BizStudentRoster roster = new BizStudentRoster();
            roster.setStudentNo(dto.getStudentNo());
            roster.setRealName(dto.getRealName());
            roster.setIdCardSuffix(encryptIdCardSuffix(dto.getIdCardSuffix()));
            roster.setCollege(dto.getCollege());
            roster.setMajor(dto.getMajor());
            roster.setClassName(dto.getClassName());
            roster.setEnrollmentYear(dto.getEnrollmentYear());
            roster.setStatus(dto.getStatus() != null ? dto.getStatus() : 0);
            rosterList.add(roster);
        }

        // 批量插入或更新
        return studentRosterMapper.batchInsertOrUpdate(rosterList);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Integer> importStudentRosterFromExcel(MultipartFile file) {
        Map<String, Integer> result = new HashMap<>();
        result.put("insertCount", 0);
        result.put("updateCount", 0);

        try (InputStream is = file.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {

            Sheet sheet = workbook.getSheetAt(0);
            List<StudentRosterDTO> students = new ArrayList<>();
            int startRowIndex = hasHeaderRow(sheet) ? 1 : 0;

            // 兼容“带表头”和“无表头”两种导入文件
            for (int i = startRowIndex; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                StudentRosterDTO dto = new StudentRosterDTO();
                dto.setStudentNo(getCellStringValue(row.getCell(0)));
                dto.setRealName(getCellStringValue(row.getCell(1)));
                dto.setIdCardSuffix(getCellStringValue(row.getCell(2)));
                dto.setCollege(getCellStringValue(row.getCell(3)));
                dto.setMajor(getCellStringValue(row.getCell(4)));
                dto.setClassName(getCellStringValue(row.getCell(5)));

                String enrollYear = getCellStringValue(row.getCell(6));
                if (StringUtils.hasText(enrollYear)) {
                    dto.setEnrollmentYear(Integer.parseInt(enrollYear));
                }

                // 验证必填字段
                if (StringUtils.hasText(dto.getStudentNo()) &&
                        StringUtils.hasText(dto.getRealName()) &&
                        StringUtils.hasText(dto.getIdCardSuffix())) {
                    students.add(dto);
                }
            }

            // 统计新增和更新数量
            int insertCount = 0;
            int updateCount = 0;
            for (StudentRosterDTO dto : students) {
                BizStudentRoster existing = studentRosterMapper.selectByStudentNo(dto.getStudentNo());
                if (existing != null) {
                    updateCount++;
                } else {
                    insertCount++;
                }
            }

            // 执行导入
            importStudentRoster(students);

            result.put("insertCount", insertCount);
            result.put("updateCount", updateCount);

        } catch (Exception e) {
            log.error("导入学生名单失败", e);
            throw new BusinessException(ErrorCode.BUSINESS_ERROR, "导入失败: " + e.getMessage());
        }

        return result;
    }

    private boolean hasHeaderRow(Sheet sheet) {
        Row firstRow = sheet.getRow(0);
        if (firstRow == null) {
            return false;
        }

        String studentNoHeader = getCellStringValue(firstRow.getCell(0));
        String realNameHeader = getCellStringValue(firstRow.getCell(1));
        String idCardSuffixHeader = getCellStringValue(firstRow.getCell(2));

        return "学号".equals(studentNoHeader)
                && "姓名".equals(realNameHeader)
                && ("身份证后6位".equals(idCardSuffixHeader) || "身份证后6位数".equals(idCardSuffixHeader));
    }

    /**
     * 获取单元格字符串值（使用DataFormatter替代废弃的setCellType）
     */
    private String getCellStringValue(Cell cell) {
        if (cell == null) return null;
        DataFormatter formatter = new DataFormatter();
        return formatter.formatCellValue(cell).trim();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteStudentRoster(Long id) {
        studentRosterMapper.deleteById(id);
    }

    @Override
    public Page<VerificationRecordVO> listVerificationRecords(Page<VerificationRecordVO> page,
                                                               String keyword,
                                                               Integer verified) {
        return studentRosterMapper.selectVerificationRecords(page, keyword, verified);
    }

    /**
     * 更新用户认证状态
     */
    private void updateUserVerificationStatus(Long userId, String studentNo, boolean verified) {
        if (sysUserMapper == null) {
            return;
        }
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setVerified(verified ? 1 : 0);
        user.setVerifiedStudentNo(studentNo);
        user.setVerifiedTime(verified ? LocalDateTime.now() : null);
        sysUserMapper.updateById(user);
    }
}

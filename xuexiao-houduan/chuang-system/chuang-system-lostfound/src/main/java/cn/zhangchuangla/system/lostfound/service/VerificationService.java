package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizStudentRoster;
import cn.zhangchuangla.system.lostfound.model.vo.StudentRosterDTO;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationRecordVO;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationRequest;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationStatus;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 身份认证服务接口
 *
 * @author Chuang
 */
public interface VerificationService {

    /**
     * 用户身份认证
     *
     * @param userId  用户ID
     * @param request 认证请求
     * @return 认证状态
     */
    VerificationStatus verify(Long userId, VerificationRequest request);

    /**
     * 查询用户认证状态
     *
     * @param userId 用户ID
     * @return 认证状态信息
     */
    VerificationStatus getVerificationStatus(Long userId);

    /**
     * 检查用户是否已认证
     *
     * @param userId 用户ID
     * @return 是否已认证
     */
    boolean isVerified(Long userId);

    /**
     * 撤销用户认证
     *
     * @param userId 用户ID
     */
    void revokeVerification(Long userId);

    /**
     * 分页查询学生名单
     *
     * @param page    分页参数
     * @param keyword 关键词(学号/姓名)
     * @return 学生名单列表
     */
    Page<BizStudentRoster> listStudentRoster(Page<BizStudentRoster> page, String keyword);

    /**
     * 批量导入学生名单
     *
     * @param students 学生列表
     * @return 导入数量
     */
    int importStudentRoster(List<StudentRosterDTO> students);

    /**
     * 从Excel导入学生名单
     *
     * @param file Excel文件
     * @return 导入结果(insertCount, updateCount)
     */
    Map<String, Integer> importStudentRosterFromExcel(MultipartFile file);

    /**
     * 删除学生名单
     *
     * @param id 学生名单ID
     */
    void deleteStudentRoster(Long id);

    /**
     * 分页查询认证记录
     *
     * @param page     分页参数
     * @param keyword  关键词(用户名/学号/姓名)
     * @param verified 认证状态(可选)
     * @return 认证记录列表
     */
    Page<VerificationRecordVO> listVerificationRecords(Page<VerificationRecordVO> page, 
                                                        String keyword, 
                                                        Integer verified);
}

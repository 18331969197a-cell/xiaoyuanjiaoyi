package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizStudentRoster;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationRecordVO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 学生名单 Mapper
 *
 * @author Chuang
 */
public interface BizStudentRosterMapper extends BaseMapper<BizStudentRoster> {

    /**
     * 根据学号、姓名、身份证后6位查询学生
     *
     * @param studentNo    学号
     * @param realName     真实姓名
     * @param idCardSuffix 身份证后6位(加密后)
     * @return 学生信息
     */
    BizStudentRoster selectByVerifyInfo(
            @Param("studentNo") String studentNo,
            @Param("realName") String realName,
            @Param("idCardSuffix") String idCardSuffix
    );

    /**
     * 根据学号和姓名查询学生（用于BCrypt验证）
     *
     * @param studentNo 学号
     * @param realName  真实姓名
     * @return 学生信息
     */
    BizStudentRoster selectByStudentNoAndName(
            @Param("studentNo") String studentNo,
            @Param("realName") String realName
    );

    /**
     * 根据学号查询学生
     *
     * @param studentNo 学号
     * @return 学生信息
     */
    BizStudentRoster selectByStudentNo(@Param("studentNo") String studentNo);

    /**
     * 批量插入或更新学生名单
     *
     * @param list 学生列表
     * @return 影响行数
     */
    int batchInsertOrUpdate(@Param("list") List<BizStudentRoster> list);

    /**
     * 解除用户绑定
     *
     * @param userId 用户ID
     * @return 影响行数
     */
    int unbindUser(@Param("userId") Long userId);

    /**
     * 分页查询认证记录
     *
     * @param page     分页参数
     * @param keyword  关键词
     * @param verified 认证状态
     * @return 认证记录列表
     */
    Page<VerificationRecordVO> selectVerificationRecords(
            Page<VerificationRecordVO> page,
            @Param("keyword") String keyword,
            @Param("verified") Integer verified
    );
}

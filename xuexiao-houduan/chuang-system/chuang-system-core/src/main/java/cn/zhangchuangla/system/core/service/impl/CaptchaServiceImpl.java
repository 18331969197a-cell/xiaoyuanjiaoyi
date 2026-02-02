package cn.zhangchuangla.system.core.service.impl;

import cn.zhangchuangla.common.cache.constant.CacheConstants;
import cn.zhangchuangla.common.cache.core.CacheProvider;
import cn.zhangchuangla.common.core.utils.Assert;
import cn.zhangchuangla.common.core.utils.CaptchaUtils;
import cn.zhangchuangla.common.core.utils.ImageCaptchaUtils;
import cn.zhangchuangla.system.core.model.request.CaptchaRequest;
import cn.zhangchuangla.system.core.model.vo.captcha.CaptchaImageVo;
import cn.zhangchuangla.system.core.service.CaptchaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * @author Chuang
 * <p>
 * created on 2025/8/4 03:04
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CaptchaServiceImpl implements CaptchaService {

    private final static String CAPTCHA_CODE_KEY = CacheConstants.CAPTCHA_CODE;
    private final CacheProvider cacheProvider;
    private final long timeout = 5;

    @Override
    public void sendEmail(CaptchaRequest request) {
        String code = CaptchaUtils.randomNumeric();
        log.info("邮箱验证码:{}", code);
        cacheProvider.set(CAPTCHA_CODE_KEY + request.getEmail(), code, timeout, TimeUnit.MINUTES);
    }

    @Override
    public void sendPhone(CaptchaRequest request) {
        String code = CaptchaUtils.randomNumeric();
        log.info("手机验证码:{}", code);
        cacheProvider.set(CAPTCHA_CODE_KEY + request.getPhone(), code, timeout, TimeUnit.MINUTES);
    }

    /**
     * 图形验证码验证
     *
     * @param uid  验证码唯一标识
     * @param code 验证码
     * @return 验证结果
     */
    @Override
    public boolean verifyImageCode(String uid, String code) {
        Assert.notEmpty(code, "验证码不能为空");
        Assert.notEmpty(uid, "验证码唯一标识不能为空");
        String cacheKey = CAPTCHA_CODE_KEY + uid;
        String cachedCode = cacheProvider.get(cacheKey);
        // 如果验证码不存在，输出日志并返回 false（而不是抛出异常）
        if (cachedCode == null || cachedCode.isEmpty()) {
            log.warn("验证码已过期或不存在，uuid: {}", uid);
            return false;
        }
        if (cachedCode.equals(code)) {
            cacheProvider.delete(cacheKey);
            log.info("验证码验证成功，uuid: {}", uid);
            return true;
        }
        log.warn("验证码不正确，uuid: {}, 接收: {}, 库中: {}", uid, code, cachedCode);
        return false;
    }


    /**
     * 邮箱验证码验证
     *
     * @param email 邮箱
     * @return 验证结果
     */
    @Override
    public boolean verifyEmail(String email, String code) {
        Assert.notEmpty(code, "验证码不能为空");
        Assert.notEmpty(email, "邮箱不能为空");
        String cacheKey = CAPTCHA_CODE_KEY + email;
        String cachedCode = cacheProvider.get(cacheKey);
        // 如果验证码不存在，输出日志并返回 false
        if (cachedCode == null || cachedCode.isEmpty()) {
            log.warn("邮箱验证码已过期或不存在，email: {}", email);
            return false;
        }
        if (cachedCode.equals(code)) {
            cacheProvider.delete(cacheKey);
            log.info("邮箱验证码验证成功，email: {}", email);
            return true;
        }
        log.warn("邮箱验证码不正确，email: {}", email);
        return false;
    }

    /**
     * 手机验证码验证
     *
     * @param phone 手机
     * @return 验证结果
     */
    @Override
    public boolean verifyPhone(String phone, String code) {
        Assert.notEmpty(phone, "手机不能为空");
        Assert.notEmpty(code, "验证码不能为空");
        String cacheKey = CAPTCHA_CODE_KEY + phone;
        String cachedCode = cacheProvider.get(cacheKey);
        // 如果验证码不存在，输出日志并返回 false
        if (cachedCode == null || cachedCode.isEmpty()) {
            log.warn("手机验证码已过期或不存在，phone: {}", phone);
            return false;
        }
        if (cachedCode.equals(code)) {
            cacheProvider.delete(cacheKey);
            log.info("手机验证码验证成功，phone: {}", phone);
            return true;
        }
        log.warn("手机验证码不正确，phone: {}", phone);
        return false;
    }

    /**
     * 生成图形验证码
     *
     * @return 图形验证码
     */
    @Override
    public CaptchaImageVo generateImageCaptcha() {
        // 测试模式：使用固定验证码 1234
        String code = "1234"; // CaptchaUtils.randomNumeric(4);

        String uuid = UUID.randomUUID().toString();
        String base64 = ImageCaptchaUtils.generateBase64Png(code, 160, 50);
        // 存储到缓存，大小写不敏感校验采用统一大写
        cacheProvider.set(CAPTCHA_CODE_KEY + uuid, code.toUpperCase(), timeout, TimeUnit.MINUTES);
        CaptchaImageVo vo = new CaptchaImageVo();
        vo.setUuid(uuid);
        vo.setImgBase64(base64);
        return vo;
    }


}

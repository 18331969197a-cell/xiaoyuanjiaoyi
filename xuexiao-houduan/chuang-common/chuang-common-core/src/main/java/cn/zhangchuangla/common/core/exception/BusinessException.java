package cn.zhangchuangla.common.core.exception;

import lombok.Getter;

/**
 * 业务异常类
 * 
 * @author Chuang
 */
@Getter
public class BusinessException extends RuntimeException {

    /**
     * 错误码
     */
    private final ErrorCode errorCode;
    
    /**
     * 额外信息
     */
    private final String detail;

    public BusinessException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.detail = null;
    }

    public BusinessException(ErrorCode errorCode, String detail) {
        super(errorCode.getMessage() + (detail != null ? ": " + detail : ""));
        this.errorCode = errorCode;
        this.detail = detail;
    }

    public BusinessException(String message) {
        super(message);
        this.errorCode = ErrorCode.BUSINESS_ERROR;
        this.detail = message;
    }

    public int getCode() {
        return errorCode.getCode();
    }
}

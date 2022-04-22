package com.bgd.api.common.exceptions;

import com.bgd.api.common.enums.ApiStatusEnum;

/**
 * @author guodg
 * @date 2021/5/12 10:03
 * @description
 */
public class ApiException extends Exception {
    // 异常码
    private String code;
    // 展示给用户看的信息
    private String showMessage;

    public ApiException(String showMessage) {
        this(ApiStatusEnum.RES_FAILURE.getCode(), showMessage, showMessage);
    }

    public ApiException(String code, String showMessage) {
        this(code, showMessage, showMessage);
    }

    public ApiException(String showMessage, Exception e) {
        this(ApiStatusEnum.RES_FAILURE.getCode(), showMessage, e.getMessage());
    }

    // message 为实际的异常信息，需要保存数据库
    public ApiException(String code, String showMessage, String message) {
        super(message);
        this.code = code;
        this.showMessage = showMessage;
    }

    public String getCode() {
        return code;
    }

    public String getShowMessage() {
        return showMessage;
    }
}

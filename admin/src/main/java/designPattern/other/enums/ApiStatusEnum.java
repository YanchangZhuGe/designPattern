package designPattern.other.enums;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/5 17:38
 */
public enum ApiStatusEnum {
    RES_SUCCESS("000000", "请求受理成功"),
    RES_FAILURE("999999", "请求受理失败"),
    // 校验类
    ERR_IP("100001", "IP未授权"),
    ERR_PARAM("100002", "参数错误，不符合报文规范"),
    ERR_OAUTH("100003", "用户未授权"),
    ERR_VERSION("100004", "版本号错误或不支持的版本号"),
    ERR_USER("100005", "用户名或者密码错误");

    private String code;
    private String message;

    ApiStatusEnum(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}

package com.example.enums;

/**
 * <p>Title: 支付通道枚举</p>
 *
 * <p>Description: 支付通道枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/10/28 12:29
 */
public enum PaymentRoadEnum {

    /**
     * swift通道
     */
    SWIFT(1, "swift通道"),
    /**
     * 国内结算通道
     */
    LOCAL_SETTLEMENT(2, "国内结算通道"),
    ;

    private final Integer value;
    private final String name;

    PaymentRoadEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public Integer getValue() {
        return value;
    }

    public String getName() {
        return name;
    }
}

package com.example.enums;

/**
 * <p>Title: 发BP状态枚举</p>
 *
 * <p>Description: 发BP状态枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/9 23:09
 */
public enum BpFlagEnum {

    /**
     * 未发BP
     */
    NONE(0, "未发BP"),
    /**
     * 发BP成功
     */
    SUCCESS(1, "发BP成功"),
    /**
     * 发BP失败
     */
    FAILURE(2, "发BP失败"),
    /**
     * 未发BP
     */
    BCM_NONE(0, "未发BCM"),
    /**
     * 发BP成功
     */
    BCM_SUCCESS(1, "发BCM成功"),
    /**
     * 发BP失败
     */
    BCM_FAILURE(2, "发BCM失败");


    private final Integer flag;
    private final String name;

    BpFlagEnum(Integer flag, String name) {
        this.flag = flag;
        this.name = name;
    }

    public Integer getFlag() {
        return flag;
    }

    public String getName() {
        return name;
    }
}

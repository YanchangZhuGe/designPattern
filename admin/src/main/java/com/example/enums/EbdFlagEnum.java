package com.example.enums;

/**
 * <p>Title: 做账标记枚举</p>
 *
 * <p>Description: 做账标记枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/9 23:09
 */
public enum EbdFlagEnum {

    /**
     * 未做账
     */
    NONE(0, "未做账"),
    /**
     * 做账成功
     */
    SUCCESS(1, "做账成功"),
    /**
     * 做账失败
     */
    FAILURE(2, "做账失败");


    private final Integer flag;
    private final String name;

    EbdFlagEnum(Integer flag, String name) {
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

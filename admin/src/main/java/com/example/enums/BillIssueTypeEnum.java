package com.example.enums;

/**
 * <p>Title: 票据付款方式枚举</p>
 *
 * <p>Description: 票据付款方式枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/8 0:14
 */
public enum BillIssueTypeEnum {

    /**
     * YS：应收（背书）
     */
    YS("YS", "背书"),
    /**
     * YF：应付（开票）
     */
    YF("YF", "开票");

    private final String type;
    private final String name;

    BillIssueTypeEnum(String type, String name) {
        this.type = type;
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    public static String getName(String type) {
        return valueOf(type).name;
    }
}

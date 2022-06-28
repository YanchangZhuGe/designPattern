package com.example.enums;

/**
 * <p>Title: 支票类型枚举</p>
 *
 * <p>Description: 支票类型枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/7 23:34
 */
public enum ChequeTypeEnum {
    /**
     * 现金支票
     */
    CASH_CHEQUE("Cash", "现金支票"),
    /**
     * 转账支票
     */
    TRANSFER_CHEQUE("Trans", "转账支票"),
    ;

    private final String type;
    private final String name;

    ChequeTypeEnum(String type, String name) {
        this.type = type;
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    //    public static String getName(String type) {
//        return valueOf(type).name;
//    }
    public static String getName(String type) {
        for (ChequeTypeEnum role : values()) {
            if (role.getType().equals(type)) {
                return role.getName();
            }
        }
        return "";
    }
}

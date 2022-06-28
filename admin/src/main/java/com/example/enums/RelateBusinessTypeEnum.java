package com.example.enums;

/**
 * <p>Title: 关联业务枚举</p>
 *
 * <p>Description: 关联业务枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/3 15:33
 */
public enum RelateBusinessTypeEnum {

    /**
     * 关联融资业务
     */
    GDT_BUSINESS("GDT_BUSINESS", "融资业务"),
    /**
     * 关联内部借款
     */
    INNER_LOAN("INNER_LOAN", "内部借款");

    private final String type;
    private final String name;

    RelateBusinessTypeEnum(String type, String name) {
        this.type = type;
        this.name = name;
    }

    public static String getName(String type) {
        for (RelateBusinessTypeEnum typeEnum : values()) {
            if (typeEnum.type.equals(type)) {
                return typeEnum.name;
            }
        }
        return "";
    }

    public String getType() {
        return type;
    }

    public String getName() {
        return name;
    }
}

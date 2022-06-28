package com.example.enums;

/**
 * <p>Title: 交易类型</p>
 *
 * <p>Description: 交易类型</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/24 14:58
 */
public enum TransTypeEnum {

    /**
     * 付汇
     */
    PFE(1, "付汇"),
    /**
     * 购汇
     */
    FEP(2, "购汇");

    private final Integer type;
    private final String name;

    TransTypeEnum(Integer type, String name) {
        this.type = type;
        this.name = name;
    }

    public Integer getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    public static TransTypeEnum get(Integer type) {
        if (type != null) {
            for (TransTypeEnum anEnum : values()) {
                if (anEnum.type.equals(type)) {
                    return anEnum;
                }
            }
        }
        return null;
    }
}

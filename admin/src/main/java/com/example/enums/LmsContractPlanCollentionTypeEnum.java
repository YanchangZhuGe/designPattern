package com.example.enums;

import lombok.Getter;

/**
 * @Classname LmsContractStateEnum
 * @Description 还款计划类型枚举
 * @Date 2022/1/12 9:14
 * @Created by Caiww
 */
@Getter
public enum LmsContractPlanCollentionTypeEnum {





    PRINCIPAL (1, "还本"),
    INTREST(2, "付息"),
    Collection(3, "其它")
    ;

    /**
     * 状态值
     */
    private Integer value;
    /**
     * 状态名称
     */
    private String name;

    /** 状态说明-公共 */
    public static final String stateCommonExplain = "无";

    LmsContractPlanCollentionTypeEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public static String getStateName(Integer value) {
        if (value != null) {
            for (LmsContractPlanCollentionTypeEnum e : values()) {
                if (e.getValue().equals(value)) {
                    return e.getName();
                }
            }
        }
        return "";
    }
}

package com.example.enums;

import lombok.Getter;

/**
 * @Classname LmsContractStateEnum
 * @Description 放还款计划状态枚举
 * @Date 2022/1/12 9:14
 * @Created by Caiww
 */
@Getter
public enum LmsContractPlanStateEnum {



    Unexecuted (1, "未执行"),
    Executed(2, "已执行"),
    Overdue(3, "逾期未执行"),
    Approve(4, "审批中")
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

    LmsContractPlanStateEnum(Integer value, String stateName) {
        this.value = value;
        this.name = name;
    }

    public static String getStateName(Integer value) {
        if (value != null) {
            for (LmsContractPlanStateEnum e : values()) {
                if (e.getValue().equals(value)) {
                    return e.getName();
                }
            }
        }
        return "";
    }
}

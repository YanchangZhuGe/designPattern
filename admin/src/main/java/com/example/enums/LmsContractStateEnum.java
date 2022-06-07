package com.example.enums;

import lombok.Getter;

/**
 * @Classname LmsContractStateEnum
 * @Description 合同状态枚举
 * @Date 2022/1/12 9:14
 * @Created by Caiww
 */
@Getter
public enum LmsContractStateEnum {



    Normal(1, "正常"),
    Deprecated(2, "作废"),
    Overdue(3, "逾期"),
    Extended(4, "展期"),
    Abort(8, "异常结项"),
    Finish(9, "结项")
    ;

    /**
     * 状态值
     */
    private Integer state;
    /**
     * 状态名称
     */
    private String stateName;

    /** 状态说明-公共 */
    public static final String stateCommonExplain = "无";

    LmsContractStateEnum(Integer state, String stateName) {
        this.state = state;
        this.stateName = stateName;
    }

    public static String getStateName(Integer state) {
        if (state != null) {
            for (LmsContractStateEnum e : values()) {
                if (e.getState().equals(state)) {
                    return e.getStateName();
                }
            }
        }
        return "";
    }
}

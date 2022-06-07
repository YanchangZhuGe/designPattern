package com.example.enums;

import lombok.Getter;

/**
 * @Classname LmsRepayTypeEnum
 * @Description 还款类型枚举
 */
@Getter
public enum LmsRepayTypeEnum {
    /*
     1本金、2利息、3手续费
     */
    CAPITAL(1, "本金"),
    INTEREST(2, "利息"),
    SERVICE_CHARGE(3, "手续费");

    /**
     * 值
     */
    private Integer value;
    /**
     * 名称
     */
    private String name;

    LmsRepayTypeEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public static String getStateName(Integer state) {
        for (LmsRepayTypeEnum e : values()) {
            if (e.getValue().equals(state)) {
                return e.getName();
            }
        }
        return "";
    }
}

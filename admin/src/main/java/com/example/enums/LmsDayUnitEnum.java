package com.example.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * @Classname LmsDayUnitEnum
 * @Description 期限单位枚举
 * @Date 2022/1/17 9:34
 * @Created by Caiww
 */
@Getter
@AllArgsConstructor
public enum LmsDayUnitEnum {

    DAY(0, "天"),
    MONTH(1, "月"),
    YEAR(2, "年");

    private Integer value;
    private String name;

    /**
     * 根据值获取名称
     * @param state
     * @return
     */
    public static String getName(Integer state) {
        if (state != null) {
            for (LmsDayUnitEnum e : values()) {
                if (e.getValue().equals(state)) {
                    return e.getName();
                }
            }
        }

        return "";
    }
}

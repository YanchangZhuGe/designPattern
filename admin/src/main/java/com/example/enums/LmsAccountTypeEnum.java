package com.example.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * @Classname LmsAccountTypeEnum
 * @Description 账户类型枚举
 * @Date 2022/1/13 17:56
 * @Created by Caiww
 */
@Getter
@AllArgsConstructor
public enum LmsAccountTypeEnum {

    BANK(1, "银行账户"),
    INTERNAL(2, "内部户");

    private Integer value;
    private String name;

    /**
     * 根据值获取名称
     * @param state
     * @return
     */
    public static String getName(Integer state) {
        if (state != null) {
            for (LmsAccountTypeEnum e : values()) {
                if (e.getValue().equals(state)) {
                    return e.getName();
                }
            }
        }

        return "";
    }

}

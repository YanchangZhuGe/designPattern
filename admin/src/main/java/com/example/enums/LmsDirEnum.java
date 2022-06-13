package com.example.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * @Classname
 * @Description 本单位借款方向枚举
 */
@Getter
@AllArgsConstructor
public enum LmsDirEnum {

    BORROWER("borrower", "借入方"),
    LENDER("lender", "借出方");

    private String value;
    private String name;

    /**
     * 根据值获取名称
     *
     * @param state
     * @return
     */
    public static String getName(Integer state) {
        if (state != null) {
            for (LmsDirEnum e : values()) {
                if (e.getValue().equals(state)) {
                    return e.getName();
                }
            }
        }

        return "";
    }
}

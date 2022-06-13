package com.example.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * @Classname LmsLedgerDirEnum
 * @Description 台账流水方向
 * @Date 2022/2/16 10:47
 * @Created by qinchuanxi
 */
@Getter
@AllArgsConstructor
public enum LmsLedgerDirEnum {

    LOAN(1, "放款"),
    REPAY(2, "还款");

    private Integer value;
    private String name;

    /**
     * 根据值获取名称
     * @param state
     * @return
     */
    public static String getName(Integer state) {
        if (state != null) {
            for (LmsLedgerDirEnum e : values()) {
                if (e.getValue().equals(state)) {
                    return e.getName();
                }
            }
        }

        return "";
    }

}

package com.example.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * @Classname LmsInterestTypeEnum
 * @Description 付息方式枚举
 * @Date 2022/1/13 16:41
 * @Created by Caiww
 */
@Getter
@AllArgsConstructor
public enum LmsInterestTypeEnum {
    CLEAR(0, "利随本清"),
    REGULAR(1, "定期结息")
    ;

    private Integer value;

    private String name;

    /**
     * 根据值获取名称
     * @param value
     * @return
     */
    public static String getName(Integer value) {
        if (value != null) {
            for (LmsInterestTypeEnum e : values()) {
                if (e.getValue().equals(value)) {
                    return e.getName();
                }
            }
        }
        return "";
    }
}

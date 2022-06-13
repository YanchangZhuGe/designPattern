package com.example.apifox.enums;

public enum ControlApplyEnum {

    CONTROL(1, "控制"),
    NOT_CONTROL(0, "不控制")
    ;
    private final Integer key;
    private final String value;

    private ControlApplyEnum(Integer key, String value){
        this.key = key;
        this.value = value;
    }

    public Integer getKey() {
        return key;
    }

    public String getValue() {
        return value;
    }
}

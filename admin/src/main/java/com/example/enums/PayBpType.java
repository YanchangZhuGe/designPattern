package com.example.enums;

/**
 * @Describtion：
 * @Autor：prince
 * @CreatTime：2021/11/16 11:23
 */
public enum PayBpType {
    PayBpType_00("0", "预付货款"),
    PayBpType_01("1", "货到付款"),
    PayBpType_02("2", "退款"),
    PayBpType_03("3", "其他"),
    ;


    private String value;
    private String name;

    PayBpType(String value, String name) {
        this.value = value;
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}

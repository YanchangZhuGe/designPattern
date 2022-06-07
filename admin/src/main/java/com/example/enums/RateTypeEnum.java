package com.example.enums;

/**
 * 利率类型
 *
 * @author chengming
 *
 */
public enum RateTypeEnum {

    /** 利率类型 */
    RATE_YEAR("RATE_YEAR", "年利率"),//1
    RATE_MONTH("RATE_MONTH", "月利率");//2

    private String code;
    private String text;

    RateTypeEnum(String code, String text) {
        this.code = code;
        this.text = text;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}

package com.example.utils.file.enums;

/**
 * 担保发起渠道
 *
 * @author Administrator
 */
public enum GuaranteeChannelEnum {
    //担保系统
    GWMS("GWMS", "担保"),
    LCMS("LCMS", "信用证"),
    LGM("LGM-Web", "保函"),
    GDEBIT("GDEBIT", "融资"),
    FEM("FEM", "外汇"),
    CLMS("CLMS", "授信");

    /**
     * 编码
     */
    private String value;
    /**
     * 名称
     */
    private String name;

    GuaranteeChannelEnum(String value, String name) {
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

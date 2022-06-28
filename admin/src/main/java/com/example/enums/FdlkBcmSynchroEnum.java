package com.example.enums;

/**
 * 调用FDLK类型
 */
public enum FdlkBcmSynchroEnum {


    PTMS_001("PTMS_001", "账户单笔支付接口"),
    PTMS_002("PTMS_002", "账户单笔支付结果查询接口"),
    PTMS_003("PTMS_003", "归集指令同步接口"),
    PTMS_004("PTMS_004", "账户批量支付接口"),
    PTMS_005("PTMS_005", "账户批量支付结果查询接口");
    private String code;
    private String value;

    FdlkBcmSynchroEnum(String code, String value) {
        this.code = code;
        this.value = value;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}

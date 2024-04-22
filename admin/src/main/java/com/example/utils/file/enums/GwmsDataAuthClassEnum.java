package com.example.utils.file.enums;

/**
 * 担保数据权限分类（单位权限，账号权限，业务权限等）
 */
public enum GwmsDataAuthClassEnum implements TypeEnum {

    UNIT("cust_no", "单位", "cust_no"),

    ACCOUNT("account_no", "账户", "account_no"),

    BUSSTYPE("type_no", "业务类型", "type_no");

    private String value;

    private String name;

    /** 查询权限所需的前缀（可以支持与value不一致） */
    private String prefix;

    GwmsDataAuthClassEnum(String value, String name, String prefix){
        this.value = value;
        this.name = name;
        this.prefix = prefix;
    }

    @Override
    public String getValue() {
        return value;
    }

    @Override
    public String getName() {
        return name;
    }

    public String getPrefix() {
        return this.prefix;
    }

}

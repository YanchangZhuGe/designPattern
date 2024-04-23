package com.example.utils.file.enums;

/**
 * 担保数据权限类型枚举
 */
public enum GwmsDataAuthTypeEnum implements TypeEnum {

    //目前queryValue定义来与value一致（因为数据库中就是2个字段），如果后续有要求不能一致，那么可以修改
//    UNIT("cust_no", "担保", "cust_no"),

    HANDLING("GWMS_handling", "担保经办", "GWMS_handling");

    private String value;

    private String name;

    /** 查询数据权限参数的key，比如单位经办权限：cust_no,GWMS_handling */
    private String queryValue;

    GwmsDataAuthTypeEnum(String value, String name, String queryValue){
        this.value = value;
        this.name = name;
        this.queryValue = queryValue;
    }

    @Override
    public String getValue() {
        return value;
    }

    @Override
    public String getName() {
        return name;
    }

    public String getQueryValue() {
        return this.queryValue;
    }

}

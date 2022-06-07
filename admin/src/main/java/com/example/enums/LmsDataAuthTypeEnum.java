package com.example.enums;


/**
 * 数据权限类型枚举
 */
public enum LmsDataAuthTypeEnum implements LmsTypeEnum {

    //目前queryValue定义来与value一致（因为数据库中就是2个字段），如果后续有要求不能一致，那么可以修改
    HANDLING("LMS_handling", "借款经办", "LMS_handling", "0", "lms_type_no");//借款模块目前没有经办权限，通过账号权限去控制

  //  ACCOUNT("LMS_account", "借款账号", "LMS_account", "1", "/api/nstc-lms/1.0/common/aims/n9/account/queryByAccount")

    private String value;

    private String name;

    /**
     * 查询数据权限参数的key，比如单位经办权限：cust_no,CTMS_handling
     */
    private String queryValue;

    /**
     * 是否自动注册用户中心权限控制
     */
    private String isAutoRegister;

    /**
     * 服务接⼝地址
     */
    private String serviceUrl;

    LmsDataAuthTypeEnum(String value, String name, String queryValue, String isAutoRegister, String serviceUrl) {
        this.value = value;
        this.name = name;
        this.queryValue = queryValue;
        this.isAutoRegister = isAutoRegister;
        this.serviceUrl = serviceUrl;
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

    public String getIsAutoRegister() {
        return this.isAutoRegister;
    }

    public String getServiceUrl() {
        return this.serviceUrl;
    }

}

package com.example.enums;

/**
 * <p>Title:排他网关</p>
 *
 * <p>Description: 工作流-排他网关 参数枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @since：2021/4/14 11:37
 */
public enum LmsUmFmParamEnum {

    LMS_FM004("LMS_FM004", "LMS", "isDevelop", "是否线下开展决策会议", 2);

    /**
     * 业务标识，需要和发起流程时⼊参保持⼀致，建议定义为静态变量，
     * 标识⼀般为模块编号+业务名称，例如:“LMS_FM004”。
     */
    private String bizType;
    /**
     * 模块编号，例:“LMS”。
     */
    private String appno;
    /**
     * 字段名称，例:“isDevelop”。
     */
    private String columnName;
    /**
     * 字段描述，例:“是否线下开展决策会议”。
     */
    private String columnDesc;
    /**
     * 字段类型(1:数值类型 2:字符串类型)，例:1。
     */
    private int columnType;

    LmsUmFmParamEnum(String bizType, String appno, String columnName, String columnDesc, int columnType) {
        this.bizType = bizType;
        this.appno = appno;
        this.columnName = columnName;
        this.columnDesc = columnDesc;
        this.columnType = columnType;
    }

    public String getBizType() {
        return bizType;
    }

    public void setBizType(String bizType) {
        this.bizType = bizType;
    }

    public String getAppno() {
        return appno;
    }

    public void setAppno(String appno) {
        this.appno = appno;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getColumnDesc() {
        return columnDesc;
    }

    public void setColumnDesc(String columnDesc) {
        this.columnDesc = columnDesc;
    }

    public int getColumnType() {
        return columnType;
    }

    public void setColumnType(int columnType) {
        this.columnType = columnType;
    }
}

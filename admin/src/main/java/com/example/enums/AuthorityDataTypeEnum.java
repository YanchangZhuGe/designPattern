package com.example.enums;

/**
 * <p>Title:数据权限类型枚举</p>
 * <p>Description:数据权限类型枚举</p>
 * <p>Company:北京九恒星科技股份有限公司</p>
 *
 * @author ym
 * @see
 * @since
 */
public enum AuthorityDataTypeEnum {

    /**
     * 单位权限
     */
    CUSTOMER_NO("cust_no", "单位与用户"),
    /**
     * 账户权限
     */
    PTMS_PAY_ACCOUNT_NO("ptms_pay_account_no", "账号与用户");


    private final String dataType;
    private final String description;

    AuthorityDataTypeEnum(String dataType, String description) {
        this.dataType = dataType;
        this.description = description;
    }

    public String getDataType() {
        return dataType;
    }

    public String getDescription() {
        return description;
    }

    public String getFullDataType() {
        if (this != CUSTOMER_NO) {
            return new StringBuilder(CUSTOMER_NO.dataType)
                    .append(",")
                    .append(this.dataType)
                    .toString();
        }
        return this.dataType;
    }

}

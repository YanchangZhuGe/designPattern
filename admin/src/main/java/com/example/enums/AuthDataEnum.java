package com.example.enums;

import org.apache.commons.lang3.StringUtils;

/**
 * <p>Title: 自定义数据权限业务品种</p>
 *
 * <p>Description: 自定义数据权限业务品种</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author dell
 * @version 1.0
 * @since：2021/11/23 17:08
 */
public enum AuthDataEnum {

    /**
     * 支付工具权限
     */
    SETTLEMENT_TOOLS("ptms-settlementTools", "付款-支付工具", "/api/nstc-ptms/1.0/common/dataInfo/settlementTools"),
    /**
     * 账户权限
     */
    ACCOUNT("ptms-account", "付款-账户", "/api/nstc-ptms/1.0/common/dataInfo/accounts");

    /**
     * 业务类型编号
     */
    private final String no;
    /**
     * 业务类型名称
     */
    private final String name;
    /**
     * 服务接⼝地址
     */
    private final String serviceUrl;

    AuthDataEnum(String no, String name, String serviceUrl) {
        this.no = no;
        this.name = name;
        this.serviceUrl = serviceUrl;
    }

    public String getNo() {
        return no;
    }

    public String getName() {
        return name;
    }

    public String getServiceUrl() {
        return serviceUrl;
    }

    public static AuthDataEnum getAuthDataEnum(String no) {
        for (final AuthDataEnum authDataEnum : values()) {
            if (StringUtils.equalsIgnoreCase(authDataEnum.getNo(), no)) {
                return authDataEnum;
            }
        }
        return null;
    }
}
package com.example.enums;

/**
 * <p>Title: 本地缓存枚举</p>
 *
 * <p>Description: 本地缓存枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/15 15:07
 */
public enum LocalCacheEnum {
    /**
     * 数据字典-结算工具
     */
    SETTLEMENT_TOOLS("ptms.settlementTool", "结算工具"),
    /**
     * 数据字典-付款类型
     */
    PAY_TYPE("ptms.payType", "付款类型"),
    /**
     * todo 数据字典-国资委资金用途
     */
    USE_OF_FUNDS("ptms.useOfFunds", "国资委资金用途"),
    /**
     * 支付限额
     */
    DIRECTED_PAY("DIRECTED_PAY", "支付限额"),
    RELATE_BUSINESS_TYPE("ptms.relateBusinessType", "付款关联业务类型"),

    ;

    private final String code;
    private final String name;

    LocalCacheEnum(String code, String name) {
        this.code = code;
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }
}

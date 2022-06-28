package com.example.enums;

import lombok.Getter;

/**
 * <p>Title: 内部户账号类型枚举</p>
 *
 * <p>Description: 内部户账号类型枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2022/4/15 18:13
 */
@Getter
public enum InnerAccountTypeEnum {

    /**
     * 定期账户
     */
    ZHLX01("ZHLX01", "定期账户"),
    /**
     * 通知账户
     */
    ZHLX02("ZHLX02", "通知账户"),
    /**
     * 应付账户
     */
    ZHLX03("ZHLX03", "应付账户"),
    /**
     * 应收账户
     */
    ZHLX04("ZHLX04", "应收账户"),
    /**
     * 协定账户
     */
    ZHLX05("ZHLX05", "协定账户"),
    /**
     * 活期账户
     */
    ZHLX06("ZHLX06", "活期账户"),
    /**
     * 借款账户
     */
    ZHLX07("ZHLX07", "借款账户"),
    /**
     * 现金账户
     */
    ZHLX08("ZHLX08", "现金账户"),
    /**
     * 现金账户
     */
    ZHLX09("ZHLX09", "现金账户"),
    /**
     * 票据账户
     */
    ZHLX10("ZHLX10", "票据账户"),
    /**
     * 借款专户
     */
    ZHLX11("ZHLX11", "借款专户"),
    /**
     * 头寸结算户
     */
    ZHLX12("ZHLX12", "头寸结算户"),
    /**
     * 利息收入账户
     */
    ZHLX13("ZHLX13", "利息收入账户"),
    /**
     * 利息支出账户
     */
    ZHLX14("ZHLX14", "利息支出账户"),
    /**
     * 其他
     */
    ZHLX15("ZHLX15", "其他");

    private final String code;
    private final String codeName;

    InnerAccountTypeEnum(String code, String codeName) {
        this.code = code;
        this.codeName = codeName;
    }
}

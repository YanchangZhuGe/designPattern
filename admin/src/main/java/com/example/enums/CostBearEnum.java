package com.example.enums;

/**
 * <p>Title: 国内外承担费用枚举</p>
 *
 * <p>Description: 国内外承担费用枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/24 15:24
 */
public enum CostBearEnum {

    /**
     * 付款人
     */
    PAYER("1", "付款人"),
    /**
     * 收款人
     */
    PAYEE("2", "收款人"),
    /**
     * 共同
     */
    together("3", "共同");

    private final String key;
    private final String name;

    CostBearEnum(String key, String name) {
        this.key = key;
        this.name = name;
    }

    public String getKey() {
        return key;
    }

    public String getName() {
        return name;
    }
}

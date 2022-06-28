package com.example.enums;

import lombok.Getter;

/**
 * <p>Title: 现金流台账业务来源</p>
 *
 * <p>Description: 现金流台账业务来源</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/12/14 15:13
 */
@Getter
public enum CashFlowSourceTypeEnum {

    /**
     * 现金流台账业务来源, 作为付款记现金流台账唯一标识的一部分
     */
    PAY_ORDER("PAY_ORDER", "付款支付单"),
    PAY_REFILL("PAY_REFILL", "付款流水处理"),
    ;

    private final String type;
    private final String name;

    CashFlowSourceTypeEnum(String type, String name) {
        this.type = type;
        this.name = name;
    }
}

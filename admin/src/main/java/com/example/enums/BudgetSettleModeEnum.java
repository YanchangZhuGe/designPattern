package com.example.enums;

/**
 * <p>Title: 预算结算方式枚举</p>
 *
 * <p>Description: 预算结算方式枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/22 14:32
 */
public enum BudgetSettleModeEnum {

    CASH(1, "现金"),
    BILL(2, "票据"),
    LC(4, "信用证");

    private final Integer type;
    private final String name;

    BudgetSettleModeEnum(Integer type, String name) {
        this.type = type;
        this.name = name;
    }

    public Integer getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    public static BudgetSettleModeEnum getWithPaymentTemplate(String paymentTemplate) {
        if (PaymentTemplateEnum.CHEQUE.getTemplate().equals(paymentTemplate)
                || PaymentTemplateEnum.BILL.getTemplate().equals(paymentTemplate)) {
            return BILL;
        } else if (PaymentTemplateEnum.LC.getTemplate().equals(paymentTemplate)) {
            return LC;
        } else {
            return CASH;
        }
    }
}

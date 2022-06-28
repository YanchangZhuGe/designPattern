package com.example.enums;

/**
 * <p>Title: 融资台账类型</p>
 *
 * <p>Description: 融资台账类型</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/16 10:45
 */
public enum GdtLedgerTypeEnum {

    /**
     * 融入
     */
    IN(0, "提款"),
    /**
     * 还本
     */
    OUT(1, "还本"),
    /**
     * 付息
     */
    INTEREST(2, "付息"),
    /**
     * 付款
     */
    PAY(4, "付款"),
    /**
     * 收款 目前不需要此类型
     */
    REC(5, "收款"),
    /**
     * 提前还本
     */
    ADVANCE_REPAYMENT(6, "提前还本"),
    /**
     * 费用
     */
    FEES(3, "费用"),
    /**
     * 担保费用
     */
    GUARANTEE_FEES(7, "担保费用"),
    /**
     * 手续费用
     */
    PROC_FEES(8, "手续费");

    private final Integer value;
    private final String name;

    GdtLedgerTypeEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public Integer getValue() {
        return value;
    }

    public String getName() {
        return name;
    }
}

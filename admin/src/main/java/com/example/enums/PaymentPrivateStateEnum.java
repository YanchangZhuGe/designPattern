package com.example.enums;

/**
 * <p>Title: 对私批量明细状态</p>
 *
 * <p>Description: 对私批量明细状态</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/11/17 11:41
 */
public enum PaymentPrivateStateEnum {

    /**
     * 初始状态：待执行
     */
    UNPAID(0, "待执行"),
    /**
     * BP返回成功状态
     */
    SUCCESS(1, "成功"),
    /**
     * BO返回失败状态
     */
    FAILED(9, "失败");


    private final Integer state;
    private final String name;

    PaymentPrivateStateEnum(Integer state, String name) {
        this.state = state;
        this.name = name;
    }

    public Integer getState() {
        return state;
    }

    public String getName() {
        return name;
    }
}

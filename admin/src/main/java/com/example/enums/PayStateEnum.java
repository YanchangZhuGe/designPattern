package com.example.enums;

import java.util.List;

/**
 * <p>Title: 申请单支付状态枚举</p>
 *
 * <p>Description: 申请单支付状态枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/8/25 13:58
 */
public enum PayStateEnum {


    /**
     * 申请已废弃: 申请单废弃后
     */
    OBSOLETE(-2, "申请已废弃"),
    /**
     * 申请已驳回: 申请单被驳回后
     */
    REJECT(-1, "申请已驳回"),
    /**
     * 已保存: 申请单保存后
     */
    SAVED(0, "已保存"),
    /**
     * 审批中: 申请单提交至工作流
     */
    APPROVAL(1, "审批中"),
    /**
     * 待支付: 申请单未进行过付款
     */
    UNPAID(2, "待支付"),
    /**
     * 部分已付: 申请单已进行过付款, 但已付金额 < 申请单金额
     */
    PARTIAL_PAID(3, "部分已付"),
    /**
     * 全部已付: 申请单已进行过付款, 已付金额 = 申请单金额
     */
    PAID(4, "全部已付"),
    /**
     * 部分拒付: 申请单已进行过付款, 但已付金额 < 申请单金额, 拒绝支付剩余部分
     */
    PARTIAL_REFUSAL(5, "部分拒付"),
    /**
     * 全部拒付: 申请单未进行过付款, 拒绝支付全部金额
     */
    REFUSAL(6, "全部拒付");

    private final Integer state;
    private final String name;

    PayStateEnum(Integer state, String name) {
        this.state = state;
        this.name = name;
    }

    public Integer getState() {
        return state;
    }

    public String getName() {
        return name;
    }

    public static String getName(Integer state) {
        for (PayStateEnum stateEnum : values()) {
            if (stateEnum.state.equals(state)) {
                return stateEnum.name;
            }
        }
        return "";
    }

    public static boolean canModify(Integer state) {
        return REJECT.state.equals(state) || SAVED.state.equals(state);
    }

    public static boolean isRefusal(Integer state) {
        return REFUSAL.state.equals(state) || PARTIAL_REFUSAL.state.equals(state);
    }

    public static boolean isPaidState(List<Integer> states) {
        if (states == null || states.size() == 0) {
            return false;
        }
        for (Integer state : states) {
            if (!UNPAID.state.equals(state) && !PARTIAL_PAID.state.equals(state)) {
                return false;
            }
        }
        return true;
    }

    public static boolean canSubmitState(Integer payState) {
        return REJECT.state.equals(payState) || SAVED.state.equals(payState);
    }
}

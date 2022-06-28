package com.example.enums;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * <p>Title: 支付单状态枚举</p>
 *
 * <p>Description: 支付单状态枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/8/26 16:11
 */
public enum PayOrderStateEnum {

    /**
     * 保存: 支付单已保存
     */
    SAVED("SAVED", "保存"),
    /**
     * 付款审批中: 支付单在审批流程中
     */
    APPROVAL("APPROVAL", "付款审批中"),
    /**
     * 付款审批驳回: 支付单从审批流程中驳回
     */
    APPROVAL_REJECT("APPROVAL_REJECT", "付款审批驳回"),
    /**
     * 待付款安排：请款付款支付单审批通过后，需要走付款安排
     */
    PAY_ARRANGEMENT("PAY_ARRANGEMENT", "待付款安排"),
    /**
     * 付款排队中: 支付单已审批通过，因未到期望付款日，未发送BP
     */
    QUEUE("QUEUE", "付款排队中"),
    /**
     * 异步付款待处理: 审批通过等待异步发指令
     */
    RESERVATIONPAY_QUEUE("RESERVATIONPAY_QUEUE", "付款审批通过"),
    /**
     * 发送BP成功: 非内部户，直连账户发送bp成功
     */
    BP_SUCCESS("BP_SUCCESS", "发送BP成功"),
    BCM_SUCCESS("BCM_SUCCESS", "发送BCM成功"),
    /**
     * 发送财司成功: 内部户-财务公司付款，发财务公司成功
     */
    FINANCIAL_SUCCESS("BP_SUCCESS", "发送财司成功"),
    /**
     * 发送BP成功: 下拨指令发送bp成功
     */
    ALLOCATE_BP_SUCCESS("BP_SUCCESS", "发送BP成功(下拨)"),
    /**
     * 发送BP异常: 支付单已审批通过，但发送BP出错，或在发BP过程中报错
     */
    BP_EXCEPTION("BP_EXCEPTION", "发送BP异常"),
    BCM_EXCEPTION("BCM_EXCEPTION", "发送BCM异常"),
    /**
     * 发送财司异常: 内部户-财务公司付款，发财务公司失败
     */
    FINANCIAL_EXCEPTION("BP_EXCEPTION", "发送财司异常"),
    /**
     * 发送BP异常(下拨): 支付单已审批通过，但下拨指令发送BP出错，或在发BP过程中报错
     */
    ALLOCATE_BP_EXCEPTION("BP_EXCEPTION", "发送BP异常(下拨)"),
    /**
     * EBD做账异常: 当涉及内部户时，发送EBD记账失败，状态为“EBD做账异常”
     */
    EBD_EXCEPTION("EBD_EXCEPTION", "做账异常"),
    /**
     * 线下处理中: 非直连的支付单已审批通过
     */
    OFFLINE_PROCESSING("OFFLINE_PROCESSING", "线下处理中"),
    /**
     * 付款已取消: 线下处理中、付款失败的支付单进行取消支付
     */
    CANCELLED("CANCELLED", "付款已取消"),
    /**
     * 付款部分成功: 票据支付单中，多张票支付，部分票据支付成功
     */
    PARTIAL_SUCCESS("PARTIAL_SUCCESS", "付款部分成功"),
    /**
     * 付款成功: 直连支付单，银行返回成功；非直连支付单，进行付款确认成功后
     */
    SUCCESS("SUCCESS", "付款成功"),
    /**
     * 付款失败: 直连支付单，BP返回付款失败
     */
    FAILED("FAILED", "付款失败"),
    /**
     * 付款失败: 直连支付单，BP返回付款失败
     */
    ALLOCATE_FAILED("ALLOCATE_FAILED", "付款失败(下拨)"),
    /**
     * 付款结果可疑: 直连支付单，BP返回付款结果可疑
     */
    SUSPICIOUS_RESULT("SUSPICIOUS_RESULT", "付款结果可疑"),
    /**
     * 付款结果可疑: 直连支付单，BP返回付款结果可疑
     */
    ALLOCATE_SUSPICIOUS_RESULT("ALLOCATE_SUSPICIOUS_RESULT", "付款结果可疑(下拨)"),
    /**
     * 系统异常: 直连支付单，异步发BP，未成功发送
     */
    SYSTEM_EXCEPTION("SYSTEM_EXCEPTION", "系统异常"),
    /**
     * 已废弃: 支付单付款审批异常后，进行作废后
     */
    OBSOLETE("OBSOLETE", "已废弃");

    private final String state;
    private final String name;

    PayOrderStateEnum(String state, String name) {
        this.state = state;
        this.name = name;
    }

    public static boolean canModify(String state) {
        return APPROVAL_REJECT.state.equals(state) || SAVED.state.equals(state);
    }

    public String getState() {
        return state;
    }

    public String getName() {
        return name;
    }

    public static String getNameByState(String state) {
        for (PayOrderStateEnum payOrderState : PayOrderStateEnum.values()) {
            if (payOrderState.state.equals(state)) {
                return payOrderState.getName();
            }
        }
        return "";
    }

    public static boolean isPendingView(String[] payStateArray) {
        if (payStateArray == null || payStateArray.length == 0) {
            return false;
        }
        String[][] pendingStates = {
                {OFFLINE_PROCESSING.state, APPROVAL_REJECT.state, SAVED.state, FAILED.state},
                {BP_EXCEPTION.state, EBD_EXCEPTION.state, SYSTEM_EXCEPTION.state},
                {APPROVAL.state, SUSPICIOUS_RESULT.state, BP_SUCCESS.state, PAY_ARRANGEMENT.state},
                {QUEUE.state}
        };

        for (String[] pendingState : pendingStates) {
            if (isPending(pendingState, payStateArray)) {
                return true;
            }
        }
        return false;
    }


    private static boolean isPending(String[] pendingState, String[] payStateArray) {
        String payStates = String.join(",", pendingState);
        for (String state : payStateArray) {
            if (!payStates.contains(state)) {
                return false;
            }
        }
        return true;
    }

    public static String[] getRefusalStates() {
        return new String[]{
                PayOrderStateEnum.SAVED.getState(),
                PayOrderStateEnum.APPROVAL.getState(),
                PayOrderStateEnum.APPROVAL_REJECT.getState(),
                PayOrderStateEnum.QUEUE.getState(),
                PayOrderStateEnum.RESERVATIONPAY_QUEUE.getState(),
                PayOrderStateEnum.BP_SUCCESS.getState(),
                PayOrderStateEnum.BP_EXCEPTION.getState(),
                PayOrderStateEnum.EBD_EXCEPTION.getState(),
                PayOrderStateEnum.OFFLINE_PROCESSING.getState(),
                PayOrderStateEnum.FAILED.getState(),
                PayOrderStateEnum.SUSPICIOUS_RESULT.getState(),
                PayOrderStateEnum.SYSTEM_EXCEPTION.getState()
        };
    }

    public static List<String> getAllOrderStates() {
        List<String> allOrderStates = new ArrayList<>();
        for (PayOrderStateEnum orderStateEnum : values()) {
            allOrderStates.add(orderStateEnum.getState());
        }
        return allOrderStates;
    }

    public static List<String> getPendingStates() {
        List<String> pendingStates = new ArrayList<>();
        pendingStates.add(PayOrderStateEnum.SAVED.getState());
        pendingStates.add(PayOrderStateEnum.APPROVAL_REJECT.getState());
        pendingStates.add(PayOrderStateEnum.OFFLINE_PROCESSING.getState());
        pendingStates.add(PayOrderStateEnum.FAILED.getState());
        return pendingStates;
    }

    public static List<String> getFlowingStates() {
        List<String> flowingStates = new ArrayList<>();
        flowingStates.add(PayOrderStateEnum.APPROVAL.getState());
        flowingStates.add(PayOrderStateEnum.BP_SUCCESS.getState());
        flowingStates.add(PayOrderStateEnum.SUSPICIOUS_RESULT.getState());
        return flowingStates;
    }

    public static boolean canSubmitState(String payOrderState) {
        return SAVED.state.equals(payOrderState) || APPROVAL_REJECT.state.equals(payOrderState);
    }

    /**
     * 可释放预算的支付单状态
     */
    public static final List<String> RELEASE_BUDGET_ORDER_STATE = Arrays.asList(OFFLINE_PROCESSING.getState(), QUEUE.getState());

    /**
     * 是否可释放预算
     */
    public static boolean canReleaseBudget(final String payOrderState) {
        return RELEASE_BUDGET_ORDER_STATE.contains(payOrderState);
    }
}

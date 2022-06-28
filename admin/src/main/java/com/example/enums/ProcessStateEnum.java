package com.example.enums;

/**
 * 支付单/申请单流程状态
 */
public enum ProcessStateEnum {
    /**
     * 待处理
     */
    PENDING("PENDING", "待处理", "setPendingCount"),
    /**
     * 流程中
     */
    PROCESSING("PROCESSING", "流程中", "setProcessingCount"),
    /**
     * 付款审批驳回: 支付单从审批流程中驳回
     */
    QUEUE("QUEUE", "排队中", "setQueueCount"),
    /**
     * 付款排队中: 支付单已审批通过，因未到期望付款日，未发送BP
     */
    EXCEPTION("EXCEPTION", "异常", "setExceptionCount"),
    /**
     * 发送BP成功: 非内部户，直连账户发送bp成功
     */
    SUCCESS("SUCCESS", "成功", "setSuccessCount"),
    /**
     * 发送BP异常: 支付单已审批通过，但发送BP出错，或在发BP过程中报错
     */
    TOTAL("TOTAL", "全部", "setTotalCount");


    private final String state;
    private final String name;
    private final String methodName;

    ProcessStateEnum(String state, String name, String methodName) {
        this.state = state;
        this.name = name;
        this.methodName = methodName;
    }

    public String getState() {
        return state;
    }

    public String getName() {
        return name;
    }

    public String getMethodName() {
        return methodName;
    }

    public static String getNameByState(String state) {
        return valueOf(state).name;
    }

    public static String getMethodNameByState(String state) {
        return valueOf(state).methodName;
    }
}

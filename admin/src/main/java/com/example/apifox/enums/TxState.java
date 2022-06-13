package com.example.apifox.enums;

/**
 * <p>Title: 交易状态标记</p>
 *
 * <p>Description: 交易状态标记</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author huangjun
 * @version 1.0
 * @since：2020/12/04 17:28
 */
public enum TxState {
    /**
     * 作废
     */
    OBSOLETE(-2,"已作废", null),
    /**
     * 已驳回
     */
    REJECT(-1, "已驳回", null),
    /**
     * 已保存
     */
    SAVED(0, "已保存", null),
    /**
     * 流程中
     */
    PROCESS(1, "流程中", null),
    /**
     * 撤回
     */
    WITHDRAW(-9,"已撤回", null),
    /**
     * 生效
     */
    EFFECT(9, "已生效", null);
    /**
     * 系统内部审批状态
     * 审批状态码规则
     * 1+工作流类型编号数字
     */

    /**
     * 系统外审批状态-直连
     */


    private Integer value;
    private String name;
    private UmFmClsEnum umFmCls;

    /**
     * 根据流程类型获取其流程中状态枚举值
     * @param umFmCls 流程类型
     * @return
     */
    public static TxState getProcessTxState(UmFmClsEnum umFmCls) {
        for (TxState txState : values()) {
            if (txState.getUmFmCls() == null) {
                continue;
            }
            String stateVariableName = txState.toString();
            if (stateVariableName.startsWith("PROCESS_") && txState.getUmFmCls() == umFmCls) {
                return txState;
            }
        }
        return TxState.PROCESS;
    }

    /**
     * 判断交易状态是否为暂存状态(可修改|提交)
     * @param txState 当前交易状态
     * @return true-暂存 false-非暂存
     */
    public static boolean isTemporaryState(Integer txState){
        if (txState == null) {
            return true;
        }
        return TxState.SAVED.getValue().equals(txState)
                || TxState.REJECT.getValue().equals(txState)
                || TxState.WITHDRAW.getValue().equals(txState);
    }
    /**
     * 判断交易状态是否为流程中状态(可结束本地工作流)
     * @param txState 当前交易状态
     * @return true-流程中 false-非流程中
     */
    public static boolean isProcessState(Integer txState){
        if (txState == null) {
            return false;
        }
        return String.valueOf(txState).startsWith(TxState.PROCESS.getValue().toString());
    }

    /**
     * 根据状态值获取状态名称
     * @param value
     * @return
     */
    public static String getNameByValue(Integer value) {
        if (value == null) {
            return null;
        }
        for (TxState txState : values()) {
            if (txState.getValue().equals(value)) {
                return txState.getName();
            }
        }
        return null;
    }

    TxState(Integer value, String name, UmFmClsEnum umFmCls) {
        this.value = value;
        this.name = name;
        this.umFmCls = umFmCls;
    }

    public Integer getValue() {
        return value;
    }

    public String getName() {
        return name;
    }

    public UmFmClsEnum getUmFmCls() {
        return umFmCls;
    }
}

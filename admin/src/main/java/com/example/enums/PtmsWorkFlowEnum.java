package com.example.enums;

import com.nstc.ptms.service.flow.activiti.PtmsFlowTypeConstants;

/**
 * <p>Title: 流程类型</p>
 * <p>Description: 流程类型</p>
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author zengshaoqi
 * @since 2021/4/7 15:07
 */
public enum PtmsWorkFlowEnum {

    /**
     * 从资金系统发起的账户付款申请单（除请款申请、对私批量付款）
     */
    SINGLE_PAY_APPLY(PtmsFlowTypeConstants.SINGLE_PAY_APPLY, "单笔付款申请单"),
    /**
     * 从资金系统发起的中国境内对私批量付款申请单（工资发放）
     */
    SALARY_PAY_APPLY(PtmsFlowTypeConstants.SALARY_PAY_APPLY, "工资发放申请单"),
    /**
     * 从资金系统发起的中国境内对私批量付款申请单（费用报销）
     */
    COST_PAY_APPLY(PtmsFlowTypeConstants.COST_PAY_APPLY, "费用报销申请单"),
    /**
     * 从资金系统发起的现金付款申请单
     */
    CASH_PAY_APPLY(PtmsFlowTypeConstants.CASH_PAY_APPLY, "现金付款申请单"),
    /**
     * 从资金系统发起的支票付款申请单
     */
    CHEQUE_PAY_APPLY(PtmsFlowTypeConstants.CHEQUE_PAY_APPLY, "支票付款申请单"),
    /**
     * 从资金系统发起的信用证付款申请单
     */
    LC_PAY_APPLY(PtmsFlowTypeConstants.LC_PAY_APPLY, "信用证付款申请单"),
    /**
     * 从资金系统发起的票据付款申请单
     */
    BILL_PAY_APPLY(PtmsFlowTypeConstants.BILL_PAY_APPLY, "票据付款申请单"),
    /**
     * 从资金系统发起的混合支付付款申请单
     */
    MIXED_PAY_APPLY(PtmsFlowTypeConstants.MIXED_PAY_APPLY, "混合支付申请单"),
    /**
     * 从资金系统发起的托收付款申请单
     */
    REMITTING_APPLY(PtmsFlowTypeConstants.REMITTING_APPLY, "托收付款申请单"),
    /**
     * 从资金系统发起的委托收款申请单
     */
    COMMISSION_RECEIVABLES_APPLY(PtmsFlowTypeConstants.COMMISSION_RECEIVABLES_APPLY, "委托收款申请单"),
    /**
     * 从资金系统发起的请款申请单
     */
    REQUEST_PAYOUT_APPLY(PtmsFlowTypeConstants.REQUEST_PAYOUT_APPLY, "请款申请单"),
    /**
     * 从资金系统发起的账户付款支付单（除请款申请、对私批量付款）
     */
    SINGLE_PAY_ORDER(PtmsFlowTypeConstants.SINGLE_PAY_ORDER, "单笔付款支付单"),
    /**
     * 从资金系统发起的中国境内对私批量付款支付单（工资发放）
     */
    SALARY_PAY_ORDER(PtmsFlowTypeConstants.SALARY_PAY_ORDER, "工资发放支付单"),
    /**
     * 从资金系统发起的中国境内对私批量付款支付单（费用报销）
     */
    COST_PAY_ORDER(PtmsFlowTypeConstants.COST_PAY_ORDER, "费用报销支付单"),
    /**
     * 从资金系统发起的现金付款支付单
     */
    CASH_PAY_ORDER(PtmsFlowTypeConstants.CASH_PAY_ORDER, "现金付款支付单"),
    /**
     * 从资金系统发起的支票付款支付单
     */
    CHEQUE_PAY_ORDER(PtmsFlowTypeConstants.CHEQUE_PAY_ORDER, "支票付款支付单"),
    /**
     * 从资金系统发起的信用证付款支付单
     */
    LC_PAY_ORDER(PtmsFlowTypeConstants.LC_PAY_ORDER, "信用证付款支付单"),
    /**
     * 从资金系统发起的票据付款支付单
     */
    BILL_PAY_ORDER(PtmsFlowTypeConstants.BILL_PAY_ORDER, "票据付款支付单"),
    /**
     * 从资金系统发起的混合支付付款支付单
     */
    MIXED_PAY_ORDER(PtmsFlowTypeConstants.MIXED_PAY_ORDER, "混合支付支付单"),
    /**
     * 从资金系统发起的托收付款支付单
     */
    REMITTING_ORDER(PtmsFlowTypeConstants.REMITTING_ORDER, "托收付款支付单"),
    /**
     * 从资金系统发起的委托收款支付单
     */
    COMMISSION_RECEIVABLES_ORDER(PtmsFlowTypeConstants.COMMISSION_RECEIVABLES_ORDER, "委托收款支付单"),
    /**
     * 从资金系统发起的请款支付单
     */
    REQUEST_PAYOUT_ORDER(PtmsFlowTypeConstants.REQUEST_PAYOUT_ORDER, "请款支付单"),
    /**
     * 请款付款安排
     */
    PAY_ARRANGEMENT(PtmsFlowTypeConstants.PAY_ARRANGEMENT, "请款付款安排"),
    /**
     * 对成功的信用证付款、支票付款、票据付款、现金付款支付单操作【退票】
     */
    BILL_REJECTION(PtmsFlowTypeConstants.BILL_REJECTION, "实物退票"),
    /**
     * 对失败的账户付款（除请款申请、对私批量）支付单操作【重发】
     */
    BANK_FAILURE_REPAY(PtmsFlowTypeConstants.BANK_FAILURE_REPAY, "单笔付款支付单失败指令重发"),
    /**
     * 对失败的账户付款（费用报销）支付单操作【重发】
     */
    COST_FAILURE_REPAY(PtmsFlowTypeConstants.COST_FAILURE_REPAY, "费用报销支付单失败指令重发"),
    /**
     * 对失败的账户付款（工资发放）支付单操作【重发】
     */
    SALARY_FAILURE_REPAY(PtmsFlowTypeConstants.SALARY_FAILURE_REPAY, "工资发放支付单失败指令重发"),
    /**
     * 对失败的账户付款（请款申请）支付单操作【重发】
     */
    REQUEST_PAYOUT_FAILURE_REPAY(PtmsFlowTypeConstants.REQUEST_PAYOUT_FAILURE_REPAY, "请款支付单失败指令重发"),
    /**
     * 明细补填
     */
    PAY_DETAIL_REFILL(PtmsFlowTypeConstants.PAY_DETAIL_REFILL, "付款明细补填"),
    /**
     * 明细补填修正
     */
    PAY_DETAIL_REFILL_MODIFY(PtmsFlowTypeConstants.PAY_DETAIL_REFILL_MODIFY, "付款明细补填更正"),
    ;

    PtmsWorkFlowEnum(String typeCode, String typeName) {
        this.typeCode = typeCode;
        this.typeName = typeName;
    }

    /**
     * 工作流业务流程编号
     */
    private final String typeCode;
    /**
     * 工作流业务流程名称
     */
    private final String typeName;

    public String getTypeCode() {
        return typeCode;
    }

    public String getTypeName() {
        return typeName;
    }

    public static PtmsWorkFlowEnum getWorkFlowTye(String typeCode) {
        if (typeCode == null) {
            return null;
        }
        for (PtmsWorkFlowEnum anEnum : values()) {
            if (anEnum.typeCode.equals(typeCode)) {
                return anEnum;
            }
        }
        return null;
    }

    public static PtmsWorkFlowEnum getWorkFlowTye(int ordinal) {
        for (PtmsWorkFlowEnum anEnum : values()) {
            if (anEnum.ordinal() == ordinal) {
                return anEnum;
            }
        }
        return null;
    }
}
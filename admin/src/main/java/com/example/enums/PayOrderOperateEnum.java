package com.example.enums;

/**
 * <p>Title: 支付单付款操作枚举</p>
 *
 * <p>Description: 支付单付款操作枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/8/26 16:54
 */
public enum PayOrderOperateEnum {

    /**
     * [线下处理中]、[付款失败]后可进行取消支付
     */
    CANCEL_PAYMENT("CANCEL_PAYMENT", "取消支付"),
    /**
     * [线下处理中]、[付款审批异常]可进行确认成功
     */
    CONFIRM_SUCCESS("CONFIRM_SUCCESS", "确认成功"),
    /**
     * [付款审批异常]可进行确认失败
     */
    CONFORM_FAILED("CONFORM_FAILED", "确认失败"),
    /**
     * [付款审批驳回]可进行修改
     */
    MODIFY("MODIFY", "修改"),
    /**
     * [付款审批驳回]、[付款审批异常]可进行废弃
     */
    ABANDONED("ABANDONED", "废弃"),
    /**
     * [付款部分成功]、[付款成功]可进行退票/证
     */
    REFUND("REFUND", "退票/证"),
    /**
     * [付款失败]、[付款审批异常]可进行重发
     */
    RESEND("RESEND", "重发"),
    /**
     * [付款排队中]可进行立即付款
     */
    IMMEDIATE_PAYMENT("", "立即付款"),
    /**
     * [系统异常]可进行确认已处理
     */
    CONFIRM_PROCESSED("", "确认已处理"),
    /**
     * [系统异常]可进行确认未处理
     */
    CONFIRM_UNPROCESSED("", "确认未处理"),
    /**
     * [付款审批异常]、[系统异常]可进行联系运维
     */
    CONTACT_OP("", "联系运维");
    private final String operate;
    private final String name;

    PayOrderOperateEnum(String operate, String name) {
        this.operate = operate;
        this.name = name;
    }

    public String getOperate() {
        return operate;
    }

    public String getName() {
        return name;
    }
}

package com.example.enums;

import com.nstc.ptms.validate.EnumValueLister;

/**
 * <p>Title: 操作类型枚举</p>
 *
 * <p>Description: 操作类型枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/6 16:17
 */
public enum OperateEnum implements EnumValueLister {

    /**
     * 表单保存
     */
    SAVE("SAVE", "保存"),
    /**
     * 表单提交/立即付款
     */
    SUBMIT("SUBMIT", "立即付款"),
    /**
     * 取消支付
     */
    CANCEL("CANCEL", "取消支付"),
    /**
     * 重发指令/重发EBD/重发BP
     */
    RESEND("RESEND", "重发"),
    /**
     * 删除
     */
    DELETE("DELETE", "删除"),
    /**
     * 确认失败
     */
    FAILURE("FAILURE", "确认失败"),
    /**
     * 确认成功
     */
    SUCCESS("SUCCESS", "确认成功"),
    /**
     * 退票/证
     */
    REFUND("REFUND", "退票/证"),

    /**
     * 确认成功
     */
    CONFIRM_PROCESS("CONFIRM_PROCESS", "确认已处理"),

    /**
     * 确认失败
     */
    CONFRM_SUSPEND("CONFRM_SUSPEND", "确认未处理"),
    /**
     * 线下处理
     */
    OFFLINE_HANDLE("OFFLINE_HANDLE", "线下处理");
    private String operate;
    private String opName;

    public String getOperate() {
        return operate;
    }

    public void setOperate(String operate) {
        this.operate = operate;
    }

    public String getOpName() {
        return opName;
    }

    public void setOpName(String opName) {
        this.opName = opName;
    }

    OperateEnum(String operate, String opName) {
        this.operate = operate;
        this.opName = opName;
    }

    public static String[] exhaustiveList() {
        return new String[]{SAVE.name(), SUBMIT.name()};
    }
}
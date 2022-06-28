package com.example.enums;

import com.nstc.ptms.model.vo.PayDetailRefillVo;

public enum RefillBusinessOperateStatusEnum {
    /**
     * 0/1
     */
    END_BILL(1, "endBill", "是否完结票据"),

    /**
     * 0/1_
     */
    USE_FINANCING(2, "useFinancing", "是否使用融资款"),

    /**
     * 0/1__
     */
    VERIFY_CREDIT(4, "verifyCredit", "信用证是否核销");

    /**
     * gen
     *
     * @param status
     * @return
     */
    public Integer getSwitchByStatus(Integer status) {
        boolean onStatus = status != null && (status & this.statusValue) == this.statusValue;
        return onStatus ? YesOrNoEnum.YES.getKey() : YesOrNoEnum.NO.getKey();
    }

    /**
     * 组装状态参数
     *
     * @param source 增加值
     * @param target 添加至目标对象
     * @return 最终值
     */
    public Integer buildStatus(Integer source, Integer target) {
        if (target == null && source == null) {
            return null;
        }
        Integer ret = target;
        int addStatusValue = YesOrNoEnum.YES.getKey().equals(source) ? this.statusValue : YesOrNoEnum.NO.getKey();
        if (ret == null) {
            return addStatusValue;
        }
        return ret | addStatusValue;
    }

    public static Integer buildRefillStatus(PayDetailRefillVo refill) {
        Integer businessStatus = RefillBusinessOperateStatusEnum.END_BILL.buildStatus(refill.getEndBill(), null);
        businessStatus = RefillBusinessOperateStatusEnum.USE_FINANCING.buildStatus(refill.getUseFinancing(), businessStatus);
        businessStatus = RefillBusinessOperateStatusEnum.VERIFY_CREDIT.buildStatus(refill.getVerifyCredit(), businessStatus);
        return businessStatus;
    }

    /**
     * 状态值
     */
    private final int statusValue;
    /**
     * 状态字段
     */
    private final String statusKey;
    /**
     * 状态名称
     */
    private final String statusName;

    RefillBusinessOperateStatusEnum(int statusValue, String statusKey, String statusName) {
        this.statusValue = statusValue;
        this.statusKey = statusKey;
        this.statusName = statusName;
    }

    public int getStatusValue() {
        return statusValue;
    }

    public String getStatusKey() {
        return statusKey;
    }

    public String getStatusName() {
        return statusName;
    }
}

package com.example.enums;

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
public enum ErpPayMentStatusEnum {


    SUCCESS(1, "成功"),
    ERROR(-1, "处理失败"),
    SAVED(0, "处理中"),
    SUSPICIOUS_RESULT(99, "可疑");

    private final Integer state;
    private final String name;

    ErpPayMentStatusEnum(Integer state, String name) {
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
        for (ErpPayMentStatusEnum stateEnum : values()) {
            if (stateEnum.state.equals(state)) {
                return stateEnum.name;
            }
        }
        return "";
    }
}

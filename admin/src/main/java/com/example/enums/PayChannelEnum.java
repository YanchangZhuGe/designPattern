package com.example.enums;

/**
 * <p>Title: 付款渠道枚举</p>
 *
 * <p>Description: 付款渠道枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/14 22:31
 */
public enum PayChannelEnum {

    //todo 外部系统要从落地规则中获取，目前只有ERP、结算中台、BPM三种外部付款来源，但是外部来源是可以用户动态增加的
    /**
     * 资金系统
     */
    G6("G6", "资金系统"),
    /**
     * ERP系统
     */
    ERP("ERP", "ERP系统"),
    /**
     * 结算中台
     */
    SETTLEMENT("SETTLEMENT", "结算中台"),
    /**
     * BPM系统
     */
    BPM("BPM", "BPM系统"),
    /**
     * 计划模块
     */
    PLAN("PLAN", "计划模块"),
    ;

    private final String source;
    private final String name;

    PayChannelEnum(String source, String name) {
        this.source = source;
        this.name = name;
    }

    public String getSource() {
        return source;
    }

    public String getName() {
        return name;
    }

    public static String getName(String source) {
        for (PayChannelEnum channelEnum : values()) {
            if (channelEnum.source.equals(source)) {
                return channelEnum.name;
            }
        }
        return "";
    }
}

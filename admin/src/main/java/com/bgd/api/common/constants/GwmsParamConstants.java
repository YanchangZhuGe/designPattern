package com.bgd.api.common.constants;

public class GwmsParamConstants {

    private static final long serialVersionUID = 1L;

    /**
     * 合同到期提醒天数
     */
    public static final String P001_GUARANTEE_END_DAY = "P001";

    /**
     * 占用担保的日期校验规则
     */
    public static final String P101_DATE_RULE = "P101";

    /**
     * 跨币种占用担保的额度计算方式
     */
    public static final String P102_EXCHANGE_RATE_WAY = "P102";

    /**
     * 是否可占用授信项下的担保合同额度
     */
    public static final String P103_GUARANTEE_REUSED_FLAG = "P103";

    /**
     * 同一抵押物可否被多次抵押
     */
    public static final String P104_PLEDGE_REUSED_FALG1 = "P104";

    /**
     * 同一质押物可否被多次质押
     */
    public static final String P105_PLEDGE_REUSED_FLAG2 = "P105";

    /**
     * 合同到期是否自动结项
     */
    public static final String P106_AUTO_END_GUARANTEE_FLAG = "P106";

    /**
     * 是否开启担保申请
     */
    public static final String P100_GUARANTEE_NEDD_APPLY_FLAG = "P100";

}

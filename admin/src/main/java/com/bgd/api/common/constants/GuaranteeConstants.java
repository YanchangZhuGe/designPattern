package com.bgd.api.common.constants;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:公用常量类
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author wk
 * @version 1.0
 * @since：2021年1月4日 下午1:52:12
 */
public class GuaranteeConstants {

    //工单表主键 fmId
    public static final String FMID = "fm_id";
    //applyId
    public static final String APPLYID = "apply_id";

    //占用释放标识
    public static final String DIR_OCCPUY = "+";
    public static final String DIR_RELEASE = "-";

    public static final Integer ISDELETE = 2; //删除标记
    public static final Integer ISNOTDELETE = 1; //释放标记
    /**
     * 工单流水号
     */
    public static final String FM_ID = "fmId";
    public static final String CASE_ID = "caseId";
    public static final String BUSINESS_SUMMARY = "businessSummary";
    public static final String CLT_NO = "cltNo";
    /**
     * 担保id
     */
    public static final String GUARANTEE_ID = "GUARANTEE_ID";
    /**
     * 最后修改时间
     */
    public static final String BALANCE_DATE = "BALANCE_DATE";
    public static final String CURRENCY_CODE = "CURRENCY_CODE";


    /**
     * 业务模块编号
     */
    public static final String CHANNEL = "GWMS";

    /**
     * 业务模块名称
     */
    public static final String CHANNEL_NAME = "担保";

    /**
     * 工作流流程编号分隔符
     */
    public static final String BIZ_NO_SEPARATOR = "-";
    public static final String DEFAULT_BIZ_NO_SEQUENCE = "0000";

    /**
     * FTP参数key
     */
    public static final String FTP_USERNAME = "rmp.FTPUserName";
    public static final String FTP_PASSWORD = "rmp.FTPPassWord";
    public static final String FTP_FILEPATH = "rmp.FTPFilePath";
    public static final String FTP_IPORT = "rmp.FTPPort";
}

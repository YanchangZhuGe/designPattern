package com.bgd.api.common.constants;

/**
 * <p>Title: 担保预占接口常量</p>
 * <p>Description: </p>
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author zengshaoqi
 * @since 2020/2/24 15:36
 */
public interface OccupyAmountConstant {
    String DATA_LIST = "dataList";


    /**
     * 担保流水号
     */
    String GUARANTEE_ID = "guaranteeId";
    /**
     * 预占金额
     */
    String ADV_AMOUNT = "advAmount";
    /**
     * 抵质押物流水号
     */
    String G_PLEDGE_ID = "gPledgeId";
    /**
     * 操作日期
     */
    String ACT_DATE = "actDate";
    /**
     * 业务开始日期
     */
    String START_DATE = "startDate";
    /**
     * 业务结束日期
     */
    String END_DATE = "endDate";
    /**
     * 台账金额
     */
    String AMOUNT = "amount";
    /**
     * 占用/释放方向
     */
    String DIR = "dir";
    /**
     * 业务币种
     */
    String CUR_NO = "curNo";
    /**
     * 占用渠道
     */
    String CHANNEL = "channel";
    /**
     * 业务系统流水号
     */
    String BUSS_ID = "bussId";
    /**
     * 业务系统编号
     */
    String BUSS_NO = "bussNo";
    /**
     * 业务类型
     */
    String BUSS_TYPE = "bussType";
    /**
     * 单位编号
     */
    String CLT_NO = "cltNo";
    /**
     * 经办员
     */
    String CREATOR = "creator";
    /**
     * 业务模块操作类型
     */
    String BUSS_ACT_TYPE = "bussActType";

    /**
     * 汇率允许误差
     */
    double RATE_EXCHANGE_ERRO = -0.1;
}

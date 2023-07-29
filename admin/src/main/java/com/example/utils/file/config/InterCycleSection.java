/***********************************************************************
 * Module:  InterCycleSection.java
 * Author:  唐剑锋
 * Purpose: com.nstc.bams.enums
 ***********************************************************************/
package com.example.utils.file.config;



import com.nstc.lms.enums.LmsContractPaymentEnum;

import java.util.Date;
import java.util.TreeSet;

/**
 * @Title:
 * @Description: 计息周期计算器
 * @Company: 北京九恒星科技股份有限公司
 * @author: 刘建华
 * @Date： 2021/2/19 17:33
 */
public class InterCycleSection {

    private String intrCycle = "-2"; // 计息周期
    private Date sDate = null; // 放款日
    private Date eDate = null; // 结束日

    /**
     * 计算计息周期区间
     *
     * @param intrCycle     计息周期
     * @param firstIntrDate 首次计息日
     * @param sDate         放款日(放还款排计划:计划开始时间；预提：预提开始日；结息：台账记录第一条记录的起息日)
     * @param eDate         结束日(放还款排计划:台帐户到期日；预提：预提结束日；结息：结息日)
     * @return
     */
    public TreeSet<Date> calculatorSection(String intrCycle, Date firstIntrDate, Date sDate, Date eDate) {
        this.intrCycle = intrCycle;
        this.sDate = sDate;
        this.eDate = eDate;
        check();
        // 计息周期 = 到期一次&利随本清 直接加入开始到期日
        //LmsContractPaymentEnum.PAYMENT_FREQUENCY_01 chargeFreq = LmsContractPaymentEnum.get(intrCycle);
     /*   if (ChargeFreq.ONCE_OVER.equals(chargeFreq)) {
            TreeSet<Date> sectionList = new TreeSet<>();
            sectionList.add(sDate);
            sectionList.add(eDate);
            return sectionList;
        }*/
        // 计息周期 != 到期一次
        int month = 0; // 周期间隔
        if (LmsContractPaymentEnum.PAYMENT_FREQUENCY_04.getCode().equals(intrCycle)) {
            // 计息周期 = 年
            month = 12;
        } else if (LmsContractPaymentEnum.PAYMENT_FREQUENCY_03.getCode().equals(intrCycle)) {
            // 计息周期 = 半年
            month = 6;
        } else if (LmsContractPaymentEnum.PAYMENT_FREQUENCY_02.getCode().equals(intrCycle)) {
            // 计息周期 = 季度
            month = 3;
        } else if (LmsContractPaymentEnum.PAYMENT_FREQUENCY_01.getCode().equals(intrCycle)) {
            // 计息周期 = 月
            month = 1;
        } else {
            throw new RuntimeException("付息频率数据错误！");
        }
        return LmsInterestUtil.calcIntrDate(firstIntrDate, sDate, eDate, month);
    }

    /**
     * 计算还本周期区间
     *
     * @param intrCycle     还本周期
     * @param firstIntrDate 首次还本日
     * @param sDate         放款日(放还款排计划:计划开始时间；预提：预提开始日；结息：台账记录第一条记录的起息日)
     * @param eDate         结束日(放还款排计划:台帐户到期日；预提：预提结束日；结息：结息日)
     * @return
     */
    public TreeSet<Date> getRepaymentArea(String intrCycle, Date firstIntrDate, Date sDate, Date eDate) {
        this.intrCycle = intrCycle;
        this.sDate = sDate;
        this.eDate = eDate;
        check();
        // 还本周期 != 到期一次
        int month = 0; // 周期间隔
        if (LmsContractPaymentEnum.REPAYMENT_FREQUENCY_04.getCode().equals(intrCycle)) {
            // 还本周期 = 年
            month = 12;
        } else if (LmsContractPaymentEnum.REPAYMENT_FREQUENCY_03.getCode().equals(intrCycle)) {
            // 还本周期 = 半年
            month = 6;
        } else if (LmsContractPaymentEnum.REPAYMENT_FREQUENCY_02.getCode().equals(intrCycle)) {
            // 还本周期 = 季度
            month = 3;
        } else if (LmsContractPaymentEnum.REPAYMENT_FREQUENCY_01.getCode().equals(intrCycle)) {
            // 还本周期 = 月
            month = 1;
        } else {
            throw new RuntimeException("还本频率数据错误！");
        }
        return LmsInterestUtil.calcIntrDate(firstIntrDate, sDate, eDate, month);
    }

    /**
     * 策略参数检查
     */
    private void check() {

        if (sDate == null || eDate == null) {
            throw new RuntimeException("放款日或者结束日不能为空！");
        }
        if (!eDate.after(sDate)) {
            throw new RuntimeException("放款日必须小于结束日！");
        }

    }

}

/*================================================================================
 * InterestUtil.java
 * 生成日期：2014-5-1 下午08:06:22
 * 作          者：杨庆祥
 * 项          目：FBCM03
 * (C)COPYRIGHT BY NSTC.
 * ================================================================================
 */
package com.example.utils.file.config;

import com.alibaba.fastjson.JSON;
import com.nstc.intr.pal.engine.MassSumInterest;
import com.nstc.lms.entity.LmsContractChangeRate;
import com.nstc.lms.entity.LmsContractPlan;
import com.nstc.lms.enums.*;
import com.nstc.util.DateUtil;
import com.nstc.util.HashMapExt;
import com.nstc.util.TextFormat;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.util.*;

/**
 * <p>
 * Title:利息计算工具类
 * </p>
 *
 * <p>
 * Description:
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author 杨庆祥
 * @version 1.0
 * @since：2014-5-1 下午08:06:22
 */
@Slf4j
public class LmsInterestUtil {
    private LmsInterestUtil() {
    }

    /**
     * @param ledgers    List
     * @param intrArea   List<Date> 计息周期区间集合
     * @param rateType   RateTypeEnum 利率类型(年利率/月利率)
     * @param ratesMap   HashMapExt 利率集合
     * @param daysOfYear Integer 年天数
     * @return LmsContractPlan[]
     * @Description:调用计息器计算收息计划
     * @author 杨庆祥
     * @since 2013-4-28 下午05:14:40
     */
    public static List<LmsContractPlan> calculatePlans(List<HashMapExt> ledgers, List<Date> intrArea, RateTypeEnum rateType,
                                                  HashMapExt ratesMap, Integer daysOfYear) {
        return calculateInterest(ledgers, intrArea, rateType, ratesMap, daysOfYear, LmsYesOrNoEnum.YES, null);
    }

    /**
     * @param ledgers    List
     * @param intrDate   Date 起息日
     * @param actDate    Date 收息日
     * @param rateType   RateTypeEnum 利率类型(年利率/月利率)
     * @param ratesMap   HashMapExt 利率集合
     * @param daysOfYear Integer 年天数
     * @return LmsContractPlan[]
     * @Description:调用计息器计算利息
     * @author 杨庆祥
     * @since 2013-4-28 下午05:14:40
     */
  public static List<LmsContractPlan> calculateInterest(List<HashMapExt> ledgers, Date intrDate, Date actDate,
                                                     RateTypeEnum rateType, HashMapExt ratesMap, Integer daysOfYear) {
        // 计息周期区间集合
        List<Date> intrArea = new ArrayList<>();
        intrArea.add(intrDate);
        intrArea.add(actDate);
        return calculateInterest(ledgers, intrArea, rateType, ratesMap, daysOfYear, LmsYesOrNoEnum.NO,
                actDate);
    }

    /**
     * @param ledgers    List
     * @param intrArea   List<Date> 计息周期区间集合
     * @param rateType   RateTypeEnum 利率类型(年利率/月利率)
     * @param ratesMap   HashMapExt 利率集合
     * @param daysOfYear Integer 年天数
     * @param isPlan     LmsYesOrNoEnum 是否为计算收息计划
     * @return LmsContractPlan[]
     * @Description:调用计息器计算利息
     * @author 杨庆祥
     * @since 2013-4-28 下午05:14:40
     */
    private static List<LmsContractPlan> calculateInterest(List<HashMapExt> ledgers, List<Date> intrArea,
                                                      RateTypeEnum rateType, HashMapExt ratesMap, Integer daysOfYear, LmsYesOrNoEnum isPlan,
                                                      Date actDate) {

        // 检查传入参数
        if (CollectionUtils.isEmpty(ledgers) || ratesMap == null || ratesMap.isEmpty()
                || CollectionUtils.isEmpty(intrArea) || daysOfYear == null || rateType == null) {
            throw new RuntimeException("calculateInterest 入参不能为空！");
        }

        // 计息参数
        HashMapExt parameter = new HashMapExt();
        // 台账记录集合
        parameter.put("RECORD_LIST", ledgers);
        // 计息周期区间集合
        parameter.put("INTR_AREA", intrArea);
        // 利率集合
        parameter.put("RATE_LIST", ratesMap);
        // 年天数
        parameter.put("DAYS", daysOfYear);
        // 利率类型(年利率/月利率)
        parameter.put("RATE_TYPE", rateType.getCode());

        log.info("method=calculateInterest,parameter={}", JSON.toJSONStringWithDateFormat(parameter, "yyyy-MM-dd"));

        // 计算利息
        MassSumInterest m1 = new MassSumInterest(parameter);
        m1.calculator();
        // 取计算结果（利率变更时分段）
        List<HashMapExt> result = m1.getResultDetails();

        log.info("method=calculateInterest,result={}", JSON.toJSONStringWithDateFormat(result, "yyyy-MM-dd"));

        List<LmsContractPlan> interestList = new ArrayList<>();
        for (int i = 0; i < result.size(); i++) {

            HashMapExt interest = result.get(i);
            // 收息日期
            Date inputDate = interest.getDate("INPUT_DATE");
            // 收息金额
            double interestAmount = interest.getDouble("INTR").doubleValue();
            // 利息为0时，跳过该记录
            if (NumUtil.isZero(interestAmount)) {
                continue;
            }
            // 收息日不等于外面传入的收息日时，跳过该记录
            if (LmsYesOrNoEnum.NO.equals(isPlan)) {
                if (DateUtil.dateDiff(inputDate, actDate) != 0) {
                    continue;
                }
            }
            LmsContractPlan view = new LmsContractPlan();
            // 起息日
            view.setStartDate(interest.getDate("START_DATE"));
            // 止息日
            view.setEndDate(interest.getDate("END_DATE"));
            // 结息日
            view.setActDate(inputDate);
            // 计息天数
            view.setDayNum(interest.getInteger("DAYS"));
            // 本金余额
            view.setBalance(interest.getDouble("AMOUNT"));
            // 积数
            view.setAmass(interest.getDouble("MASS"));
            // 利率
            view.setRate(BigDecimal.valueOf(interest.getDouble("RATE") * 100));
            // 利息
            view.setAmount(BigDecimal.valueOf(interestAmount));
            // 本金变动类型标识
            //IntrUnit intrUnit = IntrUnit.getEnum(interest.getInteger("INTR_UNIT"));
            //view.setRepayType(2);
            // 本金变动编号
           // view.setPrincipalId(interest.getInteger("PRINCIPAL_ID"));
            // 如果是最后一条，并且本金余额为0，则止息日取最后一条本金的日期
            if (NumUtil.isZero(view.getBalance())) {
                // 最后一次还本日
                Date lastLedgerDate = null;
                for (int j = 0; j < ledgers.size(); j++) {
                    HashMapExt ledger = ledgers.get(j);
                    Date date = ledger.getDate("DATE");
                    if (lastLedgerDate == null || DateUtil.dateDiff(date, lastLedgerDate) < 0) {
                        lastLedgerDate = date;
                    }
                }
                // 因为计息是算头不算尾的，所以止息日要减一天
                lastLedgerDate = DateUtil.addDay(lastLedgerDate, -1);
                // 如果止息日大于最后的台账日，并且本金余额为0，说明止息日前已经
                if (DateUtil.dateDiff(lastLedgerDate, view.getEndDate()) > 0) {
                    // 止息日
                    view.setEndDate(lastLedgerDate);
                    // 计息天数，因为前面减了一天，所以这里要加上
                    view.setDayNum(DateUtil.dateDiff(view.getStartDate(), lastLedgerDate) + 1);
                }
            }
            interestList.add(view);
        }

        return interestList;
    }


    /**
     * @param rates:
     * @return com.nstc.util.HashMapExt
     * @Description: 将利率转化成计息器所需的类型
     * @author 刘建华
     * @since 2021/3/6 14:26
     */
    public static HashMapExt getRatesMap(List<LmsContractChangeRate> rates, String ledgerType) {
        HashMapExt ratesMap = new HashMapExt();
        for (LmsContractChangeRate rate : rates) {
            // todo MathExtend.divide 有问题
//            double rateValue = MathExtend.divide(rate.getRate() == null? 0.0d : rate.getRate().doubleValue(), 100d);
            double rateValue = rate.getRate().divide(new BigDecimal(100),20,BigDecimal.ROUND_HALF_UP).doubleValue();
       /*     if (LedgerType.NORMAL_PRIN.getCode().equals(ledgerType)) {
                rateValue = MathExtend.divide(rate.getRate() == null? 0.0d : rate.getRate().doubleValue(), 100d);
            } else if (LedgerType.OVERDUE_PRIN.getCode().equals(ledgerType)
                    || LedgerType.SLACK_PRIN.getCode().equals(ledgerType)) {
                rateValue = MathExtend.divide(rate.getPrinPenaltyRate() == null? 0.0d : rate.getPrinPenaltyRate().doubleValue(), 100d);
            } else if (LedgerType.NORMAL_INTR.getCode().equals(ledgerType)
                    || LedgerType.OVERDUE_INTR.getCode().equals(ledgerType)
                    || LedgerType.SLACK_INTR.getCode().equals(ledgerType)) {
                rateValue = MathExtend.divide(rate.getIntrPenaltyRate() == null? 0.0d : rate.getIntrPenaltyRate().doubleValue(), 100d);
            } else if (LedgerType.APPROPRIATION_PRIN.getCode().equals(ledgerType)) {
                rateValue = MathExtend.divide(rate.getDivertPenaltyRate() == null? 0.0d : rate.getDivertPenaltyRate().doubleValue(), 100d);
            }*/
            ratesMap.put(TextFormat.formatDate(rate.getActDate()), BigDecimal.valueOf(rateValue));
        }
        return ratesMap;
    }

   /*  public static HashMapExt getRatesMapPun(List<LendingRates> rates) {
       HashMapExt ratesMap = new HashMapExt();
        for (LendingRates rate : rates) {
            double rateValue = MathExtend.divide(rate.getIntrPenaltyRate().doubleValue(), 100d);
            ratesMap.put(TextFormat.formatDate(rate.getEftDate()),
                    BigDecimal.valueOf(rateValue));
        }
        return ratesMap;
    }
*/
  /*  public static HashMapExt getRatesMap(ContractRates rate) {
        HashMapExt ratesMap = new HashMapExt();
        double rateValue = MathExtend.divide(rate.getRate().doubleValue(), 100d);
        ratesMap.put(TextFormat.formatDate(rate.getEftDate()),
                BigDecimal.valueOf(rateValue));
        return ratesMap;
    }
*/
    /**
     * @param records  List
     * @param actDate  Date
     * @param amount   Double
     * @param keepType KeepTypeEnum
     * @Description: 添加计息器计算利息所需的台账记录
     * @author 杨庆祥
     * @since 2014-5-1 下午08:52:30
     */
    public static void addLedger(List<HashMapExt> records, Date actDate, Double amount, KeepTypeEnum keepType) {
        HashMapExt map = new HashMapExt();
        // 日期
        map.put("DATE", actDate);
        // 金额
        map.put("AMOUNT", amount);
        // 方向
        if (KeepTypeEnum.KT_INCREASE.equals(keepType)) {
            map.put("DIR", DirFlag.PLUS.getValue());
        } else {
            map.put("DIR", DirFlag.MINUS.getValue());
        }
        // 记账类型
        map.put("TYPE", keepType.getCode());
        // 添加到记录列表
        records.add(map);
    }

    public static HashMapExt buildPlanLedger(LmsContractPlan plan) {
        HashMapExt map = new HashMapExt();
        // 日期
        map.put("DATE", plan.getActDate());
        // 金额
        map.put("AMOUNT", plan.getAmount().doubleValue());
      //  KeepTypeEnum keepType = getKeepType(plan);
        KeepTypeEnum keepType  = KeepTypeEnum.KT_DECREASE_WITHOUT_INTR;
        // 方向
        if (KeepTypeEnum.KT_INCREASE.equals(keepType)) {
            map.put("DIR", DirFlag.PLUS.getValue());
        } else {
            map.put("DIR", DirFlag.MINUS.getValue());
        }
        // 记账类型
        if (LmsContractPlanStateEnum.Executed.getValue().equals(plan.getPlanState())) {
            map.put("EXEC_FLAG", LmsYesOrNoEnum.YES.getValue());
        }
        map.put("TYPE", keepType.getCode());
        return map;
    }

    /**
     * @param payPlan:
     * @return com.nstc.fbcm.constant.contract.KeepTypeEnum
     * @Description: 判断还款计划的 记账类型
     * @author 刘建华
     * @since 2021/3/12 13:49
     */
 /*   public static KeepTypeEnum getKeepType(LmsContractPlan payPlan) {
        KeepTypeEnum keepType;
        if (LmsYesOrNoEnum.YES.getCode().equals(payPlan.getAdvPay())) {
            // 利随本清
            if (LmsYesOrNoEnum.YES.getCode().equals(payPlan.getIntrWithPrin())) {
                // 提前还款
                keepType = KeepTypeEnum.KT_DECREASE_BF_WITH_INTR;
            } else {
                keepType = KeepTypeEnum.KT_DECREASE_BF_WITHOUT_INTR;
            }
        } else {
            if (LmsYesOrNoEnum.YES.getCode().equals(payPlan.getIntrWithPrin())) {
                keepType = KeepTypeEnum.KT_DECREASE_WITH_INTR;
            } else {
                keepType = KeepTypeEnum.KT_DECREASE_WITHOUT_INTR;
            }
        }
        return keepType;
    }*/

    /**
     * @param firstIntrDate:
     * @param startDate:
     * @param maturity:
     * @param month:
     * @return java.util.Set<java.util.Date>
     * @Description: 计算收费日 去掉开始日和到期日
     * @author 刘建华
     * @since 2021/3/18 20:04
     */
    public static Set<Date> calcChargeDate(Date firstIntrDate, Date startDate, Date maturity, int month) {
        // 计算日期
        return calcDates(firstIntrDate, startDate, maturity, month);
    }

    /**
     * @param firstIntrDate :
     * @param startDate     :
     * @param maturity      :
     * @param month         :
     * @return java.util.List<java.util.Date>
     * @Description: 计算计息日
     * @author 刘建华
     * @since 2021/3/6 15:37
     */
    public static TreeSet<Date> calcIntrDate(Date firstIntrDate, Date startDate, Date maturity, int month) {
        if(firstIntrDate==null){
            throw new RuntimeException("首次计算日期不能为空");

        }

        if(month==0){
            throw new RuntimeException("计算周期不能为0！");
        }

        TreeSet<Date> dateSet = calcDates(firstIntrDate, startDate, maturity, month);
        dateSet.add(startDate);
        dateSet.add(maturity);
        return dateSet;
    }

    public static TreeSet<Date> calcDates(Date firstIntrDate, Date startDate, Date maturity, int month) {
        if(firstIntrDate==null){
            throw new RuntimeException("首次计算日期不能为空");

        }
        if(month==0){
            throw new RuntimeException("计算周期不能为0！");
        }
        // 只保留年月日
        startDate = DateUtil.getDate(startDate);
        maturity = DateUtil.getDate(maturity);
        firstIntrDate = DateUtil.getDate(firstIntrDate);
        TreeSet<Date> dateSet = new TreeSet<>();
        while (firstIntrDate.getTime() <= maturity.getTime()) {
            if (firstIntrDate.getTime() >= startDate.getTime()) {
                dateSet.add(firstIntrDate);
            }
            firstIntrDate = DateUtil.addMonth(firstIntrDate, month);
        }
        return dateSet;
    }




}

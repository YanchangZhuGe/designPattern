package com.nstc.brs.business.reconciliation;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.*;
import com.nstc.brs.model.BrsMateDailyDetailModel;
import com.nstc.brs.model.scope.BrsMateDailyDetailScope;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.smartform.core.util.DateUtils;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.StringUtils;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2024-11-26
 * @Version:1.0
 */
public class QueryDailyDetailListBusiness extends AbstractBRSBusiness {
    private String mainId;
    private Map<String,Object> brs_dailyMateDetail_form;
    private String minAmount;
    private String maxAmount;
    private String startBookDate;
    private String endBookDate;
    private String amountDir;
    private String checkAccNo;
    private String checkAccName;
    private String remarkMsg;
    @Override
    public void doExecute() throws Exception {
        if(brs_dailyMateDetail_form==null){
            brs_dailyMateDetail_form = new HashMap<String, Object>();
            brs_dailyMateDetail_form.put("id",mainId);
        }
        if(StringUtils.isNotEmpty(mainId)){
            BrsMateRecordScope recordScope = new BrsMateRecordScope();
            recordScope.setId(CastUtil.toInteger(mainId));
            List<BrsCheckRecord> dataList = getContext().getBrsBankReconciliationService().queryDailyMateList(recordScope);
            if(dataList==null || dataList.size()<=0){
                putResult("amountDirList", AmountDir.getAll());
                putResult("mateTypeList", MateFlag.getAll());
                putResult("brs_dailyMateDetail_form", brs_dailyMateDetail_form);
                return;
            }
            BrsCheckRecord  record = dataList.get(0);
            BrsMateDailyDetailScope scope = new BrsMateDailyDetailScope();
            scope.setRecordId(CastUtil.toInteger(mainId));
            scope.setMateState(MateType.TYPE_1.getValue());
            scope.setMaxAmount(CastUtil.toDouble(maxAmount));
            scope.setMinAmount(CastUtil.toDouble(minAmount));
            scope.setEndBookDate(CastUtil.toDate(endBookDate));
            scope.setStartBookDate(CastUtil.toDate(startBookDate));
            scope.setRemarkMsg(remarkMsg);
            scope.setCheckAccName(checkAccName);
            scope.setCheckAccNoLike(checkAccNo);
            scope.setAmountDir(amountDir);
            //“—∆•≈‰∂‘’Àº«¬º
            List<Map<String,Object>> dataList1 = getContext().getBrsBankReconciliationService().queryGroupByConditionList(CastUtil.toInteger(mainId));
            scope.setMateState(MateType.TYPE_2.getValue());
            //Œ¥∆•≈‰“¯––’À
            scope.setDetailType(DetailType.TYPE_1.getValue());
            List<BrsMateDailyDetailModel> dataList2 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);
            //Œ¥∆•≈‰∆Û“µ’À
            scope.setDetailType(DetailType.TYPE_2.getValue());
            List<BrsMateDailyDetailModel> dataList3 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);

            putResult("brs_dailyMateDetail_mateList", dataList1);
            putResult("brs_dailyMateUnMateList_l", BeanHelper.describe(dataList2));
            putResult("brs_dailyMateUnMateList_r", BeanHelper.describe(dataList3));
            brs_dailyMateDetail_form.putAll(BeanHelper.describe(record));
        }
        putResult("brs_dailyMateDetail_form", brs_dailyMateDetail_form);
        putResult("amountDirList", AmountDir.getAll());
        putResult("mateTypeList", MateFlag.getAll());

    }

    public String getMainId() {
        return mainId;
    }

    public void setMainId(String mainId) {
        this.mainId = mainId;
    }

    public Map<String, Object> getBrs_dailyMateDetail_form() {
        return brs_dailyMateDetail_form;
    }

    public void setBrs_dailyMateDetail_form(Map<String, Object> brs_dailyMateDetail_form) {
        this.brs_dailyMateDetail_form = brs_dailyMateDetail_form;
    }

    public String getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(String minAmount) {
        this.minAmount = minAmount;
    }

    public String getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(String maxAmount) {
        this.maxAmount = maxAmount;
    }

    public String getStartBookDate() {
        return startBookDate;
    }

    public void setStartBookDate(String startBookDate) {
        this.startBookDate = startBookDate;
    }

    public String getEndBookDate() {
        return endBookDate;
    }

    public void setEndBookDate(String endBookDate) {
        this.endBookDate = endBookDate;
    }

    public String getAmountDir() {
        return amountDir;
    }

    public void setAmountDir(String amountDir) {
        this.amountDir = amountDir;
    }

    public String getCheckAccNo() {
        return checkAccNo;
    }

    public void setCheckAccNo(String checkAccNo) {
        this.checkAccNo = checkAccNo;
    }

    public String getCheckAccName() {
        return checkAccName;
    }

    public void setCheckAccName(String checkAccName) {
        this.checkAccName = checkAccName;
    }

    public String getRemarkMsg() {
        return remarkMsg;
    }

    public void setRemarkMsg(String remarkMsg) {
        this.remarkMsg = remarkMsg;
    }
}

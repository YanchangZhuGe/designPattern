package com.nstc.brs.business.reconciliation;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.AmountDir;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.enums.MateFlag;
import com.nstc.brs.enums.MateType;
import com.nstc.brs.model.BrsMateDailyDetailModel;
import com.nstc.brs.model.scope.BrsMateDailyDetailScope;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2024-11-28
 * @Version:1.0
 */
public class DeleteDailyDetailBusiness extends AbstractBRSBusiness {
    private List<Map<String,Object>> brs_dailyMateUnMateList_l;
    private List<Map<String,Object>> brs_dailyMateUnMateList_r;
    private Map<String,Object> brs_dailyMateDetail_form;
    @Override
    public void doExecute() throws Exception {
        List<Map<String,Object>> selectList = new ArrayList<Map<String, Object>>();
        String opType = CastUtil.toNotEmptyString(brs_dailyMateDetail_form.get("opType"));
        Integer id = CastUtil.toInteger(brs_dailyMateDetail_form.get("id"));
        if(opType.equals("L")){
             selectList = getGridSelectedRow(brs_dailyMateUnMateList_l);
        }else if (opType.equals("R")){
             selectList = getGridSelectedRow(brs_dailyMateUnMateList_r);
        }

        if(selectList!=null && selectList.size()>0){
            getContext().getBrsBankReconciliationService().deleteDailyDetailList(selectList,id);
        }
    }
    @Override
    public void onFailure() {
        Integer mainId = CastUtil.toInteger(brs_dailyMateDetail_form.get("id"));
        if(mainId !=null){
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

    @Override
    public void onSuccess() {
        Integer mainId = CastUtil.toInteger(brs_dailyMateDetail_form.get("id"));
        if(mainId !=null){
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

    public List<Map<String, Object>> getBrs_dailyMateUnMateList_l() {
        return brs_dailyMateUnMateList_l;
    }

    public void setBrs_dailyMateUnMateList_l(List<Map<String, Object>> brs_dailyMateUnMateList_l) {
        this.brs_dailyMateUnMateList_l = brs_dailyMateUnMateList_l;
    }

    public List<Map<String, Object>> getBrs_dailyMateUnMateList_r() {
        return brs_dailyMateUnMateList_r;
    }

    public void setBrs_dailyMateUnMateList_r(List<Map<String, Object>> brs_dailyMateUnMateList_r) {
        this.brs_dailyMateUnMateList_r = brs_dailyMateUnMateList_r;
    }

    public Map<String, Object> getBrs_dailyMateDetail_form() {
        return brs_dailyMateDetail_form;
    }

    public void setBrs_dailyMateDetail_form(Map<String, Object> brs_dailyMateDetail_form) {
        this.brs_dailyMateDetail_form = brs_dailyMateDetail_form;
    }
}

package com.nstc.brs.business.reconciliation;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.AmountDir;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.enums.MateFlag;
import com.nstc.brs.model.BrsMateDailyDetailModel;
import com.nstc.brs.model.scope.BrsMateDailyDetailScope;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2024-11-28
 * @Version:1.0
 */
public class CancelMainDailyDetailBusiness extends AbstractBRSBusiness {
    private List<Map<String,Object>> brs_dailyMateDetail_mateList;
    private Map<String,Object> brs_dailyMateDetail_form;
    @Override
    public void doExecute() throws Exception {
        List<Map<String,Object>> selectList = getGridSelectedRow(brs_dailyMateDetail_mateList);
        if(selectList!=null && selectList.size()>0){
            Map<String,Object> data = new HashMap<String, Object>();
            data.putAll(brs_dailyMateDetail_form);
            data.put("selectList",selectList);
            getContext().getBrsBankReconciliationService().saveCancelDailyDetail(data);
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
                putResult("brs_dailyMateDetail_form", brs_dailyMateDetail_form);
                return;
            }
            BrsCheckRecord  record = dataList.get(0);
            BrsMateDailyDetailScope scope = new BrsMateDailyDetailScope();
            scope.setRecordId(CastUtil.toInteger(mainId));
            //“—∆•≈‰∂‘’Àº«¬º
            List<BrsMateDailyDetailModel> dataList1 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);
            scope.setMateState(MateFlag.TYPE_2.getValue());
            //Œ¥∆•≈‰“¯––’À
            scope.setDetailType(DetailType.TYPE_1.getLabel());
            List<BrsMateDailyDetailModel> dataList2 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);
            //Œ¥∆•≈‰∆Û“µ’À
            scope.setDetailType(DetailType.TYPE_2.getLabel());
            List<BrsMateDailyDetailModel> dataList3 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);

            putResult("brs_dailyMateDetail_mateList", BeanHelper.describe(dataList1));
            putResult("brs_dailyMateUnMateList_l", BeanHelper.describe(dataList2));
            putResult("brs_dailyMateUnMateList_r", BeanHelper.describe(dataList3));
            brs_dailyMateDetail_form = BeanHelper.describe(record);
        }
        putResult("brs_dailyMateDetail_form", brs_dailyMateDetail_form);
        putResult("amountDirList", AmountDir.getAll());
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
                putResult("brs_dailyMateDetail_form", brs_dailyMateDetail_form);
                return;
            }
            BrsCheckRecord  record = dataList.get(0);
            BrsMateDailyDetailScope scope = new BrsMateDailyDetailScope();
            scope.setRecordId(CastUtil.toInteger(mainId));
            //“—∆•≈‰∂‘’Àº«¬º
            List<BrsMateDailyDetailModel> dataList1 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);
            scope.setMateState(MateFlag.TYPE_2.getValue());
            //Œ¥∆•≈‰“¯––’À
            scope.setDetailType(DetailType.TYPE_1.getLabel());
            List<BrsMateDailyDetailModel> dataList2 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);
            //Œ¥∆•≈‰∆Û“µ’À
            scope.setDetailType(DetailType.TYPE_2.getLabel());
            List<BrsMateDailyDetailModel> dataList3 = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);

            putResult("brs_dailyMateDetail_mateList", BeanHelper.describe(dataList1));
            putResult("brs_dailyMateUnMateList_l", BeanHelper.describe(dataList2));
            putResult("brs_dailyMateUnMateList_r", BeanHelper.describe(dataList3));
            brs_dailyMateDetail_form = BeanHelper.describe(record);
        }
        putResult("brs_dailyMateDetail_form", brs_dailyMateDetail_form);
        putResult("amountDirList", AmountDir.getAll());
    }

    public List<Map<String, Object>> getBrs_dailyMateDetail_mateList() {
        return brs_dailyMateDetail_mateList;
    }

    public void setBrs_dailyMateDetail_mateList(List<Map<String, Object>> brs_dailyMateDetail_mateList) {
        this.brs_dailyMateDetail_mateList = brs_dailyMateDetail_mateList;
    }

    public Map<String, Object> getBrs_dailyMateDetail_form() {
        return brs_dailyMateDetail_form;
    }

    public void setBrs_dailyMateDetail_form(Map<String, Object> brs_dailyMateDetail_form) {
        this.brs_dailyMateDetail_form = brs_dailyMateDetail_form;
    }
}

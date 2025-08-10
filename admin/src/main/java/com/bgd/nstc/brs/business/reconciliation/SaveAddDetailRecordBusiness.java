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
import com.nstc.util.DateUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2024-12-01
 * @Version:1.0
 */
public class SaveAddDetailRecordBusiness extends AbstractBRSBusiness {
    private Map<String,Object> brs_addDetail_qry;
    private List<Map<String,Object>> brs_addInnerDetail_list;
    private List<Map<String,Object>> brs_addBankDetail_list;
    private String recordId;
    private String direction;

    @Override
    public void doExecute() throws Exception {
        List<Map<String,Object>> selectList = getGridSelectedRow(brs_addBankDetail_list);
        if(selectList==null || selectList.size()<=0){
            selectList = getGridSelectedRow(brs_addInnerDetail_list);
        }
        Map<String,Object> data = new HashMap<String, Object>();
        data.put("selectList",selectList);
        data.putAll(brs_addDetail_qry);
        getContext().getBrsBankReconciliationService().saveAddDailyDetail(data);
    }

    @Override
    public void onFailure() {
        recordId = CastUtil.toNotEmptyString(brs_addDetail_qry.get("recordId"));
        direction = CastUtil.toNotEmptyString(brs_addDetail_qry.get("direction"));
        BrsMateRecordScope scope = new BrsMateRecordScope();
        scope.setId(CastUtil.toInteger(recordId));
        List<BrsCheckRecord> mainDataList = getContext().getBrsBankReconciliationService().queryDailyMateList(scope);
        BrsCheckRecord mainData = mainDataList.get(0);
        Map<String,Object> param = new HashMap<String, Object>();
        param.putAll(brs_addDetail_qry);
        param.put("accountNo",mainData.getBankAccountNo());
        List<Map<String,Object>> dataList = new ArrayList<Map<String, Object>>();
        if(direction.equals("L")){
            dataList = getContext().getBrsBankReconciliationService().queryBankDetailList(param);
            putResult("brs_addBankDetail_list", BeanHelper.describe(dataList));
        }else{
            dataList = getContext().getBrsBankReconciliationService().queryInnerDetailList(param);
            putResult("brs_addInnerDetail_list", BeanHelper.describe(dataList));
        }
        putResult("recordId", recordId);
        putResult("brs_addDetail_qry", brs_addDetail_qry);
        putResult("amountDirList", AmountDir.getAll());
    }

    @Override
    public void onSuccess() {
        recordId = CastUtil.toNotEmptyString(brs_addDetail_qry.get("recordId"));
        direction = CastUtil.toNotEmptyString(brs_addDetail_qry.get("direction"));
        BrsMateRecordScope scope = new BrsMateRecordScope();
        scope.setId(CastUtil.toInteger(recordId));
        List<BrsCheckRecord> mainDataList = getContext().getBrsBankReconciliationService().queryDailyMateList(scope);
        BrsCheckRecord mainData = mainDataList.get(0);
        Map<String,Object> param = new HashMap<String, Object>();
        param.putAll(brs_addDetail_qry);
        param.put("accountNo",mainData.getBankAccountNo());
        List<Map<String,Object>> dataList = new ArrayList<Map<String, Object>>();
        if(direction.equals("L")){
            dataList = getContext().getBrsBankReconciliationService().queryBankDetailList(param);
            putResult("brs_addBankDetail_list", BeanHelper.describe(dataList));
        }else{
            dataList = getContext().getBrsBankReconciliationService().queryInnerDetailList(param);
            putResult("brs_addInnerDetail_list", BeanHelper.describe(dataList));
        }
        putResult("recordId", recordId);
        putResult("brs_addDetail_qry", brs_addDetail_qry);
        putResult("amountDirList", AmountDir.getAll());
    }

    public Map<String, Object> getBrs_addDetail_qry() {
        return brs_addDetail_qry;
    }

    public void setBrs_addDetail_qry(Map<String, Object> brs_addDetail_qry) {
        this.brs_addDetail_qry = brs_addDetail_qry;
    }

    public List<Map<String, Object>> getBrs_addInnerDetail_list() {
        return brs_addInnerDetail_list;
    }

    public void setBrs_addInnerDetail_list(List<Map<String, Object>> brs_addInnerDetail_list) {
        this.brs_addInnerDetail_list = brs_addInnerDetail_list;
    }

    public List<Map<String, Object>> getBrs_addBankDetail_list() {
        return brs_addBankDetail_list;
    }

    public void setBrs_addBankDetail_list(List<Map<String, Object>> brs_addBankDetail_list) {
        this.brs_addBankDetail_list = brs_addBankDetail_list;
    }
}

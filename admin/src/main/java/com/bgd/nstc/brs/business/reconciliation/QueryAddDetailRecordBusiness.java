package com.nstc.brs.business.reconciliation;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.AmountDir;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.DateUtil;
import com.nstc.util.TextFormat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description: 查询银行/企业明细
 * @Author:YPQ
 * @CreateTime: 2024-12-01
 * @Version:1.0
 */
public class QueryAddDetailRecordBusiness extends AbstractBRSBusiness {
        private String recordId;
    private String direction;
    private Map<String,Object> brs_addDetail_qry;

    @Override
    public void doExecute() throws Exception {
        if(brs_addDetail_qry==null){
            brs_addDetail_qry = new HashMap<String, Object>();
            brs_addDetail_qry.put("startBookDate", TextFormat.formatDate(DateUtil.getDate(),"yyyy-MM-dd"));
            brs_addDetail_qry.put("endBookDate", TextFormat.formatDate(DateUtil.getDate(),"yyyy-MM-dd"));
            brs_addDetail_qry.put("recordId", recordId);
            brs_addDetail_qry.put("direction", direction);
        }else{
            recordId = CastUtil.toNotEmptyString(brs_addDetail_qry.get("recordId"));
            direction = CastUtil.toNotEmptyString(brs_addDetail_qry.get("direction"));
        }
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
            putResult("brs_addBankDetail_list", dataList);
        }else{
            dataList = getContext().getBrsBankReconciliationService().queryInnerDetailList(param);
            putResult("brs_addInnerDetail_list", dataList);
        }
        putResult("recordId", recordId);
        putResult("brs_addDetail_qry", brs_addDetail_qry);
        putResult("amountDirList", AmountDir.getAll());
    }

    public String getRecordId() {
        return recordId;
    }

    public void setRecordId(String recordId) {
        this.recordId = recordId;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public Map<String, Object> getBrs_addDetail_qry() {
        return brs_addDetail_qry;
    }

    public void setBrs_addDetail_qry(Map<String, Object> brs_addDetail_qry) {
        this.brs_addDetail_qry = brs_addDetail_qry;
    }
}

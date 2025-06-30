package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;

import java.util.*;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-20
 * @Version:1.0
 */
public class SaveBankRecordBusiness extends AbstractBRSBusiness {
    private Map<String, Object> brs_selectBankRecord_qry;
    private List<Map<String, Object>> brs_selectBankRecord_list;

    @Override
    public void doExecute() throws Exception {
        List<Map<String, Object>> dataList = this.getGridSelectedRow(brs_selectBankRecord_list);
        brs_selectBankRecord_qry.put("dataList", dataList);
        this.putResult("brs_selectBankRecord_qry", brs_selectBankRecord_qry);
        getContext().getBrsBankReconciliationService().saveAddBankRecord(brs_selectBankRecord_qry);

        brs_selectBankRecord_qry.put("returnMsg", "success");
        this.putResult("brs_selectBankRecord_qry", brs_selectBankRecord_qry);
    }

    @Override
    public void onFailure() {
        brs_selectBankRecord_qry.put("returnMsg", "fail");
        this.putResult("brs_selectBankRecord_qry", brs_selectBankRecord_qry);
    }

    public Map<String, Object> getBrs_selectBankRecord_qry() {
        return brs_selectBankRecord_qry;
    }

    public void setBrs_selectBankRecord_qry(Map<String, Object> brs_selectBankRecord_qry) {
        this.brs_selectBankRecord_qry = brs_selectBankRecord_qry;
    }

    public List<Map<String, Object>> getBrs_selectBankRecord_list() {
        return brs_selectBankRecord_list;
    }

    public void setBrs_selectBankRecord_list(List<Map<String, Object>> brs_selectBankRecord_list) {
        this.brs_selectBankRecord_list = brs_selectBankRecord_list;
    }
}

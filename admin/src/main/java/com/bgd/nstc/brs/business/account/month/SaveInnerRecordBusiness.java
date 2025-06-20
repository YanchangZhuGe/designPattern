package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;

import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-24
 * @Version:1.0
 */
public class SaveInnerRecordBusiness extends AbstractBRSBusiness {
    private Map<String, Object> brs_selectInnerRecord_qry;
    private List<Map<String, Object>> brs_selectInnerRecord_list;

    @Override
    public void doExecute() throws Exception {
        List<Map<String, Object>> dataList = this.getGridSelectedRow(brs_selectInnerRecord_list);
        brs_selectInnerRecord_qry.put("dataList", dataList);
        getContext().getBrsBankReconciliationService().saveAddInnerRecord(brs_selectInnerRecord_qry);

        brs_selectInnerRecord_qry.put("returnMsg", "success");
        this.putResult("brs_selectInnerRecord_qry", brs_selectInnerRecord_qry);

    }

    @Override
    public void onFailure() {
        brs_selectInnerRecord_qry.put("returnMsg", "fail");
        this.putResult("brs_selectInnerRecord_qry", brs_selectInnerRecord_qry);
    }

    public Map<String, Object> getBrs_selectInnerRecord_qry() {
        return brs_selectInnerRecord_qry;
    }

    public void setBrs_selectInnerRecord_qry(Map<String, Object> brs_selectInnerRecord_qry) {
        this.brs_selectInnerRecord_qry = brs_selectInnerRecord_qry;
    }

    public List<Map<String, Object>> getBrs_selectInnerRecord_list() {
        return brs_selectInnerRecord_list;
    }

    public void setBrs_selectInnerRecord_list(List<Map<String, Object>> brs_selectInnerRecord_list) {
        this.brs_selectInnerRecord_list = brs_selectInnerRecord_list;
    }
}

package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.util.CastUtil;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-24
 * @Version:1.0
 */
public class MateBusRecordBusiness extends AbstractBRSBusiness {
    private List<Map<String,Object>> brs_monthCheckDetail_list;
    private Map<String,Object> brs_monthCheckDetail_form;
    @Override
    public void doExecute() throws Exception {
        Date qryDate = CastUtil.toDate(brs_monthCheckDetail_form.get("qryDate"));
        List<Map<String, Object>> dataList = this.getGridSelectedRow(brs_monthCheckDetail_list);
        brs_monthCheckDetail_form.put("dataList",dataList);
        getContext().getBrsBankReconciliationService().saveMate(brs_monthCheckDetail_form);
    }

    public List<Map<String, Object>> getBrs_monthCheckDetail_list() {
        return brs_monthCheckDetail_list;
    }

    public void setBrs_monthCheckDetail_list(List<Map<String, Object>> brs_monthCheckDetail_list) {
        this.brs_monthCheckDetail_list = brs_monthCheckDetail_list;
    }

    public Map<String, Object> getBrs_monthCheckDetail_form() {
        return brs_monthCheckDetail_form;
    }

    public void setBrs_monthCheckDetail_form(Map<String, Object> brs_monthCheckDetail_form) {
        this.brs_monthCheckDetail_form = brs_monthCheckDetail_form;
    }
}

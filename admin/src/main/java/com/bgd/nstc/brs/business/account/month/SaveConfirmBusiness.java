package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;

import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-20
 * @Version:1.0
 */
public class SaveConfirmBusiness extends AbstractBRSBusiness {
    private List<Map<String,Object>> brs_comfirm_list;
    @Override
    public void doExecute() throws Exception {
        List<Map<String, Object>> dataList = this.getGridSelectedRow(brs_comfirm_list);
        getContext().getBrsBankReconciliationService().saveConfirm(dataList);
        this.putResult("successFlag", "1");

    }

    public List<Map<String, Object>> getBrs_comfirm_list() {
        return brs_comfirm_list;
    }

    public void setBrs_comfirm_list(List<Map<String, Object>> brs_comfirm_list) {
        this.brs_comfirm_list = brs_comfirm_list;
    }
}

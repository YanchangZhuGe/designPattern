package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;

import java.util.HashMap;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-20
 * @Version:1.0
 */
public class InitSelectBankRecordBusiness extends AbstractBRSBusiness {
    private Integer mainId;
    @Override
    public void doExecute() throws Exception {
        Map<String,Object> data = new HashMap<String, Object>();
        data.put("mainId", mainId);
        this.putResult("brs_selectBankRecord_qry", data);

    }

    public Integer getMainId() {
        return mainId;
    }

    public void setMainId(Integer mainId) {
        this.mainId = mainId;
    }
}

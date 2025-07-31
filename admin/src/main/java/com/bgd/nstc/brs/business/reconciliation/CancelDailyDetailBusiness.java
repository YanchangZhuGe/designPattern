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
public class CancelDailyDetailBusiness extends AbstractBRSBusiness {
    private Map<String,Object> brs_mateDetail_form;
    @Override
    public void doExecute() throws Exception {
        List<Map<String,Object>> selectList = new ArrayList<Map<String, Object>>();
        Map<String,Object> data = new HashMap<String, Object>();
        Map<String,Object> map = new HashMap<String, Object>();
        map.putAll(brs_mateDetail_form);
        selectList.add(map);
        data.put("selectList",selectList);
        data.put("id",brs_mateDetail_form.get("mainId"));
        getContext().getBrsBankReconciliationService().saveCancelDailyDetail(data);
        putResult("brs_mateDetail_form", brs_mateDetail_form);
    }
    @Override
    public void onFailure() {
    }

    @Override
    public void onSuccess() {
    }

    public Map<String, Object> getBrs_mateDetail_form() {
        return brs_mateDetail_form;
    }

    public void setBrs_mateDetail_form(Map<String, Object> brs_mateDetail_form) {
        this.brs_mateDetail_form = brs_mateDetail_form;
    }
}

package com.nstc.brs.business.reconciliation;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.MateState;
import com.nstc.brs.enums.RecordType;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.smartform.core.util.DateUtils;
import com.nstc.util.BeanHelper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2024-11-26
 * @Version:1.0
 */
public class QueryDailyRecordBusiness extends AbstractBRSBusiness {
    private Map<String,Object> brs_dailyMate_qry;
    @Override
    public void doExecute() throws Exception {
        if(brs_dailyMate_qry == null){
            brs_dailyMate_qry = new HashMap<String, Object>();
            brs_dailyMate_qry.put("mateDate", DateUtils.getDate());
            brs_dailyMate_qry.put("mateState", MateState.UN_BALANCE.getValue());
        }
        BrsMateRecordScope scope = BeanHelper.populate(BrsMateRecordScope.class,brs_dailyMate_qry);
        scope.setType(RecordType.DAILY.getValue());
        List<BrsCheckRecord> dataList = getContext().getBrsBankReconciliationService().queryDailyMateList(scope);
        putResult("brs_dailyMate_list", BeanHelper.describe(dataList));
        putResult("brs_dailyMate_qry", brs_dailyMate_qry);
        putResult("mateStateList", MateState.getAll());
    }

    public Map<String, Object> getBrs_dailyMate_qry() {
        return brs_dailyMate_qry;
    }

    public void setBrs_dailyMate_qry(Map<String, Object> brs_dailyMate_qry) {
        this.brs_dailyMate_qry = brs_dailyMate_qry;
    }
}

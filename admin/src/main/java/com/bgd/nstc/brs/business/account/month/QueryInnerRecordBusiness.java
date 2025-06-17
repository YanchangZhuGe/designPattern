package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.scope.RecordCommonScope;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.brs.util.PageUtils;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.DateUtil;
import com.nstc.util.TextFormat;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-20
 * @Version:1.0
 */
public class QueryInnerRecordBusiness extends AbstractBRSBusiness {
    private Map<String,Object> brs_selectInnerRecord_qry;
    private List<Map<String,Object>> brs_selectInnerRecord_list;

    @Override
    public void doExecute() throws Exception {
        RecordCommonScope scope = BeanHelper.populate(RecordCommonScope.class,brs_selectInnerRecord_qry);
        scope.setRemoveFlag("removeFlag");
        if(scope.getEndDate()!=null){
            scope.setEndDate(DateUtil.addDay(scope.getEndDate(),1));
        }
        Integer mainId = CastUtil.toInteger(brs_selectInnerRecord_qry.get("mainId"));
        BrsMateRecordScope recordScope = new BrsMateRecordScope();
        recordScope.setId(mainId);
        BrsCheckRecord orgData = getContext().getBrsBankReconciliationService().queryDailyMateList(recordScope).get(0);
        String checkAccNo = orgData.getCheckAccNo();
        scope.setCheckAccNo(checkAccNo);
        int totalCount = getContext().getCommonService().getInnerRecordTotal(scope);
        int pageSize = PageUtils.getPageSize(bizEvent, "brs_selectInnerRecord_list", getAppNo());
        int curPageNo = PageUtils.getCurPageNo(bizEvent, "brs_selectInnerRecord_list");
        Map<String,Object> pageInfo = PageUtils.getPageInfoMap(pageSize, curPageNo);
        Integer pageStart = CastUtil.toInteger(pageInfo.get("pageStart"));
        Integer pageEnd = CastUtil.toInteger(pageInfo.get("pageEnd"));
        scope.setPageStart(pageStart);
        scope.setPageEnd(pageEnd);
        brs_selectInnerRecord_list = getContext().getCommonService().getInnerRecordList(scope);
        this.putResult("brs_selectInnerRecord_list", brs_selectInnerRecord_list);
        this.putResult("brs_selectInnerRecord_qry", brs_selectInnerRecord_qry);
        this.putResult("brs_selectInnerRecord_list._rowCount", totalCount);
        this.putResult("brs_selectInnerRecord_list._curPageNum", curPageNo);


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

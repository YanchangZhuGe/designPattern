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
public class QueryBankRecordBusiness extends AbstractBRSBusiness {
    private Map<String,Object> brs_selectBankRecord_qry;
    private List<Map<String,Object>> brs_selectBankRecord_list;

    @Override
    public void doExecute() throws Exception {
        RecordCommonScope scope = BeanHelper.populate(RecordCommonScope.class,brs_selectBankRecord_qry);
        scope.setRemoveFlag("removeFlag");
        if(scope.getEndDate()!=null){
            scope.setEndDate(DateUtil.addDay(scope.getEndDate(),1));
        }
        if(scope.getRecEndDate()!=null){
            scope.setRecEndDate(DateUtil.addDay(scope.getRecEndDate(),1));
        }
        Integer mainId = CastUtil.toInteger(brs_selectBankRecord_qry.get("mainId"));
        BrsMateRecordScope recordScope = new BrsMateRecordScope();
        recordScope.setId(mainId);
        BrsCheckRecord orgData = getContext().getBrsBankReconciliationService().queryDailyMateList(recordScope).get(0);
        String bankAccountNo = orgData.getBankAccountNo();
        scope.setBankAccountNo(bankAccountNo);
        int totalCount = getContext().getCommonService().getBankRecordTotal(scope);
        int pageSize = PageUtils.getPageSize(bizEvent, "brs_selectBankRecord_list", getAppNo());
        int curPageNo = PageUtils.getCurPageNo(bizEvent, "brs_selectBankRecord_list");
        Map<String,Object> pageInfo = PageUtils.getPageInfoMap(pageSize, curPageNo);
        Integer pageStart = CastUtil.toInteger(pageInfo.get("pageStart"));
        Integer pageEnd = CastUtil.toInteger(pageInfo.get("pageEnd"));
        scope.setPageStart(pageStart);
        scope.setPageEnd(pageEnd);
        brs_selectBankRecord_list = getContext().getCommonService().getBankRecordList(scope);
        this.putResult("brs_selectBankRecord_list", brs_selectBankRecord_list);
        this.putResult("brs_selectBankRecord_qry", brs_selectBankRecord_qry);
        this.putResult("brs_selectBankRecord_list._rowCount", totalCount);
        this.putResult("brs_selectBankRecord_list._curPageNum", curPageNo);


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

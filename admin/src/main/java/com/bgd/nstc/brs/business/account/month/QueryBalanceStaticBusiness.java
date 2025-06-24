package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.CollectionUtils;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

public class QueryBalanceStaticBusiness extends AbstractBRSBusiness {
    private Map<String, Object> brs_BalanceStatic_f;
    private List<Map<String, Object>> brs_BalanceStatic_l_bank;
    private List<Map<String, Object>> brs_BalanceStatic_l_comp;

    private Integer recordId;

    @Override
    public void doExecute() throws Exception {
        if (recordId == null) {
            throw new Exception("未找到记录");
        }
        if (brs_BalanceStatic_f == null) {
            brs_BalanceStatic_f = new HashMap<String, Object>();
        }
        if (brs_BalanceStatic_l_bank == null) {
            brs_BalanceStatic_l_bank = new ArrayList<Map<String, Object>>();
        }
        if (brs_BalanceStatic_l_comp == null) {
            brs_BalanceStatic_l_comp = new ArrayList<Map<String, Object>>();
        }
        MonthCheckScope scope = new MonthCheckScope();
        scope.setId(recordId);
        scope.setRecordId(recordId);
        List<BrsCheckRecord> recordList = this.getContext().getAccountService().getMonthCheckList(scope);
//        List<BrsCheckRecordDetail> recordDetailList = this.getContext().getAccountService().getMateMonthDetailList(scope);
        if (CollectionUtils.isEmpty(recordList)) {
            throw new Exception("未找到记录");
        }
//        if (CollectionUtils.isEmpty(recordDetailList)) {
//            throw new Exception("未找到记录");
//        }

        scope.setDetailType(DetailType.TYPE_1.getValue());
        brs_BalanceStatic_l_comp = this.getContext().getAccountService().getOutstandingDetailList(scope);
        scope.setDetailType(DetailType.TYPE_2.getValue());
        brs_BalanceStatic_l_bank = this.getContext().getAccountService().getOutstandingDetailList(scope);

        BrsCheckRecord record = recordList.get(0);

        brs_BalanceStatic_f.put("openBankName", record.getOpenBankName());
        brs_BalanceStatic_f.put("bankAccountNo", record.getBankAccountNo());
        brs_BalanceStatic_f.put("bankBalance", record.getBankBalance());
        brs_BalanceStatic_f.put("bussBalance", record.getInnerBalance());
 
        brs_BalanceStatic_f.put("mateDateTerm", this.getContext().getAccountService().getMateDateTerm(record));
 

        brs_BalanceStatic_f.put("bankBalanceAmount", this.getContext().getAccountService().getBankBussBalanceAmount(record,brs_BalanceStatic_l_bank));
        brs_BalanceStatic_f.put("bussBalanceAmount", this.getContext().getAccountService().getBankBussBalanceAmount(record,brs_BalanceStatic_l_comp));
 
        this.putResult("brs_BalanceStatic_f", brs_BalanceStatic_f);
        this.putResult("brs_BalanceStatic_l_bank", brs_BalanceStatic_l_bank);
        this.putResult("brs_BalanceStatic_l_comp", brs_BalanceStatic_l_comp);
    }

    public Map<String, Object> getBrs_BalanceStatic_f() {
        return brs_BalanceStatic_f;
    }

    public void setBrs_BalanceStatic_f(Map<String, Object> brs_BalanceStatic_f) {
        this.brs_BalanceStatic_f = brs_BalanceStatic_f;
    }

    public List<Map<String, Object>> getBrs_BalanceStatic_l_bank() {
        return brs_BalanceStatic_l_bank;
    }

    public void setBrs_BalanceStatic_l_bank(List<Map<String, Object>> brs_BalanceStatic_l_bank) {
        this.brs_BalanceStatic_l_bank = brs_BalanceStatic_l_bank;
    }

    public List<Map<String, Object>> getBrs_BalanceStatic_l_comp() {
        return brs_BalanceStatic_l_comp;
    }

    public void setBrs_BalanceStatic_l_comp(List<Map<String, Object>> brs_BalanceStatic_l_comp) {
        this.brs_BalanceStatic_l_comp = brs_BalanceStatic_l_comp;
    }

    public Integer getRecordId() {
        return recordId;
    }

    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }
}

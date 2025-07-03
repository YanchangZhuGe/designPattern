package com.nstc.brs.business.account.month;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsBalanceStatic;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CollectionUtils;
import com.nstc.util.DateUtil;
import com.nstc.util.MathExtend;

/**
 * 批量生成余额调节表-月末对账主页面, 按钮-初始化数据
 *
 * @ClassName SubmitMonthCheckListBusiness
 * @Author fmh
 * @Date 2024-12-3
 */
public class SubmitMonthCheckListBusiness extends AbstractBRSBusiness {
    private Map<String, Object> brs_monthCheck_q;
    private List<Map<String, Object>> brs_monthCheck_l;

    @SuppressWarnings("unchecked")
    @Override
    public void doExecute() throws Exception {
        this.putResult("brs_monthCheck_q", brs_monthCheck_q);
        this.putResult("brs_monthCheck_l", brs_monthCheck_l);

        List<Map<String, Object>> list = this.getGridSelectedRow(brs_monthCheck_l);
        if (!CollectionUtils.isEmpty(list)) {
            List<BrsCheckRecord> dataList = (List<BrsCheckRecord>) BeanHelper.populate(BrsCheckRecord.class, list);
            this.getContext().getBrsBankReconciliationService().saveBatchMakingMainRecord(dataList);
        }
    }

    public BrsBalanceStatic convertData(BrsCheckRecord record) {
        BrsBalanceStatic statics = new BrsBalanceStatic();
        statics.setRecordId(record.getId());
        statics.setMakeDate(DateUtil.getDate());
        statics.setBalanceDate(record.getMateDate());
        statics.setBankAccountNo(record.getBankAccountNo());
        statics.setBankBalance(record.getBankBalance());
        statics.setBussBalance(record.getInnerBalance());
        statics.setOpName(this.getCaller().getProfile().getUserNo());
        statics.setAmount(record.getMateAmount());
        statics.setUmMateAmount(record.getUmMateAmount());
        return statics;
    }

    public Map<String, Object> getBrs_monthCheck_q() {
        return brs_monthCheck_q;
    }

    public void setBrs_monthCheck_q(Map<String, Object> brs_monthCheck_q) {
        this.brs_monthCheck_q = brs_monthCheck_q;
    }

    public List<Map<String, Object>> getBrs_monthCheck_l() {
        return brs_monthCheck_l;
    }

    public void setBrs_monthCheck_l(List<Map<String, Object>> brs_monthCheck_l) {
        this.brs_monthCheck_l = brs_monthCheck_l;
    }


}

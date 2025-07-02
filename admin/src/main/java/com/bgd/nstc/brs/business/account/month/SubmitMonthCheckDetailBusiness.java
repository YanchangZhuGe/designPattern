package com.nstc.brs.business.account.month;

import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsBalanceStatic;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.BrsMateDetailSave;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.DateUtil;

/**
 * 生成余额调节表
 *
 * @ClassName SubmitMonthCheckDetailBusiness
 * @Author fmh
 * @Date 2024-12-2
 */
public class SubmitMonthCheckDetailBusiness extends AbstractBRSBusiness {
    private Map<String, Object> brs_monthCheckDetail_form;
    private List<Map<String, Object>> brs_monthCheckDetail_list;
    private List<Map<String, Object>> brs_monthCheckDetail_list2;
    private String id;

    @Override
    public void doExecute() throws Exception {
        Integer recordId = CastUtil.toInteger(brs_monthCheckDetail_form.get("id"));
        MonthCheckScope scope = new MonthCheckScope();
        scope.setId(recordId);
        scope.setRecordId(recordId);

        List<BrsCheckRecord> list = this.getContext().getAccountService().getMonthCheckList(scope);
        BrsBalanceStatic statics = this.convertData(list.get(0));
        List<Map<String, Object>> selectDt = this.getGridSelectedRow(brs_monthCheckDetail_list);

        if (selectDt != null && selectDt.size() > 0) {
            List<BrsMateDetailSave> dataList = BeanHelper.populate(BrsMateDetailSave.class, this.getGridSelectedRow(brs_monthCheckDetail_list));
            String detailType = CastUtil.toNotEmptyString(brs_monthCheckDetail_list.get(0).get("detailType"));
            if (dataList != null && dataList.size() > 0) {
                this.getContext().getAccountService().saveMonthCheckDetailSave(detailType, recordId, dataList);
            }
        }

        selectDt = this.getGridSelectedRow(brs_monthCheckDetail_list2);
        if (selectDt != null && selectDt.size() > 0) {
            List<BrsMateDetailSave> dataList = BeanHelper.populate(BrsMateDetailSave.class, this.getGridSelectedRow(brs_monthCheckDetail_list2));
            String detailType = CastUtil.toNotEmptyString(brs_monthCheckDetail_list.get(0).get("detailType"));
            if (dataList != null && dataList.size() > 0) {
                this.getContext().getAccountService().saveMonthCheckDetailSave(detailType, recordId, dataList);
            }
        }

        this.getContext().getAccountService().submitMonthCheckDetail(statics);

        this.putResult("brs_monthCheckDetail_form", brs_monthCheckDetail_form);
        this.putResult("brs_monthCheckDetail_list", brs_monthCheckDetail_list);
        this.putResult("brs_monthCheckDetail_list2", brs_monthCheckDetail_list2);
        this.putResult("successFlag", "1");
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

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }


    public Map<String, Object> getBrs_monthCheckDetail_form() {
        return brs_monthCheckDetail_form;
    }


    public void setBrs_monthCheckDetail_form(
            Map<String, Object> brs_monthCheckDetail_form) {
        this.brs_monthCheckDetail_form = brs_monthCheckDetail_form;
    }


    public List<Map<String, Object>> getBrs_monthCheckDetail_list() {
        return brs_monthCheckDetail_list;
    }


    public void setBrs_monthCheckDetail_list(
            List<Map<String, Object>> brs_monthCheckDetail_list) {
        this.brs_monthCheckDetail_list = brs_monthCheckDetail_list;
    }


    public List<Map<String, Object>> getBrs_monthCheckDetail_list2() {
        return brs_monthCheckDetail_list2;
    }


    public void setBrs_monthCheckDetail_list2(
            List<Map<String, Object>> brs_monthCheckDetail_list2) {
        this.brs_monthCheckDetail_list2 = brs_monthCheckDetail_list2;
    }


}

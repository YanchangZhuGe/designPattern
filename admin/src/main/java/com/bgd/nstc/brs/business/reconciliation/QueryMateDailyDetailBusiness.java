package com.nstc.brs.business.reconciliation;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.AmountDir;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.enums.MateFlag;
import com.nstc.brs.enums.MateType;
import com.nstc.brs.model.BrsMateDailyDetailModel;
import com.nstc.brs.model.scope.BrsMateDailyDetailScope;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2024-11-28
 * @Version:1.0
 */
public class QueryMateDailyDetailBusiness extends AbstractBRSBusiness {
    private Map<String,Object> brs_mateDetail_form;
    private String mainId;
    private String sourceId;
    @Override
    public void doExecute() throws Exception {
        if(brs_mateDetail_form==null){
            brs_mateDetail_form = new HashMap<String, Object>();
            brs_mateDetail_form.put("mainId",mainId);
            brs_mateDetail_form.put("sourceId",sourceId);

        }else{
            sourceId = CastUtil.toNotEmptyString(brs_mateDetail_form.get("sourceId"));
            mainId = CastUtil.toNotEmptyString(brs_mateDetail_form.get("mainId"));
        }
        BrsMateRecordScope recordScope = new BrsMateRecordScope();
        recordScope.setId(CastUtil.toInteger(mainId));
        List<BrsCheckRecord> dataList = getContext().getBrsBankReconciliationService().queryDailyMateList(recordScope);
        if(dataList==null || dataList.size()<=0){
            putResult("amountDirList", AmountDir.getAll());
            putResult("mateTypeList", MateFlag.getAll());

            putResult("brs_mateDetail_form", brs_mateDetail_form);
            return;
        }
        BrsCheckRecord  record = dataList.get(0);
        if(StringUtils.isNotEmpty(sourceId)){
            BrsMateDailyDetailScope scope = new BrsMateDailyDetailScope();
            String[] sourceIdArray = sourceId.split(",");
            scope.setSourceIdArray(sourceIdArray);
            //已匹配银行账
            scope.setDetailType(DetailType.TYPE_1.getValue());
            List<BrsMateDailyDetailModel> bankDetailList = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);
            //已匹配企业账
            scope.setDetailType(DetailType.TYPE_2.getValue());
            List<BrsMateDailyDetailModel> innerDetailList = getContext().getBrsBankReconciliationService().queryMateDetailList(scope);

            putResult("brs_mateDetail_list_r", BeanHelper.describe(bankDetailList));
            putResult("brs_mateDetail_list_l", BeanHelper.describe(innerDetailList));
            brs_mateDetail_form.putAll(BeanHelper.describe(record));
        }
        putResult("brs_mateDetail_form", brs_mateDetail_form);
        putResult("amountDirList", AmountDir.getAll());
        putResult("mateTypeList", MateFlag.getAll());
    }


    public Map<String, Object> getBrs_mateDetail_form() {
        return brs_mateDetail_form;
    }

    public void setBrs_mateDetail_form(Map<String, Object> brs_mateDetail_form) {
        this.brs_mateDetail_form = brs_mateDetail_form;
    }

    public String getMainId() {
        return mainId;
    }

    public void setMainId(String mainId) {
        this.mainId = mainId;
    }

    public String getSourceId() {
        return sourceId;
    }

    public void setSourceId(String sourceId) {
        this.sourceId = sourceId;
    }
}

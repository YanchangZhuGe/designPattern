package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.CollectionUtils;

import java.util.List;
import java.util.Map;

/**
 * @Description: ��ʼ������-δ����ϸҳ��
 * @Author:YPQ
 * @CreateTime: 2025-03-28
 * @Version:1.0
 */
public class DoInitMonthRecordBusiness extends AbstractBRSBusiness {
    private Map<String, Object> brs_monthCheckDetail_form;

    @Override
    public void doExecute() throws Exception {
        Integer mainId = CastUtil.toInteger(brs_monthCheckDetail_form.get("id"));
        BrsMateRecordScope scope = new BrsMateRecordScope();
        scope.setId(mainId);
        if (mainId == null) {
            throw new RuntimeException("û�ҵ�����¼���������ʼ��");
        }
        List<BrsCheckRecord> dataList = getContext().getBrsBankReconciliationService().queryDailyMateList(scope);
        if (!CollectionUtils.isEmpty(dataList)) {
            this.getContext().getBrsBankReconciliationService().saveBatchMakingMainRecord(dataList);
        }
        this.putResult("brs_monthCheckDetail_form", brs_monthCheckDetail_form);
        this.putResult("successFlag", "1");

    }

    public Map<String, Object> getBrs_monthCheckDetail_form() {
        return brs_monthCheckDetail_form;
    }

    public void setBrs_monthCheckDetail_form(Map<String, Object> brs_monthCheckDetail_form) {
        this.brs_monthCheckDetail_form = brs_monthCheckDetail_form;
    }
}

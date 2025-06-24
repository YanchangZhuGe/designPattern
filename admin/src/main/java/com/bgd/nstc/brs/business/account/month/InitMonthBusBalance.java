package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.CastUtil;
import com.nstc.util.DateUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-14
 * @Version:1.0
 */
public class InitMonthBusBalance extends AbstractBRSBusiness {
    private Map<String,Object> brs_modifyBussBalance_form;
    private String  mainId;
    @SuppressWarnings("unchecked")
    @Override
    public void doExecute() throws Exception {
        if(brs_modifyBussBalance_form==null){
            brs_modifyBussBalance_form = new HashMap<String, Object>();
            brs_modifyBussBalance_form.put("id",mainId);
        }
        Integer id = CastUtil.toInteger(brs_modifyBussBalance_form.get("id"));
        MonthCheckScope scope = new MonthCheckScope();
        scope.setId(id);
        //²éÑ¯Êý¾Ý
        List<BrsCheckRecord> list = this.getContext().getAccountService().getMonthCheckList(scope);
        BrsCheckRecord main = list.get(0);
        Map<String,Object> param = new HashMap<String, Object>();

        param.put("accountNo",main.getCheckAccNo());
        param.put("curCode",main.getCurCode());
        param.put("curDate", DateUtil.addDay(DateUtil.getMonthEnd(main.getMateDate()),1));
        Double innerBalance = this.getContext().getBrsBankReconciliationService().getInnerAccBalance(param);
        brs_modifyBussBalance_form.put("accountNo",main.getBankAccountNo());
        brs_modifyBussBalance_form.put("preBalance",main.getInnerBalance());
        brs_modifyBussBalance_form.put("balance",innerBalance);
        this.putResult("brs_modifyBussBalance_form", brs_modifyBussBalance_form);
    }

    public Map<String, Object> getBrs_modifyBussBalance_form() {
        return brs_modifyBussBalance_form;
    }

    public void setBrs_modifyBussBalance_form(Map<String, Object> brs_modifyBussBalance_form) {
        this.brs_modifyBussBalance_form = brs_modifyBussBalance_form;
    }

    public String getMainId() {
        return mainId;
    }

    public void setMainId(String mainId) {
        this.mainId = mainId;
    }
}

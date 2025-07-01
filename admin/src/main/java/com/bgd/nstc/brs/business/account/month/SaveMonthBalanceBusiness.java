package com.nstc.brs.business.account.month;

import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.model.scope.BrsMateRecordScope;
import com.nstc.util.CastUtil;

/**
 * 保存余额调整信息
 * @ClassName SaveMonthBalanceBusiness
 * @Author fmh
 * @Date 2024-11-25
 */
public class SaveMonthBalanceBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthBalc_form;

	@Override
	public void doExecute() throws Exception {
		BrsMateRecordScope qryScope = new BrsMateRecordScope();
		Integer id = CastUtil.toInteger(brs_monthBalc_form.get("id"));
		Double balance = CastUtil.toDouble(brs_monthBalc_form.get("balance"));
		qryScope.setId(id);
		BrsCheckRecord record = this.getContext().getBrsBankReconciliationService().queryDailyMateList(qryScope).get(0);
		record.setBankBalance(balance);
		this.getContext().getBrsBankReconciliationService().saveUpdateChangeBalance(record);
		
		brs_monthBalc_form.put("successFlag", 1);
		this.putResult("brs_monthBalc_form", brs_monthBalc_form);
	}

	public Map<String, Object> getBrs_monthBalc_form() {
		return brs_monthBalc_form;
	}

	public void setBrs_monthBalc_form(Map<String, Object> brs_monthBalc_form) {
		this.brs_monthBalc_form = brs_monthBalc_form;
	}

	

}

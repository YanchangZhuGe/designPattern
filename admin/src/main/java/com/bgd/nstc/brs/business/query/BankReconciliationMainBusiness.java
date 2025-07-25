package com.nstc.brs.business.query;


import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;

/**
 * 
 * @Title 查询银行余额调节表
 * @Description: 
 * @author ZCL
 * @date 2014-8-29 下午02:40:16
 */
public class BankReconciliationMainBusiness extends AbstractBRSBusiness{

	private Map<String,String> brs_qryBankReconciliation_top;
	
	@Override
	public void doExecute() throws Exception {
		putCommonResult();
	}
	
	protected void putCommonResult(){
		//科目列表
		//putResult("kms", getContext().getAccountService().getKms());
		putResult("kms", getContext().getAccountService().getKmsAndName());
	}

	public Map<String, String> getBrs_qryBankReconciliation_top() {
		return brs_qryBankReconciliation_top;
	}

	public void setBrs_qryBankReconciliation_top(
			Map<String, String> brs_qryBankReconciliation_top) {
		this.brs_qryBankReconciliation_top = brs_qryBankReconciliation_top;
	}

}

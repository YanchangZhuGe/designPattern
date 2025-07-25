package com.nstc.brs.business.query;


import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;

/**
 * 
 * @Title ��ѯ���������ڱ�
 * @Description: 
 * @author ZCL
 * @date 2014-8-29 ����02:40:16
 */
public class BankReconciliationMainBusiness extends AbstractBRSBusiness{

	private Map<String,String> brs_qryBankReconciliation_top;
	
	@Override
	public void doExecute() throws Exception {
		putCommonResult();
	}
	
	protected void putCommonResult(){
		//��Ŀ�б�
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

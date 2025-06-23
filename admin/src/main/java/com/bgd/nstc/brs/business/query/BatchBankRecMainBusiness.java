package com.nstc.brs.business.query;

import java.util.Map;


import com.nstc.brs.business.AbstractBRSBusiness;

/**
 * 
 * @Title 银行余额调节表汇总查询
 * @Description: 
 * @author ZCL
 * @date 2014-9-1 下午04:06:18
 */
public class BatchBankRecMainBusiness extends AbstractBRSBusiness{
	private Map<String,String> brs_qryBatchBankRec_top;

	@Override
	public void doExecute() throws Exception {
		putCommonResult();
	}
	protected void putCommonResult(){
		//putResult("kms", getContext().getAccountService().getKms());
		putResult("kms", getContext().getAccountService().getKmsAndName());
	}

	public Map<String, String> getBrs_qryBatchBankRec_top() {
		return brs_qryBatchBankRec_top;
	}

	public void setBrs_qryBatchBankRec_top(
			Map<String, String> brs_qryBatchBankRec_top) {
		this.brs_qryBatchBankRec_top = brs_qryBatchBankRec_top;
	}
}

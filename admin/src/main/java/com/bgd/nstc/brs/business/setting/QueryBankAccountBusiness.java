package com.nstc.brs.business.setting;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;

/**
 * 银行账户查询列表
 * @ClassName QueryBankAccountBusiness
 * @Author fmh
 * @Date 2024-11-19
 */
public class QueryBankAccountBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_bankAccount_q;
	private List<Map<String, Object>> brs_bankAccount_l;
	private String qBankNo;

	@Override
	public void doExecute() throws Exception {
		if(brs_bankAccount_q == null){
			brs_bankAccount_q = new HashMap<String, Object>();
			brs_bankAccount_q.put("bankNo", qBankNo);
		}
		
		List<Map<String, Object>> list = this.getContext().getCommonService().getBankAccountList(brs_bankAccount_q);
		brs_bankAccount_l = list;
		this.putResult("bankList", this.getContext().getAccountService().getBankList());
		this.putResult("curCodeList", this.getContext().getCommonService().getCurrencyList());
		this.putResult("brs_bankAccount_q", brs_bankAccount_q);
		this.putResult("brs_bankAccount_l", brs_bankAccount_l);
	}

	public Map<String, Object> getBrs_bankAccount_q() {
		return brs_bankAccount_q;
	}

	public void setBrs_bankAccount_q(Map<String, Object> brs_bankAccount_q) {
		this.brs_bankAccount_q = brs_bankAccount_q;
	}

	public List<Map<String, Object>> getBrs_bankAccount_l() {
		return brs_bankAccount_l;
	}

	public void setBrs_bankAccount_l(List<Map<String, Object>> brs_bankAccount_l) {
		this.brs_bankAccount_l = brs_bankAccount_l;
	}

	public void setqBankNo(String qBankNo) {
		this.qBankNo = qBankNo;
	}

	public String getqBankNo() {
		return qBankNo;
	}

}

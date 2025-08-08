package com.nstc.brs.business.setting;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccountSet;
import com.nstc.brs.enums.AccountState;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.StringUtils;

/**
 * ∂‘’À’Àªß…Ë÷√
 * @ClassName QueryAccountSetBusiness
 * @Author fmh
 * @Date 2024-11-19
 */
public class QueryAccountSetBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_accountSet_q;
	private List<Map<String, Object>> brs_accountSet_l;

	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {
		if(brs_accountSet_q == null){
			brs_accountSet_q = new HashMap<String, Object>();
			brs_accountSet_q.put("state","0");
		}
		String accountNos = CastUtil.toNotEmptyString(brs_accountSet_q.get("accountNos"));
		if(!StringUtils.isEmpty(accountNos)){
			brs_accountSet_q.put("accountArray",accountNos.split(","));
		}
		List<BrsAccountSet> list = this.getContext().getCommonService().getAccountSetList(brs_accountSet_q);
		brs_accountSet_l = BeanHelper.describe(list);
		this.putResult("bankList", this.getContext().getAccountService().getBankList());
		this.putResult("curList", this.getContext().getCommonService().getCurrencyList());
		this.putResult("stateList", AccountState.getAll());
		this.putResult("brs_accountSet_q", brs_accountSet_q);
		this.putResult("brs_accountSet_l", brs_accountSet_l);
	}

	public Map<String, Object> getBrs_accountSet_q() {
		return brs_accountSet_q;
	}

	public void setBrs_accountSet_q(Map<String, Object> brs_accountSet_q) {
		this.brs_accountSet_q = brs_accountSet_q;
	}

	public List<Map<String, Object>> getBrs_accountSet_l() {
		return brs_accountSet_l;
	}

	public void setBrs_accountSet_l(List<Map<String, Object>> brs_accountSet_l) {
		this.brs_accountSet_l = brs_accountSet_l;
	}

	
	
}

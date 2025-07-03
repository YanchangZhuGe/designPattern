package com.nstc.brs.business.account;

import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.handler.R;
import com.nstc.brs.util.CastUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 账户明细显示
 * @Description: 
 * @author ZCL
 * @date 2014-8-20 上午10:23:37
 */
public class AccountDetailBusiness extends AbstractBRSBusiness {

	private Integer id;
	private Map<String,String> brs_account_detail;
	
	@Override
	public void doExecute() throws Exception {
		putResult("banks", getContext().getAccountService().getBankMap());
		if(id == null){
			if(brs_account_detail == null || CastUtil.trimNull(brs_account_detail.get("id")).equals("") ){
				return ;
			}else{
				id = CastUtil.toInteger(brs_account_detail.get("id"));
			}
		}
		BrsAccount account = getContext().getAccountService().getAccount(new BrsAccount(id));
		putResult(R.SP.ACCOUNT_DETAIL, BeanHelper.describe(account));
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Map<String, String> getBrs_account_detail() {
		return brs_account_detail;
	}

	public void setBrs_account_detail(Map<String, String> brs_account_detail) {
		this.brs_account_detail = brs_account_detail;
	}
	
}

package com.nstc.brs.business.account;

import java.util.List;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.handler.R;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 账户设置初始页面
 * @Description: 
 * @author ZCL
 * @date 2014-8-19 上午11:26:21
 */
public class AccountMainBusiness extends AbstractBRSBusiness {

	@Override
	public void doExecute() throws Exception {
		putResult(R.SP.ACCOUNT_LIST, BeanHelper.describe(getBrsAccountList()));
	}
	
	public List<BrsAccount> getBrsAccountList(){
		return getContext().getAccountService().getAccountList(new BrsAccount());
	}

}

package com.nstc.brs.business.account;

import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.handler.R;
import com.nstc.brs.service.BrsAccountService;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 保存账户
 * @Description: 
 * @author ZCL
 * @date 2014-8-19 下午05:15:41
 */
public class EditAccountBusiness extends AbstractBRSBusiness {

	private List<Map<String,String>> brs_account_list;
	
	@Override
	public void doExecute() throws Exception {
		doEdit();
	}
	
	/**
	 * 
	* @Description:分析前台数据 执行增删改查
	* @author ZCL
	* @date 2014-8-19 下午06:19:06
	 */
	private void doEdit(){
		//给list追加机构号
		subProperty(brs_account_list, "branchNo", getCaller().getProfile().getBranchNo());
		
		BrsAccountService bas = getContext().getAccountService();
		List<BrsAccount> insertList = BeanHelper.populate(BrsAccount.class,
				getGridByRowType(brs_account_list, R.SPRowType.ADD));
		List<BrsAccount> updateList = BeanHelper.populate(BrsAccount.class,
				getGridByRowType(brs_account_list, R.SPRowType.MODIFIED));
		List<BrsAccount> deletList = BeanHelper.populate(BrsAccount.class,
				getGridByRowType(brs_account_list, R.SPRowType.DELETE));
		//判断科目号账号是否重复
		if(!validate(insertList) || !validate(updateList)){
			return ;
		}
		bas.saveAccount(insertList);
		bas.updateAccount(updateList);
		bas.deleteAccount(deletList);
	}
	
	/** 判断科目号账号是否重复*/
	private boolean validate(List<BrsAccount> list){
		boolean flag = true;
		for (BrsAccount account : list) {
			BrsAccount qry = new BrsAccount();
			qry.setAccountNo(account.getAccountNo());
			qry.setSubjectNo(account.getSubjectNo());
			Integer withoutId = account.getId();
			if(withoutId != null){
				qry.setWithoutId(withoutId);
			}
			List<BrsAccount> result = getContext().getAccountService().getAccountList(qry);
			if(result.size() > 0){
				set_ErrorMessage("科目:" + account.getSubjectNo() + ",账号:" + account.getAccountNo() + "的数据在系统存在相同记录");
				flag = false;
				break;
			}
		}
		return flag;
	}

	public List<Map<String, String>> getBrs_account_list() {
		return brs_account_list;
	}

	public void setBrs_account_list(List<Map<String, String>> brs_account_list) {
		this.brs_account_list = brs_account_list;
	}

}

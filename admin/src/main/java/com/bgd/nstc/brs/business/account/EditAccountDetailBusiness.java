package com.nstc.brs.business.account;

import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title �༭�˻���ϸ��Ϣ
 * @Description: 
 * @author ZCL
 * @date 2014-8-20 ����10:37:43
 */
public class EditAccountDetailBusiness extends AbstractBRSBusiness {
	public Map<String,String> brs_account_detail;

	@Override
	public void doExecute() throws Exception {
		BrsAccount account  = BeanHelper.populate(BrsAccount.class, brs_account_detail);
		if(!validate(account)){
			return;
		}
		if(account.getId() == null){
			Integer id = insert(account);
			account.setId(id);
		}else{
			update(account);
			putResult("id", account.getId());
		}
		putResult("saveType", "success");
	}
	
	private Integer insert(BrsAccount account){
		return getContext().getAccountService().saveAccount(account);
	}
	
	private void update(BrsAccount account){
		getContext().getAccountService().updateAccount(account);
	}
	
	/** �жϿ�Ŀ���˺��Ƿ��ظ�2*/
	private boolean validate(BrsAccount account){
		boolean flag = true;
		BrsAccount qry = new BrsAccount();
		qry.setAccountNo(account.getAccountNo());
		qry.setSubjectNo(account.getSubjectNo());
		Integer withoutId = account.getId();
		if(withoutId != null){
			qry.setWithoutId(withoutId);
		}
		List<BrsAccount> result = getContext().getAccountService().getAccountList(qry);
		if(result.size() > 0){
			set_ErrorMessage("��Ŀ:" + account.getSubjectNo() + ",�˺�:" + account.getAccountNo() + "��������ϵͳ������ͬ��¼");
			flag = false;
		}
		return flag;
	}

	public Map<String, String> getBrs_account_detail() {
		return brs_account_detail;
	}

	public void setBrs_account_detail(Map<String, String> brs_account_detail) {
		this.brs_account_detail = brs_account_detail;
	}
}

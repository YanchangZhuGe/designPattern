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
 * @Title �����˻�
 * @Description: 
 * @author ZCL
 * @date 2014-8-19 ����05:15:41
 */
public class EditAccountBusiness extends AbstractBRSBusiness {

	private List<Map<String,String>> brs_account_list;
	
	@Override
	public void doExecute() throws Exception {
		doEdit();
	}
	
	/**
	 * 
	* @Description:����ǰ̨���� ִ����ɾ�Ĳ�
	* @author ZCL
	* @date 2014-8-19 ����06:19:06
	 */
	private void doEdit(){
		//��list׷�ӻ�����
		subProperty(brs_account_list, "branchNo", getCaller().getProfile().getBranchNo());
		
		BrsAccountService bas = getContext().getAccountService();
		List<BrsAccount> insertList = BeanHelper.populate(BrsAccount.class,
				getGridByRowType(brs_account_list, R.SPRowType.ADD));
		List<BrsAccount> updateList = BeanHelper.populate(BrsAccount.class,
				getGridByRowType(brs_account_list, R.SPRowType.MODIFIED));
		List<BrsAccount> deletList = BeanHelper.populate(BrsAccount.class,
				getGridByRowType(brs_account_list, R.SPRowType.DELETE));
		//�жϿ�Ŀ���˺��Ƿ��ظ�
		if(!validate(insertList) || !validate(updateList)){
			return ;
		}
		bas.saveAccount(insertList);
		bas.updateAccount(updateList);
		bas.deleteAccount(deletList);
	}
	
	/** �жϿ�Ŀ���˺��Ƿ��ظ�*/
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
				set_ErrorMessage("��Ŀ:" + account.getSubjectNo() + ",�˺�:" + account.getAccountNo() + "��������ϵͳ������ͬ��¼");
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

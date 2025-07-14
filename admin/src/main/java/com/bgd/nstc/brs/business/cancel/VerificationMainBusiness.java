package com.nstc.brs.business.cancel;

import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 核销
 * @Description: 
 * @author ZCL
 * @date 2014-8-28 下午02:51:51
 */
public class VerificationMainBusiness extends AbstractBRSBusiness{
	private Map<String,String> brs_verification_top;
	private List<Map<String,String>> brs_verification_list;
	
	@Override
	public void doExecute() throws Exception {
		putCommonResult();
	}
	
	protected void putCommonResult(){
		//科目列表
		//putResult("kms", getContext().getAccountService().getKms());
		putResult("kms", getContext().getAccountService().getKmsAndName());
	}
	
	/**
	 * 
	* @Description:得到选中的记录
	* @author ZCL
	* @date 2014-8-28 下午05:15:13
	 */
	protected BrsStatementRecord getCheckedRecord() {
		//选中的记录
		List<BrsStatementRecord> list = BeanHelper.populate(BrsStatementRecord.class, getGridSelectedRow(getBrs_verification_list()));
		BrsStatementRecord qryObj= list.get(0);
		BrsStatementRecord record = getContext().getStatementRecordService().getRecord(qryObj);
		return record;
	}

	public Map<String, String> getBrs_verification_top() {
		return brs_verification_top;
	}

	public void setBrs_verification_top(Map<String, String> brs_verification_top) {
		this.brs_verification_top = brs_verification_top;
	}

	public List<Map<String, String>> getBrs_verification_list() {
		return brs_verification_list;
	}

	public void setBrs_verification_list(
			List<Map<String, String>> brs_verification_list) {
		this.brs_verification_list = brs_verification_list;
	}

}

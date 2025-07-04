package com.nstc.brs.business.account;

import java.util.List;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.handler.R;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title ÕËºÅÑ¡Ôñ
 * @Description: 
 * @author ZCL
 * @date 2014-8-20 ÏÂÎç05:11:46
 */
public class AccountSelectBusiness extends AbstractBRSBusiness{
	
	private String subjectNo;
	private String startSubjectNo;
	private String endSubjectNo;
	private String callBackFun;
	private String objName;
	@Override
	public void doExecute() throws Exception {
		BrsAccount qryPara = new BrsAccount();
		qryPara.setSubjectNo(subjectNo);
		qryPara.setStartSubjectNo(startSubjectNo);
		qryPara.setEndSubjectNo(endSubjectNo);
		List<BrsAccount> result = getContext().getAccountService().getAccountList(qryPara);
		putResult(R.SP.ACCOUNT_SELECT, BeanHelper.describe(result));
		putResult("callBackFun", callBackFun);
		putResult("objName", objName);
	}
	public String getSubjectNo() {
		return subjectNo;
	}
	public void setSubjectNo(String subjectNo) {
		this.subjectNo = subjectNo;
	}
	public String getCallBackFun() {
		return callBackFun;
	}
	public void setCallBackFun(String callBackFun) {
		this.callBackFun = callBackFun;
	}
	public String getStartSubjectNo() {
		return startSubjectNo;
	}
	public void setStartSubjectNo(String startSubjectNo) {
		this.startSubjectNo = startSubjectNo;
	}
	public String getEndSubjectNo() {
		return endSubjectNo;
	}
	public void setEndSubjectNo(String endSubjectNo) {
		this.endSubjectNo = endSubjectNo;
	}
	public String getObjName() {
		return objName;
	}
	public void setObjName(String objName) {
		this.objName = objName;
	}

}

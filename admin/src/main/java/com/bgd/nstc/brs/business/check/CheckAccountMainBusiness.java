package com.nstc.brs.business.check;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.util.CastUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 对账基础页面
 * @Description: 
 * @author ZCL
 * @date 2014-8-20 下午03:12:04
 */
public class CheckAccountMainBusiness extends AbstractBRSBusiness{
	private List<Map<String,String>> brs_checkAccount_voucher;
	private List<Map<String,String>> brs_checkAccount_bank;
	private Map<String,String> brs_checkAccount_top;
	private Map<String,String> brs_checkAccount_ruleHidden;

	@Override
	public void doExecute() throws Exception {
		putCommonResult();
		putResult("matchDate", lastRecordDate(buildStatementRecordQry()));
	}
	
	/** 公用的参数 */
	protected void putCommonResult(){
		//科目列表
		//putResult("kms", getContext().getAccountService().getKms());
		putResult("kms", getContext().getAccountService().getKmsAndName());
	}
	
	/** 构建查询条件*/
	protected CheckAccountQry buildQry(){
		CheckAccountQry qryObj = BeanHelper.populate(CheckAccountQry.class, brs_checkAccount_top);
		return qryObj;
	}
	
	/** 查账当前账户的账户初始信息 */
	protected BrsAccount getBrsAccount(){
		BrsAccount result = new BrsAccount();
		CheckAccountQry qry = buildQry();
		if(qry.getAccountNo() != null && !qry.getAccountNo().equals("")){
			BrsAccount accountQryObj = new BrsAccount();
			accountQryObj.setAccountNo(qry.getAccountNo());
			accountQryObj.setSubjectNo(qry.getSubjectNo());
			result = getContext().getAccountService().getAccount(accountQryObj);
		}
		return result;
	}
	/** 返回被选中的企业帐*/
	protected List<BrsVoucher> getCheckedVoucherList() {
		List<Map<String,String>> list = getBrs_checkAccount_voucher();
		List<BrsVoucher> result = new ArrayList<BrsVoucher>(); 
		if(list == null || list.size() == 0	){
			return result;
		}
		return BeanHelper.populate(BrsVoucher.class, getGridSelectedRow(getBrs_checkAccount_voucher()));
	}
	
	/** 返回被选中的银行帐*/
	protected List<BrsBankRecord> getCheckedBankRecordList() {
		List<Map<String,String>> list = getBrs_checkAccount_bank();
		List<BrsBankRecord> result = new ArrayList<BrsBankRecord>(); 
		if(list == null || list.size() == 0	){
			return result;
		}
		return BeanHelper.populate(BrsBankRecord.class, getGridSelectedRow(list));
	}
	
	/** 构建对账记录查询对象*/
	protected BrsStatementRecord buildStatementRecordQry(){
		if(brs_checkAccount_top == null)
			return null;
		BrsStatementRecord result = new BrsStatementRecord();
		result.setAccountNo(CastUtil.trimNull(brs_checkAccount_top.get("accountNo")));
		result.setSubjectNo(CastUtil.trimNull(brs_checkAccount_top.get("subjectNo")));
		return result;
	}
	
	/** 构建对账记录查询对象
	 * @throws ParseException */
	protected Date getStartDate(){
		if(brs_checkAccount_top == null){
			return null;
		}else{
			String startDateStr = CastUtil.trimNull(brs_checkAccount_top.get("startDate"));
			if(startDateStr != null && !"".equals(startDateStr)){
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
				Date startDate;
				try {
					startDate = sf.parse(startDateStr);
					return  startDate;
				} catch (ParseException e) {
					throw new RuntimeException("输入的日期【"+startDateStr+"】格式不正确【yyyy-MM-dd】");
				}
				
			}
		}
		return null;
	}
	
	public List<Map<String, String>> getBrs_checkAccount_voucher() {
		return brs_checkAccount_voucher;
	}

	public void setBrs_checkAccount_voucher(
			List<Map<String, String>> brs_checkAccount_voucher) {
		this.brs_checkAccount_voucher = brs_checkAccount_voucher;
	}

	public List<Map<String, String>> getBrs_checkAccount_bank() {
		return brs_checkAccount_bank;
	}

	public void setBrs_checkAccount_bank(
			List<Map<String, String>> brs_checkAccount_bank) {
		this.brs_checkAccount_bank = brs_checkAccount_bank;
	}

	public Map<String, String> getBrs_checkAccount_top() {
		return brs_checkAccount_top;
	}

	public void setBrs_checkAccount_top(Map<String, String> brs_checkAccount_top) {
		this.brs_checkAccount_top = brs_checkAccount_top;
	}

	public Map<String, String> getBrs_checkAccount_ruleHidden() {
		return brs_checkAccount_ruleHidden;
	}

	public void setBrs_checkAccount_ruleHidden(
			Map<String, String> brs_checkAccount_ruleHidden) {
		this.brs_checkAccount_ruleHidden = brs_checkAccount_ruleHidden;
	}

}

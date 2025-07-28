package com.nstc.brs.business.query;


import java.text.SimpleDateFormat;
import java.util.List;

import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.domain.BrsBalanceFormula;
import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.enums.DirFlag;
import com.nstc.brs.enums.FilterTarget;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.util.CastUtil;
import com.nstc.util.BeanHelper;



/**
 * 
 * @Title 查询银行余额调节表
 * @Description: 
 * @author ZCL
 * @date 2014-8-29 下午02:40:16
 */
public class BankReconciliationQryBusiness extends BankReconciliationMainBusiness{
	private static final SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	@Override
	public void doExecute() throws Exception {
		//add by fankebo for ZTCW-987 start 20170316
		//设置企业账与银行账查询的起始日期
		String starDate = getContext().getCheckAccountService().getbrsStartDate();
		if(starDate==null || "".equals(starDate)){
			this.set_ErrorMessage("请在全局业务参数中设置BRS.STARTDATE参数的值,此值不能为空！");
			return ;
		}
	    if(!isValidDate(starDate)){
	    	this.set_ErrorMessage("请在全局业务参数中按照正确日期格式设置,BRS.STARTDATE参数的值！");
		    return ;
	    }
		putResult(R.SP.QRYBANKREC_TOP, getBrs_qryBankReconciliation_top());
		putResult(R.SP.QRYBANKREC_DATA,BeanHelper.describe(getBalanceFormula()));
		CheckAccountQry jqry = buildQry(DirFlag.DEBIT.getValue());
		CheckAccountQry dqry = buildQry(DirFlag.CREDIT.getValue());
	    jqry.setStartDate(sdf.parse(starDate));
		dqry.setStartDate(sdf.parse(starDate));
		//add by fankebo for ZTCW-987 end 20170316
		//企业收入而银行未记账
		List<BrsVoucher> voucherJList = getContext().getCheckAccountService().getVoucher(jqry);
		//企业支出而银行未记账
		List<BrsVoucher> voucherDList = getContext().getCheckAccountService().getVoucher(dqry);
		//银行收入而企业未记账
		List<BrsBankRecord> bankJList = getContext().getCheckAccountService().getBankRecord(jqry);
		//银行支出而企业未记账
		List<BrsBankRecord> bankDList = getContext().getCheckAccountService().getBankRecord(dqry);
		putResult(R.SP.QRYBANKREC_VOUCHERJ, BeanHelper.describe(voucherJList));
		putResult(R.SP.QRYBANKREC_VOUCHERD, BeanHelper.describe(voucherDList));
		putResult(R.SP.QRYBANKREC_BANKJ, BeanHelper.describe(bankJList));
		putResult(R.SP.QRYBANKREC_BANKD, BeanHelper.describe(bankDList));
		
		putCommonResult();
	}
	
	/**
	 * 
	* @Description: 组合结果
	* @author ZCL
	* @date 2014-8-26 下午01:13:33
	 */
	protected BrsBalanceFormula getBalanceFormula(){
		BrsBalanceFormula voucherBalance = getVoucherBalance();
		BrsBalanceFormula bankBalance = getBankBalance();
		BrsBalanceFormula result = subBalanceFormula(voucherBalance, bankBalance);
		//上次对账剩余未到账信息
		BrsStatementRecord lastStateRecord = getContext().getStatementRecordService().getLastRecord(buildStatementRecordQry());
		lastStateRecord = lastStateRecord == null ? new BrsStatementRecord() : lastStateRecord;
		/**
		 * 公式 :
		 * 
		 *  企业余额 + 初始化前企业未达账 + (银行已收企业未收 - 银行已付企业未付) 
		 *  =
		 *  银行余额 + 初始化钱银行未达账  + (企业已收银行未收 - 企业已付银行未付) 
		 *  
		 *  XX已收(付)XX未收(付) = 本次XX已收(付)XX未收(付) + 历史未到账
		 */
		Double vBalance =
			result.getVoucherBalance() + 
			//收款付款 +历史未到账
			((result.getBankJval() -lastStateRecord.getBankJval()) - (result.getBankDval() - lastStateRecord.getBankDval()));
		Double bBalance = 
			result.getBankBalance() + 
			((result.getVoucherJval() -lastStateRecord.getVoucherJval()) - (result.getVoucherDval() - lastStateRecord.getVoucherDval()));
		result.setVoucherFormulaBalance(vBalance);
		result.setBankFormulaBalance(bBalance);
		
		Boolean resultFlag = true;
		if(vBalance.doubleValue() != bBalance.doubleValue()){
			
			resultFlag = false;
		}else{
			
		}
		result.setResultFlag(resultFlag);
		return result;
	}
	
	

	/**
	 * 
	* @Description:计算企业余额信息
	* @author ZCL
	* @date 2014-8-26 上午10:59:31
	 */
	private BrsBalanceFormula getVoucherBalance(){
		//企业余额信息
		BrsBalanceFormula voucherBalance = getContext().getCheckAccountService().getVoucherBalance(buildQry(null));
		//企业已收而银行未收
		Double voucherJval = voucherBalance.getJval();
		//企业已付而银行未付
		Double voucherDval = voucherBalance.getDval();
		
		voucherBalance.setVoucherJval(voucherJval);
		voucherBalance.setVoucherDval(voucherDval);
		return voucherBalance;
	}
	
	/**
	 * 
	* @Description:计算银行余额信息
	* @author ZCL
	* @date 2014-8-26 上午11:27:40
	 */
	private BrsBalanceFormula getBankBalance(){
		//银行余额信息
		BrsBalanceFormula bankBalance = getContext().getCheckAccountService().getBankBalance(buildQry(null));
		//银行收入而企业未记账
		Double bankJval = bankBalance.getJval();
		//银行支出而企业未记账
		Double bankDval = bankBalance.getDval();
		bankBalance.setBankJval(bankJval);
		bankBalance.setBankDval(bankDval);
		return bankBalance;
	}
	
	/**
	 * 
	* @Description: 将平账公式组合起来
	* 		如果系统从未核销过，则初始的未到账金额从设置账户信息的记录中查找
	  		如果系统至少做过一次核销，则从最后一次核销记录中去初始金额；
	* @author ZCL
	* @date 2014-8-28 上午11:50:27
	 */
	public BrsBalanceFormula subBalanceFormula(BrsBalanceFormula voucherBalance,BrsBalanceFormula bankBalance){
		Double voucherInitAmount = 0d;
		Double bankInitAmount = 0d;
		//初始化信息
		BrsAccount account = getBrsAccount();
		//末次核销记录
		BrsStatementRecord lastVerificationRecord = getContext().getStatementRecordService().getLastVerificationRecord(buildStatementRecordQry());
		
		if(lastVerificationRecord == null){
			voucherInitAmount = account.getAccountInitBalance();
			bankInitAmount = account.getBankAccountInitBalance();
		}else{
			voucherInitAmount = lastVerificationRecord.getBankJval() -lastVerificationRecord.getBankDval();
			bankInitAmount = lastVerificationRecord.getBankJval() - lastVerificationRecord.getBankDval();
		}
		
		BrsBalanceFormula result = new BrsBalanceFormula();
		result.setVoucherBalance(voucherBalance.getVoucherBalance() + voucherInitAmount );
		result.setVoucherJval(voucherBalance.getVoucherJval());
		result.setVoucherDval(voucherBalance.getVoucherDval());
		result.setBankBalance(bankBalance.getBankBalance() + bankInitAmount);
		result.setBankJval(bankBalance.getBankJval());
		result.setBankDval(bankBalance.getBankDval());
		
		return result;
	}
	
	/** 查账当前账户的账户初始信息*/
	protected BrsAccount getBrsAccount(){
		BrsAccount result = new BrsAccount();
		CheckAccountQry qry = BeanHelper.populate(CheckAccountQry.class, getBrs_qryBankReconciliation_top());
		if(qry.getAccountNo() != null && !qry.getAccountNo().equals("")){
			BrsAccount accountQryObj = new BrsAccount();
			accountQryObj.setAccountNo(qry.getAccountNo());
			accountQryObj.setSubjectNo(qry.getSubjectNo());
			result = getContext().getAccountService().getAccount(accountQryObj);
		}
		return result;
	}
	
	/** 构建对账记录查询对象*/
	protected BrsStatementRecord buildStatementRecordQry(){
		if(getBrs_qryBankReconciliation_top() == null)
			return null;
		BrsStatementRecord result = new BrsStatementRecord();
		result.setAccountNo(CastUtil.trimNull(getBrs_qryBankReconciliation_top().get("accountNo")));
		result.setSubjectNo(CastUtil.trimNull(getBrs_qryBankReconciliation_top().get("subjectNo")));
		return result;
	}
	
	/** 构建查询条件*/
	protected CheckAccountQry buildQry(Integer dirFlag){
		CheckAccountQry qryObj = BeanHelper.populate(CheckAccountQry.class, getBrs_qryBankReconciliation_top());
		qryObj.setDirFlag(dirFlag);
		qryObj.setFilterTarget(FilterTarget.ALL.getEnumValue());
		return qryObj;
	}
   public boolean isValidDate(String strDate){
	   try {
		   sdf.setLenient(false);
		   sdf.parse(strDate.trim());
		return true ;
	} catch (Exception e) {
		return false;
	}
   }
}

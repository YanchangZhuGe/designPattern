package com.nstc.brs.business.query;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.domain.BrsBalanceFormula;
import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.model.StatementRecordView;
import com.nstc.brs.util.CastUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 银行余额调节表汇总查询
 * @Description: 
 * @author ZCL
 * @date 2014-9-1 下午04:06:18
 */
public class BatchBankRecQryBusiness extends BatchBankRecMainBusiness{
	private Map<String,String> brs_qryBatchBankRec_top;
	//末次对账日
	private Date lastRecordDate;
	//末次核销日
	private Date lastVerificationDate;

	@Override
	public void doExecute() throws Exception {
		putCommonResult();
		BrsAccount accountQry = BeanHelper.populate(BrsAccount.class, brs_qryBatchBankRec_top);
		
		//拿到科目列表 开始循环查询结果
		List<BrsAccount> accountList = qryAccounts(accountQry);
		List<StatementRecordView> srList = getStatementRecordViews(accountList);
		putResult(R.SP.QRYBATCHBANKREC_LIST, BeanHelper.describe(srList));
		putResult("brs_qryBatchBankRec_top", brs_qryBatchBankRec_top);
	}
	
	/** 对账明细列表 */
	protected List<StatementRecordView> getStatementRecordViews(List<BrsAccount> accounts) {
		List<StatementRecordView> result = new ArrayList<StatementRecordView>();
		for (BrsAccount account : accounts) {
			//末次对账日 末次核销日  查询末次对账日作为默认endDate, 查询末次核销日作为startDate
			BrsStatementRecord srQry = new BrsStatementRecord(account.getSubjectNo(),account.getAccountNo());
			this.lastRecordDate = lastRecordDate(srQry);
			this.lastVerificationDate = lastVerificationDate(srQry);
			
			CheckAccountQry qry = buildQry(account);
			//企业余额信息
			BrsBalanceFormula voucherBalance = getContext().getCheckAccountService().getVoucherBalance(qry);
			//银行余额信息
			BrsBalanceFormula bankBalance = getContext().getCheckAccountService().getBankBalance(qry);
			BrsBalanceFormula totalBalance = subBalanceFormula(voucherBalance, bankBalance,account);
			StatementRecordView view = buildStatementRecordView(totalBalance, account);
			result.add(view);
		}
		return result;
	}
	
	protected StatementRecordView buildStatementRecordView(BrsBalanceFormula formula,BrsAccount account) {
		StatementRecordView view = new StatementRecordView();
		view.setSubjectNo(account.getSubjectNo());
		view.setAccountNo(account.getAccountNo());
		view.setAccountName(account.getAccountName());
		view.setEndDate(this.lastRecordDate);
		view.setVoucherBalance(formula.getVoucherBalance());
		view.setVoucherJval(formula.getVoucherJval());
		view.setVoucherDval(formula.getVoucherDval());
		view.setBankBalance(formula.getBankBalance());
		view.setBankJval(formula.getBankJval());
		view.setBankDval(formula.getBankDval());
		view.setVoucherFormulaBalance(formula.getVoucherFormulaBalance());
		view.setBankFormulaBalance(formula.getBankFormulaBalance());
		return view;
	}
	
	/**
	 * 
	* @Description: 将平账公式组合起来
	* 		如果系统从未核销过，则初始的未到账金额从设置账户信息的记录中查找
	  		如果系统至少做过一次核销，则从最后一次核销记录中去初始金额；
	* @author ZCL
	* @date 2014-8-28 上午11:50:27
	 */
	public BrsBalanceFormula subBalanceFormula(BrsBalanceFormula voucherBalance,BrsBalanceFormula bankBalance,BrsAccount qryAccount){
		Double voucherInitAmount = 0d;
		Double bankInitAmount = 0d;
		//初始化信息
		BrsAccount account = getBrsAccount(qryAccount);
		//末次核销记录
		BrsStatementRecord lastVerificationRecord = getContext().getStatementRecordService()
			.getLastVerificationRecord(buildStatementRecordQry(qryAccount));
		
		if(lastVerificationRecord == null){
			voucherInitAmount = account.getAccountInitBalance();
			bankInitAmount = account.getBankAccountInitBalance();
		}else{
			voucherInitAmount = lastVerificationRecord.getBankJval() -lastVerificationRecord.getBankDval();
			bankInitAmount = lastVerificationRecord.getBankJval() - lastVerificationRecord.getBankDval();
		}
		
		BrsBalanceFormula result = new BrsBalanceFormula();
		result.setVoucherBalance(voucherBalance.getVoucherBalance() + voucherInitAmount );
		result.setVoucherJval(CastUtil.toDouble(voucherBalance.getJval(), 0));
		result.setVoucherDval(CastUtil.toDouble(voucherBalance.getDval(),0));
		result.setBankBalance(bankBalance.getBankBalance() + bankInitAmount);
		result.setBankJval(CastUtil.toDouble(bankBalance.getJval(),0));
		result.setBankDval(CastUtil.toDouble(bankBalance.getDval(),0));
		
		//上次对账剩余未到账信息
		BrsStatementRecord lastStateRecord = getContext().getStatementRecordService().getLastRecord(buildStatementRecordQry(qryAccount));
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
		return result;
	}
	
	/** 查账当前账户的账户初始信息*/
	protected BrsAccount getBrsAccount(BrsAccount qryObj){
		BrsAccount result = new BrsAccount();
		if(qryObj.getAccountNo() != null && !qryObj.getAccountNo().equals("")){
			BrsAccount accountQryObj = new BrsAccount();
			accountQryObj.setAccountNo(qryObj.getAccountNo());
			accountQryObj.setSubjectNo(qryObj.getSubjectNo());
			result = getContext().getAccountService().getAccount(accountQryObj);
		}
		return result;
	}
	
	/** 构建对账记录查询对象*/
	protected BrsStatementRecord buildStatementRecordQry(BrsAccount qryAccount){
		BrsStatementRecord result = new BrsStatementRecord();
		result.setAccountNo(qryAccount.getSubjectNo());
		result.setSubjectNo(qryAccount.getAccountNo());
		return result;
	}
	
	/** 构建查询条件*/
	private CheckAccountQry buildQry(BrsAccount account){
		CheckAccountQry qryObj = new CheckAccountQry();
		//查询末次对账日作为默认endDate, 查询末次核销日作为startDate
		qryObj.setStartDate(this.lastVerificationDate);
		qryObj.setEndDate(this.lastRecordDate);
		qryObj.setSubjectNo(account.getSubjectNo());
		qryObj.setAccountNo(account.getAccountNo());
		return qryObj;
	}
	
	protected List<BrsAccount> qryAccounts(BrsAccount accountQry){
		//拿到科目列表 开始循环查询结果
		List<BrsAccount> accountList = getContext().getAccountService().getAccounts(accountQry);
	
		if(!accountQry.getStartAccountNo().equals("")){
			return accountList;
		}else{
			/**没填开始账号的时候  每个科目增加一个从总账系统的查询*/
			List<BrsAccount> subResult = new ArrayList<BrsAccount>();
			String lastSubjectNo = "";
			for (BrsAccount account : accountList) {
				//如果到了下一个科目
				if(!lastSubjectNo.equals(account.getSubjectNo())){
					subResult.add(new BrsAccount(account.getSubjectNo(),null));
					lastSubjectNo = account.getSubjectNo();
				}
				subResult.add(account);
			}
			
			return subResult;
		}
	}

	public Map<String, String> getBrs_qryBatchBankRec_top() {
		return brs_qryBatchBankRec_top;
	}

	public void setBrs_qryBatchBankRec_top(
			Map<String, String> brs_qryBatchBankRec_top) {
		this.brs_qryBatchBankRec_top = brs_qryBatchBankRec_top;
	}
}

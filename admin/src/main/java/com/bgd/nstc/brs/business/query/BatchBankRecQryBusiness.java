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
 * @Title ���������ڱ���ܲ�ѯ
 * @Description: 
 * @author ZCL
 * @date 2014-9-1 ����04:06:18
 */
public class BatchBankRecQryBusiness extends BatchBankRecMainBusiness{
	private Map<String,String> brs_qryBatchBankRec_top;
	//ĩ�ζ�����
	private Date lastRecordDate;
	//ĩ�κ�����
	private Date lastVerificationDate;

	@Override
	public void doExecute() throws Exception {
		putCommonResult();
		BrsAccount accountQry = BeanHelper.populate(BrsAccount.class, brs_qryBatchBankRec_top);
		
		//�õ���Ŀ�б� ��ʼѭ����ѯ���
		List<BrsAccount> accountList = qryAccounts(accountQry);
		List<StatementRecordView> srList = getStatementRecordViews(accountList);
		putResult(R.SP.QRYBATCHBANKREC_LIST, BeanHelper.describe(srList));
		putResult("brs_qryBatchBankRec_top", brs_qryBatchBankRec_top);
	}
	
	/** ������ϸ�б� */
	protected List<StatementRecordView> getStatementRecordViews(List<BrsAccount> accounts) {
		List<StatementRecordView> result = new ArrayList<StatementRecordView>();
		for (BrsAccount account : accounts) {
			//ĩ�ζ����� ĩ�κ�����  ��ѯĩ�ζ�������ΪĬ��endDate, ��ѯĩ�κ�������ΪstartDate
			BrsStatementRecord srQry = new BrsStatementRecord(account.getSubjectNo(),account.getAccountNo());
			this.lastRecordDate = lastRecordDate(srQry);
			this.lastVerificationDate = lastVerificationDate(srQry);
			
			CheckAccountQry qry = buildQry(account);
			//��ҵ�����Ϣ
			BrsBalanceFormula voucherBalance = getContext().getCheckAccountService().getVoucherBalance(qry);
			//���������Ϣ
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
	* @Description: ��ƽ�˹�ʽ�������
	* 		���ϵͳ��δ�����������ʼ��δ���˽��������˻���Ϣ�ļ�¼�в���
	  		���ϵͳ��������һ�κ�����������һ�κ�����¼��ȥ��ʼ��
	* @author ZCL
	* @date 2014-8-28 ����11:50:27
	 */
	public BrsBalanceFormula subBalanceFormula(BrsBalanceFormula voucherBalance,BrsBalanceFormula bankBalance,BrsAccount qryAccount){
		Double voucherInitAmount = 0d;
		Double bankInitAmount = 0d;
		//��ʼ����Ϣ
		BrsAccount account = getBrsAccount(qryAccount);
		//ĩ�κ�����¼
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
		
		//�ϴζ���ʣ��δ������Ϣ
		BrsStatementRecord lastStateRecord = getContext().getStatementRecordService().getLastRecord(buildStatementRecordQry(qryAccount));
		lastStateRecord = lastStateRecord == null ? new BrsStatementRecord() : lastStateRecord;
		/**
		 * ��ʽ :
		 * 
		 *  ��ҵ��� + ��ʼ��ǰ��ҵδ���� + (����������ҵδ�� - �����Ѹ���ҵδ��) 
		 *  =
		 *  ������� + ��ʼ��Ǯ����δ����  + (��ҵ��������δ�� - ��ҵ�Ѹ�����δ��) 
		 *  
		 *  XX����(��)XXδ��(��) = ����XX����(��)XXδ��(��) + ��ʷδ����
		 */
		Double vBalance =
			result.getVoucherBalance() + 
			//�տ�� +��ʷδ����
			((result.getBankJval() -lastStateRecord.getBankJval()) - (result.getBankDval() - lastStateRecord.getBankDval()));
		Double bBalance = 
			result.getBankBalance() + 
			((result.getVoucherJval() -lastStateRecord.getVoucherJval()) - (result.getVoucherDval() - lastStateRecord.getVoucherDval()));
		result.setVoucherFormulaBalance(vBalance);
		result.setBankFormulaBalance(bBalance);
		return result;
	}
	
	/** ���˵�ǰ�˻����˻���ʼ��Ϣ*/
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
	
	/** �������˼�¼��ѯ����*/
	protected BrsStatementRecord buildStatementRecordQry(BrsAccount qryAccount){
		BrsStatementRecord result = new BrsStatementRecord();
		result.setAccountNo(qryAccount.getSubjectNo());
		result.setSubjectNo(qryAccount.getAccountNo());
		return result;
	}
	
	/** ������ѯ����*/
	private CheckAccountQry buildQry(BrsAccount account){
		CheckAccountQry qryObj = new CheckAccountQry();
		//��ѯĩ�ζ�������ΪĬ��endDate, ��ѯĩ�κ�������ΪstartDate
		qryObj.setStartDate(this.lastVerificationDate);
		qryObj.setEndDate(this.lastRecordDate);
		qryObj.setSubjectNo(account.getSubjectNo());
		qryObj.setAccountNo(account.getAccountNo());
		return qryObj;
	}
	
	protected List<BrsAccount> qryAccounts(BrsAccount accountQry){
		//�õ���Ŀ�б� ��ʼѭ����ѯ���
		List<BrsAccount> accountList = getContext().getAccountService().getAccounts(accountQry);
	
		if(!accountQry.getStartAccountNo().equals("")){
			return accountList;
		}else{
			/**û�ʼ�˺ŵ�ʱ��  ÿ����Ŀ����һ��������ϵͳ�Ĳ�ѯ*/
			List<BrsAccount> subResult = new ArrayList<BrsAccount>();
			String lastSubjectNo = "";
			for (BrsAccount account : accountList) {
				//���������һ����Ŀ
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

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
 * @Title ��ѯ���������ڱ�
 * @Description: 
 * @author ZCL
 * @date 2014-8-29 ����02:40:16
 */
public class BankReconciliationQryBusiness extends BankReconciliationMainBusiness{
	private static final SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	@Override
	public void doExecute() throws Exception {
		//add by fankebo for ZTCW-987 start 20170316
		//������ҵ���������˲�ѯ����ʼ����
		String starDate = getContext().getCheckAccountService().getbrsStartDate();
		if(starDate==null || "".equals(starDate)){
			this.set_ErrorMessage("����ȫ��ҵ�����������BRS.STARTDATE������ֵ,��ֵ����Ϊ�գ�");
			return ;
		}
	    if(!isValidDate(starDate)){
	    	this.set_ErrorMessage("����ȫ��ҵ������а�����ȷ���ڸ�ʽ����,BRS.STARTDATE������ֵ��");
		    return ;
	    }
		putResult(R.SP.QRYBANKREC_TOP, getBrs_qryBankReconciliation_top());
		putResult(R.SP.QRYBANKREC_DATA,BeanHelper.describe(getBalanceFormula()));
		CheckAccountQry jqry = buildQry(DirFlag.DEBIT.getValue());
		CheckAccountQry dqry = buildQry(DirFlag.CREDIT.getValue());
	    jqry.setStartDate(sdf.parse(starDate));
		dqry.setStartDate(sdf.parse(starDate));
		//add by fankebo for ZTCW-987 end 20170316
		//��ҵ���������δ����
		List<BrsVoucher> voucherJList = getContext().getCheckAccountService().getVoucher(jqry);
		//��ҵ֧��������δ����
		List<BrsVoucher> voucherDList = getContext().getCheckAccountService().getVoucher(dqry);
		//�����������ҵδ����
		List<BrsBankRecord> bankJList = getContext().getCheckAccountService().getBankRecord(jqry);
		//����֧������ҵδ����
		List<BrsBankRecord> bankDList = getContext().getCheckAccountService().getBankRecord(dqry);
		putResult(R.SP.QRYBANKREC_VOUCHERJ, BeanHelper.describe(voucherJList));
		putResult(R.SP.QRYBANKREC_VOUCHERD, BeanHelper.describe(voucherDList));
		putResult(R.SP.QRYBANKREC_BANKJ, BeanHelper.describe(bankJList));
		putResult(R.SP.QRYBANKREC_BANKD, BeanHelper.describe(bankDList));
		
		putCommonResult();
	}
	
	/**
	 * 
	* @Description: ��Ͻ��
	* @author ZCL
	* @date 2014-8-26 ����01:13:33
	 */
	protected BrsBalanceFormula getBalanceFormula(){
		BrsBalanceFormula voucherBalance = getVoucherBalance();
		BrsBalanceFormula bankBalance = getBankBalance();
		BrsBalanceFormula result = subBalanceFormula(voucherBalance, bankBalance);
		//�ϴζ���ʣ��δ������Ϣ
		BrsStatementRecord lastStateRecord = getContext().getStatementRecordService().getLastRecord(buildStatementRecordQry());
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
	* @Description:������ҵ�����Ϣ
	* @author ZCL
	* @date 2014-8-26 ����10:59:31
	 */
	private BrsBalanceFormula getVoucherBalance(){
		//��ҵ�����Ϣ
		BrsBalanceFormula voucherBalance = getContext().getCheckAccountService().getVoucherBalance(buildQry(null));
		//��ҵ���ն�����δ��
		Double voucherJval = voucherBalance.getJval();
		//��ҵ�Ѹ�������δ��
		Double voucherDval = voucherBalance.getDval();
		
		voucherBalance.setVoucherJval(voucherJval);
		voucherBalance.setVoucherDval(voucherDval);
		return voucherBalance;
	}
	
	/**
	 * 
	* @Description:�������������Ϣ
	* @author ZCL
	* @date 2014-8-26 ����11:27:40
	 */
	private BrsBalanceFormula getBankBalance(){
		//���������Ϣ
		BrsBalanceFormula bankBalance = getContext().getCheckAccountService().getBankBalance(buildQry(null));
		//�����������ҵδ����
		Double bankJval = bankBalance.getJval();
		//����֧������ҵδ����
		Double bankDval = bankBalance.getDval();
		bankBalance.setBankJval(bankJval);
		bankBalance.setBankDval(bankDval);
		return bankBalance;
	}
	
	/**
	 * 
	* @Description: ��ƽ�˹�ʽ�������
	* 		���ϵͳ��δ�����������ʼ��δ���˽��������˻���Ϣ�ļ�¼�в���
	  		���ϵͳ��������һ�κ�����������һ�κ�����¼��ȥ��ʼ��
	* @author ZCL
	* @date 2014-8-28 ����11:50:27
	 */
	public BrsBalanceFormula subBalanceFormula(BrsBalanceFormula voucherBalance,BrsBalanceFormula bankBalance){
		Double voucherInitAmount = 0d;
		Double bankInitAmount = 0d;
		//��ʼ����Ϣ
		BrsAccount account = getBrsAccount();
		//ĩ�κ�����¼
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
	
	/** ���˵�ǰ�˻����˻���ʼ��Ϣ*/
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
	
	/** �������˼�¼��ѯ����*/
	protected BrsStatementRecord buildStatementRecordQry(){
		if(getBrs_qryBankReconciliation_top() == null)
			return null;
		BrsStatementRecord result = new BrsStatementRecord();
		result.setAccountNo(CastUtil.trimNull(getBrs_qryBankReconciliation_top().get("accountNo")));
		result.setSubjectNo(CastUtil.trimNull(getBrs_qryBankReconciliation_top().get("subjectNo")));
		return result;
	}
	
	/** ������ѯ����*/
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

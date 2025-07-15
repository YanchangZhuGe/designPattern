package com.nstc.brs.business.check;

import java.util.ArrayList;
import java.util.List;


import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.domain.BrsBalanceFormula;
import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.enums.DirFlag;
import com.nstc.brs.enums.IsOld;
import com.nstc.brs.handler.R;
import com.nstc.util.BeanHelper;
import com.nstc.util.MathExtend;
import com.nstc.util.TextFormat;

/**
 * 
 * @Title ƽ�˹�ʽ
 * @Description: 
 * @author ZCL
 * @date 2014-8-25 ����07:20:58
 */
public class CheckAccountBalanceBusiness extends CheckAccountMainBusiness{

	@Override
	public void doExecute() throws Exception {
		if(getBrs_checkAccount_voucher() == null || getBrs_checkAccount_bank() == null){
			return;
		}
		putResult(R.SP.CHECKACCOUNT_FORMULA, BeanHelper.describe(getBalanceFormula()));
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
		//20170412 ZTCW-1067 caoerwei ���˹�ʽ��ƽ ��Ʒ bug start
		/*Double vBalance =
			result.getVoucherBalance() + 
			//�տ�� +��ʷδ����
			((result.getBankJval() -lastStateRecord.getBankJval()) - (result.getBankDval() - lastStateRecord.getBankDval()));*/
		Double vBalance =
			result.getVoucherBalance() + 
			//�տ�� +��ʷδ����
			((result.getBankDval() - lastStateRecord.getBankDval()) - (result.getBankJval() - lastStateRecord.getBankJval()));
		//20170412 ZTCW-1067 caoerwei ���˹�ʽ��ƽ ��Ʒ bug end
		Double bBalance = 
			result.getBankBalance() + 
			((result.getVoucherJval() -lastStateRecord.getVoucherJval()) - (result.getVoucherDval() - lastStateRecord.getVoucherDval()));
	//ZTCW-1073 20170413 �������ϵͳ ƽ�˹�ʽ������Ҫ������λС���Ժ���бȽ� start
		//	 result.setVoucherFormulaBalance(vBalance);
		//result.setBankFormulaBalance(bBalance);
		result.setVoucherFormulaBalance(MathExtend.round(vBalance, 2));
		result.setBankFormulaBalance(MathExtend.round(bBalance, 2));
		//ZTCW-1073 20170413 �������ϵͳ ƽ�˹�ʽ������Ҫ������λС���Ժ���бȽ� end
		Boolean resultFlag = true;
		//if(vBalance.doubleValue() != bBalance.doubleValue()){ //ZTCW-1073 20170413 �������ϵͳ ƽ�˹�ʽ������Ҫ������λС���Ժ���бȽ� start
		if(MathExtend.subtract(result.getVoucherFormulaBalance(), result.getBankFormulaBalance()) != 0.0){
			resultFlag = false;
		}else{
			
		}
		result.setResultFlag(resultFlag);
		buildResultStr(result);
		return result;
	}
	//20170412 ZTCW-1067 caoerwei ���˹�ʽ��ƽ ��Ʒ bug start
	/*private void buildResultStr(BrsBalanceFormula bf){
		String resultStr = TextFormat.formatNumber(bf.getVoucherBalance()) + "+(" + TextFormat.formatNumber(bf.getBankJval()) + "" +
				" - " + TextFormat.formatNumber(bf.getBankDval()) + "" +
				")  = " +TextFormat.formatNumber(bf.getVoucherFormulaBalance());
		if(bf.getResultFlag()){
			resultStr += "<br/><span style='color:green'>����</span><br/>";
		}else{
			resultStr += "<br/><span style='color:red'>������</span><br/>";
		}
		resultStr += TextFormat.formatNumber(bf.getBankBalance()) + "+(" + TextFormat.formatNumber(bf.getVoucherJval()) + "" +
				" - " + TextFormat.formatNumber(bf.getVoucherDval()) + "" +
		") = " +TextFormat.formatNumber(bf.getBankFormulaBalance());
		resultStr += "</br>��ֵ</br>" + TextFormat.formatNumber(bf.getVoucherFormulaBalance() - bf.getBankFormulaBalance());
		bf.setResult(resultStr);
		
	}*/
	
	private void buildResultStr(BrsBalanceFormula bf){
		String resultStr = TextFormat.formatNumber(bf.getVoucherBalance()) + "+(" + TextFormat.formatNumber(bf.getBankDval()) + "" +
				" - " + TextFormat.formatNumber(bf.getBankJval()) + "" +
				")  = " +TextFormat.formatNumber(bf.getVoucherFormulaBalance());
		if(bf.getResultFlag()){
			resultStr += "<br/><span style='color:green'>����</span><br/>";
		}else{
			resultStr += "<br/><span style='color:red'>������</span><br/>";
		}
		resultStr += TextFormat.formatNumber(bf.getBankBalance()) + "+(" + TextFormat.formatNumber(bf.getVoucherJval()) + "" +
				" - " + TextFormat.formatNumber(bf.getVoucherDval()) + "" +
		") = " +TextFormat.formatNumber(bf.getBankFormulaBalance());
		resultStr += "</br>��ֵ</br>" + TextFormat.formatNumber(bf.getVoucherFormulaBalance() - bf.getBankFormulaBalance());
		bf.setResult(resultStr);
		
	}
	//20170412 ZTCW-1067 caoerwei ���˹�ʽ��ƽ ��Ʒ bug end
	/**
	 * 
	* @Description:������ҵ�����Ϣ
	* @author ZCL
	* @date 2014-8-26 ����10:59:31
	 */
	private BrsBalanceFormula getVoucherBalance(){
		List<BrsVoucher> voucherList = new ArrayList<BrsVoucher>();
		if(getBrs_checkAccount_voucher().size() != 0){
			voucherList =BeanHelper.populate(BrsVoucher.class, getGridSelectedRow(getBrs_checkAccount_voucher()));
		}
		Double checkedJval = 0d,checkedDval = 0d;
		for (BrsVoucher voucher : voucherList) {
			//�����δ�� ����
			if(voucher.getIsOld().intValue() == IsOld.NO.getIntValue()){
				continue;
			}
			if(DirFlag.DEBIT.getValue().intValue() == voucher.getDcFlag().intValue()){
				checkedJval += voucher.getAmount();
			}else{
				checkedDval += voucher.getAmount();
			}
		}
		//��ҵ�����Ϣ
		BrsBalanceFormula voucherBalance = getContext().getCheckAccountService().getVoucherBalance(buildQry());
		//��ҵ���ն�����δ��
		Double voucherJval = voucherBalance.getJval() - checkedJval;
		//��ҵ�Ѹ�������δ��
		Double voucherDval = voucherBalance.getDval() - checkedDval;
		
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
		List<BrsBankRecord> bankList = new ArrayList<BrsBankRecord>();
		if(getBrs_checkAccount_bank().size() != 0){
			bankList =BeanHelper.populate(BrsBankRecord.class, getGridSelectedRow(getBrs_checkAccount_bank()));
		}
		Double checkedJval = 0d,checkedDval = 0d;
		for (BrsBankRecord bankRecord : bankList) {
			//�����δ�� ����
			if(bankRecord.getIsOld().intValue() == IsOld.NO.getIntValue()){
				continue;
			}
			if(DirFlag.DEBIT.getValue().intValue() == bankRecord.getDcFlag().intValue()){
				checkedJval += bankRecord.getAmount();
			}else{
				checkedDval += bankRecord.getAmount();
			}
		}
		//���������Ϣ
		BrsBalanceFormula bankBalance = getContext().getCheckAccountService().getBankBalance(buildQry());
		//�������ն���ҵδ��
		Double bankJval = bankBalance.getJval() - checkedJval;
		//�����Ѹ�����ҵδ��
		Double bankDval = bankBalance.getDval() - checkedDval;
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
	

}

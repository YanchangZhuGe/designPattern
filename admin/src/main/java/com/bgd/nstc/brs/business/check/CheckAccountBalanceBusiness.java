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
 * @Title 平账公式
 * @Description: 
 * @author ZCL
 * @date 2014-8-25 下午07:20:58
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
		//20170412 ZTCW-1067 caoerwei 对账公式不平 产品 bug start
		/*Double vBalance =
			result.getVoucherBalance() + 
			//收款付款 +历史未到账
			((result.getBankJval() -lastStateRecord.getBankJval()) - (result.getBankDval() - lastStateRecord.getBankDval()));*/
		Double vBalance =
			result.getVoucherBalance() + 
			//收款付款 +历史未到账
			((result.getBankDval() - lastStateRecord.getBankDval()) - (result.getBankJval() - lastStateRecord.getBankJval()));
		//20170412 ZTCW-1067 caoerwei 对账公式不平 产品 bug end
		Double bBalance = 
			result.getBankBalance() + 
			((result.getVoucherJval() -lastStateRecord.getVoucherJval()) - (result.getVoucherDval() - lastStateRecord.getVoucherDval()));
	//ZTCW-1073 20170413 银企对账系统 平账公式计算需要保留两位小数以后进行比较 start
		//	 result.setVoucherFormulaBalance(vBalance);
		//result.setBankFormulaBalance(bBalance);
		result.setVoucherFormulaBalance(MathExtend.round(vBalance, 2));
		result.setBankFormulaBalance(MathExtend.round(bBalance, 2));
		//ZTCW-1073 20170413 银企对账系统 平账公式计算需要保留两位小数以后进行比较 end
		Boolean resultFlag = true;
		//if(vBalance.doubleValue() != bBalance.doubleValue()){ //ZTCW-1073 20170413 银企对账系统 平账公式计算需要保留两位小数以后进行比较 start
		if(MathExtend.subtract(result.getVoucherFormulaBalance(), result.getBankFormulaBalance()) != 0.0){
			resultFlag = false;
		}else{
			
		}
		result.setResultFlag(resultFlag);
		buildResultStr(result);
		return result;
	}
	//20170412 ZTCW-1067 caoerwei 对账公式不平 产品 bug start
	/*private void buildResultStr(BrsBalanceFormula bf){
		String resultStr = TextFormat.formatNumber(bf.getVoucherBalance()) + "+(" + TextFormat.formatNumber(bf.getBankJval()) + "" +
				" - " + TextFormat.formatNumber(bf.getBankDval()) + "" +
				")  = " +TextFormat.formatNumber(bf.getVoucherFormulaBalance());
		if(bf.getResultFlag()){
			resultStr += "<br/><span style='color:green'>等于</span><br/>";
		}else{
			resultStr += "<br/><span style='color:red'>不等于</span><br/>";
		}
		resultStr += TextFormat.formatNumber(bf.getBankBalance()) + "+(" + TextFormat.formatNumber(bf.getVoucherJval()) + "" +
				" - " + TextFormat.formatNumber(bf.getVoucherDval()) + "" +
		") = " +TextFormat.formatNumber(bf.getBankFormulaBalance());
		resultStr += "</br>差值</br>" + TextFormat.formatNumber(bf.getVoucherFormulaBalance() - bf.getBankFormulaBalance());
		bf.setResult(resultStr);
		
	}*/
	
	private void buildResultStr(BrsBalanceFormula bf){
		String resultStr = TextFormat.formatNumber(bf.getVoucherBalance()) + "+(" + TextFormat.formatNumber(bf.getBankDval()) + "" +
				" - " + TextFormat.formatNumber(bf.getBankJval()) + "" +
				")  = " +TextFormat.formatNumber(bf.getVoucherFormulaBalance());
		if(bf.getResultFlag()){
			resultStr += "<br/><span style='color:green'>等于</span><br/>";
		}else{
			resultStr += "<br/><span style='color:red'>不等于</span><br/>";
		}
		resultStr += TextFormat.formatNumber(bf.getBankBalance()) + "+(" + TextFormat.formatNumber(bf.getVoucherJval()) + "" +
				" - " + TextFormat.formatNumber(bf.getVoucherDval()) + "" +
		") = " +TextFormat.formatNumber(bf.getBankFormulaBalance());
		resultStr += "</br>差值</br>" + TextFormat.formatNumber(bf.getVoucherFormulaBalance() - bf.getBankFormulaBalance());
		bf.setResult(resultStr);
		
	}
	//20170412 ZTCW-1067 caoerwei 对账公式不平 产品 bug end
	/**
	 * 
	* @Description:计算企业余额信息
	* @author ZCL
	* @date 2014-8-26 上午10:59:31
	 */
	private BrsBalanceFormula getVoucherBalance(){
		List<BrsVoucher> voucherList = new ArrayList<BrsVoucher>();
		if(getBrs_checkAccount_voucher().size() != 0){
			voucherList =BeanHelper.populate(BrsVoucher.class, getGridSelectedRow(getBrs_checkAccount_voucher()));
		}
		Double checkedJval = 0d,checkedDval = 0d;
		for (BrsVoucher voucher : voucherList) {
			//如果是未达 忽略
			if(voucher.getIsOld().intValue() == IsOld.NO.getIntValue()){
				continue;
			}
			if(DirFlag.DEBIT.getValue().intValue() == voucher.getDcFlag().intValue()){
				checkedJval += voucher.getAmount();
			}else{
				checkedDval += voucher.getAmount();
			}
		}
		//企业余额信息
		BrsBalanceFormula voucherBalance = getContext().getCheckAccountService().getVoucherBalance(buildQry());
		//企业已收而银行未收
		Double voucherJval = voucherBalance.getJval() - checkedJval;
		//企业已付而银行未付
		Double voucherDval = voucherBalance.getDval() - checkedDval;
		
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
		List<BrsBankRecord> bankList = new ArrayList<BrsBankRecord>();
		if(getBrs_checkAccount_bank().size() != 0){
			bankList =BeanHelper.populate(BrsBankRecord.class, getGridSelectedRow(getBrs_checkAccount_bank()));
		}
		Double checkedJval = 0d,checkedDval = 0d;
		for (BrsBankRecord bankRecord : bankList) {
			//如果是未达 忽略
			if(bankRecord.getIsOld().intValue() == IsOld.NO.getIntValue()){
				continue;
			}
			if(DirFlag.DEBIT.getValue().intValue() == bankRecord.getDcFlag().intValue()){
				checkedJval += bankRecord.getAmount();
			}else{
				checkedDval += bankRecord.getAmount();
			}
		}
		//银行余额信息
		BrsBalanceFormula bankBalance = getContext().getCheckAccountService().getBankBalance(buildQry());
		//银行已收而企业未收
		Double bankJval = bankBalance.getJval() - checkedJval;
		//银行已付而企业未付
		Double bankDval = bankBalance.getDval() - checkedDval;
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
	

}

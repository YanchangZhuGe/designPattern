package com.nstc.brs.business.print;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.query.BankReconciliationQryBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.domain.BrsBalanceFormula;
import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.enums.DirFlag;
import com.nstc.brs.model.BankRecPrintView;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.model.ReportDataHolder;
import com.nstc.brs.handler.pdf.PdfReportHandler;
import com.nstc.brs.model.MainReportDataHolder;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 银行余额调节表打印
 * @Description: 
 * @author ZCL
 * @date 2014-9-11 上午11:13:11
 */
public class PrintBankRecBusiness extends BankReconciliationQryBusiness{
	BrsBalanceFormula formula = null;
	@Override
	public void doExecute() throws Exception {
		CheckAccountQry jqry = buildQry(DirFlag.DEBIT.getValue());
		CheckAccountQry dqry = buildQry(DirFlag.CREDIT.getValue());
		formula = getBalanceFormula();
		List<ReportDataHolder> dataHolders=new ArrayList<ReportDataHolder>();
		//借
		dataHolders.add(buildAddAmountHolder(jqry));
		//贷
		dataHolders.add(buildSubtractAmountHolder(dqry));
		
		MainReportDataHolder mainReportDataHolder=new MainReportDataHolder();
		mainReportDataHolder.setSubReportDataHolderList(dataHolders);
		//mainReportDataHolder.setParameter(buildRootPara());
		mainReportDataHolder.setMainReportName("BankReconciliation");
		byte[]data=PdfReportHandler.makePdfReport(mainReportDataHolder);
		putResult("_data", data);
	}
	
	private Map<String,Object> buildRootPara(){
		Map<String,Object> paraMap = new HashMap<String,Object>();
		BrsAccount account = getAccount();
		paraMap.put("bank",account.getBankNo());
		paraMap.put("bankAccountNo", account.getBankAccountNo());
		
		return paraMap;
	}
	
	
	/** 构建金额增加的列表*/
	private ReportDataHolder buildAddAmountHolder(CheckAccountQry qry){
		List<BankRecPrintView> list = buildViewList(qry);
		Map<String,Object> paraMap = new HashMap<String,Object>();
		paraMap.put("voucherBalance", formula.getVoucherBalance());
		paraMap.put("bankBalance", formula.getBankBalance());
		paraMap.put("subjectNo", qry.getSubjectNo());
		paraMap.put("accountNo", qry.getAccountNo());
		ReportDataHolder dataHolder=new ReportDataHolder();
		dataHolder.setReportName("BrsBankRecTop");
		dataHolder.setParameter(paraMap);
		dataHolder.setCollection(BeanHelper.describe(list));
		
		return dataHolder;
	}
	
	/** 构建金额减少的列表 */
	private ReportDataHolder buildSubtractAmountHolder(CheckAccountQry qry){
		List<BankRecPrintView> list = buildViewList(qry);
		Map<String,Object> paraMap = new HashMap<String,Object>();
		paraMap.put("voucherFormulaBalance",formula.getVoucherFormulaBalance());
		paraMap.put("bankFormulaBalance", formula.getBankFormulaBalance());
		ReportDataHolder dataHolder=new ReportDataHolder();
		dataHolder.setReportName("BrsBankRecBottom");
		dataHolder.setParameter(paraMap);
		dataHolder.setCollection(BeanHelper.describe(list));
		return dataHolder;
	}
	
	
	private List<BankRecPrintView> buildViewList(CheckAccountQry qry){
		List<BankRecPrintView> result = new ArrayList<BankRecPrintView>();
		//企业收入而银行未记账
		List<BrsVoucher> voucherList = getContext().getCheckAccountService().getVoucher(qry);
		//银行收入而企业未记账
		List<BrsBankRecord> bankList = getContext().getCheckAccountService().getBankRecord(qry);
		int v = voucherList.size();
		int b = bankList.size();
		int size = v > b ? v : b;
		for (int i = 0; i < size; i++) {
			BrsVoucher voucher = null;
			BrsBankRecord bank = null;
			BankRecPrintView view = new BankRecPrintView();
			if(i < v){
				voucher = voucherList.get(i);
				view.setAmountL(voucher.getAmount());
				view.setDateL(voucher.getBookDate());
				view.setSummaryL(voucher.getSummary());
			}
			if(i < b){
				bank = bankList.get(i);
				view.setAmountR(bank.getAmount());
				view.setDateR(bank.getRecordDate());
				view.setSummaryR(bank.getSummary());
			}
			result.add(view);
		}
		return result;
	}
	
	/** 得到账户信息*/
	private BrsAccount getAccount(){
		BrsAccount accountQry = BeanHelper.populate(BrsAccount.class, getBrs_qryBankReconciliation_top());
		if(accountQry.getAccountNo() == null || "".equals(accountQry.getAccountNo())){
			return accountQry;
		}else{
			return getContext().getAccountService().getAccount(accountQry);
		}
	}

}

package com.nstc.brs.business.check;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;


import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.enums.MatchMethod;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.model.CheckRule;
import com.nstc.brs.util.CheckResultComparator;
import com.nstc.brs.util.DateUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 执行对账 
 * @Description: 
 * @author ZCL
 * @date 2014-8-22 下午03:26:54
 */
public class CheckAccountCheckBusiness extends CheckAccountResultBusiness {
	
	private Map<String,String> brs_checkAccount_ruleHidden;
	
	@Override
	public void doExecute() throws Exception {
		putCommonResult();
		CheckAccountQry qry = buildQry();
		Date startDate = getInitDate(buildStatementRecordQry());
		//ZTCW-1123 20170609 add by caoerwei 对账的起始日期可人工选择，方便核对某一天的明细 start 
		Date startDateNew = getStartDate();
		if(startDateNew != null){
			startDate=startDateNew;
	    }
	//ZTCW-1123 20170609 add by caoerwei 对账的起始日期可人工选择，方便核对某一天的明细 end
		qry.setStartDate(startDate);
		String subjectNo = qry.getSubjectNo();
		String accountNo = qry.getAccountNo();
		//add by fankebo for ZTCW-1123 start 20170628 当对账处理筛选条件科目号和账号默认为空时，即查询BRS_ACCOUNT中所有科目号
		if("".equals(subjectNo) && ("".equals(accountNo))){//flag 不为空时，查询所有科目号，flag=2时，日期使用between区间查询
			qry.setFlag("1"); //设置查询标识
		}
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		if(qry.getStartDate()!=null && qry.getEndDate()!=null ){
			qry.setStartDateStr(sdf.format(qry.getStartDate()));
			qry.setEndDateStr(sdf.format(qry.getEndDate()));
			qry.setFlag("2");//设置日期查询标识
		}
		//add by fankebo for ZTCW-1123 end 20170628
		//企业账单
		List<BrsVoucher> voucherList = getContext().getCheckAccountService().getVoucher(qry);
		//银行账单
		List<BrsBankRecord> bankRecordList = getContext().getCheckAccountService().getBankRecord(qry);
		//进行匹配
		doCheck(voucherList, bankRecordList);
		//然后排序，已经匹配成功的排在前面
		CheckResultComparator comparator = new CheckResultComparator();
		Collections.sort(voucherList, comparator);
		Collections.sort(bankRecordList, comparator);
		
		putResult(R.SP.CHECKACCOUNT_VOUCHER, BeanHelper.describe(voucherList));
		putResult(R.SP.CHECKACCOUNT_BANK, BeanHelper.describe(bankRecordList));
		getBrs_checkAccount_top().put("startDate", DateUtil.fmtDateToYMD(startDate));
		//刷新方式： 对账  此处为了分页时使用
		getBrs_checkAccount_top().put("refreshType","check");
		putResult("brs_checkAccount_top", getBrs_checkAccount_top());
		putResult("brs_checkAccount_ruleHidden", brs_checkAccount_ruleHidden);
	}
	
	/**
	 * 
	* @Description:根据条件执行对账
	* @author ZCL
	* @date 2014-8-22 下午03:30:15
	 */
	private void doCheck(List<BrsVoucher> voucherList, List<BrsBankRecord> bankRecordList){
		CheckRule rule = BeanHelper.populate(CheckRule.class, brs_checkAccount_ruleHidden);
		for (BrsVoucher brsVoucher : voucherList) {
			for (BrsBankRecord record : bankRecordList) {
				if(record.getCheckedData() != null && record.getCheckedData().equals("true")){
					continue;
				}
				if(isSameAccount(brsVoucher, record, rule)){
					brsVoucher.setOpAccountName(record.getAccountName());
					brsVoucher.setCheckedData("true");
					brsVoucher.setMatchMethod(MatchMethod.AUTO.getKey());
					record.setCheckedData("true");
					record.setMatchMethod(MatchMethod.AUTO.getKey());
					break;
				}
			}
		}
	}
	
	/**
	 * 
	* @Description: 判断两笔账是否相同
	* @author ZCL
	* @date 2014-8-22 下午03:47:11
	 */
	private boolean isSameAccount(BrsVoucher brsVoucher,BrsBankRecord record,CheckRule rule){
		//金额匹配
		if(brsVoucher.getAmount().doubleValue() != record.getAmount().doubleValue())
			return false;
		//20170412 ZTCW-1067 caoerwei 对账公式不平 产品 bug start
		//收支方向,银行账 1：支出，2：收入 ,企业账 ：1：借(收入),2:贷(支出)
		if(brsVoucher.getDcFlag().equals(record.getDcFlag())){
			return false;
		}
		//20170412 ZTCW-1067 caoerwei 对账公式不平 产品 bug end
		//日期匹配
		if(rule.getDateFlag() && !dateIsMatched(brsVoucher,record,rule.getDateRange()))
			return false;
		//摘要匹配 
		if(rule.getSummaryFlag() &&!summaryIsMatched(brsVoucher, record))
			return false;
		//对账标识匹配
		if(rule.getCheckAccountFlag() &&!checkDirMatched(brsVoucher, record))
			return  false;
		return true;
	}
	
	
	
	/** 两笔账时间是否匹配*/
	private boolean dateIsMatched(BrsVoucher brsVoucher,BrsBankRecord record,Integer days){
		if(days == null)
			days = 0;
		Date vdate = brsVoucher.getBookDate();
		Date rdate = record.getRecordDate();
		int difference = DateUtil.getDaysInterval(vdate,rdate);
		if(Math.abs(difference) > days){
			return false;
		}
		return true;
	}
	/** 摘要是否匹配 */
	private boolean summaryIsMatched(BrsVoucher brsVoucher,BrsBankRecord record){
		boolean flag = false;
		String vsummary = brsVoucher.getSummary();
		String rsummary = record.getSummary();
		//都为空 则匹配
		if((vsummary == null || vsummary.equals("")) && (rsummary == null || rsummary.equals(""))){
			flag = true;
		//值相同 匹配
		}else if(vsummary != null && rsummary != null && vsummary.equals(rsummary)){
			flag = true;
		}
		return flag;
	}
	
	/** 对账标示是否相同 */
	private boolean checkDirMatched(BrsVoucher brsVoucher,BrsBankRecord record){
		boolean flag = false;
		Integer vTxId = brsVoucher.getSettleTxId();
		Integer rTxId = record.getSettleTxId();
		//都为空 则匹配
		if(vTxId == null && rTxId == null){
			flag = true;
		//值相同 匹配
		}else if(vTxId != null && rTxId != null && vTxId.intValue() == rTxId.intValue()){
			flag = true;
		}
		return flag;
	}

	public Map<String, String> getBrs_checkAccount_ruleHidden() {
		return brs_checkAccount_ruleHidden;
	}

	public void setBrs_checkAccount_ruleHidden(
			Map<String, String> brs_checkAccount_ruleHidden) {
		this.brs_checkAccount_ruleHidden = brs_checkAccount_ruleHidden;
	}
}

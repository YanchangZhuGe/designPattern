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
 * @Title ִ�ж��� 
 * @Description: 
 * @author ZCL
 * @date 2014-8-22 ����03:26:54
 */
public class CheckAccountCheckBusiness extends CheckAccountResultBusiness {
	
	private Map<String,String> brs_checkAccount_ruleHidden;
	
	@Override
	public void doExecute() throws Exception {
		putCommonResult();
		CheckAccountQry qry = buildQry();
		Date startDate = getInitDate(buildStatementRecordQry());
		//ZTCW-1123 20170609 add by caoerwei ���˵���ʼ���ڿ��˹�ѡ�񣬷���˶�ĳһ�����ϸ start 
		Date startDateNew = getStartDate();
		if(startDateNew != null){
			startDate=startDateNew;
	    }
	//ZTCW-1123 20170609 add by caoerwei ���˵���ʼ���ڿ��˹�ѡ�񣬷���˶�ĳһ�����ϸ end
		qry.setStartDate(startDate);
		String subjectNo = qry.getSubjectNo();
		String accountNo = qry.getAccountNo();
		//add by fankebo for ZTCW-1123 start 20170628 �����˴���ɸѡ������Ŀ�ź��˺�Ĭ��Ϊ��ʱ������ѯBRS_ACCOUNT�����п�Ŀ��
		if("".equals(subjectNo) && ("".equals(accountNo))){//flag ��Ϊ��ʱ����ѯ���п�Ŀ�ţ�flag=2ʱ������ʹ��between�����ѯ
			qry.setFlag("1"); //���ò�ѯ��ʶ
		}
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		if(qry.getStartDate()!=null && qry.getEndDate()!=null ){
			qry.setStartDateStr(sdf.format(qry.getStartDate()));
			qry.setEndDateStr(sdf.format(qry.getEndDate()));
			qry.setFlag("2");//�������ڲ�ѯ��ʶ
		}
		//add by fankebo for ZTCW-1123 end 20170628
		//��ҵ�˵�
		List<BrsVoucher> voucherList = getContext().getCheckAccountService().getVoucher(qry);
		//�����˵�
		List<BrsBankRecord> bankRecordList = getContext().getCheckAccountService().getBankRecord(qry);
		//����ƥ��
		doCheck(voucherList, bankRecordList);
		//Ȼ�������Ѿ�ƥ��ɹ�������ǰ��
		CheckResultComparator comparator = new CheckResultComparator();
		Collections.sort(voucherList, comparator);
		Collections.sort(bankRecordList, comparator);
		
		putResult(R.SP.CHECKACCOUNT_VOUCHER, BeanHelper.describe(voucherList));
		putResult(R.SP.CHECKACCOUNT_BANK, BeanHelper.describe(bankRecordList));
		getBrs_checkAccount_top().put("startDate", DateUtil.fmtDateToYMD(startDate));
		//ˢ�·�ʽ�� ����  �˴�Ϊ�˷�ҳʱʹ��
		getBrs_checkAccount_top().put("refreshType","check");
		putResult("brs_checkAccount_top", getBrs_checkAccount_top());
		putResult("brs_checkAccount_ruleHidden", brs_checkAccount_ruleHidden);
	}
	
	/**
	 * 
	* @Description:��������ִ�ж���
	* @author ZCL
	* @date 2014-8-22 ����03:30:15
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
	* @Description: �ж��������Ƿ���ͬ
	* @author ZCL
	* @date 2014-8-22 ����03:47:11
	 */
	private boolean isSameAccount(BrsVoucher brsVoucher,BrsBankRecord record,CheckRule rule){
		//���ƥ��
		if(brsVoucher.getAmount().doubleValue() != record.getAmount().doubleValue())
			return false;
		//20170412 ZTCW-1067 caoerwei ���˹�ʽ��ƽ ��Ʒ bug start
		//��֧����,������ 1��֧����2������ ,��ҵ�� ��1����(����),2:��(֧��)
		if(brsVoucher.getDcFlag().equals(record.getDcFlag())){
			return false;
		}
		//20170412 ZTCW-1067 caoerwei ���˹�ʽ��ƽ ��Ʒ bug end
		//����ƥ��
		if(rule.getDateFlag() && !dateIsMatched(brsVoucher,record,rule.getDateRange()))
			return false;
		//ժҪƥ�� 
		if(rule.getSummaryFlag() &&!summaryIsMatched(brsVoucher, record))
			return false;
		//���˱�ʶƥ��
		if(rule.getCheckAccountFlag() &&!checkDirMatched(brsVoucher, record))
			return  false;
		return true;
	}
	
	
	
	/** ������ʱ���Ƿ�ƥ��*/
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
	/** ժҪ�Ƿ�ƥ�� */
	private boolean summaryIsMatched(BrsVoucher brsVoucher,BrsBankRecord record){
		boolean flag = false;
		String vsummary = brsVoucher.getSummary();
		String rsummary = record.getSummary();
		//��Ϊ�� ��ƥ��
		if((vsummary == null || vsummary.equals("")) && (rsummary == null || rsummary.equals(""))){
			flag = true;
		//ֵ��ͬ ƥ��
		}else if(vsummary != null && rsummary != null && vsummary.equals(rsummary)){
			flag = true;
		}
		return flag;
	}
	
	/** ���˱�ʾ�Ƿ���ͬ */
	private boolean checkDirMatched(BrsVoucher brsVoucher,BrsBankRecord record){
		boolean flag = false;
		Integer vTxId = brsVoucher.getSettleTxId();
		Integer rTxId = record.getSettleTxId();
		//��Ϊ�� ��ƥ��
		if(vTxId == null && rTxId == null){
			flag = true;
		//ֵ��ͬ ƥ��
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

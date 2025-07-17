package com.nstc.brs.business.check;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

import com.nstc.brs.domain.BrsBalanceFormula;
import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.enums.CheckState;
import com.nstc.brs.enums.MatchMethod;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.model.CheckRule;
import com.nstc.brs.util.CheckResultComparator;
import com.nstc.brs.util.DateUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title ������˽��
 * @Description: 
 * @author ZCL
 * @date 2014-8-25 ����09:03:18
 */
public class SaveCheckResultBusiness extends CheckAccountBalanceBusiness {
	//add by fankebo for  ZTCW-748  start 20161214
	private Map<String,String> brs_checkAccount_ruleHidden;
    public Map<String, String> getBrs_checkAccount_ruleHidden() {
        return brs_checkAccount_ruleHidden;
    }

	public void setBrs_checkAccount_ruleHidden(Map<String, String> brs_checkAccount_ruleHidden) {
		this.brs_checkAccount_ruleHidden = brs_checkAccount_ruleHidden;
	}
	//add by fankebo for  ZTCW-748  end 20161214
	@Override
	public void doExecute() throws Exception {
		//modify by fankebo for  ZTCW-748  start 20161214
	   Date startDate = getInitDate(buildStatementRecordQry());
	   Date startDateNew = getStartDate();
       if(startDateNew != null)
           startDate = startDateNew;
	        getBrs_checkAccount_top().put("startDate", DateUtil.fmtDateToYMD(startDate));
		    
		    String saveFlag = getBrs_checkAccount_top().get("saveFlag");
		    
		    if(saveFlag != null && "1".equals(saveFlag)){
		        doExecute2();
		        return;
		    }
	   //modify by fankebo for  ZTCW-748  end 20161214
		BrsBalanceFormula formula = getBalanceFormula();
		if(!formula.getResultFlag()){
			set_ErrorMessage("������ƽ�˹�ʽ ����");
			putCommonResult();
			putResult(R.SP.CHECKACCOUNT_TOP, getBrs_checkAccount_top());
			putResult(R.SP.CHECKACCOUNT_RULEHIDDEN, getBrs_checkAccount_ruleHidden());
			setCheckData();
			return;
		}
		//ѡ�е���ҵ��
		List<BrsVoucher> voucherQryObjList = new ArrayList<BrsVoucher>();
		//ѡ�е�������
		List<BrsBankRecord> bankRecordQryObjList = new ArrayList<BrsBankRecord>();
		if(getBrs_checkAccount_voucher().size() > 0 ){
			voucherQryObjList = BeanHelper.populate(BrsVoucher.class, getGridSelectedRow(getBrs_checkAccount_voucher()));
		}
		if(getBrs_checkAccount_bank().size() > 0){
			bankRecordQryObjList = BeanHelper.populate(BrsBankRecord.class, getGridSelectedRow(getBrs_checkAccount_bank()));
		}
		//����˶���ҵ��������  ������δ���˵Ľ��
		 getContext().getCheckAccountService().saveChechedResult(
				voucherQryObjList, bankRecordQryObjList,buildStatementRecord(),formula);
		putResult(R.SP.CHECKACCOUNT_TOP, getBrs_checkAccount_top());
	}
    //add by fankebo for  ZTCW-748  start 20161214

	/**
     * @Description:��̨���˱���
     * @throws Exception
     * @author ��ϣ��
     * @since��2015-12-7 ����06:20:46
     */
    public void doExecute2() throws Exception {
        
        //----cxx ��ԭ�������߼�����
        Date startDate = getInitDate(buildStatementRecordQry());
        Date startDateNew = getStartDate();
        if(startDateNew != null)
            startDate = startDateNew;
        putCommonResult();
        CheckAccountQry qry = buildQry();
        qry.setStartDate(startDate);
        //��ҵ�˵�
        String subjectNo = qry.getSubjectNo();
		String accountNo = qry.getAccountNo();
		//add by fankebo for ZTCW-1123 start 20170628,�����˴���ɸѡ������Ŀ�ź��˺�Ĭ��Ϊ��ʱ������ѯBRS_ACCOUNT�����п�Ŀ��
        if("".equals(subjectNo) && ("".equals(accountNo))){
        	qry.setFlag("1"); //���ò�ѯ��ʶ
        }
    	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    	if(qry.getStartDate()!=null && qry.getEndDate()!=null ){
			qry.setStartDateStr(sdf.format(qry.getStartDate()));
			qry.setEndDateStr(sdf.format(qry.getEndDate()));
			qry.setFlag("2");
		}
        //add by fankebo for ZTCW-1123 end 20170628
        List<BrsVoucher> voucherList = getContext().getCheckAccountService().getVoucher(qry);
        //�����˵�
        List<BrsBankRecord> bankRecordList = getContext().getCheckAccountService().getBankRecord(qry);
        //����ƥ��
        doCheck(voucherList, bankRecordList);
        //Ȼ�������Ѿ�ƥ��ɹ�������ǰ��
        CheckResultComparator comparator = new CheckResultComparator();
        Collections.sort(voucherList, comparator);
        Collections.sort(bankRecordList, comparator);

        //----cxx ģ��brs_checkAccount_voucher��brs_checkAccount_bank
        List<Map<String, String>> brs_checkAccount_voucher = BeanHelper.describe(voucherList);
        List<Map<String, String>> brs_checkAccount_bank = BeanHelper.describe(bankRecordList);
        
        int autoCheckCntVch = 0;
        for(Map<String,String> map : brs_checkAccount_voucher){
            if("true".equals(map.get("checkedData"))){
                map.put("_selRowFlag", "true");
                autoCheckCntVch++;
            }
        }
        Assert.isTrue((autoCheckCntVch>0), "û�����Զ�ƥ�䵽����ҵ��");

        int autoCheckCntBank = 0;
        for(Map<String,String> map : brs_checkAccount_bank){
            if("true".equals(map.get("checkedData"))){
                map.put("_selRowFlag", "true");
                autoCheckCntBank++;
            }
        }
        Assert.isTrue((autoCheckCntBank>0), "û�����Զ�ƥ�䵽��������");
        
        setBrs_checkAccount_voucher(brs_checkAccount_voucher);
        setBrs_checkAccount_bank(brs_checkAccount_bank);
        //----cxx
        
        BrsBalanceFormula formula = getBalanceFormula();
       
        //ѡ�е���ҵ��
        List<BrsVoucher> voucherQryObjList = new ArrayList<BrsVoucher>();
        //ѡ�е�������
        List<BrsBankRecord> bankRecordQryObjList = new ArrayList<BrsBankRecord>();
        if (getBrs_checkAccount_voucher().size() > 0) {
            voucherQryObjList = BeanHelper.populate(BrsVoucher.class,
                    getGridSelectedRow(getBrs_checkAccount_voucher()));
        }
        if (getBrs_checkAccount_bank().size() > 0) {
            bankRecordQryObjList = BeanHelper.populate(BrsBankRecord.class,
                    getGridSelectedRow(getBrs_checkAccount_bank()));
        }
        //����˶���ҵ��������  ������δ���˵Ľ��
        getContext().getCheckAccountService().saveChechedResult(
                voucherQryObjList, bankRecordQryObjList,
                buildStatementRecord(), formula);
        
        List<Map<String, String>> vchRs = new ArrayList<Map<String,String>>();
        for(Map<String,String> map : brs_checkAccount_voucher){
            if(!"true".equals(map.get("checkedData"))){
            	vchRs.add(map);
            }
        }

        List<Map<String, String>> bankRs = new ArrayList<Map<String,String>>();
        for(Map<String,String> map : brs_checkAccount_bank){
            if(!"true".equals(map.get("checkedData"))){
            	bankRs.add(map);
            }
        }

        setBrs_checkAccount_voucher(vchRs);
        setBrs_checkAccount_bank(bankRs);
        
        putResult(R.SP.CHECKACCOUNT_TOP, getBrs_checkAccount_top());
        if (!formula.getResultFlag()) {
            set_ErrorMessage("������ƽ�˹�ʽ ����");
            putCommonResult();
            putResult(R.SP.CHECKACCOUNT_RULEHIDDEN,
                    getBrs_checkAccount_ruleHidden());
            setCheckData();
            return;
        }
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
                    brsVoucher.setMatchMethod(MatchMethod.AUTO.getKey());
                    brsVoucher.setCheckedData("true");
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
	private boolean isSameAccount(BrsVoucher brsVoucher, BrsBankRecord record,
			CheckRule rule) {
		// ���ƥ��
		if (brsVoucher.getAmount().doubleValue() != record.getAmount().doubleValue())
			return false;
		
		//��֧����,������ 1��֧����2������ ,��ҵ�� ��1����(����),2:��(֧��)
		if(brsVoucher.getDcFlag().equals(record.getDcFlag())){
			return false;
		}
		
		// ����ƥ��
		if (rule.getDateFlag() && !dateIsMatched(brsVoucher, record, rule.getDateRange()))
			return false;
		// ժҪƥ��
		/*if (rule.getSummaryFlag() && !summaryIsMatched(brsVoucher, record))
			return false;
		// ���˱�ʶƥ��
		if (rule.getCheckAccountFlag() && !checkDirMatched(brsVoucher, record))
			return false;*/
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
    //add by fankebo for  ZTCW-748  end 20161214
    /** ��ҳ����˼�¼���� */
	private void setCheckData(){
		CheckAccountQry qry = buildQry();
		//��ҵ�˵�
		List<BrsVoucher> voucherList = getContext().getCheckAccountService().getVoucher(qry);
		//�����˵�
		List<BrsBankRecord> bankRecordList = getContext().getCheckAccountService().getBankRecord(qry);
		
		//ҳ���ϱ�ѡ�е����� ����ҵ
		List<BrsVoucher> checkedVoucherList = getCheckedVoucherList();
		List<BrsBankRecord> checkedBankRecordList = getCheckedBankRecordList();
		for (BrsVoucher voucher : voucherList) {
			for (BrsVoucher checkedVoucher : checkedVoucherList) {
				if(voucher.getSourceId().equals(checkedVoucher.getSourceId())){
					voucher.setCheckedData("true");
					voucher.setMatchMethod(checkedVoucher.getMatchMethod());
				}
			}
		}
		for (BrsBankRecord record: bankRecordList) {
			for (BrsBankRecord checkedRecord : checkedBankRecordList) {
				if(record.getSourceId().equals(checkedRecord.getSourceId())){
					record.setCheckedData("true");
					record.setMatchMethod(checkedRecord.getMatchMethod());
				}
			}
		}
		
		putResult(R.SP.CHECKACCOUNT_VOUCHER, BeanHelper.describe(voucherList));
		putResult(R.SP.CHECKACCOUNT_BANK, BeanHelper.describe(bankRecordList));
	}
	
	/**
	 * 
	* @Description: �������˼�¼
	* @author ZCL
	* @date 2014-8-27 ����04:30:41
	 */
	private BrsStatementRecord buildStatementRecord(){
		BrsStatementRecord record = BeanHelper.populate(BrsStatementRecord.class, getBrs_checkAccount_top());
		record.setCheckState(CheckState.NOMAL.getValue());
		record.setCreateTime(new Date());
		record.setMatchTime(new Date());
		record.setLastUpdateTime(new Date());
		return record;
	}

}

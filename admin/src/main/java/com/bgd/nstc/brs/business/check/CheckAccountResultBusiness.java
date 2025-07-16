package com.nstc.brs.business.check;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.util.DateUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title ���˲�ѯ���
 * @Description: 
 * @author ZCL
 * @date 2014-8-21 ����01:34:21
 */
public class CheckAccountResultBusiness extends CheckAccountMainBusiness {
	
	
	@Override
	public void doExecute() throws Exception {
		Date startDate =getInitDate(buildStatementRecordQry());
		//ZTCW-1123 20170609 add by caoerwei ���˵���ʼ���ڿ��˹�ѡ�񣬷���˶�ĳһ�����ϸ start 
			Date startDateNew = getStartDate();
			if(startDateNew != null){
				startDate=startDateNew;
		    }
		//ZTCW-1123 20170609 add by caoerwei ���˵���ʼ���ڿ��˹�ѡ�񣬷���˶�ĳһ�����ϸ end
		putCommonResult();
		CheckAccountQry qry = buildQry();
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
		Long startTime1=System.currentTimeMillis();
		System.out.println("��ѯ��ʼʱ�䣺"+new Date(startTime1));
		List<BrsVoucher> voucherList = getContext().getCheckAccountService().getVoucher(qry);
		Long startTime2=System.currentTimeMillis();
		
		System.out.println("��ҵ�˲�ѯ����ʱ�䣺"+(startTime2-startTime1)/1000+"��");
		System.out.println("��ѯ�����˿�ʼʱ�䣺"+new Date(startTime2));
		//�����˵�
		List<BrsBankRecord> bankRecordList = getContext().getCheckAccountService().getBankRecord(qry);
		Long startTime3=System.currentTimeMillis();
		System.out.println("��ѯ����ʱ�䣺"+new Date(startTime3));
		System.out.println("�����˲�ѯ����ʱ�䣺"+(startTime3-startTime2)/1000+"��");
		System.out.println("���˲�ѯ������ʱ�䣺"+(startTime3-startTime1)/1000+"��");
		putResult(R.SP.CHECKACCOUNT_VOUCHER, BeanHelper.describe(voucherList));
		putResult(R.SP.CHECKACCOUNT_BANK, BeanHelper.describe(bankRecordList));
		getBrs_checkAccount_top().put("startDate", DateUtil.fmtDateToYMD(startDate));
		//ˢ�·�ʽ�� ˢ��  �˴�Ϊ�˷�ҳʱʹ��
		getBrs_checkAccount_top().put("refreshType","refresh");
		putResult("brs_checkAccount_top", getBrs_checkAccount_top());
	}
	

}

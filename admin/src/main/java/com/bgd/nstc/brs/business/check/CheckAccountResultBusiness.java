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
 * @Title 对账查询结果
 * @Description: 
 * @author ZCL
 * @date 2014-8-21 下午01:34:21
 */
public class CheckAccountResultBusiness extends CheckAccountMainBusiness {
	
	
	@Override
	public void doExecute() throws Exception {
		Date startDate =getInitDate(buildStatementRecordQry());
		//ZTCW-1123 20170609 add by caoerwei 对账的起始日期可人工选择，方便核对某一天的明细 start 
			Date startDateNew = getStartDate();
			if(startDateNew != null){
				startDate=startDateNew;
		    }
		//ZTCW-1123 20170609 add by caoerwei 对账的起始日期可人工选择，方便核对某一天的明细 end
		putCommonResult();
		CheckAccountQry qry = buildQry();
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
		Long startTime1=System.currentTimeMillis();
		System.out.println("查询开始时间："+new Date(startTime1));
		List<BrsVoucher> voucherList = getContext().getCheckAccountService().getVoucher(qry);
		Long startTime2=System.currentTimeMillis();
		
		System.out.println("企业账查询消耗时间："+(startTime2-startTime1)/1000+"秒");
		System.out.println("查询银行账开始时间："+new Date(startTime2));
		//银行账单
		List<BrsBankRecord> bankRecordList = getContext().getCheckAccountService().getBankRecord(qry);
		Long startTime3=System.currentTimeMillis();
		System.out.println("查询结束时间："+new Date(startTime3));
		System.out.println("银行账查询消耗时间："+(startTime3-startTime2)/1000+"秒");
		System.out.println("对账查询共消耗时间："+(startTime3-startTime1)/1000+"秒");
		putResult(R.SP.CHECKACCOUNT_VOUCHER, BeanHelper.describe(voucherList));
		putResult(R.SP.CHECKACCOUNT_BANK, BeanHelper.describe(bankRecordList));
		getBrs_checkAccount_top().put("startDate", DateUtil.fmtDateToYMD(startDate));
		//刷新方式： 刷新  此处为了分页时使用
		getBrs_checkAccount_top().put("refreshType","refresh");
		putResult("brs_checkAccount_top", getBrs_checkAccount_top());
	}
	

}

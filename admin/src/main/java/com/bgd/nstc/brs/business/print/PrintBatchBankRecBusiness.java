package com.nstc.brs.business.print;

import java.util.List;

import com.nstc.brs.business.query.BatchBankRecQryBusiness;
import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.handler.pdf.PdfReportHandler;
import com.nstc.brs.model.ReportDataHolder;
import com.nstc.brs.model.StatementRecordView;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title ��ӡ�����ڱ����
 * @Description: 
 * @author ZCL
 * @date 2014-9-3 ����02:59:14
 */
public class PrintBatchBankRecBusiness extends BatchBankRecQryBusiness{
	
	@Override
	public void doExecute() throws Exception {
		BrsAccount accountQry = BeanHelper.populate(BrsAccount.class, getBrs_qryBatchBankRec_top());
		
		//�õ���Ŀ�б� ��ʼѭ����ѯ���
		List<BrsAccount> accountList = qryAccounts(accountQry);
		List<StatementRecordView> srList = getStatementRecordViews(accountList);
		ReportDataHolder dataHolder=new ReportDataHolder();
		dataHolder.setReportName("BrsBatchBankRec");
		dataHolder.setCollection(BeanHelper.describe(srList));
		byte[]data=PdfReportHandler.makePdfReport(dataHolder);
		putResult("_data", data);
		
	}
}

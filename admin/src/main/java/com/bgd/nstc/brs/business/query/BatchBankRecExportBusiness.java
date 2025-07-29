package com.nstc.brs.business.query;

import java.util.List;

import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.model.StatementRecordView;
import com.nstc.brs.model.excel.ExcelBatchBankRec;
import com.nstc.brs.util.ExcelUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title ���������ڱ���ܴ�ӡ
 * @Description: 
 * @author ZCL
 * @date 2014-9-2 ����04:01:48
 */
public class BatchBankRecExportBusiness extends BatchBankRecQryBusiness{
	
	
	@Override
	public void doExecute() throws Exception {
		BrsAccount accountQry = BeanHelper.populate(BrsAccount.class, getBrs_qryBatchBankRec_top());
		
		//�õ���Ŀ�б� ��ʼѭ����ѯ���
		List<BrsAccount> accountList = qryAccounts(accountQry);
		List<StatementRecordView> srList = getStatementRecordViews(accountList);
		ExcelBatchBankRec root = new ExcelBatchBankRec();
		root.setDataList(srList);
		root.setSheetName("���������ڱ����");
		putResult("DataBytes",ExcelUtil.getExcelByteArray(root));
		
	}
}

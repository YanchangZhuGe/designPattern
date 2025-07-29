package com.nstc.brs.business.query;

import java.util.List;

import com.nstc.brs.domain.BrsAccount;
import com.nstc.brs.model.StatementRecordView;
import com.nstc.brs.model.excel.ExcelBatchBankRec;
import com.nstc.brs.util.ExcelUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 银行余额调节表汇总打印
 * @Description: 
 * @author ZCL
 * @date 2014-9-2 下午04:01:48
 */
public class BatchBankRecExportBusiness extends BatchBankRecQryBusiness{
	
	
	@Override
	public void doExecute() throws Exception {
		BrsAccount accountQry = BeanHelper.populate(BrsAccount.class, getBrs_qryBatchBankRec_top());
		
		//拿到科目列表 开始循环查询结果
		List<BrsAccount> accountList = qryAccounts(accountQry);
		List<StatementRecordView> srList = getStatementRecordViews(accountList);
		ExcelBatchBankRec root = new ExcelBatchBankRec();
		root.setDataList(srList);
		root.setSheetName("银行余额调节表汇总");
		putResult("DataBytes",ExcelUtil.getExcelByteArray(root));
		
	}
}

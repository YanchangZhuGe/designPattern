package com.nstc.brs.business.query;

import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.model.excel.ExcelMatchRecordBank;
import com.nstc.brs.model.excel.ExcelMatchRecordVoucher;
import com.nstc.brs.util.CastUtil;
import com.nstc.brs.util.ExcelUtil;
import com.nstc.brs.util.excel.ExcelCast;

/**
 * 
 * @Title 历史匹配记录 导出
 * @Description: 
 * @author ZCL
 * @date 2014-9-3 上午10:10:39
 */
public class MatchedRecordExportBusiness extends MatchedRecordQryBusiness {
	
	@Override
	public void doExecute() throws Exception {
		Integer exportType =CastUtil.toInteger(getBrs_qryMatchedRecord_top().get("exportType"));
		ExcelCast root = null;
		CheckAccountQry qry = getQryPara();
		//企业帐
		if(exportType.intValue() == 0){
			root = new ExcelMatchRecordVoucher();
			root.setDataList(getContext().getVoucherService().getVoucherList(qry));
			root.setSheetName("企业对账单");
		}else{
			root = new ExcelMatchRecordBank();
			root.setDataList(getContext().getBankRecordService().getRecordList(qry));
			root.setSheetName("银行对账单");
		}
		putResult("DataBytes",ExcelUtil.getExcelByteArray(root));
	}
}

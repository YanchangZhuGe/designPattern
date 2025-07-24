package com.nstc.brs.business.print;

import java.util.List;

import com.nstc.brs.business.query.MatchedRecordQryBusiness;
import com.nstc.brs.handler.pdf.PdfReportHandler;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.model.ReportDataHolder;
import com.nstc.brs.util.CastUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 历史匹配记录 打印
 * @Description: 
 * @author ZCL
 * @date 2014-9-3 上午10:10:39
 */
public class PrintMatchedRecordBusiness extends MatchedRecordQryBusiness {
	
	@Override
	public void doExecute() throws Exception {
		Integer exportType =CastUtil.toInteger(getBrs_qryMatchedRecord_top().get("exportType"));
		ReportDataHolder dataHolder=new ReportDataHolder();
		CheckAccountQry qry = getQryPara();
		List<?> list = null;
		//企业帐
		if(exportType.intValue() == 0){
			list = getContext().getVoucherService().getVoucherList(qry);
			dataHolder.setReportName("BrsMatchedRecordV");
			
		}else{
			list = getContext().getBankRecordService().getRecordList(qry);
			dataHolder.setReportName("BrsMatchedRecordB");
		}
		dataHolder.setCollection(BeanHelper.describe(list));
		byte[]data=PdfReportHandler.makePdfReport(dataHolder);
		putResult("_data", data);
	}
}

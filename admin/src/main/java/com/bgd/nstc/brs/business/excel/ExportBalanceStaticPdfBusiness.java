package com.nstc.brs.business.excel;

import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.handler.pdf.PdfReportHandler;
import com.nstc.brs.model.ReportDataHolder;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.brs.util.ExcelReportUtils;
import com.nstc.util.BeanHelper;
import org.apache.log4j.Logger;

import java.util.List;
import java.util.Map;

public class ExportBalanceStaticPdfBusiness extends ExcelTemplateBusiness {
    final static Logger log = Logger.getLogger(ExportBalanceStaticPdfBusiness.class);
    private Integer id;
    private String makeDate;
    private String checkUser;

    @SuppressWarnings({"rawtypes", "unchecked"})
    @Override
    public void doExecute() throws Exception {
        MonthCheckScope scope = new MonthCheckScope();
        scope.setId(id);
        scope.setRecordId(id);
        List<BrsCheckRecord> recordList = this.getContext().getAccountService().getMonthCheckList(scope);

        scope.setDetailType(DetailType.TYPE_1.getValue());
        List<Map<String, Object>> comList = this.getContext().getAccountService().getOutstandingDetailList(scope);
        scope.setDetailType(DetailType.TYPE_2.getValue());
        List<Map<String, Object>> bankList = this.getContext().getAccountService().getOutstandingDetailList(scope);

        BrsCheckRecord record = this.getContext().getAccountService().getBrsCheckRecord(recordList);//recordList.get(0);

        Map dataMap = this.getContext().getAccountService().getDataMap(record, bankList, comList, makeDate, checkUser);

        ReportDataHolder dataHolder = new ReportDataHolder();
        dataHolder.setReportName("BrsBalanceStatic");
        dataHolder.setParameter(dataMap);
        dataHolder.setCollection((List<Map<String, Object>>) dataMap.get("dataList"));

        byte[] dataBytes = PdfReportHandler.makePdfReport(dataHolder);
        this.putResult("data", dataBytes);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getMakeDate() {
        return makeDate;
    }

    public void setMakeDate(String makeDate) {
        this.makeDate = makeDate;
    }

    public String getCheckUser() {
        return checkUser;
    }

    public void setCheckUser(String checkUser) {
        this.checkUser = checkUser;
    }
}

package com.nstc.brs.business.excel;

import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.handler.pdf.PdfReportHandler;
import com.nstc.brs.model.ReportDataHolder;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.brs.util.ExcelReportUtils;
import com.nstc.framework.web.util.FrameworkUtil;
import com.nstc.util.BeanHelper;
import com.nstc.util.DateUtil;
import com.nstc.util.TextFormat;

import java.util.*;

public class ExportMonthCheckPdfBusiness extends ExcelTemplateBusiness {
    private String balanceDate;
    private String bankAccountNo;
    private String checkState;
    private String checkUser;
    private String mateMonth;
    private String bankNo;

    @SuppressWarnings({"rawtypes", "unchecked"})
    @Override
    public void doExecute() throws Exception {
        MonthCheckScope scope = new MonthCheckScope();
        if (mateMonth == null || mateMonth.length() == 0) {
            mateMonth = TextFormat.formatDate(DateUtil.addMonth(new Date(), -1), "yyyy-MM");
        }
        scope.setMateMonth(mateMonth);
        scope.setBankNo(bankNo);
        scope.setBankAccountNos(bankAccountNo);
        scope.setCheckState(checkState);
        List<BrsCheckRecord> list = this.getContext().getAccountService().getMonthCheckList(scope);
        Map dataMap = this.getContext().getAccountService().getDataMap(list, checkUser, mateMonth);

        ReportDataHolder dataHolder = new ReportDataHolder();
        dataHolder.setReportName("BrsMonthCheckList");
        dataHolder.setParameter(dataMap);
        dataHolder.setCollection((List<Map<String, Object>>) dataMap.get("dataList"));

        byte[] dataBytes = PdfReportHandler.makePdfReport(dataHolder);
        this.putResult("data", dataBytes);
    }

    public String getBalanceDate() {
        return balanceDate;
    }

    public void setBalanceDate(String balanceDate) {
        this.balanceDate = balanceDate;
    }

    public String getBankAccountNo() {
        return bankAccountNo;
    }

    public void setBankAccountNo(String bankAccountNo) {
        this.bankAccountNo = bankAccountNo;
    }

    public String getCheckState() {
        return checkState;
    }

    public void setCheckState(String checkState) {
        this.checkState = checkState;
    }

    public String getCheckUser() {
        return checkUser;
    }

    public void setCheckUser(String checkUser) {
        this.checkUser = checkUser;
    }

    public String getMateMonth() {
        return mateMonth;
    }

    public void setMateMonth(String mateMonth) {
        this.mateMonth = mateMonth;
    }

    public String getBankNo() {
        return bankNo;
    }

    public void setBankNo(String bankNo) {
        this.bankNo = bankNo;
    }
}

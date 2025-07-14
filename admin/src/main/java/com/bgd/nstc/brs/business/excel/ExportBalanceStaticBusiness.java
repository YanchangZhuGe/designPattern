package com.nstc.brs.business.excel;

import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.brs.util.ExcelReportUtils;
import com.nstc.framework.web.util.FrameworkUtil;
import com.nstc.util.CollectionUtils;
import com.nstc.util.DateUtil;
import org.apache.log4j.Logger;

import java.util.*;

public class ExportBalanceStaticBusiness extends ExcelTemplateBusiness {
    final static Logger log = Logger.getLogger(ExportBalanceStaticBusiness.class);
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

        String templateFile = getTempPath("balanceStatic.xlsx");
        Map dataMap = this.getContext().getAccountService().getDataMap(record, bankList, comList, makeDate, checkUser);
        byte[] dataBytes = ExcelReportUtils.exportReport(templateFile, dataMap);
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

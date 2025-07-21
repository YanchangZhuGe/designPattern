package com.nstc.brs.business.excel;

import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.handler.pdf.PdfReportHandler;
import com.nstc.brs.model.ReportDataHolder;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.brs.util.FtpTools;
import com.nstc.brs.util.ZipUtils;
import org.apache.log4j.Logger;

import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExportBalanceStaticPdfZipBusiness extends ExcelTemplateBusiness {
    final static Logger log = Logger.getLogger(ExportBalanceStaticPdfZipBusiness.class);
    private String ids;
    private String orderIds;
    private String makeDate;
    private String checkUser;

    private final String tempPath = FtpTools.getPollingInfo("tempPath") + File.separator + "brs_service" + File.separator + "pdf";
    private final String fileName = "余额调节表";
    private final String filePath = tempPath + File.separator + fileName;

    @SuppressWarnings({"rawtypes", "unchecked"})
    @Override
    public void doExecute() throws Exception {
        ZipUtils.delFile(tempPath + File.separator, fileName + ".zip");
        //创建目录,如果存在则不在创建
        ZipUtils.createFileDir(filePath);

        FileOutputStream fos = null;
        BufferedOutputStream bufferedOutputStream = null;
        try {
            String[] idSplit = ids.split(",");
            String[] orderIdsSplit = orderIds.split(",");
            for (int i = 0; i < idSplit.length; i++) {
                Integer id = Integer.valueOf(idSplit[i]);

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

                File file = new File(filePath + File.separator + "余额调节表_" + orderIdsSplit[i] + ".pdf");
                if (file.exists()) {
                    file.delete();
                }
                fos = new FileOutputStream(file);
                bufferedOutputStream = new BufferedOutputStream(fos);
                bufferedOutputStream.write(dataBytes, 0, dataBytes.length);

                bufferedOutputStream.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            closeFileOutPutStream(fos);
            closeFileOutPutStream(bufferedOutputStream);
        } finally {
            closeFileOutPutStream(fos);
            closeFileOutPutStream(bufferedOutputStream);
        }

        long startTime = System.currentTimeMillis();
        //此处用于阻塞，确保生成的数据在后续代码执行中是完整的
        /*blockMenthon(futureTasks);*/

        log.info(filePath + "执行时间：" + startTime);
        FileOutputStream out = null;
        try {
            File file = new File(filePath + ".zip");
            out = new FileOutputStream(file);
            ZipUtils.toZip(filePath, out, true, false);
        } catch (FileNotFoundException e) {
            closeFileOutPutStream(out);
            e.printStackTrace();
        } finally {
            closeFileOutPutStream(out);
        }
        log.info("执行时间>>>>>>>>>>>" + (System.currentTimeMillis() - startTime));
    }

    @Override
    public void onSuccess() {
        Map rsMap = new HashMap();
        FileInputStream fis = null;
        ByteArrayOutputStream bos = null;
        try {
            long startTimeDown = System.currentTimeMillis();
            File zipFile = new File(filePath + ".zip");
            if (!zipFile.exists()) {
                rsMap.put("errorMsg", "文件不存在请检查!");
            }
            fis = new FileInputStream(zipFile);
            bos = new ByteArrayOutputStream();
            byte[] b = new byte[1024];
            int n;
            while ((n = fis.read(b)) != -1) {
                bos.write(b, 0, n);
            }
            fis.close();
            bos.close();
            byte[] buffer = bos.toByteArray();
            rsMap.put("fileName", fileName + ".zip");
            rsMap.put("data", buffer);
            setResult(rsMap);
            log.info("余额调节表下载执行时间:" + (System.currentTimeMillis() - startTimeDown) / 1000 + " s");
        } catch (Exception e) {
            e.printStackTrace();
            closeFileInPutStream(fis);
            closeFileOutPutStream(bos);
        } finally {
            closeFileInPutStream(fis);
            closeFileOutPutStream(bos);
        }
    }

    public String getIds() {
        return ids;
    }

    public void setIds(String ids) {
        this.ids = ids;
    }

    public String getOrderIds() {
        return orderIds;
    }

    public void setOrderIds(String orderIds) {
        this.orderIds = orderIds;
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

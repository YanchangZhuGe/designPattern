package com.nstc.brs.business.excel;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.util.ExcelReportUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public abstract class ExcelTemplateBusiness extends AbstractBRSBusiness {

    public String getTempPath(String templateName) {
        String filepath = "BRS-Service-CFG/excel-template/" + templateName;
        String classesPath = ExcelReportUtils.class.getClassLoader().getResource("/").getPath();
        String templateFile = classesPath + filepath;
        return templateFile;
    }

    /**
     * @Description: 关闭输出流
     * @date: 2022/4/13 16:00
     * @author: Dengmingfeng
     **/
    public void closeFileOutPutStream(OutputStream fos) {
        if (fos != null) {
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * @Description: 关闭输入流
     * @date: 2022/4/13 16:00
     * @author: Dengmingfeng
     **/
    public void closeFileInPutStream(InputStream fis) {
        if (fis != null) {
            try {
                fis.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

package com.bgp.mcs.web.common.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class TableExportExcelAction  extends WSAction {
    public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	String absolutePath = this.getServlet().getServletContext().getRealPath("");
    	String fromPage = request.getParameter("fromPage");
    	String projectName = request.getParameter("projectName");
    	String strDataRows = request.getParameter("dataRows");
    	JSONArray jsonDatas = JSONArray.fromObject(strDataRows);
    	
    	if(fromPage == null || "".equals(fromPage)){
    		return null;
    	}
    	
    	String fileName = fromPage + ".xls";
    	String templateFileName = absolutePath + "/pm/exportTemplate/" + fileName;
    	
    	File file = new File(templateFileName);
    	InputStream in = new FileInputStream(file);
    	Workbook book = null;
    	Sheet sheet = null;
		Row row = null;
		if (fileName.indexOf(".xlsx") == -1) {
			book = new HSSFWorkbook(new POIFSFileSystem(in));
			sheet = book.getSheetAt(0);
		}else{
			book = new XSSFWorkbook(in);
			sheet = book.getSheetAt(0);
		}
		int titleRows = sheet.getPhysicalNumberOfRows();
		if(fromPage.equals("lineConsructionTemp")){
			titleRows-=2;
		}
		Row titleRow = null;
		titleRow = sheet.getRow(0);
		Cell titleCell = titleRow.getCell(0);
		titleCell.setCellType(1);
		String cellValue = titleCell.getStringCellValue().trim();
		titleCell.setCellValue(projectName + cellValue);
		
		for(int i = 0; i < jsonDatas.size(); i++){
			HSSFRow excelRow = (HSSFRow) sheet.createRow( i + titleRows);//建立新行
			JSONObject obj = (JSONObject) jsonDatas.get(i);
			for(int k=0; k<obj.size(); k++){
				int key = k+1;
				HSSFCell excelCell = excelRow.createCell(k);//建立新cell
				excelCell.setCellType(1);
				excelCell.setCellValue(obj.getString(""+key).replace("\"null\"", ""));
			}
    	}
		
    	String tempFileName = absolutePath + "/WEB-INF/temp/" + fileName;
		OutputStream os = new FileOutputStream(tempFileName);
		book.write(os);
		os.flush();
		os.close();
		
    	response.setContentType("text/json; charset=utf-8");
    	String ret="{returnCode:0, excelName:'"+fileName+"'}";
    	response.getWriter().write(ret);
    	return null;
    }
    
}

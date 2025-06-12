package com.bgp.mcs.web.pm.project;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;

public class ProductPlanExportExcelAction extends WSAction {
    @SuppressWarnings({ "deprecation", "unchecked", "rawtypes" })
	public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	
    	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
    	
    	List<MsgElement> allList = responseDTO.getMsgElements("allList");
    	List<MsgElement> measuredailylist = responseDTO.getMsgElements("measuredailylist");
    	List<MsgElement> drilldailylist = responseDTO.getMsgElements("drilldailylist");
    	List<MsgElement> colldailylist = responseDTO.getMsgElements("colldailylist");
    	String project_name = responseDTO.getValue("projectName")!=null?responseDTO.getValue("projectName"):"";
    	//激发方式
    	String build_method = responseDTO.getValue("buildMethod")!=null?responseDTO.getValue("buildMethod"):"";
    	List headList = new ArrayList();
    	List headListValue = new ArrayList();
    	headList.add("record_month");
    	headListValue.add("日期");
    	headList.add("workload_num");
    	headListValue.add("测量计划日效(km)");

    	int totalNum = 0;
    	boolean measureFlag = false;
    	boolean drillFlag = false;
    	boolean collFlag = false;
    	//测量 workload_num
    	if(measuredailylist != null){
    		measureFlag = true;
    		if(totalNum <= measuredailylist.size()){
    			totalNum = measuredailylist.size();
    		}
    	}
    	
    	if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method)||"5000100003000000005".equals(build_method)||"5000100003000000007".equals(build_method)){
    		headList.add("workload");
    		headListValue.add("钻井计划日效(个)");
        	//钻井 workload
        	if(drilldailylist != null){
        		drillFlag = true;
        		if(totalNum <= drilldailylist.size()){
        			totalNum = drilldailylist.size();
        		}
        	}
    	}
    	
    	headList.add("workload");
    	headListValue.add("采集计划日效(炮)");

    	//采集 workload
    	if(colldailylist != null){
    		collFlag = true;
    		if(totalNum <= colldailylist.size()){
    			totalNum = colldailylist.size();
    		}
    	}
    	
    	
    	if(totalNum > 0){
    		Object[] names = headListValue.toArray();
    		 
    		HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet("data");//建立新的sheet对象
    		sheet.setColumnWidth(0, 5000);
    		sheet.setColumnWidth(1, 5000);
    		sheet.setColumnWidth(2, 5000);
    		sheet.setColumnWidth(3, 5000);
    		
    		HSSFCellStyle style_center = wb.createCellStyle();
    		style_center.setAlignment(HSSFCellStyle.ALIGN_CENTER);

    		CellStyle floatCellStyle = wb.createCellStyle();  
    		floatCellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("0.000"));
    		
    		HSSFRow row0 = sheet.createRow((short)0);//建立第一行
    		HSSFCell cell0 = row0.createCell(0);  //建立第一列
    		cell0.setCellStyle(style_center);
    		
    		String fileName = new String((project_name+"-计划日效").getBytes("GBK"), "ISO8859-1");
    		cell0.setCellValue(project_name);
    		Region  rg = new Region(0,(short)0,0,(short)names.length);
    		sheet.addMergedRegion(rg);
    		
    		HSSFRow row1 = sheet.createRow((short)1);//建立第二行
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row1.createCell(j);//建立新cell
    			cell.setCellValue((String)names[j]);
    			cell.setCellStyle(style_center);
    		}

    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		
    		float totalMeasure = 0;
    		float totalDrill = 0;
    		float totalColl = 0;    		
    		for(int k=0;k<totalNum;k++){
    			int cellSize = 0;
    			HSSFRow row = sheet.createRow((short)(k+2));//建立新行
    			MsgElement dataTotal = allList.get(k);
    			Map dataMap = dataTotal.toMap();
    			String record_month_total = dataMap.get("record_month").toString();
    			//写入日期数据
    			if(record_month_total != null && record_month_total != ""){
       				HSSFCell cell = row.createCell(cellSize);//建立新cell
       				//cell.setCellType(HSSFCell.CELL_TYPE_STRING);
    				cell.setCellValue(record_month_total);
    			}
        		//测量
        		if(measureFlag){
        			cellSize++;
            		for(int i=0;i<measuredailylist.size();i++){
            			MsgElement data = measuredailylist.get(i);
            			Map map = data.toMap();
            			String record_month = map.get("record_month").toString();
            			if(record_month == record_month_total || record_month.equals(record_month_total)){
                			if(map.get("workload_num") != null && map.get("workload_num") != ""){
                				totalMeasure += Float.parseFloat(map.get("workload_num").toString());
                			}
                			HSSFCell cell = row.createCell(cellSize);//建立新cell
                			cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
                			cell.setCellStyle(floatCellStyle);
                			float measureValue = 0;
                			if(map.get("workload_num") != "" && map.get("workload_num").toString() != ""){
                    			measureValue = Float.parseFloat(map.get("workload_num").toString());
                			}else{
                				measureValue = 0;
                			}
                  			cell.setCellValue(measureValue);
            			}
            		}
        		}
        		
        		//钻井
        		if(drillFlag){
        			cellSize++;
        			if(drilldailylist.size() > 0){
                		for(int i=0;i<drilldailylist.size();i++){
                			MsgElement data = drilldailylist.get(i);
                			Map map = data.toMap();
                			String record_month = map.get("record_month").toString();
                			if(record_month == record_month_total || record_month.equals(record_month_total)){
                    			if(map.get("workload") != null && map.get("workload") != ""){
                    				totalDrill += Float.parseFloat(map.get("workload").toString());
                    			}
                    			HSSFCell cell = row.createCell(cellSize);//建立新cell
                    			cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
                    			float drillValue = 0;
                    			if(map.get("workload") != "" && map.get("workload").toString() != ""){
                    				drillValue = Float.parseFloat(map.get("workload").toString());
                    			}
                    			
                      			cell.setCellValue(drillValue);
                			}
                		}
        			}
        		}
        		
        		//采集
        		if(collFlag){
        			cellSize++;
            		for(int i=0;i<colldailylist.size();i++){
            			MsgElement data = colldailylist.get(i);
            			Map map = data.toMap();
            			String record_month = map.get("record_month").toString();
            			if(record_month == record_month_total || record_month.equals(record_month_total)){
                   			if(map.get("workload") != null && map.get("workload") != ""){
                				totalColl += Float.parseFloat(map.get("workload").toString());
                			}
                			HSSFCell cell = row.createCell(cellSize);//建立新cell
                			cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
                			float collValue = 0;
                			if(map.get("workload") != "" && map.get("workload").toString() != ""){
                				collValue = Float.parseFloat(map.get("workload").toString());
                			}else{
                				collValue = 0;
                			}
                			
                			cell.setCellValue(collValue);
            			}
            		}
        		}
    		}
    		
    		//最后一行的累加数据
    		HSSFRow row_last = sheet.createRow((short)(2+totalNum));//建立最后一行
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row_last.createCell(j);//建立新cell
    			if("日期".equals(names[j])){
    				cell.setCellType(HSSFCell.CELL_TYPE_STRING);
    				cell.setCellValue("");
    				continue;
    			}else if("测量计划日效(km)".equals(names[j])){
    				cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    				cell.setCellStyle(floatCellStyle);
    				cell.setCellValue(totalMeasure);
    				continue;
    			}else if("钻井计划日效(个)".equals(names[j])){
    				cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    				cell.setCellValue(totalDrill);
    				continue;
    			}else if("采集计划日效(炮)".equals(names[j])){
    				cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    				cell.setCellValue(totalColl);
    				continue;
    			}
    		}
    		
			// 设置 response 流属性
			response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// 设置 response 显示标头
			response.setHeader("Content-Disposition","attachment;  filename=" + fileName + ".xls");
			
			OutputStream os = response.getOutputStream();
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
    	}
    	return null;
    }
}

package com.bgp.mcs.web.mat;

import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class AcceptExportExcelAction extends WSAction {

    public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	
    	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
    	
    	List<MsgElement> datas = responseDTO.getMsgElements("datas");
    	
    	if(datas!=null){
    		String[] titles = {"物资编码","物资说明","计量单位","数量","单价","金额"};
    		String[] names={"wz_id","wz_name","wz_prickie","mat_num","wz_price","total_money"};
    		MsgElement headData = datas.get(0);
			Map headMap = headData.toMap();
			System.out.println(headMap);
    		HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet("data");//建立新的sheet对象
    		
    		HSSFRow row0 = sheet.createRow((short)0);//建立新行
    		row0.setHeight((short) 400);
    		
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平布局：居中
    		//sheet.addMergedRegion(new Region(0, (short) 0, 0, (short) colSum));
    		
//    		HSSFCellStyle borderStyle = wb.createCellStyle();
//    		borderStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);// 下边框   
//    		borderStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);// 左边框   
//    		borderStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);// 右边框   
//    		borderStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);// 上边框   

    		
    		// 建立表头
    		HSSFCell cell0 = row0.createCell(0);
    		sheet.addMergedRegion(new Region(0, (short) 0, 0,(short) 10));
    		cell0.setCellValue(""+headMap.get("org_abbreviation")+"入库单");
    		cell0.setCellStyle(style);
    		
    		HSSFRow row1 = sheet.createRow((short)1);//建立新行
    		sheet.addMergedRegion(new Region(1, (short) 0, 1,(short) 10));
    		HSSFCell cell1 = row1.createCell(0);
    		String cellData1="     库存项目："+headMap.get("project_name")+"                                          入库时间："+headMap.get("input_date")+"                                 入库单号："+headMap.get("invoices_no")+"";
    		cell1.setCellValue(cellData1);
    		/*
    		HSSFRow row2 = sheet.createRow((short)2);//建立新行
    		sheet.addMergedRegion(new Region(2, (short) 0, 2,(short) 10));
    		HSSFCell cell2 = row2.createCell(0);
    		cell2.setCellValue("     领料单位："+headMap.get("tname")+"                                                                                           项数："+headMap.get("numbers")+"");
    		*/
    		HSSFRow row3 = sheet.createRow((short)3);//建立新行
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row3.createCell(j);//建立新cell
				cell.setCellValue(titles[j]);
				cell.setCellStyle(style);
				//sheet.setColumnWidth(j, 6000);
    		}
    		// 建立具体数据
    		for(int i=0;i<datas.size();i++){
    			MsgElement data = datas.get(i);
    			Map map = data.toMap();
    			HSSFRow row = sheet.createRow((short)(i+4));//建立新行
    			
    			for(int j=0;j<titles.length;j++){
    				HSSFCell cell = row.createCell(j);//建立新cell
    				cell.setCellValue(map.get(names[j]).toString());
    			}
    		}
    		int num = datas.size()+4;
    		
    		HSSFRow rowEnd = sheet.createRow((short)(num));//建立新行
    		HSSFCell cellEnd0 = rowEnd.createCell(0);
    		HSSFCell cellEnd5 = rowEnd.createCell(5);
    		cellEnd0.setCellValue("合计：");
    		cellEnd5.setCellValue(""+headMap.get("allmoney")+"");
    		HSSFRow row = sheet.createRow((short)(num+1));//建立新行
    		sheet.addMergedRegion(new Region(num+1, (short) 0, num+1,(short) 10));
    		HSSFCell cell = row.createCell(0);
    		cell.setCellValue("开票员："+headMap.get("operator")+"                                                                          保管员: "+headMap.get("storage")+"                                                提料人:"+headMap.get("pickupgoods")+"          ");
//    		
//    		// 设置列宽，自动 
    		for(int j=0;j<titles.length;j++){
				sheet.autoSizeColumn(j); // 自动计算列宽
				//sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*0.5)); // 设置列宽为自动值的1.5倍
   		   }
    		
			// 设置 response 流属性
			response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// 设置 response 显示标头
//			response.setHeader("Content-Disposition","attachment;  filename=" + "wzOut" + ".xls");
			response.setHeader("Content-Disposition","attachment;  filename=" +URLEncoder.encode("入库单", "utf-8") + ".xls");
			
			
			
			OutputStream os = response.getOutputStream();
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
    	}
    	
    	return null;
    }
}

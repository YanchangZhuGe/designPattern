package com.bgp.mcs.web.mat;

import java.io.OutputStream;
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

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class AppExportExcelAction extends WSAction {

    public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	
    	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
    	
    	List<MsgElement> datas = responseDTO.getMsgElements("datas");
    	
    	if(datas!=null){
    		String[] titles = {"物资编码","物资分类码","名称","计量单位","参考单价","需求数量","现有数量","可调剂数量","合计申请量","计划金额","需求日期","物资说明"};
    		String[] names={"wz_id","coding_code_id","wz_name","wz_prickie","wz_price","demand_num","have_num","regulate_num","apply_num","plan_money","compile_date","code_desc"};
    		
    		HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet("data");//建立新的sheet对象
    		
    		HSSFRow row0 = sheet.createRow((short)0);//建立新行
    		
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		//style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平布局：居中
    		
    		// 建立表头
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row0.createCell(j);//建立新cell
				cell.setCellValue(titles[j]);
				cell.setCellStyle(style);
				//sheet.setColumnWidth(j, 6000);
    		}
    		
    		// 建立具体数据
    		for(int i=0;i<datas.size();i++){
    			MsgElement data = datas.get(i);
    			Map map = data.toMap();
    			HSSFRow row = sheet.createRow((short)(i+1));//建立新行
    			for(int j=0;j<titles.length;j++){
    				HSSFCell cell = row.createCell(j);//建立新cell
    				System.out.println(map.get(names[j]).toString());
    				cell.setCellValue(map.get(names[j]).toString());
    			}
    		}
//    		
//    		// 设置列宽，自动 
//    		for(int j=0;j<titles.length;j++){
//				sheet.autoSizeColumn(j); // 自动计算列宽
//				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // 设置列宽为自动值的1.5倍
//    		}
    		
			// 设置 response 流属性
			response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// 设置 response 显示标头
			response.setHeader("Content-Disposition","attachment;  filename=" + "wzPlan" + ".xls");
			
			OutputStream os = response.getOutputStream();
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
    	}
    	
    	return null;
    }
}

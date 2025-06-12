package com.bgp.mcs.web.pm.project;

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
import org.apache.poi.hssf.util.Region;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;

/**
 * 综合物化探测量测算导出Excel
 * @author zs
 *
 */
public class WtMeasureExportExcelAction  extends WSAction {
    @SuppressWarnings("deprecation")
	public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	System.out.println("in the action");
    	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
    	List<MsgElement> datas = responseDTO.getMsgElements("showWtMeasureList");
    	
    	//获取计算的总数
    	String total_jb_gy_one="";
    	String total_jb_gy_two="";
    	String total_jb_gy_three="";
    	String total_jb_gy_four="";
    	String total_jb_mountain_one = "";
    	String total_jb_mountain_two = "";
    	String total_jb_zz_one = "";
    	String total_jb_zz_two = "";
    	String total_jb_zz_three = "";
    	String total_jb_zz_four = "";
    	String total_jb_desert_one = "";
    	String total_jb_desert_two = "";
    	String total_jb_desert_three = "";
    	String total_jb_hty_one = "";
    	String total_jb_hty_two = "";
    	String total_jb_cy_one = "";
    	String total_jb_cy_two = "";  
    	String total_jb_py_one = "";
    	String total_jb_py_two = "";

    	String measureType = "";
    	String projectName = "";
    	String excelTitle = "";
    	
    	if(responseDTO.getValue("total_jb_gy_one")!= null){
          	total_jb_gy_one = responseDTO.getValue("total_jb_gy_one").substring(0,responseDTO.getValue("total_jb_gy_one").indexOf("."));
        }
    	if(responseDTO.getValue("total_jb_gy_two")!= null){
    		total_jb_gy_two = responseDTO.getValue("total_jb_gy_two").substring(0,responseDTO.getValue("total_jb_gy_two").indexOf("."));
    	}
    	if(responseDTO.getValue("total_jb_gy_three")!= null){
    		total_jb_gy_three = responseDTO.getValue("total_jb_gy_three").substring(0,responseDTO.getValue("total_jb_gy_three").indexOf("."));
    	}
    	if(responseDTO.getValue("total_jb_gy_four") != null){
    		total_jb_gy_four = responseDTO.getValue("total_jb_gy_four").substring(0,responseDTO.getValue("total_jb_gy_four").indexOf("."));
    	}
        if(responseDTO.getValue("total_jb_mountain_one") != null){
        	total_jb_mountain_one = responseDTO.getValue("total_jb_mountain_one").substring(0,responseDTO.getValue("total_jb_mountain_one").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_mountain_two") != null){
        	total_jb_mountain_two = responseDTO.getValue("total_jb_mountain_two").substring(0,responseDTO.getValue("total_jb_mountain_two").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_zz_one") != null){
        	total_jb_zz_one = responseDTO.getValue("total_jb_zz_one").substring(0,responseDTO.getValue("total_jb_zz_one").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_zz_two") != null){
        	total_jb_zz_two = responseDTO.getValue("total_jb_zz_two").substring(0,responseDTO.getValue("total_jb_zz_two").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_zz_three") != null){
        	total_jb_zz_three = responseDTO.getValue("total_jb_zz_three").substring(0,responseDTO.getValue("total_jb_zz_three").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_zz_four") != null){
        	total_jb_zz_four = responseDTO.getValue("total_jb_zz_four").substring(0,responseDTO.getValue("total_jb_zz_four").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_desert_one") != null){
        	total_jb_desert_one = responseDTO.getValue("total_jb_desert_one").substring(0,responseDTO.getValue("total_jb_desert_one").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_desert_two") != null){
        	total_jb_desert_two = responseDTO.getValue("total_jb_desert_two").substring(0,responseDTO.getValue("total_jb_desert_two").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_desert_three") != null){
        	total_jb_desert_three = responseDTO.getValue("total_jb_desert_three").substring(0,responseDTO.getValue("total_jb_desert_three").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_hty_one") != null){
        	total_jb_hty_one = responseDTO.getValue("total_jb_hty_one").substring(0,responseDTO.getValue("total_jb_hty_one").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_hty_two") != null){
        	total_jb_hty_two = responseDTO.getValue("total_jb_hty_two").substring(0,responseDTO.getValue("total_jb_hty_two").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_cy_one") != null){
        	total_jb_cy_one = responseDTO.getValue("total_jb_cy_one").substring(0,responseDTO.getValue("total_jb_cy_one").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_cy_two") != null){
        	total_jb_cy_two = responseDTO.getValue("total_jb_cy_two").substring(0,responseDTO.getValue("total_jb_cy_two").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_py_one") != null){
        	total_jb_py_one = responseDTO.getValue("total_jb_py_one").substring(0,responseDTO.getValue("total_jb_py_one").indexOf("."));
        }
        if(responseDTO.getValue("total_jb_py_two") != null){
        	total_jb_py_two = responseDTO.getValue("total_jb_py_two").substring(0,responseDTO.getValue("total_jb_py_two").indexOf("."));
        }
        
        if(responseDTO.getValue("measureType") != null){
        	measureType = responseDTO.getValue("measureType");
        }
        if(responseDTO.getValue("projectName") != null){
        	projectName = responseDTO.getValue("projectName");
        }
    	
    	if(datas!=null){
    		String[] titles = {"高原I类","高原II类","高原III类","高原Ⅳ类","山地I类","山地II类","海滩沼泽I类","海滩沼泽II类","海滩沼泽III类","海滩沼泽Ⅳ类","沙漠I类","沙漠II类","沙漠III类","黄土塬I类","黄土塬II类","戈壁草原I类","戈壁草原II类","平原I类","平原II类"};
    		String[] names={"jb_gy_one","jb_gy_two","jb_gy_three","jb_gy_four","jb_mountain_one","jb_mountain_two","jb_zz_one","jb_zz_two","jb_zz_three","jb_zz_four","jb_desert_one","jb_desert_two","jb_desert_three","jb_hty_one","jb_hty_two","jb_cy_one","jb_cy_two","jb_py_one","jb_py_two"};
    		String[] totalValues={total_jb_gy_one,total_jb_gy_two,total_jb_gy_three,total_jb_gy_four,total_jb_mountain_one,total_jb_mountain_two,total_jb_zz_one,total_jb_zz_two,total_jb_zz_three,total_jb_zz_four,total_jb_desert_one,total_jb_desert_two,total_jb_desert_three,total_jb_hty_one,total_jb_hty_two,total_jb_cy_one,total_jb_cy_two,total_jb_py_one,total_jb_py_two};
    		 
    		HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet("data");//建立新的sheet对象
    		
    		HSSFCellStyle style_center = wb.createCellStyle();
    		style_center.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		
    		HSSFRow row0 = sheet.createRow((short)0);//建立第一行
    		HSSFCell cell0 = row0.createCell(0);  //建立第一列
    		cell0.setCellStyle(style_center);
    		if("0".equals(measureType)){
    			excelTitle = projectName+"测算表";
    		}else if("1".equals(measureType)){
    			excelTitle = projectName+"确认表";
    		}   
    		
    		String fileName = new String( excelTitle.getBytes("GBK"), "ISO8859-1");
    		cell0.setCellValue(excelTitle);
    		Region  rg = new Region(0,(short)0,0,(short)18);
    		sheet.addMergedRegion(rg);
    		
//    		HSSFRow row1 = sheet.createRow((short)1);//建立第二行
//    		for(int j=0;j<names.length;j++){
//    			HSSFCell cell = row1.createCell(j);//建立新cell
//    			if(j == 0){
//    				cell.setCellValue("检波线(公里)");
//    			}else if(j == 9){
//    				cell.setCellValue("炮线(公里)");
//    			}
//    			cell.setCellStyle(style_center);
//				//sheet.setColumnWidth(j, 6000);
//    		}

    		//Region  rg1 = new Region(1,(short)0,1,(short)8);
    		//Region  rg2 = new Region(1,(short)9,1,(short)18);
    		//sheet.addMergedRegion(rg1);
    		//sheet.addMergedRegion(rg2);
    		
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		//style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平布局：居中
    		
    		HSSFRow row2 = sheet.createRow((short)1);//建立第三行
    		// 建立表头
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row2.createCell(j);//建立新cell
				cell.setCellValue(titles[j]);
				cell.setCellStyle(style);
				//sheet.setColumnWidth(j, 6000);
    		}
    		
    		// 建立具体数据
    		for(int i=0;i<datas.size();i++){
    			MsgElement data = datas.get(i);
    			Map map = data.toMap();
    			HSSFRow row = sheet.createRow((short)(i+2));//建立新行
    			for(int j=0;j<titles.length;j++){
    				HSSFCell cell = row.createCell(j);//建立新cell
    				cell.setCellValue(map.get(names[j]).toString());
    			}
    		}
    		
    		//最后一行的累加数据
    		HSSFRow row_last = sheet.createRow((short)(datas.size()+2));//建立最后一行
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row_last.createCell(j);//建立新cell
				cell.setCellValue(totalValues[j]);
				//sheet.setColumnWidth(j, 6000);
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

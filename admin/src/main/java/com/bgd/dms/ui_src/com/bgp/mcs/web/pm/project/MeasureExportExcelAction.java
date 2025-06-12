package com.bgp.mcs.web.pm.project;

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
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;

public class MeasureExportExcelAction extends WSAction {
    @SuppressWarnings("deprecation")
	public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	
    	System.out.println("in the action");
    	
    	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
    	
    	List<MsgElement> datas = responseDTO.getMsgElements("showMeasureList");
    	
    	//��ȡ���������
    	String total_jb_mountain_one = "";
    	String total_jb_mountain_two = "";
    	String total_jb_mountain_three = "";
    	String total_jb_desert_small = "";
    	String total_jb_desert_big = "";
    	String total_jb_sw_zz = "";
    	String total_jb_yzw_nt = "";
    	String total_jb_wzw_nt = "";   	
    	String total_px_mountain_one = "";
    	String total_px_mountain_two = "";
    	String total_px_mountain_three = "";
    	String total_px_desert_small = "";
    	String total_px_desert_big = "";
    	String total_px_sw_zz = "";
    	String total_px_yzw_nt = "";
    	String total_px_wzw_nt = "";
    	String measureType = "";
    	String projectName = "";
    	String excelTitle = "";
    	
        if(responseDTO.getValue("total_jb_mountain_one") != null && !"0.0".equals(responseDTO.getValue("total_jb_mountain_one").toString())){
        	total_jb_mountain_one = responseDTO.getValue("total_jb_mountain_one");
        }
        if(responseDTO.getValue("total_jb_mountain_two") != null && !"0.0".equals(responseDTO.getValue("total_jb_mountain_two").toString())){
        	total_jb_mountain_two = responseDTO.getValue("total_jb_mountain_two");
        }
        if(responseDTO.getValue("total_jb_mountain_three") != null && !"0.0".equals(responseDTO.getValue("total_jb_mountain_three").toString())){
        	total_jb_mountain_three = responseDTO.getValue("total_jb_mountain_three");
        }
        if(responseDTO.getValue("total_jb_desert_small") != null && !"0.0".equals(responseDTO.getValue("total_jb_desert_small").toString())){
        	total_jb_desert_small = responseDTO.getValue("total_jb_desert_small");
        }
        if(responseDTO.getValue("total_jb_desert_big") != null && !"0.0".equals(responseDTO.getValue("total_jb_desert_big").toString())){
        	total_jb_desert_big = responseDTO.getValue("total_jb_desert_big");
        }
        if(responseDTO.getValue("total_jb_sw_zz") != null && !"0.0".equals(responseDTO.getValue("total_jb_sw_zz").toString())){
        	total_jb_sw_zz = responseDTO.getValue("total_jb_sw_zz");
        }
        if(responseDTO.getValue("total_jb_yzw_nt") != null && !"0.0".equals(responseDTO.getValue("total_jb_yzw_nt").toString())){
        	total_jb_yzw_nt = responseDTO.getValue("total_jb_yzw_nt");
        }
        if(responseDTO.getValue("total_jb_wzw_nt") != null && !"0.0".equals(responseDTO.getValue("total_jb_wzw_nt").toString())){
        	total_jb_wzw_nt = responseDTO.getValue("total_jb_wzw_nt");
        }        
        if(responseDTO.getValue("total_px_mountain_one") != null && !"0.0".equals(responseDTO.getValue("total_px_mountain_one").toString())){
        	total_px_mountain_one = responseDTO.getValue("total_px_mountain_one");
        }
        if(responseDTO.getValue("total_px_mountain_two") != null && !"0.0".equals(responseDTO.getValue("total_px_mountain_two").toString())){
        	total_px_mountain_two = responseDTO.getValue("total_px_mountain_two");
        }
        if(responseDTO.getValue("total_px_mountain_three") != null && !"0.0".equals(responseDTO.getValue("total_px_mountain_three").toString())){
        	total_px_mountain_three = responseDTO.getValue("total_px_mountain_three");
        }
        if(responseDTO.getValue("total_px_desert_small") != null && !"0.0".equals(responseDTO.getValue("total_px_desert_small").toString())){
        	total_px_desert_small = responseDTO.getValue("total_px_desert_small");
        }
        if(responseDTO.getValue("total_px_desert_big") != null && !"0.0".equals(responseDTO.getValue("total_px_desert_big").toString())){
        	total_px_desert_big = responseDTO.getValue("total_px_desert_big");
        }
        if(responseDTO.getValue("total_px_sw_zz") != null && !"0.0".equals(responseDTO.getValue("total_px_sw_zz").toString())){
        	total_px_sw_zz = responseDTO.getValue("total_px_sw_zz");
        }
        if(responseDTO.getValue("total_px_yzw_nt") != null && !"0.0".equals(responseDTO.getValue("total_px_yzw_nt").toString())){
        	total_px_yzw_nt = responseDTO.getValue("total_px_yzw_nt");
        }
        if(responseDTO.getValue("total_px_wzw_nt") != null && !"0.0".equals(responseDTO.getValue("total_px_wzw_nt").toString())){
        	total_px_wzw_nt = responseDTO.getValue("total_px_wzw_nt");
        }
        if(responseDTO.getValue("measureType") != null){
        	measureType = responseDTO.getValue("measureType");
        }
        if(responseDTO.getValue("projectName") != null){
        	projectName = responseDTO.getValue("projectName");
        }
    	
    	if(datas!=null){
    		String[] titles = {"���ߺ�","ɽ��I��","ɽ��II��","ɽ��III��","ɳĮСɳ","ɳĮ��ɳ","ˮ��������","��ũ����ũ�������","������ũ�����ƽԭ","ɽ��I��","ɽ��II��","ɽ��III��","ɳĮСɳ","ɳĮ��ɳ","ˮ��������","��ũ����ũ�������","������ũ�����ƽԭ"};
    		String[] names={"line_no","jb_mountain_one","jb_mountain_two","jb_mountain_three","jb_desert_small","jb_desert_big","jb_sw_zz","jb_yzw_nt","jb_wzw_nt","px_mountain_one","px_mountain_two","px_mountain_three","px_desert_small","px_desert_big","px_sw_zz","px_yzw_nt","px_wzw_nt"};
    		String[] totalValues={"",total_jb_mountain_one,total_jb_mountain_two,total_jb_mountain_three,total_jb_desert_small,total_jb_desert_big,total_jb_sw_zz,total_jb_yzw_nt,total_jb_wzw_nt,total_px_mountain_one,total_px_mountain_two,total_px_mountain_three,total_px_desert_small,total_px_desert_big,total_px_sw_zz,total_px_yzw_nt,total_px_wzw_nt};
    		 
    		HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet("data");//�����µ�sheet����
    		
    		HSSFCellStyle style_center = wb.createCellStyle();
    		style_center.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		
    		HSSFRow row0 = sheet.createRow((short)0);//������һ��
    		HSSFCell cell0 = row0.createCell(0);  //������һ��
    		cell0.setCellStyle(style_center);
    		if("0".equals(measureType)){
    			excelTitle = projectName+"�����";
    		}else if("1".equals(measureType)){
    			excelTitle = projectName+"ȷ�ϱ�";
    		}   
    		
    		String fileName = new String( excelTitle.getBytes("GBK"), "ISO8859-1");
    		cell0.setCellValue(excelTitle);
    		Region  rg = new Region(0,(short)0,0,(short)16);
    		sheet.addMergedRegion(rg);
    		
    		HSSFRow row1 = sheet.createRow((short)1);//�����ڶ���
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row1.createCell(j);//������cell
    			if(j == 0){
    				cell.setCellValue("�첨��(����)");
    			}else if(j == 9){
    				cell.setCellValue("����(����)");
    			}
    			cell.setCellStyle(style_center);
				//sheet.setColumnWidth(j, 6000);
    		}

    		Region  rg1 = new Region(1,(short)0,1,(short)8);
    		Region  rg2 = new Region(1,(short)9,1,(short)16);
    		sheet.addMergedRegion(rg1);
    		sheet.addMergedRegion(rg2);
    		
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		//style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // ˮƽ���֣�����
    		
    		HSSFRow row2 = sheet.createRow((short)2);//����������
    		// ������ͷ
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row2.createCell(j);//������cell
				cell.setCellValue(titles[j]);
				cell.setCellStyle(style);
				//sheet.setColumnWidth(j, 6000);
    		}
    		
    		// ������������
    		for(int i=0;i<datas.size();i++){
    			MsgElement data = datas.get(i);
    			Map map = data.toMap();
    			HSSFRow row = sheet.createRow((short)(i+3));//��������
    			for(int j=0;j<titles.length;j++){
    				HSSFCell cell = row.createCell(j);//������cell
    				cell.setCellValue(map.get(names[j]).toString());
    			}
    		}
    		
    		//���һ�е��ۼ�����
    		HSSFRow row_last = sheet.createRow((short)(datas.size()+3));//�������һ��
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row_last.createCell(j);//������cell
				cell.setCellValue(totalValues[j]);
				//sheet.setColumnWidth(j, 6000);
    		}
    		
			// ���� response ������
			response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// ���� response ��ʾ��ͷ
			response.setHeader("Content-Disposition","attachment;  filename=" + fileName + ".xls");
			
			OutputStream os = response.getOutputStream();
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
    	}
    	
    	return null;
    }
}

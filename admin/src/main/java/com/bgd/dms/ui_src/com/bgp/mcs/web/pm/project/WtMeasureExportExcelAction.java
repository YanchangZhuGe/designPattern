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
 * �ۺ��ﻯ̽�������㵼��Excel
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
    	
    	//��ȡ���������
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
    		String[] titles = {"��ԭI��","��ԭII��","��ԭIII��","��ԭ����","ɽ��I��","ɽ��II��","��̲����I��","��̲����II��","��̲����III��","��̲�������","ɳĮI��","ɳĮII��","ɳĮIII��","����ܫI��","����ܫII��","��ڲ�ԭI��","��ڲ�ԭII��","ƽԭI��","ƽԭII��"};
    		String[] names={"jb_gy_one","jb_gy_two","jb_gy_three","jb_gy_four","jb_mountain_one","jb_mountain_two","jb_zz_one","jb_zz_two","jb_zz_three","jb_zz_four","jb_desert_one","jb_desert_two","jb_desert_three","jb_hty_one","jb_hty_two","jb_cy_one","jb_cy_two","jb_py_one","jb_py_two"};
    		String[] totalValues={total_jb_gy_one,total_jb_gy_two,total_jb_gy_three,total_jb_gy_four,total_jb_mountain_one,total_jb_mountain_two,total_jb_zz_one,total_jb_zz_two,total_jb_zz_three,total_jb_zz_four,total_jb_desert_one,total_jb_desert_two,total_jb_desert_three,total_jb_hty_one,total_jb_hty_two,total_jb_cy_one,total_jb_cy_two,total_jb_py_one,total_jb_py_two};
    		 
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
    		Region  rg = new Region(0,(short)0,0,(short)18);
    		sheet.addMergedRegion(rg);
    		
//    		HSSFRow row1 = sheet.createRow((short)1);//�����ڶ���
//    		for(int j=0;j<names.length;j++){
//    			HSSFCell cell = row1.createCell(j);//������cell
//    			if(j == 0){
//    				cell.setCellValue("�첨��(����)");
//    			}else if(j == 9){
//    				cell.setCellValue("����(����)");
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
    		//style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // ˮƽ���֣�����
    		
    		HSSFRow row2 = sheet.createRow((short)1);//����������
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
    			HSSFRow row = sheet.createRow((short)(i+2));//��������
    			for(int j=0;j<titles.length;j++){
    				HSSFCell cell = row.createCell(j);//������cell
    				cell.setCellValue(map.get(names[j]).toString());
    			}
    		}
    		
    		//���һ�е��ۼ�����
    		HSSFRow row_last = sheet.createRow((short)(datas.size()+2));//�������һ��
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

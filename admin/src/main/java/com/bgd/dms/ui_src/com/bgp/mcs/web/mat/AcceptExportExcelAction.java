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
    		String[] titles = {"���ʱ���","����˵��","������λ","����","����","���"};
    		String[] names={"wz_id","wz_name","wz_prickie","mat_num","wz_price","total_money"};
    		MsgElement headData = datas.get(0);
			Map headMap = headData.toMap();
			System.out.println(headMap);
    		HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet("data");//�����µ�sheet����
    		
    		HSSFRow row0 = sheet.createRow((short)0);//��������
    		row0.setHeight((short) 400);
    		
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // ˮƽ���֣�����
    		//sheet.addMergedRegion(new Region(0, (short) 0, 0, (short) colSum));
    		
//    		HSSFCellStyle borderStyle = wb.createCellStyle();
//    		borderStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);// �±߿�   
//    		borderStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);// ��߿�   
//    		borderStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);// �ұ߿�   
//    		borderStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);// �ϱ߿�   

    		
    		// ������ͷ
    		HSSFCell cell0 = row0.createCell(0);
    		sheet.addMergedRegion(new Region(0, (short) 0, 0,(short) 10));
    		cell0.setCellValue(""+headMap.get("org_abbreviation")+"��ⵥ");
    		cell0.setCellStyle(style);
    		
    		HSSFRow row1 = sheet.createRow((short)1);//��������
    		sheet.addMergedRegion(new Region(1, (short) 0, 1,(short) 10));
    		HSSFCell cell1 = row1.createCell(0);
    		String cellData1="     �����Ŀ��"+headMap.get("project_name")+"                                          ���ʱ�䣺"+headMap.get("input_date")+"                                 ��ⵥ�ţ�"+headMap.get("invoices_no")+"";
    		cell1.setCellValue(cellData1);
    		/*
    		HSSFRow row2 = sheet.createRow((short)2);//��������
    		sheet.addMergedRegion(new Region(2, (short) 0, 2,(short) 10));
    		HSSFCell cell2 = row2.createCell(0);
    		cell2.setCellValue("     ���ϵ�λ��"+headMap.get("tname")+"                                                                                           ������"+headMap.get("numbers")+"");
    		*/
    		HSSFRow row3 = sheet.createRow((short)3);//��������
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row3.createCell(j);//������cell
				cell.setCellValue(titles[j]);
				cell.setCellStyle(style);
				//sheet.setColumnWidth(j, 6000);
    		}
    		// ������������
    		for(int i=0;i<datas.size();i++){
    			MsgElement data = datas.get(i);
    			Map map = data.toMap();
    			HSSFRow row = sheet.createRow((short)(i+4));//��������
    			
    			for(int j=0;j<titles.length;j++){
    				HSSFCell cell = row.createCell(j);//������cell
    				cell.setCellValue(map.get(names[j]).toString());
    			}
    		}
    		int num = datas.size()+4;
    		
    		HSSFRow rowEnd = sheet.createRow((short)(num));//��������
    		HSSFCell cellEnd0 = rowEnd.createCell(0);
    		HSSFCell cellEnd5 = rowEnd.createCell(5);
    		cellEnd0.setCellValue("�ϼƣ�");
    		cellEnd5.setCellValue(""+headMap.get("allmoney")+"");
    		HSSFRow row = sheet.createRow((short)(num+1));//��������
    		sheet.addMergedRegion(new Region(num+1, (short) 0, num+1,(short) 10));
    		HSSFCell cell = row.createCell(0);
    		cell.setCellValue("��ƱԱ��"+headMap.get("operator")+"                                                                          ����Ա: "+headMap.get("storage")+"                                                ������:"+headMap.get("pickupgoods")+"          ");
//    		
//    		// �����п��Զ� 
    		for(int j=0;j<titles.length;j++){
				sheet.autoSizeColumn(j); // �Զ������п�
				//sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*0.5)); // �����п�Ϊ�Զ�ֵ��1.5��
   		   }
    		
			// ���� response ������
			response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// ���� response ��ʾ��ͷ
//			response.setHeader("Content-Disposition","attachment;  filename=" + "wzOut" + ".xls");
			response.setHeader("Content-Disposition","attachment;  filename=" +URLEncoder.encode("��ⵥ", "utf-8") + ".xls");
			
			
			
			OutputStream os = response.getOutputStream();
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
    	}
    	
    	return null;
    }
}

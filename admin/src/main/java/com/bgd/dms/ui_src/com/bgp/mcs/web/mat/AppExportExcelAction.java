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
    		String[] titles = {"���ʱ���","���ʷ�����","����","������λ","�ο�����","��������","��������","�ɵ�������","�ϼ�������","�ƻ����","��������","����˵��"};
    		String[] names={"wz_id","coding_code_id","wz_name","wz_prickie","wz_price","demand_num","have_num","regulate_num","apply_num","plan_money","compile_date","code_desc"};
    		
    		HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet("data");//�����µ�sheet����
    		
    		HSSFRow row0 = sheet.createRow((short)0);//��������
    		
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		//style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // ˮƽ���֣�����
    		
    		// ������ͷ
    		for(int j=0;j<names.length;j++){
    			HSSFCell cell = row0.createCell(j);//������cell
				cell.setCellValue(titles[j]);
				cell.setCellStyle(style);
				//sheet.setColumnWidth(j, 6000);
    		}
    		
    		// ������������
    		for(int i=0;i<datas.size();i++){
    			MsgElement data = datas.get(i);
    			Map map = data.toMap();
    			HSSFRow row = sheet.createRow((short)(i+1));//��������
    			for(int j=0;j<titles.length;j++){
    				HSSFCell cell = row.createCell(j);//������cell
    				System.out.println(map.get(names[j]).toString());
    				cell.setCellValue(map.get(names[j]).toString());
    			}
    		}
//    		
//    		// �����п��Զ� 
//    		for(int j=0;j<titles.length;j++){
//				sheet.autoSizeColumn(j); // �Զ������п�
//				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // �����п�Ϊ�Զ�ֵ��1.5��
//    		}
    		
			// ���� response ������
			response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// ���� response ��ʾ��ͷ
			response.setHeader("Content-Disposition","attachment;  filename=" + "wzPlan" + ".xls");
			
			OutputStream os = response.getOutputStream();
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
    	}
    	
    	return null;
    }
}

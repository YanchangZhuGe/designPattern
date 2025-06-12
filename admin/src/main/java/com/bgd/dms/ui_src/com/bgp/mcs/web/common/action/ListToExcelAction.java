package com.bgp.mcs.web.common.action;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

public class ListToExcelAction extends WSAction {

	public ListToExcelAction()
    {
    }

    public ActionForward servieCall(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
        throws Exception
    {
        ServiceCallConfig servicecallconfig = new ServiceCallConfig();
        servicecallconfig.setServiceName(request.getParameter("JCDP_SRV_NAME"));
        servicecallconfig.setOperationName(request.getParameter("JCDP_OP_NAME"));

        ISrvMsg isrvmsg;
        if((isrvmsg = SrvMsgUtil.createISrvMsg(servicecallconfig.getOperationName())) == null)
        {
            return null;
        } else
        {
            setDTOValue(isrvmsg, mapping, form, request, response);
            ISrvMsg isrvmsg1 = ServiceCallFactory.getIServiceCall().callWithDTO(request, isrvmsg, servicecallconfig);
            request.setAttribute("responseDTO", isrvmsg1);
            return null;
        }
    }
    
    public ActionForward executeResponse(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception{
    	
    	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
    	
    	List<MsgElement> datas = responseDTO.getMsgElements("datas");
    	
    	String JCDP_COLUMN_EXP = request.getParameter("JCDP_COLUMN_EXP");
		String JCDP_COLUMN_TITLE = request.getParameter("JCDP_COLUMN_TITLE");
		
		String excelName = UUID.randomUUID().toString()+".xls";
		
    	if(datas!=null && (JCDP_COLUMN_EXP!=null && !JCDP_COLUMN_EXP.equals(""))){
    		JCDP_COLUMN_TITLE = URLDecoder.decode(JCDP_COLUMN_TITLE, "utf-8");
    		String JCDP_FILE_NAME = request.getParameter("JCDP_FILE_NAME");
    		if(JCDP_FILE_NAME==null || JCDP_FILE_NAME.equals("")){
    			JCDP_FILE_NAME="����";
    		}else{
    			JCDP_FILE_NAME = URLDecoder.decode(JCDP_FILE_NAME, "utf-8");
    		}
    		JCDP_FILE_NAME = JCDP_FILE_NAME.replaceAll("\\/|\\\\", "");
    		
    		HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet(JCDP_FILE_NAME);//�����µ�sheet����
    		
    		String[] exps = JCDP_COLUMN_EXP.split(",");
    		String[] titles = JCDP_COLUMN_TITLE.split(",");
    		HSSFRow row0 = sheet.createRow((short)0);//��������
    		
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		//font.setTypeOffset(XSSFFont.SS_SUPER);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		//style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // ˮƽ���֣�����
    		
    		// ������ͷ
    		for(int j=0;j<titles.length;j++){
    			HSSFCell cell = row0.createCell(j);//������cell
				cell.setCellValue(titles[j]);
				cell.setCellStyle(style);
				//sheet.setColumnWidth(j, 6000);
    		}
    		
    		// ������������
    		for(int i=0;i<datas.size();i++){
    			MsgElement data = datas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+1));//��������
    			for(int j=0;j<exps.length;j++){
    				HSSFCell cell = row.createCell(j);//������cell
    				// 1209 zxh add 
    				if(data.getValue(exps[j])!=null&&data.getValue(exps[j]).contains("&sup")){
    					
    					HSSFFont font1 = wb.createFont();
    		    		font1.setFontHeightInPoints((short)11);
    		    		font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		    		font1.setTypeOffset(XSSFFont.SS_SUPER);
    		    		String datatemp = data.getValue(exps[j]);
    		    		int supindex = datatemp.indexOf("&sup");
    		    		int strlength = datatemp.length();
    		    		
    		    		datatemp = datatemp.replace("&sup", "");
		    			HSSFRichTextString rts = new HSSFRichTextString(datatemp);
    		    		
    		    		if((supindex+1+4)!=strlength){
    		    			rts.applyFont(supindex, supindex+1, font1);
    		    		}
    		    		cell.setCellValue(rts);
    					
    				}else{
    					cell.setCellValue(data.getValue(exps[j]));
    				}
    			}
    		}
    		
    		// �����п��Զ� 
    		for(int j=0;j<titles.length;j++){
				sheet.autoSizeColumn(j); // �Զ������п�
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // �����п�Ϊ�Զ�ֵ��1.5��
    		}
    		
			// ���� response ������
			//response.setContentType("application/vnd.ms-excel;  charset=utf-8");
			
			// ���� response ��ʾ��ͷ
			//response.setHeader("Content-Disposition","attachment;  filename=" + java.net.URLEncoder.encode(JCDP_FILE_NAME, "utf-8") + ".xls");
			
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
    	}
    	
    	response.setContentType("text/json; charset=utf-8");
    	
    	String ret="{returnCode:0, excelName:'"+excelName+"'}";
    	
    	response.getWriter().write(ret);
    	
    	return null;
    }
    
  
}

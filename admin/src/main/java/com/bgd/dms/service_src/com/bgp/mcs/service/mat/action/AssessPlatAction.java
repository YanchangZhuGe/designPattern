package com.bgp.mcs.service.mat.action;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.soap.SOAPException;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * ����ģ�鵼��Excel Action������
 * @author wangzheqin 2015.4.7
 *
 */
public class AssessPlatAction extends WSAction{
	
	/**
	 * ��׼������
	 */
	@Override
	public ActionForward servieCall(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
        servicecallconfig.setServiceName("MatItemSrv");
        servicecallconfig.setOperationName("getExcelData");
        
        ISrvMsg isrvmsg;
        if((isrvmsg = SrvMsgUtil.createISrvMsg(servicecallconfig.getOperationName())) == null)
        {
            return null;
        } else
        {
            setDTOValue(isrvmsg, mapping, form, request, response);
            //����������������ͳһ����
            ISrvMsg isrvmsg1 = ServiceCallFactory.getIServiceCall().callWithDTO(null, isrvmsg, servicecallconfig);
            request.setAttribute("responseDTO", isrvmsg1);
            return null;
        }
	}
	
	/**
	 * ���������
	 */
	@Override
	public ActionForward executeResponse(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
		//��ô�ӡ���ĵ����
		String doctype = responseDTO.getValue("doctype");
		String excelName = null;
		//����������������� 
		if("gbzwzxh".equals(doctype)){
			excelName = createCommonExcel(responseDTO,2);
		}
		
		response.setContentType("text/json; charset=utf-8");
    	
    	String ret="{returnCode:0, excelName:'"+excelName+"',showName:'"+excelName+"'}";
    	
    	response.getWriter().write(ret);
    	  
    	return null;
	}
	
	/**
	 * ����excel
	 * @param responseDTO
	 * @param times �п���
	 * @return
	 * @throws Exception
	 */
	private String createCommonExcel(ISrvMsg responseDTO,double times) throws Exception {
		
		String excelName = responseDTO.getValue("excelName");//excel����
		String title = responseDTO.getValue("title");//excel����
		List excelHeader = responseDTO.getValues("excelHeader");//excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");//excel����
		String sheetName = title;
		if(CollectionUtils.isNotEmpty(excelHeader)){
			Workbook wb = new HSSFWorkbook();//������HSSFWorkbook���� 
			Sheet sheet = wb.createSheet(sheetName);//�����µ�sheet����
			//������
			Row titleRow = sheet.createRow(0);//��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0,0,0,excelHeader.size()-1));
			//��ͷ
			Row headerRow = sheet.createRow(1);
			Cell hcell=null;
			
			for(int i=0;i<excelHeader.size();i++){
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			//������
			Row dataRow =null;
			//д������
			MsgElement data=null;
			if(CollectionUtils.isNotEmpty(excelData)){
	    		for(int i=0;i<excelData.size();i++){
	    			//������ǰ��
	    			dataRow = sheet.createRow(2+i);
	    			//��ȡ����
	    			data=excelData.get(i);
	    			for(int j=0;j<excelHeader.size();j++){
	    				//������Ԫ��
	    				Cell dCell=dataRow.createCell(j);
	    				//������ʽ
	    				dCell.setCellStyle(setExcelCommonStyle(wb));
	    				//��д������
						String key=("excel_column_val"+j).trim();
						if(null!=data.getValue(key) && StringUtils.isNotBlank(data.getValue(key).toString())){
		    				dCell.setCellValue(data.getValue(key).toString());
						}
	    			}
	    		}
			}
			// �����п�
			setColumnWidth(sheet,excelHeader.size(),times);
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}
	
	/**
	 * �����п�
	 * @param sheet
	 * @param columnSize
	 * @param times
	 */
	public void setColumnWidth(Sheet sheet, int columnSize , double times) {
		for (int i = 0; i < columnSize; i++) {
			// �Զ������п�
			sheet.autoSizeColumn(i, true);
			// �����п�Ϊ�Զ�ֵ��1.5��
			sheet.setColumnWidth(i, (int) (sheet.getColumnWidth(i) * times));
		}
	}
	
	/**
	 * ���ñ�����ʽ
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelTitleStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // ������Ԫ����ʽ
		// ���õ�Ԫ��ˮƽ������䷽ʽ
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// ���õ�Ԫ��ֱ������䷽ʽ
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// ��������
		Font font = wb.createFont();
		font.setFontHeightInPoints((short) 16);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("����");
		// ����������ʽ
		cellStyle.setFont(font);
		return cellStyle;
	}

	/**
	 * �豸��ͷ��ʽ
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelHearderStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // ������Ԫ����ʽ
		// ���õ�Ԫ��ˮƽ������䷽ʽ
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// ���õ�Ԫ��ֱ������䷽ʽ
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// ��������
		Font font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("����");
		// ����������ʽ
		cellStyle.setFont(font);
		// ���ñ߿�
		cellStyle.setBorderTop(CellStyle.BORDER_THIN); // �ϱ߱߿�
		cellStyle.setBorderRight(CellStyle.BORDER_THIN); // �ұ߱߿� 
		cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // �ײ��߿�
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN);  // ��߱߿�
		return cellStyle;
	}
	
	/**
	 * ���õ�Ԫ����ʽ
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelCommonStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // ������Ԫ����ʽ
		// ���õ�Ԫ��ˮƽ������䷽ʽ
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// ���õ�Ԫ��ֱ������䷽ʽ
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// ���ñ߿�
		cellStyle.setBorderTop(CellStyle.BORDER_THIN); // �ϱ߱߿�
		cellStyle.setBorderRight(CellStyle.BORDER_THIN); // �ұ߱߿� 
		cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // �ײ��߿�
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN);  // ��߱߿�
		return cellStyle;
	}
	
}

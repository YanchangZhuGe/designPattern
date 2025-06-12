package com.bgp.gms.service.rm.dm.action;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.soap.SOAPException;

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
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

public class DMDocToExcelAction extends WSAction {
	/**
	 * ��׼������
	 */
	@Override
	public ActionForward servieCall(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
        servicecallconfig.setServiceName("DevCommInfoSrv");
        servicecallconfig.setOperationName("createDocFile");
        
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
		if("ZYTPD".equals(doctype)||"FHTPD".equals(doctype)){
			excelName = saveZYTPD(responseDTO);
		}else if("ZBTPD".equals(doctype)||"ZBTPD_PL".equals(doctype)||"JBQ_PL".equals(doctype)){
			excelName = saveZBTPD(responseDTO);
		}else if("ZBCKD".equals(doctype)){
			excelName = saveZBDTCKD(responseDTO);
		}else if("ZBCKD_PL".equals(doctype)){
			excelName = saveZBPLCKD(responseDTO);
		}
    	response.setContentType("text/json; charset=utf-8");
    	
    	String ret="{returnCode:0, excelName:'"+excelName+"',showName:'"+excelName+"'}";
    	
    	response.getWriter().write(ret);
    	
    	return null;
	}


	/**
	 * ����װ����excel �������ⵥ
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZBPLCKD(ISrvMsg responseDTO) throws SOAPException, IOException {
		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName = baseData.getValue("outinfo_no")+".xls";//UUID.randomUUID().toString()+".xls";
		
		if(baseData!=null){
			String sheetName = "���ⵥ";
			HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet(sheetName);//�����µ�sheet����
    		//�ڶ����Ǳ���
    		HSSFRow row1 = sheet.createRow((short)1);//��������
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)7));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("����");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//������ �� ������ �ǵ��ӻ�����Ϣ
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("����_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//��������
    		HSSFCell cell20 = row2.createCell(0);
    		cell20.setCellValue("ת����λ:");
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)0, 2, (short)1));
    		HSSFCell cell22 = row2.createCell(2);
    		if(baseData.getValue("devouttype").toString().equals("2")){
    			cell22.setCellValue(baseData.getValue("inorgname"));
    		}
    		else{
    			cell22.setCellValue(baseData.getValue("outorgname"));
    		}
    		cell22.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)2, 2, (short)3));
    		HSSFCell cell212 = row2.createCell(5);
    		cell212.setCellValue(baseData.getValue("outinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)5, 2, (short)7));
    		HSSFRow row3 = sheet.createRow((short)3);//��������
    		HSSFRow row4 = sheet.createRow((short)4);//��������
    		HSSFCell cell40 = row4.createCell(0);
    		cell40.setCellValue("ת�뵥λ:");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)0, 4, (short)1));
    		HSSFCell cell42 = row4.createCell(2);
    		if(baseData.getValue("devouttype").toString().equals("2")){
    			cell42.setCellValue(baseData.getValue("outorgname"));
    		}
    		else{
    			cell42.setCellValue(baseData.getValue("inorgname"));
    		}
    		cell42.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)2, 4, (short)3));
    		HSSFCell cell412 = row4.createCell(5);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)5, 4, (short)7));
    		HSSFRow row5 = sheet.createRow((short)5);//��������
    		
    		//д����
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"���","�豸����","�ͺż����","��λ",
    				"����","����״��","��ŵ�","��ע"};
    		// ������ͷ
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("����_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//��������
    		for(int j=0;j<8;j++){
    			HSSFCell cell = row6.createCell(j);//������cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// ������������
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("����");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//��������
    			//����16������
				HSSFCell detcell0 = row.createCell(0);//���
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//�豸����
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//����ͺ�
				detcell2.setCellValue(data.getValue("dev_model"));
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//��λ
				detcell3.setCellValue(data.getValue("unit_name"));
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//����
				detcell4.setCellValue(data.getValue("out_num"));
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//
				detcell5.setCellValue("");
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//
				detcell6.setCellValue("");
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//��ע
				detcell7.setCellValue("");
				detcell7.setCellStyle(rowdetcontent_Style);
    		}
    		//�����ڼ�д���߰������Ϣ
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("����_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//��������
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		cell_last10.setCellValue("�������ݣ�");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)3));
    		HSSFCell cell_last19 = row_last1.createCell(4);
    		cell_last19.setCellValue("�Ʊ�");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+7, (short)4, detSize+7, (short)7));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+8));//��������
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("������λ���ʲ��ƽ���)��");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)3));
    		HSSFCell cell_last39 = row_last3.createCell(4);
    		cell_last39.setCellValue("���뵥λ(�ʲ�������):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+8, (short)4, detSize+8, (short)7));
    		HSSFRow row_last5 = sheet.createRow((short)(detSize+9));//��������
    		HSSFCell cell_last50 = row_last5.createCell(0);
    		cell_last50.setCellValue("��λ�쵼��");
    		cell_last50.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+8, (short)4, detSize+9, (short)7));
    		// �����п��Զ� 
    		for(int j=0;j<titleArrays.length;j++){
				sheet.autoSizeColumn(j, true); // �Զ������п�
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // �����п�Ϊ�Զ�ֵ��1.5��
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}
	/**
	 * ����װ����excel���䵥
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZBDTCKD(ISrvMsg responseDTO) throws SOAPException, IOException {
		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName = baseData.getValue("outinfo_no")+".xls";//UUID.randomUUID().toString()+".xls";
		if(baseData!=null){
			String sheetName = "���ⵥ";
			HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet(sheetName);//�����µ�sheet����
    		//�ڶ����Ǳ���
    		HSSFRow row1 = sheet.createRow((short)1);//��������
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)15));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("����");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//������ �� ������ �ǵ��ӻ�����Ϣ
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("����_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//��������
    		HSSFCell cell20 = row2.createCell(0);
    		cell20.setCellValue("ת����λ:");
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)0, 2, (short)1));
    		HSSFCell cell22 = row2.createCell(2);
    		cell22.setCellValue(baseData.getValue("outorgname"));
    		cell22.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)2, 2, (short)3));
    		HSSFCell cell212 = row2.createCell(12);
    		cell212.setCellValue(baseData.getValue("outinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)12, 2, (short)15));
    		HSSFRow row3 = sheet.createRow((short)3);//��������
    		HSSFRow row4 = sheet.createRow((short)4);//��������
    		HSSFCell cell40 = row4.createCell(0);
    		cell40.setCellValue("ת�뵥λ:");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)0, 4, (short)1));
    		HSSFCell cell42 = row4.createCell(2);
    		cell42.setCellValue(baseData.getValue("inorgname"));
    		cell42.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)2, 4, (short)3));
    		HSSFCell cell412 = row4.createCell(12);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)12, 4, (short)15));
    		HSSFRow row5 = sheet.createRow((short)5);//��������
    		
    		//д����
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"���","�豸����","�ͺż����","��λ",
    				"����","�ʲ����","ʵ���ʶ��","�Ա��","���պ�","���̺�",
    				"��ʻ֤","���ӷ�","Ӫ��֤","����״��","��ŵ�","��ע"};
    		// ������ͷ
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("����_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//��������
    		for(int j=0;j<16;j++){
    			HSSFCell cell = row6.createCell(j);//������cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// ������������
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("����");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//��������
    			//����16������
				HSSFCell detcell0 = row.createCell(0);//���
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//�豸����
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//����ͺ�
				detcell2.setCellValue(data.getValue("dev_model"));
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//��λ
				detcell3.setCellValue(data.getValue("unit_name"));
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//����
				detcell4.setCellValue("1");
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//�ʲ����
				detcell5.setCellValue(data.getValue("asset_coding"));
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//ʵ���ʶ��
				detcell6.setCellValue(data.getValue("dev_sign"));
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//�Ա��
				detcell7.setCellValue(data.getValue("self_num"));
				detcell7.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell8 = row.createCell(8);//ʵ���ʶ��
				detcell8.setCellValue(data.getValue("license_num"));
				detcell8.setCellStyle(rowdetcontent_Style);
				//������ȷſա�
				HSSFCell detcell9 = row.createCell(9);//
				detcell9.setCellValue("");
				detcell9.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell10 = row.createCell(10);//
				detcell10.setCellValue("");
				detcell10.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell11 = row.createCell(11);//
				detcell11.setCellValue("");
				detcell11.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell12 = row.createCell(12);//
				detcell12.setCellValue("");
				detcell12.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell13 = row.createCell(13);//
				detcell13.setCellValue("");
				detcell13.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell14 = row.createCell(14);//
				detcell14.setCellValue("");
				detcell14.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell15 = row.createCell(15);//
				detcell15.setCellValue("");
				detcell15.setCellStyle(rowdetcontent_Style);
    		}
    		//�����ڼ�д���߰������Ϣ
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("����_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//��������
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		row_last1.createCell(4);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		row_last1.createCell(8);
    		cell_last10.setCellValue("�������ݣ�");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)8));
    		HSSFCell cell_last19 = row_last1.createCell(9);
    		cell_last19.setCellValue("�Ʊ�");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(10);
    		row_last1.createCell(11);
    		row_last1.createCell(12);
    		row_last1.createCell(13);
    		row_last1.createCell(14);
    		row_last1.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+7, (short)9, detSize+7, (short)15));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+8));//��������
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("������λ���ʲ��ƽ���)��");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		row_last3.createCell(4);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		row_last3.createCell(8);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)8));
    		HSSFCell cell_last39 = row_last3.createCell(9);
    		cell_last39.setCellValue("���뵥λ(�ʲ�������):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(10);
    		row_last3.createCell(11);
    		row_last3.createCell(12);
    		row_last3.createCell(13);
    		row_last3.createCell(14);
    		row_last3.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+9, (short)8, detSize+9, (short)15));
    		// �����п��Զ� 
    		for(int j=2;j<9;j++){
				sheet.autoSizeColumn(j, true); // �Զ������п�
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // �����п�Ϊ�Զ�ֵ��1.5��
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
		}
		return excelName;
	}
	/**
	 * ����װ����excel���䵥
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZBTPD(ISrvMsg responseDTO) throws SOAPException, IOException {
		String doctype = responseDTO.getValue("doctype");
		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName = baseData.getValue("mixinfo_no")+".xls";//UUID.randomUUID().toString()+".xls";
		if(baseData!=null){
			String sheetName = "���䵥";
			HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet(sheetName);//�����µ�sheet����
    		//��һ�в�����䵥�Ļ�������
    		HSSFRow row0 = sheet.createRow((short)0);//��������
    		HSSFCell cell0 = row0.createCell(0);
    		if(!"JBQ_PL".equals(doctype)){
    			cell0.setCellValue("װ�������豸���ʿ�");
    		}
    		sheet.addMergedRegion(new Region(0, (short)0, 0, (short)7));
    		HSSFFont row0_font = wb.createFont();
    		row0_font.setFontHeightInPoints((short)16);
    		row0_font.setFontName("����_GB2312");
    		HSSFCellStyle row0_style = wb.createCellStyle();
    		row0_style.setFont(row0_font);
    		row0_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell0.setCellStyle(row0_style);
    		//�ڶ����Ǳ���
    		HSSFRow row1 = sheet.createRow((short)1);//��������
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)7));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("����");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//������ �� ������ �ǵ��ӻ�����Ϣ
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("����_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//��������
    		HSSFCell cell20 = row2.createCell(0);
    		cell20.setCellValue(baseData.getValue("outorgname"));
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)0, 2, (short)1));
    		HSSFCell cell212 = row2.createCell(6);
    		cell212.setCellValue(baseData.getValue("mixinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)6, 2, (short)7));
    		HSSFRow row3 = sheet.createRow((short)3);//��������
    		HSSFRow row4 = sheet.createRow((short)4);//��������
    		HSSFCell cell40 = row4.createCell(0);
    		cell40.setCellValue("�Ƚ����й̶��ʲ�����");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)0, 4, (short)1));
    		HSSFCell cell43 = row4.createCell(2);
    		cell43.setCellValue(baseData.getValue("inorgname"));
    		cell43.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)2, 4, (short)3));
    		HSSFCell cell46 = row4.createCell(4);
    		cell46.setCellValue("ʹ��(����)");
    		cell46.setCellStyle(row3_style);
    		HSSFCell cell412 = row4.createCell(6);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)6, 4, (short)7));
    		HSSFRow row5 = sheet.createRow((short)5);//��������
    		
    		//д����
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"���","�豸����","�ͺż����","��λ",
    				"����","����״��","��ŵ�","��ע"};
    		// ������ͷ
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("����_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//��������
    		for(int j=0;j<8;j++){
    			HSSFCell cell = row6.createCell(j);//������cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// ������������
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("����");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//��������
    			//����16������
				HSSFCell detcell0 = row.createCell(0);//���
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//�豸����
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//����ͺ�
				if("ZBTPD_PL".equals(doctype)||"JBQ_PL".equals(doctype)||"ZBTPD".equals(doctype)){
					detcell2.setCellValue(data.getValue("dev_model"));
				}else{
					detcell2.setCellValue("");
				}
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//��λ
				if("ZBTPD_PL".equals(doctype)||"JBQ_PL".equals(doctype)){
					detcell3.setCellValue(data.getValue("unit_name"));
				}else{
					detcell3.setCellValue("");//(data.getValue("unit_name"));
				}
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//����
				detcell4.setCellValue(data.getValue("assign_num"));
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//
				detcell5.setCellValue("");
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//
				detcell6.setCellValue("");
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//��ע
				detcell7.setCellValue("");
				detcell7.setCellStyle(rowdetcontent_Style);
    		}
    		//�����ڼ�д���߰������Ϣ
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("����_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//��������
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		cell_last10.setCellValue("�������ݣ�");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)3));
    		HSSFCell cell_last19 = row_last1.createCell(4);
    		cell_last19.setCellValue("�豸���ʲ������ˣ���������");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+7, (short)4, detSize+7, (short)7));
    		HSSFRow row_last2 = sheet.createRow((short)(detSize+8));//��������
    		HSSFCell cell_last20 = row_last2.createCell(0);
    		cell_last20.setCellValue("�豸������λ�쵼��ǩ�֣���");
    		cell_last20.setCellStyle(rowlast_Style);
    		row_last2.createCell(1);
    		row_last2.createCell(2);
    		row_last2.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)3));
    		HSSFCell cell_last29 = row_last2.createCell(4);
    		cell_last29.setCellValue("�Ʊ�");
    		cell_last29.setCellStyle(rowlast_Style);
    		row_last2.createCell(5);
    		row_last2.createCell(6);
    		row_last2.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+8, (short)4, detSize+8, (short)7));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+9));//��������
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("������λ���ʲ��ƽ���)��");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+9, (short)0, detSize+9, (short)3));
    		HSSFCell cell_last39 = row_last3.createCell(4);
    		cell_last39.setCellValue("���뵥λ(�ʲ�������):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+9, (short)4, detSize+9, (short)7));
    		// �����п��Զ� 
    		for(int j=0;j<titleArrays.length;j++){
				sheet.autoSizeColumn(j, true); // �Զ������п�
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // �����п�Ϊ�Զ�ֵ��1.5��
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
		}
		return excelName;
	}
	/**
	 * �������е�excel���䵥
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZYTPD(ISrvMsg responseDTO) throws SOAPException, IOException {

		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName =baseData.getValue("mixinfo_no")+".xls"; //UUID.randomUUID().toString()+".xls";
		if(baseData!=null){
			String sheetName = "���䵥";
			HSSFWorkbook wb = new HSSFWorkbook();//������HSSFWorkbook����  
    		HSSFSheet sheet = wb.createSheet(sheetName);//�����µ�sheet����
    		//��һ�в�����䵥�Ļ�������
    		HSSFRow row0 = sheet.createRow((short)0);//��������
    		HSSFCell cell0 = row0.createCell(0);
    		cell0.setCellValue(baseData.getValue("mixorgname"));
    		sheet.addMergedRegion(new Region(0, (short)0, 0, (short)15));
    		HSSFFont row0_font = wb.createFont();
    		row0_font.setFontHeightInPoints((short)16);
    		row0_font.setFontName("����_GB2312");
    		HSSFCellStyle row0_style = wb.createCellStyle();
    		row0_style.setFont(row0_font);
    		row0_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell0.setCellStyle(row0_style);
    		//�ڶ����Ǳ���
    		HSSFRow row1 = sheet.createRow((short)1);//��������
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)15));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("����");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//������ �� ������ �ǵ��ӻ�����Ϣ
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("����_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//��������
    		HSSFCell cell20 = row2.createCell(1);
    		cell20.setCellValue(baseData.getValue("outorgname"));
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)1, 2, (short)2));
    		HSSFCell cell212 = row2.createCell(12);
    		cell212.setCellValue(baseData.getValue("mixinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)12, 2, (short)15));
    		HSSFRow row3 = sheet.createRow((short)3);//��������
    		HSSFRow row4 = sheet.createRow((short)4);//��������
    		HSSFCell cell40 = row4.createCell(1);
    		cell40.setCellValue("�Ƚ����й̶��ʲ�����");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)1, 4, (short)3));
    		HSSFCell cell43 = row4.createCell(4);
    		cell43.setCellValue(baseData.getValue("inorgname"));
    		cell43.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)4, 4, (short)5));
    		HSSFCell cell46 = row4.createCell(6);
    		cell46.setCellValue("ʹ��(����)");
    		cell46.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)6, 4, (short)7));
    		HSSFCell cell412 = row4.createCell(12);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)12, 4, (short)15));
    		HSSFRow row5 = sheet.createRow((short)5);//��������
    		
    		//д����
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"���","�豸����","�ͺż����","�Ա��","���պ�",
    				"ʵ���ʶ��","�ʲ����","��λ","����","���̺�",
    				"��ʻ֤","���ӷ�","Ӫ��֤","����״��","��ŵ�","��ע"};
    		// ������ͷ
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("����_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//��������
    		for(int j=0;j<16;j++){
    			HSSFCell cell = row6.createCell(j);//������cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// ������������
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("����");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//��������
    			//����16������
    			HSSFCell detcell0 = row.createCell(0);//���
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//�豸����
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//����ͺ�
				detcell2.setCellValue(data.getValue("dev_model"));
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//�Ա��
				detcell3.setCellValue(data.getValue("self_num"));
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//ʵ���ʶ��
				detcell4.setCellValue(data.getValue("license_num"));
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//ʵ���ʶ��
				detcell5.setCellValue(data.getValue("dev_sign"));
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//�ʲ����
				detcell6.setCellValue(data.getValue("asset_coding"));
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//��λ
				detcell7.setCellValue(data.getValue("unit_name"));
				detcell7.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell8 = row.createCell(8);//����
				detcell8.setCellValue("1");
				detcell8.setCellStyle(rowdetcontent_Style);
				//������ȷſա�
				HSSFCell detcell9 = row.createCell(9);//
				detcell9.setCellValue("");
				detcell9.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell10 = row.createCell(10);//
				detcell10.setCellValue("");
				detcell10.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell11 = row.createCell(11);//
				detcell11.setCellValue("");
				detcell11.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell12 = row.createCell(12);//
				detcell12.setCellValue("");
				detcell12.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell13 = row.createCell(13);//
				detcell13.setCellValue("");
				detcell13.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell14 = row.createCell(14);//
				detcell14.setCellValue("");
				detcell14.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell15 = row.createCell(15);//
				detcell15.setCellValue("");
				detcell15.setCellStyle(rowdetcontent_Style);
    		}
    		//�����ڼ�д���߰������Ϣ
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("����_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//��������
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		row_last1.createCell(4);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		row_last1.createCell(8);
    		cell_last10.setCellValue("�������ݣ�");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)8));
    		HSSFCell cell_last19 = row_last1.createCell(9);
    		cell_last19.setCellValue("�豸���ʲ������ˣ���������");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(10);
    		row_last1.createCell(11);
    		row_last1.createCell(12);
    		row_last1.createCell(13);
    		row_last1.createCell(14);
    		row_last1.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+7, (short)9, detSize+7, (short)15));
    		HSSFRow row_last2 = sheet.createRow((short)(detSize+8));//��������
    		HSSFCell cell_last20 = row_last2.createCell(0);
    		cell_last20.setCellValue("�豸������λ�쵼��ǩ�֣���");
    		cell_last20.setCellStyle(rowlast_Style);
    		row_last2.createCell(1);
    		row_last2.createCell(2);
    		row_last2.createCell(3);
    		row_last2.createCell(4);
    		row_last2.createCell(5);
    		row_last2.createCell(6);
    		row_last2.createCell(7);
    		row_last2.createCell(8);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)8));
    		HSSFCell cell_last29 = row_last2.createCell(9);
    		cell_last29.setCellValue("�Ʊ�");
    		cell_last29.setCellStyle(rowlast_Style);
    		row_last2.createCell(10);
    		row_last2.createCell(11);
    		row_last2.createCell(12);
    		row_last2.createCell(13);
    		row_last2.createCell(14);
    		row_last2.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+8, (short)9, detSize+8, (short)15));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+9));//��������
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("������λ���ʲ��ƽ���)��");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		row_last3.createCell(4);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		row_last3.createCell(8);
    		sheet.addMergedRegion(new Region(detSize+9, (short)0, detSize+9, (short)8));
    		HSSFCell cell_last39 = row_last3.createCell(9);
    		cell_last39.setCellValue("���뵥λ(�ʲ�������):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(10);
    		row_last3.createCell(11);
    		row_last3.createCell(12);
    		row_last3.createCell(13);
    		row_last3.createCell(14);
    		row_last3.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+9, (short)9, detSize+9, (short)15));
    		// �����п��Զ� 
    		for(int j=2;j<9;j++){
				sheet.autoSizeColumn(j, true); // �Զ������п�
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // �����п�Ϊ�Զ�ֵ��1.5��
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
		}
		return excelName;
	}
}

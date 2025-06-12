package com.bgp.gms.service.rm.dm.action;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.soap.SOAPException;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi2.hssf.util.Region;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

public class DMZhfxToExcelAction extends WSAction {
	/**
	 * ��׼������
	 */
	@Override
	public ActionForward servieCall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
		servicecallconfig.setServiceName("DevInsSrv");
		servicecallconfig.setOperationName("getExcleData");

		ISrvMsg isrvmsg;
		if ((isrvmsg = SrvMsgUtil.createISrvMsg(servicecallconfig
				.getOperationName())) == null) {
			return null;
		} else {
			setDTOValue(isrvmsg, mapping, form, request, response);
			// ����������������ͳһ����
			ISrvMsg isrvmsg1 = ServiceCallFactory.getIServiceCall()
					.callWithDTO(null, isrvmsg, servicecallconfig);
			request.setAttribute("responseDTO", isrvmsg1);
			return null;
		}
	}

	/**
	 * ���������
	 */
	@Override
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ISrvMsg responseDTO = (ISrvMsg) request.getAttribute("responseDTO");
		// ��ô�ӡ���ĵ����
		String doctype = responseDTO.getValue("doctype");
		String excelName = null;
		// ������
		if ("dbbd".equals(doctype)) {
			excelName = createZZCommonExcel(responseDTO, 2);
		}
		if ("kkzysgll".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("projectbjusedetail".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("zy14type".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("projectuse".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("xcandfxc".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("wxjl".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("byjl".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("zcjjlwx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("zcjghjl".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}

		if ("pzybjuse".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("zybjuse".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ����ӻ�е�豸ͳ��
		if ("dzdjxsbtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ����ӻ�е�豸��Ϣ
		if ("dzdjxsbxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// ����Ӳɼ��豸ͳ��
		if ("dzdcjsbtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ����ӻ�е�豸���ڼ��ͺ�ͳ�Ʊ�
		if ("dzdjxsbkqjyhtj".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// �������Ҫ�豸����������ͳ��
		if ("dzdzysbdgjxtj".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// ����ӻ����豸�䱸ͳ��
		if ("dzdjdsbpbtj".equals(doctype)) {
			excelName = createJdsbpbtjExcel(responseDTO, 2);
		}
		// ����ӻ����豸�䱸ͳ����ȡ��Ϣ
		if ("dzdzysbpbxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// ��Ҫ�豸�������ͳ�Ʊ�
		if ("zysbjbqktjb".equals(doctype)) {
			excelName = createZysbjbqktjbExcel(responseDTO, 1.5);
		}
		// ��Ҫ�豸�������ͳ�Ʊ�(��̽����)
		if ("zysbjbqktjbwtc".equals(doctype)) {
			excelName = createZysbjbqktjbExcel(responseDTO, 1.5);
		}
		// ����������ʧ���
		if ("dzyqssqk".equals(doctype)) {
			excelName = createDzyqssqkExcel(responseDTO, 1.5);
		}
		// ǿ�Ʊ����ƻ����б�
		if ("qzbyjhyxb".equals(doctype)) {
			excelName = createQzbyjhyxbExcel(responseDTO, 1.5);
		}
		// ��е�豸����ͳ�Ʊ�
		if ("jxsbpztjb".equals(doctype)) {
			excelName = createJxsbpztjbExcel(responseDTO, 2);
		}
		// �豸����ȼ������ͳ��
		if ("sbdjryxhtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// �豸����ȼ��������ϸ
		if ("sbdjryxhmx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// �豸������������ͳ��
		if ("sbdjclxhtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// �豸��������������ȡ��Ϣһ����ȡ(�豸����)
		if ("sbdjclxhzqxx1".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// �豸��������������ȡ��Ϣ������ȡ(�豸��Ϣ)
		if ("sbdjclxhzqxx2".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// �ֳ�ά�޷���ͳ��
		if ("xcwxfytj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// �ֳ�ά�޷���ͳ��--��̽����
		if ("xcwxfytjwutanchu".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// �ֳ�ά�޷���ͳ��(�豸����)--��̽����
		if ("xcwxfyzqxxsblx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// �ֳ�ά�޷���ͳ��(�豸��Ϣ)--��̽����
		if ("xcwxfyzqxxsbxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// �ֳ�ά�޷���ͳ��(С��Ʒ)--��̽����
		if ("xcwxfyzqxxxyp".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// �ֳ�ά�޷���ͳ��(С��Ʒ��Ϣ)--��̽����
		if ("xcwxfyzqxxxypxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// ����������̬���
		if ("dzyqdtqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��Ҫ�豸�¶�ϵ��
		if ("zysbxdxs".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��˾����Ҫ�豸�¶�ϵ����ȡ���
		if ("gsjzysbxdxszqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��̽����Ҫ�豸�¶�ϵ����ȡ���
		if ("wtczysbxuxszqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��������(�����豸)��ȡ���
		if ("dzyqxzsbzqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��������(�����豸)��ȡ���
		if ("dzyqzysbzqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��̽����������(�����豸)
		if ("xmxxdzyqzysb".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ����Ŀ��Ҫ�豸Ͷ��ͳ��
		if ("gxmzysbtrtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ����Ŀ�ɼ��豸�ֲ�
		if ("gxmcjsbfb".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ����Ŀ��Ҫ�豸����ʡ�������
		if ("gxmzysbwhllyl".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ����Ŀ���÷���
		if ("gxmfyfx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ĳ̨��ĳ��Ŀ��Դ���ϲ�������ͳ��
		if ("TORPC".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��̨����Ŀ��Դ���ϲ�������ͳ��
		if ("TORPM".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��̨��Դ����ĳһ�����ۼ�ʱ�䷶Χ�ڲ��������Ƚ�ͳ��
		if ("SDFX".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��̨��Դ���ϲ�������ͳ��
		if ("MDFX".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// ��̨ĳ����С������ϸ
		if ("dtbjxhmx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("sbjxhmx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("dtbjxhmxh".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("whsbjxhmxh".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("aptm".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("dxmbjxhmx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("lpbjcount".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("dxmbjxhcc".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if ("bjxhlsmx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		//zjb ���������ѯ
		if ("bfsqcx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		//zjb ������Ϣ��ѯ
		if ("bfxxcx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		//zjb ���������ѯ
		if ("bfpscx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		//zjb �����ϱ���ѯ
		if ("bfsbcx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		if ("wxfyzqxxlx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if("bjxhtj".equals(doctype)){
			excelName = createCommonExcel(responseDTO, 2);
		}
		//��Դ����������Ϣ
		if("dyda".equals(doctype)){
			excelName= createZydajbxxExcel(responseDTO, 1);
		}
		if("czsqmx".equals(doctype)){
			excelName = createczsqmxExcel(responseDTO, 1);
		}
		response.setContentType("text/json; charset=utf-8");

		String ret = "{returnCode:0, excelName:'" + excelName + "',showName:'"
				+ excelName + "'}";

		response.getWriter().write(ret);

		return null;
	}

	/**
	 * �������ӱ�excel
	 * 
	 * @param responseDTO
	 * @param times
	 *            �п���
	 * @return
	 * @throws Exception
	 */
	private String createZZCommonExcel(ISrvMsg responseDTO, double times)
			throws Exception {

		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		int  hb =Integer.parseInt(responseDTO.getValue("hb"));
		int  hbEnd =Integer.parseInt(responseDTO.getValue("hbEnd"));
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));
			// ��ͷ
			Row headerRow = sheet.createRow(1);
			
			for (int i = 0; i < excelHeader.size(); i++) {
				if (i <=(hb-1)) {
					sheet.addMergedRegion(new CellRangeAddress(1, 2, i, i));
				}
			}
			sheet.addMergedRegion(new CellRangeAddress(1, 1, hb, hbEnd));
			Cell hcell = null;

			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// ������
			Row dataRow = null;
			// д������
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(2 + i);
					// ��ȡ����
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// ������Ԫ��
						Cell dCell = dataRow.createCell(j);
						// ������ʽ
						dCell.setCellStyle(setExcelCommonStyle(wb));
						// ��д������
						String key = ("excel_column_val" + j).trim();
						if (null != data.getValue(key)
								&& StringUtils.isNotBlank(data.getValue(key)
										.toString())) {
							dCell.setCellValue(data.getValue(key).toString());
						}
					}
				}
			}
			// �����п�
			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * ����excel
	 * 
	 * @param responseDTO
	 * @param times
	 *            �п���
	 * @return
	 * @throws Exception
	 */
	private String createCommonExcel(ISrvMsg responseDTO, double times)
			throws Exception {

		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));
			// ��ͷ
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;

			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// ������
			Row dataRow = null;
			// д������
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(2 + i);
					// ��ȡ����
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// ������Ԫ��
						Cell dCell = dataRow.createCell(j);
						// ������ʽ
						dCell.setCellStyle(setExcelCommonStyle(wb));
						// ��д������
						String key = ("excel_column_val" + j).trim();
						if (null != data.getValue(key)
								&& StringUtils.isNotBlank(data.getValue(key)
										.toString())) {
							dCell.setCellValue(data.getValue(key).toString());
						}
					}
				}
			}
			// �����п�
			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * ��������ŵ�excel
	 * 
	 * @param responseDTO
	 * @param times
	 *            �п���
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createOrderExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// ��ͷ
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// ������
			Row dataRow = null;
			// д������
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(2 + i);
					// ��ȡ����
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// ������Ԫ��
						Cell dCell = dataRow.createCell(j);
						// ������ʽ
						dCell.setCellStyle(setExcelCommonStyle(wb));
						if (j == 0) {
							// ���д������
							dCell.setCellValue(i + 1);
						} else {
							// ������д������
							String key = ("excel_column_val" + (j - 1)).trim();
							if (null != data.getValue(key)
									&& StringUtils.isNotBlank(data
											.getValue(key).toString())) {
								dCell.setCellValue(data.getValue(key)
										.toString());
							}
						}
					}
				}
			}
			// �����п�
			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * ��������ӻ����豸�䱸ͳ��excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createJdsbpbtjExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// ��ͷ
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// ������
			Row dataRow = null;
			// д������
			MsgElement data = null;
			// Ҫ�ϲ���Ԫ��Ŀ�ʼ��
			int startMergedRow = 2;
			// �ۼ�����
			double totalAmount = 0;
			// ��ǰ�豸����
			double curNum = 0;
			int orderValue = 1;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(2 + i);
					// ��ȡ����
					data = excelData.get(i);
					// ���
					Cell dCell0 = dataRow.createCell(0);
					// ������ʽ
					dCell0.setCellStyle(setExcelCommonStyle(wb));
					// �������ֵ
					dCell0.setCellValue(orderValue);
					// ����
					Cell dCell1 = dataRow.createCell(1);
					// ��ȡ����ֵ
					String excel_column_val0 = data.getValue(
							"excel_column_val0").toString();
					// ������ʽ
					dCell1.setCellStyle(setExcelCommonStyle(wb));
					// ���ð���
					dCell1.setCellValue(excel_column_val0);
					// �ϼ�
					Cell dCell4 = dataRow.createCell(4);
					// ��ȡ����ֵ
					if (null != data.getValue("excel_column_val2")
							&& StringUtils.isNotBlank(data.getValue(
									"excel_column_val2").toString())) {
						String excel_column_val2 = data.getValue(
								"excel_column_val2").toString();
						curNum = Double.parseDouble(excel_column_val2);
					}
					// ������ʽ
					dCell4.setCellStyle(setExcelCommonStyle(wb));
					// ���ϼƸ�ֵ
					dCell4.setCellValue(curNum);
					if (i == 0) {
						totalAmount = curNum;// ��ʼ�ۼ�����
					}
					if (i > 0) {
						MsgElement adata = excelData.get(i - 1);
						String aexcel_column_val0 = adata.getValue(
								"excel_column_val0").toString();
						if (aexcel_column_val0.equals(excel_column_val0)) {
							// �����ۼ�����
							totalAmount += curNum;
							// ���һ��
							if (i == excelData.size() - 1) {
								// �ϲ����
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 0, 0));
								// �ϲ�����
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 1, 1));
								// �ϲ��ϼ�
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 4, 4));
								// ��ȡ�ϲ���Ԫ�����
								Row mergedRow = sheet.getRow(startMergedRow);
								// ���ϼƸ�ֵ
								mergedRow.getCell(4).setCellValue(totalAmount);
							}
						} else {
							// �ϲ����
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 0, 0));
							// �ϲ�����
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 1, 1));
							// �ϲ��ϼ�
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 4, 4));
							// �޸ĵ�ǰ�����
							dataRow.getCell(0).setCellValue(orderValue + 1);
							// ��ȡ�ϲ���Ԫ�����
							Row mergedRow = sheet.getRow(startMergedRow);
							// ���ϼƸ�ֵ
							mergedRow.getCell(4).setCellValue(totalAmount);
							// ���³�ʼ��Ҫ�ϲ���Ԫ��Ŀ�ʼ��
							startMergedRow = i + 2;
							// ���ֵ��һ
							orderValue++;
							// ���³�ʼ������
							totalAmount = curNum;
						}
					}
					// �豸���
					Cell dCell2 = dataRow.createCell(2);
					// ������ʽ
					dCell2.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("excel_column_val1")
							&& StringUtils.isNotBlank(data.getValue(
									"excel_column_val1").toString())) {
						String excel_column_val1 = data.getValue(
								"excel_column_val1").toString();
						dCell2.setCellValue(excel_column_val1);
					}
					// ����
					Cell dCell3 = dataRow.createCell(3);
					// ������ʽ
					dCell3.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("excel_column_val2")
							&& StringUtils.isNotBlank(data.getValue(
									"excel_column_val2").toString())) {
						String excel_column_val2 = data.getValue(
								"excel_column_val2").toString();
						double _excel_column_val2 = Double
								.parseDouble(excel_column_val2);
						dCell3.setCellValue(_excel_column_val2);
					}
				}
			}
			// �����п�
			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * ������Ҫ�豸�������ͳ�Ʊ�excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createZysbjbqktjbExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// ��ͷ
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// ������1
			Row dataRow1 = null;
			// ������2
			Row dataRow2 = null;
			// д������
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 1; i <= excelData.size(); i++) {
					// ��������
					dataRow1 = sheet.createRow(2 * i);
					dataRow2 = sheet.createRow(2 * i + 1);
					// ��ȡ����
					data = excelData.get(i - 1);
					// �����豸���Ԫ��
					Cell dCell10 = dataRow1.createCell(0);
					Cell dCell20 = dataRow2.createCell(0);
					// ������ʽ
					dCell10.setCellStyle(setExcelCommonStyle(wb));
					dCell20.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell10.setCellValue(data.getValue("device_name")
							.toString());
					// �ϲ�����
					sheet.addMergedRegion(new CellRangeAddress(2 * i,
							2 * i + 1, 0, 0));
					// ������λ��Ԫ��
					Cell dCell11 = dataRow1.createCell(1);
					Cell dCell21 = dataRow2.createCell(1);
					// ������ʽ
					dCell11.setCellStyle(setExcelCommonStyle(wb));
					dCell21.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell11.setCellValue(data.getValue("unit").toString());
					// �ϲ�����
					sheet.addMergedRegion(new CellRangeAddress(2 * i,
							2 * i + 1, 1, 1));
					// ��������/���ⵥԪ��
					Cell dCell12 = dataRow1.createCell(2);
					Cell dCell22 = dataRow2.createCell(2);
					// ������ʽ
					dCell12.setCellStyle(setExcelCommonStyle(wb));
					dCell22.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell12.setCellValue("����");
					dCell22.setCellValue("����");
					// ����������Ԫ��
					Cell dCell13 = dataRow1.createCell(3);
					Cell dCell23 = dataRow2.createCell(3);
					// ������ʽ
					dCell13.setCellStyle(setExcelCommonStyle(wb));
					dCell23.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell13.setCellValue(data.getValue("total_num_in")
							.toString());
					dCell23.setCellValue(data.getValue("total_num_out")
							.toString());
					// �������õ�Ԫ��
					Cell dCell14 = dataRow1.createCell(4);
					Cell dCell24 = dataRow2.createCell(4);
					// ������ʽ
					dCell14.setCellStyle(setExcelCommonStyle(wb));
					dCell24.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell14.setCellValue(data.getValue("user_num_in")
							.toString());
					dCell24.setCellValue(data.getValue("user_num_out")
							.toString());
					// ��������(<1����)��Ԫ��
					Cell dCell15 = dataRow1.createCell(5);
					Cell dCell25 = dataRow2.createCell(5);
					// ������ʽ
					dCell15.setCellStyle(setExcelCommonStyle(wb));
					dCell25.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell15.setCellValue(data.getValue("little_num_in")
							.toString());
					dCell25.setCellValue(data.getValue("little_num_out")
							.toString());
					// ��������(>1����)��Ԫ��
					Cell dCell16 = dataRow1.createCell(6);
					Cell dCell26 = dataRow2.createCell(6);
					// ������ʽ
					dCell16.setCellStyle(setExcelCommonStyle(wb));
					dCell26.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell16.setCellValue(data.getValue("less_num_in")
							.toString());
					dCell26.setCellValue(data.getValue("less_num_out")
							.toString());
					// ��������/���޵�Ԫ��
					Cell dCell17 = dataRow1.createCell(7);
					Cell dCell27 = dataRow2.createCell(7);
					// ������ʽ
					dCell17.setCellStyle(setExcelCommonStyle(wb));
					dCell27.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell17.setCellValue(data.getValue("repairing_num_in")
							.toString());
					dCell27.setCellValue(data.getValue("repairing_num_out")
							.toString());
					// ���������ϵ�Ԫ��
					Cell dCell18 = dataRow1.createCell(8);
					Cell dCell28 = dataRow2.createCell(8);
					// ������ʽ
					dCell18.setCellStyle(setExcelCommonStyle(wb));
					dCell28.setCellStyle(setExcelCommonStyle(wb));
					// ��ֵ
					dCell18.setCellValue(data.getValue("unnus_num_in")
							.toString());
					dCell28.setCellValue(data.getValue("unnus_num_out")
							.toString());
				}
			}
			// �����п�
			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * ��������������ʧ���excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createDzyqssqkExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// ��ͷ
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// ������
			Row dataRow = null;
			// д������
			MsgElement data = null;
			// Ҫ�ϲ���Ԫ��Ŀ�ʼ��
			int startMergedRow = 2;
			int orderValue = 1;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(2 + i);
					// ��ȡ����
					data = excelData.get(i);
					// ���
					Cell dCell0 = dataRow.createCell(0);
					// ������ʽ
					dCell0.setCellStyle(setExcelCommonStyle(wb));
					// �������ֵ
					dCell0.setCellValue(orderValue);
					// ��Ŀ����
					Cell dCell1 = dataRow.createCell(1);
					// ��ȡ��Ŀ����ֵ
					String project_name = data.getValue("project_name")
							.toString();
					// ������ʽ
					dCell1.setCellStyle(setExcelCommonStyle(wb));
					// ������Ŀ����
					dCell1.setCellValue(project_name);
					if (i > 0) {
						MsgElement adata = excelData.get(i - 1);
						String aproject_name = adata.getValue("project_name")
								.toString();
						if (aproject_name.equals(project_name)) {
							// ���һ��
							if (i == excelData.size() - 1) {
								// �ϲ����
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 0, 0));
								// �ϲ���Ŀ����
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 1, 1));
							}
						} else {
							// �ϲ����
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 0, 0));
							// �ϲ���Ŀ����
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 1, 1));
							// �޸ĵ�ǰ�����
							dataRow.getCell(0).setCellValue(orderValue + 1);
							// ���³�ʼ��Ҫ�ϲ���Ԫ��Ŀ�ʼ��
							startMergedRow = i + 2;
							// ���ֵ��һ
							orderValue++;
						}
					}
					// �豸����
					Cell dCell2 = dataRow.createCell(2);
					// ������ʽ
					dCell2.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("coll_name")
							&& StringUtils.isNotBlank(data
									.getValue("coll_name").toString())) {
						String coll_name = data.getValue("coll_name")
								.toString();
						dCell2.setCellValue(coll_name);
					}
					// ����ͺ�
					Cell dCell3 = dataRow.createCell(3);
					// ������ʽ
					dCell3.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("devtype")
							&& StringUtils.isNotBlank(data.getValue("devtype")
									.toString())) {
						String devtype = data.getValue("devtype").toString();
						dCell3.setCellValue(devtype);
					}
					// �̿�����
					Cell dCell4 = dataRow.createCell(4);
					// ������ʽ
					dCell4.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("sumcheck_num")
							&& StringUtils.isNotBlank(data.getValue(
									"sumcheck_num").toString())) {
						String sumcheck_num = data.getValue("sumcheck_num")
								.toString();
						dCell4.setCellValue(sumcheck_num);
					}
					// ��������
					Cell dCell5 = dataRow.createCell(5);
					// ������ʽ
					dCell5.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("sumdestroy_num")
							&& StringUtils.isNotBlank(data.getValue(
									"sumdestroy_num").toString())) {
						String sumdestroy_num = data.getValue("sumdestroy_num")
								.toString();
						dCell5.setCellValue(sumdestroy_num);
					}
					// ��������
					Cell dCell6 = dataRow.createCell(6);
					// ������ʽ
					dCell6.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("sumunuse_num")
							&& StringUtils.isNotBlank(data.getValue(
									"sumunuse_num").toString())) {
						String sumunuse_num = data.getValue("sumunuse_num")
								.toString();
						dCell6.setCellValue(sumunuse_num);
					}
				}
			}
			// �����п�
			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * ����ǿ�Ʊ����ƻ����б�excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws Exception
	 */
	private String createQzbyjhyxbExcel(ISrvMsg responseDTO, double times)
			throws Exception {

		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));

			// ��ͷ
			Row headerRow1 = sheet.createRow(1);
			Row headerRow2 = sheet.createRow(2);
			for (int i = 0; i < excelHeader.size(); i++) {
				Cell hcell1 = headerRow1.createCell(i);
				Cell hcell2 = headerRow2.createCell(i);
				hcell1.setCellStyle(setExcelHearderStyle(wb));
				hcell2.setCellStyle(setExcelHearderStyle(wb));
				hcell1.setCellValue(excelHeader.get(i).toString());
				sheet.addMergedRegion(new CellRangeAddress(1, 2, i, i));
			}
			// ��ʼ����
			int initFre = 1;
			// ��ǰ����
			int curFre = 1;
			// Ĭ��ÿ�±�������
			for (int j = 0; j < curFre; j++) {
				Cell lcell11 = headerRow1
						.createCell(excelHeader.size() + j * 2);
				lcell11.setCellStyle(setExcelHearderStyle(wb));
				lcell11.setCellValue("��" + (j + 1) + "��");
				Cell lcell12 = headerRow1.createCell(excelHeader.size() + j * 2
						+ 1);
				lcell12.setCellStyle(setExcelHearderStyle(wb));
				sheet.addMergedRegion(new CellRangeAddress(1, 1, excelHeader
						.size() + j * 2, excelHeader.size() + j * 2 + 1));
				Cell lcell21 = headerRow2
						.createCell(excelHeader.size() + j * 2);
				lcell21.setCellStyle(setExcelHearderStyle(wb));
				lcell21.setCellValue("�ƻ���������");
				Cell lcell22 = headerRow2.createCell(excelHeader.size() + j * 2
						+ 1);
				lcell22.setCellStyle(setExcelHearderStyle(wb));
				lcell22.setCellValue("ʵ�ʱ�������");
			}

			// ������
			Row dataRow = null;
			// д������
			MsgElement data = null;
			// д�����ݿ�ʼ��
			int starDataRow = 3;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ��ȡ����
					data = excelData.get(i);
					// ��һ������д������
					if (i == 0) {
						// ������ǰ��
						dataRow = sheet.createRow(starDataRow);
						for (int j = 0; j < excelHeader.size() + curFre * 2; j++) {
							// ������Ԫ��
							Cell dCell = dataRow.createCell(j);
							// ������ʽ
							dCell.setCellStyle(setExcelCommonStyle(wb));
							if (j <= excelHeader.size() + 2) {
								if (j == 0) {
									// ���д������
									dCell.setCellValue(starDataRow - 2);
								} else {
									// ������д������
									String key = ("excel_column_val" + (j - 1))
											.trim();
									if (null != data.getValue(key)
											&& StringUtils.isNotBlank(data
													.getValue(key).toString())) {
										dCell.setCellValue(data.getValue(key)
												.toString());
									}
								}
							}
						}
					} else {
						MsgElement bdata = excelData.get(i - 1);
						// ͨ���豸id�ж�
						if (data.getValue("dev_acc_id").equals(
								bdata.getValue("dev_acc_id"))) {
							// ������һ
							initFre++;
							if (initFre < curFre) {
								Row curRow = sheet.getRow(starDataRow);
								String key = ("excel_column_val6").trim();
								if (null != data.getValue(key)
										&& StringUtils.isNotBlank(data
												.getValue(key).toString())) {
									curRow.getCell(
											excelHeader.size() + (initFre - 1)
													* 2).setCellValue(
											data.getValue(key).toString());
								}
								String key2 = ("excel_column_val7").trim();
								if (null != data.getValue(key2)
										&& StringUtils.isNotBlank(data
												.getValue(key2).toString())) {
									curRow.getCell(
											excelHeader.size() + (initFre - 1)
													* 2 + 1).setCellValue(
											data.getValue(key2).toString());
								}
							} else {
								Cell c11 = headerRow1.createCell(excelHeader
										.size() + curFre * 2);
								c11.setCellStyle(setExcelHearderStyle(wb));
								c11.setCellValue("��" + (curFre + 1) + "��");
								Cell c12 = headerRow1.createCell(excelHeader
										.size() + curFre * 2 + 1);
								c12.setCellStyle(setExcelHearderStyle(wb));
								sheet.addMergedRegion(new CellRangeAddress(1,
										1, excelHeader.size() + curFre * 2,
										excelHeader.size() + curFre * 2 + 1));
								Cell c21 = headerRow2.createCell(excelHeader
										.size() + curFre * 2);
								c21.setCellStyle(setExcelHearderStyle(wb));
								c21.setCellValue("�ƻ���������");
								Cell c22 = headerRow2.createCell(excelHeader
										.size() + curFre * 2 + 1);
								c22.setCellStyle(setExcelHearderStyle(wb));
								c22.setCellValue("ʵ�ʱ�������");
								for (int z = 3; z <= starDataRow; z++) {
									Row cRow = sheet.getRow(z);
									Cell cc1 = cRow.createCell(excelHeader
											.size() + curFre * 2);
									cc1.setCellStyle(setExcelHearderStyle(wb));
									Cell cc2 = cRow.createCell(excelHeader
											.size() + curFre * 2 + 1);
									cc2.setCellStyle(setExcelHearderStyle(wb));
									if (z == starDataRow) {
										// д������
										String ckey = ("excel_column_val6")
												.trim();
										if (null != data.getValue(ckey)
												&& StringUtils.isNotBlank(data
														.getValue(ckey)
														.toString())) {
											cc1.setCellValue(data
													.getValue(ckey).toString());
										}
										String ckey2 = ("excel_column_val7")
												.trim();
										if (null != data.getValue(ckey2)
												&& StringUtils.isNotBlank(data
														.getValue(ckey2)
														.toString())) {
											cc2.setCellValue(data.getValue(
													ckey2).toString());
										}
									}
								}
								curFre++;
							}

						} else {
							// ��ʼ����
							initFre = 1;
							// �����м�һ
							starDataRow++;
							dataRow = sheet.createRow(starDataRow);
							for (int j = 0; j < excelHeader.size() + curFre * 2; j++) {
								// ������Ԫ��
								Cell dCell = dataRow.createCell(j);
								// ������ʽ
								dCell.setCellStyle(setExcelCommonStyle(wb));
								if (j <= excelHeader.size() + 2) {
									if (j == 0) {
										// ���д������
										dCell.setCellValue(starDataRow - 2);
									} else {
										// ������д������
										String key = ("excel_column_val" + (j - 1))
												.trim();
										if (null != data.getValue(key)
												&& StringUtils.isNotBlank(data
														.getValue(key)
														.toString())) {
											dCell.setCellValue(data.getValue(
													key).toString());
										}
									}
								}
							}
						}
					}
				}
			}
			// �ϲ�����
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() + curFre * 2 - 1));
			// �����п�
			setColumnWidth(sheet, excelHeader.size() + curFre * 2, times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * ������е�豸����ͳ�Ʊ�excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createJxsbpztjbExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {
		String excelName = responseDTO.getValue("excelName");// excel����
		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(sheetName);// �����µ�sheet����
			// ������
			Row titleRow = sheet.createRow(0);// ��������
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// ��ͷ
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// ������
			Row dataRow = null;
			// д������
			MsgElement data = null;
			// Ҫ�ϲ���Ԫ��Ŀ�ʼ��
			int startMergedRow = 2;
			// �ۼ�����
			double totalAmount = 0;
			// ��ǰ�豸����
			double curNum = 0;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(2 + i);
					// ��ȡ����
					data = excelData.get(i);
					// �豸����
					Cell dCell0 = dataRow.createCell(0);
					// ��ȡ�豸����ֵ
					String devname = data.getValue("dev_name").toString();
					// ������ʽ
					dCell0.setCellStyle(setExcelCommonStyle(wb));
					// �����豸����ֵ
					dCell0.setCellValue(devname);
					// ����
					Cell dCell1 = dataRow.createCell(1);
					// ��ȡ����ֵ
					if (null != data.getValue("numb")
							&& StringUtils.isNotBlank(data.getValue("numb")
									.toString())) {
						String numb = data.getValue("numb").toString();
						curNum = Double.parseDouble(numb);
					}
					// ������ʽ
					dCell1.setCellStyle(setExcelCommonStyle(wb));
					// ��������ֵ
					dCell1.setCellValue(curNum);
					if (i == 0) {
						totalAmount = curNum;// ��ʼ�ۼ�����
					}
					if (i > 0) {
						MsgElement adata = excelData.get(i - 1);
						String adevname = adata.getValue("dev_name").toString();
						if (adevname.equals(devname)) {
							// �����ۼ�����
							totalAmount += curNum;
							// ���һ��
							if (i == excelData.size() - 1) {
								// �ϲ��豸����
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 0, 0));
								// �ϲ�����
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 1, 1));
								// ��ȡ�ϲ���Ԫ�����
								Row mergedRow = sheet.getRow(startMergedRow);
								// ��������ֵ
								mergedRow.getCell(1).setCellValue(totalAmount);
							}
						} else {
							// �ϲ��豸����
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 0, 0));
							// �ϲ�����
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 1, 1));
							// ��ȡ�ϲ���Ԫ�����
							Row mergedRow = sheet.getRow(startMergedRow);
							// ��������ֵ
							mergedRow.getCell(1).setCellValue(totalAmount);
							// ���³�ʼ��Ҫ�ϲ���Ԫ��Ŀ�ʼ��
							startMergedRow = i + 2;
							// ���³�ʼ������
							totalAmount = curNum;
						}
					}
					// ����ͺ�
					Cell dCell2 = dataRow.createCell(2);
					// ������ʽ
					dCell2.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("dev_model")
							&& StringUtils.isNotBlank(data
									.getValue("dev_model").toString())) {
						String dev_model = data.getValue("dev_model")
								.toString();
						dCell2.setCellValue(dev_model);
					}
					// ������λ
					Cell dCell3 = dataRow.createCell(3);
					// ������ʽ
					dCell3.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("dev_unit")
							&& StringUtils.isNotBlank(data.getValue("dev_unit")
									.toString())) {
						String dev_unit = data.getValue("dev_unit").toString();
						dCell3.setCellValue(dev_unit);
					}
					// ����
					Cell dCell4 = dataRow.createCell(4);
					// ������ʽ
					dCell4.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("numb")
							&& StringUtils.isNotBlank(data.getValue("numb")
									.toString())) {
						String numb = data.getValue("numb").toString();
						double _dnum = Double.parseDouble(numb);
						dCell4.setCellValue(_dnum);
					}
				}
			}
			// �����п�
			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}

	/**
	 * �����п�
	 * 
	 * @param sheet
	 * @param columnSize
	 * @param times
	 */
	public void setColumnWidth(Sheet sheet, int columnSize, double times) {
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
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN); // ��߱߿�
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
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN); // ��߱߿�
		return cellStyle;
	}
	/**
	 * ��Դ����������Ϣexcel
	 * @author zjb
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createZydajbxxExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel����
//		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
//		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			Workbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			Sheet sheet = wb.createSheet(excelName);// �����µ�sheet����
			// ������
//			Row titleRow = sheet.createRow(0);// ��������
//			Cell tc = titleRow.createCell(0);
//			tc.setCellValue(title);
//			tc.setCellStyle(setExcelTitleStyle(wb));
//			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
//					.size() - 1));
			// ��ͷ
			Row headerRow = sheet.createRow(0);
			Cell hcell = null;
 
		 
			Row dataRow = null;
			// д������
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
			 
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(1);
					// ��ȡ����
					data = excelData.get(i);
					Cell dCell = dataRow.createCell(1);
					dCell.setCellValue("�豸����");
					Cell dCell2 = dataRow.createCell(2);
					dCell2.setCellValue(data.getValue("dev_name").toString());
					Cell dCell3 = dataRow.createCell(3);
					dCell3.setCellValue("�豸�ͺ�");
					Cell dCell4 = dataRow.createCell(4);
					dCell4.setCellValue(data.getValue("dev_model").toString());
					Cell dCell5 = dataRow.createCell(5);
					dCell5.setCellValue("�豸����");
					Cell dCell6 = dataRow.createCell(6);
					dCell6.setCellValue(data.getValue("dev_type").toString());
					
					//�ڶ���
					Row dataRow2 = sheet.createRow(2);
					data = excelData.get(i);
					Cell d2Cell2 = dataRow2.createCell(1);
					d2Cell2.setCellValue("�ʲ����");
					Cell dCell22 = dataRow2.createCell(2);
					dCell22.setCellValue(data.getValue("asset_coding").toString());
					Cell dCell32 = dataRow2.createCell(3);
					dCell32.setCellValue("ʵ���ʶ��");
					Cell dCell42 = dataRow2.createCell(4);
					dCell42.setCellValue(data.getValue("dev_sign").toString());
					Cell dCell52 = dataRow2.createCell(5);
					dCell52.setCellValue("�Ա��");
					Cell dCell62 = dataRow2.createCell(6);
					dCell62.setCellValue(data.getValue("self_num").toString());
					
					//������
					Row dataRow3= sheet.createRow(3);
					data = excelData.get(i);
					Cell d3Cell2 = dataRow2.createCell(1);
					d2Cell2.setCellValue("���պ�");
					Cell dCell23 = dataRow2.createCell(2);
					dCell23.setCellValue(data.getValue("license_num").toString());
					Cell dCell33 = dataRow2.createCell(3);
					dCell33.setCellValue("��������");
					Cell dCell43 = dataRow2.createCell(4);
					dCell43.setCellValue(data.getValue("engine_num").toString());
					Cell dCell53 = dataRow2.createCell(5);
					dCell53.setCellValue("���̺�");
					Cell dCell63 = dataRow2.createCell(6);
					dCell63.setCellValue(data.getValue("chassis_num").toString());
					
					//������
					Row dataRow4= sheet.createRow(4);
					data = excelData.get(i);
					Cell d4Cell2 = dataRow2.createCell(1);
					d4Cell2.setCellValue("�ʲ�״��");
					Cell dCell24 = dataRow2.createCell(2);
					dCell24.setCellValue(data.getValue("stat_desc").toString());
					Cell dCell34 = dataRow2.createCell(3);
					dCell34.setCellValue("����״��");
					Cell dCell44 = dataRow2.createCell(4);
					dCell44.setCellValue(data.getValue("tech_stat_desc").toString());
					Cell dCell54 = dataRow2.createCell(5);
					dCell54.setCellValue("ʹ��״��");
					Cell dCell64 = dataRow2.createCell(6);
					dCell64.setCellValue(data.getValue("using_stat_desc").toString());
					
					//��5��
					Row dataRow5= sheet.createRow(4);
					data = excelData.get(i);
					Cell d5Cell2 = dataRow2.createCell(1);
					d5Cell2.setCellValue("��������");
					Cell dCell25 = dataRow2.createCell(2);
					dCell25.setCellValue(data.getValue("producting_date").toString());
					Cell dCell35 = dataRow2.createCell(3);
					dCell35.setCellValue("�̶��ʲ�ԭֵ");
					Cell dCell45 = dataRow2.createCell(4);
					dCell45.setCellValue(data.getValue("asset_value").toString());
					Cell dCell55 = dataRow2.createCell(5);
					dCell55.setCellValue("�̶��ʲ���ֵ");
					Cell dCell65 = dataRow2.createCell(6);
					dCell65.setCellValue(data.getValue("net_value").toString());
					}
				}
			 
			// �����п�
//			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}
	/**
	 * ������������excel
	 * @author zjb
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createBfsqcxExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel����
//		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		MsgElement headMap = responseDTO.getMsgElement("headMap");
//		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			HSSFWorkbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			HSSFSheet sheet = wb.createSheet(excelName);// �����µ�sheet����
			//��ʽ
			HSSFCellStyle titleStyle = wb.createCellStyle();        //������ʽ
            titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
            Font ztFont = wb.createFont();   
            ztFont.setFontHeightInPoints((short)13); // �������С����Ϊ12px   
            ztFont.setFontName("����");             // �������塱����Ӧ�õ���ǰ��Ԫ����  
            ztFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //�Ӵ�  
            titleStyle.setFont(ztFont);
            //�ϲ���Ԫ��CellRangeAddress����������α�ʾ��ʼ�У������У���ʼ�У� ������
	        sheet.addMergedRegion(new CellRangeAddress(0,0,0,3)); 
	        sheet.addMergedRegion(new CellRangeAddress(0,0,5,7)); 
			//�������п�ʼ
            HSSFRow titleRow = sheet.createRow(0);
            
            HSSFCell tc0 = titleRow.createCell(0);
			HSSFCell tc5 = titleRow.createCell(5);
			if(headMap!=null){
			HSSFRichTextString tc0text = new HSSFRichTextString("�豸���ϵ���:"+headMap.getValue("scrape_apply_no"));
	        HSSFRichTextString tc5text = new HSSFRichTextString("�豸���ϵ�����:"+headMap.getValue("scrape_apply_name"));
	         
	        tc0.setCellValue(tc0text);   
	        tc5.setCellValue(tc5text);

	        tc0.setCellStyle(titleStyle);
	      	tc5.setCellStyle(titleStyle);
			
	        
	        HSSFRow titleRow1 = sheet.createRow(1);
	        
	      //�ϲ���Ԫ��CellRangeAddress����������α�ʾ��ʼ�У������У���ʼ�У� ������
	        sheet.addMergedRegion(new CellRangeAddress(1,1,0,2)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,3,4)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,5,7));
	        
	        HSSFCell td0 = titleRow1.createCell(0);
			HSSFCell td3 = titleRow1.createCell(3);
			HSSFCell td5 = titleRow1.createCell(5);
			
			String  orgName = headMap.getValue("org_name");
			if(orgName.indexOf("������������˾")!=1) {
				orgName=orgName.replace("������������˾","");
			}
			HSSFRichTextString td0text = new HSSFRichTextString("���뵥λ:"+orgName);	      
	        HSSFRichTextString td3text = new HSSFRichTextString("������:"+headMap.getValue("employee_name"));	        
	        HSSFRichTextString td5text = new HSSFRichTextString("����ʱ��:"+headMap.getValue("apply_date"));
	                
		    td0.setCellValue(td0text);
	        td3.setCellValue(td3text);
	        td5.setCellValue(td5text);
	       
	        td0.setCellStyle(titleStyle);
	        td3.setCellStyle(titleStyle);
	        td5.setCellStyle(titleStyle);
			}
			//��ͷ��ʼ
	        HSSFCellStyle titleStyle1 = wb.createCellStyle();        
            titleStyle1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
            titleStyle1.setBorderTop(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderRight(HSSFCellStyle.BORDER_THIN);
            Font ztFont1 = wb.createFont();   
            ztFont1.setFontHeightInPoints((short)11); // �������С����Ϊ10px   
            ztFont1.setFontName("����");             // �������塱����Ӧ�õ���ǰ��Ԫ����  
            ztFont1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //�Ӵ�  
            titleStyle1.setFont(ztFont1);
			
	        
			HSSFRow rows= sheet.createRow(2);
			for (int i = 0; i < excelHeader.size(); i++) {
				HSSFCell cell = rows.createCell(i);
				HSSFRichTextString text = new HSSFRichTextString(excelHeader.get(i).toString());
				sheet.setColumnWidth(i,5500);
				//����Ԫ����������
   	            cell.setCellValue(text);
   	            cell.setCellStyle(titleStyle1);
			}
			// ������
			 HSSFCellStyle titleStyle2 = wb.createCellStyle();        
	            titleStyle2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	            titleStyle2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
	            titleStyle2.setWrapText(true);
	            titleStyle2.setBorderTop(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderRight(HSSFCellStyle.BORDER_THIN);
	            Font ztFont2 = wb.createFont();   
	            ztFont2.setFontHeightInPoints((short)9); // �������С����Ϊ10px   
	            ztFont2.setFontName("����");             // �������塱����Ӧ�õ���ǰ��Ԫ����  
	            ztFont2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //�Ӵ�  
	            titleStyle2.setFont(ztFont2);
			HSSFRow dataRow = null;
			// д������
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(3 + i);
					// ��ȡ����
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// ������Ԫ��
						Cell dCell = dataRow.createCell(j);
						// ������ʽ
						// ��д������
						String key = ("excel_column_val" + j).trim();
						if (null != data.getValue(key)
								&& StringUtils.isNotBlank(data.getValue(key)
										.toString())) {
							dCell.setCellValue(data.getValue(key).toString());
							dCell.setCellStyle(titleStyle2);
						}else {
							dCell.setCellValue("");
							dCell.setCellStyle(titleStyle2);
						}
					}
				}
			}
			// �����п�
//			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}
	/**
	 * ����������������excel
	 * @author zjb
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createczsqmxExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel����
//		String title = responseDTO.getValue("title");// excel����
		List excelHeader = responseDTO.getValues("excelHeader");// excel��ͷ
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel����
		MsgElement headMap = responseDTO.getMsgElement("headMap");
//		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			HSSFWorkbook wb = new HSSFWorkbook();// ������HSSFWorkbook����
			HSSFSheet sheet = wb.createSheet(excelName);// �����µ�sheet����
			//��ʽ
			HSSFCellStyle titleStyle = wb.createCellStyle();        //������ʽ
            titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
            Font ztFont = wb.createFont();   
            ztFont.setFontHeightInPoints((short)13); // �������С����Ϊ12px   
            ztFont.setFontName("����");             // �������塱����Ӧ�õ���ǰ��Ԫ����  
            ztFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //�Ӵ�  
            titleStyle.setFont(ztFont);
            //�ϲ���Ԫ��CellRangeAddress����������α�ʾ��ʼ�У������У���ʼ�У� ������
	        sheet.addMergedRegion(new CellRangeAddress(0,0,0,3)); 
	        sheet.addMergedRegion(new CellRangeAddress(0,0,5,7)); 
			//�������п�ʼ
            HSSFRow titleRow = sheet.createRow(0);
            
            HSSFCell tc0 = titleRow.createCell(0);
			HSSFCell tc5 = titleRow.createCell(5);
			
			HSSFRichTextString tc0text = new HSSFRichTextString("�豸���ϴ��õ���:"+headMap.getValue("app_no"));
	        HSSFRichTextString tc5text = new HSSFRichTextString("�豸���ϵ�����:"+headMap.getValue("app_name"));
	         
	        tc0.setCellValue(tc0text);   
	        tc5.setCellValue(tc5text);

	        tc0.setCellStyle(titleStyle);
	      	tc5.setCellStyle(titleStyle);
	       
	        
	        HSSFRow titleRow1 = sheet.createRow(1);
	        
	      //�ϲ���Ԫ��CellRangeAddress����������α�ʾ��ʼ�У������У���ʼ�У� ������
	        sheet.addMergedRegion(new CellRangeAddress(1,1,0,2)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,3,4)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,5,7));
	        
	        HSSFCell td0 = titleRow1.createCell(0);
			HSSFCell td3 = titleRow1.createCell(3);
			HSSFCell td5 = titleRow1.createCell(5);
			
			String  orgName = headMap.getValue("org_name");
			if(orgName.indexOf("������������˾")!=1) {
				orgName=orgName.replace("������������˾","");
			}
			if(orgName.indexOf("�й�ʯ�ͼ��Ŷ�����������̽�������ι�˾")!=1) {
				orgName=orgName.replace("�й�ʯ�ͼ��Ŷ�����������̽�������ι�˾","");
			}
			HSSFRichTextString td0text = new HSSFRichTextString("���뵥λ:"+orgName);	      
	        HSSFRichTextString td3text = new HSSFRichTextString("������:"+headMap.getValue("employee_name"));	        
	        HSSFRichTextString td5text = new HSSFRichTextString("����ʱ��:"+headMap.getValue("apply_date"));
	                
		    td0.setCellValue(td0text);
	        td3.setCellValue(td3text);
	        td5.setCellValue(td5text);
	       
	        td0.setCellStyle(titleStyle);
	        td3.setCellStyle(titleStyle);
	        td5.setCellStyle(titleStyle);
			
			//��ͷ��ʼ
	        HSSFCellStyle titleStyle1 = wb.createCellStyle();        
            titleStyle1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
            titleStyle1.setBorderTop(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderRight(HSSFCellStyle.BORDER_THIN);
            Font ztFont1 = wb.createFont();   
            ztFont1.setFontHeightInPoints((short)11); // �������С����Ϊ10px   
            ztFont1.setFontName("����");             // �������塱����Ӧ�õ���ǰ��Ԫ����  
            ztFont1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //�Ӵ�  
            titleStyle1.setFont(ztFont1);
			
	        
			HSSFRow rows= sheet.createRow(2);
			for (int i = 0; i < excelHeader.size(); i++) {
				HSSFCell cell = rows.createCell(i);
				HSSFRichTextString text = new HSSFRichTextString(excelHeader.get(i).toString());
				sheet.setColumnWidth(i,4500);
				//����Ԫ����������
   	            cell.setCellValue(text);
   	            cell.setCellStyle(titleStyle1);
			}
			// ������
			 HSSFCellStyle titleStyle2 = wb.createCellStyle();        
	            titleStyle2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	            titleStyle2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
	            titleStyle2.setWrapText(true);
	            titleStyle2.setBorderTop(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderRight(HSSFCellStyle.BORDER_THIN);
	            Font ztFont2 = wb.createFont();   
	            ztFont2.setFontHeightInPoints((short)9); // �������С����Ϊ10px   
	            ztFont2.setFontName("����");             // �������塱����Ӧ�õ���ǰ��Ԫ����  
	            ztFont2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //�Ӵ�  
	            titleStyle2.setFont(ztFont2);
			HSSFRow dataRow = null;
			// д������
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// ������ǰ��
					dataRow = sheet.createRow(3 + i);
					// ��ȡ����
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// ������Ԫ��
						Cell dCell = dataRow.createCell(j);
						// ������ʽ
						// ��д������
						String key = ("excel_column_val" + j).trim();
						if (null != data.getValue(key)
								&& StringUtils.isNotBlank(data.getValue(key)
										.toString())) {
							dCell.setCellValue(data.getValue(key).toString());
							dCell.setCellStyle(titleStyle2);
						}else {
							dCell.setCellValue("");
							dCell.setCellStyle(titleStyle2);
						}
					}
				}
			}
			// �����п�
//			setColumnWidth(sheet, excelHeader.size(), times);
			String file = this.getServlet().getServletContext()
					.getRealPath("/WEB-INF/temp/dm/" + excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}
}

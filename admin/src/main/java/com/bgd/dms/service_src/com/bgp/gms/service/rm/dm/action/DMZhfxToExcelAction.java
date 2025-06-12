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
	 * 先准备数据
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
			// 在这个方法这个里面统一处理
			ISrvMsg isrvmsg1 = ServiceCallFactory.getIServiceCall()
					.callWithDTO(null, isrvmsg, servicecallconfig);
			request.setAttribute("responseDTO", isrvmsg1);
			return null;
		}
	}

	/**
	 * 浏览器推送
	 */
	@Override
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ISrvMsg responseDTO = (ISrvMsg) request.getAttribute("responseDTO");
		// 获得打印的文档类别
		String doctype = responseDTO.getValue("doctype");
		String excelName = null;
		// 调拨表单
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
		// 地震队机械设备统计
		if ("dzdjxsbtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 地震队机械设备信息
		if ("dzdjxsbxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 地震队采集设备统计
		if ("dzdcjsbtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 地震队机械设备考勤及油耗统计表
		if ("dzdjxsbkqjyhtj".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 地震队主要设备待工、检修统计
		if ("dzdzysbdgjxtj".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 地震队机动设备配备统计
		if ("dzdjdsbpbtj".equals(doctype)) {
			excelName = createJdsbpbtjExcel(responseDTO, 2);
		}
		// 地震队机动设备配备统计钻取信息
		if ("dzdzysbpbxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 主要设备基本情况统计表
		if ("zysbjbqktjb".equals(doctype)) {
			excelName = createZysbjbqktjbExcel(responseDTO, 1.5);
		}
		// 主要设备基本情况统计表(物探处级)
		if ("zysbjbqktjbwtc".equals(doctype)) {
			excelName = createZysbjbqktjbExcel(responseDTO, 1.5);
		}
		// 地震仪器损失情况
		if ("dzyqssqk".equals(doctype)) {
			excelName = createDzyqssqkExcel(responseDTO, 1.5);
		}
		// 强制保养计划运行表
		if ("qzbyjhyxb".equals(doctype)) {
			excelName = createQzbyjhyxbExcel(responseDTO, 1.5);
		}
		// 机械设备配置统计表
		if ("jxsbpztjb".equals(doctype)) {
			excelName = createJxsbpztjbExcel(responseDTO, 2);
		}
		// 设备单机燃油消耗统计
		if ("sbdjryxhtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 设备单机燃油消耗明细
		if ("sbdjryxhmx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 设备单机材料消耗统计
		if ("sbdjclxhtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 设备单机材料消耗钻取信息一级钻取(设备类型)
		if ("sbdjclxhzqxx1".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 设备单机材料消耗钻取信息二级钻取(设备信息)
		if ("sbdjclxhzqxx2".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 现场维修费用统计
		if ("xcwxfytj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 现场维修费用统计--物探处级
		if ("xcwxfytjwutanchu".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 现场维修费用统计(设备类型)--物探处级
		if ("xcwxfyzqxxsblx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 现场维修费用统计(设备信息)--物探处级
		if ("xcwxfyzqxxsbxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 现场维修费用统计(小油品)--物探处级
		if ("xcwxfyzqxxxyp".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 现场维修费用统计(小油品信息)--物探处级
		if ("xcwxfyzqxxxypxx".equals(doctype)) {
			excelName = createOrderExcel(responseDTO, 1.5);
		}
		// 地震仪器动态情况
		if ("dzyqdtqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 主要设备新度系数
		if ("zysbxdxs".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 公司级主要设备新度系数钻取情况
		if ("gsjzysbxdxszqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 物探处主要设备新度系数钻取情况
		if ("wtczysbxuxszqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 地震仪器(闲置设备)钻取情况
		if ("dzyqxzsbzqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 地震仪器(在用设备)钻取情况
		if ("dzyqzysbzqqk".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 物探处地震仪器(在用设备)
		if ("xmxxdzyqzysb".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 各项目主要设备投入统计
		if ("gxmzysbtrtj".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 各项目采集设备分布
		if ("gxmcjsbfb".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 各项目主要设备完好率、利用率
		if ("gxmzysbwhllyl".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 各项目费用分析
		if ("gxmfyfx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 某台或某项目震源故障部件数量统计
		if ("TORPC".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 单台或项目震源故障部件数量统计
		if ("TORPM".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 单台震源故障某一部件累计时间范围内部件数量比较统计
		if ("SDFX".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 多台震源故障部件数量统计
		if ("MDFX".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		// 单台某部件小部件明细
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
		//zjb 报废申请查询
		if ("bfsqcx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		//zjb 报废信息查询
		if ("bfxxcx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		//zjb 报废评审查询
		if ("bfpscx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		//zjb 报废上报查询
		if ("bfsbcx".equals(doctype)) {
			excelName = createBfsqcxExcel(responseDTO, 1);
		}
		if ("wxfyzqxxlx".equals(doctype)) {
			excelName = createCommonExcel(responseDTO, 2);
		}
		if("bjxhtj".equals(doctype)){
			excelName = createCommonExcel(responseDTO, 2);
		}
		//震源档案基本信息
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
	 * 创建主子表excel
	 * 
	 * @param responseDTO
	 * @param times
	 *            列宽倍数
	 * @return
	 * @throws Exception
	 */
	private String createZZCommonExcel(ISrvMsg responseDTO, double times)
			throws Exception {

		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		int  hb =Integer.parseInt(responseDTO.getValue("hb"));
		int  hbEnd =Integer.parseInt(responseDTO.getValue("hbEnd"));
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));
			// 表头
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
			// 数据列
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(2 + i);
					// 获取数据
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// 创建单元格
						Cell dCell = dataRow.createCell(j);
						// 设置样式
						dCell.setCellStyle(setExcelCommonStyle(wb));
						// 列写入数据
						String key = ("excel_column_val" + j).trim();
						if (null != data.getValue(key)
								&& StringUtils.isNotBlank(data.getValue(key)
										.toString())) {
							dCell.setCellValue(data.getValue(key).toString());
						}
					}
				}
			}
			// 设置列宽
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
	 * 创建excel
	 * 
	 * @param responseDTO
	 * @param times
	 *            列宽倍数
	 * @return
	 * @throws Exception
	 */
	private String createCommonExcel(ISrvMsg responseDTO, double times)
			throws Exception {

		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));
			// 表头
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;

			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// 数据列
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(2 + i);
					// 获取数据
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// 创建单元格
						Cell dCell = dataRow.createCell(j);
						// 设置样式
						dCell.setCellStyle(setExcelCommonStyle(wb));
						// 列写入数据
						String key = ("excel_column_val" + j).trim();
						if (null != data.getValue(key)
								&& StringUtils.isNotBlank(data.getValue(key)
										.toString())) {
							dCell.setCellValue(data.getValue(key).toString());
						}
					}
				}
			}
			// 设置列宽
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
	 * 创建带序号的excel
	 * 
	 * @param responseDTO
	 * @param times
	 *            列宽倍数
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createOrderExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// 表头
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// 数据列
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(2 + i);
					// 获取数据
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// 创建单元格
						Cell dCell = dataRow.createCell(j);
						// 设置样式
						dCell.setCellStyle(setExcelCommonStyle(wb));
						if (j == 0) {
							// 序号写入数据
							dCell.setCellValue(i + 1);
						} else {
							// 其他列写入数据
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
			// 设置列宽
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
	 * 创建地震队机动设备配备统计excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createJdsbpbtjExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// 表头
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// 数据列
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			// 要合并单元格的开始行
			int startMergedRow = 2;
			// 累计总量
			double totalAmount = 0;
			// 当前设备数量
			double curNum = 0;
			int orderValue = 1;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(2 + i);
					// 获取数据
					data = excelData.get(i);
					// 序号
					Cell dCell0 = dataRow.createCell(0);
					// 设置样式
					dCell0.setCellStyle(setExcelCommonStyle(wb));
					// 设置序号值
					dCell0.setCellValue(orderValue);
					// 班组
					Cell dCell1 = dataRow.createCell(1);
					// 获取班组值
					String excel_column_val0 = data.getValue(
							"excel_column_val0").toString();
					// 设置样式
					dCell1.setCellStyle(setExcelCommonStyle(wb));
					// 设置班组
					dCell1.setCellValue(excel_column_val0);
					// 合计
					Cell dCell4 = dataRow.createCell(4);
					// 获取数量值
					if (null != data.getValue("excel_column_val2")
							&& StringUtils.isNotBlank(data.getValue(
									"excel_column_val2").toString())) {
						String excel_column_val2 = data.getValue(
								"excel_column_val2").toString();
						curNum = Double.parseDouble(excel_column_val2);
					}
					// 设置样式
					dCell4.setCellStyle(setExcelCommonStyle(wb));
					// 给合计赋值
					dCell4.setCellValue(curNum);
					if (i == 0) {
						totalAmount = curNum;// 初始累计数量
					}
					if (i > 0) {
						MsgElement adata = excelData.get(i - 1);
						String aexcel_column_val0 = adata.getValue(
								"excel_column_val0").toString();
						if (aexcel_column_val0.equals(excel_column_val0)) {
							// 设置累计数量
							totalAmount += curNum;
							// 最后一行
							if (i == excelData.size() - 1) {
								// 合并序号
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 0, 0));
								// 合并班组
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 1, 1));
								// 合并合计
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 4, 4));
								// 获取合并单元格的行
								Row mergedRow = sheet.getRow(startMergedRow);
								// 给合计赋值
								mergedRow.getCell(4).setCellValue(totalAmount);
							}
						} else {
							// 合并序号
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 0, 0));
							// 合并班组
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 1, 1));
							// 合并合计
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 4, 4));
							// 修改当前行序号
							dataRow.getCell(0).setCellValue(orderValue + 1);
							// 获取合并单元格的行
							Row mergedRow = sheet.getRow(startMergedRow);
							// 给合计赋值
							mergedRow.getCell(4).setCellValue(totalAmount);
							// 重新初始化要合并单元格的开始行
							startMergedRow = i + 2;
							// 序号值加一
							orderValue++;
							// 重新初始化数量
							totalAmount = curNum;
						}
					}
					// 设备类别
					Cell dCell2 = dataRow.createCell(2);
					// 设置样式
					dCell2.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("excel_column_val1")
							&& StringUtils.isNotBlank(data.getValue(
									"excel_column_val1").toString())) {
						String excel_column_val1 = data.getValue(
								"excel_column_val1").toString();
						dCell2.setCellValue(excel_column_val1);
					}
					// 数量
					Cell dCell3 = dataRow.createCell(3);
					// 设置样式
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
			// 设置列宽
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
	 * 创建主要设备基本情况统计表excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createZysbjbqktjbExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// 表头
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// 数据列1
			Row dataRow1 = null;
			// 数据列2
			Row dataRow2 = null;
			// 写入数据
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 1; i <= excelData.size(); i++) {
					// 创建两行
					dataRow1 = sheet.createRow(2 * i);
					dataRow2 = sheet.createRow(2 * i + 1);
					// 获取数据
					data = excelData.get(i - 1);
					// 创建设备类别单元格
					Cell dCell10 = dataRow1.createCell(0);
					Cell dCell20 = dataRow2.createCell(0);
					// 设置样式
					dCell10.setCellStyle(setExcelCommonStyle(wb));
					dCell20.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell10.setCellValue(data.getValue("device_name")
							.toString());
					// 合并两列
					sheet.addMergedRegion(new CellRangeAddress(2 * i,
							2 * i + 1, 0, 0));
					// 创建单位单元格
					Cell dCell11 = dataRow1.createCell(1);
					Cell dCell21 = dataRow2.createCell(1);
					// 设置样式
					dCell11.setCellStyle(setExcelCommonStyle(wb));
					dCell21.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell11.setCellValue(data.getValue("unit").toString());
					// 合并两列
					sheet.addMergedRegion(new CellRangeAddress(2 * i,
							2 * i + 1, 1, 1));
					// 创建国内/国外单元格
					Cell dCell12 = dataRow1.createCell(2);
					Cell dCell22 = dataRow2.createCell(2);
					// 设置样式
					dCell12.setCellStyle(setExcelCommonStyle(wb));
					dCell22.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell12.setCellValue("国内");
					dCell22.setCellValue("国外");
					// 创建总量单元格
					Cell dCell13 = dataRow1.createCell(3);
					Cell dCell23 = dataRow2.createCell(3);
					// 设置样式
					dCell13.setCellStyle(setExcelCommonStyle(wb));
					dCell23.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell13.setCellValue(data.getValue("total_num_in")
							.toString());
					dCell23.setCellValue(data.getValue("total_num_out")
							.toString());
					// 创建在用单元格
					Cell dCell14 = dataRow1.createCell(4);
					Cell dCell24 = dataRow2.createCell(4);
					// 设置样式
					dCell14.setCellStyle(setExcelCommonStyle(wb));
					dCell24.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell14.setCellValue(data.getValue("user_num_in")
							.toString());
					dCell24.setCellValue(data.getValue("user_num_out")
							.toString());
					// 创建闲置(<1个月)单元格
					Cell dCell15 = dataRow1.createCell(5);
					Cell dCell25 = dataRow2.createCell(5);
					// 设置样式
					dCell15.setCellStyle(setExcelCommonStyle(wb));
					dCell25.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell15.setCellValue(data.getValue("little_num_in")
							.toString());
					dCell25.setCellValue(data.getValue("little_num_out")
							.toString());
					// 创建闲置(>1个月)单元格
					Cell dCell16 = dataRow1.createCell(6);
					Cell dCell26 = dataRow2.createCell(6);
					// 设置样式
					dCell16.setCellStyle(setExcelCommonStyle(wb));
					dCell26.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell16.setCellValue(data.getValue("less_num_in")
							.toString());
					dCell26.setCellValue(data.getValue("less_num_out")
							.toString());
					// 创建在修/待修单元格
					Cell dCell17 = dataRow1.createCell(7);
					Cell dCell27 = dataRow2.createCell(7);
					// 设置样式
					dCell17.setCellStyle(setExcelCommonStyle(wb));
					dCell27.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell17.setCellValue(data.getValue("repairing_num_in")
							.toString());
					dCell27.setCellValue(data.getValue("repairing_num_out")
							.toString());
					// 创建待报废单元格
					Cell dCell18 = dataRow1.createCell(8);
					Cell dCell28 = dataRow2.createCell(8);
					// 设置样式
					dCell18.setCellStyle(setExcelCommonStyle(wb));
					dCell28.setCellStyle(setExcelCommonStyle(wb));
					// 赋值
					dCell18.setCellValue(data.getValue("unnus_num_in")
							.toString());
					dCell28.setCellValue(data.getValue("unnus_num_out")
							.toString());
				}
			}
			// 设置列宽
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
	 * 创建地震仪器损失情况excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createDzyqssqkExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// 表头
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// 数据列
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			// 要合并单元格的开始行
			int startMergedRow = 2;
			int orderValue = 1;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(2 + i);
					// 获取数据
					data = excelData.get(i);
					// 序号
					Cell dCell0 = dataRow.createCell(0);
					// 设置样式
					dCell0.setCellStyle(setExcelCommonStyle(wb));
					// 设置序号值
					dCell0.setCellValue(orderValue);
					// 项目名称
					Cell dCell1 = dataRow.createCell(1);
					// 获取项目名称值
					String project_name = data.getValue("project_name")
							.toString();
					// 设置样式
					dCell1.setCellStyle(setExcelCommonStyle(wb));
					// 设置项目名称
					dCell1.setCellValue(project_name);
					if (i > 0) {
						MsgElement adata = excelData.get(i - 1);
						String aproject_name = adata.getValue("project_name")
								.toString();
						if (aproject_name.equals(project_name)) {
							// 最后一行
							if (i == excelData.size() - 1) {
								// 合并序号
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 0, 0));
								// 合并项目名称
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 1, 1));
							}
						} else {
							// 合并序号
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 0, 0));
							// 合并项目名称
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 1, 1));
							// 修改当前行序号
							dataRow.getCell(0).setCellValue(orderValue + 1);
							// 重新初始化要合并单元格的开始行
							startMergedRow = i + 2;
							// 序号值加一
							orderValue++;
						}
					}
					// 设备名称
					Cell dCell2 = dataRow.createCell(2);
					// 设置样式
					dCell2.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("coll_name")
							&& StringUtils.isNotBlank(data
									.getValue("coll_name").toString())) {
						String coll_name = data.getValue("coll_name")
								.toString();
						dCell2.setCellValue(coll_name);
					}
					// 规格型号
					Cell dCell3 = dataRow.createCell(3);
					// 设置样式
					dCell3.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("devtype")
							&& StringUtils.isNotBlank(data.getValue("devtype")
									.toString())) {
						String devtype = data.getValue("devtype").toString();
						dCell3.setCellValue(devtype);
					}
					// 盘亏数量
					Cell dCell4 = dataRow.createCell(4);
					// 设置样式
					dCell4.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("sumcheck_num")
							&& StringUtils.isNotBlank(data.getValue(
									"sumcheck_num").toString())) {
						String sumcheck_num = data.getValue("sumcheck_num")
								.toString();
						dCell4.setCellValue(sumcheck_num);
					}
					// 毁损数量
					Cell dCell5 = dataRow.createCell(5);
					// 设置样式
					dCell5.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("sumdestroy_num")
							&& StringUtils.isNotBlank(data.getValue(
									"sumdestroy_num").toString())) {
						String sumdestroy_num = data.getValue("sumdestroy_num")
								.toString();
						dCell5.setCellValue(sumdestroy_num);
					}
					// 现有数量
					Cell dCell6 = dataRow.createCell(6);
					// 设置样式
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
			// 设置列宽
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
	 * 创建强制保养计划运行表excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws Exception
	 */
	private String createQzbyjhyxbExcel(ISrvMsg responseDTO, double times)
			throws Exception {

		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));

			// 表头
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
			// 初始次数
			int initFre = 1;
			// 当前次数
			int curFre = 1;
			// 默认每月保养次数
			for (int j = 0; j < curFre; j++) {
				Cell lcell11 = headerRow1
						.createCell(excelHeader.size() + j * 2);
				lcell11.setCellStyle(setExcelHearderStyle(wb));
				lcell11.setCellValue("第" + (j + 1) + "次");
				Cell lcell12 = headerRow1.createCell(excelHeader.size() + j * 2
						+ 1);
				lcell12.setCellStyle(setExcelHearderStyle(wb));
				sheet.addMergedRegion(new CellRangeAddress(1, 1, excelHeader
						.size() + j * 2, excelHeader.size() + j * 2 + 1));
				Cell lcell21 = headerRow2
						.createCell(excelHeader.size() + j * 2);
				lcell21.setCellStyle(setExcelHearderStyle(wb));
				lcell21.setCellValue("计划保养日期");
				Cell lcell22 = headerRow2.createCell(excelHeader.size() + j * 2
						+ 1);
				lcell22.setCellStyle(setExcelHearderStyle(wb));
				lcell22.setCellValue("实际保养日期");
			}

			// 数据列
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			// 写入数据开始行
			int starDataRow = 3;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 获取数据
					data = excelData.get(i);
					// 第一次正常写入数据
					if (i == 0) {
						// 创建当前行
						dataRow = sheet.createRow(starDataRow);
						for (int j = 0; j < excelHeader.size() + curFre * 2; j++) {
							// 创建单元格
							Cell dCell = dataRow.createCell(j);
							// 设置样式
							dCell.setCellStyle(setExcelCommonStyle(wb));
							if (j <= excelHeader.size() + 2) {
								if (j == 0) {
									// 序号写入数据
									dCell.setCellValue(starDataRow - 2);
								} else {
									// 其他列写入数据
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
						// 通过设备id判断
						if (data.getValue("dev_acc_id").equals(
								bdata.getValue("dev_acc_id"))) {
							// 次数加一
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
								c11.setCellValue("第" + (curFre + 1) + "次");
								Cell c12 = headerRow1.createCell(excelHeader
										.size() + curFre * 2 + 1);
								c12.setCellStyle(setExcelHearderStyle(wb));
								sheet.addMergedRegion(new CellRangeAddress(1,
										1, excelHeader.size() + curFre * 2,
										excelHeader.size() + curFre * 2 + 1));
								Cell c21 = headerRow2.createCell(excelHeader
										.size() + curFre * 2);
								c21.setCellStyle(setExcelHearderStyle(wb));
								c21.setCellValue("计划保养日期");
								Cell c22 = headerRow2.createCell(excelHeader
										.size() + curFre * 2 + 1);
								c22.setCellStyle(setExcelHearderStyle(wb));
								c22.setCellValue("实际保养日期");
								for (int z = 3; z <= starDataRow; z++) {
									Row cRow = sheet.getRow(z);
									Cell cc1 = cRow.createCell(excelHeader
											.size() + curFre * 2);
									cc1.setCellStyle(setExcelHearderStyle(wb));
									Cell cc2 = cRow.createCell(excelHeader
											.size() + curFre * 2 + 1);
									cc2.setCellStyle(setExcelHearderStyle(wb));
									if (z == starDataRow) {
										// 写入数据
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
							// 初始次数
							initFre = 1;
							// 数据行加一
							starDataRow++;
							dataRow = sheet.createRow(starDataRow);
							for (int j = 0; j < excelHeader.size() + curFre * 2; j++) {
								// 创建单元格
								Cell dCell = dataRow.createCell(j);
								// 设置样式
								dCell.setCellStyle(setExcelCommonStyle(wb));
								if (j <= excelHeader.size() + 2) {
									if (j == 0) {
										// 序号写入数据
										dCell.setCellValue(starDataRow - 2);
									} else {
										// 其他列写入数据
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
			// 合并标题
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() + curFre * 2 - 1));
			// 设置列宽
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
	 * 创建机械设备配置统计表excel
	 * 
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createJxsbpztjbExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {
		String excelName = responseDTO.getValue("excelName");// excel名称
		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			String sheetName = title;
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(sheetName);// 建立新的sheet对象
			// 标题行
			Row titleRow = sheet.createRow(0);// 建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
					.size() - 1));

			// 表头
			Row headerRow = sheet.createRow(1);
			Cell hcell = null;
			for (int i = 0; i < excelHeader.size(); i++) {
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			// 数据列
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			// 要合并单元格的开始行
			int startMergedRow = 2;
			// 累计总量
			double totalAmount = 0;
			// 当前设备数量
			double curNum = 0;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(2 + i);
					// 获取数据
					data = excelData.get(i);
					// 设备名称
					Cell dCell0 = dataRow.createCell(0);
					// 获取设备名称值
					String devname = data.getValue("dev_name").toString();
					// 设置样式
					dCell0.setCellStyle(setExcelCommonStyle(wb));
					// 设置设备名称值
					dCell0.setCellValue(devname);
					// 总量
					Cell dCell1 = dataRow.createCell(1);
					// 获取总量值
					if (null != data.getValue("numb")
							&& StringUtils.isNotBlank(data.getValue("numb")
									.toString())) {
						String numb = data.getValue("numb").toString();
						curNum = Double.parseDouble(numb);
					}
					// 设置样式
					dCell1.setCellStyle(setExcelCommonStyle(wb));
					// 给总量赋值
					dCell1.setCellValue(curNum);
					if (i == 0) {
						totalAmount = curNum;// 初始累计总量
					}
					if (i > 0) {
						MsgElement adata = excelData.get(i - 1);
						String adevname = adata.getValue("dev_name").toString();
						if (adevname.equals(devname)) {
							// 设置累计总量
							totalAmount += curNum;
							// 最后一行
							if (i == excelData.size() - 1) {
								// 合并设备名称
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 0, 0));
								// 合并总量
								sheet.addMergedRegion(new CellRangeAddress(
										startMergedRow, i + 2, 1, 1));
								// 获取合并单元格的行
								Row mergedRow = sheet.getRow(startMergedRow);
								// 给总量赋值
								mergedRow.getCell(1).setCellValue(totalAmount);
							}
						} else {
							// 合并设备名称
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 0, 0));
							// 合并总量
							sheet.addMergedRegion(new CellRangeAddress(
									startMergedRow, i + 1, 1, 1));
							// 获取合并单元格的行
							Row mergedRow = sheet.getRow(startMergedRow);
							// 给总量赋值
							mergedRow.getCell(1).setCellValue(totalAmount);
							// 重新初始化要合并单元格的开始行
							startMergedRow = i + 2;
							// 重新初始化总量
							totalAmount = curNum;
						}
					}
					// 规格型号
					Cell dCell2 = dataRow.createCell(2);
					// 设置样式
					dCell2.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("dev_model")
							&& StringUtils.isNotBlank(data
									.getValue("dev_model").toString())) {
						String dev_model = data.getValue("dev_model")
								.toString();
						dCell2.setCellValue(dev_model);
					}
					// 计量单位
					Cell dCell3 = dataRow.createCell(3);
					// 设置样式
					dCell3.setCellStyle(setExcelCommonStyle(wb));
					if (null != data.getValue("dev_unit")
							&& StringUtils.isNotBlank(data.getValue("dev_unit")
									.toString())) {
						String dev_unit = data.getValue("dev_unit").toString();
						dCell3.setCellValue(dev_unit);
					}
					// 数量
					Cell dCell4 = dataRow.createCell(4);
					// 设置样式
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
			// 设置列宽
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
	 * 设置列宽
	 * 
	 * @param sheet
	 * @param columnSize
	 * @param times
	 */
	public void setColumnWidth(Sheet sheet, int columnSize, double times) {
		for (int i = 0; i < columnSize; i++) {
			// 自动计算列宽
			sheet.autoSizeColumn(i, true);
			// 设置列宽为自动值的1.5倍
			sheet.setColumnWidth(i, (int) (sheet.getColumnWidth(i) * times));
		}
	}

	/**
	 * 设置标题样式
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelTitleStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // 创建单元格样式
		// 设置单元格水平方向对其方式
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 设置单元格垂直方向对其方式
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// 创建字体
		Font font = wb.createFont();
		font.setFontHeightInPoints((short) 16);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("宋体");
		// 设置字体样式
		cellStyle.setFont(font);
		return cellStyle;
	}

	/**
	 * 设备表头样式
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelHearderStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // 创建单元格样式
		// 设置单元格水平方向对其方式
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 设置单元格垂直方向对其方式
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// 创建字体
		Font font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("宋体");
		// 设置字体样式
		cellStyle.setFont(font);
		// 设置边框
		cellStyle.setBorderTop(CellStyle.BORDER_THIN); // 上边边框
		cellStyle.setBorderRight(CellStyle.BORDER_THIN); // 右边边框
		cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 底部边框
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN); // 左边边框
		return cellStyle;
	}

	/**
	 * 设置单元格样式
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelCommonStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // 创建单元格样式
		// 设置单元格水平方向对其方式
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 设置单元格垂直方向对其方式
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// 设置边框
		cellStyle.setBorderTop(CellStyle.BORDER_THIN); // 上边边框
		cellStyle.setBorderRight(CellStyle.BORDER_THIN); // 右边边框
		cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 底部边框
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN); // 左边边框
		return cellStyle;
	}
	/**
	 * 震源档案基本信息excel
	 * @author zjb
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createZydajbxxExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel名称
//		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
//		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			Workbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			Sheet sheet = wb.createSheet(excelName);// 建立新的sheet对象
			// 标题行
//			Row titleRow = sheet.createRow(0);// 建立新行
//			Cell tc = titleRow.createCell(0);
//			tc.setCellValue(title);
//			tc.setCellStyle(setExcelTitleStyle(wb));
//			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader
//					.size() - 1));
			// 表头
			Row headerRow = sheet.createRow(0);
			Cell hcell = null;
 
		 
			Row dataRow = null;
			// 写入数据
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
			 
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(1);
					// 获取数据
					data = excelData.get(i);
					Cell dCell = dataRow.createCell(1);
					dCell.setCellValue("设备名称");
					Cell dCell2 = dataRow.createCell(2);
					dCell2.setCellValue(data.getValue("dev_name").toString());
					Cell dCell3 = dataRow.createCell(3);
					dCell3.setCellValue("设备型号");
					Cell dCell4 = dataRow.createCell(4);
					dCell4.setCellValue(data.getValue("dev_model").toString());
					Cell dCell5 = dataRow.createCell(5);
					dCell5.setCellValue("设备编码");
					Cell dCell6 = dataRow.createCell(6);
					dCell6.setCellValue(data.getValue("dev_type").toString());
					
					//第二行
					Row dataRow2 = sheet.createRow(2);
					data = excelData.get(i);
					Cell d2Cell2 = dataRow2.createCell(1);
					d2Cell2.setCellValue("资产编号");
					Cell dCell22 = dataRow2.createCell(2);
					dCell22.setCellValue(data.getValue("asset_coding").toString());
					Cell dCell32 = dataRow2.createCell(3);
					dCell32.setCellValue("实物标识号");
					Cell dCell42 = dataRow2.createCell(4);
					dCell42.setCellValue(data.getValue("dev_sign").toString());
					Cell dCell52 = dataRow2.createCell(5);
					dCell52.setCellValue("自编号");
					Cell dCell62 = dataRow2.createCell(6);
					dCell62.setCellValue(data.getValue("self_num").toString());
					
					//第三行
					Row dataRow3= sheet.createRow(3);
					data = excelData.get(i);
					Cell d3Cell2 = dataRow2.createCell(1);
					d2Cell2.setCellValue("牌照号");
					Cell dCell23 = dataRow2.createCell(2);
					dCell23.setCellValue(data.getValue("license_num").toString());
					Cell dCell33 = dataRow2.createCell(3);
					dCell33.setCellValue("发动机号");
					Cell dCell43 = dataRow2.createCell(4);
					dCell43.setCellValue(data.getValue("engine_num").toString());
					Cell dCell53 = dataRow2.createCell(5);
					dCell53.setCellValue("底盘号");
					Cell dCell63 = dataRow2.createCell(6);
					dCell63.setCellValue(data.getValue("chassis_num").toString());
					
					//第四行
					Row dataRow4= sheet.createRow(4);
					data = excelData.get(i);
					Cell d4Cell2 = dataRow2.createCell(1);
					d4Cell2.setCellValue("资产状况");
					Cell dCell24 = dataRow2.createCell(2);
					dCell24.setCellValue(data.getValue("stat_desc").toString());
					Cell dCell34 = dataRow2.createCell(3);
					dCell34.setCellValue("技术状况");
					Cell dCell44 = dataRow2.createCell(4);
					dCell44.setCellValue(data.getValue("tech_stat_desc").toString());
					Cell dCell54 = dataRow2.createCell(5);
					dCell54.setCellValue("使用状况");
					Cell dCell64 = dataRow2.createCell(6);
					dCell64.setCellValue(data.getValue("using_stat_desc").toString());
					
					//第5行
					Row dataRow5= sheet.createRow(4);
					data = excelData.get(i);
					Cell d5Cell2 = dataRow2.createCell(1);
					d5Cell2.setCellValue("出厂日期");
					Cell dCell25 = dataRow2.createCell(2);
					dCell25.setCellValue(data.getValue("producting_date").toString());
					Cell dCell35 = dataRow2.createCell(3);
					dCell35.setCellValue("固定资产原值");
					Cell dCell45 = dataRow2.createCell(4);
					dCell45.setCellValue(data.getValue("asset_value").toString());
					Cell dCell55 = dataRow2.createCell(5);
					dCell55.setCellValue("固定资产净值");
					Cell dCell65 = dataRow2.createCell(6);
					dCell65.setCellValue(data.getValue("net_value").toString());
					}
				}
			 
			// 设置列宽
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
	 * 创建报废申请excel
	 * @author zjb
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createBfsqcxExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel名称
//		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		MsgElement headMap = responseDTO.getMsgElement("headMap");
//		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			HSSFWorkbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			HSSFSheet sheet = wb.createSheet(excelName);// 建立新的sheet对象
			//样式
			HSSFCellStyle titleStyle = wb.createCellStyle();        //标题样式
            titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
            Font ztFont = wb.createFont();   
            ztFont.setFontHeightInPoints((short)13); // 将字体大小设置为12px   
            ztFont.setFontName("宋体");             // 将“宋体”字体应用到当前单元格上  
            ztFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //加粗  
            titleStyle.setFont(ztFont);
            //合并单元格CellRangeAddress构造参数依次表示起始行，截至行，起始列， 截至列
	        sheet.addMergedRegion(new CellRangeAddress(0,0,0,3)); 
	        sheet.addMergedRegion(new CellRangeAddress(0,0,5,7)); 
			//标题两行开始
            HSSFRow titleRow = sheet.createRow(0);
            
            HSSFCell tc0 = titleRow.createCell(0);
			HSSFCell tc5 = titleRow.createCell(5);
			if(headMap!=null){
			HSSFRichTextString tc0text = new HSSFRichTextString("设备报废单号:"+headMap.getValue("scrape_apply_no"));
	        HSSFRichTextString tc5text = new HSSFRichTextString("设备报废单名称:"+headMap.getValue("scrape_apply_name"));
	         
	        tc0.setCellValue(tc0text);   
	        tc5.setCellValue(tc5text);

	        tc0.setCellStyle(titleStyle);
	      	tc5.setCellStyle(titleStyle);
			
	        
	        HSSFRow titleRow1 = sheet.createRow(1);
	        
	      //合并单元格CellRangeAddress构造参数依次表示起始行，截至行，起始列， 截至列
	        sheet.addMergedRegion(new CellRangeAddress(1,1,0,2)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,3,4)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,5,7));
	        
	        HSSFCell td0 = titleRow1.createCell(0);
			HSSFCell td3 = titleRow1.createCell(3);
			HSSFCell td5 = titleRow1.createCell(5);
			
			String  orgName = headMap.getValue("org_name");
			if(orgName.indexOf("东方地球物理公司")!=1) {
				orgName=orgName.replace("东方地球物理公司","");
			}
			HSSFRichTextString td0text = new HSSFRichTextString("申请单位:"+orgName);	      
	        HSSFRichTextString td3text = new HSSFRichTextString("申请人:"+headMap.getValue("employee_name"));	        
	        HSSFRichTextString td5text = new HSSFRichTextString("申请时间:"+headMap.getValue("apply_date"));
	                
		    td0.setCellValue(td0text);
	        td3.setCellValue(td3text);
	        td5.setCellValue(td5text);
	       
	        td0.setCellStyle(titleStyle);
	        td3.setCellStyle(titleStyle);
	        td5.setCellStyle(titleStyle);
			}
			//表头开始
	        HSSFCellStyle titleStyle1 = wb.createCellStyle();        
            titleStyle1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
            titleStyle1.setBorderTop(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderRight(HSSFCellStyle.BORDER_THIN);
            Font ztFont1 = wb.createFont();   
            ztFont1.setFontHeightInPoints((short)11); // 将字体大小设置为10px   
            ztFont1.setFontName("宋体");             // 将“宋体”字体应用到当前单元格上  
            ztFont1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //加粗  
            titleStyle1.setFont(ztFont1);
			
	        
			HSSFRow rows= sheet.createRow(2);
			for (int i = 0; i < excelHeader.size(); i++) {
				HSSFCell cell = rows.createCell(i);
				HSSFRichTextString text = new HSSFRichTextString(excelHeader.get(i).toString());
				sheet.setColumnWidth(i,5500);
				//给单元格设置内容
   	            cell.setCellValue(text);
   	            cell.setCellStyle(titleStyle1);
			}
			// 数据列
			 HSSFCellStyle titleStyle2 = wb.createCellStyle();        
	            titleStyle2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	            titleStyle2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
	            titleStyle2.setWrapText(true);
	            titleStyle2.setBorderTop(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderRight(HSSFCellStyle.BORDER_THIN);
	            Font ztFont2 = wb.createFont();   
	            ztFont2.setFontHeightInPoints((short)9); // 将字体大小设置为10px   
	            ztFont2.setFontName("宋体");             // 将“宋体”字体应用到当前单元格上  
	            ztFont2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //加粗  
	            titleStyle2.setFont(ztFont2);
			HSSFRow dataRow = null;
			// 写入数据
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(3 + i);
					// 获取数据
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// 创建单元格
						Cell dCell = dataRow.createCell(j);
						// 设置样式
						// 列写入数据
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
			// 设置列宽
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
	 * 创建处置申请详情excel
	 * @author zjb
	 * @param responseDTO
	 * @param times
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String createczsqmxExcel(ISrvMsg responseDTO, double times)
			throws SOAPException, IOException {

		String excelName = responseDTO.getValue("excelName");// excel名称
//		String title = responseDTO.getValue("title");// excel标题
		List excelHeader = responseDTO.getValues("excelHeader");// excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");// excel数据
		MsgElement headMap = responseDTO.getMsgElement("headMap");
//		String sheetName = title;
		if (CollectionUtils.isNotEmpty(excelHeader)) {
			HSSFWorkbook wb = new HSSFWorkbook();// 建立新HSSFWorkbook对象
			HSSFSheet sheet = wb.createSheet(excelName);// 建立新的sheet对象
			//样式
			HSSFCellStyle titleStyle = wb.createCellStyle();        //标题样式
            titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
            Font ztFont = wb.createFont();   
            ztFont.setFontHeightInPoints((short)13); // 将字体大小设置为12px   
            ztFont.setFontName("宋体");             // 将“宋体”字体应用到当前单元格上  
            ztFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //加粗  
            titleStyle.setFont(ztFont);
            //合并单元格CellRangeAddress构造参数依次表示起始行，截至行，起始列， 截至列
	        sheet.addMergedRegion(new CellRangeAddress(0,0,0,3)); 
	        sheet.addMergedRegion(new CellRangeAddress(0,0,5,7)); 
			//标题两行开始
            HSSFRow titleRow = sheet.createRow(0);
            
            HSSFCell tc0 = titleRow.createCell(0);
			HSSFCell tc5 = titleRow.createCell(5);
			
			HSSFRichTextString tc0text = new HSSFRichTextString("设备报废处置单号:"+headMap.getValue("app_no"));
	        HSSFRichTextString tc5text = new HSSFRichTextString("设备报废单名称:"+headMap.getValue("app_name"));
	         
	        tc0.setCellValue(tc0text);   
	        tc5.setCellValue(tc5text);

	        tc0.setCellStyle(titleStyle);
	      	tc5.setCellStyle(titleStyle);
	       
	        
	        HSSFRow titleRow1 = sheet.createRow(1);
	        
	      //合并单元格CellRangeAddress构造参数依次表示起始行，截至行，起始列， 截至列
	        sheet.addMergedRegion(new CellRangeAddress(1,1,0,2)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,3,4)); 
	        sheet.addMergedRegion(new CellRangeAddress(1,1,5,7));
	        
	        HSSFCell td0 = titleRow1.createCell(0);
			HSSFCell td3 = titleRow1.createCell(3);
			HSSFCell td5 = titleRow1.createCell(5);
			
			String  orgName = headMap.getValue("org_name");
			if(orgName.indexOf("东方地球物理公司")!=1) {
				orgName=orgName.replace("东方地球物理公司","");
			}
			if(orgName.indexOf("中国石油集团东方地球物理勘探有限责任公司")!=1) {
				orgName=orgName.replace("中国石油集团东方地球物理勘探有限责任公司","");
			}
			HSSFRichTextString td0text = new HSSFRichTextString("申请单位:"+orgName);	      
	        HSSFRichTextString td3text = new HSSFRichTextString("申请人:"+headMap.getValue("employee_name"));	        
	        HSSFRichTextString td5text = new HSSFRichTextString("申请时间:"+headMap.getValue("apply_date"));
	                
		    td0.setCellValue(td0text);
	        td3.setCellValue(td3text);
	        td5.setCellValue(td5text);
	       
	        td0.setCellStyle(titleStyle);
	        td3.setCellStyle(titleStyle);
	        td5.setCellStyle(titleStyle);
			
			//表头开始
	        HSSFCellStyle titleStyle1 = wb.createCellStyle();        
            titleStyle1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            titleStyle1.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
            titleStyle1.setBorderTop(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	        titleStyle1.setBorderRight(HSSFCellStyle.BORDER_THIN);
            Font ztFont1 = wb.createFont();   
            ztFont1.setFontHeightInPoints((short)11); // 将字体大小设置为10px   
            ztFont1.setFontName("宋体");             // 将“宋体”字体应用到当前单元格上  
            ztFont1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //加粗  
            titleStyle1.setFont(ztFont1);
			
	        
			HSSFRow rows= sheet.createRow(2);
			for (int i = 0; i < excelHeader.size(); i++) {
				HSSFCell cell = rows.createCell(i);
				HSSFRichTextString text = new HSSFRichTextString(excelHeader.get(i).toString());
				sheet.setColumnWidth(i,4500);
				//给单元格设置内容
   	            cell.setCellValue(text);
   	            cell.setCellStyle(titleStyle1);
			}
			// 数据列
			 HSSFCellStyle titleStyle2 = wb.createCellStyle();        
	            titleStyle2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	            titleStyle2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);   
	            titleStyle2.setWrapText(true);
	            titleStyle2.setBorderTop(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		        titleStyle2.setBorderRight(HSSFCellStyle.BORDER_THIN);
	            Font ztFont2 = wb.createFont();   
	            ztFont2.setFontHeightInPoints((short)9); // 将字体大小设置为10px   
	            ztFont2.setFontName("宋体");             // 将“宋体”字体应用到当前单元格上  
	            ztFont2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);    //加粗  
	            titleStyle2.setFont(ztFont2);
			HSSFRow dataRow = null;
			// 写入数据
			MsgElement data = null;
			if (CollectionUtils.isNotEmpty(excelData)) {
				for (int i = 0; i < excelData.size(); i++) {
					// 创建当前行
					dataRow = sheet.createRow(3 + i);
					// 获取数据
					data = excelData.get(i);
					for (int j = 0; j < excelHeader.size(); j++) {
						// 创建单元格
						Cell dCell = dataRow.createCell(j);
						// 设置样式
						// 列写入数据
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
			// 设置列宽
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

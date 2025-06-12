package com.bgp.mcs.service.common.excelIE.util;

import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.DVConstraint;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataValidation;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.bgp.mcs.service.common.CodeSelectOptionsUtil;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：邱庆豹
 * 
 * 描述：poi处理excel类，用来处理excel中的个性化设置信息
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
public class ExcelDoiOperTools {

	public final static int EXCEL_TABLE_TITLE = 0;
	public final static int EXCEL_TABLE_HEAD = 1;
	public final static int EXCEL_TABLE_CONTENT = 2;
	public final static int EXCEL_TABLE_HEAD_RED = 3;
	public final static int EXCEL_TABLE_CONTENT_DATE = 4;
	public final static int EXCEL_TABLE_CONTENT_RED = 5;

	/*
	 * 设置单元格样式
	 * 
	 * @param In:excelStyleType 需要设置的单元格样式、wb
	 * 由于cellStyle是相对于workbook而存在的所以必须传入所要设置的workbook的对象 cell 同上的道理
	 */
	public static void setCellStyle(int excelStyleType, Cell cell) {

		Workbook wb = cell.getSheet().getWorkbook();
		CellStyle style = wb.createCellStyle();
		Font font = wb.createFont();
		switch (excelStyleType) {
		case 0:
			font.setFontHeightInPoints((short) 18);
			font.setFontName("宋体");
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style.setFont(font);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(false);
			break;
		case 1:
			font.setFontHeightInPoints((short) 14);
			font.setFontName("宋体");
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style.setFont(font);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(false);
			style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style.setBorderTop(HSSFCellStyle.BORDER_THIN);
			break;
		case 2:
			font.setFontHeightInPoints((short) 10);
			font.setFontName("宋体");
			style.setFont(font);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(false);
			style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style.setBorderTop(HSSFCellStyle.BORDER_THIN);
			break;
		case 3:
			font.setFontHeightInPoints((short) 14);
			font.setFontName("宋体");
			font.setColor(Font.COLOR_RED);
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style.setFont(font);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(false);
			style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style.setBorderTop(HSSFCellStyle.BORDER_THIN);
			break;
		case 4:
			font.setFontHeightInPoints((short) 14);
			font.setFontName("宋体");
			font.setColor(Font.COLOR_RED);
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style.setFont(font);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(false);
			CreationHelper helper = wb.getCreationHelper();
			style.setDataFormat(helper.createDataFormat().getFormat("yyyy-MM-dd"));
			break;
		case 5:
			font.setFontHeightInPoints((short) 10);
			font.setFontName("宋体");
			font.setColor(Font.COLOR_RED);
			style.setFont(font);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(false);
			style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style.setBorderTop(HSSFCellStyle.BORDER_THIN);
			style.setFillBackgroundColor(Font.COLOR_RED);
			break;
		}
		cell.setCellStyle(style);
	}

	/*
	 * 设置模板数据类型
	 * 
	 * @paramIn：cell所要设置的workbook的cell对象,map 相关参数信息,isEndAll 整列是否如此这是
	 * 
	 * coding:下拉列表类型、date 日期类型
	 */
	public static void setCellStyle(Cell cell, Map map, boolean isEndAll, int excelStyleType) {
		if (excelStyleType == 1 || excelStyleType == 0) {
			setCellStyle(excelStyleType, cell);
		} else {
			setCellStyleByDataType(cell, map, isEndAll);
		}
	}

	/*
	 * 设置模板数据类型
	 * 
	 * @paramIn：cell所要设置的workbook的cell对象,map 相关参数信息,isEndAll 整列是否如此这是
	 * 
	 * coding:下拉列表类型、date 日期类型
	 */

	public static void setCellStyleByDataType(Cell cell, Map map, boolean isEndAll) {
		Sheet sheet = cell.getRow().getSheet();
		int rowIndex = cell.getRowIndex();
		int columnIndex = cell.getColumnIndex();

		if ("true".equals(map.get("notNull"))) {
			setCellStyle(ExcelDoiOperTools.EXCEL_TABLE_HEAD_RED, cell);
		} else {
			setCellStyle(ExcelDoiOperTools.EXCEL_TABLE_HEAD, cell);
		}

		String dataType = (String) map.get("dataType");

		// if ("date".equals(dataType)) {
		// if (isEndAll) {
		// rowIndex += 1;
		// for (; rowIndex < 10000; rowIndex++) {
		// Cell cellMore = sheet.createRow(rowIndex).createCell(columnIndex);
		// setCellStyle(ExcelDoiOperTools.EXCEL_TABLE_CONTENT_DATE, cellMore);
		// }
		// }
		//
		// } else
		if ("coding".equals(dataType)) {

			int startRow = rowIndex + 1;
			int endRow = startRow;
			int startCol = columnIndex;
			int endCol = columnIndex;
			if (isEndAll) {
				endRow = 10000;
			}
			setCellStyleSelectOption(sheet, (String) map.get("codeAffordType"), startRow, endRow, startCol, endCol);
		}

	}

	/*
	 * 设置下拉列表
	 */
	public static void setCellStyleSelectOption(Sheet sheet, String codeAffordType, int startRow, int endRow, int startCol, int endCol) {
		List<Map> listCode = CodeSelectOptionsUtil.getOptionByName((String) (codeAffordType));
		String[] textList = new String[listCode.size()];
		for (int j = 0; listCode != null && j < listCode.size(); j++) {
			Map mapCode = listCode.get(j);
			textList[j] = (String) mapCode.get("label");
		}
		DVConstraint constraint = DVConstraint.createExplicitListConstraint(textList);
		CellRangeAddressList dataList = null;
		dataList = new CellRangeAddressList(startRow, endRow, startCol, endCol);
		HSSFDataValidation data_validation = new HSSFDataValidation(dataList, constraint);
		data_validation.setEmptyCellAllowed(false);
		data_validation.setShowPromptBox(false);
		data_validation.createErrorBox("无效输入!", "请选择下拉列表");
		data_validation.createPromptBox("输入提示!", "请选择下拉列表里的内容!");
		sheet.addValidationData(data_validation);

	}

	/*
	 * 设置不正确的行的样式
	 */
	public static XSSFCellStyle getCellStyleValError(XSSFWorkbook book) {
		// 设置验证不正确的行的样式
		Font font = book.createFont();
		font.setFontName("宋体");
		font.setFontHeightInPoints((short) 14);
		font.setBoldweight((short) 700);
		font.setColor(IndexedColors.RED.getIndex());
		XSSFCellStyle cellStyle = book.createCellStyle();
		cellStyle.setFillBackgroundColor(IndexedColors.RED.getIndex());
		cellStyle.setFillForegroundColor(IndexedColors.RED.getIndex());
		cellStyle.setBorderBottom(CellStyle.BORDER_THIN);
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN);
		cellStyle.setBorderRight(CellStyle.BORDER_THIN);
		cellStyle.setBorderTop(CellStyle.BORDER_THIN);
		cellStyle.setFont(font);
		return cellStyle;
	}

//	/*
//	 * 将excel上传到服务器中
//	 */
//	public static String uploadExcelToServer(OMSFormFile dataFile, String filePath, XSSFWorkbook book) throws Exception {
//		String name = dataFile.getFileName();
//		// 通过得到系统时间加随机数生成新文件名，避免重复
//		int random = (int) (Math.random() * 10000);
//		String fileName = System.currentTimeMillis() + random + name.substring(name.indexOf("."));
//		// 输出流
//		filePath=filePath.replace("\\", "/");
//		FileOutputStream output = new FileOutputStream(filePath + fileName);
//		book.write(output);
//		output.flush();
//		output.close();
//		return fileName;
//	}
}

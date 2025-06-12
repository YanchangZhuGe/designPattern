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
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ����챪
 * 
 * ������poi����excel�࣬��������excel�еĸ��Ի�������Ϣ
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
	 * ���õ�Ԫ����ʽ
	 * 
	 * @param In:excelStyleType ��Ҫ���õĵ�Ԫ����ʽ��wb
	 * ����cellStyle�������workbook�����ڵ����Ա��봫����Ҫ���õ�workbook�Ķ��� cell ͬ�ϵĵ���
	 */
	public static void setCellStyle(int excelStyleType, Cell cell) {

		Workbook wb = cell.getSheet().getWorkbook();
		CellStyle style = wb.createCellStyle();
		Font font = wb.createFont();
		switch (excelStyleType) {
		case 0:
			font.setFontHeightInPoints((short) 18);
			font.setFontName("����");
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style.setFont(font);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setWrapText(false);
			break;
		case 1:
			font.setFontHeightInPoints((short) 14);
			font.setFontName("����");
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
			font.setFontName("����");
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
			font.setFontName("����");
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
			font.setFontName("����");
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
			font.setFontName("����");
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
	 * ����ģ����������
	 * 
	 * @paramIn��cell��Ҫ���õ�workbook��cell����,map ��ز�����Ϣ,isEndAll �����Ƿ��������
	 * 
	 * coding:�����б����͡�date ��������
	 */
	public static void setCellStyle(Cell cell, Map map, boolean isEndAll, int excelStyleType) {
		if (excelStyleType == 1 || excelStyleType == 0) {
			setCellStyle(excelStyleType, cell);
		} else {
			setCellStyleByDataType(cell, map, isEndAll);
		}
	}

	/*
	 * ����ģ����������
	 * 
	 * @paramIn��cell��Ҫ���õ�workbook��cell����,map ��ز�����Ϣ,isEndAll �����Ƿ��������
	 * 
	 * coding:�����б����͡�date ��������
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
	 * ���������б�
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
		data_validation.createErrorBox("��Ч����!", "��ѡ�������б�");
		data_validation.createPromptBox("������ʾ!", "��ѡ�������б��������!");
		sheet.addValidationData(data_validation);

	}

	/*
	 * ���ò���ȷ���е���ʽ
	 */
	public static XSSFCellStyle getCellStyleValError(XSSFWorkbook book) {
		// ������֤����ȷ���е���ʽ
		Font font = book.createFont();
		font.setFontName("����");
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
//	 * ��excel�ϴ�����������
//	 */
//	public static String uploadExcelToServer(OMSFormFile dataFile, String filePath, XSSFWorkbook book) throws Exception {
//		String name = dataFile.getFileName();
//		// ͨ���õ�ϵͳʱ���������������ļ����������ظ�
//		int random = (int) (Math.random() * 10000);
//		String fileName = System.currentTimeMillis() + random + name.substring(name.indexOf("."));
//		// �����
//		filePath=filePath.replace("\\", "/");
//		FileOutputStream output = new FileOutputStream(filePath + fileName);
//		book.write(output);
//		output.flush();
//		output.close();
//		return fileName;
//	}
}

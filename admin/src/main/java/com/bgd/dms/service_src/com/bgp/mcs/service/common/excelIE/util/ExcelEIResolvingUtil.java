package com.bgp.mcs.service.common.excelIE.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：邱庆豹
 * 
 * 描述：excel处理分析类，用来获取及生成excel
 */

@SuppressWarnings({ "rawtypes", "unchecked" })
public class ExcelEIResolvingUtil {

	private static RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	public  static ExcelEIResolvingUtil EERU=new ExcelEIResolvingUtil();
	
	private ExcelEIResolvingUtil(){
		
	}
	/*
	 * 构建workbook
	 * 
	 * @param IN:columnList 设置的excel表头信息 、fileContent excel标题信息 、resultList
	 * excel导出的数据
	 * 
	 * @param Out:Workbook对象
	 */
	public  Workbook getWorkbookByXmlAndData(List<Map> columnList, String fileContent, List resultList) {
		Workbook wb = new HSSFWorkbook();
		Sheet sheet = wb.createSheet("sheet0");

		Row row0 = sheet.createRow((short) 0);
		Cell cell0 = row0.createCell(0);
		cell0.setCellValue(fileContent);
		ExcelDoiOperTools.setCellStyle(ExcelDoiOperTools.EXCEL_TABLE_TITLE, cell0);
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, columnList.size() - 1));

		Row row = sheet.createRow((short) 1);
		for (int i = 0; i < columnList.size(); i++) {
			Cell cell = row.createCell(i);
			cell.setCellValue((String) (columnList.get(i).get("name")));
			ExcelDoiOperTools.setCellStyle(ExcelDoiOperTools.EXCEL_TABLE_HEAD, cell);
			sheet.autoSizeColumn(i);
		}
		for (int i = 0; i < resultList.size(); i++) {
			Row rowData = sheet.createRow((short) (i + 2));
			Map mapData = (Map) resultList.get(i);
			for (int j = 0; j < columnList.size(); j++) {
				Cell cell = rowData.createCell(j);
				cell.setCellValue((String) mapData.get((String) (columnList.get(j).get("columnName"))));
				ExcelDoiOperTools.setCellStyle(ExcelDoiOperTools.EXCEL_TABLE_CONTENT,cell);
				sheet.autoSizeColumn(j);
			}
		}
		return wb;
	}

	/*
	 * 构建workbook
	 * 
	 * @param IN:columnList 设置的excel表头信息 、fileContent excel标题信息
	 * 
	 * @param Out:Workbook对象
	 */
	public  Workbook getWorkbookByXml(List<Map> columnList, String fileContent) {
		Workbook wb = new HSSFWorkbook();
		Sheet sheet = wb.createSheet("sheet0");
		Row row0 = sheet.createRow((short) 0);
		Cell cell0 = row0.createCell(0);
		cell0.setCellValue(fileContent);
		ExcelDoiOperTools.setCellStyle(ExcelDoiOperTools.EXCEL_TABLE_TITLE,  cell0);
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, columnList.size() - 1));
		Row row = sheet.createRow((short) 1);
		for (int i = 0; i < columnList.size(); i++) {
			Cell cell = row.createCell(i);
			cell.setCellValue((String) (columnList.get(i).get("name")));
			ExcelDoiOperTools.setCellStyle(cell, columnList.get(i), true, ExcelDoiOperTools.EXCEL_TABLE_CONTENT);
			sheet.autoSizeColumn(i);
		}
		return wb;
	}

	/*
	 * 通过wsfile 解析excel 获取excel中的信息
	 * 
	 * @param IN:file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out:List 将excel解析的数据集放置到list中
	 */
	public  List getExcelDataByWSFile(WSFile file, List<Map> columnList,Map mapUserInfo) throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		if (file.getFilename().endsWith("xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new HSSFWorkbook(is);
			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			for (int m = 2; m < rows; m++) {
				Row row = sheet0.getRow(m);
				int columns = row.getPhysicalNumberOfCells();
				List listMap = new ArrayList();
				int p=0;
				int mapFlag=0;
				for(;p<columnList.size();p++){
					Map mapColumnInfoIn = new HashMap();
					 Map mapColumnInfoInTemp = columnList.get(p);
					 mapColumnInfoIn.putAll(mapColumnInfoInTemp);
					String dataType=(String) mapColumnInfoIn.get("dataType");
					if("userId".equals(dataType)){
						mapColumnInfoIn.put("value", mapUserInfo.get("userId"));
						mapFlag+=1;
					} else if("userName".equals(dataType)){
						mapColumnInfoIn.put("value", mapUserInfo.get("userName"));
						mapFlag+=1;
					} else if("orgId".equals(dataType)){
						mapColumnInfoIn.put("value", mapUserInfo.get("orgId"));
						mapFlag+=1;
					} else if("orgSubjectionId".equals(dataType)){
						mapColumnInfoIn.put("value", mapUserInfo.get("orgSubjectionId"));
						mapFlag+=1;
					} else if("codeAffordOrgID".equals(dataType)){
						mapColumnInfoIn.put("value", mapUserInfo.get("codeAffordOrgID"));
						mapFlag+=1;
					} else if("subOrgIDofAffordOrg".equals(dataType)){
						mapColumnInfoIn.put("value", mapUserInfo.get("subOrgIDofAffordOrg"));
						mapFlag+=1;
					} else if("pkValue".equals(dataType)){
						mapColumnInfoIn.put("value", jdbcDao.generateUUID());
						mapFlag+=1;
						listMap.add(mapColumnInfoIn);
					} else if("projectInfoNo".equals(dataType)){
						mapColumnInfoIn.put("value", mapUserInfo.get("projectInfoNo"));
						mapFlag+=1;
						listMap.add(mapColumnInfoIn);
					} 
				}
				for (int n = 0; n < columns; n++) {
					Cell cell = row.getCell(n);
					
					Map mapColumnInfoIn = new HashMap();
					 Map mapColumnInfoInTemp = columnList.get(n + mapFlag);
					 mapColumnInfoIn.putAll(mapColumnInfoInTemp);
					 if(cell ==null){
						 mapColumnInfoIn.put("value", null);
					 }else{
						 int cellType = cell.getCellType();
							switch (cellType) {
							case 0:
								if (HSSFDateUtil.isCellDateFormatted(cell)) {
									mapColumnInfoIn.put("value", cell.getDateCellValue());
								} else {
									mapColumnInfoIn.put("value", String.valueOf(cell.getNumericCellValue()));
								}
								break;
							case 1:
								mapColumnInfoIn.put("value", cell.getStringCellValue());
								break;
							case 2:
								mapColumnInfoIn.put("value", "");
								break;
							case 3:
								mapColumnInfoIn.put("value", "");
								break;
							case 4:
								mapColumnInfoIn.put("value", "");
								break;
							case 5:
								mapColumnInfoIn.put("value", "");
								break;
							}
							String dataType = (String) mapColumnInfoIn.get("dataType");
							String notNull = (String) (mapColumnInfoIn.get("notNull") == null ? "" : mapColumnInfoIn.get("notNull"));
							int nowCol=n+1;
							int nowRow=m+1;
							if ("true".equals(notNull) && ("".equals(mapColumnInfoIn.get("value")) || mapColumnInfoIn.get("value") == null)) {
								
								throw new ExcelExceptionHandler("第" + nowRow + "行第" + nowCol + "列数据不能为空");
							}
							if ("string".equals(dataType) && mapColumnInfoIn.get("value") != null) {
								int length = 32;

								if (mapColumnInfoIn.get("length") != null && !"".equals(mapColumnInfoIn.get("length"))) {
									length = Integer.parseInt((String) mapColumnInfoIn.get("length"));
								}
								String value = (String) mapColumnInfoIn.get("value");
								int lengthV = value.length();
								if (length < lengthV) {
									throw new ExcelExceptionHandler("第" + nowRow + "行第" + nowCol + "列数据太长，数据长度不能超过" + length);
								}
							}else if("date".equals(dataType) && mapColumnInfoIn.get("value") != null){
								int a = 1;
							}
							else if ("float".equals(dataType) && mapColumnInfoIn.get("value") != null) {
								int length = 12;

								if (mapColumnInfoIn.get("length") != null && !"".equals(mapColumnInfoIn.get("length"))) {
									length = Integer.parseInt((String) mapColumnInfoIn.get("length"));
								}
								String value = (String) mapColumnInfoIn.get("value");
								int lengthV = value.length();
								if (length < lengthV) {
									throw new ExcelExceptionHandler("第" + nowRow + "行第" + nowCol + "列数据太长，数据长度不能超过" + length);
								}

								int decLength = 2;
								if (mapColumnInfoIn.get("decimal") != null && !"".equals(mapColumnInfoIn.get("decimal"))) {
									decLength = Integer.parseInt((String) mapColumnInfoIn.get("decimal"));
								}
								if(value.lastIndexOf(".0")!=-1){
									value=value.substring(0, value.length()-2);
								}
								int decLengthV = value.split("[.]").length > 1 ? value.split("[.]")[1].length() : 0;
								if (decLengthV != decLength) {
									throw new ExcelExceptionHandler("第" + nowRow + "行第" + nowCol + "列数据格式不正确，小数位数只能为" + decLength);
								}
								mapColumnInfoIn.remove("value");
								mapColumnInfoIn.put("value", Float.valueOf(value));
							}
					 }
					
					listMap.add(mapColumnInfoIn);
				}
				dataList.add(listMap);
				listMap=null;
			}
			
		}
		return dataList;
	}
}

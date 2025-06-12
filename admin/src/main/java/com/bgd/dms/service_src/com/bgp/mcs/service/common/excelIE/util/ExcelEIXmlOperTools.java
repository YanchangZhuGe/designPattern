package com.bgp.mcs.service.common.excelIE.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.bgp.mcs.service.common.excelIE.srv.TsExcelExportImportSrv;


/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：邱庆豹
 *       
 * 描述：XML操作类，用来获取通用导入导出xml配置中设置的相关信息
 */

@SuppressWarnings({ "rawtypes", "unchecked" })
public class ExcelEIXmlOperTools {

	private static String xmlName="excelConfigInfo.xml";

	/*
	 * 获取xml中excel导出信息
	 * 
	 * @param In: modelName xlm中配置的模块id
	 * 
	 * @param Out: fileName 导出的文件名 、fileTitle 导出的文件内容的主标题、columnList xml中设置的列信息、sql xml中设置的导出sql
	 */
	public static Map  getExportXmlData(String modelName) throws DocumentException{
		Element model;
		Element sqlInfo;
		Element column;
		List<Map> columnList ;
		SAXReader reader = new SAXReader();
		Document doc  = reader.read(TsExcelExportImportSrv.class.getClassLoader().getResourceAsStream("excelConfigInfo.xml"));
		Element root = doc.getRootElement();
		Map returnMap=new HashMap();
		for (Iterator i = root.elementIterator("model"); i.hasNext();) {
			doc = reader.read(TsExcelExportImportSrv.class.getClassLoader().getResourceAsStream(xmlName));
			model = (Element) i.next();
			if (modelName.equals(model.attributeValue("name"))) {
				String fileName=model.attributeValue("fileName");
				String fileTitle=model.attributeValue("fileTitle");
				columnList = new ArrayList();
				model = model.element("Export");
				for (Iterator j = model.elementIterator("column"); j.hasNext();) {
					column = (Element) j.next();
					Map map = new HashMap();
					map.put("name", column.attributeValue("name"));
					map.put("dataType", column.attributeValue("dataType"));
					map.put("columnName", column.attributeValue("columnName"));
					columnList.add(map);
				}
				sqlInfo = model.element("sqlInfo");
				String sql = sqlInfo.getStringValue();
				returnMap.put("columnList", columnList);
				returnMap.put("fileName", fileName);
				returnMap.put("fileTitle", fileTitle);
				returnMap.put("sql", sql);
			}
			
		}
		return returnMap;
	}
	/*
	 * 获取xml中excel导出模板信息
	 * 
	 * @param In: modelName xlm中配置的模块id
	 * 
	 * @param Out: fileName 导出的文件名 、fileTitle 导出的文件内容的主标题、columnList xml中设置的列信息
	 */
	public static Map getExportTemplateXmlData(String modelName) throws DocumentException{
		Element model;
		Element column;
		List<Map> columnList ;
		SAXReader reader = new SAXReader();
		Document doc  = reader.read(TsExcelExportImportSrv.class.getClassLoader().getResourceAsStream("excelConfigInfo.xml"));
		Element root = doc.getRootElement();
		Map returnMap=new HashMap();
		for (Iterator i = root.elementIterator("model"); i.hasNext();) {
			model = (Element) i.next();
			if (modelName.equals(model.attributeValue("name"))) {
				String fileName=model.attributeValue("fileName");
				String fileTitle=model.attributeValue("fileTitle");
				columnList = new ArrayList();
				model = model.element("Import").element("sqlImport");
				for (Iterator j = model.elementIterator("column"); j.hasNext();) {
					column = (Element) j.next();
					Map map = new HashMap();
					map.put("name", column.attributeValue("name"));
					map.put("dataType", column.attributeValue("dataType"));
					map.put("columnName", column.attributeValue("columnName"));
					map.put("fkSql", column.attributeValue("fkSql"));
					map.put("length", column.attributeValue("length"));
					map.put("decimal", column.attributeValue("decimal"));
					map.put("notNull", column.attributeValue("notNull"));
					map.put("codeAffordType", column.attributeValue("codeAffordType"));
					if(!"pkValue".equals(column.attributeValue("dataType"))&&!"projectInfoNo".equals(column.attributeValue("dataType"))){
						columnList.add(map);
					}
				}
				returnMap.put("columnList", columnList);
				returnMap.put("fileName", fileName);
				returnMap.put("fileTitle", fileTitle);
			}
		}
		return returnMap;
	}
	/*
	 * 获取xml中excel导入信息
	 * 
	 * @param In: modelName xlm中配置的模块id
	 * 
	 * @param Out: columnList xml中设置的列信息、sql xml中设置的导出sql
	 */
	public static Map getImportXmlData(String modelName) throws DocumentException{
		Element model;
		Element sqlInfo;
		Element column;
		List<Map> columnList;
		SAXReader reader = new SAXReader();
		Document doc  = reader.read(TsExcelExportImportSrv.class.getClassLoader().getResourceAsStream("excelConfigInfo.xml"));
		Element root = doc.getRootElement();
		Map returnMap=new HashMap();
		for (Iterator i = root.elementIterator("model"); i.hasNext();) {
			model = (Element) i.next();
			if (modelName.equals(model.attributeValue("name"))) {
				columnList = new ArrayList();
				model = model.element("Import").element("sqlImport");
				for (Iterator j = model.elementIterator("column"); j.hasNext();) {
					column = (Element) j.next();
					Map map = new HashMap();
					map.put("name", column.attributeValue("name"));
					map.put("dataType", column.attributeValue("dataType"));
					map.put("columnName", column.attributeValue("columnName"));
					map.put("fkSql", column.attributeValue("fkSql"));
					map.put("length", column.attributeValue("length"));
					map.put("decimal", column.attributeValue("decimal"));
					map.put("notNull", column.attributeValue("notNull"));
					map.put("codeAffordType", column.attributeValue("codeAffordType"));
					columnList.add(map);
				}
				
				sqlInfo = model.element("sqlInfo");
				String sql = sqlInfo.getStringValue();
				returnMap.put("columnList", columnList);
				returnMap.put("sql", sql);
			}
		}
		return returnMap;
	}
}

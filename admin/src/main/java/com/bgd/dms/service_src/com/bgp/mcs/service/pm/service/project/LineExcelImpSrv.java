package com.bgp.mcs.service.pm.service.project;

import java.io.ByteArrayInputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import jxl.CellType;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;

public class LineExcelImpSrv  extends BaseService {
	
	
	/**
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg importExcelDataLineDesign(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		String	workMethod = reqDTO.getValue("workMethod");	//2 | 3| 02（完成）
		String	isSea = reqDTO.getValue("isSea");	//y | n 是否为深海项目 add by bianshen
		if(isSea==null||"".equals(isSea)){
			isSea = "n";
		}
		StringBuffer message = new StringBuffer("");
		
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					row = sheet.getRow(1);
					// 验证文件表头
					boolean bCheck = checkFileHeader(isSea,workMethod , row);
					boolean bSaveFlag = true;
					
					// 
					if(bCheck){
						int rows = sheet.getPhysicalNumberOfRows();
						int headerCells = row.getPhysicalNumberOfCells();
						if(rows >= 2){
							// 读取数据(行号大于2时存在数据)
							//去掉最后行空数据
							int endRow = rows - 1;
							Row endDataRow = sheet.getRow(endRow);
							int endDataCells = endDataRow.getPhysicalNumberOfCells();
							for(int j=0; j <= endDataCells; j++){
								Cell endRowCell = endDataRow.getCell(j);
								if(endRowCell != null){
									endRowCell.setCellType(1);
									String endCellValue = endRowCell.getStringCellValue().trim();
									if("".equals(endCellValue)){
										rows = endRow;
										break;
									}
								}else{
									rows = endRow;
									break;
								}
							}
							List<Map> dataList = new ArrayList<Map>();
							Map tbColumnMap = getTableColumn(isSea,workMethod);
							Map fileColumnMap = getTemplateHeader(isSea,workMethod);
							for(int i=2; i<= rows; i++){
								Row dataRow = sheet.getRow(i);
								
								if(dataRow == null){
									continue;
								}
								Map recordMap = new HashMap();
								if("2".equals(workMethod)){
									recordMap.put("object_id","");
								}else if("3".equals(workMethod)){
									recordMap.put("group_design_no", "");
								}else {
									recordMap.put("object_id","");
								}
								int dataCells = dataRow.getPhysicalNumberOfCells();
								if (dataCells > headerCells){
									dataCells = headerCells;
								}
								for(int j=0; j <= dataCells; j++){
								//	if(j==0) continue;
									
									Cell cell = dataRow.getCell(j);
									if (cell != null && !"".equals(cell.toString())) {
										cell.setCellType(1);
										String cellValue = cell.getStringCellValue().trim();
										int key = j+2;
										String tableColumn = (String)tbColumnMap.get(""+key);
									
										// 验证数据与类型是否匹配
										boolean bDataType = true;
										if(tableColumn!="line_group_id" && tableColumn!="notes"&&tableColumn!="cable_num_len"){
											bDataType = isNumeric(cellValue);
										}
										if(bDataType){
											recordMap.put(tableColumn, cellValue);
										}else{
											int line = i + 1;
											String columnTitle = (String)fileColumnMap.get(""+key);
											
											message.append("第[").append(line).append("]行'").append(columnTitle).append("'列应为数值!");
											bSaveFlag = false;
											break;
										}
									}else{
										continue;
									}
								}
								dataList.add(recordMap);
							}
							if(bSaveFlag == true){
								// 保存数据todo
								String tableName = "";
								if("2".equals(workMethod)){
									tableName = "gp_ops_2dwa_line_design";
								}else if("3".equals(workMethod)){
									tableName = "gp_ops_3dwa_group_design";
								}else{
									tableName = "gp_ops_2dwa_line_complete";
								}
								String rts = saveLineDesignToDB(user, tableName, dataList);
								message.append(rts);
							}
						}
					}else{
						message.append("导入文件表头格式不符!");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				//System.out.println("Exception:"+e.getMessage());
			}
		}
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
	
	
	/*
	 * 技术指标完成情况导入
	 * 
	 */
	public ISrvMsg importExcelTechnologyComplete(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
	    String	workMethod = reqDTO.getValue("workMethod");	//2 | 3| 02（完成），03（技术指标）
		String	isSea = reqDTO.getValue("isSea");	//y | n 是否为深海项目 add by bianshen
		if(isSea==null||"".equals(isSea)){
			isSea = "n";
		}
		StringBuffer message = new StringBuffer("");
		
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					row = sheet.getRow(1); 
					// 验证文件表头
					boolean bCheck = checkFileHeader(isSea,workMethod , row);
					boolean bSaveFlag = true;
					
					// 
					if(bCheck){
						int rows = sheet.getPhysicalNumberOfRows();
						int headerCells = row.getPhysicalNumberOfCells();
						if(rows >= 2){
							// 读取数据(行号大于2时存在数据)
							//去掉最后行空数据
							int endRow = rows - 1;
							Row endDataRow = sheet.getRow(endRow);
							int endDataCells = endDataRow.getPhysicalNumberOfCells();
							for(int j=0; j <= endDataCells; j++){
								Cell endRowCell = endDataRow.getCell(j);
								if(endRowCell != null){
									endRowCell.setCellType(1);
									String endCellValue = endRowCell.getStringCellValue().trim();
									if("".equals(endCellValue)){
										rows = endRow;
										break;
									}
								}else{
									rows = endRow;
									break;
								}
							}
							List<Map> dataList = new ArrayList<Map>();
							Map tbColumnMap = getTableColumn(isSea,workMethod);
							Map fileColumnMap = getTemplateHeader(isSea,workMethod);
							for(int i=2; i<= rows; i++){
								Row dataRow = sheet.getRow(i);
								
								if(dataRow == null){
									continue;
								}
								Map recordMap = new HashMap();
								if("03".equals(workMethod)){
									recordMap.put("object_id","");
								} 
								int dataCells = dataRow.getPhysicalNumberOfCells();
								if (dataCells > headerCells){
									dataCells = headerCells;
								}
								for(int j=0; j <= dataCells; j++){
								//	if(j==0) continue;
									
									Cell cell = dataRow.getCell(j);
									if (cell != null && !"".equals(cell.toString())) {
										cell.setCellType(1);
										String cellValue = cell.getStringCellValue().trim();
										int key = j+2;
										String tableColumn = (String)tbColumnMap.get(""+key);
									
										// 验证数据与类型是否匹配
										boolean bDataType = true;
										if(tableColumn!="target_zone_name"  && tableColumn!="basic_frequency"  && tableColumn!="bandwidth" && tableColumn!="notes"){
											bDataType = isNumeric(cellValue);
										}
										if(bDataType){
											recordMap.put(tableColumn, cellValue);
										}else{
											int line = i + 1;
											String columnTitle = (String)fileColumnMap.get(""+key);
											
											message.append("第[").append(line).append("]行'").append(columnTitle).append("'列应为数值!");
											bSaveFlag = false;
											break;
										}
									}else{
										continue;
									}
								}
								dataList.add(recordMap);
							}
							if(bSaveFlag == true){
								// 保存数据todo
								String tableName = "";
								if("03".equals(workMethod)){
									tableName = "gp_ops_technology_complete";
								} 
								String rts = saveLineDesignToDB(user, tableName, dataList);
								message.append(rts);
							}
						}
					}else{
						message.append("导入文件表头格式不符!");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				//System.out.println("Exception:"+e.getMessage());
			}
		}
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
	
	
	public String saveLineDesignToDB(UserToken user, String tableName , List<Map> list) throws Exception{
		StringBuffer writeDBMessage = new StringBuffer();
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		//String deleteSql = " delete from " + tableName +" where project_info_no = '" +user.getProjectInfoNo() +"'";
		String deleteSql = "";
		if("gp_ops_2dwa_line_design".equals(tableName) || "gp_ops_2dwa_line_design" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator_id = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}else if("gp_ops_3dwa_group_design".equals(tableName) || "gp_ops_3dwa_group_design" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}else if("gp_ops_2dwa_line_complete".equals(tableName) || "gp_ops_2dwa_line_complete" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator_id = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}else if("gp_ops_technology_complete".equals(tableName) || "gp_ops_technology_complete" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator_id = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}
		
		try{
			jdbcDao.executeUpdate(deleteSql);
		}catch(Exception e){
			writeDBMessage.append("清除已有数据失败!");
			return writeDBMessage.toString();
		}
		
//		if(list != null && list.size() > 0){
//			for(int i=0; i <list.size(); i++){
//				Map map = list.get(i);
//				map.put("project_info_no", user.getProjectInfoNo());
//				map.put("bsflag", "0");
//				map.put("creator", user.getEmpId());
//				map.put("create_date", new Date());
//				map.put("updator", user.getEmpId());
//				map.put("modifi_date", new Date());
//				map.put("order_num", i+1);
//				try{
//					Serializable entityId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,tableName);
//				}catch(Exception e){
//					int line = i + 1;
//					writeDBMessage.append("第[").append(line).append("]行数据写入数据库失败!");
//					return writeDBMessage.toString();
//				}
//			}
//		}
		// 修改为批量导入
		if(list != null && list.size() > 0){
			List<Map> newList = new ArrayList<Map>();
			String pk_name = "group_design_no";
			String creatorColumn = "creator";
			String updatorColumn = "updator";
			 
			if("gp_ops_2dwa_line_design".equals(tableName) || "gp_ops_2dwa_line_complete".equals(tableName) || "gp_ops_technology_complete".equals(tableName)){

				pk_name = "object_id";
				creatorColumn = "creator_id";
				updatorColumn = "updator_id";
			}
			for(int i=0; i <list.size(); i++){
				Map map = list.get(i);
				map.put("project_info_no", user.getProjectInfoNo());
				
				map.put("ORG_ID", user.getOrgId());
				map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
				 
				map.put(updatorColumn, user.getEmpId());
				map.put("modifi_date", new Date());
				
				map.put("bsflag", "0");
				map.put(creatorColumn, user.getEmpId());
				map.put("create_date", new Date());
				map.put("order_num", i+1);
				map.put(pk_name, jdbcDao.generateUUID());
				
				newList.add(map);
			}
			DBDataService dbSrv = new DBDataService();
			List strSqlList = dbSrv.mapsToBatchInsertSql(newList, tableName);
			
			int insertResult = dbSrv.executeBatchSql(strSqlList);
			if(insertResult < 0){
				writeDBMessage.append("数据写入数据库失败!");
				return writeDBMessage.toString();
			}
		}
		return writeDBMessage.toString();
	}
	
	private boolean checkFileHeader(String isSea,String workMethod ,Row row){
		boolean result = true;
		Map columns = getTemplateHeader(isSea,workMethod);
		int templateCols = columns.size();
		int physicalCols = row.getPhysicalNumberOfCells();
		if(physicalCols != templateCols){
			result = false;
		}else{
			for(int m=0; m<physicalCols; m++){
				Cell cell = row.getCell(m);
				cell.setCellType(1);
				String cellValue = cell.getStringCellValue().trim().toUpperCase();
				String columnName = (String)columns.get((m+1)+"");
				if(!columnName.equals(cellValue)){
					result = false;
					break;
				}
			}
		}
		return result;
	}
	private boolean checkLineReportFileHeader(Row row){
		boolean result = true;
		Map columns = this.getWeekReportHeader();
		int templateCols = columns.size();
		int physicalCols = row.getPhysicalNumberOfCells();
		int compareNumber = 0;
		if(physicalCols!=templateCols){
			result = false;
		}else{
			for(int m=1; m<templateCols; m++){
				Cell cell = row.getCell(m-1);
				cell.setCellType(1);
				String cellValue = cell.getStringCellValue().trim().toUpperCase();
				String columnName = (String)columns.get(m+"");
				if(!columnName.equals(cellValue)){
					result = false;
					break;
				}
			}
		}
		return result;
		
	}
	private boolean checkLineTempFileHeader(Row row){
		//二维比较前12项,三维比较前5项
		boolean result = true;
		Map columns = this.getLineTempHeader();
		int templateCols = columns.size();
		int physicalCols = row.getPhysicalNumberOfCells();
		int compareNumber = 20;
		 
			 
		 
		if(physicalCols!= templateCols){
			result = false;
		}else{
			for(int m=0; m<compareNumber; m++){
				Cell cell = row.getCell(m);
				cell.setCellType(1);
				String cellValue = cell.getStringCellValue().trim();
				String columnName = (String)columns.get(""+(m+1)+"");
				if(!columnName.equals(cellValue)){
					result = false;
					break;
				}
			}
		}
		return result;
	}
	private Map getLineTempHeader(){
		Map columnMap = new HashMap();
		 
			columnMap.put("1", "序号");
			columnMap.put("2", "测线号/线束号");
			columnMap.put("3", "震源类型");
			columnMap.put("4", "施工长度(km)/面积(km2)");
			columnMap.put("5", "资料长度(km)/面积(km2)");
			columnMap.put("6", "炮点面积(km)/面积(km2)");
			columnMap.put("7", "满覆盖长度(km)/面积(km2)");
			columnMap.put("8", "激发点数(炮)");
			columnMap.put("9", "接收点数(点)");
			columnMap.put("10", "记录张数(张)");
			columnMap.put("11", "合格张数(张)");
			columnMap.put("12", "合格率(%)");
			columnMap.put("13", "不合格张数(张)");
			columnMap.put("14", "不合格率（%）");
			columnMap.put("15", "空炮数(炮)");
			columnMap.put("16", "空炮率(%)");
			columnMap.put("17", "试验炮数(炮)");
			columnMap.put("18", "合格微测井数(点)");
			columnMap.put("19", "合格小折射点数(点)");
			columnMap.put("20", "合格大折射点数(点)");

		 
		return columnMap;
	}
	private Map getLineTempColumn(){
		Map columnMap = new HashMap();
	 
			columnMap.put("1", "line_num");
			columnMap.put("2", "line_group_id");
			columnMap.put("3", "epicentre_type");
			columnMap.put("4", "construction_length");
			columnMap.put("5", "data_area");
			columnMap.put("6", "shot_area");
			columnMap.put("7", "full_fold_area");
			columnMap.put("8", "excitation_points");
			columnMap.put("9", "receiveing_points");
			columnMap.put("10", "record_num");
			columnMap.put("11", "qualified_num");
			columnMap.put("12", "qualifier_ratio");
			columnMap.put("13", "unqualified_num");
			columnMap.put("14", "unqualified_ratio");
			columnMap.put("15", "null_shot");
			columnMap.put("16", "null_shot_ratio");
			columnMap.put("17", "test_shot");
			columnMap.put("18", "pass_weice");
			columnMap.put("19", "small_refraction");
			columnMap.put("20", "big_refraction");

		 
		return columnMap;
	}
public String saveLineTempToDB(UserToken user, String tableName , List<Map> list) throws Exception{
		
		StringBuffer writeDBMessage = new StringBuffer();
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String project_info_no = user.getProjectInfoNo();
		String sql = " select org_id,org_subjection_id from gp_task_project_dynamic where project_info_no ='"+project_info_no+"' and bsflag='0' ";
		Map map_org = jdbcDao.queryRecordBySQL(sql);
		String org_id=map_org.get("org_id").toString();
		String org_subjection_id=map_org.get("org_subjection_id").toString();
		
		String deleteSql = "";
		if("gp_ops_group_finish".equals(tableName) || "gp_ops_group_finish" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}
		try{
			jdbcDao.executeUpdate(deleteSql);
		}catch(Exception e){
			writeDBMessage.append("清除已有数据失败!");
			return writeDBMessage.toString();
		}
		// 修改为批量导入
		if(list != null && list.size() > 0){
			List<Map> newList = new ArrayList<Map>();
			String pk_name = "group_id"; 
		
			for(int i=0; i <list.size(); i++){
				Map map = list.get(i);
				map.put("project_info_no", user.getProjectInfoNo());
				map.put("bsflag", "0");
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("order_num", i+1);
				map.put("org_id", org_id);
				map.put("org_subjection_id", org_subjection_id);
				map.put(pk_name, jdbcDao.generateUUID());
				if(map != null){
					newList.add(map);
				}
			}
			DBDataService dbSrv = new DBDataService();
			List strSqlList = dbSrv.mapsToBatchInsertSql(newList, tableName);
			
			int insertResult = dbSrv.executeBatchSql(strSqlList);
			if(insertResult < 0){
				writeDBMessage.append("导入失败!");
				return writeDBMessage.toString();
			}else{
				writeDBMessage.append("导入成功!");
				return writeDBMessage.toString();				
			}
		}
		return writeDBMessage.toString();
	}
	
	/**
	 * 导入线束完成情况
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg importExcelDataLineTemp(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
 		String teamName = reqDTO.getValue("teamName");
		StringBuffer message = new StringBuffer("");
		
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				String name = fs.getFilename();
				if (fs.getFilename().indexOf(".xlsx") == -1 && fs.getFilename().indexOf(".xls") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					if(fs.getFilename().indexOf(".xlsx") != -1){
						book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}else if(fs.getFilename().indexOf(".xls") != -1){
						book = new HSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {

 						row = sheet.getRow(1);
					 
					
					// 验证文件表头
					boolean bCheck = checkLineTempFileHeader(row);
					//boolean bCheck = true;
					boolean bSaveFlag = true;
					
					// 
					if(bCheck){
						int rows = sheet.getPhysicalNumberOfRows();
						int headerCells = row.getPhysicalNumberOfCells();
						if(rows >= 2){
							// 读取数据(行号大于4时存在数据)
							int endRow = rows ;
							
							Row endDataRow = sheet.getRow(6-2);
							int endDataCells = endDataRow.getPhysicalNumberOfCells();
						/*	if(endDataCells > 0){
								Cell endRowCell = endDataRow.getCell(0);
								if(endRowCell != null){
									endRowCell.setCellType(1);
									String endCellValue = endRowCell.getStringCellValue().trim();
									if(endCellValue == null || "".equals(endCellValue)){
										Cell cell2 = endDataRow.getCell(1);
										cell2.setCellType(1);
										String cell2_value = cell2.getStringCellValue().trim();
										//如果cell2_value == 总计,去掉最后一行
										if("合计".equals(cell2_value)){
											rows = endRow-1;
										}
									}
								}else{
									rows = endRow-1;
								}
							}						
							*/
							List<Map> dataList = new ArrayList<Map>();
							Map tbColumnMap = getLineTempColumn();
							Map fileColumnMap = getLineTempHeader();
							int startNumber = 0;
 						 
								startNumber = 2;
							  OK:
							for(int i=startNumber; i< rows; i++){
								Row dataRow = sheet.getRow(i);
								
								if(dataRow == null){
									continue;
								}
								Map recordMap = new HashMap();

								recordMap.put("team_name", teamName);
								int dataCells = dataRow.getPhysicalNumberOfCells();
								if (dataCells > headerCells){
									dataCells = headerCells;
								}
								for(int j=0; j <= dataCells; j++){
								//	if(j==0) continue;
									
									Cell cell = dataRow.getCell(j);
									if (cell != null && !"".equals(cell.toString())) {
										cell.setCellType(1);
										String cellValue = cell.getStringCellValue().trim();
										int key = j+1;
										String tableColumn = (String)tbColumnMap.get(""+key);
										if(cellValue.equals("合计")){//根据合计取到 总数据量 为list中每条数据添加此列
											Row dataRowGb = sheet.getRow(i+1);
											Cell cell2=dataRowGb.getCell(j+1);
//											recordMap.put("total_data", );
											for(int m=0;m<dataList.size();m++){
												Map map=dataList.get(m);
												map.put("total_data", cell2.getStringCellValue());
											}
										 
											

										 
											break OK ;
										} 
										 

										// 验证数据与类型是否匹配
										boolean bDataType = true;
										if(tableColumn!="line_group_id" && tableColumn!="epicentre_type" ){
											bDataType = isNumeric(cellValue);
										}
										if(bDataType){
											recordMap.put(tableColumn, cellValue);
										}else{
											int line = i + 1;
											String columnTitle = (String)fileColumnMap.get(""+key);
											
											message.append("第[").append(line).append("]行'").append(columnTitle).append("'列应为数值!");
											bSaveFlag = false;
											break;
										}
									}else{
										continue;
									}
								}
								dataList.add(recordMap);
							}
							if(bSaveFlag == true){
								// 保存数据todo
								String  tableName = "gp_ops_group_finish";
								 
								String rts = saveLineTempToDB(user, tableName, dataList);
								message.append(rts);
							}
						}
					}else{
						message.append("导入文件表头格式不符!");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				//System.out.println("Exception:"+e.getMessage());
			}
		}
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
	private boolean checkLineCompletedFileHeader(String isSea,String workMethod ,Row row){
		//二维比较前12项,三维比较前5项
		boolean result = true;
		Map columns = this.getLineCompletedHeader(isSea,workMethod);
		int templateCols = columns.size();
		int physicalCols = row.getPhysicalNumberOfCells();
		int compareNumber = 0;
		if("2".equals(workMethod)){
			if(isSea.equals("y")){
				compareNumber = 8;
			}else{
				compareNumber = 13;
			}
			
		}else if("3".equals(workMethod)){
			if(isSea.equals("y")){
				compareNumber = 8;
			}else{
				compareNumber = 6;
			}
			
		}
		if(isSea.equals("y")){
			if(physicalCols!=templateCols){
				result = false;
			}else{
				for(int m=1; m<compareNumber; m++){
					Cell cell = row.getCell(m-1);
					cell.setCellType(1);
					String cellValue = cell.getStringCellValue().trim().toUpperCase();
					String columnName = (String)columns.get(m+"");
					if(!columnName.equals(cellValue)){
						result = false;
						break;
					}
				}
			}
		}else{
			if(physicalCols-2 != templateCols){
				result = false;
			}else{
				for(int m=2; m<compareNumber; m++){
					Cell cell = row.getCell(m);
					cell.setCellType(1);
					String cellValue = cell.getStringCellValue().trim().toUpperCase();
					String columnName = (String)columns.get((m-1)+"");
					if(!columnName.equals(cellValue)){
						result = false;
						break;
					}
				}
			}
		}
		
		return result;
	}
	
	// 判断字符串值是否数字
	private boolean isNumeric(String str){
		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");//[0-9]+(.[0-9]?)?+
		Matcher isNum = pattern.matcher(str);
		if( !isNum.matches()){
			return false;
		}
		return true;
	}

	private Map getTemplateHeader(String isSea,String workMethod){
		Map columnMap = new HashMap();
		if(isSea.equalsIgnoreCase("y")){
			columnMap.put("1", "测线号");
			columnMap.put("2", "起始炮点点号");
			columnMap.put("3", "终止炮点点号");
			columnMap.put("4", "测线设计长度");
			columnMap.put("5", "电缆数量及长度");
			columnMap.put("6", "炮点间隔");
			columnMap.put("7", "检波点间距");
			columnMap.put("8", "备 注");
		}else{
			if("2".equals(workMethod)){
				columnMap.put("1", "测线号");
				columnMap.put("2", "检波点首桩号");
				columnMap.put("3", "X坐标");
				columnMap.put("4", "Y坐标");
				columnMap.put("5", "炮点首桩号");
				columnMap.put("6", "X坐标");
				columnMap.put("7", "Y坐标");
				columnMap.put("8", "满覆盖首桩号");
				columnMap.put("9", "X坐标");
				columnMap.put("10", "Y坐标");
				columnMap.put("11", "满覆盖尾桩号");
				columnMap.put("12", "X坐标");
				columnMap.put("13", "Y坐标");
				columnMap.put("14", "炮点尾桩号");
				columnMap.put("15", "X坐标");
				columnMap.put("16", "Y坐标");
				columnMap.put("17", "检波点尾桩号");
				columnMap.put("18", "X坐标");
				columnMap.put("19", "Y坐标");
				
				
				columnMap.put("20", "一次覆盖首桩号");
				columnMap.put("21", "X坐标");
				columnMap.put("22", "Y坐标");
				columnMap.put("23", "一次覆盖尾桩号");
				columnMap.put("24", "X坐标");
				columnMap.put("25", "Y坐标");
				
				columnMap.put("26", "资料长度(KM)");
				columnMap.put("27", "微测井点数(点)");
				columnMap.put("28", "小折射点数(点)");
				columnMap.put("29", "大折射点数(点)");
				
				columnMap.put("30", "满覆盖长度（KM）");
				columnMap.put("31", "实物工作量（KM）");
				columnMap.put("32", "炮线长度（KM）");
				columnMap.put("33", "炮数（个）");
				columnMap.put("34", "检波线长度（KM）");
				columnMap.put("35", "检波点数（个）");
				columnMap.put("36", "备  注");
			}else if("3".equals(workMethod)){
 
				columnMap.put("1", "线束号");
				columnMap.put("2", "起始接收线号");
				columnMap.put("3", "终止接收线号");
				columnMap.put("4", "起始接收点点号");
				columnMap.put("5", "终止接收点点号");
				columnMap.put("6", "起始炮线号");
				columnMap.put("7", "终止炮线号");
				columnMap.put("8", "起始炮点点号");
				columnMap.put("9", "终止炮点点号");
				columnMap.put("10", "炮排数");
				columnMap.put("11", "束线炮数");
				columnMap.put("12", "束线加密炮数");
				columnMap.put("13", "设计总炮数");
				columnMap.put("14", "接收线数");
				columnMap.put("15", "检波点数");
				columnMap.put("16", "偏前满覆盖面积");
				columnMap.put("17", "炮点面积");
				columnMap.put("18", "检波点面积");
				columnMap.put("19", "检波线长度");
				columnMap.put("20", "炮线长度");			
				columnMap.put("21", "总物理点数");
				columnMap.put("22", "表层调查点数");
				columnMap.put("23", "备 注");
			}else if("03".equals(workMethod)){
				columnMap.put("1", "主要目的层名称");
				columnMap.put("2", "目的层埋深(M)");
				columnMap.put("3", "可分辨断距(M)");
				columnMap.put("4", "可分辨厚度(M)");
				columnMap.put("5", "主频(HZ)");
				columnMap.put("6", "频宽(HZ)");			
				columnMap.put("7", "备注");
			}else {
				
				columnMap.put("1", "测线号");	
				columnMap.put("2", "满覆盖首桩号");
				columnMap.put("3", "X坐标");
				columnMap.put("4", "Y坐标");
				columnMap.put("5", "满覆盖尾桩号");
				columnMap.put("6", "X坐标");
				columnMap.put("7", "Y坐标");	
				columnMap.put("8", "一次覆盖首桩号");
				columnMap.put("9", "X坐标");
				columnMap.put("10", "Y坐标");			
				columnMap.put("11", "一次覆盖尾桩号");
				columnMap.put("12", "X坐标");
				columnMap.put("13", "Y坐标");			
				columnMap.put("14", "检波点首桩号");
				columnMap.put("15", "X坐标");
				columnMap.put("16", "Y坐标");
				columnMap.put("17", "检波点尾桩号");
				columnMap.put("18", "X坐标");
				columnMap.put("19", "Y坐标");			
				columnMap.put("20", "备  注");
			}
		}
		
		return columnMap;
	}
	
	private Map getTableColumn(String isSea,String workMethod){
		Map columnMap = new HashMap();
		if(isSea.equalsIgnoreCase("y")){
			columnMap.put("1", "group_design_no");
			columnMap.put("2", "line_group_id");
			columnMap.put("3", "shot_line_start_loc");
			columnMap.put("4", "shot_line_end_loc");
			columnMap.put("5", "measure_design_len");
			columnMap.put("6", "cable_num_len");
			columnMap.put("7", "shot_interval");
			columnMap.put("8", "receiving_track_num");
			columnMap.put("9", "notes");
		}else{
			if("2".equals(workMethod)){
				columnMap.put("1", "object_id");
				columnMap.put("2", "line_group_id");
				columnMap.put("3", "geophone_start_pile");
				columnMap.put("4", "geophone_start_point_x");
				columnMap.put("5", "geophone_start_point_y");
				columnMap.put("6", "shot_start_pile");
				columnMap.put("7", "shot_start_point_x");
				columnMap.put("8", "shot_start_point_y");
				columnMap.put("9", "fullfold_start_pile");
				columnMap.put("10", "fullfold_start_point_x");
				columnMap.put("11", "fullfold_start_point_y");
				columnMap.put("12", "fullfold_end_pile");
				columnMap.put("13", "fullfold_end_point_x");
				columnMap.put("14", "fullfold_end_point_y");
				columnMap.put("15", "shot_end_pile");
				columnMap.put("16", "shot_end_point_x");
				columnMap.put("17", "shot_end_point_y");
				columnMap.put("18", "geophone_end_pile");
				columnMap.put("19", "geophone_end_point_x");
				columnMap.put("20", "geophone_end_point_y");
				
				columnMap.put("21", "first_number");
				columnMap.put("22", "x_coordinate");
				columnMap.put("23", "y_coordinate");
				columnMap.put("24", "last_number");
				columnMap.put("25", "last_x_coordinate");
				columnMap.put("26", "last_y_coordinate");
				
				columnMap.put("27", "data_workload");
				columnMap.put("28", "micro_measue_num");
				columnMap.put("29", "small_regraction_num");
				columnMap.put("30", "big_regraction_num");
				
				columnMap.put("31", "fullfold_len");
				columnMap.put("32", "physical_workload");
				columnMap.put("33", "shot_line_len");
				columnMap.put("34", "sp_num");
				columnMap.put("35", "measuring_line_len");
				columnMap.put("36", "geophone_num");
				columnMap.put("37", "notes");
			}else if("3".equals(workMethod)){ 
				columnMap.put("1", "group_design_no");
				columnMap.put("2", "line_group_id");
				columnMap.put("3", "receiving_line_start_line");
				columnMap.put("4", "receiving_line_end_line");
				columnMap.put("5", "receiving_line_start_loc");
				columnMap.put("6", "receiving_line_end_loc");
				columnMap.put("7", "shot_line_start_line");
				columnMap.put("8", "shot_line_end_line");
				columnMap.put("9", "shot_line_start_loc");
				columnMap.put("10", "shot_line_end_loc");
				columnMap.put("11", "shot_array_num");
				columnMap.put("12", "group_design_shot_num");
				columnMap.put("13", "design_infill_sp_num");
				columnMap.put("14", "design_sp_num");
				columnMap.put("15", "receiveing_line_num");
				columnMap.put("16", "geophone_point");
				columnMap.put("17", "actual_fullfold_area");
				columnMap.put("18", "shot_area");
				columnMap.put("19", "geophone_area");
				columnMap.put("20", "geophone_line_len");
				columnMap.put("21", "shot_line_len");
				columnMap.put("22", "total_point_num");
				columnMap.put("23", "design_surface_3d_sp_num");
				columnMap.put("24", "notes");
				
			}else if("03".equals(workMethod)){ 
				columnMap.put("1", "object_id");
				columnMap.put("2", "target_zone_name");
				columnMap.put("3", "target_zone_depth");
				columnMap.put("4", "resolvable_throw_profile");
				columnMap.put("5", "resolvable_thick");
				columnMap.put("6", "basic_frequency");
				columnMap.put("7", "bandwidth"); 
				columnMap.put("8", "notes");
				
			}else {
				
				columnMap.put("1", "object_id");
				columnMap.put("2", "line_group_id");

		 
				columnMap.put("3", "fullfold_start_pile");
				columnMap.put("4", "fullfold_start_point_x");
				columnMap.put("5", "fullfold_start_point_y");
				columnMap.put("6", "fullfold_end_pile");
				columnMap.put("7", "fullfold_end_point_x");
				columnMap.put("8", "fullfold_end_point_y");
				
				columnMap.put("9", "first_start_number");
				columnMap.put("10", "first_start_point_x");
				columnMap.put("11", "first_start_point_y");
				columnMap.put("12", "first_end_number");
				columnMap.put("13", "first_end_point_x");
				columnMap.put("14", "first_end_point_y");
				
				columnMap.put("15", "geophone_start_pile");
				columnMap.put("16", "geophone_start_point_x");
				columnMap.put("17", "geophone_start_point_y");
				columnMap.put("18", "geophone_end_pile");
				columnMap.put("19", "geophone_end_point_x");
				columnMap.put("20", "geophone_end_point_y");			
				columnMap.put("21", "notes");
			}
		}
		
		//String columnName = (String) columnMap.get(key);
		return columnMap;
	}
	
	private Map getWeekReportHeader(){
		Map columnMap = new HashMap();
		 
		columnMap.put("1", "施工队伍");
		columnMap.put("2", "地区(盆地)");
		columnMap.put("3", "施工井号");
		columnMap.put("4", "甲方名称");
		columnMap.put("5", "已签订合同额(万)");
		columnMap.put("6", "预测价值工作量(万)");
		columnMap.put("7", "完成价值工作量(万)");
		columnMap.put("8", "观测方式");
		columnMap.put("9", "观测井段");
		columnMap.put("10", "观测点距（米）");
		columnMap.put("11", "激发方式");
		columnMap.put("12", "采集级数（级）");
		columnMap.put("13", "接收线数（线）");
		columnMap.put("14", "道距（米）");
		columnMap.put("15", "总接收道数（道）");
		columnMap.put("16", "炮数");
		columnMap.put("17", "合格试验记录");
		columnMap.put("18", "总观测点数");
		columnMap.put("19", "优级品点数");
		columnMap.put("20", "优级品率（%）");
		columnMap.put("21", "合格品点数");
		
		columnMap.put("22", "合格品率（%）");
		columnMap.put("23", "废品点数");
		columnMap.put("24", "废品率（%）");
		columnMap.put("25", "小折射点数");
		columnMap.put("26", "微测井(口)");
		columnMap.put("27", "开工时间");
		columnMap.put("28", "完工时间");
		columnMap.put("29", "运行状态");
		columnMap.put("30", "处理、解释状态");
		columnMap.put("31", "甲方验收日期");
		columnMap.put("32", "备注");
		return columnMap;
	}
		
 
	private Map getLineCompletedHeader(String isSea,String workMethod){//isSea 是否为深海项目
		Map columnMap = new HashMap();
		if("3".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "队号");
				columnMap.put("2", "序号");
				columnMap.put("3", "线束号");
				columnMap.put("4", "设计测线满覆盖");
				columnMap.put("5", "实际完成满覆盖");
				columnMap.put("6", "补线率(%)");
				columnMap.put("7", "施工起止日期");
				columnMap.put("8", "备注");
			}else{
				columnMap.put("1", "测线号");
				columnMap.put("2", "满覆盖面积");
				columnMap.put("3", "炮数");
				columnMap.put("4", "满覆盖面积");
				columnMap.put("5", "炮数");
				columnMap.put("6", "张数");
				columnMap.put("7", "%");
				columnMap.put("8", "张数");
				columnMap.put("9", "%");
				columnMap.put("10", "张数");
				columnMap.put("11", "%");
				columnMap.put("12", "张数");
				columnMap.put("13", "%");
				columnMap.put("14", "张数");
				columnMap.put("15", "%");
				columnMap.put("16", "设计加密炮数");
				columnMap.put("17", "完成加密炮数");
				columnMap.put("18", "施工起止日期");
				columnMap.put("19", "备注");
			}
			
		}else if("2".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "队号");
				columnMap.put("2", "序号");
				columnMap.put("3", "测线号");
				columnMap.put("4", "设计测线满覆盖");
				columnMap.put("5", "实际完成满覆盖");
				columnMap.put("6", "补线率(%)");
				columnMap.put("7", "施工起止日期");
				columnMap.put("8", "备注");
			}else{
				columnMap.put("1", "测线号");
				columnMap.put("2", "覆盖次数");
				columnMap.put("3", "满覆盖点首桩号");
				columnMap.put("4", "满覆盖点尾桩号");
				columnMap.put("5", "满覆盖公里数");
				columnMap.put("6", "炮数");
				columnMap.put("7", "覆盖次数");
				columnMap.put("8", "满覆盖点首桩号");
				columnMap.put("9", "满覆盖点尾桩号");
				columnMap.put("10", "满覆盖公里数");
				columnMap.put("11", "炮点公里数");
				columnMap.put("12", "炮数");
				columnMap.put("13", "张数");
				columnMap.put("14", "%");
				columnMap.put("15", "张数");
				columnMap.put("16", "%");
				columnMap.put("17", "张数");
				columnMap.put("18", "%");
				columnMap.put("19", "张数");
				columnMap.put("20", "%");
				columnMap.put("21", "张数");			
				columnMap.put("22", "%");
				columnMap.put("23", "设计加密炮数");
				columnMap.put("24", "完成加密炮数");
				columnMap.put("25", "施工起止日期");
				columnMap.put("26", "备注");
			}
		}
		return columnMap;
	}
	private Map getWeekReportColumn(){
		Map columnMap = new HashMap();
		
		columnMap.put("1", "org_name");
		columnMap.put("2", "basin");
		columnMap.put("3", "well_number");
		columnMap.put("4", "coding_name");
		columnMap.put("5", "contracts_signed");
		columnMap.put("6", "project_income");
		columnMap.put("7", "complete_value");
		columnMap.put("8", "view_type");
		columnMap.put("9", "view_wells");
		columnMap.put("10", "view_point");
		columnMap.put("11", "build_method");
		columnMap.put("12", "collection_series");
		columnMap.put("13", "view_wells");
		columnMap.put("14", "view_point");
		columnMap.put("15", "collection_series");
		columnMap.put("16", "shot_number");
		columnMap.put("17", "test_record");
		columnMap.put("18", "obs_point");
		columnMap.put("19", "quality_points");
		columnMap.put("20", "quality_rate");
		columnMap.put("21", "pass_point");
		columnMap.put("22", "pass_rate");
		
		columnMap.put("23", "waste_point");
		columnMap.put("24", "waste_rate");
		columnMap.put("25", "ref_points");
		columnMap.put("26", "mic_logging");
		columnMap.put("27", "start_date");
		columnMap.put("28", "end_date");
		columnMap.put("29", "project_status");
		columnMap.put("30", "handle_explain_status");
	
		columnMap.put("31", "pass_date");
		columnMap.put("32", "remarks");
		columnMap.put("33", "type_code");
		return columnMap;
	}
	private Map getLineCompletedColumn(String isSea,String workMethod){//isSea 是否为深海项目
		Map columnMap = new HashMap();
		if("3".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "team_name");
				columnMap.put("2", "order_num");
				columnMap.put("3", "line_group_id");
				columnMap.put("4", "measure_fullfold_area");
				columnMap.put("5", "full_fold_area");
				columnMap.put("6", "repair_rate");
				columnMap.put("7", "construct_begin_end_date");
				columnMap.put("8", "notes");
			}else{
				columnMap.put("1", "line_group_id");
				columnMap.put("2", "measure_fullfold_area");
				columnMap.put("3", "measure_shot_num");
				columnMap.put("4", "full_fold_area");
				columnMap.put("5", "record_num");
				columnMap.put("6", "acceptable_product_num");
				columnMap.put("7", "qualifier_ratio");
				columnMap.put("8", "first_num");
				columnMap.put("9", "first_ratio");
				columnMap.put("10", "seconde_num");
				columnMap.put("11", "seconde_ratio");
				columnMap.put("12", "defective_product_num");
				columnMap.put("13", "defective_product_ratio");
				columnMap.put("14", "no_shoot_num");
				columnMap.put("15", "no_shoot_ratio");
				columnMap.put("16", "design_encrypt_sum_num");
				columnMap.put("17", "infill_sp_num");
				columnMap.put("18", "construct_begin_end_date");
				columnMap.put("19", "notes");
			}
			
		}else if("2".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "team_name");
				columnMap.put("2", "order_num");
				columnMap.put("3", "line_id");
				columnMap.put("4", "measure_fullfold_kilo_num");
				columnMap.put("5", "full_fold_len");
				columnMap.put("6", "repair_rate");
				columnMap.put("7", "construct_begin_end_date");
				columnMap.put("8", "notes");
			}else{
				columnMap.put("1", "line_id");
				columnMap.put("2", "measure_fold_num");
				columnMap.put("3", "measure_fullfold_start_pile");
				columnMap.put("4", "measure_fullfold_end_pile");
				columnMap.put("5", "measure_fullfold_kilo_num");
				columnMap.put("6", "measure_shot_num");
				columnMap.put("7", "profile_fold_num");
				columnMap.put("8", "profile_fullfold_start_pile");
				columnMap.put("9", "profile_fullfold_end_pile");
				columnMap.put("10", "full_fold_len");
				columnMap.put("11", "physical_shot_kilo_num");
				columnMap.put("12", "record_num");
				columnMap.put("13", "acceptable_product_num");
				columnMap.put("14", "qualifier_ratio");
				columnMap.put("15", "first_num");
				columnMap.put("16", "first_ratio");
				columnMap.put("17", "seconde_num");
				columnMap.put("18", "seconde_ratio");
				columnMap.put("19", "defective_product_num");
				columnMap.put("20", "defective_product_ratio");
				columnMap.put("21", "no_shoot_num");			
				columnMap.put("22", "no_shoot_ratio");
				columnMap.put("23", "design_encrypt_sum_num");
				columnMap.put("24", "infill_sp_num");
				columnMap.put("25", "construct_begin_end_date");
				columnMap.put("26", "notes");
			}
			
		}
		return columnMap;
	}
	
	private boolean checkLineConstructionFileHeader(String isSea,String workMethod ,Row row){
		boolean result = true;
		Map columns = this.getLineConstructionHeader(isSea,workMethod);
		int templateCols = columns.size();
		int physicalCols = row.getPhysicalNumberOfCells();
		if(isSea.equals("y")){
			if(physicalCols != templateCols){
				result = false;
			}else{
				for(int m=0; m<18; m++){
					Cell cell = row.getCell(m);
					cell.setCellType(1);
					String cellValue = cell.getStringCellValue().trim().toUpperCase();
					String columnName = (String)columns.get(m+1+"");
					if(!columnName.equals(cellValue)){
						result = false;
						break;
					}
				}
			}
		}else{
			int compareNumber = 5;
			if(physicalCols-1 != templateCols){
				result = false;
			}else{
				for(int m=1; m<compareNumber; m++){
					Cell cell = row.getCell(m);
					cell.setCellType(1);
					String cellValue = cell.getStringCellValue().trim().toUpperCase();
					String columnName = (String)columns.get(m+"");
					if(!columnName.equals(cellValue)){
						result = false;
						break;
					}
				}
			}
		}
		return result;
	}
	
	private Map getLineConstructionColumn(String isSea,String workMethod){
		Map columnMap = new HashMap();
		if("3".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "team_name");
				columnMap.put("2", "order_num");
				columnMap.put("3", "line_group_id");
				columnMap.put("4", "fold");
				columnMap.put("5", "binning_size");
				columnMap.put("6", "track_interval");
				columnMap.put("7", "shot_interval");
				columnMap.put("8", "cable_distance");
				columnMap.put("9", "source_distance");
				columnMap.put("10", "receiving_track_num");
				columnMap.put("11", "cable_depth");
				columnMap.put("12", "array_num");
				columnMap.put("13", "source_num");
				columnMap.put("14", "source_capacity");
				columnMap.put("15", "instrument_model");
				columnMap.put("16", "sample_ratio");
				columnMap.put("17", "record_len");
				columnMap.put("18", "notes");
			}else{
				columnMap.put("1", "line_group_id");
				columnMap.put("2", "layout");
				columnMap.put("3", "fold");
				columnMap.put("4", "binning_size");
				columnMap.put("5", "track_interval");
				columnMap.put("6", "receiving_line_distance");
				columnMap.put("7", "shot_interval");
				columnMap.put("8", "sp_line_interval");
				columnMap.put("9", "vertical_array_mode");
				columnMap.put("10", "receiving_track_num");
				columnMap.put("11", "rolling_mode");
				columnMap.put("12", "element_interval");
				columnMap.put("13", "pat_distance");
				columnMap.put("14", "geophone_comp_graph");
				columnMap.put("15", "well_depth");
				columnMap.put("16", "well_num");
				columnMap.put("17", "explosive_qty");
				columnMap.put("18", "source_comp_graph");
				columnMap.put("19", "source_num");
				columnMap.put("20", "scanning_len");
				columnMap.put("21", "scan_frequency");
				columnMap.put("22", "drive_range");
			 
				columnMap.put("23", "airgun_capacity");
				columnMap.put("24", "airgun_pressure");
				columnMap.put("25", "airgun_intro");
				columnMap.put("26", "airgun_num");
				columnMap.put("27", "airgun_length");
				columnMap.put("28", "airgun_spacing");
				
				
				columnMap.put("29", "instrument_model");
				columnMap.put("30", "preamplifier_gain");
				columnMap.put("31", "sample_ratio");
				columnMap.put("32", "record_len");
				columnMap.put("33", "notes");
			}
			
		}else if("2".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "team_name");
				columnMap.put("2", "order_num");
				columnMap.put("3", "line_id");
				columnMap.put("4", "fold");
				columnMap.put("5", "binning_size");
				columnMap.put("6", "track_interval");
				columnMap.put("7", "shot_interval");
				columnMap.put("8", "cable_distance");
				columnMap.put("9", "source_distance");
				columnMap.put("10", "receiving_track_num");
				columnMap.put("11", "cable_depth");
				columnMap.put("12", "array_num");
				columnMap.put("13", "source_num");
				columnMap.put("14", "source_capacity");
				columnMap.put("15", "instrument_model");
				columnMap.put("16", "sample_ratio");
				columnMap.put("17", "record_len");
				columnMap.put("18", "notes");
			}else{
				columnMap.put("1", "line_id");
				columnMap.put("2", "layout");
				columnMap.put("3", "fold");
				columnMap.put("4", "track_interval");
				columnMap.put("5", "shot_interval");
				columnMap.put("6", "small_dist");
				columnMap.put("7", "receiving_track_num");
				columnMap.put("8", "element_interval");
				columnMap.put("9", "pat_distance");
				columnMap.put("10", "receive_comp_graph");
				columnMap.put("11", "well_depth");
				columnMap.put("12", "well_num");
				columnMap.put("13", "explosive_qty");
				columnMap.put("14", "sp_comp_graph");
				columnMap.put("15", "source_num");
				columnMap.put("16", "scan_frequency");
				columnMap.put("17", "scanning_len");
				columnMap.put("18", "source_comp_graph");
				columnMap.put("19", "instrument_model");
				columnMap.put("20", "preamplifier_gain");
				columnMap.put("21", "sample_ratio");			
				columnMap.put("22", "record_len");
				columnMap.put("23", "notes");
			}
		}
		return columnMap;
	}
	
	private Map getLineConstructionHeader(String isSea,String workMethod){
		Map columnMap = new HashMap();
		if("3".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "队号");
				columnMap.put("2", "序号");
				columnMap.put("3", "线束号");
				columnMap.put("4", "覆盖次数");
				columnMap.put("5", "面元尺寸");
				columnMap.put("6", "道距");
				columnMap.put("7", "炮点距");
				columnMap.put("8", "缆间距");
				columnMap.put("9", "震源间距");
				columnMap.put("10", "接收道数");
				columnMap.put("11", "电缆深度");
				columnMap.put("12", "阵列数");
				columnMap.put("13", "震源数");
				columnMap.put("14", "震源容量");
				columnMap.put("15", "仪器型号");
				columnMap.put("16", "采样率");
				columnMap.put("17", "记录长度");
				columnMap.put("18", "备注");
			}else{
				columnMap.put("1", "线束号");
				columnMap.put("2", "观测系统类型");
				columnMap.put("3", "覆盖次数");
				columnMap.put("4", "面元尺寸");
				columnMap.put("5", "道距M");
				columnMap.put("6", "接收线距M");
				columnMap.put("7", "炮点距M");
				columnMap.put("8", "炮线距M");
				columnMap.put("9", "纵向排列方式");
				columnMap.put("10", "接收道数");
				columnMap.put("11", "滚动方式");
				columnMap.put("12", "组内距M");
				columnMap.put("13", "组合基距M");
				columnMap.put("14", "组合个数及图形");
				columnMap.put("15", "激发井深M");
				columnMap.put("16", "井数(口)");
				columnMap.put("17", "单井药量(KG)");
				columnMap.put("18", "组合井组合图形");
				columnMap.put("19", "台次");
				columnMap.put("20", "扫描长度(S)");
				columnMap.put("21", "扫描频率(HZ)");
				columnMap.put("22", "驱动幅度(%)");
				
				columnMap.put("23", "容量(cu in)");
				columnMap.put("24", "压力(psi)");
				columnMap.put("25", "沉放深度(m)");
				columnMap.put("26", "枪数(条)");
				columnMap.put("27", "陈列长度(m)");
				columnMap.put("28", "子阵间距(m)");
			 
				columnMap.put("29", "仪器型号");
				columnMap.put("30", "前放增益(DB)");
				columnMap.put("31", "采样率(MS)");
				columnMap.put("32", "记录长度(S)");
				columnMap.put("33", "备注");
			}
	
		}else if("2".equals(workMethod)){
			if(isSea.equals("y")){
				columnMap.put("1", "队号");
				columnMap.put("2", "序号");
				columnMap.put("3", "测线号");
				columnMap.put("4", "覆盖次数");
				columnMap.put("5", "面元尺寸");
				columnMap.put("6", "道距");
				columnMap.put("7", "炮点距");
				columnMap.put("8", "缆间距");
				columnMap.put("9", "震源间距");
				columnMap.put("10", "接收道数");
				columnMap.put("11", "电缆深度");
				columnMap.put("12", "阵列数");
				columnMap.put("13", "震源数");
				columnMap.put("14", "震源容量");
				columnMap.put("15", "仪器型号");
				columnMap.put("16", "采样率");
				columnMap.put("17", "记录长度");
				columnMap.put("18", "备注");
			}else{
				columnMap.put("1", "测线号");
				columnMap.put("2", "观测系统类型");
				columnMap.put("3", "覆盖次数");
				columnMap.put("4", "道距(M)");
				columnMap.put("5", "炮点距(M)");
				columnMap.put("6", "纵向排列方式");
				columnMap.put("7", "接收道数");
				columnMap.put("8", "组内距M");
				columnMap.put("9", "基距M");
				columnMap.put("10", "组合个数及图形");
				columnMap.put("11", "激发井深");
				columnMap.put("12", "井数(口)");
				columnMap.put("13", "单井药量(KG)");
				columnMap.put("14", "组合井组合图形");
				columnMap.put("15", "台次");
				columnMap.put("16", "扫描范围");
				columnMap.put("17", "扫描长度");
				columnMap.put("18", "组合图形");
				columnMap.put("19", "仪器型号");
				columnMap.put("20", "前方增益(DB)");
				columnMap.put("21", "采样率MS");			
				columnMap.put("22", "记录长度S");
				columnMap.put("23", "备注");
			}
			
		}
		return columnMap;
	}
	public String saveWeekReportToDB(UserToken user, String tableName , List<Map> list) throws Exception{
		StringBuffer writeDBMessage = new StringBuffer();
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String deleteSql = "";
		if("bgp_ws_daily_report".equals(tableName) || "bgp_ws_daily_report" == tableName){
			deleteSql = "update bgp_ws_daily_report   set  bsflag='1'  where project_info_no = '" +user.getProjectInfoNo() +"'";
		} 
		try{
			jdbcDao.executeUpdate(deleteSql);
		}catch(Exception e){
			writeDBMessage.append("清除已有数据失败!");
			return writeDBMessage.toString();
		}
		// 修改为批量导入
				if(list != null && list.size() > 0){
					List<Map> newList = new ArrayList<Map>();
					 
					for(int i=0; i <list.size(); i++){
						Map map = list.get(i);
						map.put("project_info_no", user.getProjectInfoNo());
						map.put("daily_id", jdbcDao.generateUUID());
						map.put("audit_status", 1);
						map.put("bsflag", 0);
						if(map.get("view_type").equals("微地震地面监测")){
		            	    map.put("type_code", "5110000053000000007");
		            	}
		            	if(map.get("view_type").equals("随钻地震")){
		            	    map.put("type_code","5110000053000000008");
		            	}
						if(map != null){
							newList.add(map);
						}
					}
					DBDataService dbSrv = new DBDataService();
					List strSqlList = dbSrv.weekReportInsertSql(newList, tableName);
					
					int insertResult = dbSrv.executeBatchSql(strSqlList);
					if(insertResult < 0){
						writeDBMessage.append("导入失败!");
						return writeDBMessage.toString();
					}else{
						writeDBMessage.append("导入成功!");
						return writeDBMessage.toString();				
					}
				}
				return writeDBMessage.toString();
	}
	public String saveLineCompletedToDB(UserToken user, String tableName , List<Map> list) throws Exception{
		StringBuffer writeDBMessage = new StringBuffer();
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String deleteSql = "";
		if("gp_ops_wa2d_line_finish".equals(tableName) || "gp_ops_wa2d_line_finish" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}else if("gp_ops_wa3d_group_finish".equals(tableName) || "gp_ops_wa3d_group_finish" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}
		
		try{
			jdbcDao.executeUpdate(deleteSql);
		}catch(Exception e){
			writeDBMessage.append("清除已有数据失败!");
			return writeDBMessage.toString();
		}
		// 修改为批量导入
		if(list != null && list.size() > 0){
			List<Map> newList = new ArrayList<Map>();
			String pk_name = "wa3d_group_id"; 
			if("gp_ops_wa2d_line_finish".equals(tableName)){
				pk_name = "wa2d_line_id";
			}
			for(int i=0; i <list.size(); i++){
				Map map = list.get(i);
				map.put("project_info_no", user.getProjectInfoNo());
				map.put("bsflag", "0");
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("order_num", i+1);
				map.put(pk_name, jdbcDao.generateUUID());
				if(map != null){
					newList.add(map);
				}
			}
			DBDataService dbSrv = new DBDataService();
			List strSqlList = dbSrv.mapsToBatchInsertSql(newList, tableName);
			
			int insertResult = dbSrv.executeBatchSql(strSqlList);
			if(insertResult < 0){
				writeDBMessage.append("导入失败!");
				return writeDBMessage.toString();
			}else{
				writeDBMessage.append("导入成功!");
				return writeDBMessage.toString();				
			}
		}
		return writeDBMessage.toString();
	}
	public ISrvMsg importExcelDataWeekReport(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo=reqDTO.getValue("projectInfoNo");
		StringBuffer message = new StringBuffer("");
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		try {
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			
			Workbook book = null;
			Sheet sheet = null;
			Row row = null;
			String name = fs.getFilename();
			if (fs.getFilename().indexOf(".xlsx") == -1 && fs.getFilename().indexOf(".xls") == -1) {
				book = new HSSFWorkbook(new POIFSFileSystem(
						new ByteArrayInputStream(fs.getFileData())));
				sheet = book.getSheetAt(0);
			} else {
				if(fs.getFilename().indexOf(".xlsx") != -1){
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
				}else if(fs.getFilename().indexOf(".xls") != -1){
					book = new HSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
				}
				sheet = book.getSheetAt(0);
			}
			if (sheet != null) {
				row = sheet.getRow(2);
				
				// 验证文件表头
				boolean bCheck = checkLineReportFileHeader(row);
				//boolean bCheck = true;
				boolean bSaveFlag = true;
				if(bCheck){
					int rows = sheet.getPhysicalNumberOfRows();
					int headerCells = row.getPhysicalNumberOfCells();
					if(rows >= 4){
						// 读取数据(行号大于4时存在数据)
						int endRow = rows ;
						
						Row endDataRow = sheet.getRow(endRow-1);
						int endDataCells = endDataRow.getPhysicalNumberOfCells();
						if(endDataCells > 0){
							Cell endRowCell = endDataRow.getCell(0);
							if(endRowCell != null){
								endRowCell.setCellType(1);
								String endCellValue = endRowCell.getStringCellValue().trim();
								if(endCellValue == null || "".equals(endCellValue)){
									Cell cell2 = endDataRow.getCell(1);
									cell2.setCellType(1);
									String cell2_value = cell2.getStringCellValue().trim();
									//如果cell2_value == 总计,去掉最后一行
									if("合计".equals(cell2_value)){
										rows = endRow-1;
									}
								}
							}else{
								rows = endRow-1;
							}
						}
						List<Map> dataList = new ArrayList<Map>();
						Map tbColumnMap = getWeekReportColumn();
						Map fileColumnMap = getWeekReportHeader();
						int startNumber = 0;
						startNumber = 3;
						Row dataRow_1 =null;
						boolean xBool = true;
						Cell cell_1=null;
						boolean flag=true;
						DecimalFormat df1 = new DecimalFormat("####");
						 SimpleDateFormat  sdf=new SimpleDateFormat("yyyy-mm-dd");
						 
						 OK:
						for(int i=startNumber; i< rows; i++){
							Row dataRow = sheet.getRow(i);//得到行
						

							if(dataRow == null){
								continue;
							}
							Map recordMap = new HashMap();
						 
							int dataCells = dataRow.getPhysicalNumberOfCells();
							if (dataCells > headerCells){
								dataCells = headerCells;
							}
						
							for(int j=0; j <= dataCells; j++){//遍历行
//								if(j==0) continue;
								int xPro=j+1;
								String columnAll=(String)tbColumnMap.get(""+xPro);
								Cell cell =dataRow.getCell(j);
								
						
								if (columnAll.equals("org_name")
										|| columnAll.equals("basin")
										|| columnAll.equals("well_number")
										|| columnAll.equals("coding_name")
										|| columnAll
												.equals("contracts_signed")
										|| columnAll
												.equals("contract_amount")
										|| columnAll
												.equals("complete_value")
										|| columnAll.equals("start_date")
										|| columnAll.equals("end_date")
										|| columnAll
												.equals("project_status")
										|| columnAll
												.equals("handle_explain_status")
										|| columnAll.equals("pass_date")
										|| columnAll.equals("remarks")) {
									

								if(dataRow_1!=null){
									cell_1 = dataRow_1.getCell(j);
								}
								if(cell_1!=null&&cell!=null){
								 String cell_2=cell.toString();
								 if(isNumeric(cell_2)){
									cell_2= new DecimalFormat("#0").format(Double.parseDouble(cell_2));
								 } 
									if(cell_1.toString().trim().equals(cell_2)){
										recordMap.put(columnAll, cell);
										continue;
										
									}else{
										int line = i + 1;
								 
										message.append("第[").append(line).append("]行'").append( (String)fileColumnMap.get(""+xPro)).append("'列与此列值须一致!");
										xBool=false;
										break OK;
									}
								}
								
								}
									
								
							
								if (cell != null && !"".equals(cell.toString())) {
									cell.setCellType(1);
									String cellValue = cell.getStringCellValue();
									int key = j+1;
									String tableColumn = (String)tbColumnMap.get(""+key);
								
									// 验证数据与类型是否匹配
							 
									boolean bDataType = true;
									if(tableColumn=="contracts_signed"||tableColumn=="contract_amount"||tableColumn=="complete_value"||tableColumn=="collection_series"||
											tableColumn=="shot_number"||tableColumn=="obs_point"||tableColumn=="quality_points"||tableColumn=="quality_rate"||
											tableColumn=="pass_point"||tableColumn=="pass_rate"||tableColumn=="waste_point"||tableColumn=="waste_rate"||tableColumn=="ref_points"){
										bDataType = isNumeric(cellValue);
									}
									if(columnAll.equals("start_date")||columnAll.equals("end_date")||columnAll.equals("pass_date")){
										try {
											sdf.parse(cell.toString());
										} catch (Exception e) {
											// TODO Auto-generated catch block
											flag=false;
											message.append("第[").append(i+1).append("]行'").append( (String)fileColumnMap.get(""+xPro)).append("时间格式不正确");
											break OK;
										}
									}
							 
									if(bDataType){
										recordMap.put(tableColumn, cellValue);
									}else{
										int line = i + 1;
										String columnTitle = (String)fileColumnMap.get(""+key);
										
										message.append("第[").append(line).append("]行'").append(columnTitle).append("'列应为数值!");
										bSaveFlag = false;
										break;
									}
								}else{
									continue;
								}
							}
							dataList.add(recordMap);

							if(i==3){
								dataRow_1=dataRow;
							}
						 
					 
						}
						if(bSaveFlag == true&&xBool==true&&flag==true){
							// 保存数据todoff
							String tableName = "";
							 
								tableName = "bgp_ws_daily_report";
							 
							String rts = saveWeekReportToDB(user, tableName, dataList);
							message.append(rts);
						}
					}
				}else{
					message.append("导入文件表头格式不符!");
				}
			}
		}
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("Exception:"+e.getMessage());
		}
 
	responseDTO.setValue("message", message.toString());
	return responseDTO;

	}
	/**
	 * 导入线束完成情况
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg importExcelDataLineCompleted(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		String workMethod = reqDTO.getValue("workMethod");	//2 | 3
		String teamName = reqDTO.getValue("teamName");
		StringBuffer message = new StringBuffer("");
		
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				String name = fs.getFilename();
				if (fs.getFilename().indexOf(".xlsx") == -1 && fs.getFilename().indexOf(".xls") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					if(fs.getFilename().indexOf(".xlsx") != -1){
						book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}else if(fs.getFilename().indexOf(".xls") != -1){
						book = new HSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {

					if("3".equals(workMethod) || workMethod == "3"){
						row = sheet.getRow(2);
					}else if("2".equals(workMethod) || workMethod == "2"){
						row = sheet.getRow(4);
					}
					
					// 验证文件表头
					boolean bCheck = checkLineCompletedFileHeader("n",workMethod, row);
					//boolean bCheck = true;
					boolean bSaveFlag = true;
					
					// 
					if(bCheck){
						int rows = sheet.getPhysicalNumberOfRows();
						int headerCells = row.getPhysicalNumberOfCells();
						if(rows >= 4){
							// 读取数据(行号大于4时存在数据)
							int endRow = rows ;
							
							Row endDataRow = sheet.getRow(endRow-1);
							int endDataCells = endDataRow.getPhysicalNumberOfCells();
							if(endDataCells > 0){
								Cell endRowCell = endDataRow.getCell(0);
								if(endRowCell != null){
									endRowCell.setCellType(1);
									String endCellValue = endRowCell.getStringCellValue().trim();
									if(endCellValue == null || "".equals(endCellValue)){
										Cell cell2 = endDataRow.getCell(1);
										cell2.setCellType(1);
										String cell2_value = cell2.getStringCellValue().trim();
										//如果cell2_value == 总计,去掉最后一行
										if("合计".equals(cell2_value)){
											rows = endRow-1;
										}
									}
								}else{
									rows = endRow-1;
								}
							}						
							
							List<Map> dataList = new ArrayList<Map>();
							Map tbColumnMap = getLineCompletedColumn("n",workMethod);
							Map fileColumnMap = getLineCompletedHeader("n",workMethod);
							int startNumber = 0;
							//三维从第四行开始,二维从第五行开始
							if("3".equals(workMethod) || workMethod == "3"){
								startNumber = 4;
							}else if("2".equals(workMethod) || workMethod == "2"){
								startNumber = 5;
							}
							for(int i=startNumber; i< rows; i++){
								Row dataRow = sheet.getRow(i);
								
								if(dataRow == null){
									continue;
								}
								Map recordMap = new HashMap();
								recordMap.put("team_name", teamName);
								int dataCells = dataRow.getPhysicalNumberOfCells();
								if (dataCells > headerCells){
									dataCells = headerCells;
								}
								for(int j=2; j <= dataCells; j++){
								//	if(j==0) continue;
									
									Cell cell = dataRow.getCell(j);
									if (cell != null && !"".equals(cell.toString())) {
										cell.setCellType(1);
										String cellValue = cell.getStringCellValue().trim();
										int key = j-1;
										String tableColumn = (String)tbColumnMap.get(""+key);
									
										// 验证数据与类型是否匹配
										boolean bDataType = true;
										if(tableColumn!="line_group_id" && tableColumn!="notes" && tableColumn!="construct_begin_end_date" && tableColumn!="line_id"){
											bDataType = isNumeric(cellValue);
										}
										if(bDataType){
											recordMap.put(tableColumn, cellValue);
										}else{
											int line = i + 1;
											String columnTitle = (String)fileColumnMap.get(""+key);
											
											message.append("第[").append(line).append("]行'").append(columnTitle).append("'列应为数值!");
											bSaveFlag = false;
											break;
										}
									}else{
										continue;
									}
								}
								dataList.add(recordMap);
							}
							if(bSaveFlag == true){
								// 保存数据todo
								String tableName = "";
								if("2".equals(workMethod)){
									tableName = "gp_ops_wa2d_line_finish";
								}else{
									tableName = "gp_ops_wa3d_group_finish";
								}
								String rts = saveLineCompletedToDB(user, tableName, dataList);
								message.append(rts);
							}
						}
					}else{
						message.append("导入文件表头格式不符!");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				//System.out.println("Exception:"+e.getMessage());
			}
		}
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
	
	/**
	 * 导入线束施工方法
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg importExcelDataLineConstruction(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String workMethod = reqDTO.getValue("workMethod");	//2 | 3
		String teamName = reqDTO.getValue("teamName");
		String isSea = reqDTO.getValue("isSea");// y|n 是否为深海项目标志
		if(isSea==null||"".equals(isSea)){
			isSea="n";
		}
		StringBuffer message = new StringBuffer("");
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				String name = fs.getFilename();
				if (fs.getFilename().indexOf(".xlsx") == -1 && fs.getFilename().indexOf(".xls") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					if(fs.getFilename().indexOf(".xlsx") != -1){
						book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}else if(fs.getFilename().indexOf(".xls") != -1){
						book = new HSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					
					int compareNum = 0;
					//读取表头文件
					if("3".equals(workMethod) || workMethod == "3"){
						if(isSea.equals("y")){
							row = sheet.getRow(2);
							compareNum = 3;
						}else{
							row = sheet.getRow(3);
							compareNum = 5;
						}
						
					}else if("2".equals(workMethod) || workMethod == "2"){
						if(isSea.equals("y")){
							row = sheet.getRow(2);
							compareNum = 3;
						}else{
							row = sheet.getRow(3);
							compareNum = 4;
						}
						
					}
					
					// 验证文件表头
					boolean bCheck = checkLineConstructionFileHeader(isSea,workMethod, row);
					//boolean bCheck = true;
					boolean bSaveFlag = true;
					
					if(bCheck){
						int rows = sheet.getPhysicalNumberOfRows();
						int headerCells = row.getPhysicalNumberOfCells();
						if(rows >= compareNum){
							int endRow = rows ;
							rows = endRow - 1;				
							List<Map> dataList = new ArrayList<Map>();
							Map tbColumnMap = getLineConstructionColumn(isSea,workMethod);
							Map fileColumnMap = getLineConstructionHeader(isSea,workMethod);
							int startNumber = 1;
							for(int i=compareNum; i<= rows; i++){
								Row dataRow = sheet.getRow(i);
								if(dataRow == null){
									continue;
								}
								Map recordMap = new HashMap();
								recordMap.put("team_name", teamName);
								int dataCells = dataRow.getPhysicalNumberOfCells();
								if (dataCells > headerCells){
									dataCells = headerCells;
								}
								for(int j=1; j < dataCells; j++){
									
									Cell cell = dataRow.getCell(j-1);
									if (cell != null && !"".equals(cell.toString())) {
										cell.setCellType(1);
										String cellValue = cell.getStringCellValue().trim();
										int key = j;
										String tableColumn = (String)tbColumnMap.get(""+key);
									
										// 验证数据与类型是否匹配
										boolean bDataType = true;
										if(isSea.equals("y")){
											if(tableColumn!="order_num" && tableColumn!="notes"&&tableColumn!="team_name"){
												bDataType = isNumeric(cellValue);
											}
										}else{
											if(tableColumn!="line_group_id" && tableColumn!="notes" && tableColumn!="vertical_array_mode" && tableColumn!="line_id" && tableColumn!="geophone_comp_graph" && tableColumn!="source_comp_graph" && tableColumn!="instrument_model" && tableColumn!="rolling_mode" && tableColumn!="scan_frequency" && tableColumn!="layout"){
												bDataType = isNumeric(cellValue);
											}
										}
										if(bDataType){
											recordMap.put(tableColumn, cellValue);
										}else{
											String columnTitle = (String)fileColumnMap.get(key+1+"");
											message.append("第[").append(i).append("]行'").append(columnTitle).append("'列应为数值!");
											bSaveFlag = false;
											break;
										}
									}else{
										continue;
									}
								}
								dataList.add(recordMap);
							}
							if(bSaveFlag == true){
								// 保存数据todo
								String tableName = "";
								if("2".equals(workMethod)){
									tableName = "gp_ops_2dwa_method_data";
								}else{
									tableName = "gp_ops_3dwa_method_data";
								}
								String rts = saveLineConstructionToDB(user, tableName, dataList);
								message.append(rts);
							}
						}
					}else{
						message.append("导入文件表头格式不符!");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
	
	public String saveLineConstructionToDB(UserToken user, String tableName , List<Map> list) throws Exception{
		StringBuffer writeDBMessage = new StringBuffer();
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String deleteSql = "";
		if("gp_ops_2dwa_method_data".equals(tableName) || "gp_ops_2dwa_method_data" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}else if("gp_ops_3dwa_method_data".equals(tableName) || "gp_ops_3dwa_method_data" == tableName){
			deleteSql = " update  " + tableName +" set bsflag = '1',modifi_date = sysdate,updator = '"+user.getEmpId()+"' where project_info_no = '" +user.getProjectInfoNo() +"'";
		}
		
		try{
			jdbcDao.executeUpdate(deleteSql);
		}catch(Exception e){
			writeDBMessage.append("清除已有数据失败!");
			return writeDBMessage.toString();
		}
		// 修改为批量导入
		if(list != null && list.size() > 0){
			List<Map> newList = new ArrayList<Map>();
			String pk_name = "method_no"; 
			for(int i=0; i <list.size(); i++){
				Map map = list.get(i);
				map.put("project_info_no", user.getProjectInfoNo());
				map.put("bsflag", "0");
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("order_num", i+1);
				map.put(pk_name, jdbcDao.generateUUID());
				if(map != null){
					newList.add(map);
				}
			}
			DBDataService dbSrv = new DBDataService();
			List strSqlList = dbSrv.mapsToBatchInsertSql(newList, tableName);
			
			int insertResult = dbSrv.executeBatchSql(strSqlList);
			if(insertResult < 0){
				writeDBMessage.append("导入失败!");
				return writeDBMessage.toString();
			}else{
				writeDBMessage.append("导入成功!");
				return writeDBMessage.toString();				
			}
		}
		return writeDBMessage.toString();
	}
	
	
	
	/**
	 * 导入深海线束完成情况
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg importExcelShDataLineCompleted(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		String workMethod = reqDTO.getValue("workMethod");	//2 | 3
		String teamName = reqDTO.getValue("teamName");
		StringBuffer message = new StringBuffer("");
		
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				String name = fs.getFilename();
				if (fs.getFilename().indexOf(".xlsx") == -1 && fs.getFilename().indexOf(".xls") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					if(fs.getFilename().indexOf(".xlsx") != -1){
						book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}else if(fs.getFilename().indexOf(".xls") != -1){
						book = new HSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					}
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					row = sheet.getRow(1);
					// 验证文件表头
					boolean bCheck = checkLineCompletedFileHeader("y",workMethod, row);
					//boolean bCheck = true;
					boolean bSaveFlag = true;
					// 
					if(bCheck){
						int rows = sheet.getPhysicalNumberOfRows();
						int headerCells = row.getPhysicalNumberOfCells();
						if(rows >= 3){
							// 读取数据(行号大于3时存在数据)
							int endRow = rows ;
							Row endDataRow = sheet.getRow(endRow-1);
							int endDataCells = endDataRow.getPhysicalNumberOfCells();
							if(endDataCells > 0){
								Cell endRowCell = endDataRow.getCell(0);
								if(endRowCell != null){
									endRowCell.setCellType(1);
									String endCellValue = endRowCell.getStringCellValue().trim();
									if(endCellValue == null || "".equals(endCellValue)){
										Cell cell2 = endDataRow.getCell(1);
										cell2.setCellType(1);
										String cell2_value = cell2.getStringCellValue().trim();
										//如果cell2_value == 总计,去掉最后一行
										if("合计".equals(cell2_value)){
											rows = endRow-1;
										}
									}
								}else{
									rows = endRow-1;
								}
							}						
							
							List<Map> dataList = new ArrayList<Map>();
							Map tbColumnMap = getLineCompletedColumn("y",workMethod);
							Map fileColumnMap = getLineCompletedHeader("y",workMethod);
							for(int i=2; i<= rows; i++){
								Row dataRow = sheet.getRow(i);
								if(dataRow == null){
									continue;
								}
								Map recordMap = new HashMap();
								recordMap.put("team_name", teamName);
								int dataCells = dataRow.getPhysicalNumberOfCells();
								for(int j=0; j < dataCells; j++){
									Cell cell = dataRow.getCell(j);
									if (cell != null && !"".equals(cell.toString())) {
										cell.setCellType(1);
										String cellValue = cell.getStringCellValue().trim();
										String tableColumn = (String)tbColumnMap.get(j+1+"");
									
										// 验证数据与类型是否匹配
										boolean bDataType = true;
										if(tableColumn!="line_group_id" && tableColumn!="notes" && tableColumn!="construct_begin_end_date" && tableColumn!="team_name"){
											bDataType = isNumeric(cellValue);
										}
										if(bDataType){
											recordMap.put(tableColumn, cellValue);
										}else{
											int line = i + 1;
											String columnTitle = (String)fileColumnMap.get(j+1+"");
											message.append("第[").append(line).append("]行'").append(columnTitle).append("'列应为数值!");
											bSaveFlag = false;
											break;
										}
									}else{
										continue;
									}
								}
								dataList.add(recordMap);
							}
							if(bSaveFlag == true){
								// 保存数据todo
								String tableName = "";
								if("2".equals(workMethod)){
									tableName = "gp_ops_wa2d_line_finish";
								}else{
									tableName = "gp_ops_wa3d_group_finish";
								}
								String rts = saveLineCompletedToDB(user, tableName, dataList);
								message.append(rts);
							}
						}
					}else{
						message.append("导入文件表头格式不符!");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				//System.out.println("Exception:"+e.getMessage());
			}
		}
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
}

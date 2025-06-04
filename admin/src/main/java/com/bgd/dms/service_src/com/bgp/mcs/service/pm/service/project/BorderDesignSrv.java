package com.bgp.mcs.service.pm.service.project;

import java.io.ByteArrayInputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class BorderDesignSrv  extends BaseService {

	public ISrvMsg saveDwsDesign(ISrvMsg reqDTO) throws Exception{
		Map map = reqDTO.toMap();		
		UserToken user = reqDTO.getUserToken();
		String wa3dDesignNo = reqDTO.getValue("wa3d_design_no");
		if(wa3dDesignNo == null || "".equals(wa3dDesignNo)){
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}else{
			map.put("updator", user.getEmpId());
			map.put("modifi_date", new Date());
		}
		map.put("bsflag", "0");
		
		Serializable wa3d_design_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_3dws_design");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 获取设计边框信息
	 * @throws Exception
	 */
	public ISrvMsg getDwsDesignById(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		String wa3d_design_no = reqDTO.getValue("wa3dDesignNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select wa3d_design_no,frame_shape,case frame_shape when '1' then '边框设计数据' when '2' then '边框成果数据' else '' end as frame_shape_text, data_type, case data_type when '1' then '炮点' when '2' then '检波点' when '3' then '满覆盖' when '4' then '一次覆盖' when '5' then '施工面积' else '' end as data_type_text,border_break_point,altitude,point_x,point_y from gp_ops_3dws_design ");
		sb.append(" where wa3d_design_no='").append(wa3d_design_no).append("'");
		
		Map dwsDesgin = new HashMap();
		dwsDesgin = jdbcDAO.queryRecordBySQL(sb.toString());
		
		if (dwsDesgin != null) {
			responseMsg.setValue("dBorder", dwsDesgin);
		}
		return responseMsg;
	}
	
	/**
	 * 删除指定编号的设计边框信息
	 * @throws Exception
	 */
	public ISrvMsg deleteDwsDesign(ISrvMsg reqDTO) throws Exception {
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		String wa3d_design_no = reqDTO.getValue("wa3dDesignNo");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("update gp_ops_3dws_design set bsflag = '1' ");
		sb.append(" where wa3d_design_no='"+wa3d_design_no+"'");
		
		jdbcTemplate.execute(sb.toString());
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
	
	public ISrvMsg importExcelData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String isSea = reqDTO.getValue("isSea");// y|n 是否为深海项目
		if(isSea==null){
			isSea="n";
		}
		UserToken user = reqDTO.getUserToken();
		// 获取文件
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		
		StringBuffer message = new StringBuffer("");
		String c_type = reqDTO.getValue("c_type");

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
					row = sheet.getRow(2);
					// 验证文件表头
					boolean bCheck = checkFileHeader(isSea,row);
					boolean bSaveFlag = true;
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
							for(int i=3; i<= rows; i++){
								Row dataRow = sheet.getRow(i);
								Map recordMap = new HashMap();
								int dataCells = dataRow.getPhysicalNumberOfCells();
								if (dataCells > headerCells){
									dataCells = headerCells;
								}
								for(int j=0; j <= dataCells; j++){
									Cell cell = dataRow.getCell(j);
									int key = j+1;
									if (cell != null && !"".equals(cell.toString())) {
										cell.setCellType(1);
										String cellValue = cell.getStringCellValue().trim();
										
										recordMap.put(""+key, cellValue);
									}else{
										recordMap.put(""+key, "");
										continue;
									}
								}
								dataList.add(recordMap);
							}
							//重新构造保存数据
							List<Map> saveObjectList = new ArrayList<Map>();
							boolean saveflag = true;
							for(int i=0; i<dataList.size(); i++){
								Map map = dataList.get(i);
								String point_1 = "" + map.get("1");
								String point_2 = "" + map.get("4");
								String point_3 = "" + map.get("7");
								String point_4 = "" + map.get("10");
								String point_5 = "" + map.get("13");
								String xAxis_1 = "" + map.get("2");
								String xAxis_2 = "" + map.get("5");
								String xAxis_3 = "" + map.get("8");
								String xAxis_4 = "" + map.get("11");
								String yAxis_1 = "" + map.get("3");
								String yAxis_2 = "" + map.get("6");
								String yAxis_3 = "" + map.get("9");
								String yAxis_4 = "" + map.get("12");
								if("y".equalsIgnoreCase(isSea)){//深海项目单独处理
									point_3 = "" + map.get("1");
									xAxis_3 = "" + map.get("2");
									yAxis_3 = "" + map.get("3");
									if("".equals(point_3) && "".equals(xAxis_3) && "".equals(yAxis_3)){
										
									}else{
										if(!"".equals(point_3)){
											Map object3 = new HashMap();
											object3.put("border_break_point", point_3);
											object3.put("point_x", xAxis_3);
											object3.put("point_y", yAxis_3);
											object3.put("data_type", "3");
											object3.put("frame_shape", "1");
											saveObjectList.add(object3);
										}else{
											//文件数据不完整
											saveflag = false;
											message.append("文件中拐点数据输入不完整,导入操作取消!");
										}
									}
								}else{
									if("".equals(point_1) && "".equals(xAxis_1) && "".equals(yAxis_1)){
										//
									}else{
										if(!"".equals(point_1)){
											Map object1 = new HashMap();
											object1.put("border_break_point", point_1);
											object1.put("point_x", xAxis_1);
											object1.put("point_y", yAxis_1);
											object1.put("data_type", "2");
											object1.put("frame_shape", "1");
											
											saveObjectList.add(object1);
										}else{
											//文件数据不完整
											saveflag = false;
											message.append("文件中拐点数据输入不完整,导入操作取消!");
										}
									}
									if("".equals(point_2) && "".equals(xAxis_2) && "".equals(yAxis_2)){
										//
									}else{
										if(!"".equals(point_2)){
											Map object2 = new HashMap();
											object2.put("border_break_point", point_2);
											object2.put("point_x", xAxis_2);
											object2.put("point_y", yAxis_2);
											object2.put("data_type", "1");
											object2.put("frame_shape", "1");
											
											saveObjectList.add(object2);
										}else{
											//文件数据不完整
											saveflag = false;
											message.append("文件中拐点数据输入不完整,导入操作取消!");
										}
									}
									if("".equals(point_3) && "".equals(xAxis_3) && "".equals(yAxis_3)){
										//
									}else{
										if(!"".equals(point_3)){
											Map object3 = new HashMap();
											object3.put("border_break_point", point_3);
											object3.put("point_x", xAxis_3);
											object3.put("point_y", yAxis_3);
											object3.put("data_type", "3");
											object3.put("frame_shape", "1");
											
											saveObjectList.add(object3);
										}else{
											//文件数据不完整
											saveflag = false;
											message.append("文件中拐点数据输入不完整,导入操作取消!");
										}
									}
									if("".equals(point_4) && "".equals(xAxis_4) && "".equals(yAxis_4)){
										//
									}else{
										if(!"".equals(point_4)){
											Map object4 = new HashMap();
											object4.put("border_break_point", point_4);
											object4.put("point_x", xAxis_4);
											object4.put("point_y", yAxis_4);
											object4.put("data_type", "4");
											object4.put("frame_shape", "1");
											
											saveObjectList.add(object4);
										}else{
											//文件数据不完整
											saveflag = false;
											message.append("文件中拐点数据输入不完整,导入操作取消!");
										}
									}
									
									
									
									if (i==0){
											if(!"".equals(point_5)){
												Map object5 = new HashMap();
												object5.put("border_break_point", "A4");
												object5.put("point_x", point_5); 
												object5.put("data_type", "5");
												object5.put("frame_shape", "1");
												
												saveObjectList.add(object5);
											}else{
												//文件数据不完整
												saveflag = false;
												message.append("文件中观测方位角未输入,导入操作取消!");
											}
										}
									}
							}
							//保存数据
							if(saveflag){
								String rts = saveBorderDesignToDB(user, saveObjectList,c_type);
								message.append(rts);
							}
						}
					}
				}else{
					message.append("文件表头格式不符,导入操作取消!");
				}
			}
			catch (Exception e) {
				System.out.println("Exception:"+e.getMessage());
			}
		}
		responseDTO.setValue("c_type_s",c_type);
		responseDTO.setValue("message", message.toString());
		return responseDTO;
	}
	
	private Map getTemplateHeader(String isSea){
		Map columnMap = new HashMap();
		if(isSea.equalsIgnoreCase("y")){
			columnMap.put("1", "边界拐点");
			columnMap.put("2", "X坐标");
			columnMap.put("3", "Y坐标");
		}else{
			columnMap.put("1", "边界拐点");
			columnMap.put("2", "X坐标");
			columnMap.put("3", "Y坐标");
			columnMap.put("4", "边界拐点");
			columnMap.put("5", "X坐标");
			columnMap.put("6", "Y坐标");
			columnMap.put("7", "边界拐点");
			columnMap.put("8", "X坐标");
			columnMap.put("9", "Y坐标");
			columnMap.put("10", "边界拐点");
			columnMap.put("11", "X坐标");
			columnMap.put("12", "Y坐标");
			columnMap.put("13", "观测方位角");

		}
		
		return columnMap;
	}
	
	private boolean checkFileHeader(String isSea,Row row){
		boolean result = true;
		Map columns = getTemplateHeader(isSea);
		int templateCols = columns.size();
		int physicalCols = row.getPhysicalNumberOfCells();
		if(physicalCols != templateCols){
			result = false;
		}else{
			for(int m=0; m<physicalCols; m++){
				Cell cell = row.getCell(m);
				cell.setCellType(1);
				String cellValue = cell.getStringCellValue().trim().toUpperCase();
				int key = m+1;
				String columnName = (String)columns.get(key+"");
				if(!columnName.equals(cellValue)){
					result = false;
					break;
				}
			}
		}
		return result;
	}
	
	public String saveBorderDesignToDB(UserToken user, List<Map> list,String c_type) throws Exception{
		StringBuffer writeDBMessage = new StringBuffer();
		RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String table_Name="";
		if(c_type.equals("1")){
			table_Name="gp_ops_3dws_design";
		}else 	if(c_type.equals("2")){
			table_Name="gp_ops_3dws_complete";
		}
		
		String deleteSql = " update  "+table_Name+"   set bsflag = '1',modifi_date = sysdate,updator = '"+user.getEmpId()+"'  where project_info_no = '" +user.getProjectInfoNo() +"'";
		try{
			jdbcDao.executeUpdate(deleteSql);
		}catch(Exception e){
			writeDBMessage.append("清除已有数据失败!");
			return writeDBMessage.toString();
		}
		
		if(list != null && list.size() > 0){
			for(int i=0; i <list.size(); i++){
				Map map = list.get(i);
				map.put("project_info_no", user.getProjectInfoNo());
				map.put("bsflag", "0");
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				
				map.put("UPDATOR", user.getEmpId());
				map.put("MODIFI_DATE", new Date()); 
				map.put("ORG_ID", user.getOrgId());
				map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
				
				try{
					Serializable entityId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_Name);
				}catch(Exception e){
					int line = i + 1;
					writeDBMessage.append("第[").append(line).append("]行数据写入数据库失败!");
					return writeDBMessage.toString();
				}
			}
		}
		return writeDBMessage.toString();
	}
}

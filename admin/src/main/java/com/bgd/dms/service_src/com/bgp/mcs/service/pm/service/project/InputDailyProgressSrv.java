package com.bgp.mcs.service.pm.service.project;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class InputDailyProgressSrv extends BaseService {

	static SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");   
	static String curDate=sdf.format(new Date()); 
	public InputDailyProgressSrv(){
		log = LogFactory.getLogger(MeasureSrv.class);
	}
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	/**
	 * 查询表层进度信息 PROGRESS_TYPE = 2
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg querySurfaceProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method querySurfaceProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String cons_date = reqDTO.getValue("consDate");
		
		StringBuffer querySql = new StringBuffer("select t.daily_progress_no,t.progress_data");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '2' and t.project_info_no = '"+projectInfoNo+"'");
		if(cons_date != null && cons_date != ""){
			querySql.append(" and t.cons_date like to_date('"+cons_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		//时间为空,按当天来查询
		else{
			querySql.append(" and t.cons_date like sysdate");
		}
		
		Map surfaceProgressMap = jdbcDao.queryRecordBySQL(querySql.toString());
		String surfaceProgressId = "";
		byte[] bt = null;
		
		if(surfaceProgressMap != null){
			surfaceProgressId = surfaceProgressMap.get("daily_progress_no").toString();
			if(surfaceProgressMap.get("progress_data")!=""&&surfaceProgressMap.get("progress_data")!=null){
				bt = (byte[]) surfaceProgressMap.get("progress_data");
			}
		}
		
		StringBuffer checkSql = new StringBuffer("select t.daily_progress_no");
		checkSql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '2' and t.project_info_no = '"+projectInfoNo+"'");
		checkSql.append(" and t.cons_date like sysdate");
		
		if(jdbcDao.queryRecordBySQL(checkSql.toString()) != null){
			//当天有数据
			responseDTO.setValue("todayFlag", "1");
		}else{
			//当天没数据
			responseDTO.setValue("todayFlag", "0");
		}
		
		if(bt != null){
			List surfaceProgressList = this.parseProgressText(bt);
			responseDTO.setValue("datas", surfaceProgressList);
		}

		responseDTO.setValue("surfaceProgressId", surfaceProgressId);
		responseDTO.setValue("queryDate", cons_date);
		
		log.debug(".....exit querySurfaceProgress...");
		return responseDTO;
	}
	
	/**
	 * 录入表层进度信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg insertSurfaceProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter method insertSurfaceProgress....");
		
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();


		// 接收前台传来的界面元素的值
		String consDate = reqDTO.getValue("consDate");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			
			// 将二进制输入流转化为数据输入流，供解析使用
			DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
			int n = 1;
			String line = null;
			while ((line = dis.readLine()) != null) {
				line = new String(line.getBytes("ISO-8859-1"));
				String datas[] = line.split(",");
				if (datas.length != 6) {
					message = "第" + n + "行不是6列,不能加入";
					flag = true;
					break;
				}
				if (datas[0].equals("")) {
					message = "第" + n + "行第1列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[1].equals("")) {
					message = "第" + n + "行第2列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[1].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第2列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[2].equals("")) {
					message = "第" + n + "行第3列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[3].equals("")) {
					message = "第" + n + "行第4列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[3].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第4列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[4].equals("")) {
					message = "第" + n + "行第5列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[4].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第5列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[5].equals("")) {
					message = "第" + n + "行第6列不能为空,不能加入";
					flag = true;
					break;
				}
				
				if (!datas[5].matches(("^-?[\\d|.]+$"))) {
					message = "第" + n + "行第6列不是数字,不能加入";
					flag = true;
					break;
				}
				
				String data3 = "";			
				if (datas[3].indexOf(".")!=-1){
					data3 = datas[3].substring(0, datas[3].indexOf("."));
				}else{
					data3 = datas[3];
				}
				
				String data4 = "";
				if (datas[4].indexOf(".")!=-1){
					data4 = datas[4].substring(0, datas[4].indexOf("."));
				}else{
					data4 = datas[4];
				}
				
				
				if(!((data3.length() == 6)||(data3.length() == 8))){
					message = "第" + n + "行第4列X坐标值整数位应该为6位或8位！";
					flag = true;
					break;
				}
				
				if(!((data4.length() == 7)||(data4.length() == 9))){
					message = "第" + n + "行第5列Y坐标值整数位应该为7位或9位！";
					flag = true;
					break;
				}
				n++;
			}
		}

		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		Map surfaceMap = new HashMap();
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		// 2代表表层进度
		surfaceMap.put("PROGRESS_TYPE", "2");
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			surfaceMap.put("PROGRESS_DATA", by);
		}
		surfaceMap.put("CONS_DATE", consDate);
		surfaceMap.put("CREATOR", user.getUserId());
		surfaceMap.put("CREATE_DATE", new Date());
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("BSFLAG", "0");
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		// 正常返回
		log.debug(".....exit insertSurfaceProgress method...");
		return responseDTO;

	}
	
	/**
	 * 更新表层进度信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateSurfaceProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter updateSurfaceProgress method");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String surfaceProgressId = reqDTO.getValue("dailyProgressNo");
		
		// 接收前台传来的界面元素的值
		String surfaceFile = reqDTO.getValue("surfaceFile");
		String consDate = reqDTO.getValue("consDate");

		// 赋值二进制文件流
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			
			// 将二进制输入流转化为数据输入流，供解析使用
			DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
			int n = 1;
			String line = null;
			while ((line = dis.readLine()) != null) {
				line = new String(line.getBytes("ISO-8859-1"));
				String datas[] = line.split(",");
				if (datas.length != 6) {
					message = "第" + n + "行不是6列,不能加入";
					flag = true;
					break;
				}
				if (datas[0].equals("")) {
					message = "第" + n + "行第1列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[1].equals("")) {
					message = "第" + n + "行第2列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[1].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第2列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[2].equals("")) {
					message = "第" + n + "行第3列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[3].equals("")) {
					message = "第" + n + "行第4列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[3].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第4列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[4].equals("")) {
					message = "第" + n + "行第5列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[4].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第5列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[5].equals("")) {
					message = "第" + n + "行第6列不能为空,不能加入";
					flag = true;
					break;
				}
				
				if (!datas[5].matches(("^-?[\\d|.]+$"))) {
					message = "第" + n + "行第6列不是数字,不能加入";
					flag = true;
					break;
				}
				
				String data3 = "";			
				if (datas[3].indexOf(".")!=-1){
					data3 = datas[3].substring(0, datas[3].indexOf("."));
				}else{
					data3 = datas[3];
				}
				
				String data4 = "";
				if (datas[4].indexOf(".")!=-1){
					data4 = datas[4].substring(0, datas[4].indexOf("."));
				}else{
					data4 = datas[4];
				}
				
				
				if(!((data3.length() == 6)||(data3.length() == 8))){
					message = "第" + n + "行第4列X坐标值整数位应该为6位或8位！";
					flag = true;
					break;
				}
				
				if(!((data4.length() == 7)||(data4.length() == 9))){
					message = "第" + n + "行第5列Y坐标值整数位应该为7位或9位！";
					flag = true;
					break;
				}
				n++;
			}
		}

		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		
		Map surfaceMap = new HashMap();
		surfaceMap.put("DAILY_PROGRESS_NO", surfaceProgressId);
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			surfaceMap.put("PROGRESS_DATA", by);
		}
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		log.debug(".....exit updateSurfaceProgress");
		return responseDTO;
	}
	
	/**
	 * 删除表层进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteSurfaceProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter deleteSurfaceProgress method");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String surfaceProgressId = reqDTO.getValue("surfaceProgressId");
		String update_sql = "update gp_ops_daily_progress p set p.bsflag = '1' where p.daily_progress_no = '"+surfaceProgressId+"'";
		jdbcDao.executeUpdate(update_sql);
		log.debug(".....exit deleteSurfaceProgress");
		return responseDTO;
	}
	/**
	 * 验证是否已存在
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg validateSurfaceProgress(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		log.debug(".....enter method validateSurfaceProgress...");
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String consDate = reqDTO.getValue("consDate");
		
		StringBuffer querySql = new StringBuffer("select t.daily_progress_no");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '2' and t.project_info_no = '"+projectInfoNo+"'");
		if(consDate != null && consDate != ""){
			querySql.append(" and t.cons_date like to_date('"+consDate+"','yyyy-mm-dd hh24:mi:ss')");
		}else{
			querySql.append(" and t.cons_date like sysdate");
		}
		
		if(jdbcDao.queryRecordBySQL(querySql.toString()) != null){
			//有数据,可以更新
			responseDTO.setValue("updateFlag", "1");
			responseDTO.setValue("curDate",curDate);
			responseDTO.setValue("daily_progress_no", jdbcDao.queryRecordBySQL(querySql.toString()).get("daily_progress_no"));
		}else{
			//没数据,不更新
			responseDTO.setValue("updateFlag", "0");
		}

		log.debug(".....exit validateSurfaceProgress...");
		
		return responseDTO;
	}
	
	/**
	 * 将表层进度的附件解析
	 * @param bt
	 * @return
	 * @throws Exception
	 */
	public List parseProgressText(byte[] bt) throws Exception {
		
		List<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
		
		//二进制输入流
		ByteArrayInputStream bis = null;
		
		//数据流
		DataInputStream dis = null;
		
		try {
			//将从DB中查到的二进制类型的字段传入，转化为二进制输入流
			bis = new ByteArrayInputStream(bt);
			
			//将二进制输入流转化为数据输入流，供解析使用
			dis = new DataInputStream(bis);
			
			String dataInfo = "";
			
			//逐行解析
			while((dataInfo = dis.readLine()) != null){
				dataInfo = new String(dataInfo.getBytes("ISO-8859-1"));
				
				if("".equals(dataInfo)){
					continue;
				}
				
				//将一行的数据用,分割，可以按位置取值
				String[] datas = dataInfo.split(",");

				HashMap<String,String> map = new HashMap<String,String>();

				map.put("lineNo",datas[0]);
					
				map.put("pointNo",datas[1]);
					
				map.put("surfaceMethod",datas[2]);
					
				map.put("pointX",datas[3]);
					
				map.put("pointY",datas[4]);
					
				if(datas.length == 6){
					map.put("altitude",datas[5]);
				}
				
				list.add(map);
				
			}//end while
			
			dis.close();
			
			dis = null;
			
			bis.close();
			
			bis = null;
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
		return list;
	}
	
	/**
	 * 查询测量进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySurveyProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method querySurveyProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String cons_date = reqDTO.getValue("consDate");
		String survey_pt_type = reqDTO.getValue("querySurveyPtType");
		
		StringBuffer querySql = new StringBuffer("select t.daily_progress_no,t.progress_data");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '1' and t.project_info_no = '"+projectInfoNo+"'");
		if(survey_pt_type != null && survey_pt_type != ""){
			querySql.append(" and t.survey_pt_type = '"+survey_pt_type+"'");
		}
		if(cons_date != null && cons_date != ""){
			querySql.append(" and t.cons_date like to_date('"+cons_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		//时间为空,按当天来查询
		else{
			querySql.append(" and t.cons_date like sysdate");
		}
		
		Map surfaceProgressMap = jdbcDao.queryRecordBySQL(querySql.toString());
		String surveyProgressId = "";
		byte[] bt = null;
		
		if(surfaceProgressMap != null){
			surveyProgressId = surfaceProgressMap.get("daily_progress_no").toString();
			if(surfaceProgressMap.get("progress_data")!=""&&surfaceProgressMap.get("progress_data")!=null){
				bt = (byte[]) surfaceProgressMap.get("progress_data");
			}
		}
		
		//检查当天的数据是否已经录入
		StringBuffer checkSql = new StringBuffer("select t.daily_progress_no");
		checkSql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '1' and t.project_info_no = '"+projectInfoNo+"'");
		checkSql.append(" and t.cons_date like sysdate");
		
		if(jdbcDao.queryRecordBySQL(checkSql.toString())  != null){
			//当天有数据
			responseDTO.setValue("todayFlag", "1");
		}else{
			//当天没数据
			responseDTO.setValue("todayFlag", "0");
		}
		
		if(bt != null){
			String em = user.getExplorationMethod();
			if("0300100012000000002".equals(em)){
				em = "2";
			}else{
				em = "3";
			}
			List surfaceProgressList = this.parseSurveyText(bt,em);
			responseDTO.setValue("datas", surfaceProgressList);
			responseDTO.setValue("expMethod", em);
		}

		responseDTO.setValue("surveyProgressId", surveyProgressId);
		responseDTO.setValue("queryDate",cons_date);
		
		log.debug(".....exit querySurveyProgress...");
		return responseDTO;
	}
	
	/**
	 * 新增测量进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg insertSurveyProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter method insertSurveyProgress....");
		
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();


		// 接收前台传来的界面元素的值
		String consDate = reqDTO.getValue("consDate");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String survey_pt_type = reqDTO.getValue("surveyPtType");
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			
			// 将二进制输入流转化为数据输入流，供解析使用
			DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
			int n = 1;
			String line = null;
			while ((line = dis.readLine()) != null) {
				line = new String(line.getBytes("ISO-8859-1"));
				String datas[] = line.split(",");
				if (datas.length != 5) {
					message = "第" + n + "行不是5列,不能加入";
					flag = true;
					break;
				}
				if (datas[0].equals("")) {
					message = "第" + n + "行第1列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[1].equals("")) {
					message = "第" + n + "行第2列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[1].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第2列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[2].equals("")) {
					message = "第" + n + "行第3列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[3].equals("")) {
					message = "第" + n + "行第4列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[3].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第4列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[4].equals("")) {
					message = "第" + n + "行第5列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[4].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第5列不是数字,不能加入";
					flag = true;
					break;
				}
				
				String data2 = "";			
				if (datas[2].indexOf(".")!=-1){
					data2 = datas[2].substring(0, datas[2].indexOf("."));
				}else{
					data2 = datas[2];
				}
				
				String data3 = "";
				if (datas[3].indexOf(".")!=-1){
					data3 = datas[3].substring(0, datas[3].indexOf("."));
				}else{
					data3 = datas[3];
				}
				
				
				if(!((data2.length() == 6)||(data2.length() == 8))){
					message = "第" + n + "行第3列X坐标值整数位应该为6位或8位！";
					flag = true;
					break;
				}
				
				if(!((data3.length() == 7)||(data3.length() == 9))){
					message = "第" + n + "行第4列Y坐标值整数位应该为7位或9位！";
					flag = true;
					break;
				}
				n++;
			}
		}

		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		Map surfaceMap = new HashMap();
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		// 1代表测量进度
		surfaceMap.put("PROGRESS_TYPE", "1");
		surfaceMap.put("SURVEY_PT_TYPE", survey_pt_type);
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			surfaceMap.put("PROGRESS_DATA", by);
		}
		surfaceMap.put("CONS_DATE", consDate);
		surfaceMap.put("CREATOR", user.getUserId());
		surfaceMap.put("CREATE_DATE", new Date());
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("BSFLAG", "0");
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		// 正常返回
		log.debug(".....exit insertSurveyProgress method...");
		return responseDTO;

	}
	
	/**
	 * 更新测量进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateSurveyProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter updateSurfaceProgress method");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		// 接收前台传来的界面元素的值
		String consDate = reqDTO.getValue("consDate");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String surveyProgressId = reqDTO.getValue("dailyProgressNo");
		String survey_pt_type = reqDTO.getValue("surveyPtType");

		// 赋值二进制文件流
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			
			// 将二进制输入流转化为数据输入流，供解析使用
			DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
			int n = 1;
			String line = null;
			while ((line = dis.readLine()) != null) {
				line = new String(line.getBytes("ISO-8859-1"));
				String datas[] = line.split(",");
				if (datas.length != 5) {
					message = "第" + n + "行不是5列,不能加入";
					flag = true;
					break;
				}
				if (datas[0].equals("")) {
					message = "第" + n + "行第1列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[1].equals("")) {
					message = "第" + n + "行第2列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[1].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第2列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[2].equals("")) {
					message = "第" + n + "行第3列不能为空,不能加入";
					flag = true;
					break;
				}
				if (datas[3].equals("")) {
					message = "第" + n + "行第4列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[3].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第4列不是数字,不能加入";
					flag = true;
					break;
				}
				if (datas[4].equals("")) {
					message = "第" + n + "行第5列不能为空,不能加入";
					flag = true;
					break;
				}
				if (!datas[4].matches(("^[\\d|.]+$"))) {
					message = "第" + n + "行第5列不是数字,不能加入";
					flag = true;
					break;
				}
				
				String data2 = "";			
				if (datas[2].indexOf(".")!=-1){
					data2 = datas[2].substring(0, datas[2].indexOf("."));
				}else{
					data2 = datas[2];
				}
				
				String data3 = "";
				if (datas[3].indexOf(".")!=-1){
					data3 = datas[3].substring(0, datas[3].indexOf("."));
				}else{
					data3 = datas[3];
				}
				
				
				if(!((data2.length() == 6)||(data2.length() == 8))){
					message = "第" + n + "行第3列X坐标值整数位应该为6位或8位！";
					flag = true;
					break;
				}
				
				if(!((data3.length() == 7)||(data3.length() == 9))){
					message = "第" + n + "行第4列Y坐标值整数位应该为7位或9位！";
					flag = true;
					break;
				}
				n++;
			}
		}

		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		
		Map surfaceMap = new HashMap();
		surfaceMap.put("DAILY_PROGRESS_NO", surveyProgressId);
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		surfaceMap.put("SURVEY_PT_TYPE", survey_pt_type);
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			surfaceMap.put("PROGRESS_DATA", by);
		}
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		log.debug(".....exit updateSurfaceProgress");
		return responseDTO;
	}
	
	/**
	 * 删除测量进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteSurveyProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter deleteSurveyProgress method");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String surveyProgressId = reqDTO.getValue("surveyProgressId");
		String update_sql = "update gp_ops_daily_progress p set p.bsflag = '1' where p.daily_progress_no = '"+surveyProgressId+"'";
		jdbcDao.executeUpdate(update_sql);
		log.debug(".....exit deleteSurveyProgress");
		return responseDTO;
	}
	/**
	 * 验证测量进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg validateSurveyProgress(ISrvMsg reqDTO) throws Exception {
		
		log.debug(".....enter method validateSurveyProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String consDate = reqDTO.getValue("consDate");
		String surveyPtType = reqDTO.getValue("surveyPtType");
		
		StringBuffer querySql = new StringBuffer("select t.daily_progress_no");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '1' and t.survey_pt_type='"+surveyPtType+"' and t.project_info_no = '"+projectInfoNo+"'");
		if(consDate != null && consDate != ""){
			querySql.append(" and t.cons_date like to_date('"+consDate+"','yyyy-mm-dd hh24:mi:ss')");
		}else{
			querySql.append(" and t.cons_date like sysdate");
		}
		
		if(jdbcDao.queryRecordBySQL(querySql.toString()) != null){
			//有数据,可以更新
			responseDTO.setValue("updateFlag", "1");
			responseDTO.setValue("curDate",curDate);
			//responseDTO.setValue("surveyPtType",surveyPtType);
			responseDTO.setValue("daily_progress_no", jdbcDao.queryRecordBySQL(querySql.toString()).get("daily_progress_no"));
		}else{
			//没数据,不更新
			responseDTO.setValue("updateFlag", "0");
		}

		log.debug(".....exit validateSurveyProgress...");
		
		return responseDTO;
	}
	/**
	 * 解析表层调查文件
	 * @param bt
	 * @return
	 * @throws Exception
	 */
	public List parseSurveyText(byte[] bt,String em) throws Exception {
		
		List<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
		
		//二进制输入流
		ByteArrayInputStream bis = null;
		
		//数据流
		DataInputStream dis = null;
		
		try {
			//将从DB中查到的二进制类型的字段传入，转化为二进制输入流
			bis = new ByteArrayInputStream(bt);
			
			//将二进制输入流转化为数据输入流，供解析使用
			dis = new DataInputStream(bis);
			
			String dataInfo = "";
			
			//逐行解析
			while((dataInfo = dis.readLine()) != null){
				dataInfo = new String(dataInfo.getBytes("ISO-8859-1"));
				
				if("".equals(dataInfo)){
					continue;
				}
				
				//将一行的数据用,分割，可以按位置取值
				String[] datas = dataInfo.split(",");

				HashMap<String,String> map = new HashMap<String,String>();

				if ("2".equals(em)) {
					// 线号
					map.put("lineNo", datas[0]);

					// 桩号
					map.put("pointNo", datas[1]);

					// X坐标
					map.put("pointX", datas[2]);

					// Y坐标
					map.put("pointY", datas[3]);

					// 高程
					map.put("altitude", datas[4]);

					log.debug("附件文档的解析出来二维项目的值：" + datas[0] + "," + datas[1]
							+ "," + datas[2] + "," + datas[3] + "," + datas[4]);

				} else {
					// 线号
					map.put("lineNo", datas[0]);

					// 桩号
					map.put("pointNo", datas[1]);

					// X坐标
					map.put("pointX", datas[2]);

					// Y坐标
					map.put("pointY", datas[3]);

					// 高程
					map.put("altitude", datas[4]);

					log.debug("附件文档的解析出来三维项目的值：" + datas[0] + "," + datas[1]
							+ "," + datas[2] + "," + datas[3] + "," + datas[4]);
				}
				
				list.add(map);
				
			}//end while
			
			dis.close();
			
			dis = null;
			
			bis.close();
			
			bis = null;
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
		return list;
	}
	
	/**
	 * 查询钻井进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDrillProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method queryDrillProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String cons_date = reqDTO.getValue("consDate");
		String queryDrillType = reqDTO.getValue("queryDrillType");
		
		StringBuffer querySql = new StringBuffer("select t.daily_progress_no,t.progress_data");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '3' and t.project_info_no = '"+projectInfoNo+"'");
		if(queryDrillType !="" &&queryDrillType != null){
			querySql.append(" and t.drill_type = '"+queryDrillType+"'");
		}
		if(cons_date != null && cons_date != ""){
			querySql.append(" and t.cons_date like to_date('"+cons_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		//时间为空,按当天来查询
		else{
			querySql.append(" and t.cons_date like sysdate");
		}
		
		Map surfaceProgressMap = jdbcDao.queryRecordBySQL(querySql.toString());
		String surfaceProgressId = "";
		byte[] bt = null;
		
		if(surfaceProgressMap != null){
			surfaceProgressId = surfaceProgressMap.get("daily_progress_no").toString();
			if(surfaceProgressMap.get("progress_data")!=""&&surfaceProgressMap.get("progress_data")!=null){
				bt = (byte[]) surfaceProgressMap.get("progress_data");
			}
		}
		
		//检查当天的数据是否已经录入
		StringBuffer checkSql = new StringBuffer("select t.daily_progress_no");
		checkSql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '3' and t.project_info_no = '"+projectInfoNo+"'");
		checkSql.append(" and t.cons_date like sysdate");
		
		if(jdbcDao.queryRecordBySQL(checkSql.toString()) != null){
			//当天有数据
			responseDTO.setValue("todayFlag", "1");
		}else{
			//当天没数据
			responseDTO.setValue("todayFlag", "0");
		}
		String em = user.getExplorationMethod();
		if("0300100012000000002".equals(em)){
			em = "2";
		}else{
			em = "3";
		}
		responseDTO.setValue("expMethod", em);
		if(bt != null){

			List surfaceProgressList = this.parseDrillText(bt,em);
			responseDTO.setValue("datas", surfaceProgressList);
		}
		
		responseDTO.setValue("dailyProgressNo", surfaceProgressId);
		responseDTO.setValue("queryDate", cons_date);
		responseDTO.setValue("queryDrillType", queryDrillType);
		
		log.debug(".....exit queryDrillProgress...");
		return responseDTO;
	}
	
	/**
	 * 新增钻井进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg insertDrillProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter method insertDrillProgress....");
		
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();


		// 接收前台传来的界面元素的值
		String consDate = reqDTO.getValue("consDate");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String drillType = reqDTO.getValue("drillType");
		
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0){
			String explorationMethod = user.getExplorationMethod();
			if("0300100012000000002".equals(explorationMethod)){
				explorationMethod = "2";
			}else{
				explorationMethod = "3";
			}
			System.out.println("explorationMethod:"+explorationMethod);
			if("3".equals(explorationMethod)){
				//三维
				WSFile uploadFile = fileList.get(0);
				byte[] by = uploadFile.getFileData();
				
				// 将二进制输入流转化为数据输入流，供解析使用
				DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
				int n = 1;
				String line = null;
				
				while ((line = dis.readLine()) != null) {
					line = new String(line.getBytes("ISO-8859-1"));
					String data[] = line.split(",");
					if (data.length != 6) {
						message = "第" + n + "行不是6列,不能加入";
						flag = true;
						break;
					}
					if (data[0].equals("")) {
						message = "第" + n + "行第1列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[1].equals("")) {
						message = "第" + n + "行第2列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[2].equals("")) {
						message = "第" + n + "行第3列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[2].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第3列不是数字,不能加入";
						flag = true;
						break;
					}
					if (data[3].equals("")) {
						message = "第" + n + "行第4列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[3].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第4列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[4].equals("")) {
						message = "第" + n + "行第5列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[4].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第5列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[5].equals("")) {
						message = "第" + n + "行第6列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[5].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第6列不是数字,不能加入";
						flag = true;
						break;
					}
					n++;
				}
			}else if("2".equals(explorationMethod) || explorationMethod == ""|| "".equals(explorationMethod)){
				//二维，如果是空，默认是二维
				WSFile uploadFile = fileList.get(0);
				byte[] by = uploadFile.getFileData();
				
				// 将二进制输入流转化为数据输入流，供解析使用
				DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
				int n = 1;
				String line = null;

				while ((line = dis.readLine()) != null) {
					String data[] = line.split(",");
					if (data.length != 5) {
						message = "第" + n + "行不是5列,不能加入";
						flag = true;
						break;
					}
					if (data[0].equals("")) {
						message = "第" + n + "行第1列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[1].equals("")) {
						message = "第" + n + "行第2列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[2].equals("")) {
						message = "第" + n + "行第3列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[2].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第3列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[3].equals("")) {
						message = "第" + n + "行第4列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[3].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第4列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[4].equals("")) {
						message = "第" + n + "行第5列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[4].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第5列不是数字,不能加入";
						flag = true;
						break;
					}
					n++;
				}
			}

		}

		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		Map surfaceMap = new HashMap();
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		// 3代表钻井进度
		surfaceMap.put("PROGRESS_TYPE", "3");
		surfaceMap.put("DRILL_TYPE", drillType);
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			surfaceMap.put("PROGRESS_DATA", by);
		}
		surfaceMap.put("CONS_DATE", consDate);
		surfaceMap.put("CREATOR", user.getUserId());
		surfaceMap.put("CREATE_DATE", new Date());
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("BSFLAG", "0");
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		// 正常返回
		log.debug(".....exit insertDrillProgress method...");
		return responseDTO;

	}
	
	/**
	 * 更新钻井进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateDrillProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter updateDrillProgress method");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		// 接收前台传来的界面元素的值
		String consDate = reqDTO.getValue("consDate");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String drillProgressId = reqDTO.getValue("drillProgressId");
		String drillType = reqDTO.getValue("drillType");

		// 赋值二进制文件流
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0){
			String explorationMethod = user.getExplorationMethod();
			if("0300100012000000002".equals(explorationMethod)){
				explorationMethod = "2";
			}else{
				explorationMethod = "3";
			}
			if("3".equals(explorationMethod)){
				//三维
				WSFile uploadFile = fileList.get(0);
				byte[] by = uploadFile.getFileData();
				
				// 将二进制输入流转化为数据输入流，供解析使用
				DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
				int n = 1;
				String line = null;
				
				while ((line = dis.readLine()) != null) {
					line = new String(line.getBytes("ISO-8859-1"));
					String data[] = line.split(",");
					if (data.length != 6) {
						message = "第" + n + "行不是6列,不能加入";
						flag = true;
						break;
					}
					if (data[0].equals("")) {
						message = "第" + n + "行第1列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[1].equals("")) {
						message = "第" + n + "行第2列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[2].equals("")) {
						message = "第" + n + "行第3列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[2].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第3列不是数字,不能加入";
						flag = true;
						break;
					}
					if (data[3].equals("")) {
						message = "第" + n + "行第4列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[3].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第4列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[4].equals("")) {
						message = "第" + n + "行第5列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[4].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第5列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[5].equals("")) {
						message = "第" + n + "行第6列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[5].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第6列不是数字,不能加入";
						flag = true;
						break;
					}
					n++;
				}
			}else if("2".equals(explorationMethod) || explorationMethod == ""|| "".equals(explorationMethod)){
				//二维，如果是空，默认是二维
				WSFile uploadFile = fileList.get(0);
				byte[] by = uploadFile.getFileData();
				
				// 将二进制输入流转化为数据输入流，供解析使用
				DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
				int n = 1;
				String line = null;

				while ((line = dis.readLine()) != null) {
					String data[] = line.split(",");
					if (data.length != 5) {
						message = "第" + n + "行不是5列,不能加入";
						flag = true;
						break;
					}
					if (data[0].equals("")) {
						message = "第" + n + "行第1列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[1].equals("")) {
						message = "第" + n + "行第2列不能为空,不能加入";
						flag = true;
						break;
					}
					if (data[2].equals("")) {
						message = "第" + n + "行第3列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[2].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第3列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[3].equals("")) {
						message = "第" + n + "行第4列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[3].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第4列不是数字,不能加入";
						flag = true;
						break;
					}
					
					if (data[4].equals("")) {
						message = "第" + n + "行第5列不能为空,不能加入";
						flag = true;
						break;
					}
					if (!data[4].matches(("^[\\d|.]+$"))) {
						message = "第" + n + "行第5列不是数字,不能加入";
						flag = true;
						break;
					}
					n++;
				}
			}
		}

		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		
		Map surfaceMap = new HashMap();
		surfaceMap.put("DAILY_PROGRESS_NO", drillProgressId);
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		surfaceMap.put("DRILL_TYPE", drillType);
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] by = uploadFile.getFileData();
			surfaceMap.put("PROGRESS_DATA", by);
		}
		surfaceMap.put("CONS_DATE", consDate);
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		log.debug(".....exit updateDrillProgress");
		return responseDTO;
	}
	
	/**
	 * 删除钻井进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteDrillProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter deleteDrillProgress method");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String drillProgressId = reqDTO.getValue("drillProgressId");
		String update_sql = "update gp_ops_daily_progress p set p.bsflag = '1' where p.daily_progress_no = '"+drillProgressId+"'";
		jdbcDao.executeUpdate(update_sql);
		log.debug(".....exit deleteDrillProgress");
		return responseDTO;
	}
	/**
	 * 验证钻井进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg validateDrillProgress(ISrvMsg reqDTO) throws Exception {
		
		log.debug(".....enter method validateDrillProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String consDate = reqDTO.getValue("consDate");
		String drillType = reqDTO.getValue("drillType");
		
		StringBuffer querySql = new StringBuffer("select t.daily_progress_no,t.drill_type");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '3' and t.drill_type = '"+drillType+"' and t.project_info_no = '"+projectInfoNo+"'");
		if(consDate != null && consDate != ""){
			querySql.append(" and t.cons_date like to_date('"+consDate+"','yyyy-mm-dd hh24:mi:ss')");
		}else{
			querySql.append(" and t.cons_date like sysdate");
		}
		
		if(jdbcDao.queryRecordBySQL(querySql.toString()) != null){
			//有数据,可以更新
			responseDTO.setValue("updateFlag", "1");
			responseDTO.setValue("curDate",curDate);
			responseDTO.setValue("dailyProgressNo", jdbcDao.queryRecordBySQL(querySql.toString()).get("daily_progress_no"));
			responseDTO.setValue("queryDrillType", jdbcDao.queryRecordBySQL(querySql.toString()).get("drill_type"));
		}else{
			//没数据,不更新
			responseDTO.setValue("updateFlag", "0");
		}

		log.debug(".....exit validateDrillProgress...");
		
		return responseDTO;
	}
	/**
	 * 解析钻井进度文件
	 * @param bt
	 * @return
	 * @throws Exception
	 */
	public List parseDrillText(byte[] bt,String em) throws Exception {
		
		List<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
		
		//二进制输入流
		ByteArrayInputStream bis = null;
		
		//数据流
		DataInputStream dis = null;
		
		try {
			//将从DB中查到的二进制类型的字段传入，转化为二进制输入流
			bis = new ByteArrayInputStream(bt);
			
			//将二进制输入流转化为数据输入流，供解析使用
			dis = new DataInputStream(bis);
			
			String dataInfo = "";
			
			//逐行解析
			while((dataInfo = dis.readLine()) != null){
				dataInfo = new String(dataInfo.getBytes("ISO-8859-1"));
				
				if("".equals(dataInfo)){
					continue;
				}
				
				//将一行的数据用,分割，可以按位置取值
				String[] datas = dataInfo.split(",");

				HashMap<String,String> map = new HashMap<String,String>();

				if("2".equals(em)){
					//测线号
					map.put("lineGroupId", datas[0]);
					
					//桩号
					map.put("pointNo",datas[1]);

					//井深
					map.put("wellDepth",datas[2]);
					//X坐标
					map.put("pointX",datas[3]);
					
					//Y坐标
					map.put("pointY",datas[4]);						
					
					log.debug("附件文档的解析出来的值："+datas[0]+","+datas[1]+","+datas[2]);

				}
				else{
					map.put("lineGroupId",datas[0]);
					
					//线号
					map.put("lineNo",datas[1]);
					
					//桩号
					map.put("pointNo",datas[2]);

					//井深
					map.put("wellDepth",datas[3]);
					
					//X坐标
					map.put("pointX",datas[4]);
					
					//Y坐标
					map.put("pointY",datas[5]);					
					
					
					log.debug("附件文档的解析出来的值："+datas[0]+","+datas[1]+","+datas[2]
					         +","+datas[3]+","+datas[4]);
				}
				
				list.add(map);
				
			}//end while
			
			dis.close();
			
			dis = null;
			
			bis.close();
			
			bis = null;
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
		return list;
	}
	
	/**
	 * 查询采集进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAcquireProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method queryAcquireProgress...");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String cons_date = reqDTO.getValue("consDate");
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		StringBuffer querySql = new StringBuffer("select t.acquire_no,t.r_data,t.s_data,t.x_data,t.line_group_id,t.cons_date");
		querySql.append(" from gp_ops_daily_acquireprog t where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"'");
		if(cons_date != null && cons_date != ""){
			querySql.append(" and t.cons_date like to_date('"+cons_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		//时间为空,按当天来查询
		//else{
		//	querySql.append(" and t.cons_date = sysdate");
		//}
		
		System.out.println("!!!!The sql is:"+querySql.toString());
		
		page = jdbcDao.queryRecordsBySQL(querySql.toString(),page);
		List aquireList = page.getData();
		responseDTO.setValue("datas", aquireList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		
		//检查当天的数据是否已经录入
		StringBuffer checkSql = new StringBuffer("select t.acquire_no");
		checkSql.append(" from gp_ops_daily_acquireprog t where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"'");
		checkSql.append(" and t.cons_date like sysdate");
		
		if(jdbcDao.queryRecordBySQL(checkSql.toString()) != null){
			//当天有数据
			responseDTO.setValue("todayFlag", "1");
		}else{
			//当天没数据
			responseDTO.setValue("todayFlag", "0");
		}

		log.debug(".....exit queryAcquireProgress...");
		return responseDTO;
	}
	
	/**
	 * 查询一条采集的详细信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAcquireProgressById(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method queryAcquireProgressById...");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String acquireNo = reqDTO.getValue("acquireNo");
		
		StringBuffer querySql = new StringBuffer("select t.acquire_no,t.r_data,t.s_data,t.x_data,t.line_group_id,t.cons_date");
		querySql.append(" from gp_ops_daily_acquireprog t where t.bsflag = '0' and t.acquire_no = '"+acquireNo+"'");
		
		Map progressInfoMap = new HashMap();
		Map progressMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if(progressMap != null){
			progressInfoMap.put("acquire_no", progressMap.get("acquire_no"));
			progressInfoMap.put("line_group_id", progressMap.get("line_group_id"));
			progressInfoMap.put("cons_date", progressMap.get("cons_date"));
		}
		responseDTO.setValue("progressInfoMap", progressInfoMap);

		log.debug(".....exit queryAcquireProgressById...");
		return responseDTO;
	}
	
	/**
	 * 新增采集进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg insertAcquireProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method insertAcquireProgress....");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		// 接收前台传来的界面元素的值
		String consDate = reqDTO.getValue("consDate");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String lineGroupId = reqDTO.getValue("lineGroupId");
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0&&fileList.size() == 3){
			
			byte[] sfile_by = null;
			byte[] rfile_by = null;
			byte[] xfile_by = null;
			for(int i=0;i<3;i++){
				WSFile f = fileList.get(i);
				String fileName = f.getFilename();
				if(fileName.indexOf(".s") != -1 || fileName.indexOf(".S") != -1){
					sfile_by = f.getFileData();
				}else if(fileName.indexOf(".r") != -1 || fileName.indexOf(".R") != -1){
					rfile_by = f.getFileData();
				}else if(fileName.indexOf(".x") != -1 || fileName.indexOf(".X") != -1){
					xfile_by = f.getFileData();
				}
			}
			
			Map surfaceMap = new HashMap();
			surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
			surfaceMap.put("S_DATA", sfile_by);
			surfaceMap.put("R_DATA", rfile_by);
			surfaceMap.put("X_DATA", xfile_by);
			surfaceMap.put("LINE_GROUP_ID", lineGroupId);
			surfaceMap.put("CONS_DATE", consDate);
			surfaceMap.put("CREATOR", user.getUserId());
			surfaceMap.put("CREATE_DATE", new Date());
			surfaceMap.put("MODIFI_DATE", user.getUserId());
			surfaceMap.put("UPDATOR", user.getUserId());
			surfaceMap.put("ORG_ID", user.getOrgId());
			surfaceMap.put("BSFLAG", "0");
			surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
			jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_acquireprog");
		}
		// 正常返回
		log.debug(".....exit insertAcquireProgress method...");
		return responseDTO;

	}
	
	/**
	 * 更新采集进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateAcquireProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter updateAcquireProgress method");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		// 接收前台传来的界面元素的值
		String consDate = reqDTO.getValue("consDate");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String lineGroupId = reqDTO.getValue("lineGroupId");
		String acquireNo = reqDTO.getValue("acquireNo");
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		boolean flag = false;
		String message = "";
		
		if(fileList.size()!=0&&fileList.size() == 3){
			WSFile SFile = fileList.get(0);
			WSFile RFile = fileList.get(1);
			WSFile XFile = fileList.get(2);
			byte[] sfile_by = SFile.getFileData();
			byte[] rfile_by = RFile.getFileData();
			byte[] xfile_by = XFile.getFileData();
			
			Map surfaceMap = new HashMap();
			surfaceMap.put("ACQUIRE_NO",acquireNo);
			surfaceMap.put("S_DATA", sfile_by);
			surfaceMap.put("R_DATA", rfile_by);
			surfaceMap.put("X_DATA", xfile_by);
			surfaceMap.put("MODIFI_DATE", user.getUserId());
			surfaceMap.put("UPDATOR", user.getUserId());
			surfaceMap.put("ORG_ID", user.getOrgId());
			surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
			jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_acquireprog");
		}

		log.debug(".....exit updateAcquireProgress");
		return responseDTO;
	}
	
	/**
	 * 删除采集进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteAcquireProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter deleteAcquireProgress method");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String[] acquireProgressNos = reqDTO.getValue("acquireNos").split(",");
		String update_sql = "";
		for(String acquireProgressNo:acquireProgressNos){
			update_sql = "update gp_ops_daily_acquireprog p set p.bsflag = '1' where p.acquire_no = '"+acquireProgressNo+"'";
			jdbcDao.executeUpdate(update_sql);
		}

		log.debug(".....exit deleteAcquireProgress");
		return responseDTO;
	}
	/**
	 * 验证采集进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg validateAcquireProgress(ISrvMsg reqDTO) throws Exception {
		
		log.debug(".....enter method validateAcquireProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String consDate = reqDTO.getValue("consDate");
		String lineGroupId = reqDTO.getValue("lineGroupId");
		
		StringBuffer querySql = new StringBuffer("select t.acquire_no");
		querySql.append(" from gp_ops_daily_acquireprog t where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"'");
		querySql.append(" and t.line_group_id = '"+lineGroupId+"'");
		if(consDate != null && consDate != ""){
			querySql.append(" and t.cons_date like to_date('"+consDate+"','yyyy-mm-dd hh24:mi:ss')");
		}else{
			querySql.append(" and t.cons_date like sysdate");
		}
		
		if(jdbcDao.queryRecordBySQL(querySql.toString()) != null){
			//有数据,可以更新
			responseDTO.setValue("updateFlag", "1");
		}else{
			//没数据,不更新
			responseDTO.setValue("updateFlag", "0");
		}

		log.debug(".....exit validateAcquireProgress...");
		
		return responseDTO;
	}
	
	/**
	 * 下载采集进度文档
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadAcquireFile(ISrvMsg reqDTO) throws Exception {

		//ISrvMsg msg = SrvMsgUtil.createMQResponseMsg(a).createResponseMsg(reqDTO);
		MQMsgImpl msg = (MQMsgImpl)SrvMsgUtil.createMQResponseMsg(reqDTO);

		String fileName = null;
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String acquireNo = reqDTO.getValue("acquireNo");
		String fileType = reqDTO.getValue("fileType");
		String lineGroupId = reqDTO.getValue("lineGroupId");
		log.debug("下载采集进度附件时对应的主键值为：" + acquireNo);

		StringBuffer getFileSql = new StringBuffer("select t.acquire_no,t.r_data,t.s_data,t.x_data,t.line_group_id,t.cons_date");
		getFileSql.append(" from gp_ops_daily_acquireprog t where t.bsflag = '0' ");
		getFileSql.append(" and t.project_info_no = '"+projectInfoNo+"'");
		getFileSql.append(" and t.line_group_id = '"+lineGroupId+"'");
		Map aquireMap = jdbcDao.queryRecordBySQL(getFileSql.toString());
		if(aquireMap != null){
			
			byte[] sfile_by = (byte[])aquireMap.get("s_data");
			byte[] rfile_by = (byte[])aquireMap.get("r_data");
			byte[] xfile_by = (byte[])aquireMap.get("x_data");
			WSFile file = new WSFile();
			
			if (fileType.equals("sFile")) {
					fileName = "采集进度S文件";
					file.setFileData(sfile_by);
					file.setFilename(fileName+".txt");
					msg.setFile(file);
					msg.setValue("fileName", fileName);
			}else if (fileType.equals("rFile")) {
					fileName = "采集进度R文件";
					file.setFileData(rfile_by);
					file.setFilename(fileName+".txt");
					msg.setFile(file);
					msg.setValue("fileName", fileName);
			}else if (fileType.equals("xFile")) {
					fileName = "采集进度X文件";
					file.setFileData(xfile_by);
					file.setFilename(fileName+".txt");
					msg.setFile(file);
					msg.setValue("fileName", fileName);
			}
		}
		return msg;
	}
	
	/**
	 * 查询试验进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryTestProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method queryTestProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String lineGroupId = reqDTO.getValue("lineGroupId");
		String testPlace = reqDTO.getValue("testPlace");
		String testType = reqDTO.getValue("testType");
		
		StringBuffer querySql = new StringBuffer("select p.test_progress_no,p.test_date,p.line_group_id,p.test_place,p.source_type,");
		querySql.append(" p.total_test_sp_num,p.test_qualified_sp_num2,p.test_type,decode(p.test_type,'1','系统试验','2','考核试验') as test_type_value ");
		querySql.append(" from gp_ops_test_progress p where p.bsflag = '0' and p.project_info_no = '"+projectInfoNo+"'");
		if(lineGroupId != null && lineGroupId != ""){
			querySql.append(" and p.line_group_id like '%"+lineGroupId+"%'");
		}
		if(testPlace != null && testPlace != ""){
			querySql.append(" and p.test_place like '%"+testPlace+"%'");
		}
		if(testType != null && testType != ""){
			querySql.append(" and p.test_type = '"+testType+"'");
		}
		
		page = jdbcDao.queryRecordsBySQL(querySql.toString(),page);
		List testList = page.getData();
		responseDTO.setValue("datas", testList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		
		log.debug(".....exit queryTestProgress...");
		return responseDTO;
	}
	/**
	 * 查询一条试验进度的详细信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryTestProgressById(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method queryTestProgressById...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String testProgressNo = reqDTO.getValue("testProgressNo");
		
		StringBuffer querySql = new StringBuffer("select p.test_progress_no,p.test_date,p.line_group_id,p.test_place,p.source_type,p.test_type,decode(p.test_type,'1','系统试验','2','考核试验') as test_type_value,");
		querySql.append(" p.test_point_x,p.test_point_y,p.test_content,p.test_conclusion,p.total_test_sp_num,p.test_qualified_sp_num2,p.notes");
		querySql.append(" from gp_ops_test_progress p where p.bsflag = '0' and p.test_progress_no = '"+testProgressNo+"'");
		
		Map progressInfoMap = new HashMap();
		Map progressMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if(progressMap != null){
			progressInfoMap.put("testProgressNo", progressMap.get("test_progress_no"));
			progressInfoMap.put("testDate", progressMap.get("test_date"));
			progressInfoMap.put("lineGroupId", progressMap.get("line_group_id"));
			progressInfoMap.put("testPlace", progressMap.get("test_place"));
			progressInfoMap.put("sourceType", progressMap.get("source_type"));
			progressInfoMap.put("testPointX", progressMap.get("test_point_x"));
			progressInfoMap.put("testPointY", progressMap.get("test_point_y"));
			progressInfoMap.put("testContent", progressMap.get("test_content"));
			progressInfoMap.put("testConclusion", progressMap.get("test_conclusion"));
			progressInfoMap.put("notes", progressMap.get("notes"));
			progressInfoMap.put("testType", progressMap.get("test_type"));
			progressInfoMap.put("testTypeValue", progressMap.get("test_type_value"));
			progressInfoMap.put("totalTestSpNum", progressMap.get("total_test_sp_num"));
			progressInfoMap.put("testQualifiedSpNum2", progressMap.get("test_qualified_sp_num2"));
		}
		
		responseDTO.setValue("progressInfoMap", progressInfoMap);
		log.debug(".....exit queryTestProgressById...");
		return responseDTO;
	}
	
	/**
	 * 插入试验进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg insertTestProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method insertTestProgress....");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		// 接收前台传来的界面元素的值
		String testType = reqDTO.getValue("testType");
		String testDate = reqDTO.getValue("testDate");
		
		String lineGroupId = reqDTO.getValue("lineGroupId");
		String testPlace = reqDTO.getValue("testPlace");
		
		String testPointX = reqDTO.getValue("testPointX");
		String testPointY = reqDTO.getValue("testPointY");
		
		String totalTestSpNum = reqDTO.getValue("totalTestSpNum");
		String testQualifiedSpNum2 = reqDTO.getValue("testQualifiedSpNum2");
		
		String sourceType = reqDTO.getValue("sourceType");
		String testContent = reqDTO.getValue("testContent");
		
		String testConclusion = reqDTO.getValue("testConclusion");
		String notes = reqDTO.getValue("notes");
			
		Map surfaceMap = new HashMap();
		surfaceMap.put("PROJECT_INFO_NO",user.getProjectInfoNo());
		surfaceMap.put("TEST_DATE", testDate);
		surfaceMap.put("LINE_GROUP_ID", lineGroupId);
		surfaceMap.put("TEST_TYPE", testType);
		surfaceMap.put("TEST_PLACE", testPlace);
		surfaceMap.put("TEST_POINT_X", testPointX);
		surfaceMap.put("TEST_POINT_Y", testPointY);
		surfaceMap.put("SOURCE_TYPE", sourceType);
		surfaceMap.put("TEST_CONTENT", testContent);
		surfaceMap.put("TEST_CONCLUSION", testConclusion);
		surfaceMap.put("NOTES", notes);
		surfaceMap.put("TOTAL_TEST_SP_NUM", totalTestSpNum);
		surfaceMap.put("TEST_QUALIFIED_SP_NUM2", testQualifiedSpNum2);
		surfaceMap.put("CREATOR", user.getUserId());
		surfaceMap.put("CREATE_DATE", new Date());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("MODIFI_DATE", new Date());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("BSFLAG", "0");
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_test_progress");

		log.debug(".....exit insertTestProgress method...");
		return responseDTO;

	}
	
	/**
	 * 更新试验进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateTestProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter updateTestProgress method");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		// 接收前台传来的界面元素的值
		String testProgressNo = reqDTO.getValue("testProgressId");
		String testType = reqDTO.getValue("testType");
		String testDate = reqDTO.getValue("testDate");
		
		String lineGroupId = reqDTO.getValue("lineGroupId");
		String testPlace = reqDTO.getValue("testPlace");
		
		String testPointX = reqDTO.getValue("testPointX");
		String testPointY = reqDTO.getValue("testPointY");
		
		String totalTestSpNum = reqDTO.getValue("totalTestSpNum");
		String testQualifiedSpNum2 = reqDTO.getValue("testQualifiedSpNum2");
		
		String sourceType = reqDTO.getValue("sourceType");
		String testContent = reqDTO.getValue("testContent");
		
		String testConclusion = reqDTO.getValue("testConclusion");
		String notes = reqDTO.getValue("notes");
			
		Map surfaceMap = new HashMap();
		surfaceMap.put("TEST_PROGRESS_NO",testProgressNo);
		surfaceMap.put("TEST_DATE", testDate);
		surfaceMap.put("LINE_GROUP_ID", lineGroupId);
		surfaceMap.put("TEST_TYPE", testType);
		surfaceMap.put("TEST_PLACE", testPlace);
		surfaceMap.put("TEST_POINT_X", testPointX);
		surfaceMap.put("TEST_POINT_Y", testPointY);
		surfaceMap.put("SOURCE_TYPE", sourceType);
		surfaceMap.put("TEST_CONTENT", testContent);
		surfaceMap.put("TEST_CONCLUSION", testConclusion);
		surfaceMap.put("TOTAL_TEST_SP_NUM", totalTestSpNum);
		surfaceMap.put("TEST_QUALIFIED_SP_NUM2", testQualifiedSpNum2);
		surfaceMap.put("NOTES", notes);
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("MODIFI_DATE", new Date());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_test_progress");

		log.debug(".....exit updateTestProgress");
		return responseDTO;
	}
	
	/**
	 * 删除试验进度
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTestProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter deleteTestProgress method");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String[] testProgressNos = reqDTO.getValue("testProgressIds").split(",");
		String update_sql = "";
		for(String testProgressNo:testProgressNos){
			update_sql = "update gp_ops_test_progress p set p.bsflag = '1' where p.test_progress_no = '"+testProgressNo+"'";
			jdbcDao.executeUpdate(update_sql);
		}
		log.debug(".....exit deleteTestProgress");
		return responseDTO;
	}
	
	/**
	 * 下载钻井文件
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadDrillFile(ISrvMsg reqDTO) throws Exception {
		
		MQMsgImpl msg = (MQMsgImpl)SrvMsgUtil.createMQResponseMsg(reqDTO);
		String fileName = null;
		
		String dailyProgressNo = reqDTO.getValue("dailyProgressNo");
		log.debug("下载钻井进度附件时对应的主键值为：" + dailyProgressNo);

		String getFileSql = "select t.cons_date,t.progress_data from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '3' and t.daily_progress_no = '"+dailyProgressNo+"'";
		Map fileMap = jdbcDao.queryRecordBySQL(getFileSql);
		if(fileMap != null){
			byte[] dril_file_by = (byte[])fileMap.get("progress_data");
			WSFile file = new WSFile();
			
			if (dril_file_by != null) {
					fileName = "钻井进度附件"+fileMap.get("cons_date");
					file.setFileData(dril_file_by);
					file.setFilename(fileName+".txt");
					msg.setFile(file);
					msg.setValue("fileName", fileName);
			}
		}
		return msg;
	}
	
	/**
	 * 下载表层文件
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadSurfaceFile(ISrvMsg reqDTO) throws Exception {
		
		MQMsgImpl msg = (MQMsgImpl)SrvMsgUtil.createMQResponseMsg(reqDTO);
		String fileName = null;
		
		String dailyProgressNo = reqDTO.getValue("dailyProgressNo");
		log.debug("下载表层进度附件时对应的主键值为：" + dailyProgressNo);

		String getFileSql = "select t.cons_date,t.progress_data from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '2' and t.daily_progress_no = '"+dailyProgressNo+"'";
		Map fileMap = jdbcDao.queryRecordBySQL(getFileSql);
		if(fileMap != null){
			byte[] surface_file_by = (byte[])fileMap.get("progress_data");
			WSFile file = new WSFile();
			
			if (surface_file_by != null) {
					fileName = "表层进度附件"+fileMap.get("cons_date");
					file.setFileData(surface_file_by);
					file.setFilename(fileName+".txt");
					msg.setFile(file);
					msg.setValue("fileName", fileName);
			}
		}
		return msg;
	}
	
	/**
	 * 下载测量文件
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadSurveyFile(ISrvMsg reqDTO) throws Exception {
		
		MQMsgImpl msg = (MQMsgImpl)SrvMsgUtil.createMQResponseMsg(reqDTO);
		String fileName = null;
		
		String dailyProgressNo = reqDTO.getValue("dailyProgressNo");
		log.debug("下载测量进度附件时对应的主键值为：" + dailyProgressNo);

		String getFileSql = "select t.cons_date,t.progress_data from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '1' and t.daily_progress_no = '"+dailyProgressNo+"'";
		Map fileMap = jdbcDao.queryRecordBySQL(getFileSql);
		if(fileMap != null){
			byte[] survey_file_by = (byte[])fileMap.get("progress_data");
			WSFile file = new WSFile();
			
			if (survey_file_by != null) {
					fileName = "测量进度附件"+fileMap.get("cons_date");
					file.setFileData(survey_file_by);
					file.setFilename(fileName+".txt");
					msg.setFile(file);
					msg.setValue("fileName", fileName);
			}
		}
		return msg;
	}
}

package com.bgp.gms.service.rm.dm;

import java.io.Serializable;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
/**
 * 设备调剂服务类
 * @author liweiming
 */
public class DispensingDevSrv extends BaseService {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	public ISrvMsg saveDispensingInfo(ISrvMsg reqDTO) throws Exception{
		Map map = reqDTO.toMap();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gms_device_disapp");
		return msg;
	}
	/**
	 * 大港调剂调配
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgDeviceApp(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String orgCode = user.getOrgCode();
		//查询该中心是否需要分配设备，有就显示调配申请单。
		String appSql = "select app.* from gms_device_app app where app.project_info_no='"+project_info_no+"' and app.DEVICE_APP_ID  " +
				"in(select distinct  detail.DEVICE_APP_ID from gms_device_app_detail detail where detail.DEV_OUT_ORG_ID='"+orgCode+"') " +
				"order by app.CREATE_DATE";
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(appSql, page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
		
	}

	
	
	
	public ISrvMsg saveDisAppBaseInfo(ISrvMsg msg) throws Exception {		
		//1.获得基本信息
		String project_info_no = msg.getValue("projectInfoNo");
		String device_app_name = msg.getValue("device_app_name");
		String remark = msg.getValue("remark");
		String device_allapp_id = msg.getValue("device_allapp_id");
		//2.存放基本信息
		Map<String,Object> mainMap = new HashMap<String,Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_name", device_app_name);
		mainMap.put("device_allapp_id", device_allapp_id);
		//2.1 新补充的申请单类别信息
		//String mixtypename = new String(msg.getValue("mixtypename").getBytes("iso-8859-1"),"utf-8");
		//String mixtypeusername = new String(msg.getValue("mixtypeusername").getBytes("iso-8859-1"),"utf-8");
		String mixtypeid = msg.getValue("mixownership");
		//2.2 从对应关系获得组织机构 : 主要是对应于专业化
		UserToken user = msg.getUserToken();
		String mixorgid = DevUtil.getMixOrgId(mixtypeid, user);
		mainMap.put("mix_org_id", mixorgid);
		
		mainMap.put("mix_type_id", mixtypeid);
		//mainMap.put("mix_type_name", mixtypename);
		//mainMap.put("mix_user_id", mixtypeusername);
		
		/** 修改操作，用于更新的主键信息 */
		String device_app_id = msg.getValue("device_app_id");
		if(device_app_id!=null&&!"".equals(device_app_id)){
			mainMap.put("device_app_id", device_app_id);
		}
		//3.生成基本信息
		mainMap.put("remark", remark);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		mainMap.put("app_org_id", user.getOrgId());
		mainMap.put("employee_id", user.getEmpId());
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", user.getEmpId());
		mainMap.put("org_id", user.getCodeAffordOrgID());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		//对大计划进行保存的操作：新建是0，提交是9
		String state = msg.getValue("state");
		mainMap.put("state", state);
		//判断是否生成了调配申请单号，如果没生成，那么先生成
		String s_device_app_no = msg.getValue("device_app_no");
		if("".equals(s_device_app_no)){
			//String device_app_no = DevUtil.getDeviceAppNo();
			Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String device_app_no = "调剂计划" + sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
			mainMap.put("device_app_no", device_app_no);
		}
		if(DevConstants.STATE_SAVED.equals(state)){
			//4.保存操作信息的保存
			mainMap.put("appdate", DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd"));
			mainMap.put("create_date", currentdate);
			mainMap.put("creator_id", user.getEmpId());
		}else if(DevConstants.STATE_SUBMITED.equals(state)){
			//5.提交操作
			mainMap.put("appdate", currentdate);
			//将状态更改为已提交
			mainMap.put("state", DevConstants.STATE_SUBMITED);
		}
		//6.向数据库写入信息
		jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_disapp");
		//7.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	
	public ISrvMsg getDisAppBaseInfo(ISrvMsg msg) throws Exception {
		String device_app_id = msg.getValue("deviceappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		//1.将申请单基本信息返回给界面
		StringBuffer sb = new StringBuffer().append("select t.device_mixapp_id,gp.project_name,app.device_app_no,app.device_app_name,t.device_mixapp_no,t.device_mixapp_name,org.org_abbreviation,emp.employee_name,t.appdate from gms_device_dismixapp t left join gms_device_app app on t.device_app_id = app.device_app_id and app.bsflag='0' left join gp_task_project gp on t.project_info_no=gp.project_info_no left join comm_org_information org on t.app_org_id = org.org_id left join comm_human_employee emp on t.employee_id = emp.employee_id where t.device_mixapp_id='"+device_app_id+"' and t.bsflag='0' ");
		Map deviceappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if(deviceappMap!=null){
			responseMsg.setValue("deviceappMap", deviceappMap);
		}
		return responseMsg;
	}
	/**
	 * 保存设备调剂计划信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDisAppDetailInfo(ISrvMsg msg) throws Exception {
		//1.获得基本信息
		String project_info_no = msg.getValue("projectInfoNo");
		String device_app_id = msg.getValue("deviceappid");
		//2.用户和时间信息
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		//3.用于处理明细信息的读取
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~",-1);
		String[] idinfos = msg.getValue("idinfos").split("~",-1);
		//给明细信息都保存到List中，用于存储子表
		List<Map<String,Object>> devDetailList = new ArrayList<Map<String,Object>>();
		for(int i=0;i<count;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			String keyid = lineinfos[i];
			//如果为修改操作，那么存在deviceallappdetid
			String deviceappdetid = msg.getValue("deviceappdetid"+keyid);
			if(deviceappdetid!=null&&!"".equals(deviceappdetid)){
				dataMap.put("device_app_detid", deviceappdetid);
			}
			String deviceallappdetid = idinfos[i];
			dataMap.put("device_allapp_detid", deviceallappdetid);
			//删除标记
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			//设备编码
			String dev_ci_code = msg.getValue("signtype"+keyid);
			dataMap.put("dev_ci_code", dev_ci_code);
			String apply_num = msg.getValue("applynum"+keyid);
			dataMap.put("apply_num", apply_num);
			String plan_start_date = msg.getValue("startdate"+keyid);
			dataMap.put("plan_start_date", plan_start_date);
			String plan_end_date = msg.getValue("enddate"+keyid);
			dataMap.put("plan_end_date", plan_end_date);
			String unitinfo = msg.getValue("unitinfo"+keyid);
			dataMap.put("unitinfo", unitinfo);
			//是否为类别编码 2012-9-26 liujb 
			String isdevicecode = msg.getValue("isdevicecode"+keyid);
			dataMap.put("isdevicecode", isdevicecode);
			//主表的ID
			dataMap.put("device_app_id", device_app_id);
			//项目的ID
			dataMap.put("project_info_no", project_info_no);
			//班组ID
			String teamid = msg.getValue("teamid"+keyid);
			dataMap.put("teamid", teamid);
			//班组team
			String teamname = msg.getValue("team"+keyid);
			dataMap.put("team", teamname);
			//创建时间
			dataMap.put("create_date", currentdate);
			//创建人
			dataMap.put("employee_id", employee_id);
			//用途purpose
			dataMap.put("purpose", msg.getValue("purpose"+keyid));
			
			devDetailList.add(dataMap);
		}
		//4.保存子表信息
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_disapp_detail");
		}
		
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	
	
	public ISrvMsg saveDisAppModifyInfowfpa(ISrvMsg msg) throws Exception {
		String oprstate = msg.getValue("oprstate");
		if("pass".equals(oprstate)){
			String device_app_id = msg.getValue("device_app_id");
			String leaderinfo = msg.getValue("leaderinfo");
			StringBuffer updateSql = new StringBuffer(" update gms_device_disapp set leaderinfo = '");
			updateSql.append(leaderinfo).append("' ");
			updateSql.append(" where device_app_id = '").append(device_app_id).append("'");
			jdbcDao.executeUpdate(updateSql.toString());
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD
	 * 保存调剂单信息(物探自有的设备，包含了出库单)
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSelfDisMixFormAllInfo(ISrvMsg msg) throws Exception {
		//1.获得基本信息
		String project_info_no = msg.getValue("project_info_no");
		String deviceappid = msg.getValue("deviceappid");
		//2.用户和时间信息
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String state = msg.getValue("state");
		//-- 先保存基本表
		Map<String,Object> mainMap = new HashMap<String,Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_id", deviceappid);
		mainMap.put("app_org_id", user.getOrgId());
		mainMap.put("appdate", DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd"));
		mainMap.put("mix_org_id", msg.getValue("out_org_id"));
		mainMap.put("mix_type_id", msg.getValue("mix_type_id"));
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("employee_id", employee_id);
		mainMap.put("state", state);
		String devicemixappname = msg.getValue("device_mixapp_name");
		mainMap.put("device_mixapp_name", devicemixappname);
		mainMap.put("create_date", currentdate);
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		if("".equals(msg.getValue("device_mixapp_no"))){
			Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String device_mixapp_no = "调剂申请" + sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
			mainMap.put("device_mixapp_no", device_mixapp_no);
		}
		else{
			mainMap.put("device_mixapp_no", msg.getValue("device_mixapp_no"));
		}
		//如果已经有了id，那么将其放在map中，实现修改功能
		Serializable mainid = null;
		String device_mixapp_id = msg.getValue("device_mixapp_id");
		if(device_mixapp_id!=null&&!"".equals(device_mixapp_id)){
			mainMap.put("device_mixapp_id", device_mixapp_id);
			mainid = device_mixapp_id;
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}else{
			//保存后的mainid信息
			mainid = jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}
		//3.1 用于处理明细信息的读取(单台) 
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~",-1);
		String[] idinfos = msg.getValue("idinfos").split("~",-1);
		//先给子表的都删了，再全都保存
		jdbcDao.executeUpdate("delete from gms_device_dismixapp_detail where device_mixapp_id='"+mainid+"' ");
		for(int i=0;i<count;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			String keyid = lineinfos[i];
			String device_app_detid = idinfos[i];
			dataMap.put("device_app_detid", device_app_detid);
			//devcicode
			String devcicode = msg.getValue("devcicode"+keyid);
			dataMap.put("dev_ci_code", devcicode);
			//设备名称
			String dev_name = msg.getValue("devicename"+keyid);
			dataMap.put("dev_name", dev_name);
			//设备型号
			String dev_type = msg.getValue("devicemodel"+keyid);
			dataMap.put("dev_type", dev_type);
			//isdevicecode 2012-9-26 liujb 
			String isdevicecode = msg.getValue("isdevicecode"+keyid);
			dataMap.put("isdevicecode", isdevicecode);
			//apply_num
			String mixappnum = msg.getValue("mixappnum"+keyid);
			dataMap.put("apply_num", mixappnum);
			
			//查询关联信息
			Map<String,Object> tempMap = jdbcDao.queryRecordBySQL("select device_allapp_detid,team,teamid,unitinfo,purpose from gms_device_app_detail dui where dui.device_app_detid='"+device_app_detid+"'");
			
			dataMap.putAll(tempMap);			
			//devcicode
			String startdate = msg.getValue("startdate"+keyid);
			dataMap.put("plan_start_date", startdate);
			//devcicode
			String enddate = msg.getValue("enddate"+keyid);
			dataMap.put("plan_end_date", enddate);
			dataMap.put("project_info_no", project_info_no);
			//主表的ID
			dataMap.put("device_mixapp_id", mainid);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_dismixapp_detail");
		}
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 大港保存调剂单信息(物探自有的设备，包含了出库单)
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSelfDisMixFormAllInfoDg(ISrvMsg msg) throws Exception {
		//大港无调配单-从配置计划表中取需要的数据
		//1.获得基本信息
		String project_info_no = msg.getValue("project_info_no");
		String deviceallappid = msg.getValue("deviceallappid");
		//2.用户和时间信息
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String state = msg.getValue("state");
		//-- 先保存基本表
		Map<String,Object> mainMap = new HashMap<String,Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_id", deviceallappid);
		mainMap.put("app_org_id", user.getOrgId());
		mainMap.put("appdate", DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd"));
		mainMap.put("mix_org_id", msg.getValue("out_org_id"));
		mainMap.put("mix_type_id", "S9998");//大港使用-用来区分与别的物探处的自有调剂
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("employee_id", employee_id);
		mainMap.put("state", state);
		String devicemixappname = msg.getValue("device_mixapp_name");
		mainMap.put("device_mixapp_name", devicemixappname);
		mainMap.put("create_date", currentdate);
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		if("".equals(msg.getValue("device_mixapp_no"))){
			Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String device_mixapp_no = "大港调剂申请" + sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
			mainMap.put("device_mixapp_no", device_mixapp_no);
		}
		else{
			mainMap.put("device_mixapp_no", msg.getValue("device_mixapp_no"));
		}
		//如果已经有了id，那么将其放在map中，实现修改功能
		Serializable mainid = null;
		String device_mixapp_id = msg.getValue("device_mixapp_id");
		if(device_mixapp_id!=null&&!"".equals(device_mixapp_id)){
			mainMap.put("device_mixapp_id", device_mixapp_id);
			mainid = device_mixapp_id;
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}else{
			//保存后的mainid信息
			mainid = jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}
		//3.1 用于处理明细信息的读取(单台) 
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~",-1);
		String[] idinfos = msg.getValue("idinfos").split("~",-1);
		//先给子表的都删了，再全都保存
		jdbcDao.executeUpdate("delete from gms_device_dismixapp_detail where device_mixapp_id='"+mainid+"' ");
		for(int i=0;i<count;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			String keyid = lineinfos[i];
			String device_allapp_detid = idinfos[i];
			dataMap.put("device_app_detid", device_allapp_detid);
			//devcicode
			String devcicode = msg.getValue("devcicode"+keyid);
			dataMap.put("dev_ci_code", devcicode);
			//设备名称
			String dev_name = msg.getValue("devicename"+keyid);
			dataMap.put("dev_name", dev_name);
			//设备型号
			String dev_type = msg.getValue("devicemodel"+keyid);
			dataMap.put("dev_type", dev_type);
			//isdevicecode 2012-9-26 liujb 
			String isdevicecode = msg.getValue("isdevicecode"+keyid);
			dataMap.put("isdevicecode", isdevicecode);
			//apply_num
			String mixappnum = msg.getValue("mixappnum"+keyid);
			dataMap.put("apply_num", mixappnum);
			
			//查询关联信息
			Map<String,Object> tempMap = jdbcDao.queryRecordBySQL("select device_allapp_detid,team,teamid,unitinfo,purpose from gms_device_allapp_detail where device_allapp_detid='"+device_allapp_detid+"'");
				
			dataMap.putAll(tempMap);			
			//devcicode
			String startdate = msg.getValue("startdate"+keyid);
			dataMap.put("plan_start_date", startdate);
			//devcicode
			String enddate = msg.getValue("enddate"+keyid);
			dataMap.put("plan_end_date", enddate);
			dataMap.put("project_info_no", project_info_no);
			//主表的ID
			dataMap.put("device_mixapp_id", mainid);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_dismixapp_detail");
		}

		String updateSql = "update gms_device_allapp allapp set allapp.assign_state = '1' ";
			   updateSql += "where allapp.project_info_no ='"+project_info_no+"' ";
			   updateSql += "and allapp.device_allapp_id ='"+deviceallappid+"' ";
		   jdbcDao.executeUpdate(updateSql);
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}

}

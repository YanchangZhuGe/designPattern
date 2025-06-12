package com.bgp.gms.android.srv;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import jxl.Workbook;
import jxl.format.Orientation;
import jxl.write.Alignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WorkFlowBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soaf.util.Operation;
import com.cnpc.jcdp.util.AppCrypt;
import com.cnpc.jcdp.util.DateUtil;
import com.cnpc.jcdp.webapp.upload.WebPathUtil;
import com.cnpc.sais.ibp.auth2.util.PasswordUtil;

/**
 * 作者：刘鑫
 * 
 * 时间：2014-3-10
 * 
 * 说明：设备模块手持机后台服务操作
 */

@Service("DeviceDataSrv")
public class DeviceDataSrv extends BaseService {

	private ILog log = LogFactory.getLogger(WorkFlowBean.class);
	private IJdbcDao ijdbcDao = BeanFactory.getQueryJdbcDAO();
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	
	
//	/*
//	 * 
//	 * 单台设备待接收数据信息接口（下载）
//	 */
//	@Operation(input = "androidParam" , output="deviceDatas")
//	public ISrvMsg devInit(ISrvMsg reqDTO) throws Exception {
//		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
//		String infos = reqDTO.getValue("androidParam");
////		JSONArray jsonArray = JSONArray.fromString(infos);
//		
//		String[] info = infos.split(",");
//		String  projectId = info[0];
//		String receiveDate = info[1];
//		String modle_name = info[2];
//		
//		if(modle_name!=null&&modle_name.equals("D_JCYS")){
//			String ssss = downloadDeviceAppmix(reqDTO );
//			reqMsg.setValue("deviceDatas", ssss);
//		}
//		return reqMsg;
//		
//	}
	
	
	/*
	 * 
	 * 单台设备待接收数据信息接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadDeviceAppmix(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String  asd = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(asd);
		
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String project_id = object.get("project_id").toString();
		String if_first = object.get("if_first").toString();
		String receive_date = object.get("receive_date").toString();
		String modle_name = object.get("modle_name").toString();

//		String sql = "select a.dev_acc_id,a.dev_name,a.self_num,a.license_num,a.dev_model,a.dev_sign,p.project_id,f.device_mixinfo_id " +
//				"from gms_device_appmix_detail t inner join gms_device_appmix_main m on t.device_mix_subid = m.device_mix_subid  " +
//				"inner join gms_device_mixinfo_form f on f.device_mixinfo_id = m.device_mixinfo_id " +
//				"inner join gp_task_project p on p.project_info_no=f.project_info_no and p.bsflag='0'  " +
//				"inner join gms_device_account a on a.dev_acc_id = t.dev_acc_id  where p.project_id = '"+project_id+"' and (t.state <> '1' or t.state is null) ";
		//dev_type 1:自有	2:附属设备	3:装备调配单台	
		//4:外租设备保存显示都不同，待解决
		String sql = "select * from (select a.dev_acc_id, a.dev_name, a.self_num, a.license_num, a.dev_model, a.dev_sign, p.project_id, f.device_mixinfo_id,'1' dev_type,f.modifi_date,f.bsflag  "+
					" from gms_device_appmix_detail t inner join gms_device_appmix_main m on t.device_mix_subid = m.device_mix_subid "+
					"inner join gms_device_mixinfo_form f on f.device_mixinfo_id = m.device_mixinfo_id "+
					"inner join gp_task_project p on p.project_info_no = f.project_info_no and p.bsflag = '0' "+
					"inner join gms_device_account a on a.dev_acc_id = t.dev_acc_id "+
					"where p.project_id = '"+project_id+"' and (t.state <> '1' or t.state is null) "+
					"union all "+
					"select a.dev_acc_id, a.dev_name, a.self_num, a.license_num, a.dev_model, a.dev_sign, p.project_id,dt.device_outinfo_id ,'2' dev_type,outform.modifi_date,outform.bsflag  "+
					"from gms_device_equ_outdetail_added dt  "+
					"inner join gms_device_coll_outform outform on outform.device_outinfo_id=dt.device_outinfo_id and outform.bsflag='0' "+
					"inner join gp_task_project p on outform.project_info_no=p.project_info_no and p.bsflag='0' "+
					"inner join gms_device_account a on a.dev_acc_id = dt.dev_acc_id "+
					"where p.project_id='"+project_id+"' and (dt.state <> '9' or dt.state is null) "+
					"union all "+
					"select acc.dev_acc_id,acc.dev_name,acc.self_num,acc.license_num,acc.dev_model,acc.dev_sign,p.project_id,dt.device_outinfo_id,'2' dev_type,outform.modifi_date,outform.bsflag  " +
					"from gms_device_equ_outdetail_added dt inner join gms_device_equ_outform outform on dt.device_outinfo_id = outform.device_outinfo_id and outform.bsflag = '0' " +
					"inner join gp_task_project p on outform.project_info_no=p.project_info_no and p.bsflag='0' left join gms_device_account acc on acc.dev_acc_id = dt.dev_acc_id " +
					"where p.project_id='"+project_id+"' and (dt.state <> '9' or dt.state is null) "+
					"union all "+
					"select a.dev_acc_id, a.dev_name, a.self_num, a.license_num, a.dev_model, a.dev_sign, p.project_id,sub.device_outinfo_id,'3' dev_type ,ouf.modifi_date,ouf.bsflag "+ 
					"from gms_device_equ_outdetail dt "+
					"inner join gms_device_equ_outsub sub on sub.device_oif_subid = dt.device_oif_subid "+
					"inner join gms_device_equ_outform ouf on sub.device_outinfo_id = ouf.device_outinfo_id  "+
					"inner join gp_task_project p on ouf.project_info_no=p.project_info_no and p.bsflag='0' "+
					"inner join gms_device_account a on a.dev_acc_id = dt.dev_acc_id "+
					"where p.project_id='"+project_id+"' and (dt.state <> '9' or dt.state is null) ) tt";
		
		if(!if_first.equals("true")){
			sql += " where tt.modifi_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss')";
		}
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		Map map = new HashMap();
		map.put("device_list",list);
		map.put("modifi_date",currentdate);
		JSONObject jsonObject = new JSONObject();
		
		System.out.println(jsonObject.fromBean(map).toString());
//		JSONArray jsonArray = JSONArray.fromCollection(list);
	
		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		return reqMsg;
	}	
	
	/*
	 * 
	 * 单台设备申请单下载接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadDeviceAppmixForm(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String  asd = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(asd);
		
		String project_id = object.get("project_id").toString();
		String if_first = object.get("if_first").toString();
		String receive_date = object.get("receive_date").toString();
		String modle_name = object.get("modle_name").toString();

//		String sql = "select devapp.device_app_name,dm.mixinfo_no,dm.device_mixinfo_id,dm.device_app_id,dm.bsflag " +
//				"from gms_device_mixinfo_form dm inner join gms_device_app devapp on dm.device_app_id = devapp.device_app_id " +
//				"inner join gp_task_project pro on devapp.project_info_no = pro.project_info_no and pro.bsflag = '0' " +
//				"where '1' = '1' and dm.state = '9' and (dm.mixform_type = '1' or dm.mixform_type = '3') and " +
//				"dm.mix_type_id = 'S0000' and (dm.opr_state<>'9' or dm.opr_state is null) and pro.project_id = '"+project_id+"'";
		
		//dev_type 1:自有	2:附属设备	3:装备调配单台	4:外租设备
		String sql = "select * from (select devapp.device_app_name,dm.mixinfo_no,dm.device_mixinfo_id,dm.device_app_id,dm.bsflag  ,dm.mix_type_id," +
					"'1' dev_type,dm.modifi_date from gms_device_mixinfo_form dm inner join gms_device_app devapp on dm.device_app_id = devapp.device_app_id "+ 
			        "inner join gp_task_project pro on devapp.project_info_no = pro.project_info_no and pro.bsflag = '0' "+ 
			        "where '1' = '1' and dm.state = '9' and (dm.mixform_type = '1' or dm.mixform_type = '3') and  "+
			        "dm.mix_type_id = 'S0000' and (dm.opr_state<>'9' or dm.opr_state is null) and pro.project_id = '"+project_id+"' "+
			        "union all "+
			        "select app.device_app_name,t.outinfo_no,t.device_outinfo_id,t.device_mixinfo_id,t.bsflag,'S1405' as mix_type_id," +
			        "'2' dev_type,t.modifi_date from gms_device_coll_outform t  left join gms_device_collmix_form mif on t.device_mixinfo_id=mif.device_mixinfo_id "+
			        "left join gms_device_collapp app on mif.device_app_id = app.device_app_id "+
			        "inner join  gp_task_project gp on t.project_info_no=gp.project_info_no "+  
			        "left join comm_human_employee he on t.print_emp_id = he.employee_id "+ 
			        "where t.state = '9' and gp.project_id = '"+project_id+"' and "+ 
			        "exists (select 1 from gms_device_equ_outdetail_added added where added.device_outinfo_id = t.device_outinfo_id) "+
			        "and (t.opr_state<>'9' or t.opr_state is null) "+
			        "union all "+ 
			        "select devapp.device_app_name,outform.outinfo_no,outform.device_outinfo_id,outform.device_mixinfo_id,outform.bsflag,mif.mix_type_id," +
			        "'3' dev_type,outform.modifi_date from gms_device_equ_outform outform "+ 
			        "left join gms_device_mixinfo_form mif on outform.device_mixinfo_id=mif.device_mixinfo_id "+
			        "left join gms_device_app devapp on devapp.device_app_id=mif.device_app_id "+
			        "inner join gp_task_project pro on outform.project_info_no=pro.project_info_no "+
			        "where outform.state='9' and pro.project_id = '"+project_id+"'"+
			        "and (outform.opr_state<>'9' or outform.opr_state is null)"+
			        "union all"+
			        "select devapp.device_hireapp_name,devapp.device_hireapp_no,devapp.device_hireapp_id,devapp.device_allapp_id,devapp.bsflag,''," +
			        "'4' dev_type,devapp.modifi_date from gms_device_hireapp devapp "+  
			        "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_hireapp_id and wfmiddle.bsflag='0' "+ 
			        "inner join gp_task_project pro on devapp.project_info_no=pro.project_info_no "+
			        "where  pro.project_id='"+project_id+"' and wfmiddle.proc_status='3' ) tt ";
		
		if(!if_first.equals("true")){
			sql += " where tt.modifi_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss')";
		}
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		map.put("modifi_date",currentdate);
		JSONObject jsonObject = new JSONObject();
		
//		JSONArray jsonArray = JSONArray.fromCollection(list);
		
		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 单台设备待接收数据信息接口（上传）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadDeviceAppmix(ISrvMsg reqDTO) throws Exception {
		String  infos = reqDTO.getValue("androidParam");
		
		JSONObject  object = JSONObject.fromObject(infos);
		JSONArray jsonArray11 = object.getJSONArray("dantai");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		if(jsonArray11.length()>0){
		for(int m =0;m<jsonArray11.length();m++){
			JSONObject object11 = jsonArray11.getJSONObject(m);
			
		String device_mixinfo_id = 	object11.get("device_mixinfo_id").toString();	//申请单主键
		String projectId = (String)object11.get("project_id");  //项目id
		String devaccId = (String)object11.get("dev_acc_id");	//设备编号
		String strDate = (String)object11.get("actual_start_date");	//实际进场时间
//		String dev_position = (String)object11.get("devPosition"); //存放地(省份+库房)
		String maintenance_cycle = (String)object11.get("maintenance_cycle"); //保养周期
		String note = (String)object11.get("memo");
		String state = object11.get("state").toString();  //验收状态  1:合格;0:不合格
		String user_id = object11.get("user_id").toString();
		String dev_type = object11.get("dev_type").toString();	//1:自有	2:附属设备	3:装备调配单台	4:外租设备	
		
		if(dev_type.equals("1")){
			String querysql="select plan.maintenance_cycle,f.project_info_no,p.project_id,t.*,a.dev_name,a.dev_model," +
					"unit.coding_name as dev_unit,teamid.coding_name as team_name,a.dev_position,f.in_org_id,f.out_org_id,f.device_mixinfo_id,f.mix_type_id " +
					"from gms_device_appmix_detail t inner join gms_device_appmix_main m on t.device_mix_subid = m.device_mix_subid and m.bsflag='0' " +
					"inner join gms_device_mixinfo_form f on f.device_mixinfo_id = m.device_mixinfo_id and f.bsflag='0' " +
					"inner join gp_task_project p on p.project_info_no=f.project_info_no and p.bsflag='0'  " +
					"inner join gms_device_account a on a.dev_acc_id = t.dev_acc_id and a.bsflag = '0' " +
					"left join gms_device_maintenance_plan plan on a.dev_acc_id = plan.dev_acc_id " +
					"left join comm_coding_sort_detail teamid on t.team = teamid.coding_code_id " +
					"left join comm_coding_sort_detail unit on a.dev_unit = unit.coding_code_id " +
					"where p.project_id = '"+projectId+"' and t.dev_acc_id = '"+devaccId+"' and f.device_mixinfo_id = '"+device_mixinfo_id+"'";
			Map queryMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(querysql);
			if(queryMap!=null){
				String projectInfoNo = (String)queryMap.get("projectInfoNo");
				Date date=sdf.parse(strDate);//实际进场时间
				String endDate = (String)queryMap.get("devPlanEndDate");
				Date planEndDate=sdf.parse(endDate);//计划离场时间
				
				String team =(String)queryMap.get("team");
				String dev_plan_start_date = (String)queryMap.get("devPlanStartDate");
				String dev_plan_end_date =(String)queryMap.get("devPlanEndDate");
				String dev_in_org =(String)queryMap.get("inOrgId");
				String dev_out_org =(String)queryMap.get("outOrgId");
				
				String  deviceMixDetid = (String)queryMap.get("deviceMixDetid");
				String deviceMixinfoId = (String)queryMap.get("deviceMixinfoId");
				String mixTypeId = (String)queryMap.get("mixTypeId");
			
				//修改台帐的使用状态
				Map<String,Object> mainMap = new HashMap<String,Object>();
				mainMap.put("dev_acc_id", devaccId);
				mainMap.put("using_stat", "0110000007000000001");
				mainMap.put("project_info_no",projectInfoNo);
				mainMap.put("search_id", "");
	//			mainMap.put("dev_position", dev_position);
				mainMap.put("MODIFI_DATE", new Date());
				jdbcDao.saveOrUpdateEntity(mainMap,"gms_device_account");
			
			
				DeviceMCSBean devbean = new DeviceMCSBean();
			//将设备插入到队级台帐
			Map<String,Object> Map_dui = devbean.queryDevAccInfo(devaccId);
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
			String searchid = UUID.randomUUID().toString().replaceAll("-", "");
			Map_dui.put("search_id", searchid);
			Map_dui.remove("dev_acc_id");
			Map_dui.put("fk_dev_acc_id", devaccId);
			Map_dui.put("project_info_id", projectInfoNo);
			Map_dui.put("planning_in_time", dev_plan_start_date);
			Map_dui.put("planning_out_time", dev_plan_end_date);
			Map_dui.put("actual_in_time", date);
			Map_dui.put("fk_device_appmix_id", deviceMixDetid);
			Map_dui.put("dev_team", team);
			Map_dui.put("using_stat", "0110000007000000001");
			Map_dui.put("mix_type_id",mixTypeId);
			Map_dui.put("in_org_id", dev_in_org);
			Map_dui.put("out_org_id", dev_out_org);
			Map_dui.put("RECEIVE_STATE", state);
			Serializable curid = jdbcDao.saveOrUpdateEntity(Map_dui,"gms_device_account_dui");
			
			
			//修改调配调剂明细表状态改为1表示已接收
			Map<String,Object> Map_mix = new HashMap<String,Object>();
			Map_mix.put("device_mix_detid", deviceMixDetid);
			Map_mix.put("team_dev_acc_id", curid.toString());
			Map_mix.put("actual_in_time", date);
			Map_mix.put("state", "1");
			jdbcDao.saveOrUpdateEntity(Map_mix,"gms_device_appmix_detail");
			
			//添加备注
			Map<String,Object> Map_remark = new HashMap<String,Object>();
			Map_remark.put("FOREIGN_KEY_ID", deviceMixDetid);
			Map_remark.put("NOTES", note);
			Map_remark.put("CREATOR", user_id);
			Map_remark.put("CREATE_DATE", new Date());
			Map_remark.put("UPDATOR", user_id);
			Map_remark.put("MODIFI_DATE", new Date());
			Map_remark.put("BSFLAG", "0");
			jdbcDao.saveOrUpdateEntity(Map_remark,"BGP_COMM_REMARK");
			
			//2012-9-28 liujb 动态表插入 去项目的 动态记录 indb_date作用不大
			Map<String,Object> Map_dymInfo = new HashMap<String,Object>();
			Map_dymInfo.put("dev_acc_id", devaccId);
			Map_dymInfo.put("device_appmix_id", deviceMixDetid);
			Map_dymInfo.put("project_info_no", projectInfoNo);
			Map_dymInfo.put("oprtype", DevConstants.DYM_OPRTYPE_OUT);
			Map_dymInfo.put("alter_date", date);
			Map_dymInfo.put("indb_date", date);
			jdbcDao.saveOrUpdateEntity(Map_dymInfo,"gms_device_dyminfo");
			
			
	//		String maintenance_cycle_value = msg.getValue("maintenance_cycle_value").trim();
			String queryCycle = "select coding_name,coding_code_id from comm_coding_sort_detail where coding_code_id = '"+maintenance_cycle+"'";
			Map mapCycle = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryCycle);
			if(mapCycle!=null){
				String maintenance_cycle_value = (String)mapCycle.get("codingName");  //保养周期天数
			
				int cyclevalue = Integer.parseInt("".equals(maintenance_cycle_value)?"0":maintenance_cycle_value);
				if(cyclevalue>0){
					//将保养周期，阶级设备id插入保养计划表中
					String searchidsqlString = "select dev_acc_id from gms_device_account_dui where search_id='" + searchid + "'";
					Date d=date;
					d=DateUtils.addDays(d, cyclevalue);
					int i=1;
					for(;d.before(planEndDate);){
						System.out.println(sdf.format(d));
						Map<String,Object> Map_Maint = jdbcDao.queryRecordBySQL(searchidsqlString);
						Map_Maint.put("actual_time", date);
						Map_Maint.put("plan_num", i);
						Map_Maint.put("last_maintenance_time", date);
						Map_Maint.put("maintenance_cycle", maintenance_cycle_value);
						Map_Maint.put("planning_out_time",dev_plan_end_date);
						Map_Maint.put("plan_date",sdf.format(d));
						jdbcDao.saveOrUpdateEntity(Map_Maint,"gms_device_maintenance_plan");
						d=DateUtils.addDays(d, cyclevalue);
						i++;
					}
				}
			}
			//将作业信息插入设备作业信息表
			String sql = "select t.*,tp.exploration_method,p.heath_info_id,p.pm_info,p.qm_info,p.hse_info from bgp_p6_project t join gp_task_project tp on t.project_info_no = tp.project_info_no and tp.bsflag = '0' " +
			 "left outer join bgp_pm_project_heath_info p on t.project_info_no = p.project_info_no where 1=1 and t.bsflag = '0' and t.project_info_no is not null ";
				   sql += " and t.project_info_no = '"+projectInfoNo+"'";
				   Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
				   if(map!=null){
						Map<String,Object> Map_proecss = devbean.queryDevProcess(deviceMixDetid);
						Map_proecss.put("project_info_no", projectInfoNo);
						Map_proecss.put("task_id", map.get("objectId"));
						jdbcDao.saveOrUpdateEntity(Map_proecss,"gms_device_receive_process");
				   }
			
			
			//更新调配单的处理状态 2012-9-26 start
			String updatesql1 = "update gms_device_mixinfo_form mif set opr_state='1' "+
								"where exists (select 1 from GMS_DEVICE_APPMIX_DETAIL dad "+ 
								"join gms_device_appmix_main dam "+ 
								"on dad.device_mix_subid=dam.device_mix_subid "+ 
								"where dam.device_mixinfo_id='"+deviceMixinfoId+"' and dad.state='1') "+
								"and exists(select 1 from GMS_DEVICE_APPMIX_DETAIL dad "+ 
								"join gms_device_appmix_main dam "+ 
								"on dad.device_mix_subid=dam.device_mix_subid "+ 
								"where dam.device_mixinfo_id='"+deviceMixinfoId+"' and (dad.state!='1' or dad.state is null)) "+
								"and mif.device_mixinfo_id = '"+deviceMixinfoId+"' ";
			String updatesql2 = "update gms_device_mixinfo_form mif set opr_state='9' "+
								"where exists (select 1 from GMS_DEVICE_APPMIX_DETAIL dad "+ 
								"join gms_device_appmix_main dam "+ 
								"on dad.device_mix_subid=dam.device_mix_subid "+ 
								"where dam.device_mixinfo_id='"+deviceMixinfoId+"' and dad.state='1') "+
								"and not exists(select 1 from GMS_DEVICE_APPMIX_DETAIL dad "+ 
								"join gms_device_appmix_main dam "+ 
								"on dad.device_mix_subid=dam.device_mix_subid "+ 
								"where dam.device_mixinfo_id='"+deviceMixinfoId+"' and (dad.state!='1' or dad.state is null))"+
								"and mif.device_mixinfo_id = '"+deviceMixinfoId+"' ";
			jdbcDao.executeUpdate(updatesql1);
			jdbcDao.executeUpdate(updatesql2);
			}
		}else if(dev_type.equals("2")){
				String querysql="select plan.maintenance_cycle,outform.project_info_no,dt.*,acc.dev_name,acc.dev_model,acc.dev_unit,acc.dev_position,"+
		    				"case dt.state when '0' then '未接收' when '9' then '已接收'  else '未接收' end as state_desc, "+
							"teamid.coding_name as team_name from gms_device_equ_outdetail_added dt "+
							"inner join gms_device_coll_outform outform on outform.device_outinfo_id=dt.device_outinfo_id and outform.bsflag='0' "+
							"inner join gp_task_project p on outform.project_info_no=p.project_info_no and p.bsflag='0' "+
							"left join gms_device_account acc on acc.dev_acc_id=dt.dev_acc_id "+
							"left join comm_coding_sort_detail teamid on dt.team=teamid.coding_code_id "+
							"left join gms_device_maintenance_plan plan on dt.dev_acc_id = plan.dev_acc_id "+
							"where p.project_id = '"+projectId+"' and dt.dev_acc_id = '"+devaccId+"' and dt.device_outinfo_id = '"+device_mixinfo_id+"' "+
				
							" union all select plan.maintenance_cycle,outform.project_info_no,dt.*,acc.dev_name,acc.dev_model,acc.dev_unit,acc.dev_position,"+
							"case dt.state when '0' then '未接收' when '9' then '已接收'  else '未接收' end as state_desc, "+
							"teamid.coding_name as team_name from gms_device_equ_outdetail_added dt "+
							"inner join gms_device_equ_outform outform on outform.device_outinfo_id=dt.device_outinfo_id and outform.bsflag='0' "+
							"inner join gp_task_project p on outform.project_info_no=p.project_info_no and p.bsflag='0' "+
							"left join gms_device_account acc on acc.dev_acc_id=dt.dev_acc_id "+
							"left join comm_coding_sort_detail teamid on dt.team=teamid.coding_code_id "+
							"left join gms_device_maintenance_plan plan on dt.dev_acc_id = plan.dev_acc_id "+
							"where p.project_id = '"+projectId+"' and dt.dev_acc_id = '"+devaccId+"' and dt.device_outinfo_id = '"+device_mixinfo_id+"'";
				Map queryMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(querysql);
				if(queryMap!=null){
				
				String projectInfoNo = queryMap.get("projectInfoNo")==null?"":(String)queryMap.get("projectInfoNo");
				String team =queryMap.get("team")==null?"":(String)queryMap.get("team");
				String dev_plan_start_date = queryMap.get("devPlanStartDate")==null?"":(String)queryMap.get("devPlanStartDate");
				String dev_plan_end_date = queryMap.get("devPlanEndDate")==null?"":(String)queryMap.get("devPlanEndDate");
				String deviceOifDetid = queryMap.get("deviceOifDetid")==null?"":(String)queryMap.get("deviceOifDetid");
				String deviceOutinfoId = queryMap.get("deviceOutinfoId")==null?"":(String)queryMap.get("deviceOutinfoId");

				Date date=sdf.parse(strDate);//实际进场时间
				String endDate = dev_plan_end_date;
				Date planEndDate = sdf.parse(sdf.format(new Date()));
				if(endDate!=null&&!endDate.equals("")){
					planEndDate=sdf.parse(endDate);//计划离场时间
				}
			
			DeviceMCSBean devbean = new DeviceMCSBean();
			//修改台帐的使用状态
			Map<String,Object> mainMap = new HashMap<String,Object>();
			mainMap.put("dev_acc_id", devaccId);
			mainMap.put("using_stat", "0110000007000000001");
			mainMap.put("project_info_no", projectInfoNo);
			mainMap.put("search_id", "");
//			mainMap.put("dev_position", dev_position2);
			jdbcDao.saveOrUpdateEntity(mainMap,"gms_device_account");
			//将设备插入到队级台帐
			Map<String,Object> Map_dui = devbean.queryDevAccInfo(devaccId);
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
			String searchid = UUID.randomUUID().toString().replaceAll("-", "");
			Map_dui.put("search_id", searchid);
			Map_dui.remove("dev_acc_id");
			Map_dui.put("fk_dev_acc_id", devaccId);
			Map_dui.put("project_info_id", projectInfoNo);
			Map_dui.put("planning_in_time", dev_plan_start_date);
			Map_dui.put("planning_out_time", dev_plan_end_date);
			Map_dui.put("actual_in_time", strDate);
			Map_dui.put("fk_device_appmix_id", deviceOifDetid);
			Map_dui.put("dev_team", team);
			Map_dui.put("mix_type_id", "S1405");
			Map_dui.put("RECEIVE_STATE", state);
			jdbcDao.saveOrUpdateEntity(Map_dui,"gms_device_account_dui");
			//修改调配调剂明细表状态改为1表示已接收
			Map<String,Object> Map_mix = new HashMap<String,Object>();
			Map_mix.put("device_oif_detid", deviceOifDetid);
			Map_mix.put("state", "9");
			jdbcDao.saveOrUpdateEntity(Map_mix,"gms_device_equ_outdetail_added");
			
			//添加备注
			Map<String,Object> Map_remark = new HashMap<String,Object>();
			Map_remark.put("FOREIGN_KEY_ID", deviceOifDetid);
			Map_remark.put("NOTES", note);
			Map_remark.put("CREATOR", user_id);
			Map_remark.put("CREATE_DATE", new Date());
			Map_remark.put("UPDATOR", user_id);
			Map_remark.put("MODIFI_DATE", new Date());
			Map_remark.put("BSFLAG", "0");
			jdbcDao.saveOrUpdateEntity(Map_remark,"BGP_COMM_REMARK");
			
			//2012-9-28 liujb 动态表插入 去项目的 动态记录 indb_date作用不大
			Map<String,Object> Map_dymInfo = new HashMap<String,Object>();
			Map_dymInfo.put("dev_acc_id", devaccId);
			Map_dymInfo.put("device_appmix_id", deviceOifDetid);
			Map_dymInfo.put("project_info_no", projectInfoNo);
			Map_dymInfo.put("oprtype", DevConstants.DYM_OPRTYPE_OUT);
			Map_dymInfo.put("alter_date", date);
			Map_dymInfo.put("indb_date", date);
			jdbcDao.saveOrUpdateEntity(Map_dymInfo,"gms_device_dyminfo");
			//2012-10-30 有可能设备不需要保养 增加控制
			
			String queryCycle = "select coding_name,coding_code_id from comm_coding_sort_detail where coding_code_id = '"+maintenance_cycle+"'";
			Map mapCycle = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryCycle);
			if(mapCycle!=null){
				String maintenance_cycle_value = (String)mapCycle.get("codingName");  //保养周期天数
			
				int cyclevalue = Integer.parseInt("".equals(maintenance_cycle_value)?"0":maintenance_cycle_value);
				if(cyclevalue>0){
				//将保养周期，阶级设备id插入保养计划表中
					String searchidsqlString = "select dev_acc_id from gms_device_account_dui where search_id='" + searchid + "'";
					Date d=date;
					d=DateUtils.addDays(d, cyclevalue);
					for(;d.before(planEndDate);){
						Map<String,Object> Map_Maint = jdbcDao.queryRecordBySQL(searchidsqlString);
						Map_Maint.put("actual_time", date);
						Map_Maint.put("last_maintenance_time", date);
						Map_Maint.put("maintenance_cycle", maintenance_cycle);
						Map_Maint.put("planning_out_time",dev_plan_end_date);
						Map_Maint.put("plan_date",sdf.format(d));
						jdbcDao.saveOrUpdateEntity(Map_Maint,"gms_device_maintenance_plan");
						d=DateUtils.addDays(d, cyclevalue);
					}
				}
			//将作业信息插入设备作业信息表
				//将作业信息插入设备作业信息表
				String sql = "select t.*,tp.exploration_method,p.heath_info_id,p.pm_info,p.qm_info,p.hse_info from bgp_p6_project t join gp_task_project tp on t.project_info_no = tp.project_info_no and tp.bsflag = '0' " +
				 "left outer join bgp_pm_project_heath_info p on t.project_info_no = p.project_info_no where 1=1 and t.bsflag = '0' and t.project_info_no is not null ";
					   sql += " and t.project_info_no = '"+projectInfoNo+"'";
					   Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
					   if(map!=null){
							Map<String,Object> Map_proecss = devbean.queryDevProcess(deviceOifDetid);
							Map_proecss.put("project_info_no", projectInfoNo);
							Map_proecss.put("task_id", map.get("objectId"));
							jdbcDao.saveOrUpdateEntity(Map_proecss,"gms_device_receive_process");
					   }
				
			String updatesql1 = "update gms_device_equ_outform mif set opr_state='1' "+
								"where exists (select 1 from gms_device_equ_outdetail_added dad "+ 
								"where dad.device_outinfo_id='"+deviceOutinfoId+"' and dad.state='9') "+
								"and exists(select 1 from gms_device_equ_outdetail_added dad "+ 
								"where dad.device_outinfo_id='"+deviceOutinfoId+"' and (dad.state!='9' or dad.state is null)) "+
								"and mif.device_outinfo_id = '"+deviceOutinfoId+"' ";
			
			String updatesql2 = "update gms_device_equ_outform mif set opr_state='9' "+
								"where exists (select 1 from gms_device_equ_outdetail_added dad "+ 
								"where dad.device_outinfo_id='"+deviceOutinfoId+"' and dad.state='9') "+
								"and not exists(select 1 from gms_device_equ_outdetail_added dad "+ 
								"where dad.device_outinfo_id='"+deviceOutinfoId+"' and (dad.state!='9' or dad.state is null)) "+
								"and mif.device_outinfo_id = '"+deviceOutinfoId+"' ";

			jdbcDao.executeUpdate(updatesql1);
			jdbcDao.executeUpdate(updatesql2);
			}}
			//更新调配单的处理状态 2012-9-26 end
			//回写成功消息
		}else if(dev_type.equals("3")){
			String querysql="select plan.maintenance_cycle,ouf.project_info_no,ouf.device_outinfo_id,mif.mix_type_id,dt.*,acc.dev_name,acc.dev_model,acc.dev_unit,acc.dev_position,"+
			"case dt.state when '0' then '未接收' when '9' then '已接收'  else '未接收' end as state_desc, "+
			"teamid.coding_name as team_name from gms_device_equ_outdetail dt "+
			"inner join gms_device_equ_outsub sub on sub.device_oif_subid = dt.device_oif_subid "+
			"inner join gms_device_equ_outform ouf on sub.device_outinfo_id = ouf.device_outinfo_id and ouf.bsflag='0' "+
			"inner join gp_task_project p on ouf.project_info_no=p.project_info_no and p.bsflag='0' "+
			"left join gms_device_mixinfo_form mif on ouf.device_mixinfo_id=mif.device_mixinfo_id "+
			"left join gms_device_account acc on acc.dev_acc_id=dt.dev_acc_id "+
			"left join comm_coding_sort_detail teamid on dt.team=teamid.coding_code_id "+
			"left join gms_device_maintenance_plan plan on dt.dev_acc_id = plan.dev_acc_id "+
			"where p.project_id = '"+projectId+"' and dt.dev_acc_id = '"+devaccId+"' and ouf.device_outinfo_id = '"+device_mixinfo_id+"'";
			Map queryMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(querysql);
			if(queryMap!=null){
			
			String projectInfoNo = queryMap.get("projectInfoNo")==null?"":(String)queryMap.get("projectInfoNo");
			String team =queryMap.get("team")==null?"":(String)queryMap.get("team");
			String dev_plan_start_date = queryMap.get("devPlanStartDate")==null?"":(String)queryMap.get("devPlanStartDate");
			String dev_plan_end_date = queryMap.get("devPlanEndDate")==null?"":(String)queryMap.get("devPlanEndDate");
			String deviceOifDetid = queryMap.get("deviceOifDetid")==null?"":(String)queryMap.get("deviceOifDetid");
			String deviceOutinfoId = queryMap.get("deviceOutinfoId")==null?"":(String)queryMap.get("deviceOutinfoId");
			String mixTypeId = queryMap.get("mixTypeId")==null?"":(String)queryMap.get("mixTypeId");
			Date date=sdf.parse(strDate);//实际进场时间
			String endDate = dev_plan_end_date;
			Date planEndDate = sdf.parse(sdf.format(new Date()));
			if(endDate!=null&&!endDate.equals("")){
				planEndDate=sdf.parse(endDate);//计划离场时间
			}
			DeviceMCSBean devbean = new DeviceMCSBean();
			//修改台帐的使用状态
			Map<String,Object> mainMap = new HashMap<String,Object>();
			mainMap.put("dev_acc_id", devaccId);
			mainMap.put("using_stat", "0110000007000000001");
			mainMap.put("project_info_no", projectInfoNo);
			mainMap.put("search_id", "");
			jdbcDao.saveOrUpdateEntity(mainMap,"gms_device_account");
			//将设备插入到队级台帐
			Map<String,Object> Map_dui = devbean.queryDevAccInfo(devaccId);
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
			String searchid = UUID.randomUUID().toString().replaceAll("-", "");
			Map_dui.put("search_id", searchid);
			Map_dui.remove("dev_acc_id");
			Map_dui.put("fk_dev_acc_id", devaccId);
			Map_dui.put("project_info_id", projectInfoNo);
			Map_dui.put("planning_in_time", dev_plan_start_date);
			Map_dui.put("planning_out_time", dev_plan_end_date);
			Map_dui.put("actual_in_time", strDate);
			Map_dui.put("fk_device_appmix_id", deviceOifDetid);
			Map_dui.put("dev_team", team);
			Map_dui.put("mix_type_id", mixTypeId);
			Map_dui.put("RECEIVE_STATE", state);
			jdbcDao.saveOrUpdateEntity(Map_dui,"gms_device_account_dui");
			//修改调配调剂明细表状态改为1表示已接收
			Map<String,Object> Map_mix = new HashMap<String,Object>();
			Map_mix.put("device_oif_detid", deviceOifDetid);
			Map_mix.put("state", "9");
			Map_mix.put("actual_in_time", strDate);
			jdbcDao.saveOrUpdateEntity(Map_mix,"gms_device_equ_outdetail");
			
			//添加备注
			Map<String,Object> Map_remark = new HashMap<String,Object>();
			Map_remark.put("FOREIGN_KEY_ID", deviceOifDetid);
			Map_remark.put("NOTES", note);
			Map_remark.put("CREATOR", user_id);
			Map_remark.put("CREATE_DATE", new Date());
			Map_remark.put("UPDATOR", user_id);
			Map_remark.put("MODIFI_DATE", new Date());
			Map_remark.put("BSFLAG", "0");
			jdbcDao.saveOrUpdateEntity(Map_remark,"BGP_COMM_REMARK");
			
			//2012-9-28 liujb 动态表插入 去项目的 动态记录 indb_date作用不大
			Map<String,Object> Map_dymInfo = new HashMap<String,Object>();
			Map_dymInfo.put("dev_acc_id", devaccId);
			Map_dymInfo.put("device_appmix_id", deviceOifDetid);
			Map_dymInfo.put("project_info_no", projectInfoNo);
			Map_dymInfo.put("oprtype", DevConstants.DYM_OPRTYPE_OUT);
			Map_dymInfo.put("alter_date", date);
			Map_dymInfo.put("indb_date", date);
			jdbcDao.saveOrUpdateEntity(Map_dymInfo,"gms_device_dyminfo");
			
			
			String queryCycle = "select coding_name,coding_code_id from comm_coding_sort_detail where coding_code_id = '"+maintenance_cycle+"'";
			Map mapCycle = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryCycle);
			if(mapCycle!=null){
				String maintenance_cycle_value = (String)mapCycle.get("codingName");  //保养周期天数
			
				int cyclevalue = Integer.parseInt("".equals(maintenance_cycle_value)?"0":maintenance_cycle_value);
				if(cyclevalue>0){
				//将保养周期，阶级设备id插入保养计划表中
				String searchidsqlString = "select dev_acc_id from gms_device_account_dui where search_id='" + searchid + "'";
				Date d=date;
				d=DateUtils.addDays(d, cyclevalue);
				for(;d.before(planEndDate);){
					Map<String,Object> Map_Maint = jdbcDao.queryRecordBySQL(searchidsqlString);
					Map_Maint.put("actual_time", date);
					Map_Maint.put("last_maintenance_time", date);
					Map_Maint.put("maintenance_cycle", maintenance_cycle);
					Map_Maint.put("planning_out_time",dev_plan_end_date);
					Map_Maint.put("plan_date",sdf.format(d));
					jdbcDao.saveOrUpdateEntity(Map_Maint,"gms_device_maintenance_plan");
					d=DateUtils.addDays(d, cyclevalue);
				}
				}
				//将作业信息插入设备作业信息表
				String sql = "select t.*,tp.exploration_method,p.heath_info_id,p.pm_info,p.qm_info,p.hse_info from bgp_p6_project t join gp_task_project tp on t.project_info_no = tp.project_info_no and tp.bsflag = '0' " +
				 "left outer join bgp_pm_project_heath_info p on t.project_info_no = p.project_info_no where 1=1 and t.bsflag = '0' and t.project_info_no is not null ";
					   sql += " and t.project_info_no = '"+projectInfoNo+"'";
					   Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
					   if(map!=null){
							Map<String,Object> Map_proecss = devbean.queryDevProcess(deviceOifDetid);
							Map_proecss.put("project_info_no", projectInfoNo);
							Map_proecss.put("task_id", map.get("objectId"));
							jdbcDao.saveOrUpdateEntity(Map_proecss,"gms_device_receive_process");
					   }
				String updatesql1 = "update gms_device_equ_outform mif set opr_state='1' "+
								"where exists (select 1 from gms_device_equ_outdetail dad "+ 
								"join gms_device_equ_outsub dam "+ 
								"on dad.device_oif_subid=dam.device_oif_subid "+ 
								"where dam.device_outinfo_id='"+deviceOutinfoId+"' and dad.state='9') "+
								"and exists(select 1 from gms_device_equ_outdetail dad "+ 
								"join gms_device_equ_outsub dam "+ 
								"on dad.device_oif_subid=dam.device_oif_subid "+ 
								"where dam.device_outinfo_id='"+deviceOutinfoId+"' and (dad.state!='9' or dad.state is null)) "+
								"and mif.device_outinfo_id = '"+deviceOutinfoId+"' ";
				
				String updatesql2 = "update gms_device_equ_outform mif set opr_state='9' "+
								"where exists (select 1 from gms_device_equ_outdetail dad "+ 
								"join gms_device_equ_outsub dam "+ 
								"on dad.device_oif_subid=dam.device_oif_subid "+ 
								"where dam.device_outinfo_id='"+deviceOutinfoId+"' and dad.state='9') "+
								"and not exists(select 1 from gms_device_equ_outdetail dad "+ 
								"join gms_device_equ_outsub dam "+ 
								"on dad.device_oif_subid=dam.device_oif_subid "+ 
								"where dam.device_outinfo_id='"+deviceOutinfoId+"' and (dad.state!='9' or dad.state is null)) "+
								"and mif.device_outinfo_id = '"+deviceOutinfoId+"' ";
			
			jdbcDao.executeUpdate(updatesql1);
			jdbcDao.executeUpdate(updatesql2);
			
			}}
		}
		}
		}
///		newProj_1249001101,8ad891f63d3964d5013d3973e9a60167,2014-03-10,河北省涿州市,30
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 批量设备待接收数据信息接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadCollOutform(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String  asd = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(asd);
		
		String project_id = object.get("project_id").toString();
		String if_first = object.get("if_first").toString();
		String receive_date = object.get("receive_date").toString();
		String modle_name = object.get("modle_name").toString();
		String sql = "select tt.device_outinfo_id,tt.device_app_id,tt.device_app_name,tt.opr_state,tt.device_oif_subid,tt.device_name,tt.device_model,tt.out_num as apply_num,tt.modifi_date,tt.dev_type,nvl(tt.out_num,0) - nvl(dd.receive_num, 0) out_num " +
				" from (select cof.device_outinfo_id,devapp.device_app_id,case when devapp.device_app_name is null then cmf.backapp_name else devapp.device_app_name end device_app_name, " +
				"cof.opr_state, sub.device_oif_subid,sub.device_name,sub.device_model,sub.out_num,cof.modifi_date ,'1' dev_type from gms_device_coll_outform cof " +
				"inner join gms_device_coll_outsub sub on cof.device_outinfo_id = sub.device_outinfo_id " +
				"inner join gp_task_project tp on cof.project_info_no = tp.project_info_no and tp.bsflag='0' " +
				"left join gms_device_collmix_form mif on cof.device_mixinfo_id = mif.device_mixinfo_id " +
				"left join gms_device_collapp devapp on devapp.device_app_id = mif.device_app_id " +
				"left join gms_device_collbackapp cmf on cof.device_mixinfo_id = cmf.device_backapp_id " +
				"where cof.state = '9' and cof.bsflag = '0' and sub.receive_state='0' and tp.project_id = '"+project_id+"' "+
				"union all select dm.device_mixinfo_id, devapp.device_app_id, devapp.device_app_name, dm.opr_state,mi.device_mix_subid,info.dev_name," +
				"info.dev_model,mi.assign_num,dm.modifi_date ,'2' dev_type from gms_device_mixinfo_form dm  " +
				"inner join gms_device_appmix_main mi on dm.device_mixinfo_id = mi.device_mixinfo_id and mi.bsflag='0' " +
				"inner join gp_task_project tp on dm.project_info_no = tp.project_info_no and tp.bsflag='0' " +
				"left join gms_device_app devapp on dm.device_app_id = devapp.device_app_id   " +
				"left join gms_device_collectinfo info on mi.dev_ci_code = info.device_id  where '1' = '1' and dm.state = '9' and mi.state is null and dm.bsflag = '0' " +
				"and (dm.mixform_type = '1' or dm.mixform_type = '3') and dm.mix_type_id = 'S14050208' and tp.project_id = '"+project_id+"') tt " +
				"left join (select sum(rec.receive_num) receive_num,rec.device_oif_subid from GMS_DEVICE_COLL_ACCOUNT_REC rec where rec.bsflag='0' group by rec.device_oif_subid) dd on tt.device_oif_subid = dd.device_oif_subid "+
				"where (tt.opr_state<>'9'  or tt.opr_state is null) ";
				if(!if_first.equals("true")){
					sql += " and tt.modifi_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss') " ;
				}
				sql += " order by tt.opr_state";
		
//		opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
//		JSONArray jsonArray = JSONArray.fromCollection(list);
		
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		map.put("modifi_date",currentdate);
		JSONObject jsonObject = new JSONObject();
		
		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 批量设备申请单信息接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadCollOutformForm(ISrvMsg reqDTO) throws Exception {
		
		String  androidParam = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(androidParam);
		
		String project_id = object.get("project_id").toString();
		String if_first = object.get("if_first").toString();
		String receive_date = object.get("receive_date").toString();
		String modle_name = object.get("modle_name").toString();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select * from (select devapp.device_app_id,case when devapp.device_app_name is null then cmf.backapp_name else devapp.device_app_name end device_app_name," +
				"cof.opr_state,cof.modifi_date as update_date,cof.device_outinfo_id,cof.bsflag,e.employee_name,'1' dev_type from gms_device_coll_outform cof " +
				"inner join gp_task_project tp on cof.project_info_no = tp.project_info_no and tp.bsflag='0' " +
				"left join gms_device_collmix_form mif on cof.device_mixinfo_id = mif.device_mixinfo_id " +
				"left join gms_device_collapp devapp on devapp.device_app_id = mif.device_app_id " +
				"left join gms_device_collbackapp cmf on cof.device_mixinfo_id = cmf.device_backapp_id " +
				"left join comm_human_employee e on cof.print_emp_id = e.employee_id and e.bsflag='0' " +
				"where cof.state = '9' and tp.project_id = '"+project_id+"'  " +
				"union all select devapp.device_app_id, devapp.device_app_name, dm.opr_state,dm.modifi_date as update_date,dm.device_mixinfo_id,dm.bsflag,he.employee_name,'2' dev_type from gms_device_mixinfo_form dm " +
				"inner join gms_device_appmix_main mi on dm.device_mixinfo_id = mi.device_mixinfo_id and mi.bsflag='0' " +
				"inner join gp_task_project tp on dm.project_info_no = tp.project_info_no and tp.bsflag='0' " +
				"left join gms_device_app devapp on dm.device_app_id = devapp.device_app_id " +
				"left join gms_device_collectinfo info on mi.dev_ci_code = info.device_id " +
				"left join comm_human_employee he on dm.print_emp_id = he.employee_id and he.bsflag='0' " +
				"where '1' = '1' and dm.state = '9' and (dm.mixform_type = '1' or dm.mixform_type = '3') and " +
				"dm.mix_type_id = 'S14050208' and tp.project_id = '"+project_id+"') where (opr_state<>'9'  or opr_state is null) ";
		if(!if_first.equals("true")){
			sql += " and update_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss') " ;
		}
			
		sql += " order by opr_state";
		
//		opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
//		JSONArray jsonArray = JSONArray.fromCollection(list);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		map.put("modifi_date",currentdate);
		JSONObject jsonObject = new JSONObject();
		
		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 批量设备待接收数据信息接口（上传）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadCollOutform(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String  infos = reqDTO.getValue("androidParam");
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd hh:mm:ss");
		
		JSONObject  object = JSONObject.fromObject(infos);
		JSONArray jsonArray11 = object.getJSONArray("piliang");
		
		if(jsonArray11.length()>0){
		for(int m =0;m<jsonArray11.length();m++){
			JSONObject object11 = jsonArray11.getJSONObject(m);
		
			String projectId = (String)object11.get("project_id");  //项目id
//			String dev_acc_id = (String)object11.get("dev_acc_id");	//设备编号
			String device_outinfo_id = (String)object11.get("device_outinfo_id"); //出库单主键ID
			String device_oif_subid = (String)object11.get("device_oif_subid");  //明细表的主键
			String out_num = (String)object11.get("out_num");	//转入数量
			if(out_num.equals("")){
				out_num = "0";
			}
			String state = object11.get("state").toString();  //验收状态  1:合格;0:不合格
			String dev_type = object11.get("dev_type").toString();	//1：采集设备    2：检波器
			String up_all = object11.get("up_all").toString();	//是否最后一次提交   0表示不是最后一次，1表示 最后一次
			System.out.println(up_all);
			System.out.println("---------------------------------------");
			String actual_in_time = (String)object11.get("actual_in_time");	//实际进场时间
			String note = (String)object11.get("memo");
			String device_app_id = (String)object11.get("device_app_id");  //判断receiveType
			String user_id = object11.get("user_id").toString();
			
		
				
			//0标示维修返还的数据
		    String receiveType = "0";
		    if(device_app_id!=null&&!device_app_id.equals("")&&!device_app_id.equals("null")){
		    	//1标示新到账的数据
		    	receiveType="1";
		    }
		    
		    
			String projectSql = "select t.project_info_no from gp_task_project t where t.bsflag='0' and t.project_id = '"+projectId+"'";
			Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
			if(projectMap!=null){
				String projectInfoNo = (String)projectMap.get("projectInfoNo");
					
				if(dev_type.equals("1")){
					String devSql = "select sub.dev_acc_id as subdevid, sub.device_id, sub.device_oif_subid,sub.team, sub.device_name," +
							"sub.device_model,sub.out_num,sub.unit_id,detail.coding_name as unit_name, teamsd.coding_name as team_name," +
							" form.in_org_id,form.out_org_id, dui.total_num,dui.unuse_num,dui.use_num,dui.dev_acc_id from " +
							"gms_device_coll_outsub sub left join comm_coding_sort_detail detail on sub.unit_id = detail.coding_code_id " +
							"left join comm_coding_sort_detail teamsd on sub.team = teamsd.coding_code_id " +
							"left join gms_device_coll_outform form on form.device_outinfo_id=sub.device_outinfo_id " +
							"left join comm_org_information inorg on form.in_org_id=inorg.org_id " +
							"left join comm_org_information outorg on form.out_org_id=outorg.org_id " +
							"left join gms_device_coll_account_dui dui on dui.fk_dev_acc_id=sub.dev_acc_id and dui.project_info_id='"+projectInfoNo+"' " +
							"where device_oif_subid='"+device_oif_subid+"'";
					
					Map<String,Object> devMap = jdbcDao.queryRecordBySQL(devSql);
					if(devMap!=null){
						String dev_acc_id = devMap.get("dev_acc_id")==null ? "" : (String)devMap.get("dev_acc_id");
						String dev_name = devMap.get("device_name")==null ? "" : (String)devMap.get("device_name");
						String dev_model = devMap.get("device_model")==null ? "" : (String)devMap.get("device_model");
						String dev_unit = devMap.get("unit_id")==null ? "" : (String)devMap.get("unit_id");
						String out_org_id = devMap.get("out_org_id")==null ? "" : (String)devMap.get("out_org_id");
						String in_org_id = devMap.get("in_org_id")==null ? "" : (String)devMap.get("in_org_id");
						String device_id = devMap.get("device_id")==null ? "" : (String)devMap.get("device_id");
						String fk_devaccId = devMap.get("subdevid")==null ? "" : (String)devMap.get("subdevid");
						String team = devMap.get("team")==null ? "" : (String)devMap.get("team");
						
						String total_num = devMap.get("total_num")==null ? "" : (String)devMap.get("total_num");
						String unuse_num = devMap.get("unuse_num")==null ? "" : (String)devMap.get("unuse_num");
						String use_num = devMap.get("use_num")==null ? "" : (String)devMap.get("use_num");
						if(total_num.equals("")){
							total_num = "0";
						}
						if(unuse_num.equals("")){
							unuse_num = "0";
						}
						if(use_num.equals("")){
							use_num = "0";
						}
						
						int new_total_num= 0;
						int new_unuse_num= 0;
						int new_use_num= 0;
						
						if(receiveType.equals("1")){
							new_total_num = Integer.parseInt(total_num)+Integer.parseInt(out_num);
							new_unuse_num = Integer.parseInt(unuse_num)+Integer.parseInt(out_num);
							new_use_num = Integer.parseInt(use_num);
						}else{
							new_total_num = Integer.parseInt(total_num);
							new_unuse_num = Integer.parseInt(unuse_num)+Integer.parseInt(out_num);
							if(use_num.equals("0")){
								new_use_num = Integer.parseInt(use_num);
							}else{
								new_use_num = Integer.parseInt(use_num)-Integer.parseInt(out_num);
							}
						}
						
						Map<String,Object> duiMap = new HashMap<String,Object>();
						if(dev_acc_id==null||"".equals(dev_acc_id)){
							duiMap.put("CREATOR", user_id);
							duiMap.put("CREATE_DATE", new Date());
						}else{
							duiMap.put("dev_acc_id", dev_acc_id);
						}
						duiMap.put("project_info_id", projectInfoNo);
						duiMap.put("dev_name", dev_name);
						duiMap.put("dev_model", dev_model);
						duiMap.put("dev_unit", dev_unit);
						
						duiMap.put("out_org_id", out_org_id);
						duiMap.put("in_org_id", in_org_id);
						
						duiMap.put("actual_in_time", actual_in_time);
						duiMap.put("is_leaving", "0");
						duiMap.put("device_id", device_id);
						duiMap.put("total_num", new_total_num);
						duiMap.put("unuse_num", new_unuse_num);
						duiMap.put("use_num", new_use_num);
						duiMap.put("fk_dev_acc_id", fk_devaccId);
						duiMap.put("dev_team", team);
						duiMap.put("BSFLAG", "0");
						duiMap.put("MODIFIER", user_id);
						duiMap.put("MODIFI_DATE", new Date());
						//jdbcDao.saveOrUpdateEntity(duiMap, "gms_device_coll_account_dui");
						if(dev_acc_id==null||"".equals(dev_acc_id)){
							Serializable keyid = jdbcDao.saveOrUpdateEntity(duiMap, "gms_device_coll_account_dui");
							dev_acc_id = keyid.toString();
						}else{
							jdbcDao.saveOrUpdateEntity(duiMap, "gms_device_coll_account_dui");
						}
						
						//添加备注
						Map<String,Object> Map_remark = new HashMap<String,Object>();
						Map_remark.put("FOREIGN_KEY_ID", device_oif_subid);
						Map_remark.put("NOTES", note);
						Map_remark.put("CREATOR", user_id);
						Map_remark.put("CREATE_DATE", new Date());
						Map_remark.put("UPDATOR", user_id);
						Map_remark.put("MODIFI_DATE", new Date());
						Map_remark.put("BSFLAG", "0");
						jdbcDao.saveOrUpdateEntity(Map_remark,"BGP_COMM_REMARK");
						
						
						//2.批量验收分批提交明细表
						Map<String,Object> recMap = new HashMap<String,Object>();
						recMap.put("RECEIVE_NUM", out_num);
						recMap.put("ACTUAL_IN_TIME", actual_in_time);
						recMap.put("RECEIVE_STATE", state);
						recMap.put("DEVICE_OIF_SUBID", device_oif_subid);
						recMap.put("PROJECT_INFO_NO", projectInfoNo);	
						recMap.put("CREATE_DATE", new Date());
						recMap.put("CREATOR_ID", user_id);	
						recMap.put("MODIFI_DATE", new Date());
						recMap.put("UPDATOR_ID", user_id);	
						recMap.put("BSFLAG", "0");
						jdbcDao.saveOrUpdateEntity(recMap, "GMS_DEVICE_COLL_ACCOUNT_REC");
					
						//2.队级台账动态表插入
						Map<String,Object> dymMap = new HashMap<String,Object>();
						dymMap.put("dev_acc_id", dev_acc_id);
						dymMap.put("opr_type", "1");
						dymMap.put("receive_num", out_num);
						dymMap.put("actual_in_time", actual_in_time);
						dymMap.put("create_date", new Date());
						dymMap.put("creator", user_id);	
						jdbcDao.saveOrUpdateEntity(dymMap, "gms_device_coll_account_dym");
						
						
						if(up_all.equals("1")){
						//3.明细设备接收状态改为已接收
							Map<String,Object> outsubMap = new HashMap<String, Object>();
							outsubMap.put("device_oif_subid",device_oif_subid);
							outsubMap.put("receive_state","1");
							jdbcDao.saveOrUpdateEntity(outsubMap, "gms_device_coll_outsub");
						}
						//4.修改公司级台账
						String colsql  ="select * from gms_device_coll_account " +
						"where dev_acc_id='"+fk_devaccId+"'";
						Map<String,Object> colMap = jdbcDao.queryRecordBySQL(colsql);
						if(colMap!=null){
							colMap.put("dev_acc_id",fk_devaccId);
							
							colMap.put("unuse_num",Integer.parseInt((String)colMap.get("unuse_num"))-Integer.parseInt(out_num));
							if(colMap.get("use_num").toString()==""){
								colMap.put("use_num",Integer.parseInt(out_num));
							}
							else{
								colMap.put("use_num",Integer.parseInt((String)colMap.get("use_num"))+Integer.parseInt(out_num));
							}
							jdbcDao.saveOrUpdateEntity(colMap, "gms_device_coll_account");
						}
						
						//2012-10-26 插入到公司级的采集设备动态表 GMS_DEVICE_COLL_DYMINFO
						Map<String,Object> duodymMap = new HashMap<String,Object>();
						duodymMap.put("dev_acc_id", fk_devaccId);
						duodymMap.put("oprtype", DevConstants.DYM_OPRTYPE_OUT);
						duodymMap.put("project_info_no",projectInfoNo);
						//出库单号
						duodymMap.put("device_appmix_id", device_outinfo_id);
						duodymMap.put("collnum", out_num);
						duodymMap.put("alter_date", actual_in_time);
						//此字段作用不大
						duodymMap.put("indb_date", currentdate);
						//基准时间，用于计算时间段进出库时间的
						duodymMap.put("format_date", DevConstants.DEV_FORMAT_DATE);	
						jdbcDao.saveOrUpdateEntity(duodymMap, "gms_device_coll_dym");
						//5.更改出库单主表的opr_state 2012-9-28
//						String outInfoId=msg.getValue("outInfoId");
						String updatesql1 = "update gms_device_coll_outform mif set opr_state='1' "+
											"where exists (select 1 from gms_device_coll_outsub dad "+ 
											"where dad.device_outinfo_id='"+device_outinfo_id+"' and dad.receive_state='1') "+
											"and exists(select 1 from gms_device_coll_outsub dad "+ 
											"where dad.device_outinfo_id='"+device_outinfo_id+"' and dad.receive_state='0') "+
											"and mif.device_outinfo_id = '"+device_outinfo_id+"' ";
						
						String updatesql2 = "update gms_device_coll_outform mif set opr_state='9' "+
											"where exists (select 1 from gms_device_coll_outsub dad "+ 
											"where dad.device_outinfo_id='"+device_outinfo_id+"' and dad.receive_state='1') "+
											"and not exists(select 1 from gms_device_coll_outsub dad "+ 
											"where dad.device_outinfo_id='"+device_outinfo_id+"' and dad.receive_state='0') "+
											"and mif.device_outinfo_id = '"+device_outinfo_id+"' ";
						
						jdbcDao.executeUpdate(updatesql1);
						jdbcDao.executeUpdate(updatesql2);
						//更新调配单的处理状态 2012-9-26 end
						//回写成功消息
					}
			}else if(dev_type.equals("2")){
				String devSql = "select t.dev_ci_code as device_id,dui.dev_acc_id,t.device_mix_subid,info.dev_name as dev_name," +
						"f.out_org_id as out_sub_id, info.dev_model as dev_type,det.coding_name,d.apply_num,t.assign_num,d.plan_start_date," +
						"d.plan_end_date,d.team as team_id,csd.coding_name as team_name,i.org_id as in_org_id,o.org_id as out_org_id," +
						"i.org_abbreviation as in_org_name,o.org_abbreviation as out_org_name,dui.total_num,dui.use_num,dui.unuse_num  " +
						"from gms_device_appmix_main t left join gms_device_app_detail d on t.device_app_detid=d.device_app_detid " +
						"left join comm_coding_sort_detail det on d.unitinfo=det.coding_code_id " +
						"left join gms_device_coll_account_dui dui on t.dev_ci_code=dui.device_id and dui.project_info_id='"+projectInfoNo+"' " +
						"left join comm_coding_sort_detail csd on d.team=csd.coding_code_id " +
						"left join gms_device_mixinfo_form f on t.device_mixinfo_id=f.device_mixinfo_id " +
						"left join comm_org_information i on f.in_org_id=i.org_id " +
						"left join comm_org_subjection sub on f.out_org_id=sub.org_subjection_id " +
						"left join comm_org_information o on sub.org_id=o.org_id " +
						"left join gms_device_collectinfo info on t.dev_ci_code=info.device_id where t.device_mix_subid='"+device_oif_subid+"'";
		
			Map<String,Object> devMap = jdbcDao.queryRecordBySQL(devSql);
			if(devMap!=null){
				String dev_name = devMap.get("dev_name")==null ? "" : (String)devMap.get("dev_name");
				String dev_model = devMap.get("dev_model")==null ? "" : (String)devMap.get("dev_model");
				String device_id = devMap.get("device_id")==null ? "" : (String)devMap.get("device_id");
				String in_org_id = devMap.get("in_org_id")==null ? "" : (String)devMap.get("in_org_id");
				String out_org_id = devMap.get("out_org_id")==null ? "" : (String)devMap.get("out_org_id");
				String out_sub_id = devMap.get("out_sub_id")==null ? "" : (String)devMap.get("out_sub_id");
				String team = devMap.get("team_id")==null ? "" : (String)devMap.get("team_id");
				
//				String fk_devaccId = devMap.get("subdevid")==null ? "" : (String)devMap.get("subdevid");
				String deviceId = devMap.get("dev_acc_id")==null ? "" : (String)devMap.get("dev_acc_id");
				
				String total_num = devMap.get("total_num")==null ? "" : (String)devMap.get("total_num");
				String unuse_num = devMap.get("unuse_num")==null ? "" : (String)devMap.get("unuse_num");
				String use_num = devMap.get("use_num")==null ? "" : (String)devMap.get("use_num");
				if(total_num.equals("")){
					total_num = "0";
				}
				if(unuse_num.equals("")){
					unuse_num = "0";
				}
				if(use_num.equals("")){
					use_num = "0";
				}
				
				int new_total_num= 0;
				int new_unuse_num= 0;
				int new_use_num= 0;
				receiveType = "1";		//默认
				if(receiveType.equals("1")){
					new_total_num = Integer.parseInt(total_num)+Integer.parseInt(out_num);
					new_unuse_num = Integer.parseInt(unuse_num)+Integer.parseInt(out_num);
					new_use_num = Integer.parseInt(use_num);
				}else{
					new_total_num = Integer.parseInt(total_num);
					new_unuse_num = Integer.parseInt(unuse_num)+Integer.parseInt(out_num);
					if(use_num.equals("0")){
						new_use_num = Integer.parseInt(use_num);
					}else{
						new_use_num = Integer.parseInt(use_num)-Integer.parseInt(out_num);
					}
				}
				
				
				//1.队级台账更新或插入
				Map<String,Object> duiMap = new HashMap<String,Object>();
				if(deviceId==null||"".equals(deviceId)){
					
				}else{
					duiMap.put("dev_acc_id", deviceId);
				}
				duiMap.put("project_info_id", projectInfoNo);
				duiMap.put("dev_name", dev_name);
				duiMap.put("dev_model", dev_model);
				duiMap.put("dev_unit", "5110000038000000011");
				duiMap.put("out_org_id", out_org_id);
				duiMap.put("in_org_id", in_org_id);
				duiMap.put("actual_in_time", actual_in_time);
				duiMap.put("is_leaving", "0");
				duiMap.put("device_id", device_id);
				duiMap.put("total_num", new_total_num);
				duiMap.put("unuse_num", new_unuse_num);
				duiMap.put("use_num", new_use_num);
//				duiMap.put("fk_dev_acc_id", fk_devaccId);
				duiMap.put("dev_team", team);
				
				duiMap.put("BSFLAG", "0");
				duiMap.put("CREATOR", user_id);
				duiMap.put("CREATE_DATE", new Date());
				duiMap.put("MODIFIER", user_id);
				duiMap.put("MODIFI_DATE", new Date());
				Serializable keyid =jdbcDao.saveOrUpdateEntity(duiMap, "gms_device_coll_account_dui");
				deviceId = keyid.toString();
				
				
				//添加备注
				Map<String,Object> Map_remark = new HashMap<String,Object>();
				Map_remark.put("FOREIGN_KEY_ID", device_oif_subid);
				Map_remark.put("NOTES", note);
				Map_remark.put("CREATOR", user_id);
				Map_remark.put("CREATE_DATE", new Date());
				Map_remark.put("UPDATOR", user_id);
				Map_remark.put("MODIFI_DATE", new Date());
				Map_remark.put("BSFLAG", "0");
				jdbcDao.saveOrUpdateEntity(Map_remark,"BGP_COMM_REMARK");
				
				
				//2.批量验收分批提交明细表
				Map<String,Object> recMap = new HashMap<String,Object>();
				recMap.put("RECEIVE_NUM", out_num);
				recMap.put("ACTUAL_IN_TIME", actual_in_time);
				recMap.put("RECEIVE_STATE", state);
				recMap.put("DEVICE_OIF_SUBID", device_oif_subid);
				recMap.put("PROJECT_INFO_NO", projectInfoNo);	
				recMap.put("CREATE_DATE", new Date());
				recMap.put("CREATOR_ID", user_id);	
				recMap.put("MODIFI_DATE", new Date());
				recMap.put("UPDATOR_ID", user_id);	
				recMap.put("BSFLAG", "0");
				jdbcDao.saveOrUpdateEntity(recMap, "GMS_DEVICE_COLL_ACCOUNT_REC");
				
				
				
				//2.队级台账动态表插入
				Map<String,Object> dymMap = new HashMap<String,Object>();
				dymMap.put("dev_acc_id", deviceId);
				dymMap.put("opr_type", "1");
				dymMap.put("receive_num", out_num);
				dymMap.put("actual_in_time", actual_in_time);
				dymMap.put("create_date", new Date());
				dymMap.put("creator", user_id);	
				jdbcDao.saveOrUpdateEntity(dymMap, "gms_device_coll_account_dym");
				
				if(up_all.equals("1")){
					//3.明细设备接收状态改为已接收
					Map<String,Object> outsubMap = new HashMap<String, Object>();
					outsubMap.put("device_mix_subid",device_oif_subid);
					outsubMap.put("state","9");
					jdbcDao.saveOrUpdateEntity(outsubMap, "gms_device_appmix_main");
				}
				
				//更新公司台帐数据
				String colsql  ="select * from gms_device_coll_account t where t.device_id='"+device_id+"' " +
						"and t.usage_sub_id like '"+out_sub_id+"%'";
				Map<String,Object> colMap = jdbcDao.queryRecordBySQL(colsql);
				colMap.put("dev_acc_id",colMap.get("dev_acc_id"));
				colMap.put("unuse_num",Double.valueOf((String)colMap.get("unuse_num"))-(Double.valueOf(out_num)));
				if(colMap.get("use_num").toString()==""){
					colMap.put("use_num",Double.valueOf("out_num"));
				}
				else{
					colMap.put("use_num",Double.valueOf((String)colMap.get("use_num"))+(Double.valueOf(out_num)));
				}
				jdbcDao.saveOrUpdateEntity(colMap, "gms_device_coll_account");
				//2012-10-26 插入到公司级的采集设备动态表 GMS_DEVICE_COLL_DYMINFO
				Map<String,Object> duodymMap = new HashMap<String,Object>();
				duodymMap.put("dev_acc_id", colMap.get("dev_acc_id"));
				duodymMap.put("oprtype", DevConstants.DYM_OPRTYPE_OUT);
				duodymMap.put("project_info_no",projectInfoNo);
				//出库单号
				duodymMap.put("device_appmix_id", device_outinfo_id);
				duodymMap.put("collnum", out_num);
				duodymMap.put("alter_date", actual_in_time);
				//此字段作用不大
				duodymMap.put("indb_date", new Date());
				//基准时间，用于计算时间段进出库时间的
				duodymMap.put("format_date", DevConstants.DEV_FORMAT_DATE);	
				jdbcDao.saveOrUpdateEntity(duodymMap, "gms_device_coll_dym");
				
				//5.更改出库单主表的opr_state 2012-9-28
				String updatesql1 = "update gms_device_mixinfo_form mif set opr_state='1' "+
									"where exists (select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"+device_outinfo_id+"' and m.state='9') "+
									"and exists(select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"+device_outinfo_id+"' and m.state is null) "+
									"and mif.device_mixinfo_id = '"+device_outinfo_id+"' ";
				
				String updatesql2 = "update gms_device_mixinfo_form mif set opr_state='9' "+
									"where exists (select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"+device_outinfo_id+"' and m.state='9') "+
									"and not exists(select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"+device_outinfo_id+"' and m.state is null) "+
									"and mif.device_mixinfo_id = '"+device_outinfo_id+"' ";
				
				jdbcDao.executeUpdate(updatesql1);
				jdbcDao.executeUpdate(updatesql2);
			}
			}
		}
		}
		}
		return reqMsg;
		
	}	
	
	/*
	 * 
	 * 基础信息数据信息接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadInformation(ISrvMsg reqDTO) throws Exception {
		String  projectId = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select t.project_info_no,t.project_id,t.project_name, d.org_id,r.EMPLOYEE_ID, r.EMPLOYEE_NAME " +
				"from gp_task_project t  inner join gp_task_project_dynamic d on t.project_info_no = d.project_info_no and d.bsflag = '0' " +
				"inner join view_human_project_relation r  on t.project_info_no = r.PROJECT_INFO_NO and r.actual_start_date is not null " +
				"and r.actual_end_date is null where t.bsflag = '0' and t.project_id = '"+projectId+"'";
		
		
//		JSONObject jsonObject =	JSONObject.fromBean(map);
//		JSONArray.fromJSONString(string);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		JSONArray jsonArray = JSONArray.fromCollection(list);
		
		reqMsg.setValue("deviceDatas", jsonArray.toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 地震队单台设备台账信息下载接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadAccountDui(ISrvMsg reqDTO) throws Exception {
		
		
		String  asd = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(asd);
		
		
		String project_id = object.get("project_id").toString();
		String if_first = object.get("if_first").toString();
		String receive_date = object.get("receive_date").toString();
		String modle_name = object.get("modle_name").toString();

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
//		String sql = "select t.dev_acc_id,t.project_info_id,t.dev_name,t.self_num,t.license_num,t.dev_model,t.mix_type_id from gms_device_account_dui t" +
//				" inner join gp_task_project p on t.project_info_id = p.project_info_no  " +
//				"and p.bsflag = '0' where t.is_leaving = '0' and t.bsflag='0' and p.project_id='"+projectId+"'";
		//批量返还的时候用到t.mix_type_id = S1405
		
		String sql = "select * from (select t.dev_acc_id,t.dev_name,t.license_num,t.self_num,t.dev_model,t.dev_sign,t.actual_in_time, " +
		"oprtbl.operator_name as alloprinfo, m.plan_date,t.bsflag ,t.mix_type_id,t.dev_type,t.dev_team,t.modifi_date, row_number() over(partition by t.dev_acc_id order by m.plan_date asc) asd " +
		"from gms_device_account_dui t left join GMS_DEVICE_MAINTENANCE_PLAN m  on t.dev_acc_id = m.dev_acc_id and m.plan_date>sysdate " +
		"inner join gp_task_project p on t.project_info_id = p.project_info_no  " +
		"left join (select device_account_id,operator_name from ( select tmp.device_account_id,tmp.operator_name," +
		"row_number() over(partition by device_account_id order by length(operator_name) desc ) as seq " +
		"from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name " +
		"from gms_device_equipment_operator where bsflag='0' ) tmp ) tmp2 where tmp2.seq=1) oprtbl on t.dev_acc_id = oprtbl.device_account_id " +
		"where  p.project_id='"+project_id+"' and t.actual_out_time is null and (t.dev_type like 'S0601%' or t.dev_type like 'S0622%' or t.dev_type like 'S0623%'" +
		" or t.dev_type like 'S07010101%' or t.dev_type like 'S070301%' or t.dev_type like 'S0801%' or t.dev_type like 'S0802%' " +
		"or t.dev_type like 'S0803%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S080504%' " +
		"or t.dev_type like 'S080601%' or t.dev_type like 'S080604%' or t.dev_type like 'S080607%' or t.dev_type like 'S090101%') ) where asd = 1";
		if(!if_first.equals("true")){
			sql += " and (modifi_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss') or plan_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss'))";
		}
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
//		JSONArray jsonArray = JSONArray.fromCollection(list);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		map.put("modifi_date",currentdate);
		JSONObject jsonObject = new JSONObject();

		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 地震队物资下载接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadWzInformationDui(ISrvMsg reqDTO) throws Exception {
		String  infos = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(infos);
		
		String project_id = object.get("project_id").toString();

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String sql = "select * from (select aa.wz_id, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, " +
				"i.coding_code_id, i.wz_name, i.wz_prickie, i.wz_price,1 wz_type from (select tid.wz_id, sum(tid.mat_num) mat_num " +
				"from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' " +
				"inner join gp_task_project gp on mti.project_info_no = gp.project_info_no and gp.bsflag='0'" +
				"where mti.bsflag = '0' and mti.invoices_type <> '2' and mti.invoices_type <> '1' and gp.project_id = '"+project_id+"' " +
				"and mti.if_input = '0' and mti.invoices_type <> '2' group by tid.wz_id) aa left join (select tod.wz_id, sum(tod.mat_num) out_num " +
				"from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' " +
				"inner join gp_task_project gp on mto.project_info_no = gp.project_info_no and gp.bsflag='0'" +
				"where mto.bsflag = '0' and mto.wz_type = '0' and gp.project_id = '"+project_id+"' group by tod.wz_id) bb on aa.wz_id = bb.wz_id " +
				"inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0' " +
				"union all  " +
				"(select aa.wz_id, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, i.coding_code_id, i.wz_name, i.wz_prickie, i.wz_price,2 wz_type " +
				"from (select tid.wz_id, sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' " +
				"inner join gp_task_project gp on mti.project_info_no = gp.project_info_no and gp.bsflag='0'" +
				"where mti.bsflag = '0' and gp.project_id = '"+project_id+"' and mti.invoices_type = '2' and mti.if_input = '0' " +
				"group by tid.wz_id) aa left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto " +
				"inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' " +
				"inner join gp_task_project gp on mto.project_info_no = gp.project_info_no and gp.bsflag='0'" +
				"where mto.bsflag = '0' and mto.wz_type = '1' and gp.project_id = '"+project_id+"' " +
				"group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') " +
				"union all " +
				"(select aa.wz_id, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, i.coding_code_id, i.wz_name, i.wz_prickie, round((aa.in_price - case when bb.out_price is null then 0 else  bb.out_price end) / case when (aa.mat_num - case when bb.out_num is null then 0  else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) = 0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end, 3) avg_price,3 wz_type " +
				"from (select tid.wz_id, sum(tid.mat_num) mat_num, sum(nvl(tid.actual_price, 0) * nvl(tid.mat_num, 0)) in_price " +
				"from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id  and tid.bsflag = '0' " +
				"inner join gp_task_project gp on mti.project_info_no = gp.project_info_no and gp.bsflag='0'" +
				"where mti.bsflag = '0' and mti.invoices_type = '1' and gp.project_id = '"+project_id+"' and mti.if_input = '0' " +
				"group by tid.wz_id) aa left join (select tod.wz_id, sum(tod.mat_num) out_num, sum(nvl(tod.actual_price, 0) * nvl(tod.mat_num, 0)) out_price " +
				"from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' " +
				"inner join gp_task_project gp on mto.project_info_no = gp.project_info_no and gp.bsflag='0'" +
				"where mto.bsflag = '0' and mto.wz_type = '2' and gp.project_id = '"+project_id+"' group by tod.wz_id) bb on aa.wz_id = bb.wz_id " +
				"inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0')) tt where  tt.stock_num>0";
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		JSONObject jsonObject = new JSONObject();

		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 项目信息（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadProjectInfo(ISrvMsg reqDTO) throws Exception {
		
		
		String  asd = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(asd);
		
		
		String type = object.get("type").toString();	//1 项目名称 2项目编号 
		String name = object.get("name").toString();

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String sql = "select t.project_id,t.project_name from gp_task_project t where t.bsflag='0' " ;
		if(type.equals("1")){
			sql += "  and t.project_name='"+name+"'";
		}else if(type.equals("2")){
			sql += " and  t.project_id = '"+name+"'";	
		}
		
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		JSONObject jsonObject = new JSONObject();

		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 地震队设备定人顶机下载接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadAccountDuiEmployee(ISrvMsg reqDTO) throws Exception {
		String  infos = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(infos);
		
		String project_id = object.get("project_id").toString();

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String sql = "select op.device_account_id,op.operator_id,op.operator_name from gms_device_account_dui t"+   
					" inner join gp_task_project p on t.project_info_id = p.project_info_no "+   
					" inner join GMS_DEVICE_EQUIPMENT_OPERATOR op on op.device_account_id = t.dev_acc_id"+
					" where  p.project_id='"+project_id+"' and (t.dev_type like 'S0601%' or t.dev_type like 'S0622%' or t.dev_type like 'S0623%' "+
					" or t.dev_type like 'S07010101%' or t.dev_type like 'S070301%' or t.dev_type like 'S0801%' or t.dev_type like 'S0802%'  "+
					" or t.dev_type like 'S0803%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S080504%'  "+
					" or t.dev_type like 'S080601%' or t.dev_type like 'S080604%' or t.dev_type like 'S080607%' or t.dev_type like 'S090101%') ";
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		JSONObject jsonObject = new JSONObject();

		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 单台设备保养计划下载接口（下载）------设备保养计划表
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadMaintenancePlan(ISrvMsg reqDTO) throws Exception {
		String  projectId = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
//		String sql = "select t.maintenance_id,t.dev_acc_id,t.plan_date,d.wz_id,d.mat_num,i.wz_name from GMS_DEVICE_MAINTENANCE_PLAN t " +
//				"inner join gms_mat_teammat_out o on t.dev_acc_id = o.dev_acc_id " +
//				"inner join gms_mat_teammat_out_detail d on o.teammat_out_id=d.teammat_out_id and d.bsflag='0' " +
//				"inner join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag='0' " +
//				"inner join gp_task_project p on o.project_info_no = p.project_info_no and p.bsflag = '0' " +
//				"where o.bsflag = '0' and o.use_type = '5110000044000000005' and p.project_id = '"+projectId+"'";
		
		//最新一条的保养时间
		String sql = "select * from (select m.maintenance_id, m.dev_acc_id, m.plan_date, " +
				"row_number() over(partition by m.dev_acc_id order by m.plan_date desc) asd " +
				"from gms_device_account_dui t inner join GMS_DEVICE_MAINTENANCE_PLAN m on t.dev_acc_id = m.dev_acc_id and t.bsflag = '0' " +
				"inner join gp_task_project p on t.project_info_id = p.project_info_no and p.bsflag = '0' where p.project_id = '"+projectId+"') cc " +
				"where cc.asd = '1' order by cc.dev_acc_id";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
//		JSONArray jsonArray = JSONArray.fromCollection(list);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		map.put("modifi_date",currentdate);
		JSONObject jsonObject = new JSONObject();
		
		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 单台设备保养物资信息（下载）------
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadDeviceMat(ISrvMsg reqDTO) throws Exception {
		String  projectId = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//小队设备对应的保养物资
		String sql = "select MAIN.PROCURE_NO AS TEAMMAT_OUT_ID, BASE.WZ_NAME, sub.use_info_detail, SUB.WZ_ID, SUB.APP_NUM AS USE_NUM,main.dev_acc_id " +
				"from GMS_MAT_TEAMMAT_OUT MAIN inner join gp_task_project p on main.project_info_no = p.project_info_no and p.bsflag = '0' " +
				"LEFT JOIN GMS_MAT_DEVICE_USE_INFO_DETAIL SUB ON MAIN.TEAMMAT_OUT_ID = SUB.TEAMMAT_OUT_ID " +
				"LEFT JOIN gms_mat_infomation BASE ON SUB.WZ_ID = BASE.WZ_ID WHERE MAIN.BSFLAG = '0' AND SUB.BSFLAG = '0' AND BASE.BSFLAG = '0' " +
				"and p.project_id = '"+projectId+"' and sub.dev_use is null " +
				"union select t.PROCURE_NO AS TEAMMAT_OUT_ID, i.WZ_NAME, d.out_detail_id as use_info_detail, d.WZ_ID, d.mat_num as use_num,t.dev_acc_id " +
				"from gms_mat_teammat_out t inner join gp_task_project p2 on t.project_info_no = p2.project_info_no and p2.bsflag = '0' " +
				"left join gms_mat_teammat_out_detail d on t.teammat_out_id = d.teammat_out_id and d.bsflag = '0' " +
				"left join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag = '0' where t.bsflag = '0' and p2.project_id = '"+projectId+"' " +
				"and t.use_type = '5110000044000000005' and d.out_detail_id not in (select nvl(repdet.material_spec, '0') " +
				"from bgp_comm_device_repair_info info left join bgp_comm_device_repair_detail repdet on info.repair_info = repdet.repair_info " +
				"where info.device_account_id = t.dev_acc_id)";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		JSONArray jsonArray = JSONArray.fromCollection(list);
		
		
		reqMsg.setValue("deviceDatas", jsonArray.toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 单台设备保养计划上传接口（上传）------设备保养计划表
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadMaintenancePlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String  infos = reqDTO.getValue("androidParam");

		JSONObject  object11 = JSONObject.fromObject(infos);
//		JSONArray jsonArray11 = object.getJSONArray("baoyang");
		
//		if(jsonArray11.length()>0){
//		for(int m =0;m<jsonArray11.length();m++){
//			JSONObject object11 = jsonArray11.getJSONObject(m);
			
			String dev_acc_id = object11.get("dev_acc_id").toString();  //设备ID
			String repair_start_date = object11.get("repair_start_date").toString();	//送修日期
			String repair_end_date = object11.get("repair_end_date").toString();       //竣工日期
			String repairer = object11.get("repairer").toString();	//承修人
			String repair_project = object11.get("repair_project").toString();  //保养类别
			String user_id = object11.get("user_id").toString() ;   //登录人ID
			String repair_type = object11.get("repair_project").toString();   //维修类别
//			String accepter = object11.get("accepter").toString();  //验收人
			String repair_detail = object11.get("maintenance_details").toString();   //保养详情
			
		
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
			
			Map map=new HashMap();
			map.put("DEVICE_ACCOUNT_ID", dev_acc_id);  //dev_acc_id
			map.put("REPAIR_TYPE", repair_type);
			map.put("REPAIR_ITEM", "0110000038000000015");
			map.put("REPAIR_START_DATE", repair_start_date);
			map.put("REPAIR_END_DATE", repair_end_date);
			map.put("REPAIRER", repairer);
			map.put("ACCEPTER", repairer);
			map.put("CREATOR", user_id);
			map.put("CREATE_DATE", new Date());
			map.put("UPDATOR", user_id);
			map.put("MODIFI_DATE", new Date());
			map.put("REPAIR_DETAIL", repair_detail);
			
			String mk=(String) jdbcDao.saveOrUpdateEntity(map, "BGP_COMM_DEVICE_REPAIR_INFO");
			
	//		if("0110000038000000015".equals(isrvmsg.getValue("repairItem"))){
			Map map2=new HashMap();
			map2.put("NEXT_MAINTAIN_DATE",repair_start_date);
			map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
			jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_MAINTAIN");  // 此表无注释，不知道为什么插入数据
	//		}
		
			JSONArray jsonArray22 = object11.getJSONArray("wzList"); //保养所用物资列表
			if(jsonArray22.length()>0){
				for(int n =0;n<jsonArray22.length();n++){
					JSONObject object22 = jsonArray22.getJSONObject(n);
//					String wz_name = object22.get("wz_name").toString();
					String wz_id = object22.get("wz_id").toString();
					String use_num = object22.get("wz_num").toString();
					
					
					String sqlWzName = "select t.wz_name from gms_mat_infomation t where t.wz_id='"+wz_id+"' and t.bsflag='0'";
					Map mapWzName = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlWzName);
					if(mapWzName!=null){
						String wz_name = (String)mapWzName.get("wzName");
					
					Map map1=new HashMap();
					map1.put("REPAIR_INFO", mk);
					map1.put("CREATOR", user_id);
					map1.put("CREATE_DATE", new Date());
					map1.put("UPDATOR", user_id);
					map1.put("MODIFI_DATE", new Date());
					
	//				map1.put("teammat_out_id", isrvmsg.getValue("teammat_out_id"+rows.get(i)));//计划单号
	//				map1.put("MATERIAL_SPEC", isrvmsg.getValue("use_info_detail"+rows.get(i)));//消耗的材料主键
					map1.put("MATERIAL_NAME", wz_name);//材料名称
					map1.put("MATERIAL_CODING", wz_id);//材料编号
					map1.put("OUT_NUM", use_num);//出库数量
	//				map1.put("UNIT_PRICE", isrvmsg.getValue("wz_price"+rows.get(i)));//单价
	//				map1.put("MATERIAL_AMOUT", isrvmsg.getValue("asign_num"+rows.get(i)));//消耗数量
	//				map1.put("TOTAL_CHARGE", isrvmsg.getValue("total_charge"+rows.get(i)));//总价
					
					//物资子表
					jdbcDao.saveOrUpdateEntity(map1, "BGP_COMM_DEVICE_REPAIR_DETAIL");
					}
				}
			}
			
			JSONArray jsonArray33 = object11.getJSONArray("repairList"); //保养项目列表
			if(jsonArray33.length()>0){
				for(int n =0;n<jsonArray33.length();n++){
					JSONObject object33 = jsonArray33.getJSONObject(n);
					String type_id = object33.get("xm_id").toString();
					
					Map map1=new HashMap();
					map1.put("REPAIR_INFO", mk);
					map1.put("CREATOR_ID", user_id);
					map1.put("CREATE_DATE", new Date());
					map1.put("UPDATOR_ID", user_id);
					map1.put("MODIFI_DATE", new Date());
					
					map1.put("BSFLAG", "0");
					map1.put("TYPE_ID", type_id);//保养项目编码
					
					//设备保养项目列表
					jdbcDao.saveOrUpdateEntity(map1, "BGP_COMM_DEVICE_REPAIR_TYPE");
				}
			}
			
//		if(isrvmsg.getValue("repairType").toString().equals("0110000037000000002")){
			//插入下一次的计划保养日期
			//查询计划结束时间和保养周期
			String querysql = "select t.planning_out_time,d.coding_name as maintenance_cycle,p.maintenance_cycle as cycle_id from gms_device_account_dui t"+
			" left join (gms_device_maintenance_plan p left join comm_coding_sort_detail d on p.maintenance_cycle=d.coding_code_id)"+
			" on t.dev_acc_id=p.dev_acc_id where t.dev_acc_id='"+dev_acc_id+"' group by t.planning_out_time,d.coding_name,p.maintenance_cycle";
			Map querymap = jdbcDao.queryRecordBySQL(querysql);
			//查询实际保养次数
			String getsql = "select count(*) as repair_num from BGP_COMM_DEVICE_REPAIR_INFO info where info.device_account_id='"+dev_acc_id+"' and info.bsflag='0'";
			Map getmap = jdbcDao.queryRecordBySQL(getsql);
			int repair_num = Integer.parseInt(getmap.get("repair_num").toString())+1; 
			//删除本次保养之后的计划
			String dletesql = "delete from gms_device_maintenance_plan p where p.dev_acc_id='"+dev_acc_id+"' and p.plan_num>'"+repair_num+"' ";
			jdbcDao.executeUpdate(dletesql);
			//插入新的本次保养之后的保养计划
			int cyclevalue = Integer.parseInt("".equals(querymap.get("maintenance_cycle").toString())?"0":querymap.get("maintenance_cycle").toString());
			Date date=sdf.parse(repair_start_date);//实际保养时间
			Date planning_out_time=sdf.parse(querymap.get("planning_out_time").toString());//实际保养时间
			Date d=date;
			d=DateUtils.addDays(d, cyclevalue);
			if(cyclevalue>0){
				int i=1;
				for(;d.before(planning_out_time);){
					System.out.println(sdf.format(d));
					Map<String,Object> Map_Maint = new HashMap<String,Object>();
					Map_Maint.put("dev_acc_id", dev_acc_id);
					Map_Maint.put("actual_time", date);
					Map_Maint.put("last_maintenance_time", date);
					Map_Maint.put("maintenance_cycle", querymap.get("cycle_id"));
					Map_Maint.put("planning_out_time",querymap.get("planning_out_time"));
					Map_Maint.put("plan_date",sdf.format(d));
					Map_Maint.put("plan_num",repair_num+i);
					jdbcDao.saveOrUpdateEntity(Map_Maint,"gms_device_maintenance_plan");
					d=DateUtils.addDays(d, cyclevalue);
					i++;
				}
			}
//		}
//		}
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 单台设备维修物资信息（下载）------
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadDeviceMatFix(ISrvMsg reqDTO) throws Exception {
		String  projectId = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//小队设备对应的保养物资
		String sql = "select MAIN.PROCURE_NO AS TEAMMAT_OUT_ID, BASE.WZ_NAME, sub.use_info_detail, SUB.WZ_ID, SUB.APP_NUM AS USE_NUM,main.dev_acc_id " +
				"from GMS_MAT_TEAMMAT_OUT MAIN inner join gp_task_project p on main.project_info_no = p.project_info_no and p.bsflag = '0' " +
				"LEFT JOIN GMS_MAT_DEVICE_USE_INFO_DETAIL SUB ON MAIN.TEAMMAT_OUT_ID = SUB.TEAMMAT_OUT_ID " +
				"LEFT JOIN gms_mat_infomation BASE ON SUB.WZ_ID = BASE.WZ_ID WHERE MAIN.BSFLAG = '0' AND SUB.BSFLAG = '0' AND BASE.BSFLAG = '0' " +
				"and p.project_id = '"+projectId+"' and sub.dev_use is null " +
				"union select t.PROCURE_NO AS TEAMMAT_OUT_ID, i.WZ_NAME, d.out_detail_id as use_info_detail, d.WZ_ID, d.mat_num as use_num,t.dev_acc_id " +
				"from gms_mat_teammat_out t inner join gp_task_project p2 on t.project_info_no = p2.project_info_no and p2.bsflag = '0' " +
				"left join gms_mat_teammat_out_detail d on t.teammat_out_id = d.teammat_out_id and d.bsflag = '0' " +
				"left join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag = '0' where t.bsflag = '0' and p2.project_id = '"+projectId+"' " +
				"and t.use_type = '5110000044000000006' and d.out_detail_id not in (select nvl(repdet.material_spec, '0') " +
				"from bgp_comm_device_repair_info info left join bgp_comm_device_repair_detail repdet on info.repair_info = repdet.repair_info " +
				"where info.device_account_id = t.dev_acc_id)";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		JSONArray jsonArray = JSONArray.fromCollection(list);
		
		
		reqMsg.setValue("deviceDatas", jsonArray.toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 单台设备维修上传接口（上传）------设备维修
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadDeviceMatFix(ISrvMsg reqDTO) throws Exception {
		String  infos = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		JSONObject  object11 = JSONObject.fromObject(infos);
//		JSONArray jsonArray11 = object.getJSONArray("weixiu");
//		
//		if(jsonArray11.length()>0){
//		for(int m =0;m<jsonArray11.length();m++){
//			JSONObject object11 = jsonArray11.getJSONObject(m);
			
			String dev_acc_id = object11.get("dev_acc_id").toString();  //设备ID
			String repair_start_date = object11.get("repair_start_date").toString();	//送修日期
			String repair_end_date = object11.get("repair_end_date").toString();       //竣工日期
			String repairer = (String)object11.get("repairer");	//承修人
			String accepter = (String)object11.get("accepter");   //验收人
			String user_id = (String)object11.get("user_id"); // 登录人的人员主键
			String repair_type = object11.get("repair_type").toString();   //维修类别
			
			String repair_detail = object11.get("repair_details").toString();   //维修详情
			
			JSONArray jsonArray22 = object11.getJSONArray("repair_item_list"); //保养所用物资列表
			if(jsonArray22.length()>0){
				for(int n =0;n<jsonArray22.length();n++){
					JSONObject object22 = jsonArray22.getJSONObject(n);
			
					String repair_item = (String)object22.get("repair_item");	//修理项目
		
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
					
					Map map=new HashMap();
					map.put("DEVICE_ACCOUNT_ID", dev_acc_id);  //dev_acc_id
					map.put("REPAIR_TYPE", repair_type);
					map.put("REPAIR_ITEM", repair_item);
					map.put("REPAIR_START_DATE", repair_start_date);
					map.put("REPAIR_END_DATE", repair_end_date);
					map.put("REPAIRER", repairer);
					map.put("ACCEPTER", accepter);
					map.put("CREATOR", user_id);
					map.put("CREATE_DATE", new Date());
					map.put("UPDATOR", user_id);
					map.put("MODIFI_DATE", new Date());
					map.put("REPAIR_DETAIL", repair_detail);
					
					String mk=(String) jdbcDao.saveOrUpdateEntity(map, "BGP_COMM_DEVICE_REPAIR_INFO");
					
					if("0110000038000000015".equals(repair_item)){
					Map map2=new HashMap();
					map2.put("NEXT_MAINTAIN_DATE",repair_start_date);
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_MAINTAIN");  // 此表无注释，不知道为什么插入数据
					}
				
					JSONArray jsonArray33 = object22.getJSONArray("wz_list");
					if(jsonArray33.length()>0){
						for(int k=0;k<jsonArray33.length();k++){
							JSONObject object33 = jsonArray33.getJSONObject(k);
//							String wz_name = object33.get("wz_name").toString();
							String wz_id = object33.get("wz_id").toString();
							String use_num = object33.get("wz_num").toString();
							String sqlWzName = "select t.wz_name from gms_mat_infomation t where t.wz_id='"+wz_id+"' and t.bsflag='0'";
							Map mapWzName = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlWzName);
							if(mapWzName!=null){
								String wz_name = (String)mapWzName.get("wzName");
				
								Map map1=new HashMap();
								map1.put("REPAIR_INFO", mk);
								map1.put("CREATOR", user_id);
								map1.put("CREATE_DATE", new Date());
								map1.put("UPDATOR", user_id);
								map1.put("MODIFI_DATE", new Date());
							
				//				map1.put("teammat_out_id", isrvmsg.getValue("teammat_out_id"+rows.get(i)));//计划单号
				//				map1.put("MATERIAL_SPEC", isrvmsg.getValue("use_info_detail"+rows.get(i)));//消耗的材料主键
								map1.put("MATERIAL_NAME", wz_name);//材料名称
								map1.put("MATERIAL_CODING", wz_id);//材料编号
								map1.put("OUT_NUM", use_num);//出库数量
				//				map1.put("UNIT_PRICE", isrvmsg.getValue("wz_price"+rows.get(i)));//单价
				//				map1.put("MATERIAL_AMOUT", isrvmsg.getValue("asign_num"+rows.get(i)));//消耗数量
				//				map1.put("TOTAL_CHARGE", isrvmsg.getValue("total_charge"+rows.get(i)));//总价
								
								//物资子表
								jdbcDao.saveOrUpdateEntity(map1, "BGP_COMM_DEVICE_REPAIR_DETAIL");
							}
						}
					}
				}
			}
//			}
//		}
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 油料编码下载
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadMatOil(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String  infos = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(infos);
		
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String if_first = object.get("if_first").toString();
		String receive_date = object.get("receive_date").toString();

		String sql = "select t.wz_id,t.wz_name from gms_mat_infomation t where t.bsflag='0' and t.wz_name like '车用汽油%' or t.wz_name like '轻柴油%' ";
		if(!if_first.equals("true")){
			sql += " and t.modifi_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss')";
		}
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		Map map = new HashMap();
		map.put("device_list",list);
		map.put("modifi_date",currentdate);
		JSONObject jsonObject = new JSONObject();
		
		System.out.println(jsonObject.fromBean(map).toString());
		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		return reqMsg;
	}
	
	
	/*
	 * 
	 * 单台设备油料消耗反馈接口
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadMatOil(ISrvMsg reqDTO) throws Exception {

		String  infos = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);


		JSONObject  object11 = JSONObject.fromObject(infos);
			
		String dev_acc_id = object11.get("dev_acc_id").toString();  //设备ID
		String project_id = (String)object11.get("project_id"); //项目ID
		String wz_id = (String)object11.get("wz_id"); //油料名称
		String oil_num = (String)object11.get("oil_num"); //油料消耗数量  (升)
		String outmat_date = (String)object11.get("outmat_date"); //消耗日期
		String mileage = object11.get("mileage").toString();   //里程表读数
		String work_hour = object11.get("work_hour").toString();  //发动机工作小时
//		String oil_from = (String)object11.get("oil_from"); //油料来源（0库房、1加油站）手持机默认为库房
//		String actual_price = (String)object11.get("actual_price"); //单价
		//出库类型out_type = ‘3 ‘ 
		String user_id = object11.get("user_id").toString();
				
		String wz_type = "";  //油料来源为油库的，物资类型为在帐
//		if(oil_from!=null&&oil_from.equals("0")){
//			wz_type = "0";
//		}
		
		//区分是汽油还是柴油，升和吨之间转换
		String mat_num = ""; 	//油料消耗数量  (吨)
		String sql_oil = "select t.wz_id,t.wz_name from gms_mat_infomation t where t.bsflag='0' and t.wz_id='"+wz_id+"'";
		Map map_oil = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql_oil);
		if(map_oil!=null){
			String wz_name = (String)map_oil.get("wzName");
			if(wz_name.indexOf("车用汽油")>-1){
				mat_num = ((Double.parseDouble(oil_num)*0.75/1000)*10000)/10000+"";
			}else{
				mat_num = ((Double.parseDouble(oil_num)*0.86/1000)*10000)/10000+"";
			}
		}
		
//		if(wz_id=="11000051822"||wz_id=="10001037161"||wz_id=="11004534305"||wz_id=="11000062340"||wz_id=="10000189078"){
//			mat_num = ((Double.parseDouble(oil_num)*0.75/1000)*10000)/10000+"";
//		}
//		else{
//			mat_num = ((Double.parseDouble(oil_num)*0.86/1000)*10000)/10000+"";
//		}
		
		String sqlPrice = "select t.wz_price from gms_mat_infomation t where t.wz_id='"+wz_id+"' and t.bsflag='0'";
		Map mapPrice = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlPrice);
		if(mapPrice!=null){
			String actual_price = mapPrice.get("wzPrice")==null ? "0" : (String)mapPrice.get("wzPrice");
			if(actual_price.equals("")){
				actual_price = "0";
			}
		
		String total_money = Double.parseDouble(oil_num)*Double.parseDouble(actual_price)+"";
		
		String projectSql = "select t.project_info_no from gp_task_project t where t.bsflag='0' and t.project_id = '"+project_id+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
			String projectInfoNo = (String)projectMap.get("projectInfoNo");
			
			//操作主表录入设备数据
			Map map = new HashMap();
			map.put("PROJECT_INFO_NO", projectInfoNo);
			map.put("total_money", total_money);
			map.put("oil_from", "0");
			map.put("outmat_date", outmat_date);
			map.put("out_type", "3");
			map.put("CREATOR_ID", user_id);
			map.put("CREATE_DATE", new Date());
			map.put("UPDATOR_ID", user_id);
			map.put("MODIFI_DATE", new Date());
			map.put("BSFLAG", "0");
			map.put("wz_type", "0");//油库加油，wz_type=0
			Serializable out_id = pureDao.saveOrUpdateEntity(map, "GMS_MAT_TEAMMAT_OUT");
			
			//操作从表录入油料
			Map tmap = new HashMap();
			tmap.put("TEAMMAT_OUT_ID", out_id);
			tmap.put("WZ_ID", wz_id);
			tmap.put("dev_acc_id", dev_acc_id);
			tmap.put("oil_num", oil_num);
			tmap.put("mat_num", mat_num);
			tmap.put("actual_price", actual_price);
			tmap.put("total_money", total_money);
			tmap.put("BSFLAG", "0");
			tmap.put("CREATOR_ID", user_id);
			tmap.put("CREATE_DATE", new Date());
			tmap.put("UPDATOR_ID", user_id);
			tmap.put("MODIFI_DATE", new Date());
			tmap.put("PROJECT_INFO_NO", projectInfoNo);
			Serializable detail_id = pureDao.saveOrUpdateEntity(tmap, "GMS_MAT_TEAMMAT_OUT_DETAIL");
			
//			//地震队物资入库清单明细
//			if(oil_from.equals("1")){
//				Map inmap = new HashMap();
//				inmap.put("INVOICES_ID", detail_id);
//				inmap.put("WZ_ID", wz_id);
//				inmap.put("mat_num", mat_num);
//				inmap.put("actual_price", actual_price);
//				inmap.put("total_money", total_money);
//				inmap.put("INPUT_TYPE", "2");
//				inmap.put("BSFLAG", "0");
//				inmap.put("CREATOR_ID", user_id);
//				inmap.put("CREATE_DATE", new Date());
//				inmap.put("UPDATOR_ID", user_id);
//				inmap.put("MODIFI_DATE", new Date());
//				inmap.put("PROJECT_INFO_NO", projectInfoNo);
//				pureDao.saveOrUpdateEntity(inmap, "GMS_MAT_TEAMMAT_INFO_DETAIL");
//			}
		}
		}
		
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd");
		
		StringBuffer sb = new StringBuffer().append("select * from (select nvl(info.mileage_total,0) as mileage_total from gms_device_operation_info info where  info.dev_acc_id='"+dev_acc_id+"' and info.modify_date<to_date('"+currentdate+"','YYYY-MM-DD') order by info.modify_date desc) where ROWNUM <= 1  ");
        Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
        float quan_total_sq=0;
        if(mainMap!=null && mainMap.get("mileage_total")!=null){
        	quan_total_sq = Float.parseFloat((String)mainMap.get("mileage_total"));
        }
        Number quan_total=0;
        if(mileage.equals(""))
        	quan_total = quan_total_sq;
        else {
        	quan_total = quan_total_sq+Float.parseFloat(mileage);
		}
		
		StringBuffer shijiansql = new StringBuffer().append("select * from (select nvl(info.work_hour_total,0) as work_hour_total from gms_device_operation_info info where  info.dev_acc_id='"+dev_acc_id+"' and info.modify_date<to_date('"+currentdate+"','YYYY-MM-DD') order by info.modify_date desc) where ROWNUM <= 1 ");
        Map shijianMap = jdbcDao.queryRecordBySQL(shijiansql.toString());
        float shijian_total_sq=0;
        if(shijianMap!=null && shijianMap.get("work_hour_total")!=null){
        	shijian_total_sq = Float.parseFloat((String)shijianMap.get("work_hour_total"));
        }
        Number shijian_total=0;
        if(work_hour.equals(""))
		    shijian_total = shijian_total_sq;
        else {
        	shijian_total = shijian_total_sq+Float.parseFloat(work_hour);
		}
		
		Map map=new HashMap();
		map.put("dev_acc_id", dev_acc_id);
		
		map.put("mileage", mileage);
//		map.put("drilling_footage", drilling_footage);
		map.put("work_hour", work_hour);
		map.put("modify_date", currentdate);
		map.put("mileage_total", quan_total);
//		map.put("drilling_footage_total", zc_total);
		map.put("work_hour_total", shijian_total);
		jdbcDao.saveOrUpdateEntity(map, "gms_device_operation_info");
		
		if(!mileage.equals("")){
			String updateSql = "update gms_device_operation_info info set info.mileage_total = info.mileage_total+"+mileage+" where info.dev_acc_id='"+dev_acc_id+"' and to_char(info.modify_date,'YYYY-MM-DD') > '"+currentdate+"' ";
			jdbcDao.executeUpdate(updateSql);
		}
//		if(!isrvmsg.getValue("drilling_footage").equals("")){
//			String updateSql2 = "update gms_device_operation_info info set info.drilling_footage_total = info.drilling_footage_total+"+isrvmsg.getValue("drilling_footage")+" where info.dev_acc_id='"+isrvmsg.getValue("ids")+"' and to_char(info.modify_date,'YYYY-MM-DD') > '"+isrvmsg.getValue("modify_date")+"' ";
//			jdbcDao.executeUpdate(updateSql2);
//		}
		if(!work_hour.equals("")){
			String updateSql3 = "update gms_device_operation_info info set info.work_hour_total = info.work_hour_total+"+work_hour+" where info.dev_acc_id='"+dev_acc_id+"' and to_char(info.modify_date,'YYYY-MM-DD') > '"+currentdate+"' ";
			jdbcDao.executeUpdate(updateSql3);
		}
		
		
		
		return reqMsg;
	}
	
	
	/*
	 * 
	 * 单台设备返还接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadDeviceBack(ISrvMsg reqDTO) throws Exception {
		String  projectId = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//小队设备未返还设备 -------------mix_type_id 调配类型  S0000 物探处自有设备  ；S0623 专业化震源 ；S1404 专业化测量
		String sql = "select account.dev_acc_id, account.dev_name, account.self_num,account.dev_sign, account.dev_model ,account.mix_type_id, " +
				"account.license_num,account.actual_in_time,account.planning_out_time from gms_device_account_dui account inner join gp_task_project p on p.project_info_no = account.project_info_id and p.bsflag='0' " +
				"where p.project_id='"+projectId+"' and account.actual_out_time is null and " +
				"account.account_stat!='0110000013000000005' and (account.is_leaving='0' and account.mix_type_id in ('S0000','S0623','S1404')) " +
				"order by account.dev_type ";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		JSONArray jsonArray = JSONArray.fromCollection(list);
		reqMsg.setValue("deviceDatas", jsonArray.toString());
		
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 单台设备返还接口（上传）
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadDeviceBack(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);


		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
//		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		
		
		String  infos = reqDTO.getValue("androidParam");
		JSONObject  object11 = JSONObject.fromObject(infos);
		String project_id = object11.get("project_id").toString(); //项目ID
		String backapp_name = object11.get("backapp_name").toString();	//申请单名称
//		String user_name = object11.get("user_name").toString();   //验收人
		String back_date = object11.get("back_date").toString();   //验收日期
		
		String backdevtype = object11.get("backdevtype").toString();
//		String state = object11.get("state").toString();  //验收状态  1:合格;0:不合格
		String note = (String)object11.get("memo");				//备注
		String user_id = object11.get("user_id").toString();	//用户ID=验收人
		JSONArray jsonArray = object11.getJSONArray("dev_list"); //返还设备Lsit
		
//		if(state.equals("1")){		
		String projectSql = "select t.project_info_no from gp_task_project t where t.bsflag='0' and t.project_id = '"+project_id+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
			String projectInfoNo = (String)projectMap.get("projectInfoNo");
			
			String user_name = "";
			String userSql = "select e.employee_name from comm_human_employee e where e.employee_id='"+user_id+"' ";
			Map userMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(userSql);
			if(userMap!=null){
				user_name = (String)projectMap.get("employeeName");
			}
			
			String device_backapp_no = "返还申请"+today.replace("-","")+"0"+Math.round(Math.random()*1000);
			
			Map<String,Object> map = new HashMap<String,Object>();
//					map.put("device_backapp_id", );   主键
			map.put("device_backapp_no", device_backapp_no);
			map.put("BACKAPP_NAME", backapp_name);
			map.put("project_info_id", projectInfoNo);
//					map.put("back_org_id", );   user.getOrgId()
			map.put("backdate", back_date);
//					map.put("back_employee_id", ); user.getEmpId()
//					map.put("backmix_org_id", ); user.getOrgId();
			map.put("bsflag", "0");
			map.put("create_date", new Date());
			map.put("creator_id", user_id);
			map.put("modifi_date", new Date());
			map.put("updator_id", user_id);
//					map.put("org_id", );
//					map.put("org_subjection_id", );
			map.put("state", "9");
//					map.put("search_backapp_id", );
//					map.put("backapp_name", );
			map.put("backdevtype", backdevtype);
			map.put("backmix_username", user_name);
			
			String device_backapp_id = jdbcDao.saveOrUpdateEntity(map, "gms_device_backapp").toString();
			
			
			//添加备注
			Map<String,Object> Map_remark = new HashMap<String,Object>();
			Map_remark.put("FOREIGN_KEY_ID", device_backapp_id);
			Map_remark.put("NOTES", note);
			Map_remark.put("CREATOR", user_id);
			Map_remark.put("CREATE_DATE", new Date());
			Map_remark.put("UPDATOR", user_id);
			Map_remark.put("MODIFI_DATE", new Date());
			Map_remark.put("BSFLAG", "0");
			jdbcDao.saveOrUpdateEntity(Map_remark,"BGP_COMM_REMARK");
					
					
			//先删子表，在插入新的子表    手持机没有修改功能
//					jdbcDao.executeUpdate("delete from gms_device_backapp_detail where bsflag='0' and device_backapp_id='"+device_backapp_id+"' ");
			
			
			if(jsonArray.length()>0){
				List<Map<String,Object>> dataList = new ArrayList<Map<String,Object>>();
				for(int n =0;n<jsonArray.length();n++){
					JSONObject object22 = jsonArray.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号、
					String actual_out_time = object22.get("actual_out_time").toString(); //实际离场时间
				
				String devdetSql = "select account.dev_acc_id,account.asset_coding, ";
				devdetSql += "account.dev_coding,account.self_num,account.dev_sign, ";
				devdetSql += "account.license_num,account.planning_out_time,account.account_stat,account.fk_dev_acc_id ";
				devdetSql += "from gms_device_account_dui account ";
				devdetSql += "where account.dev_acc_id ='"+dev_acc_id+"' " ;
				devdetSql += "and account.project_info_id='"+projectInfoNo+"' ";
				Map<String,Object> datainfo = jdbcDao.queryRecordBySQL(devdetSql);
				String account_stat = datainfo.get("account_stat")==null?"":datainfo.get("account_stat").toString();	//资产状况
				
					String fk_dev_acc_id = datainfo.get("fk_dev_acc_id").toString();
					//2. 分别更新 队级台账、设备返还申请单、公司级台账、公司级台账动态信息
					Map<String,Object> dataMap = new HashMap<String,Object>();
					dataMap.put("dev_acc_id", dev_acc_id);
					dataMap.put("actual_out_time", actual_out_time);
					dataMap.put("is_leaving", "1");
					jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_account_dui");
					dataMap.remove("dev_acc_id");
					dataMap.put("dev_acc_id", fk_dev_acc_id);
					dataMap.put("bsflag", "0");
					jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_account");
					//2012-9-28 liujb 设备动态表插入离场时间，计算利用率
					Map<String,Object> wanhaoMap = new HashMap<String,Object>();
					wanhaoMap.put("dev_acc_id", fk_dev_acc_id);
					wanhaoMap.put("project_info_no", projectInfoNo);
					wanhaoMap.put("oprtype", DevConstants.DYM_OPRTYPE_IN);
					wanhaoMap.put("alter_date", actual_out_time);
					wanhaoMap.put("indb_date", actual_out_time);
					//2012-9-28 现在离场直接离场，不用开单子
					wanhaoMap.put("device_appmix_id", "");
					jdbcDao.saveOrUpdateEntity(wanhaoMap, "gms_device_dyminfo");
//					//更新动态表的离开项目字段，是实际的离场时间。
//					String getdyminfo = "select dev_dyminfo_id,dev_acc_id,project_info_no,oprtype,indb_date "
//						+"from gms_device_dyminfo where dev_acc_id='"+fk_dev_acc_id+"' "
//						+"and project_info_no='"+projectInfoNo+"' and oprtype='"+DevConstants.DYM_OPRTYPE_IN+"' and alter_date is null";
//					Map<String,Object> dymdataMap = jdbcDao.queryRecordBySQL(getdyminfo);
//					if(dymdataMap!=null){
//						dymdataMap.put("alter_date", actual_out_time);
//						dymdataMap.put("device_appmix_id", msg.getValue("devicebackappid"));
//						jdbcDao.saveOrUpdateEntity(dymdataMap, "gms_device_dyminfo");
//					}
					if(!account_stat.equals("0110000013000000005")){ //外租设备
						datainfo.remove("fk_dev_acc_id");
						datainfo.remove("account_stat");
						datainfo.put("device_backapp_id", device_backapp_id);
						//2013-02-01 作为实际的离场时间 --没有actual_out_time 字段，使用actual_in_time
						datainfo.put("actual_in_time", actual_out_time);
						datainfo.put("bsflag", "0");
						dataList.add(datainfo);
					}
				}
				
				//循环保存子表
				for(Map<String,Object> datamap : dataList){
					jdbcDao.saveOrUpdateEntity(datamap, "gms_device_backapp_detail");
				}
			}
				
//		}
		}

		return reqMsg;
	}
	
	/*
	 * 
	 * 批量设备返还接口（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadDeviceCollBack(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String  asd = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(asd);
		
		String project_id = object.get("project_id").toString();
		
		String sql = "select account.dev_acc_id, account.dev_name, account.dev_model, account.total_num, account.unuse_num, account.device_id, " +
				"unitsd.coding_name as unit_name, case when  substr(info.dev_code, 0, 2) = '01' then '1' when substr(info.dev_code, 0, 2) = '02' " +
				"then '1' when substr(info.dev_code, 0, 2) = '03' then '1' when substr(info.dev_code, 0, 2) = '04' then '2' end dev_type,nvl(account.bsflag, 0) bsflag from " +
				"gms_device_coll_account_dui account inner join gp_task_project p on account.project_info_id=p.project_info_no and p.bsflag='0' " +
				"left join gms_device_collectinfo info on info.device_id = account.device_id " +
				"left join comm_coding_sort_detail unitsd on account.dev_unit = unitsd.coding_code_id  where (substr(info.dev_code, 0, 2) = '01' " +
				"or substr(info.dev_code, 0, 2) = '02' or substr(info.dev_code, 0, 2) = '03' or substr(info.dev_code, 0, 2) = '04') and " +
				" p.project_id = '"+project_id+"' and " +
				"(account.is_leaving is null or account.is_leaving = '0')";
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map map = new HashMap();
		map.put("device_list",list);
		JSONObject jsonObject = new JSONObject();
		
		reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		
		return reqMsg;
	}	
	
	/*
	 * 
	 * 批量设备返还接口（上传）
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadDeviceCollBack(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		
		String  infos = reqDTO.getValue("androidParam");
		JSONObject  object11 = JSONObject.fromObject(infos);
		String project_id = object11.get("project_id").toString(); //项目ID
		String backapp_name = object11.get("backapp_name").toString();	//申请单名称
//		String user_name = object11.get("user_name").toString();   //验收人
		String back_date = object11.get("back_date").toString();   //验收日期
//		String actual_num = object11.get("actual_um").toString();  //实际数量     手持机中显示，不用传到后台
		
		String user_id = object11.get("user_id").toString(); //用户ID=验收人
		String dev_type = object11.get("dev_type").toString();   //判断是检波器还是采集设备 1：采集设备，2：检波器
		JSONArray jsonArray33 = object11.getJSONArray("dev_list"); //返还设备Lsit
		JSONArray jsonArray22 = object11.getJSONArray("dev_list_else"); //附属设备
		
		String backdevtype = "";
		if(dev_type.equals("1")){
			backdevtype = "S9000";
		}else if(dev_type.equals("2")){
			backdevtype = "S14050208";
		}
		
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
		String projectSql = "select t.project_info_no,t.project_type from gp_task_project t where t.bsflag='0' and t.project_id = '"+project_id+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
			String projectInfoNo = (String)projectMap.get("projectInfoNo");
			
			String user_name = "";
			String userSql = "select e.employee_name from comm_human_employee e where e.employee_id='"+user_id+"' ";
			Map userMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(userSql);
			if(userMap!=null){
				user_name = (String)userMap.get("employeeName");
			}
			
			String device_backapp_no = "返还申请"+today.replace("-","")+"0"+Math.round(Math.random()*1000);
			
			Map<String,Object> map = new HashMap<String,Object>();
			
			map.put("device_backapp_no", device_backapp_no);
			map.put("BACKAPP_NAME", backapp_name);
			map.put("project_info_id", projectInfoNo);
			map.put("backdate", back_date);
//					map.put("back_employee_id", ); user.getEmpId()
//					map.put("backmix_org_id", ); user.getOrgId();
			map.put("bsflag", "0");
			map.put("create_date", new Date());
			map.put("creator_id", user_id);
			map.put("modifi_date", new Date());
			map.put("updator_id", user_id);
//					map.put("org_id", );
//					map.put("org_subjection_id", );
			map.put("state", "9");
//					map.put("search_backapp_id", );
//					map.put("backapp_name", );
			map.put("backdevtype", backdevtype);    
			map.put("backmix_username", user_name);
			map.put("backapptype","1");
			String device_backapp_id = jdbcDao.saveOrUpdateEntity(map, "gms_device_collbackapp").toString();
			
			List<Map<String,Object>> dataList = new ArrayList<Map<String,Object>>();
			for(int n =0;n<jsonArray33.length();n++){
				JSONObject object33 = jsonArray33.getJSONObject(n);
				String dev_acc_id = object33.get("dev_acc_id").toString();	//设备编号
				String back_num = object33.get("back_num").toString();   //返还数量
				String acutal_out_time = object33.get("actual_out_time").toString(); //实际离场时间
				String note = object33.get("memo").toString();	//备注
				if(back_num.equals("")){
					back_num="0";
				}
			
				String devdetSql = "select account.dev_acc_id,account.is_leaving,";
				devdetSql += "account.dev_name,account.dev_model ";
				devdetSql += "from gms_device_coll_account_dui account ";
				devdetSql += "where account.dev_acc_id ='"+dev_acc_id+"' " ;
				devdetSql += "and account.project_info_id='"+projectInfoNo+"' ";
				Map<String,Object> datainfo = jdbcDao.queryRecordBySQL(devdetSql);
				//返还单ID
				datainfo.put("device_backapp_id", device_backapp_id);
				//删除标识
				datainfo.put("bsflag", "0");
//						//给数量信息从界面获得，并且放到MAP中
//						String linekey = lineinfos[index];
				//返还数量
				datainfo.put("back_num", back_num);
				//这一批的计划离场时间
				datainfo.put("planning_out_time", acutal_out_time);
				//返还明细备注
				datainfo.put("devremark", note);
				dataList.add(datainfo);
//					}
				
				//2.更新队级台账
				String searchsql  = "select dev_acc_id, unuse_num,use_num from gms_device_coll_account_dui "+
							"where dev_acc_id='"+dev_acc_id+"'";
				
				Map<String,Object> duiMap = jdbcDao.queryRecordBySQL(searchsql);
				String unuse_num = (String)duiMap.get("unuse_num");
				String use_num = (String)duiMap.get("use_num");
				duiMap.put("unuse_num", Integer.parseInt(unuse_num)-Integer.parseInt(back_num));
				duiMap.put("use_num", Integer.parseInt(use_num)+Integer.parseInt(back_num));
				if(Integer.parseInt(unuse_num)-Integer.parseInt(back_num)==0){
					duiMap.put("is_leaving",'1');
				}
				duiMap.put("actual_out_time", acutal_out_time);
				//保存主表信息
				jdbcDao.saveOrUpdateEntity(duiMap, "gms_device_coll_account_dui");
			}
			//循环保存子表
			for(Map<String,Object> datamap : dataList){
				String dfg = jdbcDao.saveOrUpdateEntity(datamap, "gms_device_collbackapp_detail").toString();
				
				//3.插入队级台账动态表
				Map<String,Object> duiDymMap = new HashMap<String,Object>();
				duiDymMap.put("opr_type", DevConstants.DYM_OPRTYPE_IN);
				duiDymMap.put("dev_acc_id", datamap.get("dev_acc_id"));
				duiDymMap.put("receive_num", datamap.get("back_num"));
				duiDymMap.put("actual_out_time", datamap.get("planning_out_time"));
				duiDymMap.put("create_date", new Date());
				duiDymMap.put("creator", user_id);
				duiDymMap.put("dev_dym_id", dfg);
				jdbcDao.saveEntity(duiDymMap, "gms_device_coll_account_dym");
			}
			
			if(jsonArray22.length()>0){
//				Map<String,Object> dev_map = new HashMap<String,Object>();
//				dev_map.put("device_backapp_id", device_backapp_id);
//				dev_map.put("device_backapp_no", device_backapp_no);
//				dev_map.put("project_info_id", projectInfoNo);
//				dev_map.put("backdate", back_date);
//				dev_map.put("bsflag", "0");
//				dev_map.put("create_date", new Date());
//				dev_map.put("creator_id", user_id);
//				dev_map.put("modifi_date", new Date());
//				dev_map.put("updator_id", user_id);
//				dev_map.put("state", "0");
//				dev_map.put("backdevtype", "S1405");
//				dev_map.put("backmix_username", user_name);
//				String device_backapp_id22 = jdbcDao.(map, "gms_device_backapp").toString();
				String sql = "insert into gms_device_backapp (device_backapp_id,device_backapp_no,project_info_id,backdate,bsflag," +
						"create_date,creator_id,modifi_date,updator_id,state,backdevtype,backmix_username) values " +
						"('"+device_backapp_id+"','"+device_backapp_no+"','"+projectInfoNo+"',to_date('"+back_date+"','yyyy-MM-dd'),'0'," +
						"to_date('"+today+"','yyyy-MM-dd hh24:mi:ss')," +
						"'"+user_id+"',to_date('"+today+"','yyyy-MM-dd hh24:mi:ss'),'"+user_id+"','0','S1405','"+user_name+"')";
				
				System.out.println(sql);
				
				jdbcDao.executeUpdate(sql);
			
				
				
				List<Map<String,Object>> dataList22 = new ArrayList<Map<String,Object>>();
				for(int n =0;n<jsonArray22.length();n++){
					JSONObject object22 = jsonArray22.getJSONObject(n);
					String dev_acc_id_else = object22.get("dev_acc_id_else").toString(); //附属设备ID
					String actual_out_time_else = object22.get("actual_out_time_else").toString(); //时间
					
					String devdetSql22 = "select account.dev_acc_id,account.asset_coding, ";
					devdetSql22 += "account.dev_coding,account.self_num,account.dev_sign, ";
					devdetSql22 += "account.license_num,account.planning_out_time ";
					devdetSql22 += "from gms_device_account_dui account ";
					devdetSql22 += "where account.dev_acc_id ='"+dev_acc_id_else+"' " ;
					devdetSql22 += "and account.project_info_id='"+projectInfoNo+"' ";
					Map<String,Object> datainfo22 = jdbcDao.queryRecordBySQL(devdetSql22);
					datainfo22.put("device_backapp_id", device_backapp_id);
					//2013-02-01 作为实际的离场时间 --没有actual_out_time 字段，使用actual_in_time
					datainfo22.put("actual_in_time", actual_out_time_else);
					datainfo22.put("bsflag", "0");
					dataList22.add(datainfo22);
					
					String devupdate = "update gms_device_account_dui dui set dui.actual_out_time=to_date('"+actual_out_time_else+"','yyyy-mm-dd') where dui.dev_acc_id='"+dev_acc_id_else+"'";
					jdbcDao.executeUpdate(devupdate);
				}
					
				//循环保存子表
				for(Map<String,Object> datamap : dataList22){
					jdbcDao.saveOrUpdateEntity(datamap, "gms_device_backapp_detail");
				}
			}
		}
					
		return reqMsg;
	}	
	
	
	/*
	 * 
	 * 项目登陆人员信息更新（下载）
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg downloadUserInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String  androidParam = reqDTO.getValue("androidParam");
		JSONObject  object = JSONObject.fromObject(androidParam);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		
		String project_id = object.get("project_id").toString();
		String if_first = object.get("if_first").toString();
		String receive_date = object.get("receive_date").toString();
		String modle_name = object.get("modle_name").toString();
		
		String projectSql = "select t.project_info_no from gp_task_project t where t.bsflag='0' and t.project_id = '"+project_id+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
		
			String sql = "select u.emp_id,u.login_id,u.user_name,u.user_pwd,u.bsflag from p_auth_user u inner join " +
					"comm_org_subjection os on u.org_id = os.org_id and os.bsflag = '0' where os.org_subjection_id like " +
					"(select d.org_subjection_id from gp_task_project p join gp_task_project_dynamic d on p.project_info_no = d.project_info_no " +
					"where p.project_id = '"+project_id+"'  and p.bsflag ='0' ) || '%'";
			if(!if_first.equals("true")){
				 sql += " and u.modifi_date > to_date('"+receive_date+"','yyyy-MM-dd hh24:mi:ss')";
			}
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					Map map = (Map)list.get(i);
					String user_pwd = (String)map.get("userPwd");
					String password = AppCrypt.decrypt(user_pwd);
					map.put("userPwd", password);
				}
			}
			
			Map map = new HashMap();
			map.put("device_list",list);
			map.put("modifi_date",currentdate);
			JSONObject jsonObject = new JSONObject();
			
	//		JSONArray jsonArray = JSONArray.fromCollection(list);
			reqMsg.setValue("deviceDatas", jsonObject.fromBean(map).toString());
		}
		return reqMsg;
	}	
	
	/*
	 * 
	 * 可控震源日常检查记录（上传）
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadDeviceInspection(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String  infos = reqDTO.getValue("androidParam");

		JSONObject  object = JSONObject.fromObject(infos);
		
		String dev_acc_id = object.get("dev_acc_id").toString();	//设备ID
//		String inspectioin_no = object.get("inspectioin_no").toString();  //检查记录号
//		String inspectioin_people = object.get("inspectioin_people") == null ? "" : object.get("inspectioin_people").toString();  //检查记录人
		String inspectioin_time = object.get("inspectioin_time").toString();	//检查记录时间
		String inspectioin_update_time = object.get("inspectioin_update_time").toString();//检查更新时间
//		String suggestion = object.get("suggestion").toString();	//整改意见
		String modification_content = object.get("modification_content").toString();	//整改内容
		String modification_people = object.get("modification_people").toString();	//整改人
		String modification_result = object.get("modification_result").toString();	//整改结果
		String modification_time = object.get("modification_time").toString();	//整改时间
		
		String type = object.get("type").toString();	//设备类型     1：可控震源 2：轻便钻机 3：运输车辆 4：车装钻机
		String project_id = object.get("project_id").toString();	//项目ID
		String user_id = object.get("user_id").toString();	//用户ID
		
		String oil_num = object.get("oil_num").toString();	//燃油加油量
		String work_hour = object.get("work_hour").toString();	//工作小时
		String drilling_num = object.get("drilling_num").toString();	//钻井进尺
		String mileage_write = object.get("mileage_write").toString();	//里程表读数
		String mileage_today = object.get("mileage_today").toString();	//当日里程
		
		
		String projectSql = "select t.project_info_no from gp_task_project t where t.bsflag='0' and t.project_id = '"+project_id+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
			String project_info_no = (String)projectMap.get("projectInfoNo");
			Map map=new HashMap();
//			map.put("INSPECTIOIN_NO", inspectioin_no);
//			map.put("INSPECTIOIN_PEOPLE", inspectioin_people);
			map.put("INSPECTIOIN_TIME", inspectioin_time);
			map.put("INSPECTIOIN_UPDATE_TIME", inspectioin_update_time);
			map.put("MODIFICATION_CONTENT", modification_content);
			map.put("MODIFICATION_PEOPLE", modification_people);
			map.put("MODIFICATION_RESULT", modification_result);
			map.put("MODIFICATION_TIME", modification_time);
			map.put("PROJECT_INFO_NO", project_info_no);
			map.put("CREATE_TIME", new Date());
			map.put("MODIFY_TIME", new Date());
			map.put("BSFLAG", "0");
			map.put("CREATER", user_id);
			map.put("UPDATER", user_id);
			map.put("DEV_ACC_ID", dev_acc_id);
			map.put("TYPE", type);
			
			map.put("OIL_NUM", oil_num);
			map.put("WORK_HOUR", work_hour);
			map.put("DRILLING_NUM", drilling_num);
			map.put("MILEAGE_WRITE", mileage_write);
			map.put("MILEAGE_TODAY", mileage_today);
			
			
			String mk=(String) jdbcDao.saveOrUpdateEntity(map, "GMS_DEVICE_INSPECTIOIN");
			
			JSONArray jsonArray11 = object.getJSONArray("item_list"); //字表
			System.out.println(jsonArray11.length());
			if(jsonArray11.length()>0){
				for(int n =0;n<jsonArray11.length();n++){
					JSONObject object11 = jsonArray11.getJSONObject(n);
					String inspectioin_item_code = object11.get("inspectioin_item_code").toString();	//日常检测项目编码 
					
					Map mapDetail = new HashMap();
					mapDetail.put("DEVINSPECTIOIN_ID", mk);
					mapDetail.put("INSPECTIOIN_ITEM_CODE", inspectioin_item_code);
					mapDetail.put("BSFLAG", "0");
					mapDetail.put("MODIFY_DATE", new Date());
					mapDetail.put("CREATE_DATE", new Date());
					mapDetail.put("CREATER", user_id);
					mapDetail.put("UPDATER", user_id);
					jdbcDao.saveOrUpdateEntity(mapDetail, "GMS_DEVICE_INSPECTIOIN_ITEM");
				}
			}
		}
		return reqMsg;
	}	
	
	/*
	 * 
	 * 可控震运转记录（上传）
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadDeviceWorkInformation(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String  infos = reqDTO.getValue("androidParam");

		JSONObject  object = JSONObject.fromObject(infos);
		
		
		String dev_acc_id = object.get("dev_acc_id").toString();	//设备ID
		String project_id = object.get("project_id").toString(); 	//项目ID
//		String devwork_no = object.get("devwork_no").toString();  //运转记录号
//		String devwork_record = object.get("devwork_record").toString();  //运转记录人
		String devwork_time = object.get("devwork_time").toString();	//运转记录时间
		String devwork_update_time = object.get("devwork_update_time").toString();//运转记录更新时间
		String type = object.get("type").toString();	//1：可控震源 2：轻便钻机 3：运输车辆 4：车装钻机
//		String dwork_speed = object.get("dwork_speed").toString();	//运转转速
//		String dwork_oil_pressure = object.get("dwork_oil_pressure").toString(); 	//运转机油压力
//		String dwork_water_temp = object.get("dwork_water_temp").toString();	//运转水温
//		String dwork_drill_one = object.get("dwork_drill_one").toString();	//前低压力(驱动)
//		String dwork_drill_two = object.get("dwork_drill_two").toString();	//后低压力(驱动)
//		String dwork_vibrate_one = object.get("dwork_vibrate_one").toString();	//低压(振动)
//		String dwork_vibrate_two = object.get("dwork_vibrate_two").toString();	//高压(振动)

		String user_id = object.get("user_id").toString();	//用户ID
		
		String projectSql = "select t.project_info_no from gp_task_project t where t.bsflag='0' and t.project_id = '"+project_id+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
			String project_info_no = (String)projectMap.get("projectInfoNo");
			String user_name = "";
			String userSql = "select e.employee_name from comm_human_employee e where e.employee_id='"+user_id+"' ";
			Map userMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(userSql);
			if(userMap!=null){
				user_name = (String)projectMap.get("employeeName");
			}
			
			Map map=new HashMap();
//			map.put("DEVWORK_NO", devwork_no);
			map.put("DEVWORK_RECORD", user_name);
			map.put("DEVWORK_TIME", devwork_time);
//			map.put("DWORK_SPEED", dwork_speed);
//			map.put("DWORK_OIL_PRESSURE", dwork_oil_pressure);
//			map.put("DWORK_WATER_TEMP", dwork_water_temp);
//			map.put("DWORK_DRILL_ONE", dwork_drill_one);
//			map.put("DWORK_DRILL_TWO", dwork_drill_two);
//			map.put("DWORK_VIBRATE_ONE", dwork_vibrate_one);
//			map.put("DWORK_VIBRATE_TWO", dwork_vibrate_two);
			map.put("CREATE_TIME", new Date());
			map.put("MODIFY_TIME", new Date());
			map.put("BSFLAG", "0");
			map.put("CREATER", user_id);
			map.put("UPDATER", user_id);
			map.put("DEV_ACC_ID", dev_acc_id);
			map.put("PROJECT_INFO_NO", project_info_no);
			map.put("TYPE", type);
				
			Serializable devwork_id = pureDao.saveOrUpdateEntity(map, "GMS_DEVICE_WORK_INFORMATION");
			
			
			JSONArray jsonArray = object.getJSONArray("dork_list"); 
			if(jsonArray.length()>0){
				for(int n =0;n<jsonArray.length();n++){
					JSONObject object22 = jsonArray.getJSONObject(n);
					String type2 = object22.get("type").toString();//1:怠速状态，2：工作状态
					String dwork_speed = object22.get("dwork_speed").toString();	//运转转速
					String dwork_oil_pressure = object22.get("dwork_oil_pressure").toString(); 	//运转机油压力
					String dwork_water_temp = object22.get("dwork_water_temp").toString();	//运转水温
					String dwork_drill_one = object22.get("dwork_drill_one").toString();	//前低压力(驱动)
					String dwork_drill_two = object22.get("dwork_drill_two").toString();	//后低压力(驱动)
					String dwork_vibrate_one = object22.get("dwork_vibrate_one").toString();	//低压(振动)
					String dwork_vibrate_two = object22.get("dwork_vibrate_two").toString();	//高压(振动)
					
					Map map1=new HashMap();
					map1.put("DWORK_SPEED", dwork_speed);
					map1.put("DWORK_OIL_PRESSURE", dwork_oil_pressure);
					map1.put("DWORK_WATER_TEMP", dwork_water_temp);
					map1.put("DWORK_DRILL_ONE", dwork_drill_one);
					map1.put("DWORK_DRILL_TWO", dwork_drill_two);
					map1.put("DWORK_VIBRATE_ONE", dwork_vibrate_one);
					map1.put("DWORK_VIBRATE_TWO", dwork_vibrate_two);
					map1.put("DEVWORK_ID", devwork_id);
					map1.put("TYPE", type2);
					pureDao.saveOrUpdateEntity(map1, "GMS_DEVICE_WORK_DETAIL");
				}
			}
		}
			
		return reqMsg;
	}	
	
	/*
	 * 
	 * 物料消耗反馈接口
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadMatGrant(ISrvMsg reqDTO) throws Exception {

		String  infos = reqDTO.getValue("androidParam");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);


		JSONObject  object11 = JSONObject.fromObject(infos);
			
		String projectId = object11.get("project_id").toString();	//项目Id
		String dev_acc_id = object11.get("dev_acc_id").toString();  //设备ID
		String team_id = object11.get("team_id").toString();        //班组ID
		String outmat_date = object11.get("outmat_date").toString();	//发放时间
		String drawer = object11.get("drawer").toString(); 	//发放员
		String use_type = object11.get("use_type").toString();	//物料用途
		String pickupgoods = object11.get("pickupgoods").toString();	//提料人
		String note = object11.get("note").toString(); 	//备注
		String user_id = object11.get("user_id").toString(); //用户Id
		String wz_type = object11.get("wz_type").toString(); //物资类型
		
		JSONArray jsonArray22 = object11.getJSONArray("wz_list"); //所用物资列表
		
		String projectSql = "select t.project_info_no from gp_task_project t where t.bsflag='0' and t.project_id = '"+projectId+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
			String projectInfoNo = (String)projectMap.get("projectInfoNo");
		
			Map map = new HashMap();
			map.put("procure_no", getTableNum3(projectInfoNo));
//			map.put("total_money", reqMap.get("total_money"));
			map.put("status", "2");
			map.put("team_id", team_id);
//			map.put("device_id", reqMap.get("device_code"));
			map.put("dev_acc_id", dev_acc_id);
			map.put("outmat_date", outmat_date);
			map.put("use_type", use_type);
			map.put("drawer", drawer);
//			map.put("storage", reqMap.get("storage"));
			map.put("pickupgoods", pickupgoods);
			map.put("note", note);
			map.put("out_type", "1");
			map.put("project_info_no", projectInfoNo);
//			map.put("org_id",user.getOrgId());
//			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("CREATOR_ID", user_id);
			map.put("create_date", new Date());
			map.put("UPDATOR_ID", user_id);
			map.put("MODIFI_DATE", new Date());
			map.put("bsflag", "0");
			map.put("WZ_TYPE", wz_type);
		
		//物资出库单据表操作
		Serializable teammatOutId = pureDao.saveOrUpdateEntity(map, "gms_mat_teammat_out");

		//主表中的总共金额
		double all_money = 0;
		
		//物资领用明细操作
		if(jsonArray22.length()>0){
			for(int n =0;n<jsonArray22.length();n++){
				JSONObject object22 = jsonArray22.getJSONObject(n);
				String wz_id = object22.get("wz_id").toString();	 //物资ID
				String mat_num = object22.get("mat_num").toString();	//物资数量
				String actual_price = object22.get("actual_price").toString(); //实际单价
				if(actual_price.equals("")){
					actual_price = "0";
				}
				if(mat_num.equals("")){
					mat_num = "0";
				}
				
				double total_money = Double.parseDouble(mat_num)*Double.parseDouble(actual_price);
				
				all_money +=total_money;
				
				String getSql = "select * from gms_mat_teammat_info_detail t where t.wz_id='"
						+ wz_id + "'";
				Map getMap = pureDao.queryRecordBySQL(getSql);
				Map todMap = new HashMap();
				todMap.put("teammat_out_id", teammatOutId.toString());
				todMap.put("wz_id", wz_id);
				todMap.put("mat_num", mat_num);				//发放数量
				todMap.put("actual_price", actual_price);
				todMap.put("total_money", total_money);
				todMap.put("mat_sourth", getMap.get("mat_sourth"));
				todMap.put("goods_allocation", getMap.get("goods_allocation"));
				todMap.put("warehouse_number", getMap.get("warehouse_number"));
//				todMap.put("plan_no", reqMap.get("device_use_name"));
				todMap.put("bsflag","0");
				todMap.put("project_info_no",projectInfoNo);
				todMap.put("creator_id",user_id);
				todMap.put("create_date",new Date());
				todMap.put("UPDATOR_ID",user_id);
				todMap.put("MODIFI_DATE",new Date());
				pureDao.saveOrUpdateEntity(todMap,"gms_mat_teammat_out_detail");
			}
		}
		
		//更改主表中金额
		Map map2 = new HashMap();
		map2.put("TEAMMAT_OUT_ID", teammatOutId.toString());
		map2.put("total_money", all_money);
		pureDao.saveOrUpdateEntity(map2, "gms_mat_teammat_out");
		
		}
		return reqMsg;
	}
	
	
	public String getTableNum3(String projectInfoNo){
		
			//自动算生成单号年月日-001
		String input_no = "";
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(date);
		String autoSql = "select procure_no from gms_mat_teammat_out t where t.project_info_no='"+ projectInfoNo+ "' and t.bsflag='0' and t.procure_no like '"+today+"%' order by procure_no desc";
		Map  autoMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(autoSql);
		if(autoMap!=null&&autoMap.size()!=0){
			String input_nos = (String)autoMap.get("procureNo");
			String[] temp = input_nos.split("-");
			String nos = String.valueOf(Integer.parseInt(temp[1])+1);
			if(nos.length()==1){
				nos = "00"+nos;
			}else if(nos.length()==2){
				nos = "0"+nos;
			}
			input_no = today + "-" +nos;
		}else{
			input_no = today + "-001";
		}
		return input_no;
	}
	
	
	
	/*
	 * 
	 * 设备检查接口（上传）
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadDeviceCheck(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String  infos = reqDTO.getValue("androidParam");
		JSONObject  object11 = JSONObject.fromObject(infos);
		
		String project_id = object11.get("project_id").toString(); //项目ID
		String team_id = object11.get("team_id").toString();	//班组
		String check_date = object11.get("check_date").toString();	//检查日期
		String check_person = object11.get("check_person").toString();	//检查人员
		String modifi_project = object11.get("modifi_project").toString();	//整改事项
		String modifi_time = object11.get("modifi_time").toString();	//整改日期
		String modifi_person = object11.get("modifi_person").toString(); //整改人员
		String memo = object11.get("memo").toString();	//备注
		String system_situation = object11.get("system_situation").toString();	//班组制度执行情况
		String check_situation = object11.get("check_situation").toString();	//班组设备日常检查及保养情况
		String device_situation = object11.get("device_situation").toString();	//班组设备使用情况
		String hse_situation = object11.get("hse_situation").toString();	//班组HSE设施完成情况
		String user_id = object11.get("user_id").toString();	//用户ID
		
		JSONArray jsonArrayCL = object11.getJSONArray("dev_list_cheliang"); //设备Lsit-车辆
		JSONArray jsonArrayCZ = object11.getJSONArray("dev_list_chezhuang"); //设备Lsit-车装钻机
		JSONArray jsonArrayQB = object11.getJSONArray("dev_list_qingbian"); //设备Lsit-轻便钻机
		JSONArray jsonArrayTT = object11.getJSONArray("dev_list_tuituji"); //设备Lsit-推土机
		JSONArray jsonArrayCB = object11.getJSONArray("dev_list_yunshuchuanbo"); //设备Lsit-运输船舶
		JSONArray jsonArrayZY = object11.getJSONArray("dev_list_kekongzhenyuan"); //设备Lsit-可控震源
		JSONArray jsonArrayGJ = object11.getJSONArray("dev_list_guaji"); //设备Lsit-挂机
		JSONArray jsonArrayJZ = object11.getJSONArray("dev_list_fadianjizu"); //设备Lsit-发电机组
		
//		if(state.equals("1")){		
		String projectSql = "select t.project_info_no,t.project_type from gp_task_project t where t.bsflag='0' and t.project_id = '"+project_id+"'";
		Map projectMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectSql);
		if(projectMap!=null){
			String projectInfoNo = (String)projectMap.get("projectInfoNo");
			
//			String user_name = "";
//			String userSql = "select e.employee_name from comm_human_employee e where e.employee_id='"+user_id+"' ";
//			Map userMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(userSql);
//			if(userMap!=null){
//				user_name = (String)userMap.get("employeeName");
//			}
			
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("TEAM_ID", team_id);
			map.put("CHECK_DATE", check_date);
			map.put("CHECK_PERSON", check_person);
			map.put("MODIFI_PROJECT", modifi_project);
			map.put("MODIFI_TIME", modifi_time);
			map.put("MODIFI_PERSON", modifi_person);
			map.put("MEMO", memo);
			map.put("SYSTEM_SITUATION", system_situation);
			map.put("CHECK_SITUATION", check_situation);
			map.put("DEVICE_SITUATION", device_situation);
			map.put("HSE_SITUATION", hse_situation);
			map.put("PROJECT_INFO_NO", projectInfoNo);
			map.put("BSFLAG", "0");
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user_id);
			map.put("MODIFI_DATE", new Date());
			map.put("UPDATOR_ID", user_id);
			
			String inspection_team_id = jdbcDao.saveOrUpdateEntity(map, "BGP_DEVICE_INSPECTION_TEAM").toString();
			
			SimpleDateFormat sdf22 = new SimpleDateFormat("yyyyMMddHHmmss");
			String today_time = sdf22.format(new Date());
			
			//运输车辆
			if(jsonArrayCL.length()>0){
				for(int n =0;n<jsonArrayCL.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayCL.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"运输车辆"+today_time+".xls";
					saveexcel(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "运输车辆"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					
					jdbcDao.executeUpdate(sbSql.toString());
					
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					 
					 sn.close();
				}
			}
			//车装钻机
			if(jsonArrayCZ.length()>0){
				for(int n =0;n<jsonArrayCZ.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayCZ.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"车装钻机"+today_time+".xls";
					savechezhuangzuanjiexcel(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "车装钻机"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					jdbcDao.executeUpdate(sbSql.toString());
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					sn.close();
				}
			}
			//轻便钻机
			if(jsonArrayQB.length()>0){
				for(int n =0;n<jsonArrayQB.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayQB.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"轻便钻机"+today_time+".xls";
					saveqingbianzhuanjiexcel(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "轻便钻机"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					
					jdbcDao.executeUpdate(sbSql.toString());
					
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					sn.close();
				}
			}
			//推土机
			if(jsonArrayTT.length()>0){
				for(int n =0;n<jsonArrayTT.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayTT.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"推土机"+today_time+".xls";
					savetuituji(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "推土机"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					
					jdbcDao.executeUpdate(sbSql.toString());
					
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					sn.close();
				}
			}
			//运输船舶
			if(jsonArrayCB.length()>0){
				for(int n =0;n<jsonArrayCB.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayCB.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"运输船舶"+today_time+".xls";
					saveYunshuchuanboExcel(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "运输船舶"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					
					jdbcDao.executeUpdate(sbSql.toString());
					
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					sn.close();
				}
			}
			//可控震源
			if(jsonArrayZY.length()>0){
				for(int n =0;n<jsonArrayZY.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayZY.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"可控震源"+today_time+".xls";
					saveKekongzhenyuanExcel(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "可控震源"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					
					jdbcDao.executeUpdate(sbSql.toString());
					
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					sn.close();
				}
			}	
			//挂机
			if(jsonArrayGJ.length()>0){
				for(int n =0;n<jsonArrayGJ.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayGJ.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"挂机"+today_time+".xls";
					saveGuajiExcel(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "挂机"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					
					jdbcDao.executeUpdate(sbSql.toString());
					
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					sn.close();
				}
			}	
			//发电机组
			if(jsonArrayJZ.length()>0){
				for(int n =0;n<jsonArrayJZ.length();n++){
					
					Map map2=new HashMap();
					JSONObject object22 = jsonArrayJZ.getJSONObject(n);
					String dev_acc_id = object22.get("dev_acc_id").toString();	//设备编号
					String inspection_date = object22.get("inspection_date").toString();	//检查日期
					String inspection_content = object22.get("inspection_content").toString();	//存在描述
					String inspector = object22.get("inspector").toString();	//检查人
				
					map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
					map2.put("INSPECTOR", inspector);
					map2.put("INSPECTION_DATE", inspection_date);
					map2.put("INSPECTION_CONTENT", inspection_content);
					map2.put("BSFLAG", "0");
					map2.put("CREATOR", user_id);
					map2.put("CREATE_DATE", new Date());
					map2.put("UPDATOR", user_id);
					map2.put("MODIFI_DATE", new Date());
					map2.put("INSPECTION_TEAM_ID",inspection_team_id.toString());
					Serializable id = jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_INSPECTION");
					
					JSONArray jsonArrayCode = object22.getJSONArray("code_list"); //编码
					String path = WebPathUtil.getWebProjectPath();
					String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"发电机组"+today_time+".xls";
					saveFadianjizuExcel(jsonArrayCode,outFilePath,dev_acc_id,inspection_date,inspection_content);
					
					File fl = new File(outFilePath);
					byte by[] = new byte[200000];
						
					 FileInputStream sn = new FileInputStream(fl);
					 sn.read(by);
					 //by
					 String ucmDocId = "";
					 ucmDocId = myUcm.uploadFile(fl.getName(),by);
					 
					 
					 String file_id = jdbcDao.generateUUID();	
					 String relation_id = id.toString();
					 String file_name = "发电机组"+today_time+".xls";
					 if(file_name==null || file_name.trim().equals("")){
						file_name = "";
					 }
					StringBuffer sb = new StringBuffer();
					
//					String folder_id = responseDTO.getValue("folder_id");
					String folder_id = "";
					
					StringBuffer sbSql = new StringBuffer();
					
					sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
					
					jdbcDao.executeUpdate(sbSql.toString());
					
					myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
					myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
					sn.close();
				}
			}	
		}

		return reqMsg;
	}
	
	/*
	 * 
	 * 设备检查接口（上传）
	 * 
	 */
	@Operation(input = "androidParam" , output="deviceDatas")
	public ISrvMsg uploadTest(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);


		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String  infos = reqDTO.getValue("androidParam");
		JSONObject  object11 = JSONObject.fromObject(infos);
		
		

		return reqMsg;
	}
	
	//运输车辆
	public void saveexcel(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content){
		
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		 WritableWorkbook wwb = null;
		          try
		          {
		        	//判断是否有对应的文件夹
		          	File fl = new File(outFilePath);
		           
		    		if(!fl.getParentFile().exists()){
		    			fl.getParentFile().mkdirs();
		    		}
		        	//创建一个可写入的工作薄(Workbook)对象
		            wwb = Workbook.createWorkbook(new File(outFilePath));
		          } catch (IOException e)
		          {
		              e.printStackTrace();
		          }
		          if (wwb != null)
		          {
		              // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
		              WritableSheet ws = wwb.createSheet("sheet1", 0);
		              // 在指定单元格插入数据
		              WritableCellFormat wc = new WritableCellFormat(); 
		              WritableCellFormat wc1 = new WritableCellFormat(); 
		              // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
		              // 合并第一列第一行到第六列第一行的所有单元格 
		             
		              // 设置居中 
		              try {
						wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		            	wc.setAlignment(Alignment.CENTRE); 
		            	wc1.setOrientation(Orientation.VERTICAL);
		            	wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
						ws.mergeCells( 0 , 0 , 0 , 1);
						ws.mergeCells( 1 , 0 , 1, 1);
						ws.mergeCells( 2 , 0 , 2, 1);
						ws.mergeCells( 3 , 0 , 7, 0);
						ws.mergeCells( 8 , 0 , 8, 1);
						ws.mergeCells( 9 , 0 , 9, 1);
						ws.mergeCells( 10 , 0 , 10, 1);
						ws.mergeCells( 11 , 0 , 11, 1);
						ws.mergeCells( 12 , 0 , 12, 1);
						ws.mergeCells( 13 , 0 , 13, 1);
						ws.mergeCells( 14 , 0 , 14, 1);
						ws.mergeCells( 15 , 0 , 15, 1);
						ws.mergeCells( 16 , 0 , 16, 1);
						ws.mergeCells( 17 , 0 , 17, 1);
					} catch (WriteException e2) {
						// TODO Auto-generated catch block
						e2.printStackTrace();
					} 
					
					Label lbl1 = new Label(0, 0, "检查日期",wc);
					Label bll2 = new Label(0, 2, inspection_date,wc);
					ws.setColumnView(2, 40);
					Label lbl3 = new Label(1, 0, "设备编号",wc);
					Label bll4 = new Label(1, 2, dev_coding,wc);
					Label lbl5 = new Label(2, 0, "规格型号",wc);
					Label bll6 = new Label(2, 2, dev_model,wc);
					Label lbl8 = new Label(17, 0, "存在描述",wc);
					Label bll9 = new Label(17, 2, inspection_content,wc);
					ws.setColumnView(0, 15);
					ws.setColumnView(17, 40);
					
					Label lbl7 = new Label(3, 0, "发动机",wc);
					
					 try
		              {
		            	  ws.setRowView(1, 1600, false); //设置行高
		                  ws.addCell(lbl1);
		                  ws.addCell(bll2);
		                  ws.addCell(lbl3);
		                  ws.addCell(bll4);
		                  ws.addCell(lbl5);
		                  ws.addCell(bll6);
		                  ws.addCell(lbl7);
		              } catch (RowsExceededException e1)
		              {
		                  e1.printStackTrace();
		              } catch (WriteException e1)
		              {
		                  e1.printStackTrace();
		              }
					
					
					String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
							"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and (t.superior_code_id = '5110000164000000001' " +
							"or t.superior_code_id in (select t.coding_code_id from comm_coding_sort_detail t where " +
							"t.superior_code_id = '5110000164000000001'))  order by t.coding_show_id asc";
					List list = jdbcDao.queryRecords(codeSql);
					if(list.size()>0){
						for(int i=0;i<list.size();i++){
							Map codeMap = (Map)list.get(i);
							String flag = "0";
							String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
							String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
							String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
							for(int j=0;j<jsonArrayCode.length();j++){
								JSONObject object = jsonArrayCode.getJSONObject(j);
								String code_id = object.get("code_id").toString();	//设备编号
								if(coding_code_id.equals(code_id)){
									flag = "1" ;
								}
							}
							Label lbl = null;
							if(superior_code_id.equals("5110000164000000005")){
								lbl = new Label(i+3, 1, coding_name,wc1);
							}else{
								lbl = new Label(i+3, 0, coding_name,wc1);
							}
							Label lblValue = new Label(i+3, 2, flag.equals("1")?"×":"√",wc);
							 try
				              {
				                  ws.addCell(lbl);
				                  ws.addCell(lblValue);
				              } catch (RowsExceededException e1)
				              {
				                  e1.printStackTrace();
				              } catch (WriteException e1)
				              {
				                  e1.printStackTrace();
				              }
						}
					
		              
//		              Label lbl8 = new Label(3, 1, "机动性能",wc1);
//		              Label lbl9 = new Label(4, 1, "三滤",wc1);
//		              Label lbl10 = new Label(5, 1, "机油压力",wc1);
//		              Label lbl11 = new Label(6, 1, "各种皮带",wc1);
//		              Label lbl12 = new Label(7, 1, "冷却系统",wc1);
//		              
//		             
//		              Label lbl14 = new Label(3, 2, "√",wc);
//		              Label lbl15 = new Label(4, 2, "√",wc);
//		              Label lbl16 = new Label(5, 2, "√",wc);
//		              Label lbl17 = new Label(6, 2, "√",wc);
//		              Label lbl13 = new Label(7, 2, "√",wc);
//		              
//		              Label lbl18 = new Label(8, 0, "离合器",wc1);
//		              Label lbl19 = new Label(8, 2, "√",wc);
//		              Label lbl20 = new Label(9, 0, "变速（分动）箱",wc1);
//		              Label lbl21 = new Label(9, 2, "√",wc);
//		              Label lbl22 = new Label(10, 0, "差速箱",wc1);
//		              Label lbl23 = new Label(10, 2, "√",wc);
//		              Label lbl24 = new Label(11, 0, "传动轴",wc1);
//		              Label lbl25 = new Label(11, 2, "√",wc);
//		              Label lbl26 = new Label(12, 0, "悬挂装置",wc1);
//		              Label lbl27 = new Label(12, 2, "√",wc);
//		              Label lbl28 = new Label(13, 0, "制动系统",wc1);
//		              Label lbl29 = new Label(13, 2, "√",wc);
//		              Label lbl30 = new Label(14, 0, "轴头轮胎",wc1);
//		              Label lbl31 = new Label(14, 2, "√",wc);
//		              Label lbl32 = new Label(15, 0, "仪表电器",wc1);
//		              Label lbl33 = new Label(15, 2, "√",wc);
//		              Label lbl34 = new Label(16, 0, "日常检查记录",wc1);
//		              Label lbl35 = new Label(16, 2, "√",wc);
//		              Label lbl36 = new Label(17, 0, "存在描述",wc);
//		              Label lbl37 = new Label(17, 2, "",wc);
		              
//		              try
//		              {
//		            	  ws.setRowView(1, 1600, false); //设置行高
//		                  ws.addCell(lbl1);
//		                  ws.addCell(bll2);
//		                  ws.addCell(lbl3);
//		                  ws.addCell(bll4);
//		                  ws.addCell(lbl5);
//		                  ws.addCell(bll6);
//		                  ws.addCell(lbl7);
//		                  ws.addCell(lbl8);
//		                  ws.addCell(lbl9);
//		                  ws.addCell(lbl10);
//		                  ws.addCell(lbl11);
//		                  ws.addCell(lbl12);
//		                  ws.addCell(lbl13);
//		                  ws.addCell(lbl14);
//		                  ws.addCell(lbl15);
//		                  ws.addCell(lbl16);
//		                  ws.addCell(lbl17);
//		                  ws.addCell(lbl18);
//		                  ws.addCell(lbl19);
//		                  ws.addCell(lbl20);
//		                  ws.addCell(lbl21);
//		                  ws.addCell(lbl22);
//		                  ws.addCell(lbl23);
//		                  ws.addCell(lbl24);
//		                  ws.addCell(lbl25);
//		                  ws.addCell(lbl26);
//		                  ws.addCell(lbl27);
//		                  ws.addCell(lbl28);
//		                  ws.addCell(lbl29);
//		                  ws.addCell(lbl30);
//		                  ws.addCell(lbl31);
//		                  ws.addCell(lbl32);
//		                  ws.addCell(lbl33);
//		                  ws.addCell(lbl34);
//		                  ws.addCell(lbl35);
//		                  ws.addCell(lbl36);
//		                  ws.addCell(lbl37);
//		              } catch (RowsExceededException e1)
//		              {
//		                  e1.printStackTrace();
//		              } catch (WriteException e1)
//		              {
//		                  e1.printStackTrace();
//		              }
						
						 try
			              {
			                  ws.addCell(lbl8);
			                  ws.addCell(bll9);
			              } catch (RowsExceededException e1)
			              {
			                  e1.printStackTrace();
			              } catch (WriteException e1)
			              {
			                  e1.printStackTrace();
			              }
		              try
		              {
		                  // 从内存中写入文件中
		                  wwb.write();
		                  wwb.close();
		              } catch (IOException e)
		              {
		                  e.printStackTrace();
		              } catch (WriteException e)
		              {
		                  e.printStackTrace();
		              }
		          }
		          }

	}
	
	//车装钻机
	public void savechezhuangzuanjiexcel(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content)
	{
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		
		 WritableWorkbook wwb = null;
         try
         {
        	//判断是否有对应的文件夹
	        File fl = new File(outFilePath);
	           
	        if(!fl.getParentFile().exists()){
	    		fl.getParentFile().mkdirs();
	    	}
			//创建一个可写入的工作薄(Workbook)对象
			wwb = Workbook.createWorkbook(new File(outFilePath));
         } catch (IOException e)
         {
             e.printStackTrace();
         }
         if (wwb != null)
         {
             // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
             WritableSheet ws = wwb.createSheet("sheet1", 0);
             // 在指定单元格插入数据
             WritableCellFormat wc = new WritableCellFormat(); 
             WritableCellFormat wc1 = new WritableCellFormat(); 
             // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
             // 合并第一列第一行到第六列第一行的所有单元格 
            
             // 设置居中 
             try {
				wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	           	wc.setAlignment(Alignment.CENTRE); 
	           	wc1.setOrientation(Orientation.VERTICAL);
	           	wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			} catch (WriteException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} 
             Label lbl1 = new Label(0, 0, "检查日期",wc);
             Label bll2 = new Label(0, 1, inspection_date,wc);
             ws.setColumnView(2, 40);
             Label lbl3 = new Label(1, 0, "设备编号",wc);
             Label bll4 = new Label(1, 1, dev_coding,wc);
             Label lbl5 = new Label(2, 0, "规格型号",wc);
             Label bll6 = new Label(2, 1, dev_model,wc);
             Label lbl7 = new Label(11, 0, "存在描述",wc);
             Label bll8 = new Label(11, 1, inspection_content,wc);
             ws.setColumnView(0, 15);
             ws.setColumnView(17, 40);
             
             try
             {
           	  ws.setRowView(1, 1600, false); //设置行高
                 ws.addCell(lbl1);
                 ws.addCell(bll2);
                 ws.addCell(lbl3);
                 ws.addCell(bll4);
                 ws.addCell(lbl5);
                 ws.addCell(bll6);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
           
             String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
             		"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and t.superior_code_id = '5110000164000000002' " +
             		"order by t.coding_show_id asc";
		List list = jdbcDao.queryRecords(codeSql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map codeMap = (Map)list.get(i);
				String flag = "0";
				String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
				String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
				String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
				for(int j=0;j<jsonArrayCode.length();j++){
					JSONObject object = jsonArrayCode.getJSONObject(j);
					String code_id = object.get("code_id").toString();	//设备编号
					if(coding_code_id.equals(code_id)){
						flag = "1" ;
					}
				}
				Label lbl = new Label(i+3, 0, coding_name,wc1);
				Label lblValue = new Label(i+3, 1, flag.equals("1")?"×":"√",wc);
				 try
	              {
	                  ws.addCell(lbl);
	                  ws.addCell(lblValue);
	              } catch (RowsExceededException e1)
	              {
	                  e1.printStackTrace();
	              } catch (WriteException e1)
	              {
	                  e1.printStackTrace();
	              }
			}
             
             
//             Label lbl18 = new Label(3, 0, "泥浆泵及其附件",wc1);
//             Label lbl19 = new Label(3, 1, "√",wc);
//             Label lbl20 = new Label(4, 0, "钻机井架及其附件",wc1);
//             Label lbl21 = new Label(4, 1, "√",wc);
//             Label lbl22 = new Label(5, 0, "空压机离合器及其附件",wc1);
//             Label lbl23 = new Label(5, 1, "√",wc);
//             Label lbl24 = new Label(6, 0, "液压系统及附件",wc1);
//             Label lbl25 = new Label(6, 1, "√",wc);
//             Label lbl26 = new Label(7, 0, "悬挂装置",wc1);
//             Label lbl27 = new Label(7, 1, "√",wc);
//             Label lbl28 = new Label(8, 0, "操作阀、接头及手柄",wc1);
//             Label lbl29 = new Label(8, 1, "√",wc);
//             Label lbl30 = new Label(9, 0, "取力器",wc1);
//             Label lbl31 = new Label(9, 1, "√",wc);
//             Label lbl32 = new Label(10, 0, "减速器",wc1);
//             Label lbl33 = new Label(10, 1, "√",wc);
//             Label lbl34 = new Label(11, 0, "日常检查记录",wc1);
//             Label lbl35 = new Label(11, 1, "√",wc);
//             Label lbl36 = new Label(12, 0, "存在描述",wc);
//             Label lbl37 = new Label(12, 1, "",wc);
             
//             try
//             {
//           	  ws.setRowView(1, 1600, false); //设置行高
//                 ws.addCell(lbl1);
//                 ws.addCell(bll2);
//                 ws.addCell(lbl3);
//                 ws.addCell(bll4);
//                 ws.addCell(lbl5);
//                 ws.addCell(bll6);
//                 ws.addCell(lbl18);
//                 ws.addCell(lbl19);
//                 ws.addCell(lbl20);
//                 ws.addCell(lbl21);
//                 ws.addCell(lbl22);
//                 ws.addCell(lbl23);
//                 ws.addCell(lbl24);
//                 ws.addCell(lbl25);
//                 ws.addCell(lbl26);
//                 ws.addCell(lbl27);
//                 ws.addCell(lbl28);
//                 ws.addCell(lbl29);
//                 ws.addCell(lbl30);
//                 ws.addCell(lbl31);
//                 ws.addCell(lbl32);
//                 ws.addCell(lbl33);
//                 ws.addCell(lbl34);
//                 ws.addCell(lbl35);
//                 ws.addCell(lbl36);
//                 ws.addCell(lbl37);
//             } catch (RowsExceededException e1)
//             {
//                 e1.printStackTrace();
//             } catch (WriteException e1)
//             {
//                 e1.printStackTrace();
//             }
			 try
             {
                 ws.addCell(lbl7);
                 ws.addCell(bll8);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
             try
             {
                 // 从内存中写入文件中
                 wwb.write();
                 wwb.close();
             } catch (IOException e)
             {
                 e.printStackTrace();
             } catch (WriteException e)
             {
                 e.printStackTrace();
             }
         }
         }
	}
	
	//轻便钻机
	public void saveqingbianzhuanjiexcel(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content)
	{
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		 WritableWorkbook wwb = null;
         try
         {	
        	//判断是否有对应的文件夹
	        File fl = new File(outFilePath);
	           
	        if(!fl.getParentFile().exists()){
	    		fl.getParentFile().mkdirs();
	    	}
            //创建一个可写入的工作薄(Workbook)对象
            wwb = Workbook.createWorkbook(new File(outFilePath));
         } catch (IOException e)
         {
             e.printStackTrace();
         }
         if (wwb != null)
         {
             // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
             WritableSheet ws = wwb.createSheet("sheet1", 0);
             // 在指定单元格插入数据
             WritableCellFormat wc = new WritableCellFormat(); 
             WritableCellFormat wc1 = new WritableCellFormat(); 
             // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
             // 合并第一列第一行到第六列第一行的所有单元格 
            
             // 设置居中 
             try {
				wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
           	wc.setAlignment(Alignment.CENTRE); 
           	wc1.setOrientation(Orientation.VERTICAL);
           	wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				ws.mergeCells( 0 , 0 , 0 , 1);
				ws.mergeCells( 1 , 0 , 1, 1);
				ws.mergeCells( 2 , 0 , 2, 1);
				ws.mergeCells( 3 , 0 , 7, 0);
				ws.mergeCells( 8 , 0 , 11, 0);
				ws.mergeCells( 12 , 0 , 16, 0);
				ws.mergeCells( 17 , 0 , 20, 0);
				ws.mergeCells( 21 , 0 , 21, 1);
				ws.mergeCells( 22 , 0 , 22, 1);
				ws.mergeCells( 23 , 0 , 23, 1);
//				ws.mergeCells( 10 , 0 , 10, 1);
//				ws.mergeCells( 11 , 0 , 11, 1);
//				ws.mergeCells( 12 , 0 , 12, 1);
//				ws.mergeCells( 13 , 0 , 13, 1);
//				ws.mergeCells( 14 , 0 , 14, 1);
//				ws.mergeCells( 15 , 0 , 15, 1);
//				ws.mergeCells( 16 , 0 , 16, 1);
//				ws.mergeCells( 17 , 0 , 17, 1);
			} catch (WriteException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} 
             Label lbl1 = new Label(0, 0, "检查日期",wc);
             Label bll2 = new Label(0, 2, inspection_date,wc);
             ws.setColumnView(2, 40);
             Label lbl3 = new Label(1, 0, "设备编号",wc);
             Label bll4 = new Label(1, 2, dev_coding,wc);
             Label lbl5 = new Label(2, 0, "规格型号",wc);
             Label bll6 = new Label(2, 2, dev_model,wc);
             Label lbl40 = new Label(23, 0, "存在描述",wc);
             Label bll41 = new Label(23, 2, inspection_content,wc);
             ws.setColumnView(0, 15);
             ws.setColumnView(22, 40);
             
             Label lbl7 = new Label(3, 0, "发动机",wc);
             Label lbl18 = new Label(8, 0, "空压机",wc);
             Label lbl38 = new Label(12, 0, "液压部分",wc);
             Label lbl36 = new Label(17, 0, "井架部分",wc);
             
             try
             {
           	     ws.setRowView(1, 1600, false); //设置行高
                 ws.addCell(lbl1);
                 ws.addCell(bll2);
                 ws.addCell(lbl3);
                 ws.addCell(bll4);
                 ws.addCell(lbl5);
                 ws.addCell(bll6);
                 ws.addCell(lbl7);
                 ws.addCell(lbl18);
                 ws.addCell(lbl36);
                 ws.addCell(lbl38);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
             
             
             String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
				"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and (t.superior_code_id = '5110000164000000003' " +
				"or t.superior_code_id in (select t.coding_code_id from comm_coding_sort_detail t where " +
				"t.superior_code_id = '5110000164000000003'))  order by t.coding_show_id asc";
			List list = jdbcDao.queryRecords(codeSql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					Map codeMap = (Map)list.get(i);
					String flag = "0";
					String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
					String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
					String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
					for(int j=0;j<jsonArrayCode.length();j++){
						JSONObject object = jsonArrayCode.getJSONObject(j);
						String code_id = object.get("code_id").toString();	//设备编号
						if(coding_code_id.equals(code_id)){
							flag = "1" ;
						}
					}
					Label lbl = null;
					if(superior_code_id.equals("5110000164000000003")){
						lbl = new Label(i+3, 0, coding_name,wc1);
					}else{
						lbl = new Label(i+3, 1, coding_name,wc1);
					}
					Label lblValue = new Label(i+3, 2, flag.equals("1")?"×":"√",wc);
					 try
		              {
		                  ws.addCell(lbl);
		                  ws.addCell(lblValue);
		              } catch (RowsExceededException e1)
		              {
		                  e1.printStackTrace();
		              } catch (WriteException e1)
		              {
		                  e1.printStackTrace();
		              }
				}
				
				try
	             {
	                 ws.addCell(lbl40);
	                 ws.addCell(bll41);
	             } catch (RowsExceededException e1)
	             {
	                 e1.printStackTrace();
	             } catch (WriteException e1)
	             {
	                 e1.printStackTrace();
	             }

				try
	             {
	                 // 从内存中写入文件中
	                 wwb.write();
	                 wwb.close();
	             } catch (IOException e)
	             {
	                 e.printStackTrace();
	             } catch (WriteException e)
	             {
	                 e.printStackTrace();
	             }
		 }
         }
	}
	//推土机
	public void savetuituji(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content)
	{
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		 WritableWorkbook wwb = null;
         try
         {
        	//判断是否有对应的文件夹
        	File fl = new File(outFilePath);
         
  			if(!fl.getParentFile().exists()){
  				fl.getParentFile().mkdirs();
  			}
             //创建一个可写入的工作薄(Workbook)对象
             wwb = Workbook.createWorkbook(new File(outFilePath));
         } catch (IOException e)
         {
             e.printStackTrace();
         }
         if (wwb != null)
         {
             // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
             WritableSheet ws = wwb.createSheet("sheet1", 0);
             // 在指定单元格插入数据
             WritableCellFormat wc = new WritableCellFormat(); 
             WritableCellFormat wc1 = new WritableCellFormat(); 
             // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
             // 合并第一列第一行到第六列第一行的所有单元格 
            
             // 设置居中 
             try {
				wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
           	wc.setAlignment(Alignment.CENTRE); 
           	wc1.setOrientation(Orientation.VERTICAL);
           	wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				ws.mergeCells( 0 , 0 , 0 , 1);
				ws.mergeCells( 1 , 0 , 1, 1);
				ws.mergeCells( 2 , 0 , 2, 1);
				ws.mergeCells( 3 , 0 , 7, 0);
				ws.mergeCells( 8 , 0 , 8, 1);
				ws.mergeCells( 9 , 0 , 9, 1);
				ws.mergeCells( 10 , 0 , 10, 1);
				ws.mergeCells( 11 , 0 , 11, 1);
				ws.mergeCells( 12 , 0 , 12, 1);
				ws.mergeCells( 13 , 0 , 13, 1);
				ws.mergeCells( 14 , 0 , 14, 1);
				ws.mergeCells( 15 , 0 , 15, 1);
				ws.mergeCells( 16 , 0 , 16, 1);
				ws.mergeCells( 17 , 0 , 17, 1);
			} catch (WriteException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} 
             Label lbl1 = new Label(0, 0, "检查日期",wc);
             Label bll2 = new Label(0, 2, inspection_date,wc);
             ws.setColumnView(2, 40);
             Label lbl3 = new Label(1, 0, "设备编号",wc);
             Label bll4 = new Label(1, 2, dev_coding,wc);
             Label lbl5 = new Label(2, 0, "规格型号",wc);
             Label bll6 = new Label(2, 2, dev_model,wc);
             Label lbl8 = new Label(15, 0, "存在描述",wc);
             Label bll9 = new Label(15, 2, inspection_content,wc);
             ws.setColumnView(0, 15);
             ws.setColumnView(15, 40);
             Label lbl7 = new Label(3, 0, "发动机",wc);
             
             try
             {
           	  ws.setRowView(1, 1600, false); //设置行高
                 ws.addCell(lbl1);
                 ws.addCell(bll2);
                 ws.addCell(lbl3);
                 ws.addCell(bll4);
                 ws.addCell(lbl5);
                 ws.addCell(bll6);
                 ws.addCell(lbl7);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
             
             
             String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
				"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and (t.superior_code_id = '5110000164000000004' " +
				"or t.superior_code_id in (select t.coding_code_id from comm_coding_sort_detail t where " +
				"t.superior_code_id = '5110000164000000004')) order by t.coding_show_id asc";
			List list = jdbcDao.queryRecords(codeSql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					Map codeMap = (Map)list.get(i);
					String flag = "0";
					String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
					String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
					String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
					for(int j=0;j<jsonArrayCode.length();j++){
						JSONObject object = jsonArrayCode.getJSONObject(j);
						String code_id = object.get("code_id").toString();	//设备编号
						if(coding_code_id.equals(code_id)){
							flag = "1" ;
						}
					}
					Label lbl = null;
					if(superior_code_id.equals("5110000164000000052")){
						lbl = new Label(i+3, 1, coding_name,wc1);
					}else{
						lbl = new Label(i+3, 0, coding_name,wc1);
					}
					Label lblValue = new Label(i+3, 2, flag.equals("1")?"×":"√",wc);
					 try
		              {
		                  ws.addCell(lbl);
		                  ws.addCell(lblValue);
		              } catch (RowsExceededException e1)
		              {
		                  e1.printStackTrace();
		              } catch (WriteException e1)
		              {
		                  e1.printStackTrace();
		              }
				}
				
				 try
	             {
	                 ws.addCell(lbl8);
	                 ws.addCell(bll9);
	             } catch (RowsExceededException e1)
	             {
	                 e1.printStackTrace();
	             } catch (WriteException e1)
	             {
	                 e1.printStackTrace();
	             }
	             try
	             {
	                 // 从内存中写入文件中
	                 wwb.write();
	                 wwb.close();
	             } catch (IOException e)
	             {
	                 e.printStackTrace();
	             } catch (WriteException e)
	             {
	                 e.printStackTrace();
	             }
		 }
       }
	}
	
	/**
	 * 运输船舶检查
	 * @param jsonArrayCode
	 * @param outFilePath
	 * @param dev_acc_id
	 * @param inspection_date
	 * @param inspection_content
	 */
	public void saveYunshuchuanboExcel(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content)
	{
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		 WritableWorkbook wwb = null;
         try
         {
        	//判断是否有对应的文件夹
        	File fl = new File(outFilePath);
         
  			if(!fl.getParentFile().exists()){
  				fl.getParentFile().mkdirs();
  			}
             //创建一个可写入的工作薄(Workbook)对象
             wwb = Workbook.createWorkbook(new File(outFilePath));
         } catch (IOException e)
         {
             e.printStackTrace();
         }
         if (wwb != null)
         {
             // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
             WritableSheet ws = wwb.createSheet("sheet1", 0);
             // 在指定单元格插入数据
             WritableCellFormat wc = new WritableCellFormat(); 
             WritableCellFormat wc1 = new WritableCellFormat(); 
             // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
             // 合并第一列第一行到第六列第一行的所有单元格 
            
             // 设置居中 
             try {
				wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				wc.setAlignment(Alignment.CENTRE); 
				wc1.setOrientation(Orientation.VERTICAL);
				wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				ws.mergeCells( 0 , 0 , 0 , 1);
				ws.mergeCells( 1 , 0 , 1, 1);
				ws.mergeCells( 2 , 0 , 2, 1);
				ws.mergeCells( 3 , 0 , 10, 0);
				ws.mergeCells( 11 , 0 , 14, 0);
				ws.mergeCells( 15 , 0 , 17, 0);
				ws.mergeCells( 18 , 0 , 18, 1);
				ws.mergeCells( 19 , 0 , 19, 1);
			} catch (WriteException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} 
             Label lbl0 = new Label(0, 0, "检查日期",wc);
             Label bll0 = new Label(0, 2, inspection_date,wc);
             ws.setColumnView(0, 15);
             Label lbl1 = new Label(1, 0, "设备编号",wc);
             Label bll1 = new Label(1, 2, dev_coding,wc);
             ws.setColumnView(1, 25);
             Label lbl2 = new Label(2, 0, "规格型号",wc);
             Label bll2 = new Label(2, 2, dev_model,wc);
             ws.setColumnView(2, 40);
             Label lbl19 = new Label(19, 0, "存在描述",wc);
             Label bll19 = new Label(19, 2, inspection_content,wc);
             ws.setColumnView(19, 40);
             Label lbl3 = new Label(3, 0, "轮机设备",wc);
             Label lbl11 = new Label(11, 0, "甲板设备",wc);
             Label lbl15 = new Label(15, 0, "气爆设备",wc);
             try
             {
           	  ws.setRowView(1, 1600,false); //设置行高
                 ws.addCell(lbl0);
                 ws.addCell(bll0);
                 ws.addCell(lbl1);
                 ws.addCell(bll1);
                 ws.addCell(lbl2);
                 ws.addCell(bll2);
                 ws.addCell(lbl3);
                 ws.addCell(lbl11);
                 ws.addCell(lbl15);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
             
             
             String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
				"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and (t.superior_code_id = '5110000164000000066' " +
				"or t.superior_code_id in (select t.coding_code_id from comm_coding_sort_detail t where " +
				"t.superior_code_id = '5110000164000000066')) order by t.coding_show_id asc";
			List list = jdbcDao.queryRecords(codeSql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					Map codeMap = (Map)list.get(i);
					String flag = "0";
					String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
					String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
					String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
					for(int j=0;j<jsonArrayCode.length();j++){
						JSONObject object = jsonArrayCode.getJSONObject(j);
						String code_id = object.get("code_id").toString();	//设备编号
						if(coding_code_id.equals(code_id)){
							flag = "1" ;
						}
					}
					Label lbl = null;
					if(superior_code_id.equals("5110000164000000066")){
						lbl = new Label(i+3, 0, coding_name,wc1);
					}else{
						lbl = new Label(i+3, 1, coding_name,wc1);
					}
					Label lblValue = new Label(i+3, 2, flag.equals("1")?"×":"√",wc);
					 try
		              {
		                  ws.addCell(lbl);
		                  ws.addCell(lblValue);
		              } catch (RowsExceededException e1)
		              {
		                  e1.printStackTrace();
		              } catch (WriteException e1)
		              {
		                  e1.printStackTrace();
		              }
				}
				
				 try
	             {
	                 ws.addCell(lbl19);
	                 ws.addCell(bll19);
	             } catch (RowsExceededException e1)
	             {
	                 e1.printStackTrace();
	             } catch (WriteException e1)
	             {
	                 e1.printStackTrace();
	             }
	             try
	             {
	                 // 从内存中写入文件中
	                 wwb.write();
	                 wwb.close();
	             } catch (IOException e)
	             {
	                 e.printStackTrace();
	             } catch (WriteException e)
	             {
	                 e.printStackTrace();
	             }
		 }
       }
	}	
	
	/**
	 * 可控震源检查
	 * @param jsonArrayCode
	 * @param outFilePath
	 * @param dev_acc_id
	 * @param inspection_date
	 * @param inspection_content
	 */
	public void saveKekongzhenyuanExcel(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content)
	{
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		 WritableWorkbook wwb = null;
         try
         {
        	//判断是否有对应的文件夹
        	File fl = new File(outFilePath);
         
  			if(!fl.getParentFile().exists()){
  				fl.getParentFile().mkdirs();
  			}
             //创建一个可写入的工作薄(Workbook)对象
             wwb = Workbook.createWorkbook(new File(outFilePath));
         } catch (IOException e)
         {
             e.printStackTrace();
         }
         if (wwb != null)
         {
             // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
             WritableSheet ws = wwb.createSheet("sheet1", 0);
             // 在指定单元格插入数据
             WritableCellFormat wc = new WritableCellFormat(); 
             WritableCellFormat wc1 = new WritableCellFormat(); 
             // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
             // 合并第一列第一行到第六列第一行的所有单元格 
            
             // 设置居中 
             try {
				wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				wc.setAlignment(Alignment.CENTRE); 
				wc1.setOrientation(Orientation.VERTICAL);
				wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				ws.mergeCells( 0 , 0 , 0 , 1);
				ws.mergeCells( 1 , 0 , 1, 1);
				ws.mergeCells( 2 , 0 , 2, 1);
				ws.mergeCells( 3 , 0 , 3, 1);
				ws.mergeCells( 4 , 0 , 4, 1);
				ws.mergeCells( 5 , 0 , 7, 0);
				ws.mergeCells( 8 , 0 , 8, 1);
				ws.mergeCells( 9 , 0 , 9, 1);
				ws.mergeCells( 10 , 0 , 10, 1);
				ws.mergeCells( 11 , 0 , 11, 1);
				ws.mergeCells( 12 , 0 , 12, 1);
				ws.mergeCells( 13 , 0 , 13, 1);
			} catch (WriteException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} 
             Label lbl0 = new Label(0, 0, "检查日期",wc);
             Label bll0 = new Label(0, 2, inspection_date,wc);
             ws.setColumnView(0, 15);
             Label lbl1 = new Label(1, 0, "设备编号",wc);
             Label bll1 = new Label(1, 2, dev_coding,wc);
             ws.setColumnView(1, 25);
             Label lbl2 = new Label(2, 0, "规格型号",wc);
             Label bll2 = new Label(2, 2, dev_model,wc);
             ws.setColumnView(2, 40);
             Label lbl13 = new Label(13, 0, "存在描述",wc);
             Label bll13 = new Label(13, 2, inspection_content,wc);
             ws.setColumnView(13, 40);
             Label lbl5 = new Label(5, 0, "发动机",wc);
             try
             {
           	  ws.setRowView(1, 2800, false); //设置行高
                 ws.addCell(lbl0);
                 ws.addCell(bll0);
                 ws.addCell(lbl1);
                 ws.addCell(bll1);
                 ws.addCell(lbl2);
                 ws.addCell(bll2);
                 ws.addCell(lbl5);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
             
             
             String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
				"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and (t.superior_code_id = '5110000164000000067' " +
				"or t.superior_code_id in (select t.coding_code_id from comm_coding_sort_detail t where " +
				"t.superior_code_id = '5110000164000000067')) order by t.coding_show_id asc";
			List list = jdbcDao.queryRecords(codeSql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					Map codeMap = (Map)list.get(i);
					String flag = "0";
					String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
					String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
					String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
					for(int j=0;j<jsonArrayCode.length();j++){
						JSONObject object = jsonArrayCode.getJSONObject(j);
						String code_id = object.get("code_id").toString();	//设备编号
						if(coding_code_id.equals(code_id)){
							flag = "1" ;
						}
					}
					Label lbl = null;
					if(superior_code_id.equals("5110000164000000067")){
						lbl = new Label(i+3, 0, coding_name,wc1);
					}else{
						lbl = new Label(i+3, 1, coding_name,wc1);
					}
					Label lblValue = new Label(i+3, 2, flag.equals("1")?"×":"√",wc);
					 try
		              {
		                  ws.addCell(lbl);
		                  ws.addCell(lblValue);
		              } catch (RowsExceededException e1)
		              {
		                  e1.printStackTrace();
		              } catch (WriteException e1)
		              {
		                  e1.printStackTrace();
		              }
				}
				
				 try
	             {
	                 ws.addCell(lbl13);
	                 ws.addCell(bll13);
	             } catch (RowsExceededException e1)
	             {
	                 e1.printStackTrace();
	             } catch (WriteException e1)
	             {
	                 e1.printStackTrace();
	             }
	             try
	             {
	                 // 从内存中写入文件中
	                 wwb.write();
	                 wwb.close();
	             } catch (IOException e)
	             {
	                 e.printStackTrace();
	             } catch (WriteException e)
	             {
	                 e.printStackTrace();
	             }
		 }
       }
	}
	
	/**
	 * 挂机检查
	 * @param jsonArrayCode
	 * @param outFilePath
	 * @param dev_acc_id
	 * @param inspection_date
	 * @param inspection_content
	 */
	public void saveGuajiExcel(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content)
	{
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		
		 WritableWorkbook wwb = null;
         try
         {
        	//判断是否有对应的文件夹
	        File fl = new File(outFilePath);
	           
	        if(!fl.getParentFile().exists()){
	    		fl.getParentFile().mkdirs();
	    	}
			//创建一个可写入的工作薄(Workbook)对象
			wwb = Workbook.createWorkbook(new File(outFilePath));
         } catch (IOException e)
         {
             e.printStackTrace();
         }
         if (wwb != null)
         {
             // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
             WritableSheet ws = wwb.createSheet("sheet1", 0);
             // 在指定单元格插入数据
             WritableCellFormat wc = new WritableCellFormat(); 
             WritableCellFormat wc1 = new WritableCellFormat(); 
             // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
             // 合并第一列第一行到第六列第一行的所有单元格 
            
             // 设置居中 
             try {
				wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	           	wc.setAlignment(Alignment.CENTRE); 
	           	wc1.setOrientation(Orientation.VERTICAL);
	           	wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			} catch (WriteException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} 
             Label lbl0 = new Label(0, 0, "检查日期",wc);
             Label bll0 = new Label(0, 1, inspection_date,wc);
             ws.setColumnView(0, 15);
             Label lbl1 = new Label(1, 0, "设备编号",wc);
             Label bll1 = new Label(1, 1, dev_coding,wc);
             ws.setColumnView(1, 25);
             Label lbl2 = new Label(2, 0, "规格型号",wc);
             Label bll2 = new Label(2, 1, dev_model,wc);
             ws.setColumnView(2, 40);
             Label lbl14 = new Label(14, 0, "存在描述",wc);
             Label bll14 = new Label(14, 1, inspection_content,wc);
             ws.setColumnView(14, 40);
             
             try
             {
           	  ws.setRowView(0, 1600, false); //设置行高
                 ws.addCell(lbl0);
                 ws.addCell(bll0);
                 ws.addCell(lbl1);
                 ws.addCell(bll1);
                 ws.addCell(lbl2);
                 ws.addCell(bll2);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
           
             String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
             		"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and t.superior_code_id = '5110000164000000068' " +
             		"order by t.coding_show_id asc";
		List list = jdbcDao.queryRecords(codeSql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map codeMap = (Map)list.get(i);
				String flag = "0";
				String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
				String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
				String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
				for(int j=0;j<jsonArrayCode.length();j++){
					JSONObject object = jsonArrayCode.getJSONObject(j);
					String code_id = object.get("code_id").toString();	//设备编号
					if(coding_code_id.equals(code_id)){
						flag = "1" ;
					}
				}
				Label lbl = new Label(i+3, 0, coding_name,wc1);
				Label lblValue = new Label(i+3, 1, flag.equals("1")?"×":"√",wc);
				 try
	              {
	                  ws.addCell(lbl);
	                  ws.addCell(lblValue);
	              } catch (RowsExceededException e1)
	              {
	                  e1.printStackTrace();
	              } catch (WriteException e1)
	              {
	                  e1.printStackTrace();
	              }
			}
			 try
             {
                 ws.addCell(lbl14);
                 ws.addCell(bll14);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
             try
             {
                 // 从内存中写入文件中
                 wwb.write();
                 wwb.close();
             } catch (IOException e)
             {
                 e.printStackTrace();
             } catch (WriteException e)
             {
                 e.printStackTrace();
             }
         }
         }
	}
	
	/**
	 * 发电机组检查
	 * @param jsonArrayCode
	 * @param outFilePath
	 * @param dev_acc_id
	 * @param inspection_date
	 * @param inspection_content
	 */
	public void saveFadianjizuExcel(JSONArray jsonArrayCode,String outFilePath,String dev_acc_id,String inspection_date,String inspection_content)
	{
		String dev_coding = "";
		String dev_model = "";
		String sql = "select t.dev_coding,t.dev_model from gms_device_account_dui t where t.dev_acc_id='"+dev_acc_id+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if(map!=null){
			dev_coding = map.get("dev_coding")==null?"":map.get("dev_coding").toString();
			dev_model = map.get("dev_model")==null?"":map.get("dev_model").toString();
		}
		 WritableWorkbook wwb = null;
         try
         {
        	//判断是否有对应的文件夹
        	File fl = new File(outFilePath);
         
  			if(!fl.getParentFile().exists()){
  				fl.getParentFile().mkdirs();
  			}
             //创建一个可写入的工作薄(Workbook)对象
             wwb = Workbook.createWorkbook(new File(outFilePath));
         } catch (IOException e)
         {
             e.printStackTrace();
         }
         if (wwb != null)
         {
             // 第一个参数是工作表的名称，第二个是工作表在工作薄中的位置
             WritableSheet ws = wwb.createSheet("sheet1", 0);
             // 在指定单元格插入数据
             WritableCellFormat wc = new WritableCellFormat(); 
             WritableCellFormat wc1 = new WritableCellFormat(); 
             // 作用是从(m,n)到(p,q)的单元格全部合并，比如： 
             // 合并第一列第一行到第六列第一行的所有单元格 
            
             // 设置居中 
             try {
				wc.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				wc.setAlignment(Alignment.CENTRE); 
				wc1.setOrientation(Orientation.VERTICAL);
				wc1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
				ws.mergeCells( 0 , 0 , 0 , 1);
				ws.mergeCells( 1 , 0 , 1, 1);
				ws.mergeCells( 2 , 0 , 2, 1);
				ws.mergeCells( 3 , 0 , 7, 0);
				ws.mergeCells( 8 , 0 , 11, 0);
				ws.mergeCells( 12 , 0 , 12, 1);
				ws.mergeCells( 13 , 0 , 13, 1);
				ws.mergeCells( 14 , 0 , 14, 1);
				ws.mergeCells( 15 , 0 , 15, 1);
			} catch (WriteException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} 
             Label lbl0 = new Label(0, 0, "检查日期",wc);
             Label bll0 = new Label(0, 2, inspection_date,wc);
             ws.setColumnView(0, 15);
             Label lbl1 = new Label(1, 0, "设备编号",wc);
             Label bll1 = new Label(1, 2, dev_coding,wc);
             ws.setColumnView(1, 25);
             Label lbl2 = new Label(2, 0, "规格型号",wc);
             Label bll2 = new Label(2, 2, dev_model,wc);
             ws.setColumnView(2, 40);
             Label lbl15 = new Label(15, 0, "存在描述",wc);
             Label bll15 = new Label(15, 2, inspection_content,wc);
             ws.setColumnView(15, 40);
             Label lbl3 = new Label(3, 0, "发动机部分",wc);
             Label lbl8 = new Label(8, 0, "发电机部分",wc);
             try
             {
           	  ws.setRowView(1, 1600, false); //设置行高
                 ws.addCell(lbl0);
                 ws.addCell(bll0);
                 ws.addCell(lbl1);
                 ws.addCell(bll1);
                 ws.addCell(lbl2);
                 ws.addCell(bll2);
                 ws.addCell(lbl3);
                 ws.addCell(lbl8);
             } catch (RowsExceededException e1)
             {
                 e1.printStackTrace();
             } catch (WriteException e1)
             {
                 e1.printStackTrace();
             }
             
             
             String codeSql = "select t.coding_code_id,t.coding_name,t.superior_code_id from comm_coding_sort_detail t " +
				"where t.coding_sort_id = '5110000164' and t.bsflag='0' and t.end_if='1' and (t.superior_code_id = '5110000164000000069' " +
				"or t.superior_code_id in (select t.coding_code_id from comm_coding_sort_detail t where " +
				"t.superior_code_id = '5110000164000000069')) order by t.coding_show_id asc";
			List list = jdbcDao.queryRecords(codeSql);
			if(list.size()>0){
				for(int i=0;i<list.size();i++){
					Map codeMap = (Map)list.get(i);
					String flag = "0";
					String coding_code_id = codeMap.get("coding_code_id")==null?"":codeMap.get("coding_code_id").toString();
					String coding_name = codeMap.get("coding_name")==null?"":codeMap.get("coding_name").toString();
					String superior_code_id = codeMap.get("superior_code_id")==null?"":codeMap.get("superior_code_id").toString();
					for(int j=0;j<jsonArrayCode.length();j++){
						JSONObject object = jsonArrayCode.getJSONObject(j);
						String code_id = object.get("code_id").toString();	//设备编号
						if(coding_code_id.equals(code_id)){
							flag = "1" ;
						}
					}
					Label lbl = null;
					if(superior_code_id.equals("5110000164000000069")){
						lbl = new Label(i+3, 0, coding_name,wc1);
					}else{
						lbl = new Label(i+3, 1, coding_name,wc1);
					}
					Label lblValue = new Label(i+3, 2, flag.equals("1")?"×":"√",wc);
					 try
		              {
		                  ws.addCell(lbl);
		                  ws.addCell(lblValue);
		              } catch (RowsExceededException e1)
		              {
		                  e1.printStackTrace();
		              } catch (WriteException e1)
		              {
		                  e1.printStackTrace();
		              }
				}
				
				 try
	             {
	                 ws.addCell(lbl15);
	                 ws.addCell(bll15);
	             } catch (RowsExceededException e1)
	             {
	                 e1.printStackTrace();
	             } catch (WriteException e1)
	             {
	                 e1.printStackTrace();
	             }
	             try
	             {
	                 // 从内存中写入文件中
	                 wwb.write();
	                 wwb.close();
	             } catch (IOException e)
	             {
	                 e.printStackTrace();
	             } catch (WriteException e)
	             {
	                 e.printStackTrace();
	             }
		 }
       }
	}	
}
package com.bgp.gms.service.rm.dm;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.bgp.dms.util.RSAUtils;
import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
 
import com.bgp.mcs.service.mat.util.ExcelEIResolvingUtil;
import com.bgp.mcs.service.util.mail.SimpleMailSender;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
import com.cnpc.sais.ibp.auth2.util.PasswordUtil;

/**
 * project: 东方物探生产管理系统
 * 
 * creator: dz
 * 
 * creator time:2016-1-12
 * 
 * description:设备相关维护服务
 * 
 */
@Service("DevCommWtcSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevCommWtcSrv extends BaseService{
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IWtcDevSrv wtcDevSrv = new WtcPubDevSrv();
	JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
	/**
	 * NEWMETHOD 物探处自有设备调配申请信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDTDevMainInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = "";
		String pageSize = "";
		String djFlag = msg.getValue("djflag");//dt:自由单台调配  jbq:检波器调配 coll:大港地震仪器
		if("coll".equals(djFlag)){//easyui分页
			currentPage = msg.getValue("page");
			if (currentPage == null || currentPage.trim().equals(""))
				currentPage = "1";
			pageSize = msg.getValue("rows");
			if (pageSize == null || pageSize.trim().equals("")) {
				ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
				pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
			}
		}else{
			currentPage = msg.getValue("currentPage");
			if (currentPage == null || currentPage.trim().equals(""))
				currentPage = "1";
			pageSize = msg.getValue("pageSize");
			if (pageSize == null || pageSize.trim().equals("")) {
				ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
				pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
			}
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String viewFlag = msg.getValue("viewflag");//Y:查看单据     N:调配
		if(StringUtils.isEmpty(viewFlag)){
			viewFlag = "N";
		}
		String projectName = msg.getValue("projectname");
		String deviceAppName = msg.getValue("deviceappname");
		String proOrgName = msg.getValue("proorgname");
		String appOrgId = msg.getValue("apporgid");
		String projectNo = msg.getValue("projectno");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,"
				+ " case when length(dev.project_name) > 16 then substr(dev.project_name, 0, 16) || '...'"
				+ " else dev.project_name end as proname,"
				+ " case when length(dev.mixinfo_name) > 16 then substr(dev.mixinfo_name, 0, 16) || '...'"
				+ " else dev.mixinfo_name end as mixname,dev.*"
				+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,mix.device_mixinfo_id,"
				+ " mix.mixinfo_no,mix.mixinfo_name,sub.org_subjection_id,mix.wapproval_date as appdate,"
				+ " mix.mix_user_id,mix.modifi_date,mix.state,org.org_abbreviation as org_name,mix.project_info_no,"
				+ " mix.org_id,emp.employee_name,case mix.state when '1' then '已提交' else '未提交' end as state_desc,"
				+ " case"
				+ " when sub.org_subjection_id like 'C105001005%' then '塔里木物探处'"
				+ " when sub.org_subjection_id like 'C105001002%' then '新疆物探处'"
				+ " when sub.org_subjection_id like 'C105001003%' then '吐哈物探处'"
				+ " when sub.org_subjection_id like 'C105001004%' then '青海物探处'"
				+ " when sub.org_subjection_id like 'C105005004%' then '长庆物探处'"
				+ " when sub.org_subjection_id like 'C105005000%' then '华北物探处'"
				+ " when sub.org_subjection_id like 'C105005001%' then '新兴物探开发处'"
				+ " when sub.org_subjection_id like 'C105007%' then '大港物探处'"
				+ " when sub.org_subjection_id like 'C105063%' then '辽河物探处'"
				+ " when sub.org_subjection_id like 'C105086%' then '深海物探处'"
				+ " when sub.org_subjection_id like 'C105008%' then '综合物化处'"
				+ " when sub.org_subjection_id like 'C105002%' then '国际勘探事业部'"
				+ " else info.org_abbreviation end as pro_sub_name"
				+ " from gms_device_mixinfo_form mix"
				+ " left join comm_org_information org on mix.out_org_id = org.org_id and org.bsflag = '0'"
				+ " left join comm_human_employee emp on mix.mix_user_id = emp.employee_id and emp.bsflag = '0' "
				+ " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
				+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = mix.out_org_id and sub.bsflag = '0'"
				+ " where mix.bsflag = '0' and mix.mixform_type = '7' ");
		if("jbq".equals(djFlag)){//检波器
			querySql.append(" and mix.mix_type_id = '"+DevConstants.MIXTYPE_JIANBOQI+"'");
		}else if("coll".equals(djFlag)){//地震仪器
			querySql.append(" and mix.mix_type_id = '"+DevConstants.MIXTYPE_YIQI+"'");
		}else{//自有单台
			querySql.append(" and mix.mix_type_id = '"+DevConstants.MIXTYPE_COMMON+"'");
		}
		if("Y".equals(viewFlag)){//查看调配单
			querySql.append(" ) dev where 1 = 1");
		}else{
			querySql.append(" and mix.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%') dev where 1 = 1");
		}
		//项目名称
		if (StringUtils.isNotBlank(projectName)) {
			querySql.append(" and project_name like '%"+projectName+"%'");
		}
		//申请单名称
		if (StringUtils.isNotBlank(deviceAppName)) {
			querySql.append(" and mixinfo_name like '%"+deviceAppName+"%'");
		}
		//项目所属单位
		if (StringUtils.isNotBlank(proOrgName)) {
			querySql.append(" and dev.pro_sub_name || '-' || dev.dui_org_name like '%"+proOrgName+"%'");
		}
		//申请单位名称
		if (StringUtils.isNotBlank(appOrgId)) {
			querySql.append(" and org_subjection_id like '%"+appOrgId+"%'");
		}
		//项目编号
		if (StringUtils.isNotBlank(projectNo)) {
			querySql.append(" and project_info_no = '"+projectNo+"'");
		}
		
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by state nulls first,modifi_date desc,org_id,project_info_no ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处自有设备调配主表信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDTDevBaseInfo(ISrvMsg msg) throws Exception {
		String mixInfoId = msg.getValue("devicemixinfoid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,dev.*"
					+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,mix.device_mixinfo_id,"
					+ " mix.mixinfo_no,mix.mixinfo_name,mix.wapproval_date as appdate,org.org_abbreviation as org_name,"
					+ " emp.employee_name,dy.org_id as pro_org_id,sub.org_subjection_id as pro_sub_id,"
					+ " case mix.state when '1' then '已提交' else '未提交' end as state_desc,"
					+ " case"
					+ " when sub.org_subjection_id like 'C105001005%' then '塔里木物探处'"
					+ " when sub.org_subjection_id like 'C105001002%' then '新疆物探处'"
					+ " when sub.org_subjection_id like 'C105001003%' then '吐哈物探处'"
					+ " when sub.org_subjection_id like 'C105001004%' then '青海物探处'"
					+ " when sub.org_subjection_id like 'C105005004%' then '长庆物探处'"
					+ " when sub.org_subjection_id like 'C105005000%' then '华北物探处'"
					+ " when sub.org_subjection_id like 'C105005001%' then '新兴物探开发处'"
					+ " when sub.org_subjection_id like 'C105007%' then '大港物探处'"
					+ " when sub.org_subjection_id like 'C105063%' then '辽河物探处'"
					+ " when sub.org_subjection_id like 'C105086%' then '深海物探处'"
					+ " when sub.org_subjection_id like 'C105008%' then '综合物化处'"
					+ " when sub.org_subjection_id like 'C105002%' then '国际勘探事业部'"
					+ " else info.org_abbreviation end as pro_sub_name"
					+ " from gms_device_mixinfo_form mix"
					+ " left join comm_org_information org on mix.out_org_id = org.org_id and org.bsflag = '0'"
					+ " left join comm_human_employee emp on mix.mix_user_id = emp.employee_id and emp.bsflag = '0' "
					+ " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
					+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
					+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
					+ " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
					+ " where mix.device_mixinfo_id = '"+mixInfoId+"' ) dev");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 根据设备ID获得设备相关信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String condition = msg.getValue("condition");
		String sql = "select acc.dev_acc_id,acc.dev_name,acc.dev_model,"
				   + " acc.license_num,acc.dev_coding,acc.self_num,"
				   + " acc.dev_sign from gms_device_account acc"
				   + " where acc.dev_acc_id in"+condition;
		List<Map> unitList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 根据设备ID获得检波器设备相关信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryJBQDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String condition = msg.getValue("condition");
		String devMixSubId = msg.getValue("mixsubid");
		String sql = "select '' as device_detail_rid,'' as device_mix_subid,acc.dev_acc_id,acc.dev_name,acc.dev_model,"
				   + " acc.device_id,(nvl(acc.unuse_num, 0) - nvl(dev.assign_num, 0)) as unuse_num"
				   + " from gms_device_coll_account acc"
				   + " left join (select app.dev_acc_id,nvl(sum(app.assign_num), 0) as assign_num"
				   + " from gms_device_appmix_main app"
				   + " left join gms_device_mixinfo_form mix on app.device_mixinfo_id = mix.device_mixinfo_id"
				   + " where app.bsflag = '0' and mix.bsflag = '0' and mix.state != '1' and mix.mixform_type = '7'"
				   + " and app.dev_acc_id is not null and mix.mix_type_id = '"+DevConstants.MIXTYPE_JIANBOQI+"'";
				   if(DevUtil.isValueNotNull(devMixSubId)){
				      sql += " and app.device_mix_subid not in "+devMixSubId;
			       }
			   sql += " group by app.dev_acc_id) dev on dev.dev_acc_id = acc.dev_acc_id"
				    + " where acc.dev_acc_id = '"+condition+"'";
		List<Map> unitList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 根据设备ID获得地震仪器设备相关信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollWtcDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String condition = msg.getValue("condition");
		String devMixSubId = msg.getValue("mixsubid");
		String sql = "select '' as device_detail_rid,'' as device_mix_subid,acc.dev_acc_id,acc.dev_name,acc.dev_model,"
				   + " acc.device_id,(nvl(tech.good_num, 0) - nvl(dev.assign_num, 0)) as unuse_num"
				   + " from gms_device_coll_account acc"
				   + " left join gms_device_coll_account_tech tech on acc.dev_acc_id = tech.dev_acc_id"
				   + " left join (select app.dev_acc_id,nvl(sum(app.assign_num), 0) as assign_num"
				   + " from gms_device_appmix_main app"
				   + " left join gms_device_mixinfo_form mix on app.device_mixinfo_id = mix.device_mixinfo_id"
				   + " where app.bsflag = '0' and mix.bsflag = '0' and mix.state != '1' and mix.mixform_type = '7'"
				   + " and app.dev_acc_id is not null and mix.mix_type_id = '"+DevConstants.MIXTYPE_YIQI+"'";
				   if(DevUtil.isValueNotNull(devMixSubId)){
				      sql += " and app.device_mix_subid not in "+devMixSubId;
			       }
			   sql += " group by app.dev_acc_id) dev on dev.dev_acc_id = acc.dev_acc_id"
				    + " where acc.dev_acc_id = '"+condition+"'";
		List<Map> unitList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 检波器、地震仪器设备返还查询
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryBackDetInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String condition = msg.getValue("condition");
		String backDetId = msg.getValue("backdetid");
		String backDevType = msg.getValue("backdevtype");
		String sql = "select '' as device_backdet_id,acc.dev_name,acc.dev_model,acc.dev_acc_id,acc.actual_in_time,"
				   + " nvl(acc.total_num, 0) as total_num,nvl(nvl(acc.unuse_num, 0) - nvl(back_num, 0)  - nvl(mov_num, 0), 0) as unuse_num,"
		           + " nvl(nvl(acc.use_num, 0) + nvl(back_num, 0)  + nvl(mov_num, 0), 0) as use_num,acc.device_id,"
				   + " unitsd.coding_name as unit_name"
				   + " from gms_device_coll_account_dui acc"
				   + " left join gms_device_collectinfo info on info.device_id = acc.device_id"
				   + " left join comm_coding_sort_detail unitsd on acc.dev_unit = unitsd.coding_code_id"
				   + " left join (select app.dev_acc_id, nvl(sum(app.back_num), 0) as back_num "
				   + " from gms_device_collbackapp_detail app"
				   + " left join gms_device_collbackapp mix on app.device_backapp_id = mix.device_backapp_id"
				   + " where app.bsflag = '0' and mix.bsflag = '0' and mix.state = '0' and app.dev_acc_id is not null";
				   if(DevUtil.isValueNotNull(backDevType,DevConstants.MIXTYPE_ZHUANGBEI_DZYQ)){
					   //装备专业化地震仪器
					   sql += " and mix.backdevtype = '"+DevConstants.MIXTYPE_ZHUANGBEI_DZYQ+"'";
				   }else if(DevUtil.isValueNotNull(backDevType,DevConstants.MIXTYPE_DAGANG_DZYQ)){
					   //大港自有地震仪器
					   sql += " and mix.backdevtype = '"+DevConstants.MIXTYPE_DAGANG_DZYQ+"'";
				   }else{//检波器
					   sql += " and mix.backdevtype = '"+DevConstants.MIXTYPE_JIANBOQI+"'";
				   }
				   if(DevUtil.isValueNotNull(backDetId)){
					   sql += " and app.device_backdet_id not in"+backDetId;
				   }
			   sql += " group by app.dev_acc_id) dev on acc.dev_acc_id = dev.dev_acc_id"
				    + " left join (select det.dev_acc_id, nvl(sum(det.mov_num), 0) as mov_num"
				    + " from gms_device_move_detail det"
                    + " left join gms_device_move mov on det.dev_mov_id = mov.dev_mov_id"
                    + " where mov.bsflag = '0' and mov.move_status = '0'"
                    + " and (mov.dev_type = 'coll' or mov.dev_type = 'wcoll')"
                    + " group by det.dev_acc_id) coll on acc.dev_acc_id = coll.dev_acc_id"
					+ " where acc.dev_acc_id in "+condition;
		List<Map> unitList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处自有设备调配修改操作获得调配单信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDTMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixId = msg.getValue("devmixid");
		StringBuffer sb = new StringBuffer()
			.append( "select pro.project_name,mix.project_info_no,mix.mixinfo_no,mix.device_mixinfo_id,"
					  + " mix.mixinfo_name,emp.employee_name,mix.mix_user_id,info.org_abbreviation,"
					  + " mix.in_org_id,mix.out_org_id,mix.wapproval_date as appdate,sub.org_subjection_id,"
					  + " mix.wapproval_date as appdate from gms_device_mixinfo_form mix"
					  + " left join gp_task_project pro on pro.project_info_no = mix.project_info_no"
					  + " left join comm_human_employee emp on mix.mix_user_id = emp.employee_id and emp.bsflag = '0'"
					  + " left join comm_org_information info on info.org_id = mix.out_org_id and info.bsflag = '0'"
					  + " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
				      + " where mix.device_mixinfo_id = '"+devMixId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 删除、修改、提交物探处调配自有单台、检波器设备单据状态判断
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opDTDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String userSubOrg = user.getOrgSubjectionId();
		String delFlag = "0";
		String mixState = "";
		String devMixId = msg.getValue("devmixid");
		String opFlag = msg.getValue("opflag");
		String devType = msg.getValue("devtype");
		String projectInfoNo = "";
		try{
			String appSql = "select mix.state,mix.project_info_no from gms_device_mixinfo_form mix"
						  + " where mix.device_mixinfo_id = '"+devMixId+"' ";
			Map mixMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(mixMap)){
				mixState = mixMap.get("state").toString();
				projectInfoNo = mixMap.get("project_info_no").toString();
				if("1".equals(mixState)){
					delFlag = "1";//已提交的单据不能删除/修改/提交
				}else{
					if("tj".equals(opFlag)){						
						if(!userSubOrg.startsWith("C105001005")&&//塔里木物探处
								!userSubOrg.startsWith("C105001002")&&//新疆物探处
								!userSubOrg.startsWith("C105001003")&&//吐哈物探处
								!userSubOrg.startsWith("C105001004")&&//青海物探处
								!userSubOrg.startsWith("C105005004")&&//长庆物探处
								!userSubOrg.startsWith("C105005000")&&//华北物探处
								!userSubOrg.startsWith("C105005001")&&//新兴物探处
								!userSubOrg.startsWith("C105007")&&//大港物探处
								!userSubOrg.startsWith("C105063")&&//辽河物探处
								!userSubOrg.startsWith("C105008")&&//综合物化处
								!userSubOrg.startsWith("C105002")&&//国际勘探事业部
								!userSubOrg.startsWith("C105086")){//深海物探处
							delFlag = "4";//用户所在单位不能提交单据	
						}else{
							String delSql = "update gms_device_mixinfo_form"
										  + " set state='1',"
										  + " updator_id='"+user.getEmpId()+"',"
										  + " modifi_date = sysdate"
										  + " where device_mixinfo_id='"+devMixId+"'";
							jdbcDao.executeUpdate(delSql);
							if("DT".equals(devType)){//自有单台设备提交
								delFlag = this.upOpDTDevAccount(msg);
							}else if("JBQ".equals(devType)){//检波器调配提交
								delFlag = this.upOpJBQDevAccount(msg,projectInfoNo);
							}else if("COLL".equals(devType)){//大港自有地震仪器调配提交
								delFlag = this.upOpCollDevAccount(msg,projectInfoNo);
							}else{
								delFlag = "3";
							}
						}
					}else if("del".equals(opFlag)){
						String upSaveFlagSql = "";
						String delSql = "update gms_device_mixinfo_form"
									  + " set bsflag = '1',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where device_mixinfo_id='"+devMixId+"'";
						jdbcDao.executeUpdate(delSql);
						
						if("DT".equals(devType)){//自有单台设备逻辑删除
							upSaveFlagSql = "update gms_device_account"
								          + " set saveflag = '0'"
								          + " where dev_acc_id in"
								          + " (select d.dev_acc_id from gms_device_appmix_detail d"
								          + " where d.device_mix_subid = '"+devMixId+"')";
						}else{
							upSaveFlagSql = "update gms_device_appmix_main"
				                 		  + " set bsflag = '1',"
				                 		  + " updator_id = '"+user.getEmpId()+"',"
										  + " modifi_date = sysdate"
										  + " where device_mixinfo_id='"+devMixId+"'";
						}
						jdbcDao.executeUpdate(upSaveFlagSql);
					}
				}
			}else{
				delFlag = "3";//删除/提交/修改失败
			}
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除/提交/修改失败
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 单台设备调配提交
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String upOpDTDevAccount(ISrvMsg msg) throws Exception {
		String delFlag = "0";
		try{
			String devMixId = msg.getValue("devmixid");
			String proOrgId = msg.getValue("pro_org_id");//项目所在小队org_id
			String proSubId = msg.getValue("pro_sub_id");//项目所在小队org_sub_id
			String proOrgName = msg.getValue("pro_org_name");////项目所在小队名称
			
			String upAccSql = "update gms_device_account"
							+ " set saveflag = '1',"
							+ " ifunused = '0',"
							+ " using_stat = '"+DevConstants.DEV_USING_ZAIYONG+"',"
							+ " usage_org_id = '"+proOrgId+"',"
							+ " usage_sub_id = '"+proSubId+"',"
							+ " usage_org_name = '"+proOrgName+"'"
							+ " where dev_acc_id in"
							+ " (select d.dev_acc_id from gms_device_appmix_detail d"
							+ " where d.device_mix_subid='"+devMixId+"')";
			jdbcDao.executeUpdate(upAccSql);
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";
		}
		return delFlag;
	}
	/**
	 * NEWMETHOD 检波器设备调配提交
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String upOpJBQDevAccount(ISrvMsg msg,String projectNo) throws Exception {
		UserToken user = msg.getUserToken();
		String delFlag = "0";
		String devMixId = msg.getValue("devmixid");
		String mixDetSql = "select app.dev_ci_code,app.dev_acc_id,app.assign_num"
						 + " from gms_device_appmix_main app"
						 + " where app.device_mixinfo_id = '" + devMixId + "' ";
		List<Map> dataList = jdbcDao.queryRecords(mixDetSql);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (Map dataMap : dataList) {
			String devAccId = dataMap.get("dev_acc_id").toString();
			String assignNum = (String)dataMap.get("assign_num");
			
			// 更新公司台帐数据
			String colsql = "select dev_acc_id,nvl(use_num,0) as use_num,nvl(unuse_num,0) as unuse_num"
				          + " from gms_device_coll_account t where t.dev_acc_id='"+devAccId+"'";
			Map<String, Object> colMap = jdbcDao.queryRecordBySQL(colsql);
			if (MapUtils.isNotEmpty(colMap)) {
				String unuseNum = (String) colMap.get("unuse_num");
				String useNum = (String) colMap.get("use_num");
				int unUseNumTmp = Integer.parseInt(unuseNum)-Integer.parseInt(assignNum);
				int useNumTmp = Integer.parseInt(useNum)+Integer.parseInt(assignNum);
				if(unUseNumTmp < 0 || useNumTmp < 0 ){
					delFlag = "3";//删除/提交/修改失败
					break;
				}
				dataMap.put("dev_acc_id", devAccId);
				dataMap.put("unuseNumTmp", String.valueOf(unUseNumTmp));
				dataMap.put("useNumTmp", String.valueOf(useNumTmp));
				dataMap.put("project_info_no", projectNo);
				dataMap.put("device_mixinfo_id", devMixId);
				dataMap.put("assign_num", assignNum);
				dataMap.put("modifier", user.getEmpId());
				datasList.add(dataMap);
			}else{
				delFlag = "3";//删除/提交/修改失败
				break;
			}
		}
		if("0".equals(delFlag)){
			String upDevSaveSql = "update gms_device_coll_account set"
								+ " unuse_num = ?,"
								+ " use_num = ?,"
								+ " modifier = ?,"
								+ " modifi_date = sysdate"
								+ " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDevSaveSql,
			new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					Map<String, Object> devSaveMap = datasList.get(i);
					ps.setInt(1,  Integer.parseInt((String) devSaveMap.get("unuseNumTmp")));
					ps.setInt(2, Integer.parseInt((String) devSaveMap.get("useNumTmp")));
					ps.setString(3, (String) devSaveMap.get("modifier"));
					ps.setString(4, (String) devSaveMap.get("dev_acc_id"));
				}
				@Override
				public int getBatchSize() {
					return datasList.size();
				}
			});
			//插入到公司级的采集设备动态表 GMS_DEVICE_COLL_DYM
			String insDymDevSql = "insert into gms_device_coll_dym("
								+ " dev_dyminfo_id,"
								+ " dev_acc_id,"
								+ " oprtype,"
								+ " project_info_no,"
								+ " device_appmix_id,"
								+ " collnum,"
								+ " alter_date,"
								+ " indb_date,"
								+ " format_date"
								+ " )values(?,?,?,?,?,?,sysdate,sysdate,to_date(?,'yyyy-mm-dd'))";
			jdbcDao.getJdbcTemplate().batchUpdate(insDymDevSql,
			new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					Map<String, Object> devSaveMap = datasList.get(i);
					ps.setString(1, jdbcDao.generateUUID());
					ps.setString(2, (String) devSaveMap.get("dev_acc_id"));
					ps.setString(3, DevConstants.DYM_OPRTYPE_OUT);
					ps.setString(4, (String) devSaveMap.get("project_info_no"));
					ps.setString(5, (String) devSaveMap.get("device_mixinfo_id"));
					ps.setInt(6, Integer.parseInt((String) devSaveMap.get("assign_num")));
					ps.setString(7, DevConstants.DEV_FORMAT_DATE);
				}
				@Override
				public int getBatchSize() {
					return datasList.size();
				}
			});
		}
		return delFlag;
	}
	/**
	 * NEWMETHOD 大港自有地震仪器设备调配提交
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String upOpCollDevAccount(ISrvMsg msg,String projectNo) throws Exception {
		UserToken user = msg.getUserToken();
		String delFlag = "0";
		String devMixId = msg.getValue("devmixid");
		String mixDetSql = "select app.dev_ci_code,app.dev_acc_id,app.assign_num"
						 + " from gms_device_appmix_main app"
						 + " where app.device_mixinfo_id = '" + devMixId + "' ";
		List<Map> dataList = jdbcDao.queryRecords(mixDetSql);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (Map dataMap : dataList) {
			String devAccId = dataMap.get("dev_acc_id").toString();
			String assignNum = (String)dataMap.get("assign_num");
			
			// 更新公司台帐数据
			String colsql = "select t.dev_acc_id,nvl(tech.good_num,0) as unuse_num"
				          + " from gms_device_coll_account t"
				          + " left join gms_device_coll_account_tech tech on tech.dev_acc_id = t.dev_acc_id"
				          + " where t.dev_acc_id='"+devAccId+"'";
			Map<String, Object> colMap = jdbcDao.queryRecordBySQL(colsql);
			if (MapUtils.isNotEmpty(colMap)) {
				String unuseNum = (String) colMap.get("unuse_num");
				int unUseNumTmp = Integer.parseInt(unuseNum)-Integer.parseInt(assignNum);
				if(unUseNumTmp < 0){
					delFlag = "3";//删除/提交/修改失败
					break;
				}
				dataMap.put("dev_acc_id", devAccId);
				dataMap.put("unuseNumTmp", String.valueOf(unUseNumTmp));
				dataMap.put("project_info_no", projectNo);
				dataMap.put("device_mixinfo_id", devMixId);
				dataMap.put("assign_num", assignNum);
				dataMap.put("modifier", user.getEmpId());
				datasList.add(dataMap);
			}else{
				delFlag = "3";//删除/提交/修改失败
				break;
			}
		}
		if("0".equals(delFlag)){
			String upDevSaveSql = "update gms_device_coll_account_tech set"
								+ " good_num = ?"
								+ " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDevSaveSql,
			new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					Map<String, Object> devSaveMap = datasList.get(i);
					ps.setInt(1, Integer.parseInt((String) devSaveMap.get("unuseNumTmp")));
					ps.setString(2, (String) devSaveMap.get("dev_acc_id"));
				}
				@Override
				public int getBatchSize() {
					return datasList.size();
				}
			});
			//更新修改人及修改时间
			String upDevAccSql = "update gms_device_coll_account set"
							   + " modifier = ?,"
							   + " modifi_date = sysdate"
							   + " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDevAccSql,
			new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					Map<String, Object> devModMap = datasList.get(i);
					ps.setString(1, (String) devModMap.get("modifier"));
					ps.setString(2, (String) devModMap.get("dev_acc_id"));
				}
				@Override
				public int getBatchSize() {
					return datasList.size();
				}
			});
			//插入到公司级的采集设备动态表 GMS_DEVICE_COLL_DYM
			String insDymDevSql = "insert into gms_device_coll_dym("
								+ " dev_dyminfo_id,"
								+ " dev_acc_id,"
								+ " oprtype,"
								+ " project_info_no,"
								+ " device_appmix_id,"
								+ " collnum,"
								+ " alter_date,"
								+ " indb_date,"
								+ " format_date"
								+ " )values(?,?,?,?,?,?,sysdate,sysdate,to_date(?,'yyyy-mm-dd'))";
			jdbcDao.getJdbcTemplate().batchUpdate(insDymDevSql,
			new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					Map<String, Object> devSaveMap = datasList.get(i);
					ps.setString(1, jdbcDao.generateUUID());
					ps.setString(2, (String) devSaveMap.get("dev_acc_id"));
					ps.setString(3, DevConstants.DYM_OPRTYPE_OUT);
					ps.setString(4, (String) devSaveMap.get("project_info_no"));
					ps.setString(5, (String) devSaveMap.get("device_mixinfo_id"));
					ps.setInt(6, Integer.parseInt((String) devSaveMap.get("assign_num")));
					ps.setString(7, DevConstants.DEV_FORMAT_DATE);
				}
				@Override
				public int getBatchSize() {
					return datasList.size();
				}
			});
		}
		return delFlag;
	}
	/**
	 * NEWMETHOD 物探处单台设备调配
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateDTDevInfo(ISrvMsg msg) throws Exception {
		//董志测试事务用的
/*		try{
		String upSaveFlagSql = "update gms_device_account_dui set bsflag = '1' where dev_acc_id = '8ad878dd3a725f66013a72b5501d017d' "
				 			 + " or dev_acc_id = '8ad878dd3a725f66013a72c42f7d01ba'";
		jdbcDao.executeUpdate(upSaveFlagSql);
		String upSaveFlagSql1 = "update gms_device_account_dui set dev_coding = '900006204580' where dev_acc_id1 = '8ad891d73a6db9a0013a6dd838c40132' ";
		jdbcDao.executeUpdate(upSaveFlagSql1);
		}catch(Exception e){
			System.out.println("11111111111111111111");
			//TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			throw new RuntimeException(); 
		}*/
		
		
		String projectInfoNo = msg.getValue("projectInfoNo");
		String mixInfoId = wtcDevSrv.saveDevMixForm(msg, "DT");
		// 更新台帐表中标识
		String upSaveFlagSql = "update gms_device_account t set t.saveflag='0' where t.dev_acc_id in "
							 + " (select d.dev_acc_id from gms_device_appmix_detail d where d.device_mix_subid='"
							 + mixInfoId + "')";
		jdbcDao.executeUpdate(upSaveFlagSql);
		String delSql = "delete from gms_device_appmix_detail t where t.device_mix_subid='"
					  + mixInfoId + "'";
		jdbcDao.executeUpdate(delSql);
		
		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("device_mix_subid", mixInfoId);
			dataMap.put("project_no", projectInfoNo);
			datasList.add(dataMap);
		}
		String insMixDetSql = "insert into gms_device_appmix_detail(device_mix_detid,dev_acc_id,state,device_mix_subid,project_no)values(?,?,?,?,?)";
		jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) devSaveMap.get("dev_acc_id"));
						ps.setString(3, "0");//接收状态state
						ps.setString(4, (String) devSaveMap.get("device_mix_subid"));
						ps.setString(5, (String) devSaveMap.get("project_no"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		//更新台账标识
		String upDevSaveSql = "update gms_device_account set saveflag='1' where dev_acc_id = ? ";
		jdbcDao.getJdbcTemplate().batchUpdate(upDevSaveSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devUpMap = datasList.get(i);
						ps.setString(1, (String) devUpMap.get("dev_acc_id"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处调配自有设备、调剂闲置设备明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDTApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixId = msg.getValue("devmixid");
		String sql = "select acc.dev_name,acc.dev_model,acc.self_num,acc.dev_sign,acc.license_num,"
				   + " acc.dev_coding,case det.state when '1' then '已接收' else '未接收' end as state_desc,"
				   + " det.dev_acc_id,det.actual_in_time,det.dev_plan_start_date,"
				   + " det.dev_plan_end_date from gms_device_appmix_detail det"
				   + " left join gms_device_account acc on acc.dev_acc_id = det.dev_acc_id"
				   + " where det.device_mix_subid = '"+devMixId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处调配检波器明细信息(显示检波器调配明细，不显示闲置数量)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryJBQApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixId = msg.getValue("devmixid");
		String sql = "select app.device_detail_rid,acc.dev_name,acc.dev_model,app.assign_num,app.state,"
				   + " case app.state when '9' then '已接收' else '未接收' end as state_desc "
				   + " from gms_device_appmix_main app"
				   + " left join gms_device_coll_account acc on acc.dev_acc_id = app.dev_acc_id"
				   + " where app.device_mixinfo_id = '"+devMixId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 大港物探处调配地震仪器明细信息(显示检波器调配明细，不显示闲置数量)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String devMixId = msg.getValue("devmixid");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select app.device_detail_rid,acc.dev_name,acc.dev_model,app.assign_num,app.state,"
				   + " case app.state when '9' then '已接收' else '未接收' end as state_desc "
				   + " from gms_device_appmix_main app"
				   + " left join gms_device_coll_account acc on acc.dev_acc_id = app.dev_acc_id"
				   + " where app.device_mixinfo_id = '"+devMixId+"'");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处调配检波器明细信息(修改检波器调配单时使用)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryJBQSavedApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixId = msg.getValue("devmixid");
		String sql = "select app.device_detail_rid,acc.dev_acc_id,acc.device_id,acc.dev_name,acc.dev_model,app.assign_num,"
				   + " app.device_mix_subid,(nvl(acc.unuse_num,0) - nvl(dev.assign_num,0)) as unuse_num"
				   + " from gms_device_appmix_main app"
				   + " left join gms_device_coll_account acc on acc.dev_acc_id = app.dev_acc_id"
				   + " left join (select main.dev_acc_id,nvl(sum(main.assign_num), 0) as assign_num"
				   + " from gms_device_appmix_main main"
				   + " left join gms_device_mixinfo_form mix on main.device_mixinfo_id = mix.device_mixinfo_id"
				   + " where main.bsflag = '0' and mix.bsflag = '0' and mix.state != '1' and mix.mixform_type = '7'"
				   + " and main.dev_acc_id is not null and mix.mix_type_id = '"+DevConstants.MIXTYPE_JIANBOQI+"'"
				   + " and mix.device_mixinfo_id !='"+devMixId+"' group by main.dev_acc_id) dev"
				   + " on dev.dev_acc_id = acc.dev_acc_id"
				   + " where app.device_mixinfo_id = '"+devMixId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 大港物探处调配地震仪器明细信息(修改地震仪器调配单时使用)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollSavedApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixId = msg.getValue("devmixid");
		String sql = "select app.device_detail_rid,acc.dev_acc_id,acc.device_id,acc.dev_name,acc.dev_model,app.assign_num,"
				   + " app.device_mix_subid,(nvl(tech.good_num,0) - nvl(dev.assign_num,0)) as unuse_num"
				   + " from gms_device_appmix_main app"
				   + " left join gms_device_coll_account acc on acc.dev_acc_id = app.dev_acc_id"
				   + " left join gms_device_coll_account_tech tech on acc.dev_acc_id = tech.dev_acc_id"
				   + " left join (select main.dev_acc_id,nvl(sum(main.assign_num), 0) as assign_num"
				   + " from gms_device_appmix_main main"
				   + " left join gms_device_mixinfo_form mix on main.device_mixinfo_id = mix.device_mixinfo_id"
				   + " where main.bsflag = '0' and mix.bsflag = '0' and mix.state != '1' and mix.mixform_type = '7'"
				   + " and main.dev_acc_id is not null and mix.mix_type_id = '"+DevConstants.MIXTYPE_YIQI+"'"
				   + " and mix.device_mixinfo_id !='"+devMixId+"' group by main.dev_acc_id) dev"
				   + " on dev.dev_acc_id = acc.dev_acc_id"
				   + " where app.device_mixinfo_id = '"+devMixId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处自有设备接收明细信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDTDevDetInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String devMixId = msg.getValue("devmixid");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select case dad.state when '1' then '已接收' else '未接收' end as state_desc,"
					 + " da.dev_name,da.dev_model,da.self_num,da.license_num,da.dev_sign,da.dev_coding,"
					 + " dad.actual_in_time,da.dev_position,dad.device_mix_detid"
					 + " from gms_device_mixinfo_form dm"
					 + " left join gms_device_appmix_detail dad on dm.device_mixinfo_id = dad.device_mix_subid"
					 + " left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id"
					 + " where dm.device_mixinfo_id='"+devMixId+"'");
		//设备名称
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and da.dev_name like '%"+devName+"%'");
		}
		//设备型号
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and da.dev_model like '%"+devModel+"%'");
		}
		querySql.append(" order by dad.state nulls first,dad.device_mix_detid ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询物探处直接调配自有设备接收的明细基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevDTRecDetInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String devDetId = msg.getValue("devdetid");
		StringBuffer sb = new StringBuffer();
				sb.append("select case dad.state when '1' then '已接收' else '未接收' end as state_desc,"
						+ " da.dev_name,da.dev_model,da.dev_coding,da.self_num,da.license_num,da.dev_sign,"
						+ " da.dev_position,dad.actual_in_time,dad.dev_acc_id,dad.team_dev_acc_id"
						+ " from gms_device_appmix_detail dad"
						+ " left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id"
						+ " where dad.device_mix_detid = '" + devDetId + "'");
		Map devRecMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devRecMap)) {
			responseMsg.setValue("devRecMap", devRecMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 判断设备是否已经接收
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg recDTDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devDetIds = msg.getValue("devdetids");
		String recFlag = "0";
		String idss = "";
		String[] detInfo = devDetIds.split(",",-1);
		try{
			String appSql = "select * from gms_device_appmix_detail det where det.state = '1'"
						  + " and det.device_mix_detid in (";
			for(int i=0;i<detInfo.length;i++){
				if(!"".equals(idss)){ 
					idss += ",";
				}
				idss += "'"+detInfo[i]+"'";
			}
			appSql = appSql+idss+")";
			
			Map recMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(recMap)){
				recFlag = "1";//存在已接收的设备
			}
		}catch(Exception e){
			recFlag = "3";//操作失败
		}
		responseDTO.setValue("datas", recFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处自有设备接收设备明细显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDTDevRecInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String devMixDetId = msg.getValue("devmixdetid");
		String idss = "";
		String[] detInfo = devMixDetId.split(",",-1);
		String recSql = "select da.dev_name,da.dev_model,da.dev_coding,da.self_num,"
					 + " da.license_num,da.dev_sign,da.dev_type,da.dev_acc_id from gms_device_appmix_detail dad"
					 + " left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id"
					 + " where dad.device_mix_detid in (";
					 for(int i=0;i<detInfo.length;i++){
							if(!"".equals(idss)){ 
								idss += ",";
							}
							idss += "'"+detInfo[i]+"'";
						}
					 recSql = recSql+idss+")";
		page = pureDao.queryRecordsBySQL(recSql, page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 获得接收设备的存放地及项目的国内/国外标识
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevDTRecFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixId = msg.getValue("devmixid");
		String recSql = "select rownum,t.dev_position,t.project_country from"
				+ " (select pro.project_country,da.dev_position"
				+ " from gms_device_appmix_detail dad"
				+ " left join gp_task_project pro on dad.project_no = pro.project_info_no and pro.bsflag = '0'"
				+ " left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id"
				+ " where dad.device_mix_subid = '"+devMixId+"' order by da.modifi_date desc ) t where rownum=1";
		List<Map> recList= jdbcDao.queryRecords(recSql);
		responseDTO.setValue("datas", recList);
		return responseDTO;
	}
	/**
	 * 物探处自有单台设备明细提交操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDTDevReceive(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		DeviceMCSBean devbean = new DeviceMCSBean();
		String projectType = user.getProjectType();
		String devMixDetId = msg.getValue("devmixdetid");
		String devMixId = msg.getValue("devmixid");
		String actualStartDate= msg.getValue("actual_start_date");
		String provPos = msg.getValue("provpos");// 存放地(省份+市+县区+驻地)
		String provPosCode = msg.getValue("provposcode");// 存放地(省份+市+县区+驻地)编码
		String dgFlag = msg.getValue("dgflag");//是否为大港项目标识
		String mixTypeId = msg.getValue("mixtypeid");
		
		if (DevUtil.isValueNotNull(devMixDetId)) {
			String[] orders = devMixDetId.split(",",-1);
			final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
			for (int j = 0; j < orders.length; j++) {
				String querySql = "select dad.dev_acc_id,mif.in_org_id,mif.out_org_id,mif.project_info_no,"
					   			+ " dev_plan_end_date,dev_plan_end_date from gms_device_appmix_detail dad"
					   			+ " left join gms_device_mixinfo_form mif on mif.device_mixinfo_id = dad.device_mix_subid"
					   			+ " left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id"
					   			+ " where dad.device_mix_detid='" + orders[j] + "'";
				Map queryMap = jdbcDao.queryRecordBySQL(querySql);
				if (MapUtils.isNotEmpty(queryMap)) {
					String devAccId = (String) queryMap.get("dev_acc_id");
					String projectInfoNo = (String) queryMap.get("project_info_no");
					String inOrgId = (String) queryMap.get("in_org_id");
					String outOrgId = (String) queryMap.get("out_org_id");
					String startDate = (String) queryMap.get("dev_plan_start_date");
					String endDate = (String) queryMap.get("dev_plan_end_date");
					
					// 将设备插入到队级台帐
					Map<String, Object> duiMap = devbean.queryDevAccInfo(devAccId);
					String searchid = UUID.randomUUID().toString().replaceAll("-", "");
					duiMap.put("search_id", searchid);
					duiMap.remove("dev_acc_id");
					duiMap.put("fk_dev_acc_id", devAccId);
					duiMap.put("project_info_id", projectInfoNo);
					duiMap.put("actual_in_time",actualStartDate);
					duiMap.put("fk_device_appmix_id", orders[j]);
					duiMap.put("using_stat", DevConstants.DEV_USING_ZAIYONG);
					duiMap.put("mix_type_id", mixTypeId);
					duiMap.put("in_org_id", inOrgId);
					duiMap.put("out_org_id", outOrgId);
					duiMap.put("position_id", provPosCode);
					duiMap.put("dev_position", provPos);
					duiMap.put("planning_in_time", startDate);
					duiMap.put("planning_out_time", endDate);
					duiMap.put("creator", user.getEmpId());
					duiMap.put("create_date", DevUtil.getCurrentTime());
					duiMap.put("modifier", user.getEmpId());
					duiMap.put("modifi_date", DevUtil.getCurrentTime());
					Serializable curid = jdbcDao.saveOrUpdateEntity(duiMap,"gms_device_account_dui");
					
					Map<String, Object> dataMap = new HashMap<String, Object>();
					dataMap.put("dev_acc_id", devAccId);
					dataMap.put("device_mixinfo_id", devMixId);
					dataMap.put("project_info_no", projectInfoNo);
					dataMap.put("prov_pos", provPos);
					dataMap.put("actual_in_time", actualStartDate);
					dataMap.put("device_mix_detid", orders[j]);
					dataMap.put("team_dev_acc_id", curid.toString());
					datasList.add(dataMap);

					// 将作业信息插入设备作业信息表
					String[] taskids = msg.getValue("taskids").split("~", -1);
					if (!projectType.equals("5000100004000000009") 
								&& !projectType.equals("5000100004000000008") 
									&& "Y".equals(dgFlag)) {
						for (int i = 0; i < taskids.length; i++) {
							Map<String, Object> Map_proecss = devbean.queryDevProcess(orders[j]);
							Map_proecss.put("project_info_no", projectInfoNo);
							Map_proecss.put("task_id", taskids[i]);
							jdbcDao.saveOrUpdateEntity(Map_proecss,"gms_device_receive_process");
						}
					}
				}
			}
			//更新台账标识
			String upDevSaveSql = "update gms_device_account set "
								+ " saveflag='1',"
								+ " ifunused='0',"
								+ " using_stat='"+DevConstants.DEV_USING_ZAIYONG+"',"
								+ " project_info_no=?,"
								+ " search_id='',"
								+ " modifi_date=sysdate,"
								+ " dev_position = '"+provPos+"',"
								+ " position_id = '"+provPosCode+"'"
								+ " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDevSaveSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devUpMap = datasList.get(i);
							ps.setString(1, (String) devUpMap.get("project_info_no"));
							ps.setString(2, (String) devUpMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
			//更新调配明细表
			String upDetSaveSql = "update gms_device_appmix_detail set "
								+ " team_dev_acc_id=?,"
								+ " actual_in_time=to_date(?,'yyyy-mm-dd hh24:mi:ss'),"
								+ " state='1'"
								+ " where device_mix_detid = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDetSaveSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devUpMap = datasList.get(i);
							ps.setString(1, (String) devUpMap.get("team_dev_acc_id"));
							ps.setString(2, (String) devUpMap.get("actual_in_time"));
							ps.setString(3, (String) devUpMap.get("device_mix_detid"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
			//插入设备动态信息表
			String insDymDevSql = "insert into gms_device_dyminfo("
								+ " dev_dyminfo_id,"
								+ " dev_acc_id,"
								+ " device_appmix_id,"
								+ " project_info_no,"
								+ " oprtype,"
								+ " alter_date,"
								+ " indb_date"
								+ " )values(?,?,?,?,?,sysdate,sysdate)";
			jdbcDao.getJdbcTemplate().batchUpdate(insDymDevSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devSaveMap = datasList.get(i);
							ps.setString(1, jdbcDao.generateUUID());
							ps.setString(2, (String) devSaveMap.get("dev_acc_id"));
							ps.setString(3, (String) devSaveMap.get("device_mix_detid"));
							ps.setString(4, (String) devSaveMap.get("project_info_no"));
							ps.setString(5, DevConstants.DYM_OPRTYPE_OUT);
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
			
			String updatesql1 = "update gms_device_mixinfo_form mif set opr_state='1' "
					+ "where exists (select 1 from GMS_DEVICE_APPMIX_DETAIL dad "
					+ "where dad.device_mix_subid='"
					+ devMixId
					+ "' and dad.state='1') "
					+ "and exists(select 1 from GMS_DEVICE_APPMIX_DETAIL dad "
					+ "where dad.device_mix_subid='"
					+ devMixId
					+ "' and (dad.state!='1' or dad.state is null)) "
					+ "and mif.device_mixinfo_id = '" + devMixId + "' ";
			String updatesql2 = "update gms_device_mixinfo_form mif set opr_state='9' "
					+ "where exists (select 1 from GMS_DEVICE_APPMIX_DETAIL dad "
					+ "where dad.device_mix_subid='"
					+ devMixId
					+ "' and dad.state='1') "
					+ "and not exists(select 1 from GMS_DEVICE_APPMIX_DETAIL dad "
					+ "where dad.device_mix_subid='"
					+ devMixId
					+ "' and (dad.state!='1' or dad.state is null))"
					+ "and mif.device_mixinfo_id = '" + devMixId + "' ";
			jdbcDao.executeUpdate(updatesql1);
			jdbcDao.executeUpdate(updatesql2);
		}
		
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 设备重新接收修改接收时间
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDTDevReReceive(ISrvMsg msg) throws Exception {
		String actualInTime = msg.getValue("dev_actual_in_time");
		String devAccId = msg.getValue("devaccid"); //多项目台账ID
		String teamDevAccId = msg.getValue("teamdevaccid");//队级台账ID
		String devMixDetId = msg.getValue("devmixdetid");
		String projectInfoNo = msg.getValue("projectinfono");
		
		Map<String, Object> mapDui = new HashMap<String, Object>();
		mapDui.put("dev_acc_id", teamDevAccId);
		mapDui.put("actual_in_time", actualInTime);
		jdbcDao.saveOrUpdateEntity(mapDui, "gms_device_account_dui");
		
		Map<String, Object> mapMix = new HashMap<String, Object>();
		mapMix.put("device_mix_detid", devMixDetId);
		mapMix.put("team_dev_acc_id", teamDevAccId);
		mapMix.put("actual_in_time", actualInTime);
		mapMix.put("state", "1");
		jdbcDao.saveOrUpdateEntity(mapMix, "gms_device_appmix_detail");

		jdbcDao.executeUpdate("delete from gms_device_dyminfo where dev_acc_id='"
				+ devAccId
				+ "' and device_appmix_id='"
				+ devMixDetId
				+ "' and oprtype='"
				+ DevConstants.DYM_OPRTYPE_OUT + "' ");

		Map<String, Object> mapDymInfo = new HashMap<String, Object>();
		mapDymInfo.put("dev_acc_id", devAccId);
		mapDymInfo.put("device_appmix_id", devMixDetId);
		mapDymInfo.put("project_info_no", projectInfoNo);
		mapDymInfo.put("oprtype", DevConstants.DYM_OPRTYPE_OUT);
		mapDymInfo.put("alter_date", DevUtil.getCurrentTime());
		mapDymInfo.put("indb_date", DevUtil.getCurrentTime());
		jdbcDao.saveOrUpdateEntity(mapDymInfo, "gms_device_dyminfo");
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 获得检波器树结构及限制数量
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWtcJbqTreeInfo(ISrvMsg msg) throws Exception{
		String nodeid = msg.getValue("node");
		String outOrgId = msg.getValue("outOrgId");
		String devMixSubId = msg.getValue("mixsubid");
		//1. 第一次进来
		if ("root".equals(nodeid)) {
			//查询根节点
			String sql = "select 0 as unuse_num,'~~0~0' as id,'false' as leaf,'检波器编码树' as name,'' as code,0 as is_leaf,"
				       + " 0 as node_level,'' as dev_acc_id,'' as device_id from dual ";
			
			List list = jdbcDao.queryRecords(sql.toString());
			Map dataMap = (Map)list.get(0);			
			JSONArray jsonArray = JSONArray.fromObject(dataMap);			
			ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);
			
			if (jsonArray == null) {
				outmsg.setValue("json", "[]");
			} else {
				outmsg.setValue("json", jsonArray.toString());
			}
			return outmsg;
		}else{
			//3. 分级加载：根据传入的nodeid得到下一级的设备类别和设备编码
			String sql = "select (nvl(acc.unuse_num,0) - nvl(dev.assign_num,0)) as unuse_num,"
					   + " coll.device_id||'~'||coll.dev_code||'~'||coll.node_level||'~'||coll.is_leaf as id,"
					   + " case coll.is_leaf when 0 then 'false' else 'true' end as leaf,"
					   + " case when coll.is_leaf=0 then coll.dev_name else coll.dev_name||'('||coll.dev_model||')' end as name,"
					   + " coll.dev_code as code,coll.is_leaf,coll.node_level,acc.dev_acc_id,coll.device_id"
					   + " from gms_device_collectinfo coll"
					   + " left join gms_device_coll_account acc on acc.device_id = coll.device_id and acc.bsflag = '0'"
					   + " and acc.owning_org_id = '"+outOrgId+"'"
					   + " left join (select app.dev_acc_id,nvl(sum(app.assign_num), 0) as assign_num"
					   + " from gms_device_appmix_main app "
					   + " left join gms_device_mixinfo_form mix on app.device_mixinfo_id = mix.device_mixinfo_id "
					   + " where app.bsflag = '0' and mix.bsflag = '0' and mix.state != '1' and mix.mixform_type = '7'"
					   + " and app.dev_acc_id is not null and mix.mix_type_id = '"+DevConstants.MIXTYPE_JIANBOQI+"'";
					   if( devMixSubId != null && !"null".equals(devMixSubId) && !"".equals(devMixSubId)){
						   sql += " and app.device_mix_subid not in "+devMixSubId;
					   }
					   sql += " group by app.dev_acc_id) dev on dev.dev_acc_id = acc.dev_acc_id ";
			
			String[] keyinfos = nodeid.split("~",-1);
			if(keyinfos[0]!=null&&!"".equals(keyinfos[0])){
				sql += "where coll.node_parent_id='"+keyinfos[0]+"' ";
			}else {
				sql += "where (coll.dev_code='04' or coll.dev_code='06') and coll.node_parent_id is null ";
			}
			sql += "order by unuse_num desc";
			List list = jdbcDao.queryRecords(sql.toString());			
			JSONArray retJson = JSONArray.fromObject(list);			
			ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);
			
			if(retJson == null){
				outmsg.setValue("json", "[]");
			}else {
				outmsg.setValue("json", retJson.toString());
			}			
			return outmsg;
		}
	}
	/**
	 * NEWMETHOD 物探处直接调配地震仪器检波器设备保存
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateCOLLJBQDevInfo(ISrvMsg msg) throws Exception {
		
		UserToken user = msg.getUserToken();
		String devType = msg.getValue("devtype");
		String mixInfoId = wtcDevSrv.saveDevMixForm(msg, devType);
		String employeeId = msg.getValue("employee_id");

		String delSql = "delete from gms_device_appmix_main t where t.device_mixinfo_id='"
					  + mixInfoId + "'";
		jdbcDao.executeUpdate(delSql);
		
		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		String[] devIdInfos = msg.getValue("devidinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("device_id", devIdInfos[index]);
			dataMap.put("device_mixinfo_id", mixInfoId);
			dataMap.put("assign_num", msg.getValue("outnum" + idInfos[index]));
			dataMap.put("assign_emp_id", employeeId);
			dataMap.put("org_id", user.getOrgId());
			dataMap.put("org_subjection_id", user.getOrgSubjectionId());
			dataMap.put("device_detail_rid", msg.getValue("device_detail_rid"+index));
			datasList.add(dataMap);
		}
		String insMixDetSql = "insert into gms_device_appmix_main(device_mix_subid,device_mixinfo_id,dev_ci_code,assign_num,"
							+ " assign_emp_id,bsflag,create_date,creator_id,modifi_date,updator_id,org_id,org_subjection_id,"
							+ " state,dev_acc_id,device_detail_rid)values(?,?,?,?,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?,?,?,?,?)";
		jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) devSaveMap.get("device_mixinfo_id"));
						ps.setString(3, (String) devSaveMap.get("device_id"));
						ps.setString(4, (String) devSaveMap.get("assign_num"));
						ps.setString(5, (String) devSaveMap.get("assign_emp_id"));
						ps.setString(6, DevConstants.STATE_SAVED);
						ps.setString(7, DevUtil.getCurrentTime());
						ps.setString(8, (String) devSaveMap.get("assign_emp_id"));
						ps.setString(9, DevUtil.getCurrentTime());
						ps.setString(10, (String) devSaveMap.get("assign_emp_id"));
						ps.setString(11, (String) devSaveMap.get("org_id"));
						ps.setString(12, (String) devSaveMap.get("org_subjection_id"));
						ps.setString(13, DevConstants.STATE_SAVED);
						ps.setString(14, (String) devSaveMap.get("dev_acc_id"));
						ps.setString(15, (String) devSaveMap.get("device_detail_rid"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 获得地震仪器结构及限制数量
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWtcCollTreeInfo(ISrvMsg msg) throws Exception{
		String nodeid = msg.getValue("node");
		String outOrgId = msg.getValue("outOrgId");
		String devMixSubId = msg.getValue("mixsubid");
		//1. 第一次进来
		if ("root".equals(nodeid)) {
			//查询根节点
			String sql = "select 0 as unuse_num,'~~0~0' as id,'false' as leaf,'地震仪器编码树' as name,'' as code,0 as is_leaf,"
				       + " 0 as node_level,'' as dev_acc_id,'' as device_id from dual ";
			
			List list = jdbcDao.queryRecords(sql.toString());
			Map dataMap = (Map)list.get(0);			
			JSONArray jsonArray = JSONArray.fromObject(dataMap);			
			ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);
			
			if (jsonArray == null) {
				outmsg.setValue("json", "[]");
			} else {
				outmsg.setValue("json", jsonArray.toString());
			}
			return outmsg;
		}else{
			//3. 分级加载：根据传入的nodeid得到下一级的设备类别和设备编码
			String sql = "select (nvl(tech.good_num,0) - nvl(dev.assign_num,0)) as unuse_num,"
					   + " coll.device_id||'~'||coll.dev_code||'~'||coll.node_level||'~'||coll.is_leaf as id,"
					   + " case coll.is_leaf when 0 then 'false' else 'true' end as leaf,"
					   + " case when coll.is_leaf=0 then coll.dev_name else coll.dev_name||'('||coll.dev_model||')' end as name,"
					   + " coll.dev_code as code,coll.is_leaf,coll.node_level,acc.dev_acc_id,coll.device_id"
					   + " from gms_device_collectinfo coll"
					   + " left join gms_device_coll_account acc on acc.device_id = coll.device_id and acc.bsflag = '0'"
					   + " and acc.owning_org_id = '"+outOrgId+"'"
					   + " left join gms_device_coll_account_tech tech on acc.dev_acc_id = tech.dev_acc_id"
					   + " left join (select app.dev_acc_id,nvl(sum(app.assign_num), 0) as assign_num"
					   + " from gms_device_appmix_main app "
					   + " left join gms_device_mixinfo_form mix on app.device_mixinfo_id = mix.device_mixinfo_id "
					   + " where app.bsflag = '0' and mix.bsflag = '0' and mix.state != '1' and mix.mixform_type = '7'"
					   + " and app.dev_acc_id is not null and mix.mix_type_id = '"+DevConstants.MIXTYPE_YIQI+"'";
					   if( devMixSubId != null && !"null".equals(devMixSubId) && !"".equals(devMixSubId)){
						   sql += " and app.device_mix_subid not in "+devMixSubId;
					   }
					   sql += " group by app.dev_acc_id) dev on dev.dev_acc_id = acc.dev_acc_id ";
			
			String[] keyinfos = nodeid.split("~",-1);
			if(keyinfos[0]!=null&&!"".equals(keyinfos[0])){
				sql += "where coll.node_parent_id='"+keyinfos[0]+"' ";
			}else {
				sql += "where (coll.dev_code='01' or coll.dev_code='02' or coll.dev_code='03' or coll.dev_code='05')"
					 + " and coll.node_parent_id is null ";
			}
			sql += "order by unuse_num desc";
			List list = jdbcDao.queryRecords(sql.toString());			
			JSONArray retJson = JSONArray.fromObject(list);			
			ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);
			
			if(retJson == null){
				outmsg.setValue("json", "[]");
			}else {
				outmsg.setValue("json", retJson.toString());
			}			
			return outmsg;
		}
	}
	/**
	 * NEWMETHOD 装备作业部申请地震仪器单据修改操作获得申请单信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWtcJbqMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixSubId = msg.getValue("devmixsubid");
		String projectInfoNo = msg.getValue("projectinfono");
		StringBuffer sb = new StringBuffer()
			.append( "select acc.dev_unit,t.dev_acc_id as subdevid,t.dev_ci_code as device_id,dui.dev_acc_id,"
					 + " t.device_mix_subid,info.dev_name,info.dev_model,nvl(t.assign_num,0) as assign_num,"
		             + " f.in_org_id,o.f.out_org_id,i.org_abbreviation as in_org_name,"
		             + " o.org_abbreviation as out_org_name,nvl(dui.total_num,0) as total_num,"
		             + " nvl(dui.use_num,0) as use_num,nvl(dui.unuse_num,0) as unuse_num"
		             + " from gms_device_appmix_main t"
		             + " left join gms_device_coll_account acc on t.dev_acc_id=acc.dev_acc_id"
		             + " left join gms_device_coll_account_dui dui on t.dev_ci_code = dui.device_id"
		             + " and dui.project_info_id='"+projectInfoNo+"' and dui.is_leaving = '0'"
		             + " and dui.account_stat='"+DevConstants.DEV_ACCOUNT_ZAIZHANG+"'"
		             + " left join gms_device_mixinfo_form f on t.device_mixinfo_id = f.device_mixinfo_id"
		             + " left join comm_org_information i on f.in_org_id = i.org_id and i.bsflag = '0'"
		             + " left join comm_org_information o on f.out_org_id = o.org_id and o.bsflag = '0'"
		             + " left join gms_device_collectinfo info on t.dev_ci_code = info.device_id"
		             + " where t.device_mix_subid= '"+devMixSubId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处直接调配检波器接收保存
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitWtcJBQReceive(ISrvMsg msg) throws Exception {

		UserToken user = msg.getUserToken();
		String project_info_no = msg.getValue("projectInfoNo");
		String devMixSubId = msg.getValue("devmixsubid");   //调配单明细表主键ID
		String devAccId = msg.getValue("devaccid");         //队级台账ID
		String fkDevAccId = msg.getValue("fk_devacc_id");   //多项目台账ID
		String devMixId = msg.getValue("devmixid");         //调配单主键ID
		
		// 1.队级台账更新或插入
		Map<String, Object> duiMap = new HashMap<String, Object>();
		if (DevUtil.isValueNotNull(devAccId)) {
			duiMap.put("dev_acc_id", devAccId);
		}
		duiMap.put("project_info_id", project_info_no);
		duiMap.put("dev_name", msg.getValue("dev_name"));
		duiMap.put("dev_model", msg.getValue("dev_model"));
		duiMap.put("out_org_id", msg.getValue("out_org_id"));
		duiMap.put("in_org_id", msg.getValue("in_org_id"));
		duiMap.put("actual_in_time", msg.getValue("actual_in_time"));
		duiMap.put("dev_unit", msg.getValue("devunit"));
		duiMap.put("is_leaving", DevConstants.STATE_SAVED);
		duiMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		duiMap.put("account_stat", DevConstants.DEV_ACCOUNT_ZAIZHANG);
		duiMap.put("device_id", msg.getValue("device_id"));
		duiMap.put("total_num", msg.getValue("new_total_num"));
		duiMap.put("unuse_num", msg.getValue("new_unuse_num"));
		duiMap.put("use_num", msg.getValue("new_use_num"));
		duiMap.put("fk_dev_acc_id", fkDevAccId);
		duiMap.put("create_date", DevUtil.getCurrentTime());
		duiMap.put("creator", user.getEmpId());
		duiMap.put("modifi_date", DevUtil.getCurrentTime());
		duiMap.put("modifier", user.getEmpId());
		Serializable keyid = jdbcDao.saveOrUpdateEntity(duiMap,
				"gms_device_coll_account_dui");
		// 2.队级台账动态表插入
		Map<String, Object> dymMap = new HashMap<String, Object>();
		dymMap.put("dev_acc_id", keyid.toString());
		dymMap.put("opr_type", DevConstants.DYM_OPRTYPE_OUT);
		dymMap.put("receive_num", msg.getValue("out_num"));
		dymMap.put("actual_in_time", msg.getValue("actual_in_time"));
		dymMap.put("create_date", DevUtil.getCurrentTime());
		dymMap.put("creator", user.getEmpId());
		jdbcDao.saveOrUpdateEntity(dymMap, "gms_device_coll_account_dym");
		// 3.明细设备接收状态改为已接收
		Map<String, Object> outsubMap = new HashMap<String, Object>();
		outsubMap.put("device_mix_subid", devMixSubId);
		outsubMap.put("state", "9");
		outsubMap.put("modifi_date", DevUtil.getCurrentTime());
		jdbcDao.saveOrUpdateEntity(outsubMap, "gms_device_appmix_main");
		
		String updatesql1 = "update gms_device_mixinfo_form mif set opr_state='1' "
				+ "where (exists (select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"
				+ devMixId
				+ "' and m.state='9') "
				+ "and exists(select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"
				+ devMixId
				+ "' and m.state='0')) "
				+ "and mif.device_mixinfo_id = '" + devMixId + "' ";

		String updatesql2 = "update gms_device_mixinfo_form mif set opr_state='9' "
				+ "where (exists (select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"
				+ devMixId
				+ "' and m.state='9') "
				+ "and not exists(select 1 from gms_device_appmix_main m where m.device_mixinfo_id='"
				+ devMixId
				+ "' and m.state='0')) "
				+ "and mif.device_mixinfo_id = '" + devMixId + "' ";

		jdbcDao.executeUpdate(updatesql1);
		jdbcDao.executeUpdate(updatesql2);
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	/**
	 * NEWMETHOD 检波器、地震仪器返还主页面加载标签信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevCollJBQBackInfo(ISrvMsg reqDTO) throws Exception {
		String devBackAppId = reqDTO.getValue("devicebackappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		// 1.将申请单基本信息返回给界面
		StringBuffer sb = new StringBuffer()
				.append("select colback.device_backapp_id,colback.device_backapp_no,colback.backapp_name,pro.project_name,"
						 + " org.org_abbreviation as back_org_name,recvorg.org_abbreviation as receive_org_name,"
						 + " emp.employee_name as back_employee_name,colback.backdate,"
						 + " case colback.backdevtype when 'S14050208' then '检波器' when 'S9001' then '自有地震仪器' when 'S9000'"
						 + " then '专业化地震仪器' else '检波器' end as back_dev_type,"
						 + " case colback.state when '0' then '未提交' when '9' then '已提交' end as state_desc,"
						 + " case colback.opr_state  when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc"
						 + " from gms_device_collbackapp colback"
						 + " left join gp_task_project pro on colback.project_info_id = pro.project_info_no"
						 + " left join comm_org_information org on colback.back_org_id = org.org_id and org.bsflag = '0'"
						 + " left join comm_org_information recvorg on colback.receive_org_id = recvorg.org_id and recvorg.bsflag = '0'"
						 + " left join comm_human_employee emp on colback.back_employee_id = emp.employee_id"
						 + " where colback.device_backapp_id='"+ devBackAppId + "'");
		Map devBackappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devBackappMap)) {
			responseMsg.setValue("data", devBackappMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 检波器返还有调配步骤主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevBackMixJBQInfo(ISrvMsg reqDTO) throws Exception {
		String devBackAppId = reqDTO.getValue("devicebackappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select backapp.backapp_name,gp.project_name,backapp.device_backapp_no,"
						+ " i.org_abbreviation as back_org_name,org.org_abbreviation as receive_org_name,"
						+ " case t.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,"
						+ " emp.employee_name as back_employee_name,"
						+ " to_char(backapp.backdate, 'yyyy-mm-dd') as backdate,backapp.opr_state"
						+ " from gms_device_coll_backinfo_form t"
						+ " left join gp_task_project gp on t.project_info_id = gp.project_info_no"
						+ " left join gms_device_collbackapp backapp on t.device_backapp_id = backapp.device_backapp_id"
						+ " left join comm_org_information i on backapp.back_org_id = i.org_id and i.bsflag = '0'"
						+ " left join comm_human_employee emp on backapp.back_employee_id = emp.employee_id"
						+ " left join comm_org_information org on t.receive_org_id = org.org_id and org.bsflag = '0'"
						+ " where t.device_coll_mixinfo_id = '"+ devBackAppId + "'");
		Map devBackappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devBackappMap)) {
			responseMsg.setValue("data", devBackappMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 大港地震仪器返还原单据主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevBackMixCollInfo(ISrvMsg reqDTO) throws Exception {
		String devBackAppId = reqDTO.getValue("devicebackappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select gp.project_name,t.device_backapp_no,t.backapp_name,i.org_abbreviation as back_org_name,"
						+ " org.org_abbreviation as receive_org_name,mixorg.org_abbreviation as mix_org_name,"
						+ " emp.employee_name as back_employee_name,to_char(t.backdate, 'yyyy-mm-dd') as backdate,"
						+ " case t.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc"
						+ " from gms_device_collbackapp t"
						+ " left join gp_task_project gp on t.project_info_id = gp.project_info_no"
						+ " left join comm_human_employee emp on t.back_employee_id = emp.employee_id"
						+ " left join comm_org_information i on t.back_org_id = i.org_id and i.bsflag = '0'"
						+ " left join comm_org_information org on t.receive_org_id = org.org_id and org.bsflag = '0'"
						+ " left join comm_org_information mixorg on t.backmix_org_id = mixorg.org_id and mixorg.bsflag = '0'"
						+ " where t.device_backapp_id = '"+ devBackAppId + "'");
		Map devBackappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devBackappMap)) {
			responseMsg.setValue("data", devBackappMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 检波器、地震仪器设备返还保存
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveCollJBQBackDetailInfo(ISrvMsg msg) throws Exception {
		String backAppId = wtcDevSrv.saveBackDevApp(msg);
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();		
		// 先删子表
		jdbcDao.executeUpdate("delete from gms_device_collbackapp_detail where bsflag='0' and device_backapp_id='"
				+ backAppId + "' ");

		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		String[] lineInfos = msg.getValue("lineinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("device_backapp_id", backAppId);
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("dev_name",msg.getValue("dev_name" + lineInfos[index]));
			dataMap.put("dev_model", msg.getValue("dev_model" + lineInfos[index]));
			dataMap.put("back_num", msg.getValue("back_num" + lineInfos[index]));
			dataMap.put("planning_out_time",msg.getValue("enddate" + lineInfos[index]));
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			dataMap.put("device_id",msg.getValue("device_id" + lineInfos[index]));			
			dataMap.put("is_leaving", DevConstants.STATE_SAVED);
			dataMap.put("create_date", DevUtil.getCurrentTime());
			dataMap.put("creator_id", user.getEmpId());
			dataMap.put("modifi_date", DevUtil.getCurrentTime());
			dataMap.put("modifier", user.getEmpId());
			dataMap.put("device_detail_rid", msg.getValue("device_detail_rid"+index));
			datasList.add(dataMap);
		}
		String insOsDetSql = "insert into gms_device_collbackapp_detail("
						   + " device_backdet_id,"
						   + " device_backapp_id,"
						   + " dev_acc_id,"
						   + " dev_name,"
						   + " dev_model,"
						   + " back_num,"
						   + " planning_out_time,"
						   + " is_leaving,"
						   + " bsflag,"
						   + " device_id,"
						   + " create_date,"
						   + " creator_id,"
						   + " modifi_date,"
						   + " modifier,"
						   + " device_detail_rid"
						   + " )values(?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,?,"
						   + " ?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?)";

		jdbcDao.getJdbcTemplate().batchUpdate(insOsDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2,(String) devSaveMap.get("device_backapp_id"));
						ps.setString(3, (String) devSaveMap.get("dev_acc_id"));
						ps.setString(4, (String) devSaveMap.get("dev_name"));
						ps.setString(5, (String) devSaveMap.get("dev_model"));
						ps.setInt(6, Integer.parseInt((String) devSaveMap.get("back_num")));
						ps.setString(7, (String) devSaveMap.get("planning_out_time"));
						ps.setString(8, (String) devSaveMap.get("is_leaving"));
						ps.setString(9, (String) devSaveMap.get("bsflag"));
						ps.setString(10, (String) devSaveMap.get("device_id"));
						ps.setString(11, (String) devSaveMap.get("create_date"));
						ps.setString(12, (String) devSaveMap.get("creator_id"));
						ps.setString(13, (String) devSaveMap.get("modifi_date"));
						ps.setString(14, (String) devSaveMap.get("modifier"));
						ps.setString(15, (String) devSaveMap.get("device_detail_rid"));
					}

					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		// 回写成功消息
		return responseDTO;
	}
	/**
	 * NEWMETHOD 地震仪器设备返还可能存在仪器附属设备保存
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveCollFSBackDetailInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		/** 
		 * 插入地震仪器批量数据表(gms_device_collbackapp、gms_device_collbackapp_detail)
		 * -------------------------开始-----------------------------------
		 */
		String backAppId = wtcDevSrv.saveBackDevApp(msg);
		UserToken user = msg.getUserToken();
		// 先删子表
		jdbcDao.executeUpdate("delete from gms_device_collbackapp_detail where device_backapp_id='"
				+ backAppId + "' ");

		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		String[] lineInfos = msg.getValue("lineinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("device_backapp_id", backAppId);
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("dev_name",msg.getValue("dev_name" + lineInfos[index]));
			dataMap.put("dev_model", msg.getValue("dev_model" + lineInfos[index]));
			dataMap.put("back_num", msg.getValue("back_num" + lineInfos[index]));
			dataMap.put("planning_out_time",msg.getValue("enddate" + lineInfos[index]));
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			dataMap.put("device_id",msg.getValue("device_id" + lineInfos[index]));			
			dataMap.put("is_leaving", DevConstants.STATE_SAVED);
			dataMap.put("create_date", DevUtil.getCurrentTime());
			dataMap.put("creator_id", user.getEmpId());
			dataMap.put("modifi_date", DevUtil.getCurrentTime());
			dataMap.put("modifier", user.getEmpId());
			datasList.add(dataMap);
		}
		String insOsDetSql = "insert into gms_device_collbackapp_detail("
						   + " device_backdet_id,"
						   + " device_backapp_id,"
						   + " dev_acc_id,"
						   + " dev_name,"
						   + " dev_model,"
						   + " back_num,"
						   + " planning_out_time,"
						   + " is_leaving,"
						   + " bsflag,"
						   + " device_id,"
						   + " create_date,"
						   + " creator_id,"
						   + " modifi_date,"
						   + " modifier"
						   + " )values(?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,?,"
						   + " ?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?)";

		jdbcDao.getJdbcTemplate().batchUpdate(insOsDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2,(String) devSaveMap.get("device_backapp_id"));
						ps.setString(3, (String) devSaveMap.get("dev_acc_id"));
						ps.setString(4, (String) devSaveMap.get("dev_name"));
						ps.setString(5, (String) devSaveMap.get("dev_model"));
						ps.setInt(6, Integer.parseInt((String) devSaveMap.get("back_num")));
						ps.setString(7, (String) devSaveMap.get("planning_out_time"));
						ps.setString(8, (String) devSaveMap.get("is_leaving"));
						ps.setString(9, (String) devSaveMap.get("bsflag"));
						ps.setString(10, (String) devSaveMap.get("device_id"));
						ps.setString(11, (String) devSaveMap.get("create_date"));
						ps.setString(12, (String) devSaveMap.get("creator_id"));
						ps.setString(13, (String) devSaveMap.get("modifi_date"));
						ps.setString(14, (String) devSaveMap.get("modifier"));
					}

					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		/** 
		 * -------------------------结束-----------------------------------
		 * 插入地震仪器批量数据表(gms_device_collbackapp、gms_device_collbackapp_detail)
		 * 
		 * 
		 * 插入地震仪器附属设备(gms_device_backapp、gms_device_backapp_detail)
		 * -------------------------开始-----------------------------------
		 */
		
		// 更改设备的离场状态
		jdbcDao.executeUpdate("update gms_device_account_dui dui set is_leaving = '0'"
					+ " where dui.bsflag = '0' and dui.dev_acc_id in"
					+ " (select dev_acc_id from gms_device_backapp_detail"
					+ " where device_backapp_id = '" + backAppId + "') ");
		// 先删子表，在插入新的子表
		jdbcDao.executeUpdate("delete from gms_device_backapp_detail where device_backapp_id='"
					+ backAppId + "' ");
		
		if(DevUtil.isValueNotNull(msg.getValue("idfsinfos"))){
			//插入单台返还单表
			String projectInfoNo = user.getProjectInfoNo();
			String addUpFlag = msg.getValue("addupflag");//添加/修改标识
			String backDate = msg.getValue("backdate");//申请时间
			String backAppName = msg.getValue("backappname");
			String rcvOrgId = msg.getValue("receive_org_id");
			String searchBackappId = UUID.randomUUID().toString().replaceAll("-", "");
			String devBackAppNo = "";
			Map<String, Object> mainMap = new HashMap<String, Object>();
			mainMap.put("project_info_id", projectInfoNo);								//项目ID
			mainMap.put("back_org_id", user.getTeamOrgId());						    //返还单位
			mainMap.put("back_employee_id", user.getEmpId());							//申请人ID
			mainMap.put("backdate", backDate);						    				//申请时间
			mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);							//删除标识
			mainMap.put("state", DevConstants.STATE_SAVED);								//申请单状态,0未提交
			mainMap.put("search_backapp_id", searchBackappId);							//查询主键字段
			mainMap.put("backapp_name", backAppName);					                //返还单名称
			mainMap.put("backapptype", DevConstants.BACK_DEVTYPE_TONOMIXBACK);			//处理状态
			mainMap.put("opr_state", DevConstants.SAVE_FLAG_0);				            //验收处理状态
			
			if(DevUtil.isValueNotNull(addUpFlag,"add")){//新增 
				devBackAppNo = DevUtil.getDevBackAppNo("YQFS");
				mainMap.put("device_backapp_id", backAppId);
				mainMap.put("device_backapp_no", devBackAppNo);							    //返还单号
				mainMap.put("backdevtype", DevConstants.BACK_DEVTYPE_YIQI);					//返还类型
				mainMap.put("receive_org_id", rcvOrgId);									//接收单位ID
				mainMap.put("create_date", DevUtil.getCurrentTime());						//创建日期
				mainMap.put("creator_id", user.getEmpId());									//创建人	
				mainMap.put("modifi_date",DevUtil.getCurrentTime());						//修改时间
				mainMap.put("updator_id", user.getEmpId());									//修改人
				mainMap.put("org_id", user.getOrgId());										//返还操作人组织机构Id
				mainMap.put("org_subjection_id", user.getOrgSubjectionId());				//返还操作人组织机构隶属ID
				backAppId = (String)jdbcDao.saveEntity(mainMap, "gms_device_backapp");
			}else{			
				devBackAppNo = msg.getValue("device_backapp_no");
				mainMap.put("device_backapp_no", devBackAppNo);							    //返还单号
				mainMap.put("modifi_date",DevUtil.getCurrentTime());						//修改时间
				mainMap.put("updator_id", user.getEmpId());
				mainMap.put("device_backapp_id", backAppId);
				jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_backapp");
			}
			
			String[] idFsInfos = msg.getValue("idfsinfos").split("~", -1);
			String[] lineFsInfos = msg.getValue("linefsinfos").split("~", -1);
			final List<Map<String, Object>> datasFsList = new ArrayList<Map<String, Object>>();
			for (int index = 0; index < idFsInfos.length; index++) {
				Map<String, Object> dataMap = new HashMap<String, Object>();
				dataMap.put("device_backapp_id", backAppId);
				dataMap.put("dev_acc_id", idFsInfos[index]);
				dataMap.put("dev_coding",msg.getValue("fsdev_coding" + lineFsInfos[index]));
				dataMap.put("self_num", msg.getValue("fsself_num" + lineFsInfos[index]));
				dataMap.put("dev_sign", msg.getValue("fsdev_sign" + lineFsInfos[index]));
				dataMap.put("license_num",msg.getValue("fslicense_num" + lineFsInfos[index]));
				// 2013-02-01 作为实际的离场时间 --没有actual_out_time 字段，使用actual_in_time
				dataMap.put("actual_in_time",msg.getValue("fsenddate" + lineFsInfos[index]));
				dataMap.put("planning_out_time",msg.getValue("fsplanning_out_time" + lineFsInfos[index]));
				dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				dataMap.put("state", DevConstants.STATE_SAVED);
				dataMap.put("create_date", DevUtil.getCurrentTime());
				dataMap.put("creator_id", user.getEmpId());
				dataMap.put("modifi_date", DevUtil.getCurrentTime());
				dataMap.put("modifier", user.getEmpId());
				datasFsList.add(dataMap);
			}
			String insFsDetSql = "insert into gms_device_backapp_detail("
					+ " device_backdet_id,"
					+ " device_backapp_id,"
					+ " dev_acc_id,"
					+ " dev_coding,"
					+ " self_num,"
					+ " dev_sign,"
					+ " license_num,"
					+ " actual_in_time,"
					+ " planning_out_time,"
					+ " bsflag,"
					+ " state,"
					+ " create_date,"
					+ " creator_id,"
					+ " modifi_date,"
					+ " modifier"
					+ " )values(?,?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),"
					+ " ?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?)";
	
			jdbcDao.getJdbcTemplate().batchUpdate(insFsDetSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devSaveMap = datasFsList.get(i);
							ps.setString(1, jdbcDao.generateUUID());
							ps.setString(2, (String) devSaveMap.get("device_backapp_id"));
							ps.setString(3, (String) devSaveMap.get("dev_acc_id"));
							ps.setString(4, (String) devSaveMap.get("dev_coding"));
							ps.setString(5, (String) devSaveMap.get("self_num"));
							ps.setString(6, (String) devSaveMap.get("dev_sign"));
							ps.setString(7, (String) devSaveMap.get("license_num"));
							ps.setString(8, (String) devSaveMap.get("actual_in_time"));
							ps.setString(9, (String) devSaveMap.get("planning_out_time"));
							ps.setString(10, (String) devSaveMap.get("bsflag"));
							ps.setString(11, (String) devSaveMap.get("state"));
							ps.setString(12, (String) devSaveMap.get("create_date"));
							ps.setString(13, (String) devSaveMap.get("creator_id"));
							ps.setString(14, (String) devSaveMap.get("modifi_date"));
							ps.setString(15, (String) devSaveMap.get("modifier"));
						}
	
						@Override
						public int getBatchSize() {
							return datasFsList.size();
						}
					});
			// 更改设备的离场状态
			String upDuiDevSql = "update gms_device_account_dui set "
							   + " is_leaving = '2'"
							   + " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDuiDevSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devMap = datasFsList.get(i);
							ps.setString(1, (String) devMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasFsList.size();
						}
			});
		}
		/** 
		 * -------------------------结束-----------------------------------
		 * 插入地震仪器附属设备(gms_device_backapp、gms_device_backapp_detail)
		 */
		// 回写成功消息
		return responseDTO;
	}
	/**
	 * NEWMETHOD 检波器收工验收保存基本信息 
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 * @author ZJT
	 */
	public ISrvMsg submitJbqStock(ISrvMsg msg) throws Exception {
		// 当前登录用户的ID
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String checkTime =  msg.getValue("actual_out_time");//验收时间
		String fkDevAccId =  msg.getValue("fkdevaccid");//多项目台账ID
		String duiDevAccId =  msg.getValue("devaccid");//队级台账ID
		String devCollMixinfoId =  msg.getValue("devmixid");//返还调配单主键ID
		String projectInfoNo =  msg.getValue("projectinfono");//项目编号
		String deviceBackdetId = msg.getValue("device_backdet_id");//返还调配名表主键ID
		String recOrgId = msg.getValue("receive_org_id");//接收单位org_id
		String recSubId = msg.getValue("receive_sub_id");//接收单位sub_id
		String devName = msg.getValue("dev_name");//设备名称
		String devModel = msg.getValue("dev_model");//设备型号
		String deviceId = msg.getValue("device_id");//设备类型编码
		String typeId = msg.getValue("type_id");//设备类别码
		String techId = msg.getValue("techid");//设备技术状况表主键ID
		String useNewTotalNum = msg.getValue("use_new_total_num").toString();//现总数量
		String newUsingNum = msg.getValue("new_using_num").toString();//现在用数量
		String newUnusingNum = msg.getValue("new_unusing_num").toString();//现闲置数量
		String newOtherNum = msg.getValue("new_other_num").toString();//现其他数量
		String newGoodNum = msg.getValue("new_good_num").toString();//现完好数量
		String newTocheckNum = msg.getValue("new_tocheck_num").toString();//现盘亏数量
		String newTorepairNum = msg.getValue("new_torepair_num").toString();//现待修数量
		String newDestroyNum = msg.getValue("new_destroy_num").toString();//现毁损数量
		String outOrgId = msg.getValue("out_org_id");//原所在单位
		String receiveOrgId = msg.getValue("receive_org_id");//接收单位
		String goodNum = msg.getValue("good_num").toString();//完好数量
		String torepairNum = msg.getValue("torepair_num").toString();//待修数量
		String tocheckNum = msg.getValue("tocheck_num").toString();//盘亏数量
		String destroyNum = msg.getValue("destroy_num").toString();//毁损数量
		String backNum = msg.getValue("back_num").toString();//返还数量
		
		//更新返还调配明细表
		String sql = "update gms_device_coll_back_detail set"
		           + " is_leaving = '1',"
		           + " check_time = to_date('"+checkTime+"','yyyy-MM-dd'),"
		           + " modifi_date = sysdate,"
		   	       + " modifier = '"+employee_id+"'"
		   	       + " where device_coll_backdet_id = '"+deviceBackdetId+"'";
		jdbcDao.executeUpdate(sql);
		
		//多项目设备台账表
		Map<String, Object> accMap = new HashMap<String, Object>();		
		if (DevUtil.isValueNotNull(fkDevAccId)) {
			accMap.put("dev_acc_id",fkDevAccId);
			accMap.put("total_num",(Double.valueOf(useNewTotalNum)));
			accMap.put("use_num",(Double.valueOf(newUsingNum)));
			accMap.put("unuse_num",(Double.valueOf(newUnusingNum)));
			accMap.put("other_num", (Double.valueOf(newOtherNum)));
			jdbcDao.saveOrUpdateEntity(accMap, "gms_device_coll_account");
		}else{
			accMap.put("total_num",(Double.valueOf(useNewTotalNum)));
			accMap.put("use_num",(Double.valueOf(newUsingNum)));
			accMap.put("unuse_num",(Double.valueOf(newUnusingNum)));
			accMap.put("other_num", (Double.valueOf(newOtherNum)));
			accMap.put("owning_org_id", recOrgId);
			accMap.put("owning_sub_id", recSubId);
			accMap.put("usage_org_id", recOrgId);
			accMap.put("usage_sub_id", recSubId);
			accMap.put("dev_name", devName);
			accMap.put("dev_model", devModel);
			accMap.put("create_date", DevUtil.getCurrentTime());
			accMap.put("creator", user.getEmpId());
			accMap.put("modifi_date", DevUtil.getCurrentTime());
			accMap.put("modifier", user.getEmpId());
			accMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			accMap.put("device_id", deviceId);
			accMap.put("type_id", typeId);
			accMap.put("ifcountry", DevConstants.DEV_IFCOUNTRY_GUONEI);
			accMap.put("dev_unit", "5110000038000000011");//检波器的单位
			fkDevAccId = (String)jdbcDao.saveOrUpdateEntity(accMap, "gms_device_coll_account");
		}
		
		//设备技术状况表
		Map<String, Object> techMap = new HashMap<String, Object>();		
		if (DevUtil.isValueNotNull(techId)) {
			techMap.put("tech_id",techId);
			techMap.put("good_num",(Double.valueOf(newGoodNum)));//完好数量
			techMap.put("torepair_num",(Double.valueOf(newTorepairNum)));//待修数量
			techMap.put("tocheck_num", (Double.valueOf(newTocheckNum)));//盘亏数量
			techMap.put("destroy_num", (Double.valueOf(newDestroyNum)));//毁损数量
			jdbcDao.saveOrUpdateEntity(techMap, "gms_device_coll_account_tech");
		}else{
			techMap.put("dev_acc_id", fkDevAccId);
			techMap.put("good_num",(Double.valueOf(newGoodNum)));//完好数量
			techMap.put("touseless_num",0);//待报废数量
			techMap.put("torepair_num",(Double.valueOf(newTorepairNum)));//待修数量
			techMap.put("repairing_num",(Double.valueOf(newTorepairNum)));//在修数量
			techMap.put("tocheck_num", (Double.valueOf(newTocheckNum)));//盘亏数量
			techMap.put("destroy_num", (Double.valueOf(newDestroyNum)));//毁损数量
			techMap.put("noreturn_num",0);//未缴回数量
			techId = (String)jdbcDao.saveOrUpdateEntity(accMap, "gms_device_coll_account_tech");
		}
		// 添加本次验收的的数量确认信息
		Map<String, Object> firmMap = new HashMap<String, Object>();
		firmMap.put("dev_acc_id", fkDevAccId);
		firmMap.put("pro_dev_acc_id", duiDevAccId);
		firmMap.put("good_num", (Double.valueOf(goodNum)));
		firmMap.put("torepair_num", (Double.valueOf(torepairNum)));
		firmMap.put("tocheck_num", (Double.valueOf(tocheckNum)));
		firmMap.put("destroy_num", (Double.valueOf(destroyNum)));
		firmMap.put("project_info_no", projectInfoNo);
		firmMap.put("create_date", checkTime);
		firmMap.put("device_backdet_id", deviceBackdetId);
		jdbcDao.saveEntity(firmMap, "gms_device_coll_account_firm");

		Map<String, Object> dymMap = new HashMap<String, Object>();
		dymMap.put("oprtype", DevConstants.DYM_OPRTYPE_IN);
		dymMap.put("dev_acc_id", fkDevAccId);
		dymMap.put("collnum", (Double.valueOf(backNum)));
		dymMap.put("alter_date", checkTime);
		dymMap.put("project_info_no", projectInfoNo);
		dymMap.put("device_appmix_id", devCollMixinfoId);
		dymMap.put("indb_date", checkTime);
		dymMap.put("format_date", "2006-01-01");
		dymMap.put("new_dev_acc_id", fkDevAccId);
		jdbcDao.saveOrUpdateEntity(dymMap, "gms_device_coll_dym");
		// 如果存在维修数量，那么保存维修动态表
		if (Integer.parseInt(torepairNum) > 0) {
			Map<String, Object> weixiuDymMap = new HashMap<String, Object>();
			weixiuDymMap.put("oprtype", DevConstants.DYM_OPRTYPE_WEIXIUOUT);
			weixiuDymMap.put("dev_acc_id", fkDevAccId);
			weixiuDymMap.put("collnum", (Double.valueOf(torepairNum)));
			weixiuDymMap.put("alter_date", checkTime);
			weixiuDymMap.put("project_info_no", projectInfoNo);
			weixiuDymMap.put("device_appmix_id",devCollMixinfoId);
			weixiuDymMap.put("indb_date", DevUtil.getCurrentTime());//此字段无用处
			weixiuDymMap.put("format_date", "2006-01-01");
			weixiuDymMap.put("new_dev_acc_id", fkDevAccId);
			jdbcDao.saveOrUpdateEntity(weixiuDymMap, "gms_device_coll_dym");
		}

		String updatesql1 = "update gms_device_coll_backinfo_form mif set opr_state='1' "
				+ "where exists (select 1 from gms_device_coll_back_detail dad "
				+ "where dad.device_coll_mixinfo_id='"
				+ devCollMixinfoId
				+ "' and dad.is_leaving='1') "
				+ "and exists(select 1 from gms_device_coll_back_detail dad "
				+ "where dad.device_coll_mixinfo_id='"
				+ devCollMixinfoId
				+ "' and dad.is_leaving='0') "
				+ "and mif.device_coll_mixinfo_id = '"
				+ devCollMixinfoId
				+ "' ";
		String updatesql2 = "update gms_device_coll_backinfo_form mif set opr_state='9' "
				+ "where exists (select 1 from gms_device_coll_back_detail dad "
				+ "where dad.device_coll_mixinfo_id='"
				+ devCollMixinfoId
				+ "' and dad.is_leaving='1') "
				+ "and not exists(select 1 from gms_device_coll_back_detail dad "
				+ "where dad.device_coll_mixinfo_id='"
				+ devCollMixinfoId
				+ "' and dad.is_leaving ='0') "
				+ "and mif.device_coll_mixinfo_id = '"
				+ devCollMixinfoId
				+ "' ";
		jdbcDao.executeUpdate(updatesql1);
		jdbcDao.executeUpdate(updatesql2);
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 获得外租设备类型信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireDevType(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String sql = "select coding_name,coding_code_id from comm_coding_sort_detail"
			       + " where coding_sort_id='5110000184' order by coding_show_id ";
		List<Map> modelList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", modelList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处自主调配外租设备信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireMainInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectName = msg.getValue("projectname");
		String hireAppName = msg.getValue("hireappname");
		String hireDevType = msg.getValue("hiredevtype");
		String proOrgName = msg.getValue("proorgname");
		String appOrgId = msg.getValue("apporgid");
		String viewFlag = msg.getValue("viewflag");//Y:查看单据     N:调配
		if(StringUtils.isEmpty(viewFlag)){
			viewFlag = "N";
		}
		String projectNo = msg.getValue("projectno");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,"
				+ " case when length(dev.project_name) > 16 then substr(dev.project_name, 0, 16) || '...'"
				+ " else dev.project_name end as proname,"
				+ " case when length(dev.device_hireapp_name) > 16 then substr(dev.device_hireapp_name, 0, 16) || '...'"
				+ " else dev.device_hireapp_name end as hireappname,dev.*"
				+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,mix.device_hireapp_id,"
				+ " mix.device_hireapp_no,mix.device_hireapp_name,sub.org_subjection_id,mix.appdate,"
				+ " mix.employee_id,mix.modifi_date,mix.state,org.org_abbreviation as org_name,mix.project_info_no,"
				+ " case mix.mix_type_id"
				+ " when '5110000184000000002' then '外租单台'"
				+ " when '5110000184000000003' then '外租检波器'"
				+ " end as mixtypename,mix.mix_type_id,"
				+ " mix.org_id,emp.employee_name,case mix.state when '1' then '已提交' else '未提交' end as state_desc,"
				+ " case"
				+ " when sub.org_subjection_id like 'C105001005%' then '塔里木物探处'"
				+ " when sub.org_subjection_id like 'C105001002%' then '新疆物探处'"
				+ " when sub.org_subjection_id like 'C105001003%' then '吐哈物探处'"
				+ " when sub.org_subjection_id like 'C105001004%' then '青海物探处'"
				+ " when sub.org_subjection_id like 'C105005004%' then '长庆物探处'"
				+ " when sub.org_subjection_id like 'C105005000%' then '华北物探处'"
				+ " when sub.org_subjection_id like 'C105005001%' then '新兴物探开发处'"
				+ " when sub.org_subjection_id like 'C105007%' then '大港物探处'"
				+ " when sub.org_subjection_id like 'C105063%' then '辽河物探处'"
				+ " when sub.org_subjection_id like 'C105086%' then '深海物探处'"
				+ " when sub.org_subjection_id like 'C105008%' then '综合物化处'"
				+ " when sub.org_subjection_id like 'C105002%' then '国际勘探事业部'"
				+ " else info.org_abbreviation end as pro_sub_name"
				+ " from gms_device_hireapp mix"
				+ " left join comm_org_information org on mix.org_id = org.org_id and org.bsflag = '0'"
				+ " left join comm_human_employee emp on mix.employee_id = emp.employee_id and emp.bsflag = '0' "
				+ " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
				+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = mix.org_id and sub.bsflag = '0'"
				+ " where mix.bsflag = '0' and mix.state is not null and mix.opr_state is not null");		
		if("Y".equals(viewFlag)){//查看调配单
			querySql.append(" ) dev where 1 = 1");
		}else{
			querySql.append(" and mix.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%') dev where 1 = 1");
		}
		//项目名称
		if (StringUtils.isNotBlank(projectName)) {
			querySql.append(" and project_name like '%"+projectName+"%'");
		}
		//申请单名称
		if (StringUtils.isNotBlank(hireAppName)) {
			querySql.append(" and device_hireapp_name like '%"+hireAppName+"%'");
		}
		//外租类型
		if (StringUtils.isNotBlank(hireDevType)) {
			querySql.append(" and mix_type_id = '"+hireDevType+"'");
		}
		//项目所属单位
		if (StringUtils.isNotBlank(proOrgName)) {
			querySql.append(" and dev.pro_sub_name || '-' || dev.dui_org_name like '%"+proOrgName+"%'");
		}
		//调配单位名称
		if (StringUtils.isNotBlank(appOrgId)) {
			querySql.append(" and org_subjection_id like '%"+appOrgId+"%'");
		}
		//项目编号
		if (StringUtils.isNotBlank(projectNo)) {
			querySql.append(" and project_info_no like '%"+projectNo+"%'");
		}
		
		querySql.append(" order by state nulls first,modifi_date desc,org_id,project_info_no ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处调配外租设备主表信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireDevBaseInfo(ISrvMsg msg) throws Exception {
		String hireAppId = msg.getValue("devicehireappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,"
					+ " case when length(dev.project_name) > 16 then substr(dev.project_name, 0, 16) || '...'"
					+ " else dev.project_name end as proname,"
					+ " case when length(dev.device_hireapp_name) > 16 then substr(dev.device_hireapp_name, 0, 16) || '...'"
					+ " else dev.device_hireapp_name end as hireappname,dev.*"
					+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,mix.device_hireapp_id,"
					+ " mix.device_hireapp_no,mix.device_hireapp_name,sub.org_subjection_id,mix.appdate,"
					+ " mix.employee_id,mix.modifi_date,mix.state,org.org_abbreviation as org_name,mix.project_info_no,"
					+ " case mix.mix_type_id"
					+ " when '5110000184000000002' then '外租单台'"
					+ " when '5110000184000000003' then '外租检波器'"
					+ " end as mixtypename,mix.mix_type_id,"
					+ " mix.org_id,emp.employee_name,case mix.state when '1' then '已提交' else '未提交' end as state_desc,"
					+ " case"
					+ " when sub.org_subjection_id like 'C105001005%' then '塔里木物探处'"
					+ " when sub.org_subjection_id like 'C105001002%' then '新疆物探处'"
					+ " when sub.org_subjection_id like 'C105001003%' then '吐哈物探处'"
					+ " when sub.org_subjection_id like 'C105001004%' then '青海物探处'"
					+ " when sub.org_subjection_id like 'C105005004%' then '长庆物探处'"
					+ " when sub.org_subjection_id like 'C105005000%' then '华北物探处'"
					+ " when sub.org_subjection_id like 'C105005001%' then '新兴物探开发处'"
					+ " when sub.org_subjection_id like 'C105007%' then '大港物探处'"
					+ " when sub.org_subjection_id like 'C105063%' then '辽河物探处'"
					+ " when sub.org_subjection_id like 'C105086%' then '深海物探处'"
					+ " when sub.org_subjection_id like 'C105008%' then '综合物化处'"
					+ " when sub.org_subjection_id like 'C105002%' then '国际勘探事业部'"
					+ " else info.org_abbreviation end as pro_sub_name"
					+ " from gms_device_hireapp mix"
					+ " left join comm_org_information org on mix.org_id = org.org_id and org.bsflag = '0'"
					+ " left join comm_human_employee emp on mix.employee_id = emp.employee_id and emp.bsflag = '0' "
					+ " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
					+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
					+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
					+ " left join comm_org_subjection sub on sub.org_id = mix.org_id and sub.bsflag = '0'"
					+ " where mix.device_hireapp_id = '"+hireAppId+"') dev");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("mixMap", mixMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 物探处调配外租设备明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireAppDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String hireAppId = msg.getValue("hireappid");
		String sql = "select l.coding_name as teamname,det.dev_name,det.dev_type,d.coding_name as unitname,"
				   + " det.apply_num,det.devrental,det.rentname,det.plan_start_date,det.plan_end_date,"
				   + " det.purpose,case det.state when '1' then '已接收' when '2' then '接收中' else '未接收' end as statedesc"
				   + " from gms_device_hireapp_detail det"
				   + " left join comm_coding_sort_detail l on det.team = l.coding_code_id"
				   + " left join comm_coding_sort_detail d on d.coding_code_id = det.unitinfo "
				   + " where det.device_hireapp_id = '"+hireAppId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处调配外租设备修改操作获得申请单信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String hireAppId = msg.getValue("hireappid");
		StringBuffer sb = new StringBuffer()
			.append( "select pro.project_name,app.project_info_no,app.device_hireapp_no,app.device_hireapp_id,"
					  + " app.device_hireapp_name,emp.employee_name,app.employee_id,app.appdate,pro.project_type,"
					  + " app.mix_type_id,app.app_org_id from gms_device_hireapp app"
					  + " left join gp_task_project pro on pro.project_info_no = app.project_info_no"
					  + " left join comm_human_employee emp on app.employee_id = emp.employee_id and emp.bsflag = '0'"
				      + " where app.device_hireapp_id = '"+hireAppId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处调配外租设备修改操作获得申请单明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireDevDetInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String hireAppId = msg.getValue("hireappid");
		String sql = "select det.team,det.dev_name,det.dev_type,det.unitinfo,det.apply_num,"
			   	   + " det.devrental,det.rentname,det.plan_start_date,det.plan_end_date,det.purpose"
			       + " from gms_device_hireapp_detail det"
			       + " where det.device_hireapp_id = '"+hireAppId+"' ";
		List<Map> addedList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", addedList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 删除、修改、提交物探处调配外租单台、检波器设备单据状态判断
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opHireDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String userSubOrg = user.getOrgSubjectionId();
		String delFlag = "0";
		String mixState = "";
		String hireAppId = msg.getValue("hireappid");
		String opFlag = msg.getValue("opflag");
		try{
			String appSql = "select mix.state from gms_device_hireapp mix"
						  + " where mix.device_hireapp_id = '"+hireAppId+"' ";
			Map mixMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(mixMap)){
				mixState = mixMap.get("state").toString();
				if("1".equals(mixState)){
					delFlag = "1";//已提交的单据不能删除/修改/提交
				}else{
					if("tj".equals(opFlag)){						
						if(!userSubOrg.startsWith("C105001005")&&//塔里木物探处
								!userSubOrg.startsWith("C105001002")&&//新疆物探处
								!userSubOrg.startsWith("C105001003")&&//吐哈物探处
								!userSubOrg.startsWith("C105001004")&&//青海物探处
								!userSubOrg.startsWith("C105005004")&&//长庆物探处
								!userSubOrg.startsWith("C105005000")&&//华北物探处
								!userSubOrg.startsWith("C105005001")&&//新兴物探处
								!userSubOrg.startsWith("C105007")&&//大港物探处
								!userSubOrg.startsWith("C105063")&&//辽河物探处
								!userSubOrg.startsWith("C105008")&&//综合物化处
								!userSubOrg.startsWith("C105002")&&//国际勘探事业部
								!userSubOrg.startsWith("C105086")){//深海物探处
							delFlag = "4";//用户所在单位不能提交单据	
						}else{
							String delSql = "update gms_device_hireapp"
										  + " set state='1',"
										  + " updator_id='"+user.getEmpId()+"',"
										  + " modifi_date = sysdate"
										  + " where device_hireapp_id='"+hireAppId+"'";
							jdbcDao.executeUpdate(delSql);
						}
					}else if("del".equals(opFlag)){
						String delSql = "update gms_device_hireapp"
									  + " set bsflag = '1',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where device_hireapp_id='"+hireAppId+"'";
						jdbcDao.executeUpdate(delSql);
						String delDetSql = "update gms_device_hireapp_detail"
										 + " set bsflag = '1'"
										 + " where device_hireapp_id='"+hireAppId+"'";
						jdbcDao.executeUpdate(delDetSql);
					}
				}
			}else{
				delFlag = "3";//删除/提交/修改失败
			}
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除/提交/修改失败
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 物探处直接调外租设备保存
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateHireDevInfo(ISrvMsg msg) throws Exception {
		
		UserToken user = msg.getUserToken();
		String hireAppId = wtcDevSrv.saveHireDevApp(msg);
		String employeeId = msg.getValue("employee_id");
		String projectInfoNo = msg.getValue("projectInfoNo");

		String delSql = "delete from gms_device_hireapp_detail where device_hireapp_id = '"
					  + hireAppId + "'";
		jdbcDao.executeUpdate(delSql);
		
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < lineinfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[index];
			dataMap.put("device_hireapp_id", hireAppId);
			dataMap.put("project_info_no", projectInfoNo);
			dataMap.put("team", msg.getValue("team" + keyid));
			dataMap.put("apply_num", msg.getValue("neednum" + keyid));
			dataMap.put("purpose", msg.getValue("purpose" + keyid));
			dataMap.put("plan_start_date", msg.getValue("startdate" + keyid));
			dataMap.put("plan_end_date", msg.getValue("enddate" + keyid));
			dataMap.put("employee_id", employeeId);
			dataMap.put("unitinfo", msg.getValue("unit" + keyid));
			dataMap.put("devrental", msg.getValue("devrental" + keyid));
			dataMap.put("rentname", msg.getValue("rentname" + keyid));
			dataMap.put("dev_name", msg.getValue("devicename" + keyid));
			dataMap.put("dev_type", msg.getValue("devicetype" + keyid));
			datasList.add(dataMap);
		}
		String insMixDetSql = "insert into gms_device_hireapp_detail(device_app_detid,device_hireapp_id,project_info_no,team,"
							+ " apply_num,purpose,plan_start_date,plan_end_date,employee_id,create_date,unitinfo,bsflag,devrental,"
							+ " rentname,state,dev_name,dev_type)"
							+ " values(?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?,?,?,?,?,?)";
		jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) devSaveMap.get("device_hireapp_id"));
						ps.setString(3, (String) devSaveMap.get("project_info_no"));
						ps.setString(4, (String) devSaveMap.get("team"));
						ps.setString(5, (String) devSaveMap.get("apply_num"));
						ps.setString(6, (String) devSaveMap.get("purpose"));
						ps.setString(7, (String) devSaveMap.get("plan_start_date"));
						ps.setString(8, (String) devSaveMap.get("plan_end_date"));
						ps.setString(9, (String) devSaveMap.get("employee_id"));
						ps.setString(10, DevUtil.getCurrentTime());
						ps.setString(11, (String) devSaveMap.get("unitinfo"));
						ps.setString(12, DevConstants.STATE_SAVED);
						ps.setString(13, (String) devSaveMap.get("devrental"));
						ps.setString(14, (String) devSaveMap.get("rentname"));
						ps.setString(15, DevConstants.STATE_SAVED);					
						ps.setString(16, (String) devSaveMap.get("dev_name"));
						ps.setString(17, (String) devSaveMap.get("dev_type"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 查询外租申请单主表信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireAppBaseInfo(ISrvMsg msg) throws Exception {
		String hireAppId = msg.getValue("devicehireappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select devapp.device_hireapp_id,pro.project_name,devapp.device_hireapp_no,devapp.device_hireapp_name,"
						+ " case devapp.opr_state when '1' then '处理中' when '9' then '已处理' when '4' then '关闭' else '未处理' end as state_desc,"
						+ " org.org_abbreviation as org_name,emp.employee_name,d.coding_name as mix_type_name,"
						+ " devapp.appdate from gms_device_hireapp devapp"
						+ " left join comm_org_information org on devapp.org_id = org.org_id and org.bsflag = '0'"
						+ " left join comm_coding_sort_detail d on d.coding_code_id = devapp.mix_type_id"
						+ " left join comm_human_employee emp on devapp.employee_id = emp.employee_id"
						+ " left join gp_task_project pro on devapp.project_info_no=pro.project_info_no "
						+ " where devapp.device_hireapp_id ='"+ hireAppId + "'");
		Map hireMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(hireMap)) {
			responseMsg.setValue("hireMap", hireMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 查询外租申请单明细表信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireAppDetBaseInfo(ISrvMsg msg) throws Exception {
		String hireAppDetId = msg.getValue("devicehireappdetid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select appdet.device_app_detid,sd.coding_name as unitname,teamsd.coding_name as teamname,"
						+ " pro.project_name,appdet.dev_name,appdet.dev_type as dev_model,nvl(appdet.apply_num,0) apply_num,"
						+ " appdet.purpose,emp.employee_name, appdet.plan_start_date,appdet.plan_end_date,appdet.devrental,"
						+ " nvl(appdet.mix_num,0) mix_num,appdet.rentname,devapp.mix_type_id,devapp.mix_type_name"
						+ " from gms_device_hireapp_detail appdet"
						+ " left join gms_device_hireapp devapp on appdet.device_hireapp_id = devapp.device_hireapp_id"
						+ " left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id"
						+ " left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id"
						+ " left join gp_task_project pro on appdet.project_info_no = pro.project_info_no"
						+ " left join comm_human_employee emp on appdet.employee_id = emp.employee_id"
						+ " where appdet.device_app_detid= '"+hireAppDetId+"' ");
		Map hireDetMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(hireDetMap)) {
			responseMsg.setValue("hireDetMap", hireDetMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 显示需要填报外租设备的明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireDevFillInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String hireAppDetId = msg.getValue("hireappdetid");
		StringBuffer sb = new StringBuffer()
			.append("select hd.device_hireapp_id,pro.project_name,teamsd.coding_name as teamname,"
					+ " hd.dev_name,hd.dev_type as dev_model,team,device_app_detid,hd.unitinfo,"
					+ " hd.dev_ci_code,nvl(apply_num,0) as apply_num,nvl(mix_num,0) as mix_num,"
					+ " plan_start_date,plan_end_date,ha.org_id,org.org_name,ha.app_org_id,"
					+ " apporg.org_name as app_org_name,ha.org_subjection_id,hd.rentname,"
					+ " sub.org_subjection_id as duisubid from gms_device_hireapp_detail hd"
					+ " left join gp_task_project pro on pro.project_info_no = hd.project_info_no"
					+ " left join comm_coding_sort_detail teamsd on hd.team = teamsd.coding_code_id"
					+ " left join gms_device_hireapp ha on hd.device_hireapp_id = ha.device_hireapp_id"
					+ " left join comm_org_information org on org.org_id=ha.org_id and org.bsflag ='0'"
					+ " left join comm_org_information apporg on apporg.org_id=ha.app_org_id and apporg.bsflag ='0'"
					+ " left join comm_org_subjection sub on ha.app_org_id = sub.org_id and sub.bsflag = '0'"
					+ " where hd.device_app_detid ='"+hireAppDetId+"'");
		Map fillMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(fillMap)) {
			responseDTO.setValue("fillMap", fillMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 保存外租申请填报设备明细表
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHireDevFillInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String projectInfoNo = msg.getValue("project_info_no");
		String devAppDetId = msg.getValue("deviceappdetid");
		String applyNum = msg.getValue("applynum");
		String mixNum = msg.getValue("mixnum");
		String inOrgId = msg.getValue("inorgid");
		String outOrgId = msg.getValue("outorgid");
		String team = msg.getValue("team");
		String devUnit = msg.getValue("devunit");
		String rentName = msg.getValue("rentname");
		String hireAppId = msg.getValue("hireappid");
		int apply_num = Integer.parseInt(applyNum);//申请数量
		int mix_num = Integer.parseInt(mixNum);//已填报数量
				
		String[] lineInfos = msg.getValue("checklines").split("~", -1);
		int checkNum = lineInfos.length;// 本次填报数量
			mix_num = mix_num + checkNum;
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < lineInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String devAccId = jdbcDao.generateUUID();
			dataMap.put("dev_acc_id", devAccId);
			dataMap.put("dev_name", msg.getValue("detdev_ci_name" + lineInfos[index]));
			dataMap.put("dev_model", msg.getValue("detdev_ci_model" + lineInfos[index]));
			dataMap.put("dev_sign", msg.getValue("dev_sign" + lineInfos[index]));
			dataMap.put("dev_type", msg.getValue("detdev_ci_code" + lineInfos[index]));
			dataMap.put("dev_unit", devUnit);
			dataMap.put("tech_stat", DevConstants.DEV_TECH_WANHAO);
			dataMap.put("using_stat", DevConstants.DEV_USING_ZAIYONG);
			dataMap.put("owning_org_id", msg.getValue("ownorgid" + lineInfos[index]));
			dataMap.put("owning_sub_id", msg.getValue("orgsubjectionid" + lineInfos[index]));
			dataMap.put("owning_org_name", msg.getValue("ownorgname" + lineInfos[index]));
			dataMap.put("usage_org_id", msg.getValue("usageorgid" + lineInfos[index]));
			dataMap.put("usage_sub_id", msg.getValue("usagesubid" + lineInfos[index]));
			dataMap.put("usage_org_name", msg.getValue("usageorgname" + lineInfos[index]));
			dataMap.put("account_stat", DevConstants.DEV_ACCOUNT_WAIZU);
			dataMap.put("license_num", msg.getValue("license_num" + lineInfos[index]));
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			dataMap.put("creator", user.getEmpId());
			dataMap.put("create_date", DevUtil.getCurrentTime());
			dataMap.put("modifier", user.getEmpId());
			dataMap.put("modifi_date", DevUtil.getCurrentTime());
			dataMap.put("planning_in_time", msg.getValue("startdate" + lineInfos[index]));
			dataMap.put("planning_out_time", msg.getValue("enddate" + lineInfos[index]));
			dataMap.put("actual_in_time", msg.getValue("realstartdate" + lineInfos[index]));
			dataMap.put("project_info_id", projectInfoNo);
			dataMap.put("out_org_id", outOrgId);
			dataMap.put("in_org_id", inOrgId);
			dataMap.put("is_leaving", DevConstants.BSFLAG_NORMAL);
			dataMap.put("dev_team", team);
			dataMap.put("mix_type_id", DevConstants.BACK_DEVTYPE_WAIZU);
			dataMap.put("rentname", rentName);
			dataMap.put("devrental", msg.getValue("devrental" + lineInfos[index]));
			dataMap.put("device_app_detid", devAppDetId);
			datasList.add(dataMap);
		}
		
		String insDuiSql = "insert into gms_device_account_dui(dev_acc_id,dev_name,dev_model,dev_sign,"
						 + " dev_type,dev_unit,tech_stat,using_stat,owning_org_id,owning_sub_id,owning_org_name,"
						 + " usage_org_name,usage_org_id,usage_sub_id,account_stat,license_num,bsflag,creator,"
						 + " create_date,modifier,modifi_date,planning_in_time,planning_out_time,actual_in_time,"
						 + " project_info_id,out_org_id,in_org_id,is_leaving,fk_device_appmix_id,dev_team,mix_type_id)"
						 + " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,"
						 + " to_date(?,'yyyy-mm-dd hh24:mi:ss'),to_date(?,'yyyy-mm-dd'),"
						 + " to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?,?,?,?,?,?)";
		jdbcDao.getJdbcTemplate().batchUpdate(insDuiSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, (String) devSaveMap.get("dev_acc_id"));
						ps.setString(2, (String) devSaveMap.get("dev_name"));
						ps.setString(3, (String) devSaveMap.get("dev_model"));
						ps.setString(4, (String) devSaveMap.get("dev_sign"));
						ps.setString(5, (String) devSaveMap.get("dev_type"));
						ps.setString(6, (String) devSaveMap.get("dev_unit"));
						ps.setString(7, (String) devSaveMap.get("tech_stat"));
						ps.setString(8, (String) devSaveMap.get("using_stat"));
						ps.setString(9, (String) devSaveMap.get("owning_org_id"));
						ps.setString(10, (String) devSaveMap.get("owning_sub_id"));
						ps.setString(11, (String) devSaveMap.get("owning_org_name"));
						ps.setString(12, (String) devSaveMap.get("usage_org_name"));
						ps.setString(13, (String) devSaveMap.get("usage_org_id"));
						ps.setString(14, (String) devSaveMap.get("usage_sub_id"));
						ps.setString(15, (String) devSaveMap.get("account_stat"));
						ps.setString(16, (String) devSaveMap.get("license_num"));
						ps.setString(17, (String) devSaveMap.get("bsflag"));
						ps.setString(18, (String) devSaveMap.get("creator"));
						ps.setString(19, (String) devSaveMap.get("create_date"));
						ps.setString(20, (String) devSaveMap.get("modifier"));
						ps.setString(21, (String) devSaveMap.get("modifi_date"));
						ps.setString(22, (String) devSaveMap.get("planning_in_time"));
						ps.setString(23, (String) devSaveMap.get("planning_out_time"));
						ps.setString(24, (String) devSaveMap.get("actual_in_time"));
						ps.setString(25, (String) devSaveMap.get("project_info_id"));
						ps.setString(26, (String) devSaveMap.get("out_org_id"));
						ps.setString(27, (String) devSaveMap.get("in_org_id"));
						ps.setString(28, (String) devSaveMap.get("is_leaving"));
						ps.setString(29, (String) devSaveMap.get("device_app_detid"));
						ps.setString(30, (String) devSaveMap.get("dev_team"));
						ps.setString(31, (String) devSaveMap.get("mix_type_id"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		//插入外租设备动态信息表
		String insFillSql = "insert into gms_device_hirefill_detail(device_appmix_id,device_app_detid,"
							+ " dev_acc_id,dev_sign,license_num,dev_plan_start_date,dev_plan_end_date,"
							+ " team,devrental,rentname,receive_date"
							+ " )values(?,?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),"
							+ " ?,?,?,to_date(?,'yyyy-mm-dd'))";
		jdbcDao.getJdbcTemplate().batchUpdate(insFillSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> fillMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) fillMap.get("device_app_detid"));
						ps.setString(3, (String) fillMap.get("dev_acc_id"));
						ps.setString(4, (String) fillMap.get("dev_sign"));
						ps.setString(5, (String) fillMap.get("license_num"));
						ps.setString(6, (String) fillMap.get("planning_in_time"));
						ps.setString(7, (String) fillMap.get("planning_out_time"));
						ps.setString(8, (String) fillMap.get("dev_team"));
						ps.setString(9, (String) fillMap.get("devrental"));
						ps.setString(10, (String) fillMap.get("rentname"));
						ps.setString(11, (String) fillMap.get("actual_in_time"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		// 根据已审批数量判断处理状态
		if (mix_num - apply_num == 0) {
			jdbcDao.executeUpdate("update gms_device_hireapp_detail set state='1'"
								   + " where device_app_detid='"+ devAppDetId + "'");
		} 
		if (mix_num != 0 && (mix_num < apply_num) ) {
			jdbcDao.executeUpdate("update gms_device_hireapp_detail set state='2'"
					              + " where device_app_detid='"+ devAppDetId + "'");
		}

		jdbcDao.executeUpdate("update gms_device_hireapp_detail set mix_num="+mix_num+" where device_app_detid='"+devAppDetId+"'");
		
		//更新外租调配单
		String upAppSql1 = "update gms_device_hireapp app set app.opr_state = '1'"
						 + " where exists (select 1 from gms_device_hireapp_detail dad"
						 + " where dad.device_hireapp_id='" + hireAppId + "' and (dad.state!='1' or dad.state is null))"
						 + " and app.device_hireapp_id = '" + hireAppId + "'";
		
		String upAppSql2 = "update gms_device_hireapp app set app.opr_state='9'"
						 + " where not exists(select 1 from gms_device_hireapp_detail dad"
						 + " where dad.device_hireapp_id='"+ hireAppId + "'"
						 + " and (dad.state!='1' or dad.state is null))"
						 + " and app.device_hireapp_id = '" + hireAppId + "'";
		jdbcDao.executeUpdate(upAppSql1);
		jdbcDao.executeUpdate(upAppSql2);
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 外租设备离场设备信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireDevOutInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectInfoId = msg.getValue("projectinfoid");
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select acc.dev_acc_id,acc.asset_coding,acc.self_num,acc.dev_sign,acc.license_num,"
						+ " acc.actual_in_time,acc.planning_out_time,acc.actual_out_time,acc.dev_name,acc.dev_model,"
						+ " case acc.is_leaving when '0' then '未离场' else '已离场' end as is_leaving_desc"
						+ " from gms_device_account_dui acc where acc.bsflag = '0'"
						+ " and acc.account_stat = '"+DevConstants.DEV_ACCOUNT_WAIZU+"'"
						+ " and acc.project_info_id = "+projectInfoId+"");
		//设备名称
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//设备型号
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '%"+devModel+"%'");
		}
		//实物标识号
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and acc.dev_sign like '%"+devSign+"%'");
		}
		//车牌号
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and acc.license_num like '%"+licenseNum+"%'");
		}
		querySql.append(" order by acc.is_leaving nulls first,acc.create_date,acc.dev_type ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 查询外租设备单台明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireDevInfo(ISrvMsg msg) throws Exception {
		String devAccId = msg.getValue("devaccid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select acc.dev_sign,acc.license_num,acc.actual_in_time,"
						+ " acc.planning_out_time,acc.actual_out_time,acc.dev_name,acc.dev_model,"
						+ " case acc.is_leaving when '0' then '未离场' else '已离场' end as is_leaving_desc"
						+ " from gms_device_account_dui acc"
						+ " where acc.dev_acc_id = '"+devAccId+"' ");
		Map devMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devMap)) {
			responseMsg.setValue("devMap", devMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 保存外租设备离场的信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHireDevLeftInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();		
		
		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		String[] checkLines = msg.getValue("checklines").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("actual_out_time", msg.getValue("enddate" + checkLines[index]));
			dataMap.put("is_leaving", DevConstants.DEVLEAVING_YES);
			dataMap.put("modifier", user.getEmpId());
			datasList.add(dataMap);
		}
		//更新队级台账标识
		String upDevSaveSql = "update gms_device_account_dui set "
							+ " actual_out_time = to_date(?,'yyyy-mm-dd hh24:mi:ss'),"
							+ " is_leaving = '1',"
							+ " using_stat = '"+DevConstants.DEV_USING_XIANZHI+"',"
							+ " modifi_date = sysdate,"
							+ " modifier = ?,"
							+ " check_time = sysdate"
							+ " where dev_acc_id = ? ";
		jdbcDao.getJdbcTemplate().batchUpdate(upDevSaveSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devUpMap = datasList.get(i);
						ps.setString(1, (String) devUpMap.get("actual_out_time"));
						ps.setString(2, (String) devUpMap.get("modifier"));
						ps.setString(3, (String) devUpMap.get("dev_acc_id"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		
		//更新外租设备动态表
		String upHireDevSql = "update gms_device_hirefill_detail set "
							+ " actual_out_time = to_date(?,'yyyy-mm-dd')"
							+ " where dev_acc_id = ? ";
		jdbcDao.getJdbcTemplate().batchUpdate(upHireDevSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devFillMap = datasList.get(i);
						ps.setString(1, (String) devFillMap.get("actual_out_time"));
						ps.setString(2, (String) devFillMap.get("dev_acc_id"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 外租检波器接收时显示在队的检波器信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireDuiJBQInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String deviceId = msg.getValue("device_id");
		String projectInfoNo = msg.getValue("projectinfono");
		StringBuffer sb = new StringBuffer()
			.append( "select dui.dev_acc_id,nvl(dui.total_num,0) as total_num,"
		             + " nvl(dui.use_num,0) as use_num,nvl(dui.unuse_num,0) as unuse_num"
		             + " from gms_device_coll_account_dui dui"
		             + " where dui.is_leaving = '0' and dui.project_info_id = '"+projectInfoNo+"' "
		             + " and dui.account_stat = '"+DevConstants.DEV_ACCOUNT_WAIZU+"'"		            
		             + " and dui.device_id = '"+deviceId+"' ");
		Map jbqMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(jbqMap)) {
			responseDTO.setValue("jbqMap", jbqMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 外租检波器接收保存
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitWtcHireJBQReceive(ISrvMsg msg) throws Exception {

		UserToken user = msg.getUserToken();
		String projectInfoNo = msg.getValue("projectinfono");
		String devAppDetId = msg.getValue("deviceappdetid");
		String hireAppId = msg.getValue("hireappid");
		String devAccId = msg.getValue("devaccid");         //队级台账ID
		String applyNum = msg.getValue("applynum");         //转入数量
		
		// 1.队级台账更新或插入
		Map<String, Object> duiMap = new HashMap<String, Object>();
		if (DevUtil.isValueNotNull(devAccId)) {
			duiMap.put("dev_acc_id", devAccId);
		}
		duiMap.put("project_info_id", projectInfoNo);
		duiMap.put("dev_name", msg.getValue("dev_name"));
		duiMap.put("dev_model", msg.getValue("dev_model"));
		duiMap.put("out_org_id", msg.getValue("outorgid"));
		duiMap.put("in_org_id", msg.getValue("inorgid"));
		duiMap.put("actual_in_time", msg.getValue("actual_in_time"));
		duiMap.put("planning_in_time", msg.getValue("plan_start_date"));
		duiMap.put("planning_out_time", msg.getValue("plan_end_date"));
		duiMap.put("dev_unit", msg.getValue("devunit"));
		duiMap.put("dev_team", msg.getValue("team"));
		duiMap.put("is_leaving", DevConstants.STATE_SAVED);
		duiMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		duiMap.put("account_stat", DevConstants.DEV_ACCOUNT_WAIZU);
		duiMap.put("device_id", msg.getValue("deviceid"));
		duiMap.put("total_num", msg.getValue("new_total_num"));
		duiMap.put("unuse_num", msg.getValue("new_unuse_num"));
		duiMap.put("use_num", msg.getValue("new_use_num"));
		duiMap.put("create_date", DevUtil.getCurrentTime());
		duiMap.put("creator", user.getEmpId());
		duiMap.put("modifi_date", DevUtil.getCurrentTime());
		duiMap.put("modifier", user.getEmpId());
		duiMap.put("fk_device_appmix_id", devAppDetId);
		Serializable keyid = jdbcDao.saveOrUpdateEntity(duiMap,
				"gms_device_coll_account_dui");
		// 2.队级台账动态表插入
		Map<String, Object> dymMap = new HashMap<String, Object>();
		dymMap.put("dev_acc_id", keyid.toString());
		dymMap.put("opr_type", DevConstants.DYM_OPRTYPE_OUT);
		dymMap.put("receive_num", applyNum);
		dymMap.put("actual_in_time", msg.getValue("actual_in_time"));
		dymMap.put("create_date", DevUtil.getCurrentTime());
		dymMap.put("creator", user.getEmpId());
		jdbcDao.saveOrUpdateEntity(dymMap, "gms_device_coll_account_dym");
		
		//更新外租检波器已接收并更新验收数量
		jdbcDao.executeUpdate("update gms_device_hireapp_detail set state='1',mix_num="+applyNum+" where device_app_detid='"+ devAppDetId + "'");
		
		//更新外租调配单
		String upAppSql1 = "update gms_device_hireapp app set app.opr_state = '1'"
						 + " where exists (select 1 from gms_device_hireapp_detail dad"
						 + " where dad.device_hireapp_id='" + hireAppId + "'"
						 + " and (dad.state!='1' or dad.state is null))"
						 + " and app.device_hireapp_id = '" + hireAppId + "'";
		
		String upAppSql2 = "update gms_device_hireapp app set app.opr_state='9'"
						 + " where not exists(select 1 from gms_device_hireapp_detail dad"
						 + " where dad.device_hireapp_id='"+ hireAppId + "'"
						 + " and (dad.state!='1' or dad.state is null))"
						 + " and app.device_hireapp_id = '" + hireAppId + "'";
		jdbcDao.executeUpdate(upAppSql1);
		jdbcDao.executeUpdate(upAppSql2);
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	/**
	 * NEWMETHOD 外租检波器离场设备信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireJBQOutInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectInfoId = msg.getValue("projectinfoid");
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select acc.dev_acc_id,acc.total_num,acc.unuse_num,acc.use_num,acc.actual_in_time,"
						+ " acc.planning_out_time,acc.actual_out_time,acc.dev_name,acc.dev_model,acc.is_leaving,"
						+ " case acc.is_leaving when '0' then '未离场' else '已离场' end as is_leaving_desc"
						+ " from gms_device_coll_account_dui acc where acc.bsflag = '0'"
						+ " and acc.account_stat = '"+DevConstants.DEV_ACCOUNT_WAIZU+"'"
						+ " and acc.project_info_id = "+projectInfoId);
		//设备名称
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//设备型号
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '%"+devModel+"%'");
		}
		querySql.append(" order by acc.is_leaving nulls first,acc.create_date,acc.dev_model ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 查询外租检波器在队明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireJBQInfo(ISrvMsg msg) throws Exception {
		String devAccId = msg.getValue("devaccid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select acc.dev_acc_id,acc.total_num,acc.unuse_num,acc.use_num,acc.actual_in_time,"
						+ " acc.planning_out_time,acc.actual_out_time,acc.dev_name,acc.dev_model,"
						+ " case acc.is_leaving when '0' then '未离场' else '已离场' end as is_leaving_desc"
						+ " from gms_device_coll_account_dui acc"
						+ " where acc.dev_acc_id = '"+devAccId+"' ");
		Map devMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devMap)) {
			responseMsg.setValue("devMap", devMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 保存外租检波器离场的信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHireJBQLeftInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String unuseNum = msg.getValue("unuse_num");//在队数量(本次离场数量)
		String useNum = msg.getValue("use_num");//已离场数量
		String opFlag = msg.getValue("opflag");//修改离场时间标识
		
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("dev_acc_id", msg.getValue("dev_acc_id"));
		if(opFlag == null || !"mod".equals(opFlag)){
			dataMap.put("use_num", Integer.parseInt(useNum)+Integer.parseInt(unuseNum));
			dataMap.put("unuse_num", "0");
			dataMap.put("is_leaving", DevConstants.DEVLEAVING_YES);
		}
		dataMap.put("actual_out_time", msg.getValue("actual_out_time"));
		dataMap.put("modifier", user.getEmpId());
		dataMap.put("modifi_date", DevUtil.getCurrentTime());
		jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_coll_account_dui");
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 设备报停计划显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOsAppPlanInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectInfoId = msg.getValue("projectinfoid");
		String osAppNo = msg.getValue("osappno");
		String osAppName = msg.getValue("osappname");

		StringBuffer querySql = new StringBuffer();
			querySql.append( "select pro.project_name,devapp.device_osapp_id,devapp.device_osapp_no,devapp.osapp_name,devapp.project_info_no,"
					+ " devapp.osapp_org_id,devapp.os_employee_id,devapp.osappdate,devapp.create_date,devapp.modifi_date,wfmiddle.proc_status,"
					+ " case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,"
					+ " org.org_abbreviation as org_name,emp.employee_name"
					+ " from gms_device_osapp devapp"
					+ " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_osapp_id and wfmiddle.bsflag='0'"
					+ " left join comm_org_information org on devapp.osapp_org_id = org.org_id and org.bsflag='0'"
					+ " left join comm_human_employee emp on devapp.os_employee_id = emp.employee_id"
					+ " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
					+ " where devapp.bsflag = '0' and devapp.project_info_no = "+projectInfoId);
		//申请单号
		if (StringUtils.isNotBlank(osAppNo)) {
			querySql.append(" and devapp.device_osapp_no like '%"+osAppNo+"%'");
		}
		//申请但名称
		if (StringUtils.isNotBlank(osAppName)) {
			querySql.append(" and devapp.osapp_name like '%"+osAppName+"%'");
		}
		querySql.append(" order by wfmiddle.proc_status nulls first,devapp.create_date ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 查询报停计划申请单主表信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOsAppBaseInfo(ISrvMsg msg) throws Exception {
		String devOsAppId = msg.getValue("deviceosappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select project.project_name,devapp.device_osapp_id,devapp.device_osapp_no,devapp.osapp_name,"
						+ " devapp.osappdate,devapp.create_date,wf.proc_status,case wf.proc_status when '1' then '待审批'"
						+ " when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,"
						+ " org.org_name,emp.employee_name"
						+ " from gms_device_osapp devapp left join comm_org_information org on devapp.osapp_org_id=org.org_id"
						+ " left join common_busi_wf_middle wf on wf.business_id=devapp.device_osapp_id"
						+ " left join comm_human_employee emp on devapp.os_employee_id=emp.employee_id"
						+ " left join gp_task_project project on devapp.project_info_no=project.project_info_no"
						+ " where devapp.bsflag='0' and devapp.device_osapp_id = '" + devOsAppId + "'");
		Map osMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(osMap)) {
			responseMsg.setValue("osMap", osMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 查询报停计划明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOsAppPlanDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String osAppId = msg.getValue("osappid");
		String sql = "select alldet.device_osdet_id,alldet.device_osapp_id,alldet.dev_name,alldet.dev_model,"
				    + " outorg.org_abbreviation as out_org_name,alldet.dev_coding,alldet.self_num,alldet.dev_sign,"
					+ " alldet.license_num,alldet.osnum,unitsd.coding_name as unit_name,"
					+ " alldet.reason,alldet.start_date,alldet.plan_end_date,alldet.devtype,alldet.act_in_time "
					+ " from gms_device_osapp_detail alldet"
					+ " left join comm_coding_sort_detail sd on alldet.dev_name=sd.coding_code_id"
					+ " left join comm_org_subjection sub on alldet.out_org_id = sub.org_subjection_id and sub.bsflag = '0'"
					+ " left join comm_org_information outorg on sub.org_id = outorg.org_id and outorg.bsflag = '0'"
					+ " left join comm_coding_sort_detail unitsd on alldet.dev_unit=unitsd.coding_code_id"
					+ " where alldet.device_osapp_id = '"+osAppId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 保存设备报停申请单信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOsAppDevInfo(ISrvMsg msg) throws Exception {
		String deviceOsAppId = wtcDevSrv.saveDevOsApp(msg);
		
		String delSql = "delete from gms_device_osapp_detail os where os.device_osapp_id='"
			  + deviceOsAppId + "'";
		jdbcDao.executeUpdate(delSql);
		
		String[] lineInfos = msg.getValue("lineinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < lineInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("device_osapp_id", deviceOsAppId);
			dataMap.put("dev_acc_id",  msg.getValue("devaccid" + lineInfos[index]));
			dataMap.put("dev_coding", msg.getValue("devcoding" + lineInfos[index]));
			dataMap.put("self_num", msg.getValue("selfnum" + lineInfos[index]));
			dataMap.put("dev_sign", msg.getValue("devsign" + lineInfos[index]));
			dataMap.put("license_num", msg.getValue("licensenum" + lineInfos[index]));
			dataMap.put("dev_unit", msg.getValue("devunit" + lineInfos[index]));
			dataMap.put("osnum", "1");
			dataMap.put("reason", msg.getValue("reason" + lineInfos[index]));
			dataMap.put("start_date", msg.getValue("startdate" + lineInfos[index]));
			dataMap.put("plan_end_date", msg.getValue("enddate" + lineInfos[index]));
			dataMap.put("dev_name", msg.getValue("devname" + lineInfos[index]));
			dataMap.put("dev_model", msg.getValue("devmodel" + lineInfos[index]));
			dataMap.put("out_org_id", msg.getValue("outorgid" + lineInfos[index]));
			dataMap.put("act_in_time", msg.getValue("actualdate" + lineInfos[index]));
			datasList.add(dataMap);
		}
		String insOsDetSql = "insert into gms_device_osapp_detail("
							+ " device_osdet_id,"
							+ " device_osapp_id,"
							+ " dev_acc_id,"
							+ " dev_coding,"
							+ " self_num,"
							+ " dev_sign,"
							+ " license_num,"
							+ " dev_unit,"
							+ " osnum,"
							+ " reason,"
							+ " start_date,"
							+ " plan_end_date,"
							+ " devtype,"
							+ " dev_name,"
							+ " dev_model,"
							+ " out_org_id,"
							+ " act_in_time"
							+ " )values(?,?,?,?,?,?,?,?,?,?,"
							+ " to_date(?,'yyyy-mm-dd hh24:mi:ss'),to_date(?,'yyyy-mm-dd hh24:mi:ss'),"
							+ " ?,?,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'))";
		jdbcDao.getJdbcTemplate().batchUpdate(insOsDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) devSaveMap.get("device_osapp_id"));
						ps.setString(3, (String) devSaveMap.get("dev_acc_id"));
						ps.setString(4, (String) devSaveMap.get("dev_coding"));
						ps.setString(5, (String) devSaveMap.get("self_num"));
						ps.setString(6, (String) devSaveMap.get("dev_sign"));
						ps.setString(7, (String) devSaveMap.get("license_num"));
						ps.setString(8, (String) devSaveMap.get("dev_unit"));
						ps.setInt(9, Integer.parseInt((String) devSaveMap.get("osnum")));
						ps.setString(10, (String) devSaveMap.get("reason"));
						ps.setString(11, (String) devSaveMap.get("start_date"));
						ps.setString(12, (String) devSaveMap.get("plan_end_date"));
						ps.setString(13, "1");
						ps.setString(14, (String) devSaveMap.get("dev_name"));
						ps.setString(15, (String) devSaveMap.get("dev_model"));
						ps.setString(16, (String) devSaveMap.get("out_org_id"));
						ps.setString(17, (String) devSaveMap.get("act_in_time"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 根据设备ID获得设备相关信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOsDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String condition = msg.getValue("condition");
		String proFlag = msg.getValue("proflag");
		String projectNo = msg.getValue("projectno");
		String sql = "select acc.dev_acc_id,acc.dev_name,acc.dev_model,acc.dev_unit,acc.out_org_id,"
				   + " acc.license_num,acc.dev_coding,acc.self_num,acc.actual_in_time,acc.dev_type,"
				   + " acc.tech_stat,acc.using_stat,acc.owning_org_id,acc.owning_sub_id,acc.dev_team,"
				   + " acc.fk_dev_acc_id,acc.account_stat,acc.out_org_id,acc.mix_type_id,"
				   + " acc.planning_out_time,acc.dev_sign from gms_device_account_dui acc";
				   if(DevUtil.isValueNotNull(proFlag,DevConstants.PROJECT_XN)){
					   sql += " where acc.project_info_id = '"+projectNo+"'"
							+ " and (acc.transfer_state != '"+DevConstants.DEV_TRANSFER_STATE_MID+"'"
							+ " or acc.transfer_state is null)"
							+ " and acc.is_leaving = '"+DevConstants.DEV_LEAVING_NO+"'"
							+ " and acc.bsflag = '"+DevConstants.BSFLAG_NORMAL+"'";
				   }else{
					   sql += " where acc.dev_acc_id in"+condition;
				   }
		List<Map> unitList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 删除、修改、提交设备报停计划单据状态判断
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opOsDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String delFlag = "0";
		String osState = "";
		String deviceOsAppId = msg.getValue("deviceosappid");
		String opFlag = msg.getValue("opflag");
		try{
			String appSql = "select nvl(wfmiddle.proc_status,'') as proc_status from gms_device_osapp devapp"
						  + " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_osapp_id"
						  + " and wfmiddle.bsflag = '0' where devapp.device_osapp_id = '"+deviceOsAppId+"' ";
			Map osMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(osMap)){
				osState = osMap.get("proc_status").toString();
				if("1".equals(osState) || "3".equals(osState)){
					delFlag = "1";//已提交的单据不能删除/修改/提交
				}else{
					if("del".equals(opFlag)){
						String upSaveFlagSql = "";
						String delSql = "update gms_device_osapp"
									  + " set bsflag = '1',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where device_osapp_id='"+deviceOsAppId+"'";
						jdbcDao.executeUpdate(delSql);
					}
				}
			}else{
				delFlag = "3";//删除/提交/修改失败
			}
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除/提交/修改失败
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 设备报停计划显示主要信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOsMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String deviceOsAppId = msg.getValue("deviceosappId");
		StringBuffer sb = new StringBuffer()
			.append( "select pro.project_name,app.project_info_no,app.device_osapp_id,app.device_osapp_no,"
					  + " app.osapp_name,app.osappdate,info.org_name,app.os_employee_id,emp.employee_name,"
					  + " app.osapp_org_id from gms_device_osapp app"
					  + " left join gp_task_project pro on pro.project_info_no = app.project_info_no"
					  + " left join comm_human_employee emp on app.os_employee_id = emp.employee_id and emp.bsflag = '0'"
					  + " left join comm_org_information info on info.org_id = app.osapp_org_id and info.bsflag = '0'"
				      + " where app.device_osapp_id = '"+deviceOsAppId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 报停计划设备明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOsApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String deviceOsAppId = msg.getValue("deviceosappId");
		String sql = "select os.dev_acc_id,os.dev_name,os.self_num,os.dev_sign,os.license_num,"
				   + " os.dev_model,os.dev_coding,os.act_in_time as actual_in_time,os.reason,"
				   + " os.start_date,os.plan_end_date,os.dev_unit,os.out_org_id"
				   + " from gms_device_osapp_detail os"
				   + " where os.device_osapp_id = '"+deviceOsAppId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 更新报停设备队级台账报停日期
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWtcDevOSAppAuditInfowfpa(ISrvMsg msg) throws Exception {
		String oprState = msg.getValue("oprstate");
		String endFlag = msg.getValue("endflag");
		String deviceOsAppId = msg.getValue("deviceosappid");
		
		if ("pass".equals(oprState)&&"END_NODE".equals(endFlag)) {
			String[] idInfos = msg.getValue("idinfos").split("~", -1);
			final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
			for (int index = 0; index < idInfos.length; index++) {
				Map<String, Object> dataMap = new HashMap<String, Object>();
				dataMap.put("dev_acc_id", idInfos[index]);
				dataMap.put("using_stat", DevConstants.DEV_USING_TINGYONG);
				dataMap.put("stop_date", msg.getValue("startdate" + index));
				datasList.add(dataMap);
			}			
			//更新队级台账
			String upDevSaveSql = "update gms_device_account_dui set "
								+ " stop_date = to_date(?,'yyyy-mm-dd hh24:mi:ss'),"
								+ " using_stat = ?"
								+ " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDevSaveSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devUpMap = datasList.get(i);
							ps.setString(1, (String) devUpMap.get("stop_date"));
							ps.setString(2, (String) devUpMap.get("using_stat"));
							ps.setString(3, (String) devUpMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}
		// 7.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 单项目设备转移显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMoveAppInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectInfoNo = msg.getValue("projectinfono");
		String devMovName = msg.getValue("devmovname");
		String inProjectName = msg.getValue("inprojectname");
		String outProjectName = msg.getValue("outprojectname");
		String devCollFlag = msg.getValue("devcollflag");

		StringBuffer querySql = new StringBuffer();
			querySql.append( "select tmp.*,case when length(tmp.out_project_name) > 16 then substr(tmp.out_project_name, 0, 16) || '...' else tmp.out_project_name"
							+ " end as short_out_pro_name,case when length(tmp.in_project_name) > 16 then substr(tmp.in_project_name, 0, 16) || '...'"
							+ " else tmp.in_project_name end as short_in_pro_name,case when length(tmp.dev_mov_name) > 16 then"
							+ " substr(tmp.dev_mov_name, 0, 16) || '...' else tmp.dev_mov_name end as short_dev_mov_name"
							+ " from (select wfmiddle.proc_status,t.dev_mov_id,t.dev_mov_no,t.dev_mov_name,outgp.project_name as out_project_name,"
							+ " ingp.project_name as in_project_name,u.employee_name as opertor,t.apply_date,'转出' as mov_state,"
							+ " case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc"
							+ " from gms_device_move t"
							+ " left join gp_task_project outgp on t.out_project_info_id=outgp.project_info_no"
							+ " left join gp_task_project ingp on t.in_project_info_id=ingp.project_info_no"
							+ " left join comm_human_employee u on t.opertor_id = u.employee_id"
							+ " left join common_busi_wf_middle wfmiddle on t.dev_mov_id=wfmiddle.business_id and wfmiddle.bsflag ='0'"
							+ " where t.out_project_info_id='"+projectInfoNo+"' and t.dev_type = '"+devCollFlag+"' and t.bsflag = '0'"
							+ " union all"
							+ " select wfmiddle.proc_status,t.dev_mov_id,t.dev_mov_no,t.dev_mov_name,outgp.project_name as out_project_name,"
							+ " ingp.project_name as in_project_name,u.employee_name as opertor,t.apply_date,'转入' as mov_state,"
							+ " '审批通过' as state_desc from gms_device_move t"
							+ " left join gp_task_project outgp on t.out_project_info_id=outgp.project_info_no"
							+ " left join gp_task_project ingp on t.in_project_info_id=ingp.project_info_no"
							+ " left join comm_human_employee u on t.opertor_id = u.employee_id"
							+ " left join common_busi_wf_middle wfmiddle on t.dev_mov_id=wfmiddle.business_id and wfmiddle.bsflag ='0'"
							+ " where t.in_project_info_id = '"+projectInfoNo+"' and t.dev_type = '"+devCollFlag+"' and t.bsflag = '0'"
							+ " and wfmiddle.proc_status = '3' ) tmp where 1=1 ");
		//申请名称
		if (StringUtils.isNotBlank(devMovName)) {
			querySql.append(" and dev_mov_name like '%"+devMovName+"%'");
		}
		//转入项目名称
		if (StringUtils.isNotBlank(inProjectName)) {
			querySql.append(" and in_project_name like '%"+inProjectName+"%'");
		}
		//转出项目名称
		if (StringUtils.isNotBlank(outProjectName)) {
			querySql.append(" and out_project_name like '%"+outProjectName+"%'");
		}
		querySql.append(" order by proc_status nulls first,apply_date desc ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 多项目设备转移显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMultiMoveAppInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectInfoNo = msg.getValue("projectinfono");
		String devMovName = msg.getValue("devmovname");
		String inProjectName = msg.getValue("inprojectname");
		String outProjectName = msg.getValue("outprojectname");
		String moveStatus = msg.getValue("movestatus");
		String devCollFlag = msg.getValue("devcollflag");

		StringBuffer querySql = new StringBuffer();
			querySql.append( "select t.dev_mov_id,t.dev_mov_no,t.dev_mov_name,outgp.project_name as out_project_name,"
							+ " ingp.project_name as in_project_name,u.employee_name as opertor,t.apply_date,"
							+ " case t.move_status when '0' then '待转移' when '1' then '已转移' else '待转移' end as move_status_desc,"
							+ " t.in_project_info_id,t.out_project_info_id,"
							+ " case when length(t.dev_mov_name) > 16 then substr(t.dev_mov_name, 0, 16) || '...' else t.dev_mov_name"
							+ " end as short_dev_mov_name,case when length(outgp.project_name) > 16 then substr(outgp.project_name, 0, 16) || '...'"
							+ " else outgp.project_name end as out_short_pro_name,case when length(ingp.project_name) > 16 then"
							+ " substr(ingp.project_name, 0, 16) || '...' else ingp.project_name end as in_short_pro_name"
							+ " from gms_device_move t"
							+ " left join gp_task_project outgp on t.out_project_info_id=outgp.project_info_no"
							+ " left join gp_task_project ingp on t.in_project_info_id=ingp.project_info_no"
							+ " left join comm_human_employee u on t.opertor_id = u.employee_id"
							+ " where t.bsflag='0' and t.dev_type = '"+devCollFlag+"'"
							+ " and t.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%' ");
		//申请名称
		if (StringUtils.isNotBlank(devMovName)) {
			querySql.append(" and t.dev_mov_name like '%"+devMovName+"%'");
		}
		//转入项目名称
		if (StringUtils.isNotBlank(inProjectName)) {
			querySql.append(" and ingp.project_name like '%"+inProjectName+"%'");
		}
		//转出项目名称
		if (StringUtils.isNotBlank(outProjectName)) {
			querySql.append(" and outgp.project_name like '%"+outProjectName+"%'");
		}
		//转出状态
		if (StringUtils.isNotBlank(moveStatus)) {
			querySql.append(" and t.move_status = '"+moveStatus+"'");
		}
		querySql.append(" order by t.move_status nulls first,apply_date desc ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 单项目设备转移主要信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMovMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMovId = msg.getValue("devmovid");
		StringBuffer sb = new StringBuffer()
			.append( "select mov.dev_mov_id,mov.dev_mov_name,mov.dev_mov_no,mov.out_project_info_id,"
					  + " mov.in_project_info_id,mov.opertor_id,mov.apply_date,inpro.project_name as inproname,"
					  + " outpro.project_name as outproname,emp.employee_name,outpro.bsflag as outbsflag,"
					  + " inpro.bsflag as inbsflag from gms_device_move mov"
					  + " left join gp_task_project inpro on mov.in_project_info_id = inpro.project_info_no"
					  + " left join gp_task_project outpro on mov.out_project_info_id = outpro.project_info_no"
					  + " left join comm_human_employee emp on mov.opertor_id = emp.employee_id and emp.bsflag = '0'"
				      + " where mov.dev_mov_id = '"+devMovId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 保存单台设备转移单明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWtcMoveAppDetInfo(ISrvMsg msg) throws Exception {
		String devMovId = wtcDevSrv.saveMovDevApp(msg,"DT");
		UserToken user = msg.getUserToken();
		// 转入转出项目ID
		String inProjectInfoNo = msg.getValue("inProjectInfoNo");
		String projectType = msg.getValue("projecttype");
		String multiFlag = msg.getValue("multiflag");// 多项目和单项目转移区分：Y为多项目设备转移
		String outProBsFlag = msg.getValue("outProBsFlag");//转出项目是否为虚拟项目 2：虚拟项目
		System.out.println("outProBsFlag == "+outProBsFlag);
		String fatherFlag = "";
		String proYear = "";
		String proStartDate = "";
		String proEndDate = "";
		String transferType = "";
		String inOrgId = "";
		String usageSubOrgId = "";
		if (DevUtil.isValueNotNull(multiFlag,"Y")) {
			transferType = "1";
		}else{
			transferType = "0";
		}
		if (DevUtil.isValueNotNull(projectType,DevConstants.DEV_PROTYPE_JZ)) {
			// 判断井中转移项目是年度项目还是子项目
			String proSql = "select t.project_year,t.project_father_no from gp_task_project t where t.project_info_no='"
						  + inProjectInfoNo + "'";
			Map proMap = jdbcDao.queryRecordBySQL(proSql);
			if (proMap != null) {
				if (proMap.get("project_father_no").toString() != null
						&& !"".equals(proMap.get("project_father_no")
								.toString())) {
					fatherFlag = "0";// 子项目
				} else {
					fatherFlag = "1";// 年度项目
				}
			}
		}
		// 查询转入项目的计划开始时间和结束时间作为转移设备的计划开始时间和结束时间
		String proSql = "";
		if (DevUtil.isValueNotNull(projectType,DevConstants.DEV_PROTYPE_JZ)) {
			if ("1".equals(fatherFlag)) {// 年度项目
				proSql = "select t.project_year||'-1-1' as acquire_start_time,t.project_year||'-12-31' as acquire_end_time,"
					   + " dy.org_id,dy.org_subjection_id from gp_task_project t"
					   + " left join gp_task_project_dynamic dy on t.project_info_no = dy.project_info_no"
					   + " where t.project_info_no='"+ inProjectInfoNo + "'";
			} else {
				proSql = "select t.start_time as acquire_start_time,t.end_time as acquire_end_time,"
					   + " dy.org_id,dy.org_subjection_id from gp_task_project t"
				       + " left join gp_task_project_dynamic dy on t.project_info_no = dy.project_info_no"
				       + " where t.project_info_no='"+inProjectInfoNo+"'";
			}
		} else {
			proSql = "select t.acquire_start_time,t.acquire_end_time,dy.org_id,"
				   + " dy.org_subjection_id from gp_task_project t"
				   + " left join gp_task_project_dynamic dy on t.project_info_no = dy.project_info_no"
				   + " where t.project_info_no='"+inProjectInfoNo+"'";
		}
		Map projectMap = jdbcDao.queryRecordBySQL(proSql);
		if(MapUtils.isNotEmpty(projectMap)){
			proStartDate = projectMap.get("acquire_start_time").toString();
			proEndDate = projectMap.get("acquire_end_time").toString();
			inOrgId = projectMap.get("org_id").toString();
			usageSubOrgId = projectMap.get("org_subjection_id").toString();
		}
		
		jdbcDao.executeUpdate("update gms_device_account_dui dui set dui.transfer_state = '',transfer_type = ''"
							  + " where dui.bsflag = '0' and dui.dev_acc_id in"
							  + " ( select det.dev_acc_id from gms_device_move_detail det where det.dev_mov_id='"
							  + devMovId + "' ) ");			
		// 删除子表
		jdbcDao.executeUpdate("delete from gms_device_move_detail t where t.dev_mov_id='"
					+ devMovId + "'");
		
		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		String[] lineInfos = msg.getValue("lineinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_mov_id", devMovId);
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("actual_out_time", msg.getValue("enddate" + lineInfos[index]));
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			dataMap.put("create_date", DevUtil.getCurrentTime());
			dataMap.put("creator_id", user.getEmpId());
			dataMap.put("modifi_date", DevUtil.getCurrentTime());
			dataMap.put("updator_id", user.getEmpId());
			dataMap.put("org_id", user.getOrgId());
			dataMap.put("org_subjection_id", user.getOrgSubjectionId());
			dataMap.put("mov_num", "1");			
			dataMap.put("dev_name", msg.getValue("dev_name" + lineInfos[index]));
			dataMap.put("dev_model", msg.getValue("dev_model" + lineInfos[index]));
			dataMap.put("dev_sign", msg.getValue("dev_sign" + lineInfos[index]));
			dataMap.put("dev_type", msg.getValue("dev_type" + lineInfos[index]));
			dataMap.put("dev_unit", msg.getValue("dev_unit" + lineInfos[index]));
			dataMap.put("tech_stat", DevConstants.DEV_TECH_WANHAO);
			dataMap.put("using_stat", DevConstants.DEV_USING_ZAIYONG);
			dataMap.put("owning_org_id", msg.getValue("owning_org_id" + lineInfos[index]));
			dataMap.put("owning_sub_id", msg.getValue("owning_sub_id" + lineInfos[index]));
			dataMap.put("usage_org_id", inOrgId);
			dataMap.put("usage_sub_id", usageSubOrgId);
			dataMap.put("account_stat", msg.getValue("account_stat" + lineInfos[index]));
			dataMap.put("license_num", msg.getValue("license_num" + lineInfos[index]));
			dataMap.put("planning_in_time", proStartDate);
			dataMap.put("planning_out_time", proEndDate);
			dataMap.put("actual_in_time", msg.getValue("startdate" + lineInfos[index]));
			dataMap.put("project_info_id", inProjectInfoNo);
			dataMap.put("out_org_id", msg.getValue("out_org_id" + lineInfos[index]));
			dataMap.put("in_org_id", inOrgId);
			dataMap.put("is_leaving", DevConstants.BSFLAG_NORMAL);
			dataMap.put("dev_team", msg.getValue("dev_team" + lineInfos[index]));
			dataMap.put("fk_dev_acc_id", msg.getValue("fk_dev_acc_id" + lineInfos[index]));
			dataMap.put("mix_type_id", msg.getValue("mix_type_id" + lineInfos[index]));
			dataMap.put("transfer_type", transferType);
			dataMap.put("fk_device_appmix_id", devMovId);
			dataMap.put("dev_coding", msg.getValue("dev_coding" + lineInfos[index]));
			dataMap.put("self_num", msg.getValue("self_num" + lineInfos[index]));
			datasList.add(dataMap);
		}
		String insOsDetSql = "insert into gms_device_move_detail("
							+ " dev_mov_det_id,"
							+ " dev_mov_id,"
							+ " dev_acc_id,"
							+ " bsflag,"
							+ " create_date,"
							+ " creator_id,"
							+ " modifi_date,"
							+ " updator_id,"
							+ " org_id,"
							+ " org_subjection_id,"
							+ " actual_out_time,"
							+ " mov_num"
							+ " )values(?,?,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,"
							+ " to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?)";
		
		jdbcDao.getJdbcTemplate().batchUpdate(insOsDetSql,
			new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					Map<String, Object> devSaveMap = datasList.get(i);
					ps.setString(1, jdbcDao.generateUUID());
					ps.setString(2, (String) devSaveMap.get("dev_mov_id"));
					ps.setString(3, (String) devSaveMap.get("dev_acc_id"));
					ps.setString(4, (String) devSaveMap.get("bsflag"));
					ps.setString(5, (String) devSaveMap.get("create_date"));
					ps.setString(6, (String) devSaveMap.get("creator_id"));
					ps.setString(7, (String) devSaveMap.get("modifi_date"));
					ps.setString(8, (String) devSaveMap.get("updator_id"));
					ps.setString(9, (String) devSaveMap.get("org_id"));
					ps.setString(10, (String) devSaveMap.get("org_subjection_id"));
					ps.setString(11, (String) devSaveMap.get("actual_out_time"));
					ps.setInt(12, Integer.parseInt((String) devSaveMap.get("mov_num")));
				}
				@Override
				public int getBatchSize() {
					return datasList.size();
				}
			});
		// 生成新的项目的设备台帐，状态为N不显示，当审批通过之后修改为0显示
		jdbcDao.executeUpdate("delete from gms_device_account_dui t where t.fk_device_appmix_id='"
				+ devMovId + "'");
		
		//更新队级台账设备转移状态
		String upDevSaveSql = "update gms_device_account_dui set "
							+ " transfer_state = '2',transfer_type = '"+transferType+"'"
							+ " where dev_acc_id = ? ";
		jdbcDao.getJdbcTemplate().batchUpdate(upDevSaveSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devUpMap = datasList.get(i);
						ps.setString(1, (String) devUpMap.get("dev_acc_id"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		//虚拟项目转移不生成新的台账，直接使用原虚拟项目台账
		if (!DevUtil.isValueNotNull(outProBsFlag,DevConstants.PROJECT_XN)){
			//插入队级台账
			String insDuiSql = "insert into gms_device_account_dui(dev_acc_id,dev_name,dev_model,dev_sign,"
							 + " dev_type,dev_unit,tech_stat,using_stat,owning_org_id,owning_sub_id,"
							 + " usage_org_id,usage_sub_id,account_stat,license_num,bsflag,creator,"
							 + " create_date,modifier,modifi_date,planning_in_time,planning_out_time,actual_in_time,"
							 + " project_info_id,out_org_id,in_org_id,is_leaving,fk_device_appmix_id,dev_team,mix_type_id,"
							 + " transfer_type,dev_coding,self_num,fk_dev_acc_id)"
							 + " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,'N',?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,"
							 + " to_date(?,'yyyy-mm-dd hh24:mi:ss'),to_date(?,'yyyy-mm-dd'),"
							 + " to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?,?,'0',?,?,?,?,?,?,?)";
		
			jdbcDao.getJdbcTemplate().batchUpdate(insDuiSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) devSaveMap.get("dev_name"));
						ps.setString(3, (String) devSaveMap.get("dev_model"));
						ps.setString(4, (String) devSaveMap.get("dev_sign"));
						ps.setString(5, (String) devSaveMap.get("dev_type"));
						ps.setString(6, (String) devSaveMap.get("dev_unit"));
						ps.setString(7, (String) devSaveMap.get("tech_stat"));
						ps.setString(8, (String) devSaveMap.get("using_stat"));
						ps.setString(9, (String) devSaveMap.get("owning_org_id"));
						ps.setString(10, (String) devSaveMap.get("owning_sub_id"));
						ps.setString(11, (String) devSaveMap.get("usage_org_id"));
						ps.setString(12, (String) devSaveMap.get("usage_sub_id"));
						ps.setString(13, (String) devSaveMap.get("account_stat"));
						ps.setString(14, (String) devSaveMap.get("license_num"));
						ps.setString(15, (String) devSaveMap.get("creator_id"));
						ps.setString(16, (String) devSaveMap.get("create_date"));
						ps.setString(17, (String) devSaveMap.get("updator_id"));
						ps.setString(18, (String) devSaveMap.get("modifi_date"));
						ps.setString(19, (String) devSaveMap.get("planning_in_time"));
						ps.setString(20, (String) devSaveMap.get("planning_out_time"));
						ps.setString(21, (String) devSaveMap.get("actual_out_time"));
						ps.setString(22, (String) devSaveMap.get("project_info_id"));
						ps.setString(23, (String) devSaveMap.get("out_org_id"));
						ps.setString(24, (String) devSaveMap.get("in_org_id"));
						ps.setString(25, (String) devSaveMap.get("fk_device_appmix_id"));
						ps.setString(26, (String) devSaveMap.get("dev_team"));
						ps.setString(27, (String) devSaveMap.get("mix_type_id"));
						ps.setString(28, (String) devSaveMap.get("transfer_type"));
						ps.setString(29, (String) devSaveMap.get("dev_coding"));
						ps.setString(30, (String) devSaveMap.get("self_num"));
						ps.setString(31, (String) devSaveMap.get("fk_dev_acc_id"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		}
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	/**
	 * NEWMETHOD 删除、修改、提交转移设备单据状态判断
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opMovDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String delFlag = "0";
		String movState = "";
		String devMovId = msg.getValue("devmovid");
		String opFlag = msg.getValue("opflag");
		String movType = msg.getValue("movtype");
		String projectInfoNo = "";
		try{
			String appSql = "select nvl(wfmiddle.proc_status,'') as proc_status"
							+ " from gms_device_move devapp"
							+ " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.dev_mov_id"
							+ " where devapp.dev_mov_id ='"+devMovId+"'";
			Map movMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(movMap)){
				movState = movMap.get("proc_status").toString();
				if("1".equals(movState) || "3".equals(movState)){
					delFlag = "1";//已提交的单据不能删除/修改/提交
				}else{
					if("tj".equals(opFlag)){
						if(DevUtil.isValueNotNull(movType) && "dev".equals(movType)){
							String tjSql = "update gms_device_account_dui dui set"
								          + " dui.actual_out_time=(select t.actual_out_time"
								          + " from gms_device_move_detail t"
								          + " where t.dev_mov_id = '"+devMovId+"'"
								          + " and t.dev_acc_id=dui.dev_acc_id)"
										  + " where exists(select 1 from gms_device_move_detail t"
										  + " where t.dev_acc_id=dui.dev_acc_id"
										  + " and t.dev_mov_id = '"+devMovId+"' )";
							jdbcDao.executeUpdate(tjSql);
						}
					}else if("del".equals(opFlag)){
						String delSql = "update gms_device_move"
									  + " set bsflag = '1',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where dev_mov_id = '"+devMovId+"'";
						jdbcDao.executeUpdate(delSql);
						
						if(DevUtil.isValueNotNull(movType) && "dev".equals(movType)){
							String upDuiSql = "update gms_device_account_dui set transfer_state='',transfer_type=''"
											+ " where dev_acc_id in"
										  	+ " (select dev_acc_id from gms_device_move_detail"
										  	+ " where dev_mov_id='"+devMovId+"' and bsflag='0')";
							jdbcDao.executeUpdate(upDuiSql);
							
							String delDuiSql = "delete from gms_device_account_dui"
								             + " where fk_device_appmix_id = '"+devMovId+"' and bsflag = 'N'";
							jdbcDao.executeUpdate(delDuiSql);
						}
					}
				}
			}else{
				delFlag = "3";//删除/提交/修改失败
			}
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除/提交/修改失败
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 删除、修改、提交多项目转移设备单据状态判断
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opMultiMovDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String delFlag = "0";
		String movState = "";
		String devMovId = msg.getValue("devmovid");
		String opFlag = msg.getValue("opflag");
		String movType = msg.getValue("movtype");
		String empId = msg.getValue("empid");
		String outProBsFlag = msg.getValue("outprobsflag");
		String inProOrgId = msg.getValue("inproorgid");
		String inProSubId = msg.getValue("inprosubid");
		String inProjectNo = "";
		String outProjectNo = "";
		
		try{
			String appSql = "select in_project_info_id,out_project_info_id,move_status"
						  + " from gms_device_move where dev_mov_id ='"+devMovId+"'";
			Map movMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(movMap)){
				movState = movMap.get("move_status").toString();
				inProjectNo = movMap.get("in_project_info_id").toString();
				outProjectNo = movMap.get("out_project_info_id").toString();
				if("1".equals(movState)){
					delFlag = "1";//已转移的单据不能删除/修改/提交
				}else{
					if("tj".equals(opFlag)){
						String sucFlag = "";
						if(DevUtil.isValueNotNull(movType,"wdev")){
							if(DevUtil.isValueNotNull(outProBsFlag,DevConstants.PROJECT_XN)){//虚拟项目转移
								sucFlag = this.saveVirProMoveDevDet(msg,devMovId,inProjectNo,outProjectNo,empId,inProOrgId,inProSubId);
							}else{
								sucFlag = this.saveInsMoveDevDet(msg,devMovId,inProjectNo,outProjectNo,empId);
							}			
							if("fail".equals(sucFlag)){
								delFlag = "3";//删除/提交/修改失败
							}
						}else if(DevUtil.isValueNotNull(movType,"wcoll")){
							if(DevUtil.isValueNotNull(outProBsFlag,DevConstants.PROJECT_XN)){//虚拟项目转移
								sucFlag = this.saveVirProMoveCollDevDet(devMovId,inProjectNo,outProjectNo,empId,inProOrgId,inProSubId);
							}else{
								sucFlag = this.saveInsMoveCollDevDet(devMovId,inProjectNo,outProjectNo,empId);
							}
							if("fail".equals(sucFlag)){
								delFlag = "3";//删除/提交/修改失败
							}
						}else{
							delFlag = "3";//删除/提交/修改失败
						}
					}else if("del".equals(opFlag)){
						String delSql = "update gms_device_move"
									  + " set bsflag = '1',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where dev_mov_id = '"+devMovId+"'";
						jdbcDao.executeUpdate(delSql);
						
						if(DevUtil.isValueNotNull(movType,"wdev")){
							String upDuiSql = "update gms_device_account_dui set transfer_state='',transfer_type=''"
											+ " where dev_acc_id in"
										  	+ " (select dev_acc_id from gms_device_move_detail"
										  	+ " where dev_mov_id='"+devMovId+"' and bsflag='0')";
							jdbcDao.executeUpdate(upDuiSql);
							
							//非虚拟项目删除生成的队级设备台账
							if(!DevUtil.isValueNotNull(outProBsFlag,DevConstants.PROJECT_XN)){
								String delDuiSql = "delete from gms_device_account_dui"
									             + " where fk_device_appmix_id = '"+devMovId+"'"
									             + " and bsflag = '"+DevConstants.BSFLAG_INTERMEDIATE+"'";
								jdbcDao.executeUpdate(delDuiSql);
							}
						}
					}
				}
			}else{
				delFlag = "3";//删除/提交/修改失败
			}
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除/提交/修改失败
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 多项目单台设备转移提交操作数据
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	private String saveInsMoveDevDet(ISrvMsg msg,String devMovId,String inProjectNo,
												String outProjectNo,String empId) throws Exception{
			String succFlag = "success";
			String tjSql = "update gms_device_account_dui dui set"
				         + " dui.actual_out_time=(select t.actual_out_time"
				         + " from gms_device_move_detail t"
				         + " where t.dev_mov_id = '"+devMovId+"'"
				         + " and t.dev_acc_id=dui.dev_acc_id)"
						 + " where exists(select 1 from gms_device_move_detail t"
						 + " where t.dev_acc_id=dui.dev_acc_id"
						 + " and t.dev_mov_id = '"+devMovId+"' )";
			jdbcDao.executeUpdate(tjSql);
			
			// 更新转入台帐状态
			jdbcDao.executeUpdate("update gms_device_account_dui set bsflag = '0',transfer_state = '0'"
					              + " where fk_device_appmix_id = '"+devMovId+"'");
			// 更新设备转移主表转移状态为：已转移
			jdbcDao.executeUpdate("update gms_device_move set move_status = '1'"
					              + " where dev_mov_id = '"+devMovId+"'");
			// 更新转出台帐离队状态
			jdbcDao.executeUpdate("update gms_device_account_dui dui set dui.is_leaving='1',dui.transfer_state='1',"
								 + " dui.check_time=(select t.actual_out_time from gms_device_move_detail t"
								 + " where t.dev_acc_id = dui.dev_acc_id and t.dev_mov_id = '"+devMovId+"')"
								 + " where exists(select 1 from gms_device_move_detail t where t.dev_acc_id=dui.dev_acc_id"
								 + " and t.dev_mov_id = '"+devMovId+"')");
			// 更新物探处台帐使用项目id
			jdbcDao.executeUpdate("update gms_device_account t set t.project_info_no='"+inProjectNo+"',"
								 + " t.check_time=(select actual_out_time from (select d.actual_out_time,"
								 + " dui.fk_dev_acc_id from gms_device_move_detail d"
								 + " left join gms_device_account_dui dui on d.dev_acc_id = dui.dev_acc_id"
								 + " where d.dev_mov_id='"+devMovId+"') aa where t.dev_acc_id = aa.fk_dev_acc_id)"
								 + " where exists( select 1 from (select dui.fk_dev_acc_id from gms_device_move_detail d"
								 + " left join gms_device_account_dui dui on d.dev_acc_id = dui.dev_acc_id"
								 + " where d.dev_mov_id='"+devMovId+"')aa where t.dev_acc_id=aa.fk_dev_acc_id)");
			//查询出要转移的设备
			String idInfos = "";
			String querySql = "select dev_acc_id from gms_device_move_detail where dev_mov_id = '"+devMovId+"'";
			List queryist = jdbcDao.queryRecords(querySql);
			for (int i = 0; i < queryist.size(); i++) {
				Map queryMap = (Map) queryist.get(i);
				if(i==0){
					idInfos = queryMap.get("dev_acc_id").toString();
				}else{
					idInfos = idInfos+"~"+queryMap.get("dev_acc_id").toString();
				}								
			}
			
			msg.setValue("outProjectInfoNo", outProjectNo);
			msg.setValue("inProjectInfoNo", inProjectNo);
			msg.setValue("employeeId", empId);
			msg.setValue("idinfos", idInfos);
								
			String arcFlag = wtcDevSrv.saveDevArchive(msg);
			if(DevUtil.isValueNotNull(arcFlag)){
				succFlag = "fail";
				log.info("设备转移插入档案报错!!! 错误码："+arcFlag+" 转移主键ID："+devMovId);
				SimpleMailSender.sendTextMail("多项目设备单台转移审批", "设备转移插入档案报错：错误码：arcFlag = "+arcFlag+" || 转移主键ID：devMovId = "+devMovId);
			}
		return succFlag;		
	}
	/**
	 * NEWMETHOD 多项目单台设备转移虚拟项目转正式项目提交操作数据
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRES_NEW)
	private String saveVirProMoveDevDet(ISrvMsg msg,String devMovId,String inProjectNo,
												String outProjectNo,String empId,String inProOrgId,String inProSubId) throws Exception{
		String succFlag = "success";
		//手工启动事务(经测试没有起作用)
		DataSourceTransactionManager transactionManager = (DataSourceTransactionManager) BeanFactory
																.getBean("jdbcTransactionManager");
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW); // 事物隔离级别，开启新事务
		TransactionStatus status = transactionManager.getTransaction(def); // 获得事务状态
		try {
			// 更新转出台帐离队状态
			jdbcDao.executeUpdate("update gms_device_account_dui dui set dui.project_info_id='"+inProjectNo+"',"
								 + " dui.transfer_state='',dui.usage_org_id='"+inProOrgId+"',dui.usage_sub_id='"+inProSubId+"',"
								 + " in_org_id='"+inProOrgId+"',dui.actual_in_time=(select t.actual_out_time"
								 + " from gms_device_move_detail t where t.dev_acc_id = dui.dev_acc_id"
								 + " and t.dev_mov_id = '"+devMovId+"')"
								 + " where exists(select 1 from gms_device_move_detail t"
								 + " where t.dev_acc_id=dui.dev_acc_id and t.dev_mov_id = '"+devMovId+"')");
			// 更新物探处台帐使用项目id
			jdbcDao.executeUpdate("update gms_device_account t set t.project_info_no='"+inProjectNo+"',"
								 + " t.usage_org_id='"+inProOrgId+"',t.usage_sub_id='"+inProSubId+"',"
								 + " t.check_time=(select actual_out_time from (select d.actual_out_time,"
								 + " dui.fk_dev_acc_id from gms_device_move_detail d"
								 + " left join gms_device_account_dui dui on d.dev_acc_id = dui.dev_acc_id"
								 + " where d.dev_mov_id='"+devMovId+"') aa where t.dev_acc_id = aa.fk_dev_acc_id)"
								 + " where exists( select 1 from (select dui.fk_dev_acc_id from gms_device_move_detail d"
								 + " left join gms_device_account_dui dui on d.dev_acc_id = dui.dev_acc_id"
								 + " where d.dev_mov_id='"+devMovId+"')aa where t.dev_acc_id=aa.fk_dev_acc_id)");
			//查询出要转移的设备
			String idInfos = "";
			String querySql = "select dev_acc_id from gms_device_move_detail where dev_mov_id = '"+devMovId+"'";
			List queryist = jdbcDao.queryRecords(querySql);
			for (int i = 0; i < queryist.size(); i++) {
				Map queryMap = (Map) queryist.get(i);
				if(i==0){
					idInfos = queryMap.get("dev_acc_id").toString();
				}else{
					idInfos = idInfos+"~"+queryMap.get("dev_acc_id").toString();
				}								
			}
			msg.setValue("outProjectInfoNo", outProjectNo);
			msg.setValue("inProjectInfoNo", inProjectNo);
			msg.setValue("idinfos", idInfos);

			String arcFlag = wtcDevSrv.saveVirProDevArchive(msg);
			if(DevUtil.isValueNotNull(arcFlag)){
				succFlag = "fail";
				log.info("虚拟项目转正式项目修改设备档案报错!!! 错误码："+arcFlag+" 转移主键ID："+devMovId);
				SimpleMailSender.sendTextMail("虚拟项目转正式项目修改设备档案报错", "修改设备档案项目编号报错：错误码：arcFlag = "+arcFlag+" || 转移主键ID：devMovId = "+devMovId);
			}
			
			boolean opFlag = wtcDevSrv.opVirProDev(outProjectNo);
			if(!opFlag){
				succFlag = "fail";
				log.info("转移完成逻辑删除虚拟项目报错!!! 转移主键ID："+devMovId);
				SimpleMailSender.sendTextMail("转移完成逻辑删除虚拟项目报错", "转移完成逻辑删除虚拟项目报错!!! 转移主键ID：devMovId = "+devMovId);
			}
			if("success".equals(succFlag)){
				// 更新设备转移主表转移状态为：已转移
				jdbcDao.executeUpdate("update gms_device_move set move_status = '1'"
								  	  + " where dev_mov_id = '"+devMovId+"'");
			}
			transactionManager.commit(status);
		} catch (Exception e) {
			succFlag = "fail";
			transactionManager.rollback(status);
			throw new RuntimeException("运行时出错！");
			//TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return succFlag;
	}
	/**
	 * NEWMETHOD 多项目批量设备转移提交操作数据
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	private String saveInsMoveCollDevDet(String devMovId,String inProjectNo,
												String outProjectNo,String empId) throws Exception{
			String succFlag = "success";
			// 查询转入项目的计划开始时间和结束时间作为转移设备的计划开始时间和结束时间及转入项目的队伍
			String proSql = "select t.acquire_start_time,t.acquire_end_time,dy.org_id from gp_task_project t"
						  + " left join gp_task_project_dynamic dy on t.project_info_no = dy.project_info_no"
						  + " where t.project_info_no='"+inProjectNo+"'";
			Map proMap = jdbcDao.queryRecordBySQL(proSql);
			String startDate = "";
			String endDate = "";
			String duiOrg = "";
			if(MapUtils.isNotEmpty(proMap)){
				startDate = proMap.get("acquire_start_time").toString();
				endDate = proMap.get("acquire_start_time").toString();
				duiOrg = proMap.get("org_id").toString();				
			}
			// 查询转移设备相关信息
			String querySql = "select t.dev_acc_id,t.actual_out_time,dui.fk_dev_acc_id,dui.out_org_id,"
							+ " nvl(t.mov_num,0) as mov_num,nvl(dui.unuse_num,0) as unuse_num,"
							+ " nvl(dui.use_num,0) as use_num,nvl(dui.total_num,0) as total_num,"
							+ " dui.dev_name,dui.dev_model,dui.device_id,dui.dev_unit,dui.dev_team"
				            + " from gms_device_move_detail t"
				            + " left join gms_device_coll_account_dui dui on t.dev_acc_id = dui.dev_acc_id"
				            + " where t.dev_mov_id = '"+devMovId+"'";
			List queryList = jdbcDao.queryRecords(querySql);
			// 更新转出台帐数据
			for (int i = 0; i < queryList.size(); i++) {
				// 1.操作原台帐数据
				Map queryMap = (Map) queryList.get(i);
				int movNum = Integer.parseInt((String)queryMap.get("mov_num"));// 转移数量
				int useNum = Integer.parseInt((String)queryMap.get("use_num"));// 离队数量
				int unuseNum = Integer.parseInt((String)queryMap.get("unuse_num"));// 在队数量
				
				Map<String, Object> mainMap = new HashMap<String, Object>();
				mainMap.put("dev_acc_id", queryMap.get("dev_acc_id"));
				mainMap.put("use_num", useNum + movNum);
				mainMap.put("unuse_num", unuseNum - movNum);
				if((unuseNum - movNum) < 0){
					succFlag = "fail";
					log.info("批量转移设备出现负数：devMovId = "+devMovId+" movNum = "+movNum+"  unuseNum = "+unuseNum);
					SimpleMailSender.sendTextMail("多项目批量设备转移", "批量转移设备出现负数：devMovId = "+devMovId+" || movNum = "+movNum+" || unuseNum = "+unuseNum);
					break;
				}
				if (unuseNum - movNum == 0) {
					mainMap.put("is_leaving", DevConstants.DEVLEAVING_YES);
					mainMap.put("actual_out_time", queryMap.get("actual_out_time"));
				}
				mainMap.put("modifi_date", DevUtil.getCurrentTime());
				mainMap.put("modifier", empId);
				jdbcDao.saveOrUpdateEntity(mainMap,"gms_device_coll_account_dui");
				// 3.插入队级台账动态表
				Map<String, Object> duiDymMap = new HashMap<String, Object>();
				duiDymMap.put("opr_type", DevConstants.DYM_OPRTYPE_IN);
				duiDymMap.put("dev_acc_id", queryMap.get("dev_acc_id"));
				duiDymMap.put("receive_num", queryMap.get("mov_num"));
				duiDymMap.put("actual_out_time",queryMap.get("actual_out_time"));
				duiDymMap.put("create_date", DevUtil.getCurrentTime());
				duiDymMap.put("creator", empId);
				jdbcDao.saveOrUpdateEntity(duiDymMap,"gms_device_coll_account_dym");

				// 2.操作新台帐数据
				// 查询新台帐是否存在转移的设备
				String newAccSql = "select * from gms_device_coll_account_dui t"
					             + " where t.project_info_id = '"+inProjectNo+"'"
					             + " and t.fk_dev_acc_id = '"+queryMap.get("fk_dev_acc_id")+"' ";
				Map queryNewDatas = jdbcDao.queryRecordBySQL(newAccSql);
				String devAccId = "";
				// 没有执行新增
				if (MapUtils.isEmpty(queryNewDatas)) {
					Map<String, Object> duiMap = new HashMap<String, Object>();
					duiMap.put("dev_name", queryMap.get("dev_name"));
					duiMap.put("dev_model", queryMap.get("dev_model"));
					duiMap.put("device_id", queryMap.get("device_id"));
					duiMap.put("dev_unit", queryMap.get("dev_unit"));
					duiMap.put("total_num", movNum);
					duiMap.put("unuse_num", movNum);
					duiMap.put("use_num", 0);
					duiMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
					duiMap.put("create_date", DevUtil.getCurrentTime());
					duiMap.put("creator", empId);
					duiMap.put("modifi_date", DevUtil.getCurrentTime());
					duiMap.put("modifier", empId);
					duiMap.put("planning_in_time",startDate);
					duiMap.put("planning_out_time",endDate);
					duiMap.put("actual_in_time",queryMap.get("actual_out_time"));
					duiMap.put("fk_dev_acc_id",queryMap.get("fk_dev_acc_id"));
					duiMap.put("project_info_id",inProjectNo);
					duiMap.put("out_org_id",queryMap.get("out_org_id"));
					duiMap.put("in_org_id",duiOrg);
					duiMap.put("is_leaving", DevConstants.DEVLEAVING_NO);
					duiMap.put("fk_device_appmix_id", devMovId);
					duiMap.put("dev_team", queryMap.get("dev_team"));
					duiMap.put("account_stat", DevConstants.DEV_ACCOUNT_ZAIZHANG);					
					devAccId = (String) jdbcDao.saveOrUpdateEntity(duiMap,"gms_device_coll_account_dui");
				} else {
					// 否则执行累加
					devAccId = queryNewDatas.get("dev_acc_id").toString();
					int newTotalNum = Integer.parseInt((String)queryNewDatas.get("total_num"));
					int newUnUseNum = Integer.parseInt((String)queryNewDatas.get("unuse_num"));
					queryNewDatas.put("total_num", newTotalNum + movNum);
					queryNewDatas.put("unuse_num", newUnUseNum + movNum);
					queryNewDatas.put("modifi_date", DevUtil.getCurrentTime());
					queryNewDatas.put("modifier", empId);
					queryNewDatas.put("is_leaving", DevConstants.DEVLEAVING_NO);
					jdbcDao.saveOrUpdateEntity(queryNewDatas,"gms_device_coll_account_dui");
				}
				// 队级台账动态表插入
				Map<String, Object> dymMap = new HashMap<String, Object>();
				dymMap.put("dev_acc_id", devAccId);
				dymMap.put("opr_type", "1");
				dymMap.put("receive_num", movNum);
				dymMap.put("actual_in_time", queryMap.get("actual_out_time"));
				dymMap.put("create_date", DevUtil.getCurrentTime());
				dymMap.put("creator", empId);
				jdbcDao.saveOrUpdateEntity(dymMap,"gms_device_coll_account_dym");
			}
			if("success".equals(succFlag)){
				// 更新设备转移主表转移状态为：已转移
				jdbcDao.executeUpdate("update gms_device_move set move_status = '1'"
						              + " where dev_mov_id = '"+devMovId+"'");
			}
		return succFlag;		
	}
	/**
	 * NEWMETHOD 多项目批量设备转移虚拟项目转正式项目提交操作数据
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	private String saveVirProMoveCollDevDet(String devMovId,String inProjectNo,
												String outProjectNo,String empId,String inProOrgId,String inProSubId) throws Exception{
			String succFlag = "success";
			// 查询转移设备相关信息
			String querySql = "select t.dev_acc_id,t.actual_out_time,dui.fk_dev_acc_id,dui.out_org_id,"
							+ " nvl(t.mov_num,0) as mov_num,nvl(dui.unuse_num,0) as unuse_num,"
							+ " nvl(dui.use_num,0) as use_num,nvl(dui.total_num,0) as total_num,"
							+ " dui.dev_name,dui.dev_model,dui.device_id,dui.dev_unit,dui.dev_team"
				            + " from gms_device_move_detail t"
				            + " left join gms_device_coll_account_dui dui on t.dev_acc_id = dui.dev_acc_id"
				            + " where t.dev_mov_id = '"+devMovId+"'";
			List queryList = jdbcDao.queryRecords(querySql);
			// 更新转出台帐数据
			for (int i = 0; i < queryList.size(); i++) {
				// 1.操作原台帐数据
				Map queryMap = (Map) queryList.get(i);
				int movNum = Integer.parseInt((String)queryMap.get("mov_num"));// 转移数量
				int useNum = Integer.parseInt((String)queryMap.get("use_num"));// 离队数量
				int unuseNum = Integer.parseInt((String)queryMap.get("unuse_num"));// 在队数量
				String devAccId = (String)queryMap.get("dev_acc_id");//转移转移台账主键ID
				String actulInTime = (String)queryMap.get("actual_out_time");//进队时间
				
				// 2.插入队级台账动态表
				Map<String, Object> duiDymMap = new HashMap<String, Object>();
				duiDymMap.put("opr_type", DevConstants.DYM_OPRTYPE_IN);
				duiDymMap.put("dev_acc_id", queryMap.get("dev_acc_id"));
				duiDymMap.put("receive_num", queryMap.get("mov_num"));
				duiDymMap.put("actual_out_time",queryMap.get("actual_out_time"));
				duiDymMap.put("create_date", DevUtil.getCurrentTime());
				duiDymMap.put("creator", empId);
				jdbcDao.saveOrUpdateEntity(duiDymMap,"gms_device_coll_account_dym");

				// 3.操作新台帐数据
				// 查询新台帐是否存在转移的设备
				String newAccSql = "select * from gms_device_coll_account_dui t"
					             + " where t.project_info_id = '"+inProjectNo+"'"
					             + " and t.fk_dev_acc_id = '"+queryMap.get("fk_dev_acc_id")+"' ";
				Map queryNewDatas = jdbcDao.queryRecordBySQL(newAccSql);
				// 没有则执行新增
				if (MapUtils.isEmpty(queryNewDatas)) {
					jdbcDao.executeUpdate("update gms_device_coll_account_dui"
										 + " set project_info_id = '"+inProjectNo+"',"
										 + " actual_in_time = to_date('"+actulInTime+"','yyyy-mm-dd hh24:mi:ss'),"
										 + " in_org_id = '"+inProOrgId+"',"
										 + " usage_org_id = '"+inProOrgId+"',"
										 + " usage_sub_id = '"+inProSubId+"'"
							             + " where dev_acc_id = '"+devAccId+"'");
				} else {
					// 否则执行累加
					int newTotalNum = Integer.parseInt((String)queryNewDatas.get("total_num"));
					int newUnUseNum = Integer.parseInt((String)queryNewDatas.get("unuse_num"));
					queryNewDatas.put("total_num", newTotalNum + movNum);
					queryNewDatas.put("unuse_num", newUnUseNum + movNum);
					queryNewDatas.put("modifi_date", DevUtil.getCurrentTime());
					queryNewDatas.put("modifier", empId);
					jdbcDao.saveOrUpdateEntity(queryNewDatas,"gms_device_coll_account_dui");
					//累加成功删除虚拟项目台账记录
					jdbcDao.executeUpdate("delete from gms_device_coll_account_dui"
				              			  + " where dev_acc_id = '"+devAccId+"'");
					
					devAccId = queryNewDatas.get("dev_acc_id").toString();
				}
				// 队级台账动态表插入
				Map<String, Object> dymMap = new HashMap<String, Object>();
				dymMap.put("dev_acc_id", devAccId);
				dymMap.put("opr_type", DevConstants.DYM_OPRTYPE_OUT);
				dymMap.put("receive_num", movNum);
				dymMap.put("actual_in_time", queryMap.get("actual_out_time"));
				dymMap.put("create_date", DevUtil.getCurrentTime());
				dymMap.put("creator", empId);
				jdbcDao.saveOrUpdateEntity(dymMap,"gms_device_coll_account_dym");
			}
			boolean opFlag = wtcDevSrv.opVirProDev(outProjectNo);
			if(!opFlag){
				succFlag = "fail";
				log.info("转移完成逻辑删除虚拟项目报错!!! 转移主键ID："+devMovId);
				SimpleMailSender.sendTextMail("转移完成逻辑删除虚拟项目报错", "转移完成逻辑删除虚拟项目报错!!! 转移主键ID：devMovId = "+devMovId);
			}
			if("success".equals(succFlag)){
				// 更新设备转移主表转移状态为：已转移
				jdbcDao.executeUpdate("update gms_device_move set move_status = '1'"
						              + " where dev_mov_id = '"+devMovId+"'");
			}
		return succFlag;		
	}
	/**
	 * NEWMETHOD 转移设备明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMovDevAppDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMovId = msg.getValue("devmovid");
		String sql = "select det.dev_acc_id,acc.dev_name,acc.dev_model,acc.dev_unit,acc.out_org_id,"
				   + " acc.license_num,acc.dev_coding,acc.self_num,acc.actual_in_time,acc.dev_type,"
				   + " acc.tech_stat,acc.using_stat,acc.owning_org_id,acc.owning_sub_id,acc.dev_team,"
				   + " acc.fk_dev_acc_id,acc.account_stat,acc.out_org_id,acc.mix_type_id,"
				   + " acc.dev_sign,det.actual_out_time from gms_device_move_detail det"
				   + " left join gms_device_account_dui acc on det.dev_acc_id = acc.dev_acc_id"
				   + " where det.dev_mov_id = '"+devMovId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 转移设备明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMovCollAppDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMovId = msg.getValue("devmovid");
		String sql = "select movdet.device_detail_rid,movdet.dev_acc_id,acc.dev_name,acc.dev_model,unit.coding_name as unit_name,"
				   + " nvl(acc.total_num, 0) as total_num,movdet.mov_num,acc.actual_in_time,"
				   + " nvl(nvl(acc.unuse_num, 0)-nvl(back_num,0)-nvl(coll.mov_num, 0),0) as unuse_num,"
				   + " nvl(nvl(acc.use_num, 0)+nvl(back_num,0)+nvl(coll.mov_num, 0),0) as use_num,"
				   + " movdet.actual_out_time from gms_device_move_detail movdet"
				   + " left join gms_device_coll_account_dui acc on movdet.dev_acc_id = acc.dev_acc_id"
				   + " left join (select app.dev_acc_id, nvl(sum(app.back_num), 0) as back_num "
				   + " from gms_device_collbackapp_detail app"
				   + " left join gms_device_collbackapp mix on app.device_backapp_id = mix.device_backapp_id"
				   + " where app.bsflag = '0' and mix.bsflag = '0' and mix.state = '0' and app.dev_acc_id is not null"
				   + " group by app.dev_acc_id) dev on acc.dev_acc_id = dev.dev_acc_id"
				   + " left join (select det.dev_acc_id, nvl(sum(det.mov_num), 0) as mov_num"
				   + " from gms_device_move_detail det"
				   + " left join gms_device_move mov on det.dev_mov_id = mov.dev_mov_id"
				   + " where mov.bsflag = '0' and mov.move_status = '0' and mov.dev_type = 'coll'"
				   + " and det.dev_mov_id != '"+devMovId+"'"
				   + " group by det.dev_acc_id) coll on acc.dev_acc_id = coll.dev_acc_id"
				   + " left join comm_coding_sort_detail unit on acc.dev_unit = unit.coding_code_id"
				   + " where movdet.dev_mov_id = '"+devMovId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 审批保存设备转移信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWtcDevMoveAuditInfowfpa(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String oprstate = msg.getValue("oprstate");
		String endFlag = msg.getValue("endflag");
		String devMovId = msg.getValue("devmovid");
		String inProjectNo = msg.getValue("inProjectInfoNo");		

		if ("pass".equals(oprstate) && "END_NODE".equals(endFlag)) {
			// 更新转入台帐状态
			jdbcDao.executeUpdate("update gms_device_account_dui set bsflag = '0',transfer_state = '0'"
					              + " where fk_device_appmix_id = '"+devMovId+"'");
			// 更新设备转移主表转移状态为：已转移
			jdbcDao.executeUpdate("update gms_device_move set move_status = '1'"
					              + " where dev_mov_id = '"+devMovId+"'");
			// 更新转出台帐离队状态
			jdbcDao.executeUpdate("update gms_device_account_dui dui set dui.is_leaving='1',dui.transfer_state='1',"
								 + " dui.check_time=(select t.actual_out_time from gms_device_move_detail t"
								 + " where t.dev_acc_id = dui.dev_acc_id and t.dev_mov_id = '"+devMovId+"')"
								 + " where exists(select 1 from gms_device_move_detail t where t.dev_acc_id=dui.dev_acc_id"
								 + " and t.dev_mov_id = '"+devMovId+"')");
			// 更新物探处台帐使用项目id
			jdbcDao.executeUpdate("update gms_device_account t set t.project_info_no='"+inProjectNo+"',"
								 + " t.check_time=(select actual_out_time from (select d.actual_out_time,"
								 + " dui.fk_dev_acc_id from gms_device_move_detail d"
								 + " left join gms_device_account_dui dui on d.dev_acc_id = dui.dev_acc_id"
								 + " where d.dev_mov_id='"+devMovId+"') aa where t.dev_acc_id = aa.fk_dev_acc_id)"
								 + " where exists( select 1 from (select dui.fk_dev_acc_id from gms_device_move_detail d"
								 + " left join gms_device_account_dui dui on d.dev_acc_id = dui.dev_acc_id"
								 + " where d.dev_mov_id='"+devMovId+"')aa where t.dev_acc_id=aa.fk_dev_acc_id)");
			String arcFlag = wtcDevSrv.saveDevArchive(msg);
			if(DevUtil.isValueNotNull(arcFlag)){
				log.info("设备转移插入档案报错!!! 错误码："+arcFlag+" 转移主键ID："+devMovId);
				SimpleMailSender.sendTextMail("单项目设备单台转移审批", "设备转移插入档案报错：错误码：arcFlag = "+arcFlag+" || 转移主键ID：devMovId = "+devMovId);
			}
		} else if ("notPass".equals(oprstate)) {
			// 审批不通过将实际离场时间修改为空
			String detsql = "update gms_device_account_dui dui set dui.actual_out_time=''"
						  + " where exists(select 1 from gms_device_move_detail t"
						  + " where t.dev_acc_id=dui.dev_acc_id"
						  + " and t.dev_mov_id = '"+devMovId+"')";
			jdbcDao.executeUpdate(detsql);
		}
		// 7.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 根据设备ID获得批量转移设备相关信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String condition = msg.getValue("condition");
		String proFlag = msg.getValue("proflag");
		String projectNo = msg.getValue("projectno");
		String sql = "select '' as device_detail_rid,acc.dev_acc_id,acc.dev_name,acc.dev_model,nvl(acc.total_num, 0) as total_num,"
			       + " nvl(nvl(acc.unuse_num, 0)-nvl(back_num,0)-nvl(mov_num, 0),0) as unuse_num,"
			       + " nvl(nvl(acc.use_num, 0)+nvl(back_num,0)+nvl(mov_num, 0),0) as use_num,"
			       + " acc.actual_in_time,unitsd.coding_name as unit_name"
				   + " from gms_device_coll_account_dui acc"
				   + " left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id"
				   + " left join (select app.dev_acc_id, nvl(sum(app.back_num), 0) as back_num "
				   + " from gms_device_collbackapp_detail app"
				   + " left join gms_device_collbackapp mix on app.device_backapp_id = mix.device_backapp_id"
				   + " where app.bsflag = '0' and mix.bsflag = '0' and mix.state = '0' and app.dev_acc_id is not null"
				   + " group by app.dev_acc_id) dev on acc.dev_acc_id = dev.dev_acc_id"
				   + " left join (select det.dev_acc_id, nvl(sum(det.mov_num), 0) as mov_num"
				   + " from gms_device_move_detail det"
				   + " left join gms_device_move mov on det.dev_mov_id = mov.dev_mov_id"
				   + " where mov.bsflag = '0' and mov.move_status = '0' and (mov.dev_type = 'coll' or mov.dev_type = 'wcoll')"
				   + " group by det.dev_acc_id) coll on acc.dev_acc_id = coll.dev_acc_id";
				   if(DevUtil.isValueNotNull(proFlag,DevConstants.PROJECT_XN)){
					   sql += " where acc.project_info_id = '"+projectNo+"'"
							+ " and acc.is_leaving = '"+DevConstants.DEV_LEAVING_NO+"'"
							+ " and acc.bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
							+ " and (nvl(nvl(acc.unuse_num, 0) - nvl(back_num, 0)"
							+ " - nvl(mov_num, 0), 0)) > 0";
				    }else{
					   sql += " where acc.dev_acc_id in"+condition;
				    }
		List<Map> unitList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 保存批量转出单明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWtcCollMoveDetInfo(ISrvMsg msg) throws Exception {
		String devMovId = wtcDevSrv.saveMovDevApp(msg,"COLL");
		UserToken user = msg.getUserToken();
		// 首先删除转移明细子表
		jdbcDao.executeUpdate("delete from gms_device_move_detail t where t.dev_mov_id='"
				+ devMovId + "'");
		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		String[] lineInfos = msg.getValue("lineinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_mov_id", devMovId);
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			dataMap.put("create_date", DevUtil.getCurrentTime());
			dataMap.put("creator_id", user.getEmpId());
			dataMap.put("modifi_date", DevUtil.getCurrentTime());
			dataMap.put("updator_id", user.getEmpId());
			dataMap.put("org_id", user.getOrgId());
			dataMap.put("org_subjection_id", user.getOrgSubjectionId());
			dataMap.put("actual_out_time", msg.getValue("enddate" + lineInfos[index]));
			dataMap.put("mov_num", msg.getValue("mov_num" + lineInfos[index]));
			dataMap.put("device_detail_rid", msg.getValue("device_detail_rid"+index));
			datasList.add(dataMap);
		}
		String insOsDetSql = "insert into gms_device_move_detail("
						   + " dev_mov_det_id,"
						   + " dev_mov_id,"
						   + " dev_acc_id,"
						   + " bsflag,"
						   + " create_date,"
						   + " creator_id,"
						   + " modifi_date,"
						   + " updator_id,"
						   + " org_id,"
						   + " org_subjection_id,"
						   + " actual_out_time,"
						   + " mov_num,"
						   + " device_detail_rid"
						   + " )values(?,?,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,"
						   + " to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?,?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?)";

			jdbcDao.getJdbcTemplate().batchUpdate(insOsDetSql,
				new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) devSaveMap.get("dev_mov_id"));
						ps.setString(3, (String) devSaveMap.get("dev_acc_id"));
						ps.setString(4, (String) devSaveMap.get("bsflag"));
						ps.setString(5, (String) devSaveMap.get("create_date"));
						ps.setString(6, (String) devSaveMap.get("creator_id"));
						ps.setString(7, (String) devSaveMap.get("modifi_date"));
						ps.setString(8, (String) devSaveMap.get("updator_id"));
						ps.setString(9, (String) devSaveMap.get("org_id"));
						ps.setString(10, (String) devSaveMap.get("org_subjection_id"));
						ps.setString(11, (String) devSaveMap.get("actual_out_time"));
						ps.setInt(12, Integer.parseInt((String) devSaveMap.get("mov_num")));
						ps.setString(13, (String) devSaveMap.get("device_detail_rid"));
				}
				@Override
				public int getBatchSize() {
					return datasList.size();
				}
			});
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 查询转移主表信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWtcDevMovBaseInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String devMovId = msg.getValue("devmovid");
		String projectInfoNo = user.getProjectInfoNo();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select t.dev_mov_id,t.dev_mov_no,t.dev_mov_name,outgp.project_name as out_project_name,"
						+ " ingp.project_name as in_project_name,emp.employee_name as opertor,t.apply_date,"
						+ " case when t.out_project_info_id = '"+projectInfoNo+"' then '转出' else '转入' end as mov_state,"
						+ " case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过'"
						+ " else '未提交' end as state_desc,case t.move_status when '0' then '待转移' when '1' then '已转移'"
						+ " else '待转移' end as move_status_desc,outgp.bsflag as outbsflag,ingp.bsflag as inbsflag,"
						+ " dy.org_id,dy.org_subjection_id from gms_device_move t"
						+ " left join gp_task_project outgp on t.out_project_info_id=outgp.project_info_no"
						+ " left join gp_task_project ingp on t.in_project_info_id=ingp.project_info_no"
						+ " left join gp_task_project_dynamic dy on ingp.project_info_no = dy.project_info_no"
						+ " left join comm_human_employee emp on t.opertor_id = emp.employee_id"
						+ " left join common_busi_wf_middle wfmiddle on t.dev_mov_id=wfmiddle.business_id"
						+ " where t.dev_mov_id = '"+devMovId+"'");
		Map deviceappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(deviceappMap)) {
			responseMsg.setValue("deviceappMap", deviceappMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 单项目批量设备转移单审核 保存信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWtcCollMoveAuditInfowfpa(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String oprstate = msg.getValue("oprstate");
		String endFlag = msg.getValue("endflag");
		String devMovId = msg.getValue("devmovid");
		String inProjectNo = msg.getValue("inProjectInfoNo");
		String outProjectNo = msg.getValue("outProjectInfoNo");
		String succFlag = "success";
		
		if ("pass".equals(oprstate) && "END_NODE".equals(endFlag)) {
			// 查询转入项目的计划开始时间和结束时间作为转移设备的计划开始时间和结束时间及转入项目的队伍
			String proSql = "select t.acquire_start_time,t.acquire_end_time,dy.org_id from gp_task_project t"
						  + " left join gp_task_project_dynamic dy on t.project_info_no = dy.project_info_no"
						  + " where t.project_info_no='"+inProjectNo+"'";
			Map proMap = jdbcDao.queryRecordBySQL(proSql);
			String startDate = "";
			String endDate = "";
			String duiOrg = "";
			if(MapUtils.isNotEmpty(proMap)){
				startDate = proMap.get("acquire_start_time").toString();
				endDate = proMap.get("acquire_start_time").toString();
				duiOrg = proMap.get("org_id").toString();				
			}
			// 查询转移设备相关信息
			String querySql = "select t.dev_acc_id,t.actual_out_time,dui.fk_dev_acc_id,dui.out_org_id,"
							+ " nvl(t.mov_num,0) as mov_num,nvl(dui.unuse_num,0) as unuse_num,"
							+ " nvl(dui.use_num,0) as use_num,nvl(dui.total_num,0) as total_num,"
							+ " dui.dev_name,dui.dev_model,dui.device_id,dui.dev_unit,dui.dev_team"
				            + " from gms_device_move_detail t"
				            + " left join gms_device_coll_account_dui dui on t.dev_acc_id = dui.dev_acc_id"
				            + " where t.dev_mov_id = '"+devMovId+"'";
			List queryList = jdbcDao.queryRecords(querySql);
			// 更新转出台帐数据
			for (int i = 0; i < queryList.size(); i++) {
				// 1.操作原台帐数据
				Map queryMap = (Map) queryList.get(i);
				int movNum = Integer.parseInt((String)queryMap.get("mov_num"));// 转移数量
				int useNum = Integer.parseInt((String)queryMap.get("use_num"));// 离队数量
				int unuseNum = Integer.parseInt((String)queryMap.get("unuse_num"));// 在队数量
				
				Map<String, Object> mainMap = new HashMap<String, Object>();
				mainMap.put("dev_acc_id", queryMap.get("dev_acc_id"));
				mainMap.put("use_num", useNum + movNum);
				mainMap.put("unuse_num", unuseNum - movNum);
				if((unuseNum - movNum) < 0){
					succFlag = "fail";
					log.info("批量转移设备出现负数：devMovId = "+devMovId+" movNum = "+movNum+"  unuseNum = "+unuseNum);
					SimpleMailSender.sendTextMail("单项目批量设备转移审批", "批量转移设备出现负数：devMovId = "+devMovId+" || movNum = "+movNum+" || unuseNum = "+unuseNum);
					break;
				}
				if (unuseNum - movNum == 0) {
					mainMap.put("is_leaving", DevConstants.DEVLEAVING_YES);
					mainMap.put("actual_out_time", queryMap.get("actual_out_time"));
				}
				mainMap.put("modifi_date", DevUtil.getCurrentTime());
				mainMap.put("modifier", user.getEmpId());
				jdbcDao.saveOrUpdateEntity(mainMap,"gms_device_coll_account_dui");
				// 3.插入队级台账动态表
				Map<String, Object> duiDymMap = new HashMap<String, Object>();
				duiDymMap.put("opr_type", DevConstants.DYM_OPRTYPE_IN);
				duiDymMap.put("dev_acc_id", queryMap.get("dev_acc_id"));
				duiDymMap.put("receive_num", queryMap.get("mov_num"));
				duiDymMap.put("actual_out_time",queryMap.get("actual_out_time"));
				duiDymMap.put("create_date", DevUtil.getCurrentTime());
				duiDymMap.put("creator", user.getEmpId());
				jdbcDao.saveOrUpdateEntity(duiDymMap,"gms_device_coll_account_dym");

				// 2.操作新台帐数据
				// 查询新台帐是否存在转移的设备
				String newAccSql = "select * from gms_device_coll_account_dui t"
					             + " where t.project_info_id = '"+inProjectNo+"'"
					             + " and t.fk_dev_acc_id = '"+queryMap.get("fk_dev_acc_id")+"' ";
				Map queryNewDatas = jdbcDao.queryRecordBySQL(newAccSql);
				String devAccId = "";
				// 没有执行新增
				if (MapUtils.isEmpty(queryNewDatas)) {
					Map<String, Object> duiMap = new HashMap<String, Object>();
					duiMap.put("dev_name", queryMap.get("dev_name"));
					duiMap.put("dev_model", queryMap.get("dev_model"));
					duiMap.put("device_id", queryMap.get("device_id"));
					duiMap.put("dev_unit", queryMap.get("dev_unit"));
					duiMap.put("total_num", movNum);
					duiMap.put("unuse_num", movNum);
					duiMap.put("use_num", 0);
					duiMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
					duiMap.put("create_date", DevUtil.getCurrentTime());
					duiMap.put("creator", user.getEmpId());
					duiMap.put("modifi_date", DevUtil.getCurrentTime());
					duiMap.put("modifier", user.getEmpId());
					duiMap.put("planning_in_time",startDate);
					duiMap.put("planning_out_time",endDate);
					duiMap.put("actual_in_time",queryMap.get("actual_out_time"));
					duiMap.put("fk_dev_acc_id",queryMap.get("fk_dev_acc_id"));
					duiMap.put("project_info_id",inProjectNo);
					duiMap.put("out_org_id",queryMap.get("out_org_id"));
					duiMap.put("in_org_id",duiOrg);
					duiMap.put("is_leaving", DevConstants.DEVLEAVING_NO);
					duiMap.put("fk_device_appmix_id", devMovId);
					duiMap.put("dev_team", queryMap.get("dev_team"));
					duiMap.put("account_stat", DevConstants.DEV_ACCOUNT_ZAIZHANG);					
					devAccId = (String) jdbcDao.saveOrUpdateEntity(duiMap,"gms_device_coll_account_dui");
				} else {
					// 否则执行累加
					devAccId = queryNewDatas.get("dev_acc_id").toString();
					int newTotalNum = Integer.parseInt((String)queryNewDatas.get("total_num"));
					int newUnUseNum = Integer.parseInt((String)queryNewDatas.get("unuse_num"));
					queryNewDatas.put("total_num", newTotalNum + movNum);
					queryNewDatas.put("unuse_num", newUnUseNum + movNum);
					queryNewDatas.put("modifi_date", DevUtil.getCurrentTime());
					queryNewDatas.put("modifier", user.getEmpId());
					queryNewDatas.put("is_leaving", DevConstants.DEVLEAVING_NO);
					jdbcDao.saveOrUpdateEntity(queryNewDatas,"gms_device_coll_account_dui");
				}
				// 队级台账动态表插入
				Map<String, Object> dymMap = new HashMap<String, Object>();
				dymMap.put("dev_acc_id", devAccId);
				dymMap.put("opr_type", "1");
				dymMap.put("receive_num", movNum);
				dymMap.put("actual_in_time", queryMap.get("actual_out_time"));
				dymMap.put("create_date", DevUtil.getCurrentTime());
				dymMap.put("creator", user.getEmpId());
				jdbcDao.saveOrUpdateEntity(dymMap,"gms_device_coll_account_dym");
			}
			 if("success".equals(succFlag)){
				// 更新设备转移主表转移状态为：已转移
				jdbcDao.executeUpdate("update gms_device_move set move_status = '1'"
									+ " where dev_mov_id = '"+devMovId+"'");
			 }
		}
		// 7.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 调剂申请单
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryTJDevMainInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectName = msg.getValue("projectname");
		String deviceAppName = msg.getValue("deviceappname");
		String outOrg = msg.getValue("outorg");
		String inOrg = msg.getValue("inorg");
		String oprState = msg.getValue("oprstate");
		String wfFlag = msg.getValue("wfFlag");//Y：审批页面调用    N：调剂申请页面调用
		StringBuffer querySql = new StringBuffer();
		querySql.append("select f.device_mixinfo_id,f.mixinfo_no,f.mixinfo_name,inorg.org_abbreviation as inorgname,"
				+ " inorg.org_abbreviation || '-' || duiorg.org_abbreviation as sub_org_name,"
				+ " case when length(p.project_name) > 16 then substr(p.project_name, 0, 16) || '...'"
				+ " else p.project_name end as proname,"
				+ " case when length(f.mixinfo_name) > 16 then substr(f.mixinfo_name, 0, 16) || '...'"
				+ " else f.mixinfo_name end as mixname,f.project_info_no,"
				+ " outorg.org_abbreviation as outorgname,f.wapproval_date as appdate,p.project_name,f.state,"
				+ " case when f.state ='0' then '未提交' when f.state='1' then '审批通过' when f.state ='2'"
				+ " then '待审批' when f.state ='3' then '审批不通过' when f.state ='4' then '待审批' end as state_desc,"
				+ " puser.employee_name from gms_device_mixinfo_form f"
				+ " left join comm_org_information inorg on f.mix_org_id = inorg.org_id and inorg.bsflag = '0'"
				+ " left join comm_org_information outorg on f.out_org_id = outorg.org_id and outorg.bsflag = '0'"
				+ " left join comm_org_information duiorg on duiorg.org_id = f.in_org_id and duiorg.bsflag = '0'"
				+ " left join gp_task_project p on p.project_info_no=f.project_info_no"
				+ " left join comm_human_employee puser on puser.employee_id = f.mix_user_id"
				+ " left join comm_org_subjection mixsub on f.out_org_id = mixsub.org_id and mixsub.bsflag = '0'"
				+ " where f.mixform_type = '6' and f.bsflag = '0'");
		if(DevUtil.isValueNotNull(wfFlag)&&"Y".equals(wfFlag)){
			querySql.append("and mixsub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%' ");
		}else{
			querySql.append("and f.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%' ");
		}
		//项目名称
		if (StringUtils.isNotBlank(projectName)) {
			querySql.append(" and project_name like '%"+projectName+"%'");
		}
		//申请单名称
		if (StringUtils.isNotBlank(deviceAppName)) {
			querySql.append(" and mixinfo_name like '%"+deviceAppName+"%' ");
		}
		//转出单位名称
		if (StringUtils.isNotBlank(outOrg)) {
			querySql.append(" and outorg.org_name like '%"+outOrg+"%' ");
		}
		//转入单位名称
		if (StringUtils.isNotBlank(inOrg)) {
			querySql.append(" and inorg.org_name like '%"+outOrg+"%' ");
		}
		//审批状态
		if (StringUtils.isNotBlank(oprState)) {
			if(DevUtil.isValueNotNull(wfFlag)&&"Y".equals(wfFlag)){
				if("0".equals(oprState)){
					querySql.append(" and f.state = '2' ");
				}else{
					querySql.append(" and (f.state='3' or f.state='1') ");
				}
			}else{
				if("2".equals(oprState) || "4".equals(oprState)){
					querySql.append(" and (state = '2' or state = '4') ");
				}else{
					querySql.append(" and state = '"+oprState+"' ");
				}
			}
		}
		
		querySql.append(" order by case f.state when '0' then 'A' when '2' then 'B' when '4' then 'C' when '3' then 'D' else 'D' end, f.create_date desc ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 删除、修改、提交调剂设备单据状态判断
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opTJDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String userSubOrg = user.getOrgSubjectionId();
		String delFlag = "0";
		String mixState = "";
		String opState = "";//0未提交 1审核通过 2待审核 3审核失败		
		String devMixId = msg.getValue("devmixid");
		String opFlag = msg.getValue("opflag");
		String projectInfoNo = "";
		try{
			String appSql = "select mix.state,mix.project_info_no from gms_device_mixinfo_form mix"
						  + " where mix.device_mixinfo_id = '"+devMixId+"' ";
			Map mixMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(mixMap)){
				mixState = mixMap.get("state").toString();
				projectInfoNo = mixMap.get("project_info_no").toString();
				if(!"0".equals(mixState)){
					if("wf".equals(opFlag)){//审批调剂设备单据时判断单据是否已经审批
						if("1".equals(mixState) || "3".equals(mixState)){
							delFlag = "1";//审批通过和审批不通过的单据不能再次审批
						}
					}else{
						delFlag = "1";//已提交的单据不能删除/修改/提交
					}
				}else{
					if("tj".equals(opFlag)){
						if(userSubOrg.startsWith("C105029")){//如果为东方公司设备物资科调剂直接通过
							opState = "1";
						}else{
							opState = "2";
						}
						String proOrgId = msg.getValue("pro_org_id");//项目所在小队org_id
						String proSubId = msg.getValue("pro_sub_id");//项目所在小队org_sub_id
						String proOrgName = msg.getValue("pro_org_name");////项目所在小队名称
						
						String delSql = "update gms_device_mixinfo_form"
									  + " set state = '"+opState+"',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where device_mixinfo_id='"+devMixId+"'";
						jdbcDao.executeUpdate(delSql);
						//如果为审批通过直接更新多项目设备台账状态
						if("1".equals(opState)){
							String upAccSql = "update gms_device_account"
											+ " set saveflag = '1',"
											+ " ifunused = '0',"
											+ " using_stat = '"+DevConstants.DEV_USING_ZAIYONG+"',"
											+ " usage_org_id = '"+proOrgId+"',"
											+ " usage_sub_id = '"+proSubId+"',"
											+ " usage_org_name = '"+proOrgName+"'"
											+ " where dev_acc_id in"
											+ " (select d.dev_acc_id from gms_device_appmix_detail d"
											+ " where d.device_mix_subid='"+devMixId+"')";
							jdbcDao.executeUpdate(upAccSql);
						}
					}else if("del".equals(opFlag)){
						String delSql = "update gms_device_mixinfo_form"
									  + " set bsflag = '1',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where device_mixinfo_id='"+devMixId+"'";
						jdbcDao.executeUpdate(delSql);
						
						//自有单台设备逻辑删除
						String upSaveFlagSql = "update gms_device_account"
									         + " set saveflag = '0'"
									         + " where dev_acc_id in"
									         + " (select d.dev_acc_id from gms_device_appmix_detail d"
									         + " where d.device_mix_subid = '"+devMixId+"')";
						jdbcDao.executeUpdate(upSaveFlagSql);
					}
				}
			}else{
				delFlag = "3";//删除/提交/修改失败
			}
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除/提交/修改失败
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 调剂设备审批明细显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryWfTjDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devMixId = msg.getValue("devmixid");
		String sql = "select '物探处审批' as wutanchu, to_char(f.approval_date,'yyyy-mm-dd') as wdate,"
			       + " f.wapproval_desc,emp.employee_name,"
			       + " case when f.state='2' then '待审批' when f.state='4' then '审批通过'"
			       + " when f.state='1' then '审批通过' when f.state='3' then '审批不通过' end as state"
			   	   + " from gms_device_mixinfo_form f"
			   	   + " left join comm_human_employee emp on f.wapprovaler = emp.employee_id"
				   + " where f.state != '0' and f.device_mixinfo_id = '"+devMixId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * 获得设备存放地数据
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevPositionInfo(ISrvMsg msg) throws Exception{
		String posFlag = msg.getValue("posflag");//P:省市县区  S：设备资产库
		String posValue  = msg.getValue("posvalue");
		String posSql = "";
		if(DevUtil.isValueNotNull(posFlag)){
			posSql = "select pos_id as code,pos_name as note from gms_device_position"
				   + " where bsflag = '0' and pos_level = 1 ";
			if("S".equals(posFlag)){//验收时显示资产库
				posSql += "order by case when pos_id = '910000' then 'A' else 'B' end,pos_id ";
			}else{
				posSql += "and pos_flag = 'P'";
			}
		}
		if(DevUtil.isValueNotNull(posValue)){
			posSql = "select pos_id as code,pos_name as note from gms_device_position"
				   + " where bsflag = '0' and parent_id = '"+posValue+"'";
		}
		System.out.println("posSql == "+posSql);
		List list = jdbcDao.queryRecords(posSql.toString());			
		JSONArray retJson = JSONArray.fromObject(list);			
		ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);			
		if(retJson == null){
			outmsg.setValue("json", "[]");
		}else {
			outmsg.setValue("json", retJson.toString());
		}			
		return outmsg;
	}
	
	/**
	 * 导出震源档案
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZYInfo(ISrvMsg msg) throws Exception {
		String devId = msg.getValue("devid");// 设备ID
		String modelName = "震源档案信息";// 导出excel的名称
		String modelPath = "/rm/dm/excelModelNew/zy_template.xls";// excel模板存放路径
		ISrvMsg outMsg = SrvMsgUtil.createResponseMsg(msg);
		outMsg.setValue("modelname", modelName);
		outMsg.setValue("modelpath", modelPath);
		// 单机消耗记录
		String djSql = " select rownum rm , t.* from(select distinct * from (select nvl((select project_name from gp_task_project p where p.project_info_no = wx.project_info_id), '不在项目') as projectname, r.wz_id, i.wz_name, i.wz_prickie, i.wz_price, r.actual_price, mat.use_num, to_char(wx.bywx_date,'yyyy-MM-dd') bywx_date, wx.create_date from gms_device_zy_bywx wx left join gms_device_zy_wxbymat mat on wx.usemat_id = mat.usemat_id left join gms_mat_recyclemat_info r on r.wz_id = mat.wz_id left join gms_mat_infomation i on i.wz_id = r.wz_id left join gms_device_account_dui dui on dui.dev_acc_id = wx.dev_acc_id where dui.fk_dev_acc_id = '"+devId+"' and r.wz_type = '3' and r.bsflag = '0' and r.project_info_id is not null and wx.project_info_id is not null and wx.bsflag = '0' and wx.project_info_id = r.project_info_id union all select nvl((select project_name from gp_task_project p where p.project_info_no = wx.project_info_id), '不在项目') as projectname, r.wz_id, i.wz_name, i.wz_prickie, i.wz_price, r.actual_price, mat.use_num, to_char(wx.bywx_date,'yyyy-MM-dd') bywx_date, wx.create_date from gms_device_zy_bywx wx left join gms_device_zy_wxbymat mat on wx.usemat_id = mat.usemat_id left join gms_mat_recyclemat_info r on r.wz_id = mat.wz_id left join gms_mat_infomation i on i.wz_id = r.wz_id left join gms_device_account dui on dui.dev_acc_id = wx.dev_acc_id where dui.dev_acc_id = '"+devId+"' and r.wz_type = '3' and r.bsflag = '0' and r.project_info_id is null and wx.project_info_id is null and wx.bsflag = '0') a where 1 = 1 order by bywx_date desc, create_date desc) t ";
		outMsg.setValue("djxhlist", djSql);
		// 参与项目
		String proSql = " select rownum rm,t.*,to_char(actual_in_time,'yyyy-MM-dd')||'--'||to_char(actual_out_time,'yyyy-MM-dd') newdate,country||'/'||project_address newcountry from(select pro.project_name, dui1.dev_name, dui.asset_coding, dui.actual_in_time, dui.actual_out_time, p.local_temp_low, p.local_temp_height, p.projecter, p.country, p.project_address, p.work_hour, p.surface, dui1.dev_model, dui1.self_num, org.org_abbreviation, p.construction_method, p.construction_paramete from gms_device_account_dui dui join gms_device_zy_project p on p.project_info_id = dui.project_info_id join gms_device_account dui1 on dui.fk_dev_acc_id = dui1.dev_acc_id join gp_task_project pro on dui.project_info_id = pro.project_info_no join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no join comm_org_information org on org.org_id = dy.org_id where dui.fk_dev_acc_id = '"+devId+"' order by dui.actual_in_time desc, dui.actual_out_time desc)t ";
		outMsg.setValue("prolist", proSql);
		// 油品消耗
		String oilSql = " select rownum rm,t.* from(select acc.dev_name, acc.asset_coding, pro.project_name, t.project_info_no, d.dev_acc_id, nvl(sum(d.oil_num), 0) oil_num, nvl(sum(d.total_money), 0) total_money from gms_mat_teammat_out t left join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id = d.teammat_out_id left join gms_device_account_dui acc on acc.dev_acc_id = d.dev_acc_id left join gp_task_project pro on t.project_info_no = pro.project_info_no where t.out_type = '3' and acc.fk_dev_acc_id = '"+devId+"' group by acc.dev_name, acc.asset_coding, pro.project_name, t.project_info_no, d.dev_acc_id)t ";
		outMsg.setValue("oillist", oilSql);
		//总成绩更换记录
		 String zcjghsql="select rownum rm,t.*,to_char(bywx_date,'yyyy-MM-dd') bywx_date1 from (select a.*,b.wz_sequences,b.bywx_date,repair_men from ( select code.coding_code_id,code.coding_name, s.mat_model, s.wz_sequence   from comm_coding_sort_detail code   left join (select z.*                from GMS_DEVICE_ZY_ZCJ z, gms_device_account dui               where dui.self_num = z.self_num                 and dui.dev_acc_id = '"+devId+"') s     on code.coding_code_id = s.coding_code_id  where code.coding_sort_id = '5110000187'   and code.coding_code_id != '5110000187000000015'   and code.bsflag = '0' order by code.coding_code_id asc ) a left join (select distinct *  from (select                  t.zcj_type as  zcj_type,                t.repair_men,               w.wz_sequences,               t.bywx_date          from gms_device_zy_bywx t  left join (select t.parent_falut_id,                                   l.usemat_id,                                   l.falut_reason,                                   d.deal_name                              from gms_device_zy_falut l                              left join GMS_DEVICE_ZY_FALUT_CATEGORY t                               on l.falut_group_id = t.falut_id                             left join GMS_DEVICE_ZY_FALUT_DEAL d                               on l.falut_desc = d.deal_id                            where l.bsflag = '0'                              and l.falut_source = '1'                              and l.falut_case = '1') p                   on t.usemat_id = p.usemat_id         left join gms_device_account_dui d            on d.dev_acc_id = t.dev_acc_id         left join gms_device_zy_wxbymat w           on t.usemat_id = w.usemat_id         left join gms_mat_recyclemat_info r           on r.wz_id = w.wz_id         left join gms_mat_infomation i           on i.wz_id = r.wz_id         left join gp_task_project g          on g.project_info_no = t.project_info_id         left join gms_device_zy_project sg           on sg.project_info_id = t.project_info_id        where r.wz_type = '3'          and r.bsflag = '0'           and t.bsflag = '0'          and t.dev_acc_id in (select dev_acc_id                                 from gms_device_account_dui                                where   FK_DEV_ACC_ID = '"+devId+"' )          and t.project_info_id is not null          and r.project_info_id is not null          and r.project_info_id = t.project_info_id          and t.zcj_type is not null       union all      select               t.zcj_type as  zcj_type,             t.repair_men,             w.wz_sequences,             t.bywx_date        from gms_device_zy_bywx t           left join (select t.parent_falut_id,                                 l.usemat_id,                                 l.falut_reason,                                 d.deal_name                            from gms_device_zy_falut l                            left join GMS_DEVICE_ZY_FALUT_CATEGORY t                              on l.falut_group_id = t.falut_id                            left join GMS_DEVICE_ZY_FALUT_DEAL d                              on l.falut_desc = d.deal_id                           where l.bsflag = '0'                             and l.falut_source = '1'                             and l.falut_case = '1') p                  on t.usemat_id = p.usemat_id        left join gms_device_account d          on d.dev_acc_id = t.dev_acc_id        left join gms_device_zy_wxbymat w          on t.usemat_id = w.usemat_id        left join gms_mat_recyclemat_info r          on r.wz_id = w.wz_id        left join gms_mat_infomation i          on i.wz_id = r.wz_id        left join gms_device_zy_project sg          on sg.project_info_id = t.project_info_id       where t.project_info_id is null         and r.project_info_id is null         and r.wz_type = '3'         and r.bsflag = '0'         and t.bsflag = '0'         and t.project_info_id is null         and t.dev_acc_id in (select dev_acc_id                                from gms_device_account                               where      FK_DEV_ACC_ID = '"+devId+"')         and t.zcj_type is not null      union all   select              w.zcj_code_id as  zcj_type,             t.repair_men,             w.wz_sequences,             t.bywx_date        from gms_device_zy_bywx t        left join (select t.parent_falut_id,                                l.usemat_id,                                l.falut_reason,                               d.deal_name                           from gms_device_zy_falut l                           left join GMS_DEVICE_ZY_FALUT_CATEGORY t                             on l.falut_group_id = t.falut_id                           left join GMS_DEVICE_ZY_FALUT_DEAL d                             on l.falut_desc = d.deal_id                          where l.bsflag = '0'                            and l.falut_source = '1'                            and l.falut_case = '1') p                 on t.usemat_id = p.usemat_id       left join gms_device_account_dui d         on d.dev_acc_id = t.dev_acc_id       left join gms_device_zy_wxbymat w         on t.usemat_id = w.usemat_id       left join gms_mat_recyclemat_info r         on r.wz_id = w.wz_id       left join gms_mat_infomation i         on i.wz_id = r.wz_id      left join gp_task_project g        on g.project_info_no = t.project_info_id      left join gms_device_zy_project sg        on sg.project_info_id = t.project_info_id      where r.wz_type = '3'        and r.bsflag = '0'        and t.bsflag = '0'        and t.dev_acc_id in (select dev_acc_id                              from gms_device_account_dui                             where    FK_DEV_ACC_ID = '"+devId+"')        and t.project_info_id is not null        and w.zcj_code_id is not null     ) a WHERE a.zcj_type in ('5110000187000000001','5110000187000000003','5110000187000000005','5110000187000000006','5110000187000000008','5110000187000000010','5110000187000000011','5110000187000000013','5110000187000000002','5110000187000000007','5110000187000000012','5110000187000000004','5110000187000000009','5110000187000000014','5110000187000000015','0')  order by bywx_date desc) b on b.zcj_type=a.coding_code_id  order by coding_code_id,bywx_date desc) t";
		outMsg.setValue("zcjghlist", zcjghsql);
		 //保养记录
		 StringBuffer byjl = new StringBuffer()
			 .append(" select rownum,t.* from(select distinct * from (select wx.create_date, to_char(wx.bywx_date,'yyyy-MM-dd') bywx_date, wx.maintenance_level, wx.maintenance_desc, (select d.coding_name from comm_coding_sort_detail d where d.coding_code_id = wx.zcj_type) as zcj_type, wx.usemat_id, '不在项目' as project_name, t.dev_name, t.self_num, t.dev_model, wx.work_hours, (case wx.performance_desc when '0' then '良好' when '1' then '待修' when '2' then '待查' end) as performance_desc, wx.repair_men, wx.bak from gms_device_zy_bywx wx left join gms_device_account t on wx.dev_acc_id = t.dev_acc_id where (wx.bywx_type = '2' or ((wx.bywx_type = '0' or wx.bywx_type is null) and wx.maintenance_level <> '无')) and wx.bsflag = '0' and wx.project_info_id is null and wx.dev_acc_id = '"+devId+"' union all select wx.create_date, to_char(wx.bywx_date,'yyyy-MM-dd') bywx_date, wx.maintenance_level, wx.maintenance_desc, (select d.coding_name from comm_coding_sort_detail d where d.coding_code_id = wx.zcj_type) as zcj_type, wx.usemat_id, p.project_name, dui.dev_name, dui.self_num, dui.dev_model, wx.work_hours, (case wx.performance_desc when '0' then '良好' when '1' then '待修' when '2' then '待查' end) as performance_desc, wx.repair_men, wx.bak from gms_device_zy_bywx wx left join gms_device_account_dui dui on wx.dev_acc_id = dui.dev_acc_id left join gp_task_project p on p.project_info_no = wx.project_info_id where (wx.bywx_type = '2' or ((wx.bywx_type = '0' or wx.bywx_type is null) and wx.maintenance_level <> '无')) and wx.bsflag = '0' and wx.project_info_id is not null and dui.fk_dev_acc_id = '"+devId+"') tt order by tt.bywx_date desc, tt.create_date desc)t ");
		 outMsg.setValue("byjllist", byjl.toString());
		 
	 
	 
		// 设备基本信息
		StringBuffer devinfoSql = new StringBuffer()
		.append("select t.*, ")
		.append("(select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, ")
		.append("(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,")
		.append("(select org_name from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,")
		.append("(select org_name from comm_org_information org where t.USAGE_ORG_ID=org.org_id) as usage_org_name_desc,")
		.append("(select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,")
		.append("d.coding_name as stat_desc from ("
				+ "select ifcountry,dev_coding,dev_acc_id,dev_name,dev_model,dev_sign,self_num,license_num,dev_type,producting_date,asset_value,net_value,dev_position,asset_coding,cont_num,turn_num,using_stat,saveflag,spare1,spare2,spare3,spare4,usage_org_id ,owning_org_id,project_info_no,account_stat,tech_stat,bsflag,owning_sub_id,usage_sub_id,indiv_dev_type,engine_num,chassis_num from GMS_DEVICE_ACCOUNT "
				+ ") t left join comm_coding_sort_detail d on t.account_stat=d.coding_code_id ")
		.append("where dev_acc_id='" + devId + "'");  
		outMsg.setValue("deviceaccMapList", devinfoSql.toString());

		// 运转记录
		  String yzjlSql = "select rownum as rm,t.* from ( select  pro.project_info_no,pro.project_name,otmp.dev_name,otmp.asset_coding,otmp.dev_acc_id,";
		yzjlSql +=" sum(nvl(otmp.work_hour, 0)) as work_hour_total,  to_char(max(otmp.modify_date),'yyyy-MM-dd') as modify_date ";
		yzjlSql +=" from (select nvl(oi.work_hour, 0) as work_hour,oi.modify_date,acc.dev_acc_id,acc.dev_name,acc.asset_coding,'' as project_info_no";
		yzjlSql +=" from gms_device_operation_info oi inner join gms_device_account acc on oi.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1' and acc.dev_acc_id = '"+devId+"'";
		yzjlSql +=" union all";
		yzjlSql +=" select nvl(oi.work_hour, 0) as work_hour,oi.modify_date,dui.fk_dev_acc_id as dev_acc_id,dui.dev_name,dui.asset_coding,oi.project_info_no";
		yzjlSql +=" from gms_device_operation_info oi inner join gms_device_account_dui dui on oi.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1' and dui.fk_dev_acc_id = '"+devId+"') otmp";
		yzjlSql +=" left join gp_task_project pro on otmp.project_info_no = pro.project_info_no and pro.bsflag = '0'";
		yzjlSql +=" group by pro.project_info_no,pro.project_name,otmp.dev_name,otmp.asset_coding,otmp.dev_acc_id order by modify_date)t ";
		outMsg.setValue("yzjllist", yzjlSql);
		// 强制保养记录
		String qzbySql = "select rownum rm,t.*,falut_reason||'  '||falut_case newcol,to_char(t.bywx_date,'yyyy-MM-dd') bywx_date1 from(SELECT distinct* FROM (SELECT * FROM (SELECT wx.create_date, wx.bak, wx.legacy, wx.falut_reason||p.deal_name AS falut_reason, wx.work_hours, t.dev_model,  wx.bywx_date, wx.falut_desc||p.deal_name AS falut_desc, wx.falut_case||p.falut_reason AS falut_case, wx.maintenance_desc, wx.repair_unit, wx.repair_men, (SELECT d.coding_name FROM comm_coding_sort_detail d WHERE d.coding_code_id = wx.zcj_type) AS zcj_type, wx.usemat_id, t.dev_name, i.wz_name, t.self_num FROM gms_device_zy_bywx wx LEFT JOIN (SELECT t.parent_falut_id, l.usemat_id, l.falut_reason, d.deal_name FROM gms_device_zy_falut l LEFT JOIN GMS_DEVICE_ZY_FALUT_CATEGORY t ON l.falut_group_id = t.falut_id LEFT JOIN GMS_DEVICE_ZY_FALUT_DEAL d ON l.falut_desc = d.deal_id WHERE l.bsflag = '0' AND l.falut_source = '1' AND l.falut_case = '1') p ON wx.usemat_id = p.usemat_id LEFT JOIN gms_device_zy_wxbymat w ON wx.usemat_id = w.usemat_id LEFT JOIN gms_mat_recyclemat_info r ON r.wz_id = w.wz_id LEFT JOIN gms_mat_infomation i ON r.wz_id = i.wz_id LEFT JOIN gms_device_account_dui t ON t.dev_acc_id = wx.dev_acc_id WHERE r.wz_type = '3' AND r.bsflag = '0' AND wx.bsflag = '0' AND wx.project_info_id is NOT null AND r.project_info_id is NOT null AND wx.project_info_id = wx.project_info_id AND (wx.bywx_type = '1' OR ((wx.bywx_type = '0' OR wx.bywx_type is null) AND wx.maintenance_level = '无')) AND t.fk_dev_acc_id = '"+devId+"' UNION all SELECT wx.create_date, wx.bak, wx.legacy, wx.falut_reason||p.deal_name AS falut_reason, wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc||p.deal_name AS falut_desc, wx.falut_case||p.falut_reason AS falut_case, wx.maintenance_desc, wx.repair_unit, wx.repair_men, (SELECT d.coding_name FROM comm_coding_sort_detail d WHERE d.coding_code_id = wx.zcj_type) AS zcj_type, wx.usemat_id, t.dev_name, i.wz_name, t.self_num FROM gms_device_zy_bywx wx LEFT JOIN (SELECT t.parent_falut_id, l.usemat_id, l.falut_reason, d.deal_name FROM gms_device_zy_falut l LEFT JOIN GMS_DEVICE_ZY_FALUT_CATEGORY t ON l.falut_group_id = t.falut_id LEFT JOIN GMS_DEVICE_ZY_FALUT_DEAL d ON l.falut_desc = d.deal_id WHERE l.bsflag = '0' AND l.falut_source = '1' AND l.falut_case = '1' ) p ON wx.usemat_id = p.usemat_id LEFT JOIN gms_device_zy_wxbymat w ON wx.usemat_id = w.usemat_id LEFT JOIN gms_mat_recyclemat_info r ON r.wz_id = w.wz_id LEFT JOIN gms_mat_infomation i ON i.wz_id = r.wz_id LEFT JOIN gms_device_account t ON t.dev_acc_id = wx.dev_acc_id WHERE r.wz_type = '3' AND r.bsflag = '0' AND wx.bsflag = '0' AND wx.project_info_id is null AND r.project_info_id is null AND (wx.bywx_type = '1' OR ((wx.bywx_type = '0' OR wx.bywx_type is null) AND wx.maintenance_level = '无')) AND t.dev_acc_id = '"+devId+"') tt UNION all SELECT * FROM (SELECT wx.create_date, wx.bak, wx.legacy, wx.falut_reason||p.deal_name AS falut_reason, wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc||p.deal_name AS falut_desc, wx.falut_case||p.falut_reason AS falut_case, wx.maintenance_desc, wx.repair_unit, wx.repair_men, (SELECT d.coding_name FROM comm_coding_sort_detail d WHERE d.coding_code_id = wx.zcj_type) AS zcj_type, wx.usemat_id, t.dev_name, '' AS wz_name, t.self_num FROM gms_device_zy_bywx wx LEFT JOIN (SELECT t.parent_falut_id, l.usemat_id, l.falut_reason, d.deal_name FROM gms_device_zy_falut l LEFT JOIN GMS_DEVICE_ZY_FALUT_CATEGORY t ON l.falut_group_id = t.falut_id LEFT JOIN GMS_DEVICE_ZY_FALUT_DEAL d ON l.falut_desc = d.deal_id WHERE l.bsflag = '0' AND l.falut_source = '1' AND l.falut_case = '1' ) p ON wx.usemat_id = p.usemat_id LEFT JOIN gms_device_account_dui t ON t.dev_acc_id = wx.dev_acc_id WHERE (wx.usemat_id is null OR wx.usemat_id NOT IN (SELECT usemat_id FROM gms_device_zy_wxbymat WHERE usemat_id is NOT null)) AND wx.bsflag = '0' AND wx.project_info_id is NOT null AND (wx.bywx_type = '1' OR ((wx.bywx_type = '0' OR wx.bywx_type is null) AND wx.maintenance_level = '无')) AND t.fk_dev_acc_id = '"+devId+"' UNION all SELECT wx.create_date, wx.bak, wx.legacy, wx.falut_reason||p.deal_name AS falut_reason, wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc||p.deal_name AS falut_desc, wx.falut_case||p.falut_reason AS falut_case, wx.maintenance_desc, wx.repair_unit, wx.repair_men, (SELECT d.coding_name FROM comm_coding_sort_detail d WHERE d.coding_code_id = wx.zcj_type) AS zcj_type, wx.usemat_id, t.dev_name, '' AS wz_name, t.self_num FROM gms_device_zy_bywx wx LEFT JOIN (SELECT t.parent_falut_id, l.usemat_id, l.falut_reason, d.deal_name FROM gms_device_zy_falut l LEFT JOIN GMS_DEVICE_ZY_FALUT_CATEGORY t ON l.falut_group_id = t.falut_id LEFT JOIN GMS_DEVICE_ZY_FALUT_DEAL d ON l.falut_desc = d.deal_id WHERE l.bsflag = '0' AND l.falut_source = '1' AND l.falut_case = '1' ) p ON wx.usemat_id = p.usemat_id LEFT JOIN gms_device_account t ON t.dev_acc_id = wx.dev_acc_id WHERE (wx.usemat_id is null OR wx.usemat_id NOT IN (SELECT usemat_id FROM gms_device_zy_wxbymat WHERE usemat_id is NOT null)) AND wx.bsflag = '0' AND wx.project_info_id is null AND (wx.bywx_type = '1' OR ((wx.bywx_type = '0' OR wx.bywx_type is null) AND wx.maintenance_level = '无')) AND t.dev_acc_id = '"+devId+"') ttt) k ORDER BY bywx_date DESC ,create_date DESC )t";
		outMsg.setValue("qzbylist", qzbySql);
		 
		 
	 
		outMsg.setValue(
				"listname",
				"djxhlist,prolist,oillist,yzjllist,qzbylist,deviceaccMapList,byjllist,zcjghlist");
		return outMsg;
	}
	/**
	 * 导出设备档案
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevArchiveInfo(ISrvMsg msg) throws Exception {
		String devId = msg.getValue("devid");// 设备ID
		String modelName = "设备档案信息";// 导出excel的名称
		String modelPath = "/rm/dm/excelModelNew/dev_template.xls";// excel模板存放路径
		ISrvMsg outMsg = SrvMsgUtil.createResponseMsg(msg);
		outMsg.setValue("modelname", modelName);
		outMsg.setValue("modelpath", modelPath);
		// 定人定机记录
		String djSql = "select pro.project_name, acc.dev_name,acc.dev_model, acc.dev_coding, info.operator_name"
				+ " from gms_device_equipment_operator info"
				+ " left join gms_device_archive_detail arc on arc.dev_archive_refid = info.entity_id"
				+ " left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id"
				+ " left join gp_task_project pro on arc.project_info_id = pro.project_info_no"
				+ " where arc.dev_archive_type = '5' and info.bsflag != '1'"
				+ " and arc.dev_acc_id = '" + devId + "'";
		outMsg.setValue("djlist", djSql);
		// 参与项目
		String proSql = "select pro.project_name, acc.dev_name,acc.dev_model, acc.dev_coding, dui.actual_in_time,dui.actual_out_time"
				+ " from gms_device_account_dui dui"
				+ " left join gms_device_account acc on acc.dev_acc_id = dui.fk_dev_acc_id"
				+ " left join gp_task_project pro on dui.project_info_id = pro.project_info_no"
				+ " where dui.bsflag = '0' and acc.dev_acc_id = '"
				+ devId
				+ "'"
				+ " group by pro.project_name,acc.dev_name,acc.dev_coding,acc.dev_model,"
				+ " dui.actual_in_time,dui.actual_out_time";
		outMsg.setValue("prolist", proSql);
		// 油品消耗
		String oilSql = "select acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num,row_number() over( order by aa.modifi_date desc) as rm ,aa.modifi_date,nvl(sum(aa.oil_num), 0) oil_num,nvl(sum(aa.total_money), 0) total_money"
				+ " from (select d.dev_acc_id,nvl(sum(d.oil_num), 0) oil_num,nvl(sum(d.total_money), 0) total_money,"
				+ " to_char(t.modifi_date, 'yyyy') as modifi_date"
				+ " from gms_mat_teammat_out t"
				+ " left join gms_mat_teammat_out_detail d on t.teammat_out_id = d.teammat_out_id"
				+ " left join gms_device_account_dui acc on acc.dev_acc_id = d.dev_acc_id"
				+ " left join gp_task_project pro on t.project_info_no = pro.project_info_no"
				+ " where t.out_type = '3' and t.bsflag = '0' and acc.fk_dev_acc_id = '"
				+ devId
				+ "'"
				+ " group by d.dev_acc_id, t.modifi_date) aa,gms_device_account acc1 where acc1.dev_acc_id='"
				+ devId
				+ "'  group by aa.modifi_date, acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num";
		outMsg.setValue("oillist", oilSql);
		// 操作人
		String oper_namesql = "select '" + getDevAccOperInfo(msg)
				+ "' oper_names from dual";
		//累计使用天数
		StringBuffer days = new StringBuffer()
    	.append("select nvl(sum(end_time - begin_time),'0') as days from ( select nvl(dui.actual_in_time,"
    			+ " to_date(to_char(sysdate, 'yyyy-mm-dd'), 'yyyy-mm-dd')) as begin_time,"
    			+ " nvl(dui.actual_out_time, to_date(to_char(sysdate, 'yyyy-mm-dd'), 'yyyy-mm-dd')) as end_time"
    			+ " from gms_device_account_dui dui where dui.bsflag='0' and   dui.fk_dev_acc_id ='"+devId+"')");
		//保养花费
		 StringBuffer bycost = new StringBuffer()
	 		.append("select nvl(sum(tmp.human_cost+tmp.material_cost)/10000, 0) as by_cost from (select nvl(info.human_cost, 0) as human_cost,"
	 				+ " nvl(info.material_cost, 0) as material_cost,dui.fk_dev_acc_id as dev_acc_id"
	 				+ " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id"
	 				+ " where info.repair_level = '605'"
	 				+ " union all"
	 				+ " select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,acc.dev_acc_id"
	 				+ " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account acc on info.device_account_id = acc.dev_acc_id"
	 				+ " where info.repair_level = '605') tmp where tmp.dev_acc_id = '"+devId+"'");
		 //保养次数
		 StringBuffer bycount = new StringBuffer()
			 .append("select count(*) bycount from (select info.create_date,dui.fk_dev_acc_id as dev_acc_id from BGP_COMM_DEVICE_REPAIR_INFO info"
					 + " inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id where info.repair_level = '605'"
					 + " union all"
					 + " select info.create_date,acc.dev_acc_id from BGP_COMM_DEVICE_REPAIR_INFO info"
					 + " inner join gms_device_account acc on info.DEVICE_ACCOUNT_ID = acc.dev_acc_id where info.repair_level = '605') tmp"
					 + " where tmp.dev_acc_id = '"+ devId + "'");
		 //年度保养次数
		StringBuffer by_year_count = new StringBuffer();
		by_year_count.append(bycount);
		by_year_count.append(" and to_char(tmp.create_date,'yyyy')=to_char(sysdate,'yyyy')");
		//维修次数
		StringBuffer wxcount = new StringBuffer()
		.append("select count(*) wxcount from (select info.modifi_date,info.repair_item,dui.dev_acc_id"
				+ " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id"
				+ " where info.repair_level <> '605'"
				+ " union all"
				+ " select info.modifi_date,info.repair_item,acc.dev_acc_id from BGP_COMM_DEVICE_REPAIR_INFO info"
				+ " inner join gms_device_account acc on info.DEVICE_ACCOUNT_ID = acc.dev_acc_id where info.repair_level <> '605') tmp"
				+ " where tmp.dev_acc_id = '"+ devId + "'");
		//年度维修次数
		StringBuffer wx_year_count = new StringBuffer();
		 		
		wx_year_count.append(wxcount).append(" and to_char(tmp.modifi_date,'yyyy')=to_char(sysdate,'yyyy') ");
		//发动机维修次数
		StringBuffer wx_eng_count = new StringBuffer();
		wx_eng_count.append(wxcount);
		wx_eng_count.append(" and tmp.repair_item='"+DevConstants.DEV_REPAIR_ITEM_FDJ+"' ");
		//维修花费
		StringBuffer wx_cost = new StringBuffer()
		.append("select nvl(sum(tmp.human_cost+tmp.material_cost)/10000, 0) as wxcost from (select nvl(info.human_cost, 0) as human_cost,"
				+ " nvl(info.material_cost, 0) as material_cost,info.modifi_date,dui.fk_dev_acc_id as dev_acc_id"
				+ " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id"
				+ " where info.repair_level <> '605'"
				+ " union all"
				+ " select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,info.modifi_date,acc.dev_acc_id"
				+ " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account acc on info.DEVICE_ACCOUNT_ID = acc.dev_acc_id"
				+ " where info.repair_level <> '605') tmp where tmp.dev_acc_id = '"+devId+"'");
		//年度维修花费
		StringBuffer wx_year_cost = new StringBuffer();
		wx_year_cost.append(wx_cost);
		wx_year_cost.append(" and to_char(tmp.modifi_date,'yyyy')=to_char(sysdate,'yyyy') ");
		// 设备基本信息
		String devinfoSql = "select ("+wx_year_cost+") wx_year_cost,("+wx_cost+") wx_cost,("+wx_eng_count+") wx_eng_count,("+wx_year_count+") wx_year_count,("+wxcount+") wx_count,("+by_year_count+") by_year_count,("+bycount+") bycount,("+bycost+") by_cost,("+days+") days,tab3.*,"
				+ " (select nvl(count(*), 0) as per_num "
				+ "   from (select oper.operator_name"
				+ "           from gms_device_equipment_operator oper"
				+ "           left join gms_device_account_dui dui"
				+ "             on oper.device_account_id = dui.dev_acc_id"
				+ "          where oper.bsflag <> '1'"
				+ "            and dui.fk_dev_acc_id = '"+devId+"'"
				+ "         union all"
				+ "         select oper.operator_name"
				+ "          from gms_device_equipment_operator oper"
				+ "           left join gms_device_account acc"
				+ "            on oper.fk_dev_acc_id = acc.dev_acc_id"
				+ "         where oper.bsflag <> '1'"
				+ "           and oper.fk_dev_acc_id ="
				+ "               '"+devId+"') tmp) pre_num,"
				+ "  ("+oper_namesql+") oper_names , "
				+ "  t.*,"
				+ "  (select coding_name"
				+ "     from comm_coding_sort_detail c"
				+ "    where t.using_stat = c.coding_code_id) as using_stat_desc,"
				+ "  (select coding_name"
				+ "     from comm_coding_sort_detail c"
				+ "   where t.tech_stat = c.coding_code_id) as tech_stat_desc,"
				+ " (select org_name"
				+ "     from comm_org_information org"
				+ "    where t.owning_org_id = org.org_id) as owning_org_name_desc,"
				+ "  (select org_name"
				+ "     from comm_org_information org"
				+ "    where t.USAGE_ORG_ID = org.org_id) as usage_org_name_desc,"
				+ "  (select pro.project_name"
				+ "     from gp_task_project pro"
				+ "    where pro.project_info_no = t.project_info_no) as project_name_desc,"
				+ "  d.coding_name as stat_desc"
				+ "  from GMS_DEVICE_ACCOUNT t"
				+ "  left join comm_coding_sort_detail d"
				+ "    on t.account_stat = d.coding_code_id"
				+ "  left join ( select nvl(sum(tmp.mileage_total), 0) as mileage_total,"
				+ "              nvl(sum(tmp.drilling_footage_total), 0) as drilling_footage_total,"
				+ "              nvl(sum(tmp.work_hour_total), 0) as work_hour_total,"
				+ "              dev_acc_id"
				+ "         from (select nvl(info.mileage, 0) as mileage_total,"
				+ "  nvl(info.drilling_footage, 0) as drilling_footage_total,"
				+ "  nvl(info.work_hour, 0) as work_hour_total,"
				+ "  dui.fk_dev_acc_id as dev_acc_id"
				+ "               from gms_device_operation_info info"
				+ "              inner join gms_device_account_dui dui"
				+ "                 on info.dev_acc_id = dui.dev_acc_id"
				+ "             union all"
				+ "             select nvl(info.mileage, 0) as mileage_total,"
				+ " nvl(info.drilling_footage, 0) as drilling_footage_total,"
				+ " nvl(info.work_hour, 0) as work_hour_total,"
				+ " info.dev_acc_id"
				+ "              from gms_device_operation_info info"
				+ "             inner join gms_device_account acc"
				+ "                on info.dev_acc_id = acc.dev_acc_id) tmp"
				+ "     group by dev_acc_id) tab3"
				+ "     on tab3.dev_acc_id=t.dev_acc_id      "
				+ " where t.dev_acc_id = '"+devId+"' ";

		outMsg.setValue("deviceaccMapList", devinfoSql.toString());

		// 运转记录
		String yzjlSql = " select    acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num,row_number() over( order by modify_date desc) as rm ,nvl(sum(tmp.mileage_total), 0) as mileage_total,nvl(sum(tmp.drilling_footage_total), 0) as drilling_footage_total, nvl(sum(tmp.work_hour_total), 0) as work_hour_total,tmp.modify_date";
		yzjlSql += " from (select nvl(info.mileage, 0) as mileage_total,nvl(info.drilling_footage, 0) as drilling_footage_total,nvl(info.work_hour, 0) as work_hour_total,to_char(info.modify_date, 'yyyy') as modify_date,dui.fk_dev_acc_id as dev_acc_id ";
		yzjlSql += " from gms_device_operation_info info inner join gms_device_account_dui dui on info.dev_acc_id = dui.dev_acc_id union all ";
		yzjlSql += " select nvl(info.mileage, 0) as mileage_total,nvl(info.drilling_footage, 0) as drilling_footage_total,nvl(info.work_hour, 0) as work_hour_total,to_char(info.modify_date, 'yyyy') as modify_date,acc.dev_acc_id ";
		yzjlSql += " from gms_device_operation_info info inner join gms_device_account acc on info.dev_acc_id = acc.dev_acc_id ";
		yzjlSql += " ) tmp ,gms_device_account acc1 where tmp.dev_acc_id='"
				+ devId
				+ "' and acc1.dev_acc_id='"
				+ devId
				+ "' group by tmp.modify_date,acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num order by tmp.modify_date desc ";
		outMsg.setValue("yzjllist", yzjlSql);
		// 强制保养记录
		String qzbySql = "select acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num,row_number() over( order by tmp.modifi_date desc) as rm ,nvl(sum(tmp.human_cost), 0) as human_cost,nvl(sum(tmp.material_cost), 0) as material_cost,tmp.modifi_date ";
		qzbySql += " from (select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,dui.fk_dev_acc_id as dev_acc_id ";
		qzbySql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id where info.repair_level='605' ";
		qzbySql += " union all ";
		qzbySql += " select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,acc.dev_acc_id ";
		qzbySql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account acc on info.DEVICE_ACCOUNT_ID = acc.dev_acc_id where info.repair_level='605' ) tmp ,gms_device_account acc1";
		qzbySql += " where tmp.dev_acc_id ='"
				+ devId
				+ "' and acc1.dev_acc_id='"
				+ devId
				+ "' group by tmp.modifi_date ,acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num order by tmp.modifi_date desc ";
		outMsg.setValue("qzbylist", qzbySql);
		// 单机 消耗
		String clxhySql = "select acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num,row_number() over( order by tmp.modifydate desc) as rm ,tmp.modifydate,nvl(sum(tmp.total_charge), 0) total_charge,nvl(sum(tmp.material_amout), 0) material_amout,nvl(sum(tmp.out_num), 0) out_num ";
		clxhySql += " from (select dui.fk_dev_acc_id as dev_acc_id,nvl(info.total_charge, 0) total_charge,nvl(info.material_amout, 0) material_amout,nvl(info.out_num, 0) out_num,to_char(info.create_date, 'yyyy') as modifydate ";
		clxhySql += " from BGP_COMM_DEVICE_REPAIR_DETAIL info left join BGP_COMM_DEVICE_REPAIR_INFO inf on info.repair_info=inf.repair_info inner join gms_device_account_dui dui on inf.device_account_id = dui.dev_acc_id where info.bsflag = '0' ";
		clxhySql += " union all ";
		clxhySql += " select acc.dev_acc_id,nvl(info1.total_charge, 0) total_charge,nvl(info1.material_amout, 0) material_amout,nvl(info1.out_num, 0) out_num,to_char(info1.create_date, 'yyyy') as modifydate ";
		clxhySql += " from BGP_COMM_DEVICE_REPAIR_DETAIL info1 left join BGP_COMM_DEVICE_REPAIR_INFO inf1 on info1.repair_info=inf1.repair_info inner join gms_device_account acc on inf1.device_account_id = acc.dev_acc_id where info1.bsflag = '0' )tmp ,gms_device_account acc1";
		clxhySql += " where tmp.dev_acc_id='"
				+ devId
				+ "' and acc1.dev_acc_id='"
				+ devId
				+ "' group by tmp.modifydate,acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num order by tmp.modifydate desc";
		outMsg.setValue("clxhlist", clxhySql);
		// 设备事故
		String sbsgSql = "select  distinct pro.project_name,row_number() over( order by info.modifi_date desc) as rm,acc.dev_name,acc.asset_coding,info.*,det1.coding_name as accident_properties1,det2.coding_name as accident_grade1,(select  wmsys.wm_concat(p.operator_name) as operator_name  from  gms_device_equipment_operator p ,GMS_DEVICE_ARCHIVE_DETAIL arc where  p.device_account_id = dui.dev_acc_id    and p.entity_id=arc.dev_archive_refid and arc.dev_archive_type='5' and  p.bsflag='0' and dui.project_info_id=p.project_info_id) as operator_name  from BGP_COMM_DEVICE_ACCIDENT_INFO info "
				+ "left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.accident_info_id "
				+ "left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "
				+ "left join gp_task_project pro on arc.project_info_id = pro.project_info_no "
				+ "left join comm_coding_sort_detail det1 on det1.coding_code_id=info.accident_properties "
				+ "left join comm_coding_sort_detail det2  on det2.coding_code_id = info.accident_grade left join gms_device_account_dui dui"
				+ " on acc.dev_acc_id = dui.fk_dev_acc_id   left join gms_device_equipment_operator p  on p.device_account_id = dui.dev_acc_id and p.entity_id=arc.dev_archive_refid and arc.dev_archive_type='5' and  p.bsflag='0' "
				+ "where  arc.dev_archive_type='6' and dui.project_info_id=arc.project_info_id  and  arc.dev_acc_id='"
				+ devId + "'     order by info.modifi_date desc";// arc.dev_archive_type='6'
																	// and
		outMsg.setValue("sbsglist", sbsgSql);
		// 项目维修记录
		String wxjlSql = "select acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num,row_number() over( order by tmp.modifi_date  desc) as rm,nvl(sum(tmp.human_cost), 0) as human_cost,nvl(sum(tmp.material_cost), 0) as material_cost,tmp.modifi_date ";
		wxjlSql += " from (select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,dui.fk_dev_acc_id as dev_acc_id";
		wxjlSql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id where info.repair_level <> '605' ";
		wxjlSql += " union all ";
		wxjlSql += " select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,acc.dev_acc_id ";
		wxjlSql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account acc on info.DEVICE_ACCOUNT_ID = acc.dev_acc_id where info.repair_level <> '605' ) tmp,gms_device_account acc1";
		wxjlSql += " where tmp.dev_acc_id ='"
				+ devId
				+ "' and acc1.dev_acc_id='"
				+ devId
				+ "' group by tmp.modifi_date,acc1.dev_name,acc1.dev_model,acc1.self_num,acc1.license_num order by tmp.modifi_date desc ";
		outMsg.setValue("wxjllist", wxjlSql);
		outMsg.setValue(
				"listname",
				"djlist,prolist,oillist,yzjllist,qzbylist,clxhlist,sbsglist,wxjllist,deviceaccMapList");
		return outMsg;
	}
	/**
	 * 查询设备当前操作人
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public String getDevAccOperInfo(ISrvMsg reqDTO) throws Exception {
		String device_acc_id = reqDTO.getValue("devid");
		String sql="select acc.using_stat from gms_device_account acc where acc.dev_acc_id='"+device_acc_id+"'";
		Map map=jdbcDao.queryRecordBySQL(sql);
		StringBuffer sb1 = new StringBuffer();
		String oper_names = "";
		if(MapUtils.isNotEmpty(map)){
			String usingStat=map.get("using_stat").toString();
			//在项目
			if("0110000007000000001".equals(usingStat)){
				sb1.append("select oper.operator_name from gms_device_equipment_operator oper ")
				.append("left join gms_device_account_dui dui ")
				.append("on oper.device_account_id=dui.dev_acc_id ")
				.append("where oper.bsflag='0' and dui.fk_dev_acc_id='"+device_acc_id+"'");
			}else{//不在项目
				sb1.append("select oper.operator_name from gms_device_equipment_operator oper ")
				.append("left join gms_device_account acc ")
				.append("on oper.fk_dev_acc_id=acc.dev_acc_id ")
				.append("where oper.bsflag='0' and oper.fk_dev_acc_id='"+device_acc_id+"'");
			}
		}
		List<Map> operMapList = this.jdbcDao.queryRecords(sb1.toString());
		if (operMapList != null && operMapList.size() > 0) {
			if (operMapList.size() == 1) {
				oper_names = operMapList.get(0).get("operator_name").toString();
			} else {
				for (Map oper : operMapList) {
					oper_names += oper.get("operator_name") + ",";
				}
				oper_names = oper_names.substring(0,
						oper_names.lastIndexOf(","));
			}
		}
		return oper_names;
	}
	/**
	 * 获得设备存放地数据(测试zTree用，可以删除)
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevZTreeInfo(ISrvMsg msg) throws Exception{
		String posId = msg.getValue("posid");
		System.out.println("posId11111111111111111111111 == ");
		String posSql = "";
		posSql = "select pos_id as id,pos_name as name,pos_level,parent_id,pos_seq,pos_flag"
			   + " from gms_device_position ";
        if(DevUtil.isValueNotNull(posId)){
        	posSql += " where pos_id = '"+posId+"'";	   
		}
		posSql += " order by pos_level, pos_seq, pos_id";
		List list = jdbcDao.queryRecords(posSql.toString());			
		JSONArray retJson = JSONArray.fromObject(list);			
		ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);			
		if(retJson == null){
			outmsg.setValue("json", "[]");
		}else {
			outmsg.setValue("json", retJson.toString());
		}
		System.out.println("outmsg == "+outmsg.toString());
		return outmsg;
	}
	/**
	 * 大港设备返还详情信息导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveBackDetailExcelDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		final String device_detail_rid = reqDTO.getValue("device_detail_rid");
		final String fk_dev_acc_id = reqDTO.getValue("fk_dev_acc_id");
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		List<Map> mapLista = new ArrayList();
		int unfindNum = 0;
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil.getDEVExcelBackDetailDataDgByWSFile(file);
			}
			// 遍历dataList，操作数据库
			for (int i = 0; i < dataList.size(); i++) {
				Map dataMap = (Map) dataList.get(i);
				Map kqMap = new HashMap();
				kqMap.put("device_detail_rid",device_detail_rid);
				kqMap.put("fk_dev_acc_id", fk_dev_acc_id);
				kqMap.put("dev_coding", dataMap.get("dev_coding"));
				kqMap.put("dev_name", dataMap.get("dev_name"));
				kqMap.put("dev_model", dataMap.get("dev_model"));
				kqMap.put("self_num", dataMap.get("self_num"));
				kqMap.put("dev_unit", dataMap.get("dev_unit"));
				kqMap.put("asset_value", dataMap.get("asset_value"));
				kqMap.put("net_value", dataMap.get("net_value"));
				mapLista.add(kqMap);
				StringBuffer querySql = new StringBuffer();
				String dev_coding = dataMap.get("dev_coding")!=null?dataMap.get("dev_coding").toString():"";
				querySql.append("select count(dev_acc_id) from (select b.dev_acc_id,b.dev_coding from gms_device_account_b b union all select acc.dev_acc_id,acc.dev_coding from gms_device_account acc) c where c.dev_coding = '"+dev_coding+"'");
				Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
				if(deviceappMap==null){
					unfindNum++;
				}
			}
			msg.setValue("unfindNum", unfindNum);
			final List<Map> mapList  = mapLista;//批量数据
			if (mapList != null) {
				if(mapList.size()>0){
					String insMixDetSql = "insert into gms_device_collbackapp_det_dg("
							+ "dev_acc_id,device_detail_rid,dev_coding,dev_name,dev_model,"
							+ "self_num,dev_unit,asset_value,net_value,fk_dev_acc_id)values(?,?,?,?,?,?,?,?,?,?)";
					jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							ps.setString(1, jdbcDao.generateUUID());
							ps.setString(2,device_detail_rid);
							ps.setString(3,mapList.get(i).get("dev_coding")!=null?mapList.get(i).get("dev_coding").toString():"");
							ps.setString(4,mapList.get(i).get("dev_name")!=null?mapList.get(i).get("dev_name").toString():"");
							ps.setString(5,mapList.get(i).get("dev_model")!=null?mapList.get(i).get("dev_model").toString():"");
							ps.setString(6,mapList.get(i).get("self_num")!=null?mapList.get(i).get("self_num").toString():"");
							ps.setString(7,mapList.get(i).get("dev_unit")!=null?mapList.get(i).get("dev_unit").toString():"");
							ps.setString(8,mapList.get(i).get("asset_value")!=null?mapList.get(i).get("asset_value").toString():"");
							ps.setString(9,mapList.get(i).get("net_value")!=null?mapList.get(i).get("net_value").toString():"");
							ps.setString(10,mapList.get(i).get("fk_dev_acc_id")!=null?mapList.get(i).get("fk_dev_acc_id").toString():"");
						}
						@Override
						public int getBatchSize() {
							return mapList.size();
						}
					});
				}
			}
		}
		msg.setValue("message", "success");
		return msg;
	}
	/**
	 * 大港设备调拨详情信息导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveMixDetailExcelDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		final String device_detail_rid = reqDTO.getValue("device_detail_rid");
		final String fk_dev_acc_id = reqDTO.getValue("fk_dev_acc_id");
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		List<Map> mapLista = new ArrayList();
		int unfindNum = 0;
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil.getDEVExcelBackDetailDataDgByWSFile(file);
			}
			// 遍历dataList，操作数据库
			for (int i = 0; i < dataList.size(); i++) {
				Map dataMap = (Map) dataList.get(i);
				Map kqMap = new HashMap();
				kqMap.put("device_detail_rid",device_detail_rid);
				kqMap.put("fk_dev_acc_id", fk_dev_acc_id);
				kqMap.put("dev_coding", dataMap.get("dev_coding"));
				kqMap.put("dev_name", dataMap.get("dev_name"));
				kqMap.put("dev_model", dataMap.get("dev_model"));
				kqMap.put("self_num", dataMap.get("self_num"));
				kqMap.put("dev_unit", dataMap.get("dev_unit"));
				kqMap.put("asset_value", dataMap.get("asset_value"));
				kqMap.put("net_value", dataMap.get("net_value"));
				mapLista.add(kqMap);
				StringBuffer querySql = new StringBuffer();
				String dev_coding = dataMap.get("dev_coding")!=null?dataMap.get("dev_coding").toString():"";
				querySql.append("select count(dev_acc_id) from (select b.dev_acc_id,b.dev_coding from gms_device_account_b b union all select acc.dev_acc_id,acc.dev_coding from gms_device_account acc) c where c.dev_coding = '"+dev_coding+"'");
				Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
				if(deviceappMap==null){
					unfindNum++;
				}
			}
			msg.setValue("unfindNum", unfindNum);
			final List<Map> mapList  = mapLista;//批量数据
			if (mapList != null) {
				if(mapList.size()>0){
					String insMixDetSql = "insert into gms_device_appmix_det_dg("
							+ "dev_acc_id,device_detail_rid,dev_coding,dev_name,dev_model,"
							+ "self_num,dev_unit,asset_value,net_value,fk_dev_acc_id)values(?,?,?,?,?,?,?,?,?,?)";
					jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							ps.setString(1, jdbcDao.generateUUID());
							ps.setString(2,device_detail_rid);
							ps.setString(3,mapList.get(i).get("dev_coding")!=null?mapList.get(i).get("dev_coding").toString():"");
							ps.setString(4,mapList.get(i).get("dev_name")!=null?mapList.get(i).get("dev_name").toString():"");
							ps.setString(5,mapList.get(i).get("dev_model")!=null?mapList.get(i).get("dev_model").toString():"");
							ps.setString(6,mapList.get(i).get("self_num")!=null?mapList.get(i).get("self_num").toString():"");
							ps.setString(7,mapList.get(i).get("dev_unit")!=null?mapList.get(i).get("dev_unit").toString():"");
							ps.setString(8,mapList.get(i).get("asset_value")!=null?mapList.get(i).get("asset_value").toString():"");
							ps.setString(9,mapList.get(i).get("net_value")!=null?mapList.get(i).get("net_value").toString():"");
							ps.setString(10,mapList.get(i).get("fk_dev_acc_id")!=null?mapList.get(i).get("fk_dev_acc_id").toString():"");
						}
						@Override
						public int getBatchSize() {
							return mapList.size();
						}
					});
				}
			}
		}
		msg.setValue("message", "success");
		return msg;
	}
	/**查询设备明细信息
	@author zjb
	@since 2016-8-29 16:13:14
	*/
	public ISrvMsg findDevDetail(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		//获取当前页
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String device_detail_rid =msg.getValue("device_detail_rid");
		String dev_acc_id = msg.getValue("dev_acc_id");
		StringBuffer querySql = new StringBuffer();
		String querysgllSql = "select * from gms_device_appmix_det_dg det where 1=1 ";
		if(device_detail_rid!=null&&!"null".equals(device_detail_rid)){
			querysgllSql +="and det.device_detail_rid = '"+device_detail_rid+"'";
		}else{
			querysgllSql +="and 1=2 ";
		}
		page = jdbcDao.queryRecordsBySQL(querysgllSql, page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 大港设备转移详情信息导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveMoveDetailExcelDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		final String device_detail_rid = reqDTO.getValue("device_detail_rid");
		final String fk_dev_acc_id = reqDTO.getValue("fk_dev_acc_id");
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		List<Map> mapLista = new ArrayList();
		int unfindNum = 0;
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil.getDEVExcelBackDetailDataDgByWSFile(file);
			}
			// 遍历dataList，操作数据库
			for (int i = 0; i < dataList.size(); i++) {
				Map dataMap = (Map) dataList.get(i);
				Map kqMap = new HashMap();
				kqMap.put("device_detail_rid",device_detail_rid);
				kqMap.put("fk_dev_acc_id", fk_dev_acc_id);
				kqMap.put("dev_coding", dataMap.get("dev_coding"));
				kqMap.put("dev_name", dataMap.get("dev_name"));
				kqMap.put("dev_model", dataMap.get("dev_model"));
				kqMap.put("self_num", dataMap.get("self_num"));
				kqMap.put("dev_unit", dataMap.get("dev_unit"));
				kqMap.put("asset_value", dataMap.get("asset_value"));
				kqMap.put("net_value", dataMap.get("net_value"));
				mapLista.add(kqMap);
				StringBuffer querySql = new StringBuffer();
				String dev_coding = dataMap.get("dev_coding")!=null?dataMap.get("dev_coding").toString():"";
				querySql.append("select count(dev_acc_id) from (select b.dev_acc_id,b.dev_coding from gms_device_account_b b union all select acc.dev_acc_id,acc.dev_coding from gms_device_account acc) c where c.dev_coding = '"+dev_coding+"'");
				Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
				if(deviceappMap==null){
					unfindNum++;
				}
			}
			msg.setValue("unfindNum", unfindNum);
			final List<Map> mapList  = mapLista;//批量数据
			if (mapList != null) {
				if(mapList.size()>0){
					String insMixDetSql = "insert into gms_device_move_detail_dg("
							+ "dev_acc_id,device_detail_rid,dev_coding,dev_name,dev_model,"
							+ "self_num,dev_unit,asset_value,net_value,fk_dev_acc_id)values(?,?,?,?,?,?,?,?,?,?)";
					jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							ps.setString(1, jdbcDao.generateUUID());
							ps.setString(2,device_detail_rid);
							ps.setString(3,mapList.get(i).get("dev_coding")!=null?mapList.get(i).get("dev_coding").toString():"");
							ps.setString(4,mapList.get(i).get("dev_name")!=null?mapList.get(i).get("dev_name").toString():"");
							ps.setString(5,mapList.get(i).get("dev_model")!=null?mapList.get(i).get("dev_model").toString():"");
							ps.setString(6,mapList.get(i).get("self_num")!=null?mapList.get(i).get("self_num").toString():"");
							ps.setString(7,mapList.get(i).get("dev_unit")!=null?mapList.get(i).get("dev_unit").toString():"");
							ps.setString(8,mapList.get(i).get("asset_value")!=null?mapList.get(i).get("asset_value").toString():"");
							ps.setString(9,mapList.get(i).get("net_value")!=null?mapList.get(i).get("net_value").toString():"");
							ps.setString(10,mapList.get(i).get("fk_dev_acc_id")!=null?mapList.get(i).get("fk_dev_acc_id").toString():"");
						}
						@Override
						public int getBatchSize() {
							return mapList.size();
						}
					});
				}
			}
		}
		msg.setValue("message", "success");
		return msg;
	}
	/**查询设备明细信息
	@author zjb
	@since 2016-8-29 16:13:14
	*/
	public ISrvMsg findMoveDevDetail(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		//获取当前页
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String device_detail_rid =msg.getValue("device_detail_rid");
		String dev_acc_id = msg.getValue("dev_acc_id");
		StringBuffer querySql = new StringBuffer();
		String querysgllSql = "select * from gms_device_move_detail_dg det where 1=1 ";
		if(device_detail_rid!=null&&!"null".equals(device_detail_rid)){
			querysgllSql +="and det.device_detail_rid = '"+device_detail_rid+"'";
		}else{
			querysgllSql +="and 1=2 ";
		}
		page = jdbcDao.queryRecordsBySQL(querysgllSql, page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 获得外租设备类别信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireDevClass(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String sql = "select coding_name,coding_code_id from comm_coding_sort_detail"
			       + " where coding_sort_id='5110000210' order by coding_show_id ";
		List<Map> modelList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", modelList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 接收外租设备信息显示
	 * zjb
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireMainInfoNew(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectName = msg.getValue("projectname");
		String hireAppName = msg.getValue("hireappname");
		String hiredevclass = msg.getValue("hiredevclass");//外租设备类别
		String proOrgName = msg.getValue("proorgname");
		String appOrgId = msg.getValue("apporgid");
		String viewFlag = msg.getValue("viewflag");//Y:查看单据     N:调配
		String device_type = msg.getValue("device_type");//设备类别0：单台1：检波器2：地震仪器
		if(StringUtils.isEmpty(viewFlag)){
			viewFlag = "N";
		}
		String projectNo = msg.getValue("projectno");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,"
				+ " case when length(dev.project_name) > 16 then substr(dev.project_name, 0, 16) || '...'"
				+ " else dev.project_name end as proname,"
				+ " case when length(dev.device_hireapp_name) > 16 then substr(dev.device_hireapp_name, 0, 16) || '...'"
				+ " else dev.device_hireapp_name end as hireappname,dev.*"
				+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,mix.device_hireapp_id,"
				+ " mix.device_hireapp_no,mix.device_hireapp_name,sub.org_subjection_id,mix.appdate,"
				+ " mix.employee_id,mix.modifi_date,mix.state,org.org_abbreviation as org_name,mix.project_info_no,"
				+ " case mix.mix_type_id"
				+ " when '5110000184000000002' then '外租单台'"
				+ " when '5110000184000000003' then '外租检波器'"
				+ " end as mixtypename,mix.mix_type_id,"
				+ " case mix.mix_class_id"
				+ " when '5110000210000000001' then '一体化设备'"
				+ " when '5110000210000000002' then '装备设备'"
				+ " when '5110000210000000003' then '社会设备'"
				+ " end as mixclassname,mix.mix_class_id,"
				+ " mix.org_id,emp.employee_name,case mix.state when '1' then '已提交' else '未提交' end as state_desc,"
				+ " case"
				+ " when sub.org_subjection_id like 'C105001005%' then '塔里木物探处'"
				+ " when sub.org_subjection_id like 'C105001002%' then '新疆物探处'"
				+ " when sub.org_subjection_id like 'C105001003%' then '吐哈物探处'"
				+ " when sub.org_subjection_id like 'C105001004%' then '青海物探处'"
				+ " when sub.org_subjection_id like 'C105005004%' then '长庆物探处'"
				+ " when sub.org_subjection_id like 'C105005000%' then '华北物探处'"
				+ " when sub.org_subjection_id like 'C105005001%' then '新兴物探开发处'"
				+ " when sub.org_subjection_id like 'C105007%' then '大港物探处'"
				+ " when sub.org_subjection_id like 'C105063%' then '辽河物探处'"
				+ " when sub.org_subjection_id like 'C105086%' then '深海物探处'"
				+ " when sub.org_subjection_id like 'C105008%' then '综合物化处'"
				+ " when sub.org_subjection_id like 'C105002%' then '国际勘探事业部'"
				+ " else info.org_abbreviation end as pro_sub_name,"
				+ " mix.device_type"
				+ " from gms_device_hireapp mix"
				+ " left join comm_org_information org on mix.org_id = org.org_id and org.bsflag = '0'"
				+ " left join comm_human_employee emp on mix.employee_id = emp.employee_id and emp.bsflag = '0' "
				+ " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
				+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = mix.org_id and sub.bsflag = '0'"
				+ " where mix.bsflag = '0' and mix.state is not null and mix.opr_state is not null");		
		if("Y".equals(viewFlag)){//查看调配单
			querySql.append(" ) dev where 1 = 1");
		}else{
			querySql.append(" and mix.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%') dev where 1 = 1");
		}
		//项目名称
		if (StringUtils.isNotBlank(projectName)) {
			querySql.append(" and project_name like '%"+projectName+"%'");
		}
		//申请单名称
		if (StringUtils.isNotBlank(hireAppName)) {
			querySql.append(" and device_hireapp_name like '%"+hireAppName+"%'");
		}
		//外租类型
		if (StringUtils.isNotBlank(hiredevclass)) {
			querySql.append(" and mix_class_id = '"+hiredevclass+"'");
		}
		//项目所属单位
		if (StringUtils.isNotBlank(proOrgName)) {
			querySql.append(" and dev.pro_sub_name || '-' || dev.dui_org_name like '%"+proOrgName+"%'");
		}
		//调配单位名称
		if (StringUtils.isNotBlank(appOrgId)) {
			querySql.append(" and org_subjection_id like '%"+appOrgId+"%'");
		}
		//项目编号
		if (StringUtils.isNotBlank(projectNo)) {
			querySql.append(" and project_info_no like '%"+projectNo+"%'");
		}
		//外租类型
		if (StringUtils.isNotBlank(device_type)) {
			querySql.append(" and device_type = '"+device_type+"'");
		}
		querySql.append(" order by state nulls first,modifi_date desc,org_id,project_info_no ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 接收外租设备主表信息显示
	 * zjb
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireDevBaseInfoNew(ISrvMsg msg) throws Exception {
		String hireAppId = msg.getValue("devicehireappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,"
					+ " case when length(dev.project_name) > 16 then substr(dev.project_name, 0, 16) || '...'"
					+ " else dev.project_name end as proname,"
					+ " case when length(dev.device_hireapp_name) > 16 then substr(dev.device_hireapp_name, 0, 16) || '...'"
					+ " else dev.device_hireapp_name end as hireappname,dev.*"
					+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,mix.device_hireapp_id,"
					+ " mix.device_hireapp_no,mix.device_hireapp_name,sub.org_subjection_id,mix.appdate,"
					+ " mix.employee_id,mix.modifi_date,mix.state,org.org_abbreviation as org_name,mix.project_info_no,"
					+ " case mix.mix_type_id"
					+ " when '5110000184000000002' then '外租单台'"
					+ " when '5110000184000000003' then '外租检波器'"
					+ " end as mixtypename,mix.mix_type_id,"
					+ " case mix.mix_class_id"
					+ " when '5110000210000000001' then '一体化设备'"
					+ " when '5110000210000000002' then '装备设备'"
					+ " when '5110000210000000003' then '社会设备'"
					+ " end as mixclassname,mix.mix_class_id,"
					+ " mix.org_id,emp.employee_name,case mix.state when '1' then '已提交' else '未提交' end as state_desc,"
					+ " case"
					+ " when sub.org_subjection_id like 'C105001005%' then '塔里木物探处'"
					+ " when sub.org_subjection_id like 'C105001002%' then '新疆物探处'"
					+ " when sub.org_subjection_id like 'C105001003%' then '吐哈物探处'"
					+ " when sub.org_subjection_id like 'C105001004%' then '青海物探处'"
					+ " when sub.org_subjection_id like 'C105005004%' then '长庆物探处'"
					+ " when sub.org_subjection_id like 'C105005000%' then '华北物探处'"
					+ " when sub.org_subjection_id like 'C105005001%' then '新兴物探开发处'"
					+ " when sub.org_subjection_id like 'C105007%' then '大港物探处'"
					+ " when sub.org_subjection_id like 'C105063%' then '辽河物探处'"
					+ " when sub.org_subjection_id like 'C105086%' then '深海物探处'"
					+ " when sub.org_subjection_id like 'C105008%' then '综合物化处'"
					+ " when sub.org_subjection_id like 'C105002%' then '国际勘探事业部'"
					+ " else info.org_abbreviation end as pro_sub_name,"
					+ " mix.device_type"
					+ " from gms_device_hireapp mix"
					+ " left join comm_org_information org on mix.org_id = org.org_id and org.bsflag = '0'"
					+ " left join comm_human_employee emp on mix.employee_id = emp.employee_id and emp.bsflag = '0' "
					+ " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
					+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
					+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
					+ " left join comm_org_subjection sub on sub.org_id = mix.org_id and sub.bsflag = '0'"
					+ " where mix.device_hireapp_id = '"+hireAppId+"') dev");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("mixMap", mixMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 接收外租设备明细信息
	 * zjb
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHireAppDetNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String hireAppId = msg.getValue("hireappid");
		String sql = "select det.device_detail_rid,l.coding_name as teamname,det.dev_name,det.dev_type,d.coding_name as unitname,"
				   + " det.apply_num,det.devrental,det.rentname,det.plan_start_date,det.plan_end_date,"
				   + " det.purpose,case det.state when '1' then '已接收' when '2' then '接收中' else '未接收' end as statedesc"
				   + " from gms_device_hireapp_detail det"
				   + " left join comm_coding_sort_detail l on det.team = l.coding_code_id"
				   + " left join comm_coding_sort_detail d on d.coding_code_id = det.unitinfo "
				   + " where det.device_hireapp_id = '"+hireAppId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 接收外租设备修改操作获得申请单信息
	 * zjb
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireMainInfoNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String hireAppId = msg.getValue("hireappid");
		StringBuffer sb = new StringBuffer()
			.append( "select pro.project_name,app.project_info_no,app.device_hireapp_no,app.device_hireapp_id,"
					  + " app.device_hireapp_name,emp.employee_name,app.employee_id,app.appdate,pro.project_type,"
					  + " app.mix_type_id,app.mix_class_id,app.app_org_id,app.device_type from gms_device_hireapp app"
					  + " left join gp_task_project pro on pro.project_info_no = app.project_info_no"
					  + " left join comm_human_employee emp on app.employee_id = emp.employee_id and emp.bsflag = '0'"
				      + " where app.device_hireapp_id = '"+hireAppId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 接收外租设备修改操作获得申请单明细信息
	 * zjb
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHireDevDetInfoNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String hireAppId = msg.getValue("hireappid");
		String sql = "select det.team,det.dev_name,det.dev_type,det.unitinfo,det.apply_num,"
			   	   + " det.devrental,det.rentname,det.plan_start_date,det.plan_end_date,det.purpose"
			       + " from gms_device_hireapp_detail det"
			       + " where det.device_hireapp_id = '"+hireAppId+"' ";
		List<Map> addedList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", addedList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 删除、修改接收外租单台、检波器设备单据状态判断
	 * zjb
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opHireDevInfoNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String userSubOrg = user.getOrgSubjectionId();
		String delFlag = "0";
		String mixState = "";
		String hireAppId = msg.getValue("hireappid");
		String opFlag = msg.getValue("opflag");
		try{
			String appSql = "select mix.state from gms_device_hireapp mix"
						  + " where mix.device_hireapp_id = '"+hireAppId+"' ";
			Map mixMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(mixMap)){
				mixState = mixMap.get("state").toString();
				if("1".equals(mixState)){
					delFlag = "1";//已提交的单据不能删除/修改/提交
				}else{
					if("tj".equals(opFlag)){						
						if(!userSubOrg.startsWith("C105001005")&&//塔里木物探处
								!userSubOrg.startsWith("C105001002")&&//新疆物探处
								!userSubOrg.startsWith("C105001003")&&//吐哈物探处
								!userSubOrg.startsWith("C105001004")&&//青海物探处
								!userSubOrg.startsWith("C105005004")&&//长庆物探处
								!userSubOrg.startsWith("C105005000")&&//华北物探处
								!userSubOrg.startsWith("C105005001")&&//新兴物探处
								!userSubOrg.startsWith("C105007")&&//大港物探处
								!userSubOrg.startsWith("C105063")&&//辽河物探处
								!userSubOrg.startsWith("C105008")&&//综合物化处
								!userSubOrg.startsWith("C105002")&&//国际勘探事业部
								!userSubOrg.startsWith("C105086")){//深海物探处
							delFlag = "4";//用户所在单位不能提交单据	
						}else{
							String delSql = "update gms_device_hireapp"
										  + " set state='1',"
										  + " updator_id='"+user.getEmpId()+"',"
										  + " modifi_date = sysdate"
										  + " where device_hireapp_id='"+hireAppId+"'";
							jdbcDao.executeUpdate(delSql);
						}
					}else if("del".equals(opFlag)){
						String delSql = "update gms_device_hireapp"
									  + " set bsflag = '1',"
									  + " updator_id = '"+user.getEmpId()+"',"
									  + " modifi_date = sysdate"
									  + " where device_hireapp_id='"+hireAppId+"'";
						jdbcDao.executeUpdate(delSql);
						String delDetSql = "update gms_device_hireapp_detail"
										 + " set bsflag = '1'"
										 + " where device_hireapp_id='"+hireAppId+"'";
						jdbcDao.executeUpdate(delDetSql);
					}
				}
			}else{
				delFlag = "3";//删除/提交/修改失败
			}
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除/提交/修改失败
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 接收外租设备保存
	 * zjb
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateHireDevInfoNew(ISrvMsg msg) throws Exception {
		
		UserToken user = msg.getUserToken();
		String hireAppId = wtcDevSrv.saveHireDevAppNew(msg);
		String employeeId = msg.getValue("employee_id");
		String projectInfoNo = msg.getValue("projectInfoNo");

		String delSql = "delete from gms_device_hireapp_detail where device_hireapp_id = '"
					  + hireAppId + "'";
		jdbcDao.executeUpdate(delSql);
		
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < lineinfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[index];
			dataMap.put("device_hireapp_id", hireAppId);
			dataMap.put("project_info_no", projectInfoNo);
			dataMap.put("team", msg.getValue("team" + keyid));
			dataMap.put("apply_num", msg.getValue("neednum" + keyid));
			dataMap.put("purpose", msg.getValue("purpose" + keyid));
			dataMap.put("plan_start_date", msg.getValue("startdate" + keyid));
			dataMap.put("plan_end_date", msg.getValue("enddate" + keyid));
			dataMap.put("employee_id", employeeId);
			dataMap.put("unitinfo", msg.getValue("unit" + keyid));
			dataMap.put("devrental", msg.getValue("devrental" + keyid));
			dataMap.put("rentname", msg.getValue("rentname" + keyid));
			dataMap.put("dev_name", msg.getValue("devicename" + keyid));
			dataMap.put("dev_type", msg.getValue("devicetype" + keyid));
			dataMap.put("device_detail_rid", msg.getValue("device_detail_rid"+keyid));
			datasList.add(dataMap);
		}
		String insMixDetSql = "insert into gms_device_hireapp_detail(device_app_detid,device_hireapp_id,project_info_no,team,"
							+ " apply_num,purpose,plan_start_date,plan_end_date,employee_id,create_date,unitinfo,bsflag,devrental,"
							+ " rentname,state,dev_name,dev_type,device_detail_rid)"
							+ " values(?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),?,to_date(?,'yyyy-mm-dd hh24:mi:ss'),?,?,?,?,?,?,?,?)";
		jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> devSaveMap = datasList.get(i);
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) devSaveMap.get("device_hireapp_id"));
						ps.setString(3, (String) devSaveMap.get("project_info_no"));
						ps.setString(4, (String) devSaveMap.get("team"));
						ps.setString(5, (String) devSaveMap.get("apply_num"));
						ps.setString(6, (String) devSaveMap.get("purpose"));
						ps.setString(7, (String) devSaveMap.get("plan_start_date"));
						ps.setString(8, (String) devSaveMap.get("plan_end_date"));
						ps.setString(9, (String) devSaveMap.get("employee_id"));
						ps.setString(10, DevUtil.getCurrentTime());
						ps.setString(11, (String) devSaveMap.get("unitinfo"));
						ps.setString(12, DevConstants.STATE_SAVED);
						ps.setString(13, (String) devSaveMap.get("devrental"));
						ps.setString(14, (String) devSaveMap.get("rentname"));
						ps.setString(15, DevConstants.DEVRECEIVE);					
						ps.setString(16, (String) devSaveMap.get("dev_name"));
						ps.setString(17, (String) devSaveMap.get("dev_type"));
						ps.setString(18, (String) devSaveMap.get("device_detail_rid"));
					}
					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 大港设备调拨详情信息导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveRevDetailExcelDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		final String device_detail_rid = reqDTO.getValue("device_detail_rid");
		final String fk_dev_acc_id = reqDTO.getValue("fk_dev_acc_id");
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		List<Map> mapLista = new ArrayList();
		int unfindNum = 0;
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil.getDEVExcelBackDetailDataDgByWSFile(file);
			}
			// 遍历dataList，操作数据库
			for (int i = 0; i < dataList.size(); i++) {
				Map dataMap = (Map) dataList.get(i);
				Map kqMap = new HashMap();
				kqMap.put("device_detail_rid",device_detail_rid);
				kqMap.put("fk_dev_acc_id", fk_dev_acc_id);
				kqMap.put("dev_coding", dataMap.get("dev_coding"));
				kqMap.put("dev_name", dataMap.get("dev_name"));
				kqMap.put("dev_model", dataMap.get("dev_model"));
				kqMap.put("self_num", dataMap.get("self_num"));
				kqMap.put("dev_unit", dataMap.get("dev_unit"));
				kqMap.put("asset_value", dataMap.get("asset_value"));
				kqMap.put("net_value", dataMap.get("net_value"));
				mapLista.add(kqMap);
			}
			msg.setValue("unfindNum", unfindNum);
			final List<Map> mapList  = mapLista;//批量数据
			if (mapList != null) {
				if(mapList.size()>0){
					String insMixDetSql = "insert into gms_device_hireapp_det_dg("
							+ "dev_acc_id,device_detail_rid,dev_coding,dev_name,dev_model,"
							+ "self_num,dev_unit,asset_value,net_value,fk_dev_acc_id)values(?,?,?,?,?,?,?,?,?,?)";
					jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							ps.setString(1, jdbcDao.generateUUID());
							ps.setString(2,device_detail_rid);
							ps.setString(3,mapList.get(i).get("dev_coding")!=null?mapList.get(i).get("dev_coding").toString():"");
							ps.setString(4,mapList.get(i).get("dev_name")!=null?mapList.get(i).get("dev_name").toString():"");
							ps.setString(5,mapList.get(i).get("dev_model")!=null?mapList.get(i).get("dev_model").toString():"");
							ps.setString(6,mapList.get(i).get("self_num")!=null?mapList.get(i).get("self_num").toString():"");
							ps.setString(7,mapList.get(i).get("dev_unit")!=null?mapList.get(i).get("dev_unit").toString():"");
							ps.setString(8,mapList.get(i).get("asset_value")!=null?mapList.get(i).get("asset_value").toString():"");
							ps.setString(9,mapList.get(i).get("net_value")!=null?mapList.get(i).get("net_value").toString():"");
							ps.setString(10,mapList.get(i).get("fk_dev_acc_id")!=null?mapList.get(i).get("fk_dev_acc_id").toString():"");
						}
						@Override
						public int getBatchSize() {
							return mapList.size();
						}
					});
				}
			}
		}
		msg.setValue("message", "success");
		return msg;
	}
	/**查询接收外租设备明细信息
	@author zjb
	@since 2016-8-29 16:13:14
	*/
	public ISrvMsg findHireRevDevDetail(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		//获取当前页
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String device_detail_rid =msg.getValue("device_detail_rid");
		String dev_acc_id = msg.getValue("dev_acc_id");
		StringBuffer querySql = new StringBuffer();
		String querysgllSql = "select * from gms_device_hireapp_det_dg det where 1=1 ";
		if(device_detail_rid!=null&&!"null".equals(device_detail_rid)){
			querysgllSql +="and det.device_detail_rid = '"+device_detail_rid+"'";
		}else{
			querysgllSql +="and 1=2 ";
		}
		page = jdbcDao.queryRecordsBySQL(querysgllSql, page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 登陆页面判断用户旧密码是否正确
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkHomeUserPassWord(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String loginId = msg.getValue("loginid");
		String userPwd = msg.getValue("userpwd");
		loginId=RSAUtils.decode(loginId, RSAUtils.PRIVATE_KEY);//RAS 私钥解密
		userPwd=RSAUtils.decode(userPwd, RSAUtils.PRIVATE_KEY);//RAS 私钥解密
	 
		String opFlag = "0";
		try {
			String userSql = "select user_pwd from p_auth_user where bsflag = '0' and login_id = '"+loginId+"'";
			Map userMap = jdbcDao.queryRecordBySQL(userSql);
			if(MapUtils.isNotEmpty(userMap)){
				Object userOldPwd = userMap.get("user_pwd");
				String checkPwd = PasswordUtil.encrypt(userPwd);			
				if (!checkPwd.equals(userOldPwd)){
					opFlag = "1";// 旧密码不匹配
				}else{
					if((checkPwd.equals(userOldPwd)&&DevUtil.isValidPassword(userPwd)) 
						|| (checkPwd.equals(userOldPwd)&&DevUtil.isValueNotNull(loginId, DevConstants.COMM_USER_SUPERADMIN))){
						opFlag = "2";// 密码匹配且符合规则/密码匹配且用户为超级管理员
					}else{
						opFlag = "4";// 密码匹配但不符合规则
					}			
				}
			}else{
				opFlag = "5";// 用户不存在
			}			
		} catch (Exception e) {
			opFlag = "3";// 操作失败
		}
		responseDTO.setValue("datas", opFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 登陆页面更新用户密码
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateHomePassWord(ISrvMsg msg) throws Exception {
		String loginId = msg.getValue("loginid");
		String newPwd = msg.getValue("password");
		String upSql = "update p_auth_user"
					 + " set user_pwd = '"+PasswordUtil.encrypt(newPwd)+"'" 
					 + " where bsflag = '0' and login_id = '"+loginId+"'";
		jdbcDao.executeUpdate(upSql);
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("errorMsg", "密码修改成功，重新登录后新密码生效！");
		return responseDTO;
	}
}

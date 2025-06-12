package com.bgp.gms.service.rm.dm;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

/**
 * 设备后台流程管理类
 * @author wangzheqin 2015.6.8
 */
@Service("DevProSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevProSrv extends BaseService {
	
	public DevProSrv() {
		log = LogFactory.getLogger(DevProSrv.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();


	
	/**
	 * 设备返还保存
	 * @param msg
	 * @return null
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateDevBackApp(ISrvMsg msg) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String backDevType = msg.getValue("backdevtype");
		String backMixOrgId = user.getTeamOrgId();
		String projectType= user.getProjectType();
		
		//如果不是S0000自由设备,S9998大港调剂收工验收,则返还调配单位为设备物资科
		if(backDevType!=null && !"S0000".equals(backDevType) && !"S9998".equals(backDevType)){
			backMixOrgId = DevConstants.MIXTYPE_ZHUANGBEI_ORGID;
		}
		Map map = new HashedMap();
		Date date = new Date();//当前时间
		String searchBackappId = UUID.randomUUID().toString().replaceAll("-", "");
		String backDate = msg.getValue("backdate");
		String deviceBackappNo = "返还申请"+backDate.replace("-","")+"0"+Math.round(Math.random()*1000);
		
		map.put("device_backapp_id",msg.getValue("device_backapp_id"));         //返还单ID
		map.put("device_backapp_no", deviceBackappNo);							//返还单号
		map.put("project_info_id", projectInfoNo);								//项目ID
		map.put("back_org_id", user.getTeamOrgId());							//返还单位
		map.put("back_employee_id", msg.getValue("back_employee_id"));			//申请人ID
		map.put("backdate", msg.getValue("backdate"));						    //申请时间
		map.put("backmix_org_id", backMixOrgId);								//返还调配单位
		map.put("bsflag", "0");													//删除标识
		map.put("create_date", date);											//创建日期
		map.put("creator_id", user.getEmpId());									//创建人
		map.put("modifi_date",date);											//修改时间
		map.put("updator_id", user.getEmpId());									//修改人
		map.put("org_id", user.getOrgId());										//返还操作人组织机构Id
		map.put("org_subjection_id", user.getOrgSubjectionId());				//返还操作人组织机构隶属ID
		map.put("state", "0");													//申请单状态,0未提交
		map.put("search_backapp_id", searchBackappId);							//查询主键字段
		map.put("backapp_name", msg.getValue("backappname"));					//返还单名称
		map.put("backdevtype", backDevType);									//返还类型
		//map.put("backmix_username", msg.getValue("backmix_username"));		//返还调配人
		map.put("backapptype", "1");											//处理状态
		//可控震源返还默认接收单位为震源中心
		if(DevConstants.MIXTYPE_ZHENYUAN.equals(backDevType)){
			map.put("receive_org_id", DevConstants.MIXTYPE_ZHUANGBEI_ZY_ORGID);		//接收单位ID
		}else{
			map.put("receive_org_id", msg.getValue("receive_org_id"));				//接收单位ID
		}
		
		Serializable backAppId =  jdbcDao.saveOrUpdateEntity(map, "gms_device_backapp");
		
		//返还单位
		String out_org_id = msg.getValue("out_org_id");
		String devbackmixid ="";
		String devicebackappid ="";
		//判断此项目是否是综合物化探的项目
		//是，省略调配阶段
		if(projectType.equals("5000100004000000009")){	
			Map<String,Object> mainMap = new HashMap<String,Object>();
			//对应的返还单信息
			String device_backapp_id = backAppId.toString();
			//新增之前先要删掉之前调配的数据
			jdbcDao.executeUpdate("delete from gms_device_backinfo_form where bsflag='0' and device_backapp_id='"+devicebackappid+"' ");
			//向map中添加新增数据
			mainMap.put("device_backapp_id", device_backapp_id);
			mainMap.put("backmixinfo_no", deviceBackappNo);
			mainMap.put("state", "9");
			//当前登录用户的ID
			String employee_id = user.getEmpId();
			mainMap.put("print_emp_id", employee_id);
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
			mainMap.put("modifi_date", currentdate);
			mainMap.put("updator_id", employee_id);
			mainMap.put("create_date", currentdate);
			mainMap.put("creator_id", employee_id);
			mainMap.put("project_info_no", user.getProjectInfoNo());
			//删除标记
			mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			//保存ORG的信息
			mainMap.put("org_id", user.getCodeAffordOrgID());
			mainMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			Serializable devBackInfo = jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_backinfo_form");
			devbackmixid = devBackInfo.toString();
			device_backapp_id = backAppId.toString();
		}else{
			devicebackappid = backAppId.toString();
		}
		//先删子表，在插入新的子表
		jdbcDao.executeUpdate("delete from gms_device_backapp_detail where bsflag='0' and device_backapp_id='"+devicebackappid+"' ");
		
		//将本次子表的信息保存进去
		String idinfo = msg.getValue("idinfos");
		String[] idinfos = idinfo.split("~" , -1);
		String enddateinfo = msg.getValue("enddateinfo");
		String[] enddateinfos = enddateinfo.split("~",-1);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		List<Map<String,Object>> dataList = new ArrayList<Map<String,Object>>();
		for(int index=0;index<idinfos.length;index++){
			String devdetSql = "select account.dev_acc_id,account.asset_coding, ";
			devdetSql += "account.dev_coding,account.self_num,account.dev_sign, ";
			devdetSql += "account.license_num,account.planning_out_time ";
			devdetSql += "from gms_device_account_dui account ";
			devdetSql += "where account.dev_acc_id ='"+idinfos[index]+"' " ;
			devdetSql += "and account.project_info_id='"+projectInfoNo+"' ";
			Map<String,Object> datainfo = jdbcDao.queryRecordBySQL(devdetSql);
			datainfo.put("device_backapp_id", devicebackappid);
			datainfo.put("device_mixinfo_id", devbackmixid);
			//2013-02-01 作为实际的离场时间 --没有actual_out_time 字段，使用actual_in_time
			datainfo.put("actual_in_time", enddateinfos[index]);
			datainfo.put("bsflag", DevConstants.BSFLAG_NORMAL);
			//20150707新增create_date, CREATOR_ID
			datainfo.put("create_date", currentdate);
			datainfo.put("creator", user.getEmpId());
			dataList.add(datainfo);
		}
		//循环保存子表
		for(Map<String,Object> datamap : dataList){
			
			jdbcDao.saveOrUpdateEntity(datamap, "gms_device_backapp_detail");
		}

		return responseDTO;
	} 
	
	/**
	 * 根据项目编号查询项目组织机构ID,返回对应的作业部orgId
	 * @param msg
	 * @return 项目所在物探处对应的装备作业部orgId
	 * @throws Exception
	 */
	public ISrvMsg findProjectOrgSubIdByProNo(ISrvMsg msg) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg); 
		//项目编号
		String projectInfoNo = msg.getValue("projectInfoNo");
		StringBuffer sb = new StringBuffer();
		//remark 项目中可能存在多队伍项目,所以截取到物探处,作去重处理
		sb.append("select distinct case when (t.org_subjection_id like 'C105001%' or t.org_subjection_id like 'C105005%') then substr(t.org_subjection_id,0,10) ")
		  .append("else substr(t.org_subjection_id,0,7) end as org_sub_id from Gp_Task_Project_Dynamic t where t.bsflag='0' and t.project_info_no = '").append(projectInfoNo).append("'");
		
		//项目对应的物探处组织机构
		Map idMap = jdbcDao.queryRecordBySQL(sb.toString());		
		//所在项目对应的验收作业部
		String checkOrgId = "";
		
		if(idMap != null){
			String orgSubId = idMap.get("org_sub_id").toString();
			//塔里木--塔里木作业部
			if("C105001005".equals(orgSubId)){
				checkOrgId = "C6000000005551";
			}
			//新疆物探处--北疆作业部
			else if("C105001002".equals(orgSubId)){
				checkOrgId = "C6000000005538";
			}
			//吐哈物探处--吐哈作业部
			else if("C105001003".equals(orgSubId)){
				checkOrgId = "C6000000005555";
			}
			//青海物探处--敦煌作业部
			else if("C105001004".equals(orgSubId)){
				checkOrgId = "C6000000005543";
			}
			//长庆物探处--长庆作业部
			else if("C105005004".equals(orgSubId)){
				checkOrgId = "C6000000005534";
			}
			//辽河物探处--辽河作业部
			else if("C105063".equals(orgSubId)){
				checkOrgId = "C6000000007537";
			}
			//华北物探处--华北作业部
			else if("C105005000".equals(orgSubId)){
				checkOrgId = "C6000000005547";
			}
			//新兴物探处--新区作业部
			else if("C105005001".equals(orgSubId)){
				checkOrgId = "C6000000005560";
			}
			//大港物探处--测量服务中心大港作业分部
			else if("C105007".equals(orgSubId)){
				checkOrgId = "C6000000005532";
			}
		}
		//写入信息
		responseDTO.setValue("checkOrgId", checkOrgId);
		return responseDTO;
	}

	/**
	 * 方法名：getjbqCollectDeviceInfoNew
	 * 功能：生成检波器批量树的异步数据查询
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollectjbqDeviceInfoNew(ISrvMsg msg) throws Exception{
		String nodeid = msg.getValue("node");
		DeviceMCSBean deviceBean = new DeviceMCSBean();
		//1. 第一次进来
		if ("root".equals(nodeid)) {
			//查询根节点
			String sql = "select '~~0~0' as id,'false' as leaf,'批量设备编码树' as name,'' as code,0 as is_leaf,0 as node_level from dual ";
			
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
			String sql = "select device_id||'~'||dev_code||'~'||node_level||'~'||is_leaf as id,"+
						"case is_leaf when 0 then 'false' else 'true' end as leaf, "+
						"case when is_leaf=0 then dev_name else dev_name||'('||dev_model||')' end as name,dev_code as code,"+
						"is_leaf,node_level from gms_device_collectinfo ";
			//共有四个信息，按顺序分别是 device_id dev_code node_level is_leaf
			String[] keyinfos = nodeid.split("~",-1);
			
			if(keyinfos[0]!=null&&!"".equals(keyinfos[0])){
				sql += "where node_parent_id='"+keyinfos[0]+"' ";
			}else {
				sql += "where (dev_code='04' or dev_code='06' )  and node_parent_id is null ";
			}
			
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
	 * 设备入库明细提交操作zjt
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	
	@SuppressWarnings("null")
	public ISrvMsg saveEqDevRStock(ISrvMsg msg) throws Exception {
		DeviceMCSBean devbean = new DeviceMCSBean();

		Connection connection = jdbcDao.getDataSource().getConnection();
		Statement stmt = connection.createStatement();
		String device_backdet_id = msg.getValue("device_backdet_id");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		if (device_backdet_id != null) {
			String[] orders = device_backdet_id.split(",");
			for (int i = 0; i < orders.length; i++) {

				String querySql = "select backdet.*,dui.dev_acc_id,dui.fk_dev_acc_id,app.receive_org_id,acc.owning_org_id," 
								+ "dui.project_info_id from gms_device_backapp_detail backdet "
								+ "left join gms_device_account_dui dui on backdet.dev_acc_id = dui.dev_acc_id and dui.bsflag = '0' "
								+ "left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag = '0' "
								+ "left join gms_device_backapp app on backdet.device_backapp_id = app.device_backapp_id and app.bsflag = '0' "
								+ "where backdet.bsflag = '0' and backdet.device_backdet_id = '" + orders[i] + "' ";
				System.out.println("querySql == "+querySql);
				Map queryMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
						querySql);
				if (queryMap != null) {

					String devaccIdDui = (String) queryMap.get("devAccId");
					String devaccId = (String) queryMap.get("fkDevAccId");
					String projectInfoNo = (String) queryMap.get("projectInfoId");
					String devicebackappid = (String) queryMap.get("deviceBackappId");
					String receiveorgid = (String) queryMap.get("receiveOrgId");
					String owningorgid = (String) queryMap.get("owningOrgId");
					String actual_out_date = msg.getValue("actual_out_date");
					String dev_position = msg.getValue("dev_position");
					String province = msg.getValue("province");
					String dev_position2 = province + "-" + dev_position;

					// 修改台帐的使用状态
					Map<String, Object> mainMap = new HashMap<String, Object>();
					/*2015.6.11新增手收工验收判断 by wangzheqin 
					 *@remark 如果所属单位和所在单位(即验收的接收单位)一样,把所在单位清空,出库时直接判断所属单位为空或所在单位为当前单位即可直接出库
					 */
					StringBuffer sb = new StringBuffer();
					
					if(receiveorgid.equals(owningorgid)){
						mainMap.put("usage_org_id", "");
						mainMap.put("usage_sub_id", "");
					}else{
						mainMap.put("usage_org_id", receiveorgid);
						mainMap.put("usage_sub_id", getOrgSubId(receiveorgid));
					}
					
					mainMap.put("dev_acc_id", devaccId);
					String tech_stat = msg.getValue("tech_stat");
					mainMap.put("tech_stat", tech_stat);
					String using_stat = DevUtil.getUsingStatByTechstat(tech_stat);
					mainMap.put("using_stat", using_stat);
					mainMap.put("project_info_no", "");
					mainMap.put("dev_position", dev_position2);
					mainMap.put("saveflag", "0");// 台账表0表示已验收(与返还明细表标识相反)
					mainMap.put("check_time", actual_out_date);// 验收时间
					mainMap.put("modifi_date", currentdate);
					mainMap.put("modifier", employee_id);
					devbean.saveDevRecInfo(mainMap, "gms_device_account");
					// 将设备在队级台帐中更新：实际离场时间，离场状态
					Map<String, Object> Map_dui = new HashMap<String, Object>();
					Map_dui.put("dev_acc_id", devaccIdDui);
					// 2013-02-04 验收时间，在队级台账加一个字段，专门存储此设备的 验收时间
					Map_dui.put("check_time", actual_out_date);
					Map_dui.put("is_leaving", "1");
					Map_dui.put("modifi_date", currentdate);
					Map_dui.put("modifier", employee_id);
					devbean.saveDevRecInfo(Map_dui, "gms_device_account_dui");
					// 修改返还明细表状态改为1表示已验收
					Map<String, Object> Map_mix = new HashMap<String, Object>();
					Map_mix.put("device_backdet_id", orders[i]);
					Map_mix.put("state", "1");
					Map_mix.put("dev_position", dev_position2);
					Map_mix.put("modifi_date", currentdate);
					Map_mix.put("modifier", employee_id);
					devbean.saveDevRecInfo(Map_mix, "gms_device_backapp_detail");
					// 2012-9-28 liujb 设备动态表插入离场时间，用于计算利用率
					Map<String, Object> wanhaoMap = new HashMap<String, Object>();
					wanhaoMap.put("dev_acc_id", devaccId);
					wanhaoMap.put("project_info_no", projectInfoNo);
					wanhaoMap.put("oprtype", DevConstants.DYM_OPRTYPE_IN);
					wanhaoMap.put("alter_date", actual_out_date);
					wanhaoMap.put("indb_date", actual_out_date);
					wanhaoMap.put("device_appmix_id", devicebackappid);
					jdbcDao.saveOrUpdateEntity(wanhaoMap, "gms_device_dyminfo");
					// 2012-10-25 liujb 如果状态为待修，那么需要插入待修的动态日志记录 计算完好率
					if (DevConstants.DEV_TECH_DAIXIU.equals(msg
							.getValue("tech_stat"))) {
						Map<String, Object> daixiuMap = new HashMap<String, Object>();
						daixiuMap.put("dev_acc_id", devaccId);
						daixiuMap.put("oprtype",
								DevConstants.DYM_OPRTYPE_WEIXIUOUT);
						daixiuMap.put("alter_date", actual_out_date);
						daixiuMap.put("indb_date", actual_out_date);
						// 如果以后以送修单的形式拼出，在这个地方将送修单ID存进来
						// dataMap.put("device_appmix_id", "xiaoming123");
						// 以前都是先给5类型的也插进去，然后根据indb_date排序，现在通过内关联方式查询结果，indb_date字段作用不大
						jdbcDao.saveOrUpdateEntity(daixiuMap,
								"gms_device_dyminfo");
					}
					
					// 更新调配单的处理状态 2012-10-16 start
					String updatesql1 = "update gms_device_backapp mif set opr_state='1' "
							+ "where exists (select 1 from gms_device_backapp_detail dad "
							+ "where dad.device_backapp_id='"
							+ devicebackappid
							+ "' and dad.state='1') "
							+ "and exists(select 1 from gms_device_backapp_detail dad "
							+ "where dad.device_backapp_id='"
							+ devicebackappid
							+ "' and (dad.state!='1' or dad.state is null)) "
							+ "and mif.device_backapp_id = '"
							+ devicebackappid
							+ "' ";
					String updatesql2 = "update gms_device_backapp mif set opr_state='9' "
							+ "where exists (select 1 from gms_device_backapp_detail dad "
							+ "where dad.device_backapp_id='"
							+ devicebackappid
							+ "' and dad.state='1') "
							+ "and not exists(select 1 from gms_device_backapp_detail dad "
							+ "where dad.device_backapp_id='"
							+ devicebackappid
							+ "' and (dad.state!='1' or dad.state is null)) "
							+ "and mif.device_backapp_id = '"
							+ devicebackappid
							+ "' ";
					stmt.addBatch(updatesql1);
					stmt.addBatch(updatesql2);

					// 档案ID信息归档 一共7个
					// 1. 此设备相关运转记录
					String yzjlsql = "insert into gms_device_archive_detail "
						+ "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,seqinfo,creator,create_date) "
						+ "(select t.OPERATION_INFO_ID,dui.project_info_id,dui.fk_dev_acc_id,'1',t.OPERATION_INFO_ID,rownum,'"+ employee_id + "',sysdate "
						+ "from GMS_DEVICE_OPERATION_INFO t join gms_device_account_dui dui on t.dev_acc_id=dui.dev_acc_id "
					    + "where dui.project_info_id='"+projectInfoNo+"' and dui.fk_dev_acc_id='" + devaccId + "')";
					stmt.addBatch(yzjlsql);
					// 2. 此设备相关的强制保养记录
					String qzbysql = "insert into gms_device_archive_detail "
						+ "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,seqinfo,creator,create_date) "
						+ "(select t.repair_info,dui.project_info_id,dui.fk_dev_acc_id,'2',t.repair_info,rownum,'"+employee_id+"',sysdate "
						+ "from bgp_comm_device_repair_info t join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
						+ "where dui.project_info_id='"+projectInfoNo+"' and dui.fk_dev_acc_id='"+devaccId+"' and t.repair_level='605')";
					stmt.addBatch(qzbysql);					
					// 3. 此设备相关单机材料消耗
					String djclsql = "insert into gms_device_archive_detail "
						+ "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,seqinfo,creator,create_date) "
						+ "(select t.REPAIR_DETAIL_ID,dui.project_info_id,dui.fk_dev_acc_id,'3',t.REPAIR_DETAIL_ID,rownum,'"+employee_id+"',sysdate "
						+ "from BGP_COMM_DEVICE_REPAIR_DETAIL t left join bgp_comm_device_repair_info rp on t.repair_info=rp.repair_info "
						+ "join gms_device_account_dui dui on rp.device_account_id=dui.dev_acc_id "
						+ "where dui.project_info_id='"+projectInfoNo+"' and dui.fk_dev_acc_id='"+devaccId+"')";
					stmt.addBatch(djclsql);
					// 4. 此设备相关油水消耗
					String yssql = "insert into gms_device_archive_detail "
						+ "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,seqinfo,creator,create_date) "
						+ "(select t.oil_info_id,dui.project_info_id,dui.fk_dev_acc_id,'4',t.oil_info_id,rownum,'"+employee_id+"',sysdate "
						+ "from BGP_COMM_DEVICE_OIL_INFO t join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
						+ "where dui.project_info_id='"+projectInfoNo+"' and dui.fk_dev_acc_id='"+devaccId+"')";
					stmt.addBatch(yssql);
					// 5. 此设备相关的定人定机操作记录
					String djsql = "insert into gms_device_archive_detail "
						+ "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,seqinfo,creator,create_date) "
						+ "(select t.entity_id,dui.project_info_id,dui.fk_dev_acc_id,'5',t.entity_id,rownum,'"+employee_id+"',sysdate "
						+ "from gms_device_equipment_operator t join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
						+ "where dui.project_info_id='"+projectInfoNo+"' and dui.fk_dev_acc_id='"+devaccId+"')";
					stmt.addBatch(djsql);
					// 6. 此设备相关事故记录
					String sgsql = "insert into gms_device_archive_detail "
						+ "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,seqinfo,creator,create_date) "
						+ "(select t.accident_info_id,dui.project_info_id,dui.fk_dev_acc_id,'6',t.accident_info_id,rownum,'"+employee_id+"',sysdate "
						+ "from BGP_COMM_DEVICE_ACCIDENT_INFO t join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
						+ "where dui.project_info_id='"+projectInfoNo+"' and dui.fk_dev_acc_id='"+devaccId+"')";
					stmt.addBatch(sgsql);
					// 7. 此设备相关的维修记录
					String wxsql = "insert into gms_device_archive_detail "
						+ "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,seqinfo,creator,create_date) "
						+ "(select t.repair_info,dui.project_info_id,dui.fk_dev_acc_id,'7',t.repair_info,rownum,t.creator,sysdate "
						+ "from bgp_comm_device_repair_info t join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
						+ "where dui.project_info_id='"+projectInfoNo+ "' and dui.fk_dev_acc_id='"+devaccId+"' and t.repair_level<>'605')";
					stmt.addBatch(wxsql);
				}
			}
		}
		stmt.executeBatch();
		stmt.close();
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	
	/**
	 * 方法名：getjbqCollectDeviceInfoNew
	 * 功能：生成地震仪器批量树的异步数据查询
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollectdzyqDeviceInfoNew(ISrvMsg msg) throws Exception{
		String nodeid = msg.getValue("node");
		DeviceMCSBean deviceBean = new DeviceMCSBean();
		//1. 第一次进来
		if ("root".equals(nodeid)) {
			//查询根节点
			String sql = "select '~~0~0' as id,'false' as leaf,'批量设备编码树' as name,'' as code,0 as is_leaf,0 as node_level from dual ";
			
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
			String sql = "select device_id||'~'||dev_code||'~'||node_level||'~'||is_leaf as id,"+
						"case is_leaf when 0 then 'false' else 'true' end as leaf, "+
						"case when is_leaf=0 then dev_name else dev_name||'('||dev_model||')' end as name,dev_code as code,"+
						"is_leaf,node_level from gms_device_collectinfo ";
			//共有四个信息，按顺序分别是 device_id dev_code node_level is_leaf
			String[] keyinfos = nodeid.split("~",-1);
			
			if(keyinfos[0]!=null&&!"".equals(keyinfos[0])){
				sql += "where node_parent_id='"+keyinfos[0]+"' ";
			}else {
				sql += "where dev_code!='04' and dev_code!='06'  and node_parent_id is null ";
			}
			
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
	 * NEWMETHOD
	 * 采集设备收工验收保存基本信息 2015-06-12 收工验收保存验收的信息
	 * @param msg
	 * @return
	 * @throws Exception
	 * @author ZJT
	 */
	public ISrvMsg submitCollectStock(ISrvMsg msg) throws Exception {
		//当前登录用户的ID
		UserToken user = msg.getUserToken();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd hh:mm:ss");
		//1.返还明细表id
		String device_backdet_id = msg.getValue("device_backdet_id");
		//2013-02-17  地震队级台账信息的调整由地震队提交时控制
		Map dataMap = new HashMap<String,Object>();
		//1.更新返还明细表 是否离场标识为‘1’
		dataMap.put("device_coll_backdet_id", device_backdet_id);
		dataMap.put("is_leaving", '1');
		//20150615新增验收状态验收中 如果存在未缴回的数量验收状态为验收中 is_leaving=2
		String sql="";
		String sqlbad="";
		String name=msg.getValue("noreturn_num");
		if(msg.getValue("noreturn_num")!=null&&!msg.getValue("noreturn_num").equals("0"))
		{
			sql = "update gms_device_coll_back_detail set is_leaving='2',in_date=to_date('"+ msg.getValue("actual_out_time")+"','yyyy-mm-dd'),modifi_date=sysdate,modifier='"+user.getUserId()+"' where device_coll_backdet_id = '"+device_backdet_id+"' ";
			sqlbad = "update gms_device_collbackapp_detail set is_leaving='2',modifi_date=sysdate,modifier='"+user.getUserId()+"' where device_backdet_id = '"+device_backdet_id+"'";
		}
		else
		{
			sql = "update gms_device_coll_back_detail set is_leaving='1',in_date=to_date('"+ msg.getValue("actual_out_time")+"','yyyy-mm-dd'),modifi_date=sysdate,modifier='"+user.getUserId()+"' where device_coll_backdet_id = '"+device_backdet_id+"'";
			sqlbad = "update gms_device_collbackapp_detail set is_leaving='1',modifi_date=sysdate,modifier='"+user.getUserId()+"' where device_backdet_id = '"+device_backdet_id+"'";
		}
		
		jdbcDao.executeUpdate(sql);
		jdbcDao.executeUpdate(sqlbad);
		//jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_coll_back_detail");
		//3.更新公司级台账
		String sqla  = "select acc.dev_acc_id from gms_device_coll_account acc ";
				sqla+="where acc.device_id='"+msg.getValue("device_id")+"' ";
				sqla+="and acc.usage_org_id='"+msg.getValue("receive_org_id")+"' and acc.bsflag='0' and acc.ifcountry !='国外' ";
		Map<String,Object> accMapA = jdbcDao.queryRecordBySQL(sqla);
		String devaccid = null;
		if(accMapA == null){
			accMapA = new HashMap<String,Object>();
		}else{
			devaccid = accMapA.get("dev_acc_id").toString();
		}
		//查询其他信息
		
		accMapA.put("total_num", msg.getValue("use_new_total_num"));
		accMapA.put("use_num", msg.getValue("new_using_num"));
		accMapA.put("unuse_num", msg.getValue("new_unusing_num"));
		accMapA.put("other_num", msg.getValue("new_other_num"));
		
		accMapA.put("usage_org_id", msg.getValue("receive_org_id"));
		accMapA.put("owning_org_id", msg.getValue("owning_org_id"));
		accMapA.put("ifcountry", msg.getValue("ifcountry"));
		accMapA.put("usage_sub_id",msg.getValue("usage_sub_id"));
		accMapA.put("owning_sub_id",msg.getValue("owning_sub_id"));
		
		accMapA.put("dev_name", msg.getValue("dev_name"));
		accMapA.put("dev_model", msg.getValue("dev_model"));
		//创建时间等乱七八糟的信息
		accMapA.put("create_date", currentdate);
		accMapA.put("creator", user.getEmpId());
		//2012-10-17 新增缺少的信息
		accMapA.put("bsflag", DevConstants.BSFLAG_NORMAL);
		accMapA.put("dev_unit", msg.getValue("dev_unit"));
		accMapA.put("device_id", msg.getValue("device_id"));
		accMapA.put("type_id", msg.getValue("type_id"));
		
		if(devaccid!=null){
			jdbcDao.saveOrUpdateEntity(accMapA, "gms_device_coll_account");
		}else{
			Serializable accid = jdbcDao.saveOrUpdateEntity(accMapA, "gms_device_coll_account");
			devaccid = accid.toString();
		}
		
		String sqld  = "select tech_id from gms_device_coll_account_tech  ";
		sqld+="where dev_acc_id='"+devaccid+"' ";
		Map<String,Object> techidMap = jdbcDao.queryRecordBySQL(sqld);
		if(techidMap!=null){
			accMapA.putAll(techidMap);
		}
		accMapA.put("dev_acc_id",devaccid);
		accMapA.put("good_num", msg.getValue("new_good_num"));
		//2012-12-29 待报废暂时去掉，不做批量的技术验收 需要重新开发 批量报废功能对设备进行报废。
		//accMapA.put("touseless_num", msg.getValue("new_usless_num"));
		accMapA.put("torepair_num", msg.getValue("new_torepair_num"));
		accMapA.put("tocheck_num", msg.getValue("new_tocheck_num"));
		accMapA.put("destroy_num", msg.getValue("new_destroy_num"));
		//20150612新增待缴回数量
		accMapA.put("noreturn_num", msg.getValue("new_noreturn_num"));
		jdbcDao.saveOrUpdateEntity(accMapA, "gms_device_coll_account_tech");
		//添加本次验收的的数量确认信息
		Map<String,Object> technumMap = new HashMap<String,Object>();
		technumMap.put("dev_acc_id",devaccid);
		technumMap.put("pro_dev_acc_id",msg.getValue("devaccId"));
		technumMap.put("good_num", msg.getValue("good_num"));
		//2012-12-29 待报废暂时去掉，不做批量的技术验收 需要重新开发 批量报废功能对设备进行报废。
		//technumMap.put("tousless_num", msg.getValue("usless_num"));
		technumMap.put("device_backdet_id", device_backdet_id);
		technumMap.put("torepair_num", msg.getValue("torepair_num"));
		technumMap.put("tocheck_num", msg.getValue("tocheck_num"));
		technumMap.put("destroy_num", msg.getValue("destroy_num"));
		technumMap.put("project_info_no",msg.getValue("projectInfoNo"));
		//20150612新增未缴回数量
		technumMap.put("noreturn_num", msg.getValue("noreturn_num"));
		//2013-02-17 验收时间 放在create_date中
		technumMap.put("create_date",msg.getValue("actual_out_time"));
		technumMap.put("dev_dym_id",device_backdet_id);
		technumMap.put("check_time",currentdate);
		jdbcDao.saveEntity(technumMap, "gms_device_coll_account_firm");
		
		String newdevaccid = devaccid;
		String olddevaccid = devaccid;
		if(msg.getValue("out_org_id")!=null&&!msg.getValue("out_org_id").equals(msg.getValue("receive_org_id"))){
			String sqlb  = "select acc.dev_acc_id,acc.total_num,acc.unuse_num,acc.use_num,acc.other_num from gms_device_coll_account acc ";
			sqlb+="where acc.device_id='"+msg.getValue("device_id")+"' ";
			sqlb+="and acc.usage_org_id='"+msg.getValue("out_org_id")+"'and acc.bsflag='0' and acc.owning_org_id='"+msg.getValue("owning_org_id")+"' and acc.ifcountry !='国外' ";
			Map<String,Object> accMapB = jdbcDao.queryRecordBySQL(sqlb);
			if(accMapB!=null){
				//如果归还的单位和原ID不一致没那么olddevaccid取原单位的ID
				olddevaccid = (String)accMapB.get("dev_acc_id");
				String sqlc  = "select tech.tech_id,acc.dev_acc_id,tech.good_num from gms_device_coll_account acc ";
				sqlc+="left join gms_device_coll_account_tech tech on tech.dev_acc_id=acc.dev_acc_id ";
				sqlc+="where acc.device_id='"+msg.getValue("device_id")+"' ";
				sqlc+="and acc.usage_org_id='"+msg.getValue("out_org_id")+"' ";
				
				Map<String,Object> accMapTechB = jdbcDao.queryRecordBySQL(sqlc);
				String goodN = (String)accMapTechB.get("good_num");
				accMapTechB.remove("good_num");
				accMapTechB.put("good_num", Integer.parseInt(goodN)-Integer.parseInt(msg.getValue("back_num")));
				jdbcDao.saveOrUpdateEntity(accMapTechB, "gms_device_coll_account_tech");
			}
		}
		//2012-10-26 插入公司级台账动态表 返还的数量明细 
		String seqrchLeavingSql = "select to_char(actual_out_time,'yyyy-mm-dd') as actual_out_time from gms_device_coll_account_dym where dev_dym_id='"+device_backdet_id+"'";
		Map leavingMap = jdbcDao.queryRecordBySQL(seqrchLeavingSql);
		String actualouttime_leaving = null;
		if(leavingMap!=null){
			actualouttime_leaving = leavingMap.get("actual_out_time").toString();
		}else{
			//2013-02-17 为了兼顾历史数据(历史数据可能在队级日志表没记录离场时间)，使用验收时间作为离场时间确认
			actualouttime_leaving = msg.getValue("actual_out_time");
		}
		Map<String,Object> compDymMap = new HashMap<String,Object>();
		compDymMap.put("oprtype", DevConstants.DYM_OPRTYPE_IN);
		compDymMap.put("dev_acc_id", olddevaccid);
		compDymMap.put("collnum", msg.getValue("back_num"));
		compDymMap.put("alter_date", actualouttime_leaving);
		compDymMap.put("project_info_no", msg.getValue("projectInfoNo"));
		compDymMap.put("device_appmix_id", msg.getValue("device_backapp_id"));
		//这个字段没啥用
		compDymMap.put("indb_date", actualouttime_leaving);
		compDymMap.put("format_date", "2006-01-01");
		compDymMap.put("new_dev_acc_id",  newdevaccid);
		jdbcDao.saveOrUpdateEntity(compDymMap, "gms_device_coll_dym");
		//如果存在维修数量，那么保存维修动态表
		if(Integer.parseInt(msg.getValue("torepair_num").toString())>0){
			//2012-10-26 插入公司级台账动态表 维修的数量
			Map<String,Object> weixiuDymMap = new HashMap<String,Object>();
			weixiuDymMap.put("oprtype", DevConstants.DYM_OPRTYPE_WEIXIUOUT);
			weixiuDymMap.put("dev_acc_id", newdevaccid);
			weixiuDymMap.put("collnum", msg.getValue("torepair_num"));
			//2013-02-17 这个日志时间，使用验收时间作为维修时间的起始时间 
			weixiuDymMap.put("alter_date", msg.getValue("actual_out_time"));
			weixiuDymMap.put("project_info_no", msg.getValue("projectInfoNo"));
			weixiuDymMap.put("device_appmix_id", msg.getValue("device_backapp_id"));
			//这个字段没啥用
			weixiuDymMap.put("indb_date", msg.getValue("actual_out_time"));
			weixiuDymMap.put("format_date", "2006-01-01");
			weixiuDymMap.put("new_dev_acc_id",  newdevaccid);
			jdbcDao.saveOrUpdateEntity(weixiuDymMap, "gms_device_coll_dym");
		}
		//2012-10-17 增加更改主表的处理状态
		String device_backapp_id = msg.getValue("device_backapp_id");
		String updatesql1 = "update gms_device_coll_backinfo_form mif set opr_state='1' "+
							"where exists (select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and dad.is_leaving='1') "+
							"and exists(select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and (dad.is_leaving='0' or dad.is_leaving='2')) "+
							"and mif.device_coll_mixinfo_id = '"+device_backapp_id+"' ";
		
		String updatesql2 = "update gms_device_coll_backinfo_form mif set opr_state='9' "+
							"where exists (select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and dad.is_leaving='1') "+
							"and not exists(select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and (dad.is_leaving='0' or dad.is_leaving='2')) "+
							"and mif.device_coll_mixinfo_id = '"+device_backapp_id+"' ";
		
		String updatesql3 = "update gms_device_coll_backinfo_form mif set opr_state='2' "+
				"where exists (select 1 from gms_device_coll_back_detail dad "+ 
				"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and dad.is_leaving='2') "+
				"and mif.device_coll_mixinfo_id = '"+device_backapp_id+"' ";
		jdbcDao.executeUpdate(updatesql1);
		jdbcDao.executeUpdate(updatesql2);
		jdbcDao.executeUpdate(updatesql3);
		//如果验收信息中存在未缴回的数量，单据状态改为处理中
				if(msg.getValue("noreturn_num")!=null&&!msg.getValue("noreturn_num").equals("0"))
						{
						   String sql3=" update gms_device_coll_backinfo_form app set app.opr_state='2' where app.device_coll_mixinfo_id='"+device_backapp_id+"' ";
						   jdbcDao.executeUpdate(sql3);
						}
				Map<String, Object> logMap = new HashMap<String, Object>();
				logMap.put("rectype", "验收");
				//存储台帐变更记录明细信息
				StringBuilder sb =new StringBuilder();
				if( Integer.parseInt(msg.getValue("good_num").toString())>0)
				{
					sb.append("完好数量增加"+msg.getValue("good_num")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("torepair_num").toString())>0)
				{
					sb.append("维修数量增加"+msg.getValue("torepair_num")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("destroy_num").toString())>0)
				{
					sb.append("毁损数量增加"+msg.getValue("destroy_num")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("tocheck_num").toString())>0)
				{
					sb.append("盘亏数量增加"+msg.getValue("tocheck_num")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("noreturn_num").toString())>0)
				{
					sb.append("未交回数量增加"+msg.getValue("noreturn_num")+"<br>");
				}
				logMap.put("remark", sb.toString());
				String selectdeviceMixAppNoSql=" select p.device_backapp_no from gms_device_coll_backinfo_form f  left join gms_device_collbackapp p on p.device_backapp_id=f.device_backapp_id where f.device_coll_mixinfo_id='"+device_backapp_id+"'";
				Map<String,Object> selectdeviceMixAppNoSqlMap = jdbcDao.queryRecordBySQL(selectdeviceMixAppNoSql);
				String currentDate = DateUtil.convertDateToString(
						DateUtil.getCurrentDate(), "yyyy-MM-dd");
				//20150612新增待缴回数量
				logMap.put("recdate", currentDate);
				logMap.put("dev_acc_id", newdevaccid);
				logMap.put("wanhao_num", msg.getValue("new_good_num"));
				logMap.put("weixiu_num", msg.getValue("new_torepair_num"));
				logMap.put("pankui_num", msg.getValue("new_tocheck_num"));
				logMap.put("huisun_num", msg.getValue("new_destroy_num"));
				logMap.put("noreturn_num", msg.getValue("noreturn_num"));
				logMap.put("bak", selectdeviceMixAppNoSqlMap.get("device_backapp_no"));
				logMap.put("opr_num",msg.getValue("back_num"));
				logMap.put("creator",user.getEmpId());
				logMap.put("create_date", currentdate);
				recChangeLogInfoForColldev(logMap);		
				
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD
	 * 采集设备收工验收更新基本信息 2015-06-12 收工验收更新验收的信息
	 * @param msg
	 * @return
	 * @throws Exception
	 * @author ZJT
	 */
	public ISrvMsg submitCollectStockUpdate(ISrvMsg msg) throws Exception {
		//当前登录用户的ID
		UserToken user = msg.getUserToken();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd hh:mm:ss");
		//1.返还明细表id
		String device_backdet_id = msg.getValue("device_backdet_id");
		//2013-02-17  地震队级台账信息的调整由地震队提交时控制
		Map dataMap = new HashMap<String,Object>();
		//1.更新返还明细表 是否离场标识为‘1’
		dataMap.put("device_coll_backdet_id", device_backdet_id);
		dataMap.put("is_leaving", '1');
		//20150615新增验收状态验收中 如果存在未缴回的数量验收状态为验收中 is_leaving=2
		String sql="";
		String sqlbad="";
		String name=msg.getValue("noreturn_num");
		if(msg.getValue("noreturn_num")!=null&&!msg.getValue("noreturn_num").equals("0"))
		{
			sql = "update gms_device_coll_back_detail set is_leaving='2',in_date=to_date('"+ msg.getValue("actual_out_time")+"','yyyy-mm-dd') where device_coll_backdet_id = '"+device_backdet_id+"'";
			sqlbad = "update gms_device_collbackapp_detail set is_leaving='2' where device_backdet_id = '"+device_backdet_id+"'";
		}
		else
		{
			sql = "update gms_device_coll_back_detail set is_leaving='1',in_date=to_date('"+ msg.getValue("actual_out_time")+"','yyyy-mm-dd') where device_coll_backdet_id = '"+device_backdet_id+"'";
			sqlbad = "update gms_device_collbackapp_detail set is_leaving='1' where device_backdet_id = '"+device_backdet_id+"'";
		}
		
		jdbcDao.executeUpdate(sql);
		jdbcDao.executeUpdate(sqlbad);
		//jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_coll_back_detail");
		//3.更新公司级台账
		String sqla  = "select acc.dev_acc_id from gms_device_coll_account acc ";
				sqla+="where acc.device_id='"+msg.getValue("device_id")+"' ";
				sqla+="and acc.usage_org_id='"+msg.getValue("receive_org_id")+"' and acc.bsflag='0'  and acc.ifcountry !='国外' ";
		Map<String,Object> accMapA = jdbcDao.queryRecordBySQL(sqla);
		String devaccid = null;
		if(accMapA == null){
			accMapA = new HashMap<String,Object>();
		}else{
			devaccid = accMapA.get("dev_acc_id").toString();
		}
		//查询其他信息
		
		accMapA.put("total_num", msg.getValue("use_new_total_num"));
		accMapA.put("use_num", msg.getValue("new_using_num"));
		accMapA.put("unuse_num", msg.getValue("new_unusing_num"));
		accMapA.put("other_num", msg.getValue("new_other_num"));
		
		accMapA.put("usage_org_id", msg.getValue("receive_org_id"));
		accMapA.put("owning_org_id", msg.getValue("owning_org_id"));
		accMapA.put("ifcountry", msg.getValue("ifcountry"));
		accMapA.put("usage_sub_id",msg.getValue("usage_sub_id"));
		accMapA.put("owning_sub_id",msg.getValue("owning_sub_id"));
		
		accMapA.put("dev_name", msg.getValue("dev_name"));
		accMapA.put("dev_model", msg.getValue("dev_model"));
		//创建时间等乱七八糟的信息
		accMapA.put("create_date", currentdate);
		accMapA.put("creator", user.getEmpId());
		//2012-10-17 新增缺少的信息
		accMapA.put("bsflag", DevConstants.BSFLAG_NORMAL);
		accMapA.put("dev_unit", msg.getValue("dev_unit"));
		accMapA.put("device_id", msg.getValue("device_id"));
		accMapA.put("type_id", msg.getValue("type_id"));
		
		if(devaccid!=null){
			jdbcDao.saveOrUpdateEntity(accMapA, "gms_device_coll_account");
		}else{
			Serializable accid = jdbcDao.saveOrUpdateEntity(accMapA, "gms_device_coll_account");
			devaccid = accid.toString();
		}
		String sqld  = "select tech_id from gms_device_coll_account_tech  ";
		sqld+="where dev_acc_id='"+devaccid+"' ";
		Map<String,Object> techidMap = jdbcDao.queryRecordBySQL(sqld);
		if(techidMap!=null){
			accMapA.putAll(techidMap);
		}
		accMapA.put("dev_acc_id",devaccid);
		accMapA.put("good_num", msg.getValue("new_good_num"));
		//2012-12-29 待报废暂时去掉，不做批量的技术验收 需要重新开发 批量报废功能对设备进行报废。
		//accMapA.put("touseless_num", msg.getValue("new_usless_num"));
		accMapA.put("torepair_num", msg.getValue("new_torepair_num"));
		accMapA.put("tocheck_num", msg.getValue("new_tocheck_num"));
		accMapA.put("destroy_num", msg.getValue("new_destroy_num"));
		//20150612新增待缴回数量
		accMapA.put("noreturn_num", msg.getValue("new_noreturn_num"));
		jdbcDao.saveOrUpdateEntity(accMapA, "gms_device_coll_account_tech");
		//2012-10-17 增加更改主表的处理状态
		String device_backapp_id = msg.getValue("device_backapp_id");
		//添加本次验收的的数量确认信息
		Map<String,Object> technumMap = new HashMap<String,Object>();
		technumMap.put("dev_acc_id",devaccid);
		technumMap.put("pro_dev_acc_id",msg.getValue("devaccId"));
		technumMap.put("good_num", msg.getValue("good_num"));
		//2012-12-29 待报废暂时去掉，不做批量的技术验收 需要重新开发 批量报废功能对设备进行报废。
		//technumMap.put("tousless_num", msg.getValue("usless_num"));
		technumMap.put("device_backdet_id", device_backdet_id);
		technumMap.put("torepair_num", msg.getValue("torepair_num"));
		technumMap.put("tocheck_num", msg.getValue("tocheck_num"));
		technumMap.put("destroy_num", msg.getValue("destroy_num"));
		technumMap.put("project_info_no",msg.getValue("projectInfoNo"));
		//20150612新增未缴回数量
		technumMap.put("noreturn_num", msg.getValue("noreturn_num"));
		//2013-02-17 验收时间 放在create_date中
		technumMap.put("create_date",msg.getValue("actual_out_time"));
		technumMap.put("check_time",currentdate);
		//technumMap.put("dev_dym_id",device_backdet_id);
		jdbcDao.saveOrUpdateEntity(technumMap, "gms_device_coll_account_firm");
		
		
		String updatesql1 = "update gms_device_coll_backinfo_form mif set opr_state='1' "+
							"where exists (select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and dad.is_leaving='1') "+
							"and exists(select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and (dad.is_leaving='0' or dad.is_leaving='2')) "+
							"and mif.device_coll_mixinfo_id = '"+device_backapp_id+"' ";
		
		String updatesql2 = "update gms_device_coll_backinfo_form mif set opr_state='9' "+
							"where exists (select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and dad.is_leaving='1') "+
							"and not exists(select 1 from gms_device_coll_back_detail dad "+ 
							"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and (dad.is_leaving='0' or dad.is_leaving='2')) "+
							"and mif.device_coll_mixinfo_id = '"+device_backapp_id+"' ";
	
		jdbcDao.executeUpdate(updatesql1);
		jdbcDao.executeUpdate(updatesql2);

		String updatesql3 = "update gms_device_coll_backinfo_form mif set opr_state='2' "+
				"where exists (select 1 from gms_device_coll_back_detail dad "+ 
				"where dad.device_coll_mixinfo_id='"+device_backapp_id+"' and dad.is_leaving='2') "+
				"and mif.device_coll_mixinfo_id = '"+device_backapp_id+"' ";
		jdbcDao.executeUpdate(updatesql3);
		//如果验收信息中存在未缴回的数量，单据状态改为处理中
				if(msg.getValue("noreturn_num")!=null&&!msg.getValue("noreturn_num").equals("0"))
						{
						   String sql3=" update gms_device_coll_backinfo_form app set app.opr_state='2' where app.device_coll_mixinfo_id='"+device_backapp_id+"' ";
						   jdbcDao.executeUpdate(sql3);
						}
				Map<String, Object> logMap = new HashMap<String, Object>();
				logMap.put("rectype", "验收");
				//查询返还单单号
				String selectdeviceMixAppNoSql=" select p.device_backapp_no from gms_device_coll_backinfo_form f  left join gms_device_collbackapp p on p.device_backapp_id=f.device_backapp_id where f.device_coll_mixinfo_id='"+device_backapp_id+"'";
						Map<String,Object> selectdeviceMixAppNoSqlMap = jdbcDao.queryRecordBySQL(selectdeviceMixAppNoSql);
						String currentDate = DateUtil.convertDateToString(
						DateUtil.getCurrentDate(), "yyyy-MM-dd");
				//20150612新增待缴回数量
				logMap.put("recdate", currentDate);
				logMap.put("dev_acc_id", devaccid);
				logMap.put("wanhao_num", msg.getValue("new_good_num"));
				logMap.put("weixiu_num", msg.getValue("new_torepair_num"));
				logMap.put("pankui_num", msg.getValue("new_tocheck_num"));
				logMap.put("huisun_num", msg.getValue("new_destroy_num"));
				logMap.put("noreturn_num", msg.getValue("noreturn_num"));
				logMap.put("bak", selectdeviceMixAppNoSqlMap.get("device_backapp_no"));
				logMap.put("opr_num",msg.getValue("back_num"));
				logMap.put("creator",user.getEmpId());
				logMap.put("create_date", currentdate);
				//存储台帐变更记录明细信息
				StringBuilder sb =new StringBuilder();
				if( Integer.parseInt(msg.getValue("good_num1").toString())>0)
				{
					sb.append("完好数量增加"+msg.getValue("good_num1")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("torepair_num1").toString())>0)
				{
					sb.append("维修数量增加"+msg.getValue("torepair_num1")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("destroy_num1").toString())>0)
				{
					sb.append("毁损数量增加"+msg.getValue("destroy_num1")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("tocheck_num1").toString())>0)
				{
					sb.append("盘亏数量增加"+msg.getValue("tocheck_num1")+"<br>");
				}
				if( Integer.parseInt(msg.getValue("noreturn_num1").toString())<0)
				{
					int noreturn_num1=Math.abs(Integer.parseInt(msg.getValue("noreturn_num1").toString()));
					sb.append("未交回数量减少"+noreturn_num1+"<br>");
				}
				
				logMap.put("remark", sb.toString());
				recChangeLogInfoForColldev(logMap);
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * 批量返还申请 提交触发的后台方法，对明细信息进行日志控制 2013-02-17
	 * 2015-06-11 修改返还单直接返回在收工验收批量功能中
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveCollectSubmitInfo(ISrvMsg msg) throws Exception {
		String devicebackappid = msg.getValue("devicebackappid");
		//先得到所有的子记录
		String devsql = "select * from gms_device_backapp_detail t where t.device_backapp_id='"+devicebackappid+"'";
		List<Map> devdataList = jdbcDao.queryRecords(devsql);
		if(devdataList != null){
			for(Map devMap : devdataList){
				String devupdate = "update gms_device_account_dui dui set dui.actual_out_time=to_date('"+devMap.get("actual_in_time")+"','yyyy-mm-dd') where dui.dev_acc_id='"+devMap.get("dev_acc_id")+"'";
				jdbcDao.executeUpdate(devupdate);
			}
		}
		String sql = "select * from gms_device_collbackapp_detail where device_backapp_id='"+devicebackappid+"'";
		List<Map> dataList = jdbcDao.queryRecords(sql);
		UserToken user = msg.getUserToken();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd hh:mm:ss");
		for(Map dataMap : dataList){
			//2.更新队级台账
			String searchsql  = "select dev_acc_id, unuse_num,use_num from gms_device_coll_account_dui "+
						"where dev_acc_id='"+dataMap.get("dev_acc_id")+"'";

			Map<String,Object> duiMap = jdbcDao.queryRecordBySQL(searchsql);
			String unuse_num = (String)duiMap.get("unuse_num");
			String use_num = (String)duiMap.get("use_num");
			duiMap.put("unuse_num", Integer.parseInt(unuse_num)-Integer.parseInt(dataMap.get("back_num").toString()));
			duiMap.put("use_num", Integer.parseInt(use_num)+Integer.parseInt(dataMap.get("back_num").toString()));
			if(Integer.parseInt(unuse_num)-Integer.parseInt(dataMap.get("back_num").toString())==0){
				duiMap.put("is_leaving",'1');
			}
			duiMap.put("actual_out_time", dataMap.get("planning_out_time"));
			//保存主表信息
			jdbcDao.saveOrUpdateEntity(duiMap, "gms_device_coll_account_dui");
			//3.插入队级台账动态表
			Map<String,Object> duiDymMap = new HashMap<String,Object>();
			duiDymMap.put("opr_type", DevConstants.DYM_OPRTYPE_IN);
			duiDymMap.put("dev_acc_id", dataMap.get("dev_acc_id"));
			duiDymMap.put("receive_num", dataMap.get("back_num"));
			duiDymMap.put("actual_out_time", dataMap.get("planning_out_time"));
			duiDymMap.put("create_date", currentdate);
			duiDymMap.put("creator", user.getEmpId());
			duiDymMap.put("dev_dym_id", dataMap.get("device_backdet_id"));
			//保存主表信息
			jdbcDao.saveEntity(duiDymMap, "gms_device_coll_account_dym");
		}
		String basesql = "update gms_device_collbackapp set state='9' where device_backapp_id ='"+devicebackappid+"'";
		jdbcDao.executeUpdate(basesql);
		//查询批量返还单信息
		String searchsql  = " select * from gms_device_collbackapp apk where apk.device_backapp_id='"+devicebackappid+"' ";
		Map<String,Object> reqMap = jdbcDao.queryRecordBySQL(searchsql);
		//生成调配返还单信息、便于直接在收工验收批量功能中展示
		List<Map> list = new ArrayList<Map>();
		String collbackdetailsql = "select d.dev_acc_id,d.back_num,d.device_backdet_id from gms_device_collbackapp_detail d where d.device_backapp_id='"+devicebackappid+"'";
		list = pureDao.queryRecords(collbackdetailsql);
		String deviceCollMixinfoId="";
		if(list.size()>0)
		{
		Map<String,Object> mixMap = new HashMap<String,Object>();
		mixMap.put("device_mixapp_no", DevUtil.getEqMixInfoNo());
 		mixMap.put("device_backapp_id", devicebackappid);//返还单ID
 		mixMap.put("project_info_id", reqMap.get("project_info_id"));
 		mixMap.put("receive_org_id", reqMap.get("receive_org_id"));
 		mixMap.put("coll_backapp_no", reqMap.get("device_backapp_no"));
 		mixMap.put("back_org_id", reqMap.get("back_org_id"));
 		mixMap.put("backmix_org_id", reqMap.get("backmix_org_id"));
 		mixMap.put("back_dev_type", reqMap.get("backdevtype"));
 		mixMap.put("backmix_username", user.getUserId());
 		mixMap.put("MIXDATE", currentdate);
 		mixMap.put("state", '9');
		
 		mixMap.put("org_subjection_id", user.getOrgSubjectionId());
 		mixMap.put("org_id", user.getOrgId());
 		mixMap.put("creator_id", user.getUserId());
 		mixMap.put("create_date", currentdate);
 		mixMap.put("bsflag", "0");
		
		Serializable deviceCollMixinfoIds = pureDao.saveOrUpdateEntity(mixMap,"gms_device_coll_backinfo_form");
		deviceCollMixinfoId=deviceCollMixinfoIds.toString();
		}
		for(int i=0;i<list.size();i++){
			//String mixNum = "mixnum_"+ids[i];
			//String devaccid = "devaccid_"+ids[i];
			Map detailMap = new HashMap();
			detailMap=list.get(i);
			detailMap.put("device_coll_mixinfo_id", deviceCollMixinfoId);
			detailMap.put("device_backdet_id", list.get(i).get("device_backdet_id"));
			detailMap.put("dev_acc_id2", detailMap.get("dev_acc_id"));
			detailMap.put("back_num",  detailMap.get("back_num"));
			detailMap.put("is_leaving", "0");
			detailMap.put("create_date", currentdate);
			detailMap.put("creator_id", user.getUserId());
			pureDao.saveOrUpdateEntity(detailMap, "gms_device_coll_back_detail");
		}
		
		
		
		String sql1 = "update gms_device_collbackapp app set app.opr_state='1' where exists(select 1 from (select a.back_num,b.mix_num from ";
			   sql1+= "(select 1, sum(d.back_num) as back_num from GMS_DEVICE_COLLBACKAPP_DETAIL d where d.device_backapp_id='"+reqMap.get("collbackappid")+"' ) a  left join";
			   sql1+= "(select 1,sum(det.back_num) as mix_num from GMS_DEVICE_COLL_BACKINFO_FORM form left join GMS_DEVICE_COLL_BACK_DETAIL det on form.device_coll_mixinfo_id=det.device_coll_mixinfo_id where form.device_backapp_id='"+reqMap.get("collbackappid")+"') b on 1=1)c where c.back_num>c.mix_num) and app.device_backapp_id='"+reqMap.get("collbackappid")+"'";
			   
	    String sql2 = "update gms_device_collbackapp app set app.opr_state='9' where not exists(select 1 from (select a.back_num,b.mix_num from ";
			   sql2+= "(select 1, sum(d.back_num) as back_num from GMS_DEVICE_COLLBACKAPP_DETAIL d where d.device_backapp_id='"+reqMap.get("collbackappid")+"' ) a  left join";
			   sql2+= "(select 1,sum(det.back_num) as mix_num from GMS_DEVICE_COLL_BACKINFO_FORM form left join GMS_DEVICE_COLL_BACK_DETAIL det on form.device_coll_mixinfo_id=det.device_coll_mixinfo_id where form.device_backapp_id='"+reqMap.get("collbackappid")+"') b on 1=1)c where c.back_num>c.mix_num) and app.device_backapp_id='"+reqMap.get("collbackappid")+"'";
		jdbcDao.executeUpdate(sql1);
		jdbcDao.executeUpdate(sql2);
		//更新仪器附属设备返还单明细状态
		String updateStateSql=" update GMS_DEVICE_BACKAPP p set p.state='9' where  p.device_backapp_id='"+devicebackappid+"'";
		jdbcDao.executeUpdate(updateStateSql);

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * 查询采集设备台账的基本信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollectDevAccInfo(ISrvMsg reqDTO) throws Exception{
		String deviceAccId = reqDTO.getValue("deviceAccId");
		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer().append("select ga.dev_acc_id,ga.dev_name,ga.dev_model,ga.other_num as other_num ,ga.total_num as total_num,ga.unuse_num as unuse_num,ga.use_num as use_num, gt.good_num as good_num,gt.tocheck_num as tocheck_num,gt.touseless_num as touseless_num,gt.noreturn_num, gt.torepair_num as torepair_num,gt.destroy_num as destroy_num,gt.repairing_num as repairing_num,")
			.append("gc1.dev_name as dev_type,usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name,ga.dev_position ")
			.append("from gms_device_coll_account ga ")
			.append("left join gms_device_collectinfo gc1 on ga.device_id=gc1.device_id ")
			.append("left join comm_org_information usageorg on ga.usage_org_id=usageorg.org_id ")
			.append("left join comm_coding_sort_detail unitsd on ga.dev_unit=unitsd.coding_code_id ")
			.append("left join gms_device_coll_account_tech gt on gt.dev_acc_id = ga.dev_acc_id ")
			.append("left join gms_device_collectinfo ci on ga.device_id=ci.device_id ")
			.append("where ga.dev_acc_id = '"+deviceAccId+"'");
		Map deviceaccMap = jdbcDao.queryRecordBySQL(sb.toString());
		if(deviceaccMap!=null){
			responseMsg.setValue("deviceaccMap", deviceaccMap);
		}
		return responseMsg;
	}
	/**
	 * 新增采集设备的台账基本信息地震仪器
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author ZJT
	 */
	public ISrvMsg saveCollectDevAccount(ISrvMsg msg) throws Exception {
		//修改台帐的使用状态
		Map m = msg.toMap();
		//判断台帐中是否存在此项数据
		String checkSql = "select dev_acc_id from gms_device_coll_account where device_id='"+msg.getValue("device_id")+"' and usage_org_id='"+msg.getValue("usage_org_id")+"' and owning_org_id='"+msg.getValue("owning_org_id")+"' and bsflag='0'";
		List<Map> checkResult = jdbcDao.queryRecords(checkSql);
		if(checkResult.size() >= 1){
			throw new Exception("所在单位["+msg.getValue("usage_org_name")+"]已存在采集设备["+msg.getValue("dev_name")+"]的台账信息,不能重复添加!");
		}
		String usage_sub_id = "select org_subjection_id as usage_sub_id from comm_org_subjection where org_id='"+msg.getValue("usage_org_id")+"' and bsflag='0'";
		Map<String,Object> submap = jdbcDao.queryRecordBySQL(usage_sub_id);
		m.putAll(submap);
		String currentdateTime = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		m.put("device_id", msg.getValue("device_id"));
		m.put("creator", user.getEmpId());
		m.put("create_date", currentdateTime);
		m.put("modifier", user.getEmpId());
		m.put("modifi_date", currentdateTime);
		m.put("bsflag", DevConstants.BSFLAG_NORMAL);
		Serializable deviceAccId = jdbcDao.saveEntity(m, "gms_device_coll_account");
		Map<String,Object> techMap = new HashMap<String,Object>();
		techMap.put("dev_acc_id", deviceAccId);
		techMap.put("good_num", m.get("wanhao_num"));
		techMap.put("torepair_num", m.get("weixiu_num"));
		techMap.put("destroy_num", m.get("huisun_num"));
		techMap.put("tocheck_num", m.get("pankui_num"));
		jdbcDao.saveEntity(techMap, "gms_device_coll_account_tech");
		//插入变更记录日志信息  为了标识这些信息是必须的，单独用一个map来写下
		Map<String,Object> logMap = new HashMap<String,Object>();
		logMap.put("rectype", "新增");
		String currentDate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd");
		logMap.put("recdate", currentDate);
		logMap.put("dev_acc_id", deviceAccId);
		logMap.put("total_num", m.get("total_num"));
		logMap.put("unuse_num", m.get("unuse_num"));
		logMap.put("use_num", m.get("use_num"));
		logMap.put("other_num", m.get("other_num"));
		logMap.put("wanhao_num", m.get("wanhao_num"));
		logMap.put("weixiu_num", m.get("weixiu_num"));
		logMap.put("pankui_num", m.get("pankui_num"));
		logMap.put("huisun_num", m.get("huisun_num"));
		logMap.put("opr_num", new String(m.get("total_num").toString()));
		logMap.put("creator",user.getEmpId());
		logMap.put("create_date", currentdateTime);
		logMap.put("bak", m.get("bak"));
		//存储台帐变更记录明细信息
		StringBuilder sb =new StringBuilder();
		if( Integer.parseInt(msg.getValue("wanhao_num").toString())>0)
		{
			sb.append("完好数量增加"+msg.getValue("wanhao_num")+"<br>");
		}
		if( Integer.parseInt(msg.getValue("weixiu_num").toString())>0)
		{
			sb.append("维修数量增加"+msg.getValue("weixiu_num")+"<br>");
		}
		if( Integer.parseInt(msg.getValue("huisun_num").toString())>0)
		{
			sb.append("毁损数量增加"+msg.getValue("huisun_num")+"<br>");
		}
		if( Integer.parseInt(msg.getValue("pankui_num").toString())>0)
		{
			sb.append("盘亏数量增加"+msg.getValue("pankui_num")+"<br>");
		}
		logMap.put("remark", sb.toString());
		recChangeLogInfoForColldev(logMap);
		//回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * 设备物资处修改验收单位
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg toUpdateReviceOrgId(ISrvMsg msg) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		
		String deviceBackAppId = msg.getValue("id");
		String receiveOrgId = msg.getValue("receive_org_id");
		
		if(deviceBackAppId != null){
			String sql = "update gms_device_backapp set receive_org_id ='"+receiveOrgId+"' where device_backapp_id='"+deviceBackAppId+"'";			
			jdbcDao.executeUpdate(sql);
		}
		
		
		
		return responseMsg;
	}
	
	/**
	 * 此类自己使用，此方法用于保存采集设备变更记录信息
	 * @param logMap
	 */
	private void recChangeLogInfoForColldev(Map<String, Object> logMap) {
		jdbcDao.saveEntity(logMap, "gms_device_coll_record");
	}

	/**
	 * NEWMETHOD
	 * 保存出库单信息(按量管理的采集设备)
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOutFormDetailInfo(ISrvMsg msg) throws Exception {
		//1.获得基本信息
		String project_info_no = msg.getValue("project_info_no");
		String device_mixinfo_id = msg.getValue("devicemixinfoid");
		//2.用户和时间信息
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String projectType = msg.getValue("project_type");
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String state = msg.getValue("state");
		//-- 先保存基本表
		String in_org_id = msg.getValue("in_org_id");
		String in_sub_id = msg.getValue("in_sub_id");
		String out_org_id = msg.getValue("out_org_id");
		String out_date = msg.getValue("out_date");
		Map<String,Object> mainMap = new HashMap<String,Object>();
		mainMap.put("device_mixinfo_id", device_mixinfo_id);
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("in_org_id", in_org_id);
		mainMap.put("out_org_id", out_org_id);
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("print_emp_id", employee_id);
		mainMap.put("state", state);
		mainMap.put("create_date", currentdate);
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		if("".equals(msg.getValue("outinfo_no"))){
			mainMap.put("outinfo_no", DevUtil.getCollOutInfoNo());
		}
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		if(DevConstants.STATE_SUBMITED.equals(state)){
			mainMap.put("receive_state", DevConstants.DEVRECEIVE_NO);
			mainMap.put("out_date", out_date);
		}
		//2012-10-29 保存申请单类别
		String devouttype = msg.getValue("devouttype");
		mainMap.put("devouttype", devouttype);
		//保存后的mainid信息
		Serializable mainid = jdbcDao.saveEntity(mainMap, "gms_device_coll_outform");
		//3.用于处理明细信息的读取
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~",-1);
		String[] idinfos = msg.getValue("idinfos").split("~",-1);
		for(int i=0;i<count;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			String keyid = lineinfos[i];
			String device_mif_subid = idinfos[i];
			dataMap.put("device_mif_subid", device_mif_subid);
			
			String devaccid = msg.getValue("devaccid"+keyid);
			dataMap.put("dev_acc_id", devaccid);
			//设备编号
			String device_id = msg.getValue("deviceid"+keyid);
			//更换的设备编号
			String deviceidnew = msg.getValue("deviceidnew"+keyid);
			if(deviceidnew!=null&&!"".equals(deviceidnew)){
				dataMap.put("device_id", deviceidnew);
			}else{
				dataMap.put("device_id", device_id);
			}
			//设备名称
			String device_name = msg.getValue("devicename"+keyid);
			dataMap.put("device_name", device_name);
			//规格型号
			String device_model = msg.getValue("devicemodel"+keyid);
			//更换的设备型号
			String devicemodelnew = msg.getValue("devicemodelnew"+keyid);
			if(devicemodelnew!=null&&!"".equals(devicemodelnew)){
				dataMap.put("device_model", devicemodelnew);
			}else{
				dataMap.put("device_model", device_model);
			}
			//调配数量
			String mix_num = msg.getValue("mixnum"+keyid);
			dataMap.put("mix_num", mix_num);
			//出库数量
			String out_num = msg.getValue("outnum"+keyid);
		
			//4.修改公司级台账对应技术状况表20150618
			String colsql  ="select * from gms_device_coll_account_tech " +
			"where dev_acc_id='"+devaccid+"'";
			Map<String,Object> colMap = jdbcDao.queryRecordBySQL(colsql);
			colMap.put("dev_acc_id",devaccid);
			colMap.put("tech_id",colMap.get("tech_id"));
			colMap.put("good_num",Integer.parseInt((String)colMap.get("good_num"))-Integer.parseInt(out_num));
			jdbcDao.saveOrUpdateEntity(colMap, "gms_device_coll_account_tech");
			//2012-10-26 插入到公司级的采集设备动态表 GMS_DEVICE_COLL_DYMINFO
			Map<String,Object> duodymMap = new HashMap<String,Object>();
			duodymMap.put("dev_acc_id", devaccid);
			duodymMap.put("oprtype", DevConstants.DYM_OPRTYPE_OUT);
			duodymMap.put("project_info_no",project_info_no);
			//出库单号
			duodymMap.put("device_appmix_id", mainid);
			duodymMap.put("collnum", out_num);
			duodymMap.put("alter_date", out_date);
			//此字段作用不大
			duodymMap.put("indb_date", currentdate);
			//基准时间，用于计算时间段进出库时间的
			duodymMap.put("format_date", DevConstants.DEV_FORMAT_DATE);	
			jdbcDao.saveOrUpdateEntity(duodymMap, "gms_device_coll_dym");

			dataMap.put("out_num", out_num);
			//单位信息
			String unit_id = msg.getValue("unitid"+keyid);
			dataMap.put("unit_id", unit_id);
			//班组信息 2012-9-27
			String team = msg.getValue("team"+keyid);
			dataMap.put("team", team);
			//dev_acc_id
			//String devaccid = msg.getValue("devaccid"+keyid);
			//dataMap.put("dev_acc_id", devaccid);
			//2012-10-28 liujb 增加备注信息
			String devremark = msg.getValue("devremark"+keyid);
			dataMap.put("devremark", devremark);
			//主表的ID
			dataMap.put("device_outinfo_id", mainid);
			//4.1 保存子表信息
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_coll_outsub");
		}
		//补充.用于处理补充明细信息的读取
		if(msg.getValue("mixcount") != null){
			int mixcount = Integer.parseInt(msg.getValue("mixcount"));
			String[] mixlineinfos = msg.getValue("mixline_infos").split("~",-1);
			String[] mixidinfos = msg.getValue("mixidinfos").split("~",-1);
			for(int i=0;i<mixcount;i++){
				Map<String,Object> dataMap = new HashMap<String,Object>();
				String keyid = mixlineinfos[i];
				String device_mif_subid = mixidinfos[i];
				dataMap.put("device_mif_subid", device_mif_subid);
				//设备名称
				String device_name = msg.getValue("mixdevicename"+keyid);
				dataMap.put("device_name", device_name);
				//规格型号
				String device_model = msg.getValue("mixdevicemodel"+keyid);
				dataMap.put("device_model", device_model);
				//调配数量
				String mix_num = msg.getValue("mixnum"+keyid);
				dataMap.put("mix_num", mix_num);
				//申请数量
				String out_num = msg.getValue("mixoutnum"+keyid);
				dataMap.put("out_num", out_num);
				//单位信息
				String unit_id = msg.getValue("mixunitname"+keyid);
				dataMap.put("unit_name", unit_id);
				//班组信息 2012-9-27
				String team = msg.getValue("mixteam"+keyid);
				dataMap.put("team", team);
				//U代表不用接受，随批量带的额外从属设备
				dataMap.put("receive_state", "U");
				//2012-10-28 liujb 增加备注信息
				String devremark = msg.getValue("mixoutdevremark"+keyid);
				dataMap.put("devremark", devremark);
				//主表的ID
				dataMap.put("device_outinfo_id", mainid);
				Connection conn = jdbcDao.getDataSource().getConnection();
				//4.1 保存子表信息
				jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_coll_outsubadd");
			}
			String devaddcount = msg.getValue("devaddedcount");
			
			if(!"0".equals(devaddcount)){
				//6添加 补充填报单台信息
				int devaddedcount = Integer.parseInt(msg.getValue("devaddedcount"));
				final List<Map<String,Object>> datasList = new ArrayList<Map<String,Object>>();
				String[] devaddedline_infos = msg.getValue("devaddedline_infos").split("~",-1);
				for(int i=0;i<devaddedcount;i++){
					String mix_type_id = msg.getValue("mix_type_id");
					String dev_team = null;
					if(DevConstants.BACK_DEVTYPE_YIQI.equals(mix_type_id)) {
						if("5000100004000000009".equals(projectType)){//综合物化探 
							dev_team = DevConstants.TEAM_ZH_YIQI;
						}else if("5000100004000000006".equals(projectType)){//深海项目
							dev_team = DevConstants.TEAM_SH_YIQI;
						}else{//陆上地震项目
							dev_team = DevConstants.TEAM_YIQI;
						}
					}else if(DevConstants.BACK_DEVTYPE_ZHENYUAN
							.equals(mix_type_id)) {
						dev_team = DevConstants.TEAM_ZHENYUAN;
					}else if(DevConstants.BACK_DEVTYPE_CELIANG
							.equals(mix_type_id)) {
						if("5000100004000000009".equals(projectType)){//综合物化探 
							dev_team = DevConstants.TEAM_ZH_CELIANG;
						}else{
							dev_team = DevConstants.TEAM_CELIANG;
						}
					}
					Map<String,Object> dataMap = new HashMap<String,Object>();
					String keyid = devaddedline_infos[i];
					dataMap.put("team", dev_team);
					dataMap.put("dev_ci_code", msg.getValue("mixdetdevcicode"+keyid));
					dataMap.put("dev_acc_id", msg.getValue("mixdetdev_acc_id"+keyid));
					dataMap.put("asset_coding", msg.getValue("mixdetasset_coding"+keyid));
					dataMap.put("self_num", msg.getValue("mixdetself_num"+keyid));
					dataMap.put("license_num", msg.getValue("mixdetlicense_num"+keyid));
					dataMap.put("dev_sign", msg.getValue("mixdetdev_sign"+keyid));
					dataMap.put("dev_plan_start_date", msg.getValue("mixdetplanstartdate"+keyid));
					dataMap.put("dev_plan_end_date", msg.getValue("mixdetplanenddate"+keyid));
					dataMap.put("devremark", msg.getValue("mixdetremark"+keyid));
					//主表的ID
					dataMap.put("device_outinfo_id", mainid);
					datasList.add(dataMap);
					//如果已经有了subid，那么将其放在map中，实现修改功能
					Serializable addeddetid = jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_equ_outdetail_added");
				}
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				String updateDevaccSql = "update gms_device_account set saveflag='1',ifunused='0',using_stat='0110000007000000001',usage_org_id='"
						+ in_org_id
						+ "',usage_sub_id='"
						+ in_sub_id
						+ "' where dev_acc_id=?";
				BatchPreparedStatementSetter updatesetter = new BatchPreparedStatementSetter() {
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> tempMap = datasList.get(i);
						ps.setString(1, (String) tempMap.get("dev_acc_id"));
					}

					public int getBatchSize() {
						return datasList.size();
					}
				};
				// 更新到调配单子表和更改台账标记表
				jdbcTemplate.batchUpdate(updateDevaccSql, updatesetter);
			}
			String addcount = msg.getValue("addedcount");
			
			if(!"0".equals(addcount)){
				//6添加 补充填报单台信息
				int addedcount = Integer.parseInt(msg.getValue("addedcount"));
				final List<Map<String,Object>> datasList = new ArrayList<Map<String,Object>>();
				String[] addedline_info = msg.getValue("addedline_info").split("~",-1);
				for(int i=0;i<addedcount;i++){
					String mix_type_id = msg.getValue("mix_type_id");
					String dev_team = null;
					if(DevConstants.BACK_DEVTYPE_YIQI.equals(mix_type_id)) {
						if("5000100004000000009".equals(projectType)){//综合物化探 
							dev_team = DevConstants.TEAM_ZH_YIQI;
						}else if("5000100004000000006".equals(projectType)){//深海项目
							dev_team = DevConstants.TEAM_SH_YIQI;
						}else{//陆上地震项目
							dev_team = DevConstants.TEAM_YIQI;
						}
					}else if(DevConstants.BACK_DEVTYPE_ZHENYUAN
							.equals(mix_type_id)) {
						dev_team = DevConstants.TEAM_ZHENYUAN;
					}else if(DevConstants.BACK_DEVTYPE_CELIANG
							.equals(mix_type_id)) {
						if("5000100004000000009".equals(projectType)){//综合物化探 
							dev_team = DevConstants.TEAM_ZH_CELIANG;
						}else{
							dev_team = DevConstants.TEAM_CELIANG;
						}
					}
					Map<String,Object> dataMap = new HashMap<String,Object>();
					String keyid = addedline_info[i];
					dataMap.put("team", dev_team);
					dataMap.put("dev_ci_code", msg.getValue("addeddevcicode"+keyid));
					dataMap.put("dev_acc_id", msg.getValue("addeddev_acc_id"+keyid));
					dataMap.put("asset_coding", msg.getValue("addedasset_coding"+keyid));
					dataMap.put("self_num", msg.getValue("addedself_num"+keyid));
					dataMap.put("license_num", msg.getValue("addedlicense_num"+keyid));
					dataMap.put("dev_sign", msg.getValue("addeddev_sign"+keyid));
					dataMap.put("dev_plan_start_date", msg.getValue("addedplanstartdate"+keyid));
					dataMap.put("dev_plan_end_date", msg.getValue("addedplanenddate"+keyid));
					dataMap.put("devremark", msg.getValue("addedremark"+keyid));
					//主表的ID
					dataMap.put("device_outinfo_id", mainid);
					datasList.add(dataMap);
					//如果已经有了subid，那么将其放在map中，实现修改功能
					Serializable addeddetid = jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_equ_outdetail_added");
				}
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				String updateDevaccSql = "update gms_device_account set saveflag='1',ifunused='0',using_stat='0110000007000000001',usage_org_id='"
						+ in_org_id
						+ "',usage_sub_id='"
						+ in_sub_id
						+ "' where dev_acc_id=?";
				BatchPreparedStatementSetter updatesetter = new BatchPreparedStatementSetter() {
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> tempMap = datasList.get(i);
						ps.setString(1, (String) tempMap.get("dev_acc_id"));
					}

					public int getBatchSize() {
						return datasList.size();
					}
				};
				// 更新到调配单子表和更改台账标记表
				jdbcTemplate.batchUpdate(updateDevaccSql, updatesetter);
			}
		}
		if (DevConstants.STATE_SUBMITED.equals(state)) {
			// 更改申请表主表的状态，执行两个状态
			String updatesql1 = null;
			String updatesql2 = null;

			updatesql1 = "update gms_device_collmix_form cof set cof.opr_state = '1' "
					+ "where (exists (select 1 from (select cms.device_mixinfo_id,sum(nvl(cms.mix_num, 0)) as mix_num,"
					+ "sum(nvl(temp.outednum, 0)) as outednum from gms_device_coll_mixsub cms left join (select device_mif_subid, sum(out_num) as outednum "
					+ "from gms_device_coll_outsub group by device_mif_subid) temp on temp.device_mif_subid = cms.device_mif_subid left join gms_device_collmix_form cmf "
					+ "on cms.device_mixinfo_id = cmf.device_mixinfo_id  "
					+ "where cms.device_mixinfo_id = '"
					+ device_mixinfo_id
					+ "' group by cms.device_mixinfo_id) tmp where tmp.mix_num > outednum)"
					+ "or exists (select 1 from (select addcms.device_mixinfo_id,sum(nvl(addcms.mix_num, 0)) as addmix_num,sum(nvl(temp1.outednum, 0)) as addoutednum "
					+ "from gms_device_coll_mixsubadd addcms left join (select device_mif_subid, sum(out_num) as outednum "
					+ "from gms_device_coll_outsubadd group by device_mif_subid) temp1 on temp1.device_mif_subid = addcms.device_mif_subid "
					+ "left join gms_device_collmix_form addcmf on addcms.device_mixinfo_id = addcmf.device_mixinfo_id "
					+ "where addcms.device_mixinfo_id ='"
					+ device_mixinfo_id
					+ "' group by addcms.device_mixinfo_id ) tmp1 "
					+ "where tmp1.addmix_num > tmp1.addoutednum)) "
					+ "and cof.device_mixinfo_id = '"
					+ device_mixinfo_id
					+ "' ";

			updatesql2 = "update gms_device_collmix_form cof set cof.opr_state = '9' "
					+ "where not exists (select 1 from (select cms.device_mixinfo_id,sum(nvl(cms.mix_num, 0)) as mix_num,"
					+ "sum(nvl(temp.outednum, 0)) as outednum from gms_device_coll_mixsub cms left join (select device_mif_subid, sum(out_num) as outednum "
					+ "from gms_device_coll_outsub group by device_mif_subid) temp on temp.device_mif_subid = cms.device_mif_subid left join gms_device_collmix_form cmf "
					+ "on cms.device_mixinfo_id = cmf.device_mixinfo_id  "
					+ "where cms.device_mixinfo_id = '"
					+ device_mixinfo_id
					+ "' group by cms.device_mixinfo_id) tmp where tmp.mix_num > outednum) "
					+ "and not exists (select 1 from (select addcms.device_mixinfo_id,sum(nvl(addcms.mix_num, 0)) as addmix_num,sum(nvl(temp1.outednum, 0)) as addoutednum "
					+ "from gms_device_coll_mixsubadd addcms left join (select device_mif_subid, sum(out_num) as outednum "
					+ "from gms_device_coll_outsubadd group by device_mif_subid) temp1 on temp1.device_mif_subid = addcms.device_mif_subid "
					+ "left join gms_device_collmix_form addcmf on addcms.device_mixinfo_id = addcmf.device_mixinfo_id "
					+ "where addcms.device_mixinfo_id ='"
					+ device_mixinfo_id
					+ "' group by addcms.device_mixinfo_id ) tmp1 "
					+ "where tmp1.addmix_num > tmp1.addoutednum) "
					+ "and cof.device_mixinfo_id = '"
					+ device_mixinfo_id
					+ "' ";

			jdbcDao.executeUpdate(updatesql1);
			jdbcDao.executeUpdate(updatesql2);
		}
		
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}

	/* 多项目强制保养保存 */
	public ISrvMsg saveNewDeviceAccountRepairInfo(ISrvMsg isrvmsg)
			throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		Map codeMap = new HashMap();
		codeMap.put("1", "个");
		codeMap.put("2", "台");
		codeMap.put("3", "只");
		Map map = new HashMap();
		String repair_info = isrvmsg.getValue("repair_info");
		if (StringUtils.isNotBlank(repair_info) && !repair_info.equals("null")) {
			map.put("repair_info", repair_info);
			String sqlString = "delete from BGP_COMM_DEVICE_REPAIR_DETAIL where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString);
			String sqlString2 = "delete from BGP_COMM_DEVICE_REPAIR_TYPE where repair_info='"
					+ repair_info + "'";
			jdbcDao.executeUpdate(sqlString2);
		}
		map.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
		map.put("REPAIR_TYPE", isrvmsg.getValue("repairType"));
		map.put("REPAIR_ITEM", isrvmsg.getValue("repairItem"));
		map.put("REPAIR_START_DATE", isrvmsg.getValue("REPAIR_START_DATE"));
		map.put("REPAIR_END_DATE", isrvmsg.getValue("REPAIR_END_DATE"));
		map.put("HUMAN_COST", isrvmsg.getValue("HUMAN_COST"));
		map.put("MILEAGE_TOTAL", isrvmsg.getValue("MILEAGE_TOTAL"));
		map.put("DRILLING_FOOTAGE_TOTAL", isrvmsg.getValue("DRILLING_FOOTAGE_TOTAL"));
		map.put("WORK_HOUR_TOTAL", isrvmsg.getValue("WORK_HOUR_TOTAL"));
		map.put("MATERIAL_COST", isrvmsg.getValue("MATERIAL_COST"));
		map.put("CREATOR", isrvmsg.getUserToken().getUserName());
		map.put("REPAIRER", isrvmsg.getValue("REPAIRER"));
		map.put("ACCEPTER", isrvmsg.getValue("ACCEPTER"));
		map.put("WORK_HOUR", isrvmsg.getValue("WORK_HOUR"));
		map.put("REPAIR_DETAIL", isrvmsg.getValue("REPAIR_DETAIL"));
		map.put("RECORD_STATUS", isrvmsg.getValue("RECORD_STATUS"));
		String mk = (String) jdbcDao.saveOrUpdateEntity(map,
				"BGP_COMM_DEVICE_REPAIR_INFO");
		List rows = isrvmsg.getCheckBoxValues("rows");

		// System.out.println(isrvmsg.getValue("repairItem"));
		if ("0110000038000000015".equals(isrvmsg.getValue("repairItem"))) {
			Map map2 = new HashMap();
			map2.put("NEXT_MAINTAIN_DATE",
					isrvmsg.getValue("REPAIR_START_DATE"));
			map2.put("DEVICE_ACCOUNT_ID", isrvmsg.getValue("dev_appdet_id"));
			jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_MAINTAIN");
		}

		// 保养项目--------------------------------传过来的是没有选中的选项(和手持机保持一致)
		String qzby_value = isrvmsg.getValue("qzby_value");
		if (qzby_value != null && qzby_value!="") {
			String temp[] = qzby_value.split(",");
			String[] updateSql = new String[temp.length];
			for (int j = 0; j < temp.length; j++) {
				// Map map1=new HashMap();
				// map1.put("REPAIR_INFO", mk);
				// map1.put("CREATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("CREATE_DATE", new Date());
				// map1.put("UPDATOR_ID", isrvmsg.getUserToken().getUserId());
				// map1.put("MODIFI_DATE", new Date());
				// map1.put("BSFLAG", "0");
				// map1.put("TYPE_ID", temp[j]);//保养项目编码
				//
				// //设备保养项目列表
				// jdbcDao.saveOrUpdateEntity(map1,
				// "BGP_COMM_DEVICE_REPAIR_TYPE");

				String sql = "insert into BGP_COMM_DEVICE_REPAIR_TYPE (repair_detail_id,repair_info,creator_id,create_date,updator_id,modifi_date,bsflag,type_id) "
						+ "values((select sys_guid() from dual),'"
						+ mk
						+ "','"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'"
						+ isrvmsg.getUserToken().getUserId()
						+ "',sysdate,'0','" + temp[j] + "')";
				updateSql[j] = sql;
			}
			jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		}


		if (rows != null) {
			for (int i = 0; i < rows.size(); i++) {
				Map map1 = new HashMap();
				map1.put("REPAIR_INFO", mk);
				map1.put("CREATOR", isrvmsg.getUserToken().getUserName());
				map1.put("CREATE_DATE", currentdate);
//				map1.put("teammat_out_id",
//						isrvmsg.getValue("teammat_out_id" + rows.get(i)));// 计划单号
//				map1.put("MATERIAL_SPEC",
//						isrvmsg.getValue("use_info_detail" + rows.get(i)));// 消耗的材料主键
				map1.put("MATERIAL_NAME",
						isrvmsg.getValue("wz_name" + rows.get(i)));// 材料名称
				map1.put("MATERIAL_CODING",
						isrvmsg.getValue("wz_id" + rows.get(i)));// 材料编号
				map1.put("MATERIAL_UNIT",
						isrvmsg.getValue("wz_prickie" + rows.get(i)));//计量单位
				map1.put("UNIT_PRICE",
						isrvmsg.getValue("wz_price" + rows.get(i)));// 单价
				map1.put("OUT_NUM", isrvmsg.getValue("asign_num" + rows.get(i)));// 出库数量(多项目保养消耗数量等于出库数量)
				map1.put("MATERIAL_AMOUT",
						isrvmsg.getValue("asign_num" + rows.get(i)));// 消耗数量
				map1.put("TOTAL_CHARGE",
						isrvmsg.getValue("total_charge" + rows.get(i)));// 总价

				// 物资子表
				jdbcDao.saveOrUpdateEntity(map1,
						"BGP_COMM_DEVICE_REPAIR_DETAIL");
				// Map map2=new HashMap();
				// map2.put("use_info_detail",
				// isrvmsg.getValue("use_info_detail"+rows.get(i)));
				// map2.put("dev_use", "9");
				// jdbcDao.saveOrUpdateEntity(map2,
				// "GMS_MAT_DEVICE_USE_INFO_DETAIL");

			}
		}

		return responseDTO;
	}
	
	//根据OrgId取OrgSubId
	private String getOrgSubId(String orgId){
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.bsflag='0' and t.org_id ='"+orgId+"'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		
		return map.get("org_subjection_id").toString();
	}
	
	/* 多项目强制保养保存 */
	public ISrvMsg saveStockinMain(ISrvMsg isrvmsg)
			throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//获取批量验收单ID
		String device_coll_mixinfo_id=isrvmsg.getValue("shuaId");
		//获取修改的接收单位
		String receiveOrgId=isrvmsg.getValue("checkOrg");
		Map map = new HashMap();
		map.put("DEVICE_COLL_MIXINFO_ID", device_coll_mixinfo_id);
		map.put("RECEIVE_ORG_ID", receiveOrgId);
		map.put("UPDATOR_ID", isrvmsg.getUserToken().getUserId());
		map.put("MODIFI_DATE", currentdate);
		jdbcDao.saveOrUpdateEntity(map,
				"GMS_DEVICE_COLL_BACKINFO_FORM");
		return responseDTO;
	}
	
	
	
	
	
	
	/**
	 * 物资同步
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg wuziPortal(ISrvMsg msg) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg); 
		String date = msg.getValue("date");
		//查出临时表中物资价格数量与正式表物资价格数量对应不上的数据进行处理
		String resultSql=" select p.matnr,p.menge,p.preis,p.banfn,p.notes from gp_material_plan_tmp p right join gms_mat_demand_plan_invoices z on z.submite_number=p.banfn where p.lgort like '%队%'   and p.notes like '%合计金额%' and p.syn_time like '%"+date+"%'  order by p.banfn desc ";
		List<Map> listResult = jdbcDao.queryRecords(resultSql.toString());
		double mo=0.00;
		String banfn="";
		List<String> insertList =new ArrayList<String>();
		if(listResult!=null)
		{
			for(int i=0;i<listResult.size();i++)
			{
				String totalMoney="";
				//更新物资库物资价格
				String updateSql="update gms_mat_infomation t set t.wz_price='"+listResult.get(i).get("preis")+"' where t.wz_id='"+listResult.get(i).get("matnr")+"'";
				insertList.add(updateSql);
				String []str=listResult.get(i).get("notes").toString().split("合计金额：");
				if(str[1].contains("#"))
				{
				String [] str1=	str[1].toString().split("#");
				totalMoney=str1[0];
				}
				else
				{
					totalMoney=str[1];
				}
				String updateSql2=" update gms_mat_demand_plan_invoices s set s.total_money='"+totalMoney+"' where s.submite_number='"+listResult.get(i).get("banfn")+"'";
				insertList.add(updateSql2);
				String updateSql3=" update gms_mat_demand_plans s set s.buy_num='"+listResult.get(i).get("preis")+"' ,s.demand_num='"+listResult.get(i).get("menge")+"' where   s.wz_id='"+listResult.get(i).get("matnr")+"' and s.plan_invoice_id in (select b.plan_invoice_id from gms_mat_demand_plan_invoices b where b.submite_number='"+listResult.get(i).get("banfn")+"') ";
				insertList.add(updateSql3);
			}
			
							String str[]=new String[insertList.size()];
							String strings[]=insertList.toArray(str);
							//批处理操作
							jdbcTemplate.batchUpdate(strings);
		}
		
		
		return responseDTO;
	}
	
	
	/**
	 * 项目分布
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProJectInfo(ISrvMsg msg) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg); 
		UserToken user = msg.getUserToken();
		String shuaId = msg.getValue("deviceId");
		String proSql1 = "select case "
						+ "when acc.usage_org_id = 'C6000000005551' then 'C105001005' "
						+ "when acc.usage_org_id = 'C6000000005538' then 'C105001002' "
						+ "when acc.usage_org_id = 'C6000000005555' then 'C105001003' "
						+ "when acc.usage_org_id = 'C6000000005543' then 'C105001004' "
						+ "when acc.usage_org_id = 'C6000000005534' then 'C105005004' "
						+ "when acc.usage_org_id = 'C6000000007537' then 'C105063' "
						+ "when acc.usage_org_id = 'C6000000005547' then 'C105005000' "
						+ "when acc.usage_org_id = 'C6000000005560' then 'C105005001' "
						+ "when acc.usage_org_id = 'C6000000005532' then 'C105007' "
						+ "when acc.usage_org_id = 'C6000000000040' then 'C105007' "
						+ "else 'null' end as org_id from gms_device_coll_account acc "
						+ "where acc.dev_acc_id='"+shuaId+"' ";

		Map deviceProjectMap = jdbcDao.queryRecordBySQL(proSql1
				.toString());
		List<Map> list = new ArrayList<Map>();
		String proSql="";
		if(deviceProjectMap!=null){
			proSql += "select project_name,unuse_num,usage_sub_name || '-' || org_abbreviation as org_abbreviation, "
					+ "actual_in_time from (select pro.project_name,t.unuse_num,info.org_abbreviation,t.actual_in_time,case "
					+ "when sub.org_subjection_id like 'C105001005%' then '塔里木物探处' "
					+ "when sub.org_subjection_id like 'C105001002%' then '新疆物探处' "
					+ "when sub.org_subjection_id like 'C105001003%' then '吐哈物探处' "
					+ "when sub.org_subjection_id like 'C105001004%' then '青海物探处' "
					+ "when sub.org_subjection_id like 'C105005004%' then '长庆物探处' "
					+ "when sub.org_subjection_id like 'C105005000%' then '华北物探处' "
					+ "when sub.org_subjection_id like 'C105005001%' then '新兴物探开发处' "
					+ "when sub.org_subjection_id like 'C105007%' then '大港物探处' "
					+ "when sub.org_subjection_id like 'C105063%' then '辽河物探处' "
					+ "when sub.org_subjection_id like 'C105086%' then '深海物探处' "
					+ "when sub.org_subjection_id like 'C105008%' then '综合物化处' "
					+ "when sub.org_subjection_id like 'C105002%' then '国际勘探事业部' "
					+ "when sub.org_subjection_id like 'C105006%' then '装备服务处' "
					+ "when sub.org_subjection_id like 'C105003%' then '研究院' "
					+ "when sub.org_subjection_id like 'C105017%' then '矿区服务事业部' "
					+ "else info.org_abbreviation end as usage_sub_name "		
					+ "from gms_device_coll_account_dui t "
					+ "left join gp_task_project pro on t.project_info_id = pro.project_info_no "
					+ "left join gp_task_project_dynamic dy on dy.project_info_no=t.project_info_id "
					+ "left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0' "
					+ "left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0' "
					+ "where t.device_id=(select t.device_id from gms_device_coll_account t where t.dev_acc_id='"+shuaId+"') "
					+ "and dy.org_subjection_id like '"+deviceProjectMap.get("org_id").toString()+"%' and t.is_leaving = '0' "
					+ "order by t.actual_in_time desc ) ";
		}
		list = jdbcDao.queryRecords(proSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 定人定机
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDj(ISrvMsg isrvmsg) throws Exception {
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = isrvmsg.getUserToken();
		String employee_id = user.getEmpId();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		List operator_ids=isrvmsg.getValues("operator_id");
		List operator_names=isrvmsg.getValues("operator_name");
		String project_no = isrvmsg.getValue("projectno");//项目编号
		String fk_devaccid = isrvmsg.getValue("fkdevaccid");//多项目台账ID
		String device_account_id=isrvmsg.getValue("devaccid");
		String addModFlag = isrvmsg.getValue("add_mod_flag");//新增修改标识:0:新增    1：修改
		String fk_entity_id = isrvmsg.getValue("fk_id");
		
		if(addModFlag!= null && !"0".equals(addModFlag)){
			String sqlStr = "update gms_device_equipment_operator set bsflag='2',modifi_date=sysdate,"
				   +"modifier='"+employee_id+"' where entity_id='"+fk_entity_id+"' ";
			jdbcDao.executeUpdate(sqlStr);
		}
		
		if(operator_ids!=null){
			for(int i=0;i<operator_ids.size();i++){
				Map map=new HashMap();
				map.put("device_account_id",device_account_id);
				map.put("operator_id",operator_ids.get(i));
				map.put("operator_name",operator_names.get(i));
				map.put("fk_dev_acc_id",fk_devaccid);
				map.put("project_info_id",project_no);
				map.put("create_date", currentdate);
				map.put("creator_id", employee_id);
				map.put("bsflag", DevConstants.BSFLAG_NORMAL);
				jdbcDao.saveOrUpdateEntity(map, "gms_device_equipment_operator");
			}
		}
		return responseDTO;
	}
	/**
	 * 综合物化探定人定机
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveZHDj(ISrvMsg isrvmsg) throws Exception {
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = isrvmsg.getUserToken();
		String employee_id = user.getEmpId();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		List operator_ids = isrvmsg.getValues("operator_id");
		List operator_names = isrvmsg.getValues("operator_name");
		String project_no = isrvmsg.getValue("projectno");//项目编号
		String fk_devaccid = isrvmsg.getValue("ids");//多项目台账ID
		String team_dev_id = isrvmsg.getValue("team_dev_id");//队级台账ID

		//String sqlString="delete from gms_device_equipment_operator where fk_dev_acc_id='"+fk_devaccid+"' and project_info_id ='"+project_no+"' ";
		//jdbcDao.executeUpdate(sqlString);
		String sqlStr = "update gms_device_equipment_operator set bsflag='2',modifi_date=sysdate,"
			   +"modifier='"+employee_id+"' where fk_dev_acc_id='"+fk_devaccid+"' and project_info_id ='"+project_no+"' ";
		jdbcDao.executeUpdate(sqlStr);
			
		if(operator_ids!=null){
			for(int i=0;i<operator_ids.size();i++){
				Map map = new HashMap();
				map.put("fk_dev_acc_id",fk_devaccid);
				map.put("operator_name",operator_names.get(i));
				map.put("operator_id",operator_ids.get(i));
				map.put("project_info_id",project_no);
				map.put("device_account_id",team_dev_id);
				map.put("create_date", currentdate);
				map.put("creator_id", employee_id);
				map.put("bsflag", DevConstants.BSFLAG_NORMAL);
				jdbcDao.saveOrUpdateEntity(map, "gms_device_equipment_operator");
			}
		}		
		return responseDTO;
	}
	/**
	 * 定人定机删除操作手
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteOperor(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String employee_id = user.getEmpId();
		String fk_entity_id = isrvmsg.getValue("fk_id");

		String sqlStr = "update gms_device_equipment_operator set bsflag='1',modifi_date=sysdate,"
						   +"modifier='"+employee_id+"' where entity_id='"+fk_entity_id+"' ";
		jdbcDao.executeUpdate(sqlStr);
		
		return responseDTO;
	}
	/**
	 * 新增采集设备的台账基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author ZJT
	 */
	public ISrvMsg updateCollectDevAccount(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// 修改台帐的使用状态
		Map m = msg.toMap();
		String checkSql = "select dev_acc_id from gms_device_coll_account where device_id='"
				+ msg.getValue("device_id")
				+ "' and usage_org_id='"
				+ msg.getValue("usage_org_id")
				+ "' and dev_acc_id='"
				+ msg.getValue("dev_acc_id") + "' and bsflag = '0' ";
		List<Map> checkResult = jdbcDao.queryRecords(checkSql);
		if (checkResult.size() >= 1) {
			m.put("dev_acc_id", checkResult.get(0).get("dev_acc_id"));
		}
		String usage_sub_id = "select org_subjection_id as usage_sub_id from comm_org_subjection where org_id='"
				+ msg.getValue("usage_org_id") + "' and bsflag='0'";
		Map<String, Object> submap = jdbcDao.queryRecordBySQL(usage_sub_id);
		m.putAll(submap);
		String currentdateTime = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		m.put("modifier", user.getEmpId());
		m.put("modifi_date", currentdateTime);
		jdbcDao.saveOrUpdateEntity(m, "gms_device_coll_account");
		//如果操作类型是修改
		if(m.get("opertype").equals("0"))
		{
		// 技术状态信息存储
		Map<String, Object> techMap = new HashMap<String, Object>();
		techMap.put("tech_id", m.get("tech_id"));
		techMap.put("dev_acc_id", m.get("dev_acc_id"));
		techMap.put("good_num", m.get("wanhao_num"));
		techMap.put("torepair_num", m.get("weixiu_num"));
		techMap.put("repairing_num", m.get("zaixiu_num"));
		techMap.put("destroy_num", m.get("huisun_num"));
		techMap.put("tocheck_num", m.get("pankui_num"));
		techMap.put("noreturn_num", m.get("noreturn_num"));
		techMap.put("touseless_num", m.get("touseless_num"));
		jdbcDao.saveOrUpdateEntity(techMap, "gms_device_coll_account_tech");
		// 插入变更记录日志信息 为了标识这些信息是必须的，单独用一个map来写下
		Map<String, Object> logMap = new HashMap<String, Object>();
		logMap.put("rectype", "修改");
		String currentDate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd");
		logMap.put("recdate", currentDate);
		logMap.put("dev_acc_id", m.get("dev_acc_id"));
		logMap.put("total_num", m.get("total_num"));
		logMap.put("unuse_num", m.get("unuse_num"));
		logMap.put("use_num", m.get("use_num"));
		logMap.put("other_num", m.get("other_num"));
		logMap.put("wanhao_num", m.get("wanhao_num"));
		logMap.put("weixiu_num", m.get("weixiu_num"));
		logMap.put("zaixiu_num", m.get("zaixiu_num"));
		logMap.put("pankui_num", m.get("pankui_num"));
		logMap.put("huisun_num", m.get("huisun_num"));
		logMap.put("noreturn_num", m.get("noreturn_num"));
		logMap.put("touseless_num", m.get("touseless_num"));
		int oldtotalnum = Integer.parseInt(m.get("oldtotal_num").toString());
		int totalnum = Integer.parseInt(m.get("total_num").toString());
		int opr_num=0;
		//存储台帐变更记录明细信息
		StringBuilder sb =new StringBuilder();
		if( Integer.parseInt(m.get("wanhao_num1").toString())>0)
		{
			opr_num=opr_num+Integer.parseInt(m.get("wanhao_num1").toString());
			sb.append("完好数量增加"+m.get("wanhao_num1")+"<br>");
		}
		if( Integer.parseInt(m.get("wanhao_num1").toString())<0)
		{
			int wanhao_num=	Math.abs(Integer.parseInt(m.get("wanhao_num1").toString()));
			opr_num=opr_num+wanhao_num;
			sb.append("完好数量减少"+wanhao_num+"<br>");
		}
		
		if( Integer.parseInt(m.get("weixiu_num1").toString())>0)
		{
			opr_num=opr_num+Integer.parseInt(m.get("weixiu_num1").toString());
			sb.append("待修数量增加"+m.get("weixiu_num1")+"<br>");
		}
		if( Integer.parseInt(m.get("weixiu_num1").toString())<0)
		{
			int weixiu_num1=Math.abs(Integer.parseInt(m.get("weixiu_num1").toString()));
			opr_num=opr_num+weixiu_num1;
			sb.append("待修数量减少"+weixiu_num1+"<br>");
		}
		if( Integer.parseInt(m.get("zaixiu_num1").toString())>0)
		{
			opr_num=opr_num+Integer.parseInt(m.get("zaixiu_num1").toString());
			sb.append("在修数量增加"+m.get("zaixiu_num1")+"<br>");
		}
		if( Integer.parseInt(m.get("zaixiu_num1").toString())<0)
		{
			int zaixiu_num1=	Math.abs(Integer.parseInt(m.get("zaixiu_num1").toString()));
			opr_num=opr_num+zaixiu_num1;
			sb.append("在修数量减少"+zaixiu_num1+"<br>");
		}
		if( Integer.parseInt(m.get("huisun_num1").toString())>0)
		{	opr_num=opr_num+Integer.parseInt(m.get("huisun_num1").toString());
			sb.append("毁损数量增加"+m.get("huisun_num1")+"<br>");
		}
		if( Integer.parseInt(m.get("huisun_num1").toString())<0)
		{
			int huisun_num1=Math.abs(Integer.parseInt(m.get("huisun_num1").toString()));
			opr_num=opr_num+huisun_num1;
			sb.append("毁损数量减少"+huisun_num1+"<br>");
		}
		if( Integer.parseInt(m.get("pankui_num1").toString())>0)
		{
			opr_num=opr_num+Integer.parseInt(m.get("pankui_num1").toString());
			sb.append("盘亏数量增加"+m.get("pankui_num1")+"<br>");
		}
		if( Integer.parseInt(m.get("pankui_num1").toString())<0)
		{
			int pankui_num1=Math.abs(Integer.parseInt(m.get("pankui_num1").toString()));
			opr_num=opr_num+pankui_num1;
			sb.append("盘亏数量减少"+pankui_num1+"<br>");
		}
		if( Integer.parseInt(m.get("touseless_num1").toString())>0)
		{
			opr_num=opr_num+Integer.parseInt(m.get("touseless_num1").toString());
			sb.append("待报废数量增加"+m.get("touseless_num1")+"<br>");
		}
		if( Integer.parseInt(m.get("touseless_num1").toString())<0)
		{
			int touseless_num1=Math.abs(Integer.parseInt(m.get("touseless_num1").toString()));
			opr_num=opr_num+touseless_num1;
			sb.append("待报废数量减少"+touseless_num1+"<br>");
		}
		logMap.put("remark", sb.toString());
		logMap.put("bak", msg.getValue("bak"));
		logMap.put("opr_num", opr_num + "");
		logMap.put("creator", user.getEmpId());
		logMap.put("create_date", currentdateTime);
		recChangeLogInfoForColldev(logMap);
		}
		//转资
		if(m.get("opertype").equals("1"))
		{
			// 技术状态信息存储
			Map<String, Object> techMap = new HashMap<String, Object>();
			techMap.put("tech_id", m.get("tech_id"));
			techMap.put("dev_acc_id", m.get("dev_acc_id"));
			techMap.put("good_num", m.get("unuse_num"));
			techMap.put("torepair_num", m.get("weixiu_num"));
			techMap.put("repairing_num", m.get("zaixiu_num"));
			techMap.put("destroy_num", m.get("huisun_num"));
			techMap.put("tocheck_num", m.get("pankui_num"));
			techMap.put("noreturn_num", m.get("noreturn_num"));
			techMap.put("touseless_num", m.get("touseless_num"));
			jdbcDao.saveOrUpdateEntity(techMap, "gms_device_coll_account_tech");
			// 插入变更记录日志信息 为了标识这些信息是必须的，单独用一个map来写下
			Map<String, Object> logMap = new HashMap<String, Object>();
			logMap.put("rectype", "转资");
			String currentDate = DateUtil.convertDateToString(
					DateUtil.getCurrentDate(), "yyyy-MM-dd");
			logMap.put("recdate", currentDate);
			logMap.put("dev_acc_id", m.get("dev_acc_id"));
			logMap.put("total_num", m.get("total_num"));
			logMap.put("unuse_num", m.get("unuse_num"));
			logMap.put("use_num", m.get("use_num"));
			logMap.put("other_num", m.get("other_num"));
			logMap.put("wanhao_num", Integer.parseInt(m.get("wanhao_num").toString())+Integer.parseInt(m.get("wanhaoadd_num").toString()));
			logMap.put("weixiu_num", m.get("weixiu_num"));
			logMap.put("zaixiu_num", m.get("zaixiu_num"));
			logMap.put("pankui_num", m.get("pankui_num"));
			logMap.put("huisun_num", m.get("huisun_num"));
			logMap.put("noreturn_num", m.get("noreturn_num"));
			logMap.put("touseless_num", m.get("touseless_num"));
			//存储台帐变更记录明细信息
			StringBuilder sb =new StringBuilder();
				sb.append("完好数量增加"+m.get("wanhaoadd_num")+"<br>");
			logMap.put("remark", sb.toString());
			logMap.put("bak", msg.getValue("bak"));
			logMap.put("opr_num", m.get("wanhaoadd_num") + "");
			logMap.put("creator", user.getEmpId());
			logMap.put("create_date", currentdateTime);
			recChangeLogInfoForColldev(logMap);
		}
		//转出
				if(m.get("opertype").equals("2"))
				{
					// 技术状态信息存储
					Map<String, Object> techMap = new HashMap<String, Object>();
					techMap.put("tech_id", m.get("tech_id"));
					techMap.put("good_num", m.get("unuse_num"));
					techMap.put("touseless_num", m.get("ntouseless_num"));
					techMap.put("TOREPAIR_NUM", m.get("nweixiu_num"));
					techMap.put("REPAIRING_NUM", m.get("nzaixiu_num"));
					techMap.put("DESTROY_NUM", m.get("nhuisun_num"));
					jdbcDao.saveOrUpdateEntity(techMap, "gms_device_coll_account_tech");
					// 插入变更记录日志信息 为了标识这些信息是必须的，单独用一个map来写下
					Map<String, Object> logMap = new HashMap<String, Object>();
					logMap.put("rectype", "转出");
					String currentDate = DateUtil.convertDateToString(
							DateUtil.getCurrentDate(), "yyyy-MM-dd");
					logMap.put("recdate", currentDate);
					logMap.put("dev_acc_id", m.get("dev_acc_id"));
					logMap.put("total_num", m.get("total_num"));
					logMap.put("unuse_num", m.get("unuse_num"));
					logMap.put("use_num", m.get("use_num"));
					logMap.put("other_num", m.get("other_num"));
					logMap.put("wanhao_num", m.get("nwanhao_num"));
					logMap.put("weixiu_num", m.get("nweixiu_num"));
					logMap.put("zaixiu_num", m.get("nzaixiu_num"));
					logMap.put("pankui_num", m.get("pankui_num"));
					logMap.put("huisun_num", m.get("nhuisun_num"));
					logMap.put("noreturn_num", m.get("noreturn_num"));
					logMap.put("touseless_num", m.get("ntouseless_num"));
					//存储台帐变更记录明细信息
					StringBuilder sb =new StringBuilder();
					String sql=" select f.org_abbreviation as orgname from comm_org_information f where f.org_id='"+msg.getValue("checkOrg")+"'";
					Map<String, Object> mds = jdbcDao.queryRecordBySQL(sql);
					sb.append("转入单位："+mds.get("orgname")+"<br>");
					int count=0;
					if(Integer.parseInt(m.get("wanhaocut_num").toString())>0)
					{
						count=count+Integer.parseInt(m.get("wanhaocut_num").toString());
						sb.append("完好数量减少"+m.get("wanhaocut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("touselesscut_num").toString())>0)
					{
						count=count+Integer.parseInt(m.get("touselesscut_num").toString());
						sb.append("待报废数量减少"+m.get("touselesscut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("weixiucut_num").toString())>0)
					{
						count=count+Integer.parseInt(m.get("weixiucut_num").toString());
						sb.append("待修数量减少"+m.get("weixiucut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("zaixiucut_num").toString())>0)
					{
						count=count+Integer.parseInt(m.get("zaixiucut_num").toString());
						sb.append("在修数量减少"+m.get("zaixiucut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("huisuncut_num").toString())>0)
					{
						count=count+Integer.parseInt(m.get("huisuncut_num").toString());
						sb.append("毁损数量减少"+m.get("huisuncut_num")+"<br>");
					}
					logMap.put("remark", sb.toString());
					logMap.put("bak", msg.getValue("bak"));
					logMap.put("opr_num", count);
					logMap.put("creator", user.getEmpId());
					logMap.put("create_date", currentdateTime);
					recChangeLogInfoForColldev(logMap);
					//转入单位同步设备数并增加台帐操作记录
					String checkSqlr = "select dev_acc_id from gms_device_coll_account where device_id='"+ msg.getValue("device_id")+"' and usage_org_id='"+msg.getValue("checkOrg")+"' and bsflag = '0' ";
					List<Map> zhuanruList = jdbcDao.queryRecords(checkSqlr);
					String dev_acc_idr="";
					if (zhuanruList.size() >= 1) {
						dev_acc_idr=zhuanruList.get(0).get("dev_acc_id").toString();
					}
					else
					{
						String checkSqlz = "select dev_name,dev_model,device_id,dev_unit,type_id,ifcountry from gms_device_coll_account where dev_acc_id='"+msg.getValue("dev_acc_id")+"' and bsflag = '0'";
						List<Map> checkResulrt = jdbcDao.queryRecords(checkSqlz);
						Map r =checkResulrt.get(0);
						r.put("creator", user.getEmpId());
						r.put("create_date", currentdateTime);
						r.put("usage_org_id",m.get("checkOrg"));
						//查出对应的机构隶属关系
						String sqlorgname="select s.org_subjection_id as usage_sub_id from comm_org_subjection s where s.org_id='"+m.get("checkOrg").toString()+"' and s.bsflag='0' ";
						Map<String, Object> md = jdbcDao.queryRecordBySQL(sqlorgname);
						r.put("usage_sub_id",md.get("usage_sub_id"));
						r.put("bsflag","0");
						Serializable did=	jdbcDao.saveOrUpdateEntity(r, "gms_device_coll_account");
						dev_acc_idr=did.toString();
					}
					String sqlr=" select * from gms_device_coll_account_tech t where t.dev_acc_id='"+dev_acc_idr+"'";
					// 技术状态信息存储
					Map<String, Object> techMapr = jdbcDao.queryRecordBySQL(sqlr);
					if(techMapr!=null)
					{
						techMapr.put("tech_id", techMapr.get("tech_id"));
						techMapr.put("good_num", Integer.parseInt(techMapr.get("good_num").toString())+ Integer.parseInt(m.get("wanhaocut_num").toString()));
						techMapr.put("touseless_num", Integer.parseInt(techMapr.get("touseless_num").toString())+ Integer.parseInt(m.get("touselesscut_num").toString()));
						techMapr.put("torepair_num", Integer.parseInt(techMapr.get("torepair_num").toString())+ Integer.parseInt(m.get("weixiucut_num").toString()));
						//判断在修是否为空
						if(	techMapr.get("repairing_num")=="")
						{
							techMapr.put("repairing_num", Integer.parseInt(m.get("zaixiucut_num").toString()));
						}
						else
						{
							techMapr.put("repairing_num", Integer.parseInt(techMapr.get("repairing_num").toString())+ Integer.parseInt(m.get("zaixiucut_num").toString()));
						}
						//判断待报废是否为空
						if(	techMapr.get("destroy_num")=="")
						{
							techMapr.put("destroy_num", Integer.parseInt(m.get("huisuncut_num").toString()));
						}
						else
						{
							techMapr.put("destroy_num", Integer.parseInt(techMapr.get("destroy_num").toString())+ Integer.parseInt(m.get("huisuncut_num").toString()));
						}
					jdbcDao.saveOrUpdateEntity(techMapr, "gms_device_coll_account_tech");
					// 插入变更记录日志信息 为了标识这些信息是必须的，单独用一个map来写下
					Map<String, Object> logMapr = new HashMap<String, Object>();
					logMapr.put("rectype", "转入");
					logMapr.put("recdate", currentDate);
					logMapr.put("dev_acc_id", dev_acc_idr);
					logMapr.put("wanhao_num", techMapr.get("good_num"));
					logMapr.put("weixiu_num", techMapr.get("torepair_num"));
					logMapr.put("zaixiu_num", techMapr.get("repairing_num"));
					logMapr.put("pankui_num", techMapr.get("tocheck_num"));
					logMapr.put("huisun_num", techMapr.get("destroy_num"));
					logMapr.put("noreturn_num", techMapr.get("noreturn_num"));
					logMapr.put("touseless_num", techMapr.get("touseless_num"));
					//存储台帐变更记录明细信息
					StringBuilder sbr =new StringBuilder();
					if(Integer.parseInt(m.get("wanhaocut_num").toString())>0)
					{
						sbr.append("完好数量增加"+m.get("wanhaocut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("touselesscut_num").toString())>0)
					{
						sbr.append("待报废数量增加"+m.get("touselesscut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("weixiucut_num").toString())>0)
					{
						sbr.append("待修数量增加"+m.get("weixiucut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("zaixiucut_num").toString())>0)
					{
						sbr.append("在修数量增加"+m.get("zaixiucut_num")+"<br>");
					}
					if(Integer.parseInt(m.get("huisuncut_num").toString())>0)
					{
						sbr.append("毁损数量增加"+m.get("huisuncut_num")+"<br>");
					}
					logMapr.put("remark", sbr.toString());
					logMapr.put("bak", m.get("usage_org_name")+"转入");
					logMapr.put("opr_num", count);
					logMapr.put("creator", user.getEmpId());
					logMapr.put("create_date", currentdateTime);
					recChangeLogInfoForColldev(logMapr);
					}
					else
					{
						Map map=new HashMap();
						map.put("dev_acc_id", dev_acc_idr);
						map.put("good_num", m.get("wanhaocut_num"));
						map.put("torepair_num", m.get("weixiucut_num"));
						map.put("repairing_num", m.get("zaixiucut_num"));
						map.put("destroy_num", m.get("huisuncut_num"));
						map.put("tocheck_num", "0");
						map.put("noreturn_num", "0");
						map.put("touseless_num", m.get("touselesscut_num"));
						jdbcDao.saveOrUpdateEntity(map, "gms_device_coll_account_tech");
						// 插入变更记录日志信息 为了标识这些信息是必须的，单独用一个map来写下
						Map<String, Object> logMapr = new HashMap<String, Object>();
						logMapr.put("rectype", "转入");
						logMapr.put("recdate", currentDate);
						logMapr.put("dev_acc_id", dev_acc_idr);
						logMapr.put("wanhao_num", m.get("wanhaocut_num"));
						logMapr.put("weixiu_num", m.get("weixiucut_num"));
						logMapr.put("zaixiu_num", m.get("zaixiucut_num"));
						logMapr.put("pankui_num", "0");
						logMapr.put("huisun_num", m.get("huisuncut_num"));
						logMapr.put("noreturn_num", "0");
						logMapr.put("touseless_num", m.get("touselesscut_num"));
						//存储台帐变更记录明细信息
						StringBuilder sbr =new StringBuilder();
						if(Integer.parseInt(m.get("wanhaocut_num").toString())>0)
						{
							sbr.append("完好数量增加"+m.get("wanhaocut_num")+"<br>");
						}
						if(Integer.parseInt(m.get("touselesscut_num").toString())>0)
						{
							sbr.append("待报废数量增加"+m.get("touselesscut_num")+"<br>");
						}
						if(Integer.parseInt(m.get("weixiucut_num").toString())>0)
						{
							sbr.append("待修数量增加"+m.get("weixiucut_num")+"<br>");
						}
						if(Integer.parseInt(m.get("zaixiucut_num").toString())>0)
						{
							sbr.append("在修数量增加"+m.get("zaixiucut_num")+"<br>");
						}
						if(Integer.parseInt(m.get("huisuncut_num").toString())>0)
						{
							sbr.append("毁损数量增加"+m.get("huisuncut_num")+"<br>");
						}
						logMapr.put("remark", sbr.toString());
						logMapr.put("bak", m.get("usage_org_name")+"转入");
						logMapr.put("opr_num", count);
						logMapr.put("creator", user.getEmpId());
						logMapr.put("create_date", currentdateTime);
						recChangeLogInfoForColldev(logMapr);
					}
					
				}
		// 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 变更申请单号  add
	 * @return
	 */
	public static String getMoveAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "变更申请单"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	/**
	 * NEWMETHOD 保存变更申请单-多项目
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savemoveInfo(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得变更申请单名称
		String moveName=isrvmsg.getValue("move_name");
		//变更申请单ID
		String dev_move_id = isrvmsg.getValue("dev_move_id");
		//变更申请单号
		String moveNo = isrvmsg.getValue("move_no");
		//调剂时间
		String applyDate= isrvmsg.getValue("apply_date");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String moveId="";//存储新增的插入的主键
		//如果是新增操作
		if("null".equals(dev_move_id)){
			moveNo = getMoveAppNo();
			mainMap.put("moveapp_name", moveName);
			mainMap.put("moveapp_no", moveNo);
			mainMap.put("in_org_id", isrvmsg.getValue("in_org_id"));
			mainMap.put("out_org_id", isrvmsg.getValue("out_org_id"));
			mainMap.put("APPLY_DATE", applyDate);
			mainMap.put("opertor_id", isrvmsg.getValue("opertor_id_name"));
			mainMap.put("CREATOR_ID", user.getEmpId());
			//2015-09-29新增move_type类型 1：单台 2批量
			mainMap.put("move_type", "2");
			mainMap.put("create_date", currentdate);
			mainMap.put("bsflag", "0");
			mainMap.put("state", "0");
			//6.向数据库写入信息
			Serializable id=jdbcDao.saveOrUpdateEntity(mainMap, "GMS_DEVICE_MOVEAPP");
			dev_move_id=id.toString();
		}
		//修改操作
		else
		{	
			mainMap.put("moveapp_id", dev_move_id);
			mainMap.put("moveapp_name", moveName);
			mainMap.put("in_org_id", isrvmsg.getValue("in_org_id"));
			mainMap.put("out_org_id", isrvmsg.getValue("out_org_id"));
			mainMap.put("APPLY_DATE", applyDate);
			mainMap.put("opertor_id", isrvmsg.getValue("opertor_id_name"));
			mainMap.put("UPDATOR_ID", user.getEmpId());
			mainMap.put("MODIFI_DATE", currentdate);
			mainMap.put("bsflag", "0");
			mainMap.put("state", "0");
			jdbcDao.saveOrUpdateEntity(mainMap, "GMS_DEVICE_MOVEAPP");
		}
		// 删除记录
		String querysgllSql = "delete from GMS_DEVICE_MOVEAPP_DETAIL l where l.MOVEAPP_ID='"+ dev_move_id + "'";
		jdbcDao.executeUpdate(querysgllSql);
				// 选中的条数
				int count = Integer.parseInt(isrvmsg.getValue("count"));
				// 存储
				String[] lineinfos = isrvmsg.getValue("line_infos").split("~", -1);
				List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
				for (int i = 0; i < count; i++) {
					Map<String, Object> dataMap = new HashMap<String, Object>();
					String keyid = lineinfos[i];
					String dev_acc_id = isrvmsg.getValue("dev_acc_id" + keyid);
					String rwanhao_num = isrvmsg.getValue("rwanhao_num" + keyid);
					String rtouseless_num = isrvmsg.getValue("rtouseless_num" + keyid);
					String rweixiu_num = isrvmsg.getValue("rweixiu_num" + keyid);
					String rzaixiu_num = isrvmsg.getValue("rzaixiu_num" + keyid);
					String rhuisun_num = isrvmsg.getValue("rhuisun_num" + keyid);
					dataMap.put("OUT_DEV_ID", dev_acc_id);
					dataMap.put("WANHAO_NUM", rwanhao_num);
					dataMap.put("TOUSELESS_NUM", rtouseless_num);
					dataMap.put("WEIXIU_NUM", rweixiu_num);
					dataMap.put("ZAIXIU_NUM", rzaixiu_num);
					dataMap.put("HUISUN_NUM",rhuisun_num);
					dataMap.put("CREATE_DATE", currentdate);
					dataMap.put("CREATOR_ID", user.getUserId());
					dataMap.put("MOVEAPP_ID", dev_move_id);
					jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_MOVEAPP_DETAIL");
				}
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		return respMsg;
	}
	/**
	 * 查询变更申请基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getmoveAppInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String devrecId = msg.getValue("devrecId");
		String str = " select f.moveapp_id, f.moveapp_no,  f.moveapp_name, inorg.org_abbreviation as inorgname, outorg.org_abbreviation as outorgname,f.apply_date, ";
		str+= "  (case  when f.state = '0' then '未提交'  when f.state = '1' then  '待接收'  when f.state = '2' then '已接收'  when f.state = '3' then ";
		str+= "  '退回'  end) as state, f.opertor_id  from gms_device_moveapp f  left join(comm_org_subjection sub  left join comm_org_information inorg on sub.org_id = inorg.org_id) on f.in_org_id = sub.org_subjection_id ";
		str+= "  left join(comm_org_subjection sub  left join comm_org_information outorg on sub.org_id = outorg.org_id) on f.out_org_id = sub.org_subjection_id";  
		str+= " where   f.moveapp_id='"+devrecId+"' ";
	
		Map repairInfoMap = this.jdbcDao.queryRecordBySQL(str);
		responseDTO.setValue("deviceaccMap", repairInfoMap);
		return responseDTO;
	}
	/**
	 * 查询变更设备信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getmoveAppsInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_id = msg.getValue("mixId");
		String str = " select f.moveapp_id, f.moveapp_no,f.in_org_id,f.out_org_id,  f.moveapp_name, inorg.org_abbreviation as inorgname, outorg.org_abbreviation as outorgname,f.apply_date, ";
		str+= "  (case  when f.state = '0' then '未提交'  when f.state = '1' then  '待接收'  when f.state = '2' then '已接收'  when f.state = '3' then ";
		str+= "  '退回'  end) as state, f.opertor_id  from gms_device_moveapp f  left join(comm_org_subjection sub  left join comm_org_information inorg on sub.org_id = inorg.org_id) on f.in_org_id = sub.org_subjection_id ";
		str+= "  left join(comm_org_subjection sub  left join comm_org_information outorg on sub.org_id = outorg.org_id) on f.out_org_id = sub.org_subjection_id";  
		str+= " where   f.moveapp_id='"+wz_id+"' ";
		Map map = new HashMap();
		map = jdbcDao.queryRecordBySQL(str);
		List<Map> list = new ArrayList<Map>();
		String listSql = " select d.move_det_id,account.dev_acc_id,account.device_id,account.dev_name,account.dev_model,t.good_num,t.touseless_num,t.torepair_num,nvl(t.repairing_num,0) as repairing_num,t.tocheck_num,d.wanhao_num ,d.touseless_num as rtouseless_num,d.weixiu_num,d.zaixiu_num,d.huisun_num,(d.wanhao_num+d.touseless_num+d.weixiu_num+d.zaixiu_num+d.huisun_num) as allnum  from gms_device_moveapp_detail d left join gms_device_coll_account_tech t on t.dev_acc_id=d.out_dev_id left join gms_device_coll_account account on account.dev_acc_id=d.out_dev_id  where d.moveapp_id='"+wz_id+"'";
		list = jdbcDao.queryRecords(listSql);
		responseDTO.setValue("datas", list);
		responseDTO.setValue("devMap", map);
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD 接收变更申请单-多项目
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg receivemoveInfo(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得变更申请单名称
		String moveName=isrvmsg.getValue("move_name");
		//变更申请单ID
		String dev_move_id = isrvmsg.getValue("dev_move_id");
		//变更申请单号
		String moveNo = isrvmsg.getValue("move_no");
		//调剂时间
		String applyDate= isrvmsg.getValue("apply_date");
		//是否验收
		String info= isrvmsg.getValue("info");
		//验收
		if(info.equals("0"))
		{
			mainMap.put("state","2");
		}
		//退回
		if(info.equals("1"))
		{
			mainMap.put("state","3");
		}
		mainMap.put("moveapp_id", dev_move_id);
		jdbcDao.saveOrUpdateEntity(mainMap, "GMS_DEVICE_MOVEAPP");
		//验收操作
		if(info.equals("0"))
		{
		//生成基本信息
				// 选中的条数
				int count = Integer.parseInt(isrvmsg.getValue("count"));
				// 存储
				String[] lineinfos = isrvmsg.getValue("line_infos").split("~", -1);
				List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
				for (int i = 0; i < count; i++) {
					//因转出数量已经在用户提交变更单中更新、这里不用更新
					Map<String, Object> dataMap = new HashMap<String, Object>();
					String keyid = lineinfos[i];
					String move_det_id = isrvmsg.getValue("move_det_id" + keyid);
					String dev_acc_id=isrvmsg.getValue("dev_acc_id" + keyid);
					String rwanhao_num = isrvmsg.getValue("rwanhao_num" + keyid);
					String rtouseless_num = isrvmsg.getValue("rtouseless_num" + keyid);
					String rweixiu_num = isrvmsg.getValue("rweixiu_num" + keyid);
					String rzaixiu_num = isrvmsg.getValue("rzaixiu_num" + keyid);
					String rhuisun_num = isrvmsg.getValue("rhuisun_num" + keyid);
					String rpankui_num = isrvmsg.getValue("rpankui_num" + keyid);
					String wanhao_num = isrvmsg.getValue("wanhao_num" + keyid);
					String touseless_num = isrvmsg.getValue("touseless_num" + keyid);
					String weixiu_num = isrvmsg.getValue("weixiu_num" + keyid);
					String zaixiu_num = isrvmsg.getValue("zaixiu_num" + keyid);
					String huisun_num = isrvmsg.getValue("huisun_num" + keyid);
					dataMap.put("MOVE_DET_ID", move_det_id);
					dataMap.put("OUT_DEV_ID", dev_acc_id);
					dataMap.put("RWANHAO_NUM", rwanhao_num);
					dataMap.put("RTOUSELESS_NUM", rtouseless_num);
					dataMap.put("RWEIXIU_NUM", rweixiu_num);
					dataMap.put("RZAIXIU_NUM", rzaixiu_num);
					dataMap.put("RHUISUN_NUM",rhuisun_num);
					dataMap.put("RPANKUI_NUM",rpankui_num);
					dataMap.put("CREATE_DATE", currentdate);
					dataMap.put("CREATOR_ID", user.getUserId());
					dataMap.put("MOVEAPP_ID", dev_move_id);
					jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_MOVEAPP_DETAIL");
				
					Map<String, Object> logMap = new HashMap<String, Object>();
					logMap.put("rectype", "转出");
					String currentDate = DateUtil.convertDateToString(
							DateUtil.getCurrentDate(), "yyyy-MM-dd");
					logMap.put("recdate", currentDate);
					logMap.put("dev_acc_id", dev_acc_id);
					logMap.put("wanhao_num", wanhao_num);
					logMap.put("weixiu_num", weixiu_num);
					logMap.put("zaixiu_num", zaixiu_num);
					//转出单位没有盘亏数量
					logMap.put("pankui_num", "0");
					logMap.put("huisun_num", huisun_num);
					logMap.put("noreturn_num", "0");
					logMap.put("touseless_num", touseless_num);
					//存储台帐变更记录明细信息
					StringBuilder sb =new StringBuilder();
					String sql=" select f.org_abbreviation as orgname from comm_org_information f left join comm_org_subjection s on s.org_id=f.org_id where s.org_subjection_id='"+isrvmsg.getValue("in_org_id").trim()+"'";
					Map<String, Object> mds = jdbcDao.queryRecordBySQL(sql);
					sb.append("转入单位："+mds.get("orgname")+"<br>");
					String count1=isrvmsg.getValue("allnum" + keyid);
					if(Integer.parseInt(wanhao_num)>0)
					{
						sb.append("完好数量减少"+wanhao_num+"<br>");
					}
					if(Integer.parseInt(touseless_num)>0)
					{
						sb.append("待报废数量减少"+touseless_num+"<br>");
					}
					if(Integer.parseInt(weixiu_num)>0)
					{
						sb.append("待修数量减少"+weixiu_num+"<br>");
					}
					if(Integer.parseInt(zaixiu_num)>0)
					{
						sb.append("在修数量减少"+zaixiu_num+"<br>");
					}
					if(Integer.parseInt(huisun_num)>0)
					{
						sb.append("毁损数量减少"+huisun_num+"<br>");
					}
					logMap.put("remark", sb.toString());
					logMap.put("bak", moveNo);
					logMap.put("opr_num", count1);
					logMap.put("creator", user.getEmpId());
					logMap.put("create_date", currentdate);
					//增加转出记录
					recChangeLogInfoForColldev(logMap);
					
					//转入单位同步设备数并增加台帐操作记录
					String checkSqlr = "select dev_acc_id from gms_device_coll_account where device_id='"+ isrvmsg.getValue("device_id"+ keyid)+"' and usage_sub_id='"+isrvmsg.getValue("in_org_id")+"' and bsflag = '0' ";
					List<Map> zhuanruList = jdbcDao.queryRecords(checkSqlr);
					String dev_acc_idr="";
					if (zhuanruList.size() >= 1) {
						dev_acc_idr=zhuanruList.get(0).get("dev_acc_id").toString();
					}
					else
					{
						String checkSqlz = "select dev_name,dev_model,device_id,dev_unit,type_id,ifcountry from gms_device_coll_account where dev_acc_id='"+dev_acc_id+"' and bsflag = '0'";
						List<Map> checkResulrt = jdbcDao.queryRecords(checkSqlz);
						Map r =checkResulrt.get(0);
						r.put("creator", user.getEmpId());
						r.put("create_date", currentdate);
						r.put("usage_sub_id",isrvmsg.getValue("in_org_id"));
						//查出对应的机构隶属关系
						String sqlorgname="select f.org_id from comm_org_information f left join comm_org_subjection s  on s.org_id=f.org_id where s.org_subjection_id='"+isrvmsg.getValue("in_org_id")+"' and s.bsflag='0' ";
						Map<String, Object> md = jdbcDao.queryRecordBySQL(sqlorgname);
						r.put("usage_org_id",md.get("org_id"));
						r.put("bsflag","0");
						Serializable did=	jdbcDao.saveOrUpdateEntity(r, "gms_device_coll_account");
						dev_acc_idr=did.toString();
					}
					String sqlr=" select * from gms_device_coll_account_tech t where t.dev_acc_id='"+dev_acc_idr+"'";
					// 技术状态信息存储
					Map<String, Object> techMapr = jdbcDao.queryRecordBySQL(sqlr);
					if(techMapr!=null)
					{
						techMapr.put("tech_id", techMapr.get("tech_id"));
						techMapr.put("good_num", Integer.parseInt(techMapr.get("good_num").toString())+ Integer.parseInt(rwanhao_num));
						techMapr.put("touseless_num", Integer.parseInt(techMapr.get("touseless_num").toString())+ Integer.parseInt(rtouseless_num));
						techMapr.put("destroy_num", Integer.parseInt(techMapr.get("destroy_num").toString())+ Integer.parseInt(rhuisun_num));
						techMapr.put("torepair_num", Integer.parseInt(techMapr.get("torepair_num").toString())+ Integer.parseInt(rweixiu_num));
						//判断在修是否为空
						if(	techMapr.get("repairing_num")=="")
						{
							techMapr.put("repairing_num", Integer.parseInt(rzaixiu_num));
						}
						else
						{
							techMapr.put("repairing_num", Integer.parseInt(techMapr.get("repairing_num").toString())+ Integer.parseInt(rzaixiu_num));
						}
						techMapr.put("tocheck_num", Integer.parseInt(techMapr.get("tocheck_num").toString())+ Integer.parseInt(rpankui_num));
					jdbcDao.saveOrUpdateEntity(techMapr, "gms_device_coll_account_tech");
					// 插入变更记录日志信息 为了标识这些信息是必须的，单独用一个map来写下
					Map<String, Object> logMapr = new HashMap<String, Object>();
					logMapr.put("rectype", "转入");
					logMapr.put("recdate", currentDate);
					logMapr.put("dev_acc_id", dev_acc_idr);
					logMapr.put("wanhao_num", rwanhao_num);
					logMapr.put("weixiu_num", rweixiu_num);
					logMapr.put("zaixiu_num", rzaixiu_num);
					logMapr.put("pankui_num", rpankui_num);
					logMapr.put("huisun_num", rhuisun_num);
					logMapr.put("noreturn_num", "0");
					logMapr.put("touseless_num", rtouseless_num);
					//存储台帐变更记录明细信息
					StringBuilder sbr =new StringBuilder();
					if(Integer.parseInt(rwanhao_num)>0)
					{
						sbr.append("完好数量增加"+rwanhao_num+"<br>");
					}
					if(Integer.parseInt(rtouseless_num)>0)
					{
						sbr.append("待报废数量增加"+rtouseless_num+"<br>");
					}
					if(Integer.parseInt(rweixiu_num)>0)
					{
						sbr.append("待修数量增加"+rweixiu_num+"<br>");
					}
					if(Integer.parseInt(rzaixiu_num)>0)
					{
						sbr.append("在修数量增加"+rzaixiu_num+"<br>");
					}
					if(Integer.parseInt(rhuisun_num)>0)
					{
						sbr.append("毁损数量增加"+rhuisun_num+"<br>");
					}
					logMapr.put("remark", sbr.toString());
					logMapr.put("bak", isrvmsg.getValue("out_org_name")+"转入");
					logMapr.put("opr_num", count1);
					logMapr.put("creator", user.getEmpId());
					logMapr.put("create_date", currentdate);
					recChangeLogInfoForColldev(logMapr);
					}
					else
					{
						Map map=new HashMap();
						map.put("dev_acc_id", dev_acc_idr);
						map.put("good_num", rwanhao_num);
						map.put("torepair_num", rweixiu_num);
						map.put("repairing_num", rzaixiu_num);
						map.put("destroy_num", rhuisun_num);
						map.put("tocheck_num", rpankui_num);
						map.put("noreturn_num", "0");
						map.put("touseless_num", rtouseless_num);
						jdbcDao.saveOrUpdateEntity(map, "gms_device_coll_account_tech");
						// 插入变更记录日志信息 为了标识这些信息是必须的，单独用一个map来写下
						Map<String, Object> logMapr = new HashMap<String, Object>();
						logMapr.put("rectype", "转入");
						logMapr.put("recdate", currentDate);
						logMapr.put("dev_acc_id", dev_acc_idr);
						logMapr.put("wanhao_num", rwanhao_num);
						logMapr.put("weixiu_num", rweixiu_num);
						logMapr.put("zaixiu_num", rzaixiu_num);
						logMapr.put("pankui_num", rpankui_num);
						logMapr.put("huisun_num", rhuisun_num);
						logMapr.put("noreturn_num", "0");
						logMapr.put("touseless_num", rtouseless_num);
						//存储台帐变更记录明细信息
						StringBuilder sbr =new StringBuilder();
						if(Integer.parseInt(rwanhao_num)>0)
						{
							sbr.append("完好数量增加"+rwanhao_num+"<br>");
						}
						if(Integer.parseInt(rtouseless_num)>0)
						{
							sbr.append("待报废数量增加"+rtouseless_num+"<br>");
						}
						if(Integer.parseInt(rweixiu_num)>0)
						{
							sbr.append("待修数量增加"+rweixiu_num+"<br>");
						}
						if(Integer.parseInt(rzaixiu_num)>0)
						{
							sbr.append("在修数量增加"+rzaixiu_num+"<br>");
						}
						if(Integer.parseInt(rhuisun_num)>0)
						{
							sbr.append("毁损数量增加"+rhuisun_num+"<br>");
						}
						logMapr.put("remark", sbr.toString());
						logMapr.put("bak", isrvmsg.getValue("out_org_name")+"转入");
						logMapr.put("opr_num", count1);
						logMapr.put("creator", user.getEmpId());
						logMapr.put("create_date", currentdate);
						recChangeLogInfoForColldev(logMapr);
					}
				}
		}
				//退回操作
				if(info.equals("1"))
				{
					String moveapp_id = dev_move_id;
					
					String sql=" select d.wanhao_num,d.touseless_num,d.weixiu_num,d.zaixiu_num,d.huisun_num,d.out_dev_id  from gms_device_moveapp_detail d  where d.moveapp_id='"+moveapp_id+"'";
					List list = jdbcDao.queryRecords(sql.toString());
					for(int i=0;i<list.size();i++)
					{
						Map dataMap = (Map)list.get(i);	
						int good_num= Integer.parseInt(dataMap.get("wanhao_num").toString());
						int touseless_num= Integer.parseInt(dataMap.get("touseless_num").toString());
						int torepair_num= Integer.parseInt(dataMap.get("weixiu_num").toString());
						int repairing_num= Integer.parseInt(dataMap.get("zaixiu_num").toString());
						int tocheck_num= Integer.parseInt(dataMap.get("huisun_num").toString());
						//查询出对应台帐中的技术状况
						String techSql="select nvl(t.good_num,0) as good_num ,nvl(t.touseless_num,0) as touseless_num ,nvl(t.torepair_num,0) as torepair_num ,nvl(t.repairing_num,0) as repairing_num,  nvl(t.destroy_num, 0) as destroy_num, t.tech_id from gms_device_coll_account_tech t where t.dev_acc_id='"+dataMap.get("out_dev_id")+"'";
						Map<String, Object> techMapr = jdbcDao.queryRecordBySQL(techSql);
						techMapr.put("good_num", Integer.parseInt(techMapr.get("good_num").toString())+good_num);
						techMapr.put("touseless_num", Integer.parseInt(techMapr.get("touseless_num").toString())+touseless_num);
						techMapr.put("torepair_num", Integer.parseInt(techMapr.get("torepair_num").toString())+torepair_num);
						techMapr.put("repairing_num", Integer.parseInt(techMapr.get("repairing_num").toString())+repairing_num);
						techMapr.put("destroy_num", Integer.parseInt(techMapr.get("destroy_num").toString())+tocheck_num);
						jdbcDao.saveOrUpdateEntity(techMapr, "gms_device_coll_account_tech");
					}
					
				}	
				ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
				return respMsg;
	}
	/**
	 * 提交后更新转出单位台帐的数量
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateColAccount(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String moveapp_id = msg.getValue("moveapp_id");
		String sql=" select d.wanhao_num,d.touseless_num,d.weixiu_num,d.zaixiu_num,d.huisun_num,d.out_dev_id  from gms_device_moveapp_detail d  where d.moveapp_id='"+moveapp_id+"'";
		List list = jdbcDao.queryRecords(sql.toString());
		for(int i=0;i<list.size();i++)
		{
			Map dataMap = (Map)list.get(i);	
			int good_num= Integer.parseInt(dataMap.get("wanhao_num").toString());
			int touseless_num= Integer.parseInt(dataMap.get("touseless_num").toString());
			int torepair_num= Integer.parseInt(dataMap.get("weixiu_num").toString());
			int repairing_num= Integer.parseInt(dataMap.get("zaixiu_num").toString());
			int tocheck_num= Integer.parseInt(dataMap.get("huisun_num").toString());
			//查询出对应台帐中的技术状况
			String techSql="select nvl(t.good_num,0) as good_num ,nvl(t.touseless_num,0) as touseless_num ,nvl(t.torepair_num,0) as torepair_num ,nvl(t.repairing_num,0) as repairing_num,  nvl(t.destroy_num, 0) as destroy_num,t.tech_id from gms_device_coll_account_tech t where t.dev_acc_id='"+dataMap.get("out_dev_id")+"'";
			Map<String, Object> techMapr = jdbcDao.queryRecordBySQL(techSql);
			techMapr.put("good_num", Integer.parseInt(techMapr.get("good_num").toString())-good_num);
			techMapr.put("touseless_num", Integer.parseInt(techMapr.get("touseless_num").toString())-touseless_num);
			techMapr.put("torepair_num", Integer.parseInt(techMapr.get("torepair_num").toString())-torepair_num);
			techMapr.put("repairing_num", Integer.parseInt(techMapr.get("repairing_num").toString())-repairing_num);
			techMapr.put("destroy_num", Integer.parseInt(techMapr.get("destroy_num").toString())-tocheck_num);
			jdbcDao.saveOrUpdateEntity(techMapr, "gms_device_coll_account_tech");
		}
	
		return responseDTO;
	}
	
	/**
	 * 查询单台设备信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSinDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String ids = msg.getValue("ids");
		String querysgllSql = "select acc.* from gms_device_account acc  where  acc.dev_acc_id in ("
				+ ids + ") ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 查询单台设备变更信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSinDevMoveInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String mixId = msg.getValue("mixId");
		String str = " select f.moveapp_id, f.moveapp_no,f.in_org_id,f.out_org_id,  f.moveapp_name, inorg.org_abbreviation as inorgname, outorg.org_abbreviation as outorgname,f.apply_date, ";
		str+= "  (case  when f.state = '0' then '未提交'  when f.state = '1' then  '待接收'  when f.state = '2' then '已接收'  when f.state = '3' then ";
		str+= "  '退回'  end) as state, f.opertor_id  from gms_device_moveapp f  left join(comm_org_subjection sub  left join comm_org_information inorg on sub.org_id = inorg.org_id) on f.in_org_id = sub.org_subjection_id ";
		str+= "  left join(comm_org_subjection sub  left join comm_org_information outorg on sub.org_id = outorg.org_id) on f.out_org_id = sub.org_subjection_id ";  
		str+= " where   f.moveapp_id='"+mixId+"' ";
		Map map = new HashMap();
		map = jdbcDao.queryRecordBySQL(str);
		List<Map> list = new ArrayList<Map>();
		String listSql = " select d.move_det_id,d.out_dev_id,acc.dev_acc_id,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign from gms_device_moveapp_detail d left join gms_device_account acc on d.out_dev_id=acc.dev_acc_id  where d.moveapp_id='"+mixId+"' order by acc.dev_coding";
		list = jdbcDao.queryRecords(listSql);
		responseDTO.setValue("datas", list);
		responseDTO.setValue("devMap", map);
		return responseDTO;
	}
	
	/**
	 * 修改保存单台设备变更信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateSinDevMoveInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateSinDevMoveInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String flag = isrvmsg.getValue("flag");
		Map map = isrvmsg.toMap();
		//申请单id
		String moveappId="";
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//保存操作
				//定义保存申请表map
				Map aMap=new HashMap();
				aMap.put("moveapp_no", getMoveAppNo());
				aMap.put("moveapp_name", map.get("moveapp_name").toString());
				aMap.put("in_org_id", map.get("in_org_id").toString());
				aMap.put("out_org_id", map.get("out_org_id").toString());
				aMap.put("opertor_id", map.get("opertor_id").toString());
				aMap.put("state", "0");
				aMap.put("apply_date", map.get("apply_date").toString());
				aMap.put("bsflag", "0");
				aMap.put("creator_id", user.getUserId());
				aMap.put("create_date", new Date());
				//move_type类型 1：单台 2批量
				aMap.put("move_type", "1");
				moveappId=(String)jdbcDao.saveOrUpdateEntity(aMap, "gms_device_moveapp");
			}else{//修改操作
				//申请id从表单数据获取
				moveappId=map.get("moveapp_id").toString();
				Map uMap=new HashMap();
				uMap.put("moveapp_id", moveappId);
				uMap.put("moveapp_name", map.get("moveapp_name").toString());
				uMap.put("in_org_id", map.get("in_org_id").toString());
				uMap.put("out_org_id", map.get("out_org_id").toString());
				uMap.put("opertor_id", map.get("opertor_id").toString());
				uMap.put("apply_date", map.get("apply_date").toString());
				uMap.put("updator_id", user.getUserId());
				uMap.put("modifi_date", new Date());
				uMap.put("state", "0");//退回的记录，修改后变成未提交记录
				jdbcDao.saveOrUpdateEntity(uMap, "gms_device_moveapp");
			}
			//如果申请id不为空，修改保存明细记录时，先删除相关记录
			if(StringUtils.isNotBlank(moveappId)){
				// 修改台账，释放锁定记录
				String ucSql="update gms_device_account set spare5=null where dev_acc_id in ( select out_dev_id from gms_device_moveapp_detail where moveapp_id ='"+moveappId+"' )";
				jdbcDao.executeUpdate(ucSql);
				// 删除单据明细记录
				String delSql = "delete from gms_device_moveapp_detail d where d.moveapp_id='"+ moveappId + "'";
				jdbcDao.executeUpdate(delSql);
				String devAccIds="";
				// 保存记录
				for (Object key : map.keySet()) {
					//保存单据明细记录
					if(((String)key).startsWith("out_dev_id")){
						int index=((String)key).lastIndexOf("_");
						String indexStr=((String)key).substring(index+1);
						String uuid = UUID.randomUUID().toString().replaceAll("-", "");
						String outDevId=(String)map.get("out_dev_id_"+indexStr);
						if("".equals(devAccIds)){
							devAccIds+="'"+outDevId+"'";
						}else{
							devAccIds+=",'"+outDevId+"'";
						}
						String sql ="insert into gms_device_moveapp_detail (move_det_id,moveapp_id,out_dev_id) values ('"+uuid+"','"+moveappId+"','"+outDevId+"')";
						sqlList.add(sql);
					}
				}
				if(CollectionUtils.isNotEmpty(sqlList)){
					String str[]=new String[sqlList.size()];
					String strings[]=sqlList.toArray(str);
					//批处理操作
					jdbcTemplate.batchUpdate(strings);
				}
				//更新单台台账流动变更管理(变更设备 所在单位 信息,0表示设备已锁定)
				if(!"".equals(devAccIds)){
					String updateSql="update gms_device_account set spare5='0' where dev_acc_id in ("+devAccIds+")";
					jdbcDao.executeUpdate(updateSql);
				}
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 修改单台设备转移变更记录
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateMoveappDetailInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("updateMoveappDetailInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String info = isrvmsg.getValue("info");
		//申请单id
		String moveappId = isrvmsg.getValue("moveapp_id");
		String inOrgId = isrvmsg.getValue("in_org_id");
		Map map = isrvmsg.toMap();
		try{
			//如果申请id不为空
			if(StringUtils.isNotBlank(moveappId)){
				// 验收
				if("ys".equals(info)){
					// 更新单据明细信息
					String dSql = "update  gms_device_moveapp_detail set in_dev_id=out_dev_id where moveapp_id='"+ moveappId + "'";
					jdbcDao.executeUpdate(dSql);
					// 更新单据信息，状态置为 已接收 状态
					String aSql="update gms_device_moveapp set state='2' where moveapp_id='"+ moveappId + "'";
					jdbcDao.executeUpdate(aSql);
					//更新 设备所在单位 信息,释放已锁定设备
					String oSql = "select sub.org_subjection_id,sub.org_id,info.org_abbreviation from comm_org_subjection sub"
							+ " left join comm_org_information info on sub.org_id=info.org_id and info.bsflag='0'"
							+ " where sub.bsflag='0' and sub.org_subjection_id='"+inOrgId+"' ";
					Map oMap=jdbcDao.queryRecordBySQL(oSql);
					String usageOrgId=oMap.get("org_id").toString();
					String usageOrgName=oMap.get("org_abbreviation").toString();
					String usageSubId=oMap.get("org_subjection_id").toString();
					String updateSql="update gms_device_account set spare5=null,usage_org_id='"+usageOrgId+"',usage_org_name='"+usageOrgName+"',usage_sub_id='"+usageSubId+"' where dev_acc_id in ( select out_dev_id from gms_device_moveapp_detail where moveapp_id ='"+moveappId+"' )";
					jdbcDao.executeUpdate(updateSql);
				}
				//退回(可以进行修改操作)
				if("th".equals(info)){
					// 释放已锁定设备
					//String updateSql="update gms_device_account set spare5=null where dev_acc_id in ( select out_dev_id from gms_device_moveapp_detail where moveapp_id ='"+moveappId+"' )";
					//jdbcDao.executeUpdate(updateSql);
					// 更新单据信息，状态置为 退回 状态
					String aSql="update gms_device_moveapp set state='3' where moveapp_id='"+ moveappId + "'";
					jdbcDao.executeUpdate(aSql);
				}
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 删除转移信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteMoveAppInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteMoveAppInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String id = isrvmsg.getValue("id");
		try{
			// 修改台账，释放锁定记录
			String updateSql="update gms_device_account set spare5=null where dev_acc_id in ( select out_dev_id from gms_device_moveapp_detail where moveapp_id ='"+id+"' )";
			jdbcDao.executeUpdate(updateSql);
			// 修改单据记录
			String dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
			String sql = "update gms_device_moveapp set bsflag='1',updator_id='"
					+ user.getUserId() + "',modifi_date=to_date('" + dt
					+ "','yyyy-mm-dd hh24:mi:ss') where moveapp_id = '" + id
					+ "'";
			jdbcDao.executeUpdate(sql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 车辆证照信息显示
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevLicInfo(ISrvMsg msg) throws Exception {
		log.info("queryDevLicInfo");
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
		String devname = msg.getValue("devname");
		String devmodel = msg.getValue("devmodel");
		String licensetype = msg.getValue("licensetype");
		String licensenum = msg.getValue("licensenum");
		String devsign = msg.getValue("devsign");
		String validday = msg.getValue("validday");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select case when valid_day <= 30 then 'red' when valid_day <= 90 then 'yellow' else 'green' end as warn,"
				+ " tmp.* from(select row_number() over(partition by gdl.dev_acc_id, gdl.license_type order by gdl.dev_end_date desc) rn,"
				+ " dev.dev_sign,dev.dev_acc_id,dev.dev_name,dev.dev_model,dev.license_num,dev.dev_coding,"
				+ " dev.asset_coding,dev.usage_org_id,gdl.dev_license_id,gdl.dev_reg_date,gdl.license_type,"
				+ " gdl.dev_start_date,gdl.dev_end_date,gdl.dev_cgs_name,gdl.dev_user_name,gdl.dev_zs_no,"
				+ " case gdl.license_type when '001' then '车辆行驶证' when '002' then '车辆道路运输证' when '003' then '危货运输车辆检测' when '004' then  '危险品运输证' "
				+ " when '005' then '车辆二级维护' end as license_type_name,gdl.last_audit_date,"
				+ " case when round(to_number(gdl.dev_end_date - trunc(sysdate))) < 0 then 0 else round(to_number(gdl.dev_end_date - trunc(sysdate))) end as valid_day "
				+ " from gms_device_account dev join gms_device_license gdl on gdl.dev_acc_id = dev.dev_acc_id and gdl.bsflag = '0'"
				+ " where dev.bsflag = '0' and dev.account_stat = '"+DevConstants.DEV_ACCOUNT_ZAIZHANG+"' and dev.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
				+ " and dev.dev_acc_id is not null ) tmp where rn = 1 ");
		//设备名称
		if (StringUtils.isNotBlank(devname)) {
			querySql.append(" and dev_name like '%"+devname+"%'");
		}
		//规格型号
		if (StringUtils.isNotBlank(devmodel)) {
			querySql.append(" and dev_model like '%"+devmodel+"%'");
		}
		//证照类型
		if (StringUtils.isNotBlank(licensetype)) {
			querySql.append(" and license_type like '%"+licensetype+"%'");
		}
		//车牌号
		if (StringUtils.isNotBlank(licensenum)) {
			querySql.append(" and license_num like '%"+licensenum+"%'");
		}
		//实物标识号
		if (StringUtils.isNotBlank(devsign)) {
			querySql.append(" and dev_sign like '%"+devsign+"%'");
		}
		//有效天数
		if (StringUtils.isNotBlank(validday)) {
			querySql.append(" and to_number(valid_day) < '"+validday+"'");
		}
		querySql.append(" order by license_type,dev_end_date,valid_day ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 查询车辆证照明细信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevLicDetInfo(ISrvMsg msg) throws Exception {
		log.info("queryDevLicDetInfo");
		String devlicense_id = msg.getValue("devlicenseid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		
		StringBuffer sb = new StringBuffer()
				.append("select dev.dev_type,dev.dev_acc_id,dev.dev_name, dev.dev_model,dev.license_num,dev.owning_org_id,"
					+ " org.org_abbreviation as owning_org_name,dev.asset_coding,dev.usage_org_id,usage.org_abbreviation as usage_org_name,"
					+ " dev.using_stat,usestat.coding_name as usestat_name, gdl.dev_license_id,gdl.dev_reg_date,dev.dev_coding,"
					+ " gdl.dev_start_date,gdl.dev_end_date,gdl.dev_cgs_name,gdl.dev_user_name,gdl.dev_zs_no,"
					+ " case gdl.license_type when '001' then '车辆行驶证' when '002' then '车辆道路运输证' when '003' then '危货运输车辆检测' when '004' then  '危险品运输证' "
					+ " when '005' then '车辆二级维护' end as license_type_name,gdl.dev_gd_bsflag,gdl.dev_sx_bsflag,sd.coding_name as cycle_name,gdl.last_audit_date,gdl.validate_end"
					+ " from gms_device_account dev join gms_device_license gdl on gdl.dev_acc_id = dev.dev_acc_id and gdl.bsflag = '0'"
					+ " left join comm_org_information usage on usage.org_id = dev.usage_org_id and usage.bsflag = '0'"
					+ " left join comm_coding_sort_detail usestat on usestat.coding_code_id = dev.using_stat and usestat.bsflag = '0'"
					+ " left join comm_org_information org on org.org_id = dev.owning_org_id and org.bsflag = '0'"
					+ " left join comm_coding_sort_detail sd on sd.coding_code_id = gdl.dev_audie_cycle and sd.bsflag = '0'"
					+ " where dev.bsflag = '0' and gdl.dev_license_id = '"+devlicense_id+"'");
		
		Map devLicMap = jdbcDao.queryRecordBySQL(sb.toString());
		if(devLicMap!=null){
			responseMsg.setValue("devLicMap", devLicMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD
	 * 车辆证照审验明细
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryLicAuiditInfo(ISrvMsg msg) throws Exception {
		log.info("queryLicAuiditInfo");
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
		String devaccid = msg.getValue("devaccid");
		String licensetype = msg.getValue("licensetype");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select distinct dev.dev_name,dev.dev_model,dev.license_num,dev.dev_coding,gdl.dev_start_date,gdl.dev_end_date,"
				+ " case gdl.license_type when '001' then '车辆行驶证' when '002' then '车辆道路运输证' when '003' then '危货运输车辆检测' when '004' then  '危险品运输证' "
				+ " when '005' then '车辆二级维护' end as license_type_name,gdl.last_audit_date"
				+ " from gms_device_account dev join gms_device_license gdl on gdl.dev_acc_id = dev.dev_acc_id and gdl.bsflag = '0'"
				+ " where dev.dev_acc_id = '"+devaccid+"' and gdl.license_type = '"+licensetype+"' order by gdl.dev_end_date desc");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}

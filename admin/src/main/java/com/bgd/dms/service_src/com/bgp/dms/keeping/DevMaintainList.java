package com.bgp.dms.keeping;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.mcs.service.mat.util.ExcelEIResolvingUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

public class DevMaintainList extends BaseService{
	
	public DevMaintainList() {
		log = LogFactory.getLogger(DevMaintainList.class);
	}
	
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询保养信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMaintainDevList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryMaintainDevList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String s_dev_name = isrvmsg.getValue("s_dev_name");// 车牌号码
		String s_dev_model = isrvmsg.getValue("s_dev_model");// 设备类别
		String s_license_num = isrvmsg.getValue("s_license_num");// 设备名称
		String s_self_num = isrvmsg.getValue("s_self_num");// 业务类型
		String s_dev_sign = isrvmsg.getValue("s_dev_sign");// 业务类型
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select mp.fk_dev_acc_id,acc.dev_name,acc.dev_model,acc.self_num,"
				+ "acc.license_num,acc.dev_sign,pla.plan_date - sysdate+1 date1,pla.plan_date "
				+ "from gms_device_maintenance_plan mp "
				+ "left join (select mp.fk_dev_acc_id,min(mp.plan_date) plan_date "
				+ "from gms_device_maintenance_plan mp "
				+ "left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id "
				+ "where acc.bsflag = '0' "
				+ "and mp.plan_date - sysdate > -1 "
				+ "group by mp.fk_dev_acc_id) pla on pla.fk_dev_acc_id = mp.fk_dev_acc_id "
				+ "left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id "
				+ "where acc.bsflag = '0' "
				+ "and acc.project_info_no is null "
				+ "and mp.fk_dev_acc_id is not null ");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and acc.DEV_NAME like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and acc.DEV_MODEL like '%"+s_dev_model+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and acc.license_num like '%"+s_license_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_self_num)) {
			querySql.append(" and acc.self_num like '%"+s_self_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_sign)) {
			querySql.append(" and acc.dev_sign like '%"+s_dev_sign+"%' ");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and acc.owning_sub_id like '"+orgSubId+"%' " );
			}
		}
		querySql.append(" group by mp.fk_dev_acc_id, acc.dev_name, acc.dev_model, acc.self_num, acc.license_num, acc.dev_sign, pla.plan_date ");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by date1 nulls first,mp.fk_dev_acc_id ");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 加载详细信息
	 * 
	 */
	public ISrvMsg getMaintainDevInfo(ISrvMsg msg) throws Exception {
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
		String fk_dev_acc_id = msg.getValue("fk_dev_acc_id");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select mp.fk_dev_acc_id,mp.plan_date, mp.plan_num,acc.dev_name,acc.dev_model, "
				+ "mp.mileage,mp.work_hour,acc.self_num,acc.license_num "
				+ "from gms_device_maintenance_plan mp "
				+ "left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id "
				+ "where acc.bsflag = '0' and "
				+ " mp.plan_date > sysdate "
				+ "and fk_dev_acc_id ='"+fk_dev_acc_id+"' order by mp.plan_date");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 多项目保养计划删除
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delDeviceAccMaintenancePlan(ISrvMsg msg) throws Exception {
		String fkDevId = msg.getValue("fkDevId"); // 主台帐ID
		// 保养次数
		if (fkDevId != null) {
			String sql = "delete from gms_device_maintenance_plan t where t.fk_dev_acc_id = '"+ fkDevId +"'";
			jdbcDao.executeUpdate(sql);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * 加载保养详细信息
	 * 
	 */
	public ISrvMsg getMaintainInfo(ISrvMsg msg) throws Exception {
		//查询详细信息
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String devAccId = msg.getValue("devAccId");
		
		StringBuffer querySql = new StringBuffer();
		querySql.append("select acc.dev_acc_id fk_dev_acc_id,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,acc.dev_coding,max(info.repair_end_date) last_date, "
				+"nvl(max(oper.mileage_total),0) as mileage ,nvl(max(oper.drilling_footage_total),0) as footage ,nvl(max(oper.work_hour_total),0) as work_hour "
				+"from GMS_DEVICE_ACCOUNT acc left join BGP_COMM_DEVICE_REPAIR_INFO info on acc.dev_acc_id = info.device_account_id "
				+"left join GMS_DEVICE_OPERATION_INFO oper on acc.dev_acc_id = oper.dev_acc_id "
				+"where acc.bsflag='0' and acc.dev_acc_id='"+devAccId+"' "
				+"group by acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,acc.dev_coding, acc.dev_acc_id");
		Map mixMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		//查询未到时间的保养计划
		StringBuffer sql = new StringBuffer();
		sql.append("select mp.fk_dev_acc_id,mp.plan_date, mp.plan_num,acc.dev_name,acc.dev_model, "
				+ "mp.mileage,mp.work_hour,acc.self_num,acc.license_num,mp.maintenance_id  "
				+ "from gms_device_maintenance_plan mp "
				+ "left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id "
				+ "where acc.bsflag = '0' and mp.dev_acc_id is null and mp.project_info_id is null "
				+ "and mp.fk_dev_acc_id is not null and mp.plan_date > sysdate and acc.dev_acc_id = '"+devAccId+"' "
				+ "order by mp.plan_date" );
		List<Map> mixMaps = jdbcDao.queryRecords(sql.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("datas", mixMaps);
		}
		return responseMsg;
	}
	
	
	/**
	 * 删除指定信息
	 */
	public ISrvMsg deleteMaintainPlanInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteMaintainPlanInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String maintenance_id = isrvmsg.getValue("maintenance_id");// 设备验收id
		try{
			String delsql = "delete from gms_device_maintenance_plan t where t.maintenance_id = '"+ maintenance_id +"'";
			jdbcDao.executeUpdate(delsql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD
	 * 增加修改验收准备信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDeviceAccMaintenancePlan(ISrvMsg isrvmsg) throws Exception {
		log.info("saveDeviceAccMaintenancePlan");
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> strMap = new HashMap<String,Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String flag= (String)map.get("flag");
		String fk_dev_acc_id = (String)map.get("fk_dev_acc_id");
		System.out.println(flag);
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			for (Object key : map.keySet()) {
				//如果有需要删除的数据，保存其删除sql
				if(((String)key).startsWith("del_tr_")){
					Map delMap = new HashMap();
					String maintenance_id = (String)map.get(key);
					String delsql = "delete from gms_device_maintenance_plan t where t.maintenance_id = '"+ maintenance_id +"'";
					jdbcDao.executeUpdate(delsql);
				}
				if(((String)key).startsWith("maintenance_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					String plan_date = "to_date('"+(String)map.get("plan_date_"+indexStr)+"','yyyy-MM-dd')";
					String mileage = (String)map.get("mileage_"+indexStr);
					String work_hour = (String)map.get("work_hour_"+indexStr);
					String date = "to_date('"+currentdate+"','yyyy-MM-dd HH24:mi:ss')";
					if(mileage==""){
						mileage = null;
					}
					if(work_hour==""){
						work_hour = null;
					}
					//保存生成的sql，主键为空值，保存否则修改
					if(null==map.get("maintenance_id_"+indexStr) || StringUtils.isBlank(map.get("maintenance_id_"+indexStr).toString())){
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						String addsql = "INSERT INTO gms_device_maintenance_plan (maintenance_id, fk_dev_acc_id, plan_date, mileage, work_hour, creator, create_date) "
								+ "VALUES ('"+iuuid+"','"+fk_dev_acc_id+"',"+plan_date+","+mileage+","+work_hour+",'"+employee_id+"',"+date+")";
						//jdbcDao.executeUpdate(addsql);
						sqlList.add(addsql);
					}else{
						String maintenance_id = (String)map.get("maintenance_id_"+indexStr);//保存表主键
						String upsql = "UPDATE gms_device_maintenance_plan SET fk_dev_acc_id = '"+fk_dev_acc_id+"', plan_date = "+plan_date+" ,"
								+ "mileage = "+mileage+",work_hour = "+work_hour+",updator = '"+employee_id+"', modifi_date = "+date+" "
										+ " WHERE maintenance_id = '"+maintenance_id+"'";
						//jdbcDao.executeUpdate(upsql);
						sqlList.add(upsql);
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//批处理操作
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}	
	
}

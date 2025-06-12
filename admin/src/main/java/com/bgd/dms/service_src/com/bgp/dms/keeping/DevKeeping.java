package com.bgp.dms.keeping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.bgp.mcs.service.doc.service.MyUcm;
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
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;
import com.cnpc.jcdp.util.DateUtil;

public class DevKeeping extends BaseService{
	

	public DevKeeping() {
		log = LogFactory.getLogger(DevKeeping.class);
	}
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询设备出入库信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryKeepingConfInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryKeepingConfInfoList");
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
		String dev_num = isrvmsg.getValue("q_dev_num");// 车牌号码
		String dev_type = isrvmsg.getValue("q_dev_type");// 设备类别
		String dev_name = isrvmsg.getValue("q_dev_name");// 设备名称
		String thing_type = isrvmsg.getValue("q_thing_type");// 业务类型
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.keeping_id,t.dev_name,t.dev_tname,t.dev_num,t.turn_date,"
				+ "t.keeping_date,info.org_abbreviation sub_org_id,t.dev_sign,t.self_num,"
				+ "case when t.thing_type = '1' then '入库' when t.thing_type = '-1' then '出库' else 'error' end as thing_type,"
				+ "case when t.dev_type like 'S0808%' then '船舶' " 		//船舶
				+ "when t.dev_type like 'S14050101%' then '地震仪器主机' "   //地震仪器主机
				+ "when t.dev_type like 'S0623%' then '可控震源' "       //可控震源
				+ "when t.dev_type like 'S1404%' then '测量设备' "       //测量设备
				+ "when t.dev_type like 'S060101%' then '车装钻机' "     //车装钻机
				+ "when t.dev_type like 'S060102%' then '人抬化钻机' "     //人抬化钻机
				+ "when t.dev_type like 'S070301%' then '推土机' "     //推土机
				+ "when t.dev_type like 'S0622%' then '仪器车' "       //仪器车
				+ "when t.dev_type like 'S08%' then '运输设备' "         //运输设备
				+ "when t.dev_type like 'S0901%' then '发电机组' "      //发电机组
				+ "end as dev_type "
				+ "from dms_device_keeping t "
				+ "left join comm_org_information info "
				+ "on t.sub_org_id = info.org_id "
				+ "left join comm_org_subjection sub "
				+ "on t.sub_org_id = sub.org_id "
				+ "where t.bsflag = '0'");

		if (StringUtils.isNotBlank(dev_num)) {
			querySql.append(" and t.dev_num like '%" + dev_num + "%'");
		}
		if (StringUtils.isNotBlank(dev_type)) {
			querySql.append(" and t.dev_type like '%" + dev_type + "%'");
		}
		if (StringUtils.isNotBlank(dev_name)) {
			querySql.append(" and t.dev_name like '%" + dev_name + "%'");
		}
		if (StringUtils.isNotBlank(thing_type)) {
			querySql.append(" and t.thing_type = '" + thing_type + "' ");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and sub.org_subjection_id  like '"+orgSubId+"%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc,t.modify_date desc,t.keeping_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询设备出入库信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryKeepingConfInfoViewList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryKeepingConfInfoViewList");
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
		String dev_num = isrvmsg.getValue("q_dev_num");// 车牌号码
		String dev_type = isrvmsg.getValue("q_dev_type");// 设备类别
		String dev_name = isrvmsg.getValue("q_dev_name");// 设备名称
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.keeping_id,t.dev_name,t.dev_tname,t.dev_num,t.turn_date,"
				+ "t.keeping_date,info.org_abbreviation sub_org_id,t.dev_sign,t.self_num,"
				+ "case when t.thing_type = '1' then '入库' when t.thing_type = '-1' then '出库' else 'error' end as thing_type,"
				+ "case when t.dev_type like 'S0808%' then '船舶' " 		//船舶
				+ "when t.dev_type like 'S14050101%' then '地震仪器主机' "   //地震仪器主机
				+ "when t.dev_type like 'S0623%' then '可控震源' "       //可控震源
				+ "when t.dev_type like 'S1404%' then '测量设备' "       //测量设备
				+ "when t.dev_type like 'S060101%' then '车装钻机' "     //车装钻机
				+ "when t.dev_type like 'S060102%' then '人抬化钻机' "     //人抬化钻机
				+ "when t.dev_type like 'S070301%' then '推土机' "     //推土机
				+ "when t.dev_type like 'S0622%' then '仪器车' "       //仪器车
				+ "when t.dev_type like 'S08%' then '运输设备' "         //运输设备
				+ "when t.dev_type like 'S0901%' then '发电机组' "      //发电机组
				+ "end as dev_type "
				+ "from dms_device_keeping t "
				+ "left join comm_org_information info "
				+ "on t.sub_org_id = info.org_id "
				+ "left join comm_org_subjection sub "
				+ "on t.sub_org_id = sub.org_id "
				+ "where t.bsflag = '0' and t.thing_type = '1' ");

		if (StringUtils.isNotBlank(dev_num)) {
			querySql.append(" and t.dev_num like '%" + dev_num + "%'");
		}
		if (StringUtils.isNotBlank(dev_type)) {
			querySql.append(" and t.dev_type like '%" + dev_type + "%'");
		}
		if (StringUtils.isNotBlank(dev_name)) {
			querySql.append(" and t.dev_name like '%" + dev_name + "%'");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and sub.org_subjection_id  like '"+orgSubId+"%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc,t.modify_date desc,t.keeping_id");
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
	public ISrvMsg getKeepingConfInfo(ISrvMsg msg) throws Exception {
		String keeping_id = msg.getValue("keeping_id");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select t.*,t.position_id provposcode,info.org_abbreviation out_org_name from dms_device_keeping t "
				+ "left join comm_org_information info on t.sub_org_id = info.org_id "
				+ "left join comm_org_subjection sub on t.sub_org_id = sub.org_id "
				+ "where t.bsflag = '0' and t.keeping_id='"+keeping_id+"'");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		// 查询文件表
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ keeping_id + "' and t.bsflag='0' and t.is_file='1' ";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseMsg.setValue("fdataPublic", list2);// 附件
		return responseMsg;
	}
	
	
	/**
	 * 删除指定信息
	 */
	public ISrvMsg deleteKeepingInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteKeepingInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		String keeping_id = isrvmsg.getValue("keeping_id");// id
		try{
			String sql = "select * from dms_device_keeping p where p.bsflag='0'"
					+ " and p.thing_type='1' and p.keeping_id = '"+keeping_id+"'";
			Map mixMap = jdbcDao.queryRecordBySQL(sql);
			if (MapUtils.isEmpty(mixMap)) {
				//删除验收通知
				String delSql = "update dms_device_keeping set bsflag='1' where keeping_id ='"+keeping_id+"'";
				jdbcDao.executeUpdate(delSql);
				operationFlag = "success";
			}else{
				operationFlag = "keepin";
			}	
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 加载设备当前状态
	 * 
	 */
	public ISrvMsg getKeepingPosition(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String orgSubId = user.getSubOrgIDofAffordOrg();
		String code = "";
		String note = "";
		//塔里木物探处
		if(orgSubId.indexOf("C105001005")!= -1){code="910600"; note="塔里木";};
		//新疆物探处
		if(orgSubId.indexOf("C105001002")!= -1){code="910200"; note="新疆";};
		//吐哈物探处
		if(orgSubId.indexOf("C105001003")!= -1){code="910300"; note="吐哈";};
		//青海物探处
		if(orgSubId.indexOf("C105001004")!= -1){code="910400"; note="青海";};
		//长庆物探处
		if(orgSubId.indexOf("C105005004")!= -1){code="910700"; note="长庆";};
		//华北物探处
		if(orgSubId.indexOf("C105005000")!= -1){code="910500"; note="华北";};
		//新兴物探开发处
		if(orgSubId.indexOf("C105005001")!= -1){code="910900"; note="新兴";};
		//大港物探处
		if(orgSubId.indexOf("C105007")!= -1){code="911000"; note="大港";};
		//辽河物探处
		if(orgSubId.indexOf("C105063")!= -1){code="910800"; note="辽河";};
		//综合物化处
		if(orgSubId.indexOf("C105008")!= -1){code="911100"; note="综合";};
		//装备服务处
		if(orgSubId.indexOf("CC105006")!= -1){code="910100"; note="装备";};
		Map<String,String> map=new HashMap<String,String>();  
		map.put("code",code);
		map.put("note",note);		
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * 加载设备当前状态
	 * 
	 */
	public ISrvMsg getKeepingDevInfo(ISrvMsg msg) throws Exception {
		String dev_id = msg.getValue("dev_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select sum(t.thing_type) as thing_type from dms_device_keeping t "
					+ "where t.bsflag = '0' and t.dev_id='"+dev_id+"'");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseDTO.setValue("data", mixMap);
		}
		return responseDTO;
	}
		
	/**
	 * NEWMETHOD
	 * 修改验收通知信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateKeepingConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateKeepingConfInfo");
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> strMap = new HashMap<String,Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String dev_type = (String)map.get("dev_type");
		String dev_name = (String)map.get("dev_name");
		String dev_tname = (String)map.get("dev_tname");
		String dev_num = (String)map.get("dev_num");
		String dev_sign = (String)map.get("dev_sign");
		String dev_id = (String)map.get("dev_id");
		String self_num = (String)map.get("self_num");
		String thing_type = (String)map.get("thing_type");
		String sub_org_id = (String)map.get("sub_org_id");
		String turn_date = (String)map.get("turn_date");
		String keeping_date = (String)map.get("keeping_date");
		String turn_pp = (String)map.get("turn_pp");
		String keeping_pp = (String)map.get("keeping_pp");
		String dev_turn_num = (String)map.get("dev_turn_num");
		String given_pp = (String)map.get("given_pp");
		String dev_clean = (String)map.get("dev_clean");
		String mark_num = (String)map.get("mark_num");
		String port_num = (String)map.get("port_num");
		String key_num = (String)map.get("key_num");
		String tool_num = (String)map.get("tool_num");
		String freezing_point = (String)map.get("freezing_point");
		String spare_tire_num = (String)map.get("spare_tire_num");
		String fire_extinguisher = (String)map.get("fire_extinguisher");
		String other = (String)map.get("other");
		String keeping_position = (String)map.get("provpos");
		String position_id = (String)map.get("provposcode");
		String flag= (String)map.get("flag");
		String keeping_id = "";//保存表主键
		System.out.println(flag);
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//保存操作
				Map mainMap=new HashMap();
				mainMap.put("dev_type", dev_type);//指标名称
				mainMap.put("dev_name", dev_name);//年度
				mainMap.put("dev_tname", dev_tname);
				mainMap.put("dev_num", dev_num);
				mainMap.put("dev_sign", dev_sign);
				mainMap.put("dev_id", dev_id);
				mainMap.put("self_num", self_num);
				mainMap.put("thing_type", thing_type);
				mainMap.put("sub_org_id", sub_org_id);
				mainMap.put("turn_date", turn_date);//指标名称
				mainMap.put("keeping_date", keeping_date);//年度
				mainMap.put("turn_pp", turn_pp);//指标名称
				mainMap.put("keeping_pp", keeping_pp);//年度
				mainMap.put("dev_turn_num", dev_turn_num);
				mainMap.put("given_pp", given_pp);
				mainMap.put("dev_clean", dev_clean);
				mainMap.put("mark_num", mark_num);
				mainMap.put("port_num", port_num);
				mainMap.put("key_num", key_num);//指标名称
				mainMap.put("tool_num", tool_num);//年度
				mainMap.put("freezing_point", freezing_point);
				mainMap.put("spare_tire_num", spare_tire_num);
				mainMap.put("fire_extinguisher", fire_extinguisher);
				mainMap.put("other", other);
				mainMap.put("keeping_position", keeping_position);
				mainMap.put("position_id", position_id);
				mainMap.put("creater", employee_id);
				mainMap.put("create_date", currentdate);
				mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				ServiceUtils.setCommFields(mainMap, "keeping_id", user);
				keeping_id = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_device_keeping");
				String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
				String plan_date = "add_months(to_date('"+keeping_date+"','yyyy-MM-dd'),3)";
				String date = "to_date('"+currentdate+"','yyyy-MM-dd HH24:mi:ss')";
				String addsql = "INSERT INTO gms_device_maintenance_plan (maintenance_id, fk_dev_acc_id, plan_date, creator, create_date) "
						+ "VALUES ('"+iuuid+"','"+dev_id+"',"+plan_date+",'"+employee_id+"',"+date+")";
				jdbcDao.executeUpdate(addsql);
				//更新设备返还列表的KEEPING_FLAG为1，以保证同一个返还列表的设备在添加了设备入库之后不被再次入库
				String updatesql ="update gms_device_backapp_detail dt set dt.KEEPING_FLAG=1 "
						+ "where dt.dev_acc_id="+dev_id;
				jdbcDao.executeUpdate(updatesql);
			}else{//修改操作
				keeping_id=(String)map.get("keeping_id");
				Map umainMap=new HashMap();
				umainMap.put("keeping_id", keeping_id);//指标名称
				umainMap.put("dev_type", dev_type);//指标名称
				umainMap.put("dev_name", dev_name);//年度
				umainMap.put("dev_tname", dev_tname);
				umainMap.put("dev_num", dev_num);
				umainMap.put("dev_sign", dev_sign);
				umainMap.put("dev_id", dev_id);
				umainMap.put("self_num", self_num);
				umainMap.put("thing_type", thing_type);
				umainMap.put("sub_org_id", sub_org_id);
				umainMap.put("turn_date", turn_date);//指标名称
				umainMap.put("keeping_date", keeping_date);//年度
				umainMap.put("turn_pp", turn_pp);//指标名称
				umainMap.put("keeping_pp", keeping_pp);//年度
				umainMap.put("dev_turn_num", dev_turn_num);
				umainMap.put("given_pp", given_pp);
				umainMap.put("dev_clean", dev_clean);
				umainMap.put("mark_num", mark_num);
				umainMap.put("port_num", port_num);
				umainMap.put("key_num", key_num);//指标名称
				umainMap.put("tool_num", tool_num);//年度
				umainMap.put("freezing_point", freezing_point);
				umainMap.put("spare_tire_num", spare_tire_num);
				umainMap.put("fire_extinguisher", fire_extinguisher);
				umainMap.put("other", other);
				umainMap.put("keeping_position", keeping_position);
				umainMap.put("position_id", position_id);
				umainMap.put("updator", employee_id);
				umainMap.put("modify_date", currentdate);
				umainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				ServiceUtils.setCommFields(umainMap, "keeping_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_device_keeping");
			}
			//存储附件操作
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			List<WSFile> filesOther = mqMsgOther.getFiles();
			Map<String, Object> doc = new HashMap<String, Object>();
			MyUcm ucm = new MyUcm();
			String filename = "";
			String fileOrder = "";
			String ucmDocId = "";
			try {// 处理附件
				for (WSFile file : filesOther) {
					filename = file.getFilename();
					fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
					ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", keeping_id);
					doc.put("file_type", fileOrder);
					doc.put("file_name", filename);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("creator_id", user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("create_date", currentdate);
					if("-1".equals(thing_type)){
						doc.put("doc_type", "5110000211000000002");
					}else{
						doc.put("doc_type", "5110000211000000001");
					}
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					// 附件表
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					// 日志表
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
							user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
				}
			} catch (Exception e) {
				System.out.println("附件未插入或修改");
			}
		} catch (Exception e) {
			e.printStackTrace();
			operationFlag = "failed";
		}
		return responseDTO;
	}
	
	/**
	 * 加载详细信息
	 * 
	 */
	public ISrvMsg getProvinceConfInfo(ISrvMsg msg) throws Exception {
		log.info("getProvinceConfInfo");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String pos_name = msg.getValue("pos_name");
		String querySql = "select t.pos_id from gms_device_position t where t.pos_name = '"+pos_name+"'";
		Map mixMap = jdbcDao.queryRecordBySQL(querySql);
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		return responseMsg;
	}
	
	
	/**
	 * NEWMETHOD 显示所有设备(单台)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevAccData(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		//String zhEquSub = msg.getValue("zhequsub");//是否为综合物化探
		//String addEd = msg.getValue("added");//是否为补充设备
		//String collFlag = msg.getValue("collflag");//是否为装备出库"：装备出库可以选择整个装备服务处设备
		//String dgEquSub = msg.getValue("dgequsub");
		String subOrgId = msg.getValue("suborgid");
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String ownOrgName = msg.getValue("ownorgname");
		String devCoding = msg.getValue("devcoding");
		String assetCoding = msg.getValue("assetcoding");
		String objData = msg.getValue("objdata");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		/*querySql.append("select org.org_abbreviation as own_org_name,acc.* from "
						+ " ( select account.* "
						+ " from gms_device_backapp_detail backdet "
						+ " inner join gms_device_account_dui account on backdet.dev_acc_id = account.dev_acc_id "
						+ " where backdet.device_backapp_id in(select backapp.device_backapp_id "
						+ " from gms_device_backapp backapp "
						+ " left join comm_org_information org on backapp.back_org_id = org.org_id and org.bsflag = '0' "
						+ " left join comm_org_information recv on recv.org_id = backapp.receive_org_id and recv.bsflag = '0' "
						+ " left join comm_human_employee emp on backapp.back_employee_id = emp.employee_id "
						+ " left join gp_task_project pro on backapp.project_info_id = pro.project_info_no " 
						+ " where backapp.bsflag = '0' and backapp.backdevtype != 'S1405' "
						+ " and (backapp.backapptype = '1' or backapp.backapptype = '4')) and backdet.KEEPING_FLAG is null) acc"
						+ " left join comm_org_information org on acc.owning_org_id = org.org_id and org.bsflag = '0' "
				 		+ " where acc.bsflag = '0' ");*/
		querySql.append("select org.org_abbreviation as own_org_name,acc.* from gms_device_backapp_detail backdet"
				+ " left join gms_device_account_dui accdui on backdet.dev_acc_id = accdui.dev_acc_id"
				+ " left join gms_device_account acc on accdui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag = '0'"
				+ " left join gms_device_backapp backapp on backdet.device_backapp_id = backapp.device_backapp_id"
				+ " left join comm_org_information org on acc.owning_org_id = org.org_id and org.bsflag = '0'"
				+ " where backdet.keeping_flag is null and backapp.bsflag = '0' and backapp.backdevtype != 'S1405'"
				+ " and backapp.backapptype = '4' and acc.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		/*if(DevUtil.isValueNotNull(outOrgId)){
			if(DevUtil.isValueNotNull(outOrgId,"Y")){
				querySql.append(" and (acc.owning_sub_id like 'C105008042%' or acc.owning_sub_id like '%C105008013%' ) ");
			}else{
					querySql.append(" and ((acc.owning_sub_id like '"+outOrgId+"%' and acc.usage_sub_id is null) "
									+ "or acc.usage_sub_id like '"+outOrgId+"%')");
			}		
		}
		if(DevUtil.isValueNotNull(addEd,"Y")){//装备要求补充设备不能出震源只能是附属设备
			querySql.append(" and acc.dev_type not like 'S0623%' ");
		}*/
		//设备名称
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//设备型号
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '"+devModel+"%'");
		}
		//自编号
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and acc.self_num like '%"+selfNum+"%'");
		}
		//实物标识号
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and acc.dev_sign like '%"+devSign+"%'");
		}
		//牌照号
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and acc.license_num like '%"+licenseNum+"%'");
		}
		//所在单位
		if (StringUtils.isNotBlank(ownOrgName)) {
			querySql.append(" and org.org_abbreviation like '%"+ownOrgName+"%'");
		}
		//ERP设备编号
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and acc.dev_coding like '%"+devCoding+"%'");
		}
		//AMIS资产编号
		if (StringUtils.isNotBlank(assetCoding)) {
			querySql.append(" and acc.asset_coding like '%"+assetCoding+"%'");
		}
		if(DevUtil.isValueNotNull(objData)){
			querySql.append(" and acc.dev_acc_id not in("+objData+")");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",acc.dev_acc_id ");
		}else{
/*			if(DevUtil.isValueNotNull(collFlag,"Y")){
				querySql.append(" order by case"
						+ " when acc.dev_type like 'S0808%' then 1" 		//船舶
						+ " when acc.dev_type like 'S14050101%' then 2"   //地震仪器主机
						+ " when acc.dev_type like 'S0623%' then 3"       //可控震源
						+ " when acc.dev_type like 'S1404%' then 4"       //测量设备
						+ " when acc.dev_type like 'S060101%' then 5"     //车装钻机
						+ " when acc.dev_type like 'S060102%' then 6"     //人抬化钻机
						+ " when acc.dev_type like 'S070301%' then 7"     //推土机
						+ " when acc.dev_type like 'S0622%' then 8"       //仪器车
						+ " when acc.dev_type like 'S08%' then 9"         //运输设备
						+ " when acc.dev_type like 'S0901%' then 10"      //发电机组
						+ " end,acc.dev_model,acc.dev_sign,acc.dev_acc_id ");
			}else{*/
				querySql.append(" order by case"
						+ " when acc.dev_type like 'S08%' then 1" 		  //船舶
						+ " when acc.dev_type like 'S070301%' then 2"     //推土机
						+ " when acc.dev_type like 'S060101%' then 3"     //车装钻机
						+ " when acc.dev_type like 'S060102%' then 4"     //人抬化钻机
						+ " when acc.dev_type like 'S0901%' then 5"       //发电机组
						+ " when acc.dev_type like 'S1404%' then 6"       //测量设备
						+ " when acc.dev_type like 'S14050101%' then 7"   //地震仪器主机
						+ " when acc.dev_type like 'S0623%' then 8"       //可控震源
						+ " when acc.dev_type like 'S0622%' then 9"       //仪器车
						+ " end,acc.dev_model,acc.dev_sign,acc.dev_acc_id ");
//			}
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD 显示全部设备(单台)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevAllAcc(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		String orgSubId = user.getSubOrgIDofAffordOrg();
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String devCoding = msg.getValue("devcoding");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select account.* ,org.org_abbreviation as own_org_name "
				+ " from gms_device_account account "
				+ " left join comm_org_information org on account.owning_org_id = org.org_id and org.bsflag = '0' "
				+ " where account.bsflag = '0' "
				+ "and account.project_info_no is null "
				+ "and account.account_stat in "
				+ "('0110000013000000003', '0110000013000000001', '0110000013000000006') "
				+ "and (account.dev_type like 'S06%' or account.dev_type like 'S07%' or "
				+ "account.dev_type like 'S08%' or account.dev_type like 'S09%' or "
				+ "account.dev_type like 'S1507%') ");
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and account.owning_sub_id like '"+orgSubId+"%'" );
			}
		}
		//设备名称
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and account.dev_name like '%"+devName+"%'");
		}
		//设备型号
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and account.dev_model like '"+devModel+"%'");
		}
		//自编号
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and account.self_num like '%"+selfNum+"%'");
		}
		//实物标识号
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and account.dev_sign like '%"+devSign+"%'");
		}
		//牌照号
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and account.license_num like '%"+licenseNum+"%'");
		}
		//ERP设备编号
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and account.dev_coding like '%"+devCoding+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",account.dev_acc_id ");
		}else{
			querySql.append(" order by case"
					+ " when dev_type like 'S08%' then 1" 		  //船舶
					+ " when dev_type like 'S070301%' then 2"     //推土机
					+ " when dev_type like 'S060101%' then 3"     //车装钻机
					+ " when dev_type like 'S060102%' then 4"     //人抬化钻机
					+ " when dev_type like 'S0901%' then 5"       //发电机组
					+ " when dev_type like 'S1404%' then 6"       //测量设备
					+ " when dev_type like 'S14050101%' then 7"   //地震仪器主机
					+ " when dev_type like 'S0623%' then 8"       //可控震源
					+ " when dev_type like 'S0622%' then 9"       //仪器车
					+ " end,account.dev_model,account.dev_sign,account.dev_acc_id ");
		}

		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	
}

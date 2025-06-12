package com.bgp.dms.check;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
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

public class CheckDevReady extends BaseService{
	
	public CheckDevReady() {
			log = LogFactory.getLogger(CheckDevReady.class);
	}
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询验收准备列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCheckReadyInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckReadyInfoList");
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
		String ck_cid = isrvmsg.getValue("ck_cid");// 验收单号
		String apply_num = isrvmsg.getValue("apply_num");
		String pact_num = isrvmsg.getValue("pact_num");
		String ck_sector = isrvmsg.getValue("ck_sector");
		String ck_outcome = isrvmsg.getValue("ck_outcome");
		
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*, t2.org_abbreviation ck_sectors " +
			      "from dms_device_check t " 
				+ "left join comm_org_information t2 on t2.org_id = t.ck_sector "
				+ "left join comm_org_subjection t4 on t4.org_id = t.ck_sector "
				+ "left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "
				+ "where t.bsflag=0 ");
		// 验收单号
		System.out.println(querySql);
		if (StringUtils.isNotBlank(ck_cid)) {
			querySql.append(" and t.ck_cid like '%" + ck_cid + "%'");
		}
		if (StringUtils.isNotBlank(apply_num)) {
			querySql.append(" and t.apply_num like '%" + apply_num + "%'");
		}
		if (StringUtils.isNotBlank(pact_num)) {
			querySql.append(" and t.pact_num like '%" + pact_num + "%'");
		}
		if (StringUtils.isNotBlank(ck_sector)) {
			querySql.append(" and t.ck_sector like '%" + ck_sector + "%'");
		}
		if (StringUtils.isNotBlank(ck_outcome)) {
			querySql.append(" and t.ck_outcome like '%" + ck_outcome + "%'");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and t4.org_subjection_id  like '%" + orgSubId + "%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.ck_status,t.create_date desc,t.apply_num desc");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getCheckConfInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ck_id = isrvmsg.getValue("ck_id");// id
		String sql = "select t.*,t2.org_abbreviation ck_sectors "
				+ "from dms_device_check t "
				+ "left join comm_org_information t2 on t2.org_id = t.ck_sector "
			    + "left join comm_org_subjection t4 on t.ck_sector=t4.org_id "
		        + "left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "
				+ "where  t.ck_id='"+ck_id+"'";
		Map maps=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("data", maps);
		return responseDTO;
	}
	
	/**
	 * 查询详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheck(ISrvMsg isrvmsg) throws Exception {
		log.info("getCheck");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ck_id = isrvmsg.getValue("ck_id");// id
		String sql = "select t.* "
				+ "from dms_device_check t "
				+ "where  t.ck_id='"+ck_id+"' and t.ck_status='已验收'";
		Map maps=jdbcDao.queryRecordBySQL(sql);
		if(maps==null || maps.size()==0){
			responseDTO.setValue("operationFlag", operationFlag);
			return responseDTO;
		}
		operationFlag = "failed";
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 删除指定信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteCheckConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteCheckConfInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String ck_id = isrvmsg.getValue("ck_id");// 设备验收id
		try{
			//删除指定信息
			String delSql = "update dms_device_check set bsflag='1' where ck_id='"+ck_id+"' and ck_status='未验收'";
			jdbcDao.executeUpdate(delSql);
			responseDTO.setValue("operationFlag", operationFlag);
			return responseDTO;
		}catch(Exception e){
			operationFlag = "failed";
		}
		return responseDTO;
	}
	
	/**
	 * 获取验收列表详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckItemInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getCheckItemInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ck_id = isrvmsg.getValue("ck_id");// 验收id
		String msql = "select t.*,t2.org_abbreviation ck_sectors "
				+ " from dms_device_check t "
				+ "left join comm_org_information t2 on t2.org_id = t.ck_sector "
				+ "left join comm_org_subjection t4 on t.ck_sector=t4.org_id "
			    + "left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "
				+ " where t.ck_id = '"+ck_id+"' ";
		Map map=jdbcDao.queryRecordBySQL(msql);
		//获取验收设备信息
		String  sql = "select d.* "
				+ "from dms_device_check t,dms_device_check_device d "
				+ "where t.ck_id = '"+ck_id+"' and d.ck_id=t.ck_id and d.bsflag = 0";
		List<Map> list= jdbcDao.queryRecords(sql);
		//获取验收人员信息
		String  sqls = "select p.*,t2.org_abbreviation ps_sectors "
				+ "from dms_device_check t,dms_device_check_person p "
				+ "left join comm_org_information t2 on t2.org_id = p.ps_sector "
				+ "left join comm_org_subjection t4 on p.ps_sector=t4.org_id "
			    + "left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "
				+ "where p.ck_id = '"+ck_id+"' and p.ck_id=t.ck_id and p.bsflag = 0 ";
		List<Map> lists= jdbcDao.queryRecords(sqls);
		responseDTO.setValue("data", map);
		responseDTO.setValue("datas", list);
		responseDTO.setValue("datass", lists);
		return responseDTO;
	}

	/**
	 * NEWMETHOD
	 * 增加修改验收准备信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg saveOrUpdateCheckReadyInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateCheckReadyInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String apply_num = (String) map.get("apply_num");
		String ck_company = (String) map.get("ck_company");
		String ck_company_score = (String) map.get("ck_company_score");
		String ck_sector = (String) map.get("ck_sector");
		String pact_num = (String) map.get("pact_num");
		String flag = (String) map.get("flag");
		String ck_cid = (String) map.get("ck_cid");
		String ck_id = "";// 保存表主键

		// 存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if ("add".equals(flag)) {// 保存操作
				Map<String, Object> mainMap = new HashMap<String, Object>();
				mainMap.put("ck_cid", ck_cid);
				mainMap.put("apply_num", apply_num);// 指标名称
				mainMap.put("pact_num", pact_num);
				mainMap.put("ck_company", ck_company);
				mainMap.put("ck_company_score", ck_company_score);
				mainMap.put("creater", employee_id);
				mainMap.put("ck_sector", ck_sector);
				mainMap.put("ck_status", "未验收");
				mainMap.put("create_date", currentdate);
				mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				mainMap.put("checkflag", DevConstants.BSFLAG_NORMAL);
				mainMap.put("checkdelflag", DevConstants.BSFLAG_NORMAL);
				ServiceUtils.setCommFields(mainMap, "ck_id", user);
				ck_id = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_device_check");
				
				isrvmsg.setValue("ck_id", ck_id);
				isrvmsg.setValue("flag", "update");
				isrvmsg.replaceValue("ck_id", ck_id);
				isrvmsg.replaceValue("flag", "update");
			} else {// 修改操作
				ck_id = (String) map.get("ck_id");
				Map<String, Object> umainMap = new HashMap<String, Object>();
				umainMap.put("ck_id", ck_id);
				umainMap.put("ck_cid", ck_cid);
				umainMap.put("ck_sector", ck_sector);
				umainMap.put("apply_num", apply_num);// 指标名称
				umainMap.put("pact_num", pact_num);
				umainMap.put("ck_company", ck_company);
				umainMap.put("ck_company_score", ck_company_score);
				umainMap.put("updator", employee_id);
				umainMap.put("modify_date", currentdate);
				umainMap.put("ck_status", "已验收");
				umainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				umainMap.put("checkflag", DevConstants.BSFLAG_NORMAL);
				umainMap.put("checkdelflag", DevConstants.BSFLAG_NORMAL);
				ServiceUtils.setCommFields(umainMap, "ck_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_device_check");
			}

			for (Object key : map.keySet()) {
				Set set = map.keySet();
				System.out.println(set);
				// 如果有需要删除的数据，保存其删除sql
				if (((String) key).startsWith("del_tr_dev_")) {
					Map<String, String> delMap = new HashMap<String, String>();
					delMap.put("dev_id", (String) map.get(key));
					delMap.put("bsflag", "1");
					sqlList.add(assembleSql(delMap, "dms_device_check_device", null, "update", "dev_id"));
				}
				if (((String) key).startsWith("dev_id")) {
					int index = ((String) key).lastIndexOf("_");
					String indexStr = ((String) key).substring(index + 1);
					// 保存生成的sql，主键为空值，保存否则修改
					if ("000".equals(map.get("dev_id_" + indexStr))) {
						Map<String, String> aMap = new HashMap<String, String>();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("dev_id", iuuid);
						aMap.put("ck_id", ck_id);
						aMap.put("dev_name", (String) map.get("dev_name_" + indexStr));
						aMap.put("dev_model", (String) map.get("dev_model_" + indexStr));
						aMap.put("dev_num", (String) map.get("dev_num_" + indexStr));
						aMap.put("dev_producer", (String) map.get("dev_producer_" + indexStr));
						aMap.put("dev_type", (String) map.get("dev_type_" + indexStr));
						aMap.put("creater", employee_id);
						aMap.put("create_date", "to_date('" + currentdate + "','yyyy-MM-dd HH24:mi:ss')");
						aMap.put("bsflag", "0");
						sqlList.add(assembleSql(aMap, "dms_device_check_device",
								new String[] { "create_date", "dev_num" }, "add", ""));
					} else {
						Map<String, String> uMap = new HashMap<String, String>();
						uMap.put("dev_id", (String) map.get("dev_id_" + indexStr));
						uMap.put("ck_id", (String) map.get("ck_id"));
						uMap.put("dev_name", (String) map.get("dev_name_" + indexStr));
						uMap.put("dev_model", (String) map.get("dev_model_" + indexStr));
						uMap.put("dev_num", (String) map.get("dev_num_" + indexStr));
						uMap.put("dev_producer", (String) map.get("dev_producer_" + indexStr));
						uMap.put("dev_type", (String) map.get("dev_type_" + indexStr));
						uMap.put("updator", employee_id);
						uMap.put("modify_date", "to_date('" + currentdate + "','yyyy-MM-dd HH24:mi:ss')");
						sqlList.add(assembleSql(uMap, "dms_device_check_device",
								new String[] { "modify_date", "dev_num" }, "update", "dev_id"));
					}
				}
				// 如果有需要删除的数据，保存其删除sql
				if (((String) key).startsWith("del_tr_ps_")) {
					Map<String, String> delMap = new HashMap<String, String>();
					delMap.put("ps_id", (String) map.get(key));
					delMap.put("bsflag", "1");
					sqlList.add(assembleSql(delMap, "dms_device_check_person", null, "update", "ps_id"));
				}
				if (((String) key).startsWith("ps_id")) {
					int index = ((String) key).lastIndexOf("_");
					String indexStr = ((String) key).substring(index + 1);
					// 保存生成的sql，主键为空值，保存否则修改
					if ("000".equals(map.get("ps_id_" + indexStr))) {
						Map<String, String> aMap = new HashMap<String, String>();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("ps_id", iuuid);
						aMap.put("ck_id", ck_id);
						aMap.put("ps_name", (String) map.get("ps_name_" + indexStr));
						aMap.put("ps_sector", (String) map.get("ps_sector_" + indexStr));
						aMap.put("ps_sex", (String) map.get("ps_sex_" + indexStr));
						aMap.put("ps_job", (String) map.get("ps_job_" + indexStr));
						aMap.put("creater", employee_id);
						aMap.put("create_date", "to_date('" + currentdate + "','yyyy-MM-dd HH24:mi:ss')");
						aMap.put("bsflag", "0");
						sqlList.add(assembleSql(aMap, "dms_device_check_person", new String[] { "create_date" }, "add", ""));
					} else {
						Map<String, String> uMap = new HashMap<String, String>();
						uMap.put("ps_id", (String) map.get("ps_id_" + indexStr));
						uMap.put("ck_id", (String) map.get("ck_id"));
						uMap.put("ps_name", (String) map.get("ps_name_" + indexStr));
						uMap.put("ps_sector", (String) map.get("ps_sector_" + indexStr));
						uMap.put("ps_sex", (String) map.get("ps_sex_" + indexStr));
						uMap.put("ps_job", (String) map.get("ps_job_" + indexStr));
						uMap.put("updator", employee_id);
						uMap.put("modify_date", "to_date('" + currentdate + "','yyyy-MM-dd HH24:mi:ss')");
						sqlList.add(assembleSql(uMap, "dms_device_check_person", new String[] { "modify_date" }, "update", "ps_id"));
					}
				}
			}
			if (CollectionUtils.isNotEmpty(sqlList)) {
				String str[] = new String[sqlList.size()];
				String strings[] = sqlList.toArray(str);
				// 批处理操作
				jdbcTemplate.batchUpdate(strings);
			}
			
			// 验收信息
			new CheckDevDo().saveOrUpdateCheckDoInfo(isrvmsg);
		} catch (Exception e) {
			e.printStackTrace();
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 生成操作语句
	 * @param data
	 * @param tableName
	 * @param arr
	 * @param oFlag
	 * @return
	 */
	public String assembleSql(Map data, String tableName, String[] arr, String oFlag, String pkColumn) {
		String tempSql = "";
		if ("add".equals(oFlag)) {
			tempSql += "insert into " + tableName + "(";
			String values = "";
			Object[] keys = data.keySet().toArray();

			for (int i = 0; i < keys.length; i++) {
				tempSql += keys[i].toString() + ",";
				boolean flag = false;
				if (null != arr) {
					for (int j = 0; j < arr.length; j++) {
						if (keys[i].toString().equals(arr[j])) {
							flag = true;
							break;
						}
					}
				}
				if (null == data.get(keys[i].toString())
						|| StringUtils.isBlank(data.get(keys[i].toString()).toString())) {
					values += "null,";
				} else {
					if (flag) {
						values += data.get(keys[i].toString()) + ",";
					} else {
						values += "'" + data.get(keys[i].toString()) + "',";
					}
				}
			}
			tempSql = tempSql.substring(0, tempSql.length() - 1);
			values = values.substring(0, values.length() - 1);
			tempSql += ") values (" + values + ") ";
		}
		if ("update".equals(oFlag)) {
			tempSql += "update  " + tableName + " set ";
			Object[] keys = data.keySet().toArray();

			for (int i = 0; i < keys.length; i++) {
				tempSql += keys[i].toString() + "=";
				boolean flag = false;
				if (null != arr) {
					for (int j = 0; j < arr.length; j++) {
						if (keys[i].toString().equals(arr[j])) {
							flag = true;
							break;
						}
					}
				}
				if (null == data.get(keys[i].toString())
						|| StringUtils.isBlank(data.get(keys[i].toString()).toString())) {
					tempSql += "null,";
				} else {
					if (flag) {
						tempSql += data.get(keys[i].toString()) + ",";
					} else {
						tempSql += "'" + data.get(keys[i].toString()) + "',";
					}
				}
			}
			tempSql = tempSql.substring(0, tempSql.length() - 1);
			tempSql += " where " + pkColumn + "='" + data.get(pkColumn).toString() + "'";
		}
		return tempSql;
	}
	
}

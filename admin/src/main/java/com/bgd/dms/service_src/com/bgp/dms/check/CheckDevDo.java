package com.bgp.dms.check;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
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
import com.cnpc.jcdp.util.DateUtil;

public class CheckDevDo extends BaseService{
	
	public CheckDevDo() {
		log = LogFactory.getLogger(CheckDevDo.class);	
	}
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询验收列表信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCheckDoInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckDoInfoList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals("")) {
			currentPage = "1";
		}
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String ck_cid = isrvmsg.getValue("ck_cid");// 验收单号
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t2.org_abbreviation ck_sectors "
				+ "from dms_device_check t "
				+ "left join comm_org_information t2 on t2.org_id = t.ck_sector "
				+ "left join comm_org_subjection t4 on t.ck_sector=t4.org_id "
				+ "left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "
				+ "where t.bsflag=0 and t.checkdelflag=0");
		// 验收单号
		if (StringUtils.isNotBlank(ck_cid)) {
			querySql.append(" and t.ck_cid like '%" + ck_cid + "%'");
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
	 * 加载详细信息
	 * 
	 */
	public ISrvMsg getCheckDofInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getCheckDofInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ck_id = isrvmsg.getValue("ck_id");// 设备验收id
		String msql = "select t.*,t2.org_abbreviation ck_sectors "
				+ "from dms_device_check t "
				+ "left join comm_org_information t2 on t2.org_id = t.ck_sector "
				+ "left join comm_org_subjection t4 on t.ck_sector=t4.org_id "
			    + "left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "
				+ "where  t.ck_id='"+ck_id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		//查询问题信息
		String sql = "select q.* from dms_device_check_question q，dms_device_check t where t.ck_id = q.ck_id and q.ck_id='"+ck_id+"' and q.bsflag=0";
		List<Map> list= jdbcDao.queryRecords(sql);
		
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ ck_id + "' and t.bsflag='0' and t.is_file='1' ";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseDTO.setValue("fdataPublic", list2);//附件
		responseDTO.setValue("data", map);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 删除指定信息
	 */
	public ISrvMsg deleteCheckDoInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteCheckDoInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String ck_id = isrvmsg.getValue("ck_id");// 设备验收id
		try{
			//删除验收信息
			String delSql = "update dms_device_check_question set bsflag='1' where question_id in (select q.question_id from dms_device_check_question q,dms_device_check t where t.ck_id='"+ck_id+" and q.question_id = t.question_id')";
			jdbcDao.executeUpdate(delSql);
			String delSql0 = "update dms_device_check set checkdelflag='1' where ck_id='"+ck_id+"'";
			jdbcDao.executeUpdate(delSql0);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}


	/**
	 * NEWMETHOD
	 * 修改验收信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({"rawtypes"})
	public ISrvMsg saveOrUpdateCheckDoInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateCheckDoInfo");
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		System.out.println("=============================================");
		String ck_id = (String) map.get("ck_id");// 保存表主键
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String pact_num = (String) map.get("pact_num");
		String ck_cid = (String) map.get("ck_cid");
		String ck_date = (String) map.get("ck_date");
		String sar_date = (String) map.get("sar_date");
		String num_right = "on".equals(map.get("num_right")) ? "1" : "0";
		String name_right = "on".equals(map.get("name_right")) ? "1" : "0";
		String pg_right = "on".equals(map.get("pg_right")) ? "1" : "0";
		String pg_corrode = "on".equals(map.get("pg_corrode")) ? "1" : "0";
		String kname_right = "on".equals(map.get("kname_right")) ? "1" : "0";
		String thing_right = "on".equals(map.get("thing_right")) ? "1" : "0";
		String injure_right = "on".equals(map.get("injure_right")) ? "1" : "0";
		String function_right = "on".equals(map.get("function_right")) ? "1" : "0";
		String card_right = "on".equals(map.get("card_right")) ? "1" : "0";
		String data_right = "on".equals(map.get("data_right")) ? "1" : "0";
		String ck_sector = (String) map.get("ck_sector");
		String ck_pyperson = (String) map.get("ck_pyperson");
		String ck_conclusion = (String) map.get("ck_conclusion");
		String ck_outcome = (String) map.get("ck_outcome");
		String flag = (String) map.get("flag");
		System.out.println(flag);
		// 存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if ("update".equals(flag)) {// 保存操作
				Map<String, Object> umainMap = new HashMap<String, Object>();
				umainMap.put("ck_id", ck_id);// 指标名称
				umainMap.put("ck_date", ck_date);// 指标名称
				umainMap.put("sar_date", sar_date);// 年度
				umainMap.put("num_right", num_right);
				umainMap.put("name_right", name_right);
				umainMap.put("pg_right", pg_right);
				umainMap.put("pg_corrode", pg_corrode);
				umainMap.put("kname_right", kname_right);// 指标名称
				umainMap.put("thing_right", thing_right);// 年度
				umainMap.put("injure_right", injure_right);
				umainMap.put("function_right", function_right);
				umainMap.put("card_right", card_right);
				umainMap.put("data_right", data_right);
				umainMap.put("ck_sector", ck_sector);// 指标名称
				umainMap.put("ck_pyperson", ck_pyperson);// 年度
				umainMap.put("ck_conclusion", ck_conclusion);
				umainMap.put("ck_outcome", ck_outcome);
				umainMap.put("updator_id", employee_id);
				umainMap.put("modify_date", currentdate);
				umainMap.put("ck_status", "已验收");// 年度
				umainMap.put("checkflag", "1");
				umainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				ServiceUtils.setCommFields(umainMap, "ck_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_device_check");
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		for (Object key : map.keySet()) {
			// 如果有需要删除的数据，保存其删除sql
			if (((String) key).startsWith("del_tr_")) {
				Map<String, String> delMap = new HashMap<String, String>();
				delMap.put("question_id", (String) map.get(key));
				delMap.put("bsflag", "1");
				sqlList.add(assembleSql(delMap, "dms_device_check_question", null, "update", "question_id"));
			}
			if (((String) key).startsWith("question_id")) {
				int index = ((String) key).lastIndexOf("_");
				String indexStr = ((String) key).substring(index + 1);
				// 保存生成的sql，主键为空值，保存否则修改
				if ("000".equals(map.get("question_id_" + indexStr))) {
					Map<String, String> aMap = new HashMap<String, String>();
					String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
					aMap.put("question_id", iuuid);
					aMap.put("ck_id", ck_id);
					aMap.put("question_instruction", (String) map.get("question_instruction_" + indexStr));
					aMap.put("y_date", "to_date('" + (String) map.get("y_date_" + indexStr) + "','yyyy-MM-dd')");
					aMap.put("question_info", (String) map.get("question_info_" + indexStr));
					// aMap.put("pact_num", pact_num);
					aMap.put("ck_cid", ck_cid);
					aMap.put("question_info", "未解决");
					aMap.put("creator_id", employee_id);
					aMap.put("create_date", "to_date('" + currentdate + "','yyyy-MM-dd HH24:mi:ss')");
					aMap.put("bsflag", "0");
					sqlList.add(assembleSql(aMap, "dms_device_check_question", new String[] { "y_date", "create_date" },
							"add", ""));
				} else {
					Map<String, String> uMap = new HashMap<String, String>();
					uMap.put("question_id", (String) map.get("question_id_" + indexStr));
					uMap.put("ck_id", (String) map.get("ck_id"));
					uMap.put("question_instruction", (String) map.get("question_instruction_" + indexStr));
					// uMap.put("pact_num", pact_num);
					uMap.put("ck_cid", ck_cid);
					uMap.put("y_date", "to_date('" + (String) map.get("y_date_" + indexStr) + "','yyyy-MM-dd')");
					uMap.put("question_info", "未解决");
					uMap.put("updator", employee_id);
					uMap.put("modify_date", "to_date('" + currentdate + "','yyyy-MM-dd HH24:mi:ss')");
					sqlList.add(assembleSql(uMap, "dms_device_check_question", new String[] { "y_date", "modify_date" },
							"update", "question_id"));
				}
			}
		}
		if (CollectionUtils.isNotEmpty(sqlList)) {
			String str[] = new String[sqlList.size()];
			String strings[] = sqlList.toArray(str);
			// 批处理操作
			jdbcTemplate.batchUpdate(strings);
		}
		// 附件上传
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		Map<String, Object> doc = new HashMap<String, Object>();
		MyUcm ucm = new MyUcm();
		String filename = "";
		String fileOrder = "";
		String ucmDocId = "";
		try {
			// 处理附件
			for (WSFile file : filesOther) {
				filename = file.getFilename();
				fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
				ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", ck_id);
				doc.put("file_type", fileOrder);
				doc.put("file_name", filename);
				doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("create_date", currentdate);
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				if ("ck_list".equals(fileOrder)) {
					doc.put("doc_type", "5110000202000000001");
				}
				if ("nck_list".equals(fileOrder)) {
					doc.put("doc_type", "5110000202000000002");
				}
				if ("ck_posts".equals(fileOrder)) {
					doc.put("doc_type", "5110000202000000003");
				}
				if ("ck_post_many".equals(fileOrder)) {
					doc.put("doc_type", "5110000202000000004");
				}
				// 附件表
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				// 日志表
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
						user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("附件未修改");
		}
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
	public String assembleSql(Map data,String tableName,String[] arr,String oFlag,String pkColumn){
		String tempSql="";
		if("add".equals(oFlag)){
			tempSql += "insert into "+ tableName +"(";
			String values = "";
			Object[] keys =  data.keySet().toArray();
			
			for(int i=0;i<keys.length;i++){
				tempSql+= keys[i].toString() + ",";
				boolean flag = false;
				if(null!=arr){
					for(int j=0;j<arr.length;j++){
						if(keys[i].toString().equals(arr[j])){
							flag = true;
							break;
						}
					}
				}
				if(null== data.get(keys[i].toString()) || StringUtils.isBlank( data.get(keys[i].toString()).toString())){
					values += "null,";
				}else{
					if(flag){
						values += data.get(keys[i].toString())+",";
					}else{
						values += "'"+data.get(keys[i].toString())+"',";
					}
				}
			}
			tempSql = tempSql.substring(0, tempSql.length()-1);
			values = values.substring(0, values.length()-1);
			tempSql+=") values ("+values+") ";
		}
		if("update".equals(oFlag)){
			tempSql += "update  "+ tableName +" set ";
			Object[] keys =  data.keySet().toArray();
			
			for(int i=0;i<keys.length;i++){
				tempSql+= keys[i].toString() + "=";
				boolean flag = false;
				if(null!=arr){
					for(int j=0;j<arr.length;j++){
						if(keys[i].toString().equals(arr[j])){
							flag = true;
							break;
						}
					}
				}
				if(null== data.get(keys[i].toString()) || StringUtils.isBlank( data.get(keys[i].toString()).toString())){
					tempSql += "null,";
				}else{
					if(flag){
						tempSql += data.get(keys[i].toString())+",";
					}else{
						tempSql += "'"+data.get(keys[i].toString())+"',";
					}
				}
			}
			tempSql = tempSql.substring(0, tempSql.length()-1);
			tempSql+=" where "+pkColumn+"='"+data.get(pkColumn).toString()+"'";
		}
		return tempSql;
	}
	
}

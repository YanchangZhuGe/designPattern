package com.bgp.dms.modelSelection.modelapply;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import com.cnpc.jcdp.log.LogFactory;
import com.bgp.dms.check.CheckDevReady;
import com.bgp.dms.util.EquipmentStants;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
import net.sf.json.JSONArray;

public class EquipmentParMan extends BaseService{
	
	public EquipmentParMan() {
		log = LogFactory.getLogger(CheckDevReady.class);
	}
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	/**
	 * �豸����   ����/�޸�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg addEquipmentPreAdd(ISrvMsg isrvmsg) throws Exception {
		log.info("addEquipmentPreAdd");
		UserToken user = isrvmsg.getUserToken();
		String whole =isrvmsg.getValue("whole");   // �豸��������
		String flag =(String)isrvmsg.getValue("flag");   // ����/�޸ı��
		String parameter_ids = isrvmsg.getValue("ids");   // ����ID
		// ��ǰ�豸����
		String current_device_type ="";
		// ��ǰ�豸����ID
		String current_device_type_id ="";
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		if(parameter_ids.equals("null") && "add".equals(flag)){
			queryScrapeInfoSql.append("select d.* from DMS_EXPLORTATION_TREE d where d.bsflag ='0'");
			if (!whole.equals("null")) {
				queryScrapeInfoSql.append(" and d.whole  = '" + whole + "'");
			}
			Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
			current_device_type = (String) deviceappMap.get("name");
			current_device_type_id = (String) deviceappMap.get("id");
		}else{
			queryScrapeInfoSql.append("select d.* from DMS_EQUIPMENT_PARAMETERS d where d.bsflag ='0'");
			if (!parameter_ids.equals("null")) {
				queryScrapeInfoSql.append(" and d.parameter_ids  = '" + parameter_ids + "'");
			}
			Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
			current_device_type = (String) deviceappMap.get("current_device_type");
			current_device_type_id = (String) deviceappMap.get("current_device_type_id");
		}
		Map map = isrvmsg.toMap();
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		try{
			for (Object key : map.keySet()) {	
				if(((String)key).startsWith("parameter_ids")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if(null==map.get("parameter_ids_"+indexStr) || StringUtils.isBlank(map.get("parameter_ids_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("parameter_ids", iuuid);
						// ��������
						String parameter_name =isrvmsg.getValue("parameter_name_" + indexStr);
						StringBuffer queryDmsEquParId = new StringBuffer();
						queryDmsEquParId.append(" select l.* from dms_equipment_parameters l where l.bsflag='0'");
						if (StringUtils.isNotBlank(parameter_name)) {
							queryDmsEquParId.append(" and l.parameter_name  = '" + parameter_name + "'");
						}
						Map deviceapp = jdbcDao.queryRecordBySQL(queryDmsEquParId.toString());
						String parameter_id ="";
						if(deviceapp ==null){
							// ����id
							parameter_id = UUID.randomUUID().toString().replaceAll("-", "");
							aMap.put("parameter_id", parameter_id);
						}else{
							parameter_id =(String) deviceapp.get("parameter_id");
							aMap.put("parameter_id", parameter_id);
						}
						aMap.put("parameter_name", isrvmsg.getValue("parameter_name_" + indexStr));
						aMap.put("current_device_type", current_device_type);
						aMap.put("current_device_type_id", current_device_type_id);
						aMap.put("creater", user.getEmpId());
						aMap.put("create_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						aMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(aMap,"DMS_EQUIPMENT_PARAMETERS",new String[] {"create_date"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("parameter_ids", (String)map.get("parameter_ids_"+indexStr));
						// ��������
						String parameter_name =isrvmsg.getValue("parameter_name_" + indexStr);
						StringBuffer queryDmsEquParId = new StringBuffer();
						queryDmsEquParId.append(" select l.* from dms_equipment_parameters l where l.bsflag='0'");
						if (StringUtils.isNotBlank(parameter_name)) {
							queryDmsEquParId.append(" and l.parameter_name  = '" + parameter_name + "'");
						}
						Map deviceapp = jdbcDao.queryRecordBySQL(queryDmsEquParId.toString());
						String parameter_id ="";
						if(deviceapp ==null){
							// ����id
							parameter_id = UUID.randomUUID().toString().replaceAll("-", "");
							uMap.put("parameter_id", parameter_id);
						}else{
							parameter_id =(String) deviceapp.get("parameter_id");
							uMap.put("parameter_id", parameter_id);
						}
						
						uMap.put("parameter_name", isrvmsg.getValue("parameter_name_" + indexStr));
						uMap.put("current_device_type", current_device_type);
						uMap.put("current_device_type_id", current_device_type_id);
						uMap.put("updatetor", user.getEmpId());
						uMap.put("modify_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						uMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						List<String> sqlListSize = new ArrayList<String>();
						sqlListSize.add("update dms_equ_par_table t set t.parameter_name ='" + isrvmsg.getValue("parameter_name_" + indexStr) + "' where t.table_whole_id  = '"+ (String)map.get("parameter_ids_"+indexStr) + "' and t.bsflag='0'");
						String strS[]=new String[sqlListSize.size()];
						String stringsS[]=sqlListSize.toArray(strS);
						//���������
						jdbcTemplate.batchUpdate(stringsS);
						sqlList.add(assembleSql(uMap,"dms_equipment_parameters",new String[] {"modify_date"},"update","parameter_ids"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
}
		
	/**
	 * ���ɲ������
	 * @param data
	 * @param tableName
	 * @param arr
	 * @param oFlag
	 * @return
	 */
	@SuppressWarnings("rawtypes")
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

	
	
	/**
	 *  ��ѯ�豸���ܹ�����Ϣ
	 * @param isrvmsg       ��������ֵ
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg selTree(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id = isrvmsg.getValue("id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select d.* from DMS_EXPLORTATION_TREE d where bsflag ='0'");
		// Tree �Ƿ��������
		if (StringUtils.isBlank(id)) {
			queryScrapeInfoSql.append(" and d.id  = '" + id + "'");
		}
		// �������
		queryScrapeInfoSql.append(" order by d.id asc");
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryScrapeInfoSql+"");
		JSONArray retJson = JSONArray.fromObject(list);
		responseDTO.setValue("json", retJson.toString());
		return responseDTO;
		
	}
	
	/**
	 * ɾ�� �豸����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg todeleteEquPar(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String deviceId = isrvmsg.getValue("updateids");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// ��Ŀ��ID
		mainMap.put("parameter_ids", deviceId);
		// �޸���
		mainMap.put("updatetor", user.getEmpId());
		// �޸�ʱ��
		mainMap.put("modify_date", createdate);
		// ɾ�����
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "dms_equipment_parameters");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;

	}
	
	/**
	 *  ��ѯ�豸����
	 * @param isrvmsg       ��������ֵ
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getCurrentType(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String parameter_ids = isrvmsg.getValue("parameter_ids");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select t.* from dms_equipment_parameters t");
		if (StringUtils.isNotBlank(parameter_ids)) {
			queryScrapeInfoSql.append(" where t.parameter_ids  = '" + parameter_ids + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		return responseDTO;
		
	}
	
	/**
	 *  �豸����ҳ��ѡ��
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getEquipmentInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//������ϸ��Ϣ
		String parameter_ids=msg.getValue("parameter_ids");
		StringBuffer queryAssetForDeviceSql = new StringBuffer();
		queryAssetForDeviceSql.append("select * from dms_equipment_parameters d where ");
		if (StringUtils.isNotBlank(parameter_ids)) {
			queryAssetForDeviceSql.append(" d.parameter_ids  = '"+parameter_ids+"'");
		}		
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryAssetForDeviceSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	
	
	/**
	 * ɾ���豸����
	 */

	public ISrvMsg deleteEquPar(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String parameter_ids = isrvmsg.getValue("parameter_ids");
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// �豸��������id
		mainMap.put("parameter_ids", parameter_ids);
		// �޸���
		mainMap.put("updatetor", user.getEmpId());
		// �޸�ʱ��
		mainMap.put("modify_date", createdate);
		// ɾ�����
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		// û�б������뵥����Ϣ����������뵥�Ļ�����Ϣ
		
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "dms_equipment_parameters");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 *  ��̽��¼ҳ��ѡ��
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getExplorationList(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//������ϸ��Ϣ
		String equipment_id=msg.getValue("equipment_id");
		StringBuffer queryAssetForDeviceSql = new StringBuffer();
		queryAssetForDeviceSql.append("select * from DMS_EXPLORATION_LIST d where d.bsflag='0'");
		if (StringUtils.isNotBlank(equipment_id)) {
			queryAssetForDeviceSql.append("and d.equipment_id  = '"+equipment_id+"'");
		}		
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryAssetForDeviceSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	
	
	/**
	 *  ��ѯ��̽��¼
	 * @param isrvmsg       ��������ֵ
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getExplorationType(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String equipment_id = isrvmsg.getValue("equipment_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		StringBuffer queryScrapeInfoSqlDevice = new StringBuffer();
		queryScrapeInfoSql.append("select t.* from DMS_EXPLORATION_LIST t where t.bsflag='0'");
		if (!equipment_id.equals("null")) {
			queryScrapeInfoSql.append(" and t.equipment_id  = '" + equipment_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap ==null){
			return responseDTO;
		}
		String equipment_ids =(String) deviceappMap.get("equipment_ids");
		queryScrapeInfoSqlDevice.append(" select * from DMS_EXPLORATION_LIST l left join dms_equ_par_table t on l.equipment_ids=t.current_device_type_id where l.bsflag='0'");
		if (StringUtils.isNotBlank(equipment_ids)) {
			queryScrapeInfoSqlDevice.append(" and l.equipment_ids  = '" + equipment_ids + "'");
		}
		// �������
		queryScrapeInfoSqlDevice.append(" order by l.equipment_id asc");
		Map deviceappMapDevice = jdbcDao.queryRecordBySQL(queryScrapeInfoSqlDevice.toString());
		
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMapDevice);
		}
		
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryScrapeInfoSqlDevice.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		
		// ��ѯ�ļ���
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ equipment_id + "' and t.bsflag='0' and t.is_file='1' ";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// �ļ�����
		responseDTO.setValue("fdataPublic", list2);// ѡ��������Ӧ����
		
		
		return responseDTO;
		
	}
	 
	 
	/**
	 * ��ӿ�̽��¼
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ISrvMsg addEquipmentList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		// �豸id
		String equipment_id = isrvmsg.getValue("equipment_id");
		String mid = isrvmsg.getValue("equipment_ids");
		String id = isrvmsg.getValue("id");
		//String pid = isrvmsg.getValue("pid");
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// ����豸����
		String equipment_name = isrvmsg.getValue("equipment_name").trim();
		// ����豸�ͺ�
		String equipment_model = isrvmsg.getValue("equipment_model").trim();
		// ����豸����						 
		String equipment_code = isrvmsg.getValue("equipment_code").trim();
		// �����������
		String manufacturer = isrvmsg.getValue("manufacturer").trim();
		// ��ñ�ע
		String bak = isrvmsg.getValue("bak").trim();
		String flag= (String)isrvmsg.getValue("flag");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		Map map = isrvmsg.toMap();
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if (equipment_id.equals("null") && "add".equals(flag)) {
				if(mid.equals("null")){
					mid = UUID.randomUUID().toString().replaceAll("-", "");
				}
				queryScrapeInfoSql.append("select d.* from DMS_EXPLORTATION_TREE d where d.bsflag ='0'");
				if (!id.equals("null")) {
					queryScrapeInfoSql.append(" and d.id  = '" + id + "'");
				}
				Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				String current_device_type = (String) deviceappMap.get("name");
				
				strMap.put("equipment_name", equipment_name);
				strMap.put("current_device_type", current_device_type);
				strMap.put("current_device_type_id", id);
				strMap.put("equipment_model", equipment_model);
				strMap.put("equipment_code", equipment_code);
				strMap.put("manufacturer", manufacturer);
				strMap.put("bak", bak);
				strMap.put("creater", user.getEmpId());
				strMap.put("create_date", createdate);
				strMap.put("equipment_ids", mid);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				Serializable dis_id = jdbcDao.saveOrUpdateEntity(strMap, "DMS_EXPLORATION_LIST");
				equipment_id =(String) dis_id;
				
			} else{
				strMap.put("equipment_id", equipment_id);
				strMap.put("equipment_ids", mid);
				strMap.put("equipment_name", equipment_name);
				strMap.put("equipment_model", equipment_model);
				strMap.put("equipment_code", equipment_code);
				strMap.put("manufacturer", manufacturer);
				strMap.put("bak", bak);
				strMap.put("updatetor", user.getEmpId());
				strMap.put("modify_date", createdate);
				strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
				jdbcDao.saveOrUpdateEntity(strMap, "DMS_EXPLORATION_LIST");
			}
			// ����������ֵkey).su
			for (Object key : map.keySet()) {
				if(((String)key).startsWith("whole")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if("000".equals(map.get("whole_"+indexStr))){
						Map aMap = new HashMap();
						// ����id
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("whole", iuuid);
						// �豸����id
						aMap.put("current_device_type_id", mid);
						// �豸����
						aMap.put("CURRENT_DEVICE_TYPE", equipment_name);
						// ��������
						String parameter_name = isrvmsg.getValue("parameter_name_" + indexStr);
						aMap.put("parameter_name", parameter_name);
						// �豸��������ID
						String table_whole_id = isrvmsg.getValue("parameter_ids_" + indexStr);
						aMap.put("table_whole_id", table_whole_id);
						StringBuffer queryDmsEquParId = new StringBuffer();
						queryDmsEquParId.append(" select l.* from dms_equipment_parameters l where l.bsflag='0'");
						if (StringUtils.isNotBlank(parameter_name)) {
							queryDmsEquParId.append(" and l.parameter_name  = '" + parameter_name + "'");
						}
						Map deviceapp = jdbcDao.queryRecordBySQL(queryDmsEquParId.toString());
						String parameter_id = "";
						if(deviceapp ==null){
							// ����id
							parameter_id = UUID.randomUUID().toString().replaceAll("-", "");
							aMap.put("parameter_id", parameter_id);
						}else{
							parameter_id =(String) deviceapp.get("parameter_id");
							aMap.put("parameter_id", parameter_id);
						}
						// ����
						String parameter = isrvmsg.getValue("parameter_" + indexStr);
						aMap.put("parameter", parameter);
						aMap.put("creater", user.getEmpId());
						aMap.put("create_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						aMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(aMap,"DMS_EQU_PAR_TABLE",new String[] {"create_date"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("whole", (String)map.get("whole_"+indexStr));
						// �豸����id
						uMap.put("current_device_type_id", mid);
						// �豸����
						uMap.put("CURRENT_DEVICE_TYPE", equipment_name);
						String parameter_name = isrvmsg.getValue("parameter_name_" + indexStr);
						uMap.put("parameter_name", parameter_name);
						// �豸��������ID
						String table_whole_id = isrvmsg.getValue("parameter_ids_" + indexStr);
						uMap.put("table_whole_id", table_whole_id);
						StringBuffer queryDmsEquParId = new StringBuffer();
						queryDmsEquParId.append(" select l.* from dms_equipment_parameters l where l.bsflag='0'");
						if (!parameter_name.equals("null")) {
							queryDmsEquParId.append(" and l.parameter_name  = '" + parameter_name + "'");
						}
						Map deviceapp = jdbcDao.queryRecordBySQL(queryDmsEquParId.toString());
						String parameter_id ="";
						if(deviceapp ==null){
							// ����id
							parameter_id = UUID.randomUUID().toString().replaceAll("-", "");
							uMap.put("parameter_id", parameter_id);
						}else{
							parameter_id =(String) deviceapp.get("parameter_id");
							uMap.put("parameter_id", parameter_id);
						}
						
						String parameter = isrvmsg.getValue("parameter_" + indexStr);
						uMap.put("parameter_id", (String)map.get("parameter_id_"+indexStr));
						uMap.put("parameter", parameter);
						uMap.put("updatetor", user.getEmpId());
						uMap.put("modify_date","to_date('"+createdate+"','yyyy-MM-dd HH24:mi:ss')");
						uMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
						sqlList.add(assembleSql(uMap,"DMS_EQU_PAR_TABLE",new String[] {"modify_date"},"update","whole"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		
		
		// �����ϴ�
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		Map<String, Object> doc = new HashMap<String, Object>();
		MyUcm ucm = new MyUcm();
		String filename = "";
		String fileOrder = "";
		String ucmDocId = "";
		try {
			// ������
			for (WSFile file : filesOther) {
				filename = file.getKey();
				if(filename.equals("skill_parameter__")){
				fileOrder = file.getKey().toString().split("__")[0];
				ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", equipment_id);
				doc.put("file_type", fileOrder);
				doc.put("file_name", file.getFilename());
				doc.put("bsflag", EquipmentStants.BSFLAG_ZC);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("UPLOAD_DATE", createdate);
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				// ������
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				// ��־��
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
						user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
			  }
			}

		} catch (Exception e) {
			System.out.println("���븽���쳣");
		}
		
		return responseDTO;
	}
	
	 
	/**
	 * ɾ�� ��̽��¼
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg todeleteEquList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String deviceId = isrvmsg.getValue("updateids");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// �豸��ID
		mainMap.put("equipment_id", deviceId);
		// �޸���
		mainMap.put("updatetor", user.getEmpId());
		// �޸�ʱ��
		mainMap.put("modify_date", createdate);
		// ɾ�����
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_EXPLORATION_LIST");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ��ȡZtree id
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg getTreeId(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id = isrvmsg.getValue("id");
		StringBuffer queryopiInfoSql = new StringBuffer();
		queryopiInfoSql.append("select  t.* from DMS_EXPLORTATION_TREE t where bsflag ='0' ");
		if (StringUtils.isNotBlank(id)) {
			queryopiInfoSql.append(" and t.id  = '"+id+"'");
		}	
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryopiInfoSql.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		return responseDTO;
	}
	
	
	/**
	 * Ztree ����豸
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addZtree(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String whole = isrvmsg.getValue("whole");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// �豸id
		String id = isrvmsg.getValue("id").trim();
		// �����豸id
		String pid = isrvmsg.getValue("pid").trim();
		// �豸����					 
		String name = isrvmsg.getValue("name").trim();
		// open �Ƿ����չ��
		String open =EquipmentStants.BSFLAG_ZK;
		// �Ƿ����ѡ��
		String nocheck =EquipmentStants.BSFLAG_XZ;
		try{
			if (whole.equals("null")) {
			strMap.put("id", id);
			strMap.put("pid", pid);
			strMap.put("name", name);
			strMap.put("nocheck", nocheck);
			strMap.put("open", open);
			strMap.put("creater", user.getEmpId());
			strMap.put("create_date", createdate);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			Serializable whole_id = jdbcDao.saveOrUpdateEntity(strMap, "dms_explortation_tree");
			whole =(String) whole_id;
		} else{
			strMap.put("whole", whole);
			strMap.put("id", id);
			strMap.put("pid", pid);
			strMap.put("name", name);
			strMap.put("nocheck", nocheck);
			strMap.put("open", open);
			strMap.put("updatetor", user.getEmpId());
			strMap.put("modify_date", createdate);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			List<String> sqlList = new ArrayList<String>();
			sqlList.add("update DMS_EXPLORATION_LIST l set l.current_device_type ='" + name + "' where l.current_device_type_id='" + id + "' and l.bsflag='0'");
			sqlList.add("update dms_equipment_parameters p set p.current_device_type ='" + name + "' where p.current_device_type_id='" + id + "' and p.bsflag='0'");
			String str[]=new String[sqlList.size()];
			String strings[]=sqlList.toArray(str);
			//���������
			jdbcTemplate.batchUpdate(strings);
			jdbcDao.saveOrUpdateEntity(strMap, "dms_explortation_tree");
		}
		}catch (Exception e) {
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
		}
	
	/**
	 * ��ѯ��̽����Ƿ��������
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg selectZtreeList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String current_device_type_id = isrvmsg.getValue("current_device_type_id");
		StringBuffer queryopiInfoSql = new StringBuffer();
		queryopiInfoSql.append("select t.* from dms_equipment_parameters t  where t.bsflag='0' ");
		queryopiInfoSql.append(" and t.current_device_type_id  = '"+current_device_type_id+"'");
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryopiInfoSql.toString());
		if (list.size()>0) {
			operationFlag = EquipmentStants.BSFLAG_SB;
			responseDTO.setValue("operationFlag", operationFlag);
		} 
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
		
	}
	/**
	 * ɾ��ZTree�ڵ�
	 */

	public ISrvMsg deleteZtreeNote(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String whole = isrvmsg.getValue("whole");
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// ��Ŀ��ID
		mainMap.put("whole", whole);
		// �޸���
		mainMap.put("updatetor", user.getEmpId());
		// �޸�ʱ��
		mainMap.put("modify_date", createdate);
		// ɾ�����
		mainMap.put("bsflag", EquipmentStants.BSFLAG_DELETE);
		// û�б������뵥����Ϣ����������뵥�Ļ�����Ϣ
		try{
			jdbcDao.saveOrUpdateEntity(mainMap, "dms_explortation_tree");
		}catch(Exception e){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;

	}
	/**
	 *  ��ȡ�豸���Ƶ�ֵ
	 * @param isrvmsg       ��������ֵ
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getEquipmentType(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String whole = isrvmsg.getValue("whole");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select d.* from DMS_EXPLORTATION_TREE d where d.bsflag ='0'");
		if (StringUtils.isNotBlank(whole)) {
			queryScrapeInfoSql.append(" and d.whole  = '" + whole + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		return responseDTO;
		
	}
	
	
	/**
	 *  ��ѯ�豸������
	 * @param isrvmsg       ��������ֵ
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getDevicePara(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String current_device_type_id = isrvmsg.getValue("current_device_type_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select p.* from DMS_EQUIPMENT_PARAMETERS p where p.bsflag = '0' ");
		if (StringUtils.isNotBlank(current_device_type_id)) {
			queryScrapeInfoSql.append(" and p.current_device_type_id  = '" + current_device_type_id + "'");
		}
		//�������
		queryScrapeInfoSql.append(" order by p.parameter_id desc");
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		if (list.size()>0) {
			responseDTO.setValue("deviceappMap", list);
		}
		
		return responseDTO;
		
	}
	
	/**
	 *  ��ȡcurrent_device_type_id��ֵ
	 * @param isrvmsg       ��������ֵ
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getEquipmentTypeId(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String equipment_id = isrvmsg.getValue("equipment_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select d.* from DMS_EXPLORATION_LIST d where d.bsflag ='0'");
		if (StringUtils.isNotBlank(equipment_id)) {
			queryScrapeInfoSql.append(" and d.equipment_id  = '" + equipment_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		
		if (deviceappMap != null) {
			responseDTO.setValue("str", deviceappMap);
		}
		return responseDTO;
		
	}
	
	
	/**
	 *  ����Ա�--�����б�
	 * @param isrvmsg       ��������ֵ
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg getParameterList(ISrvMsg isrvmsg) throws Exception {
		String ids = isrvmsg.getValue("equipment_id");
		String  strs = "'"+ids.replace(",", "','")+"'";
		List<Map> list = new ArrayList<Map>();
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select distinct(parameter_id) as code ,parameter_name as note from (select t.parameter_id,t.parameter_name from dms_equ_par_table t where t.bsflag = '0'  and t.current_device_type_id in ( select l.equipment_ids from DMS_EXPLORATION_LIST l where l.bsflag='0' and l.equipment_id");
		queryScrapeInfoSql.append(" in ("+strs+")))");
		list = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		List<Map> list2 = new ArrayList<Map>();
		StringBuffer queryScrapeInfoSqlList = new StringBuffer();
		queryScrapeInfoSqlList.append("select l.* from DMS_EXPLORATION_LIST l where l.bsflag='0' and l.equipment_id ");
		queryScrapeInfoSqlList.append(" in ("+strs+")");
		list2 = jdbcDao.queryRecords(queryScrapeInfoSqlList.toString());
		JSONArray retJson = JSONArray.fromObject(list);	
		ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(isrvmsg);			
		if(retJson == null){
			outmsg.setValue("json", "[]");
		}else {
			outmsg.setValue("json", retJson.toString());
		}	
		
		outmsg.setValue("deviceappMap", list2);
		return outmsg;
	}
	
	/**
	 * ����Ա�--�Ƿ���ԶԱ�
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg queryParContrastName(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = EquipmentStants.BSFLAG_CG;
		String ids = isrvmsg.getValue("ids");
		List<Map> list = new ArrayList<Map>();
		String  strs = "'"+ids.replace(",", "','")+"'";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select l.CURRENT_DEVICE_TYPE from DMS_EXPLORATION_LIST l where l.bsflag='0' and equipment_id ");
		querySql.append("in ("+strs+")");
		list = jdbcDao.queryRecords(querySql.toString());
		Map map =list.get(0);
		Map map2 =list.get(1);
		String name1 =(String) map.get("current_device_type");
		String name2 =(String) map2.get("current_device_type");
		if(!name1.equals(name2)){
			operationFlag = EquipmentStants.BSFLAG_SB;
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ����Ա�--��ϸ����
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg queryParContrast(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String equipment_name = isrvmsg.getValue("equipment_name");		// ��������
		if(equipment_name.equals("")){
			equipment_name="undefined";
		}
		String ids = isrvmsg.getValue("ids");
		List<Map> list = new ArrayList<Map>();
		List<Map> list1 = new ArrayList<Map>();
		List<Map> list2 = new ArrayList<Map>();
		String  strs = "'"+ids.replace(",", "','")+"'";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.parameter_id,t.parameter_name,t.parameter as parameter,t.current_device_type_id from dms_equ_par_table t where t.bsflag = '0'  and t.current_device_type_id in ( select l.equipment_ids from DMS_EXPLORATION_LIST l where l.bsflag='0' and l.equipment_id  "
				+ "in ("+strs+"))");
		// ���뵥����
		if (!equipment_name.equals("undefined")) {
			querySql.append(" and t.parameter_name  like '%"+equipment_name+"%'");
		}
		// �������
		querySql.append(" order by current_device_type_id");
		list = jdbcDao.queryRecords(querySql.toString());
		
		//�豸
		StringBuffer querySql1 = new StringBuffer();
		querySql1.append("select distinct(current_device_type_id),parameter_name from (select t.current_device_type_id,t.parameter_name from dms_equ_par_table t where t.bsflag = '0'  and t.current_device_type_id in ( select l.equipment_ids from DMS_EXPLORATION_LIST l where l.bsflag='0' and l.equipment_id  "
				+ "in ("+strs+")))");
		// ���뵥����
		if (!equipment_name.equals("undefined")) {
			querySql1.append(" where parameter_name like '%"+equipment_name+"%'");
		}
		list1 = jdbcDao.queryRecords(querySql1.toString());
		
		//����
		StringBuffer querySql2 = new StringBuffer();
		querySql2.append("select distinct(parameter_id),parameter_name  from (select t.parameter_id,t.parameter_name from dms_equ_par_table t where t.bsflag = '0'  and t.current_device_type_id in ( select l.equipment_ids from DMS_EXPLORATION_LIST l where l.bsflag='0' and l.equipment_id  "
				+ "in ("+strs+")))");
		// ���뵥����
		if (!equipment_name.equals("undefined")) {
			querySql2.append(" where parameter_name like '%"+equipment_name+"%'");
		}
		list2 = jdbcDao.queryRecords(querySql2.toString());
		
		responseDTO.setValue("deviceappMap", list);
		responseDTO.setValue("deviceappMap1", list1);
		responseDTO.setValue("deviceappMap2", list2);
		return responseDTO;
		
	}
	/**
	 * �豸���� -- ����  ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg toUp(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String parameter_ids = isrvmsg.getValue("up");
		String nos="";
		int no = 0;
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.* from dms_equipment_parameters t where t.bsflag = '0'  and t.parameter_ids ='"+parameter_ids+"'");
		Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if (deviceappMap != null) {
			nos = (String) deviceappMap.get("no");
		}
		if(Integer.parseInt(nos) !=1){
			no =(Integer.parseInt(nos) -1);
		}else{
			no = 1;
		}
		
		StringBuffer querySql2 = new StringBuffer();
		querySql2.append("select t.* from dms_equipment_parameters t where t.bsflag = '0'  and t.no ='"+no+"'");
		Map deviceappMap2 = jdbcDao.queryRecordBySQL(querySql2.toString());
		Map<String, Object> mainMap = new HashMap<String, Object>();
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		
		String parameter_ids2 ="";
		if(deviceappMap2!=null){
			parameter_ids2 = (String) deviceappMap2.get("parameter_ids");
			// ��Ŀ��ID
			mainMap.put("parameter_ids", parameter_ids2);
			mainMap.put("no", nos);
			// �޸���
			mainMap.put("updatetor", user.getEmpId());
			// �޸�ʱ��
			mainMap.put("modify_date", createdate);
			// �޸ı��
			mainMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			
			jdbcDao.saveOrUpdateEntity(mainMap, "dms_equipment_parameters");
		}
		
		// ��Ŀ��ID
		mainMap.put("parameter_ids", parameter_ids);
		mainMap.put("no", no);
		// �޸���
		mainMap.put("updatetor", user.getEmpId());
		// �޸�ʱ��
		mainMap.put("modify_date", createdate);
		// �޸ı��
		mainMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
		
		jdbcDao.saveOrUpdateEntity(mainMap, "dms_equipment_parameters");
		
		return responseDTO;

	}
	
	/**
	 * �豸���� -- ����  ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg toDown(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String parameter_ids = isrvmsg.getValue("down");
		String nos="";
		int no =0;
		StringBuffer querySql = new StringBuffer();
		StringBuffer querySql3 = new StringBuffer();
		querySql.append("select t.* from dms_equipment_parameters t where t.bsflag = '0'  and t.parameter_ids ='"+parameter_ids+"'");
		querySql3.append("select case when max(p.no) is null then '0' else max(p.no) end as no from dms_equipment_parameters p where p.bsflag='0'");
		Map deviceappMap3 = jdbcDao.queryRecordBySQL(querySql3.toString());
		String no2 =(String) deviceappMap3.get("no");
		Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if (deviceappMap != null) {
			nos = (String) deviceappMap.get("no");
		}
		if(Integer.parseInt(nos) < Integer.parseInt(no2)){
			no =(Integer.parseInt(nos) +1);
		}else{
			no =Integer.parseInt(no2);
		}
		
		StringBuffer querySql2 = new StringBuffer();
		querySql2.append("select t.* from dms_equipment_parameters t where t.bsflag = '0'  and t.no ='"+no+"'");
		Map deviceappMap2 = jdbcDao.queryRecordBySQL(querySql2.toString());
		Map<String, Object> mainMap = new HashMap<String, Object>();
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		
		String parameter_ids2 ="";
		if(deviceappMap2!=null){
			parameter_ids2 = (String) deviceappMap2.get("parameter_ids");
			// ��Ŀ��ID
			mainMap.put("parameter_ids", parameter_ids2);
			mainMap.put("no", nos);
			// �޸���
			mainMap.put("updatetor", user.getEmpId());
			// �޸�ʱ��
			mainMap.put("modify_date", createdate);
			// �޸ı��
			mainMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			
			jdbcDao.saveOrUpdateEntity(mainMap, "dms_equipment_parameters");
		}
		 
		// ��Ŀ��ID
		mainMap.put("parameter_ids", parameter_ids);
		mainMap.put("no", no);
		// �޸���
		mainMap.put("updatetor", user.getEmpId());
		// �޸�ʱ��
		mainMap.put("modify_date", createdate);
		// �޸ı��
		mainMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
		
		jdbcDao.saveOrUpdateEntity(mainMap, "dms_equipment_parameters");
		
		return responseDTO;

	}
	
}

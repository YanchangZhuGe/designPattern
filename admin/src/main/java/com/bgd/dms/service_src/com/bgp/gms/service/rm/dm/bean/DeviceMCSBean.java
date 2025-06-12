package com.bgp.gms.service.rm.dm.bean;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.util.DateUtil;

public class DeviceMCSBean {
	IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	ILog log = LogFactory.getLogger(DeviceMCSBean.class);
	
	public DeviceMCSBean(){
		
	}
	/**
	 * NEWMETHOD
	 * 查询返还调配单主表信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryBackMDFInfo(String search_mix_mainid){
		String sql = "select device_mixinfo_id from gms_device_backinfo_form t ";
		sql += "where search_mix_mainid='"+search_mix_mainid+"' ";
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	/**
	 * NEWMETHOD
	 * 返还调配单关联子表信息
	 * @param mainMap
	 */
	public void saveBackMDFSubInfo(String[] mdmides,String[] pos,String device_mixinfo_id,String modifidate,String modifier) {
		for(int i=0;i<mdmides.length;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			dataMap.put("device_mixinfo_id", device_mixinfo_id);
			dataMap.put("device_backdet_id", mdmides[i]);
			dataMap.put("dev_position", pos[i]);
			dataMap.put("modifi_date", modifidate);
			dataMap.put("modifier", modifier);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_backapp_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 批量设备返还调配单关联子表信息
	 * @param mainMap
	 */
	public void saveBackCollSubInfo(String[] mdmides,String[] pos,String device_mixinfo_id) {
		for(int i=0;i<mdmides.length;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			dataMap.put("device_backapp_id",mdmides[i] );
			dataMap.put("device_backdet_id", pos[i]);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_backapp_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 外租申请子表信息的保存功能
	 * @param mainMap
	 */
	public void saveNewHireAppDetailInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_hireapp_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 维修信息保存到设备动态表
	 * @param mainMap
	 */
	public void saveRIFBackDymSubInfo(String[] mdmides,String device_mixinfo_id,String[] senddates) {
		for(int i=0;i<mdmides.length;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			dataMap.put("device_appmix_id", device_mixinfo_id);
			dataMap.put("dev_acc_id", mdmides[i]);
			dataMap.put("alter_date", senddates[i]);
			dataMap.put("oprtype", DevConstants.DYM_OPRTYPE_WEIXIUIN);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_dyminfo");
		}
	}
	/**
	 * NEWMETHOD
	 * 维修信息保存到设备动态表
	 * @param mainMap
	 */
	public void saveRIFDymSubInfo(String[] mdmides,String device_mixinfo_id,String[] senddates) {
		for(int i=0;i<mdmides.length;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			dataMap.put("device_appmix_id", device_mixinfo_id);
			dataMap.put("dev_acc_id", mdmides[i]);
			dataMap.put("alter_date", senddates[i]);
			dataMap.put("oprtype", DevConstants.DYM_OPRTYPE_WEIXIUOUT);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_dyminfo");
		}
	}
	/**
	 * NEWMETHOD
	 * 维修调配单关联子表信息
	 * @param mainMap
	 */
	public void saveRIFSubInfo(String[] mdmides,String device_mixinfo_id,String[] senddates) {
		for(int i=0;i<mdmides.length;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			dataMap.put("device_mixinfo_id", device_mixinfo_id);
			dataMap.put("dev_acc_id", mdmides[i]);
			dataMap.put("actual_in_time", senddates[i]);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_repairinfo_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 查询调配单主表信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryRIFInfo(String search_mix_mainid){
		String sql = "select device_mixinfo_id from gms_device_repairinfo_form t ";
		sql += "where search_mix_mainid='"+search_mix_mainid+"' ";
		//sql += " order by dev_ct_code";
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	/**
	 * NEWMETHOD
	 * 保存模板子表信息
	 * @param mainMap
	 */
	public void saveCollModelSubInfo(List<Map<String,Object>> modelList,String model_mainid) {
		for(Map dataMap : modelList){
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_collmodel_sub");
		}
	}
	/**
	 * NEWMETHOD
	 * 调配单关联子表信息
	 * @param mainMap
	 */
	public void saveMDFSubInfo(String[] mdmides,String device_mixinfo_id) {
		for(int i=0;i<mdmides.length;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			dataMap.put("device_mixinfo_id", device_mixinfo_id);
			dataMap.put("device_mix_id", mdmides[i]);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_mixinfo_detail");
			if(i==(mdmides.length-1)){
				//更改是否开据调配单状态
				dataMap.put("IS_PRINT_FORM", DevConstants.ISADDDETAIL_YES);
				jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_appmix_main");
			}
		}
	}
	/**
	 * NEWMETHOD
	 * 查询调配单主表信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryMDFInfo(String search_mix_mainid){
		String sql = "select device_mixinfo_id from gms_device_backinfo_form t ";
		sql += "where search_mix_mainid='"+search_mix_mainid+"' ";
		//sql += " order by dev_ct_code";
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	/**
	 * NEWMETHOD
	 * 调配明细子表信息
	 * @param mainMap
	 */
	public void saveMixDetailSubInfo(List<Map<String, Object>> subDetailList) {
		for(int i=0;i<subDetailList.size();i++){
			Map<String,Object> dataMap = subDetailList.get(i);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_appmix_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 项目设备申请子表信息的保存功能
	 * @param mainMap
	 */
	public void saveNewMixAppDetailInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_app_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 项目设备申请子表信息的保存功能(按量管理)
	 * @param mainMap
	 */
	public void saveNewCollMixDetailSubInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_app_colldetsub");
		}
	}
	/**
	 * NEWMETHOD
	 * 项目设备申请子表信息的保存功能(按量管理)
	 * @param mainMap
	 */
	public void saveNewCollMixAppDetailInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_app_colldetail");
		}
	}
	/**
	 * NEWMETHOD
	 * 项目设备申请子表信息的保存功能(按台管理)
	 * @param mainMap
	 */
	public void saveNewDevAllAppDetailInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_allapp_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 项目设备申请子表信息的保存功能(按量管理)
	 * @param mainMap
	 */
	public void saveNewCollDevAllAppDetailInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_allapp_colldetail");
		}
	}
	/**
	 * NEWMETHOD
	 * 设备模板子表信息的保存功能(按台管理)
	 * @param mainMap
	 */
	public void saveNewDevModelDetailInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_dev_model_detail");
		}
	}
	/**
	 * NEWMETHOD
	 * 设备模板子表信息的保存功能(按量管理)
	 * @param mainMap
	 */
	public void saveNewCollModelDetailInfo(List<Map<String, Object>> devDetailList) {
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_dev_model_detail");
		}
	}
	public void saveOSMappingDetailInfo(List<Map> osDatalist,String device_allapp_id) {
		for(int i=0;i<osDatalist.size();i++){
			Map dataMap = osDatalist.get(i);
			dataMap.put("device_allapp_id", device_allapp_id);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_aamapping");
		}
	}
	/**
	 * 查询设备编码类别
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryDeviceType(Map<String,Object> map){
		Object condition = null;
		if(map!=null){
			condition = map.get("condition");
		}
		String sql = "select * from gms_device_codetype t ";
		if (condition != null) {
			sql += "where "+condition;
		}
		//sql += " order by dev_ct_code";
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	/**
	 * 查询设备编码信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryDeviceInfo(Map<String,Object> map){
		Object condition = null;
		if(map!=null){
			condition = map.get("condition");
		}
		String sql = "select * from gms_device_codeinfo t ";
		if (condition != null) {
			sql += "where "+condition;
		}
		//sql += " order by dev_ct_code";
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	/**
	 * 查询项目信息
	 * @param project_id_no
	 * @return
	 */
	public Map<String, Object> queryProDevAppInfo(String project_id_no) {
		String sql = "select * from gms_device_app where project_info_id='"+project_id_no+"'";
		Map<String, Object> resultMap = jdbcDao.queryRecordBySQL(sql);
		return resultMap;
	}
	/**
	 * 查询项目中某明细的信息
	 * @param project_id_no
	 * @return
	 */
	public Map<String, Object> queryProDevDetailById(String dev_appdet_id) {
		String sql = "select * from gms_device_app_detail where dev_appdet_id='"+dev_appdet_id+"'";
		Map<String, Object> resultMap = jdbcDao.queryRecordBySQL(sql);
		return resultMap;
	}

	/**
	 * 设备调配调剂主表信息的保存功能
	 * @param mainMap
	 */
	public void saveDevMixMainInfo(Map<String,Object> mainMap) {
		jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_appmix_main");
	}
	/**
	 * 调配明细主表信息
	 * @param mainMap
	 */
	public void saveMixDetailMainInfo(Map<String,Object> mainMap) {
		jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_mixdetail_main");
	}
	/**
	 * 调配明细子表信息
	 * @param mainMap
	 */
	public void saveMixDetailSubInfo(List<Map<String, Object>> subDetailList,String device_mix_mainid) {
		for(int i=0;i<subDetailList.size();i++){
			Map<String,Object> dataMap = subDetailList.get(i);
			dataMap.put("device_mix_mainid", device_mix_mainid);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_appmix_detail");
		}
		
	}
	/**
	 * 查询调配明细主表信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryMixDetailMainInfo(String search_mix_mainid){
		Object condition = null;
		String sql = "select device_mix_mainid from gms_device_mixdetail_main t ";
		if (condition != null) {
			sql += "where search_mix_mainid='"+search_mix_mainid+"' ";
		}
		//sql += " order by dev_ct_code";
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	/**
	 * 查询返还单主表信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> queryBackAppInfo(String search_backapp_id){
		String sql = "select device_backapp_id from gms_device_backapp t ";
		sql += "where t.search_backapp_id='"+search_backapp_id+"' ";
		//sql += " order by dev_ct_code";
		log.debug("查询sql:"+sql);
		List<Map<String,Object>> list = radDao.getJdbcTemplate().queryForList(sql);
		return list;
	}
	/**
	 * 调配返还单明细子表信息
	 * @param mainMap
	 */
	public void saveBackAppSubInfo(String[] backsubides,String device_backapp_id) {
		for(int i=0;i<backsubides.length;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			//先查询基本信息
			Map tmpMap = jdbcDao.queryRecordBySQL("select dev_coding,self_num,dev_sign,license_num,actual_in_time,planing_out_time from gms_device_account_dui where dev_acc_id='"+backsubides[i]+"'");
			if(tmpMap!=null){
				dataMap.put("dev_coding", tmpMap.get("dev_coding"));
				dataMap.put("self_num", tmpMap.get("self_num"));
				dataMap.put("dev_sign", tmpMap.get("dev_sign"));
				dataMap.put("license_num", tmpMap.get("license_num"));
				dataMap.put("actual_in_time", tmpMap.get("actual_in_time"));
				dataMap.put("planing_out_time", tmpMap.get("planing_out_time"));
			}
			dataMap.put("device_backapp_id", device_backapp_id);
			dataMap.put("dev_acc_id", backsubides[i]);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_backapp_detail");
		}
	}
	
	/**
	 * 项目设备接收明细提交保存功能，更改台帐状态，插入台帐动态附属表，插入队级台帐
	 * 项目设备入库明细提交保存功能
	 * @param mainMap
	 */
	public void saveDevRecInfo(Map<String,Object> mainMap,String tabelname) {
		jdbcDao.saveOrUpdateEntity(mainMap, tabelname);
	}
	/**
	 * 查询台帐信息
	 * @param project_id_no
	 * @return
	 */
	public Map queryDevAccInfo(String dev_acc_id) {
		StringBuffer sqlsb = new StringBuffer()
				.append(
						"select DEV_ACC_ID,DEV_CODING,DEV_NAME,ASSET_STAT,DEV_MODEL,SELF_NUM,DEV_SIGN,DEV_TYPE,DEV_UNIT,")
				.append(
						"ASSET_CODING,TURN_NUM,ORDER_NUM,REQU_NUM,ASSET_VALUE,NET_VALUE,CONT_NUM,CURRENCY,")
				.append(
						"TECH_STAT,USING_STAT,CAPITAL_SOURCE,OWNING_ORG_ID,OWNING_ORG_NAME,OWNING_SUB_ID,")
				.append(
						"USAGE_ORG_ID,USAGE_ORG_NAME,USAGE_SUB_ID,DEV_POSITION,MANU_FACTUR,PRODUCTING_DATE,")
				.append(
						"ACCOUNT_STAT,DEV_PHOTO,LICENSE_NUM,CHASSIS_NUM,ENGINE_NUM,BSFLAG,REMARK,CREATOR,")
				.append(
						"CREATE_DATE,MODIFIER,MODIFI_DATE ")
				.append(
						"from gms_device_account where dev_acc_id='" + dev_acc_id + "'");
		Map resultMap = jdbcDao.queryRecordBySQL(sqlsb.toString());
		return resultMap;
	}
	/**
	 * 查询队级台帐ID
	 * @param project_id_no
	 * @return
	 */
	public Map queryDevProcess(String fk_mix_id) {
		StringBuffer sqlsb = new StringBuffer()
				.append(
						"select DEV_ACC_ID ")
				
				
				.append(
						"from GMS_DEVICE_ACCOUNT_DUI where fk_device_appmix_id='" + fk_mix_id + "'");
		Map resultMap = jdbcDao.queryRecordBySQL(sqlsb.toString());
		return resultMap;
	}
	/**
	 * 保养计划查询队级台帐ID
	 * @param project_id_no
	 * @return
	 */
	public Map queryDevDuiID(String searchid) {
		StringBuffer sqlsb = new StringBuffer()
				.append(
						"select DEV_ACC_ID ")
				
				
				.append(
						"from GMS_DEVICE_ACCOUNT_DUI where search_id='" + searchid + "'");
		Map resultMap = jdbcDao.queryRecordBySQL(sqlsb.toString());
		return resultMap;
	}
}

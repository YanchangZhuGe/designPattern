package com.bgp.dms.assess;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.ServiceUtils;
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

/**
 * 
 * @author dushuai
 * 
 */
public class IndexAssessSrv extends BaseService {

	public IndexAssessSrv() {
		log = LogFactory.getLogger(IndexAssessSrv.class);
	}
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * ��ѯָ��������Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIndexConfInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryIndexConfInfoList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String index_name = isrvmsg.getValue("index_name");// ָ������
		String index_year = isrvmsg.getValue("index_year");// ָ�����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.user_name as updator_name"
				+ " from dms_assess_indexconf t "
				+ " left join p_auth_user_dms t1 on t.updator=t1.user_id "
				+ " where t.bsflag='0'");
		// ָ������
		if (StringUtils.isNotBlank(index_name)) {
			querySql.append(" and t.index_name like '%" + index_name + "%'");
		}
		// ָ�����
		if (StringUtils.isNotBlank(index_year)) {
			querySql.append(" and t.index_year = '" + index_year + "'");
		}
		querySql.append(" order by t.modify_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ȡָ��������Ϣ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIndexConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getIndexConfInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String indexconf_id = isrvmsg.getValue("indexconf_id");// ָ������id
		//��ѯָ��������Ϣ
		String msql = "select t.* from dms_assess_indexconf t where t.bsflag='0' and t.indexconf_id='"+indexconf_id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		//��ѯָ������Ϣ
		String sql = "select t.*"
				+ " from dms_assess_indexconf_item t"
				+ " where t.bsflag = '0' and t.indexconf_id='"+indexconf_id+"' order by t.item_order";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("data", map);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * �������޸�ָ��������Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateIndexConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateIndexConfInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String index_name = map.get("index_name").toString();//ָ������
		String index_year = map.get("index_year").toString();//���
		String flag = map.get("flag").toString();//�����޸ı�־
		String indexconfId = "";//����ָ�����ñ�����
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//�������
				Map mainMap=new HashMap();
				mainMap.put("index_name", index_name);//ָ������
				mainMap.put("index_year", index_year);//���
				ServiceUtils.setCommFields(mainMap, "indexconf_id", user);
				indexconfId = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_assess_indexconf");
			}else{//�޸Ĳ���
				indexconfId=map.get("indexconf_id").toString();
				Map umainMap=new HashMap();
				umainMap.put("indexconf_id", indexconfId);
				umainMap.put("index_name", index_name);
				umainMap.put("index_year", index_year);
				ServiceUtils.setCommFields(umainMap, "indexconf_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_assess_indexconf");
			}
			for (Object key : map.keySet()) {
				//�������Ҫɾ�������ݣ�������ɾ��sql
				if(((String)key).startsWith("del_tr")){
					Map delMap = new HashMap();
					delMap.put("item_id", (String)map.get(key));
					delMap.put("bsflag","1");
					sqlList.add(assembleSql(delMap,"dms_assess_indexconf_item",null,"update","item_id"));
				}
				if(((String)key).startsWith("item_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if(null==map.get("item_id_"+indexStr) || StringUtils.isBlank(map.get("item_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("item_id", iuuid);
						aMap.put("indexconf_id", indexconfId);
						aMap.put("item_name", (String)map.get("item_name_"+indexStr));
						aMap.put("item_order", (String)map.get("item_order_"+indexStr));
						aMap.put("bsflag", "0");
						sqlList.add(assembleSql(aMap,"dms_assess_indexconf_item",new String[] {"item_order"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("item_id", (String)map.get("item_id_"+indexStr));
						uMap.put("item_name", (String)map.get("item_name_"+indexStr));
						uMap.put("item_order", (String)map.get("item_order_"+indexStr));
						sqlList.add(assembleSql(uMap,"dms_assess_indexconf_item",new String[] {"item_order"},"update","item_id"));
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
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ɾ��ָ��������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteIndexConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteIndexConfInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String indexconf_id = isrvmsg.getValue("indexconf_id");// ָ������id
		try{
			//ɾ����λָ������Ϣ��
			String delSql = "update dms_assess_indexconf_unit_item set bsflag='1' where item_id in (select unit_id from dms_assess_indexconf_unit where indexconf_id='"+indexconf_id+"')";
			jdbcDao.executeUpdate(delSql);
			//ɾ����λָ�����ñ�
			String delSql0 = "update dms_assess_indexconf_unit set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where indexconf_id='"+indexconf_id+"'";
			jdbcDao.executeUpdate(delSql0);
			//ɾ��ָ������Ϣ��
			String delSql1 = "update dms_assess_indexconf_item set bsflag='1' where indexconf_id='"+indexconf_id+"'";
			jdbcDao.executeUpdate(delSql1);
			//ɾ��ָ��������Ϣ��
			String delSql2 = "update dms_assess_indexconf set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where indexconf_id='"+indexconf_id+"'";
			jdbcDao.executeUpdate(delSql2);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ��ѯ����ָ����Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIndexOrgInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryIndexOrgInfoList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String index_name = isrvmsg.getValue("index_name");// ָ������
		String org_id = isrvmsg.getValue("org_id");// ������λ
		String subOrg_id = isrvmsg.getValue("subOrg_id");// ��������������λ
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.user_name as updator_name,t2.index_name,t4.org_abbreviation as org_name"
				+ " from dms_assess_indexconf_unit t "
				+ " left join p_auth_user_dms t1 on t.updator=t1.user_id "
				+ " left join dms_assess_indexconf t2 on t.indexconf_id=t2.indexconf_id and t2.bsflag='0'"
				+ " left join comm_org_subjection t3 on t.org_subjection_id=t3.org_subjection_id "
				+ " left join comm_org_information t4 on t3.org_id=t4.org_id "
				+ " where t.bsflag='0'");
		// ָ������
		if (StringUtils.isNotBlank(index_name)) {
			querySql.append(" and t2.index_name like '%" + index_name + "%'");
		}
		if(!"C105".equals(org_id)){
			//  ������λ
			if (StringUtils.isNotBlank(org_id)) {
				querySql.append(" and t.org_id = '" + org_id + "'");
			}
			// ��������������λ
			if (StringUtils.isNotBlank(subOrg_id)) {
				querySql.append(" and t.org_subjection_id = '" + subOrg_id + "'");
			}
		}
		querySql.append(" order by t.modify_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ȡ������λ������Ϣ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgNameInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getOrgNameAndIndexConfInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String subOrg_id = isrvmsg.getValue("subOrg_id");// ��������������λ
		//��ѯָ��������Ϣ
		String msql = "select t1.org_abbreviation as org_name"
				+ " from comm_org_subjection t "
				+ " left join comm_org_information t1  on t.org_id=t1.org_id "
				+ " where t.bsflag='0' and t.org_subjection_id='"+subOrg_id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * ��ȡָ��������Ϣ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIndexConfItemInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getIndexConfItemInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//��ѯָ������Ϣ
		String sql = "select t.indexconf_id as id,t.index_year||t.index_name as name"
				+ " from dms_assess_indexconf t"
				+ " where t.bsflag = '0' ";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ��λָ����Ϣ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIndexOrgInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getIndexOrgInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String unit_id = isrvmsg.getValue("unit_id");// ������ID
		//��ѯָ��������Ϣ
		String msql = "select t.*,t1.index_name,t3.org_abbreviation as org_name"
				+ " from dms_assess_indexconf_unit t "
				+ " left join dms_assess_indexconf t1 on t.indexconf_id=t1.indexconf_id and t1.bsflag='0'"
				+ " left join comm_org_subjection t2 on t.org_subjection_id=t2.org_subjection_id "
				+ " left join comm_org_information t3 on t2.org_id=t3.org_id "
				+ " where t.bsflag='0' and t.unit_id='"+unit_id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		String sql = "select t.item_id,t1.item_name from dms_assess_indexconf_unit_item t"
				+ " left join dms_assess_indexconf_item t1 on t.item_id=t1.item_id and t1.bsflag='0'"
				+ " where t.bsflag = '0' and t.unit_id ='"+unit_id+"' order by t1.item_order";
		List<Map> list= jdbcDao.queryRecords(sql);
		String itemids="";
		String itemNames="";
		if(CollectionUtils.isNotEmpty(list)){
			for(Map tMap:list){
				String item_id=tMap.get("item_id").toString();
				String item_name=tMap.get("item_name").toString();
				itemids += "," + item_id;
				itemNames += "," + item_name;
			}
			itemids = itemids=="" ? "" : itemids.substring(1);
			itemNames = itemNames=="" ? "" : itemNames.substring(1);
		}
		if((!"".equals(itemids)) && MapUtils.isNotEmpty(map)){
			map.put("item_ids", itemids);
		}
		if((!"".equals(itemNames))&& MapUtils.isNotEmpty(map)){
			map.put("item_names", itemNames);
		}
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * �������޸ĵ�λָ����Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateIndexOrgInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateIndexOrgInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String org_id=map.get("org_id").toString();//������λ
		String org_subjection_id=map.get("org_subjection_id").toString();//���
		String flag=map.get("flag").toString();//�����޸ı�־
		String unitId="";//���浥λָ�����ñ�����
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//�������
				Map mainMap=new HashMap();
				mainMap.put("org_id", org_id);//������λ
				mainMap.put("org_subjection_id", org_subjection_id);//��������������λ
				mainMap.put("indexconf_id", map.get("indexconf_id").toString());
				ServiceUtils.setCommFields(mainMap, "unit_id", user);
				unitId = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_assess_indexconf_unit");
			}else{//�޸Ĳ���
				unitId=map.get("unit_id").toString();
				Map umainMap=new HashMap();
				umainMap.put("unit_id",unitId);
				umainMap.put("indexconf_id", map.get("indexconf_id").toString());
				umainMap.put("org_id", org_id);
				umainMap.put("org_subjection_id", org_subjection_id);
				ServiceUtils.setCommFields(umainMap, "unit_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_assess_indexconf_unit");
			}
			//ɾ����λָ������Ϣ��
			String delSql = "delete from dms_assess_indexconf_unit_item where unit_id ='"+unitId+"'";
			jdbcDao.executeUpdate(delSql);
			//�����޸ĵ�λָ������Ϣ��
			String item_ids=map.get("item_ids").toString();//ָ����ids
			String[] ids=item_ids.split(",");
			for(int i=0;i<ids.length;i++){
				Map aMap = new HashMap();
				String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
				aMap.put("unit_item_id", iuuid);
				aMap.put("unit_id", unitId);
				aMap.put("item_id", ids[i]);
				aMap.put("bsflag", "0");
				sqlList.add(assembleSql(aMap,"dms_assess_indexconf_unit_item",null,"add",""));
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		responseDTO.setValue("org_id", org_id);
		responseDTO.setValue("org_subjection_id", org_subjection_id);
		return responseDTO;
	}
	
	/**
	 * ɾ��ָ��������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteIndexOrgInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteIndexOrgInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String unit_id = isrvmsg.getValue("unit_id");// ����id
		try{
			//ɾ����λָ������Ϣ��
			String delSql = "update dms_assess_indexconf_unit_item set bsflag='1' where unit_id ='"+unit_id+"'";
			jdbcDao.executeUpdate(delSql);
			//ɾ����λָ�����ñ�
			String delSql0 = "update dms_assess_indexconf_unit set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where unit_id='"+unit_id+"'";
			jdbcDao.executeUpdate(delSql0);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ��ȡ�豸���ʽ�����Ч����ָ��������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getJbzxConfData(ISrvMsg isrvmsg) throws Exception {
		log.info("getJbzxConfData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//��ѯָ�꿼�˱�����
		String sql = "select tt.org_id,tt.org_subjection_id,tt.item_id,tt.item_name,tt.org_name,tt1.conf_id,tt1.basic_data,tt1.assess_content,tt1.control_target from (select t.org_id,t.org_subjection_id,t1.item_id,t2.item_name,t4.org_abbreviation as org_name,t3.coding_show_id,t2.item_order "
				+ " from dms_assess_indexconf_unit t "
				+ " left join dms_assess_indexconf_unit_item t1 on t.unit_id=t1.unit_id and t1.bsflag='0' "
				+ " left join dms_assess_indexconf_item t2 on t1.item_id=t2.item_id and t2.bsflag='0' "
				+ " left join comm_org_subjection t3 on t.org_subjection_id=t3.org_subjection_id "
				+ " left join comm_org_information t4 on t3.org_id=t4.org_id "
				+ " left join dms_assess_indexconf t5 on t.indexconf_id=t5.indexconf_id and t5.bsflag='0' "
				+ " where t.bsflag='0' and t5.index_name like '%�豸���ʽ�����Ч����ָ�����Ŀ��%' order by t3.coding_show_id,t2.item_order ) tt "
				+ " left join (select t.conf_id,t.org_id,t.org_subjection_id,t.item_id,t.basic_data,t.assess_content,t.control_target,"
				+ " t1.item_name,t3.org_abbreviation as org_name,t2.coding_show_id,t1.item_order from dms_assess_jbzx_conf t "
				+ " left join dms_assess_indexconf_item t1 on t.item_id=t1.item_id and t1.bsflag='0' "
				+ " left join comm_org_subjection t2 on t.org_subjection_id=t2.org_subjection_id "
				+ " left join comm_org_information t3 on t2.org_id=t3.org_id "
				+ " where t.bsflag='0' order by t2.coding_show_id,t1.item_order) tt1 "
				+ " on tt.org_id=tt1.org_id and tt.org_subjection_id=tt1.org_subjection_id and tt.item_id=tt1.item_id order by tt.coding_show_id,tt.org_subjection_id,tt.org_id,tt.item_order";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * �������޸��豸���ʽ�����Ч����ָ��������Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateJbzxConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateJbzxConfInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		//ɾ��sql�ַ���
		String dSqlStr = "";
		try {
			//�����޸��豸���ʽ�����Ч����ָ��������Ϣ
			for (Object key : map.keySet()) {
				if(((String)key).startsWith("conf_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if(null==map.get("conf_id_"+indexStr) || StringUtils.isBlank(map.get("conf_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("conf_id", iuuid);
						aMap.put("org_id", (String)map.get("org_id_"+indexStr));
						aMap.put("org_subjection_id", (String)map.get("org_subjection_id_"+indexStr));
						aMap.put("item_id", (String)map.get("item_id_"+indexStr));
						aMap.put("basic_data", (String)map.get("basic_data_"+indexStr));
						aMap.put("assess_content", (String)map.get("assess_content_"+indexStr));
						aMap.put("control_target", (String)map.get("control_target_"+indexStr));
						aMap.put("creater", user.getUserId());
						aMap.put("create_date", "sysdate");
						aMap.put("updator", user.getUserId());
						aMap.put("modify_date","sysdate");
						aMap.put("bsflag","0");
						sqlList.add(assembleSql(aMap,"dms_assess_jbzx_conf",new String[] {"basic_data","control_target","create_date","modify_date"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("conf_id", (String)map.get("conf_id_"+indexStr));
						uMap.put("basic_data", (String)map.get("basic_data_"+indexStr));
						uMap.put("assess_content", (String)map.get("assess_content_"+indexStr));
						uMap.put("control_target", (String)map.get("control_target_"+indexStr));
						uMap.put("updator", user.getUserId());
						uMap.put("modify_date","sysdate");
						dSqlStr+=",'"+map.get("conf_id_"+indexStr).toString()+"'";
						sqlList.add(assembleSql(uMap,"dms_assess_jbzx_conf",new String[] {"basic_data","control_target","modify_date"},"update","conf_id"));
					}
				}
			}
			//�����λ��Ӧ��ָ�����޸ģ���ɾ����ǰ���õ���Ϣ
			if(!"".equals(dSqlStr)){
				dSqlStr = dSqlStr.substring(1);
				String dSql="delete from dms_assess_jbzx_conf where conf_id not in ("+dSqlStr+")";
				jdbcDao.executeUpdate(dSql);
				//ɾ����λ���ϱ���ָ������
				String dSql2="delete from dms_assess_jbzx_detail where conf_id not in ("+dSqlStr+")";
				jdbcDao.executeUpdate(dSql2);
				
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	/**
	 * ��ѯ�豸���ʽ�����Ч����ָ����Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryJbzxInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryJbzxInfoList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String assess_date = isrvmsg.getValue("assess_date");// ����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.user_name as report_name,t3.org_abbreviation as org_name"
				+ " from dms_assess_jbzx_info t "
				+ " left join p_auth_user t1 on t.updator=t1.user_id "
				+ " left join comm_org_subjection t2 on t.org_subjection_id=t2.org_subjection_id and t2.bsflag='0' "
				+ " left join comm_org_information t3 on t2.org_id=t3.org_id and t3.bsflag='0'"
				+ " where t.bsflag='0' ");
		// ����
		if (StringUtils.isNotBlank(assess_date)) {
			querySql.append(" and t.assess_date = '" + assess_date + "'");
		}
		if(!"C105".equals(user.getSubOrgIDofAffordOrg())){
			querySql.append(" and t.org_subjection_id = '" + user.getSubOrgIDofAffordOrg() + "'");
		}
		querySql.append(" order by t.assess_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ�豸���ʽ�����Ч����ָ����ϸ��Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryJbzxDetailList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryJbzxDetailList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String id = isrvmsg.getValue("id");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.cumu_report,t1.control_target,t2.item_name from dms_assess_jbzx_detail t " +
				"left join dms_assess_jbzx_conf t1 on t.conf_id=t1.conf_id and t1.bsflag='0' " +
				"left join dms_assess_indexconf_item t2 on t1.item_id=t2.item_id and t2.bsflag='0' " +
				"where t.info_id ='" + id + "' and t.bsflag='0' order by t2.item_order");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ȡ�Ƿ��ϱ���Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIsReportData(ISrvMsg isrvmsg) throws Exception {
		log.info("getIsReportData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		String org_id = isrvmsg.getValue("org_id");
		String assess_date = isrvmsg.getValue("assess_date");
		//��ѯָ�꿼�˱�����
		String sql = "select count(*) as iflag from dms_assess_jbzx_info t "
				+ " left join dms_assess_jbzx_detail t1 "
				+ " on t.info_id=t1.info_id and t1.bsflag='0' "
				+ " where t.bsflag='0' and t.org_id='" + org_id
				+ "' and t.org_subjection_id='" + org_sub_id
				+ "' and t.assess_date='" + assess_date+ "'";
		Map map=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * ͨ����λ,���ڻ�ȡ�豸���ʽ�����Ч����ָ�������
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAddJbzxData(ISrvMsg isrvmsg) throws Exception {
		log.info("getAddJbzxData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		String org_id = isrvmsg.getValue("org_id");
		// ��ѯָ�꿼�˱�����
		String sql = "select t.conf_id,t.basic_data,t.control_target,t.item_id,t1.item_name"
				+ " from dms_assess_jbzx_conf t"
				+ " left join dms_assess_indexconf_item t1 on t.item_id=t1.item_id and t1.bsflag='0'"
				+ " where t.bsflag='0' " + " and t.org_subjection_id='"
				+ org_sub_id + "'" + " and t.org_id='" + org_id + "'"
				+ " order by t1.item_order";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ��λ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgName(ISrvMsg isrvmsg) throws Exception {
		log.info("getOrgName");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		String org_id = isrvmsg.getValue("org_id");
		// ��ѯָ�꿼�˱�����
		String sql = "select inf.org_abbreviation as org_name from comm_org_subjection sub"
				+ " left join comm_org_information inf "
				+ " on sub.org_id=inf.org_id and inf.bsflag='0'"
				+ " where sub.bsflag='0'  and sub.org_subjection_id='"
				+ org_sub_id
				+ "' and sub.org_id='"
				+ org_id
				+ "'";
		Map map=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * ��ȡ�豸���ʽ�����Ч����ָ����Ϣ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getJbzxInfoData(ISrvMsg isrvmsg) throws Exception {
		log.info("getJbzxInfoData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id = isrvmsg.getValue("id");
		//��ѯָ�꿼����Ϣ������
		String msql = "select t.info_id,t.org_id,t.org_subjection_id,t.assess_date,t2.org_abbreviation as org_name"
				+ " from dms_assess_jbzx_info t" 
				+ " left join comm_org_subjection t1 on t.org_subjection_id=t1.org_subjection_id"
				+ " left join comm_org_information t2 on t1.org_id=t2.org_id"
				+ " where t.bsflag='0' and t.info_id='"+id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		//��ѯָ�꿼����ϸ������
		String lsql = "select t.detail_id,t.conf_id,t.cumu_report,t1.basic_data,t1.control_target,t1.item_id,t2.item_name "
				+ "from dms_assess_jbzx_detail t "
				+ "right join dms_assess_jbzx_conf t1 on t.conf_id=t1.conf_id and t1.bsflag='0' "
				+ "left join dms_assess_indexconf_item t2 on t1.item_id=t2.item_id and t2.bsflag='0' "
				+ "where t.info_id='"
				+ id
				+ "' and t.bsflag='0' order by t2.item_order";
		List<Map> list= jdbcDao.queryRecords(lsql);
		responseDTO.setValue("map", map);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * �������޸��豸���ʽ�����Ч����ָ����Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateJbzxInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateJbzxInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String assess_date=map.get("assess_date").toString();//��������
		String orgId=map.get("org_id").toString();//������λ
		String orgSubId=map.get("org_subjection_id").toString();//��������������λ
		String flag=map.get("flag").toString();//�����޸ı�־
		String infoId="";//����ָ�꿼����Ϣ������
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//�������
				Map mainMap=new HashMap();
				mainMap.put("org_id", orgId);//������λ
				mainMap.put("org_subjection_id", orgSubId);//��������������λ
				mainMap.put("assess_date", assess_date);
				ServiceUtils.setCommFields(mainMap, "info_id", user);
				infoId = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_assess_jbzx_info");
			}else{//�޸Ĳ���
				infoId=map.get("info_id").toString();
				Map umainMap=new HashMap();
				umainMap.put("info_id", infoId);
				ServiceUtils.setCommFields(umainMap, "info_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_assess_jbzx_info");
			}
			for (Object key : map.keySet()) {
				if(((String)key).startsWith("detail_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if(null==map.get("detail_id_"+indexStr) || StringUtils.isBlank(map.get("detail_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("detail_id", iuuid);
						aMap.put("info_id", infoId);
						aMap.put("conf_id", (String)map.get("conf_id_"+indexStr));
						aMap.put("cumu_report", (String)map.get("cumu_report_"+indexStr));
						aMap.put("bsflag", "0");
						sqlList.add(assembleSql(aMap,"dms_assess_jbzx_detail",new String[] {"cumu_report"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("detail_id", (String)map.get("detail_id_"+indexStr));
						uMap.put("conf_id", (String)map.get("conf_id_"+indexStr));
						uMap.put("cumu_report", (String)map.get("cumu_report_"+indexStr));
						sqlList.add(assembleSql(uMap,"dms_assess_jbzx_detail",new String[] {"cumu_report"},"update","detail_id"));
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
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ɾ���豸���ʽ�����Ч����ָ����Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteJbzxInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteJbzxInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String id = isrvmsg.getValue("id");
		try{
			//ɾ������ָ�꿼����ϸ��
			String delSql0 = "update dms_assess_jbzx_detail set bsflag='1' where info_id='"+id+"'";
			jdbcDao.executeUpdate(delSql0);
			//ɾ������ָ����Ϣ��
			String delSql1 = "update dms_assess_jbzx_info set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where info_id='"+id+"'";
			jdbcDao.executeUpdate(delSql1);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ��ȡ�豸���ʽ�����Ч����ָ��ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getJbzxChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//��ȡ��ָ��id
		String item_id = isrvmsg.getValue("item_id");
		if(StringUtils.isBlank(item_id) || ("null".equals(item_id))){
			item_id="";
		}
		//ָ������
		String item_name = isrvmsg.getValue("item_name");
		if(StringUtils.isBlank(item_name) || ("null".equals(item_name))){
			item_name="";
		}else{
			if("1".equals(item_name)){
				item_name="�ʲ��۾�";
			}
			if("2".equals(item_name)){
				item_name="�ɹ��۸�";
			}
			if("3".equals(item_name)){
				item_name="���";
			}
			if("4".equals(item_name)){
				item_name="�첨������̯���۾�";
			}
			if("5".equals(item_name)){
				item_name="�豸ά��";
			}
		}
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		StringBuilder sql = new StringBuilder(
				"select tt.*,tt2.org_abbreviation as org_name,tt3.item_name from("
						+ " select nvl(max(t1.cumu_report),0) as cumu_report,nvl(max(t.control_target),0) as control_target,t.org_subjection_id,t.org_id,t.item_id"
						+ " from dms_assess_jbzx_conf t"
						+ " left join  dms_assess_jbzx_detail t1 on t.conf_id=t1.conf_id and t1.bsflag='0'"
						+ " where t.bsflag='0'");
		if (StringUtils.isNotBlank(item_id)) {
			sql.append(" and t.item_id = '" + item_id + "'");
		}
		if (StringUtils.isNotBlank(item_name)) {
			sql.append(" and t.item_id = (select item_id from dms_assess_indexconf_item where bsflag='0' and item_name='" + item_name + "')");
		}
		if(!"C105".equals(org_sub_id)){
			sql.append(" and t.org_subjection_id = '" + org_sub_id + "'");
		}
		sql.append(" group by t.org_id,t.org_subjection_id,t.item_id ");
		sql.append(") tt  left join comm_org_subjection tt1 on tt.org_subjection_id=tt1.org_subjection_id"
						+ " left join comm_org_information tt2 on tt1.org_id=tt2.org_id"
						+ " left join dms_assess_indexconf_item tt3 on tt.item_id=tt3.item_id and tt3.bsflag='0'");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		String level = isrvmsg.getValue("level");
		DecimalFormat df = new DecimalFormat("0.00");
		String value = "0";
		double costValue = 0;
		String costValueFormat = "";
		root.addAttribute("yAxisName", "(��λ����Ԫ)");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// ��������
		if(CollectionUtils.isNotEmpty(list) && list.size()>0){
			root.addAttribute("caption", list.get(0).get("item_name").toString());
			Element categories=root.addElement("categories");
			Element dataset1=root.addElement("dataset");
			dataset1.addAttribute("seriesName","�ۼ��ϱ�ֵ");
			Element dataset2=root.addElement("dataset");
			dataset2.addAttribute("seriesName","Ŀ��ֵ");
		    for (Map map:list) {
				Element category  = categories.addElement("category");
				category.addAttribute("label", map.get("org_name").toString());
				Element set1  = dataset1.addElement("set");
				set1.addAttribute("value", map.get("cumu_report").toString());
				Element set2  = dataset2.addElement("set");
				set2.addAttribute("value", map.get("control_target").toString());
		    }
		}
		responseDTO.setValue("Str", document.asXML());
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

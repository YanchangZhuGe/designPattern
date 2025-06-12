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
	 * ��ѯ�豸�������Ϣ 
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
		String dev_num = isrvmsg.getValue("q_dev_num");// ���ƺ���
		String dev_type = isrvmsg.getValue("q_dev_type");// �豸���
		String dev_name = isrvmsg.getValue("q_dev_name");// �豸����
		String thing_type = isrvmsg.getValue("q_thing_type");// ҵ������
		String orgSubId = user.getSubOrgIDofAffordOrg();// ����������λ
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.keeping_id,t.dev_name,t.dev_tname,t.dev_num,t.turn_date,"
				+ "t.keeping_date,info.org_abbreviation sub_org_id,t.dev_sign,t.self_num,"
				+ "case when t.thing_type = '1' then '���' when t.thing_type = '-1' then '����' else 'error' end as thing_type,"
				+ "case when t.dev_type like 'S0808%' then '����' " 		//����
				+ "when t.dev_type like 'S14050101%' then '������������' "   //������������
				+ "when t.dev_type like 'S0623%' then '�ɿ���Դ' "       //�ɿ���Դ
				+ "when t.dev_type like 'S1404%' then '�����豸' "       //�����豸
				+ "when t.dev_type like 'S060101%' then '��װ���' "     //��װ���
				+ "when t.dev_type like 'S060102%' then '��̧�����' "     //��̧�����
				+ "when t.dev_type like 'S070301%' then '������' "     //������
				+ "when t.dev_type like 'S0622%' then '������' "       //������
				+ "when t.dev_type like 'S08%' then '�����豸' "         //�����豸
				+ "when t.dev_type like 'S0901%' then '�������' "      //�������
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
			// ����������λ
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
	 * ��ѯ�豸�������Ϣ 
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
		String dev_num = isrvmsg.getValue("q_dev_num");// ���ƺ���
		String dev_type = isrvmsg.getValue("q_dev_type");// �豸���
		String dev_name = isrvmsg.getValue("q_dev_name");// �豸����
		String orgSubId = user.getSubOrgIDofAffordOrg();// ����������λ
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.keeping_id,t.dev_name,t.dev_tname,t.dev_num,t.turn_date,"
				+ "t.keeping_date,info.org_abbreviation sub_org_id,t.dev_sign,t.self_num,"
				+ "case when t.thing_type = '1' then '���' when t.thing_type = '-1' then '����' else 'error' end as thing_type,"
				+ "case when t.dev_type like 'S0808%' then '����' " 		//����
				+ "when t.dev_type like 'S14050101%' then '������������' "   //������������
				+ "when t.dev_type like 'S0623%' then '�ɿ���Դ' "       //�ɿ���Դ
				+ "when t.dev_type like 'S1404%' then '�����豸' "       //�����豸
				+ "when t.dev_type like 'S060101%' then '��װ���' "     //��װ���
				+ "when t.dev_type like 'S060102%' then '��̧�����' "     //��̧�����
				+ "when t.dev_type like 'S070301%' then '������' "     //������
				+ "when t.dev_type like 'S0622%' then '������' "       //������
				+ "when t.dev_type like 'S08%' then '�����豸' "         //�����豸
				+ "when t.dev_type like 'S0901%' then '�������' "      //�������
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
			// ����������λ
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
	 * ������ϸ��Ϣ
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
		// ��ѯ�ļ���
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ keeping_id + "' and t.bsflag='0' and t.is_file='1' ";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// �ļ�����
		responseMsg.setValue("fdataPublic", list2);// ����
		return responseMsg;
	}
	
	
	/**
	 * ɾ��ָ����Ϣ
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
				//ɾ������֪ͨ
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
	 * �����豸��ǰ״̬
	 * 
	 */
	public ISrvMsg getKeepingPosition(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String orgSubId = user.getSubOrgIDofAffordOrg();
		String code = "";
		String note = "";
		//����ľ��̽��
		if(orgSubId.indexOf("C105001005")!= -1){code="910600"; note="����ľ";};
		//�½���̽��
		if(orgSubId.indexOf("C105001002")!= -1){code="910200"; note="�½�";};
		//�¹���̽��
		if(orgSubId.indexOf("C105001003")!= -1){code="910300"; note="�¹�";};
		//�ຣ��̽��
		if(orgSubId.indexOf("C105001004")!= -1){code="910400"; note="�ຣ";};
		//������̽��
		if(orgSubId.indexOf("C105005004")!= -1){code="910700"; note="����";};
		//������̽��
		if(orgSubId.indexOf("C105005000")!= -1){code="910500"; note="����";};
		//������̽������
		if(orgSubId.indexOf("C105005001")!= -1){code="910900"; note="����";};
		//�����̽��
		if(orgSubId.indexOf("C105007")!= -1){code="911000"; note="���";};
		//�ɺ���̽��
		if(orgSubId.indexOf("C105063")!= -1){code="910800"; note="�ɺ�";};
		//�ۺ��ﻯ��
		if(orgSubId.indexOf("C105008")!= -1){code="911100"; note="�ۺ�";};
		//װ������
		if(orgSubId.indexOf("CC105006")!= -1){code="910100"; note="װ��";};
		Map<String,String> map=new HashMap<String,String>();  
		map.put("code",code);
		map.put("note",note);		
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * �����豸��ǰ״̬
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
	 * �޸�����֪ͨ��Ϣ
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
		String keeping_id = "";//���������
		System.out.println(flag);
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//�������
				Map mainMap=new HashMap();
				mainMap.put("dev_type", dev_type);//ָ������
				mainMap.put("dev_name", dev_name);//���
				mainMap.put("dev_tname", dev_tname);
				mainMap.put("dev_num", dev_num);
				mainMap.put("dev_sign", dev_sign);
				mainMap.put("dev_id", dev_id);
				mainMap.put("self_num", self_num);
				mainMap.put("thing_type", thing_type);
				mainMap.put("sub_org_id", sub_org_id);
				mainMap.put("turn_date", turn_date);//ָ������
				mainMap.put("keeping_date", keeping_date);//���
				mainMap.put("turn_pp", turn_pp);//ָ������
				mainMap.put("keeping_pp", keeping_pp);//���
				mainMap.put("dev_turn_num", dev_turn_num);
				mainMap.put("given_pp", given_pp);
				mainMap.put("dev_clean", dev_clean);
				mainMap.put("mark_num", mark_num);
				mainMap.put("port_num", port_num);
				mainMap.put("key_num", key_num);//ָ������
				mainMap.put("tool_num", tool_num);//���
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
				//�����豸�����б��KEEPING_FLAGΪ1���Ա�֤ͬһ�������б���豸��������豸���֮�󲻱��ٴ����
				String updatesql ="update gms_device_backapp_detail dt set dt.KEEPING_FLAG=1 "
						+ "where dt.dev_acc_id="+dev_id;
				jdbcDao.executeUpdate(updatesql);
			}else{//�޸Ĳ���
				keeping_id=(String)map.get("keeping_id");
				Map umainMap=new HashMap();
				umainMap.put("keeping_id", keeping_id);//ָ������
				umainMap.put("dev_type", dev_type);//ָ������
				umainMap.put("dev_name", dev_name);//���
				umainMap.put("dev_tname", dev_tname);
				umainMap.put("dev_num", dev_num);
				umainMap.put("dev_sign", dev_sign);
				umainMap.put("dev_id", dev_id);
				umainMap.put("self_num", self_num);
				umainMap.put("thing_type", thing_type);
				umainMap.put("sub_org_id", sub_org_id);
				umainMap.put("turn_date", turn_date);//ָ������
				umainMap.put("keeping_date", keeping_date);//���
				umainMap.put("turn_pp", turn_pp);//ָ������
				umainMap.put("keeping_pp", keeping_pp);//���
				umainMap.put("dev_turn_num", dev_turn_num);
				umainMap.put("given_pp", given_pp);
				umainMap.put("dev_clean", dev_clean);
				umainMap.put("mark_num", mark_num);
				umainMap.put("port_num", port_num);
				umainMap.put("key_num", key_num);//ָ������
				umainMap.put("tool_num", tool_num);//���
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
			//�洢��������
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			List<WSFile> filesOther = mqMsgOther.getFiles();
			Map<String, Object> doc = new HashMap<String, Object>();
			MyUcm ucm = new MyUcm();
			String filename = "";
			String fileOrder = "";
			String ucmDocId = "";
			try {// ������
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
					// ������
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					// ��־��
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
							user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
				}
			} catch (Exception e) {
				System.out.println("����δ������޸�");
			}
		} catch (Exception e) {
			e.printStackTrace();
			operationFlag = "failed";
		}
		return responseDTO;
	}
	
	/**
	 * ������ϸ��Ϣ
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
	 * NEWMETHOD ��ʾ�����豸(��̨)
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
		//String zhEquSub = msg.getValue("zhequsub");//�Ƿ�Ϊ�ۺ��ﻯ̽
		//String addEd = msg.getValue("added");//�Ƿ�Ϊ�����豸
		//String collFlag = msg.getValue("collflag");//�Ƿ�Ϊװ������"��װ���������ѡ������װ�������豸
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
		if(DevUtil.isValueNotNull(addEd,"Y")){//װ��Ҫ�󲹳��豸���ܳ���Դֻ���Ǹ����豸
			querySql.append(" and acc.dev_type not like 'S0623%' ");
		}*/
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and acc.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and acc.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and acc.license_num like '%"+licenseNum+"%'");
		}
		//���ڵ�λ
		if (StringUtils.isNotBlank(ownOrgName)) {
			querySql.append(" and org.org_abbreviation like '%"+ownOrgName+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and acc.dev_coding like '%"+devCoding+"%'");
		}
		//AMIS�ʲ����
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
						+ " when acc.dev_type like 'S0808%' then 1" 		//����
						+ " when acc.dev_type like 'S14050101%' then 2"   //������������
						+ " when acc.dev_type like 'S0623%' then 3"       //�ɿ���Դ
						+ " when acc.dev_type like 'S1404%' then 4"       //�����豸
						+ " when acc.dev_type like 'S060101%' then 5"     //��װ���
						+ " when acc.dev_type like 'S060102%' then 6"     //��̧�����
						+ " when acc.dev_type like 'S070301%' then 7"     //������
						+ " when acc.dev_type like 'S0622%' then 8"       //������
						+ " when acc.dev_type like 'S08%' then 9"         //�����豸
						+ " when acc.dev_type like 'S0901%' then 10"      //�������
						+ " end,acc.dev_model,acc.dev_sign,acc.dev_acc_id ");
			}else{*/
				querySql.append(" order by case"
						+ " when acc.dev_type like 'S08%' then 1" 		  //����
						+ " when acc.dev_type like 'S070301%' then 2"     //������
						+ " when acc.dev_type like 'S060101%' then 3"     //��װ���
						+ " when acc.dev_type like 'S060102%' then 4"     //��̧�����
						+ " when acc.dev_type like 'S0901%' then 5"       //�������
						+ " when acc.dev_type like 'S1404%' then 6"       //�����豸
						+ " when acc.dev_type like 'S14050101%' then 7"   //������������
						+ " when acc.dev_type like 'S0623%' then 8"       //�ɿ���Դ
						+ " when acc.dev_type like 'S0622%' then 9"       //������
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
	 * NEWMETHOD ��ʾȫ���豸(��̨)
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
			// ����������λ
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and account.owning_sub_id like '"+orgSubId+"%'" );
			}
		}
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and account.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and account.dev_model like '"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and account.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and account.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and account.license_num like '%"+licenseNum+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and account.dev_coding like '%"+devCoding+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",account.dev_acc_id ");
		}else{
			querySql.append(" order by case"
					+ " when dev_type like 'S08%' then 1" 		  //����
					+ " when dev_type like 'S070301%' then 2"     //������
					+ " when dev_type like 'S060101%' then 3"     //��װ���
					+ " when dev_type like 'S060102%' then 4"     //��̧�����
					+ " when dev_type like 'S0901%' then 5"       //�������
					+ " when dev_type like 'S1404%' then 6"       //�����豸
					+ " when dev_type like 'S14050101%' then 7"   //������������
					+ " when dev_type like 'S0623%' then 8"       //�ɿ���Դ
					+ " when dev_type like 'S0622%' then 9"       //������
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

package com.bgp.gms.service.rm.dm;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class WtcPubDevSrv implements IWtcDevSrv {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	@Override
	public String saveDevMixForm(ISrvMsg msg, String devType)throws Exception {
		UserToken user = msg.getUserToken();
		String projectInfoNo = msg.getValue("projectInfoNo");
		String projectOrgId = msg.getValue("projectOrgId");
		String mixInfoName = msg.getValue("mix_info_name");
		String employeeId = msg.getValue("employee_id");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String appDate = msg.getValue("appdate");//����ʱ��
		String outOrgId = msg.getValue("out_org_id");
		String mixformType = msg.getValue("mixform_type");
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("mixinfo_name", mixInfoName);
		mainMap.put("project_info_no", projectInfoNo);
		mainMap.put("in_org_id", projectOrgId);//ת�뵥λ����Ŀ����С��
		mainMap.put("out_org_id", outOrgId);//�豸ת����λ
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("mixform_type", mixformType);//��̽��ֱ�ӵ����첨��
		mainMap.put("wapproval_date", appDate);
		if("JBQ".equals(devType)){
			mainMap.put("mix_type_id", DevConstants.MIXTYPE_JIANBOQI);
		}else if("COLL".equals(devType)){
			mainMap.put("mix_type_id", DevConstants.MIXTYPE_YIQI);
		}else{
			mainMap.put("mix_type_id", DevConstants.MIXTYPE_COMMON);
		}		
		mainMap.put("state", DevConstants.STATE_SAVED);
		mainMap.put("opr_state", DevConstants.STATE_SAVED);
		String mixInfoNo = "";//��������
		if(addUpFlag != null && "add".equals(addUpFlag)){//����
			if("JBQ".equals(devType)){
				mixInfoNo = DevUtil.getWTCDevMixAppNo("JBQ");//�첨���豸����
			}else if("COLL".equals(devType)){
				mixInfoNo = DevUtil.getWTCDevMixAppNo("COLL");//���������豸����
			}else{
				mixInfoNo = DevUtil.getWTCDevMixAppNo("DT");//���е�̨�豸����
			}			
			mainMap.put("create_date", DevUtil.getCurrentTime());
			mainMap.put("creator_id", user.getEmpId());
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
			mainMap.put("mix_user_id", employeeId);//������ID(��̽��������Ա)
			mainMap.put("mix_org_id", user.getOrgId());//���������ڵ�λ
			mainMap.put("print_emp_id", employeeId);//������(��̽��������Ա)
			mainMap.put("org_id", user.getOrgId());//�����˵�λorg_id
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());//�����˵�λsub_id
		}else{
			mixInfoNo = msg.getValue("mix_info_no");
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
		}
		mainMap.put("mixinfo_no", mixInfoNo);
		String mixInfoId = msg.getValue("device_mixinfo_id");
		if (DevUtil.isValueNotNull(mixInfoId)) {
			mainMap.put("device_mixinfo_id", mixInfoId);
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_mixinfo_form");
		}else{
			mixInfoId = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_mixinfo_form");
		}
		return mixInfoId;
	}
	@Override
	public String saveHireDevApp(ISrvMsg msg) throws Exception{
		UserToken user = msg.getUserToken();
		String projectInfoNo = msg.getValue("projectInfoNo");
		String projectOrgId = msg.getValue("projectOrgId");
		String hireAppName = msg.getValue("device_hireapp_name");
		String employeeId = msg.getValue("employee_id");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String addDate = msg.getValue("appdate");//����ʱ��
		String hireDevType = msg.getValue("hiredevtype");
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("device_hireapp_name", hireAppName);
		mainMap.put("app_org_id", projectOrgId);//���뵥λ����Ŀ����С��
		mainMap.put("appdate", addDate);//����ʱ��
		mainMap.put("employee_id", employeeId);//�����˼��˵��ݵĵ�����
		mainMap.put("project_info_no", projectInfoNo);
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("mix_type_id", hireDevType);		
		mainMap.put("state", DevConstants.STATE_SAVED);
		mainMap.put("opr_state", DevConstants.STATE_SAVED);
		String hireAppNo = "";//��������
		if(addUpFlag != null && "add".equals(addUpFlag)){//����
			if("5110000184000000003".equals(hireDevType)){
				hireAppNo = DevUtil.getWTCHireDevAppNo("WZJBQ");//����첨���豸����
			}else{
				hireAppNo = DevUtil.getWTCHireDevAppNo("WZDT");//�������е�̨�豸����
			}			
			mainMap.put("create_date", DevUtil.getCurrentTime());
			mainMap.put("creator_id", user.getEmpId());
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
			mainMap.put("org_id", user.getOrgId());//�����˵�λorg_id
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());//�����˵�λsub_id
		}else{
			hireAppNo = msg.getValue("device_hireapp_no");
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
		}
		mainMap.put("device_hireapp_no", hireAppNo);
		String hireAppId = msg.getValue("device_hireapp_id");
		if (DevUtil.isValueNotNull(hireAppId)) {
			mainMap.put("device_hireapp_id", hireAppId);
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_hireapp");
		}else{
			hireAppId = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_hireapp");
		}
		return hireAppId;
	}
	@Override
	public String saveDevOsApp(ISrvMsg msg) throws Exception{
		UserToken user = msg.getUserToken();
		String projectInfoNo = msg.getValue("projectinfono");
		String osAppName = msg.getValue("osappname");
		String employeeId = msg.getValue("employeeid");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String appDate = msg.getValue("osappdate");//����ʱ��
		String osAppOrgId = msg.getValue("osapporgid");
		String deviceOsAppId = msg.getValue("deviceosappid");
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("project_info_no", projectInfoNo);
		mainMap.put("osapp_org_id", osAppOrgId);
		mainMap.put("osapp_name", osAppName);
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("os_employee_id", employeeId);
		mainMap.put("osappdate", appDate);
		mainMap.put("state", DevConstants.STATE_SAVED);

		String devOsAppNo = "";//��ͣ�ƻ�����
		if(addUpFlag != null && "add".equals(addUpFlag)){//����
			devOsAppNo =  DevUtil.getOSAppInfoNo();//�첨���豸����
			mainMap.put("create_date", DevUtil.getCurrentTime());
			mainMap.put("creator_id", user.getEmpId());
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
			mainMap.put("org_id", user.getOrgId());//�����˵�λorg_id
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());//�����˵�λsub_id
		}else{
			devOsAppNo = msg.getValue("deviceosappno");
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
		}
		mainMap.put("device_osapp_no", devOsAppNo);
		if (DevUtil.isValueNotNull(deviceOsAppId)) {
			mainMap.put("device_osapp_id", deviceOsAppId);
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_osapp");
		}else{
			deviceOsAppId = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_osapp");
		}
		return deviceOsAppId;		
	}
	@Override
	public String saveMovDevApp(ISrvMsg msg,String dcFlag) throws Exception{
		UserToken user = msg.getUserToken();
		// ת��ת����ĿID
		String outProjectInfoNo = msg.getValue("outProjectInfoNo");
		String inProjectInfoNo = msg.getValue("inProjectInfoNo");
		String devMovName = msg.getValue("dev_mov_name");
		String movEmployeeId = msg.getValue("mov_employee_id");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String applyDate = msg.getValue("apply_date");//����ʱ��
		String multiFlag = msg.getValue("multiflag");// ����Ŀ�͵���Ŀת�����֣�YΪ����Ŀ�豸ת��
		String devMovId = msg.getValue("devmovid");
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("out_project_info_id", outProjectInfoNo);
		mainMap.put("in_project_info_id", inProjectInfoNo);
		mainMap.put("dev_mov_name", devMovName);
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("opertor_id", movEmployeeId);
		mainMap.put("apply_date", applyDate);
		if("COLL".equals(dcFlag)){
			if (DevUtil.isValueNotNull(multiFlag) && "Y".equals(multiFlag)) {
				mainMap.put("dev_type", "wcoll");
			} else {
				mainMap.put("dev_type", "coll");
			}
		}else{
			if (DevUtil.isValueNotNull(multiFlag) && "Y".equals(multiFlag)) {
				mainMap.put("dev_type", "wdev");
			} else {
				mainMap.put("dev_type", "dev");
			}
		}
		String devMovNo = "";
		if(DevUtil.isValueNotNull(addUpFlag) && "add".equals(addUpFlag)){//����
			devMovNo =  DevUtil.getMoveAppNo();
			mainMap.put("create_date", DevUtil.getCurrentTime());
			mainMap.put("creator_id", user.getEmpId());
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
			mainMap.put("org_id", user.getOrgId());//�����˵�λorg_id
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());//�����˵�λsub_id
		}else{
			devMovNo = msg.getValue("dev_mov_no");
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
		}
		mainMap.put("dev_mov_no", devMovNo);
		mainMap.put("move_status", DevConstants.STATE_SAVED);
		if (DevUtil.isValueNotNull(devMovId)) {
			mainMap.put("dev_mov_id", devMovId);
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_move");
		}else{
			devMovId = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_move");
		}
		return devMovId;		
	}
	@Override
	public String saveBackDevApp(ISrvMsg msg) throws Exception{
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String backDevType = msg.getValue("backdevtype");
		String backAppId = msg.getValue("devicebackappid");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String backDate = msg.getValue("backdate");//����ʱ��
		String backAppName = msg.getValue("backappname");
		String rcvOrgId = msg.getValue("receive_org_id");
		String searchBackappId = UUID.randomUUID().toString().replaceAll("-", "");
		String devBackAppNo = "";
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("project_info_id", projectInfoNo);								//��ĿID
		if(user.getOrgSubjectionId().startsWith("C105008")){//�ۺ��ﻯ̽��Ŀ��λ����Ϊ������޷���ʾ
			mainMap.put("back_org_id", user.getOrgId());						    //������λ
		}else{
			mainMap.put("back_org_id", user.getTeamOrgId());						//������λ
		}
		mainMap.put("back_employee_id", user.getEmpId());							//������ID
		mainMap.put("backdate", backDate);						    				//����ʱ��
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);							//ɾ����ʶ
		mainMap.put("state", DevConstants.STATE_SAVED);								//���뵥״̬,0δ�ύ
		mainMap.put("search_backapp_id", searchBackappId);							//��ѯ�����ֶ�
		mainMap.put("backapp_name", backAppName);					                //����������
		mainMap.put("backapptype", DevConstants.BACK_DEVTYPE_TONOMIXBACK);			//����״̬
		mainMap.put("opr_state", DevConstants.SAVE_FLAG_0);				            //���մ���״̬
		
		if(DevUtil.isValueNotNull(addUpFlag,"add")){//���� 
			if(backDevType.equals(DevConstants.BACK_DEVTYPE_ZIYOU)){
				devBackAppNo = DevUtil.getDevBackAppNo("ZY");
			}else if(backDevType.equals(DevConstants.BACK_DEVTYPE_ZHENYUAN)){
				devBackAppNo = DevUtil.getDevBackAppNo("JY");
			}else if(backDevType.equals(DevConstants.BACK_DEVTYPE_CELIANG)){
				devBackAppNo = DevUtil.getDevBackAppNo("CL");
			}else if(backDevType.equals(DevConstants.BACK_DEVTYPE_YIQI_FUSHU)||
					backDevType.equals(DevConstants.BACK_DEVTYPE_YIQI)){
				devBackAppNo = DevUtil.getDevBackAppNo("YQFS");
			}else if(backDevType.equals(DevConstants.BACK_DEVTYPE_SWAP)){
				devBackAppNo = DevUtil.getDevBackAppNo("TJ");
			}else if(backDevType.equals(DevConstants.BACK_DEVTYPE_JBQ)){
				devBackAppNo = DevUtil.getDevBackAppNo("JBQ");
			}else if(backDevType.equals(DevConstants.BACK_DEVTYPE_DG_DZYQ)
					|| backDevType.equals(DevConstants.BACK_DEVTYPE_ZB_DZYQ)){
				devBackAppNo = DevUtil.getDevBackAppNo("COLL");
			}			
			mainMap.put("backdevtype", backDevType);									//��������
			mainMap.put("receive_org_id", rcvOrgId);									//���յ�λID
			mainMap.put("create_date", DevUtil.getCurrentTime());						//��������
			mainMap.put("creator_id", user.getEmpId());									//������	
			mainMap.put("modifi_date",DevUtil.getCurrentTime());						//�޸�ʱ��
			mainMap.put("updator_id", user.getEmpId());									//�޸���
			mainMap.put("org_id", user.getOrgId());										//������������֯����Id
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());				//������������֯��������ID
		}else{			
			devBackAppNo = msg.getValue("device_backapp_no");
			mainMap.put("modifi_date",DevUtil.getCurrentTime());						//�޸�ʱ��
			mainMap.put("updator_id", user.getEmpId());	
		}
		mainMap.put("device_backapp_no", devBackAppNo);							    //��������
		if(backDevType.equals(DevConstants.BACK_DEVTYPE_JBQ) 
				|| backDevType.equals(DevConstants.BACK_DEVTYPE_DG_DZYQ)
					|| backDevType.equals(DevConstants.BACK_DEVTYPE_ZB_DZYQ)){
			//�첨������������(������е���������װ��רҵ����������)����
			if (DevUtil.isValueNotNull(backAppId)) {
				mainMap.put("device_backapp_id", backAppId);
				jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_collbackapp");
			}else{
				backAppId = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_collbackapp");
			}			
		}else{
			if (DevUtil.isValueNotNull(backAppId)) {
				mainMap.put("device_backapp_id", backAppId);
				jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_backapp");
			}else{
				backAppId = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_backapp");
			}
		}
		return backAppId;		
	}
	@Override
	public String saveDevArchive(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String employeeId = msg.getValue("employeeId");//����Ŀת���ύ����form�ύ���ܻ���û�token
		if(!DevUtil.isValueNotNull(employeeId)){
			employeeId = user.getEmpId();
		}
		String outProjectNo = msg.getValue("outProjectInfoNo");
		String wrongFlag = "";
		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("employee_id", employeeId);
			dataMap.put("out_project_no", outProjectNo);
			datasList.add(dataMap);
		}
		try{
			// 1. ���豸�����ת��¼
			String upYzjlSql = "insert into gms_device_archive_detail "
								+ " (dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,"
								+ " dev_archive_refid,seqinfo,creator,create_date)"
								+ " (select t.operation_info_id,dui.project_info_id,dui.fk_dev_acc_id,"
								+ " '1',t.operation_info_id,rownum,?,sysdate "
								+ " from gms_device_operation_info t"
								+ " join gms_device_account_dui dui on t.dev_acc_id=dui.dev_acc_id "
								+ " where dui.project_info_id = ? and dui.dev_acc_id = ? )";
			jdbcDao.getJdbcTemplate().batchUpdate(upYzjlSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devYzjlMap = datasList.get(i);
							ps.setString(1, (String) devYzjlMap.get("employee_id"));
							ps.setString(2, (String) devYzjlMap.get("out_project_no"));
							ps.setString(3, (String) devYzjlMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "YZJL";
		}
		try{
			// 2. ���豸��ص�ǿ�Ʊ�����¼
			String upQzbySql = "insert into gms_device_archive_detail "
							 + " (dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,"
							 + " seqinfo,creator,create_date) (select t.repair_info,dui.project_info_id,dui.fk_dev_acc_id,"
							 + " '2',t.repair_info,rownum,?,sysdate from bgp_comm_device_repair_info t"
							 + " join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
							 + " where dui.project_info_id = ? and dui.dev_acc_id = ? and t.repair_level='605')";
			jdbcDao.getJdbcTemplate().batchUpdate(upQzbySql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devQzbyMap = datasList.get(i);
							ps.setString(1, (String) devQzbyMap.get("employee_id"));
							ps.setString(2, (String) devQzbyMap.get("out_project_no"));
							ps.setString(3, (String) devQzbyMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "QZBY";
		}
		try{
			// 3. ���豸��ص�����������
			String upDjxhSql = "insert into gms_device_archive_detail "
							 + "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,"
							 + " seqinfo,creator,create_date) (select t.repair_detail_id,dui.project_info_id,"
							 + " dui.fk_dev_acc_id,'3',t.repair_detail_id,rownum,?,sysdate "
							 + " from bgp_comm_device_repair_detail t"
							 + " left join bgp_comm_device_repair_info rp on t.repair_info=rp.repair_info "
							 + " join gms_device_account_dui dui on rp.device_account_id=dui.dev_acc_id "
							 + " where dui.project_info_id = ? and dui.dev_acc_id = ? )";
			jdbcDao.getJdbcTemplate().batchUpdate(upDjxhSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devDjxhMap = datasList.get(i);
							ps.setString(1, (String) devDjxhMap.get("employee_id"));
							ps.setString(2, (String) devDjxhMap.get("out_project_no"));
							ps.setString(3, (String) devDjxhMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "DJXH";
		}
		try{
			// 4. ���豸�����ˮ����
			String upYsxhSql = "insert into gms_device_archive_detail"
							 + "(dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,"
							 + " seqinfo,creator,create_date) (select t.oil_info_id,dui.project_info_id,"
							 + " dui.fk_dev_acc_id,'4',t.oil_info_id,rownum,?,sysdate "
							 + " from bgp_comm_device_oil_info t"
							 + " join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id"
							 + " where dui.project_info_id = ? and dui.dev_acc_id = ? )";
			jdbcDao.getJdbcTemplate().batchUpdate(upYsxhSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devYsxhMap = datasList.get(i);
							ps.setString(1, (String) devYsxhMap.get("employee_id"));
							ps.setString(2, (String) devYsxhMap.get("out_project_no"));
							ps.setString(3, (String) devYsxhMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "YSXH";
		}
		try{
			// 5. ���豸��صĶ��˶���������¼
			String upDrdjSql = "insert into gms_device_archive_detail"
							 + " (dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,"
							 + " seqinfo,creator,create_date) (select t.entity_id,dui.project_info_id,"
							 + " dui.fk_dev_acc_id,'5',t.entity_id,rownum,?,sysdate "
							 + " from gms_device_equipment_operator t"
							 + " join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
							 + " where dui.project_info_id = ? and dui.dev_acc_id = ? )";
			jdbcDao.getJdbcTemplate().batchUpdate(upDrdjSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devDrdjMap = datasList.get(i);
							ps.setString(1, (String) devDrdjMap.get("employee_id"));
							ps.setString(2, (String) devDrdjMap.get("out_project_no"));
							ps.setString(3, (String) devDrdjMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "DRDJ";
		}
		try{
			// 6. ���豸����¹ʼ�¼
			String upSgjlSql = "insert into gms_device_archive_detail "
							 + " (dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,"
							 + " seqinfo,creator,create_date) (select t.accident_info_id,dui.project_info_id,"
							 + " dui.fk_dev_acc_id,'6',t.accident_info_id,rownum,?,sysdate "
							 + " from bgp_comm_device_accident_info t"
							 + " join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
							 + " where dui.project_info_id = ? and dui.dev_acc_id = ? )";
			jdbcDao.getJdbcTemplate().batchUpdate(upSgjlSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devSgjlMap = datasList.get(i);
							ps.setString(1, (String) devSgjlMap.get("employee_id"));
							ps.setString(2, (String) devSgjlMap.get("out_project_no"));
							ps.setString(3, (String) devSgjlMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "SGJL";
		}
		try{
			// 7. ���豸��ص�ά�޼�¼
			String upWxjlSql = "insert into gms_device_archive_detail "
							 + " (dev_archive_detid,project_info_id,dev_acc_id,dev_archive_type,dev_archive_refid,"
							 + " seqinfo,creator,create_date) (select t.repair_info,dui.project_info_id,"
							 + " dui.fk_dev_acc_id,'7',t.repair_info,rownum,t.creator,sysdate"
							 + " from bgp_comm_device_repair_info t"
							 + " join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id "
							 + " where dui.project_info_id = ? and dui.dev_acc_id = ?"
							 + " and t.repair_level<>'605' )";
			jdbcDao.getJdbcTemplate().batchUpdate(upWxjlSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devWxjlMap = datasList.get(i);
							ps.setString(1, (String) devWxjlMap.get("out_project_no"));
							ps.setString(2, (String) devWxjlMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "WXJL";
		}
		return wrongFlag;
	}
	@Override
	public String saveVirProDevArchive(ISrvMsg msg) throws Exception {
		String inProjectNo = msg.getValue("inProjectInfoNo");
		String wrongFlag = "";
		String[] idInfos = msg.getValue("idinfos").split("~", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < idInfos.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_acc_id", idInfos[index]);
			dataMap.put("in_project_no", inProjectNo);
			datasList.add(dataMap);
		}
		try{
			// 1. ���豸�����ת��¼
			String upYzjlSql = "update gms_device_operation_info set"
							 + " project_info_no = ?"
							 + " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upYzjlSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devYzjlMap = datasList.get(i);
							ps.setString(1, (String) devYzjlMap.get("in_project_no"));
							ps.setString(2, (String) devYzjlMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "YZJL";
		}
		try{
			// 2. ���豸��ص�ǿ�Ʊ�����¼��ά�޼�¼��������������
			String upQzbySql = "update bgp_comm_device_repair_info set"
					 		 + " project_info_no = ?"
					 		 + " where device_account_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upQzbySql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devQzbyMap = datasList.get(i);
							ps.setString(1, (String) devQzbyMap.get("in_project_no"));
							ps.setString(2, (String) devQzbyMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "QZBY";
		}
		try{
			// 3. ���豸��صĶ��˶���������¼
			String upDrdjSql = "update gms_device_equipment_operator set"
					 		 + " project_info_id = ?"
					 		 + " where device_account_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upDrdjSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devDrdjMap = datasList.get(i);
							ps.setString(1, (String) devDrdjMap.get("in_project_no"));
							ps.setString(2, (String) devDrdjMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "DRDJ";
		}
		try{
			// 4. ���豸��صı����ƻ�
			String upByjhSql = "update gms_device_maintenance_plan set"
					 		 + " project_info_id = ?"
					 		 + " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upByjhSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devByjhMap = datasList.get(i);
							ps.setString(1, (String) devByjhMap.get("in_project_no"));
							ps.setString(2, (String) devByjhMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "BYJH";
		}
		try{
			// 5. ���豸��ص��ճ����
			String upRcjcSql = "update gms_device_inspectioin set"
					 		 + " project_info_no = ?"
					 		 + " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upRcjcSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devRcjcMap = datasList.get(i);
							ps.setString(1, (String) devRcjcMap.get("in_project_no"));
							ps.setString(2, (String) devRcjcMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "RCJC";
		}
		try{
			// 6. ���豸��ص�״̬����¼
			String upZtjcSql = "update gms_device_work_information set"
					 		 + " project_info_no = ?"
					 		 + " where dev_acc_id = ? ";
			jdbcDao.getJdbcTemplate().batchUpdate(upZtjcSql,
					new BatchPreparedStatementSetter() {
						@Override
						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							Map<String, Object> devZtjcMap = datasList.get(i);
							ps.setString(1, (String) devZtjcMap.get("in_project_no"));
							ps.setString(2, (String) devZtjcMap.get("dev_acc_id"));
						}
						@Override
						public int getBatchSize() {
							return datasList.size();
						}
					});
		}catch(Exception e){
			e.printStackTrace();
			wrongFlag = "ZTJC";
		}
		return wrongFlag;
	}
	@Override
	public boolean opVirProDev(String outProjectNo) throws Exception {
		boolean opFlag = true;
		try{
			//ɾ����Ŀ��  1�������ж϶Ӽ���̨�豸�������豸̨���Ƿ����豸  2���ж��Ƿ��е����к�Ϊ����ĵ���  3���ж��Ƿ���δ�ύ�ʹ������ĵ���
			jdbcDao.executeUpdate("update gp_task_project pro set pro.bsflag = '"+DevConstants.BSFLAG_DELETE+"',"
					 + " pro.notes = '"+DevConstants.PROJECT_DELXN+"' where not exists"
					 + " (select 1 from gms_device_account_dui accdui where accdui.project_info_id = '"+outProjectNo+"'"
					 + " union all"
					 + " select 1 from gms_device_coll_account_dui colldui where colldui.project_info_id = '"+outProjectNo+"')"
					 + " and not exists"
					 + " (select 1 from gms_device_mixinfo_form mix"
					 + " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
                     + " where mix.state = '9' and mix.bsflag = '0' and pro.bsflag = '2'"
                     + " and mix.opr_state != '9' and mix.opr_state != '4' and mix.project_info_no = '"+outProjectNo+"'"
                     + " union all"
                     + " select 1 from gms_device_collmix_form cmf"
                     + " left join gp_task_project tp on cmf.project_info_no = tp.project_info_no"
                     + " where cmf.state = '9' and cmf.bsflag = '0' and tp.bsflag = '2'"
                     + " and cmf.opr_state != '9' and cmf.opr_state != '4' and cmf.project_info_no = '"+outProjectNo+"')"
                     + " and not exists"
                     + " (select 1 from gms_device_collapp devapp"
                     + " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id"
                     + " and wfmiddle.bsflag = '0'"
                     + " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
                     + " where devapp.bsflag = '0' and devapp.mix_org_type = '1' and pro.bsflag = '2'"
                     + " and wfmiddle.proc_status != '3' and wfmiddle.proc_status != '4' and devapp.project_info_no = '"+outProjectNo+"'"
                     + " union all"
                     + " select 1 from gms_device_app devapp"
                     + " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id"
                     + " and wfmiddle.bsflag = '0'"
                     + " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
                     + " where devapp.bsflag = '0' and devapp.mix_org_type = '1'"
                     + " and (devapp.mix_type_id = 'S1404' or devapp.mix_type_id = 'S0623' or devapp.mix_type_id = 'S0622')"
                     + " and pro.bsflag = '2' and wfmiddle.proc_status != '3' and wfmiddle.proc_status != '4'"
                     + " and devapp.project_info_no = '"+outProjectNo+"')"
					 + " and pro.bsflag = '"+DevConstants.PROJECT_XN+"' and pro.project_info_no = '"+outProjectNo+"'");
			//ɾ����Ŀ��̬�� 1�������ж϶Ӽ���̨�豸�������豸̨���Ƿ����豸  2���ж��Ƿ��е����к�Ϊ����ĵ���  3���ж��Ƿ���δ�ύ�ʹ������ĵ���
			jdbcDao.executeUpdate("update gp_task_project_dynamic dy set dy.bsflag = '"+DevConstants.BSFLAG_DELETE+"',"
					 + " dy.notes = '"+DevConstants.PROJECT_DELXN+"' where not exists"
					 + " (select 1 from gms_device_account_dui accdui where accdui.project_info_id = '"+outProjectNo+"'"
					 + " union all"
					 + " select 1 from gms_device_coll_account_dui colldui where colldui.project_info_id = '"+outProjectNo+"')"
					 + " and not exists"
					 + " (select 1 from gms_device_mixinfo_form mix"
					 + " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
                     + " where mix.state = '9' and mix.bsflag = '0' and pro.bsflag = '2'"
                     + " and mix.opr_state != '9' and mix.opr_state != '4' and mix.project_info_no = '"+outProjectNo+"'"
                     + " union all"
                     + " select 1 from gms_device_collmix_form cmf"
                     + " left join gp_task_project tp on cmf.project_info_no = tp.project_info_no"
                     + " where cmf.state = '9' and cmf.bsflag = '0' and tp.bsflag = '2'"
                     + " and cmf.opr_state != '9' and cmf.opr_state != '4' and cmf.project_info_no = '"+outProjectNo+"')"
                     + " and not exists"
                     + " (select 1 from gms_device_collapp devapp"
                     + " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id"
                     + " and wfmiddle.bsflag = '0'"
                     + " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
                     + " where devapp.bsflag = '0' and devapp.mix_org_type = '1' and pro.bsflag = '2'"
                     + " and wfmiddle.proc_status != '3' and wfmiddle.proc_status != '4'"
                     + " and devapp.project_info_no = '"+outProjectNo+"'"
                     + " union all"
                     + " select 1 from gms_device_app devapp"
                     + " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id"
                     + " and wfmiddle.bsflag = '0'"
                     + " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
                     + " where devapp.bsflag = '0' and devapp.mix_org_type = '1'"
                     + " and (devapp.mix_type_id = 'S1404' or devapp.mix_type_id = 'S0623' or devapp.mix_type_id = 'S0622')"
                     + " and pro.bsflag = '2' and wfmiddle.proc_status != '3' and wfmiddle.proc_status != '4'"
                     + " and devapp.project_info_no = '"+outProjectNo+"')"
					 + " and dy.bsflag = '"+DevConstants.PROJECT_XN+"' and dy.project_info_no = '"+outProjectNo+"'");
		}catch(Exception e){
			e.printStackTrace();
			opFlag = false;
		}
		return opFlag;
	}
	@Override
	public String saveHireDevAppNew(ISrvMsg msg) throws Exception{
		UserToken user = msg.getUserToken();
		String projectInfoNo = msg.getValue("projectInfoNo");
		String projectOrgId = msg.getValue("projectOrgId");
		String hireAppName = msg.getValue("device_hireapp_name");
		String employeeId = msg.getValue("employee_id");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String addDate = msg.getValue("appdate");//����ʱ��
		String hireDevClass = msg.getValue("hiredevclass");
		String device_type = msg.getValue("device_type");//�豸���0����̨1���첨��2����������
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("device_hireapp_name", hireAppName);
		mainMap.put("app_org_id", projectOrgId);//���뵥λ����Ŀ����С��
		mainMap.put("appdate", addDate);//����ʱ��
		mainMap.put("employee_id", employeeId);//�����˼��˵��ݵĵ�����
		mainMap.put("project_info_no", projectInfoNo);
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("mix_class_id", hireDevClass);		
		mainMap.put("state", DevConstants.DEVRECEIVE);//�豸����
		mainMap.put("opr_state", DevConstants.STATE_SUBMITED);
		mainMap.put("device_type", device_type);
		String hireAppNo = "";//���뵥��
		if(addUpFlag != null && "add".equals(addUpFlag)){//����
			hireAppNo = DevUtil.getWTCHireDevAppNoNew(device_type);//�����豸����
			mainMap.put("create_date", DevUtil.getCurrentTime());
			mainMap.put("creator_id", user.getEmpId());
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
			mainMap.put("org_id", user.getOrgId());//�����˵�λorg_id
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());//�����˵�λsub_id
		}else{
			hireAppNo = msg.getValue("device_hireapp_no");
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
		}
		mainMap.put("device_hireapp_no", hireAppNo);
		String hireAppId = msg.getValue("device_hireapp_id");
		if (DevUtil.isValueNotNull(hireAppId)) {
			mainMap.put("device_hireapp_id", hireAppId);
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_hireapp");
		}else{
			hireAppId = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_hireapp");
		}
		return hireAppId;
	}
}

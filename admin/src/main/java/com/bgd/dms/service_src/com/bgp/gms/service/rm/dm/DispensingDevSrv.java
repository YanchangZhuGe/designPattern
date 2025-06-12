package com.bgp.gms.service.rm.dm;

import java.io.Serializable;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
/**
 * �豸����������
 * @author liweiming
 */
public class DispensingDevSrv extends BaseService {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	public ISrvMsg saveDispensingInfo(ISrvMsg reqDTO) throws Exception{
		Map map = reqDTO.toMap();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gms_device_disapp");
		return msg;
	}
	/**
	 * ��۵�������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgDeviceApp(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String orgCode = user.getOrgCode();
		//��ѯ�������Ƿ���Ҫ�����豸���о���ʾ�������뵥��
		String appSql = "select app.* from gms_device_app app where app.project_info_no='"+project_info_no+"' and app.DEVICE_APP_ID  " +
				"in(select distinct  detail.DEVICE_APP_ID from gms_device_app_detail detail where detail.DEV_OUT_ORG_ID='"+orgCode+"') " +
				"order by app.CREATE_DATE";
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(appSql, page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
		
	}

	
	
	
	public ISrvMsg saveDisAppBaseInfo(ISrvMsg msg) throws Exception {		
		//1.��û�����Ϣ
		String project_info_no = msg.getValue("projectInfoNo");
		String device_app_name = msg.getValue("device_app_name");
		String remark = msg.getValue("remark");
		String device_allapp_id = msg.getValue("device_allapp_id");
		//2.��Ż�����Ϣ
		Map<String,Object> mainMap = new HashMap<String,Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_name", device_app_name);
		mainMap.put("device_allapp_id", device_allapp_id);
		//2.1 �²�������뵥�����Ϣ
		//String mixtypename = new String(msg.getValue("mixtypename").getBytes("iso-8859-1"),"utf-8");
		//String mixtypeusername = new String(msg.getValue("mixtypeusername").getBytes("iso-8859-1"),"utf-8");
		String mixtypeid = msg.getValue("mixownership");
		//2.2 �Ӷ�Ӧ��ϵ�����֯���� : ��Ҫ�Ƕ�Ӧ��רҵ��
		UserToken user = msg.getUserToken();
		String mixorgid = DevUtil.getMixOrgId(mixtypeid, user);
		mainMap.put("mix_org_id", mixorgid);
		
		mainMap.put("mix_type_id", mixtypeid);
		//mainMap.put("mix_type_name", mixtypename);
		//mainMap.put("mix_user_id", mixtypeusername);
		
		/** �޸Ĳ��������ڸ��µ�������Ϣ */
		String device_app_id = msg.getValue("device_app_id");
		if(device_app_id!=null&&!"".equals(device_app_id)){
			mainMap.put("device_app_id", device_app_id);
		}
		//3.���ɻ�����Ϣ
		mainMap.put("remark", remark);
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		mainMap.put("app_org_id", user.getOrgId());
		mainMap.put("employee_id", user.getEmpId());
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", user.getEmpId());
		mainMap.put("org_id", user.getCodeAffordOrgID());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		//�Դ�ƻ����б���Ĳ������½���0���ύ��9
		String state = msg.getValue("state");
		mainMap.put("state", state);
		//�ж��Ƿ������˵������뵥�ţ����û���ɣ���ô������
		String s_device_app_no = msg.getValue("device_app_no");
		if("".equals(s_device_app_no)){
			//String device_app_no = DevUtil.getDeviceAppNo();
			Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String device_app_no = "�����ƻ�" + sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
			mainMap.put("device_app_no", device_app_no);
		}
		if(DevConstants.STATE_SAVED.equals(state)){
			//4.���������Ϣ�ı���
			mainMap.put("appdate", DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd"));
			mainMap.put("create_date", currentdate);
			mainMap.put("creator_id", user.getEmpId());
		}else if(DevConstants.STATE_SUBMITED.equals(state)){
			//5.�ύ����
			mainMap.put("appdate", currentdate);
			//��״̬����Ϊ���ύ
			mainMap.put("state", DevConstants.STATE_SUBMITED);
		}
		//6.�����ݿ�д����Ϣ
		jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_disapp");
		//7.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	
	public ISrvMsg getDisAppBaseInfo(ISrvMsg msg) throws Exception {
		String device_app_id = msg.getValue("deviceappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		//1.�����뵥������Ϣ���ظ�����
		StringBuffer sb = new StringBuffer().append("select t.device_mixapp_id,gp.project_name,app.device_app_no,app.device_app_name,t.device_mixapp_no,t.device_mixapp_name,org.org_abbreviation,emp.employee_name,t.appdate from gms_device_dismixapp t left join gms_device_app app on t.device_app_id = app.device_app_id and app.bsflag='0' left join gp_task_project gp on t.project_info_no=gp.project_info_no left join comm_org_information org on t.app_org_id = org.org_id left join comm_human_employee emp on t.employee_id = emp.employee_id where t.device_mixapp_id='"+device_app_id+"' and t.bsflag='0' ");
		Map deviceappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if(deviceappMap!=null){
			responseMsg.setValue("deviceappMap", deviceappMap);
		}
		return responseMsg;
	}
	/**
	 * �����豸�����ƻ���Ϣ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDisAppDetailInfo(ISrvMsg msg) throws Exception {
		//1.��û�����Ϣ
		String project_info_no = msg.getValue("projectInfoNo");
		String device_app_id = msg.getValue("deviceappid");
		//2.�û���ʱ����Ϣ
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		//3.���ڴ�����ϸ��Ϣ�Ķ�ȡ
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~",-1);
		String[] idinfos = msg.getValue("idinfos").split("~",-1);
		//����ϸ��Ϣ�����浽List�У����ڴ洢�ӱ�
		List<Map<String,Object>> devDetailList = new ArrayList<Map<String,Object>>();
		for(int i=0;i<count;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			String keyid = lineinfos[i];
			//���Ϊ�޸Ĳ�������ô����deviceallappdetid
			String deviceappdetid = msg.getValue("deviceappdetid"+keyid);
			if(deviceappdetid!=null&&!"".equals(deviceappdetid)){
				dataMap.put("device_app_detid", deviceappdetid);
			}
			String deviceallappdetid = idinfos[i];
			dataMap.put("device_allapp_detid", deviceallappdetid);
			//ɾ�����
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			//�豸����
			String dev_ci_code = msg.getValue("signtype"+keyid);
			dataMap.put("dev_ci_code", dev_ci_code);
			String apply_num = msg.getValue("applynum"+keyid);
			dataMap.put("apply_num", apply_num);
			String plan_start_date = msg.getValue("startdate"+keyid);
			dataMap.put("plan_start_date", plan_start_date);
			String plan_end_date = msg.getValue("enddate"+keyid);
			dataMap.put("plan_end_date", plan_end_date);
			String unitinfo = msg.getValue("unitinfo"+keyid);
			dataMap.put("unitinfo", unitinfo);
			//�Ƿ�Ϊ������ 2012-9-26 liujb 
			String isdevicecode = msg.getValue("isdevicecode"+keyid);
			dataMap.put("isdevicecode", isdevicecode);
			//�����ID
			dataMap.put("device_app_id", device_app_id);
			//��Ŀ��ID
			dataMap.put("project_info_no", project_info_no);
			//����ID
			String teamid = msg.getValue("teamid"+keyid);
			dataMap.put("teamid", teamid);
			//����team
			String teamname = msg.getValue("team"+keyid);
			dataMap.put("team", teamname);
			//����ʱ��
			dataMap.put("create_date", currentdate);
			//������
			dataMap.put("employee_id", employee_id);
			//��;purpose
			dataMap.put("purpose", msg.getValue("purpose"+keyid));
			
			devDetailList.add(dataMap);
		}
		//4.�����ӱ���Ϣ
		for(int i=0;i<devDetailList.size();i++){
			jdbcDao.saveOrUpdateEntity(devDetailList.get(i), "gms_device_disapp_detail");
		}
		
		//5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	
	
	public ISrvMsg saveDisAppModifyInfowfpa(ISrvMsg msg) throws Exception {
		String oprstate = msg.getValue("oprstate");
		if("pass".equals(oprstate)){
			String device_app_id = msg.getValue("device_app_id");
			String leaderinfo = msg.getValue("leaderinfo");
			StringBuffer updateSql = new StringBuffer(" update gms_device_disapp set leaderinfo = '");
			updateSql.append(leaderinfo).append("' ");
			updateSql.append(" where device_app_id = '").append(device_app_id).append("'");
			jdbcDao.executeUpdate(updateSql.toString());
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD
	 * �����������Ϣ(��̽���е��豸�������˳��ⵥ)
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSelfDisMixFormAllInfo(ISrvMsg msg) throws Exception {
		//1.��û�����Ϣ
		String project_info_no = msg.getValue("project_info_no");
		String deviceappid = msg.getValue("deviceappid");
		//2.�û���ʱ����Ϣ
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String state = msg.getValue("state");
		//-- �ȱ��������
		Map<String,Object> mainMap = new HashMap<String,Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_id", deviceappid);
		mainMap.put("app_org_id", user.getOrgId());
		mainMap.put("appdate", DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd"));
		mainMap.put("mix_org_id", msg.getValue("out_org_id"));
		mainMap.put("mix_type_id", msg.getValue("mix_type_id"));
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("employee_id", employee_id);
		mainMap.put("state", state);
		String devicemixappname = msg.getValue("device_mixapp_name");
		mainMap.put("device_mixapp_name", devicemixappname);
		mainMap.put("create_date", currentdate);
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		if("".equals(msg.getValue("device_mixapp_no"))){
			Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String device_mixapp_no = "��������" + sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
			mainMap.put("device_mixapp_no", device_mixapp_no);
		}
		else{
			mainMap.put("device_mixapp_no", msg.getValue("device_mixapp_no"));
		}
		//����Ѿ�����id����ô�������map�У�ʵ���޸Ĺ���
		Serializable mainid = null;
		String device_mixapp_id = msg.getValue("device_mixapp_id");
		if(device_mixapp_id!=null&&!"".equals(device_mixapp_id)){
			mainMap.put("device_mixapp_id", device_mixapp_id);
			mainid = device_mixapp_id;
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}else{
			//������mainid��Ϣ
			mainid = jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}
		//3.1 ���ڴ�����ϸ��Ϣ�Ķ�ȡ(��̨) 
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~",-1);
		String[] idinfos = msg.getValue("idinfos").split("~",-1);
		//�ȸ��ӱ�Ķ�ɾ�ˣ���ȫ������
		jdbcDao.executeUpdate("delete from gms_device_dismixapp_detail where device_mixapp_id='"+mainid+"' ");
		for(int i=0;i<count;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			String keyid = lineinfos[i];
			String device_app_detid = idinfos[i];
			dataMap.put("device_app_detid", device_app_detid);
			//devcicode
			String devcicode = msg.getValue("devcicode"+keyid);
			dataMap.put("dev_ci_code", devcicode);
			//�豸����
			String dev_name = msg.getValue("devicename"+keyid);
			dataMap.put("dev_name", dev_name);
			//�豸�ͺ�
			String dev_type = msg.getValue("devicemodel"+keyid);
			dataMap.put("dev_type", dev_type);
			//isdevicecode 2012-9-26 liujb 
			String isdevicecode = msg.getValue("isdevicecode"+keyid);
			dataMap.put("isdevicecode", isdevicecode);
			//apply_num
			String mixappnum = msg.getValue("mixappnum"+keyid);
			dataMap.put("apply_num", mixappnum);
			
			//��ѯ������Ϣ
			Map<String,Object> tempMap = jdbcDao.queryRecordBySQL("select device_allapp_detid,team,teamid,unitinfo,purpose from gms_device_app_detail dui where dui.device_app_detid='"+device_app_detid+"'");
			
			dataMap.putAll(tempMap);			
			//devcicode
			String startdate = msg.getValue("startdate"+keyid);
			dataMap.put("plan_start_date", startdate);
			//devcicode
			String enddate = msg.getValue("enddate"+keyid);
			dataMap.put("plan_end_date", enddate);
			dataMap.put("project_info_no", project_info_no);
			//�����ID
			dataMap.put("device_mixapp_id", mainid);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_dismixapp_detail");
		}
		//5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * ��۱����������Ϣ(��̽���е��豸�������˳��ⵥ)
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSelfDisMixFormAllInfoDg(ISrvMsg msg) throws Exception {
		//����޵��䵥-�����üƻ�����ȡ��Ҫ������
		//1.��û�����Ϣ
		String project_info_no = msg.getValue("project_info_no");
		String deviceallappid = msg.getValue("deviceallappid");
		//2.�û���ʱ����Ϣ
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String state = msg.getValue("state");
		//-- �ȱ��������
		Map<String,Object> mainMap = new HashMap<String,Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_id", deviceallappid);
		mainMap.put("app_org_id", user.getOrgId());
		mainMap.put("appdate", DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd"));
		mainMap.put("mix_org_id", msg.getValue("out_org_id"));
		mainMap.put("mix_type_id", "S9998");//���ʹ��-��������������̽�������е���
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("employee_id", employee_id);
		mainMap.put("state", state);
		String devicemixappname = msg.getValue("device_mixapp_name");
		mainMap.put("device_mixapp_name", devicemixappname);
		mainMap.put("create_date", currentdate);
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		if("".equals(msg.getValue("device_mixapp_no"))){
			Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String device_mixapp_no = "��۵�������" + sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
			mainMap.put("device_mixapp_no", device_mixapp_no);
		}
		else{
			mainMap.put("device_mixapp_no", msg.getValue("device_mixapp_no"));
		}
		//����Ѿ�����id����ô�������map�У�ʵ���޸Ĺ���
		Serializable mainid = null;
		String device_mixapp_id = msg.getValue("device_mixapp_id");
		if(device_mixapp_id!=null&&!"".equals(device_mixapp_id)){
			mainMap.put("device_mixapp_id", device_mixapp_id);
			mainid = device_mixapp_id;
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}else{
			//������mainid��Ϣ
			mainid = jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_dismixapp");
		}
		//3.1 ���ڴ�����ϸ��Ϣ�Ķ�ȡ(��̨) 
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~",-1);
		String[] idinfos = msg.getValue("idinfos").split("~",-1);
		//�ȸ��ӱ�Ķ�ɾ�ˣ���ȫ������
		jdbcDao.executeUpdate("delete from gms_device_dismixapp_detail where device_mixapp_id='"+mainid+"' ");
		for(int i=0;i<count;i++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			String keyid = lineinfos[i];
			String device_allapp_detid = idinfos[i];
			dataMap.put("device_app_detid", device_allapp_detid);
			//devcicode
			String devcicode = msg.getValue("devcicode"+keyid);
			dataMap.put("dev_ci_code", devcicode);
			//�豸����
			String dev_name = msg.getValue("devicename"+keyid);
			dataMap.put("dev_name", dev_name);
			//�豸�ͺ�
			String dev_type = msg.getValue("devicemodel"+keyid);
			dataMap.put("dev_type", dev_type);
			//isdevicecode 2012-9-26 liujb 
			String isdevicecode = msg.getValue("isdevicecode"+keyid);
			dataMap.put("isdevicecode", isdevicecode);
			//apply_num
			String mixappnum = msg.getValue("mixappnum"+keyid);
			dataMap.put("apply_num", mixappnum);
			
			//��ѯ������Ϣ
			Map<String,Object> tempMap = jdbcDao.queryRecordBySQL("select device_allapp_detid,team,teamid,unitinfo,purpose from gms_device_allapp_detail where device_allapp_detid='"+device_allapp_detid+"'");
				
			dataMap.putAll(tempMap);			
			//devcicode
			String startdate = msg.getValue("startdate"+keyid);
			dataMap.put("plan_start_date", startdate);
			//devcicode
			String enddate = msg.getValue("enddate"+keyid);
			dataMap.put("plan_end_date", enddate);
			dataMap.put("project_info_no", project_info_no);
			//�����ID
			dataMap.put("device_mixapp_id", mainid);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_dismixapp_detail");
		}

		String updateSql = "update gms_device_allapp allapp set allapp.assign_state = '1' ";
			   updateSql += "where allapp.project_info_no ='"+project_info_no+"' ";
			   updateSql += "and allapp.device_allapp_id ='"+deviceallappid+"' ";
		   jdbcDao.executeUpdate(updateSql);
		//5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}

}

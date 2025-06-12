package com.bgp.mcs.service.pm.service.project;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.EDcode;

public class DailyProgressSrv extends BaseService {

	public DailyProgressSrv(){
		log = LogFactory.getLogger(MeasureSrv.class);
	}
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	/**
	 * ��ѯ��������Ϣ PROGRESS_TYPE = 2
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	private ISrvMsg querySurfaceProgress(ISrvMsg reqDTO) throws Exception {
		log.debug(".....enter method querySurfaceProgress...");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String cons_date = reqDTO.getValue("cons_date");
		
		StringBuffer querySql = new StringBuffer("select t.daily_progress_no,t.project_info_no,t.progress_type,t.cons_date,t.line_group_id,");
		querySql.append("t.survey_pt_type, decode(t.survey_pt_type,'1','�ڵ�','2','�첨��') survey_pt_type_value,t.drill_type,decode(t.drill_type,'1','��е�꾮','2','�˹��꾮') drill_type_value");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '2' and t.project_info_no = '"+projectInfoNo+"'");
		if(cons_date != null && cons_date != ""){
			querySql.append(" and t.cons_date = to_date('"+cons_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		
		log.debug(".....exit querySurfaceProgress...");
		return responseDTO;
	}
	
	/**
	 * ¼���������Ϣ
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	private ISrvMsg insertSurfaceProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter method insertSurfaceProgress....");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		EDcode encode = new EDcode();

		/*
		 * ����һ��pojo���͵Ķ���,������Ԫ�ظ�ֵ����
		 */

		// ����ǰ̨�����Ľ���Ԫ�ص�ֵ
		String consDate = reqDTO.getValue("consDate");
		String surfaceFile = reqDTO.getValue("surfaceFile");	
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		boolean flag = false;
		String message = "";

		// ��ֵ�������ļ���
		if (surfaceFile != null && !surfaceFile.equals("")) {
			byte by[] = encode.decode(surfaceFile);

			// ��������������ת��Ϊ������������������ʹ��
			DataInputStream dis = new DataInputStream(new ByteArrayInputStream(by));
			int n = 1;
			String line = null;
			while ((line = dis.readLine()) != null) {
				line = new String(line.getBytes("ISO-8859-1"));
				String datas[] = line.split(",");
				if (datas.length != 6) {
					message = "��" + n + "�в���6��,���ܼ���";
					flag = true;
					break;
				}
				if (datas[0].equals("")) {
					message = "��" + n + "�е�1�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (datas[1].equals("")) {
					message = "��" + n + "�е�2�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (!datas[1].matches(("^[\\d|.]+$"))) {
					message = "��" + n + "�е�2�в�������,���ܼ���";
					flag = true;
					break;
				}
				if (datas[2].equals("")) {
					message = "��" + n + "�е�3�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (datas[3].equals("")) {
					message = "��" + n + "�е�4�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (!datas[3].matches(("^[\\d|.]+$"))) {
					message = "��" + n + "�е�4�в�������,���ܼ���";
					flag = true;
					break;
				}
				if (datas[4].equals("")) {
					message = "��" + n + "�е�5�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (!datas[4].matches(("^[\\d|.]+$"))) {
					message = "��" + n + "�е�5�в�������,���ܼ���";
					flag = true;
					break;
				}
				if (datas[5].equals("")) {
					message = "��" + n + "�е�6�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				//08.12.16 zhoumeng �߳̿���Ϊ����
				if (!datas[5].matches(("^-?[\\d|.]+$"))) {
					message = "��" + n + "�е�6�в�������,���ܼ���";
					flag = true;
					break;
				}
				
				String data3 = "";			
				if (datas[3].indexOf(".")!=-1){
					data3 = datas[3].substring(0, datas[3].indexOf("."));
				}else{
					data3 = datas[3];
				}
				
				String data4 = "";
				if (datas[4].indexOf(".")!=-1){
					data4 = datas[4].substring(0, datas[4].indexOf("."));
				}else{
					data4 = datas[4];
				}
				
				
				if(!((data3.length() == 6)||(data3.length() == 8))){
					message = "��" + n + "�е�4��X����ֵ����λӦ��Ϊ6λ��8λ��";
					flag = true;
					break;
				}
				
				if(!((data4.length() == 7)||(data4.length() == 9))){
					message = "��" + n + "�е�5��Y����ֵ����λӦ��Ϊ7λ��9λ��";
					flag = true;
					break;
				}

			}


		}
		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		Map surfaceMap = new HashMap();
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		// 2���������
		surfaceMap.put("PROGRESS_TYPE", "2");
		surfaceMap.put("PROGRESS_DATA", encode.decode(surfaceFile));
		surfaceMap.put("CREATOR", user.getUserId());
		surfaceMap.put("CREATE_DATE", new Date());
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		// ��������
		log.debug(".....exit insertSurfaceProgress method...");
		return responseDTO;

	}
	
	/**
	 * ���±�������Ϣ
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	private ISrvMsg updateSurfaceProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter updateSurfaceProgress method");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String surfaceProgressId = reqDTO.getValue("surfaceProgressId");
		
		EDcode encode = new EDcode();

		// ����ǰ̨�����Ľ���Ԫ�ص�ֵ
		String surfaceFile = reqDTO.getValue("surfaceFile");
		String consDate = reqDTO.getValue("consDate");

		// ��ֵ�������ļ���
		boolean flag = false;
		String message = "";

		if (surfaceFile != null && !surfaceFile.equals("")) {
			byte by[] = encode.decode(surfaceFile);

			// ��������������ת��Ϊ������������������ʹ��
			DataInputStream dis = new DataInputStream(new ByteArrayInputStream(
					by));
			int n = 1;
			String line = null;
			while ((line = dis.readLine()) != null) {
				String datas[] = line.split(",");
				if (datas.length != 6) {
					message = "��" + n + "�в���6��,���ܼ���";
					flag = true;
					break;
				}
				if (datas[0].equals("")) {
					message = "��" + n + "�е�1�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (datas[1].equals("")) {
					message = "��" + n + "�е�2�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (!datas[1].matches(("^[\\d|.]+$"))) {
					message = "��" + n + "�е�2�в�������,���ܼ���";
					flag = true;
					break;
				}
				if (datas[2].equals("")) {
					message = "��" + n + "�е�3�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (datas[3].equals("")) {
					message = "��" + n + "�е�4�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (!datas[3].matches(("^[\\d|.]+$"))) {
					message = "��" + n + "�е�4�в�������,���ܼ���";
					flag = true;
					break;
				}
				if (datas[4].equals("")) {
					message = "��" + n + "�е�5�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				if (!datas[4].matches(("^[\\d|.]+$"))) {
					message = "��" + n + "�е�5�в�������,���ܼ���";
					flag = true;
					break;
				}
				if (datas[5].equals("")) {
					message = "��" + n + "�е�6�в���Ϊ��,���ܼ���";
					flag = true;
					break;
				}
				//08.12.16 zhoumeng �߳̿���Ϊ����
				if (!datas[5].matches(("^-?[\\d|.]+$"))) {
					message = "��" + n + "�е�6�в�������,���ܼ���";
					flag = true;
					break;
				}
				
				String data3 = "";			
				if (datas[3].indexOf(".")!=-1){
					data3 = datas[3].substring(0, datas[3].indexOf("."));
				}else{
					data3 = datas[3];
				}
				
				String data4 = "";
				if (datas[4].indexOf(".")!=-1){
					data4 = datas[4].substring(0, datas[4].indexOf("."));
				}else{
					data4 = datas[4];
				}
				
				
				if(!(data3.length() == 6)||(data3.length() == 8)){
					message = "��" + n + "�е�4��X����ֵ����λӦ��Ϊ6λ��8λ��";
					flag = true;
					break;
				}
				
				if(!(data4.length() == 7)||(data4.length() == 9)){
					message = "��" + n + "�е�5��Y����ֵ����λӦ��Ϊ7λ��9λ��";
					flag = true;
					break;
				}
			}

			//gpOpsDailyProgress.setProgressData(encode.Decode(surfaceFile));
		}

		if (flag) {
			responseDTO.setValue("recordsError", "YES");
			responseDTO.setValue("message", message);
			return responseDTO;
		}
		
		Map surfaceMap = new HashMap();
		surfaceMap.put("DAILY_PROGRESS_NO", surfaceProgressId);
		surfaceMap.put("PROJECT_INFO_NO",projectInfoNo);
		// 2���������
		surfaceMap.put("PROGRESS_TYPE", "2");
		surfaceMap.put("PROGRESS_DATA", encode.decode(surfaceFile));
		surfaceMap.put("CREATOR", user.getUserId());
		surfaceMap.put("CREATE_DATE", new Date());
		surfaceMap.put("MODIFI_DATE", user.getUserId());
		surfaceMap.put("UPDATOR", user.getUserId());
		surfaceMap.put("ORG_ID", user.getOrgId());
		surfaceMap.put("ORG_SUBJECTION_ID", user.getSubOrgIDofAffordOrg());
		jdbcDao.saveOrUpdateEntity(surfaceMap, "gp_ops_daily_progress");

		log.debug(".....exit updateSurfaceProgress");
		return responseDTO;
	}
	
	/**
	 * ɾ��������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	private ISrvMsg deleteSurfaceProgress(ISrvMsg reqDTO) throws Exception {

		log.debug(".....enter deleteSurfaceProgress method");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String surfaceProgressId = reqDTO.getValue("surfaceProgressId");
		String update_sql = "update gp_ops_daily_progress p set p.bsflag = '1' where p.daily_progress_no = '"+surfaceProgressId+"'";
		jdbcDao.executeUpdate(update_sql);
		log.debug(".....exit deleteSurfaceProgress");
		return responseDTO;
	}
	
	private ISrvMsg validateSurfaceProgress(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		log.debug(".....enter method validateSurfaceProgress...");
		
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String surfaceProgressId = reqDTO.getValue("surfaceProgressId");
		String consDate = reqDTO.getValue("consDate");
		
		StringBuffer querySql = new StringBuffer("select count(t.daily_progress_no) as surfacecount");
		querySql.append(" from gp_ops_daily_progress t where t.bsflag = '0' and t.progress_type = '2' and t.project_info_no = '"+projectInfoNo+"'");
		if(consDate != null && consDate != ""){
			querySql.append(" and t.cons_date = to_date('"+consDate+"','yyyy-mm-dd hh24:mi:ss')");
		}
		
		int surfaceCount = Integer.parseInt(jdbcDao.queryRecordBySQL(querySql.toString()).get("surfacecount").toString());
		if(surfaceCount >0){
			//������,���Ը���
			responseDTO.setValue("updateFlag", "1");
		}else{
			//û����,������
			responseDTO.setValue("updateFlag", "0");
		}

		log.debug(".....exit validateSurfaceProgress...");
		
		return responseDTO;
	}
}

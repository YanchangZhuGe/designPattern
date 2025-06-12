package com.bgp.mcs.service.wt.pm.service.dailyReport;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.xml.soap.SOAPException;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.srv.OPCostSrv;
import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityMCSBean;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.ResourceAssignmentMCSBean;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.workload.WorkloadMCSBean;
import com.bgp.mcs.service.pm.service.project.DailyReportProcessRatePOJO;
import com.bgp.mcs.service.pm.service.project.ProjectMCSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.primavera.ws.p6.activity.Activity;
import com.primavera.ws.p6.activity.ActivityExtends;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentExtends;

public class WtDailyReportSrv extends BaseService {

	private ILog log;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private WorkloadMCSBean workloadMCSBean;
	private ResourceAssignmentMCSBean resourceAssignmentMCSBean;



	public WtDailyReportSrv() {
		log = LogFactory.getLogger(WtDailyReportSrv.class);
		workloadMCSBean = (WorkloadMCSBean) BeanFactory.getBean("P6WorkloadMCSBean");
		resourceAssignmentMCSBean = (ResourceAssignmentMCSBean) BeanFactory.getBean("P6ResourceAssignmentMCSBean");

	}

	java.text.DecimalFormat df_1 = new java.text.DecimalFormat("#.000");

	public ISrvMsg queryDailyReport(ISrvMsg reqDTO) throws Exception {

		String org_subjection_id = (String) reqDTO.getValue("orgSubjectionId");

		String org_id=(String)reqDTO.getValue("orgId");
		String project_name = (String) reqDTO.getValue("projectName");
// 
//		String[] projectNames = project_name.split("");// �ֽ�ɵ��ַ�
//
//		project_name = "%";
//
//		for (int i = 0; i < projectNames.length; i++) {
//			project_name += projectNames[i] + "%";
//		}

//		String org_name = (String) reqDTO.getValue("orgName");
//		System.out.println("org_name-------------990000-----" + org_subjection_id);
//		String[] orgNames = org_name.split("");
//
//		org_name = "%";
//
//		for (int i = 0; i < orgNames.length; i++) {
//			org_name += orgNames[i] + "%";
//		}

		String audit_status = (String) reqDTO.getValue("auditStatus");

		String project_status = (String) reqDTO.getValue("projectStatus");

		String project_type = (String) reqDTO.getValue("projectType");

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
		String org_sql = "";//��Ŀ���û���¼�Ժ���Ҫ����ֻ�ܲ鿴����Ŀ���������ձ���������
		if(org_id!=null&&org_id.equals("C6000000000124")){
			org_sql = " and gp.project_department='C6000000000124' ";
		}
		if(org_id!=null&&org_id.equals("C6000000004707")){
			org_sql = " and gp.project_department='C6000000004707' ";
		}
		if(org_id!=null&&org_id.equals("C6000000005592")){
			org_sql = " and gp.project_department='C6000000005592' ";
		}
		if(org_id!=null&&org_id.equals("C6000000005594")){
			org_sql = " and gp.project_department='C6000000005594' ";
		}
		if(org_id!=null&&org_id.equals("C6000000005595")){
			org_sql = " and gp.project_department='C6000000005595' ";
		}
		if(org_id!=null&&org_id.equals("C6000000005605")){
			org_sql = " and gp.project_department='C6000000005605' ";
		}
		
		String sql = "select * from (select row_number() over (partition  by r.project_info_no order by r.produce_date desc) as row_num,r.*,gp.project_name,oi.org_abbreviation as org_name,r.org_id as report_org_id,gp.project_type as gp_project_type,gp.exploration_method as gp_exploration_method,gp.project_start_time as gp_start_time,gp.project_end_time as gp_end_time " +
		" from gp_ops_daily_report_wt r " +
		" join gp_task_project gp on gp.project_info_no = r.project_info_no "
		+ " and gp.project_name like '%"+project_name+"%' "
		+ " and gp.bsflag = '0' "
		+ " and gp.project_status like '%"+project_status+"%' "
		+ " and project_type in('"+project_type+"') "
		+org_sql+
		" join comm_org_information oi on   r.org_id  like  '%'|| oi.org_id ||'%'  and oi.bsflag = '0' "+
		"  join gp_ops_daily_report_zb b on b.project_info_no=r.project_info_no and b.daily_no_wt=r.daily_no_wt  and b.bsflag='0' "+
		" where r.bsflag = '0' and r.org_subjection_id like 'C105008%'" +
		" and r.audit_status like '%"+audit_status+"%' "+
		" ) where row_num = 1 ";

		page = radDao.queryRecordsBySQL(sql, page);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);

		return msg;

	}
	
	public ISrvMsg deleteFile(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();

		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		
		String upload_file_names = isrvmsg.getValue("upload_file_name");
		String file_date = isrvmsg.getValue("fild_date");
	
		String file_id= isrvmsg.getValue("file_id");
 		if(file_id!=null&&!file_id.equals("")){
 		 String sql="UPDATE file_checkaccept SET bsflag = '1' WHERE id = '"+file_id+"' ";
			radDao.executeUpdate(sql.toString());
		} 
	
		String message="ɾ���ɹ�!";
		responseDTO.setValue("message", message);
		return responseDTO;
	}
	
	public ISrvMsg importProjectUploadFile(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();

		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		
		String upload_file_names = isrvmsg.getValue("upload_file_name");
		String file_date = isrvmsg.getValue("fild_date");
		String fild_status = isrvmsg.getValue("fild_status");

		String file_id= isrvmsg.getValue("file_id");
 		if(file_id!=null&&!file_id.equals("")){
			String [] upload_file_name=upload_file_names.split(",");
		 String sql="UPDATE file_checkaccept SET FILD_NAME = '"+upload_file_name[0]+"' WHERE id = '"+file_id+"' and bsflag='0' ";
			radDao.executeUpdate(sql.toString());
		}else{
			String[] fileNames = upload_file_names.split(",");
			for(int i=0;i<fileNames.length;i++){
				byte[] fileBytes = null;
				String uploadFileName =fileNames[i];
				if(uploadFileName != ""){
					fileBytes = MyUcm.getFileBytes(uploadFileName, user);
				}
				if(fileBytes != null && fileBytes.length > 0){
					StringBuffer sbSql = new StringBuffer();

					String ucmDocId = myUcm.uploadFile(uploadFileName, fileBytes);
	 				sbSql = new StringBuffer("insert into file_checkaccept (id,PROJECT_INFO_NO,FILD_NAME,FILD_DATE,BSFLAG,FILD_STATUS,CREATE_NAME,CREATE_DATE)");
					sbSql.append("values('").append(ucmDocId).append("','").append(projectInfoNo).append("','").append(uploadFileName).append("',").append("to_date('"+file_date+"','yyyy-MM-dd')").append(",'").append(0).append("','").append(fild_status)
					.append("','").append(user.getUserName()).append("',").append("sysdate)");
					radDao.executeUpdate(sbSql.toString());
	 			}
				
			}
		}

	
		String message="����ɹ�!";
		responseDTO.setValue("message", message);
		return responseDTO;
	}
	
	
	
	public ISrvMsg importDailyUploadFile(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();

		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		
		String upload_file_names = isrvmsg.getValue("upload_file_name");
		String[] fileNames = upload_file_names.split(",");
		for(int i=0;i<fileNames.length;i++){
			byte[] fileBytes = null;
			String uploadFileName =fileNames[i];
			if(uploadFileName != ""){
				fileBytes = MyUcm.getFileBytes(uploadFileName, user);
			}
			if(fileBytes != null && fileBytes.length > 0){
				String ucmDocId = myUcm.uploadFile(uploadFileName, fileBytes);
				String updateSql="update GP_OPS_DAILY_REPORT_ZB set UPLOAD_FILE_UCMDOCID='"+ucmDocId+"' where BSFLAG='0' and FILE_NAME='"+uploadFileName+"' and PROJECT_INFO_NO='"+projectInfoNo+"'";
				radDao.executeUpdate(updateSql);
			}
			
		}
		String message="����ɹ�!";
		responseDTO.setValue("message", message);
		return responseDTO;
	}
		
	
	public ISrvMsg submitDailyReportWt(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String daily_report_ids = reqDTO.getValue("daily_report_ids");
		String status = reqDTO.getValue("status");
		String[] ids = daily_report_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String id = (String)ids[i];
			String sql="update GP_OPS_DAILY_REPORT_ZB set STATUS='"+status+"' where DAILY_REPORT_ID='"+id+"'";
			radDao.executeUpdate(sql);
			
			String getInfo = "select IF_BUILD,PROJECT_INFO_NO from GP_OPS_DAILY_REPORT_WT where DAILY_NO_WT=(select zb.DAILY_NO_WT from GP_OPS_DAILY_REPORT_ZB zb where zb.daily_report_id='"+id+"' and zb.BSFLAG='0')"
			+"and BSFLAG='0'";
			Map reportMap = radDao.queryRecordBySQL(getInfo);
			if(reportMap!=null){
				String if_build = (String)reportMap.get("if_build");
				String project_info_no = (String)reportMap.get("project_info_no");
				
				if(if_build!=null&&!"".equals(if_build)){
					//�޸��ձ�¼��״̬ʱͬ����Ŀ��Ϣ��״̬
					String projectStatus = "";
					if(if_build!=null&&"1".equals(if_build)||"2".equals(if_build)||"3".equals(if_build)||"4".equals(if_build)||"5".equals(if_build)){
						//��Ŀ���� ��Ǩ��̤������������ѵ������
						projectStatus="5000100001000000001";
					}else if(if_build!=null&&"6".equals(if_build)||"7".equals(if_build)){
						//���ɼ���ͣ������Ӧ����ʩ��
						projectStatus="5000100001000000002";

					}else if(if_build!=null&&"8".equals(if_build)){
						//��Ŀ��ͣ
						projectStatus="5000100001000000004";

					}else if(if_build!=null&&"9".equals(if_build)){
						projectStatus="5000100001000000005";

						//ʩ������
					}
					String projectupdate="update gp_task_project set PROJECT_STATUS='"+projectStatus+"' where PROJECT_INFO_NO='"+project_info_no+"'";
					radDao.getJdbcTemplate().update(projectupdate);
				}
			}
		

		}
		responseDTO.setValue("message", "success");
		return responseDTO;
	}	
	public ISrvMsg deleteDailyReportWt(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String daily_report_ids = reqDTO.getValue("daily_report_ids");
		String[] ids = daily_report_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String id = (String)ids[i];
			String sql0="update bgp_p6_workload set BSFLAG='1' where ACTIVITY_OBJECT_ID=(select ACTIVITY_OBJECT_ID from GP_OPS_DAILY_REPORT_ZB where DAILY_REPORT_ID='"+id+"') and PRODUCE_DATE=("
							+"select PRODUCE_DATE from GP_OPS_DAILY_REPORT_ZB where DAILY_REPORT_ID='"+id+"')";
			radDao.executeUpdate(sql0);			
			//String sql1="update GP_OPS_DAILY_REPORT_ZB set BSFLAG='1' where DAILY_REPORT_ID='"+id+"'";
			//radDao.executeUpdate(sql1);			
			String sql2="update GP_OPS_DAILY_QUESTION set BSFLAG='1' where DAILY_REPORT_ID='"+id+"'";
			radDao.executeUpdate(sql2);

		}
		responseDTO.setValue("message", "success");
		return responseDTO;
	}

	
	
	public ISrvMsg exportDailyTemplateWt(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String projectName = user.getProjectName();
		String activity_object_id = reqDTO.getValue("activity_object_id");

		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../pm/comm/exportDailyTemplateWt.xls"));
		Sheet sheet = wb.getSheetAt(0);
		Row row0 = sheet.getRow(0);
         
		String getActName="select name from BGP_P6_ACTIVITY where BSFLAG='0' and OBJECT_ID='"+activity_object_id+"'";
		Map actMap = radDao.queryRecordBySQL(getActName);
		
		String getResourceName="select distinct RESOURCE_NAME from bgp_p6_workload where BSFLAG='0' and PROJECT_INFO_NO='"+projectInfoNo+"' and ACTIVITY_OBJECT_ID='"+activity_object_id+"' and RESOURCE_NAME not like '%�����' and RESOURCE_NAME not like '%�����' and RESOURCE_NAME not like '%����'";
		List<Map> list = radDao.queryRecords(getResourceName);
		for(int i=0;i<list.size();i++){
			Map temp  = list.get(i);
			String resource_name = (String)temp.get("resource_name");
			String name = resource_name.split(" ")[1];
			Cell cell = row0.createCell(i+17);
			cell.setCellValue(name);				
		}
		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename(projectName+"_"+actMap.get("name")+".xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	/**
	 * �����ձ��б��ͷ
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg exportDailyTableTitleWt(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String activity_object_id = reqDTO.getValue("activity_object_id");
		String project_info_no = reqDTO.getValue("project_info_no");
		
		String[] info={"DAILY_WORKLOAD/������",         
			      "DAILY_PHYSICAL_POINT/�����",    
			      "DAILY_COORDINATE_POINT/�����",			
			      "DAILY_CHECK_POINT/����",				
			      "DAILY_NON_CONFORMING_PRODUCTS/��Ʒ",
			      "DAILY_CONFORMING_PRODUCTS/�ϸ�Ʒ",
			      "DAILY_FIRST_GRADE/һ��Ʒ",
			      "DAILY_REWORK_POINT/������",
			      "DAILY_NULL_POINT/�յ�",
			      "DAILY_GPS_CONTROL_POINT/GPS���Ƶ�",
			      "DAILY_WELL_SOUNDING_POINT/���Բ����",
			      "DAILY_MEASUREMENT_POINT/�����",
			      "DAILY_BASIC_POINT/����",
			      "DAILY_GRAVITY_DATUM_POINT/��������",
			      "DAILY_TERRAIN_CORRECT_POINT/���θ�����",
			      "DAILY_TC_CHECK_POINT/�ظļ���",	
			      "DAILY_BASE_STATION/�ձ�վ",
			      "DAILY_MAGNETISM_BASE_STATION/�����ձ�վ"};
		
		List<Map> tdList = new ArrayList<Map>();
		String sql="select distinct RESOURCE_NAME from bgp_p6_workload "
					+"where BSFLAG='0' and PROJECT_INFO_NO='"+project_info_no+"' and ACTIVITY_OBJECT_ID='"+activity_object_id+"' "
					+"and RESOURCE_NAME not like '%�����' and RESOURCE_NAME not like '%�����' and RESOURCE_NAME not like '%����'";
		List<Map> list = radDao.queryRecords(sql);
		for(int i=0;i<list.size();i++){
		Map<String,String>	tdMap = new HashMap<String, String>();
			Map temp  = list.get(i);
			String resource_name = (String)temp.get("resource_name");
			String name = resource_name.split(" ")[1];
			for(int y=0;y<=info.length-1;y++){
				String infoValue = info[y];
				String infoValueTitle = infoValue.split("/")[1];
				if(infoValueTitle.equals(name)){
					String coloum = infoValue.split("/")[0];
					tdMap.put("name", name);
					tdMap.put("coloum", coloum.toLowerCase());
					tdList.add(tdMap);
				}
			}
		}
		responseDTO.setValue("tdList", tdList);
		return responseDTO;
	}

	

		public ISrvMsg importDaily(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			String errorMessage = "";
			UserToken user = reqDTO.getUserToken();
			String user_id = user.getUserId();
			String projectInfoNo = user.getProjectInfoNo();
			ActivityMCSBean activityMCSBean = new ActivityMCSBean();

			String sqlp="  select ct.project_id from gp_task_project ct where ct.project_info_no='"+projectInfoNo+"'";
			Map projectIdMap=jdbcDao.queryRecordBySQL(sqlp);
			String project_id=(String) projectIdMap.get("projectId");
			
			//��ȡ��Ŀ��ʩ��С��
			String getOrgTeam = "select PROJECT_DYNAMIC_NO,ORG_ID,ORG_SUBJECTION_ID from gp_task_project_dynamic where  PROJECT_INFO_NO='"+projectInfoNo+"' and BSFLAG='0'";
			Map orgTeamMap = jdbcDao.queryRecordBySQL(getOrgTeam);
			String orgId = (String)orgTeamMap.get("orgId");
			String orgSubjectionId = (String)orgTeamMap.get("orgSubjectionId");

			
			//����	��Ŀ״̬	�������	��̽����	ʩ��С��	�ɼ�״̬ (ͣ��,��ͣ��ԭ��	ʩ��ͼ����	������������	�ܼ���������	
			//������	�����	�����	����	��Ʒ	�ϸ�Ʒ	һ��Ʒ	������	�յ�	GPS���Ƶ�	���Բ����	�����	����	��������	���θ�����	�ظļ���	�ձ�վ	�����ձ�վ																																																																																																																																																																																																																																				
			String[] info={"DAILY_WORKLOAD/������",         
				      "DAILY_PHYSICAL_POINT/�����",    
				      "DAILY_COORDINATE_POINT/�����",			
				      "DAILY_CHECK_POINT/����",				
				      "DAILY_NON_CONFORMING_PRODUCTS/��Ʒ",
				      "DAILY_CONFORMING_PRODUCTS/�ϸ�Ʒ",
				      "DAILY_FIRST_GRADE/һ��Ʒ",
				      "DAILY_REWORK_POINT/������",
				      "DAILY_NULL_POINT/�յ�",
				      "DAILY_GPS_CONTROL_POINT/GPS���Ƶ�",
				      "DAILY_WELL_SOUNDING_POINT/���Բ����",
				      "DAILY_MEASUREMENT_POINT/�����",
				      "DAILY_BASIC_POINT/����",
				      "DAILY_GRAVITY_DATUM_POINT/��������",
				      "DAILY_TERRAIN_CORRECT_POINT/���θ�����",
				      "DAILY_TC_CHECK_POINT/�ظļ���",	
				      "DAILY_BASE_STATION/�ձ�վ",
				      "DAILY_MAGNETISM_BASE_STATION/�����ձ�վ"};

			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
			List<WSFile> files = mqMsg.getFiles();
			
			MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
			String file_id = UUID.randomUUID().toString().replaceAll("-", "");

			for(int t=0;t<files.size();t++){
				WSFile uploadFile = files.get(t);
				String uploadFileName=uploadFile.getFilename();
				byte[] uploadData = uploadFile.getFileData();
				String ucmDocId = myUcm.uploadFile(uploadFileName, uploadData);
				
				if(ucmDocId!=""){
					String org_id = user.getOrgId();
					String org_subjection_id = user.getOrgSubjectionId();
					String qc_id = "WTRBDR";
					
					StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id ,parent_file_id,file_number)");
					sbSql.append("values('").append(file_id).append("','").append(uploadFileName).append("','").append(ucmDocId).append("','").append(qc_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
					.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append(org_id).append("','").append(org_subjection_id).append("','','')");
					
					radDao.executeUpdate(sbSql.toString());
					myUcm.docVersion(file_id, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
					myUcm.docLog(file_id, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
				}	
			}
			
			if (files != null && files.size() > 0) {
				WSFile file = files.get(0);
				InputStream is = new ByteArrayInputStream(file.getFileData());
				Workbook book = new HSSFWorkbook(is);
				Sheet sheet = book.getSheetAt(0);
				
				Row row0 = sheet.getRow(0);
				//DAILY_WORKLOAD_������	�����	�����	����	��Ʒ	�ϸ�Ʒ	һ��Ʒ	������	�յ�	GPS���Ƶ�	���Բ����	�����	����	��������	���θ�����	�ظļ���	�ձ�վ	�����ձ�վ																																																																																																																																																																																																																																				
				Map<String,String> excleTOjava = new HashMap<String, String>();
				for(int j=14;j<=info.length+15;j++){
					Cell cell0 = row0.getCell(j)==null?row0.createCell(j):row0.getCell(j);
					cell0.setCellType(1);
					String title = cell0.getStringCellValue()==null? "":cell0.getStringCellValue();
					for(int y=0;y<=info.length-1;y++){
						String infoValue = info[y];
						String infoValueTitle = infoValue.split("/")[1];
						if(infoValueTitle.equals(title)){
							excleTOjava.put("excle_"+j, "java_"+y);
							break;
						}
					}
				}
				
	
				
				for (int i = 1; i < sheet.getPhysicalNumberOfRows(); i++) {
					String  checkCell="";
					Row row = sheet.getRow(i);
					Cell cell = row.getCell(0)==null?row.createCell(0):row.getCell(0);
					//�ձ�����
					String PRODUCE_DATE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
					if(!PRODUCE_DATE.matches("([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8])))")){
						checkCell+="��"+i+"�����ڸ�ʽ����(������2000-01-01)��";
					}
					//��Ŀ״̬
					cell = row.getCell(1)==null?row.createCell(1):row.getCell(1);
					cell.setCellType(1);
					String IF_BUILD = cell.getStringCellValue()==null?"":cell.getStringCellValue();
					IF_BUILD = getindexToValue("IF_BUILD",IF_BUILD);
					if("".equals(IF_BUILD)){
						checkCell+="��"+i+"����Ŀ״̬����Ϊ�գ�";
					}
					//�������
					cell = row.getCell(2)==null?row.createCell(2):row.getCell(2);
					cell.setCellType(1);
					String WEATHER = cell.getStringCellValue()==null?"":cell.getStringCellValue();
					WEATHER = getindexToValue("WEATHER",WEATHER);

					//��̽����
					cell = row.getCell(3)==null?row.createCell(3):row.getCell(3);
					cell.setCellType(1);
					String EXPLORATION_METHOD = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					//ʩ��С��
					cell = row.getCell(4)==null?row.createCell(4):row.getCell(4);
					cell.setCellType(1);
					String TEAM = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					//�ɼ�״̬
					cell = row.getCell(5)==null?row.createCell(5):row.getCell(5);
					cell.setCellType(1);
					String TASK_STATUS = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					TASK_STATUS = getindexToValue("TASK_STATUS",TASK_STATUS);
					if("".equals(TASK_STATUS)){
						checkCell+="��"+i+"�вɼ�״̬����Ϊ�գ�";
					}
					//��ͣ��ͣ��ԭ��
					cell = row.getCell(6)==null?row.createCell(6):row.getCell(6);
					cell.setCellType(1);
					String PAUSE_STOP_REASON = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					PAUSE_STOP_REASON = getindexToValue("PAUSE_STOP_REASON",PAUSE_STOP_REASON);
					String STOP_REASON="";
					if("11".equals(TASK_STATUS)){
						STOP_REASON	=PAUSE_STOP_REASON;
					}
					String PAUSE_REASON = "";
					if("12".equals(TASK_STATUS)){
						PAUSE_REASON =PAUSE_STOP_REASON;
					}					
					
					//����״̬
					cell = row.getCell(7)==null?row.createCell(7):row.getCell(7);
					cell.setCellType(1);
					String STATUS = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					STATUS = getindexToValue("STATUS",STATUS);

					//ʩ��ͼ
					cell = row.getCell(8)==null?row.createCell(8):row.getCell(8);
					cell.setCellType(1);
					String FILE_NAME = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					if("".equals(FILE_NAME)){
						checkCell+="��"+i+"��ʩ��ͼ����Ϊ�գ�";
					}
					//������������
					cell = row.getCell(9)==null?row.createCell(9):row.getCell(9);
					cell.setCellType(1);
					String DAILY_INSTRUMENT_USE = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					if("".equals(DAILY_INSTRUMENT_USE)){
						checkCell+="��"+i+"������������������Ϊ�գ�";
					}
					//�ܼ���������
					cell = row.getCell(10)==null?row.createCell(10):row.getCell(10);
					cell.setCellType(1);
					String DAILY_INSTRUMENT_ALL = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					if("".equals(DAILY_INSTRUMENT_ALL)){
						checkCell+="��"+i+"���ܼ�������������Ϊ�գ�";
					}
					//�������
					cell = row.getCell(11)==null?row.createCell(11):row.getCell(11);
					cell.setCellType(1);
					String BUG_CODE = cell.getStringCellValue()==null? "":cell.getStringCellValue();
					BUG_CODE = getindexToValue("BUG_CODE",BUG_CODE.trim());


					//��������
					cell = row.getCell(12)==null?row.createCell(12):row.getCell(12);
					cell.setCellType(1);
					String Q_DESCRIPTION = cell.getStringCellValue()==null? "":cell.getStringCellValue();
	
					//�������
					cell = row.getCell(13)==null?row.createCell(13):row.getCell(13);
					cell.setCellType(1);
					String RESOLVENT = cell.getStringCellValue()==null? "":cell.getStringCellValue();

					if("".equals(PRODUCE_DATE)){
						responseDTO.setValue("message", "��"+i+"��������Ϊ�գ�");
						return responseDTO; 	
					}
					
					if("6".equals(IF_BUILD)){
						if(!"".equals(checkCell)){
							radDao.executeUpdate("update bgp_doc_gms_file set BSFLAG='1' where FILE_ID='"+file_id+"'");
							responseDTO.setValue("message", checkCell);
							return responseDTO; 					
						}						
					}

					
					String wtId = UUID.randomUUID().toString().replaceAll("-", "");
					String questionId = UUID.randomUUID().toString().replaceAll("-", "");

					String getCheckProuceDate="select DAILY_NO_WT from GP_OPS_DAILY_REPORT_WT where BSFLAG='0' and PROJECT_INFO_NO='"+projectInfoNo+"' and PRODUCE_DATE=to_date('"+PRODUCE_DATE+"','yyyy-MM-dd')";
					Map prouceDate = radDao.queryRecordBySQL(getCheckProuceDate);
					
					if(prouceDate==null){
						setProjectStatus(projectInfoNo,IF_BUILD);
						
						String insterWtSql="INSERT INTO GP_OPS_DAILY_REPORT_WT(DAILY_NO_WT, PROJECT_INFO_NO, ORG_ID,  PRODUCE_DATE,AUDIT_STATUS, AUDIT_DATE, RATIFIER, CREATOR, CREATE_DATE, BSFLAG, WEATHER,  IF_BUILD,  SUBMIT_STATUS, ORG_SUBJECTION_ID, STOP_REASON, PAUSE_REASON)"+ 
						"VALUES('"+wtId+"', '"+projectInfoNo+"', '"+orgId+"', to_date(\'"+PRODUCE_DATE+"\',\'yyyy-MM-dd\'), '0',     SYSDATE,      '', '"+user_id+"',    SYSDATE,   '0', '"+WEATHER+"','"+IF_BUILD+"', '1', '"+orgSubjectionId+"', '"+STOP_REASON+"', '"+PAUSE_REASON+"')";
						radDao.executeUpdate(insterWtSql);	
						/*
						if("".equals(BUG_CODE)&&"".equals(RESOLVENT)&&"".equals(Q_DESCRIPTION)){							
						}else {
							String insterQuestionSql="INSERT INTO GP_OPS_DAILY_QUESTION(QUESTION_ID, PROJECT_INFO_NO, ORG_ID, ORG_SUBJECTION_ID, BUG_CODE, BUG_NAME, RESOLVENT, Q_DESCRIPTION,PRODUCE_DATE,CREATOR,CREATE_DATE, UPDATOR, MODIFI_DATE, LOCKED_IF, BSFLAG, NOTES, SPARE1, SPARE2)"+ 
							"VALUES('"+questionId+"', '"+projectInfoNo+"', '"+orgId+"', '"+orgSubjectionId+"', '"+BUG_CODE+"', '', '"+RESOLVENT+"', '"+Q_DESCRIPTION+"', to_date(\'"+PRODUCE_DATE+"\',\'yyyy-MM-dd\'), '"+user_id+"', SYSDATE, '"+user_id+"', SYSDATE, '', '0', '', '', '')";
							radDao.executeUpdate(insterQuestionSql);
						}
						*/
		

						
						//��workloa��ӿճ�ʼ��������----start
						String sql = "select * from bgp_p6_workload where bsflag = '0' and project_info_no = '"+ projectInfoNo+ "' and produce_date = to_date('"+ PRODUCE_DATE + "','yyyy-MM-dd') ";
			            List<Map<String, Object>> temp = radDao.getJdbcTemplate().queryForList(sql);
						if (temp == null || temp.size() == 0) {
							// ����û�м�¼
							sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"
									+ projectInfoNo + "' ";
							List<Map<String, Object>> tempList = radDao.getJdbcTemplate().queryForList(sql);

							for (int s = 0; s < tempList.size(); s++) {
								Map<String, Object> mapTemp = tempList.get(s);
								mapTemp.put("produce_date", PRODUCE_DATE);
								mapTemp.put("object_id", null);
								mapTemp.put("actual_this_period_units", "0");
								mapTemp.put("create_date", new Date());
								mapTemp.put("creator", user.getUserId());
								mapTemp.put("modifi_date", new Date());
								mapTemp.put("updator", user.getUserId());
							}
							WorkloadMCSBean w = new WorkloadMCSBean();
							w.saveOrUpdateWorkloadToMCS(tempList, user);
						}
						//��workloa��ӿճ�ʼ��������----end
					}else{
						wtId = (String)prouceDate.get("daily_no_wt");
					}
					if(!"6".equals(IF_BUILD)){
						continue;
					}
					//���ݿ�̽�����������id
					String getActivity = "select ACTIVITY_OBJECT_ID,MAPPING_ID,EXPLORATION_METHOD from bgp_activity_method_mapping where EXPLORATION_METHOD=("+
							"select CODING_CODE_ID from COMM_CODING_SORT_DETAIL where CODING_NAME='"+EXPLORATION_METHOD+"' and BSFLAG='0') and BSFLAG='0' and PROJECT_INFO_NO='"+projectInfoNo+"'";
					Map ActivityMap = jdbcDao.queryRecordBySQL(getActivity);
					String ACTIVITY_OBJECT_ID="";
					String methodCode="";
					if(ActivityMap!=null){
						ACTIVITY_OBJECT_ID = (String)ActivityMap.get("activityObjectId");
						methodCode=(String)ActivityMap.get("explorationMethod");
						
						String 	getOrgId="select ORG_ID  from COMM_ORG_INFORMATION where ORG_ABBREVIATION='"+TEAM+"'";
						Map vspMap = jdbcDao.queryRecordBySQL(getOrgId);
						String VSP_TEAM_NO="";
						if(vspMap!=null){
							VSP_TEAM_NO = (String)vspMap.get("orgId");						
						}
						//DAILY_WORKLOAD_������	�����	�����	����	��Ʒ	�ϸ�Ʒ	һ��Ʒ	������	�յ�	GPS���Ƶ�	���Բ����	�����	����	��������	���θ�����	�ظļ���	�ձ�վ	�����ձ�վ																																																																																																																																																																																																																																				
						Map<String,String> excleKV = new HashMap<String, String>();
						String v="";
						String k="";
						for(int j=14;j<=info.length+14;j++){
							cell = row.getCell(j)==null?row.createCell(j):row.getCell(j);
							cell.setCellType(1);
							String colunmValue = cell.getStringCellValue()==null? "":cell.getStringCellValue();

							String javaV = excleTOjava.get("excle_"+j);
							if(javaV!=null){
								int javaIndex = Integer.parseInt(javaV.split("_")[1]);
								String infoValue = info[javaIndex];
								String infoValueValue = infoValue.split("/")[0];
								String infoValueName = infoValue.split("/")[1];

								k=k+","+infoValueValue;
								if("".equals(colunmValue)){
									v=v+",null";
								}else{
									v=v+","+colunmValue;
								}
								excleKV.put("key_"+infoValueName, colunmValue);
							}

						}
						String DAILY_REPORT_ID = UUID.randomUUID().toString().replaceAll("-", "");
						String checkZbMeThod="select EXPLORATION_METHOD,DAILY_NO_WT,DAILY_REPORT_ID from GP_OPS_DAILY_REPORT_ZB where PROJECT_INFO_NO='"+projectInfoNo+"' and BSFLAG='0' and EXPLORATION_METHOD='"+methodCode+"' and DAILY_NO_WT='"+wtId+"'";
						Map zbMeThod = radDao.queryRecordBySQL(checkZbMeThod);

						StringBuffer sbk = new StringBuffer();
						StringBuffer sbv = new StringBuffer();
						
						if(zbMeThod==null){
							sbk.append("INSERT INTO GP_OPS_DAILY_REPORT_ZB(PROJECT_INFO_NO, EXPLORATION_METHOD, CREATE_DATE, BSFLAG, PRODUCE_DATE, VSP_TEAM_NO, ACTIVITY_OBJECT_ID, DAILY_REPORT_ID, DAILY_NO_WT, DAILY_INSTRUMENT_USE, DAILY_INSTRUMENT_ALL, TASK_STATUS, STOP_REASON, PAUSE_REASON,FILE_NAME,STATUS");
							sbk.append(k);
							sbk.append(")");
							
							sbv.append(" VALUES('"+projectInfoNo+"', '"+methodCode+"', SYSDATE, '0', to_date(\'"+PRODUCE_DATE+"\',\'yyyy-MM-dd\'), '"+VSP_TEAM_NO+"', '"+ACTIVITY_OBJECT_ID+"', '"+DAILY_REPORT_ID+"','"+wtId+"',"+DAILY_INSTRUMENT_USE+","+DAILY_INSTRUMENT_ALL+",'"+TASK_STATUS+"', '"+STOP_REASON+"', '"+PAUSE_REASON+"','"+FILE_NAME+"','1'");
							sbv.append(v);
							sbv.append(")");

							String insterZbSql = sbk.toString()+sbv.toString();
						    
							radDao.executeUpdate(insterZbSql);	
							
							if("".equals(BUG_CODE)&&"".equals(RESOLVENT)&&"".equals(Q_DESCRIPTION)){							
							}else {
								String insterQuestionSql="INSERT INTO GP_OPS_DAILY_QUESTION(QUESTION_ID, PROJECT_INFO_NO, ORG_ID, ORG_SUBJECTION_ID, BUG_CODE, BUG_NAME, RESOLVENT, Q_DESCRIPTION,PRODUCE_DATE,CREATOR,CREATE_DATE, UPDATOR, MODIFI_DATE, LOCKED_IF, BSFLAG, NOTES, SPARE1, SPARE2,DAILY_REPORT_ID)"+ 
								"VALUES('"+questionId+"', '"+projectInfoNo+"', '"+orgId+"', '"+orgSubjectionId+"', '"+BUG_CODE+"', '', '"+RESOLVENT+"', '"+Q_DESCRIPTION+"', to_date(\'"+PRODUCE_DATE+"\',\'yyyy-MM-dd\'), '"+user_id+"', SYSDATE, '"+user_id+"', SYSDATE, '', '0', '', '', '','"+DAILY_REPORT_ID+"')";
								radDao.executeUpdate(insterQuestionSql);
							}
							
							//���´��뱾�˸Ų����𡣣���ԭ���������ƣ�
							//��workload�����������---start
							Map<String,Object> map = new HashMap<String,Object>();
							map.put("activity_object_id", ACTIVITY_OBJECT_ID);
							map.put("produce_date", PRODUCE_DATE);
							PageModel page = new PageModel();
							page.setCurrPage(1);
							page.setPageSize(99999);

							page = workloadMCSBean.queryWorkload(map,page);
							List<Map<String, Object>> workLoadList = page.getData();
							
							List<Map<String, Object>> workList = new ArrayList<Map<String, Object>>();
							
							for (int r = 0; r < workLoadList.size(); r++) {
								Map<String, Object> workload = workLoadList.get(r);
								workload.put("produce_date", PRODUCE_DATE);
								//String value = reqDTO.getValue("actual_this_period_units"+workload.get("object_id").toString());//ҳ��ֵ
								String RESOURCE_NAME = (String)workload.get("resource_name");
								String unitsValue = excleKV.get("key_"+RESOURCE_NAME.split(" ")[1]);
								if("".equals(unitsValue)||unitsValue==null){
									unitsValue="0";
								}
								workload.put("actual_this_period_units", unitsValue);//����Դ��Ӧ�ı��ڷ���ֵ
								workload.put("ACTIVITY_OBJECT_ID", ACTIVITY_OBJECT_ID);
								workList.add(workload);
							}
							workloadMCSBean.saveOrUpdateWorkloadToMCS(workList, user);
							//��workload�����������----end
							
							map.put("object_id", ACTIVITY_OBJECT_ID);
							map.put("project_id", project_id);
							List<Map<String,Object>> list2 = activityMCSBean.queryActivityFrom(map);
							List<ActivityExtends> list3 = new ArrayList<ActivityExtends>();

							if (list2 != null && list2.size() > 0) {
								Map<String,Object> map2 = list2.get(0);
								Activity a = new Activity();
								
							 if (STATUS == "Not Started" || "Not Started".equals(STATUS)) {
									//״̬ҳ����ֵ �򲻱�
									a.setStatus((String)map2.get("STATUS"));
									a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//��ʼ����
									if (map2.get("ACTUAL_START_DATE")!=null) {
										a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//ʵ�ʿ�ʼ����
									}
									a.setFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//����ʱ��
									if (map2.get("ACTUAL_FINISH_DATE")!=null) {
										a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", null, ((Timestamp)map2.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//ʵ�ʽ���
									}
								} else if (STATUS == "In Progress" || "In Progress".equals(STATUS)) {
									a.setStatus("In Progress");
									//String startDate = reqDTO.getValue("start_date");
									String startDate = PRODUCE_DATE;
									if (startDate != null && !"".equals(startDate)) {
										a.setStartDate(P6TypeConvert.convert(startDate.substring(0, 10)+" 08:00:00","yyyy-MM-dd HH:mm:ss"));//��ʼ����
										a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, startDate.substring(0, 10)+" 08:00:00", "yyyy-MM-dd HH:mm:ss"));//ʵ�ʿ�ʼ����
									} else {
										a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//��ʼ����
										if (map2.get("ACTUAL_START_DATE")!=null) {
											a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//ʵ�ʿ�ʼ����
										}
									}
									//��ѧ��20131105�޸�: ״̬Ϊ������,��ѽ���ʱ���ÿ� 
									
									a.setFinishDate(null);//����ʱ��

									
								} else if (STATUS == "Completed" || "Completed".equals(STATUS)) {
									a.setStatus("Completed");
									String startDate = PRODUCE_DATE;
									if (startDate != null && !"".equals(startDate)) {
										a.setStartDate(P6TypeConvert.convert(startDate.substring(0, 10)+" 08:00:00","yyyy-MM-dd HH:mm:ss"));//��ʼ����
										a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, startDate.substring(0, 10)+" 08:00:00", "yyyy-MM-dd HH:mm:ss"));//ʵ�ʿ�ʼ����
									} else {
										a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//��ʼ����
										if (map2.get("ACTUAL_START_DATE")!=null) {
											a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//ʵ�ʿ�ʼ����
										}
									}
									String finishDate = PRODUCE_DATE;

									//String finishDate = reqDTO.getValue("finish_date");
									if(finishDate!=null){
										a.setFinishDate(P6TypeConvert.convert(finishDate.substring(0, 10)+" 18:00:00","yyyy-MM-dd HH:mm:ss"));//����ʱ��
										a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", null, finishDate.substring(0, 10)+" 18:00:00", "yyyy-MM-dd HH:mm:ss"));//ʵ�ʽ�������

									}
									} else {
									a.setStatus((String)map2.get("STATUS"));
									a.setStartDate(P6TypeConvert.convert(((Timestamp) map2.get("START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//��ʼ����
									if (map2.get("ACTUAL_START_DATE")!=null) {
										a.setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate", null, ((Timestamp)map2.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//ʵ�ʿ�ʼ����
									}
									a.setFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));//����ʱ��
									if (map2.get("ACTUAL_FINISH_DATE")!=null) {
										a.setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate", null, ((Timestamp)map2.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));//ʵ�ʽ���
									}
								}
								
								//a.setStartDate(value)
								
								a.setPlannedStartDate(P6TypeConvert.convert(((Timestamp)map2.get("PLANNED_START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
								a.setPlannedFinishDate(P6TypeConvert.convert(((Timestamp)map2.get("PLANNED_FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
								
								a.setId((String)map2.get("ID"));
								a.setName((String)map2.get("NAME"));
								a.setProjectId((String)map2.get("PROJECT_ID"));
								a.setProjectName((String)map2.get("PROJECT_NAME"));
								a.setProjectObjectId(((BigDecimal)map2.get("PROJECT_OBJECT_ID")).intValue());
//								if ((String)map2.get("STATUS") == "Not Started" || "Not Started".equals((String)map2.get("STATUS"))) {
//									a.setStatus("In Progress");//��ʼ//Completed
//								} else {
//									a.setStatus((String)map2.get("STATUS"));
//								}
								a.setWBSCode((String)map2.get("WBS_CODE"));
								a.setWBSName((String)map2.get("WBS_NAME"));
								a.setWBSObjectId(P6TypeConvert.convertInteger("WBSObjectId",((BigDecimal)map2.get("WBS_OBJECT_ID")).toEngineeringString()));
								a.setObjectId(((BigDecimal)map2.get("OBJECT_ID")).intValue());
								if (map2.get("SUSPEND_DATE")!=null) {
									a.setSuspendDate(P6TypeConvert.convertXMLGregorianCalendar("SuspendDate", null, ((Timestamp)map2.get("SUSPEND_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
								}
								if (map2.get("RESUME_DATE")!=null) {
									a.setResumeDate(P6TypeConvert.convertXMLGregorianCalendar("ResumeDate", null, ((Timestamp)map2.get("RESUME_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
								}
								a.setNotesToResources((String)map2.get("NOTES_TO_RESOURCES"));
								if (map2.get("EXPECTED_FINISH_DATE")!=null) {
									a.setExpectedFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ResumeDate", null, ((Timestamp)map2.get("EXPECTED_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
								}
								a.setPlannedDuration(Double.valueOf(((BigDecimal)map2.get("PLANNED_DURATION")).toEngineeringString()));
								a.setLastUpdateDate(P6TypeConvert.convertXMLGregorianCalendar("LastUpdateDate", null, new Date()));
								a.setLastUpdateUser(user.getUserName());
								
							 
								a.setRemainingDuration(P6TypeConvert.convertDouble("RemainingDuration",null,String.valueOf(2.0)));
								
								a.setCalendarName((String) map2.get("CALENDAR_NAME"));
								a.setCalendarObjectId(((BigDecimal)map2.get("CALENDAR_OBJECT_ID")).intValue());

								ActivityExtends aa = new ActivityExtends(a);
								aa.setSubmitFlag("0");
								list3.add(aa);
								
								//activityObjectId = a.getObjectId().toString();
							}
							
							activityMCSBean.saveOrUpdateP6Activity(list3, user, project_id);
							
							Map<String,Object> map9 = new HashMap<String,Object>();
							map9.put("activity_object_id", ACTIVITY_OBJECT_ID);
							map9.put("produce_date", PRODUCE_DATE);
							List<Map<String,Object>> list = resourceAssignmentMCSBean.queryResourceAssignment(map9);
							Map<String,Object> map1 = null;
							ResourceAssignmentExtends r = null;
							List<ResourceAssignmentExtends> resourceAssignments = new ArrayList<ResourceAssignmentExtends>();
							
							for (int f = 0; f < list.size(); f++) {
								map1 = list.get(f);
								
								String RESOURCE_NAME = (String)map1.get("resource_name");
								String value = excleKV.get("key_"+RESOURCE_NAME.split(" ")[1]);
								double value1 = ((BigDecimal) map1.get("ACTUAL_THIS_PERIOD_UNITS")).doubleValue();//���ݿ��е�ֵ(Ҫ�����ǵ�ֵ)
								//double value1 = 0.0;
								if (value == null || "".equals(value) || value == "0" || "0".equals(value)) {
									//��Դ���ڷ���ֵΪ0
									if (value1 != 0) {
										//���ݿ�������ֵ (�޸����ݿ��ֵΪ0)
									} else {
										//�������ֵΪ0 ҳ���ֵΪ0 ������������Դ
										continue;
									}
								}
								//����
								String remainingUnit = reqDTO.getValue("remaining_units"+map1.get("OBJECT_ID").toString());//ҳ��ֵ
								
								//ʵ������/ʵ���豸̨��
								String budgeted_units = reqDTO.getValue("budgeted_units"+map1.get("OBJECT_ID").toString());//ҳ��ֵ
								
								if (((String) map1.get("RESOURCE_TYPE")) == "Material" || "Material".equals((String) map1.get("RESOURCE_TYPE"))) {
									//���� ��������
								} else {
									//�˹� ���˹� �������� ��Ҫ�������������е�ÿ��Сʱ��
									value = String.valueOf(((BigDecimal)map1.get("HOURS_PER_DAY")).doubleValue() * Double.parseDouble(value));
									remainingUnit = String.valueOf(((BigDecimal)map1.get("HOURS_PER_DAY")).doubleValue() * Double.parseDouble(remainingUnit));
									budgeted_units = String.valueOf(((BigDecimal)map1.get("HOURS_PER_DAY")).doubleValue() * Double.parseDouble(budgeted_units));
								}
								
								String namespace = "http://xmlns.oracle.com/Primavera/P6/WS/ResourceAssignment/V1";
								r = new ResourceAssignmentExtends();
								r.getResourceAssignment().setProjectId(map1.get("PROJECT_ID").toString());
								r.getResourceAssignment().setProjectObjectId(((BigDecimal)map1.get("PROJECT_OBJECT_ID")).intValue());
								r.setOrgId(user.getOrgId());
								r.setOrgSubjectionId(user.getOrgSubjectionId());
								r.getResourceAssignment().setActivityId((String) map1.get("ACTIVITY_ID"));
								r.getResourceAssignment().setActivityName((String) map1.get("ACTIVITY_NAME"));
								r.getResourceAssignment().setResourceName((String) map1.get("RESOURCE_NAME"));
								r.getResourceAssignment().setResourceId((String) map1.get("RESOURCE_ID"));
								r.getResourceAssignment().setActivityObjectId(((BigDecimal)map1.get("ACTIVITY_OBJECT_ID")).intValue());
								r.getResourceAssignment().setPlannedStartDate(P6TypeConvert.convert(((Timestamp) map1.get("PLANNED_START_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
								r.getResourceAssignment().setPlannedFinishDate(P6TypeConvert.convert(((Timestamp) map1.get("PLANNED_FINISH_DATE")).toString(),"yyyy-MM-dd HH:mm:ss"));
								r.getResourceAssignment().setPlannedDuration(P6TypeConvert.convertDouble("PlannedDuration",namespace,((BigDecimal)map1.get("PLANNED_DURATION")).toEngineeringString()));
								
								if (map1.get("ACTUAL_START_DATE")!=null) {
									r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,((Timestamp)map1.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
									r.getResourceAssignment().setStartDate(P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,((Timestamp) map1.get("START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
								} else {
									//ʵ�ʿ�ʼΪ�� ȡ�ձ�����
									r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,PRODUCE_DATE.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss"));
									r.getResourceAssignment().setStartDate((P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,PRODUCE_DATE.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss")));
								}
								
								if (STATUS == "In Progress" || "In Progress".equals(STATUS)) {
									if (map1.get("ACTUAL_START_DATE")!=null) {
										r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,((Timestamp)map1.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
										r.getResourceAssignment().setStartDate(P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,((Timestamp) map1.get("START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
									} else {
										//ʵ�ʿ�ʼΪ�� ȡ�ձ�����
										r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,PRODUCE_DATE.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss"));
										r.getResourceAssignment().setStartDate((P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,PRODUCE_DATE.substring(0, 10) + " 08:00:00", "yyyy-MM-dd HH:mm:ss")));
									}
									r.getResourceAssignment().setFinishDate(P6TypeConvert.convertXMLGregorianCalendar("FinshDate",namespace,((Timestamp) map1.get("FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
									
									if (map1.get("ACTUAL_FINISH_DATE")!=null) {
										r.getResourceAssignment().setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate",namespace,((Timestamp)map1.get("ACTUAL_FINISH_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
									}
								} else if (STATUS == "Completed" || "Completed".equals(STATUS)) {
									r.getResourceAssignment().setActualStartDate(P6TypeConvert.convertXMLGregorianCalendar("ActualStartDate",namespace,((Timestamp)map1.get("ACTUAL_START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
									r.getResourceAssignment().setStartDate(P6TypeConvert.convertXMLGregorianCalendar("StartDate",namespace,((Timestamp) map1.get("START_DATE")).toString(), "yyyy-MM-dd HH:mm:ss"));
									
									r.getResourceAssignment().setFinishDate(P6TypeConvert.convertXMLGregorianCalendar("FinshDate",namespace,PRODUCE_DATE.substring(0, 10) + " 18:00:00", "yyyy-MM-dd HH:mm:ss"));
									r.getResourceAssignment().setActualFinishDate(P6TypeConvert.convertXMLGregorianCalendar("ActualFinishDate",namespace,PRODUCE_DATE.substring(0, 10) + " 18:00:00", "yyyy-MM-dd HH:mm:ss"));
								}
									
								
								r.getResourceAssignment().setActualThisPeriodUnits(P6TypeConvert.convertDouble("ActualThisPeriodUnits",namespace,value));//����Դ��Ӧ�ı��ڷ���ֵ
								
								double actualUnits = ((BigDecimal) map1.get("ACTUAL_UNITS")).doubleValue() + Double.parseDouble(value) - value1;//�����ۼ�����
								
								r.getResourceAssignment().setActualUnits(P6TypeConvert.convertDouble("ActualUnits",namespace,String.valueOf(actualUnits)));//�ۼ�����
								
								double plannedUnits = Double.parseDouble(((BigDecimal)map1.get("PLANNED_UNITS")).toEngineeringString());
								
								r.getResourceAssignment().setPlannedUnits(P6TypeConvert.convertDouble("PlannedUnits",namespace,String.valueOf(plannedUnits)));//Ԥ������
								
								r.getResourceAssignment().setRemainingUnits(P6TypeConvert.convertDouble("RemainingUnits",namespace,remainingUnit));//ҳ��ֵ
								
								r.setBudgetedUnits(Double.parseDouble(budgeted_units));
								
								r.setSubmitFlag("0");//0���� 1�ύ 3ͨ�� 4δͨ��
								r.getResourceAssignment().setLastUpdateDate(P6TypeConvert.convertXMLGregorianCalendar("LastUpdateDate",namespace,new Date()));
								r.getResourceAssignment().setLastUpdateUser(user.getEmpId());
								r.getResourceAssignment().setObjectId(((BigDecimal)map1.get("OBJECT_ID")).intValue());
								r.getResourceAssignment().setResourceObjectId(P6TypeConvert.convertInteger("ResourceObjectId",namespace,((BigDecimal)map1.get("RESOURCE_OBJECT_ID")).toEngineeringString()));
								r.getResourceAssignment().setResourceType((String) map1.get("RESOURCE_TYPE"));
								r.getResourceAssignment().setCalendarName((String) map1.get("CALENDAR_NAME"));
								r.getResourceAssignment().setCalendarObjectId(P6TypeConvert.convertInteger("CalendarObjectId",namespace,((BigDecimal)map1.get("CALENDAR_OBJECT_ID")).toEngineeringString()));
								
								resourceAssignments.add(r);
								
							}
							resourceAssignmentMCSBean.saveOrUpdateP6ResourceAssignmentToMCS(resourceAssignments, user, ACTIVITY_OBJECT_ID);

							
						}
					}else{
						errorMessage+="��"+i+"�У�û�и÷�����Ӧ����ҵ;";
					}
					
				//for_end
				}
			}
			if("".equals(errorMessage)){
				errorMessage="����ɹ�!";
			}else{
				radDao.executeUpdate("update bgp_doc_gms_file set BSFLAG='1' where FILE_ID='"+file_id+"'");
			}
			responseDTO.setValue("message", errorMessage);
			return responseDTO; 
		}
	
	public static String getindexToValue(String type,String value){
		String[] IF_BUILD={"1_��Ǩ","2_̤��","3_����","4_��ѵ","5_����","6_�ɼ�","7_����","8_����","9_ǲɢ","10_�鵵","11_ͣ��","12_��ͣ","13_����"};
		String[] PAUSE_STOP_REASON={"1_��������","2_��Ա����","3_��������","4_��ũЭ������","5_�͹�˾����","6_����"};
		String[] WEATHER={"1_��","2_��","3_����","4_��","5_��","6_��","7_˪��","8_����","9_̨��","10_����ѩ","11_ѩ","12_���ѩ","13_����","14_����","15_��ɳ","16_����","17_���"};
		String[] TASK_STATUS={"1_�ɼ�","2_ͣ��","3_��ͣ","4_����"};
		String[] STATUS={"Not Started_δ��ʼ","In Progress_���ڽ���","Completed_���"};
		String[] BUG_CODE={"5000100005000000001_��Ա","5000100005000000002_����","5000100005000000003_�豸","5000100005000000004_HSE","5000100005000000005_����","5000100005000000006_��ũ��������ϵ","5000100005000000007_����",
		"5000100005000000008_����","5000100005000000009_�׷���Ϣ","5000100005000000010_��Ȼ����","5000100005000000011_����","5000100005000000012_����Ӫ","5000100005000000013_����"};

		String[]  temp=null;
		if("IF_BUILD".equals(type)){
			temp=IF_BUILD;
		}else if("PAUSE_STOP_REASON".equals(type)){
			temp=PAUSE_STOP_REASON;
		}else if("WEATHER".equals(type)){
			temp=WEATHER;
		}else if("TASK_STATUS".equals(type)){
			temp=TASK_STATUS;
		}else if("STATUS".equals(type)){
			temp=STATUS;
		}else if("BUG_CODE".equals(type)){
			temp=BUG_CODE;			
		}
		String infoValue="";
		for(int i=0;i<=temp.length-1;i++){
			String info = temp[i];
			String infoName = info.split("_")[1];
			if(infoName.equals(value)){
				infoValue  = info.split("_")[0];
			}
		}
		return infoValue;
	}
	public void setProjectStatus(String project_info_no,String IF_BUILD){
		if(IF_BUILD!=null&&!"".equals(IF_BUILD)){
			//�޸��ձ�¼��״̬ʱͬ����Ŀ��Ϣ��״̬
			String projectStatus = "";
			if(IF_BUILD!=null&&"1".equals(IF_BUILD)||"2".equals(IF_BUILD)||"3".equals(IF_BUILD)||"4".equals(IF_BUILD)||"5".equals(IF_BUILD)){
				//��Ŀ���� ��Ǩ��̤������������ѵ������
				projectStatus="5000100001000000001";
			}else if(IF_BUILD!=null&&"6".equals(IF_BUILD)||"7".equals(IF_BUILD)){
				//���ɼ���ͣ������Ӧ����ʩ��
				projectStatus="5000100001000000002";

			}else if(IF_BUILD!=null&&"8".equals(IF_BUILD)){
				//��Ŀ��ͣ
				projectStatus="5000100001000000004";

			}else if(IF_BUILD!=null&&"9".equals(IF_BUILD)){
				projectStatus="5000100001000000005";

				//ʩ������
			}
			String projectupdate="update gp_task_project set PROJECT_STATUS='"+projectStatus+"' where PROJECT_INFO_NO='"+project_info_no+"'";
			radDao.getJdbcTemplate().update(projectupdate);
		}	
	}
	
	public ISrvMsg getAuditInfo(ISrvMsg reqDTO) throws Exception {

		String daily_no = reqDTO.getValue("dailyNo");

		String sql = "select r.*,h.employee_name,adm.*  from gp_ops_daily_report r"
				+ " left join gp_adm_data_examine adm on r.daily_no = adm.data_no and adm.bsflag = '0' "
				+ " left join comm_human_employee h on h.employee_id = r.ratifier and h.bsflag = '0' "
				+ " where daily_no = '" + daily_no + "' ";

		Map map = jdbcDao.queryRecordBySQL(sql);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("auditMap", map);

		return msg;
	}
	
	
	public ISrvMsg getAustaus(ISrvMsg reqDTO) throws Exception {

		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String sql = " select  *  from   gp_proj_product_plan_wt  t where project_info_no = '"+projectInfoNo+"'   ";

		Map map = jdbcDao.queryRecordBySQL(sql);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("auditMap", map);

		return msg;
	}
	public Map getDailyStatus(Map map) {
		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
		Map dailyMap=new HashMap();
		String sql=" select * from gp_ops_daily_report_wt t where" +
				" t.project_info_no='"+projectInfoNo+"' and t.bsflag='0' and t.produce_date=to_date('"+produceDate+"','yyyy-mm-dd')";
		 dailyMap = jdbcDao.queryRecordBySQL(sql);
		return dailyMap;
	}
	@Deprecated
	public Map getDailyReport(Map map) {

		String dailyNo = (String) map.get("dailyNo");
		String daily_no_ws = (String) map.get("daily_no_ws");
		String daily_no = (String) map.get("dailyNoWs");
		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");

		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map.get("daily_no");
		}
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map.get("produce_date");
		}

		String sql = "";

		if (produceDate != null && !"".equals(produceDate)
				&& produceDate != "null" && !"null".equals(produceDate)) {
			sql = "select * from gp_ops_daily_report_zb r join gp_ops_daily_report_wt t on t.daily_no_wt=r.daily_no_wt left join gp_ops_daily_produce_sit sit on  sit.daily_no= r.daily_no_wt and sit.bsflag = '0' "
					+ " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method)  "
					+ " where r.project_info_no = '"
					+ projectInfoNo
					+ "'  and t.bsflag = '0' and t.produce_date = to_date('"
					+ produceDate + "','yyyy-MM-dd') ";
		} else {
			sql = "select * from gp_ops_daily_report_zb r  join gp_ops_daily_report_wt t on t.daily_no_wt=r.daily_no_wt left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no_wt and sit.bsflag = '0' "
					+ " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) "
					+ " where r.daily_no = '"
					+ dailyNo
					+ "'  and r.bsflag = '0' ";
		}

		Map dailyReport = jdbcDao.queryRecordBySQL(sql);

		sql = "select sum(nvl(r.daily_survey_shot_num,0)) as project_survey_shot_num "
				+ ",sum(nvl(r.daily_survey_geophone_num,0)) as project_survey_geophone_num "
				+ ",sum(nvl(r.survey_incept_workload,0)) as project_survey_incept_workload "
				+ ",sum(nvl(r.survey_shot_workload,0)) as project_survey_shot_workload "
				+ ",sum(nvl(r.daily_micro_measue_point_num,0)) as project_micro_measue_num"
				+ ",sum(nvl(r.daily_small_refraction_num,0)) as project_small_refraction_num"
				+ ",sum(nvl(r.daily_drill_sp_num,0)) as project_drill_sp_num"
				+ ",sum(nvl(r.daily_drill_well_num,0)) as project_drill_well_num"
				+ ",sum(nvl(r.daily_drill_footage_num,0)) as project_drill_footage_num"
				+ ",sum(nvl(r.daily_acquire_sp_num,0)+nvl(r.daily_jp_acquire_shot_num,0)+nvl(r.daily_qq_acquire_shot_num,0)) as project_acquire_sp_num"
				+ ",sum(nvl(r.daily_acquire_workload,0)+nvl(r.daily_jp_acquire_workload,0)+nvl(r.daily_qq_acquire_workload,0)) as project_acquire_workload"
				+ ",sum(nvl(r.daily_acquire_qualified_num,0)) as project_qualified_sp_num"
				+ ",sum(nvl(r.daily_acquire_firstlevel_num,0)) as project_firstlevel_sp_num"
				+ ",sum(nvl(r.collect_2_class,0)) as project_collect_2_class"
				+ ",sum(nvl(r.collect_waster_num,0)) as project_collect_waster_num"
				+ ",sum(nvl(r.collect_miss_num,0)) as project_collect_miss_num"
				+ ",sum(nvl(r.daily_test_sp_num,0)) as project_test_sp_num"
				+ ",sum(nvl(r.daily_test_qualified_sp_num,0)) as project_qualified_test_sp_num"
				+ " from gp_ops_daily_report r where project_info_no = '"
				+ projectInfoNo + "' ";

		if (produceDate != null && !"".equals(produceDate)
				&& produceDate != "null" && !"null".equals(produceDate)) {
			sql += " and produce_date <= to_date('" + produceDate
					+ "','yyyy-MM-dd') ";
		}

		Map map1 = jdbcDao.queryRecordBySQL(sql);

		try {
			dailyReport.putAll(map1);
		} catch (NullPointerException e) {
			// mapΪ��
			dailyReport = map1;
			dailyReport.put("produceDate", produceDate);
		}

		DecimalFormat df = new DecimalFormat();
		String style = "0.00%";

		df.applyPattern(style);

		// ����������ܵ�
		if (dailyReport.get("dailySurveyShotNum") == null
				|| "".equals(dailyReport.get("dailySurveyShotNum"))) {
			dailyReport.put("dailySurveyShotNum", "0");
		}
		if (dailyReport.get("dailySurveyGeophoneNum") == null
				|| "".equals(dailyReport.get("dailySurveyGeophoneNum"))) {
			dailyReport.put("dailySurveyGeophoneNum", "0");
		}
		dailyReport
				.put("dailySurveyTotalNum",
						P6TypeConvert.convertLong(dailyReport
								.get("dailySurveyShotNum"))
								+ P6TypeConvert.convertLong(dailyReport
										.get("dailySurveyGeophoneNum")));

		// ���ֱ���
		double designNum = 0.0;
		double actualNum = 0.0;

		// �������
		if (dailyReport.get("designSpNum") == null
				|| "".equals(dailyReport.get("designSpNum"))) {
			dailyReport.put("designSpNum", "0");
		}
		if (dailyReport.get("designGeophoneNum") == null
				|| "".equals(dailyReport.get("designGeophoneNum"))) {
			dailyReport.put("designGeophoneNum", "0");
		}
		if (dailyReport.get("projectSurveyShotNum") == null
				|| "".equals(dailyReport.get("projectSurveyShotNum"))) {
			dailyReport.put("projectSurveyShotNum", "0");
		}
		if (dailyReport.get("projectSurveyGeophoneNum") == null
				|| "".equals(dailyReport.get("projectSurveyGeophoneNum"))) {
			dailyReport.put("projectSurveyGeophoneNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designSpNum"))
				+ P6TypeConvert.convertDouble(dailyReport
						.get("designGeophoneNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectSurveyRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectSurveyShotNum"))
					+ P6TypeConvert.convertDouble(dailyReport
							.get("projectSurveyGeophoneNum"));
			dailyReport.put("projectSurveyRatio",
					df.format((actualNum / designNum)));
		}

		// �꾮�ڵ�
		if (dailyReport.get("designDrillNum") == null
				|| "".equals(dailyReport.get("designDrillNum"))) {
			dailyReport.put("designDrillNum", "0");
		}
		if (dailyReport.get("projectDrillSpNum") == null
				|| "".equals(dailyReport.get("projectDrillSpNum"))) {
			dailyReport.put("projectDrillSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("designDrillNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectDrillSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectDrillSpNum"));
			dailyReport.put("projectDrillSpRatio",
					df.format((actualNum / designNum)));
		}

		// �꾮 �첨��
		if (dailyReport.get("designGeophoneNum") == null
				|| "".equals(dailyReport.get("designGeophoneNum"))) {
			dailyReport.put("designGeophoneNum", "0");
		}
		if (dailyReport.get("projectSurveyGeophoneNum") == null
				|| "".equals(dailyReport.get("projectSurveyGeophoneNum"))) {
			dailyReport.put("projectSurveyGeophoneNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("designGeophoneNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectSurveyRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectSurveyGeophoneNum"));
			dailyReport.put("projectSurveyRatio",
					df.format((actualNum / designNum)));
		}

		// �ɼ� �ڵ�
		if (dailyReport.get("designSpNum") == null
				|| "".equals(dailyReport.get("designSpNum"))) {
			dailyReport.put("designSpNum", "0");
		}
		if (dailyReport.get("projectAcquireSpNum") == null
				|| "".equals(dailyReport.get("projectAcquireSpNum"))) {
			dailyReport.put("projectAcquireSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectAcquireSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectAcquireSpNum"));
			dailyReport.put("projectAcquireSpRatio",
					df.format((actualNum / designNum)));
		}

		// �ɼ� ������
		if (dailyReport.get("fullFoldWorkload") == null
				|| "".equals(dailyReport.get("fullFoldWorkload"))) {
			dailyReport.put("fullFoldWorkload", "0");
		}
		if (dailyReport.get("projectAcquireWorkload") == null
				|| "".equals(dailyReport.get("projectAcquireWorkload"))) {
			dailyReport.put("projectAcquireWorkload", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("fullFoldWorkload"));

		if (designNum == 0.0) {
			dailyReport.put("projectAcquireWorkRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectAcquireWorkload"));
			dailyReport.put("projectAcquireWorkRatio",
					df.format((actualNum / designNum)));
		}

		// �ɼ� �ϸ���
		if (dailyReport.get("projectAcquireSpNum") == null
				|| "".equals(dailyReport.get("projectAcquireSpNum"))) {
			dailyReport.put("projectAcquireSpNum", "0");
		}
		if (dailyReport.get("projectQualifiedSpNum") == null
				|| "".equals(dailyReport.get("projectQualifiedSpNum"))) {
			dailyReport.put("projectQualifiedSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectQualifiedSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectQualifiedSpNum"));
			dailyReport.put("projectQualifiedSpRatio",
					df.format((actualNum / designNum)));
		}

		// �ɼ� һ����
		if (dailyReport.get("projectFirstlevelSpNum") == null
				|| "".equals(dailyReport.get("projectFirstlevelSpNum"))) {
			dailyReport.put("projectFirstlevelSpNum", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectFirstlevelSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectFirstlevelSpNum"));
			dailyReport.put("projectFirstlevelSpRatio",
					df.format((actualNum / designNum)));
		}

		// �ɼ� ������
		if (dailyReport.get("projectCollect2Class") == null
				|| "".equals(dailyReport.get("projectCollect2Class"))) {
			dailyReport.put("projectCollect2Class", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectCollect2ClassRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectCollect2Class"));
			dailyReport.put("projectCollect2ClassRatio",
					df.format((actualNum / designNum)));
		}

		// �ɼ� ����
		if (dailyReport.get("projectCollectWasterNum") == null
				|| "".equals(dailyReport.get("projectCollectWasterNum"))) {
			dailyReport.put("projectCollectWasterNum", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectCollectWasterNumRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectCollectWasterNum"));
			dailyReport.put("projectCollectWasterNumRatio",
					df.format((actualNum / designNum)));
		}

		// �ɼ� ����
		if (dailyReport.get("projectCollectMissNum") == null
				|| "".equals(dailyReport.get("projectCollectMissNum"))) {
			dailyReport.put("projectCollectMissNum", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectCollectMissNumRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectCollectMissNum"));
			dailyReport.put("projectCollectMissNumRatio",
					df.format((actualNum / designNum)));
		}

		return dailyReport;
	}
	public List getExploration(String projectInfoNo,String produceDate) throws Exception {
		String sql = "select distinct(exploration_method) from gp_ops_daily_report_zb where project_info_no='"
				+ projectInfoNo + "' and bsflag='0' and produce_date = to_date('"
				+ produceDate + "','yyyy-MM-dd')  order by exploration_method desc";
		List<Map> list = (List) jdbcDao.queryRecords(sql);
		return list;
	}
	
	
	public List getIbuild(String projectInfoNo,String produce_date) throws Exception {
		String sql = "select distinct pa.name,w.if_build   from bgp_p6_activity pa  inner join gp_task_project t on t.project_id = pa.project_id"+
		      " and t.bsflag = '0'   inner join gp_ops_daily_report_zb b on b.activity_object_id = pa.object_id"+
		     " inner join gp_ops_daily_report_wt w on w.project_info_no=b.project_info_no and w.produce_date=b.produce_date"+
		    "  where pa.bsflag = '0'    and t.project_info_no = '"+projectInfoNo+"'    and b.produce_date = to_date('"+produce_date+"', 'yyyy-mm-dd')";
 
			 
		List<Map> list = (List) jdbcDao.queryRecords(sql);
		return list;
	}
	public ISrvMsg getMessage(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"
			+ projectInfoNo + "' ";
		Map daily_map=new HashMap();
		daily_map = jdbcDao.queryRecordBySQL(sql);
		
	msg.setValue("daily_map", daily_map);
		return msg;
	}
	public ISrvMsg getActivityName(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String activityId=(String) reqDTO.getValue("activityId");
		String sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"
			+ projectInfoNo + "'  and activity_object_id='"+activityId+"'";
		Map daily_map=new HashMap();
		daily_map = jdbcDao.queryRecordBySQL(sql);
		
	msg.setValue("daily_map", daily_map);
		return msg;
	}
	public ISrvMsg getMappingMethod(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String activityId=(String) reqDTO.getValue("activityId");
		String sql = "select * from bgp_activity_method_mapping g  where g.project_info_no='" +
		projectInfoNo+"' and g.activity_object_id='"+activityId+"'";
		 
		Map map=jdbcDao.queryRecordBySQL(sql);
		Map daily_map=new HashMap();
		String method="";
		if(map!=null){
			 method=(String) map.get("explorationMethod");
		}
		
	    if(!method.equals("5110000056000000045")&&!method.equals("")){
    		String sql1="select   t.coding_name,t.superior_code_id  FROM comm_coding_sort_detail t " +
			" WHERE t.coding_sort_id = '5110000056'   and t.bsflag = '0' " +
			"and t.coding_code_id='"+method+"'";

    		daily_map=jdbcDao.queryRecordBySQL(sql1);
    		 daily_map.put("explorationMethod", map.get("explorationMethod"));
	    }else if(method.equals("5110000056000000045")){
	    	 daily_map.put("explorationMethod","5110000056000000045");
	    	 daily_map.put("codingName","����");
	    }
	   
    	msg.setValue("daily_map", daily_map);
		return msg;
	}
	public ISrvMsg getStatus(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String produceDate=(String) reqDTO.getValue("produceDate");
		String sql = "select * from gp_ops_daily_report_wt where bsflag = '0'   and project_info_no = '"
			+ projectInfoNo + "' and produce_date=to_date('"+produceDate+"','yyyy-mm-dd')";
		Map daily_map=new HashMap();
		daily_map = jdbcDao.queryRecordBySQL(sql);
		
	msg.setValue("daily_map", daily_map);
		return msg;
	}

	public List getDailyReportList(String projectInfoNo,String produceDate) throws Exception {
		 
		List listM=new ArrayList();
		List list=getExploration(projectInfoNo, produceDate);
		for(int i=0;i<list.size();i++){
			Map map=(Map) list.get(i);
		String explorationMethod=(String)map.get("explorationMethod");
		String sql="";
		if(explorationMethod.equals("5110000056000000045")){
		  sql="select a.sumCe_a,  a.sumCe_b,  a.sumCe_c, a.sumCe_d, a.sumCe_e, b.sumCe1, b.sumCe2, b.sumCe3, b.sumCe4,  b.sumCe5,"+
       "round (decode(a.sumCe_e, 0,0,  a.sumCe_b / a.sumCe_e)*100,2) avgCet,round (decode(a.sumCe_c, 0,0,  a.sumCe_d / a.sumCe_c)*100,2) lvttCe "+
  " from (select t.sumCe_a, t.sumCe_b, t.sumCe_c, t.sumCe_d, t.sumCe_e from (select distinct (b.produce_date),"+
                               " sum(b.DAILY_GPS_CONTROL_POINT) over(order by b.produce_date) sumCe_a,"+
                               " sum(b.DAILY_MEASUREMENT_POINT) over(order by b.produce_date) sumCe_b,"+
                                "sum(b.DAILY_TERRAIN_CORRECT_POINT) over(order by b.produce_date) sumCe_c,"+
                              "  sum(b.DAILY_TC_CHECK_POINT) over(order by b.produce_date) sumCe_d,"+
                               " sum(b.DAILY_COORDINATE_POINT) over(order by b.produce_date) sumCe_e"+
                 " from gp_ops_daily_report_zb b where b.exploration_method = '"+explorationMethod+"' and b.bsflag='0' and b.project_info_no = '"+projectInfoNo+"') t"+
       "  where t.produce_date = to_date('"+produceDate+"', 'yyyy-mm-dd')) a, (select sum(b.DAILY_GPS_CONTROL_POINT) sumCe1,"+
             "  sum(b.DAILY_MEASUREMENT_POINT) sumCe2,  sum(b.DAILY_TERRAIN_CORRECT_POINT) sumCe3,  sum(b.DAILY_TC_CHECK_POINT) sumCe4, sum(b.DAILY_COORDINATE_POINT) sumCe5"+
        "  from gp_ops_daily_report_zb b  where b.exploration_method = '"+explorationMethod+"'   and b.project_info_no = '"+projectInfoNo+"' and b.produce_date = to_date('"+produceDate+"', 'yyyy-mm-dd') ) b";
	 
		    	Map daily_map=null;
		    	daily_map=new HashMap();
				daily_map = jdbcDao.queryRecordBySQL(sql);
				daily_map.put("exmethod", "5110000056000000045");
				daily_map.put("explorationMethod", explorationMethod);
				daily_map.put("name", "����������");
				listM.add(daily_map);
		     
		}else if(!explorationMethod.equals("5110000056000000045")&&!("").equals(explorationMethod)){
		 
				String sql1 = "select   t.coding_name,t.superior_code_id  FROM comm_coding_sort_detail t "
						+ " WHERE t.coding_sort_id = '5110000056'   and t.bsflag = '0' "
						+ "and t.coding_code_id='" + explorationMethod + "'";

				Map mapOrg = jdbcDao.queryRecordBySQL(sql1);

				StringBuffer sql2 = new StringBuffer(
						"select a.base_14p,a.base_13n,a.base_12m,a.base_11l,a.base_10k,a.base_9j,a.base_8h,a.base_7g,a.base_6f,a.base_5e,a.base_4d,a.base_3c,a.base_2b,a.base_1a,"
								+ "b.base14,b.base13,b.base12,b.base11,b.base10,b.base9,b.base8,b.base7,b.base6,b.base5,b.base4,b.base3,b.base2,b.base1,b.base0,c.location_point,c.line_length ,c.line_unit,"
								+ "round (decode(a.base_13n, 0,0,  a.base_10k / a.base_13n)*100,2) lvavg, ");
				if (mapOrg.get("superiorCodeId").equals("5110000056000000001")
						|| mapOrg.get("superiorCodeId").equals(
								"5110000056000000002")
						|| mapOrg.get("superiorCodeId").equals("0")) {
					sql2.append("round (decode(a.base_10k, 0,0,  a.base_8h /  a.base_10k)*100,2) lvavgtt,");
				} else {
					sql2.append("round (decode(a.base_13n, 0,0,  a.base_8h /  a.base_13n)*100,2) lvavgtt,");
				}

				sql2.append("  round(decode( c.location_point, 0, 0, a.base_14p /  c.location_point) * 100, 2) pointavg,"
						+ " round(decode( c.line_length, 0, 0, a.base_12m /  c.line_length) * 100, 2)lengthavg,"
						+ " round (decode( c.location_point, 0,0,  a.base_9j / c.location_point)*100,2) lvavgt, round (decode(a.base_13n, 0,0,  a.base_7g / a.base_13n)*100,2) lvavge,"
						+ " round (decode(c.location_point, 0,0,  a.base_6f /c.location_point)*100,2) lvavgv,  round (decode(c.location_point, 0,0,  a.base_5e / c.location_point)*100,2) lvavgw  from (select *"
						+ "   from (select distinct (b.produce_date), sum(b.DAILY_COORDINATE_POINT)over(order by b.produce_date) base_14p,"
						+ "   sum(b.DAILY_PHYSICAL_POINT)over(order by b.produce_date)  base_13n, sum(b.DAILY_WORKLOAD)over(order by b.produce_date)  base_12m,"
						+ " sum(b.DAILY_BASIC_POINT)over(order by b.produce_date) base_11l,  sum(b.DAILY_CHECK_POINT)over(order by b.produce_date) base_10k,"
						+ "   sum(b.DAILY_REWORK_POINT)over(order by b.produce_date) base_9j,  sum(b.DAILY_FIRST_GRADE)over(order by b.produce_date) base_8h,"
						+ "sum(b.DAILY_CONFORMING_PRODUCTS)over(order by b.produce_date)  base_7g,  sum(b.DAILY_NON_CONFORMING_PRODUCTS)over(order by b.produce_date)  base_6f,"
						+ "sum(b.DAILY_NULL_POINT)over(order by b.produce_date) base_5e, sum(b.DAILY_BASE_STATION)over(order by b.produce_date)  base_4d,"
						+ "sum(b.DAILY_WELL_SOUNDING_POINT)over(order by b.produce_date)  base_3c,sum(b.DAILY_GRAVITY_DATUM_POINT)over(order by b.produce_date)  base_2b,"
						+ " sum(b.DAILY_MAGNETISM_BASE_STATION)over(order by b.produce_date)  base_1a  from gp_ops_daily_report_zb b where b.exploration_method = '"
						+ explorationMethod
						+ "'"
						+ " and b.bsflag='0' and b.project_info_no = '"
						+ projectInfoNo
						+ "') t where t.produce_date = to_date('"
						+ produceDate
						+ "', 'yyyy-mm-dd')) a,"
						+ "(select   sum(b.DAILY_COORDINATE_POINT) base14,  sum(b.DAILY_PHYSICAL_POINT) base13, sum(b.DAILY_WORKLOAD) base12,  sum(b.DAILY_BASIC_POINT)base11,"
						+ "  sum(b.DAILY_CHECK_POINT)base10,  sum(b.DAILY_REWORK_POINT)base9,   sum(b.DAILY_FIRST_GRADE)base8,   sum(b.DAILY_CONFORMING_PRODUCTS) base7,"
						+ "sum(b.DAILY_NON_CONFORMING_PRODUCTS) base6, sum(b.DAILY_NULL_POINT) base5,  sum(b.DAILY_BASE_STATION) base4, sum(b.DAILY_WELL_SOUNDING_POINT) base3,"
						+ " sum(b.DAILY_GRAVITY_DATUM_POINT) base2,sum(b.DAILY_MAGNETISM_BASE_STATION) base1 ,sum(b.daily_first_ratio) base0 from gp_ops_daily_report_zb b where b.exploration_method = '"
						+ explorationMethod
						+ "'"
						+ " and b.bsflag='0' and b.project_info_no = '"
						+ projectInfoNo
						+ "' and b.produce_date = to_date('"
						+ produceDate
						+ "', 'yyyy-mm-dd') ) b,  (select *"
						+ " from (select a.location_point, a.line_length,a.line_unit from gp_wt_workload a  where a.project_info_no = '"
						+ projectInfoNo
						+ "' and a.exploration_method='"
						+ explorationMethod + "') pp ) c");

	 String sqlSub=sql2.toString();
 			if(mapOrg.get("superiorCodeId").equals("5110000056000000001")){
 				Map daily_map1=null;
		    	daily_map1=new HashMap();
				daily_map1 = jdbcDao.queryRecordBySQL(sqlSub);
				daily_map1.put("exmethod", "5110000056000000001");
				daily_map1.put("explorationMethod", explorationMethod);
			 

			    
               
				daily_map1.put("name", mapOrg.get("codingName"));
				 
				listM.add(daily_map1);
					}
			
		   
 			if(mapOrg.get("superiorCodeId").equals("5110000056000000002")){
		    	Map daily_map2=null;
		    	daily_map2=new HashMap();
				daily_map2 = jdbcDao.queryRecordBySQL(sqlSub);
				daily_map2.put("exmethod", "5110000056000000002");
				daily_map2.put("explorationMethod", explorationMethod);
			 
                
				daily_map2.put("name", mapOrg.get("codingName"));
				 
			 
				listM.add(daily_map2);
		    }
 			if(mapOrg.get("superiorCodeId").equals("5110000056000000003")){
		    	Map daily_map3=null;
		    	daily_map3=new HashMap();
				daily_map3 = jdbcDao.queryRecordBySQL(sqlSub);
				daily_map3.put("exmethod", "5110000056000000003");
				daily_map3.put("explorationMethod", explorationMethod);
				 
				daily_map3.put("name", mapOrg.get("codingName"));
				 
				 
				listM.add(daily_map3);
		    }
 			if(mapOrg.get("superiorCodeId").equals("5110000056000000004")){
		    	Map daily_map4=null;
				
		    	daily_map4=new HashMap();
		    	
				daily_map4 = jdbcDao.queryRecordBySQL(sqlSub);
				daily_map4.put("exmethod", "5110000056000000004");
				daily_map4.put("explorationMethod", explorationMethod);
				 
				daily_map4.put("name", mapOrg.get("codingName"));
				listM.add(daily_map4);
		    }
 			if(mapOrg.get("superiorCodeId").equals("0")){
		    	Map daily_map5=null;
		    	daily_map5=new HashMap();
				daily_map5 = jdbcDao.queryRecordBySQL(sqlSub);
				daily_map5.put("exmethod", "5110000056000000005"); 
				daily_map5.put("explorationMethod", explorationMethod);
		 
				daily_map5.put("name", mapOrg.get("codingName"));
				listM.add(daily_map5);
		    }
 			if(mapOrg.get("superiorCodeId").equals("5110000056000000006")){
				Map daily_map6=null;
		    	daily_map6=new HashMap();
				daily_map6 = jdbcDao.queryRecordBySQL(sqlSub);
				daily_map6.put("exmethod", "5110000056000000006");
				daily_map6.put("explorationMethod", explorationMethod);
				 
				daily_map6.put("name", mapOrg.get("codingName"));
				listM.add(daily_map6);
					 
				}
			}
		}
	return listM;
	}
	private double round(double d, int i) {
		// TODO Auto-generated method stub
		return 0;
	}

	public ISrvMsg getDailyReportInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String produceDate = (String) reqDTO.getValue("produceDate");
		// Map temp = reqDTO.toMap();

		Map map1 = new HashMap();
		map1.put("produceDate", produceDate);

		map1.put("projectInfoNo", projectInfoNo);

		Map map2 = new HashMap();
		map2.put("produceDate", produceDate);

		map2.put("projectInfoNo", projectInfoNo);

		Map map = new HashMap();
		map.put("produceDate", produceDate);

		map.put("projectInfoNo", projectInfoNo);

		Map dailyProject = getDailyProject(map1);
		Map build = getDailyReportNew(map);
		Map sumDaily = getDailySum(map2);

		msg.setValue("build", build);
		msg.setValue("dailyProject", dailyProject);
		msg.setValue("sumDaily", sumDaily);

		return msg;
	}

	private Map getDailySum(Map map2) {
		// TODO Auto-generated method stub

		String projectInfoNo = (String) map2.get("projectInfoNo");
		String produceDate = (String) map2.get("produceDate");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map2.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map2.get("produce_date");
		}

		String sql = "select sum(nvl(DAILY_SURVEY_POINT_NUM_WS,0)) as project_survey_shot_num "
				+ ",sum(nvl(r.DAILY_SURFACE_POINT_NUM,0)) as project_survey_geophone_num "
				+ ",sum(nvl(r.DAILY_DRILL_SP_NUM,0)) as project_survey_incept_workload "
				+ ",sum(nvl(r.DRILL_SHOT_WORKLOAD_WS,0)) as project_survey_shot_workload "
				+ ",sum(nvl(r.DAILY_ACQUIRE_SP_NUM,0)) as project_survey_total_workload "
				+ ",sum(nvl(r.DAILY_ACQUIRE_QUALIFIED_NUM,0)) as project_micro_measue_num"
				+ " from gp_ops_daily_report_ws r where r.AUDIT_STATUS = '3' and project_info_no='"
				+ projectInfoNo + "'";

		Map dailyNum = new HashMap();
		dailyNum = jdbcDao.queryRecordBySQL(sql);

		return dailyNum;
	}

	private Map getDailyProject(Map map1) {
		// TODO Auto-generated method stub

		String projectInfoNo = (String) map1.get("projectInfoNo");
		String produceDate = (String) map1.get("produceDate");

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map1.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map1.get("produce_date");
		}

		String sql = "select * from gp_task_project_dynamic where project_info_no='"
				+ projectInfoNo + "'";

		Map dailyProject = new HashMap();
		dailyProject = jdbcDao.queryRecordBySQL(sql);

		return dailyProject;

	}
	public List  getExplorationUnit(String projectInfoNo,String productDate) throws Exception{
		List list=getExplorationByDate(projectInfoNo,productDate);
		String method="";
		List orgList=new ArrayList();
		Map mapOrg=new HashMap();
		Map maptt=new HashMap();
		Map map=new HashMap();
	   Map mapU=new HashMap();
		for(int i=0;i<list.size();i++){
			maptt=(Map)list.get(i);
			method=(String)maptt.get("explorationMethod");
     if(!method.equals("5110000056000000045")){
    	 String sql="select   t.coding_name,t.superior_code_id  FROM comm_coding_sort_detail t " +
			" WHERE t.coding_sort_id = '5110000056'   and t.bsflag = '0' " +
			"and t.coding_code_id='"+method+"'";

	String sql1="select a.line_unit   from gp_wt_workload a where a.project_info_no = '"+projectInfoNo+"' and   a.exploration_method='"+method+"'";
	map=jdbcDao.queryRecordBySQL(sql);
	mapU=jdbcDao.queryRecordBySQL(sql1);
	if(map!=null){
		map.put("method", method);
		mapOrg.put("exploration_method_name"+i, map.get("codingName"));
		mapOrg.put("super_id"+i, map.get("superiorCodeId"));
		mapOrg.put("exploration_method"+i, map.get("method"));
		
		mapOrg.put("method"+i,mapU.get("lineUnit"));
		orgList.add(mapOrg);
	}
     }
			
			
			 
	 
		
			 
	
		
		}
	
		return orgList;			
	}

	/**
	 * ��ȡ��Ŀ��ʩ������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectTeamName(ISrvMsg reqDTO) throws Exception{
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
 
		
		//������鶼��һ����¼��,����
		  ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
	      String getTeamSql = "select d.org_id from gp_task_project_dynamic d where d.bsflag = '0' and d.project_info_no = '"+projectInfoNo+"'";
	      Map projectInfoMap = radDao.queryRecordBySQL(getTeamSql);
	      if(projectInfoMap != null){
	    	  String teamName = "";
	    	  String orgIdParmas = "";
	    	  String orgId = projectInfoMap.get("org_id").toString();
	    	  String[] orgIds = orgId.split(",");
	    	  int orgLength = orgIds.length;
	    	  if(orgLength == 1){
	    		  String getTeamNameSlq = "select i.org_name from comm_org_information i where i.bsflag = '0' and i.org_id = '"+orgId+"'";
	    		  Map teamNameMap = radDao.queryRecordBySQL(getTeamNameSlq);
	    		  if(teamNameMap != null){
	    			  teamName = teamNameMap.get("org_name").toString();
	    		  }
	    	  }else if(orgLength >= 2){
	    		  for(int i=0;i<orgLength;i++){
	    			  orgIdParmas += ",'"+orgIds[i]+"'";
	    		  }
	    		  orgIdParmas = orgIdParmas.substring(1, orgIdParmas.length());
	    		  String getTeamNameSlq = "select wm_concat(i.org_abbreviation) as teams from comm_org_information i where i.bsflag = '0' and i.org_id in ("+orgIdParmas+")";
	    		  Map teamNameMap = radDao.queryRecordBySQL(getTeamNameSlq);
	    		  if(teamNameMap != null){
	    			  teamName = teamNameMap.get("teams").toString();
	    		  }
	    	  }
	    	  
	      	msg.setValue("teamName", teamName);
	      }
		
        return msg;
	}


	public List  getExplorationName(String projectInfoNo,String produceDate) throws Exception{
		List list=getExplorationByDate(projectInfoNo, produceDate) ;
		String method="";
		List orgList=new ArrayList();
		Map mapOrg=new HashMap();
		Map maptt=new HashMap();
		Map map=new HashMap();
	
		for(int i=0;i<list.size();i++){
			maptt=(Map)list.get(i);
			
			method=(String)maptt.get("explorationMethod");
             if(!method.equals("5110000056000000045")){
            		String sql="select   t.coding_name,t.superior_code_id  FROM comm_coding_sort_detail t " +
					" WHERE t.coding_sort_id = '5110000056'   and t.bsflag = '0' " +
					"and t.coding_code_id='"+method+"'";
  
			map=jdbcDao.queryRecordBySQL(sql);
			map.put("method", method);
			 
	 
			mapOrg.put("exploration_method_name"+i, map.get("codingName"));
			mapOrg.put("super_id"+i, map.get("superiorCodeId"));
			mapOrg.put("exploration_method"+i, map.get("method"));
			 
	
		orgList.add(mapOrg);
             }
		
		}
	
		return orgList;			
	}
public List  getOrgId(String projectInfoNo) throws Exception{
		List list=getExplorationMethod(projectInfoNo);
		String method="";
		List orgList=new ArrayList();
		Map mapOrg=new HashMap();
		Map maptt=new HashMap();
		Map map=new HashMap();
	
		for(int i=0;i<list.size();i++){
			maptt=(Map)list.get(i);
			method=(String)maptt.get("explorationMethod");
			 
			if(!method.equals("5110000056000000045")){
				String sql="select   t.coding_name  FROM comm_coding_sort_detail t " +
				" WHERE t.coding_sort_id = '5110000056'   and t.bsflag = '0' " +
				"and t.coding_code_id='"+method+"'";

		map=jdbcDao.queryRecordBySQL(sql);
		map.put("method", method);
 
		mapOrg.put("exploration_method_name"+i, map.get("codingName"));
		mapOrg.put("exploration_method"+i, map.get("method"));
		 

    	orgList.add(mapOrg);
			}
			
		}
	
		return orgList;
	}

public Map getListForFields(String projectInfoNo) throws Exception {
		Map mapFields = new HashMap();
		List<Map> list = (List) getExplorationMethod(projectInfoNo);

		for (int i = 0; i < list.size(); i++) {

			Map map = list.get(i);

			mapFields.put("exploration_method_name"+i, "avgz" + i);
			mapFields.put("exploration_method"+i,"sum"+i);
		}
		return mapFields;
}

	public List getExplorationByDate(String projectInfoNo,String produceDate) throws Exception {
		String sql="select * from gp_ops_daily_report_zb b where b.project_info_no='"
			+ projectInfoNo + "' and b.bsflag='0' and b.exploration_method!='5110000056000000045' and b.produce_date = to_date('"+produceDate+"', 'yyyy-mm-dd')";
		List<Map> list = (List) jdbcDao.queryRecords(sql);
		return list;
	}
public static void main(String[] args) {
	 WtDailyReportSrv wd=new WtDailyReportSrv();
	 try {
		List list=wd.getExplorationByDate("8ad878dd42c062570142c0a039df00ba", "2014-02-14");
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
}




	Map getDailyReportNew(Map map1) {
		// TODO Auto-generated method stub

		String projectInfoNo = (String) map1.get("projectInfoNo");
		String produceDate = (String) map1.get("produceDate");

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map1.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map1.get("produce_date");
		}

		String sql = "select * from gp_ops_daily_report_wt where project_info_no='"
				+ projectInfoNo
				+ "' and  bsflag='0' and produce_date = to_date('"
				+ produceDate + "','yyyy-MM-dd')";

		Map build = new HashMap();
		build = jdbcDao.queryRecordBySQL(sql);

		return build;
	}
	
	public ISrvMsg getDailyReportDate(ISrvMsg  reqDTO) throws SOAPException {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String produceDate = (String) reqDTO.getValue("produceDate");


		String sql = "select * from gp_ops_daily_report_wt where project_info_no='"
				+ projectInfoNo
				+ "' and bsflag='0' and produce_date = to_date('"
				+ produceDate + "','yyyy-MM-dd')";

		Map build = new HashMap();
		build = jdbcDao.queryRecordBySQL(sql);
       msg.setValue("build", build);
		return msg;
	}


	public List getDaiyMethodUcm(String projectInfoNo,String produceDate)throws Exception{

		//ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
	//	String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
	//	String produceDate = (String) reqDTO.getValue("produceDate");
	//	String explorationmethod = reqDTO.getValue("exploration_method");
	//	String dailynowt = reqDTO.getValue("daily_no_wt");
		
			
		String sql = "SELECT * FROM gp_ops_daily_report_zb where project_info_no='"+projectInfoNo+"'"+
			 "and BSFLAG='0' and EXPLORATION_METHOD!='5110000056000000045' and status='3' and PRODUCE_DATE=to_date('"
				+ produceDate + "','yyyy-MM-dd')";
		Map build = new HashMap();
		//build = jdbcDao.queryRecordBySQL(sql);
		List<Map> list = (List) jdbcDao.queryRecords(sql);
		List<Map> ucmList = new ArrayList<Map>();
		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		if(list!=null&&list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = list.get(i);
				String ucmId = (String) map.get("uploadFileUcmdocid");
				String expMethod = (String)map.get("explorationMethod");
				if(ucmId!=null&!"".equals(ucmId)){
					String imageName = myUcm.getDocTitle(ucmId);
					String imagePath = myUcm.getDocUrl(ucmId);
					Map ucmMap = new HashMap<String, String>();
					ucmMap.put("ucmId", ucmId);
					ucmMap.put("imageName", imageName);
					ucmMap.put("imagePath", imagePath);
					ucmMap.put("expMethod", expMethod);
					
					ucmList.add(ucmMap);
				}
			}
		}

	//	msg.setValue("ucmList", ucmList);
		return ucmList;

	}
	
	public Map getDailyReportBy(Map map) {

		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
        String exploration=(String) map.get("exploration_method");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map.get("produce_date");
		}
       
		String sql = "select * from gp_ops_daily_report_zb where project_info_no='"
				+ projectInfoNo
				+ "' and  produce_date = to_date('"
				+ produceDate + "','yyyy-MM-dd') and bsflag='0' and exploration_method='"+exploration+"'";

		Map dailyReport = new HashMap();
		dailyReport = jdbcDao.queryRecordBySQL(sql);
//a

		return dailyReport;
	}

	public Map getDailyReportProduceSit(Map map) {

		Object daily_no = map.get("dailyNo");
		Object project_info_no = map.get("projectInfoNo");
		Object produce_date = map.get("produceDate");
		Object difference = map.get("difference");

		if (difference == null || "".equals(difference)) {
			difference = "0";
		}

		String sql = null;

		if (produce_date != null && !"".equals(produce_date)
				&& produce_date != "null" && !"null".equals(produce_date)) {
			sql = "select sit.* from gp_ops_daily_produce_sit sit join gp_ops_daily_report r on r.daily_no = sit.daily_no and r.project_info_no = '"
					+ project_info_no
					+ "' and produce_date = to_date('"
					+ produce_date
					+ "','yyyy-MM-dd')-"
					+ difference
					+ " "
					+ " and r.bsflag = '0'  where sit.bsflag = '0' ";
		} else {
			sql = "select * from gp_ops_daily_produce_sit where bsflag = '0'  and daily_no = '"
					+ daily_no + "'";
		}

		Map report = jdbcDao.queryRecordBySQL(sql);
		return report;
	}

	public Map getNextDailyReportStatus(Map map) {

		Object daily_no = map.get("dailyNo");
		Object project_info_no = map.get("projectInfoNo");
		Object produce_date = map.get("produceDate");
		Object difference = map.get("difference");

		if (difference == null || "".equals(difference)) {
			difference = "0";
		}

		String sql = null;

		if (produce_date != null && !"".equals(produce_date)
				&& produce_date != "null" && !"null".equals(produce_date)) {
			sql = "select sit.* from gp_ops_daily_produce_sit sit join gp_ops_daily_report r on r.daily_no = sit.daily_no and r.project_info_no = '"
					+ project_info_no
					+ "' and produce_date = to_date('"
					+ produce_date
					+ "','yyyy-MM-dd')+"
					+ difference
					+ " "
					+ " and r.bsflag = '0'  where sit.bsflag = '0' ";
		} else {
			sql = "select * from gp_ops_daily_produce_sit where bsflag = '0'  and daily_no = '"
					+ daily_no + "'";
		}

		Map report = jdbcDao.queryRecordBySQL(sql);
		return report;
	}

	public List getExplorationMethod(String projectInfoNo) throws Exception {
// 	         String sql = "select * from (select a.line_unit, (select case b.superior_code_id  when '0' then   b.coding_code_id"+
//	         " else  b.superior_code_id end from comm_coding_sort_detail b  where b.coding_code_id = a.exploration_method"+
//	         " and a.exploration_method = b.coding_code_id and a.bsflag = '0') as uu from gp_wt_workload a"+
//	         " where a.project_info_no = '"+projectInfoNo+"') pp  where pp.uu in (select distinct (exploration_method)"+
//	         " from gp_ops_daily_report_zb b where b.project_info_no = '"+projectInfoNo+"'  and b.bsflag = '0')";
//		
		
		
		String sql="select distinct(exploration_method) from gp_ops_daily_report_zb b where b.project_info_no='"
			+ projectInfoNo + "' and  b.bsflag='0' and b.exploration_method!='5110000056000000045'";
		List<Map> list = (List) jdbcDao.queryRecords(sql);
		return list;
	}
	public List getDailyU(String projectInfoNo) throws Exception {
		  String sql = " select a.line_unit ,a.exploration_method   from gp_wt_workload a"+
        " where a.project_info_no = '"+projectInfoNo+"'";
			List<Map> list = (List) jdbcDao.queryRecords(sql);
			return list;
	}
	public ISrvMsg getFileList(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = user.getProjectInfoNo();
		String fild_status =reqDTO.getValue("fild_status");

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			msg.setValue("totalRows", 0);
			return msg;
		}

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
 		String sql="select * from file_checkaccept  t where t.bsflag='0' and t.project_info_no='"+projectInfoNo+"' and t.fild_status='"+fild_status+"'";
		
		page = radDao.queryRecordsBySQL(sql, page);

		 

		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);

		return msg;

 		
	}
	/**
	 * �����ձ�����Ŀ�б��ѯ����������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDailyReportLength(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String multi_flag = reqDTO.getValue("multi") != null ? reqDTO
				.getValue("multi") : "";
				String projectInfoNo = user.getProjectInfoNo();
				String explorationMthod = user.getExplorationMethod();

				System.out.println("����Ŀ���ձ��б�" + projectInfoNo + "��̽����"
						+ explorationMthod);
				if (projectInfoNo == null || "".equals(projectInfoNo)) {
					msg.setValue("totalRows", 0);
					return msg;
				}

				String currentPage = reqDTO.getValue("currentPage");
				if (currentPage == null || currentPage.trim().equals(""))
					currentPage = "1";
				String pageSize = reqDTO.getValue("pageSize");
				if (pageSize == null || pageSize.trim().equals("")) {
					ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
					pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
				}
//d.LINE_LENGTH
				PageModel page = new PageModel();
				page.setCurrPage(Integer.parseInt(currentPage));
				page.setPageSize(Integer.parseInt(pageSize));
				 List<Map> list=(List)getExplorationMethod(projectInfoNo);
				 if(list.size()!=0){
					 
				 
				 StringBuffer sql = new StringBuffer("select * from (select date1,");
				  for (int i = 0; i <list.size(); i++) {
					  
				 Map map=list.get(i);

				 sql.append("sum(decode(explorationMethod, '"+map.get("explorationMethod")+"', tt , 0)) avgz"+i+","+//avgz+i--- �������ٷֱ�
	      "sum(decode(explorationMethod, '"+map.get("explorationMethod")+"', yy , 0)) sum"+i+" ");//�ۼƹ�����
				 if(i!=list.size()-1){
					 sql.append(",");
				 }
				  }
	  sql.append("  from (   ");
	  for (int i = 0; i <list.size(); i++) {
			 Map map=list.get(i);
				 if(i>0){
					 sql.append(" union ");
				 }
			sql.append(" select date1,    round (decode(cl"+i+".LINE_LENGTH,0,0,a.aaa / cl"+i+".LINE_LENGTH) * 100 ,2)as tt, a.aaa as yy, a.explorationMethod from (select distinct (c.produce_date) date1,"+
					         " sum(c.DAILY_WORKLOAD) over(partition by c.exploration_method order by c.produce_date) aaa,"+
					         " c.exploration_method explorationMethod from gp_ops_daily_report_zb c where c.bsflag='0' and c.STATUS='3' and c.project_info_no = '"+projectInfoNo+"'"+
					         " and c.exploration_method = '"+map.get("explorationMethod")+"') a,  (select a.LINE_LENGTH,  a.exploration_method from gp_wt_workload a "+
	 "where a.project_info_no = '"+projectInfoNo+"'     and a.exploration_method='"+map.get("explorationMethod")+"') cl"+i+"  "	   );
	 
				  }
	  sql.append( "  )group by date1 order by date1" +
				 " ) inf , gp_ops_daily_report_wt wt where inf.date1 = wt.produce_date and wt.project_info_no = '"+projectInfoNo+"' and wt.bsflag='0' order by date1 desc");
				  System.out.println(sql);
				
					 
				 
				 
					page = radDao.queryRecordsBySQL(sql.toString(), page);
					
					List ls = page.getData();
					
					Map mapFields = getListForFields(projectInfoNo);
					
					
					Map mapTemp = new HashMap();
					
						for(int j=0; j<ls.size(); j++){
							Map mapVL = (Map)ls.get(j);
							
							for(int i=0;i<list.size(); i++){
								String vlName = (String)mapFields.get("exploration_method"+i);
								String valueBai=(String)mapFields.get("exploration_method_name"+i);
								
								String value = (String)mapVL.get(vlName);		
								String vl=(String)mapVL.get(valueBai);
					
								if(("0").equals(value) && mapTemp.get(vlName) !=null){ 
									mapVL.put(vlName, mapTemp.get(vlName));
									mapVL.put(valueBai, mapTemp.get(valueBai));
								}
							}
							
							mapTemp = mapVL;
	
						}


					msg.setValue("datas", ls);
					msg.setValue("totalRows", page.getTotalRow());
					msg.setValue("pageSize", pageSize);
				 }
		return msg;
	}
	/**
	 * �����ձ��б��ѯ������㣩
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDailyReportList(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String multi_flag = reqDTO.getValue("multi") != null ? reqDTO
				.getValue("multi") : "";
		if ("2" == multi_flag || "2".equals(multi_flag)) {
			// ����Ŀ���ձ��б�,��Ŀ��Ŵ�ǰ̨��,��ѯ��Ҫ����������
			String projectInfoNo = reqDTO.getValue("projectInfoNo") != null ? reqDTO
					.getValue("projectInfoNo") : "";

			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				msg.setValue("totalRows", 0);
				return msg;
			}

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

			 String sql="";
			page = radDao.queryRecordsBySQL(sql, page);

			msg.setValue("datas", page.getData());
			msg.setValue("totalRows", page.getTotalRow());
			msg.setValue("pageSize", pageSize);

		} else {

			// ����Ŀ���ձ��б�
			String projectInfoNo="";
			if ("1" == multi_flag || "1".equals(multi_flag)) {
				// ����Ŀ���ձ��б�,��Ŀ��Ŵ�ǰ̨��,��ѯ��Ҫ����������
				  projectInfoNo = reqDTO.getValue("projectInfoNo") != null ? reqDTO.getValue("projectInfoNo") : "";

				}else{
					   projectInfoNo = user.getProjectInfoNo();
				}
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				msg.setValue("totalRows", 0);
				return msg;
			}
		
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

			 List<Map> list=(List)getExplorationMethod(projectInfoNo);
			 if(list.size()!=0){
				StringBuffer sql = new StringBuffer("select * from (select date1,");
				 for (int i = 0; i <list.size(); i++) {
					 Map map=list.get(i);
				sql.append("sum(decode(explorationMethod, '"+map.get("explorationMethod")+"', tt , 0)) avgz"+i+","+//avgz+i--- �������ٷֱ�
						"sum(decode(explorationMethod, '"+map.get("explorationMethod")+"', yy , 0)) sum"+i+" ");//�ۼƹ�����
						if(i!=list.size()-1){
							 sql.append(",");
						 }
				 }
			  sql.append("  from (   ");
			  for (int i = 0; i <list.size(); i++) {
					 Map map=list.get(i);
						 if(i>0){
							 sql.append(" union ");
						 }
					sql.append(" select date1,    round (decode(cl"+i+".location_point,0,0,a.aaa / cl"+i+".location_point)* 100,2)  as tt, a.aaa as yy, a.explorationMethod from (select distinct (c.produce_date) date1,"+
							         " sum(c.daily_coordinate_point) over(partition by c.exploration_method order by c.produce_date) aaa,"+
							         " c.exploration_method explorationMethod from gp_ops_daily_report_zb c where c.bsflag='0' and c.project_info_no = '"+projectInfoNo+"'"+
							         " and c.exploration_method = '"+map.get("explorationMethod")+"') a,  (select a.location_point,  a.exploration_method from gp_wt_workload a "+
			 "where a.project_info_no = '"+projectInfoNo+"'     and a.exploration_method='"+map.get("explorationMethod")+"') cl"+i+"  "	   );
			 
			}
			  sql.append( "  )group by date1 order by date1 desc" +
						 " ) inf   left join gp_ops_daily_report_wt wt on inf.date1 = wt.produce_date where wt.project_info_no = '"+projectInfoNo+"' and wt.bsflag='0' order by wt.produce_date desc");
			System.out.println(sql);
						
							 
						 
						 
							page = radDao.queryRecordsBySQL(sql.toString(), page);
							
							List ls = page.getData();
							
//							Map mapFields = getListForFields(projectInfoNo);
//							
//							
//							Map mapTemp = new HashMap();
//							
//								for(int j=0; j<ls.size(); j++){
//									Map mapVL = (Map)ls.get(j);
//									
//									for(int i=0;i<list.size(); i++){
//										String vlName = (String)mapFields.get("exploration_method"+i);
//										String valueBai=(String)mapFields.get("exploration_method_name"+i);
//										
//										String value = (String)mapVL.get(vlName);		
//										String vl=(String)mapVL.get(valueBai);
//							
//										if(("").equals(value) && mapTemp.get(vlName) !=null){ 
//											mapVL.put(vlName, mapTemp.get(vlName));
//											mapVL.put(valueBai, mapTemp.get(valueBai));
//										}
//									}
//									
//									mapTemp = mapVL;
//			
//								}


							msg.setValue("datas", ls);
							msg.setValue("totalRows", page.getTotalRow());
							msg.setValue("pageSize", pageSize);
			 }else{
				 String sql="   select * from gp_ops_daily_report_wt t where t.project_info_no='"+projectInfoNo+"' and t.bsflag='0' order by t.produce_date desc";
					page = radDao.queryRecordsBySQL(sql, page);

					msg.setValue("datas", page.getData());
					msg.setValue("totalRows", page.getTotalRow());
					msg.setValue("pageSize", pageSize);
			 }

		}
		return msg;
	}

	public String getBuildMethod(String projectInfoNo) throws Exception {

		String build_method = "";
		String get_build_method = "select p.build_method from gp_task_project p where p.bsflag = '0' and p.project_info_no = '"
				+ projectInfoNo + "'";
		if (jdbcDao.queryRecordBySQL(get_build_method) != null) {
			build_method = jdbcDao.queryRecordBySQL(get_build_method)
					.get("buildMethod").toString();
		}
		return build_method;
	}
	
	
	 

	public ISrvMsg submitDailyReport(ISrvMsg reqDTO) throws Exception {

		String dailyNo = reqDTO.getValue("dailyNo");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String produceDate = reqDTO.getValue("produceDate");
		String auditStatus = reqDTO.getValue("audit_status");		
	 
		if (dailyNo == null || "".equals(dailyNo) || dailyNo == "null"
				|| "null".equals(dailyNo)||"undefined".equals(dailyNo)) {

			Map map = new HashMap();
			map.put("projectInfoNo", projectInfoNo);
			map.put("produceDate", produceDate);
			Map daily = this.getDailyReportNew(map);
			dailyNo = (String) daily.get("dailyNoWt");
		}

		UserToken user = reqDTO.getUserToken();

		Map map = reqDTO.toMap();
		map.put("updator", user.getUserName());
		map.put("modifi_date", new Date());
		map.put("submit_status", "2");
		map.put("audit_status", auditStatus);
		map.put("daily_no_wt", dailyNo);

		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
				"gp_ops_daily_report_wt");

	 

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}

	public ISrvMsg auditDailyReport(ISrvMsg reqDTO) throws Exception {
		String dailyNo = reqDTO.getValue("dailyNo");
		String auditStatus = reqDTO.getValue("audit_status");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String audit_opinion = reqDTO.getValue("audit_opinion");
		// String orgId = reqDTO.getValue("orgId");

		String sql = "select * from gp_task_project where project_info_no = '"
				+ projectInfoNo + "' ";

		Map project = jdbcDao.queryRecordBySQL(sql);

		UserToken user = reqDTO.getUserToken();

		Map map = reqDTO.toMap();
		map.put("updator", user.getEmpId());
		map.put("audit_date", new Date());
		map.put("daily_no", dailyNo);
		// map.put("org_id", orgId);
		map.put("modifi_date", new Date());
		map.put("audit_status", auditStatus);
		map.put("ratifier", user.getEmpId());

		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
				"gp_ops_daily_report");

		if (audit_opinion != null && !"".equals(audit_opinion)) {
			sql = "select * from gp_adm_data_examine where data_no = '"
					+ dailyNo + "'  and bsflag = '0' ";

			Map temp = new HashMap();
			Map examine = jdbcDao.queryRecordBySQL(sql);
			if (examine != null) {
				temp.put("data_examine_no", examine.get("dataExamineNo"));
				temp.put("project_info_no", projectInfoNo);
				temp.put("data_no", dailyNo);
				temp.put("audit_date", new Date());
				temp.put("audit_opinion", audit_opinion);
				temp.put("bsflag", "0");
			} else {
				temp.put("project_info_no", projectInfoNo);
				temp.put("data_no", dailyNo);
				temp.put("audit_date", new Date());
				temp.put("audit_opinion", audit_opinion);
				temp.put("bsflag", "0");
			}

			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(temp,
					"gp_adm_data_examine");
		}

		// ����ͨ�� �����ձ�״̬�޸���Ŀ״̬
		if (auditStatus != null && auditStatus.equals("3")) {
			if (map.get("if_build") != null
					&& "4".equals((String) map.get("if_build"))) {
				if ("5000100001000000001".equals((String) project
						.get("projectStatus"))) {
					// ���� �ĳ���Ŀ����
					map.put("project_status", "5000100001000000002");
					map.put("project_info_no", projectInfoNo);
					map.put("modifi_date", new Date());

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
							"gp_task_project");
				}
			} else if (map.get("if_build") != null
					&& "6".equals((String) map.get("if_build"))) {
				// �ɼ�
				map.put("ifBuild", "6");
				map.put("flag", "min");

				Map report = this.getDailyReportByStatus(map);
				if (report != null) {
					map.put("project_start_time", report.get("produceDate"));
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
							"gp_task_project");
				}
			} else if (map.get("if_build") != null
					&& "9".equals((String) map.get("if_build"))) {
				// ����
				map.put("ifBuild", "9");
				map.put("flag", "max");

				Map report = this.getDailyReportByStatus(map);
				if (report != null) {
					map.put("project_end_time", report.get("produceDate"));
					map.put("project_status", "5000100001000000005");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
							"gp_task_project");
				}
			} else if (map.get("if_build") != null
					&& "8".equals((String) map.get("if_build"))) {
				// ��ͣ
				map.put("project_status", "5000100001000000004");
				map.put("modifi_date", new Date());
				map.put("project_info_no", projectInfoNo);

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
						"gp_task_project");
				}
			map.clear();
			// map.put("produceDate", value)
			map.put("userId", user.getEmpId());
			map.put("userName", user.getUserName());

			sql = "select * from gp_ops_daily_report where daily_no = '"
					+ dailyNo + "' ";

			Map daily = jdbcDao.queryRecordBySQL(sql);

			map.put("projectInfoNo", projectInfoNo);
			map.put("produceDate", daily.get("produceDate"));

			// ����ͨ���Ժ�ѹ����������ı���ֵ�ÿ�
			String update = "update bgp_p6_workload set actual_this_period_units = '0',modifi_date = sysdate where project_info_no = '"
					+ projectInfoNo + "' and bsflag = '0'";
			// radDao.getJdbcTemplate().update(update);

			// �ձ������ز��� ���ÿձ���ֵ ����ͨ��ʱ����ÿ�յĹ����������¼���ۼ�ֵ
			update = "select p.project_object_id,sum(nvl(p.actual_this_period_units,0)) as actual_this_period_units,p.activity_object_id,p.resource_object_id from bgp_p6_workload p join gp_ops_daily_report r  on r.project_info_no = p.project_info_no and r.produce_date = p.produce_date "
					+ "and r.produce_date <= to_date('"
					+ daily.get("produceDate")
					+ "','yyyy-MM-dd') and r.project_info_no = '"
					+ projectInfoNo
					+ "' and r.bsflag = '0' where p.bsflag = '0' group by p.project_object_id,p.activity_object_id,p.resource_object_id ";

			List<Map> list = jdbcDao.queryRecords(update);
			if (list != null && list.size() != 0) {
				for (int i = 0; i < list.size(); i++) {
					Map temp = list.get(i);
					update = "update bgp_p6_workload set actual_units = '"
							+ temp.get("actualThisPeriodUnits")
							+ "' where project_info_no = '" + projectInfoNo
							+ "' and activity_object_id = '"
							+ temp.get("activityObjectId")
							+ "' and resource_object_id = '"
							+ temp.get("resourceObjectId")
							+ "'  and produce_date is null ";
					radDao.getJdbcTemplate().update(update);
				}
			}

			update = "update bgp_p6_assign_mapping set submit_flag = '"
					+ auditStatus
					+ "',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"
					+ projectInfoNo + "') and bsflag = '0'";
			radDao.getJdbcTemplate().update(update);

			update = "update bgp_p6_activity set submit_flag = '"
					+ auditStatus
					+ "',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"
					+ projectInfoNo + "') and bsflag = '0' ";

			radDao.getJdbcTemplate().update(update);

			AuditDailyReportThread thread = new AuditDailyReportThread(map);
			thread.start();
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("dailyNo", dailyNo);
		msg.setValue("projectInfoNo", projectInfoNo);

		return msg;
	}

	public Map getDailyReportByStatus(Map map) {
		String ifBuild = (String) map.get("ifBuild");
		String flag = (String) map.get("flag");
		String projectInfoNo = (String) map.get("projectInfoNo");
		String orgId = (String) map.get("orgId");

		String sql = "select * from gp_ops_daily_report t,gp_ops_daily_produce_sit sit where t.project_info_no = '"
				+ projectInfoNo
				+ "' and sit.daily_no = t.daily_no and sit.if_build = '"
				+ ifBuild
				+ "' "
				+ " and t.audit_status = '3'  and t.bsflag = '0'";

		if (orgId != null && !"".equals(orgId)) {
			sql += " and t.rog_id = '" + orgId + "' ";
		}

		sql += " order by t.produce_date ";

		if (flag == "max" || "max".equals(flag)) {
			sql += "desc";
		}

		Map report = jdbcDao.queryRecordBySQL(sql);

		return report;
	}

	public ISrvMsg saveOrUpdateDailyView(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		Map<String,Object> map5 = reqDTO.toMap();
	
	  // String weather=reqDTO.getValue("viewWeather");
	   //String ifBuild=reqDTO.getValue("build");
	   //map.put("weather", weather);//����
      //map.put("if_build",ifBuild );//��Ŀ״̬
		String projectInfoNo=user.getProjectInfoNo();
	    String produce_date=reqDTO.getValue("produce_date");//��������
	    
	   
	   
	  List list=  getExploration(projectInfoNo, produce_date);
	  for(int i=0;i<list.size();i++){
			Map  map = new HashMap();
			 map.put("projectInfoNo",projectInfoNo);
				map.put("produce_date", produce_date);//��������
					map.put("create_date", new Date());//¼������
				
		  Map mapEx=(Map) list.get(i);
			map.put("exploration_method", mapEx.get("explorationMethod"));
			  Map  map1=getDailyReportBy(map);
	   		    String dailyId=	(String) map1.get("dailyReportId");
	   			map.put("daily_report_id", dailyId);
		  if( mapEx.get("explorationMethod").equals("5110000056000000045")){
   		    //----------------------------------//����
			
   			map.put("daily_gps_control_point", reqDTO.getValue("gpscon1"));
   			map.put("daily_coordinate_point", reqDTO.getValue("gpscon2"));
   			map.put("daily_measurement_point", reqDTO.getValue("gpscon3"));
   			map.put("daily_terrain_correct_point", reqDTO.getValue("gpscon4"));
   			map.put("daily_tc_check_point", reqDTO.getValue("gpscon5"));
   			
   			//--------------------------------------����
   			
   			
   			
   		
   			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report_zb");
   		}else{
   			String sql1="select   t.coding_name,t.superior_code_id  FROM comm_coding_sort_detail t " +
			" WHERE t.coding_sort_id = '5110000056'   and t.bsflag = '0' " +
			"and t.coding_code_id='"+ mapEx.get("explorationMethod")+"'";

 		Map mapOrg=jdbcDao.queryRecordBySQL(sql1);
 		
 		if(mapOrg.get("superiorCodeId").equals("5110000056000000001")){
			 //����
 			String workLoad= reqDTO.getValue("base12"+mapEx.get("explorationMethod").toString());
 		
 			System.out.print(workLoad);
 		 
 			map.put("daily_workload", workLoad); //�չ�����
 			String se=mapEx.get("explorationMethod").toString();
 			map.put("daily_coordinate_point", reqDTO.getValue("base14"+mapEx.get("explorationMethod").toString())); //�������
 	
 			map.put("daily_check_point", reqDTO.getValue("base10"+mapEx.get("explorationMethod").toString())); //�ռ���
 			map.put("DAILY_PHYSICAL_POINT", reqDTO.getValue("base13"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_rework_point", reqDTO.getValue("base9"+mapEx.get("explorationMethod").toString())); //�շ�����
 			map.put("daily_first_grade", reqDTO.getValue("base8"+mapEx.get("explorationMethod").toString())); //��һ��Ʒ
 			map.put("daily_conforming_products", reqDTO.getValue("base7"+mapEx.get("explorationMethod").toString())); //�պϸ�Ʒ
 			map.put("daily_basic_point", reqDTO.getValue("base11"+mapEx.get("explorationMethod").toString())); //�ջ���
 			map.put("daily_non_conforming_products", reqDTO.getValue("base6"+mapEx.get("explorationMethod").toString())); //�շ�Ʒ
 			map.put("DAILY_NULL_POINT", reqDTO.getValue("base5"+mapEx.get("explorationMethod").toString())); //�տյ�
  
 			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report_zb");
		}
		
	   
			if(mapOrg.get("superiorCodeId").equals("5110000056000000002")){
				map.put("daily_workload",  reqDTO.getValue("load1"+mapEx.get("explorationMethod").toString())); //�չ�����
 			map.put("daily_coordinate_point", reqDTO.getValue("load2"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_check_point", reqDTO.getValue("load3"+mapEx.get("explorationMethod").toString())); //�ռ���
 			map.put("DAILY_PHYSICAL_POINT", reqDTO.getValue("load4"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_rework_point", reqDTO.getValue("load5"+mapEx.get("explorationMethod").toString())); //�շ�����
 			map.put("daily_first_grade", reqDTO.getValue("load6"+mapEx.get("explorationMethod").toString())); //��һ��Ʒ
 			map.put("daily_conforming_products", reqDTO.getValue("load7"+mapEx.get("explorationMethod").toString())); //�պϸ�Ʒ
 			map.put("daily_base_station", reqDTO.getValue("load8"+mapEx.get("explorationMethod").toString())); //�ձ�վ
 			map.put("daily_non_conforming_products", reqDTO.getValue("load9"+mapEx.get("explorationMethod").toString())); //�շ�Ʒ
 			map.put("daily_null_point", reqDTO.getValue("load10"+mapEx.get("explorationMethod").toString())); //�տյ�
 			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report_zb");
	    	 
	    }
			if(mapOrg.get("superiorCodeId").equals("5110000056000000003")){
				map.put("daily_workload",  reqDTO.getValue("cymethod"+mapEx.get("explorationMethod").toString())); //�չ�����
 			map.put("daily_coordinate_point", reqDTO.getValue("cymethod1"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_check_point", reqDTO.getValue("cymethod2"+mapEx.get("explorationMethod").toString())); //�ռ���
 			map.put("DAILY_PHYSICAL_POINT", reqDTO.getValue("cymethod3"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_rework_point", reqDTO.getValue("cymethod4"+mapEx.get("explorationMethod").toString())); //�շ�����
 			map.put("daily_first_grade", reqDTO.getValue("cymethod5"+mapEx.get("explorationMethod").toString())); //��һ��Ʒ
 			map.put("daily_conforming_products", reqDTO.getValue("cymethod6"+mapEx.get("explorationMethod").toString())); //�պϸ�Ʒ
 			map.put("DAILY_WELL_SOUNDING_POINT", reqDTO.getValue("cymethod7"+mapEx.get("explorationMethod").toString())); //���Բ����
 			map.put("daily_non_conforming_products", reqDTO.getValue("cymethod8"+mapEx.get("explorationMethod").toString())); //�շ�Ʒ
 			map.put("daily_null_point", reqDTO.getValue("cymethod9"+mapEx.get("explorationMethod").toString())); //�տյ�
 			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report_zb");
	    }
			if(mapOrg.get("superiorCodeId").equals("5110000056000000004")){
				map.put("daily_workload",  reqDTO.getValue("bw1"+mapEx.get("explorationMethod").toString())); //�չ�����
 			map.put("daily_coordinate_point", reqDTO.getValue("bw2"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_check_point", reqDTO.getValue("bw3"+mapEx.get("explorationMethod").toString())); //�ռ���
 			map.put("DAILY_PHYSICAL_POINT", reqDTO.getValue("bw4"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_rework_point", reqDTO.getValue("bw5"+mapEx.get("explorationMethod").toString())); //�շ�����
 			map.put("daily_first_grade", reqDTO.getValue("bw6"+mapEx.get("explorationMethod").toString())); //��һ��Ʒ
 			map.put("daily_conforming_products", reqDTO.getValue("bw7"+mapEx.get("explorationMethod").toString())); //�պϸ�Ʒ
 			map.put("daily_non_conforming_products", reqDTO.getValue("bw8"+mapEx.get("explorationMethod").toString())); //�շ�Ʒ
 			map.put("daily_null_point", reqDTO.getValue("bw9"+mapEx.get("explorationMethod").toString())); //�տյ�
 			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report_zb");
	    }
			if(mapOrg.get("superiorCodeId").equals("0")){
				map.put("daily_workload",  reqDTO.getValue("xumethod"+mapEx.get("explorationMethod").toString())); //�չ�����
 			map.put("daily_coordinate_point", reqDTO.getValue("xumethod1"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_check_point", reqDTO.getValue("xumethod2"+mapEx.get("explorationMethod").toString())); //�ռ���
 			map.put("DAILY_PHYSICAL_POINT", reqDTO.getValue("xumethod3"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_rework_point", reqDTO.getValue("xumethod4"+mapEx.get("explorationMethod").toString())); //�շ�����
 			map.put("daily_first_grade", reqDTO.getValue("xueFirst"+mapEx.get("explorationMethod").toString())); //��һ��Ʒ
 			map.put("daily_conforming_products", reqDTO.getValue("xumethod5"+mapEx.get("explorationMethod").toString())); //�պϸ�Ʒ
 			map.put("daily_non_conforming_products", reqDTO.getValue("xumethod6"+mapEx.get("explorationMethod").toString())); //�շ�Ʒ
 			map.put("daily_null_point", reqDTO.getValue("xumethod7"+mapEx.get("explorationMethod").toString())); //�տյ�
 			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report_zb");
	    }
			if(mapOrg.get("superiorCodeId").equals("5110000056000000006")){
		 
				map.put("daily_workload",  reqDTO.getValue("provalue"+mapEx.get("explorationMethod").toString())); //�չ�����
 			map.put("daily_coordinate_point", reqDTO.getValue("provalue1"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_check_point", reqDTO.getValue("provalue2"+mapEx.get("explorationMethod").toString())); //�ռ���
 			map.put("DAILY_PHYSICAL_POINT", reqDTO.getValue("provalue3"+mapEx.get("explorationMethod").toString())); //�������
 			map.put("daily_rework_point", reqDTO.getValue("provalue4"+mapEx.get("explorationMethod").toString())); //�շ�����
 			map.put("daily_first_grade", reqDTO.getValue("provalue5"+mapEx.get("explorationMethod").toString())); //��һ��Ʒ
 			map.put("daily_conforming_products", reqDTO.getValue("provalue6"+mapEx.get("explorationMethod").toString())); //�պϸ�Ʒ
 			map.put("daily_gravity_datum_point", reqDTO.getValue("provalue7"+mapEx.get("explorationMethod").toString())); //����������
 			map.put("daily_magnetism_base_station", reqDTO.getValue("provalue8"+mapEx.get("explorationMethod").toString())); //�մ����ձ�վ
 			map.put("daily_gravity_datum_point", reqDTO.getValue("provalue9"+mapEx.get("explorationMethod").toString())); //�վ��Բ����
 			map.put("daily_non_conforming_products", reqDTO.getValue("provalue10"+mapEx.get("explorationMethod").toString())); //�շ�Ʒ
 			map.put("daily_null_point", reqDTO.getValue("provalue11"+mapEx.get("explorationMethod").toString())); //�տյ�
 			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_report_zb");
			}
   		}

     		
			}
		 
	  
	   //------------------------------------  
	
		
	  
	
		 
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}
	public ISrvMsg saveOrUpdateDailyReport(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();

		String flag = reqDTO.getValue("flag");
		System.out.print(flag);
		String edit_flag = reqDTO.getValue("edit_flag");
		String project_info_no = reqDTO.getValue("project_info_no");
		//sel
	
		
		String produceDate = reqDTO.getValue("produce_date");
		String org_id = null;
		String org_subjection_id = null;

		boolean flag1 = false;

		ProjectMCSBean projectMCSBean = (ProjectMCSBean) BeanFactory
				.getBean("ProjectMCSBean");

		PageModel page = new PageModel();
          
		Map map = reqDTO.toMap();
		
		
		  
		String exploration_method="select d.exploration_method from gp_wt_workload d where d.project_info_no='"+project_info_no+"'";
	     List<Map>   mapX=(List<Map>) radDao.queryRecords(exploration_method);
		

//           if("6".equals(map.get("if_build"))){
//        		String sqlPa = "select * from gp_ops_daily_report_wt t"+
//     	       " where t.project_info_no = '"+project_info_no+"' and t.produce_date < to_date('"+produceDate+"', 'yyyy-mm-dd')  order by t.produce_date desc ";
//
//     		 
//     			List<Map > listPa  = jdbcDao.queryRecords(sqlPa);
//     			Map mapPa=null; 
//     		    for(int i=0;i<listPa.size();i++){
//     		    	mapPa=(Map) listPa.get(0);
//     		    	System.out.print(mapPa.get("produceDate"));
//     		    }
//     		  
//     		  // String pause_re= (String) mapPa.get("pauseReason");
//
//     		   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//     		  
//     		   long to=sdf.parse(produceDate).getTime();
//     		   long from=sdf.parse(mapPa.get("produceDate").toString()).getTime();
//     		 int a=(int) ((to - from) / (1000 * 60 * 60 * 24));
//
//     		    if("8".equals(mapPa.get("ifBuild"))){
//     		    	
//     		        for(int i=0;i<a-1;i++){
//     		        	 Date da=sdf.parse(mapPa.get("produceDate").toString());
//		        	     	Calendar c=Calendar.getInstance(); 
//		        	    	c.setTime(da); 
//		        	    	c.add(Calendar.DAY_OF_MONTH, i+1); 
//     		        	 for(int j=0;j<mapX.size();j++){
//     		        		  Map mapM=mapX.get(j);
//     		        		
//                               String da1= sdf.format(c.getTime());
//     		        		  map.put("exploration_method", mapM.get("exploration_method"));
//     		        		  map.put("produce_date",da1) ;
//     		        		  BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_daily_report_zb");
//     		        		
//     		          }
//     		        	  map.put("if_build", "8");
//     		        	 map.put("bsflag", "0");
//     		        	 map.put("audit_status", "0");
//     		        	 map.put("pause_reason",pause_re);
// 		        		  BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_daily_report_wt");
//     		        }
//     		    }
//           }
		
	    
		map.put("projectInfoNo", map.get("project_info_no"));
          String sqlBuild="select  t.if_build from gp_ops_daily_report_wt t where t.project_info_no='"+map.get("project_info_no")+"' and t.produce_date=to_date('"+produceDate+"','yyyy-mm-dd')";
         Map mapBuild= radDao.queryRecordBySQL(sqlBuild.toString());
          page = projectMCSBean.quertProject(map, page);
          if(mapBuild!=null){
        	  if(("8").equals(mapBuild.get("if_build"))){
  	       		String sql1="delete from gp_ops_daily_report_zb where project_info_no='"+project_info_no+"' and produce_date = to_date('"
  	 	    	  + produceDate + "','yyyy-MM-dd') ";
  	 		      radDao.executeUpdate(sql1);
  	            
  	        }
          }
		  
		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map project = (Map) list.get(0);
			map.put("workarea_no", project.get("workarea_no"));
			map.put("exploration_method", project.get("exploration_method"));
		}

		page = projectMCSBean.quertProjectDynamic(map, page);

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map dy = (Map) list.get(0);

			org_id = (String) dy.get("org_id");
			map.put("org_id", dy.get("org_id"));

			org_subjection_id = (String) dy.get("org_subjection_id");
			map.put("org_subjection_id", dy.get("org_subjection_id"));
		}

		if (flag.equals("notSaved")) {
			String if_build = reqDTO.getValue("if_build");
			String produce_date = reqDTO.getValue("produce_date");
			String stop_reason="";
			if(if_build.equals("7")){
			stop_reason=reqDTO.getValue("stop_reason");
			}
			
			map.put("creator", user.getUserName());
			map.put("create_date", new Date());
			map.put("produce_date",produce_date);
			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());
			 map.put("if_build",if_build);
			map.put("bsflag", "0");
			map.put("SUBMIT_STATUS", "1");
		 map.put("pause_reason",stop_reason);
			map.put("audit_status", "0");
			
			
			Serializable dailyNo = BeanFactory.getPureJdbcDAO()
					.saveOrUpdateEntity(map, "gp_ops_daily_report_wt");

			map.put("daily_no_wt", dailyNo);
			
				
 
			
			flag1 = true;

			JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

			String sql = "select * from bgp_p6_workload where bsflag = '0' and project_info_no = '"
					+ project_info_no
					+ "' and produce_date = to_date('"
					+ produceDate + "','yyyy-MM-dd') ";
             
			List<Map<String, Object>> temp = radDao.getJdbcTemplate()
					.queryForList(sql);
			if (temp == null || temp.size() == 0) {
				// ����û�м�¼
				sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"
						+ project_info_no + "' ";
				List<Map<String, Object>> tempList = radDao.getJdbcTemplate()
						.queryForList(sql);
				
				// �������ռ�¼
				for (int i = 0; i < tempList.size(); i++) {
					Map<String, Object> mapTemp = tempList.get(i);

					mapTemp.put("produce_date", produceDate);
					mapTemp.put("object_id", null);

					mapTemp.put("actual_this_period_units", "0");
					map.put("org_id", org_id);
					map.put("org_subjection_id", org_subjection_id);
					mapTemp.put("create_date", new Date());
					mapTemp.put("creator", user.getUserId());
					mapTemp.put("modifi_date", new Date());
					mapTemp.put("updator", user.getUserId());
				}

				WorkloadMCSBean w = new WorkloadMCSBean();
				w.saveOrUpdateWorkloadToMCS(tempList, user);
			}

		} else if (edit_flag.equals("yes")
				&& (flag.equals("notPassed") || flag.equals("notSubmited"))) {
			// �޸�
 
			String daily_no_wt = reqDTO.getValue("daily_no_wt");
			String if_build = reqDTO.getValue("if_build");
			String stop_reason="";
			if(if_build.equals("7")){
			stop_reason=reqDTO.getValue("stop_reason");
			}
		 
			map.put("daily_no_wt", daily_no_wt);
			map.put("stop_reason", stop_reason);
			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());

			// map.put("collect_time", collect_time);
			map.put("bsflag", "0");

			map.put("if_build", if_build);
			map.put("produce_date", produceDate);
     
			Serializable dailyNo = BeanFactory.getPureJdbcDAO()
					.saveOrUpdateEntity(map, "gp_ops_daily_report_wt");

			// ��ѯ��daily_sit_no���и���
			String getsitDailyNo = "select s.daily_sit_no from gp_ops_daily_produce_sit s where s.bsflag = '0' and s.daily_no = '"
					+ dailyNo + "'";

			if (radDao.queryRecordBySQL(getsitDailyNo.toString()) != null) {
				map.put("daily_sit_no",
						radDao.queryRecordBySQL(getsitDailyNo.toString()).get(
								"daily_sit_no"));
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
						"gp_ops_daily_produce_sit");
			}
			 

			flag1 = true;
		}

		if (flag1) {
			String deleteId = reqDTO.getValue("deleteId");
			Map map1 = reqDTO.toMap();
			String[] deleteIds = deleteId.split(",");
			List<String> list1 = new ArrayList<String>();
			if (deleteIds != null && deleteIds.length > 1) {
				for (int i = 1; i < deleteIds.length; i++) {
					list1.add(deleteIds[i]);
				}
				this.deleteQuestion(list1);
			}

			List<String> listOrders = reqDTO.getValues("order");
			String order = reqDTO.getValue("order");

			if (listOrders == null && order != null) {
				listOrders = new ArrayList<String>();
				listOrders.add(order);
			}

			List saveList = new ArrayList();
			List updateList = new ArrayList();

			String j = null;

			String question_id = null;

			String bug_code = null;
			String q_description = null;
			String resolvent = null;

			if (listOrders != null && listOrders.size() != 0) {

				for (int i = 0; i < listOrders.size(); i++) {
					j = listOrders.get(i);

					question_id = reqDTO.getValue("question_id_" + j);
					bug_code = reqDTO.getValue("bug_code_" + j);
					q_description = reqDTO.getValue("q_description_" + j);
					resolvent = reqDTO.getValue("resolvent_" + j);
					if (question_id == null || "".equals(question_id)) {
						// ����
						map = new HashMap();

						map.put("creator", user.getEmpId());
						map.put("create_date", new Date());
						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());

						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);

						saveList.add(map);
					} else {
						// �޸�
						map = new HashMap();

						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());

						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);

						map.put("question_id", question_id);

						updateList.add(map);
					}

				}
			}

			this.saveDailyQuestion(saveList);
			this.updateDailyQuestion(updateList);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("flag", flag);
		msg.setValue("projectInfoNo", project_info_no);

		msg.setValue("customKey", "edit_flag,produceDate");
		msg.setValue("customValue", edit_flag + "," + produceDate);
		msg.setValue("taskBackUrl", "/pm/dailyReport/singleProject/wt/queryWtResourceAssignment.srq");

		System.out.print(map.get("if_build"));
		String if_build = (String) map.get("if_build");
		if(if_build!=null&&!"".equals(if_build)){
			//�޸��ձ�¼��״̬ʱͬ����Ŀ��Ϣ��״̬
			String projectStatus = "";
			if(if_build!=null&&"1".equals(if_build)||"2".equals(if_build)||"3".equals(if_build)||"4".equals(if_build)||"5".equals(if_build)){
				//��Ŀ���� ��Ǩ��̤������������ѵ������
				projectStatus="5000100001000000001";
			}else if(if_build!=null&&"6".equals(if_build)||"7".equals(if_build)){
				//���ɼ���ͣ������Ӧ����ʩ��
				projectStatus="5000100001000000002";

			}else if(if_build!=null&&"8".equals(if_build)){
				//��Ŀ��ͣ
				projectStatus="5000100001000000004";

			}else if(if_build!=null&&"9".equals(if_build)){
				projectStatus="5000100001000000005";

				//ʩ������
			}
			String projectupdate="update gp_task_project set PROJECT_STATUS='"+projectStatus+"' where PROJECT_INFO_NO='"+project_info_no+"'";
			radDao.getJdbcTemplate().update(projectupdate);
		}	
		return msg;
	
	
	}

	
	public ISrvMsg saveOrUpdateWtIndex(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String if_build = reqDTO.getValue("if_build");
		String flag = reqDTO.getValue("flag");
		System.out.print(flag);
		String edit_flag = reqDTO.getValue("edit_flag");
		String project_info_no = reqDTO.getValue("project_info_no");
		//sel
	
		
		String produceDate = reqDTO.getValue("produce_date");
		String org_id = null;
		String org_subjection_id = null;

		boolean flag1 = false;

		ProjectMCSBean projectMCSBean = (ProjectMCSBean) BeanFactory
				.getBean("ProjectMCSBean");

		PageModel page = new PageModel();

		Map map = reqDTO.toMap();
		map.put("projectInfoNo", map.get("project_info_no"));
		//if("8".equals(map.get("if_build"))){
			map.put("task_status", "3");
			 	String projectupdate="update gp_task_project set PROJECT_STATUS='5000100001000000004' where PROJECT_INFO_NO='"+project_info_no+"'";
				radDao.getJdbcTemplate().update(projectupdate);
		//}
		
		map.put("pause_reason",map.get("pause_reason"));

		page = projectMCSBean.quertProject(map, page);
		   if(("8").equals(if_build)){
       		String sql1="delete from gp_ops_daily_report_zb where project_info_no='"+project_info_no+"' and produce_date = to_date('"
 	    	  + produceDate + "','yyyy-MM-dd') ";
 		      radDao.executeUpdate(sql1);
            
        }
		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map project = (Map) list.get(0);
			map.put("workarea_no", project.get("workarea_no"));
			map.put("exploration_method", project.get("exploration_method"));
		}
		String exploration_method="select d.exploration_method from gp_wt_workload d where d.project_info_no='"+project_info_no+"'";
	     List<Map>   mapX=(List<Map>) radDao.queryRecords(exploration_method);
		
        
       
	 	String sdNd=" select * from gp_ops_daily_report_zb b where b.daily_no_wt='"+map.get("daily_no_wt")+"'";
		List<Map<String, Object>> sdList = radDao.getJdbcTemplate()
		.queryForList(sdNd);
		if(sdList.size()==0){
			 for(int j=0;j<mapX.size();j++){
        		  Map mapM=mapX.get(j);
        		  map.put("exploration_method", mapM.get("exploration_method"));
        		  BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_daily_report_zb");
          }
		}else{
			 for(int j=0;j<mapX.size();j++){
       		  Map mapM=mapX.get(j);
       		  map.put("exploration_method", mapM.get("exploration_method"));
       		  BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_daily_report_zb");
         }
		}
      
		page = projectMCSBean.quertProjectDynamic(map, page);

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map dy = (Map) list.get(0);

			org_id = (String) dy.get("org_id");
			map.put("org_id", dy.get("org_id"));

			org_subjection_id = (String) dy.get("org_subjection_id");
			map.put("org_subjection_id", dy.get("org_subjection_id"));
		}

		if (flag.equals("notSaved")) {
		
			map.put("creator", user.getUserName());
			map.put("create_date", new Date());

			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());

			map.put("bsflag", "0");
			map.put("SUBMIT_STATUS", "1");

			map.put("audit_status", "0");
			
			
			Serializable dailyNo = BeanFactory.getPureJdbcDAO()
					.saveOrUpdateEntity(map, "gp_ops_daily_report_wt");
			map.put("daily_no_wt", dailyNo);
			flag1 = true;

			JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

			String sql = "select * from bgp_p6_workload where bsflag = '0' and project_info_no = '"
					+ project_info_no
					+ "' and produce_date = to_date('"
					+ produceDate + "','yyyy-MM-dd') ";
             
			List<Map<String, Object>> temp = radDao.getJdbcTemplate()
					.queryForList(sql);
			if (temp == null || temp.size() == 0) {
				// ����û�м�¼
				sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"
						+ project_info_no + "' ";
				List<Map<String, Object>> tempList = radDao.getJdbcTemplate()
						.queryForList(sql);
				
				// �������ռ�¼
				for (int i = 0; i < tempList.size(); i++) {
					Map<String, Object> mapTemp = tempList.get(i);

					mapTemp.put("produce_date", produceDate);
					mapTemp.put("object_id", null);

					mapTemp.put("actual_this_period_units", "0");
					map.put("org_id", org_id);
					map.put("org_subjection_id", org_subjection_id);
					mapTemp.put("create_date", new Date());
					mapTemp.put("creator", user.getUserId());
					mapTemp.put("modifi_date", new Date());
					mapTemp.put("updator", user.getUserId());
				}

				WorkloadMCSBean w = new WorkloadMCSBean();
				w.saveOrUpdateWorkloadToMCS(tempList, user);
			}

		} else if (edit_flag.equals("yes")
				&& (flag.equals("notPassed") || flag.equals("notSubmited"))) {
			// �޸�
			String daily_no_wt = reqDTO.getValue("daily_no_wt");
			
			String stop_reason = reqDTO.getValue("stop_reason");
			String pause_reason=reqDTO.getValue("pause_reason");
			// String collect_time=reqDTO.getValue("collect_time");
			// Map daily = this.getDailyReport(map);
			map.put("daily_no_wt", daily_no_wt);

			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());

			// map.put("collect_time", collect_time);
			map.put("bsflag", "0");

			map.put("if_build", if_build);
			map.put("produce_date", produceDate);
		 
			Serializable dailyNo = BeanFactory.getPureJdbcDAO()
					.saveOrUpdateEntity(map, "gp_ops_daily_report_wt");

			// ��ѯ��daily_sit_no���и���
			String getsitDailyNo = "select s.daily_sit_no from gp_ops_daily_produce_sit s where s.bsflag = '0' and s.daily_no = '"
					+ dailyNo + "'";

			if (radDao.queryRecordBySQL(getsitDailyNo.toString()) != null) {
				map.put("daily_sit_no",
						radDao.queryRecordBySQL(getsitDailyNo.toString()).get(
								"daily_sit_no"));
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
						"gp_ops_daily_produce_sit");
			}
			 

			flag1 = true;
		}

		if (flag1) {
			String deleteId = reqDTO.getValue("deleteId");
			Map map1 = reqDTO.toMap();
			String[] deleteIds = deleteId.split(",");
			List<String> list1 = new ArrayList<String>();
			if (deleteIds != null && deleteIds.length > 1) {
				for (int i = 1; i < deleteIds.length; i++) {
					list1.add(deleteIds[i]);
				}
				this.deleteQuestion(list1);
			}

			List<String> listOrders = reqDTO.getValues("order");
			String order = reqDTO.getValue("order");

			if (listOrders == null && order != null) {
				listOrders = new ArrayList<String>();
				listOrders.add(order);
			}

			List saveList = new ArrayList();
			List updateList = new ArrayList();

			String j = null;

			String question_id = null;

			String bug_code = null;
			String q_description = null;
			String resolvent = null;

			if (listOrders != null && listOrders.size() != 0) {

				for (int i = 0; i < listOrders.size(); i++) {
					j = listOrders.get(i);

					question_id = reqDTO.getValue("question_id_" + j);
					bug_code = reqDTO.getValue("bug_code_" + j);
					q_description = reqDTO.getValue("q_description_" + j);
					resolvent = reqDTO.getValue("resolvent_" + j);
					if (question_id == null || "".equals(question_id)) {
						// ����
						map = new HashMap();

						map.put("creator", user.getEmpId());
						map.put("create_date", new Date());
						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());

						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);

						saveList.add(map);
					} else {
						// �޸�
						map = new HashMap();

						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());

						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);

						map.put("question_id", question_id);

						updateList.add(map);
					}

				}
			}

			this.saveDailyQuestion(saveList);
			this.updateDailyQuestion(updateList);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("flag", flag);
		msg.setValue("projectInfoNo", project_info_no);

		msg.setValue("customKey", "edit_flag,produceDate");
		msg.setValue("customValue", edit_flag + "," + produceDate);
		System.out.print(map.get("if_build"));
	 			msg.setValue("taskBackUrl", "/pm/dailyReport/singleProject/wt/queryWtResourceAssignment.srq");
		return msg;
	
	
	}
	

	private void deleteQuestion(final List<String> ids) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String sql = "update gp_ops_daily_question set bsflag = '1' where question_id = ?";
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return ids.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				ps.setString(1, ids.get(i));
			}

		};

		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}
	 
	/**
	 * ��ѯ�ձ�������
	 * 
	 * @param map
	 * @return
	 */
	 
	public List<Map<String, Object>> findGpOpsDaily(Map map) {

		String dailyNo = (String) map.get("dailyNo");
		String lineGroupId = (String) map.get("lineGroupId");
		String tableName = (String) map.get("tableName");

		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map.get("daily_no");
		}
		if (lineGroupId == null || "".equals(lineGroupId)) {
			lineGroupId = (String) map.get("line_group_id");
		}
		if (tableName == null || "".equals(tableName)) {
			tableName = (String) map.get("table_name");
		}

		String customKey = (String) map.get("customKey");
		String customValue = (String) map.get("customValue");

		if (customKey == null || "".equals(customKey)) {
			customKey = (String) map.get("custom_key");
		}
		if (customValue == null || "".equals(customValue)) {
			customValue = (String) map.get("custom_value");
		}

		String sql = "select * from " + tableName + " where daily_no = '"
				+ dailyNo + "' and bsflag = '0'  ";

		if (lineGroupId != null && !"".equals(lineGroupId)) {
			sql += " and line_group_id = '" + lineGroupId + "' ";
		}

		if (customKey != null && !"".equals(customKey)) {
			String[] temp = customKey.split(",");
			String[] temp1 = customValue.split(",");

			for (int i = 0; i < temp.length; i++) {
				sql += " and " + temp[i] + "= '" + temp1[i] + "' ";
			}
		}

		List<Map<String, Object>> list = radDao.getJdbcTemplate().queryForList(
				sql);

		return list;
	}

	public ISrvMsg saveOrUpdateDailyPlan(ISrvMsg reqDTO) throws Exception {

		String deleteId = reqDTO.getValue("deleteId");
		Map map1 = reqDTO.toMap();
		String[] deleteIds = deleteId.split(",");
		List<String> list = new ArrayList<String>();
		if (deleteIds != null && deleteIds.length > 1) {
			for (int i = 1; i < deleteIds.length; i++) {
				list.add(deleteIds[i]);
			}
			this.deleteDailyPlan(list);
		}

		List<String> listOrders = reqDTO.getValues("order");
		String order = reqDTO.getValue("order");

		if (listOrders == null && order != null) {
			listOrders = new ArrayList<String>();
			listOrders.add(order);
		}

		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		if (project_info_no == null || "".equals(project_info_no)) {
			project_info_no = user.getProjectInfoNo();
		}

		List saveList = new ArrayList();
		List updateList = new ArrayList();

		String j = null;
		String pro_plan_id = null;
		String value = null;
		String record_month = null;
		Map map = null;

		String[] valueName = { "measure_", "drill_", "collect_" };
		String[] valueKey = { "workload_num", "workload", "workload" };
		String[] proValue = { "measure_pro_plan_id_", "drill_pro_plan_id_",
				"coll_pro_plan_id_" };
		String[] planType = { "measuredailylist", "drilldailylist",
				"colldailylist" };

		if (listOrders != null) {
			for (int i = 0; i < listOrders.size(); i++) {
				j = listOrders.get(i);

				for (int k = 0; k < valueName.length; k++) {

					value = reqDTO.getValue(valueName[k] + j);
					pro_plan_id = reqDTO.getValue(proValue[k] + j);
					record_month = reqDTO.getValue("record_month_" + j);
					if (value == null) {
						// ��ֵ ����
					} else {
						if (pro_plan_id == null || "".equals(pro_plan_id)
								|| "undefined".equals(pro_plan_id)) {
							// ����
							map = new HashMap();
							map.put("bsflag", "0");
							// map.put("pro_plan_id", pro_plan_id);
							map.put("record_month", record_month);
							map.put("oper_plan_type", planType[k]);
							map.put(valueKey[k], value);
							map.put("project_info_no", project_info_no);

							saveList.add(map);
						} else {
							// �޸�
							map = new HashMap();
							map.put("bsflag", "0");
							map.put("pro_plan_id", pro_plan_id);
							map.put("record_month", record_month);
							map.put("oper_plan_type", planType[k]);
							map.put(valueKey[k], value);
							map.put("project_info_no", project_info_no);

							updateList.add(map);
						}
					}

				}

			}

			this.saveDailyPlan(saveList);
			this.updateDailyPlan(updateList);
		} else {
			String updateAll = "update gp_proj_product_plan p set p.bsflag = '1' where p.project_info_no = '"
					+ project_info_no + "'";
			radDao.executeUpdate(updateAll);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		return msg;
	}

	public ISrvMsg queryDailyPlan(ISrvMsg reqDTO) throws Exception {

		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);

		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String[] planType = { "measuredailylist", "drilldailylist",
				"colldailylist" };

		StringBuffer sql = new StringBuffer();

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		sql.append("select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month from gp_proj_product_plan where project_info_no = '"
				+ projectInfoNo + "'  and oper_plan_type in(");

		for (int i = 0; i < planType.length; i++) {
			sql.append("'" + planType[i] + "',");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(") and bsflag ='0' order by to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') ");

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		List list = page.getData();
		// List list = null;
		if (list != null && list.size() != 0) {
			msg.setValue("hasSaved", "1");
			msg.setValue("allList", list);

			for (int i = 0; i < planType.length; i++) {
				sql = new StringBuffer();
				sql.append("select pro_plan_id,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,workload_num,workload from gp_proj_product_plan where bsflag = '0' and project_info_no = '"
						+ projectInfoNo
						+ "'  and oper_plan_type = '"
						+ planType[i]
						+ "'  order by to_char(to_date("
						+ "record_month,'yyyy-MM-dd'),'yyyy-MM-dd')");
				page = radDao.queryRecordsBySQL(sql.toString(), page);
				msg.setValue(planType[i], page.getData());
			}
		} else if (list == null || list.size() == 0) {
			msg.setValue("hasSaved", "0");
			list = countDailyPlan(projectInfoNo);

			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}

		return msg;
	}

	private Map<String, String> getDesignTotal(String projectInfoNo) {
		Map totalUnitsMap = new HashMap();
		String[] measure2Type = { "G02003", "G02004" };
		String[] measure3Type = { "G2003", "G2004" };

		String[] drill2Type = { "G05001" };
		String[] drill3Type = { "G5001" };

		String[] coll2Type = { "G07001", "G07003", "G07005" };
		String[] coll3Type = { "G7001", "G7003", "G7005" };

		String method_sql = "select exploration_method from gp_task_project  where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0'";
		Map totalMap = radDao.queryRecordBySQL(method_sql);

		String exploration_method = null;
		if (totalMap != null) {
			exploration_method = (String) totalMap.get("exploration_method");
		}

		// ����
		String measureSqlTemp = "";
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			measureSqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				measureSqlTemp = measureSqlTemp + measure2Type[i] + "','";
			}
			measureSqlTemp = measureSqlTemp.substring(0,
					measureSqlTemp.length() - 2);
			measureSqlTemp += ") order by a.planned_start_date";
		} else {
			measureSqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				measureSqlTemp = measureSqlTemp + measure3Type[i] + "','";
			}
			measureSqlTemp = measureSqlTemp.substring(0,
					measureSqlTemp.length() - 2);
			measureSqlTemp += ") order by a.planned_start_date";
		}

		String measureSql = "select nvl(sum(w.planned_units),0) as measure_plan_units from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' ";
		measureSql += measureSqlTemp;
		String totalMeasure = "";
		if (radDao.queryRecordBySQL(measureSql) != null) {
			totalMeasure = radDao.queryRecordBySQL(measureSql)
					.get("measure_plan_units").toString();
		}
		totalUnitsMap.put("totalMeasure", totalMeasure);

		// �꾮
		String drillSqlTemp = "";
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			drillSqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill2Type.length; i++) {
				drillSqlTemp = drillSqlTemp + drill2Type[i] + "','";
			}
			drillSqlTemp = drillSqlTemp.substring(0, drillSqlTemp.length() - 2);
			drillSqlTemp += ")";
		} else {
			drillSqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill3Type.length; i++) {
				drillSqlTemp = drillSqlTemp + drill3Type[i] + "','";
			}
			drillSqlTemp = drillSqlTemp.substring(0, drillSqlTemp.length() - 2);
			drillSqlTemp += ")";
		}

		String drillSql = "select nvl(sum(w.planned_units),0) as drill_planned_units from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' ";

		drillSql += drillSqlTemp;
		String totalDrill = "";
		if (radDao.queryRecordBySQL(drillSql) != null) {
			totalDrill = radDao.queryRecordBySQL(drillSql)
					.get("drill_planned_units").toString();
		}
		totalUnitsMap.put("totalDrill", totalDrill);

		// �ɼ�
		String collSqlTemp = "";
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			collSqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll2Type.length; i++) {
				collSqlTemp = collSqlTemp + coll2Type[i] + "','";
			}
			collSqlTemp = collSqlTemp.substring(0, collSqlTemp.length() - 2);
			collSqlTemp += ")";
		} else {
			collSqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll3Type.length; i++) {
				collSqlTemp = collSqlTemp + coll3Type[i] + "','";
			}
			collSqlTemp = collSqlTemp.substring(0, collSqlTemp.length() - 2);
			collSqlTemp += ")";
		}

		String collSql = "select nvl(sum(w.planned_units),0) as coll_planned_units from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' ";

		collSql += collSqlTemp;
		String totalColl = "";
		if (radDao.queryRecordBySQL(collSql) != null) {
			totalColl = radDao.queryRecordBySQL(collSql)
					.get("coll_planned_units").toString();
		}
		totalUnitsMap.put("totalColl", totalColl);

		return totalUnitsMap;
	}

	private List countDailyPlan(String projectInfoNo) {
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);

		List AllList = new ArrayList();
		List measuredailylist = new ArrayList();
		List drilldailylist = new ArrayList();
		List colldailylist = new ArrayList();

		String[] measure2Type = { "G02003", "G02004" };
		String[] measure3Type = { "G2003", "G2004" };

		String[] drill2Type = { "G05001" };
		String[] drill3Type = { "G5001" };

		String[] coll2Type = { "G07001", "G07003", "G07005" };
		String[] coll3Type = { "G7001", "G7003", "G7005" };

		String sql = "select exploration_method from gp_task_project  where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0'";
		page = radDao.queryRecordsBySQL(sql.toString(), page);

		List list = page.getData();

		String exploration_method = null;
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			exploration_method = (String) map.get("exploration_method");
		} else {
			return null;
		}

		String sqlTemp = null;

		// �ܵ�
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		String max_finish_date = null;
		String min_start_date = null;

		Date start_date = null;
		Date end_date = null;

		int day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}
		Date temp = start_date;
		String dateTemp = null;
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));
			temp.setTime(temp.getTime() + 86400000L);
			AllList.add(map);
		}

		// ����
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ") order by a.planned_start_date";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ") order by a.planned_start_date";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		max_finish_date = null;
		min_start_date = null;

		start_date = null;
		end_date = null;

		day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}

		sql = "select w.planned_units,a.planned_duration/8 as duration,round(w.planned_units*8/a.planned_duration,3) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));

			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String) tempMap
							.get("average_units"));
				}
			}
			map.put("workload_num", df_1.format(workload_num));
			measuredailylist.add(map);
		}

		// String startDate = null;
		// String endDate = null;
		//
		// Date sd = null;
		// Date ed = null;
		// Date tempDate = null;
		//
		// for (int i = 0; i < list.size(); i++) {
		// Map tempMap = (Map) list.get(i);
		// startDate = (String) tempMap.get("start_date");//ÿ����ҵ�Ŀ�ʼʱ��
		// endDate = (String) tempMap.get("finish_date");//ÿ����ҵ�Ľ���ʱ��
		//
		// tempDate = DateOperation.parseToUtilDate(startDate);//���ڱȽ�
		//
		// if (sd == null || ed == null) {
		// //���sdΪnull �ü�¼Ϊ��һ����ҵ
		// sd = tempDate;
		// ed = DateOperation.parseToUtilDate(endDate);
		// } else
		// if(DateOperation.getDateSkip(endDate,DateOperation.formatDate(sd)) >
		// 0) {
		// //���endDate > sd
		//
		// } else {
		// //���endDate <= sd
		//
		// }
		//
		// }

		// �꾮
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		max_finish_date = null;
		min_start_date = null;

		start_date = null;
		end_date = null;

		day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}

		sql = "select w.planned_units,a.planned_duration/8 as duration,round(w.planned_units*8/a.planned_duration,3) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));

			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String) tempMap
							.get("average_units"));
				}
			}
			map.put("workload", df_1.format(workload_num));
			drilldailylist.add(map);
		}

		// �ɼ�
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		max_finish_date = null;
		min_start_date = null;

		start_date = null;
		end_date = null;

		day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}

		sql = "select w.planned_units,a.planned_duration/8 as duration,round(w.planned_units*8/a.planned_duration,3) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));

			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String) tempMap
							.get("average_units"));
				}
			}
			map.put("workload", df_1.format(workload_num));
			colldailylist.add(map);
		}

		List list2 = new ArrayList();
		list2.add(AllList);
		list2.add(measuredailylist);
		list2.add(drilldailylist);
		list2.add(colldailylist);
		return list2;
	}

	private void deleteDailyPlan(final List<String> ids) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String sql = "update gp_proj_product_plan set bsflag = '1' where pro_plan_id = ?";
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return ids.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				ps.setString(1, ids.get(i));
			}

		};

		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}

	private void saveDailyPlan(final List list) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "RECORD_MONTH", "WORKLOAD", "WORKLOAD_NUM",
				"PROJECT_INFO_NO", "OPER_PLAN_TYPE", "BSFLAG", "PRO_PLAN_ID" };
		StringBuffer sql = new StringBuffer();
		sql.append("insert into gp_proj_product_plan (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append(propertys[i]).append(",");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(") values (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("record_month"));
				ps.setString(2, (String) map.get("workload"));
				ps.setString(3, (String) map.get("workload_num"));
				ps.setString(4, (String) map.get("project_info_no"));
				ps.setString(5, (String) map.get("oper_plan_type"));
				ps.setString(6, "0");
				ps.setString(7, radDao.generateUUID());
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}

	private void updateDailyPlan(final List list) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "RECORD_MONTH", "WORKLOAD", "WORKLOAD_NUM",
				"PROJECT_INFO_NO", "OPER_PLAN_TYPE", "BSFLAG", "PRO_PLAN_ID" };

		StringBuffer sql = new StringBuffer();
		sql.append("update gp_proj_product_plan set ");
		for (int i = 0; i < propertys.length - 1; i++) {
			sql.append(propertys[i]).append("=?,");// ����ֵ
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(" where ").append(propertys[propertys.length - 1])
				.append("=?");// ����

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("record_month"));
				ps.setString(2, (String) map.get("workload"));
				ps.setString(3, (String) map.get("workload_num"));
				ps.setString(4, (String) map.get("project_info_no"));
				ps.setString(5, (String) map.get("oper_plan_type"));
				ps.setString(6, "0");
				ps.setString(7, (String) map.get("pro_plan_id"));
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}

	public ISrvMsg queryDailyQuestion(ISrvMsg reqDTO) throws Exception {

		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);

		String produceDate = reqDTO.getValue("produceDate");// ��������
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String bugCode = reqDTO.getValue("bugCode");// �������

		UserToken user = reqDTO.getUserToken();
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}

		String sql = "select * from gp_ops_daily_question where bsflag = '0' ";

		if (projectInfoNo != null) {
			sql = sql + " and project_info_no = '" + projectInfoNo + "' ";
		}
		if (produceDate != null) {
			sql = sql + " and produce_date = to_date('" + produceDate
					+ "','yyyy-MM-dd')";
		}
		if (bugCode != null) {
			sql = sql + " and bug_code = '" + bugCode + "' ";
		}

		page = radDao.queryRecordsBySQL(sql, page);
		List list = page.getData();

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("questionList", list);

		return msg;
	}

	public ISrvMsg queryDailyQuestionList(ISrvMsg reqDTO) throws Exception {

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

		String produceDate = reqDTO.getValue("produceDate");// ��������
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String bugCode = reqDTO.getValue("bugCode");// �������

		UserToken user = reqDTO.getUserToken();
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}

		String sql = "select * from gp_ops_daily_question where bsflag = '0' ";

		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			sql = sql + " and project_info_no = '" + projectInfoNo + "' ";
		}
		if (produceDate != null && !"".equals(produceDate)
				&& !"null".equals(produceDate)) {
			sql = sql + " and produce_date = to_date('" + produceDate
					+ "','yyyy-MM-dd')";
		}
		if (bugCode != null && !"".equals(bugCode)) {
			sql = sql + " and bug_code = '" + bugCode + "' ";
		}

		page = radDao.queryRecordsBySQL(sql, page);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);

		return msg;
	}

	private void saveDailyQuestion(final List list) throws Exception {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "project_info_no", "org_id",
				"org_subjection_id", "bug_code", "bug_name", "resolvent",
				"q_description", "produce_date", "creator", "create_date",
				"updator", "modifi_date", "bsflag", "question_id" };

		StringBuffer sql = new StringBuffer();
		sql.append("insert into gp_ops_daily_question (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append(propertys[i]).append(",");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(") values (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("project_info_no"));
				ps.setString(2, (String) map.get("org_id"));
				ps.setString(3, (String) map.get("org_subjection_id"));
				ps.setString(4, (String) map.get("bug_code"));
				ps.setString(5, (String) map.get("bug_name"));
				ps.setString(6, (String) map.get("resolvent"));
				ps.setString(7, (String) map.get("q_description"));

				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				java.sql.Date date;
				try {
					date = new java.sql.Date(f.parse(
							(String) map.get("produce_date")).getTime());
					ps.setDate(8, date);
				} catch (Exception e) {
					ps.setDate(8, null);
				}

				ps.setString(9, (String) map.get("creator"));
				ps.setDate(10, new java.sql.Date(new Date().getTime()));

				ps.setString(11, (String) map.get("updator"));
				ps.setDate(12, new java.sql.Date(new Date().getTime()));

				ps.setString(13, "0");

				ps.setString(14, radDao.generateUUID());
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);

	}

	private void updateDailyQuestion(final List list) throws Exception {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "project_info_no", "org_id",
				"org_subjection_id", "bug_code", "bug_name", "resolvent",
				"q_description", "produce_date", "updator", "modifi_date",
				"bsflag", "question_id" };

		StringBuffer sql = new StringBuffer();
		sql.append("update gp_ops_daily_question set ");
		for (int i = 0; i < propertys.length - 1; i++) {
			sql.append(propertys[i]).append("=?,");// ����ֵ
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(" where ").append(propertys[propertys.length - 1])
				.append("=?");// ����

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("project_info_no"));
				ps.setString(2, (String) map.get("org_id"));
				ps.setString(3, (String) map.get("org_subjection_id"));
				ps.setString(4, (String) map.get("bug_code"));
				ps.setString(5, (String) map.get("bug_name"));
				ps.setString(6, (String) map.get("resolvent"));
				ps.setString(7, (String) map.get("q_description"));

				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				java.sql.Date date;
				try {
					date = new java.sql.Date(f.parse(
							(String) map.get("produce_date")).getTime());
					ps.setDate(8, date);
				} catch (Exception e) {
					ps.setDate(8, null);
				}

				ps.setString(9, (String) map.get("updator"));
				ps.setDate(10, new java.sql.Date(new Date().getTime()));

				ps.setString(11, "0");

				ps.setString(12, (String) map.get("question_id"));
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);

	}

	/**
	 * ��ѯ��Ŀ������Ϣ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg queryWtDailyReportProcess(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		

		Map<String, String> paramMap = new HashMap<String, String>();

		paramMap.put("projectInfoNo", projectInfoNo);
		//������ĿID����Ŀ��̽����
		String exSql=" select d.exploration_method,l.coding_name from gp_wt_workload d   join    comm_coding_sort_detail l on l.coding_code_id=d.exploration_method"+
          "where d.project_info_no = '"+projectInfoNo+"'  and d.bsflag = '0'  and d.exploration_method != '5110000056000000045'";
		List exList= jdbcDao.queryRecords(exSql);
	 

 

 

 
		msg.setValue("pageSize", exList.size());// ҳ���¼����
	/*	msg.setValue("cur", cur);// ��ǰҳ��
		msg.setValue("totalRows", totalRows);// ��¼����2
*/		msg.setValue("totalList", exList);// �ձ�������Ϣ�б�2
		msg.setValue("projectInfoNo", projectInfoNo);// ��Ŀ���
	 
 
		return msg;
	}

	/**
	 * �������з��������Ĳ��ظ��ĵ���������
	 * 
	 * @param map
	 *            Map ������
	 * @return list List �ձ����������б�
	 * @throws ��
	 */
	public List loadAllProduceDate(Map map) {

		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
		String startDate = (String) map.get("startDate");
		String endDate = (String) map.get("endDate");
		String explorationMethod = (String) map.get("explorationMethod");

		// ���Ϊ�գ�˵���ǰ���Ŀ�������Ϊ�գ�˵���ǰ���Ŀ��ʩ������
		String orgId = (String) map.get("orgId");

		if (projectInfoNo == null) {
			projectInfoNo = "";
		}
		if (produceDate == null) {
			produceDate = "";
		}
		if (startDate == null) {
			startDate = "";
		}
		if (endDate == null) {
			endDate = "";
		}
		if (orgId == null) {
			orgId = "";
		}
		if (explorationMethod == null) {
			explorationMethod = "";
		}

		String sqlDates = "select distinct t1.produce_date from gp_ops_daily_report t1 left outer join gp_task_project gp on t1.project_info_no = gp.project_info_no where t1.audit_status = '3' and t1.bsflag = '0' and gp.bsflag = '0'";

		if (!orgId.equals("")) {

			sqlDates = sqlDates + " and t1.org_id = '" + orgId + "'";
		}
		if (!projectInfoNo.equals("")) {

			sqlDates = sqlDates + " and t1.project_info_no = '" + projectInfoNo
					+ "'";
		}
		if (!startDate.equals("")) {

			sqlDates = sqlDates + " and t1.produce_date >= to_date('"
					+ startDate + "','yyyy-mm-dd')";
		}

		if (!endDate.equals("")) {

			sqlDates = sqlDates
					+ " and TO_CHAR(t1.produce_date,'YYYY-MM-DD') <= '"
					+ endDate + "'";
		}
		if (!explorationMethod.equals("")) {

			sqlDates = sqlDates + " and t1.exploration_method= '"
					+ explorationMethod + "'";
		}

		sqlDates = sqlDates + "order by t1.produce_date desc";

		log.debug("the sql is:" + sqlDates);

		List list = jdbcDao.queryRecords(sqlDates);

		return list;
	}

	/**
	 * ���Long��ʽΪ�գ�ת��Ϊ��
	 * 
	 * @param par
	 *            Long ת��ǰ������
	 * @return par Long ת���������
	 * @throws ��
	 */
	public static Long nullToLong(Long par) {
		if (par == null) {
			return new Long(0);
		} else {
			try {
				return par;
			} catch (Exception e) {
				e.printStackTrace();
				return new Long(0);
			}
		}
	}

	

	/**
	 * ����Ŀ�����ձ�������Ϣ
	 * 
	 * @param map
	 *            Map ������
	 * @return dailyReportProcessRatePOJO DailyReportProcessRatePOJO �ձ�������Ϣ����
	 * @throws ��
	 */
	public List<Map>  processList(String projectInfoNo)throws Exception{

		log.debug("���� WtDailyReportSrv �� processList ����.....");
 
 		//������Ŀ��ϢID �� ��Ŀ�Ŀ�̽�����ͼƻ� ����㡢����㡢���㡣
		String sqlReport = "select d.exploration_method,  d.line_length,  b.Daily_Workload,  d.LOCATION_POINT,   l.coding_name, d.PHYSICS_POINT,  d.CHECK_POINT, "+
				 "sum(b.Daily_Coordinate_Point)sm_poin  ,sum(DAILY_PHYSICAL_POINT)sm_physical,sum(DAILY_CHECK_POINT)sm_check, "+
				" d.line_length-nvl(sum(b.Daily_Workload),0) remain_workload,"+
				"  d.LOCATION_POINT-sum(b.Daily_Coordinate_Point) remain_point,"+
                "  d.physics_point-sum(b.daily_physical_point) remain_physice,"+
                "  d.check_point-sum(b.daily_check_point) remain_check "+
                 " from gp_wt_workload d  join gp_ops_daily_report_zb b on b.project_info_no = d.project_info_no"+
				 
                 " and b.exploration_method = d.exploration_method  and b.bsflag = '0'  join comm_coding_sort_detail l on l.coding_code_id=d.exploration_method  and l.bsflag='0'  where d.project_info_no = '"+projectInfoNo+"'"+
                 "  and d.exploration_method != '5110000056000000045'  group by d.exploration_method,    d.LOCATION_POINT,   d.PHYSICS_POINT,  d.CHECK_POINT , l.coding_name ,b.Daily_Workload,  d.line_length";
		   List<Map> listReport = jdbcDao.queryRecords(sqlReport);
		return listReport;
	}
	/**
	 * ����Ŀ�����ձ�������Ϣ
	 * 
	 * @param map
	 *            Map ������
	 * @return dailyReportProcessRatePOJO DailyReportProcessRatePOJO �ձ�������Ϣ����
	 * @throws ��
	 */
	public DailyReportProcessRatePOJO findDailyReportProcessByProject(Map map) {

		log.debug("���� GpOpsDailyReportDAO �� findDailyReportProcessByProject ����.....");
		log.debug("The map is:" + map);

		String projectInfoNo = (String) map.get("projectInfoNo");
		String projectType = (String) map.get("projectType");
		String produceDate = (String) map.get("produceDate");
		String explorationMethod = (String) map.get("explorationMethod");
		String explorationMethod1 = "";
		if (explorationMethod1 != null) {
			explorationMethod1 = explorationMethod;
			if (explorationMethod1 == "2" || "2".equals(explorationMethod1)) {
				explorationMethod1 = "0300100012000000002";
			} else {
				explorationMethod1 = "0300100012000000003";
			}
		}

		if (produceDate == null) {
			produceDate = "";
		}
		if (projectInfoNo == null) {
			projectInfoNo = "";
		}

		DailyReportProcessRatePOJO dpProcess = new DailyReportProcessRatePOJO();

		// ��������
		dpProcess.setProductDate(produceDate);

		// ��ѯ���ύ���ձ�������Ϣ
		String sqlReport = " select dr.* from gp_ops_daily_report dr left outer join gp_task_project gp on dr.project_info_no = gp.project_info_no where dr.bsflag = '0' and gp.bsflag = '0' and dr.audit_status = '3'";
		if (projectInfoNo != "") {
			sqlReport = sqlReport + " and dr.project_info_no = '"
					+ projectInfoNo + "'";
		}
		if (produceDate != "") {
			sqlReport = sqlReport + " and dr.produce_date =  TO_DATE('"
					+ produceDate + "','YYYY-MM-DD')";
		}

		List<Map> listReport = jdbcDao.queryRecords(sqlReport);

		if (listReport == null || listReport.isEmpty()) {

			log.debug("�뿪 GpOpsDailyReportDAO �� findDailyReportProcessByProject ����.....");

			return dpProcess;
		}

		long acquireShot = (long) 0;// �ɼ�����ɵ�����Դ�ڵ���+�����ڵ���+��ǹ�ڵ���
		long drillShot = (long) 0;// �꾮����ɵ���
		long surfaceShot = (long) 0;// �������ɵ���=С��������ɵ���+΢�⾮����ɵ���
		long surveyShotNum = (long) 0;// ����������ڵ���
		long surveyGeophoneNum = (long) 0;// ��������ɼ첨����

		for (int j = 0; j < listReport.size(); j++) {

			// GpOpsDailyReport dailyReport =
			// (GpOpsDailyReport)listReport.get(j);
			Map dailyReport = listReport.get(j);
			acquireShot = acquireShot
					+ nullToLong(Long.valueOf(dailyReport.get(
							"dailyAcquireSpNum").toString() != "" ? dailyReport
							.get("dailyAcquireSpNum").toString() : "0"))
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailyJpAcquireShotNum")
									.toString() != "" ? dailyReport.get(
									"dailyJpAcquireShotNum").toString() : "0"))
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailyQqAcquireShotNum")
									.toString() != "" ? dailyReport.get(
									"dailyQqAcquireShotNum").toString() : "0"));
			drillShot = drillShot
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailyDrillSpNum")
									.toString() != "" ? dailyReport.get(
									"dailyDrillSpNum").toString() : "0"));
			surfaceShot = surfaceShot
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailySmallRefractionNum")
									.toString() != "" ? dailyReport.get(
									"dailySmallRefractionNum").toString() : "0"))
					+ nullToLong(Long
							.valueOf(dailyReport
									.get("dailyMicroMeasuePointNum").toString() != "" ? dailyReport
									.get("dailyMicroMeasuePointNum").toString()
									: "0"));
			surveyShotNum = surveyShotNum
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailySurveyShotNum")
									.toString() != "" ? dailyReport.get(
									"dailySurveyShotNum").toString() : "0"));
			surveyGeophoneNum = surveyGeophoneNum
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailySurveyGeophoneNum")
									.toString() != "" ? dailyReport.get(
									"dailySurveyGeophoneNum").toString() : "0"));
		}

		// ������ɵ����ý���ƴpojo
		dpProcess.setCollShotNum(String.valueOf(acquireShot));
		dpProcess.setDrillShotNum(String.valueOf(drillShot));
		dpProcess.setSurfacePointNo(String.valueOf(surfaceShot));
		dpProcess.setSurveyShotNum(String.valueOf(surveyShotNum));
		dpProcess.setSurveyGeophoneNum(String.valueOf(surveyGeophoneNum));

		// ���Ҹ�����Ŀ�ۼ�ֵ
		String sql1 = "select nvl(sum(nvl(t1.daily_acquire_sp_num,0)),0) as projectAcquireSpNum1 ,"
				+ "nvl(sum(nvl(t1.daily_micro_measue_point_num,0)),0) as projectMicroMeasueNum,"
				+ "nvl(sum(nvl(t1.daily_small_refraction_num,0)),0) as projectSmallRefractionNum ,"
				+ "nvl(sum(nvl(t1.daily_survey_shot_num,0)),0) as projectSurveyShotNum ,"
				+ "nvl(sum(nvl(t1.daily_survey_geophone_num,0)),0) as projectSurveyGeophoneNum ,"
				+ "nvl(sum(nvl(t1.daily_drill_sp_num,0)),0) as projectDrillSpNum ,"
				+ "nvl(sum(nvl(t1.daily_jp_acquire_shot_num,0)),0) as projectAcquireSpNum2,"
				+ "nvl(sum(nvl(t1.daily_qq_acquire_shot_num,0)),0) as projectAcquireSpNum3 "
				+ "from gp_ops_daily_report t1 left outer join gp_task_project gp on "
				+ "t1.project_info_no = gp.project_info_no "
				+ "where t1.bsflag = '0' and gp.bsflag = '0' ";
		if (projectInfoNo != "") {
			sql1 = sql1 + " and t1.project_info_no = '" + projectInfoNo + "'";
		}
		if (produceDate != "") {
			sql1 = sql1 + " and TO_CHAR(t1.produce_date,'YYYY-MM-DD') <= '"
					+ produceDate + "'";
		}

		List<Map> listsql1 = jdbcDao.queryRecords(sql1);

		// û�з��������ļ�¼
		if (listsql1 == null || listsql1.isEmpty()) {

			return dpProcess;
		}
		Long projectAcquireSpNum1 = (long) 0;
		Long projectAcquireSpNum2 = (long) 0;
		Long projectAcquireSpNum3 = (long) 0;
		Long projectAcquireSpNum = (long) 0;

		Long projectMicroMeasueNum = (long) 0;
		Long projectSmallRefractionNum = (long) 0;
		Long projectSurveyShotNum = (long) 0;
		Long projectSurveyGeophoneNum = (long) 0;
		Long projectDrillSpNum = (long) 0;

		Map listsqlMap = listsql1.get(0);
		if (listsqlMap != null) {
			projectAcquireSpNum1 = Long.valueOf(listsqlMap.get(
					"projectacquirespnum1").toString());
			projectAcquireSpNum2 = Long.valueOf(listsqlMap.get(
					"projectacquirespnum2").toString());
			projectAcquireSpNum3 = Long.valueOf(listsqlMap.get(
					"projectacquirespnum3").toString());
			projectAcquireSpNum = projectAcquireSpNum1 + projectAcquireSpNum2
					+ projectAcquireSpNum3;

			projectMicroMeasueNum = Long.valueOf(listsqlMap.get(
					"projectmicromeasuenum").toString());
			projectSmallRefractionNum = Long.valueOf(listsqlMap.get(
					"projectsmallrefractionnum").toString());
			projectSurveyShotNum = Long.valueOf(listsqlMap.get(
					"projectsurveyshotnum").toString());
			projectSurveyGeophoneNum = Long.valueOf(listsqlMap.get(
					"projectsurveygeophonenum").toString());
			projectDrillSpNum = Long.valueOf(listsqlMap
					.get("projectdrillspnum").toString());
		}

		// ���ۼƹ������ý���ƴpojo��
		dpProcess.setCollFinishedSpNum(String.valueOf(projectAcquireSpNum));
		dpProcess.setSurfaceFinishedSpNum(String.valueOf(projectMicroMeasueNum
				+ projectSmallRefractionNum));
		dpProcess.setSurveyFinishedSpNum(String.valueOf(projectSurveyShotNum
				+ projectSurveyGeophoneNum));
		dpProcess.setDrillFinishedSpNum(String.valueOf(projectDrillSpNum));

		String sql2 = "";
		log.debug("the explorationMethod is:" + explorationMethod);
		// ���Ҹ������ֵ�����Ϊ��ά�����Ҷ�ά������Ʋ��������Ϊ������ά��������ά������Ʋ���
		if (explorationMethod != null
				&& explorationMethod.equals("0300100012000000002")) {
			sql2 = "select nvl(t.design_sp_num,0) as designSpNum,"
					+ "nvl(t.design_geophone_num,0) as designGeophoneNum,"
					+ "nvl(t.design_drilling_num,0) as designDrillNum,"
					+ "nvl(t.design_micro_measue_num,0) as designMicroMeasueNum,"
					+ "nvl(t.design_small_regraction_num,0) as designSmallRegractionNum"
					+ " from gp_ops_2dwa_design_basic_data t left outer join gp_task_project gp "
					+ " on t.project_info_no = gp.project_info_no where t.bsflag = '0' and gp.bsflag = '0'";
			if (projectInfoNo != "") {
				sql2 = sql2 + " and t.project_info_no = '" + projectInfoNo
						+ "'";
			}

		} else if (explorationMethod != null
				&& explorationMethod.equals("0300100012000000003")) {
			sql2 = "select nvl(t1.design_shot_num,0) as designSpNum,"
					+ "nvl(t1.receiveing_point_num,0) as designGeophoneNum,"
					+ "nvl(t1.design_drilling_num,0) as designDrillNum,"
					+ "nvl(t1.design_micro_measue_num,0) as designMicroMeasueNum,"
					+ "nvl(t1.design_small_regraction_num,0) as designSmallRegractionNum"
					+ " from gp_ops_3dwa_design_data t1 left outer join gp_task_project gp1 "
					+ " on t1.project_info_no = gp1.project_info_no where t1.bsflag = '0' and gp1.bsflag = '0'";
			if (projectInfoNo != "") {
				sql2 = sql2 + " and t1.project_info_no = '" + projectInfoNo
						+ "'";
			}
		}
		log.debug("The sql2 is:" + sql2);
		List<Map> listsql2 = jdbcDao.queryRecords(sql2);

		// û�з��������ļ�¼
		if (listsql2 == null || listsql2.isEmpty()) {

			return dpProcess;
		}

		Long designSpNum = (long) 0;
		Long designGeophoneNum = (long) 0;
		Long designDrillNum = (long) 0;
		Long designMicroMeasueNum = (long) 0;
		Long designSmallRegractionNum = (long) 0;
		Map listsqlMap2 = listsql2.get(0);

		if (listsqlMap2 != null) {
			designSpNum = Long.valueOf(listsqlMap2.get("designspnum")
					.toString());
			designGeophoneNum = Long.valueOf(listsqlMap2.get(
					"designgeophonenum").toString());
			designDrillNum = Long.valueOf(listsqlMap2.get("designdrillnum")
					.toString());
			designMicroMeasueNum = Long.valueOf(listsqlMap2.get(
					"designmicromeasuenum").toString());
			designSmallRegractionNum = Long.valueOf(listsqlMap2.get(
					"designsmallregractionnum").toString());
		}

		// ������ٷֱȣ����������뱣����λС��
		Double projectAcquireSpRatio = 0.00;
		Double projectSurfaceRatio = 0.00;
		Double projectSurveyRatio = 0.00;
		Double projectDrillSpRatio = 0.00;

		if (designSpNum != 0) {

			projectAcquireSpRatio = (double) (Math.round(10000
					* (double) projectAcquireSpNum / (double) designSpNum)) / 100;
		}

		if (designMicroMeasueNum + designSmallRegractionNum != 0) {

			projectSurfaceRatio = (double) (Math
					.round(10000
							* (double) (projectMicroMeasueNum + projectSmallRefractionNum)
							/ (double) (designMicroMeasueNum + designSmallRegractionNum))) / 100;
		}

		if (designSpNum + designGeophoneNum != 0) {

			projectSurveyRatio = (double) (Math
					.round(10000
							* (double) (projectSurveyShotNum + projectSurveyGeophoneNum)
							/ (double) (designSpNum + designGeophoneNum))) / 100;
		}

		if (designDrillNum != 0) {

			projectDrillSpRatio = (double) (Math.round(10000
					* (double) projectDrillSpNum / (double) designDrillNum)) / 100;
		}

		// ����ɰٷֱ��ý���ƴpojo��
		dpProcess.setCollFinishedRate(String.valueOf(projectAcquireSpRatio));
		dpProcess.setSurfaceFinishedRate(String.valueOf(projectSurfaceRatio));
		dpProcess.setSurveyFinishedRate(String.valueOf(projectSurveyRatio));
		dpProcess.setDrillFinishedRate(String.valueOf(projectDrillSpRatio));

		log.debug("�����ɹ����뿪 GpOpsDailyReportDAO �� findDailyReportProcessByProject ����.....");

		return dpProcess;
	}

	/**
	 * ɾ���ձ�����
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteDailyReport(ISrvMsg reqDTO) throws Exception {
		System.out.println("deleteDailyReport !");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
	
     
		String  proDate = reqDTO.getValue("produceDate");
		String[] produceDate=proDate.split(",");
		 System.out.println(projectInfoNo+"-=-==-=-=-=-="+produceDate);
		String updateSqlzb = "";
		String updateSqlwt="";
		String updateSqlin="";
        String updateDailyWorkloadSql="";
		if (proDate != null) {
			
				// ɾ����Ӧ���ڵĹ�����������ձ���Ӧ������
			
			for(String id : produceDate){
				updateSqlzb = "update gp_ops_daily_report_zb  g set g.bsflag='1' where g.project_info_no='"
						+ projectInfoNo + "'and g.produce_date=to_date('"+id+"','yyyy-mm-dd')";
				updateSqlwt="update gp_ops_daily_report_wt  g set g.bsflag='1' where g.project_info_no='"
					+ projectInfoNo + "'and g.produce_date=to_date('"+id+"','yyyy-mm-dd')";
				updateDailyWorkloadSql = "update bgp_p6_workload w set w.bsflag = '1' where w.project_info_no = '"+projectInfoNo+"' and w.produce_date = to_date('"+id+"','yyyy-MM-dd')";
				radDao.executeUpdate(updateDailyWorkloadSql);
				radDao.executeUpdate(updateSqlzb);
				radDao.executeUpdate(updateSqlwt);
		 

			}
		}
		return msg;

	}

	/**
	 * ���¶�ȡ�ƻ���Ч
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg refreshDailyPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String checkSql = "select p.pro_plan_id from gp_proj_product_plan p where p.bsflag = '0' and p.project_info_no = '"
				+ projectInfoNo + "'";
		if (radDao.queryRecords(checkSql) != null
				&& radDao.queryRecords(checkSql).size() > 0) {
			String delDailyPlanSql = "update gp_proj_product_plan p set p.bsflag = '1' where p.project_info_no = '"
					+ projectInfoNo + "'";
			if (radDao.executeUpdate(delDailyPlanSql) > 0) {
				List list = countDailyPlan(projectInfoNo);
				msg.setValue("allList", list.get(0));
				msg.setValue("measuredailylist", list.get(1));
				msg.setValue("drilldailylist", list.get(2));
				msg.setValue("colldailylist", list.get(3));
			}
		} else {
			List list = countDailyPlan(projectInfoNo);
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		msg.setValue("hasSaved", "0");
		return msg;
	}
}

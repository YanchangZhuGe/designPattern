package com.bgp.mcs.service.pm.service.consult;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class ConsultReportSrv  extends BaseService {
	private ILog log;
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	/**
	 * 新增请示报告
	 * @throws Exception
	 */
	public ISrvMsg saveConsultReport(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		
		String reportName = reqDTO.getValue("reportName");
		String submitFlag = "0";
		String consultOrg = reqDTO.getValue("consultOrg");
		String requestOrg = reqDTO.getValue("requestOrg");
		String projectId = reqDTO.getValue("projectId");
		String subjectMatter = reqDTO.getValue("subjectMatter");
		String suggestionScheme = reqDTO.getValue("suggestionScheme");
		String consult_date = reqDTO.getValue("consult_date");
		
		String folder_id = reqDTO.getValue("folder_id") != null?reqDTO.getValue("folder_id"):"";
		
		Map map = new HashMap();
		String object_id = reqDTO.getValue("object_id");
		if (object_id == null || "".equals(object_id)) {
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
		}else{
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			map.put("object_id", object_id);
		}
		map.put("report_name", reportName);
		map.put("submit_flag", submitFlag);
		map.put("consult_org", consultOrg);
		map.put("request_org", requestOrg);
		map.put("project_id", projectId);
		map.put("subject_matter", subjectMatter);
		map.put("suggestion_scheme", suggestionScheme);
		map.put("consult_date", consult_date);
		map.put("folder_id", folder_id);
		map.put("bsflag", "0");
		
		// 保存文件
		String fileName = "";
		String fileUcmId = "";
		String fileType = "";
		String oldUcmId = reqDTO.getValue("oldUcmId") != null?reqDTO.getValue("oldUcmId"):"";
		boolean fileExist = false;
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			fileName = uploadFile.getFilename();
			fileType = uploadFile.getType();
			byte[] uploadData = uploadFile.getFileData();
			fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
			map.put("ucm_id", fileUcmId);
			
			fileExist = true;
		}
		Map mapT = new HashMap();
		String consult_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_consult_report").toString();
		
		if(!"".equals(oldUcmId)){
			// 删除旧的文件记录
			myUcm.deleteFile(oldUcmId);
			String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '" + oldUcmId + "'";
			RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
			JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
			jdbcTemplate.execute(sql);
		}
		
		if(fileExist){
			Map fileMap = new HashMap();
			fileMap.put("file_name", fileName);
			fileMap.put("ucm_id", fileUcmId);
			fileMap.put("file_type", fileType);
			fileMap.put("parent_file_id", folder_id);
		
			fileMap.put("project_info_no", projectId);
			fileMap.put("bsflag", "0");
			fileMap.put("is_file", "1");
			fileMap.put("creator_id", user.getEmpId());
			fileMap.put("create_date", new Date());
		
			String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap, "bgp_doc_gms_file").toString();
			myUcm.docVersion(doc_pk_id, "1.0", fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
			myUcm.docLog(doc_pk_id, "1.0", 1, fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
			
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 获取指定ID请示报告
	 * @throws Exception
	 */
	public ISrvMsg getConsultReportById(ISrvMsg reqDTO) throws Exception {
		String objectid = reqDTO.getValue("objectId");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select object_id , report_name , to_char(create_date,'yyyy-MM-dd') as create_date,consult_org , request_org,project_id,subject_matter,suggestion_scheme, to_char(consult_date,'yyyy-MM-dd') as consult_date , case submit_flag when '0' THEN '否' when '1' then '是' else '否' end as submit_flag , '' as approval_status,folder_id,ucm_id from bgp_consult_report where object_id='"+objectid+"'");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map consultReport = jdbcDAO.queryRecordBySQL(sql.toString());
		responseMsg.setValue("consultReport", consultReport);
		return responseMsg;
	}
	
	/**
	 * 删除请示报告
	 * @throws Exception
	 */
	public ISrvMsg deleteConsultReport(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String ids = reqDTO.getValue("objectId");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String[] objectIds = ids.split(",");
		String sql1= " select r.object_id,   r.report_name,  te.proc_status,  to_char(r.create_date, 'yyyy-MM-dd') as create_date," +
				"    r.submit_flag  , r.ucm_id  from bgp_consult_report r left join common_busi_wf_middle te on te.business_id = r.object_id"+
				" and te.bsflag = '0' where r.bsflag='0' and object_id in(";

		for (int i = 0; i < objectIds.length; i++) {
			sql1 += "'"+objectIds[i] +"',";
		}
		sql1 = sql1.substring(0, sql1.lastIndexOf(","));
		sql1 += ")";
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map  map=jdbcDAO.queryRecordBySQL(sql1);
		if(map.get("submit_flag").equals("0")||map.get("proc_status").equals("4")){
			String sql = "update bgp_consult_report set bsflag='1'  where bsflag='0' and object_id in(";
			for (int i = 0; i < objectIds.length; i++) {
				sql += "'"+objectIds[i] +"',";
			}
			
			sql = sql.substring(0, sql.lastIndexOf(","));
			sql += ")";
			jdbcTemplate.execute(sql);
			
			
			msg.setValue("ActionStatus","ok");
		}else {
			msg.setValue("ActionStatus","nok");
		}
	
		return msg;
	}
 
	/**
	 * 修改提交状态
	 * @throws Exception
	 */
	public ISrvMsg submitConsultReport(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String objectId = reqDTO.getValue("objectId");
		StringBuffer sbUpdate = new StringBuffer("update bgp_consult_report set submit_flag='1'");
		sbUpdate.append("  where bsflag='0' and object_id='").append(objectId).append("'");
		jdbcTemplate.execute(sbUpdate.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("ActionStatus","ok");
		return msg;
	}
	

	/**
	 *  审批状态(通过)
	 * @throws Exception
	 */
	public ISrvMsg approvalConsultReport(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String objectId = reqDTO.getValue("objectId");
		StringBuffer sbUpdate = new StringBuffer("update bgp_consult_report set approval_status='1',submit_flag='5'");
		sbUpdate.append("  where bsflag='0' and submit_flag='1' and object_id='").append(objectId).append("'");
		jdbcTemplate.execute(sbUpdate.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("ActionStatus","ok");
		return msg;
	}
	/**
	 *  审批状态(不通过)
	 * @throws Exception
	 */
	public ISrvMsg noApprovalConsultReport(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String objectId = reqDTO.getValue("objectId");
		StringBuffer sbUpdate = new StringBuffer("update bgp_consult_report set approval_status='2',submit_flag='5'");
		sbUpdate.append("  where bsflag='0' and submit_flag='1' and object_id='").append(objectId).append("'");
		jdbcTemplate.execute(sbUpdate.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("ActionStatus","ok");
		return msg;
	}
}

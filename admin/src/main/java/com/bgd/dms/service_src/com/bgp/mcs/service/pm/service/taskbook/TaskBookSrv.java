package com.bgp.mcs.service.pm.service.taskbook;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class TaskBookSrv extends BaseService {
	
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	
	/**
	 *文档树 -->物探处 --开始
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getFileTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String module_id = (String)reqDTO.getValue("module_id");
		String project_info_no = (String)reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no =user.getProjectInfoNo();
		}
		if(project_info_no ==null || project_info_no.trim().equals("")){
			project_info_no = "";
		}
		String id ="";
		String name = "";
		List jsList = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select f.file_id id ,f.file_name name ,f.is_file isFile,f.file_abbr abbr from bgp_doc_gms_file f  ")
		.append(" where f.bsflag = '0' and f.is_file='0' and f.parent_file_id is null and f.ucm_id is null")
		.append(" and f.project_info_no = '").append(project_info_no).append("'");
		Map root = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sb.toString());
		if(root==null){
			root = new HashMap();
			id = user.getProjectInfoNo();
			name = user.getProjectName();
			root.put("id", "");
			root.put("name", name);
			root.put("isFile", "0");
		}else if(root!=null && root.get("id")!=null){
			id = (String)root.get("id");
			name = (String)root.get("name");
		}
		List tList = getFileFirstChild(module_id,project_info_no);
		if (tList != null && tList.size() > 0) {
			JSONArray jsonarray = JSONArray.fromObject(tList);
			root.put("children", jsonarray);
			root.put("leaf", false);
			root.put("expanded", true);
		}else {
			root.put("children", null);
			root.put("leaf", true);
			root.put("expanded", true);
		}
		jsList.add(root);
		JSONArray json = null;
		json = JSONArray.fromObject(jsList);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json",json.toString());
		
		return msg;
	}
	public List getFileFirstChild(String module_id,String project_info_no) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select f.file_id id ,f.file_name name ,f.is_file isFile,f.file_abbr abbr from bgp_doc_folder_module t")
		.append(" left join bgp_doc_gms_file f on t.folder_id = f.file_id and f.bsflag='0'")
		.append(" where t.bsflag='0' and  t.module_id ='").append(module_id).append("'")
		.append(" and f.project_info_no = '").append(project_info_no).append("'");
		System.out.println(sb.toString());
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			String abbr = (String)map.get("abbr");
			List tList = getFileTreeChild(abbr,project_info_no);
			if (tList != null && tList.size() > 0) {
				JSONArray jsonarray = JSONArray.fromObject(tList);
				map.put("children", jsonarray);
				map.put("leaf", false);
				map.put("expanded", false);
			} else {
				map.put("children", null);
				map.put("leaf", true);
				map.put("expanded", false);
				continue;
			}
			jsList.add(map);
		}
		return list;
	}
	public List getFileTreeChild(String fileId,String project_info_no) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select  t.file_id id, t.file_name name ,t.is_file isFile,t.file_abbr abbr from bgp_doc_gms_file t ")
		.append(" where t.parent_file_id='").append(fileId).append("'")
		.append(" and t.bsflag ='0' and t.is_file ='0' and t.ucm_id is null")
		.append(" and t.project_info_no = '").append(project_info_no).append("'");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			String abbr = (String)map.get("abbr");
			List tList = getFileTreeChild(abbr,project_info_no);
			if (tList != null && tList.size() > 0) {
				JSONArray jsonarray = JSONArray.fromObject(tList);
				map.put("children", jsonarray);
				map.put("leaf", false);
				map.put("expanded", false);
			} else {
				map.put("children", null);
				map.put("leaf", true);
				map.put("expanded", false);
				continue;
			}
			jsList.add(map);
		}
		return list;
	}
	/**
	 *文档树 -->物探处 --结束
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	
	
	/**
	 *任务书保存
	 * @param reqDTO
	 */
	public ISrvMsg saveTaskBook(ISrvMsg reqDTO) throws Exception{
		//Map map = reqDTO.toMap();
		Map map = new HashMap();
		UserToken user = reqDTO.getUserToken();
		
		String object_id = reqDTO.getValue("object_id");
		if (object_id == null || "".equals(object_id)) {
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
		}else{
			map.put("updator_id", user.getEmpId());
			map.put("modifi_date", new Date());
			map.put("object_id", object_id);
		}
		
		String project_info_no = user.getProjectInfoNo();
		String line_group_id = reqDTO.getValue("line_group_id") != null?reqDTO.getValue("line_group_id"):"";
		String work_type = reqDTO.getValue("work_type") != null?reqDTO.getValue("work_type"):"";
		String task_name = reqDTO.getValue("name") != null?reqDTO.getValue("name"):"";
		String workarea_name = reqDTO.getValue("workarea_name") != null?reqDTO.getValue("workarea_name"):"";
		String team_name = reqDTO.getValue("team_name") != null?reqDTO.getValue("team_name"):"";
		String produce_date = reqDTO.getValue("produce_date") != null?reqDTO.getValue("produce_date"):"";
		String receive_name = reqDTO.getValue("receive_name") != null?reqDTO.getValue("receive_name"):"";
		String send_name = reqDTO.getValue("send_name") != null?reqDTO.getValue("send_name"):"";
		String folder_id = reqDTO.getValue("folder_id") != null?reqDTO.getValue("folder_id"):"";
		
		map.put("project_info_no",project_info_no);
		map.put("line_group_id", line_group_id);
		map.put("work_type", work_type);
		map.put("name", task_name);
		map.put("workarea_name", workarea_name);
		map.put("team_name", team_name);
		map.put("produce_date", produce_date);
		map.put("receive_name", receive_name);
		map.put("send_name", send_name);
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
		
		Serializable taskbook_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_ops_work_report");
		
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
		
			fileMap.put("project_info_no", project_info_no);
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
	 * 获取项目信息
	 * @throws Exception
	 */
	public ISrvMsg getProjectInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select (select workarea from gp_workarea_diviede where workarea_no in(");
		sb.append("select workarea_no from gp_task_project where project_info_no = '");
		sb.append(project_info_no).append("' and bsflag='0')) as workarea,");
		sb.append("(select WMSYS.WM_CONCAT(team_usual_code) from comm_org_team where org_id in(");
		sb.append("select org_id from gp_task_project_dynamic where project_info_no = '");
		sb.append(project_info_no).append("' and bsflag='0')) as team_name from dual");
		
		Map project = new HashMap();
		project = jdbcDAO.queryRecordBySQL(sb.toString());
		
		if (project != null) {
			responseMsg.setValue("project", project);
		}
		return responseMsg;
	}
	
	/**
	 * 获取任务书信息
	 * @throws Exception
	 */
	public ISrvMsg getTaskBook(ISrvMsg reqDTO) throws Exception {
		
		String objectId = reqDTO.getValue("objectId");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select line_group_id ,name , work_type ,case work_type when '1' then '测量' when '2' then '表层测量(微测井)' when '3' then '表层调查(小折射)' when '4' then '钻井' when '5' then '放线' when '6' then '爆炸班' when '7' then '震源' when '8' then '仪器' else '' end as work_type_name,workarea_name, team_name,to_char(produce_date,'yyyy-MM-dd') as produce_date, receive_name, send_name, folder_id, ucm_id from bgp_ops_work_report ");
		sb.append(" where object_id='").append(objectId).append("'");
		
		Map taskbook = new HashMap();
		taskbook = jdbcDAO.queryRecordBySQL(sb.toString());
		
		if (taskbook != null) {
			responseMsg.setValue("taskbook", taskbook);
		}
		return responseMsg;
	}
	
	/**
	 * 删除指定编号的任务信息
	 * @throws Exception
	 */
	public ISrvMsg deleteTaskBook(ISrvMsg reqDTO) throws Exception {
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		String ids = reqDTO.getValue("objectId");
		String[] objectIds = ids.split(",");
		
		String sql = "update bgp_ops_work_report set bsflag='1'  where bsflag='0' and object_id in(";
		for (int i = 0; i < objectIds.length; i++) {
			sql += "'"+objectIds[i] +"',";
		}
		
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		jdbcTemplate.execute(sql);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("ActionStatus","ok");
		return msg;
	}
}

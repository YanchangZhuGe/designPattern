package com.bgp.mcs.service.pm.service.p6.project;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bgp.mcs.service.pm.service.p6.project.baselineproject.BaselineProjectWSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.primavera.ws.p6.baselineproject.BaselineProject;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Jun 4, 2012
 * 
 * 描述：
 * 
 * 说明：
 */
public class ProjectSrv extends BaseService{
	private ILog log;
	private ProjectMCSBean projectMCSBean;
	//private BaselineProjectMCSBean baselineProjectMCSBean;
	private BaselineProjectWSBean baselineProjectWSBean;
	private RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	
	public ProjectSrv(){
		log = LogFactory.getLogger(ProjectSrv.class);
		projectMCSBean = (ProjectMCSBean) BeanFactory.getBean("P6ProjectMCSBean"); 
		baselineProjectWSBean = (BaselineProjectWSBean) BeanFactory.getBean("P6BaselineProjectWSBean"); 
	}
	
	public ISrvMsg queryProject(ISrvMsg reqDTO) throws Exception{
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
		
		String projectName = reqDTO.getValue("projectName");
		
		String isSingle = reqDTO.getValue("isSingle");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String projectType = reqDTO.getValue("projectType");
		String isMainProject = reqDTO.getValue("isMainProject");
		String projectStatus = reqDTO.getValue("projectStatus");
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
	    String isws = reqDTO.getValue("isws");
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		if(projectType==null || projectType.trim().equals("")){
			projectType = user.getProjectType();
		}
		if(orgSubjectionId==null || orgSubjectionId.trim().equals("")){
			orgSubjectionId = user.getOrgSubjectionId();
		}
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (isSingle != null && !"".equals(isSingle) && isSingle != "null" && !"null".equals(isSingle)&&isws==null) {
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				msg.setValue("totalRows", 0);
				msg.setValue("pageSize", pageSize);
				return msg;
			} else {
				map.put("projectInfoNo", projectInfoNo);
			}
		}
		
		map.put("orgSubjectionId", orgSubjectionId);
		map.put("projectName", projectName);
		map.put("isMainProject", isMainProject);
		map.put("projectStatus", projectStatus);
		map.put("projectType", projectType);
		map.put("projectFatherNo", projectFatherNo);
		if("5000100004000000009".equals(projectType)){//综合物化探
			page = projectMCSBean.quertWtProject(map, page);
		}else{
			page = projectMCSBean.quertProject(map, page);
		}
		
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		msg.setValue("projectType", projectType);
		return msg;
	}
	
	public ISrvMsg queryBaselineProject(ISrvMsg reqDTO) throws Exception{
		
		
		String projectObjectId = reqDTO.getValue("projectObjectId");
		String wbsObjectId = reqDTO.getValue("wbsObjectId");
		String isSingle = reqDTO.getValue("isSingle");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String objectId = reqDTO.getValue("objectId");
		String targetObjectId = reqDTO.getValue("targetObjectId");
		
//		Map<String, Object> map = new HashMap<String, Object>();
//		
//		map.put("objectId", objectId);
		
		//List<BaselineProject> list = baselineProjectWSBean.getBaselineProjectFromP6(null, "OriginalProjectObjectId = "+projectObjectId, null);
		
		String sql = "select * from bgp_p6_project where 1=1 and bsflag = '0'";
		if(targetObjectId != "" && targetObjectId != null){
			sql += " and object_id ='"+targetObjectId+"'";
		}else{
			if (objectId != null && !"".equals(objectId)) {
				sql += " and object_id = '"+objectId+"'";
			} else {
				sql += " and project_object_id in(";
				sql += "select object_id from bgp_p6_project where 1=1 and bsflag = '0'";
				if (projectInfoNo != null && !"".equals(projectInfoNo)) {
					sql  += " and project_info_no = '"+projectInfoNo+"' ";
				}
				if (projectObjectId != null && !"".equals(projectObjectId) && projectObjectId != "null" && !"null".equals(projectObjectId)) {
					sql  += " and object_id = '"+projectObjectId+"' ";
				}
				sql += ")";
			}
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
		
		page = radDao.queryRecordsBySQL(sql, page);
		
//		List<Map<String, Object>> datas = new ArrayList<Map<String, Object>>();
//		Map<String, Object> map = null;
//		BaselineProject b = null;
//		for (int i = 0; i < list.size(); i++) {
//			b = list.get(i);
//			map = new HashMap<String, Object>();
//			map.put("name", b.getName());
//			map.put("objectId", b.getObjectId());
//			map.put("wbsObjectId", b.getWBSObjectId().getValue());
//			map.put("status", b.getStatus());
//			map.put("id", b.getId());
//			datas.add(map);
//		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		msg.setValue("projectObjectId", projectObjectId);
		msg.setValue("wbsObjectId", wbsObjectId);
		msg.setValue("isSingle", isSingle);
		
		return msg;
	}
	
	
	
	
	/**
	 * 项目进度管理 查询项目列表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryjdListProject(ISrvMsg reqDTO) throws Exception{
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
		
		String projectName = reqDTO.getValue("projectName");
		String isSingle = reqDTO.getValue("isSingle");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String projectType = reqDTO.getValue("projectType");
		String isMainProject = reqDTO.getValue("isMainProject");
		String projectStatus = reqDTO.getValue("projectStatus");
		String projectFatherNo = reqDTO.getValue("projectFatherNo");
	    String isws = reqDTO.getValue("isws");
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		if(projectType==null || projectType.trim().equals("")){
			projectType = user.getProjectType();
		}
		if(orgSubjectionId==null || orgSubjectionId.trim().equals("")){
			orgSubjectionId = user.getOrgSubjectionId();
		}
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (isSingle != null && !"".equals(isSingle) && isSingle != "null" && !"null".equals(isSingle)&&isws==null) {
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
				msg.setValue("totalRows", 0);
				msg.setValue("pageSize", pageSize);
				return msg;
			} else {
				map.put("projectInfoNo", projectInfoNo);
			}
		}
		
		map.put("orgSubjectionId", orgSubjectionId);
		map.put("projectName", projectName);
		map.put("isMainProject", isMainProject);
		map.put("projectStatus", projectStatus);
		map.put("projectType", projectType);
		map.put("projectFatherNo", projectFatherNo);
		if("5000100004000000009".equals(projectType)){//综合物化探
			page = projectMCSBean.quertWtProject2(map, page);
			List<Map> list = page.getData();
			List<Map> list_2 = new ArrayList();
			if(list!=null&&list.size()!=0){
				for(int i=0;i<list.size();i++){
					Map map_ = list.get(i);
					String project_id = map_.get("project_id").toString();
					String sql_ = "  select "
							+ "max(actual_finish_date)  actual_finish_date, "
							+ "min(actual_start_date)   actual_start_date, "
							+ "max(planned_finish_date) planned_finish_date,"
							+ "min(planned_start_date)  planned_start_date "
							+ "from bgp_p6_activity where wbs_object_id in (select object_id "
							+ "from  bgp_p6_project_wbs where parent_object_id =(select  wbs.object_id  from  bgp_p6_project pro "
							+ "JOIN bgp_p6_project_wbs wbs on wbs.PROJECT_OBJECT_ID = pro.OBJECT_ID "
							+ "AND pro.project_id='"+project_id+"' AND wbs.name ='运行阶段')) ";
					
					Map map_2 = radDao.queryRecordBySQL(sql_);
					
					String actual_finish_date = map_2.get("actual_finish_date").toString();
					String actual_start_date = map_2.get("actual_start_date").toString();
					String planned_finish_date = map_2.get("planned_finish_date").toString();
					String planned_start_date = map_2.get("planned_start_date").toString();
					if(actual_start_date!=null){//如果实际采集时间不为空
						map_.put("acquire_start_time", actual_start_date);
						map_.put("acquire_end_time", actual_finish_date);
					}else{
						map_.put("acquire_start_time", planned_start_date);
						map_.put("acquire_end_time", planned_finish_date);
					}
					list_2.add(map_);
					
				}
				page.setData(list_2);
			}
			
		}else{
			page = projectMCSBean.quertProject(map, page);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		msg.setValue("projectType", projectType);
		return msg;
	}
}

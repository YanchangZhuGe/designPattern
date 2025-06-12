package com.bgp.mcs.service.pm.service.p6.project;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBElement;
import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.namespace.QName;
import javax.xml.ws.Holder;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.bgp.mcs.service.pm.service.p6.project.projectCodeAssignment.ProjectCodeAssignmentWSBean;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.project.IntegrationFault;
import com.primavera.ws.p6.project.Project;
import com.primavera.ws.p6.project.ProjectExtends;
import com.primavera.ws.p6.project.ProjectFieldType;
import com.primavera.ws.p6.project.ProjectPortType;
import com.primavera.ws.p6.projectcodeassignment.ProjectCodeAssignment;
import com.primavera.ws.p6.projectcodeassignment.ProjectCodeAssignmentPortType;

public class ProjectWSBean {
	private ILog log;
	private ProjectMCSBean proMCS;
	ProjectPortType servicePort;
	ProjectCodeAssignmentPortType codeServicePort;
	public ProjectWSBean(){
		log = LogFactory.getLogger(ProjectWSBean.class);
		//proMCS = new ProjectMCSBean();
		
		try {
			servicePort= P6WSPortTypeFactory.getPortType(ProjectPortType.class,null);
			codeServicePort=P6WSPortTypeFactory.getPortType(ProjectCodeAssignmentPortType.class,null);
			proMCS = new ProjectMCSBean();
		} catch (Exception e) {
			log.debug("ProjectWSBean init Exception!");
			e.printStackTrace();
		}
	}

	/**
	 * 从P6中获取项目信息
	 * @param mcsUser
	 * @param filter
	 * @param order
	 * @return
	 * @throws Exception
	 */
	public List<Project> getProjectFromP6(UserToken mcsUser, String filter, String order) throws Exception{
		List<ProjectFieldType> fieldTypes = new ArrayList<ProjectFieldType>();
		fieldTypes.add(ProjectFieldType.OBJECT_ID);
		fieldTypes.add(ProjectFieldType.NAME);
		fieldTypes.add(ProjectFieldType.ID);
		fieldTypes.add(ProjectFieldType.OBS_NAME);
		fieldTypes.add(ProjectFieldType.OBS_OBJECT_ID);
		fieldTypes.add(ProjectFieldType.STATUS);
		fieldTypes.add(ProjectFieldType.START_DATE);
		fieldTypes.add(ProjectFieldType.FINISH_DATE);
		fieldTypes.add(ProjectFieldType.PLANNED_START_DATE);
		fieldTypes.add(ProjectFieldType.DATA_DATE);
		fieldTypes.add(ProjectFieldType.WBS_OBJECT_ID);
		fieldTypes.add(ProjectFieldType.SUMMARY_ACTUAL_START_DATE);
		fieldTypes.add(ProjectFieldType.SUMMARY_ACTUAL_FINISH_DATE);
		fieldTypes.add(ProjectFieldType.SUMMARY_PLANNED_START_DATE);
		fieldTypes.add(ProjectFieldType.SUMMARY_PLANNED_FINISH_DATE);
		fieldTypes.add(ProjectFieldType.SUMMARY_BASELINE_START_DATE);
		fieldTypes.add(ProjectFieldType.SUMMARY_BASELINE_FINISH_DATE);
		fieldTypes.add(ProjectFieldType.CURRENT_BASELINE_PROJECT_OBJECT_ID);
		fieldTypes.add(ProjectFieldType.SUMMARY_ACTUAL_DURATION);
		
		ProjectPortType servicePort = P6WSPortTypeFactory.getPortType(ProjectPortType.class,null);
		
		List<Project> list =  servicePort.readProjects(fieldTypes, filter, order);
		
		return list;
	}
	
	/**
	 * 删除项目
	 * @param list = ProjectMCSBean.getDeleteProjects();
	 * @return
	 * @throws Exception
	 */
	public boolean deleteProject(List<Map> del_list) throws Exception{
		ProjectPortType servicePort = P6WSPortTypeFactory.getPortType(ProjectPortType.class,null);
		List<Integer> delIds=new ArrayList<Integer>();
		for(int i=0;i<del_list.size();i++){
			Map tmp=del_list.get(i);
			String tmp_objectId=(String) tmp.get("object_id");
			if(tmp_objectId.equals(""))continue;
			delIds.add(Integer.parseInt(tmp_objectId));
		}
		
		return servicePort.deleteProjects(delIds);
	}
	
	public boolean insertProject(List<Map> list, UserToken user){
		boolean flag = true;
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			try {
				//System.out.println(map.get("org_subjection_id"));
				this.createProjectByTemp(map, (String) map.get("org_subjection_id"), user);
			} catch (Exception e) {//我他娘的很不理解为啥有异常了直接return？ for循环就不执行了？后面的数据 咋办？？？？？？？？？？？？？？
				flag = false;
				continue;
			}
		}
		return flag;
	}
	/**
	 * 复制一个项目到目标项目
	 * @param arg0
	 * @return
	 * @throws IntegrationFault
	 */
	public boolean copyProjectAsBaseline(String arg0){
		boolean flag = false;
		Holder projectId = new Holder(Integer.parseInt(arg0));
			try {
				servicePort.copyProjectAsBaseline(projectId);
				flag=true;
			} catch (IntegrationFault e) {
				e.printStackTrace();
			}
		
		return flag;

	}
	
	/**
	 * update P6中已经存在的项目，同时将记录update到GMS中
	 * @param list = ProjectMCSBean.getUpdateProjects();
	 * @return
	 * @throws Exception
	 */
	public boolean updateProject(List list, UserToken user) throws Exception{
		
		//========update各种分类码============
		List<ProjectCodeAssignment> update_list=new ArrayList<ProjectCodeAssignment>();
		for(int i=0;i<list.size();i++){//多个项目的循环
			log.info("同步update项目分类码 标记i="+i);
			
			List<String> gms_code=new ArrayList<String>();
			//GpTaskProject gp=(GpTaskProject)((Map)list.get(i)).get("gp_project");
			Map gp = (Map)((Map) list.get(i)).get("gp_project");
			
			String filter="ProjectObjectId='"+(String)((Map)list.get(i)).get("object_id")+"'";
			//通过P6的项目objectid获取P6系统中的，关于这个项目的所有ProjectCodeAssignment
			List<ProjectCodeAssignment> code_list = new ProjectCodeAssignmentWSBean().getProjectCodeAssignmentFromP6(null, filter, null);
			
			gms_code.add((String)gp.get("market_classify"));//市场范围!
			gms_code.add((String)gp.get("project_type"));//项目类型!
			gms_code.add((String)gp.get("project_business_type"));//业务类型....
			gms_code.add((String)gp.get("build_type"));//激发方式
			gms_code.add((String)gp.get("is_main_project"));//是否重点!
			gms_code.add((String)gp.get("exploration_method"));//勘探方法 维度
//			gms_code.add((String)gp.get("")getGpWorkareaDiviede().getCropAreaType());//工区--作物区类型!
//			gms_code.add((String)gp.get("")getGpWorkareaDiviede().getSurfaceType());//工区--地表类型!
//			gms_code.add((String)gp.get("")getGpWorkareaDiviede().getBlock());//工区--区域
			
			for (int j=0;j<gms_code.size();j++){
				int codeTypeObjectId=proMCS.getP6ProjectCodeTypeObjectId(gms_code.get(j));
				if(codeTypeObjectId==0){
					//codeTypeObjectId为空，跳过
					log.info(j+"codeTypeObjectId为空，跳过"+gms_code.get(j));
					continue;
				}else{
					int codeObjectId=proMCS.getP6ProjectCodeObjectId(gms_code.get(j),codeTypeObjectId);
					for(int k=0;k<code_list.size();k++){
						ProjectCodeAssignment tmp_code=code_list.get(k);
						if(codeTypeObjectId==tmp_code.getProjectCodeTypeObjectId().getValue()){
							if(codeObjectId!=tmp_code.getProjectCodeObjectId()){//to_update
								tmp_code.setProjectCodeObjectId(codeObjectId);
								update_list.add(tmp_code);
							}
						}
					}
					log.info("同步update项目分类码 标记i="+i+" j="+j);
				}
			}
		}//close多个项目的循环
		codeServicePort.updateProjectCodeAssignments(update_list);
		
		//==========================
		
		List<Project> projectList = GMSProjectToP6Project(list);
		
		boolean res = servicePort.updateProjects(projectList);
		
		List<ProjectExtends> list1 = new ArrayList<ProjectExtends>();
		
		for (int i = 0; i < projectList.size(); i++) {
			Project tmp=projectList.get(i);
			String filter="ObjectId='"+tmp.getObjectId().toString()+"'";
			List<Project> p6_project=getProjectFromP6(null,filter,null);
			ProjectExtends tmp1 = new ProjectExtends(p6_project.get(0));
			list1.add(tmp1);
		}
		
		//将update记录存放在MCS中
		proMCS.saveP6ProjectToMCS(list1, user);  
		
		return res;
	}
	
	/**
	 * 在P6中创建新项目，同时创建项目相关的分类码；保存P6中的项目信息到GMS
	 * @param gp Map对象，GMS新创建项目的类，包含所有信息
	 * @param org_sub_id 队伍隶属，用于确定P6的eps、obs
	 * @throws Exception
	 */
	public void createProjectByTemp(Map<String, String> gp, String org_sub_id, UserToken user) throws Exception{
		int epsId=proMCS.getEps(org_sub_id);
		int obsId=proMCS.getObs(org_sub_id);
		int new_objectId=0;
		
		//String project_type = gp.get("project_type");
		//先取合同开始时间, 没有合同时间取计划开始时间
		if(gp.get("design_start_date") != null && gp.get("design_start_date") != ""){
			new_objectId=createNullProject(gp.get("project_id"),gp.get("project_name"),epsId,obsId,gp.get("design_start_date"));
		}else{
			new_objectId=createNullProject(gp.get("project_id"),gp.get("project_name"),epsId,obsId,gp.get("acquire_start_time"));
		}
		
		String filter="ObjectId='"+new_objectId+"'";
		List<Project> p6_project=getProjectFromP6(null,filter,null);
		Project tmp=p6_project.get(0);
		ProjectExtends tmp1 = new ProjectExtends(tmp);
		tmp1.setProjectInfoNo(gp.get("project_info_no"));
		List<ProjectExtends> mcs_project=new ArrayList<ProjectExtends>();
		mcs_project.add(tmp1);
		
		proMCS.saveP6ProjectToMCS(mcs_project, user);
	}
	
	private int createNullProject(String proj_id, String proj_name,int epsObjectId, int  obsObjectId ,String design_start_date) throws Exception{
		Project proj=new Project();
		proj.setId(proj_id);
		proj.setName(proj_name);
		proj.setParentEPSObjectId(epsObjectId);
		proj.setOBSObjectId(obsObjectId);
		if(design_start_date != null && !"".equals(design_start_date)){
			proj.setPlannedStartDate(P6TypeConvert.convert(design_start_date, "yyyy-MM-dd"));
		}
		List<Project> projectList = new ArrayList<Project>();
		projectList.add(proj);
		
		List<Integer> objIds = servicePort.createProjects(projectList);
		return objIds.get(0).intValue();
	}
	
	/**
	 * 将GMS的项目信息包装到P6的Project类中
	 * @param gms
	 * @return
	 * @throws ParseException
	 */
	public List<Project> GMSProjectToP6Project(List gms) throws ParseException{
		List<Project> res = new ArrayList<Project>();
		
		for(int i=0;i<gms.size();i++){
    		Map map = (Map)gms.get(i);
    		//GpTaskProject tmp_gp=(GpTaskProject)map.get("gp_project");
    		Map tmp_gp = (Map) map.get("gp_project");
    		String tmp_orgSubId=(String) map.get("org_subjection_id");
    		String tmp_objectId=(String) map.get("object_id");
    		if(tmp_orgSubId.equals("")||tmp_objectId.equals(""))continue;//过滤空值，创建项目没有写入P6中，则有可能为空
    		
    		Project tmp = new Project();
			int obs = proMCS.getObs(tmp_orgSubId);
			int eps = proMCS.getEps(tmp_orgSubId);
			int object_id= Integer.parseInt(tmp_objectId);
			//解决大港物探处项目信息没有合同开始时间的问题 造成同步出错
			String plannedStartDate = (String) tmp_gp.get("design_start_date");
			if(plannedStartDate.length()==0){
				plannedStartDate = (String) tmp_gp.get("acquire_start_time");
			}
    		JAXBElement<XMLGregorianCalendar> date=new JAXBElement<XMLGregorianCalendar>(new QName("com.bgp.mcs.p6.service.project"), XMLGregorianCalendar.class, null, P6TypeConvert.convert(plannedStartDate, "yyyy-MM-dd"));
    		
    		tmp.setId((String) tmp_gp.get("project_id"));
    		tmp.setName((String) tmp_gp.get("project_name"));
    		tmp.setPlannedStartDate(date.getValue());
    		tmp.setParentEPSObjectId(eps);
    		tmp.setOBSObjectId(obs);
    		tmp.setObjectId(object_id);
    		
    		res.add(tmp);
		}
		return res;
	}
	
	public static void main(String[] args) throws Exception {
		ProjectWSBean w = new ProjectWSBean();
		List<Project> list = w.getProjectFromP6(null, null, null);
		for (int i = 0; i < list.size(); i++) {
			Project p = list.get(i);
			System.out.println("P is:"+p);
			System.out.println(p.getObjectId()+"||"+p.getName()+"||"+p.getCurrentBaselineProjectObjectId().getValue()+"||"+P6TypeConvert.convert(p.getDataDate(),"yyyy-MM-dd")+"||"+P6TypeConvert.convert(p.getPlannedStartDate(),"yyyy-MM-dd")+"||"+p.getSummaryActualDuration().getValue()+"||"+P6TypeConvert.convert(p.getSummaryPlannedStartDate(),"yyyy-MM-dd")+"||"+P6TypeConvert.convert(p.getSummaryPlannedFinishDate(),"yyyy-MM-dd")+"||"+P6TypeConvert.convert(p.getSummaryActualStartDate(),"yyyy-MM-dd")+"||"+P6TypeConvert.convert(p.getSummaryActualFinishDate(),"yyyy-MM-dd"));
		}
	}
}

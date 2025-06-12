package com.bgp.mcs.service.pm.service.p6.project.projectCodeAssignment;

import java.util.ArrayList;
import java.util.List;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.projectcodeassignment.ProjectCodeAssignment;
import com.primavera.ws.p6.projectcodeassignment.ProjectCodeAssignmentFieldType;
import com.primavera.ws.p6.projectcodeassignment.ProjectCodeAssignmentPortType;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Feb 10, 2012
 * 
 * 描述：
 * 
 * 说明:
 */
public class ProjectCodeAssignmentWSBean {
	private ILog log;
	
	public ProjectCodeAssignmentWSBean() {
		log = LogFactory.getLogger(ProjectCodeAssignmentWSBean.class);
	}
	
	public List<ProjectCodeAssignment> getProjectCodeAssignmentFromP6(UserToken mcsUser, String filter, String order)throws Exception {
		List<ProjectCodeAssignmentFieldType> fieldTypes = new ArrayList<ProjectCodeAssignmentFieldType>();
		
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_ID);//项目编号
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_NAME);//项目名
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_OBJECT_ID);//项目主键
		
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_DESCRIPTION);//分类码描述
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_OBJECT_ID);//分类码主键
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_VALUE);//分类码码值
		
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_TYPE_NAME);//分类码所属分类名
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_TYPE_OBJECT_ID);//分类码所属分类主键
		
		fieldTypes.add(ProjectCodeAssignmentFieldType.CREATE_DATE);
		fieldTypes.add(ProjectCodeAssignmentFieldType.LAST_UPDATE_DATE);
		
		ProjectCodeAssignmentPortType projectCodeAssignmentPoryType = P6WSPortTypeFactory.getPortType(ProjectCodeAssignmentPortType.class, mcsUser);
		
		List<ProjectCodeAssignment> list = projectCodeAssignmentPoryType.readProjectCodeAssignments(fieldTypes, filter, order);
		
		return list;
	}
	
	public static void main(String[] args) throws Exception {
		ProjectCodeAssignmentWSBean a = new ProjectCodeAssignmentWSBean();
		List<ProjectCodeAssignment> list = a.getProjectCodeAssignmentFromP6(null, null, null);
		for (int i = 0; i < list.size(); i++) {
			ProjectCodeAssignment aa = list.get(i);System.out.println("------------------");
			System.out.println(aa.getProjectObjectId());
			System.out.println(aa.getProjectId());
			System.out.println(aa.getProjectName());
			System.out.println(aa.getProjectCodeValue());
			System.out.println(P6TypeConvert.convert(aa.getCreateDate().getValue(),"yyyy-MM-dd"));
			System.out.println(P6TypeConvert.convert(aa.getLastUpdateDate().getValue(),"yyyy-MM-dd"));
			System.out.println("------------------");
		}
	}
}

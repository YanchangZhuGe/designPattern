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
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ��ǿ��Feb 10, 2012
 * 
 * ������
 * 
 * ˵��:
 */
public class ProjectCodeAssignmentWSBean {
	private ILog log;
	
	public ProjectCodeAssignmentWSBean() {
		log = LogFactory.getLogger(ProjectCodeAssignmentWSBean.class);
	}
	
	public List<ProjectCodeAssignment> getProjectCodeAssignmentFromP6(UserToken mcsUser, String filter, String order)throws Exception {
		List<ProjectCodeAssignmentFieldType> fieldTypes = new ArrayList<ProjectCodeAssignmentFieldType>();
		
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_ID);//��Ŀ���
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_NAME);//��Ŀ��
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_OBJECT_ID);//��Ŀ����
		
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_DESCRIPTION);//����������
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_OBJECT_ID);//����������
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_VALUE);//��������ֵ
		
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_TYPE_NAME);//����������������
		fieldTypes.add(ProjectCodeAssignmentFieldType.PROJECT_CODE_TYPE_OBJECT_ID);//������������������
		
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

package com.bgp.mcs.service.pm.service.p6.project.baselineproject;

import java.util.ArrayList;
import java.util.List;

import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.baselineproject.BaselineProject;
import com.primavera.ws.p6.baselineproject.BaselineProjectFieldType;
import com.primavera.ws.p6.baselineproject.BaselineProjectPortType;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，June 4, 2012
 * 
 * 描述：
 * 
 * 说明:
 */
public class BaselineProjectWSBean {
	
	private ILog log;
	
	public BaselineProjectWSBean(){
		log = LogFactory.getLogger(BaselineProjectWSBean.class);
	}
	public boolean deleteBaseLineProject(UserToken mcsUser,List<Integer> projectIds) throws Exception{
		BaselineProjectPortType baselineProjectProtType = P6WSPortTypeFactory.getPortType(BaselineProjectPortType.class, mcsUser);
		return baselineProjectProtType.deleteBaselineProjects(projectIds);
	}
	
	public List<BaselineProject> getBaselineProjectFromP6(UserToken mcsUser, String filter, String order)throws Exception {
		List<BaselineProjectFieldType> fieldTypes = new ArrayList<BaselineProjectFieldType>();
		
		fieldTypes.add(BaselineProjectFieldType.OBJECT_ID);
		fieldTypes.add(BaselineProjectFieldType.ID);
		fieldTypes.add(BaselineProjectFieldType.NAME);
		fieldTypes.add(BaselineProjectFieldType.OBS_NAME);
		fieldTypes.add(BaselineProjectFieldType.OBS_OBJECT_ID);
		fieldTypes.add(BaselineProjectFieldType.ORIGINAL_PROJECT_OBJECT_ID);
		fieldTypes.add(BaselineProjectFieldType.OWNER_RESOURCE_OBJECT_ID);
		fieldTypes.add(BaselineProjectFieldType.WBS_OBJECT_ID);
		fieldTypes.add(BaselineProjectFieldType.STATUS);
		fieldTypes.add(BaselineProjectFieldType.START_DATE);
		fieldTypes.add(BaselineProjectFieldType.FINISH_DATE);
		
		BaselineProjectPortType baselineProjectProtType = P6WSPortTypeFactory.getPortType(BaselineProjectPortType.class, mcsUser);
		List<BaselineProject> list = baselineProjectProtType.readBaselineProjects(fieldTypes, filter, order);
		
		
		return list;
	}

	public static void main(String[] args) throws Exception {
		BaselineProjectWSBean projects = new BaselineProjectWSBean();
		List<BaselineProject> list = projects.getBaselineProjectFromP6(null, null, null);
		for (int i = 0; i < list.size(); i++) {
			BaselineProject project = list.get(i);
			System.out.println(project.getName()+"||"+project.getObjectId()+"||"+project.getOriginalProjectObjectId().getValue()+"||"+project.getStatus());
		}
	}
}

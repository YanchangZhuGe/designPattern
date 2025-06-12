package com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.resourceassignment.ResourceAssignment;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentExtends;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentFieldType;
import com.primavera.ws.p6.resourceassignment.ResourceAssignmentPortType;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Dec 27, 2011
 * 
 * 描述：
 * 
 * 说明:
 */
public class ResourceAssignmentWSBean{
	
	private ILog log;
    
    public ResourceAssignmentWSBean()
    {
        log = LogFactory.getLogger(ResourceAssignmentWSBean.class);
    }
    
    /**
     * 从P6中读取资源分配信息
     * @param mcsUser 用户
     * @param filter 过滤器
     * @param order 排序器
     * @return List
     * @throws Exception
     */
    public List<ResourceAssignmentExtends> getResourceAssignmentFromP6(UserToken mcsUser, String filter, String order)throws Exception {
    	List<ResourceAssignmentFieldType> fieldTypes = new ArrayList<ResourceAssignmentFieldType>();
    	
    	fieldTypes.add(ResourceAssignmentFieldType.PROJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.PROJECT_OBJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTIVITY_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTIVITY_NAME);
    	fieldTypes.add(ResourceAssignmentFieldType.RESOURCE_NAME);
    	fieldTypes.add(ResourceAssignmentFieldType.RESOURCE_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.PLANNED_START_DATE);
    	fieldTypes.add(ResourceAssignmentFieldType.PLANNED_FINISH_DATE);
    	fieldTypes.add(ResourceAssignmentFieldType.PLANNED_DURATION);
    	fieldTypes.add(ResourceAssignmentFieldType.PLANNED_UNITS);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTUAL_START_DATE);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTUAL_FINISH_DATE);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTUAL_THIS_PERIOD_UNITS);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTUAL_UNITS);
    	fieldTypes.add(ResourceAssignmentFieldType.REMAINING_UNITS);
    	fieldTypes.add(ResourceAssignmentFieldType.LAST_UPDATE_DATE);
    	fieldTypes.add(ResourceAssignmentFieldType.LAST_UPDATE_USER);
    	fieldTypes.add(ResourceAssignmentFieldType.OBJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTIVITY_OBJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.RESOURCE_OBJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.RESOURCE_TYPE);
    	
    	fieldTypes.add(ResourceAssignmentFieldType.ACTUAL_COST);
    	fieldTypes.add(ResourceAssignmentFieldType.COST_ACCOUNT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.COST_ACCOUNT_NAME);
    	fieldTypes.add(ResourceAssignmentFieldType.COST_ACCOUNT_OBJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.WBS_OBJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.REMAINING_DURATION);
    	
    	fieldTypes.add(ResourceAssignmentFieldType.START_DATE);
    	fieldTypes.add(ResourceAssignmentFieldType.FINISH_DATE);
    	fieldTypes.add(ResourceAssignmentFieldType.REMAINING_UNITS_PER_TIME);
    	fieldTypes.add(ResourceAssignmentFieldType.ACTUAL_DURATION);
    	
    	fieldTypes.add(ResourceAssignmentFieldType.CALENDAR_NAME);
    	fieldTypes.add(ResourceAssignmentFieldType.CALENDAR_OBJECT_ID);
    	fieldTypes.add(ResourceAssignmentFieldType.AT_COMPLETION_UNITS);
    	
    	ResourceAssignmentPortType resourceAssignmentPortType = P6WSPortTypeFactory.getPortType(ResourceAssignmentPortType.class, mcsUser);
    	
    	List<ResourceAssignment> list = resourceAssignmentPortType.readResourceAssignments(fieldTypes, filter, order);
    	
    	ResourceAssignmentMCSBean s = new ResourceAssignmentMCSBean();
    	List<ResourceAssignmentExtends> list2 = new ArrayList<ResourceAssignmentExtends>();
		for (int i = 0; i < list.size(); i++) {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("object_id",list.get(i).getObjectId());
			List<Map<String,Object>> list1 = s.queryResourceAssignment(map);
			if (list1 != null && list1.size() > 0) {
				map = list1.get(0);
				ResourceAssignmentExtends ss = new ResourceAssignmentExtends(list.get(i));
				ss.setBsflag("0");
				ss.setBudgetedUnits(((BigDecimal)map.get("BUDGETED_UNITS")).doubleValue());
				ss.setSubmitFlag("0");
				list2.add(ss);
			} else {
				list2.add(new ResourceAssignmentExtends(list.get(i)));
			}
		}
    	
    	return list2;
    }
    
    public boolean updateResourceAssignmentToP6(UserToken mcsUser, List<ResourceAssignment> resourceAssignments) throws Exception {
    	
    	ResourceAssignmentPortType resourceAssignmentPortType = P6WSPortTypeFactory.getPortType(ResourceAssignmentPortType.class, mcsUser);
    	
    	boolean flag = resourceAssignmentPortType.updateResourceAssignments(resourceAssignments);
    	
    	return flag;
    }
    
    public List saveResourceAssignmentToP6(UserToken mcsUser, List<ResourceAssignment> resourceAssignments) throws Exception {
    	
    	ResourceAssignmentPortType resourceAssignmentPortType = P6WSPortTypeFactory.getPortType(ResourceAssignmentPortType.class, mcsUser);
    	
    	List flag = resourceAssignmentPortType.createResourceAssignments(resourceAssignments);
    	
    	return flag;

    }
    
    public static void main(String[] args) throws Exception {
    	ResourceAssignmentWSBean a = new ResourceAssignmentWSBean();
    	List<ResourceAssignmentExtends> list = a.getResourceAssignmentFromP6(null, "ProjectObjectId='1664'", null);
    	
    	//System.out.println("资源代码 || 尚需单位 || 资源类型 || 开始 || 结束");
    	for (int i = 0; i < list.size(); i++) {
    		ResourceAssignmentExtends aa = list.get(i);
    		System.out.println(aa.getResourceAssignment().getResourceName()+"||"+
    				aa.getResourceAssignment().getActualUnits().getValue()+"||"+
    				aa.getResourceAssignment().getActualThisPeriodUnits().getValue()
    				);
		}
	}
    
}

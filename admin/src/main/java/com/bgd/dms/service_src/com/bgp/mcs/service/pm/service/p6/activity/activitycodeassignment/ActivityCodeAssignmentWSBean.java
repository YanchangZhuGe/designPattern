package com.bgp.mcs.service.pm.service.p6.activity.activitycodeassignment;

import java.util.ArrayList;
import java.util.List;
import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.activitycodeassignment.ActivityCodeAssignment;
import com.primavera.ws.p6.activitycodeassignment.ActivityCodeAssignmentFieldType;
import com.primavera.ws.p6.activitycodeassignment.ActivityCodeAssignmentPortType;
import com.primavera.ws.p6.activitycodeassignment.CreateActivityCodeAssignmentsResponse.ObjectId;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：赵学良，Oct 17, 2012
 * 
 * 描述：
 * 
 * 说明：
 */

public class ActivityCodeAssignmentWSBean {
	private ILog log;
	
	public ActivityCodeAssignmentWSBean() {
		log = LogFactory.getLogger(ActivityCodeAssignmentWSBean.class);
	}
	
    /**
     * 从P6中读取任务信息的分类码
     * @param mcsUser 用户 可以为空
     * @param filter 过滤器 WBSObjectId
     * @param order 排序
     */
    public List<ActivityCodeAssignment> getActivityCodeAssignmentFromP6(UserToken mcsUser, String filter, String order)throws Exception {
    	List<ActivityCodeAssignmentFieldType> fieldTypes = new ArrayList<ActivityCodeAssignmentFieldType>();
    	
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_OBJECT_ID); //作业主键
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_ID); //作业主键缩写
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_NAME); //作业名称
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_OBJECT_ID);// 分类码主键
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_VALUE); //分类码值
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_DESCRIPTION); //分类码描述
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_TYPE_OBJECT_ID); //当前分类码的父级
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_TYPE_NAME);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_TYPE_SCOPE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.CREATE_DATE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.CREATE_USER);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.LAST_UPDATE_DATE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.LAST_UPDATE_USER);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.PROJECT_OBJECT_ID);//项目主键	
    	fieldTypes.add(ActivityCodeAssignmentFieldType.PROJECT_ID);//项目编号
    	fieldTypes.add(ActivityCodeAssignmentFieldType.IS_BASELINE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.IS_TEMPLATE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.WBS_OBJECT_ID);
    	
    	ActivityCodeAssignmentPortType ActivityCodeAssignmentPort = P6WSPortTypeFactory.getPortType(ActivityCodeAssignmentPortType.class, mcsUser);
		List<ActivityCodeAssignment> list = ActivityCodeAssignmentPort.readActivityCodeAssignments(fieldTypes, filter, order);
		return list;
    }
    
    /**
     * 修改任务信息保存到P6当中
     * @param mcsUser UserToken 用户
     * @param list List<Activity> 任务列表
     * @return flag boolean 成功与否
     * @throws Exception
     */
    public boolean updateActivityCodeAssignmentToP6(UserToken mcsUser,List<ActivityCodeAssignment> list)throws Exception {
    	
    	ActivityCodeAssignmentPortType ActivityCodeAssignmentPort = P6WSPortTypeFactory.getPortType(ActivityCodeAssignmentPortType.class,mcsUser);
    	boolean flag = ActivityCodeAssignmentPort.updateActivityCodeAssignments(list);
    	return flag;
    }
    
    /**
     * 创建分类码
     * @param mcsUser
     * @param list
     * @return
     * @throws Exception
     */
    public List<ObjectId> createActivityCodeAssignmentToP6(UserToken mcsUser,List<ActivityCodeAssignment> list)throws Exception {
    	
    	ActivityCodeAssignmentPortType ActivityCodeAssignmentPort = P6WSPortTypeFactory.getPortType(ActivityCodeAssignmentPortType.class,mcsUser);
    	List<ObjectId> saveList = ActivityCodeAssignmentPort.createActivityCodeAssignments(list);
    	return saveList;
    }
    
    /**
     * 删除分类码
     * @param mcsUser
     * @param deleteList
     * @return
     * @throws Exception
     */
    public boolean deleteActivityCodeAssignmentToP6(UserToken mcsUser,List<com.primavera.ws.p6.activitycodeassignment.DeleteActivityCodeAssignments.ObjectId> deleteList)throws Exception {
    	
    	ActivityCodeAssignmentPortType ActivityCodeAssignmentPort = P6WSPortTypeFactory.getPortType(ActivityCodeAssignmentPortType.class,mcsUser);
    	boolean flag = ActivityCodeAssignmentPort.deleteActivityCodeAssignments(deleteList);
    	return flag;
    }
    
    public static void main(String[] args) throws Exception {
//    	105618 62869 s2245 ActivityName

    	ActivityCodeAssignment aca = new ActivityCodeAssignment();

    	ActivityCodeAssignmentWSBean s = new ActivityCodeAssignmentWSBean();
    	List<ActivityCodeAssignment> list = s.getActivityCodeAssignmentFromP6(null, "ActivityObjectId=62869", null);
    	for (int i = 0; i < list.size(); i++) {
    		ActivityCodeAssignment a = list.get(i);
    		System.out.println(a.getWBSObjectId().getValue() + "-----" + a.getActivityCodeObjectId()+ "-----" + a.getActivityCodeValue()+"-----"+a.getActivityName()+"-----"+a.getActivityCodeDescription()+"-----"+a.getActivityCodeTypeName());
		}
	}
}

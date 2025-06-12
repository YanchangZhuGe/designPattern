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
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ���ѧ����Oct 17, 2012
 * 
 * ������
 * 
 * ˵����
 */

public class ActivityCodeAssignmentWSBean {
	private ILog log;
	
	public ActivityCodeAssignmentWSBean() {
		log = LogFactory.getLogger(ActivityCodeAssignmentWSBean.class);
	}
	
    /**
     * ��P6�ж�ȡ������Ϣ�ķ�����
     * @param mcsUser �û� ����Ϊ��
     * @param filter ������ WBSObjectId
     * @param order ����
     */
    public List<ActivityCodeAssignment> getActivityCodeAssignmentFromP6(UserToken mcsUser, String filter, String order)throws Exception {
    	List<ActivityCodeAssignmentFieldType> fieldTypes = new ArrayList<ActivityCodeAssignmentFieldType>();
    	
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_OBJECT_ID); //��ҵ����
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_ID); //��ҵ������д
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_NAME); //��ҵ����
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_OBJECT_ID);// ����������
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_VALUE); //������ֵ
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_DESCRIPTION); //����������
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_TYPE_OBJECT_ID); //��ǰ������ĸ���
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_TYPE_NAME);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.ACTIVITY_CODE_TYPE_SCOPE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.CREATE_DATE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.CREATE_USER);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.LAST_UPDATE_DATE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.LAST_UPDATE_USER);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.PROJECT_OBJECT_ID);//��Ŀ����	
    	fieldTypes.add(ActivityCodeAssignmentFieldType.PROJECT_ID);//��Ŀ���
    	fieldTypes.add(ActivityCodeAssignmentFieldType.IS_BASELINE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.IS_TEMPLATE);
    	fieldTypes.add(ActivityCodeAssignmentFieldType.WBS_OBJECT_ID);
    	
    	ActivityCodeAssignmentPortType ActivityCodeAssignmentPort = P6WSPortTypeFactory.getPortType(ActivityCodeAssignmentPortType.class, mcsUser);
		List<ActivityCodeAssignment> list = ActivityCodeAssignmentPort.readActivityCodeAssignments(fieldTypes, filter, order);
		return list;
    }
    
    /**
     * �޸�������Ϣ���浽P6����
     * @param mcsUser UserToken �û�
     * @param list List<Activity> �����б�
     * @return flag boolean �ɹ����
     * @throws Exception
     */
    public boolean updateActivityCodeAssignmentToP6(UserToken mcsUser,List<ActivityCodeAssignment> list)throws Exception {
    	
    	ActivityCodeAssignmentPortType ActivityCodeAssignmentPort = P6WSPortTypeFactory.getPortType(ActivityCodeAssignmentPortType.class,mcsUser);
    	boolean flag = ActivityCodeAssignmentPort.updateActivityCodeAssignments(list);
    	return flag;
    }
    
    /**
     * ����������
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
     * ɾ��������
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

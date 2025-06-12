package com.bgp.mcs.service.pm.service.p6.activity;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.ws.Holder;

import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.activity.Activity;
import com.primavera.ws.p6.activity.ActivityFieldType;
import com.primavera.ws.p6.activity.ActivityPortType;

/**
 * 
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ��ǿ��Dec 26, 2011
 * 
 * ������
 * 
 * ˵��:
 */
public class ActivityWSBean {
	
	private ILog log;
	
	public ActivityWSBean() {
		log = LogFactory.getLogger(ActivityWSBean.class);
	}
	
	/**
     * ��P6�ж�ȡ������Ϣ �õ������wbs���������µ���������
     * @param mcsUser �û� ����Ϊ��
     * @param wbsObjectId int wbs���� 
     * @param filter ������ WBSObjectId
     * @param order ����
     */
    public List<Activity> getActivityFromP6(UserToken mcsUser, int wbsObjectId,String filter, String order)throws Exception {
    	List<ActivityFieldType> fieldTypes = new ArrayList<ActivityFieldType>();
    	fieldTypes.add(ActivityFieldType.ID);
    	fieldTypes.add(ActivityFieldType.NAME);
    	fieldTypes.add(ActivityFieldType.OBJECT_ID);
    	fieldTypes.add(ActivityFieldType.STATUS);
    	fieldTypes.add(ActivityFieldType.PROJECT_ID);
    	fieldTypes.add(ActivityFieldType.PROJECT_NAME);
    	fieldTypes.add(ActivityFieldType.PROJECT_OBJECT_ID);
    	fieldTypes.add(ActivityFieldType.TYPE);
    	fieldTypes.add(ActivityFieldType.WBS_NAME);
    	fieldTypes.add(ActivityFieldType.WBS_CODE);
    	fieldTypes.add(ActivityFieldType.WBS_OBJECT_ID);
    	fieldTypes.add(ActivityFieldType.ACTUAL_FINISH_DATE);
    	fieldTypes.add(ActivityFieldType.ACTUAL_START_DATE);
    	fieldTypes.add(ActivityFieldType.START_DATE);//��ʼʱ��
    	fieldTypes.add(ActivityFieldType.FINISH_DATE);//����ʱ��
    	fieldTypes.add(ActivityFieldType.PLANNED_START_DATE);
    	fieldTypes.add(ActivityFieldType.PLANNED_FINISH_DATE);
    	fieldTypes.add(ActivityFieldType.SUSPEND_DATE);
    	fieldTypes.add(ActivityFieldType.RESUME_DATE);
    	fieldTypes.add(ActivityFieldType.NOTES_TO_RESOURCES);
    	
    	fieldTypes.add(ActivityFieldType.PLANNED_DURATION);
    	fieldTypes.add(ActivityFieldType.EXPECTED_FINISH_DATE);
    	
    	fieldTypes.add(ActivityFieldType.LAST_UPDATE_DATE);
    	fieldTypes.add(ActivityFieldType.LAST_UPDATE_USER);
    	
    	fieldTypes.add(ActivityFieldType.REMAINING_DURATION);
    	fieldTypes.add(ActivityFieldType.CALENDAR_NAME);
    	fieldTypes.add(ActivityFieldType.CALENDAR_OBJECT_ID);    
    	
    	fieldTypes.add(ActivityFieldType.BASELINE_START_DATE);//���߿�ʼʱ��;
    	fieldTypes.add(ActivityFieldType.BASELINE_FINISH_DATE);//���߽���ʱ��
    	
    	fieldTypes.add(ActivityFieldType.PERCENT_COMPLETE);
    	fieldTypes.add(ActivityFieldType.PERCENT_COMPLETE_TYPE);
    	
    	ActivityPortType ActivityServicePort = P6WSPortTypeFactory.getPortType(ActivityPortType.class, mcsUser);
    	
		List<Activity> list = ActivityServicePort.readAllActivitiesByWBS(wbsObjectId, fieldTypes, filter, order);
		return list;
    }
    
    
    /**
     * ��P6�ж�ȡ������Ϣ
     * @param mcsUser �û� ����Ϊ��
     * @param filter ������ WBSObjectId
     * @param order ����
     */
    public List<Activity> getActivityFromP6(UserToken mcsUser, String filter, String order)throws Exception {
    	List<ActivityFieldType> fieldTypes = new ArrayList<ActivityFieldType>();
    	fieldTypes.add(ActivityFieldType.ID);
    	fieldTypes.add(ActivityFieldType.NAME);
    	fieldTypes.add(ActivityFieldType.OBJECT_ID);
    	fieldTypes.add(ActivityFieldType.STATUS);
    	fieldTypes.add(ActivityFieldType.PROJECT_ID);
    	fieldTypes.add(ActivityFieldType.PROJECT_NAME);
    	fieldTypes.add(ActivityFieldType.PROJECT_OBJECT_ID);
    	fieldTypes.add(ActivityFieldType.TYPE);
    	fieldTypes.add(ActivityFieldType.WBS_NAME);
    	fieldTypes.add(ActivityFieldType.WBS_CODE);
    	fieldTypes.add(ActivityFieldType.WBS_OBJECT_ID);
    	fieldTypes.add(ActivityFieldType.ACTUAL_FINISH_DATE);
    	fieldTypes.add(ActivityFieldType.ACTUAL_START_DATE);
    	fieldTypes.add(ActivityFieldType.START_DATE);//��ʼʱ��
    	fieldTypes.add(ActivityFieldType.FINISH_DATE);//����ʱ��
    	fieldTypes.add(ActivityFieldType.PLANNED_START_DATE);
    	fieldTypes.add(ActivityFieldType.PLANNED_FINISH_DATE);
    	fieldTypes.add(ActivityFieldType.SUSPEND_DATE);
    	fieldTypes.add(ActivityFieldType.RESUME_DATE);
    	fieldTypes.add(ActivityFieldType.NOTES_TO_RESOURCES);
    	
    	fieldTypes.add(ActivityFieldType.PLANNED_DURATION);
    	fieldTypes.add(ActivityFieldType.EXPECTED_FINISH_DATE);
    	
    	fieldTypes.add(ActivityFieldType.LAST_UPDATE_DATE);
    	fieldTypes.add(ActivityFieldType.LAST_UPDATE_USER);
    	
    	fieldTypes.add(ActivityFieldType.REMAINING_DURATION);
    	fieldTypes.add(ActivityFieldType.CALENDAR_NAME);
    	fieldTypes.add(ActivityFieldType.CALENDAR_OBJECT_ID);
    	
    	fieldTypes.add(ActivityFieldType.BASELINE_START_DATE);//���߿�ʼʱ��;
    	fieldTypes.add(ActivityFieldType.BASELINE_FINISH_DATE);//���߽���ʱ��
    	
    	fieldTypes.add(ActivityFieldType.PERCENT_COMPLETE);
    	fieldTypes.add(ActivityFieldType.PERCENT_COMPLETE_TYPE);
    	
    	ActivityPortType ActivityServicePort = P6WSPortTypeFactory.getPortType(ActivityPortType.class, mcsUser);
    	
		List<Activity> list = ActivityServicePort.readActivities(fieldTypes, filter, order);
		return list;
    }
    
    /**
     * �޸�������Ϣ���浽P6����
     * @param mcsUser UserToken �û�
     * @param list List<Activity> �����б�
     * @return flag boolean �ɹ����
     * @throws Exception
     */
    public boolean updateActivityToP6(UserToken mcsUser,List<Activity> list)throws Exception {
    	
    	ActivityPortType ActivityServicePort = P6WSPortTypeFactory.getPortType(ActivityPortType.class,mcsUser);
    	boolean flag = ActivityServicePort.updateActivities(list);
    	return flag;
    }
    /**
     * ��P6д��������Ϣ 
     * @param mcsUser
     * @param filter
     * @param order
     * @return
     * @throws Exception
     */
    public int addActivity(UserToken mcsUser,List<Activity> activityList)throws Exception {
    	//List<Activity> activityList = new ArrayList<Activity>();
    	//Activity a = new Activity();
    	//a.setName("���� д����ҵ");
    	//a.setProjectObjectId(4351);
    	//a.setWBSObjectId(P6TypeConvert.convertInteger("WBSObjectId", "34836"));
    	//activityList.add(a);
    	
    	ActivityPortType ActivityServicePort = P6WSPortTypeFactory.getPortType(ActivityPortType.class,mcsUser);
    	List<Integer> ids = ActivityServicePort.createActivities(activityList);    	
    	return ids.get(0).intValue();
    }
    
    /**
     * ɾ����ҵ
     * @param mcsUser
     * @param activityObjectIdList
     * @return
     * @throws Exception
     */
    public boolean deleteActivity(UserToken mcsUser,List<Integer> activityObjectIdList)throws Exception {
    	ActivityPortType ActivityServicePort = P6WSPortTypeFactory.getPortType(ActivityPortType.class,mcsUser);
    	boolean deleteFlag = ActivityServicePort.deleteActivities(activityObjectIdList);	
    	return deleteFlag;
    }
    
    /**
     * ������ҵ
     * @param mcsUser
     * @param activityList
     * @param targetProjectObjectId
     * @param targetWBSObjectId
     * @throws Exception
     */
    public void copyActivity(UserToken mcsUser,List<Map> activityList,int targetProjectObjectId,int targetWBSObjectId) throws Exception{
    	ActivityPortType ActivityServicePort = P6WSPortTypeFactory.getPortType(ActivityPortType.class,mcsUser);
    	
    	if(activityList != null && activityList.size() > 0 ){
    		for(int i=0;i<activityList.size();i++){
    			Map activityMap = activityList.get(i);
    			String obejctId = activityMap.get("objectId") != null ? activityMap.get("objectId").toString() : "";
    			if(obejctId != ""){

        			Holder<Integer> objectId = new Holder<Integer>(new Integer(obejctId));
        	    	ActivityServicePort.copyActivity(objectId, targetProjectObjectId, targetWBSObjectId, null, false, true, false, false, false, false, false, false);

    			}
    		}
    	}
    }
    public static void main(String[] args) throws Exception {
//    	105618
    	ActivityWSBean s = new ActivityWSBean();
    	List<Activity> list = s.getActivityFromP6(null, "WBSObjectId=1", null);
    	for (int i = 0; i < list.size(); i++) {
    		Activity a = list.get(i);
    		System.out.println(a.getName() + "-----" + a.getPercentComplete().getValue()+ "-----" + a.getPercentCompleteType());
		}
	}
}

package com.bgp.mcs.service.pm.service.p6.activity.relationship;

import java.util.ArrayList;
import java.util.List;

import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.relationship.Relationship;
import com.primavera.ws.p6.relationship.RelationshipFieldType;
import com.primavera.ws.p6.relationship.RelationshipPortType;

/**
 * 
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ��ǿ��2012 5 17
 * 
 * ������
 * 
 * ˵��:
 */
public class RelationshipWSBean {
	
	private ILog log;
	
	public RelationshipWSBean(){
		log = LogFactory.getLogger(RelationshipWSBean.class);
	}
	
	public List<Relationship> getRelationshipFromP6(UserToken mcsUser, String filter, String order)throws Exception {
		List<RelationshipFieldType> fieldTypes = new ArrayList<RelationshipFieldType>();
		
		fieldTypes.add(RelationshipFieldType.OBJECT_ID);//����
		
		fieldTypes.add(RelationshipFieldType.CREATE_DATE);
		fieldTypes.add(RelationshipFieldType.CREATE_USER);
		fieldTypes.add(RelationshipFieldType.LAST_UPDATE_DATE);
		fieldTypes.add(RelationshipFieldType.LAST_UPDATE_USER);
		
//		string
//		'Finish to Start'  2
//		'Finish to Finish' 3
//		'Start to Start' 0
//		'Start to Finish'  1
		fieldTypes.add(RelationshipFieldType.TYPE);//��ϵ����
		
		//ǰ��
		fieldTypes.add(RelationshipFieldType.PREDECESSOR_ACTIVITY_ID);//������
		fieldTypes.add(RelationshipFieldType.PREDECESSOR_ACTIVITY_NAME);//������
		fieldTypes.add(RelationshipFieldType.PREDECESSOR_ACTIVITY_OBJECT_ID);//��������
//		string
//		'Task Dependent'
//		'Resource Dependent'
//		'Level of Effort'
//		'Start Milestone'
//		'Finish Milestone'
//		'WBS Summary'
		fieldTypes.add(RelationshipFieldType.PREDECESSOR_ACTIVITY_TYPE);//ǰ����������
		fieldTypes.add(RelationshipFieldType.PREDECESSOR_PROJECT_ID);//ǰ������������Ŀ���
		fieldTypes.add(RelationshipFieldType.PREDECESSOR_PROJECT_OBJECT_ID);//ǰ������������Ŀ����
		
		
		//���
		fieldTypes.add(RelationshipFieldType.SUCCESSOR_ACTIVITY_ID);//������
		fieldTypes.add(RelationshipFieldType.SUCCESSOR_ACTIVITY_NAME);//������
		fieldTypes.add(RelationshipFieldType.SUCCESSOR_ACTIVITY_OBJECT_ID);//��������
//		string
//		'Task Dependent'
//		'Resource Dependent'
//		'Level of Effort'
//		'Start Milestone'
//		'Finish Milestone'
//		'WBS Summary'
		fieldTypes.add(RelationshipFieldType.SUCCESSOR_ACTIVITY_TYPE);//�����������
		fieldTypes.add(RelationshipFieldType.SUCCESSOR_PROJECT_ID);//�������������Ŀ���
		fieldTypes.add(RelationshipFieldType.SUCCESSOR_PROJECT_OBJECT_ID);//�������������Ŀ����
		fieldTypes.add(RelationshipFieldType.LAG);//��ʱ
		
		RelationshipPortType RelationshipServicePort = P6WSPortTypeFactory.getPortType(RelationshipPortType.class, mcsUser);
		List<Relationship> list = RelationshipServicePort.readRelationships(fieldTypes, filter, order);
		
		return list;
	}
	/**
	 * ������ҵ��ǰ���ϵ
	 * @param mcsUser
	 * @param wbsList
	 * @return
	 * @throws Exception
	 */
    public int addRelationship(UserToken mcsUser, List<Relationship> relationshipList)throws Exception {
    	
    	RelationshipPortType RelationshipServicePort = P6WSPortTypeFactory.getPortType(RelationshipPortType.class, mcsUser);
    	List<Integer> ids = RelationshipServicePort.createRelationships(relationshipList);
    	return ids.get(0).intValue();
    }
    
    public boolean updateRelationship(UserToken mcsUser, List<Relationship> relationshipList)throws Exception {
    	
    	RelationshipPortType RelationshipServicePort = P6WSPortTypeFactory.getPortType(RelationshipPortType.class, mcsUser);
    	return  RelationshipServicePort.updateRelationships(relationshipList);
    	
    }
    
    public boolean deleteRelationship(UserToken mcsUser, List<Integer> relationObjectIds)throws Exception {
    	
    	RelationshipPortType RelationshipServicePort = P6WSPortTypeFactory.getPortType(RelationshipPortType.class, mcsUser);
    	return RelationshipServicePort.deleteRelationships(relationObjectIds);
    }
	
	public static void main(String[] args) throws Exception {
		RelationshipWSBean rr = new RelationshipWSBean();
		//List<Relationship> list = rr.getRelationshipFromP6(null, "PredecessorProjectObjectId = '1664'", null);
		List<Relationship> list = rr.getRelationshipFromP6(null, "PredecessorActivityObjectId = 62989", null);
		//List<Relationship> list = rr.getRelationshipFromP6(null, "SuccessorActivityObjectId = 62989", null);
		System.out.println("list is:"+list);
		for (int i = 0; i < list.size(); i++) {
			Relationship r = list.get(i);
			System.out.println(r.getObjectId()+"=="+r.getPredecessorActivityName()+"==="+r.getSuccessorActivityName()+"==="+r.getPredecessorProjectObjectId().getValue()+"==="+r.getSuccessorProjectObjectId().getValue()+"==="+r.getType()+"=="+r.getPredecessorActivityId());
		}
	}
}

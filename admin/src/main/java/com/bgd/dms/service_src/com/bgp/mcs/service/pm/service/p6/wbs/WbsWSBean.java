package com.bgp.mcs.service.pm.service.p6.wbs;

import java.util.ArrayList;
import java.util.List;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.wbs.WBS;
import com.primavera.ws.p6.wbs.WBSFieldType;
import com.primavera.ws.p6.wbs.WBSPortType;

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
public class WbsWSBean {
	
	private ILog log;
	
	public WbsWSBean() {
		log = LogFactory.getLogger(WbsWSBean.class);
	}
	
	/**
     * ��P6�ж�ȡwbs��Ϣ �õ���������������µ�����wbs
     * @param mcsUser �û� ����Ϊ��
     * @param objectId int wbsId--P6�е�WbsId(����) 
     * @param filter ������ ParentObjectId
     * @param order ���� SequenceNumber
     */
    public List<WBS> getWbsFromP6(UserToken mcsUser, int objectId, String filter, String order)throws Exception {
    	List<WBSFieldType> fieldTypes = new ArrayList<WBSFieldType>();
    	fieldTypes.add(WBSFieldType.PARENT_OBJECT_ID);
    	fieldTypes.add(WBSFieldType.NAME);
    	fieldTypes.add(WBSFieldType.CODE);
    	fieldTypes.add(WBSFieldType.PROJECT_OBJECT_ID);
    	fieldTypes.add(WBSFieldType.PROJECT_ID);
    	fieldTypes.add(WBSFieldType.SEQUENCE_NUMBER);
    	fieldTypes.add(WBSFieldType.OBS_NAME);
    	fieldTypes.add(WBSFieldType.OBS_OBJECT_ID);
    	
    	fieldTypes.add(WBSFieldType.LAST_UPDATE_DATE);
    	
    	fieldTypes.add(WBSFieldType.START_DATE);//��ʼʱ��
    	fieldTypes.add(WBSFieldType.FINISH_DATE);//����ʱ��
    	
    	
    	fieldTypes.add(WBSFieldType.OBJECT_ID);
    	
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_START_DATE);//�ƻ���ʼʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_FINISH_DATE);//�ƻ�����ʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_START_DATE);//ʵ�ʿ�ʼʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_FINISH_DATE);//ʵ�ʽ���ʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_START_DATE);//���߿�ʼʱ��;
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_FINISH_DATE);//���߽���ʱ��;
    	
    	WBSPortType WBSServicePort = P6WSPortTypeFactory.getPortType(WBSPortType.class, mcsUser);
    	
		List<WBS> list = WBSServicePort.readAllWBS(objectId, fieldTypes, filter, order);
		
		return list;
    }
    
    /**
     * ��P6�ж�ȡwbs��Ϣ
     * @param mcsUser �û� ����Ϊ��
     * @param filter ������ ParentObjectId
     * @param order ���� SequenceNumber
     */
    public List<WBS> getWbsFromP6(UserToken mcsUser, String filter, String order)throws Exception {
    	
    	System.out.println("getWbsFromP6!!!!!!!!!!!!!!!");
    	
    	List<WBSFieldType> fieldTypes = new ArrayList<WBSFieldType>();
    	fieldTypes.add(WBSFieldType.PARENT_OBJECT_ID);
    	fieldTypes.add(WBSFieldType.NAME);
    	fieldTypes.add(WBSFieldType.CODE);
    	fieldTypes.add(WBSFieldType.PROJECT_OBJECT_ID);
    	fieldTypes.add(WBSFieldType.PROJECT_ID);
    	fieldTypes.add(WBSFieldType.SEQUENCE_NUMBER);
    	fieldTypes.add(WBSFieldType.OBS_NAME);
    	fieldTypes.add(WBSFieldType.OBS_OBJECT_ID);
    	
    	fieldTypes.add(WBSFieldType.LAST_UPDATE_DATE);
    	
    	fieldTypes.add(WBSFieldType.START_DATE);//��ʼʱ��
    	fieldTypes.add(WBSFieldType.FINISH_DATE);//����ʱ��
    	
    	fieldTypes.add(WBSFieldType.OBJECT_ID);
    	
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_START_DATE);//�ƻ���ʼʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_FINISH_DATE);//�ƻ�����ʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_START_DATE);//ʵ�ʿ�ʼʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_FINISH_DATE);//ʵ�ʽ���ʱ��
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_START_DATE);//���߿�ʼʱ��;
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_FINISH_DATE);//���߽���ʱ��;
    	
    	fieldTypes.add(WBSFieldType.SUMMARY_REMAINING_DURATION);
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_DURATION);
    	fieldTypes.add(WBSFieldType.CODE);
    	fieldTypes.add(WBSFieldType.CREATE_DATE);
    	
    	WBSPortType WBSServicePort = P6WSPortTypeFactory.getPortType(WBSPortType.class, mcsUser);
    	
		List<WBS> list = WBSServicePort.readWBS(fieldTypes, filter, order);
		
		return list;
    }
    /**
     * ��P6����wbs
     * @param mcsUser
     * @param filter
     * @param order
     * @return
     * @throws Exception
     */
    public int addWbs(UserToken mcsUser, List<WBS> wbsList)throws Exception {
    	
    	WBSPortType WBSServicePort = P6WSPortTypeFactory.getPortType(WBSPortType.class, mcsUser);
    	List<Integer> ids = WBSServicePort.createWBS(wbsList);
    	return ids.get(0).intValue();
    }
    
    /**
     * ɾ��WBS
     * @param mcsUser
     * @param wbsList
     * @return
     * @throws Exception
     */
    public boolean deleteWbs(UserToken mcsUser, List<Integer> wbsObjectIdList)throws Exception {
    	WBSPortType WBSServicePort = P6WSPortTypeFactory.getPortType(WBSPortType.class, mcsUser);
    	boolean deleteFlag = WBSServicePort.deleteWBS(wbsObjectIdList, null);
    	return deleteFlag;
    }
    
    /**
     * ����WBS
     * @param mcsUser
     * @param wbsList
     * @return
     * @throws Exception
     */
    public boolean updateWbs(UserToken mcsUser, List<WBS> wbsList)throws Exception {
    	WBSPortType WBSServicePort = P6WSPortTypeFactory.getPortType(WBSPortType.class, mcsUser);
    	boolean updateFlag = WBSServicePort.updateWBS(wbsList);
    	return updateFlag;
    }
    public static void main(String[] args) throws Exception {
    	WbsWSBean w = new WbsWSBean();
    	List<WBS> list = w.getWbsFromP6(null, "ObjectId = 13002", null);
    	for (int i = 0; i < list.size(); i++) {
    		WBS s = list.get(i);
    		System.out.println("ObjectId="+s.getObjectId()+" Name="+s.getName()+" startDate="+P6TypeConvert.convert(s.getStartDate(),"yyyy-MM-dd")+"SUMMARY_PLANNED_START_DATE ="+s.getSummaryRemainingDuration().getValue()+",the code is:"+s.getCode()+",the create date is:"+P6TypeConvert.convert(s.getCreateDate(),"yyyy-MM-dd"));
		}
	}
    
}

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
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Dec 26, 2011
 * 
 * 描述：
 * 
 * 说明:
 */
public class WbsWSBean {
	
	private ILog log;
	
	public WbsWSBean() {
		log = LogFactory.getLogger(WbsWSBean.class);
	}
	
	/**
     * 从P6中读取wbs信息 得到传入的主键隶属下的所有wbs
     * @param mcsUser 用户 可以为空
     * @param objectId int wbsId--P6中的WbsId(主键) 
     * @param filter 过滤器 ParentObjectId
     * @param order 排序 SequenceNumber
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
    	
    	fieldTypes.add(WBSFieldType.START_DATE);//开始时间
    	fieldTypes.add(WBSFieldType.FINISH_DATE);//结束时间
    	
    	
    	fieldTypes.add(WBSFieldType.OBJECT_ID);
    	
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_START_DATE);//计划开始时间
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_FINISH_DATE);//计划结束时间
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_START_DATE);//实际开始时间
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_FINISH_DATE);//实际结束时间
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_START_DATE);//基线开始时间;
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_FINISH_DATE);//基线结束时间;
    	
    	WBSPortType WBSServicePort = P6WSPortTypeFactory.getPortType(WBSPortType.class, mcsUser);
    	
		List<WBS> list = WBSServicePort.readAllWBS(objectId, fieldTypes, filter, order);
		
		return list;
    }
    
    /**
     * 从P6中读取wbs信息
     * @param mcsUser 用户 可以为空
     * @param filter 过滤器 ParentObjectId
     * @param order 排序 SequenceNumber
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
    	
    	fieldTypes.add(WBSFieldType.START_DATE);//开始时间
    	fieldTypes.add(WBSFieldType.FINISH_DATE);//结束时间
    	
    	fieldTypes.add(WBSFieldType.OBJECT_ID);
    	
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_START_DATE);//计划开始时间
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_FINISH_DATE);//计划结束时间
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_START_DATE);//实际开始时间
    	fieldTypes.add(WBSFieldType.SUMMARY_ACTUAL_FINISH_DATE);//实际结束时间
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_START_DATE);//基线开始时间;
    	fieldTypes.add(WBSFieldType.SUMMARY_BASELINE_FINISH_DATE);//基线结束时间;
    	
    	fieldTypes.add(WBSFieldType.SUMMARY_REMAINING_DURATION);
    	fieldTypes.add(WBSFieldType.SUMMARY_PLANNED_DURATION);
    	fieldTypes.add(WBSFieldType.CODE);
    	fieldTypes.add(WBSFieldType.CREATE_DATE);
    	
    	WBSPortType WBSServicePort = P6WSPortTypeFactory.getPortType(WBSPortType.class, mcsUser);
    	
		List<WBS> list = WBSServicePort.readWBS(fieldTypes, filter, order);
		
		return list;
    }
    /**
     * 向P6新增wbs
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
     * 删除WBS
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
     * 更新WBS
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

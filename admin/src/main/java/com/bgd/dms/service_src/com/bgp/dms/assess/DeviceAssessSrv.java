package com.bgp.dms.assess;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import com.bgp.dms.device.DeviceAnalSrv;
import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
import com.bgp.gms.service.rm.dm.constants.DevConstants;

/**
 * project: 设备体系信息化建设
 * 
 * creator: dz
 * 
 * creator time:2015-5-6
 * 
 * description:设备考核操作相关服务
 * 
 */
@Service("DeviceAssessSrv")
@SuppressWarnings({"unchecked","unused"})
public class DeviceAssessSrv extends BaseService {
	
	public DeviceAssessSrv() {
		log = LogFactory.getLogger(DeviceAssessSrv.class);
	}
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	/**
	 * NEWMETHOD
	 * 保存考核指标信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAssessInfo(ISrvMsg msg) throws Exception {
		log.info("saveAssessInfo");
		//1.获得基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		String assess_mainid = msg.getValue("assess_mainid");
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//当前登录用户的ID
		String employee_id = user.getEmpId();
		if(assess_mainid!=null&&!"".equals(assess_mainid)){
			mainMap.put("assess_mainid", assess_mainid);
			mainMap.put("assess_dev_type", msg.getValue("dev_type_value"));
			mainMap.put("assess_account_stat", msg.getValue("account_stat_value"));
			mainMap.put("assess_ifproduction", msg.getValue("dev_produce_value"));
			mainMap.put("assess_ifcountry", msg.getValue("dev_ifcountry_value"));
			mainMap.put("create_org_id", user.getCodeAffordOrgID());
			mainMap.put("modifier", employee_id);
			mainMap.put("modify_date", currentdate);
			mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			mainMap.put("assess_ceiling", msg.getValue("assess_ceiling"));
			mainMap.put("assess_floor", msg.getValue("assess_floor"));
		}else{
			mainMap.put("assess_type", msg.getValue("assess_type"));
			mainMap.put("assess_dev_type", msg.getValue("dev_type_value"));
			mainMap.put("assess_account_stat", msg.getValue("account_stat_value"));
			mainMap.put("assess_ifproduction", msg.getValue("dev_produce_value"));
			mainMap.put("assess_ifcountry", msg.getValue("dev_ifcountry_value"));
			mainMap.put("create_org_id", user.getCodeAffordOrgID());
			mainMap.put("creator", employee_id);
			mainMap.put("create_date", currentdate);
			mainMap.put("modifier", employee_id);
			mainMap.put("modify_date", currentdate);
			mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			mainMap.put("assess_ceiling", msg.getValue("assess_ceiling"));
			mainMap.put("assess_floor", msg.getValue("assess_floor"));
		}
		jdbcDao.saveOrUpdateEntity(mainMap, "dms_device_assess_main");
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 保存考核指标信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrgAssessInfo(ISrvMsg msg) throws Exception {
		log.info("saveOrgAssessInfo");
		//1.获得基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
			//当前登录用户的ID
		String employee_id = user.getEmpId();
		String select_org = msg.getValue("selectorg");
		System.out.println("select_org == "+select_org);
		Map<String,Object> orgMap = new HashMap<String,Object>();
			orgMap.put("assess_org_id", msg.getValue("assess_org"));
			orgMap.put("assess_type", msg.getValue("assess_type"));
			orgMap.put("assess_value", msg.getValue("assess_value"));
			orgMap.put("create_org_id", user.getCodeAffordOrgID());
			orgMap.put("creator", employee_id);
			orgMap.put("create_date", currentdate);
			orgMap.put("modifier", employee_id);
			orgMap.put("modify_date", currentdate);
			orgMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			orgMap.put("remark", msg.getValue("assess_remark"));
			orgMap.put("assess_org_ceiling", msg.getValue("assess_org_ceiling"));
			orgMap.put("assess_org_floor", msg.getValue("assess_org_floor"));
			jdbcDao.saveOrUpdateEntity(orgMap, "dms_device_org_assess");
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("assessorgid", select_org);
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 修改单位指标权重信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg upOrgAssessInfo(ISrvMsg msg) throws Exception {
		log.info("upOrgAssessInfo");
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		String select_org = msg.getValue("selectorg");
		//当前登录用户的ID
		String employee_id = user.getEmpId();
		String idinfo = msg.getValue("idinfos");
		String[] idinfos = idinfo.split("~", -1);
		String assessnum = msg.getValue("assessnums");
		String[] assessnums = assessnum.split("~", -1);
		String assessceinum = msg.getValue("assessceinums");
		String[] assessceinums = assessceinum.split("~", -1);
		String assessflonum = msg.getValue("assessflonums");
		String[] assessflonums = assessflonum.split("~", -1);
		for(int index=0;index<idinfos.length;index++){
			Map<String,Object> dataMap = new HashMap<String,Object>();
			dataMap.put("assess_id", idinfos[index]);
			dataMap.put("assess_value", assessnums[index]);
			dataMap.put("assess_org_ceiling", assessceinums[index]);
			dataMap.put("assess_org_floor", assessflonums[index]);
			dataMap.put("modify_date", currentdate);
			dataMap.put("modifier", employee_id);
			jdbcDao.saveOrUpdateEntity(dataMap, "dms_device_org_assess");
		}
		
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("assessorgid", select_org);
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 删除指标信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delAssessInfo(ISrvMsg msg) throws Exception {
		log.info("delAssessInfo");
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		//当前登录用户的ID
		String employee_id = user.getEmpId();
		String delassessmainid = msg.getValue("delassessmainid");
		try{
			String delass = "update dms_device_assess_main set bsflag='1',modifier='"+employee_id+"',"
			                +"modify_date=to_date('"+currentdate+"','yyyy-MM-dd HH24:mi:ss') where assess_mainid in ("+delassessmainid+")";
			jdbcDao.executeUpdate(delass);
		}catch(Exception e){
		}
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 删除单位指标权重信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delOrgAssessInfo(ISrvMsg msg) throws Exception {
		log.info("delOrgAssessInfo");
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		//当前登录用户的ID
		String employee_id = user.getEmpId();
		String delassessids = msg.getValue("delassessid");
		try{
			String delass = "update dms_device_org_assess set bsflag='1',modifier='"+employee_id+"',"
			                +"modify_date=to_date('"+currentdate+"','yyyy-MM-dd HH24:mi:ss') where assess_id in ("+delassessids+")";
			jdbcDao.executeUpdate(delass);
		}catch(Exception e){
		}
		//5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}
}

package com.bgp.mcs.service.hse.service;

import java.io.ByteArrayInputStream;
import java.io.Serializable;
import java.net.InetAddress;
import java.net.URLDecoder;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;

public class HseSrv  extends BaseService {

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private HseUtil hseUtil = HseUtil.getInstance();
	
	
	//公共的，根据人员org_subjection_id，查询他的上级单位……………………
	public ISrvMsg queryOrg(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String org_subjection_id = isrvmsg.getValue("org_subjection_id");
		if(org_subjection_id==null || org_subjection_id.trim().equals("")){
			org_subjection_id = user.getOrgSubjectionId();
		}
		boolean flag = true;
		String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		if(list.size()==0){
			flag = false;
		}
		responseDTO.setValue("list", list);
		responseDTO.setValue("flag", flag);
		return responseDTO;

	}
	
	
	//新增隐患记录
	public ISrvMsg addDanger(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String danger_name = isrvmsg.getValue("danger_name");
		String danger_type = isrvmsg.getValue("danger_type");
		String danger_level = isrvmsg.getValue("danger_level");
		String danger_big = isrvmsg.getValue("danger_big");
		String danger_midd = isrvmsg.getValue("danger_midd");
		String danger_place = isrvmsg.getValue("danger_place");
		String danger_date = isrvmsg.getValue("danger_date");
		String danger_effect = isrvmsg.getValue("danger_effect");
		String danger_des = isrvmsg.getValue("danger_des");
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("DANGER_NAME", danger_name);
		map.put("DANGER_TYPE", danger_type);
		map.put("DANGER_LEVEL", danger_level);
		map.put("DANGER_BIG", danger_big);
		map.put("DANGER_MIDD", danger_midd);
		map.put("DANGER_PLACE", danger_place);
		map.put("DANGER_DATE", danger_date);
		map.put("DANGER_EFFECT", danger_effect);
		map.put("DANGER_DES", danger_des);
		map.put("CREATOR_ID", user.getUserId());
		map.put("CREATE_DATE", now);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_HSE_DANGER");
		
		return responseDTO;

	}
	
	public ISrvMsg addDangerModify(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String hse_danger_id = isrvmsg.getValue("hse_danger_id");
		String modify_time = isrvmsg.getValue("modify_time");
		String modify_type = isrvmsg.getValue("modify_type");
		String modify_person = isrvmsg.getValue("modify_person");
		String modify_check = isrvmsg.getValue("modify_check");
		String modify_step = isrvmsg.getValue("modify_step");
		String modify_project = isrvmsg.getValue("modify_project");
		String modify_no_reason = isrvmsg.getValue("modify_no_reason");
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("HSE_DANGER_ID", hse_danger_id);
		map.put("MODIFY_TIME", modify_time);
		map.put("MODIFY_TYPE", modify_type);
		map.put("MODIFY_PERSON", modify_person);
		map.put("MODIFY_CHECK", modify_check);
		map.put("MODIFY_STEP", modify_step);
		map.put("MODIFY_PROJECT", modify_project);
		map.put("MODIFY_NO_REASON", modify_no_reason);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_HSE_DANGER");
		
		return responseDTO;

	}
	
	public ISrvMsg addDangerReward(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_danger_id = isrvmsg.getValue("hse_danger_id");
		String reward_type = isrvmsg.getValue("reward_type");
		String reward_level = isrvmsg.getValue("reward_level");
		String reward_date = isrvmsg.getValue("reward_date");
		String reward_money = isrvmsg.getValue("reward_money");
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("HSE_DANGER_ID", hse_danger_id);
		map.put("REWARD_TYPE", reward_type);
		map.put("REWARD_LEVEL", reward_level);
		map.put("REWARD_DATE", reward_date);
		map.put("REWARD_MONEY", reward_money);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_HSE_DANGER");
		
		return responseDTO;

	}
	
	public ISrvMsg viewDanger(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_danger_id = isrvmsg.getValue("hse_danger_id");
		
		String sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_danger t left join comm_org_subjection os1 on t.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on t.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0'  left join comm_org_subjection os3 on t.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0'  where t.bsflag='0' and t.hse_danger_id='"+hse_danger_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		System.out.println("******************************************"+map);
		responseDTO.setValue("hse_danger_id", hse_danger_id);
		responseDTO.setValue("map", map);
		return responseDTO;

	}
	
	public ISrvMsg editDanger(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_danger_id = isrvmsg.getValue("hse_danger_id");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String danger_name = isrvmsg.getValue("danger_name");
		String danger_type = isrvmsg.getValue("danger_type");
		String danger_level = isrvmsg.getValue("danger_level");
		String danger_big = isrvmsg.getValue("danger_big");
		String danger_midd = isrvmsg.getValue("danger_midd");
		String danger_place = isrvmsg.getValue("danger_place");
		String danger_date = isrvmsg.getValue("danger_date");
		String danger_effect = isrvmsg.getValue("danger_effect");
		String danger_des = isrvmsg.getValue("danger_des");
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("HSE_DANGER_ID", hse_danger_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("DANGER_NAME", danger_name);
		map.put("DANGER_LEVEL", danger_level);
		map.put("DANGER_TYPE", danger_type);
		map.put("DANGER_BIG", danger_big);
		map.put("DANGER_MIDD", danger_midd);
		map.put("DANGER_PLACE", danger_place);
		map.put("DANGER_DATE", danger_date);
		map.put("DANGER_EFFECT", danger_effect);
		map.put("DANGER_DES", danger_des);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_HSE_DANGER");
		
		return responseDTO;

	}
	//修改隐患基本信息
	public ISrvMsg editDangerInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_danger_id = isrvmsg.getValue("hse_danger_id");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String danger_name = isrvmsg.getValue("danger_name");
		String danger_type = isrvmsg.getValue("danger_type");
		String danger_level = isrvmsg.getValue("danger_level");
		String danger_big = isrvmsg.getValue("danger_big");
		String danger_midd = isrvmsg.getValue("danger_midd");
		String danger_place = isrvmsg.getValue("danger_place");
		String danger_date = isrvmsg.getValue("danger_date");
		String danger_effect = isrvmsg.getValue("danger_effect");
		String danger_des = isrvmsg.getValue("danger_des");
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("HSE_DANGER_ID", hse_danger_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("DANGER_NAME", danger_name);
		map.put("DANGER_TYPE", danger_type);
		map.put("DANGER_LEVEL", danger_level);
		map.put("DANGER_BIG", danger_big);
		map.put("DANGER_MIDD", danger_midd);
		map.put("DANGER_PLACE", danger_place);
		map.put("DANGER_DATE", danger_date);
		map.put("DANGER_EFFECT", danger_effect);
		map.put("DANGER_DES", danger_des);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_HSE_DANGER");
		
		return responseDTO;

	}
	//修改整改信息
	public ISrvMsg editDangerModify(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_danger_id = isrvmsg.getValue("hse_danger_id");
		String modify_type = isrvmsg.getValue("modify_type");
		String modify_person = isrvmsg.getValue("modify_person");
		String modify_check = isrvmsg.getValue("modify_check");
		String modify_step = isrvmsg.getValue("modify_step");
		String modify_time = isrvmsg.getValue("modify_time");
		String modify_no_reason = isrvmsg.getValue("modify_no_reason");
		String modify_project = isrvmsg.getValue("modify_project");
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("HSE_DANGER_ID", hse_danger_id);
		map.put("MODIFY_TYPE", modify_type);
		map.put("MODIFY_PERSON", modify_person);
		map.put("MODIFY_CHECK", modify_check);
		map.put("MODIFY_STEP", modify_step);
		map.put("MODIFY_TIME", modify_time);
		map.put("MODIFY_NO_REASON", modify_no_reason);
		map.put("MODIFY_PROJECT", modify_project);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_HSE_DANGER");
		
		return responseDTO;

	}
	//修改奖励信息
	public ISrvMsg editDangerReward(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_danger_id = isrvmsg.getValue("hse_danger_id");
		String reward_type = isrvmsg.getValue("reward_type");
		String reward_level = isrvmsg.getValue("reward_level");
		String reward_money = isrvmsg.getValue("reward_money");
		String reward_date = isrvmsg.getValue("reward_date");
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("HSE_DANGER_ID", hse_danger_id);
		map.put("REWARD_TYPE", reward_type);
		map.put("REWARD_LEVEL", reward_level);
		map.put("REWARD_MONEY", reward_money);
		map.put("REWARD_DATE", reward_date);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_HSE_DANGER");
		
		return responseDTO;

	}
	
	//删除隐患记录
	public ISrvMsg deleteDanger(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_danger_ids = isrvmsg.getValue("hse_danger_id");
		String ids[] =  hse_danger_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_danger set bsflag = '1' where hse_danger_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;

	}
	
	//事故快报
	public ISrvMsg viewAccident(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_accident_id = isrvmsg.getValue("hse_accident_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_accident_news t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' where t.bsflag = '0' and t.hse_accident_id='"+hse_accident_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		System.out.println("******************************************"+map);
		responseDTO.setValue("hse_accident_id", hse_accident_id);
		responseDTO.setValue("isProject", isProject);
		responseDTO.setValue("map", map);
		return responseDTO;

	}
	
	public ISrvMsg addNewsInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String hse_accident_id = isrvmsg.getValue("hse_accident_id");
		String isProject = isrvmsg.getValue("isProject");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String second_org2 = isrvmsg.getValue("second_org2");
		String third_org2 = isrvmsg.getValue("third_org2");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String accident_name = isrvmsg.getValue("accident_name");
		String accident_type = isrvmsg.getValue("accident_type");
		String accident_date = isrvmsg.getValue("accident_date");
		String accident_place = isrvmsg.getValue("accident_place");
		String workplace_flag = isrvmsg.getValue("workplace_flag");
		String out_flag = isrvmsg.getValue("out_flag");
		String out_name = isrvmsg.getValue("out_name");
		String out_type = isrvmsg.getValue("out_type");
		String accident_money = isrvmsg.getValue("accident_money");
		String number_die = isrvmsg.getValue("number_die");
		String number_harm = isrvmsg.getValue("number_harm");
		String number_injure = isrvmsg.getValue("number_injure");
		String number_lose = isrvmsg.getValue("number_lose");
		String accident_process = isrvmsg.getValue("accident_process");
		String accident_reason = isrvmsg.getValue("accident_reason");
		String accident_result = isrvmsg.getValue("accident_result");
		String accident_sugg = isrvmsg.getValue("accident_sugg");
		String write_date = isrvmsg.getValue("write_date");
		String write_name = isrvmsg.getValue("write_name");
		String duty_name = isrvmsg.getValue("duty_name");
		
		String selectedTagIndex = isrvmsg.getValue("selectedTagIndex");
		if(selectedTagIndex==null||selectedTagIndex.equals("")){
			selectedTagIndex="0";
		}
		int index = Integer.parseInt(selectedTagIndex)+1;
		
		Date now = new Date();
		
		Map map1 = new HashMap();
		map1.put("HSE_ACCIDENT_ID", hse_accident_id);
		map1.put("SECOND_ORG", second_org);
		map1.put("THIRD_ORG", third_org);
		map1.put("FOURTH_ORG", fourth_org);
		map1.put("ACCIDENT_NAME", accident_name);
		map1.put("ACCIDENT_TYPE", accident_type);
		map1.put("ACCIDENT_DATE", accident_date);
		map1.put("ACCIDENT_PLACE", accident_place);
		map1.put("WORKPLACE_FLAG", workplace_flag);
		map1.put("OUT_FLAG", out_flag);
		map1.put("OUT_NAME", out_name);
		map1.put("OUT_TYPE", out_type);
		map1.put("ACCIDENT_MONEY", accident_money);
		
		map1.put("NUMBER_DIE", number_die);
		map1.put("NUMBER_HARM", number_harm);
		map1.put("NUMBER_INJURE", number_injure);
		map1.put("NUMBER_LOSE", number_lose);
		
		map1.put("ACCIDENT_PROCESS", accident_process);
		map1.put("ACCIDENT_REASON", accident_reason);
		map1.put("ACCIDENT_RESULT", accident_result);
		map1.put("ACCIDENT_SUGG", accident_sugg);
		map1.put("WRITE_DATE", write_date);
		map1.put("WRITE_NAME", write_name);
		map1.put("DUTY_NAME", duty_name);
		
		if(hse_accident_id==null||hse_accident_id.equals("")){
			map1.put("CREATOR_ID", user.getUserId());
			map1.put("CREATE_DATE", now);
			if(isProject.equals("2")){
				map1.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map1.put("UPDATOR_ID", user.getUserId());
		map1.put("MODIFI_DATE", now);
		map1.put("BSFLAG", "0");
		
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map1,"BGP_HSE_ACCIDENT_NEWS");
		hse_accident_id = id.toString();
		
		String sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from bgp_hse_accident_news t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' where t.bsflag = '0' and t.hse_accident_id='"+hse_accident_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("hse_accident_id", hse_accident_id);
		responseDTO.setValue("second_org", second_org);
		responseDTO.setValue("second_org2", second_org2);
		responseDTO.setValue("third_org", third_org);
		responseDTO.setValue("third_org2", third_org2);
		responseDTO.setValue("accident_name", accident_name);
		responseDTO.setValue("accident_type", accident_type);
		responseDTO.setValue("accident_date", accident_date);
		responseDTO.setValue("accident_place", accident_place);
		responseDTO.setValue("workplace_flag", workplace_flag);
		responseDTO.setValue("out_flag", out_flag);
		responseDTO.setValue("out_name", out_name);
		responseDTO.setValue("out_type", out_type);
		responseDTO.setValue("accident_money", accident_money);
		responseDTO.setValue("number_die", number_die);
		responseDTO.setValue("number_harm", number_harm);
		responseDTO.setValue("number_injure", number_injure);
		responseDTO.setValue("number_lose", number_lose);
		responseDTO.setValue("accident_process", accident_process);
		responseDTO.setValue("accident_reason", accident_reason);
		responseDTO.setValue("accident_result", accident_result);
		responseDTO.setValue("accident_sugg", accident_sugg);
		responseDTO.setValue("write_date", write_date);
		responseDTO.setValue("write_name", write_name);
		responseDTO.setValue("duty_name", duty_name);
		
		responseDTO.setValue("index", index);
		responseDTO.setValue("map", map);
		responseDTO.setValue("isProject", isProject);
		
		return responseDTO;

	}
	//删除事故快报信息
	public ISrvMsg deleteAccident(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_accident_ids = isrvmsg.getValue("hse_accident_id");
		String ids[] =  hse_accident_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_accident_news set bsflag = '1' where hse_accident_id='"+ids[i]+"'";
			String sql2 = "update bgp_hse_accident_record set bsflag = '1' where hse_accident_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
			jdbcTemplate.execute(sql2);
		}
		
		return responseDTO;

	}
	
	//事件信息报告
	public ISrvMsg viewEvent(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_event_id = isrvmsg.getValue("hse_event_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date from bgp_hse_event t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0'  where t.bsflag = '0' and t.hse_event_id='"+hse_event_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("hse_event_id", hse_event_id);
		responseDTO.setValue("isProject", isProject);
		responseDTO.setValue("map", map);
		return responseDTO;

	}
	
	public ISrvMsg addEvent(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String hse_event_id = isrvmsg.getValue("hse_event_id");
		String isProject = isrvmsg.getValue("isProject");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String second_org2 = isrvmsg.getValue("second_org2");
		String third_org2 = isrvmsg.getValue("third_org2");
		String event_name = isrvmsg.getValue("event_name");
		String event_type = isrvmsg.getValue("event_type");
		String event_property = isrvmsg.getValue("event_property");
		String event_date = isrvmsg.getValue("event_date");
		String event_place = isrvmsg.getValue("event_place");
		String write_date = isrvmsg.getValue("write_date");
		String out_flag = isrvmsg.getValue("out_flag");
		String out_name = isrvmsg.getValue("out_name");
		String report_name = isrvmsg.getValue("report_name");
		String report_date = isrvmsg.getValue("report_date");
		
		String number_owner = isrvmsg.getValue("number_owner");
		String number_out = isrvmsg.getValue("number_out");
		String number_stock = isrvmsg.getValue("number_stock");
		String number_group = isrvmsg.getValue("number_group");
		String number_hours = isrvmsg.getValue("number_hours");
		
		String analyze_name = isrvmsg.getValue("analyze_name");
		String analyze_work = isrvmsg.getValue("analyze_work");
		String result_date = isrvmsg.getValue("result_date");
		String duty_name = isrvmsg.getValue("duty_name");
		String event_process = isrvmsg.getValue("event_process");
		String event_reason = isrvmsg.getValue("event_reason");
		String event_describe = isrvmsg.getValue("event_describe");
		String event_result = isrvmsg.getValue("event_result");
		
		String first_money = isrvmsg.getValue("first_money");
		String second_money = isrvmsg.getValue("second_money");
		String all_money = isrvmsg.getValue("all_money");

//		String selectedTagIndex = isrvmsg.getValue("selectedTagIndex");
//		System.out.println(selectedTagIndex);
//		if(selectedTagIndex==null||selectedTagIndex.equals("")){
//			selectedTagIndex="0";
//		}
//		int index = Integer.parseInt(selectedTagIndex)+1;
		Date now = new Date();
		
		Map map1 = new HashMap();
		map1.put("HSE_EVENT_ID", hse_event_id);
		map1.put("SECOND_ORG", second_org);
		map1.put("THIRD_ORG", third_org);
		map1.put("FOURTH_ORG", fourth_org);
		map1.put("EVENT_NAME", event_name);
		map1.put("EVENT_TYPE", event_type);
		map1.put("EVENT_PROPERTY", event_property);
		map1.put("EVENT_DATE", event_date);
		map1.put("EVENT_PLACE", event_place);
		map1.put("WRITE_DATE", write_date);
		map1.put("OUT_FLAG", out_flag);
		map1.put("OUT_NAME", out_name);
		map1.put("REPORT_NAME", report_name);
		map1.put("REPORT_DATE", report_date);
		
		map1.put("NUMBER_OWNER", number_owner);
		map1.put("NUMBER_OUT", number_out);
		map1.put("NUMBER_STOCK", number_stock);
		map1.put("NUMBER_GROUP", number_group);
		map1.put("NUMBER_HOURS", number_hours);
		
		map1.put("EVENT_PROCESS", event_process);
		map1.put("EVENT_REASON", event_reason);
		map1.put("EVENT_DESCRIBE", event_describe);
		map1.put("ANALYZE_NAME", analyze_name);
		map1.put("ANALYZE_WORK", analyze_work);
		map1.put("EVENT_RESULT", event_result);
		map1.put("RESULT_DATE", result_date);
		map1.put("DUTY_NAME", duty_name);
		
		map1.put("FIRST_MONEY", first_money);
		map1.put("SECOND_MONEY", second_money);
		map1.put("ALL_MONEY", all_money);
		
		if(hse_event_id==null||hse_event_id.equals("")){
			map1.put("CREATOR_ID", user.getUserId());
			map1.put("CREATE_DATE", now);
			if(isProject.equals("2")){
				map1.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map1.put("UPDATOR_ID", user.getUserId());
		map1.put("MODIFI_DATE", now);
		map1.put("BSFLAG", "0");
		
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map1,"BGP_HSE_EVENT");
		hse_event_id = id.toString();
		
		String sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,t.create_date from bgp_hse_event t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' where t.bsflag = '0' and t.hse_event_id='"+hse_event_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("hse_event_id", hse_event_id);
		responseDTO.setValue("second_org", second_org);
		responseDTO.setValue("second_org2", second_org2);
		responseDTO.setValue("third_org", third_org);
		responseDTO.setValue("third_org2", third_org2);
		responseDTO.setValue("event_name", event_name);
		responseDTO.setValue("event_type", event_type);
		responseDTO.setValue("event_property", event_property);
		responseDTO.setValue("event_date", event_date);
		responseDTO.setValue("event_place", event_place);
		responseDTO.setValue("write_date", write_date);
		responseDTO.setValue("out_flag", out_flag);
		responseDTO.setValue("out_name", out_name);
		responseDTO.setValue("report_name", report_name);
		responseDTO.setValue("report_date", report_date);
		
		responseDTO.setValue("number_owner", number_owner);
		responseDTO.setValue("number_out", number_out);
		responseDTO.setValue("number_stock", number_stock);
		responseDTO.setValue("number_group", number_group);
		responseDTO.setValue("number_hours", number_hours);
		
		responseDTO.setValue("event_process", event_process);
		responseDTO.setValue("event_reason", event_reason);
		responseDTO.setValue("event_result", event_result);
		responseDTO.setValue("event_describe", event_describe);
		responseDTO.setValue("analyze_name", analyze_name);
		responseDTO.setValue("analyze_work", analyze_work);
		responseDTO.setValue("result_date", result_date);
		responseDTO.setValue("duty_name", duty_name);

		responseDTO.setValue("first_money", first_money);
		responseDTO.setValue("second_money", second_money);
		responseDTO.setValue("all_money", all_money);

//		responseDTO.setValue("index", index);
		responseDTO.setValue("map", map);
		responseDTO.setValue("isProject", isProject);
		
		return responseDTO;

	}
	//删除信息
	public ISrvMsg deleteEvent(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_event_ids = isrvmsg.getValue("hse_event_id");
		String ids[] =  hse_event_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_event set bsflag = '1' where hse_event_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;

	}
	
	//事故记录
	public ISrvMsg viewRecord(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_accident_id = isrvmsg.getValue("hse_accident_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String sql = "select t.*,r.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name  from bgp_hse_accident_news t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0'  left join bgp_hse_accident_record r on t.hse_accident_id = r.hse_accident_id and r.bsflag = '0' where t.bsflag = '0' and t.hse_accident_id='"+hse_accident_id+"'";
		String sql2 = "select * from bgp_hse_accident_number n where n.bsflag='0' and n.hse_accident_id='"+hse_accident_id+"' order by type asc";
		String sql3 = "select e.* from bgp_hse_accident_news t left join bgp_hse_accident_record r on t.hse_accident_id=r.hse_accident_id and r.bsflag='0' left join bgp_hse_record_environ e on r.hse_record_id=e.hse_record_id where t.bsflag='0' and t.hse_accident_id='"+hse_accident_id+"' order by order_num asc";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		responseDTO.setValue("hse_accident_id", hse_accident_id);
		responseDTO.setValue("isProject", isProject);
		responseDTO.setValue("map", map);
		responseDTO.setValue("list", list);
		responseDTO.setValue("list3", list3);
		return responseDTO;

	}
	
	public ISrvMsg addRecord(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String hse_accident_id = isrvmsg.getValue("hse_accident_id");
		String isProject = isrvmsg.getValue("isProject");
		String hse_record_id = isrvmsg.getValue("hse_record_id");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String second_org2 = isrvmsg.getValue("second_org2");
		String third_org2 = isrvmsg.getValue("third_org2");
		String accident_name = isrvmsg.getValue("accident_name");
		String accident_type = isrvmsg.getValue("accident_type");
		String accident_date = isrvmsg.getValue("accident_date");
		String accident_level = isrvmsg.getValue("accident_level");
		String accident_place = isrvmsg.getValue("accident_place");
		String place_type = isrvmsg.getValue("place_type");
		String bulletin_flag = isrvmsg.getValue("bulletin_flag");
		String case_flag = isrvmsg.getValue("case_flag");
		String case_date = isrvmsg.getValue("case_date");
		String duty_flag = isrvmsg.getValue("duty_flag");
		String workplace_flag = isrvmsg.getValue("workplace_flag");
		String out_flag = isrvmsg.getValue("out_flag");
		String out_name = isrvmsg.getValue("out_name");
		String out_type = isrvmsg.getValue("out_type");
		String accident_course = isrvmsg.getValue("accident_course");
		String number_toxic = isrvmsg.getValue("number_toxic");
		
		String first_reason = isrvmsg.getValue("first_reason");
		String second_reason = isrvmsg.getValue("second_reason");
		String accident_step = isrvmsg.getValue("accident_step");
		String accident_test = isrvmsg.getValue("accident_test");
		String accident_note = isrvmsg.getValue("accident_note");
		String accident_risk = isrvmsg.getValue("accident_risk");
		
		String money_lose = isrvmsg.getValue("money_lose");
		String other_lose = isrvmsg.getValue("other_lose");
		String all_lose = isrvmsg.getValue("all_lose");
		String lose_hours = isrvmsg.getValue("lose_hours");
		
		String report_date = isrvmsg.getValue("report_date");
		String report_name = isrvmsg.getValue("report_name");
		String contact_name = isrvmsg.getValue("contact_name");
		String phone = isrvmsg.getValue("phone");
		String table_date = isrvmsg.getValue("table_date");
		String table_person = isrvmsg.getValue("table_person");
		String duty_id = isrvmsg.getValue("duty_id");
		String lose_id = isrvmsg.getValue("lose_id");
		String stuff_id = isrvmsg.getValue("stuff_id");
		String pollution_type = isrvmsg.getValue("pollution_type");
		
		
		String selectedTagIndex = isrvmsg.getValue("selectedTagIndex");
		if(selectedTagIndex==null||selectedTagIndex.equals("")){
			selectedTagIndex="0";
		}
		int index = Integer.parseInt(selectedTagIndex)+1;
		
		Date now = new Date();
		
		Map map1 = new HashMap();
		map1.put("HSE_ACCIDENT_ID", hse_accident_id);
		map1.put("SECOND_ORG", second_org);
		map1.put("THIRD_ORG", third_org);
		map1.put("FOURTH_ORG", fourth_org);
		map1.put("ACCIDENT_NAME", accident_name);
		map1.put("ACCIDENT_TYPE", accident_type);
		map1.put("ACCIDENT_DATE", accident_date);
		map1.put("ACCIDENT_PLACE", accident_place);
		map1.put("WORKPLACE_FLAG", workplace_flag);
		map1.put("OUT_FLAG", out_flag);
		map1.put("OUT_NAME", out_name);
		map1.put("OUT_TYPE", out_type);
		
		if(hse_accident_id==null||hse_accident_id.equals("")){
			if(isProject.equals("2")){
				map1.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map1.put("UPDATOR_ID", user.getUserId());
		map1.put("MODIFI_DATE", now);
		map1.put("BSFLAG", "0");
		
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map1,"BGP_HSE_ACCIDENT_NEWS");
		hse_accident_id = id.toString();
		
		Map map2 = new HashMap();
		map2.put("HSE_RECORD_ID", hse_record_id);
		map2.put("ACCIDENT_LEVEL", accident_level);
		map2.put("PLACE_TYPE", place_type);
		map2.put("BULLETIN_FLAG", bulletin_flag);
		map2.put("CASE_FLAG", case_flag);
		map2.put("CASE_DATE", case_date);
		map2.put("DUTY_FLAG", duty_flag);
		map2.put("ACCIDENT_COURSE", accident_course);
		map2.put("FIRST_REASON", first_reason);
		map2.put("SECOND_REASON", second_reason);
		map2.put("ACCIDENT_NOTE", accident_note);
		map2.put("ACCIDENT_STEP", accident_step);
		map2.put("ACCIDENT_TEST", accident_test);
		map2.put("ACCIDENT_RISK", accident_risk);
		map2.put("MONEY_LOSE", money_lose);
		map2.put("OTHER_LOSE", other_lose);
		map2.put("ALL_LOSE", all_lose);
		map2.put("LOSE_HOURS", lose_hours);
		map2.put("REPORT_DATE", report_date);
		map2.put("REPORT_NAME", report_name);
		map2.put("CONTACT_NAME", contact_name);
		map2.put("PHONE", phone);
		map2.put("TABLE_DATE", table_date);
		map2.put("TABLE_PERSON", table_person);
		map2.put("DUTY_ID", duty_id);
		map2.put("LOSE_ID", lose_id);
		map2.put("STUFF_ID", stuff_id);
		map2.put("NUMBER_TOXIC", number_toxic);
		map2.put("HSE_ACCIDENT_ID", hse_accident_id);
		map2.put("POLLUTION_TYPE", pollution_type);
	
		map2.put("BSFLAG", "0");
		if(hse_record_id.equals("")||hse_record_id==null){
			map2.put("CREATE_DATE", now);
			map2.put("CREATOR_ID", user.getUserId());
		}
		map2.put("MODIFI_DATE", now);
		map2.put("UPDATOR_ID", user.getUserId());
		
		hse_record_id = pureJdbcDao.saveOrUpdateEntity(map2, "BGP_HSE_ACCIDENT_RECORD").toString(); 
		
		
		for(int i=0;i<5;i++){
			String hse_number_id = isrvmsg.getValue("hse_number_id"+i);
			String type = isrvmsg.getValue("type"+i);
			String number_die = isrvmsg.getValue("number_die"+i);
			String number_harm = isrvmsg.getValue("number_harm"+i);
			String number_injure = isrvmsg.getValue("number_injure"+i);
			
			Map map3 = new HashMap();
			
			map3.put("HSE_NUMBER_ID", hse_number_id);
			map3.put("NUMBER_DIE", number_die);
			map3.put("NUMBER_HARM", number_harm);
			map3.put("NUMBER_INJURE", number_injure);
			map3.put("TYPE", type);
			map3.put("HSE_ACCIDENT_ID", hse_accident_id);
			map3.put("BSFLAG", "0");
			if(hse_number_id.equals("")||hse_number_id==null){
			map3.put("CREATE_DATE", now);
			map3.put("CREATOR_ID", user.getUserId());
			}
			map3.put("MODIFI_DATE", now);
			map3.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(map3, "BGP_HSE_ACCIDENT_NUMBER"); 
		}
		
		
		String enviFlag = isrvmsg.getValue("enviFlag");
		if(enviFlag!=null&&!enviFlag.equals("")){
			if(enviFlag.equals("0")){
				//删除生态损失的记录
				String deleteSql = "delete from bgp_hse_record_environ where hse_record_id='"+hse_record_id+"'";
				jdbcTemplate.execute(deleteSql);
				
				String orders = isrvmsg.getValue("orders");
				if(orders!=null&&!orders.equals("")){
					String[] order = orders.split(","); 
					for(int i=0;i<order.length;i++){
						String leak_name = isrvmsg.getValue("leak_name"+order[i]);
						String leak_num = isrvmsg.getValue("leak_num"+order[i]);
						String emission_num = isrvmsg.getValue("emission_num"+order[i]);
						String equal_num = isrvmsg.getValue("equal_num"+order[i]);
						String cas_id = isrvmsg.getValue("cas_id"+order[i]);
						
						Map map3 = new HashMap();
						
						map3.put("LEAK_NAME", leak_name);
						map3.put("LEAK_NUM", leak_num);
						map3.put("EMISSION_NUM", emission_num);
						map3.put("EQUAL_NUM", equal_num);
						map3.put("CAS_ID", cas_id);
						map3.put("HSE_RECORD_ID", hse_record_id);
						map3.put("ORDER_NUM", i);
						pureJdbcDao.saveOrUpdateEntity(map3, "BGP_HSE_RECORD_ENVIRON"); 
					}
				}
			}
		}
		
		
		String sql = "select t.*,r.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,t.create_date from bgp_hse_accident_news t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join bgp_hse_accident_record r on t.hse_accident_id=r.hse_accident_id and r.bsflag='0' where t.bsflag = '0'  and t.hse_accident_id='"+hse_accident_id+"'";
		String sql2 = "select * from bgp_hse_accident_number n where n.bsflag='0' and n.hse_accident_id='"+hse_accident_id+"' order by type asc";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		responseDTO.setValue("hse_accident_id", hse_accident_id);
		responseDTO.setValue("index", index);
		responseDTO.setValue("map", map);
		responseDTO.setValue("list", list);
		
		return responseDTO;
	}
	
	//删除事故记录
	public ISrvMsg deleteRecord(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_accident_ids = isrvmsg.getValue("hse_accident_id");
		String ids[] =  hse_accident_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_accident_news set bsflag = '1' where hse_accident_id='"+ids[i]+"'";
			String sql2 = "update bgp_hse_accident_record set bsflag = '1' where hse_accident_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
			jdbcTemplate.execute(sql2);
		}
		
		return responseDTO;

	}
	//周报列表
	public ISrvMsg viewWeek(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_common_id = isrvmsg.getValue("hse_common_id");
		
		String sql = "select * from bgp_hse_common c where c.bsflag='0' and c.hse_common_id='"+hse_common_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("map", map);
		return responseDTO;

	}
	
	//删除hse周报
	public ISrvMsg deleteWeek(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_common_ids = isrvmsg.getValue("hse_common_id");
		String ids[] =  hse_common_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_common set bsflag = '1' where hse_common_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//删除hse周报  明细中的某条记录
 	public ISrvMsg deleteDetail(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String ids = isrvmsg.getValue("ids");
		String table = isrvmsg.getValue("table");
		String key = isrvmsg.getValue("key");
		String id[] =  ids.split(",");
		for(int i=0;i<id.length;i++){
			String sql = "delete from "+table+" where "+key+"='"+id[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;

	}
	
	
	//准驾证管理  添加  
	public ISrvMsg addDriving(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_driving_id = isrvmsg.getValue("hse_driving_id");
		String remark_id = isrvmsg.getValue("remark_id");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String name = isrvmsg.getValue("name");
		String sex = isrvmsg.getValue("sex");
		String birthday = isrvmsg.getValue("birthday");
		String duty = isrvmsg.getValue("duty");
		String card_id = isrvmsg.getValue("card_id");
		String file_number = isrvmsg.getValue("file_number");
		String car_type = isrvmsg.getValue("car_type");
		String driving_number = isrvmsg.getValue("driving_number");
		String driving_type = isrvmsg.getValue("driving_type");
		String sign_org = isrvmsg.getValue("sign_org");
		String signer = isrvmsg.getValue("signer");
		String sign_date = isrvmsg.getValue("sign_date");
		String expiry_date = isrvmsg.getValue("expiry_date");
		String contract_person = isrvmsg.getValue("contract_person");
		String contract_phone = isrvmsg.getValue("contract_phone");
		String remark = isrvmsg.getValue("memo");
		
		Map map = new HashMap();

		map.put("HSE_DRIVING_ID", hse_driving_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("NAME", name);
		map.put("SEX", sex);
		map.put("BIRTHDAY", birthday);
		map.put("DUTY", duty);
		map.put("CARD_ID", card_id);
		map.put("FILE_NUMBER", file_number);
		map.put("CAR_TYPE", car_type);
		map.put("DRIVING_NUMBER", driving_number);
		map.put("DRIVING_TYPE", driving_type);
		map.put("SIGN_ORG", sign_org);
		map.put("SIGNER", signer);
		map.put("SIGN_DATE", sign_date);
		map.put("EXPIRY_DATE", expiry_date);
		map.put("CONTRACT_PERSON", contract_person);
		map.put("CONTRACT_PHONE", contract_phone);
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}
		System.out.println(user.getProjectInfoNo());
		if(hse_driving_id==null||hse_driving_id.equals("")){
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_CONTROL_DRIVING");
		hse_driving_id = id.toString();
		
		if(!remark.equals("")&&remark!=null){
			Map remarkMap = new HashMap();
			
			remarkMap.put("REMARK_ID", remark_id);
			remarkMap.put("FOREIGN_KEY_ID", hse_driving_id);
			remarkMap.put("NOTES", remark);
			if(remark_id==null||remark_id.equals("")){
				remarkMap.put("CREATOR_ID", user.getUserId());
				remarkMap.put("CREATE_DATE", new Date());
			}
			remarkMap.put("UPDATOR_ID", user.getUserId());
			remarkMap.put("MODIFI_DATE", new Date());
			remarkMap.put("BSFLAG", "0");
			pureJdbcDao.saveOrUpdateEntity(remarkMap,"BGP_COMM_REMARK");
		}
		return responseDTO;
	}
	
	//查询准驾照的信息
	public ISrvMsg queryDriving(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_driving_id = isrvmsg.getValue("hse_driving_id");
		
		String sql = "select t.* ,r.notes,r.remark_id,oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name from bgp_hse_control_driving t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join bgp_comm_remark r on t.hse_driving_id = r.foreign_key_id and r.bsflag='0' where t.bsflag = '0' and t.hse_driving_id='"+hse_driving_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("map", map);
		return responseDTO;

	}
	
	//删除
	public ISrvMsg deleteDriving(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_driving_ids = isrvmsg.getValue("hse_driving_id");
		String ids[] =  hse_driving_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_control_driving set bsflag = '1' where hse_driving_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;

	}
	
	//HSE理念、方针的宣贯         添加  
	public ISrvMsg addAdvertise(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_advertise_id = isrvmsg.getValue("hse_advertise_id");
		String isProject = isrvmsg.getValue("isProject");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String content = isrvmsg.getValue("content");
		String times = isrvmsg.getValue("times");
		String if_plicy = isrvmsg.getValue("if_plicy");
		String duty = isrvmsg.getValue("duty");
		String advertise_person = isrvmsg.getValue("advertise_person");
		String advertise_date = isrvmsg.getValue("advertise_date");
		
		Map map = new HashMap();

		map.put("HSE_ADVERTISE_ID", hse_advertise_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("CONTENT", content);
		map.put("TIMES", times);
		map.put("IF_PLICY", if_plicy);
		map.put("DUTY", duty);
		map.put("ADVERTISE_PERSON", advertise_person);
		map.put("ADVERTISE_DATE", advertise_date);
		
		if(hse_advertise_id==null||hse_advertise_id.equals("")){
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
			if(isProject.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ADVERTISE");
		hse_advertise_id = id.toString();
		
		return responseDTO;
	}
	
	//查
	public ISrvMsg queryAdvertise(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_advertise_id = isrvmsg.getValue("hse_advertise_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_advertise t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' where t.bsflag = '0' and t.hse_advertise_id='"+hse_advertise_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("map", map);
		responseDTO.setValue("isProject", isProject);
		return responseDTO;

	}
	//删除
	public ISrvMsg deleteAdvertise(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_advertise_ids = isrvmsg.getValue("hse_advertise_id");
		String ids[] =  hse_advertise_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_advertise set bsflag = '1' where hse_advertise_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;

	}
	
	//HSE安全经验分享         添加  
	public ISrvMsg addSafeShare(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_safeshare_id = isrvmsg.getValue("hse_safeshare_id");
		String isProject = isrvmsg.getValue("isProject");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String safe_name = isrvmsg.getValue("safe_name");
		String safe_date = isrvmsg.getValue("safe_date");
		String safe_type = isrvmsg.getValue("safe_type");
		String info_type = isrvmsg.getValue("info_type");
		String share_person = isrvmsg.getValue("share_person");
		String upload_person = isrvmsg.getValue("upload_person");
		String content = isrvmsg.getValue("content");
		String share_occasion = isrvmsg.getValue("share_occasion");
		
		Map map = new HashMap();

		map.put("HSE_SAFESHARE_ID", hse_safeshare_id);
		map.put("SAFE_NAME", safe_name);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("SAFE_TYPE", safe_type);
		map.put("SAFE_DATE", safe_date);
		map.put("INFO_TYPE", info_type);
		map.put("UPLOAD_PERSON", upload_person);
		map.put("SHARE_PERSON", share_person);
		map.put("SHARE_OCCASION", share_occasion);
		map.put("CONTENT", content);
		if(hse_safeshare_id==null||hse_safeshare_id.equals("")){
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
			if(isProject.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_SAFESHARE");
		hse_safeshare_id = id.toString();
		
		return responseDTO;
	}
	
	//查询
	public ISrvMsg querySafeShare(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_safeshare_id = isrvmsg.getValue("hse_safeshare_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_safeshare t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' where t.bsflag = '0' and t.hse_safeshare_id='"+hse_safeshare_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("map", map);
		responseDTO.setValue("isProject", isProject);
		return responseDTO;

	}
	//删除
	public ISrvMsg deleteSafeShare(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_safeshare_ids = isrvmsg.getValue("hse_safeshare_id");
		String ids[] =  hse_safeshare_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_safeshare set bsflag = '1' where hse_safeshare_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;

	}
	
	//安全经验附件导入功能
	public ISrvMsg importSafeShare(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
		UserToken user = reqDTO.getUserToken();	
		String project= reqDTO.getValue("project"); // 是否多项目
		
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
						
						String second_org = "";
						String third_org = "";
						String fourth_org = "";
						String second_org_name = "";
						String third_org_name = "";
						String fourth_org_name = "";
						
						String safe_name = "";
						String safe_date = "";
						String safe_type = "";
						String info_type = "";
						String share_person = "";
						String share_occasion = "";
						String upload_person = "";
						String content = "";
			 
						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																						// 集合
						for (int j = 0; j <11; j++) {
							Cell ss = row.getCell(j);
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									second_org_name = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("second_org_name", second_org_name);
									break;
								case 1:
									ss.setCellType(1);
									third_org_name = ss.getStringCellValue().trim();
									tempMap.put("third_org_name", third_org_name);
									break; 
								case 2:
									ss.setCellType(1);
									fourth_org_name = ss.getStringCellValue().trim();
									tempMap.put("fourth_org_name", fourth_org_name);
									break; 
					 
								case 3:
									ss.setCellType(1);
									safe_name = ss.getStringCellValue().trim();
									tempMap.put("safe_name", safe_name);
									break; 
								case 4:
									ss.setCellType(1);
									safe_date = ss.getStringCellValue().trim();
									if(ss.getCellType()==0){
										safe_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										safe_date = ss.getStringCellValue().trim(); // 对应赋值
									} 
									safe_date=safe_date.replace("/", "-");
									String[] biths=safe_date.split("-");
									String temp="";
									for(int i=0;i<biths.length;i++){
										if(biths[i].length()==1){
										biths[i]="0"+biths[i];
										}
										if(i==biths.length-1){
											temp+=biths[i];
										}else{
											temp+=biths[i]+"-";
										}
										
									}
									tempMap.put("safe_date", temp);
									
									try{
										new SimpleDateFormat("yyyy-MM-dd").parse(temp);
									}catch(Exception ex){
										
										message.append("第").append(m + 1).append(
									"行上报日期格式不正确;");
									} 
									break; 
								case 5:
									ss.setCellType(1);
									safe_type = ss.getStringCellValue().trim();
									tempMap.put("safe_type", safe_type);
									break;  
								case 6:
									ss.setCellType(1);
									info_type = ss.getStringCellValue().trim();
									tempMap.put("info_type", info_type);
									break; 
								case 7:
									ss.setCellType(1);
									share_person = ss.getStringCellValue().trim();
									tempMap.put("share_person", share_person);
									break; 
								case 8:
									ss.setCellType(1);
									share_occasion = ss.getStringCellValue().trim();
									tempMap.put("share_occasion", share_occasion);
									break; 
								case 9:
									ss.setCellType(1);
									upload_person = ss.getStringCellValue().trim();
									tempMap.put("upload_person", upload_person);
									break; 
								case 10:
									ss.setCellType(1);
									content = ss.getStringCellValue().trim();
									tempMap.put("content", content);
									break; 
								default:
									break;
								}
							}
						}
					     	// 判断必填项处理
				 
						if (safe_name.equals("") || safe_date.equals("") || safe_type.equals("") || info_type.equals("") ||share_person.equals("") || upload_person.equals("") || content.equals("")) { 
							message.append("第").append(m + 1).append(
									"行红色标注项不能为空;");
						}
						// 根据用户输入的单位名称，来查询组织机构id号
						if(!second_org_name.equals("")){ 
							String sql = "select  cob.org_subjection_id,cif.org_id ,cob.father_org_id,cif.org_name,cif.org_abbreviation  from comm_org_information cif  left join comm_org_subjection cob  on cif.org_id=cob.org_id and cob.bsflag='0'   where cif.bsflag='0' and cif.org_abbreviation = '"+second_org_name+"' ";
							Map tempMaps = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
							if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								second_org = (String) tempMaps.get("orgSubjectionId"); 
								 tempMap.put("second_org", second_org); 
							}else{
								message.append("第").append(m + 1).append(
								"行单位不存在，请正确输入;"); 
							}
							
						} 
						if(!third_org_name.equals("")){ 
							String sql = "select  cob.org_subjection_id,cif.org_id ,cob.father_org_id,cif.org_name,cif.org_abbreviation  from comm_org_information cif  left join comm_org_subjection cob  on cif.org_id=cob.org_id and cob.bsflag='0'   where cif.bsflag='0' and cif.org_abbreviation = '"+third_org_name+"' ";
							Map tempMaps = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
							if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								third_org = (String) tempMaps.get("orgSubjectionId"); 
								 tempMap.put("third_org", third_org); 
							}else{
								message.append("第").append(m + 1).append(
								"行基层单位不存在，请正确输入;"); 
							}
							
						} 
						if(!fourth_org_name.equals("")){ 
							String sql = "select  cob.org_subjection_id,cif.org_id ,cob.father_org_id,cif.org_name,cif.org_abbreviation  from comm_org_information cif  left join comm_org_subjection cob  on cif.org_id=cob.org_id and cob.bsflag='0'   where cif.bsflag='0' and cif.org_abbreviation = '"+fourth_org_name+"' ";
							Map tempMaps = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
							if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								fourth_org = (String) tempMaps.get("orgSubjectionId"); 
								tempMap.put("fourth_org", fourth_org); 
							}else{
								message.append("第").append(m + 1).append(
								"行下属单位不存在，请正确输入;"); 
							}
							
						} 
						
						if (message.toString().equals("")) {
							tempMap.put("project", project);
							datelist.add(tempMap);
						} // 必填项不为空 则把数据放入 集合中
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportSafeShare(datelist, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");

			}
		}
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	public void saveImportSafeShare(List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合
			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i);    
					String hidden_no = "";  
					String mdetail_no = "";   
					String project=(String) map.get("project");

					String second_org = (String) map.get("second_org");
					String third_org = (String) map.get("third_org");
					String fourth_org = (String)map.get("fourth_org");
					String safe_name = (String)map.get("safe_name");
					String safe_date = (String)map.get("safe_date");
					String safe_type_name = (String)map.get("safe_type");
					String info_type_name = (String)map.get("info_type");
					String share_person = (String)map.get("share_person");
					String share_occasion = (String)map.get("share_occasion");
					String upload_person = (String)map.get("upload_person");
					String content = (String)map.get("content");
					String safe_type = "";
					String info_type = "";
					
					
					String sqlSafe = "select coding_code from comm_coding_sort_detail where  coding_sort_id='5110000026' and coding_name = '"+safe_type_name+"' order by coding_show_id";
					String sqlInfo = "select coding_code from comm_coding_sort_detail where  coding_sort_id='5110000027' and coding_name ='"+info_type_name+"' order by coding_show_id";
					
					Map mapSafe = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlSafe);
					Map mapInfo = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlInfo);
					
					if(mapSafe!=null){
						 safe_type = (String)mapSafe.get("codingCode");
					}
					if(mapInfo!=null){
						 info_type = (String)mapInfo.get("codingCode");
					}
						  
					Map tempMap = new HashMap(); 
					tempMap.put("HSE_SAFESHARE_ID", "");
					tempMap.put("SECOND_ORG", second_org);
					tempMap.put("THIRD_ORG", third_org);
					tempMap.put("FOURTH_ORG", fourth_org);
					tempMap.put("SAFE_TYPE", safe_type);
					tempMap.put("SAFE_DATE", safe_date);
					tempMap.put("INFO_TYPE", info_type);
					tempMap.put("UPLOAD_PERSON", upload_person);
					tempMap.put("SHARE_PERSON", share_person);
					tempMap.put("CONTENT", content);
					tempMap.put("BSFLAG", "0");
					tempMap.put("CREATE_DATE", new Date());
					tempMap.put("CREATOR_ID", user.getUserId());
					tempMap.put("MODIFI_DATE", new Date());
					tempMap.put("UPDATOR_ID", user.getUserId());
					tempMap.put("SAFE_NAME", safe_name);
					 
					tempMap.put("SHARE_OCCASION", share_occasion);
					if(project!=null&&project.equals("2")){
						tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
					} 
					//jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_HIDDEN_INFORMATION"); // 保存
					Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"BGP_HSE_SAFESHARE");
					hidden_no = id.toString();
			}
		}
	}

	
	//HSE个人安全行动计划         添加  
	public ISrvMsg addSafePlan(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_plan_id = isrvmsg.getValue("hse_plan_id");
		String isProject = isrvmsg.getValue("isProject");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String name = isrvmsg.getValue("name");
		String duty = isrvmsg.getValue("duty");
		String year = isrvmsg.getValue("year");
		String complete_status = isrvmsg.getValue("complete_status");
		String orders = isrvmsg.getValue("orders");
		
		
		Map map = new HashMap();
		map.put("HSE_PLAN_ID", hse_plan_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("NAME", name);
		map.put("DUTY", duty);
		map.put("YEAR", year);
		map.put("COMPLETE_STATUS", complete_status);
		
		if(hse_plan_id==null||hse_plan_id.equals("")){
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
			if(isProject.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_SAFEPLAN");
		hse_plan_id = id.toString();
		
		String order[] = orders.split(",");
		for(int i=0;i<order.length;i++){
			String rowNum = order[i];
			String hse_plan_detail_id = isrvmsg.getValue("hse_plan_detail_id"+rowNum);
			String plan_action = isrvmsg.getValue("plan_action"+rowNum);
			String plan_purpose = isrvmsg.getValue("plan_purpose"+rowNum);
			String plan_times = isrvmsg.getValue("plan_times"+rowNum);
			String january = isrvmsg.getValue("january"+rowNum);
				if(january==null){
					january = "1";
 				}
			String february = isrvmsg.getValue("february"+rowNum);
				if(february==null){
					february = "1";
				}
			String march = isrvmsg.getValue("march"+rowNum);
				if(march==null){
					march = "1";
				}
			String april = isrvmsg.getValue("april"+rowNum);
				if(april==null){
					april = "1";
				}
			String may = isrvmsg.getValue("may"+rowNum);
				if(may==null){
					may = "1";
				}
			String june = isrvmsg.getValue("june"+rowNum);
				if(june==null){
					june = "1";
				}
			String july = isrvmsg.getValue("july"+rowNum);
				if(july==null){
					july = "1";
				}
			String august = isrvmsg.getValue("august"+rowNum);
				if(august==null){
					august = "1";
				}
			String september = isrvmsg.getValue("september"+rowNum);
				if(september==null){
					september = "1";
				}
			String october = isrvmsg.getValue("october"+rowNum);
				if(october==null){
					october = "1";
				}
			String november = isrvmsg.getValue("november"+rowNum);
				if(november==null){
					november = "1";
				}
			String december = isrvmsg.getValue("december"+rowNum);
				if(december==null){
					december = "1";
				}
			String first_quarter = isrvmsg.getValue("first_quarter"+rowNum);
			String second_quarter = isrvmsg.getValue("second_quarter"+rowNum);
			String third_quarter = isrvmsg.getValue("third_quarter"+rowNum);
			String fourth_quarter = isrvmsg.getValue("fourth_quarter"+rowNum);
			
			String bsflag = isrvmsg.getValue("bsflag"+rowNum);
			if(bsflag==null||bsflag.equals("")){
				bsflag="0";
			}
			
			Map mapDetail = new HashMap();
			mapDetail.put("HSE_PLAN_DETAIL_ID", hse_plan_detail_id);
			mapDetail.put("HSE_PLAN_ID", hse_plan_id);
			mapDetail.put("PLAN_ACTION", plan_action);
			mapDetail.put("PLAN_PURPOSE", plan_purpose);
			mapDetail.put("PLAN_TIMES", plan_times);
			mapDetail.put("JANUARY", january);
			mapDetail.put("FEBRUARY", february);
			mapDetail.put("MARCH", march);
			mapDetail.put("APRIL", april);
			mapDetail.put("MAY", may);
			mapDetail.put("JUNE", june);
			mapDetail.put("JULY", july);
			mapDetail.put("AUGUST", august);
			mapDetail.put("SEPTEMBER", september);
			mapDetail.put("OCTOBER", october);
			mapDetail.put("NOVEMBER", november);
			mapDetail.put("DECEMBER", december);
			mapDetail.put("FIRST_QUARTER", first_quarter);
			mapDetail.put("SECOND_QUARTER", second_quarter);
			mapDetail.put("THIRD_QUARTER", third_quarter);
			mapDetail.put("FOURTH_QUARTER", fourth_quarter);
			mapDetail.put("ORDER_NUM", i);
			mapDetail.put("BSFLAG", bsflag);
			if(hse_plan_detail_id==null||hse_plan_detail_id.equals("")){
				mapDetail.put("CREATE_DATE", new Date());
				mapDetail.put("CREATOR_ID", user.getUserId());
			}
			mapDetail.put("MODIFI_DATE", new Date());
			mapDetail.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(mapDetail,"BGP_HSE_SAFEPLAN_DETAIL");
		}
		
		
		
		return responseDTO;
	}
	
	
	//HSE个人安全行动计划         复制并添加  
	public ISrvMsg addAndCopySafePlan(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_plan_id2 = isrvmsg.getValue("hse_plan_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String sql = "select * from bgp_hse_safeplan t where t.bsflag='0' and t.hse_plan_id='"+hse_plan_id2+"'";
		Map mapMain = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		String second_org = mapMain.get("secondOrg")==null ? "" : (String)mapMain.get("secondOrg");
		String third_org = mapMain.get("thirdOrg") == null ? "" : (String)mapMain.get("thirdOrg");
		String fourth_org = mapMain.get("fourthOrg") == null ? "" : (String)mapMain.get("fourthOrg");
		String name = mapMain.get("name") == null ? "" : (String)mapMain.get("name");
		String duty = mapMain.get("duty") == null ? "" : (String)mapMain.get("duty");
		String year = mapMain.get("year") == null ? "" : (String)mapMain.get("year");
		String complete_status = mapMain.get("completeStatus") == null ? "" : (String)mapMain.get("completeStatus");
		String project_info_no = mapMain.get("projectInfoNo") == null ? "" : (String)mapMain.get("projectInfoNo");
		
		Map map = new HashMap();
		map.put("HSE_PLAN_ID", "");
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("NAME", name);
		map.put("DUTY", duty);
		map.put("YEAR", year);
		map.put("COMPLETE_STATUS", complete_status);
		
		map.put("PROJECT_INFO_NO", project_info_no);
		map.put("CREATOR_ID", user.getUserId());
		map.put("CREATE_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_SAFEPLAN");
		String hse_plan_id = id.toString();
		
		String sqlDetail = "select * from bgp_hse_safeplan_detail t where t.bsflag='0' and t.hse_plan_id='"+hse_plan_id2+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlDetail);
		for(int i=0;i<list.size();i++){
			Map mapDetail = (Map)list.get(i);
			String plan_action = mapDetail.get("planAction") == null ? "" : (String)mapDetail.get("planAction");
			String plan_purpose = mapDetail.get("planPurpose") == null ? "" : (String)mapDetail.get("planPurpose");
			String plan_times = mapDetail.get("planTimes") == null ? "" : (String)mapDetail.get("planTimes");
			String january = mapDetail.get("january") == null ? "" : (String)mapDetail.get("january");
			String february = mapDetail.get("february") == null ? "" : (String)mapDetail.get("february");
			String march = mapDetail.get("march") == null ? "" : (String)mapDetail.get("march");
			String april = mapDetail.get("april") == null ? "" : (String)mapDetail.get("april");
			String may = mapDetail.get("may") == null ? "" : (String)mapDetail.get("may");
			String june = mapDetail.get("june") == null ? "" : (String)mapDetail.get("june");
			String july = mapDetail.get("july") == null ? "" : (String)mapDetail.get("july");
			String august = mapDetail.get("august") == null ? "" : (String)mapDetail.get("august");
			String september = mapDetail.get("september") == null ? "" : (String)mapDetail.get("september");
			String october = mapDetail.get("october") == null ? "" : (String)mapDetail.get("october");
			String november = mapDetail.get("november") == null ? "" : (String)mapDetail.get("november");
			String december = mapDetail.get("december") == null ? "" : (String)mapDetail.get("december");
			String first_quarter = mapDetail.get("firstQuarter") == null ? "" : (String)mapDetail.get("firstQuarter");
			String second_quarter = mapDetail.get("secondQuarter") == null ? "" : (String)mapDetail.get("secondQuarter");
			String third_quarter = mapDetail.get("thirdQuarter") == null ? "" : (String)mapDetail.get("thirdQuarter");
			String fourth_quarter = mapDetail.get("fourthQuarter") == null ? "" : (String)mapDetail.get("fourthQuarter");
			String order_num = mapDetail.get("orderNum") == null ? "" : (String)mapDetail.get("orderNum");
			
			Map mapDetail2 = new HashMap();
			mapDetail2.put("HSE_PLAN_DETAIL_ID", "");
			mapDetail2.put("HSE_PLAN_ID", hse_plan_id);
			mapDetail2.put("PLAN_ACTION", plan_action);
			mapDetail2.put("PLAN_PURPOSE", plan_purpose);
			mapDetail2.put("PLAN_TIMES", plan_times);
			mapDetail2.put("JANUARY", january);
			mapDetail2.put("FEBRUARY", february);
			mapDetail2.put("MARCH", march);
			mapDetail2.put("APRIL", april);
			mapDetail2.put("MAY", may);
			mapDetail2.put("JUNE", june);
			mapDetail2.put("JULY", july);
			mapDetail2.put("AUGUST", august);
			mapDetail2.put("SEPTEMBER", september);
			mapDetail2.put("OCTOBER", october);
			mapDetail2.put("NOVEMBER", november);
			mapDetail2.put("DECEMBER", december);
			mapDetail2.put("FIRST_QUARTER", first_quarter);
			mapDetail2.put("SECOND_QUARTER", second_quarter);
			mapDetail2.put("THIRD_QUARTER", third_quarter);
			mapDetail2.put("FOURTH_QUARTER", fourth_quarter);
			mapDetail2.put("ORDER_NUM", order_num);
			mapDetail2.put("BSFLAG", "0");
			mapDetail2.put("CREATE_DATE", new Date());
			mapDetail2.put("CREATOR_ID", user.getUserId());
			mapDetail2.put("MODIFI_DATE", new Date());
			mapDetail2.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(mapDetail2,"BGP_HSE_SAFEPLAN_DETAIL");
		}
		
		responseDTO.setValue("isProject", isProject);
		return responseDTO;
	}
	
	
	//删除
	public ISrvMsg deleteSafePlan(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_plan_ids = isrvmsg.getValue("hse_plan_id");
		String ids[] =  hse_plan_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_safeplan set bsflag = '1' where hse_plan_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//安全检查与沟通
	public ISrvMsg addSafeCheck(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_check_id = isrvmsg.getValue("hse_check_id");
		String isProject = isrvmsg.getValue("isProject");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String check_person = isrvmsg.getValue("check_person");
		String check_part = isrvmsg.getValue("check_part");
		String check_date = isrvmsg.getValue("check_date");
		String safe_time = isrvmsg.getValue("safe_time");
		String check_suggest = isrvmsg.getValue("check_suggest");
		
		
		String goods = isrvmsg.getValue("goods");
		String[] good = goods.split(","); 
		String nots = isrvmsg.getValue("nots");
		String[] not = nots.split(",");
		String projects = isrvmsg.getValue("projects");
		String[] project = projects.split(",");
		String problems = isrvmsg.getValue("problems");
		String[] problem = problems.split(",");
		
		String delProjs = isrvmsg.getValue("delProj");
		String delProbs = isrvmsg.getValue("delProb");
		String[] delProj = delProjs.split(",");
		String[] delProb = delProbs.split(",");
		
		
		
		Map map = new HashMap();
		map.put("HSE_CHECK_ID", hse_check_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("CHECK_PERSON", check_person);
		map.put("CHECK_PART", check_part);
		map.put("CHECK_DATE", check_date);
		map.put("SAFE_TIME", safe_time);
		map.put("CHECK_SUGGEST", check_suggest);
		
		if(hse_check_id==null||hse_check_id.equals("")){
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
			if(isProject.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_SAFECHECK");
		hse_check_id = id.toString();
		if(!projects.equals("")&&projects!=null){
			for(int i=0;i<project.length;i+=2){
				String hse_project_id = project[i];
				String sort_id = project[i+1];
				
				Map projectMap = new HashMap();
				projectMap.put("HSE_PROJECT_ID", hse_project_id);
				projectMap.put("SORT_ID", sort_id);
				projectMap.put("HSE_CHECK_ID", hse_check_id);
				projectMap.put("BSFLAG", "0");
				if(hse_project_id==null||hse_project_id.equals("")){
					projectMap.put("CREATE_DATE", new Date());
					projectMap.put("CREATOR_ID", user.getUserId());
				}
				projectMap.put("MODIFI_DATE", new Date());
				projectMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(projectMap,"BGP_HSE_SAFECHECK_PROJECT");
			}
		}
		
		//查询出所有“其他”复选框的ID，根据下面问题的sort_id机型比较
		String sql = "select coding_code_id,coding_sort_id,superior_code_id from Comm_Coding_Sort_Detail sd where sd.coding_sort_id = '5110000029' and sd.coding_name = '其他' and sd.bsflag = '0' order by superior_code_id";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		
		if(!problems.equals("")&&problems!=null){
			for(int i=0;i<problem.length;i+=2){
				String hse_problem_id = problem[i];
				String sort_id = problem[i+1];
				
				System.out.println("hse_problem_id="+hse_problem_id+",sort_id="+sort_id);
				Map problemMap = new HashMap();
				problemMap.put("HSE_PROBLEM_ID", hse_problem_id);
				problemMap.put("SORT_ID", sort_id);
				problemMap.put("HSE_CHECK_ID", hse_check_id);
				problemMap.put("BSFLAG", "0");
				problemMap.put("MODIFI_DATE", new Date());
				problemMap.put("UPDATOR_ID", user.getUserId());
				if(hse_problem_id==null||hse_problem_id.equals("")){
					problemMap.put("CREATE_DATE", new Date());
					problemMap.put("CREATOR_ID", user.getUserId());
				}
				pureJdbcDao.saveOrUpdateEntity(problemMap,"BGP_HSE_SAFECHECK_PROBLEM");
				
				for(int j=0;j<list.size();j++){
					Map otherMap = (Map)list.get(j);
					String coding_code = (String)otherMap.get("codingCodeId");
					String supId = (String)otherMap.get("superiorCodeId");
					if(coding_code.equals(sort_id)){
						String hse_other_id = isrvmsg.getValue("hse_other_id"+supId);
						String other_name = isrvmsg.getValue("other_name"+supId);
						Map nameMap = new HashMap();
						nameMap.put("HSE_OTHER_ID", hse_other_id);
						nameMap.put("SORT_ID", coding_code);
						nameMap.put("OTHER_NAME", other_name);
						nameMap.put("HSE_CHECK_ID", hse_check_id);
						nameMap.put("BSFLAG", "0");
						nameMap.put("MODIFI_DATE", new Date());
						nameMap.put("UPDATOR_ID", user.getUserId());
						if(hse_problem_id==null||hse_problem_id.equals("")){
							nameMap.put("CREATE_DATE", new Date());
							nameMap.put("CREATOR_ID", user.getUserId());
						}
						pureJdbcDao.saveOrUpdateEntity(nameMap,"BGP_HSE_SAFECHECK_OTHER");
					}
				}
			}
		}
		if(goods!=null&&!goods.equals("")){
			for(int i=0;i<good.length;i++){
				String hse_discover_id = isrvmsg.getValue("good_id"+good[i]);
				String good_safe = isrvmsg.getValue("good_safe"+good[i]);
				String bsflag = isrvmsg.getValue("good_bsflag"+good[i]);
				if(bsflag==null||bsflag.equals("")){
					bsflag="0";
				}
				Map goodMap = new HashMap();
				goodMap.put("HSE_DISCOVER_ID", hse_discover_id);
				goodMap.put("GOOD_SAFE", good_safe);
				goodMap.put("TYPE", "1");
				goodMap.put("HSE_CHECK_ID", hse_check_id);
				goodMap.put("BSFLAG", bsflag);
				if(hse_discover_id==null||hse_discover_id.equals("")){
					goodMap.put("CREATE_DATE", new Date());
					goodMap.put("CREATOR_ID", user.getUserId());
				}
				goodMap.put("MODIFI_DATE", new Date());
				goodMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(goodMap,"BGP_HSE_SAFECHECK_DISCOVER");
			}
		}
		if(nots!=null&&!nots.equals("")){
			for(int i=0;i<not.length;i++){
				String hse_discover_id = isrvmsg.getValue("not_id"+not[i]);
				String not_safe = isrvmsg.getValue("not_safe"+not[i]);
				String bsflag = isrvmsg.getValue("not_bsflag"+not[i]);
				if(bsflag==null||bsflag.equals("")){
					bsflag="0";
				}
				Map notMap = new HashMap();
				notMap.put("HSE_DISCOVER_ID", hse_discover_id);
				notMap.put("NOT_SAFE", not_safe);
				notMap.put("TYPE", "2");
				notMap.put("HSE_CHECK_ID", hse_check_id);
				notMap.put("BSFLAG", bsflag);
				if(hse_discover_id==null||hse_discover_id.equals("")){
					notMap.put("CREATE_DATE", new Date());
					notMap.put("CREATOR_ID", user.getUserId());
				}
				notMap.put("MODIFI_DATE", new Date());
				notMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(notMap,"BGP_HSE_SAFECHECK_DISCOVER");
			}
		}
		
		if(delProjs!=null&&!delProjs.equals("")){
			for(int i=0;i<delProj.length;i++){
				String delProjSql = "update bgp_hse_safecheck_project set bsflag = '1' where hse_project_id='"+delProj[i]+"'";
				jdbcTemplate.execute(delProjSql);
			}
		}
		
		if(delProbs!=null&&!delProbs.equals("")){
			for(int i=0;i<delProb.length;i++){
				String querySql = "select * from bgp_hse_safecheck_problem where bsflag='0' and hse_problem_id='"+delProb[i]+"'";
				Map queryMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(querySql);
				if(queryMap!=null){
					String  sort_id = (String)queryMap.get("sortId");
					for(int j=0;j<list.size();j++){
						Map otherMap = (Map)list.get(j);
						String sort_id2 = (String)otherMap.get("codingCodeId");
						if(sort_id.equals(sort_id2)){
							String delOtherSql = "update bgp_hse_safecheck_other set bsflag='1' where sort_id='"+sort_id+"' and hse_check_id='"+hse_check_id+"' and bsflag='0'";
							jdbcTemplate.execute(delOtherSql);
						}
					}
				}
				String delProbSql = "update bgp_hse_safecheck_problem set bsflag = '1' where hse_problem_id='"+delProb[i]+"'";
				jdbcTemplate.execute(delProbSql);
			}
		}
		

		return responseDTO;
	}
	
	
	public ISrvMsg addAndCopySafeCheck(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_check_id2 = isrvmsg.getValue("hse_check_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String sqlMain = "select * from bgp_hse_safecheck t where t.bsflag='0' and t.hse_check_id='"+hse_check_id2+"'";
		Map mapMain = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlMain);
		
		String project_info_no = mapMain.get("projectInfoNo") == null ? "" : (String)mapMain.get("projectInfoNo");
		String second_org = mapMain.get("secondOrg") == null ? "" : (String)mapMain.get("secondOrg");
		String third_org = mapMain.get("thirdOrg") == null ? "" : (String)mapMain.get("thirdOrg");
		String fourth_org = mapMain.get("fourthOrg") == null ? "" : (String)mapMain.get("fourthOrg");
		String check_person = mapMain.get("checkPerson") == null ? "" : (String)mapMain.get("checkPerson");
		String check_part = mapMain.get("checkPart") == null ? "" : (String)mapMain.get("checkPart");
		String check_date = mapMain.get("checkDate") == null ? "" : (String)mapMain.get("checkDate");
		String safe_time = mapMain.get("safeTime") == null ? "" : (String)mapMain.get("safeTime");
		String check_suggest = mapMain.get("checkSuggest") == null ? "" : (String)mapMain.get("checkSuggest");
		
		Map map = new HashMap();
		map.put("HSE_CHECK_ID", "");
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("CHECK_PERSON", check_person);
		map.put("CHECK_PART", check_part);
		map.put("CHECK_DATE", check_date);
		map.put("SAFE_TIME", safe_time);
		map.put("CHECK_SUGGEST", check_suggest);
		
		map.put("CREATOR_ID", user.getUserId());
		map.put("CREATE_DATE", new Date());
		map.put("PROJECT_INFO_NO", project_info_no);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_SAFECHECK");
		
		String hse_check_id = id.toString();
		
		String sqlProject = "select * from bgp_hse_safecheck_project t where t.bsflag='0' and t.hse_check_id='"+hse_check_id2+"'";
		List listProject = BeanFactory.getQueryJdbcDAO().queryRecords(sqlProject);
		for(int i=0;i<listProject.size();i++){
			Map mapProject = (Map)listProject.get(i);
			String sort_id = mapProject.get("sortId") == null ? "" : (String)mapProject.get("sortId");
			
			Map projectMap = new HashMap();
			projectMap.put("HSE_PROJECT_ID", "");
			projectMap.put("SORT_ID", sort_id);
			projectMap.put("HSE_CHECK_ID", hse_check_id);
			projectMap.put("BSFLAG", "0");
			projectMap.put("CREATE_DATE", new Date());
			projectMap.put("CREATOR_ID", user.getUserId());
			projectMap.put("MODIFI_DATE", new Date());
			projectMap.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(projectMap,"BGP_HSE_SAFECHECK_PROJECT");
		}
		
		//查询出所有“其他”复选框的ID，根据下面问题的sort_id机型比较
//		String sql = "select coding_code_id,coding_sort_id,superior_code_id from Comm_Coding_Sort_Detail sd where sd.coding_sort_id = '5110000029' and sd.coding_name = '其他' and sd.bsflag = '0' order by superior_code_id";
//		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		String sqlProblem = "select * from bgp_hse_safecheck_problem t where t.bsflag='0' and t.hse_check_id='"+hse_check_id2+"'";
		List listProblem = BeanFactory.getQueryJdbcDAO().queryRecords(sqlProblem); 
		
		for(int i=0;i<listProblem.size();i++){
			Map mapProblem = (Map)listProblem.get(i);
			String sort_id = mapProblem.get("sortId") == null ? "" : (String)mapProblem.get("sortId");
			
			Map problemMap = new HashMap();
			problemMap.put("HSE_PROBLEM_ID", "");
			problemMap.put("SORT_ID", sort_id);
			problemMap.put("HSE_CHECK_ID", hse_check_id);
			problemMap.put("BSFLAG", "0");
			problemMap.put("MODIFI_DATE", new Date());
			problemMap.put("UPDATOR_ID", user.getUserId());
			problemMap.put("CREATE_DATE", new Date());
			problemMap.put("CREATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(problemMap,"BGP_HSE_SAFECHECK_PROBLEM");
		}
		
		String sqlOther = "select * from bgp_hse_safecheck_other t where t.bsflag='0' and t.hse_check_id='"+hse_check_id2+"'";
		List listOther = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOther); 
		for(int j=0;j<listOther.size();j++){
			Map otherMap = (Map)listOther.get(j);
			String sort_id = otherMap.get("sortId")==null?"":(String)otherMap.get("sortId");
			String other_name = otherMap.get("otherName")==null?"":(String)otherMap.get("otherName");
			Map nameMap = new HashMap();
			nameMap.put("HSE_OTHER_ID", "");
			nameMap.put("SORT_ID", sort_id);
			nameMap.put("OTHER_NAME", other_name);
			nameMap.put("HSE_CHECK_ID", hse_check_id);
			nameMap.put("BSFLAG", "0");
			nameMap.put("MODIFI_DATE", new Date());
			nameMap.put("UPDATOR_ID", user.getUserId());
			nameMap.put("CREATE_DATE", new Date());
			nameMap.put("CREATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(nameMap,"BGP_HSE_SAFECHECK_OTHER");
		}
			
		String sqlDescover = "select * from bgp_hse_safecheck_discover t where t.bsflag='0' and t.hse_check_id='"+hse_check_id2+"'";
		List listDescover = BeanFactory.getQueryJdbcDAO().queryRecords(sqlDescover);
		for(int i=0;i<listDescover.size();i++){
			Map mapDescover = (Map)listDescover.get(i);
			String good_safe = mapDescover.get("goodSafe")==null?"":(String)mapDescover.get("goodSafe");
			String not_safe = mapDescover.get("notSafe")==null?"":(String)mapDescover.get("notSafe");
			String type = mapDescover.get("type")==null?"":(String)mapDescover.get("type");
			Map descoverMap = new HashMap();
			descoverMap.put("HSE_DISCOVER_ID", "");
			descoverMap.put("GOOD_SAFE", good_safe);
			descoverMap.put("NOT_SAFE", not_safe);
			descoverMap.put("TYPE", type);
			descoverMap.put("HSE_CHECK_ID", hse_check_id);
			descoverMap.put("BSFLAG", "0");
			descoverMap.put("CREATE_DATE", new Date());
			descoverMap.put("CREATOR_ID", user.getUserId());
			descoverMap.put("MODIFI_DATE", new Date());
			descoverMap.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(descoverMap,"BGP_HSE_SAFECHECK_DISCOVER");
		}
		responseDTO.setValue("isProject", isProject);
		return responseDTO;
	}	
	
	
	//删除
	public ISrvMsg deleteCheck(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_check_ids = isrvmsg.getValue("hse_check_id");
		String ids[] =  hse_check_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_safecheck set bsflag = '1' where hse_check_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	public ISrvMsg querySafeCheckColumn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String year = isrvmsg.getValue("year");
		String month = isrvmsg.getValue("month");
		String second = isrvmsg.getValue("second_org");
		String third = isrvmsg.getValue("third_org");
		String fourth = isrvmsg.getValue("fourth_org");
		
		
		String sql = "select sd1.coding_code_id, sd1.coding_name,";
         	   sql = sql + "sum(case when sp.hse_problem_id is null or sc.hse_check_id is null  then 0 else 1 end) num";
         	   sql = sql + " from Comm_Coding_Sort_Detail sd1 left join comm_coding_sort_detail sd2 on sd1.coding_code_id = sd2.superior_code_id and sd2.bsflag = '0' left join bgp_hse_safecheck_problem sp on sd2.coding_code_id = sp.sort_id and sp.bsflag = '0'  left join bgp_hse_safecheck sc on sc.hse_check_id = sp.hse_check_id and sc.bsflag = '0' "; 
         	   if(second!=null&&!second.equals("")){
         		   sql = sql + " and sc.second_org='"+second+"'";
         	   }
         	   if(third!=null&&!third.equals("")){
         		   sql = sql + " and sc.third_org='"+third+"'";
         	   }
         	   if(fourth!=null&&!fourth.equals("")){
         		   sql = sql + " and sc.fourth_org='"+fourth+"'";
         	   }
         	   if(year!=null&&!year.equals("")){
         		   if(month!=null&&!month.equals("")){
         			   sql = sql + " and sc.check_date >= to_date('"+year+"-"+month+"-1','yyyy-MM-dd') and sc.check_date <= to_date('"+year+"-"+month+"-31','yyyy-MM-dd')";
         		   }else{
         		   sql = sql + " and sc.check_date >= to_date('"+year+"-1-1','yyyy-MM-dd') and sc.check_date <= to_date('"+year+"-12-31','yyyy-MM-dd')";
         		   }
         	   }
               sql = sql + " where sd1.coding_sort_id = '5110000029' and sd1.superior_code_id = '0' and sd1.bsflag = '0' group by sd1.coding_code_id, sd1.coding_name order by sd1.coding_code_id";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		String Str = "<chart caption='安全观察与沟通统计图' showValues='1' decimals='0' formatNumberScale='0' palette='2' bgColor='#f3f3f3'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  codingName = (String)map.get("codingName");
			String  num = (String)map.get("num");
			Str = Str+"<set value='"+num+"' label='"+codingName+"'/>";
		}
		Str = Str+"</chart>";
		System.out.println("Str = " + Str);
		
		responseDTO.setValue("Str", Str);
		return responseDTO;
	}
	
	//HSE绩效考核模板 
	public ISrvMsg addModel(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_model_id = isrvmsg.getValue("hse_model_id");
		String model_name = isrvmsg.getValue("model_name");
		String result = isrvmsg.getValue("result");
		String punish_money = isrvmsg.getValue("punish_money");
		
		
		String goods = isrvmsg.getValue("good_ids");
		String bads = isrvmsg.getValue("bad_ids");
		String[] good = goods.split(","); 
		String[] bad = bads.split(",");
		
		
		Map map = new HashMap();
		map.put("HSE_MODEL_ID", hse_model_id);
		map.put("MODEL_NAME", model_name);
		map.put("RESULT", result);
		map.put("PUNISH_MONEY", punish_money);
		if(hse_model_id==null||hse_model_id.equals("")){
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ASSESS_MODEL");
		hse_model_id = id.toString();

		
		if(goods!=null&&!goods.equals("")){
			for(int i=0;i<good.length;i++){
				String hse_content_id = isrvmsg.getValue("hse_good_id"+good[i]);
				String target = isrvmsg.getValue("target"+good[i]);
				String score = isrvmsg.getValue("score"+good[i]);
				String complete_status = isrvmsg.getValue("complete_status"+good[i]);
				String get_score = isrvmsg.getValue("get_score"+good[i]);
				String order = isrvmsg.getValue("good_order"+good[i]);
				String bsflag = isrvmsg.getValue("good_bsflag"+good[i]);
				if(bsflag==null||bsflag.equals("")){
					bsflag="0";
				}
				Map goodMap = new HashMap();
				goodMap.put("HSE_CONTENT_ID", hse_content_id);
				goodMap.put("TARGET", target);
				goodMap.put("SCORE", score);
				goodMap.put("COMPLETE_STATUS", complete_status);
				goodMap.put("GET_SCORE", get_score);
				goodMap.put("TYPE", "1");
				goodMap.put("HSE_MODEL_ID", hse_model_id);
				goodMap.put("ORDER_NUM", order);
				goodMap.put("BSFLAG", bsflag);
				if(hse_content_id==null||hse_content_id.equals("")){
					goodMap.put("CREATE_DATE", new Date());
					goodMap.put("CREATOR_ID", user.getUserId());
				}
				goodMap.put("MODIFI_DATE", new Date());
				goodMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(goodMap,"BGP_HSE_MODEL_CONTENT");
			}
		}
		if(bads!=null&&!bads.equals("")){
			for(int i=0;i<bad.length;i++){
				String hse_content_id = isrvmsg.getValue("hse_bad_id"+bad[i]);
				String break_rule = isrvmsg.getValue("break_rule"+bad[i]);
				String rule_level = isrvmsg.getValue("rule_level"+bad[i]);
				String order = isrvmsg.getValue("bad_order"+bad[i]);
				String bsflag = isrvmsg.getValue("bad_bsflag"+bad[i]);
				if(bsflag==null||bsflag.equals("")){
					bsflag="0";
				}
				Map badMap = new HashMap();
				badMap.put("HSE_CONTENT_ID", hse_content_id);
				badMap.put("BREAK_RULE", break_rule);
				badMap.put("RULE_LEVEL", rule_level);
				badMap.put("TYPE", "2");
				badMap.put("HSE_MODEL_ID", hse_model_id);
				badMap.put("ORDER_NUM", order);
				badMap.put("BSFLAG", bsflag);
				if(hse_content_id==null||hse_content_id.equals("")){
					badMap.put("CREATE_DATE", new Date());
					badMap.put("CREATOR_ID", user.getUserId());
				}
				badMap.put("MODIFI_DATE", new Date());
				badMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(badMap,"BGP_HSE_MODEL_CONTENT");
			}
		}
		
		return responseDTO;
	}	
	
	
	//查询
	public ISrvMsg queryModel(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_model_id = isrvmsg.getValue("hse_model_id");
		
		String sql = "select * from bgp_hse_assess_model m where bsflag='0' and m.hse_model_id = '"+hse_model_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("map", map);
		return responseDTO;

	}
	
	
	//删除
	public ISrvMsg deleteModel(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_model_ids = isrvmsg.getValue("hse_model_id");
		String ids[] =  hse_model_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_assess_model set bsflag = '1' where hse_model_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	
	//HSE绩效考核基本信息 
	public ISrvMsg addAssess(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_assess_id = isrvmsg.getValue("hse_assess_id");
		String project = isrvmsg.getValue("project");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String year = isrvmsg.getValue("year");
		String quarter = isrvmsg.getValue("quarter");
		String month = isrvmsg.getValue("month");
		String assess_person_id = isrvmsg.getValue("assess_person_id");
		String assess_date = isrvmsg.getValue("assess_date");
		String hse_model_id = isrvmsg.getValue("hse_model_id");
		String action = isrvmsg.getValue("action");
		
		Map map = new HashMap();
		map.put("HSE_ASSESS_ID", hse_assess_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("YEAR", year);
		if(!quarter.equals("")&&quarter!=null){
			map.put("QUARTER_MONTH", quarter);
			map.put("TYPE", "1");
		}
		if(!month.equals("")&&month!=null){
			map.put("QUARTER_MONTH", month);
			map.put("TYPE", "2");
		}
		map.put("ASSESS_NAME", assess_person_id);
		map.put("ASSESS_DATE", assess_date);
		if(hse_assess_id==null||hse_assess_id.equals("")){
			map.put("ORG_ID", user.getOrgId());
			map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		map.put("ASSESS_STATUS", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ASSESS");
		hse_assess_id = id.toString();
		
		responseDTO.setValue("hse_assess_id", hse_assess_id);
		responseDTO.setValue("isProject", project);
		responseDTO.setValue("assess_date", assess_date);
		responseDTO.setValue("assess_person_id", assess_person_id);
		responseDTO.setValue("hse_model_id", hse_model_id);
		responseDTO.setValue("action", action);

		return responseDTO;
	}
	
	//HSE绩效考核表
	public ISrvMsg addAssessContent(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		
		String hse_assess_id = isrvmsg.getValue("hse_assess_id");
		String project = isrvmsg.getValue("project");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String year = isrvmsg.getValue("year");
		String quarter = isrvmsg.getValue("quarter");
		String month = isrvmsg.getValue("month");
		String assess_name = isrvmsg.getValue("assess_name");
		String assess_date = isrvmsg.getValue("assess_date");
		
		String assess_post = isrvmsg.getValue("assess_post");
		String result = isrvmsg.getValue("result");
		String punish_money = isrvmsg.getValue("punish_money");
		String assess_sign = isrvmsg.getValue("assess_sign");
		String sign_date = isrvmsg.getValue("sign_date");
		String leader_sign = isrvmsg.getValue("leader_sign");
		String leader_date = isrvmsg.getValue("leader_date");
		String superior_sign = isrvmsg.getValue("superior_sign");
		String superior_date = isrvmsg.getValue("superior_date");
		String remark_id = isrvmsg.getValue("remark_id");
		String remark = isrvmsg.getValue("memo");
		String assess_suggest = isrvmsg.getValue("assess_suggest");
		String superior_suggest = isrvmsg.getValue("superior_suggest");
		
		
		String goods = isrvmsg.getValue("good_ids");
		String bads = isrvmsg.getValue("bad_ids");
		String[] good = goods.split(","); 
		String[] bad = bads.split(",");
		
		
		Map map = new HashMap();
		map.put("HSE_ASSESS_ID", hse_assess_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("YEAR", year);
		if(!quarter.equals("")&&quarter!=null){
			map.put("QUARTER_MONTH", quarter);
			map.put("TYPE", "1");
		}
		if(!month.equals("")&&month!=null){
			map.put("QUARTER_MONTH", month);
			map.put("TYPE", "2");
		}
		map.put("ASSESS_NAME", assess_name);
		map.put("ASSESS_DATE", assess_date);
		if(hse_assess_id==null||hse_assess_id.equals("")){
			map.put("ORG_ID", user.getOrgId());
			map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		map.put("ASSESS_STATUS", "0");
		
		map.put("ASSESS_POST", assess_post);
		map.put("RESULT", result);
		map.put("PUNISH_MONEY", punish_money);
		map.put("ASSESS_SIGN", assess_sign);
		map.put("SIGN_DATE", sign_date);
		map.put("LEADER_SIGN", leader_sign);
		map.put("LEADER_DATE", leader_date);
		map.put("SUPERIOR_SIGN", superior_sign);
		map.put("SUPERIOR_DATE", superior_date);
		map.put("ASSESS_SUGGEST", assess_suggest);
		map.put("SUPERIOR_SUGGEST", superior_suggest);
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ASSESS");
		hse_assess_id = id.toString();

		//
		if(goods!=null&&!goods.equals("")){
			for(int i=0;i<good.length;i++){
				String hse_content_id = isrvmsg.getValue("hse_good_id"+good[i]);
				String target = isrvmsg.getValue("target"+good[i]);
				String score = isrvmsg.getValue("score"+good[i]);
				String complete_status = isrvmsg.getValue("complete_status"+good[i]);
				String get_score = isrvmsg.getValue("get_score"+good[i]);
				int order = i+1;
				String bsflag = isrvmsg.getValue("good_bsflag"+good[i]);
				if(bsflag==null||bsflag.equals("")){
					bsflag="0";
				}
				Map goodMap = new HashMap();
				goodMap.put("HSE_CONTENT_ID", hse_content_id);
				goodMap.put("TARGET", target);
				goodMap.put("SCORE", score);
				goodMap.put("COMPLETE_STATUS", complete_status);
				goodMap.put("GET_SCORE", get_score);
				goodMap.put("TYPE", "1");
				goodMap.put("HSE_ASSESS_ID", hse_assess_id);
				goodMap.put("ORDER_NUM", order);
				goodMap.put("BSFLAG", bsflag);
				if(hse_content_id==null||hse_content_id.equals("")){
					goodMap.put("CREATE_DATE", new Date());
					goodMap.put("CREATOR_ID", user.getUserId());
				}
				goodMap.put("MODIFI_DATE", new Date());
				goodMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(goodMap,"BGP_HSE_ASSESS_CONTENT");
			}
		}
		//	惩罚
		if(bads!=null&&!bads.equals("")){
			for(int i=0;i<bad.length;i++){
				String hse_content_id = isrvmsg.getValue("hse_bad_id"+bad[i]);
				String break_rule = isrvmsg.getValue("break_rule"+bad[i]);
				String rule_level = isrvmsg.getValue("rule_level"+bad[i]);
				int order = i+1;
				String bsflag = isrvmsg.getValue("bad_bsflag"+bad[i]);
				if(bsflag==null||bsflag.equals("")){
					bsflag="0";
				}
				Map badMap = new HashMap();
				badMap.put("HSE_CONTENT_ID", hse_content_id);
				badMap.put("BREAK_RULE", break_rule);
				badMap.put("RULE_LEVEL", rule_level);
				badMap.put("TYPE", "2");
				badMap.put("HSE_ASSESS_ID", hse_assess_id);
				badMap.put("ORDER_NUM", order);
				badMap.put("BSFLAG", bsflag);
				if(hse_content_id==null||hse_content_id.equals("")){
					badMap.put("CREATE_DATE", new Date());
					badMap.put("CREATOR_ID", user.getUserId());
				}
				badMap.put("MODIFI_DATE", new Date());
				badMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(badMap,"BGP_HSE_ASSESS_CONTENT");
			}
		}
		//附件添加修改
		if(!remark.equals("")&&remark!=null){
			Map remarkMap = new HashMap();
			
			remarkMap.put("REMARK_ID", remark_id);
			remarkMap.put("FOREIGN_KEY_ID", hse_assess_id);
			remarkMap.put("NOTES", remark);
			if(remark_id==null||remark_id.equals("")){
				remarkMap.put("CREATOR_ID", user.getUserId());
				remarkMap.put("CREATE_DATE", new Date());
			}
			remarkMap.put("UPDATOR_ID", user.getUserId());
			remarkMap.put("MODIFI_DATE", new Date());
			remarkMap.put("BSFLAG", "0");
			pureJdbcDao.saveOrUpdateEntity(remarkMap,"BGP_COMM_REMARK");
		}
		
		
		
		return responseDTO;
	}	
	
	
	//HSE绩效考核表  复制并添加
	public ISrvMsg addAndCopyAssessContent(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_assess_id2 = isrvmsg.getValue("hse_assess_id");		//页面传过来的主键
		
		String hse_assess_id = "";   		//新增记录的主键
		String sql = "select * from bgp_hse_assess t where t.bsflag='0' and t.hse_assess_id='"+hse_assess_id2+"'";
		Map mapMain = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	
		if(mapMain!=null){
			String second_org = mapMain.get("secondOrg")==null?"":(String)mapMain.get("secondOrg");
			String third_org = mapMain.get("thirdOrg")==null?"":(String)mapMain.get("thirdOrg");
			String fourth_org = mapMain.get("fourthOrg")==null?"":(String)mapMain.get("fourthOrg");
			String year = mapMain.get("year")==null?"":(String)mapMain.get("year");
			String quarter_month = mapMain.get("quarterMonth")==null?"":(String)mapMain.get("quarterMonth");
			String type = mapMain.get("type")==null?"":(String)mapMain.get("type");
			String assess_name = mapMain.get("assessName")==null?"":(String)mapMain.get("assessName");
			String assess_date = mapMain.get("assessDate")==null?"":(String)mapMain.get("assessDate");
			String assess_post = mapMain.get("assessPost")==null?"":(String)mapMain.get("assessPost");
			String result = mapMain.get("result")==null?"":(String)mapMain.get("result");
			String punish_money = mapMain.get("punishMoney")==null?"":(String)mapMain.get("punishMoney");
			String assess_sign = mapMain.get("assessSign")==null?"":(String)mapMain.get("assessSign");
			String sign_date = mapMain.get("signDate")==null?"":(String)mapMain.get("signDate");
			String leader_sign = mapMain.get("leaderSign")==null?"":(String)mapMain.get("leaderSign");
			String leader_date = mapMain.get("leaderDate")==null?"":(String)mapMain.get("leaderDate");
			String superior_sign = mapMain.get("superiorSign")==null?"":(String)mapMain.get("superiorSign");
			String superior_date = mapMain.get("superiorDate")==null?"":(String)mapMain.get("superiorDate");
			String assess_suggest = mapMain.get("assessSuggest")==null?"":(String)mapMain.get("assessSuggest");
			String superior_suggest = mapMain.get("superiorSuggest")==null?"":(String)mapMain.get("superiorSuggest");
			
			Map map = new HashMap();
			map.put("HSE_ASSESS_ID", "");
			map.put("SECOND_ORG", second_org);
			map.put("THIRD_ORG", third_org);
			map.put("FOURTH_ORG", fourth_org);
			map.put("YEAR", year);
			map.put("QUARTER_MONTH", quarter_month);
			map.put("TYPE", type);
			map.put("ASSESS_NAME", assess_name);
			map.put("ASSESS_DATE", assess_date);
			map.put("ORG_ID", user.getOrgId());
			map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			map.put("CREATOR_ID", user.getUserId());
			map.put("CREATE_DATE", new Date());
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			map.put("UPDATOR_ID", user.getUserId());
			map.put("MODIFI_DATE", new Date());
			map.put("BSFLAG", "0");
			map.put("ASSESS_STATUS", "0");
			map.put("ASSESS_POST", assess_post);
			map.put("RESULT", result);
			map.put("PUNISH_MONEY", punish_money);
			map.put("ASSESS_SIGN", assess_sign);
			map.put("SIGN_DATE", sign_date);
			map.put("LEADER_SIGN", leader_sign);
			map.put("LEADER_DATE", leader_date);
			map.put("SUPERIOR_SIGN", superior_sign);
			map.put("SUPERIOR_DATE", superior_date);
			map.put("ASSESS_SUGGEST", assess_suggest);
			map.put("SUPERIOR_SUGGEST", superior_suggest);
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ASSESS");
			hse_assess_id = id.toString();
		}
		
		String sqlContent = "select * from bgp_hse_assess_content t where t.bsflag='0' and t.hse_assess_id='"+hse_assess_id2+"'";
		List listContent = BeanFactory.getQueryJdbcDAO().queryRecords(sqlContent);
		
		for(int i=0;i<listContent.size();i++){
			Map mapContent = (Map)listContent.get(i);
			String target = mapContent.get("target")==null?"":(String)mapContent.get("target");
			String score = mapContent.get("score")==null?"":(String)mapContent.get("score");
			String complete_status = mapContent.get("completeStatus")==null?"":(String)mapContent.get("completeStatus");
			String get_score = mapContent.get("getScore")==null?"":(String)mapContent.get("getScore");
			String break_rule = mapContent.get("breakRule")==null?"":(String)mapContent.get("breakRule");
			String rule_level = mapContent.get("ruleLevel")==null?"":(String)mapContent.get("ruleLevel");
			String type = mapContent.get("type")==null?"":(String)mapContent.get("type");
			String order_num = mapContent.get("orderNum")==null?"":(String)mapContent.get("orderNum");
			Map goodMap = new HashMap();
			goodMap.put("HSE_CONTENT_ID", "");
			goodMap.put("TARGET", target);
			goodMap.put("SCORE", score);
			goodMap.put("COMPLETE_STATUS", complete_status);
			goodMap.put("GET_SCORE", get_score);
			goodMap.put("TYPE", type);
			goodMap.put("BREAK_RULE", break_rule);
			goodMap.put("RULE_LEVEL", rule_level);
			goodMap.put("HSE_ASSESS_ID", hse_assess_id);
			goodMap.put("ORDER_NUM", order_num);
			goodMap.put("BSFLAG", "0");
			goodMap.put("CREATE_DATE", new Date());
			goodMap.put("CREATOR_ID", user.getUserId());
			goodMap.put("MODIFI_DATE", new Date());
			goodMap.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(goodMap,"BGP_HSE_ASSESS_CONTENT");
		}
		
		
		String sqlRemark = "select * from bgp_comm_remark t where t.bsflag='0' and t.foreign_key_id='"+hse_assess_id2+"'";
		Map mapRemark = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlRemark);
		//附件添加修改
		if(mapRemark!=null){
			String notes = mapRemark.get("notes")==null ? "" : (String)mapRemark.get("notes");
			Map remarkMap = new HashMap();
			
			remarkMap.put("REMARK_ID", "");
			remarkMap.put("FOREIGN_KEY_ID", hse_assess_id);
			remarkMap.put("NOTES", notes);
			remarkMap.put("CREATOR_ID", user.getUserId());
			remarkMap.put("CREATE_DATE", new Date());
			remarkMap.put("UPDATOR_ID", user.getUserId());
			remarkMap.put("MODIFI_DATE", new Date());
			remarkMap.put("BSFLAG", "0");
			pureJdbcDao.saveOrUpdateEntity(remarkMap,"BGP_COMM_REMARK");
		}
		
		
		
		return responseDTO;
	}	
	
	//查询
	public ISrvMsg queryAssess(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_assess_id = isrvmsg.getValue("hse_assess_id");
		
		String sql = "select ha.*,ee.employee_name,au.user_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_assess ha left join comm_org_subjection os1 on ha.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ha.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on ha.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join p_auth_user au on ha.creator_id=au.user_id and au.bsflag='0' where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ha.modifi_date desc ";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		responseDTO.setValue("map", map);
		return responseDTO;

	}
	
	//删除
	public ISrvMsg deleteAssess(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_assess_ids = isrvmsg.getValue("hse_assess_id");
		String ids[] =  hse_assess_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_assess set bsflag = '1' where hse_assess_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	
	//HSE绩效考核表  ----员工
	public ISrvMsg addAssessYuan(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_assess_id = isrvmsg.getValue("hse_assess_id");
		String assess_sign = isrvmsg.getValue("assess_sign");
		String sign_date = isrvmsg.getValue("sign_date");
		String leader_sign = isrvmsg.getValue("leader_sign");
		String leader_date = isrvmsg.getValue("leader_date");
		String superior_sign = isrvmsg.getValue("superior_sign");
		String superior_date = isrvmsg.getValue("superior_date");
		String assess_suggest = isrvmsg.getValue("assess_suggest");
		
		
		Map map = new HashMap();
		map.put("HSE_ASSESS_ID", hse_assess_id);
		map.put("ASSESS_SIGN", assess_sign);
		map.put("SIGN_DATE", sign_date);
		map.put("LEADER_SIGN", leader_sign);
		map.put("LEADER_DATE", leader_date);
		map.put("SUPERIOR_SIGN", superior_sign);
		map.put("SUPERIOR_DATE", superior_date);
		map.put("ASSESS_SUGGEST", assess_suggest);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ASSESS");
		hse_assess_id = id.toString();

		
		String sql = "update bgp_hse_assess set assess_status='2' where hse_assess_id='"+hse_assess_id+"'";
		jdbcTemplate.execute(sql);
		
		
		return responseDTO;
	}	
	
	//HSE绩效考核表  ----上级主管
	public ISrvMsg addAssessSup(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_assess_id = isrvmsg.getValue("hse_assess_id");
		String assess_sign = isrvmsg.getValue("assess_sign");
		String sign_date = isrvmsg.getValue("sign_date");
		String leader_sign = isrvmsg.getValue("leader_sign");
		String leader_date = isrvmsg.getValue("leader_date");
		String superior_sign = isrvmsg.getValue("superior_sign");
		String superior_date = isrvmsg.getValue("superior_date");
		String superior_suggest = isrvmsg.getValue("superior_suggest");
		
		Map map = new HashMap();
		map.put("HSE_ASSESS_ID", hse_assess_id);
		map.put("ASSESS_SIGN", assess_sign);
		map.put("SIGN_DATE", sign_date);
		map.put("LEADER_SIGN", leader_sign);
		map.put("LEADER_DATE", leader_date);
		map.put("SUPERIOR_SIGN", superior_sign);
		map.put("SUPERIOR_DATE", superior_date);
		map.put("SUPERIOR_SUGGEST", superior_suggest);
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ASSESS");
		hse_assess_id = id.toString();

		String sql = "update bgp_hse_assess set assess_status='3' where hse_assess_id='"+hse_assess_id+"'";
		jdbcTemplate.execute(sql);
		
		
		return responseDTO;
	}
	
	//审核不通过
	public ISrvMsg assessNoPass(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_assess_id = isrvmsg.getValue("hse_assess_id");

		String sql = "update bgp_hse_assess set assess_status='4' where hse_assess_id='"+hse_assess_id+"'";
		jdbcTemplate.execute(sql);
		return responseDTO;
	}
	
	/**
	 * hse管理人员信息批量导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg importExcelMessage(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
		UserToken user = reqDTO.getUserToken();	
		String project= reqDTO.getValue("project"); // 是否多项目
		String second_org = reqDTO.getValue("second_org")==null?"":reqDTO.getValue("second_org");
		String third_org = reqDTO.getValue("third_org")==null?"":reqDTO.getValue("third_org");
		String fourth_org = reqDTO.getValue("fourth_org")==null?"":reqDTO.getValue("fourth_org");
		
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			List<Map> datelist1 = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet0 = null;
				Sheet sheet1 = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet0 = book.getSheetAt(0);
					sheet1 = book.getSheetAt(1);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet0 = book.getSheetAt(0);
					sheet1 = book.getSheetAt(1);
				}
				
				int rows = sheet0.getPhysicalNumberOfRows();
				Row row0 = sheet0.getRow(0);
				int columns = row0.getPhysicalNumberOfCells();
				
				
				
				if (sheet0 != null) {
					for(int m=2;m<rows;m++){
						Row row = sheet0.getRow(m);
						
						System.out.println(columns);
						Map mapColumnInfoIn = new HashMap();
						for (int n = 0; n < columns; n++) {
							if(row.getCell(n) !=null){
								Cell cell = row.getCell(n);
								int cellType = cell.getCellType();
								switch (cellType) {
								case 0:
									if (HSSFDateUtil.isCellDateFormatted(cell)) {
										mapColumnInfoIn.put(n, cell.getDateCellValue());
									} else {
										cell.setCellType(cell.CELL_TYPE_STRING);
										mapColumnInfoIn.put(n, cell.getStringCellValue());
									}
									break;
								case 1:
									mapColumnInfoIn.put(n, cell.getStringCellValue());
									break;
								}
							}
							else{
								mapColumnInfoIn.put(n, "");
//									break;
							}
					}
						Map map = new HashMap();
						
						String year = mapColumnInfoIn.get(0)==null?"":mapColumnInfoIn.get(0).toString();
						String quarter = mapColumnInfoIn.get(1)==null?"":mapColumnInfoIn.get(1).toString();
						String month = mapColumnInfoIn.get(2)==null?"":mapColumnInfoIn.get(2).toString();
						String assess_name = mapColumnInfoIn.get(3)==null?"":mapColumnInfoIn.get(3).toString();
						String assess_date = mapColumnInfoIn.get(5)==null?"":mapColumnInfoIn.get(5).toString();
						
						
						if(quarter.equals("第一季度")){
							quarter = "1";
						}else if(quarter.equals("第二季度")){
							quarter = "4";
						}else if(quarter.equals("第三季度")){
							quarter = "7";
						}else if(quarter.equals("第四季度")){
							quarter = "10";
						}
						
						
						if(year.equals("")){
							message.append("Sheet1第").append(m + 1).append("行年度不能为空，请正确输入;");
						}
						if(quarter.equals("")&&month.equals("")){
							message.append("Sheet1第").append(m + 1).append("行季度和月份不能同时为空，请正确输入;");
						}
						if(!month.equals("")&&!quarter.equals("")){
							message.append("Sheet1第").append(m + 1).append("行季度和月份只能选择其一，请正确输入;");
						}
						if(assess_name.equals("")){
							message.append("Sheet1第").append(m + 1).append("行被考核人不能为空，请正确输入;");
						}
						if(assess_date.equals("")){
							message.append("Sheet1第").append(m + 1).append("行考核日期不能为空，请正确输入;");
						}
						
						map.put("second_org", second_org);
						map.put("third_org", third_org);
						map.put("fourth_org", fourth_org);
						map.put("year", year);
						if(!quarter.equals("")&&quarter!=null){
							map.put("quarter_month", quarter);
							map.put("type", "1");
						}
						if(!month.equals("")&&month!=null){
							map.put("quarter_month", month);
							map.put("type", "2");
						}
						map.put("assess_name", assess_name);
						map.put("assess_date", assess_date);
						map.put("org_id", user.getOrgId());
						map.put("org_subjection_id", user.getOrgSubjectionId());
						if(project.equals("2")){
							map.put("project_info_no", user.getProjectInfoNo());
						}else{
							map.put("project_info_no", "");
						}
						map.put("assess_post", mapColumnInfoIn.get(4));
						map.put("result", mapColumnInfoIn.get(6));
						map.put("punish_money", mapColumnInfoIn.get(7));
						map.put("assess_sign", mapColumnInfoIn.get(8));
						map.put("sign_date", mapColumnInfoIn.get(9));
						map.put("leader_sign", mapColumnInfoIn.get(10));
						map.put("leader_date", mapColumnInfoIn.get(11));
						map.put("superior_sign", mapColumnInfoIn.get(12));
						map.put("superior_date", mapColumnInfoIn.get(13));
						map.put("memo", mapColumnInfoIn.get(14));
						map.put("assess_suggest", mapColumnInfoIn.get(15));
						map.put("superior_suggest", mapColumnInfoIn.get(16));
						datelist.add(map);
					     	// 判断必填项处理
					}
				}
				
				//子表数据
				int rows1 = sheet1.getPhysicalNumberOfRows();
				Row row1 = sheet1.getRow(0);
				int columns1 = row1.getPhysicalNumberOfCells();
				if (sheet1 != null) {
					for(int m=2;m<rows1;m++){
						Row row = sheet1.getRow(m);
						
						Map mapColumnInfoIn = new HashMap();
						for (int n = 0; n < columns1; n++) {
							if(row.getCell(n) !=null){
								Cell cell = row.getCell(n);
								int cellType = cell.getCellType();
								switch (cellType) {
								case 0:
									if (HSSFDateUtil.isCellDateFormatted(cell)) {
										mapColumnInfoIn.put(n, cell.getDateCellValue());
									} else {
										cell.setCellType(cell.CELL_TYPE_STRING);
										mapColumnInfoIn.put(n, cell.getStringCellValue());
									}
									break;
								case 1:
									mapColumnInfoIn.put(n, cell.getStringCellValue());
									break;
								}
							}
							else{
								mapColumnInfoIn.put(n, "");
//									break;
							}
					}
						Map map = new HashMap();
						
						String year = mapColumnInfoIn.get(0)==null?"":mapColumnInfoIn.get(0).toString();
						String quarter = mapColumnInfoIn.get(1)==null?"":mapColumnInfoIn.get(1).toString();
						String month = mapColumnInfoIn.get(2)==null?"":mapColumnInfoIn.get(2).toString();
						String assess_name = mapColumnInfoIn.get(3)==null?"":mapColumnInfoIn.get(3).toString();
						
						if(quarter.equals("第一季度")){
							quarter = "1";
						}else if(quarter.equals("第二季度")){
							quarter = "4";
						}else if(quarter.equals("第三季度")){
							quarter = "7";
						}else if(quarter.equals("第四季度")){
							quarter = "10";
						}
						
						if(year.equals("")){
							message.append("Sheet2第").append(m + 1).append("行年度不能为空，请正确输入;");
						}
						if(quarter.equals("")&&month.equals("")){
							message.append("Sheet2第").append(m + 1).append("行季度和月份不能同时为空，请正确输入;");
						}
						if(!month.equals("")&&!quarter.equals("")){
							message.append("Sheet2第").append(m + 1).append("行季度和月份只能选择其一，请正确输入;");
						}
						if(assess_name.equals("")){
							message.append("Sheet2第").append(m + 1).append("行被考核人不能为空，请正确输入;");
						}
						map.put("year", year);
						if(!quarter.equals("")&&quarter!=null){
							map.put("quarter_month", quarter);
							map.put("type", "1");
						}
						if(!month.equals("")&&month!=null){
							map.put("quarter_month", month);
							map.put("type", "2");
						}
						map.put("assess_name", assess_name);
						if(project.equals("2")){
							map.put("project_info_no", user.getProjectInfoNo());
						}else{
							map.put("project_info_no", "");
						}
						map.put("target", mapColumnInfoIn.get(4));
						map.put("score", mapColumnInfoIn.get(5));
						map.put("complete_status", mapColumnInfoIn.get(6));
						map.put("get_score", mapColumnInfoIn.get(7));
						
						map.put("break_rule", mapColumnInfoIn.get(8));
						map.put("rule_level", mapColumnInfoIn.get(9));
						datelist1.add(map);
					     	// 判断必填项处理
					}
				}
				
				
				
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportMessage(datelist, user); // 调用保存方法
				}
				if (datelist1 != null && datelist1.size() > 0) {
					saveImportMessageDetail(datelist1, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");

			}
		}
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	
	
	/**
	 * HSE绩效考核批量数据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveImportMessage (List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合

			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map dataMap = new HashMap();
				Map map123 = (HashMap) datelist.get(i); 
				
			
				dataMap.put("SECOND_ORG", map123.get("second_org"));
				dataMap.put("THIRD_ORG", map123.get("third_org"));
				dataMap.put("FOURTH_ORG", map123.get("fourth_org"));
				dataMap.put("YEAR", map123.get("year"));
				dataMap.put("QUARTER_MONTH", map123.get("quarter_month"));
				dataMap.put("TYPE", map123.get("type"));
				dataMap.put("ASSESS_NAME", map123.get("assess_name"));
				dataMap.put("ASSESS_DATE", map123.get("assess_date"));
				dataMap.put("ORG_ID", user.getOrgId());
				dataMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
				dataMap.put("CREATOR_ID", user.getUserId());
				dataMap.put("CREATE_DATE", new Date());
				dataMap.put("PROJECT_INFO_NO", map123.get("project_info_no"));
				dataMap.put("UPDATOR_ID", user.getUserId());
				dataMap.put("MODIFI_DATE", new Date());
				dataMap.put("BSFLAG", "0");
				dataMap.put("ASSESS_STATUS", "0");
				
				dataMap.put("ASSESS_POST", map123.get("assess_post"));
				dataMap.put("RESULT", map123.get("result"));
				dataMap.put("PUNISH_MONEY", map123.get("punish_money"));
				dataMap.put("ASSESS_SIGN", map123.get("assess_sign"));
				dataMap.put("SIGN_DATE", map123.get("sign_date"));
				dataMap.put("LEADER_SIGN", map123.get("leader_sign"));
				dataMap.put("LEADER_DATE", map123.get("leader_date"));
				dataMap.put("SUPERIOR_SIGN", map123.get("superior_sign"));
				dataMap.put("SUPERIOR_DATE", map123.get("superior_date"));
				dataMap.put("ASSESS_SUGGEST", map123.get("assess_suggest"));
				dataMap.put("SUPERIOR_SUGGEST", map123.get("superior_suggest"));	            
				
				Serializable id = pureJdbcDao.saveOrUpdateEntity(dataMap,"BGP_HSE_ASSESS");
				String hse_assess_id = id.toString();
				
				String memo = map123.get("memo")==null?"":map123.get("memo").toString();
				//附件添加修改
				if(!memo.equals("")&&memo!=null){
					Map remarkMap = new HashMap();
					
					remarkMap.put("FOREIGN_KEY_ID", hse_assess_id);
					remarkMap.put("NOTES", memo);
					remarkMap.put("CREATOR_ID", user.getUserId());
					remarkMap.put("CREATE_DATE", new Date());
					remarkMap.put("UPDATOR_ID", user.getUserId());
					remarkMap.put("MODIFI_DATE", new Date());
					remarkMap.put("BSFLAG", "0");
					pureJdbcDao.saveOrUpdateEntity(remarkMap,"BGP_COMM_REMARK");
				}
				
			}
		}
	}
	
	
	/**
	 * HSE绩效考核字表批量数据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveImportMessageDetail(List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合

			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i); 
			
				String year = map.get("year")==null?"":map.get("year").toString();
				String quarter_month = map.get("quarter_month")==null?"":map.get("quarter_month").toString();
				String type = map.get("type")==null?"":map.get("type").toString();
				String assess_name = map.get("assess_name")==null?"":map.get("assess_name").toString();
				String project_info_no = map.get("project_info_no")==null?"":map.get("project_info_no").toString();
				
				String sql = "select t.hse_assess_id from BGP_HSE_ASSESS t where t.year='"+year+"' and t.quarter_month='"+quarter_month+"' and t.type='"+type+"' and t.assess_name='"+assess_name+"' and t.project_info_no='"+project_info_no+"'";
				Map AssessMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
				
				String hse_assess_id = AssessMap.get("hseAssessId")==null?"":AssessMap.get("hseAssessId").toString();
				
				Map goodMap = new HashMap();
				goodMap.put("TARGET", map.get("target"));
				goodMap.put("SCORE", map.get("score"));
				goodMap.put("COMPLETE_STATUS", map.get("complete_status"));
				goodMap.put("GET_SCORE", map.get("get_score"));
				goodMap.put("TYPE", "1");
				goodMap.put("HSE_ASSESS_ID", hse_assess_id);
				goodMap.put("BSFLAG", "0");
				goodMap.put("CREATE_DATE", new Date());
				goodMap.put("CREATOR_ID", user.getUserId());
				goodMap.put("MODIFI_DATE", new Date());
				goodMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(goodMap,"BGP_HSE_ASSESS_CONTENT");
				
				Map badMap = new HashMap();
				badMap.put("BREAK_RULE", map.get("break_rule"));
				badMap.put("RULE_LEVEL", map.get("rule_level"));
				badMap.put("TYPE", "2");
				badMap.put("HSE_ASSESS_ID", hse_assess_id);
				badMap.put("BSFLAG", "0");
				badMap.put("CREATE_DATE", new Date());
				badMap.put("CREATOR_ID", user.getUserId());
				badMap.put("MODIFI_DATE", new Date());
				badMap.put("UPDATOR_ID", user.getUserId());
				pureJdbcDao.saveOrUpdateEntity(badMap,"BGP_HSE_ASSESS_CONTENT");
			}
		}
	}
	
	
	
	//HSE百万工时 ----设置
	public ISrvMsg hourSet(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat dateFm = new SimpleDateFormat("EEEE");
		
		String start_date = isrvmsg.getValue("start_date");
		String today = sdf.format(new Date());
		Date date1 = sdf.parse(start_date);
		Date date2 = sdf.parse(today);
		
		int s = (int) ((date2.getTime() - date1.getTime())/ (24 * 60 * 60 * 1000));//计算两个时间相差天数
		
		String hse_workhour_id = isrvmsg.getValue("hse_workhour_id");
		String isProject = isrvmsg.getValue("isProject");
		
		String subjection_id = user.getOrgSubjectionId();
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		if(third_org!=null&&!third_org.equals("")){
			subjection_id = third_org;
		}
		if(fourth_org!=null&&!fourth_org.equals("")){
			subjection_id = fourth_org;
		}
			
		
		if(hse_workhour_id!=null&&!hse_workhour_id.equals("")){
			String sql = "delete from bgp_hse_workhour_detail where hse_workhour_id = '"+hse_workhour_id+"'";
			jdbcTemplate.execute(sql);
		}
		
		Map map = new HashMap();
		map.put("HSE_WORKHOUR_ID", hse_workhour_id);
		map.put("SUBJECTION_ID", subjection_id);
		map.put("START_DATE", start_date);
		if(hse_workhour_id==null||hse_workhour_id.equals("")){
			if(isProject!=null&&!isProject.equals("")){
				if(isProject.equals("2")){
					map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
			}
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_WORKHOUR_SET");
		hse_workhour_id = id.toString();
		
		int allHour = 0;
		
		for(int i=1;i<7;i++){
			 String people_num = isrvmsg.getValue("people_num_"+i);
			 String monday = isrvmsg.getValue("monday_"+i);
			 String tuesday = isrvmsg.getValue("tuesday_"+i);
			 String wednesday = isrvmsg.getValue("wednesday_"+i);
			 String thursday = isrvmsg.getValue("thursday_"+i);
			 String friday = isrvmsg.getValue("friday_"+i);
			 String saturday = isrvmsg.getValue("saturday_"+i);
			 String sunday = isrvmsg.getValue("sunday_"+i);
			 
			 if(monday==null){
				 monday = "0";
			 }
			 if(tuesday==null){
				 tuesday = "0";
			 }
			 if(wednesday==null){
				 wednesday = "0";
			 }
			 if(thursday==null){
				 thursday = "0";
			 }
			 if(friday==null){
				 friday = "0";
			 }
			 if(saturday==null){
				 saturday = "0";
			 }
			 if(sunday==null){
				 sunday = "0";
			 }
			 
			 Map detMap = new HashMap();
			 detMap.put("PEOPLE_NUM", people_num);
			 detMap.put("MONDAY", monday);
			 detMap.put("TUESDAY", tuesday);
			 detMap.put("WEDNESDAY", wednesday);
			 detMap.put("THURSDAY", thursday);
			 detMap.put("FRIDAY", friday);
			 detMap.put("SATURDAY", saturday);
			 detMap.put("SUNDAY", sunday);
			 detMap.put("TYPE", i);
			 detMap.put("HSE_WORKHOUR_ID", hse_workhour_id);
			 
			 pureJdbcDao.saveOrUpdateEntity(detMap,"BGP_HSE_WORKHOUR_DETAIL");
			 
			 int hours = 0;
			 if(i==1){
					hours = 24;
				}else if(i==2){
					hours = 16;
				}else if(i==3){
					hours = 12;
				}else if(i==4){
					hours = 8;
				}else if(i==5){
					hours = 4;
				}else if(i==6){
					hours = 2;
				}
			 
			 for(int j = 0;j<=s;j++){
	              long todayDate = date1.getTime() + j * 24 * 60 * 60 * 1000;
	              Date tmDate = new Date(todayDate);
	              String ssss = new SimpleDateFormat("yyyy-MM-dd").format(tmDate);
	              String weekDay = dateFm.format(tmDate);
	              String week = "";
				 if(weekDay.equals("星期一")){
					 week = monday;
				 }else if(weekDay.equals("星期二")){
					 week = tuesday;
				 }else if(weekDay.equals("星期三")){
					 week = wednesday;
				 }else if(weekDay.equals("星期四")){
					 week = thursday;
				 }else if(weekDay.equals("星期五")){
					 week = friday;
				 }else if(weekDay.equals("星期六")){
					 week = saturday;
				 }else if(weekDay.equals("星期日")){
					 week = sunday;
				 }
				 
				 
				 if(week!=null&&week.equals("0")){
					 if(people_num==null||people_num.equals("")){
						 people_num = "0";
					 }
					 log.debug(people_num);
					 allHour += Integer.parseInt(people_num)*hours;
				 }
	            	  
	            }
		}
		
		if(isProject!=null&&isProject.equals("2")){
			
			String sqlDelete = "update  bgp_hse_workhour_single set bsflag='1' where project_info_no='"+user.getProjectInfoNo()+"'";
			jdbcTemplate.execute(sqlDelete);
			
			Map thirdMap = new HashMap();
			thirdMap.put("SUBJECTION_ID", subjection_id);
			thirdMap.put("WORKHOUR", allHour);
			thirdMap.put("RECORD_PERCENT", "");
			thirdMap.put("INJURE_PERCENT", "");
			thirdMap.put("DIE_PERCENT", "");
			thirdMap.put("BSFLAG", "0");
			thirdMap.put("CREATOR_ID", user.getUserId());
			thirdMap.put("CREATE_DATE", new Date());
			thirdMap.put("UPDATOR_ID", user.getUserId());
			thirdMap.put("MODIFI_DATE", new Date());
			thirdMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			
			pureJdbcDao.saveOrUpdateEntity(thirdMap,"BGP_HSE_WORKHOUR_SINGLE");
		}else{
			
			String sqlDelete = "update  bgp_hse_workhour_all set bsflag='1' where subjection_id='"+subjection_id+"'";
			jdbcTemplate.execute(sqlDelete);
			Map thirdMap = new HashMap();
			thirdMap.put("SUBJECTION_ID", subjection_id);
			thirdMap.put("WORKHOUR", allHour);
			thirdMap.put("RECORD_PERCENT", "");
			thirdMap.put("INJURE_PERCENT", "");
			thirdMap.put("DIE_PERCENT", "");
			thirdMap.put("BSFLAG", "0");
			thirdMap.put("CREATOR_ID", user.getUserId());
			thirdMap.put("CREATE_DATE", new Date());
			thirdMap.put("UPDATOR_ID", user.getUserId());
			thirdMap.put("MODIFI_DATE", new Date());
			
			pureJdbcDao.saveOrUpdateEntity(thirdMap,"BGP_HSE_WORKHOUR_ALL");
		}
		
		return responseDTO;
	}
	
	//HSE百万工时 ----设置集团指标
	public ISrvMsg hourSetTarget(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		
		String hse_target_id = isrvmsg.getValue("hse_target_id");
		String record_percent = isrvmsg.getValue("record_percent");
		String injure_percent = isrvmsg.getValue("injure_percent");
		String die_percent = isrvmsg.getValue("die_percent");
		
		Map map = new HashMap();
		map.put("HSE_TARGET_ID", hse_target_id);
		map.put("RECORD_PERCENT", record_percent);
		map.put("INJURE_PERCENT", injure_percent);
		map.put("DIE_PERCENT", die_percent);
		if(hse_target_id==null||hse_target_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_WORKHOUR_TARGET");
		
		return responseDTO;
	}
	
	
	//单项目停止百万工时统计
	public ISrvMsg stopWorkHour(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String projectInfoId = user.getProjectInfoNo();
		if(projectInfoId!=null&&!projectInfoId.equals("")){
			String sql = "update bgp_hse_workhour_set set bsflag='1' where project_info_no = '"+projectInfoId+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;
	}
	
	
	//HSE百万工时 
	public ISrvMsg allHourMe(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		allHour();
		return responseDTO;
	}
	
	//HSE百万工时 ----求工时
	public void allHour() throws Exception {
		
	/*
	 * 二级单位排序
	 * 		select t.org_sub_id, os.org_id, oi.org_abbreviation,t.order_num
  	 *		from bgp_hse_org t
  	 *		join comm_org_subjection os on os.org_subjection_id = t.org_sub_id
     *                       and os.bsflag = '0'
  	 *		join comm_org_information oi on os.org_id = oi.org_id
     *                         and oi.bsflag = '0'
 	 *		start with t.father_org_sub_id = 'C105' and t.org_sub_id not in ('C105083','C105082','C105080','C105079001')
	 *		connect by t.org_sub_id = prior t.father_org_sub_id 
	 *		order by t.order_num
	 * 
	 * BGP_HSE_ORG 最末级的单位
	 * select * from bgp_hse_org t where t.org_sub_id not in (select father_org_sub_id from bgp_hse_org)
	 * 
	 * 发生率统计公式：
	 *  “百万工时可记录事件发生率”等于“5.6.4 事故、事件报告、调查和处理”“事故记录”功能中所有记录中的伤亡人员三个合计数的合，加，“5.6.4 事故、事件报告、调查和处理”“事件信息报告”功能中“事件性质”为限工事件、医疗事件的记录中的受伤害人员四个伤害人数的合，再除以工时；
	 *	“百万工时损工伤亡发生率”等于“5.6.4 事故、事件报告、调查和处理”“事故记录”功能中所有记录中的伤亡人员三个合计数的合，除以工时；
	 *	“百万工时死亡事故发生率”等于“5.6.4 事故、事件报告、调查和处理”“事故记录”功能中所有记录中的伤亡人员死亡合计数，除以工时。
	 *	以上均为统计本行所属单位或下属单位相关记录、相关工时，合计行统计的是所属列相关总人数/合计行总工时。
	 * 
	 * 
	 * */	
		
		
		System.out.println("************************************************************************************************************");
		System.out.println("开始执行多项目的百万工时！！！");
		
		String sql2 = "select to_char(sysdate,'day') week,to_char(sysdate-1,'yyyy-MM-dd') yesterday,to_char(sysdate,'yyyy-MM-dd') today  from dual";
		Map map2 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql2);
		String weekDay = (String)map2.get("week");
		String today = (String)map2.get("today");
		String yesterday = (String)map2.get("yesterday");
		if(weekDay.equals("星期一")){
			weekDay = "monday";
		}else if(weekDay.equals("星期二")){
			weekDay = "tuesday";
		}else if(weekDay.equals("星期三")){
			weekDay = "wednesday";
		}else if(weekDay.equals("星期四")){
			weekDay = "thursday";
		}else if(weekDay.equals("星期五")){
			weekDay = "friday";
		}else if(weekDay.equals("星期六")){
			weekDay = "saturday";
		}else if(weekDay.equals("星期日")){
			weekDay = "sunday";
		}
		
		int hours = 1;
		int allHours = 0;
		String sqlSub = "select * from bgp_hse_workhour_set where bsflag='0' and project_info_no is null";
		List subList = BeanFactory.getQueryJdbcDAO().queryRecords(sqlSub); 
		for(int j=0;j<subList.size();j++){
			Map subMap = (Map)subList.get(j);
			String subId = (String)subMap.get("subjectionId");
			allHours = 0;
			for(int i=1;i<7;i++){
				if(i==1){
					hours = 24;
				}else if(i==2){
					hours = 16;
				}else if(i==3){
					hours = 12;
				}else if(i==4){
					hours = 8;
				}else if(i==5){
					hours = 4;
				}else if(i==6){
					hours = 2;
				}
				String sql = "select * from bgp_hse_workhour_set ws left join bgp_hse_workhour_detail wd on ws.hse_workhour_id = wd.hse_workhour_id where ws.bsflag = '0' and ws.project_info_no is null and wd.type='"+i+"'  and ws.subjection_id='"+subId+"' order by ws.subjection_id asc";
				Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
				String week = (String)map.get(weekDay);
				String people_num = (String)map.get("peopleNum")==""?"0":(String)map.get("peopleNum");
				if(week.equals("0")){
					allHours += Integer.parseInt(people_num) * hours;
				}
			}
			
			String yesterdaySql = "select * from bgp_hse_workhour_all wa where wa.subjection_id='"+subId+"' and to_char(wa.create_date,'yyyy-MM-dd')='"+yesterday+"'";
			Map yesterdayMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(yesterdaySql);
			if(yesterdayMap!=null&&!yesterdayMap.equals("")){
				String workHour = (String)yesterdayMap.get("workhour")=="" ? "0" : (String)yesterdayMap.get("workhour");
				int yesterdayHours = Integer.parseInt(workHour);
				allHours  = allHours + yesterdayHours ;
			}
			
			double acc_all4 = 0;
			double eve_all4 = 0;
			double dieNum4 = 0;
			
			//根据subId算出该单位是第几层的，在选择事故时间中的，是基层单位还是下属单位
			String levelSql = "select t.org_sub_id,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105'  start with t.org_sub_id = '"+subId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List levelList = BeanFactory.getQueryJdbcDAO().queryRecords(levelSql);
			String level = "fourth_org='";
			if(levelList.size()>2){
				level = "fourth_org='";
			}
			if(levelList.size()==2){
				level = "third_org='";
			}
			
			
			//事故记录中的伤亡人员和的SQL
			String	accSql4 = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and  an."+level+subId+"'";
			Map accMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql4);
			if(accMap4!=null&&!accMap4.equals("")){
				String die4 = (String)accMap4.get("die")=="" ? "0" : (String)accMap4.get("die");
				String harm4 = (String)accMap4.get("harm")=="" ? "0" : (String)accMap4.get("harm");
				String injure4 = (String)accMap4.get("injure")=="" ? "0" : (String)accMap4.get("injure");
				dieNum4 = Integer.parseInt(die4);
				acc_all4 = Integer.parseInt(die4)+Integer.parseInt(harm4)+Integer.parseInt(injure4);
			}
			//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
			String eveSql4 = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t."+level+subId+"' and t.event_property in ('1','2')";
			Map eveMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql4);
			if(eveMap4!=null&&!eveMap4.equals("")){
				String owner_num4 = (String)eveMap4.get("ownerNum")=="" ? "0" : (String)eveMap4.get("ownerNum");
				String out_num4 = (String)eveMap4.get("outNum")=="" ? "0" : (String)eveMap4.get("outNum");
				String stock_num4 = (String)eveMap4.get("stockNum")=="" ? "0" : (String)eveMap4.get("stockNum");
				String group_num4 = (String)eveMap4.get("groupNum")=="" ? "0" : (String)eveMap4.get("groupNum");
				eve_all4 = Integer.parseInt(owner_num4)+Integer.parseInt(out_num4)+Integer.parseInt(stock_num4)+Integer.parseInt(group_num4);
			}
			
				double accEvePercent4 = 0; 
				double accPercent4 = 0;				
				double diePercent4 = 0;
			if(allHours!=0){
				accEvePercent4 = (acc_all4+eve_all4)/allHours; //百万工时可记录事件发生率
				accPercent4 = acc_all4/allHours;				//百万工时损工伤亡发生率
				diePercent4 = dieNum4/allHours;				//百万工时死亡事故发生率
			}
			System.out.println(allHours);
			Map thirdMap = new HashMap();
			thirdMap.put("SUBJECTION_ID", subId);
			thirdMap.put("WORKHOUR", allHours);
			thirdMap.put("RECORD_PERCENT", accEvePercent4);
			thirdMap.put("INJURE_PERCENT", accPercent4);
			thirdMap.put("DIE_PERCENT", diePercent4);
			thirdMap.put("BSFLAG", "0");
			thirdMap.put("CREATOR_ID", "");
			thirdMap.put("CREATE_DATE", new Date());
			thirdMap.put("UPDATOR_ID", "");
			thirdMap.put("MODIFI_DATE", new Date());
			
			pureJdbcDao.saveOrUpdateEntity(thirdMap,"BGP_HSE_WORKHOUR_ALL");
		}
		
		
		
		
		//二级单位添加   +  三级单位添加
		String secSql = "select t.org_sub_id, os.org_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where t.father_org_sub_id = 'C105' and t.org_sub_id not in ('C105083','C105082','C105080','C105079001') and t.org_sub_id not in (select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)   order by t.order_num";
		List secList = BeanFactory.getQueryJdbcDAO().queryRecords(secSql);
		for(int m=0;m<secList.size();m++){
			Map secMap = (Map)secList.get(m);
			String subjectionId = (String)secMap.get("orgSubId");

			String thirdOrgSql = "select * from bgp_hse_org t where t.father_org_sub_id='"+subjectionId+"'  and t.org_sub_id not in (select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)";
			List thirdList = BeanFactory.getQueryJdbcDAO().queryRecords(thirdOrgSql);
			for(int n=0;n<thirdList.size();n++){
				Map thirdMap = (Map)thirdList.get(n);
				String thirdOrgId = (String)thirdMap.get("orgSubId"); 
				
				String sumSql3 = "select sum(workhour) sum from bgp_hse_workhour_all wa where wa.bsflag='0' and wa.subjection_id like '"+thirdOrgId+"%' and to_char(wa.create_date,'yyyy-MM-dd') = '"+today+"' and wa.subjection_id in  ( select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)";
				Map sumMap3 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sumSql3);
				if(sumMap3.get("sum")==null||sumMap3.get("sum").equals("")){
					allHours = 0;
				}else{
					allHours = Integer.parseInt((String)sumMap3.get("sum"));
					System.out.println(allHours);
				}
				
				double acc_all3 = 0;
				double eve_all3 = 0;
				double dieNum3 = 0;
				//事故记录中的伤亡人员和的SQL
				String	accSql3 = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and  an.third_org='"+thirdOrgId+"'";
				Map accMap3 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql3);
				if(accMap3!=null&&!accMap3.equals("")){
					String die3 = (String)accMap3.get("die")=="" ? "0" : (String)accMap3.get("die");
					String harm3 = (String)accMap3.get("harm")=="" ? "0" : (String)accMap3.get("harm");
					String injure3 = (String)accMap3.get("injure")=="" ? "0" : (String)accMap3.get("injure");
					dieNum3 = Integer.parseInt(die3);
					acc_all3 = Integer.parseInt(die3)+Integer.parseInt(harm3)+Integer.parseInt(injure3);
				}
				//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
				String eveSql3 = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.third_org='"+thirdOrgId+"' and t.event_property in ('1','2')";
				Map eveMap3 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql3);
				if(eveMap3!=null&&!eveMap3.equals("")){
					String owner_num3 = (String)eveMap3.get("ownerNum")=="" ? "0" : (String)eveMap3.get("ownerNum");
					String out_num3 = (String)eveMap3.get("outNum")=="" ? "0" : (String)eveMap3.get("outNum");
					String stock_num3 = (String)eveMap3.get("stockNum")=="" ? "0" : (String)eveMap3.get("stockNum");
					String group_num3 = (String)eveMap3.get("groupNum")=="" ? "0" : (String)eveMap3.get("groupNum");
					eve_all3 = Integer.parseInt(owner_num3)+Integer.parseInt(out_num3)+Integer.parseInt(stock_num3)+Integer.parseInt(group_num3);
				}
				
				double accEvePercent3 = 0; 
				double accPercent3 = 0;				
				double diePercent3 = 0;
				if(allHours!=0){
					accEvePercent3 = (acc_all3+eve_all3)/allHours; //百万工时可记录事件发生率
					accPercent3 = acc_all3/allHours;				//百万工时损工伤亡发生率
					diePercent3 = dieNum3/allHours;				//百万工时死亡事故发生率
				}
				Map map3 = new HashMap();
				map3.put("SUBJECTION_ID", thirdOrgId);
				map3.put("WORKHOUR", allHours);
				map3.put("RECORD_PERCENT", accEvePercent3);
				map3.put("INJURE_PERCENT", accPercent3);
				map3.put("DIE_PERCENT", diePercent3);
				map3.put("BSFLAG", "0");
				map3.put("CREATOR_ID", "");
				map3.put("CREATE_DATE", new Date());
				map3.put("UPDATOR_ID", "");
				map3.put("MODIFI_DATE", new Date());
				
				pureJdbcDao.saveOrUpdateEntity(map3,"BGP_HSE_WORKHOUR_ALL");
			}
			//百万工时求和
			String sumSql = "select sum(workhour) sum from bgp_hse_workhour_all wa where wa.bsflag='0' and wa.subjection_id like '"+subjectionId+"%' and to_char(wa.create_date,'yyyy-MM-dd') = '"+today+"' and wa.subjection_id in  ( select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)";
			Map sumMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sumSql);
			if(sumMap.get("sum")==null||sumMap.get("sum").equals("")){
				allHours = 0;
			}else{
				allHours = Integer.parseInt((String)sumMap.get("sum"));
				System.out.println(allHours);
			}
			
			double acc_all = 0;
			double eve_all = 0;
			double dieNum = 0;
			//事故记录中的伤亡人员和的SQL
			String	accSql = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and  an.second_org='"+subjectionId+"'";
			Map accMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql);
			if(accMap!=null&&!accMap.equals("")){
				String die = (String)accMap.get("die")=="" ? "0" : (String)accMap.get("die");
				String harm = (String)accMap.get("harm")=="" ? "0" : (String)accMap.get("harm");
				String injure = (String)accMap.get("injure")=="" ? "0" : (String)accMap.get("injure");
				dieNum = Integer.parseInt(die);
				acc_all = Integer.parseInt(die)+Integer.parseInt(harm)+Integer.parseInt(injure);
			}
			//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
			String eveSql = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.second_org='"+subjectionId+"' and t.event_property in ('1','2')";
			Map eveMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql);
			if(eveMap!=null&&!eveMap.equals("")){
				String owner_num = (String)eveMap.get("ownerNum")=="" ? "0" : (String)eveMap.get("ownerNum");
				String out_num = (String)eveMap.get("outNum")=="" ? "0" : (String)eveMap.get("outNum");
				String stock_num = (String)eveMap.get("stockNum")=="" ? "0" : (String)eveMap.get("stockNum");
				String group_num = (String)eveMap.get("groupNum")=="" ? "0" : (String)eveMap.get("groupNum");
				eve_all = Integer.parseInt(owner_num)+Integer.parseInt(out_num)+Integer.parseInt(stock_num)+Integer.parseInt(group_num);
			}
			
			
			double accEvePercent = 0; 
			double accPercent = 0;				
			double diePercent = 0;
			if(allHours!=0){
				accEvePercent = (acc_all+eve_all)/allHours; //百万工时可记录事件发生率
				accPercent = acc_all/allHours;				//百万工时损工伤亡发生率
				diePercent = dieNum/allHours;				//百万工时死亡事故发生率
			}
			Map secondMap = new HashMap();
			secondMap.put("SUBJECTION_ID", subjectionId);
			secondMap.put("WORKHOUR", allHours);
			secondMap.put("RECORD_PERCENT", accEvePercent);
			secondMap.put("INJURE_PERCENT", accPercent);
			secondMap.put("DIE_PERCENT", diePercent);
			secondMap.put("BSFLAG", "0");
			secondMap.put("CREATOR_ID", "");
			secondMap.put("CREATE_DATE", new Date());
			secondMap.put("UPDATOR_ID", "");
			secondMap.put("MODIFI_DATE", new Date());
			
			pureJdbcDao.saveOrUpdateEntity(secondMap,"BGP_HSE_WORKHOUR_ALL");
		}
	System.out.println("多多多**********************************************************************************************");
	System.out.println("多项目的百万工时执行结束！！！");
	
	
	//单项目百万工时
	System.out.println("单单单*************************************************************************************************");
	System.out.println("开始执单项目的百万工时！！！");
		
	int singleHours = 1;
	int allSingleHours = 0;
	String slqProject = "select * from bgp_hse_workhour_set where bsflag='0' and project_info_no is not null";
	List projectList = BeanFactory.getQueryJdbcDAO().queryRecords(slqProject); 
	for(int j=0;j<projectList.size();j++){
		Map subMap = (Map)projectList.get(j);
		String subId = (String)subMap.get("subjectionId");
		String projectInfoNo = (String)subMap.get("projectInfoNo");
		allSingleHours = 0;
		for(int i=1;i<7;i++){
			if(i==1){
				singleHours = 24;
			}else if(i==2){
				singleHours = 16;
			}else if(i==3){
				singleHours = 12;
			}else if(i==4){
				singleHours = 8;
			}else if(i==5){
				singleHours = 4;
			}else if(i==6){
				singleHours = 2;
			}
			String sql = "select * from bgp_hse_workhour_set ws left join bgp_hse_workhour_detail wd on ws.hse_workhour_id = wd.hse_workhour_id where ws.bsflag = '0' and ws.project_info_no is not null and wd.type='"+i+"'  and ws.project_info_no='"+projectInfoNo+"'";
			Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			String week = (String)map.get(weekDay);
			String people_num = (String)map.get("peopleNum")==""?"0":(String)map.get("peopleNum");
			if(week.equals("0")){
				allSingleHours += Integer.parseInt(people_num) * singleHours;
			}
		}
		
		String yesterdaySql2 = "select * from bgp_hse_workhour_single wa where wa.project_info_no='"+projectInfoNo+"' and to_char(wa.create_date,'yyyy-MM-dd')='"+yesterday+"'";
		Map yesterdayMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(yesterdaySql2);
		if(yesterdayMap!=null&&!yesterdayMap.equals("")){
			String workHour = (String)yesterdayMap.get("workhour")=="" ? "0" : (String)yesterdayMap.get("workhour");
			int yesterdayHours = Integer.parseInt(workHour);
			allSingleHours  = allSingleHours + yesterdayHours ;
		}
		
		double acc_all4 = 0;
		double eve_all4 = 0;
		double dieNum4 = 0;
		
		//根据subId算出该单位是第几层的，在选择事故时间中的，是基层单位还是下属单位
		String levelSql = "select t.org_sub_id,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105'  start with t.org_sub_id = '"+subId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		List levelList = BeanFactory.getQueryJdbcDAO().queryRecords(levelSql);
		String level = "fourth_org='";
		if(levelList.size()>2){
			level = "fourth_org='";
		}
		if(levelList.size()==2){
			level = "third_org='";
		}
		
		
		//事故记录中的伤亡人员和的SQL
		String	accSql4 = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and an.project_info_no='"+projectInfoNo+"'";
		Map accMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql4);
		if(accMap4!=null&&!accMap4.equals("")){
			String die4 = (String)accMap4.get("die")=="" ? "0" : (String)accMap4.get("die");
			String harm4 = (String)accMap4.get("harm")=="" ? "0" : (String)accMap4.get("harm");
			String injure4 = (String)accMap4.get("injure")=="" ? "0" : (String)accMap4.get("injure");
			dieNum4 = Integer.parseInt(die4);
			acc_all4 = Integer.parseInt(die4)+Integer.parseInt(harm4)+Integer.parseInt(injure4);
		}
		//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
		String eveSql4 = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.project_info_no='"+projectInfoNo+"' and t.event_property in ('1','2')";
		Map eveMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql4);
		if(eveMap4!=null&&!eveMap4.equals("")){
			String owner_num4 = (String)eveMap4.get("ownerNum")=="" ? "0" : (String)eveMap4.get("ownerNum");
			String out_num4 = (String)eveMap4.get("outNum")=="" ? "0" : (String)eveMap4.get("outNum");
			String stock_num4 = (String)eveMap4.get("stockNum")=="" ? "0" : (String)eveMap4.get("stockNum");
			String group_num4 = (String)eveMap4.get("groupNum")=="" ? "0" : (String)eveMap4.get("groupNum");
			eve_all4 = Integer.parseInt(owner_num4)+Integer.parseInt(out_num4)+Integer.parseInt(stock_num4)+Integer.parseInt(group_num4);
		}
		
			double accEvePercent4 = 0; 
			double accPercent4 = 0;				
			double diePercent4 = 0;
		if(allSingleHours!=0){
			accEvePercent4 = (acc_all4+eve_all4)/allSingleHours; //百万工时可记录事件发生率
			accPercent4 = acc_all4/allSingleHours;				//百万工时损工伤亡发生率
			diePercent4 = dieNum4/allSingleHours;				//百万工时死亡事故发生率
		}
		
		System.out.println("***************************************************************************************************");
		System.out.println("subId="+subId);
		System.out.println("workhour="+allSingleHours);
		System.out.println("accEvePercent4="+accEvePercent4);
		System.out.println("accPercent4="+accPercent4);
		System.out.println("diePercent4="+diePercent4);
		System.out.println("***************************************************************************************************");
		
		InetAddress addr = InetAddress.getLocalHost();
		String ip=addr.getHostAddress().toString();//获得本机IP
		
		Map thirdMap = new HashMap();
		thirdMap.put("SUBJECTION_ID", subId);
		thirdMap.put("WORKHOUR", allSingleHours);
		thirdMap.put("RECORD_PERCENT", accEvePercent4);
		thirdMap.put("INJURE_PERCENT", accPercent4);
		thirdMap.put("DIE_PERCENT", diePercent4);
		thirdMap.put("BSFLAG", "0");
		thirdMap.put("CREATOR_ID", ip);
		thirdMap.put("CREATE_DATE", new Date());
		thirdMap.put("UPDATOR_ID", "");
		thirdMap.put("MODIFI_DATE", new Date());
		thirdMap.put("PROJECT_INFO_NO", projectInfoNo);
		
		pureJdbcDao.saveOrUpdateEntity(thirdMap,"BGP_HSE_WORKHOUR_SINGLE");
	}
	

	String secSingleSql = " select * from bgp_hse_org ho where ho.org_sub_id in ('C105063','C105005000','C105001002','C105005004','C105002','C105005001','C105001005','C105001003','C105008','C105007')  and ho.org_sub_id not in (select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is not null) order by ho.order_num";
	List secSingleList = BeanFactory.getQueryJdbcDAO().queryRecords(secSingleSql);
	for(int m=0;m<secSingleList.size();m++){
		Map secMap = (Map)secSingleList.get(m);
		String subjectionId = (String)secMap.get("orgSubId");

		//百万工时求和
		String sumSql = "select sum(workhour) sum from bgp_hse_workhour_single wa where wa.bsflag='0' and wa.subjection_id like '"+subjectionId+"%' and to_char(wa.create_date,'yyyy-MM-dd') = '"+today+"' and wa.subjection_id in  ( select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is not null)";
		Map sumMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sumSql);
		if(sumMap.get("sum")==null||sumMap.get("sum").equals("")){
			allHours = 0;
		}else{
			allHours = Integer.parseInt((String)sumMap.get("sum"));
			System.out.println(allHours);
		}
		
		double acc_all = 0;
		double eve_all = 0;
		double dieNum = 0;
		//事故记录中的伤亡人员和的SQL
		String	accSql = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and an.project_info_no is not null and  an.second_org='"+subjectionId+"'";
		Map accMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql);
		if(accMap!=null&&!accMap.equals("")){
			String die = (String)accMap.get("die")=="" ? "0" : (String)accMap.get("die");
			String harm = (String)accMap.get("harm")=="" ? "0" : (String)accMap.get("harm");
			String injure = (String)accMap.get("injure")=="" ? "0" : (String)accMap.get("injure");
			dieNum = Integer.parseInt(die);
			acc_all = Integer.parseInt(die)+Integer.parseInt(harm)+Integer.parseInt(injure);
		}
		//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
		String eveSql = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.project_info_no is not null and t.second_org='"+subjectionId+"' and t.event_property in ('1','2')";
		Map eveMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql);
		if(eveMap!=null&&!eveMap.equals("")){
			String owner_num = (String)eveMap.get("ownerNum")=="" ? "0" : (String)eveMap.get("ownerNum");
			String out_num = (String)eveMap.get("outNum")=="" ? "0" : (String)eveMap.get("outNum");
			String stock_num = (String)eveMap.get("stockNum")=="" ? "0" : (String)eveMap.get("stockNum");
			String group_num = (String)eveMap.get("groupNum")=="" ? "0" : (String)eveMap.get("groupNum");
			eve_all = Integer.parseInt(owner_num)+Integer.parseInt(out_num)+Integer.parseInt(stock_num)+Integer.parseInt(group_num);
		}
		
		
		double accEvePercent = 0; 
		double accPercent = 0;				
		double diePercent = 0;
		if(allHours!=0){
			accEvePercent = (acc_all+eve_all)/allHours; //百万工时可记录事件发生率
			accPercent = acc_all/allHours;				//百万工时损工伤亡发生率
			diePercent = dieNum/allHours;				//百万工时死亡事故发生率
		}
		Map secondMap = new HashMap();
		secondMap.put("SUBJECTION_ID", subjectionId);
		secondMap.put("WORKHOUR", allHours);
		secondMap.put("RECORD_PERCENT", accEvePercent);
		secondMap.put("INJURE_PERCENT", accPercent);
		secondMap.put("DIE_PERCENT", diePercent);
		secondMap.put("BSFLAG", "0");
		secondMap.put("CREATOR_ID", "");
		secondMap.put("CREATE_DATE", new Date());
		secondMap.put("UPDATOR_ID", "");
		secondMap.put("MODIFI_DATE", new Date());
		
		pureJdbcDao.saveOrUpdateEntity(secondMap,"BGP_HSE_WORKHOUR_SINGLE");
	}
	System.out.println("单单单*************************************************************************************************");
	System.out.println("项目的百万工时执行结束！！！");
		
	}
	
	
	
	//人力资源---HSE专业人员
	public ISrvMsg addProfessional(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_professional_id = isrvmsg.getValue("hse_professional_id");
		String project = isrvmsg.getValue("project");
		String employee_id = isrvmsg.getValue("employee_id");
		String work_property = isrvmsg.getValue("work_property");
		String plate_property = isrvmsg.getValue("plate_property");
		String safeflag = isrvmsg.getValue("safeflag");
		String start_date = isrvmsg.getValue("start_date");
		String person_status = isrvmsg.getValue("person_status");
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from bgp_hse_professional t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_professional_id = (String)mapEmp.get("hseProfessionalId");
			}
			
		}
		
		
		
		
		Map map = new HashMap();
		map.put("HSE_PROFESSIONAL_ID", hse_professional_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("WORK_PROPERTY", work_property);
		map.put("PLATE_PROPERTY", plate_property);
		map.put("SAFEFLAG", safeflag);
		map.put("START_DATE", start_date);
		map.put("PERSON_STATUS", person_status);
		if(hse_professional_id==null||hse_professional_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_PROFESSIONAL");
		hse_professional_id = id.toString();
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//人力资源---HSE专业人员---专业证书
	public ISrvMsg saveCertificate(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_professional_id = isrvmsg.getValue("hse_professional_id");
		String ids = isrvmsg.getValue("ids");
		
		if(hse_professional_id!=null&&!hse_professional_id.equals("")){
			String sql = "delete from bgp_hse_professional_cert where hse_professional_id = '"+hse_professional_id+"'";
			jdbcTemplate.execute(sql);
		}
		
		if(ids!=null&&!ids.equals("")){
			String[] id = ids.split(",");
			for(int i=0;i<id.length;i++){
				String order = id[i];
				String certifcate_name = isrvmsg.getValue("certificate_name"+order);
				String certifcate_date = isrvmsg.getValue("certificate_date"+order);
				
				Map map = new HashMap();
				map.put("CERTIFICATE_NAME", certifcate_name);
				map.put("CERTIFICATE_DATE", certifcate_date);
				map.put("HSE_PROFESSIONAL_ID", hse_professional_id);
				pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_PROFESSIONAL_CERT");
			}
		}
		
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryProfessional(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_professional_id = isrvmsg.getValue("hse_professional_id");
		
		String sql = "select * from (select * from (select hp.hse_professional_id,hp.employee_id,hp.work_property,hp.plate_property,hp.safeflag,hp.project_info_no,hp.start_date,hp.bsflag,hp.person_status,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type, case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,cd.coding_name title,cc.days,cc.color,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter from bgp_hse_professional hp left join comm_human_employee ee on hp.employee_id = ee.employee_id and ee.bsflag = '0'   left join comm_coding_sort_detail sd    on ee.employee_education_level = sd.coding_code_id   and sd.bsflag = '0'       left join bgp_comm_human_technic ht        on ht.employee_id = ee.employee_id       and ht.bsflag = '0'       left join comm_coding_sort_detail cd      on ht.expert_sort = cd.coding_code_id    and cd.bsflag = '0'  left join comm_human_employee_hr hr on ee.employee_id = hr.employee_id and hr.bsflag='0'          left join bgp_comm_human_labor la on la.labor_id=hp.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0' left join comm_org_subjection os1 on hp.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hp.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hp.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0' left join (select pc.hse_certificate_id,pc.certificate_date,pc.hse_professional_id,pc.certificate_date -to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd') days, case when months_between(pc.certificate_date,to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')) <= 0 then 'red' when months_between(pc.certificate_date, to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')) > 2 then '' else 'orange' end color from bgp_hse_professional_cert pc where pc.certificate_date is not null order by pc.certificate_date asc) cc on cc.hse_professional_id = hp.hse_professional_id where hp.bsflag = '0' order by hp.modifi_date desc) where bsflag='0' and hse_professional_id = '"+hse_professional_id+"' ) ";
//		String sql = "select * from (select hp.*, ee.employee_name,cd.coding_name title,ee.employee_id_code_no,decode(ee.employee_gender,'0','女','1','男') sex,sd.coding_name,decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') human_scotter, oi1.org_abbreviation second_org_name, oi2.org_abbreviation third_org_name, oi3.org_abbreviation fourth_org_name"
//					+" from bgp_hse_professional hp join comm_human_employee ee on hp.employee_id = ee.employee_id and ee.bsflag = '0'"
//					+" left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0'"
//					+" left join comm_human_employee_hr hr on ee.employee_id = hr.employee_id and hr.bsflag='0'"
//					+" left join comm_org_subjection os1 on os1.org_subjection_id=hp.second_org and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0'"
//					+" left join comm_org_subjection os2 on os2.org_subjection_id=hp.third_org and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0'"
//					+" left join comm_org_subjection os3 on os3.org_subjection_id=hp.fourth_org and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0' where hp.bsflag = '0' and hp.hse_professional_id = '"+hse_professional_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		String certSql = "select pc.hse_certificate_id,pc.certificate_name,pc.certificate_date,pc.certificate_date-to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd') days, months_between(pc.certificate_date,to_date(to_char(sysdate, 'yyyy-MM-dd'), 'yyyy-MM-dd')) color  from bgp_hse_professional_cert pc where pc.hse_professional_id='"+hse_professional_id+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(certSql);
		
		responseDTO.setValue("list", list);
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteProfessional(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_professional_ids = isrvmsg.getValue("hse_professional_id");
		String ids[] =  hse_professional_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_professional set bsflag = '1' where hse_professional_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//人力资源---特种作业人员
	public ISrvMsg addSpecialWork(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_special_id = isrvmsg.getValue("hse_special_id");
		String project = isrvmsg.getValue("project");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		String work_type = isrvmsg.getValue("work_type");
		String certificate_name = isrvmsg.getValue("certificate_name");
		String certificate_org = isrvmsg.getValue("certificate_org");
		String check_date = isrvmsg.getValue("check_date");
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_SPECIAL_WORK t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_special_id = (String)mapEmp.get("hseSpecialId");
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_SPECIAL_ID", hse_special_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("WORK_TYPE", work_type);
		map.put("CERTIFICATE_NAME", certificate_name);
		map.put("CERTIFICATE_ORG", certificate_org);
		map.put("CHECK_DATE", check_date);
		map.put("PERSON_STATUS", person_status);
		if(hse_special_id==null||hse_special_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_SPECIAL_WORK");
		hse_special_id = id.toString();
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg querySpecialWork(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_special_id = isrvmsg.getValue("hse_special_id");
		
		String sql = "select * from (select sw.hse_special_id,sw.employee_id,sw.work_type,sw.certificate_name,sw.certificate_org,sw.check_date,sw.person_status,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type, case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter  from bgp_hse_special_work sw left join comm_human_employee ee on sw.employee_id=ee.employee_id and ee.bsflag='0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on sw.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on sw.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on sw.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0'  left join bgp_comm_human_labor la on la.labor_id=sw.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0' where sw.bsflag='0' and sw.hse_special_id='"+hse_special_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteSpecialWork(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_special_ids = isrvmsg.getValue("hse_special_id");
		String ids[] =  hse_special_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_special_work set bsflag = '1' where hse_special_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//人力资源---司驾人员
	public ISrvMsg addDriver(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_driver_id = isrvmsg.getValue("hse_driver_id");
		String project = isrvmsg.getValue("project");
		String remark_id = isrvmsg.getValue("remark_id");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		
		String danger_driver = isrvmsg.getValue("danger_driver");
		String special_driver = isrvmsg.getValue("special_driver");
		String type_num = isrvmsg.getValue("type_num");
		String driver_date = isrvmsg.getValue("driver_date");
		String doc_num = isrvmsg.getValue("doc_num");
		String driver_type = isrvmsg.getValue("driver_type");
		String duty = isrvmsg.getValue("duty");
		String inner_type = isrvmsg.getValue("inner_type");
		String driving_num = isrvmsg.getValue("driving_num");
		String driving_org = isrvmsg.getValue("driving_org");
		String signer = isrvmsg.getValue("signer");
		String sign_date = isrvmsg.getValue("sign_date");
		String useful_life = isrvmsg.getValue("useful_life");
		String second_person = isrvmsg.getValue("second_person");
		String phone = isrvmsg.getValue("phone");
		String remark = isrvmsg.getValue("memo");
		
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_DRIVER t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_driver_id = (String)mapEmp.get("hseDriverId");
				
				String sqlRemark = "select * from  bgp_comm_remark r where  r.bsflag='0' and r.foreign_key_id='"+hse_driver_id+"'";
				Map mapRemark = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlRemark);
				if(mapRemark!=null){
					remark_id = (String)mapEmp.get("remarkId");
				}
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_DRIVER_ID", hse_driver_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("PERSON_STATUS", person_status);
		map.put("DANGER_DRIVER", danger_driver);
		map.put("SPECIAL_DRIVER", special_driver);
		map.put("TYPE_NUM", type_num);
		map.put("DRIVER_DATE", driver_date);
		map.put("DOC_NUM", doc_num);
		map.put("DRIVER_TYPE", driver_type);
		map.put("DUTY", duty);
		map.put("INNER_TYPE", inner_type);
		map.put("DRIVING_NUM", driving_num);
		map.put("DRIVING_ORG", driving_org);
		map.put("SIGNER", signer);
		map.put("SIGN_DATE", sign_date);
		map.put("USEFUL_LIFE", useful_life);
		map.put("SECOND_PERSON", second_person);
		map.put("PHONE", phone);
		if(hse_driver_id==null||hse_driver_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project!=null&&project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_DRIVER");
		hse_driver_id = id.toString();
		
		
		if(remark!=null&&!remark.equals("")){
			Map remarkMap = new HashMap();
			
			remarkMap.put("REMARK_ID", remark_id);
			remarkMap.put("FOREIGN_KEY_ID", hse_driver_id);
			remarkMap.put("NOTES", remark);
			if(remark_id==null||remark_id.equals("")){
				remarkMap.put("CREATOR_ID", user.getUserId());
				remarkMap.put("CREATE_DATE", new Date());
			}
			remarkMap.put("UPDATOR_ID", user.getUserId());
			remarkMap.put("MODIFI_DATE", new Date());
			remarkMap.put("BSFLAG", "0");
			pureJdbcDao.saveOrUpdateEntity(remarkMap,"BGP_COMM_REMARK");
		}
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryDriver(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_driver_id = isrvmsg.getValue("hse_driver_id");
		
		String sql = "select * from (select hd.hse_driver_id,hd.employee_id,hd.person_status,hd.danger_driver,hd.special_driver,hd.type_num,hd.driver_date,hd.doc_num,hd.driver_type,hd.duty,hd.inner_type,hd.driving_num,hd.driving_org,hd.signer,hd.sign_date,hd.useful_life,hd.second_person,hd.phone,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type, case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter ,cr.remark_id,cr.notes from bgp_hse_driver hd left join comm_human_employee ee on hd.employee_id=ee.employee_id and ee.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on hd.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hd.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hd.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_remark cr on cr.foreign_key_id=hd.hse_driver_id and cr.bsflag='0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0' left join bgp_comm_human_labor la on la.labor_id=hd.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0'  where hd.bsflag='0' and hd.hse_driver_id='"+hse_driver_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteDriver(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_driver_ids = isrvmsg.getValue("hse_driver_id");
		String ids[] =  hse_driver_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_driver set bsflag = '1' where hse_driver_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	
	//人力资源---应急人员
	public ISrvMsg addStrain(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_strain_id = isrvmsg.getValue("hse_strain_id");
		String project = isrvmsg.getValue("project");
		String remark_id = isrvmsg.getValue("remark_id");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		
		String strain_type = isrvmsg.getValue("strain_type");
		String strain_duty = isrvmsg.getValue("strain_duty");
		String first_phone = isrvmsg.getValue("first_phone");
		String second_phone = isrvmsg.getValue("second_phone");
		String expert_flag = isrvmsg.getValue("expert_flag");
		String expert_level = isrvmsg.getValue("expert_level");
		String expert_field = isrvmsg.getValue("expert_field");
		String expert_duty = isrvmsg.getValue("expert_duty");
		String remark = isrvmsg.getValue("memo");
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_STRAIN t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_strain_id = (String)mapEmp.get("hseStrainId");
				
				String sqlRemark = "select * from  bgp_comm_remark r where  r.bsflag='0' and r.foreign_key_id='"+hse_strain_id+"'";
				Map mapRemark = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlRemark);
				if(mapRemark!=null){
					remark_id = (String)mapEmp.get("remarkId");
				}
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_STRAIN_ID", hse_strain_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("PERSON_STATUS", person_status);
		map.put("STRAIN_TYPE", strain_type);
		map.put("STRAIN_DUTY", strain_duty);
		map.put("FIRST_PHONE", first_phone);
		map.put("SECOND_PHONE", second_phone);
		map.put("EXPERT_FLAG", expert_flag);
		map.put("EXPERT_LEVEL", expert_level);
		map.put("EXPERT_FIELD", expert_field);
		map.put("EXPERT_DUTY", expert_duty);
		if(hse_strain_id==null||hse_strain_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_STRAIN");
		hse_strain_id = id.toString();
		
		
		if(!remark.equals("")&&remark!=null){
			Map remarkMap = new HashMap();
			
			remarkMap.put("REMARK_ID", remark_id);
			remarkMap.put("FOREIGN_KEY_ID", hse_strain_id);
			remarkMap.put("NOTES", remark);
			if(remark_id==null||remark_id.equals("")){
				remarkMap.put("CREATOR_ID", user.getUserId());
				remarkMap.put("CREATE_DATE", new Date());
			}
			remarkMap.put("UPDATOR_ID", user.getUserId());
			remarkMap.put("MODIFI_DATE", new Date());
			remarkMap.put("BSFLAG", "0");
			pureJdbcDao.saveOrUpdateEntity(remarkMap,"BGP_COMM_REMARK");
		}
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryStrain(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_strain_id = isrvmsg.getValue("hse_strain_id");
		
		String sql = "select * from (select hs.hse_strain_id,hs.employee_id,hs.person_status,hs.strain_type,hs.strain_duty,hs.first_phone,hs.second_phone,hs.expert_flag,hs.expert_level,hs.expert_field,hs.expert_duty,hs.bsflag,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter ,cr.remark_id,cr.notes from bgp_hse_strain hs left join comm_human_employee ee on ee.employee_id=hs.employee_id and ee.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on hs.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hs.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hs.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join bgp_comm_remark cr on cr.foreign_key_id=hs.hse_strain_id and cr.bsflag='0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0'  left join bgp_comm_human_labor la on la.labor_id=hs.employee_id and la.bsflag='0'  left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0'  where hs.bsflag='0' and hs.hse_strain_id='"+hse_strain_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteStrain(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_strain_ids = isrvmsg.getValue("hse_strain_id");
		String ids[] =  hse_strain_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_strain set bsflag = '1' where hse_strain_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//人力资源---餐饮从业人员
	public ISrvMsg addCater(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_cater_id = isrvmsg.getValue("hse_cater_id");
		String project = isrvmsg.getValue("project");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		
		String certificate_name = isrvmsg.getValue("certificate_name");
		String certificate_num = isrvmsg.getValue("certificate_num");
		String certificate_org = isrvmsg.getValue("certificate_org");
		String check_date = isrvmsg.getValue("check_date");
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_CATER t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_cater_id = (String)mapEmp.get("hseCaterId");
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_CATER_ID", hse_cater_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("PERSON_STATUS", person_status);
		map.put("CERTIFICATE_NAME", certificate_name);
		map.put("CERTIFICATE_NUM", certificate_num);
		map.put("CERTIFICATE_ORG", certificate_org);
		map.put("CHECK_DATE", check_date);
		if(hse_cater_id==null||hse_cater_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_CATER");
		hse_cater_id = id.toString();
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryCater(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_cater_id = isrvmsg.getValue("hse_cater_id");
		
		String sql = "select * from (select hc.hse_cater_id,hc.employee_id,hc.person_status,hc.certificate_name,hc.certificate_num,hc.certificate_org,hc.check_date,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter  from bgp_hse_cater hc left join comm_human_employee ee on hc.employee_id=ee.employee_id and ee.bsflag='0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on hc.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hc.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hc.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0'  left join bgp_comm_human_labor la on la.labor_id=hc.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0' where hc.bsflag='0' and hc.hse_cater_id='"+hse_cater_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteCater(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_cater_ids = isrvmsg.getValue("hse_cater_id");
		String ids[] =  hse_cater_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_cater set bsflag = '1' where hse_cater_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//人力资源---涉爆人员
	public ISrvMsg addBlast(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_blast_id = isrvmsg.getValue("hse_blast_id");
		String project = isrvmsg.getValue("project");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		
		String certificate_name = isrvmsg.getValue("certificate_name");
		String certificate_num = isrvmsg.getValue("certificate_num");
		String certificate_org = isrvmsg.getValue("certificate_org");
		String check_date = isrvmsg.getValue("check_date");
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_BLAST t where t.bsflag='0'  and t.project_info_no='"+user.getProjectInfoNo()+"' and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_blast_id = (String)mapEmp.get("hseBlastId");
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_BLAST_ID", hse_blast_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("PERSON_STATUS", person_status);
		map.put("CERTIFICATE_NAME", certificate_name);
		map.put("CERTIFICATE_NUM", certificate_num);
		map.put("CERTIFICATE_ORG", certificate_org);
		map.put("CHECK_DATE", check_date);
		if(hse_blast_id==null||hse_blast_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_BLAST");
		hse_blast_id = id.toString();
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryBlast(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_blast_id = isrvmsg.getValue("hse_blast_id");
		
		String sql = "select * from (select hb.hse_blast_id,hb.employee_id,hb.person_status,hb.certificate_name,hb.certificate_num,hb.certificate_org,hb.check_date,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter   from bgp_hse_blast hb left join comm_human_employee ee on hb.employee_id=ee.employee_id and ee.bsflag='0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on hb.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hb.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hb.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0' left join bgp_comm_human_labor la on la.labor_id=hb.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0' where hb.bsflag='0' and hb.hse_blast_id='"+hse_blast_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteBlast(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_blast_ids = isrvmsg.getValue("hse_blast_id");
		String ids[] =  hse_blast_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_blast set bsflag = '1' where hse_blast_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	//人力资源---职业健康人员
	public ISrvMsg addHealth(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_health_id = isrvmsg.getValue("hse_health_id");
		String project = isrvmsg.getValue("project");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		
		String health_post = isrvmsg.getValue("health_post");
		String post_date = isrvmsg.getValue("post_date");
		String radioactive = isrvmsg.getValue("radioactive");
		String medical_history = isrvmsg.getValue("medical_history");
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_HEALTH t where t.bsflag='0'  and t.project_info_no='"+user.getProjectInfoNo()+"' and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_health_id = (String)mapEmp.get("hseHealthId");
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_HEALTH_ID", hse_health_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("PERSON_STATUS", person_status);
		map.put("HEALTH_POST", health_post);
		map.put("POST_DATE", post_date);
		map.put("RADIOACTIVE", radioactive);
		map.put("MEDICAL_HISTORY", medical_history);
		if(hse_health_id==null||hse_health_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_HEALTH");
		hse_health_id = id.toString();
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryHealth(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_health_id = isrvmsg.getValue("hse_health_id");
		
		String sql = "select * from (select hh.hse_health_id,hh.employee_id,hh.person_status,hh.health_post,hh.post_date,hh.radioactive,hh.medical_history,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter  from bgp_hse_health hh left join comm_human_employee ee on hh.employee_id=ee.employee_id and ee.bsflag='0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on hh.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hh.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hh.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0' left join bgp_comm_human_labor la on la.labor_id=hh.employee_id and la.bsflag='0'  left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0' where hh.bsflag='0' and hh.hse_health_id='"+hse_health_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteHealth(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_health_ids = isrvmsg.getValue("hse_health_id");
		String ids[] =  hse_health_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_health set bsflag = '1' where hse_health_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//人力资源--医护人员
	public ISrvMsg addMedical(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_medical_id = isrvmsg.getValue("hse_medical_id");
		String project = isrvmsg.getValue("project");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		String work_type = isrvmsg.getValue("work_type");
		String certificate_name = isrvmsg.getValue("certificate_name");
		String certificate_num = isrvmsg.getValue("certificate_num");
		String certificate_org = isrvmsg.getValue("certificate_org");
		String check_date = isrvmsg.getValue("check_date");
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_MEDICAL t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_medical_id = (String)mapEmp.get("hseMedicalId");
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_MEDICAL_ID", hse_medical_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("WORK_TYPE", work_type);
		map.put("CERTIFICATE_NAME", certificate_name);
		map.put("CERTIFICATE_NUM", certificate_num);
		map.put("CERTIFICATE_ORG", certificate_org);
		map.put("CHECK_DATE", check_date);
		map.put("PERSON_STATUS", person_status);
		if(hse_medical_id==null||hse_medical_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_MEDICAL");
		hse_medical_id = id.toString();
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryMedical(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_medical_id = isrvmsg.getValue("hse_medical_id");
		
		String sql = "select * from (select hm.hse_medical_id,hm.employee_id,hm.person_status,hm.work_type,hm.certificate_name,hm.certificate_num,hm.certificate_org,hm.check_date,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter from bgp_hse_medical hm left join comm_human_employee ee on hm.employee_id=ee.employee_id and ee.bsflag='0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on hm.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hm.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hm.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0'  left join bgp_comm_human_labor la on la.labor_id=hm.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0' where hm.bsflag='0' and hm.hse_medical_id='"+hse_medical_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteMedical(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_medical_ids = isrvmsg.getValue("hse_medical_id");
		String ids[] =  hse_medical_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_medical set bsflag = '1' where hse_medical_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//人力资源--水域施工人员
	public ISrvMsg addWaterPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_water_id = isrvmsg.getValue("hse_water_id");
		String project = isrvmsg.getValue("project");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		String certificate_flag = isrvmsg.getValue("certificate_flag");
		String certificate_date = isrvmsg.getValue("certificate_date");
		String certificate_num = isrvmsg.getValue("certificate_num");
		String certificate_org = isrvmsg.getValue("certificate_org");
		
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_WATER t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_water_id = (String)mapEmp.get("hseWaterId");
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_WATER_ID", hse_water_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("CERTIFICATE_FLAG", certificate_flag);
		map.put("CERTIFICATE_DATE", certificate_date);
		map.put("CERTIFICATE_ORG", certificate_org);
		map.put("CERTIFICATE_NUM", certificate_num);
		map.put("PERSON_STATUS", person_status);
		if(hse_water_id==null||hse_water_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(project.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_WATER");
		hse_water_id = id.toString();
		
		
		responseDTO.setValue("project", project);
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryWaterPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_water_id = isrvmsg.getValue("hse_water_id");
		
		String sql = "select * from (select hw.hse_water_id,hw.employee_id,hw.person_status,hw.certificate_flag,hw.certificate_date,hw.certificate_org,hw.certificate_num,cd.coding_name title,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,case when ee.employee_id is null then sd3.coding_name else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工') end human_scotter  from bgp_hse_water hw left join comm_human_employee ee on hw.employee_id=ee.employee_id and ee.bsflag='0' left join comm_coding_sort_detail sd on ee.employee_education_level=sd.coding_code_id and sd.bsflag='0' left join comm_human_employee_hr hr on ee.employee_id=hr.employee_id and hr.bsflag='0' left join comm_org_subjection os1 on hw.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hw.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hw.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join bgp_comm_human_technic ht on ht.employee_id=ee.employee_id and ht.bsflag='0' left join comm_coding_sort_detail cd on ht.expert_sort=cd.coding_code_id and cd.bsflag='0'  left join bgp_comm_human_labor la on la.labor_id=hw.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_coding_sort_detail sd3 on la.if_engineer=sd3.coding_code_id and sd3.bsflag='0' where hw.bsflag='0' and hw.hse_water_id='"+hse_water_id+"' order by ht.receive_date desc) where rownum=1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteWaterPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_water_ids = isrvmsg.getValue("hse_water_id");
		String ids[] =  hse_water_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_water set bsflag = '1' where hse_water_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//专业技能，技术资源
	public ISrvMsg addTechResource(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		/*
		 *  专业技能/技术资源下的4个子模块公用一个数据表，时间都是comm_date 截止时间都是the_end_date 
		 *  根据model_type来区分4个模块，1--HSE培训师  2--HSE内审员 3--注册HSE审核员 4--注册安全工程师
		*/
		
		String hse_tech_id = isrvmsg.getValue("hse_tech_id");
		String isProject = isrvmsg.getValue("isProject");
		String employee_id = isrvmsg.getValue("employee_id");
		String person_status = isrvmsg.getValue("person_status");
		String plate_property = isrvmsg.getValue("plate_property");
		String comm_date = isrvmsg.getValue("comm_date");
		String certificate_name = isrvmsg.getValue("certificate_name");
		String certificate_org = isrvmsg.getValue("certificate_org");
		String certificate_num = isrvmsg.getValue("certificate_num");
		String org_level = isrvmsg.getValue("org_level");
		String licence_num = isrvmsg.getValue("licence_num");
		String the_end_date = isrvmsg.getValue("the_end_date");
		String model_type = isrvmsg.getValue("model_type");
		String assessor_type = isrvmsg.getValue("assessor_type");
		
		
		String second_org = "";
		String third_org = "";
		String fourth_org = "";
		if(employee_id!=null&&!employee_id.equals("")){
			String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+employee_id+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list.size()!=0){
				int len = list.size();
				if(len>0){
					second_org = (String)((Map)list.get(0)).get("orgSubId");
				}
				if(len>1){
					third_org = (String)((Map)list.get(1)).get("orgSubId");
				}
				if(len>2){
					fourth_org = (String)((Map)list.get(2)).get("orgSubId");
				}
			}
			//判断人员是否存在，如果存在，更新数据
			String sqlEmp = "select * from BGP_HSE_TECH_RESOURCE t where t.bsflag='0' and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.model_type='"+model_type+"' and t.employee_id='"+employee_id+"'";
			Map mapEmp = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlEmp);
			if(mapEmp!=null){
				hse_tech_id = (String)mapEmp.get("hseTechId");
			}
		}
		
		Map map = new HashMap();
		map.put("HSE_TECH_ID", hse_tech_id);
		map.put("EMPLOYEE_ID", employee_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("PERSON_STATUS", person_status);
		map.put("PLATE_PROPERTY", plate_property);
		map.put("COMM_DATE", comm_date);
		map.put("CERTIFICATE_NAME", certificate_name);
		map.put("CERTIFICATE_ORG", certificate_org);
		map.put("CERTIFICATE_NUM", certificate_num);
		map.put("ORG_LEVEL", org_level);
		map.put("LICENCE_NUM", licence_num);   //执业证号
		map.put("THE_END_DATE", the_end_date);
		map.put("MODEL_TYPE", model_type);      //区分4个的模块
		map.put("ASSESSOR_TYPE", assessor_type);  //注册HSE审核员 类别
		
		if(hse_tech_id==null||hse_tech_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(isProject.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_TECH_RESOURCE");
		hse_tech_id = id.toString();
		
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryTechResource(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_tech_id = isrvmsg.getValue("hse_tech_id");
		
		String sql = "select *  from (select tr.hse_tech_id,  tr.employee_id,  tr.person_status,tr.plate_property,tr.comm_date,tr.certificate_name,tr.certificate_org,tr.certificate_num,tr.licence_num,tr.org_level,tr.the_end_date,tr.model_type,tr.assessor_type,  cd.coding_name title,  case  when ee.employee_id is null then  la.employee_name  else  ee.employee_name  end employee_name,  case  when ee.employee_id is null then  la.employee_id_code_no  else  ee.employee_id_code_no  end code_id,  case  when ee.employee_id is null then  decode(la.employee_gender, '0', '女', '1', '男')  else  decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男')  end sex_type,  case  when ee.employee_id is null then  sd2.coding_name  else  sd.coding_name  end coding_name,  oi1.org_abbreviation second_org_name,  oi2.org_abbreviation third_org_name,  oi3.org_abbreviation fourth_org_name,  case   when ee.employee_id is null then    sd3.coding_name   else decode(hr.spare7,'0','一线员工','1','境外员工','2','二三线员工')  end human_scotter  from bgp_hse_tech_resource tr  left join comm_human_employee ee  on tr.employee_id = ee.employee_id  and ee.bsflag = '0'  left join comm_coding_sort_detail sd  on ee.employee_education_level = sd.coding_code_id  and sd.bsflag = '0'  left join comm_human_employee_hr hr  on ee.employee_id = hr.employee_id  and hr.bsflag = '0'  left join comm_org_subjection os1  on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on os1.org_id = oi1.org_id  and oi1.bsflag = '0'  left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left join comm_org_information oi2  on os2.org_id = oi2.org_id  and oi2.bsflag = '0'  left join comm_org_subjection os3  on tr.fourth_org = os3.org_subjection_id  and os3.bsflag = '0'  left join comm_org_information oi3  on os3.org_id = oi3.org_id  and oi3.bsflag = '0'  left join bgp_comm_human_technic ht  on ht.employee_id = ee.employee_id  and ht.bsflag = '0'  left join comm_coding_sort_detail cd  on ht.expert_sort = cd.coding_code_id  and cd.bsflag = '0'  left join bgp_comm_human_labor la  on la.labor_id = tr.employee_id  and la.bsflag = '0'  left join comm_coding_sort_detail sd2  on la.employee_education_level = sd2.coding_code_id  and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3  on la.if_engineer = sd3.coding_code_id  and sd3.bsflag = '0'  where tr.bsflag = '0'  and tr.hse_tech_id = '"+hse_tech_id+"'  order by ht.receive_date desc)  where rownum = 1";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteTechResource(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_tech_ids = isrvmsg.getValue("hse_tech_id");
		String ids[] =  hse_tech_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_tech_resource set bsflag = '1' where hse_tech_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	//财力资源 
	public ISrvMsg addFinancial(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_financial_id = isrvmsg.getValue("hse_financial_id");
		String isProject = isrvmsg.getValue("isProject");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String fourth_org = isrvmsg.getValue("fourth_org");
		String project_name = isrvmsg.getValue("project_name");
		String plan_money = isrvmsg.getValue("plan_money");
		String money_source = isrvmsg.getValue("money_source");
		String declare_person = isrvmsg.getValue("declare_person");
		String declare_date = isrvmsg.getValue("declare_date");
		
		
		Map map = new HashMap();
		map.put("HSE_FINANCIAL_ID", hse_financial_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("FOURTH_ORG", fourth_org);
		map.put("PROJECT_NAME", project_name);
		map.put("PLAN_MONEY", plan_money);
		map.put("MONEY_SOURCE", money_source);
		map.put("DECLARE_PERSON", declare_person);
		map.put("DECLARE_DATE", declare_date);
		if(hse_financial_id==null||hse_financial_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
			if(isProject.equals("2")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_FINANCIAL");
		hse_financial_id = id.toString();
		
		return responseDTO;
	}
	
	//财力资源 
	public ISrvMsg addFinancialDetail(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_financial_id = isrvmsg.getValue("hse_financial_id");
		
		String hse_detail_id = isrvmsg.getValue("hse_detail_id");
		String plan_flag = isrvmsg.getValue("plan_flag");
		String second_org22 = isrvmsg.getValue("second_org22");
		String third_org22 = isrvmsg.getValue("third_org22");
		String fourth_org22 = isrvmsg.getValue("fourth_org22");
		String project_name22 = isrvmsg.getValue("project_name22");
		String input_money = isrvmsg.getValue("input_money");
		String gap_money = isrvmsg.getValue("gap_money");
		String complete_date = isrvmsg.getValue("complete_date");
		String duty_person = isrvmsg.getValue("duty_person");

		Map map2 = new HashMap();
		map2.put("HSE_DETAIL_ID", hse_detail_id);
		map2.put("PLAN_FLAG", plan_flag);
		map2.put("SECOND_ORG", second_org22);
		map2.put("THIRD_ORG", third_org22);
		map2.put("FOURTH_ORG", fourth_org22);
		map2.put("PROJECT_NAME", project_name22);
		map2.put("INPUT_MONEY", input_money);
		map2.put("GAP_MONEY", gap_money);
		map2.put("DUTY_PERSON", duty_person);
		map2.put("COMPLETE_DATE", complete_date);
		map2.put("HSE_FINANCIAL_ID", hse_financial_id);
		if(hse_detail_id==null||hse_detail_id.equals("")){
			map2.put("CREATE_DATE", new Date());
			map2.put("CREATOR_ID", user.getUserId());
		}
		map2.put("UPDATOR_ID", user.getUserId());
		map2.put("MODIFI_DATE", new Date());
		map2.put("BSFLAG", "0");
		pureJdbcDao.saveOrUpdateEntity(map2,"BGP_HSE_FINANCIAL_DETAIL");
		
		
		if(hse_financial_id!=null&&!hse_financial_id.equals("")){
			String sql = "delete from bgp_hse_financial_type where hse_financial_id = '"+hse_financial_id+"'";
			jdbcTemplate.execute(sql);
		}
		
		for(int i=0;i<4;i++){
			String money = isrvmsg.getValue("money"+i);
			if(money==null||money.equals("")){
				money="0";
			}
			Map map3 = new HashMap();
			map3.put("MONEY", money);
			map3.put("ORDER_TYPE", i);
			map3.put("HSE_FINANCIAL_ID", hse_financial_id);
			pureJdbcDao.saveOrUpdateEntity(map3,"BGP_HSE_FINANCIAL_TYPE");
		}
		
		
		return responseDTO;
	}
	
	public ISrvMsg addFinancialCheck(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_financial_id = isrvmsg.getValue("hse_financial_id");
		String pass_flag = isrvmsg.getValue("pass_flag");
		String check_person = isrvmsg.getValue("check_person");
		String pass_date = isrvmsg.getValue("pass_date");
		String check_describe = isrvmsg.getValue("check_describe");
		
		
		Map map = new HashMap();
		map.put("HSE_FINANCIAL_ID", hse_financial_id);
		map.put("PASS_FLAG", pass_flag);
		map.put("CHECK_PERSON", check_person);
		map.put("PASS_DATE", pass_date);   
		map.put("CHECK_DESCRIBE", check_describe);
		
		if(hse_financial_id==null||hse_financial_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_FINANCIAL");
		hse_financial_id = id.toString();
		
		return responseDTO;
	}
	
	//查询
	public ISrvMsg queryFinancial(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_financial_id = isrvmsg.getValue("hse_financial_id");
		
		String sql = "select hf.*,fd.hse_detail_id,fd.plan_flag,fd.second_org second_org2,fd.third_org third_org2,fd.fourth_org fourth_org2,fd.project_name project_name2,fd.input_money,fd.gap_money,fd.duty_person,fd.complete_date,ft.*,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,oi4.org_abbreviation second_org_name2,oi5.org_abbreviation third_org_name2,oi6.org_abbreviation fourth_org_name2 from bgp_hse_financial hf left join bgp_hse_financial_detail fd on hf.hse_financial_id=fd.hse_financial_id and fd.bsflag='0' left join comm_org_subjection os1 on hf.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on hf.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on hf.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' left join comm_org_subjection os4 on fd.second_org=os4.org_subjection_id and os4.bsflag='0' left join comm_org_information oi4 on os4.org_id=oi4.org_id and oi4.bsflag='0' left join comm_org_subjection os5 on os5.org_subjection_id=fd.third_org and os5.bsflag='0' left join comm_org_information oi5 on os5.org_id=oi5.org_id and oi5.bsflag='0' left join comm_org_subjection os6 on fd.fourth_org=os6.org_subjection_id and os6.bsflag='0' left join comm_org_information oi6 on os6.org_id=oi6.org_id and oi6.bsflag='0' left join bgp_hse_financial_type ft on hf.hse_financial_id=ft.hse_financial_id where hf.bsflag='0' and hf.hse_financial_id='"+hse_financial_id+"' order by ft.order_type asc ";
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		responseDTO.setValue("list", list);
		return responseDTO;
	}
	
	//删除
	public ISrvMsg deleteFinancial(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_financial_ids = isrvmsg.getValue("hse_financial_id");
		String ids[] =  hse_financial_ids.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_hse_financial set bsflag = '1' where hse_financial_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	
	
	/*
	 * select level,t.* from bgp_op_cost_template  t
		start with parent_id = '01'
		connect by prior template_id = parent_id
	 * */
	//模板表中导入数据，每月的1号开始，创建新数据
	public ISrvMsg createEnvironmentManage(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
		String sql = "select t.org_sub_id, os.org_id,t.father_org_sub_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where t.father_org_sub_id in ( select org_sub_id from bgp_hse_org tt where tt.father_org_sub_id = 'C105') and t.environment_flag='1' order by t.order_num";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		for(int i=0;i<list.size();i++){
			Map mapOrg = (Map)list.get(i);
			String org_sub_id = (String)mapOrg.get("orgSubId");
			Map map = new HashMap();
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("STATUS", "0");
			map.put("TYPE","0");
			map.put("BSFLAG","0");
			map.put("CREATE_DATE", today);
			map.put("MODIFI_DATE", new Date());
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
			String hse_environment_id = id.toString();
			
			String sqlInsert = "insert into bgp_hse_environment_detail(hse_detail_id,project_name,unit,model_father_id,total_flag,order_num,hse_model_id,hse_environment_id) select sys_guid() hse_detail_id,project_name,unit,father_id model_father_id,total_flag,order_num,hse_model_id,'"+hse_environment_id+"' from bgp_hse_environment_model ";
			jdbcTemplate.execute(sqlInsert);
			
			String sqlUpdate = "update bgp_hse_environment_detail t  set t.father_id = (select hse_detail_id from bgp_hse_environment_detail d where d.hse_model_id = t.model_father_id  and d.hse_environment_id = '"+hse_environment_id+"') where t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_hse_environment_detail t set t.father_id = '101' where t.father_id is null and t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
		}
		
		String sql2 = "select t.org_sub_id, os.org_id,t.father_org_sub_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where  t.org_sub_id in ( select org_sub_id from bgp_hse_org tt where tt.father_org_sub_id = 'C105') and t.environment_flag='1' order by t.order_num";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		for(int i=0;i<list2.size();i++){
			Map mapOrg = (Map)list2.get(i);
			String org_sub_id = (String)mapOrg.get("orgSubId");
			Map map = new HashMap();
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("STATUS", "0");
			map.put("TYPE","1");
			map.put("BSFLAG","0");
			map.put("CREATE_DATE", today);
			map.put("MODIFI_DATE", new Date());
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
			String hse_environment_id = id.toString();
			
			String sqlInsert = "insert into bgp_hse_environment_detail(hse_detail_id,project_name,unit,model_father_id,total_flag,order_num,hse_model_id,hse_environment_id) select sys_guid() hse_detail_id,project_name,unit,father_id model_father_id,total_flag,order_num,hse_model_id,'"+hse_environment_id+"' from bgp_hse_environment_model ";
			jdbcTemplate.execute(sqlInsert);
			
			String sqlUpdate = "update bgp_hse_environment_detail t  set t.father_id = (select hse_detail_id from bgp_hse_environment_detail d where d.hse_model_id = t.model_father_id  and d.hse_environment_id = '"+hse_environment_id+"') where t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_hse_environment_detail t set t.father_id = '101' where t.father_id is null and t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
		}
		
		String sql3 = "select t.org_sub_id, os.org_id,t.father_org_sub_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where t.org_sub_id = 'C105' order by t.order_num";
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		for(int i=0;i<list3.size();i++){
			Map mapOrg = (Map)list3.get(i);
			String org_sub_id = (String)mapOrg.get("orgSubId");
			Map map = new HashMap();
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("STATUS", "0");
			map.put("TYPE","2");
			map.put("BSFLAG","0");
			map.put("CREATE_DATE", today);
			map.put("MODIFI_DATE", new Date());
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
			String hse_environment_id = id.toString();
			
			String sqlInsert = "insert into bgp_hse_environment_detail(hse_detail_id,project_name,unit,model_father_id,total_flag,order_num,hse_model_id,hse_environment_id) select sys_guid() hse_detail_id,project_name,unit,father_id model_father_id,total_flag,order_num,hse_model_id,'"+hse_environment_id+"' from bgp_hse_environment_model ";
			jdbcTemplate.execute(sqlInsert);
			
			String sqlUpdate = "update bgp_hse_environment_detail t  set t.father_id = (select hse_detail_id from bgp_hse_environment_detail d where d.hse_model_id = t.model_father_id  and d.hse_environment_id = '"+hse_environment_id+"') where t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_hse_environment_detail t set t.father_id = '101' where t.father_id is null and t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
		}
		
		return responseDTO;
	}
	
	//双击一条记录，进入修改页面
	public ISrvMsg IntoAddJsp(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_environment_id = isrvmsg.getValue("hse_environment_id");
		
		responseDTO.setValue("hse_environment_id", hse_environment_id);
		return responseDTO;
	}
	
	//用户开始填写数据
	public ISrvMsg addEnvironmentManage(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		UserToken user = isrvmsg.getUserToken();
		
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
		String hse_environment_id = isrvmsg.getValue("hse_environment_id");
		
			Map map = new HashMap();
			map.put("HSE_ENVIRONMENT_ID", hse_environment_id);
			map.put("MODIFI_DATE", new Date());
			map.put("STATUS", "1");
			if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
				map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			}
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
			hse_environment_id = id.toString();
			
		String ids = isrvmsg.getValue("ids");
		if(ids!=null){
			String[] orders = ids.split(",");
			for(int i=0;i<orders.length;i++){
			String hse_detail_id = isrvmsg.getValue("hse_detail_id"+orders[i]) == null ? "" : isrvmsg.getValue("hse_detail_id"+orders[i]);
			String month_data = isrvmsg.getValue("month_data"+orders[i]) == null ? "" : isrvmsg.getValue("month_data"+orders[i]);
			
//			Map map22 = new HashMap();
//			map22.put("HSE_DETAIL_ID", hse_detail_id);
//			map22.put("MONTH_DATA",month_data);
//			pureJdbcDao.saveOrUpdateEntity(map22,"BGP_HSE_ENVIRONMENT_DETAIL");
			String updateSql = "update bgp_hse_environment_detail set month_data = '"+month_data+"' where hse_detail_id = '"+hse_detail_id+"' ";
			jdbcTemplate.execute(updateSql);	
			}
		}
		//根据father_id 算出子节点相加之和
		String sqlTotal = "update bgp_hse_environment_detail t set t.month_data = (select sum(d.month_data) from bgp_hse_environment_detail d where d.father_id=t.hse_detail_id) where t.hse_environment_id='"+hse_environment_id+"' and t.total_flag='1'";
		jdbcTemplate.execute(sqlTotal);	
		
		/*		代码33：二氧化硫=野外施工燃料煤二氧化硫产生量+野外作业柴油机用柴油二氧化硫产生量
				野外施工燃料煤二氧化硫产生量（吨）=1.6×野外施工燃料煤×野外施工燃料煤平均含硫量
				野外作业柴油机用柴油二氧化硫产生量（吨）=野外作业柴油机用柴油×18/0.849/1000
				代码34：氮氧化物=野外施工燃料煤氮氧化物产生量+野外作业柴油机用柴油氮氧化物产生量
				野外施工燃料煤氮氧化物产生量（吨）=1.63×野外施工燃料煤×(0.25×0.015＋0.000938）
				野外作业柴油机用柴油氮氧化物产生量（吨）=野外作业柴油机用柴油×60/0.849/1000
		*/
		
		//二氧化硫
		String sqlSO2 = "update bgp_hse_environment_detail t set t.month_data = ((1.6*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001001001' and d.hse_environment_id='"+hse_environment_id+"'),0)*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001002001' and d.hse_environment_id='"+hse_environment_id+"'),0)/100) + (nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001003002' and d.hse_environment_id='"+hse_environment_id+"'),0)*18/0.849/1000)) where t.hse_model_id='101003001' and t.hse_environment_id = '"+hse_environment_id+"'";
		jdbcTemplate.execute(sqlSO2);	
		//氮氧化物
		String sqlNO = "update bgp_hse_environment_detail t set t.month_data = (1.63*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001001001' and d.hse_environment_id='"+hse_environment_id+"'),0)*(0.25*0.015+0.000938)) + (nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001003002' and d.hse_environment_id='"+hse_environment_id+"'),0)*60/0.849/1000) where t.hse_model_id='101003002' and t.hse_environment_id = '"+hse_environment_id+"'";
		jdbcTemplate.execute(sqlNO);	
		
		
		
		//算出全年累计
		String sqlYear = "update bgp_hse_environment_detail t set t.year_data = (select sum(ed.month_data) from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"') and to_char(en.create_date,'yyyy')=to_char(sysdate,'yyyy') and t.hse_model_id=ed.hse_model_id) where t.hse_environment_id = '"+hse_environment_id+"'";
		jdbcTemplate.execute(sqlYear);
		
		//累计同比增减量
		String sqlIncrease = "update bgp_hse_environment_detail t set t.increase_data = (t.month_data - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"'),-12)  and t.hse_model_id=ed.hse_model_id),0)) where t.hse_environment_id = '"+hse_environment_id+"'";
		jdbcTemplate.execute(sqlIncrease);
		
		//累计同比±%
//		String sqlPercent = "update bgp_hse_environment_detail t set t.increase_percent = (((t.month_data - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"'),-12)  and t.hse_model_id=ed.hse_model_id),0))/nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"'),-12)  and t.hse_model_id=ed.hse_model_id),t.month_data))*100) where t.hse_environment_id = '"+hse_environment_id+"'";
		String  sqlPercent = "update bgp_hse_environment_detail dd set dd.increase_percent = (select case when asd=0 then 100 else qwe/asd*100 end asd from (select (nvl(t.month_data,0) - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id where en.bsflag = '0' and en.org_sub_id = (select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"'), -12) and t.hse_model_id = ed.hse_model_id), 0)) qwe , nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id where en.bsflag = '0' and en.org_sub_id = (select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id+"'), -12) and t.hse_model_id = ed.hse_model_id), nvl(t.month_data,0)) asd,t.hse_model_id,t.hse_environment_id from bgp_hse_environment_detail t where t.hse_environment_id = '"+hse_environment_id+"') cc where dd.hse_model_id=cc.hse_model_id) where dd.hse_environment_id='"+hse_environment_id+"'";
		jdbcTemplate.execute(sqlPercent);
		
		//判断是否机关，机关不用提交就可以汇总，如果是机关，则汇总
		String sqlOrgFlag = "select en.hse_environment_id,ho.organ_flag from bgp_hse_environment en join bgp_hse_org ho on en.org_sub_id=ho.org_sub_id where en.bsflag='0' and en.hse_environment_id = '"+hse_environment_id+"'";
		Map mapOrgFlag = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlOrgFlag);
		String organ_flag = (String)mapOrgFlag.get("organFlag");
		if(organ_flag!=null&&organ_flag.equals("0")){    
			hseUtil.totalEnvironment(hse_environment_id); 
		}
		
		System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		responseDTO.setValue("hse_environment_id", hse_environment_id);
		return responseDTO;
	}
	
	//提交成功的时候，添加提交人和提交时间
	public ISrvMsg submitMethod(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_environment_id = isrvmsg.getValue("hse_environment_id");
		Map map = new HashMap();
		map.put("HSE_ENVIRONMENT_ID", hse_environment_id);
		map.put("SUBMIT_PERSON", user.getUserName());
		map.put("SUBMIT_DATE", new Date());
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
		return responseDTO;
	}
	
	//审批通过
	public ISrvMsg passMethod(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_environment_id = isrvmsg.getValue("hse_environment_id");
		String sql = "update bgp_hse_environment set status='3' where  bsflag='0' and hse_environment_id='"+hse_environment_id+"'";
		jdbcTemplate.execute(sql);
		//审批人和审批时间
		Map mapInfo = new HashMap();
		mapInfo.put("HSE_ENVIRONMENT_ID", hse_environment_id);
		mapInfo.put("APPROVE_PERSON", user.getUserName());
		mapInfo.put("APPROVE_DATE", new Date());
		Serializable id = pureJdbcDao.saveOrUpdateEntity(mapInfo,"BGP_HSE_ENVIRONMENT");
		
		String qqq = "select t.father_org_sub_id,en.create_date,en.hse_environment_id from bgp_hse_org t join bgp_hse_environment en on t.org_sub_id=en.org_sub_id and en.bsflag='0' where en.hse_environment_id='"+hse_environment_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(qqq);
		String org_sub_id = (String)map.get("fatherOrgSubId");
		String create_date = (String)map.get("createDate");
		
		if(!org_sub_id.equals("C1")){
		
		String sql1 = "select * from bgp_hse_environment where bsflag='0' and org_sub_id='"+org_sub_id+"' and create_date=to_date('"+create_date+"','yyyy-MM-dd')";
		Map mapId = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql1);
		String hse_environment_id2 = (String)mapId.get("hseEnvironmentId");
		
		
		Map map123 = new HashMap();
		map123.put("HSE_ENVIRONMENT_ID", hse_environment_id2);
		map123.put("MODIFI_DATE", new Date());
		map123.put("STATUS", "1");
		pureJdbcDao.saveOrUpdateEntity(map123,"BGP_HSE_ENVIRONMENT");
		
		
		String sqlTotal = "update bgp_hse_environment_detail t set t.month_data =  (select sum(month_data) from bgp_hse_org ho join bgp_hse_environment en on ho.org_sub_id = en.org_sub_id and en.bsflag = '0' join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id  where (ho.father_org_sub_id='"+org_sub_id+"' and ho.environment_flag='1' and en.create_date=to_date('"+create_date+"','yyyy-MM-dd') and en.status='3' or (ho.organ_flag = '0' and en.status not in ('0', '4') and ho.father_org_sub_id = '"+org_sub_id+"' and en.create_date = to_date('"+create_date+"', 'yyyy-MM-dd')  and ho.environment_flag = '1')) and ed.hse_model_id= t.hse_model_id) where t.hse_environment_id = (select hse_environment_id from bgp_hse_environment where org_sub_id='"+org_sub_id+"' and create_date=to_date('"+create_date+"','yyyy-MM-dd'))";
		jdbcTemplate.execute(sqlTotal);
		
		//根据father_id 查询出下属基层单位包含的     每个基层单位查出6条数据，进行运算《燃料煤平均含硫量=Σ（各下级单位平均含硫量*燃料煤量本月）/Σ（各下级单位燃料煤量本月）》 
		String sqlS = "select * from bgp_hse_org ho join bgp_hse_environment en on ho.org_sub_id = en.org_sub_id and en.bsflag = '0' join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where ho.father_org_sub_id = '"+org_sub_id+"'  and ho.environment_flag='1' and en.create_date = to_date('"+create_date+"', 'yyyy-MM-dd') and ed.hse_model_id in ('101001001','101001001001','101001001002','101001002','101001002001','101001002002') and en.status='3' order by ed.hse_environment_id desc,ed.hse_model_id asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlS);
		
		double data_s1 = 0;
		double data_s2 = 0;
		double data_s3 = 0;
		double total_data1 = 0;
		double total_data2 = 0;
		double total_data3 = 0;
		
		
		for(int i=0;i<list.size();i+=6){
			Map map1 = (Map)list.get(i);
			Map map2 = (Map)list.get(i+1);
			Map map3 = (Map)list.get(i+2);
			Map map4 = (Map)list.get(i+3);
			Map map5 = (Map)list.get(i+4);
			Map map6 = (Map)list.get(i+5);
			
		/*	1.燃料煤
				其中:野外施工燃料煤
		                                  其他
			2.燃料煤平均含硫量
		                     其中:野外施工燃料煤平均含硫量
		                                 其他
		     month_data1~6 分别对应上面六项 
			*/
			double data1 = 0;
			double data2 = 0;
			double data3 = 0;
			double data4 = 0;
			double data5 = 0;
			double data6 = 0;
			String month_data1 = (String)map1.get("monthData");    
			if(month_data1==null){
				System.out.println("**************************************");
				System.out.println("null");
				System.out.println("**************************************");
			}else if(month_data1.equals("")){
				System.out.println("**************************************");
				System.out.println("空字符串");
				System.out.println("**************************************");
			}else{
				data1 = Double.parseDouble(month_data1);
			}
				
			String month_data2 = (String)map2.get("monthData");
			if(month_data2!=null&&!month_data2.equals("")){
				data2 = Double.parseDouble(month_data2);
			}
			String month_data3 = (String)map3.get("monthData");
			if(month_data3!=null&&!month_data3.equals("")){
				data3 = Double.parseDouble(month_data3);
			}
			String month_data4 = (String)map4.get("monthData");
			if(month_data4!=null&&!month_data4.equals("")){
				data4 = Double.parseDouble(month_data4);
			}
			String month_data5 = (String)map5.get("monthData");
			if(month_data5!=null&&!month_data5.equals("")){
				data5 = Double.parseDouble(month_data5);
			}
			String month_data6 = (String)map6.get("monthData");
			if(month_data6!=null&&!month_data6.equals("")){
				data6 = Double.parseDouble(month_data6);
			}
			
			data_s1 +=data1*data4; 
			data_s2 +=data2*data5; 
			data_s3 +=data3*data6; 
		
			total_data1 += data1;
			total_data2 += data2;
			total_data3 += data3;
		}
		
		if(total_data1==0){
			String sss = "update bgp_hse_environment_detail set month_data = '' where hse_model_id='101001002' and hse_environment_id='"+hse_environment_id2+"'";
			jdbcTemplate.execute(sss);	
		}else{
			double percent_s1 = data_s1/total_data1;
			String sss = "update bgp_hse_environment_detail set month_data = '"+percent_s1+"' where hse_model_id='101001002' and hse_environment_id='"+hse_environment_id2+"'";
			jdbcTemplate.execute(sss);	
		}
		
		if(total_data2==0){
			String sss = "update bgp_hse_environment_detail set month_data = '' where hse_model_id='101001002001' and hse_environment_id='"+hse_environment_id2+"'";
			jdbcTemplate.execute(sss);	
		}else{
			double percent_s2 = data_s2/total_data2;
			String sss = "update bgp_hse_environment_detail set month_data = '"+percent_s2+"' where hse_model_id='101001002001' and hse_environment_id='"+hse_environment_id2+"'";
			jdbcTemplate.execute(sss);	
		}
		
		if(total_data3==0){
			String sss = "update bgp_hse_environment_detail set month_data = '' where hse_model_id='101001002002' and hse_environment_id='"+hse_environment_id2+"'";
			jdbcTemplate.execute(sss);	
		}else{
			double percent_s3 = data_s3/total_data3;
			String sss = "update bgp_hse_environment_detail set month_data = '"+percent_s3+"' where hse_model_id='101001002002' and hse_environment_id='"+hse_environment_id2+"'";
			jdbcTemplate.execute(sss);	
		}
		
		/*		代码33：二氧化硫=野外施工燃料煤二氧化硫产生量+野外作业柴油机用柴油二氧化硫产生量
				野外施工燃料煤二氧化硫产生量（吨）=1.6×野外施工燃料煤×野外施工燃料煤平均含硫量
				野外作业柴油机用柴油二氧化硫产生量（吨）=野外作业柴油机用柴油×18/0.849/1000
				代码34：氮氧化物=野外施工燃料煤氮氧化物产生量+野外作业柴油机用柴油氮氧化物产生量
				野外施工燃料煤氮氧化物产生量（吨）=1.63×野外施工燃料煤×(0.25×0.015＋0.000938）
				野外作业柴油机用柴油氮氧化物产生量（吨）=野外作业柴油机用柴油×60/0.849/1000
		 */

		//二氧化硫
		String sqlSO2 = "update bgp_hse_environment_detail t set t.month_data = ((1.6*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001001001' and d.hse_environment_id='"+hse_environment_id2+"'),0)*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001002001' and d.hse_environment_id='"+hse_environment_id2+"'),0)/100) + (nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001003002' and d.hse_environment_id='"+hse_environment_id2+"'),0)*18/0.849/1000)) where t.hse_model_id='101003001' and t.hse_environment_id = '"+hse_environment_id2+"'";
		jdbcTemplate.execute(sqlSO2);	
		//氮氧化物
		String sqlNO = "update bgp_hse_environment_detail t set t.month_data = (1.63*nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001001001' and d.hse_environment_id='"+hse_environment_id2+"'),0)*(0.25*0.015+0.000938)) + (nvl((select d.month_data from bgp_hse_environment_detail d where d.hse_model_id='101001003002' and d.hse_environment_id='"+hse_environment_id2+"'),0)*60/0.849/1000) where t.hse_model_id='101003002' and t.hse_environment_id = '"+hse_environment_id2+"'";
		jdbcTemplate.execute(sqlNO);	
		
		
		
		//算出全年累计
		String sqlYear = "update bgp_hse_environment_detail t set t.year_data = (select sum(ed.month_data) from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and to_char(en.create_date,'yyyy')=to_char(sysdate,'yyyy') and t.hse_model_id=ed.hse_model_id) where t.hse_environment_id = '"+hse_environment_id2+"'";
		jdbcTemplate.execute(sqlYear);
		
		//累计同比增减量
		String sqlIncrease = "update bgp_hse_environment_detail t set t.increase_data = (t.month_data - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'),-12)  and t.hse_model_id=ed.hse_model_id),0)) where t.hse_environment_id = '"+hse_environment_id2+"'";
		jdbcTemplate.execute(sqlIncrease);
		
		//累计同比±%
		String  sqlPercent = "update bgp_hse_environment_detail dd set dd.increase_percent = (select case when asd=0 then 100 else qwe/asd*100 end asd from (select (nvl(t.month_data,0) - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id where en.bsflag = '0' and en.org_sub_id = (select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'), -12) and t.hse_model_id = ed.hse_model_id), 0)) qwe , nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id = ed.hse_environment_id where en.bsflag = '0' and en.org_sub_id = (select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'), -12) and t.hse_model_id = ed.hse_model_id), nvl(t.month_data,0)) asd,t.hse_model_id,t.hse_environment_id from bgp_hse_environment_detail t where t.hse_environment_id = '"+hse_environment_id2+"') cc where dd.hse_model_id=cc.hse_model_id) where dd.hse_environment_id='"+hse_environment_id2+"'";
//		String sqlPercent = "update bgp_hse_environment_detail t set t.increase_percent = (((t.month_data - nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'),-12)  and t.hse_model_id=ed.hse_model_id),0))/nvl((select month_data from bgp_hse_environment en join bgp_hse_environment_detail ed on en.hse_environment_id=ed.hse_environment_id where en.bsflag='0' and en.org_sub_id=(select org_sub_id from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"') and en.create_date = add_months((select create_date from bgp_hse_environment where hse_environment_id = '"+hse_environment_id2+"'),-12)  and t.hse_model_id=ed.hse_model_id),t.month_data))*100) where t.hse_environment_id = '"+hse_environment_id2+"'";
		jdbcTemplate.execute(sqlPercent);
		
		}
		
		
		return responseDTO;
	}
	
	//审批不通过
	public ISrvMsg noPassMethod(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String hse_environment_id = isrvmsg.getValue("hse_environment_id");
		String sql = "update bgp_hse_environment set status='4' where  bsflag='0' and hse_environment_id='"+hse_environment_id+"'";
		jdbcTemplate.execute(sql);
		
		Map mapInfo = new HashMap();
		mapInfo.put("HSE_ENVIRONMENT_ID", hse_environment_id);
		mapInfo.put("APPROVE_PERSON", user.getUserName());
		mapInfo.put("APPROVE_DATE", new Date());
		Serializable id = pureJdbcDao.saveOrUpdateEntity(mapInfo,"BGP_HSE_ENVIRONMENT");
		return responseDTO;
	}
	
	//设置哪些单位需要填写环境管理
	public ISrvMsg setEnvironmentOrg(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String rootMenuId = isrvmsg.getValue("rootMenuId");
		String ids = isrvmsg.getValue("ids");
		
		String sqlDelete = "update bgp_hse_org set environment_flag='' where org_sub_id like '"+rootMenuId+"%'";
		jdbcTemplate.execute(sqlDelete);
		
		String[] org_sub_ids = ids.split(",");
		for(int i=0;i<org_sub_ids.length;i++){
			String sql = "update bgp_hse_org set environment_flag='1' where org_sub_id='"+org_sub_ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		String sql2 = "update bgp_hse_org set environment_flag='1' where org_sub_id='"+rootMenuId+"'";
		jdbcTemplate.execute(sql2);

		return responseDTO;
	}
	
	//环境管理  公司或者二级单位汇总提交（机关的填写和其他单位的审核通过之后再汇总） 
	public ISrvMsg submitTotalEnvironment(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String hse_environment_id = isrvmsg.getValue("hse_environment_id");

		String sql = "select * from bgp_hse_environment t where t.hse_environment_id = '"+hse_environment_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		String org_sub_id = (String)map.get("orgSubId");
		String create_date = (String)map.get("createDate");
		
		
		String sqlOrgs = "select en.hse_environment_id,en.status,ho.organ_flag from bgp_hse_environment en join bgp_hse_org ho on ho.org_sub_id=en.org_sub_id where en.bsflag = '0' and ho.environment_flag='1' and ho.father_org_sub_id = '"+org_sub_id+"'  and en.create_date=to_date('"+create_date+"','yyyy-MM-dd')";
		List list  = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOrgs);
		
		boolean flag = false;
		for(int i=0;i<list.size();i++){
			Map mapOrg = (Map)list.get(i);
			String status = (String)mapOrg.get("status");
			String organ_flag = (String)mapOrg.get("organFlag");
			if(organ_flag.equals("0")){              //机关填写的环境月报是要是不是未填写和审批不通过，上级单位就可以汇总提交
				if(status.equals("0")||status.equals("4")){
					flag = true;
					break;
				}
			}else{
				if(!status.equals("3")){           //其他的单位填写的环境月报状态必须是审批通过，上级单位才可以汇总提交
					flag = true;
					break;
				}
			}
		}
		
		responseDTO.setValue("flag", flag);
		return responseDTO;
	}
	
	//设置环境信息集团指标
	public ISrvMsg setTarget(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
			String hse_environment_id = isrvmsg.getValue("hse_environment_id");
			String target = isrvmsg.getValue("target");
			
			Map map = new HashMap();
			map.put("HSE_ENVIRONMENT_ID", hse_environment_id);
			map.put("BSFLAG", "0");
			if(hse_environment_id==null||hse_environment_id.equals("")){
				map.put("CREATE_DATE", new Date());
				map.put("CREATOR_ID", user.getUserId());
			}
			map.put("TARGET", target);
			map.put("MODIFI_DATE", new Date());
			map.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT_TARGET");

			return responseDTO;
	}
	
	//环境信息单位添加
	public ISrvMsg addEnvironmentInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
		String ids = isrvmsg.getValue("ids");
		String[] order = ids.split(",");
		for(int i=0;i<order.length;i++){
			String hse_info_id = isrvmsg.getValue("hse_info_id"+order[i]);
			String org_sub_id = isrvmsg.getValue("org_sub_id"+order[i]);
			String life_number = isrvmsg.getValue("life_number"+order[i]);
			String industry_number = isrvmsg.getValue("industry_number"+order[i]);
			String industry_cod = isrvmsg.getValue("industry_cod"+order[i]);
			String water_number = isrvmsg.getValue("water_number"+order[i]);
			String boiler_number = isrvmsg.getValue("boiler_number"+order[i]);
			String boiler_coal = isrvmsg.getValue("boiler_coal"+order[i]);
			String boiler_gas = isrvmsg.getValue("boiler_gas"+order[i]);
			String boiler_condition = isrvmsg.getValue("boiler_condition"+order[i]);
			
			Map map = new HashMap();
			map.put("HSE_INFO_ID", hse_info_id);
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("LIFE_NUMBER", life_number);
			map.put("INDUSTRY_NUMBER", industry_number);
			map.put("INDUSTRY_COD", industry_cod);
			map.put("WATER_NUMBER", water_number);
			map.put("BOILER_NUMBER", boiler_number);
			map.put("BOILER_COAL", boiler_coal);
			map.put("BOILER_GAS", boiler_gas);
			map.put("BOILER_CONDITION", boiler_condition);
			pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT_INFO");
		}
		
		String father_id = isrvmsg.getValue("father_id");
		String father_info_id = isrvmsg.getValue("father_info_id");
		String totalLife = isrvmsg.getValue("totalLife");
		String totalIndustry = isrvmsg.getValue("totalIndustry");
		String totalCOD = isrvmsg.getValue("totalCOD");
		String totalWater = isrvmsg.getValue("totalWater");
		String totalBoiler = isrvmsg.getValue("totalBoiler");
		String totalCoal = isrvmsg.getValue("totalCoal");
		String totalGas = isrvmsg.getValue("totalGas");
		
		Map map1 = new HashMap();
		map1.put("HSE_INFO_ID", father_info_id);
		map1.put("ORG_SUB_ID", father_id);
		map1.put("LIFE_NUMBER", totalLife);
		map1.put("INDUSTRY_NUMBER", totalIndustry);
		map1.put("INDUSTRY_COD", totalCOD);
		map1.put("WATER_NUMBER", totalWater);
		map1.put("BOILER_NUMBER", totalBoiler);
		map1.put("BOILER_COAL", totalCoal);
		map1.put("BOILER_GAS", totalGas);
		pureJdbcDao.saveOrUpdateEntity(map1,"BGP_HSE_ENVIRONMENT_INFO");
		
		
		
		return responseDTO;
	}
	
	
	//职业健康状况设置集团指标
	public ISrvMsg setHealthTarget(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
			String hse_target_id = isrvmsg.getValue("hse_target_id");
			String health_target = isrvmsg.getValue("health_target");
			String places_target = isrvmsg.getValue("places_target");
			
			Map map = new HashMap();
			map.put("HSE_TARGET_ID", hse_target_id);
			map.put("BSFLAG", "0");
			if(hse_target_id==null||hse_target_id.equals("")){
				map.put("CREATE_DATE", new Date());
				map.put("CREATOR_ID", user.getUserId());
			}
			map.put("HEALTH_TARGET", health_target);
			map.put("PLACES_TARGET", places_target);
			map.put("MODIFI_DATE", new Date());
			map.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_HEALTH_TARGET");

			return responseDTO;
	}
	
	// 职业健康状况  添加
	public ISrvMsg saveProfessionalHealth(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
		String ids = isrvmsg.getValue("ids");
		String[] order = ids.split(",");
		for(int i=0;i<order.length;i++){
			String hse_professional_id = isrvmsg.getValue("hse_professional_id"+order[i]);
			String org_sub_id = isrvmsg.getValue("org_sub_id"+order[i]);
			String percent_health = isrvmsg.getValue("percent_health"+order[i]);
			String total_num = isrvmsg.getValue("total_num"+order[i]);
			String places = isrvmsg.getValue("places"+order[i]);
			String people_num = isrvmsg.getValue("people_num"+order[i]);
			String percent_places = isrvmsg.getValue("percent_places"+order[i]);
			
			Map map = new HashMap();
			map.put("HSE_PROFESSIONAL_ID", hse_professional_id);
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("PERCENT_HEALTH", percent_health);
			map.put("TOTAL_NUM", total_num);
			map.put("PLACES", places);
			map.put("PEOPLE_NUM", people_num);
			map.put("PERCENT_PLACES", percent_places);
			map.put("BSFLAG", "0");
			if(hse_professional_id==null||hse_professional_id.equals("")){
				map.put("CREATE_DATE", new Date());
				map.put("CREATOR_ID", user.getUserId());
			}
			map.put("MODIFI_DATE", new Date());
			map.put("UPDATOR_ID", user.getUserId());
			pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_PROFESSIONAL_HEALTH");
			
			
//			String asdfg = "update bgp_hse_professional_health set percent_places='"+percent_places+"' where hse_professional_id='"+hse_professional_id+"'";
//			jdbcTemplate.execute(asdfg);
			
		}
		
		return responseDTO;
	}
	
	
	//多项目上传文档
	public ISrvMsg saveMultipleDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		
		String creatorId = user.getUserId();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String parentFileId = reqDTO.getValue("parentFileId");
		String createDate = reqDTO.getValue("createDate");
		String fileName = reqDTO.getValue("doc_name");
		String ucmId = reqDTO.getValue("ucmId");
		String fileId = reqDTO.getValue("fileId");
		
		Map mapDetail = new HashMap();
		
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			mapDetail.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}
		mapDetail.put("creator_id", creatorId);
		mapDetail.put("parent_file_id", parentFileId);
		mapDetail.put("create_date", new Date());
		mapDetail.put("file_name", fileName);
		mapDetail.put("bsflag", "0");
		mapDetail.put("is_file", "1");
		mapDetail.put("org_id", user.getOrgId());
		mapDetail.put("org_subjection_id", user.getOrgSubjectionId());
		mapDetail.put("updator_id", creatorId);
		mapDetail.put("modifi_date", new Date());
		//主键存不为空修改，为空新增
		if(fileId!=null && !"".equals(fileId)){
			mapDetail.put("file_id", fileId);
		}
		
		MyUcm ucm = new MyUcm();
		byte[] fileBytes = null;
		String documentId = "";
		//获取文档的初始名字
		String uploadFileName = reqDTO.getValue("upload_file_name") != null?reqDTO.getValue("upload_file_name"):"";
		if(uploadFileName != ""){
			 //从服务器中获取文档
			fileBytes = MyUcm.getFileBytes(uploadFileName, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			//调用上传方法
			documentId = ucm.uploadFile(uploadFileName, fileBytes);
			mapDetail.put("ucm_id", documentId);
		}
		
/*		MyUcm ucm = new MyUcm();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String documentId = "";
		if(fileList!= null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
			mapDetail.put("ucm_id", documentId);
			
			if(ucmId!=null && !"".equals(ucmId)){
				ucm.deleteFile(ucmId);
			}
			
		}
		*/
		
		String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_doc_gms_file").toString();
		
		ucm.docVersion(doc_pk_id, "1.0", documentId, creatorId, creatorId, user.getOrgId(), user.getOrgSubjectionId(),fileName);
		ucm.docLog(doc_pk_id, "1.0", 1, creatorId, creatorId, creatorId, user.getOrgId(), user.getOrgSubjectionId(),fileName);
		
		responseDTO.setValue("parentFileId", parentFileId);			
		return responseDTO;
	}
	
	//单项目上传文档
	public ISrvMsg saveSingleDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		
		String creatorId = user.getUserId();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String fileAbbr = reqDTO.getValue("fileAbbr");
		String createDate = reqDTO.getValue("createDate");
		String fileName = reqDTO.getValue("doc_name");
		String ucmId = reqDTO.getValue("ucmId");
		String fileId = reqDTO.getValue("fileId");
		
		String parent_file_id = "";
		String sql = "select * from bgp_doc_gms_file f where f.bsflag='0' and is_file='0' and f.project_info_no='"+projectInfoNo+"' and f.file_abbr='"+fileAbbr+"'";
		Map map  = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null){
			parent_file_id = (String)map.get("fileId");
		}
		
		Map mapDetail = new HashMap();
		
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			mapDetail.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}
		mapDetail.put("creator_id", creatorId);
		mapDetail.put("create_date", new Date());
		mapDetail.put("file_name", fileName);
		mapDetail.put("parent_file_id", parent_file_id);
		mapDetail.put("bsflag", "0");
		mapDetail.put("is_file", "1");
		mapDetail.put("org_id", user.getOrgId());
		mapDetail.put("org_subjection_id", user.getOrgSubjectionId());
		mapDetail.put("updator_id", creatorId);
		mapDetail.put("modifi_date", new Date());
		//主键存不为空修改，为空新增
		if(fileId!=null && !"".equals(fileId)){
			mapDetail.put("file_id", fileId);
		}
	
		MyUcm ucm = new MyUcm();
		byte[] fileBytes = null;
		String documentId = "";
		//获取文档的初始名字
		String uploadFileName = reqDTO.getValue("upload_file_name") != null?reqDTO.getValue("upload_file_name"):"";
		if(uploadFileName != ""){
			 //从服务器中获取文档
			fileBytes = MyUcm.getFileBytes(uploadFileName, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			//调用上传方法
			documentId = ucm.uploadFile(uploadFileName, fileBytes);
			mapDetail.put("ucm_id", documentId);
		}
		
/*		MyUcm ucm = new MyUcm();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String documentId = "";
		if(fileList!= null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
			mapDetail.put("ucm_id", documentId);
			
			if(ucmId!=null && !"".equals(ucmId)){
				ucm.deleteFile(ucmId);
			}
			
		}
		*/
		
		String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_doc_gms_file").toString();
		ucm.docVersion(doc_pk_id, "1.0", documentId, creatorId, creatorId, user.getOrgId(), user.getOrgSubjectionId(),fileName);
		ucm.docLog(doc_pk_id, "1.0", 1, creatorId, creatorId, creatorId, user.getOrgId(), user.getOrgSubjectionId(),fileName);
		
		responseDTO.setValue("fileAbbr", fileAbbr);			
		return responseDTO;
	}
	
	//上传文档(hse公共) 某条记录的附件
	public ISrvMsg saveHseCommonDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		
		String creatorId = user.getUserId();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String createDate = reqDTO.getValue("createDate");
		String fileName = reqDTO.getValue("doc_name");
		String ucmId = reqDTO.getValue("ucmId");
		String fileId = reqDTO.getValue("fileId");
		String relation_id = reqDTO.getValue("relation_id");
		
		
		Map mapDetail = new HashMap();
		
		if(user.getProjectInfoNo()!=null&&!user.getProjectInfoNo().equals("")){
			mapDetail.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		}
		mapDetail.put("creator_id", creatorId);
		if(relation_id!=null&&!relation_id.equals("")){
			mapDetail.put("RELATION_ID", relation_id);
		}
		mapDetail.put("create_date", createDate);
		mapDetail.put("file_name", fileName);
		mapDetail.put("bsflag", "0");
		mapDetail.put("is_file", "1");
		mapDetail.put("org_id", user.getOrgId());
		mapDetail.put("org_subjection_id", user.getOrgSubjectionId());
		mapDetail.put("updator_id", creatorId);
		mapDetail.put("modifi_date", new Date());
		//主键存不为空修改，为空新增
		if(fileId!=null && !"".equals(fileId)){
			mapDetail.put("file_id", fileId);
		}
		
		
		MyUcm ucm = new MyUcm();
		byte[] fileBytes = null;
		String documentId = "";
		//获取文档的初始名字
		String uploadFileName = reqDTO.getValue("upload_file_name") != null?reqDTO.getValue("upload_file_name"):"";
		if(uploadFileName != ""){
			 //从服务器中获取文档
			fileBytes = MyUcm.getFileBytes(uploadFileName, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			//调用上传方法
			documentId = ucm.uploadFile(uploadFileName, fileBytes);
			mapDetail.put("ucm_id", documentId);
		}
		
/*		MyUcm ucm = new MyUcm();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String documentId = "";
		if(fileList!= null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
			mapDetail.put("ucm_id", documentId);
			
			if(ucmId!=null && !"".equals(ucmId)){
				ucm.deleteFile(ucmId);
			}
			
		}
		*/
		
		String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_doc_gms_file").toString();
		ucm.docVersion(doc_pk_id, "1.0", documentId, creatorId, creatorId, user.getOrgId(), user.getOrgSubjectionId(),fileName);
		ucm.docLog(doc_pk_id, "1.0", 1, creatorId, creatorId, creatorId, user.getOrgId(), user.getOrgSubjectionId(),fileName);
		
		return responseDTO;
	}
	
	
	//获取上传文件名字
	public ISrvMsg getFileName(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String ucmId = isrvmsg.getValue("ucmId");
		MyUcm ucm = new MyUcm();
		String fileName = ucm.getDocTitle(ucmId);
		
		responseDTO.setValue("fileName",fileName);
		
		return responseDTO;
	}
	
	//删除文档
	public ISrvMsg deleteDoc(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String file_id = isrvmsg.getValue("file_id");
		String ids[] =  file_id.split(",");
		for(int i=0;i<ids.length;i++){
			String sql = "update bgp_doc_gms_file set bsflag='1' where file_id='"+ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		return responseDTO;
	}
	
	
	
	//HSE培训  ---多项目
	public ISrvMsg addHseTraining(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_plan_id = isrvmsg.getValue("hse_plan_id");
		String hse_detail_id = isrvmsg.getValue("hse_detail_id");
		String second_org = isrvmsg.getValue("second_org");
		String third_org = isrvmsg.getValue("third_org");
		String train_object = isrvmsg.getValue("train_object");
		String train_address = isrvmsg.getValue("train_address");
		String project_name = isrvmsg.getValue("project_name");
		String train_time = isrvmsg.getValue("train_time");
		String train_purpose = isrvmsg.getValue("train_purpose");
		String train_content = isrvmsg.getValue("train_content");
		String lead_type = isrvmsg.getValue("lead_type"); //是否领导宣贯
		
		String train_num = isrvmsg.getValue("train_num");
		String train_class = isrvmsg.getValue("train_class");
		String train_cost = isrvmsg.getValue("train_cost");
		String train_transport = isrvmsg.getValue("train_transport");
		String train_material = isrvmsg.getValue("train_material");
		String train_places = isrvmsg.getValue("train_places");
		String train_accommodation = isrvmsg.getValue("train_accommodation");
		String train_other = isrvmsg.getValue("train_other");
		String train_total = isrvmsg.getValue("train_total");
		
		Map map = new HashMap();
		map.put("HSE_PLAN_ID", hse_plan_id);
		map.put("SECOND_ORG", second_org);
		map.put("THIRD_ORG", third_org);
		map.put("TRAIN_OBJECT", train_object);
		map.put("TRAIN_ADDRESS", train_address);
		map.put("TRAIN_PURPOSE", train_purpose);
		map.put("TRAIN_TIME", train_time);
		map.put("PROJECT_NAME", project_name);
		map.put("TRAIN_CONTENT", train_content);
		map.put("BSFLAG", "0");
		if(hse_plan_id==null||hse_plan_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("MODIFI_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("LEAD_TYPE", lead_type);
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_TRAIN_PLAN");
		hse_plan_id = id.toString();
		
		Map map1 = new HashMap();
		map1.put("HSE_DETAIL_ID", hse_detail_id);
		map1.put("TRAIN_NUM", train_num);
		map1.put("TRAIN_CLASS", train_class);
		map1.put("TRAIN_COST", train_cost);
		map1.put("TRAIN_TRANSPORT", train_transport);
		map1.put("TRAIN_MATERIAL", train_material);
		map1.put("TRAIN_PLACES", train_places);
		map1.put("TRAIN_ACCOMMODATION", train_accommodation);
		map1.put("TRAIN_OTHER", train_other);
		map1.put("TRAIN_TOTAL", train_total);
		map1.put("HSE_PLAN_ID", hse_plan_id);
		pureJdbcDao.saveOrUpdateEntity(map1,"BGP_HSE_TRAIN_DETAIL");
		
		return responseDTO;
	}
	
	
	public ISrvMsg addHseTrainingRecord(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_plan_id = isrvmsg.getValue("hse_plan_id");
		
		String temp = isrvmsg.getValue("temp");
		
		if(temp!=null&&!temp.equals("")){
			
			String sql = "delete from BGP_HSE_TRAIN_RECORD where hse_plan_id = '"+hse_plan_id+"'";
			jdbcTemplate.execute(sql);
			
			String[] orders = temp.split(","); 
			for(int i=0;i<orders.length;i++){
				String order = orders[i];
				String employee_id = isrvmsg.getValue("employee_id"+order);
				String train_date = isrvmsg.getValue("train_date"+order);
				String employee_type = isrvmsg.getValue("employee_type"+order);
				String train_result = isrvmsg.getValue("train_result"+order);
				String notes = isrvmsg.getValue("notes"+order);
				
				Map map = new HashMap();
				map.put("TRAIN_DATE", train_date);
				map.put("EMPLOYEE_TYPE", employee_type);
				map.put("TRAIN_RESULT", train_result);
				map.put("NOTES", notes);
				map.put("EMPLOYEE_ID", employee_id);
				map.put("HSE_PLAN_ID", hse_plan_id);
				map.put("ORDER_NUM", i);
				pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_TRAIN_RECORD");
			}
		}
		
		return responseDTO;
	}
	
	public ISrvMsg viewHseTraining(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken(); 
		
		String hse_plan_id = isrvmsg.getValue("hse_plan_id");
		String train_detail_no = isrvmsg.getValue("detail_id");
		String sqlNew = "select tp.hse_plan_id, tp.train_object,tp.train_address,oi.org_abbreviation  second_org_name,oi1.org_abbreviation third_org_name,tp.project_name,tp.train_time,tp.second_org,tp.third_org,tp.bsflag,tp.modifi_date,tp.train_content,td.hse_detail_id, td.train_num,td.train_class,td.train_cost,td.train_transport,td.train_material,td.train_places,td.train_accommodation,td.train_other,td.train_total,tp.train_purpose from bgp_hse_train_plan tp left join bgp_hse_train_detail td on tp.hse_plan_id=td.hse_plan_id  left join comm_org_subjection os on tp.second_org = os.org_subjection_id and os.bsflag = '0' left join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0'  left join comm_org_subjection os1 on tp.third_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' where tp.bsflag = '0' and tp.hse_plan_id = '"+hse_plan_id+"'";
		Map mapNew = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlNew);
		
		String sqlOld = "select pn.train_plan_no,pn.train_object,train_address,oi1.org_abbreviation  second_org_name,i.org_abbreviation,p.project_name,pn.train_cycle,os1.org_subjection_id second_org, os.org_subjection_id  third_org,dl.bsflag, dl.modifi_date,dl.train_content,dl.train_detail_no,dl.train_number,dl.train_class,dl.train_cost,dl.train_transportation,dl.train_materials,dl.train_places,dl.train_accommodation,dl.train_other,dl.train_total,pn.train_purpose from BGP_COMM_HUMAN_TRAINING_DETAIL dl inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no = pn.train_plan_no and pn.bsflag = '0' left join gp_task_project p on pn.project_info_no = p.project_info_no and p.bsflag = '0' left join comm_org_information i on pn.spare1 = i.org_id and i.bsflag = '0' left join comm_org_subjection os on os.org_id = i.org_id and os.bsflag = '0' left join comm_org_subjection os1 on os.father_org_id = os1.org_subjection_id and os1.bsflag = '0'  left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' where dl.bsflag = '0' and (dl.classification = '2' or dl.classification = '4')   and dl.train_detail_no='"+train_detail_no+"'";
		Map mapOld = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlOld);
		
		
		String sqlRecord = "select * from ((select td.train_plan_no,d.employee_id,d.employee_type ,d.train_result, d.notes,d.train_date, decode(ls.employee_name, '', es.employee_name, ls.employee_name) employee_name from BGP_COMM_HUMAN_TRAINING_RECORD d left join bgp_comm_human_training_detail td on d.train_detail_no=td.train_detail_no and td.bsflag='0'   left join bgp_comm_human_labor ls on d.employee_id = ls.labor_id left join comm_human_employee es on d.employee_id = es.employee_id where d.bsflag='0') union all (select tr.hse_plan_id,tr.employee_id,tr.employee_type,tr.train_result,tr.notes,tr.train_date,decode(ls.employee_name,'',es.employee_name,ls.employee_name) employee_name from bgp_hse_train_record tr left join bgp_comm_human_labor ls on tr.employee_id = ls.labor_id and ls.bsflag='0' left join comm_human_employee es on tr.employee_id = es.employee_id and es.bsflag='0' )) t where t.train_plan_no = '"+hse_plan_id+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlRecord);
	
		responseDTO.setValue("mapNew", mapNew);
		responseDTO.setValue("mapOld", mapOld);
		responseDTO.setValue("list", list);
		
		return responseDTO;
	}
	
	public ISrvMsg deleteHseTraining(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String ids = isrvmsg.getValue("ids");
		
		String id[] =  ids.split(",");
		for(int i=0;i<id.length;i+=2){
			String sql = "update bgp_hse_train_plan set bsflag = '1' where hse_plan_id='"+id[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		return responseDTO;
	}
	
	
	//HSE法律法规  ---多项目
	public ISrvMsg addLawAndRequest(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
//		String org_subjection_id = user.getOrgSubjectionId();
//		String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
//		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		
//		String org_sub_id = "C105";
//		int len = list.size();
//		if(len>0){
//			if((String)((Map)list.get(0)).get("organFlag")!="0"){
//				org_sub_id = (String)((Map)list.get(0)).get("orgSubId");
//				if(len>1){
//					if((String)((Map)list.get(1)).get("organFlag")!="0"){
//						org_sub_id = (String)((Map)list.get(1)).get("orgSubId");
//						if(len>2){
//							if((String)((Map)list.get(2)).get("organFlag")!="0"){
//								org_sub_id = (String)((Map)list.get(2)).get("orgSubId");
//							}
//						}
//					}
//				}
//			}
//		}
		
		String hse_law_id = isrvmsg.getValue("hse_law_id");
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		Map map = new HashMap();
		map.put("HSE_LAW_ID", hse_law_id);
		map.put("ORG_SUB_ID", org_sub_id);
		map.put("BSFLAG", "0");
		if(hse_law_id==null||hse_law_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("MODIFI_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_LAW");
		hse_law_id = id.toString();
		
		String temp = isrvmsg.getValue("temp");
	
		if(temp!=null&&!temp.equals("")){
			
			String sqlDelete = "delete from bgp_hse_law_detail where  hse_law_id = '"+hse_law_id+"'";
			jdbcTemplate.execute(sqlDelete);
			
			String[] orders = temp.split(","); 
			for(int i=0;i<orders.length;i++){
				String order = orders[i];
				String order_num = isrvmsg.getValue("order_num"+order);
				String law_name = isrvmsg.getValue("law"+order);
				String file_code = isrvmsg.getValue("file_code"+order);
				String start_date = isrvmsg.getValue("start_date"+order);
				String if_ok = isrvmsg.getValue("if_ok"+order);
				
				Map map1 = new HashMap();
				map1.put("ORDER_NUM", order_num);
				map1.put("LAW_NAME", law_name);
				map1.put("FILE_CODE", file_code);
				map1.put("START_DATE", start_date);
				map1.put("HSE_LAW_ID", hse_law_id);
				map1.put("IF_OK", if_ok);
				pureJdbcDao.saveOrUpdateEntity(map1,"BGP_HSE_LAW_DETAIL");
			}
		}
		
		return responseDTO;
	}
	
	//HSE法律法规
	public ISrvMsg addLawAndRequestOrg(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_law_id = isrvmsg.getValue("hse_law_id");
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		String father_modifi_date = isrvmsg.getValue("modifi_date");
		Map map = new HashMap();
		map.put("HSE_LAW_ID", hse_law_id);
		map.put("ORG_SUB_ID", org_sub_id);
		map.put("FATHER_MODIFI_DATE", father_modifi_date);
		map.put("BSFLAG", "0");
		if(hse_law_id==null||hse_law_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("MODIFI_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_LAW");
		hse_law_id = id.toString();
		
		String temp = isrvmsg.getValue("temp");
		String ids = isrvmsg.getValue("ids");
	
		if(temp!=null&&!temp.equals("")){
			
			String sqlDelete = "delete from bgp_hse_law_detail where (if_ok='1' or if_ok is null) and hse_law_id = '"+hse_law_id+"'";
			jdbcTemplate.execute(sqlDelete);
			
			String[] orders = temp.split(",");
			
			for(int i=0;i<orders.length;i++){
				String order = orders[i];
				String order_num = isrvmsg.getValue("order_num"+order);
				String law_name = isrvmsg.getValue("law"+order);
				String file_code = isrvmsg.getValue("file_code"+order);
				String start_date = isrvmsg.getValue("start_date"+order);
				String if_ok = isrvmsg.getValue("if_ok"+order);
				if(ids!=null&&!ids.equals("")){
					String[] idss = ids.split(",");
					for(int j=0;j<idss.length;j++){
						String if_ok_value = idss[j];
						if(if_ok_value.equals(order)){
							if_ok = "1";
						}
					}
				}
				
				Map map1 = new HashMap();
				map1.put("ORDER_NUM", order_num);
				map1.put("LAW_NAME", law_name);
				map1.put("FILE_CODE", file_code);
				map1.put("START_DATE", start_date);
				map1.put("HSE_LAW_ID", hse_law_id);
				map1.put("IF_OK", if_ok);
				pureJdbcDao.saveOrUpdateEntity(map1,"BGP_HSE_LAW_DETAIL");
			}
		}
		
		return responseDTO;
	}
	
	//HSE法律法规
	public ISrvMsg addLawAndRequestOrgSelf(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String hse_law_id = isrvmsg.getValue("hse_law_id");
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		Map map = new HashMap();
		map.put("HSE_LAW_ID", hse_law_id);
		map.put("ORG_SUB_ID", org_sub_id);
		map.put("BSFLAG", "0");
		if(hse_law_id==null||hse_law_id.equals("")){
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("MODIFI_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_LAW");
		hse_law_id = id.toString();
		
		String temp = isrvmsg.getValue("temp");
	
		if(temp!=null&&!temp.equals("")){
			
			String sqlDelete = "delete from bgp_hse_law_detail where if_ok='2' and hse_law_id = '"+hse_law_id+"'";
			jdbcTemplate.execute(sqlDelete);
			
			String[] orders = temp.split(",");
			
			for(int i=0;i<orders.length;i++){
				String order = orders[i];
				String order_num = isrvmsg.getValue("order_num"+order);
				String law_name = isrvmsg.getValue("law"+order);
				String file_code = isrvmsg.getValue("file_code"+order);
				String start_date = isrvmsg.getValue("start_date"+order);
				String if_ok = isrvmsg.getValue("if_ok"+order);
				
				Map map1 = new HashMap();
				map1.put("ORDER_NUM", order_num);
				map1.put("LAW_NAME", law_name);
				map1.put("FILE_CODE", file_code);
				map1.put("START_DATE", start_date);
				map1.put("HSE_LAW_ID", hse_law_id);
				map1.put("IF_OK", if_ok);
				pureJdbcDao.saveOrUpdateEntity(map1,"BGP_HSE_LAW_DETAIL");
			}
		}
		
		return responseDTO;
	}
	
	public ISrvMsg deleteLaw(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String org_sub_id = isrvmsg.getValue("org_sub_id");
		
		String sql = "update bgp_hse_law set bsflag = '1' where org_sub_id='"+org_sub_id+"'";
		jdbcTemplate.execute(sql);
		
		return responseDTO;
	}
	
	
	//HSE检查    附件导入功能
	public ISrvMsg importHseCheck(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
		UserToken user = reqDTO.getUserToken();	
		
		String check_no = reqDTO.getValue("check_no");
		
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
						
						String exist_unit = "";
						String roots_unit = "";
						String exist_parts = "";
						String gause_analysis = "";
						String requirements = "";
						String completion = "";
						String completion_time = "";
						String detail_name = "";
						String detail_model = "";
						String detail_quantity = "";
						String approval_conditions = "";
						String notes = "";
						String spare2 = "";
						
							
			 
						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																						// 集合
						for (int j = 0; j <9; j++) {
							Cell ss = row.getCell(j);
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									exist_unit = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("exist_unit", exist_unit);
									break;
								case 1:
									ss.setCellType(1);
									roots_unit = ss.getStringCellValue().trim();
									tempMap.put("roots_unit", roots_unit);
									break; 
								case 2:
									ss.setCellType(1);
									exist_parts = ss.getStringCellValue().trim();
									tempMap.put("exist_parts", exist_parts);
									break; 
								case 3:
									ss.setCellType(1);
									completion_time = ss.getStringCellValue().trim();
									if(ss.getCellType()==0){
										completion_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										completion_time = ss.getStringCellValue().trim(); // 对应赋值
									} 
									completion_time=completion_time.replace("/", "-");
									String[] biths=completion_time.split("-");
									String temp="";
									for(int i=0;i<biths.length;i++){
										if(biths[i].length()==1){
										biths[i]="0"+biths[i];
										}
										if(i==biths.length-1){
											temp+=biths[i];
										}else{
											temp+=biths[i]+"-";
										}
										
									}
									tempMap.put("completion_time", temp);
									
									try{
										new SimpleDateFormat("yyyy-MM-dd").parse(temp);
									}catch(Exception ex){
										
										message.append("第").append(m + 1).append(
									"行上报日期格式不正确;");
									} 
									break; 
								case 4:
									ss.setCellType(1);
									spare2 = ss.getStringCellValue().trim();
									tempMap.put("spare2", spare2);
									break;  
								case 5:
									ss.setCellType(1);
									notes = ss.getStringCellValue().trim();
									tempMap.put("notes", notes);
									break; 
								case 6:
									ss.setCellType(1);
									gause_analysis = ss.getStringCellValue().trim();
									tempMap.put("gause_analysis", gause_analysis);
									break; 
								case 7:
									ss.setCellType(1);
									requirements = ss.getStringCellValue().trim();
									tempMap.put("requirements", requirements);
									break; 
								case 8:
									ss.setCellType(1);
									completion = ss.getStringCellValue().trim();
									tempMap.put("completion", completion);
									break; 
								default:
									break;
								}
							}
						}
						
						if (message.toString().equals("")) {
							tempMap.put("check_no", check_no);
							datelist.add(tempMap);
						} // 必填项不为空 则把数据放入 集合中
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportHseCheck(datelist, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");

			}
		}
		return responseDTO;
	}
	public void saveImportHseCheck(List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合
			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i);    
				String exist_unit = (String)map.get("exist_unit");
				String roots_unit = (String)map.get("roots_unit");
				String exist_parts = (String)map.get("exist_parts");
				String gause_analysis = (String)map.get("gause_analysis");
				String requirements = (String)map.get("requirements");
				String completion = (String)map.get("completion");
				String completion_time = (String)map.get("completion_time");
				String detail_name = (String)map.get("detail_name");
				String detail_model = (String)map.get("detail_model");
				String detail_quantity = (String)map.get("detail_quantity");
				String approval_conditions = (String)map.get("approval_conditions");
				String notes = (String)map.get("notes");
				String spare2 = (String)map.get("spare2");
				
				String check_no = (String)map.get("check_no");
					
						  
				Map tempMap = new HashMap(); 
				tempMap.put("CHECK_DETAIL_NO", "");
				tempMap.put("CHECK_NO", check_no);
				tempMap.put("EXIST_UNIT", exist_unit);
				tempMap.put("ROOTS_UNIT", roots_unit);
				tempMap.put("EXIST_PARTS", exist_parts);
				tempMap.put("GAUSE_ANALYSIS", gause_analysis);
				tempMap.put("REQUIREMENTS", requirements);
				tempMap.put("COMPLETION", completion);
				tempMap.put("COMPLETION_TIME", completion_time);
				tempMap.put("NOTES", notes);
				tempMap.put("SPARE2", spare2);
				tempMap.put("BSFLAG", "0");
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("UPDATOR_ID", user.getUserId());
				 
				//jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_HIDDEN_INFORMATION"); // 保存
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"BGP_HSE_CHECK_DETAIL");
			}
		}
	}
	
	
	

	
	//HSE检查主信息导入功能
		public ISrvMsg importHseCheckMain(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
			UserToken user = reqDTO.getUserToken();	
			
			String isProject = reqDTO.getValue("isProject");
			String projectInfoNo = reqDTO.getValue("projectInfoNo");
		 
			String org_sub_id = reqDTO.getValue("org_sub_id");
			String second_org = reqDTO.getValue("second_org");
			String check_unit_org = reqDTO.getValue("check_unit_org");
			String check_roots_org = reqDTO.getValue("check_roots_org");
			String check_unit_id = reqDTO.getValue("check_unit_id");
			String check_roots_id = reqDTO.getValue("check_roots_id");
			
			if  (null != check_unit_org && !"".equals(check_unit_org))  {
				check_unit_org = URLDecoder.decode(check_unit_org, "utf-8");
			}
			if  (null != check_roots_org && !"".equals(check_roots_org))  {
				check_roots_org = URLDecoder.decode(check_roots_org, "utf-8");
			}
		
			
			SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
			StringBuffer message = new StringBuffer("");
			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
			List<WSFile> fileList = mqMsg.getFiles();
			if (fileList != null && fileList.size() > 0) {
				WSFile fs = fileList.get(0);
				List<Map> datelist = new ArrayList<Map>();
				try {
					Workbook book = null;
					Sheet sheet = null;
					Row row = null;
					if (fs.getFilename().indexOf(".xlsx") == -1) {
						book = new HSSFWorkbook(new POIFSFileSystem(
								new ByteArrayInputStream(fs.getFileData())));
						sheet = book.getSheetAt(0);
					} else {
						book = new XSSFWorkbook(new ByteArrayInputStream(fs
								.getFileData()));
						sheet = book.getSheetAt(0);
					}
					if (sheet != null) {
						for (int m = 3; m <= sheet.getLastRowNum(); m++) {
							row = sheet.getRow(m);
							
							String check_parts="";
							String check_type="";
							String if_contractor_team="";
							String leadership_led="";
							String led_leadership="";
							String contact="";
							String check_members="";
							String check_start_time="";
							String check_end_time="";
							String check_level = "";
			  
							Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																							// 集合
							for (int j = 0; j <10; j++) {
								Cell ss = row.getCell(j);
								if (ss != null && !"".equals(ss.toString())) {
									switch (j) {
									case 0:
										ss.setCellType(1);
										check_parts = ss.getStringCellValue().trim(); // 对应赋值
										tempMap.put("check_parts", check_parts);
										break;
									case 1:
										ss.setCellType(1);
										check_type = ss.getStringCellValue().trim();
										tempMap.put("check_type", check_type);
										break; 
									case 2:
										ss.setCellType(1);
										if_contractor_team = ss.getStringCellValue().trim();
										tempMap.put("if_contractor_team", if_contractor_team);
										break; 
									case 3:
										ss.setCellType(1);
										leadership_led = ss.getStringCellValue().trim();
										tempMap.put("leadership_led", leadership_led);
										break; 
									case 4:
										ss.setCellType(1);
										led_leadership = ss.getStringCellValue().trim();
										tempMap.put("led_leadership", led_leadership);
										break; 	
									case 5:
										ss.setCellType(1);
										contact = ss.getStringCellValue().trim();
										tempMap.put("contact", contact);
										break; 	
									case 6:
										ss.setCellType(1);
										check_members = ss.getStringCellValue().trim();
										tempMap.put("check_members", check_members);
										break;
									
										
									case 7:
										ss.setCellType(1);
										check_start_time = ss.getStringCellValue().trim();
										if(ss.getCellType()==0){
											check_start_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											check_start_time = ss.getStringCellValue().trim(); // 对应赋值
										} 
										check_start_time=check_start_time.replace("/", "-");
										String[] biths=check_start_time.split("-");
										String temp="";
										for(int i=0;i<biths.length;i++){
											if(biths[i].length()==1){
											biths[i]="0"+biths[i];
											}
											if(i==biths.length-1){
												temp+=biths[i];
											}else{
												temp+=biths[i]+"-";
											}
											
										}
										tempMap.put("check_start_time", temp);
										
										try{
											new SimpleDateFormat("yyyy-MM-dd").parse(temp);
										}catch(Exception ex){
											
											message.append("第").append(m + 1).append(
										"行检查开始日期格式不正确;");
										} 
										break; 
										
									case 8:
										ss.setCellType(1);
										check_end_time = ss.getStringCellValue().trim();
										if(ss.getCellType()==0){
											check_end_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											check_end_time = ss.getStringCellValue().trim(); // 对应赋值
										} 
										check_end_time=check_end_time.replace("/", "-");
										String[] biths_end=check_end_time.split("-");
										String temp_end="";
										for(int t=0;t<biths_end.length;t++){
											if(biths_end[t].length()==1){
												biths_end[t]="0"+biths_end[t];
											}
											if(t==biths_end.length-1){
												temp_end+=biths_end[t];
											}else{
												temp_end+=biths_end[t]+"-";
											}
											
										}
										tempMap.put("check_end_time", temp_end);
										
										try{
											new SimpleDateFormat("yyyy-MM-dd").parse(temp_end);
										}catch(Exception ex){
											
											message.append("第").append(m + 1).append(
										"行检查结束日期格式不正确;");
										} 
										break; 
										
									case 9:
										ss.setCellType(1);
										check_level = ss.getStringCellValue().trim();
										tempMap.put("check_level", check_level);
										break;
										
									default:
										break;
									}
								}
							}
						 
							
							if(check_type.equals("")|| check_type.equals("")){
								message.append("第").append(m+1).append("行,检查类别不能为空!");
							}
							if(if_contractor_team.equals("")|| if_contractor_team.equals("")){
								message.append("第").append(m+1).append("行,是否承包商队伍检查不能为空!");
							}
							if(leadership_led.equals("")|| leadership_led.equals("")){
								message.append("第").append(m+1).append("行,领导带队不能为空!");
							}
							if(check_members.equals("")|| check_members.equals("")){
								message.append("第").append(m+1).append("行,检查成员不能为空!");
							}
							if(check_start_time.equals("")|| check_start_time.equals("")){
								message.append("第").append(m+1).append("行,检查开始时间不能为空!");
							}
							if(check_end_time.equals("")|| check_end_time.equals("")){
								message.append("第").append(m+1).append("行,检查结束时间不能为空!");
							}
							if(check_level.equals("")|| check_level.equals("")){
								message.append("第").append(m+1).append("行,检查级别不能为空!");
							}
							
							
							if (message.toString().equals("")) {
								tempMap.put("isProject", isProject);
								tempMap.put("projectInfoNo", projectInfoNo);
								
								tempMap.put("org_sub_id", org_sub_id);
								tempMap.put("second_org", second_org);
								tempMap.put("check_unit_org", check_unit_org);
								tempMap.put("check_roots_org", check_roots_org);
								tempMap.put("check_unit_id", check_unit_id);
								tempMap.put("check_roots_id", check_roots_id);
		 
								
								datelist.add(tempMap);
							} // 必填项不为空 则把数据放入 集合中
						}
					}
				} catch (Exception e) {
					System.out.println(e.getMessage());
				}
				if (!message.toString().equals("")) {
					responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
				} else {
					if (datelist != null && datelist.size() > 0) {
						saveImportHseCheckMain(datelist, user); // 调用保存方法
					}
					responseDTO.setValue("message", "导入成功!");

				}
			}
			return responseDTO;
		}
	
	
	
		public void saveImportHseCheckMain(List datelist, UserToken user) {
			if (datelist != null && datelist.size() > 0) { // 表格数据list集合
				for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
					Map map = (HashMap) datelist.get(i);    
					
					String org_sub_id =(String)map.get("org_sub_id");
					String second_org = (String)map.get("second_org");
					String check_unit_org = (String)map.get("check_unit_org");
					String check_roots_org =(String)map.get("check_roots_org");
					String check_unit_id =(String)map.get("check_unit_id");
					String check_roots_id =(String)map.get("check_roots_id");
					
					
					String check_parts= (String)map.get("check_parts");
					String check_type= (String)map.get("check_type");
					String if_contractor_team= (String)map.get("if_contractor_team");
					String leadership_led= (String)map.get("leadership_led");
					String led_leadership= (String)map.get("led_leadership");
					String contact= (String)map.get("contact");
					String check_members= (String)map.get("check_members");
					String check_start_time= (String)map.get("check_start_time");
					String check_end_time= (String)map.get("check_end_time");
					String check_level = (String)map.get("check_level");
					
					String isProject = (String)map.get("isProject");
					String projectInfoNo = (String)map.get("projectInfoNo");
					
					String  check_type_s="";
					String  if_contractor_team_s="";
					String  leadership_led_s="";
					String  check_level_s="";
				 
					if(null != check_type && !"".equals(check_type)){
						if(check_type.equals("日常检查")){
							check_type_s="1";
						}else  if(check_type.equals("专项检查")){
							check_type_s="2";
						}else  if(check_type.equals("联系点到位")){
							check_type_s="3";
						}
					}
					
					if(null != if_contractor_team && !"".equals(if_contractor_team)){
						if(if_contractor_team.equals("是")){
							if_contractor_team_s="1";
						}else  if(if_contractor_team.equals("否")){
							if_contractor_team_s="2";
						} 
					}
					if(null != leadership_led && !"".equals(leadership_led)){
						if(leadership_led.equals("是")){
							leadership_led_s="1";
						}else  if(leadership_led.equals("否")){
							leadership_led_s="2";
						} 
					}
				 
					if(null != check_level && !"".equals(check_level)){
						if(check_level.equals("公司")){
							check_level_s="1";
							org_sub_id="";
						}else  if(check_level.equals("二级单位")){
							check_level_s="2";
							second_org="";
						}else  if(check_level.equals("基层单位")){
							check_level_s="3";
						}
					}
					
					
					check_start_time=check_start_time.replace("-", "");
					String check_name=check_level+check_start_time+check_type;
					
					Map tempMap = new HashMap(); 
					
					tempMap.put("check_no", "");
					tempMap.put("org_sub_id", org_sub_id);
					tempMap.put("second_org", second_org);
					tempMap.put("check_level", check_level_s);
					tempMap.put("check_unit_org", check_unit_org);
					tempMap.put("check_roots_org", check_roots_org);
					tempMap.put("check_parts", check_parts);
					tempMap.put("check_type", check_type_s);
					tempMap.put("if_contractor_team", if_contractor_team_s);
					tempMap.put("contact", contact);
					tempMap.put("leadership_led", leadership_led_s);
					tempMap.put("check_members", check_members);
					tempMap.put("check_start_time", check_start_time);
					tempMap.put("check_end_time", check_end_time);
					tempMap.put("led_leadership", led_leadership);
					
					tempMap.put("check_unit_id", check_unit_id);
					tempMap.put("check_roots_id", check_roots_id);
					
					tempMap.put("check_name", check_name);
					
					tempMap.put("bsflag", "0");					
					tempMap.put("create_date", new Date());
					tempMap.put("creator", user.getUserName());
					tempMap.put("modifi_date", new Date());
					tempMap.put("updator", user.getUserName());
 
					if(isProject.equals("2")){
						tempMap.put("project_no", user.getProjectInfoNo()); 
					}
					tempMap.put("number_problems", "0");
					
					//jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_HIDDEN_INFORMATION"); // 保存
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"BGP_HSE_CHECK");
				}
			}
		}
	
	
	
	
	
		//HSE物资台账信息导入功能
				public ISrvMsg importSbookMain(ISrvMsg reqDTO) throws Exception {
					ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
					UserToken user = reqDTO.getUserToken();	
					
					String isProject = reqDTO.getValue("isProject");
					String projectInfoNo = reqDTO.getValue("projectInfoNo");
				 
					String org_sub_id = reqDTO.getValue("org_sub_id");
					String second_org = reqDTO.getValue("second_org");
					String third_org = reqDTO.getValue("third_org");
			 
					
					SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
					StringBuffer message = new StringBuffer("");
					MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
					List<WSFile> fileList = mqMsg.getFiles();
					if (fileList != null && fileList.size() > 0) {
						WSFile fs = fileList.get(0);
						List<Map> datelist = new ArrayList<Map>();
						try {
							Workbook book = null;
							Sheet sheet = null;
							Row row = null;
							if (fs.getFilename().indexOf(".xlsx") == -1) {
								book = new HSSFWorkbook(new POIFSFileSystem(
										new ByteArrayInputStream(fs.getFileData())));
								sheet = book.getSheetAt(0);
							} else {
								book = new XSSFWorkbook(new ByteArrayInputStream(fs
										.getFileData()));
								sheet = book.getSheetAt(0);
							}
							if (sheet != null) {
								for (int m = 3; m <= sheet.getLastRowNum(); m++) {
									row = sheet.getRow(m);
									
									String supplies_name="";
									String supplies_category="";
									String model_num="";
									String quantity="";
									String unit_measurement="";
									String acquisition_time="";
									String valid_until="";
									String check_period_until="";
									String storage_location="";
									String the_depository="";
									
									 
					  
									Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																									// 集合
									for (int j = 0; j <10; j++) {
										Cell ss = row.getCell(j);
										if (ss != null && !"".equals(ss.toString())) {
											switch (j) {
											case 0:
												ss.setCellType(1);
												supplies_name = ss.getStringCellValue().trim(); // 对应赋值
												tempMap.put("supplies_name", supplies_name);
												break;
											case 1:
												ss.setCellType(1);
												supplies_category = ss.getStringCellValue().trim();
												tempMap.put("supplies_category", supplies_category);
												break; 
											case 2:
												ss.setCellType(1);
												model_num = ss.getStringCellValue().trim();
												tempMap.put("model_num", model_num);
												break; 
											case 3:
												ss.setCellType(1);
												quantity = ss.getStringCellValue().trim();
												tempMap.put("quantity", quantity);
												break; 
											case 4:
												ss.setCellType(1);
												unit_measurement = ss.getStringCellValue().trim();
												tempMap.put("unit_measurement", unit_measurement);
												break; 	
											case 5:
												ss.setCellType(1);
												acquisition_time = ss.getStringCellValue().trim();
												if(ss.getCellType()==0){
													acquisition_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
												}else{
													ss.setCellType(1);
													acquisition_time = ss.getStringCellValue().trim(); // 对应赋值
												} 
												acquisition_time=acquisition_time.replace("/", "-");
												String[] biths_g=acquisition_time.split("-");
												String temp_g="";
												for(int g=0;g<biths_g.length;g++){
													if(biths_g[g].length()==1){
														biths_g[g]="0"+biths_g[g];
													}
													if(g==biths_g.length-1){
														temp_g+=biths_g[g];
													}else{
														temp_g+=biths_g[g]+"-";
													}
													
												}
												tempMap.put("acquisition_time", temp_g);
												
												try{
													new SimpleDateFormat("yyyy-MM-dd").parse(temp_g);
												}catch(Exception ex){
													
													message.append("第").append(m + 1).append(
												"行购置时间格式不正确;");
												} 
												break; 	
 	
											case 6:
												ss.setCellType(1);
												valid_until = ss.getStringCellValue().trim();
												if(ss.getCellType()==0){
													valid_until=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
												}else{
													ss.setCellType(1);
													valid_until = ss.getStringCellValue().trim(); // 对应赋值
												} 
												valid_until=valid_until.replace("/", "-");
												String[] biths=valid_until.split("-");
												String temp="";
												for(int i=0;i<biths.length;i++){
													if(biths[i].length()==1){
													biths[i]="0"+biths[i];
													}
													if(i==biths.length-1){
														temp+=biths[i];
													}else{
														temp+=biths[i]+"-";
													}
													
												}
												tempMap.put("valid_until", temp);
												
												try{
													new SimpleDateFormat("yyyy-MM-dd").parse(temp);
												}catch(Exception ex){
													
													message.append("第").append(m + 1).append(
												"行有效截止至格式不正确;");
												} 
												break; 
												
											case 7:
												ss.setCellType(1);
												check_period_until = ss.getStringCellValue().trim();
												if(ss.getCellType()==0){
													check_period_until=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
												}else{
													ss.setCellType(1);
													check_period_until = ss.getStringCellValue().trim(); // 对应赋值
												} 
												check_period_until=check_period_until.replace("/", "-");
												String[] biths_end=check_period_until.split("-");
												String temp_end="";
												for(int t=0;t<biths_end.length;t++){
													if(biths_end[t].length()==1){
														biths_end[t]="0"+biths_end[t];
													}
													if(t==biths_end.length-1){
														temp_end+=biths_end[t];
													}else{
														temp_end+=biths_end[t]+"-";
													}
													
												}
												tempMap.put("check_period_until", temp_end);
												
												try{
													new SimpleDateFormat("yyyy-MM-dd").parse(temp_end);
												}catch(Exception ex){
													
													message.append("第").append(m + 1).append(
												"行校验期截止至格式不正确;");
												} 
												break; 
												
											case 8:
												ss.setCellType(1);
												storage_location = ss.getStringCellValue().trim();
												tempMap.put("storage_location", storage_location);
												break;
											case 9:
												ss.setCellType(1);
												the_depository = ss.getStringCellValue().trim();
												tempMap.put("the_depository", the_depository);
												break;
												
												
											default:
												break;
											}
										}
									}
								 
									
									if(supplies_name.equals("")|| supplies_name.equals("")){
										message.append("第").append(m+1).append("行,物资名称不能为空!");
									}
									if(supplies_category.equals("")|| supplies_category.equals("")){
										message.append("第").append(m+1).append("行,物资类别不能为空!");
									}
									if(quantity.equals("")|| quantity.equals("")){
										message.append("第").append(m+1).append("行,数量不能为空!");
									}
									if(unit_measurement.equals("")|| unit_measurement.equals("")){
										message.append("第").append(m+1).append("行,计量单位不能为空!");
									}
									if(acquisition_time.equals("")|| acquisition_time.equals("")){
										message.append("第").append(m+1).append("行,购置时间不能为空!");
									}
									if(storage_location.equals("")|| storage_location.equals("")){
										message.append("第").append(m+1).append("行,存放位置不能为空!");
									}
									if(the_depository.equals("")|| the_depository.equals("")){
										message.append("第").append(m+1).append("行,保管人不能为空!");
									}
									
									
									if (message.toString().equals("")) {
										tempMap.put("isProject", isProject);
										tempMap.put("projectInfoNo", projectInfoNo);
										
										tempMap.put("org_sub_id", org_sub_id);
										tempMap.put("second_org", second_org);
										tempMap.put("third_org", third_org);
										 
										
										datelist.add(tempMap);
									} // 必填项不为空 则把数据放入 集合中
								}
							}
						} catch (Exception e) {
							System.out.println(e.getMessage());
						}
						if (!message.toString().equals("")) {
							responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
						} else {
							if (datelist != null && datelist.size() > 0) {
								saveImportSbookMain(datelist, user); // 调用保存方法
							}
							responseDTO.setValue("message", "导入成功!");

						}
					}
					return responseDTO;
				}
			
	
				public void saveImportSbookMain(List datelist, UserToken user) {
					if (datelist != null && datelist.size() > 0) { // 表格数据list集合
						for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
							Map map = (HashMap) datelist.get(i);    
							
							String org_sub_id =(String)map.get("org_sub_id");
							String second_org = (String)map.get("second_org");
							String third_org = (String)map.get("third_org");
							  
							String supplies_name=(String)map.get("supplies_name");
							String supplies_category=(String)map.get("supplies_category");
							String model_num=(String)map.get("model_num");
							String quantity=(String)map.get("quantity");
							String unit_measurement=(String)map.get("unit_measurement");
							String acquisition_time=(String)map.get("acquisition_time");
							String valid_until=(String)map.get("valid_until");
							String check_period_until=(String)map.get("check_period_until");
							String storage_location=(String)map.get("storage_location");
							String the_depository=(String)map.get("the_depository");
							 
							String isProject = (String)map.get("isProject");
							String projectInfoNo = (String)map.get("projectInfoNo");
							
							String  supplies_category_s="";
							 
							if(null != supplies_category && !"".equals(supplies_category)){
								if(supplies_category.equals("人身防护")){
									supplies_category_s="1";
								}else  if(supplies_category.equals("医疗急救")){
									supplies_category_s="2";
								}else  if(supplies_category.equals("消防救援")){
									supplies_category_s="3";
								}else  if(supplies_category.equals("防洪防汛")){
									supplies_category_s="4";
								}else  if(supplies_category.equals("应急照明")){
									supplies_category_s="5";
								}else  if(supplies_category.equals("交通运输")){
									supplies_category_s="6";
								}else  if(supplies_category.equals("通讯联络")){
									supplies_category_s="7";
								}else  if(supplies_category.equals("检测监测")){
									supplies_category_s="8";
								}else  if(supplies_category.equals("工程抢险")){
									supplies_category_s="9";
								}else  if(supplies_category.equals("剪切破拆")){
									supplies_category_s="10";
								}else  if(supplies_category.equals("电力抢修")){
									supplies_category_s="11";
								}else  if(supplies_category.equals("其他")){
									supplies_category_s="12";
								}
							}
							 
							
							Map tempMap = new HashMap(); 
							
							tempMap.put("emergency_no", "");
							tempMap.put("org_sub_id", org_sub_id);
							tempMap.put("second_org", second_org);
							tempMap.put("third_org", third_org);
					 
							tempMap.put("supplies_name", supplies_name);
							tempMap.put("supplies_category", supplies_category_s);
							tempMap.put("model_num", model_num);
							tempMap.put("quantity", quantity);
							tempMap.put("unit_measurement", unit_measurement);
							tempMap.put("valid_until", valid_until);
							tempMap.put("acquisition_time", acquisition_time);
							tempMap.put("check_period_until", check_period_until);
							tempMap.put("storage_location", storage_location);
							tempMap.put("the_depository", the_depository);
						  
							tempMap.put("bsflag", "0");					
							tempMap.put("create_date", new Date());
							tempMap.put("creator", user.getUserName());
							tempMap.put("modifi_date", new Date());
							tempMap.put("updator", user.getUserName());
		 
							if(isProject.equals("2")){
								tempMap.put("project_no", user.getProjectInfoNo()); 
							}
				  
							BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"BGP_EMERGENCY_STANDBOOK");
						}
					}
				}
			
				
			//HSE检查主信息导入功能
			public ISrvMsg editHseExamine(ISrvMsg reqDTO) throws Exception {
				ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
				UserToken user = reqDTO.getUserToken();	
				
//					String isProject = reqDTO.getValue("isProject");
//					String projectInfoNo = reqDTO.getValue("projectInfoNo");
			 
				String ids = reqDTO.getValue("ids");
				String hse_examine_id = reqDTO.getValue("hse_examine_id");
				
				String deleteSql = "delete from BGP_HSE_EXAMINE_MENU where project_info_no='"+user.getProjectInfoNo()+"'";
				jdbcTemplate.execute(deleteSql);
				
				if(ids!=null){
					String[] id = ids.split(",");
					for(int i=0 ; i<id.length;i++){
						Map map = new HashMap();
						map.put("BSFLAG" , "0");
						map.put("CREATE_DATE" , new Date());
						map.put("CREATOR_ID" , user.getUserId());
						map.put("MODIFI_DATE" , new Date());
						map.put("UPDATOR_ID" , user.getUserId());
						map.put("PROJECT_INFO_NO" , user.getProjectInfoNo());
						map.put("MENU_ID" , id[i]);
						map.put("ORG_SUBJECTION_ID" , user.getOrgSubjectionId());
						map.put("ORG_ID" , user.getOrgId());
						pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_EXAMINE_MENU");
					}
				}
				responseDTO.setValue("message", "保存成功!");
				return responseDTO;
			}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//fusionCharts  隐患基本信息   饼状图
	public ISrvMsg queryDanPie(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String sql = "with temptable as ( select '一般' as dan_level from dual union select '较大' from dual union select '重大' from dual union select '特大' from dual ) select dan_level,sum(case  nvl(t.hse_danger_id,'0') when '0' then 0 else 1 end) num   from   temptable temp left join  bgp_hse_danger t  on temp.dan_level = t.danger_level and t.bsflag='0' group by temp.dan_level  order by decode(temp.dan_level,'一般','1','较大','2','重大','3','特大','4') asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String Str = "<chart  palette='2' caption='安全隐患情况描述' showPercentageInLabel='0'  formatNumberScale='0' showValues='1' showLabels='1' showLegend='0' legendNumColumns='4' pieRadius=''   bgColor='#EAF1F9'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  danger_level = (String)map.get("danLevel");
			String  num = (String)map.get("num");
			Str = Str+"<set value='"+num+"' label='"+danger_level+"'/>";
		}
		Str = Str+"</chart>";

		responseDTO.setValue("Str", Str);
		
		return responseDTO;

	}
	
	
	//fusionCharts  隐患基本信息   柱状图
	public ISrvMsg queryDanColumn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
	
		//查询出所有二级单位
		String sql = "select t1.org_hr_id,t1.org_hr_short_name as org_name,t2.org_gms_id,t3.org_subjection_id,t3.father_org_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0' where t1.org_hr_parent_id = '50000674' and t1.org_hr_short_name not like '%机关%' and t1.org_hr_short_name not like '%直属机构%'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		//查询出所有级别，为下面for循环所用
		String sql2 = "with temptable as ( select '一般' as dan_level from dual union select '较大' from dual union select '重大' from dual union select '特大' from dual ) select * from temptable temp  order by decode(temp.dan_level,'一般','1','较大','2','重大','3','特大','4') asc";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		String Str = "<chart palette='2' caption='各单位安全隐患分布数量' showLabels='1' showvalues='0'  showSum='1' decimals='0' useRoundEdges='1' legendBorderAlpha='1' formatNumberScale='0' showBorder='0' bgColor='#EAF1F9'><categories>";
		for(int i =0 ;i<list.size();i++){
			Map map = (Map)list.get(i);
			String org_name = (String)map.get("orgName");//单位名称
			Str = Str + "<category label='"+org_name+"' />"; 
		}
			Str= Str + "</categories>";
		
		for(int j=0;j<list2.size();j++){
			Map map2 = (Map)list2.get(j);  
			String dan_level = (String)map2.get("danLevel");  //隐患级别
			Str = Str +"<dataset seriesName='"+dan_level+"' showValues='1'>";
			  for(int k=0;k<list.size();k++){
				  Map mapData = (Map)list.get(k);
				  String org_subjection_id = (String)mapData.get("orgSubjectionId");//组织机构ID
				  //查询某单位，某级别的隐患数量
				  String sql3 = "select count(t.hse_danger_id) num from bgp_hse_danger t where t.bsflag='0' and t.danger_level='"+dan_level+"' and t.second_org='"+org_subjection_id+"'";
				  Map mapNum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
				  String num = (String)mapNum.get("num");
				  Str = Str+"<set value='"+num+"' />"; 
	 		  }
			  Str = Str+"</dataset>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	//fusionCharts  隐患基本信息   柱状图   未整改
	public ISrvMsg queryModColumn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
	
		//查询出所有二级单位
		String sql = "select t1.org_hr_id,t1.org_hr_short_name as org_name,t2.org_gms_id,t3.org_subjection_id,t3.father_org_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0' where t1.org_hr_parent_id = '50000674' and t1.org_hr_short_name not like '%机关%' and t1.org_hr_short_name not like '%直属机构%'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		//查询出所有级别，为下面for循环所用
		String sql2 = "with temptable as ( select '一般' as dan_level from dual union select '较大' from dual union select '重大' from dual union select '特大' from dual ) select * from temptable temp  order by decode(temp.dan_level,'一般','1','较大','2','重大','3','特大','4') asc";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		String Str = "<chart palette='2' caption='各单位未整改隐患分布数量' showLabels='1' showvalues='0'  showSum='1' decimals='0' useRoundEdges='1' legendBorderAlpha='1' formatNumberScale='0' showBorder='0' bgColor='#EAF1F9'><categories>";
		for(int i =0 ;i<list.size();i++){
			Map map = (Map)list.get(i);
			String org_name = (String)map.get("orgName");//单位名称
			Str = Str + "<category label='"+org_name+"' />"; 
		}
			Str= Str + "</categories>";
		
		for(int j=0;j<list2.size();j++){
			Map map2 = (Map)list2.get(j);  
			String dan_level = (String)map2.get("danLevel");  //隐患级别
			Str = Str +"<dataset seriesName='"+dan_level+"' showValues='1'>";
			  for(int k=0;k<list.size();k++){
				  Map mapData = (Map)list.get(k);
				  String org_subjection_id = (String)mapData.get("orgSubjectionId");//组织机构ID
				  //查询某单位，某级别的隐患数量
				  String sql3 = "select count(t.hse_danger_id) num from bgp_hse_danger t where t.bsflag='0' and t.modify_type='未整改' and t.danger_level='"+dan_level+"' and t.second_org='"+org_subjection_id+"'";
				  Map mapNum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
				  String num = (String)mapNum.get("num");
				  Str = Str+"<set value='"+num+"' />"; 
	 		  }
			  Str = Str+"</dataset>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	//fusionCharts  隐患基本信息   饼状图    整改
	public ISrvMsg queryModPie(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
		
		String sql = "with temptable as ( select '已整改' as mod_type from dual union select '未整改' from dual ) select mod_type, sum(case nvl(t.hse_danger_id, '0') when '0' then 0 else 1 end) num  from temptable temp left join bgp_hse_danger t on temp.mod_type = t.modify_type and t.bsflag='0' group by temp.mod_type order by decode(temp.mod_type,'已整改','1','未整改','2') asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String Str = "<chart  palette='2' caption='隐患整改情况' showPercentageInLabel='0'  formatNumberScale='0' showValues='1' showLabels='1' showLegend='0' legendNumColumns='4' pieRadius=''   bgColor='#EAF1F9'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  modType = (String)map.get("modType");
			String  num = (String)map.get("num");
			Str = Str+"<set value='"+num+"' label='"+modType+"'/>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}

	//fusionCharts 事故信息   饼状图    事故类型
	public ISrvMsg queryAccTypePie(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
		
		String sql = "with temptable  as (select '1' as acc_type from dual union select '2' from dual  union select '3' from dual)  select decode(acc_type,'1','工业生产安全事故','2','火灾事故','3','交通事故') acc_type ,sum(case nvl(hse_accident_id,'0') when '0' then 0 else 1 end) num from temptable temp left join bgp_hse_accident_news t on temp.acc_type = t.accident_type and t.bsflag='0' group by temp.acc_type  order by temp.acc_type asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String Str = "<chart  palette='2' caption='' showPercentageInLabel='0'  formatNumberScale='0' showValues='1' showLabels='1' showLegend='1' legendNumColumns='4' pieRadius=''   bgColor='#EAF1F9'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  acc_type = (String)map.get("accType");
			String  num = (String)map.get("num");
			Str = Str+"<set value='"+num+"' label='"+acc_type+"'/>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	//fusionCharts 事故信息   饼状图    事故级别
	public ISrvMsg queryAccLevelPie(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
		
		String sql = "with temptable  as (select '1' as acc_level from dual union select '2' from dual  union select '3' from dual union select '4' from dual)  select decode(acc_level,'1','一般','2','较大','3','重大','4','特大') acc_level ,sum(case nvl(hse_accident_id,'0') when '0' then 0 else 1 end) num from temptable temp left join bgp_hse_accident_record t on temp.acc_level = t.accident_level and t.bsflag='0' group by temp.acc_level  order by temp.acc_level asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String Str = "<chart  palette='2' caption='' showPercentageInLabel='0'  formatNumberScale='0' showValues='1' showLabels='1' showLegend='1' legendNumColumns='4' pieRadius=''   bgColor='#EAF1F9'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  acc_level = (String)map.get("accLevel");
			String  num = (String)map.get("num");
			Str = Str+"<set value='"+num+"' label='"+acc_level+"'/>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	//fusionCharts   事故类型  柱状图  
	public ISrvMsg queryAccTypeColumn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
	
		//查询出所有二级单位
		String sql = "select t1.org_hr_id,t1.org_hr_short_name as org_name,t2.org_gms_id,t3.org_subjection_id,t3.father_org_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0' where t1.org_hr_parent_id = '50000674' and t1.org_hr_short_name not like '%机关%' and t1.org_hr_short_name not like '%直属机构%'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		//查询出所有级别，为下面for循环所用
		String sql2 = "with temptable as ( select '1' as acc_type from dual union select '2' from dual union select '3' from dual ) select decode(temp.acc_type,'1','工业生产安全事故','2','火灾事故','3','交通事故') acc_type,temp.acc_type acc_type2 from temptable temp  order by temp.acc_type asc";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		String Str = "<chart palette='2' caption='各单位事故分布情况' showLabels='1' showvalues='0'  showSum='1' decimals='0' useRoundEdges='1' legendBorderAlpha='1' formatNumberScale='0' showBorder='0' bgColor='#EAF1F9'><categories>";
		for(int i =0 ;i<list.size();i++){
			Map map = (Map)list.get(i);
			String org_name = (String)map.get("orgName");//单位名称
			Str = Str + "<category label='"+org_name+"' />"; 
		}
			Str= Str + "</categories>";
		
		for(int j=0;j<list2.size();j++){
			Map map2 = (Map)list2.get(j);  
			String acc_type = (String)map2.get("accType");  //事故级别    汉字
			String acc_type2 = (String)map2.get("accType2");  //事故级别  数字
			Str = Str +"<dataset seriesName='"+acc_type+"' showValues='1'>";
			  for(int k=0;k<list.size();k++){
				  Map mapData = (Map)list.get(k);
				  String org_subjection_id = (String)mapData.get("orgSubjectionId");//组织机构ID
				  //查询某单位，某级别的事故数量
				  String sql3 = "select count(t.hse_accident_id) num from bgp_hse_accident_news t where t.bsflag='0' and t.accident_type='"+acc_type2+"' and t.second_org='"+org_subjection_id+"'";
				  Map mapNum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
				  String num = (String)mapNum.get("num");
				  Str = Str+"<set value='"+num+"' />"; 
	 		  }
			  Str = Str+"</dataset>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	//fusionCharts  事故级别      柱状图  
	public ISrvMsg queryAccLevelColumn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
	
		//查询出所有二级单位
		String sql = "select t1.org_hr_id,t1.org_hr_short_name as org_name,t2.org_gms_id,t3.org_subjection_id,t3.father_org_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0' where t1.org_hr_parent_id = '50000674' and t1.org_hr_short_name not like '%机关%' and t1.org_hr_short_name not like '%直属机构%'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		//查询出所有级别，为下面for循环所用
		String sql2 = "with temptable as ( select '1' as acc_level from dual union select '2' from dual union select '3' from dual union select '4' from dual ) select decode(temp.acc_level,'1','一般','2','较大','3','重大','4','特大') acc_level,temp.acc_level acc_level2 from temptable temp  order by temp.acc_level asc";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		String Str = "<chart palette='2' caption='各单位事故分布情况' showLabels='1' showvalues='0'  showSum='1' decimals='0' useRoundEdges='1' legendBorderAlpha='1' formatNumberScale='0' showBorder='0' bgColor='#EAF1F9'><categories>";
		for(int i =0 ;i<list.size();i++){
			Map map = (Map)list.get(i);
			String org_name = (String)map.get("orgName");//单位名称
			Str = Str + "<category label='"+org_name+"' />"; 
		}
			Str= Str + "</categories>";
		
		for(int j=0;j<list2.size();j++){
			Map map2 = (Map)list2.get(j);  
 			String acc_level = (String)map2.get("accLevel");  //事故级别   汉字
			String acc_level2 = (String)map2.get("accLevel2");  //事故级别   数字
			Str = Str +"<dataset seriesName='"+acc_level+"' showValues='1'>";
			  for(int k=0;k<list.size();k++){
				  Map mapData = (Map)list.get(k);
				  String org_subjection_id = (String)mapData.get("orgSubjectionId");//组织机构ID
				  //查询某单位，某级别的事故数量
				  String sql3 = "select count(t.hse_accident_id) num from bgp_hse_accident_record t join bgp_hse_accident_news n on t.hse_accident_id=n.hse_accident_id and n.bsflag='0' where t.bsflag='0' and  t.accident_level='"+acc_level2+"' and n.second_org='"+org_subjection_id+"'";
				  Map mapNum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
				  String num = (String)mapNum.get("num");
				  Str = Str+"<set value='"+num+"' />"; 
	 		  }
			  Str = Str+"</dataset>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	//fusionCharts 事件信息   饼状图    事件类型
	public ISrvMsg queryEventTypePie(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
		
		String sql = "with temptable  as (select '1' as event_type from dual union select '2' from dual  union select '3' from dual union select '4' from dual)  select decode(temp.event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') event_type ,sum(case nvl(hse_event_id,'0') when '0' then 0 else 1 end) num from temptable temp left join bgp_hse_event t on temp.event_type = t.event_type and t.bsflag='0' group by temp.event_type  order by temp.event_type asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String Str = "<chart  palette='2' caption='' showPercentageInLabel='0'  formatNumberScale='0' showValues='1' showLabels='1' showLegend='1' legendNumColumns='4' pieRadius=''   bgColor='#EAF1F9'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  event_type = (String)map.get("eventType");
			String  num = (String)map.get("num");
			Str = Str+"<set value='"+num+"' label='"+event_type+"'/>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	//fusionCharts 事件信息   饼状图    事件性质
	public ISrvMsg queryEventLevelPie(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
		
		String sql = "with temptable  as (select '1' as event_pro from dual union select '2' from dual  union select '3' from dual union select '4' from dual union select '5' from dual)  select decode(temp.event_pro,'1','限工事件','2','医疗事件','3','急救箱事件','4','经济损失事件','5','未遂事件') event_pro ,sum(case nvl(t.hse_event_id,'0') when '0' then 0 else 1 end) num from temptable temp left join bgp_hse_event t on temp.event_pro = t.event_property and t.bsflag='0' group by temp.event_pro order by temp.event_pro asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String Str = "<chart  palette='2' caption='' showPercentageInLabel='0'  formatNumberScale='0' showValues='1' showLabels='1' showLegend='1' legendNumColumns='4' pieRadius=''   bgColor='#EAF1F9'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  event_pro = (String)map.get("eventPro");
			String  num = (String)map.get("num");
			Str = Str+"<set value='"+num+"' label='"+event_pro+"'/>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	//fusionCharts   事件类型  柱状图  
	public ISrvMsg queryEventTypeColumn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
	
		//查询出所有二级单位
		String sql = "select t1.org_hr_id,t1.org_hr_short_name as org_name,t2.org_gms_id,t3.org_subjection_id,t3.father_org_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0' where t1.org_hr_parent_id = '50000674' and t1.org_hr_short_name not like '%机关%' and t1.org_hr_short_name not like '%直属机构%'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		//查询出所有级别，为下面for循环所用
		String sql2 = "with temptable as ( select '1' as event_type from dual union select '2' from dual union select '3' from dual union select '4' from dual ) select decode(temp.event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') event_type,temp.event_type event_type2 from temptable temp  order by temp.event_type asc";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		String Str = "<chart palette='2' caption='' showLabels='1' showvalues='0'  showSum='1' decimals='0' useRoundEdges='1' legendBorderAlpha='1' formatNumberScale='0' showBorder='0' bgColor='#EAF1F9'><categories>";
		for(int i =0 ;i<list.size();i++){
			Map map = (Map)list.get(i);
			String org_name = (String)map.get("orgName");//单位名称
			Str = Str + "<category label='"+org_name+"' />"; 
		}
			Str= Str + "</categories>";
		
		for(int j=0;j<list2.size();j++){
			Map map2 = (Map)list2.get(j);  
			String event_type = (String)map2.get("eventType");  //事件类型   汉字
			String event_type2 = (String)map2.get("eventType2");  //  数字
			Str = Str +"<dataset seriesName='"+event_type+"' showValues='1'>";
			  for(int k=0;k<list.size();k++){
				  Map mapData = (Map)list.get(k);
				  String org_subjection_id = (String)mapData.get("orgSubjectionId");//组织机构ID
				  //查询某单位，某级别的事件数量
				  String sql3 = "select count(t.hse_event_id) num from bgp_hse_event t where t.bsflag='0' and t.event_type='"+event_type2+"' and t.second_org='"+org_subjection_id+"'";
				  Map mapNum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
				  String num = (String)mapNum.get("num");
				  Str = Str+"<set value='"+num+"' />"; 
	 		  }
			  Str = Str+"</dataset>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	//fusionCharts  事件属性     柱状图  
	public ISrvMsg queryEventLevelColumn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	
		UserToken user = isrvmsg.getUserToken();
	
		//查询出所有二级单位
		String sql = "select t1.org_hr_id,t1.org_hr_short_name as org_name,t2.org_gms_id,t3.org_subjection_id,t3.father_org_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id join comm_org_subjection t3 on t3.org_id = t2.org_gms_id and t3.bsflag = '0' where t1.org_hr_parent_id = '50000674' and t1.org_hr_short_name not like '%机关%' and t1.org_hr_short_name not like '%直属机构%'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		//查询出所有级别，为下面for循环所用
		String sql2 = "with temptable as ( select '1' as event_pro from dual union select '2' from dual union select '3' from dual union select '4' from dual union select '5' from dual ) select decode(temp.event_pro,'1','限工事件','2','医疗事件','3','急救箱事件','4','经济损失事件','5','未遂事件') event_pro,temp.event_pro event_pro2 from temptable temp  order by temp.event_pro asc";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		String Str = "<chart palette='2' caption='' showLabels='1' showvalues='0'  showSum='1' decimals='0' useRoundEdges='1' legendBorderAlpha='1' formatNumberScale='0' showBorder='0' bgColor='#EAF1F9'><categories>";
		for(int i =0 ;i<list.size();i++){
			Map map = (Map)list.get(i);
			String org_name = (String)map.get("orgName");//单位名称
			Str = Str + "<category label='"+org_name+"' />"; 
		}
			Str= Str + "</categories>";
		
		for(int j=0;j<list2.size();j++){
			Map map2 = (Map)list2.get(j);  
 			String event_pro = (String)map2.get("eventPro");  //隐患级别   汉字
			String event_pro2 = (String)map2.get("eventPro2");  //隐患级别   数字
			Str = Str +"<dataset seriesName='"+event_pro+"' showValues='1'>";
			  for(int k=0;k<list.size();k++){
				  Map mapData = (Map)list.get(k);
				  String org_subjection_id = (String)mapData.get("orgSubjectionId");//组织机构ID
				  //查询某单位，某级别的隐患数量
				  String sql3 = "select count(t.hse_event_id) num from bgp_hse_event t where t.bsflag='0' and  t.event_property='"+event_pro2+"' and t.second_org='"+org_subjection_id+"'";
				  Map mapNum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
				  String num = (String)mapNum.get("num");
				  Str = Str+"<set value='"+num+"' />"; 
	 		  }
			  Str = Str+"</dataset>";
		}
		Str = Str+"</chart>";
	
		responseDTO.setValue("Str", Str);
		
		return responseDTO;
	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

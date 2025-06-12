package com.bgp.mcs.service.hse.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.Serializable;
import java.net.URLDecoder;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import net.sf.json.JSONArray;

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

import com.bgp.gms.service.op.srv.OPCostSrv;
import com.bgp.gms.service.rm.em.pojo.BgpHumanPlanDetail;
import com.bgp.gms.service.rm.em.pojo.BgpHumanTrainingPlan;
import com.bgp.gms.service.rm.em.util.EquipmentAutoNum;
import com.bgp.gms.service.rm.em.util.PropertiesUtil;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.hse.service.pojo.HseOperation;
import com.bgp.mcs.service.hse.service.pojo.HseOperationDetail;
import com.bgp.mcs.service.ma.showMainFrame.util.MarketGetInfoUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;

public class HseOperationSrv  extends BaseService {

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();
	
	/**
	 * 员工树 --> 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getEmployeeTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String org_id ="";
		if(org_id !=null && node!=null && node.equals("root")){
			org_id = user.getOrgId();
		}else{
			org_id = node;
		}
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb  = new StringBuffer();
		sb.append("select t1.org_hr_id ,t1.org_hr_short_name name ,t2.org_gms_id id,t3.org_subjection_id sub_id ,'false' is_employee")
		.append(" from bgp_comm_org_hr t1")
		.append(" join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id ")
		.append(" join comm_org_subjection t3 on t3.org_id = t2.org_gms_id  and t3.bsflag = '0' ")
		.append(" where t2.org_gms_id = '").append(org_id).append("'");
		Map root = pureJdbcDao.queryRecordBySQL(sb.toString());
		String org_hr_id = "";
		if(root!=null){
			org_hr_id = (String)root.get("org_hr_id");
		}
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){
			json = JSONArray.fromObject(root);
		}else{
			list = getEmployee(org_id, org_hr_id);
			json = JSONArray.fromObject(list);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	public List getEmployee(String org_id, String org_hr_id) throws Exception{
		List list = new ArrayList();
		List tList = new ArrayList();
		List jsList = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select t1.org_hr_id ,t1.org_hr_short_name name ,t2.org_gms_id id,t3.org_subjection_id sub_id ,'false' is_employee ")
		.append(" from bgp_comm_org_hr t1")
		.append(" join bgp_comm_org_hr_gms t2 on t1.org_hr_id = t2.org_hr_id ")
		.append(" join comm_org_subjection t3 on t3.org_id = t2.org_gms_id  and t3.bsflag = '0' ")
		.append(" where t1.org_hr_parent_id = '").append(org_hr_id).append("'");
		list = pureJdbcDao.queryRecords(sb.toString());

		sb  = new StringBuffer();
		sb.append(" select e.employee_id as id,e.employee_name as name ,'true' is_employee ,'' org_hr_id ,'' org_gms_id")
		.append(" from comm_human_employee e")
		.append(" where e.bsflag='0' and e.org_id='").append(org_id).append("'");
		tList = pureJdbcDao.queryRecords(sb.toString());
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			jsList.add(map);
		}
		for(int i=0;tList!=null&&i<tList.size();i++){
			Map map = (Map)tList.get(i);
			map.put("leaf", true);
			jsList.add(map);
		}
		return jsList;
	}
	/**
	 * 员工能力评价 --> 基本信息保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEvaluation(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String hse_evaluation_id = reqDTO.getValue("hse_evaluation_id");
		String isProject = reqDTO.getValue("isProject");
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		if (hse_evaluation_id == null || hse_evaluation_id.trim().equals("")) {// 新增操作
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			if(isProject.equals("2")){
				map.put("project_info_no", user.getProjectInfoNo());
			}
		}
		System.out.println(map);
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_hse_evaluation");
		msg.setValue("hse_evaluation_id", id);
		return msg;
	}
	/**
	 * 员工能力评价 --> 基本信息
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getEvaluationDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String hse_evaluation_id = reqDTO.getValue("hse_evaluation_id");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.hse_evaluation_id ,t.second_org ,inf1.org_abbreviation second_name ,t.third_org ,")
		.append(" inf2.org_abbreviation third_name ,t.fourth_org ,inf3.org_abbreviation fourth_name, ")
		.append(" t.evaluation_type ,t.appraiser ,to_char(t.evaluation_date, 'yyyy-MM-dd') evaluation_date ")
		.append(" from bgp_hse_evaluation t")
		.append(" left join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id  and sub1.bsflag = '0'")
		.append(" left join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag = '0' ")
		.append(" left join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag = '0' ")
		.append(" left join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag = '0' ")
		.append(" left join comm_org_subjection sub3 on t.fourth_org = sub3.org_subjection_id and sub3.bsflag = '0'")
		.append(" left join comm_org_information inf3 on sub3.org_id = inf3.org_id and inf3.bsflag = '0' ")
		.append(" where t.bsflag = '0' and t.hse_evaluation_id ='").append(hse_evaluation_id).append("'");
		System.out.println(sb.toString());
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("hse_evaluation_id", hse_evaluation_id);
		msg.setValue("evaluationMap", map);
		return msg;
	}
	/**
	 * 员工能力评价 --> 员工能力保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEvaluationStaff(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String sqls = reqDTO.getValue("sql");
		System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
		
		
		
//		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
//		UserToken user = reqDTO.getUserToken();
//		
//		
//		String duty_id = reqDTO.getValue("duty_id");
//		String ids[] =  duty_id.split(",");
//		
//		for(int i=0;i<ids.length;i++){
//			String sql = "update bgp_hse_duty_book t set t.bsflag ='1' where duty_id='"+ids[i]+"'";
//			jdbcTemplate.execute(sql);
//		}
		
		
//		String sqls = reqDTO.getValue("sql");
//		System.out.println(sqls);
//		String sql[] = sqls.split(";");
//		for(int i=0 ;i<sql.length;i++){
//			jdbcTemplate.execute(sql[i]);
//		}
		
		return msg;
	}
	/**
	 * 员工能力评价 --> 员工能力信息列表
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getEvaluationStaff(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String hse_evaluation_id = reqDTO.getValue("hse_evaluation_id");
		StringBuffer sb = new StringBuffer();
		sb.append("select s.hse_evaluation_staff ,s.staff_org ,s.staff_name ,s.staff_position ,s.staff_health ,")
		.append(" s.constraindication ,s.degrees ,s.work_experience ,s.interview ,s.qualification ,s.exam , ")
		.append(" s.subversion ,s.work_ethic ,s.emergency_power ,s.competent ,t.evaluation_date ,t.appraiser ")
		.append(" from bgp_hse_evaluation t")
		.append(" left join bgp_hse_evaluation_staff s on t.hse_evaluation_id = s.hse_evaluation_id and s.bsflag='0'")
		.append(" where t.bsflag='0' ")
		.append(" and t.hse_evaluation_id ='").append(hse_evaluation_id).append("'");
		System.out.println(sb.toString());
		List list = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("hse_evaluation_id", hse_evaluation_id);
		msg.setValue("datas", list);
		return msg;
	}
	/**
	 * 属地划分 --> 列表
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getApanageList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String subjection_id = reqDTO.getValue("subjection_id");
		if(subjection_id ==null || subjection_id.trim().equals("")){
			subjection_id = "null";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select rownum,rr.* from (select t.* from (select t.apanage_id,t.org_id ,t.org_subjection_id ,t.org_name ,")
		.append("sum(t.fixed_sum) fixed_sum ,sum(t.fixed_human) fixed_human ,sum(t.fixed_equipment) fixed_equipment , ")
		.append(" sum(t.fixed_danger) fixed_danger ,sum(t.flow_sum) flow_sum , sum(t.flow_human) flow_human ,")
		.append(" sum(t.flow_equipment) flow_equipment ,sum(t.flow_danger) flow_danger from( ")
		.append(" select '' apanage_id,inf.org_id ,o.org_sub_id org_subjection_id ,inf.org_abbreviation org_name ,t.fixed_sum , ")
		.append(" t.fixed_human ,t.fixed_equipment ,t.fixed_danger ,t.flow_sum ,t.flow_human ,t.flow_equipment ,t.flow_danger")
		.append(" from bgp_hse_org o")
		.append(" join comm_org_subjection sub on o.org_sub_id = sub.org_subjection_id and sub.bsflag='0'")
		.append(" join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag='0'")
		.append(" left join (select sum(t.fixed_sum) fixed_sum , sum(t.fixed_human) fixed_human ,")
		.append(" sum(t.fixed_equipment) fixed_equipment ,sum(t.fixed_danger) fixed_danger ,sum(t.flow_sum) flow_sum ,")
		.append(" sum(t.flow_human) flow_human ,sum(t.flow_equipment) flow_equipment ,sum(t.flow_danger) flow_danger ,")
		.append(" org.father_org_sub_id ,org.org_sub_id from bgp_hse_apanage t")
		.append(" join bgp_hse_org org on t.org_subjection_id = org.org_sub_id")
		.append(" where t.bsflag ='0' group by org.father_org_sub_id ,org.org_sub_id) t on  t.org_sub_id like concat(o.org_sub_id,'%')")
		.append(" where o.apanage_flag ='1' and o.father_org_sub_id ='").append(subjection_id)
		//.append(" where (o.org_sub_id ='").append(subjection_id).append("' or o.father_org_sub_id ='").append(subjection_id)
		.append("' and o.org_sub_id!='C105' ) t group by t.apanage_id ,t.org_id ,t.org_subjection_id ,t.org_name ) t join bgp_hse_org oo on oo.org_sub_id=t.org_subjection_id  order by oo.order_num asc ) rr");
		//.append(" where o.father_org_sub_id ='").append(subjection_id).append("' order by rownum ");
		String sql = "select t.org_sub_id,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		//判断是否还有子节点
		List listFather = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		
//		if(list!=null &&(list.size()==2 || list.size()==3)){
		if((list!=null && list.size()==2)||listFather.size()==0){
			sb = new StringBuffer();
			sb.append("select rownum ,t.apanage_id ,inf.org_id ,o.org_sub_id org_subjection_id,inf.org_abbreviation org_name ,t.fixed_sum ,")
			.append(" t.fixed_human ,t.fixed_equipment ,t.fixed_danger ,t.flow_sum ,t.flow_human ,t.flow_equipment ,t.flow_danger  ")
			.append(" from bgp_hse_org o ")
			.append(" join comm_org_subjection sub on o.org_sub_id = sub.org_subjection_id and sub.bsflag='0'")
			.append(" join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag='0'")
			.append(" left join bgp_hse_apanage t on inf.org_id = t.org_id and t.org_subjection_id = sub.org_subjection_id and t.bsflag='0'")
			//.append(" where o.father_org_sub_id ='").append(subjection_id).append("' order by rownum ");
			//.append(" where o.org_sub_id ='").append(subjection_id).append("' or o.father_org_sub_id ='").append(subjection_id).append("' order by rownum ");
			.append(" where o.apanage_flag ='1' and o.org_sub_id ='").append(subjection_id).append("' order by rownum ");
		}
		
		//物探处可以直接修改小队的数据
		if((list!=null && list.size()==1)||listFather.size()==0){
			sb = new StringBuffer();
			sb.append("select rownum, rr.* from (select t.* from (select t.apanage_id, inf.org_id, o.org_sub_id org_subjection_id, ") 
			.append("inf.org_abbreviation org_name, t.fixed_sum, t.fixed_human, t.fixed_equipment, t.fixed_danger, t.flow_sum, t.flow_human, " )
			.append("t.flow_equipment, t.flow_danger from bgp_hse_org o join comm_org_subjection sub on o.org_sub_id = sub.org_subjection_id " )
			.append("and sub.bsflag = '0' join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag = '0' left join " )
			.append("(select t.apanage_id, t.fixed_sum, t.fixed_human, t.fixed_equipment, t.fixed_danger, t.flow_sum, t.flow_human, " )
			.append("t.flow_equipment, t.flow_danger, org.father_org_sub_id, org.org_sub_id from bgp_hse_apanage t join bgp_hse_org org " )
			.append("on t.org_subjection_id = org.org_sub_id where t.bsflag = '0' ) t on t.org_sub_id like concat(o.org_sub_id, '%') " )
			.append("where o.apanage_flag = '1' and o.father_org_sub_id = '").append(subjection_id).append("' and o.org_sub_id != 'C105') t join bgp_hse_org oo " )
			.append("on oo.org_sub_id = t.org_subjection_id order by oo.order_num asc,oo.org_sub_id asc) rr");
		}
		
		System.out.println(sb.toString());
		List aList = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("datas", aList);
		return msg;
	}
	/**
	 * 属地划分 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveApanage(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String sqls = reqDTO.getValue("sql");
		System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
		return msg;
	}
	/**
	 * 属地划分 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getApanageSum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String subjection_id = reqDTO.getValue("subjection_id");
		if(subjection_id ==null || subjection_id.trim().equals("")){
			subjection_id = "null";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select sum(t.layer_sum-(-t.fixed_sum)-(-t.flow_sum)) num , sum(t.layer_human-(-t.fixed_human)-(-t.flow_human)) human ,")
		.append(" sum(t.layer_equipment-(-t.fixed_equipment)-(-t.flow_equipment)) equipment ,sum(t.layer_danger-(-t.fixed_danger)-(-t.flow_danger)) danger")
		.append(" from bgp_hse_apanage t")
		.append(" join bgp_hse_org org on t.org_subjection_id = org.org_sub_id ")
		.append("  where t.bsflag ='0' and org.org_sub_id like'").append(subjection_id).append("%'");
		//.append("  where t.bsflag ='0' and org.father_org_sub_id like'").append(subjection_id).append("%'");
		System.out.println(sb.toString());
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("data", map);
		return msg;
	}
	
	/**
	 * 属地划分 --> 设置哪些单位需要填写属地划分
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg setApanageFlag(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String rootMenuId = isrvmsg.getValue("rootMenuId");
		String ids = isrvmsg.getValue("ids");
		
		String sqlDelete = "update bgp_hse_org set apanage_flag ='' where org_sub_id like '"+rootMenuId+"%'";
		jdbcTemplate.execute(sqlDelete);
		
		String[] org_sub_ids = ids.split(",");
		for(int i=0;i<org_sub_ids.length;i++){
			String sql = "update bgp_hse_org set apanage_flag ='1' where org_sub_id='"+org_sub_ids[i]+"'";
			jdbcTemplate.execute(sql);
		}
		
		String sql2 = "update bgp_hse_org set apanage_flag ='1' where org_sub_id='"+rootMenuId+"'";
		jdbcTemplate.execute(sql2);

		return responseDTO;
	}
	/**
	 * HSE责任书 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDutyBook(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String duty_id = reqDTO.getValue("duty_id");
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");
		map.put("project_info_no", user.getProjectInfoNo());
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		if (duty_id == null || duty_id.trim().equals("")) {// 新增操作
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_hse_duty_book");
		msg.setValue("duty_id", id);
		return msg;
	}
	/**
	 * HSE责任书 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDutyBookDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String duty_id = reqDTO.getValue("duty_id");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.duty_id ,t.second_org ,inf1.org_abbreviation second_name ,t.third_org ,")
		.append(" inf2.org_abbreviation third_name  ,t.fourth_org ,inf3.org_abbreviation fourth_name , ")
		.append(" t.duty_year ,t.task ,t.duty_module ,t.master_num ,t.employee_num ")
		.append(" from bgp_hse_duty_book t")
		.append(" left join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id  and sub1.bsflag = '0'")
		.append(" left join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag = '0' ")
		.append(" left join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag = '0' ")
		.append(" left join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag = '0' ")
		.append(" left join comm_org_subjection sub3 on t.fourth_org = sub3.org_subjection_id and sub3.bsflag = '0'")
		.append(" left join comm_org_information inf3 on sub3.org_id = inf3.org_id and inf3.bsflag = '0' ")
		.append(" where t.duty_id ='").append(duty_id).append("'");
		System.out.println(sb.toString());
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("duty_id", duty_id);
		msg.setValue("dutyMap", map);
		return msg;
	}
	/**
	 *  HSE责任书 --> 列表
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg dutyBookSummary(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String subjection_id = reqDTO.getValue("subjection_id");
		if(subjection_id ==null || subjection_id.trim().equals("")){
			subjection_id = "null";
		}
		String year = reqDTO.getValue("year");
		if(year ==null || year.trim().equals("")){
			year = "null";
		}
		StringBuffer sb = new StringBuffer();
		sb = new StringBuffer();
		sb.append("select rownum,rr.* from (select inf.org_id ,o.org_sub_id org_subjection_id ,inf.org_abbreviation org_name ,")
		.append(" master_1 ,master_2 ,master_3 ,master_4 ,master_5 ,employee_1 ,employee_2 ,employee_3 ,")
		.append(" employee_4 ,employee_5 ,task_master_1 ,task_master_2 ,task_master_3 ,task_employee_1 ,")
		.append(" task_employee_2 ,task_employee_3 from bgp_hse_org o")
		.append(" join comm_org_subjection sub on o.org_sub_id = sub.org_subjection_id and sub.bsflag='0'")
		.append(" join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag='0'")
		.append(" left join (select sum(case t.task when '1' then t.master_num end ) master_1 ,")
		.append(" sum(case t.task when '2' then t.master_num end ) master_2 ,sum(case t.task when '3' then t.master_num end ) master_3 ,")
		.append(" sum(case t.task when '4' then t.master_num end ) master_4 ,sum(case t.task when '5' then t.master_num end ) master_5 , ")
		.append(" sum(case t.task when '1' then t.employee_num end ) employee_1 ,sum(case t.task when '2' then t.employee_num end ) employee_2 ,")
		.append(" sum(case t.task when '3' then t.employee_num end ) employee_3 ,sum(case t.task when '4' then t.employee_num end ) employee_4 ,")
		.append(" sum(case t.task when '5' then t.employee_num end ) employee_5 ,sum(case t.duty_module when '1' then t.master_num end ) task_master_1 ,")
		.append(" sum(case t.duty_module when '2' then t.master_num end ) task_master_2 ,sum(case t.duty_module when '3' then t.master_num end ) task_master_3 ,")
		.append(" sum(case t.duty_module when '1' then t.employee_num end ) task_employee_1 ,sum(case t.duty_module when '2' then t.employee_num end ) task_employee_2 ,")
		.append(" sum(case t.duty_module when '3' then t.employee_num end ) task_employee_3 ,org.org_sub_id from bgp_hse_duty_book t ");
		
		String sql = "select t.org_sub_id,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		int size = getSubjectionChild(subjection_id);
		if(list!=null){
			int len = list.size();
			if(len<1){
				sb.append(" join bgp_hse_org org on t.second_org = org.org_sub_id");
			}
			if(len==1){
				if(size>0){
					sb.append(" join bgp_hse_org org on t.third_org = org.org_sub_id");
				}else{
					sb.append(" join bgp_hse_org org on t.second_org = org.org_sub_id");
				}
			}
			if(len>=2){
				if(size>0){
					sb.append(" join bgp_hse_org org on t.fourth_org = org.org_sub_id");
				}else{
					sb.append(" join bgp_hse_org org on t.third_org = org.org_sub_id");
				}
			}
		}else{
			sb.append(" join bgp_hse_org org on t.second_org = org.org_sub_id");
		}
		System.out.println("size="+list.size());
		sb.append(" where t.bsflag ='0' and t.duty_year ='").append(year).append("'group by org.org_sub_id ) t on  t.org_sub_id like concat(o.org_sub_id,'%')");
		
		sql = "select * from bgp_hse_org t where t.father_org_sub_id ='"+subjection_id+"'";
		if(size>=1){
			sb.append(" where o.father_org_sub_id='").append(subjection_id).append("' ");
		}else{
			sb.append(" where o.org_sub_id ='").append(subjection_id).append("' ");
		}
		sb.append(" and o.org_sub_id !='C105' order by o.order_num) rr");
		System.out.println(sb.toString());
		List aList = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("datas", aList);
		sb = new StringBuffer();
		sb.append("select sum(case t.task when '1' then t.master_num -(-t.employee_num) end ) module_1 ,sum(case t.task when '2' then t.master_num-(-t.employee_num) end ) module_2 ,")
		.append(" sum(case t.task when '3' then t.master_num-(-t.employee_num) end ) module_3 ,sum(case t.task when '4' then t.master_num-(-t.employee_num) end ) module_4 ,")
		.append(" sum(case t.task when '5' then t.master_num-(-t.employee_num) end ) module_5 ,sum(case t.duty_module when '1' then t.master_num-(-t.employee_num) end ) task_1 ,")
		.append(" sum(case t.duty_module when '2' then t.master_num-(-t.employee_num) end ) task_2 ,sum(case t.duty_module when '3' then t.master_num-(-t.employee_num) end ) task_3")
		.append(" from bgp_hse_duty_book t  join bgp_hse_org org on t.fourth_org = org.org_sub_id ")
		.append(" where t.bsflag ='0' and t.duty_year ='").append(year).append("' and org.father_org_sub_id like'").append(subjection_id).append("%'");
		System.out.println(sb.toString());
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("data", map);
		return msg;
	}
	public int getSubjectionChild(String subjection_id){
		String sql = "select * from bgp_hse_org t where t.father_org_sub_id ='"+subjection_id+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		return list.size();
	}
	/**
	 * 操作规程和指南 --> 列表
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOperationRules(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String rules_id = reqDTO.getValue("rules_id");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.rules_id ,t.second_org ,inf1.org_abbreviation second_name ,t.third_org ,inf2.org_abbreviation third_name ,")
		.append(" t.rules_analy_date ,t.rules_check_date ,t.analysis_code ,t.analysis_date ,t.analysis_depart ,t.analysis_describe , ")
		.append(" t.analysis_type ,t.analysis_employee ,t.analysis_licence ,t.analysis_task ,t.evaluate_name ,t.evaluate_class ,")
		.append(" t.evaluate_opearater ,t.evaluate_discuss ,t.evaluate_defend ,t.defend_describe ,t.evaluate_get ,t.get_describe ,")
		.append(" t.evaluate_suit ,t.suit_describe ,t.evaluate_ask ,t.ask_describe ,t.operation ,t.operation_describe ,t.evaluate_suggestion ,")
		.append(" t.evaluate_present ,t.evaluate_fill ,t.evaluate_audit ,t.evaluate_date ,t.history_class ,t.history_date")
		.append(" from bgp_hse_operation_rules t")
		.append(" join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id  and sub1.bsflag = '0'")
		.append(" join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag = '0' ")
		.append(" join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag = '0' ")
		.append(" join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag = '0' ")
		.append(" where t.bsflag ='0' and t.rules_id ='").append(rules_id).append("'");
		System.out.println(sb.toString());
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("data", map);
		return msg;
	}
	/**
	 * 操作规程和指南 --> 保存、获得rules_id
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOperationRules(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String rules_id = reqDTO.getValue("rules_id");
		String isProject = reqDTO.getValue("isProject");
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");
		
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		if (rules_id == null || rules_id.trim().equals("")) {// 新增操作
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			if(isProject.equals("2")){
				map.put("project_info_no", user.getProjectInfoNo());
			}
		}
		System.out.println(map);
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_hse_operation_rules");
		msg.setValue("rules_id", id);
		return msg;
	}
	/**
	 * 操作规程和指南 --> 列表
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTablesList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String rules_id = reqDTO.getValue("rules_id");
		if(rules_id ==null || rules_id.trim().equals("")){
			rules_id = "null";
		}
		StringBuffer sb = new StringBuffer();
		sb = new StringBuffer();
		sb.append("select t.analysis_id ,t.rules_id ,t.work_step ,t.danger ,t.aftermath ,t.control_step ,")
		.append(" t.possibility ,t.ponderance ,t.riskiness ,t.improve_step ,t.results ")
		.append(" from bgp_hse_operation_analysis t")
		.append(" where t.bsflag='0' and t.rules_id ='").append(rules_id).append("'");
		System.out.println(sb.toString());
		List aList = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("analysisList", aList);
		
		sb = new StringBuffer();
		sb.append("select t.evaluate_id ,t.rules_id ,t.operation_step ,t.key_point ,t.fault_risk")
		.append(" from bgp_hse_operation_evaluate t")
		.append(" where t.bsflag='0' and t.rules_id ='").append(rules_id).append("'");
		System.out.println(sb.toString());
		List eList = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("evaluate1List", eList);
		
		sb = new StringBuffer();
		sb.append("select t.suggest_id ,t.rules_id ,t.suggestion ,t.introducer ")
		.append(" from bgp_hse_operation_evaluates t")
		.append(" where t.bsflag='0' and t.rules_id ='").append(rules_id).append("'");
		System.out.println(sb.toString());
		List sList = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("evaluate2List", sList);
		
		sb = new StringBuffer();
		sb.append("select t.history_id ,t.rules_id ,t.operation_staff ,t.program ,t.execute_date ,t.execute_result ,t.note")
		.append(" from bgp_hse_operation_history t")
		.append(" where t.bsflag='0' and t.rules_id ='").append(rules_id).append("'");
		System.out.println(sb.toString());
		List hList = pureJdbcDao.queryRecords(sb.toString());
		msg.setValue("historyList", hList);
		return msg;
	}
	/**
	 * 不符合通知单包括新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "unchecked", "rawtypes" })
	public ISrvMsg getHseOrderInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String keyId = reqDTO.getValue("id");
 
		// 申请表主键

		if (keyId != null || keyId !=""){		 
			// 查询主表信息
			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(
					" select   ion.org_name, hor.verifier_signature, hor.project_no,hor.order_no,hor.audit_unit,hor.audit_date ,hor.amonth,hor.aday,hor.reporter,hor.client,hor.validation_situation,hor.verify_date,hor.inspection_team,hor.person_charge,hor.creator,hor.create_date,hor.updator,hor.modifi_date,hor.bsflag  from  BGP_NOACCORDWITH_ORDER hor  join comm_org_subjection os1     on hor.audit_unit = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id    where hor.bsflag='0' ");
			sb.append(" and hor.order_no='").append(keyId).append("' ");

			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);
		 
			// 查询子表信息
			StringBuffer subsql = new StringBuffer(
					"select order_detail_no,order_no,no_conformity,no_conform_num,suggestions,period,creator,create_date,updator,modifi_date,bsflag,spare1  from  BGP_HSE_ORDER_DETAIL  where bsflag='0' ");

			subsql.append("  and order_no='").append(
					keyId).append("' order by  modifi_date  desc ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(
					subsql.toString());
			responseDTO.setValue("detailInfo", list);

		}
 
		return responseDTO;
	}

	public ISrvMsg saveHseOrder(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map mapInfo = null;
		HseOperation applyInfo = new HseOperation();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);
		String projectInfoNo = user.getProjectInfoNo();
		if (projectInfoNo == null || projectInfoNo.equals("")){
			projectInfoNo = "";
		}
		// 申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("order_no") == null) {// 新增操作
			mapInfo.put("bsflag", "0");
			mapInfo.put("project_no",projectInfoNo);
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
					mapInfo, "BGP_NOACCORDWITH_ORDER");
			infoKeyValue = id.toString();
		} else {// 修改或审核操作
 
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"BGP_NOACCORDWITH_ORDER");
			infoKeyValue = (String) mapInfo.get("order_no");
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));
 System.out.println("equipmentSize"+equipmentSize);
		Map mapDetail = new HashMap();
		// 存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {

			HseOperationDetail applyDetail = new HseOperationDetail();
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					applyDetail);
			mapDetail = PropertiesUtil.describe(applyDetail);
 
			if (mapInfo.get("order_no") == null) {			 
				mapDetail.put("order_no", infoKeyValue);
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modify_date", new Date());
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"BGP_HSE_ORDER_DETAIL");

			} else {

			 
				mapDetail.put("order_no", infoKeyValue);
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modify_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"BGP_HSE_ORDER_DETAIL");
			}

		}

		return responseDTO;
	}
	
	
	/*
	 * 危害因素大类
	 */
	public ISrvMsg queryHazardBig(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("SELECT t.coding_code_id AS value, t.coding_name AS label  FROM comm_coding_sort_detail t where t.coding_sort_id = '5110000032'   and t.bsflag = '0'   and t.SUPERIOR_CODE_ID='0'   and length(t.coding_code) <= 2  order by  t.coding_show_id desc  ");
 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);  
		return responseDTO;
	}
	/*
	 * 危害因素中类
	 */
	public ISrvMsg queryHazardCenter(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		String hazardBig = reqDTO.getValue("hazardBig");
		
		StringBuffer sb = new StringBuffer(" SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t  ");
		sb.append("  where t.SUPERIOR_CODE_ID like  '").append(hazardBig).append("%' and t.bsflag='0'  ");
	 		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	
	/*
	 * 设备设施类别大类
	 */
	public ISrvMsg queryeQuipmentOne(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("SELECT t.coding_code_id AS value, t.coding_name AS label  FROM comm_coding_sort_detail t where t.coding_sort_id = '5110000039'   and t.bsflag = '0'   and t.SUPERIOR_CODE_ID='0'   and length(t.coding_code) <= 2");
 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);  
		return responseDTO;
	}
	
	/*
	 * hse隐患风险级别
	 */
	public ISrvMsg queryRiskLevels(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("SELECT t.coding_code_id AS value, t.coding_name AS label  FROM comm_coding_sort_detail t where t.coding_sort_id = '5110000132'   and t.bsflag = '0'   and t.SUPERIOR_CODE_ID='0'   and length(t.coding_code) <= 2  order by  t.coding_show_id   ");
 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);  
		return responseDTO;
	}
	
	
	/*
	 * 设备设施类别中类
	 */
	public ISrvMsg queryQuipmentTwo(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		String hazardBig = reqDTO.getValue("equipmentOne"); 
		StringBuffer sb = new StringBuffer(" SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t  ");
		sb.append("  where t.SUPERIOR_CODE_ID like  '").append(hazardBig).append("%' and t.bsflag='0'  ");
	 		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	
	
	/**
	 * 审核定级评分修改页面显示信息testtest
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg editAuditList(ISrvMsg reqDTO) throws Exception {
		System.out.println("审核定级评分查询");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String auditlist_id=reqDTO.getValue("auditlist_id"); 
		if(auditlist_id !=null){	 
				Map map = new HashMap();
			StringBuffer sb = new StringBuffer(
					" select  tr.auditlist_id,tr.audit_level,tr.audit_personnel,tr.audit_time,tr.auditlist_level ,tr.sum_standard_score, tr.sum_factor_score,tr.sum_individual_score,tr.sum_actual_score,tr.sum_comprehensive_score,ion.org_name,tr.creator,tr.create_date,tr.org_sub_id,tr.bsflag,tr.second_org,tr.third_org ,oi1.org_abbreviation as second_org_name,  oi2.org_abbreviation as third_org_name  from   BGP_HSE_AUDITLISTS  tr    join comm_org_subjection os1      on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  join comm_org_information oi1     on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'       join comm_org_information ion  on ion.org_id=os1.org_id      where   tr.bsflag='0' ");
			sb.append(" and tr.auditlist_id='").append(auditlist_id).append("' ");
	        map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString()); 
	     
	        StringBuffer sbAudit = new StringBuffer(
			"	 select ad.elements,  ad.one_no ,ad.auditlist_id, ad.factor_score ,  ad.actual_score ,ad.comprehensive_score,ad.creator,ad.create_date  from  BGP_AUDITLISTS_ONE ad join  BGP_HSE_AUDITLISTS tr on tr.auditlist_id=ad.auditlist_id and tr.bsflag='0' where ad.bsflag='0' ");
	        sbAudit.append("  and ad.auditlist_id='").append(auditlist_id).append("'  order by ad.elements ");
	        List subList = BeanFactory.getQueryJdbcDAO().queryRecords(
					sbAudit.toString());
			if (subList != null && subList.size() > 0) {
				for(int i = 0;i < subList.size();i++){
				Map oneList = (Map)subList.get(i);
				String oneNO = (String)oneList.get("oneNo");
					
				  StringBuffer sbAuditTwo = new StringBuffer(
					"	 select    ad.two_no,ad.one_no,ad.individual_score,ad.standard_scor ,ad.audit_content,ad.creator,ad.create_date  from  BGP_AUDITLISTS_TWO ad join  BGP_AUDITLISTS_ONE  tr on tr.one_no=ad.one_no and tr.bsflag='0' where ad.bsflag='0' ");
				  sbAuditTwo.append("  and ad.one_no='").append(oneNO).append("'  order by ad.audit_content ");
			        List subListTwo = BeanFactory.getQueryJdbcDAO().queryRecords(sbAuditTwo.toString());
				   System.out.println(subListTwo.size());
				
				}
				 
				responseDTO.setValue("subList", subList);
				
				
			} 
	    responseDTO.setValue("auditlistId", auditlist_id);
		responseDTO.setValue("applyInfo", map);
		}
		return responseDTO;
	}
	
public ISrvMsg saveProjectDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		 //  org_subjection_id   father_id  file   fileUrl		   
		String org_subjection_id = reqDTO.getValue("org_subjection_id");
		String creatorId = reqDTO.getValue("creatorId");
		String fatherId = reqDTO.getValue("father_id");
		String fileName = "hse机关结构图";
		String ucmId = reqDTO.getValue("ucmId");
		String fileId = reqDTO.getValue("fileId");
		String org_type = reqDTO.getValue("org_type");

		Map mapDetail = new HashMap(); 
		mapDetail.put("creator_id", creatorId);
		mapDetail.put("create_date", new Date());
		mapDetail.put("modifi_date", new Date());
		mapDetail.put("file_name", fileName);
		mapDetail.put("bsflag", "0");
		mapDetail.put("spare1", "0");
		mapDetail.put("org_id", fatherId);
		mapDetail.put("org_type", org_type);		
		mapDetail.put("org_subjection_id", org_subjection_id);
		//主键存不为空修改，为空新增
		if(fileId!=null && !"".equals(fileId)){
			mapDetail.put("pmain_id", fileId);
			mapDetail.put("updator_id", user.getUserName());		
			mapDetail.put("spare1", "0");
		}
		 
		MyUcm ucm = new MyUcm();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String documentId = "";
		if(fileList!= null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
			mapDetail.put("ucm_id", documentId);			
			if(ucmId!=null && !"".equals(ucmId)){
				ucm.deleteFile(ucmId);
				
				String update =" update BGP_HSE_PICTURE_MAIN set bsflag='1' where ucm_id='"+ucmId+"'";
				jdbcDao.getJdbcTemplate().update(update);
			} 
		}
		 
		String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"BGP_HSE_PICTURE_MAIN").toString();
  
		return responseDTO;
	}
	
public ISrvMsg saveProjectDocA(ISrvMsg reqDTO) throws Exception {
	
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
	UserToken user = reqDTO.getUserToken();   
	String org_subjection_id = reqDTO.getValue("org_subjection_idA");
	String creatorId = reqDTO.getValue("creatorIdA");
	String fatherId = reqDTO.getValue("father_idA");
	String fileName = "hse单位结构图";
	String ucmId = reqDTO.getValue("ucmIdA");
	String fileId = reqDTO.getValue("fileIdA");
	String org_type = reqDTO.getValue("org_typeA");
	String mainId = reqDTO.getValue("mainIdA");
	String org_sub_id = reqDTO.getValue("org_sub_idA");
	String second_org = reqDTO.getValue("second_orgA");
	
	
	Map mapDetail = new HashMap(); 
	mapDetail.put("creator_id", creatorId);
	mapDetail.put("create_date", new Date());
	mapDetail.put("modifi_date", new Date());
	mapDetail.put("file_name", fileName);
	mapDetail.put("bsflag", "0");
	mapDetail.put("spare1", "1");
	mapDetail.put("spare2", mainId);
	mapDetail.put("org_id", fatherId);
	mapDetail.put("org_type", org_type);		
	mapDetail.put("org_subjection_id", org_subjection_id);
	//主键存不为空修改，为空新增
	if(fileId!=null && !"".equals(fileId)){
		mapDetail.put("pmain_id", fileId);
		mapDetail.put("updator_id", user.getUserName());		
	}
	 
	MyUcm ucm = new MyUcm();
	MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
	List<WSFile> fileList = mqMsg.getFiles();
	String documentId = "";
	if(fileList!= null && fileList.size()>0){
		WSFile fs = fileList.get(0);
		documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
		mapDetail.put("ucm_id", documentId);			
		if(ucmId!=null && !"".equals(ucmId)){
			ucm.deleteFile(ucmId);
			
			String update =" update BGP_HSE_PICTURE_MAIN set bsflag='1' where ucm_id='"+ucmId+"'";
			jdbcDao.getJdbcTemplate().update(update);
		} 
	}
	 
	String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"BGP_HSE_PICTURE_MAIN").toString();
	responseDTO.setValue("doc_main_id", doc_pk_id);
	return responseDTO;
}


public ISrvMsg saveProjectDocB(ISrvMsg reqDTO) throws Exception {
	
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
	UserToken user = reqDTO.getUserToken();   
	String org_subjection_id = reqDTO.getValue("org_subjection_idB");
	String creatorId = reqDTO.getValue("creatorIdB");
	String fatherId = reqDTO.getValue("father_idB");
	String fileName = "hse基层单位结构图";
	String ucmId = reqDTO.getValue("ucmIdB");
	String fileId = reqDTO.getValue("fileIdB");
	String org_type = reqDTO.getValue("org_typeB");
	String mainId = reqDTO.getValue("mainIdB");
	String org_sub_id = reqDTO.getValue("org_sub_idB");
	String second_org = reqDTO.getValue("second_orgB");
	
	
	Map mapDetail = new HashMap(); 
	mapDetail.put("creator_id", creatorId);
	mapDetail.put("create_date", new Date());
	mapDetail.put("modifi_date", new Date());
	mapDetail.put("file_name", fileName);	
	mapDetail.put("org_sub_id", org_sub_id);
	mapDetail.put("second_org", second_org);	
	mapDetail.put("bsflag", "0");
	mapDetail.put("pmain_id", mainId);
	mapDetail.put("org_id", fatherId);
	mapDetail.put("org_type", org_type);		
	mapDetail.put("org_subjection_id", org_subjection_id);
	//主键存不为空修改，为空新增
	if(fileId!=null && !"".equals(fileId)){
		mapDetail.put("mdetail_id", fileId);
		mapDetail.put("updator_id", user.getUserName());		
	}
	 
	MyUcm ucm = new MyUcm();
	MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
	List<WSFile> fileList = mqMsg.getFiles();
	String documentId = "";
	if(fileList!= null && fileList.size()>0){
		WSFile fs = fileList.get(0);
		documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
		mapDetail.put("ucm_id", documentId);			
		if(ucmId!=null && !"".equals(ucmId)){
			ucm.deleteFile(ucmId);
			
			String update =" update BGP_HSE_PICTURE_MDETAIL set bsflag='1' where ucm_id='"+ucmId+"'";
			jdbcDao.getJdbcTemplate().update(update);
		} 
	}
	 
	String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"BGP_HSE_PICTURE_MDETAIL").toString();
	responseDTO.setValue("doc_main_id", doc_pk_id);
	return responseDTO;
}



/*
 * 问题清单体系要素号
 */
public ISrvMsg queryElements(ISrvMsg reqDTO) throws Exception{
	ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO); 
	StringBuffer sb = new StringBuffer("SELECT t.coding_code_id AS value, t.coding_name AS label  FROM comm_coding_sort_detail t where t.coding_sort_id = '5110000047'   and t.bsflag = '0'   and t.SUPERIOR_CODE_ID='0'   and length(t.coding_code) <= 2 order by t.coding_show_id ");

	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
	responseDTO.setValue("detailInfo", list);  
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
					//employee_name，person_status，work_property，plate_property，safeflag，start_date
					
					String employee_name = "";
					String employee_code_id="";
					String person_status = "";
					String work_property = "";
					String plate_property = "";
					String safeflag = "";
					String start_date="";
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				
							case 3:
								ss.setCellType(1);
								work_property = ss.getStringCellValue().trim();
								tempMap.put("work_property", work_property);
								break; 
							case 4:
								ss.setCellType(1);
								plate_property = ss.getStringCellValue().trim();
								tempMap.put("plate_property", plate_property);
								break; 
							case 5:
								ss.setCellType(1);
								safeflag = ss.getStringCellValue().trim();
								tempMap.put("safeflag", safeflag);
								break;  
								
							case 6: 
								if(ss.getCellType()==0){
									start_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									start_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								start_date=start_date.replace("/", "-");
								String[] biths=start_date.split("-");
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
								System.out.println(temp);
								tempMap.put("start_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportMessage(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse管理人员批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportMessage (List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_PROFESSIONAL t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
		   
			String hse_professional_id = "";  
			String employee_name = (String) map.get("employee_name");
			String person_status =(String) map.get("person_status");
			String work_property = (String) map.get("work_property");
			String plate_property = (String) map.get("plate_property");
			String safeflag = (String) map.get("safeflag");
			String start_date=(String) map.get("start_date"); 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");

            String work_propertys="";
            String plate_propertys="";
            String safeflags="";
            
			if (work_property != null) {
				if (work_property.equals("专职")) {
					work_propertys = "1";
				} else if (work_property.equals("兼职")) {
					work_propertys = "2";
				} 
			} 
			
			if (plate_property != null) {
				if (plate_property.equals("野外一线")) {
					plate_propertys = "1";
				} else if (plate_property.equals("固定场所")) {
					plate_propertys = "2";
				} else if (plate_property.equals("科研单位")) {
					plate_propertys = "3";
				} else if (plate_property.equals("培训接待")) {
					plate_propertys = "4";
				} else if (plate_property.equals("矿区")) {
					plate_propertys = "5";
				} 
			} 
			  
			if (safeflag != null) {
				if (safeflag.equals("是")) {
					safeflags = "1";
				} else if (safeflag.equals("否")) {
					safeflags = "0";
				} 
			} 
			 
			
		  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_professional_id = tempmap.get("hseProfessionalId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_professional_id", hse_professional_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				tempMap.put("WORK_PROPERTY", work_propertys);
				tempMap.put("PLATE_PROPERTY", plate_propertys);
				tempMap.put("SAFEFLAG", safeflags);
				tempMap.put("START_DATE", start_date);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_PROFESSIONAL"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_professional_id", hse_professional_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				tempMap.put("WORK_PROPERTY", work_propertys);
				tempMap.put("PLATE_PROPERTY", plate_propertys);
				tempMap.put("SAFEFLAG", safeflags);
				tempMap.put("START_DATE", start_date);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_PROFESSIONAL"); // 保存
			}
		}
	}
}


/**
 * hse特种作业人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelSpecial(ISrvMsg reqDTO) throws Exception {
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
					//employee_name，person_status，work_type    certificate_name  certificate_org   check_date
					
					String employee_name = "";
					String employee_code_id="";   
					String person_status = "";
					String work_type = "";
					String certificate_name = "";
					String certificate_org = "";
					String check_date="";
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				
							case 3:
								ss.setCellType(1);
								work_type = ss.getStringCellValue().trim();
								tempMap.put("work_type", work_type);
								break; 
							case 4:
								ss.setCellType(1);
								certificate_name = ss.getStringCellValue().trim();
								tempMap.put("certificate_name", certificate_name);
								break; 
							case 5:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break;  
								
							case 6: 
								if(ss.getCellType()==0){
									check_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									check_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								check_date=check_date.replace("/", "-");
								String[] biths=check_date.split("-");
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
								System.out.println(temp);
								tempMap.put("check_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportSpecial(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse特种作业人员信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportSpecial(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_SPECIAL_WORK t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，person_status，work_type    certificate_name  certificate_org   check_date
			String hse_special_id = "";  
			String employee_name = (String) map.get("employee_name");
			String person_status =(String) map.get("person_status");
			String work_type = (String) map.get("work_type");
			String certificate_name = (String) map.get("certificate_name");
			String certificate_org = (String) map.get("certificate_org");
			String check_date=(String) map.get("check_date"); 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");

            
			
		  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_special_id = tempmap.get("hseSpecialId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_special_id", hse_special_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org); 
				
				tempMap.put("WORK_TYPE", work_type);
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_SPECIAL_WORK"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_special_id", hse_special_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				 
				tempMap.put("WORK_TYPE", work_type);
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_SPECIAL_WORK"); // 保存
			}
		}
	}
}

/**
 * hse医护人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelMedical(ISrvMsg reqDTO) throws Exception {
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
					//employee_name，person_status，work_type   certificate_name   certificate_num   certificate_org    check_date
					
					String employee_name = "";
					String employee_code_id="";   
					String person_status = "";
					String work_type = "";
					String certificate_name = "";
					String certificate_num = "";
					String certificate_org = "";
					String check_date="";
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <8; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				
							case 3:
								ss.setCellType(1);
								work_type = ss.getStringCellValue().trim();
								tempMap.put("work_type", work_type);
								break; 
							case 4:
								ss.setCellType(1);
								certificate_name = ss.getStringCellValue().trim();
								tempMap.put("certificate_name", certificate_name);
								break; 
							case 5:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break; 
								
							case 6:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break;  
								
							case 7: 
								if(ss.getCellType()==0){
									check_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									check_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								check_date=check_date.replace("/", "-");
								String[] biths=check_date.split("-");
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
								System.out.println(temp);
								tempMap.put("check_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportMedical(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse医护人员批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportMedical(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_MEDICAL t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，person_status，work_type    certificate_name  certificate_org   check_date
			String hse_medical_id = "";  
			String employee_name = (String) map.get("employee_name");
			String person_status =(String) map.get("person_status");
			String work_type = (String) map.get("work_type");
			String certificate_name = (String) map.get("certificate_name");
			String certificate_num = (String) map.get("certificate_num");
			String certificate_org = (String) map.get("certificate_org");
			String check_date=(String) map.get("check_date"); 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");

            
			
		  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_medical_id = tempmap.get("hseMedicalId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_medical_id", hse_medical_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org); 
				
				tempMap.put("WORK_TYPE", work_type);
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_MEDICAL"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_medical_id", hse_medical_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				 
				tempMap.put("WORK_TYPE", work_type);
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_MEDICAL"); // 保存
			}
		}
	}
}



/**
 * hse水域施工人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelWater(ISrvMsg reqDTO) throws Exception {
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
					//employee_name，person_status  certificate_flag   certificate_date   certificate_org   certificate_num
					
					String employee_name = "";
					String employee_code_id="";   
					
					String person_status = "";
					String certificate_flag = "";
					String certificate_date = "";
					String certificate_org = "";
					String certificate_num="";
					
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				
							case 3:
								ss.setCellType(1);
								certificate_flag = ss.getStringCellValue().trim();
								tempMap.put("certificate_flag", certificate_flag);
								break; 
								
							case 4: 
								if(ss.getCellType()==0){
									certificate_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									certificate_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								certificate_date=certificate_date.replace("/", "-");
								String[] biths=certificate_date.split("-");
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
								System.out.println(temp);
								tempMap.put("certificate_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
							case 5:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break; 
							case 6:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break;  
								  
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportWater(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse水域施工人员信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportWater(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_WATER t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，person_status  certificate_flag   certificate_date   certificate_org   certificate_num
			String hse_water_id = "";  
			String employee_name = (String) map.get("employee_name");
			
			String person_status = (String) map.get("person_status");
			String certificate_flag = (String) map.get("certificate_flag");
			String certificate_date = (String) map.get("certificate_date");
			String certificate_org = (String) map.get("certificate_org");
			String certificate_num=(String) map.get("certificate_num");
			
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");
			
			String certificate_flagD="";
			if (certificate_flag != null) {
				if (certificate_flag.equals("是")) {
					certificate_flagD = "1";
				} else if (certificate_flag.equals("否")) {
					certificate_flagD = "2";
				} 
			} 
			
		  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_water_id = tempmap.get("hseWaterId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_water_id", hse_water_id); 
				tempMap.put("employee_id", employeeId); 
				  
				tempMap.put("CERTIFICATE_FLAG", certificate_flagD);
				tempMap.put("CERTIFICATE_DATE", certificate_date);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_WATER"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_water_id", hse_water_id); 
				tempMap.put("employee_id", employeeId); 
 
				tempMap.put("CERTIFICATE_FLAG", certificate_flagD);
				tempMap.put("CERTIFICATE_DATE", certificate_date);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_WATER"); // 保存
			}
		}
	}
}


/**
 * hse驾驶人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelDriver(ISrvMsg reqDTO) throws Exception {
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
					//employee_name，person_status  danger_driver   special_driver  type_num  driver_date  doc_num 
					//driver_type  duty  inner_type   driving_num   driving_org   signer   sign_date   useful_life
					
					String employee_name = "";
					String employee_code_id="";  
					
					String person_status = "";
					String danger_driver = "";
					String special_driver = "";
					String type_num = "";
					String driver_date="";   //驾驶证初领日期
					
					String doc_num = "";
					String driver_type = "";
					String duty = "";
					String inner_type = "";
					String driving_num="";
					
					String driving_org = "";
					String signer = "";
					String sign_date = "";   //签发日期
					String useful_life = "";  //有效日期 
					
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <16; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
								//employee_name，person_status  danger_driver   special_driver  type_num  driver_date  doc_num 
								//driver_type  duty  inner_type   driving_num   driving_org   signer   sign_date   useful_life
								
								
							case 3:
								ss.setCellType(1);
								danger_driver = ss.getStringCellValue().trim();
								tempMap.put("danger_driver", danger_driver);
								break; 
								
							case 4:
								ss.setCellType(1);
								special_driver = ss.getStringCellValue().trim();
								tempMap.put("special_driver", special_driver);
								break; 
							case 5:
								ss.setCellType(1);
								type_num = ss.getStringCellValue().trim();
								tempMap.put("type_num", type_num);
								break; 
								
								
							case 6: 
								if(ss.getCellType()==0){
									driver_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									driver_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								driver_date=driver_date.replace("/", "-");
								String[] biths=driver_date.split("-");
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
								System.out.println(temp);
								tempMap.put("driver_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								
								
								
							case 7:
								ss.setCellType(1);
								doc_num = ss.getStringCellValue().trim();
								tempMap.put("doc_num", doc_num);
								break; 
							case 8:
								ss.setCellType(1);
								driver_type = ss.getStringCellValue().trim();
								tempMap.put("driver_type", driver_type);
								break; 
							case 9:
								ss.setCellType(1);
								duty = ss.getStringCellValue().trim();
								tempMap.put("duty", duty);
								break; 
								
								
						
							case 10:
								ss.setCellType(1);
								inner_type = ss.getStringCellValue().trim();
								tempMap.put("inner_type", inner_type);
								break; 
							case 11:
								ss.setCellType(1);
								driving_num = ss.getStringCellValue().trim();
								tempMap.put("driving_num", driving_num);
								break;  
								  
							case 12:
								ss.setCellType(1);
								driving_org = ss.getStringCellValue().trim();
								tempMap.put("driving_org", driving_org);
								break; 
							case 13:
								ss.setCellType(1);
								signer = ss.getStringCellValue().trim();
								tempMap.put("signer", signer);
								break; 
					 
								   
							case 14: 
								if(ss.getCellType()==0){
									sign_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									sign_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								sign_date=sign_date.replace("/", "-");
								String[] bithsSD=sign_date.split("-");
								String tempSD="";
								for(int i=0;i<bithsSD.length;i++){
									if(bithsSD[i].length()==1){
									bithsSD[i]="0"+bithsSD[i];
									}
									if(i==bithsSD.length-1){
										tempSD+=bithsSD[i];
									}else{
										tempSD+=bithsSD[i]+"-";
									}
									
								}
								System.out.println(tempSD);
								tempMap.put("sign_date",tempSD); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(tempSD);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								
							case 15: 
								if(ss.getCellType()==0){
									useful_life=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									useful_life = ss.getStringCellValue().trim(); // 对应赋值
								} 
								useful_life=useful_life.replace("/", "-");
								String[] bithsUL=useful_life.split("-");
								String tempUL="";
								for(int i=0;i<bithsUL.length;i++){
									if(bithsUL[i].length()==1){
									bithsUL[i]="0"+bithsUL[i];
									}
									if(i==bithsUL.length-1){
										tempUL+=bithsUL[i];
									}else{
										tempUL+=bithsUL[i]+"-";
									}
									
								}
								System.out.println(tempUL);
								tempMap.put("useful_life",tempUL); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(tempUL);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								  
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportDriver(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse驾驶人员信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportDriver(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_DRIVER t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，person_status  danger_driver   special_driver  type_num  driver_date  doc_num 
				//driver_type  duty  inner_type   driving_num   driving_org   signer   sign_date   useful_life
				
			String hse_driver_id = "";  
			String employee_name = (String) map.get("employee_name"); 
			
			String person_status = (String) map.get("person_status");
			String danger_driver =  (String) map.get("danger_driver");
			String special_driver = (String) map.get("special_driver");
			String type_num =  (String) map.get("type_num");
			String driver_date= (String) map.get("driver_date");   //驾驶证初领日期
			
			String doc_num =  (String) map.get("doc_num");
			String driver_type =  (String) map.get("driver_type");
			String duty =  (String) map.get("duty");
			String inner_type = (String) map.get("inner_type");
			String driving_num= (String) map.get("driving_num");
			
			String driving_org =  (String) map.get("driving_org");
			String signer =  (String) map.get("signer");
			String sign_date =  (String) map.get("sign_date");  //签发日期
			String useful_life =  (String) map.get("useful_life");  //有效日期 
			 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");
			 
			
			String danger_driverD="";
			String special_driverD  ="";
			String driver_typeD ="";
			String dutyD="";
			String inner_typeD="";
			 
			if (danger_driver != null) {
				if (danger_driver.equals("是")) {
					danger_driverD = "1";
				} else if (danger_driver.equals("否")) {
					danger_driverD = "2";
				} 
			} 
			
			if (special_driver != null) {
				if (special_driver.equals("是")) {
					special_driverD = "1";
				} else if (special_driver.equals("否")) {
					special_driverD = "2";
				} 
			} 
			
			if (driver_type != null) {
				if (driver_type.equals("甲")) {
					driver_typeD = "1";
				} else if (driver_type.equals("乙")) {
					driver_typeD = "2";
				}  else if (driver_type.equals("丙")) {
					driver_typeD = "3";
					} 
			} 
			if (duty != null) {
				if (duty.equals("处级")) {
					dutyD = "1";
				} else if (duty.equals("科级")) {
					dutyD = "2";
				}  else if (duty.equals("其他")) {
					dutyD = "3";
					} 
			} 
		  
		 
			 Map innerTypeMap = jdbcDao
				.queryRecordBySQL(" select  coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000033' and superior_code_id='0' and bsflag='0' and  coding_name like '"
						+ inner_type + "'");
		        if (innerTypeMap != null)
		        	inner_typeD= (String) innerTypeMap.get("coding_code_id");
		        
		        
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_driver_id = tempmap.get("hseDriverId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_driver_id", hse_driver_id); 
				tempMap.put("employee_id", employeeId); 
				  
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("DANGER_DRIVER", danger_driverD);
				tempMap.put("SPECIAL_DRIVER", special_driverD);
				tempMap.put("TYPE_NUM", type_num);
				tempMap.put("DRIVER_DATE", driver_date);
				tempMap.put("DOC_NUM", doc_num);
				tempMap.put("DRIVER_TYPE", driver_typeD);
				tempMap.put("DUTY", dutyD);
				tempMap.put("INNER_TYPE", inner_typeD);
				tempMap.put("DRIVING_NUM", driving_num);
				tempMap.put("DRIVING_ORG", driving_org);
				tempMap.put("SIGNER", signer);
				tempMap.put("SIGN_DATE", sign_date);
				tempMap.put("USEFUL_LIFE", useful_life);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_DRIVER"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_driver_id", hse_driver_id); 
				tempMap.put("employee_id", employeeId); 
			 
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("DANGER_DRIVER", danger_driverD);
				tempMap.put("SPECIAL_DRIVER", special_driverD);
				tempMap.put("TYPE_NUM", type_num);
				tempMap.put("DRIVER_DATE", driver_date);
				tempMap.put("DOC_NUM", doc_num);
				tempMap.put("DRIVER_TYPE", driver_typeD);
				tempMap.put("DUTY", dutyD);
				tempMap.put("INNER_TYPE", inner_typeD);
				tempMap.put("DRIVING_NUM", driving_num);
				tempMap.put("DRIVING_ORG", driving_org);
				tempMap.put("SIGNER", signer);
				tempMap.put("SIGN_DATE", sign_date);
				tempMap.put("USEFUL_LIFE", useful_life); 
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_DRIVER"); // 保存
			}
		}
	}
}

/**
 * hse应急人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelStrain(ISrvMsg reqDTO) throws Exception {
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
					//employee_name，person_status    strain_type  strain_duty  first_phone  
					//second_phone  expert_flag   expert_level   expert_field   expert_duty
					
					String employee_name = "";
					String employee_code_id="";   
					
					String person_status = "";
					String strain_type = "";
					String strain_duty = "";
					String first_phone = "";
					String second_phone="";
					String expert_flag="";
					String expert_level="";
					String expert_field="";
					String expert_duty="";
					
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <11; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				
							case 3:
								ss.setCellType(1);
								strain_type = ss.getStringCellValue().trim();
								tempMap.put("strain_type", strain_type);
								break; 
								 
							case 4:
								ss.setCellType(1);
								strain_duty = ss.getStringCellValue().trim();
								tempMap.put("strain_duty", strain_duty);
								break; 
							case 5:
								ss.setCellType(1);
								first_phone = ss.getStringCellValue().trim();
								tempMap.put("first_phone", first_phone);
								break;  
								  
							case 6:
								ss.setCellType(1);
								second_phone = ss.getStringCellValue().trim();
								tempMap.put("second_phone", second_phone);
								break;  
							case 7:
								ss.setCellType(1);
								expert_flag = ss.getStringCellValue().trim();
								tempMap.put("expert_flag", expert_flag);
								break;  
							case 8:
								ss.setCellType(1);
								expert_level = ss.getStringCellValue().trim();
								tempMap.put("expert_level", expert_level);
								break;  
							case 9:
								ss.setCellType(1);
								expert_field = ss.getStringCellValue().trim();
								tempMap.put("expert_field", expert_field);
								break;  
							case 10:
								ss.setCellType(1);
								expert_duty = ss.getStringCellValue().trim();
								tempMap.put("expert_duty", expert_duty);
								break;  
						 
								
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportStrain(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse应急人员信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportStrain(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_STRAIN t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，person_status    strain_type  strain_duty  first_phone  
				//second_phone  expert_flag   expert_level   expert_field   expert_duty
				 
				
			String hse_strain_id = "";   
			String employee_name = (String) map.get("employee_name"); 
			String person_status = (String) map.get("person_status");
			String strain_type = (String) map.get("strain_type");
			String strain_duty = (String) map.get("strain_duty");
			String first_phone = (String) map.get("first_phone");
			String second_phone=(String) map.get("second_phone");
			String expert_flag=(String) map.get("expert_flag");
			String expert_level=(String) map.get("expert_level");
			String expert_field=(String) map.get("expert_field");
			String expert_duty=(String) map.get("expert_duty");
			 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");
			 
			String strain_typeD="";
			String strain_dutyD=""; 
			String expert_flagD="";  
			String expert_levelD=""; 
			String expert_fieldD=""; 
			String expert_dutyD="";
		 
			if (strain_type != null) {
				if (strain_type.equals("自然灾害")) {
					strain_typeD = "1";
				} else if (strain_type.equals("事故灾难")) {
					strain_typeD = "2";
				} else if (strain_type.equals("公共卫生")) {
					strain_typeD = "3";
				} else if (strain_type.equals("社会安全")) {
					strain_typeD = "4";
				} 
			} 
			
			 Map innerTypeMap = jdbcDao
				.queryRecordBySQL(" select  coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000034' and superior_code_id='0' and bsflag='0' and  coding_name like '"
						+ strain_duty + "'");
		        if (innerTypeMap != null)
		        	strain_dutyD= (String) innerTypeMap.get("coding_code_id");
		        
		        
			if (expert_flag != null) {
				if (expert_flag.equals("是")) {
					expert_flagD = "1";
				} else if (expert_flag.equals("否")) {
					expert_flagD = "2";
				} 
			} 
			
			if (expert_level != null) {
				if (expert_level.equals("集团公司")) {
					expert_levelD = "1";
				} else if (expert_level.equals("公司")) {
					expert_levelD = "2";
				}  else if (expert_level.equals("二级单位")) {
					expert_levelD = "3";
				} 
			} 
			
			 Map innerTypeMapA = jdbcDao
				.queryRecordBySQL(" select  coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000035' and superior_code_id='0' and bsflag='0' and  coding_name like '"
						+ expert_field + "'");
		        if (innerTypeMapA != null)
		        	expert_fieldD= (String) innerTypeMapA.get("coding_code_id");
		        
		     Map innerTypeMapB = jdbcDao
				.queryRecordBySQL(" select  coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000036' and superior_code_id='0' and bsflag='0' and  coding_name like '"
						+ expert_duty + "'");
		        if (innerTypeMapB != null)
		        	expert_dutyD= (String) innerTypeMapB.get("coding_code_id");
		        
		        
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_strain_id = tempmap.get("hseStrainId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_strain_id", hse_strain_id); 
				tempMap.put("employee_id", employeeId); 
		 
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("STRAIN_TYPE", strain_typeD);
				tempMap.put("STRAIN_DUTY", strain_dutyD);
				tempMap.put("FIRST_PHONE", first_phone);
				tempMap.put("SECOND_PHONE", second_phone);
				tempMap.put("EXPERT_FLAG", expert_flagD);
				tempMap.put("EXPERT_LEVEL", expert_levelD);
				tempMap.put("EXPERT_FIELD", expert_fieldD);
				tempMap.put("EXPERT_DUTY", expert_dutyD);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				 
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_STRAIN"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_strain_id", hse_strain_id); 
				tempMap.put("employee_id", employeeId); 
			  
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("STRAIN_TYPE", strain_typeD);
				tempMap.put("STRAIN_DUTY", strain_dutyD);
				tempMap.put("FIRST_PHONE", first_phone);
				tempMap.put("SECOND_PHONE", second_phone);
				tempMap.put("EXPERT_FLAG", expert_flagD);
				tempMap.put("EXPERT_LEVEL", expert_levelD);
				tempMap.put("EXPERT_FIELD", expert_fieldD);
				tempMap.put("EXPERT_DUTY", expert_dutyD);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_STRAIN"); // 保存
			}
		}
	}
}

/**
 * hse餐饮从业人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelCater(ISrvMsg reqDTO) throws Exception {
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
					//employee_name，person_status   certificate_name   certificate_num   certificate_org   check_date
					
					String employee_name = "";
					String employee_code_id="";    
					String person_status = "";
					String certificate_name = "";
					String certificate_num = "";
					String certificate_org = "";
					String check_date="";
					
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				 
							case 3:
								ss.setCellType(1);
								certificate_name = ss.getStringCellValue().trim();
								tempMap.put("certificate_name", certificate_name);
								break; 
							case 4:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break; 
								
							case 5:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break;  
								
							case 6: 
								if(ss.getCellType()==0){
									check_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									check_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								check_date=check_date.replace("/", "-");
								String[] biths=check_date.split("-");
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
								System.out.println(temp);
								tempMap.put("check_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportCater(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse餐饮从业人员批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportCater(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_CATER t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，person_status，    certificate_name  certificate_org   check_date
			String hse_cater_id = "";  
			String employee_name = (String) map.get("employee_name");
			String person_status =(String) map.get("person_status");
			String certificate_name = (String) map.get("certificate_name");
			String certificate_num = (String) map.get("certificate_num");
			String certificate_org = (String) map.get("certificate_org");
			String check_date=(String) map.get("check_date"); 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");

         
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_cater_id = tempmap.get("hseCaterId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_cater_id", hse_cater_id); 
				tempMap.put("employee_id", employeeId);  
		 
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_CATER"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_cater_id", hse_cater_id); 
				tempMap.put("employee_id", employeeId); 
	  
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_CATER"); // 保存
			}
		}
	}
}


/**
 * hse涉爆人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelBlast(ISrvMsg reqDTO) throws Exception {
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
					//employee_name，person_status   certificate_name   certificate_num   certificate_org   check_date
					
					String employee_name = "";
					String employee_code_id="";    
					String person_status = "";
					String certificate_name = "";
					String certificate_num = "";
					String certificate_org = "";
					String check_date="";
					
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				 
							case 3:
								ss.setCellType(1);
								certificate_name = ss.getStringCellValue().trim();
								tempMap.put("certificate_name", certificate_name);
								break; 
							case 4:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break; 
								
							case 5:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break;  
								
							case 6: 
								if(ss.getCellType()==0){
									check_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									check_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								check_date=check_date.replace("/", "-");
								String[] biths=check_date.split("-");
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
								System.out.println(temp);
								tempMap.put("check_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
								 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportBlast(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse涉爆人员批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportBlast(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_BLAST t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，person_status，    certificate_name  certificate_org   check_date
			String hse_blast_id = "";  
			String employee_name = (String) map.get("employee_name");
			String person_status =(String) map.get("person_status");
			String certificate_name = (String) map.get("certificate_name");
			String certificate_num = (String) map.get("certificate_num");
			String certificate_org = (String) map.get("certificate_org");
			String check_date=(String) map.get("check_date"); 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");

         
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_blast_id = tempmap.get("hseBlastId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_blast_id", hse_blast_id); 
				tempMap.put("employee_id", employeeId);  
		 
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_BLAST"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_blast_id", hse_blast_id); 
				tempMap.put("employee_id", employeeId); 
	  
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CHECK_DATE", check_date);
				tempMap.put("PERSON_STATUS", person_status);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_BLAST"); // 保存
			}
		}
	}
}



/**
 * hse职业健康人员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelHealth(ISrvMsg reqDTO) throws Exception {
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
					//employee_name， person_status     health_post   post_date   radioactive    medical_history
					
					String employee_name = "";
					String employee_code_id="";   
					String person_status = "";
					String health_post = "";
					String post_date = "";
					String radioactive = "";
					String medical_history="";
					String employeeId="";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
				
							case 3:
								ss.setCellType(1);
								health_post = ss.getStringCellValue().trim();
								tempMap.put("health_post", health_post);
								break; 
								
							case 4: 
								if(ss.getCellType()==0){
									post_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									post_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								post_date=post_date.replace("/", "-");
								String[] biths=post_date.split("-");
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
								System.out.println(temp);
								tempMap.put("post_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
							case 5:
								ss.setCellType(1);
								radioactive = ss.getStringCellValue().trim();
								tempMap.put("radioactive", radioactive);
								break; 
							case 6:
								ss.setCellType(1);
								medical_history = ss.getStringCellValue().trim();
								tempMap.put("medical_history", medical_history);
								break;  
								  
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
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
				saveImportHealth(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse职业健康人员信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportHealth(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_HEALTH t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name， person_status     health_post   post_date   radioactive    medical_history
			String hse_health_id = "";  
			String employee_name = (String) map.get("employee_name");
			String person_status =(String) map.get("person_status");
			String health_post = (String) map.get("health_post");
			String post_date = (String) map.get("post_date");
			String radioactive = (String) map.get("radioactive");
			String medical_history=(String) map.get("medical_history"); 
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project");
			
			String radioactives="";
			if (radioactive != null) {
				if (radioactive.equals("是")) {
					radioactives = "1";
				} else if (radioactive.equals("否")) {
					radioactives = "2";
				} 
			} 
			
		  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				Map tempMap = new HashMap();
				hse_health_id = tempmap.get("hseHealthId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_health_id", hse_health_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org); 
				
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("HEALTH_POST", health_post);
				tempMap.put("POST_DATE", post_date);
				tempMap.put("RADIOACTIVE", radioactives);
				tempMap.put("MEDICAL_HISTORY", medical_history);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_HEALTH"); // 保存 
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_health_id", hse_health_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				 
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("HEALTH_POST", health_post);
				tempMap.put("POST_DATE", post_date);
				tempMap.put("RADIOACTIVE", radioactives);
				tempMap.put("MEDICAL_HISTORY", medical_history);
				
				tempMap.put("SECOND_ORG", second_org);
				tempMap.put("THIRD_ORG", third_org);
				tempMap.put("FOURTH_ORG", fourth_org);
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_HEALTH"); // 保存
			}
		}
	}
}


/**
 * hse内审员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelTrainer2(ISrvMsg reqDTO) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
	UserToken user = reqDTO.getUserToken();	
	String project= reqDTO.getValue("project"); // 是否多项目
	String addType= reqDTO.getValue("addType");
	
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
					//employee_name，code_id    tech_title   person_status   
					//certificate_name   certificate_org  org_level  certificate_num   the_end_date
					
					String employee_name = "";
					String employee_code_id="";   
					
					String code_id = "";
					String tech_title = "";
					String person_status = "";
					String certificate_name = "";
					String certificate_org="";
					String org_level="";
					String certificate_num="";
					String the_end_date="";
					 
					String employeeId=""; 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <9; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								tech_title = ss.getStringCellValue().trim();
								tempMap.put("tech_title", tech_title);
								break; 
				
							case 3:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
								
							case 4:
								ss.setCellType(1);
								certificate_name = ss.getStringCellValue().trim();
								tempMap.put("certificate_name", certificate_name);
								break;
			 
							case 5:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break; 
							case 6:
								ss.setCellType(1);
								org_level = ss.getStringCellValue().trim();
								tempMap.put("org_level", org_level);
								break; 	
								
							case 7:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break;  
								  
								
							case 8: 
								if(ss.getCellType()==0){
									the_end_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									the_end_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								the_end_date=the_end_date.replace("/", "-");
								String[] bithsA=the_end_date.split("-");
								String tempA="";
								for(int i=0;i<bithsA.length;i++){
									if(bithsA[i].length()==1){
									bithsA[i]="0"+bithsA[i];
									}
									if(i==bithsA.length-1){
										tempA+=bithsA[i];
									}else{
										tempA+=bithsA[i]+"-";
									}
									
								}
								System.out.println(tempA);
								tempMap.put("the_end_date",tempA); 
								break; 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
								}
								
							} 
							
							if (message.toString().equals("")) {
								tempMap.put("project", project);
								tempMap.put("addType", addType);
								
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
				saveImportTrainer2(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse内审员信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportTrainer2(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_TECH_RESOURCE t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，code_id    tech_title   person_status   
				//certificate_name   certificate_org  org_level  certificate_num   the_end_date

			String hse_tech_id = "";  
			String employee_name = (String) map.get("employee_name");
 
			String code_id =(String) map.get("employee_code_id");
			String tech_title = (String) map.get("tech_title");
			String person_status = (String) map.get("person_status");
			String certificate_name = (String) map.get("certificate_name"); 
			String certificate_org=(String) map.get("certificate_org");
			String org_level=(String) map.get("org_level");
			String certificate_num=(String) map.get("certificate_num"); 			
			String the_end_date=(String) map.get("the_end_date"); 
			
			
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project"); 
			String addType=(String) map.get("addType");
			  
			String org_levelB="";
			if (org_level != null) {
				if (org_level.equals("集团公司")) {
					org_levelB = "1";
				} else if (org_level.equals("公司")) {
					org_levelB = "2";
				} else if (org_level.equals("二级单位")) {
					org_levelB = "3";
				} else if (org_level.equals("三级单位")) {
					org_levelB = "4";
				}  
			} 
			
		  
			  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				String modelType= tempmap.get("modelType").toString(); 
				if(modelType.equals("2")){
				Map tempMap = new HashMap();
				hse_tech_id = tempmap.get("hseTechId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_tech_id", hse_tech_id); 
				tempMap.put("employee_id", employeeId); 
  
				tempMap.put("CODE_ID", code_id);
				tempMap.put("TECH_TITLE", tech_title);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("CERTIFICATE_NAME", certificate_name); 
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("ORG_LEVEL", org_levelB);
				tempMap.put("CERTIFICATE_NUM", certificate_num); 
				tempMap.put("THE_END_DATE", the_end_date);
				tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
 
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存 
				}
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_tech_id", hse_tech_id); 
				tempMap.put("employee_id", employeeId); 
				
				tempMap.put("CODE_ID", code_id);
				tempMap.put("TECH_TITLE", tech_title);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("CERTIFICATE_NAME", certificate_name); 
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("ORG_LEVEL", org_levelB);
				tempMap.put("CERTIFICATE_NUM", certificate_num); 
				tempMap.put("THE_END_DATE", the_end_date);
				tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
 
				  
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存
			}
		}
	}
}



/**
 * hse专业技能资源信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelTrainerList(ISrvMsg reqDTO) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
	UserToken user = reqDTO.getUserToken();	
	String project= reqDTO.getValue("project"); // 是否多项目
	String addType= reqDTO.getValue("addType");
	
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
					//employee_name， code_id    tech_title   person_status   plate_property 
					//comm_date   certificate_org   certificate_num   the_end_date
					
					String employee_name = "";
					String employee_code_id="";   
					
					String code_id = "";
					String tech_title = "";
					String person_status = "";
					String plate_property = "";
					String comm_date="";
					String certificate_org="";
					String certificate_num="";
					String the_end_date="";
					 
					String employeeId=""; 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <9; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								tech_title = ss.getStringCellValue().trim();
								tempMap.put("tech_title", tech_title);
								break; 
				
							case 3:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
								
							case 4:
								ss.setCellType(1);
								plate_property = ss.getStringCellValue().trim();
								tempMap.put("plate_property", plate_property);
								break;
								
							case 5: 
								if(ss.getCellType()==0){
									comm_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									comm_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								comm_date=comm_date.replace("/", "-");
								String[] biths=comm_date.split("-");
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
								System.out.println(temp);
								tempMap.put("comm_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
							case 6:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break; 
							case 7:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break;  
								  
								
							case 8: 
								if(ss.getCellType()==0){
									the_end_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									the_end_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								the_end_date=the_end_date.replace("/", "-");
								String[] bithsA=the_end_date.split("-");
								String tempA="";
								for(int i=0;i<bithsA.length;i++){
									if(bithsA[i].length()==1){
									bithsA[i]="0"+bithsA[i];
									}
									if(i==bithsA.length-1){
										tempA+=bithsA[i];
									}else{
										tempA+=bithsA[i]+"-";
									}
									
								}
								System.out.println(tempA);
								tempMap.put("the_end_date",tempA); 
								break;
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
								}
								
							} 
							
							if (message.toString().equals("")) {
								tempMap.put("project", project);
								tempMap.put("addType", addType);
								
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
				saveImportTrainerList(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse专业技能资源信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportTrainerList(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_TECH_RESOURCE t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name， code_id    tech_title   person_status   plate_property 
				//comm_date   certificate_org   certificate_num   the_end_date

			String hse_tech_id = "";  
			String employee_name = (String) map.get("employee_name");
 
			String code_id =(String) map.get("employee_code_id");
			String tech_title = (String) map.get("tech_title");
			String person_status = (String) map.get("person_status");
			String plate_property = (String) map.get("plate_property");
			String comm_date=(String) map.get("comm_date"); 			
			String certificate_org=(String) map.get("certificate_org"); 			
			String certificate_num=(String) map.get("certificate_num"); 			
			String the_end_date=(String) map.get("the_end_date"); 
			
			
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project"); 
			String addType=(String) map.get("addType");
			  
			String plate_propertyB="";
			if (plate_property != null) {
				if (plate_property.equals("野外一线")) {
					plate_propertyB = "1";
				} else if (plate_property.equals("固定场所")) {
					plate_propertyB = "2";
				} else if (plate_property.equals("科研单位")) {
					plate_propertyB = "3";
				} else if (plate_property.equals("培训接待")) {
					plate_propertyB = "4";
				} else if (plate_property.equals("矿区")) {
					plate_propertyB = "5";
				} 
			} 
			
		  
			
			  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null) {
				String modelType= tempmap.get("modelType").toString(); 
				if(modelType.equals("1")){
				Map tempMap = new HashMap();
				hse_tech_id = tempmap.get("hseTechId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_tech_id", hse_tech_id); 
				tempMap.put("employee_id", employeeId); 
				tempMap.put("CODE_ID", code_id);
				tempMap.put("TECH_TITLE", tech_title);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("PLATE_PROPERTY", plate_propertyB);
				tempMap.put("COMM_DATE", comm_date);
		//		map.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
		//		map.put("ORG_LEVEL", org_level);
		//		map.put("LICENCE_NUM", licence_num);   //执业证号
				tempMap.put("THE_END_DATE", the_end_date);
				tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
		//		map.put("ASSESSOR_TYPE", assessor_type);  //注册HSE审核员 类别
				 
				
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存 
				}
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_tech_id", hse_tech_id); 
				tempMap.put("employee_id", employeeId); 
				
				tempMap.put("CODE_ID", code_id);
				tempMap.put("TECH_TITLE", tech_title);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("PLATE_PROPERTY", plate_propertyB);
				tempMap.put("COMM_DATE", comm_date);
		//		map.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
		//		map.put("ORG_LEVEL", org_level);
		//		map.put("LICENCE_NUM", licence_num);   //执业证号
				tempMap.put("THE_END_DATE", the_end_date);
				tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
		//		map.put("ASSESSOR_TYPE", assessor_type);  //注册HSE审核员 类别
				  
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存
			}
		}
	}
}




/**
 * hse注册HSE审核员信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelTrainer3(ISrvMsg reqDTO) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
	UserToken user = reqDTO.getUserToken();	
	String project= reqDTO.getValue("project"); // 是否多项目
	String addType= reqDTO.getValue("addType");
	
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
					//employee_name，code_id    tech_title   person_status     certificate_name 
					//certificate_num   certificate_org comm_date   assessor_type   the_end_date
					
					String employee_name = "";
					String employee_code_id="";   
					
					String code_id = "";
					String tech_title = "";
					String person_status = "";
					String certificate_name = "";
					String certificate_num="";
					String certificate_org="";
					String comm_date="";
					String assessor_type="";
					String the_end_date="";
					 
					String employeeId=""; 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <10; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								tech_title = ss.getStringCellValue().trim();
								tempMap.put("tech_title", tech_title);
								break; 
				
							case 3:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
								
							case 4:
								ss.setCellType(1);
								certificate_name = ss.getStringCellValue().trim();
								tempMap.put("certificate_name", certificate_name);
								break;
							case 5:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break;
							case 6:
								ss.setCellType(1);
								certificate_org = ss.getStringCellValue().trim();
								tempMap.put("certificate_org", certificate_org);
								break;
								
							case 7: 
								if(ss.getCellType()==0){
									comm_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									comm_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								comm_date=comm_date.replace("/", "-");
								String[] biths=comm_date.split("-");
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
								System.out.println(temp);
								tempMap.put("comm_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
				 
							case 8:
								ss.setCellType(1);
								assessor_type = ss.getStringCellValue().trim();
								tempMap.put("assessor_type", assessor_type);
								break;  
								   
							case 9: 
								if(ss.getCellType()==0){
									the_end_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									the_end_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								the_end_date=the_end_date.replace("/", "-");
								String[] bithsA=the_end_date.split("-");
								String tempA="";
								for(int i=0;i<bithsA.length;i++){
									if(bithsA[i].length()==1){
									bithsA[i]="0"+bithsA[i];
									}
									if(i==bithsA.length-1){
										tempA+=bithsA[i];
									}else{
										tempA+=bithsA[i]+"-";
									}
									
								}
								System.out.println(tempA);
								tempMap.put("the_end_date",tempA); 
								break;
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
								}
								
							} 
							
							if (message.toString().equals("")) {
								tempMap.put("project", project);
								tempMap.put("addType", addType);
								
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
				saveImportTrainer3(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse注册HSE审核员信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportTrainer3(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_TECH_RESOURCE t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name，code_id    tech_title   person_status     certificate_name 
				//certificate_num   certificate_org comm_date   assessor_type   the_end_date
				

			String hse_tech_id = "";  
			String employee_name = (String) map.get("employee_name");
 
			String code_id =(String) map.get("employee_code_id");
			String tech_title = (String) map.get("tech_title");
			String person_status = (String) map.get("person_status"); 
			String certificate_name = (String) map.get("certificate_name");
			String certificate_num=(String) map.get("certificate_num"); 	
			String certificate_org=(String) map.get("certificate_org"); 
			String comm_date=(String) map.get("comm_date"); 			
			String assessor_type=(String) map.get("assessor_type");   
			String the_end_date=(String) map.get("the_end_date"); 
			
			
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project"); 
			String addType=(String) map.get("addType");
			  
			String assessor_typeB="";
			if (assessor_type != null) {
				if (assessor_type.equals("实习审核员")) {
					assessor_typeB = "1";
				} else if (assessor_type.equals("审核员")) {
					assessor_typeB = "2";
				} else if (assessor_type.equals("高级审核员")) {
					assessor_typeB = "3";
				}  
			} 
 
			  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null  ) {
				String modelType= tempmap.get("modelType").toString();  
				if(modelType.equals("3")){
				Map tempMap = new HashMap();
				hse_tech_id = tempmap.get("hseTechId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
				tempMap.put("hse_tech_id", hse_tech_id); 
				tempMap.put("employee_id", employeeId); 
				//employee_name，code_id    tech_title   person_status     certificate_name 
				//certificate_num   certificate_org comm_date   assessor_type   the_end_date
				
				tempMap.put("CODE_ID", code_id);
				tempMap.put("TECH_TITLE", tech_title);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("COMM_DATE", comm_date);
				tempMap.put("ASSESSOR_TYPE", assessor_typeB);  //注册HSE审核员 类别 
				tempMap.put("THE_END_DATE", the_end_date);
				tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
	 
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存 
				}
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_tech_id", hse_tech_id); 
				tempMap.put("employee_id", employeeId); 
				
				tempMap.put("CODE_ID", code_id);
				tempMap.put("TECH_TITLE", tech_title);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("CERTIFICATE_NAME", certificate_name);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("CERTIFICATE_ORG", certificate_org);
				tempMap.put("COMM_DATE", comm_date);
				tempMap.put("ASSESSOR_TYPE", assessor_typeB);  //注册HSE审核员 类别 
				tempMap.put("THE_END_DATE", the_end_date);
				tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
				  
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存
			}
		}
	}
}






/**
 * hse注册安全工程师批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelTrainer4(ISrvMsg reqDTO) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
	UserToken user = reqDTO.getUserToken();	
	String project= reqDTO.getValue("project"); // 是否多项目
	String addType= reqDTO.getValue("addType");
	
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
					//employee_name， code_id    tech_title   person_status     certificate_num   licence_num  comm_date 
					
					String employee_name = "";
					String employee_code_id="";   
					
					String code_id = "";
					String tech_title = "";
					String person_status = "";
					String certificate_num="";
					String licence_num="";
					String comm_date="";
			 
					String employeeId=""; 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								employee_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("employee_name", employee_name);
								break;
							case 1:
								ss.setCellType(1);
								employee_code_id = ss.getStringCellValue().trim();
								tempMap.put("employee_code_id", employee_code_id);
								break; 
							case 2:
								ss.setCellType(1);
								tech_title = ss.getStringCellValue().trim();
								tempMap.put("tech_title", tech_title);
								break; 
				
							case 3:
								ss.setCellType(1);
								person_status = ss.getStringCellValue().trim();
								tempMap.put("person_status", person_status);
								break; 
							 
							case 4:
								ss.setCellType(1);
								certificate_num = ss.getStringCellValue().trim();
								tempMap.put("certificate_num", certificate_num);
								break;
							case 5:
								ss.setCellType(1);
								licence_num = ss.getStringCellValue().trim();
								tempMap.put("licence_num", licence_num);
								break;
								
							case 6: 
								if(ss.getCellType()==0){
									comm_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									comm_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								comm_date=comm_date.replace("/", "-");
								String[] biths=comm_date.split("-");
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
								System.out.println(temp);
								tempMap.put("comm_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行日期格式不正确;");
								} 
								break;
						 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
	 
							if (employee_name.equals("") || employee_code_id.equals("")) { 
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}

							if(!employee_code_id.equals("")){ 
								// 根据人员身份证号判断导入人员是否存在
								String sql = "select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no ='"+employee_code_id+"' ";
								Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
								if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
								     employeeId = (String) tempMaps.get("employeeId"); 
									 tempMap.put("employeeId", employeeId); 
								}else{
									message.append("第").append(m + 1).append(
									"行人员身份证号不存在，请正确输入;"); 
								}
								
							} 
							
							if (message.toString().equals("")) {
								tempMap.put("project", project);
								tempMap.put("addType", addType);
								
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
				saveImportTrainer4(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}


/**
 * hse注册安全工程师批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportTrainer4(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合

		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i); 
			String sql1 = "select t.* from BGP_HSE_TECH_RESOURCE t where t.employee_id='"
				+ map.get("employeeId")
				+ "' and t.bsflag='0'  and t.project_info_no = '"+user.getProjectInfoNo()+"' "; 
		    Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);   
		
			// 根据人员id查询orgId 
			String second_org = "";
			String third_org = "";
			String fourth_org = ""; 
				String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = (select os.org_subjection_id from comm_org_subjection os join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' join  (select e.org_id,e.employee_id from comm_human_employee e where e.bsflag='0' union select l.owning_org_id as org_is,l.labor_id as employee_id from bgp_comm_human_labor l where l.bsflag='0') tt on tt.org_id=oi.org_id   where os.bsflag='0' and tt.employee_id = '"+map.get("employeeId")+"')  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
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
				//employee_name， code_id    tech_title   person_status     certificate_num   licence_num  comm_date 

			String hse_tech_id = "";  
			String employee_name = (String) map.get("employee_name");
 
			String code_id =(String) map.get("employee_code_id");
			String tech_title = (String) map.get("tech_title");
			String person_status = (String) map.get("person_status");
			String certificate_num=(String) map.get("certificate_num"); 
			String licence_num = (String) map.get("licence_num");
			String comm_date=(String) map.get("comm_date"); 			
		  
			String employeeId=(String) map.get("employeeId");
			String project=(String) map.get("project"); 
			String addType=(String) map.get("addType");
			  
		  
			// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
			if (tempmap != null  ) {
				String modelType= tempmap.get("modelType").toString();  
				if(modelType.equals("4")){
				Map tempMap = new HashMap();
				hse_tech_id = tempmap.get("hseTechId").toString();
				employeeId = tempmap.get("employeeId").toString(); 
			 
					tempMap.put("hse_tech_id", hse_tech_id); 
					tempMap.put("employee_id", employeeId); 
	  
					tempMap.put("CODE_ID", code_id);
					tempMap.put("TECH_TITLE", tech_title);
					tempMap.put("PERSON_STATUS", person_status);
					tempMap.put("CERTIFICATE_NUM", certificate_num);
					tempMap.put("LICENCE_NUM", licence_num); 
					tempMap.put("COMM_DATE", comm_date); 
					tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
			  
					tempMap.put("UPDATOR_ID", user.getUserId());
					tempMap.put("MODIFI_DATE", new Date());
					tempMap.put("BSFLAG", "0"); 
					jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存 
				}
		 
			
			} else {
				Map tempMap = new HashMap();
				tempMap.put("hse_tech_id", hse_tech_id); 
				tempMap.put("employee_id", employeeId); 
				
				tempMap.put("CODE_ID", code_id);
				tempMap.put("TECH_TITLE", tech_title);
				tempMap.put("PERSON_STATUS", person_status);
				tempMap.put("CERTIFICATE_NUM", certificate_num);
				tempMap.put("LICENCE_NUM", licence_num); 
				tempMap.put("COMM_DATE", comm_date); 
				tempMap.put("MODEL_TYPE", addType);      //区分4个的模块
				  
				tempMap.put("UPDATOR_ID", user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG", "0"); 
				tempMap.put("CREATE_DATE", new Date());
				tempMap.put("CREATOR_ID", user.getUserId());
				
				if(project.equals("2")){
					tempMap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				}
				 
				jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_TECH_RESOURCE"); // 保存
			}
		}
	}
}


public ISrvMsg queryCheckPie(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	
	String check_date = isrvmsg.getValue("check_date");
	String check_dateA = isrvmsg.getValue("check_dateA");
	String second = isrvmsg.getValue("second_org");
	String third = isrvmsg.getValue("third_org");
	String fourth = isrvmsg.getValue("fourth_org");
	
	
	String sql = "select sd1.coding_code_id,  sd1.coding_name,   sum(case    when qd.qdetail_no  is null or lq.questions_no is null then   0  else  1 end) num from Comm_Coding_Sort_Detail sd1   left join BGP_LIST_QUESTIONS_DETAIL qd   on qd.system_elements=sd1.coding_code_id and qd.bsflag='0'   left join  BGP_LIST_QUESTIONS lq   on qd.questions_no=lq.questions_no and lq.bsflag='0' "; 
     	   if(second!=null&&!second.equals("")){
     		   sql = sql + " and lq.org_sub_id like'"+second+"%' ";
     	   }
     	   if(third!=null&&!third.equals("")){
     		   sql = sql + " and lq.second_org like'"+third+"%' ";
     	   }
     	   if(fourth!=null&&!fourth.equals("")){
     		   sql = sql + " and lq.third_org like'"+fourth+"%' ";
     	   }
     		if(check_date!=null && !check_date.equals("")){
    			sql = sql+" and lq.check_date >= to_date('"+check_date+"','yyyy-MM-dd') ";
    		}
    		if(check_dateA!=null && !check_dateA.equals("")){
    			sql = sql+" and lq.check_date <= to_date('"+check_dateA+"','yyyy-MM-dd') ";
    		}
    		 
           sql = sql + " where sd1.coding_sort_id = '5110000047' and sd1.superior_code_id = '0' and sd1.bsflag = '0' group by sd1.coding_code_id, sd1.coding_name order by sd1.coding_code_id";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	
	String Str = "<chart caption='问题清单体系要素统计' showValues='1' baseFontSize='12' decimals='0' formatNumberScale='0' palette='2' bgColor='#f3f3f3'>";
	for(int i=0;i<list.size();i++){
		Map map = (Map)list.get(i);
		String  codingName = (String)map.get("codingName");
		String  num = (String)map.get("num");
		Str = Str+"<set value='"+num+"' label='("+codingName+")'/>";
	}
	Str = Str+"</chart>";
	System.out.println("Str = " + Str);
	
	responseDTO.setValue("Str", Str);
	return responseDTO;
}




/**
 * hse隐患信息批量导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("unchecked")
public ISrvMsg importExcelHidden(ISrvMsg reqDTO) throws Exception {
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
				for (int m = 4; m <= sheet.getLastRowNum(); m++) {
					row = sheet.getRow(m);
		//hidden_no,org_sub_id,second_org,third_org,operation_post,hidden_name, identification_method,hazard_big,
		//hazard_center,hidden_level,hidden_type_s,whether_new,rpeople_type,recognition_people,hidden_yuanyin,report_date,hidden_description
		
					String org_sub_id = "";
					String second_org = "";
					String third_org = "";
					
					String org_sub_id_name = "";
					String second_org_name = "";
					String third_org_name = "";
					String operation_post = "";
					String hidden_name = "";					
					String identification_method = "";
					String hazard_big = "";
					String hazard_center = "";
					
					String hidden_level = "";
					String hidden_type_s = "";
					String whether_new = "";
					String rpeople_type = "";
					String recognition_people = "";
					String hidden_yuanyin = "";
					String report_date = "";
					String hidden_description = "";
					
				//	mdetail_no,evaluation_date,evaluation_level,evaluation_personnel,main_methods,evaluation_state,risk_levels,
			   //rectification_state,rectification_measures_type,rectification_measures,control_effect,rectification_date,  
			  //reward_level,reward_amount,cash_date,reward_state
					
					
					String evaluation_level = "";
					String evaluation_personnel = "";
					String main_methods = "";
					String risk_levels = "";
					
					String rectification_state = "";
					String rectification_measures_type = "";
					String rectification_measures = "";
					String control_effect = "";	
					String rectification_date = "";	
					 
					String reward_level = "";
					String reward_amount = "";
					String cash_date = "";
					
					String harmful_consequences = "";
					String rectification_head = "";
					String rectification_people = "";
		 
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <30; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								org_sub_id_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("org_sub_id_name", org_sub_id_name);
								break;
							case 1:
								ss.setCellType(1);
								second_org_name = ss.getStringCellValue().trim();
								tempMap.put("second_org_name", second_org_name);
								break; 
							case 2:
								ss.setCellType(1);
								third_org_name = ss.getStringCellValue().trim();
								tempMap.put("third_org_name", third_org_name);
								break; 
				 
							case 3:
								ss.setCellType(1);
								operation_post = ss.getStringCellValue().trim();
								tempMap.put("operation_post", operation_post);
								break; 
						/*	case 4:
								ss.setCellType(1);
								hidden_name = ss.getStringCellValue().trim();
								tempMap.put("hidden_name", hidden_name);
								break; 
							 */
							case 4:
								ss.setCellType(1);
								identification_method = ss.getStringCellValue().trim();
								tempMap.put("identification_method", identification_method);
								break;  
							case 5:
								ss.setCellType(1);
								hazard_big = ss.getStringCellValue().trim();
								tempMap.put("hazard_big", hazard_big);
								break; 
							case 6:
								ss.setCellType(1);
								hazard_center = ss.getStringCellValue().trim();
								tempMap.put("hazard_center", hazard_center);
								break; 
							case 7:
								ss.setCellType(1);
								hidden_level = ss.getStringCellValue().trim();
								tempMap.put("hidden_level", hidden_level);
								break; 
							case 8:
								ss.setCellType(1);
								hidden_type_s = ss.getStringCellValue().trim();
								tempMap.put("hidden_type_s", hidden_type_s);
								break; 
							case 9:
								ss.setCellType(1);
								whether_new = ss.getStringCellValue().trim();
								tempMap.put("whether_new", whether_new);
								break; 
							case 10:
								ss.setCellType(1);
								rpeople_type = ss.getStringCellValue().trim();
								tempMap.put("rpeople_type", rpeople_type);
								break; 
							case 11:
								ss.setCellType(1);
								recognition_people = ss.getStringCellValue().trim();
								tempMap.put("recognition_people", recognition_people);
								break; 
							case 12:
								ss.setCellType(1);
								hidden_yuanyin = ss.getStringCellValue().trim();
								tempMap.put("hidden_yuanyin", hidden_yuanyin);
								break; 
							case 13:
						 
								if(ss.getCellType()==0){
									report_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									report_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								report_date=report_date.replace("/", "-");
								String[] biths=report_date.split("-");
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
								System.out.println(temp);
								tempMap.put("report_date",temp); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行上报日期格式不正确;");
								} 
								break; 
								
							case 14:
								ss.setCellType(1);
								hidden_description = ss.getStringCellValue().trim();
								tempMap.put("hidden_description", hidden_description);
								break; 
							case 15:
								ss.setCellType(1);
								evaluation_level = ss.getStringCellValue().trim();
								tempMap.put("evaluation_level", evaluation_level);
								break;  
							case 16:
								ss.setCellType(1);
								evaluation_personnel = ss.getStringCellValue().trim();
								tempMap.put("evaluation_personnel", evaluation_personnel);
								break; 
							case 17:
								ss.setCellType(1);
								main_methods = ss.getStringCellValue().trim();
								tempMap.put("main_methods", main_methods);
								break; 
							case 18:
								ss.setCellType(1);
								harmful_consequences = ss.getStringCellValue().trim();
								tempMap.put("harmful_consequences", harmful_consequences);
								break; 
								
							case 19:
								ss.setCellType(1);
								risk_levels = ss.getStringCellValue().trim();
								tempMap.put("risk_levels", risk_levels);
								break; 
							case 20:
								ss.setCellType(1);
								rectification_state = ss.getStringCellValue().trim();
								tempMap.put("rectification_state", rectification_state);
								break; 
							case 21:
								ss.setCellType(1);
								rectification_measures_type = ss.getStringCellValue().trim();
								tempMap.put("rectification_measures_type", rectification_measures_type);
								break; 
							case 22:
								ss.setCellType(1);
								rectification_measures = ss.getStringCellValue().trim();
								tempMap.put("rectification_measures", rectification_measures);
								break; 
							case 23:
								ss.setCellType(1);
								control_effect = ss.getStringCellValue().trim();
								tempMap.put("control_effect", control_effect);
								break; 
								
							case 24:
								ss.setCellType(1);
								rectification_head = ss.getStringCellValue().trim();
								tempMap.put("rectification_head", rectification_head);
								break; 
							case 25:
								ss.setCellType(1);
								rectification_people = ss.getStringCellValue().trim();
								tempMap.put("rectification_people", rectification_people);
								break; 
								
								
							case 26:
						 
								if(ss.getCellType()==0){
									rectification_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									rectification_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								rectification_date=rectification_date.replace("/", "-");
								String[] bithsA=rectification_date.split("-");
								String tempA="";
								for(int i=0;i<bithsA.length;i++){
									if(bithsA[i].length()==1){
									bithsA[i]="0"+bithsA[i];
									}
									if(i==bithsA.length-1){
										tempA+=bithsA[i];
									}else{
										tempA+=bithsA[i]+"-";
									}
									
								}
								System.out.println(tempA);
								tempMap.put("rectification_date",tempA); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(tempA);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行整改完成时间格式不正确;");
								} 
								break; 
								
								
							case 27:
								ss.setCellType(1);
								reward_level = ss.getStringCellValue().trim();
								tempMap.put("reward_level", reward_level);
								break; 
							case 28:
								ss.setCellType(1);
								reward_amount = ss.getStringCellValue().trim();
								tempMap.put("reward_amount", reward_amount);
								
								try {   
									 double value = 0;  
									Scanner s = new Scanner(reward_amount); 
									value = s.nextDouble();   
								} catch (Exception ex) { 
									message.append("第").append(m + 1).append(
											"行奖励金额应为数字格式，请正确输入;"); 
									}
								
								
								break; 
							case 29:
						 
								if(ss.getCellType()==0){
									cash_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									cash_date = ss.getStringCellValue().trim(); // 对应赋值
								} 
								cash_date=cash_date.replace("/", "-");
								String[] bithsB=cash_date.split("-");
								String tempB="";
								for(int i=0;i<bithsB.length;i++){
									if(bithsB[i].length()==1){
									bithsB[i]="0"+bithsB[i];
									}
									if(i==bithsB.length-1){
										tempB+=bithsB[i];
									}else{
										tempB+=bithsB[i]+"-";
									}
									
								}
								System.out.println(tempB);
								tempMap.put("cash_date",tempB); 
								
								try{
									new SimpleDateFormat("yyyy-MM-dd").parse(tempB);
								}catch(Exception ex){
									
									message.append("第").append(m + 1).append(
								"行兑现日期格式不正确;");
								} 
								break; 
								
							 
							default:
								break;
							}
						}
					}
				     	// 判断必填项处理
			 
							if (org_sub_id_name.equals("") || operation_post.equals("") || hazard_big.equals("") || hazard_center.equals("") || hidden_level.equals("") || hidden_type_s.equals("") || hidden_yuanyin.equals("")  || report_date.equals("") ||hidden_description.equals("") || harmful_consequences.equals("") || risk_levels.equals("") || rectification_state.equals("")|| rectification_measures.equals("") || control_effect.equals("") ) {  
								message.append("第").append(m + 1).append(
										"行红色标注项不能为空;");
							}
							// 根据用户输入的单位名称，来查询组织机构id号
									if(!org_sub_id_name.equals("")){ 
										String sql = "select  cob.org_subjection_id,cif.org_id ,cob.father_org_id,cif.org_name,cif.org_abbreviation  from comm_org_information cif  left join comm_org_subjection cob  on cif.org_id=cob.org_id and cob.bsflag='0'   where cif.bsflag='0' and cif.org_abbreviation = '"+org_sub_id_name+"' ";
										Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
										if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
											org_sub_id = (String) tempMaps.get("orgSubjectionId"); 
											 tempMap.put("org_sub_id", org_sub_id); 
										}else{
											message.append("第").append(m + 1).append(
											"行单位不存在，请正确输入;"); 
										}
										
									} 
									if(!second_org_name.equals("")){ 
										String sql = "select  cob.org_subjection_id,cif.org_id ,cob.father_org_id,cif.org_name,cif.org_abbreviation  from comm_org_information cif  left join comm_org_subjection cob  on cif.org_id=cob.org_id and cob.bsflag='0'   where cif.bsflag='0' and cif.org_abbreviation = '"+second_org_name+"' ";
										Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
										if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
											second_org = (String) tempMaps.get("orgSubjectionId"); 
											 tempMap.put("second_org", second_org); 
										}else{
											message.append("第").append(m + 1).append(
											"行基层单位不存在，请正确输入;"); 
										}
										
									} 
									if(!third_org_name.equals("")){ 
										String sql = "select  cob.org_subjection_id,cif.org_id ,cob.father_org_id,cif.org_name,cif.org_abbreviation  from comm_org_information cif  left join comm_org_subjection cob  on cif.org_id=cob.org_id and cob.bsflag='0'   where cif.bsflag='0' and cif.org_abbreviation = '"+third_org_name+"' ";
										Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
										if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
											third_org = (String) tempMaps.get("orgSubjectionId"); 
											 tempMap.put("third_org", third_org); 
										}else{
											message.append("第").append(m + 1).append(
											"行下属单位不存在，请正确输入;"); 
										}
										
									} 
							
									//大类
									if(!hazard_big.equals("")){ 
										String sql = "select t.coding_code_id from comm_coding_sort_detail t where t.coding_sort_id='5110000032' and t.bsflag='0' and  t.coding_name = '"+hazard_big+"'  ";
										Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
										if (tempMaps != null && tempMaps.size() > 0) {  
										}else{
											message.append("第").append(m + 1).append(
											"行隐患危害类型(大类)系统不存在，请正确选择;"); 
										}
										
									} 
									
									//小类
									if(!hazard_center.equals("")){ 
										String sql = "select t.coding_code_id from comm_coding_sort_detail t where t.coding_sort_id='5110000032' and t.bsflag='0' and  t.coding_name = '"+hazard_center+"'  ";
										Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
										if (tempMaps != null && tempMaps.size() > 0) {  
										}else{
											message.append("第").append(m + 1).append(
											"行隐患危害类型(小类)系统不存在，请正确选择;"); 
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
				saveImportHidden(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	return responseDTO;
}

 
/**
 * hse隐患信息批量数据保存
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public void saveImportHidden(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合
		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i);    
				String hidden_no = "";  
				String mdetail_no = "";   
				String project=(String) map.get("project");

			//hidden_no,org_sub_id,second_org,third_org,operation_post,hidden_name, identification_method,hazard_big,
			//hazard_center,hidden_level,hidden_type_s,whether_new,rpeople_type,recognition_people,hidden_yuanyin,report_date,hidden_description
			
						String org_sub_id = (String) map.get("org_sub_id");
						String second_org = (String) map.get("second_org");
						String third_org = (String) map.get("third_org"); 
					 
						String operation_post = (String) map.get("operation_post");
						//String hidden_name = (String) map.get("hidden_name");					
						String identification_method = (String) map.get("identification_method");
						String id_method="";
						String hazard_big = (String) map.get("hazard_big");
						String hazard_center = (String) map.get("hazard_center");
						
						String hidden_level = (String) map.get("hidden_level");
						String hi_level="";
						String hidden_type_s = (String) map.get("hidden_type_s");
						String whether_new = (String) map.get("whether_new");
						String wh_new="";
						String rpeople_type = (String) map.get("rpeople_type");
						String recognition_people = (String) map.get("recognition_people");
						String hidden_yuanyin = (String) map.get("hidden_yuanyin");
						String report_date = (String) map.get("report_date");
						String hidden_description = (String) map.get("hidden_description");
						
					//	mdetail_no,evaluation_date,evaluation_level,evaluation_personnel,main_methods,evaluation_state,risk_levels,
				   //rectification_state,rectification_measures_type,rectification_measures,control_effect,rectification_date,  
				  //reward_level,reward_amount,cash_date,reward_state
						
						
						String evaluation_level = (String) map.get("evaluation_level");
						String ev_level="";
						String evaluation_personnel = (String) map.get("evaluation_personnel");
						String main_methods = (String) map.get("main_methods");
						String ma_methods="";
						String risk_levels = (String) map.get("risk_levels");
						String ris_levels="";
						String rectification_state = (String) map.get("rectification_state");
						String re_state="";
						String rectification_measures_type = (String) map.get("rectification_measures_type");
						String rm_type="";
						String rectification_measures = (String) map.get("rectification_measures");
						String control_effect = (String) map.get("control_effect");	
						String co_effect="";
						String rectification_date = (String) map.get("rectification_date");	
						 
						String reward_level = (String) map.get("reward_level");
						String rew_level="";
						String reward_amount = (String) map.get("reward_amount");
						String cash_date = (String) map.get("cash_date");
						
						
						String harmful_consequences = (String) map.get("harmful_consequences");
						String rectification_head = (String) map.get("rectification_head");
						String rectification_people = (String) map.get("rectification_people");
						
						
						if (identification_method != null) {
							if (identification_method.equals("集中识别")) {
								id_method = "1";
							} else if (identification_method.equals("随机识别")) {
								id_method = "2";
							}else if (identification_method.equals("专项识别")) {
								id_method = "3";
							}else if (identification_method.equals("来访者识别")) {
								id_method = "4";
							}else if (identification_method.equals("安全观察与沟通")) {
								id_method = "5";
							}else if (identification_method.equals("工作安全分析")) {
								id_method = "6";
							}else if (identification_method.equals("工艺安全分析")) {
								id_method = "7";
							}else if (identification_method.equals("工艺安全分析")) {
								id_method = "8";
							} 
						} 
					        
						
						//风险等级
						Map applyRiskLevels = jdbcDao
						.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_sort_id='5110000132' and t.bsflag='0' and  t.coding_name = '"
								+ risk_levels+ "'");
				        if (applyRiskLevels != null)
				        	ris_levels = (String) applyRiskLevels.get("coding_code_id");
				        
				      //控制后风险等级
						Map applyControlEffect = jdbcDao
						.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where  t.coding_sort_id='5110000132' and t.bsflag='0' and  t.coding_name = '"
								+ control_effect+ "'");
				        if (applyControlEffect != null)
				        	co_effect = (String) applyControlEffect.get("coding_code_id");
				        
						//大类
						Map applyBigMap = jdbcDao
						.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where  t.coding_sort_id='5110000032' and t.bsflag='0' and  t.coding_name = '"
								+ map.get("hazard_big") + "'");
				        if (applyBigMap != null)
				        	hazard_big = (String) applyBigMap.get("coding_code_id");
				        //中类
				        Map centerMap = jdbcDao
						.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where  t.coding_sort_id='5110000032' and t.bsflag='0' and  t.coding_name = '"
								+ map.get("hazard_center") + "'");
				        if (centerMap != null)
				        	hazard_center= (String) centerMap.get("coding_code_id");
					       

						if (hidden_level != null) {
							if (hidden_level.equals("特大")) {
								hi_level = "1";
							} else if (hidden_level.equals("重大")) {
								hi_level = "2";
							}else if (hidden_level.equals("较大")) {
								hi_level = "3";
							}else if (hidden_level.equals("较大")) {
								hi_level = "4";
							}
						}
						
						if (whether_new != null) {
							if (whether_new.equals("是")) {
								wh_new = "1";
							} else if (whether_new.equals("否")) {
								wh_new = "2";
							}
						}
						
						if (evaluation_level != null) {
							if (evaluation_level.equals("公司")) {
								ev_level = "1";
							} else if (evaluation_level.equals("二级单位")) {
								ev_level = "2";
							}else if (evaluation_level.equals("基层单位")) {
								ev_level = "3";
							}else if (evaluation_level.equals("基层单位下属单位")) {
								ev_level = "4";
							}
						}
						
						if (main_methods != null) {
							if (main_methods.equals("矩阵法")) {
								ma_methods = "1";
							} else if (main_methods.equals("LEC")) {
								ma_methods = "2";
							}else if (main_methods.equals("HAZOP")) {
								ma_methods = "3";
							}else if (main_methods.equals("专家评估法")) {
								ma_methods = "4";
							}else if (main_methods.equals("安全检查表法")) {
								ma_methods = "5";
							}else if (main_methods.equals("默认为矩阵法")) {
								ma_methods = "6";
							}
						}
						
					/*	if (risk_levels != null) {
							if (risk_levels.equals("低风险")) {
								ris_levels = "1";
							} else if (risk_levels.equals("中风险")) {
								ris_levels = "2";
							}else if (risk_levels.equals("高风险")) {
								ris_levels = "3";
							} 
						}*/
						
						if (rectification_state != null) {
							if (rectification_state.equals("已整改")) {
								re_state = "1";
							} else if (rectification_state.equals("未整改")) {
								re_state = "2";
							}else if (rectification_state.equals("正在整改")) {
								re_state = "3";
							} 
						}
						
						if (rectification_measures_type != null) {
							if (rectification_measures_type.equals("消除")) {
								rm_type = "1";
							} else if (rectification_measures_type.equals("工程/设计")) {
								rm_type = "2";
							}else if (rectification_measures_type.equals("行政/程序")) {
								rm_type = "3";
							}else if (rectification_measures_type.equals("劳保")) {
								rm_type = "4";
							}
						}
						
					/*	if (control_effect != null) {
							if (control_effect.equals("消除")) {
								co_effect = "1";
							} else if (control_effect.equals("降低")) {
								co_effect = "2";
							}
						}*/
					   
						if (reward_level != null) {
							if (reward_level.equals("公司")) {
								rew_level = "1";
							} else if (reward_level.equals("二级单位")) {
								rew_level = "2";
							}else if (reward_level.equals("基层单位")) {
								rew_level = "3";
							}else if (reward_level.equals("基层单位下属单位")) {
								rew_level = "4";
							}
						}
					  
				Map tempMap = new HashMap(); 
				tempMap.put("org_sub_id",org_sub_id );
				tempMap.put("second_org", second_org);
				tempMap.put("third_org",third_org );
				tempMap.put("operation_post",operation_post );
				//tempMap.put("hidden_name", hidden_name);
				tempMap.put("identification_method",id_method );
				tempMap.put("hazard_big", hazard_big);
				tempMap.put("hazard_center",hazard_center );
				tempMap.put("whether_new",wh_new );
				tempMap.put("recognition_people", recognition_people);
				tempMap.put("report_date",report_date );
				tempMap.put("hidden_level", hi_level);
				tempMap.put("hidden_description",hidden_description );
				tempMap.put("rpeople_type", rpeople_type);
				tempMap.put("hidden_yuanyin", hidden_yuanyin);
				tempMap.put("hidden_type_s", hidden_type_s);
				 
				tempMap.put("updator", user.getUserName());
				tempMap.put("modifi_date", new Date());
				tempMap.put("bsflag", "0"); 
				tempMap.put("subflag", "0"); 
				tempMap.put("create_date", new Date());
				tempMap.put("creator", user.getUserName());
				
					if(project.equals("2")){
						tempMap.put("project_no", user.getProjectInfoNo());
					} 
				//jdbcDao.saveOrUpdateEntity(tempMap, "BGP_HSE_HIDDEN_INFORMATION"); // 保存
				Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"BGP_HSE_HIDDEN_INFORMATION");
				hidden_no = id.toString();
				
					if (!ris_levels.equals("")){
						Map tempMapA= new HashMap(); 
						tempMapA.put("hidden_no",hidden_no);
						tempMapA.put("subflag", "1"); 
		 		        jdbcDao.saveOrUpdateEntity(tempMapA, "BGP_HSE_HIDDEN_INFORMATION"); // 保存
					}
				
				Map tempMapB = new HashMap(); 
				tempMapB.put("mdetail_no","" );
				tempMapB.put("hidden_no",hidden_no );
				tempMapB.put("evaluation_date",new Date() );
				tempMapB.put("evaluation_level",ev_level );
				tempMapB.put("evaluation_personnel",evaluation_personnel );
				tempMapB.put("main_methods",ma_methods);
				tempMapB.put("risk_levels",ris_levels );
					if (!ris_levels.equals("")){
					tempMapB.put("evaluation_state","已评价" );
					}else{
					tempMapB.put("evaluation_state","未评价" );
					}
				
					tempMapB.put("harmful_consequences",harmful_consequences);
					tempMapB.put("rectification_head",rectification_head);
					tempMapB.put("rectification_people",rectification_people);
					
				tempMapB.put("rectification_state",re_state);
				tempMapB.put("rectification_measures_type",rm_type);
				tempMapB.put("rectification_measures",rectification_measures );
				tempMapB.put("control_effect",co_effect);
				tempMapB.put("rectification_date",rectification_date);
				
				tempMapB.put("reward_level",rew_level);
				tempMapB.put("reward_amount",reward_amount);
				tempMapB.put("cash_date",cash_date);
					if (!rew_level.equals("")){
					     tempMapB.put("reward_state","已奖励");
					}else{
						tempMapB.put("reward_state","未奖励");
					}
				 
				tempMapB.put("updator", user.getUserName());
				tempMapB.put("modifi_date", new Date());
				tempMapB.put("bsflag", "0"); 
				tempMapB.put("create_date", new Date());
				tempMapB.put("creator", user.getUserName());
				
 		        jdbcDao.saveOrUpdateEntity(tempMapB, "BGP_HIDDEN_INFORMATION_DETAIL"); // 保存
				
				
		 
		}
	}
}



public ISrvMsg queryHidden(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	
	String check_date = isrvmsg.getValue("check_date");
	String check_dateA = isrvmsg.getValue("check_dateA");
	String second = isrvmsg.getValue("second_org");
	String third = isrvmsg.getValue("third_org");
	String fourth = isrvmsg.getValue("fourth_org");
	
	
	String sql = "select sd1.coding_code_id,       sd1.coding_name,       sum(case     when qd.hidden_no is null  then     0   else    1   end) num  from Comm_Coding_Sort_Detail sd1  left join BGP_HSE_HIDDEN_INFORMATION qd    on qd.hazard_center = sd1.coding_code_id   and qd.bsflag = '0'   "; 
     	   if(second!=null&&!second.equals("")){
     		   sql = sql + " and qd.org_sub_id like'"+second+"%' ";
     	   }
     	   if(third!=null&&!third.equals("")){
     		   sql = sql + " and qd.second_org like'"+third+"%' ";
     	   }
     	   if(fourth!=null&&!fourth.equals("")){
     		   sql = sql + " and qd.third_org like'"+fourth+"%' ";
     	   }
     		if(check_date!=null && !check_date.equals("")){
    			sql = sql+" and qd.report_date >= to_date('"+check_date+"','yyyy-MM-dd') ";
    		}
    		if(check_dateA!=null && !check_dateA.equals("")){
    			sql = sql+" and qd.report_date <= to_date('"+check_dateA+"','yyyy-MM-dd') ";
    		}
    		 
           sql = sql + "   where sd1.superior_code_id  like  '5110000032%'   and sd1.bsflag = '0'    group by sd1.coding_code_id, sd1.coding_name order by sd1.coding_code_id ";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	
	String Str = "<chart caption='隐患分类统计'  yAxisName='数量' baseFontSize ='12'  yAxisNameWidth='16' rotateYAxisName='0'  labelDisplay='WRAP'   >";
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


public ISrvMsg queryHiddenA(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	
	String check_date = isrvmsg.getValue("check_date");
	String check_dateA = isrvmsg.getValue("check_dateA");
	String second = isrvmsg.getValue("second_org");
	String third = isrvmsg.getValue("third_org");
	String fourth = isrvmsg.getValue("fourth_org");
	
	
	String sql = "select ht.hidden_type,    sum(case      when qd.hidden_no is null then     0     else   1    end) nums  from (select '民爆物品' hidden_type      from dual      union    select '交通伤害' hidden_type      from dual     union      select '机械伤害' hidden_type      from dual     union     select '火灾' hidden_type      from dual     union     select '触电' hidden_type     from dual      union    select '起重伤害' hidden_type     from dual     union     select '水上作业' hidden_type     from dual     union     select '淹溺' hidden_type      from dual   union    select '灼烫' hidden_type    from dual     union     select '高处坠落' hidden_type    from dual    union    select '坍塌' hidden_type   from dual     union   select '锅炉压力容器' hidden_type    from dual     union        select '环境' hidden_type   from dual        union        select '职业健康' hidden_type    from dual    union    select '职业禁忌症' hidden_type    from dual     union     select '疫情' hidden_type  from dual    union      select '中毒和窒息' hidden_type     from dual     union        select '其他' hidden_type from dual  ) ht  left join BGP_HSE_HIDDEN_INFORMATION qd   on qd.hidden_type_s = ht.hidden_type   and qd.bsflag = '0'   and qd.hidden_type_s is not null  "; 
     	   if(second!=null&&!second.equals("")){
     		   sql = sql + " and qd.org_sub_id like'"+second+"%' ";
     	   }
     	   if(third!=null&&!third.equals("")){
     		   sql = sql + " and qd.second_org like'"+third+"%' ";
     	   }
     	   if(fourth!=null&&!fourth.equals("")){
     		   sql = sql + " and qd.third_org like'"+fourth+"%' ";
     	   }
     		if(check_date!=null && !check_date.equals("")){
    			sql = sql+" and qd.report_date >= to_date('"+check_date+"','yyyy-MM-dd') ";
    		}
    		if(check_dateA!=null && !check_dateA.equals("")){
    			sql = sql+" and qd.report_date <= to_date('"+check_dateA+"','yyyy-MM-dd') ";
    		}
    		 
           sql = sql + "     group by ht.hidden_type ";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	
	String Str = "<chart caption='隐患产生影响分布'  yAxisName='数量' baseFontSize ='12'  yAxisNameWidth='16' rotateYAxisName='0'  labelDisplay='WRAP'   >";
	for(int i=0;i<list.size();i++){
		Map map = (Map)list.get(i);
		String  codingName = (String)map.get("hiddenType");
		String  num = (String)map.get("nums");
		Str = Str+"<set value='"+num+"' label='"+codingName+"'/>";
	}
	Str = Str+"</chart>";
	System.out.println("Str = " + Str);
	
	responseDTO.setValue("Str", Str);
	return responseDTO;
 
	
}


public ISrvMsg queryHiddenC(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	
	String check_date = isrvmsg.getValue("check_date");
	String check_dateA = isrvmsg.getValue("check_dateA");
	String second = isrvmsg.getValue("second_org");
	String third = isrvmsg.getValue("third_org");
	String fourth = isrvmsg.getValue("fourth_org");
	
	
	String sql = "select ht.rpeople_type,    sum(case      when qd.hidden_no is null then     0     else   1    end) nums  from (select '机关管理人员' rpeople_type      from dual      union    select '直线管理者' rpeople_type      from dual     union      select 'HSE专业人员（管理和监督）' rpeople_type      from dual     union     select '操作岗位员工（合同化）' rpeople_type      from dual     union     select '操作岗位员工（市场化）' rpeople_type     from dual      union    select '季节性临时用工' rpeople_type     from dual     union     select '承包商员工' rpeople_type     from dual     ) ht    left join BGP_HSE_HIDDEN_INFORMATION qd   on qd.rpeople_type = ht.rpeople_type   and qd.bsflag = '0'   and qd.rpeople_type is not null    "; 
     	   if(second!=null&&!second.equals("")){
     		   sql = sql + " and qd.org_sub_id like'"+second+"%' ";
     	   }
     	   if(third!=null&&!third.equals("")){
     		   sql = sql + " and qd.second_org like'"+third+"%' ";
     	   }
     	   if(fourth!=null&&!fourth.equals("")){
     		   sql = sql + " and qd.third_org like'"+fourth+"%' ";
     	   }
     		if(check_date!=null && !check_date.equals("")){
    			sql = sql+" and qd.report_date >= to_date('"+check_date+"','yyyy-MM-dd') ";
    		}
    		if(check_dateA!=null && !check_dateA.equals("")){
    			sql = sql+" and qd.report_date <= to_date('"+check_dateA+"','yyyy-MM-dd') ";
    		}
    		 
           sql = sql + "    group by ht.rpeople_type  ";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	
	String Str = "<chart caption='隐患汇报人分布'  yAxisName='数量' baseFontSize ='12'  yAxisNameWidth='16' rotateYAxisName='0'  labelDisplay='WRAP'   >";
	for(int i=0;i<list.size();i++){
		Map map = (Map)list.get(i);
		String  codingName = (String)map.get("rpeopleType");
		String  num = (String)map.get("nums");
		Str = Str+"<set value='"+num+"' label='"+codingName+"'/>";
	}
	Str = Str+"</chart>";
	System.out.println("Str = " + Str);
	
	responseDTO.setValue("Str", Str);
	return responseDTO;
 
	
}




public ISrvMsg queryHiddenD(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	
	String check_date = isrvmsg.getValue("check_date");
	String check_dateA = isrvmsg.getValue("check_dateA");
	String second = isrvmsg.getValue("second_org");
	String third = isrvmsg.getValue("third_org");
	String fourth = isrvmsg.getValue("fourth_org");
	
	
	String sql = " select t.org_code,     t.org_short_name,   sum(case   when qd.hidden_no is null then    0     else    1    end) nums,   decode(te.num_a, '', '0', te.num_a) num_a    from pub_org t     left join BGP_HSE_HIDDEN_INFORMATION qd    on qd.ORG_SUB_ID = t.org_code     and qd.bsflag = '0'   and qd.hidden_no is not null      left join (select sum(case        when bt.hidden_no is null then        0     else      1   end) num_a,     bt.ORG_SUB_ID      from BGP_HSE_HIDDEN_INFORMATION bt     left join BGP_HIDDEN_INFORMATION_DETAIL bdl     on bt.hidden_no = bdl.hidden_no    and bdl.bsflag = '0'   where bdl.rectification_state = '2'       and bt.bsflag = '0'   group by bt.ORG_SUB_ID) te    on te.ORG_SUB_ID = qd.ORG_SUB_ID     where (t.org_id = 'C6000000000001' or    t.parent_org_id = 'C6000000000001')     group by t.org_code, t.org_short_name, te.num_a,  t.P_ORDER    order by  t.P_ORDER   "; 
      
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	
	String Str = "<chart caption='单位隐患识别统计'    yAxisName='数量' baseFontSize ='12'  yAxisNameWidth='16' rotateYAxisName='0'  labelDisplay='WRAP'   >";
	Str=Str+"<categories> ";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  codingName = (String)map.get("orgShortName");	 
			Str = Str+"<category label='"+codingName+"'/>";
		}
	Str = Str+"</categories>";
	Str = Str+"<dataset SeriesName='隐患数量'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  nums = (String)map.get("nums");	 
			Str = Str+"	<set value='"+nums+"' />";
		} 
	Str = Str+"</dataset>";
	
	Str = Str+"<dataset SeriesName='未整改隐患数量'>";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  numA = (String)map.get("numA");
			Str = Str+"	<set value='"+numA+"' />";
		} 
	Str = Str+"</dataset>";
	
	Str = Str+"</chart>";
	System.out.println("Str = " + Str);	
	responseDTO.setValue("Str", Str);
	return responseDTO;
 
	
}

//5.4.3 建设项目“三个同时”  特种设备
public ISrvMsg importExcelSpecialDev(ISrvMsg reqDTO) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
	UserToken user = reqDTO.getUserToken();	
	String project= reqDTO.getValue("project"); // 是否多项目
	String project_three_ids = reqDTO.getValue("project_three_ids");
	
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
				for (int m = 2; m <= sheet.getLastRowNum(); m++) {
					row = sheet.getRow(m);
					
					String detail_name = "";
					String detail_model = "";
					String detail_quantity = "";
					String approval_conditions = "";
		
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <4; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								detail_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("detail_name", detail_name);
								break;
							case 1:
								ss.setCellType(1);
								detail_model = ss.getStringCellValue().trim();
								tempMap.put("detail_model", detail_model);
								break; 
							case 2:
								ss.setCellType(1);
								detail_quantity = ss.getStringCellValue().trim();
								tempMap.put("detail_quantity", detail_quantity);
								break; 
				 
							case 3:
								ss.setCellType(1);
								approval_conditions = ss.getStringCellValue().trim();
								tempMap.put("approval_conditions", approval_conditions);
								break; 
							 
								default:
								break;
							}
						}
					}
				     	
					if (message.toString().equals("")) {
						tempMap.put("project_three_id", project_three_ids);
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
				saveSpecialDev(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	responseDTO.setValue("project_three_ids", project_three_ids);
	return responseDTO;
}


public void saveSpecialDev(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合
		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i);    
				String project_three_id = map.get("project_three_id") ==null ? "" : (String)map.get("project_three_id");
				String detail_name = map.get("detail_name") ==null ? "" : (String)map.get("detail_name");
				String detail_model = map.get("detail_model") == null ? "" : (String)map.get("detail_model");
				String detail_quantity = map.get("detail_quantity") == null ? "" : (String)map.get("detail_quantity");
				String approval_conditions = map.get("approval_conditions") ==null ? "" : (String)map.get("approval_conditions");
				
				if(approval_conditions.equals("是")){
					approval_conditions = "1";
				} 
				if(approval_conditions.equals("否")){
					approval_conditions = "2";
				}
					  
				Map tempMap = new HashMap(); 
				tempMap.put("PROJECT_THREE_ID", project_three_id);
				tempMap.put("DETAIL_NAME",detail_name);
				tempMap.put("DETAIL_MODEL",detail_model);
				tempMap.put("DETAIL_QUANTITY", detail_quantity);
				tempMap.put("APPROVAL_CONDITIONS",approval_conditions);
				tempMap.put("CREATOR", user.getUserId());
				tempMap.put("CREATE_DATE",new Date() );
				tempMap.put("UPDATOR",user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG","0" );
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"BGP_HSE_PROJCT_DETAIL");
				
		}
	}
}


//5.4.3 建设项目“三个同时”  特种作业人员
public ISrvMsg importExcelSpecialHuman(ISrvMsg reqDTO) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
	UserToken user = reqDTO.getUserToken();	
	String project= reqDTO.getValue("project"); // 是否多项目
	String project_three_ids = reqDTO.getValue("project_three_ids");
	
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
				for (int m = 2; m <= sheet.getLastRowNum(); m++) {
					row = sheet.getRow(m);
					
					String special_name = "";
					String special_sex = "";
					String special_code = "";
					String special_age = "";
					String work_type = "";
					String certificate_name = "";
					String certificate_date = "";
					
		
					Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																					// 集合
					for (int j = 0; j <7; j++) {
						Cell ss = row.getCell(j);
						if (ss != null && !"".equals(ss.toString())) {
							switch (j) {
							case 0:
								ss.setCellType(1);
								special_name = ss.getStringCellValue().trim(); // 对应赋值
								tempMap.put("special_name", special_name);
								break;
							case 1:
								ss.setCellType(1);
								special_sex = ss.getStringCellValue().trim();
								tempMap.put("special_sex", special_sex);
								break; 
							case 2:
								ss.setCellType(1);
								special_code = ss.getStringCellValue().trim();
								tempMap.put("special_code", special_code);
								break; 
							case 3:
								ss.setCellType(1);
								special_age = ss.getStringCellValue().trim();
								tempMap.put("special_age", special_age);
								break; 
							case 4:
								ss.setCellType(1);
								work_type = ss.getStringCellValue().trim();
								tempMap.put("work_type", work_type);
								break; 
							case 5:
								ss.setCellType(1);
								certificate_name = ss.getStringCellValue().trim();
								tempMap.put("certificate_name", certificate_name);
								break; 
							case 6:
								ss.setCellType(1);
								certificate_date = ss.getStringCellValue().trim();
								tempMap.put("certificate_date", certificate_date);
								break; 	
							 
								default:
								break;
							}
						}
					}
				     	
					if (message.toString().equals("")) {
						tempMap.put("project_three_id", project_three_ids);
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
				saveSpecialHuman(datelist, user); // 调用保存方法
			}
			responseDTO.setValue("message", "导入成功!");

		}
	}
	responseDTO.setValue("project", project);
	responseDTO.setValue("project_three_ids", project_three_ids);
	return responseDTO;
}


public void saveSpecialHuman(List datelist, UserToken user) {
	if (datelist != null && datelist.size() > 0) { // 表格数据list集合
		for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
			Map map = (HashMap) datelist.get(i);    
				String project_three_id = map.get("project_three_id") ==null ? "" : (String)map.get("project_three_id");
				String special_name = map.get("special_name") ==null ? "" : (String)map.get("special_name");
				String special_sex = map.get("special_sex") == null ? "" : (String)map.get("special_sex");
				String special_code = map.get("special_code") == null ? "" : (String)map.get("special_code");
				String special_age = map.get("special_age") ==null ? "" : (String)map.get("special_age");
				String work_type = map.get("work_type") ==null ? "" : (String)map.get("work_type");
				String certificate_name = map.get("certificate_name") ==null ? "" : (String)map.get("certificate_name");
				String certificate_date = map.get("certificate_date") ==null ? "" : (String)map.get("certificate_date");
				
				if(special_sex.equals("男")){
					special_sex = "1";
				} 
				if(special_sex.equals("女")){
					special_sex = "0";
				}
					  
				Map tempMap = new HashMap(); 
				tempMap.put("PROJECT_THREE_ID", project_three_id);
				tempMap.put("SPECIAL_NAME",special_name);
				tempMap.put("SPECIAL_SEX",special_sex);
				tempMap.put("SPECIAL_CODE", special_code);
				tempMap.put("SPECIAL_AGE",special_age);
				tempMap.put("WORK_TYPE", work_type);
				tempMap.put("CERTIFICATE_NAME",certificate_name);
				tempMap.put("CERTIFICATE_DATE", certificate_date);
				tempMap.put("CREATOR", user.getUserId());
				tempMap.put("CREATE_DATE",new Date() );
				tempMap.put("UPDATOR",user.getUserId());
				tempMap.put("MODIFI_DATE", new Date());
				tempMap.put("BSFLAG","0" );
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"BGP_HSE_PROJCT_HUMAN");
				
		}
	}
}






/*
 * hse隐患信息数据导出
 */
public ISrvMsg exportHseHidden(ISrvMsg reqDTO) throws Exception {
	MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
	UserToken user = reqDTO.getUserToken();
	String projectInfoNo = user.getProjectInfoNo(); 
 
	String project = reqDTO.getValue("project");
	String check_date = reqDTO.getValue("check_date");
	String check_date_a = reqDTO.getValue("check_date_a");
	String all_value = reqDTO.getValue("all_value"); 
	

	String orgStr="";	
	String org_subjection_id = user.getOrgSubjectionId();
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	
	List listOrg = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	if (listOrg != null && listOrg.size() > 0) {
		for(int i = 0;i < listOrg.size();i++){
		Map orgMap = (Map)listOrg.get(i); 
		String organFlag = (String)orgMap.get("organFlag");
		if(i==0){
				if(!organFlag.equals("0")){
					orgStr = " and tr.org_sub_id = '" + (String)orgMap.get("orgSubId") +"' ";
				}
		}
		if(i==1){
			if(!organFlag.equals("0")){
				orgStr = " and tr.second_org = '" + (String)orgMap.get("orgSubId") +"' ";
			}
		}
		if(i==2){
			if(!organFlag.equals("0")){
				orgStr = " and tr.third_org = '" + (String)orgMap.get("orgSubId") +"' ";
			}
		}
		
		   }

		}
	
	StringBuilder subsql = new StringBuilder(); 
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../hse/hseOptionPage/hseHiddenTwo/exportHiddenMessage.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "org_sub_id_name", "second_org_name", "third_org_name", "operation_post", "identification_method", "hazard_big", "hazard_center", "hidden_level", "hidden_type_s", "whether_new",
				"rpeople_type", "recognition_people", "hidden_yuanyin", "report_date", "hidden_description", "evaluation_level", "evaluation_personnel", "main_methods", "harmful_consequences", "risk_levels",
				"rectification_state", "rectification_measures_type", "rectification_measures", "control_effect", "rectification_head", "rectification_people", "rectification_date", "reward_level", "reward_amount", "cash_date"};
		
		
		subsql.append("select    ion.org_abbreviation as org_sub_id_name ,   oi1.org_abbreviation as second_org_name,       oi2.org_abbreviation as third_org_name,   tr.operation_post, decode (tr.identification_method,'1','集中识别','2','随机识别','3','专项识别','4','来访者识别','5','安全观察与沟通','6','工作安全分析','7','工艺安全分析','8','其它') identification_method,  csd1.coding_name as hazard_big ,csd2.coding_name as hazard_center ,decode (tr.hidden_level,'1','特大','2','重大','3','较大','4','一般') hidden_level,tr.hidden_type_s,decode(tr.whether_new,'1','是','2','否')whether_new,  tr.rpeople_type,tr.recognition_people,tr.hidden_yuanyin,tr.report_date,tr.hidden_description,decode (hdl.evaluation_level,'1','公司','2','二级单位','3','基层单位','4','基层单位下属单位') evaluation_level,hdl.evaluation_personnel,  decode (hdl.main_methods,'1','矩阵法','2','LEC','3','HAZOP','4','专家评估法','5','安全检查表法','6','默认为矩阵法') main_methods,hdl.harmful_consequences,cdl.coding_name as risk_levels,  decode (hdl.rectification_state,'1','已整改','2','未整改','3','正在整改') rectification_state,decode (hdl.evaluation_level,'1','消除','2','工程/设计','3','行政/程序','4','劳保') rectification_measures_type,hdl.rectification_measures,csd3.coding_name  control_effect ,  hdl.rectification_head,hdl.rectification_people,hdl.rectification_date,decode (hdl.reward_level,'1','公司','2','二级单位','3','基层单位','4','基层单位下属单位') reward_level,hdl.reward_amount,hdl.cash_date  from BGP_HSE_HIDDEN_INFORMATION tr   left join comm_coding_sort_detail csd1  on csd1.coding_code_id= tr.hazard_big and csd1.bsflag='0'    left join comm_coding_sort_detail csd2  on csd2.coding_code_id= tr.hazard_center and csd2.bsflag='0'  left join comm_org_subjection os1  on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'  left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'  left join comm_org_subjection ose  on tr.org_sub_id = ose.org_subjection_id  and ose.bsflag = '0'  left join comm_org_information ion  on ion.org_id = ose.org_id  left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no = tr.hidden_no  and hdl.bsflag = '0'  left join comm_coding_sort_detail cdl  on cdl.coding_code_id = hdl.risk_levels  and cdl.bsflag = '0'  left join comm_coding_sort_detail csd3  on csd3.coding_code_id = hdl.control_effect  and csd3.bsflag = '0'  where tr.bsflag = '0'  ");
        if (all_value.equals("1")){
        	
        	if(project.equals("1")){
        		subsql.append(orgStr);
        		//subsql.append(" and tr.org_sub_id  like  '"+user.getSubOrgIDofAffordOrg()+"%'  ");
        	}else if (project.equals("2")){        		
        		subsql.append(" and tr.project_no= '"+projectInfoNo+"'");
        		
        	}

        	if(check_date!=null && !check_date.equals("")){
        		subsql.append(" and tr.report_date >= to_date('"+check_date+"','yyyy-MM-dd') ");
        		}
        		if(check_date_a!=null && !check_date_a.equals("")){
        			subsql.append(" and tr.report_date <= to_date('"+check_date_a+"','yyyy-MM-dd') ");
        		}
        	
        }else if (all_value.equals("2")) {
        			if(project.equals("1")){
        				subsql.append(orgStr);
		        		//subsql.append(" and tr.org_sub_id  like  '"+user.getSubOrgIDofAffordOrg()+"%'  ");
		        	}else if (project.equals("2")){        		
		        		subsql.append(" and tr.project_no= '"+projectInfoNo+"'");
		        		
		        	}
        	
        }
		
	    subsql.append("  order by hdl.rectification_state desc ");
      

		List<Map> list =  BeanFactory.getPureJdbcDAO().queryRecords( subsql.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("HSE隐患信息.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		 
	
	return mqmsgimpl;

}






	
}

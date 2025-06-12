package com.bgp.mcs.service.pm.service.wr;
import java.io.ByteArrayInputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 生产周报数据抽取
 * 
 * 屈克将
 * 
 * 2011-08-24
 *
 */
@SuppressWarnings({ "unchecked"})
public class DataExtractSrv extends BaseService{

	private RADJdbcDao radDao;
	private JdbcTemplate jdbcTemplate;
	public DataExtractSrv() {
		radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
        jdbcTemplate = radDao.getJdbcTemplate();
	}
	private IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();
	private IPureJdbcDao  jdbcDaos=BeanFactory.getPureJdbcDAO();
	
	/**
	 * 抽取地震采集项目情况数据
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAcqProjectInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
//		String week_date = reqDTO.getValue("week_date");
		String week_end_date = reqDTO.getValue("week_end_date");

		String sumStartDate = week_end_date.substring(0, 4)+"-01-01";
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("select count(distinct p.project_info_no) from gp_task_project p join gp_task_project_dynamic pd on p.project_info_no=pd.project_info_no");
		sb.append(" where p.bsflag='0' and pd.bsflag='0'");
		sb.append(" and pd.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%'");
		sb.append(" and p.project_status=? and p.project_country=?");
		
		String sql = sb.toString();

		sb = new StringBuffer();
		sb.append("select count(distinct p.project_info_no) from gp_task_project p join gp_task_project_dynamic pd on p.project_info_no=pd.project_info_no");
		sb.append(" where p.bsflag='0' and pd.bsflag='0'");
		sb.append(" and pd.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%'");
		sb.append(" and p.project_status='5000100001000000003' and p.project_country=?");
		sb.append(" and to_char(p.modifi_date,'yyyy-MM-dd') between '").append(sumStartDate).append("' and '").append(week_end_date).append("'");
		
		String sql2 = sb.toString();
		
		List list = new ArrayList();
		
		Map inner = new HashMap();
		inner.put("prepare_num", jdbcTemplate.queryForInt(sql, new Object[]{"5000100001000000001","1"}));
		inner.put("construct_num", jdbcTemplate.queryForInt(sql, new Object[]{"5000100001000000002","1"}));
		inner.put("end_num", jdbcTemplate.queryForInt(sql2, new Object[]{"1"}));
		list.add(inner);

		Map outter = new HashMap();
		outter.put("prepare_num", jdbcTemplate.queryForInt(sql, new Object[]{"5000100001000000001","2"}));
		outter.put("construct_num", jdbcTemplate.queryForInt(sql, new Object[]{"5000100001000000002","2"}));
		outter.put("end_num", jdbcTemplate.queryForInt(sql2, new Object[]{"2"}));
		list.add(outter);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", list);
		return msg;
	}

	/**
	 * 抽取重点项目动态数据
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getStressProjectInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("select distinct p.project_info_no,p.project_name from gp_task_project p join gp_task_project_dynamic pd on p.project_info_no=pd.project_info_no");
		sb.append(" where p.bsflag='0' and pd.bsflag='0'");
		sb.append(" and pd.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%'");
		sb.append(" and p.is_main_project in('0300100008000000001','0300100008000000002') and p.project_status='5000100001000000002'");
		
		List list = jdbcTemplate.queryForList(sb.toString());
		List newList = new ArrayList();
		
		// 把key小写
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			Map newMap = new HashMap();
			newMap.put("project_info_no", map.get("PROJECT_INFO_NO"));
			newMap.put("project_name", map.get("PROJECT_NAME"));
			newList.add(newMap);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", newList);
		return msg;
	}

	/**
	 * 抽取地震采集项目运行动态数据
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectDynamicInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		
		String week_date = reqDTO.getValue("week_date");
		String week_end_date = reqDTO.getValue("week_end_date");
		StringBuffer sb = new StringBuffer();
		
		sb.append("select p.project_name, csd1.coding_name as manage_org, ot.team_id as team_name, pd.design_object_workload as design_workload");
		sb.append(", (select sum(nvl(r.daily_acquire_workload, 0)) + sum(nvl(r.daily_jp_acquire_workload, 0)) + sum(nvl(r.daily_qq_acquire_workload, 0)) from gp_ops_daily_report r where r.project_info_no = p.project_info_no and r.bsflag = '0' and r.audit_status = '3' and p.exploration_method = r.exploration_method and to_char(r.produce_date, 'yyyy-MM-dd') <= '").append(week_end_date).append("') as complete_workload ");
		sb.append(", (select case s.if_build when '1' then '动迁' when '2' then '踏勘' when '3' then '试验' when '4' then '测量' when '5' then '钻井' when '6' then '采集' when '7' then '停工' when '8' then '暂停' when '9' then '结束' else '' end as if_build from gp_ops_daily_report r join gp_ops_daily_produce_sit s on s.daily_no = r.daily_no where r.project_info_no = p.project_info_no and r.bsflag = '0' and r.audit_status = '3' and p.exploration_method = r.exploration_method and to_char(r.produce_date, 'yyyy-MM-dd') <= '").append(week_end_date).append("' and rownum = 1) as notes");
		sb.append(" from gp_task_project p join gp_task_project_dynamic pd on p.project_info_no = pd.project_info_no and p.exploration_method = pd.exploration_method join comm_coding_sort_detail csd1 on csd1.coding_code_id = p.manage_org join comm_org_team ot on ot.org_id = pd.org_id");
		sb.append(" where p.bsflag = '0' and pd.bsflag = '0' and p.project_info_no in (select distinct project_info_no from gp_ops_daily_report r where r.bsflag = '0' and to_char(r.produce_date, 'yyyy-MM-dd') between '").append(week_date).append("' and '").append(week_end_date).append("' and r.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%')");

		List list = jdbcTemplate.queryForList(sb.toString());
		List newList = new LinkedList();

		// 把key小写
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			Map newMap = new HashMap();
			newMap.put("project_name", map.get("PROJECT_NAME"));
			newMap.put("manage_org", map.get("MANAGE_ORG"));
			newMap.put("team_name", map.get("TEAM_NAME"));
			String notes = (String)map.get("NOTES");
			if(!"采集".equals(notes)){
				newMap.put("notes", map.get("NOTES"));
			}
			
			BigDecimal design_workload = (BigDecimal)(map.get("DESIGN_WORKLOAD"));
			if(design_workload==null || design_workload.equals("")) design_workload=new BigDecimal(0);
			newMap.put("design_workload", design_workload);

			BigDecimal complete_workload = (BigDecimal)(map.get("COMPLETE_WORKLOAD"));
			if(complete_workload==null || complete_workload.equals("")) complete_workload=new BigDecimal(0);
			newMap.put("complete_workload", complete_workload);
			
			BigDecimal schedule=new BigDecimal(0);
			if(design_workload.compareTo(new BigDecimal(0))>0){
				schedule = complete_workload.multiply(new BigDecimal(100)).divide(design_workload, 2, BigDecimal.ROUND_HALF_EVEN);
			}
			newMap.put("schedule", schedule);
			
			int index=0;
			// 根据schedule的值，按照从小到大的顺序，在newList中寻找合适的位置
			for(;index<newList.size();index++){
				BigDecimal compareSchedule = (BigDecimal)((Map)newList.get(index)).get("schedule");
				if(schedule.compareTo(compareSchedule)<0){
					break;
				}
			}
			newList.add(index, newMap);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", newList);
		return msg;
	}


	/**
	 * 抽取处理解释项目运行动态数据，抽取的是最近审批通过的一期数据
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSIProjectDynamicInfo(ISrvMsg reqDTO) throws Exception {
		
		String projectType = reqDTO.getValue("project_type");
		String orgId = reqDTO.getValue("org_id");
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("select * from BGP_WR_PROJECT_DYNAMIC where week_date=(");
		sb.append(" select max(t.week_date) from BGP_WR_PROJECT_DYNAMIC t where t.bsflag='0' and t.subflag='1' ");
		sb.append(" and t.project_type='").append(projectType).append("'");
		sb.append(" and t.org_id = '").append(orgId).append("')");
		sb.append(" and org_id = '").append(orgId).append("'");
		sb.append(" and project_type='").append(projectType).append("' and bsflag='0'");
		
		List list = jdbcTemplate.queryForList(sb.toString());
		List newList = new LinkedList();

		// 把key小写
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			Map newMap = new HashMap();
			Iterator it = map.keySet().iterator();
			
			while(it.hasNext()){
				String key = (String)it.next();
				Object value = map.get(key);
				newMap.put(key.toLowerCase(), value);
			}
			
			newList.add(newMap);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", newList);
		return msg;
	}


	/**
	 * 抽取非地震项目运行动态数据，抽取的是上一期的数据，和处理解释的逻辑一致，直接调用
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIPCEProjectDynamicInfo(ISrvMsg reqDTO) throws Exception {
		
		return getSIProjectDynamicInfo(reqDTO);
		
	}

	/*
	 * 抽取地震仪器的设备使用情况
	 * 
	 * @param reqDTO
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	public ISrvMsg getSeismicInstrumentInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();

		StringBuffer sqlBuffer = new StringBuffer(
				"SELECT PA.CLASSIFY_MODEL,PA.ALL_NUM,PB.ALL_TRACKS_NUM,PA.USE_NUM,PB.USE_TRACKS_NUM,PA.OBSOLESCENT_NUM,PB.OBSOLESCENT_TRACKS_NUM ")
				.append(" FROM (SELECT TB.CLASSIFY_MODEL, TB.ALL_NUM, TB.USE_NUM, TB.OBSOLESCENT_NUM ")
				.append(" FROM (SELECT CLASSIFY_MODEL, SUM(DECODE(DA.DEVICE_ACCOUNT_ID, NULL, 0, 1)) ALL_NUM, ")
				.append(" SUM(DECODE(DA.DEVICE_ACCOUNT_ID, NULL, 0, DECODE(DA.USAGE_STATUS, '0110000007000000001', '1', '0'))) USE_NUM, ")
				.append(" SUM(DECODE(DA.DEVICE_ACCOUNT_ID, NULL, 0, DECODE(DA.USAGE_STATUS, '0110000006000000005', '1', '0'))) OBSOLESCENT_NUM ")
				.append(" FROM (SELECT CR.DEVICE_NAME, CR.DEVICE_SPECIFICATION, CR.CLASSIFY_MODEL  FROM BGP_COMM_DEVICE_COMPARE_REL CR ")
				.append(" INNER JOIN (SELECT CODING_NAME AS CLASSIFY_MODEL FROM COMM_CODING_SORT_DETAIL ")
				.append(" WHERE CODING_SORT_ID = '5000300003' AND CODING_CODE LIKE '02%' AND END_IF = '1' AND BSFLAG = '0') CM ")
				.append(" ON CR.CLASSIFY_MODEL = CM.CLASSIFY_MODEL AND CR.BSFLAG = '0' AND CR.DEVICE_TYPE = '2') CI ")
				.append(" LEFT OUTER JOIN BGP_COMM_DEVICE_ACCOUNT DA ON CI.DEVICE_NAME = DA.DEVICE_NAME ")
				.append(" AND CI.DEVICE_SPECIFICATION = DA.DEVICE_SPECIFICATION AND DA.BSFLAG = '0' AND (DA.OWNING_SUBJECTION_ORG_ID LIKE '"
						+ user.getSubOrgIDofAffordOrg()
						+ "%' and DA.OWNING_SUBJECTION_ORG_ID not LIKE 'C105007%' and DA.OWNING_SUBJECTION_ORG_ID not LIKE 'C105063%') ")
				.append(" GROUP BY CI.CLASSIFY_MODEL) TB) PA ")
				.append(" LEFT OUTER JOIN (SELECT TB.CLASSIFY_MODEL,TB.ALL_NUM * TB.CALCULATE_RATIO AS ALL_TRACKS_NUM, TB.USE_NUM * TB.CALCULATE_RATIO AS USE_TRACKS_NUM, ")
				.append(" TB.OBSOLESCENT_NUM * TB.CALCULATE_RATIO AS OBSOLESCENT_TRACKS_NUM ")
				.append(" FROM (SELECT CLASSIFY_MODEL,CI.CALCULATE_RATIO,MAX(nvl(DA.QUANTITY,0)) ALL_NUM,MAX(nvl(DA.WAREHOUSE_AMOUNT,0)) USE_NUM, ")
				.append(" SUM(DECODE(DS.COL_STATUS, '0110000006000000013', '1', '0110000006000000007', '1', '0')) OBSOLESCENT_NUM ")
				.append(" FROM (SELECT CR.DEVICE_NAME, CR.DEVICE_SPECIFICATION, CR.CLASSIFY_MODEL, CR.CALCULATE_RATIO FROM BGP_COMM_DEVICE_COMPARE_REL CR ")
				.append(" INNER JOIN (SELECT CODING_NAME AS CLASSIFY_MODEL FROM COMM_CODING_SORT_DETAIL ")
				.append(" WHERE CODING_SORT_ID = '5000300003' AND CODING_CODE LIKE '02%' AND END_IF = '1' AND BSFLAG = '0') CM ")
				.append(" ON CR.CLASSIFY_MODEL = CM.CLASSIFY_MODEL AND CR.BSFLAG = '0' AND CR.DEVICE_TYPE = '1') CI ")
				.append(" LEFT OUTER JOIN (SELECT DISTINCT T1.COLLECTING_ID,T1.COLLECTING_SPECIFICATION,T1.COLLECTING_NAME,T1.QUANTITY,T3.WAREHOUSE_AMOUNT,T1.OWNING_SUBJECTION_ORG_ID ")
				.append(" FROM BGP_COMM_DEVICE_COLLECTING T1 ")
				.append(" LEFT OUTER JOIN (SELECT M1.DEVICE_ACCOUNT_ID, SUM(DECODE(M1.WAREHOUSE_AMOUNT,NULL,0,M1.WAREHOUSE_AMOUNT) -DECODE(M2.WAREHOUSE_AMOUNT,NULL,0,M2.WAREHOUSE_AMOUNT)) WAREHOUSE_AMOUNT ")
				.append(" FROM (SELECT P1.ACCEPTED_ORG_ID,P3.ORG_NAME,P3.DEVICE_ACCOUNT_ID,SUM(P2.WAREHOUSE_AMOUNT) WAREHOUSE_AMOUNT FROM BGP_COMM_EQUIP_WAREHOUSE_INFO P1 ")
				.append(" INNER JOIN BGP_COMM_EQUIP_WAREHOUSE_DETAI P2 ON P1.WAREHOUSE_INFO_ID = P2.WAREHOUSE_INFO_ID AND P1.BSFLAG = '0' AND P1.WAREHOUSE_TYPE = '1' AND P1.RECORD_STATUS = '2' ")
				.append(" INNER JOIN BGP_COMM_EQUIP_WAREHOUSE_SN P3 ON P2.WAREHOUSE_DETAIL_ID = P3.WAREHOUSE_DETAIL_ID ")
				.append(" INNER JOIN COMM_ORG_INFORMATION P3 ON P1.ACCEPTED_ORG_ID = P3.ORG_ID ")
				.append(" GROUP BY P1.ACCEPTED_ORG_ID,P3.ORG_NAME,P3.DEVICE_ACCOUNT_ID) M1 ")
				.append(" LEFT OUTER JOIN (SELECT P1.ACCEPTED_ORG_ID, P3.ORG_NAME, P3.DEVICE_ACCOUNT_ID,SUM(P2.WAREHOUSE_AMOUNT) WAREHOUSE_AMOUNT FROM BGP_COMM_EQUIP_WAREHOUSE_INFO P1 ")
				.append(" INNER JOIN BGP_COMM_EQUIP_WAREHOUSE_DETAI P2 ON P1.WAREHOUSE_INFO_ID =P2.WAREHOUSE_INFO_ID  AND P1.BSFLAG = '0' AND P1.WAREHOUSE_TYPE = '2' AND P1.RECORD_STATUS = '2' ")
				.append(" INNER JOIN BGP_COMM_EQUIP_WAREHOUSE_SN P3 ON P2.WAREHOUSE_DETAIL_ID =  P3.WAREHOUSE_DETAIL_ID ")
				.append(" INNER JOIN COMM_ORG_INFORMATION P3 ON P1.ACCEPTED_ORG_ID = P3.ORG_ID ")
				.append(" GROUP BY P1.ACCEPTED_ORG_ID,P3.ORG_NAME,P3.DEVICE_ACCOUNT_ID) M2 ")
				.append(" ON M1.ACCEPTED_ORG_ID = M2.ACCEPTED_ORG_ID  AND M1.DEVICE_ACCOUNT_ID = M2.DEVICE_ACCOUNT_ID ")
				.append(" GROUP BY M1.DEVICE_ACCOUNT_ID) T3 ")
				.append(" ON T1.COLLECTING_ID = T3.DEVICE_ACCOUNT_ID WHERE T1.BSFLAG = '0') DA ")
				.append(" ON CI.DEVICE_NAME = DA.COLLECTING_NAME  AND CI.DEVICE_SPECIFICATION = DA.COLLECTING_SPECIFICATION ")
				.append(" and (DA.OWNING_SUBJECTION_ORG_ID LIKE '" + user.getSubOrgIDofAffordOrg()
						+ "%' and DA.OWNING_SUBJECTION_ORG_ID not LIKE 'C105007%' and DA.OWNING_SUBJECTION_ORG_ID not LIKE 'C105063%') ")
				.append(" LEFT OUTER JOIN BGP_COMM_DEVICE_COL_STATUS DS  ON DA.COLLECTING_ID = DS.COLLECTING_ID  AND DS.BSFLAG = '0' ")
				.append(" GROUP BY CI.CLASSIFY_MODEL, CI.CALCULATE_RATIO) TB) PB  ON PA.CLASSIFY_MODEL = PB.CLASSIFY_MODEL");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlBuffer.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", list);
		return msg;

	}

	/*
	 * 抽取可控震源的设备使用情况controlled source
	 * 
	 * @param reqDTO
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	public ISrvMsg getControlledSourceInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		StringBuffer sqlBuffer = new StringBuffer("SELECT CLASSIFY_MODEL,SUM(DECODE(DA.DEVICE_ACCOUNT_ID, NULL, 0, 1)) ALL_NUM, ")
				.append(" SUM(DECODE(DA.DEVICE_ACCOUNT_ID, NULL, 0, DECODE(DA.USAGE_STATUS, '0110000007000000001', '1', '0'))) USE_NUM, ")
				.append(" SUM(DECODE(DA.DEVICE_ACCOUNT_ID,NULL,0,DECODE(DA.USAGE_STATUS, '0110000006000000013', '1', '0110000006000000007', '1', '0'))) OBSOLESCENT_NUM ")
				.append(" FROM (SELECT CR.DEVICE_NAME, CR.DEVICE_SPECIFICATION, CR.CLASSIFY_MODEL FROM BGP_COMM_DEVICE_COMPARE_REL CR ")
				.append(" INNER JOIN (SELECT CODING_NAME AS CLASSIFY_MODEL FROM COMM_CODING_SORT_DETAIL  WHERE CODING_SORT_ID = '5000300003' AND CODING_CODE LIKE '04%' ")
				.append(" AND END_IF = '1' AND BSFLAG = '0') CM ")
				.append(" ON CR.CLASSIFY_MODEL = CM.CLASSIFY_MODEL AND CR.BSFLAG = '0' AND CR.DEVICE_TYPE = '3') CI ")
				.append(" LEFT OUTER JOIN BGP_COMM_DEVICE_ACCOUNT DA ON CI.DEVICE_NAME = DA.DEVICE_NAME ")
				.append(" AND CI.DEVICE_SPECIFICATION = DA.DEVICE_SPECIFICATION AND DA.BSFLAG = '0'  AND DA.OWNING_SUBJECTION_ORG_ID LIKE '"
						+ user.getSubOrgIDofAffordOrg() + "%' ").append(" GROUP BY CI.CLASSIFY_MODEL");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlBuffer.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", list);
		return msg;
	}

	/*
	 * 抽取测量仪器的设备使用情况measuring
	 */
	public ISrvMsg getMeasuringInstrumentInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		StringBuffer sqlBuffer = new StringBuffer("SELECT CI.DEVICE_NAME CLASSIFY_MODEL, SUM(DECODE(DA.DEVICE_ACCOUNT_ID, NULL, 0, 1)) ALL_NUM, ")
				.append(" SUM(DECODE(DA.DEVICE_ACCOUNT_ID, NULL, 0, DECODE(DA.USAGE_STATUS, '0110000007000000001', '1', '0'))) USE_NUM, ")
				.append(" SUM(DECODE(DA.DEVICE_ACCOUNT_ID,NULL,0,DECODE(DA.USAGE_STATUS, '0110000006000000013', '1', '0110000006000000007', '1', '0'))) OBSOLESCENT_NUM ")
				.append(" FROM (SELECT CODING_NAME AS DEVICE_NAME FROM COMM_CODING_SORT_DETAIL ")
				.append(" WHERE CODING_SORT_ID = '5000300003' AND CODING_CODE LIKE '05%' AND END_IF = '1' AND BSFLAG = '0') CI ")
				.append(" LEFT OUTER JOIN BGP_COMM_DEVICE_ACCOUNT DA ON CI.DEVICE_NAME = DA.DEVICE_NAME AND DA.BSFLAG = '0' AND DA.OWNING_SUBJECTION_ORG_ID LIKE '"
						+ user.getSubOrgIDofAffordOrg() + "%' ")
				.append(" GROUP BY CI.DEVICE_NAME");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlBuffer.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", list);
		return msg;
	}

	
	/**
	 * 抽取落实收入价值工作量数据
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWorkloadInfo(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String week_date = reqDTO.getValue("week_date");
		String week_end_date = reqDTO.getValue("week_end_date");
		
		String sumStartDate = week_end_date.substring(0, 4)+"-01-01";
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("select sum(nvl(r.DAILY_ACQUIRE_WORKLOAD,0))+sum(nvl(r.DAILY_JP_ACQUIRE_WORKLOAD,0))+sum(nvl(r.DAILY_QQ_ACQUIRE_WORKLOAD,0)) as workload");
		sb.append(" from gp_ops_daily_report r join gp_task_project p on p.project_info_no=r.project_info_no");
		sb.append(" where r.bsflag='0' and r.audit_status='3' and p.bsflag='0'");
		sb.append(" and r.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%'");
		sb.append(" and p.project_country=?");
		sb.append(" and r.exploration_method=?");
		sb.append(" and to_char(r.produce_date,'yyyy-MM-dd') between ? and ?");
		
		String sql = sb.toString();

		List list = new ArrayList();
		
		Map inner = new HashMap();
		inner.put("country", "1");
		inner.put("week_2d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"1","0300100012000000002",week_date,week_end_date},Double.class));
		inner.put("year_2d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"1","0300100012000000002",sumStartDate,week_end_date},Double.class));
		inner.put("week_3d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"1","0300100012000000003",week_date,week_end_date},Double.class));
		inner.put("year_3d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"1","0300100012000000003",sumStartDate,week_end_date},Double.class));
		list.add(inner);

		Map outter = new HashMap();
		outter.put("country", "2");
		outter.put("week_2d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"2","0300100012000000002",week_date,week_end_date},Double.class));
		outter.put("year_2d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"2","0300100012000000002",sumStartDate,week_end_date},Double.class));
		outter.put("week_3d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"2","0300100012000000003",week_date,week_end_date},Double.class));
		outter.put("year_3d_workload", jdbcTemplate.queryForObject(sql, new Object[]{"2","0300100012000000003",sumStartDate,week_end_date},Double.class));
		list.add(outter);

		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", list);
		return msg;
	}

	/**
	 * 抽取非地震落实收入价值工作量数据
	 * 逻辑是抽取最近一期审批通过的数据
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getNoWorkloadInfo(ISrvMsg reqDTO) throws Exception {

		String orgId = reqDTO.getValue("org_id");
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("select * from BGP_WR_WORKLOAD_INFO where bsflag='0' and week_date=(");
		sb.append(" select max(t.week_date) from BGP_WR_WORKLOAD_INFO t where t.bsflag='0' and subflag='1'");
		sb.append(" and t.org_id = '").append(orgId).append("')");
		sb.append(" and org_id = '").append(orgId).append("'");
		
		List list = jdbcTemplate.queryForList(sb.toString());
		List newList = new LinkedList();

		// 把key小写
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			Map newMap = new HashMap();
			Iterator it = map.keySet().iterator();
			
			while(it.hasNext()){
				String key = (String)it.next();
				Object value = map.get(key);
				newMap.put(key.toLowerCase(), value);
			}
			
			newList.add(newMap);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("datas", newList);
		return msg;
	}
	
	   /**
	    * 地震采集项目信息批量导入
	    * @param reqDTO
	    * @return
	    * @throws Exception
	    */
		@SuppressWarnings("unchecked")
		public ISrvMsg importExcelTemplate(ISrvMsg reqDTO)throws Exception{
			ISrvMsg responseDTO=SrvMsgUtil.createResponseMsg(reqDTO);
			UserToken user=reqDTO.getUserToken();
			
			String weekDate=reqDTO.getValue("ww");
			String orgId=reqDTO.getValue("org_id");
			String action=reqDTO.getValue("action");
			String orgSub=reqDTO.getValue("org_subjection_id");
			String prjoctType=reqDTO.getValue("project_type");
			String week_end_date=reqDTO.getValue("week_end_date");
			
			SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
			StringBuffer message = new StringBuffer("");
			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;  //读取excel 表中的数据
			List<WSFile> fileList = mqMsg.getFiles();
			if(fileList != null && fileList.size()>0){
				WSFile fs = fileList.get(0);
				List<Map> datelist = new ArrayList<Map>();
				try{		
					Workbook book = null;
					Sheet sheet = null;
					Row row = null;
					if (fs.getFilename().indexOf(".xlsx")==-1) {		
						book = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(fs.getFileData())));
						sheet = book.getSheetAt(0);  						
					}else{
						book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
						sheet = book.getSheetAt(0);							
					}
					if(sheet != null ){
						for (int m = 3; m <= sheet.getLastRowNum(); m++) {   
							row = sheet.getRow(m);	 
				    //固定处理  ..上
							
					//项目名称	甲方名称 	队号	 设计工作量	完成工作量	进度（%）	备注		

							String project_name="";  
							String manage_org="";
							String team_name="";
							String design_workload="";
							String complete_workload="";
							String schedule="";
							String notes="";
							Map<String, String> tempMap = new HashMap<String, String>();  //把excel数据保存到map 集合
							for (int j = 0; j <=6; j++) {
								
								Cell ss=row.getCell(j);							
									if (ss != null && !"".equals(ss.toString())) {
											switch (j) {
												case 0:
													ss.setCellType(1);project_name=ss.getStringCellValue().trim(); //对应赋值
													tempMap.put("project_name", project_name);
													break;
												case 1:
													ss.setCellType(1);manage_org=ss.getStringCellValue().trim();
													tempMap.put("manage_org", manage_org);
													break;
												case 2:
													ss.setCellType(1);team_name=ss.getStringCellValue().trim();
													tempMap.put("team_name", team_name);
													break;
												case 3:
													ss.setCellType(1);design_workload=ss.getStringCellValue().trim();
													tempMap.put("design_workload",design_workload);
														break;											
												case 4:
													ss.setCellType(1);complete_workload=ss.getStringCellValue().trim();
													tempMap.put("complete_workload",complete_workload);
														break;
												case 5:
													ss.setCellType(1);schedule=ss.getStringCellValue().trim();
													tempMap.put("schedule",schedule);
														break;													
												case 6:
													ss.setCellType(1);notes=ss.getStringCellValue().trim();
													tempMap.put("notes",notes);
													break;
												default:
													break;
										    }							
								      }
							     }	
							
							 //判断是否为数字
							java.util.regex.Pattern   p=java.util.regex.Pattern.compile("\\d+(\\.\\d+)?"); 

				            if(!design_workload.equals("") && design_workload!=null){
				            	  java.util.regex.Matcher   isNum=p.matcher(design_workload);
								  if (!isNum.matches()) {message.append("第").append(m+1).append("行 设计工作量应为数字格式(注:最大只可填入三位小数)!");	}
							}  
							if(!complete_workload.equals("") && complete_workload!=null){
								java.util.regex.Matcher   isNum1=p.matcher(complete_workload);
								if(!isNum1.matches()) {message.append("第").append(m+1).append("行 完成工作量应为数字格式(注:最大只可填入三位小数)!"); }
							}
							if(!schedule.equals("") && schedule!=null){
							    java.util.regex.Matcher   isNum2=p.matcher(schedule);
								if(!isNum2.matches()) {message.append("第").append(m+1).append("行 进度应为数字格式(注:最大只可填入两位小数)!"); }
							}
							if(message.toString().equals("")){
								datelist.add(tempMap);
							}	
									
						}
						}
				   }catch(Exception e){System.out.println(e.getMessage());}
					   if(!message.toString().equals("")){
						   String  testa=message.toString();
						   responseDTO.setValue("message",testa);   //必填项为空则在页面弹出提示 
						}else{	
				            if(datelist != null && datelist.size()>0){
					            for(int i=0;i<datelist.size();i++){   
									Map map=(HashMap)datelist.get(i);
									String project_status="正常";  //正常
									String reason="";          //不正常原因
									
									Map tempMap=new HashMap();
									tempMap.put("project_name", map.get("project_name"));  
									tempMap.put("manage_org", map.get("manage_org")); 
									tempMap.put("team_name", map.get("team_name")); 
									tempMap.put("design_workload", map.get("design_workload")); 
									tempMap.put("complete_workload", map.get("complete_workload"));
									tempMap.put("schedule", map.get("schedule")); 
									tempMap.put("notes", map.get("notes")); 
									
									tempMap.put("project_status",project_status ); 
									tempMap.put("reason", reason);
									tempMap.put("create_user",  user.getUserName());
									tempMap.put("create_date", new Date());
									tempMap.put("mondify_user",  user.getUserName());
									tempMap.put("modify_date", new Date());
									tempMap.put("bsflag", "0");
									tempMap.put("subflag", "0");
									
									tempMap.put("week_date", weekDate);
									tempMap.put("project_type", prjoctType);
									tempMap.put("org_id", orgId);
									tempMap.put("org_subjection_id",orgSub);
									radDao.saveOrUpdateEntity(tempMap, "bgp_wr_project_dynamic");  //保存			
						            }
				              }		
				            responseDTO.setValue("message","导入成功");
					     } 
						 
			   }
					  responseDTO.setValue("week_date",weekDate);
					  responseDTO.setValue("project_type",prjoctType);
					  responseDTO.setValue("org_id",orgId);
					  responseDTO.setValue("week_end_date",week_end_date);
					  responseDTO.setValue("action",action);
				      return responseDTO;	
		 }
		

	/**
	 * 抽取报表列表页面
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getReportIndexList(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
//		String audit = reqDTO.getValue("audit");
		String week_date = reqDTO.getValue("week_date");
		String subflag = reqDTO.getValue("subflag");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		StringBuffer sb = new StringBuffer("select distinct");
		
//		if(audit.equals("true")){
//			sb.append(" t.record_id,t.create_user,t.subflag,");
//		}
		
		sb.append(" t.week_date,t.week_end_date");
		sb.append(" from bgp_wr_record t ");
		sb.append(" where t.bsflag = '0' and t.subflag = '1' ");//
		sb.append(" and t.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%'");
		
//		if(audit.equals("true")){
//			sb.append(" and t.subflag != '0'");
//		}else{
//			sb.append(" and t.subflag = '1'");
//		}
		
		if(week_date!=null && !week_date.equals("")){
			sb.append(" and to_char(t.week_date,'yyyy-MM-dd')='").append(week_date).append("'");
		}

		if(subflag!=null && !subflag.equals("")){
			sb.append(" and t.subflag='").append(subflag).append("'");
		}
		
		sb.append(" order by week_date desc");
		
		page = radDao.queryRecordsBySQL(sb.toString(), page);
		
		List list = page.getData();
		
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		
//		for(int i=0;i<list.size();i++){
//			Map map = (Map)list.get(i);
//			String weekDate = (String)map.get("week_date");
//
//			Calendar cal2 = Calendar.getInstance();
//			cal2.set(Calendar.DAY_OF_YEAR,1);
//			while(cal2.get(Calendar.DAY_OF_WEEK)!=6){
//				cal2.add(Calendar.DAY_OF_WEEK,-1);
//			}
//			
//			int weekNum=1;
//			while(!sdf.format(cal2.getTime()).equals(weekDate)){
//				cal2.add(Calendar.DAY_OF_YEAR,7);
//				weekNum++;
//			}
//			
//			map.put("week_num", weekNum);
//		}

		msg.setValue("datas", list);

		// 分页信息
		msg.setValue("totalRows", page.getTotalRow());
		
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}

}

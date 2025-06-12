package com.bgp.mcs.service.pm.service.wr.weekRaoPicChart.srv;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WorkFlowBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 
 * 标题：物探生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司：中油瑞飞
 * 
 * 作者：邱庆豹，2010-8-11
 * 
 * 生产周报生产chart服务类,用来给action提供相关业务数据
 */

@SuppressWarnings({ "unchecked", "rawtypes" })
public class WeekRaoPicChartSrv extends BaseService {

	private IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	
	/*
	 * 公司生产经营jfreeChart图表 modelType 1-公司生产经营信心 2-国际部生产经营信息
	 */

	public ISrvMsg getCompanyProductionInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String subflag = "0";
		String weekDate = reqDTO.getValue("week_date");
		String orgId = reqDTO.getValue("orgId");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String chartname = reqDTO.getValue("chartname");

		
		if (weekDate == null || "".equals(weekDate)) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			int week = cal.get(Calendar.DAY_OF_WEEK);
			if (week == 6) {
				cal.setTime(new Date());
			} else if (week < 7 && week > 1) {
				cal.add(Calendar.DAY_OF_YEAR, -8 - week);
			} else if (week == 1) {
				cal.add(Calendar.DAY_OF_YEAR, -9);
			} else {
				cal.add(Calendar.DAY_OF_YEAR, -8);
			}
			weekDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		}

		if (orgId == null || "".equals(orgId)) {
			orgId = user.getCodeAffordOrgID();
		}
		if (orgSubjectionId == null || "".equals(orgSubjectionId)) {
			orgSubjectionId = user.getSubOrgIDofAffordOrg();
		}

		String sql = "select subflag from bgp_wr_record where bsflag='0' and  org_id = '" + orgId + "' and week_date =to_date('" + weekDate
				+ "','yyyy-MM-dd')";
		Map mapSubFlag = queryJdbcDao.queryRecordBySQL(sql);
		if (mapSubFlag != null && mapSubFlag.get("subflag") != null) {
			subflag = (String) mapSubFlag.get("subflag");
		}

		Map map = new HashMap();
		StringBuffer sqlQuery = new StringBuffer("SELECT SUM(M.NEW_GET) OVER(PARTITION BY 1 ORDER BY M.WEEK_DATE ASC) NEW_GET, ")
				.append(" SUM(M.CARRYOUT) OVER(PARTITION BY 1 ORDER BY M.WEEK_DATE ASC) CARRYOUT, ")
				.append(" SUM(M.COMPLETE_MONEY) OVER(PARTITION BY 1 ORDER BY M.WEEK_DATE ASC) COMPLETE_MONEY, nvl(N.BUDGET_MONEY,0) BUDGET_MONEY, ")
				.append(" M.WEEK_DATE, N.YEAR ")
				.append(" FROM (SELECT NVL(P1.NEW_GET, 0) NEW_GET, NVL(P1.CARRYOUT, 0) CARRYOUT, P1.WEEK_DATE, NVL(P2.COMPLETE_MONEY, 0) COMPLETE_MONEY ")
				.append(" FROM (SELECT NVL(SUM(IM.NEW_GET), 0) NEW_GET, NVL(SUM(IM.CARRYOUT), 0) CARRYOUT, IM.WEEK_DATE ")
				.append(" FROM BGP_WR_INCOME_MONEY IM ")
				.append(" WHERE IM.BSFLAG = '0' AND IM.SUBFLAG = '" + subflag + "' AND IM.WEEK_DATE <= TO_DATE('" + weekDate
						+ "', 'yyyy-MM-dd')  AND IM.WEEK_DATE >= TRUNC(TO_DATE('" + weekDate + "', 'yyyy-mm-dd'), 'yyyy') ")
				.append(" AND IM.ORG_SUBJECTION_ID LIKE '" + orgSubjectionId + "%' ")
				.append(" AND IM.ORG_ID IN ('C0000000000232','C6000000000003','C6000000000010','C6000000000011','C6000000000013', ")
				.append(" 'C6000000000012','C6000000000045','C6000000000060','C6000000000008','C6000000001888', ")
				.append(" 'C6000000000004','C6000000000009') ")
				.append(" GROUP BY IM.WEEK_DATE) P1 ")
				.append("  left outer JOIN (SELECT NVL(SUM(WI.COMPLETE_2D_MONEY + WI.COMPLETE_3D_MONEY), 0) COMPLETE_MONEY, WI.WEEK_DATE ")
				.append("   FROM BGP_WR_WORKLOAD_INFO WI ")
				.append("  WHERE WI.BSFLAG = '0' AND WI.SUBFLAG = '" + subflag + "' AND WI.WEEK_DATE <= TO_DATE('" + weekDate
						+ "', 'yyyy-MM-dd')  AND wi.WEEK_DATE >= TRUNC(TO_DATE('" + weekDate + "', 'yyyy-mm-dd'), 'yyyy') ")
				.append("    AND WI.ORG_SUBJECTION_ID LIKE '" + orgSubjectionId + "%' ")
				.append("    AND WI.ORG_ID IN ('C0000000000232','C6000000000003','C6000000000010','C6000000000011','C6000000000013', ")
				.append("           'C6000000000012','C6000000000045','C6000000000060','C6000000000008','C6000000001888', ")
				.append("           'C6000000000004','C6000000000009')  ")
				.append("  GROUP BY WI.WEEK_DATE) P2 ON P1.WEEK_DATE = P2.WEEK_DATE AND P1.WEEK_DATE <= TO_DATE('" + weekDate
						+ "', 'yyyy-MM-dd')) M ").append("  LEFT OUTER JOIN (SELECT SUM(WB.BUDGET_MONEY) BUDGET_MONEY, WB.YEAR ")
				.append("  FROM BGP_WR_BUDGET_YEAR WB ").append(" WHERE WB.BSFLAG = '0' AND WB.SUBFLAG = '" + subflag + "' ")
				.append(" AND WB.ORG_ID IN ('C0000000000232','C6000000000003','C6000000000010','C6000000000011','C6000000000013', ")
				.append(" 'C6000000000012','C6000000000045','C6000000000060','C6000000000008','C6000000001888', ")
				.append(" 'C6000000000004','C6000000000009')  AND WB.ORG_SUBJECTION_ID LIKE '" + orgSubjectionId + "%' ")
				.append(" GROUP BY WB.YEAR) N ").append(" ON TO_CHAR(M.WEEK_DATE, 'yyyy') = N.YEAR ");
		List list = queryJdbcDao.queryRecords(sqlQuery.toString());
		StringBuffer sqlQueryAllA = new StringBuffer("SELECT NVL(SUM(T.NEW_GET), 0) NEW_GET, COUNTRY, NVL(SUM(T.CARRYOUT), 0) CARRYOUT ")
				.append(" FROM BGP_WR_INCOME_MONEY T ")
				.append(" WHERE   t.WEEK_DATE >= TRUNC(TO_DATE('"
						+ weekDate
						+ "', 'yyyy-mm-dd'), 'yyyy') AND T.WEEK_DATE <= TO_DATE('"
						+ weekDate
						+ "', 'yyyy-MM-dd') AND t.ORG_ID IN ('C0000000000232','C6000000000003','C6000000000010','C6000000000011','C6000000000013', ")
				.append("           'C6000000000012','C6000000000045','C6000000000060','C6000000000008','C6000000001888', ")
				.append("           'C6000000000004','C6000000000009') AND T.BSFLAG = '0' AND T.SUBFLAG = '" + subflag
						+ "' and t.org_subjection_id like '" + orgSubjectionId + "%' GROUP BY COUNTRY ");
		List listA = queryJdbcDao.queryRecords(sqlQueryAllA.toString());
		StringBuffer sqlQueryAllB = new StringBuffer(
				"SELECT NVL(SUM(T.COMPLETE_2D_MONEY+t.COMPLETE_3D_MONEY), 0) COMPLETE_MONEY, T.COUNTRY ")
				.append(" FROM BGP_WR_WORKLOAD_INFO T WHERE  t.WEEK_DATE >= TRUNC(TO_DATE('"
						+ weekDate
						+ "', 'yyyy-mm-dd'), 'yyyy') AND  T.WEEK_DATE <= TO_DATE('"
						+ weekDate
						+ "', 'yyyy-MM-dd') and  T.BSFLAG = '0' AND t.ORG_ID IN ('C0000000000232','C6000000000003','C6000000000010','C6000000000011','C6000000000013', ")
				.append("           'C6000000000012','C6000000000045','C6000000000060','C6000000000008','C6000000001888', ")
				.append("           'C6000000000004','C6000000000009') AND T.SUBFLAG = '" + subflag + "' and t.org_subjection_id like '"
						+ orgSubjectionId + "%'  GROUP BY T.COUNTRY");
		List listB = queryJdbcDao.queryRecords(sqlQueryAllB.toString());
		StringBuffer sqlQueryAllC = new StringBuffer("select nvl(sum(t.budget_money),0) budget_money from BGP_WR_BUDGET_YEAR t ")
				.append(" where t.bsflag='0' AND T.YEAR=TO_CHAR(to_date('"
						+ weekDate
						+ "','yyyy-MM-dd'), 'yyyy') AND t.ORG_ID IN ('C0000000000232','C6000000000003','C6000000000010','C6000000000011','C6000000000013', ")
				.append("           'C6000000000012','C6000000000045','C6000000000060','C6000000000008','C6000000001888', ")
				.append("           'C6000000000004','C6000000000009') and t.subflag='" + subflag + "' and t.org_subjection_id like '"
						+ orgSubjectionId + "%'");
		List listC = queryJdbcDao.queryRecords(sqlQueryAllC.toString());
		double carryA = 0.0;
		double carryB = 0.0;
		double newA = 0.0;
		double newB = 0.0;
		double completeA = 0.0;
		double completeB = 0.0;
		double budgetMoney = 0.0;
		int carryPlus = 0;
		int completePlus = 0;
		if (listA != null && listA.size() > 0) {
			for (int i = 0; i < listA.size(); i++) {
				Map mapCarry = (Map) listA.get(i);
				if ("1".equals(mapCarry.get("country"))) {
					carryA = Double.parseDouble((String) mapCarry.get("carryout"));
				}
				if ("2".equals(mapCarry.get("country"))) {
					carryB = Double.parseDouble((String) mapCarry.get("carryout"));
				}
			}
		}

		if (listA != null && listA.size() > 0) {
			for (int i = 0; i < listA.size(); i++) {
				Map mapNew = (Map) listA.get(i);
				if ("1".equals(mapNew.get("country"))) {
					newA = Double.parseDouble((String) mapNew.get("newGet"));
				}
				if ("2".equals(mapNew.get("country"))) {
					newB = Double.parseDouble((String) mapNew.get("newGet"));
				}
			}
		}

		if (listB != null && listB.size() > 0) {
			for (int i = 0; i < listB.size(); i++) {
				Map mapComplete = (Map) listB.get(i);
				if ("1".equals(mapComplete.get("country"))) {
					completeA = Double.parseDouble((String) mapComplete.get("completeMoney"));
				}
				if ("2".equals(mapComplete.get("country"))) {
					completeB = Double.parseDouble((String) mapComplete.get("completeMoney"));
				}
			}
		}

		if (listC != null && listC.size() > 0) {
			for (int i = 0; i < listC.size(); i++) {
				Map mapComplete = (Map) listC.get(i);
				budgetMoney = Double.parseDouble((String) mapComplete.get("budgetMoney"));
			}
		}
		if (budgetMoney != 0) {
			carryPlus = Double.valueOf(((carryA + carryB) / budgetMoney*100)).intValue();
			completePlus = Double.valueOf(((completeA + completeB) / budgetMoney*100)).intValue();
		}
		String carryAllInfo = "国际：" + carryB + ",国内：" + carryA + ",为指标的" + carryPlus + "%";
		String completeInfo = "国际：" + completeB + ",国内：" + completeA + ",为指标的" + completePlus + "%";
		String newInfo = "国际：" + newB + ",国内：" + newA;
		map.put("carryAllInfo", carryAllInfo);
		map.put("newInfo", newInfo);
		map.put("completeInfo", completeInfo);
		map.put("titlename", chartname);
		responseDTO.setValue("chartArgs", map);
		responseDTO.setValue("resultList", list);
		responseDTO.setValue("week_date", weekDate);
		responseDTO.setValue("chartname", chartname);

		return responseDTO;
	}

	/*
	 * 获取各经理部提交的生产周报的subflag标记
	 */
	public ISrvMsg getWeekPrintSubflagInfo(ISrvMsg reqDTO) throws Exception {
		String weekDate = reqDTO.getValue("weekDate");
		if (weekDate == null || "".equals(weekDate)) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			int week = cal.get(Calendar.DAY_OF_WEEK);
			if (week == 6) {
				cal.setTime(new Date());
			} else if (week < 7 && week > 1) {
				cal.add(Calendar.DAY_OF_YEAR, -8 - week);
			} else if (week == 1) {
				cal.add(Calendar.DAY_OF_YEAR, -9);
			} else {
				cal.add(Calendar.DAY_OF_YEAR, -8);
			}
			weekDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		}

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgId = user.getCodeAffordOrgID();
		String sql = "select subflag,record_id from bgp_wr_record where bsflag='0' and  org_id = '" + orgId + "' and week_date =to_date('" + weekDate
				+ "','yyyy-MM-dd')";
		Map map = queryJdbcDao.queryRecordBySQL(sql);
		if (map != null && map.get("subflag") != null) {
			String subflag = (String) map.get("subflag");
			responseDTO.setValue("subflag", subflag);
			String recordId = (String)map.get("recordId");
			responseDTO.setValue("recordId", recordId);
		}
		return responseDTO;
	}
	
	/**
	 * 进入生产周报审批页面时，获取某个生产周报的审批信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWeekPrintAudit(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		String weekDate = reqDTO.getValue("weekDate");
		if (weekDate == null || "".equals(weekDate)) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			int week = cal.get(Calendar.DAY_OF_WEEK);
			if (week == 6) {
				cal.setTime(new Date());
			} else if (week < 7 && week > 1) {
				cal.add(Calendar.DAY_OF_YEAR, -8 - week);
			} else if (week == 1) {
				cal.add(Calendar.DAY_OF_YEAR, -9);
			} else {
				cal.add(Calendar.DAY_OF_YEAR, -8);
			}
			weekDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		}

		UserToken user = reqDTO.getUserToken();
		String orgId = user.getCodeAffordOrgID();
		String sql = "select subflag,record_id,proc_inst_id,week_num from bgp_wr_record where bsflag='0' and  org_id = '" + orgId + "' and week_date =to_date('" + weekDate
				+ "','yyyy-MM-dd')";
		Map map = queryJdbcDao.queryRecordBySQL(sql);
		if (map != null && map.get("subflag") != null) {
			String subflag = (String) map.get("subflag");
			String recordId = (String)map.get("recordId");
			String weekNum = (String)map.get("weekNum");
			responseDTO.setValue("subflag", subflag);
			responseDTO.setValue("weekNum", weekNum);
			responseDTO.setValue("recordId", recordId);
		}
		
		// 处理审核模板信息
		String audit_info = reqDTO.getValue("audit_info");
		if (audit_info != null && !"".equals(audit_info)) {
			WorkFlowBean workFlowBean=(WorkFlowBean)BeanFactory.getBean("workFlowBean");
			workFlowBean.getExamineInfo(reqDTO, responseDTO);
		}
		// 获取审批历史信息
		if (map.get("procInstId") != null) {
			WorkFlowBean workFlowBean=(WorkFlowBean)BeanFactory.getBean("workFlowBean");
			List listProcHistory = workFlowBean.getProcHistory((String) map.get("procInstId"));
			responseDTO.setValue("listProcHistory", listProcHistory);
		}
		return responseDTO;		
	}
	

	/**
	 * 对某一条生产周报进行审批
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWeekPrintAudit(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		
		String org_id = user.getCodeAffordOrgID();
		String  week_date = reqDTO.getValue("weekDate");
		String  newSubflag = reqDTO.getValue("newSubflag");
		String proc_status = "";
		if ("true".equals(reqDTO.getValue("audit")) && reqDTO.getValue("isPass") != null && !"".equals(reqDTO.getValue("isPass"))) {
			WorkFlowBean workFlowBean=(WorkFlowBean)BeanFactory.getBean("workFlowBean");
			proc_status = workFlowBean.examineNode(reqDTO).getValue("proc_status");
		}
		if(proc_status != "" && ("4".equals(proc_status) || "3".equals(proc_status)) ){
			
			String[] sql = new String[16];
			
			 // 准备审批数据
			sql[0] = "update bgp_wr_record set subflag='" + newSubflag + "' where org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
	    	
			sql[1] ="update BGP_WR_WORKLOAD_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[2] ="update bgp_wr_acq_project_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[3] ="update bgp_wr_stress_project_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[4] ="update bgp_wr_sail_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[5] ="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='1'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[6] ="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='2'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[7] ="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='3'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[8] ="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='4'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[9] ="update BGP_WR_HOLD_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[10] ="update BGP_WR_INSTRUMENT_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[11] ="update BGP_WR_INSTRUMENT_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[12] ="update BGP_WR_FOCUS_INFO set subflag='" + newSubflag + "' where bsflag='0' and country='2'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[13] ="update BGP_WR_FOCUS_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[14] ="update bgp_geophone_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			
			sql[15] ="update bgp_wr_material_info set subflag='" + newSubflag + "' where bsflag='0'  and instr(org_subjection_id,'"+user.getSubOrgIDofAffordOrg()+"')>0 and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			

			for(int i=0;i<sql.length;i++){
				jdbcDao.executeUpdate(sql[i]);
			}
			
		}

		return responseDTO;		
	}
	
	/*
	 * 地震勘探工作量完成情况
	 */

	public ISrvMsg getCompanyWorkloadInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();
		String subflag = "0";
		String weekDate = reqDTO.getValue("weekDate");
		if (weekDate == null || "".equals(weekDate)) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			int week = cal.get(Calendar.DAY_OF_WEEK);
			if (week == 6) {
				cal.setTime(new Date());
			} else if (week < 7 && week > 1) {
				cal.add(Calendar.DAY_OF_YEAR, -8 - week);
			} else if (week == 1) {
				cal.add(Calendar.DAY_OF_YEAR, -9);
			} else {
				cal.add(Calendar.DAY_OF_YEAR, -8);
			}
			weekDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		}

		String orgId = user.getCodeAffordOrgID();
		String sql = "select subflag from bgp_wr_record where bsflag='0' and  org_id = '" + orgId + "' and week_date =to_date('" + weekDate
				+ "','yyyy-MM-dd')";
		Map mapSubFlag = queryJdbcDao.queryRecordBySQL(sql);
		if (mapSubFlag != null && mapSubFlag.get("subflag") != null) {
			subflag = (String) mapSubFlag.get("subflag");
		}
		StringBuffer sqlQueryAll = new StringBuffer(
				"SELECT SUM(COMPLETE_2D_MONEY) OVER(PARTITION BY 1 ORDER BY WEEK_DATE ASC) COMPLETE_2D_MONEY, ")
				.append(" SUM(COMPLETE_3D_MONEY) OVER(PARTITION BY 1 ORDER BY WEEK_DATE ASC) COMPLETE_3D_MONEY,WEEK_DATE ")
				.append(" FROM (SELECT NVL(SUM(WI.COMPLETE_2D_MONEY), 0) COMPLETE_2D_MONEY,NVL(SUM(WI.COMPLETE_3D_MONEY), 0) COMPLETE_3D_MONEY,WI.WEEK_DATE ")
				.append(" FROM BGP_WR_WORKLOAD_INFO WI ")
				.append(" WHERE WI.ORG_SUBJECTION_ID LIKE '" + orgSubjectionId + "%' AND WI.BSFLAG = '0' AND WI.SUBFLAG = '"+subflag+"' ")
				.append(" AND WI.WEEK_DATE <= TO_DATE('" + weekDate + "', 'yyyy-MM-dd') AND WI.WEEK_DATE >= TRUNC(TO_DATE('" + weekDate
						+ "', 'yyyy-mm-dd'), 'yyyy') GROUP BY WI.WEEK_DATE ) ORDER BY WEEK_DATE ASC");
		StringBuffer sqlQuery = new StringBuffer(
				"SELECT NVL(SUM(WI.COMPLETE_2D_MONEY), 0) COMPLETE_2D_MONEY,NVL(SUM(WI.COMPLETE_3D_MONEY), 0) COMPLETE_3D_MONEY,WI.WEEK_DATE ")
				.append(" FROM BGP_WR_WORKLOAD_INFO WI ")
				.append(" WHERE WI.ORG_SUBJECTION_ID LIKE '" + orgSubjectionId + "%' AND WI.BSFLAG = '0' AND WI.SUBFLAG = '"+subflag+"' ")
				.append(" AND WI.WEEK_DATE <= TO_DATE('" + weekDate + "', 'yyyy-MM-dd')  AND WI.WEEK_DATE >= TRUNC(TO_DATE('" + weekDate
						+ "', 'yyyy-mm-dd'), 'yyyy')")
				.append("  GROUP BY WI.WEEK_DATE  ORDER BY WEEK_DATE ASC");
		StringBuffer sqlQueryHuan = new StringBuffer(
				"SELECT DECODE(COMPLETE_2D_MONEY_OLD, 0, 0, ROUND(COMPLETE_2D_MONEY / COMPLETE_2D_MONEY_OLD * 100 - 100, 0)) COMPLETE_2D_MONEY, ")
				.append(" DECODE(COMPLETE_3D_MONEY_OLD, 0, 0, ROUND(COMPLETE_3D_MONEY / COMPLETE_3D_MONEY_OLD * 100 - 100, 0)) COMPLETE_3D_MONEY ")
				.append(" FROM (SELECT NVL(M.COMPLETE_2D_MONEY, 0) COMPLETE_2D_MONEY, ")
				.append(" NVL(M.COMPLETE_3D_MONEY, 0) COMPLETE_3D_MONEY, ")
				.append(" LAG(NVL(COMPLETE_2D_MONEY, 0), 1, 0) OVER(ORDER BY WEEK_DATE ASC) COMPLETE_2D_MONEY_OLD, ")
				.append(" LAG(NVL(COMPLETE_3D_MONEY, 0), 1, 0) OVER(ORDER BY WEEK_DATE ASC) COMPLETE_3D_MONEY_OLD, ")
				.append(" M.WEEK_DATE ").append(" FROM (SELECT SUM(T.COMPLETE_2D_MONEY) COMPLETE_2D_MONEY, ")
				.append(" SUM(T.COMPLETE_3D_MONEY) COMPLETE_3D_MONEY, ").append(" T.WEEK_DATE ").append(" FROM BGP_WR_WORKLOAD_INFO T ")
				.append("  WHERE T.BSFLAG = '0' ").append(" AND T.SUBFLAG = '"+subflag+"' ").append("  AND T.ORG_SUBJECTION_ID LIKE '"+orgSubjectionId+"%' ")
				.append(" GROUP BY T.WEEK_DATE) M ORDER BY M.WEEK_DATE DESC) ").append(" WHERE ROWNUM=1 ");
		StringBuffer sqlQueryTong = new StringBuffer(
				"SELECT DECODE(COMPLETE_2D_MONEY_OLD, 0, 0, ROUND(COMPLETE_2D_MONEY / COMPLETE_2D_MONEY_OLD * 100-100, 0)) COMPLETE_2D_MONEY, ")
				.append(" DECODE(COMPLETE_3D_MONEY_OLD, 0, 0, ROUND(COMPLETE_3D_MONEY / COMPLETE_3D_MONEY_OLD * 100-100, 0)) COMPLETE_3D_MONEY ")
				.append(" FROM (SELECT NVL(SUM(COMPLETE_2D_MONEY), 0) COMPLETE_2D_MONEY, NVL(SUM(COMPLETE_3D_MONEY), 0) COMPLETE_3D_MONEY ")
				.append(" FROM (SELECT NVL(SUM(T.COMPLETE_2D_MONEY), 0) COMPLETE_2D_MONEY, ")
				.append(" NVL(SUM(T.COMPLETE_3D_MONEY), 0) COMPLETE_3D_MONEY, T.WEEK_DATE ")
				.append(" FROM BGP_WR_WORKLOAD_INFO T ")
				.append(" WHERE T.BSFLAG = '0' AND T.SUBFLAG = '"+subflag+"' AND T.ORG_SUBJECTION_ID LIKE '"+orgSubjectionId+"%' GROUP BY T.WEEK_DATE) M ")
				.append(" WHERE M.WEEK_DATE <= TO_DATE('"+weekDate+"', 'yyyy-MM-dd') ")
				.append(" AND M.WEEK_DATE >= TRUNC(TO_DATE('"+weekDate+"', 'yyyy-MM-dd'), 'YY')) M, ")
				.append(" (SELECT NVL(SUM(COMPLETE_2D_MONEY), 0) COMPLETE_2D_MONEY_OLD, ")
				.append(" NVL(SUM(COMPLETE_3D_MONEY), 0) COMPLETE_3D_MONEY_OLD ")
				.append(" FROM (SELECT NVL(SUM(T.COMPLETE_2D_MONEY), 0) COMPLETE_2D_MONEY,NVL(SUM(T.COMPLETE_3D_MONEY), 0) COMPLETE_3D_MONEY,T.WEEK_DATE ")
				.append(" FROM BGP_WR_WORKLOAD_INFO T ")
				.append(" WHERE T.BSFLAG = '0' AND T.SUBFLAG = '"+subflag+"' AND T.ORG_SUBJECTION_ID LIKE '"+orgSubjectionId+"%' GROUP BY T.WEEK_DATE) M ")
				.append(" WHERE M.WEEK_DATE <= NEXT_DAY(TRUNC(ADD_MONTHS(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), -12), 'YY'), 2) + ")
				.append(" TRUNC((TRUNC(NEXT_DAY(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 2)) - ")
				.append(" NEXT_DAY(TRUNC(TO_DATE('"+weekDate+"', 'yyyy-mm-dd'), 'YY'), 2))) ")
				.append("  AND M.WEEK_DATE >= TRUNC(ADD_MONTHS(TO_DATE('"+weekDate+"', 'yyyy-MM-dd'), -12), 'YY')) N ");

		List listA = queryJdbcDao.queryRecords(sqlQueryAll.toString());
		List listB = queryJdbcDao.queryRecords(sqlQuery.toString());
		List listC = queryJdbcDao.queryRecords(sqlQueryHuan.toString());
		List listD = queryJdbcDao.queryRecords(sqlQueryTong.toString());
		String year2D = "";
		String year3D = "";
		String week2D = "";
		String week3D = "";
		if (listC != null && listC.size() > 0) {
			Map map = (Map) listC.get(0);
			String complete2dMoney = (String) map.get("complete2dMoney");
			int rate2D = Integer.parseInt(complete2dMoney);
			if (rate2D > 0) {
				week2D = "环比上升" + rate2D+"%";
			} else {
				week2D = "环比下降" + rate2D * -1+"%";
			}
			
			String complete3dMoney = (String) map.get("complete3dMoney");
			int rate3D = Integer.parseInt(complete3dMoney);
			if (rate3D > 0) {
				week3D = "环比上升" + rate3D+"%";
			} else {
				week3D = "环比下降" + rate3D * -1+"%";
			}
		}
		
		if (listD != null && listD.size() > 0) {
			Map map = (Map) listD.get(0);
			String complete2dMoney = (String) map.get("complete2dMoney");
			int rate2D = Integer.parseInt(complete2dMoney);
			if (rate2D > 0) {
				year2D = "同比上升" + rate2D+"%";
			} else {
				year2D = "同比下降" + rate2D * -1+"%";
			}
			
			String complete3dMoney = (String) map.get("complete3dMoney");
			int rate3D = Integer.parseInt(complete3dMoney);
			if (rate3D > 0) {
				year3D = "同比上升" + rate3D+"%";
			} else {
				year3D = "同比下降" + rate3D * -1+"%";
			}
		}
		Map map=new HashMap();
		map.put("year2D", year2D);
		map.put("year3D", year3D);
		map.put("week2D", week2D);
		map.put("week3D", week3D);
		map.put("titleName", "地震勘探工作量完成情况");
		responseDTO.setValue("listA", listA);
		responseDTO.setValue("listB", listB);
		responseDTO.setValue("chartArgs", map);
		return responseDTO;
	}
	


	/*
	 * 获取各经理部提交的生产月报的subflag标记
	 */
	public ISrvMsg getMonthPrintSubflagInfo(ISrvMsg reqDTO) throws Exception {
		String  monthNo= reqDTO.getValue("monthNo");
		String monthDate="";
		if(monthNo==null){
			if((new SimpleDateFormat("yyyy-MM").format(new Date())).endsWith("12")){
				monthDate=new SimpleDateFormat("yyyy-MM").format(new Date())+"-31";
			}else{
				monthDate=new SimpleDateFormat("yyyy-MM").format(new Date())+"-25";
			}
			monthNo=new SimpleDateFormat("yyyy-MM").format(new Date());
		}else{
			if(monthNo.endsWith("12")){
				monthDate=monthNo+"-31";
			}else{
				monthDate=monthNo+"-25";
			}
		}

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgId = user.getCodeAffordOrgID();
		String sql = "select subflag,issue_number,record_id from bgp_month_record where bsflag='0' and  org_id = '" + orgId + "' and month_no =to_char(to_date('" + monthNo+ "','yyyy-MM'),'yyyy-MM')";
		Map map = queryJdbcDao.queryRecordBySQL(sql);
		if (map != null && map.get("subflag") != null) {
			String subflag = (String) map.get("subflag");
			responseDTO.setValue("subflag", subflag);
			String recordId = (String)map.get("recordId");
			responseDTO.setValue("recordId", recordId);
			String monthNum = (String)map.get("issue_number");
			responseDTO.setValue("monthNum", monthNum);
		}
		responseDTO.setValue("monthDate", monthDate);
		responseDTO.setValue("monthNo", monthNo);
		return responseDTO;
	}
	

	/**
	 * 进入生产月报审批页面时，获取某个生产月报的审批信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMonthPrintAudit(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		String monthNo = reqDTO.getValue("monthNo");

		UserToken user = reqDTO.getUserToken();
		String orgId = user.getCodeAffordOrgID();
		String sql = "select subflag,record_id,proc_inst_id,issue_number,to_char(month_end_date,'yyyy-MM-dd') as month_date from bgp_month_record where bsflag='0' and  org_id = '" + orgId + "' and month_no = '" + monthNo + "'";
		
		Map map = queryJdbcDao.queryRecordBySQL(sql);
		if (map != null && map.get("subflag") != null) {
			String subflag = (String) map.get("subflag");
			String recordId = (String)map.get("recordId");
			String issueNumber = (String)map.get("issueNumber");
			String monthDate = (String)map.get("monthDate");
			
			responseDTO.setValue("subflag", subflag);
			responseDTO.setValue("monthNum", issueNumber);
			responseDTO.setValue("recordId", recordId);
			responseDTO.setValue("monthDate", monthDate);
		}
		
		// 处理审核模板信息
		String audit_info = reqDTO.getValue("audit_info");
		if (audit_info != null && !"".equals(audit_info)) {
			WorkFlowBean workFlowBean=(WorkFlowBean)BeanFactory.getBean("workFlowBean");
			workFlowBean.getExamineInfo(reqDTO, responseDTO);
		}
		// 获取审批历史信息
		if (map.get("procInstId") != null) {
			WorkFlowBean workFlowBean=(WorkFlowBean)BeanFactory.getBean("workFlowBean");
			List listProcHistory = workFlowBean.getProcHistory((String) map.get("procInstId"));
			responseDTO.setValue("listProcHistory", listProcHistory);
		}
		return responseDTO;		
	}
	
	/**
	 * 对某一条生产月报进行审批
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMonthPrintAudit(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		
		String org_id = user.getCodeAffordOrgID();
		String month_no = reqDTO.getValue("monthNo");
		String newSubflag = reqDTO.getValue("newSubflag");
		String proc_status = "";
		
		if (reqDTO.getValue("isPass") != null && !"".equals(reqDTO.getValue("isPass"))) {
			WorkFlowBean workFlowBean=(WorkFlowBean)BeanFactory.getBean("workFlowBean");
			proc_status = workFlowBean.examineNode(reqDTO).getValue("proc_status");
		}
		if(proc_status != "" && ("4".equals(proc_status) || "3".equals(proc_status)) ){
			
			String[] sql = new String[33];
			
			 // 准备审批数据
			sql[0] = "update bgp_month_record set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "'";
	    	
			sql[1] ="update BGP_MONTH_INCOME_MONEY set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[2] ="update BGP_MONTH_WORKLOAD_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[3] ="update BGP_MONTH_NOTMAIN_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[4] ="update BGP_MONTH_IMPACTIVITY_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[5] ="update BGP_MONTH_SAIL_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[6] ="update BGP_MONTH_IMPANDCOORD_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[7] ="update BGP_MONTH_WORKPLAN set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[8] ="update BGP_MONTH_PROJECT_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and project_type='1'";
			
			sql[9] ="update BGP_MONTH_PROJECT_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and project_type='2'";
			
			sql[10] ="update BGP_MONTH_PROJECT_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and project_type='3'";
			
			sql[11] ="update BGP_MONTH_STRESS_PROJECT_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[12] ="update BGP_MONTH_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and project_type='2'";
			
			sql[13] ="update BGP_MONTH_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and project_type='4'";
			
			sql[14] ="update BGP_MONTH_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and project_type='5'";
			
			sql[15] ="update BGP_MONTH_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and project_type='6'";
			
			sql[16] ="update BGP_MONTH_SITUATION_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and sitution_type='1'";
			
			sql[17] ="update BGP_MONTH_SITUATION_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and sitution_type='2'";

			sql[18] ="update BGP_MONTH_QUALITYMANAGE_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and typeid='3'";
			
			sql[19] ="update BGP_MONTH_SITUATION_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and sitution_type='3'";
			
			sql[20] ="update BGP_MONTH_SITUATION_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and sitution_type='4'";
			
			sql[21] ="update BGP_MONTH_SITUATION_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and sitution_type='5'";
			
			sql[22] ="update BGP_MONTH_INSTRUMENT_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[23] ="update BGP_MONTH_INSTRUMENT_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and country='1'";
			
			sql[24] ="update BGP_MONTH_FOCUS_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and country='2'";
			
			sql[25] ="update BGP_MONTH_FOCUS_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and country='1'";
			
			sql[26] ="update BGP_MONTH_MATERIAL_INFO set subflag='" + newSubflag + "' where month_no='" + month_no + "' ";

			sql[27] ="update BGP_MONTH_MARTANDPROJECT_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[28] ="update BGP_MONTH_HSE_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and typeid='1'";
			
			sql[29] ="update BGP_MONTH_HSE_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and typeid='2'";
			
			sql[30] ="update BGP_MONTH_INFOAMATION_QUALITY set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' ";
			
			sql[31] ="update BGP_MONTH_QUALITYMANAGE_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and typeid='1'";
			
			sql[32] ="update BGP_MONTH_QUALITYMANAGE_INFO set subflag='" + newSubflag + "' where org_id='" + org_id + "' and month_no='" + month_no + "' " + "and typeid='2'";
			
			for(int i=0;i<sql.length;i++){
				jdbcDao.executeUpdate(sql[i]);
			}
			
		}

		return responseDTO;		
	}
}

package com.bgp.mcs.service.pm.service.project;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class TeamDynamicSrv extends BaseService
{

	/**
	 * 
	* @Title: getTeamStatistics1
	* @Description: 队伍动态代码重构，提供性能
	* @param @param reqDTO
	* @param @return
	* @param @throws Exception    设定文件
	* @return ISrvMsg    返回类型
	* @throws
	 */
	public ISrvMsg getTeamStatistics1(ISrvMsg reqDTO) throws Exception
	{
		UserToken user = reqDTO.getUserToken();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubIdofAff = reqDTO.getValue("orgSubId");

		if (orgSubIdofAff == null || "".equals(orgSubIdofAff))
		{
			orgSubIdofAff = user.getSubOrgIDofAffordOrg();
		}
		// String orgSubIdofAff = "C105";
		// 获取统计单位
		DBDataService dbDataSrv = new DBDataService();
		List<Map> orgList = dbDataSrv.getOrganization1(orgSubIdofAff);

		List<Map> teamStatistics = new ArrayList<Map>();

		for (int j = 0; j < orgList.size(); j++)
		{

			Map lineStatistics = new HashMap();

			Map map = orgList.get(j);
			String orgSubId = (String) map.get("org_sub_id");
			String orgName = (String) map.get("org_name");
			String orgId = (String) map.get("org_id");

			lineStatistics.put("orgName", orgName);
			lineStatistics.put("orgCode", orgSubId);
			lineStatistics.put("orgId", orgId);

			// 查询每个处级单位总的队伍数
			List<Map> teamSums = getTeamSums(orgSubId);

			lineStatistics.put("teamSums", teamSums.size());
			// 查询正在施工的队伍
			List<Map> teamOperationNums = getQueryUsedTeam1(orgSubId);

			int teamOperNums = 0;

			for (int j1 = 0; j1 < teamSums.size(); j1++)
			{
				Map map1 = teamSums.get(j1);
				String teamOrgSubId = (String) map1.get("org_subjection_id");
				boolean flag = false;
				for (int j2 = 0; j2 < teamOperationNums.size(); j2++)
				{
					Map map2 = teamOperationNums.get(j2);
					String orgsubid = (String) map2.get("orgsubid");
					if (orgsubid.indexOf(teamOrgSubId) != -1)
					{
						flag = true;
						break;
					}
				}
				if (flag)
				{
					teamOperNums = teamOperNums + 1;
				}
			}
			lineStatistics.put("teamOperationNums", teamOperNums);
			lineStatistics.put("teamIdleNums", teamSums.size() - teamOperNums);

			teamStatistics.add(lineStatistics);
		}

		String dataXml = dataToXML(teamStatistics);
		int p_start = dataXml.indexOf("<chart");
		dataXml = dataXml.substring(p_start, dataXml.length());
		responseMsg.setValue("Str", dataXml);

		responseMsg.setValue("teamStatistics", teamStatistics);

		return responseMsg;
	}

	/**
	 * 
	* @Title: getQueryUsedTeam1
	* @Description: 查询在用的队伍数
	* @param @param orgSubId
	* @param @return    设定文件
	* @return List<Map>    返回类型
	* @throws
	 */
	private List<Map> getQueryUsedTeam1(String orgSubId)
	{

		StringBuffer sql = new StringBuffer(
				"select count(distinct d.org_id) as num,d.org_subjection_id as orgsubid from gp_task_project p ");
		sql.append(" , gp_task_project_dynamic d where p.project_info_no=d.project_info_no and d.bsflag='0'  and  p.bsflag='0'");
		sql.append(" and p.project_status<>'5000100001000000003' and d.org_subjection_id like '%"
				+ orgSubId + "%' ");
		sql.append(" group by d.org_subjection_id");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try
		{
			resultList = jdbcDAO.queryRecords(sql.toString());
		} catch (Exception e)
		{
		}
		return resultList;
	}

	public ISrvMsg getTeamStatistics(ISrvMsg reqDTO) throws Exception
	{
		UserToken user = reqDTO.getUserToken();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubIdofAff = reqDTO.getValue("orgSubId");
		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");
		if (orgSubIdofAff == null || "".equals(orgSubIdofAff))
		{
			orgSubIdofAff = user.getSubOrgIDofAffordOrg();
		}
		// String orgSubIdofAff = "C105";
		// 获取统计单位
		DBDataService dbDataSrv = new DBDataService();
		List<Map> orgList = dbDataSrv.getOrganization(orgSubIdofAff);

		if (orgList != null)
		{
			// 获取队伍数
			List<Map> teamSums = getTeamSums(orgSubIdofAff);
			// String[] statuss1 = {"试验","测量","钻井","采集","动迁","踏勘"};
			// List<Map> teamOperationNums = getTeamByStatus(startDate, endDate,
			// statuss1, orgSubIdofAff);
			// String[] statuss2 = {"动迁","踏勘"};
			// List<Map> teamReadyNums = getTeamByStatus(startDate, endDate,
			// statuss2, orgSubIdofAff);
			// String[] statuss3 = {"结束"};
			// List<Map> teamStopNums = getTeamByStatus(startDate, endDate,
			// statuss3, orgSubIdofAff);

			List<Map> teamOperationNums = getQueryUsedTeam(orgSubIdofAff);

			List<Map> teamUse = getTeamUse(orgSubIdofAff);

			DecimalFormat df = new DecimalFormat();
			DecimalFormat df2 = new DecimalFormat("#.##");
			String style = "0";
			df.applyPattern(style);

			List<Map> teamStatistics = new ArrayList<Map>();
			List<Map> teamStatistics2 = new ArrayList<Map>();
			long sumTeamSums = 0;// 队伍总数
			long sumTeamOperationNums = 0;// 正在施工
			long sumTeamIdleNums = 0;// 闲置
			long sumTeamPrepareNums = 0;// 准备
			long sumTeamStopNums = 0;// 结束
			long sumTeamUse = 0;// 动用过的队伍
			double sumTeamUseRadio = 0;
			double sumTeamNum = 0;// 本年度动用过的队伍数量
			for (int i = 0; i < orgList.size(); i++)
			{
				Map map = orgList.get(i);
				String orgName = (String) map.get("org_name");
				String orgCode = (String) map.get("org_sub_id");
				String orgId = (String) map.get("org_id");
				Map lineStatistics = new HashMap();
				Map lineStatistics2 = new HashMap();

				lineStatistics.put("orgName", orgName);
				lineStatistics.put("orgCode", orgCode);
				lineStatistics.put("orgId", orgId);

				lineStatistics2.put("orgName", orgName);
				lineStatistics2.put("orgCode", orgCode);
				lineStatistics2.put("orgId", orgId);

				// 计算队伍总数
				long lineTeamSums = 0;
				if (teamSums != null)
				{
					for (int k = 0; k < teamSums.size(); k++)
					{
						Map team = teamSums.get(k);
						String orgSubId = (String) team
								.get("org_subjection_id");
						if (orgSubId.contains(orgCode))
						{
							lineTeamSums++;
						}
					}
				}
				lineStatistics.put("teamSums", lineTeamSums);
				sumTeamSums += lineTeamSums;

				// 在用项目
				long lineTeamOperationNums = 0;
				if (teamOperationNums != null)
				{
					for (int k = 0; k < teamOperationNums.size(); k++)
					{
						Map team = teamOperationNums.get(k);
						String orgSubId = (String) team.get("orgsubid");
						if (orgSubId.contains(orgCode))
						{
							String cnt = (String) team.get("num");
							long teamCount = new Long(cnt);
							lineTeamOperationNums += teamCount;
						}
					}
				}
				lineStatistics.put("teamOperationNums", lineTeamOperationNums);
				sumTeamOperationNums += lineTeamOperationNums;
				sumTeamUse += lineTeamOperationNums;

				// //计算施工队伍数
				// long lineTeamOperationNums = 0;
				// if(teamOperationNums != null){
				// for(int k=0; k<teamOperationNums.size(); k++){
				// Map team = teamOperationNums.get(k);
				// String orgSubId = (String)team.get("orgsubid");
				// if(orgSubId.contains(orgCode)){
				// String cnt = (String)team.get("num");
				// long teamCount = new Long(cnt);
				// lineTeamOperationNums += teamCount;
				// }
				// }
				// }
				// lineStatistics.put("teamOperationNums",
				// lineTeamOperationNums);
				// sumTeamOperationNums += lineTeamOperationNums;
				// sumTeamUse += lineTeamOperationNums;
				//
				// //准备队伍
				// long lineTeamPrepareNums = 0;
				// if(teamReadyNums != null){
				// for(int k=0; k<teamReadyNums.size(); k++){
				// Map team = teamReadyNums.get(k);
				// String orgSubId = (String)team.get("orgsubid");
				// if(orgSubId.contains(orgCode)){
				// String cnt = (String)team.get("num");
				// long teamCount = new Long(cnt);
				// lineTeamPrepareNums += teamCount;
				// }
				// }
				// }
				// //lineStatistics.put("teamPrepareNums", lineTeamPrepareNums);
				// //sumTeamPrepareNums += lineTeamPrepareNums;
				// //sumTeamUse += lineTeamPrepareNums;
				//
				// //结束队伍
				// long lineTeamStopNums = 0;
				// if (teamStopNums != null) {
				// for(int k=0; k<teamStopNums.size(); k++){
				// Map team = teamStopNums.get(k);
				// String orgSubId = (String)team.get("orgsubid");
				// if(orgSubId.contains(orgCode)){
				// String cnt = (String)team.get("num");
				// long teamCount = new Long(cnt);
				// lineTeamStopNums += teamCount;
				// }
				// }
				// }
				// lineStatistics.put("teamStopNums", lineTeamStopNums);
				// sumTeamStopNums += lineTeamStopNums;
				// sumTeamUse += lineTeamStopNums;

				// 计算物探处队伍动用率
				// 物探处动用率=年度施工队伍总数/物探处队伍总数×100%
				// 计算出本年动用过的队伍数量
				int lineUseTeam = 0;
				String sqlUseTeam = "select count(distinct(t.org_subjection_id)) num  from gp_ops_daily_report t where t.org_subjection_id like '"
						+ orgCode
						+ "%' and to_char(t.produce_date,'yyyy') =to_char(sysdate,'yyyy')";
				Map mapUseTeam = BeanFactory.getQueryJdbcDAO()
						.queryRecordBySQL(sqlUseTeam);
				if (mapUseTeam != null)
				{
					lineUseTeam = Integer.parseInt((String) mapUseTeam
							.get("num"));
					sumTeamNum += lineUseTeam;
				}
				long lineTeamSumsNew = 0;
				if (lineTeamSums == 0)
				{
					lineTeamSumsNew = 1;
				} else
				{
					lineTeamSumsNew = lineTeamSums;
				}
				lineStatistics.put("teamUse2",
						df.format(lineUseTeam * 1.0 / lineTeamSumsNew * 100));
				lineStatistics2.put("teamUse2",
						df.format(lineUseTeam * 1.0 / lineTeamSumsNew * 100));

				// 计算闲置队伍数
				long lineTeamIdleNums;
				// 闲置=总队伍-准备-施工-结束
				// lineTeamIdleNums = lineTeamSums - lineTeamOperationNums -
				// lineTeamPrepareNums - lineTeamStopNums;

				// 闲置=总队伍-在用-结束
				lineTeamIdleNums = lineTeamSums - lineTeamOperationNums;
				lineStatistics.put("teamIdleNums", lineTeamIdleNums);

				// sumTeamUseRadio = 0;
				// 计算物探处队伍利用率
				// 公式 物探处各动用队伍自己的利用率之和除以动用的队伍数
				double teamUseRadio = 0;
				String yearNum = "0";
				if (teamUse != null)
				{
					int k = 0;
					for (int j = 0; j < teamUse.size(); j++)
					{
						Map team = teamUse.get(j);
						System.out.println(team);
						String orgSubId = (String) team.get("orgSubjectionId");
						// 国际部过滤、综合物化探过滤
						if (orgSubId.indexOf("C105002") > 0
								|| orgSubId.indexOf("C105008") > 0)
						{
							continue;
						}
						yearNum = (String) team.get("yearNum");
						// 求出一个小队同事进行两个项目时，日报有交叉，交叉部分的天数取一份
						// 两个项目相同日报日期的天数除以二，因为两个项目都减去二分之一就是一份了；teamUse是按照项目来的
						String sqlCha = "select (max(t1.produce_date)-min(t1.produce_date))/2 project_together from gp_ops_daily_report t1 join gp_ops_daily_produce_sit s1 on t1.daily_no=s1.daily_no and s1.bsflag='0'"
								+ "join gp_ops_daily_report t2 join gp_ops_daily_produce_sit s2 on t2.daily_no = s2.daily_no and s2.bsflag='0'"
								+ "on t1.org_subjection_id = t2.org_subjection_id and t1.produce_date = t2.produce_date and t2.bsflag = '0' and t1.project_info_no != t2.project_info_no and t1.audit_status='3'"
								+ "where t1.bsflag = '0' and s1.survey_process_status<>'1' and s2.survey_process_status<>'1' and s1.collect_process_status<>'3' and s2.collect_process_status<>'3' and t1.org_subjection_id = '"
								+ orgSubId + "'";
						String projectTogether = "0";
						Map mapCha = BeanFactory.getQueryJdbcDAO()
								.queryRecordBySQL(sqlCha);
						if (mapCha != null)
						{
							projectTogether = (String) mapCha
									.get("projectTogether");
							if (projectTogether == null
									|| projectTogether.equals(""))
							{
								projectTogether = "0";
							}
						}

						if (orgSubId.contains(orgCode))
						{
							String useRadio = (String) team.get("useRadio");
							double useRadioDouble = Double
									.parseDouble(useRadio)
									- Double.parseDouble(projectTogether);
							teamUseRadio += useRadioDouble;
							k++;
						}
					}

					double asd = teamUseRadio
							/ (lineTeamSumsNew * Double.parseDouble(yearNum))
							* 100;
					// if (teamUseRadio == 0) {
					//
					// } else {
					// teamUseRadio = teamUseRadio/k;
					// }

					lineStatistics.put("teamUse", df2.format(asd));
					lineStatistics2.put("teamUse", df2.format(asd));
					// sumTeamUseRadio += teamUseRadio * lineTeamSums;
					sumTeamUseRadio += teamUseRadio;
				}

				teamStatistics.add(lineStatistics);
				teamStatistics2.add(lineStatistics2);
				sumTeamIdleNums += lineTeamIdleNums;
			}

			sumTeamUseRadio = sumTeamUseRadio / (sumTeamSums * 365) * 100;

			// 汇总统计
			Map sumMap = new HashMap();
			sumMap.put("orgName", "公司");
			sumMap.put("orgCode", "C105");
			sumMap.put("teamSums", sumTeamSums);
			sumMap.put("teamOperationNums", sumTeamOperationNums);
			sumMap.put("teamIdleNums", sumTeamIdleNums);
			sumMap.put("teamPrepareNums", sumTeamPrepareNums);
			sumMap.put("teamStopNums", sumTeamStopNums);
			sumMap.put("teamUse", df2.format(sumTeamUseRadio));
			sumMap.put("teamUse2", df.format(100.0 * sumTeamNum / sumTeamSums));

			teamStatistics.add(0, sumMap);
			teamStatistics2.add(0, sumMap);
			String dataXml = dataToXML(teamStatistics);
			int p_start = dataXml.indexOf("<chart");
			dataXml = dataXml.substring(p_start, dataXml.length());
			responseMsg.setValue("Str", dataXml);

			dataXml = dataToXML2(teamStatistics2);
			p_start = dataXml.indexOf("<chart");
			dataXml = dataXml.substring(p_start, dataXml.length());
			responseMsg.setValue("Str2", dataXml);

			dataXml = dataToXML4(teamStatistics2);
			p_start = dataXml.indexOf("<chart");
			dataXml = dataXml.substring(p_start, dataXml.length());
			responseMsg.setValue("Str3", dataXml);

			responseMsg.setValue("teamStatistics", teamStatistics);
		}

		return responseMsg;
	}

	public ISrvMsg getTeamUse(ISrvMsg reqDTO) throws Exception
	{
		UserToken user = reqDTO.getUserToken();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubIdofAff = reqDTO.getValue("orgSubId");
		String orgName = null;
		if (orgSubIdofAff == null || "".equals(orgSubIdofAff))
		{
			orgSubIdofAff = user.getSubOrgIDofAffordOrg();
			orgName = user.getOrgName();
		} else
		{
			String sql = "select oi.org_abbreviation as org_name from comm_org_subjection os,comm_org_information oi where os.org_subjection_id = '"
					+ orgSubIdofAff
					+ "' and oi.org_id = os.org_id and os.bsflag = '0' and oi.bsflag = '0' ";
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			List<Map> resultList = jdbcDAO.queryRecords(sql.toString());
			if (resultList != null && resultList.size() != 0)
			{
				Map map = resultList.get(0);
				orgName = (String) map.get("org_name");
			}
		}

		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");

		// 队伍总数
		List<Map> teamSums = getTeamSums(orgSubIdofAff);

		// 动用队伍
		// String[] statuss1 = {"试验","测量","钻井","采集"};
		List<Map> teamOperationNums = getQueryUsedTeam(orgSubIdofAff);

		// 准备队伍
		// String[] statuss2 = {"动迁","踏勘"};
		// List<Map> teamReadyNums = getTeamByStatus(startDate, endDate,
		// statuss2, orgSubIdofAff);

		// //结束队伍
		// String[] statuss3 = {"结束"};
		// List<Map> teamStopNums = getTeamByStatus(startDate, endDate,
		// statuss3, orgSubIdofAff);

		DecimalFormat df = new DecimalFormat();
		DecimalFormat df2 = new DecimalFormat("#.##");
		String style = "0";
		df.applyPattern(style);

		double sumUseRadio = 0;
		String yearNum = "0";
		List<Map> teamUse = getTeamUse(orgSubIdofAff);
		List<Map> teamStatistics = new ArrayList<Map>();
		List<Map> teamStatistics1 = new ArrayList<Map>();
		if (teamUse != null)
		{
			for (int i = 0; i < teamUse.size(); i++)
			{
				Map lineStatistics = new HashMap();
				Map team = teamUse.get(i);
				String orgSubId = (String) team.get("orgSubjectionId");
				yearNum = (String) team.get("yearNum");
				// 求出一个小队同事进行两个项目时，日报有交叉，交叉部分的天数取一份
				// 两个项目相同日报日期的天数除以二，因为两个项目都减去二分之一就是一份了；teamUse是按照项目来的
				String sqlCha = "select (max(t1.produce_date)-min(t1.produce_date))/2 project_together from gp_ops_daily_report t1 join gp_ops_daily_produce_sit s1 on t1.daily_no=s1.daily_no and s1.bsflag='0'"
						+ "join gp_ops_daily_report t2 join gp_ops_daily_produce_sit s2 on t2.daily_no = s2.daily_no and s2.bsflag='0'"
						+ "on t1.org_subjection_id = t2.org_subjection_id and t1.produce_date = t2.produce_date and t2.bsflag = '0' and t1.project_info_no != t2.project_info_no and t1.audit_status='3'"
						+ "where t1.bsflag = '0' and s1.survey_process_status<>'1' and s2.survey_process_status<>'1' and s1.collect_process_status<>'3' and s2.collect_process_status<>'3' and t1.org_subjection_id = '"
						+ orgSubId + "'";
				String projectTogether = "0";
				Map mapCha = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
						sqlCha);
				if (mapCha != null)
				{
					projectTogether = (String) mapCha.get("projectTogether");
					if (projectTogether == null || projectTogether.equals(""))
					{
						projectTogether = "0";
					}
				}

				if (orgSubId.contains(orgSubIdofAff))
				{
					String useRadio = (String) team.get("useRadio");
					double useRadioDouble = Double.parseDouble(useRadio)
							- Double.parseDouble(projectTogether);
					sumUseRadio += useRadioDouble;
					lineStatistics.put(
							"teamUse",
							df2.format(useRadioDouble
									/ Double.parseDouble(yearNum) * 100));
					lineStatistics.put("orgName", team.get("orgName"));
					teamStatistics.add(lineStatistics);
				}

			}

		}

		if (teamSums != null)
		{
			teamStatistics1 = new ArrayList<Map>();

			int run = 0;
			int stop = 0;
			int prepare = 0;
			int idle = 0;
			int useTime = 0;
			double sumTeamUse = 0;

			for (int i = 0; i < teamSums.size(); i++)
			{
				Map lineStatistics = new HashMap();
				Map team = teamSums.get(i);
				boolean flag = false;
				String orgCode = (String) team.get("org_subjection_id");
				lineStatistics.put("orgName", team.get("team_name"));
				lineStatistics.put("orgCode", orgCode);
				lineStatistics.put("num", 1);

				lineStatistics.put("run", 0);
				lineStatistics.put("stop", 0);
				lineStatistics.put("prepare", 0);
				lineStatistics.put("idle", 0);
				int k = 0;
				lineStatistics.put("useTime", 0);// 动用次数
				lineStatistics.put("teamUse", "0");// 利用率

				for (int j = 0; j < teamUse.size(); j++)
				{
					Map teamUseMap = teamUse.get(j);
					String orgSubId = (String) teamUseMap
							.get("orgSubjectionId");
					yearNum = (String) teamUseMap.get("yearNum");
					// 求出一个小队同事进行两个项目时，日报有交叉，交叉部分的天数取一份
					// 两个项目相同日报日期的天数除以二，因为两个项目都减去二分之一就是一份了；teamUse是按照项目来的
					String sqlCha = "select (max(t1.produce_date)-min(t1.produce_date))/2 project_together from gp_ops_daily_report t1 join gp_ops_daily_produce_sit s1 on t1.daily_no=s1.daily_no and s1.bsflag='0'"
							+ "join gp_ops_daily_report t2 join gp_ops_daily_produce_sit s2 on t2.daily_no = s2.daily_no and s2.bsflag='0'"
							+ "on t1.org_subjection_id = t2.org_subjection_id and t1.produce_date = t2.produce_date and t2.bsflag = '0' and t1.project_info_no != t2.project_info_no and t1.audit_status='3'"
							+ "where t1.bsflag = '0' and s1.survey_process_status<>'1' and s2.survey_process_status<>'1' and s1.collect_process_status<>'3' and s2.collect_process_status<>'3' and t1.org_subjection_id = '"
							+ orgSubId + "'";
					String projectTogether = "0";
					Map mapCha = BeanFactory.getQueryJdbcDAO()
							.queryRecordBySQL(sqlCha);
					if (mapCha != null)
					{
						projectTogether = (String) mapCha
								.get("projectTogether");
						if (projectTogether == null
								|| projectTogether.equals(""))
						{
							projectTogether = "0";
						}
					}

					if (orgSubId.equals(orgCode) || orgCode == orgSubId)
					{
						String useRadio = (String) teamUseMap.get("useRadio");
						double useRadioDouble = Double.parseDouble(useRadio)
								- Double.parseDouble(projectTogether);
						lineStatistics.put(
								"teamUse",
								df2.format(useRadioDouble
										/ Double.parseDouble(yearNum) * 100));
						sumTeamUse += useRadioDouble;
						k++;
						break;
					}
				}

				// 运行
				if (teamOperationNums != null)
				{
					for (int j = 0; j < teamOperationNums.size(); j++)
					{
						Map map = teamOperationNums.get(j);
						if (orgCode.contains((String) map.get("orgsubid")))
						{
							lineStatistics.put("run", 1);

							run++;
							flag = true;
							break;
						}
					}
				}

				// //结束
				// if (teamStopNums != null) {
				// for (int j = 0; j < teamStopNums.size(); j++) {
				// Map map = teamStopNums.get(j);
				// if (orgCode.contains((String) map.get("orgsubid"))) {
				// lineStatistics.put("stop", 1);
				// k++;
				// stop++;
				// flag = true;
				// break;
				// }
				// }
				// }

				// 准备
				// if (teamReadyNums != null) {
				// for (int j = 0; j < teamReadyNums.size(); j++) {
				// Map map = teamReadyNums.get(j);
				// if (orgCode.contains((String) map.get("orgsubid"))) {
				// lineStatistics.put("prepare", 1);
				// k++;
				// prepare++;
				// flag = true;
				// break;
				// }
				// }
				// }
				//
				lineStatistics.put("useTime", k);
				useTime = useTime + k;

				if (flag)
				{
					teamStatistics1.add(lineStatistics);
					continue;
				}

				idle++;
				lineStatistics.put("idle", 1);
				teamStatistics1.add(lineStatistics);
			}

			double sumTeamNum = 1;
			if (teamSums.size() == 0)
			{
				sumTeamNum = 1;
			} else
			{
				sumTeamNum = teamSums.size();
			}

			Map lineStatistics = new HashMap();
			lineStatistics.put("orgName", orgName);
			lineStatistics.put("orgCode", "C105");
			lineStatistics.put("num", teamSums.size());
			lineStatistics.put("run", run);
			lineStatistics.put("stop", stop);
			lineStatistics.put("prepare", prepare);
			lineStatistics.put("idle", idle);
			lineStatistics.put("useTime", useTime);
			lineStatistics.put("teamUse",
					df2.format(sumTeamUse / (365 * sumTeamNum) * 100));

			teamStatistics1.add(lineStatistics);

			lineStatistics = new HashMap();
			lineStatistics.put("teamUse",
					df2.format(sumTeamUse / (365 * sumTeamNum) * 100));
			lineStatistics.put("orgName", orgName);
			teamStatistics.add(0, lineStatistics);

			String dataXml = dataToXML3(teamStatistics);
			int p_start = dataXml.indexOf("<chart");
			dataXml = dataXml.substring(p_start, dataXml.length());
			responseMsg.setValue("Str", dataXml);

			style = "0%";
			df.applyPattern(style);

			responseMsg.setValue("teamUse2",
					df.format(useTime * 1.0 / sumTeamNum));

			responseMsg.setValue("teamStatistics", teamStatistics1);
		}

		return responseMsg;
	}

	private List<Map> getTeamUse(String orgSubId)
	{
		// String sql =
		// "select min(send_date),max(send_date),r.org_id,r.org_subjection_id,project_info_no,max(send_date)-min(send_date) as day "
		// +
		// " ,round((max(send_date)-min(send_date))/(to_date(to_char(sysdate,'yyyy')||'-12-31','yyyy-MM-dd') - to_date(to_char(sysdate,'yyyy')||'-01-01','yyyy-MM-dd'))*100,2) as use_radio"+
		// " ,oi.org_abbreviation as org_name"+
		// " from rpt_gp_daily r " +
		// " join comm_org_information oi "+
		// " on oi.org_id = r.org_id and oi.bsflag = '0' "+
		// " where r.bsflag = '0' " +
		// " and work_status not in ('动迁','踏勘','试验') " +
		// " and send_date >= to_date(to_char(sysdate,'yyyy')||'-01-01','yyyy-MM-dd') "
		// +
		// " and send_date <= to_date(to_char(sysdate,'yyyy')||'-12-31','yyyy-MM-dd') "
		// +
		// " and org_subjection_id like '"+orgSubId+"%' "+
		// " group by project_info_no,r.org_id,r.org_subjection_id,oi.org_abbreviation";
		//
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = new ArrayList<Map>();

		// 开始测量日期（从日报信息中读取） 修改项目结束时，不进行统计
		String sqlStartDate = "select t.project_info_no, t.org_subjection_id,min(t.produce_date) min_date from gp_task_project t1 join  gp_ops_daily_report t  on t1.project_info_no=t.project_info_no  join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag = '0' where s.bsflag = '0' "
				+ " and t.project_info_no=t1.project_info_no and t1.project_status<>'5000100001000000003' "
				+ "and t.audit_status='3' and s.survey_process_status <> '1' and t.produce_date >= to_date(to_char(sysdate,'yyyy')||'-01-01','yyyy-MM-dd') and t.produce_date <= to_date(to_char(sysdate,'yyyy')||'-12-31','yyyy-MM-dd') and t.org_subjection_id like '"
				+ orgSubId
				+ "%'  group by t.project_info_no,t.org_subjection_id";
		List<Map> startDateList = jdbcDAO.queryRecords(sqlStartDate);
		if (startDateList.size() != 0)
		{
			for (int i = 0; i < startDateList.size(); i++)
			{
				Map map = startDateList.get(i);
				// System.out.println(startDateList);
				// System.out.println(map);
				String projectInfoNo = (String) map.get("project_info_no");
				String startDate = (String) map.get("min_date");
				String orgSubjectionId = (String) map.get("org_subjection_id");
				String endDate = "";
				// 求出如果采集工作量结束的最小时间
				String sqlEndDate = "select t.*  from gp_ops_daily_report t join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag = '0' where t.bsflag = '0' and t.audit_status='3'  and t.project_info_no = '"
						+ projectInfoNo
						+ "' and s.collect_process_status='3' and t.produce_date >= to_date(to_char(sysdate,'yyyy')||'-01-01','yyyy-MM-dd') and t.produce_date <= to_date(to_char(sysdate,'yyyy')||'-12-31','yyyy-MM-dd') order by t.produce_date asc";
				Map mapMaxDate = BeanFactory.getPureJdbcDAO().queryRecordBySQL(
						sqlEndDate);
				// System.out.println(mapMaxDate);
				if (mapMaxDate != null && !mapMaxDate.equals(""))
				{
					endDate = (String) mapMaxDate.get("produce_date");
				} else
				{

					String sqlEndDate2 = "select * from gp_ops_daily_report t join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag = '0' where t.bsflag = '0' and t.audit_status='3'  and t.project_info_no = '"
							+ projectInfoNo
							+ "' and t.produce_date >= to_date(to_char(sysdate,'yyyy')||'-01-01','yyyy-MM-dd') and t.produce_date <= to_date(to_char(sysdate,'yyyy')||'-12-31','yyyy-MM-dd') order by t.produce_date desc";
					Map mapMaxDate2 = BeanFactory.getQueryJdbcDAO()
							.queryRecordBySQL(sqlEndDate2);
					if (mapMaxDate2 != null)
					{
						endDate = (String) mapMaxDate2.get("produceDate");
					}
				}

				if (startDate != null && !startDate.equals("")
						&& endDate != null && !endDate.equals(""))
				{
					String totalSql = "select t.*,(to_date('"
							+ endDate
							+ "','yyyy-MM-dd')-to_date('"
							+ startDate
							+ "','yyyy-MM-dd')) use_radio,(to_date(to_char(sysdate,'yyyy')||'-12-31','yyyy-MM-dd') - to_date(to_char(sysdate,'yyyy')||'-01-01','yyyy-MM-dd')) year_num,oi.org_abbreviation org_name from gp_ops_daily_report t join rpt_gp_daily rpt on t.project_info_no=rpt.project_info_no and rpt.bsflag='0' left join comm_org_information oi on rpt.org_id=oi.org_id and oi.bsflag='0' where t.bsflag='0' and t.project_info_no='"
							+ projectInfoNo + "' and rownum=1";
					Map mapTotal = BeanFactory.getQueryJdbcDAO()
							.queryRecordBySQL(totalSql);
					// System.out.println(mapTotal);
					resultList.add(mapTotal);

				}
			}
		}

		return resultList;
	}

	private List<Map> getTeamSums(String orgSubId)
	{
		// 获取队伍总数
		StringBuffer message = new StringBuffer();
		StringBuffer sql = new StringBuffer(
				"select os.org_subjection_id,oi.org_abbreviation as team_name from comm_org_team ot, comm_org_subjection os,comm_org_information oi");
		sql.append(" where ot.org_id = os.org_id and ot.bsflag = '0' and oi.bsflag = '0' and oi.org_id = ot.org_id and os.bsflag = '0' and ot.if_registered = '1'");
		sql.append(" and ot.team_specialty in   ( '0100100015000000017','0100100015000000014','0100100015000000018')  ");
		sql.append(" and os.org_subjection_id like '" + orgSubId + "%'");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try
		{
			resultList = jdbcDAO.queryRecords(sql.toString());
		} catch (Exception e)
		{
			message.append("表名或查询条件字段不存在!");
		}
		return resultList;
	}

	private List<Map> getTeamOperationNums(String startDate, String endDate,
			String orgSubId)
	{
		// 获取施工队伍数
		StringBuffer message = new StringBuffer();
		StringBuffer sql = new StringBuffer(
				"select count(distinct(org_id)) as num,org_subjection_id as orgsubid ");
		sql.append(" from (select gp.work_status,row_number() over(partition by gp.org_id order by gp.send_date desc) row_1 ,gp.org_id,gp.org_subjection_id ");
		sql.append(" 				from rpt_gp_daily gp where gp.bsflag = '0'");
		sql.append("				and gp.send_date >=  to_date(substr('" + startDate
				+ "',1,4)||'01-01', 'yyyy-MM-dd')");
		sql.append(" 				and gp.send_date <= to_date('" + endDate
				+ "', 'yyyy-MM-dd')");
		sql.append(" 				)");
		sql.append(" where row_1 = 1 and work_status not in ('结束') and org_subjection_id like '"
				+ orgSubId + "%' group by org_subjection_id");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try
		{
			resultList = jdbcDAO.queryRecords(sql.toString());
		} catch (Exception e)
		{
			message.append("表名或查询条件字段不存在!");
		}
		return resultList;
	}

	private List<Map> getTeamReadyNums(String startDate, String endDate,
			String orgSubId)
	{
		// 获取准备队伍数
		StringBuffer message = new StringBuffer();
		StringBuffer sql = new StringBuffer(
				"select count(distinct rpt.org_id) as num,rpt.org_subjection_id as orgsubid from rpt_gp_daily rpt ");
		sql.append(" join gp_task_project p on p.project_info_no=rpt.project_info_no and p.bsflag='0' ");
		sql.append(" where rpt.bsflag='0' and rpt.work_status in ('动迁','踏勘') and rpt.ORG_SUBJECTION_ID like 'C105%' ");
		sql.append(" and rpt.send_date = (select max(r.send_date) from rpt_gp_daily r where r.BSFLAG = '0' and r.PROJECT_INFO_NO = p.PROJECT_INFO_NO ");
		sql.append(" and r.send_date >= to_date(substr('" + startDate
				+ "',1,4)||'01-01', 'yyyy-MM-dd')");
		sql.append(" and r.send_date <= to_date('" + endDate
				+ "', 'yyyy-MM-dd')");
		sql.append(" ) and rpt.org_subjection_id like '" + orgSubId + "%'");
		sql.append(" group by rpt.ORG_SUBJECTION_ID");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try
		{
			resultList = jdbcDAO.queryRecords(sql.toString());
		} catch (Exception e)
		{
			message.append("表名或查询条件字段不存在!");
		}
		return resultList;
	}

	private List<Map> getTeamByStatus(String startDate, String endDate,
			String[] statuss, String orgSubId)
	{

		String temp = "";
		if (statuss != null)
		{
			for (int i = 0; i < statuss.length; i++)
			{
				temp += "'" + statuss[i] + "',";
			}
			temp = temp.substring(0, temp.length() - 1);
		}

		StringBuffer sql = new StringBuffer(
				"select count(distinct rpt.org_id) as num,rpt.org_subjection_id as orgsubid from rpt_gp_daily rpt ");
		sql.append(" join gp_task_project p on p.project_info_no=rpt.project_info_no and p.bsflag='0' ");
		sql.append(" where rpt.bsflag='0' and rpt.work_status in (")
				.append(temp).append(")");
		sql.append(" and rpt.org_subjection_id like '" + orgSubId + "%' ");
		sql.append(" and rpt.send_date = (select max(r.send_date) from rpt_gp_daily r where r.BSFLAG = '0' and r.PROJECT_INFO_NO = p.PROJECT_INFO_NO ");
		sql.append(" and r.send_date >= to_date(substr('" + startDate
				+ "',1,4)||'01-01', 'yyyy-MM-dd')");
		sql.append(" and r.send_date <= to_date('" + endDate
				+ "', 'yyyy-MM-dd')");
		sql.append(" )");
		sql.append(" group by rpt.org_subjection_id");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try
		{
			resultList = jdbcDAO.queryRecords(sql.toString());
		} catch (Exception e)
		{
		}
		return resultList;
	}

	private String dataToXML(List<Map> list)
	{
		String resultXML = "";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("palette", "2");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "none");
		// root.addAttribute("caption", "队伍动态");
		// root.addAttribute("xAxisName", "直属单位");
		root.addAttribute("yAxisName", "队伍数");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "0");
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "在用");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "闲置");
		if (list != null)
		{
			for (int i = 0; i < list.size(); i++)
			{
				Map map = list.get(i);
				String orgName = (String) map.get("orgName");
				String orgCode = (String) map.get("orgCode");

				if ("公司".equals(orgName))
				{
					continue;
				}
				Element category = categories.addElement("category");
				category.addAttribute("label", orgName);

				// 施工队伍数
				String data1 = "" + map.get("teamOperationNums");
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", data1);
				set1.addAttribute("showValue", "1");
				set1.addAttribute("link", "j-inBrowse('run','" + orgCode + "')");

				// 闲置队伍数
				String data2 = "" + map.get("teamIdleNums");
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", data2);
				set2.addAttribute("showValue", "1");
				set2.addAttribute("link", "j-inBrowse('no','" + orgCode + "')");
			}
		}
		resultXML = document.asXML();
		return resultXML;
	}

	private String dataToXML2(List<Map> list)
	{
		String resultXML = "";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("palette", "2");
		root.addAttribute("numberSuffix", "%");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "none");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "0");
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "利用率");
		dataset1.addAttribute("color", "1381c0");
		dataset1.addAttribute("anchorBorderColor", "1381c0");
		dataset1.addAttribute("anchorBgColor", "1381c0");
		// Element dataset2 = root.addElement("dataset");
		// dataset2.addAttribute("seriesName", "动用率");
		// dataset2.addAttribute("color", "f5d34b");
		// dataset2.addAttribute("anchorBorderColor", "f5d34b");
		// dataset2.addAttribute("anchorBgColor", "f5d34b");
		if (list != null)
		{
			for (int i = 0; i < list.size(); i++)
			{
				Map map = list.get(i);
				String orgName = (String) map.get("orgName");
				String orgCode = (String) map.get("orgCode");
				Element category = categories.addElement("category");
				category.addAttribute("label", orgName);

				// 队伍利用率
				String data1 = "" + map.get("teamUse");
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", data1);
				set1.addAttribute("showValue", "1");
				set1.addAttribute("link", "j-open1('" + orgCode + "')");

				// 队伍动用率
				// String data2 = ""+map.get("teamUse2");
				// Element set2 = dataset2.addElement("set");
				// set2.addAttribute("value", data2);
				// set2.addAttribute("showValue", "1");

			}
		}
		resultXML = document.asXML();
		return resultXML;
	}

	private String dataToXML3(List<Map> list)
	{
		String resultXML = "";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("palette", "2");
		root.addAttribute("numberSuffix", "%");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "none");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "0");
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "利用率");
		dataset1.addAttribute("color", "1381c0");
		dataset1.addAttribute("anchorBorderColor", "1381c0");
		dataset1.addAttribute("anchorBgColor", "1381c0");
		if (list != null)
		{
			for (int i = 0; i < list.size(); i++)
			{
				Map map = list.get(i);
				String orgName = (String) map.get("orgName");

				Element category = categories.addElement("category");
				category.addAttribute("label", orgName);

				// 队伍利用率
				String data1 = "" + map.get("teamUse");
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", data1);
				set1.addAttribute("showValue", "1");

			}
		}
		resultXML = document.asXML();
		return resultXML;
	}

	private String dataToXML4(List<Map> list)
	{
		String resultXML = "";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("palette", "2");
		root.addAttribute("numberSuffix", "%");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "none");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "0");
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "动用率");
		dataset1.addAttribute("color", "f5d34b");
		dataset1.addAttribute("anchorBorderColor", "f5d34b");
		dataset1.addAttribute("anchorBgColor", "f5d34b");
		if (list != null)
		{
			for (int i = 0; i < list.size(); i++)
			{
				Map map = list.get(i);
				String orgName = (String) map.get("orgName");

				Element category = categories.addElement("category");
				category.addAttribute("label", orgName);

				// 队伍利用率
				String data1 = "" + map.get("teamUse2");
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", data1);
				set1.addAttribute("showValue", "1");

			}
		}
		resultXML = document.asXML();
		return resultXML;
	}

	private List<Map> getQueryUsedTeam(String orgSubId)
	{

		StringBuffer sql = new StringBuffer(
				"select count(distinct d.org_id) as num,d.org_subjection_id as orgsubid from gp_task_project p ");
		sql.append(" join gp_task_project_dynamic d on p.project_info_no=d.project_info_no and d.bsflag='0'  where p.bsflag='0' and p.project_year='2014' ");
		sql.append(" and p.project_status<>'5000100001000000003' and d.org_subjection_id like '"
				+ orgSubId + "%'  ");
		sql.append(" group by d.org_subjection_id");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try
		{
			resultList = jdbcDAO.queryRecords(sql.toString());
		} catch (Exception e)
		{
		}
		return resultList;
	}

}

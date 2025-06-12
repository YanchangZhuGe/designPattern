package com.bgp.dms.use;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 资产创收创效
 * 
 * @author cc
 * 
 */
public class AssetsIncomeSrv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	private boolean inStr(String[] strs, String s) {
		for (int i = 0; i < strs.length; i++) {
			if (s.equals(strs[i])) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 获取资产创收创效数据(公司)
	 * 
	 * @return
	 */
	public ISrvMsg getAssetsIncomeOrProfitData(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String[] org_names = { "研究院", "信息技术中心", "物探技术研究中心" };
		String amountYear = msg.getValue("amountYear");// 年度
		if (StringUtils.isBlank(amountYear)) {
			amountYear = "";
		}
		String analType = msg.getValue("analType");// 统计分析类别
		if (StringUtils.isBlank(analType)) {
			analType = "";
		}
		// 物探处
		String orgSubId = msg.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		StringBuilder cSql = new StringBuilder(
				" select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
						+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
						+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
						+ " ben.sub_org_id as sub_id from dms_device_benefit ben where ben.bsflag = '0'");
		StringBuilder rSql = new StringBuilder(
				"select case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id,1,10)"
						+ " when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id,1,10)"
						+ " else substr(acc.owning_sub_id,1,7) end sub_id,acc.net_value"
						+ " from gms_device_account acc"
						+ " where acc.bsflag = '0' and acc.account_stat = '0110000013000000003'"
						+ " union all"
						+ " select case when b.owning_sub_id like 'C105001%' then substr(b.owning_sub_id,1,10)"
						+ " when b.owning_sub_id like 'C105005%' then substr(b.owning_sub_id,1,10)"
						+ " else substr(b.owning_sub_id,1,7) end sub_id,b.net_value"
						+ " from gms_device_account_b b"
						+ " where b.bsflag = '0' and b.account_stat = '0110000013000000003'");
		// 东方公司
		StringBuilder sql1 = new StringBuilder();
		// 物探处
		StringBuilder sql2 = new StringBuilder();
		// 收入比
		if ("cost".equals(analType)) {
			sql1.append("select oi.org_abbreviation as org_name,t.sub_id,t.income_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.income_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		} else {// 利润比
			sql1.append("select oi.org_abbreviation as org_name,t.sub_id,t.profit_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.profit_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		}
		sql1.append(cSql);
		sql1.append(" and ben.level_type='1' ");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql1.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql1.append(" and ben.sub_org_id='" + orgSubId + "' ");
		sql1.append(" group by ben.sub_org_id ) t");
		sql1.append(" left join ( select '" + orgSubId
				+ "' as sub_id,sum(t1.net_value) as net_value from ( ");
		sql1.append(rSql);
		sql1.append(" ) t1 ");
		sql1.append(" ) t2 on t.sub_id=t2.sub_id ");
		sql1.append(" left join comm_org_subjection sub on t.sub_id=sub.org_subjection_id and  sub.bsflag='0'");
		sql1.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by rate desc");
		// 物探处
		if ("cost".equals(analType)) {
			sql2.append("select oi.org_abbreviation as org_name,t.sub_id,t.income_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.income_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		} else {// 利润比
			sql2.append("select oi.org_abbreviation as org_name,t.sub_id,t.profit_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.profit_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		}
		sql2.append(cSql);
		sql2.append(" and ben.level_type='2' ");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql2.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql2.append(" group by ben.sub_org_id ) t");
		sql2.append(" left join (select t1.sub_id as sub_id,sum(t1.net_value) as net_value from ( ");
		sql2.append(rSql);
		sql2.append(" ) t1 ");
		sql2.append(" group by t1.sub_id) t2 on t.sub_id=t2.sub_id ");
		sql2.append(" left join comm_org_subjection sub on t.sub_id=sub.org_subjection_id and  sub.bsflag='0'");
		// sql2.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by t2.net_value, sub.coding_show_id desc");
		sql2.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by rate desc");

		List<Map> list1 = jdbcDao.queryRecords(sql1.toString());
		List<Map> list2 = jdbcDao.queryRecords(sql2.toString());
		List<Map> list = new ArrayList<Map>();
		if (CollectionUtils.isNotEmpty(list1)) {
			list.addAll(list1);
		}
		if (CollectionUtils.isNotEmpty(list2)) {
			list.addAll(list2);
		}
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		if (CollectionUtils.isNotEmpty(list)) {
			for (Map map : list) {
				if (!inStr(org_names, map.get("org_name").toString())) {
					Element set = root.addElement("set");
					String value = "0";
					if (null != map.get("rate")) {
						value = map.get("rate").toString();
					}
					set.addAttribute("label", map.get("org_name").toString());
					set.addAttribute("value", value);
					set.addAttribute("displayValue", value + "%");
					set.addAttribute("toolText", map.get("org_name").toString()
							+ "," + value + "%");
					if (!"0".equals(value)) {
						String _orgSubId = map.get("sub_id").toString();
						if (!"C105".equals(_orgSubId)) {
							set.addAttribute("link",
									"JavaScript:popWuTanIncomeProfitRate('"
											+ amountYear + "','" + analType
											+ "','" + _orgSubId + "')");
						}
					}
				}
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}

	/**
	 * 获取资产创收创效数据(物探处)
	 * 
	 * @return
	 */
	public ISrvMsg getWutanAssetsIncomeOrProfitData(ISrvMsg isrvmsg)
			throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String amountYear = isrvmsg.getValue("amountYear");// 年度
		if (StringUtils.isBlank(amountYear)) {
			amountYear = "";
		}
		String analType = isrvmsg.getValue("analType");// 统计分析类别
		if (StringUtils.isBlank(analType)) {
			analType = "";
		}
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if (StringUtils.isBlank(orgSubId)) {
			orgSubId = "";
		}
		StringBuilder cSql = new StringBuilder(
				" select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
						+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
						+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
						+ " ben.sub_org_id as sub_id from dms_device_benefit ben where ben.bsflag = '0' ");
		StringBuilder rSql = new StringBuilder(
				"select case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id,1,10)"
						+ " when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id,1,10)"
						+ " else substr(acc.owning_sub_id,1,7) end sub_id,acc.net_value,pro.project_info_no,pro.project_year"
						+ " from gms_device_account acc"
						+ " left join gp_task_project_dynamic dyn on acc.owning_sub_id=dyn.org_subjection_id"
						+ " left join gp_task_project pro on dyn.project_info_no= pro.project_info_no"
						+ " where acc.bsflag = '0' and acc.account_stat = '0110000013000000003'"
						+ " union all"
						+ " select case when b.owning_sub_id like 'C105001%' then substr(b.owning_sub_id,1,10)"
						+ " when b.owning_sub_id like 'C105005%' then substr(b.owning_sub_id,1,10)"
						+ " else substr(b.owning_sub_id,1,7) end sub_id,b.net_value,pro.project_info_no,pro.project_year"
						+ " from gms_device_account_b b"
						+ " left join gp_task_project_dynamic dyn on b.owning_sub_id=dyn.org_subjection_id"
						+ " left join gp_task_project pro on dyn.project_info_no= pro.project_info_no"
						+ " where b.bsflag = '0' and b.account_stat = '0110000013000000003'");
		// 物探处
		StringBuilder sql1 = new StringBuilder();
		// 项目
		StringBuilder sql2 = new StringBuilder();
		// 收入比
		if ("cost".equals(analType)) {
			sql1.append("select oi.org_abbreviation as label,t.sub_id as id,t.income_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.income_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		} else {// 利润比
			sql1.append("select oi.org_abbreviation as label,t.sub_id as id,t.profit_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.profit_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		}
		sql1.append(cSql);
		sql1.append(" and ben.level_type='2' ");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql1.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql1.append(" and ben.sub_org_id='" + orgSubId + "' ");
		sql1.append(" group by ben.sub_org_id ) t");
		sql1.append(" left join ( select t1.sub_id as sub_id,sum(t1.net_value) as net_value from ( ");
		sql1.append(rSql);
		sql1.append(" ) t1 ");
		sql1.append(" where t1.sub_id='" + orgSubId + "' ");
		sql1.append(" group by t1.sub_id) t2 on t.sub_id=t2.sub_id ");
		sql1.append(" left join comm_org_subjection sub on t.sub_id=sub.org_subjection_id and  sub.bsflag='0'");
		// sql1.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by sub.coding_show_id");
		sql1.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by  rate");
		// 项目
		if ("cost".equals(analType)) {
			sql2.append("select proj.project_name as label,t.project_info_no as id,t.income_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.income_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		} else {// 利润比
			sql2.append("select proj.project_name as label,t.project_info_no as id,t.profit_amount,t2.net_value,round(decode(nvl(t2.net_value,0),0,0,nvl(t.profit_amount,0)*100/nvl(t2.net_value,0)),2) as rate from ( ");
		}
		sql2.append(" select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
				+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
				+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
				+ " ben.project_info_no as project_info_no from dms_device_benefit ben where ben.bsflag = '0' and ben.level_type='3'");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql2.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql2.append(" and ben.sub_org_id='" + orgSubId + "' ");
		sql2.append(" group by ben.project_info_no ) t");
		sql2.append(" left join (select t1.project_info_no as project_info_no,sum(t1.net_value) as net_value from ( ");
		sql2.append(rSql);
		sql2.append(" ) t1 ");
		if (StringUtils.isNotBlank(amountYear)) {
			sql2.append(" where to_char(t1.project_year,'yyyy')='" + amountYear
					+ "' ");
		}
		sql2.append(" and t1.sub_id='" + orgSubId + "' ");
		sql2.append(" group by t1.project_info_no) t2 on t.project_info_no=t2.project_info_no ");
		sql2.append(" left join gp_task_project proj on t.project_info_no=proj.project_info_no order by rate desc");
		List<Map> list1 = jdbcDao.queryRecords(sql1.toString());
		List<Map> list2 = jdbcDao.queryRecords(sql2.toString());
		List<Map> list = new ArrayList<Map>();
		if (CollectionUtils.isNotEmpty(list1)) {
			list.addAll(list1);
		}
		if (CollectionUtils.isNotEmpty(list2)) {
			list.addAll(list2);
		}
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		if (CollectionUtils.isNotEmpty(list)) {
			for (Map map : list) {
				Element set = root.addElement("set");
				String value = "0";
				if (null != map.get("rate")) {
					value = map.get("rate").toString();
				}
				set.addAttribute("label", map.get("label").toString());
				set.addAttribute("value", value);
				set.addAttribute("displayValue", value + "%");
				set.addAttribute("toolText", map.get("label").toString() + ","
						+ value + "%");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}

	/**
	 * 根据组织机构查询项目列表
	 * 
	 * @return
	 */
	public ISrvMsg getProjectListByOrgSubId(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String orgSubId = msg.getValue("orgSubId");
		StringBuffer sb = new StringBuffer();
		sb.append(
				"select t.project_info_no,t.project_name from Gp_task_project t left join Gp_Task_Project_Dynamic d ")
				.append("on t.project_info_no = d.project_info_no where t.bsflag ='0' and d.bsflag='0' and d.org_subjection_id like '")
				.append(orgSubId).append("%'");

		List<Map> list = jdbcDao.queryRecords(sb.toString());

		responseDTO.setValue("list", list);

		return responseDTO;
	}

	/**
	 * 获取当前年度
	 * 
	 * @return
	 */
	public String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}
}

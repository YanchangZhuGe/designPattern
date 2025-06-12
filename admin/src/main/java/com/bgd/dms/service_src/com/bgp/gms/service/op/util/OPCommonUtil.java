package com.bgp.gms.service.op.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.soap.SOAPException;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.DateOperation;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

/**
 * 
 * 标题：
 * 
 * 作者：邱庆豹，2012 6 8
 * 
 * 描述：经营管理操作工具类
 * 
 * 说明: 提取经营管理公共操作，服务于各业务模块
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
public class OPCommonUtil {

	private static JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private static IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();

	private static IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private static RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

	/*
	 * 用于将一个list 转换为tree List，便于 前台树的生成
	 */
	public static Map convertListTreeToJson(List list, String idName, String parentIdName, Map rootMap) {
		return convertListTreeToJsonBase(list, idName, parentIdName, rootMap, false);
	}

	public static Map convertListTreeToJsonCheck(List list, String idName, String parentIdName, Map rootMap) {
		return convertListTreeToJsonBase(list, idName, parentIdName, rootMap, true);
	}

	/*
	 * 
	 */
	public static Map convertListTreeToJsonBase(List list, String idName, String parentIdName, Map rootMap, boolean checked) {
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);
			String id = (String) map.get(idName);
			List subList = new ArrayList();
			for (int j = 0; list != null && j < list.size(); j++) {
				Map subMap = (Map) list.get(j);
				if (id.equals(subMap.get(parentIdName))) {
					subList.add(subMap);
				}
			}
			map.put("children", subList);
		}
		if (checked) {
			for (int i = 0; list != null && i < list.size(); i++) {
				Map map = (Map) list.get(i);
				if (((List) map.get("children")).size() < 1) {
					map.put("checked", false);
				}
			}
		}
		List rootSubList = new ArrayList();
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);
			if (map.get(parentIdName).equals(rootMap.get(idName))) {
				rootSubList.add(map);
			}
		}
		rootMap.put("children", rootSubList);
		return rootMap;
	}

	/*
	 * 设置树的显示序号
	 */
	public static int getOrderOfTreeDisplay(String tableName, String parentId) {
		int order = -1;
		String sqlIndex = "select max(order_code) indexLoc from " + tableName + " where parent_id = '" + parentId + "' and bsflag='0'";
		Map indexMap = jdbcDao.queryRecordBySQL(sqlIndex);
		if (indexMap != null) {
			String indexStr = (String) indexMap.get("indexloc");
			if (indexStr != null && !"".equals(indexStr)) {
				order = Integer.parseInt(indexStr) + 1;
			}
		}
		return order;
	}

	/*
	 * 多列树多拽时设置树node的order
	 */
	public static void setOrderOfTreeDragDrop(String tableName, String tableKeyName, ISrvMsg reqDTO) throws Exception {

		String sourceNodeId = reqDTO.getValue("sourceNodeId");
		String targetNodeZip = reqDTO.getValue("targetNodeZip");
		String targetNodeIndex = reqDTO.getValue("targetNodeIndex");
		String beforeOrAfter = reqDTO.getValue("beforeOrAfter");
		int index = Integer.parseInt(targetNodeIndex);
		if ("after".equals(beforeOrAfter)) {
			index += 1;
		}
		String sqlUpdateOthers = "update " + tableName + " set order_code=order_code+1 where parent_id='" + targetNodeZip + "' and order_code>=" + index;
		String sqlUpdateSource = "update " + tableName + " set parent_id = '" + targetNodeZip + "',order_code= " + index + " where " + tableKeyName + "='" + sourceNodeId + "'";
		jdbcTemplate.execute(sqlUpdateOthers);
		jdbcTemplate.execute(sqlUpdateSource);
	}
	

	/*
	 * 获取编码表下拉中的第一条数据
	 */
	public static String getCodeFirstData(String codingSortId) {
		String codeValue = null;
		String sqlCode = "SELECT t.coding_code AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='" + codingSortId
				+ "' and t.bsflag='0' order by t.coding_show_id ";
		List list = jdbcDao.queryRecords(sqlCode);
		if (list != null && list.size() > 0) {
			Map mapCode = (Map) list.get(0);
			if (mapCode != null) {
				codeValue = (String) mapCode.get("value");
			}
		}
		return codeValue;
	}

	/*
	 * 获取某项目的费用方案数据
	 */
	public static List<Map> getCostVersionData(String projectInfoNo) {
		String sqlCode = "select rownum row_num ,s.* from (select decode(t.if_decision,'1','blue','black')decision,t.* from bgp_op_cost_project_schema t where bsflag ='0' and project_info_no ='"+projectInfoNo+"' order by schema_name) s";
		List<Map> list = jdbcDao.queryRecords(sqlCode);
		return list;
	}

	/*
	 * 获取虚拟项目信息
	 */
	public static List<Map> getVirtualProjectInfoData(String orgSubjectionId) {
		String sqlCode = "select * from bgp_op_cost_project_basic where bsflag='0' and org_subjection_id like '"+orgSubjectionId+"%'";
		List<Map> list = jdbcDao.queryRecords(sqlCode);
		return list;
	}

	/*
	 * 根据项目编号获取项目名称
	 */
	public static String getProjectNameByProjectInfoNo(String projectInfoNo) {
		String projectName = "";
		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			String sql = "select project_name from (select project_info_no,project_name from gp_task_project union select project_info_no,project_name from bgp_op_cost_project_basic) where project_info_no = '"
					+ projectInfoNo + "'";
			Map map = jdbcDao.queryRecordBySQL(sql);
			if (map != null && map.get("projectName") != null) {
				projectName = (String) map.get("projectName");
			}
		}
		return projectName;
	}

	/*
	 * 费用科目自动编码
	 */
	public static String getCodeNodeByAutoGen(String tableName, String tablekeyName, String parentId, String costType) {
		// 自动生成编码
		String nodeCode = "";
		String maxNodeCode = null;
		boolean ifRoot = false;
		String parentNodeCode = null;
		// 判断当前节点是否为根节点
		String sqlIfRoot = "select count(1) rootnum from " + tableName + " where " + tablekeyName + " = '" + parentId + "'";
		Map mapIfRoot = jdbcDao.queryRecordBySQL(sqlIfRoot);
		if (mapIfRoot != null && !"0".equals(mapIfRoot.get("rootnum"))) {// 非根节点
			ifRoot = false;
		} else {
			ifRoot = true;
		}
		// 计算当前节点同级节点的最大编码
		String sqlNodeCode = "select max(node_code) code from " + tableName + " where bsflag='0' and  parent_id='" + parentId + "'";
		Map mapNodeCode = jdbcDao.queryRecordBySQL(sqlNodeCode);
		if (mapNodeCode != null && mapNodeCode.get("code") != null && !"".equals(mapNodeCode.get("code"))) {
			maxNodeCode = (String) mapNodeCode.get("code");
		}
		// 计算上级节点编码
		String sqlParentNodeCode = "select node_code code from " + tableName + " where bsflag='0' and " + tablekeyName + "='" + parentId + "'";
		Map mapParentNodeCode = jdbcDao.queryRecordBySQL(sqlParentNodeCode);
		if (mapParentNodeCode != null && mapParentNodeCode.get("code") != null && !"".equals(mapParentNodeCode.get("code"))) {
			parentNodeCode = (String) mapParentNodeCode.get("code");
		}
		// 计算当前节点编码
		if (maxNodeCode != null) {
			String headStr = maxNodeCode.substring(0, maxNodeCode.length() - 3);
			String tailStr = maxNodeCode.substring(maxNodeCode.length() - 3, maxNodeCode.length());
			int codeOrder = Integer.parseInt(tailStr) + 1;
			char[] ary1 = String.valueOf(codeOrder).toCharArray();
			char[] ary2 = { '0', '0', '0' };
			System.arraycopy(ary1, 0, ary2, ary2.length - ary1.length, ary1.length);
			String newTailStr = new String(ary2);
			nodeCode = headStr + newTailStr;
		} else {
			if (ifRoot) {
				nodeCode = "S" + costType + "001";
			} else {
				nodeCode = parentNodeCode + "001";
			}
		}

		return nodeCode;
	}

	/*
	 * 获取项目目标成本基本信息表主键
	 */
	public static String getTargetProjectBasicId(String projectInfoNo) {
		String querySql = "select tartget_basic_id id from bgp_op_target_project_basic where bsflag='0' and project_info_no='" + projectInfoNo + "'";
		Map map = jdbcDao.queryRecordBySQL(querySql);
		if (map == null) {
			Map mapForSave = new HashMap();
			mapForSave.put("project_info_no", projectInfoNo);
			mapForSave.put("bsflag", "0");
			mapForSave.put("create_date", new Date());
			mapForSave.put("update_date", new Date());
			return ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).saveOrUpdateEntity(mapForSave, "bgp_op_target_project_basic").toString();
		} else {
			return (String) map.get("id");
		}
	}

	/*
	 * 获取项目目标成本类型
	 */
	public static String getCostTypeOfTargetProject(String projectInfoNo) {
		String costType = "";
		String sqlCostType = " select distinct cost_type from bgp_op_target_project_info where bsflag='0' and  project_info_no='" + projectInfoNo + "'";
		Map map = jdbcDao.queryRecordBySQL(sqlCostType);
		if (map != null && map.get("costType") != null && !"".equals(map.get("costType"))) {
			costType = (String) map.get("costType");
		} else {
			String sqlCode = "SELECT t.coding_code AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='5110000023' and t.bsflag='0' order by t.coding_show_id ";
			List list = jdbcDao.queryRecords(sqlCode);
			if (list != null && list.size() > 0) {
				Map mapCode = (Map) list.get(0);
				if (mapCode != null) {
					costType = (String) mapCode.get("costType");
				}
			}
		}
		return costType;
	}

	/*
	 * 获取版本名称
	 */
	public static String getCostSchemaNameById(String schemaId) {
		String sql = "select schema_name from bgp_op_cost_project_schema where cost_project_schema_id ='" + schemaId + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (map == null) {
			return null;
		} else {
			return (String) map.get("schemaName");
		}
	}

	/*
	 * 获取一体化方案模板类型
	 */
	public static String getCostTypeBySchemaId(String schemaId) {
		String sql = "select max(ct.cost_type) cost_type from bgp_op_cost_project_info pi inner join bgp_op_cost_template ct on pi.template_id = ct.template_id and pi.cost_project_schema_id = '"
				+ schemaId + "' ";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (map == null) {
			return null;
		} else {
			return (String) map.get("costType");
		}
	}

	/*
	 * list生成string并用分号隔开
	 */

	public static String[] getStringFromList(List<String> list) {

		String[] returnStr = new String[list.size()];
		for (int i = 0; i < list.size(); i++) {
			returnStr[i] = list.get(i);
		}
		return returnStr;
	}

	/*
	 * 目标计划费用金额
	 */
	public static void setTargetMoneyInfoByCode(List<String> list, String code, double money, String moneyDesc, String projectInfoNo) throws ParseException {
		DecimalFormat df = new DecimalFormat("0.00");
		StringBuffer sql = new StringBuffer(
				"select pi.gp_target_project_id,pd.target_project_detail_id,pd.cost_detail_money,pd.cost_detail_desc from bgp_op_target_project_info pi ");
		sql.append(" left outer join bgp_op_target_project_detail pd on pi.gp_target_project_id = pd.gp_target_project_id and pd.bsflag='0' ");
		sql.append(" where pi.project_info_no= '" + projectInfoNo + "' and pi.bsflag='0' and pi.node_code = '" + code + "'  ");
		Map map = pureDao.queryRecordBySQL(sql.toString());
		if (map != null) {
			map.put("cost_detail_money", df.format(money));
			map.put("cost_detail_desc", moneyDesc);
			map.put("bsflag", "0");

			String sqlInsert = "insert into bgp_op_target_project_detail (target_project_detail_id,gp_target_project_id,cost_detail_money,cost_detail_desc,bsflag,create_date,modifi_date) "
					+ "(select sys_guid(),'{gp_target_project_id}',{cost_detail_money},{cost_detail_desc},'0',sysdate,sysdate from dual)";
			String sqlUpdate = "update bgp_op_target_project_detail set cost_detail_money = {cost_detail_money},cost_detail_desc={cost_detail_desc} where target_project_detail_id='{target_project_detail_id}'";
			String targetProjectDetailId = (String) map.get("target_project_detail_id");
			if (targetProjectDetailId != null && !"".equals(targetProjectDetailId)) {
				sqlUpdate = sqlUpdate.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlUpdate = sqlUpdate.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				sqlUpdate = sqlUpdate.replace("{target_project_detail_id}", targetProjectDetailId);
				list.add(sqlUpdate);
			} else {
				sqlInsert = sqlInsert.replace("{gp_target_project_id}", (String) map.get("gp_target_project_id"));
				sqlInsert = sqlInsert.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlInsert = sqlInsert.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				list.add(sqlInsert);
			}
		}
	}

	/*
	 * 反馈变更费用金额
	 */
	public static void setTargetMoneyInfoChangeByCode(List<String> list, String code, double money, String moneyDesc, String projectInfoNo) throws ParseException {
		DecimalFormat df = new DecimalFormat("0.00");
		StringBuffer sql = new StringBuffer("select pi.gp_target_project_id,pd.target_change_id,pd.cost_detail_money,pd.cost_detail_desc from bgp_op_target_project_info pi ");
		sql.append(" left outer join bgp_op_target_project_change pd on pi.gp_target_project_id = pd.gp_target_project_id and pd.bsflag='0' ");
		sql.append(" where pi.project_info_no= '" + projectInfoNo + "' and pi.bsflag='0' and pi.node_code = '" + code + "'  ");
		Map map = pureDao.queryRecordBySQL(sql.toString());
		if (map != null) {
			map.put("cost_detail_money", df.format(money));
			map.put("bsflag", "0");

			String sqlInsert = "insert into bgp_op_target_project_change (target_change_id,gp_target_project_id,cost_detail_money,cost_detail_desc,bsflag,create_date,modifi_date) "
					+ "(select sys_guid(),'{gp_target_project_id}',{cost_detail_money},{cost_detail_desc},'0',sysdate,sysdate from dual)";
			String sqlUpdate = "update bgp_op_target_project_change set cost_detail_money = {cost_detail_money},cost_detail_desc={cost_detail_desc} where target_change_id='{target_change_id}'";
			String targetChangeId = (String) map.get("target_change_id");
			if (targetChangeId != null && !"".equals(targetChangeId)) {
				sqlUpdate = sqlUpdate.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlUpdate = sqlUpdate.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				sqlUpdate = sqlUpdate.replace("{target_change_id}", targetChangeId);
				list.add(sqlUpdate);
			} else {
				sqlInsert = sqlInsert.replace("{gp_target_project_id}", (String) map.get("gp_target_project_id"));
				sqlInsert = sqlInsert.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlInsert = sqlInsert.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				list.add(sqlInsert);
			}
		}

	}

	/*
	 * 反馈实际费用金额
	 */
	public static void setTargetMoneyInfoActualByCode(List<String> list, String code, double money, String moneyDesc, String projectInfoNo) throws ParseException {
		DecimalFormat df = new DecimalFormat("0.00");
		StringBuffer sql = new StringBuffer("select pi.gp_target_project_id,pd.actual_detail_id,pd.cost_detail_money,pd.cost_detail_desc from bgp_op_target_project_info pi ");
		sql.append(" left outer join bgp_op_actual_project_detail pd on pi.gp_target_project_id = pd.gp_target_project_id and pd.bsflag='0' ");
		sql.append(" where pi.project_info_no= '" + projectInfoNo + "' and pi.bsflag='0' and pi.node_code = '" + code + "'  ");
		Map map = pureDao.queryRecordBySQL(sql.toString());
		if (map != null) {
			// map.remove("actual_detail_id");
			String sqlInsert = "insert into bgp_op_actual_project_detail (actual_detail_id,gp_target_project_id,cost_detail_money,cost_detail_desc,bsflag,create_date,modifi_date,occur_date) "
					+ "(select sys_guid(),'{gp_target_project_id}',{cost_detail_money},{cost_detail_desc},'0',sysdate,sysdate,sysdate from dual)";
			String sqlUpdate = "update bgp_op_actual_project_detail set cost_detail_money = {cost_detail_money},cost_detail_desc={cost_detail_desc} where actual_detail_id='{actual_detail_id}'";
			String actualDetailId = (String) map.get("actual_detail_id");
			if (actualDetailId != null && !"".equals(actualDetailId)) {
				sqlUpdate = sqlUpdate.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlUpdate = sqlUpdate.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				sqlUpdate = sqlUpdate.replace("{actual_detail_id}", actualDetailId);
				list.add(sqlUpdate);
			} else {
				sqlInsert = sqlInsert.replace("{gp_target_project_id}", (String) map.get("gp_target_project_id"));
				sqlInsert = sqlInsert.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlInsert = sqlInsert.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				list.add(sqlInsert);
			}
		}

	}

	/*
	 * 反馈实际费用金额
	 */
	public static void setTargetMoneyInfoActualByCodeDate(List<String> list, String code, double money, String moneyDesc, String projectInfoNo, String currentDate)
			throws ParseException {
		DecimalFormat df = new DecimalFormat("0.00");
		StringBuffer sql = new StringBuffer("select pi.gp_target_project_id,pd.actual_detail_id,pd.cost_detail_money,pd.cost_detail_desc from bgp_op_target_project_info pi ");
		sql.append(" left outer join bgp_op_actual_project_detail pd on pi.gp_target_project_id = pd.gp_target_project_id and pd.bsflag='0' and pd.occur_date=to_date('"
				+ currentDate + "','yyyy-MM-dd')");
		sql.append(" where pi.project_info_no= '" + projectInfoNo + "' and pi.bsflag='0' and pi.node_code = '" + code + "'  ");
		Map map = pureDao.queryRecordBySQL(sql.toString());
		if (map != null) {
			// map.remove("actual_detail_id");
			String sqlInsert = "insert into bgp_op_actual_project_detail (actual_detail_id,gp_target_project_id,cost_detail_money,cost_detail_desc,bsflag,create_date,modifi_date,occur_date) "
					+ "(select sys_guid(),'{gp_target_project_id}',{cost_detail_money},{cost_detail_desc},'0',sysdate,sysdate,to_date('"
					+ currentDate
					+ "','yyyy-MM-dd') from dual)";
			String sqlUpdate = "update bgp_op_actual_project_detail set cost_detail_money = {cost_detail_money},cost_detail_desc={cost_detail_desc} where actual_detail_id='{actual_detail_id}'";
			String actualDetailId = (String) map.get("actual_detail_id");
			if (actualDetailId != null && !"".equals(actualDetailId)) {
				sqlUpdate = sqlUpdate.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlUpdate = sqlUpdate.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				sqlUpdate = sqlUpdate.replace("{actual_detail_id}", actualDetailId);
				list.add(sqlUpdate);
			} else {
				sqlInsert = sqlInsert.replace("{gp_target_project_id}", (String) map.get("gp_target_project_id"));
				sqlInsert = sqlInsert.replace("{cost_detail_money}", "to_number('" + df.format(money) + "')");
				sqlInsert = sqlInsert.replace("{cost_detail_desc}", moneyDesc == null ? "null" : "'" + moneyDesc + "'");
				list.add(sqlInsert);
			}
		}

	}

	/*
	 * 设置分页信息
	 */
	public static void setFenyeInfo(ISrvMsg reqDTO, ISrvMsg responseDTO, String querySql) throws SOAPException {
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;

		String queryFenye = "select * from (select datas.*,rownum rownum_,rownum from (" + querySql + ") datas where rownum <= " + rowEnd + ") where rownum_ > " + rowStart;
		String queryCount = "select count(1) count from (" + querySql + ")";

		String totalRows = "0";
		Map countMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryCount.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		List list = jdbcDao.queryRecords(queryFenye.toString());

		responseDTO.setValue("datas", list);

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		responseDTO.setValue("totalRows", total);
		responseDTO.setValue("pageCount", pageCount);
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("currentPage", currentPage);
	}

	/*
	 * 设置计划基础数据
	 */
	public static void setFormulaBasicInfoOfPlan(Map<String, Double> map, String code, double value, String desc, String projectInfoNo) {
		map.put(code, value);
	}

	/*
	 * 设置实际基础数据
	 */
	public static void setFormulaBasicInfoOfActual(Map<String, Double> map, String code, double value, String desc, String projectInfoNo) {
		map.put(code, value);
	}

	/*
	 * 替换掉公式中的业务抽象，并计算公式的结果值
	 */
	public static double getFormulaDataByBasicInfo(Map<String, Double> map, String formulaContent) {

		// 替换{}字符
		StringBuffer resultString = new StringBuffer();
		StringBuffer resultDescString = new StringBuffer();
		Pattern regex = Pattern.compile("\\{[^\\{\\}]*\\}");
		Matcher regexMatcher = regex.matcher(formulaContent);
		while (regexMatcher.find() && map != null) {
			String matchStr = regexMatcher.group();
			regexMatcher.appendReplacement(resultString, String.valueOf(map.get(matchStr)));
		}
		regexMatcher.appendTail(resultString);
		regexMatcher.appendTail(resultDescString);

		// 四则运算
		double result = 0f;
		try {
			result = OPCaculator.excute(resultString.toString());
		} catch (Exception e) {
			return 0f;
		}
		return result;
	}

	/*
	 * 替换掉公式中的业务抽象
	 */

	public static String getFormulaDescByBasicInfo(Map<String, Double> map, String formulaContent) {
		DecimalFormat df = new DecimalFormat("0.0000");
		// 替换{}字符
		StringBuffer resultDescString = new StringBuffer();
		Pattern regex = Pattern.compile("\\{[^\\{\\}]*\\}");
		Matcher regexMatcher = regex.matcher(formulaContent);
		while (regexMatcher.find() && map != null) {
			String matchStr = regexMatcher.group();
			try {
				double value = 0;
				if(map.get(matchStr)!=null){
					value = map.get(matchStr);
				}
				String descString = matchStr.replace("}", df.format(value) + "}");
				regexMatcher.appendReplacement(resultDescString, descString);
			} catch (Exception ex) {
				System.out.println("-------------------------------->" + matchStr);
				ex.printStackTrace();
			}
		}
		regexMatcher.appendTail(resultDescString);

		return resultDescString.toString();
	}

	/*
	 * 获取excel中指定块的数据
	 */
	public static List<Map> getDataBlockFromExcel(WSFile file, int startCol, int startRow, int colNum, String costType, String reportDate, UserToken user) throws IOException {
		List<Map> dataList = new ArrayList<Map>();
		if (file.getFilename().endsWith("xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new HSSFWorkbook(is);
			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			for (int m = startRow; m < rows; m++) {
				Row row = sheet0.getRow(m);
				Map map = new HashMap();
				char dataLoc = 'A';
				for (int j = startCol; j < startCol + colNum; j++) {
					Cell cell = row.getCell(j);
					if (j == startCol) {
						map.putAll(getReportDataInfoByCostName(cell.getStringCellValue(), costType));
					} else {
						switch (cell.getCellType()) {
						case HSSFCell.CELL_TYPE_FORMULA:
							cell.setCellType(Cell.CELL_TYPE_NUMERIC);
							break;
						case HSSFCell.CELL_TYPE_NUMERIC:
							break;
						}
						map.put("data_" + dataLoc, cell.getNumericCellValue());
						dataLoc += 1;
					}
				}
				map.put("report_date", reportDate);
				map.put("bsflag", "0");
				map.put("org_id", user.getCodeAffordOrgID());
				map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				map.put("spare5", m);
				dataList.add(map);
			}
		}
		return dataList;
	}

	/*
	 * 获取excel中指定块的数据
	 */
	public static List<Map> getDataBlockFromExcel(WSFile file, int startCol, int startRow, int colNum) throws IOException {
		List<Map> dataList = new ArrayList<Map>();
		if (file.getFilename().endsWith("xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			HSSFWorkbook book = new HSSFWorkbook(is);
			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			for (int m = startRow; m < rows; m++) {
				Row row = sheet0.getRow(m);
				Map map = new HashMap();
				char dataLoc = 'A';
				for (int j = startCol; j < startCol + colNum && row != null; j++) {
					Cell cell = row.getCell(j);
					if (cell != null) {
						String strCell = "";
						switch (cell.getCellType()) {
						case HSSFCell.CELL_TYPE_FORMULA:
							try {
								if (HSSFDateUtil.isCellDateFormatted(cell)) {
									Date date = cell.getDateCellValue();
									strCell = date.toString();
									break;
								} else {
									strCell = String.valueOf(cell.getNumericCellValue());
								}
							} catch (IllegalStateException e) {
								strCell = String.valueOf(cell.getRichStringCellValue());
							}
							map.put("data_" + dataLoc, strCell);
							break;
						case HSSFCell.CELL_TYPE_NUMERIC:
							map.put("data_" + dataLoc, cell.getNumericCellValue());
							break;
						case HSSFCell.CELL_TYPE_STRING:
							map.put("data_" + dataLoc, cell.getStringCellValue());
							break;
						}
					} else {
						map.put("data_" + dataLoc, " ");
					}
					dataLoc += 1;
				}
				dataList.add(map);
			}
		}
		return dataList;
	}

	/*
	 * 更新方案的科目信息
	 */
	public static List<String> setVersionDataBlockByExcel(List<Map> list, String projectInfoNo, String costProjectSchemaId) throws IOException {
		StringBuffer sqlQuery = new StringBuffer(
				"select * from(select t.*,count(1) over (partition by cost_name) cost_name_num from(select pi.gp_cost_project_id,pi.cost_name,pd.cost_project_detail_id,pi.template_id,pi.parent_id, ");
		sqlQuery.append(" connect_by_isleaf leaf from BGP_OP_COST_PROJECT_INFO pi ");
		sqlQuery.append(" left outer join bgp_op_cost_project_detail pd on pi.gp_cost_project_id = pd.gp_cost_project_id and pd.bsflag = '0' ");
		sqlQuery.append(" where  connect_by_isleaf='1' and  pi.project_info_no = '" + projectInfoNo + "' and pi.cost_project_schema_id = '" + costProjectSchemaId
				+ "' and pi.bsflag = '0' ");
		sqlQuery.append(" start with pi.parent_id = '01' connect by prior pi.gp_cost_project_id=pi.parent_id) t ) where cost_name_num = '1' ");
		List<Map> listResult = pureDao.queryRecords(sqlQuery.toString());
		List<String> sql = new ArrayList<String>();
		for (Map map : listResult) {
			String costName = (String) map.get("cost_name");
			String costProjectDetailId = (String) map.get("cost_project_detail_id");
			String gpCostProjectId = (String) map.get("gp_cost_project_id");
			for (Map mapArg : list) {
				String dataA = (String) mapArg.get("data_A");
				String dataB = String.valueOf(mapArg.get("data_B") == null||String.valueOf(mapArg.get("data_B")).trim().equals("") ? 0 : mapArg.get("data_B"));
				String dataC = (String) mapArg.get("data_C");
				dataC = dataC == null ? " " : dataC;
				if (costName.equals(dataA)) {
					if (costProjectDetailId == null || "".equals(costProjectDetailId)) {
						String temp = "insert into bgp_op_cost_project_detail(cost_project_detail_id,gp_cost_project_id,cost_project_schema_id,cost_detail_money,cost_detail_desc,bsflag) values ((select sys_guid() from dual),"
								+ "'" + gpCostProjectId + "','" + costProjectSchemaId + "'," + dataB + "*10000,'" + dataC + "','0')";
						sql.add(temp);
					} else {
						String temp = "update bgp_op_cost_project_detail set COST_DETAIL_MONEY=to_number('" + dataB + "')*10000,COST_DETAIL_DESC='" + dataC
								+ "' where cost_project_detail_id='" + costProjectDetailId + "'";
						sql.add(temp);
					}
				}
			}
		}
		return sql;
	}

	/*
	 * 获取报表科目信息
	 */
	public static Map getReportDataInfoByCostName(String costName, String costType) {
		Map map = new HashMap();
		costName = costName.trim();
		map.put("cost_name", costName);
		String sql = "select report_template_id,node_code,order_code,cost_type from bgp_op_report_template where cost_name = '" + costName + "' and cost_type = '" + costType
				+ "' and bsflag='0'";
		Map mapTemplate = pureDao.queryRecordBySQL(sql);
		if (mapTemplate != null) {
			map.putAll(mapTemplate);
		}
		return map;
	}

	/*
	 * 根据LIST 以及tableName 批量保存数据
	 */
	public static boolean saveListDataInfoByTableName(List<Map> list, String tableName) throws Exception {
		tableName = tableName.toUpperCase();
		// 获取表主键
		String sqlPrimaryKey = "select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = 'P' and au.table_name = '"
				+ tableName + "'";
		Map mapPrimaryKey = pureDao.queryRecordBySQL(sqlPrimaryKey);
		String primaryKey = (String) mapPrimaryKey.get("column_name");
		// 获取表各字段类型
		String sqlColumaType = "select t.* from user_tab_columns t where  t.table_name = '" + tableName + "'";
		List<Map> listColumanType = pureDao.queryRecords(sqlColumaType);
		Map mapColumanType = new HashMap();
		for (Map temp : listColumanType) {
			mapColumanType.put(temp.get("column_name"), temp.get("data_type"));
		}
		String[] sqlUpdates = new String[list.size()];
		int sqlUpdateLoc = 0;
		for (Map temp : list) {
			if (temp.containsKey(primaryKey.toLowerCase())) {// 修改
				String sqlUpdate = "update " + tableName + " set ";
				Set<String> key = temp.keySet();
				for (Iterator it = key.iterator(); it.hasNext();) {
					String columnName = (String) it.next();
					columnName = columnName.trim();
					if (mapColumanType.containsKey(columnName.toUpperCase()) && !primaryKey.equals(columnName.toUpperCase())) {
						String columnType = (String) mapColumanType.get(columnName.toUpperCase());
						Object value = temp.get(columnName);
						if (columnType.equals("VARCHAR2")) {
							sqlUpdate += columnName + "='" + String.valueOf(value) + "' and ";
						} else if (columnType.equals("NUMBER")) {
							sqlUpdate += columnName + "=to_number('" + String.valueOf(value) + "') and ";
						} else if (columnType.equals("DATE")) {
							sqlUpdate += columnName + "=to_date('" + String.valueOf(value) + "','yyyy-MM-dd') and ";
						}
					}
				}
				if (sqlUpdate.endsWith("and ")) {
					sqlUpdate = sqlUpdate.substring(0, sqlUpdate.length() - 4);
				}
				sqlUpdate += " where '" + primaryKey + "'='" + String.valueOf(temp.get(primaryKey.toLowerCase())) + "'";
				sqlUpdates[sqlUpdateLoc++] = sqlUpdate;
			} else {// 新增
				String sqlInsertB = "insert into  " + tableName + " ( ";
				String sqlInsertA = "values(";
				Set<String> key = temp.keySet();
				for (Iterator it = key.iterator(); it.hasNext();) {
					String columnName = (String) it.next();
					if (mapColumanType.containsKey(columnName.toUpperCase())) {
						String columnType = (String) mapColumanType.get(columnName.toUpperCase());
						Object value = temp.get(columnName);
						sqlInsertB += columnName.toUpperCase() + ",";
						if (columnType.equals("VARCHAR2")) {
							sqlInsertA += "'" + String.valueOf(value) + "' , ";
						} else if (columnType.equals("NUMBER")) {
							sqlInsertA += "to_number('" + String.valueOf(value) + "') , ";
						} else if (columnType.equals("DATE")) {
							sqlInsertA += "to_date('" + String.valueOf(value) + "','yyyy-MM-dd') , ";
						}
					}
				}
				sqlInsertB += primaryKey + ")";
				sqlInsertA += " (select sys_guid() from dual) )";
				sqlUpdates[sqlUpdateLoc++] = sqlInsertB + sqlInsertA;
			}

		}
		jdbcTemplate.batchUpdate(sqlUpdates);
		return true;
	}

	/*
	 * 获取当前单价库导入时间
	 */
	public static String getCostPricePrjDate(String projectInfoNo) throws Exception {
		String sql = "select max(create_date) cdate from bgp_op_price_project_info where project_info_no='" + projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		String cdate = "";
		if (map != null) {
			cdate = (String) map.get("cdate");
		}
		return cdate;
	}

	/*
	 * 生成序列号
	 */
	public static String getNumberOfTargetVersion(String projectInfoNo) throws Exception {
		String sql = "select max(gather_version) ver_number from bgp_op_target_gather_info where project_info_no='" + projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		String verNumber = "";
		if (map != null) {
			verNumber = (String) map.get("ver_number");
		}
		if (verNumber == null || "".equals(verNumber)) {
			verNumber = "001";
		} else {
			int codeOrder = Integer.parseInt(verNumber) + 1;
			char[] ary1 = String.valueOf(codeOrder).toCharArray();
			char[] ary2 = { '0', '0', '0' };
			System.arraycopy(ary1, 0, ary2, ary2.length - ary1.length, ary1.length);
			verNumber = new String(ary2);
		}
		return verNumber;
	}
	
	// 处理综合无他花坛项目艰苦状况
	public static void saveWtprojectHealthInfo(String projectInfoNo) throws Exception{
		Map map_info = new HashMap();
		
		
		String sqlDeleteInfo = "delete from bgp_pm_project_heath_info where project_info_no='" + projectInfoNo + "'";
		String sqlDeleteDetail = "delete from bgp_pm_project_heath_detail_wt where project_info_no='" + projectInfoNo + "'";
		
		jdbcTemplate.execute(sqlDeleteInfo);
		jdbcTemplate.execute(sqlDeleteDetail);
		//偏离度开始
		String sqlType = " select * from gp_task_project where project_info_no = '"+projectInfoNo+"' and bsflag='0'";//查询项目勘探方法
		Map mapType=pureDao.queryRecordBySQL(sqlType);
		String methodList = mapType.get("exploration_method").toString();
		String[] methods = methodList.split(",");

		List<String> typeList = Arrays.asList(methods);
		for(int i=0;i<typeList.size();i++){
			String sql = " select max(produce_date) as produce_date from gp_ops_daily_report_zb where project_info_no='"+projectInfoNo+"' "
					+ " and exploration_method='"+typeList.get(i).toString()+"' and task_status = '1' ";//获取每个勘探方法日报里面最大日期
			Map dailyMap =pureDao.queryRecordBySQL(sql);
			String produce_date = dailyMap.get("produce_date").toString();
			String plan_date  = "";
			String[] mid = {"02","03","05","01"};
			
			for(int j=0;j<mid.length;j++){//取每个勘探方法计划最大日期
				String sql_ = " select max(w.mdate) mdate from gp_proj_product_plan_wt w join bgp_activity_method_mapping m "
						+ " on w.mid = m.activity_object_id and w.project_info_no = m.project_info_no and m.bsflag = '0'"
						+ " and w.project_info_no ='"+projectInfoNo+"' and w.wid = '"+mid[j]+"' "
						+ " and m.exploration_method ='"+typeList.get(i).toString()+"'";
				Map map_ =pureDao.queryRecordBySQL(sql_);
				plan_date = map_.get("mdate").toString();
				if(plan_date.length()!=0){
					break;
				}
			}
			
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date date1 = sdf.parse(produce_date);
			Date date2 = sdf.parse(plan_date);
			String end_date = new String();
			if(date2.after(date1)){//如果计划日期大于日报日期  统计时间按照日报时间
				end_date = produce_date;
			}else{
				end_date = plan_date;
			}
			
			String sql_sum_1 = " SELECT SUM(NVL(daily_workload,0))       AS daily_workload, SUM(NVL(daily_physical_point,0)) AS daily_physical_point"
					+ " FROM gp_ops_daily_report_zb WHERE PROJECT_INFO_NO ='"+projectInfoNo+"' and EXPLORATION_METHOD ='"+typeList.get(i).toString()+"' "
					+ " AND bsflag='0' AND PRODUCE_DATE < to_date('"+end_date+"','yyyy-MM-dd') ";
			Map sql_map_1 =pureDao.queryRecordBySQL(sql_sum_1);
			String dailyValue = "";
			
			if(!sql_map_1.get("daily_workload").equals("0")){
			  dailyValue = "" + sql_map_1.get("daily_workload");
		    }else{
			  dailyValue = "" + sql_map_1.get("daily_physical_point");
		    }
			
			
			
			String planValue = "";
			for(int j=0;j<mid.length;j++){//取每个勘探方法计划最大日期
				String sql_sum_2 = " select sum(value) AS planval from gp_proj_product_plan_wt w join bgp_activity_method_mapping m "
						+ " on w.mid = m.activity_object_id and w.project_info_no = m.project_info_no and m.bsflag = '0'"
						+ " and w.project_info_no ='"+projectInfoNo+"' and w.wid = '"+mid[j]+"' "
						+ " and m.exploration_method ='"+typeList.get(i).toString()+"' "
						+ " and to_date(mdate,'yyyy-MM-dd')<to_date('"+end_date+"','yyyy-MM-dd') ";
				Map map_ =pureDao.queryRecordBySQL(sql_sum_2);
				planValue = map_.get("planval").toString();
				if(planValue.length()!=0){
					break;
				}
			}
			double radio = 0.0;
			if(planValue.equals("0")){
				radio = 0;
			}else{
				radio = (double) (Double.parseDouble(dailyValue) - Double.parseDouble(planValue))/ Double.parseDouble(planValue) * 100;
			}
			
			//工作量滞后不超过10%，亮绿灯；工作量滞后10%-20%，亮黄灯；工作量偏差滞后超过20%，亮红灯。计划偏离度为正则为超前，为负则为滞后。
			
			if(radio<0){
				double abs = Math.abs(radio);//取绝对值
				if(abs<=10){
					map_info.put("pm_info", "green");
				}else if(abs>10&&abs<=20){
					map_info.put("pm_info", "yellow");
				}else{
					map_info.put("pm_info", "red");
				}
			}
			DecimalFormat df = new DecimalFormat();
			String style = "0.00";
			df.applyPattern(style);
			Map map_detail_1 = new HashMap();
			map_detail_1.put("project_info_no", projectInfoNo);
			map_detail_1.put("heath_content", df.format(radio));
			map_detail_1.put("exploration_method", typeList.get(i).toString());
			map_detail_1.put("heath_order", typeList.get(i).toString().substring(17, 19));
			map_detail_1.put("remark", "工作量滞后不超过10%，亮绿灯；工作量滞后10%-20%，亮黄灯；工作量偏差滞后超过20%，亮红灯。计划偏离度为正则为超前，为负则为滞后");
			map_detail_1.put("creator","");
			map_detail_1.put("bsflag","0");
			pureDao.saveEntity(map_detail_1, "bgp_pm_project_heath_detail_wt");
			//偏离度结束
			
			//质量开始
			String sql_zl = " SELECT "
					+ "ds1.project_info_no,"
					+ "ds1.EXPLORATION_METHOD,"
					+ "ccsd.CODING_NAME,"
					+ "NVL(ds1.sum_FIRST_GRADE/ds1.sum_PHYSICAL_POINT* 100,0)            AS rat1,"
					+ "NVL(ds1.sum_CONFORMING_PRODUCTS/ds1.sum_PHYSICAL_POINT* 100,0)    AS rat2,"
					+ "NVL(ds1.sum_NON_CONFORMING_PRODUCTS/ds1.sum_PHYSICAL_POINT*100,0) AS rat3,"
					+ "NVL(ds1.sum_NULL_POINT/ds1.sum_PHYSICAL_POINT* 100,0)             AS rat4 "
					+ "FROM(SELECT project_info_no,EXPLORATION_METHOD,"
					+ "SUM(DAILY_FIRST_GRADE)  AS sum_FIRST_GRADE,"
					+ "SUM(DAILY_CONFORMING_PRODUCTS)     AS sum_CONFORMING_PRODUCTS,"
					+ "SUM(DAILY_NON_CONFORMING_PRODUCTS) AS sum_NON_CONFORMING_PRODUCTS,"
					+ "SUM(DAILY_NULL_POINT)              AS sum_NULL_POINT, "
					+ "SUM(DAILY_PHYSICAL_POINT)          AS sum_PHYSICAL_POINT "
					+ "FROM gp_ops_daily_report_zb "
					+ " WHERE project_info_no='"+projectInfoNo+"' AND BSFLAG='0' AND status = '3' "
					+ " GROUP BY project_info_no,EXPLORATION_METHOD) ds1"
					+ " JOIN  comm_coding_sort_detail ccsd"
					+ "  ON"
					+ " ccsd.CODING_CODE_ID = ds1.EXPLORATION_METHOD"
					+ " AND ccsd.bsflag='0' ";
			
			Map<String,String> map_zl =pureDao.queryRecordBySQL(sql_zl);
			
			Map map_detail_2 = new HashMap();//一级品率
			map_detail_2.put("project_info_no", projectInfoNo);
			map_detail_2.put("exploration_method", typeList.get(i).toString());
			map_detail_2.put("heath_content", map_zl.get("rat1"));
			map_detail_2.put("heath_order", "101");
			map_detail_2.put("bsflag", "0");
			pureDao.saveEntity(map_detail_2, "bgp_pm_project_heath_detail_wt");
			
			Map map_detail_3 = new HashMap();//合格品率
			map_detail_3.put("project_info_no", projectInfoNo);
			map_detail_3.put("exploration_method", typeList.get(i).toString());
			map_detail_3.put("heath_content", map_zl.get("rat2"));
			map_detail_3.put("heath_order", "102");
			map_detail_3.put("bsflag", "0");
			pureDao.saveEntity(map_detail_3, "bgp_pm_project_heath_detail_wt");
			
			Map map_detail_4 = new HashMap();//废品率
			map_detail_4.put("project_info_no", projectInfoNo);
			map_detail_4.put("exploration_method", typeList.get(i).toString());
			map_detail_4.put("heath_content", map_zl.get("rat3"));
			map_detail_4.put("heath_order", "103");
			map_detail_4.put("bsflag", "0");
			pureDao.saveEntity(map_detail_4, "bgp_pm_project_heath_detail_wt");
			
			Map map_detail_5 = new HashMap();//空点率
			map_detail_5.put("project_info_no", projectInfoNo);
			map_detail_5.put("exploration_method", typeList.get(i).toString());
			map_detail_5.put("heath_content", map_zl.get("rat4"));
			map_detail_5.put("heath_order", "104");
			map_detail_5.put("bsflag", "0");
			pureDao.saveEntity(map_detail_5, "bgp_pm_project_heath_detail_wt");
			
			//查询立项时候的质量指标
			String sql_qua = "select * from bgp_pm_quality_index where project_info_no = '"+projectInfoNo+"' and exploration_method='"+typeList.get(i).toString()+"' and bsflag='0'";
			
			Map<String,String> map_zl_xl =pureDao.queryRecordBySQL(sql_qua);
			
			String firstlevel_radio = map_zl_xl.get("firstlevel_radio").toString();//一级品
			String qualified_radio = map_zl_xl.get("qualified_radio").toString();//合格品
			String waster_radio = map_zl_xl.get("waster_radio").toString();//废品
			String miss_radio = map_zl_xl.get("miss_radio").toString();//空点
			
			if(Double.parseDouble(map_zl.get("rat1").toString())<Double.parseDouble(firstlevel_radio)||Double.parseDouble(map_zl.get("rat2").toString())<Double.parseDouble(qualified_radio)||Double.parseDouble(map_zl.get("rat3").toString())>Double.parseDouble(waster_radio)||Double.parseDouble(map_zl.get("rat4").toString())>Double.parseDouble(miss_radio)){
				map_info.put("qm_info", "red");
			}else{
				map_info.put("qm_info", "green");
			}
			//质量结束
		}
		// 质量事故分级
		StringBuffer sql2210 = new StringBuffer("     select rownum||':'||report_desc report_desc,change_flag from (select  case when t.super_num > 0 then '特大事故' ");
		sql2210.append(" when t.great_num > 0 then '重大事故' when t.large_num > 0 then '较大事故' ");
		sql2210.append("when t.small_num > 0 then  '一般事故' else '无' ");
		sql2210.append("end||',上报日期'|| to_char(t.REPORT_DATE,'yyyy-MM-dd')||'整改日期'|| ");
		sql2210.append("to_char(t.change_date,'yyyy-MM-dd')||decode(t.change_date,null,'       ','') report_desc , ");
		sql2210.append("decode(t.change_date,null,'1','0') change_flag, ");
		sql2210.append("t.report_date  from bgp_qua_accident t where t.project_info_no = '"+projectInfoNo+"' and t.bsflag = '0') ");
		sql2210.append("where report_desc not like '无%' order by report_date");
		
		List<Map> list2210 = pureDao.queryRecords(sql2210.toString());
		int changeFlag=0;
		String heathContent2210="";
		for(Map map:list2210){
			changeFlag+=Integer.parseInt((String) map.get("change_flag"));
			heathContent2210+=(String) map.get("report_desc")+";";
		}
		if(heathContent2210.endsWith(";")){
			heathContent2210=heathContent2210.substring(0, heathContent2210.length()-1);
		}
		if("".equals(heathContent2210)){
			heathContent2210="无事故发生";
		}
		if(changeFlag>0){
			map_info.put("qm_info", "red");
		}
		Map map020 = new HashMap();
		map020.put("project_info_no", projectInfoNo);
		map020.put("heath_order", "99");
		map020.put("heath_standard", "发生一般质量事故、较大质量事故、重大质量事故或特大质量事故时亮红灯");
		map020.put("heath_content", heathContent2210);
		map020.put("bsflag", "0");
		pureDao.saveEntity(map020, "bgp_pm_project_heath_detail_wt");
		

		
		
		//HSE
		// 控制性指标
		// 隐患整改率
		StringBuffer sql3110 = new StringBuffer("SELECT decode(count(1), 0, 1, sum(decode(hd.rectification_state, '已整改', '1', '1')) / count(1)) change_ratio");
		sql3110.append(" from BGP_HSE_HIDDEN_INFORMATION  hi left outer join BGP_HIDDEN_INFORMATION_DETAIL hd on hi.hidden_no=hd.hidden_no where hi.project_no='" + projectInfoNo
				+ "' and hi.bsflag='0' and hd.bsflag='0'  ");
		Map map3110 = pureDao.queryRecordBySQL(sql3110.toString());
		String changeRatio = (String) map3110.get("change_ratio");
		String color021 = null;
		if (Double.parseDouble(changeRatio) < 0.9) {
			map_info.put("hse_info", "red");
			color021="red";
		} else if (Double.parseDouble(changeRatio) < 0.98) {
			map_info.put("hse_info", "yellow");
			color021="yellow";
		}
		
		Map map021 = new HashMap();
		map021.put("project_info_no", projectInfoNo);
		map021.put("heath_order", "201");
		map021.put("heath_color", color021);
		map021.put("heath_standard", "隐患整改率低于 98%，亮黄灯；低于90%，亮红灯");
		map021.put("heath_content", Double.parseDouble(changeRatio) * 100);
		pureDao.saveEntity(map021, "bgp_pm_project_heath_detail_wt");
		
		// 工业生产重伤人数(0%)
		StringBuffer sql3120 = new StringBuffer(" select nvl(sum(m.number_harm),0) number_harm from bgp_hse_accident_news t  ");
		sql3120.append(" left outer join bgp_hse_accident_number m on t.hse_accident_id = m.hse_accident_id ");
		sql3120.append(" and m.bsflag='0' where t.accident_type = '1' and t.project_info_no='" + projectInfoNo + "'");
		Map map3120 = pureDao.queryRecordBySQL(sql3120.toString());
		String numberHarm = (String) map3120.get("number_harm");
		String color022 = null;
		if (Double.parseDouble(numberHarm) > 0) {
			map_info.put("hse_info", "red");
			color022="red";
		}
		Map map022 = new HashMap();
		map022.put("project_info_no", projectInfoNo);
		map022.put("heath_order", "202");
		map022.put("heath_color", color022);
		map022.put("heath_standard", "重伤人数超过0，亮红灯");
		map022.put("heath_content", numberHarm);
		pureDao.saveEntity(map022, "bgp_pm_project_heath_detail_wt");
		
		// 轻微环境污染和生态破坏起数(0%)
		StringBuffer sql3130 = new StringBuffer("select count(1) en_num from bgp_hse_accident_record t inner join  bgp_hse_record_environ p on t.hse_record_id = p.hse_record_id  ");
		sql3130.append(" inner join bgp_hse_accident_news m on t.hse_accident_id = m.hse_accident_id  where m.project_info_no = '" + projectInfoNo
				+ "'  and t.bsflag='0' and m.bsflag='0' ");
		Map map3130 = pureDao.queryRecordBySQL(sql3130.toString());
		String en_num = (String) map3130.get("en_num");
		String color023 = null;
		if (Double.parseDouble(en_num) > 0) {
			map_info.put("hse_info", "red");
			color023="red";
		}
		
		Map map023 = new HashMap();
		map023.put("project_info_no", projectInfoNo);
		map023.put("heath_order", "203");
		map023.put("heath_color", color023);
		map023.put("heath_standard", "事故记录中发生生态损失时，亮红灯");
		map023.put("heath_content", "生态损失发生数量：" + en_num);
		pureDao.saveEntity(map023, "bgp_pm_project_heath_detail_wt");
		
		
		// 百万工时损工伤亡发生率（LTIF）(0.15)
		StringBuffer sql3140 = new StringBuffer("select die_percent from bgp_hse_workhour_single  t where t.project_info_no = '" + projectInfoNo
				+ "' and t.bsflag='0' order by t.CREATE_DATE desc");
		Map map3140 = pureDao.queryRecordBySQL(sql3140.toString());
		String diePercent = map3140 == null ? "0" : (String) map3140.get("die_percent");
		if(diePercent == ""){
			diePercent = "0";
		}
		String color024 =null;
		if (Double.parseDouble(diePercent) > 0.15) {
			map_info.put("hse_info", "red");
			color024="red";
		} else if (Double.parseDouble(diePercent) == 0.15) {
			map_info.put("hse_info", "yellow");
			color024="yellow";
		}
		Map map024 = new HashMap();
		map024.put("project_info_no", projectInfoNo);
		map024.put("heath_order", "204");
		map024.put("heath_color", color024);
		map024.put("heath_standard", "百万工时损工伤亡发生率（LTIF）：0.15");
		map024.put("heath_content", Double.parseDouble(diePercent) * 100);
		pureDao.saveEntity(map024, "bgp_pm_project_heath_detail_wt");
		
		// 杜绝性指标（发生即为红色）
		// 杜绝一般A级及以上工业生产事故、火灾事故、环境污染或生态破坏事故
		
		StringBuffer sql3210 = new StringBuffer("  select count(1) acc_num  from bgp_hse_accident_news t  ");
		sql3210.append("  left outer join bgp_hse_accident_record r on t.hse_accident_id = r.hse_accident_id ");
		sql3210.append(" where (t.accident_type = '5110000042000000001' or t.accident_type = '5110000042000000002') and  r.accident_level != '5110000043000000002'  and r.accident_level != '5110000043000000003' and t.project_info_no='"
				+ projectInfoNo + "'");
		Map map3210 = pureDao.queryRecordBySQL(sql3210.toString());
		String accNum = (String) map3210.get("acc_num");
		String color025 = null;
		Map map025 = new HashMap();
		if (accNum != null && !"0".equals(accNum) && !"".equals(accNum)) {
			map_info.put("hse_info", "red");
			color025 = "red";
		}
		map025.put("project_info_no", projectInfoNo);
		map025.put("heath_order", "205");
		map025.put("heath_color", color025);
		map025.put("heath_standard", "发生一般A级、较大、重大、特大工业生产安全事故、火灾事故，或生态损失，亮红灯");
		map025.put("heath_content", "发生次数：" + accNum);
		pureDao.saveEntity(map025, "bgp_pm_project_heath_detail_wt");
		
		// 有效遏制一般A级交通事故
		StringBuffer sql3220 = new StringBuffer("  select count(1) acc_num_1  from bgp_hse_accident_news t  ");
		sql3220.append("  left outer join bgp_hse_accident_record r on t.hse_accident_id = r.hse_accident_id ");
		sql3220.append(" where (t.accident_type = '5110000042000000004' or t.accident_type = '5110000042000000005')   and r.accident_level != '5110000043000000002'  and r.accident_level != '5110000043000000003' and t.project_info_no='"
				+ projectInfoNo + "'");
		Map map3220 = pureDao.queryRecordBySQL(sql3220.toString());
		String accNum1 = (String) map3220.get("acc_num_1");
		
		String color026 = null;
		Map map026 = new HashMap();

		if (accNum1 != null && !"0".equals(accNum1) && !"".equals(accNum1)) {
			map_info.put("hse_info", "red");
			color026="red";
		}
		
		map026.put("project_info_no", projectInfoNo);
		map026.put("heath_order", "206");
		map026.put("heath_color", color026);
		map026.put("heath_standard", "发生一般A级、较大、重大、特大道路交通事故、水上交通事故，亮红灯");
		map026.put("heath_content", "发生次数：" + accNum1);
		pureDao.saveEntity(map026, "bgp_pm_project_heath_detail_wt");
		
		// 杜绝民爆物品丢失事故（含丢失后找回）
		StringBuffer sql3230 = new StringBuffer("  select count(1) acc_num_2  from bgp_hse_accident_news t  ");
		sql3230.append("  left outer join bgp_hse_accident_record r on t.hse_accident_id = r.hse_accident_id ");
		sql3230.append(" where (t.accident_type = '5110000042000000006' )   and r.accident_level != '5110000043000000002'  and r.accident_level != '5110000043000000003' and t.project_info_no='"
				+ projectInfoNo + "'");
		Map map3230 = pureDao.queryRecordBySQL(sql3230.toString());
		String accNum2 = (String) map3230.get("acc_num_2");
		String color027 = null;
		Map map027 = new HashMap();
		if (accNum2 != null && !"0".equals(accNum2) && !"".equals(accNum2)) {
			map_info.put("hse_info", "red");
			color027 = "red";
		}
		map027.put("project_info_no", projectInfoNo);
		map027.put("heath_order", "207");
		map027.put("heath_color", color027);
		map027.put("heath_standard", "发生一般A级、较大、重大、特大民爆物品丢失、被盗事故，亮红灯");
		map027.put("heath_content", "发生次数：" + accNum2);
		pureDao.saveEntity(map027, "bgp_pm_project_heath_detail_wt");
		
		// 杜绝在公司年度HSE体系审核定级中被评定为C级
		StringBuffer sql3240 = new StringBuffer("select max(AUDITLIST_LEVEL) AUDITLIST_LEVEL from BGP_HSE_AUDITLISTS t where t.project_no = '" + projectInfoNo
				+ "'");
		Map map3240 = pureDao.queryRecordBySQL(sql3240.toString());
		String auditlistLevel = (String) map3240.get("auditlist_level");
		String color028 = null;
		if ("C".equals(auditlistLevel) || "D".equals(auditlistLevel)) {
			map_info.put("hse_info", "red");
			color028 = "red";
		}
		Map map028 = new HashMap();
		map028.put("project_info_no", projectInfoNo);
		map028.put("heath_order", "208");
		map028.put("heath_color", color028);
		map028.put("heath_standard", "审核定级评分等级为C或D，亮红灯");
		map028.put("heath_content", auditlistLevel == null ? "暂未定级" : "级别：" + auditlistLevel);
		pureDao.saveEntity(map028, "bgp_pm_project_heath_detail_wt");
		
		
		map_info.put("project_info_no", projectInfoNo);
		map_info.put("bsflag", 0);
		map_info.put("spare4", new Date());
		pureDao.saveEntity(map_info, "bgp_pm_project_heath_info").toString();
		
		
	}
	 
	private static void saveWTProjectHealthInfo(String projectInfoNo) throws Exception{
		
	}
	/*
	 * 处理项目健康情况信息
	 */
	@SuppressWarnings("unused")
	public static void saveProjectHealthInfo(String projectInfoNo) throws Exception {
		char resultA = 'a';
		char resultB = 'a';
		char resultC = 'a';
		DecimalFormat df = new DecimalFormat("########0.00");
		List<Map> listSave = new ArrayList<Map>();
		
		
		String sqlType="select t.project_type from GP_TASK_PROJECT t  where t.project_info_no='"+projectInfoNo+"'";
		Map mapType=pureDao.queryRecordBySQL(sqlType);
		String projectType=(String) mapType.get("project_type");
		if(projectType.equals("5000100004000000009")){//跳出
			saveWtprojectHealthInfo(projectInfoNo);
			return;
		}
		
		//判断时间点：
		StringBuffer cjDateFlag=new StringBuffer("select case when sysdate<start_date then 0 when sysdate>end_date  then 0 else 1 end flag ");
		cjDateFlag.append(" from(select  case when min(t2.planned_start_date)>min(nvl(t2.actual_start_date, sysdate))  then min(t2.planned_start_date) ");
		cjDateFlag.append(" else min(nvl(t2.actual_start_date, sysdate)) end start_date ");
		cjDateFlag.append(" from bgp_p6_project t1 inner join bgp_p6_activity t2 on t1.object_id = t2.project_object_id ");
		cjDateFlag.append(" where t1.project_info_no ='"+projectInfoNo+"' and t2.name like '%测量%' and t2.bsflag = '0') ");
		cjDateFlag.append(" left outer join (select  case when max(t2.planned_finish_date)>max(nvl(t2.actual_finish_date, sysdate))  then max(t2.planned_finish_date) ");
		cjDateFlag.append(" else max(nvl(t2.actual_finish_date, sysdate)) end end_date ");
		cjDateFlag.append(" from bgp_p6_project t1 inner join bgp_p6_activity t2 on t1.object_id = t2.project_object_id ");
		cjDateFlag.append(" where t1.project_info_no ='"+projectInfoNo+"' and t2.name like '%采集%' and t2.bsflag = '0') on 1=1 ");
		
		StringBuffer plDateFlag=new StringBuffer("select case when sysdate<start_date then 0 when sysdate>end_date  then 0 else 1 end flag");
		plDateFlag.append(" from(select  case when min(t2.planned_start_date)>min(nvl(t2.actual_start_date, sysdate))  then min(t2.planned_start_date) ");
		plDateFlag.append(" else min(nvl(t2.actual_start_date, sysdate)) end start_date ");
		plDateFlag.append(" from bgp_p6_project t1 inner join bgp_p6_activity t2 on t1.object_id = t2.project_object_id ");
		plDateFlag.append(" where t1.project_info_no ='"+projectInfoNo+"' and t2.name like '%工区踏勘%' and t2.bsflag = '0') ");
		plDateFlag.append(" left outer join (select nvl(max(t3.actual_finish_date),sysdate) end_date from  bgp_p6_project t1 inner join bgp_p6_project_wbs t2  ");
		plDateFlag.append(" on t1.object_id=t2.project_object_id left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id  ");
		plDateFlag.append(" where t1.project_info_no = '"+projectInfoNo+"' start with t2.name ='资源遣散' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID) on 1=1 ");
		Map mapCjDateFlag = pureDao.queryRecordBySQL(cjDateFlag.toString());
		Map mapPlDateFlag = pureDao.queryRecordBySQL(plDateFlag.toString());
		String flagSC=(String) mapCjDateFlag.get("flag");
		String flagHSE=(String) mapPlDateFlag.get("flag");
		
		// 生产
		// 进度
		// 计划偏离度
		StringBuffer sql1110 = new StringBuffer(" select t.oper_plan_type,to_number(to_char((nvl(t.actual_work,0)-t.plan_work) / t.plan_work,'9999.0000')) rationum   ");
		sql1110.append(" from (select * from (select t.oper_plan_type,t.plan_work, ");
		sql1110.append(" decode(t.oper_plan_type,'measuredailylist',d.measuredailylist,'drilldailylist',d.drilldailylist, d.colldailylist) actual_work ");
		sql1110.append(" from (select sum(decode(pp.oper_plan_type,'measuredailylist',nvl(pp.workload_num, 0),nvl(pp.workload, 0))) plan_work, pp.oper_plan_type ");
		sql1110.append(" from gp_proj_product_plan pp where pp.project_info_no = '" + projectInfoNo + "' and pp.bsflag = '0' ");
		sql1110.append(" and to_date(pp.record_month,'yyyy-MM-dd')<sysdate group by pp.oper_plan_type) t ");
		sql1110.append(" left outer join (select sum(nvl(gd.SHOT_2D_WORKLOAD, 0) + nvl(gd.SHOT_3D_WORKLOAD, 0)) measuredailylist, ");
		sql1110.append(" sum(nvl(gd.DAILY_2D_TOTAL_SHOT, 0) + nvl(gd.DAILY_3D_TOTAL_SHOT, 0)) drilldailylist, ");
		sql1110.append(" sum(nvl(gd.DAILY_FINISHING_2D_SP, 0) + nvl(gd.DAILY_FINISHING_3D_SP, 0)) colldailylist ");
		sql1110.append(" from rpt_gp_daily gd where gd.project_info_no = '" + projectInfoNo + "' and gd.bsflag = '0') d on 1 = 1)) t ");

		//List<Map> list = pureDao.queryRecords(sql1110.toString());

		StringBuilder sql1111 = new StringBuilder("select case when start_date + Floor((end_date - start_date) / 3) >sysdate then 0 else  1 end ismiddle,oper_plan_type ");
		sql1111.append("  from (select to_date(min(t.record_month), 'yyyy-MM-dd') start_date,t.oper_plan_type,t.project_info_no, ");
		sql1111.append("  to_date(max(t.record_month), 'yyyy-MM-dd') end_date  from gp_proj_product_plan t ");
		sql1111.append("  where t.oper_plan_type in ('measuredailylist', 'drilldailylist', 'colldailylist') ");
		sql1111.append("  group by t.oper_plan_type, t.project_info_no) m  where m.project_info_no='" + projectInfoNo + "' ");
		List<Map> list1111 = pureDao.queryRecords(sql1111.toString());

		
		String getExplorationMethod = "select t.exploration_method,t.project_status from gp_task_project t where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"'";
		//获取项目二维三维
		Map explorationMethodMap = radDao.queryRecordBySQL(getExplorationMethod);
		
		//各个作业的状态
		//判断测量结束
		StringBuilder surveyStatusFlag = new StringBuilder("select survey_process_status as end_flag from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no ");
		surveyStatusFlag.append(" where d.produce_date =(select max(produce_date) from gp_ops_daily_report ");
		surveyStatusFlag.append(" where bsflag = '0' and audit_status = '3' and project_info_no = '"+projectInfoNo+"' and nvl(survey_incept_workload, 0) + nvl(survey_shot_workload, 0) > 0) and project_info_no = '"+projectInfoNo+"' and d.bsflag = '0'");
		
		//判断采集结束
		StringBuilder acquireStatusFlag = new StringBuilder("select collect_process_status as end_flag from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no ");
		acquireStatusFlag.append(" where d.produce_date = (select max(produce_date) from gp_ops_daily_report ");
		acquireStatusFlag.append(" where bsflag = '0' and audit_status = '3' and project_info_no = '"+projectInfoNo+"' and nvl(daily_acquire_sp_num, 0) + nvl(daily_jp_acquire_shot_num, 0) + nvl(daily_qq_acquire_shot_num, 0) > 0) and project_info_no = '"+projectInfoNo+"' and d.bsflag = '0'");
	
		//判断钻井结束
		StringBuilder drillStatusFlag = new StringBuilder("select drill_process_status as end_flag from gp_ops_daily_report d join gp_ops_daily_produce_sit s on s.daily_no = d.daily_no ");
		drillStatusFlag.append(" where d.produce_date = (select max(produce_date) from gp_ops_daily_report ");
		drillStatusFlag.append(" where bsflag = '0' and audit_status = '3' and project_info_no = '"+projectInfoNo+"' and  nvl(daily_drill_sp_num,0)  > 0)  and project_info_no = '"+projectInfoNo+"' and d.bsflag = '0'");
		
		String surveyStatus = "";
		String acquireStatus = "";
		String drillStatus = "";
		Map surveyStatusMap = radDao.queryRecordBySQL(surveyStatusFlag.toString());
		Map acquireStatusMap = radDao.queryRecordBySQL(acquireStatusFlag.toString());
		Map drillStatusMap = radDao.queryRecordBySQL(drillStatusFlag.toString());
		//测量状态
		if (surveyStatusMap != null) {
			String value = "" + surveyStatusMap.get("end_flag");
			if("1".equals(value)){
				surveyStatus = "未开始";
			}else if("2".equals(value)){
				surveyStatus = "正在施工";
			}else if("3".equals(value)){
				surveyStatus = "结束";
			}
		}
		//采集状态
		if (acquireStatusMap != null) {
			String value = "" + acquireStatusMap.get("end_flag");
			if("1".equals(value)){
				acquireStatus = "未开始";
			}else if("2".equals(value)){
				acquireStatus = "正在施工";
			}else if("3".equals(value)){
				acquireStatus = "结束";
			}
		}
		//钻井状态
		if (drillStatusMap != null) {
			String value = "" + drillStatusMap.get("end_flag");
			if("1".equals(value)){
				drillStatus = "未开始";
			}else if("2".equals(value)){
				drillStatus = "正在施工";
			}else if("3".equals(value)){
				drillStatus = "结束";
			}
		}
		
		//各个作业的计划工作量,实际工作量,计划开始结束时间和时间开始结束时间
		
		double sumDesignSurveyWorkload = 0;
		double sumDesignAcquireWorkload = 0;
		double sumDesignDrillWorkload = 0;
		
		double sumDailySurveyWorkload = 0;
		double sumDailyAcquireWorkload = 0;
		double sumDailyDrillWorkload = 0;
		
		String surveyDesignStartDate = "";
		String surveyDesignEndDate = "";
		String surveyDailyStartDate = "";
		String surveyDailyEndDate = "";
		String surveyCurDate = "";
		
		String acquireDesignStartDate = "";
		String acquireDesignEndDate = "";
		String acquireDailyStartDate = "";
		String acquireDailyEndDate = "";
		String acquireCurDate = "";
		
		String drillDesignStartDate = "";
		String drillDesignEndDate = "";
		String drillDailyStartDate = "";
		String drillDailyEndDate = "";
		String drillCurDate = "";
		

		
		//测量设计时间
		StringBuilder designSurveyDate = new StringBuilder("select to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month");
		designSurveyDate.append(" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ");
		designSurveyDate.append(" and oper_plan_type = 'measuredailylist' ");
		designSurveyDate.append(" order by record_month ");
		List<Map> designSurveyDateList = radDao.queryRecords(designSurveyDate.toString());
		//测量计划开始和结束时间
		if(designSurveyDateList != null & designSurveyDateList.size() > 0){
			surveyDesignStartDate = (String) ((Map) designSurveyDateList.get(0)).get("record_month");
			surveyDesignEndDate = (String) ((Map) designSurveyDateList.get(designSurveyDateList.size()-1)).get("record_month");
		}	
		
		
		//测量实际时间
		StringBuilder dailySurveyDate = new StringBuilder("select to_char(produce_date,'yyyy-MM-dd') as produce_date");
		dailySurveyDate.append(" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3' ");
		dailySurveyDate.append(" and  nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) > 0 group by produce_date order by produce_date ");
		List<Map> dailySurveyDateList = radDao.queryRecords(dailySurveyDate.toString());
		//测量实际开始和结束时间
		if(dailySurveyDateList != null && dailySurveyDateList.size() > 0){
			surveyDailyStartDate = (String) ((Map) dailySurveyDateList.get(0)).get("produce_date");
			surveyCurDate = (String) ((Map) dailySurveyDateList.get(dailySurveyDateList.size()-1)).get("produce_date");
			if("结束".equals(surveyStatus) || "结束" == surveyStatus){
				surveyDailyEndDate = (String) ((Map) dailySurveyDateList.get(dailySurveyDateList.size()-1)).get("produce_date");
			}
		}
		
		//测量设计工作量
		StringBuilder designSurveyWorkload = new StringBuilder("select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli, ");
		designSurveyWorkload.append(" to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month");
		designSurveyWorkload.append(" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ");
		designSurveyWorkload.append(" and oper_plan_type = 'measuredailylist' ");
		

		
		//测量实际工作量
		StringBuilder dailySurveyWorkload = new StringBuilder("select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value ");
		dailySurveyWorkload.append(" ,sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value ");
		dailySurveyWorkload.append(" ,sum(nvl(d.daily_drill_sp_num,0)) as drill_value ");
		dailySurveyWorkload.append(" ,to_char(produce_date,'yyyy-MM-dd') as produce_date");
		dailySurveyWorkload.append(" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3' ");
		if("结束" == surveyStatus || "结束".equals(surveyStatus)){
			if(DateOperation.diffDaysOfDate(surveyDailyEndDate,surveyDesignEndDate) >= 0){
				//如果实际完成时间大于计划完成时间 (滞后完成),截取计划时间之前的工作量之和
				dailySurveyWorkload.append(" and produce_date <= sysdate ");
				dailySurveyWorkload.append(" and produce_date <= to_date('"+surveyDesignEndDate+"','yyyy-MM-dd')");
			}else{
				dailySurveyWorkload.append(" and produce_date <= sysdate ");
				//如果任务提前完成,对计划工作量进行截取
				designSurveyWorkload.append(" and to_date(record_month,'yyyy-MM-dd') <= to_date('"+surveyDailyEndDate+"','yyyy-MM-dd') ");
			}
		}else if("未开始" != surveyStatus && !"未开始".equals(surveyStatus)){
			dailySurveyWorkload.append(" and produce_date <= sysdate ");
			if(DateOperation.diffDaysOfDate(surveyCurDate,surveyDesignEndDate) >= 0){
				dailySurveyWorkload.append(" and produce_date <= to_date('"+surveyDesignEndDate+"','yyyy-MM-dd')");
			}else{
				dailySurveyWorkload.append(" and produce_date <= to_date('"+surveyCurDate+"','yyyy-MM-dd')");
			}			
		}
		
		dailySurveyWorkload.append(" and nvl(survey_incept_workload,0)+nvl(survey_shot_workload,0) > 0 group by produce_date order by produce_date ");
		List<Map> dailySurveyList = radDao.queryRecords(dailySurveyWorkload.toString());
		if(surveyStatus == "" && dailySurveyList != null){
			surveyStatus = "正在施工";
		}

		
		//循环算出测量的实际工作量
		if(dailySurveyList != null && dailySurveyList.size() > 0){
			for (int i = 0; i < dailySurveyList.size(); i++) {
				Map dailyMap = dailySurveyList.get(i);
				sumDailySurveyWorkload += Double.parseDouble(""+dailyMap.get("measure_value"));
			}
		}

		//设计工作量
		designSurveyWorkload.append(" and to_date(record_month,'yyyy-MM-dd') <= sysdate order by record_month ");
		List<Map> designSurveyList = radDao.queryRecords(designSurveyWorkload.toString());
		
		//循环算出测量的计划工作量
		if(designSurveyList != null & designSurveyList.size() > 0){
			for (int i = 0; i < designSurveyList.size(); i++) {
				Map designMap = designSurveyList.get(i);
				sumDesignSurveyWorkload += Double.parseDouble(""+designMap.get("gongli"));
			}
		}

		
		//采集设计工作量
		StringBuilder designAcquireWorkload = new StringBuilder("select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli, ");
		designAcquireWorkload.append(" to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month");
		designAcquireWorkload.append(" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ");
		designAcquireWorkload.append(" and oper_plan_type = 'colldailylist' ");

		
		
		//采集设计时间
		StringBuilder designAcquireDate = new StringBuilder("select to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month");
		designAcquireDate.append(" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ");
		designAcquireDate.append(" and oper_plan_type = 'colldailylist' and workload is not null");
		designAcquireDate.append(" order by record_month ");
		List<Map> designAcquireDateList = radDao.queryRecords(designAcquireDate.toString());
		//采集计划开始和结束时间
		if(designAcquireDateList != null & designAcquireDateList.size() > 0){
			acquireDesignStartDate = (String) ((Map) designAcquireDateList.get(0)).get("record_month");
			acquireDesignEndDate = (String) ((Map) designAcquireDateList.get(designAcquireDateList.size()-1)).get("record_month");
		}
		
		//采集实际时间
		StringBuilder dailyAcquireDate = new StringBuilder("select to_char(produce_date,'yyyy-MM-dd') as produce_date");
		dailyAcquireDate.append(" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3' ");
		dailyAcquireDate.append(" and nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) > 0 group by produce_date order by produce_date ");
		List<Map> dailyAcquireDateList = radDao.queryRecords(dailyAcquireDate.toString());
		//采集实际开始和结束时间
		if(dailyAcquireDateList != null && dailyAcquireDateList.size() > 0){
			acquireDailyStartDate = (String) ((Map) dailyAcquireDateList.get(0)).get("produce_date");
			acquireCurDate = (String) ((Map) dailyAcquireDateList.get(dailyAcquireDateList.size()-1)).get("produce_date");
			if("结束".equals(acquireStatus) || "结束" == acquireStatus){
				acquireDailyEndDate = (String) ((Map) dailyAcquireDateList.get(dailyAcquireDateList.size()-1)).get("produce_date");
			}
		}
		
		//采集实际工作量
		StringBuilder dailyAcquireWorkload = new StringBuilder("select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value ");
		dailyAcquireWorkload.append(" ,sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value ");
		dailyAcquireWorkload.append(" ,sum(nvl(d.daily_drill_sp_num,0)) as drill_value ");
		dailyAcquireWorkload.append(" ,to_char(produce_date,'yyyy-MM-dd') as produce_date");
		dailyAcquireWorkload.append(" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3' ");
		if("结束" == acquireStatus || "结束".equals(acquireStatus)){
			if(DateOperation.diffDaysOfDate(acquireDailyEndDate,acquireDesignEndDate) >= 0){
				//如果实际完成时间大于计划完成时间 (滞后完成),截取计划时间之前的工作量之和
				dailyAcquireWorkload.append(" and produce_date <= sysdate ");
				dailyAcquireWorkload.append(" and produce_date <= to_date('"+acquireDesignEndDate+"','yyyy-MM-dd')");
			}else{
				dailyAcquireWorkload.append(" and produce_date <= sysdate ");
				//如果任务提前完成,对计划工作量进行截取
				designAcquireWorkload.append(" and to_date(record_month,'yyyy-MM-dd') <= to_date('"+acquireDailyEndDate+"','yyyy-MM-dd') ");
			}
		}else if("未开始" != acquireStatus && !"未开始".equals(acquireStatus)){
			dailyAcquireWorkload.append(" and produce_date <= sysdate ");
			
			if(DateOperation.diffDaysOfDate(acquireCurDate,acquireDesignEndDate) >= 0){
				dailyAcquireWorkload.append(" and produce_date <= to_date('"+acquireDesignEndDate+"','yyyy-MM-dd')");
			}else{
				dailyAcquireWorkload.append(" and produce_date <= to_date('"+acquireCurDate+"','yyyy-MM-dd')");
			}
			
		}
		dailyAcquireWorkload.append(" and nvl(daily_acquire_sp_num,0)+nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0) > 0 group by produce_date order by produce_date ");
		List<Map> dailyAcquireList = radDao.queryRecords(dailyAcquireWorkload.toString());
		if(acquireStatus == "" && dailyAcquireList != null){
			acquireStatus = "正在施工";
		}
		
		//设计工作量
		designAcquireWorkload.append(" and to_date(record_month,'yyyy-MM-dd') <= sysdate order by record_month ");
		List<Map> designAcquireList = radDao.queryRecords(designAcquireWorkload.toString());
		
		//循环算出采集的计划工作量
		if(designAcquireList != null & designAcquireList.size() > 0){
			for (int i = 0; i < designAcquireList.size(); i++) {
				Map designMap = designAcquireList.get(i);
				sumDesignAcquireWorkload += Double.parseDouble(""+designMap.get("paodian"));
			}
		}
		
		//循环算出采集的实际工作量
		if(dailyAcquireList != null && dailyAcquireList.size() > 0){
			for (int i = 0; i < dailyAcquireList.size(); i++) {
				Map dailyMap = dailyAcquireList.get(i);
				sumDailyAcquireWorkload += Double.parseDouble(""+dailyMap.get("coll_value"));
			}
		}

		//钻井设计工作量
		StringBuilder designDrillWorkload = new StringBuilder("select nvl(workload,0) as paodian,nvl(workload_num,0) as gongli, ");
		designDrillWorkload.append(" to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month");
		designDrillWorkload.append(" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ");
		designDrillWorkload.append(" and oper_plan_type = 'drilldailylist' ");

		
		//钻井设计时间
		StringBuilder designDrillDate = new StringBuilder("select to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month");
		designDrillDate.append(" from gp_proj_product_plan where project_info_no = '"+projectInfoNo+"' and bsflag = '0' ");
		designDrillDate.append(" and oper_plan_type = 'drilldailylist' ");
		designDrillDate.append(" order by record_month ");
		List<Map> designDrillDateList = radDao.queryRecords(designDrillDate.toString());
		//钻井计划开始和结束时间
		if(designDrillDateList != null & designDrillDateList.size() > 0){
			drillDesignStartDate = (String) ((Map) designDrillDateList.get(0)).get("record_month");
			drillDesignEndDate = (String) ((Map) designDrillDateList.get(designDrillDateList.size()-1)).get("record_month");
		}
			
		//钻井实际时间
		StringBuilder dailyDrillDate = new StringBuilder("select to_char(produce_date,'yyyy-MM-dd') as produce_date");
		dailyDrillDate.append(" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3' ");
		dailyDrillDate.append(" and nvl(daily_drill_sp_num,0) > 0 group by produce_date order by produce_date ");
		List<Map> dailyDrillDateList = radDao.queryRecords(dailyDrillDate.toString());
		
		//钻井实际开始和结束时间
		if(dailyDrillDateList != null && dailyDrillDateList.size() > 0){
			drillDailyStartDate = (String) ((Map) dailyDrillDateList.get(0)).get("produce_date");
			drillCurDate = (String) ((Map) dailyDrillDateList.get(dailyDrillDateList.size()-1)).get("produce_date");
			if("结束".equals(drillStatus) || "结束" == drillStatus){
				drillDailyEndDate = (String) ((Map) dailyDrillDateList.get(dailyDrillDateList.size()-1)).get("produce_date");
			}	
		}
		
		//钻井实际工作量
		StringBuilder dailyDrillWorkload = new StringBuilder("select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value ");
		dailyDrillWorkload.append(" ,sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value ");
		dailyDrillWorkload.append(" ,sum(nvl(d.daily_drill_sp_num,0)) as drill_value ");
		dailyDrillWorkload.append(" ,to_char(produce_date,'yyyy-MM-dd') as produce_date");
		dailyDrillWorkload.append(" from gp_ops_daily_report d where project_info_no = '"+projectInfoNo+"' and bsflag = '0' and audit_status = '3' ");
		if("结束" == drillStatus || "结束".equals(drillStatus)){
			if(DateOperation.diffDaysOfDate(drillDailyEndDate,drillDesignEndDate) >= 0){
				//如果实际完成时间大于计划完成时间 (滞后完成),截取计划时间之前的工作量之和
				dailyDrillWorkload.append(" and produce_date <= sysdate ");
				dailyDrillWorkload.append(" and produce_date <= to_date('"+drillDesignEndDate+"','yyyy-MM-dd')");
			}else{
				dailyDrillWorkload.append(" and produce_date <= sysdate ");
				//如果任务提前完成,对计划工作量进行截取
				designDrillWorkload.append(" and to_date(record_month,'yyyy-MM-dd') <= to_date('"+drillDailyEndDate+"','yyyy-MM-dd') ");
			}
		}else if("未开始" != drillStatus && !"未开始".equals(drillStatus)){
			dailyDrillWorkload.append(" and produce_date <= sysdate ");
			
			if(DateOperation.diffDaysOfDate(drillCurDate,drillDesignEndDate) >= 0){
				dailyDrillWorkload.append(" and produce_date <= to_date('"+drillDesignEndDate+"','yyyy-MM-dd')");
			}else{
				dailyDrillWorkload.append(" and produce_date <= to_date('"+drillCurDate+"','yyyy-MM-dd')");
			}
			
		}
		dailyDrillWorkload.append(" and nvl(daily_drill_sp_num,0) > 0 group by produce_date order by produce_date ");
		List<Map> dailyDrillList = radDao.queryRecords(dailyDrillWorkload.toString());
		if(drillStatus == "" && dailyAcquireList != null){
			drillStatus = "正在施工";
		}
		
		//钻井设计工作量
		designDrillWorkload.append(" and to_date(record_month,'yyyy-MM-dd') <= sysdate order by record_month ");
		List<Map> designDrillList = radDao.queryRecords(designDrillWorkload.toString());
		//循环算出钻井的计划工作量
		if(designDrillList != null & designDrillList.size() > 0){
			for (int i = 0; i < designDrillList.size(); i++) {
				Map designMap = designDrillList.get(i);
				sumDesignDrillWorkload += Double.parseDouble(""+designMap.get("paodian"));
			}
		}
		
		//循环算出钻井的实际工作量
		if(dailyDrillList != null && dailyDrillList.size() > 0){
			for (int i = 0; i < dailyDrillList.size(); i++) {
				Map dailyMap = dailyDrillList.get(i);
				sumDailyDrillWorkload += Double.parseDouble(""+dailyMap.get("drill_value"));
			}
		}

		boolean isStartM = "正在施工".equals(surveyStatus) ? true : false;
		boolean isStartD = "正在施工".equals(drillStatus) ? true : false;
		boolean isStartG = "正在施工".equals(acquireStatus) ? true : false;
		
		boolean notStartM = "未开始".equals(surveyStatus) ? true : false;
		boolean notStartD = "未开始".equals(drillStatus) ? true : false;
		boolean notStartG = "未开始".equals(acquireStatus) ? true : false;
		
		boolean isEndM = "结束".equals(surveyStatus) ? true : false;
		boolean isEndD = "结束".equals(drillStatus) ? true : false;
		boolean isEndG = "结束".equals(acquireStatus) ? true : false;
		
		//测量偏离度
		double surveyRatio = (sumDailySurveyWorkload - sumDesignSurveyWorkload) /sumDesignSurveyWorkload;
		//采集偏离度
		double acquireRatio = (sumDailyAcquireWorkload - sumDesignAcquireWorkload) /sumDesignAcquireWorkload;
		//钻井偏离度
		double drillRation = (sumDailyDrillWorkload - sumDesignDrillWorkload) /sumDesignDrillWorkload;
		
		boolean middleM = false;
		boolean middleD = false;
		boolean middleG = false;
		for (Map map1111 : list1111) {
			if ("measuredailylist".equals(map1111.get("oper_plan_type")) && "1".equals(map1111.get("ismiddle"))) {
				middleM = true;
			} else if ("drilldailylist".equals(map1111.get("oper_plan_type")) && "1".equals(map1111.get("ismiddle"))) {
				middleD = true;
			} else if ("colldailylist".equals(map1111.get("oper_plan_type")) &&"1".equals(map1111.get("ismiddle"))) {
				middleG = true;
			}
		}
		
		String color001 = null;
		String color002 = null;
		String color003 = null;
		if (isStartM) {
			if (middleM) {// 后三分之二周期
				if (surveyRatio < -0.15) {
					resultA = 'c';
					color001 = "red";
				} else if (surveyRatio < -0.05) {
					resultA = 'b';
					color001 = "yellow";
				}
			} else {
				if (surveyRatio < -0.3) {
					resultA = 'c';
					color001 = "red";
				} else if (surveyRatio < -0.1) {
					resultA = 'b';
					color001 = "yellow";
				}
			}
		}
		if (isStartD) {
			if (middleD) {// 后三分之二周期
				if (drillRation < -0.15) {
					resultA = 'c';
					color002 = "red";
				} else if (drillRation < -0.05) {
					resultA = 'b';
					color002 = "yellow";
				}
			} else {
				if (drillRation < -0.3) {
					resultA = 'c';
					color002 = "red";
				} else if (drillRation < -0.1) {
					resultA = 'b';
					color002 = "yellow";
				}
			}
		}
		if (isStartG) {
			if (middleG) {// 后三分之二周期
				if (acquireRatio < -0.15) {
					resultA = 'c';
					color003 = "red";
				} else if (acquireRatio < -0.05) {
					resultA = 'b';
					color003 = "yellow";
				}
			} else {
				if (acquireRatio < -0.3) {
					resultA = 'c';
					color003 = "red";
				} else if (acquireRatio < -0.1) {
					resultA = 'b';
					color003 = "yellow";
				}
			}
		}
		
		Map map001 = new HashMap();
		map001.put("heath_order", "1");
		map001.put("heath_standard",
		"前1/3生产周期：不健康：工作量滞后超过30%，亮红灯；亚健康：工作量滞后超过10%及以上小于30%，亮黄灯；正常：工作量滞后10%以内，亮绿灯；后2/3生产周期：不健康：工作量滞后超过15%，亮红灯；亚健康：工作量滞后超过5%及以上小于15%，亮黄灯；正常：工作量滞后5%以内，亮绿灯.计划偏离度为正则为超前，为负则为滞后");
		
		//如果测量的实际工作量是0,则不现实偏离度
		if(sumDailySurveyWorkload > 0){
			map001.put("heath_color", color001);

			if (isStartM) {
				map001.put("heath_content", "计划偏离度为:" + df.format(surveyRatio * 100) + "%" + (isEndM == true ? "测量已结束" : ""));
			} else if(notStartM){
				map001.put("heath_content", "测量未开始");
			} else if(isEndM){
				map001.put("heath_content", "计划偏离度为:" + df.format(surveyRatio * 100) + "%" + (isEndM == true ? "测量已结束" : ""));
			}
		}else{
			map001.put("heath_content", "无测量");
		}
		

		Map map002 = new HashMap();
		
		map002.put("heath_order", "2");
		map002.put("heath_standard",
		"前1/3生产周期：不健康：工作量滞后超过30%，亮红灯；亚健康：工作量滞后超过10%及以上小于30%，亮黄灯；正常：工作量滞后10%以内，亮绿灯；后2/3生产周期：不健康：工作量滞后超过15%，亮红灯；亚健康：工作量滞后超过5%及以上小于15%，亮黄灯；正常：工作量滞后5%以内，亮绿灯.计划偏离度为正则为超前，为负则为滞后");
		
		if(sumDailyDrillWorkload > 0){
			map002.put("heath_color", color002);

			if (isStartD) {
				map002.put("heath_content", "计划偏离度为:" + df.format(drillRation * 100) + "%" + (isEndD == true ? "钻井已结束" : ""));
			} else if(notStartD){
				map002.put("heath_content", "钻井未开始");
			} else if(isEndD){
				map002.put("heath_content", "计划偏离度为:" + df.format(drillRation * 100) + "%" + (isEndD == true ? "钻井已结束" : ""));
			}
		}else{
			map002.put("heath_content", "无钻井");
		}

		Map map003 = new HashMap();
		
		map003.put("heath_order", "3");
		map003.put("heath_standard",
		"前1/3生产周期：不健康：工作量滞后超过30%，亮红灯；亚健康：工作量滞后超过10%及以上小于30%，亮黄灯；正常：工作量滞后10%以内，亮绿灯；后2/3生产周期：不健康：工作量滞后超过15%，亮红灯；亚健康：工作量滞后超过5%及以上小于15%，亮黄灯；正常：工作量滞后5%以内，亮绿灯.计划偏离度为正则为超前，为负则为滞后");

		if(sumDailyAcquireWorkload > 0){
			map003.put("heath_color", color003);
			if (isStartG) {
				map003.put("heath_content", "计划偏离度为:" + df.format(acquireRatio * 100) + "%" + (isEndG == true ? "采集已结束" : ""));
			} else if(notStartG){
				map003.put("heath_content", "采集未开始");
			} else if(isEndG){
				map003.put("heath_content", "计划偏离度为:" + df.format(acquireRatio * 100) + "%" + (isEndG == true ? "采集已结束" : ""));
			}	
		}else{
			map003.put("heath_content", "无采集");
		}

		// 生产效率

		StringBuffer sql1121 = new StringBuffer(
				"with daily_plan_prj as (select decode(nvl(pp.workload, 0), 0, 1, dp.daily_sp / nvl(pp.workload, 0)) s_ratio, dp.send_date, dp.project_info_no ");
		sql1121.append(" from (select nvl(sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)), 0) daily_sp,gd.project_info_no,gd.send_date ");
		sql1121.append(" from rpt_gp_daily gd where gd.project_info_no='" + projectInfoNo
				+ "' group by gd.project_info_no, gd.send_date) dp  left outer join gp_proj_product_plan pp ");
		sql1121.append(" on dp.project_info_no = pp.project_info_no and dp.send_date = to_date(pp.record_month, 'yyyy-MM-dd') and  pp.oper_plan_type = 'colldailylist') ");
		sql1121.append(" select to_number(to_char(s_ratio*100,'99999999.00')) s_ratio from (select t.s_ratio,t.send_date");
		sql1121.append(" from daily_plan_prj t order by send_date desc ) m where rownum = 1 ");
		Map map1121 = pureDao.queryRecordBySQL(sql1121.toString());

		// 计算计划日效果与实际日效时间配比
		StringBuffer sql1220 = new StringBuffer(" select case when actual_start_date<to_date(start_date,'yyyy-MM-dd') then 0 when actual_end_date>to_date (end_date,'yyyy-MM-dd') then 1 else 2 end flag from (select  ");
		sql1220.append(" (select min(send_date) from rpt_gp_daily where project_info_no = '" + projectInfoNo + "' and bsflag='0') actual_start_date, ");
		sql1220.append(" (select max(send_date) from rpt_gp_daily where project_info_no = '" + projectInfoNo + "' and bsflag='0') actual_end_date, ");
		sql1220.append(" (select min(record_month) from gp_proj_product_plan where  project_info_no = '" + projectInfoNo + "' and bsflag='0') start_date, ");
		sql1220.append(" (select  max(record_month)  from gp_proj_product_plan where  project_info_no = '" + projectInfoNo + "' and bsflag='0') end_date ");
		sql1220.append(" from dual ) ");
		Map map1220 = pureDao.queryRecordBySQL(sql1220.toString());

		Map map004 = new HashMap();
		map004.put("heath_order", "4");
		String color004 = null;
		/*
		if ("0".equals(map1120.get("e_result")) && isStartG) {
			resultA = 'c';
			color004 = "red";
		}
		*/
		map004.put("heath_color", color004);
		map004.put("heath_standard", "连续两天实际日效低于计划日效50%，亮红灯");
		double sRatio = 0f;
		if (!isStartG) {
			map004.put("heath_content", "采集未开始");
		} else if ("0".equals(map1220.get("flag"))) {
			map004.put("heath_content", "实际开始比计划提前");
		} else if ("1".equals(map1220.get("flag"))) {
			map004.put("heath_content", "实际完成已超出计划完成日期");
		} else if (isStartG) {
			if (map1121 == null || "".equals(map1121.get("s_ratio"))) {
				map004.put("heath_content", "日效与计划日效持平");
			} else {
				sRatio = Double.parseDouble((String) map1121.get("s_ratio"));
				if (sRatio == 100) {
					map004.put("heath_content", "日效与计划日效持平");
				} else if (sRatio > 100) {
					map004.put("heath_content", "当天日效超出计划日效的:" + (sRatio - 100) + "%");
				} else {
					map004.put("heath_content", "当天日效超低于计划日效的:" + (100 - sRatio) + "%");
				}
			}
		}

		// 里程碑时间结点
		StringBuilder sql1130 = new StringBuilder(" select case  when (actual_finish_date is not null and sysdate>=actual_finish_date) then 1 ");
		sql1130.append(" when sysdate<=planned_start_date then 2 when sysdate>planned_start_date and sysdate<=actual_start_date then 4 ");
		sql1130.append(" when sysdate>actual_start_date and sysdate<planned_finish_date then 6 ");
		sql1130.append(" when sysdate>=planned_finish_date and sysdate<=actual_finish_date then 5 else 3 end flag,(actual_start_date-planned_start_date)+weather_delay start_days, ");
		sql1130.append(" case when end_flag=to_date('1900-01-01','yyyy-MM-dd') then case  when (sysdate-planned_finish_date)>0 then  (sysdate - planned_finish_date) - weather_delay else 0 end ");
		sql1130.append(" else  case when actual_finish_date-planned_finish_date<0 then  (actual_finish_date - planned_finish_date)- weather_delay ");
		sql1130.append(" else   (actual_finish_date - planned_finish_date) - case  when weather_delay - (actual_start_date - planned_start_date) > 0 then ");
		sql1130.append(" weather_delay - (actual_start_date - planned_start_date)  else  0  end  end end end_days, case when end_flag=to_date('1900-01-01','yyyy-MM-dd') then 1 else 0 end end_flag,weather_delay ");
		sql1130.append(" from (select min(t2.planned_start_date) planned_start_date,min(t2.actual_start_date) actual_start_date ");
		sql1130.append(" from bgp_p6_project t1 inner join bgp_p6_activity t2 on t1.object_id = t2.project_object_id ");
		sql1130.append(" where t1.project_info_no = '" + projectInfoNo + "' and t2.wbs_name = '采集' and t2.bsflag = '0') t1 ");
		sql1130.append(" left outer join (select max(t2.planned_finish_date) planned_finish_date,max(nvl(t2.actual_finish_date, sysdate)) actual_finish_date,min(nvl(t2.actual_finish_date, to_date('1900-01-01','yyyy-MM-dd'))) end_flag from bgp_p6_project t1 ");
		sql1130.append(" inner join bgp_p6_activity t2 on t1.object_id = t2.project_object_id ");
		sql1130.append(" where t1.project_info_no =  '" + projectInfoNo + "' and t2.wbs_name ='采集' and t2.bsflag = '0') t2 on 1 = 1 ");
		sql1130.append(" left outer join ");
		sql1130.append(" (select round(nvl(sum(s.weather_delay),0)/8) as weather_delay  from gp_ops_daily_report d join gp_ops_daily_produce_sit s on d.daily_no = s.daily_no and s.bsflag = '0' ");
		sql1130.append(" where d.bsflag = '0' and d.audit_status = '3' and d.project_info_no = '"+projectInfoNo+"') ");
		sql1130.append(" t3 on 1=1");
		Map map1130 = pureDao.queryRecordBySQL(sql1130.toString());
		
		String color005 = null;
		Map map005 = new HashMap();
		map005.put("heath_order", "5");
		map005.put("heath_standard", "项目采集开始、采集结束时间滞后天数超出“自然因素影响时间”，亮红灯");
		
		DecimalFormat df1 = new DecimalFormat("########0");
		
		
		if(map1130!=null){
			String flag=(String) map1130.get("flag");
			String weather_delay=(String) map1130.get("weather_delay");
			
			long startDays = DateOperation.diffDaysOfDate(acquireDailyStartDate,acquireDesignStartDate);
			long endDays = DateOperation.diffDaysOfDate(acquireDailyEndDate,acquireDesignEndDate);
			
			String heathContentStr="";
			if(startDays >0){
				if(DateOperation.diffDaysOfDate(acquireDailyStartDate,acquireDesignStartDate)==-1){
					heathContentStr+="项目采集开始滞后天数为0";
				}else{
					heathContentStr+="项目采集开始滞后天数为"+DateOperation.diffDaysOfDate(acquireDailyStartDate,acquireDesignStartDate);
				}
				
			}else{
				if(DateOperation.diffDaysOfDate(acquireDesignStartDate,acquireDailyStartDate)==-1){
					heathContentStr+="项目采集开始提前天数为0";
				}else{
					heathContentStr+="项目采集开始提前天数为"+DateOperation.diffDaysOfDate(acquireDesignStartDate,acquireDailyStartDate);
				}
			}
			heathContentStr+=",";
			//如果采集结束了
			if(isEndG){
				if(endDays >0){
					if(DateOperation.diffDaysOfDate(acquireDailyEndDate,acquireDesignEndDate)==-1){
						heathContentStr+="项目采集结束滞后天数为0";
					}else{
						heathContentStr+="项目采集结束滞后天数为"+DateOperation.diffDaysOfDate(acquireDailyEndDate,acquireDesignEndDate);
					}
					
				}else{
					if(DateOperation.diffDaysOfDate(acquireDesignEndDate,acquireDailyEndDate)==-1){
						heathContentStr+="项目采集结束提前天数为0";
					}else{
						heathContentStr+="项目采集结束提前天数为"+DateOperation.diffDaysOfDate(acquireDesignEndDate,acquireDailyEndDate);
					}
					
				}
			}
			
			
			map005.put("heath_content", heathContentStr+","+"(其中自然因素影响时间为："+weather_delay +"天)");
			if("2".equals(flag)){
				map005.put("heath_content", "采集未开始");
			}else if("4".equals(flag)){
				if(startDays>0){
					resultA = 'c';
					color005 = "red";
				}
			}else if("5".equals(flag)){
				if(endDays>0){
					resultA = 'c';
					color005 = "red";
				}
			}
		}

		map005.put("heath_color", color005);

		// 人员
		// 人员数量（实际/计划）
		StringBuffer sql1210 = new StringBuffer("select nvl(sum(t.people_number),0) plan_num from bgp_comm_human_plan_detail t where t.project_info_no='" + projectInfoNo
				+ "' and t.bsflag='0' ");
		StringBuffer sql1211 = new StringBuffer("select nvl((select count(t.labor_id) from bgp_comm_human_labor_deploy t ");
		sql1211.append(" where t.bsflag = '0' and t.project_info_no = '" + projectInfoNo + "') + ");
		sql1211.append(" (select count(d.employee_id) from bgp_human_prepare_human_detail d ");
		sql1211.append(" left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' ");
		sql1211.append(" where d.bsflag = '0' and p.project_info_no = '" + projectInfoNo + "'),0) actual_num from dual ");
		Map map1210 = pureDao.queryRecordBySQL(sql1210.toString());
		Map map1211 = pureDao.queryRecordBySQL(sql1211.toString());
		String planNum = (String) map1210.get("plan_num");
		String actualNum = (String) map1211.get("actual_num");
		Map map006 = new HashMap();
		map006.put("heath_order", "6");
		map006.put("heath_standard", "人员数量");
		map006.put("heath_content", "计划数量为：" + planNum + ",实际数量为：" + actualNum);
		// 操作技能（实际日效/计划日效）

		Map map007 = new HashMap();
		map007.put("heath_order", "7");
		map007.put("heath_standard", "实际日效/计划日效");
		if ("0".equals(map1220.get("flag"))) {
			map007.put("heath_content", "实际开始比计划提前");
		} else if ("1".equals(map1220.get("flag"))) {
			map007.put("heath_content", "实际完成已超出计划完成日期");
		} else {
			map007.put("heath_content", sRatio + "%");
		}

		// 设备
		// 设备完好率
		// 利用率
		StringBuffer sql1310 = new StringBuffer("select case when zhidu.zhidutaitian = 0 or zhidu.zhidutaitian is null then 0 ");
		sql1310.append(" else trunc(100*(zhidu.zhidutaitian-wanhao.nowanhao)/zhidu.zhidutaitian,2) end as wanhaolv, ");
		sql1310.append(" case when zhidu.zhidutaitian = 0 or zhidu.zhidutaitian is null then 0  ");
		sql1310.append(" else trunc(100*(zhidu.zhidutaitian-liyong.noliyong)/zhidu.zhidutaitian,2) end as liyonglv  ");
		sql1310.append(" from (select '" + projectInfoNo + "' as proflag from dual ) base  ");
		sql1310.append(" left join  ");
		sql1310.append(" (select '" + projectInfoNo + "' as proflag,sum(case when dui.actual_out_time is null  ");
		sql1310.append(" then to_number(trunc(sysdate,'dd')-trunc(actual_in_time,'dd'))  ");
		sql1310.append(" else to_number(trunc(actual_out_time,'dd')-trunc(actual_in_time,'dd')) end) as zhidutaitian  ");
		sql1310.append(" from gms_device_account_dui dui  ");
		sql1310.append(" where dui.project_info_id='" + projectInfoNo + "' and  ");
		sql1310.append(" (dev_type like 'S070301%' or dev_type like 'S060101%' or dev_type like 'S060102%' or dev_type like 'S08%')  ");
		sql1310.append(" ) zhidu on base.proflag = zhidu.proflag  ");
		sql1310.append(" left join  ");
		sql1310.append(" (select '" + projectInfoNo + "' as proflag,count(1) as nowanhao   ");
		sql1310.append(" from bgp_comm_device_timesheet sheet  ");
		sql1310.append(" where exists(select 1 from gms_device_account_dui dui where dui.dev_acc_id=sheet.device_account_id  ");
		sql1310.append(" and timesheet_symbol in ('5110000041000000002')  ");
		sql1310.append(" and dui.project_info_id='" + projectInfoNo + "' and  ");
		sql1310.append(" (dev_type like 'S070301%' or dev_type like 'S060101%' or dev_type like 'S060102%' or dev_type like 'S08%')  ");
		sql1310.append(" )) wanhao on base.proflag = wanhao.proflag  ");
		sql1310.append(" left join  ");
		sql1310.append(" (select '" + projectInfoNo + "' as proflag,count(1) as noliyong   ");
		sql1310.append(" from bgp_comm_device_timesheet sheet  ");
		sql1310.append(" where exists(select 1 from gms_device_account_dui dui where dui.dev_acc_id=sheet.device_account_id  ");
		sql1310.append(" and timesheet_symbol in ('5110000041000000002','5110000041000000003')  ");
		sql1310.append(" and dui.project_info_id='" + projectInfoNo + "' and  ");
		sql1310.append(" (dev_type like 'S070301%' or dev_type like 'S060101%' or dev_type like 'S060102%' or dev_type like 'S08%')  ");
		sql1310.append(" )) liyong on base.proflag = liyong.proflag ");
		Map map1310 = pureDao.queryRecordBySQL(sql1310.toString());
		String wanhaolv = (String) map1310.get("wanhaolv");
		Map map008 = new HashMap();
		map008.put("heath_order", "8");
		map008.put("heath_standard", "");
		map008.put("heath_content", df.format(Double.parseDouble(wanhaolv)));
		String liyonglv = (String) map1310.get("liyonglv");
		Map map009 = new HashMap();
		map009.put("heath_order", "9");
		map009.put("heath_standard", "");
		map009.put("heath_content", df.format(Double.parseDouble(liyonglv)));
		// 设备事故发生数
		StringBuffer sql1311 = new StringBuffer("select count(1) as shigushu from BGP_COMM_DEVICE_ACCIDENT_INFO accinfo ");
		sql1311.append(" where exists (select 1  from gms_device_account_dui dui  ");
		sql1311.append("  where dui.dev_acc_id = accinfo.device_account_id and dui.project_info_id = '" + projectInfoNo + "')");
		Map map1311 = pureDao.queryRecordBySQL(sql1311.toString());
		String shigushu = (String) map1311.get("shigushu");
		Map map010 = new HashMap();
		map010.put("heath_order", "10");
		map010.put("heath_standard", "");
		map010.put("heath_content", shigushu);
		// 关键物资
		// 计算项目结束时间：
		String projectEndDate = getProjectEndDate(projectInfoNo);
		// 84、85#（读取物资分类码为1903、1905之下的所有物资）
		StringBuffer sql1410 = new StringBuffer("select nvl(sum(t.mat_num),0) mat_num from gms_mat_teammat_out_detail t  ");
		sql1410.append(" inner join gms_mat_infomation i on t.wz_id=i.wz_id and t.bsflag='0' and i.bsflag='0'  ");
		sql1410.append(" and (i.coding_code_id like '1903%' or i.coding_code_id like '1905%' )  ");
		sql1410.append(" where t.project_info_no = '" + projectInfoNo + "' and ( t.create_date -to_date('" + projectEndDate + "','yyyy-MM-dd') >=-7 and t.create_date-to_date('"
				+ projectEndDate + "','yyyy-MM-dd') <=0)");
		StringBuffer sql1411 = new StringBuffer("select nvl(sum(t.stock_num),0) stock_num from gms_mat_teammat_info t  ");
		sql1411.append(" inner join gms_mat_infomation mi on t.wz_id = mi.wz_id and t.bsflag='0' and mi.bsflag='0' ");
		sql1411.append(" and (mi.coding_code_id like '1903%' or mi.coding_code_id like '1905%' )  and t.project_info_no = '" + projectInfoNo + "'");
		Map map1410 = pureDao.queryRecordBySQL(sql1410.toString());
		String matNum01 = (String) map1410.get("mat_num");
		Map map1411 = pureDao.queryRecordBySQL(sql1411.toString());
		String stockNum01 = (String) map1411.get("stock_num");
		Map map011 = new HashMap();
		map011.put("heath_order", "11");
		map011.put("heath_standard", "");
		map011.put("heath_content", "近一周出库数量为：" + matNum01 + ",当前库存数量为：" + stockNum01);
		// 燃油 （读取物资分类码为0703之下的所有物资）
		StringBuffer sql1420 = new StringBuffer("select nvl(sum(t.mat_num),0) mat_num from gms_mat_teammat_out_detail t  ");
		sql1420.append(" inner join gms_mat_infomation i on t.wz_id=i.wz_id and t.bsflag='0' and i.bsflag='0'  ");
		sql1420.append(" and (i.coding_code_id like '0703%'  )  ");
		sql1420.append(" where t.project_info_no = '" + projectInfoNo + "' and ( t.create_date -to_date('" + projectEndDate + "','yyyy-MM-dd') >=-7 and t.create_date-to_date('"
				+ projectEndDate + "','yyyy-MM-dd') <=0)");
		StringBuffer sql1421 = new StringBuffer("select sum(t.stock_num) stock_num from gms_mat_teammat_info t  ");
		sql1421.append(" inner join gms_mat_infomation mi on t.wz_id = mi.wz_id and t.bsflag='0' and mi.bsflag='0' ");
		sql1421.append(" and (mi.coding_code_id like '0703%' )  and t.project_info_no = '" + projectInfoNo + "'");
		Map map1420 = pureDao.queryRecordBySQL(sql1420.toString());
		String matNum02 = (String) map1420.get("mat_num");
		Map map1421 = pureDao.queryRecordBySQL(sql1421.toString());
		String stockNum02 = (String) map1421.get("stock_num");
		Map map012 = new HashMap();
		map012.put("heath_order", "12");
		map012.put("heath_standard", "");
		map012.put("heath_content", "近一周出库数量为：" + matNum02 + ",库存数量为：" + stockNum02);
		// 炮线 （读取物资分类码为32019904之下的所有物资）
		StringBuffer sql1430 = new StringBuffer("select nvl(sum(t.mat_num),0) mat_num from gms_mat_teammat_out_detail t  ");
		sql1430.append(" inner join gms_mat_infomation i on t.wz_id=i.wz_id and t.bsflag='0' and i.bsflag='0'  ");
		sql1430.append(" and (i.coding_code_id like '32019904%'  )  ");
		sql1430.append(" where t.project_info_no = '" + projectInfoNo + "' and ( t.create_date -to_date('" + projectEndDate + "','yyyy-MM-dd') >=-7 and t.create_date-to_date('"
				+ projectEndDate + "','yyyy-MM-dd') <=0)");
		StringBuffer sql1431 = new StringBuffer("select sum(t.stock_num) stock_num from gms_mat_teammat_info t  ");
		sql1431.append(" inner join gms_mat_infomation mi on t.wz_id = mi.wz_id and t.bsflag='0' and mi.bsflag='0' ");
		sql1431.append(" and (mi.coding_code_id like '32019904%' )  and t.project_info_no = '" + projectInfoNo + "'");
		Map map1430 = pureDao.queryRecordBySQL(sql1430.toString());
		String matNum03 = (String) map1430.get("mat_num");
		Map map1431 = pureDao.queryRecordBySQL(sql1431.toString());
		String stockNum03 = (String) map1431.get("stock_num");
		Map map013 = new HashMap();
		map013.put("heath_order", "13");
		map013.put("heath_standard", "");
		map013.put("heath_content", "近一周出库数量为：" + matNum03 + ",库存数量为：" + stockNum03);
		// 物资质量
		StringBuffer sql1440 = new StringBuffer("select count(1) reason_num from gms_mat_out_info t where  t.out_date = sysdate-1 and out_reason='1' and t.project_info_no='"
				+ projectInfoNo + "'");
		Map map1440 = pureDao.queryRecordBySQL(sql1440.toString());
		String reasonNum = (String) map1440.get("reason_num");
		Map map014 = new HashMap();
		map014.put("heath_order", "14");
		map014.put("heath_standard", "");
		map014.put("heath_content", "因质量原因退库：" + reasonNum + "次");
		// 生产组织
		StringBuffer sql1510 = new StringBuffer("select wmsys.wm_concat(dq.q_description )  q_description from gp_ops_daily_question dq ");
		sql1510.append(" where dq.bug_code in ('5000100005000000006','5000100005000000007','5000100005000000008','5000100005000000009','5000100005000000010') ");
		sql1510.append(" and dq.produce_date = sysdate-1 and dq.project_info_no ='" + projectInfoNo + "'");
		Map map1510 = pureDao.queryRecordBySQL(sql1510.toString());
		String qDescription = (String) map1510.get("q_description");
		Map map015 = new HashMap();
		map015.put("heath_order", "15");
		map015.put("heath_standard", "");
		map015.put("heath_content", qDescription == null ? "无生产问题" : qDescription);
		
		if("0".equals(flagSC)){
			resultA='d';
		}
		
		// 质量
		// 合同要求指标
		//20131107赵学良修改: 合格率、一级品率默认100%,空炮率、废跑率默认0% . 之前项目健康状况质量一直红灯
		
		StringBuffer sql2110 = new StringBuffer("select to_char(decode(nvl(sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)), 0),0,1, ");
		sql2110.append(" nvl(sum(nvl(gd.DAILY_2D_ACQUIRE_QUALIFIED_NUM,0) + nvl(DAILY_3D_ACQUIRE_QUALIFIED_NUM,0)), 0) / ");
		sql2110.append(" sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)))*100,'9990.00') h_num, ");
		sql2110.append(" to_char(decode(nvl(sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)), 0),0,1, ");
		sql2110.append(" nvl(sum(nvl(gd.DAILY_2D_ACQUIRE_1LEVEL_NUM,0) + nvl(gd.DAILY_3D_ACQUIRE_1LEVEL_NUM,0)), 0) / ");
		sql2110.append(" sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)))*100,'9990.00') o_num, ");
		sql2110.append(" to_char(decode(nvl(sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)), 0),0,0, ");
		sql2110.append(" nvl(sum(nvl(gd.COLLECT_2D_WASTER_NUM,0) + nvl(gd.COLLECT_3D_WASTER_NUM,0)), 0) / ");
		sql2110.append(" sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)))*100,'9990.00') f_num, ");
		sql2110.append(" to_char(decode(nvl(sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)), 0),0,0, ");
		sql2110.append(" nvl(sum(nvl(gd.miss_2d_sp,0) + nvl(gd.miss_3d_sp,0)), 0) / ");
		sql2110.append(" sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)))*100,'9990.00') k_num ");
		sql2110.append(" from rpt_gp_daily gd  where  gd.project_info_no = '" + projectInfoNo + "'　and gd.bsflag='0'");
		Map map2110 = pureDao.queryRecordBySQL(sql2110.toString());
		StringBuffer sql2111 = new StringBuffer(
				"select nvl(max(firstlevel_radio),0) firstlevel_radio, nvl(max(qualified_radio),0) qualified_radio, nvl(max(waster_radio),0) waster_radio, nvl(max(all_miss_radio),0) all_miss_radio ");
		sql2111.append(" from bgp_pm_quality_index where project_info_no = '" + projectInfoNo + "' and bsflag = '0'");
		Map map2111 = pureDao.queryRecordBySQL(sql2111.toString());
		// 合格率
		String hNum = (String) map2110.get("h_num");
		String hNumS = (String) map2111.get("qualified_radio");
		String color016 = null;
		if (Double.parseDouble(hNum) < Double.parseDouble(hNumS) && isStartG) {
			resultB = 'c';
			color016 = "red";
		}
		Map map016 = new HashMap();
		map016.put("heath_order", "16");
		map016.put("heath_color", color016);
		map016.put("heath_standard", Double.parseDouble(hNumS));
		if (isStartG) {
			map016.put("heath_content", Double.parseDouble(hNum) + "%");
		} else {
			map016.put("heath_content", "采集未开始");
		}
		// 一级品率
		String oNum = (String) map2110.get("o_num");
		String oNumS = (String) map2111.get("firstlevel_radio");
		String color017 = null;
		if (Double.parseDouble(oNum) < Double.parseDouble(oNumS) && isStartG) {
			resultB = 'c';
			color017 = "red";
		}
		Map map017 = new HashMap();
		map017.put("heath_order", "17");
		map017.put("heath_color", color017);
		map017.put("heath_standard", Double.parseDouble(oNumS));
		if (isStartG) {
			map017.put("heath_content", Double.parseDouble(oNum) + "%");
		} else {
			map017.put("heath_content", "采集未开始");
		}
		//废炮率 
		String kNum = (String) map2110.get("k_num");
		String hkNumS = (String) map2111.get("waster_radio");
		String color018 = null;
		if (Double.parseDouble(kNum) > Double.parseDouble(hkNumS) && isStartG) {
			resultB = 'c';
			color018 = "red";
		}
		Map map018 = new HashMap();
		map018.put("heath_order", "19");
		map018.put("heath_color", color018);
		map018.put("heath_standard", Double.parseDouble(hkNumS));
		if (isStartG) {
			map018.put("heath_content", Double.parseDouble(kNum) + "%");
		} else {
			map018.put("heath_content", "采集未开始");
		}
		//空炮率
		String color019 = null;
		String fNum = (String) map2110.get("f_num");
		String fNumS = (String) map2111.get("all_miss_radio");
		if (Double.parseDouble(fNum) > Double.parseDouble(fNumS) && isStartG) {
			resultB = 'c';
			color019 = "red";
		}
		Map map019 = new HashMap();
		map019.put("heath_order", "18");
		map019.put("heath_color", color019);
		map019.put("heath_standard", Double.parseDouble(fNumS));

		if (isStartG) {
			map019.put("heath_content", Double.parseDouble(fNum) + "%");
		} else {
			map019.put("heath_content", "采集未开始");
		}
		// 质量事故分级
		StringBuffer sql2210 = new StringBuffer("     select rownum||':'||report_desc report_desc,change_flag from (select  case when t.super_num > 0 then '特大事故' ");
		sql2210.append(" when t.great_num > 0 then '重大事故' when t.large_num > 0 then '较大事故' ");
		sql2210.append("when t.small_num > 0 then  '一般事故' else '无' ");
		sql2210.append("end||',上报日期'|| to_char(t.REPORT_DATE,'yyyy-MM-dd')||'整改日期'|| ");
		sql2210.append("to_char(t.change_date,'yyyy-MM-dd')||decode(t.change_date,null,'       ','') report_desc , ");
		sql2210.append("decode(t.change_date,null,'1','0') change_flag, ");
		sql2210.append("t.report_date  from bgp_qua_accident t where t.project_info_no = '"+projectInfoNo+"' and t.bsflag = '0') ");
		sql2210.append("where report_desc not like '无%' order by report_date");
		
		List<Map> list2210 = pureDao.queryRecords(sql2210.toString());
		int changeFlag=0;
		String heathContent2210="";
		for(Map map:list2210){
			changeFlag+=Integer.parseInt((String) map.get("change_flag"));
			heathContent2210+=(String) map.get("report_desc")+";";
		}
		if(heathContent2210.endsWith(";"))heathContent2210=heathContent2210.substring(0, heathContent2210.length()-1);
		if("".equals(heathContent2210))heathContent2210="无事故发生";
		Map map020 = new HashMap();
		if(changeFlag>0){
			resultB = 'c';
			map020.put("heath_color", "red");
		}
		map020.put("heath_order", "20");
		map020.put("heath_standard", "发生一般质量事故、较大质量事故、重大质量事故或特大质量事故时亮红灯");
		map020.put("heath_content", heathContent2210);
		if("0".equals(flagSC)){
			resultB='d';
		}
		// HSE
		// 控制性指标
		// 隐患整改率
		StringBuffer sql3110 = new StringBuffer("SELECT decode(count(1), 0, 1, sum(decode(hd.rectification_state, '已整改', '1', '1')) / count(1)) change_ratio");
		sql3110.append(" from BGP_HSE_HIDDEN_INFORMATION  hi left outer join BGP_HIDDEN_INFORMATION_DETAIL hd on hi.hidden_no=hd.hidden_no where hi.project_no='" + projectInfoNo
				+ "' and hi.bsflag='0' and hd.bsflag='0'  ");
		Map map3110 = pureDao.queryRecordBySQL(sql3110.toString());
		String changeRatio = (String) map3110.get("change_ratio");
		String color021 = null;
		if (Double.parseDouble(changeRatio) < 0.9) {
			resultC = 'c';
			color021 = "red";
		} else if (Double.parseDouble(changeRatio) < 0.98) {
			resultC = 'b';
			color021 = "yellow";
		}
		Map map021 = new HashMap();
		map021.put("heath_order", "21");
		map021.put("heath_color", color021);
		map021.put("heath_standard", "隐患整改率低于 98%，亮黄灯；低于90%，亮红灯");
		map021.put("heath_content", Double.parseDouble(changeRatio) * 100);
		// 工业生产重伤人数(0%)
		StringBuffer sql3120 = new StringBuffer(" select nvl(sum(m.number_harm),0) number_harm from bgp_hse_accident_news t  ");
		sql3120.append(" left outer join bgp_hse_accident_number m on t.hse_accident_id = m.hse_accident_id ");
		sql3120.append(" and m.bsflag='0' where t.accident_type = '1' and t.project_info_no='" + projectInfoNo + "'");
		Map map3120 = pureDao.queryRecordBySQL(sql3120.toString());
		String numberHarm = (String) map3120.get("number_harm");
		String color022 = null;
		if (Double.parseDouble(numberHarm) > 0) {
			resultC = 'c';
			color022 = "red";
		}
		Map map022 = new HashMap();
		map022.put("heath_order", "22");
		map022.put("heath_color", color022);
		map022.put("heath_standard", "重伤人数超过0，亮红灯");
		map022.put("heath_content", numberHarm);
		// 轻微环境污染和生态破坏起数(0%)
		// todo
		StringBuffer sql3130 = new StringBuffer("select count(1) en_num from bgp_hse_accident_record t inner join  bgp_hse_record_environ p on t.hse_record_id = p.hse_record_id  ");
		sql3130.append(" inner join bgp_hse_accident_news m on t.hse_accident_id = m.hse_accident_id  where m.project_info_no = '" + projectInfoNo
				+ "'  and t.bsflag='0' and m.bsflag='0' ");
		Map map3130 = pureDao.queryRecordBySQL(sql3130.toString());
		String en_num = (String) map3130.get("en_num");
		String color023 = "";
		if (Double.parseDouble(en_num) > 0) {
			resultC = 'c';
			color022 = "red";
		}
		Map map023 = new HashMap();
		map023.put("heath_order", "23");
		map022.put("heath_color", color023);
		map023.put("heath_standard", "事故记录中发生生态损失时，亮红灯");
		map023.put("heath_content", "生态损失发生数量：" + en_num);

		// 百万工时损工伤亡发生率（LTIF）(0.15)
		StringBuffer sql3140 = new StringBuffer("select die_percent from bgp_hse_workhour_single  t where t.project_info_no = '" + projectInfoNo
				+ "' and t.bsflag='0' order by t.CREATE_DATE desc");
		Map map3140 = pureDao.queryRecordBySQL(sql3140.toString());
		String diePercent = map3140 == null ? "0" : (String) map3140.get("die_percent");
		if(diePercent == ""){
			diePercent = "0";
		}
		String color024 = null;
		if (Double.parseDouble(diePercent) > 0.15) {
			resultC = 'c';
			color024 = "red";
		} else if (Double.parseDouble(diePercent) == 0.15) {
			resultC = 'b';
			color024 = "yellow";
		}
		Map map024 = new HashMap();
		map024.put("heath_color", color024);
		map024.put("heath_order", "24");
		map024.put("heath_standard", "百万工时损工伤亡发生率（LTIF）：0.15");
		map024.put("heath_content", Double.parseDouble(diePercent) * 100);
		// 杜绝性指标（发生即为红色）
		// 杜绝一般A级及以上工业生产事故、火灾事故、环境污染或生态破坏事故
		StringBuffer sql3210 = new StringBuffer("  select count(1) acc_num  from bgp_hse_accident_news t  ");
		sql3210.append("  left outer join bgp_hse_accident_record r on t.hse_accident_id = r.hse_accident_id ");
		sql3210.append(" where (t.accident_type = '5110000042000000001' or t.accident_type = '5110000042000000002') and  r.accident_level != '5110000043000000002'  and r.accident_level != '5110000043000000003' and t.project_info_no='"
				+ projectInfoNo + "'");
		Map map3210 = pureDao.queryRecordBySQL(sql3210.toString());
		String accNum = (String) map3210.get("acc_num");
		Map map025 = new HashMap();
		String color025 = null;
		if (accNum != null && !"0".equals(accNum) && !"".equals(accNum)) {
			resultC = 'c';
			color025 = "red";
		}
		map025.put("heath_color", color025);
		map025.put("heath_order", "25");
		map025.put("heath_standard", "发生一般A级、较大、重大、特大工业生产安全事故、火灾事故，或生态损失，亮红灯");
		map025.put("heath_content", "发生次数：" + accNum);
		// 有效遏制一般A级交通事故
		StringBuffer sql3220 = new StringBuffer("  select count(1) acc_num_1  from bgp_hse_accident_news t  ");
		sql3220.append("  left outer join bgp_hse_accident_record r on t.hse_accident_id = r.hse_accident_id ");
		sql3220.append(" where (t.accident_type = '5110000042000000004' or t.accident_type = '5110000042000000005')   and r.accident_level != '5110000043000000002'  and r.accident_level != '5110000043000000003' and t.project_info_no='"
				+ projectInfoNo + "'");
		Map map3220 = pureDao.queryRecordBySQL(sql3220.toString());
		String accNum1 = (String) map3220.get("acc_num_1");
		Map map026 = new HashMap();

		String color026 = null;
		if (accNum1 != null && !"0".equals(accNum1) && !"".equals(accNum1)) {
			resultC = 'c';
			color026 = "red";
		}
		map026.put("heath_color", color026);

		map026.put("heath_order", "26");
		map026.put("heath_standard", "发生一般A级、较大、重大、特大道路交通事故、水上交通事故，亮红灯");
		map026.put("heath_content", "发生次数：" + accNum1);
		// 杜绝民爆物品丢失事故（含丢失后找回）
		StringBuffer sql3230 = new StringBuffer("  select count(1) acc_num_2  from bgp_hse_accident_news t  ");
		sql3230.append("  left outer join bgp_hse_accident_record r on t.hse_accident_id = r.hse_accident_id ");
		sql3230.append(" where (t.accident_type = '5110000042000000006' )   and r.accident_level != '5110000043000000002'  and r.accident_level != '5110000043000000003' and t.project_info_no='"
				+ projectInfoNo + "'");
		Map map3230 = pureDao.queryRecordBySQL(sql3230.toString());
		String accNum2 = (String) map3230.get("acc_num_2");
		Map map027 = new HashMap();

		String color027 = null;
		if (accNum2 != null && !"0".equals(accNum2) && !"".equals(accNum2)) {
			resultC = 'c';
			color027 = "red";
		}
		map027.put("heath_color", color027);

		map027.put("heath_order", "27");
		map027.put("heath_standard", "发生一般A级、较大、重大、特大民爆物品丢失、被盗事故，亮红灯");
		map027.put("heath_content", "发生次数：" + accNum2);
		// 杜绝在公司年度HSE体系审核定级中被评定为C级
		StringBuffer sql3240 = new StringBuffer("select max(AUDITLIST_LEVEL) AUDITLIST_LEVEL from BGP_HSE_AUDITLISTS t where t.project_no = '" + projectInfoNo
				+ "'");
		Map map3240 = pureDao.queryRecordBySQL(sql3240.toString());
		String auditlistLevel = (String) map3240.get("auditlist_level");
		String color028 = null;
		if ("C".equals(auditlistLevel) || "D".equals(auditlistLevel)) {
			resultC = 'c';
			color028 = "red";
		}
		Map map028 = new HashMap();
		map028.put("heath_order", "28");
		map028.put("heath_color", color028);
		map028.put("heath_standard", "审核定级评分等级为C或D，亮红灯");
		map028.put("heath_content", auditlistLevel == null ? "暂未定级" : "级别：" + auditlistLevel);

		if("0".equals(flagHSE)){
			resultC='d';
		}
		
		Map mapPrimary = new HashMap();
		mapPrimary.put("project_info_no", projectInfoNo);
		switch (resultA) {
		case 'a':
			mapPrimary.put("pm_info", "green");
			break;
		case 'b':
			mapPrimary.put("pm_info", "yellow");
			break;
		case 'c':
			mapPrimary.put("pm_info", "red");
			break;
		case 'd':
			mapPrimary.put("pm_info", "gray");
			break;
		}
		switch (resultB) {
		case 'a':
			mapPrimary.put("qm_info", "green");
			break;
		case 'b':
			mapPrimary.put("qm_info", "yellow");
			break;
		case 'c':
			mapPrimary.put("qm_info", "red");
			break;
		case 'd':
			mapPrimary.put("qm_info", "gray");
			break;
		}
		switch (resultC) {
		case 'a':
			mapPrimary.put("hse_info", "green");
			break;
		case 'b':
			mapPrimary.put("hse_info", "yellow");
			break;
		case 'c':
			mapPrimary.put("hse_info", "red");
			break;
		case 'd':
			mapPrimary.put("hse_info", "gray");
			break;
		}
		mapPrimary.put("bsflag", "0");
		
		//生产、质量的灯在施工结束（采集结束）后变灰，HSE的灯在项目结束后变灰
		//项目结束HSE变灰
		if("5000100001000000003" == explorationMethodMap.get("project_status") || "5000100001000000003".equals(explorationMethodMap.get("project_status"))){
			mapPrimary.put("hse_info", "gray");
			mapPrimary.put("qm_info", "gray");
			mapPrimary.put("pm_info", "gray");
		}
		//施工结束生产、质量变灰
		else if("5000100001000000005" == explorationMethodMap.get("project_status") || "5000100001000000005".equals(explorationMethodMap.get("project_status"))){
			mapPrimary.put("hse_info", "gray");
		}
		
		String sqlDeleteInfo = "delete from bgp_pm_project_heath_info where project_info_no='" + projectInfoNo + "'";
		String sqlDeleteDetail = "delete from bgp_pm_project_heath_detail where project_info_no='" + projectInfoNo + "'";
		jdbcTemplate.execute(sqlDeleteInfo);
		jdbcTemplate.execute(sqlDeleteDetail);
		
		String key = "";
		//判断该项目在健康信息表中是否存在数据,不存在则写入,存在则用已有的
		if (projectType.equals("5000100004000000009")) {//判断是否为综合
			String sqlEMethod = "select t.exploration_method from GP_TASK_PROJECT t  where t.project_info_no='"
					+ projectInfoNo + "'";
			Map ex_method = pureDao.queryRecordBySQL(sqlEMethod);
			String ex = (String) ex_method.get("exploration_method");
			String[] wtEx = ex.split(",");
			String wtKT = "";
			String sqlLoca = "";

			Map mapGwd = null;
			double sumPoint = 0.0;
			double sumPointZb = 0.0;
		    double pointRatio=0.0;
			 List list=new ArrayList();
			for (int i = 0; i < wtEx.length; i++) {
				wtKT = wtEx[i];
 
				
				//String sqlEx1 = "select * FROM comm_coding_sort_detail t WHERE t.coding_sort_id = '5110000056' and t.bsflag = '0'   and t.coding_code_id = '"
					//	+ wtEx[i] + "'";
				//Map mapEx1 = pureDao.queryRecordBySQL(sqlEx1);
				if (!wtKT.equals(
						"5110000056000000009")
						&& !wtKT.equals(
								"5110000056000000013")
						&& !wtKT.equals(
								"5110000056000000004")) {// 重磁取坐标点
					sqlLoca = "select  d.location_point from gp_wt_workload d where d.project_info_no='"
							+ projectInfoNo
							+ "' and d.exploration_method='"
							+ wtEx[i] + "'";
					mapGwd = pureDao.queryRecordBySQL(sqlLoca);
					String sqlZb = "select sum(b.daily_coordinate_point) daily_coordinate_point from gp_ops_daily_report_zb b "
							+ "where b.project_info_no = '"
							+ projectInfoNo
							+ "' and b.bsflag = '0'  and b.exploration_method = '"
							+ wtEx[i] + "'";
					Map mapZb = pureDao.queryRecordBySQL(sqlZb);
					if(!"".equals(mapZb.get("daily_coordinate_point"))){
						sumPoint = Double.parseDouble((String) mapGwd
								.get("location_point"));
						sumPointZb = Double.parseDouble((String) mapZb
								.get("daily_coordinate_point"));
						pointRatio = (sumPointZb - sumPoint) / sumPoint;
					}else{
						pointRatio=0.0;
					}
				 

					if (mapGwd == null) {
						sqlLoca = "select  d.line_length from gp_wt_workload d where d.project_info_no='"
								+ projectInfoNo
								+ "' and d.exploration_method='"
								+ wtEx[i]
								+ "'";
						mapGwd = pureDao.queryRecordBySQL(sqlLoca);
						sqlZb = "select sum(d.daily_workload)daily_workload from gp_ops_daily_report_zb b "
								+ "where b.project_info_no = '"
								+ projectInfoNo
								+ "' and b.bsflag = '0'  and b.exploration_method = '"
								+ wtEx[i] + "'";
						mapZb = pureDao.queryRecordBySQL(sqlZb);
						sumPoint = Double.parseDouble((String) mapGwd
								.get("location_point"));
						
						if(!"".equals(mapZb.get("daily_workload"))){
							sumPointZb = Double.parseDouble((String) mapZb
									.get("daily_workload"));
							pointRatio  = (sumPointZb - sumPoint) / sumPoint;
						}else{
							pointRatio =0.0;
						}
						
					}
					list.add(pointRatio);

				} else {
					sqlLoca = "select  d.line_length from gp_wt_workload d where d.project_info_no='"
							+ projectInfoNo
							+ "' and d.exploration_method='"
							+ wtEx[i] + "'";
					mapGwd = pureDao.queryRecordBySQL(sqlLoca);
					String sqlZb = "select sum(b.daily_workload)daily_workload from gp_ops_daily_report_zb b "
							+ "where b.project_info_no = '"
							+ projectInfoNo
							+ "' and b.bsflag = '0'  and b.exploration_method = '"
							+ wtEx[i] + "'";
					Map mapZb = pureDao.queryRecordBySQL(sqlZb);
					sumPoint = Double.parseDouble((String) mapGwd
							.get("line_length"));
					if("".equals(mapGwd.get("line_length"))||"".equals(mapZb.get("daily_workload"))){
						pointRatio =0.0;
					}else{
						sumPointZb = Double.parseDouble((String) mapZb
								.get("daily_workload"));
						pointRatio = (sumPointZb - sumPoint) / sumPoint;
					}
				 
					if (mapGwd == null) {
						sqlLoca = "select  d.location_point from gp_wt_workload d where d.project_info_no='"
								+ projectInfoNo
								+ "' and d.exploration_method=' "
								+ wtEx[i]
								+ "'";
						mapGwd = pureDao.queryRecordBySQL(sqlLoca);
						sqlZb = "select sum(b.daily_coordinate_point)daily_coordinate_point from gp_ops_daily_report_zb b "
								+ "where b.project_info_no = '"
								+ projectInfoNo
								+ "' and b.bsflag = '0'  and b.exploration_method = ' "
								+ wtEx[i] + "'";
						mapZb = pureDao.queryRecordBySQL(sqlZb);
						sumPoint = Double.parseDouble((String) mapGwd
								.get("location_point"));
						sumPointZb = Double.parseDouble((String) mapZb
								.get("daily_coordinate_point"));
						pointRatio  = (sumPointZb - sumPoint) / sumPoint;
					}
					list.add(pointRatio);

				}
			
			}
			if (ex_method.equals("5000100001000000003")) {
				mapPrimary.put("pm_info", "gray");
			} else {
		 
				   Object [] li=(Object[])list.toArray();
				    Arrays.sort(li);
					double db= (Double) li[li.length-1];
					if(db<0.1){
						mapPrimary.put("pm_info", "green");
					}else if(db>=0.1&&db<=0.2){
						mapPrimary.put("pm_info", "yellow");
					}else{
						mapPrimary.put("pm_info", "red");
					}
			 
			}
			
			
		}
		String checkExistSql = "select pi.heath_info_id from bgp_pm_project_heath_info pi where pi.bsflag = '0' and pi.project_info_no = '"+projectInfoNo+"'";
		Map checkExistMap = jdbcDao.queryRecordBySQL(checkExistSql);
		if(checkExistMap != null){
			key = checkExistMap.get("heath_info_id").toString();
		}else{
			key = pureDao.saveOrUpdateEntity(mapPrimary, "bgp_pm_project_heath_info").toString();
		}
		
		listSave.add(map001);
		listSave.add(map002);
		listSave.add(map003);
		listSave.add(map004);
		listSave.add(map005);
		listSave.add(map006);
		listSave.add(map007);
		listSave.add(map008);
		listSave.add(map009);
		listSave.add(map010);
		listSave.add(map011);
		listSave.add(map012);
		listSave.add(map013);
		listSave.add(map014);
		listSave.add(map015);
		listSave.add(map016);
		listSave.add(map017);
		listSave.add(map018);
		listSave.add(map019);
		listSave.add(map020);
		listSave.add(map021);
		listSave.add(map022);
		listSave.add(map023);
		listSave.add(map024);
		listSave.add(map025);
		listSave.add(map026);
		listSave.add(map027);
		listSave.add(map028);
		/**
		 * TODO
		 */
		for (Map mapTemp : listSave) {
			mapTemp.put("heath_info_id", key);
			mapTemp.put("project_info_no", projectInfoNo);
			pureDao.saveOrUpdateEntity(mapTemp, "bgp_pm_project_heath_detail");
		}
	}

	/*
	 * 获取项目健康状况
	 */
	public static Map getProjectHealthColor(String projectInfoNo) throws Exception {
		String sql = "select * from bgp_pm_project_heath_info where project_info_no='" + projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		return map;
	}

	/*
	 * 处理项目健康情况信息
	 */
	public static List<Map> getProjectHealthInfo(String projectInfoNo) throws Exception {
		
		String sqlType = " select * from gp_task_project where project_info_no = '"+projectInfoNo+"' and bsflag='0'";//查询项目勘探方法
		Map mapType=pureDao.queryRecordBySQL(sqlType);
		String project_type = mapType.get("project_type").toString();
		
		String sql = "";
		if(project_type.equals("5000100004000000009")){
			sql = "select * from bgp_pm_project_heath_detail_wt where project_info_no = '" + projectInfoNo + "' order by to_number(heath_order) asc";
		}else{
			sql = "select * from bgp_pm_project_heath_detail where project_info_no = '" + projectInfoNo + "' order by to_number(heath_order) asc";
		}
		
		
		List list = pureDao.queryRecords(sql);
		return list;
	}

	/*
	 * 获取项目结束日期
	 */
	public static String getProjectEndDate(String projectInfoNo) throws Exception {
		StringBuffer sqlEndDate = new StringBuffer(
				"select nvl(max(t2.actual_finish_date),sysdate) end_date from bgp_p6_project t1 inner join bgp_p6_activity t2 on t1.object_id = t2.project_object_id where t1.project_info_no = '"
						+ projectInfoNo + "' ");
		sqlEndDate.append(" and t2.wbs_name = '资源遣散' and t2.bsflag='0' order by t2.planned_start_date asc ");
		Map map = pureDao.queryRecordBySQL(sqlEndDate.toString());

		return (String) map.get("end_date");
	}

	/*
	 * 获取日期时间差
	 */
	public static int getDaysBetweenDate(Date a, Date b) throws Exception {
		return (int) ((b.getTime() - a.getTime()) / 1000 / 60 / 60 / 24 + 1);
	}
	
	/*
	 * 获取最新事故ID
	 */
	public static String getNewAccidentIdByPrj(String projectInfoNo) throws Exception {
		StringBuffer sqlEndDate = new StringBuffer( "select * from (select t.*, t.rowid from bgp_qua_accident_report t");
		sqlEndDate.append(" join bgp_qua_accident a on t.accident_id = a.accident_id and a.bsflag='0' ");
		sqlEndDate.append(" where  a.project_info_no ='"+projectInfoNo+"' order by t.modifi_date desc)d where rownum ='1'");
		Map map = pureDao.queryRecordBySQL(sqlEndDate.toString());
		if(map!=null){
			return (String) map.get("report_id");
		}else{
			return null;
		}
	}
	
	/*
	 * 获取项目目标成本基本信息表主键
	 */
	public static String getPermit(String projectInfoNo,Map userMap,String adjust) {
		String proc_status = "1";
		String org_subjection_id = "";
		String querySql = "select wf.* ,t.org_subjection_id from BGP_OP_TARGET_PROJECT_BASIC t "+
		" left join common_busi_wf_middle wf on t.tartget_basic_id = wf.business_id and wf.bsflag='0' "+
		" left join wf_r_examineinst r on wf.proc_inst_id = r.procinst_id and r.examine_end_date is not null" +
		" where wf.busi_table_name = 'BGP_OP_TARGET_PROJECT_BASIC' and wf.business_type='5110000004100000009'"+
		" and t.project_info_no ='"+projectInfoNo+"'";
		if(adjust!=null && "adjust".equals(adjust)){
			querySql = "select wf.* from common_busi_wf_middle wf "+
			" left join wf_r_examineinst r on wf.proc_inst_id = r.procinst_id and r.examine_end_date is not null" +
			" where wf.bsflag='0' and wf.busi_table_name = 'BGP_OP_TARGET_PROJECT_INFO' and wf.business_type='5110000004100000014'"+
			" and wf.business_id ='"+projectInfoNo+"' ";
		}
		Map map = jdbcDao.queryRecordBySQL(querySql);
		String sql = "select 'true' d from dual t where '"+(String)userMap.get("org_subjection_id")+"' in (select t.org_subjection_id from bgp_comm_org_wtc t) or '"+(String)userMap.get("org_subjection_id")+"'='C105' ";
		Map temp = jdbcDao.queryRecordBySQL(sql);
		if (map != null) {
			proc_status = (String)map.get("procStatus");
			if(temp!=null){
				proc_status = "3";
			}
			if(proc_status!=null && proc_status.trim().equals("3")){
				if(temp==null){
					proc_status = "1";
				}else{
					proc_status = "3";
				}
			}
			/*org_subjection_id = (String)map.get("orgSubjectionId");
			if(org_subjection_id ==null || org_subjection_id.trim().equals("")){
				if(temp!=null){
					sql = "update BGP_OP_TARGET_PROJECT_BASIC t set t.org_id ='"+(String)userMap.get("org_id")+"',t.org_subjection_id='"+(String)userMap.get("org_subjection_id")+
					"',t.creator='"+(String)userMap.get("user_id")+"',t.updator='"+(String)userMap.get("user_id")+"',t.create_date=sysdate,t.update_date=sysdate "+
					" where t.tartget_basic_id='"+(String)userMap.get("tartget_basic_id")+"'";
					jdbcTemplate.execute(sql);	
				}
			}*/
		}else{
			if(temp==null){
				proc_status = "1";
			}else{
				proc_status = "3";
			}
		}
		
		return proc_status;
	}
	
	public static boolean  getInformationOfAuditVersion(String projectInfoNo){
		String sql="select proc_status from common_busi_wf_middle where  business_type='5110000004100000014' and business_id='"+projectInfoNo+"' and bsflag='0'";
		List list=jdbcDao.queryRecords(sql);
		if(list!=null&&list.size()>0){
			Map map = (Map)list.get(0);
			String proc_status = (String)map.get("procStatus");
			if(proc_status!=null &&(proc_status.trim().equals("1")||proc_status.trim().equals("3"))){
				return true;
			}
			return false;
		}else{
			return false;
		}
	}
	/*
	 * 获取项目目标成本的流程信息
	 */
	public static boolean getProcessStatus(String table_name,String business_id,String business_type,String project_info_no) {
		String querySql = "select t.proc_status from common_busi_wf_middle t join "+table_name+" p on t.business_id = p."+business_id+" and p.bsflag ='0' "+
		" where t.bsflag ='0' and t.busi_table_name ='"+table_name+"' and t.business_type ='"+business_type+"' and p.project_info_no ='"+project_info_no+"'";
		Map map = pureDao.queryRecordBySQL(querySql);
		if(map != null) {
			String proc_status = (String)map.get("proc_status");
			if(proc_status!=null && (proc_status.trim().equals("1") || proc_status.trim().equals("3"))){
				return false;
			}
		}
		return true;
	}
	/*
	 * 获取项目目标成本的流程信息
	 */
	public static boolean getProcessStatus2(String table_name,String business_id,String business_type,String project_info_no) {
		String querySql = "select t.proc_status from common_busi_wf_middle t where t.business_id='"+project_info_no+"' "+
		" and t.bsflag ='0' and t.busi_table_name ='"+table_name+"' and t.business_type ='"+business_type+"' ";
		Map map = pureDao.queryRecordBySQL(querySql);
		if(map != null) {
			String proc_status = (String)map.get("proc_status");
			if(proc_status!=null && (proc_status.trim().equals("1") || proc_status.trim().equals("3"))){
				return false;
			}
		}
		return true;
	}
	
	public static String getProjectType(String project_info_no) {
		String project_type = "2";
		String querySql = "select t.project_type from bgp_op_cost_project_basic t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'";
		Map map = pureDao.queryRecordBySQL(querySql);
		project_type = map==null ||map.get("project_type")==null?"2":(String)map.get("project_type");
		return project_type ;
	}
	public static String getExplorationMethod(String project_info_no) {
		String exploration_method = "";
		String querySql = "select t.* ,t.rowid from gp_task_project t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'";
		Map map = pureDao.queryRecordBySQL(querySql);
		exploration_method = map==null ||map.get("exploration_method")==null?"":(String)map.get("exploration_method");
		return exploration_method ;
	}
	/**
	 * 查询计划偏离度
	 * @param project_info_no
	 * @return
	 */
	public static List getEmName(String project_info_no){
		List list=new ArrayList();
		
		String sql = " SELECT wt.HEATH_CONTENT AS num,wt.EXPLORATION_METHOD,wt.REMARK,ccsd.coding_name "
				+ " FROM "
				+ " bgp_pm_project_heath_detail_wt wt "
				+ " JOIN  "
				+ " comm_coding_sort_detail ccsd "
				+ " ON "
				+ " ccsd.coding_code_id=wt.exploration_method "
				+ " WHERE "
				+ " PROJECT_INFO_NO = '"+project_info_no+"' and to_number(heath_order)<100";
		
		list=jdbcDao.queryRecordsBySQL(sql).getData();
		
		
		return list;
		
	}
	//查询综合物化探质量事故分级
	public static Map getAccident(String project_info_no){
		String sql = " select * from bgp_pm_project_heath_detail_wt where project_info_no = '"+project_info_no+"' and heath_order='99' ";
		List<Map> list=jdbcDao.queryRecordsBySQL(sql).getData();
		Map map = list.get(0);
		return map;
	}
	//查询综合物化探HSE
	public static List getHse(String project_info_no){
		String sql = " select * from bgp_pm_project_heath_detail_wt where project_info_no = '"+project_info_no+"' and heath_order>200 order by to_number(HEATH_ORDER) ";
		List<Map> list=jdbcDao.queryRecordsBySQL(sql).getData();
		
		return list;
	}
	
	//查询综合物化探质量信息
	public static List getwtquality(String project_info_no){
		List list=new ArrayList();
		List listNew=new ArrayList();
		String sql = " select ccsd.coding_name,qua.exploration_method,qua.firstlevel_radio,qua.qualified_radio,qua.waster_radio,qua.miss_radio "
				+ " from bgp_pm_quality_index qua"
				+ " join"
				+ " comm_coding_sort_detail ccsd"
				+ " on  qua.exploration_method = ccsd.coding_code_id"
				+ " and ccsd.bsflag='0' and qua.bsflag ='0' and qua.project_info_no = '"+project_info_no+"' ";
		list=jdbcDao.queryRecordsBySQL(sql).getData();
		
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String exploration_method = map.get("explorationMethod").toString();
			String sql_ = " select heath_content, heath_order from bgp_pm_project_heath_detail_wt "
					+ "where "
					+ "project_info_no='"+project_info_no+"' "
					+ "and exploration_method='"+exploration_method+"' "
					+ "and to_number(heath_order)>100 and bsflag='0' order by to_number(heath_order) ";
			List list_tmp = jdbcDao.queryRecordsBySQL(sql_).getData();
			for(int j=0;j<list_tmp.size();j++){
				Map map_tmp = (Map)list_tmp.get(j);
				String heath_order = map_tmp.get("heathOrder").toString();
				String heath_content = map_tmp.get("heathContent").toString();
				if(heath_order.equals("101")){
					map.put("rat1", heath_content);
				}else if(heath_order.equals("102")){
					map.put("rat2", heath_content);
				}else if(heath_order.equals("103")){
					map.put("rat3", heath_content);
				}else{
					map.put("rat4", heath_content);
				}
			}
			listNew.add(map);
		}
		
		return listNew;
	}
	/**
	 * 获取合格率
	 * @param project_info_no
	 * @return
	 */
	public static Map getIndicators(String project_info_no) {
		String querySql = "select a.coding_code_id as exploration_method,a.coding_name as exploration_method_name,a.superior_code_id,b.object_id,b.project_info_no,b.firstlevel_radio,b.qualified_radio,b.waster_radio,b.miss_radio from comm_coding_sort_detail a left join bgp_pm_quality_index b on a.coding_code_id=b.exploration_method  and b.project_info_no = '"+project_info_no+"'  where a.coding_code_id in ('5110000056000000017')";
		Map map = pureDao.queryRecordBySQL(querySql);
		return map ;
	}
	
	public static void importTargetIndicatorInfo(String projectInfoNo ,String table_name ,String key_id ,String targetBasicId ,UserToken user) {
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserName();
		// 判断项目类型
		String sql = " select exploration_method from gp_task_project where project_info_no = '" + projectInfoNo + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		if("0300100012000000002".equals(map.get("exploration_method"))){
			StringBuilder sqlProject = new StringBuilder("select t.layout tech_001 ,d.design_line_num tech_002,d.design_workload1 tech_005,d.design_workload2 tech_006,d.workload spare5,");
			sqlProject.append(" decode(d.workload ,'1',d.design_workload1 ,d.design_workload2) tech_020,d.design_sp_num tech_004,d.design_micro_measue_num tech_018,");
			sqlProject.append(" d.design_small_regraction_num tech_003,t.receiving_track_num tech_008,t.fold tech_007,t.track_interval tech_009,t.shot_interval tech_010, ");
			sqlProject.append(" t.receiving_line_distance tech_011,t.sp_line_interval tech_012,t.layout tech_013 ");
			sqlProject.append(" from gp_task_project_dynamic d left join gp_ops_2dwa_design_basic_data t on d.project_info_no = t.project_info_no");
			sqlProject.append(" where d.bsflag ='0' and t.bsflag ='0' and t.project_info_no = '" + projectInfoNo + "'");
			Map mapTech = pureDao.queryRecordBySQL(sqlProject.toString());
			String sqlTech = "select * from "+table_name+" where bsflag ='0' and tartget_basic_id = '" + targetBasicId + "'";
			Map mapId = pureDao.queryRecordBySQL(sqlTech);
			if(mapId != null){
				mapTech.put(key_id, mapId.get(key_id));
				mapTech.put("updator", user_id);
				mapTech.put("update_date", new Date());
			}else{
				mapTech.put("tartget_basic_id", targetBasicId);
				mapTech.put("bsflag", "0");
				mapTech.put("creator", user_id);
				mapTech.put("create_date",new Date());
				mapTech.put("updator", user_id);
				mapTech.put("update_date", new Date());
				mapTech.put("org_id", org_id);
				mapTech.put("org_subjection_id",org_subjection_id);
			}
			pureDao.saveOrUpdateEntity(mapTech, table_name);
		}else{
			StringBuilder sqlProject = new StringBuilder("select t.layout tech_001 ,d.design_line_num tech_002,d.design_workload1 tech_005,d.design_workload2 tech_006,d.workload spare5,");
			sqlProject.append(" decode(d.workload ,'1',d.design_workload1 ,d.design_workload2) tech_020,d.design_sp_num tech_004,d.design_micro_measue_num tech_018, ");
			sqlProject.append(" d.design_small_regraction_num tech_003,t.receiving_track_num tech_008,t.fold tech_007,t.track_interval tech_009,t.shot_interval tech_010, ");
			sqlProject.append(" t.receiving_line_distance tech_011,t.sp_line_interval tech_012,t.layout tech_013 ,t.group_roll_distance tech_014,t.binning tech_015");
			sqlProject.append(" from gp_task_project_dynamic d left join gp_ops_3dwa_design_data t on d.project_info_no = t.project_info_no");
			sqlProject.append(" where d.bsflag ='0' and t.bsflag ='0' and t.project_info_no = '" + projectInfoNo + "'");
			Map mapTech = pureDao.queryRecordBySQL(sqlProject.toString());
			String sqlTech = "select * from "+table_name+" where bsflag ='0' and tartget_basic_id = '" + targetBasicId + "'";
			Map mapId = pureDao.queryRecordBySQL(sqlTech);
			if (mapId != null) {
				mapTech.put(key_id, mapId.get(key_id));
				mapTech.put("updator", user_id);
				mapTech.put("update_date", new Date());
			} else {
				mapTech.put("tartget_basic_id", targetBasicId);
				mapTech.put("bsflag", "0");
				mapTech.put("creator", user_id);
				mapTech.put("create_date",new Date());
				mapTech.put("updator", user_id);
				mapTech.put("update_date", new Date());
				mapTech.put("org_id", org_id);
				mapTech.put("org_subjection_id",org_subjection_id);
			}
			pureDao.saveOrUpdateEntity(mapTech, table_name);
		}
		
	}
	public static Map getProjectDate(String project_info_no) {
		StringBuffer sb = new StringBuffer();
		sb.append(" select to_char(s.planned_start_date,'yyyy-MM-dd')planned_start_date,to_char(e.planned_finish_date,'yyyy-MM-dd') planned_finish_date  ")
		.append(" from (select nvl(min(t3.actual_start_date),min(t3.planned_start_date)) planned_start_date from  ")
		.append(" bgp_p6_project t1 inner join bgp_p6_project_wbs t2 on t1.object_id=t2.project_object_id  ")
		.append(" left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id  ")
		.append(" where t1.project_info_no = '"+project_info_no+"'  ")
		.append(" start with t2.name ='工区踏勘' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID )s ")
		.append(" left join (select nvl(max(t3.actual_finish_date),max(t3.planned_finish_date)) planned_finish_date ")
		.append(" from bgp_p6_project t1 inner join bgp_p6_project_wbs t2 on t1.object_id=t2.project_object_id  ")
		.append(" left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id  ")
		.append(" where t1.project_info_no = '"+project_info_no+"'  ")
		.append(" start with t2.name ='资源遣散' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID)e on 1=1 ");
		Map map =pureDao.queryRecordBySQL(sb.toString());
		return map ;
	}
	/*夏秋雨添加 2013-10-15*/
	public static String getCostOrderAndCode(String tableName,String parentId,String spare1,String spare5) {
		String code = "";
		if(parentId.trim().equals("01")){//选中是业务节点根节点
			StringBuffer sb = new StringBuffer();
			sb.append(" select nvl(max(ct.node_code),'S01000')||':'||nvl(max(ct.order_code),-1) code from bgp_op_cost_template ct  ")
			.append(" where ct.bsflag ='0' and ct.spare1 = '"+spare1+"' and ct.spare5 ='"+spare5+"' and ct.parent_id ='"+parentId+"' ");
			Map indexMap = jdbcDao.queryRecordBySQL(sb.toString());
			code = indexMap==null || indexMap.get("code")==null?"":(String) indexMap.get("code");
		}else{//
			StringBuffer sb = new StringBuffer();
			sb.append(" select nvl(d.node_code,decode('"+parentId+"','01','S01000',t.node_code||'000'))||':'||nvl(d.order_code,-1) code  ")
			.append(" from "+tableName+" t left join(select nvl(max(ct.order_code),-1)order_code ,max(ct.node_code)node_code from bgp_op_cost_template ct  ")
			.append(" where ct.bsflag ='0' and ct.spare1 = '"+spare1+"' and ct.spare5 ='"+spare5+"' and ct.parent_id ='"+parentId+"') d on 1=1 ")
			.append(" where t.bsflag ='0' and t.template_id ='"+parentId+"' ");
			Map indexMap = jdbcDao.queryRecordBySQL(sb.toString());
			code = indexMap==null || indexMap.get("code")==null?"":(String) indexMap.get("code");
		}
		
		return code;
	}
	/*夏秋雨添加 2013-11-21 综合物化探费用求和*/
	public static String getWhtSumMoney(String project_info_no,String type) {
		String sum_money = "0";
		if(type !=null && type.trim().equals("adjust")){
			StringBuffer sb = new StringBuffer("select nvl(sum(c.cost_detail_money),0) sum_money from bgp_op_target_project_change c")
			.append(" left join bgp_op_target_project_info p on c.gp_target_project_id = p.gp_target_project_id ")
			.append(" where c.bsflag ='0' and p.bsflag ='0' and p.project_info_no ='"+project_info_no+"'");
			Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sb.toString());
			
			sum_money = map ==null || map.get("sum_money") ==null ?"0": (String)map.get("sum_money");
		}else{
			StringBuffer sb = new StringBuffer("select nvl(sum(d.cost_detail_money),0) sum_money from bgp_op_target_project_detail d")
			.append(" left join bgp_op_target_project_info p on d.gp_target_project_id = p.gp_target_project_id ")
			.append(" where d.bsflag ='0' and p.bsflag ='0' and p.project_info_no ='"+project_info_no+"'");
			Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sb.toString());
			
			sum_money = map ==null || map.get("sum_money") ==null ?"0": (String)map.get("sum_money");
		}
		
		
		return sum_money;
	}
	/*夏秋雨添加 2013-12-02  选择的项目是否是子项目*/
	public static boolean isChildren(String project_info_no,String project_type) {

		StringBuffer sb = new StringBuffer("select case when project_father_no is null then 'fasle' else 'true' end is_children from gp_task_project t")
		.append(" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and t.project_type ='"+project_type+"'");
		Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sb.toString());
		
		String is_children = map ==null || map.get("is_children") ==null ?"false": (String)map.get("is_children");
		if(is_children!=null && is_children.trim().equals("true")){
			return true;
		}
		return false;
	}
}

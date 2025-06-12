package com.bgp.gms.service.rm.dm;

import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.xml.soap.SOAPException;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.bgp.mcs.service.common.DateOperation;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class EarthquakeTeamStatistics extends BaseService {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	/*
	 * 机械设备统计
	 */
	public ISrvMsg getDevInputChartDetail(ISrvMsg reqDTO)
			throws Exception {
		String project_info_no = reqDTO.getValue("project_info_no");
		String deviceType = reqDTO.getValue("deviceType");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("设备名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("自编号");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("实物标识号");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("牌照号");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("AMIS资产编号");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_even");
		titletd8.addText("班组");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_odd");
		titletd9.addText("操作手");

		StringBuffer selectSql = new StringBuffer()
				.append("select dev_name,dev_model,license_num,self_num,dev_sign,asset_coding, oprtbl.operator_name as alloprinfo,teamsd.coding_name as team_name from gms_device_account_dui dui inner join dms_device_tree dt on dt.device_code = dui.dev_type left join(select device_account_id,operator_name from ( select tmp.device_account_id,tmp.operator_name,row_number() over(partition by device_account_id order by length(operator_name) desc) as seq from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = dui.dev_team where dui.bsflag = '0' and dui.project_info_id='"+project_info_no+"' and dt.dev_tree_id like '"+deviceType+"%' order by dui.dev_team,dui.dev_type");
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("dev_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("dev_model").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("self_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("dev_sign").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("license_num").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("asset_coding").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classeven);
				contenttd8.addText(tempMap.get("team_name").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classodd);
				contenttd9.addText(tempMap.get("alloprinfo").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机械设备统计
	 */
	public ISrvMsg getMachineryEquipmentStatistics(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();
		equipmentList.add("05~储油、储气设施");
		equipmentList.add("06~石油专用设备");
		equipmentList.add("07~施工机械");
		equipmentList.add("08~运输设备");
		equipmentList.add("09~动力设备及设施");
		equipmentList.add("13~机修加工设备");
		equipmentList.add("1407~石油专用仪器-焊割设备");
		equipmentList.add("1601~野营房");
		// equipmentList.add("070301-推土机");
		// equipmentList.add("080101-卡车");
		// equipmentList.add("08010301,08010302-油水罐车");
		// equipmentList.add("08010304-雷管炸药车");
		// equipmentList.add("060101-车装钻机");
		// equipmentList.add("060102-人抬化钻机");
		// equipmentList.add("080105-皮卡");
		// equipmentList.add("0901-发电机组");
		// equipmentList.add("1601-野营房");

		String preSql = " select '@' as dev_type,count(1) as realnum from gms_device_account_dui where project_info_id='"
				+ projectInfoNo + "'";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("yAxisName", "设备数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		// 级别 公司0 物探处1 项目2
		String drillLevel = reqDTO.getValue("drillLevel");
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));

			if (equipmentCode.contains(",")) {
				String[] codeArray = equipmentCode.split(",");
				selectSql.append(" and (dev_type like 'S").append(codeArray[0])
						.append("%'");
				selectSql.append("      or dev_type like 'S")
						.append(codeArray[1]).append("%')");
			} else {
				selectSql.append(" and dev_type like 'S").append(equipmentCode)
						.append("%'");
			}
			// 执行Sql
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");
				if (Integer.parseInt(resultMap.get("realnum").toString()) > 0) {
					// 拼XML文档
					Element category = categories.addElement("category");
					category.addAttribute("label", equipmentName);
					Element set = dataset.addElement("set");
					set.addAttribute("value", equipmentNum);
					if (drillLevel != null && "1".equals(drillLevel)) {
						String orgkeyId = reqDTO.getValue("orgkeyId");
						set.addAttribute("link", "j-drillDownDevInfo-"
								+ orgkeyId + "~" + projectInfoNo + "~"
								+ resultMap.get("dev_type"));
					} else {
						set.addAttribute("link", "j-drillDownDevInfo-"
								+ resultMap.get("dev_type"));
					}
				}
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机械设备统计
	 */
	public ISrvMsg getDevInfoDrillDown(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String dev_type = reqDTO.getValue("code");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String preSql = " select dev_name,dev_model,nvl(license_num,nvl(self_num,dev_sign)) as techcode,'1' as realnum "
				+ "from gms_device_account_dui where project_info_id='"
				+ projectInfoNo + "'";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");

		StringBuffer selectSql = new StringBuffer();
		selectSql.append(preSql);

		if (dev_type.contains(",")) {
			String[] codeArray = dev_type.split(",");
			selectSql.append(" and (dev_type like 'S").append(codeArray[0])
					.append("%'");
			selectSql.append("      or dev_type like 'S").append(codeArray[1])
					.append("%')");
		} else {
			selectSql.append(" and dev_type like 'S").append(dev_type)
					.append("%'");
		}
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (Map tempMap : resultList) {
				equipmentNum = "" + tempMap.get("realnum");
				Element category = categories.addElement("category");
				category.addAttribute("label", tempMap.get("dev_name")
						.toString()
						+ "("
						+ tempMap.get("techcode").toString()
						+ ")");
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-drillDownDevInfoBack");
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机械设备统计
	 */
	public ISrvMsg getDevInfoDrillDownForTable(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String orgkeyId = reqDTO.getValue("orgkeyId");
		String dev_type = reqDTO.getValue("code");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		titletr.addAttribute("onclick", "javascript:drillDownDevInfoBack('"
				+ orgkeyId + "')");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("设备名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("自编号");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("实物标识号");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("牌照号");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("AMIS资产编号");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_even");
		titletd8.addText("班组");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_odd");
		titletd9.addText("操作手");

		String preSql = " " + "from gms_device_account_dui "
				+ "where project_info_id='" + projectInfoNo + "'";
		StringBuffer selectSql = new StringBuffer();
		selectSql
				.append("select dev_name,dev_model,license_num,self_num,dev_sign,asset_coding,oprtbl.operator_name as alloprinfo,teamsd.coding_name as team_name ")
				.append("from gms_device_account_dui dui ")
				.append("left join (select device_account_id,operator_name from ( ")
				.append("select tmp.device_account_id,tmp.operator_name,row_number() ")
				.append("over(partition by device_account_id order by length(operator_name) desc ) as seq ")
				.append("from (select device_account_id,wmsys.wm_concat(operator_name) ")
				.append("over(partition by device_account_id order by operator_name) as operator_name ")
				.append("from gms_device_equipment_operator where bsflag='0' ) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id ")
				.append("left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = dui.dev_team ")
				.append("where dui.project_info_id='" + projectInfoNo + "'");

		if (dev_type.contains(",")) {
			String[] codeArray = dev_type.split(",");
			selectSql.append(" and (dev_type like 'S").append(codeArray[0])
					.append("%'");
			selectSql.append("      or dev_type like 'S").append(codeArray[1])
					.append("%')");
		} else {
			selectSql.append(" and dev_type like 'S").append(dev_type)
					.append("%'");
		}
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				contenttr.addAttribute("onclick",
						"javascript:drillDownDevInfoBack('" + orgkeyId + "')");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("dev_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("dev_model").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("self_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("dev_sign").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("license_num").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("asset_coding").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classeven);
				contenttd8.addText(tempMap.get("team_name").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classodd);
				contenttd9.addText(tempMap.get("alloprinfo").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机械设备统计
	 */
	public ISrvMsg getDevInfoDrillDownForTableForPop(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String dev_type = reqDTO.getValue("code");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("设备名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("自编号");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("实物标识号");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("牌照号");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("AMIS资产编号");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_even");
		titletd8.addText("班组");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_odd");
		titletd9.addText("操作手");

		StringBuffer selectSql = new StringBuffer()
				.append("select dev_name,dev_model,license_num,self_num,dev_sign,asset_coding,")
				.append("oprtbl.operator_name as alloprinfo,teamsd.coding_name as team_name ")
				.append("from gms_device_account_dui dui ")
				.append("left join (select device_account_id,operator_name from ( ")
				.append("select tmp.device_account_id,tmp.operator_name,row_number() ")
				.append("over(partition by device_account_id order by length(operator_name) desc ) as seq ")
				.append("from (select device_account_id,wmsys.wm_concat(operator_name) ")
				.append("over(partition by device_account_id order by operator_name) as operator_name ")
				.append("from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id ")
				.append("left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = dui.dev_team ")
				.append("where dui.bsflag = '0' and dui.project_info_id='"
						+ projectInfoNo + "' ");

		if (dev_type.contains(",")) {
			String[] codeArray = dev_type.split(",");
			selectSql.append(" and (dev_type like 'S").append(codeArray[0])
					.append("%' ");
			selectSql.append("      or dev_type like 'S").append(codeArray[1])
					.append("%') ");
		} else {
			selectSql.append(" and dev_type like 'S").append(dev_type)
					.append("%' ");
		}
		selectSql.append("order by dui.dev_team,dui.dev_type ");
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("dev_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("dev_model").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("self_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("dev_sign").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("license_num").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("asset_coding").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classeven);
				contenttd8.addText(tempMap.get("team_name").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classodd);
				contenttd9.addText(tempMap.get("alloprinfo").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/**
	 * 单项目设备缺勤、检修信息统计
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg geDevQueqinJianxiuStaticData(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");
		String licenseNum = reqDTO.getValue("licenseNum");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("设备名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("自编号");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("实物标识号");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("牌照号");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("出勤天数");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_odd");
		titletd8.addText("待工天数");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_even");
		titletd9.addText("检修天数");
		Element titletd10 = titletr.addElement("td");
		titletd10.addAttribute("class", "bt_info_odd");
		titletd10.addText("油耗累计(升)");
		Element titletd11 = titletr.addElement("td");
		titletd11.addAttribute("class", "bt_info_even");
		titletd11.addText("工作小时累计");
		Element titletd12 = titletr.addElement("td");
		titletd12.addAttribute("class", "bt_info_odd");
		titletd12.addText("钻井进尺累计");
		Element titletd13 = titletr.addElement("td");
		titletd13.addAttribute("class", "bt_info_even");
		titletd13.addText("行驶里程累计");
		Element titletd14 = titletr.addElement("td");
		titletd14.addAttribute("class", "bt_info_odd");
		titletd14.addText("单位油耗");
		StringBuffer selectSql = new StringBuffer();
		selectSql
				.append("select a.dev_acc_id,a.dev_name,a.dev_type,a.dev_model,a.self_num,a.dev_sign,a.license_num,a.oilnum,a.mileage,a.drillingfootage,a.workhour,sum(a.daigongnum) daigongnum,sum(a.jianxiunum) jianxiunum,sum(a.kaoqin) chuqinnum,")
				.append("case when a.dev_type is null then 0 when (substr(a.dev_type,0,3)='S08' and a.mileage!=0) then trunc((a.oilnum/a.mileage*100),3) when (substr(a.dev_type,0,5)='S0601' and a.drillingfootage !=0) then trunc((a.oilnum/a.drillingfootage),3) when (substr(a.dev_type,0,5)='S0622' and a.mileage!=0) then trunc((a.oilnum/a.mileage*100),3) when (substr(a.dev_type,0,5)='S0623' and a.workhour !=0) then trunc((a.oilnum/a.workhour),3) when (substr(a.dev_type,0,5)='S0901' and a.workhour !=0) then trunc((a.oilnum/a.workhour),3) else 0 end dwyh ")
				.append("from (")
				.append("select  b.dev_acc_id, b.dev_type, b.dev_name,b.actual_in_time, b.dev_model, b.self_num, b.dev_sign, b.license_num,b.mileage,b.drillingfootage,b.workhour,b.daigongnum,b.jianxiunum,b.kaoqin, (case when sum(doi.oil_quantity) is null then 0 else sum(doi.oil_quantity) end + case when sum(oil.oil_num) is null then 0 else sum(oil.oil_num) end) oilnum from (select dui.dev_acc_id,dui.dev_type,dui.dev_name,dui.actual_in_time,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num, ")
				.append("case when sum(gdo.mileage) is null then 0 else sum(gdo.mileage) end mileage,")
				.append("case when sum(gdo.drilling_footage) is null then 0 else sum(gdo.drilling_footage) end drillingfootage,")
				.append("case when sum(gdo.work_hour) is null then 0 else sum(gdo.work_hour) end workhour,")
				.append("decode(sd.coding_name,'待工',sumnum,0) as daigongnum,")
				.append("decode(sd.coding_name,'检修',sumnum,0) as jianxiunum,decode(sd.coding_name, '出勤', sumnum, 0) as kaoqin ")
				.append("from (select device_account_id,timesheet_symbol ,count(1) as sumnum ")
				.append("from bgp_comm_device_timesheet where 1=1 ");
		if (!startDate.equals("")) {
			selectSql.append(" and timesheet_date>=to_date('" + startDate
					+ "','yyyy-mm-dd') ");
		}
		if (!endDate.equals("")) {
			selectSql.append(" and timesheet_date<=to_date('" + endDate
					+ "','yyyy-mm-dd') ");
		}
		selectSql
				.append("group by device_account_id,timesheet_symbol ) tmp ")
				.append("join comm_coding_sort_detail sd on tmp.timesheet_symbol=sd.coding_code_id  ")
				.append("join gms_device_account_dui dui on tmp.device_account_id=dui.dev_acc_id  ")
				.append("left join GMS_DEVICE_OPERATION_INFO gdo on tmp.device_account_id = gdo.dev_acc_id ")
				.append("where dui.project_info_id='" + projectInfoNo + "' ");
		if (!licenseNum.equals("")) {
			selectSql.append(" and dui.license_num='" + licenseNum + "'");
		}
		selectSql
				.append("group by dui.dev_acc_id,sd.coding_name,sumnum,sd.coding_name,sumnum,dui.dev_name,dui.dev_type,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num,dui.actual_in_time )b ")
				.append("left join bgp_comm_device_oil_info doi on b.dev_acc_id = doi.device_account_id ")
				.append("left join (select tod.dev_acc_id ,case when sum(tod.oil_num) is null then 0 else sum(tod.oil_num) end oil_num ")
				.append("from gms_mat_teammat_out mto left join GMS_MAT_TEAMMAT_OUT_DETAIL tod on mto.teammat_out_id= tod.teammat_out_id and tod.bsflag='0' ")
				.append("where mto.bsflag='0' and mto.out_type='3' ");
		if (!startDate.equals("")) {
			selectSql.append(" and mto.outmat_date>=to_date('" + startDate
					+ "','yyyy-mm-dd') ");
		}
		if (!endDate.equals("")) {
			selectSql.append(" and mto.outmat_date<=to_date('" + endDate
					+ "','yyyy-mm-dd') ");
		}
		selectSql
				.append("group by tod.dev_acc_id ) oil on b.dev_acc_id = oil.dev_acc_id ")
				.append("group by b.dev_acc_id, b.dev_type, b.dev_name,b.actual_in_time, b.dev_model, b.self_num, b.dev_sign, b.license_num,b.mileage,b.drillingfootage,b.workhour,b.daigongnum,b.jianxiunum,b.kaoqin ")
				.append(")a ")
				.append("group by a.dev_acc_id,a.dev_name,a.dev_type,a.dev_model,a.self_num,a.dev_sign,a.license_num,a.oilnum,a.mileage,a.drillingfootage,a.workhour order by a.dev_name ");

		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null, muddle_td = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				muddle_td = "muddle_td";
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				contenttr.addAttribute("onclick", "popDevQueqinJianxiuDetail('"
						+ tempMap.get("dev_acc_id") + "')");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("dev_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("dev_model").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd4.addText(tempMap.get("self_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd5.addText(tempMap.get("dev_sign").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd6.addText(tempMap.get("license_num").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("chuqinnum").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classodd);
				contenttd8.addText(tempMap.get("daigongnum").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classeven);
				contenttd9.addText(tempMap.get("jianxiunum").toString());
				Element contenttd10 = contenttr.addElement("td");
				contenttd10.addAttribute("class", classodd);
				contenttd10.addText(tempMap.get("oilnum").toString());
				Element contenttd11 = contenttr.addElement("td");
				contenttd11.addAttribute("class", classeven);
				contenttd11.addText(tempMap.get("workhour").toString());
				Element contenttd12 = contenttr.addElement("td");
				contenttd12.addAttribute("class", classodd);
				contenttd12.addText(tempMap.get("drillingfootage").toString());
				Element contenttd13 = contenttr.addElement("td");
				contenttd13.addAttribute("class", classeven);
				contenttd13.addText(tempMap.get("mileage").toString());
				Element contenttd14 = contenttr.addElement("td");
				contenttd14.addAttribute("class", classodd);
				contenttd14.addText(tempMap.get("dwyh").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 采集设备统计 外层汇总 2013-1-18
	 */
	public ISrvMsg getCollEqSumStatistics(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		String conditionsql = "select device_id,dev_name,dev_code from gms_device_collectinfo where is_leaf=0 and node_level='1' order by dev_code";
		List<Map> conditionList = jdbcDAO.queryRecords(conditionsql);
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("yAxisName", "设备数量");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");

		String devsql = "select distinct b.revtotal,dui.dev_name from gms_device_account_dui dui inner join (select count(*) as revtotal from gms_device_account_dui dui where dui.dev_type like'S14050101%' and dui.project_info_id='"
				+ projectInfoNo
				+ "' and nvl(dui.bsflag,0)!='N') b on 1=1 where dui.dev_type like 'S14050101%' and dui.project_info_id='"
				+ projectInfoNo
				+ "' and nvl(dui.bsflag,0)!='N' union all select distinct b.revtotal,'检波器' as dev_name from gms_device_account_dui dui inner join (select count(*) as revtotal from gms_device_account_dui dui where dui.dev_type like'S14050208%' and dui.project_info_id='"
				+ projectInfoNo
				+ "' and nvl(dui.bsflag,0)!='N') b on 1=1 where dui.dev_type like'S14050208%' and dui.project_info_id='"
				+ projectInfoNo + "' and nvl(dui.bsflag,0)!='N'";
		String sumSql = "select device_id,dev_name,revtotal from (";
		for (int i = 0; i < conditionList.size(); i++) {
			Map tmpMap = conditionList.get(i);
			if (i != 0) {
				sumSql += "union ";
			}
			sumSql += "(select '"
					+ i
					+ "' as seq,'"
					+ tmpMap.get("device_id")
					+ "' as device_id,'"+tmpMap.get("dev_name")+"' as dev_name,sum(dui.total_num) as revtotal "
					+ "from gms_device_coll_account_dui dui "
					+ "left join gms_device_collectinfo info on info.device_id = dui.device_id "
					+ "where dui.project_info_id='" + projectInfoNo
					+ "' and info.dev_code like'" + tmpMap.get("dev_code")
					+ "%' and nvl(dui.bsflag,0)!='N' group by substr(info.dev_code,0,2) ) ";
		}
		sumSql += ") order by seq";
		List<Map> summap = jdbcDAO.queryRecords(sumSql);
		List<Map> datalist = jdbcDAO.queryRecords(devsql);
		if (summap != null && summap.size() > 0) {
			for (int i = 0; i < summap.size(); i++) {
				datalist.add(summap.get(i));
			}
		}
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		// 获取结果
		// String equipmentNum = "";
		String drillLevel = reqDTO.getValue("drillLevel");
		if (datalist != null && datalist.size() > 0) {
			for (Map dataMap : datalist) {
				String equipmentNum = "" + dataMap.get("revtotal");
				String devname = "" + dataMap.get("dev_name");
				String device_id = "" + dataMap.get("device_id");
				Element category = categories.addElement("category");
				category.addAttribute("label", devname);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				if (drillLevel != null) {
					if ("2".equals(drillLevel)) {
						set.addAttribute("link", "j-popCollEqStaticinfo-"
								+ device_id);
					} else if ("1".equals(drillLevel)) {
						String orgkeyId = reqDTO.getValue("orgkeyId");
						set.addAttribute("link",
								"j-drillWutanTeamProCaijiDevInfosForSingle-"
										+ orgkeyId + "~" + projectInfoNo + "~"
										+ device_id);
					}
				}
			}
		} else {
			Element set = root.addElement("set");
			set.addAttribute("label", "没有采集设备信息");
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 电子设备统计zjt修改
	 */
	public ISrvMsg getElectronicEquipmentStatistics(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String deviceid = reqDTO.getValue("deviceid");// "采集站对应的ID";

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("yAxisName", "设备数量");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");

		String preSql = "select case when dym.opr_type=2 then 0-dym.receive_num else dym.receive_num end as revnum, "
				+ "dym.opr_type,to_char(dym.actual_in_time,'yyyy-mm-dd')||to_char(dym.actual_out_time,'yyyy-mm-dd') dateinfo, "
				+ "case when dym.actual_in_time is not null then '1' else '2' end as actual_flag "
				+ "from gms_device_coll_account_dym dym "
				+ "left join gms_device_coll_account_dui dui on dui.dev_acc_id=dym.dev_acc_id "
				+ "left join gms_device_collectinfo ci on dui.device_id=ci.device_id ";
		if("8ad88271448dddeb01448fb3992d0894".equals(deviceid)){//线缆
			preSql += "where ci.node_parent_id ='"
				+ deviceid
				+ "' and dui.project_info_id='"
				+ projectInfoNo
				+ "' "
				+ "order by nvl(dym.actual_in_time,dym.actual_out_time),actual_flag desc ";
		}else{
			preSql += "left join gms_device_collectinfo parent on ci.node_parent_id=parent.device_id  "
				+ "where parent.node_parent_id ='"
				+ deviceid
				+ "' and dui.project_info_id='"
				+ projectInfoNo
				+ "' "
				+ "order by nvl(dym.actual_in_time,dym.actual_out_time),actual_flag desc ";
			
		}
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List list = null;
		try {
			list = jdbcDAO.queryRecords(preSql);
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		// String equipmentNum = "";
		String drillLevel = reqDTO.getValue("drillLevel");
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				Map dataMap = (Map) list.get(i);
				Element set = root.addElement("set");
				String showlabel = null;
				String showcolor = null;
				if ("1".equals((String) dataMap.get("actual_flag"))) {
					showlabel = ((String) dataMap.get("dateinfo")) + "进场";
					showcolor = "F9DA7A";
				} else {
					showlabel = ((String) dataMap.get("dateinfo")) + "离场";
					showcolor = "D1E8F9";
				}
				set.addAttribute("label", showlabel);
				set.addAttribute("color", showcolor);
				set.addAttribute("value", (String) dataMap.get("revnum"));
				if (drillLevel != null && "1".equals(drillLevel)) {
					String orgkeyId = reqDTO.getValue("orgkeyId");
					set.addAttribute("link", "j-drillWutanTeamProCaijiDevBack-"
							+ orgkeyId);
				}
			}
			// 拼XML文档
			String sumSql = "select sum(unuse_num) as revtotal from gms_device_coll_account_dui dui "
					+ "left join gms_device_collectinfo ci on dui.device_id=ci.device_id  ";
			if("8ad88271448dddeb01448fb3992d0894".equals(deviceid)){//线缆
				sumSql+= "where ci.node_parent_id='"
					+ deviceid
					+ "' and dui.project_info_id='" + projectInfoNo + "' ";
			}else{
				sumSql+= "left join gms_device_collectinfo parent on ci.node_parent_id=parent.device_id  "
					+ "where parent.node_parent_id='"
					+ deviceid
					+ "' and dui.project_info_id='" + projectInfoNo + "' ";
			}
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(sumSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("revtotal");
				Element set = root.addElement("set");
				set.addAttribute("label", "总数");
				set.addAttribute("color", "9FA994");
				set.addAttribute("value", equipmentNum);
				if (drillLevel != null && "1".equals(drillLevel)) {
					String orgkeyId = reqDTO.getValue("orgkeyId");
					set.addAttribute("link", "j-drillWutanTeamProCaijiDevBack-"
							+ orgkeyId);
				}
			}
		} else {
			Element set = root.addElement("set");
			set.addAttribute("label", "没有此类设备");
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机动设备配备班组钻取
	 */
	public ISrvMsg getTeamDevInfoDrillDownForTable(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String dev_types = reqDTO.getValue("code");
		String[] codes = dev_types.split("~", -1);

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		titletr.addAttribute("onclick", "javascript:drillDownTeamDevInfoBack()");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("设备名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("自编号");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("实物标识号");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("牌照号");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("AMIS资产编号");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_even");
		titletd8.addText("班组");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_odd");
		titletd9.addText("操作手");

		StringBuffer selectSql = new StringBuffer()
				.append("select dev_name,dev_model,license_num,self_num,dev_sign,asset_coding,")
				.append("oprtbl.operator_name as alloprinfo,teamsd.coding_name as team_name ")
				.append("from gms_device_account_dui dui ")
				.append("left join (select device_account_id,operator_name from ( ")
				.append("select tmp.device_account_id,tmp.operator_name,row_number() ")
				.append("over(partition by device_account_id order by length(operator_name) desc ) as seq ")
				.append("from (select device_account_id,wmsys.wm_concat(operator_name) ")
				.append("over(partition by device_account_id order by operator_name) as operator_name ")
				.append("from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id ")
				.append("left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = dui.dev_team ")
				.append("where dui.project_info_id='" + projectInfoNo + "'");

		if (codes[1].contains(",")) {
			String[] codeArray = codes[1].split(",");
			selectSql.append(" and (dev_type like 'S").append(codeArray[0])
					.append("%'");
			selectSql.append("      or dev_type like 'S").append(codeArray[1])
					.append("%')");
		} else {
			selectSql.append(" and dev_type like 'S").append(codes[1])
					.append("%'");
		}
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				contenttr.addAttribute("onclick",
						"javascript:drillDownTeamDevInfoBack()");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("dev_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("dev_model").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("self_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("dev_sign").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("license_num").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("asset_coding").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classeven);
				contenttd8.addText(tempMap.get("team_name").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classodd);
				contenttd9.addText(tempMap.get("alloprinfo").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机动设备配备班组钻取 地震队级
	 */
	public ISrvMsg getTeamDevInfoDrillDownForTableForPop(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String dev_types = reqDTO.getValue("code");
		String[] codes = dev_types.split("~", -1);

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("设备名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("自编号");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("实物标识号");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("牌照号");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("AMIS资产编号");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_even");
		titletd8.addText("班组");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_odd");
		titletd9.addText("操作手");

		StringBuffer selectSql = new StringBuffer()
				.append("select dev_name,dev_model,license_num,self_num,dev_sign,asset_coding,")
				.append("oprtbl.operator_name as alloprinfo,teamsd.coding_name as team_name ")
				.append("from gms_device_account_dui dui ")
				.append("left join (select device_account_id,operator_name from ( ")
				.append("select tmp.device_account_id,tmp.operator_name,row_number() ")
				.append("over(partition by device_account_id order by length(operator_name) desc ) as seq ")
				.append("from (select device_account_id,wmsys.wm_concat(operator_name) ")
				.append("over(partition by device_account_id order by operator_name) as operator_name ")
				.append("from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id ")
				.append("left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = dui.dev_team ")
				.append("where dui.project_info_id='" + projectInfoNo
						+ "' and dui.dev_team='" + codes[0] + "' ");

		if (codes[1].contains(",")) {
			String[] codeArray = codes[1].split(",");
			selectSql.append(" and (dev_type like 'S").append(codeArray[0])
					.append("%'");
			selectSql.append("      or dev_type like 'S").append(codeArray[1])
					.append("%')");
		} else {
			selectSql.append(" and dev_type like 'S").append(codes[1])
					.append("%'");
		}
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("dev_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("dev_model").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("self_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("dev_sign").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("license_num").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("asset_coding").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classeven);
				contenttd8.addText(tempMap.get("team_name").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classodd);
				contenttd9.addText(tempMap.get("alloprinfo").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/**
	 * 地震队项目缺勤、检修的信息钻取(地震队级)
	 * */
	public ISrvMsg getDevQueqinJianxiuDetailForPop(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String devaccid = reqDTO.getValue("devaccid");

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("设备名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("自编号");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("实物标识号");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("牌照号");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("日期");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_even");
		titletd8.addText("出勤类别");

		StringBuffer selectSql = new StringBuffer("")
				.append("select dui.dev_name,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num, ")
				.append("to_char(timesheet_date,'yyyy-mm-dd') as timesheet_date,sd.coding_name as timesheet_name ")
				.append("from bgp_comm_device_timesheet ts,gms_device_account_dui dui,comm_coding_sort_detail sd ")
				.append("where ts.device_account_id=dui.dev_acc_id  ")
				.append("and ts.timesheet_symbol=sd.coding_code_id ")
				.append("and ts.timesheet_symbol!='5110000041000000001' ")
				.append("and ts.device_account_id='" + devaccid + "' ")
				.append("order by ts.timesheet_symbol,ts.timesheet_date ");

		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("dev_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("dev_model").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("self_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("dev_sign").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("license_num").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("timesheet_date").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classeven);
				contenttd8.addText(tempMap.get("timesheet_name").toString());
			}
		}
		String dataXML = root.asXML();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机动设备配备统计
	 */
	public ISrvMsg getMobileEquipmentStatisticsForTable(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();
		equipmentList.add("070301-推土机");
		equipmentList.add("080101-卡车");
		equipmentList.add("08010301,08010302-油水罐车");
		equipmentList.add("08010304-雷管炸药车");
		equipmentList.add("060101-车装钻机");
		equipmentList.add("060102-人抬化钻机");
		equipmentList.add("080105-皮卡");
		equipmentList.add("062301-可控震源");
		equipmentList.add("080503-沙滩摩托车");
		equipmentList.add("0803-载客车辆");
		equipmentList.add("0804-生产用特种车辆");
		equipmentList.add("0806-专用车辆");
		equipmentList.add("0901-发电机组");

		// 根据team的数量，分别取查找team的设备配备信息
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("班组");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("设备类别");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("数量");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("合计");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");

		String hejisql = "select count(1) as realnum from gms_device_account_dui dui "
				+ "where dui.project_info_id='"
				+ projectInfoNo
				+ "' and dui.dev_team='@' ";
		for (int i = 0; i < equipmentList.size(); i++) {
			if (i == 0) {
				hejisql += " and (";
			}
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("-");
			String equipmentCode = strArray[0];
			if (equipmentCode.contains(",")) {
				String[] codeArray = equipmentCode.split(",");
				if (i != 0) {
					hejisql += " or ";
				}
				hejisql += " dui.dev_type like 'S" + codeArray[0] + "%' ";
				hejisql += " or dui.dev_type like 'S" + codeArray[1] + "%' ";
			} else {
				if (i != 0) {
					hejisql += " or ";
				}
				hejisql += " dui.dev_type like 'S" + equipmentCode + "%' ";
			}
		}
		hejisql += ") ";

		String preSql = " select devtypecode,devtypename,count(1) as realnum from (";
		String conditionsql = "where dui.project_info_id='" + projectInfoNo
				+ "' and dui.dev_team='@' ";
		StringBuffer tmptableSql = new StringBuffer();
		for (int i = 0; i < equipmentList.size(); i++) {
			if (i != 0) {
				tmptableSql.append(" union ");
			}
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("-");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			if (equipmentCode.contains(",")) {
				String[] codeArray = equipmentCode.split(",");
				tmptableSql
						.append("(select '"
								+ equipmentCode
								+ "' as devtypecode,'"
								+ equipmentName
								+ "' as devtypename,dui.dev_acc_id from gms_device_account_dui dui ")
						.append(conditionsql);
				tmptableSql.append(" and (dui.dev_type like 'S")
						.append(codeArray[0]).append("%'");
				tmptableSql.append("      or dui.dev_type like 'S")
						.append(codeArray[1]).append("%')) ");
			} else {
				tmptableSql
						.append("(select '"
								+ equipmentCode
								+ "' as devtypecode,'"
								+ equipmentName
								+ "' as devtypename,dui.dev_acc_id from gms_device_account_dui dui ")
						.append(conditionsql);
				tmptableSql.append(" and dui.dev_type like 'S")
						.append(equipmentCode).append("%') ");
			}
		}
		String groupbySql = ") tmp group by devtypecode,devtypename ";
		// 先查询班组
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		String teamSql = "select distinct dev_team, sd.coding_name from gms_device_account_dui dui join comm_coding_sort_detail sd on dui.dev_team=sd.coding_code_id where dui.project_info_id='"
				+ projectInfoNo + "'";
		List<Map> teamList = jdbcDAO.queryRecords(teamSql);
		List<String> teamNameList = new ArrayList<String>();
		List<String> teamCodeList = new ArrayList<String>();
		int teamSize = 0;
		if (teamList != null) {
			teamSize = teamList.size();
		}
		// 维护班组的数据集
		for (int i = 0; i < teamList.size(); i++) {
			Map map = teamList.get(i);
			String teamName = "" + map.get("coding_name");
			String teamCode = "" + map.get("dev_team");
			teamNameList.add(teamName);
			teamCodeList.add(teamCode);
		}
		for (int index = 0; index < teamCodeList.size(); index++) {
			String teamName = teamNameList.get(index);
			String teamCode = teamCodeList.get(index);
			Map totalMap = null;
			// 执行Sql
			List<Map> resultList = null;
			try {
				totalMap = jdbcDAO.queryRecordBySQL(hejisql.replace("@",
						teamCodeList.get(index)));
				String patitionsql = preSql + tmptableSql.toString()
						+ groupbySql;
				resultList = jdbcDAO.queryRecords(patitionsql.replace("@",
						teamCodeList.get(index)));
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			if (resultList != null) {
				for (int m = 0; m < resultList.size(); m++) {
					Map tempMap = resultList.get(m);
					String classodd = null, classeven = null;
					if (index % 2 == 0) {
						classodd = "odd_odd";
						classeven = "odd_even";
					} else {
						classodd = "even_odd";
						classeven = "even_even";
					}
					if (m == 0) {
						// 生成几个的列信息
						Element contenttr = root.addElement("tr");
						Element contenttd1 = contenttr.addElement("td");
						contenttd1.addAttribute("rowspan", resultList.size()
								+ "");
						contenttd1.addText((index + 1) + "");
						contenttd1.addAttribute("class", classodd);
						Element contenttd2 = contenttr.addElement("td");
						contenttd2.addAttribute("rowspan", resultList.size()
								+ "");
						contenttd2.addText(teamName);
						contenttd2.addAttribute("class", classeven);
						Element contenttd3 = contenttr.addElement("td");
						contenttd3.addText(tempMap.get("devtypename")
								.toString());
						contenttd3.addAttribute("class", classodd);
						contenttd3.addAttribute("onclick", "drillteamdev('"
								+ teamCode + "~"
								+ tempMap.get("devtypecode").toString() + "')");
						Element contenttd4 = contenttr.addElement("td");
						contenttd4.addText(tempMap.get("realnum").toString());
						contenttd4.addAttribute("class", classeven);
						contenttd4.addAttribute("onclick", "drillteamdev('"
								+ teamCode + "~"
								+ tempMap.get("devtypecode").toString() + "')");
						Element contenttd5 = contenttr.addElement("td");
						contenttd5.addAttribute("rowspan", resultList.size()
								+ "");
						contenttd5.addText(totalMap.get("realnum").toString());
						contenttd5.addAttribute("class", classodd);
					} else {

						Element contenttr = root.addElement("tr");
						Element contenttd3 = contenttr.addElement("td");
						contenttd3.addText(tempMap.get("devtypename")
								.toString());
						contenttd3.addAttribute("class", classodd);
						contenttd3.addAttribute("onclick", "drillteamdev('"
								+ teamCode + "~"
								+ tempMap.get("devtypecode").toString() + "')");
						Element contenttd4 = contenttr.addElement("td");
						contenttd4.addText(tempMap.get("realnum").toString());
						contenttd4.addAttribute("class", classeven);
						contenttd4.addAttribute("onclick", "drillteamdev('"
								+ teamCode + "~"
								+ tempMap.get("devtypecode").toString() + "')");
					}
				}
			}
		}
		String dataXML = root.asXML();
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 机动设备配备统计
	 */
	public ISrvMsg getMobileEquipmentStatistics(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();
		equipmentList.add("070301-推土机");
		equipmentList.add("080101-卡车");
		equipmentList.add("08010301,08010302-油水罐车");
		equipmentList.add("08010304-雷管炸药车");
		equipmentList.add("060101-车装钻机");
		equipmentList.add("060102-人抬化钻机");
		equipmentList.add("080105-皮卡");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		String teamSql = "select distinct dev_team, sd.coding_name from gms_device_account_dui dui join comm_coding_sort_detail sd on dui.dev_team=sd.coding_code_id where dui.project_info_id='"
				+ projectInfoNo + "'";
		List<Map> teamList = jdbcDAO.queryRecords(teamSql);
		List<String> teamNameList = new ArrayList<String>();
		List<String> teamCodeList = new ArrayList<String>();

		String preSql = " select coding_code_id,coding_name as team_name,count(1) as realnum "
				+ "from gms_device_account_dui dui join comm_coding_sort_detail sd on dui.dev_team=sd.coding_code_id "
				+ "where dui.project_info_id='" + projectInfoNo + "' ";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机动设备配备统计");
		// root.addAttribute("xAxisName", "设备类型");
		// root.addAttribute("yAxisName", "班组配备数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		int teamSize = 0;
		if (teamList != null) {
			teamSize = teamList.size();
		}

		// 维护当前项目的所有班组数据集
		Element[] datasets = new Element[teamSize];
		for (int i = 0; i < teamList.size(); i++) {
			Map map = teamList.get(i);
			String teamName = "" + map.get("coding_name");
			String teamCode = "" + map.get("dev_team");
			teamNameList.add(teamName);
			teamCodeList.add(teamCode);

			datasets[i] = root.addElement("dataset");
			datasets[i].addAttribute("seriesName", teamName);
		}

		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("-");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			selectSql.append(preSql);
			if (equipmentCode.contains(",")) {
				String[] codeArray = equipmentCode.split(",");
				selectSql.append(" and (dev_type like 'S").append(codeArray[0])
						.append("%'");
				selectSql.append("      or dev_type like 'S")
						.append(codeArray[1]).append("%')");
			} else {
				selectSql.append(" and dev_type like 'S").append(equipmentCode)
						.append("%'");
			}
			selectSql.append(" group by coding_name,coding_code_id");
			// 执行Sql
			List<Map> resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecords(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			// 拼XML文档
			Element category = categories.addElement("category");
			category.addAttribute("label", equipmentName);
			for (int m = 0; m < teamNameList.size(); m++) {
				String teamName = teamNameList.get(m);
				String teamCode = teamCodeList.get(m);

				boolean dataExist = false;
				if (resultMap != null) {
					for (int k = 0; k < resultMap.size(); k++) {
						Map map3 = resultMap.get(k);
						String equipmentNum = "" + map3.get("realnum");
						String curTeamName = "" + map3.get("team_name");
						if (curTeamName.equals(teamName)
								|| curTeamName == teamName) {
							Element set = datasets[m].addElement("set");
							set.addAttribute("value", equipmentNum);
							set.addAttribute("link", "j-drillteamdev-"
									+ teamCode + "~" + equipmentCode);
							dataExist = true;
							break;
						}
					}
				}
				if (dataExist == false) {
					// 放置空数据
					Element set = datasets[m].addElement("set");
				}
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 采集项目主要设备到位率统计
	 */
	public ISrvMsg geAcquisitionEquipmentStatistics(ISrvMsg reqDTO)
			throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();
		equipmentList.add("070301-推土机");
		equipmentList.add("060101-车装钻机");
		equipmentList.add("060102-人抬化钻机");
		equipmentList.add("080101-卡车");
		equipmentList.add("08010301,08010302-油水罐车");
		equipmentList.add("080105-皮卡");
		equipmentList.add("08010304-雷管炸药车");
		equipmentList.add("110402-车载电台");
		equipmentList.add("110404-对讲机");
		equipmentList.add("14030106-现场处理机");
		equipmentList.add("14050208-检波器");
		equipmentList.add("1601-野营房");
		equipmentList.add("14050101-地震仪器主机");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		// 获取日期范围
		String dateSql = "select to_char((case when min(dad.plan_start_date)<min(dui.actual_in_time) then min(dad.plan_start_date) else min(dui.actual_in_time) end),'yyyy-mm-dd') as min_date, "
				+ "to_char((case when max(dad.plan_start_date)>max(dui.actual_in_time) then max(dad.plan_start_date) else max(dui.actual_in_time) end),'yyyy-mm-dd') as max_date "
				+ "from gms_device_allapp_detail dad,gms_device_account_dui dui where dad.project_info_no='"
				+ projectInfoNo
				+ "' and dui.project_info_id='"
				+ projectInfoNo
				+ "'";
		Map dateMap = jdbcDAO.queryRecordBySQL(dateSql);
		String minDate = "";
		String maxDate = "";
		if (dateMap != null) {
			minDate = "" + dateMap.get("min_date");
			maxDate = "" + dateMap.get("max_date");
		}
		long diffDays = 0;
		diffDays = DateOperation.diffDaysOfDate(maxDate, minDate);
		List axisDateList = new ArrayList();

		if (!"".equals(minDate)) {
			axisDateList.add(minDate);
		}
		// 生成日期坐标
		if (diffDays > 0) {
			if (diffDays > 20) {
				for (int i = 1; i < 21; i++) {
					long afterNDay = new Float(i * diffDays / 20).longValue();
					String nextDate = DateOperation.afterNDays(minDate,
							afterNDay);
					axisDateList.add(nextDate);
				}
			}

			if (diffDays < 21) {
				for (int i = 1; i < diffDays; i++) {
					String nextDate = DateOperation.afterNDays(minDate, i);
					axisDateList.add(nextDate);
				}
			}
		}
		// 设备类型条件
		StringBuffer option1 = new StringBuffer();
		StringBuffer option2 = new StringBuffer();
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = "" + equipmentList.get(i);
			String[] values = value.split("-")[0].split(",", -1);
			for (int index = 0; index < values.length; index++) {
				option1.append(" or dev_ci_code like 'S").append(values[index])
						.append("%' ");
				option1.append(" or dev_ci_code like '").append(values[index])
						.append("%' ");
				option2.append(" or dev_type like 'S").append(values[index])
						.append("%'");
			}
		}
		String sqlOption1 = option1.toString();
		String sqlOption2 = option2.toString();
		sqlOption1 = " and(" + sqlOption1.substring(4, sqlOption1.length())
				+ ")";
		sqlOption2 = " and(" + sqlOption2.substring(4, sqlOption2.length())
				+ ")";

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震采集项目主要设备到位率统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("yAxisName", "设备数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		Element categories = root.addElement("categories");

		Element planDataset = root.addElement("dataset");
		planDataset.addAttribute("seriesName", "计划到位统计");
		Element actualDataset = root.addElement("dataset");
		actualDataset.addAttribute("seriesName", "实际到位统计");

		for (int i = 0; i < axisDateList.size(); i++) {
			String curDate = "" + axisDateList.get(i);
			Element category = categories.addElement("category");
			category.addAttribute("label", curDate);

			String dateOption1 = " and plan_start_date <= to_date('" + curDate
					+ "','yyyy-MM-dd')";
			String dateOption2 = " and actual_in_time <= to_date('" + curDate
					+ "','yyyy-MM-dd')";

			String planSql = " select sum(approve_num) as plan_num from gms_device_allapp_detail where project_info_no='"
					+ projectInfoNo + "' and bsflag='0' ";
			String actualSql = " select count(1) as actual_num from gms_device_account_dui where project_info_id='"
					+ projectInfoNo + "'";

			planSql = planSql + sqlOption1 + dateOption1;
			actualSql = actualSql + sqlOption2 + dateOption2;
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(planSql);
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			String planNum = "0";
			if (resultMap != null) {
				planNum = "" + resultMap.get("plan_num");
				if ("".equals(planNum))
					planNum = "0";
			}
			Element planSet = planDataset.addElement("set");
			planSet.addAttribute("value", planNum);

			try {
				resultMap = jdbcDAO.queryRecordBySQL(actualSql);
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			String actualNum = "0";
			if (resultMap != null) {
				actualNum = "" + resultMap.get("actual_num");
				if ("".equals(actualNum))
					actualNum = "0";
			}
			Element actualSet = actualDataset.addElement("set");
			actualSet.addAttribute("value", actualNum);
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/**
	 * 异步查询各项目主要设备完好率、利用率统计
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg geDeviceLiyongWanhaoStatistics(ISrvMsg reqDTO)
			throws Exception {
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		// orgid,not org_sub_id
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberSuffix", "%");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");

		String[] devtypes = new String[] { "070301-推土机", "08-运输设备",
				"060101-车装钻机", "060102-人抬化钻机" };// ,"0901-发电机组"

		// 规定显示的分组信息
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "完好率");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "利用率");
		// Element dataset3 = root.addElement("dataset");
		// dataset3.addAttribute("seriesName", "制度完好率");
		// Element dataset4 = root.addElement("dataset");
		// dataset4.addAttribute("seriesName", "制度利用率");

		// 统计两个值类数值
		StringBuffer sb = new StringBuffer(
				"select case when zhidu.zhidutaitian = 0 or zhidu.zhidutaitian is null then 0 ")
				.append("else trunc((zhidu.zhidutaitian-wanhao.nowanhao)/zhidu.zhidutaitian,4) end as wanhaolv,")
				.append("case when zhidu.zhidutaitian = 0 or zhidu.zhidutaitian is null then 0 ")
				.append(" else trunc((zhidu.zhidutaitian-liyong.noliyong)/zhidu.zhidutaitian,4) end as liyonglv ")
				.append("from (select '@' as proflag from dual ) base ")
				.append("left join ")
				.append("(select '@' as proflag,sum(case when dui.actual_out_time is null ")
				.append("then to_number(trunc(sysdate,'dd')-trunc(actual_in_time,'dd')) ")
				.append("else to_number(trunc(actual_out_time,'dd')-trunc(actual_in_time,'dd')) end) as zhidutaitian ")
				.append("from gms_device_account_dui dui ")
				.append("where dui.project_info_id='" + projectInfoNo + "' ")
				.append("and dev_type like 'S@%') zhidu on base.proflag = zhidu.proflag  ")
				.append("left join ")
				.append("(select '@' as proflag,count(1) as nowanhao  ")
				.append("from bgp_comm_device_timesheet sheet ")
				.append("where exists(select 1 from gms_device_account_dui dui where dui.dev_acc_id=sheet.device_account_id ")
				.append("and timesheet_symbol in ('5110000041000000002') ")
				.append("and dui.project_info_id='" + projectInfoNo + "' ")
				.append("and dev_type like 'S@%' )) wanhao on base.proflag = wanhao.proflag ")

				.append("left join ")
				.append("(select '@' as proflag,count(1) as noliyong  ")
				.append("from bgp_comm_device_timesheet sheet ")
				.append("where exists(select 1 from gms_device_account_dui dui where dui.dev_acc_id=sheet.device_account_id ")
				.append("and timesheet_symbol in ('5110000041000000002','5110000041000000003') ")
				.append("and dui.project_info_id='" + projectInfoNo + "' ")
				.append("and dev_type like 'S@%' )) liyong on base.proflag = liyong.proflag ");
		for (int index = 0; index < devtypes.length; index++) {
			List<Map> list = jdbcDAO.queryRecords(sb.toString().replaceAll("@",
					devtypes[index].split("-")[0]));

			Element category = categories.addElement("category");
			category.addAttribute("label", devtypes[index].split("-")[1]);

			if (list != null) {

				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", MessageFormat.format(
						"{0,number,0.0}",
						new Object[] { new Float(Float.parseFloat((list.get(0))
								.get("wanhaolv").toString()) * 100) }));

				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", MessageFormat.format(
						"{0,number,0.0}",
						new Object[] { new Float(Float.parseFloat((list.get(0))
								.get("liyonglv").toString()) * 100) }));

				// Element set3 = dataset3.addElement("set");
				// set3.addAttribute("value",
				// MessageFormat.format("{0,number,0.00}", new Object[]{new
				// Float(Float.parseFloat((list.get(0)).get("wanhaolv").toString())*1.5)}));
				//
				// Element set4 = dataset4.addElement("set");
				// set4.addAttribute("value",
				// MessageFormat.format("{0,number,0.00}", new Object[]{new
				// Float(Float.parseFloat((list.get(0)).get("liyonglv").toString())*1.5)}));

			} else {
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", "0");

				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", "0");

				// Element set3 = dataset3.addElement("set");
				// set3.addAttribute("value", "0");
				//
				// Element set4 = dataset4.addElement("set");
				// set4.addAttribute("value", "0");
			}
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("xmldata", document.asXML());
		System.out.println(msg.getValue("xmldata"));
		return msg;
	}

	/**
	 * 机械设备配置统计表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMecEquConStaForTable(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String sql = "select tab.* ,count(*) over (partition by tab.dev_name) as rsize,sum(tab.numb) over (partition by tab.dev_name) as snum from ( "
				+ " select '车装钻机' as dev_name,t.dev_model,'台' as dev_unit,count(*) numb ,'0' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S060101%' and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '山地钻机' as dev_name,t.dev_model,'套' as dev_unit,count(*) numb ,'1' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S060102%' and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '吉普车' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'2' as numorder  "
				+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S080304%' and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '普通卡车' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'3' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0'  and t.dev_type in ('S0801010002011','S0801010002037','S0801010002009','S0801010002015','S0801010002030','S0801010002013', "
				+ " 'S0801010099021','S0801010002004','S0801010007020','S0801010002010','S0801010004004','S0801010002040','S0801010002050','S0801010001003','S0801010001004','S0801010002037', "
				+ " 'S0801010002042','S0801010008004','S0801010009003','S0801010002018','S0801010002032','S0801010002014') "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '沙漠卡车' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'4' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0'  and t.dev_type in ('S0801010002035','S0801010007006','S0801010006004','S0801010007007','S0801010002036', "
				+ " 'S0801010002047','S0801010002035','S0801010002038','S0801010002046','S0801010010007','S0801010010005','S0801010010009','S0801010006004','S0801010002039', "
				+ " 'S0801010010008','S0801010010002','S0801010010001','S0801010002045','S0801010010001','S0801010002038','S0801010002045','S0801010002041','S0801010010003', "
				+ " 'S0801010011009','S0801010011005','S0801010010012','S0801010002048','S0801010010006','S0801010010009','S0801010010013','S0801010002044','S0801010002048', "
				+ " 'S0801010007013','S0801010007007','S0801010006006','S0801010007008','S0801010007010') "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '皮卡' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'5' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0'  and t.dev_type like 'S080105%' "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '雷管炸药车' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'6' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S08010304%' "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '油水灌车' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'7' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0' and (t.dev_type like 'S08010301%' or t.dev_type like 'S08010302%') "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '推土机' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'8' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S070301%' "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " select '专用车辆' as dev_name,t.dev_model,'辆' as dev_unit,count(*) numb ,'9' as numorder "
				+ " from gms_device_account_dui t where t.bsflag = '0' and t.dev_type like 'S0806%' "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' group by t.dev_model "
				+ " union all "
				+ " SELECT '地震仪器' as dev_name,T.DEV_MODEL,'道' as dev_unit,SUM(nvl(T.TOTAL_NUM, 0) * nvl(T2.DEVICE_SLOT_NUM, 0)) as numb ,'10' as numorder "
				+ " FROM GMS_DEVICE_COLL_ACCOUNT_dui T LEFT JOIN GMS_DEVICE_COLLECTINFO T1 ON T1.DEVICE_ID = T.DEVICE_ID "
				+ " LEFT JOIN GMS_DEVICE_COLLMODEL_SUB T2 ON T2.DEVICE_ID = T.DEVICE_ID WHERE (T1.DEV_CODE LIKE '01%' OR T1.DEV_CODE LIKE '02%' OR T1.DEV_CODE LIKE '03%') "
				+ " and t.project_info_id = '"
				+ projectInfoNo
				+ "' GROUP BY T.DEV_MODEL "
				+ " union all "
				+ " SELECT '检波器' as dev_name,T.DEV_MODEL,'串' as dev_unit,sum(nvl(T.TOTAL_NUM, 0)) as numb ,'11' as numorder "
				+ " FROM GMS_DEVICE_COLL_ACCOUNT_dui T LEFT JOIN GMS_DEVICE_COLLECTINFO T1 ON T1.DEVICE_ID = T.DEVICE_ID "
				+ " WHERE T1.DEV_CODE LIKE '04%'  and t.project_info_id = '"
				+ projectInfoNo
				+ "'  GROUP BY T.DEV_MODEL "
				+ " ) tab order by tab.numorder ";
		System.out.println("sql == " + sql);
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql);
		// 根据team的数量，分别取查找team的设备配备信息
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:99.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("设备名称");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("总量");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("规格型号");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("计量单位");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("数量");

		if (CollectionUtils.isNotEmpty(list)) {
			for (int i = 0; i < list.size(); i++) {
				String classodd = null;
				String classeven = null;
				Map map = list.get(i);
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				// 要合并的行数
				String rsize = map.get("rsize").toString();
				// 设备名称
				String dev_name = map.get("dev_name").toString();
				// 总量
				String snum = map.get("snum").toString();
				// 规格型号
				String dev_model = map.get("dev_model").toString();
				// 计量单位
				String dev_unit = map.get("dev_unit").toString();
				// 数量
				String numb = map.get("numb").toString();
				if (i == 0) {
					// 生成几个的列信息
					Element contenttr = root.addElement("tr");
					Element contenttd1 = contenttr.addElement("td");
					contenttd1.addAttribute("rowspan", rsize + "");
					contenttd1.addText(dev_name);
					contenttd1.addAttribute("class", classodd);
					Element contenttd2 = contenttr.addElement("td");
					contenttd2.addAttribute("rowspan", rsize + "");
					contenttd2.addText(snum);
					contenttd2.addAttribute("class", classeven);
					Element contenttd3 = contenttr.addElement("td");
					contenttd3.addText(dev_model);
					contenttd3.addAttribute("class", classodd);
					Element contenttd4 = contenttr.addElement("td");
					contenttd4.addText(dev_unit);
					contenttd4.addAttribute("class", classeven);
					Element contenttd5 = contenttr.addElement("td");
					contenttd5.addText(numb);
					contenttd5.addAttribute("class", classodd);
				}
				if (i > 0) {
					Map pmap = list.get(i - 1);
					if (dev_name.equals(pmap.get("dev_name").toString())) {
						Element contenttr = root.addElement("tr");
						Element contenttd3 = contenttr.addElement("td");
						contenttd3.addText(dev_model);
						contenttd3.addAttribute("class", classodd);
						Element contenttd4 = contenttr.addElement("td");
						contenttd4.addText(dev_unit);
						contenttd4.addAttribute("class", classeven);
						Element contenttd5 = contenttr.addElement("td");
						contenttd5.addText(numb);
						contenttd5.addAttribute("class", classodd);
					} else {
						// 生成几个的列信息
						Element contenttr = root.addElement("tr");
						Element contenttd1 = contenttr.addElement("td");
						contenttd1.addAttribute("rowspan", rsize + "");
						contenttd1.addText(dev_name);
						contenttd1.addAttribute("class", classodd);
						Element contenttd2 = contenttr.addElement("td");
						contenttd2.addAttribute("rowspan", rsize + "");
						contenttd2.addText(snum);
						contenttd2.addAttribute("class", classeven);
						Element contenttd3 = contenttr.addElement("td");
						contenttd3.addText(dev_model);
						contenttd3.addAttribute("class", classodd);
						Element contenttd4 = contenttr.addElement("td");
						contenttd4.addText(dev_unit);
						contenttd4.addAttribute("class", classeven);
						Element contenttd5 = contenttr.addElement("td");
						contenttd5.addText(numb);
						contenttd5.addAttribute("class", classodd);
					}
				}
			}
		}
		String dataXML = root.asXML();
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 震源设备统计
	 */
	public ISrvMsg getZyStatistics(ISrvMsg reqDTO) throws Exception {
		// "project_info_id="+project_info_id+"&startDate="+startDate+"&endDate="+endDate+"&dev_coding="+self_num
		// self_num=<%=self_num%>
		// &project_info_id=<%=project_info_id%>&
		// start_date=<%=start_date%>&end_date=<%=end_date%>");
		String project_info_id = reqDTO.getValue("project_info_id");
		String devSql = "";

		String self_num = reqDTO.getValue("self_num");
		String start_date = reqDTO.getValue("start_date");
		String end_date = reqDTO.getValue("end_date");
		// 帅选符合条件的项目
		String selectProjectSql = "select t.project_info_no"
				+ "     from    gp_task_project t, gp_task_project_dynamic t2"
				+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
		if (null != project_info_id && (!"".equals(project_info_id))) {
			selectProjectSql += "     and  t.project_info_no='"
					+ project_info_id + "'";
		}
		if (null != start_date && (!"".equals(start_date))) {
			selectProjectSql += "   and  t.acquire_end_time>=to_date('"
					+ start_date + "','yyyy-mm-dd')";
		}
		if (null != end_date && (!"".equals(end_date))) {
			selectProjectSql += "   and  t.acquire_end_time<=to_date('"
					+ end_date + "','yyyy-mm-dd')";
		}

		if (null != self_num && (!"".equals(self_num))) {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
					+ selectProjectSql
					+ ")"
					+ "   and  d.self_num ='"
					+ self_num + "'";
		} else {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
					+ selectProjectSql + ")";
		}

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();

		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		List<Map> listMap = dao
				.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
		for (int i = 0; i < listMap.size(); i++) {
			Map map = listMap.get(i);
			String element = map.get("coding_code_id").toString() + "~"
					+ map.get("coding_name");
			equipmentList.add(element);

		}

		String preSql = " select sum(realnum) as realnum , coding_code_id"
				+ "  from (select (m.use_num) as realnum, coding_code_id"
				+ "   from gms_device_zy_wxbymat m  left join gms_mat_recyclemat_info r    on r.wz_id = m.wz_id "
				+ "  where     r.wz_type = '3'   and r.bsflag = 0  and r.project_info_id is not null    and   m.usemat_id in"
				+ "  (select x.usemat_id"
				+ "     from gms_device_zy_bywx x"
				+ "   where  x.bsflag='0'  and  x.project_info_id =r.project_info_id  and   x.project_info_id ='"
				+ project_info_id + "'   and    x.dev_acc_id in (" + devSql
				+ "))" + "   and m.coding_code_id = '@'" + "   ) a"
				+ " group by coding_code_id";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "备件数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZySingleWzCountDetail-"
						+ project_info_id + "~" + self_num + "~" + start_date
						+ "~" + end_date + "~" + equipmentCode);

			} else {
				equipmentNum = "0";
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZySingleWzCountDetail-"
						+ project_info_id + "~" + self_num + "~" + start_date
						+ "~" + end_date + "~" + equipmentCode);
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 震源设备金额统计
	 */
	public ISrvMsg getZyMStatistics(ISrvMsg reqDTO) throws Exception {

		// String projectInfoNo = reqDTO.getValue("projectInfoNo");
		// 项目编码字符串","
		String userOrgId = reqDTO.getUserToken().getOrgId();
		String project_info_id = reqDTO.getValue("project_info_id");
		String dev_coding = reqDTO.getValue("dev_coding");
		String startDate = reqDTO.getValue("start_date");
		if (startDate == null || "".equals(startDate)) {
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm");
			startDate = sf.format(new Date()) + "-01";
		}
		String endDate = reqDTO.getValue("end_date");
		if (endDate == null || "".equals(endDate)) {
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm-dd");
			endDate = sf.format(new Date());
		}
		// 多个项目编号 in
		String idsSql = "";
		// 帅选设备
		String devSql = "";
		String bywxSql = "";
		String selectedProjectSql = "select  distinct  t.project_info_no,t.project_name"
				+ "    from gp_task_project t, gp_task_project_dynamic t2"
				+ "    where t.project_info_no = t2.project_info_no and t.bsflag='0' ";
		// 1.柱状图横坐标显示项目
		// 项目编号为空显示所有项目
		// 项目编号不为空是显示选择的项目名称
		// 保存项目的LIST
		boolean isfilterDate = true;
		if (null != project_info_id && (!"".equals(project_info_id))) {
			isfilterDate = false;
			String[] ids = project_info_id.split(",");

			for (int i = 0; i < ids.length; i++) {
				idsSql += "'" + ids[i] + "',";
			}
			idsSql = idsSql.substring(0, idsSql.lastIndexOf(","));
			selectedProjectSql += "  and  t.project_info_no in (" + idsSql
					+ ")";
			// 筛选在一定时间段内正在运行的项目
			if (null != startDate && (!"".equals(startDate))) {
				selectedProjectSql += "  and  t.acquire_end_time>to_date('"
						+ startDate + "','yyyy-mm-dd') ";
			}

			if (null != endDate && (!"".equals(endDate))) {
				selectedProjectSql += "and t.acquire_end_time<= to_date('"
						+ endDate + "','yyyy-mm-dd')";
			}
		}
		if (isfilterDate) {
			// 筛选在一定时间段内正在运行的项目
			if (null != startDate && (!"".equals(startDate))) {
				selectedProjectSql += "  and  t.acquire_end_time>to_date('"
						+ startDate + "','yyyy-mm-dd') ";
			}

			if (null != endDate && (!"".equals(endDate))) {
				selectedProjectSql += "and t.acquire_end_time<= to_date('"
						+ endDate + "','yyyy-mm-dd')";
			}
		}
		List<String> projectList = new ArrayList<String>();
		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		List<Map> listMap = dao.queryRecords(selectedProjectSql);
		if (null != listMap) {
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				Object info_no = map.get("project_info_no");
				Object name = map.get("project_name");
				if (null != info_no && null != name) {
					String id = info_no.toString();
					String project_name = name.toString();
					String element = id + "~" + project_name;
					projectList.add(element);
				}

			}
		}

		// 前台手动选择震源编号
		if (null != dev_coding && (!"".equals(dev_coding))) {
			devSql = "select  d.project_info_id from gms_device_account_dui d where d.self_num = '"
					+ dev_coding + "'";
		} else {
			devSql = "select  d.project_info_id from gms_device_account_dui d";
		}
		selectedProjectSql += "   and t.project_info_no  in ( " + devSql + ")";
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String preSql = "";
		if (null != dev_coding && (!"".equals(dev_coding))) {

			preSql = "   select sum(m.use_num*n.actual_price) as realnum"
					+ "  from gms_device_zy_wxbymat m ,gms_mat_recyclemat_info n"
					+ "  where usemat_id in (select usemat_id from gms_device_zy_bywx t where  t.project_info_id=n.project_info_id  and  t.project_info_id='@' and t.dev_acc_id   in (select dev_acc_id from gms_device_account_dui  where self_num='"
					+ dev_coding
					+ "' )) and m.wz_id=n.wz_id and n.wz_type='3' and n.project_info_id is not null  and n.bsflag='0'  ";
		} else {
			preSql = "   select sum(m.use_num*n.actual_price) as realnum"
					+ "  from gms_device_zy_wxbymat m ,gms_mat_recyclemat_info n"
					+ "  where  n.wz_type='3'  and n.bsflag='0' and   n.project_info_id is not null and  usemat_id in (select usemat_id from gms_device_zy_bywx t where   t.project_info_id=n.project_info_id  and  t.project_info_id='@' ) and m.wz_id=n.wz_id";
		}

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "备件消耗金额（元）");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "12000");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < projectList.size(); i++) {
			String value = (String) projectList.get(i);
			String[] strArray = value.split("~");
			String projectCode = strArray[0];
			String projectName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", projectName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZySingleWzXhM-" + projectCode
						+ "~" + dev_coding + "~" + startDate + "~" + endDate);

			} else {
				equipmentNum = "0";
				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", projectName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZySingleWzXhM-" + projectCode
						+ "~" + dev_coding + "~" + startDate + "~" + endDate);
			}
		}
		String dataXML = document.asXML();

		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/**
	 * 部件类型
	 * 
	 * @param reqDTO
	 * @return
	 * @throws SOAPException
	 */
	public ISrvMsg getZyAllParts(ISrvMsg reqDTO) throws SOAPException {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		List<Map> listMap = dao
				.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
		responseMsg.setValue("datas", listMap);
		return responseMsg;

	}

	public ISrvMsg getZySortDetail(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String self_num = reqDTO.getValue("self_num");
		String work_hours = reqDTO.getValue("work_hours");
		String s_work_hours_max = reqDTO.getValue("s_work_hours_max");
		String coding_code_id = reqDTO.getValue("coding_code_id");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd0 = titletr.addElement("td");
		titletd0.addAttribute("class", "bt_info_odd");
		titletd0.addText("序号");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_even");
		titletd1.addText("日期");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_odd");
		titletd2.addText("自编号");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_even");
		titletd3.addText("累计工作小时");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_odd");
		titletd4.addText("故障现象");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_even");
		titletd5.addText("故障原因以及解决办法");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_odd");
		titletd6.addText("更换主要备件");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_even");
		titletd7.addText("性能描述");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_odd");
		titletd8.addText("承修单位");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_even");
		titletd9.addText("主修人");
		// Element titletd10 = titletr.addElement("td");
		// titletd10.addAttribute("class", "bt_info_odd");
		// titletd10.addText("油耗累计(升)");
		// Element titletd11 = titletr.addElement("td");
		// titletd11.addAttribute("class", "bt_info_even");
		// titletd11.addText("工作小时累计");
		// Element titletd12 = titletr.addElement("td");
		// titletd12.addAttribute("class", "bt_info_odd");
		// titletd12.addText("钻井进尺累计");
		// Element titletd13 = titletr.addElement("td");
		// titletd13.addAttribute("class", "bt_info_even");
		// titletd13.addText("行驶里程累计");
		// Element titletd14 = titletr.addElement("td");
		// titletd14.addAttribute("class", "bt_info_odd");
		// titletd14.addText("单位油耗");
		StringBuffer selectSql = new StringBuffer();

		selectSql
				.append("select  b.self_num,c.wz_id,d.wz_name, a.*  from gms_device_zy_bywx a ,")
				.append("gms_device_account_dui b,")
				.append("gms_device_zy_wxbymat c ,gms_mat_infomation d  where a.dev_acc_id=b.dev_acc_id and c.usemat_id=a.usemat_id and d.wz_id=c.wz_id");

		if (!"".equals(work_hours)) {
			selectSql.append("  and a.work_hours>=" + work_hours);
		}
		if (!"".equals(s_work_hours_max)) {
			selectSql.append("  and a.work_hours<=" + s_work_hours_max);
		}

		if (!"".equals(self_num)) {
			selectSql
					.append("   and  a.dev_acc_id in (select dev_acc_id from gms_device_account_dui where self_num='"
							+ self_num + "')");
		}
		if (!"".equals(coding_code_id)) {
			selectSql.append("  and   c.coding_code_id='" + coding_code_id
					+ "'");
		}
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null, muddle_td = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				muddle_td = "muddle_td";
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd0 = contenttr.addElement("td");
				contenttd0.addAttribute("class", classodd);
				contenttd0.addText(showinfo + "");

				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classeven);
				contenttd1.addText(tempMap.get("bywx_date").toString());

				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classodd);
				contenttd2.addText(tempMap.get("self_num").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classeven);
				contenttd3.addText(tempMap.get("work_hours").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classodd);
				contenttd4.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd4.addText(tempMap.get("falut_desc").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classeven);
				contenttd5.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd5.addText(tempMap.get("falut_case").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classodd);
				contenttd6.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd6.addText(tempMap.get("wz_name").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classeven);
				contenttd7.addText(tempMap.get("performance_desc").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classodd);
				contenttd8.addText(tempMap.get("repair_unit").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classeven);
				contenttd9.addText(tempMap.get("repair_men").toString());
				// Element contenttd10 = contenttr.addElement("td");
				// contenttd10.addAttribute("class", classodd);
				// contenttd10.addText(tempMap.get("oilnum").toString());
				// Element contenttd11 = contenttr.addElement("td");
				// contenttd11.addAttribute("class", classeven);
				// contenttd11.addText(tempMap.get("workhour").toString());
				// Element contenttd12 = contenttr.addElement("td");
				// contenttd12.addAttribute("class", classodd);
				// contenttd12.addText(tempMap.get("drillingfootage").toString());
				// Element contenttd13 = contenttr.addElement("td");
				// contenttd13.addAttribute("class", classeven);
				// contenttd13.addText(tempMap.get("mileage").toString());
				// Element contenttd14 = contenttr.addElement("td");
				// contenttd14.addAttribute("class", classodd);
				// contenttd14.addText(tempMap.get("dwyh").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 震源单台设备统计
	 */
	public ISrvMsg getZySortDetailStatistics(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String self_num = reqDTO.getValue("self_num");
		String work_hours = reqDTO.getValue("work_hours");
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String s_work_hours_max = reqDTO.getValue("s_work_hours_max");
		String real_dev_acc_id = reqDTO.getValue("real_dev_acc_id");

		IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
		String sqlCodingName = "select  coding_name from comm_coding_sort_detail where coding_sort_id='5110000188' and coding_code_id='"
				+ coding_code_id + "'";
		Map map = jdbc.queryRecordBySQL(sqlCodingName);
		String coding_name = map.get("coding_name").toString();
		String devSql = "";
		String bywxSql = "";
		boolean isAdd = false;
		if (null != self_num && (!"".equals(self_num))) {
			devSql = "select dev_acc_id from gms_device_account_dui t where t.self_num= '"
					+ self_num + "'";
		} else {
			devSql = "select dev_acc_id from gms_device_account_dui t where 1!=1";
		}
		if (null != work_hours && (!"".equals(work_hours))) {
			bywxSql = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w,gms_mat_recyclemat_info r  where m.dev_acc_id in ("
					+ devSql
					+ ")  and  m.project_info_id=r.project_info_id   and   m.project_info_id is not null and   r.project_info_id is not null  and   m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'  and    r.wz_id=w.wz_id and   m.usemat_id = w.usemat_id and w.coding_code_id='"
					+ coding_code_id
					+ "' and to_number(m.work_hours)>="
					+ work_hours;
			isAdd = true;
		} else {
			bywxSql = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w ,  gms_mat_recyclemat_info r where m.dev_acc_id in ("
					+ devSql
					+ ")  and  m.project_info_id=r.project_info_id   and    m.project_info_id is not null and   r.project_info_id is not null  and       m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'   and  r.wz_id=w.wz_id   and    m.usemat_id = w.usemat_id and w.coding_code_id='"
					+ coding_code_id + "'";

			isAdd = true;
		}
		if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
			bywxSql += "    and  to_number(m.work_hours)<=" + s_work_hours_max;
			isAdd = true;
		}
		if (isAdd) {
			bywxSql += "  group by m.work_hours   order  by work_hours";
		}
		String bywxNew = "(" + bywxSql + ")  a";

		String preSql1 = "select  work_hours , realnum   from  " + bywxNew;

		String devSql2 = "";
		String bywxSql2 = "";

		boolean isAdd2 = false;
		if (null != self_num && (!"".equals(self_num))) {
			devSql2 = "select dev_acc_id from gms_device_account t where t.self_num= '"
					+ self_num
					+ "'  and t.dev_acc_id='"
					+ real_dev_acc_id
					+ "'";
		} else {
			devSql2 = "select dev_acc_id from gms_device_account t where 1!=1";
		}
		if (null != work_hours && (!"".equals(work_hours))) {
			bywxSql2 = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w, gms_mat_recyclemat_info  r  where m.dev_acc_id in ("
					+ devSql2
					+ ")  and      m.project_info_id is   null and   r.project_info_id is   null  and     m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'  and  r.wz_id=w.wz_id  and   m.usemat_id = w.usemat_id and w.coding_code_id='"
					+ coding_code_id
					+ "' and to_number(m.work_hours)>="
					+ work_hours;
			isAdd2 = true;
		} else {
			bywxSql2 = "select   m.work_hours , sum(w.use_num) as  realnum  from   gms_device_zy_bywx m, gms_device_zy_wxbymat w   , gms_mat_recyclemat_info  r where m.dev_acc_id in ("
					+ devSql2
					+ ")  and     m.project_info_id is   null and   r.project_info_id is null  and  m.bsflag='0'  and  r.wz_type='3'  and r.bsflag='0'  and  r.wz_id=w.wz_id  and  m.usemat_id = w.usemat_id    and m.bsflag='0'   and w.coding_code_id='"
					+ coding_code_id + "'";

			isAdd2 = true;
		}
		if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
			bywxSql2 += "    and  to_number(m.work_hours)<=" + s_work_hours_max;
			isAdd2 = true;
		}
		if (isAdd2) {
			bywxSql2 += "  group by m.work_hours   order  by work_hours";
		}
		String bywxNew2 = "(" + bywxSql2 + ")  b";

		String preSql2 = "select  work_hours , realnum   from  " + bywxNew2;

		String table = "(   " + preSql1 + "    union all    " + preSql2
				+ ") devTable  where  devTable.work_hours='#' ";
		String bigTable = "select   sum(realnum) as  realnum  from " + table
				+ "  group by  work_hours  order  by work_hours ";

		IPureJdbcDao timeDao = BeanFactory.getPureJdbcDAO();
		List<Map> mapTimes = timeDao.queryRecords(bywxSql);
		IPureJdbcDao timeDao2 = BeanFactory.getPureJdbcDAO();
		List<Map> mapTimes2 = timeDao2.queryRecords(bywxSql2);
		Set<Integer> timeSet = new HashSet<Integer>();
		for (Map m : mapTimes) {
			timeSet.add(Integer.parseInt(m.get("work_hours").toString()));
		}
		for (Map m2 : mapTimes2) {
			timeSet.add(Integer.parseInt(m2.get("work_hours").toString()));
		}
		List<Integer> timeList = new ArrayList<Integer>(timeSet);
		Collections.sort(timeList);

		List<String> equipmentList = new ArrayList<String>();
		// if ((null != coding_code_id && (!"".equals(coding_code_id)))
		// && (null != coding_name && (!"".equals(coding_name)))) {
		// if (null != mapTimes) {
		// for (int i = 0; i < mapTimes.size(); i++) {
		// Map mapTime = mapTimes.get(i);
		// equipmentList.add(coding_code_id + "~"
		// + mapTime.get("work_hours").toString());
		// }
		// }
		//
		// }
		// if ((null != coding_code_id && (!"".equals(coding_code_id)))
		// && (null != coding_name && (!"".equals(coding_name)))) {
		// if (null != mapTimes2) {
		// for (int i = 0; i < mapTimes2.size(); i++) {
		// Map mapTime = mapTimes2.get(i);
		// equipmentList.add(coding_code_id + "~"
		// + mapTime.get("work_hours").toString());
		// }
		// }
		//
		// }

		if ((null != coding_code_id && (!"".equals(coding_code_id)))
				&& (null != coding_name && (!"".equals(coding_name)))) {
			if (null != timeList) {
				for (int i = 0; i < timeList.size(); i++) {
					Integer time = timeList.get(i);
					System.out.println(time);
					equipmentList.add(coding_code_id + "~" + time.toString());
				}
			}

		}

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("yAxisName", "备件消耗数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "12000");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");

		Iterator<String> iter = equipmentList.iterator();
		while (iter.hasNext()) {
			String value = iter.next();
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(bigTable);
			presqli = presqli.replaceAll("#", strArray[1]);
			selectSql.append(presqli);
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");
				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("link", "j-popSureSelfNumDetail-" + self_num
						+ "~" + equipmentName + "~" + work_hours + "~"
						+ s_work_hours_max + "~" + coding_code_id + "~"
						+ real_dev_acc_id);
				set.addAttribute("value", equipmentNum);

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	public ISrvMsg getMZySortDetail(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String self_num = reqDTO.getValue("self_num");
		String work_hours = reqDTO.getValue("work_hours");
		String s_work_hours_max = reqDTO.getValue("s_work_hours_max");
		String coding_code_id = reqDTO.getValue("coding_code_id");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd0 = titletr.addElement("td");
		titletd0.addAttribute("class", "bt_info_odd");
		titletd0.addText("选择");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_even");
		titletd1.addText("日期");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_odd");
		titletd2.addText("自编号");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_even");
		titletd3.addText("累计工作小时");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_odd");
		titletd4.addText("故障现象");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_even");
		titletd5.addText("故障原因以及解决办法");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_odd");
		titletd6.addText("更换主要备件");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_even");
		titletd7.addText("性能描述");
		Element titletd8 = titletr.addElement("td");
		titletd8.addAttribute("class", "bt_info_odd");
		titletd8.addText("承修单位");
		Element titletd9 = titletr.addElement("td");
		titletd9.addAttribute("class", "bt_info_even");
		titletd9.addText("主修人");
		StringBuffer selectSql = new StringBuffer();

		selectSql
				.append("select  b.self_num,c.wz_id,d.wz_name, a.*  from gms_device_zy_bywx a ,")
				.append("gms_device_account_dui b,")
				.append("gms_device_zy_wxbymat c ,gms_mat_infomation d  where a.dev_acc_id=b.dev_acc_id and c.usemat_id=a.usemat_id and d.wz_id=c.wz_id");

		if (!"".equals(work_hours)) {
			selectSql.append("  and a.work_hours>=" + work_hours);
		}
		if (!"".equals(s_work_hours_max)) {
			selectSql.append("  and a.work_hours<=" + s_work_hours_max);
		}

		if (!"".equals(self_num)) {
			selectSql
					.append("   and  a.dev_acc_id in (select dev_acc_id from gms_device_account_dui where self_num='"
							+ self_num + "')");
		}
		if (!"".equals(coding_code_id)) {
			selectSql.append("  and   c.coding_code_id='" + coding_code_id
					+ "'");
		}
		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(selectSql.toString());
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null, muddle_td = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				muddle_td = "muddle_td";
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd0 = contenttr.addElement("td");
				contenttd0.addAttribute("class", classodd);
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classeven);
				contenttd1.addText(tempMap.get("bywx_date").toString());

				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classodd);
				contenttd2.addText(tempMap.get("self_num").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classeven);
				contenttd3.addText(tempMap.get("work_hours").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classodd);
				contenttd4.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd4.addText(tempMap.get("falut_desc").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classeven);
				contenttd5.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd5.addText(tempMap.get("falut_case").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classodd);
				contenttd6.addAttribute("style",
						"{width:85px;overflow:hidden;text-overflow:ellipsis;}");
				contenttd6.addText(tempMap.get("wz_name").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classeven);
				contenttd7.addText(tempMap.get("performance_desc").toString());
				Element contenttd8 = contenttr.addElement("td");
				contenttd8.addAttribute("class", classodd);
				contenttd8.addText(tempMap.get("repair_unit").toString());
				Element contenttd9 = contenttr.addElement("td");
				contenttd9.addAttribute("class", classeven);
				contenttd9.addText(tempMap.get("repair_men").toString());
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 震源多台设备统计
	 */
	public ISrvMsg getMZySortDetailStatistics(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		// 自编号字符串" ,,,"
		String self_num = reqDTO.getValue("self_num");
		// 保养开始时间
		String work_hours = reqDTO.getValue("work_hours");
		// 部件编码
		String coding_code_id = reqDTO.getValue("coding_code_id");
		// 保养结束时间
		String s_work_hours_max = reqDTO.getValue("s_work_hours_max");
		Set<String> equipmentList = new HashSet<String>();
		IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
		String sqlCodingName = "select  coding_name from comm_coding_sort_detail where coding_sort_id='5110000188' and coding_code_id='"
				+ coding_code_id + "'";
		Map map = jdbc.queryRecordBySQL(sqlCodingName);

		String devSql = "";
		String bywxSql = "";

		String[] self_nums = self_num.split(",");
		String self_numsSql = "";

		for (int i = 0; i < self_nums.length; i++) {
			self_numsSql += "'" + self_nums[i] + "',";
			equipmentList.add(coding_code_id + "~" + self_nums[i]);
		}
		self_numsSql = self_numsSql.substring(0, self_numsSql.lastIndexOf(","));

		devSql = "select dev_acc_id from gms_device_account_dui t where t.self_num in ("
				+ self_numsSql + ")";
		// 保养开始日期
		if (null != work_hours && (!"".equals(work_hours))) {
			bywxSql = "select   m.usemat_id      from   gms_device_zy_bywx m where  m.bsflag='0'    and    m.project_info_id is not  null and     m.dev_acc_id in ("
					+ devSql
					+ ") and m.bywx_date>=to_date('"
					+ work_hours
					+ "', 'yyyy-mm-dd')";
		} else {
			bywxSql = "select   m.usemat_id      from   gms_device_zy_bywx m where   m.bsflag='0' and   m.dev_acc_id in ("
					+ devSql + ")";
		}
		// 保养结束日期
		if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
			bywxSql += "    and   m.bywx_date<=to_date('" + s_work_hours_max
					+ "' ,'yyyy-mm-dd')";
		}

		String preSql = "select sum(use_num) as realnum  from gms_device_zy_wxbymat z left join gms_mat_recyclemat_info mat   on mat.wz_id=z.wz_id    where  mat.project_info_id is not null and   mat.wz_type='3'  and    mat.bsflag='0'  and   z.usemat_id in"
				+ "(select t.usemat_id  from gms_device_zy_bywx t  where  t.bsflag='0'  and   t.project_info_id=mat.project_info_id  and   t.dev_acc_id in  (select dev_acc_id"
				+ "    from   gms_device_account_dui d   where d.self_num = '#')) and z.coding_code_id='@' and usemat_id in ("
				+ bywxSql + ") ";

		String devSql1 = "select dev_acc_id from gms_device_account t where t.self_num in ("
				+ self_numsSql + ")";
		String bywxSql1;
		// 保养开始日期
		if (null != work_hours && (!"".equals(work_hours))) {
			bywxSql1 = "select   m.usemat_id      from   gms_device_zy_bywx m where m.bsflag='0'  and   m.project_info_id is null   and   m.dev_acc_id in ("
					+ devSql1
					+ ") and m.bywx_date>=to_date('"
					+ work_hours
					+ "', 'yyyy-mm-dd')";
		} else {
			bywxSql1 = "select   m.usemat_id      from   gms_device_zy_bywx m where   m.bsflag='0'  and   m.dev_acc_id in ("
					+ devSql1 + ")";
		}
		// 保养结束日期
		if (null != s_work_hours_max && (!"".equals(s_work_hours_max))) {
			bywxSql1 += "    and   m.bywx_date<=to_date('" + s_work_hours_max
					+ "' ,'yyyy-mm-dd')";
		}

		String preSql1 = "select sum(use_num) as realnum  from gms_device_zy_wxbymat z  left join  gms_mat_recyclemat_info r on z.wz_id=r.wz_id   where  r.project_info_id is null and   r.wz_type='3'  and  r.bsflag='0'  and   z.usemat_id in"
				+ "(select t.usemat_id  from gms_device_zy_bywx t  where   t.project_info_id is null  and   t.bsflag='0'  and   t.dev_acc_id in  (select dev_acc_id"
				+ "    from   gms_device_account d   where d.self_num = '#')) and z.coding_code_id='@' and usemat_id in ("
				+ bywxSql1 + ") ";

		String bigTable = "select sum(realnum) as realnum from (" + preSql
				+ "    union all  " + preSql1 + ") aa";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("yAxisName", "备件消耗数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "12000");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");

		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		Iterator<String> iter = equipmentList.iterator();
		while (iter.hasNext()) {
			String value = (String) iter.next();
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(bigTable);
			presqli = presqli.replaceAll("@", strArray[0]);
			presqli = presqli.replace("#", strArray[1]);
			selectSql.append(presqli);

			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-singleMatBywxDetail-"
						+ equipmentName + "~" + coding_code_id + "~"
						+ work_hours + "~" + s_work_hours_max);

			} else {
				equipmentNum = "0";
				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-singleMatBywxDetail-"
						+ equipmentName + "~" + coding_code_id + "~"
						+ work_hours + "~" + s_work_hours_max);
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 单台震源某个部件中的小部件明细
	 */
	public ISrvMsg getSingleMatBywxDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		// 自编号字符串
		String self_num = reqDTO.getValue("self_num");

		// 部件编码
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String bywx_begin_date = reqDTO.getValue("bywx_begin_date");
		String bywx_end_date = reqDTO.getValue("bywx_end_date");

		String searchSql = "select wz_id, sum(use_num) as realnum"
				+ " from (select m.wz_id, r.actual_price, m.use_num"
				+ "    from gms_device_zy_wxbymat   m,"
				+ "        gms_mat_recyclemat_info r,"
				+ "            gms_mat_infomation      i"
				+ "      where m.usemat_id in "
				+ "              (select o.usemat_id"
				+ "                 from gms_device_zy_bywx o"
				+ "                where r.project_info_id=o.project_info_id   and  o.project_info_id is not null  and  o.dev_acc_id in"
				+ "                      (select t.dev_acc_id"
				+ "                         from gms_device_account_dui t"
				+ "                         where t.self_num = '"
				+ self_num
				+ "') and o.bywx_date>=to_date('"
				+ bywx_begin_date
				+ "','yyyy-mm-dd') and o.bywx_date<=to_date('"
				+ bywx_end_date
				+ "','yyyy-mm-dd') and m.usemat_id=o.usemat_id)"
				+ "          and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "           and r.wz_id = m.wz_id"
				+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0'  and r.project_info_id  is not null ) a  where a.wz_id='@' "
				+ "  group by wz_id";

		String searchSql1 = "select wz_id, sum(use_num) as realnum"
				+ " from (select m.wz_id, r.actual_price, m.use_num"
				+ "    from gms_device_zy_wxbymat   m,"
				+ "        gms_mat_recyclemat_info r,"
				+ "            gms_mat_infomation      i"
				+ "      where m.usemat_id in "
				+ "              (select o.usemat_id"
				+ "                 from gms_device_zy_bywx o"
				+ "                where   o.project_info_id  is  null and  o.dev_acc_id in"
				+ "                      (select t.dev_acc_id"
				+ "                         from gms_device_account t"
				+ "                         where t.self_num = '"
				+ self_num
				+ "') and o.bywx_date>=to_date('"
				+ bywx_begin_date
				+ "','yyyy-mm-dd') and o.bywx_date<=to_date('"
				+ bywx_end_date
				+ "','yyyy-mm-dd') and m.usemat_id=o.usemat_id)"
				+ "          and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "           and r.wz_id = m.wz_id"
				+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0'  and r.project_info_id is null ) a  where a.wz_id='@' "
				+ "  group by wz_id";

		String bigTable = "select sum(realnum) as realnum  from (" + searchSql1
				+ "  union all  " + searchSql + ")  aa ";

		String x_nameSql = "select distinct i.wz_id, i.wz_name"
				+ "    from gms_mat_infomation   i ,gms_mat_recyclemat_info rr  "
				+ "     where i.wz_id=rr.wz_id and rr.wz_type='3' and rr.bsflag='0' and  rr.project_info_id is  not null  and   i.wz_id in("
				+ "          select wz_id"
				+ "             from (select m.wz_id"
				+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
				+ "              where m.usemat_id in"
				+ "                    (select o.usemat_id"
				+ "                      from gms_device_zy_bywx o"
				+ "                      where o.project_info_id =r.project_info_id   and  o.project_info_id is not null and  o.dev_acc_id in"
				+ "                            (select t.dev_acc_id"
				+ "                              from gms_device_account_dui t"
				+ "                             where t.self_num = '"
				+ self_num
				+ "'))"
				+ "                and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "                and r.wz_id = m.wz_id and r.wz_type='3' and r.bsflag='0'))";

		String x_nameSql1 = "select distinct i.wz_id, i.wz_name"
				+ "    from gms_mat_infomation   i ,gms_mat_recyclemat_info rr"
				+ "     where i.wz_id=rr.wz_id and rr.wz_type='3' and rr.bsflag='0'  and  rr.project_info_id is null   and   i.wz_id in("
				+ "          select wz_id"
				+ "             from (select m.wz_id"
				+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
				+ "              where m.usemat_id in"
				+ "                    (select o.usemat_id"
				+ "                      from gms_device_zy_bywx o"
				+ "                      where   o.project_info_id is null  and  o.dev_acc_id in"
				+ "                            (select t.dev_acc_id"
				+ "                              from gms_device_account t"
				+ "                             where t.self_num = '"
				+ self_num
				+ "'))"
				+ "                and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "                and r.wz_id = m.wz_id  and r.wz_type='3' and r.bsflag='0'))";

		IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
		// 存储横坐标
		List<Map> wzMapList = jdbc.queryRecords(x_nameSql);
		Set<String> wzList = new HashSet<String>();
		for (int i = 0; i < wzMapList.size(); i++) {
			wzList.add(wzMapList.get(i).get("wz_id") + "~"
					+ wzMapList.get(i).get("wz_name"));
		}

		IPureJdbcDao jdbc1 = BeanFactory.getPureJdbcDAO();
		// 存储横坐标
		List<Map> wzMapList1 = jdbc.queryRecords(x_nameSql1);

		for (int i = 0; i < wzMapList1.size(); i++) {
			wzList.add(wzMapList1.get(i).get("wz_id") + "~"
					+ wzMapList1.get(i).get("wz_name"));
		}

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("yAxisName", "备件消耗数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "12000");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");

		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		Iterator<String> iter = wzList.iterator();
		while (iter.hasNext()) {
			String value = (String) iter.next();
			String[] strArray = value.split("~");
			String wzCode = strArray[0];
			String wzName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(bigTable);
			presqli = presqli.replaceAll("@", strArray[0]);
			selectSql.append(presqli);

			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", wzName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popBjDetailTable-" + wzCode + "~"
						+ self_num + "~" + coding_code_id + "~" + wzName + "~"
						+ equipmentNum + "~" + bywx_begin_date + "~"
						+ bywx_end_date);

			} else {
				equipmentNum = "0";
				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", wzName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popBjDetailTable-" + wzCode + "~"
						+ self_num + "~" + coding_code_id + "~" + wzName + "~"
						+ "0" + "~" + bywx_begin_date + "~" + bywx_end_date);

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 单台某类型物资-单独部件明细
	 */
	public ISrvMsg getBjDetailForm(ISrvMsg reqDTO) throws Exception {
		String wz_id = reqDTO.getValue("wz_id");
		IPureJdbcDao wzjdbc = BeanFactory.getPureJdbcDAO();

		String wz_name = wzjdbc
				.queryRecordBySQL(
						"select  wz_name from gms_mat_infomation where  wz_id='"
								+ wz_id + "'").get("wz_name").toString();
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String self_num = reqDTO.getValue("self_num");
		String price = reqDTO.getValue("price");
		String bywx_beign_date = reqDTO.getValue("begin");
		String bywx_end_date = reqDTO.getValue("end");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("备件名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("单价");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("使用数量");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("消耗金额");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("消耗时间");

		String searchSql = "select '"
				+ wz_name
				+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
				+ "      from gms_device_zy_bywx      x,"
				+ "      gms_device_zy_wxbymat   w,"
				+ "       gms_mat_recyclemat_info i"
				+ "       where  x.project_info_id=i.project_info_id   and  x.project_info_id  is not null and i.project_info_id is not null and    i.wz_type='3'  and  i.bsflag='0'  and     x.dev_acc_id in (select t.dev_acc_id"
				+ "                   from gms_device_account_dui t"
				+ "                 where t.self_num = '"
				+ self_num
				+ "')"
				+ "       and x.usemat_id = w.usemat_id"
				+ "       and w.wz_id = '"
				+ wz_id
				+ "'"
				+ "       and w.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'"
				+ "       and x.bywx_date>=to_date('" + bywx_beign_date
				+ "','yyyy-mm-dd') and x.bywx_date<=to_date('" + bywx_end_date
				+ "','yyyy-mm-dd')";

		String searchSql2 = "select '"
				+ wz_name
				+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
				+ "      from gms_device_zy_bywx      x,"
				+ "      gms_device_zy_wxbymat   w,"
				+ "       gms_mat_recyclemat_info i"
				+ "       where  x.project_info_id is null  and  i.project_info_id is null and  i.wz_type='3'  and  i.bsflag='0'  and  x.dev_acc_id in (select t.dev_acc_id"
				+ "                   from gms_device_account t"
				+ "                 where t.self_num = '"
				+ self_num
				+ "')"
				+ "       and x.usemat_id = w.usemat_id"
				+ "       and w.wz_id = '"
				+ wz_id
				+ "'"
				+ "       and w.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'"
				+ "       and x.bywx_date>=to_date('" + bywx_beign_date
				+ "','yyyy-mm-dd') and x.bywx_date<=to_date('" + bywx_end_date
				+ "','yyyy-mm-dd')";

		String bigTable = "select * from  (" + searchSql + "   union all  "
				+ searchSql2 + ") aa";

		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(bigTable);
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("wz_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("actual_price").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("use_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("price").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("bywx_date").toString());

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 单台震源某个部件累计工作小时中的小部件明细
	 */
	// self_num='+self_num+"&work_hours="+work_hours+"
	// &work_hours_begin="+work_hours_begin+"&work_hours_end="+work_hours_end
	public ISrvMsg getWorkHoursMatBywxDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		// 自编号字符串
		String self_num = reqDTO.getValue("self_num");

		// 部件编码
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String work_hours_begin = reqDTO.getValue("work_hours_begin");
		String work_hours_end = reqDTO.getValue("work_hours_end");
		String work_hours = reqDTO.getValue("work_hours");
		String real_dev_acc_id = reqDTO.getValue("real_dev_acc_id");
		// String real_dev_acc_id=request.getParameter("real_dev_acc_id");

		String a = "select wz_id, sum(use_num) as realnum"
				+ " from (select m.wz_id, r.actual_price, m.use_num"
				+ "    from gms_device_zy_wxbymat   m,"
				+ "        gms_mat_recyclemat_info r,"
				+ "            gms_mat_infomation      i"
				+ "      where   m.usemat_id in "
				+ "              (select o.usemat_id"
				+ "                 from gms_device_zy_bywx o"
				+ "                where   o.project_info_id=r.project_info_id  and  o.project_info_id is not null and  o.bsflag='0'  and  o.dev_acc_id in"
				+ "                      (select t.dev_acc_id"
				+ "                         from gms_device_account_dui t"
				+ "                         where t.self_num = '" + self_num
				+ "') " + " and m.usemat_id=o.usemat_id";
		if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
			a += "   and  to_number(o.work_hours)>=" + work_hours_begin;
		}
		if (null != work_hours_end && (!"".equals(work_hours_end))) {
			a += "  and   to_number(o.work_hours)<=" + work_hours_end;
		}
		if (null != work_hours && (!"".equals(work_hours))) {
			a += "    and  o.work_hours='" + work_hours + "'";
		}
		a += " )";
		String b = "          and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "           and r.wz_id = m.wz_id"
				+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0' and r.project_info_id is not null ) a  where a.wz_id='@' "
				+ "  group by wz_id";

		String searchSql = a + b;

		String a1 = "select wz_id, sum(use_num) as realnum"
				+ " from (select m.wz_id, r.actual_price, m.use_num"
				+ "    from gms_device_zy_wxbymat   m,"
				+ "        gms_mat_recyclemat_info r,"
				+ "            gms_mat_infomation      i"
				+ "      where m.usemat_id in "
				+ "              (select o.usemat_id"
				+ "                 from gms_device_zy_bywx o"
				+ "                where  o.project_info_id is null  and  o.bsflag='0'  and  o.dev_acc_id in"
				+ "                      (select t.dev_acc_id"
				+ "                         from gms_device_account t"
				+ "                         where   t.dev_acc_id='"
				+ real_dev_acc_id + "' and   t.self_num = '" + self_num + "') "
				+ " and m.usemat_id=o.usemat_id";
		if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
			a1 += "   and  to_number(o.work_hours)>=" + work_hours_begin;
		}
		if (null != work_hours_end && (!"".equals(work_hours_end))) {
			a1 += "  and   to_number(o.work_hours)<=" + work_hours_end;
		}
		if (null != work_hours && (!"".equals(work_hours))) {
			a1 += "    and  o.work_hours='" + work_hours + "'";
		}
		a1 += " )";
		String b1 = "          and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "           and r.wz_id = m.wz_id"
				+ "           and m.wz_id = i.wz_id  and r.wz_type='3'  and r.bsflag = '0' and r.project_info_id is null  ) a  where a.wz_id='@' "
				+ "  group by wz_id";

		String searchSql1 = a1 + b1;

		String bigTable = "(" + searchSql + "  union all  " + searchSql1
				+ ")  aa ";
		String doSql = "select sum(realnum)  as realnum  from  " + bigTable
				+ " group by wz_id";

		String x_nameSql = "select distinct wz_id, wz_name"
				+ "    from gms_mat_infomation"
				+ "     where wz_id in("
				+ "          select wz_id"
				+ "             from (select m.wz_id"
				+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
				+ "              where m.usemat_id in"
				+ "                    (select o.usemat_id"
				+ "                      from gms_device_zy_bywx o"
				+ "                      where  o.project_info_id =r.project_info_id and  o.work_hours='"
				+ work_hours + "' and   o.dev_acc_id in"
				+ "                            (select t.dev_acc_id"
				+ "                              from gms_device_account_dui t"
				+ "                             where t.self_num = '"
				+ self_num + "'))" + "                and m.coding_code_id = '"
				+ coding_code_id + "'"
				+ "                and r.wz_id = m.wz_id ))";

		String x_nameSql1 = "select distinct wz_id, wz_name"
				+ "    from gms_mat_infomation"
				+ "     where wz_id in("
				+ "          select wz_id"
				+ "             from (select m.wz_id"
				+ "               from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
				+ "              where m.usemat_id in"
				+ "                    (select o.usemat_id"
				+ "                      from gms_device_zy_bywx o"
				+ "                      where  o.project_info_id is null  and  o.work_hours='"
				+ work_hours + "' and   o.dev_acc_id in"
				+ "                            (select t.dev_acc_id"
				+ "                              from gms_device_account t"
				+ "                             where   t.dev_acc_id='"
				+ real_dev_acc_id + "' and  t.self_num = '" + self_num + "'))"
				+ "                and m.coding_code_id = '" + coding_code_id
				+ "'" + "                and r.wz_id = m.wz_id ))";

		IPureJdbcDao jdbc = BeanFactory.getPureJdbcDAO();
		// 存储横坐标
		List<Map> wzMapList = jdbc.queryRecords(x_nameSql);

		List<String> wz = new ArrayList<String>();
		for (int i = 0; i < wzMapList.size(); i++) {
			wz.add(wzMapList.get(i).get("wz_id") + "~"
					+ wzMapList.get(i).get("wz_name"));
		}

		IPureJdbcDao jdbc1 = BeanFactory.getPureJdbcDAO();
		// 存储横坐标
		List<Map> wzMapList1 = jdbc.queryRecords(x_nameSql1);
		for (int i = 0; i < wzMapList1.size(); i++) {
			wz.add(wzMapList1.get(i).get("wz_id") + "~"
					+ wzMapList1.get(i).get("wz_name"));
		}
		Set<String> wzList = new HashSet<String>(wz);
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("yAxisName", "备件消耗数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "12000");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");

		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		Iterator<String> iter = wzList.iterator();
		while (iter.hasNext()) {
			String value = (String) iter.next();
			String[] strArray = value.split("~");
			String wzCode = strArray[0];
			String wzName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(doSql);
			presqli = presqli.replaceAll("@", strArray[0]);
			selectSql.append(presqli);

			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", wzName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popBjWorkHourDetailTable-"
						+ self_num + "~" + coding_code_id + "~" + work_hours
						+ "~" + work_hours_begin + "~" + work_hours_end + "~"
						+ wzCode + "~" + real_dev_acc_id);

			} else {
				equipmentNum = "0";
				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", wzName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popBjWorkHourDetailTable-"
						+ self_num + "~" + coding_code_id + "~" + work_hours
						+ "~" + work_hours_begin + "~" + work_hours_end + "~"
						+ wzCode + "~" + real_dev_acc_id);

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 单台某类型物资-累计工作小时单独部件明细
	 */
	public ISrvMsg getBjWorkHourDetailForm(ISrvMsg reqDTO) throws Exception {
		String wz_id = reqDTO.getValue("wz_id");
		IPureJdbcDao wzjdbc = BeanFactory.getPureJdbcDAO();
		String wz_name = wzjdbc
				.queryRecordBySQL(
						"select distinct  i.wz_name from gms_mat_infomation  i ,gms_mat_recyclemat_info r  where r.wz_id=i.wz_id and r.wz_type='3' and r.bsflag='0' and i.wz_id='"
								+ wz_id + "'").get("wz_name").toString();
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String self_num = reqDTO.getValue("self_num");
		String work_hours = reqDTO.getValue("work_hours");
		String work_hours_begin = reqDTO.getValue("begin");
		String work_hours_end = reqDTO.getValue("work_hours_end");
		String real_dev_acc_id = reqDTO.getValue("real_dev_acc_id");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("备件名称");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("单价");
		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("使用数量");
		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("消耗金额");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("消耗时间");

		String searchSql = "select '"
				+ wz_name
				+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
				+ "      from gms_device_zy_bywx      x,"
				+ "      gms_device_zy_wxbymat   w,"
				+ "       gms_mat_recyclemat_info i"
				+ "       where  i.project_info_id =x.project_info_id  and  i.project_info_id is not null and  x.project_info_id is not null and x.bsflag='0' and  x.dev_acc_id in (select t.dev_acc_id"
				+ "                   from gms_device_account_dui t"
				+ "                 where t.self_num = '"
				+ self_num
				+ "')"
				+ "       and x.usemat_id = w.usemat_id"
				+ "       and w.wz_id = '"
				+ wz_id
				+ "'"
				+ "       and w.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'";
		if (null != work_hours && (!"".equals(work_hours))) {
			searchSql += " and  x.work_hours='" + work_hours + "'";
		}

		if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
			searchSql += "   and  to_number(x.work_hours)>=" + work_hours_begin
					+ "   ";
		}
		if (null != work_hours_end && (!"".equals(work_hours_end))) {
			searchSql += "   and  to_number(x.work_hours)<=" + work_hours_end
					+ "   ";
		}

		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(searchSql);
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}

		String searchSql1 = "select '"
				+ wz_name
				+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price"
				+ "      from gms_device_zy_bywx      x,"
				+ "      gms_device_zy_wxbymat   w,"
				+ "       gms_mat_recyclemat_info i"
				+ "       where  i.project_info_id is  null and  x.project_info_id is  null and x.bsflag='0'    and  x.dev_acc_id in (select t.dev_acc_id"
				+ "                   from     gms_device_account t"
				+ "                 where   t.dev_acc_id='"
				+ real_dev_acc_id
				+ "'  and   t.self_num = '"
				+ self_num
				+ "')"
				+ "       and x.usemat_id = w.usemat_id"
				+ "       and w.wz_id = '"
				+ wz_id
				+ "'"
				+ "       and w.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.bsflag = '0'";
		if (null != work_hours && (!"".equals(work_hours))) {
			searchSql1 += " and  x.work_hours='" + work_hours + "'";
		}

		if (null != work_hours_begin && (!"".equals(work_hours_begin))) {
			searchSql1 += "   and  to_number(x.work_hours)>="
					+ work_hours_begin + "   ";
		}
		if (null != work_hours_end && (!"".equals(work_hours_end))) {
			searchSql1 += "   and  to_number(x.work_hours)<=" + work_hours_end
					+ "   ";
		}

		// 执行Sql
		IPureJdbcDao jdbcDAO1 = BeanFactory.getPureJdbcDAO();
		List<Map> resultList1 = null;
		try {
			resultList1 = jdbcDAO1.queryRecords(searchSql1);
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}

		resultList.addAll(resultList1);

		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("wz_name").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("actual_price").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("use_num").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("price").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("bywx_date").toString());

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 单项目备件大类消耗明细
	 */
	public ISrvMsg getZySingleWzXhM(ISrvMsg reqDTO) throws Exception {
		String project_info_id = reqDTO.getValue("project_info_id");
		String devSql = "";

		String self_num = reqDTO.getValue("self_num");
		String start_date = reqDTO.getValue("start_date");
		String end_date = reqDTO.getValue("end_date");
		// 帅选符合条件的项目
		String selectProjectSql = "select t.project_info_no"
				+ "     from    gp_task_project t, gp_task_project_dynamic t2"
				+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
		if (null != project_info_id && (!"".equals(project_info_id))) {
			selectProjectSql += "     and  t.project_info_no='"
					+ project_info_id + "'";
		}
		if (null != start_date && (!"".equals(start_date))) {
			selectProjectSql += "   and  t.acquire_end_time>=to_date('"
					+ start_date + "','yyyy-mm-dd')";
		}
		if (null != end_date && (!"".equals(end_date))) {
			selectProjectSql += "   and  t.acquire_end_time<=to_date('"
					+ end_date + "','yyyy-mm-dd')";
		}

		if (null != self_num && (!"".equals(self_num))
				&& (!"null".equals(self_num))) {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
					+ selectProjectSql
					+ ")"
					+ "   and  d.self_num ='"
					+ self_num + "'";
		} else {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
					+ selectProjectSql + ")";
		}

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();

		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		List<Map> listMap = dao
				.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
		for (int i = 0; i < listMap.size(); i++) {
			Map map = listMap.get(i);
			String element = map.get("coding_code_id").toString() + "~"
					+ map.get("coding_name");
			equipmentList.add(element);

		}

		String preSql = " select sum(realnum) as realnum , coding_code_id"
				+ "  from (select (m.use_num * r.actual_price) as realnum, coding_code_id"
				+ "   from gms_device_zy_wxbymat m, gms_mat_recyclemat_info r"
				+ "  where  r.bsflag='0'  and r.wz_type='3' and   r.project_info_id is not null  and  m.usemat_id in"
				+ "  (select x.usemat_id"
				+ "     from gms_device_zy_bywx x"
				+ "   where   x.project_info_id=r.project_info_id  and   x.bsflag='0'  and   x.project_info_id='"
				+ project_info_id + "'     and  x.dev_acc_id in (" + devSql
				+ "))" + "  and m.coding_code_id = '@'"
				+ "   and r.wz_id = m.wz_id) a" + " group by coding_code_id";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "消耗金额（元）");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZySingleWzM-" + project_info_id
						+ "~" + self_num + "~" + start_date + "~" + end_date
						+ "~" + equipmentCode);

			} else {
				equipmentNum = "0";
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZySingleWzM-" + project_info_id
						+ "~" + self_num + "~" + start_date + "~" + end_date
						+ "~" + equipmentCode);
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 单项目备件消耗明细
	 */
	public ISrvMsg getZySingleWzM(ISrvMsg reqDTO) throws Exception {
		String project_info_id = reqDTO.getValue("project_info_id");
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String devSql = "";

		String self_num = reqDTO.getValue("self_num");
		String start_date = reqDTO.getValue("start_date");
		String end_date = reqDTO.getValue("end_date");
		// 帅选符合条件的项目
		String selectProjectSql = "select t.project_info_no"
				+ "     from    gp_task_project t, gp_task_project_dynamic t2"
				+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
		if (null != project_info_id && (!"".equals(project_info_id))) {
			selectProjectSql += "     and  t.project_info_no='"
					+ project_info_id + "'";
		}
		if (null != start_date && (!"".equals(start_date))) {
			selectProjectSql += "   and  t.acquire_end_time>=to_date('"
					+ start_date + "','yyyy-mm-dd')";
		}
		if (null != end_date && (!"".equals(end_date))) {
			selectProjectSql += "   and  t.acquire_end_time<=to_date('"
					+ end_date + "','yyyy-mm-dd')";
		}

		if (null != self_num && (!"".equals(self_num))
				&& (!"null".equals(self_num))) {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
					+ selectProjectSql
					+ ")"
					+ "   and  d.self_num ='"
					+ self_num + "'";
		} else {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
					+ selectProjectSql + ")";
		}

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();

		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		String nameSql_x = "select distinct m.wz_id,r.wz_name"
				+ " from gms_device_zy_wxbymat m,"
				+ "   gms_mat_infomation r,gms_mat_recyclemat_info mat"
				+ " where  mat.wz_type='3'  and mat.bsflag='0'  and  mat.project_info_id is not null   and  m.usemat_id in"
				+ "     (select t.usemat_id"
				+ "       from gms_device_zy_bywx t"
				+ "      where  mat.project_info_id=t.project_info_id and  t.bsflag='0'  and   t.project_info_id='"
				+ project_info_id + "'  and  t.dev_acc_id in"
				+ "           (select dev_acc_id from gms_device_account_dui)"
				+ "  and t.project_info_id='" + project_info_id + "')"
				+ "   and m.coding_code_id = '" + coding_code_id + "'"
				+ "  and r.wz_id=m.wz_id and mat.wz_id=r.wz_id";
		List<Map> listMap = dao.queryRecords(nameSql_x);
		for (int i = 0; i < listMap.size(); i++) {
			Map map = listMap.get(i);
			String element = map.get("wz_id").toString() + "~"
					+ map.get("wz_name");
			equipmentList.add(element);

		}

		String preSql = "select  realnum from ( select m.wz_id, sum(m.use_num*r.actual_price) as realnum"
				+ " from gms_device_zy_wxbymat m,"
				+ "   gms_mat_recyclemat_info  r"
				+ " where   r.project_info_id is not null and    r.bsflag='0'  and r.wz_type='3'   and   m.usemat_id in"
				+ "      (select t.usemat_id"
				+ "        from gms_device_zy_bywx t"
				+ "     where   r.project_info_id=t.project_info_id   and   t.bsflag='0'  and  t.project_info_id='"
				+ project_info_id
				+ "'   and t.dev_acc_id in"
				+ "            ("
				+ devSql
				+ "))"
				+ "  and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ " and r.wz_id=m.wz_id and r.wz_type='3' and r.bsflag='0' "
				+ " group by m.wz_id) a where a.wz_id='@'";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "消耗金额（元）");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popWxbyHistoryBjCForm-" + self_num
						+ "~" + project_info_id + "~" + coding_code_id + "~"
						+ equipmentCode);

			} else {
				equipmentNum = "0";
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popWxbyHistoryBjCForm-" + self_num
						+ "~" + project_info_id + "~" + coding_code_id + "~"
						+ equipmentCode);
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	public ISrvMsg getZyAllProjectStatistics(ISrvMsg reqDTO) throws Exception {
		// project_info_id="+project_info_id+"&start_date="+start_date+"&end_date="+end_date+"&self_num="+self_num
		String project_info_id = reqDTO.getValue("project_info_id");
		String self_num = reqDTO.getValue("self_num");
		String startDate = reqDTO.getValue("start_date");
		if (startDate == null || "".equals(startDate)) {
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm");
			startDate = sf.format(new Date()) + "-01";
		}
		String endDate = reqDTO.getValue("end_date");
		if (endDate == null || "".equals(endDate)) {
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-mm-dd");
			endDate = sf.format(new Date());
		}
		// 多个项目编号 in
		String idsSql = "";
		// 帅选设备
		String devSql = "";
		String bywxSql = "";
		String selectedProjectSql = "select distinct  t.project_info_no,t.project_name"
				+ "    from gp_task_project t, gp_task_project_dynamic t2"
				+ "    where t.project_info_no = t2.project_info_no and t.bsflag='0' ";
		// 1.柱状图横坐标显示项目
		// 项目编号为空显示所有项目
		// 项目编号不为空是显示选择的项目名称
		// 保存项目的LIST
		boolean isFilterByDate = true;
		if (null != project_info_id && (!"".equals(project_info_id))) {
			isFilterByDate = false;
			String[] ids = project_info_id.split(",");

			for (int i = 0; i < ids.length; i++) {
				idsSql += "'" + ids[i] + "',";
			}
			idsSql = idsSql.substring(0, idsSql.lastIndexOf(","));
			selectedProjectSql += "  and  t.project_info_no in (" + idsSql
					+ ")";
			// 筛选在一定时间段内正在运行的项目
			if (null != startDate && (!"".equals(startDate))) {
				selectedProjectSql += "  and  t.acquire_end_time>to_date('"
						+ startDate + "','yyyy-mm-dd') ";
			}

			if (null != endDate && (!"".equals(endDate))) {
				selectedProjectSql += "and t.acquire_end_time<= to_date('"
						+ endDate + "','yyyy-mm-dd')";
			}
		}
		if (isFilterByDate) {

			// 筛选在一定时间段内正在运行的项目
			if (null != startDate && (!"".equals(startDate))) {
				selectedProjectSql += "  and  t.acquire_end_time>to_date('"
						+ startDate + "','yyyy-mm-dd') ";
			}

			if (null != endDate && (!"".equals(endDate))) {
				selectedProjectSql += "and t.acquire_end_time<= to_date('"
						+ endDate + "','yyyy-mm-dd')";
			}
		}
		List<String> projectList = new ArrayList<String>();
		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		List<Map> listMap = dao.queryRecords(selectedProjectSql);
		if (null != listMap) {
			for (int i = 0; i < listMap.size(); i++) {
				Map map = listMap.get(i);
				Object info_no = map.get("project_info_no");
				Object name = map.get("project_name");
				if (null != info_no && null != name) {
					String id = info_no.toString();
					String project_name = name.toString();
					String element = id + "~" + project_name;
					projectList.add(element);
				}

			}
		}

		// 前台手动选择震源编号
		if (null != self_num && (!"".equals(self_num))) {
			devSql = "select  d.project_info_id from gms_device_account_dui d where d.self_num = '"
					+ self_num + "'";
		} else {
			devSql = "select  d.project_info_id from gms_device_account_dui d";
		}
		// selectedProjectSql += "   and t.project_info_no  in ( " + devSql +
		// ")";
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String preSql = "";
		if (null != self_num && (!"".equals(self_num))) {
			preSql = "  select sum(m.use_num) as  realnum"
					+ "   from gms_device_zy_wxbymat m    left join  gms_mat_recyclemat_info  r on m.wz_id=r.wz_id "
					+ "   where usemat_id in (select usemat_id"
					+ "            from gms_device_zy_bywx t"
					+ "         where  r.project_info_id =t.project_info_id    and  t.project_info_id = '@' and t.dev_acc_id in (select dev_acc_id from gms_device_account_dui where self_num='"
					+ self_num
					+ "' )  and  r.wz_type='3'  and  r.bsflag='0'  and  r.project_info_id is not null ";
		} else {
			preSql = "  select sum(m.use_num) as  realnum"
					+ "   from gms_device_zy_wxbymat m   left join  gms_mat_recyclemat_info  r on m.wz_id=r.wz_id  "
					+ "   where usemat_id in (select usemat_id"
					+ "            from gms_device_zy_bywx t"
					+ "         where  t.project_info_id=r.project_info_id   and     t.project_info_id = '@')  and    r.wz_type='3'  and  r.bsflag='0'  and   r.project_info_id is not null ";
		}

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "备件数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "12000");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < projectList.size(); i++) {
			String value = (String) projectList.get(i);
			String[] strArray = value.split("~");
			String projectCode = strArray[0];
			String projectName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", projectName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popSingleProjectBjWxByCount-"
						+ projectCode + "~" + self_num + "~" + startDate + "~"
						+ endDate);

			} else {
				equipmentNum = "0";
				// 拼XML文档
				Element category = categories.addElement("category");
				category.addAttribute("label", projectName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popSingleProjectBjWxByCount-"
						+ projectCode + "~" + self_num + "~" + startDate + "~"
						+ endDate);
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 单项目备件数量消耗明细
	 */
	public ISrvMsg getZySingleWzC(ISrvMsg reqDTO) throws Exception {
		String project_info_id = reqDTO.getValue("project_info_id");
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String devSql = "";

		String self_num = reqDTO.getValue("self_num");
		String start_date = reqDTO.getValue("start_date");
		String end_date = reqDTO.getValue("end_date");
		// 帅选符合条件的项目
		String selectProjectSql = "select t.project_info_no"
				+ "     from    gp_task_project t, gp_task_project_dynamic t2"
				+ "     where t.project_info_no = t2.project_info_no and t.bsflag='0'";
		if (null != project_info_id && (!"".equals(project_info_id))) {
			selectProjectSql += "     and  t.project_info_no='"
					+ project_info_id + "'";
		}
		if (null != start_date && (!"".equals(start_date))) {
			selectProjectSql += "   and  t.acquire_end_time>=to_date('"
					+ start_date + "','yyyy-mm-dd')";
		}
		if (null != end_date && (!"".equals(end_date))) {
			selectProjectSql += "   and  t.acquire_end_time<=to_date('"
					+ end_date + "','yyyy-mm-dd')";
		}

		if (null != self_num && (!"".equals(self_num))) {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where  d.project_info_id  in ("
					+ selectProjectSql
					+ ")"
					+ "   and  d.self_num ='"
					+ self_num + "'";
		} else {
			devSql = "select  d.dev_acc_id from gms_device_account_dui d where d.project_info_id  in ("
					+ selectProjectSql + ")";
		}

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();

		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		String nameSql_x = "select distinct m.wz_id,r.wz_name"
				+ " from gms_device_zy_wxbymat m,"
				+ "   gms_mat_infomation r   ,   gms_mat_recyclemat_info mat"
				+ " where   mat.wz_type='3'  and  mat.bsflag='0' and  mat.project_info_id is not null   and  m.usemat_id in"
				+ "     (select t.usemat_id"
				+ "       from gms_device_zy_bywx t"
				+ "      where  mat.project_info_id=t.project_info_id  and  t.bsflag='0'  and   t.project_info_id='"
				+ project_info_id + "' and   t.dev_acc_id in"
				+ "           (select dev_acc_id from gms_device_account_dui))"
				+ "   and m.coding_code_id = '" + coding_code_id + "'"
				+ "  and r.wz_id=m.wz_id and r.wz_id=mat.wz_id";
		List<Map> listMap = dao.queryRecords(nameSql_x);
		for (int i = 0; i < listMap.size(); i++) {
			Map map = listMap.get(i);
			String element = map.get("wz_id").toString() + "~"
					+ map.get("wz_name");
			equipmentList.add(element);

		}

		String preSql = "select  realnum from ( select m.wz_id, sum(m.use_num) as realnum"
				+ " from gms_device_zy_wxbymat m left join  gms_mat_recyclemat_info r on m.wz_id=r.wz_id "
				+ "    where  r.wz_type='3' and r.bsflag='0'  and   r.project_info_id  is not null  and   m.usemat_id in"
				+ "      (select t.usemat_id"
				+ "        from gms_device_zy_bywx t"
				+ "     where   r.project_info_id=t.project_info_id  and  t.bsflag='0'   and   t.dev_acc_id in"
				+ "            ("
				+ devSql
				+ "))"
				+ "  and m.coding_code_id = '"
				+ coding_code_id
				+ "'"
				+ " group by m.wz_id) a where a.wz_id='@'";
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "消耗数量");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popWxbyHistoryBjCForm-" + self_num
						+ "~" + project_info_id + "~" + coding_code_id + "~"
						+ equipmentCode);
			} else {
				equipmentNum = "0";
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popWxbyHistoryBjCForm-" + self_num
						+ "~" + project_info_id + "~" + coding_code_id + "~"
						+ equipmentCode);

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	public ISrvMsg getWxbyHistoryBjCForm(ISrvMsg reqDTO) throws Exception {
		String wz_id = reqDTO.getValue("wz_id");
		IPureJdbcDao wzjdbc = BeanFactory.getPureJdbcDAO();
		String wz_name = wzjdbc
				.queryRecordBySQL(
						"select distinct  wz_name from  gms_mat_recyclemat_info r ,    gms_mat_infomation  m where   r.project_info_id is not null  and  r.wz_type='3' and r.bsflag='0'  and r.wz_id=m.wz_id  and  r.wz_id='"
								+ wz_id + "'").get("wz_name").toString();
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String self_num = reqDTO.getValue("self_num");
		String project_info_id = reqDTO.getValue("project_info_id");

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("table");
		root.addAttribute("class", "tab_info");
		root.addAttribute("border", "0");
		root.addAttribute("cellspacing", "0");
		root.addAttribute("cellpadding", "0");
		root.addAttribute("style", "width:96.8%");
		root.addAttribute("id", "queryRetTable");

		Element titletr = root.addElement("tr");
		Element titletd1 = titletr.addElement("td");
		titletd1.addAttribute("class", "bt_info_odd");
		titletd1.addText("序号");
		Element titletd2 = titletr.addElement("td");
		titletd2.addAttribute("class", "bt_info_even");
		titletd2.addText("震源编号");
		Element titletd3 = titletr.addElement("td");
		titletd3.addAttribute("class", "bt_info_odd");
		titletd3.addText("部件名称");

		Element titletd4 = titletr.addElement("td");
		titletd4.addAttribute("class", "bt_info_even");
		titletd4.addText("单价");

		Element titletd5 = titletr.addElement("td");
		titletd5.addAttribute("class", "bt_info_odd");
		titletd5.addText("使用数量");
		Element titletd6 = titletr.addElement("td");
		titletd6.addAttribute("class", "bt_info_even");
		titletd6.addText("消耗金额");
		Element titletd7 = titletr.addElement("td");
		titletd7.addAttribute("class", "bt_info_odd");
		titletd7.addText("消耗时间");
		String searchSql = "";
		if (null == self_num || "".equals(self_num) || "null".equals(self_num)) {
			searchSql = "select '"
					+ wz_name
					+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price, self_num"
					+ "      from gms_device_zy_bywx      x,"
					+ "      gms_device_zy_wxbymat   w,"
					+ "       gms_mat_recyclemat_info i,"
					+ "      gms_device_account_dui  d"
					+ "       where x.dev_acc_id in (select t.dev_acc_id"
					+ "                   from gms_device_account_dui t"
					+ "                 )"
					+ "       and x.usemat_id = w.usemat_id"
					+ "       and w.wz_id = '"
					+ wz_id
					+ "'"
					+ "       and w.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and i.project_info_id=x.project_info_id  and  i.project_info_id is not null   and i.bsflag = '0'"
					+ "       and    x.project_info_id='" + project_info_id
					+ "'"
					+ "    and  d.dev_acc_id=x.dev_acc_id  and x.bsflag='0'  ";

		} else {

			searchSql = "select '"
					+ wz_name
					+ "'  as  wz_name ,i.actual_price, w.use_num, x.bywx_date,(i.actual_price * w.use_num) as price  ,self_num"
					+ "      from gms_device_zy_bywx      x,"
					+ "      gms_device_zy_wxbymat   w,"
					+ "       gms_mat_recyclemat_info i,"
					+ "     gms_device_account_dui d"
					+ "       where x.dev_acc_id in (select t.dev_acc_id"
					+ "                   from gms_device_account_dui t"
					+ "                 where t.self_num = '"
					+ self_num
					+ "')"
					+ "       and x.usemat_id = w.usemat_id"
					+ "       and w.wz_id = '"
					+ wz_id
					+ "'"
					+ "       and w.coding_code_id = '"
					+ coding_code_id
					+ "'"
					+ "       and i.wz_id = w.wz_id  and i.wz_type='3'  and  i.project_info_id  is not null  and i.bsflag = '0'"
					+ "   and    x.project_info_id='" + project_info_id + "'"
					+ "   and d.dev_acc_id=x.dev_acc_id   and x.bsflag='0' ";
		}

		// 执行Sql
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try {
			resultList = jdbcDAO.queryRecords(searchSql);
		} catch (Exception e) {
			// message.append("表名或查询条件字段不存在!");
		}
		// 获取结果
		String equipmentNum = "";
		// 拼XML文档
		if (resultList != null) {
			for (int i = 0; i < resultList.size(); i++) {
				Map tempMap = resultList.get(i);
				String classodd = null, classeven = null;
				if (i % 2 == 0) {
					classodd = "odd_odd";
					classeven = "odd_even";
				} else {
					classodd = "even_odd";
					classeven = "even_even";
				}
				int showinfo = i + 1;
				Element contenttr = root.addElement("tr");
				Element contenttd1 = contenttr.addElement("td");
				contenttd1.addAttribute("class", classodd);
				contenttd1.addText(showinfo + "");
				Element contenttd2 = contenttr.addElement("td");
				contenttd2.addAttribute("class", classeven);
				contenttd2.addText(tempMap.get("self_num").toString());
				Element contenttd3 = contenttr.addElement("td");
				contenttd3.addAttribute("class", classodd);
				contenttd3.addText(tempMap.get("wz_name").toString());
				Element contenttd4 = contenttr.addElement("td");
				contenttd4.addAttribute("class", classeven);
				contenttd4.addText(tempMap.get("actual_price").toString());
				Element contenttd5 = contenttr.addElement("td");
				contenttd5.addAttribute("class", classodd);
				contenttd5.addText(tempMap.get("use_num").toString());
				Element contenttd6 = contenttr.addElement("td");
				contenttd6.addAttribute("class", classeven);
				contenttd6.addText(tempMap.get("price").toString());
				Element contenttd7 = contenttr.addElement("td");
				contenttd7.addAttribute("class", classodd);
				contenttd7.addText(tempMap.get("bywx_date").toString());

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<table");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	public ISrvMsg getZyBjUse(ISrvMsg reqDTO) throws Exception {

		// project_info_id="+project_info_id+"&start_date="+start_date+"&end_date="+end_date+
		String project_info_id = reqDTO.getValue("project_info_id");
		String innerIds = "";
		if (null != project_info_id && !"".equals(project_info_id)
				&& !"null".equals(project_info_id)) {
			project_info_id = project_info_id.substring(0,
					project_info_id.lastIndexOf(","));
			String[] ids = project_info_id.split(",");

			for (int i = 0; i < ids.length; i++) {
				innerIds += "'" + ids[i] + "' ,";
			}
			innerIds = innerIds.substring(0, innerIds.lastIndexOf(","));
		}

		String start_date = reqDTO.getValue("start_date");
		String end_date = reqDTO.getValue("end_date");
		String type = reqDTO.getValue("type");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();

		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		List<Map> listMap = dao
				.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
		for (int i = 0; i < listMap.size(); i++) {
			Map map = listMap.get(i);
			String element = map.get("coding_code_id").toString() + "~"
					+ map.get("coding_name");
			equipmentList.add(element);

		}
		String preSql = "";
		String preSql1 = "";
		String sql = "";
		if ("num".equals(type)) {
			String a = " select sum(realnum) as realnum , coding_code_id"
					+ "  from (select (m.use_num) as realnum, coding_code_id"
					+ "   from gms_device_zy_wxbymat m  left  join gms_mat_recyclemat_info r on m.wz_id=r.wz_id"
					+ "  where   r.wz_type='3'  and r.bsflag='0' and  r.project_info_id is not null    and   m.usemat_id in"
					+ "  (select x. usemat_id  from gms_device_zy_bywx x"
					+ "     where 1=1  and x.bsflag='0'  and  x.project_info_id=r.project_info_id and  x.project_info_id is not null  ";
			if (null != project_info_id && !"".equals(project_info_id)
					&& !"null".equals(project_info_id)) {
				a += "   and   x.project_info_id   in (" + innerIds + ") ";
			}

			if (!"".equals(start_date) && null != start_date) {
				a += "    and x.bywx_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (!"".equals(end_date) && null != end_date) {
				a += "    and x.bywx_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			String b = ")" + "   and m.coding_code_id = '@'" + "   ) a"
					+ " group by coding_code_id";
			preSql = a + b;

			String a1 = " select sum(realnum) as realnum , coding_code_id"
					+ "  from (select (m.use_num) as realnum, coding_code_id"
					+ "   from gms_device_zy_wxbymat m  left  join gms_mat_recyclemat_info r on m.wz_id=r.wz_id"
					+ "  where   r.wz_type='3'  and r.bsflag='0' and  r.project_info_id is  null   and   m.usemat_id in"
					+ "  (select x. usemat_id  from gms_device_zy_bywx x"
					+ "     where 1=1  and x.bsflag='0'  and  x.project_info_id is  null ";
			if (null != project_info_id && !"".equals(project_info_id)
					&& !"null".equals(project_info_id)) {
				a1 += "   and   x.project_info_id   in (" + innerIds + ") ";
			}

			if (!"".equals(start_date) && null != start_date) {
				a1 += "    and x.bywx_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (!"".equals(end_date) && null != end_date) {
				a1 += "    and x.bywx_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			String b1 = ")" + "   and m.coding_code_id = '@'" + "   ) a1"
					+ " group by coding_code_id";
			preSql1 = a1 + b1;

			sql = "select sum(realnum) as realnum , coding_code_id  from  "
					+ "(" + preSql + "   union  all " + preSql1
					+ ") k  group by coding_code_id ";
		} else if ("money".equals(type)) {
			String a = " select sum(realnum) as realnum , coding_code_id"
					+ "  from (select (m.use_num*r.actual_price) as realnum, coding_code_id"
					+ "   from gms_device_zy_wxbymat m,gms_mat_recyclemat_info r "
					+ "  where   m.usemat_id in"
					+ "  (select x. usemat_id  from gms_device_zy_bywx x"
					+ "     where 1=1  and   x.project_info_id=r.project_info_id  and  x.project_info_id is not null  ";
			if (null != project_info_id && !"".equals(project_info_id)
					&& !"null".equals(project_info_id)) {
				a += "  and  x.project_info_id   in (" + innerIds + ") ";
			}

			if (!"".equals(start_date) && null != start_date) {
				a += "    and x.bywx_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (!"".equals(end_date) && null != end_date) {
				a += "    and x.bywx_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			String b = ")"
					+ "   and m.coding_code_id = '@'"
					+ "   and  r.wz_type='3' and r.bsflag='0' and r.project_info_id is not null    and r.wz_id=m.wz_id ) a"
					+ " group by coding_code_id";

			String a1 = " select sum(realnum) as realnum , coding_code_id"
					+ "  from (select (m.use_num*r.actual_price) as realnum, coding_code_id"
					+ "   from gms_device_zy_wxbymat m,gms_mat_recyclemat_info r "
					+ "  where   m.usemat_id in"
					+ "  (select x. usemat_id  from gms_device_zy_bywx x"
					+ "     where 1=1    and x.project_info_id is  null  ";
			if (null != project_info_id && !"".equals(project_info_id)
					&& !"null".equals(project_info_id)) {
				a1 += "  and  x.project_info_id   in (" + innerIds + ") ";
			}

			if (!"".equals(start_date) && null != start_date) {
				a1 += "    and x.bywx_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (!"".equals(end_date) && null != end_date) {
				a1 += "    and x.bywx_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			String b1 = ")"
					+ "   and m.coding_code_id = '@'"
					+ "   and  r.wz_type='3' and r.bsflag='0' and r.project_info_id is  null    and r.wz_id=m.wz_id ) a1"
					+ " group by coding_code_id";
			preSql = a + b;
			preSql1 = a1 + b1;

			sql = "select sum(realnum) as realnum , coding_code_id  from  "
					+ "(" + preSql + "   union  all " + preSql1
					+ ") k  group by coding_code_id ";
		}
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");

		if ("num".equals(type)) {
			root.addAttribute("yAxisName", "备件数量");
		} else {
			root.addAttribute("yAxisName", "备件消耗金额（元）");
		}

		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(sql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");

				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZyBjUse-" + project_info_id
						+ "~" + start_date + "~" + end_date + "~"
						+ equipmentCode + "~" + type);

			} else {
				equipmentNum = "0";
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				set.addAttribute("link", "j-popZyBjUse-" + project_info_id
						+ "~" + start_date + "~" + end_date + "~"
						+ equipmentCode + "~" + type);
			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	public ISrvMsg getPopZyBjUse(ISrvMsg reqDTO) throws Exception {
		String project_info_id = reqDTO.getValue("project_info_id");
		String type = reqDTO.getValue("type");
		String innerIds = "";
		if (null != project_info_id && !"".equals(project_info_id)
				&& !"null".equals(project_info_id)) {
			project_info_id = project_info_id.substring(0,
					project_info_id.lastIndexOf(","));
			String[] ids = project_info_id.split(",");

			for (int i = 0; i < ids.length; i++) {
				innerIds += "'" + ids[i] + "' ,";
			}
			innerIds = innerIds.substring(0, innerIds.lastIndexOf(","));
		}
		String coding_code_id = reqDTO.getValue("coding_code_id");
		String devSql = "";

		String self_num = reqDTO.getValue("type");
		String start_date = reqDTO.getValue("start_date");
		String end_date = reqDTO.getValue("end_date");
		String baseTable = "";
		String baseTable1 = "";
		String sqlTable = "";
		if (null != project_info_id && (!"".equals(project_info_id))) {
			baseTable = "("
					+ "select m.use_num,"
					+ "m.coding_code_id,"
					+ " "
					+ " r.actual_price,"
					+ "  i.wz_name,"
					+ "  m.wz_id"
					+ "      from gms_device_zy_wxbymat m"
					+ " left join gms_device_zy_bywx x"
					+ "  on m.usemat_id = x.usemat_id"
					+ "   left join gms_mat_recyclemat_info r"
					+ "   on m.wz_id = r.wz_id"
					+ " left join gms_mat_infomation i"
					+ "   on r.wz_id = i.wz_id"
					+ " where  x.bsflag='0' and   r.wz_type = '3' and   r.project_info_id=x.project_info_id  and   r.project_info_id  is not null "
					+ "  and r.bsflag = '0'" + "  and x.project_info_id in ("
					+ innerIds + ")" + " and m.coding_code_id = '"
					+ coding_code_id + "'";
			if (null != start_date && (!"".equals(start_date))) {
				baseTable += "   and  x.bywx_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (null != end_date && (!"".equals(end_date))) {
				baseTable += "   and  x.bywx_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			baseTable += ") a";
			sqlTable = baseTable;
		} else {
			baseTable = "select m.use_num,"
					+ "   m.coding_code_id,"
					+ " "
					+ "    r.actual_price,"
					+ "     i.wz_name,"
					+ "     m.wz_id"
					+ "  from gms_device_zy_wxbymat m"
					+ "  left join gms_device_zy_bywx x"
					+ "    on m.usemat_id = x.usemat_id"
					+ "   left join gms_mat_recyclemat_info r"
					+ "    on m.wz_id = r.wz_id"
					+ "   left join gms_mat_infomation i"
					+ "    on r.wz_id = i.wz_id"
					+ " where x.bsflag='0'  and  r.wz_type = '3' and r.project_info_id is null "
					+ "  and   x.project_info_id is null  and  r.bsflag = '0'"
					+ "   and m.coding_code_id = '" + coding_code_id + "' ";
			if (null != start_date && (!"".equals(start_date))) {
				baseTable += "   and  x.bywx_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (null != end_date && (!"".equals(end_date))) {
				baseTable += "   and  x.bywx_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			baseTable += "";

			baseTable1 = "select m.use_num,"
					+ "m.coding_code_id,"
					+ " "
					+ " r.actual_price,"
					+ "  i.wz_name,"
					+ "  m.wz_id"
					+ "      from gms_device_zy_wxbymat m"
					+ " left join gms_device_zy_bywx x"
					+ "  on m.usemat_id = x.usemat_id"
					+ "   left join gms_mat_recyclemat_info r"
					+ "   on m.wz_id = r.wz_id"
					+ " left join gms_mat_infomation i"
					+ "   on r.wz_id = i.wz_id"
					+ " where  x.bsflag='0' and   r.wz_type = '3' and  r.project_info_id =x.project_info_id   and  r.project_info_id  is not null and x.project_info_id is not null  "
					+ "  and r.bsflag = '0'" + " and m.coding_code_id = '"
					+ coding_code_id + "'";
			if (null != start_date && (!"".equals(start_date))) {
				baseTable1 += "   and  x.bywx_date>=to_date('" + start_date
						+ "','yyyy-mm-dd')";
			}
			if (null != end_date && (!"".equals(end_date))) {
				baseTable1 += "   and  x.bywx_date<=to_date('" + end_date
						+ "','yyyy-mm-dd')";
			}
			baseTable1 += "";
			sqlTable = "(  select  *   from (" + baseTable + "  union all  "
					+ baseTable1 + ")  k ) kk";
		}
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		List<String> equipmentList = new ArrayList<String>();

		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		String nameSql_x = "select distinct wz_id,wz_name  from  " + sqlTable;

		List<Map> listMap = dao.queryRecords(nameSql_x);
		for (int i = 0; i < listMap.size(); i++) {
			Map map = listMap.get(i);
			String element = map.get("wz_id").toString() + "~"
					+ map.get("wz_name");
			equipmentList.add(element);

		}
		String preSql = "";
		if ("num".equals(type)) {
			preSql = "select sum(use_num)  as realnum  from   " + sqlTable
					+ "   where  wz_id='@' " + "   group by wz_id  ";
		} else if ("money".equals(type)) {
			preSql = "select sum(use_num*actual_price)  as realnum  from   "
					+ sqlTable + "   where  wz_id='@' " + "   group by wz_id ";
		}

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		// root.addAttribute("caption", "地震队机械设备统计");
		// root.addAttribute("xAxisName", "设备类型");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("rotateValues", "1");
		if ("num".equals(type)) {
			root.addAttribute("yAxisName", "备件数量");
		} else {
			root.addAttribute("yAxisName", "备件消耗金额（元）");
		}
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showExportDataMenuItem", "1");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		for (int i = 0; i < equipmentList.size(); i++) {
			String value = (String) equipmentList.get(i);
			String[] strArray = value.split("~");
			String equipmentCode = strArray[0];
			String equipmentName = strArray[1];
			StringBuffer selectSql = new StringBuffer();
			String presqli = new String(preSql);
			selectSql.append(presqli.replaceAll("@", strArray[0]));
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
			Map resultMap = null;
			try {
				resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}
			// 获取结果
			String equipmentNum = "";
			if (resultMap != null) {
				equipmentNum = "" + resultMap.get("realnum");
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				// set.addAttribute("link", "j-popWxbyHistoryBjCForm-" +
				// self_num
				// + "~" + project_info_id + "~" + coding_code_id + "~"
				// + equipmentCode);
			} else {
				equipmentNum = "0";
				Element category = categories.addElement("category");
				category.addAttribute("label", equipmentName);
				Element set = dataset.addElement("set");
				set.addAttribute("value", equipmentNum);
				// set.addAttribute("link", "j-popWxbyHistoryBjCForm-" +
				// self_num
				// + "~" + project_info_id + "~" + coding_code_id + "~"
				// + equipmentCode);

			}
		}
		String dataXML = document.asXML();
		int p_start = dataXML.indexOf("<chart");
		dataXML = dataXML.substring(p_start, dataXML.length());
		responseMsg.setValue("dataXML", dataXML);
		return responseMsg;
	}

	/*
	 * 震源备件金额
	 */
	public ISrvMsg getProjectUse(ISrvMsg reqDTO) throws Exception {
		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String userOrgId = reqDTO.getUserToken().getOrgId();
		// String args=key+"-"+self_num+"-"
		// +project_info_id+"-"+bywx_date_begin+"-"+
		// bywx_date_end+"-"+work_hours_begin+"-"+work_hours_end+"-"+wz_name;
		String args = reqDTO.getValue("args");

		String[] arg = args.split("~");
		// 现场非现场标志 xcsb fxcsb
		String key = arg[0];
		// 自编号
		String self_num = arg[1];
		// 项目ID
		String project_info_id = arg[2];
		// 保养维修起止时间
		String bywx_date_begin = arg[3];
		if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
			bywx_date_begin = new SimpleDateFormat("yyyy").format(new Date())
					+ "-01-01";
		}
		String bywx_date_end = arg[4];
		if (null == bywx_date_end || "".equals(bywx_date_end)) {
			bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
		}
		// 累计工作小时起止时间
		String work_hours_begin = arg[5];
		String work_hours_end = arg[6];
		// 备件名称
		String wz_name = arg[7];
		String zcjType = arg[8];
		String byjb = arg[9];
		String wz_id = arg[10];

		String byjbSql = "";
		if (null != byjb && !"".equals(byjb) && !"null".equals(byjb)) {
			byjb = byjb.substring(0, byjb.lastIndexOf(","));
			String str[] = byjb.split(",");
			for (int i = 0; i < str.length; i++) {
				byjbSql += "'" + str[i] + "'" + ",";

			}
			byjbSql = byjbSql.substring(0, byjbSql.lastIndexOf(","));
		}
		// 物资ID B,C,D,

		String wz_idSql = "";
		if (null != wz_id && !"".equals(wz_id) && !"null".equals(wz_id)) {
			wz_id = wz_id.substring(0, wz_id.lastIndexOf(","));
			String str[] = wz_id.split(",");
			for (int i = 0; i < str.length; i++) {
				wz_idSql += "'" + str[i] + "'" + ",";
			}
			wz_idSql = wz_idSql.substring(0, wz_idSql.lastIndexOf(","));
		}
		// Sql 中的IN 格式 自编号
		String self_nums = "";
		if (null != self_num && !"".equals(self_num)) {
			if (self_num.indexOf(",") > 0) {
				String[] snum = self_num.split(",");
				for (int i = 0; i < snum.length; i++) {
					self_nums += "'" + snum[i] + "'" + ",";
				}
				if (null != self_nums && !"".equals(self_nums)) {
					self_nums = self_nums.substring(0,
							self_nums.lastIndexOf(","));
				}
			} else {
				List<Map> list = dao
						.queryRecords("select self_num from gms_device_account  where dev_type  like 'S06230101%'  and  bsflag='0' and  self_num  like '%"
								+ self_num + "%'");
				if (null == list) {
					self_nums = "";
				} else {
					for (Map map : list) {
						self_nums += "'" + map.get("self_num").toString() + "'"
								+ ",";
					}
					if (null != self_nums && !"".equals(self_nums)) {
						self_nums = self_nums.substring(0,
								self_nums.lastIndexOf(","));
					}
				}
			}

		}

		// Sql 中的IN 格式 项目ID
		String project_info_ids = "";
		if (null != project_info_id && !"".equals(project_info_id)
				&& !"null".equals(project_info_id)) {
			String[] pid = project_info_id.split(",");
			for (int i = 0; i < pid.length; i++) {
				project_info_ids += "'" + pid[i] + "'" + ",";
			}
			if (null != project_info_ids && !"".equals(project_info_ids)) {
				project_info_ids = project_info_ids.substring(0,
						project_info_ids.lastIndexOf(","));
			}
		}

		/**
		 * 现场和非现场
		 */

		if ("xcsb".equals(key)) {
			// X 坐标项目名称
			String ProjectSql = "select  distinct  t.project_info_no,t.project_name"
					+ "    from gp_task_project t, gp_task_project_dynamic t2"
					+ "    where t.project_info_no = t2.project_info_no and t.bsflag='0'";
			// + "  and t.acquire_end_time>=to_date('"
			// + bywx_date_begin
			// + "','yyyy-mm-dd')"
			// + "  and  t.acquire_end_time<=to_date('"
			// + bywx_date_end
			// + "','yyyy-mm-dd')";
			if (null != project_info_ids && !"".equals(project_info_ids)) {
				ProjectSql += "  and t.project_info_no  in ("
						+ project_info_ids + ")   ";
			} else {
				ProjectSql += "  and t.project_info_no in  ( select project_info_id from gms_device_zy_bywx  t where t.project_info_id  is not null and "
						+ "t.bywx_date>=to_date('"+bywx_date_begin+"','yyyy-mm-dd') and t.bywx_date<=to_date('"+bywx_date_end+"','yyyy-mm-dd'))";
			}
			List<String> projectList = new ArrayList<String>();

			List<Map> listMap = dao.queryRecords(ProjectSql);
			if (null != listMap) {
				for (int i = 0; i < listMap.size(); i++) {
					Map map = listMap.get(i);
					Object info_no = map.get("project_info_no");
					Object name = map.get("project_name");
					if (null != info_no && null != name) {
						String id = info_no.toString();
						String project_name = name.toString();
						String element = id + "~" + project_name;
						projectList.add(element);
					}

				}
			}

			// Y坐标数据统计
			StringBuffer sql = new StringBuffer(
					"select  sum (b.use_num*c.actual_price) as price  from gms_device_zy_bywx t "
							+ "   left join gms_device_zy_wxbymat b on t.usemat_id=b.usemat_id "
							+ "   left join gms_mat_recyclemat_info  c on c.wz_id=b.wz_id where ");
			sql.append("   c.wz_type='3'  and c.bsflag='0' and  c.project_info_id is not null  and t.project_info_id=c.project_info_id    and t.bsflag='0'");
			if (null != self_nums && (!"".equals(self_nums))) {
				sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account_dui  n where n.self_num in ("
						+ self_nums + ") )");
			}
			if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
					&& !"null".equals(bywx_date_begin)) {
				sql.append("   and t.bywx_date>=to_date('" + bywx_date_begin
						+ "','yyyy-mm-dd')");
			}
			if (null != bywx_date_end && (!"".equals(bywx_date_end))
					&& !"null".equals(bywx_date_end)) {
				sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')");
			}
			if (null != work_hours_begin && (!"".equals(work_hours_begin))
					&& !"null".equals(work_hours_begin)) {
				int begin = Integer.parseInt(work_hours_begin);
				sql.append("   and  to_number( t.work_hours)>=" + begin);
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))
					&& !"null".equals(work_hours_end)) {
				int end = Integer.parseInt(work_hours_end);
				sql.append("   and  to_number( t.work_hours)<=" + end);
			}
			if (null != wz_name && (!"".equals(wz_name))
					&& !"null".equals(wz_name)) {
				sql.append("   and t.usemat_id  in (")
						.append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
						.append("   (select wz_id from gms_mat_recyclemat_info r where  r.project_info_id is not null and   r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
								+ wz_name + "%')))");

			}

			if (null != zcjType && !"".equals(zcjType)
					&& !"null".equals(zcjType)) {
				String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
						+ "')";
				sql.append(zcj_typeSql);
			}

			if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
				String wz_id_sql = "  and  c.wz_id in (" + wz_idSql + ")";
				sql.append(wz_id_sql);
			}
			if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
				String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
						+ ")";
				sql.append(by_jb_sql);
			}

			sql.append(" and  t.project_info_id='@'");
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			// root.addAttribute("caption", "地震队机械设备统计");
			// root.addAttribute("xAxisName", "设备类型");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			root.addAttribute("rotateValues", "1");
			root.addAttribute("yAxisName", "备件消耗金额（元）");
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "1");
			root.addAttribute("showExportDataMenuItem", "1");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "12000");
			root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
			Element categories = root.addElement("categories");
			Element dataset = root.addElement("dataset");
			for (int i = 0; i < projectList.size(); i++) {
				String value = (String) projectList.get(i);
				String[] strArray = value.split("~");
				String projectCode = strArray[0];
				String projectName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(sql.toString());
				selectSql.append(presqli.replaceAll("@", projectCode));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("表名或查询条件字段不存在!");
				}
				// 获取结果
				String price = "";
				if (resultMap != null) {
					price = "" + resultMap.get("price");
					// 拼XML文档
					Element category = categories.addElement("category");
					category.addAttribute("label", projectName);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					String newArgs = new String(args);
					newArgs = newArgs + "~" + projectCode;
					set.addAttribute("link", "j-popBJTYList-" + newArgs);

				} else {
					price = "0";
					// 拼XML文档
					Element category = categories.addElement("category");
					category.addAttribute("label", projectName);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					String newArgs = new String(args);
					newArgs = newArgs + "~" + projectCode;
					set.addAttribute("link", "j-popBJTYList-" + newArgs);

				}
			}
			String dataXML = document.asXML();
			int p_start = dataXML.indexOf("<chart");
			dataXML = dataXML.substring(p_start, dataXML.length());
			responseMsg.setValue("dataXML", dataXML);

		} else if ("fxcsb".equals(key)) {
			// X 坐标项目名称

			List<String> projectList = new ArrayList<String>();

			projectList.add("东部维修组~东部维修组");
			projectList.add("西部维修组~西部维修组");
			projectList.add("其他~其他");

			// Y坐标数据统计
			StringBuffer sql = new StringBuffer(
					"select  sum (b.use_num*c.actual_price) as price  from gms_device_zy_bywx t "
							+ "   left join gms_device_zy_wxbymat b on t.usemat_id=b.usemat_id "
							+ "   left join gms_mat_recyclemat_info  c on c.wz_id=b.wz_id where ");
			sql.append("   c.wz_type='3'  and c.bsflag='0' and  c.project_info_id is  null   and t.bsflag='0'");
			if (null != self_nums && (!"".equals(self_nums))) {
				sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account  n where n.self_num in ("
						+ self_nums + ") )");
			}
			if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
					&& !"null".equals(bywx_date_begin)) {
				sql.append("   and t.bywx_date>=to_date('" + bywx_date_begin
						+ "','yyyy-mm-dd')");
			}
			if (null != bywx_date_end && (!"".equals(bywx_date_end))
					&& !"null".equals(bywx_date_end)) {
				sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')");
			}
			if (null != work_hours_begin && (!"".equals(work_hours_begin))
					&& !"null".equals(work_hours_begin)) {
				int begin = Integer.parseInt(work_hours_begin);
				sql.append("   and  to_number( t.work_hours)>=" + begin);
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))
					&& !"null".equals(work_hours_end)) {
				int end = Integer.parseInt(work_hours_end);
				sql.append("   and  to_number( t.work_hours)<=" + end);
			}
			if (null != wz_name && (!"".equals(wz_name))
					&& !"null".equals(wz_name)) {
				sql.append("   and t.usemat_id  in (")
						.append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
						.append("   (select wz_id from gms_mat_recyclemat_info r where r.project_info_id  is null and  r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
								+ wz_name + "%')))");

			}

			if (null != zcjType && !"".equals(zcjType)
					&& !"null".equals(zcjType)) {
				String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
						+ "')";
				sql.append(zcj_typeSql);
			}
			if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
				String wz_id_sql = "  and  c.wz_id in (" + wz_idSql + ")";
				sql.append(wz_id_sql);
			}
			if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
				String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
						+ ")";
				sql.append(by_jb_sql);
			}
			sql.append(" and  t.project_info_id is null");
			sql.append(" and  t.repair_unit='@'");
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			// root.addAttribute("caption", "地震队机械设备统计");
			// root.addAttribute("xAxisName", "设备类型");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			root.addAttribute("rotateValues", "1");
			root.addAttribute("yAxisName", "备件消耗金额（元）");
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "1");
			root.addAttribute("showExportDataMenuItem", "1");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "12000");
			root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
			Element categories = root.addElement("categories");
			Element dataset = root.addElement("dataset");
			for (int i = 0; i < projectList.size(); i++) {
				String value = (String) projectList.get(i);
				String[] strArray = value.split("~");
				String projectCode = strArray[0];
				String projectName = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(sql.toString());
				if ("其他".equals(projectCode)) {
					selectSql.append(presqli.replaceAll("t.repair_unit='@'",
							"  t.repair_unit not in ('东部维修组','西部维修组')"));
				} else {
					selectSql.append(presqli.replaceAll("@", projectCode));
				}

				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("表名或查询条件字段不存在!");
				}
				// 获取结果
				String price = "";
				if (resultMap != null) {
					price = "" + resultMap.get("price");
					// 拼XML文档
					Element category = categories.addElement("category");
					category.addAttribute("label", projectName);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					if ("东部维修组".equals(projectCode)) {
						projectCode = "dbwxz";
					} else if ("西部维修组".equals(projectCode)) {
						projectCode = "xbwxz";
					} else if ("其他".equals(projectCode)) {
						projectCode = "qt";
					}
					String newArgs = new String(args);
					newArgs = newArgs + "~" + projectCode;
					set.addAttribute("link", "j-popBJTYList-" + newArgs);

				} else {
					price = "0";
					// 拼XML文档
					Element category = categories.addElement("category");
					category.addAttribute("label", projectName);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					if ("东部维修组".equals(projectCode)) {
						projectCode = "dbwxz";
					} else if ("西部维修组".equals(projectCode)) {
						projectCode = "xbwxz";
					} else if ("其他".equals(projectCode)) {
						projectCode = "qt";
					}
					String newArgs = new String(args);
					newArgs = newArgs + "~" + projectCode;
					set.addAttribute("link", "j-popBJTYList-" + newArgs);

				}
			}
			String dataXML = document.asXML();
			int p_start = dataXML.indexOf("<chart");
			dataXML = dataXML.substring(p_start, dataXML.length());
			responseMsg.setValue("dataXML", dataXML);

		}
		return responseMsg;
	}

	/*
	 * 单项目备件大类消耗明细
	 */
	public ISrvMsg getWz14TypeList(ISrvMsg reqDTO) throws Exception {
		IPureJdbcDao dao = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String args = reqDTO.getValue("args");
		String[] arg = args.split("~");
		// 现场非现场标志 xcsb fxcsb
		String key = arg[0];
		// 自编号
		String self_num = arg[1];
		// 项目ID 单项目或者是东部维修组|西部维修部
		String project_info_id = arg[11];
		String zcjType = arg[8];
		String byjb = arg[9];
		String wz_id = arg[10];

		String byjbSql = "";
		if (null != byjb && !"".equals(byjb) && !"null".equals(byjb)) {
			byjb = byjb.substring(0, byjb.lastIndexOf(","));
			String str[] = byjb.split(",");
			for (int i = 0; i < str.length; i++) {
				byjbSql += "'" + str[i] + "'" + ",";

			}
			byjbSql = byjbSql.substring(0, byjbSql.lastIndexOf(","));
		}
		// 物资ID B,C,D,

		String wz_idSql = "";
		if (null != wz_id && !"".equals(wz_id) && !"null".equals(wz_id)) {
			wz_id = wz_id.substring(0, wz_id.lastIndexOf(","));
			String str[] = wz_id.split(",");
			for (int i = 0; i < str.length; i++) {
				wz_idSql += "'" + str[i] + "'" + ",";
			}
			wz_idSql = wz_idSql.substring(0, wz_idSql.lastIndexOf(","));
		}

		// 保养维修起止时间
		String bywx_date_begin = arg[3];
		if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
			bywx_date_begin = new SimpleDateFormat("yyyy").format(new Date())
					+ "-01-01";
		}
		String bywx_date_end = arg[4];
		if (null == bywx_date_end || "".equals(bywx_date_end)) {
			bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
		}
		// 累计工作小时起止时间
		String work_hours_begin = arg[5];
		String work_hours_end = arg[6];
		// 备件名称
		String wz_name = arg[7];
		// Sql 中的IN 格式 自编号
		String self_nums = "";
		if (null != self_num && !"".equals(self_num)) {
			if (self_num.indexOf(",") > 0) {
				String[] snum = self_num.split(",");
				for (int i = 0; i < snum.length; i++) {
					self_nums += "'" + snum[i] + "'" + ",";
				}
				if (null != self_nums && !"".equals(self_nums)) {
					self_nums = self_nums.substring(0,
							self_nums.lastIndexOf(","));
				}
			} else {
				List<Map> list = dao
						.queryRecords("select self_num from gms_device_account  where dev_type  like 'S06230101%'  and  bsflag='0' and  self_num  like '%"
								+ self_num + "%'");
				if (null == list) {
					self_nums = "";
				} else {
					for (Map map : list) {
						self_nums += "'" + map.get("self_num").toString() + "'"
								+ ",";
					}
					if (null != self_nums && !"".equals(self_nums)) {
						self_nums = self_nums.substring(0,
								self_nums.lastIndexOf(","));
					}
				}
			}

		}

		List<String> typeList = new ArrayList<String>();

		List<Map> listMap = dao
				.queryRecords("select * from comm_coding_sort_detail  t where coding_sort_id='5110000188' and bsflag='0' order by t.coding_code_id ");
		for (int i = 0; i < listMap.size(); i++) {
			Map map = listMap.get(i);
			String element = map.get("coding_code_id").toString() + "~"
					+ map.get("coding_name");
			typeList.add(element);

		}
		/**
		 * 现场震源
		 */
		if ("xcsb".equals(key)) {
			// Y坐标数据统计
			StringBuffer sql = new StringBuffer(
					"  select sum(w.use_num*r.actual_price ) as price , w.coding_code_id "
							+ "  from gms_device_zy_bywx t left  join gms_device_zy_wxbymat w "
							+ "   on t.usemat_id=w.usemat_id");
			sql.append("  left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id  ");
			sql.append("   where r.project_info_id =t.project_info_id  and  w.coding_code_id is not null  and r.wz_type='3' and r.project_info_id is not null  and r.bsflag='0' and t.bsflag='0' ");
			if (null != self_nums && (!"".equals(self_nums))) {
				sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account_dui  n where n.self_num in ("
						+ self_nums + ") )");
			}
			if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
					&& !"null".equals(bywx_date_begin)) {
				sql.append("   and t.bywx_date>=to_date('" + bywx_date_begin
						+ "','yyyy-mm-dd')");
			}
			if (null != bywx_date_end && (!"".equals(bywx_date_end))
					&& !"null".equals(bywx_date_end)) {
				sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')");
			}
			if (null != work_hours_begin && (!"".equals(work_hours_begin))
					&& !"null".equals(work_hours_begin)) {
				int begin = Integer.parseInt(work_hours_begin);
				sql.append("   and  to_number( t.work_hours)>=" + begin);
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))
					&& !"null".equals(work_hours_end)) {
				int end = Integer.parseInt(work_hours_end);
				sql.append("   and  to_number( t.work_hours)<=" + end);
			}
			if (null != project_info_id && (!"".equals(project_info_id))
					&& !"null".equals(project_info_id)) {
				sql.append("   and t.project_info_id='" + project_info_id + "'");
			}
			if (null != wz_name && (!"".equals(wz_name))
					&& !"null".equals(wz_name)) {
				sql.append("   and t.usemat_id  in (")
						.append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
						.append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
								+ wz_name + "%')))");

			}

			if (null != zcjType && !"".equals(zcjType)
					&& !"null".equals(zcjType)) {
				String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
						+ "')";
				sql.append(zcj_typeSql);
			}

			if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
				String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
				sql.append(wz_id_sql);
			}
			if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
				String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
						+ ")";
				sql.append(by_jb_sql);
			}

			sql.append(" and  w.coding_code_id='@'");
			sql.append(" group  by  w.coding_code_id");
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			// root.addAttribute("caption", "地震队机械设备统计");
			// root.addAttribute("xAxisName", "设备类型");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			root.addAttribute("rotateValues", "1");
			root.addAttribute("yAxisName", "消耗金额（元）");
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "1");
			root.addAttribute("showExportDataMenuItem", "1");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
			Element categories = root.addElement("categories");
			Element dataset = root.addElement("dataset");
			for (int i = 0; i < typeList.size(); i++) {
				String value = (String) typeList.get(i);
				String[] strArray = value.split("~");
				String id = strArray[0];
				String name = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(sql.toString());
				selectSql.append(presqli.replaceAll("@", id));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("表名或查询条件字段不存在!");
				}
				// 获取结果
				String price = "";
				if (resultMap != null) {
					price = "" + resultMap.get("price");

					Element category = categories.addElement("category");
					category.addAttribute("label", name);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					String newArgs = new String(args);
					newArgs = newArgs + "~" + id;
					set.addAttribute("link", "j-popProjectBjUseDetail-"
							+ newArgs);

				} else {
					price = "0";
					Element category = categories.addElement("category");
					category.addAttribute("label", name);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					String newArgs = new String(args);
					newArgs = newArgs + "~" + id;
					set.addAttribute("link", "j-popProjectBjUseDetail-"
							+ newArgs);
				}
			}
			String dataXML = document.asXML();
			int p_start = dataXML.indexOf("<chart");
			dataXML = dataXML.substring(p_start, dataXML.length());
			responseMsg.setValue("dataXML", dataXML);

		} else if ("fxcsb".equals(key)) {
			// Y坐标数据统计
			StringBuffer sql = new StringBuffer(
					"  select sum(w.use_num*r.actual_price ) as price , w.coding_code_id "
							+ "  from gms_device_zy_bywx t left  join gms_device_zy_wxbymat w "
							+ "   on t.usemat_id=w.usemat_id");
			sql.append("  left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id  ");
			sql.append("   where w.coding_code_id is not null  and r.wz_type='3'  and r.project_info_id is  null  and r.bsflag='0' ");
			if (null != self_nums && (!"".equals(self_nums))) {
				sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account  n where n.self_num in ("
						+ self_nums + ") )");
			}
			if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
					&& !"null".equals(bywx_date_begin)) {
				sql.append("   and t.bywx_date>=to_date('" + bywx_date_begin
						+ "','yyyy-mm-dd')");
			}
			if (null != bywx_date_end && (!"".equals(bywx_date_end))
					&& !"null".equals(bywx_date_end)) {
				sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')");
			}
			if (null != work_hours_begin && (!"".equals(work_hours_begin))
					&& !"null".equals(work_hours_begin)) {
				int begin = Integer.parseInt(work_hours_begin);
				sql.append("   and  to_number( t.work_hours)>=" + begin);
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))
					&& !"null".equals(work_hours_end)) {
				int end = Integer.parseInt(work_hours_end);
				sql.append("   and  to_number( t.work_hours)<=" + end);
			}
			if (null != project_info_id && (!"".equals(project_info_id))
					&& !"null".equals(project_info_id)) {
				if ("dbwxz".equals(project_info_id)) {
					project_info_id = "东部维修组";
					sql.append("   and t.repair_unit='" + project_info_id + "'");
				} else if ("xbwxz".equals(project_info_id)) {
					project_info_id = "西部维修组";
					sql.append("   and t.repair_unit='" + project_info_id + "'");
				} else if ("qt".equals(project_info_id)) {
					project_info_id = "其他";
					sql.append("   and t.repair_unit  not in ('东部维修组','西部维修组')");
				}

			}
			if (null != wz_name && (!"".equals(wz_name))
					&& !"null".equals(wz_name)) {
				sql.append("   and t.usemat_id  in (")
						.append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
						.append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
								+ wz_name + "%')))");

			}

			if (null != zcjType && !"".equals(zcjType)
					&& !"null".equals(zcjType)) {
				String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
						+ "')";
				sql.append(zcj_typeSql);
			}

			if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
				String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
				sql.append(wz_id_sql);
			}
			if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
				String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
						+ ")";
				sql.append(by_jb_sql);
			}

			sql.append(" and  t.project_info_id  is null ");
			sql.append(" and  w.coding_code_id='@'");
			sql.append(" group  by  w.coding_code_id");
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("chart");
			root.addAttribute("bgColor", "F3F5F4,DEE6EB");
			// root.addAttribute("caption", "地震队机械设备统计");
			// root.addAttribute("xAxisName", "设备类型");
			root.addAttribute("formatNumberScale", "0");
			root.addAttribute("formatNumber", "0");
			root.addAttribute("rotateValues", "1");
			root.addAttribute("yAxisName", "消耗金额（元）");
			root.addAttribute("showLabels", "1");
			root.addAttribute("showValues", "1");
			root.addAttribute("showExportDataMenuItem", "1");
			root.addAttribute("rotateYAxisName", "0");
			root.addAttribute("yAxisNameWidth", "16");
			root.addAttribute("exportDataMenuItemLabel", "复制到复制板...");
			Element categories = root.addElement("categories");
			Element dataset = root.addElement("dataset");
			for (int i = 0; i < typeList.size(); i++) {
				String value = (String) typeList.get(i);
				String[] strArray = value.split("~");
				String id = strArray[0];
				String name = strArray[1];
				StringBuffer selectSql = new StringBuffer();
				String presqli = new String(sql.toString());
				selectSql.append(presqli.replaceAll("@", id));
				IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				Map resultMap = null;
				try {
					resultMap = jdbcDAO.queryRecordBySQL(selectSql.toString());
				} catch (Exception e) {
					// message.append("表名或查询条件字段不存在!");
				}
				// 获取结果
				String price = "";
				if (resultMap != null) {
					price = "" + resultMap.get("price");
					Element category = categories.addElement("category");
					category.addAttribute("label", name);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					String newArgs = new String(args);
					newArgs = newArgs + "~" + id;
					set.addAttribute("link", "j-popProjectBjUseDetail-"
							+ newArgs);

				} else {
					price = "0";
					Element category = categories.addElement("category");
					category.addAttribute("label", name);
					Element set = dataset.addElement("set");
					set.addAttribute("value", price);
					String newArgs = new String(args);
					newArgs = newArgs + "~" + id;
					set.addAttribute("link", "j-popProjectBjUseDetail-"
							+ newArgs);
				}
			}
			String dataXML = document.asXML();
			int p_start = dataXML.indexOf("<chart");
			dataXML = dataXML.substring(p_start, dataXML.length());
			responseMsg.setValue("dataXML", dataXML);

		}

		return responseMsg;
	}

	public ISrvMsg getProjectBjUseDetail(ISrvMsg reqDTO) throws Exception {
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String args = reqDTO.getValue("args");
		String[] arg = args.split("~");
		// 现场非现场标志 xcsb fxcsb
		String key = arg[0];
		// 自编号
		String self_num = arg[1];

		String zcjType = arg[8];
		// 项目ID 单项目
		String project_info_id = arg[11];
		// 备件大类 code
		String coding_code_id = arg[12];
		// 保养维修起止时间
		String bywx_date_begin = arg[3];

		String byjb = arg[9];
		String wz_id = arg[10];

		String byjbSql = "";
		if (null != byjb && !"".equals(byjb) && !"null".equals(byjb)) {
			byjb = byjb.substring(0, byjb.lastIndexOf(","));
			String str[] = byjb.split(",");
			for (int i = 0; i < str.length; i++) {
				byjbSql += "'" + str[i] + "'" + ",";

			}
			byjbSql = byjbSql.substring(0, byjbSql.lastIndexOf(","));
		}
		// 物资ID B,C,D,

		String wz_idSql = "";
		if (null != wz_id && !"".equals(wz_id) && !"null".equals(wz_id)) {
			wz_id = wz_id.substring(0, wz_id.lastIndexOf(","));
			String str[] = wz_id.split(",");
			for (int i = 0; i < str.length; i++) {
				wz_idSql += "'" + str[i] + "'" + ",";
			}
			wz_idSql = wz_idSql.substring(0, wz_idSql.lastIndexOf(","));
		}
		if (null == bywx_date_begin || "".equals(bywx_date_begin)) {
			bywx_date_begin = new SimpleDateFormat("yyyy").format(new Date())
					+ "-01-01";
		}
		String bywx_date_end = arg[4];
		if (null == bywx_date_end || "".equals(bywx_date_end)) {
			bywx_date_end = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
		}
		// 累计工作小时起止时间
		String work_hours_begin = arg[5];
		String work_hours_end = arg[6];
		// 备件名称
		String wz_name = arg[7];
		// Sql 中的IN 格式 自编号
		String self_nums = "";
		if (null != self_num && !"".equals(self_num)) {
			if (self_num.indexOf(",") > 0) {
				String[] snum = self_num.split(",");
				for (int i = 0; i < snum.length; i++) {
					self_nums += "'" + snum[i] + "'" + ",";
				}
				if (null != self_nums && !"".equals(self_nums)) {
					self_nums = self_nums.substring(0,
							self_nums.lastIndexOf(","));
				}
			} else {
				List<Map> list = jdbcDAO
						.queryRecords("select self_num from gms_device_account  where dev_type  like 'S06230101%'  and  bsflag='0' and  self_num  like '%"
								+ self_num + "%'");
				if (null == list) {
					self_nums = "";
				} else {
					for (Map map : list) {
						self_nums += "'" + map.get("self_num").toString() + "'"
								+ ",";
					}
					if (null != self_nums && !"".equals(self_nums)) {
						self_nums = self_nums.substring(0,
								self_nums.lastIndexOf(","));
					}
				}
			}

		}
		if ("xcsb".equals(key)) {
			StringBuffer sql = new StringBuffer(
					"select  d.self_num, i.wz_name,r.actual_price,w.use_num,t.bywx_date "
							+ "   from  gms_device_zy_bywx t left join gms_device_zy_wxbymat w on t.usemat_id=w.usemat_id");
			sql.append("   left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id ");
			sql.append("  left join gms_mat_infomation i on r.wz_id=i.wz_id");
			sql.append("  left join gms_device_account_dui d on  d.dev_acc_id=t.dev_acc_id");
			sql.append("  where   r.project_info_id=t.project_info_id   and  r.wz_type='3'  and r.bsflag='0' and r.project_info_id is not null  and t.bsflag='0'  ");
			if (null != self_nums && (!"".equals(self_nums))) {
				sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account_dui  n where n.self_num in ("
						+ self_nums + ") )");
			}
			if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
					&& !"null".equals(bywx_date_begin)) {
				sql.append("   and t.bywx_date>=to_date('" + bywx_date_begin
						+ "','yyyy-mm-dd')");
			}
			if (null != bywx_date_end && (!"".equals(bywx_date_end))
					&& !"null".equals(bywx_date_end)) {
				sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')");
			}
			if (null != work_hours_begin && (!"".equals(work_hours_begin))
					&& !"null".equals(work_hours_begin)) {
				int begin = Integer.parseInt(work_hours_begin);
				sql.append("   and  to_number( t.work_hours)>=" + begin);
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))
					&& !"null".equals(work_hours_end)) {
				int end = Integer.parseInt(work_hours_end);
				sql.append("   and  to_number( t.work_hours)<=" + end);
			}
			if (null != project_info_id && (!"".equals(project_info_id))
					&& !"null".equals(project_info_id)) {
				sql.append("   and t.project_info_id='" + project_info_id + "'");
			}
			if (null != wz_name && (!"".equals(wz_name))
					&& !"null".equals(wz_name)) {
				sql.append("   and t.usemat_id  in (")
						.append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
						.append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
								+ wz_name + "%')))");

			}
			if (null != coding_code_id && (!"".equals(coding_code_id))
					&& !"null".equals(coding_code_id)) {
				sql.append("  and w.coding_code_id='" + coding_code_id + "'");
			}
			if (null != zcjType && !"".equals(zcjType)
					&& !"null".equals(zcjType)) {
				String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
						+ "')";
				sql.append(zcj_typeSql);
			}

			if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
				String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
				sql.append(wz_id_sql);
			}
			if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
				String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
						+ ")";
				sql.append(by_jb_sql);
			}
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("table");
			root.addAttribute("class", "tab_info");
			root.addAttribute("border", "0");
			root.addAttribute("cellspacing", "0");
			root.addAttribute("cellpadding", "0");
			root.addAttribute("style", "width:96.8%");
			root.addAttribute("id", "queryRetTable");

			Element titletr = root.addElement("tr");
			Element titletd1 = titletr.addElement("td");
			titletd1.addAttribute("class", "bt_info_odd");
			titletd1.addText("序号");
			Element titletd2 = titletr.addElement("td");
			titletd2.addAttribute("class", "bt_info_even");
			titletd2.addText("震源编号");
			Element titletd3 = titletr.addElement("td");
			titletd3.addAttribute("class", "bt_info_odd");
			titletd3.addText("部件名称");

			Element titletd4 = titletr.addElement("td");
			titletd4.addAttribute("class", "bt_info_even");
			titletd4.addText("单价");

			Element titletd5 = titletr.addElement("td");
			titletd5.addAttribute("class", "bt_info_odd");
			titletd5.addText("使用数量");
			Element titletd7 = titletr.addElement("td");
			titletd7.addAttribute("class", "bt_info_even");
			titletd7.addText("消耗时间");

			List<Map> resultList = null;
			try {
				resultList = jdbcDAO.queryRecords(sql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}

			// 拼XML文档
			if (resultList != null) {
				for (int i = 0; i < resultList.size(); i++) {
					Map tempMap = resultList.get(i);
					String classodd = null, classeven = null;
					if (i % 2 == 0) {
						classodd = "odd_odd";
						classeven = "odd_even";
					} else {
						classodd = "even_odd";
						classeven = "even_even";
					}
					int showinfo = i + 1;
					Element contenttr = root.addElement("tr");
					Element contenttd1 = contenttr.addElement("td");
					contenttd1.addAttribute("class", classodd);
					contenttd1.addText(showinfo + "");
					Element contenttd2 = contenttr.addElement("td");
					contenttd2.addAttribute("class", classeven);
					contenttd2.addText(tempMap.get("self_num").toString());
					Element contenttd3 = contenttr.addElement("td");
					contenttd3.addAttribute("class", classodd);
					contenttd3.addText(tempMap.get("wz_name").toString());
					Element contenttd4 = contenttr.addElement("td");
					contenttd4.addAttribute("class", classeven);
					contenttd4.addText(tempMap.get("actual_price").toString());
					Element contenttd5 = contenttr.addElement("td");
					contenttd5.addAttribute("class", classodd);
					contenttd5.addText(tempMap.get("use_num").toString());
					Element contenttd7 = contenttr.addElement("td");
					contenttd7.addAttribute("class", classeven);
					contenttd7.addText(tempMap.get("bywx_date").toString());
				}
			}
			String dataXML = document.asXML();
			int p_start = dataXML.indexOf("<table");
			dataXML = dataXML.substring(p_start, dataXML.length());
			responseMsg.setValue("dataXML", dataXML);
		} else if ("fxcsb".equals(key)) {
			StringBuffer sql = new StringBuffer(
					"select  d.self_num, i.wz_name,r.actual_price,w.use_num,t.bywx_date "
							+ "   from  gms_device_zy_bywx t left join gms_device_zy_wxbymat w on t.usemat_id=w.usemat_id");
			sql.append("   left join gms_mat_recyclemat_info r on r.wz_id=w.wz_id ");
			sql.append("  left join gms_mat_infomation i on r.wz_id=i.wz_id");
			sql.append("  left join gms_device_account d on  d.dev_acc_id=t.dev_acc_id");
			sql.append("  where r.wz_type='3'  and r.bsflag='0'   and r.project_info_id is   null   and t.bsflag='0'");
			if (null != self_nums && (!"".equals(self_nums))) {
				sql.append("   and  t.dev_acc_id in (select dev_acc_id  from  gms_device_account  n where n.self_num in ("
						+ self_nums + ") )");
			}
			if (null != bywx_date_begin && (!"".equals(bywx_date_begin))
					&& !"null".equals(bywx_date_begin)) {
				sql.append("   and t.bywx_date>=to_date('" + bywx_date_begin
						+ "','yyyy-mm-dd')");
			}
			if (null != bywx_date_end && (!"".equals(bywx_date_end))
					&& !"null".equals(bywx_date_end)) {
				sql.append("   and t.bywx_date<=to_date('" + bywx_date_end
						+ "','yyyy-mm-dd')");
			}
			if (null != work_hours_begin && (!"".equals(work_hours_begin))
					&& !"null".equals(work_hours_begin)) {
				int begin = Integer.parseInt(work_hours_begin);
				sql.append("   and  to_number( t.work_hours)>=" + begin);
			}
			if (null != work_hours_end && (!"".equals(work_hours_end))
					&& !"null".equals(work_hours_end)) {
				int end = Integer.parseInt(work_hours_end);
				sql.append("   and  to_number( t.work_hours)<=" + end);
			}
			if (null != project_info_id && (!"".equals(project_info_id))
					&& !"null".equals(project_info_id)) {
				if ("dbwxz".equals(project_info_id)) {
					project_info_id = "东部维修组";
					sql.append("   and t.repair_unit='" + project_info_id + "'");
				} else if ("xbwxz".equals(project_info_id)) {
					project_info_id = "西部维修组";
					sql.append("   and t.repair_unit='" + project_info_id + "'");
				} else if ("qt".equals(project_info_id)) {
					project_info_id = "其他";
					sql.append("   and t.repair_unit  not in ('东部维修组','西部维修组')");
				}
				sql.append("   and t.project_info_id is  null");
			}
			if (null != wz_name && (!"".equals(wz_name))
					&& !"null".equals(wz_name)) {
				sql.append("   and t.usemat_id  in (")
						.append("   select usemat_id from gms_device_zy_wxbymat m where m.wz_id in ")
						.append("   (select wz_id from gms_mat_recyclemat_info r where r.wz_type='3' and r.bsflag='0' and  r.wz_id  in (select wz_id  from gms_mat_infomation  where wz_name  like '%"
								+ wz_name + "%')))");

			}
			if (null != coding_code_id && (!"".equals(coding_code_id))
					&& !"null".equals(coding_code_id)) {
				sql.append("  and w.coding_code_id='" + coding_code_id + "'");
			}
			if (null != zcjType && !"".equals(zcjType)
					&& !"null".equals(zcjType)) {
				String zcj_typeSql = "  and   t.zcj_type in ('" + zcjType
						+ "')";
				sql.append(zcj_typeSql);
			}

			if (!"".equals(wz_id) && null != wz_id && !"null".equals(wz_id)) {
				String wz_id_sql = "  and  r.wz_id in (" + wz_idSql + ")";
				sql.append(wz_id_sql);
			}
			if (!"".equals(byjb) && null != byjb && !"null".equals(byjb)) {
				String by_jb_sql = "  and  t.MAINTENANCE_LEVEL  in (" + byjbSql
						+ ")";
				sql.append(by_jb_sql);
			}
			Document document = DocumentHelper.createDocument();
			Element root = document.addElement("table");
			root.addAttribute("class", "tab_info");
			root.addAttribute("border", "0");
			root.addAttribute("cellspacing", "0");
			root.addAttribute("cellpadding", "0");
			root.addAttribute("style", "width:96.8%");
			root.addAttribute("id", "queryRetTable");

			Element titletr = root.addElement("tr");
			Element titletd1 = titletr.addElement("td");
			titletd1.addAttribute("class", "bt_info_odd");
			titletd1.addText("序号");
			Element titletd2 = titletr.addElement("td");
			titletd2.addAttribute("class", "bt_info_even");
			titletd2.addText("震源编号");
			Element titletd3 = titletr.addElement("td");
			titletd3.addAttribute("class", "bt_info_odd");
			titletd3.addText("部件名称");

			Element titletd4 = titletr.addElement("td");
			titletd4.addAttribute("class", "bt_info_even");
			titletd4.addText("单价");

			Element titletd5 = titletr.addElement("td");
			titletd5.addAttribute("class", "bt_info_odd");
			titletd5.addText("使用数量");
			Element titletd7 = titletr.addElement("td");
			titletd7.addAttribute("class", "bt_info_even");
			titletd7.addText("消耗时间");

			List<Map> resultList = null;
			try {
				resultList = jdbcDAO.queryRecords(sql.toString());
			} catch (Exception e) {
				// message.append("表名或查询条件字段不存在!");
			}

			// 拼XML文档
			if (resultList != null) {
				for (int i = 0; i < resultList.size(); i++) {
					Map tempMap = resultList.get(i);
					String classodd = null, classeven = null;
					if (i % 2 == 0) {
						classodd = "odd_odd";
						classeven = "odd_even";
					} else {
						classodd = "even_odd";
						classeven = "even_even";
					}
					int showinfo = i + 1;
					Element contenttr = root.addElement("tr");
					Element contenttd1 = contenttr.addElement("td");
					contenttd1.addAttribute("class", classodd);
					contenttd1.addText(showinfo + "");
					Element contenttd2 = contenttr.addElement("td");
					contenttd2.addAttribute("class", classeven);
					contenttd2.addText(tempMap.get("self_num").toString());
					Element contenttd3 = contenttr.addElement("td");
					contenttd3.addAttribute("class", classodd);
					contenttd3.addText(tempMap.get("wz_name").toString());
					Element contenttd4 = contenttr.addElement("td");
					contenttd4.addAttribute("class", classeven);
					contenttd4.addText(tempMap.get("actual_price").toString());
					Element contenttd5 = contenttr.addElement("td");
					contenttd5.addAttribute("class", classodd);
					contenttd5.addText(tempMap.get("use_num").toString());
					Element contenttd7 = contenttr.addElement("td");
					contenttd7.addAttribute("class", classeven);
					contenttd7.addText(tempMap.get("bywx_date").toString());
				}
			}
			String dataXML = document.asXML();
			int p_start = dataXML.indexOf("<table");
			dataXML = dataXML.substring(p_start, dataXML.length());
			responseMsg.setValue("dataXML", dataXML);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 设备利用率展示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevUtilizationRate(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String orgId = user.getOrgId();
		String startDate = msg.getValue("startdate");//开始时间
		String endDate = msg.getValue("enddate");//结束时间
		String ownSubId = msg.getValue("ownsubid");//所属单位
		String ifCountry = msg.getValue("ifcountry");//国内/国外标识
		String devType = msg.getValue("devtype");//设备类型
		String _startDate = "";
		String _lastStartDate = "";
		String _endDate = "";
		String _lastEndDate = "";
		if(StringUtils.isNotBlank(startDate)){
			_startDate = startDate;
			_lastStartDate = (Integer.parseInt(startDate.substring(0, 4))-1) + startDate.substring(4);
		}else{
			_startDate = (DevUtil.getCurrentYear()+"-01-01").trim();
			_lastStartDate = ((Integer.parseInt(DevUtil.getCurrentYear())-1)+"-01-01").trim();
		}
		if(StringUtils.isNotBlank(endDate)){
			_endDate = endDate;
			_lastEndDate = (Integer.parseInt(endDate.substring(0, 4))-1) + endDate.substring(4);
		}else{
			_endDate = DevUtil.getCurrentDate();
			_lastEndDate = (Integer.parseInt(DevUtil.getCurrentDate().substring(0, 4))-1) + DevUtil.getCurrentDate().substring(4);
		}
		List<Map> thisRateList = jdbcDao.queryRecords(getDevRateSql(_startDate,_endDate,ownSubId,ifCountry,devType));
		List<Map> lastRateList = jdbcDao.queryRecords(getDevRateSql(_lastStartDate,_lastEndDate,ownSubId,ifCountry,devType));
		
		List<Map> list =  new ArrayList<Map>();
		for(Map tempMap : thisRateList){
			Map newMap = new HashMap();
			newMap.put("hisdate", tempMap.get("his_date"));
			newMap.put("userate", tempMap.get("userate"));
			newMap.put("lastuserate", "0");
			list.add(newMap);
		}
		
		for(Map tempMap : lastRateList){
			boolean inFlag = false;
			for(Map map : list){
				if(tempMap.get("his_date").equals(map.get("hisdate"))){
					map.put("lastuserate", tempMap.get("userate"));
					inFlag = true;
					break;
				}
			}
			//补充日期一边不存和一边不存在的数据
//			if(!inFlag){
//				Map newMap = new HashMap();
//				newMap.put("hisdate", tempMap.get("his_date"));
//				newMap.put("userate", "0");
//				newMap.put("lastuserate", tempMap.get("userate"));
//				list.add(newMap);
//			}
		}
		responseDTO.setValue("datas", list); 
		return responseDTO;
	}
	/**
	 * NEWMETHOD 利用率sql
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	private String getDevRateSql (String startDate,String endDate,String ownSubId,String ifCountry,String devType){
		StringBuilder sqlBuilder = new StringBuilder();
		String rateSql = "select to_char(dh.his_date,'mmdd') his_date,"
					   + " case when cast(round(nvl(decode(sum(dh.sum_num),0,0,"
	                   + " (sum(dh.use_num)+nvl(t.usenum,0)) / sum(dh.sum_num)),"
	                   + " 0) * 100 * 365 / 250, 2) as number(10, 2)) > 100"
	                   + " then 100 else cast(round(nvl(decode(sum(dh.sum_num),0,0,"
	                   + " (sum(dh.use_num)+nvl(t.usenum,0)) / sum(dh.sum_num)),"
	                   + " 0) * 100 * 365 / 250, 2) as number(10, 2)) end as userate";
					   //if(Integer.parseInt(DevUtil.getCurrentYear()) > Integer.parseInt(startDate.substring(0,4))){
						//   rateSql += " from gms_device_dailyhistory"+"_"+startDate.substring(0,4)+" dh";
					   //}else{
						   rateSql += " from gms_device_dailyhistory dh";
					   //}
	           rateSql += " left join dms_device_tree dt on dh.device_type = dt.device_code"
	                   + " left join (select d.his_date, sum(d.use_num) as usenum";
	                   //if(Integer.parseInt(DevUtil.getCurrentYear()) > Integer.parseInt(startDate.substring(0,4))){
	                	//   rateSql += " from gms_device_dailyhistory"+"_"+startDate.substring(0,4)+" d";
	           		   //}else{
	           			   rateSql += " from gms_device_dailyhistory d";
	           		   //}
	           rateSql += " left join dms_device_tree dr on dr.device_code = d.device_type"	                   
	                   + " where d.bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
	                   + " and d.account_stat = '"+DevConstants.DEV_ACCOUNT_BAOFEI+"'";
		if(StringUtils.isNotBlank(ifCountry)){
			if("0".equals(ifCountry)){
				rateSql += " and d.country = '"+DevConstants.DEV_IFCOUNTRY_GUONEI+"'";
			}else if("1".equals(ifCountry)){
				rateSql += " and d.country = '"+DevConstants.DEV_IFCOUNTRY_GUOWAI+"'";
			}else{
				rateSql += " and ( d.country = '"+DevConstants.DEV_IFCOUNTRY_GUONEI+"'"
						 + " or d.country = '"+DevConstants.DEV_IFCOUNTRY_GUOWAI+"' )";
			}
		}
		if(StringUtils.isNotBlank(ownSubId)){
         	rateSql += " and d.org_subjection_id like '"+ownSubId+"%'";
        }
		if(StringUtils.isNotBlank(devType)){
         	rateSql += " and dr.dev_tree_id like '"+devType+"%'";
        }
		rateSql += " group by d.his_date) t on dh.his_date = t.his_date"
                 + " where dh.account_stat = '"+DevConstants.DEV_ACCOUNT_ZAIZHANG+"'"
                 + " and dh.ifproduction = '"+DevConstants.DEV_PRODUCTION_YES+"'"
                 + " and dh.bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
                 + " and dh.his_date >= to_date('"+startDate+"', 'yyyy-mm-dd')"
                 + " and dh.his_date <= to_date('"+endDate+"', 'yyyy-mm-dd')";
        if(StringUtils.isNotBlank(ifCountry)){
         	if("0".equals(ifCountry)){
         		rateSql += " and dh.country = '"+DevConstants.DEV_IFCOUNTRY_GUONEI+"'";
         	}else if("1".equals(ifCountry)){
         		rateSql += " and dh.country = '"+DevConstants.DEV_IFCOUNTRY_GUOWAI+"'";
         	}else{
         		rateSql += " and ( dh.country = '"+DevConstants.DEV_IFCOUNTRY_GUONEI+"'"
         						 + " or dh.country = '"+DevConstants.DEV_IFCOUNTRY_GUOWAI+"' )";
         	}
         }
         if(StringUtils.isNotBlank(ownSubId)){
         	rateSql += " and dh.org_subjection_id like '"+ownSubId+"%'";
         }
         if(StringUtils.isNotBlank(devType)){
          	rateSql += " and dt.dev_tree_id like '"+devType+"%'";
         }
                 
        rateSql += " group by dh.his_date,t.usenum order by dh.his_date";
		return rateSql;
	}
}

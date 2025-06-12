package com.bgp.dms.assess;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import com.bgp.dms.assess.IServ.IAssessNodeServ;
import com.bgp.dms.assess.IServ.IReportMarkServ;
import com.bgp.dms.assess.IServ.IReportServ;
import com.bgp.dms.assess.IServ.ITemplateServ;
import com.bgp.dms.assess.IServ.impl.AssessNodeServ;
import com.bgp.dms.assess.IServ.impl.AssessNodeServ2;
import com.bgp.dms.assess.model.AssessBorad;
import com.bgp.dms.assess.model.AssessInfo;
import com.bgp.dms.assess.model.TemplateInfo;
import com.bgp.dms.assess.util.AssessTools;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
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

/**
 * project: 设备体系信息化建设
 * 
 * creator: gaoyunpeng
 * 
 * creator time:2015-9-7
 * 
 * description:考核查询相关服务
 * 
 */
@Service("AssessPlatServ")
public class AssessPlatServ extends BaseService {
	public AssessPlatServ() {

		log = LogFactory.getLogger(AssessPlatServ.class);
		log.info("AssessPlatServ init");
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IAssessNodeServ assessNodeServ = new AssessNodeServ();
	private IAssessNodeServ assessNodeServ2 = new AssessNodeServ2();
	private ITemplateServ templateServ;
	private IReportServ reportServ;
	private IReportMarkServ reportMarkServ;

	public ISrvMsg findBoardBySheetID(ISrvMsg msg) throws Exception {
		log.info("findBoardBySheetID");
		StringBuffer htmlBuffer = new StringBuffer();
		htmlBuffer
				.append("<html><body><table border='1' bgcolor='#ffffcc'><tr>");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String sheetID = msg.getValue("sheetID");
		sheetID = "3";
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		AssessBorad assessBorad = assessNodeServ2.createBoradBySheetID(sheetID);
		List cList = assessBorad.getColumnHeadList();
		for (Iterator iterator = cList.iterator(); iterator.hasNext();) {
			Map<String, Object> map = (Map<String, Object>) iterator.next();
			String name = AssessTools.valueOf(map.get("HEADNAME"), "");
			htmlBuffer.append("<td>").append(name).append("</td>");
		}
		htmlBuffer.append("</tr>");
		List lList = assessBorad.getLineList();

		for (Iterator iterator = lList.iterator(); iterator.hasNext();) {
			Map<String, List> map = (Map<String, List>) iterator.next();
			java.util.Set<String> lkeys = map.keySet();
			htmlBuffer.append("<tr>");
			for (Iterator iterator2 = lkeys.iterator(); iterator2.hasNext();) {

				String lineID = (String) iterator2.next();
				System.out.println("lineID=" + lineID);
				Map<String, Object> headMap = assessNodeServ2
						.findHeadByID(lineID);
				String lineName = AssessTools.valueOf(headMap.get("HEADNAME"),
						"");
				htmlBuffer.append("<td>").append(lineName);
				htmlBuffer.append("</td>");
				List contentList = assessNodeServ2.findContentByLineID(lineID);
				for (Iterator iterator4 = cList.iterator(); iterator4.hasNext();) {
					Map<String, Object> c_map = (Map<String, Object>) iterator4
							.next();
					String columnID = AssessTools.valueOf(c_map.get("HEADID"),
							"");
					for (Iterator iterator3 = contentList.iterator(); iterator3
							.hasNext();) {
						Map m = (Map) iterator3.next();

						String content = AssessTools.valueOf(m.get("CONTENT"),
								"");
						String cid = AssessTools.valueOf(m.get("COLUMID"), "");
						if (cid.equals(columnID)) {
							htmlBuffer.append("<td>");
							htmlBuffer.append(content);
							htmlBuffer.append("</td>");
						}
					}

				}

			}
			htmlBuffer.append("</tr>");
		}
		htmlBuffer.append("</body></html>");
		responseDTO.setValue("result", htmlBuffer.toString());
		System.out.println(htmlBuffer.toString());
		return responseDTO;
	}

	/**
	 * 使用 Map按key进行排序
	 * 
	 * @param map
	 * @return
	 */
	public static Map<String, String> sortMapByKey(Map<String, String> map) {
		if (map == null || map.isEmpty()) {
			return null;
		}
		Map<String, String> sortMap = new java.util.TreeMap<String, String>(
				new com.bgp.dms.assess.MapKeyComparator());
		sortMap.putAll(map);
		return sortMap;
	}

	/**
	 * 查找所有根节点列表
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRootAssessList(ISrvMsg msg) throws Exception {
		log.info("queryRootAssessList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String assessname = msg.getValue("assessname");// 考核名称
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dms.assessid,dms.assessname,info.org_name as create_org_name,"
				+ " emp.employee_name as creator_name,dms.create_date"
				+ " from dms_assess_plat_tree dms "
				+ " left join comm_org_information info on dms.create_org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_human_employee emp on dms.creater = emp.employee_id and emp.bsflag = '0'"
				+ " where dms.bsflag = '0' and dms.nodelevel='"
				+ DevConstants.DMS_ASSESS_PLAT_LEVEL_0 + "' ");
		// 指标名称
		if (StringUtils.isNotBlank(assessname)) {
			querySql.append(" and dms.assessname like '%" + assessname + "%'");
		}
		querySql.append(" order by create_date desc");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * 查找所有SHEET节点列表
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySheetAssessList(ISrvMsg msg) throws Exception {
		log.info("querySheetAssessList");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sheetname = msg.getValue("sheetname");// SHEET名称
		String assessname = msg.getValue("assessname");// 考核名称
		String title = msg.getValue("title");// 标题名称
		StringBuffer querySql = new StringBuffer();
		querySql.append("select plat.assessname,dms.assessid,dms.assessname as sheetname,dms.title,"
				+ " info.org_name as create_org_name,emp.employee_name as creator_name,dms.create_date"
				+ " from dms_assess_plat_tree dms"
				+ " left join comm_org_information info on dms.create_org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_human_employee emp on dms.creater = emp.employee_id and emp.bsflag = '0'"
				+ " left join dms_assess_plat_tree plat on dms.rootid = plat.assessid and plat.bsflag = '0'"
				+ " where dms.bsflag = '0' and dms.nodetypes = '"
				+ DevConstants.DMS_ASSESS_PLAT_NOTE_S + "' ");
		// SHEET名称
		if (StringUtils.isNotBlank(sheetname)) {
			querySql.append(" and dms.assessname like '%" + sheetname + "%'");
		}
		// 考核名称
		if (StringUtils.isNotBlank(assessname)) {
			querySql.append(" and plat.assessname like '%" + assessname + "%'");
		}
		// 标题名称
		if (StringUtils.isNotBlank(title)) {
			querySql.append(" and dms.title like '%" + title + "%'");
		}
		querySql.append(" order by create_date desc");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	public ISrvMsg findSheetList(ISrvMsg msg) throws Exception {
		log.info("queryRootAssessList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		// List<AssessInfo> list = assessNodeServ.findRootList();
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		StringBuffer querySql = new StringBuffer();
		querySql.append("select tt.ASSESSID as assessid,tt.TITLE as title,tt.ASSESSNAME as assessname,");
		querySql.append("tt.creater as creater,info.org_name as create_org_name,emp.employee_name as creator_name,");
		querySql.append(" tt.CREATER as creater,tt.CREATE_DATE as create_date,tt.create_org_id as create_org_id, ");
		querySql.append("t0.assessname as rootName from (select t.ASSESSID as ASSESSID,t.TITLE as title, ");
		querySql.append(" t.ASSESSNAME as ASSESSNAME,t.REMARKS as REMARKS,t.CREATE_ORG_ID as create_org_id, ");
		querySql.append(" t.CREATE_DATE as CREATE_DATE,t.creater as creater,tr.superiorId as rootId   ");
		querySql.append(" from DMS_ASSESS_plat_Tree t,DMS_ASSESS_PLAT_RELAX tr where t.ASSESSID = tr.ASSESSID and t.nodetypes='S'  ");
		querySql.append(" order by t.create_date desc) tt left join DMS_ASSESS_plat_Tree t0 ");
		querySql.append("on t0.assessid = tt.rootid left join comm_org_information info  ");
		querySql.append("on tt.create_org_id = info.org_id and info.bsflag = '0' left join ");
		querySql.append("comm_human_employee emp on tt.creater = emp.employee_id and emp.bsflag = '0'");
		log.info("querySql=" + querySql);
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * 创建根节点,即对应excel文件名称的考核主题
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRootAssess(ISrvMsg msg) throws Exception {
		log.info("saveRootAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		log.info("user=" + user);
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		assessInfo.setLevel(0);
		assessInfo.setIsLeaf(false);
		assessInfo.setIsRoot(true);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("R");
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setCREATER(employee_id);
		assessInfo.setAssessInfoName(assessName);
		assessNodeServ.saveAssess(assessInfo);
		return responseDTO;
	}

	/**
	 * 创建根节点,即对应excel文件名称的考核主题
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRootAssessInfo(ISrvMsg msg) throws Exception {
		log.info("saveRootAssessInfo");
		// 1.获得基本信息
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		String assessid = msg.getValue("assessid");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// 当前登录用户的ID
		String employee_id = user.getEmpId();
		if (assessid != null && !"".equals(assessid)) {
			mainMap.put("assessid", assessid);
			mainMap.put("assesscode", "");
			mainMap.put("assessname", msg.getValue("assessName"));
			mainMap.put("nodetypes", DevConstants.DMS_ASSESS_PLAT_NOTE_R);
			mainMap.put("nodelevel", DevConstants.DMS_ASSESS_PLAT_LEVEL_0);
			mainMap.put("remarks", msg.getValue("remarks"));
			mainMap.put("updator", employee_id);
			mainMap.put("modify_date", currentdate);
			mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		} else {
			mainMap.put("assesscode", "");
			mainMap.put("assessname", msg.getValue("assessName"));
			mainMap.put("nodetypes", DevConstants.DMS_ASSESS_PLAT_NOTE_R);
			mainMap.put("nodelevel", DevConstants.DMS_ASSESS_PLAT_LEVEL_0);
			mainMap.put("remarks", msg.getValue("remarks"));
			mainMap.put("creater", employee_id);
			mainMap.put("create_date", currentdate);
			mainMap.put("create_org_id", user.getCodeAffordOrgID());
			mainMap.put("updator", employee_id);
			mainMap.put("modify_date", currentdate);
			mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		}
		jdbcDao.saveOrUpdateEntity(mainMap, "dms_assess_plat_tree");
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}

	/**
	 * 修改根节点,即对应excel文件名称的考核主题
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateRootAssess(ISrvMsg msg) throws Exception {
		log.info("updateRootAssess");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		String assessid = AssessTools.valueOf(msg.getValue("assessid"), "");
		assessInfo.setAssessInfoID(assessid);
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		assessInfo.setAssessInfoName(assessName);
		assessInfo.setLevel(0);
		assessInfo.setIsLeaf(false);
		assessInfo.setIsRoot(true);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("R");
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setUPDATOR(employee_id);
		assessNodeServ.updateAssess(assessInfo);
		return responseDTO;
	}

	/**
	 * 创建考核大项，即对应excel的sheet
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSheetAssess(ISrvMsg msg) throws Exception {
		log.info("saveSheetAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String rootID = AssessTools.valueOf(msg.getValue("rootID"), "");
		AssessInfo rootAssessInfo = assessNodeServ.findRootAssess(rootID);
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(rootAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setLevel(rootAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(true);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsColHeader(false);
		assessInfo.setIsSheet(true);
		assessInfo.setNodetypes("S");
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setCREATER(employee_id);
		assessInfo.setAssessInfoName(assessName);
		int displayOrder = Integer.parseInt(AssessTools.valueOf(
				msg.getValue("displayOrder"), "0"));
		assessInfo.setDisplayOrder(displayOrder);
		assessNodeServ.saveAssess(assessInfo);
		return responseDTO;
	}

	/**
	 * 修改考核大项，即对应excel的sheet
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateSheetAssess(ISrvMsg msg) throws Exception {
		log.info("updateSheetAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String rootID = AssessTools.valueOf(msg.getValue("rootID"), "");
		AssessInfo rootAssessInfo = assessNodeServ.findRootAssess(rootID);
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(rootAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		String assessid = AssessTools.valueOf(msg.getValue("assessid"), "");
		assessInfo.setAssessInfoID(assessid);
		assessInfo.setLevel(rootAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(true);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsColHeader(false);
		assessInfo.setIsSheet(true);
		assessInfo.setNodetypes("S");
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setUPDATOR(employee_id);
		assessInfo.setAssessInfoName(assessName);
		int displayOrder = Integer.parseInt(AssessTools.valueOf(
				msg.getValue("displayOrder"), "0"));
		assessInfo.setDisplayOrder(displayOrder);
		assessNodeServ.updateAssess(assessInfo);
		return responseDTO;
	}

	/**
	 * 创建excel中sheet的列数据表头节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveColHeaderAssess(ISrvMsg msg) throws Exception {
		log.info("saveColHeaderAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String sheetID = AssessTools.valueOf(msg.getValue("sheetID"), "");
		AssessInfo sheetAssessInfo = assessNodeServ.findAssessByID(sheetID);
		AssessInfo rootAssessInfo = sheetAssessInfo.getRootNode();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		assessInfo.setLevel(sheetAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(true);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsColHeader(true);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("B");
		assessInfo.setExcelType("H");
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(sheetAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setCREATER(employee_id);
		assessInfo.setAssessInfoName(assessName);
		int displayOrder = Integer.parseInt(AssessTools.valueOf(
				msg.getValue("displayOrder"), "0"));
		assessInfo.setDisplayOrder(displayOrder);
		assessNodeServ.saveAssess(assessInfo);
		assessNodeServ.changeLeafToBranch(sheetID);
		return responseDTO;
	}

	/**
	 * 修改excel中sheet的列数据表头节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateColHeaderAssess(ISrvMsg msg) throws Exception {
		log.info("saveColHeaderAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String sheetID = AssessTools.valueOf(msg.getValue("sheetID"), "");
		AssessInfo sheetAssessInfo = assessNodeServ.findAssessByID(sheetID);
		AssessInfo rootAssessInfo = sheetAssessInfo.getRootNode();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		String assessid = AssessTools.valueOf(msg.getValue("assessid"), "");
		assessInfo.setAssessInfoID(assessid);
		assessInfo.setLevel(sheetAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(true);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsColHeader(true);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("B");
		assessInfo.setExcelType("H");
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(sheetAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setUPDATOR(employee_id);
		assessInfo.setAssessInfoName(assessName);
		int displayOrder = Integer.parseInt(AssessTools.valueOf(
				msg.getValue("displayOrder"), "0"));
		assessInfo.setDisplayOrder(displayOrder);
		assessNodeServ.updateAssess(assessInfo);
		assessNodeServ.changeLeafToBranch(sheetID);
		return responseDTO;
	}

	/**
	 * 创建excel中sheet的行数据表头节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRowHeaderAssess(ISrvMsg msg) throws Exception {
		log.info("getAssessSqlInfo");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String sheetID = AssessTools.valueOf(msg.getValue("sheetID"), "");
		AssessInfo sheetAssessInfo = assessNodeServ.findAssessByID(sheetID);
		AssessInfo rootAssessInfo = sheetAssessInfo.getRootNode();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		assessInfo.setLevel(sheetAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(false);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(true);
		assessInfo.setIsColHeader(false);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("B");
		assessInfo.setExcelType("L");
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(sheetAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setCREATER(employee_id);
		assessInfo.setAssessInfoName(assessName);
		int displayOrder = Integer.parseInt(AssessTools.valueOf(
				msg.getValue("displayOrder"), "0"));
		assessInfo.setDisplayOrder(displayOrder);
		assessNodeServ.saveAssess(assessInfo);
		assessNodeServ.changeLeafToBranch(sheetID);
		return responseDTO;
	}

	/**
	 * 创建excel中sheet的行数据表头节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateRowHeaderAssess(ISrvMsg msg) throws Exception {
		log.info("getAssessSqlInfo");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String sheetID = AssessTools.valueOf(msg.getValue("sheetID"), "");
		AssessInfo sheetAssessInfo = assessNodeServ.findAssessByID(sheetID);
		AssessInfo rootAssessInfo = sheetAssessInfo.getRootNode();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		String assessid = AssessTools.valueOf(msg.getValue("assessid"), "");
		assessInfo.setAssessInfoID(assessid);
		assessInfo.setLevel(sheetAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(false);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(true);
		assessInfo.setIsColHeader(false);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("B");
		assessInfo.setExcelType("L");
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(sheetAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setUPDATOR(employee_id);
		assessInfo.setAssessInfoName(assessName);
		int displayOrder = Integer.parseInt(AssessTools.valueOf(
				msg.getValue("displayOrder"), "0"));
		assessInfo.setDisplayOrder(displayOrder);
		assessNodeServ.updateAssess(assessInfo);
		assessNodeServ.changeLeafToBranch(sheetID);
		return responseDTO;
	}

	/**
	 * 创建excel中sheet的行数据节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveContentAssess(ISrvMsg msg) throws Exception {
		log.info("saveContentAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String colHeaderID = AssessTools.valueOf(msg.getValue("colHeaderID"),
				"");
		AssessInfo colHeaderAssessInfo = assessNodeServ
				.findAssessByID(colHeaderID);

		String rowHeaderID = AssessTools.valueOf(msg.getValue("rowHeaderID"),
				"");
		AssessInfo rowHeaderAssessInfo = assessNodeServ
				.findAssessByID(rowHeaderID);

		AssessInfo rootAssessInfo = colHeaderAssessInfo.getRootNode();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		assessInfo.setLevel(rowHeaderAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(false);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsColHeader(false);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("L");
		assessInfo.setExcelType("C");
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(colHeaderAssessInfo);
		superiorAssessInfos.add(rowHeaderAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setCREATER(employee_id);
		assessInfo.setAssessInfoName(assessName);
		assessInfo.setDisplayOrder(colHeaderAssessInfo.getDisplayOrder());
		assessNodeServ.saveAssess(assessInfo);
		assessNodeServ.changeLeafToBranch(colHeaderID);
		assessNodeServ.changeLeafToBranch(rowHeaderID);
		return responseDTO;
	}

	/**
	 * 修改excel中sheet的行数据节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateContentAssess(ISrvMsg msg) throws Exception {
		log.info("saveContentAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String colHeaderID = AssessTools.valueOf(msg.getValue("colHeaderID"),
				"");
		AssessInfo colHeaderAssessInfo = assessNodeServ
				.findAssessByID(colHeaderID);
		String rowHeaderID = AssessTools.valueOf(msg.getValue("rowHeaderID"),
				"");
		AssessInfo rowHeaderAssessInfo = assessNodeServ
				.findAssessByID(rowHeaderID);
		AssessInfo rootAssessInfo = colHeaderAssessInfo.getRootNode();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		String assessid = AssessTools.valueOf(msg.getValue("assessid"), "");
		assessInfo.setAssessInfoID(assessid);
		assessInfo.setLevel(rowHeaderAssessInfo.getLevel() + 1);
		assessInfo.setRootNode(rootAssessInfo);
		assessInfo.setIsLeaf(false);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsColHeader(false);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("L");
		assessInfo.setExcelType("C");
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(colHeaderAssessInfo);
		superiorAssessInfos.add(rowHeaderAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setUPDATOR(employee_id);
		assessInfo.setAssessInfoName(assessName);
		assessInfo.setDisplayOrder(colHeaderAssessInfo.getDisplayOrder());
		assessNodeServ.saveAssess(assessInfo);
		assessNodeServ.changeLeafToBranch(colHeaderID);
		assessNodeServ.changeLeafToBranch(rowHeaderID);
		return responseDTO;
	}

	/**
	 * 创建excel中sheet的行数据的下级节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSubContentAssess(ISrvMsg msg) throws Exception {
		log.info("saveSubContentAssess");
		String assessName = AssessTools.valueOf(msg.getValue("assessName"), "");
		String superiorAssessID = AssessTools.valueOf(
				msg.getValue("superiorAssessID"), "");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		AssessInfo assessInfo = new AssessInfo();
		assessInfo.setIsLeaf(false);
		assessInfo.setIsRoot(false);
		assessInfo.setIsRowHeader(false);
		assessInfo.setIsColHeader(false);
		assessInfo.setIsSheet(false);
		assessInfo.setNodetypes("L");
		assessInfo.setExcelType("C");
		double fullScore = Double.parseDouble(AssessTools.valueOf(
				msg.getValue("fullScore"), "0"));
		assessInfo.setFullScore(fullScore);
		double qualifiedScore = Double.parseDouble(AssessTools.valueOf(
				msg.getValue("QualifiedScore"), "0"));
		assessInfo.setQualifiedScore(qualifiedScore);
		AssessInfo superiorAssessInfo = assessNodeServ
				.findAssessByID(superiorAssessID);
		assessInfo.setLevel(superiorAssessInfo.getLevel() + 1);
		AssessInfo rootAssessInfo = superiorAssessInfo.getRootNode();
		assessInfo.setRootNode(rootAssessInfo);
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(superiorAssessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		assessInfo.setRemarks(AssessTools.valueOf(msg.getValue("remarks"), ""));
		assessInfo.setCREATER(employee_id);
		assessInfo.setAssessInfoName(assessName);
		assessInfo.setDisplayOrder(superiorAssessInfo.getDisplayOrder());
		assessNodeServ.saveAssess(assessInfo);
		assessNodeServ.changeLeafToBranch(superiorAssessID);
		return responseDTO;
	}

	/**
	 * 删除节点
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteAssesById(ISrvMsg msg) throws Exception {
		String assessInfoID = msg.getValue("assessInfoID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		assessNodeServ.deleteAssesById(assessInfoID);
		return responseDTO;
	}

	/**
	 * 查询下级节点集合
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findChildAssessListByID(ISrvMsg msg) throws Exception {
		String assessInfoID = msg.getValue("assessInfoID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		assessNodeServ.findChildAssessListByID(assessInfoID);
		return responseDTO;
	}

	/**
	 * 根据上级节点查询叶级节点集合
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findLeafListBySuperiorID(ISrvMsg msg) throws Exception {
		String superiorID = msg.getValue("superiorID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		Object ColsuperiorAssessInfo = new AssessInfo();
		AssessInfo assessInfo = new AssessInfo();
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		List<AssessInfo> LeafList = assessNodeServ
				.findLeafListBySuperiorID(superiorID);
		return responseDTO;
	}

	/**
	 * 根据id查询父级列头数据的列数据
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findSuperiorColHeaderInfoByID(ISrvMsg msg) throws Exception {
		String assessInfoID = msg.getValue("assessInfoID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		AssessInfo assessInfo = assessNodeServ
				.findSuperiorColHeaderInfoByID(assessInfoID);
		return responseDTO;
	}

	/**
	 * 据id查询父级列头数据的行数据
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findSuperiorRowHeaderInfoByID(ISrvMsg msg) throws Exception {
		String assessInfoID = msg.getValue("assessInfoID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		AssessInfo assessInfo = assessNodeServ
				.findSuperiorRowHeaderInfoByID(assessInfoID);
		return responseDTO;
	}

	/**
	 * 根据节点名称查询同级别下的节点对象
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findAssessByName(ISrvMsg msg) throws Exception {
		String assessInfoName = msg.getValue("assessInfoName");
		String level = AssessTools.valueOf(msg.getValue("level"), "0");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		AssessInfo assessInfo = assessNodeServ.findAssessByName(assessInfoName,
				Integer.parseInt(level));
		System.out.println("assessInfo=" + assessInfo);
		if (assessInfo != null) {
			responseDTO.setValue("assessid", assessInfo.getAssessInfoID());
			responseDTO.setValue("assessName", assessInfo.getAssessInfoName());
		}

		return responseDTO;
	}

	/**
	 * 根据模板id查询叶级集合
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findLeafListByTemplateId(ISrvMsg msg) throws Exception {
		String templateID = msg.getValue("templateID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		List<AssessInfo> leafList = assessNodeServ
				.findLeafListByTemplateId(templateID);
		return responseDTO;
	}

	/**
	 * 根据id查询根级节点对象
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findRootAssessByID(ISrvMsg msg) throws Exception {
		String assessInfoID = msg.getValue("assessInfoID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		AssessInfo assessInfo = assessNodeServ.findAssessByID(assessInfoID);
		responseDTO.setValue("assessid", assessInfoID);
		responseDTO.setValue("assessName", assessInfo.getAssessInfoName());
		responseDTO.setValue("remarks", assessInfo.getRemarks());
		return responseDTO;
	}

	/**
	 * 根据节点id查询节点对象
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findAssessByID(ISrvMsg msg) throws Exception {
		log.info("findAssessByID");
		String assessInfoID = msg.getValue("assessInfoID");
		assessInfoID = "3";
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		AssessInfo assessInfo = assessNodeServ.findAssessByID(assessInfoID);
		List<AssessInfo> superlist = assessInfo.getSuperiorAssessInfos();
		for (Iterator iterator = superlist.iterator(); iterator.hasNext();) {
			AssessInfo pAssess = (AssessInfo) iterator.next();
			String name = pAssess.getAssessInfoName();
			String excelType = pAssess.getExcelType();
			System.out.println("---------------superlist--------------");
			System.out.println("name=" + name);
			System.out.println("excelType=" + excelType);
			System.out.println("--------------superlist---------------");
		}
		List<AssessInfo> childlist = assessInfo.getChildAssessInfos();
		for (Iterator iterator = childlist.iterator(); iterator.hasNext();) {
			AssessInfo cAssess = (AssessInfo) iterator.next();
			String name = cAssess.getAssessInfoName();
			String excelType = cAssess.getExcelType();
			System.out.println("---------------childlist--------------");
			System.out.println("name=" + name);
			System.out.println("excelType=" + excelType);
			System.out.println("---------------childlist--------------");
		}
		return responseDTO;
	}

	/**
	 * 根据根节点id查询sheet级对象集合
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findSheetListByRootID(ISrvMsg msg) throws Exception {
		String rootID = msg.getValue("rootID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		List<AssessInfo> sheetList = assessNodeServ
				.getSheetListByRootID(rootID);
		return responseDTO;
	}

	/**
	 * 保存模板
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveTemplateInfo(ISrvMsg msg) throws Exception {
		String rootID = msg.getValue("rootID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		TemplateInfo templateInfo = new TemplateInfo();
		AssessInfo assessRootInfo = new AssessInfo();
		templateInfo.setAssessRootInfo(assessRootInfo);
		templateServ.saveTemplateInfo(templateInfo);
		return responseDTO;
	}

	/**
	 * 更新模板对象
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateTemplateInfo(ISrvMsg msg) throws Exception {
		String rootID = msg.getValue("rootID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		TemplateInfo templateInfo = new TemplateInfo();
		AssessInfo assessRootInfo = new AssessInfo();
		templateInfo.setAssessRootInfo(assessRootInfo);
		templateServ.updateTemplateInfo(templateInfo);
		return responseDTO;
	}

	/**
	 * 查询所有模板对象
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findAllTemplateInfoList(ISrvMsg msg) throws Exception {
		String rootID = msg.getValue("rootID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		TemplateInfo templateInfo = new TemplateInfo();
		AssessInfo assessRootInfo = new AssessInfo();
		templateInfo.setAssessRootInfo(assessRootInfo);
		List<TemplateInfo> list = templateServ.getAllTemplateInfoList();
		return responseDTO;
	}

	/**
	 * 根据id查询模板对象
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findTemplateInfoByID(ISrvMsg msg) throws Exception {
		String templateInfoID = msg.getValue("templateInfoID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		TemplateInfo templateInfo = templateServ
				.getTemplateInfoByID(templateInfoID);
		return responseDTO;
	}

	/**
	 * 根据sheet节点id，创建列级头数据集合
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg createColHeaderListBySheetID(ISrvMsg msg) throws Exception {
		String sheetID = msg.getValue("sheetID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		List<TemplateInfo> list = templateServ
				.createColHeaderListBySheetID(sheetID);
		return responseDTO;
	}

	/**
	 * 查询考核名称详细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRootAssessInfo(ISrvMsg msg) throws Exception {
		log.info("getRootAssessInfo");
		String assessid = msg.getValue("assessid");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select dms.assessid,dms.assessname,info.org_name as create_org_name,")
				.append("emp.employee_name as creator_name,dms.create_date,dms.remarks,")
				.append("dms.create_org_id,emp.employee_id ")
				.append("from dms_assess_plat_tree dms ")
				.append("left join comm_org_information info on dms.create_org_id = info.org_id and info.bsflag = '0' ")
				.append("left join comm_human_employee emp on dms.creater = emp.employee_id and emp.bsflag = '0' ")
				.append("where dms.bsflag = '0' and dms.assessid='" + assessid
						+ "' ");
		Map assessMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (assessMap != null) {
			responseDTO.setValue("assessMap", assessMap);
		}
		return responseDTO;
	}

	/**
	 * 查询SHEET详细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSheetAssessInfo(ISrvMsg msg) throws Exception {
		log.info("getSheetAssessInfo");
		String assessid = msg.getValue("assessid");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select dms.title,plat.assessname,dms.assessid,dms.assessname as sheetname,")
				.append("info.org_name as create_org_name,emp.employee_name as creator_name,")
				.append("dms.create_date,dms.remarks,dms.create_org_id,emp.employee_id ")
				.append("from dms_assess_plat_tree dms ")
				.append("left join comm_org_information info on dms.create_org_id = info.org_id and info.bsflag = '0' ")
				.append("left join comm_human_employee emp on dms.creater = emp.employee_id and emp.bsflag = '0' ")
				.append("left join dms_assess_plat_tree plat on dms.rootid = plat.assessid and plat.bsflag = '0' ")
				.append("where dms.bsflag = '0' and dms.assessid='" + assessid
						+ "' ");
		Map sheetMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (sheetMap != null) {
			responseDTO.setValue("sheetMap", sheetMap);
		}
		return responseDTO;
	}

	/**
	 * NEWMETHOD 删除考核信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delRootAssess(ISrvMsg msg) throws Exception {
		log.info("delRootAssess");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		// 当前登录用户的ID
		String employee_id = user.getEmpId();
		String delassessid = msg.getValue("delassessid");
		try {
			String delass = "update dms_assess_plat_tree set bsflag='1',updator='"
					+ employee_id
					+ "',"
					+ "modify_date=to_date('"
					+ currentdate
					+ "','yyyy-MM-dd HH24:mi:ss') where assessid in ("
					+ delassessid + ")";
			jdbcDao.executeUpdate(delass);
		} catch (Exception e) {
		}
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 保存审核要素信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAssessElementInfo(ISrvMsg msg) throws Exception {
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		String assessName = msg.getValue("assess_name");
		String assessContent = msg.getValue("assess_content");
		String assessFactDesc = msg.getValue("assess_fact_desc");
		String assessSeq = msg.getValue("assess_seq");
		String remark = msg.getValue("remark");
		String assessLevel = msg.getValue("assess_level");
		String assess_parent_id = "root".equals(msg.getValue("assess_parent_id")) ? null
				: msg.getValue("assess_parent_id");
		String assessIsLeaf = msg.getValue("assess_is_leaf");
		//当前登录用户的ID
		String employee_id = user.getEmpId();
		// 3.信息放map
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("assess_name", assessName);
		dataMap.put("assess_content", assessContent);
		dataMap.put("assess_fact_desc", assessFactDesc);
		dataMap.put("assess_level", assessLevel);
		dataMap.put("assess_parent_id", assess_parent_id);
		dataMap.put("assess_is_leaf", assessIsLeaf);
		dataMap.put("creater", employee_id);
		dataMap.put("create_date", currentdate);
		dataMap.put("create_org_id", user.getCodeAffordOrgID());
		dataMap.put("updator", employee_id);
		dataMap.put("modify_date", currentdate);
		dataMap.put("remark", remark);
		dataMap.put("assess_seq", assessSeq);
		dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		// 如果是修改界面，给device_id给带进来
		String pageAction = msg.getValue("pageAction");
		if ("modify".equals(pageAction)) {
		}
		// 4. 写入数据库
		jdbcDao.saveOrUpdateEntity(dataMap, "dms_assess_plat_elements");
		// 5. 回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("returninfo", "保存成功!");
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * 删除要素评分信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delAssessScore(ISrvMsg msg) throws Exception {
		log.info("delAssessScore");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String assessScoreId = msg.getValue("assessscoreid");
		String delFlag = "0";
		try{
			String delScore = "update dms_assess_plat_score set bsflag = '1',"
					        + " modifier = '"+user.getEmpId()+"',"
			                + " modify_date = sysdate"
					        + " where assess_score_id = '"+assessScoreId+"' ";
			jdbcDao.executeUpdate(delScore);
		}catch(Exception e){
			e.printStackTrace();
			delFlag = "3";//删除失败
		}
		//5.回写消息
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
}

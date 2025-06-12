package com.bgp.mcs.service.mat.service;

import java.io.File;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.collections.MapUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.bgp.mcs.service.mat.util.ExcelEIResolvingUtil;
import com.bgp.mcs.service.mat.util.JsonUtil;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WorkFlowBean;
import com.cnpc.demo.esb.ws.GMSHRClient;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.icg.dao.PureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;

/**
 * 作者：杨园
 * 
 * 时间：2012-6-10
 * 
 * 说明：物资管理模块后台服务操作
 */
public class MatItemSrv extends BaseService {
	private ILog log = LogFactory.getLogger(WorkFlowBean.class);
	private IJdbcDao ijdbcDao = BeanFactory.getQueryJdbcDAO();
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory
			.getBean("radJdbcDao")).getJdbcTemplate();

	/**
	 * 物资分类管理新增和修改操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateMat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		pureDao.saveOrUpdateEntity(map, "gms_mat_coding_code");
		return reqMsg;
	}

	/**
	 * 物资设置中的物资库的添加业务保存方法
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatBuss(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String father_mat_menu_id = reqDTO.getValue("fatherMatMenuId"); // 选中的节点
		String menu_name = reqDTO.getValue("menu_name");
		String order_num = reqDTO.getValue("order_num");
		String org_subjection_id = reqDTO.getValue("org_subjection_id");
		String org_id = reqDTO.getValue("org_id");
		String memo = reqDTO.getValue("memo");
		String is_leaf = reqDTO.getValue("is_leaf");
		String pagerAction = reqDTO.getValue("pagerAction");
		Map reqMap = reqDTO.toMap();
		Map map = new HashMap();
		// 调配单
		if (pagerAction != null && pagerAction.equals("edit")) {
			map.put("MAT_MENU_ID", father_mat_menu_id); // 修改本节点
		} else {
			String mat_menu_id = "";
			String sql = "select t.mat_menu_id from gms_mat_buss_menu t where t.father_mat_menu_id='"
					+ father_mat_menu_id + "' order by mat_menu_id desc";
			Map mapPK = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			if (mapPK != null && mapPK.size() != 0) {
				mat_menu_id = (String) mapPK.get("matMenuId");
				String end_str = mat_menu_id
						.substring(mat_menu_id.length() - 3);// 截取后三位
				String start_str = mat_menu_id.substring(0,
						mat_menu_id.length() - 3);// 截取后三位之前的
				end_str = Integer.parseInt(end_str) + 1 + "";
				// 新生成的主键
				if (end_str.length() == 3) {
					mat_menu_id = start_str + end_str;
				} else if (end_str.length() == 2) {
					mat_menu_id = start_str + "0" + end_str;
				} else if (end_str.length() == 1) {
					mat_menu_id = start_str + "00" + end_str;
				}
			} else {
				mat_menu_id = father_mat_menu_id + "001";
			}

			String insertSql = "insert into gms_mat_buss_menu(mat_menu_id) values('"
					+ mat_menu_id + "') ";
			jdbcDao.executeUpdate(insertSql);
			map.put("MAT_MENU_ID", mat_menu_id); // 新增记录主键
			map.put("FATHER_MAT_MENU_ID", father_mat_menu_id);
			map.put("CREATE_DATE", new Date());
			map.put("CREATOR_ID", user.getUserId());
		}
		map.put("MENU_NAME", menu_name);
		map.put("ORDER_NUM", order_num);
		map.put("ORG_SUBJECTION_ID", org_subjection_id);
		map.put("ORG_ID", org_id);
		map.put("MEMO", memo);
		map.put("IS_LEAF", is_leaf);

		map.put("BSFLAG", "0");
		map.put("MODIFI_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());

		Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_buss_menu");

		return reqMsg;
	}

	/**
	 * 物资台账查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String userId = user.getSubOrgIDofAffordOrg();
		String codeId = reqDTO.getValue("codeId");
		StringBuffer sql = new StringBuffer();
		if (!userId.equals("C105")) {
			sql.append("select * from gms_mat_infomation g where coding_code_id='"
					+ codeId
					+ "' and g.wz_id = (select wz_id from gms_mat_infomation_wtc where bsflag='0') and bsflag ='0'");
		} else {
			sql.append("select * from gms_mat_infomation where coding_code_id='"
					+ codeId + "' and bsflag='0'");
		}
		Map map = ijdbcDao.queryRecordBySQL(sql.toString());
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 构建物资树形列表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMat(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String root = reqDTO.getValue("root");
		String parentId = reqDTO.getValue("node");
		boolean ifRoot = false;
		if (parentId == null || "".equals(parentId) || "root".equals(parentId)) {
			parentId = "C105";
			ifRoot = true;
		}
		StringBuffer sqlBuffer = new StringBuffer(
				"select * from (select connect_by_root(coding_code_id) root,level cur_depth, ");
		sqlBuffer
				.append("decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(coding_code_id, '/') path, ");
		sqlBuffer
				.append("code_name,code_desc,note,coding_code_id,parent_code,parent_code zip,coding_code_id id ");
		sqlBuffer.append("from ( ");
		sqlBuffer
				.append("select * from gms_mat_coding_code c where bsflag='0' ");
		sqlBuffer.append(") ");
		sqlBuffer
				.append("start with parent_code = '"
						+ parentId
						+ "' connect by prior coding_code_id = parent_code) where cur_depth= '1'order by root");
		List list = ijdbcDao.queryRecords(sqlBuffer.toString());
		// 根节点值
		Map map = new HashMap();
		map.put("codingCodeId", "C105");
		map.put("parentCode", "self");
		map.put("codeName", "物资分类");
		map.put("description", "");
		map.put("note", "");
		map.put("expanded", "true");
		map.put("children", list);
		// // 构建jsonList
		// Map jsonMap = JsonUtil.convertListTreeToJson(list, "codingCodeId",
		// "parentCode", map);

		JSONArray retJson = null;
		if (ifRoot) {
			retJson = JSONArray.fromObject(map);
		} else {
			retJson = JSONArray.fromObject(list);
		}
		JSONArray.fromObject(map);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/**
	 * 物资库件物资详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select i.*,c.code_name from gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and c.bsflag='0' where i.wz_id='"
				+ id + "' and i.bsflag='0'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 物资台账单件物资详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select i.*,c.code_name,t.stock_num,t.actual_price from gms_mat_recyclemat_info t inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id and t.bsflag='0'and t.recyclemat_info='"
				+ id + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 物资台账单件物资详细信息查询（可重复物资）--------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatRep(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String sql = "select i.*, c.code_name, tt.stock_num, tt.actual_price,tt.total_num,tt.broken_num from (select t.wz_id, sum(t.stock_num) stock_num,sum(t.total_num) total_num,sum(t.broken_num) broken_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then 1 else sum(t.stock_num) end, 3) actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '2' and t.org_subjection_id like '"
				+ orgSubjectionId
				+ "%' group by t.wz_id) tt inner join(gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0') on tt.wz_id = i.wz_id where tt.wz_id='"
				+ id + "' order by i.coding_code_id asc, i.wz_id asc";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 代管物资调剂明细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findEscrow(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String[] ids = id.split(",");
		String planId = "";
		String detailId = "";
		if (ids.length > 1) {
			planId += id.substring(0, id.indexOf(","));
			detailId += id.substring(id.indexOf(",") + 1);
		} else {
			planId += id;
			detailId += "";
		}
		String sql = "select i.wz_name,i.wz_id,i.wz_prickie,d.actual_price,d.mat_num,d.total_money from GMS_MAT_TEAMMAT_INFO_DETAIL d inner join (select * from GMS_MAT_TEAMMAT_INVOICES t where t.invoices_id='"
				+ detailId
				+ "' and t.plan_invoice_id='"
				+ planId
				+ "'and t.bsflag='0')s on d.invoices_id=s.invoices_id and d.bsflag='0'inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0'";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 代管物资调剂单查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findEscDep(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select t.*,o.org_name,p.project_name,u.user_name from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id inner join comm_org_information o on t.org_id=o.org_id inner join gp_task_project p on t.project_info_no=p.project_info_no and t.bsflag='0'and t.plan_invoice_id='"
				+ id + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 代管物资调剂单详细查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMatEscList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		String planId = "";
		String detailId = "";
		if (ids.length > 1) {
			planId += id.substring(0, id.indexOf(","));
			detailId += id.substring(id.indexOf(",") + 1);
		} else {
			planId += id;
			detailId += "";
		}
		String sql = "select m.input_date,m.total_money,m.invoices_id,m.invoices_no,m.operator,m.create_date,m.note,m.area,t.plan_invoice_id,o.org_name,p.project_name,u.user_name,t.compile_date from gms_mat_teammat_invoices m inner join (GMS_MAT_DEMAND_PLAN_INVOICE t inner join p_auth_user u on t.creator_id=u.user_id inner join comm_org_information o on t.org_id=o.org_id inner join gp_task_project p on t.project_info_no=p.project_info_no and t.bsflag='0') on m.plan_invoice_id=t.plan_invoice_id and t.bsflag='0' where m.invoices_id='"
				+ detailId
				+ "'and t.plan_invoice_id='"
				+ planId
				+ "' and m.bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 代管物资调剂新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getEscLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String planInvoiceId = reqDTO.getValue("planInvoiceId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select m.wz_id,m.coding_code_id,m.wz_name,r.stock_num,t.plan_id,t.apply_num,t.regulate_num,t.org_subjection_id,t.org_id,u.use_num,m.wz_price from gms_mat_demand_plan t inner join (GMS_MAT_INFOMATION m left join (GMS_MAT_RECYCLEMAT_INFO r left join GMS_MAT_RECYCLE_USE_INFO u on r.recyclemat_info=u.recyclemat_info )on m.wz_id=r.wz_id and m.bsflag='0'and r.bsflag='0' )on t.wz_id=m.wz_id  and t.org_subjection_id like r.org_subjection_id||'%'  and t.plan_invoice_id='"
				+ planInvoiceId + "'and t.regulate_num>0";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 代管物资调剂修改页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findEscLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		List<Map> list = new ArrayList<Map>();
		String[] ids = id.split(",");
		String planId = "";
		String detailId = "";
		if (ids.length > 1) {
			planId += id.substring(0, id.indexOf(","));
			detailId += id.substring(id.indexOf(",") + 1);
		} else {
			planId += id;
			detailId += "";
		}
		String sql = "select i.wz_name,i.wz_id,i.wz_prickie,d.teammat_info_idetail_id,d.actual_price,d.mat_num,d.total_money,s.regulate_num,r.stock_num,r.org_subjection_id from GMS_MAT_TEAMMAT_INFO_DETAIL d inner join (select t.invoices_id, p.regulate_num, p.org_subjection_id,p.wz_id from GMS_MAT_TEAMMAT_INVOICES t  inner join gms_mat_demand_plan p on t.plan_invoice_id=p.plan_invoice_id and p.bsflag='0' and p.regulate_num>0 where t.invoices_id='"
				+ detailId
				+ "' and t.plan_invoice_id='"
				+ planId
				+ "'and t.bsflag='0')s on d.invoices_id=s.invoices_id and d.bsflag='0'inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0'  inner join gms_mat_recyclemat_info r on r.wz_id = d.wz_id and r.org_subjection_id = s.org_subjection_id and r.bsflag = '0' and r.org_subjection_id = d.org_subjection_id and r.wz_id=s.wz_id";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 代管物资调剂单保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatEscEdit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map reqMap = reqDTO.toMap();
		Map map = new HashMap();
		// 调配单
		map.put("plan_invoice_id", reqMap.get("plan_invoice_id"));
		map.put("project_info_no", reqMap.get("project_info_no"));
		map.put("invoices_no", reqMap.get("invoices_no"));
		map.put("operator", reqMap.get("operator"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("source", user.getOrgId());
		map.put("input_date", reqMap.get("input_date"));
		map.put("note", reqMap.get("note"));
		map.put("area", reqMap.get("area"));

		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("creator_id", user.getUserId());
		map.put("create_date", new Date());
		map.put("bsflag", "0");
		map.put("if_input", "1");
		map.put("invoices_type", reqMap.get("invoices_type"));
		Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_invoices");

		for (int i = 0; i < ids.length; i = i + 2) {

			String regulateNum = "regulate_num_" + ids[i + 1];
			String actualPrice = "actual_price_" + ids[i + 1];
			String totalMoney = "total_money_" + ids[i + 1];

			// 用gms_mat_demand_plan传过来的组织机构
			String orgId = "org_id_" + ids[i + 1];
			String orgSubjectionId = "org_subjection_id_" + ids[i + 1];
			// 调配单明细
			Map tidMap = new HashMap();
			tidMap.put("invoices_id", invoicesId.toString());
			tidMap.put("wz_id", ids[i]);
			tidMap.put("mat_num", reqMap.get(regulateNum));
			tidMap.put("actual_price", reqMap.get(actualPrice));
			tidMap.put("total_money", reqMap.get(totalMoney));
			tidMap.put("mat_sourth", user.getOrgId());
			tidMap.put("project_info_no", reqMap.get("project_info_no"));

			tidMap.put("org_id", reqMap.get(orgId));
			tidMap.put("org_subjection_id", reqMap.get(orgSubjectionId));
			tidMap.put("creator_id", user.getUserId());
			tidMap.put("create_date", new Date());
			tidMap.put("bsflag", "0");
			tidMap.put("if_accept", "1");
			tidMap.put("invoices_type", "4");
			pureDao.saveOrUpdateEntity(tidMap, "gms_mat_teammat_info_detail");
			// 可重复利用物资库存操作
			// String sql =
			// "select * from GMS_MAT_RECYCLEMAT_INFO g where g.wz_type='2' and g.bsflag='0'and g.wz_id='"+ids[i]+"' and g.org_subjection_id = (select org_subjection_id from bgp_comm_org_wtc w where (select org_subjection_id from gp_task_project_dynamic where project_info_no = '"+user.getProjectInfoNo()+"') like w.org_subjection_id || '%')";
			String sql = "select * from GMS_MAT_RECYCLEMAT_INFO g where g.wz_type='2' and g.bsflag='0'and g.wz_id='"
					+ ids[i]
					+ "' and '"
					+ reqMap.get(orgSubjectionId)
					+ "' like g.org_subjection_id||'%'";
			Map getMap = pureDao.queryRecordBySQL(sql);
			double num = Double.valueOf(getMap.get("stock_num").toString())
					- Double.valueOf(reqMap.get(regulateNum).toString());
			Map repMap = new HashMap();
			repMap.put("recyclemat_info", getMap.get("recyclemat_info"));
			repMap.put("stock_num", num);
			pureDao.saveOrUpdateEntity(repMap, "GMS_MAT_RECYCLEMAT_INFO");
		}

		return reqMsg;
	}

	/**
	 * 代管物资调剂单修改保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateMatEscEdit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map reqMap = reqDTO.toMap();
		Map map = new HashMap();
		// 调配单
		map.put("invoices_id", reqMap.get("invoices_id"));
		map.put("invoices_no", reqMap.get("invoices_no"));
		map.put("operator", reqMap.get("operator"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("input_date", reqMap.get("input_date"));
		map.put("note", reqMap.get("note"));

		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_invoices");
		// 调配单明细
		for (int i = 0; i < ids.length; i++) {
			String actualPrice = "actual_price_" + ids[i];
			String totalMoney = "total_money_" + ids[i];
			Map tidMap = new HashMap();
			tidMap.put("teammat_info_idetail_id", ids[i]);
			tidMap.put("actual_price", reqMap.get(actualPrice));
			tidMap.put("total_money", reqMap.get(totalMoney));

			tidMap.put("updator_id", user.getUserId());
			tidMap.put("modifi_date", new Date());
			pureDao.saveOrUpdateEntity(tidMap, "gms_mat_teammat_info_detail");

		}

		return reqMsg;
	}

	/**
	 * 物资台账入库明细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findMatIn(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select org.org_abbreviation,d.out_price,d.out_num,d.total_money,info.out_date from gms_mat_recyclemat_info t left join gms_mat_out_info_detail d on t.wz_id=d.wz_id left join gms_mat_out_info info on d.out_info_id=info.out_info_id and info.bsflag='0' and info.if_submit='1' and info.out_type='2' left join comm_org_information org on info.org_id=org.org_id where t.recyclemat_info='"
				+ id + "'";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 物资台账入库明细(可重复) ----------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findMatInRep(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String sql = "select org.org_abbreviation,d.out_price,d.out_num,d.total_money,info.out_date,d.out_info_detail_id from gms_mat_recyclemat_info t left join gms_mat_out_info_detail d on t.wz_id=d.wz_id left join gms_mat_out_info info on d.out_info_id=info.out_info_id and info.bsflag='0' and info.if_submit='1' and info.out_type='2' left join comm_org_information org on info.org_id=org.org_id where t.wz_type='2' and t.org_subjection_id=info.org_subjection_id and t.org_subjection_id like '"
				+ orgSubjectionId + "%' and t.wz_id = '" + id + "'";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 物资台账出库明细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findMatOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select * from gms_mat_recyclemat_info t where t.recyclemat_info='"
				+ id + "'";
		Map queryMap = jdbcDao.queryRecordBySQL(sql);
		String queryout = "select d.*,gp.project_name,org.org_abbreviation from gms_mat_teammat_info_detail d left join gp_task_project gp on d.project_info_no=gp.project_info_no left join comm_org_information org on d.org_id=org.org_id where d.wz_id='"
				+ queryMap.get("wz_id") + "'";
		List list = pureDao.queryRecords(queryout);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 物资台账出库明细(可重复)------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findMatOutRep(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		// String sql =
		// "select org.org_abbreviation,d.out_price,d.out_num,d.total_money,info.out_date,d.out_info_detail_id from gms_mat_recyclemat_info t left join gms_mat_out_info_detail d on t.wz_id=d.wz_id left join gms_mat_out_info info on d.out_info_id=info.out_info_id and info.bsflag='0' and info.if_submit='1' and info.out_type='2' left join comm_org_information org on info.org_id=org.org_id where t.wz_type='2' and t.org_subjection_id=info.org_subjection_id and t.org_subjection_id like '"+orgSubjectionId+"%' and t.wz_id = '"+id+"'";
		// Map queryMap = jdbcDao.queryRecordBySQL(sql);
		String queryout = "select d.*,gp.project_name,org.org_abbreviation from gms_mat_teammat_info_detail d left join gp_task_project gp on d.project_info_no=gp.project_info_no left join comm_org_information org on d.org_id=org.org_id where d.bsflag='0' and d.wz_id='"
				+ id
				+ "' and d.org_subjection_id like '"
				+ orgSubjectionId
				+ "%'";
		List list = pureDao.queryRecords(queryout);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 物资分类管理新增和修改操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();
		String codeName = map.get("coding_code_id").toString();
		String sql = "select coding_code_id from gms_mat_coding_code where code_name = '"
				+ codeName + "'";
		Map codeMap = pureDao.queryRecordBySQL(sql);
		String codingCodeId = codeMap.get("coding_code_id").toString();
		map.put("coding_code_id", codingCodeId);
		map.put("bsflag", "0");
		map.put("updator", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("new_add_creator", user.getUserId());
		map.put("new_add_date", new Date());

		pureDao.saveOrUpdateEntity(map, "gms_mat_infomation");
		return reqMsg;
	}

	/**
	 * 物资分类管理删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_infomation set bsflag = '1' where wz_id = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 物资分类管理处级删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteMatLedgerWTC(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_infomation_wtc set bsflag = '1' where wz_id = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 处级物资台账管理新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatLeafWTC(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String codeId = reqDTO.getValue("codeId");
		String mat_menu_id = reqDTO.getValue("bussId");

		System.out.println("codeIds:" + codeId);

		String[] ids = codeId.split(",");

		List<Map> list = new ArrayList<Map>();
		for (int i = 0; i < ids.length; i++) {

			System.out.println(ids[i]);
			Map map = new HashMap();
			if (ids[i].length() == 8) {
				String sql = "select * from gms_mat_infomation g where g.wz_id not in (select w.wz_id from gms_mat_buss_infomation w where w.bsflag='0' and w.mat_menu_id='"
						+ mat_menu_id
						+ "') and g.coding_code_id='"
						+ ids[i]
						+ "' and g.bsflag = '0'";
				map = pureDao.queryRecordBySQL(sql);
			} else {
				if (ids[i].length() != 0) {
					String sql = "select * from gms_mat_infomation g where g.wz_id not in (select w.wz_id from gms_mat_buss_infomation w where w.bsflag='0' and w.mat_menu_id='"
							+ mat_menu_id
							+ "') and g.coding_code_id like'"
							+ ids[i] + "%' and g.bsflag = '0'";
					List newList = pureDao.queryRecords(sql);
					for (int j = 0; j < newList.size(); j++) {
						list.add((Map) newList.get(j));
					}
				}
			}
			if (map != null) {
				list.add(map);
			}
		}
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 处级物资台账管理新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatLedgerWTC(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String mat_menu_id = reqDTO.getValue("mat_menu_id");
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			Map map = new HashMap();
			map.put("bsflag", "0");
			map.put("wz_id", ids[i]);
			map.put("mat_menu_id", mat_menu_id);
			pureDao.saveOrUpdateEntity(map, "gms_mat_buss_infomation");
		}
		return reqMsg;
	}

	/**
	 * 可重复利用物资台账管理新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepMatLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String codeId = reqDTO.getValue("codeId");

		System.out.println("codeIds:" + codeId);

		String[] ids = codeId.split(",");

		List<Map> list = new ArrayList<Map>();
		for (int i = 0; i < ids.length; i++) {

			System.out.println(ids[i]);
			Map map = new HashMap();
			if (ids[i].length() == 8) {
				String sql = "select * from gms_mat_infomation g where g.wz_id not in (select w.wz_id from GMS_MAT_RECYCLEMAT_INFO w where w.bsflag='0' ) and g.coding_code_id='"
						+ ids[i] + "' and g.bsflag = '0'";
				map = pureDao.queryRecordBySQL(sql);
			} else {
				if (ids[i].length() != 0) {
					String sql = "select * from gms_mat_infomation g where g.wz_id not in (select w.wz_id from GMS_MAT_RECYCLEMAT_INFO w where w.bsflag='0' ) and g.coding_code_id like'"
							+ ids[i] + "%' and g.bsflag = '0'";
					List newList = pureDao.queryRecords(sql);
					for (int j = 0; j < newList.size(); j++) {
						list.add((Map) newList.get(j));
					}
				}
			}
			if (map != null) {
				list.add(map);
			}
		}
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 可重复利用物资台账管理新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRepMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			Map map = new HashMap();
			map.put("bsflag", "0");
			map.put("wz_id", ids[i]);
			String stockNumId = "stock_num_" + ids[i];
			String stockNum = reqMap.get(stockNumId).toString();
			String actualPriceId = "actual_price_" + ids[i];
			String actualPrice = reqMap.get(actualPriceId).toString();
			map.put("stock_num", stockNum);
			map.put("actual_price", actualPrice);
			pureDao.saveOrUpdateEntity(map, "GMS_MAT_RECYCLEMAT_INFO");
		}
		return reqMsg;
	}

	/**
	 * 可重复利用物资台账单件物资详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select g.coding_code_id,g.wz_name,g.wz_code,g.wz_prickie,g.wz_price,g.mat_desc,g.note,t.stock_num,t.actual_price,t.recyclemat_info from gms_mat_infomation g inner join GMS_MAT_RECYCLEMAT_INFO t on g.wz_id=t.wz_id and g.bsflag='0' and t.bsflag='0'and g.wz_id='"
				+ id + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		String codingCodeId = map.get("codingCodeId").toString();
		String querysql = "select code_name from gms_mat_coding_code where coding_code_id = '"
				+ codingCodeId + "'";
		Map querymap = ijdbcDao.queryRecordBySQL(querysql);
		String codeName = querymap.get("codeName").toString();
		map.put("codingCodeId", codeName);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 可重复利用物资分类管理删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRepMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update GMS_MAT_RECYCLEMAT_INFO set bsflag = '1' where wz_id = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 可重复利用物资分类管理修改操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateRepMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();
		pureDao.saveOrUpdateEntity(map, "GMS_MAT_RECYCLEMAT_INFO");
		return reqMsg;
	}

	/**
	 * 单项目物资台账单件物资详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSingleMatLedger(ISrvMsg reqDTO) throws Exception {
		String logid = "[getSingleMatLedger]";
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		// String sql =
		// "select g.wz_id ,g.coding_code_id,g.mat_desc,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0' and g.wz_id = '"+
		// id + "'";
		StringBuffer sql = new StringBuffer();
		sql.append("select aa.wz_id," +
				"(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num," +
				"i.coding_code_id,i.wz_name,i.wz_prickie,i.note,i.wz_price,i.mat_desc from ( ");
		sql.append("select tid.wz_id,sum(tid.mat_num) mat_num " +
				"from gms_mat_teammat_invoices mti " +
				"inner join gms_mat_teammat_info_detail tid " +
				"on mti.invoices_id=tid.invoices_id and tid.bsflag='0' " +
				"where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tid.wz_id='"
				+ id
				+ "'  and mti.invoices_type<>'2' and mti.if_input='0' group by tid.wz_id ");
		sql.append(")aa left join ( ");
		sql.append("select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto " +
				"inner join gms_mat_teammat_out_detail tod " +
				"on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' " +
				"where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tod.wz_id='"
				+ id
				+ "' group by tod.wz_id ");
		sql.append(") bb on aa.wz_id=bb.wz_id " +
				"inner join gms_mat_infomation i " +
				"on aa.wz_id = i.wz_id and i.bsflag='0' " +
				"order by i.coding_code_id asc,aa.wz_id asc ");
		Map map = ijdbcDao.queryRecordBySQL(sql.toString());
		String codingCodeId = map.get("codingCodeId").toString();
		String querysql = "select code_name from gms_mat_coding_code where coding_code_id = '"
				+ codingCodeId + "'";
		log.info(logid + "sql=" + querysql);
		Map querymap = ijdbcDao.queryRecordBySQL(querysql);
		String codeName = querymap.get("codeName").toString();
		map.put("codingCodeId", codeName);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 单项目物资台账单件物资详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSingleRepMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		// String sql =
		// "select g.wz_id ,g.coding_code_id,g.mat_desc,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0' and g.wz_id = '"+
		// id + "'";
		StringBuffer sql = new StringBuffer();
		sql.append("select aa.wz_id,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,i.wz_price,i.mat_desc from ( ");
		sql.append("select tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tid.wz_id='"
				+ id
				+ "' and mti.invoices_type='2' and mti.if_input='0' group by tid.wz_id ");
		sql.append(")aa left join ( ");
		sql.append("select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tod.wz_id='"
				+ id
				+ "' group by tod.wz_id ");
		sql.append(") bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0' order by i.coding_code_id asc,aa.wz_id asc ");
		Map map = ijdbcDao.queryRecordBySQL(sql.toString());
		String codingCodeId = map.get("codingCodeId").toString();
		String querysql = "select code_name from gms_mat_coding_code where coding_code_id = '"
				+ codingCodeId + "'";
		Map querymap = ijdbcDao.queryRecordBySQL(querysql);
		String codeName = querymap.get("codeName").toString();
		map.put("codingCodeId", codeName);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 单项目物资台账单件物资详细信息查询--自采购
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSinglePurLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		// String sql =
		// "select g.wz_id ,g.coding_code_id,g.mat_desc,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0' and g.wz_id = '"+
		// id + "'";
		StringBuffer sql = new StringBuffer();
		sql.append("select aa.wz_id,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,i.wz_price,i.mat_desc from ( ");
		sql.append("select tid.wz_id,sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tid.wz_id='"
				+ id
				+ "'  and mti.invoices_type='1' and mti.if_input='0' group by tid.wz_id ");
		sql.append(")aa left join ( ");
		sql.append("select tod.wz_id,sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tod.wz_id='"
				+ id
				+ "' group by tod.wz_id ");
		sql.append(") bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0' order by i.coding_code_id asc,aa.wz_id asc ");
		Map map = ijdbcDao.queryRecordBySQL(sql.toString());
		String codingCodeId = map.get("codingCodeId").toString();
		String querysql = "select code_name from gms_mat_coding_code where coding_code_id = '"
				+ codingCodeId + "'";
		Map querymap = ijdbcDao.queryRecordBySQL(querysql);
		String codeName = querymap.get("codeName").toString();
		map.put("codingCodeId", codeName);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 小队台账新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("codeId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select * from gms_mat_demand_plan_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.submite_number='"
				+ id + "'";
		list = pureDao.queryRecords(sql);

		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 单项目物资台账自从采购管理新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveSingleMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		Map map = reqDTO.toMap();
		Map tMap = new HashMap();

		tMap.put("INVOICES_ID",
				map.get("invoices_id") == null ? "" : map.get("invoices_id")
						.toString());
		tMap.put("plan_invoice_id", map.get("plan_invoice_id").toString());
		tMap.put("procure_no", map.get("procure_no").toString());
		tMap.put("input_date", map.get("input_date").toString());
		tMap.put("operator", map.get("operator").toString());
		tMap.put("source", map.get("source").toString());
		tMap.put("vehicle_no", map.get("vehicle_no").toString());
		tMap.put("pickupgoods", map.get("pickupgoods").toString());
		tMap.put("storage", map.get("storage").toString());
		tMap.put("waybill_no", map.get("waybill_no").toString());
		tMap.put("note", map.get("note").toString());
		tMap.put("total_money", map.get("total_money").toString());
		tMap.put("supplier", map.get("supplier").toString());
		tMap.put("invoices_type", "1");
		tMap.put("if_input", "0");
		tMap.put("bsflag", "0");
		tMap.put("project_info_no", projectInfoNo);
		tMap.put("org_id", user.getOrgId());
		tMap.put("org_subjection_id", user.getOrgSubjectionId());
		tMap.put("creator_id", user.getUserId());
		tMap.put("create_date", new Date());
		// gms_mat_teammat_invoices 表新增
		Serializable invoicesId = pureDao.saveOrUpdateEntity(tMap,
				"gms_mat_teammat_invoices");

		// 删除字表中的数据
		String sqlDelete = "delete from gms_mat_teammat_info_detail where invoices_id='"
				+ invoicesId + "'";
		jdbcDao.executeUpdate(sqlDelete);

		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			Map tiMap = new HashMap();
			Map tidMap = new HashMap();
			String invoiceNum = "invoice_num_" + ids[i];
			String matNum = "mat_num_" + ids[i];
			String actualPrice = "actual_price_" + ids[i];
			String totalMoney = "total_money_" + ids[i];
			String warehouseNumber = "warehouse_number_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			String receiveNumber = "receive_number_" + ids[i];
			String giveOut = "give_out_" + ids[i];

			tidMap.put("receive_number", map.get(invoiceNum).toString());
			tidMap.put("mat_num", map.get(matNum).toString());
			tidMap.put("actual_price", map.get(actualPrice).toString());
			tidMap.put("total_money", map.get(totalMoney).toString());
			tidMap.put("warehouse_number", map.get(warehouseNumber).toString());
			tidMap.put("goods_allocation", map.get(goodsAllocation).toString());
			tidMap.put("bsflag", "0");
			tidMap.put("input_type", "0");
			tidMap.put("if_accept", "0");
			tidMap.put("wz_id", ids[i]);
			tidMap.put("project_info_no", projectInfoNo);
			tidMap.put("creator_id", user.getUserId());
			tidMap.put("org_id", user.getOrgId());
			tidMap.put("org_subjection_id", user.getOrgSubjectionId());
			tidMap.put("create_date", new Date());
			tidMap.put("invoices_id", invoicesId.toString());
			// gms_mat_teammat_info_detail表新增
			Serializable teammatInfoIdetailId = pureDao.saveOrUpdateEntity(
					tidMap, "gms_mat_teammat_info_detail");

			tiMap.put("bsflag", "0");
			tiMap.put("wz_id", ids[i]);
			tiMap.put("stock_num", map.get(matNum).toString());
			tiMap.put("actual_price", map.get(actualPrice).toString());
			tiMap.put("project_info_no", projectInfoNo);
			// 更新计划明细入库量
			String updateSql = " update gms_mat_demand_plan_detail d set d.use_num='"
					+ map.get(matNum).toString()
					+ "' where d.submite_number='"
					+ map.get("plan_invoice_id").toString()
					+ "'and d.wz_id='"
					+ ids[i] + "' ";
			jdbcDao.executeUpdate(updateSql);
			/*
			 * // gms_mat_teammat_info 表操作 String sql =
			 * "select * from gms_mat_teammat_info where wz_id = '" + ids[i] +
			 * "'"; Map smap = ijdbcDao.queryRecordBySQL(sql); if (smap == null)
			 * { pureDao.saveOrUpdateEntity(tiMap, "gms_mat_teammat_info"); }
			 * else { Double stockNum =
			 * Double.valueOf(smap.get("stockNum").toString()); stockNum +=
			 * Double.valueOf(map.get(matNum).toString()); String updateSql =
			 * "update gms_mat_teammat_info set stock_num ='" + stockNum +
			 * "' where teammat_info_id = '" +
			 * smap.get("teammatInfoId").toString() + "'";
			 * jdbcDao.executeUpdate(updateSql); }
			 * 
			 * // GMS_MAT_MATLABEl表操作
			 * 
			 * String goods_allocation = map.get(goodsAllocation).toString();
			 * String matFrame = goods_allocation.substring(0, 2); String
			 * matLevel = goods_allocation.substring(2, 4); String matPosition =
			 * goods_allocation.substring(4);
			 * if(goods_allocation.equals("")||goods_allocation.length()!=6){
			 * 
			 * } else{ matFrame = goods_allocation.substring(0, 2); matLevel =
			 * goods_allocation.substring(2, 4); matPosition =
			 * goods_allocation.substring(4); } Map mMap = new HashMap();
			 * mMap.put("wz_id", ids[i]); mMap .put("teammat_info_idetail_id",
			 * teammatInfoIdetailId .toString()); mMap.put("mat_frame",
			 * matFrame); mMap.put("mat_level", matLevel);
			 * mMap.put("mat_position", matPosition); mMap.put("creator_id",
			 * user.getUserId()); mMap.put("org_id", user.getOrgId());
			 * mMap.put("org_subjection_id", user.getOrgSubjectionId());
			 * mMap.put("create_date", new Date()); mMap.put("bsflag", "0");
			 * pureDao.saveOrUpdateEntity(mMap, "gms_mat_matlabel");
			 */
		}
		return reqMsg;
	}

	/**
	 * 订单详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPurList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String invoices_type = reqDTO.getValue("invoices_type");
		String sql = "select t.*,bz.submite_id from gms_mat_teammat_invoices t left join gms_mat_demand_plan_bz bz on t.plan_invoice_id = bz.submite_number and bz.bsflag='0' where t.project_info_no='"
				+ projectInfoNo
				+ "'and t.invoices_id='"
				+ id
				+ "'and t.bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sql);

		String input_no = "";
		if (invoices_type != null && !invoices_type.equals("")) {
			// 自动算生成单号年月日-001
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String today = sdf.format(date);
			String autoSql = "select input_no from gms_mat_teammat_invoices t where t.project_info_no='"
					+ projectInfoNo
					+ "' and t.bsflag='0' and t.invoices_type = '"
					+ invoices_type
					+ "' and t.input_no like '"
					+ today
					+ "%' order by input_no desc";
			Map autoMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					autoSql);
			if (autoMap != null && autoMap.size() != 0) {
				String input_nos = (String) autoMap.get("inputNo");
				String[] temp = input_nos.split("-");
				String nos = String.valueOf(Integer.parseInt(temp[1]) + 1);
				if (nos.length() == 1) {
					nos = "00" + nos;
				} else if (nos.length() == 2) {
					nos = "0" + nos;
				}
				input_no = today + "-" + nos;
			} else {
				input_no = today + "-001";
			}
			map.put("input_no", input_no);
		}
		reqMsg.setValue("matInfo", map);

		return reqMsg;
	}

	/**
	 * 自购单验收详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findPruList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select m.procure_no,m.input_date,t.*,c.coding_code_id,c.wz_id,c.wz_name,c.wz_prickie,c.wz_code from gms_mat_teammat_info_detail t inner join gms_mat_infomation c on t.wz_id=c.wz_id and c.bsflag='0'and t.if_accept='0' inner join gms_mat_teammat_invoices m on t.invoices_id=m.invoices_id and m.bsflag='0' where t.project_info_no='"
				+ projectInfoNo
				+ "' and t.invoices_id='"
				+ id
				+ "' and t.bsflag='0' order by c.coding_code_id asc,c.wz_id asc";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 获取自采购信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPurLeaf(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String invoicesId = reqDTO.getValue("invoicesId");
		String sql = "select i.*,t.mat_num,t.actual_price,t.total_money,t.warehouse_number,t.goods_allocation from GMS_MAT_TEAMMAT_INFO_DETAIL t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' and t.invoices_id = '"
				+ invoicesId + "'";

		List list = pureDao.queryRecords(sql);

		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 调拨订单验收
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveTrac(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String invoicesId = reqDTO.getValue("invoicesId");
		String input_no = reqDTO.getValue("input_no");
		String[] ids = id.split(",");
		/*
		 * for (int i = 0; i < ids.length; i++) { Map map = new HashMap();
		 * map.put("teammat_info_idetail_id", ids[i]); map.put("if_accept",
		 * "0"); pureDao.saveOrUpdateEntity(map, "gms_mat_teammat_info_detail");
		 * 
		 * // gms_mat_teammat_info 表操作 String getSql =
		 * "select * from gms_mat_teammat_info_detail t where t.teammat_info_idetail_id='"
		 * + ids[i] + "'"; Map getMap = pureDao.queryRecordBySQL(getSql); Map
		 * tiMap = new HashMap(); tiMap.put("bsflag", "0"); tiMap.put("wz_id",
		 * getMap.get("wz_id")); tiMap.put("stock_num", getMap.get("mat_num"));
		 * tiMap.put("actual_price", getMap.get("actual_price"));
		 * tiMap.put("is_recyclemat", "1"); tiMap.put("project_info_no",
		 * projectInfoNo); tiMap.put("org_id", user.getOrgId());
		 * tiMap.put("org_sbujection_id", user.getOrgSubjectionId());
		 * tiMap.put("creator_id", user.getUserId()); tiMap.put("create_date",
		 * new Date());
		 * 
		 * 
		 * String sql = "select * from gms_mat_teammat_info t where t.wz_id = '"
		 * + getMap.get("wz_id").toString() +
		 * "' and  t.project_info_no='"+user.getProjectInfoNo()+"'"; Map smap =
		 * ijdbcDao.queryRecordBySQL(sql); if (smap == null) {
		 * pureDao.saveOrUpdateEntity(tiMap, "gms_mat_teammat_info"); } else {
		 * Double stockNum = Double.valueOf(smap.get("stockNum").toString());
		 * stockNum += Double.valueOf(getMap.get("mat_num").toString()); String
		 * updateSql = "update gms_mat_teammat_info t set t.stock_num ='" +
		 * stockNum + "' where t.teammat_info_id = '" +
		 * smap.get("teammatInfoId").toString() +
		 * "' and t.project_info_no='"+user.getProjectInfoNo()+"'";
		 * jdbcDao.executeUpdate(updateSql); } }
		 */
		String sql = "update gms_mat_teammat_invoices t set t.if_input='0',t.input_no='"
				+ input_no
				+ "' where t.invoices_id='"
				+ invoicesId
				+ "'and t.project_info_no='" + projectInfoNo + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 可重复利用订单验收
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRep(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String invoicesId = reqDTO.getValue("invoicesId");
		String input_no = reqDTO.getValue("input_no");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			Map map = new HashMap();
			map.put("teammat_info_idetail_id", ids[i]);
			map.put("if_accept", "0");
			pureDao.saveOrUpdateEntity(map, "gms_mat_teammat_info_detail");

			// gms_mat_teammat_info 表操作
			String getSql = "select * from gms_mat_teammat_info_detail t where t.teammat_info_idetail_id='"
					+ ids[i] + "'";
			Map getMap = pureDao.queryRecordBySQL(getSql);
			Map tiMap = new HashMap();
			tiMap.put("bsflag", "0");
			tiMap.put("wz_id", getMap.get("wz_id"));
			tiMap.put("stock_num", getMap.get("mat_num"));
			tiMap.put("actual_price", getMap.get("actual_price"));
			tiMap.put("is_recyclemat", "0");
			tiMap.put("project_info_no", projectInfoNo);
			tiMap.put("org_id", user.getOrgId());
			tiMap.put("org_sbujection_id", user.getOrgSubjectionId());
			tiMap.put("creator_id", user.getUserId());
			tiMap.put("create_date", new Date());
			String sql = "select * from gms_mat_teammat_info t where t.wz_id = '"
					+ getMap.get("wz_id").toString()
					+ "'and t.project_info_no='"
					+ user.getProjectInfoNo()
					+ "'";
			Map smap = ijdbcDao.queryRecordBySQL(sql);
			if (smap == null) {
				pureDao.saveOrUpdateEntity(tiMap, "gms_mat_teammat_info");
			} else {
				Double stockNum = Double.valueOf(smap.get("stockNum")
						.toString());
				stockNum += Double.valueOf(getMap.get("mat_num").toString());
				String updateSql = "update gms_mat_teammat_info t set t.stock_num ='"
						+ stockNum
						+ "' where t.teammat_info_id = '"
						+ smap.get("teammatInfoId").toString()
						+ "'and t.project_info_no='"
						+ user.getProjectInfoNo()
						+ "'";
				jdbcDao.executeUpdate(updateSql);
			}
		}
		String total_money = reqDTO.getValue("total_money");
		String procure_no = reqDTO.getValue("procure_no");
		String pickupgoods = reqDTO.getValue("pickupgoods");
		String storage = reqDTO.getValue("storage");
		String note = reqDTO.getValue("note");
		String sql = "update gms_mat_teammat_invoices t set t.if_input='0',t.input_no='"
				+ input_no
				+ "',t.storage='"
				+ storage
				+ "',t.total_money='"
				+ total_money
				+ "',t.pickupgoods='"
				+ pickupgoods
				+ "',t.note='"
				+ note
				+ "',t.procure_no='"
				+ procure_no
				+ "' where t.invoices_id='"
				+ invoicesId
				+ "'and t.project_info_no='" + projectInfoNo + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 调拨订单验收修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateTrac(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String checkId = reqDTO.getValue("checkIds");

		String invoicesId = reqDTO.getValue("invoices_id");
		String input_no = reqDTO.getValue("input_no");
		String total_money = reqDTO.getValue("total_money");
		String procure_no = reqDTO.getValue("procure_no");
		String pickupgoods = reqDTO.getValue("pickupgoods");
		String storage = reqDTO.getValue("storage");
		String note = reqDTO.getValue("note");
		String sqlUpdate = "update gms_mat_teammat_invoices t set t.if_input='0',t.input_no='"
				+ input_no
				+ "',t.storage='"
				+ storage
				+ "',t.total_money='"
				+ total_money
				+ "',t.pickupgoods='"
				+ pickupgoods
				+ "',t.note='"
				+ note
				+ "',t.procure_no='"
				+ procure_no
				+ "' where t.invoices_id='"
				+ invoicesId
				+ "'and t.project_info_no='" + projectInfoNo + "'";
		jdbcDao.executeUpdate(sqlUpdate);

		String[] ids = id.split(",");
		String[] checkIds = checkId.split(",");
		for (int j = 0; j < checkIds.length; j++) {
			int i = 0;
			for (i = 0; i < ids.length; i++) {
				if (ids[i].equals(checkIds[j])) {
					Map map = new HashMap();
					map.put("teammat_info_idetail_id", ids[i]);
					map.put("if_accept", "0");
					pureDao.saveOrUpdateEntity(map,
							"gms_mat_teammat_info_detail");

					// gms_mat_teammat_info 表操作
					String getSql = "select * from gms_mat_teammat_info_detail t where t.teammat_info_idetail_id='"
							+ ids[i] + "'";
					Map getMap = pureDao.queryRecordBySQL(getSql);
					Map tiMap = new HashMap();
					tiMap.put("bsflag", "0");
					tiMap.put("wz_id", getMap.get("wz_id"));
					tiMap.put("stock_num", getMap.get("mat_num"));
					tiMap.put("actual_price", getMap.get("actual_price"));
					tiMap.put("is_recyclemat", "1");
					tiMap.put("project_info_no", projectInfoNo);
					tiMap.put("org_id", user.getOrgId());
					tiMap.put("org_sbujection_id", user.getOrgSubjectionId());
					tiMap.put("creator_id", user.getUserId());
					tiMap.put("create_date", new Date());
					String sql = "select * from gms_mat_teammat_info t where t.wz_id = '"
							+ getMap.get("wz_id").toString()
							+ "'and t.project_info_no='" + projectInfoNo + "'";
					Map smap = ijdbcDao.queryRecordBySQL(sql);
					if (smap == null) {
						pureDao.saveOrUpdateEntity(tiMap,
								"gms_mat_teammat_info");
					} else {
						Double stockNum = Double.valueOf(smap.get("stockNum")
								.toString());
						stockNum += Double.valueOf(getMap.get("mat_num")
								.toString());
						String updateSql = "update gms_mat_teammat_info t set t.stock_num ='"
								+ stockNum
								+ "' where t.teammat_info_id = '"
								+ smap.get("teammatInfoId").toString()
								+ "'and t.project_info_no='"
								+ projectInfoNo
								+ "'";
						jdbcDao.executeUpdate(updateSql);
					}
					break;
				}

			}
			if (i == ids.length) {
				String getSql = "select * from gms_mat_teammat_info_detail t where t.teammat_info_idetail_id='"
						+ checkIds[j] + "'";
				Map getMap = pureDao.queryRecordBySQL(getSql);
				if (getMap.get("if_accept").toString().equals("0")) {
					Map map = new HashMap();
					map.put("teammat_info_idetail_id", checkIds[j]);
					map.put("if_accept", "1");
					pureDao.saveOrUpdateEntity(map,
							"gms_mat_teammat_info_detail");

					// gms_mat_teammat_info 表操作
					Map tiMap = new HashMap();
					tiMap.put("bsflag", "0");
					tiMap.put("wz_id", getMap.get("wz_id"));
					tiMap.put("stock_num", getMap.get("mat_num"));
					tiMap.put("actual_price", getMap.get("actual_price"));
					tiMap.put("is_recyclemat", "1");
					tiMap.put("project_info_no", projectInfoNo);
					tiMap.put("org_id", user.getOrgId());
					tiMap.put("org_sbujection_id", user.getOrgSubjectionId());
					tiMap.put("creator_id", user.getUserId());
					tiMap.put("create_date", new Date());
					String sql = "select * from gms_mat_teammat_info t where t.wz_id = '"
							+ getMap.get("wz_id").toString()
							+ "'and t.project_info_no='" + projectInfoNo + "'";
					Map smap = ijdbcDao.queryRecordBySQL(sql);
					Double stockNum = Double.valueOf(smap.get("stockNum")
							.toString());
					stockNum -= Double
							.valueOf(getMap.get("mat_num").toString());
					String updateSql = "update gms_mat_teammat_info t set t.stock_num ='"
							+ stockNum
							+ "' where t.teammat_info_id = '"
							+ smap.get("teammatInfoId").toString()
							+ "'and t.project_info_no='" + projectInfoNo + "'";
					jdbcDao.executeUpdate(updateSql);
				}
			}
		}
		return reqMsg;
	}

	/**
	 * 物资退货信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRetPur(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		Map reqMap = reqDTO.toMap();
		String[] ids = id.split(",");
		Map map = new HashMap();
		map.put("procure_no", reqMap.get("procure_no"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("invoices_id", reqMap.get("invoices_id"));
		map.put("out_date", reqMap.get("out_date"));
		map.put("storeroom", reqMap.get("storeroom"));
		map.put("input_org", reqMap.get("input_org"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("bsflag", "0");
		map.put("create_date", new Date());
		map.put("out_type", "1");
		map.put("project_info_no", projectInfoNo);
		map.put("creator_id", user.getUserId());
		// 新增退货单
		Serializable outInfoId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_out_info");

		Map outMap2 = new HashMap();
		outMap2.put("PLAN_INVOICE_ID", outInfoId.toString());
		outMap2.put("project_info_no", projectInfoNo);
		outMap2.put("bsflag", "0");
		outMap2.put("WZ_TYPE", "2");
		Serializable outId = pureDao.saveOrUpdateEntity(outMap2,
				"gms_mat_teammat_out");

		// 新增退货单明细
		for (int i = 0; i < ids.length; i++) {
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "actual_price_" + ids[i];
			// String getSql =
			// "select * from gms_mat_teammat_info_detail t where t.teammat_info_idetail_id='"
			// + ids[i] + "'";

			// String getSql =
			// "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,(a.stock_num*a.wz_price) total_money,a.project_info_no from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.project_info_no from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"+user.getProjectInfoNo()+"' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.project_info_no='"+user.getProjectInfoNo()+"' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"+user.getProjectInfoNo()+"' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"+user.getProjectInfoNo()+"') a where a.project_info_no='"+projectInfoNo+"' and a.wz_id='"+ids[i]+"'";
			// Map getMap = pureDao.queryRecordBySQL(getSql);
			Map oidMap = new HashMap();
			oidMap.put("out_info_id", outInfoId.toString());
			oidMap.put("wz_id", ids[i]);
			oidMap.put("out_num", reqMap.get(mat_num));
			oidMap.put("out_price", reqMap.get(actual_price));
			oidMap.put("total_money", reqMap.get(total_money));
			// oidMap.put("goods_allocation", getMap.get("goods_allocation"));
			oidMap.put("bsflag", "0");
			oidMap.put("project_info_no", projectInfoNo);
			pureDao.saveOrUpdateEntity(oidMap, "gms_mat_out_info_detail");

			Map outDetailMap2 = new HashMap();
			outDetailMap2.put("teammat_out_id", outId.toString());
			outDetailMap2.put("wz_id", ids[i]);
			outDetailMap2.put("mat_num", reqMap.get(mat_num));
			outDetailMap2.put("actual_price", reqMap.get(actual_price));
			outDetailMap2.put("total_money", reqMap.get(total_money));
			outDetailMap2.put("project_info_no", projectInfoNo);
			outDetailMap2.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap2,
					"gms_mat_teammat_out_detail");

			// 台账数据操作
			/*
			 * String sql =
			 * "select * from gms_mat_teammat_info t where t.wz_id = '" +
			 * getMap.get("wz_id").toString() +
			 * "'and t.project_info_no='"+projectInfoNo+"'"; Map smap =
			 * ijdbcDao.queryRecordBySQL(sql);
			 * 
			 * Double stockNum =
			 * Double.valueOf(smap.get("stockNum").toString()); stockNum -=
			 * Double.valueOf(reqMap.get(mat_num).toString()); String updateSql
			 * = "update gms_mat_teammat_info t set t.stock_num ='" + stockNum +
			 * "' where t.teammat_info_id = '" +
			 * smap.get("teammatInfoId").toString() +
			 * "'and t.project_info_no='"+projectInfoNo+"'";
			 * jdbcDao.executeUpdate(updateSql);
			 */
		}
		return reqMsg;
	}

	/**
	 * 退货单详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRetPur(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String sql = "select t.*,ti.procure_no procure_name from gms_mat_out_info t left join GMS_MAT_TEAMMAT_INVOICES ti on ti.invoices_id=t.procure_no and  ti.bsflag='0' where t.project_info_no='"
				+ projectInfoNo
				+ "'and t.out_info_id='"
				+ id
				+ "'and t.bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 退货物资明细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findRetPur(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select t.*,f.note,i.* from GMS_MAT_OUT_INFO f inner join (gms_mat_out_info_detail t inner join (gms_mat_infomation i) on t.wz_id = i.wz_id ) on f.out_info_id=t.out_info_id and f.out_info_id='"
				+ id
				+ "'and t.project_info_no='"
				+ projectInfoNo
				+ "'and i.bsflag='0'";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 单项目物资退货信息修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRetPurOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		// String checkId = reqDTO.getValue("checkIds");
		Map reqMap = reqDTO.toMap();
		String[] ids = id.split(",");
		// String[] checkIds = id.split(",");
		Map map = new HashMap();
		map.put("out_info_id", reqMap.get("out_info_id"));
		map.put("procure_no", reqMap.get("procure_no"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("invoices_id", reqMap.get("invoices_id"));
		map.put("out_date", reqMap.get("out_date"));
		map.put("storeroom", reqMap.get("storeroom"));
		map.put("input_org", reqMap.get("input_org"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("modifi_date", new Date());
		map.put("updator_id", user.getUserId());
		// 修改退货单
		Serializable outInfoId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_out_info");

		String sql = "select * from gms_mat_teammat_out where plan_invoice_id='"
				+ outInfoId.toString() + "'";
		Map mapOut = pureDao.queryRecordBySQL(sql);
		if (mapOut != null) {
			Map outMap2 = new HashMap();
			outMap2.put("TEAMMAT_OUT_ID", (String) mapOut.get("teammat_out_id"));
			outMap2.put("PLAN_INVOICE_ID", outInfoId.toString());
			outMap2.put("project_info_no", projectInfoNo);
			outMap2.put("bsflag", "0");
			Serializable outId = pureDao.saveOrUpdateEntity(outMap2,
					"gms_mat_teammat_out");

			String sql1 = "delete from gms_mat_out_info_detail where out_info_id='"
					+ outInfoId.toString() + "'";
			String sql2 = "delete from gms_mat_teammat_out_detail where teammat_out_id = '"
					+ outId.toString() + "'";

			jdbcDao.executeUpdate(sql1);
			jdbcDao.executeUpdate(sql2);

			// 新增退货单明细
			for (int i = 0; i < ids.length; i++) {
				String mat_num = "mat_num_" + ids[i];
				String total_money = "total_money_" + ids[i];
				String actual_price = "actual_price_" + ids[i];
				Map oidMap = new HashMap();
				oidMap.put("out_info_id", outInfoId.toString());
				oidMap.put("wz_id", ids[i]);
				oidMap.put("out_num", reqMap.get(mat_num));
				oidMap.put("out_price", reqMap.get(actual_price));
				oidMap.put("total_money", reqMap.get(total_money));
				// oidMap.put("goods_allocation",
				// getMap.get("goods_allocation"));
				oidMap.put("bsflag", "0");
				oidMap.put("project_info_no", projectInfoNo);
				pureDao.saveOrUpdateEntity(oidMap, "gms_mat_out_info_detail");

				Map outDetailMap2 = new HashMap();
				outDetailMap2.put("teammat_out_id", outId.toString());
				outDetailMap2.put("wz_id", ids[i]);
				outDetailMap2.put("mat_num", reqMap.get(mat_num));
				outDetailMap2.put("actual_price", reqMap.get(actual_price));
				outDetailMap2.put("total_money", reqMap.get(total_money));
				outDetailMap2.put("project_info_no", projectInfoNo);
				outDetailMap2.put("bsflag", "0");
				pureDao.saveOrUpdateEntity(outDetailMap2,
						"gms_mat_teammat_out_detail");
			}
		}

		/*
		 * for (int j = 0; j < checkIds.length; j++) { int i = 0; for (i = 0; i
		 * < ids.length; i++) { if (ids[i].equals(checkIds[j])) { String getSql
		 * =
		 * "select * from gms_mat_teammat_info_detail t where t.teammat_info_idetail_id='"
		 * + ids[i] + "'"; Map getMap = pureDao.queryRecordBySQL(getSql); String
		 * getInfSql =
		 * "select * from gms_mat_out_info_detail t where t.out_info_id='"
		 * +reqMap
		 * .get("out_info_id").toString()+"'and t.wz_id='"+getMap.get("wz_id"
		 * ).toString()+"' and t.bsflag='0'"; Map getInfmap =
		 * pureDao.queryRecordBySQL(getInfSql); String getOutSql =
		 * "select * from gms_mat_teammat_out_detail t where t.teammat_out_id='"
		 * +
		 * outId.toString()+"' and bsflag='0' and t.wz_id ='"+getMap.get("wz_id"
		 * )+"'"; Map getOutmap = pureDao.queryRecordBySQL(getOutSql);
		 * //判断退货明细表是否为空 if(getInfmap==null){ String mat_num =
		 * "mat_num_"+ids[i]; String total_money = "total_money_"+ids[i]; String
		 * actual_price = "actual_price_"+ids[i]; Map oidMap = new HashMap();
		 * oidMap.put("out_info_id", reqMap.get("out_info_id"));
		 * oidMap.put("wz_id", getMap.get("wz_id")); oidMap.put("out_num",
		 * reqMap.get(mat_num)); oidMap.put("out_price",
		 * reqMap.get(actual_price));
		 * oidMap.put("total_money",reqMap.get(total_money));
		 * oidMap.put("goods_allocation", getMap.get("goods_allocation"));
		 * oidMap.put("project_info_no", projectInfoNo); oidMap.put("bsflag",
		 * "0"); pureDao.saveOrUpdateEntity(oidMap, "gms_mat_out_info_detail");
		 * 
		 * 
		 * Map outDetailMap2 = new HashMap();
		 * outDetailMap2.put("teammat_out_id", outId.toString());
		 * outDetailMap2.put("wz_id", getMap.get("wz_id"));
		 * outDetailMap2.put("mat_num",reqMap.get(mat_num));
		 * outDetailMap2.put("actual_price",reqMap.get(actual_price) );
		 * outDetailMap2.put("total_money",reqMap.get(total_money) );
		 * outDetailMap2.put("project_info_no", projectInfoNo);
		 * outDetailMap2.put("bsflag", "0");
		 * pureDao.saveOrUpdateEntity(outDetailMap2
		 * ,"gms_mat_teammat_out_detail");
		 * 
		 * 
		 * // 台账数据操作
		 * 
		 * // String sql = "select * from gms_mat_teammat_info where wz_id = '"
		 * // + getMap.get("wz_id").toString() + "'"; // Map smap =
		 * ijdbcDao.queryRecordBySQL(sql); // // Double stockNum =
		 * Double.valueOf(smap.get("stockNum").toString()); // stockNum -=
		 * Double.valueOf(reqMap.get(mat_num).toString()); // String updateSql =
		 * "update gms_mat_teammat_info set stock_num ='" // + stockNum +
		 * "' where teammat_info_id = '" // +
		 * smap.get("teammatInfoId").toString() + "'"; //
		 * jdbcDao.executeUpdate(updateSql); } else{ Map oidMap = new HashMap();
		 * String mat_num = "mat_num_"+ids[i]; String total_money =
		 * "total_money_"+ids[i]; String actual_price = "actual_price_"+ids[i];
		 * oidMap.put("out_info_detail_id",
		 * getInfmap.get("out_info_detail_id")); oidMap.put("out_num",
		 * reqMap.get(mat_num)); oidMap.put("out_price",
		 * reqMap.get(actual_price));
		 * oidMap.put("total_money",reqMap.get(total_money));
		 * pureDao.saveOrUpdateEntity(oidMap, "gms_mat_out_info_detail");
		 * 
		 * if(getOutmap!=null){ Map outDetailMap2 = new HashMap();
		 * outDetailMap2.put("OUT_DETAIL_ID", getOutmap.get("out_detail_id"));
		 * outDetailMap2.put("teammat_out_id", outId.toString());
		 * outDetailMap2.put("wz_id", getMap.get("wz_id"));
		 * outDetailMap2.put("mat_num",reqMap.get(mat_num));
		 * outDetailMap2.put("actual_price",reqMap.get(actual_price) );
		 * outDetailMap2.put("total_money",reqMap.get(total_money) );
		 * outDetailMap2.put("project_info_no", projectInfoNo);
		 * outDetailMap2.put("bsflag", "0");
		 * pureDao.saveOrUpdateEntity(outDetailMap2
		 * ,"gms_mat_teammat_out_detail"); } // 台账数据操作 // String sql =
		 * "select * from gms_mat_teammat_info t where t.wz_id = '" // +
		 * getMap.get("wz_id").toString() +
		 * "'and t.project_info_no='"+projectInfoNo+"'"; // Map smap =
		 * ijdbcDao.queryRecordBySQL(sql); // // Double stockNum =
		 * Double.valueOf
		 * (smap.get("stockNum").toString()==""?"0":smap.get("stockNum"
		 * ).toString()); // stockNum +=
		 * Double.valueOf(getInfmap.get("out_num").toString()); // stockNum -=
		 * Double.valueOf(reqMap.get(mat_num).toString()); // String updateSql =
		 * "update gms_mat_teammat_info t set t.stock_num ='" // + stockNum +
		 * "' where t.teammat_info_id = '" // +
		 * smap.get("teammatInfoId").toString() +
		 * "'and t.project_info_no='"+projectInfoNo+"'"; //
		 * jdbcDao.executeUpdate(updateSql); } break; }
		 * 
		 * } // if (i == ids.length) { // String getSql =
		 * "select * from gms_mat_teammat_info_detail t where t.teammat_info_idetail_id='"
		 * + ids[i] + "'and t.project_info_no='"+projectInfoNo+"'"; // Map
		 * getMap = pureDao.queryRecordBySQL(getSql); // String getInfSql =
		 * "select * from gms_mat_out_info_detail t where t.out_info_id='"
		 * +reqMap
		 * .get("out_info_id").toString()+"'and t.wz_id='"+getMap.get("wz_id"
		 * ).toString()+"' and bsflag='0'"; // Map getInfmap =
		 * pureDao.queryRecordBySQL(getInfSql); // if(getInfmap !=null){ //
		 * String Infsql=
		 * "update gms_mat_out_info_detail set bsflag='1' where out_info_detail_id='"
		 * +getInfmap.get("out_info_detail_id").toString()+"'"; //
		 * jdbcDao.executeUpdate(Infsql); // // 台账数据操作 // // String sql =
		 * "select * from gms_mat_teammat_info t where t.wz_id = '" // +
		 * getMap.get("wz_id").toString() +
		 * "'and t.project_info_no='"+projectInfoNo+"'"; // Map smap =
		 * ijdbcDao.queryRecordBySQL(sql); // // Double stockNum =
		 * Double.valueOf(smap.get("stockNum").toString()); // stockNum +=
		 * Double.valueOf(getInfmap.get("out_num").toString()); // String
		 * updateSql = "update gms_mat_teammat_info t set t.stock_num ='" // +
		 * stockNum + "' where t.teammat_info_id = '" // +
		 * smap.get("teammatInfoId").toString() +
		 * "'and t.project_info_no='"+projectInfoNo+"'"; //
		 * jdbcDao.executeUpdate(updateSql); // } // } } }
		 */
		return reqMsg;
	}

	/**
	 * 物资发放信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveGrant(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqMap.get("laborId").toString();
		String[] ids = id.split(",");
		String data = reqMap.get("data").toString();
		String[] datas = data.split(",");
		for (int m = 1; m < datas.length; m++) {
			String teammatInfoIdetailId = datas[m].substring(0,
					datas[m].indexOf(":"));
			String outNum = datas[m].substring(datas[m].indexOf(":") + 1);
			Map tmap = new HashMap();
			String tisql = "select d.out_num from gms_mat_teammat_info_detail d where d.teammat_info_idetail_id='"
					+ teammatInfoIdetailId + "'";
			Map timap = pureDao.queryRecordBySQL(tisql);
			if (timap.get("out_num").toString().equals("")
					|| timap.get("out_num") == null) {
				tmap.put("teammat_info_idetail_id", teammatInfoIdetailId);
				tmap.put("out_num", outNum);
				pureDao.saveOrUpdateEntity(tmap, "gms_mat_teammat_info_detail");
			} else {
				double num = Double.valueOf(timap.get("out_num").toString());
				num += Double.valueOf(outNum);
				tmap.put("teammat_info_idetail_id", teammatInfoIdetailId);
				tmap.put("out_num", num);
				pureDao.saveOrUpdateEntity(tmap, "gms_mat_teammat_info_detail");
			}
		}
		Map map = new HashMap();
		map.put("procure_no", reqMap.get("procure_no"));
		map.put("plan_invoice_id", reqMap.get("submite_number"));
		map.put("device_use_name", reqMap.get("device_use_name"));
		map.put("status", reqMap.get("status"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("team_id", reqMap.get("s_apply_team"));
		map.put("device_id", reqMap.get("device_code"));
		map.put("dev_acc_id", reqMap.get("dev_acc_id"));
		map.put("outmat_date", reqMap.get("outmat_date"));
		map.put("drawer", reqMap.get("drawer"));
		map.put("storage", reqMap.get("storage"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("note", reqMap.get("note"));
		map.put("out_type", reqMap.get("out_type"));
		map.put("use_type", reqMap.get("plan_type"));
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("create_date", new Date());
		map.put("bsflag", "0");
		// 物资出库单据表操作
		Serializable teammatOutId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_out");
		// 物资领用明细操作
		for (int i = 0; i < ids.length; i++) {
			String getSql = "select * from gms_mat_teammat_info_detail t where t.wz_id='"
					+ ids[i] + "'";
			Map getMap = pureDao.queryRecordBySQL(getSql);
			Map todMap = new HashMap();
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "actual_price_" + ids[i];
			todMap.put("teammat_out_id", teammatOutId.toString());
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num)); // 发放数量
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("mat_sourth", getMap.get("mat_sourth"));
			todMap.put("goods_allocation", getMap.get("goods_allocation"));
			todMap.put("warehouse_number", getMap.get("warehouse_number"));
			todMap.put("plan_no", reqMap.get("device_use_name"));
			todMap.put("bsflag", "0");
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("creator_id", user.getUserId());
			todMap.put("create_date", new Date());
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_out_detail");
			// 记录出库量
			if (reqMap.get("dev_acc_id") == null) {
				String sql = "select t.use_num from gms_mat_demand_plan_detail t where t.submite_number='"
						+ reqMap.get("submite_number")
						+ "'and t.wz_id='"
						+ ids[i] + "'and t.bsflag='0'";
				Map bzmap = pureDao.queryRecordBySQL(sql);
				if (bzmap.get("use_num").toString().equals("")
						|| bzmap.get("use_num") == null) {
					String update = "update gms_mat_demand_plan_detail t set t.use_num='"
							+ reqMap.get(mat_num)
							+ "' where t.submite_number='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				} else {
					double useNum = Double.valueOf(bzmap.get("use_num")
							.toString());
					useNum += Double.valueOf(reqMap.get(mat_num).toString());
					String update = "update gms_mat_demand_plan_detail t set t.use_num='"
							+ useNum
							+ "' where t.submite_number='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				}
			} else {
				String sql = "select t.use_num from gms_mat_device_use_info_detail t where t.teammat_out_id='"
						+ reqMap.get("submite_number")
						+ "'and t.wz_id='"
						+ ids[i] + "'and t.bsflag='0'";
				Map devmap = pureDao.queryRecordBySQL(sql);
				if (devmap.get("use_num") == null
						|| devmap.get("use_num").toString().equals("")) {
					String update = "update gms_mat_device_use_info_detail t set t.use_num='"
							+ reqMap.get(mat_num)
							+ "' where t.teammat_out_id='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				} else {
					double useNum = Double.valueOf(devmap.get("use_num")
							.toString());
					useNum += Double.valueOf(reqMap.get(mat_num).toString());
					String update = "update gms_mat_device_use_info_detail t set t.use_num='"
							+ useNum
							+ "' where t.teammat_out_id='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				}
			}
			// 台账数据操作

			String sql = "select * from gms_mat_teammat_info t where t.wz_id = '"
					+ getMap.get("wz_id").toString()
					+ "'and t.project_info_no='" + projectInfoNo + "'";
			Map smap = ijdbcDao.queryRecordBySQL(sql);

			double stockNum = Double.valueOf(smap.get("stockNum").toString());
			stockNum -= Double.valueOf(reqMap.get(mat_num).toString());
			String updateSql = "update gms_mat_teammat_info t set t.stock_num ='"
					+ stockNum
					+ "' where t.teammat_info_id = '"
					+ smap.get("teammatInfoId").toString()
					+ "'and t.project_info_no='" + projectInfoNo + "'";
			jdbcDao.executeUpdate(updateSql);

		}
		// 发放完成后关闭计划
		if (reqMap.get("dev_acc_id") == null) {
			String sql = "select i.*,d.approve_num,d.use_num from GMS_MAT_DEMAND_PLAN_BZ t inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' where d.approve_num != (case when d.use_num is null then 0 else d.use_num end) and t.submite_number='"
					+ reqMap.get("submite_number")
					+ "'and t.s_apply_team='"
					+ reqMap.get("s_apply_team")
					+ "'and t.project_info_no='"
					+ projectInfoNo
					+ "' and t.bsflag='0'order by i.coding_code_id asc,i.wz_id asc";
			Map closeMap = pureDao.queryRecordBySQL(sql);
			if (closeMap == null) {
				String updateSql = "update gms_mat_demand_plan_bz t set t.if_submit='4' where t.submite_number='"
						+ reqMap.get("submite_number") + "'";
				jdbcDao.executeUpdate(updateSql);
			}
		} else {
			String sql = "select d.plan_num,d.use_num,i.* from gms_mat_teammat_out t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id where d.plan_num !=(case when d.use_num is null then 0 else d.use_num end) and t.teammat_out_id='"
					+ reqMap.get("submite_number")
					+ "' and t.project_info_no='"
					+ projectInfoNo
					+ "' and t.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";
			Map closeMap = pureDao.queryRecordBySQL(sql);
			if (closeMap == null) {
				String updateSql = "update GMS_MAT_TEAMMAT_OUT t set t.status='2' where t.teammat_out_id='"
						+ reqMap.get("submite_number") + "'";
				jdbcDao.executeUpdate(updateSql);
			}
		}
		return reqMsg;
	}

	/**
	 * 物资发放虚拟转正式
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEditGrant(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqMap.get("laborId").toString();
		String[] ids = id.split(",");
		String data = reqMap.get("data").toString();
		String[] datas = data.split(",");
		for (int m = 1; m < datas.length; m++) {
			String teammatInfoIdetailId = datas[m].substring(0,
					datas[m].indexOf(":"));
			String outNum = datas[m].substring(datas[m].indexOf(":") + 1);
			Map tmap = new HashMap();
			String tisql = "select d.out_num from gms_mat_teammat_info_detail d where d.teammat_info_idetail_id='"
					+ teammatInfoIdetailId + "'";
			Map timap = pureDao.queryRecordBySQL(tisql);
			if (timap.get("out_num").toString().equals("")
					|| timap.get("out_num") == null) {
				tmap.put("teammat_info_idetail_id", teammatInfoIdetailId);
				tmap.put("out_num", outNum);
				pureDao.saveOrUpdateEntity(tmap, "gms_mat_teammat_info_detail");
			} else {
				double num = Double.valueOf(timap.get("out_num").toString());
				num += Double.valueOf(outNum);
				tmap.put("teammat_info_idetail_id", teammatInfoIdetailId);
				tmap.put("out_num", num);
				pureDao.saveOrUpdateEntity(tmap, "gms_mat_teammat_info_detail");
			}
		}
		Map map = new HashMap();
		map.put("teammat_out_id", reqMap.get("teammat_out_id"));
		map.put("out_type", reqMap.get("out_type"));
		// 物资出库单据表操作
		Serializable teammatOutId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_out");
		// 物资领用明细操作
		for (int i = 0; i < ids.length; i++) {
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "actual_price_" + ids[i];

			// 台账数据操作

			String sql = "select * from gms_mat_teammat_info t where t.wz_id = '"
					+ ids[i] + "'and t.project_info_no='" + projectInfoNo + "'";
			Map smap = ijdbcDao.queryRecordBySQL(sql);

			double stockNum = Double.valueOf(smap.get("stockNum").toString());
			stockNum -= Double.valueOf(reqMap.get(mat_num).toString());
			String updateSql = "update gms_mat_teammat_info t set t.stock_num ='"
					+ stockNum
					+ "' where t.teammat_info_id = '"
					+ smap.get("teammatInfoId").toString()
					+ "'and t.project_info_no='" + projectInfoNo + "'";
			jdbcDao.executeUpdate(updateSql);

		}
		// 发放完成后关闭计划
		if (reqMap.get("dev_acc_id") == null) {
			String sql = "select i.*,d.approve_num,d.use_num from GMS_MAT_DEMAND_PLAN_BZ t inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' where d.approve_num != (case when d.use_num is null then 0 else d.use_num end) and t.submite_number='"
					+ reqMap.get("submite_number")
					+ "'and t.s_apply_team='"
					+ reqMap.get("s_apply_team")
					+ "'and t.project_info_no='"
					+ projectInfoNo
					+ "' and t.bsflag='0'order by i.coding_code_id asc,i.wz_id asc";
			Map closeMap = pureDao.queryRecordBySQL(sql);
			if (closeMap == null) {
				String updateSql = "update gms_mat_demand_plan_bz t set t.if_submit='4' where t.submite_number='"
						+ reqMap.get("submite_number") + "'";
				jdbcDao.executeUpdate(updateSql);
			}
		} else {
			String sql = "select d.plan_num,d.use_num,i.* from gms_mat_teammat_out t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id where d.plan_num !=(case when d.use_num is null then 0 else d.use_num end) and t.teammat_out_id='"
					+ reqMap.get("submite_number")
					+ "' and t.project_info_no='"
					+ projectInfoNo
					+ "' and t.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";
			Map closeMap = pureDao.queryRecordBySQL(sql);
			if (closeMap == null) {
				String updateSql = "update GMS_MAT_TEAMMAT_OUT t set t.status='2' where t.teammat_out_id='"
						+ reqMap.get("submite_number") + "'";
				jdbcDao.executeUpdate(updateSql);
			}
		}
		return reqMsg;
	}

	/**
	 * 物资虚拟发放信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOutGrant(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqMap.get("laborId").toString();
		String[] ids = id.split(",");
		Map map = new HashMap();
		map.put("procure_no", reqMap.get("procure_no"));
		map.put("plan_invoice_id", reqMap.get("submite_number"));
		map.put("device_use_name", reqMap.get("device_use_name"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("status", reqMap.get("status"));
		map.put("team_id", reqMap.get("s_apply_team"));
		map.put("device_id", reqMap.get("device_code"));
		map.put("dev_acc_id", reqMap.get("dev_acc_id"));
		map.put("outmat_date", reqMap.get("outmat_date"));
		map.put("drawer", reqMap.get("drawer"));
		map.put("storage", reqMap.get("storage"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("note", reqMap.get("note"));
		map.put("out_type", reqMap.get("out_type"));
		map.put("use_type", reqMap.get("out_type"));
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("create_date", new Date());
		map.put("bsflag", "0");
		// 物资出库单据表操作
		Serializable teammatOutId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_out");
		// 物资领用明细操作
		for (int i = 0; i < ids.length; i++) {
			Map todMap = new HashMap();
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "actual_price_" + ids[i];
			todMap.put("teammat_out_id", teammatOutId.toString());
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num)); // 发放数量
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("plan_no", reqMap.get("device_use_name"));
			todMap.put("bsflag", "0");
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("creator_id", user.getUserId());
			todMap.put("create_date", new Date());
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_out_detail");
			if (reqMap.get("dev_acc_id") == null) {
				String sql = "select t.use_num from gms_mat_demand_plan_detail t where t.submite_number='"
						+ reqMap.get("submite_number")
						+ "'and t.wz_id='"
						+ ids[i] + "'and t.bsflag='0'";
				Map bzmap = pureDao.queryRecordBySQL(sql);
				if (bzmap.get("use_num").toString().equals("")
						|| bzmap.get("use_num") == null) {
					String update = "update gms_mat_demand_plan_detail t set t.use_num='"
							+ reqMap.get(mat_num)
							+ "' where t.submite_number='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				} else {
					double useNum = Double.valueOf(bzmap.get("use_num")
							.toString());
					useNum += Double.valueOf(reqMap.get(mat_num).toString());
					String update = "update gms_mat_demand_plan_detail t set t.use_num='"
							+ useNum
							+ "' where t.submite_number='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				}
			} else {
				String sql = "select t.use_num from gms_mat_device_use_info_detail t where t.teammat_out_id='"
						+ reqMap.get("submite_number")
						+ "'and t.wz_id='"
						+ ids[i] + "'and t.bsflag='0'";
				Map devmap = pureDao.queryRecordBySQL(sql);
				if (devmap.get("use_num") == null
						|| devmap.get("use_num").toString().equals("")) {
					String update = "update gms_mat_device_use_info_detail t set t.use_num='"
							+ reqMap.get(mat_num)
							+ "' where t.teammat_out_id='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				} else {
					double useNum = Double.valueOf(devmap.get("use_num")
							.toString());
					useNum += Double.valueOf(reqMap.get(mat_num).toString());
					String update = "update gms_mat_device_use_info_detail t set t.use_num='"
							+ useNum
							+ "' where t.teammat_out_id='"
							+ reqMap.get("submite_number")
							+ "'and t.wz_id='"
							+ ids[i] + "'and t.bsflag='0'";
					jdbcDao.executeUpdate(update);
				}
			}
		}
		return reqMsg;
	}

	/**
	 * 物资发放信息修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateGrant(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String checkId = reqDTO.getValue("checkIds");
		Map reqMap = reqDTO.toMap();
		String[] ids = id.split(",");
		String[] checkIds = checkId.split(",");
		Map map = new HashMap();
		map.put("teammat_out_id", reqMap.get("teammat_out_id"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("drawer", reqMap.get("drawer"));
		map.put("storage", reqMap.get("storage"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("note", reqMap.get("note"));
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("bsflag", "0");
		// 物资出库单据表操作
		Serializable teammatOutId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_out");
		// 物资领用明细操作
		for (int i = 0; i < checkIds.length; i++) {
			String mat_num = "mat_num_" + checkIds[i];
			String total_money = "total_money_" + checkIds[i];
			String actual_price = "actual_price_" + checkIds[i];
			int j = 0;
			for (j = 0; j < ids.length; j++) {
				if (ids[j].equals(checkIds[i])) {
					String getSql = "select * from gms_mat_teammat_out_detail t where t.teammat_out_id='"
							+ reqMap.get("teammat_out_id")
							+ "'and t.wz_id='"
							+ ids[j]
							+ "'and t.bsflag='0'and t.project_info_no='"
							+ projectInfoNo + "' ";
					Map getMap = pureDao.queryRecordBySQL(getSql);
					if (getMap == null) {
						String getdSql = "select * from gms_mat_teammat_info_detail t where t.wz_id='"
								+ ids[i] + "'";
						Map getdMap = pureDao.queryRecordBySQL(getSql);
						Map todMap = new HashMap();
						todMap.put("teammat_out_id",
								reqMap.get("teammat_out_id"));
						todMap.put("wz_id", ids[i]);
						todMap.put("mat_num", reqMap.get(mat_num)); // 发放数量
						todMap.put("actual_price", reqMap.get(actual_price));
						todMap.put("total_money", reqMap.get(total_money));
						todMap.put("mat_sourth", getdMap.get("mat_sourth"));
						todMap.put("goods_allocation",
								getdMap.get("goods_allocation"));
						todMap.put("warehouse_number",
								getdMap.get("warehouse_number"));
						todMap.put("plan_no", reqMap.get("device_use_name"));
						todMap.put("bsflag", "0");
						todMap.put("project_info_no", projectInfoNo);
						todMap.put("org_id", user.getOrgId());
						todMap.put("org_subjection_id",
								user.getOrgSubjectionId());
						todMap.put("creator_id", user.getUserId());
						todMap.put("create_date", new Date());
						pureDao.saveOrUpdateEntity(todMap,
								"gms_mat_teammat_out_detail");
						// 台账数据操作
						String sql = "select * from gms_mat_teammat_info where wz_id = '"
								+ ids[i] + "'";
						Map smap = ijdbcDao.queryRecordBySQL(sql);

						Double stockNum = Double.valueOf(smap.get("stockNum")
								.toString());
						stockNum -= Double.valueOf(reqMap.get(mat_num)
								.toString());
						String updateSql = "update gms_mat_teammat_info set stock_num ='"
								+ stockNum
								+ "' where teammat_info_id = '"
								+ smap.get("teammatInfoId").toString() + "'";
						jdbcDao.executeUpdate(updateSql);
					} else {
						Map todMap = new HashMap();
						todMap.put("out_detail_id", getMap.get("out_detail_id"));
						todMap.put("mat_num", reqMap.get(mat_num)); // 发放数量
						todMap.put("actual_price", reqMap.get(actual_price));
						todMap.put("total_money", reqMap.get(total_money));
						pureDao.saveOrUpdateEntity(todMap,
								"gms_mat_teammat_out_detail");
						// 台账数据操作
						String sql = "select * from gms_mat_teammat_info where wz_id = '"
								+ ids[i] + "'";
						Map smap = ijdbcDao.queryRecordBySQL(sql);

						Double stockNum = Double.valueOf(smap.get("stockNum")
								.toString());
						stockNum += Double.valueOf(getMap.get("mat_num")
								.toString());
						stockNum -= Double.valueOf(reqMap.get(mat_num)
								.toString());
						String updateSql = "update gms_mat_teammat_info set stock_num ='"
								+ stockNum
								+ "' where teammat_info_id = '"
								+ smap.get("teammatInfoId").toString() + "'";
						jdbcDao.executeUpdate(updateSql);
					}
					break;
				}

			}
			if (j == ids.length) {
				String getSql = "select * from gms_mat_teammat_out_detail t where t.teammat_out_id='"
						+ reqMap.get("teammat_out_id")
						+ "'and t.wz_id='"
						+ checkIds[i]
						+ "'and t.bsflag='0'and t.project_info_no='"
						+ projectInfoNo + "' ";
				Map getMap = pureDao.queryRecordBySQL(getSql);
				if (getMap != null) {
					String Infsql = "update gms_mat_teammat_out_detail set bsflag='1' where out_detail_id='"
							+ getMap.get("out_detail_id").toString()
							+ "'and project_info_no='" + projectInfoNo + "'";
					jdbcDao.executeUpdate(Infsql);
					// 台账数据操作

					String sql = "select * from gms_mat_teammat_info where wz_id = '"
							+ checkIds[i] + "'";
					Map smap = ijdbcDao.queryRecordBySQL(sql);

					Double stockNum = Double.valueOf(smap.get("stockNum")
							.toString());
					stockNum += Double
							.valueOf(getMap.get("mat_num").toString());
					String updateSql = "update gms_mat_teammat_info set stock_num ='"
							+ stockNum
							+ "' where teammat_info_id = '"
							+ smap.get("teammatInfoId").toString() + "'";
					jdbcDao.executeUpdate(updateSql);
				}
			}

		}
		return reqMsg;
	}

	/**
	 * 发放物资表单
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getGrantList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String sql = "select t.teammat_out_id,t.procure_no,t.device_use_name,t.dev_acc_id,t.plan_invoice_id,t.outmat_date,t.total_money,t.drawer,t.storage,t.pickupgoods,decode(t.out_type,'1','正常出库','2','虚拟出库') out_type ,nvl(c.coding_name,(d.dev_ci_name||d.dev_ci_model)) as tname from gms_mat_teammat_out t left join gms_device_codeinfo d on t.device_id = d.dev_ci_code left join comm_coding_sort_detail c on t.team_id = c.coding_code_id and c.bsflag='0' where t.teammat_out_id='"
				+ id + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 发放物资表单详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findGrantList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select * from gms_mat_teammat_out_detail t inner join gms_mat_teammat_out o on t.teammat_out_id=o.teammat_out_id and o.bsflag='0' inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0'and t.teammat_out_id='"
				+ id
				+ "'and t.project_info_no='"
				+ projectInfoNo
				+ "' order by i.coding_code_id asc,i.wz_id asc";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 物资退库页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTracLeaf(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		List<Map> list = new ArrayList<Map>();
		String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a order by a.wz_id asc";
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 单项目物资退库信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatOut(ISrvMsg reqDTO) throws Exception {
		Map map = new HashMap();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String checkId = reqDTO.getValue("checkIds");
		Map reqMap = reqDTO.toMap();
		String[] ids = id.split(",");
		String[] checkIds = id.split(",");

		map.put("input_storeroom", reqMap.get("input_storeroom"));
		map.put("out_reason", reqMap.get("out_reason"));
		map.put("invoices_id", reqMap.get("invoices_id"));
		map.put("procure_no", reqMap.get("procure_no"));
		map.put("out_date", reqMap.get("out_date"));
		map.put("storeroom", reqMap.get("storeroom"));
		map.put("input_org", reqMap.get("input_org"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("terms_num", reqMap.get("terms_num"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("transport_type", reqMap.get("transport_type"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("bsflag", "0");
		map.put("if_submit", "1");
		map.put("out_type", "2");
		map.put("wz_type", reqMap.get("wzType"));

		map.put("create_date", new Date());
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("creator_id", user.getUserId());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		// 新增退货单
		Serializable outInfoId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_out_info");
		// 查询物探处组织机构
		String sql = "select * from bgp_comm_org_wtc t where (select org_subjection_id from gp_task_project_dynamic where project_info_no ='"
				+ user.getProjectInfoNo()
				+ "') like t.org_subjection_id || '%'";
		Map queryMap = pureDao.queryRecordBySQL(sql);
		// 操作可重复利用表
		for (int i = 0; i < ids.length; i++) {
			String wzId = ids[i].substring(0, ids[i].indexOf("_"));
			String matNum = "mat_num_" + ids[i];
			String wzPrice = "wz_price_" + ids[i];
			String totalmoney = "total_money_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			Map oidMap = new HashMap();
			oidMap.put("out_info_id", outInfoId.toString());
			oidMap.put("wz_id", wzId);
			oidMap.put("out_num", reqMap.get(matNum));
			oidMap.put("out_price", reqMap.get(wzPrice));
			oidMap.put("total_money", reqMap.get(totalmoney));
			oidMap.put("goods_allocation", reqMap.get(goodsAllocation));
			oidMap.put("project_info_no", projectInfoNo);
			oidMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(oidMap, "gms_mat_out_info_detail");
			// 4 表示项目中退库，只需要清空库存
			if (!reqMap.get("input_storeroom").toString().equals("4")) {
				String orgSubjectionId = "";
				String orgId = "";
				// 综合物化探项目需要选择物资小站，物探处下面没有可重复物资
				String projectType = user.getProjectType();
				if (projectType.equals("5000100004000000009")) {
					orgSubjectionId = reqDTO.getValue("selectOrgSubId");
					if (orgSubjectionId != null
							&& orgSubjectionId.equals("C105008042567")) {
						orgId = "C6000000000567";
					} else if (orgSubjectionId != null
							&& orgSubjectionId.equals("C105008042568")) {
						orgId = "C6000000000568";
					}
				} else {
					orgSubjectionId = (String) queryMap
							.get("org_subjection_id");
					orgId = (String) queryMap.get("org_id");
				}

				// 向可重复利用库插入数据
				Map repMap = new HashMap();
				String findsql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
						+ wzId
						+ "' and t.bsflag='0' and wz_type='"
						+ reqMap.get("input_storeroom").toString()
						+ "' and t.org_subjection_id = '"
						+ orgSubjectionId
						+ "'";
				Map getMap = pureDao.queryRecordBySQL(findsql);
				String out_num = reqMap.get(matNum) == null ? "0" : reqMap.get(
						matNum).toString();
				double stockNum = Double.valueOf(out_num);
				if (getMap != null) {
					String stock_num = getMap.get("stock_num") == null ? "0"
							: getMap.get("stock_num").toString();
					stockNum += Double.valueOf(stock_num);
					repMap.put("RECYCLEMAT_INFO", getMap.get("recyclemat_info"));
				}
				repMap.put("wz_id", wzId);
				repMap.put("actual_price", reqMap.get(wzPrice));
				repMap.put("stock_num", stockNum);
				repMap.put("wz_type", reqMap.get("input_storeroom"));
				repMap.put("BSFLAG", "0");
				repMap.put("org_id", orgId);
				repMap.put("ORG_SUBJECTION_ID", orgSubjectionId);
				repMap.put("CREATOR_ID", user.getUserId());
				repMap.put("CREATE_DATE", new Date());
				repMap.put("UPDATOR_ID", user.getUserId());
				repMap.put("MODIFI_DATE", new Date());
				pureDao.saveOrUpdateEntity(repMap, "gms_mat_recyclemat_info");
			}
		}
		// 出库表添加相应数据，主表
		Map outMap = new HashMap();
		outMap.put("PLAN_INVOICE_ID", outInfoId.toString());
		outMap.put("project_info_no", projectInfoNo);
		outMap.put("bsflag", "0");
		outMap.put("out_type", "5");
		outMap.put("wz_type", reqMap.get("wzType"));
		Serializable outId = pureDao.saveOrUpdateEntity(outMap,
				"gms_mat_teammat_out");
		// 出库表添加相应数据，明细
		for (int j = 0; j < ids.length; j++) {
			Map outDetailMap = new HashMap();
			String wzId = ids[j].substring(0, ids[j].indexOf("_"));
			String matNum = "mat_num_" + ids[j];
			String wzPrice = "wz_price_" + ids[j];
			String totalmoney = "total_money_" + ids[j];
			outDetailMap.put("teammat_out_id", outId.toString());
			outDetailMap.put("plan_no", outInfoId.toString());
			outDetailMap.put("wz_id", wzId);
			outDetailMap.put("mat_num", reqMap.get(matNum));
			outDetailMap.put("actual_price", reqMap.get(wzPrice));
			outDetailMap.put("total_money", reqMap.get(totalmoney));
			outDetailMap.put("project_info_no", projectInfoNo);
			outDetailMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap,
					"gms_mat_teammat_out_detail");
		}
		return reqMsg;
	}

	/**
	 * 单项目物资退库信息修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateMatOut(ISrvMsg reqDTO) throws Exception {
		Map map = new HashMap();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();

		String id = reqDTO.getValue("laborId");
		String checkId = reqDTO.getValue("checkIds");
		Map reqMap = reqDTO.toMap();
		String[] ids = id.split(",");
		String[] checkIds = id.split(",");
		String out_info_id = reqMap.get("out_info_id") == null ? "" : reqMap
				.get("out_info_id").toString();

		// 向可重复利用库插入数据 修改的时候应该从可重复利用库中减去退库
		String querySql = "select * from gms_mat_out_info_detail d where d.out_info_id='"
				+ out_info_id + "'";
		List queryList = jdbcDao.queryRecords(querySql);
		// 遍历dataList，操作数据库
		for (int i = 0; i < queryList.size(); i++) {
			Map dataMap = (Map) queryList.get(i);
			String findsql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
					+ dataMap.get("wz_id") + "'and t.bsflag='0'";
			Map getMap = pureDao.queryRecordBySQL(findsql);
			if (getMap != null) {
				String out_num = dataMap.get("out_num") == null ? "0" : dataMap
						.get("out_num").toString();
				String stock_num = getMap.get("stock_num") == null ? "0"
						: getMap.get("stock_num").toString();
				double stockNum = Double.valueOf(stock_num)
						- Double.valueOf(out_num);
				Map repMap = new HashMap();
				repMap.put("RECYCLEMAT_INFO", getMap.get("recyclemat_info"));
				repMap.put("stock_num", stockNum);
				pureDao.saveOrUpdateEntity(repMap, "gms_mat_recyclemat_info");
			}
		}

		String sql1 = "delete from gms_mat_out_info_detail where out_info_id='"
				+ out_info_id + "'";
		String sql2 = "delete from gms_mat_teammat_out where PLAN_INVOICE_ID='"
				+ out_info_id + "'";
		String sql3 = "delete from gms_mat_teammat_out_detail where plan_no='"
				+ out_info_id + "'";
		jdbcDao.executeUpdate(sql1);
		jdbcDao.executeUpdate(sql2);
		jdbcDao.executeUpdate(sql3);

		map.put("OUT_INFO_ID", reqMap.get("out_info_id"));
		map.put("input_storeroom", reqMap.get("input_storeroom"));
		map.put("out_reason", reqMap.get("out_reason"));
		map.put("invoices_id", reqMap.get("invoices_id"));
		map.put("procure_no", reqMap.get("procure_no"));
		map.put("out_date", reqMap.get("out_date"));
		map.put("storeroom", reqMap.get("storeroom"));
		map.put("input_org", reqMap.get("input_org"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("terms_num", reqMap.get("terms_num"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("transport_type", reqMap.get("transport_type"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("bsflag", "0");
		map.put("if_submit", "1");
		map.put("out_type", "2");

		map.put("create_date", new Date());
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("creator_id", user.getUserId());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		// 新增退货单
		Serializable outInfoId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_out_info");
		for (int i = 0; i < ids.length; i++) {
			String wzId = ids[i].substring(0, ids[i].indexOf("_"));
			String matNum = "mat_num_" + ids[i];
			String wzPrice = "wz_price_" + ids[i];
			String totalmoney = "total_money_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			Map oidMap = new HashMap();
			oidMap.put("out_info_id", outInfoId.toString());
			oidMap.put("wz_id", wzId);
			oidMap.put("out_num", reqMap.get(matNum));
			oidMap.put("out_price", reqMap.get(wzPrice));
			oidMap.put("total_money", reqMap.get(totalmoney));
			oidMap.put("goods_allocation", reqMap.get(goodsAllocation));
			oidMap.put("project_info_no", projectInfoNo);
			oidMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(oidMap, "gms_mat_out_info_detail");

			// 向可重复利用库插入数据
			Map repMap = new HashMap();
			String findsql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
					+ wzId + "'and t.bsflag='0'";
			Map getMap = pureDao.queryRecordBySQL(findsql);
			String out_num = reqMap.get(matNum) == null ? "0" : reqMap.get(
					matNum).toString();
			double stockNum = Double.valueOf(out_num);
			if (getMap != null) {
				String stock_num = getMap.get("stock_num") == null ? "0"
						: getMap.get("stock_num").toString();
				stockNum += Double.valueOf(stock_num);
				repMap.put("RECYCLEMAT_INFO", getMap.get("recyclemat_info"));
			}
			repMap.put("wz_id", wzId);
			repMap.put("actual_price", reqMap.get(wzPrice));
			repMap.put("stock_num", stockNum);
			repMap.put("wz_type", "2");
			repMap.put("BSFLAG", "0");
			repMap.put("org_id", user.getOrgId());
			repMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			repMap.put("CREATOR_ID", user.getUserId());
			repMap.put("CREATE_DATE", new Date());
			repMap.put("UPDATOR_ID", user.getUserId());
			repMap.put("MODIFI_DATE", new Date());
			pureDao.saveOrUpdateEntity(repMap, "gms_mat_recyclemat_info");

		}
		// 出库表添加相应数据，主表
		Map outMap = new HashMap();
		outMap.put("PLAN_INVOICE_ID", outInfoId.toString());
		outMap.put("project_info_no", projectInfoNo);
		outMap.put("bsflag", "0");
		outMap.put("out_type", "5");
		outMap.put("wz_type", reqMap.get("wzType"));
		Serializable outId = pureDao.saveOrUpdateEntity(outMap,
				"gms_mat_teammat_out");
		// 出库表添加相应数据，明细
		for (int j = 0; j < ids.length; j++) {
			Map outDetailMap = new HashMap();
			String wzId = ids[j].substring(0, ids[j].indexOf("_"));
			String matNum = "mat_num_" + ids[j];
			String wzPrice = "wz_price_" + ids[j];
			String totalmoney = "total_money_" + ids[j];
			outDetailMap.put("teammat_out_id", outId.toString());
			outDetailMap.put("plan_no", outInfoId.toString());
			outDetailMap.put("wz_id", wzId);
			outDetailMap.put("mat_num", reqMap.get(matNum));
			outDetailMap.put("actual_price", reqMap.get(wzPrice));
			outDetailMap.put("total_money", reqMap.get(totalmoney));
			outDetailMap.put("project_info_no", projectInfoNo);
			outDetailMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap,
					"gms_mat_teammat_out_detail");
		}
		return reqMsg;

		// String id = reqDTO.getValue("laborId");
		// String checkId = reqDTO.getValue("checkIds");
		// Map reqMap = reqDTO.toMap();
		// String[] ids = id.split(",");
		// String[] checkIds = checkId.split(",");
		//
		// map.put("out_info_id", reqMap.get("out_info_id"));
		// // map.put("input_storeroom", reqMap.get("input_storeroom"));
		// map.put("invoices_id", reqMap.get("invoices_id"));
		// map.put("out_date", reqMap.get("out_date"));
		// map.put("storeroom", reqMap.get("storeroom"));
		// map.put("input_org", reqMap.get("input_org"));
		// map.put("total_money", reqMap.get("total_money"));
		// map.put("terms_num", reqMap.get("terms_num"));
		// map.put("operator", reqMap.get("operator"));
		// map.put("pickupgoods", reqMap.get("pickupgoods"));
		// map.put("transport_type", reqMap.get("transport_type"));
		// map.put("storage", reqMap.get("storage"));
		// map.put("note", reqMap.get("note"));
		// map.put("procure_no", reqMap.get("procure_no"));
		//
		// map.put("modifi_date", new Date());
		// map.put("updator_id", user.getUserId());
		// //修改退货单
		// pureDao.saveOrUpdateEntity(map,"gms_mat_out_info");
		// for(int i=0;i<checkIds.length;i++){
		// int j=0;
		// for(j=0;j<ids.length;j++){
		// if(ids[j].equals(checkIds[i])){
		// String wzId=ids[j].substring(0,ids[j].indexOf("_"));
		// String goods_allocation = ids[j].substring(ids[j].indexOf("_")+1);
		// String getSql =
		// "select * from gms_mat_out_info_detail t where t.wz_id='"+wzId+"'and t.out_info_id='"+reqMap.get("out_info_id")+"'and t.project_info_no='"+projectInfoNo+"'and t.bsflag='0'";
		// if(goods_allocation!=null&&!goods_allocation.equals("")){
		// getSql += "and t.goods_allocation='"+goods_allocation+"'";
		// }
		// Map getMap = pureDao.queryRecordBySQL(getSql);
		// if(getMap == null){
		// String matNum="mat_num_"+ids[j];
		// String wzPrice="wz_price_"+ids[j];
		// String totalmoney="total_money_"+ids[j];
		// String goodsAllocation="goods_allocation_"+ids[j];
		// Map oidMap = new HashMap();
		// oidMap.put("out_info_id",reqMap.get("out_info_id"));
		// oidMap.put("wz_id",wzId);
		// oidMap.put("out_num",reqMap.get(matNum) );
		// oidMap.put("out_price",reqMap.get(wzPrice) );
		// oidMap.put("total_money",reqMap.get(totalmoney) );
		// oidMap.put("goods_allocation",reqMap.get(goodsAllocation) );
		// oidMap.put("project_info_no",projectInfoNo );
		// oidMap.put("bsflag","0");
		// pureDao.saveOrUpdateEntity(oidMap,"gms_mat_out_info_detail");
		// }else{
		// String matNum="mat_num_"+ids[j];
		// String wzPrice="wz_price_"+ids[j];
		// String totalmoney="total_money_"+ids[j];
		// String goodsAllocation="goods_allocation_"+ids[j];
		// Map oidMap = new HashMap();
		// oidMap.put("out_info_detail_id",getMap.get("out_info_detail_id"));
		// oidMap.put("out_num",reqMap.get(matNum) );
		// oidMap.put("out_price",reqMap.get(wzPrice) );
		// oidMap.put("total_money",reqMap.get(totalmoney) );
		// oidMap.put("goods_allocation",reqMap.get(goodsAllocation) );
		// pureDao.saveOrUpdateEntity(oidMap,"gms_mat_out_info_detail");
		// }
		// break;
		// }
		//
		// }
		// if(j==ids.length){
		// String wzId=checkIds[i].substring(0,checkIds[i].indexOf("_"));
		// String goods_allocation =
		// checkIds[i].substring(checkIds[i].indexOf("_")+1);
		// String getSql =
		// "select * from gms_mat_out_info_detail t where t.wz_id='"+wzId+"'and t.out_info_id='"+reqMap.get("out_info_id")+"'and t.project_info_no='"+projectInfoNo+"'and t.bsflag='0'";
		// if(goods_allocation!=null&&!goods_allocation.equals("")){
		// getSql += "and t.goods_allocation='"+goods_allocation+"'";
		// }
		// Map getMap = pureDao.queryRecordBySQL(getSql);
		// if(getMap != null){
		// Map oidMap = new HashMap();
		// oidMap.put("out_info_detail_id",getMap.get("out_info_detail_id"));
		// oidMap.put("bsflag","1");
		// pureDao.saveOrUpdateEntity(oidMap,"gms_mat_out_info_detail");
		// }
		// }
		// }
		// return reqMsg;
	}

	/**
	 * 退库物资表单
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTracOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String sql = "select t.*,decode(t.input_storeroom,'3','代管物资','2','可重复利用物资','4','项目退库') input_store,i.org_abbreviation as org_name,dui.dev_name,dui.license_num,dui.self_num from gms_mat_out_info t left join gms_device_account_dui dui on t.dev_acc_id=dui.dev_acc_id inner join comm_org_information i on t.org_id=i.org_id and t.out_info_id='"
				+ id + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 退库单详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findTracOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select * from gms_mat_out_info_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and t.bsflag='0' and i.bsflag='0' inner join GMS_MAT_OUT_INFO o on t.out_info_id=o.out_info_id and o.bsflag='0' and o.out_info_id='"
				+ id
				+ "'and t.project_info_no='"
				+ projectInfoNo
				+ "'and t.out_num>0";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 班组退货单删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTeamOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String teammat_out_id = reqDTO.getValue("matId");
		String querySql = "select * from gms_mat_out_info t left join gms_mat_out_info_detail d on t.out_info_id=d.out_info_id where t.out_info_id='"
				+ teammat_out_id + "'";
		List queryList = pureDao.queryRecords(querySql);
		for (int i = 0; i < queryList.size(); i++) {
			Map queryMap = (Map) queryList.get(i);
			// 查询出库数量
			String outsql = "";
			if (queryMap.get("dev_acc_id") != null
					&& !queryMap.get("dev_acc_id").equals("")) {
				outsql += "select d.out_detail_id,d.mat_num  from gms_mat_teammat_out_detail d left join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
						+ queryMap.get("wz_id")
						+ "' and d.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' and t.bsflag='0' and t.dev_acc_id='"
						+ queryMap.get("dev_acc_id")
						+ "'  and rownum=1 order by d.mat_num desc  ";
			} else {
				outsql += "select d.out_detail_id,d.mat_num  from gms_mat_teammat_out_detail d left join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
						+ queryMap.get("wz_id")
						+ "' and d.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' and t.bsflag='0' and t.team_id ='"
						+ queryMap.get("team_id")
						+ "' and rownum=1 order by d.mat_num desc  ";
			}
			Map outMap = pureDao.queryRecordBySQL(outsql);
			double outNum = Double.valueOf(outMap.get("mat_num").toString());
			outNum += Double.valueOf(queryMap.get("out_num").toString());
			String updateSql = "update gms_mat_teammat_out_detail d set d.mat_num = '"
					+ outNum
					+ "' where d.out_detail_id='"
					+ queryMap.get("out_detail_id") + "'";
			jdbcDao.executeUpdate(updateSql);
		}
		String upTKSql = " update gms_mat_out_info t set t.bsflag='1' where t.out_info_id='"
				+ teammat_out_id + "'";
		jdbcDao.executeUpdate(upTKSql);

		return reqMsg;
	}

	/**
	 * 退货单删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTracOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		// String id = reqDTO.getValue("matId");
		String out_info_id = reqDTO.getValue("matId") == null ? "" : reqDTO
				.getValue("matId").toString();
		String sql = "update gms_mat_out_info set bsflag = '1' where out_info_id = '"
				+ out_info_id + "'";
		jdbcDao.executeUpdate(sql);

		// 向可重复利用库插入数据 修改的时候应该从可重复利用库中减去退库
		String querySql = "select * from gms_mat_out_info_detail d where d.out_info_id='"
				+ out_info_id + "'";
		List queryList = jdbcDao.queryRecords(querySql);
		// 遍历dataList，操作数据库
		for (int i = 0; i < queryList.size(); i++) {
			Map dataMap = (Map) queryList.get(i);
			String findsql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
					+ dataMap.get("wz_id") + "'and t.bsflag='0'";
			Map getMap = pureDao.queryRecordBySQL(findsql);
			if (getMap != null) {
				String out_num = dataMap.get("out_num") == null ? "0" : dataMap
						.get("out_num").toString();
				String stock_num = getMap.get("stock_num") == null ? "0"
						: getMap.get("stock_num").toString();
				double stockNum = Double.valueOf(stock_num)
						- Double.valueOf(out_num);
				Map repMap = new HashMap();
				repMap.put("RECYCLEMAT_INFO", getMap.get("recyclemat_info"));
				repMap.put("stock_num", stockNum);
				pureDao.saveOrUpdateEntity(repMap, "gms_mat_recyclemat_info");
			}
		}

		String sql1 = "delete from gms_mat_out_info_detail where out_info_id='"
				+ out_info_id + "'";
		String sql2 = "delete from gms_mat_teammat_out where PLAN_INVOICE_ID='"
				+ out_info_id + "'";
		String sql3 = "delete from gms_mat_teammat_out_detail where plan_no='"
				+ out_info_id + "'";
		jdbcDao.executeUpdate(sql1);
		jdbcDao.executeUpdate(sql2);
		jdbcDao.executeUpdate(sql3);
		return reqMsg;
	}

	/**
	 * 退货单提交操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitTrac(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		// 更新退货单
		String sql = "update gms_mat_out_info set if_submit = '1' where out_info_id = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		// 更新出库单和出库明细
		String updateOutSql = "update gms_mat_teammat_out t set t.bsflag = '0' where t.plan_invoice_id='"
				+ id + "'";
		String updateDetSql = "update gms_mat_teammat_out_detail d set d.bsflag = '0' where d.plan_no='"
				+ id + "'";
		jdbcDao.executeUpdate(updateOutSql);
		jdbcDao.executeUpdate(updateDetSql);
		// 向可重复利用库插入数据
		String querySql = "select * from gms_mat_out_info_detail d where d.out_info_id='"
				+ id + "'";
		List queryList = jdbcDao.queryRecords(querySql);
		// 遍历dataList，操作数据库
		for (int i = 0; i < queryList.size(); i++) {
			Map dataMap = (Map) queryList.get(i);
			String findsql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
					+ dataMap.get("wz_id") + "'and t.bsflag='0'";
			Map getMap = pureDao.queryRecordBySQL(findsql);
			double stockNum = Double.valueOf(dataMap.get("out_num").toString());
			if (getMap != null) {
				stockNum += Double.valueOf(getMap.get("out_num").toString());
			}
			Map repMap = new HashMap();
			repMap.put("wz_id", dataMap.get("wz_id"));
			repMap.put("actual_price", dataMap.get("out_price"));
			repMap.put("stock_num", stockNum);
			repMap.put("wz_type", "2");
			repMap.put("BSFLAG", "0");
			repMap.put("org_id", user.getOrgId());
			repMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			repMap.put("CREATOR_ID", user.getUserId());
			repMap.put("CREATE_DATE", dataMap.get("out_date"));
			repMap.put("UPDATOR_ID", user.getUserId());
			repMap.put("MODIFI_DATE", new Date());
			pureDao.saveOrUpdateEntity(repMap, "gms_mat_recyclemat_info");

		}
		return reqMsg;
	}

	/**
	 * 物资编制新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savePlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map bzmap = new HashMap();
		bzmap.put("submite_id", reqMap.get("plannum").toString());
		/*********** start ***********/
		// 物化探不存s_apply_team
		if (reqMap.get("s_apply_team") != null)
			bzmap.put("s_apply_team", reqMap.get("s_apply_team").toString());
		/*********** end ***********/
		bzmap.put("plan_type", reqMap.get("plan_type").toString());
		bzmap.put("if_purchase", reqMap.get("if_purchase").toString());
		bzmap.put("total_money", reqMap.get("total_money").toString());
		bzmap.put("task_object_id", reqMap.get("taskObjectId").toString());
		bzmap.put("creator_id", user.getUserId());
		bzmap.put("create_date", new Date());
		bzmap.put("bsflag", "0");
		if (reqMap.get("if_purchase").toString().equals("0")) {
			bzmap.put("if_submit", "2");
		} else {
			bzmap.put("if_submit", "0");
		}
		bzmap.put("plan_invoice_id", "0");
		bzmap.put("org_id", user.getOrgId());
		bzmap.put("org_subjection_id", user.getOrgSubjectionId());
		bzmap.put("project_info_no", user.getProjectInfoNo());
		Serializable submiteNumber = pureDao.saveOrUpdateEntity(bzmap,
				"gms_mat_demand_plan_bz");
		// 声明更新物资基本库的sql数组
		String[] updateSql = new String[ids.length];
		for (int i = 0; i < ids.length; i++) {
			// 定义更新物资基本库sql
			String sql = "update gms_mat_infomation t set t.wz_price='"
					+ reqMap.get("wz_price_" + ids[i] + "").toString()
					+ "'where t.wz_id='" + ids[i] + "'";
			// 将sql存入数组中
			updateSql[i] = sql;
			// 保存计划明细
			Map map = new HashMap();
			String demandNum = "demand_num_" + ids[i];
			String demandDate = "demand_date_" + ids[i];
			String demandMoney = "demand_money_" + ids[i];
			String note = "note_" + ids[i];
			map.put("note", reqMap.get(note).toString());
			map.put("demand_num", reqMap.get(demandNum).toString());
			map.put("approve_num", reqMap.get(demandNum).toString());
			map.put("demand_date", reqMap.get(demandDate).toString());
			map.put("demand_money", reqMap.get(demandMoney).toString());
			map.put("submite_number", submiteNumber.toString());
			map.put("wz_id", ids[i]);
			map.put("bsflag", "0");
			map.put("project_info_no", user.getProjectInfoNo());
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("team_id", user.getOrgId());
			pureDao.saveOrUpdateEntity(map, "gms_mat_demand_plan_detail");
		}
		// 更新物资库单价
		jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		return reqMsg;
	}

	/**
	 * 物资编制新增--大港各个中心进行编制
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savePlanDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map bzmap = new HashMap();
		bzmap.put("submite_number", reqMap.get("submite_number").toString());
		bzmap.put("submite_id", reqMap.get("plannum").toString());
		bzmap.put("plan_type", reqMap.get("plan_type").toString());
		bzmap.put("if_purchase", '9');
		bzmap.put("total_money", reqMap.get("total_money").toString());
		bzmap.put("creator_id", user.getUserId());
		bzmap.put("create_date", new Date());
		bzmap.put("bsflag", "0");

		bzmap.put("plan_invoice_id", "0");
		bzmap.put("org_id", user.getOrgId());
		bzmap.put("org_subjection_id", user.getOrgSubjectionId());
		bzmap.put("project_info_no", reqMap.get("input_org").toString());
		Serializable submiteNumber = pureDao.saveOrUpdateEntity(bzmap,
				"gms_mat_demand_plan_bz");

		String deleteSql = "delete from gms_mat_demand_plan_detail where submite_number = '"
				+ submiteNumber + "'";
		jdbcDao.executeUpdate(deleteSql);

		// 声明更新物资基本库的sql数组
		String[] updateSql = new String[ids.length];
		for (int i = 0; i < ids.length; i++) {
			// 定义更新物资基本库sql
			String sql = "update gms_mat_infomation t set t.wz_price='"
					+ reqMap.get("wz_price_" + ids[i] + "").toString()
					+ "'where t.wz_id='" + ids[i] + "'";
			// 将sql存入数组中
			updateSql[i] = sql;
			// 保存计划明细
			Map map = new HashMap();
			String demandNum = "demand_num_" + ids[i];
			String demandDate = "demand_date_" + ids[i];
			String demandMoney = "demand_money_" + ids[i];
			String note = "note_" + ids[i];
			map.put("note", reqMap.get(note).toString());
			map.put("demand_num", reqMap.get(demandNum).toString());
			map.put("approve_num", reqMap.get(demandNum).toString());
			map.put("demand_money", reqMap.get(demandMoney).toString());
			map.put("submite_number", submiteNumber.toString());
			map.put("wz_id", ids[i]);
			map.put("bsflag", "0");
			map.put("project_info_no", reqMap.get("input_org").toString());
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("team_id", user.getOrgId());
			pureDao.saveOrUpdateEntity(map, "gms_mat_demand_plan_detail");
		}
		// 更新物资库单价
		jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		return reqMsg;
	}

	/**
	 * 物资编制新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRepPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map bzmap = new HashMap();
		bzmap.put("submite_id", reqMap.get("plannum").toString());
		/*********** start ***********/
		// 物化探不存s_apply_team
		if (reqMap.get("s_apply_team") != null)
			bzmap.put("s_apply_team", reqMap.get("s_apply_team").toString());
		/*********** end ***********/
		bzmap.put("plan_type", reqMap.get("plan_type").toString());
		bzmap.put("if_purchase", reqMap.get("if_purchase").toString());
		bzmap.put("total_money", reqMap.get("total_money").toString());
		bzmap.put("task_object_id", reqMap.get("taskObjectId").toString());
		bzmap.put("creator_id", user.getUserId());
		bzmap.put("create_date", new Date());
		bzmap.put("bsflag", "0");
		if (reqMap.get("if_purchase").toString().equals("0")) {
			bzmap.put("if_submit", "2");
		} else {
			bzmap.put("if_submit", "0");
		}
		bzmap.put("plan_invoice_id", "0");
		bzmap.put("org_id", user.getOrgId());
		bzmap.put("org_subjection_id", user.getOrgSubjectionId());
		bzmap.put("project_info_no", user.getProjectInfoNo());
		Serializable submiteNumber = pureDao.saveOrUpdateEntity(bzmap,
				"gms_mat_demand_plan_bz");
		// 声明更新物资基本库的sql数组
		String[] updateSql = new String[ids.length];
		for (int i = 0; i < ids.length; i++) {
			// 定义更新物资基本库sql
			String sql = "update gms_mat_infomation t set t.wz_price='"
					+ reqMap.get("wz_price_" + ids[i] + "").toString()
					+ "'where t.wz_id='" + ids[i] + "'";
			// 将sql存入数组中
			updateSql[i] = sql;
			// 保存计划明细
			Map map = new HashMap();
			String demandNum = "demand_num_" + ids[i];
			String demandDate = "demand_date_" + ids[i];
			String demandMoney = "demand_money_" + ids[i];
			String note = "note_" + ids[i];
			map.put("note", reqMap.get(note).toString());
			map.put("demand_num", reqMap.get(demandNum).toString());
			map.put("approve_num", reqMap.get(demandNum).toString());
			map.put("demand_date", reqMap.get(demandDate).toString());
			map.put("demand_money", reqMap.get(demandMoney).toString());
			map.put("submite_number", submiteNumber.toString());
			map.put("wz_id", ids[i]);
			map.put("bsflag", "0");
			map.put("project_info_no", user.getProjectInfoNo());
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("team_id", user.getOrgId());
			pureDao.saveOrUpdateEntity(map, "gms_mat_demand_plan_detail");

			// 可重复利用物资库存操作 -----动态值："+user.getProjectInfoNo()+"
			/*
			 * String sqlRep =
			 * "select * from GMS_MAT_RECYCLEMAT_INFO g where g.wz_type='2' and g.bsflag='0'and g.wz_id='"
			 * +ids[i]+
			 * "' and g.org_subjection_id = (select org_subjection_id from bgp_comm_org_wtc w where (select org_subjection_id from gp_task_project_dynamic where project_info_no = '"
			 * +user.getProjectInfoNo()+"') like w.org_subjection_id || '%')";
			 * Map getMap = pureDao.queryRecordBySQL(sqlRep); double num =
			 * Double.valueOf(getMap.get("stock_num").toString());
			 * //可重复数据库中该物资的库存量----lx
			 * if(reqMap.get(demandNum)==null||reqMap.get(
			 * demandNum).toString().equals("")){//为空库存量不变 ----lx }else{ num =
			 * Double
			 * .valueOf(getMap.get("stock_num").toString())-Double.valueOf(
			 * reqMap.get(demandNum).toString()); //现有库存量-需求数量=新库存量----lx } Map
			 * repMap = new HashMap(); repMap.put("recyclemat_info",
			 * getMap.get("recyclemat_info")); repMap.put("stock_num", num);
			 * pureDao.saveOrUpdateEntity(repMap, "GMS_MAT_RECYCLEMAT_INFO");
			 */
		}
		// 更新物资库单价
		jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		return reqMsg;
	}

	/**
	 * 物资编制新增 单项目 粗略的物资计划 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRoughPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map ro_map = new HashMap();
		String planId = reqDTO.getValue("planId");
		String ifTeam = reqDTO.getValue("ifTeam");

		ro_map.put("plan_id", planId);
		ro_map.put("PLAN_NO", reqMap.get("plan_no"));
		ro_map.put("APPLY_DATE", reqMap.get("apply_date"));
		ro_map.put("APPLY_PERSON", reqMap.get("apply_person"));
		ro_map.put("APPLY_PHONE", reqMap.get("apply_phone"));
		ro_map.put("DELIVERY_DATE", reqMap.get("delivery_date"));
		ro_map.put("DELIVERY_ADDRESS", reqMap.get("delivery_address"));
		ro_map.put("ERP_NO", reqMap.get("erp_no"));
		ro_map.put("TOTAL_MONEY", reqMap.get("total_money"));
		ro_map.put("UPDATOR_ID", user.getUserId());
		ro_map.put("MODIFI_DATE", new Date());
		ro_map.put("BSFLAG", "0");
		if (ifTeam != null && ifTeam.equals("1")) {
			ro_map.put("IF_SUBMIT", "1");
		} else {
			ro_map.put("ORG_ID", user.getOrgId());
			ro_map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			ro_map.put("TASK_OBJECT_ID", reqMap.get("taskObjectId"));
			ro_map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			ro_map.put("CREATOR_ID", user.getUserId());
			ro_map.put("CREATE_DATE", new Date());
			ro_map.put("IF_SUBMIT", "0");
		}

		Serializable plan_id = pureDao.saveOrUpdateEntity(ro_map,
				"GMS_MAT_DEMAND_PLAN_ROUGH");

		String deleteSql = "delete from GMS_MAT_DEMAND_ROUGH_DETAIL where plan_id = '"
				+ plan_id + "'";
		jdbcDao.executeUpdate(deleteSql);

		for (int i = 0; i < ids.length; i++) {
			Map map = new HashMap();
			String wz_name = "wz_name_" + ids[i];
			String wz_prickie = "wz_prickie_" + ids[i];
			String apply_num = "apply_num_" + ids[i];
			String submit_num = "submit_num_" + ids[i];
			String wz_price = "wz_price_" + ids[i];
			String total_price = "total_price_" + ids[i];
			String note = "note_" + ids[i];
			String main_part_value = "main_part_value_" + ids[i];
			map.put("WZ_NAME", reqMap.get(wz_name));
			map.put("WZ_PRICKIE", reqMap.get(wz_prickie));
			map.put("WZ_PRICE", reqMap.get(wz_price));
			map.put("TOTAL_PRICE", reqMap.get(total_price));
			map.put("APPLY_NUM", reqMap.get(apply_num));
			map.put("SUBMIT_NUM", reqMap.get(submit_num));
			map.put("MAIN_PART", reqMap.get(main_part_value));
			map.put("NOTE", reqMap.get(note));
			map.put("CREATOR", user.getUserId());
			map.put("CREATE_DATE", new Date());
			map.put("UPDATOR", user.getUserId());
			map.put("MODIFI_DATE", new Date());
			map.put("BSFLAG", "0");
			map.put("PLAN_ID", plan_id);
			map.put("order_num", i);

			pureDao.saveOrUpdateEntity(map, "GMS_MAT_DEMAND_ROUGH_DETAIL");
		}
		return reqMsg;
	}

	/**
	 * 物资计划编制查询 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRoughPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		String sql = "select t.*,oi.org_abbreviation,oi.org_name from gms_mat_demand_plan_rough t left join comm_org_information oi on oi.org_id=t.org_id and oi.bsflag='0' where t.plan_id='"
				+ plan_id + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("map", map);
		return reqMsg;
	}

	/**
	 * 物资计划编制查询是否审批 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRoughPlanSubmit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		// String sql =
		// "select t.*,oi.org_abbreviation,oi.org_name from gms_mat_demand_plan_rough t left join comm_org_information oi on oi.org_id=t.org_id and oi.bsflag='0' where t.plan_id='"+plan_id+"'";
		String sql = "select case when wm.proc_status is null then '0' else wm.proc_status end proc_status from gms_mat_demand_plan_rough p  left join  common_busi_wf_middle wm on p.plan_id=wm.business_id where p.plan_id='"
				+ plan_id + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("map", map);
		return reqMsg;
	}

	/**
	 * 物资计划编制详细查询(子表) 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRoughPlanDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		String sql = "select * from gms_mat_demand_rough_detail where plan_id = '"
				+ plan_id + "' order by order_num asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);

		reqMsg.setValue("mapInfo", list);
		return reqMsg;
	}

	/**
	 * 物资计划编修改状态 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateRoughPlanStatus(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		String sql = "update gms_mat_demand_plan_rough t set t.if_submit='1' where t.plan_id = '"
				+ plan_id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 物资计划编删除 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRoughPlanStatus(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		String sql = "update gms_mat_demand_plan_rough t set t.bsflag='1' where t.plan_id = '"
				+ plan_id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 物资计划项目部查询 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String detail_id = reqDTO.getValue("detail_id");
		String sql = "select t.*, oi.org_abbreviation, oi.org_name from gms_mat_demand_rough_detail d join  gms_mat_demand_plan_rough t on d.plan_id =t.plan_id and t.bsflag='0' left join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' where d.detail_id = '"
				+ detail_id + "' ";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("map", map);
		return reqMsg;
	}

	/**
	 * 物资计划项目部查询 详细物资明细 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectPlanDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String detail_id = reqDTO.getValue("detail_id");
		String sql = "select d.detail_id,mi.wz_id,mi.coding_code_id,mi.wz_name,mi.wz_prickie,mi.wz_price,dp.demand_num,dp.plan_money from gms_mat_demand_rough_detail d left join gms_mat_demand_plan_invoice pi on d.plan_invoice_id=pi.plan_invoice_id and pi.bsflag='0' left join gms_mat_demand_plan dp on dp.plan_invoice_id=pi.plan_invoice_id and dp.bsflag='0' left join gms_mat_infomation mi on dp.wz_id = mi.wz_id and mi.bsflag='0' where d.bsflag='0' and  d.detail_id='"
				+ detail_id + "'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 综合物化探项目部编制计划---------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savePlanProject(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String id = reqmap.get("laborId").toString();
		String[] ids = id.split(",");
		String plan_id = reqDTO.getValue("plan_id");
		String projectInfoNo = reqDTO.getValue("project_info_no");

		Map pimap = new HashMap();
		pimap.put("submite_if", "0");
		pimap.put("bsflag", "0");
		pimap.put("project_info_no", projectInfoNo);

		pimap.put("org_id", user.getOrgId());
		pimap.put("org_subjection_id", user.getOrgSubjectionId());
		pimap.put("creator_id", user.getUserId());
		pimap.put("create_date", new Date());
		pimap.put("UPDATOR_ID", user.getUserId());
		pimap.put("MODIFI_DATE", new Date());

		Serializable planInvoiceId = pureDao.saveOrUpdateEntity(pimap,
				"gms_mat_demand_plan_invoice");

		// 关联表赋值
		String upsql = "update gms_mat_demand_rough_detail t set t.plan_invoice_id='"
				+ planInvoiceId.toString()
				+ "' where detail_id='"
				+ plan_id
				+ "' and t.bsflag='0'";
		jdbcDao.executeUpdate(upsql);

		for (int i = 0; i < ids.length; i++) {
			String demandNum = "demand_num_" + ids[i];
			String planMoney = "demand_money_" + ids[i];
			// 汇总申请信息
			Map dpmap = new HashMap();
			dpmap.put("plan_invoice_id", planInvoiceId.toString());
			dpmap.put("wz_id", ids[i]);
			dpmap.put("demand_num", reqmap.get(demandNum));
			dpmap.put("plan_money", reqmap.get(planMoney));
			// dpmap.put("regulate_num", reqmap.get(regulateNum));
			dpmap.put("apply_num", reqmap.get(demandNum));
			dpmap.put("demand_date", new Date());
			dpmap.put("bsflag", "0");
			dpmap.put("project_info_no", projectInfoNo);
			dpmap.put("creator_id", user.getUserId());
			dpmap.put("create_date", new Date());
			dpmap.put("org_id", user.getOrgId());
			dpmap.put("org_subjection_id", user.getOrgSubjectionId());
			pureDao.saveOrUpdateEntity(dpmap, "gms_mat_demand_plan");
		}
		return reqMsg;
	}

	/**
	 * 综合物化探项目部编制计划---------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatePlanProject(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String id = reqmap.get("laborId").toString();
		String[] ids = id.split(",");
		// String plan_id = reqDTO.getValue("plan_id");
		String plan_invoice_id = reqDTO.getValue("plan_invoice_id");
		String projectInfoNo = reqDTO.getValue("project_info_no");

		Map pimap = new HashMap();
		pimap.put("plan_invoice_id", plan_invoice_id);
		pimap.put("submite_if", "0");
		pimap.put("bsflag", "0");

		pimap.put("UPDATOR_ID", user.getUserId());
		pimap.put("MODIFI_DATE", new Date());

		Serializable planInvoiceId = pureDao.saveOrUpdateEntity(pimap,
				"gms_mat_demand_plan_invoice");

		// 关联表赋值
		// String upsql =
		// "update gms_mat_demand_rough_detail t set t.plan_invoice_id='"+planInvoiceId.toString()+"' where detail_id='"+plan_id+"' and t.bsflag='0'";
		// jdbcDao.executeUpdate(upsql);

		String delSql = " delete from gms_mat_demand_plan where plan_invoice_id='"
				+ planInvoiceId + "'";
		jdbcDao.executeUpdate(delSql);

		for (int i = 0; i < ids.length; i++) {
			String demandNum = "demand_num_" + ids[i];
			String planMoney = "demand_money_" + ids[i];
			// 汇总申请信息
			Map dpmap = new HashMap();
			dpmap.put("plan_invoice_id", planInvoiceId.toString());
			dpmap.put("wz_id", ids[i]);
			dpmap.put("demand_num", reqmap.get(demandNum));
			dpmap.put("plan_money", reqmap.get(planMoney));
			// dpmap.put("regulate_num", reqmap.get(regulateNum));
			dpmap.put("apply_num", reqmap.get(demandNum));
			dpmap.put("demand_date", new Date());
			dpmap.put("bsflag", "0");
			dpmap.put("project_info_no", projectInfoNo);
			dpmap.put("creator_id", user.getUserId());
			dpmap.put("org_id", user.getOrgId());
			dpmap.put("org_subjection_id", user.getOrgSubjectionId());
			pureDao.saveOrUpdateEntity(dpmap, "gms_mat_demand_plan");
		}
		return reqMsg;
	}

	/**
	 * 综合物化探项目部编制计划查询状态---------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectPlanSubmit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		String sql = "select d.*,case when d.plan_invoice_id is not null then '已编辑' else '未编辑' end if_write,case when m.proc_status='3' then '已提交' else '未提交' end if_submit from gms_mat_demand_rough_detail d left join gms_mat_demand_plan_invoice t on d.plan_invoice_id=t.plan_invoice_id and t.bsflag='0' left join common_busi_wf_middle m on t.plan_invoice_id = m.business_id and m.bsflag='0' where d.detail_id='"
				+ plan_id + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("mapInfo", map);

		return reqMsg;
	}

	/*
	 * 综合物化探项目部提交计划编制-------------lx
	 */

	public ISrvMsg submitProjectPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");

		String sql = "select * from gms_mat_demand_rough_detail where bsflag='0' and detail_id = '"
				+ plan_id + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		String plan_invoice_id = (String) map.get("planInvoiceId");

		// 审批流默认审批通过
		Map comm = new HashMap();
		comm.put("business_id", plan_invoice_id);
		comm.put("bsflag", "0");
		comm.put("proc_status", "3");
		comm.put("PROC_ID", "11"); // 数据库表中为必填，默认给赋值11
		pureDao.saveOrUpdateEntity(comm, "common_busi_wf_middle");

		return reqMsg;
	}

	/**
	 * 可重复物资计划编制新增 单项目 粗略的物资计划 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRepeatRoughPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map ro_map = new HashMap();
		String planId = reqDTO.getValue("planId");
		String ifTeam = reqDTO.getValue("ifTeam");

		ro_map.put("plan_id", planId);
		ro_map.put("PLAN_NO", reqMap.get("plan_no"));
		ro_map.put("APPLY_DATE", reqMap.get("apply_date"));
		ro_map.put("APPLY_PERSON", reqMap.get("apply_person"));
		ro_map.put("APPLY_PHONE", reqMap.get("apply_phone"));
		ro_map.put("DELIVERY_DATE", reqMap.get("delivery_date"));
		ro_map.put("DELIVERY_ADDRESS", reqMap.get("delivery_address"));
		ro_map.put("ERP_NO", reqMap.get("erp_no"));
		ro_map.put("TOTAL_MONEY", reqMap.get("total_money"));
		ro_map.put("UPDATOR_ID", user.getUserId());
		ro_map.put("MODIFI_DATE", new Date());
		ro_map.put("BSFLAG", "0");
		ro_map.put("IF_REPEAT", "1"); // 值为1，是可重复计划

		if (ifTeam != null && ifTeam.equals("1")) {
			ro_map.put("IF_SUBMIT", "1");
		} else {
			ro_map.put("ORG_ID", user.getOrgId());
			ro_map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			ro_map.put("TASK_OBJECT_ID", reqMap.get("taskObjectId"));
			ro_map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			ro_map.put("CREATOR_ID", user.getUserId());
			ro_map.put("CREATE_DATE", new Date());
			ro_map.put("IF_SUBMIT", "0");
		}

		Serializable plan_id = pureDao.saveOrUpdateEntity(ro_map,
				"GMS_MAT_DEMAND_PLAN_ROUGH");

		String deleteSql = "delete from GMS_MAT_DEMAND_ROUGH_REPEAT where plan_id = '"
				+ plan_id + "'";
		jdbcDao.executeUpdate(deleteSql);

		for (int i = 0; i < ids.length; i++) {
			Map map = new HashMap();
			String wz_name = "wz_name_" + ids[i];
			String wz_prickie = "wz_prickie_" + ids[i];
			String apply_num = "apply_num_" + ids[i];
			String submit_num = "submit_num_" + ids[i];
			String zhichenggan_num = "zhichenggan_num_" + ids[i];
			String pengbu_num = "pengbu_num_" + ids[i];
			String appearance = "appearance_" + ids[i];
			String performance = "performance_" + ids[i];
			String note = "note_" + ids[i];
			String main_part_value = "main_part_value_" + ids[i];
			String gucheng_num = "gucheng_num_" + ids[i];
			String kuerle_num = "kuerle_num_" + ids[i];

			map.put("WZ_NAME", reqMap.get(wz_name));
			map.put("WZ_PRICKIE", reqMap.get(wz_prickie));
			map.put("ZHICHENGGAN_NUM", reqMap.get(zhichenggan_num));
			map.put("PENGBU_NUM", reqMap.get(pengbu_num));
			map.put("APPEARANCE", reqMap.get(appearance));
			map.put("PERFORMANCE", reqMap.get(performance));
			map.put("APPLY_NUM", reqMap.get(apply_num));
			map.put("SUBMIT_NUM", reqMap.get(submit_num));
			map.put("MAIN_PART", reqMap.get(main_part_value));
			map.put("GUCHENG_NUM", reqMap.get(gucheng_num));
			map.put("KUERLE_NUM", reqMap.get(kuerle_num));
			map.put("NOTE", reqMap.get(note));
			map.put("CREATOR", user.getUserId());
			map.put("CREATE_DATE", new Date());
			map.put("UPDATOR", user.getUserId());
			map.put("MODIFI_DATE", new Date());
			map.put("BSFLAG", "0");
			map.put("PLAN_ID", plan_id);
			map.put("order_num", i);

			pureDao.saveOrUpdateEntity(map, "GMS_MAT_DEMAND_ROUGH_REPEAT");
		}
		return reqMsg;
	}

	/**
	 * 物资计划编制详细查询(子表) 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRoughPlanRepeat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		String sql = "select * from gms_mat_demand_rough_repeat where plan_id = '"
				+ plan_id + "' order by order_num asc";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);

		reqMsg.setValue("mapInfo", list);
		return reqMsg;
	}

	/**
	 * 物资计划项目部查询 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryPlanWZXZ(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String detail_id = reqDTO.getValue("detail_id");
		String sql = "select t.*, oi.org_abbreviation, oi.org_name from gms_mat_demand_rough_repeat d join  gms_mat_demand_plan_rough t on d.plan_id =t.plan_id and t.bsflag='0' left join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' where d.detail_id = '"
				+ detail_id + "' ";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("map", map);
		return reqMsg;
	}

	/**
	 * 综合物化探物资小站编制可重复计划查询状态---------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryWZXZPlanSubmit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");
		String sql = "select d.*,case when d.plan_invoice_id is not null then '已编辑' else '未编辑' end if_write,case when m.proc_status='3' then '已提交' else '未提交' end if_submit from gms_mat_demand_rough_repeat d left join gms_mat_demand_plan_invoice t on d.plan_invoice_id=t.plan_invoice_id and t.bsflag='0' left join common_busi_wf_middle m on t.plan_invoice_id = m.business_id and m.bsflag='0' where d.detail_id='"
				+ plan_id + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("mapInfo", map);

		return reqMsg;
	}

	/**
	 * 可重复物资编制新增 综合物化探物资小站------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savePlanWZXZ(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String id = reqmap.get("laborId").toString();
		String[] ids = id.split(",");
		String plan_id = reqDTO.getValue("plan_id");
		String projectInfoNo = reqDTO.getValue("project_info_no");

		// 生成提交表单
		Map pimap = new HashMap();
		pimap.put("submite_if", "0");
		pimap.put("bsflag", "0");
		pimap.put("project_info_no", projectInfoNo);

		pimap.put("org_id", user.getOrgId());
		pimap.put("org_subjection_id", user.getOrgSubjectionId());
		pimap.put("creator_id", user.getUserId());
		pimap.put("create_date", new Date());
		pimap.put("UPDATOR_ID", user.getUserId());
		pimap.put("MODIFI_DATE", new Date());

		Serializable planInvoiceId = pureDao.saveOrUpdateEntity(pimap,
				"gms_mat_demand_plan_invoice");

		// 关联表赋值
		String upsql = "update gms_mat_demand_rough_repeat t set t.plan_invoice_id='"
				+ planInvoiceId.toString()
				+ "' where detail_id='"
				+ plan_id
				+ "' and t.bsflag='0'";
		jdbcDao.executeUpdate(upsql);

		for (int i = 0; i < ids.length; i = i + 2) {

			String demandNum = "demand_num_" + ids[i + 1];
			String demandDate = "demand_date_" + ids[i + 1];
			String orgSubjectionId = "org_subjection_id_" + ids[i + 1];
			String orgId = "org_id_" + ids[i + 1];
			String regulateNum = "regulate_num_" + ids[i + 1];

			Map dpmap = new HashMap();
			dpmap.put("plan_invoice_id", planInvoiceId.toString());
			dpmap.put("wz_id", ids[i]);
			dpmap.put("demand_num", reqDTO.getValue(demandNum));
			dpmap.put("apply_num", reqmap.get(demandNum));
			dpmap.put("regulate_num", reqmap.get(regulateNum));
			dpmap.put("demand_date", reqmap.get(demandDate));
			dpmap.put("bsflag", "0");
			dpmap.put("project_info_no", projectInfoNo);
			dpmap.put("creator_id", user.getUserId());
			dpmap.put("UPDATOR_ID", user.getUserId());
			dpmap.put("MODIFI_DATE", new Date());
			dpmap.put("org_id", reqmap.get(orgId));
			dpmap.put("org_subjection_id", reqmap.get(orgSubjectionId));
			pureDao.saveOrUpdateEntity(dpmap, "gms_mat_demand_plan");

			// 可重复利用物资库存操作 -----动态值："+user.getProjectInfoNo()+"
			String sqlRep = "select * from GMS_MAT_RECYCLEMAT_INFO g where g.wz_type='2' and g.bsflag='0'and g.wz_id='"
					+ ids[i]
					+ "' and g.org_subjection_id = '"
					+ reqmap.get(orgSubjectionId) + "'";
			Map getMap = pureDao.queryRecordBySQL(sqlRep);
			double num = Double.valueOf(getMap.get("stock_num").toString()); // 可重复数据库中该物资的库存量----lx
			if (reqmap.get(demandNum) == null
					|| reqmap.get(demandNum).toString().equals("")) {// 为空库存量不变
																		// ----lx
			} else {
				num = Double.valueOf(getMap.get("stock_num").toString())
						- Double.valueOf(reqmap.get(demandNum).toString()); // 现有库存量-需求数量=新库存量----lx
			}
			Map repMap = new HashMap();
			repMap.put("recyclemat_info", getMap.get("recyclemat_info"));
			repMap.put("stock_num", num);
			pureDao.saveOrUpdateEntity(repMap, "GMS_MAT_RECYCLEMAT_INFO");

		}
		return reqMsg;
	}

	/**
	 * 物资小站可重复物资查询 详细物资明细 综合物化探用 --------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectPlanWZXZ(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String detail_id = reqDTO.getValue("detail_id");
		String sql = "select d.detail_id,mi.wz_id,mi.coding_code_id,mi.wz_name,mi.wz_prickie,mi.wz_price,dp.demand_num,dp.plan_money,dp.demand_date,ri.stock_num,oi.org_abbreviation from gms_mat_demand_rough_repeat d left join gms_mat_demand_plan_invoice pi on d.plan_invoice_id=pi.plan_invoice_id and pi.bsflag='0' left join gms_mat_demand_plan dp on dp.plan_invoice_id=pi.plan_invoice_id and dp.bsflag='0' left join gms_mat_recyclemat_info ri on dp.wz_id=ri.wz_id and ri.bsflag='0' and ri.org_subjection_id=dp.org_subjection_id left join comm_org_information oi on ri.org_id=oi.org_id and oi.bsflag='0' left join gms_mat_infomation mi on dp.wz_id = mi.wz_id and mi.bsflag='0' where d.bsflag='0' and  d.detail_id='"
				+ detail_id + "'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 综合物化探物资小站修改可重复物资计划---------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatePlanWZXZ(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String id = reqmap.get("laborId").toString();
		String[] ids = id.split(",");
		String plan_id = reqDTO.getValue("plan_id");
		String projectInfoNo = reqDTO.getValue("project_info_no");
		String plan_invoice_id = reqDTO.getValue("plan_invoice_id");

		// 生成提交表单
		Map pimap = new HashMap();
		pimap.put("PLAN_INVOICE_ID", plan_invoice_id);
		pimap.put("submite_if", "0");
		pimap.put("bsflag", "0");
		pimap.put("project_info_no", projectInfoNo);

		pimap.put("org_id", user.getOrgId());
		pimap.put("org_subjection_id", user.getOrgSubjectionId());
		pimap.put("UPDATOR_ID", user.getUserId());
		pimap.put("MODIFI_DATE", new Date());

		Serializable planInvoiceId = pureDao.saveOrUpdateEntity(pimap,
				"gms_mat_demand_plan_invoice");

		// 修改的时候，需要把可重复物资的库存加回去
		String sqlOld = "select nvl(p.demand_num,0)+nvl(g.stock_num,0) stock_num ,g.recyclemat_info from gms_mat_demand_plan p inner join GMS_MAT_RECYCLEMAT_INFO g on p.wz_id = g.wz_id and p.org_subjection_id=g.org_subjection_id where g.wz_type = '2' and g.bsflag = '0' and p.bsflag='0' and p.plan_invoice_id = '"
				+ planInvoiceId + "'";
		List list = pureDao.queryRecords(sqlOld);
		if (list.size() > 0) {
			for (int j = 0; j < list.size(); j++) {
				Map mapOld = (Map) list.get(j);
				Map repMap = new HashMap();
				repMap.put("recyclemat_info", mapOld.get("recyclemat_info"));
				repMap.put("stock_num", mapOld.get("stock_num"));
				pureDao.saveOrUpdateEntity(repMap, "GMS_MAT_RECYCLEMAT_INFO");
			}
		}

		// 删除原字表中数据
		String deleteSql = "update gms_mat_demand_plan set bsflag='1' where plan_invoice_id='"
				+ planInvoiceId + "'";
		jdbcDao.executeUpdate(deleteSql);

		for (int i = 0; i < ids.length; i = i + 2) {

			String demandNum = "demand_num_" + ids[i + 1];
			String demandDate = "demand_date_" + ids[i + 1];
			String orgSubjectionId = "org_subjection_id_" + ids[i + 1];
			String orgId = "org_id_" + ids[i + 1];
			String regulateNum = "regulate_num_" + ids[i + 1];

			Map dpmap = new HashMap();
			dpmap.put("plan_invoice_id", planInvoiceId.toString());
			dpmap.put("wz_id", ids[i]);
			dpmap.put("demand_num", reqDTO.getValue(demandNum));
			dpmap.put("apply_num", reqmap.get(demandNum));
			dpmap.put("regulate_num", reqmap.get(regulateNum));
			dpmap.put("demand_date", reqmap.get(demandDate));
			dpmap.put("bsflag", "0");
			dpmap.put("project_info_no", projectInfoNo);
			dpmap.put("creator_id", user.getUserId());
			dpmap.put("UPDATOR_ID", user.getUserId());
			dpmap.put("MODIFI_DATE", new Date());
			dpmap.put("org_id", reqmap.get(orgId));
			dpmap.put("org_subjection_id", reqmap.get(orgSubjectionId));
			pureDao.saveOrUpdateEntity(dpmap, "gms_mat_demand_plan");

			// 可重复利用物资库存操作 -----动态值："+user.getProjectInfoNo()+"
			String sqlRep = "select * from GMS_MAT_RECYCLEMAT_INFO g where g.wz_type='2' and g.bsflag='0'and g.wz_id='"
					+ ids[i]
					+ "' and g.org_subjection_id = '"
					+ reqmap.get(orgSubjectionId) + "'";
			Map getMap = pureDao.queryRecordBySQL(sqlRep);
			double num = Double.valueOf(getMap.get("stock_num").toString()); // 可重复数据库中该物资的库存量----lx
			if (reqmap.get(demandNum) == null
					|| reqmap.get(demandNum).toString().equals("")) {// 为空库存量不变
																		// ----lx
			} else {
				num = Double.valueOf(getMap.get("stock_num").toString())
						- Double.valueOf(reqmap.get(demandNum).toString()); // 现有库存量-需求数量=新库存量----lx
			}
			Map repMap = new HashMap();
			repMap.put("recyclemat_info", getMap.get("recyclemat_info"));
			repMap.put("stock_num", num);
			pureDao.saveOrUpdateEntity(repMap, "GMS_MAT_RECYCLEMAT_INFO");

		}
		return reqMsg;
	}

	/*
	 * 综合物化探物资小站提交计划编制-------------lx
	 */

	public ISrvMsg submitWZXZPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String plan_id = reqDTO.getValue("plan_id");

		String sql = "select * from gms_mat_demand_rough_repeat where bsflag='0' and detail_id = '"
				+ plan_id + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		String plan_invoice_id = (String) map.get("planInvoiceId");

		// 审批流默认审批通过
		Map comm = new HashMap();
		comm.put("business_id", plan_invoice_id);
		comm.put("bsflag", "0");
		comm.put("proc_status", "3");
		comm.put("PROC_ID", "11"); // 数据库表中为必填，默认给赋值11
		pureDao.saveOrUpdateEntity(comm, "common_busi_wf_middle");

		return reqMsg;
	}

	/**
	 * 计划编制新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.*,t.unit_num  from GMS_MAT_DEMAND_TAMPLATE_DETAIL t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' where t.tamplate_id = '"
				+ value + "'and t.bsflag='0' order by i.coding_code_id,i.wz_id";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资计划配置页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRatioLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String projectInfoNo = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		StringBuffer sql = new StringBuffer();
		sql.append("select '1'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '19'mat_id,'火工产品'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and (i.coding_code_id like '19%') and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '19'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '1.1'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '1901@1905'mat_id,'炸药'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '1901%' or i.coding_code_id like '1905%')and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '1901@1905'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '1.2'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '1903'mat_id,'  雷管'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '1903%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '1903'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '2'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '07'mat_id,'油品'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '07%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '07'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '2.1'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '070301'mat_id,'  汽油费'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '070301%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '070301'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '2.2'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '070303'mat_id,'  柴油费'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '070303%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '070303'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '2.3'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '0705'mat_id,'  小油品'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '0705%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '0705'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '3'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '32019904'mat_id,'炮线(被覆线)'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '32019904%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '32019904'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '4'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '36070205'mat_id,'磁带'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '36070205%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '36070205'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '5'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '12'mat_id,'膨润土'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '12%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '12'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '6'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '21'mat_id,'劳保'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '21%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '21'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '7'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '08'mat_id,'煤'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '08%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '08'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '8'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '1402'mat_id,'轮胎'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  i.coding_code_id like '1402%' and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '1402'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '9'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '55@56'mat_id,'汽车材料'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '55%' or i.coding_code_id like '56%') and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '55@56'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '10'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '48'mat_id,'钻机材料'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '48%') and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '48'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '11'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '02@47'mat_id,'钻探材料'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '02%' or i.coding_code_id like '47') and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '02@47'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '12'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '55'mat_id,'运输车配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '55%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '55'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '13'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '57'mat_id,'船舶配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '57%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '57'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '14'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '51010401'mat_id,'推土机配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '51010401%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '51010401'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '15'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '51012201'mat_id,'震源配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '51012201%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '51012201'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '16'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '28'mat_id,'发电机配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '28%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '28'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '17'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '33060402'mat_id,'蓄电池'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '33060402%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '33060402'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '18'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '03'mat_id,'钢材'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '03%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '03'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '19'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '04'mat_id,'钢丝绳'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '04%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '04'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '20'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '37'mat_id,'仪器配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '37%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '37'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '21'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '37810104'mat_id,'检波器配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '37810104%' )and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0' )a inner join (select '37810104'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '22'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '40031514@20030314'mat_id,'聚乙烯绳、钢钎'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '40031514%'or i.coding_code_id like '20030314%' )and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0' )a inner join (select '40031514@20030314'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id");
		sql.append(" union all");
		sql.append(" select '23'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '38'mat_id,'仪表配件'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '38%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '38'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '24'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '45'mat_id,'消防器材'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '45%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '45'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '25'orderNum,a.mat_id,a.code_name,a.demand_num,a.demand_money,cast((a.demand_money/b.total_money)as decimal(10,4))rat from (select '40'mat_id,'工具'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '40%' ) and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0')a inner join (select '40'mat_id,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '26'orderNum,a.mat_id,a.code_name,(b.demand_num-a.demand_num)demand_num,(b.total_money-a.demand_money)demand_money,cast(((b.total_money-a.demand_money)/b.total_money)as decimal(10,4))rat from (select '00'mat_id,'其他'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.bsflag='0' and  (i.coding_code_id like '1901%'or i.coding_code_id like '1905%'or i.coding_code_id like '1903%'or i.coding_code_id like '07%'or i.coding_code_id like '70301%'or i.coding_code_id like '70303%'or i.coding_code_id like '705%'or i.coding_code_id like '32019904%'or i.coding_code_id like '36070205%'or i.coding_code_id like '37810104%'or i.coding_code_id like '40031514%'or i.coding_code_id like '20030314%'or i.coding_code_id like '19%' or i.coding_code_id like '12%'or i.coding_code_id like '21%'or i.coding_code_id like '08%'or i.coding_code_id like '1402%'or i.coding_code_id like '55%'or i.coding_code_id like '56%'or i.coding_code_id like '48%'or i.coding_code_id like '02%'or i.coding_code_id like '47%'or i.coding_code_id like '55%'or i.coding_code_id like '57%'or i.coding_code_id like '51010401%'or i.coding_code_id like '51012201%'or i.coding_code_id like '28%'or i.coding_code_id like '33060402%'or i.coding_code_id like '03%'or i.coding_code_id like '04%'or i.coding_code_id like '37%'or i.coding_code_id like '38%'or i.coding_code_id like '45%'or i.coding_code_id like '40%')and d.project_info_no='"
				+ projectInfoNo
				+ "'and d.bsflag='0' )a inner join (select '00'mat_id,sum(d.demand_num)demand_num,sum(d.demand_money)total_money from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0')b on a.mat_id=b.mat_id ");
		sql.append(" union all");
		sql.append(" select '27'orderNum,''mat_id,'合计'code_name,sum(d.demand_num)demand_num,sum(d.demand_money)demand_money,(sum(d.demand_money)/sum(d.demand_money))rat from gms_mat_demand_plan_detail d where d.project_info_no='"
				+ projectInfoNo + "'and d.bsflag='0'");

		list = jdbcDao.queryRecords(sql.toString());
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资计划配置综合详细页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRatioList(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String value = reqDTO.getValue("value");
		String[] ids = value.split("@");
		StringBuffer codingCodeId = new StringBuffer();
		for (int i = 0; i < ids.length; i++) {
			if (ids.length == 1) {
				codingCodeId.append("i.coding_code_id like '" + ids[i] + "%'");
			} else {
				if (ids.length > 1) {
					if (i == ids.length - 1) {
						codingCodeId.append("i.coding_code_id like '" + ids[i]
								+ "%')");
					} else {
						codingCodeId.append("(i.coding_code_id like '" + ids[i]
								+ "%'or ");
					}
				}
			}
		}
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.wz_id,i.coding_code_id,i.wz_name,i.wz_prickie,i.wz_price,d.demand_num,d.demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.project_info_no='"
				+ projectInfoNo + "'and b.bsflag='0'and " + codingCodeId + "";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资计划 调整计划在任务中的阶段
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg planItemListTo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String ids = reqDTO.getValue("laborId");
		String taskObjectId = reqDTO.getValue("taskObjectId");

		String[] id = ids.split(",");

		for (int i = 0; i < id.length; i++) {
			Map map = new HashMap();
			map.put("SUBMITE_NUMBER", id[i]);
			map.put("TASK_OBJECT_ID", taskObjectId);
			pureDao.saveOrUpdateEntity(map, "GMS_MAT_DEMAND_PLAN_BZ");
		}
		return reqMsg;
	}

	/**
	 * 小队物资消耗折线图单日消耗物资
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamwzList(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.coding_code_id,i.wz_id,i.wz_name,i.wz_prickie,d.actual_price,sum(d.mat_num)mat_num,sum(d.total_money)total_money from gms_mat_teammat_out t inner join (gms_mat_teammat_out_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.bsflag='0' and t.outmat_date like to_date('"
				+ value
				+ "','yyyy-mm-dd') and t.project_info_no='"
				+ projectInfoNo
				+ "' group by i.coding_code_id,i.wz_id,i.wz_name,i.wz_prickie,d.actual_price order by i.coding_code_id asc ,i.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 小队物资消耗折线图单日消耗物资
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeambzList(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select o.*,d.*,t.outmat_date from GMS_MAT_TEAMMAT_OUT t inner join (gms_mat_teammat_out_detail d inner join gms_mat_infomation o on d.wz_id=o.wz_id and o.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.team_id='"
				+ value
				+ "' and t.project_info_no ='"
				+ projectInfoNo
				+ "' and t.bsflag='0' order by o.coding_code_id asc ,o.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资计划配置其他详细页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRatioOtherList(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String value = reqDTO.getValue("value");
		String[] ids = value.split("@");
		StringBuffer codingCodeId = new StringBuffer();
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.wz_id,i.coding_code_id,i.wz_name,i.wz_prickie,i.wz_price,d.demand_num,d.demand_money from gms_mat_demand_plan_bz b inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on b.submite_number = d.submite_number and d.bsflag='0' where b.project_info_no='"
				+ projectInfoNo
				+ "'and b.bsflag='0'and b.plan_type='"
				+ value
				+ "'";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资用途
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryConRatio(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String radioValue = reqDTO.getValue("radioValue");
		String sql = "select d.coding_code_id value,d.coding_name lable from comm_coding_sort_detail d where d.coding_sort_id='5110000044'";
		if (radioValue != null && radioValue.equals("1")) {
			sql = sql
					+ " and (d.coding_code_id='5110000044000000006' or d.coding_code_id='5110000044000000005' or d.coding_code_id='5110000044000000007')";
		} else if (radioValue != null && radioValue.equals("2")) {
			sql = sql
					+ " and (d.coding_code_id='5110000044000000002' or d.coding_code_id='5110000044000000004' or d.coding_code_id='5110000044000000003' or d.coding_code_id='5110000044000000001')";
		}
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 班组物资发放页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOutLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		String selectId = reqDTO.getValue("selectId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.*,d.approve_num,d.use_num from GMS_MAT_DEMAND_PLAN_BZ t inner join (GMS_MAT_DEMAND_PLAN_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' where d.approve_num != (case when d.use_num is null then 0 else d.use_num end) and t.submite_number='"
				+ value
				+ "'and t.s_apply_team='"
				+ selectId
				+ "'and t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and t.bsflag='0'order by i.coding_code_id asc,i.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 资发放修改页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOutEditLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String teammatOutId = reqDTO.getValue("teammatOutId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.*,d.mat_num,d.total_money,d.actual_price from gms_mat_teammat_out_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where d.teammat_out_id='"
				+ teammatOutId
				+ "'and d.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' order by i.coding_code_id asc ,i.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 设备物资发放页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOutDevLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		String selectId = reqDTO.getValue("selectId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select d.plan_num,d.use_num,i.* from gms_mat_teammat_out t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id where d.plan_num !=(case when d.use_num is null then 0 else d.use_num end) and t.teammat_out_id='"
				+ value
				+ "' and t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and t.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资调拨验收页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTrac(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String invoicesId = reqDTO.getValue("invoicesId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.wz_name,i.coding_code_id,i.wz_id,i.wz_prickie,t.teammat_info_idetail_id,t.mat_num,t.actual_price,t.receive_number,t.total_money,t.warehouse_number,t.goods_allocation,t.give_out from GMS_MAT_TEAMMAT_INFO_DETAIL t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' where t.invoices_id = '"
				+ invoicesId
				+ "'and t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'and t.if_accept='1' order by i.coding_code_id asc,i.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 计划编制编辑页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findPlanLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select t.plan_detail_id,t.demand_money,t.demand_num,t.demand_date,t.note,i.wz_name,i.wz_prickie,i.wz_price,i.wz_id,i.coding_code_id from gms_mat_demand_plan_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.submite_number='"
				+ value + "'and t.bsflag='0'";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 计划编制编辑页面初始化----------大港
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findPlanLeafDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		// if(user.getOrgId().equals("C6000000005263")){
		// sql="select t.plan_detail_id,t.demand_money,t.demand_num,t.demand_date,t.note,i.wz_name,i.wz_prickie,i.wz_price,i.wz_id,i.coding_code_id,tt.stock_num from gms_mat_demand_plan_detail t inner join (select t.wz_id, case when  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end is null then 0 else  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end end stock_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then  1 else sum(t.stock_num) end, 3) actual_price, t.org_id,comm.org_abbreviation  from gms_mat_recyclemat_info t  inner join comm_org_information comm on t.org_id = comm.org_id left join  (select sum(plan_num) plan_num,wz_id  from gms_mat_demand_plan_flat where  plan_flat_type='1' and wz_type='1' group by wz_id ) flat   on t.wz_id=flat.wz_id where t.bsflag = '0' and t.wz_type = '1' and t.org_id = 'C6000000000039' and t.wz_type = '1' and t.bsflag = '0'  or t.org_id = 'C6000000000040' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005269' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005275' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005279' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005280' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005278' and t.bsflag = '0' and t.wz_type = '1' group by t.wz_id, t.org_id,comm.org_abbreviation,flat.plan_num) tt on t.wz_id = tt.wz_id and tt.stock_num > 0 inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.submite_number='"+value+"'and t.bsflag='0'";
		// }else{
		sql = "select t.plan_detail_id,t.demand_money,t.demand_num,t.demand_date,t.note,i.wz_name,i.wz_prickie,i.wz_price,i.wz_id,i.coding_code_id from gms_mat_demand_plan_detail t  inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.submite_number='"
				+ value + "'and t.bsflag='0'";
		// }
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 可重复物资计划编制编辑页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findRepPlanLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select t.plan_detail_id,t.demand_money,t.demand_num,t.demand_date,t.note,i.wz_name,i.wz_prickie,i.wz_price,i.wz_id,i.coding_code_id , nvl(t.demand_num,0)+nvl(r.stock_num,0) stock_num from gms_mat_demand_plan_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' inner join gms_mat_recyclemat_info r on t.wz_id=r.wz_id and r.bsflag='0' and r.wz_type='2' where r.org_subjection_id = (select org_subjection_id from bgp_comm_org_wtc w where (select org_subjection_id from gp_task_project_dynamic where project_info_no = '"
				+ user.getProjectInfoNo()
				+ "') like w.org_subjection_id || '%') and t.submite_number='"
				+ value + "'and t.bsflag='0'";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 计划编制详细信息信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findPlanList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.demand_num,t.approve_num,t.create_date,t.note,i.wz_name,i.wz_prickie,i.wz_price,i.wz_id,i.coding_code_id,t.demand_date from gms_mat_demand_plan_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.submite_number='"
				+ id
				+ "'and t.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划单号查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findPlanNum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select * from gms_mat_demand_plan_bz t where t.s_apply_team='"
				+ id
				+ "'and t.bsflag='0'and t.project_info_no='"
				+ user.getProjectInfoNo() + "'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划汇总单号查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findSumNum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String getDate = df.format(new Date());
		String sql = "select * from gms_mat_demand_plan_invoice t where t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'and t.compile_date=to_date('"
				+ getDate + "','yyyy-mm-dd')";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 物资发放单号查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findGrantNum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String getDate = df.format(new Date());
		String sql = "select t.teammat_out_id from gms_mat_teammat_out t inner join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id=d.teammat_out_id and d.bsflag='0'  where t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'and t.out_type<3 group by t.teammat_out_id";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划编制删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deletePlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_demand_plan_bz set bsflag = '1' where submite_number = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 计划详细信息删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deletePlanList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String submiteNumber = reqDTO.getValue("submiteNumber");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			String sql = "select * from  gms_mat_demand_plan_detail where wz_id = '"
					+ ids[i]
					+ "'and project_info_no='"
					+ user.getProjectInfoNo()
					+ "'and submite_number='"
					+ submiteNumber + "' and bsflag='0'";
			Map map = pureDao.queryRecordBySQL(sql);
			String upsql = "update gms_mat_demand_plan_detail set bsflag = '1' where plan_detail_id = '"
					+ map.get("plan_detail_id").toString() + "'";
			jdbcDao.executeUpdate(upsql);
		}
		return reqMsg;
	}

	/**
	 * 修改模板信息新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savePlanEdit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String submiteNumber = reqDTO.getValue("submiteNumber");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			Map tmap = new HashMap();
			tmap.put("wz_id", ids[i]);
			tmap.put("submite_number", submiteNumber);
			tmap.put("bsflag", "0");
			tmap.put("project_info_no", user.getProjectInfoNo());
			tmap.put("creator_id", user.getUserId());
			tmap.put("create_date", new Date());
			tmap.put("org_id", user.getOrgId());
			tmap.put("org_subjection_id", user.getOrgSubjectionId());
			tmap.put("team_id", user.getOrgId());
			pureDao.saveOrUpdateEntity(tmap, "gms_mat_demand_plan_detail");
		}
		return reqMsg;
	}

	/**
	 * 计划编制查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select * from gms_mat_demand_plan_bz t where t.bsflag='0'and t.submite_number='"
				+ id
				+ "'and t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' ";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 计划编制查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryPlanDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select * from gms_mat_demand_plan_bz t where t.bsflag='0'and t.submite_number='"
				+ id
				+ "'and t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' ";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 计划编制修改操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatePlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map bzmap = new HashMap();
		bzmap.put("submite_number", reqMap.get("submite_number").toString());
		bzmap.put("submite_id", reqMap.get("plannum").toString());

		/*********** start ***********/
		// 物化探不存s_apply_team
		if (reqMap.get("s_apply_team") != null)
			bzmap.put("s_apply_team", reqMap.get("s_apply_team").toString());
		/*********** end ***********/

		bzmap.put("plan_type", reqMap.get("plan_type").toString());
		// bzmap.put("if_purchase", reqMap.get("if_purchase").toString());
		bzmap.put("total_money", reqMap.get("total_money").toString());
		bzmap.put("modifi_date", new Date());
		bzmap.put("updator_id", user.getUserId());
		pureDao.saveOrUpdateEntity(bzmap, "gms_mat_demand_plan_bz");
		Map upmap = new HashMap();
		// 声明更新物资基本库的sql数组
		String[] updateSql = new String[ids.length];
		for (int i = 0; i < ids.length; i++) {
			// 定义更新物资基本库sql
			String matSql = "update gms_mat_infomation t set t.wz_price='"
					+ reqMap.get("wz_price_" + ids[i] + "").toString()
					+ "'where t.wz_id='" + ids[i] + "'";
			// 将sql存入数组中
			updateSql[i] = matSql;
			String demandMoney = "demand_money_" + ids[i];
			String demandNum = "demand_num_" + ids[i];
			String demandDate = "demand_date_" + ids[i];
			String note = "note_" + ids[i];
			String sql = "select * from  gms_mat_demand_plan_detail where wz_id = '"
					+ ids[i]
					+ "'and project_info_no='"
					+ user.getProjectInfoNo()
					+ "' and submite_number='"
					+ reqMap.get("submite_number") + "'and bsflag='0'";
			Map map = pureDao.queryRecordBySQL(sql);
			upmap.put("plan_detail_id", map.get("plan_detail_id"));
			upmap.put("demand_num", reqMap.get(demandNum).toString());
			upmap.put("approve_num", reqMap.get(demandNum).toString());
			upmap.put("demand_date", reqMap.get(demandDate).toString());
			upmap.put("demand_money", reqMap.get(demandMoney).toString());
			upmap.put("note", reqMap.get(note).toString());
			upmap.put("modifi_date", new Date());
			upmap.put("updator_id", user.getUserId());
			pureDao.saveOrUpdateEntity(upmap, "gms_mat_demand_plan_detail");
		}
		// 更新物资库单价
		jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		return reqMsg;
	}

	/**
	 * 计划编制修改操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateRepPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		Map bzmap = new HashMap();
		bzmap.put("submite_number", reqMap.get("submite_number").toString());
		bzmap.put("submite_id", reqMap.get("plannum").toString());

		/*********** start ***********/
		// 物化探不存s_apply_team
		if (reqMap.get("s_apply_team") != null)
			bzmap.put("s_apply_team", reqMap.get("s_apply_team").toString());
		/*********** end ***********/

		bzmap.put("plan_type", reqMap.get("plan_type").toString());
		// bzmap.put("if_purchase", reqMap.get("if_purchase").toString());
		bzmap.put("total_money", reqMap.get("total_money").toString());
		bzmap.put("modifi_date", new Date());
		bzmap.put("updator_id", user.getUserId());
		pureDao.saveOrUpdateEntity(bzmap, "gms_mat_demand_plan_bz");
		Map upmap = new HashMap();
		// 声明更新物资基本库的sql数组
		String[] updateSql = new String[ids.length];
		for (int i = 0; i < ids.length; i++) {
			// 定义更新物资基本库sql
			String matSql = "update gms_mat_infomation t set t.wz_price='"
					+ reqMap.get("wz_price_" + ids[i] + "").toString()
					+ "'where t.wz_id='" + ids[i] + "'";
			// 将sql存入数组中
			updateSql[i] = matSql;
			String demandMoney = "demand_money_" + ids[i];
			String demandNum = "demand_num_" + ids[i];
			String demandDate = "demand_date_" + ids[i];

			String note = "note_" + ids[i];
			String sql = "select * from  gms_mat_demand_plan_detail where wz_id = '"
					+ ids[i]
					+ "'and project_info_no='"
					+ user.getProjectInfoNo()
					+ "' and submite_number='"
					+ reqMap.get("submite_number") + "'and bsflag='0'";
			Map map = pureDao.queryRecordBySQL(sql);

			// 可重复利用物资库存操作
			String sqlRep = "select g.recyclemat_info,nvl(g.stock_num,0) stock_num,nvl(t.demand_num, 0) demand_num from GMS_MAT_RECYCLEMAT_INFO g left join gms_mat_demand_plan_detail t on t.wz_id=g.wz_id and t.bsflag='0' and t.plan_detail_id='"
					+ map.get("plan_detail_id")
					+ "'  where g.wz_type='2' and g.bsflag='0'and g.wz_id='"
					+ ids[i]
					+ "' and g.org_subjection_id = (select org_subjection_id from bgp_comm_org_wtc w where (select org_subjection_id from gp_task_project_dynamic where project_info_no = '"
					+ user.getProjectInfoNo()
					+ "') like w.org_subjection_id || '%')";
			Map getMap = pureDao.queryRecordBySQL(sqlRep);
			double num = Double.valueOf(getMap.get("stock_num").toString())
					+ Double.valueOf(getMap.get("demand_num").toString()); // 可重复数据库中该物资的库存量----lx
			if (reqMap.get(demandNum) == null
					|| reqMap.get(demandNum).toString().equals("")) {// 为空库存量不变
																		// ----lx
			} else {
				num = Double.valueOf(getMap.get("stock_num").toString())
						+ Double.valueOf(getMap.get("demand_num").toString())
						- Double.valueOf(reqMap.get(demandNum).toString()); // 现有库存量-需求数量=新库存量----lx
			}
			Map repMap = new HashMap();
			repMap.put("recyclemat_info", getMap.get("recyclemat_info"));
			repMap.put("stock_num", num);
			pureDao.saveOrUpdateEntity(repMap, "GMS_MAT_RECYCLEMAT_INFO");

			upmap.put("plan_detail_id", map.get("plan_detail_id"));
			upmap.put("demand_num", reqMap.get(demandNum).toString());
			upmap.put("approve_num", reqMap.get(demandNum).toString());
			upmap.put("demand_date", reqMap.get(demandDate).toString());
			upmap.put("demand_money", reqMap.get(demandMoney).toString());
			upmap.put("note", reqMap.get(note).toString());
			upmap.put("modifi_date", new Date());
			upmap.put("updator_id", user.getUserId());
			pureDao.saveOrUpdateEntity(upmap, "gms_mat_demand_plan_detail");

		}
		// 更新物资库单价
		jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		return reqMsg;
	}

	/**
	 * 计划编制汇总
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savePlanSum(ISrvMsg reqDTO) throws Exception {

		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqmap = reqDTO.toMap();
		String plan_invoice_type = "";
		if (reqmap.get("plan_invoice_type") != null) {
			plan_invoice_type = reqmap.get("plan_invoice_type").toString();
		}

		System.out.println(plan_invoice_type);
		String id = reqmap.get("laborId").toString();
		String value = reqDTO.getValue("value");
		String[] ids = id.split(",");
		String[] values = value.split(",");
		// 新增物资计划版本信息
		String getSql = "select t.planversions_id from gms_mat_demand_planversions t where t.project_info_no = '"
				+ projectInfoNo + "' ";
		Map getMap = ijdbcDao.queryRecordBySQL(getSql);
		if (getMap == null) {
			Map pmap = new HashMap();
			pmap.put("planversions_name", "物资计划版本");
			pmap.put("planversions_no", "1.0");
			pmap.put("submite_if", "1");
			pmap.put("compile_date", new Date());
			pmap.put("org_id", user.getOrgId());
			pmap.put("org_subjection_id", user.getOrgSubjectionId());
			pmap.put("creator_id", user.getUserId());
			pmap.put("project_info_no", projectInfoNo);
			pmap.put("bsflag", "0");
			Serializable planversionsId = pureDao.saveOrUpdateEntity(pmap,
					"gms_mat_demand_planversions");
			// 生成提交表单
			Map pimap = new HashMap();
			pimap.put("planversions_id", planversionsId.toString());
			pimap.put("submite_if", "0");
			pimap.put("bsflag", "0");
			pimap.put("project_info_no", projectInfoNo);
			pimap.put("compile_date", reqmap.get("compile_date"));
			pimap.put("total_money", reqmap.get("total_money"));
			pimap.put("submite_number", reqmap.get("submite_number"));
			pimap.put("plan_name", reqmap.get("plan_name"));
			// 新增主办区域，备注 --------lx
			pimap.put("main_part", reqmap.get("main_part"));
			pimap.put("memo", reqmap.get("memo"));

			pimap.put("org_id", user.getOrgId());
			pimap.put("org_subjection_id", user.getOrgSubjectionId());
			pimap.put("creator_id", user.getUserId());
			pimap.put("create_date", new Date());
			pimap.put("plan_invoice_type", plan_invoice_type);
			Serializable planInvoiceId = pureDao.saveOrUpdateEntity(pimap,
					"gms_mat_demand_plan_invoice");
			for (int m = 0; m < values.length; m++) {
				String upsql = "update gms_mat_demand_plan_bz t set t.plan_invoice_id='"
						+ planInvoiceId.toString()
						+ "' where t.submite_number='"
						+ values[m]
						+ "' and t.plan_invoice_id='0'and t.bsflag='0'";
				String upDevSql = "update gms_mat_teammat_out t set t.plan_invoice_id='"
						+ planInvoiceId.toString()
						+ "' where t.teammat_out_id='"
						+ values[m]
						+ "' and t.plan_invoice_id='0'and t.bsflag='0'";
				jdbcDao.executeUpdate(upsql);
				jdbcDao.executeUpdate(upDevSql);

			}
			for (int i = 0; i < ids.length; i++) {
				String demandNum = "demand_num" + ids[i];
				String planMoney = "plan_money" + ids[i];
				String haveNum = "have_num" + ids[i];
				// String regulateNum = "regulate_num" + ids[i];
				String applyNum = "apply_num" + ids[i];
				// 汇总信息
				Map dumap = new HashMap();
				dumap.put("planversions_id", planversionsId.toString());
				dumap.put("wz_id", ids[i]);
				dumap.put("demand_num", reqmap.get(demandNum));
				dumap.put("plan_money", reqmap.get(planMoney));
				dumap.put("bsflag", "0");
				dumap.put("create_date", new Date());
				dumap.put("project_info_no", projectInfoNo);
				pureDao.saveOrUpdateEntity(dumap, "gms_mat_demand_useplan");
				// 汇总申请信息
				Map dpmap = new HashMap();
				dpmap.put("plan_invoice_id", planInvoiceId.toString());
				dpmap.put("wz_id", ids[i]);
				dpmap.put("demand_num", reqmap.get(demandNum));
				dpmap.put("plan_money", reqmap.get(planMoney));
				dpmap.put("have_num", reqmap.get(haveNum));
				// dpmap.put("regulate_num", reqmap.get(regulateNum));
				dpmap.put("apply_num", reqmap.get(applyNum));
				dpmap.put("demand_date", new Date());
				dpmap.put("bsflag", "0");
				dpmap.put("project_info_no", projectInfoNo);
				dpmap.put("creator_id", user.getUserId());
				dpmap.put("org_id", user.getOrgId());
				dpmap.put("org_subjection_id", user.getOrgSubjectionId());
				pureDao.saveOrUpdateEntity(dpmap, "gms_mat_demand_plan");
			}
		} else {
			// 生成提交表单
			Map pimap = new HashMap();

			pimap.put("planversions_id", getMap.get("planversionsId"));
			pimap.put("submite_number", reqmap.get("submite_number"));
			pimap.put("submite_if", "0");
			pimap.put("bsflag", "0");
			pimap.put("project_info_no", projectInfoNo);
			pimap.put("total_money", reqmap.get("total_money"));
			pimap.put("compile_date", reqmap.get("compile_date"));
			pimap.put("plan_name", reqmap.get("plan_name"));
			// 新增主办区域，备注 --------lx
			pimap.put("main_part", reqmap.get("main_part"));
			pimap.put("memo", reqmap.get("memo"));

			pimap.put("org_id", user.getOrgId());
			pimap.put("org_subjection_id", user.getOrgSubjectionId());
			pimap.put("creator_id", user.getUserId());
			pimap.put("create_date", new Date());
			pimap.put("plan_invoice_type", plan_invoice_type);
			Serializable planInvoiceId = pureDao.saveOrUpdateEntity(pimap,
					"gms_mat_demand_plan_invoice");
			for (int m = 0; m < values.length; m++) {
				String upsql = "update gms_mat_demand_plan_bz t set t.plan_invoice_id='"
						+ planInvoiceId.toString()
						+ "' where t.submite_number='"
						+ values[m]
						+ "' and t.plan_invoice_id='0'and t.bsflag='0'";
				String upDevSql = "update gms_mat_teammat_out t set t.plan_invoice_id='"
						+ planInvoiceId.toString()
						+ "' where t.teammat_out_id='"
						+ values[m]
						+ "' and t.plan_invoice_id='0'and t.bsflag='0'";
				jdbcDao.executeUpdate(upsql);
				jdbcDao.executeUpdate(upDevSql);
			}
			for (int i = 0; i < ids.length; i++) {
				String demandNum = "demand_num" + ids[i];
				String planMoney = "plan_money" + ids[i];
				String haveNum = "have_num" + ids[i];
				// String regulateNum = "regulate_num" + ids[i];
				String applyNum = "apply_num" + ids[i];
				// 汇总信息
				Map dumap = new HashMap();
				dumap.put("planversions_id", getMap.get("planversionsId"));
				dumap.put("wz_id", ids[i]);
				dumap.put("demand_num", reqmap.get(demandNum));
				dumap.put("plan_money", reqmap.get(planMoney));
				dumap.put("bsflag", "0");
				dumap.put("create_date", new Date());
				dumap.put("project_info_no", projectInfoNo);
				pureDao.saveOrUpdateEntity(dumap, "gms_mat_demand_useplan");
				// 物资需求明细

				Map dpmap = new HashMap();
				dpmap.put("plan_invoice_id", planInvoiceId.toString());
				dpmap.put("wz_id", ids[i]);
				dpmap.put("demand_num", reqmap.get(demandNum));
				dpmap.put("plan_money", reqmap.get(planMoney));
				dpmap.put("have_num", reqmap.get(haveNum));
				// dpmap.put("regulate_num", reqmap.get(regulateNum));
				dpmap.put("apply_num", reqmap.get(applyNum));
				dpmap.put("demand_date", new Date());
				dpmap.put("bsflag", "0");
				dpmap.put("project_info_no", projectInfoNo);
				dpmap.put("org_id", user.getOrgId());
				dpmap.put("org_subjection_id", user.getOrgSubjectionId());
				dpmap.put("creator_id", user.getUserId());
				pureDao.saveOrUpdateEntity(dpmap, "gms_mat_demand_plan");
			}
		}
		return reqMsg;
	}

	/**
	 * 计划编制汇总信息修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatePlanSum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String id = reqmap.get("laborId").toString();
		String[] ids = id.split(",");
		Map pimap = new HashMap();
		pimap.put("plan_invoice_id", reqmap.get("plan_invoice_id"));
		pimap.put("compile_date", reqmap.get("compile_date"));
		pimap.put("total_money", reqmap.get("total_money"));
		pimap.put("submite_number", reqmap.get("submite_number"));
		pimap.put("plan_name", reqmap.get("plan_name"));
		// 新增主办区域，备注 --------lx
		pimap.put("main_part", reqmap.get("main_part"));
		pimap.put("memo", reqmap.get("memo"));

		pimap.put("creator_id", user.getUserId());
		pimap.put("create_date", new Date());
		pureDao.saveOrUpdateEntity(pimap, "gms_mat_demand_plan_invoice");
		for (int i = 0; i < ids.length; i++) {
			String haveNum = "have_num" + ids[i];
			// String regulateNum = "regulate_num" + ids[i];
			String applyNum = "apply_num" + ids[i];
			Map dpmap = new HashMap();
			dpmap.put("plan_id", ids[i]);
			dpmap.put("have_num", reqmap.get(haveNum));
			// dpmap.put("regulate_num", reqmap.get(regulateNum));
			dpmap.put("apply_num", reqmap.get(applyNum));
			String sql = "update gms_mat_demand_plan t set t.apply_num='"
					+ reqmap.get(applyNum) + "',t.have_num='"
					+ reqmap.get(haveNum) + "' where t.plan_invoice_id='"
					+ reqmap.get("plan_invoice_id") + "'and t.wz_id='" + ids[i]
					+ "'";
			// pureDao.saveOrUpdateEntity(, "gms_mat_demand_plan");
			jdbcDao.executeUpdate(sql);

		}
		return reqMsg;
	}

	/**
	 * 计划编制删除
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteMatSub(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_demand_plan_invoice t set t.bsflag='1' where t.plan_invoice_id='"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		String upsql = "update gms_mat_demand_plan_bz t set t.plan_invoice_id='0' where t.plan_invoice_id='"
				+ id + "'and t.bsflag='0'";
		String upDevSql = "update gms_mat_teammat_out t set t.plan_invoice_id='0' where t.plan_invoice_id='"
				+ id + "'and t.bsflag='0'";
		jdbcDao.executeUpdate(upsql);
		jdbcDao.executeUpdate(upDevSql);
		return reqMsg;
	}

	/**
	 * 计划编制提交
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitMat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_demand_plan_invoice t set t.submite_if='1' where t.plan_invoice_id='"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 计划编制信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select u.*,m.wz_name from gms_mat_demand_useplan u inner join GMS_MAT_INFOMATION m on u.wz_id = m.wz_id and m.bsflag='0'and u.bsflag='0' and planversions_id = '"
				+ id + "'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划编制明细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubDetaile(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.submite_id,i.wz_name,d.demand_num,d.approve_num,d.demand_date,i.note,s.coding_name from gms_mat_demand_plan_bz t inner join (gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where t.plan_invoice_id='"
				+ id
				+ "'and t.bsflag='0' union select t.procure_no,i.wz_name,d.plan_num demand_num,d.app_num approve_num,t.create_date demand_date,i.note,t.device_use_name coding_name from GMS_MAT_TEAMMAT_OUT t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.plan_invoice_id='"
				+ id + "'and t.bsflag='0'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划编制审批信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getappDetaile(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select decode(t.submite_if,'1','待审批','2','审批未通过','3','审批通过','4','调剂未通过','5','调剂通过') submite_if,t.modifi_date,u.user_name,t.remark from gms_mat_demand_plan_invoice t left join p_auth_user u on t.updator_id=u.user_id and u.bsflag=0 where t.plan_invoice_id ='"
				+ id + "' and t.submite_if>0 and t.bsflag='0'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划编制版本信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getplanSum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String sql = "select * from gms_mat_demand_planversions where project_info_no = '"
				+ projectInfoNo + "' order by create_date desc ";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 计划编制汇总小队
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanTeam(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		// 4月16-2015 屏蔽陆地项目中物资计划-储备计划
		String sql = "select o.teammat_out_id submite_number,o.procure_no submite_id,u.user_name,i.org_name,c.dev_ci_name coding_name from gms_mat_teammat_out o left join p_auth_user u on o.creator_id=u.user_id left join comm_org_information i on o.org_id=i.org_id inner join GMS_MAT_DEVICE_USE_INFO_DETAIL d on o.teammat_out_id=d.teammat_out_id left join gms_device_codeinfo c on o.device_id = c.dev_ci_code where o.bsflag='0'and o.plan_invoice_id='0'and o.project_info_no='"
				+ value
				+ "' and o.status='1' group by o.teammat_out_id ,o.procure_no ,u.user_name,i.org_name,c.dev_ci_name union all select t.submite_number,t.submite_id,u.user_name,i.org_name,d.coding_name from gms_mat_demand_plan_bz t left join p_auth_user u on t.creator_id=u.user_id left join comm_org_information i on t.org_id=i.org_id left join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id where t.if_submit='1'and ( t.if_purchase='2') and t.bsflag='0'and t.plan_invoice_id='0'and t.project_info_no='"
				+ value + "'";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 大港计划编制汇总小队
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanTeamDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = " select t.submite_number,t.submite_id,u.user_name,i.org_name,d.coding_name,case SUBSTR(t.submite_id,0,3) when  'WZG' then '物资供应' when 'ZYH' then '专业化'  when 'ZCG' then '自采购' else '专业化' end type from gms_mat_demand_plan_bz t left join p_auth_user u on t.creator_id=u.user_id left join comm_org_information i on t.org_id=i.org_id left join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id where t.if_submit='1'and (t.if_purchase='1' or t.if_purchase='2') and t.bsflag='0'and t.plan_invoice_id='0'and t.project_info_no='"
				+ value + "'";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 获得计划编制汇总信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubDate(ISrvMsg reqDTO) throws Exception {

		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		String[] ids = id.split(",");
		List<Map> list = new ArrayList<Map>();
		String submiteNumber = "";
		String teammatOutId = "";
		for (int i = 0; i < ids.length; i++) {
			if (i == ids.length - 1) {
				submiteNumber += "t.submite_number='" + ids[i] + "'";
			} else {
				submiteNumber += "t.submite_number='" + ids[i] + "'or ";
			}
		}
		for (int i = 0; i < ids.length; i++) {
			if (i == ids.length - 1) {
				teammatOutId += "t.teammat_out_id='" + ids[i] + "'";
			} else {
				teammatOutId += "t.teammat_out_id='" + ids[i] + "'or ";
			}
		}
		// 增加物资单位
		String sql = "select i.wz_id,i.coding_code_id,i.wz_name,i.wz_price,sum(d.approve_num)demand_num,i.mat_desc,d.have_num from gms_mat_demand_plan_bz t inner join ((select t.approve_num,t.demand_money,t.submite_number,t.wz_id,i.stock_num have_num from gms_mat_demand_plan_detail t left join GMS_MAT_TEAMMAT_INFO i on t.wz_id=i.wz_id and i.bsflag='0' and t.bsflag='0' and i.project_info_no='"
				+ projectInfoId
				+ "' ) d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number inner join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where "
				+ submiteNumber
				+ " and t.plan_invoice_id='0'and t.bsflag='0' group by i.wz_name,i.coding_code_id,i.wz_price,i.mat_desc,i.wz_id,d.have_num";
		sql += " union all select mi.wz_id,mi.coding_code_id,mi.wz_name,mi.wz_price,sum(t.approve_num)demand_num,mi.mat_desc,t.have_num from(select t.app_num approve_num,t.teammat_out_id,t.wz_id,i.stock_num have_num from GMS_MAT_DEVICE_USE_INFO_DETAIL t left join GMS_MAT_TEAMMAT_INFO i on t.wz_id=i.wz_id and i.bsflag='0' and t.bsflag='0' and i.project_info_no='"
				+ projectInfoId
				+ "' )t inner join gms_mat_infomation mi on t.wz_id=mi.wz_id and mi.bsflag='0' where "
				+ teammatOutId
				+ " group by  mi.wz_id,mi.coding_code_id,mi.wz_name,mi.wz_price,mi.mat_desc,t.have_num order by coding_code_id asc,wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 获得计划编制汇总信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubDateDg(ISrvMsg reqDTO) throws Exception {

		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		String[] ids = id.split(",");
		List<Map> list = new ArrayList<Map>();
		String submiteNumber = "";
		String teammatOutId = "";
		for (int i = 0; i < ids.length; i++) {
			if (i == ids.length - 1) {
				submiteNumber += "t.submite_number='" + ids[i] + "'";
			} else {
				submiteNumber += "t.submite_number='" + ids[i] + "'or ";
			}
		}
		for (int i = 0; i < ids.length; i++) {
			if (i == ids.length - 1) {
				teammatOutId += "t.teammat_out_id='" + ids[i] + "'";
			} else {
				teammatOutId += "t.teammat_out_id='" + ids[i] + "'or ";
			}
		}
		// 增加物资单位
		// String sql =
		// "select i.wz_id,i.coding_code_id,i.wz_name, i.wz_price,i.wz_prickie,to_char(tt.demand_date, 'yyyy-MM-dd') as create_date,tt.demand_num,i.mat_desc from (select d.wz_id, sum(d.approve_num) demand_num ,d.demand_date from gms_mat_demand_plan_bz t inner join (select t.approve_num,t.demand_money,t.submite_number,t.wz_id,i.stock_num have_num,t.demand_date from gms_mat_demand_plan_detail t left join GMS_MAT_TEAMMAT_INFO i on t.wz_id=i.wz_id and i.bsflag='0' and t.bsflag='0' and i.project_info_no='"+projectInfoId+"'  where t.bsflag='0') d  on t.submite_number=d.submite_number left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where "+submiteNumber+" and t.plan_invoice_id='0'and t.bsflag='0' group by d.wz_id,d.demand_date) tt inner join gms_mat_infomation i on tt.wz_id = i.wz_id and i.bsflag='0'";
		String sql = "select i.wz_id,i.coding_code_id,i.wz_name, i.wz_price,i.wz_prickie,tt.demand_num,i.mat_desc from (select d.wz_id, sum(d.approve_num) demand_num  from gms_mat_demand_plan_bz t inner join (select t.approve_num,t.demand_money,t.submite_number,t.wz_id,i.stock_num have_num,t.demand_date from gms_mat_demand_plan_detail t left join GMS_MAT_TEAMMAT_INFO i on t.wz_id=i.wz_id and i.bsflag='0' and t.bsflag='0' and i.project_info_no='"
				+ projectInfoId
				+ "'  where t.bsflag='0') d  on t.submite_number=d.submite_number left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where "
				+ submiteNumber
				+ " and t.plan_invoice_id='0'and t.bsflag='0' group by d.wz_id) tt inner join gms_mat_infomation i on tt.wz_id = i.wz_id and i.bsflag='0'";
		sql += " union all select mi.wz_id,mi.coding_code_id,mi.wz_name,mi.wz_price,mi.wz_prickie,sum(t.approve_num)demand_num,mi.mat_desc from(select t.app_num approve_num,t.teammat_out_id,t.wz_id,i.stock_num have_num from GMS_MAT_DEVICE_USE_INFO_DETAIL t left join GMS_MAT_TEAMMAT_INFO i on t.wz_id=i.wz_id and i.bsflag='0' and t.bsflag='0' and i.project_info_no='"
				+ projectInfoId
				+ "' )t inner join gms_mat_infomation mi on t.wz_id=mi.wz_id and mi.bsflag='0' where "
				+ teammatOutId
				+ " group by mi.wz_id, mi.coding_code_id, mi.wz_name,mi.wz_price,mi.mat_desc,mi.wz_prickie,  mi.create_date order by coding_code_id asc, wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 计划表单编辑页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanEdit(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String planInvoiceId = reqDTO.getValue("planInvoiceId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select s.demand_num,t.plan_id,t.have_num,t.regulate_num,t.apply_num,(m.wz_price*s.demand_num*1000/1000)  as plan_money,m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,c.code_desc,c.code_name,t.demand_date from GMS_MAT_DEMAND_PLAN t inner join (select sum(d.approve_num)demand_num,d.wz_id,b.plan_invoice_id from GMS_MAT_DEMAND_PLAN_BZ b inner join GMS_MAT_DEMAND_PLAN_DETAIL d on b.submite_number=d.submite_number and d.bsflag='0' where  b.plan_invoice_id ='"
				+ planInvoiceId
				+ "' and b.bsflag='0' group by d.wz_id,b.plan_invoice_id)s on t.wz_id=s.wz_id inner join gms_mat_infomation m on t.wz_id = m.wz_id and t.bsflag='0'and m.bsflag='0' left join gms_mat_coding_code c on m.coding_code_id=c.coding_code_id and c.bsflag='0' where t.plan_invoice_id ='"
				+ planInvoiceId + "' and t.bsflag='0'";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 计划表单编辑页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamEdit(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String planInvoiceId = reqDTO.getValue("planInvoiceId");
		List<Map> list = new ArrayList<Map>();
		String org_subjection_id = user.getOrgSubjectionId();
		String ss = user.getOrgId();
		String sql = "select i.wz_id,i.coding_code_id,i.wz_name,i.wz_price,sum(d.approve_num)demand_num,i.mat_desc,d.have_num,d.regulate_num,s.coding_name,d.demand_date from gms_mat_demand_plan_bz t inner join ((select t.approve_num,t.demand_money,t.submite_number,t.wz_id,i.stock_num have_num,r.stock_num regulate_num,t.demand_date from gms_mat_demand_plan_detail t left join GMS_MAT_TEAMMAT_INFO i on t.wz_id=i.wz_id and i.bsflag='0' and t.bsflag='0' and i.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' left join GMS_MAT_RECYCLEMAT_INFO r on t.wz_id=r.wz_id and r.bsflag='0' and '"
				+ org_subjection_id
				+ "' like r.org_subjection_id||'%' where t.bsflag='0') d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where t.plan_invoice_id='"
				+ planInvoiceId
				+ "'and t.bsflag='0' group by i.wz_name,i.coding_code_id,i.wz_price,i.mat_desc,i.wz_id,d.have_num,d.regulate_num, s.coding_name,d.demand_date union all  select mi.wz_id,mi.coding_code_id,mi.wz_name,mi.wz_price,sum(t.approve_num)demand_num,mi.mat_desc,t.have_num,t.regulate_num,dev.dev_name coding_name,o.outmat_date from GMS_MAT_TEAMMAT_OUT o inner join ((select t.app_num approve_num,t.teammat_out_id,t.wz_id,i.stock_num have_num,r.stock_num regulate_num from GMS_MAT_DEVICE_USE_INFO_DETAIL t left join GMS_MAT_TEAMMAT_INFO i on t.wz_id=i.wz_id and i.bsflag='0' and t.bsflag='0' and i.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' left join GMS_MAT_RECYCLEMAT_INFO r on t.wz_id=r.wz_id and r.bsflag='0')t inner join gms_mat_infomation mi on t.wz_id=mi.wz_id and mi.bsflag='0')on o.teammat_out_id = t.teammat_out_id and o.bsflag='0' inner join gms_device_account dev on o.dev_acc_id=dev.dev_acc_id where o.plan_invoice_id='"
				+ planInvoiceId
				+ "' group by  mi.wz_id,mi.coding_code_id,mi.wz_name,mi.wz_price,mi.mat_desc,t.have_num,t.regulate_num,dev.dev_name,o.outmat_date order by coding_code_id asc,wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 计划表单编辑页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubTeamEdit(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String planInvoiceId = reqDTO.getValue("planInvoiceId");
		String[] ids = planInvoiceId.split(",");
		List<Map> list = new ArrayList();
		for (int i = 0; i < ids.length; i++) {
			String sql = "select i.wz_name,d.plan_detail_id,d.demand_num,d.approve_num approve_num,d.demand_date,i.note,s.coding_name from gms_mat_demand_plan_bz t inner join (gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where t.submite_number='"
					+ ids[i] + "'and t.bsflag='0'";
			sql += " union all select i.wz_name,d.use_info_detail plan_detail_id,d.plan_num demand_num,d.app_num approve_num,t.create_date demand_date ,i.note,t.procure_no coding_name  from GMS_MAT_TEAMMAT_OUT t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='"
					+ ids[i] + "'";
			List getList = jdbcDao.queryRecords(sql);
			for (int j = 0; j < getList.size(); j++) {
				list.add((Map) getList.get(j));
			}
		}
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 计划表单编辑页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubTeamLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String planInvoiceId = reqDTO.getValue("planInvoiceId");
		String[] ids = planInvoiceId.split(",");
		List<Map> list = new ArrayList();
		for (int i = 0; i < ids.length; i++) {
			String sql = "select i.wz_name,d.plan_detail_id,d.demand_num,d.approve_num approve_num,d.demand_date,i.note,s.coding_name from gms_mat_demand_plan_bz t inner join (gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where t.plan_invoice_id='"
					+ ids[i] + "'and t.bsflag='0'";
			sql += " union all select i.wz_name,d.use_info_detail plan_detail_id,d.plan_num demand_num,d.app_num approve_num,t.create_date demand_date ,i.note,t.procure_no coding_name  from GMS_MAT_TEAMMAT_OUT t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.plan_invoice_id='"
					+ ids[i] + "'";
			List getList = jdbcDao.queryRecords(sql);
			for (int j = 0; j < getList.size(); j++) {
				list.add((Map) getList.get(j));
			}
		}
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 提交计划信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		// String sql =
		// "select ab.demand_num,t.have_num,t.regulate_num,t.apply_num,t.plan_money,m.coding_code_id,m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,c.code_desc,c.code_name from GMS_MAT_DEMAND_PLAN t inner join gms_mat_infomation m on t.wz_id = m.wz_id and t.bsflag='0'and m.bsflag='0'inner join gms_mat_coding_code c on m.coding_code_id=c.coding_code_id and c.bsflag='0' inner join gms_mat_demand_plan_detail ab on ab.wz_id=m.wz_id and m.bsflag='0' where t.plan_invoice_id ='"
		// + id + "' order by m.coding_code_id asc,m.wz_id asc";
		// 20号修改--计划编制--->送审显示！
		String sql = "select s.demand_num,t.plan_id,t.have_num,t.regulate_num,t.apply_num,t.plan_money,m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,c.code_desc,c.code_name,t.demand_date from GMS_MAT_DEMAND_PLAN t inner join (select sum(d.approve_num)demand_num,d.wz_id,b.plan_invoice_id from GMS_MAT_DEMAND_PLAN_BZ b inner join GMS_MAT_DEMAND_PLAN_DETAIL d on b.submite_number=d.submite_number and d.bsflag='0' where  b.plan_invoice_id ='"
				+ id
				+ "' and b.bsflag='0' group by d.wz_id,b.plan_invoice_id)s on t.wz_id=s.wz_id inner join gms_mat_infomation m on t.wz_id = m.wz_id and t.bsflag='0'and m.bsflag='0' left join gms_mat_coding_code c on m.coding_code_id=c.coding_code_id and c.bsflag='0' where t.plan_invoice_id ='"
				+ id + "' and t.bsflag='0'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 查询流程选择
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProcess(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubId = user.getOrgSubjectionId();
		if (orgSubId.startsWith("C105001") || orgSubId.startsWith("C105005")) {
			if (orgSubId.length() > 10) {
				orgSubId = orgSubId.substring(0, 10);
			}
		} else {
			if (orgSubId.length() >= 7) {
				orgSubId = orgSubId.substring(0, 7);
			}
		}
		String sql = "select * from gms_mat_process_judge t where t.org_subjection_id like '"
				+ orgSubId + "%'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划调剂审批信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAppList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.demand_num,t.have_num,t.regulate_num,t.apply_num,t.plan_money,m.wz_name,m.wz_prickie,m.wz_price,c.code_desc,c.code_name from GMS_MAT_DEMAND_PLAN t inner join gms_mat_infomation m on t.wz_id = m.wz_id and t.bsflag='0'and m.bsflag='0'inner join gms_mat_coding_code c on m.coding_code_id=c.coding_code_id and c.bsflag='0' where t.plan_invoice_id ='"
				+ id + "'and t.regulate_num>0";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 提交计划信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getplan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo,t.plan_invoice_type from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' where t.plan_invoice_id='"
				+ id + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 提交计划信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getplanPru(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select t.create_date,t.submite_number,o.org_name,u.user_name,p.project_name from gms_mat_demand_plan_bz t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' where t.submite_number='"
				+ id + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 判断是否已被提交
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubIf(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select case when wm.proc_status is null then '0' else wm.proc_status end proc_status from gms_mat_demand_plan_invoice p  left join  common_busi_wf_middle wm on p.plan_invoice_id=wm.business_id where p.plan_invoice_id='"
				+ id + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 大港小队送审状态判断是否已被提交
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubIfDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.submite_if from  gms_mat_demand_plan_invoice t where t.plan_invoice_id='"
				+ id + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 判断小队计划是否已被提交
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubTeam(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.if_submit,t.if_purchase from gms_mat_demand_plan_bz t where t.submite_number='"
				+ id + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 判断小队计划是否已被提交
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubTeamDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select m.proc_status as if_submit, if_purchase from gms_mat_demand_plan_bz t left join common_busi_wf_middle m on t.submite_number = m.business_id and m.bsflag = '0' where t.bsflag = '0' and t.submite_number='"
				+ id + "' order by t.if_purchase desc, t.create_date desc ";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 判断小队计划是否已被提交 ---井中
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSubTeamJZ(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select m.proc_status as if_submit, if_purchase from gms_mat_demand_plan_bz t left join common_busi_wf_middle m on t.submite_number = m.business_id and m.bsflag = '0' where t.bsflag = '0' and t.submite_number='"
				+ id
				+ "' and t.if_purchase = '1' order by t.if_purchase desc, t.create_date desc ";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 判断小队计划是否已被提交
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateTeam(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_demand_plan_bz t set  t.if_submit_dg='1',t.if_submit='1' where t.submite_number='"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 关闭小队计划禁止发放
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg closeTeam(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_demand_plan_bz t set  t.if_submit='4' where t.submite_number='"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 编制好的计划提交送审
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatePlanSub(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			// 更新送审需求申请单表信息
			Map map = new HashMap();
			String planId = "plan_id_" + ids[i];
			String haveNum = "have_num_" + ids[i];
			String regulateNum = "regulate_num_" + ids[i];
			String applyNum = "apply_num_" + ids[i];
			map.put("plan_id", reqMap.get(planId).toString());
			map.put("have_num", reqMap.get(haveNum).toString());
			map.put("regulate_num", reqMap.get(regulateNum).toString());
			map.put("apply_num", reqMap.get(applyNum).toString());
			pureDao.saveOrUpdateEntity(map, "gms_mat_demand_plan");
		}
		// 更新送审需求申请单表状态
		Map piMap = new HashMap();
		piMap.put("plan_invoice_id", reqMap.get("plan_invoice_id").toString());
		piMap.put("submite_if", "1");
		pureDao.saveOrUpdateEntity(piMap, "gms_mat_demand_plan_invoice");
		// 更新物资计划版本状态
		String sql = "select planversions_id from gms_mat_demand_plan_invoice where plan_invoice_id = '"
				+ reqMap.get("plan_invoice_id").toString() + "'";
		Map pmap = ijdbcDao.queryRecordBySQL(sql);
		Map map = new HashMap();
		map.put("planversions_id", pmap.get("planversionsId").toString());
		map.put("submite_if", "1");
		pureDao.saveOrUpdateEntity(map, "gms_mat_demand_planversions");
		return reqMsg;
	}

	/**
	 * 计划审批
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateApprove(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		// 更新送审需求申请单表状态
		Map piMap = new HashMap();
		piMap.put("plan_invoice_id", reqMap.get("plan_invoice_id").toString());
		piMap.put("submite_if", reqMap.get("submite_if").toString());
		piMap.put("remark", reqMap.get("remark").toString());
		piMap.put("updator_id", user.getUserId());
		piMap.put("modifi_date", new Date());
		pureDao.saveOrUpdateEntity(piMap, "gms_mat_demand_plan_invoice");
		// 更新物资计划版本状态
		String sql = "select planversions_id from gms_mat_demand_plan_invoice where plan_invoice_id = '"
				+ reqMap.get("plan_invoice_id").toString() + "'";
		Map pmap = ijdbcDao.queryRecordBySQL(sql);
		Map map = new HashMap();
		map.put("planversions_id", pmap.get("planversionsId").toString());
		map.put("submite_if", reqMap.get("submite_if").toString());
		pureDao.saveOrUpdateEntity(map, "gms_mat_demand_planversions");
		/*
		 * String submiteIf = reqMap.get("submite_if").toString(); if
		 * (submiteIf.equals("3")) { for (int i = 0; i < ids.length; i++) { //
		 * 更新送审需求申请单表信息 Map pamap = new HashMap(); String haveNum = "have_num_"
		 * + ids[i]; String regulateNum = "regulate_num_" + ids[i]; String
		 * planId = "plan_id_" + ids[i]; String applyNum = "apply_num_" +
		 * ids[i]; pamap.put("plan_id", reqMap.get(planId).toString());
		 * pamap.put("have_num", reqMap.get(haveNum).toString());
		 * pamap.put("regulate_num", reqMap.get(regulateNum).toString());
		 * pamap.put("apply_num", reqMap.get(applyNum).toString());
		 * pureDao.saveOrUpdateEntity(pamap, "gms_mat_demand_plan_adjust"); }
		 * 
		 * }
		 */
		return reqMsg;
	}

	/**
	 * 班组需求计划审批
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveTeamList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("planDetailId");
		System.out.println(id);
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			String planDetailId = ids[i].substring(0, ids[i].indexOf(":"));
			String approveNum = ids[i].substring(ids[i].indexOf(":") + 1);
			String sql = "update gms_mat_demand_plan_detail d set d.approve_num = '"
					+ approveNum
					+ "' where d.plan_detail_id='"
					+ planDetailId
					+ "'";
			String tsql = "update GMS_MAT_DEVICE_USE_INFO_DETAIL d set d.app_num = '"
					+ approveNum
					+ "' where d.use_info_detail='"
					+ planDetailId
					+ "'";
			jdbcDao.executeUpdate(sql);
			jdbcDao.executeUpdate(tsql);
		}
		// for(int i=0;i<ids.length;i++){
		// String[] temp = ids[i].split(":");
		// String planDetailId = temp[0];
		// String approveNum = temp[1];
		// if(temp.length==3){
		// String demandNum = temp[2];
		// System.out.println(demandNum);
		// String sql
		// ="update gms_mat_demand_plan_detail d set d.approve_num = '"+approveNum+"',d.demand_num='"+demandNum+"' where d.plan_detail_id='"+planDetailId+"'";
		// jdbcDao.executeUpdate(sql);
		// }else{
		// String sql
		// ="update gms_mat_demand_plan_detail d set d.approve_num = '"+approveNum+"' where d.plan_detail_id='"+planDetailId+"'";
		// jdbcDao.executeUpdate(sql);
		// }
		// String tsql
		// ="update GMS_MAT_DEVICE_USE_INFO_DETAIL d set d.app_num = '"+approveNum+"' where d.use_info_detail='"+planDetailId+"'";
		// jdbcDao.executeUpdate(tsql);
		// }
		return reqMsg;
	}

	/**
	 * 油料excel导入数据库
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		String errorMessage = "";
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List<Map> columnList = new ArrayList<Map>();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil.getExcelDataByWSFile(file);
			}
		}
		System.out.println(dataList.size());
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

		// 遍历dataList，操作数据库
		for (int i = 0; i < dataList.size(); i++) {
			Map dataMap = (Map) dataList.get(i);
			String sql = "select * from gms_device_account_dui d where d.project_info_id='"
					+ user.getProjectInfoNo()
					+ "'  and  (d.dev_coding='"
					+ dataMap.get("dev_coding")
					+ "'or d.dev_sign='"
					+ dataMap.get("dev_sign")
					+ "'or d.license_num='"
					+ dataMap.get("license_num")
					+ "'or d.self_num='"
					+ dataMap.get("self_num") + "')";
			Map getMap = pureDao.queryRecordBySQL(sql);
			if (dataMap.get("oil_from") == null) {
				errorMessage += "第" + (i + 2) + "条油料没有来源，它以下数据未执行录入操作！";
				reqMsg.setValue("errorMessage", errorMessage);
				break;
			}
			if (getMap == null) {
				errorMessage += "第" + (i + 2) + "条设备台账中不存在此设备，它以下数据未执行录入操作！";
				reqMsg.setValue("errorMessage", errorMessage);
				break;
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String actual_out_time = getMap.get("actual_out_time") == null ? ""
						: (String) getMap.get("actual_out_time"); // 设备实际返还时间
				String out_date = dataMap.get("out_date") == null ? ""
						: (String) dataMap.get("out_date"); // 发料时间

				if (actual_out_time.equals("")
						|| (!actual_out_time.equals("") && !out_date.equals("") && sdf
								.parse(actual_out_time).getTime() > sdf.parse(
								out_date).getTime())) {
					// 出库表单操作
					Map omap = new HashMap();
					omap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
					omap.put("oil_from", dataMap.get("oil_from"));
					omap.put("total_money", dataMap.get("total_money"));
					omap.put("outmat_date", getDate(dataMap.get("out_date")
							.toString()));// (String)dataMap.get("out_date")
					omap.put("out_type", "3");
					omap.put("org_id", user.getOrgId());
					omap.put("org_subjection_id", user.getOrgSubjectionId());
					omap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
					omap.put("CREATOR_ID", user.getUserId());
					omap.put("CREATE_DATE", new Date());
					omap.put("UPDATOR_ID", user.getUserId());
					omap.put("MODIFI_DATE", new Date());
					omap.put("BSFLAG", "0");
					if (dataMap.get("oil_from") != null
							&& dataMap.get("oil_from").equals("0")) {
						omap.put("WZ_TYPE", "0");
					}
					Serializable id = pureDao.saveOrUpdateEntity(omap,
							"GMS_MAT_TEAMMAT_OUT");
					// 出库明细操作
					Map tmap = new HashMap();
					tmap.put("TEAMMAT_OUT_ID", id);
					tmap.put("WZ_ID", dataMap.get("wz_id"));
					tmap.put("dev_acc_id", getMap.get("dev_acc_id"));
					tmap.put("mat_num", dataMap.get("mat_num"));
					tmap.put("oil_num", dataMap.get("oil_num"));
					tmap.put("actual_price", dataMap.get("actual_price"));
					tmap.put("total_money", dataMap.get("total_money"));
					tmap.put("BSFLAG", "0");
					tmap.put("org_id", user.getOrgId());
					tmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
					tmap.put("CREATOR_ID", user.getUserId());
					tmap.put("CREATE_DATE", new Date());
					tmap.put("UPDATOR_ID", user.getUserId());
					tmap.put("MODIFI_DATE", new Date());
					tmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
					pureDao.saveOrUpdateEntity(tmap,
							"GMS_MAT_TEAMMAT_OUT_DETAIL");
					// 入库明细操作
					String oil_from = dataMap.get("oil_from").toString();
					if (oil_from.equals("1")) {
						Map inmap = new HashMap();
						inmap.put("INVOICES_ID", id);
						inmap.put("WZ_ID", dataMap.get("wz_id"));
						inmap.put("mat_num", dataMap.get("mat_num"));
						inmap.put("actual_price", dataMap.get("actual_price"));
						inmap.put("total_money", dataMap.get("total_money"));
						inmap.put("INPUT_TYPE", "2");
						inmap.put("BSFLAG", "0");
						inmap.put("org_id", user.getOrgId());
						inmap.put("ORG_SUBJECTION_ID",
								user.getOrgSubjectionId());
						inmap.put("CREATOR_ID", user.getUserId());
						inmap.put("CREATE_DATE", dataMap.get("out_date"));
						inmap.put("UPDATOR_ID", user.getUserId());
						inmap.put("MODIFI_DATE", new Date());
						inmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
						pureDao.saveOrUpdateEntity(inmap,
								"GMS_MAT_TEAMMAT_INFO_DETAIL");
					}
				} else {
					errorMessage += "第" + (i + 2)
							+ "条设备返还日期不能小于加油日期，它以下数据未执行录入操作！";
					reqMsg.setValue("errorMessage", errorMessage);
					break;
				}
			}
		}
		reqMsg.setValue("errorMessage", "导入成功!");
		return reqMsg;
	}
	
	/**
	 * 多项目油料excel导入数据库
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDevMatExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		String errorMessage = "";
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List<Map> columnList = new ArrayList<Map>();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil.getExcelDataByWSFile(file);
			}
		}
		System.out.println(dataList.size());
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

		// 遍历dataList，操作数据库
		for (int i = 0; i < dataList.size(); i++) {
			Map dataMap = (Map) dataList.get(i);
			String sql = "select * from gms_device_account d where d.project_info_id='"
					+ user.getProjectInfoNo()
					+ "'  and  (d.dev_coding='"
					+ dataMap.get("dev_coding")
					+ "'or d.dev_sign='"
					+ dataMap.get("dev_sign")
					+ "'or d.license_num='"
					+ dataMap.get("license_num")
					+ "'or d.self_num='"
					+ dataMap.get("self_num") + "')";
			Map getMap = pureDao.queryRecordBySQL(sql);
			if (dataMap.get("oil_from") == null) {
				errorMessage += "第" + (i + 2) + "条油料没有来源，它以下数据未执行录入操作！";
				reqMsg.setValue("errorMessage", errorMessage);
				break;
			}
			if (getMap == null) {
				errorMessage += "第" + (i + 2) + "条设备台账中不存在此设备，它以下数据未执行录入操作！";
				reqMsg.setValue("errorMessage", errorMessage);
				break;
			} else {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String actual_out_time = getMap.get("actual_out_time") == null ? ""
						: (String) getMap.get("actual_out_time"); // 设备实际返还时间
				String out_date = dataMap.get("out_date") == null ? ""
						: (String) dataMap.get("out_date"); // 发料时间

				if (actual_out_time.equals("")
						|| (!actual_out_time.equals("") && !out_date.equals("") && sdf
								.parse(actual_out_time).getTime() > sdf.parse(
								out_date).getTime())) {
					// 出库表单操作
					Map omap = new HashMap();
					omap.put("oil_from", "0");
					omap.put("total_money", dataMap.get("total_money"));
					omap.put("outmat_date", getDate(dataMap.get("out_date")
							.toString()));// (String)dataMap.get("out_date")
					omap.put("out_type", "3");
					omap.put("org_id", user.getOrgId());
					omap.put("org_subjection_id", user.getOrgSubjectionId());
					omap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
					omap.put("CREATOR_ID", user.getUserId());
					omap.put("CREATE_DATE", new Date());
					omap.put("UPDATOR_ID", user.getUserId());
					omap.put("MODIFI_DATE", new Date());
					omap.put("BSFLAG", "0");
					omap.put("WZ_TYPE", "0");
					
					Serializable id = pureDao.saveOrUpdateEntity(omap,
							"GMS_MAT_TEAMMAT_OUT");
					// 出库明细操作
					Map tmap = new HashMap();
					tmap.put("TEAMMAT_OUT_ID", id);
					tmap.put("WZ_ID", dataMap.get("wz_id"));
					tmap.put("dev_acc_id", getMap.get("dev_acc_id"));
					tmap.put("mat_num", dataMap.get("mat_num"));
					tmap.put("oil_num", dataMap.get("oil_num"));
					tmap.put("actual_price", dataMap.get("actual_price"));
					tmap.put("total_money", dataMap.get("total_money"));
					tmap.put("BSFLAG", "0");
					tmap.put("org_id", user.getOrgId());
					tmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
					tmap.put("CREATOR_ID", user.getUserId());
					tmap.put("CREATE_DATE", new Date());
					tmap.put("UPDATOR_ID", user.getUserId());
					tmap.put("MODIFI_DATE", new Date());
					tmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
					pureDao.saveOrUpdateEntity(tmap,
							"GMS_MAT_TEAMMAT_OUT_DETAIL");
					// 入库明细操作
					Map inmap = new HashMap();
					inmap.put("INVOICES_ID", id);
					inmap.put("WZ_ID", dataMap.get("wz_id"));
					inmap.put("mat_num", dataMap.get("mat_num"));
					inmap.put("actual_price", dataMap.get("actual_price"));
					inmap.put("total_money", dataMap.get("total_money"));
					inmap.put("INPUT_TYPE", "2");
					inmap.put("BSFLAG", "0");
					inmap.put("org_id", user.getOrgId());
					inmap.put("ORG_SUBJECTION_ID",
							user.getOrgSubjectionId());
					inmap.put("CREATOR_ID", user.getUserId());
					inmap.put("CREATE_DATE", dataMap.get("out_date"));
					inmap.put("UPDATOR_ID", user.getUserId());
					inmap.put("MODIFI_DATE", new Date());
					inmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
					pureDao.saveOrUpdateEntity(inmap,
							"GMS_MAT_TEAMMAT_INFO_DETAIL");
					
				} 
			}
		}
		reqMsg.setValue("errorMessage", "导入成功!");
		return reqMsg;
	}

	public String getDate(String date) {
		String month = "";
		String day = "";
		String[] dateNum = date.split("-");
		int num = Integer.parseInt(dateNum[1]);
		int dayNum = Integer.parseInt(dateNum[2]);
		if (num < 10) {
			month = "0" + dateNum[1];
		} else {
			month = dateNum[1];
		}
		if (dayNum < 10) {
			day = "0" + dateNum[2];
		} else {
			day = dateNum[2];
		}
		return dateNum[0] + "-" + month + "-" + day;

	}

	/**
	 * 可重复利用物资excel导入数据库
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveExcelRepMat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		String errorMessage = null;
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List<Map> columnList = new ArrayList<Map>();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil
						.getRepMatExcelDataByWSFile(file);
			}
		}
		System.out.println(dataList.size());
		// 遍历dataList，操作数据库
		for (int i = 0; i < dataList.size(); i++) {
			Map dataMap = (Map) dataList.get(i);

			double stockNum = 0;

			String sql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
					+ dataMap.get("wz_id") + "'and t.bsflag='0'";
			Map getMap = pureDao.queryRecordBySQL(sql);
			stockNum = Double.valueOf(dataMap.get("stock_num").toString());
			if (getMap != null) {
				stockNum += Double.valueOf(getMap.get("stock_num").toString());
			}
			Map repMap = new HashMap();
			repMap.put("wz_id", dataMap.get("wz_id"));
			repMap.put("actual_price", dataMap.get("actual_price"));
			repMap.put("stock_num", stockNum);
			repMap.put("wz_type", "2");
			repMap.put("BSFLAG", "0");
			repMap.put("org_id", user.getOrgId());
			repMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			repMap.put("CREATOR_ID", user.getUserId());
			repMap.put("CREATE_DATE", dataMap.get("out_date"));
			repMap.put("UPDATOR_ID", user.getUserId());
			repMap.put("MODIFI_DATE", new Date());
			pureDao.saveOrUpdateEntity(repMap, "gms_mat_recyclemat_info");

		}
		return reqMsg;
	}

	private String getWzId(int sortno) {
		String pix = "";
		if (sortno < 10) {
			pix = "zy00000000";
		} else if (10 <= sortno && sortno < 100) {
			pix = "zy0000000";
		} else if (100 <= sortno && sortno < 1000) {
			pix = "zy000000";
		} else if (1000 <= sortno && sortno < 10000) {
			pix = "zy00000";
		} else if (10000 <= sortno && sortno < 100000) {
			pix = "zy0000";
		} else if (100000 <= sortno && sortno < 1000000) {
			pix = "zy000";
		} else if (1000000 <= sortno && sortno < 10000000) {
			pix = "zy00";
		} else if (10000000 <= sortno && sortno < 100000000) {
			pix = "zy0";
		} else if (100000000 <= sortno && sortno < 1000000000) {
			pix = "zy";
		}
		String wz_id = pix + sortno;
		return wz_id;
	}

	/**
	 * 模板定制新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTemLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(50);

		String id = reqDTO.getValue("ids");
		String value = reqDTO.getValue("value");
		String[] ids = id.split(",");
		System.out.println("codeIds:" + id);
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		if (value == null || value.equals("undefined")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0'";
		} else {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"
					+ value + "%'";
		}
		page = jdbcDao.queryRecordsBySQL(sql, page);
		list = page.getData();
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			int j = 0;
			for (j = 0; j < ids.length; j++) {

				if (map.get("wz_id").toString().equals(ids[j])) {
					map.put("disabled", "disabled");
					break;
				}
			}
			if (j == ids.length) {
				map.put("disabled", "");
			}
		}
		reqMsg.setValue("datas", page.getData());
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 大港各中心物资
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTemLeafDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(50);

		String id = reqDTO.getValue("ids");
		String tamplateName = reqDTO.getValue("tamplate_name");
		String wzId = reqDTO.getValue("wz_id");
		String codingCodeId = reqDTO.getValue("coding_code_id");
		String[] ids = id.split(",");
		System.out.println("codeIds:" + id);
		List<Map> list = new ArrayList<Map>();
		String orgId = user.getOrgId();
		String sql = "";
		if (orgId == "C6000000005263") {
			// var
			// sql="select i.*,c.code_name,t.stock_num,t.recyclemat_info,org_abbreviation from gms_mat_recyclemat_info t inner join comm_org_information comm on t.org_id=comm.org_id inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id and t.bsflag='0'and t.wz_type='"+type+"' and t.org_id in (select org_id from comm_org_information  where org_id= 'C6000000000039' and bsflag='0' or org_id= 'C6000000000040' and bsflag='0' or org_id= 'C6000000005269' and bsflag='0' or org_id= 'C6000000005275' and bsflag='0' or org_id= 'C6000000005279' and bsflag='0' or org_id= 'C6000000005280' and bsflag='0' or org_id= 'C6000000005278' and bsflag='0')";
			sql = "select i.*,c.code_name, tt.stock_num,tt.actual_price, tt.org_id,tt.org_abbreviation from (select t.wz_id, case when  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end is null then 0 else  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end end stock_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then  1 else sum(t.stock_num) end, 3) actual_price, t.org_id,comm.org_abbreviation  from gms_mat_recyclemat_info t  inner join comm_org_information comm on t.org_id = comm.org_id left join  (select sum(plan_num) plan_num,wz_id  from gms_mat_demand_plan_flat where  plan_flat_type='1' and wz_type='1' group by wz_id ) flat   on t.wz_id=flat.wz_id where t.bsflag = '0' and t.wz_type = '1' and t.org_id = 'C6000000000039' and t.wz_type = '1' and t.bsflag = '0'  or t.org_id = 'C6000000000040' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005269' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005275' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005279' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005280' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005278' and t.bsflag = '0' and t.wz_type = '1' group by t.wz_id, t.org_id,comm.org_abbreviation,flat.plan_num) tt inner join(gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0') on tt.wz_id = i.wz_id and tt.stock_num>0";
			if (tamplateName != null && !tamplateName.equals("")) {
				sql += " and i.wz_name like '%" + tamplateName + "%'";
			}
			if (wzId != null && !wzId.equals("")) {
				sql += " and i.wz_id like'%" + wzId + "%'";
			}
			if (codingCodeId != null && !codingCodeId.equals("")) {
				sql += " and i.coding_code_id like'%" + codingCodeId + "%'";
			}
			sql += "  order by i.coding_code_id asc, i.wz_id asc";
		} else {
			// var
			// sql="select i.*,c.code_name,t.stock_num,t.recyclemat_info from gms_mat_recyclemat_info t inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id and t.bsflag='0'and t.wz_type='"+type+"' and t.org_id='"+orgId+"'";
			sql = "select i.*, c.code_name, tt.stock_num, tt.actual_price  from (select t.wz_id, case when  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end is null then 0 else  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end end stock_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then 1 else sum(t.stock_num) end, 3) actual_price from gms_mat_recyclemat_info  t  left join  (select sum(plan_num) plan_num,wz_id  from gms_mat_demand_plan_flat where  plan_flat_type='1' and wz_type='1' group by wz_id ) flat   on t.wz_id=flat.wz_id where t.bsflag = '0' and t.wz_type = '1' and t.org_id = '"
					+ orgId
					+ "'  group by t.wz_id,flat.plan_num) tt inner join(gms_mat_infomation i  inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0') on tt.wz_id = i.wz_id and tt.stock_num>0 ";
			if (tamplateName != null && !tamplateName.equals("")) {
				sql += " and i.wz_name like '%" + tamplateName + "%'";
			}
			if (wzId != null && !wzId.equals("")) {
				sql += " and i.wz_id like'%" + wzId + "%'";
			}
			if (codingCodeId != null && !codingCodeId.equals("")) {
				sql += " and i.coding_code_id like'%" + codingCodeId + "%'";
			}
			sql += "order by i.coding_code_id asc, i.wz_id asc";
		}
		page = jdbcDao.queryRecordsBySQL(sql, page);
		list = page.getData();
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			int j = 0;
			for (j = 0; j < ids.length; j++) {

				if (map.get("wz_id").toString().equals(ids[j])) {
					map.put("disabled", "disabled");
					break;
				}
			}
			if (j == ids.length) {
				map.put("disabled", "");
			}
		}
		reqMsg.setValue("datas", page.getData());
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资编制计划 -单项目 选择可重复物资页面初始化（综合物化探） ------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepTemLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(50);

		String id = reqDTO.getValue("ids");
		String value = reqDTO.getValue("value");
		String[] ids = id.split(",");
		System.out.println("codeIds:" + id);
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		String sqlQueryOrgSubjectionId = "select org_subjection_id from bgp_comm_org_wtc w where (select org_subjection_id from gp_task_project_dynamic where project_info_no = '"
				+ user.getProjectInfoNo()
				+ "') like w.org_subjection_id || '%'";
		Map mapQuerySubjectionId = BeanFactory.getQueryJdbcDAO()
				.queryRecordBySQL(sqlQueryOrgSubjectionId);
		String orgSubjectionId = (String) mapQuerySubjectionId
				.get("orgSubjectionId");
		if (value == null || value.equals("undefined")) {
			sql += "select i.*, c.code_name, t.stock_num, t.recyclemat_info, t.actual_price from gms_mat_recyclemat_info t inner join(gms_mat_infomation i";
			sql += " inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0')";
			sql += " on t.wz_id = i.wz_id and t.bsflag = '0' and t.wz_type = '2' and t.stock_num>0 and t.org_subjection_id like '"
					+ orgSubjectionId + "%'";
			sql += " order by i.coding_code_id asc, i.wz_id asc";
		} else {

			sql += "select i.*, c.code_name, t.stock_num, t.recyclemat_info, t.actual_price from gms_mat_recyclemat_info t inner join(gms_mat_infomation i";
			sql += " inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0' and t.wz_name like '%"
					+ value + "%')";
			sql += " on t.wz_id = i.wz_id and t.bsflag = '0' and t.wz_type = '2' and t.stock_num>0 and t.org_subjection_id like '"
					+ orgSubjectionId + "%'";
			sql += " order by i.coding_code_id asc, i.wz_id asc";
		}
		page = jdbcDao.queryRecordsBySQL(sql, page);
		list = page.getData();
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			int j = 0;
			for (j = 0; j < ids.length; j++) {

				if (map.get("wz_id").toString().equals(ids[j])) {
					map.put("disabled", "disabled");
					break;
				}
			}
			if (j == ids.length) {
				map.put("disabled", "");
			}
		}
		reqMsg.setValue("datas", page.getData());
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资编制计划 -单项目 选择可重复物资页面初始化（综合物化探物资小站） ------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepTemLeafWZXZ(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(50);

		String id = reqDTO.getValue("ids");
		String value = reqDTO.getValue("value");
		String[] ids = id.split(",");
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String wz_name = reqDTO.getValue("tamplate_name");
		String wz_id = reqDTO.getValue("wz_id");
		String coding_code_id = reqDTO.getValue("coding_code_id");
		if (value == null || value.equals("undefined")) {
			sql += "select i.*, c.code_name, t.stock_num, t.recyclemat_info, t.actual_price from gms_mat_recyclemat_info t inner join(gms_mat_infomation i";
			sql += " inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0')";
			sql += " on t.wz_id = i.wz_id and t.bsflag = '0' and t.wz_type = '2' and t.stock_num>0 and t.org_subjection_id like '"
					+ orgSubjectionId + "%'";
			if (wz_name != null && !wz_name.equals("")) {
				sql += " and i.wz_name like '%" + wz_name + "%'";
			}
			if (wz_id != null && !wz_id.equals("")) {
				sql += " and i.wz_id like '%" + wz_id + "%'";
			}
			if (coding_code_id != null && !coding_code_id.equals("")) {
				sql += " and i.coding_code_id like '%" + coding_code_id + "%'";
			}
			sql += " order by i.coding_code_id asc, i.wz_id asc";
		} else {

			sql += "select i.*, c.code_name, t.stock_num, t.recyclemat_info, t.actual_price from gms_mat_recyclemat_info t inner join(gms_mat_infomation i";
			sql += " inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0' and t.wz_name like '%"
					+ value + "%')";
			sql += " on t.wz_id = i.wz_id and t.bsflag = '0' and t.wz_type = '2' and t.stock_num>0 and t.org_subjection_id like '"
					+ orgSubjectionId + "%'";
			if (wz_name != null && !wz_name.equals("")) {
				sql += " and i.wz_name like '%" + wz_name + "%'";
			}
			if (wz_id != null && !wz_id.equals("")) {
				sql += " and i.wz_id like '%" + wz_id + "%'";
			}
			if (coding_code_id != null && !coding_code_id.equals("")) {
				sql += " and i.coding_code_id like '%" + coding_code_id + "%'";
			}
			sql += " order by i.coding_code_id asc, i.wz_id asc";
		}
		page = jdbcDao.queryRecordsBySQL(sql, page);
		list = page.getData();
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			int j = 0;
			for (j = 0; j < ids.length; j = j + 2) {

				if (map.get("wz_id").toString().equals(ids[j])
						&& orgSubjectionId.equals(ids[j + 1])) {
					map.put("disabled", "disabled");
					// break;
				}
			}
			if (j * 2 == ids.length) {
				map.put("disabled", "");
			}
		}
		reqMsg.setValue("datas", page.getData());
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 模板定制新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTemMat(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(500);

		String id = reqDTO.getValue("ids");
		String[] ids = id.split(",");
		System.out.println("codeIds:" + id);
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		sql += "select i.*,t.unit_num,t.tamplate_detail_id from gms_mat_demand_tamplate_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.tamplate_id='"
				+ id + "' and t.bsflag='0'";
		page = jdbcDao.queryRecordsBySQL(sql, page);
		list = page.getData();
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			int j = 0;
			for (j = 0; j < ids.length; j++) {

				if (map.get("wz_id").toString().equals(ids[j])) {
					map.put("disabled", "disabled");
					break;
				}
			}
			if (j == ids.length) {
				map.put("disabled", "");
			}
		}
		reqMsg.setValue("datas", page.getData());
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * excel模板导入新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getExclData(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(500);

		String id = reqDTO.getValue("obj");
		System.out.println(id);
		String[] ids = id.split(",");
		System.out.println(ids);
		List<Map> list = new ArrayList<Map>();
		for (int i = 0; i < ids.length; i++) {
			String[] data = ids[i].split("@");
			String sql = "select t.* from gms_mat_infomation t where t.bsflag='0'and wz_id='"
					+ data[0] + "'";
			Map map = pureDao.queryRecordBySQL(sql);
			map.put("mat_num", data[1]);
			list.add(map);
		}
		System.out.println(list);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * excel模板导入新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanExclData(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");
		String errorMessage = "";
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(500);

		String id = reqDTO.getValue("obj");
		System.out.println(id);
		String[] ids = id.split(",");
		System.out.println(ids);
		List<Map> list = new ArrayList<Map>();
		for (int i = 0; i < ids.length; i++) {
			String[] data = ids[i].split("@");
			String sql = "select t.* from gms_mat_infomation t where t.bsflag='0'and wz_id='"
					+ data[0] + "'";
			Map map = pureDao.queryRecordBySQL(sql);
			if (map == null) {
				int n = 1;
				n += i + 1;
				errorMessage += "第" + n + "行物资库中不存在此项物资！";
				reqMsg.setValue("errorMessage", errorMessage);
			} else {
				String actual_price = "";
				if (data[3].equals(" ")) {
					actual_price = map.get("wz_price") == null ? "" : map.get(
							"wz_price").toString();
				} else {
					actual_price = data[3];
				}
				map.put("unit_num", data[1]);
				map.put("demand_date", data[2]);
				map.put("actual_price", actual_price);
				if (data.length > 4) {
					map.put("note", data[4]);
				} else {
					map.put("note", "");
				}
				list.add(map);
			}
		}
		System.out.println(list);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);
		return reqMsg;
	}

	/**
	 * excel模板导入新增页面初始化--大港多项目专业化中心计划
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanExclDataDg(ISrvMsg reqDTO) throws Exception {
		String errorMessage = "";
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(1000);

		String id = reqDTO.getValue("obj");
		System.out.println(id);
		String[] ids = id.split(",");
		System.out.println(ids);
		List<Map> list = new ArrayList<Map>();
		for (int i = 0; i < ids.length; i++) {
			String[] data = ids[i].split("@");
			String sql = "select t.* from gms_mat_infomation t where t.bsflag='0'and wz_id='"
					+ data[0] + "'";
			Map map = pureDao.queryRecordBySQL(sql);
			if (map == null) {
				int n = 1;
				n += i + 1;
				errorMessage += "第" + n + "行物资库中不存在此项物资！";
				reqMsg.setValue("errorMessage", errorMessage);
			} else {
				String actual_price = "";
				if (data[1].equals(" ")) {
					actual_price = map.get("wz_price") == null ? "" : map.get(
							"wz_price").toString();
				} else {
					actual_price = data[1];
				}
				map.put("unit_num", data[2]);
				map.put("actual_price", actual_price);
				if (data.length > 3) {
					map.put("note", data[3]);
				} else {
					map.put("note", "");
				}
				list.add(map);
			}
		}
		System.out.println(list);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);
		return reqMsg;
	}

	/**
	 * 模板定制新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMatLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(500);
		pageSize = "500";
		String id = reqDTO.getValue("ids");
		String tamplateName = reqDTO.getValue("tamplate_name");
		tamplateName = java.net.URLDecoder.decode(tamplateName, "UTF-8");
		String wzId = reqDTO.getValue("wz_id");
		String codingCodeId = reqDTO.getValue("coding_code_id");
		String[] ids = id.split(",");
		System.out.println("tamplateName:" + tamplateName);
		System.out.println("wzId:" + wzId);
		System.out.println("codingCodeId:" + codingCodeId);
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		if (!tamplateName.equals("") && !wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"
					+ tamplateName
					+ "%'and t.wz_id like'%"
					+ wzId
					+ "%'and t.coding_code_id like'%" + codingCodeId + "%'";
		} else if (!tamplateName.equals("") && wzId.equals("")
				&& codingCodeId.equals("")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"
					+ tamplateName + "%'";
		} else if (tamplateName.equals("") && !wzId.equals("")
				&& codingCodeId.equals("")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_id like '%"
					+ wzId + "%'";
		} else if (tamplateName.equals("") && wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.coding_code_id like '"
					+ codingCodeId + "%'";
		} else if (!tamplateName.equals("") && !wzId.equals("")
				&& codingCodeId.equals("")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"
					+ tamplateName + "%'and t.wz_id like'%" + wzId + "%'";
		} else if (!tamplateName.equals("") && wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"
					+ tamplateName
					+ "%'and t.coding_code_id like'%"
					+ codingCodeId + "%'";
		} else if (tamplateName.equals("") && !wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_id like'%"
					+ wzId
					+ "%'and t.coding_code_id like'%"
					+ codingCodeId
					+ "%'";
		}
		page = jdbcDao.queryRecordsBySQL(sql, page);
		list = page.getData();
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			int j = 0;
			for (j = 0; j < ids.length; j++) {

				if (map.get("wz_id").toString().equals(ids[j])) {
					map.put("disabled", "disabled");
					break;
				}
			}
			if (j == ids.length) {
				map.put("disabled", "");
			}
		}
		reqMsg.setValue("datas", page.getData());
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", page.getPageSize());
		reqMsg.setValue("currentPage", currentPage);
		return reqMsg;

	}

	/**
	 * 单机计划编制查询模板物资
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryTemMatLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(500);
		pageSize = "500";
		String id = reqDTO.getValue("ids");
		String tamplateName = reqDTO.getValue("tamplate_name");
		String tamplateId = reqDTO.getValue("tamplateId");
		String wzId = reqDTO.getValue("wz_id");
		String codingCodeId = reqDTO.getValue("coding_code_id");
		String[] ids = id.split(",");
		System.out.println("tamplateName:" + tamplateName);
		System.out.println("wzId:" + wzId);
		System.out.println("codingCodeId:" + codingCodeId);
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		if (!tamplateName.equals("") && !wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select i.*,d.unit_num,d.tamplate_detail_id from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.tamplate_id='"
					+ tamplateId
					+ "' and i.wz_id like '%"
					+ wzId
					+ "%' and i.wz_name like'%"
					+ tamplateName
					+ "%' and i.coding_code_id like'%" + codingCodeId + "%'";
		} else if (!tamplateName.equals("") && wzId.equals("")
				&& codingCodeId.equals("")) {
			sql += "select i.*,d.unit_num,d.tamplate_detail_id from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.tamplate_id='"
					+ tamplateId
					+ "' and i.wz_name like '%"
					+ tamplateName
					+ "%'";
		} else if (tamplateName.equals("") && !wzId.equals("")
				&& codingCodeId.equals("")) {
			sql += "select i.*,d.unit_num,d.tamplate_detail_id from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.tamplate_id='"
					+ tamplateId + "' and i.wz_id like '%" + wzId + "%'";
		} else if (tamplateName.equals("") && wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select i.*,d.unit_num,d.tamplate_detail_id from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.tamplate_id='"
					+ tamplateId
					+ "' and i.coding_code_id like '"
					+ codingCodeId + "%'";
		} else if (!tamplateName.equals("") && !wzId.equals("")
				&& codingCodeId.equals("")) {
			sql += "select i.*,d.unit_num,d.tamplate_detail_id from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.tamplate_id='"
					+ tamplateId
					+ "' and i.wz_name like '%"
					+ tamplateName
					+ "%'and i.wz_id like'%" + wzId + "%'";
		} else if (!tamplateName.equals("") && wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select i.*,d.unit_num,d.tamplate_detail_id from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.tamplate_id='"
					+ tamplateId
					+ "' and i.wz_name like '%"
					+ tamplateName
					+ "%'and i.coding_code_id like'%" + codingCodeId + "%'";
		} else if (tamplateName.equals("") && !wzId.equals("")
				&& !codingCodeId.equals("")) {
			sql += "select i.*,d.unit_num,d.tamplate_detail_id from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.tamplate_id='"
					+ tamplateId
					+ "' and i.wz_name like'%"
					+ wzId
					+ "%'and i.coding_code_id like'%" + codingCodeId + "%'";
		}
		page = jdbcDao.queryRecordsBySQL(sql, page);
		list = page.getData();
		for (int i = 0; i < list.size(); i++) {
			Map map = list.get(i);
			int j = 0;
			for (j = 0; j < ids.length; j++) {

				if (map.get("wz_id").toString().equals(ids[j])) {
					map.put("disabled", "disabled");
					break;
				}
			}
			if (j == ids.length) {
				map.put("disabled", "");
			}
		}
		reqMsg.setValue("datas", page.getData());
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", page.getPageSize());
		reqMsg.setValue("currentPage", currentPage);
		return reqMsg;

	}

	/**
	 * 新增模板
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatTem(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String id = reqMap.get("laborId").toString();
		String[] ids = id.split(",");
		Map map = new HashMap();
		if (reqMap.get("tamplate_id") == null) {
			map.put("tamplate_name", reqMap.get("tamplate_name"));
			map.put("coding_code_id", reqMap.get("s_apply_team"));
			map.put("device_id", reqMap.get("device_id"));
			map.put("tamplate_type", reqMap.get("tamplate_type"));
			map.put("loacked_if", reqMap.get("loacked_if"));
			map.put("org_id", user.getOrgId());
			map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("bsflag", "0");
		} else {
			map.put("tamplate_id", reqMap.get("tamplate_id"));
			map.put("tamplate_name", reqMap.get("tamplate_name"));
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
		}
		Serializable tamplateId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_demand_tamplate");
		System.out.println(ids.length);
		for (int i = 0; i < ids.length; i++) {
			String unitNum = "unit_num" + ids[i];
			String sql = "";
			if (reqMap.get("tamplate_id") == null) {
				sql += "select t.* from gms_mat_demand_tamplate_detail t where t.tamplate_id='"
						+ tamplateId.toString()
						+ "' and t.wz_id='"
						+ ids[i]
						+ "'and t.bsflag='0'";
			} else {
				sql += "select t.* from gms_mat_demand_tamplate_detail t where t.tamplate_id='"
						+ reqMap.get("tamplate_id")
						+ "' and t.wz_id='"
						+ ids[i] + "'and t.bsflag='0'";

			}
			Map getmap = pureDao.queryRecordBySQL(sql);
			if (getmap == null) {
				Map tmap = new HashMap();
				tmap.put("wz_id", ids[i]);
				tmap.put("unit_num", reqMap.get(unitNum));
				tmap.put("tamplate_id", tamplateId.toString());
				tmap.put("bsflag", "0");
				pureDao.saveOrUpdateEntity(tmap,
						"gms_mat_demand_tamplate_detail");
			} else {
				Map tmap = new HashMap();
				tmap.put("unit_num", reqMap.get(unitNum));
				tmap.put("tamplate_detail_id", getmap.get("tamplate_detail_id"));
				pureDao.saveOrUpdateEntity(tmap,
						"gms_mat_demand_tamplate_detail");

			}
		}
		return reqMsg;
	}

	/**
	 * 模板详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTemList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.wz_id,t.wz_name,t.wz_prickie,t.wz_price,t.coding_code_id,d.unit_num from gms_mat_infomation t inner join gms_mat_demand_tamplate_detail d on t.wz_id = d.wz_id where d.tamplate_id = '"
				+ id
				+ "'and d.bsflag='0' order by t.coding_code_id asc,t.wz_id asc";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 删除模板信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteMatTem(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_demand_tamplate t set t.bsflag = '1' where t.tamplate_id = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 获取单机主键信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getdevAccId(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String teammat_out_id = reqDTO.getValue("teammat_out_id");

		String sql = "select t.dev_acc_id from gms_mat_teammat_out t where t.teammat_out_id='"
				+ teammat_out_id + "'and t.bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 删除模板详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTemList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String sql = "update gms_mat_demand_tamplate_detail t set t.bsflag = '1' where t.wz_id = '"
				+ id + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 获取模板信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatTem(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.*,(d.dev_ci_name||d.dev_ci_model) device_name  from GMS_MAT_DEMAND_TAMPLATE t left join gms_device_codeinfo d on t.device_id=d.dev_ci_code where t.tamplate_id = '"
				+ id + "'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 修改模板信息新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String tamplateId = reqDTO.getValue("tamplateId");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			Map tmap = new HashMap();
			tmap.put("wz_id", ids[i]);
			tmap.put("tamplate_id", tamplateId);
			tmap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(tmap, "gms_mat_demand_tamplate_detail");
		}
		return reqMsg;
	}

	/**
	 * 获取模板信息导出excel
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatTemList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		ExcelEIResolvingUtil util = new ExcelEIResolvingUtil();
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("tamplateId");
		String sql = "select i.wz_id,i.coding_code_id,i.wz_name,i.wz_prickie,i.wz_price,d.unit_num,i.note from GMS_MAT_DEMAND_TAMPLATE_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where d.tamplate_id='"
				+ id
				+ "'and d.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";

		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		return reqMsg;
	}

	/**
	 * 获取计划信息导出excel
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatPlanList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		ExcelEIResolvingUtil util = new ExcelEIResolvingUtil();
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("submiteNumber");
		String sql = "select t.demand_num,t.demand_date,i.wz_name,i.wz_prickie,i.wz_price,i.wz_id,i.coding_code_id from gms_mat_demand_plan_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.submite_number='"
				+ id + "'and t.bsflag='0'";

		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		return reqMsg;
	}

	/**
	 * 获取入库信息导出excel
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAcceptList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		ExcelEIResolvingUtil util = new ExcelEIResolvingUtil();
		UserToken user = reqDTO.getUserToken();
		// 获得查询主键
		String id = reqDTO.getValue("id");
		String[] ids = id.split(",");
		List list = new ArrayList();
		// 查询出库信息
		for (int i = 0; i < ids.length; i++) {
			String sql = "select p.project_name,org.org_abbreviation,t.invoices_no,t.input_date,"
					+ "t.total_money as allmoney,t.operator,t.pickupgoods,t.storage,d.wz_id,i.wz_name,i.wz_prickie,i.wz_price,"
					+ "d.mat_num,d.total_money from gms_mat_teammat_invoices t left join gms_mat_teammat_info_detail d "
					+ "on t.invoices_id=d.invoices_id left join gms_mat_infomation i on d.wz_id=i.wz_id left join gp_task_project p "
					+ "on t.project_info_no = p.project_info_no left join comm_org_information org on t.org_id=org.org_id where t.bsflag='0' "
					+ "and t.invoices_id='" + ids[i] + "'";

			List getList = pureDao.queryRecords(sql);
			for (int j = 0; j < getList.size(); j++) {
				list.add(getList.get(j));
			}
		}
		// 返还查询数据
		reqMsg.setValue("datas", list);
		return reqMsg;
	}

	/**
	 * 获取出库信息导出excel
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getGrantPlanList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		ExcelEIResolvingUtil util = new ExcelEIResolvingUtil();
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("id");
		String[] ids = id.split(",");
		List list = new ArrayList();
		for (int i = 0; i < ids.length; i++) {
			String sql = "select t.outmat_date,org.org_name,org.org_abbreviation,t.total_money allMoney,t.procure_no,t.numbers,t.drawer,t.storage,t.pickupgoods,p.project_name,d.*,i.wz_id,i.wz_name,i.wz_prickie,nvl(c.coding_name,(dev.dev_ci_name||dev.dev_ci_model)) as tname from GMS_MAT_TEAMMAT_OUT t inner join (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0'inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'left join gms_device_codeinfo dev on t.device_id = dev.dev_ci_code left join comm_coding_sort_detail c on t.team_id = c.coding_code_id and c.bsflag='0' left join comm_org_information org on t.org_id=org.org_id where t.teammat_out_id='"
					+ ids[i] + "'and t.bsflag='0'";

			List getList = pureDao.queryRecords(sql);
			for (int j = 0; j < getList.size(); j++) {
				list.add(getList.get(j));
			}
		}
		reqMsg.setValue("datas", list);
		return reqMsg;
	}

	/**
	 * 获取审批计划信息导出excel
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAppPlanList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		ExcelEIResolvingUtil util = new ExcelEIResolvingUtil();
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("planId");
		String sql = "select p.compile_date,t.demand_num,t.have_num,t.regulate_num,t.apply_num,t.plan_money,m.coding_code_id,m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,c.code_desc,c.code_name from gms_mat_demand_plan_invoice p inner join (GMS_MAT_DEMAND_PLAN t inner join gms_mat_infomation m on t.wz_id = m.wz_id and t.bsflag='0'and m.bsflag='0'inner join gms_mat_coding_code c on m.coding_code_id=c.coding_code_id and c.bsflag='0') on p.plan_invoice_id=t.plan_invoice_id and p.bsflag='0' where t.plan_invoice_id ='"
				+ id + "' order by m.coding_code_id asc,m.wz_id asc";

		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		return reqMsg;
	}

	/**
	 * 班组退货信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveTeamOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		// 保存退库单据
		Map outMap = new HashMap();
		outMap.put("invoices_id", reqMap.get("invoices_id"));
		outMap.put("out_date", reqMap.get("out_date"));
		outMap.put("procure_no", reqMap.get("procure_no"));
		outMap.put("operator", reqMap.get("operator"));
		outMap.put("note", reqMap.get("note"));
		outMap.put("total_money", reqMap.get("total_money"));
		outMap.put("team_id", reqMap.get("s_apply_team"));

		outMap.put("bsflag", "0");
		outMap.put("if_submit", "1");
		outMap.put("out_type", "3");
		outMap.put("creator_id", user.getUserId());
		outMap.put("create_date", new Date());
		outMap.put("org_id", user.getOrgId());
		outMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		outMap.put("project_info_no", projectInfoId);
		Serializable outInfoId = pureDao.saveOrUpdateEntity(outMap,
				"gms_mat_out_info");
		// 保存退库物资明细
		for (int i = 0; i < ids.length; i++) {
			String matNum = "mat_num_" + ids[i];
			String wzPrice = "wz_price_" + ids[i];
			String totalMoney = "total_money_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			Map detailMap = new HashMap();
			detailMap.put("out_info_id", outInfoId.toString());
			detailMap.put("wz_id", ids[i]);
			detailMap.put("out_price", reqMap.get(wzPrice));
			detailMap.put("out_num", reqMap.get(matNum));
			detailMap.put("total_money", reqMap.get(totalMoney));
			detailMap.put("goods_allocation", reqMap.get(goodsAllocation));
			detailMap.put("bsflag", "0");
			detailMap.put("project_info_no", projectInfoId);
			pureDao.saveOrUpdateEntity(detailMap, "gms_mat_out_info_detail");
			// 查询出库数量
			String outsql = "select d.out_detail_id,d.mat_num as out_num from gms_mat_teammat_out_detail d left join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
					+ ids[i]
					+ "' and d.project_info_no='"
					+ projectInfoId
					+ "' and t.bsflag='0' and rownum=1 order by d.mat_num desc  ";
			Map queryMap = pureDao.queryRecordBySQL(outsql);
			double outNum = Double.valueOf(queryMap.get("out_num").toString());
			outNum -= Double.valueOf(reqMap.get(matNum).toString());
			String updateSql = "update gms_mat_teammat_out_detail d set d.mat_num = '"
					+ outNum
					+ "' where d.out_detail_id='"
					+ queryMap.get("out_detail_id") + "'";
			jdbcDao.executeUpdate(updateSql);
		}
		/*
		 * //生成入库单据 Map tiMap = new HashMap(); tiMap.put("procure_no",
		 * outInfoId.toString()); tiMap.put("invoices_type", "5");
		 * tiMap.put("if_input", "1"); tiMap.put("bsflag", "0");
		 * tiMap.put("project_info_no", projectInfoId); tiMap.put("creator_id",
		 * user.getUserId()); tiMap.put("create_date", new Date());
		 * tiMap.put("org_id", user.getOrgId()); tiMap.put("ORG_SUBJECTION_ID",
		 * user.getOrgSubjectionId()); Serializable
		 * invoicesId=pureDao.saveOrUpdateEntity(tiMap,
		 * "gms_mat_teammat_invoices");
		 * 
		 * //生成入库明细 for(int i=0;i<ids.length;i++){ String matNum =
		 * "mat_num_"+ids[i]; String wzPrice = "wz_price_"+ids[i]; String
		 * totalMoney = "total_money_"+ids[i]; String goodsAllocation =
		 * "goods_allocation_"+ids[i]; Map detailMap = new HashMap();
		 * detailMap.put("invoices_id", invoicesId.toString());
		 * detailMap.put("wz_id", ids[i]); detailMap.put("actual_price",
		 * reqMap.get(wzPrice)); detailMap.put("mat_num", reqMap.get(matNum));
		 * detailMap.put("total_money", reqMap.get(totalMoney));
		 * detailMap.put("goods_allocation", reqMap.get(goodsAllocation));
		 * detailMap.put("bsflag", "0"); detailMap.put("if_accept", "1");
		 * detailMap.put("project_info_no", projectInfoId);
		 * detailMap.put("creator_id", user.getUserId());
		 * detailMap.put("create_date", new Date()); detailMap.put("org_id",
		 * user.getOrgId()); detailMap.put("ORG_SUBJECTION_ID",
		 * user.getOrgSubjectionId()); pureDao.saveOrUpdateEntity(detailMap,
		 * "gms_mat_teammat_info_detail"); }
		 */

		return reqMsg;
	}

	/**
	 * 单机退货信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDevOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		// 保存退库单据
		Map outMap = new HashMap();
		outMap.put("invoices_id", reqMap.get("invoices_id"));
		outMap.put("out_date", reqMap.get("out_date"));
		outMap.put("procure_no", reqMap.get("procure_no"));
		outMap.put("operator", reqMap.get("operator"));
		outMap.put("note", reqMap.get("note"));
		outMap.put("total_money", reqMap.get("total_money"));
		outMap.put("dev_acc_id", reqMap.get("dev_acc_id"));

		outMap.put("bsflag", "0");
		outMap.put("if_submit", "1");
		outMap.put("out_type", "5");
		outMap.put("creator_id", user.getUserId());
		outMap.put("create_date", new Date());
		outMap.put("org_id", user.getOrgId());
		outMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		outMap.put("project_info_no", projectInfoId);
		Serializable outInfoId = pureDao.saveOrUpdateEntity(outMap,
				"gms_mat_out_info");
		// 保存退库物资明细
		for (int i = 0; i < ids.length; i++) {
			String matNum = "mat_num_" + ids[i];
			String wzPrice = "wz_price_" + ids[i];
			String totalMoney = "total_money_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			Map detailMap = new HashMap();
			detailMap.put("out_info_id", outInfoId.toString());
			detailMap.put("wz_id", ids[i]);
			detailMap.put("out_price", reqMap.get(wzPrice));
			detailMap.put("out_num", reqMap.get(matNum));
			detailMap.put("total_money", reqMap.get(totalMoney));
			detailMap.put("goods_allocation", reqMap.get(goodsAllocation));
			detailMap.put("bsflag", "0");
			detailMap.put("project_info_no", projectInfoId);
			pureDao.saveOrUpdateEntity(detailMap, "gms_mat_out_info_detail");
			// 查询出库数量
			String org_subjection_id = user.getOrgSubjectionId();
			String org_id = user.getOrgId();
			String outsql = "select d.out_detail_id,d.mat_num as out_num from gms_mat_teammat_out_detail d inner join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
					+ ids[i]
					+ "' and d.project_info_no='"
					+ projectInfoId
					+ "' and t.bsflag='0'and t.dev_acc_id='"
					+ reqMap.get("dev_acc_id") + "' ";
			if (org_subjection_id.startsWith("C105007")) {
				if (org_id != null
						&& (org_id.equals("C6000000000039")
								|| org_id.equals("C6000000000040")
								|| org_id.equals("C6000000005275")
								|| org_id.equals("C6000000005277")
								|| org_id.equals("C6000000005278")
								|| org_id.equals("C6000000005279") || org_id
									.equals("C6000000005280"))) {
					outsql += "  and t.wz_type='11' and t.org_id = '" + org_id
							+ "'";
				} else {
					outsql += "  and t.wz_type = '22'";
				}
			}
			outsql += " and rownum=1 order by d.mat_num desc  ";
			Map queryMap = pureDao.queryRecordBySQL(outsql);
			double outNum = Double.valueOf(queryMap.get("out_num").toString());
			outNum -= Double.valueOf(reqMap.get(matNum).toString());
			String updateSql = "update gms_mat_teammat_out_detail d set d.mat_num = '"
					+ outNum
					+ "' where d.out_detail_id='"
					+ queryMap.get("out_detail_id") + "'";
			jdbcDao.executeUpdate(updateSql);
		}
		/*
		 * //生成入库单据 Map tiMap = new HashMap(); tiMap.put("procure_no",
		 * outInfoId.toString()); tiMap.put("invoices_type", "5");
		 * tiMap.put("if_input", "1"); tiMap.put("bsflag", "0");
		 * tiMap.put("project_info_no", projectInfoId); tiMap.put("creator_id",
		 * user.getUserId()); tiMap.put("create_date", new Date());
		 * tiMap.put("org_id", user.getOrgId()); tiMap.put("ORG_SUBJECTION_ID",
		 * user.getOrgSubjectionId()); Serializable
		 * invoicesId=pureDao.saveOrUpdateEntity(tiMap,
		 * "gms_mat_teammat_invoices");
		 * 
		 * //生成入库明细 for(int i=0;i<ids.length;i++){ String matNum =
		 * "mat_num_"+ids[i]; String wzPrice = "wz_price_"+ids[i]; String
		 * totalMoney = "total_money_"+ids[i]; String goodsAllocation =
		 * "goods_allocation_"+ids[i]; Map detailMap = new HashMap();
		 * detailMap.put("invoices_id", invoicesId.toString());
		 * detailMap.put("wz_id", ids[i]); detailMap.put("actual_price",
		 * reqMap.get(wzPrice)); detailMap.put("mat_num", reqMap.get(matNum));
		 * detailMap.put("total_money", reqMap.get(totalMoney));
		 * detailMap.put("goods_allocation", reqMap.get(goodsAllocation));
		 * detailMap.put("bsflag", "0"); detailMap.put("if_accept", "1");
		 * detailMap.put("project_info_no", projectInfoId);
		 * detailMap.put("creator_id", user.getUserId());
		 * detailMap.put("create_date", new Date()); detailMap.put("org_id",
		 * user.getOrgId()); detailMap.put("ORG_SUBJECTION_ID",
		 * user.getOrgSubjectionId()); pureDao.saveOrUpdateEntity(detailMap,
		 * "gms_mat_teammat_info_detail"); }
		 */

		return reqMsg;
	}

	/**
	 * 班组退货信息修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateTeamOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		String org_subjection_id = user.getOrgSubjectionId();
		String org_id = user.getOrgId();
		// 查询原始退库数据
		String querySql = "select d.* from gms_mat_out_info t left join gms_mat_out_info_detail d on t.out_info_id=d.out_info_id where t.out_info_id='"
				+ reqMap.get("out_info_id") + "'";
		List queryList = pureDao.queryRecords(querySql);
		// 还原出库数量
		for (int i = 0; i < queryList.size(); i++) {
			Map queryMap = (Map) queryList.get(i);
			// 查询出库数量
			String outsql = "";
			if (reqMap.get("dev_acc_id") != null) {

				outsql += "select d.out_detail_id,d.mat_num  from gms_mat_teammat_out_detail d inner join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
						+ queryMap.get("wz_id")
						+ "' and d.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' and t.bsflag='0'and t.dev_acc_id='"
						+ reqMap.get("dev_acc_id") + "'";
				if (org_subjection_id.startsWith("C105007")) {
					if (org_id != null
							&& (org_id.equals("C6000000000039")
									|| org_id.equals("C6000000000040")
									|| org_id.equals("C6000000005275")
									|| org_id.equals("C6000000005277")
									|| org_id.equals("C6000000005278")
									|| org_id.equals("C6000000005279") || org_id
										.equals("C6000000005280"))) {
						outsql += "  and t.wz_type='11' and t.org_id = '"
								+ org_id + "'";
					} else {
						outsql += "  and t.wz_type = '22'";
					}
				}
				outsql += " and rownum=1 order by d.mat_num desc ";
			} else {
				outsql += "select d.out_detail_id,d.mat_num  from gms_mat_teammat_out_detail d left join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
						+ queryMap.get("wz_id")
						+ "' and d.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' and t.bsflag='0' and t.team_id='"
						+ reqMap.get("s_apply_team")
						+ "' and rownum=1 order by d.mat_num desc  ";
			}
			Map outMap = pureDao.queryRecordBySQL(outsql);
			double outNum = Double.valueOf(outMap.get("mat_num").toString());
			outNum += Double.valueOf(queryMap.get("out_num").toString());
			String updateSql = "update gms_mat_teammat_out_detail d set d.mat_num = '"
					+ outNum
					+ "' where d.out_detail_id='"
					+ outMap.get("out_detail_id") + "'";
			jdbcDao.executeUpdate(updateSql);
		}
		// 修改退库单据
		Map outMap = new HashMap();
		outMap.put("out_info_id", reqMap.get("out_info_id"));
		outMap.put("invoices_id", reqMap.get("invoices_id"));
		outMap.put("out_date", reqMap.get("out_date"));
		outMap.put("procure_no", reqMap.get("procure_no"));
		outMap.put("operator", reqMap.get("operator"));
		outMap.put("note", reqMap.get("note"));
		outMap.put("total_money", reqMap.get("total_money"));
		outMap.put("team_id", reqMap.get("s_apply_team"));
		outMap.put("dev_acc_id", reqMap.get("dev_acc_id"));

		outMap.put("updator_id", user.getUserId());
		outMap.put("modifi_date", new Date());
		Serializable outInfoId = pureDao.saveOrUpdateEntity(outMap,
				"gms_mat_out_info");
		// 删除原始退库明细
		String deleteSql = " delete from gms_mat_out_info_detail d where d.out_info_id ='"
				+ outInfoId + "'";
		jdbcTemplate.execute(deleteSql);
		// 保存退库物资明细
		for (int i = 0; i < ids.length; i++) {
			String matNum = "mat_num_" + ids[i];
			String wzPrice = "wz_price_" + ids[i];
			String totalMoney = "total_money_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			Map detailMap = new HashMap();
			detailMap.put("out_info_id", outInfoId.toString());
			detailMap.put("wz_id", ids[i]);
			detailMap.put("out_price", reqMap.get(wzPrice));
			detailMap.put("out_num", reqMap.get(matNum));
			detailMap.put("total_money", reqMap.get(totalMoney));
			detailMap.put("goods_allocation", reqMap.get(goodsAllocation));
			detailMap.put("bsflag", "0");
			detailMap.put("project_info_no", projectInfoId);
			pureDao.saveOrUpdateEntity(detailMap, "gms_mat_out_info_detail");
			// 查询出库数量
			String outsql = "";
			if (reqMap.get("dev_acc_id") != null) {
				outsql += "select d.out_detail_id,d.mat_num from gms_mat_teammat_out_detail d inner join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
						+ ids[i]
						+ "' and d.project_info_no='"
						+ projectInfoId
						+ "' and t.bsflag='0' and t.dev_acc_id='"
						+ reqMap.get("dev_acc_id") + "' ";
				if (org_subjection_id.startsWith("C105007")) {
					if (org_id != null
							&& (org_id.equals("C6000000000039")
									|| org_id.equals("C6000000000040")
									|| org_id.equals("C6000000005275")
									|| org_id.equals("C6000000005277")
									|| org_id.equals("C6000000005278")
									|| org_id.equals("C6000000005279") || org_id
										.equals("C6000000005280"))) {
						outsql += "  and t.wz_type='11' and t.org_id = '"
								+ org_id + "'";
					} else {
						outsql += "  and t.wz_type = '22'";
					}
				}
				outsql += " and rownum=1 order by d.mat_num desc  ";
			} else {
				outsql += "select d.out_detail_id,d.mat_num from gms_mat_teammat_out_detail d left join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
						+ ids[i]
						+ "' and d.project_info_no='"
						+ projectInfoId
						+ "' and t.bsflag='0' and t.team_id='"
						+ reqMap.get("s_apply_team")
						+ "' and rownum=1 order by d.mat_num desc  ";
			}
			Map queryMap = pureDao.queryRecordBySQL(outsql);
			double outNum = Double
					.valueOf(queryMap.get("mat_num") == null ? "0" : queryMap
							.get("mat_num").toString());
			outNum -= Double.valueOf(reqMap.get(matNum).toString());
			String updateSql = "update gms_mat_teammat_out_detail d set d.mat_num = '"
					+ outNum
					+ "' where d.out_detail_id='"
					+ queryMap.get("out_detail_id") + "'";
			jdbcDao.executeUpdate(updateSql);
		}
		return reqMsg;
	}

	/**
	 * 班组退货信息提交
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitTeamOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		String id = reqDTO.getValue("matId");
		// 更新退库单状态
		String oiSql = "update gms_mat_out_info t set t.if_submit='1' where t.out_info_id='"
				+ id
				+ "'and t.project_info_no='"
				+ projectInfoId
				+ "'and t.bsflag='0'";
		jdbcDao.executeUpdate(oiSql);
		// 更新入库单据状态
		String sql = "update gms_mat_teammat_invoices t set t.if_input='0' where t.procure_no='"
				+ id
				+ "'and t.project_info_no='"
				+ projectInfoId
				+ "'and t.bsflag='0'";
		jdbcDao.executeUpdate(sql);
		// 更新入库明细状态
		String getSql = "select t.teammat_info_idetail_id from gms_mat_teammat_info_detail t inner join gms_mat_teammat_invoices i on t.invoices_id=i.invoices_id and t.bsflag='0' where i.procure_no='"
				+ id
				+ "'and i.project_info_no='"
				+ projectInfoId
				+ "'and t.bsflag='0'";
		List getlist = pureDao.queryRecords(getSql);
		for (int i = 0; i < getlist.size(); i++) {
			Map map = (Map) getlist.get(i);
			String updateSql = "update gms_mat_teammat_info_detail t set t.if_accept='0' where t.teammat_info_idetail_id='"
					+ map.get("teammat_info_idetail_id").toString() + "'";
			jdbcDao.executeUpdate(sql);
		}
		/*
		 * //查询退库物资 String outSql =
		 * "select t.wz_id,t.out_num from GMS_MAT_OUT_INFO_DETAIL t where t.out_info_id='"
		 * +id+"'"; List list =pureDao.queryRecords(outSql); //更新小队库存 for(int
		 * i=0;i<list.size();i++){ Map map = (Map) list.get(i); String teamSql =
		 * "select * from gms_mat_teammat_info t where t.wz_id = '"+
		 * map.get("wz_id").toString() +
		 * "' and t.project_info_no='"+projectInfoId+"'"; Map smap =
		 * ijdbcDao.queryRecordBySQL(teamSql);
		 * 
		 * Double stockNum = Double.valueOf(smap.get("stockNum").toString());
		 * stockNum += Double.valueOf(map.get("out_num").toString()); String
		 * updateSql = "update gms_mat_teammat_info set stock_num ='" + stockNum
		 * + "' where teammat_info_id = '" +
		 * smap.get("teammatInfoId").toString() + "'";
		 * jdbcDao.executeUpdate(updateSql); }
		 */
		return reqMsg;
	}

	/**
	 * 油料消耗新增单据
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addConsumption(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		//多项目主台帐ID
		String devAccId = reqDTO.getValue("devAccId");
		//单项目目主台帐ID
		String devAccDuiId = reqDTO.getValue("ids");
		String projectInfoId = "";
		String oil_from = "";;
		Map reqMap = reqDTO.toMap();
		String ids = "";
		if(devAccId != null && !("").equals(devAccId)){
			ids = devAccId; 
			oil_from="0";
		}else{
			ids = devAccDuiId;
			projectInfoId = user.getProjectInfoNo();
			oil_from=reqDTO.getValue("oil_from").toString();
		}
		String[] id = ids.split(",");
		String org_subjection_id = user.getOrgSubjectionId();
		String org_id = user.getOrgId();
		// 操作主表录入设备数据
		Map map = new HashMap();
		map.put("PROJECT_INFO_NO", projectInfoId);
		map.put("total_money", reqDTO.getValue("total_money"));
		map.put("oil_from", oil_from);
		map.put("outmat_date", reqDTO.getValue("outmat_date"));
		map.put("out_type", "3");
		map.put("org_id", user.getOrgId());
		map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("CREATE_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		if (org_subjection_id.startsWith("C105007")) {
			if (oil_from.equals("0")) {
				if (org_id != null
						&& (org_id.equals("C6000000000039")
								|| org_id.equals("C6000000000040")
								|| org_id.equals("C6000000005275")
								|| org_id.equals("C6000000005277")
								|| org_id.equals("C6000000005278")
								|| org_id.equals("C6000000005279") || org_id
									.equals("C6000000005280"))) {
					map.put("wz_type", "11");// 油库加油，
				} else {
					map.put("wz_type", "22");// 油库加油，
				}
			}
		} else {
			map.put("wz_type", reqDTO.getValue("wz_type"));// 油库加油，wz_type=0
		}
		Serializable out_id = pureDao.saveOrUpdateEntity(map,
				"GMS_MAT_TEAMMAT_OUT");
		for (int i = 0; i < id.length; i++) {
			String matNum = "mat_num_" + id[i];
			String totalMoney = "total_money_" + id[i];
			String oilNum = "oil_num_" + id[i];
			// 操作从表录入油料
			Map tmap = new HashMap();
			tmap.put("TEAMMAT_OUT_ID", out_id);
			tmap.put("WZ_ID", reqDTO.getValue("wz_id"));
			tmap.put("dev_acc_id", id[i]);
			tmap.put("oil_num", reqMap.get(oilNum));
			tmap.put("mat_num", reqMap.get(matNum));
			tmap.put("actual_price", reqDTO.getValue("actual_price"));
			tmap.put("total_money", reqMap.get(totalMoney));
			tmap.put("BSFLAG", "0");
			tmap.put("org_id", user.getOrgId());
			tmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			tmap.put("CREATOR_ID", user.getUserId());
			tmap.put("CREATE_DATE", new Date());
			tmap.put("UPDATOR_ID", user.getUserId());
			tmap.put("MODIFI_DATE", new Date());
			tmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			Serializable detail_id = pureDao.saveOrUpdateEntity(tmap,
					"GMS_MAT_TEAMMAT_OUT_DETAIL");
			// 操作油料入库
			if (oil_from.equals("1")) {
				Map inmap = new HashMap();
				inmap.put("INVOICES_ID", detail_id);
				inmap.put("WZ_ID", reqDTO.getValue("wz_id"));
				inmap.put("mat_num", reqMap.get(matNum));
				inmap.put("actual_price", reqDTO.getValue("actual_price"));
				inmap.put("total_money", reqMap.get(totalMoney));
				inmap.put("INPUT_TYPE", "2");
				inmap.put("BSFLAG", "0");
				inmap.put("org_id", user.getOrgId());
				inmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
				inmap.put("CREATOR_ID", user.getUserId());
				inmap.put("CREATE_DATE", new Date());
				inmap.put("UPDATOR_ID", user.getUserId());
				inmap.put("MODIFI_DATE", new Date());
				inmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				pureDao.saveOrUpdateEntity(inmap, "GMS_MAT_TEAMMAT_INFO_DETAIL");
			}
		}
		return reqMsg;
	}

	/**
	 * 油料消耗删除单据
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteConsumption(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String ids = reqDTO.getValue("ids");
		String id[] = ids.split(",");
		for (int i = 0; i < id.length; i++) {
			String sql = "update gms_mat_teammat_out set bsflag = '1' where teammat_out_id = '"
					+ id[i] + "'";
			String outSql = "update GMS_MAT_TEAMMAT_OUT_DETAIL set bsflag = '1' where teammat_out_id = '"
					+ id[i] + "'";
			String infoSql = "update GMS_MAT_TEAMMAT_INFO_DETAIL set bsflag = '1' where invoices_id in "
					+ "(select d.out_detail_id from GMS_MAT_TEAMMAT_OUT_DETAIL d where d.teammat_out_id = '"
					+ id[i] + "')";
			// String infoSql =
			// "update GMS_MAT_TEAMMAT_INFO_DETAIL set bsflag = '1' where invoices_id = '"
			// + id[i] + "'";
			jdbcDao.executeUpdate(sql);
			jdbcDao.executeUpdate(outSql);
			jdbcDao.executeUpdate(infoSql);
		}
		return reqMsg;
	}

	/**
	 * 油料消耗主台帐详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findDevConsumptionList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select acc.dev_name,acc.self_num,acc.license_num,i.wz_prickie,d.actual_price,d.mat_num,d.total_money,d.oil_num,acc.dev_sign,oprtbl.operator_name from GMS_MAT_TEAMMAT_OUT t inner join  (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' inner join gms_device_account acc on d.dev_acc_id=acc.dev_acc_id and acc.bsflag='0'  left join (select device_account_id,operator_name from ( select tmp.device_account_id,tmp.operator_name,row_number() over(partition by device_account_id order by length(operator_name) desc ) as seq from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on acc.dev_acc_id = oprtbl.device_account_id) on t.teammat_out_id =d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='"
				+ id
				+ "'and t.bsflag='0'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}
	
	/**
	 * 油料消耗详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findConsumptionList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select dui.dev_name,dui.self_num,dui.license_num,i.wz_prickie,d.actual_price,d.mat_num,d.total_money,d.oil_num,dui.dev_sign,oprtbl.operator_name from GMS_MAT_TEAMMAT_OUT t inner join  (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' inner join gms_device_account_dui dui on d.dev_acc_id=dui.dev_acc_id and dui.bsflag='0'  left join (select device_account_id,operator_name from ( select tmp.device_account_id,tmp.operator_name,row_number() over(partition by device_account_id order by length(operator_name) desc ) as seq from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id) on t.teammat_out_id =d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='"
				+ id
				+ "'and t.bsflag='0'and t.project_info_no='"
				+ user.getProjectInfoNo() + "'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 单机油料消耗详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findDevGrantList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select i.wz_name,i.wz_prickie,i.wz_price,d.actual_price,d.mat_num,d.total_money from GMS_MAT_TEAMMAT_OUT t inner join  (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id =d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='"
				+ id
				+ "'and t.bsflag='0'and t.project_info_no='"
				+ user.getProjectInfoNo() + "'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 油料消耗单据信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryConsumption(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("teammatOutId");
		String sql = "select t.teammat_out_id,t.outmat_date,t.oil_from,d.actual_price,d.wz_id,i.coding_code_id from GMS_MAT_TEAMMAT_OUT t inner join gms_mat_teammat_out_detail d on t.teammat_out_id=d.teammat_out_id and d.bsflag='0'  inner join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag='0' where t.teammat_out_id='"
				+ id
				+ "'and t.bsflag='0' group by t.teammat_out_id,t.outmat_date,t.oil_from,d.actual_price,d.wz_id,i.coding_code_id";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 油料消耗修改单据
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateConsumption(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		String oil_from = reqDTO.getValue("oil_from");
		Map reqMap = reqDTO.toMap();
		String ids = reqDTO.getValue("ids");
		String[] id = ids.split(",");
		Map map = new HashMap();
		map.put("TEAMMAT_OUT_ID", reqMap.get("teammat_out_id"));
		map.put("oil_from", reqMap.get("oil_from"));
		map.put("outmat_date", reqDTO.getValue("outmat_date"));
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("wz_type", reqDTO.getValue("wz_type"));// 油库加油，wz_type=0
		pureDao.saveOrUpdateEntity(map, "GMS_MAT_TEAMMAT_OUT");
		// 出库明细
		for (int i = 0; i < id.length; i++) {
			String oilNum = "oil_num_" + id[i];
			String matNum = "mat_num_" + id[i];
			String totalMoney = "total_money_" + id[i];
			Map tmap = new HashMap();
			tmap.put("out_detail_id", id[i]);
			tmap.put("oil_num", reqMap.get(oilNum));
			tmap.put("mat_num", reqMap.get(matNum));
			tmap.put("wz_id", reqMap.get("wz_id"));
			tmap.put("actual_price", reqMap.get("actual_price"));
			tmap.put("actual_price", reqMap.get("actual_price"));
			tmap.put("total_money", reqMap.get(totalMoney));
			tmap.put("UPDATOR_ID", user.getUserId());
			tmap.put("MODIFI_DATE", new Date());
			pureDao.saveOrUpdateEntity(tmap, "GMS_MAT_TEAMMAT_OUT_DETAIL");
			// 操作入库单
			String sql = "select * from GMS_MAT_TEAMMAT_INFO_DETAIL d where d.invoices_id='"
					+ id[i] + "' and d.bsflag='0'";
			Map getMap = pureDao.queryRecordBySQL(sql);
			if (oil_from.equals("1")) {
				if (getMap != null) {
					// 更新入库明细
					String updateSql = "update GMS_MAT_TEAMMAT_INFO_DETAIL d set d.mat_num='"
							+ reqMap.get(matNum)
							+ "',d.actual_price='"
							+ reqMap.get("actual_price")
							+ "',d.total_money='"
							+ reqMap.get(totalMoney)
							+ "' where d.invoices_id='" + id[i] + "'";
					jdbcDao.executeUpdate(updateSql);
				} else {
					Map inmap = new HashMap();
					inmap.put("INVOICES_ID", id[i]);
					inmap.put("WZ_ID", reqMap.get("wz_id"));
					inmap.put("mat_num", reqMap.get(matNum));
					inmap.put("actual_price", reqMap.get("actual_price"));
					inmap.put("total_money", reqMap.get(totalMoney));
					inmap.put("INPUT_TYPE", "2");
					inmap.put("BSFLAG", "0");
					inmap.put("org_id", user.getOrgId());
					inmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
					inmap.put("CREATOR_ID", user.getUserId());
					inmap.put("CREATE_DATE", new Date());
					inmap.put("UPDATOR_ID", user.getUserId());
					inmap.put("MODIFI_DATE", new Date());
					inmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
					pureDao.saveOrUpdateEntity(inmap,
							"GMS_MAT_TEAMMAT_INFO_DETAIL");
				}
			} else if (oil_from.equals("0")) {
				if (getMap != null) {
					// 更新入库明细
					String upindetail = "update GMS_MAT_TEAMMAT_INFO_DETAIL d set d.bsflag='1' where d.invoices_id='"
							+ id[i] + "'";
					jdbcDao.executeUpdate(upindetail);
				}
			}
		}
		return reqMsg;
	}

	public ISrvMsg viewConsumption(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String teammat_out_id = reqDTO.getValue("teammat_out_id");

		String sql = "select * from GMS_MAT_TEAMMAT_OUT o inner join gms_device_account_dui d on o.dev_acc_id=d.dev_acc_id and d.bsflag='0' inner join p_auth_user u on o.creator_id=u.user_id and u.bsflag='0' where o.teammat_out_id='"
				+ teammat_out_id
				+ "' and o.bsflag='0'and o.dev_acc_id is not null";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("map", map);
		return reqMsg;
	}

	// 单机消耗计划管理 添加的时候用的 ，显示通设备的全部物资 复选框全选
	public ISrvMsg queryDevice(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String id = reqDTO.getValue("ids");
		String sql = "select i.wz_id,i.coding_code_id,i.wz_name,i.wz_prickie,i.wz_price,d.unit_num from GMS_MAT_DEMAND_TAMPLATE t join GMS_MAT_DEMAND_TAMPLATE_DETAIL d on t.tamplate_id=d.tamplate_id join GMS_MAT_INFOMATION i on i.wz_id=d.wz_id and i.bsflag='0' where t.tamplate_id='"
				+ id + "' order by i.coding_code_id asc,i.wz_id asc";

		List list = pureDao.queryRecords(sql);

		reqMsg.setValue("datas", list);
		return reqMsg;
	}

	// 修改的时候用的，复选框只选数据库保存的 单机消耗计划管理
	public ISrvMsg queryDeviceEdit(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String id = reqDTO.getValue("ids");
		String sql = "select * from GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where d.teammat_out_id='"
				+ id
				+ "' and d.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";

		List list = pureDao.queryRecords(sql);

		reqMsg.setValue("datas", list);
		return reqMsg;

	}

	public ISrvMsg queryExpense(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String id = reqDTO.getValue("ids");
		String sql = "select i.*,d.plan_num,d.use_num from gms_mat_teammat_out o left join gms_mat_device_use_info_detail d on o.teammat_out_id = d.teammat_out_id and d.bsflag='0' join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where o.teammat_out_id='"
				+ id
				+ "' and o.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";

		List list = pureDao.queryRecords(sql);

		reqMsg.setValue("datas", list);
		return reqMsg;
	}

	public ISrvMsg viewExpense(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String teammat_out_id = reqDTO.getValue("teammat_out_id");

		String sql = "select o.total_money,o.device_id,o.*,decode(o.status,'0','未提交','1','已提交','2','已结束') stat ,c.dev_name dev_name,c.self_num,c.license_num,r.notes,u.user_name from gms_mat_teammat_out o join gms_device_account_dui c on o.dev_acc_id = c.dev_acc_id left join bgp_comm_remark r on o.teammat_out_id = r.foreign_key_id and r.bsflag='0' join p_auth_user u on o.creator_id = u.user_id and u.bsflag='0' where o.teammat_out_id='"
				+ teammat_out_id + "' and o.bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	public ISrvMsg addExpense(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String teammat_out_id = reqDTO.getValue("teammat_out_id");
		String device_use_name = reqDTO.getValue("device_use_name");
		String device_id = reqDTO.getValue("device_id");
		String remark = reqDTO.getValue("remark");
		String ids = reqDTO.getValue("ids");
		String[] temp = ids.split(",");
		Map map = new HashMap();

		map.put("TEAMMAT_OUT_ID", teammat_out_id);
		map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		map.put("DEVICE_USE_NAME", device_use_name);
		map.put("procure_no", reqDTO.getValue("second_org2"));
		map.put("total_money", reqDTO.getValue("total_money"));
		map.put("DEVICE_ID", device_id);
		map.put("dev_acc_id", reqDTO.getValue("dev_acc_id"));
		map.put("plan_invoice_id", "0");
		map.put("PLAN_TYPE", "1");
		map.put("STATUS", "0");
		map.put("org_id", user.getOrgId());
		map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("CREATE_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		Serializable id = pureDao
				.saveOrUpdateEntity(map, "GMS_MAT_TEAMMAT_OUT");

		if (!remark.equals("") || remark != null) {
			Map remarkMap = new HashMap();
			remarkMap.put("FOREIGN_KEY_ID", id);
			remarkMap.put("NOTES", remark);
			remarkMap.put("CREATOR_ID", user.getUserId());
			remarkMap.put("CREATE_DATE", new Date());
			remarkMap.put("UPDATOR_ID", user.getUserId());
			remarkMap.put("MODIFI_DATE", new Date());
			remarkMap.put("BSFLAG", "0");
			pureDao.saveOrUpdateEntity(remarkMap, "BGP_COMM_REMARK");
		}
		for (int i = 0; i < temp.length; i++) {
			String plan_num = reqDTO.getValue("plan_num" + temp[i]);
			System.out.println(temp[i]);
			Map tmap = new HashMap();
			tmap.put("TEAMMAT_OUT_ID", id);
			tmap.put("WZ_ID", temp[i]);
			tmap.put("PLAN_NUM", plan_num);
			tmap.put("APP_NUM", plan_num);
			tmap.put("BSFLAG", "0");
			pureDao.saveOrUpdateEntity(tmap, "GMS_MAT_DEVICE_USE_INFO_DETAIL");
		}
		return reqMsg;
	}

	public ISrvMsg saveExpense(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqMap = reqDTO.toMap();
		String teammat_out_id = reqDTO.getValue("teammat_out_id");
		String device_use_name = reqDTO.getValue("device_use_name");
		String remark = reqDTO.getValue("remark");
		String ids = reqDTO.getValue("ids");
		String details = reqDTO.getValue("details");
		String[] dd = details.split(",");
		String[] temp = ids.split(",");
		Map map = new HashMap();

		map.put("TEAMMAT_OUT_ID", teammat_out_id);
		map.put("DEVICE_USE_NAME", device_use_name);
		map.put("procure_no", reqDTO.getValue("second_org2"));
		map.put("total_money", reqDTO.getValue("total_money"));
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		Serializable id = pureDao
				.saveOrUpdateEntity(map, "GMS_MAT_TEAMMAT_OUT");

		if (!remark.equals("") && remark != null) {
			Map remarkMap = new HashMap();
			remarkMap.put("FOREIGN_KEY_ID", id);
			remarkMap.put("NOTES", remark);
			remarkMap.put("CREATOR_ID", user.getUserId());
			remarkMap.put("CREATE_DATE", new Date());
			remarkMap.put("UPDATOR_ID", user.getUserId());
			remarkMap.put("MODIFI_DATE", new Date());
			remarkMap.put("BSFLAG", "0");
			pureDao.saveOrUpdateEntity(remarkMap, "BGP_COMM_REMARK");
		}

		for (int i = 0; i < temp.length; i++) {
			String plan_num = reqDTO.getValue("plan_num" + temp[i]);
			String detail = reqDTO.getValue("detail" + temp[i]);
			System.out.println(temp[i]);
			Map tmap = new HashMap();
			tmap.put("USE_INFO_DETAIL", detail);
			tmap.put("PLAN_NUM", plan_num);
			tmap.put("BSFLAG", "0");
			pureDao.saveOrUpdateEntity(tmap, "GMS_MAT_DEVICE_USE_INFO_DETAIL");
		}

		for (int j = 0; j < dd.length; j++) {
			String aa = dd[j];
			String sql = "update gms_mat_device_use_info_detail set bsflag = '1' where use_info_detail = '"
					+ dd[j] + "'";
			jdbcDao.executeUpdate(sql);
		}
		return reqMsg;
	}

	public ISrvMsg submitExpense(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String ids = reqDTO.getValue("ids");
		String id[] = ids.split(",");
		for (int i = 0; i < id.length; i++) {
			String sql = "update gms_mat_teammat_out set status = '1' where teammat_out_id = '"
					+ id[i] + "'";
			jdbcDao.executeUpdate(sql);
		}
		return reqMsg;
	}

	public ISrvMsg deleteExpense(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String ids = reqDTO.getValue("ids");
		String id[] = ids.split(",");
		for (int i = 0; i < id.length; i++) {
			String sql = "update gms_mat_teammat_out set bsflag = '1' where teammat_out_id = '"
					+ id[i] + "'";
			jdbcDao.executeUpdate(sql);
		}
		return reqMsg;
	}

	public ISrvMsg closeExpense(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String ids = reqDTO.getValue("ids");
		String id[] = ids.split(",");
		for (int i = 0; i < id.length; i++) {
			String sql = "update gms_mat_teammat_out set status = '2' where teammat_out_id = '"
					+ id[i] + "'";
			jdbcDao.executeUpdate(sql);
		}
		return reqMsg;
	}

	/**
	 * 单机计划单号查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findDeviceNum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select * from gms_mat_teammat_out t where t.device_id='"
				+ id + "'and t.bsflag='0'and t.project_info_no='"
				+ user.getProjectInfoNo() + "'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 可重复利用库删除操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRepMat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("matId");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String sql = "update gms_mat_recyclemat_info t set t.bsflag = '1' where t.wz_id = '"
				+ id + "' and t.org_subjection_id='" + orgSubjectionId + "'";
		jdbcDao.executeUpdate(sql);
		return reqMsg;
	}

	/**
	 * 可重复利用库新增/修改操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRepMatLedgerEdit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String recyclemat_info = reqDTO.getValue("recyclemat_info");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String orgId = reqDTO.getValue("orgId");
		Map reqmap = reqDTO.toMap();
		String sql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
				+ reqmap.get("wz_id") + "' and t.recyclemat_info='"
				+ recyclemat_info + "' and t.bsflag='0'";
		Map getMap = pureDao.queryRecordBySQL(sql);
		if (getMap != null && orgSubjectionId.trim().length() > 0) {
			orgSubjectionId = getMap.get("org_subjection_id").toString();
		}
		// 数量
		double stockNum = Double.valueOf(reqmap.get("stock_num") == "" ? "0"
				: reqmap.get("stock_num").toString());
		double total_num = stockNum;
		Map map = new HashMap();
		// if(reqmap.get("recyclemat_info").toString().equals("")){
		if (getMap != null) {
			// stockNum += Double.valueOf(getMap.get("stock_num")== "" ? "0" :
			// getMap.get("stock_num").toString());
			// total_num += Double.valueOf(getMap.get("total_num")== "" ? "0" :
			// getMap.get("total_num").toString());

			// 单价
			double actual_price = Double
					.valueOf(getMap.get("actual_price") == "" ? "0" : getMap
							.get("actual_price").toString());
			// 库存数量*库存单间+新增数量*新增单间/总数量
			double avg_price = ((Double
					.valueOf(reqmap.get("actual_price") == "" ? "0" : reqmap
							.get("actual_price").toString()) * Double
					.valueOf(reqmap.get("stock_num") == "" ? "0" : reqmap.get(
							"stock_num").toString())) + (Double.valueOf(getMap
					.get("stock_num") == "" ? "0" : getMap.get("stock_num")
					.toString()) * Double
					.valueOf(getMap.get("actual_price") == "" ? "0" : getMap
							.get("actual_price").toString())))
					/ (stockNum == 0 ? 1 : stockNum);
			map.put("recyclemat_info", getMap.get("recyclemat_info"));
			map.put("actual_price", avg_price);
		} else {
			map.put("create_date", new Date());
			map.put("creator_id", user.getUserId());
			map.put("actual_price", reqmap.get("actual_price"));
		}
		// }

		map.put("wz_id", reqmap.get("wz_id"));
		map.put("stock_num", stockNum);
		map.put("total_num", total_num);
		map.put("wz_type", "2");
		map.put("org_id", orgId);
		map.put("org_subjection_id", orgSubjectionId);
		map.put("modifi_date", new Date());
		map.put("updator_id", user.getUserId());

		map.put("bsflag", "0");
		pureDao.saveOrUpdateEntity(map, "gms_mat_recyclemat_info");

		Map map2 = new HashMap();
		map2.put("if_submit", "1");
		map2.put("out_type", "2");
		map2.put("bsflag", "0");
		map2.put("org_id", orgId);
		map2.put("ORG_SUBJECTION_ID", orgSubjectionId);
		map2.put("CREATOR_ID", user.getUserId());
		map2.put("CREATE_DATE", new Date());
		map2.put("UPDATOR_ID", user.getUserId());
		map2.put("MODIFI_DATE", new Date());
		map2.put("out_date", new Date());
		Serializable out_info_id = pureDao.saveOrUpdateEntity(map2,
				"gms_mat_out_info");

		Map map3 = new HashMap();
		map3.put("OUT_INFO_ID", out_info_id.toString());
		map3.put("WZ_ID", reqmap.get("wz_id"));
		map3.put("OUT_PRICE", reqmap.get("actual_price"));
		map3.put("OUT_NUM", reqmap.get("stock_num"));
		map3.put(
				"TOTAL_MONEY",
				Double.valueOf(reqmap.get("actual_price") == "" ? "0" : reqmap
						.get("actual_price").toString())
						* Double.valueOf(reqmap.get("stock_num") == "" ? "0"
								: reqmap.get("stock_num").toString()));
		map3.put("BSFLAG", "0");
		pureDao.saveOrUpdateEntity(map3, "gms_mat_out_info_detail");

		return reqMsg;
	}

	/**
	 * 可重复利用库修改操作 ---------------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRepMatLedgerUpdate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		Map map = new HashMap();
		double broken_num = Double.valueOf(reqmap.get("broken_num") == "" ? "0"
				: reqmap.get("broken_num").toString());

		String sql = "select * from gms_mat_recyclemat_info t where t.recyclemat_info='"
				+ reqmap.get("recyclemat_info") + "' and t.bsflag='0'";
		Map getMap = pureDao.queryRecordBySQL(sql);
		if (getMap != null) {
			double stockNum = Double
					.valueOf(getMap.get("stock_num") == "" ? "0" : getMap.get(
							"stock_num").toString());
			stockNum = stockNum - broken_num;
			map.put("stock_num", stockNum);
		}

		map.put("recyclemat_info", reqmap.get("recyclemat_info"));
		map.put("total_num", reqmap.get("total_num"));
		map.put("broken_num", reqmap.get("broken_num"));

		map.put("modifi_date", new Date());
		map.put("updator_id", user.getUserId());

		map.put("bsflag", "0");
		pureDao.saveOrUpdateEntity(map, "gms_mat_recyclemat_info");
		return reqMsg;
	}

	/**
	 * 可重复利用库详细入库情况修改操作 ---------------------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg repMatLedgerUpdateDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String ids = reqDTO.getValue("ids");
		if (ids != null) {
			String[] id = ids.split(",");
			for (int i = 0; i < id.length; i++) {
				String out_info_detail_id = id[i];
				String sql = "select * from gms_mat_out_info_detail t join gms_mat_out_info io on t.out_info_id = io.out_info_id and io.bsflag = '0'  and io.if_submit = '1' and io.out_type = '2' join gms_mat_recyclemat_info ro on ro.wz_id=t.wz_id and ro.bsflag='0' and ro.wz_type='2' where t.bsflag = '0' and io.org_subjection_id=ro.org_subjection_id and t.out_info_detail_id = '"
						+ out_info_detail_id + "'";
				Map mapDetail = pureDao.queryRecordBySQL(sql);
				double outNum = Double
						.valueOf(mapDetail.get("out_num") == "" ? "0"
								: mapDetail.get("out_num").toString());
				String recyclemat_info = (String) mapDetail
						.get("recyclemat_info");
				double stockNum = Double
						.valueOf(mapDetail.get("stock_num") == "" ? "0"
								: mapDetail.get("stock_num").toString());
				double totalNum = Double
						.valueOf(mapDetail.get("total_num") == "" ? "0"
								: mapDetail.get("total_num").toString());

				double newOutNum = Double.valueOf(reqDTO.getValue("out_num_"
						+ out_info_detail_id) == "" ? "0" : reqDTO
						.getValue("out_num_" + out_info_detail_id));
				double newOutPrice = Double
						.valueOf(reqDTO.getValue("out_price_"
								+ out_info_detail_id) == "" ? "0" : reqDTO
								.getValue("out_price_" + out_info_detail_id));
				double newTotalMoney = Double
						.valueOf(reqDTO.getValue("total_money_"
								+ out_info_detail_id) == "" ? "0" : reqDTO
								.getValue("total_money_" + out_info_detail_id));

				Map map = new HashMap();
				map.put("OUT_INFO_DETAIL_ID", out_info_detail_id);
				map.put("OUT_PRICE", newOutPrice);
				map.put("OUT_NUM", newOutNum);
				map.put("TOTAL_MONEY", newTotalMoney);
				pureDao.saveOrUpdateEntity(map, "GMS_MAT_OUT_INFO_DETAIL");

				Map map2 = new HashMap();
				map2.put("RECYCLEMAT_INFO", recyclemat_info);
				map2.put("STOCK_NUM", stockNum + newOutNum - outNum);
				map2.put("TOTAL_NUM", totalNum + newOutNum - outNum);
				pureDao.saveOrUpdateEntity(map2, "gms_mat_recyclemat_info");
			}
		}
		return reqMsg;
	}

	/**
	 * 可重复利用物资台账物子查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRepMatLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select * from gms_mat_recyclemat_info t where t.recyclemat_info='"
				+ id + "'and t.bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/*
	 * 查询组织机构
	 */
	public ISrvMsg queryOrgSubjection(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String str = "";
		if (!orgSubjectionId.equals("")) {
			str = " where t.org_subjection_id like '" + orgSubjectionId + "%'";
		}
		StringBuffer sb = new StringBuffer(
				"select t.org_subjection_id value,t.org_abbreviation lable from bgp_comm_org_wtc t "
						+ str);

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}

	/*
	 * 查询项目名称
	 */
	public ISrvMsg queryProgectName(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		StringBuffer sb = new StringBuffer(
				"select p.project_info_no value,p.project_name lable from gp_task_project p join gp_task_project_dynamic d on p.project_info_no=d.project_info_no and d.bsflag='0' where p.bsflag='0'and d.org_subjection_id like '"
						+ orgSubjectionId + "%'");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}

	/**
	 * 小队单项物资消耗详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamListXH(ISrvMsg reqDTO) throws Exception {
		String logid = "[getTeamListXH]";
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_type = reqDTO.getValue("wz_type");
		String id = reqDTO.getValue("ids");
		String org_id = user.getOrgId();
		if (org_id != null
				&& (org_id.equals("C6000000000039")
						|| org_id.equals("C6000000000040")
						|| org_id.equals("C6000000005275")
						|| org_id.equals("C6000000005277")
						|| org_id.equals("C6000000005278")
						|| org_id.equals("C6000000005279") || org_id
							.equals("C6000000005280"))) {
			wz_type = "11";
		} else if((org_id.equals("C6000000000039")
				|| org_id.equals("C6000000000040")
				|| org_id.equals("C6000000005275")
				|| org_id.equals("C6000000005277")
				|| org_id.equals("C6000000005278")
				|| org_id.equals("C6000000005279") || org_id
					.equals("C6000000005280"))){
			wz_type = "22";
		}
		
		String sql = "select d.*,i.*,nvl(c.coding_name," +
				"(dev.dev_name || '-' || dev.license_num || '-' || dev.self_num || '-' || dev.dev_sign)) as tname," +
				"o.outmat_date from gms_mat_teammat_out o " +
				"inner join " +
				"(gms_mat_teammat_out_detail d " +
				"inner join gms_mat_infomation i " +
				"on d.wz_id=i.wz_id and i.bsflag='0') " +
				"on o.teammat_out_id=d.teammat_out_id " +
				"and d.bsflag='0' " +
				"left join comm_coding_sort_detail c " +
				"on o.team_id = c.coding_code_id and c.bsflag='0' " +
				"left join gms_device_account_dui dev " +
				"on dev.dev_acc_id=o.dev_acc_id " +
				"and dev.bsflag='0' where o.bsflag='0' " +
				"and o.out_type<>'5' " +
				"and  o.wz_type='"
				+ wz_type
				+ "'  and d.wz_id='"
				+ id
				+ "'and o.project_info_no='"
				+ projectInfoNo
				+ "' order by d.create_date desc";
		log.info(logid + "sql=" + sql);
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 小队单项物资入库详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamListRK(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select i.invoices_no,d.mat_num,d.actual_price,d.total_money,d.warehouse_number,d.goods_allocation,i.procure_no,d.input_type,i.input_date,p.project_name as mat_sourth from gms_mat_teammat_info_detail d left join gms_mat_teammat_invoices i on d.invoices_id=i.invoices_id and i.bsflag='0' left join gp_task_project p on d.mat_sourth=p.project_info_no where d.wz_id='"
				+ id
				+ "' and i.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 小队单项物资退库详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamListTK(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_type = reqDTO.getValue("wz_type");
		String id = reqDTO.getValue("ids");
		String sql = "select t.out_info_detail_id,t.out_info_id,t.wz_id,t.out_price,t.out_num,t.total_money,i.wz_name,i.wz_prickie from gms_mat_out_info_detail t inner join gms_mat_infomation i on t.wz_id = i.wz_id and t.bsflag = '0' and i.bsflag = '0' inner join GMS_MAT_OUT_INFO o on t.out_info_id = o.out_info_id and o.bsflag = '0' and o.out_type = '2' and t.wz_id = '"
				+ id
				+ "' and t.project_info_no = '"
				+ projectInfoNo
				+ "' and t.out_num > 0";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 小队单项物资转出详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamListZC(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_type = reqDTO.getValue("wz_type");
		String id = reqDTO.getValue("ids");
		String sql = "select i.coding_code_id,i.wz_id,i.wz_name,i.wz_prickie,d.out_price,d.out_num,d.total_money,o.out_date from GMS_MAT_OUT_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag = '0' inner join GMS_MAT_OUT_INFO o on d.out_info_id = o.out_info_id and o.bsflag = '0' where d.wz_id = '"
				+ id
				+ "' and o.out_type = '4' and d.project_info_no = '"
				+ projectInfoNo
				+ "' order by i.coding_code_id asc, i.wz_id asc";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 待料计划详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPlanMatList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select i.coding_code_id,i.wz_id,i.wz_name,i.wz_prickie,i.wz_price,d.demand_num,case when d.use_num is null then 0 else d.use_num end use_num,(d.demand_num-(case when d.use_num is null then 0 else d.use_num end))odd_num,d.demand_money from gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where d.submite_number='"
				+ id
				+ "' and d.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 物资转出页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRemoveLeaf(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		List<Map> list = new ArrayList<Map>();
		// String
		// sql="select i.wz_id,i.coding_code_id,i.wz_name,i.wz_prickie,t.stock_num,t.actual_price,(t.stock_num*t.actual_price)total_money from gms_mat_teammat_info t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.project_info_no='"+projectInfoNo+"' and t.stock_num>0 and t.bsflag='0'";

		String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,a.stock_num*a.wz_price total_money from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 小队库存物资转出项目
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRemove(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String laborId = reqMap.get("laborId").toString();
		String[] ids = laborId.split(",");
		String wz_types = reqDTO.getValue("wz_types"); // 原项目出库类型
		String wzType = reqDTO.getValue("wzType");

		// 生成转出单据
		Map outMap = new HashMap();
		outMap.put("project_info_no", projectInfoNo);
		outMap.put("input_org", reqMap.get("input_org"));
		outMap.put("operator", reqMap.get("operator"));
		outMap.put("out_date", reqMap.get("out_date"));
		outMap.put("total_money", reqMap.get("total_money"));

		outMap.put("bsflag", "0");
		outMap.put("org_id", user.getOrgId());
		outMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		outMap.put("CREATOR_ID", user.getUserId());
		outMap.put("CREATE_DATE", new Date());
		outMap.put("UPDATOR_ID", user.getUserId());
		outMap.put("MODIFI_DATE", new Date());
		outMap.put("out_type", "4");
		Serializable out_info_id = pureDao.saveOrUpdateEntity(outMap,
				"GMS_MAT_OUT_INFO");
		// 生成入库单据
		Map inMap = new HashMap();
		inMap.put("invoices_no", this.getTableNum());
		inMap.put("source", projectInfoNo);
		inMap.put("operator", reqMap.get("operator"));
		inMap.put("input_date", reqMap.get("out_date"));
		inMap.put("total_money", reqMap.get("total_money"));
		inMap.put("project_info_no", reqMap.get("input_org"));
		inMap.put("invoices_type", wzType);
		inMap.put("if_input", "0");

		inMap.put("bsflag", "0");
		inMap.put("org_id", user.getOrgId());
		inMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		inMap.put("CREATOR_ID", user.getUserId());
		inMap.put("CREATE_DATE", new Date());
		inMap.put("UPDATOR_ID", user.getUserId());
		inMap.put("MODIFI_DATE", new Date());
		Serializable invoices_id = pureDao.saveOrUpdateEntity(inMap,
				"GMS_MAT_TEAMMAT_INVOICES");

		Map outMap2 = new HashMap();
		outMap2.put("PLAN_INVOICE_ID", out_info_id.toString());
		outMap2.put("project_info_no", projectInfoNo);
		outMap2.put("bsflag", "0");
		outMap2.put("WZ_TYPE", wz_types);
		Serializable outId = pureDao.saveOrUpdateEntity(outMap2,
				"gms_mat_teammat_out");

		// 生成单据明细
		for (int i = 0; i < ids.length; i++) {
			// 查询物资明细
			// String sql =
			// "select t.wz_id,t.stock_num,t.actual_price,(t.stock_num*t.actual_price)total_money from gms_mat_teammat_info t  where t.project_info_no='"+projectInfoNo+"' and t.wz_id='"+ids[i]+"' and t.bsflag='0'";
			String sql = "";
			if (wz_types != null && wz_types.equals("1")) {
				sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,(a.stock_num*a.wz_price) total_money,a.project_info_no from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.project_info_no from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' and mti.if_input='0' and mti.invoices_type='2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ user.getProjectInfoNo()
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ user.getProjectInfoNo()
						+ "') a where a.project_info_no='"
						+ projectInfoNo
						+ "' and a.wz_id='" + ids[i] + "'";
			} else if (wz_types != null && wz_types.equals("2")) {
				sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num, (nvl(a.stock_num,0)*nvl(a.wz_price,0)) total_money,a.project_info_no from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,t.avg_price wz_price,t.stock_num,t.mat_num,t.out_num,T.PROJECT_INFO_NO from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' and mti.if_input='0' and mti.invoices_type='1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ user.getProjectInfoNo()
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ user.getProjectInfoNo()
						+ "') a  where a.project_info_no='"
						+ projectInfoNo
						+ "' and a.wz_id='" + ids[i] + "'";
			} else {
				sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,(a.stock_num*a.wz_price) total_money,a.project_info_no from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.project_info_no from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' and mti.if_input='0' and mti.invoices_type<>'2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"
						+ user.getProjectInfoNo()
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ user.getProjectInfoNo()
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ user.getProjectInfoNo()
						+ "') a where a.project_info_no='"
						+ projectInfoNo
						+ "' and a.wz_id='" + ids[i] + "'";
			}
			Map getMat = pureDao.queryRecordBySQL(sql);

			String out_num = reqDTO.getValue("out_num_" + ids[i]);
			String total_money = reqDTO.getValue("total_money_" + ids[i]);
			// 生成转出单据明细
			Map outDetailMap = new HashMap();
			outDetailMap.put("out_info_id", out_info_id.toString());
			outDetailMap.put("wz_id", getMat.get("wz_id"));
			outDetailMap.put("out_price", getMat.get("wz_price"));
			outDetailMap.put("out_num", out_num);
			outDetailMap.put("total_money", total_money);
			outDetailMap.put("project_info_no", projectInfoNo);
			outDetailMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap, "GMS_MAT_OUT_INFO_DETAIL");
			// 生成入库单据明细
			Map inDetailMap = new HashMap();
			inDetailMap.put("invoices_id", invoices_id.toString());
			inDetailMap.put("wz_id", getMat.get("wz_id"));
			inDetailMap.put("actual_price", getMat.get("wz_price"));
			inDetailMap.put("mat_num", out_num);
			inDetailMap.put("total_money", total_money);
			inDetailMap.put("project_info_no", reqMap.get("input_org"));
			inDetailMap.put("bsflag", "0");
			inDetailMap.put("if_accept", "0");
			inDetailMap.put("MAT_SOURTH", projectInfoNo); // 转出把项目Id保存在入库明细，以便于追踪
			inDetailMap.put("org_id", user.getOrgId());
			inDetailMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			inDetailMap.put("CREATOR_ID", user.getUserId());
			inDetailMap.put("CREATE_DATE", new Date());
			inDetailMap.put("UPDATOR_ID", user.getUserId());
			inDetailMap.put("MODIFI_DATE", new Date());
			pureDao.saveOrUpdateEntity(inDetailMap,
					"GMS_MAT_TEAMMAT_INFO_DETAIL");
			// 减少小队库存
			// String upSql =
			// "update gms_mat_teammat_info t set t.stock_num='0' where t.project_info_no='"+projectInfoNo+"' and t.wz_id='"+ids[i]+"' and t.bsflag='0'";
			// jdbcDao.executeUpdate(upSql);

			Map outDetailMap2 = new HashMap();
			outDetailMap2.put("teammat_out_id", outId.toString());
			outDetailMap2.put("wz_id", getMat.get("wz_id"));
			outDetailMap2.put("mat_num", out_num);
			outDetailMap2.put("actual_price", getMat.get("wz_price"));
			outDetailMap2.put("total_money", total_money);
			outDetailMap2.put("project_info_no", projectInfoNo);
			outDetailMap2.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap2,
					"gms_mat_teammat_out_detail");

		}
		return reqMsg;
	}

	/**
	 * 转移物资详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRemoveMatList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select i.coding_code_id,i.wz_id,i.wz_name,i.wz_prickie,d.out_price,d.out_num,d.total_money from GMS_MAT_OUT_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where d.out_info_id='"
				+ id
				+ "' and d.bsflag='0' order by i.coding_code_id asc,i.wz_id asc";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 生成表单单号
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public String getTableNum2(String projectInfoNo, String invoicesType) {
		// String startDate = new
		// java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
		// SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		// String applyDate = sdf.format(new Date());

		// 自动算生成单号年月日-001
		String input_no = "";
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(date);
		String autoSql = "select invoices_no from gms_mat_teammat_invoices t where t.project_info_no='"
				+ projectInfoNo
				+ "' and t.bsflag='0' and t.invoices_type = '"
				+ invoicesType
				+ "' and t.invoices_no like '"
				+ today
				+ "%' order by invoices_no desc";
		Map autoMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(autoSql);
		if (autoMap != null && autoMap.size() != 0) {
			String input_nos = (String) autoMap.get("invoicesNo");
			String[] temp = input_nos.split("-");
			String nos = String.valueOf(Integer.parseInt(temp[1]) + 1);
			if (nos.length() == 1) {
				nos = "00" + nos;
			} else if (nos.length() == 2) {
				nos = "0" + nos;
			}
			input_no = today + "-" + nos;
		} else {
			input_no = today + "-001";
		}
		return input_no;
	}

	public String getTableNum3(String projectInfoNo) {
		// String startDate = new
		// java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
		// SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		// String applyDate = sdf.format(new Date());

		// 自动算生成单号年月日-001
		String input_no = "";
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String today = sdf.format(date);
		String autoSql = "select procure_no from gms_mat_teammat_out t where t.project_info_no='"
				+ projectInfoNo
				+ "' and t.bsflag='0' and t.procure_no like '"
				+ today + "%' order by procure_no desc";
		Map autoMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(autoSql);
		if (autoMap != null && autoMap.size() != 0) {
			String input_nos = (String) autoMap.get("procureNo");
			String[] temp = input_nos.split("-");
			String nos = String.valueOf(Integer.parseInt(temp[1]) + 1);
			if (nos.length() == 1) {
				nos = "00" + nos;
			} else if (nos.length() == 2) {
				nos = "0" + nos;
			}
			input_no = today + "-" + nos;
		} else {
			input_no = today + "-001";
		}
		return input_no;
	}

	public String getTableNum() {
		String startDate = new java.text.SimpleDateFormat("yyyy-MM-dd")
				.format(new Date());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String applyDate = sdf.format(new Date());
		return applyDate;
	}

	/**
	 * 其他油料消耗新增单据
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveConOil(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();

		Map reqMap = reqDTO.toMap();

		String totalMoney = "";// 总金额,增加金额判断(前台总金额计算有可能为0)
		float oilNum = 0;// 数量
		float actualPrice = 0;// 单价
		if (reqDTO.getValue("total_money") != null) {
			totalMoney = reqDTO.getValue("total_money");
		}
		if (reqDTO.getValue("oil_num") != null) {
			oilNum = Float.parseFloat(reqDTO.getValue("oil_num"));
		}
		if (reqMap.get("actual_price") != null) {
			actualPrice = Float.parseFloat(reqMap.get("actual_price")
					.toString());
		}

		// 当前台传过来的总金额为空,直接用单价*数量
		if (totalMoney == null || totalMoney.equals("0")
				|| totalMoney.equals("")) {
			float tempt = Math.round((oilNum * actualPrice) * 1000) / 1000;
			totalMoney = String.valueOf(tempt);
		}

		// 单据信息
		Map map = new HashMap();
		map.put("TEAMMAT_OUT_ID", reqMap.get("teammat_out_id"));
		map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		map.put("DEVICE_USE_NAME", reqMap.get("device_use_name"));
		map.put("procure_no", reqDTO.getValue("procure_no"));
		map.put("drawer", reqDTO.getValue("drawer"));
		map.put("use_user", reqDTO.getValue("use_user"));
		map.put("oil_from", reqDTO.getValue("oil_from"));
		map.put("total_money", totalMoney);
		map.put("outmat_date", reqDTO.getValue("outmat_date"));
		map.put("team_id", reqDTO.getValue("team_id"));
		map.put("out_type", reqDTO.getValue("out_type"));
		map.put("org_id", user.getOrgId());
		map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("CREATE_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		String org_subjection_id = user.getOrgSubjectionId();
		String org_id = user.getOrgId();
		if (org_subjection_id.startsWith("C105007")) {
			if (reqDTO.getValue("oil_from").equals("0")) {
				if (org_id != null
						&& (org_id.equals("C6000000000039")
								|| org_id.equals("C6000000000040")
								|| org_id.equals("C6000000005275")
								|| org_id.equals("C6000000005277")
								|| org_id.equals("C6000000005278")
								|| org_id.equals("C6000000005279") || org_id
									.equals("C6000000005280"))) {
					map.put("wz_type", "11");// 油库加油，
				} else {
					map.put("wz_type", "22");// 油库加油，
				}
			}
		} else {
			map.put("wz_type", reqMap.get("wz_type"));// 油库加油，wz_type=0
		}
		Serializable id = pureDao
				.saveOrUpdateEntity(map, "GMS_MAT_TEAMMAT_OUT");
		// 出库明细信息
		Map tmap = new HashMap();
		tmap.put("TEAMMAT_OUT_ID", id);
		tmap.put("WZ_ID", reqMap.get("wz_id"));
		tmap.put("mat_num", reqDTO.getValue("mat_num"));
		tmap.put("oil_num", reqDTO.getValue("oil_num"));
		tmap.put("actual_price", reqMap.get("actual_price"));
		tmap.put("total_money", totalMoney);
		tmap.put("BSFLAG", "0");
		tmap.put("org_id", user.getOrgId());
		tmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		tmap.put("CREATOR_ID", user.getUserId());
		tmap.put("CREATE_DATE", new Date());
		tmap.put("UPDATOR_ID", user.getUserId());
		tmap.put("MODIFI_DATE", new Date());
		tmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		Serializable detail_id = pureDao.saveOrUpdateEntity(tmap,
				"GMS_MAT_TEAMMAT_OUT_DETAIL");
		// 入库明细信息
		String oil_from = reqDTO.getValue("oil_from").toString();
		if (oil_from.equals("1")) {
			Map inmap = new HashMap();
			inmap.put("INVOICES_ID", id);
			inmap.put("WZ_ID", reqMap.get("wz_id"));
			inmap.put("mat_num", reqDTO.getValue("mat_num"));
			inmap.put("actual_price", reqMap.get("actual_price"));
			inmap.put("total_money", reqDTO.getValue("total_money"));
			inmap.put("INPUT_TYPE", "2");
			inmap.put("BSFLAG", "0");
			inmap.put("org_id", user.getOrgId());
			inmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			inmap.put("CREATOR_ID", user.getUserId());
			inmap.put("CREATE_DATE", new Date());
			inmap.put("UPDATOR_ID", user.getUserId());
			inmap.put("MODIFI_DATE", new Date());
			inmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
			pureDao.saveOrUpdateEntity(inmap, "GMS_MAT_TEAMMAT_INFO_DETAIL");
		}
		return reqMsg;
	}

	/**
	 * 油料消耗单据基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg viewConOil(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String teammat_out_id = reqDTO.getValue("teammat_out_id");

		String sql = "select t.device_use_name,t.procure_no,t.outmat_date,t.total_money,u.user_name,d.coding_name team_name,o.coding_name share_name,sd.coding_name,t.drawer from gms_mat_teammat_out t left join p_auth_user u on t.creator_id=u.user_id left join comm_coding_sort_detail d on t.team_id=d.coding_code_id left join comm_coding_sort_detail o on t.drawer=o.coding_code_id left join comm_coding_sort_detail sd on t.use_user=sd.coding_code_id  where t.teammat_out_id='"
				+ teammat_out_id + "'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		reqMsg.setValue("map", map);
		return reqMsg;
	}

	/**
	 * 油料消耗详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findConOilList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select i.wz_name,i.wz_prickie,i.wz_price,d.actual_price,d.mat_num,d.total_money,d.oil_num from GMS_MAT_TEAMMAT_OUT t inner join  (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id =d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='"
				+ id
				+ "'and t.bsflag='0'and t.project_info_no='"
				+ user.getProjectInfoNo() + "'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 分包商
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryConOil(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String sql = "select d.coding_code_id value,d.coding_name lable from comm_coding_sort_detail d where d.coding_sort_id='5110000049'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 材料通途
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryConUse(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String sql = "select d.coding_code_id value,d.coding_name lable from comm_coding_sort_detail d where d.coding_sort_id='5110000048'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 其他油料消耗单据信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findConOil(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("teammatOutId");
		String sql = "select t.teammat_out_id,t.device_use_name,t.oil_from,t.procure_no,t.outmat_date,t.total_money,t.use_user,t.drawer,t.team_id,d.wz_id,d.mat_num,d.oil_num,d.actual_price,i.coding_code_id from gms_mat_teammat_out t inner join gms_mat_teammat_out_detail d on t.teammat_out_id=d.teammat_out_id  inner join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag='0' where t.out_type='4' and t.bsflag='0'and t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and t.teammat_out_id='"
				+ id
				+ "'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 油料消耗修改单据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg editConOil(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		String oil_from = reqDTO.getValue("oil_from").toString();
		Map reqMap = reqDTO.toMap();
		// 更新出库单
		Map map = new HashMap();
		map.put("TEAMMAT_OUT_ID", reqMap.get("teammat_out_id"));
		map.put("PROJECT_INFO_NO", user.getProjectInfoNo());
		map.put("DEVICE_USE_NAME", reqMap.get("device_use_name"));
		map.put("procure_no", reqDTO.getValue("procure_no"));
		map.put("drawer", reqDTO.getValue("drawer"));
		map.put("use_user", reqDTO.getValue("use_user"));
		map.put("oil_from", reqDTO.getValue("oil_from"));
		map.put("total_money", reqDTO.getValue("total_money"));
		map.put("outmat_date", reqDTO.getValue("outmat_date"));
		map.put("team_id", reqDTO.getValue("team_id"));
		map.put("out_type", reqDTO.getValue("out_type"));
		map.put("org_id", user.getOrgId());
		map.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("CREATE_DATE", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("BSFLAG", "0");
		String org_subjection_id = user.getOrgSubjectionId();
		String org_id = user.getOrgId();
		if (org_subjection_id.startsWith("C105007")) {
			if (reqDTO.getValue("oil_from").equals("0")) {
				if (org_id != null
						&& (org_id.equals("C6000000000039")
								|| org_id.equals("C6000000000040")
								|| org_id.equals("C6000000005275")
								|| org_id.equals("C6000000005277")
								|| org_id.equals("C6000000005278")
								|| org_id.equals("C6000000005279") || org_id
									.equals("C6000000005280"))) {
					map.put("wz_type", "11");// 油库加油，
				} else {
					map.put("wz_type", "22");// 油库加油，
				}
			}
		} else {
			map.put("wz_type", reqMap.get("wz_type"));// 油库加油，wz_type=0
		}
		pureDao.saveOrUpdateEntity(map, "GMS_MAT_TEAMMAT_OUT");
		// 更新出库明细
		String upoutdetail = "update GMS_MAT_TEAMMAT_OUT_DETAIL d set d.oil_num='"
				+ reqDTO.getValue("oil_num")
				+ "',d.mat_num='"
				+ reqDTO.getValue("mat_num")
				+ "',d.actual_price = '"
				+ reqDTO.getValue("actual_price")
				+ "',d.total_money='"
				+ reqDTO.getValue("total_money")
				+ "',d.wz_id='"
				+ reqDTO.getValue("wz_id")
				+ "' where d.teammat_out_id='"
				+ reqDTO.getValue("teammat_out_id") + "'";
		jdbcDao.executeUpdate(upoutdetail);
		// 更新入库明细
		String sql = "select * from GMS_MAT_TEAMMAT_INFO_DETAIL d where d.invoices_id='"
				+ reqDTO.getValue("teammat_out_id") + "' and d.bsflag='0'";
		Map getMap = pureDao.queryRecordBySQL(sql);
		if (oil_from.equals("1")) {
			if (getMap != null) {
				// 更新入库明细
				String upindetail = "update GMS_MAT_TEAMMAT_INFO_DETAIL d set d.mat_num='"
						+ reqDTO.getValue("mat_num")
						+ "',d.actual_price = '"
						+ reqDTO.getValue("actual_price")
						+ "',d.total_money='"
						+ reqDTO.getValue("total_money")
						+ "',d.wz_id='"
						+ reqDTO.getValue("wz_id")
						+ "' where d.invoices_id='"
						+ reqDTO.getValue("teammat_out_id") + "'";
				jdbcDao.executeUpdate(upindetail);
			} else {
				Map inmap = new HashMap();
				inmap.put("INVOICES_ID", reqMap.get("teammat_out_id"));
				inmap.put("WZ_ID", reqMap.get("wz_id"));
				inmap.put("mat_num", reqDTO.getValue("mat_num"));
				inmap.put("actual_price", reqMap.get("actual_price"));
				inmap.put("total_money", reqDTO.getValue("total_money"));
				inmap.put("INPUT_TYPE", "2");
				inmap.put("BSFLAG", "0");
				inmap.put("org_id", user.getOrgId());
				inmap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
				inmap.put("CREATOR_ID", user.getUserId());
				inmap.put("CREATE_DATE", new Date());
				inmap.put("UPDATOR_ID", user.getUserId());
				inmap.put("MODIFI_DATE", new Date());
				inmap.put("PROJECT_INFO_NO", user.getProjectInfoNo());
				pureDao.saveOrUpdateEntity(inmap, "GMS_MAT_TEAMMAT_INFO_DETAIL");
			}
		} else if (oil_from.equals("0")) {
			if (getMap != null) {
				// 更新入库明细
				String upindetail = "update GMS_MAT_TEAMMAT_INFO_DETAIL d set d.bsflag='1' where d.invoices_id='"
						+ reqDTO.getValue("teammat_out_id") + "'";
				jdbcDao.executeUpdate(upindetail);
			}
		}
		return reqMsg;
	}

	/**
	 * 物资出库页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherGantOut(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num, (nvl(a.stock_num,0)*nvl(a.wz_price,0)) total_money from(select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' and mti.invoices_type<>'2' and mti.invoices_type<>'1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0'  where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a";
		if (wz_ids != null && !wz_ids.equals("")) {
			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 可重复利用物资出库页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherRepOut_Dg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		// String
		// sql="select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,aa.stock_num,a.mat_num,a.out_num,a.org_id,comm.org_abbreviation from (select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.org_id from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no,aa.org_id from (select * from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num)-case when sum(info.infosum) is null then 0 else sum(info.infosum) end mat_num, flat.plan_org org_id from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' inner join gms_mat_demand_plan_flat flat on mti.invoices_id = flat.invoices_id left join (select sum(stock_num) infosum,gms.wz_id from GMS_MAT_TEAMMAT_INFO gms inner join ( select wz_id from gms_mat_out_info g inner join gms_mat_out_info_detail g1 on g.out_info_id=g1.out_info_id where g1.project_info_no ='"+user.getProjectInfoNo()+"' and input_org='专业化' ) g on gms.wz_id=g.wz_id where project_info_no ='"+user.getProjectInfoNo()+"' group by gms.wz_id ) info on tid.wz_id=info.wz_id  where mti.bsflag = '0' and mti.project_info_no = '"+user.getProjectInfoNo()+"' group by tid.wz_id, tid.project_info_no, flat.plan_org) where mat_num >0)aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0'  and mto.project_info_no='"+user.getProjectInfoNo()+"' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' where t.stock_num > '0' and t.project_info_no = '"+user.getProjectInfoNo()+"') a  inner join comm_org_information comm on a.org_id=comm.org_id   inner join (select aa.wz_id, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end + case when cc.out_num is null then 0 else cc.out_num  end  ) stock_num, i.coding_code_id, i.wz_name, i.wz_prickie, i.note,  i.wz_price  from (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_invoices mti  inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no =  '"+user.getProjectInfoNo()+"' and mti.if_input = '0'  group by tid.wz_id) aa  left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto  inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.project_info_no = '"+user.getProjectInfoNo()+"' group by tod.wz_id) bb on aa.wz_id = bb.wz_id  left join ( select deta.wz_id,sum(deta.out_num) out_num from gms_mat_out_info info inner join gms_mat_out_info_detail deta on info.out_info_id=deta.out_info_id  where info.bsflag = '0' and info.project_info_no =  '"+user.getProjectInfoNo()+"' and info.out_type='3' and deta.bsflag='0' group by deta.wz_id )  cc on aa.wz_id = cc.wz_id  inner join gms_mat_infomation i  on aa.wz_id = i.wz_id  and i.bsflag = '0')  aa on a.wz_id=aa.wz_id";
		String sql = "";
		String org_id = user.getOrgId();
		String wz_type = "";
		sql += " select * from ( select aa.wz_id, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end ) stock_num, i.coding_code_id, i.wz_name, i.wz_prickie, i.note,  i.wz_price";
		sql += "  from (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_invoices mti  inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0'";
		if (org_id != null
				&& (org_id.equals("C6000000000039")
						|| org_id.equals("C6000000000040")
						|| org_id.equals("C6000000005275")
						|| org_id.equals("C6000000005277")
						|| org_id.equals("C6000000005278")
						|| org_id.equals("C6000000005279") || org_id
							.equals("C6000000005280"))) {
			sql += " and mti.if_center = '1' and mti.org_id='" + org_id + "'";
			wz_type = "11";
		} else {
			sql += " and mti.if_center is null";
			wz_type = "22";
		}
		sql += " and mti.project_info_no =  '" + user.getProjectInfoNo()
				+ "' and mti.if_input = '0'  group by tid.wz_id) aa";
		sql += "  left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto  inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type = '"
				+ wz_type
				+ "'  and (mto.oil_from != '1' or mto.oil_from is null) and mto.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id";
		sql += "  inner join gms_mat_infomation i  on aa.wz_id = i.wz_id  and i.bsflag = '0' ) tt where tt.stock_num>0";

		if (wz_ids != null && !wz_ids.equals("")) {

			sql += " and tt.wz_id in(" + wz_ids + ")";
		}
		sql += " order by tt.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资发放-----------大港
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherRepOut_Dg_FaFang(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String projectInfoNo = user.getProjectInfoNo();
		String org_id = user.getOrgId();
		String wz_ids = reqDTO.getValue("wz_ids");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		String wz_type = "";
		sql = "select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0'";
		if (org_id != null
				&& (org_id.equals("C6000000000039")
						|| org_id.equals("C6000000000040")
						|| org_id.equals("C6000000005275")
						|| org_id.equals("C6000000005277")
						|| org_id.equals("C6000000005278")
						|| org_id.equals("C6000000005279") || org_id
							.equals("C6000000005280"))) {
			sql += " and mti.if_center = '1' and mti.org_id='" + org_id + "'";
			wz_type = "11";
		} else {
			sql += " and mti.if_center is null";
			wz_type = "22";
		}
		sql += " and mti.project_info_no='"
				+ projectInfoNo
				+ "'  group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type = '"
				+ wz_type
				+ "' and (mto.oil_from != '1' or mto.oil_from is null)  and mto.project_info_no='"
				+ projectInfoNo
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' where t.stock_num > '0' and t.project_info_no = '"
				+ projectInfoNo + "') a";

		// String
		// sql="select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,aa.stock_num,a.mat_num,a.out_num,a.org_id,comm.org_abbreviation from (select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.org_id from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no,aa.org_id from (select * from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num)-case when sum(info.infosum) is null then 0 else sum(info.infosum) end mat_num, flat.plan_org org_id from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' inner join gms_mat_demand_plan_flat flat on mti.invoices_id = flat.invoices_id left join (select sum(stock_num) infosum,gms.wz_id from GMS_MAT_TEAMMAT_INFO gms inner join ( select wz_id from gms_mat_out_info g inner join gms_mat_out_info_detail g1 on g.out_info_id=g1.out_info_id where g1.project_info_no ='"+user.getProjectInfoNo()+"' and input_org='专业化' ) g on gms.wz_id=g.wz_id where project_info_no ='"+user.getProjectInfoNo()+"' group by gms.wz_id ) info on tid.wz_id=info.wz_id  where mti.bsflag = '0' and mti.project_info_no = '"+user.getProjectInfoNo()+"' group by tid.wz_id, tid.project_info_no, flat.plan_org) where mat_num >0)aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0'  and mto.project_info_no='"+user.getProjectInfoNo()+"' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' where t.stock_num > '0' and t.project_info_no = '"+user.getProjectInfoNo()+"') a  inner join comm_org_information comm on a.org_id=comm.org_id   inner join (select aa.wz_id, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end + case when cc.out_num is null then 0 else cc.out_num  end  ) stock_num, i.coding_code_id, i.wz_name, i.wz_prickie, i.note,  i.wz_price  from (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_invoices mti  inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no =  '"+user.getProjectInfoNo()+"' and mti.if_input = '0'  group by tid.wz_id) aa  left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto  inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.project_info_no = '"+user.getProjectInfoNo()+"' group by tod.wz_id) bb on aa.wz_id = bb.wz_id  left join ( select deta.wz_id,sum(deta.out_num) out_num from gms_mat_out_info info inner join gms_mat_out_info_detail deta on info.out_info_id=deta.out_info_id  where info.bsflag = '0' and info.project_info_no =  '"+user.getProjectInfoNo()+"' and info.out_type='3' and deta.bsflag='0' group by deta.wz_id )  cc on aa.wz_id = cc.wz_id  inner join gms_mat_infomation i  on aa.wz_id = i.wz_id  and i.bsflag = '0')  aa on a.wz_id=aa.wz_id";
		if (wz_ids != null && !wz_ids.equals("")) {

			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	public ISrvMsg getOtherPurOut(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num, (nvl(a.stock_num,0)*nvl(a.wz_price,0)) total_money from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,t.avg_price wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' and mti.invoices_type='1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a ";
		if (wz_ids != null && !wz_ids.equals("")) {

			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 物资出库页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherGantOutEdit(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");
		String teamOutId = reqDTO.getValue("teamOutId");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' and mti.invoices_type<>'2' and invoices_type<>'1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'  and mto.teammat_out_id <>'"
				+ teamOutId
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id   left join gms_mat_teammat_out_detail od on od.wz_id=t.wz_id and od.bsflag='0' and od.teammat_out_id='"
				+ teamOutId
				+ "' where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a";
		if (wz_ids != null && !wz_ids.equals("")) {
			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	public ISrvMsg getOtherRepOutEdit(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");
		String teamOutId = reqDTO.getValue("teamOutId");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' and mti.invoices_type='2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'  and mto.teammat_out_id <>'"
				+ teamOutId
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id   left join gms_mat_teammat_out_detail od on od.wz_id=t.wz_id and od.bsflag='0' and od.teammat_out_id='"
				+ teamOutId
				+ "' where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a";
		if (wz_ids != null && !wz_ids.equals("")) {
			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	public ISrvMsg getOtherPurOutEdit(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");
		String teamOutId = reqDTO.getValue("teamOutId");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,t.avg_price wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' and mti.invoices_type='1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'  and mto.teammat_out_id <>'"
				+ teamOutId
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id   left join gms_mat_teammat_out_detail od on od.wz_id=t.wz_id and od.bsflag='0' and od.teammat_out_id='"
				+ teamOutId
				+ "' where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a";
		if (wz_ids != null && !wz_ids.equals("")) {
			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	// 选择物资页面初始页面
	public ISrvMsg getSelectRepOut(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = user.getProjectInfoNo();

		String teamOutId = reqDTO.getValue("teamOutId");
		String s_wz_id = reqDTO.getValue("s_wz_id");
		String s_wz_name = reqDTO.getValue("s_wz_name");
		String selectWzId = reqDTO.getValue("selectWzId");
		String wz_type = reqDTO.getValue("wz_type");
		String checkSql = "";
		if (teamOutId != null && !teamOutId.equals("")
				&& !teamOutId.equals("null")) {
			if (wz_type.equals("1")) {
				checkSql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ projectInfoNo
						+ "' and mti.if_input='0' and mti.invoices_type='2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"
						+ projectInfoNo
						+ "' and mto.teammat_out_id <>'"
						+ teamOutId
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ projectInfoNo
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ projectInfoNo + "') a";
				if ((selectWzId != null && !selectWzId.equals(""))
						|| (s_wz_id != null && !s_wz_id.equals(""))
						|| (s_wz_name != null && !s_wz_name.equals(""))) {
					checkSql += " where ";
				}
				if (selectWzId != null && !selectWzId.equals("")) {
					checkSql += " a.wz_id not in (" + selectWzId + ")";
				}
				if (s_wz_id != null && !s_wz_id.equals("")) {
					if (selectWzId != null && !selectWzId.equals("")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_id like '%" + s_wz_id + "%'";
				}
				if (s_wz_name != null && !s_wz_name.equals("")) {
					if ((selectWzId != null && selectWzId != "")
							|| (s_wz_id != null && s_wz_id != "")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_name like '%" + s_wz_name + "%'";
				}

				checkSql += " order by a.wz_id asc";
			} else if (wz_type.equals("2")) {
				checkSql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,t.stock_num,t.avg_price wz_price,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ projectInfoNo
						+ "' and mti.if_input='0' and mti.invoices_type='1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='"
						+ projectInfoNo
						+ "' and mto.teammat_out_id <>'"
						+ teamOutId
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ projectInfoNo
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ projectInfoNo + "') a";
				if ((selectWzId != null && !selectWzId.equals(""))
						|| (s_wz_id != null && !s_wz_id.equals(""))
						|| (s_wz_name != null && !s_wz_name.equals(""))) {
					checkSql += " where ";
				}
				if (selectWzId != null && !selectWzId.equals("")) {
					checkSql += " a.wz_id not in (" + selectWzId + ")";
				}
				if (s_wz_id != null && !s_wz_id.equals("")) {
					if (selectWzId != null && !selectWzId.equals("")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_id like '%" + s_wz_id + "%'";
				}
				if (s_wz_name != null && !s_wz_name.equals("")) {
					if ((selectWzId != null && selectWzId != "")
							|| (s_wz_id != null && s_wz_id != "")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_name like '%" + s_wz_name + "%'";
				}
				checkSql += " order by a.wz_id asc";
			} else {
				checkSql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ projectInfoNo
						+ "' and mti.if_input='0' and mti.invoices_type<>'2' and mti.invoices_type<>'1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"
						+ projectInfoNo
						+ "' and mto.teammat_out_id <>'"
						+ teamOutId
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ projectInfoNo
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ projectInfoNo + "') a";
				if ((selectWzId != null && !selectWzId.equals(""))
						|| (s_wz_id != null && !s_wz_id.equals(""))
						|| (s_wz_name != null && !s_wz_name.equals(""))) {
					checkSql += " where ";
				}
				if (selectWzId != null && !selectWzId.equals("")) {
					checkSql += " a.wz_id not in (" + selectWzId + ")";
				}
				if (s_wz_id != null && !s_wz_id.equals("")) {
					if (selectWzId != null && !selectWzId.equals("")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_id like '%" + s_wz_id + "%'";
				}
				if (s_wz_name != null && !s_wz_name.equals("")) {
					if ((selectWzId != null && selectWzId != "")
							|| (s_wz_id != null && s_wz_id != "")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_name like '%" + s_wz_name + "%'";
				}
				checkSql += " order by a.wz_id asc";
			}
		} else {
			if (wz_type.equals("1")) {
				checkSql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ projectInfoNo
						+ "' and mti.if_input='0' and mti.invoices_type='2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"
						+ projectInfoNo
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ projectInfoNo
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ projectInfoNo + "') a";
				if ((selectWzId != null && !selectWzId.equals(""))
						|| (s_wz_id != null && !s_wz_id.equals(""))
						|| (s_wz_name != null && !s_wz_name.equals(""))) {
					checkSql += " where ";
				}
				if (selectWzId != null && !selectWzId.equals("")) {
					checkSql += " a.wz_id not in (" + selectWzId + ")";
				}
				if (s_wz_id != null && !s_wz_id.equals("")) {
					if (selectWzId != null && !selectWzId.equals("")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_id like '%" + s_wz_id + "%'";
				}
				if (s_wz_name != null && !s_wz_name.equals("")) {
					if ((selectWzId != null && selectWzId != "")
							|| (s_wz_id != null && s_wz_id != "")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_name like '%" + s_wz_name + "%'";
				}
				checkSql += " order by a.wz_id asc";
			} else if (wz_type.equals("2")) {
				checkSql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,t.avg_price wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ projectInfoNo
						+ "' and mti.if_input='0' and mti.invoices_type='1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='"
						+ projectInfoNo
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
						+ projectInfoNo
						+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
						+ projectInfoNo + "') a";
				if ((selectWzId != null && !selectWzId.equals(""))
						|| (s_wz_id != null && !s_wz_id.equals(""))
						|| (s_wz_name != null && !s_wz_name.equals(""))) {
					checkSql += " where ";
				}
				if (selectWzId != null && !selectWzId.equals("")) {
					checkSql += " a.wz_id not in (" + selectWzId + ")";
				}
				if (s_wz_id != null && !s_wz_id.equals("")) {
					if (selectWzId != null && !selectWzId.equals("")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_id like '%" + s_wz_id + "%'";
				}
				if (s_wz_name != null && !s_wz_name.equals("")) {
					if ((selectWzId != null && selectWzId != "")
							|| (s_wz_id != null && s_wz_id != "")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_name like '%" + s_wz_name + "%'";
				}
				checkSql += " order by a.wz_id asc";
			} else {
				checkSql = "select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
						+ projectInfoNo
						+ "' and mti.if_input='0' and mti.invoices_type<>'2' and mti.invoices_type<>'1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"
						+ projectInfoNo
						+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0'   where t.stock_num > '0' and t.project_info_no = '"
						+ projectInfoNo + "') a";
				if ((selectWzId != null && !selectWzId.equals(""))
						|| (s_wz_id != null && !s_wz_id.equals(""))
						|| (s_wz_name != null && !s_wz_name.equals(""))) {
					checkSql += " where ";
				}
				if (selectWzId != null && !selectWzId.equals("")) {
					checkSql += " a.wz_id not in (" + selectWzId + ")";
				}
				if (s_wz_id != null && !s_wz_id.equals("")) {
					if (selectWzId != null && !selectWzId.equals("")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_id like '%" + s_wz_id + "%'";
				}
				if (s_wz_name != null && !s_wz_name.equals("")) {
					if ((selectWzId != null && selectWzId != "")
							|| (s_wz_id != null && s_wz_id != "")) {
						checkSql += " and ";
					}
					checkSql += " a.wz_name like '%" + s_wz_name + "%'";
				}
				checkSql += " order by a.wz_id asc";
			}
		}
		log.info("执行sql:"+checkSql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(checkSql);

		reqMsg.setValue("list", list);

		return reqMsg;
	}

	/**
	 * 其他方式发料单据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOtherGrantOut(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId").toString();
		String[] ids = id.split(",");
		Map map = new HashMap();
		map.put("procure_no", getTableNum3(projectInfoNo));
		map.put("total_money", reqMap.get("total_money"));
		map.put("status", reqMap.get("status"));
		map.put("team_id", reqMap.get("s_apply_team"));
		map.put("device_id", reqMap.get("device_code"));
		map.put("dev_acc_id", reqMap.get("dev_acc_id"));
		map.put("outmat_date", reqMap.get("outmat_date"));
		map.put("use_type", reqMap.get("plan_type"));
		map.put("drawer", reqMap.get("drawer"));
		map.put("storage", reqMap.get("storage"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("note", reqMap.get("note"));
		map.put("out_type", "1");
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("create_date", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("bsflag", "0");
		map.put("WZ_TYPE", reqMap.get("wz_type"));

		// 物资出库单据表操作
		Serializable teammatOutId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_out");
		// 物资领用明细操作
		for (int i = 0; i < ids.length; i++) {
			String getSql = "select * from gms_mat_teammat_info_detail t where t.wz_id='"
					+ ids[i] + "'";
			Map getMap = pureDao.queryRecordBySQL(getSql);
			Map todMap = new HashMap();
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "mat_price_" + ids[i];
			todMap.put("teammat_out_id", teammatOutId.toString());
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num)); // 发放数量
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("mat_sourth", getMap.get("mat_sourth"));
			todMap.put("goods_allocation", getMap.get("goods_allocation"));
			todMap.put("warehouse_number", getMap.get("warehouse_number"));
			todMap.put("plan_no", reqMap.get("device_use_name"));
			todMap.put("bsflag", "0");
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("creator_id", user.getUserId());
			todMap.put("create_date", new Date());
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_out_detail");

			// 台账数据操作
			/*
			 * String sql =
			 * "select * from gms_mat_teammat_info t where t.wz_id = '" + ids[i]
			 * + "'and t.project_info_no='"+projectInfoNo+"'"; Map smap =
			 * ijdbcDao.queryRecordBySQL(sql);
			 * 
			 * double stockNum =
			 * Double.valueOf(smap.get("stockNum").toString()); stockNum -=
			 * Double.valueOf(reqMap.get(mat_num).toString()); String updateSql
			 * = "update gms_mat_teammat_info t set t.stock_num ='" + stockNum +
			 * "' where t.teammat_info_id = '" +
			 * smap.get("teammatInfoId").toString() +
			 * "'and t.project_info_no='"+projectInfoNo+"'";
			 * jdbcDao.executeUpdate(updateSql);
			 */

		}
		return reqMsg;
	}

	/**
	 * 查询出库方式
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getState(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String teammat_out_id = reqDTO.getValue("teammat_out_id");

		String sql = "select * from GMS_MAT_TEAMMAT_OUT o left join gms_device_account t on o.dev_acc_id = t.dev_acc_id where o.teammat_out_id='"
				+ teammat_out_id + "' and o.bsflag='0'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		String sql2 = "select * from GMS_MAT_TEAMMAT_OUT o  left join gms_device_account_dui d on o.dev_acc_id=d.dev_acc_id and d.bsflag='0' where o.teammat_out_id='"
				+ teammat_out_id + "' and o.bsflag='0'";
		Map map2 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql2);
		System.out.println(map);
		reqMsg.setValue("map2", map2);
		reqMsg.setValue("map", map);
		return reqMsg;
	}

	/**
	 * 其他物资出库修改页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOutDetail(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));
		String projectInfoNo = user.getProjectInfoNo();
		String value = reqDTO.getValue("value");
		String wz_type = reqDTO.getValue("wz_type");
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		// String
		// sql="select i.wz_name,i.wz_id,i.wz_prickie,i.wz_price,d.actual_price,d.mat_num,d.total_money,d.out_detail_id from gms_mat_teammat_out_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.teammat_out_id='"+value+"' order by i.wz_id asc";
		if (wz_type != null && wz_type.equals("1")) {
			sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num, a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name,i.wz_id, i.wz_name, i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from gms_mat_teammat_out_detail od left join (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, i.coding_code_id,i.wz_name, i.wz_prickie, i.note, aa.project_info_no from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no = '"
					+ projectInfoNo
					+ "' and mti.if_input = '0' and mti.invoices_type='2' group by tid.wz_id, tid.project_info_no) aa left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type='1' and mto.project_info_no = '"
					+ projectInfoNo
					+ "' and mto.teammat_out_id<>'"
					+ value
					+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') t on t.wz_id=od.wz_id  inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id, s.coding_name from gms_mat_demand_plan_detail d inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
					+ projectInfoNo
					+ "' group by d.wz_id, s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ projectInfoNo
					+ "' and od.teammat_out_id='"
					+ value
					+ "') a order by a.wz_id asc";
		} else if (wz_type != null && wz_type.equals("2")) {
			sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num, a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name,i.wz_id, i.wz_name, i.wz_prickie,t.avg_price wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from gms_mat_teammat_out_detail od left join (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price, i.coding_code_id,i.wz_name, i.wz_prickie, i.note, aa.project_info_no from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no = '"
					+ projectInfoNo
					+ "' and mti.if_input = '0' and mti.invoices_type='1' group by tid.wz_id, tid.project_info_no) aa left join (select tod.wz_id, sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price  from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type='2' and mto.project_info_no = '"
					+ projectInfoNo
					+ "' and mto.teammat_out_id<>'"
					+ value
					+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') t on t.wz_id=od.wz_id  inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id, s.coding_name from gms_mat_demand_plan_detail d inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
					+ projectInfoNo
					+ "' group by d.wz_id, s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ projectInfoNo
					+ "' and od.teammat_out_id='"
					+ value
					+ "') a order by a.wz_id asc";
		} else {
			sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num, a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name,i.wz_id, i.wz_name, i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from gms_mat_teammat_out_detail od left join (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, i.coding_code_id,i.wz_name, i.wz_prickie, i.note, aa.project_info_no from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no = '"
					+ projectInfoNo
					+ "' and mti.if_input = '0' and mti.invoices_type<>'2' and mti.invoices_type<>'1' group by tid.wz_id, tid.project_info_no) aa left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type='0' and mto.project_info_no = '"
					+ projectInfoNo
					+ "' and mto.teammat_out_id<>'"
					+ value
					+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') t on t.wz_id=od.wz_id  inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id, s.coding_name from gms_mat_demand_plan_detail d inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
					+ projectInfoNo
					+ "' group by d.wz_id, s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ projectInfoNo
					+ "' and od.teammat_out_id='"
					+ value
					+ "') a order by a.wz_id asc";
		}
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 其他方式发料单据修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOthEdit(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String teamMatOutId = reqMap.get("teammat_out_id") == null ? ""
				: reqMap.get("teammat_out_id").toString();
		String sql = "delete from gms_mat_teammat_out_detail t where t.teammat_out_id='"
				+ teamMatOutId + "'";
		jdbcDao.executeUpdate(sql);// 删除子表中的信息，重新添加

		Map map = new HashMap();
		map.put("teammat_out_id", reqMap.get("teammat_out_id"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("team_id", reqMap.get("s_apply_team"));
		map.put("device_id", reqMap.get("device_code"));
		map.put("dev_acc_id", reqMap.get("dev_acc_id"));
		map.put("outmat_date", reqMap.get("outmat_date"));
		map.put("use_type", reqMap.get("plan_type"));
		map.put("drawer", reqMap.get("drawer"));
		map.put("storage", reqMap.get("storage"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("note", reqMap.get("note"));
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("bsflag", "0");
		map.put("WZ_TYPE", reqMap.get("wz_type"));

		// 物资出库单据表操作
		Serializable teammatOutId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_out");
		// 物资领用明细操作
		String id = reqDTO.getValue("laborId").toString();
		String[] ids = id.split(",");

		for (int i = 0; i < ids.length; i++) {
			String getSql = "select * from gms_mat_teammat_info_detail t where t.wz_id='"
					+ ids[i] + "'";
			Map getMap = pureDao.queryRecordBySQL(getSql);
			Map todMap = new HashMap();
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "mat_price_" + ids[i];
			todMap.put("teammat_out_id", teammatOutId.toString());
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num)); // 发放数量
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("mat_sourth", getMap.get("mat_sourth"));
			todMap.put("goods_allocation", getMap.get("goods_allocation"));
			todMap.put("warehouse_number", getMap.get("warehouse_number"));
			todMap.put("plan_no", reqMap.get("device_use_name"));
			todMap.put("bsflag", "0");
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("UPDATOR_ID", user.getUserId());
			todMap.put("MODIFI_DATE", new Date());
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_out_detail");
		}

		// for(int i=0;i<ids.length;i++){
		// String outSql =
		// "select d.* from GMS_MAT_TEAMMAT_OUT_DETAIL d where d.out_detail_id='"+ids[i]+"'";
		// Map outMap = ijdbcDao.queryRecordBySQL(outSql);
		//
		// Map todMap = new HashMap();
		// String mat_num="mat_num_"+ids[i];
		// String total_money = "total_money_"+ids[i];
		// String actual_price = "mat_price_"+ids[i];
		// todMap.put("teammat_out_id", teammatOutId.toString());
		// todMap.put("out_detail_id", ids[i]);
		// todMap.put("mat_num", reqMap.get(mat_num)); //发放数量
		// todMap.put("actual_price", reqMap.get(actual_price));
		// todMap.put("total_money", reqMap.get(total_money));
		// todMap.put("project_info_no",projectInfoNo);
		// todMap.put("org_id",user.getOrgId());
		// todMap.put("org_subjection_id", user.getOrgSubjectionId());
		// todMap.put("creator_id",user.getUserId());
		// todMap.put("create_date",new Date());
		// pureDao.saveOrUpdateEntity(todMap,"gms_mat_teammat_out_detail");
		// }

		/*
		 * // 台账数据操作
		 * 
		 * String sql = "select * from gms_mat_teammat_info t where t.wz_id = '"
		 * + outMap.get("wzId") + "'and t.project_info_no='"+projectInfoNo+"'";
		 * Map smap = ijdbcDao.queryRecordBySQL(sql); //台账库存数量 double stockNum =
		 * Double.valueOf(smap.get("stockNum").toString()); //历史出库数量 double
		 * beforNum = Double.valueOf(outMap.get("matNum").toString()); //库存变更
		 * stockNum += beforNum; stockNum -=
		 * Double.valueOf(reqMap.get(mat_num).toString()); String updateSql =
		 * "update gms_mat_teammat_info t set t.stock_num ='" + stockNum +
		 * "' where t.teammat_info_id = '" +
		 * smap.get("teammatInfoId").toString() +
		 * "'and t.project_info_no='"+projectInfoNo+"'";
		 * jdbcDao.executeUpdate(updateSql);
		 */

		return reqMsg;
	}

	/**
	 * 物资手动接收页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAcceptList(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String wz_ids = reqDTO.getValue("wz_ids");
		List<Map> list = new ArrayList<Map>();
		// String sql =
		// "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select i.wz_id,i.wz_name,i.wz_prickie,i.wz_price,sum(d.demand_num) demand_num from gms_mat_demand_plan_detail d inner join gms_mat_demand_plan_bz b on d.submite_number=b.submite_number and b.bsflag='0' inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where d.bsflag='0' and b.project_info_no='"+user.getProjectInfoNo()+"' group by i.wz_id,i.wz_name,i.wz_prickie,i.wz_price) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"+user.getProjectInfoNo()+"' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num";
		String projectType = user.getProjectType();
		String sql = "";
		if (projectType.equals("5000100004000000008")) {
			sql = "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,sum(t.demand_num) demand_num from gms_mat_demand_plan_detail t join gms_mat_demand_plan_bz i on t.submite_number = i.submite_number and i.bsflag='0' and i.if_purchase='1' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.submite_number=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num";
		} else {
			sql = "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,sum(t.demand_num) demand_num from GMS_MAT_DEMAND_PLAN t join gms_mat_demand_plan_invoice i on t.plan_invoice_id=i.plan_invoice_id and i.bsflag='0' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.plan_invoice_id=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num";
		}
		if (wz_ids != null && !wz_ids.equals("")) {
			sql += " and cc.wz_id in (" + wz_ids + ")";
		}
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 物资手动接收页面初始化----------Dg
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAcceptListDg(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String wz_ids = reqDTO.getValue("wz_ids");
		String wz_from = reqDTO.getValue("wz_from");
		String project_info_no = user.getProjectInfoNo();
		String org_id = user.getOrgId();
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		if (wz_from != null && wz_from.equals("1")) {
			sql = "select cc.*, '' plan_flat_id from (select i.wz_id, i.wz_name, i.wz_prickie, i.wz_price, aa.demand_num, i.coding_code_id, case when bb.mat_num is null then 0  else bb.mat_num end mat_num "
					+ "from (select t2.wz_id, sum(t2.demand_num) demand_num from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL t2 on t.submite_number = t2.submite_number "
					+ "inner join common_busi_wf_middle t3 on t3.business_id = t.plan_invoice_id inner join gms_mat_demand_plan_invoice t4 on t.plan_invoice_id = t4.plan_invoice_id "
					+ "where t3.proc_status = '3' and t.bsflag = '0' and (t.if_purchase <> '9' or t.if_purchase is null)  and t4.plan_invoice_type = '物资供应' "
					+ "and project_info_no = '"
					+ project_info_no
					+ "' group by t2.wz_id ) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num "
					+ "from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' "
					+ "where tid.bsflag = '0' and tit.wz_from = '1' and tit.project_info_no = '"
					+ project_info_no
					+ "' and tit.if_center is null group by tid.wz_id) bb "
					+ "on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') cc where demand_num > mat_num";
			if (wz_ids != null && !wz_ids.equals("")) {
				sql += " and cc.wz_id in (" + wz_ids + ")";
			}

		} else if (wz_from.equals("2")) {
			sql = "select cc.*,'' plan_flat_id from (select i.wz_id,i.wz_name,i.wz_prickie,i.wz_price,aa.demand_num,i.coding_code_id, case when bb.mat_num is null then 0 else bb.mat_num end mat_num "
					+ "from (select info.wz_id, sum(info.out_num) demand_num  from gms_mat_out_info t inner join common_busi_wf_middle mid on t.out_info_id = mid.business_id and mid.bsflag = '0'  and mid.proc_status = '3' "
					+ "inner join gms_mat_out_info_detail info on t.out_info_id = info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag = '0' "
					+ "inner join gp_task_project task on t.project_info_no = task.project_info_no where t.out_type = '4'  and t.input_org = '"
					+ project_info_no + "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and ot.wz_type = '11'  and t.org_id = '" + org_id
						+ "'";
			} else {
				sql += " and ot.wz_type = '22' ";
			}
			sql += " group by info.wz_id) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_info_detail tid "
					+ "inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' where tid.bsflag = '0' and tit.wz_from='2'  and tit.project_info_no = '"
					+ project_info_no + "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and tit.if_center='1'  and tit.org_id='" + org_id
						+ "' ";
			} else {
				sql += " and tit.if_center is null ";
			}
			sql += "group by tid.wz_id ) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') cc where demand_num > mat_num";
			if (wz_ids != null && !wz_ids.equals("")) {
				sql += " and cc.wz_id in (" + wz_ids + ")";
			}

		} else {
			sql = "select i.wz_id, i.coding_code_id, i.wz_name, i.wz_prickie ,t.plan_num demand_num,t.plan_num in_num, t.plan_price wz_price, t.plan_flat_id, 0 mat_num from gms_mat_demand_plan_flat t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' where project_info_no = '"
					+ project_info_no
					+ "' and t.plan_org='"
					+ wz_from
					+ "' and plan_flat_type = '0'";
			if (wz_ids != null && !wz_ids.equals("")) {
				sql += " and t.plan_flat_id in (" + wz_ids + ")";
			}
		}

		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 物资手动修改页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAcceptDatasDg(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		String wz_from = reqDTO.getValue("wz_from");
		String project_info_no = user.getProjectInfoNo();
		String org_id = user.getOrgId();
		List<Map> list = new ArrayList<Map>();
		String projectType = user.getProjectType();
		String sql = "";
		if (wz_from != null && wz_from.equals("1")) {
			sql = "select i.wz_id, i.wz_name, i.wz_prickie, tid.teammat_info_idetail_id, tid.mat_num, tid.actual_price, tid.total_money, tid.goods_allocation, tid.warehouse_number, cc.demand_num, nvl(cc.mat_num, 0) - nvl(tid.mat_num, 0) out_num, '' plan_flat_id "
					+ "from gms_mat_teammat_info_detail tid inner join gms_mat_infomation i on tid.wz_id = i.wz_id and i.bsflag = '0'"
					+ "left join  (select i.wz_id, i.wz_name, i.wz_prickie, i.wz_price, aa.demand_num, i.coding_code_id, case when bb.mat_num is null then 0  else bb.mat_num end mat_num "
					+ "from (select t2.wz_id, sum(t2.demand_num) demand_num from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL t2 on t.submite_number = t2.submite_number "
					+ "inner join common_busi_wf_middle t3 on t3.business_id = t.plan_invoice_id inner join gms_mat_demand_plan_invoice t4 on t.plan_invoice_id = t4.plan_invoice_id "
					+ "where t3.proc_status = '3' and t.bsflag = '0' and (t.if_purchase <> '9' or t.if_purchase is null)  and t4.plan_invoice_type = '物资供应' "
					+ "and project_info_no = '"
					+ project_info_no
					+ "' group by t2.wz_id ) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num "
					+ "from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' "
					+ "where tid.bsflag = '0' and tit.wz_from = '1' and tit.project_info_no = '"
					+ project_info_no
					+ "' and tit.if_center is null group by tid.wz_id) bb "
					+ "on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') cc on tid.wz_id=cc.wz_id where tid.bsflag = '0' and tid.invoices_id = '"
					+ id + "'";

		} else if (wz_from.equals("2")) {
			sql = "select i.wz_id, i.wz_name, i.wz_prickie, tid.teammat_info_idetail_id, tid.mat_num, tid.actual_price, tid.total_money, tid.goods_allocation, tid.warehouse_number, cc.demand_num, nvl(cc.mat_num, 0) - nvl(tid.mat_num, 0) out_num,'' plan_flat_id "
					+ "from from gms_mat_teammat_info_detail tid inner join gms_mat_infomation i on tid.wz_id = i.wz_id and i.bsflag = '0' "
					+ "left join (select i.wz_id,i.wz_name,i.wz_prickie,i.wz_price,aa.demand_num,i.coding_code_id, case when bb.mat_num is null then 0 else bb.mat_num end mat_num "
					+ "from (select info.wz_id, sum(info.out_num) demand_num  from gms_mat_out_info t inner join common_busi_wf_middle mid on t.out_info_id = mid.business_id and mid.bsflag = '0'  and mid.proc_status = '3' "
					+ "inner join gms_mat_out_info_detail info on t.out_info_id = info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag = '0' "
					+ "inner join gp_task_project task on t.project_info_no = task.project_info_no where t.out_type = '4'  and t.input_org = '"
					+ project_info_no + "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and ot.wz_type = '11'  and t.org_id = '" + org_id
						+ "'";
			} else {
				sql += " and ot.wz_type = '22' ";
			}
			sql += " group by info.wz_id) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_info_detail tid "
					+ "inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' where tid.bsflag = '0' and tit.wz_from='2'  and tit.project_info_no = '"
					+ project_info_no + "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and tit.if_center='1'  and tit.org_id='" + org_id
						+ "' ";
			} else {
				sql += " and tit.if_center is null ";
			}
			sql += "group by tid.wz_id ) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') cc on tid.wz_id=cc.wz_id where tid.bsflag = '0' and tid.invoices_id = '"
					+ id + "'";

		} else {
			// sql =
			// "select i.wz_id, i.coding_code_id, i.wz_name, i.wz_prickie ,t.plan_num demand_num,t.plan_num in_num, t.plan_price wz_price, t.plan_flat_id, 0 mat_num from gms_mat_demand_plan_flat t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' where project_info_no = '"+project_info_no+"' and t.plan_org='"+wz_from+"' and plan_flat_type = '0'";
		}
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 物资手动修改页面初始化-----弹出页面之后初始化-------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAcceptDatas2Dg(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String org_id = user.getOrgId();
		String id = reqDTO.getValue("ids");
		String wz_ids = reqDTO.getValue("wz_ids");
		String wz_from = reqDTO.getValue("wz_from");
		String project_info_no = user.getProjectInfoNo();
		List<Map> list = new ArrayList<Map>();
		String projectType = user.getProjectType();
		String sql = "";
		if (wz_from != null && wz_from.equals("1")) {
			sql = "select cc.wz_id, cc.wz_name, cc.wz_prickie, tid.mat_num, case when tid.teammat_info_idetail_id is null then cc.wz_price else tid.actual_price end actual_price, tid.total_money, tid.goods_allocation, tid.warehouse_number, cc.demand_num, cc.mat_num out_num, '' plan_flat_id from (select i.wz_id, i.wz_name, i.wz_prickie, i.wz_price, aa.demand_num, i.coding_code_id, case when bb.mat_num is null then 0  else bb.mat_num end mat_num "
					+ "from (select t2.wz_id, sum(t2.demand_num) demand_num from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL t2 on t.submite_number = t2.submite_number "
					+ "inner join common_busi_wf_middle t3 on t3.business_id = t.plan_invoice_id inner join gms_mat_demand_plan_invoice t4 on t.plan_invoice_id = t4.plan_invoice_id "
					+ "where t3.proc_status = '3' and t.bsflag = '0' and (t.if_purchase <> '9' or t.if_purchase is null)  and t4.plan_invoice_type = '物资供应' "
					+ "and project_info_no = '"
					+ project_info_no
					+ "' group by t2.wz_id ) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num "
					+ "from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' "
					+ "where tid.bsflag = '0' and tit.wz_from = '1' and tit.project_info_no = '"
					+ project_info_no
					+ "' and tit.if_center is null and tid.invoices_id <> '"
					+ id
					+ "' group by tid.wz_id) bb "
					+ "on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') cc left join gms_mat_teammat_info_detail tid on tid.wz_id = cc.wz_id and tid.bsflag = '0' and tid.invoices_id = '"
					+ id + "' where  cc.demand_num > cc.mat_num";
			if (wz_ids != null && !wz_ids.equals("")) {
				sql += " and cc.wz_id in (" + wz_ids + ")";
			}

		} else if (wz_from.equals("2")) {
			sql = "select cc.wz_id, cc.wz_name, cc.wz_prickie, tid.mat_num, case when tid.teammat_info_idetail_id is null then cc.wz_price else tid.actual_price end actual_price, tid.total_money, tid.goods_allocation, tid.warehouse_number, cc.demand_num, cc.mat_num out_num,'' plan_flat_id from (select i.wz_id,i.wz_name,i.wz_prickie,i.wz_price,aa.demand_num,i.coding_code_id, case when bb.mat_num is null then 0 else bb.mat_num end mat_num "
					+ "from (select info.wz_id, sum(info.out_num) demand_num  from gms_mat_out_info t inner join common_busi_wf_middle mid on t.out_info_id = mid.business_id and mid.bsflag = '0'  and mid.proc_status = '3' "
					+ "inner join gms_mat_out_info_detail info on t.out_info_id = info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag = '0' "
					+ "inner join gp_task_project task on t.project_info_no = task.project_info_no where t.out_type = '4'  and t.input_org = '"
					+ project_info_no + "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and ot.wz_type = '11'  and t.org_id = '" + org_id
						+ "'";
			} else {
				sql += " and ot.wz_type = '22' ";
			}
			sql += " group by info.wz_id) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_info_detail tid "
					+ "inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' where tid.bsflag = '0' and tit.wz_from='2' and tid.invoices_id <> '"
					+ id
					+ "'  and tit.project_info_no = '"
					+ project_info_no
					+ "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and tit.if_center='1'  and tit.org_id='" + org_id
						+ "' ";
			} else {
				sql += " and tit.if_center is null ";
			}
			sql += "group by tid.wz_id ) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') cc left join gms_mat_teammat_info_detail tid on tid.wz_id = cc.wz_id and tid.bsflag = '0' and tid.invoices_id = '"
					+ id + "' where  cc.demand_num > cc.mat_num";
			if (wz_ids != null && !wz_ids.equals("")) {
				sql += " and cc.wz_id in (" + wz_ids + ")";
			}

		} else {
			sql = "select i.wz_id, i.coding_code_id, i.wz_name, i.wz_prickie ,t.plan_num demand_num,t.plan_num in_num, t.plan_price wz_price, t.plan_flat_id, 0 mat_num from gms_mat_demand_plan_flat t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' where project_info_no = '"
					+ project_info_no
					+ "' and t.plan_org='"
					+ wz_from
					+ "' and plan_flat_type = '0'";
			if (wz_ids != null && !wz_ids.equals("")) {
				sql += " and t.plan_flat_id in (" + wz_ids + ")";
			}
		}
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 物资手动验收初始化 *
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSelectAcceptList(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String s_coding_code = reqDTO.getValue("s_coding_code");
		String s_wz_name = reqDTO.getValue("s_wz_name");
		String selectWzId = reqDTO.getValue("selectWzId");
		String invoices_id = reqDTO.getValue("invoices_id");

		String sql = "";
		if (invoices_id != null && !invoices_id.equals("")
				&& !invoices_id.equals("null")) {
			sql = "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,(case when aa.wz_price  is null  then (select round(avg(plans.buy_num),2) from gms_mat_demand_plan  plans where plans.wz_id=aa.wz_id ) when aa.wz_price is not null then aa.wz_price  end) as wz_price,aa.demand_num,aa.coding_code_id,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id,sum(t.demand_num) demand_num from GMS_MAT_DEMAND_PLAN t join gms_mat_demand_plan_invoice i on t.plan_invoice_id=i.plan_invoice_id and i.bsflag='0' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.plan_invoice_id=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' and tit.invoices_id<>'"
					+ invoices_id
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num";

			if (selectWzId != null && !selectWzId.equals("")) {
				sql += " and  cc.wz_id not in (" + selectWzId + ")";
			}
			if (s_coding_code != null && !s_coding_code.equals("")) {
				sql += " and cc.coding_code_id like '%" + s_coding_code + "%'";
			}
			if (s_wz_name != null && !s_wz_name.equals("")) {
				sql += " and  cc.wz_name like '%" + s_wz_name + "%'";
			}
		} else {
			sql = "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,(case when aa.wz_price  is null  then (select round(avg(plans.buy_num),2) from gms_mat_demand_plan  plans where plans.wz_id=aa.wz_id ) when aa.wz_price is not null then aa.wz_price  end) as wz_price,aa.demand_num,aa.coding_code_id,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id,sum(t.demand_num) demand_num from GMS_MAT_DEMAND_PLAN t join gms_mat_demand_plan_invoice i on t.plan_invoice_id=i.plan_invoice_id and i.bsflag='0' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.plan_invoice_id=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num";

			if (selectWzId != null && !selectWzId.equals("")) {
				sql += " and  cc.wz_id not in (" + selectWzId + ")";
			}
			if (s_coding_code != null && !s_coding_code.equals("")) {
				sql += " and cc.coding_code_id like '%" + s_coding_code + "%'";
			}
			if (s_wz_name != null && !s_wz_name.equals("")) {
				sql += " and  cc.wz_name like '%" + s_wz_name + "%'";
			}
		}

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 物资手动验收初始化------------大港 *
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSelectAcceptListDg(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String s_coding_code = reqDTO.getValue("s_coding_code");
		String s_wz_name = reqDTO.getValue("s_wz_name");
		String selectWzId = reqDTO.getValue("selectWzId");
		String invoices_id = reqDTO.getValue("invoices_id");
		String wz_from = reqDTO.getValue("wz_from");
		String project_info_no = user.getProjectInfoNo();
		String org_id = user.getOrgId();
		String sql = "";

		if (wz_from != null && wz_from.equals("1")) {
			sql = "select cc.*, '' plan_flat_id from (select i.wz_id, i.wz_name, i.wz_prickie, i.wz_price, aa.demand_num, i.coding_code_id, case when bb.mat_num is null then 0  else bb.mat_num end mat_num "
					+ "from (select t2.wz_id, sum(t2.demand_num) demand_num from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL t2 on t.submite_number = t2.submite_number "
					+ "inner join common_busi_wf_middle t3 on t3.business_id = t.plan_invoice_id inner join gms_mat_demand_plan_invoice t4 on t.plan_invoice_id = t4.plan_invoice_id "
					+ "where t3.proc_status = '3' and t.bsflag = '0' and (t.if_purchase <> '9' or t.if_purchase is null)  and t4.plan_invoice_type = '物资供应' "
					+ "and project_info_no = '"
					+ project_info_no
					+ "' group by t2.wz_id ) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num "
					+ "from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' "
					+ "where tid.bsflag = '0' and tit.wz_from = '1' and tit.project_info_no = '"
					+ project_info_no
					+ "' and tit.if_center is null group by tid.wz_id) bb "
					+ "on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') cc where demand_num > mat_num";
			if (selectWzId != null && !selectWzId.equals("")) {
				sql += " and  cc.wz_id not in (" + selectWzId + ")";
			}
			if (s_coding_code != null && !s_coding_code.equals("")) {
				sql += " and cc.coding_code_id like '%" + s_coding_code + "%'";
			}
			if (s_wz_name != null && !s_wz_name.equals("")) {
				sql += " and  cc.wz_name like '%" + s_wz_name + "%'";
			}
		} else if (wz_from.equals("2")) {
			sql = "select cc.*,'' plan_flat_id from (select i.wz_id,i.wz_name,i.wz_prickie,i.wz_price,aa.demand_num,i.coding_code_id, case when bb.mat_num is null then 0 else bb.mat_num end mat_num "
					+ "from (select info.wz_id, sum(info.out_num) demand_num  from gms_mat_out_info t inner join common_busi_wf_middle mid on t.out_info_id = mid.business_id and mid.bsflag = '0'  and mid.proc_status = '3' "
					+ "inner join gms_mat_out_info_detail info on t.out_info_id = info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag = '0' "
					+ "inner join gp_task_project task on t.project_info_no = task.project_info_no where t.out_type = '4'  and t.input_org = '"
					+ project_info_no + "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and ot.wz_type = '11'  and t.org_id = '" + org_id
						+ "'";
			} else {
				sql += " and ot.wz_type = '22' ";
			}
			sql += " group by info.wz_id) aa left join (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_info_detail tid "
					+ "inner join gms_mat_teammat_invoices tit on tid.invoices_id = tit.invoices_id and tit.bsflag = '0' where tid.bsflag = '0' and tit.wz_from='2'  and tit.project_info_no = '"
					+ project_info_no + "'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and tit.if_center='1'  and tit.org_id='" + org_id
						+ "' ";
			} else {
				sql += " and tit.if_center is null ";
			}
			sql += "group by tid.wz_id ) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') cc where demand_num > mat_num";
			if (selectWzId != null && !selectWzId.equals("")) {
				sql += " and  cc.wz_id not in (" + selectWzId + ")";
			}
			if (s_coding_code != null && !s_coding_code.equals("")) {
				sql += " and cc.coding_code_id like '%" + s_coding_code + "%'";
			}
			if (s_wz_name != null && !s_wz_name.equals("")) {
				sql += " and  cc.wz_name like '%" + s_wz_name + "%'";
			}
		} else {
			sql = "select i.wz_id, i.coding_code_id, i.wz_name, i.wz_prickie ,t.plan_num demand_num, t.plan_price wz_price, t.plan_flat_id, 0 mat_num from gms_mat_demand_plan_flat t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' where project_info_no = '"
					+ project_info_no
					+ "' and t.plan_org='"
					+ wz_from
					+ "' and plan_flat_type = '0'";
			if (selectWzId != null && !selectWzId.equals("")) {
				sql += " and  t.plan_flat_id not in (" + selectWzId + ")";
			}
			if (s_coding_code != null && !s_coding_code.equals("")) {
				sql += " and i.coding_code_id like '%" + s_coding_code + "%'";
			}
			if (s_wz_name != null && !s_wz_name.equals("")) {
				sql += " and i.wz_name like '%" + s_wz_name + "%'";
			}
		}

		/*
		 * 
		 * 
		 * String sql = "";
		 * if(invoices_id!=null&&!invoices_id.equals("")&&!invoices_id
		 * .equals("null")){ sql =
		 * "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,aa.coding_code_id,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id,sum(t.demand_num) demand_num from GMS_MAT_DEMAND_PLAN t join gms_mat_demand_plan_invoice i on t.plan_invoice_id=i.plan_invoice_id and i.bsflag='0' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.plan_invoice_id=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
		 * +user.getProjectInfoNo()+
		 * "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
		 * +user.getProjectInfoNo()+"' and tit.invoices_id<>'"+invoices_id+
		 * "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num"
		 * ;
		 * 
		 * if(selectWzId!=null&&!selectWzId.equals("")){ sql +=
		 * " and  cc.wz_id not in ("+selectWzId+")"; }
		 * if(s_coding_code!=null&&!s_coding_code.equals("")){ sql +=
		 * " and cc.coding_code_id like '%"+s_coding_code+"%'"; }
		 * if(s_wz_name!=null&&!s_wz_name.equals("")){ sql +=
		 * " and  cc.wz_name like '%"+s_wz_name+"%'"; } }else{ sql =
		 * "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,aa.coding_code_id,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id,sum(t.demand_num) demand_num from GMS_MAT_DEMAND_PLAN t join gms_mat_demand_plan_invoice i on t.plan_invoice_id=i.plan_invoice_id and i.bsflag='0' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.plan_invoice_id=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
		 * +user.getProjectInfoNo()+
		 * "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
		 * +user.getProjectInfoNo()+
		 * "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num"
		 * ;
		 * 
		 * if(selectWzId!=null&&!selectWzId.equals("")){ sql +=
		 * " and  cc.wz_id not in ("+selectWzId+")"; }
		 * if(s_coding_code!=null&&!s_coding_code.equals("")){ sql +=
		 * " and cc.coding_code_id like '%"+s_coding_code+"%'"; }
		 * if(s_wz_name!=null&&!s_wz_name.equals("")){ sql +=
		 * " and  cc.wz_name like '%"+s_wz_name+"%'"; } }
		 */
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 物资手动验收初始化----井中 *
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSelectAcceptListJZ(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String s_coding_code = reqDTO.getValue("s_coding_code");
		String s_wz_name = reqDTO.getValue("s_wz_name");
		String selectWzId = reqDTO.getValue("selectWzId");
		String invoices_id = reqDTO.getValue("invoices_id");

		String sql = "";
		if (invoices_id != null && !invoices_id.equals("")
				&& !invoices_id.equals("null")) {
			sql = "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,aa.coding_code_id,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id,sum(t.demand_num) demand_num from gms_mat_demand_plan_detail t join gms_mat_demand_plan_bz i on t.submite_number = i.submite_number and i.bsflag='0'  and i.if_purchase='1' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.submite_number=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' and tit.invoices_id<>'"
					+ invoices_id
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num";

			if (selectWzId != null && !selectWzId.equals("")) {
				sql += " and  cc.wz_id not in (" + selectWzId + ")";
			}
			if (s_coding_code != null && !s_coding_code.equals("")) {
				sql += " and cc.coding_code_id like '%" + s_coding_code + "%'";
			}
			if (s_wz_name != null && !s_wz_name.equals("")) {
				sql += " and  cc.wz_name like '%" + s_wz_name + "%'";
			}
		} else {
			sql = "select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,aa.coding_code_id,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id,sum(t.demand_num) demand_num from gms_mat_demand_plan_detail t join gms_mat_demand_plan_bz i on t.submite_number = i.submite_number and i.bsflag='0'  and i.if_purchase='1' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.submite_number=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,m.coding_code_id) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc where cc.demand_num>mat_num";

			if (selectWzId != null && !selectWzId.equals("")) {
				sql += " and  cc.wz_id not in (" + selectWzId + ")";
			}
			if (s_coding_code != null && !s_coding_code.equals("")) {
				sql += " and cc.coding_code_id like '%" + s_coding_code + "%'";
			}
			if (s_wz_name != null && !s_wz_name.equals("")) {
				sql += " and  cc.wz_name like '%" + s_wz_name + "%'";
			}
		}

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 手动验收物资保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAcceptLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("id").toString();
		String[] ids = id.split(",");
		Map map = new HashMap();

		// 物资入库单据表操作
		map.put("invoices_no", this.getTableNum2(projectInfoNo, "5"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("input_date", reqMap.get("input_date"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("invoices_type", "5");
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("create_date", new Date());
		map.put("bsflag", "0");
		map.put("if_input", "0");
		Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_invoices");
		// 物资入库明细操作
		for (int i = 0; i < ids.length; i++) {

			Map todMap = new HashMap();
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "actual_price_" + ids[i];
			String warehouse_number = "warehouse_number_" + ids[i];
			String goods_allocation = "goods_allocation_" + ids[i];

			todMap.put("invoices_id", invoicesId);
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("warehouse_number", reqMap.get(warehouse_number));
			todMap.put("goods_allocation", reqMap.get(goods_allocation));
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("CREATOR_ID", user.getUserId());
			todMap.put("create_date", new Date());
			todMap.put("bsflag", "0");
			todMap.put("if_accept", "0");
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_info_detail");

			// 台账数据操作
			/*
			 * String sql =
			 * "select * from gms_mat_teammat_info t where t.wz_id = '" + ids[i]
			 * + "'and t.project_info_no='"+projectInfoNo+"'"; Map smap =
			 * ijdbcDao.queryRecordBySQL(sql); //台账库存数量 double stockNum;
			 * if(smap==null){ Map teamMap = new HashMap(); teamMap.put("wz_id",
			 * ids[i]); teamMap.put("stock_num", reqMap.get(mat_num));
			 * teamMap.put("actual_price", reqMap.get(actual_price));
			 * teamMap.put("project_info_no", projectInfoNo);
			 * teamMap.put("org_id",user.getOrgId());
			 * teamMap.put("org_subjection_id", user.getOrgSubjectionId());
			 * teamMap.put("CREATOR_ID", user.getUserId());
			 * teamMap.put("create_date", new Date()); teamMap.put("bsflag",
			 * "0"); teamMap.put("is_recyclemat", "1");
			 * pureDao.saveOrUpdateEntity(teamMap,"gms_mat_teammat_info"); }
			 * else{ stockNum = Double.valueOf(smap.get("stockNum").toString());
			 * stockNum += Double.valueOf(reqMap.get(mat_num).toString());
			 * String updateSql =
			 * "update gms_mat_teammat_info t set t.stock_num ='" + stockNum +
			 * "' where t.teammat_info_id = '" +
			 * smap.get("teammatInfoId").toString() +
			 * "'and t.project_info_no='"+projectInfoNo+"'";
			 * jdbcDao.executeUpdate(updateSql); } String matSql =
			 * "update gms_mat_infomation t set t.wz_price='"
			 * +reqMap.get(actual_price)+"' where t.wz_id='"+ids[i]+"'";
			 * jdbcDao.executeUpdate(matSql);
			 */
		}
		return reqMsg;
	}

	/**
	 * 手动验收物资修改查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAcceptDatas(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String sql = "select * from gms_mat_teammat_invoices t where t.project_info_no='"
				+ user.getProjectInfoNo()
				+ "'and t.invoices_id='"
				+ id
				+ "'and t.bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 物资手动修改页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAcceptDatas(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		List<Map> list = new ArrayList<Map>();
		String projectType = user.getProjectType();
		String sql = "";
		if (projectType.equals("5000100004000000008")) {
			sql = "select i.wz_id,i.wz_name,i.wz_prickie,tid.teammat_info_idetail_id,tid.mat_num,tid.actual_price,tid.total_money,tid.goods_allocation,tid.warehouse_number,cc.demand_num,nvl(cc.mat_num,0)-nvl(tid.mat_num,0) out_num from gms_mat_teammat_info_detail tid inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' left join (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,sum(t.demand_num) demand_num from gms_mat_demand_plan_detail t join gms_mat_demand_plan_bz i on t.submite_number = i.submite_number and i.bsflag='0'  and i.if_purchase='1' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.submite_number=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc on tid.wz_id = cc.wz_id where tid.bsflag='0' and tid.invoices_id='"
					+ id + "'";
		} else {
			sql = "select i.wz_id,i.wz_name,i.wz_prickie,tid.teammat_info_idetail_id,tid.mat_num,tid.actual_price,tid.total_money,tid.goods_allocation,tid.warehouse_number,cc.demand_num,nvl(cc.mat_num,0)-nvl(tid.mat_num,0) out_num from gms_mat_teammat_info_detail tid inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' left join (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,sum(t.demand_num) demand_num from GMS_MAT_DEMAND_PLAN t join gms_mat_demand_plan_invoice i on t.plan_invoice_id=i.plan_invoice_id and i.bsflag='0' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.plan_invoice_id=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc on tid.wz_id = cc.wz_id where tid.bsflag='0' and tid.invoices_id='"
					+ id + "'";
		}
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 物资手动修改页面初始化-----弹出页面之后初始化-------lx
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAcceptDatas2(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		String wz_ids = reqDTO.getValue("wz_ids");
		List<Map> list = new ArrayList<Map>();
		String projectType = user.getProjectType();
		String sql = "";
		if (projectType.equals("5000100004000000008")) {
			sql = "select cc.wz_id,cc.wz_name,cc.wz_prickie,tid.mat_num, case when tid.teammat_info_idetail_id is null then cc.wz_price else tid.actual_price end actual_price,tid.total_money,tid.goods_allocation,tid.warehouse_number,cc.demand_num,cc.mat_num out_num from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,sum(t.demand_num) demand_num from gms_mat_demand_plan_detail t join gms_mat_demand_plan_bz i on t.submite_number = i.submite_number and i.bsflag='0' and i.if_purchase='1' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.submite_number=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' and tid.invoices_id<>'"
					+ id
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc left join gms_mat_teammat_info_detail tid on tid.wz_id = cc.wz_id and tid.bsflag='0' and tid.invoices_id='"
					+ id + "' where cc.demand_num > cc.mat_num ";
		} else {
			sql = "select cc.wz_id,cc.wz_name,cc.wz_prickie,tid.mat_num, case when tid.teammat_info_idetail_id is null then cc.wz_price else tid.actual_price end actual_price,tid.total_money,tid.goods_allocation,tid.warehouse_number,cc.demand_num,cc.mat_num out_num from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.wz_price,aa.demand_num,case when bb.mat_num is null then 0 else bb.mat_num end mat_num from (select m.wz_id,m.wz_name,m.wz_prickie,m.wz_price,sum(t.demand_num) demand_num from GMS_MAT_DEMAND_PLAN t join gms_mat_demand_plan_invoice i on t.plan_invoice_id=i.plan_invoice_id and i.bsflag='0' inner join gms_mat_infomation m on t.wz_id=m.wz_id and m.bsflag='0' join common_busi_wf_middle w on i.plan_invoice_id=w.business_id and  w.bsflag='0' where t.bsflag='0' and w.proc_status='3' and i.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by m.wz_id,m.wz_name,m.wz_prickie,m.wz_price) aa left join(select i.wz_id,sum(tid.mat_num)mat_num from gms_mat_teammat_info_detail tid inner join gms_mat_teammat_invoices tit on tid.invoices_id=tit.invoices_id and tit.bsflag='0' inner join gms_mat_infomation i on tid.wz_id=i.wz_id and i.bsflag='0' where tid.bsflag='0' and tit.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' and tid.invoices_id<>'"
					+ id
					+ "' group by i.wz_id) bb on aa.wz_id = bb.wz_id  order by aa.wz_id) cc left join gms_mat_teammat_info_detail tid on tid.wz_id = cc.wz_id and tid.bsflag='0' and tid.invoices_id='"
					+ id + "' where cc.demand_num > cc.mat_num ";
		}
		if (wz_ids != null && !wz_ids.equals("")) {
			sql += " and cc.wz_id in (" + wz_ids + ")";
		}
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * 手动验收物资保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg EditAcceptLedger(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("id").toString();
		String[] ids = id.split(",");
		Map map = new HashMap();

		// 物资入库单据表操作
		map.put("invoices_id", reqMap.get("invoices_id"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("input_date", reqMap.get("input_date"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("total_money", reqMap.get("total_money"));
		Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_invoices");

		String deleteSql = "delete from gms_mat_teammat_info_detail where invoices_id='"
				+ invoicesId + "'";
		jdbcDao.executeUpdate(deleteSql);

		// 物资入库明细操作
		for (int i = 0; i < ids.length; i++) {

			Map todMap = new HashMap();
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "actual_price_" + ids[i];
			String warehouse_number = "warehouse_number_" + ids[i];
			String goods_allocation = "goods_allocation_" + ids[i];

			// todMap.put("teammat_info_idetail_id", ids[i]);
			todMap.put("invoices_id", invoicesId);
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("warehouse_number", reqMap.get(warehouse_number));
			todMap.put("goods_allocation", reqMap.get(goods_allocation));
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("CREATOR_ID", user.getUserId());
			todMap.put("create_date", new Date());
			todMap.put("bsflag", "0");
			todMap.put("if_accept", "0");
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_info_detail");
			// 查询物资编码
			// String querySql =
			// "select wz_id from gms_mat_teammat_info_detail where teammat_info_idetail_id = '"+ids[i]+"'";
			// Map getMap = pureDao.queryRecordBySQL(querySql);
			// 更新单价
			String matSql = "update gms_mat_infomation t set t.wz_price='"
					+ reqMap.get(actual_price) + "' where t.wz_id='" + ids[i]
					+ "'";
			jdbcDao.executeUpdate(matSql);
		}
		return reqMsg;
	}

	/**
	 * 手动验收物资删除
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteAcceptDatas(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		// String outSql =
		// "update gms_mat_teammat_info out set out.bsflag='1' where out.teammat_info_id='"+id+"'";
		// String detailSql =
		// "update gms_mat_teammat_info_detail out set out.bsflag='1' where out.teammat_info_idetail_id='"+id+"'";
		String outSql = "update GMS_MAT_TEAMMAT_INVOICES out set out.bsflag='1' where out.invoices_id='"
				+ id + "'";
		String detailSql = "update gms_mat_teammat_info_detail out set out.bsflag='1' where out.invoices_id='"
				+ id + "'";
		jdbcDao.executeUpdate(outSql);
		jdbcDao.executeUpdate(detailSql);
		return reqMsg;
	}

	/**
	 * 油料添加页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevDatas(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String id = reqDTO.getValue("ids");
		String outmat_date = reqDTO.getValue("outmat_date");
		List<Map> list = new ArrayList<Map>();
		String sql = "select dui.dev_acc_id,dui.dev_name,dui.self_num,dui.license_num,dui.asset_coding,dui.dev_sign,oprtbl.operator_name from gms_device_account_dui dui  left join (select device_account_id,operator_name from ( "
				+ " select tmp.device_account_id,tmp.operator_name,row_number() over(partition by device_account_id order by length(operator_name) desc ) as seq"
				+ " from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name"
				+ " from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id where dui.project_info_id='"
				+ user.getProjectInfoNo()
				+ "' and (dui.dev_type like 'S0601%' or dui.dev_type like 'S0622%' or dui.dev_type like 'S0623%'"
				+ "or dui.dev_type like 'S07010101%' or dui.dev_type like 'S070301%' "
				+ "or dui.dev_type like 'S0801%' or dui.dev_type like 'S0802%' or dui.dev_type like 'S0803%' or dui.dev_type like 'S0804%' or dui.dev_type like 'S0808%' "
				+ "or dui.dev_type like 'S080503%' or dui.dev_type like 'S080504%' or dui.dev_type like 'S080601%' or dui.dev_type like 'S080604%' "
				+ "or dui.dev_type like 'S080607%' or dui.dev_type like 'S090101%') and (dui.actual_out_time>=to_date('"
				+ outmat_date
				+ "','yyyy-MM-dd') or dui.actual_out_time is null) order by dui.dev_type,dui.actual_in_time desc";
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}
	
	/**
	 * 多项目油料添加页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevAccDatas(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String ids = reqDTO.getValue("ids");
		String id ="";
		if(ids != null && !"".equals(ids)){
			id = ids.substring(0,ids.length()-1);
		}
		List<Map> list = new ArrayList<Map>();
		StringBuffer sb = new StringBuffer();
		sb.append(" select acc.dev_acc_id,acc.dev_name,acc.self_num,acc.license_num,acc.asset_coding,acc.dev_sign,acc.dev_acc_id,eo.operator_name  ")
          .append("from gms_device_account acc left join gms_device_equipment_operator eo on eo.device_account_id = dev_acc_id where acc.bsflag='0' and dev_acc_id in (")
          .append(id).append(")");
		list = pureDao.queryRecords(sb.toString());
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	// 油料消耗修改页面
	public ISrvMsg getDevDatasEdit(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String teammat_out_id = reqDTO.getValue("teammat_out_id");
		List<Map> list = new ArrayList<Map>();
		String sql = "select d.out_detail_id,dui.dev_name,dui.self_num,dui.license_num,i.wz_prickie,d.oil_num,d.mat_num,d.total_money,dui.dev_sign,"
				+ "oprtbl.operator_name from GMS_MAT_TEAMMAT_OUT t inner join  (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i "
				+ "on d.wz_id=i.wz_id and i.bsflag='0' inner join gms_device_account_dui dui on d.dev_acc_id=dui.dev_acc_id and dui.bsflag='0'  "
				+ "left join (select device_account_id,operator_name from "
				+ "( select tmp.device_account_id,tmp.operator_name,row_number() over(partition by device_account_id order by length(operator_name) desc ) as seq "
				+ "from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name "
				+ "from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id) "
				+ "on t.teammat_out_id =d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='"
				+ teammat_out_id + "' " + "and t.bsflag='0'";
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}
	
	// 多项目油料消耗修改页面
	public ISrvMsg getDevAccDatasEdit(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String isRecyclemat = reqDTO.getValue("isRecyclemat");
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String teammat_out_id = reqDTO.getValue("teammat_out_id");
		List<Map> list = new ArrayList<Map>();
		String sql = "select d.out_detail_id,dui.dev_name,dui.self_num,dui.license_num,i.wz_prickie,d.oil_num,d.mat_num,d.total_money,dui.dev_sign,"
				+ "oprtbl.operator_name from GMS_MAT_TEAMMAT_OUT t inner join  (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i "
				+ "on d.wz_id=i.wz_id and i.bsflag='0' inner join gms_device_account dui on d.dev_acc_id=dui.dev_acc_id and dui.bsflag='0'  "
				+ "left join (select device_account_id,operator_name from "
				+ "( select tmp.device_account_id,tmp.operator_name,row_number() over(partition by device_account_id order by length(operator_name) desc ) as seq "
				+ "from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name "
				+ "from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id) "
				+ "on t.teammat_out_id =d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='"
				+ teammat_out_id + "' " + "and t.bsflag='0'";
		list = pureDao.queryRecords(sql);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", list.size());
		reqMsg.setValue("pageSize", list.size());
		return reqMsg;
	}

	/**
	 * excel物资发放导入新增页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExcelDatas(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");
		String errorMessage = "";
		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		page.setPageSize(500);

		String id = reqDTO.getValue("obj");
		System.out.println(id);
		String[] ids = id.split(",");
		System.out.println(ids);
		List<Map> list = new ArrayList<Map>();
		for (int i = 0; i < ids.length; i++) {
			String[] data = ids[i].split("@");
			String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from(select s.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and tid.wz_id='"
					+ data[0]
					+ "' and mti.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and tod.wz_id='"
					+ data[0]
					+ "' and mto.project_info_no='"
					+ user.getProjectInfoNo()
					+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join(gms_mat_demand_plan_detail d inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number and b.bsflag='0' and b.project_info_no='"
					+ user.getProjectInfoNo()
					+ "') on t.wz_id = d.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ user.getProjectInfoNo() + "') a order by a.wz_id asc";
			Map map = pureDao.queryRecordBySQL(sql);
			if (map == null) {
				int n = 1;
				n += i + 1;
				errorMessage += "第" + n + "行物资库中不存在此项物资！";
				reqMsg.setValue("errorMessage", errorMessage);
			} else {
				// map.put("wz_price", data[1]);
				map.put("demand_num", data[1]);
				map.put("actual_price", data[3]);
				list.add(map);
			}
		}
		System.out.println(list);
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);
		return reqMsg;
	}

	/**
	 * 库存油料
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOilNum(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String wz_id = reqDTO.getValue("wz_id");

		String sql = "";
		String wz_type = "";
		String org_subjection_id = user.getOrgSubjectionId();
		String org_id = user.getOrgId();
		if (org_subjection_id.startsWith("C105007")) {
			sql += " select aa.wz_id, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end ) stock_num, i.coding_code_id, i.wz_name, i.wz_prickie, i.note,  i.wz_price";
			sql += "  from (select tid.wz_id, sum(tid.mat_num) mat_num  from gms_mat_teammat_invoices mti  inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and mti.if_center = '1' and mti.org_id='" + org_id
						+ "'";
				wz_type = "11";
			} else {
				sql += " and mti.if_center is null";
				wz_type = "22";
			}
			sql += " and mti.project_info_no =  '" + projectInfoNo
					+ "' and mti.if_input = '0'  group by tid.wz_id) aa";
			sql += "  left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto  inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type = '"
					+ wz_type
					+ "'  and (mto.oil_from != '1' or mto.oil_from is null) and mto.project_info_no = '"
					+ projectInfoNo
					+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id";
			sql += "  inner join gms_mat_infomation i  on aa.wz_id = i.wz_id  and i.bsflag = '0'";
		} else {
			sql = "select a.coding_code_id, sum(a.stock_num) as stock_num from(select dd.coding_name, i.wz_id,i.coding_code_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
					+ projectInfoNo
					+ "' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type = '0' and mto.project_info_no='"
					+ projectInfoNo
					+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
					+ projectInfoNo
					+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ projectInfoNo
					+ "'and (i.coding_code_id like'07030102%' or i.coding_code_id like '07030301%' or i.coding_code_id like '07030101%')) a group by a.coding_code_id order by a.coding_code_id desc";
		}

		List list = ijdbcDao.queryRecords(sql);

		String sql2 = "select * from gms_mat_infomation where wz_id='" + wz_id
				+ "' and bsflag='0'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql2);

		reqMsg.setValue("map", map);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 选择油料
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg selectOilType(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String oil_type = reqDTO.getValue("oil_type");
		List list = new ArrayList();
		if (oil_type != null) {
			if (oil_type.equals("1")) {
				String sql = "select t.wz_id,t.wz_name from gms_mat_infomation t where t.bsflag='0' and t.wz_name like '车用汽油%' order by t.wz_name";
				list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			} else if (oil_type.equals("2")) {
				String sql = "select t.wz_id,t.wz_name from gms_mat_infomation t where t.bsflag='0' and t.wz_name like '轻柴油%' order by t.wz_name";
				list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			}
		}

		Map map = new HashMap();
		map.put("wzId", "");
		map.put("wzName", "请选择");
		list.add(0, map);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * NEWMETHOD 跳转到配置计划送审审批明细界面
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatAllAddAppInfosForProcwfpg(ISrvMsg reqDTO)
			throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		// 修改增加中心
		String sql = "select org_id,org_name,org_abbreviation from comm_org_information  where org_id= 'C6000000000039' and bsflag='0' or org_id= 'C6000000000040' and bsflag='0' or org_id= 'C6000000005269' and bsflag='0' or org_id= 'C6000000005275' and bsflag='0' or org_id= 'C6000000005279' and bsflag='0' or org_id= 'C6000000005280' and bsflag='0'or org_id= 'C6000000005278' and bsflag='0'  or org_id= 'C6000000005370' and bsflag='0'";
		List list = jdbcDao.queryRecords(sql);
		System.out
				.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1");
		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * NEWMETHOD 跳转到配置计划送审审批明细界面---DG
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatPlanDgAddAppInfosForProcwfpg(ISrvMsg reqDTO)
			throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		System.out
				.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1");

		return reqMsg;
	}

	public ISrvMsg toSaveMatPlanDgAddAppAuditInfowfpa(ISrvMsg reqDTO)
			throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String oprstate = reqDTO.getValue("oprstate");
		String submite_number = reqDTO.getValue("submite_number");
		String matstatus = "";
		String projectInfoNo = "";
		String total_money = "";
		String orgId = "";
		String orgSubjectionId = "";
		StringBuffer sb = new StringBuffer()
				.append("select bz.*,e.proc_status from GMS_MAT_DEMAND_PLAN_BZ bz left join common_busi_wf_middle e on bz.submite_number = e.business_id where bz.submite_number='"
						+ submite_number + "' and bz.bsflag = '0' ");
		Map matappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (matappMap != null) {
			matstatus = matappMap.get("proc_status").toString();
			projectInfoNo = matappMap.get("project_info_no").toString();
			total_money = matappMap.get("total_money").toString();
			orgId = matappMap.get("org_id").toString();
			orgSubjectionId = matappMap.get("org_subjection_id").toString();
		}

		if ("pass".equals(oprstate) && "3".equals(matstatus)) {
			Date startDate = new Date();
			String str = new java.text.SimpleDateFormat("yyyy-MM-dd")
					.format(startDate);

			Map map = new HashMap();

			// 物资入库单据表操作
			map.put("invoices_no", this.getTableNum2(projectInfoNo, "5"));
			map.put("input_date", str);
			map.put("total_money", total_money);
			map.put("project_info_no", projectInfoNo);
			map.put("org_id", orgId);
			map.put("org_subjection_id", orgSubjectionId);
			map.put("CREATOR_ID", user.getUserId());
			map.put("create_date", new Date());
			map.put("UPDATOR_ID", user.getUserId());
			map.put("MODIFI_DATE", new Date());
			map.put("bsflag", "0");
			map.put("if_input", "0");
			map.put("IF_CENTER", "1"); // 1代表是各个中心申请的物资
			Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
					"gms_mat_teammat_invoices");

			String sql = "select d.*,i.wz_price from gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id = i.wz_id where d.bsflag='0' and  d.submite_number='"
					+ submite_number + "'";
			List list = jdbcDao.queryRecords(sql);
			if (list != null && list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					Map mapDetail = (Map) list.get(i);
					String demand_num = mapDetail.get("demand_num").toString();
					String demand_money = mapDetail.get("demand_num")
							.toString();
					String wz_id = mapDetail.get("wz_id").toString();
					String wz_price = mapDetail.get("wz_price").toString();

					Map planMap = new HashMap();
					planMap.put("PLAN_INVOICE_ID", submite_number);
					planMap.put("PLAN_NUM", demand_num);
					planMap.put("PLAN_PRICE", wz_price);
					planMap.put("PLAN_TOTAL_MONEY", demand_money);
					planMap.put("PLAN_DATE", str);
					planMap.put("PLAN_ORG", user.getOrgId());
					planMap.put("WZ_ID", wz_id);
					planMap.put("PROJECT_INFO_NO", projectInfoNo);
					planMap.put("WZ_TYPE", "1");
					planMap.put("CREATOR_ID", user.getUserId());
					planMap.put("plan_flat_type", "1");
					planMap.put("invoices_id", invoicesId);
					pureDao.saveOrUpdateEntity(planMap,
							"gms_mat_demand_plan_flat");

					Map todMap = new HashMap();
					// 物资入库明细表操作
					todMap.put("invoices_id", invoicesId);
					todMap.put("wz_id", wz_id);
					todMap.put("mat_num", demand_num);
					todMap.put("total_money", demand_money);
					todMap.put("actual_price", wz_price);
					// todMap.put("warehouse_number",
					// reqMap.get(warehouse_number));
					// todMap.put("goods_allocation",
					// reqMap.get(goods_allocation));
					todMap.put("project_info_no", projectInfoNo);
					todMap.put("org_id", orgId);
					todMap.put("org_subjection_id", orgSubjectionId);
					todMap.put("CREATOR_ID", user.getUserId());
					todMap.put("create_date", new Date());
					todMap.put("UPDATOR_ID", user.getUserId());
					todMap.put("MODIFI_DATE", new Date());
					todMap.put("bsflag", "0");
					todMap.put("if_accept", "0");
					// todMap.put("input_type", is_recyclemat);
					pureDao.saveOrUpdateEntity(todMap,
							"gms_mat_teammat_info_detail");
				}
			}
		}

		// 地震队物资入库
		/*
		 * todMap=new HashMap();
		 * sql="select * from GMS_MAT_TEAMMAT_INFO where is_recyclemat='"
		 * +is_recyclemat
		 * +"' and wz_id='"+ids[i]+"' and project_info_no='"+projectInfoNo+"'";
		 * Map select_map=jdbcDao.queryRecordBySQL(sql); if(select_map!=null){
		 * todMap.put("teammat_info_id", select_map.get("teammat_info_id")); int
		 * a =Integer.valueOf(reqMap.get(mat_num).toString()); int b
		 * =Integer.valueOf(select_map.get("stock_num").toString());
		 * todMap.put("stock_num", a+b); }else{ todMap.put("wz_id", ids[i]);
		 * todMap.put("STOCK_NUM", reqMap.get(mat_num));
		 * todMap.put("total_money", reqMap.get(total_money));
		 * todMap.put("actual_price", reqMap.get(actual_price));
		 * todMap.put("org_id",user.getOrgId()); todMap.put("org_subjection_id",
		 * user.getOrgSubjectionId()); todMap.put("CREATOR_ID",
		 * user.getUserId()); todMap.put("create_date", new Date());
		 * todMap.put("project_info_no", projectInfoNo);
		 * todMap.put("is_recyclemat", is_recyclemat); todMap.put("recyclemat",
		 * reqMap.get(mat_num)); }
		 * pureDao.saveOrUpdateEntity(todMap,"gms_mat_teammat_info");
		 */

		return reqMsg;
	}

	public ISrvMsg toSaveMatRemoveDgAddAppAuditInfowfpa(ISrvMsg reqDTO)
			throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String oprstate = reqDTO.getValue("oprstate");
		String out_info_id = reqDTO.getValue("out_info_id");
		String matstatus = "";
		String projectInfoNo = "";
		String total_money = "";
		String orgId = "";
		String orgSubjectionId = "";
		StringBuffer sb = new StringBuffer()
				.append("select bz.*,e.proc_status from GMS_MAT_OUT_INFO bz left join common_busi_wf_middle e on bz.out_info_id = e.business_id where bz.out_info_id='"
						+ out_info_id + "' and bz.bsflag = '0' ");
		Map matappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (matappMap != null) {
			matstatus = matappMap.get("proc_status").toString();
		}

		if ("pass".equals(oprstate)) {
			if ("3".equals(matstatus)) {
				Date startDate = new Date();
				String str = new java.text.SimpleDateFormat("yyyy-MM-dd")
						.format(startDate);

				String sqlUpdate = "update gms_mat_teammat_out  t set t.bsflag='0' where t.plan_invoice_id = '"
						+ out_info_id + "'  ";
				jdbcTemplate.execute(sqlUpdate);
			} else if ("1".equals(matstatus)) {
				String sqlUpdate = "update gms_mat_teammat_out  t set t.bsflag='0' where t.plan_invoice_id = '"
						+ out_info_id + "'  ";
				jdbcTemplate.execute(sqlUpdate);
			}
		} else if ("notPass".equals(oprstate)) {
			String sqlUpdate = "update gms_mat_teammat_out  t set t.bsflag='1' where t.plan_invoice_id = '"
					+ out_info_id + "'  ";
			jdbcTemplate.execute(sqlUpdate);
		}

		return reqMsg;
	}

	public ISrvMsg toSaveMatAllAddAppAuditInfowfpa(ISrvMsg reqDTO)
			throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();

		String oprstate = (String) reqmap.get("oprstate");
		if ("pass".equals(oprstate)) {

			String sqlMian = "update gms_mat_demand_plan_invoice set total_money='"
					+ reqmap.get("total_money")
					+ "' where plan_invoice_id='"
					+ reqmap.get("plan_invoice_id") + "'";
			jdbcDao.executeUpdate(sqlMian);

			String id = reqmap.get("laborId").toString();
			String[] ids = id.split(",");
			if (id != null && !id.equals("")) {
				// 定义数组变量
				String[] updateSql = new String[ids.length];

				for (int i = 0; i < ids.length; i++) {
					// Map updateMap = new HashMap();
					String regulateNum = "regulate_num" + ids[i];
					String applyNum = "apply_num" + ids[i];

					/*
					 * String sql =
					 * "select * from gms_mat_demand_plan t  where t.plan_invoice_id='"
					 * +
					 * reqmap.get("plan_invoice_id")+"'and t.wz_id='"+ids[i]+"'"
					 * ; Map getMap = pureDao.queryRecordBySQL(sql);
					 * updateMap.put("plan_id", getMap.get("plan_id"));
					 * updateMap.put("regulate_num", reqmap.get(regulateNum));
					 * updateMap.put("apply_num", reqmap.get(applyNum));
					 * pureDao.
					 * saveOrUpdateEntity(updateMap,"gms_mat_demand_plan");
					 */
					// 为数组赋值
					String applyNum1 = "";
					String regulateNum2 = "";
					if (reqmap.get(applyNum) != ""
							&& reqmap.get(applyNum) != null) {
						applyNum1 = reqmap.get(applyNum).toString();
					}
					if (reqmap.get(regulateNum) != ""
							&& reqmap.get(regulateNum) != null) {
						regulateNum2 = reqmap.get(regulateNum).toString();
					}
					String sql = "update gms_mat_demand_plan t set t.apply_num='"
							+ applyNum1
							+ "',t.regulate_num='"
							+ regulateNum2
							+ "' where t.plan_invoice_id='"
							+ reqmap.get("plan_invoice_id")
							+ "'and t.wz_id='"
							+ ids[i] + "'";
					updateSql[i] = sql;
					// pureDao.saveOrUpdateEntity(, "gms_mat_demand_plan");
					// jdbcDao.executeUpdate(sql);
				}
				jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
			}
		}
		return reqMsg;
	}

	/**
	 * 多项目大港物资审批
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg toSaveMatAllAddAppAuditInfowfpaDg(ISrvMsg reqDTO)
			throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();

		String oprstate = (String) reqmap.get("oprstate");
		if ("pass".equals(oprstate)) {

			String sqlMian = "update gms_mat_demand_plan_invoice set total_money='"
					+ reqmap.get("total_money")
					+ "' where plan_invoice_id='"
					+ reqmap.get("plan_invoice_id") + "'";
			jdbcDao.executeUpdate(sqlMian);

			String id = reqmap.get("laborId").toString();
			String[] ids = id.split(",");
			if (id != null && !id.equals("")) {
				// 定义数组变量
				String[] updateSql = new String[ids.length];

				for (int i = 0; i < ids.length; i++) {
					// Map updateMap = new HashMap();
					String regulateNum = "regulate_num" + ids[i];
					String applyNum = "apply_num" + ids[i];

					/*
					 * String sql =
					 * "select * from gms_mat_demand_plan t  where t.plan_invoice_id='"
					 * +
					 * reqmap.get("plan_invoice_id")+"'and t.wz_id='"+ids[i]+"'"
					 * ; Map getMap = pureDao.queryRecordBySQL(sql);
					 * updateMap.put("plan_id", getMap.get("plan_id"));
					 * updateMap.put("regulate_num", reqmap.get(regulateNum));
					 * updateMap.put("apply_num", reqmap.get(applyNum));
					 * pureDao.
					 * saveOrUpdateEntity(updateMap,"gms_mat_demand_plan");
					 */
					// 为数组赋值
					String applyNum1 = "";
					String regulateNum2 = "";
					if (reqmap.get(applyNum) != ""
							&& reqmap.get(applyNum) != null) {
						applyNum1 = reqmap.get(applyNum).toString();
					}
					if (reqmap.get(regulateNum) != ""
							&& reqmap.get(regulateNum) != null) {
						regulateNum2 = reqmap.get(regulateNum).toString();
					}
					String sql = "update gms_mat_demand_plan t set t.apply_num='"
							+ applyNum1
							+ "',t.regulate_num='"
							+ regulateNum2
							+ "' where t.plan_invoice_id='"
							+ reqmap.get("plan_invoice_id")
							+ "'and t.wz_id='"
							+ ids[i] + "'";
					updateSql[i] = sql;
					// pureDao.saveOrUpdateEntity(, "gms_mat_demand_plan");
					// jdbcDao.executeUpdate(sql);
				}
				jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
			}
		}
		return reqMsg;
	}

	/**
	 * 查看物资调配详细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg slectAllocateList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String[] ids = reqmap.get("ids").toString().split(",");
		String sql = "select i.wz_prickie, i.wz_id, i.wz_name,  i.wz_price, d.demand_num, d.outbound_org_id, d.approve_num, d.demand_date, comm.org_abbreviation outbound_name, case  when sum(flat.plan_num)is null then  0 else sum(flat.plan_num) end plan_num  from gms_mat_demand_plan_bz t inner join(gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag = '0') on t.submite_number = d.submite_number and d.bsflag = '0' left join comm_coding_sort_detail s on t.s_apply_team = s.coding_code_id and s.bsflag = '0' left join gms_mat_demand_plan_flat flat on i.wz_id=flat.wz_id and flat.plan_invoice_id = '"
				+ ids[0]
				+ "'  and plan_org != 'C6000000005370' left join comm_org_information comm on d.OUTBOUND_ORG_ID = comm.org_id where t.plan_invoice_id = '"
				+ ids[0]
				+ "' and t.bsflag = '0'group by i.wz_prickie, i.wz_id, i.wz_name,  i.wz_price, d.demand_num, d.outbound_org_id, d.approve_num, d.demand_date, comm.org_abbreviation";
		List list = jdbcDao.queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 物资调配
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findAllocateList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String[] ids = reqmap.get("ids").toString().split(",");
		String sql = "select i.wz_prickie, d.plan_detail_id,  i.wz_id,  t.submite_id, i.wz_name,  i.wz_price,  d.demand_num,  d.outbound_org_id,  d.outbound_number,  d.approve_num,   d.demand_date,  d.outbound_number,case when re.stock_num is null then  0 else re.stock_num   end stock_num,  case when re.wz_type = '1' then '在帐库存' else '在帐库存' end wz_type,  case  when re.actual_price is null then 0  else re.actual_price end actual_price, case when flat.plan_num is null then  0 else flat.plan_num end  plan_num, case  when re1.stock_num is null then  0 else re1.stock_num   end stock_num1,  case  when re1.wz_type = '2' then '可重复库存' else '可重复库存'  end wz_type1, case when re1.actual_price is null then 0 else re1.actual_price end actual_price1, case when flat1.plan_num1 is null then 0 else  flat1.plan_num1 end plan_num1 from gms_mat_demand_plan_bz t inner join(gms_mat_demand_plan_detail d  inner join gms_mat_infomation i  on d.wz_id = i.wz_id  and i.bsflag = '0') on t.submite_number = d.submite_number and d.bsflag = '0' left join comm_coding_sort_detail s  on t.s_apply_team = s.coding_code_id and s.bsflag = '0'  left join ( select  t.wz_type, t.wz_id, case when sum(t.stock_num) - case  when flat.plan_num is null then  0  else flat.plan_num end is null then  0 else sum(t.stock_num) - case when flat.plan_num is null then 0  else flat.plan_num end end stock_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then  1 else sum(t.stock_num) end, 3) actual_price from gms_mat_recyclemat_info t  left join (select sum(plan_num) plan_num, wz_id from gms_mat_demand_plan_flat  where plan_flat_type = '1' and wz_type = '1'  group by wz_id) flat  on t.wz_id = flat.wz_id  where t.bsflag = '0' and t.wz_type = '1'  and t.org_id = '"
				+ user.getOrgId()
				+ "' group by t.wz_id, flat.plan_num,t.wz_type) re on i.wz_id = re.wz_id left join ( select  t.wz_type, t.wz_id, case when sum(t.stock_num) - case  when flat.plan_num is null then  0  else flat.plan_num end is null then  0 else sum(t.stock_num) - case when flat.plan_num is null then 0  else flat.plan_num end end stock_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then  1 else sum(t.stock_num) end, 3) actual_price from gms_mat_recyclemat_info t  left join (select sum(plan_num) plan_num, wz_id from gms_mat_demand_plan_flat  where plan_flat_type = '1' and wz_type = '1'  group by wz_id) flat  on t.wz_id = flat.wz_id  where t.bsflag = '0' and t.wz_type = '2'  and t.org_id = '"
				+ user.getOrgId()
				+ "' group by t.wz_id, flat.plan_num,t.wz_type) re1 on i.wz_id = re1.wz_id left join ( select sum(plan_num) plan_num ,wz_id from gms_mat_demand_plan_flat where wz_type='1' and plan_invoice_id = '"
				+ ids[0]
				+ "' group by wz_id)  flat on i.wz_id=flat.wz_id left join ( select sum(plan_num) plan_num1 ,wz_id from gms_mat_demand_plan_flat where wz_type='2' and plan_invoice_id = '"
				+ ids[0]
				+ "' group by wz_id) flat1 on i.wz_id=flat1.wz_id  where t.plan_invoice_id = '"
				+ ids[0]
				+ "' and t.bsflag = '0' and d.outbound_org_id='"
				+ user.getOrgId() + "'";
		List list = jdbcDao.queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 大港副科物资调配详细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findPlanDgwt(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String sql = "select i.wz_prickie,i.wz_id,t.submite_id,i.wz_name,i.wz_price,d.demand_num,d.approve_num,d.demand_date,i.note,s.coding_name from gms_mat_demand_plan_bz t inner join (gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where t.plan_invoice_id='"
				+ reqmap.get("planInvoiceId")
				+ "'and t.bsflag='0' union select i.wz_prickie,i.wz_id,t.procure_no,i.wz_name,i.wz_price,d.plan_num demand_num,d.app_num approve_num,t.create_date demand_date,i.note,t.device_use_name coding_name from GMS_MAT_TEAMMAT_OUT t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.plan_invoice_id='"
				+ reqmap.get("planInvoiceId") + "'and t.bsflag='0'";
		// select
		// t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation
		// org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo
		// from gms_mat_demand_plan_invoice t inner join p_auth_user u on
		// t.creator_id=u.user_id and u.bsflag='0' inner join
		// comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner
		// join gp_task_project p on t.project_info_no=p.project_info_no and
		// p.bsflag='0' where t.plan_invoice_id in( select t.plan_invoice_id
		// from gms_mat_demand_plan_invoice t inner join common_busi_wf_middle
		// t3 on t3.business_id =t.plan_invoice_id inner join
		// gms_mat_demand_plan_invoice t2 on t3.business_id=t2.plan_invoice_id
		// where t.org_subjection_id like 'C105007%' and t3.proc_status='3' and
		// t.bsflag='0')
		List list = jdbcDao.queryRecords(sql);

		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 大港分配出库详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findSubListAssignDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String sql = " select i.wz_prickie, d.plan_detail_id,  i.wz_id, t.submite_id, i.wz_name, i.wz_price, d.demand_num, d.approve_num, d.demand_date,   i.note, s.coding_name,comm.org_abbreviation outbound_org_id,d.outbound_number  from gms_mat_demand_plan_bz t inner join(gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag = '0') on t.submite_number = d.submite_number and d.bsflag = '0' left join comm_coding_sort_detail s on t.s_apply_team = s.coding_code_id and s.bsflag = '0'  left join comm_org_information comm on d.outbound_org_id=comm.org_id  where t.plan_invoice_id = '"
				+ reqmap.get("ids") + "'  and t.bsflag = '0' ";
		// union select i.wz_prickie, i.wz_id, t.procure_no, i.wz_name,
		// i.wz_price, d.plan_num demand_num, d.app_num approve_num,
		// t.create_date demand_date, i.note, t.device_use_name coding_name from
		// GMS_MAT_TEAMMAT_OUT t inner join(GMS_MAT_DEVICE_USE_INFO_DETAIL d
		// inner join gms_mat_infomation i on d.wz_id = i.wz_id and i.bsflag =
		// '0') on t.teammat_out_id = d.teammat_out_id and d.bsflag = '0' where
		// t.plan_invoice_id = '"+reqmap.get("ids")+"'
		List list = jdbcDao.queryRecords(sql);
		// String wz_sql="";
		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 大港分配出库-指定出库单位
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateAssignDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String sql = reqmap.get("sql").toString();
		String[] sqls = sql.split("@");
		for (int i = 0; i < sqls.length; i++) {
			jdbcDao.executeUpdate(sqls[i]);
		}
		reqMsg.setValue("abc", "abc");
		return reqMsg;
	}

	/**
	 * 大港调配状态修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg allocateType(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String id = reqmap.get("ids").toString();
		String[] ids = id.split(",");
		if (ids[0].equals("1")) {
			String sql = "select count(*)*2 type_num,sum(flat_type) type_num1 from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL de on t.submite_number=de.submite_number where plan_invoice_id = '"
					+ ids[1] + "'  ";
			Map listMap = jdbcDao.queryRecordBySQL(sql);
			Map map = new HashMap();
			map.put("plan_invoice_id", ids[1]);
			if (listMap.get("type_num").equals(listMap.get("type_num1"))) {
				map.put("flat_type", "2");
			} else {
				map.put("flat_type", "1");
			}
			jdbcDao.saveOrUpdateEntity(map, "gms_mat_demand_plan_invoice");
		} else if (ids[0].equals("2")) {
			for (int i = 1; i < ids.length; i++) {
				Map map = new HashMap();
				map.put("plan_detail_id", ids[i]);
				map.put("flat_type", "2");
				jdbcDao.saveOrUpdateEntity(map, "GMS_MAT_DEMAND_PLAN_DETAIL");
			}
		} else {
			for (int i = 1; i < ids.length; i++) {
				Map map = new HashMap();
				map.put("plan_detail_id", ids[i]);
				map.put("flat_type", "1");
				jdbcDao.saveOrUpdateEntity(map, "GMS_MAT_DEMAND_PLAN_DETAIL");
			}
		}

		return reqMsg;
	}

	/**
	 * 大港调配出库-调配表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg allocateList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String[] project_info_ids = reqmap.get("project_info_ids").toString()
				.split(",");
		String[] wz_list = reqmap.get("wz_list").toString().split("@");
		Map map = new HashMap();
		for (int i = 0; i < wz_list.length; i++) {
			String[] array = wz_list[i].split(",");

			map.put("project_info_no", project_info_ids[0]);
			map.put("plan_invoice_id", project_info_ids[1]);
			map.put("wz_id", array[0]);
			map.put("creator_id", user.getUserId());
			map.put("plan_org", user.getOrgId());
			if (Integer.parseInt(array[1]) > 0) {
				map.put("plan_num", array[1]);
				map.put("plan_price", array[2]);
				map.put("plan_total_money",
						Math.round(Double.parseDouble(array[1])
								* Double.parseDouble(array[2])));
				map.put("wz_type", 1);
				pureDao.saveOrUpdateEntity(map, "gms_mat_demand_plan_flat");
			}
			if (Integer.parseInt(array[3]) > 0) {
				map.put("plan_num", array[3]);
				map.put("plan_price", array[4]);
				map.put("plan_total_money",
						Math.round(Double.parseDouble(array[3])
								* Double.parseDouble(array[4])));
				map.put("wz_type", 2);
				pureDao.saveOrUpdateEntity(map, "gms_mat_demand_plan_flat");
			}
		}
		return reqMsg;
	}

	/**
	 * 大港分中心出库
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg allocateOutbound(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String plan = reqmap.get("plan").toString();
		String[] plans = plan.split("@"); // 参数截断1,1,2,3,4@5,5,5,5,5
		Map map = new HashMap();

		return reqMsg;
	}

	/**
	 * 分配出库-查看
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg viewSuppliesAllocate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select * from (select t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo,decode(t.assign_type, '0', '未分配', '1', '已分配', '', '未分配') assign_type from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' where t.plan_invoice_id in(select t.plan_invoice_id from gms_mat_demand_plan_invoice t  inner join common_busi_wf_middle t3 on t3.business_id =t.plan_invoice_id  inner join gms_mat_demand_plan_invoice t2 on t3.business_id=t2.plan_invoice_id  where t.org_subjection_id like 'C105007%'  and t3.proc_status='3' and t.bsflag='0')) where plan_invoice_id='"
				+ reqDTO.getValue("plan_invoice_id") + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;

	}

	/**
	 * 分配出库-查看是否已调配
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg select_assign_type(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select * from  gms_mat_demand_plan_invoice  where plan_invoice_id='"
				+ reqDTO.getValue("plan_invoice_id") + "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;

	}

	/**
	 * 查询8个专业化单位
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg select_org(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select * from (select org_id, org_name, org_abbreviation,decode(org_id,'C6000000005275',0,1) order_num from comm_org_information where bsflag = '0'and org_id in ('C6000000005275','C6000000000039','C6000000000040','C6000000005279','C6000000005280','C6000000005278','C6000000007366','C6000000005277')) tt order by tt.order_num asc,tt.org_id asc";
		List list = jdbcDao.queryRecords(sql);
		reqMsg.setValue("list", list);
		return reqMsg;

	}

	/**
	 * 大港验收物资保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAcceptLedgerDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("id").toString();
		String[] ids = id.split(",");
		// String
		// is_recyclemat=reqMap.get("is_recyclemat").toString().equals("物资供应")?"1":reqMap.get("is_recyclemat").toString().equals("转出")?"3":"2";
		// 1物资供应 2 专业化 3 其他项目转出的物资
		String orgId = "";
		String org_id = user.getOrgId();
		String wz_from = reqMap.get("wz_from").toString();

		Map map = new HashMap();

		// 物资入库单据表操作
		map.put("invoices_no", this.getTableNum2(projectInfoNo, "5"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("input_date", reqMap.get("input_date"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("invoices_type", "5");
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("CREATOR_ID", user.getUserId());
		map.put("create_date", new Date());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		map.put("bsflag", "0");
		map.put("if_input", "0");
		if (org_id != null
				&& (org_id.equals("C6000000000039")
						|| org_id.equals("C6000000000040")
						|| org_id.equals("C6000000005275")
						|| org_id.equals("C6000000005277")
						|| org_id.equals("C6000000005278")
						|| org_id.equals("C6000000005279") || org_id
							.equals("C6000000005280"))) {
			map.put("IF_CENTER", "1"); // 1代表是专业化单位物资 null代表小队物资
		}
		map.put("WZ_FROM", wz_from);
		Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_invoices");
		// 入库单据结束

		// 修改入库状态
		/*
		 * if(is_recyclemat!=null&&!is_recyclemat.equals("3")){ String
		 * sqls="select * from  GMS_MAT_DEMAND_PLAN_DETAIL where plan_detail_id='"
		 * +reqMap.get("plan_flat_id")+"'"; Map
		 * select_map=jdbcDao.queryRecordBySQL(sqls); if(select_map!=null){
		 * select_map.put("flat_type", "3"); select_map.put("outbound_number",
		 * invoicesId);
		 * pureDao.saveOrUpdateEntity(select_map,"GMS_MAT_DEMAND_PLAN_DETAIL");
		 * }else{ Map planMap = new HashMap(); planMap.put("plan_flat_id",
		 * reqMap.get("plan_flat_id")); planMap.put("plan_flat_type", "1");
		 * planMap.put("invoices_id", invoicesId);
		 * pureDao.saveOrUpdateEntity(planMap,"gms_mat_demand_plan_flat");
		 * 
		 * } }else{ Map planMap = new HashMap();
		 * planMap.put("out_info_detail_id", reqMap.get("plan_flat_id"));
		 * planMap.put("receive_org_id", "1"); planMap.put("invoices_id",
		 * invoicesId);
		 * pureDao.saveOrUpdateEntity(planMap,"gms_mat_out_info_detail");
		 * 
		 * 
		 * }
		 */

		for (int i = 0; i < ids.length; i = i + 2) {
			String sql = "select * from GMS_MAT_RECYCLEMAT_INFO where org_id='"
					+ orgId + "' and wz_id='" + ids[i] + "'";
			// Map seMap=jdbcDao.queryRecordBySQL(sql);

			String pk = ids[i];
			Map todMap = new HashMap();
			if (wz_from != null
					&& (wz_from.equals("C6000000000039")
							|| wz_from.equals("C6000000000040")
							|| wz_from.equals("C6000000005275")
							|| wz_from.equals("C6000000005277")
							|| wz_from.equals("C6000000005278")
							|| wz_from.equals("C6000000005279") || wz_from
								.equals("C6000000005280"))) {
				Map planMap = new HashMap();
				planMap.put("plan_flat_id", ids[i + 1]);
				planMap.put("plan_flat_type", "1");
				planMap.put("invoices_id", invoicesId);
				pureDao.saveOrUpdateEntity(planMap, "gms_mat_demand_plan_flat");
				pk = ids[i + 1];
			}

			String mat_num = "mat_num_" + pk;
			String total_money = "total_money_" + pk;
			String actual_price = "actual_price_" + pk;
			String warehouse_number = "warehouse_number_" + pk;
			String goods_allocation = "goods_allocation_" + pk;

			// 物资入库明细表操作
			todMap.put("invoices_id", invoicesId);
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("warehouse_number", reqMap.get(warehouse_number));
			todMap.put("goods_allocation", reqMap.get(goods_allocation));
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("CREATOR_ID", user.getUserId());
			todMap.put("create_date", new Date());
			todMap.put("bsflag", "0");
			todMap.put("if_accept", "0");
			// todMap.put("input_type", is_recyclemat);
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_info_detail");

			/*
			 * //地震队物资入库 -----------赵阳做的 todMap=new HashMap();
			 * sql="select * from GMS_MAT_TEAMMAT_INFO where is_recyclemat='"
			 * +is_recyclemat
			 * +"' and wz_id='"+ids[i]+"' and project_info_no='"+projectInfoNo
			 * +"'"; Map select_map=jdbcDao.queryRecordBySQL(sql);
			 * if(select_map!=null){ todMap.put("teammat_info_id",
			 * select_map.get("teammat_info_id")); int a
			 * =Integer.valueOf(reqMap.get(mat_num).toString()); int b
			 * =Integer.valueOf(select_map.get("stock_num").toString());
			 * todMap.put("stock_num", a+b); }else{ todMap.put("wz_id", ids[i]);
			 * todMap.put("STOCK_NUM", reqMap.get(mat_num));
			 * todMap.put("total_money", reqMap.get(total_money));
			 * todMap.put("actual_price", reqMap.get(actual_price));
			 * todMap.put("org_id",user.getOrgId());
			 * todMap.put("org_subjection_id", user.getOrgSubjectionId());
			 * todMap.put("CREATOR_ID", user.getUserId());
			 * todMap.put("create_date", new Date());
			 * todMap.put("project_info_no", projectInfoNo);
			 * todMap.put("is_recyclemat", is_recyclemat);
			 * todMap.put("recyclemat", reqMap.get(mat_num)); }
			 * pureDao.saveOrUpdateEntity(todMap,"gms_mat_teammat_info");
			 */
		}
		return reqMsg;
	}

	/**
	 * 手动验收物资保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg EditAcceptLedgerDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("id").toString();
		String[] ids = id.split(",");
		Map map = new HashMap();

		// 物资入库单据表操作
		map.put("invoices_id", reqMap.get("invoices_id"));
		map.put("operator", reqMap.get("operator"));
		map.put("pickupgoods", reqMap.get("pickupgoods"));
		map.put("input_date", reqMap.get("input_date"));
		map.put("storage", reqMap.get("storage"));
		map.put("note", reqMap.get("note"));
		map.put("total_money", reqMap.get("total_money"));
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		Serializable invoicesId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_teammat_invoices");

		String deleteSql = "delete from gms_mat_teammat_info_detail where invoices_id='"
				+ invoicesId + "'";
		jdbcDao.executeUpdate(deleteSql);

		// 物资入库明细操作
		for (int i = 0; i < ids.length; i = i + 2) {

			Map todMap = new HashMap();
			String mat_num = "mat_num_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String actual_price = "actual_price_" + ids[i];
			String warehouse_number = "warehouse_number_" + ids[i];
			String goods_allocation = "goods_allocation_" + ids[i];

			// todMap.put("teammat_info_idetail_id", ids[i]);
			todMap.put("invoices_id", invoicesId);
			todMap.put("wz_id", ids[i]);
			todMap.put("mat_num", reqMap.get(mat_num));
			todMap.put("total_money", reqMap.get(total_money));
			todMap.put("actual_price", reqMap.get(actual_price));
			todMap.put("warehouse_number", reqMap.get(warehouse_number));
			todMap.put("goods_allocation", reqMap.get(goods_allocation));
			todMap.put("project_info_no", projectInfoNo);
			todMap.put("org_id", user.getOrgId());
			todMap.put("org_subjection_id", user.getOrgSubjectionId());
			todMap.put("CREATOR_ID", user.getUserId());
			todMap.put("create_date", new Date());
			todMap.put("bsflag", "0");
			todMap.put("if_accept", "0");
			pureDao.saveOrUpdateEntity(todMap, "gms_mat_teammat_info_detail");
			// 更新单价
			String matSql = "update gms_mat_infomation t set t.wz_price='"
					+ reqMap.get(actual_price) + "' where t.wz_id='" + ids[i]
					+ "'";
			jdbcDao.executeUpdate(matSql);
		}
		return reqMsg;
	}

	/**
	 * 大港选择物资页面初始页面
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSelectRepOutDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = user.getProjectInfoNo();
		String org_id = user.getOrgId();

		String teamOutId = reqDTO.getValue("teamOutId");
		String s_wz_id = reqDTO.getValue("s_wz_id");
		String s_wz_name = reqDTO.getValue("s_wz_name");
		String selectWzId = reqDTO.getValue("selectWzId");
		String wz_type = reqDTO.getValue("wz_type");
		String checkSql = "";
		checkSql = "select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0'";
		if (org_id != null
				&& (org_id.equals("C6000000000039")
						|| org_id.equals("C6000000000040")
						|| org_id.equals("C6000000005275")
						|| org_id.equals("C6000000005277")
						|| org_id.equals("C6000000005278")
						|| org_id.equals("C6000000005279") || org_id
							.equals("C6000000005280"))) {
			checkSql += " and mti.if_center = '1' and mti.org_id='" + org_id
					+ "'";
			wz_type = "11";
		} else {
			checkSql += " and mti.if_center is null";
			wz_type = "22";
		}
		checkSql += " and mti.project_info_no='"
				+ projectInfoNo
				+ "'  group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type = '"
				+ wz_type
				+ "'  and (mto.oil_from != '1' or mto.oil_from is null)  and mto.project_info_no='"
				+ projectInfoNo
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' where t.stock_num > '0' and t.project_info_no = '"
				+ projectInfoNo + "') a";
		if ((selectWzId != null && !selectWzId.equals(""))
				|| (s_wz_id != null && !s_wz_id.equals(""))
				|| (s_wz_name != null && !s_wz_name.equals(""))) {
			checkSql += " where ";
		}
		if (selectWzId != null && !selectWzId.equals("")) {
			checkSql += " a.wz_id not in (" + selectWzId + ")";
		}
		if (s_wz_id != null && !s_wz_id.equals("")) {
			if (selectWzId != null && !selectWzId.equals("")) {
				checkSql += " and ";
			}
			checkSql += " a.wz_id like '%" + s_wz_id + "%'";
		}
		if (s_wz_name != null && !s_wz_name.equals("")) {
			if ((selectWzId != null && selectWzId != "")
					|| (s_wz_id != null && s_wz_id != "")) {
				checkSql += " and ";
			}
			checkSql += " a.wz_name like '%" + s_wz_name + "%'";
		}
		checkSql += " order by a.wz_id asc";

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(checkSql);

		reqMsg.setValue("list", list);

		return reqMsg;
	}

	/**
	 * 可重复利用物资excel导入数据库
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveExcelRepMatDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String type = reqDTO.getValue("type");
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		String errorMessage = null;
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List<Map> columnList = new ArrayList<Map>();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = ExcelEIResolvingUtil
						.getRepMatExcelDataByWSFileDg(file);
			}
		}
		System.out.println(dataList.size());
		// 遍历dataList，操作数据库
		for (int i = 0; i < dataList.size(); i++) {
			Map dataMap = (Map) dataList.get(i);
			if (dataMap.get("wz_id") != null && dataMap.get("wz_id") != "") {
				Map repMap = new HashMap();
				String recyclemat_info = "";
				String sql = "select * from gms_mat_recyclemat_info t where t.wz_id='"
						+ dataMap.get("wz_id")
						+ "'and t.bsflag='0' and wz_type='"
						+ type
						+ "' and org_id='" + user.getOrgId() + "'";
				Map getMap = pureDao.queryRecordBySQL(sql);
				double stockNum = Double.valueOf(dataMap.get("stock_num")
						.toString());
				if (getMap != null) {
					stockNum += Double.valueOf(getMap.get("stock_num")
							.toString());
					repMap.put("recyclemat_info", getMap.get("recyclemat_info"));
				}

				repMap.put("wz_id", dataMap.get("wz_id"));
				// repMap.put("actual_price", dataMap.get("actual_price"));
				repMap.put("stock_num", stockNum);
				repMap.put("wz_type", type);
				repMap.put("BSFLAG", "0");
				repMap.put("org_id", user.getOrgId());
				repMap.put("org_subjection_id", user.getOrgSubjectionId());
				repMap.put("CREATOR_ID", user.getUserId());
				// repMap.put("CREATE_DATE", dataMap.get("out_date"));
				repMap.put("UPDATOR_ID", user.getUserId());
				repMap.put("MODIFI_DATE", new Date());
				pureDao.saveOrUpdateEntity(repMap, "gms_mat_recyclemat_info");
			}
		}
		return reqMsg;
	}

	/**
	 * 大港物资台账入库明细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findMatInDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String orgId = reqDTO.getValue("orgId");
		String type = reqDTO.getValue("type");
		String sql = "select org.org_abbreviation,d.out_price,t.stock_num,d.total_money,to_char(info.out_date,'yyyy-MM-dd HH24:mi:ss') out_date,to_char(t.modifi_date,'yyyy-MM-dd HH24:mi:ss') modifi_date from gms_mat_recyclemat_info t inner join gms_mat_out_info_detail d on t.wz_id=d.wz_id inner join gms_mat_out_info info on d.out_info_id=info.out_info_id and info.bsflag='0' and info.if_submit='1' and info.out_type='"
				+ type
				+ "' inner join comm_org_information org on t.source_org_id=org.org_id where t.wz_id='"
				+ id + "'";
		sql += "union all select org.org_abbreviation,t.actual_price,t.stock_num,(t.actual_price*t.stock_num) total_money ,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') out_date,to_char(t.modifi_date,'yyyy-MM-dd HH24:mi:ss') modifi_date from gms_mat_recyclemat_info t  inner join comm_org_information org on t.source_org_id = org.org_id where t.wz_id='"
				+ id
				+ "' and t.wz_type='"
				+ type
				+ "' and t.org_id='"
				+ orgId
				+ "'";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 大港物资台账出库明细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findMatOutDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String sql = "select * from gms_mat_recyclemat_info t where t.recyclemat_info='"
				+ id + "'";
		Map queryMap = jdbcDao.queryRecordBySQL(sql);
		String queryout = "select d.*,gp.project_name,org.org_abbreviation from gms_mat_teammat_info_detail d left join gp_task_project gp on d.project_info_no=gp.project_info_no left join comm_org_information org on d.org_id=org.org_id where d.wz_id='"
				+ queryMap.get("wz_id") + "'";
		List list = pureDao.queryRecords(queryout);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 大港物资台账入库明细
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findTeammatDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String project_info_no = reqDTO.getValue("project_info_no");
		String org_id = user.getOrgId();
		String sql = " select * from GMS_MAT_TEAMMAT_INFO_DETAIL a inner join gms_mat_teammat_invoices mti on mti.invoices_id = a.invoices_id";

		if (org_id != null
				&& (org_id.equals("C6000000000039")
						|| org_id.equals("C6000000000040")
						|| org_id.equals("C6000000005275")
						|| org_id.equals("C6000000005277")
						|| org_id.equals("C6000000005278")
						|| org_id.equals("C6000000005279") || org_id
							.equals("C6000000005280"))) {
			sql += " and mti.if_center = '1' and mti.org_id='" + org_id + "'";
		} else {
			sql += " and mti.if_center is null";
		}
		sql += " and mti.bsflag='0' where a.project_info_no='"
				+ project_info_no + "' and wz_id='" + id + "'";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 大港单项目物资台账单件物资详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSingleRepMatLedgerDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String type = reqDTO.getValue("type");
		// String sql =
		// "select g.wz_id ,g.coding_code_id,g.mat_desc,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0' and g.wz_id = '"+
		// id + "'";
		StringBuffer sql = new StringBuffer();
		sql.append("select aa.wz_id,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,i.wz_price,i.mat_desc from ( ");
		sql.append("select tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tid.wz_id='"
				+ id
				+ "'  and mti.if_input='0' group by tid.wz_id ");
		sql.append(")aa left join ( ");
		sql.append("select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and tod.wz_id='"
				+ id
				+ "' group by tod.wz_id ");
		sql.append(") bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0' order by i.coding_code_id asc,aa.wz_id asc ");
		Map map = ijdbcDao.queryRecordBySQL(sql.toString());
		String codingCodeId = map.get("codingCodeId").toString();
		String querysql = "select code_name from gms_mat_coding_code where coding_code_id = '"
				+ codingCodeId + "'";
		Map querymap = ijdbcDao.queryRecordBySQL(querysql);
		String codeName = querymap.get("codeName").toString();
		map.put("codingCodeId", codeName);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 物资调配查询能调配的单据ID
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getsuppliesDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String sql = "   select distinct bz.plan_invoice_id from GMS_MAT_DEMAND_PLAN_DETAIL t inner join GMS_MAT_DEMAND_PLAN_BZ bz on t.submite_number=bz.submite_number  where t.flat_org_id ='"
				+ user.getOrgId() + "'";
		List list = jdbcDao.queryRecords(sql);
		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 大港物资台账新增
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatItem(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		for (int i = 0; i < ids.length; i++) {
			String wz_type = "wz_type_" + ids[i];
			// String
			// sql="select * from gms_mat_recyclemat_info where wz_id='"+ids[i]+"' and org_id='"+user.getOrgId()+"' and wz_type='"+(reqMap.get(wz_type).toString().equals("在帐物资")?"1":"2")+"'";
			// Map recyclemat = ijdbcDao.queryRecordBySQL(sql.toString());
			Map map = new HashMap();
			String wz_number = "wz_number_" + ids[i]; // 数量
			/*
			 * if(recyclemat!=null){ map.put("recyclemat_info",
			 * recyclemat.get("recyclematInfo")); int
			 * num=Integer.valueOf(recyclemat.get("stockNum").toString()); int
			 * reqNum=Integer.valueOf(reqMap.get(wz_number).toString());
			 * map.put("stock_num", num+reqNum); }else{
			 */
			String coding_code_id = "coding_code_id_" + ids[i];
			String wz_name = "wz_name_" + ids[i];
			String wz_price_ = "wz_price_" + ids[i];
			String note = "note_" + ids[i];

			map.put("wz_id", ids[i]);
			map.put("actual_price", reqMap.get(wz_price_).toString());
			map.put("stock_num", reqMap.get(wz_number).toString());
			map.put("wz_type",
					reqMap.get(wz_type).toString().equals("在帐物资") ? "1" : "2");
			map.put("BSFLAG", "0");
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("UPDATOR_ID", user.getUserId());
			map.put("MODIFI_DATE", new Date());
			map.put("source_org_id", "C6000000005370"); // 自己增加物资时默认物资来源大港分中心
			// }
			pureDao.saveOrUpdateEntity(map, "gms_mat_recyclemat_info");
		}
		return reqMsg;
	}

	/**
	 * 大港调配出库-调配表-针对大港分中心
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAllocate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		/*
		 * Map reqmap = reqDTO.toMap(); String
		 * plan_invoice_id=reqmap.get("plan_invoice_id").toString(); String sql=
		 * "select bz.project_info_no,plan_invoice_id,t.outbound_number,i.wz_id,i.wz_price from GMS_MAT_DEMAND_PLAN_DETAIL t inner join GMS_MAT_DEMAND_PLAN_BZ bz on t.submite_number=bz.submite_number inner join gms_mat_infomation i on i.wz_id=t.wz_id where bz.plan_invoice_id='"
		 * +plan_invoice_id+"'  and outbound_org_id='C6000000005370'"; List
		 * list=jdbcDao.queryRecords(sql); for (int i = 0; i < list.size(); i++)
		 * { Map detail=(Map)list.get(i); Map map=new HashMap(); String
		 * number=detail.get("outbound_number").toString(); String
		 * price=detail.get("wz_price").toString();
		 * map.put("project_info_no",detail.get("project_info_no"));
		 * map.put("plan_invoice_id", detail.get("plan_invoice_id"));
		 * map.put("plan_num", number); map.put("plan_price", price);
		 * map.put("plan_total_money",
		 * (Integer.valueOf(number)*Double.valueOf(price))); map.put("wz_id",
		 * detail.get("wz_id")); map.put("creator_id", "C6000000005370");
		 * map.put("plan_org", "C6000000005370");
		 * pureDao.saveOrUpdateEntity(map, "gms_mat_demand_plan_flat");
		 * 
		 * }
		 */
		return reqMsg;
	}

	/**
	 * 大港物资出库页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherGantOutDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num, (nvl(a.stock_num,0)*nvl(a.wz_price,0)) total_money from(select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' and mti.invoices_type<>'2' and mti.invoices_type<>'1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a";
		if (wz_ids != null && !wz_ids.equals("")) {
			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 大港计划编制汇总信息修改
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatePlanSumDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map reqmap = reqDTO.toMap();
		String id = reqmap.get("laborId").toString();
		String[] ids = id.split(",");
		Map pimap = new HashMap();
		pimap.put("plan_invoice_id", reqmap.get("plan_invoice_id"));
		pimap.put("compile_date", reqmap.get("compile_date"));
		pimap.put("total_money", reqmap.get("total_money"));
		pimap.put("submite_number", reqmap.get("submite_number"));
		pimap.put("plan_name", reqmap.get("plan_name"));
		// 新增主办区域，备注 --------lx
		pimap.put("main_part", reqmap.get("main_part"));
		pimap.put("memo", reqmap.get("memo"));

		pimap.put("creator_id", user.getUserId());
		pimap.put("create_date", new Date());
		pureDao.saveOrUpdateEntity(pimap, "gms_mat_demand_plan_invoice");
		for (int i = 0; i < ids.length; i++) {
			String haveNum = "have_num" + ids[i];
			// String regulateNum = "regulate_num" + ids[i];
			String applyNum = "apply_num" + ids[i];
			String plan_money = "plan_money" + ids[i];
			Map dpmap = new HashMap();
			dpmap.put("plan_id", ids[i]);
			// dpmap.put("have_num", reqmap.get(haveNum));
			// dpmap.put("regulate_num", reqmap.get(regulateNum));
			dpmap.put("apply_num", reqmap.get(applyNum));
			String sql = "update gms_mat_demand_plan t set t.apply_num='"
					+ reqmap.get(applyNum) + "' where t.plan_invoice_id='"
					+ reqmap.get("plan_invoice_id") + "'and t.wz_id='" + ids[i]
					+ "'";
			// pureDao.saveOrUpdateEntity(, "gms_mat_demand_plan");
			jdbcDao.executeUpdate(sql);
			sql = "select d.* from gms_mat_demand_plan_bz  t inner join  gms_mat_demand_plan_detail d on t.submite_number=d.submite_number where plan_invoice_id='"
					+ reqmap.get("plan_invoice_id")
					+ "' and wz_id='"
					+ ids[i]
					+ "'";
			dpmap = jdbcDao.queryRecordBySQL(sql);
			// dpmap.put("plan_detail_id", dpmap.get("plan_detail_id"));
			dpmap.put("demand_num", reqmap.get(applyNum));
			dpmap.put("approve_num", reqmap.get(applyNum));
			dpmap.put("demand_money", reqmap.get(plan_money));
			jdbcDao.saveOrUpdateEntity(dpmap, "gms_mat_demand_plan_detail");
		}
		return reqMsg;
	}

	/**
	 * 可重复利用物资出库页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherRepOutDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String wz_ids = reqDTO.getValue("wz_ids");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num, (nvl(a.stock_num,0)*nvl(a.wz_price,0)) total_money from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' and mti.if_input='0' and mti.invoices_type='2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
				+ user.getProjectInfoNo()
				+ "' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
				+ user.getProjectInfoNo() + "') a ";
		if (wz_ids != null && !wz_ids.equals("")) {

			sql += " where a.wz_id in(" + wz_ids + ")";
		}
		sql += " order by a.wz_id asc";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 流程查看！
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProcessDgwt(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String procinstId = reqDTO.getValue("procinstId");
		String sql = "select t4.entity_id,  t4.proc_name,  t4.create_user_name,  t3.node_name,  decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,  t2.examine_user_name,  t2.examine_start_date,   subStr(t2.examine_end_date,0,16) examine_end_date,  t1.is_open,  t2.examine_info  from wf_r_taskinst t1  inner join (select max(taskinst_id) taskinst_id, wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst  group by procinst_id,node_id) t2 on t1.entity_id = t2.taskinst_id     and t1.procinst_id = '"
				+ procinstId
				+ "'   inner join wf_d_node t3 on t1.node_id = t3.entity_id   inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id   order by t2.examine_end_date asc";
		List list = jdbcDao.queryRecords(sql);
		reqMsg.setValue("list", list);
		return reqMsg;
	}

	/**
	 * 物资台账单件物资详细信息查询
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMatRepDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("laborId");
		String orgId = reqDTO.getValue("orgId");
		String type = reqDTO.getValue("type");
		String sql = "";
		if (orgId.equals("C6000000005263")) {
			sql = "select i.*, c.code_name, tt.stock_num, tt.actual_price,tt.total_num,tt.broken_num from (select t.wz_id, sum(t.stock_num) stock_num,sum(t.total_num) total_num,sum(t.broken_num) broken_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then 1 else sum(t.stock_num) end, 3) actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '"
					+ type
					+ "' and org_id= 'C6000000000039' and bsflag='0' and t.wz_type = '"
					+ type
					+ "' or org_id= 'C6000000000040' and bsflag='0' and t.wz_type = '"
					+ type
					+ "' or org_id= 'C6000000005269' and bsflag='0' and t.wz_type = '"
					+ type
					+ "' or org_id= 'C6000000005275' and bsflag='0' and t.wz_type = '"
					+ type
					+ "' or org_id= 'C6000000005279' and bsflag='0' and t.wz_type = '"
					+ type
					+ "' or org_id= 'C6000000005280' and bsflag='0' and t.wz_type = '"
					+ type
					+ "' or org_id= 'C6000000005278' and bsflag='0' and t.wz_type = '"
					+ type
					+ "'  group by t.wz_id) tt inner join(gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0') on tt.wz_id = i.wz_id where tt.wz_id='"
					+ id + "' order by i.coding_code_id asc, i.wz_id asc";
		} else {
			sql = "select i.*, c.code_name, tt.stock_num, tt.actual_price,tt.total_num,tt.broken_num from (select t.wz_id, sum(t.stock_num) stock_num,sum(t.total_num) total_num,sum(t.broken_num) broken_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then 1 else sum(t.stock_num) end, 3) actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '"
					+ type
					+ "' and t.org_id = '"
					+ orgId
					+ "' group by t.wz_id) tt inner join(gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0') on tt.wz_id = i.wz_id where tt.wz_id='"
					+ id + "' order by i.coding_code_id asc, i.wz_id asc";
		}
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 获得物资信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWz(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String wz_id = reqDTO.getValue("wz_id");
		String sql = "select * from GMS_MAT_INFOMATION where wz_id='" + wz_id
				+ "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	/**
	 * 大港物资台账
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getLedgerDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String wz_id = reqDTO.getValue("wz_id");
		String sql = "select * from GMS_MAT_INFOMATION where wz_id='" + wz_id
				+ "'";
		Map map = ijdbcDao.queryRecordBySQL(sql);
		reqMsg.setValue("matInfo", map);
		return reqMsg;
	}

	public ISrvMsg findMatOutRepDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("ids");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String type = reqDTO.getValue("type");
		// String sql =
		// "select org.org_abbreviation,d.out_price,d.out_num,d.total_money,info.out_date,d.out_info_detail_id from gms_mat_recyclemat_info t left join gms_mat_out_info_detail d on t.wz_id=d.wz_id left join gms_mat_out_info info on d.out_info_id=info.out_info_id and info.bsflag='0' and info.if_submit='1' and info.out_type='2' left join comm_org_information org on info.org_id=org.org_id where t.wz_type='2' and t.org_subjection_id=info.org_subjection_id and t.org_subjection_id like '"+orgSubjectionId+"%' and t.wz_id = '"+id+"'";
		// Map queryMap = jdbcDao.queryRecordBySQL(sql);
		String queryout = "select d.*,gp.project_name,org.org_abbreviation from gms_mat_teammat_info_detail d left join gp_task_project gp on d.project_info_no=gp.project_info_no left join comm_org_information org on d.org_id=org.org_id  left join gms_mat_demand_plan_flat flat on d.invoices_id=flat.invoices_id where d.bsflag='0' and d.wz_id='"
				+ id
				+ "' and flat.wz_type='"
				+ type
				+ "' and d.org_subjection_id like 'C105007%'";
		List list = pureDao.queryRecords(queryout);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 单项目物资退库信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMatOutDg(ISrvMsg reqDTO) throws Exception {
		Map map = new HashMap();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String id = reqDTO.getValue("laborId");
		String checkId = reqDTO.getValue("checkIds");
		Map reqMap = reqDTO.toMap();
		String[] ids = id.split(",");
		String[] checkIds = id.split(",");
		map.put("input_storeroom", reqMap.get("input_storeroom"));
		map.put("procure_no", reqMap.get("procure_no")); // 采购订单号
		map.put("out_date", reqMap.get("out_date"));
		map.put("storeroom", reqMap.get("storeroom")); // 发料库房/供货商/退货班组
		map.put("input_org", "专业化"); // 接收单位/采购单位 大港默认专业化
		map.put("total_money", reqMap.get("total_money")); // 合计金额
		map.put("terms_num", reqMap.get("terms_num")); // 项数
		map.put("operator", reqMap.get("operator")); // 经办/采购员/操作人
		map.put("pickupgoods", reqMap.get("pickupgoods")); // 提料/验收员
		map.put("transport_type", reqMap.get("transport_type")); // 运输方式
		map.put("storage", reqMap.get("storage")); // 发料/保管员
		map.put("note", reqMap.get("note")); // 备注
		map.put("bsflag", "0"); // 删除标记
		map.put("if_submit", "1"); // 提交标示
		map.put("out_type", "2"); // 出库方式

		map.put("create_date", new Date());
		map.put("project_info_no", projectInfoNo);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getOrgSubjectionId());
		map.put("creator_id", user.getUserId());
		map.put("UPDATOR_ID", user.getUserId());
		map.put("MODIFI_DATE", new Date());
		// 新增退货单
		Serializable outInfoId = pureDao.saveOrUpdateEntity(map,
				"gms_mat_out_info");
		// 退库、退货明细信息表
		for (int i = 0; i < ids.length; i++) {
			String wzId = ids[i].substring(0, ids[i].indexOf("_"));
			String matNum = "mat_num_" + ids[i];
			String wzPrice = "wz_price_" + ids[i];
			String totalmoney = "total_money_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			String receive_org_id = "org_id_" + ids[i];
			Map oidMap = new HashMap();
			// oidMap.put("out_info_id",outInfoId.toString() );
			oidMap.put("wz_id", wzId);
			oidMap.put("out_info_id", outInfoId);
			oidMap.put("out_num", reqMap.get(matNum));
			oidMap.put("out_price", reqMap.get(wzPrice));
			oidMap.put("total_money", reqMap.get(totalmoney));
			oidMap.put("goods_allocation", reqMap.get(goodsAllocation));
			oidMap.put("project_info_no", projectInfoNo);
			oidMap.put("bsflag", "0");
			oidMap.put("receive_org_id", reqMap.get("input_storeroom"));
			pureDao.saveOrUpdateEntity(oidMap, "gms_mat_out_info_detail");
			// 4 表示项目中退库，只需要清空库存

		}
		// 出库表添加相应数据，主表
		Map outMap = new HashMap();
		outMap.put("PLAN_INVOICE_ID", outInfoId.toString());
		outMap.put("project_info_no", projectInfoNo);
		outMap.put("bsflag", "0");
		outMap.put("out_type", "1");
		outMap.put("reocure_no", outInfoId);
		outMap.put("wz_type", "-1"); // 大港小队没有物资类型 大港代表出库到专业化中心
		outMap.put("use_type", "5110000045000000944");
		outMap.put("outmat_date", new Date());
		outMap.put("wz_type", reqMap.get("wzType"));
		Serializable outId = pureDao.saveOrUpdateEntity(outMap,
				"gms_mat_teammat_out");
		// 出库表添加相应数据，明细
		for (int j = 0; j < ids.length; j++) {
			Map outDetailMap = new HashMap();
			String wzId = ids[j].substring(0, ids[j].indexOf("_"));
			String matNum = "mat_num_" + ids[j];
			String wzPrice = "wz_price_" + ids[j];
			String totalmoney = "total_money_" + ids[j];
			outDetailMap.put("teammat_out_id", outId.toString());
			outDetailMap.put("plan_no", outInfoId.toString());
			outDetailMap.put("wz_id", wzId);
			outDetailMap.put("mat_num", reqMap.get(matNum));
			outDetailMap.put("actual_price", reqMap.get(wzPrice));
			outDetailMap.put("total_money", reqMap.get(totalmoney));
			outDetailMap.put("project_info_no", projectInfoNo);
			outDetailMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap,
					"gms_mat_teammat_out_detail");
		}
		return reqMsg;
	}

	/**
	 * 专业化物资入库---小队退库的物资
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAcceptWz(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("id");
		String[] ids = id.split(",");

		for (int i = 0; i < ids.length; i++) {
			String wz_id = "wz_id_" + ids[i];
			String wz_type = "wz_type_" + ids[i];
			Map map = new HashMap();
			String wz_number = "out_num_" + ids[i]; // 数量
			String coding_code_id = "coding_code_id_" + ids[i];
			String wz_name = "wz_name_" + ids[i];
			String wz_price_ = "out_price_" + ids[i];
			String note = "note_" + ids[i];
			String total_money = "total_money_" + ids[i];
			String source_org_id = "source_org_id_" + ids[i];
			map.put("wz_id", reqMap.get(wz_id).toString());
			map.put("actual_price", reqMap.get(wz_price_).toString());
			map.put("stock_num", reqMap.get(wz_number).toString());
			map.put("wz_type", reqMap.get(wz_type).toString());
			map.put("BSFLAG", "0");
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("UPDATOR_ID", user.getUserId());
			map.put("MODIFI_DATE", new Date());
			map.put("source_org_id", reqMap.get(source_org_id).toString());// 物资来源地
			// }
			pureDao.saveOrUpdateEntity(map, "gms_mat_recyclemat_info");
			String sql = "select out_info_detail_id,bsflag from GMS_MAT_OUT_INFO_DETAIL where out_info_detail_id='"
					+ ids[i] + "' and bsflag = '0'";
			Map detail = jdbcDao.queryRecordBySQL(sql);
			detail.put("bsflag", "5"); // 数据标记改成5，，代表已经被中心验收
			jdbcDao.saveOrUpdateEntity(detail, "GMS_MAT_OUT_INFO_DETAIL");
		}
		return reqMsg;

	}

	/**
	 * 调用ESS获取问题状态
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg selEss(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		GMSHRClient client = new GMSHRClient(null, null);
		Map avc = client.getHRDeptId(user.getLoginId());
		String ret = "";
		if(avc!=null){
			Object avcList = avc.get("list");
			if(avcList!=null){
				ret = avcList.toString();
				// String
				// ret="[{isclosed=0, questionknowledgeid=null, questionsubmitter=刘峰, questiontypeid=8ad891f53b8c8cea013b8c9501570002, subtime=2013-07-17, updatetime=2013-07-17, questiontitle=, isassigned=1, questiondesc=想请教大家一个问题：我在利用GeoEast软件进行处理过程中发现，水域中的剖面有同相轴串位问题。工区地形是渤海过渡带，采用可控震源和气枪激发，水中采用双检检波器接收。, questionsummary=, replayno=0, questionid=8ad878053febcbbb013fec5fcc1d0147, urgency=1, subflag=0, closedtime=, subuser=80267812, checkno=0, questionkeywords=, fileflag=0}, {isclosed=0, questionknowledgeid=, questionsubmitter=刘峰, questiontypeid=8ad891f53b8c8cea013b8c9501570002, subtime=2013-07-17, updatetime=2013-07-17, questiontitle=同相轴串位, isassigned=3, questiondesc=想请教大家一个问题：我在利用GeoEast软件进行处理过程中发现，水域中的剖面有同相轴串位问题。工区地形是渤海过渡带，采用可控震源和气枪激发，水中采用双检检波器接收。, questionsummary=子波整形参数不一致造成的串位, replayno=4, questionid=8ad878053febcbbb013fecbe301d0387, urgency=1, subflag=0, closedtime=2013-07-17, subuser=80267812, checkno=0, questionkeywords=同相轴串位，子波整形参数, fileflag=0}, {isclosed=0, questionknowledgeid=, questionsubmitter=刘峰, questiontypeid=8ad891f53b8c8cea013b8c9501570004, subtime=2013-07-22, updatetime=2013-07-22, questiontitle=, isassigned=2, questiondesc=大家看看这个图有什么问题吗？, questionsummary=, replayno=8, questionid=8ad8780540055cfc0140057bd089009a, urgency=0, subflag=0, closedtime=, subuser=80267812, checkno=0, questionkeywords=, fileflag=1}, {isclosed=0, questionknowledgeid=, questionsubmitter=刘峰, questiontypeid=8ad891f53b8c8cea013b8c9501570002, subtime=2013-07-17, updatetime=2013-07-17, questiontitle=同相轴串位, isassigned=3, questiondesc=想请教大家一个问题：我在利用GeoEast软件进行处理过程中发现，水域中的剖面有同相轴串位问题。工区地形是渤海过渡带，采用可控震源和气枪激发，水中采用双检检波器接收。, questionsummary=子波整形时匹配参数选取不合适, replayno=1, questionid=8ad878053febcbbb013fec60a05d0161, urgency=0, subflag=0, closedtime=2013-07-17, subuser=80267812, checkno=0, questionkeywords=同相轴串位，子波整形, fileflag=0}, {isclosed=0, questionknowledgeid=, questionsubmitter=刘峰, questiontypeid=8ad891f53b8c8cea013b8c9501570002, subtime=2013-07-18, updatetime=2013-07-18, questiontitle=, isassigned=1, questiondesc=请问GeoEast做剩余静校正时有什么注意事项？, questionsummary=, replayno=0, questionid=8ad878053fed4c9c013fef0c0e9800be, urgency=1, subflag=0, closedtime=, subuser=80267812, checkno=0, questionkeywords=, fileflag=0}]";
				// JSONObject jsons= JSONObject.fromObject(aa);
				JSONArray jsonArray = (JSONArray) JSONSerializer.toJSON(ret);
				System.out.println(jsonArray);
				reqMsg.setValue("list", jsonArray);
				reqMsg.setValue("url", avc.get("url"));
			}
			
		}
		
		return reqMsg;
	}

	/**
	 * 大港转出查询数据
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherPurOutDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentPage = reqDTO.getValue("currentPage");
		String org_id = user.getOrgId();
		String projectInfoNo = user.getProjectInfoNo();
		String wz_ids = reqDTO.getValue("wz_ids");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		// page.setPageSize(Integer.parseInt(pageSize));

		String value = reqDTO.getValue("value");
		String wz_type = "";
		List<Map> list = new ArrayList<Map>();
		String sql = "select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0'";
		if (org_id != null
				&& (org_id.equals("C6000000000039")
						|| org_id.equals("C6000000000040")
						|| org_id.equals("C6000000005275")
						|| org_id.equals("C6000000005277")
						|| org_id.equals("C6000000005278")
						|| org_id.equals("C6000000005279") || org_id
							.equals("C6000000005280"))) {
			sql += " and mti.if_center = '1' and mti.org_id='" + org_id + "'";
			wz_type = "11";
		} else {
			sql += " and mti.if_center is null";
			wz_type = "22";
		}
		sql += " and mti.project_info_no='"
				+ projectInfoNo
				+ "'  group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type = '"
				+ wz_type
				+ "' and (mto.oil_from != '1' or mto.oil_from is null)  and mto.project_info_no='"
				+ projectInfoNo
				+ "' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' where t.stock_num > '0' and t.project_info_no = '"
				+ projectInfoNo + "') a";

		// String
		// sql="select * from (select aa.wz_id,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,i.wz_price,(nvl( (aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end), 0) * nvl(i.wz_price, 0)) total_money from ( select tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"+user.getProjectInfoNo()+"' and mti.if_input='0' group by tid.wz_id )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0'  and mto.project_info_no='"+user.getProjectInfoNo()+"' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0' )";
		if (wz_ids != null && !wz_ids.equals("")) {

			sql += " where wz_id in(" + wz_ids + ")";
		}
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * DG计划表单编辑页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamEditDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));

		String planInvoiceId = reqDTO.getValue("planInvoiceId");
		List<Map> list = new ArrayList<Map>();
		String sql = "select i.wz_price,i.wz_id,i.wz_name,d.plan_detail_id,d.demand_num,d.approve_num approve_num,d.demand_date,i.note,s.coding_name from gms_mat_demand_plan_bz t inner join (gms_mat_demand_plan_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.submite_number=d.submite_number and d.bsflag='0' left join comm_coding_sort_detail s on t.s_apply_team=s.coding_code_id and s.bsflag='0' where t.plan_invoice_id='"
				+ planInvoiceId
				+ "'and t.bsflag='0' union all select i.wz_price,i.wz_id,i.wz_name,d.use_info_detail plan_detail_id,d.plan_num demand_num,d.app_num approve_num,t.create_date demand_date ,i.note,t.procure_no coding_name  from GMS_MAT_TEAMMAT_OUT t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.plan_invoice_id='"
				+ planInvoiceId + "'";
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 大港小队库存物资转出项目
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveRemoveDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String laborId = reqMap.get("laborId").toString();
		String[] ids = laborId.split(",");
		String wz_types = reqDTO.getValue("wz_types"); // 大港的类型设置为3、转出
														// ----赵阳做的，没用
		// String wzType = reqDTO.getValue("wzType");

		String wz_type = reqDTO.getValue("wz_type");

		// 生成转出单据信息
		Map outMap = new HashMap();
		outMap.put("project_info_no", projectInfoNo);
		outMap.put("input_org", reqMap.get("input_org"));
		outMap.put("operator", reqMap.get("operator"));
		outMap.put("out_date", reqMap.get("out_date"));
		outMap.put("total_money", reqMap.get("total_money"));

		outMap.put("bsflag", "0");
		outMap.put("org_id", user.getOrgId());
		outMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		outMap.put("CREATOR_ID", user.getUserId());
		outMap.put("CREATE_DATE", new Date());
		outMap.put("UPDATOR_ID", user.getUserId());
		outMap.put("MODIFI_DATE", new Date());
		outMap.put("out_type", "4");
		Serializable out_info_id = pureDao.saveOrUpdateEntity(outMap,
				"GMS_MAT_OUT_INFO");
		// 生成入库单据
		Map inMap = new HashMap();
		inMap.put("invoices_no", this.getTableNum());
		inMap.put("source", projectInfoNo);
		inMap.put("operator", reqMap.get("operator"));
		inMap.put("input_date", reqMap.get("out_date"));
		inMap.put("total_money", reqMap.get("total_money"));
		inMap.put("project_info_no", reqMap.get("input_org"));
		inMap.put("invoices_type", wz_types);
		inMap.put("if_input", "0");

		inMap.put("bsflag", "0");
		inMap.put("org_id", user.getOrgId());
		inMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		inMap.put("CREATOR_ID", user.getUserId());
		inMap.put("CREATE_DATE", new Date());
		inMap.put("UPDATOR_ID", user.getUserId());
		inMap.put("MODIFI_DATE", new Date());
		// Serializable invoices_id = pureDao.saveOrUpdateEntity(inMap,
		// "GMS_MAT_TEAMMAT_INVOICES");

		Map outMap2 = new HashMap();
		outMap2.put("PLAN_INVOICE_ID", out_info_id.toString());
		outMap2.put("project_info_no", projectInfoNo);
		outMap2.put("bsflag", "0");
		outMap2.put("WZ_TYPE", wz_type);
		Serializable outId = pureDao.saveOrUpdateEntity(outMap2,
				"gms_mat_teammat_out");

		// 生成单据明细
		for (int i = 0; i < ids.length; i++) {
			// 查询物资明细
			// String sql =
			// "select t.wz_id,t.stock_num,t.actual_price,(t.stock_num*t.actual_price)total_money from gms_mat_teammat_info t  where t.project_info_no='"+projectInfoNo+"' and t.wz_id='"+ids[i]+"' and t.bsflag='0'";
			// String sql = "";
			// if(wz_types!=null&&wz_types.equals("1")){
			// sql =
			// "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,(a.stock_num*a.wz_price) total_money,a.project_info_no from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.project_info_no from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"+user.getProjectInfoNo()+"' and mti.if_input='0' and mti.invoices_type='2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='"+user.getProjectInfoNo()+"' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"+user.getProjectInfoNo()+"' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"+user.getProjectInfoNo()+"') a where a.project_info_no='"+projectInfoNo+"' and a.wz_id='"+ids[i]+"'";
			// }else if(wz_types!=null&&wz_types.equals("2")){
			// sql =
			// "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num, (nvl(a.stock_num,0)*nvl(a.wz_price,0)) total_money,a.project_info_no from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,t.avg_price wz_price,t.stock_num,t.mat_num,t.out_num,T.PROJECT_INFO_NO from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"+user.getProjectInfoNo()+"' and mti.if_input='0' and mti.invoices_type='1' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='"+user.getProjectInfoNo()+"' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"+user.getProjectInfoNo()+"' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"+user.getProjectInfoNo()+"') a  where a.project_info_no='"+projectInfoNo+"' and a.wz_id='"+ids[i]+"'";
			// }else{
			// sql =
			// "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,(a.stock_num*a.wz_price) total_money,a.project_info_no from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.project_info_no from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='"+user.getProjectInfoNo()+"' and mti.if_input='0' and mti.invoices_type<>'2' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='0' and mto.project_info_no='"+user.getProjectInfoNo()+"' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"+user.getProjectInfoNo()+"' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"+user.getProjectInfoNo()+"') a where a.project_info_no='"+projectInfoNo+"' and a.wz_id='"+ids[i]+"'";
			// }
			// Map getMat = pureDao.queryRecordBySQL(sql);
			// 生成转出单据明细
			Map outDetailMap = new HashMap();
			outDetailMap.put("out_info_id", out_info_id.toString());
			outDetailMap.put("wz_id", ids[i]);
			outDetailMap.put("out_price", reqMap.get("wz_price_" + ids[i]));
			outDetailMap.put("out_num", reqMap.get("stock_num_" + ids[i]));
			outDetailMap
					.put("total_money", reqMap.get("total_money_" + ids[i]));
			outDetailMap.put("project_info_no", projectInfoNo);
			outDetailMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap, "GMS_MAT_OUT_INFO_DETAIL");
			// 生成入库单据明细
			Map inDetailMap = new HashMap();
			// inDetailMap.put("invoices_id", invoices_id.toString());
			inDetailMap.put("wz_id", ids[i]);
			inDetailMap.put("actual_price", reqMap.get("wz_price_" + ids[i]));
			inDetailMap.put("mat_num", reqMap.get("stock_num_" + ids[i]));
			inDetailMap.put("total_money", reqMap.get("total_money_" + ids[i]));
			inDetailMap.put("project_info_no", reqMap.get("input_org"));
			inDetailMap.put("bsflag", "0");
			inDetailMap.put("if_accept", "0");

			inDetailMap.put("org_id", user.getOrgId());
			inDetailMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
			inDetailMap.put("CREATOR_ID", user.getUserId());
			inDetailMap.put("CREATE_DATE", new Date());
			inDetailMap.put("UPDATOR_ID", user.getUserId());
			inDetailMap.put("MODIFI_DATE", new Date());
			// pureDao.saveOrUpdateEntity(inDetailMap,
			// "GMS_MAT_TEAMMAT_INFO_DETAIL");
			// 减少小队库存
			// String upSql =
			// "update gms_mat_teammat_info t set t.stock_num='0' where t.project_info_no='"+projectInfoNo+"' and t.wz_id='"+ids[i]+"' and t.bsflag='0'";
			// jdbcDao.executeUpdate(upSql);

			// 转出的物资设置成（物资领用明细）
			Map outDetailMap2 = new HashMap();
			outDetailMap2.put("teammat_out_id", outId.toString());
			outDetailMap2.put("wz_id", ids[i]);
			outDetailMap2.put("mat_num", reqMap.get("stock_num_" + ids[i]));
			outDetailMap2.put("actual_price", reqMap.get("wz_price_" + ids[i]));
			outDetailMap2.put("total_money",
					reqMap.get("total_money_" + ids[i]));
			outDetailMap2.put("project_info_no", projectInfoNo);
			outDetailMap2.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(outDetailMap2,
					"gms_mat_teammat_out_detail");

		}
		return reqMsg;
	}

	/**
	 * 班组退货信息保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveTeamOutDg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		Map reqMap = reqDTO.toMap();
		String id = reqDTO.getValue("laborId");
		String[] ids = id.split(",");
		// 保存退库单据
		Map outMap = new HashMap();
		outMap.put("invoices_id", reqMap.get("invoices_id"));
		outMap.put("out_date", reqMap.get("out_date"));
		outMap.put("procure_no", reqMap.get("procure_no"));
		outMap.put("operator", reqMap.get("operator"));
		outMap.put("note", reqMap.get("note"));
		outMap.put("total_money", reqMap.get("total_money"));
		outMap.put("team_id", reqMap.get("s_apply_team"));

		outMap.put("storeroom", reqMap.get("storeroom"));
		outMap.put("bsflag", "0");
		outMap.put("if_submit", "1");
		outMap.put("out_type", "3");
		outMap.put("creator_id", user.getUserId());
		outMap.put("create_date", new Date());
		outMap.put("org_id", user.getOrgId());
		outMap.put("ORG_SUBJECTION_ID", user.getOrgSubjectionId());
		outMap.put("project_info_no", projectInfoId);
		Serializable outInfoId = pureDao.saveOrUpdateEntity(outMap,
				"gms_mat_out_info");
		// 保存退库物资明细
		for (int i = 0; i < ids.length; i++) {
			String matNum = "mat_num_" + ids[i];
			String wzPrice = "wz_price_" + ids[i];
			String totalMoney = "total_money_" + ids[i];
			String goodsAllocation = "goods_allocation_" + ids[i];
			Map detailMap = new HashMap();
			detailMap.put("out_info_id", outInfoId.toString());
			detailMap.put("wz_id", ids[i]);
			detailMap.put("out_price", reqMap.get(wzPrice));
			detailMap.put("out_num", reqMap.get(matNum));
			detailMap.put("total_money", reqMap.get(totalMoney));
			detailMap.put("goods_allocation", reqMap.get(goodsAllocation));
			detailMap.put("bsflag", "0");
			detailMap.put("project_info_no", projectInfoId);
			pureDao.saveOrUpdateEntity(detailMap, "gms_mat_out_info_detail");
			// 查询出库数量
			String outsql = "select d.out_detail_id,d.mat_num as out_num from gms_mat_teammat_out_detail d left join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id where d.wz_id='"
					+ ids[i]
					+ "' and d.project_info_no='"
					+ projectInfoId
					+ "' and t.bsflag='0' and rownum=1 order by d.mat_num desc  ";
			Map queryMap = pureDao.queryRecordBySQL(outsql);
			double outNum = Double.valueOf(queryMap.get("out_num").toString());
			outNum -= Double.valueOf(reqMap.get(matNum).toString());
			String updateSql = "update gms_mat_teammat_out_detail d set d.mat_num = '"
					+ outNum
					+ "' where d.out_detail_id='"
					+ queryMap.get("out_detail_id") + "'";
			jdbcDao.executeUpdate(updateSql);
		}
		/*
		 * //生成入库单据 Map tiMap = new HashMap(); tiMap.put("procure_no",
		 * outInfoId.toString()); tiMap.put("invoices_type", "5");
		 * tiMap.put("if_input", "1"); tiMap.put("bsflag", "0");
		 * tiMap.put("project_info_no", projectInfoId); tiMap.put("creator_id",
		 * user.getUserId()); tiMap.put("create_date", new Date());
		 * tiMap.put("org_id", user.getOrgId()); tiMap.put("ORG_SUBJECTION_ID",
		 * user.getOrgSubjectionId()); Serializable
		 * invoicesId=pureDao.saveOrUpdateEntity(tiMap,
		 * "gms_mat_teammat_invoices");
		 * 
		 * //生成入库明细 for(int i=0;i<ids.length;i++){ String matNum =
		 * "mat_num_"+ids[i]; String wzPrice = "wz_price_"+ids[i]; String
		 * totalMoney = "total_money_"+ids[i]; String goodsAllocation =
		 * "goods_allocation_"+ids[i]; Map detailMap = new HashMap();
		 * detailMap.put("invoices_id", invoicesId.toString());
		 * detailMap.put("wz_id", ids[i]); detailMap.put("actual_price",
		 * reqMap.get(wzPrice)); detailMap.put("mat_num", reqMap.get(matNum));
		 * detailMap.put("total_money", reqMap.get(totalMoney));
		 * detailMap.put("goods_allocation", reqMap.get(goodsAllocation));
		 * detailMap.put("bsflag", "0"); detailMap.put("if_accept", "1");
		 * detailMap.put("project_info_no", projectInfoId);
		 * detailMap.put("creator_id", user.getUserId());
		 * detailMap.put("create_date", new Date()); detailMap.put("org_id",
		 * user.getOrgId()); detailMap.put("ORG_SUBJECTION_ID",
		 * user.getOrgSubjectionId()); pureDao.saveOrUpdateEntity(detailMap,
		 * "gms_mat_teammat_info_detail"); }
		 */

		return reqMsg;
	}

	/**
	 * 其他物资出库修改页面初始化
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOutDetailDg(ISrvMsg reqDTO) throws Exception {
		System.out.println("getRepMatLeaf");

		UserToken user = reqDTO.getUserToken();
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
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
		// page.setPageSize(Integer.parseInt(pageSize));
		String projectInfoNo = user.getProjectInfoNo();
		String value = reqDTO.getValue("value");
		String wz_type = reqDTO.getValue("wz_type");
		String org_id = user.getOrgId();
		List<Map> list = new ArrayList<Map>();
		String sql = "";
		// String
		// sql="select i.wz_name,i.wz_id,i.wz_prickie,i.wz_price,d.actual_price,d.mat_num,d.total_money,d.out_detail_id from gms_mat_teammat_out_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.teammat_out_id='"+value+"' order by i.wz_id asc";
		if (wz_type != null && wz_type.equals("1")) {
			sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num, a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name,i.wz_id, i.wz_name, i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from gms_mat_teammat_out_detail od left join (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, i.coding_code_id,i.wz_name, i.wz_prickie, i.note, aa.project_info_no from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no = '"
					+ projectInfoNo
					+ "' and mti.if_input = '0' and mti.invoices_type='2' group by tid.wz_id, tid.project_info_no) aa left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type='1' and (mto.oil_from != '1' or mto.oil_from is null) and mto.project_info_no = '"
					+ projectInfoNo
					+ "' and mto.teammat_out_id<>'"
					+ value
					+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') t on t.wz_id=od.wz_id  inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id, s.coding_name from gms_mat_demand_plan_detail d inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
					+ projectInfoNo
					+ "' group by d.wz_id, s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ projectInfoNo
					+ "' and od.teammat_out_id='"
					+ value
					+ "') a order by a.wz_id asc";
		} else if (wz_type != null && wz_type.equals("2")) {
			sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num, a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name,i.wz_id, i.wz_name, i.wz_prickie,t.avg_price wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from gms_mat_teammat_out_detail od left join (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num,round((aa.in_price-case when bb.out_price is null then 0 else bb.out_price end)/ case when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) is null then 1 when (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end)=0 then 1 else (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) end,3) avg_price, i.coding_code_id,i.wz_name, i.wz_prickie, i.note, aa.project_info_no from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num) mat_num,sum(nvl(tid.actual_price,0)*nvl(tid.mat_num,0)) in_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no = '"
					+ projectInfoNo
					+ "' and mti.if_input = '0' and mti.invoices_type='1' group by tid.wz_id, tid.project_info_no) aa left join (select tod.wz_id, sum(tod.mat_num) out_num,sum(nvl(tod.actual_price,0)*nvl(tod.mat_num,0)) out_price  from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type='2' and (mto.oil_from != '1' or mto.oil_from is null) and mto.project_info_no = '"
					+ projectInfoNo
					+ "' and mto.teammat_out_id<>'"
					+ value
					+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') t on t.wz_id=od.wz_id  inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id, s.coding_name from gms_mat_demand_plan_detail d inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
					+ projectInfoNo
					+ "' group by d.wz_id, s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ projectInfoNo
					+ "' and od.teammat_out_id='"
					+ value
					+ "') a order by a.wz_id asc";
		} else {
			sql = "select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num, a.mat_num,a.out_num,a.sss,a.total_money from (select dd.coding_name,i.wz_id, i.wz_name, i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,od.mat_num sss,od.total_money from gms_mat_teammat_out_detail od left join (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, i.coding_code_id,i.wz_name, i.wz_prickie, i.note, aa.project_info_no from (select tid.project_info_no, tid.wz_id, sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' where mti.bsflag = '0' and mti.project_info_no = '"
					+ projectInfoNo + "' and mti.if_input = '0'";
			if (org_id != null
					&& (org_id.equals("C6000000000039")
							|| org_id.equals("C6000000000040")
							|| org_id.equals("C6000000005275")
							|| org_id.equals("C6000000005277")
							|| org_id.equals("C6000000005278")
							|| org_id.equals("C6000000005279") || org_id
								.equals("C6000000005280"))) {
				sql += " and mti.if_center = '1' and mti.org_id='" + org_id
						+ "'";
				wz_type = "11";
			} else {
				sql += " and mti.if_center is null";
				wz_type = "22";
			}
			sql += "  group by tid.wz_id, tid.project_info_no) aa left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.wz_type='"
					+ wz_type
					+ "' and (mto.oil_from != '1' or mto.oil_from is null) and mto.project_info_no = '"
					+ projectInfoNo
					+ "' and mto.teammat_out_id<>'"
					+ value
					+ "' group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') t on t.wz_id=od.wz_id  inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id, s.coding_name from gms_mat_demand_plan_detail d inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '"
					+ projectInfoNo
					+ "' group by d.wz_id, s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '"
					+ projectInfoNo
					+ "' and od.teammat_out_id='"
					+ value
					+ "') a order by a.wz_id asc";
		}
		list = jdbcDao.queryRecords(sql);
		pageSize = String.valueOf(list.size());
		page.setPageSize(Integer.parseInt(pageSize));
		reqMsg.setValue("datas", list);
		reqMsg.setValue("totalRows", page.getTotalRow());
		reqMsg.setValue("pageCount", page.getPageCount());
		reqMsg.setValue("pageSize", pageSize);
		reqMsg.setValue("currentPage", currentPage);

		return reqMsg;
	}

	/**
	 * 提交计划信息查询--计划接收专用
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @date 2015-03-17
	 * @author 陈冲
	 */
	public ISrvMsg getSubReceviceList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "select t.plan_id,nvl(t.have_num,'') as have_num, nvl(t.regulate_num,'') as regulate_num, nvl(t.apply_num,'') as apply_num,t.plan_money,t.demand_num,t.demand_date,m.wz_id,m.wz_name,m.wz_prickie, t.buy_num as wz_price,c.code_desc,c.code_name,t.demand_date from GMS_MAT_DEMAND_PLANS t  inner join gms_mat_infomation m on t.wz_id = m.wz_id and t.bsflag='0'and m.bsflag='0' left join gms_mat_coding_code c on m.coding_code_id=c.coding_code_id and c.bsflag='0' where t.plan_invoice_id ='"
				+ id + "' and t.bsflag='0'";
		List list = ijdbcDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/**
	 * 计划接收--计划接收专用
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @date 2015-03-17
	 * @author 陈冲
	 */
	public ISrvMsg updatePlanReceiveList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("ids");
		String sql = "update GMS_MAT_DEMAND_PLAN_INVOICES s set  s.creator_id='"
				+ user.getUserId()
				+ "',s.project_info_no='"
				+ user.getProjectInfoNo()
				+ "' where s.plan_invoice_id='"
				+ id
				+ "'";
		int result = jdbcDao.executeUpdate(sql);
		String planSql = "update GMS_MAT_DEMAND_PLANs s set  s.creator_id='"
				+ user.getUserId() + "',s.project_info_no='"
				+ user.getProjectInfoNo() + "' where s.plan_invoice_id='" + id
				+ "'";
		int resultPlan = jdbcDao.executeUpdate(planSql);
		if (result > 0 && resultPlan > 0) {
			// 将当前数据同步到物资主表与汇总表中
			String demandPlanSql = "insert into  gms_mat_demand_plan(PLAN_ID,WZ_ID,PLAN_INVOICE_ID,DEMAND_NUM,DEMAND_DATE,TEAM_ID,HAVE_NUM,REGULATE_NUM,APPLY_NUM,PLAN_MONEY,COMPILE_DATE,"
					+ "ORG_ID,ORG_SUBJECTION_ID,CREATOR_ID,CREATE_DATE,UPDATOR_ID,MODIFI_DATE,BSFLAG,PROJECT_INFO_NO,BUY_NUM) select  PLAN_ID,WZ_ID,PLAN_INVOICE_ID,DEMAND_NUM,DEMAND_DATE,TEAM_ID,"
					+ "HAVE_NUM,REGULATE_NUM,APPLY_NUM,PLAN_MONEY,COMPILE_DATE,ORG_ID,ORG_SUBJECTION_ID,CREATOR_ID,CREATE_DATE,UPDATOR_ID,MODIFI_DATE,BSFLAG,PROJECT_INFO_NO,BUY_NUM from gms_mat_demand_plans "
					+ "s where s.plan_invoice_id='" + id + "'";
			jdbcDao.executeUpdate(demandPlanSql);
			String InvoicesSql = "insert into gms_mat_demand_plan_invoice(PLAN_INVOICE_ID,SUBMITE_IF,TEAM_ID,COMPILE_DATE,SUBMITE_NUMBER,ASKFOR_DATE,ORG_ID,ORG_SUBJECTION_ID,CREATOR_ID,CREATE_DATE,UPDATOR_ID,"
					+ "MODIFI_DATE,BSFLAG,PROJECT_INFO_NO,PROC_ID,PROC_STATUS,PROC_INST_ID,PLANVERSIONS_ID,REMARK,TOTAL_MONEY,PLAN_NAME,MEMO,MAIN_PART,ASSIGN_TYPE,PLAN_INVOICE_TYPE) select PLAN_INVOICE_ID,SUBMITE_IF,TEAM_ID,COMPILE_DATE,"
					+ "SUBMITE_NUMBER,ASKFOR_DATE,ORG_ID,ORG_SUBJECTION_ID,CREATOR_ID,CREATE_DATE,UPDATOR_ID,MODIFI_DATE,BSFLAG,PROJECT_INFO_NO,PROC_ID,PROC_STATUS,PROC_INST_ID,PLANVERSIONS_ID,REMARK,TOTAL_MONEY,PLAN_NAME,MEMO,MAIN_PART,"
					+ "'0' as ASSIGN_TYPE,'物资供应' as PLAN_INVOICE_TYPE from gms_mat_demand_plan_invoices s where s.plan_invoice_id='"
					+ id + "'";
			jdbcDao.executeUpdate(InvoicesSql);

			// 默认为同步的物资计划添加审批流(-审批通过)
			Map voiceMap = new HashMap();
			voiceMap.put("busi_table_name", "gms_mat_demand_plan_invoice");
			voiceMap.put("proc_status", "3");
			voiceMap.put("business_id", id);
			voiceMap.put("proc_id", id);// 审批详情主键 这里忽略 随便写了一个主键
			voiceMap.put("bsflag", "0");
			pureDao.saveOrUpdateEntity(voiceMap, "common_busi_wf_middle");
			Map bzmap = new HashMap();
			String Listsql = "select * from gms_mat_demand_plan_invoice s where s.plan_invoice_id='"
					+ id + "'";
			Map map = ijdbcDao.queryRecordBySQL(Listsql);
			// 计划用途默认综合
			bzmap.put("plan_type", "5110000044000000001");
			// 选择班组默认队部
			bzmap.put("s_apply_team", "0110000001000000020");
			// 因取不到作业表的主键 这里不进行操作.---TASK_OBJECT_ID
			bzmap.put("CREATOR_ID", map.get("creatorId"));
			bzmap.put("CREATE_DATE", map.get("createDate").toString());
			bzmap.put("UPDATOR_ID", map.get("updatorId").toString());
			bzmap.put("MODIFI_DATE", map.get("modifiDate").toString());
			bzmap.put("BSFLAG", map.get("bsflag").toString());
			bzmap.put("PROJECT_INFO_NO", map.get("projectInfoNo").toString());
			bzmap.put("ORG_ID", map.get("orgId").toString());
			bzmap.put("ORG_SUBJECTION_ID", map.get("orgSubjectionId")
					.toString());
			bzmap.put("SUBMITE_ID", map.get("planName").toString());
			bzmap.put("TOTAL_MONEY", map.get("totalMoney").toString());
			bzmap.put("PLAN_INVOICE_ID", map.get("planInvoiceId").toString());
			bzmap.put("IF_SUBMIT_DG", "0");
			Serializable submiteNumber = pureDao.saveOrUpdateEntity(bzmap,
					"gms_mat_demand_plan_bz");
			String ListMapsql = "select * from gms_mat_demand_plan s where s.plan_invoice_id='"
					+ id + "'";
			List<Map> listMap = ijdbcDao.queryRecords(ListMapsql);
			for (int i = 0; i < listMap.size(); i++) {
				// 保存计划明细
				Map mapV = new HashMap();
				mapV.put("note", "");
				mapV.put("demand_num", listMap.get(i).get("demandNum")
						.toString());
				mapV.put("approve_num", listMap.get(i).get("applyNum")
						.toString());
				mapV.put("use_num", listMap.get(i).get("applyNum").toString());
				mapV.put("demand_date", listMap.get(i).get("demandDate")
						.toString());
				mapV.put("demand_money", listMap.get(i).get("planMoney")
						.toString());
				mapV.put("submite_number", submiteNumber.toString());
				mapV.put("wz_id", listMap.get(i).get("wzId").toString());
				mapV.put("buy_money", listMap.get(i).get("buyNum").toString());
				mapV.put("bsflag", "0");
				mapV.put("project_info_no", user.getProjectInfoNo());
				mapV.put("creator_id", user.getUserId());
				mapV.put("create_date", new Date());
				mapV.put("org_id", user.getOrgId());
				mapV.put("org_subjection_id", user.getOrgSubjectionId());
				mapV.put("team_id", user.getOrgId());
				pureDao.saveOrUpdateEntity(mapV, "gms_mat_demand_plan_detail");
				reqMsg.setValue("result", "接收成功!");
			}

		} else {
			reqMsg.setValue("result", "接收异常!");
		}
		return reqMsg;
	}

	/**
	 * 获取物资模块要导出的excel数据
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 * @author wangzheqin 2015.4.7
	 */
	public ISrvMsg getExcelData(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		// 导出标识
		String matFlag = msg.getValue("matFlag");
		// 项目号
		String projectInfoNo = msg.getValue("projectInfoNo");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		// 各班组物资消耗
		if ("gbzwzxh".equals(matFlag)) {

			String teamId = msg.getValue("teamId");// 队伍ID

			StringBuffer sb = new StringBuffer();
			sb.append(
					"select o.coding_code_id as excel_column_val0,o.wz_id as excel_column_val1,o.wz_name as excel_column_val2,o.wz_prickie as excel_column_val3,d.actual_price as excel_column_val4,d.mat_num as excel_column_val5,d.total_money as excel_column_val6, t.outmat_date as excel_column_val7 from GMS_MAT_TEAMMAT_OUT t inner join(gms_mat_teammat_out_detail d ")
					.append("inner join gms_mat_infomation o on d.wz_id = o.wz_id and o.bsflag = '0') on t.teammat_out_id = d.teammat_out_id and d.bsflag = '0' ")
					.append("where t.team_id = '")
					.append(teamId)
					.append("' ")
					.append("and t.project_info_no = '")
					.append(projectInfoNo)
					.append("' ")
					.append("and t.bsflag = '0' order by o.coding_code_id asc, o.wz_id asc");

			// 获取项目名称
			List<Map> list = jdbcDao.queryRecords(sb.toString());
			String projectName = getProjectName(projectInfoNo, "各班组物资消耗情况 ");
			String excelName = "各班组物资消耗情况 .xls";
			List<String> headerList = new ArrayList<String>();
			headerList.add("物料组");
			headerList.add("物料编码");
			headerList.add("物料描述");
			headerList.add("计量单位");
			headerList.add("单价");
			headerList.add("数量");
			headerList.add("金额(元)");
			headerList.add("发放日期");
			responseMsg.setValue("doctype", matFlag);
			responseMsg.setValue("excelName", excelName);
			responseMsg.setValue("title", projectName);
			responseMsg.setValue("excelHeader", headerList);
			responseMsg.setValue("excelData", list);
		}

		return responseMsg;
	}

	/**
	 * 获取项目名称
	 * 
	 * @param projectInfoNo
	 * @return
	 */
	public String getProjectName(String projectInfoNo, String insName) {
		String sql = "select t.project_name from gp_task_project t where t.bsflag='0' and t.project_info_no='"
				+ projectInfoNo + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (MapUtils.isNotEmpty(map)) {
			return map.get("project_name").toString();
		}
		return insName;
	}

	/**
	 * 获取班组名称
	 * 
	 * @param codeId
	 * @return
	 */
	public ISrvMsg getCodeName(ISrvMsg msg) throws Exception {

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String codeId = msg.getValue("codeId");

		String sql = "select t.coding_name from comm_coding_sort_detail t where t.coding_code_id ='"
				+ codeId + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (MapUtils.isNotEmpty(map)) {
			responseMsg
					.setValue("code_name", map.get("coding_name").toString());
		}
		return responseMsg;
	}
}

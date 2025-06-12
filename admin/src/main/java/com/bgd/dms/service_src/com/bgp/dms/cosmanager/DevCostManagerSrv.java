package com.bgp.dms.cosmanager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.ServiceUtils;
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

public class DevCostManagerSrv extends BaseService {

	public DevCostManagerSrv() {
		log = LogFactory.getLogger(DevCostManagerSrv.class);
	}

	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	/**
	 * 查询单机成本信息
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCostManagerList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCostManagerList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String s_dev_name = isrvmsg.getValue("s_dev_name");// 车牌号码
		String s_dev_model = isrvmsg.getValue("s_dev_model");// 设备类别
		String s_license_num = isrvmsg.getValue("s_license_num");// 设备名称
		String s_self_num = isrvmsg.getValue("s_self_num");// 业务类型
		String s_dev_sign = isrvmsg.getValue("s_dev_sign");// 业务类型
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select acc.dev_name,"
				+ " acc.dev_model,"
				+ "acc.self_num ,"
				+ " costt.cost_manager_id,"
				+ "  acc.license_num,"
				+ "  acc.dev_sign,"
				+ "  costt.apply_name,"
				+ "  costt.oper,"
				+ "  decode(costt.stat, '0', '审批不通过', '1', '审批通过','2','未提交','3','已提交', costt.stat) stat,"
				+ "  newt.total_money"
				+ " from dms_device_costmanager costt"
				+ " left join gms_device_account acc"
				+ "   on acc.dev_acc_id = costt.dev_acc_id"
				+ "  left join (select sum(cd.costs) total_money,cd.cost_manager_id from DMS_DEVICE_COSTMANAGER_DETAIL cd group by cd.cost_manager_id) newt"
				+ " on costt.cost_manager_id=newt.cost_manager_id where costt.bsflag='0' ");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and acc.DEV_NAME like '%" + s_dev_name + "%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and acc.DEV_MODEL like '%" + s_dev_model + "%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and acc.license_num like '%" + s_license_num
					+ "%' ");
		}
		if (StringUtils.isNotBlank(s_self_num)) {
			querySql.append(" and acc.self_num like '%" + s_self_num + "%' ");
		}
		if (StringUtils.isNotBlank(s_dev_sign)) {
			querySql.append(" and acc.dev_sign like '%" + s_dev_sign + "%' ");
		}
		if (!"C105".equals(orgSubId)) {
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and costt.SUB_ID like '" + orgSubId
						+ "%' ");
			}
		}
	 
	//	if (StringUtils.isNotBlank(sortField)) {
		//	querySql.append(" order by " + sortField + " " + sortOrder + " ");
	//	} else {
	//		querySql.append(" order by date1 nulls first,mp.fk_dev_acc_id ");
		//}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * 加载详细信息
	 * 
	 */
	public ISrvMsg queryCostManagerDList(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String cost_manager_id = msg.getValue("cost_manager_id");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.costs,d.cost_date,d1.coding_name from dms_device_costmanager_detail d left join comm_coding_sort_detail d1 on d1.coding_code_id=d.coding_code_id where d.bsflag='0' and d.cost_manager_id='"+cost_manager_id+"'");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 根据ID查询单据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCostManagerListById(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCostManagerListById");
		String cost_manager_id = isrvmsg.getValue("cost_manager_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String sql = "select costs.stat,costs.cost_manager_id,costs.dev_acc_id fk_dev_acc_id,acc.dev_name,acc.dev_model,acc.license_num,acc.self_num,acc.dev_sign,costs.oper,costs.remark,costs.apply_name from dms_device_costmanager costs left join gms_device_account acc on acc.dev_acc_id=costs.dev_acc_id where costs.bsflag='0' and  cost_manager_id='"+cost_manager_id+"'";
		Map data = jdbcDao.queryRecordBySQL(sql);
		String sqllist="select d.costs,d.cost_date,d1.coding_name,d1.coding_code_id costType from dms_device_costmanager_detail d left join comm_coding_sort_detail d1 on d1.coding_code_id=d.coding_code_id where d.bsflag='0'and d.cost_manager_id='"+cost_manager_id+"'";
		responseDTO.setValue("data", data);
		List<Map> datas=jdbcDao.queryRecords(sqllist);
		responseDTO.setValue("datas", datas);
		return responseDTO;
	}
	
	/**
	 * 单机成本删除
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delCostManagerById(ISrvMsg msg) throws Exception {
		String cost_manager_id = msg.getValue("cost_manager_id"); // 主台帐ID
		// 保养次数
		if (StringUtils.isNotBlank(cost_manager_id)) {
			String dsql1 = "update   dms_device_costmanager_detail set BSFLAG='1' where COST_MANAGER_ID='"
					+ cost_manager_id + "'";
			jdbcDao.executeUpdate(dsql1);
			String dsql2 = "update   dms_device_costmanager set BSFLAG='1' where COST_MANAGER_ID='"
					+ cost_manager_id + "'";
			jdbcDao.executeUpdate(dsql2);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 审核
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg shCostManagerById(ISrvMsg msg) throws Exception {
		String cost_manager_id = msg.getValue("cost_manager_id"); // 主台帐ID
		String stat=msg.getValue("stat");//单据状态
		// 保养次数
		if (StringUtils.isNotBlank(cost_manager_id)) {
			 
			String dsql2 = "update   dms_device_costmanager set STAT='"+stat+"' where COST_MANAGER_ID='"
					+ cost_manager_id + "'";
			jdbcDao.executeUpdate(dsql2);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 提交操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg tjCostManagerById(ISrvMsg msg) throws Exception {
		String cost_manager_id = msg.getValue("cost_manager_id"); // 主台帐ID
		String stat=msg.getValue("stat");//单据状态
		// 保养次数
		if (StringUtils.isNotBlank(cost_manager_id)) {
			 
			String dsql2 = "update   dms_device_costmanager set STAT='"+stat+"' where COST_MANAGER_ID='"
					+ cost_manager_id + "'";
			jdbcDao.executeUpdate(dsql2);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * 票据类型集合
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCostTypeList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCostTypeList");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String sql = "select coding_name,coding_code_id from comm_coding_sort_detail  d where d.coding_sort_id='5110000212' order by coding_code_id ";
		List datas = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", datas);
		return responseDTO;
	}

	/**
	 * NEWMETHOD 增加修改单机成本
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateCostManager(ISrvMsg isrvmsg) throws Exception {
		log.info("saveCostManager");
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String COST_MANAGER_ID = (String) map.get("cost_manager_id");
		String flag = (String) map.get("flag");
		String stat = (String) map.get("stat");
		String fk_dev_acc_id = (String) map.get("fk_dev_acc_id");
		//修改单据先删除在添加
		if ("update".equals(flag)) {
			String dsql1 = "update   dms_device_costmanager_detail set BSFLAG='1' where COST_MANAGER_ID='"
					+ COST_MANAGER_ID + "'";
			jdbcDao.executeUpdate(dsql1);
			String dsql2 = "update   dms_device_costmanager set BSFLAG='1' where COST_MANAGER_ID='"
					+ COST_MANAGER_ID + "'";
			jdbcDao.executeUpdate(dsql2);
		}
		Map<String, Object> costmanager = new HashMap<String, Object>();
		costmanager.put("BSFLAG", '0');
		costmanager.put("DEV_ACC_ID", fk_dev_acc_id);
		costmanager.put("CREATOR", user.getUserId());
		costmanager.put("CREATE_DATE", currentdate);
		costmanager.put("REMARK", map.get("REMARK"));
		costmanager.put("OPER", map.get("OPER"));
		//判断是否修改还是添加，修改保存以前单据状态，新建的未提交
		costmanager.put("STAT", '2');
		costmanager.put("ORG_NAME", user.getOrgName());
		costmanager.put("APPLY_NAME", map.get("APPLY_NAME"));
		costmanager.put("ORG_ID", user.getOrgId());
		costmanager.put("SUB_ID", user.getOrgSubjectionId());
		String id = (String) jdbcDao.saveEntity(costmanager,
				"DMS_DEVICE_COSTMANAGER");
		// 存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		for (Object key : map.keySet()) {

			if (((String) key).startsWith("maintenance_id")) {
				int index = ((String) key).lastIndexOf("_");
				String indexStr = ((String) key).substring(index + 1);
				String cost_date = "to_date('"
						+ (String) map.get("cost_date_" + indexStr)
						+ "','yyyy-MM-dd')";
				String costType = (String) map.get("costType_" + indexStr);
				String costs = (String) map.get("costs_" + indexStr);

				// 保存生成的sql，主键为空值，保存否则修改

				String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
				String addsql = "INSERT INTO DMS_DEVICE_COSTMANAGER_DETAIL (COST_MANAGER_D_ID,CODING_CODE_ID ,COSTS, COST_DATE, BSFLAG, COST_MANAGER_ID) "
						+ "VALUES ('"
						+ iuuid
						+ "','"
						+ costType
						+ "','"
						+ costs + "'," + cost_date + ",'0','" + id + "')";
				sqlList.add(addsql);

			}
		}

		try {
			if (CollectionUtils.isNotEmpty(sqlList)) {
				String str[] = new String[sqlList.size()];
				String strings[] = sqlList.toArray(str);
				// 批处理操作
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}

}

package com.bgp.dms.purchase;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import com.bgp.gms.service.rm.dm.util.DevUtil;
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

import net.sf.json.JSONArray;

/**
 * 
 * @author dushuai
 * 
 */
public class PurchaseSrv extends BaseService {

	public PurchaseSrv() {
		log = LogFactory.getLogger(PurchaseSrv.class);
	}

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	/**
	 * 查询采购信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCgApplyList(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		String cgOrderNum = msg.getValue("cgordernum");//采购订单编号
		String contractNum = msg.getValue("contractnum");//合同号
		String supplierName = msg.getValue("suppliername");//供应商名称
		String billType = msg.getValue("billtype");//订单类型
		String cgWay = msg.getValue("cgway");//采购方式
		String cgType = msg.getValue("cgtype");//采购类别
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select case when t.creater like '8%' then emp.employee_name else t.creater end as emp_name,"
				+ " bt.coding_name as cg_order_type_name,bw.coding_name as buy_way_name,lb.coding_name as cg_lb_name,"
				+ " t.cg_apply_id,t.cg_order_num,t.contract_num,t.supplier_num,t.supplier_name,"
				+ " to_char(to_date(t.create_date,'yyyymmdd'),'yyyy-mm-dd') as create_date"
				+ " from dms_cg_apply t"
				+ " left join comm_coding_sort_detail bt on t.cg_order_type = bt.coding_code_id"
				+ " left join comm_coding_sort_detail bw on t.buy_way = bw.coding_code_id"
				+ " left join comm_coding_sort_detail lb on lb.coding_code_id = t.zzcglb"
				+ " left join comm_human_employee_hr hr on t.creater = hr.employee_cd and hr.bsflag = '0'"
				+ " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
				+ " where t.bsflag='0' ");
		// 采购订单编号
		if (StringUtils.isNotBlank(cgOrderNum)) {
			querySql.append(" and t.cg_order_num like '%"+cgOrderNum+"%'");
		}
		// 合同号
		if (StringUtils.isNotBlank(contractNum)) {
			querySql.append(" and t.contract_num like '%"+contractNum+"%'");
		}
		// 供应商名称
		if (StringUtils.isNotBlank(supplierName)) {
			querySql.append(" and t.supplier_name like '%"+supplierName+"%'");
		}
		// 订单类型
		if (StringUtils.isNotBlank(billType)&&!"请选择...".equals(billType)) {
			querySql.append(" and t.cg_order_type = '"+billType+"'");
		}
		// 采购方式
		if (StringUtils.isNotBlank(cgWay)&&!"请选择...".equals(cgWay)) {
			querySql.append(" and t.buy_way = '"+cgWay+"'");
		}
		//采购类别
		if(StringUtils.isNotBlank(cgType)&&!"请选择...".equals(cgType)){
			querySql.append("and t.zzcglb='"+cgType+"'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc");
		}		
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询采购明细信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCgApplyDetailList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCgApplyDetailList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String cpApplyId = isrvmsg.getValue("cpApplyId");// 申请单id
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,"
				+ " case when t.line_type='H' then '设备采购' when t.line_type='I' then '费用采购' end as line_type_name"
				+ " from dms_cg_apply_detail t "
				+ " where t.bsflag='0' and t.cg_apply_id ='" + cpApplyId + "' ");
		querySql.append(" order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询分配明细信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCgApplyFPList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCgApplyFPList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String cpApplyId = isrvmsg.getValue("cpApplyId");// 单号
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.org_abbreviation as accept_org_name"
				+ " from dms_cg_apply_fp t "
				+ " left join comm_org_information t1 on t.accept_org_id = t1.org_id and t1.bsflag = '0'"
				+ " where t.bsflag = '0' and t.ebeln = '" + cpApplyId + "' ");
		querySql.append(" order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
		
	/**
	 * 查询采购信息详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCgApplyInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getCgApplyInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 申请单ID
		String cgApplyId = isrvmsg.getValue("cgApplyId");
		StringBuffer sql = new StringBuffer();
		sql.append("select case when t.creater like '8%' then emp.employee_name else t.creater end as emp_name,"
				+ " t.*,t1.org_abbreviation as org_name,"
				+ " case when t.cg_order_type='Zdb1' then '设备采购订单' when t.cg_order_type='Zdb2' then '设备费用定单' end as cg_order_type_name,"
				+ " case when t.buy_way='FS01' then '公开招标采购' when t.buy_way='FS02' then '邀请招标采购' when t.buy_way='FS03' then '询价采购'"
				+ " when t.buy_way='FS04' then '竞争性谈判采购' when t.buy_way='FS05' then '单一来源采购' when t.buy_way='FS06' then '反向拍卖'" 
				+ " when t.buy_way='FS07' then '目录采购自动匹配' when t.buy_way='FS08' then '目录采购手工点选' when t.buy_way='FS09' then '参照目录式采购'" 
				+ " when t.buy_way='FS10' then '框架采购' end as buy_way_name,"
				+ " case when t.isdevice='1' then '设备' when t.isdevice='0' then '物资' end as isdevice_name"
				+ " from dms_cg_apply t "
				+ " left join comm_org_information t1 on t1.org_id=t1.org_id and t1.bsflag='0'"
				+ " left join comm_human_employee_hr hr on t.creater = hr.employee_cd and hr.bsflag = '0'"
				+ " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
				+ " where t.bsflag='0'");
		// 申请单ID
		if (StringUtils.isNotBlank(cgApplyId)) {
			sql.append(" and t.cg_apply_id  = '" + cgApplyId + "'");
		}
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	/**
	 * 获得采购订单的采购方式和采购类别
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getPurchTypeInfo(ISrvMsg msg) throws Exception {
		String purchCode = msg.getValue("purchcode");// w:采购方式  t：采购类别
		String posSql = "";
		if (DevUtil.isValueNotNull(purchCode)) {
			posSql = "select coding_code_id as code, coding_name as note"
					+ " from comm_coding_sort_detail"
					+ " where bsflag = '0' and coding_sort_id = '"+purchCode+"'"
					+ " order by coding_code_id";
		}
		List list = jdbcDao.queryRecords(posSql.toString());
		JSONArray retJson = JSONArray.fromObject(list);
		ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);
		if (retJson == null) {
			outmsg.setValue("json", "[]");
		} else {
			outmsg.setValue("json", retJson.toString());
		}
		return outmsg;
	}
	/**
	 * NEWMETHOD 采购订单主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCGApplyMainInfo(ISrvMsg reqDTO) throws Exception {
		String cgApplyId = reqDTO.getValue("cgapplyid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select case when t.creater like '8%' then emp.employee_name else t.creater end as emp_name,"
						+ " bt.coding_name as cg_order_type_name,bw.coding_name as buy_way_name,t.supplier_name,"
						+ " lb.coding_name as cg_lb_name,t.cg_order_num,t.contract_num,t.supplier_num,"
						+ " to_char(to_date(t.create_date,'yyyymmdd'),'yyyy-mm-dd') as create_date"
						+ " from dms_cg_apply t"
						+ " left join comm_coding_sort_detail bt on t.cg_order_type = bt.coding_code_id"
						+ " left join comm_coding_sort_detail bw on t.buy_way = bw.coding_code_id"
						+ " left join comm_coding_sort_detail lb on lb.coding_code_id = t.zzcglb"
						+ " left join comm_human_employee_hr hr on t.creater = hr.employee_cd and hr.bsflag = '0'"
						+ " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
						+ " where t.cg_apply_id = '"+cgApplyId+"'");
		Map cdApplyMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(cdApplyMap)) {
			responseMsg.setValue("data", cdApplyMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 采购订单明细信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCGApplyDet(ISrvMsg msg) throws Exception {
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
		String cgApplyId = msg.getValue("cgapplyid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.dms_cg_apply_detail_id,cd.dev_ci_name as dev_name,t.line_num,"
				+ " case when t.line_type = 'H' then '设备采购' when t.line_type = 'I' then '费用采购' end as line_type_name,"
				+ " t.material_code,t.material_desc,t.amount,t.amount_money,t.meas_unit,t.unit_price,"
				+ " t.banfn_cg,t.banfn_xq,t.currency,t.material_group,t.dev_coding"
				+ " from dms_cg_apply_detail t"
				+ " left join gms_device_codeinfo cd on cd.dev_ci_code = t.dev_coding"
				+ " where t.bsflag = '0' and t.cg_apply_id = '"+cgApplyId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc,t.dms_cg_apply_detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 采购订单分配明细信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryFPApplyDet(ISrvMsg msg) throws Exception {
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
		String cgOrderNum = msg.getValue("cgordernum");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.dev_coding,cd.dev_ci_name as dev_name,org.org_abbreviation as accept_org_name,"
				+ " t.fp_id,t.material_code,t.line_num,t.material_desc,t.material_group,"
				+ " org.org_name as orgname,t.amount,t.amount_money,t.unit_price,t.meas_unit,t.currency"
				+ " from dms_cg_apply_fp t "
				+ " left join comm_org_information org on t.accept_org_id = org.org_id and org.bsflag = '0'"
				+ " left join gms_device_codeinfo cd on cd.dev_ci_code = t.dev_coding"
				+ " where t.bsflag = '0' and t.ebeln = '"+cgOrderNum+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}

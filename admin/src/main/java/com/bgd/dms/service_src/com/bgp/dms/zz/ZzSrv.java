package com.bgp.dms.zz;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * project: 东方物探设备体系信息化系统
 * 
 * creator: 陈冲
 * 
 * creator time:2015-9-7
 * 
 * description:设备转资增值业务类
 * 
 */
public class ZzSrv  extends BaseService{
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private WFCommonBean wfBean;
	
	public ZzSrv() {
		wfBean = (WFCommonBean) BeanFactory.getBean("WFCommonBean");
	}
	/**
	 * 查询转资列表信息
	 * 1：创建
		2：已申请
		3：未转资
		4：已转资
		5：删除
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZzList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String zz_no = isrvmsg.getValue("zz_no");// 转资单号
		String cg_order_num = isrvmsg.getValue("cg_order_num");// 采购单号
		String zz_state = isrvmsg.getValue("zz_state");// 转资状态
		String flag = isrvmsg.getValue("flag");// 未转资标识 1 为未转资 null为已转资
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num," +
				"f.zz_date,f.zz_money,f.lifnr_name," +
				"f.zz_num,f.batch_plan,f.creator," +
				"z.org_abbreviation as org_name," +
				"case when f.zz_state='1' then '创建' " +
				"when f.zz_state='2' then '已申请' " +
				"when f.zz_state='3' then '未转资' " +
				"when f.zz_state='4' then '已转资' end as zz_state_desc " +
				"from dms_zz_info f ");
		querySql.append("left join comm_org_information z on f.org_id=z.org_id  where f.bsflag='0' ");
		log.info("flag=" + flag);
		if("1".equals(flag)){
			querySql.append(" and  (f.zz_state = '1' or f.zz_state = '2' or f.zz_state = '3' or f.zz_state = '4') ");
		}else{
			querySql.append(" and  f.zz_state = '4' ");
		}
		
		
		// 转资单号
		if (StringUtils.isNotBlank(zz_no)) {
			querySql.append(" and f.zz_no  like '%"+zz_no+"'%");
		}
		// 采购单号
		if (StringUtils.isNotBlank(cg_order_num)) {
			querySql.append(" and f.cg_order_num  like '%"+cg_order_num+"%'");
		}
		// 转资状态
		if (StringUtils.isNotBlank(zz_state)) {
			querySql.append(" and f.zz_state='"+zz_state+"'");
		}
		// 转资状态
		if (StringUtils.isNotBlank(flag)) {
		querySql.append(" and f.cg_order_num is null");
		}
		querySql.append(" order by  f.zz_state, f.zz_date desc ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * 查询转资基本信息
	 * 
	 */
	public ISrvMsg getZzInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		String zz_id = isrvmsg.getValue("zz_id");// 转资单号
		String cg_order_num = isrvmsg.getValue("cg_order_num");// 采购单号
		String zz_state = isrvmsg.getValue("zz_state");// 转资状态
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num,f.zz_date,f.zz_money,f.lifnr_name,f.zz_num,f.batch_plan,f.creator,z.org_abbreviation as org_name,case when f.zz_state='1' then '创建' when f.zz_state='2' then '已申请' when f.zz_state='3' then '未转资' when f.zz_state='4' then '已转资' end as zz_state_desc from dms_zz_info f ");
		querySql.append(" left join comm_org_subjection s on f.org_sub_id=s.org_subjection_id left join comm_org_information z on z.org_id=s.org_id  ");
		querySql.append("  where f.bsflag='0' and f.zz_state!='5' ");
		// 申请单ID
		if (StringUtils.isNotBlank(zz_id)) {
			querySql.append(" and f.zz_id  = '"+zz_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceMap", deviceappMap);
		}
		return responseDTO;
	}

	/**
	 * 查询转资设备信息
	 * 
	 */
	public ISrvMsg getZzDetailInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_id = isrvmsg.getValue("zz_id");// 转资单号
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select d.*,i.org_abbreviation org_name from dms_zz_detailed d  left join dms_zz_info f on f.zz_id=d.zz_id ")
		.append(" left join bgp_comm_erp_org_info e on d.zzssdw=e.erp_org_info_id and e.bsflag='0' ")
		.append(" left join comm_org_information i on e.gms_org_id=i.org_id and i.bsflag='0' ")
		.append(" where d.bsflag='0' ");
		// 申请单ID
		if (StringUtils.isNotBlank(zz_id)) {
			querySql.append(" and f.zz_id  = '"+zz_id+"'");
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querySql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 查询转资列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryzAddList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String valueadd_id = isrvmsg.getValue("valueadd_id");// 增值单号
		String bsflag = isrvmsg.getValue("bsflag");// 增值状态
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.*,case when f.bsflag='1' then '创建' when f.bsflag='2' then '已申请' when f.bsflag='3' then '未增值' when f.bsflag='4' then '已增值' end as bsflag_desc, case when f.isdevice='0' then '物资' when f.isdevice='1' then '设备' else '' end as isdevice_desc from Dms_Equi_Valueadd_Info f where f.bsflag!='5' ");
		// 增值单号
		if (StringUtils.isNotBlank(valueadd_id)) {
			querySql.append(" and f.valueadd_id  like '%"+valueadd_id+"%'");
		}
		// 增值状态
		if (StringUtils.isNotBlank(bsflag)) {
			querySql.append(" and f.bsflag='"+bsflag+"'");
		}
		querySql.append(" order by  f.bsflag, f.create_date desc ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询增值基本信息
	 * 
	 */
	public ISrvMsg getzAddInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_info_id = isrvmsg.getValue("zz_info_id");// 转资单号
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.*,case when f.bsflag='1' then '创建' when f.bsflag='2' then '已申请' when f.bsflag='3' then '未增值' when f.bsflag='4' then '已增值' end as bsflag_desc, case when f.isdevice='0' then '物资' when f.isdevice='1' then '设备' else '' end as isdevice_desc from Dms_Equi_Valueadd_Info f where f.bsflag!='5' and f.zz_info_id='"+zz_info_id+"' ");
		Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceMap", deviceappMap);
		}
		return responseDTO;
	}
	
	/**
	 * 查询增值设备信息
	 * 
	 */
	public ISrvMsg getzAddDetailInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_info_id = isrvmsg.getValue("zz_info_id");// 转资单号
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select * from Dms_Equi_Valueadd_Detail d " +
				" join Dms_Equi_Valueadd_Info f on f.zz_info_id=d.zz_info_id ");
		// 增值单ID
		if (StringUtils.isNotBlank(zz_info_id)) {
			querySql.append(" and f.zz_info_id  = '"+zz_info_id+"'");
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querySql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * 查询转资列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryTranAssetList(ISrvMsg msg) throws Exception {
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
		String zzNo = msg.getValue("zzno");// 转资单号
		String zzOrgName = msg.getValue("zzorgname");// 转资机构名称
		String cgOrderNum = msg.getValue("cgordernum");// 采购单号
		String lifnrName = msg.getValue("lifnrname");// 供应商名称
		String zzState = msg.getValue("zzstate");// 转资状态
		String batchPlan = msg.getValue("batchplan");// 批次计划
		String creatorName = msg.getValue("creatorname");// 创建人
		String zzNumStart = msg.getValue("zznumstart");// 转资起始台数
		String zzNumEnd = msg.getValue("zznumend");// 转资结束台数
		String zzMoneyStart = msg.getValue("zzmoneystart");// 转资起始总金额
		String zzMoneyend = msg.getValue("zzmoneyend");// 转资结束总金额
		String zzDateStart = msg.getValue("zzdatestart");// 创建起始时间
		String zzDateEnd = msg.getValue("zzdateend");// 创建结束时间
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
					+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
					+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
					+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,info.org_name,"
					+ " case when f.zz_state = '1' then '创建' when f.zz_state = '2' then '已申请'"
					+ " when f.zz_state = '3' then '未转资' when f.zz_state = '4' then '已转资' end as zz_state_desc"
					+ " from dms_zz_info f"
					+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
	                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					+ " left join comm_org_information info on f.org_id = info.org_id and info.bsflag = '0'"
					+ " where f.bsflag = '0'");				
		// 转资单号
		if (StringUtils.isNotBlank(zzNo)) {
			querySql.append(" and f.zz_no  like '%"+zzNo+"%'");
		}
		// 转资机构
		if (StringUtils.isNotBlank(zzOrgName)) {
			querySql.append(" and info.org_name like '%"+zzOrgName+"%'");
		}
		// 采购单号
		if (StringUtils.isNotBlank(cgOrderNum)) {
			querySql.append(" and f.cg_order_num like '%"+cgOrderNum+"%'");
		}
		// 供应商名称
		if (StringUtils.isNotBlank(lifnrName)) {
			querySql.append(" and f.lifnr_name like '%"+lifnrName+"%'");
		}
		// 批次计划
		if (StringUtils.isNotBlank(batchPlan)) {
			querySql.append(" and f.batch_plan like '%"+batchPlan+"%'");
		}
		// 创建人
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creator like '%"+creatorName+"%')");
		}
		// 转资状态
		if (StringUtils.isNotBlank(zzState)) {
			querySql.append(" and f.zz_state = '"+zzState+"'");
		}
		//转资台数
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"' and f.zz_num <= '"+zzNumEnd+"'");
		}
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"'");
		}
		if(StringUtils.isBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num <= '"+zzNumEnd+"'");
		}
		//转资总金额
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"' and f.zz_money <= '"+zzMoneyend+"'");
		}
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"'");
		}
		if(StringUtils.isBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money <= '"+zzMoneyend+"'");
		}
		//创建日期
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.zz_state, f.zz_date desc ");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 转资单据主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssetMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzId = reqDTO.getValue("zzid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
						+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
						+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
						+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,"
						+ " case when f.zz_state = '1' then '创建' when f.zz_state = '2' then '已申请'"
						+ " when f.zz_state = '3' then '未转资' when f.zz_state = '4' then '已转资' end as zz_state_desc"
						+ " from dms_zz_info f"
						+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
		                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
						+ " left join comm_org_information info on info.org_id = f.org_id and info.bsflag = '0'"
						+ " where f.bsflag = '0' and f.zz_state != '5'"
						+ " and f.zz_id = '"+zzId+"'");
		Map zzMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(zzMap)) {
			responseMsg.setValue("data", zzMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 转资单据设备明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAssetDevDet(ISrvMsg msg) throws Exception {	
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
		String zzId = msg.getValue("zzid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append( "select d.zzd_id,d.eqktx,d.typbz,d.dev_coding,d.answt,"
					+ " to_char(to_date(d.inbdt, 'yyyymmdd'), 'yyyy-mm-dd') as inbdt,"
					+ " info.org_abbreviation as own_org_name,info.org_name"
					+ " from dms_zz_detailed d"
					+ " left join comm_org_information info on info.org_id = d.org_id and info.bsflag = '0'"
					+ " where d.bsflag = '0' and d.zz_id = '"+zzId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date desc,d.zzd_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询增值列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseValueList(ISrvMsg msg) throws Exception {
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
		String valueId = msg.getValue("valueid");// 增值单号
		String valueContent = msg.getValue("valuecontent");// 增值内容
		String valueState = msg.getValue("valuestate");// 增值状态
		String creatorName = msg.getValue("creatorname");// 创建人
		String valueMoneyStart = msg.getValue("valuemoneystart");// 增值起始总金额
		String valueMoneyend = msg.getValue("valuemoneyend");// 增值结束总金额
		String createDateStart = msg.getValue("createdatestart");// 创建起始时间
		String createDateEnd = msg.getValue("createdateend");// 创建结束时间
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				      + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					  + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				      + " case when f.bsflag = '1' then '创建' when f.bsflag = '2' then '已申请'"
					  + " when f.bsflag = '3' then '待增值' when f.bsflag = '4' then '已增值' end as bsflag_desc"
					  + " from dms_equi_valueadd_info f"
					  + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					  + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
				      + " where f.bsflag!='5' ");				
		// 增值单号
		if (StringUtils.isNotBlank(valueId)) {
			querySql.append(" and f.valueadd_id  like '%"+valueId+"%'");
		}
		// 增值内容
		if (StringUtils.isNotBlank(valueContent)) {
			querySql.append(" and f.valueadd_content like '%"+valueContent+"%'");
		}
		// 创建人
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creater like '%"+creatorName+"%')");
		}
		// 增值状态
		if (StringUtils.isNotBlank(valueState)) {
			querySql.append(" and f.bsflag = '"+valueState+"'");
		}
		//增值总金额
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"' and f.amount_money <= '"+valueMoneyend+"'");
		}
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"'");
		}
		if(StringUtils.isBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money <= '"+valueMoneyend+"'");
		}
		//创建日期
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.create_date desc,f.bsflag,f.zz_info_id");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 增值单据主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIncreaseMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzInfoId = reqDTO.getValue("zzinfoid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				       + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					   + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				       + " case when f.bsflag = '1' then '创建' when f.bsflag = '2' then '已申请'"
					   + " when f.bsflag = '3' then '待增值' when f.bsflag = '4' then '已增值' end as bsflag_desc"
					   + " from dms_equi_valueadd_info f"
					   + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					   + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					   + " where f.zz_info_id = '"+zzInfoId+"'");
		Map valueMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(valueMap)) {
			responseMsg.setValue("data", valueMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 增值单据设备明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseDevDet(ISrvMsg msg) throws Exception {	
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
		String zzInfoId = msg.getValue("zzinfoid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.dev_name,d.dev_coding,d.typbz,d.zz_detail_id,d.zzzjitem,"
					  + " d.cg_order_num,d.contract_num,d.valueadd_money"
					  + " from dms_equi_valueadd_detail d"
					  + " where d.zz_info_id = '"+zzInfoId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date,d.zz_detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询转资申请单状态
	 */
	public ISrvMsg getZzState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_id=isrvmsg.getValue("zz_id");// 报废处置申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select zzinfo.zz_id, nvl(wfmiddle.proc_status, '') as proc_status  from dms_zz_info_apply zzinfo ");
		queryScrapeInfoSql.append("join common_busi_wf_middle wfmiddle on zzinfo.zz_id = wfmiddle.business_id ");
		// 申请单ID
		if (StringUtils.isNotBlank(zz_id)) {
			queryScrapeInfoSql.append(" and zz_id  = '"+zz_id+"'");
		}
		Map zzMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(zzMap!=null){
			responseDTO.setValue("zzMap", zzMap);
		}
		return responseDTO;
	}
	/**
	 * 查询转资申请列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryzhuanziApplyList(ISrvMsg msg) throws Exception {
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
		String zzNo = msg.getValue("zzno");// 转资单号
		String zzOrgName = msg.getValue("zzorgname");// 转资机构名称
		String cgOrderNum = msg.getValue("cgordernum");// 采购单号
		String lifnrName = msg.getValue("lifnrname");// 供应商名称
		String zzState = msg.getValue("zzstate");// 转资状态
		String batchPlan = msg.getValue("batchplan");// 批次计划
		String creatorName = msg.getValue("creatorname");// 创建人
		String zzNumStart = msg.getValue("zznumstart");// 转资起始台数
		String zzNumEnd = msg.getValue("zznumend");// 转资结束台数
		String zzMoneyStart = msg.getValue("zzmoneystart");// 转资起始总金额
		String zzMoneyend = msg.getValue("zzmoneyend");// 转资结束总金额
		String zzDateStart = msg.getValue("zzdatestart");// 创建起始时间
		String zzDateEnd = msg.getValue("zzdateend");// 创建结束时间
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
					+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
					+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
					+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,info.org_name,"
					+ " case when f.zz_state = '1' then '创建' when f.zz_state = '2' then '已申请'"
					+ " when f.zz_state = '3' then '未转资' when f.zz_state = '4' then '已转资' end as zz_state_desc,"
					+ " case when t2.proc_status = '1' then '待审批' when t2.proc_status = '3' THEN '审批通过' "
					+ " when t2.proc_status = '4' then '审批不通过' else '未提交' end as apply_status"
					+ " from dms_zz_info_apply f"
					+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
	                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					+ " left join comm_org_information info on f.org_id = info.org_id and info.bsflag = '0'"
	                + " left join common_busi_wf_middle t2 on f.zz_id= t2.business_id and t2.bsflag = '0'"
					+ " where f.bsflag = '0'");
		// 转资单号
		if (StringUtils.isNotBlank(zzNo)) {
			querySql.append(" and f.zz_no  like '%"+zzNo+"%'");
		}
		// 转资机构
		if (StringUtils.isNotBlank(zzOrgName)) {
			querySql.append(" and info.org_name like '%"+zzOrgName+"%'");
		}
		// 采购单号
		if (StringUtils.isNotBlank(cgOrderNum)) {
			querySql.append(" and f.cg_order_num like '%"+cgOrderNum+"%'");
		}
		// 供应商名称
		if (StringUtils.isNotBlank(lifnrName)) {
			querySql.append(" and f.lifnr_name like '%"+lifnrName+"%'");
		}
		// 批次计划
		if (StringUtils.isNotBlank(batchPlan)) {
			querySql.append(" and f.batch_plan like '%"+batchPlan+"%'");
		}
		// 创建人
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creator like '%"+creatorName+"%')");
		}
		// 申请状态
		if (StringUtils.isNotBlank(zzState)) {
			if("2".equals(zzState.toString())) {
				querySql.append(" and (t2.proc_status IS NULL OR t2.proc_status!='2') ");
			}else {
				querySql.append(" and t2.proc_status = '"+zzState+"'");
			}
			
		}
		//转资台数
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"' and f.zz_num <= '"+zzNumEnd+"'");
		}
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"'");
		}
		if(StringUtils.isBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num <= '"+zzNumEnd+"'");
		}
		//转资总金额
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"' and f.zz_money <= '"+zzMoneyend+"'");
		}
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"'");
		}
		if(StringUtils.isBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money <= '"+zzMoneyend+"'");
		}
		//创建日期
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.zz_state, f.zz_date desc ");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 转资单据申请主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZhuanZiMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzId = reqDTO.getValue("zzid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
						+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
						+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
						+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,"
						+ " case when f.zz_state = '1' then '创建' when f.zz_state = '2' then '已申请'"
						+ " when f.zz_state = '3' then '未转资' when f.zz_state = '4' then '已转资' end as zz_state_desc"
						+ " from dms_zz_info_apply f"
						+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
		                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
						+ " left join comm_org_information info on info.org_id = f.org_id and info.bsflag = '0'"
						+ " where f.bsflag = '0' and f.zz_state != '5'"
						+ " and f.zz_id = '"+zzId+"'");
		Map zzMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(zzMap)) {
			responseMsg.setValue("data", zzMap);
		}
		return responseMsg;
	}
	/**
	 * 转资单据申请设备明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZhuanZiDevDet(ISrvMsg msg) throws Exception {	
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
		String zzId = msg.getValue("zzid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append( "select d.zzd_id,d.eqktx,d.typbz,d.dev_coding,d.answt,"
					+ " to_char(to_date(d.inbdt, 'yyyymmdd'), 'yyyy-mm-dd') as inbdt,"
					+ " d.org_name"
					+ " from dms_zz_detailed_apply d"
					+ " left join comm_org_information info on info.org_id = d.org_id and info.bsflag = '0'"
					+ " where d.bsflag = '0' and d.zz_id = '"+zzId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date desc,d.zzd_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 转资单据审核明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProcHistory(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zzid");	
		// 获取审批历史信息
		StringBuffer querySql = new StringBuffer();
		querySql.append("select proc_inst_id from common_busi_wf_middle where bsflag = '0' and business_id='"+zzId+"'");
		List<Map> procInstId = pureJdbcDao.queryRecords(querySql.toString());
		for (Map map : procInstId) {
			List listExamine = wfBean.getProcHistory(map.get("proc_inst_id").toString());
			responseDTO.setValue("datas", listExamine);
		}
		responseDTO.setValue("totalRows",1);
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 转资文件列表
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFileList(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zzid");	
		//文件数据
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.ucm_id as file_id, t.file_name,"
				+ " case when t.file_type = 'contract_purchase' then '采购合同'"
				+ " when t.file_type ='contract_device' THEN '设备验收单'"
				+ " when t.file_type ='contract_transfer' THEN '设备固定资产转资申请单'"
				+ " when t.file_type ='contract_claim' THEN '设备转资报销票据整理单' end as file_type"
				+ " from bgp_doc_gms_file t WHERE  t.bsflag = '0' and t.relation_id='"+zzId+"'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas",list);
		responseDTO.setValue("totalRows",page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询增值申请列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseApplyValueList(ISrvMsg msg) throws Exception {
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
		String valueId = msg.getValue("valueid");// 增值单号
		String valueContent = msg.getValue("valuecontent");// 增值内容
		String valueState = msg.getValue("valuestate");// 增值状态
		String creatorName = msg.getValue("creatorname");// 创建人
		String valueMoneyStart = msg.getValue("valuemoneystart");// 增值起始总金额
		String valueMoneyend = msg.getValue("valuemoneyend");// 增值结束总金额
		String createDateStart = msg.getValue("createdatestart");// 创建起始时间
		String createDateEnd = msg.getValue("createdateend");// 创建结束时间
		String zengzhiState = msg.getValue("zengzhiState");//审核状态
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				      + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					  + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				      + " case when f.bsflag = '1' then '创建' when f.bsflag = '2' then '已申请'"
					  + " when f.bsflag = '3' then '待增值' when f.bsflag = '4' then '已增值' end as bsflag_desc,"
					  + " case when t2.proc_status = '1' then '待审批' when t2.proc_status = '3' THEN '审批通过' "
					  + " when t2.proc_status = '4' then '审批不通过' else '未提交' end as apply_status"
					  + " from dms_equi_valueadd_info_apply f"
					  + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					  + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					  + " left join common_busi_wf_middle t2 on f.zz_info_id= t2.business_id and t2.bsflag = '0'"
				      + " where f.bsflag ='0' ");				
		// 增值单号
		if (StringUtils.isNotBlank(valueId)) {
			querySql.append(" and f.valueadd_id  like '%"+valueId+"%'");
		}
		// 增值内容
		if (StringUtils.isNotBlank(valueContent)) {
			querySql.append(" and f.valueadd_content like '%"+valueContent+"%'");
		}
		// 创建人
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creater like '%"+creatorName+"%')");
		}
		// 增值状态
		if (StringUtils.isNotBlank(valueState)) {
			querySql.append(" and f.bsflag = '"+valueState+"'");
		}
		// 申请状态
		if (StringUtils.isNotBlank(zengzhiState)) {
			if("2".equals(zengzhiState.toString())) {
				querySql.append(" and (t2.proc_status IS NULL OR t2.proc_status!='2') ");
			}else {
				querySql.append(" and t2.proc_status = '"+zengzhiState+"'");
			}			
		}
		//增值总金额
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"' and f.amount_money <= '"+valueMoneyend+"'");
		}
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"'");
		}
		if(StringUtils.isBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money <= '"+valueMoneyend+"'");
		}
		//创建日期
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.create_date desc,f.bsflag,f.zz_info_id");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询增值申请单状态
	 */
	public ISrvMsg getZengzState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_id=isrvmsg.getValue("zz_id");// 报废处置申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select zzinfo.zz_info_id, nvl(wfmiddle.proc_status, '') as proc_status  from dms_equi_valueadd_info_apply zzinfo ");
		queryScrapeInfoSql.append("join common_busi_wf_middle wfmiddle on zzinfo.zz_info_id = wfmiddle.business_id ");
		// 申请单ID
		if (StringUtils.isNotBlank(zz_id)) {
			queryScrapeInfoSql.append(" and zz_info_id  = '"+zz_id+"'");
		}
		Map zzMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(zzMap!=null){
			responseDTO.setValue("zzMap", zzMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD 增值申请单据主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIncreaseApplyMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzInfoId = reqDTO.getValue("zzinfoid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				       + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					   + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				       + " case when f.bsflag = '1' then '创建' when f.bsflag = '2' then '已申请'"
					   + " when f.bsflag = '3' then '待增值' when f.bsflag = '4' then '已增值' end as bsflag_desc,"
					   + " case when t2.proc_status = '1' then '待审批' when t2.proc_status = '3' THEN '审批通过' "
					   + " when t2.proc_status = '4' then '审批不通过' else '未提交' end as apply_status"
					   + " from dms_equi_valueadd_info_apply f"
					   + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					   + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					   + " left join common_busi_wf_middle t2 on f.zz_info_id= t2.business_id and t2.bsflag = '0'"
					   + " where f.zz_info_id = '"+zzInfoId+"'");
		Map valueMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(valueMap)) {
			responseMsg.setValue("data", valueMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 增值申请单据设备明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseApplyDevDet(ISrvMsg msg) throws Exception {	
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
		String zzInfoId = msg.getValue("zzinfoid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.dev_name,d.dev_coding,d.typbz,d.zz_detail_id,d.zzzjitem,"
					  + " d.cg_order_num,d.contract_num,d.valueadd_money"
					  + " from dms_equi_valueadd_detail_apply d"
					  + " where d.zz_info_id = '"+zzInfoId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date,d.zz_detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 增值单据审核明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProcZengZHistory(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zz_info_id");	
		// 获取审批历史信息
		StringBuffer querySql = new StringBuffer();
		querySql.append("select proc_inst_id from common_busi_wf_middle where bsflag = '0' and business_id='"+zzId+"'");
		List<Map> procInstId = pureJdbcDao.queryRecords(querySql.toString());
		for (Map map : procInstId) {
			List listExamine = wfBean.getProcHistory(map.get("proc_inst_id").toString());
			responseDTO.setValue("datas", listExamine);
		}
		responseDTO.setValue("totalRows",1);
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 增值文件列表
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZengZFileList(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zz_info_id");	
		//文件数据
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.ucm_id as file_id, t.file_name, t.create_date"
				+ " from bgp_doc_gms_file t WHERE  t.bsflag = '0' and t.relation_id='"+zzId+"'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas",list);
		responseDTO.setValue("totalRows",page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询消息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMessageList(ISrvMsg msg) throws Exception {
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
		
		String content = msg.getValue("content");//消息内容
		
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.*"
					+ " from dms_msg_info f"
					+ " where f.bsflag = '0'");
		//消息内容
		if (StringUtils.isNotBlank(content)) {
			querySql.append(" and f.content  like '%"+content+"%'");
		}
		
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 消息文件列表
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMsgFileList(ISrvMsg msg) throws Exception {
		
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
		
		String msg_id = msg.getValue("msg_id");	
		//文件数据
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.ucm_id as file_id, t.file_name, t.create_date"
				+ " from bgp_doc_gms_file t WHERE  t.bsflag = '0' and t.file_type = 'msg_purchase' and t.relation_id='"+msg_id+"'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas",list);
		responseDTO.setValue("totalRows",page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 消息  查询消息通知
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getMsgInfoData(ISrvMsg isrvmsg) throws Exception {
		log.info("getMsgInfoData");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql = new StringBuffer();
		queryopiInfoSql.append("SELECT * FROM DMS_MSG_INFO dmi WHERE TO_CHAR(dmi.SHOW_DATE) >= TO_CHAR(SYSDATE) and dmi.bsflag = '0'");
		List<Map> deviceappMap = jdbcDao.queryRecords(queryopiInfoSql.toString());
		responseDTO.setValue("data", deviceappMap);
		return responseDTO;
	}
}

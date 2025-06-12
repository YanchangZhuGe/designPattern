package com.bgp.dms.plan;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
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

/**
 * 
 * @author dushuai
 * 
 */
public class ExePlanSrv extends BaseService {

	public ExePlanSrv() {
		log = LogFactory.getLogger(ExePlanSrv.class);
	}

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	/**
	 * ��ѯִ�мƻ���Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePlanList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryExePlanList");
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
		String applyNum = isrvmsg.getValue("applyNum");// ����
		String orderType = isrvmsg.getValue("orderType");// ��������
		String applyYear = isrvmsg.getValue("applyYear");// ���
		String org_name = isrvmsg.getValue("org_name");
		String proc_status = isrvmsg.getValue("proc_status");
		
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t2.org_abbreviation as org_name,"
				+ " case when t.order_type='Y006' then '�豸����ƻ�' when t.order_type='Y002' then '��������ƻ�' end as order_type_name,"
				+ " case when t.is_gene='1' then '����' when t.is_gene='2' then '������' when t.is_gene='3' then '������' end as proc_status,"
				+ " case when emp.employee_name is null then t.fill_per else emp.employee_name end as employee_name"
				+ " from dms_exeplan_apply t "
				+ " left join comm_org_subjection t1 on t.org_subjection_id=t1.org_subjection_id and t1.bsflag='0'"
				+ " left join comm_org_information t2 on t1.org_id=t2.org_id and t2.bsflag='0' "
				+ " left join comm_human_employee_hr hr on t.fill_per = hr.employee_cd"
				+ " left join comm_human_employee emp on emp.employee_id = hr.employee_id"
				+ " where t.bsflag='0' ");
		// ����
		if (StringUtils.isNotBlank(applyNum)) {
			querySql.append(" and t.apply_num like '%" + applyNum + "%'");
		}
		// ���
		if (StringUtils.isNotBlank(applyYear)) {
			querySql.append(" and t.apply_year = '" + applyYear + "'");
		}
		// ��������
		if (StringUtils.isNotBlank(orderType)) {
			querySql.append(" and t.order_type= '" + orderType + "'");
		}
		// ������λ
		if (StringUtils.isNotBlank(org_name)) {
			querySql.append(" and t2.org_abbreviation like '%" + org_name + "%'");
		}
		// ����״̬
		if (StringUtils.isNotBlank(proc_status)) {
			querySql.append(" and t.is_gene= '" + proc_status + "'");
		}
		querySql.append(" order by t.order_type desc,t.is_gene,t.fill_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯִ�мƻ���ϸ��Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePlanDetailList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryExePlanDetailList");
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
		String applyId = isrvmsg.getValue("applyId");// ���뵥id
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t2.org_abbreviation as org_name from dms_exeplan_apply_detail t " 
				+ " left join comm_org_subjection t1 on t.org_subjection_id=t1.org_subjection_id and t1.bsflag='0'"
				+ " left join comm_org_information t2 on t1.org_id=t2.org_id and t2.bsflag='0' "
				+ " where t.bsflag='0' and t.apply_id ='" + applyId + "' ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ������Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryApprovalInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryExePlanDetailList");
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
		String businessId = isrvmsg.getValue("businessId");// ҵ�񵥾�id
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.* from dms_comm_wf_sync t where t.business_id ='" + businessId + "' ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ�ɹ�֪ͨ����Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryPurcList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryPurcList");
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
		String purcNum = isrvmsg.getValue("purcNum");// ����
		String purcType = isrvmsg.getValue("purcType");// �ɹ�����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t2.org_abbreviation as org_name,"
				+ " case when t.order_type='Z006' then '�豸�ɹ��ƻ�' when t.order_type='Z002' then '���ʲɹ��ƻ�' end as order_type_name,"
				+ " case when t.appstate='1' then '����' when t.appstate='2' then '������' when t.appstate='3' then '������' end as proc_status"
				+ " from dms_exeplan_purc t "
				+ " left join comm_org_subjection t1 on t.org_subjection_id=t1.org_subjection_id and t1.bsflag='0'"
				+ " left join comm_org_information t2 on t2.org_id=t1.org_id and t2.bsflag='0' "
				+ " where t.bsflag='0' ");
		// ����
		if (StringUtils.isNotBlank(purcNum)) {
			querySql.append(" and t.purc_num like '%" + purcNum + "%'");
		}
		// �ɹ�����
		if (StringUtils.isNotBlank(purcType)) {
			querySql.append(" and t.order_type = '" + purcType + "'");
		}
		querySql.append(" order by t.order_type desc,t.appstate,t.fill_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ�ɹ�֪ͨ����ϸ��Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryPurcDetailList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryPurcDetailList");
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
		String purcId = isrvmsg.getValue("purcId");// �ɹ�֪ͨ��id
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pd.*,ad.apply_num,t2.org_abbreviation as org_name"
					  + " from dms_exeplan_purc_detail pd"
					  + " left join dms_exeplan_apply_detail ad on pd.exeplan_detail_id = ad.detail_id and ad.bsflag = '0'"
					  + " left join dms_exeplan_apply app on ad.apply_num = app.apply_num  and app.bsflag = '0'"
					  + " left join comm_org_information t2 on t2.org_id = pd.org_id and t2.bsflag = '0'"
					  + " where pd.bsflag = '0' and pd.purc_id ='" + purcId + "' ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ���뵥״̬
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getApplyState(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyState");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ���뵥ID
		String applyId = isrvmsg.getValue("applyId");
		StringBuffer sql = new StringBuffer();
		sql.append("select t.apply_id, nvl(t1.proc_status, '') as proc_status  from dms_exeplan_apply t ");
		sql.append(" left join common_busi_wf_middle t1 on t.apply_id = t1.business_id  where t.bsflag='0' ");
		// ���뵥ID
		if (StringUtils.isNotBlank(applyId)) {
			sql.append(" and t.apply_id  = '" + applyId + "'");
		}
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		if (MapUtils.isNotEmpty(map)) {
			responseDTO.setValue("data", map);
		}
		return responseDTO;
	}
	/**
	 * ��ѯ����ƻ��б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePlanApplyList(ISrvMsg msg) throws Exception {
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
		String applyNum = msg.getValue("applynum");//���󵥺�
		String orderType = msg.getValue("ordertype");//��������
		String applyYear = msg.getValue("applyyear");//���
		String orgName = msg.getValue("orgname");//������λ
		String procStatus = msg.getValue("procstatus");//����״̬
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.apply_id,t.apply_num,t.apply_year,t2.org_abbreviation as org_name,"
				+ " to_char(to_date(t.fill_date, 'yyyymmdd'), 'yyyy-mm-dd') as fill_date,"
				+ " case when t.fill_per like '8%' then emp.employee_name else t.fill_per end as fill_per,"
				+ " case when t.is_gene = '1' then '����' when t.is_gene = '2' then '������' when t.is_gene = '3' then '������'"
				+ " end as proc_status,d.coding_name as order_type_name"
				+ " from dms_exeplan_apply t "
				+ " left join comm_coding_sort_detail d on d.coding_code_id = t.order_type"
				+ " left join comm_org_information t2 on t.org_id = t2.org_id and t2.bsflag = '0'"
				+ " left join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag = '0'"
				+ " left join comm_human_employee_hr hr on t.fill_per = hr.employee_cd and hr.bsflag = '0'"
				+ " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
				+ " where t.bsflag = '0' and sub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		// ���󵥺�
		if (StringUtils.isNotBlank(applyNum)) {
			querySql.append(" and t.apply_num like '%"+applyNum+"%'");
		}
		// ���
		if (StringUtils.isNotBlank(applyYear)&&!"��ѡ��...".equals(applyYear)) {
			querySql.append(" and t.apply_year = '"+applyYear+"'");
		}
		// ������λ
		if (StringUtils.isNotBlank(orgName)) {
			querySql.append(" and t2.org_name like '%"+orgName+"%'");
		}
		// ��������
		if (StringUtils.isNotBlank(orderType)&&!"��ѡ��...".equals(orderType)) {
			querySql.append(" and t.order_type = '"+orderType+"'");
		}
		// ����״̬
		if (StringUtils.isNotBlank(procStatus)&&!"��ѡ��...".equals(procStatus)) {
			querySql.append(" and t.is_gene = '"+procStatus+"'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc,t.is_gene,t.apply_id");
		}		
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����ƻ���ҳ����Ϣ��ʾ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getExePlanMainInfo(ISrvMsg reqDTO) throws Exception {
		String applyId = reqDTO.getValue("applyid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select t.apply_id,t.apply_num,t.apply_year,t2.org_abbreviation as org_name,"
					  + " case when t.fill_per like '8%' then emp.employee_name else t.fill_per end as fill_per,"
					  + " to_char(to_date(t.fill_date, 'yyyymmdd'), 'yyyy-mm-dd') as fill_date,"
					  + " case when t.is_gene = '1' then '����' when t.is_gene = '2' then '������' when t.is_gene = '3' then '������'"
					  + " end as proc_status,d.coding_name as order_type_name"
					  + " from dms_exeplan_apply t "
					  + " left join comm_coding_sort_detail d on d.coding_code_id = t.order_type"
					  + " left join comm_org_information t2 on t.org_id = t2.org_id and t2.bsflag = '0'"
					  + " left join comm_human_employee_hr hr on t.fill_per = hr.employee_cd and hr.bsflag = '0'"
					  + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					  + " where t.apply_id = '"+applyId+"'");
		Map cdApplyMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(cdApplyMap)) {
			responseMsg.setValue("data", cdApplyMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ����ƻ���ϸ��Ϣ��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePlanDetByApplyNum(ISrvMsg msg) throws Exception {
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
		String applyId = msg.getValue("applyid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.detail_id,t.material_desc,t.material_code,t.apply_number,t.meas_unit,"
					  + " to_char(to_date(t.delivery_date, 'yyyymmdd'), 'yyyy-mm-dd') as delivery_date,"
				      + " t.asse_price,t.apply_dnum,t.contact,t.phone,t2.org_abbreviation as org_name"
				      + " from dms_exeplan_apply_detail t " 
				      + " left join comm_org_subjection t1 on t.org_subjection_id = t1.org_subjection_id and t1.bsflag = '0'"
				      + " left join comm_org_information t2 on t1.org_id = t2.org_id and t2.bsflag = '0' "
				      + " where t.apply_num = '" + applyId + "' ");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����ƻ���ϸ��Ϣ��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePlanDet(ISrvMsg msg) throws Exception {
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
		String applyId = msg.getValue("applyid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.detail_id,t.material_desc,t.material_code,t.apply_number,t.meas_unit,"
					  + " to_char(to_date(t.delivery_date, 'yyyymmdd'), 'yyyy-mm-dd') as delivery_date,"
				      + " t.asse_price,t.apply_dnum,t.contact,t.phone,t2.org_abbreviation as org_name"
				      + " from dms_exeplan_apply_detail t " 
				      + " left join comm_org_subjection t1 on t.org_subjection_id = t1.org_subjection_id and t1.bsflag = '0'"
				      + " left join comm_org_information t2 on t1.org_id = t2.org_id and t2.bsflag = '0' "
				      + " where t.apply_id = '" + applyId + "' ");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����ƻ�������ϸ��Ϣ��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePlanApprovalDet(ISrvMsg msg) throws Exception {
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
		String syncId = msg.getValue("syncid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.sync_id,t.busi_node,t.appr_status,t.appr_opinion,t.appr_per,"
					  + " to_char(to_date(t.appr_time, 'yyyymmdd hh24:mi:ss'), 'yyyy-mm-dd hh24:mi:ss') as appr_time"
					  + " from dms_comm_wf_sync t"
				      + " where t.business_id = '"+syncId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.appr_time asc");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ�ɹ��ƻ��б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePurcList(ISrvMsg msg) throws Exception {
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
		String purcNum = msg.getValue("purcnum");//�ɹ�����
		String orderType = msg.getValue("ordertype");//�ɹ�����
		String purcYear = msg.getValue("purcyear");//���
		String orgName = msg.getValue("orgname");//������λ
		String procStatus = msg.getValue("procstatus");//����״̬
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.purc_id,t.purc_num,t.purc_type,t.purc_year,"
				+ " case when t.fill_per like '8%' then emp.employee_name else t.fill_per end as fill_per,"
				+ " to_char(to_date(t.fill_date, 'yyyymmdd'), 'yyyy-mm-dd') as fill_date,"
				+ " case when t.order_type = 'Z001' or t.order_type = 'Z002' then '���ʲɹ��ƻ�' else d.coding_name"
				+ " end as order_type_name,t2.org_abbreviation as org_name,"
				+ " case when t.appstate = '1' then '����' when t.appstate = '2' then '������'"
				+ " when t.appstate = '3' then '������' end as proc_status"
				+ " from dms_exeplan_purc t"
				+ " left join comm_coding_sort_detail d on d.coding_code_id = t.order_type"
				+ " left join comm_org_information t2 on t2.org_id = t.org_id and t2.bsflag = '0'"
				+ " left join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag = '0'"
				+ " left join comm_human_employee_hr hr on t.fill_per = hr.employee_cd and hr.bsflag = '0'"
				+ " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
				+ " where t.bsflag = '0' and sub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		// �ɹ�����
		if (StringUtils.isNotBlank(purcNum)) {
			querySql.append(" and t.purc_num like '%"+purcNum+"%'");
		}
		// ���
		if (StringUtils.isNotBlank(purcYear)&&!"��ѡ��...".equals(purcYear)) {
			querySql.append(" and t.purc_year = '"+purcYear+"'");
		}
		// ������λ
		if (StringUtils.isNotBlank(orgName)) {
			querySql.append(" and t2.org_name like '%"+orgName+"%'");
		}
		// �ɹ�����
		if (StringUtils.isNotBlank(orderType)&&!"��ѡ��...".equals(orderType)) {
			if("Z001".equals(orderType)){
				querySql.append(" and (t.order_type = 'Z001' or t.order_type = 'Z002')");
			}else{
				querySql.append(" and t.order_type = '"+orderType+"'");
			}
		}
		// ����״̬
		if (StringUtils.isNotBlank(procStatus)&&!"��ѡ��...".equals(procStatus)) {
			querySql.append(" and t.appstate = '"+procStatus+"'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc,t.appstate,t.purc_id");
		}		
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �ɹ��ƻ���ҳ����Ϣ��ʾ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getExePurcMainInfo(ISrvMsg reqDTO) throws Exception {
		String purcId = reqDTO.getValue("purcid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select t.purc_id,t.purc_num,t.purc_type,t.purc_year,"
					  + " case when t.fill_per like '8%' then emp.employee_name else t.fill_per end as fill_per,"
					  + " to_char(to_date(t.fill_date, 'yyyymmdd'), 'yyyy-mm-dd') as fill_date,"
					  + " case when t.order_type = 'Z001' or t.order_type = 'Z002' then '���ʲɹ��ƻ�' else d.coding_name"
					  + " end as order_type_name,t2.org_abbreviation as org_name,"
					  + " case when t.appstate = '1' then '����' when t.appstate = '2' then '������'"
					  + " when t.appstate = '3' then '������' end as proc_status"
					  + " from dms_exeplan_purc t"
					  + " left join comm_coding_sort_detail d on d.coding_code_id = t.order_type"
					  + " left join comm_org_information t2 on t2.org_id = t.org_id and t2.bsflag = '0'"
					  + " left join comm_human_employee_hr hr on t.fill_per = hr.employee_cd and hr.bsflag = '0'"
					  + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					  + " where t.purc_id = '"+purcId+"'");
		Map purcMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(purcMap)) {
			responseMsg.setValue("data", purcMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD �ɹ��ƻ���ϸ��Ϣ��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePurcDetByPurcNum(ISrvMsg msg) throws Exception {
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
		String purcId = msg.getValue("purcid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pd.detail_id,pd.material_code,pd.material_desc,pd.amount,pd.unit,"
					  + " pd.price,pd.apply_dnum,pd.contact,pd.phone,pd.remark,ad.apply_num,"
					  + " t2.org_abbreviation as own_org_name,t2.org_name"
					  + " from dms_exeplan_purc_detail pd"
					  + " left join dms_exeplan_apply_detail ad on pd.exeplan_detail_id = ad.detail_id and ad.bsflag = '0'"
					  + " left join dms_exeplan_apply app on ad.apply_num = app.apply_num  and app.bsflag = '0'"
					  + " left join comm_org_information t2 on t2.org_id = pd.org_id and t2.bsflag = '0'"
					  + " where pd.purc_num ='" + purcId + "' ");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by pd.detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �ɹ��ƻ���ϸ��Ϣ��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryExePurcDet(ISrvMsg msg) throws Exception {
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
		String purcId = msg.getValue("purcid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pd.detail_id,pd.material_code,pd.material_desc,pd.amount,pd.unit,"
					  + " pd.price,pd.apply_dnum,pd.contact,pd.phone,pd.remark,ad.apply_num,"
					  + " t2.org_abbreviation as own_org_name,t2.org_name,pd.fromreqid"
					  + " from dms_exeplan_purc_detail pd"
					  + " left join dms_exeplan_apply_detail ad on pd.exeplan_detail_id = ad.detail_id and ad.bsflag = '0'"
					  + " left join dms_exeplan_apply app on ad.apply_num = app.apply_num  and app.bsflag = '0'"
					  + " left join comm_org_information t2 on t2.org_id = pd.org_id and t2.bsflag = '0'"
					  + " where pd.purc_id ='" + purcId + "' ");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by pd.detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}

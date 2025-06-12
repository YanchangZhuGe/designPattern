package com.bgp.dms.keeping;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
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

public class DevQZMaintianList extends BaseService{
	
	public DevQZMaintianList() {
		log = LogFactory.getLogger(DevQZMaintianList.class);
	}
	
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * ��ѯǿ�Ʊ�����Ϣ 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryUserInfo1(ISrvMsg isrvmsg) throws Exception {
		log.info("queryQZMaintain");
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
		String s_dev_name = isrvmsg.getValue("s_dev_name");// ���ƺ���
		String s_dev_model = isrvmsg.getValue("s_dev_model");// �豸���
		String s_license_num = isrvmsg.getValue("s_license_num");// �豸����
		String s_self_num = isrvmsg.getValue("s_self_num");// ҵ������
		String s_dev_sign = isrvmsg.getValue("s_dev_sign");// ҵ������
		String orgSubId = user.getSubOrgIDofAffordOrg();// ����������λ
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select info.*,account.dev_sign,account.dev_name, "
				+ " account.dev_model,account.self_num,account.license_num "
				+ " from bgp_comm_device_repair_info info "
				+ " inner join gms_device_account account on account.dev_acc_id = info.device_account_id and account.bsflag = '0' "
				+ " where info.repair_level = '"+DevConstants.DEV_REPAIR_LEVEL_BAOYANG+"'"
				+ " and info.project_info_no is null and account.account_stat in "
				+ " ('0110000013000000003', '0110000013000000001', '0110000013000000006') "
				+ " and (account.dev_type like 'S06%' or account.dev_type like 'S07%' or "
				+ " account.dev_type like 'S08%' or account.dev_type like 'S09%' or "
				+ " account.dev_type like 'S1507%')");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and account.dev_name like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and account.dev_model like '%"+s_dev_model+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and account.license_num like '%"+s_license_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_self_num)) {
			querySql.append(" and account.self_num like '%"+s_self_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_sign)) {
			querySql.append(" and account.dev_sign like '%"+s_dev_sign+"%' ");
		}
		if (StringUtils.isNotBlank(orgSubId)) {
			querySql.append(" and account.owning_sub_id like '"+orgSubId+"%' " );
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by info.repair_start_date desc,account.license_num,repair_end_date desc,account.dev_acc_id desc ");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯǿ�Ʊ�����Ϣ 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg queryQZMaintain(ISrvMsg isrvmsg) throws Exception {
		log.info("queryQZMaintain");
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
		String s_dev_name = isrvmsg.getValue("s_dev_name");// ���ƺ���
		String s_dev_model = isrvmsg.getValue("s_dev_model");// �豸���
		String s_license_num = isrvmsg.getValue("s_license_num");// �豸����
		String s_self_num = isrvmsg.getValue("s_self_num");// ҵ������
		String s_dev_sign = isrvmsg.getValue("s_dev_sign");// ҵ������
		String orgSubId = user.getSubOrgIDofAffordOrg();// ����������λ
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select info.*,account.dev_sign,account.dev_name, "
				+ " account.dev_model,account.self_num,account.license_num "
				+ " from bgp_comm_device_repair_info info "
				+ " inner join gms_device_account account on account.dev_acc_id = info.device_account_id and account.bsflag = '0' "
				+ " where info.repair_level = '"+DevConstants.DEV_REPAIR_LEVEL_BAOYANG+"'"
				+ " and info.project_info_no is null and account.account_stat in "
				+ " ('0110000013000000003', '0110000013000000001', '0110000013000000006') "
				+ " and (account.dev_type like 'S06%' or account.dev_type like 'S07%' or "
				+ " account.dev_type like 'S08%' or account.dev_type like 'S09%' or "
				+ " account.dev_type like 'S1507%')");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and account.dev_name like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and account.dev_model like '%"+s_dev_model+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and account.license_num like '%"+s_license_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_self_num)) {
			querySql.append(" and account.self_num like '%"+s_self_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_sign)) {
			querySql.append(" and account.dev_sign like '%"+s_dev_sign+"%' ");
		}
		if (StringUtils.isNotBlank(orgSubId)) {
			querySql.append(" and account.owning_sub_id like '"+orgSubId+"%' " );
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by info.repair_start_date desc,account.license_num,repair_end_date desc,account.dev_acc_id desc ");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	
	/**
	 * ������ϸ��Ϣ
	 * 
	 */
	public ISrvMsg getQZMaintain(ISrvMsg msg) throws Exception {
		log.info("getQZMaintain");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String repair_info = msg.getValue("repair_info");
		String querySql = "select info.*,account.dev_name,account.dev_model,account.self_num,account.license_num   "
				+ ",(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=info.repair_type) as repairtype,"
				+ " (select c.coding_name from comm_coding_sort_detail c where c.coding_code_id=info.repair_item) as repairitem,(select c.coding_name from comm_coding_sort_detail c where c.coding_code_id=info.repair_level) as repairLevel  from bgp_comm_device_repair_info info  left join GMS_DEVICE_ACCOUNT ACCOUNT on ACCOUNT.DEV_ACC_ID=INFO.DEVICE_ACCOUNT_ID ";
		querySql += " where info.repair_info='" + repair_info + "'";
		Map mixMap = jdbcDao.queryRecordBySQL(querySql);
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		return responseMsg;
	}
	
	
	/**
	 * ������ϸ��Ϣ
	 * 
	 */
	public ISrvMsg getQZMaintainInfo(ISrvMsg msg) throws Exception {
		log.info("getQZMaintainInfo");
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
		String repair_info = msg.getValue("repair_info");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select d.* from BGP_COMM_DEVICE_REPAIR_DETAIL d "
				+ "left join gms_mat_infomation i on d.material_coding = i.wz_id "
				+ "where d.repair_info = '"+repair_info+"'");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ������ϸ��Ϣ
	 * 
	 */
	public ISrvMsg getQZMaintainList(ISrvMsg msg) throws Exception {
		log.info("getQZMaintainList");
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
		String repair_info = msg.getValue("repair_info");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select d.coding_name "
				+ "from COMM_CODING_SORT_DETAIL d "
				+ "where d.CODING_SORT_ID = '5110000159' and d.bsflag = '0' and d.coding_code_id in("
				+ "select p.type_id from BGP_COMM_DEVICE_REPAIR_TYPE p "
				+ "where p.repair_info = '"+repair_info+"')");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʾ�����豸(��̨)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevAccData(ISrvMsg msg) throws Exception {
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
		String orgSubId = user.getSubOrgIDofAffordOrg();
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String devCoding = msg.getValue("devcoding");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select account.*, f.org_abbreviation as own_org_name "
				+ " from gms_device_account account "
				+ " left join comm_org_information f on f.org_id = account.owning_org_id "
				+ " and f.bsflag = '0' "
				+ " where account.bsflag = '0' "
				+ " and (account.account_stat = '0110000013000000003' or account.account_stat = '0110000013000000001' "
				+ " or account.account_stat = '0110000013000000003') "
				+ " and (account.dev_type like 'S06%' or account.dev_type like 'S07%' or "
				+ " account.dev_type like 'S08%' or account.dev_type like 'S09%' or "
				+ " account.dev_type like 'S1507%') ");
		if(!"C105".equals(orgSubId)){
			// ����������λ
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and account.owning_sub_id like '"+orgSubId+"%'" );
			}
		}
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and account.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and account.dev_model like '"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and account.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and account.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and account.license_num like '%"+licenseNum+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and account.dev_coding like '%"+devCoding+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",account.dev_acc_id ");
		}else{
			querySql.append(" order by case"
					+ " when dev_type like 'S08%' then 1" 		  //����
					+ " when dev_type like 'S070301%' then 2"     //������
					+ " when dev_type like 'S060101%' then 3"     //��װ���
					+ " when dev_type like 'S060102%' then 4"     //��̧�����
					+ " when dev_type like 'S0901%' then 5"       //�������
					+ " when dev_type like 'S1404%' then 6"       //�����豸
					+ " when dev_type like 'S14050101%' then 7"   //������������
					+ " when dev_type like 'S0623%' then 8"       //�ɿ���Դ
					+ " when dev_type like 'S0622%' then 9"       //������
					+ " end,account.dev_model,account.dev_sign,account.dev_acc_id ");
		}

		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʾ�������ʷ���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryQzbyMatData(ISrvMsg msg) throws Exception {
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
		String wzName = msg.getValue("wzname");
		String wzId = msg.getValue("wzid");
		String wzMinPrice = msg.getValue("wzminprice");
		String wzMaxPrice = msg.getValue("wzmaxprice");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select g.*,g.wz_id as wz_id_tmp, c.code_name from gms_mat_infomation g"
					+ " inner join gms_mat_coding_code c on g.coding_code_id = c.coding_code_id"
					+ " and g.bsflag = '0' and c.bsflag = '0' ");
		//��������
		if (StringUtils.isNotBlank(wzName)) {
			querySql.append(" and g.wz_name like '%"+wzName+"%'");
		}
		//���ʱ���
		if (StringUtils.isNotBlank(wzId)) {
			querySql.append(" and g.wz_id like '%"+wzId+"%'");
		}
		//���ʵ���
		if (StringUtils.isNotBlank(wzMinPrice)&&!StringUtils.isNotBlank(wzMaxPrice)) {
			querySql.append(" and g.wz_price > "+wzMinPrice+"");
		}
		if (StringUtils.isNotBlank(wzMaxPrice)&&!StringUtils.isNotBlank(wzMinPrice)) {
			querySql.append(" and g.wz_price < "+wzMaxPrice+"");
		}
		if (StringUtils.isNotBlank(wzMinPrice)
				&&StringUtils.isNotBlank(wzMaxPrice)) {
			querySql.append(" and g.wz_price > "+wzMinPrice+" and g.wz_price < "+wzMaxPrice+"");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",g.wz_id ");
		}else{
			querySql.append(" order by g.coding_code_id asc, g.wz_id asc ");
		}

		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}

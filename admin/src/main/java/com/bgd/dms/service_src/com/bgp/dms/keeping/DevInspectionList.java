package com.bgp.dms.keeping;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

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

public class DevInspectionList extends BaseService{
	
	public DevInspectionList() {
		log = LogFactory.getLogger(DevInspectionList.class);
	}
	
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryInspectionList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryInspectionList");
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
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select (select coding_name from comm_coding_sort_detail where coding_code_id=a.inspection_type)as inspection_type1, "
				+ " a.*, doc.file_name,doc.ucm_id ,b.dev_name,b.dev_acc_id,b.dev_sign,b.dev_model,b.license_num,b.self_num,oi.org_abbreviation as owning_org_name "  
				+ " from BGP_COMM_DEVICE_INSPECTION a left join GMS_DEVICE_ACCOUNT b on a.fk_dev_acc_id=b.dev_acc_id  "
				+ " left join bgp_doc_gms_file doc on doc.relation_id=a.inspection_id left join comm_org_information oi on oi.org_id = b.owning_org_id " 
				+ " where a.fk_dev_acc_id is not null");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and b.dev_name like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and b.dev_model like '%"+s_dev_model+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and b.license_num like '%"+s_license_num+"%' ");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and b.owning_sub_id like '"+orgSubId+"%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by a.inspection_date desc,a.inspection_id ");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 日常检查信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDayInspectionList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryInspectionList");
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
		String s_dev_sign = isrvmsg.getValue("s_dev_sign");// 设备名称
		String s_self_num = isrvmsg.getValue("s_self_num");// 设备名称
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select ins.*,acc.dev_name,acc.dev_model,acc.self_num, "
				+ " acc.license_num,acc.dev_sign,u.user_name as t_ins_people "
				+ " from gms_device_inspectioin ins  "
				+ " left join gms_device_account acc  "
				+ " on ins.dev_acc_id=acc.dev_acc_id and acc.bsflag='0' " 
				+ " left join p_auth_user u on ins.inspectioin_people=u.user_id and u.bsflag='0' "
				+ " where ins.bsflag='0' and ins.project_info_no is null ");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and acc.dev_name like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and acc.dev_model like '%"+s_dev_model+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and acc.license_num like '%"+s_license_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_sign)) {
			querySql.append(" and acc.dev_sign like '%"+s_dev_sign+"%' ");
		}
		if (StringUtils.isNotBlank(s_self_num)) {
			querySql.append(" and acc.self_num like '%"+s_self_num+"%' ");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and acc.owning_sub_id like '"+orgSubId+"%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by ins.create_time desc");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 加载日常检查详情
	 * 
	 */
	public ISrvMsg getDayInspectionInfo(ISrvMsg msg) throws Exception {
		log.info("getDayInspectionInfo");
		String devinspectioin_id = msg.getValue("devinspectioin_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select t.*,m.inspectioin_item_code,acc.dev_name,acc.dev_model,acc.self_num,acc.dev_sign,acc.license_num from gms_device_inspectioin t "+
				" left join gms_device_inspectioin_item m on t.devinspectioin_id = m.devinspectioin_id and m.bsflag = '0' "+
				" left join gms_device_account acc on t.dev_acc_id = acc.dev_acc_id and acc.bsflag = '0' "+
				" where t.bsflag = '0' and  t.devinspectioin_id = '"+devinspectioin_id+"'");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseDTO.setValue("data", mixMap);
		}
		return responseDTO;
	}
	
}

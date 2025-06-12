package com.bgp.dms.keeping;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

public class DevRepairList extends BaseService{
	
	public DevRepairList() {
		log = LogFactory.getLogger(DevRepairList.class);
	}
	
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询强制保养信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRepairtain(ISrvMsg isrvmsg) throws Exception {
		log.info("queryRepairtain");
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
		querySql.append("select info.*,case info.record_status when '1' then '修理完' when '0' then '修理中' else '修理完' end as record_status_desc, "
       + " account.dev_name, account.dev_model, account.self_num, account.license_num, "
       + " (select coding_name from comm_coding_sort_detail "
       + " where coding_code_id = info.REPAIR_TYPE) as repairtype, "
       + " (select coding_name from comm_coding_sort_detail "
       + " where coding_code_id = info.repair_item) as repairitem, "
       + " (select coding_name from comm_coding_sort_detail "
       + " where coding_code_id = info.REPAIR_LEVEL) as repairlevel "
	   + " from bgp_comm_device_repair_info info "
	   + " right JOIN GMS_DEVICE_ACCOUNT ACCOUNT on ACCOUNT.DEV_ACC_ID = INFO.DEVICE_ACCOUNT_ID "
	   + " where repair_level != '"+DevConstants.DEV_REPAIR_LEVEL_BAOYANG+"' ");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and account.dev_name like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and account.dev_model like '%"+s_dev_model+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and account.license_num like '%"+s_license_num+"%' ");
		}
		if (StringUtils.isNotBlank(orgSubId)) {
			querySql.append(" and account.owning_sub_id like '"+orgSubId+"%' " );
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by repair_start_date desc,account.dev_acc_id desc ");
		}
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
	public ISrvMsg getRepairMaintain(ISrvMsg msg) throws Exception {
		log.info("getRepairMaintain");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String repair_info = msg.getValue("repair_info");
		String querySql = "select info.*,case info.record_status when '1' then '修理完' when '0' then '修理中' else '修理完' end as record_status_desc, "
			       + " account.dev_name, account.dev_model, account.self_num, account.license_num, "
			       + " (select coding_name from comm_coding_sort_detail "
			       + " where coding_code_id = info.REPAIR_TYPE) as repairtype, "
			       + " (select coding_name from comm_coding_sort_detail "
			       + " where coding_code_id = info.repair_item) as repairitem, "
			       + " (select coding_name from comm_coding_sort_detail "
			       + " where coding_code_id = info.REPAIR_LEVEL) as repairlevel "
				   + " from bgp_comm_device_repair_info info "
				   + " right JOIN GMS_DEVICE_ACCOUNT ACCOUNT on ACCOUNT.DEV_ACC_ID = INFO.DEVICE_ACCOUNT_ID "
				   + " where repair_level != '"+DevConstants.DEV_REPAIR_LEVEL_BAOYANG+"' and info.repair_info='" + repair_info + "'";
		Map mixMap = jdbcDao.queryRecordBySQL(querySql);
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		return responseMsg;
	}
	
	/**
	 * 加载详细信息
	 * 
	 */
	public ISrvMsg getRepairList(ISrvMsg isrvmsg) throws Exception {
		log.info("getRepairList");
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
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		String repair_info = isrvmsg.getValue("repair_info");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.* from BGP_COMM_DEVICE_REPAIR_DETAIL d "
				+ "left join gms_mat_infomation i on d.material_coding=i.wz_id  where d.repair_info ='"+repair_info+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.repair_detail_id desc ");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	
	/**
	 * 油料消耗加载详细信息
	 * 
	 */
	public ISrvMsg getExpendList(ISrvMsg isrvmsg) throws Exception {
		log.info("getExpendList");
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
		String s_self_num = isrvmsg.getValue("s_self_num");// 设备类别
		String s_license_num = isrvmsg.getValue("s_license_num");// 设备名称
		String s_user_name = isrvmsg.getValue("s_user_name");// 设备名称
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.teammat_out_id,d.actual_price,t.outmat_date,"
				+ " i.wz_name,u.user_name,decode(t.oil_from, '0', '油库', '1', '加油站', '') oil_from,"
				+ " sum(d.oil_num) oil_num,sum(d.mat_num) mat_num,sum(d.total_money) total_money"
				+ " from gms_mat_teammat_out t"
  				+ " inner join(gms_mat_teammat_out_detail d"
 				+ " inner join gms_mat_infomation i on d.wz_id = i.wz_id) on t.teammat_out_id = d.teammat_out_id and d.bsflag = '0'"
  				+ " left join p_auth_user u on t.creator_id = u.user_id and u.bsflag = '0' "
  				+ " left join gms_mat_teammat_out_detail detail on t.teammat_out_id = detail.teammat_out_id "
  				+ " left join gms_device_account account on detail.dev_acc_id = account.dev_acc_id "
  				+ " where t.out_type = '3' and t.bsflag = '0' and t.project_info_no is null");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and account.dev_name like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_self_num)) {
			querySql.append(" and account.self_num like '%"+s_self_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and account.license_num like '%"+s_license_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_user_name)) {
			querySql.append(" and u.user_name like '%"+s_user_name+"%' ");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and account.owning_sub_id like '"+orgSubId+"%' " );
			}
		}
		querySql.append(" group by t.teammat_out_id, d.actual_price, t.outmat_date, i.wz_name, u.user_name, t.oil_from");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.outmat_date desc,t.teammat_out_id ");
		}
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
	public ISrvMsg getExpendtain(ISrvMsg isrvmsg) throws Exception {
		log.info("getExpendtain");
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
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		String id = isrvmsg.getValue("id");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select acc.dev_name,acc.self_num,acc.license_num,i.wz_prickie,d.actual_price, "
				+ " d.mat_num,d.total_money,d.oil_num,acc.dev_sign,oprtbl.operator_name "
				+ " from GMS_MAT_TEAMMAT_OUT t inner join  "
				+ " (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join "
				+ " gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' "
				+ " inner join gms_device_account acc on d.dev_acc_id=acc.dev_acc_id and acc.bsflag='0' "
				+ " left join (select device_account_id,operator_name from ( "
				+ " select tmp.device_account_id,tmp.operator_name,row_number() "
				+ " over(partition by device_account_id order by length(operator_name) desc ) as seq "
				+ " from (select device_account_id,wmsys.wm_concat(operator_name) "
				+ " over(partition by device_account_id order by operator_name) as operator_name "
				+ " from gms_device_equipment_operator where bsflag='0') tmp ) tmp2 where tmp2.seq=1) oprtbl "
				+ " on acc.dev_acc_id = oprtbl.device_account_id) on t.teammat_out_id =d.teammat_out_id "
				+ " and d.bsflag='0' where t.teammat_out_id='"+id+"'"
				+ " and t.bsflag='0'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD
	 * 修改验收油料信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateExpendInfo(ISrvMsg reqDTO) throws Exception {
		log.info("saveOrUpdateKeepingConfInfo");
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		//主台帐ID
		String devAccId = reqDTO.getValue("devAccId");
		String oil_from = "";
		Map reqMap = reqDTO.toMap();
		String ids = "";
		if(devAccId != null && !("").equals(devAccId)){
			ids = devAccId; 
			oil_from="0";
		}
		String[] id = ids.split(",");
		String org_subjection_id = user.getOrgSubjectionId();
		String org_id = user.getOrgId();
		// 操作主表录入设备数据
		Map map = new HashMap();
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
				pureDao.saveOrUpdateEntity(inmap, "GMS_MAT_TEAMMAT_INFO_DETAIL");
			}
		}
		return reqMsg;
	}
	
}

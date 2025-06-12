package com.bgp.dms.keeping;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.rm.dm.IWtcDevSrv;
import com.bgp.gms.service.rm.dm.WtcPubDevSrv;
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

public class DevOperatorList extends BaseService{
	
	public DevOperatorList() {
		log = LogFactory.getLogger(DevOperatorList.class);
	}
	
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private IWtcDevSrv wtcDevSrv = new WtcPubDevSrv();
	
	/**
	 * 查询定人定机信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOperatortain(ISrvMsg isrvmsg) throws Exception {
		log.info("queryOperatortain");
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
		String s_dev_sign = isrvmsg.getValue("s_dev_sign");// 设备类别
		String s_self_num = isrvmsg.getValue("s_self_num");// 设备名称
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t.dev_coding as erp_id,org.org_abbreviation, "
				+ " usingsd.coding_name as using_stat_desc,  "
				+ " techsd.coding_name as tech_stat_desc,  "
				+ " accountsd.coding_name as account_stat_desc,oprtbl.operator_name as alloprinfo  "
				+ " from gms_device_account t   "
				+ " left join (select device_account_id,operator_name from (   "
				+ " select tmp.device_account_id,tmp.operator_name,row_number()   "
				+ " over(partition by device_account_id order by length(operator_name) desc ) as seq  "
				+ " from (select device_account_id,wmsys.wm_concat(operator_name)   "
				+ " over(partition by device_account_id order by operator_name) as operator_name   "
				+ " from gms_device_equipment_operator where bsflag='0') tmp ) tmp2 where tmp2.seq=1) oprtbl on t.dev_acc_id = oprtbl.device_account_id  " 
				+ " left join comm_coding_sort_detail usingsd on t.using_stat=usingsd.coding_code_id   "
				+ " left join comm_coding_sort_detail techsd on t.tech_stat=techsd.coding_code_id   "
				+ " left join comm_coding_sort_detail accountsd on t.account_stat=accountsd.coding_code_id   "
				+ " left join comm_org_information org on t.owning_org_id=org.org_id   "
				+ " where t.bsflag='0'  and t.account_stat!='0110000013000000005' and t.ifproduction='5110000186000000002' "
				+ " and (t.dev_type like 'S08%' or t.dev_type like 'S09%'  or t.dev_type like 'S07%' or t.dev_type like 'S13%') ");
		if (StringUtils.isNotBlank(s_dev_name)) {
			querySql.append(" and t.dev_name like '%"+s_dev_name+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_model)) {
			querySql.append(" and t.dev_model like '%"+s_dev_model+"%' ");
		}
		if (StringUtils.isNotBlank(s_license_num)) {
			querySql.append(" and t.license_num like '%"+s_license_num+"%' ");
		}
		if (StringUtils.isNotBlank(s_dev_sign)) {
			querySql.append(" and t.dev_sign like '%"+s_dev_sign+"%' ");
		}
		if (StringUtils.isNotBlank(s_self_num)) {
			querySql.append(" and t.self_num like '%"+s_self_num+"%' ");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and t.owning_sub_id like '"+orgSubId+"%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by oprtbl.operator_name asc, t.dev_type asc ");
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
	public ISrvMsg getOperatortain(ISrvMsg msg) throws Exception {
		log.info("getOperatortain");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String dev_acc_id = msg.getValue("dev_acc_id");
		String querySql = " select (select coding_name "
          + " from comm_coding_sort_detail c "
          + " where t.using_stat = c.coding_code_id) as using_stat_desc, "
          + " (select coding_name from comm_coding_sort_detail c "
          + " where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.*,t.dev_coding as erp_id, "
      	  + " (select org_abbreviation from comm_org_information org "
          + " where t.owning_org_id = org.org_id) as owning_org_name_desc, "
          + " (select coding_name from comm_coding_sort_detail co "
          + " where co.coding_code_id = t.account_stat) as account_stat_desc "
          + " from GMS_DEVICE_ACCOUNT t "
          + " where dev_acc_id = '"+dev_acc_id+"'";
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
	public ISrvMsg getOperatorList(ISrvMsg isrvmsg) throws Exception {
		log.info("getOperatorList");
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
		String dev_acc_id = isrvmsg.getValue("dev_acc_id");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select to_char(p.create_date, 'yyyy-mm-dd') as createdate, " 
				+ "p.operator_name, p.change_reason, p.change_file, f.file_name "
				+ " from GMS_DEVICE_EQUIPMENT_OPERATOR p "
				+ " left join BGP_DOC_GMS_FILE f on f.file_id = p.change_file "
				+ " where p.fk_dev_acc_id = '"+dev_acc_id+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by p.create_date desc ");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 导出定人定机档案
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevArchiveInfo(ISrvMsg msg) throws Exception{
		String modelName = "定人定机";//导出excel的名称
		String modelPath = "/dmsManager/safekeeping/deviceEquipment/devoperator.xls";//excel模板存放路径
		ISrvMsg outMsg = SrvMsgUtil.createResponseMsg(msg);
		outMsg.setValue("modelname", modelName);
		outMsg.setValue("modelpath", modelPath);
		//定人定机记录
		String djSql = "select t.*,t.dev_coding as erp_id,org.org_abbreviation, "
				+ " usingsd.coding_name as using_stat_desc, "
				+ " techsd.coding_name as tech_stat_desc, "
				+ " accountsd.coding_name as account_stat_desc,oprtbl.operator_name as alloprinfo "
				+ " from gms_device_account t "
				+ " left join (select device_account_id,operator_name from ( "
				+ " select tmp.device_account_id,tmp.operator_name,row_number() "
				+ " over(partition by device_account_id order by length(operator_name) desc ) as seq "  
				+ " from (select device_account_id,wmsys.wm_concat(operator_name) "
				+ " over(partition by device_account_id order by operator_name) as operator_name "   
				+ " from gms_device_equipment_operator where bsflag='0') tmp ) tmp2 where tmp2.seq=1) oprtbl on t.dev_acc_id = oprtbl.device_account_id "   
				+ " left join comm_coding_sort_detail usingsd on t.using_stat=usingsd.coding_code_id "
				+ " left join comm_coding_sort_detail techsd on t.tech_stat=techsd.coding_code_id "
				+ " left join comm_coding_sort_detail accountsd on t.account_stat=accountsd.coding_code_id "
				+ " left join comm_org_information org on t.owning_org_id=org.org_id "
          		+ " where t.bsflag='0'  and t.account_stat!='0110000013000000005' and t.ifproduction='5110000186000000002' "
          		+ " and (t.dev_type like 'S08%' or t.dev_type like 'S09%' or t.dev_type like 'S07%' or t.dev_type like 'S13%')";
		outMsg.setValue("djlist", djSql);
 		outMsg.setValue("listname", "djlist");
		return outMsg;
	}
	
}

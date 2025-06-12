package com.bgp.dms.check;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

public class CheckPersonDev extends BaseService{
	
	public CheckPersonDev() {
		log = LogFactory.getLogger(CheckPersonDev.class);
	}
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询验收设备
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCheckDevList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckDevList");
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
		String ck_id = isrvmsg.getValue("ck_id");// 验收ID
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.dev_id,d.dev_name,d.dev_model,d.dev_type,d.dev_producer,d.dev_num "
				+ "from dms_device_check t,dms_device_check_device d  "
				+ "where d.ck_id=t.ck_id and d.bsflag = 0");
		// 验收ID
		if (StringUtils.isNotBlank(ck_id)) {
			querySql.append(" and t.ck_id = '" + ck_id + "'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.ck_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询验收人员信息数据
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCheckPersonList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckPersonList");
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
		String ck_id = isrvmsg.getValue("ck_id");//验收ID
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select p.*,t2.org_abbreviation ps_sectors "
				+ "from dms_device_check t,dms_device_check_person p "
				+ "left join comm_org_information t2 on t2.org_id = p.ps_sector "
				+ "left join comm_org_subjection t4 on p.ps_sector=t4.org_id "
			    + "left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "
				+ "where p.ck_id=t.ck_id and p.bsflag = 0");
		//验收ID
		if (StringUtils.isNotBlank(ck_id)) {
			querySql.append(" and t.ck_id = '" + ck_id + "'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.ck_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询供货商满意度
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCheckCsiList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckCsiList");
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
		String ck_id = isrvmsg.getValue("ck_id");// 指标名称
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from dms_device_check_supplier_csi");
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
	
	public ISrvMsg getCheckCsiInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getCheckCsiInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ck_id = isrvmsg.getValue("ck_id");// 指标配置id
		String msql = "select t.ck_id,t.ck_cid,t.ck_company,s.csi,s.csi_id from dms_device_check_supplier_csi s,dms_device_check t "
				+ "where t.ck_id='"+ck_id+"' and t.ck_id = s.ck_id";
		Map map=jdbcDao.queryRecordBySQL(msql);
		if(map==null || map.size()<1){
			String sql = "select t.ck_id,t.ck_cid,t.ck_company,t.ck_id,t.ck_company_score from dms_device_check t "
					+ "where t.ck_id='"+ck_id+"' ";
			Map smap=jdbcDao.queryRecordBySQL(sql);
			System.out.println(sql);
			responseDTO.setValue("data", smap);
			return responseDTO;
		}
		System.out.println(msql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * 保存和修改供货商评价
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateCheckCsiInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateCheckCsiInfo");
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> strMap = new HashMap<String,Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String csi= (String)map.get("csi");
		String ck_company = (String)map.get("ck_company");
		String ck_id = (String)map.get("ck_id");//保存表主键
		String ck_cid= (String)map.get("ck_cid");
		String flag= (String)map.get("flag");
		String csi_id = "";
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if(flag.equals("add")){//保存操作
				Map mainMap=new HashMap();
				mainMap.put("ck_id", ck_id);//指标名称
				mainMap.put("ck_cid", ck_cid);//年度
				mainMap.put("ck_company", ck_company);
				mainMap.put("csi", csi);
				mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				mainMap.put("creater", employee_id);
				mainMap.put("create_date", currentdate);
				ServiceUtils.setCommFields(mainMap, "csi_id", user);
				csi_id = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_device_check_supplier_csi");
			}else{//修改操作
				csi_id=(String)map.get("csi_id");
				String sql = "update dms_device_check_supplier_csi "
						+ "set ck_cid ='"+ck_cid+"',ck_company ='"+ck_company+"',csi ='"+csi+"',updator ='"+employee_id+"',modify_date = to_date('"+currentdate+"','yyyy-MM-dd HH24:mi:ss') "
						+ " where csi_id ='"+csi_id+"'";
				jdbcDao.executeUpdate(sql);
			}
		} catch (Exception e) {
			e.printStackTrace();
			operationFlag = "failed";
		}
		return responseDTO;
	}
	
	/**
	 * 删除指定信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteCheckDevInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteCheckDevInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String dev_id = isrvmsg.getValue("dev_id");// 设备验收id
		try{
			String delSql = "update dms_device_check_device set bsflag='1' where dev_id='"+dev_id+"' ";
			jdbcDao.executeUpdate(delSql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 删除指定信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteCheckPersonInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteCheckPersonInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String ps_id = isrvmsg.getValue("ps_id");// 设备验收id
		try{
			String delSql = "update dms_device_check_person set bsflag='1' where ps_id='"+ps_id+"' ";
			jdbcDao.executeUpdate(delSql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
}

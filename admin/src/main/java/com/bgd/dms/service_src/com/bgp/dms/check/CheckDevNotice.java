package com.bgp.dms.check;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

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
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;
import com.cnpc.jcdp.util.DateUtil;

/**
 * 
 * @author lifan
 * 
 */
public class CheckDevNotice extends BaseService{


	public CheckDevNotice() {
		log = LogFactory.getLogger(CheckDevNotice.class);
	}
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询验收通知信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCheckConfInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckConfInfoList");
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
		String apply_num = isrvmsg.getValue("q_apply_num");// 需求单号
		String orgSubId = isrvmsg.getValue("orgSubId");// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.pact_num,t.create_date,t.ck_dmsid,t.apply_num,t.ck_company,t.fold_org_id,"+
						" t.using_org_id,t.yar_date,t.bsflag,info.org_abbreviation fold_org_name,"+
				        " info1.org_abbreviation using_org_name"+
						" from dms_device_check_notice t"+
						" left join comm_org_information info on t.fold_org_id=info.org_id"+ 
						" left join comm_org_information info1 on t.using_org_id=info1.org_id"+ 
						" left join comm_org_subjection sub1 on sub1.org_id=t.fold_org_id"+
						" left join comm_org_subjection sub2 on sub2.org_id=t.using_org_id"+
				        " where t.bsflag = '0' ");
		// 需求单号名称
		if (StringUtils.isNotBlank(apply_num)) {
			querySql.append(" and t.apply_num like '%" + apply_num + "%'");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and sub1.org_subjection_id like '"+orgSubId+"%' or sub2.org_subjection_id like '"+orgSubId+"%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append("  order by t.create_date desc,t.yar_date desc,t.apply_num desc ");
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
	public ISrvMsg getCheckConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getCheckConfInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ck_dmsid = isrvmsg.getValue("ck_dmsid");// 验收通知id
		String msql = "select t.pact_num,t.ck_dmsid,t.apply_num,t.ck_company,t.yar_date,"
				    + " t.fold_org_id,foldorg.org_abbreviation fold_org_name,"
				    + " t.using_org_id,useorg.org_abbreviation using_org_name"
				    + " from dms_device_check_notice t"
					+ " left join comm_org_information foldorg"
				    + " on t.fold_org_id = foldorg.org_id and foldorg.bsflag = '0'"
					+ " left join comm_org_information useorg"
				    + " on t.using_org_id = useorg.org_id and useorg.bsflag = '0'"
					+ " where t.ck_dmsid = '"+ck_dmsid+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		// 查询文件表
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ ck_dmsid + "' and t.bsflag='0' and t.is_file='1' ";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdataPublic", list2);// 附件
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * 删除指定信息
	 */
	public ISrvMsg deleteCheckNoticInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteCheckNoticInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String ck_dmsid = isrvmsg.getValue("ck_dmsid");// id
		try{
			//删除验收通知
			String delSql = "update dms_device_check_notice set bsflag='1' where ck_dmsid ='"+ck_dmsid+"'";
			jdbcDao.executeUpdate(delSql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
		
	/**
	 * NEWMETHOD
	 * 修改验收通知信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({"rawtypes"})
	public ISrvMsg saveOrUpdateCheckConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateCheckConfInfo");
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String apply_num = (String) map.get("apply_num");
		String yar_date = (String) map.get("yar_date");
		String pact_num = (String) map.get("pact_num");
		String ck_company = (String) map.get("ck_company");
		String fold_org_id = (String) map.get("fold_org_id");
		String using_org_id = (String) map.get("using_org_id");
		String flag = (String) map.get("flag");
		String ck_dmsid = "";// 保存表主键
		// 存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if ("add".equals(flag)) {// 保存操作
				Map<String, Object> mainMap = new HashMap<String, Object>();
				mainMap.put("apply_num", apply_num);// 指标名称
				mainMap.put("yar_date", yar_date);// 年度
				mainMap.put("pact_num", pact_num);
				mainMap.put("ck_company", ck_company);
				mainMap.put("fold_org_id", fold_org_id);
				mainMap.put("using_org_id", using_org_id);
				mainMap.put("creater", employee_id);
				mainMap.put("create_date", currentdate);
				mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				ServiceUtils.setCommFields(mainMap, "ck_dmsid", user);
				ck_dmsid = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_device_check_notice");
			} else {// 修改操作
				ck_dmsid = (String) map.get("ck_dmsid");
				Map<String, Object> umainMap = new HashMap<String, Object>();
				umainMap.put("ck_dmsid", ck_dmsid);// 指标名称
				umainMap.put("apply_num", apply_num);// 指标名称
				umainMap.put("yar_date", yar_date);// 年度
				umainMap.put("pact_num", pact_num);
				umainMap.put("fold_org_id", fold_org_id);
				umainMap.put("using_org_id", using_org_id);
				umainMap.put("ck_company", ck_company);
				umainMap.put("updator", employee_id);
				umainMap.put("modify_date", currentdate);
				umainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
				ServiceUtils.setCommFields(umainMap, "ck_dmsid", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_device_check_notice");
			}
			// 存储附件操作
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			List<WSFile> filesOther = mqMsgOther.getFiles();
			Map<String, Object> doc = new HashMap<String, Object>();
			MyUcm ucm = new MyUcm();
			String filename = "";
			String fileOrder = "";
			String ucmDocId = "";
			try {// 处理附件
				for (WSFile file : filesOther) {
					filename = file.getFilename();
					fileOrder = file.getKey().toString().split("__")[0];// fileOrder.substring(1,5)+"__"+System.currentTimeMillis()
					ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", ck_dmsid);
					doc.put("doc_type", "5110000203000000001");
					doc.put("file_type", fileOrder);
					doc.put("file_name", filename);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("creator_id", user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("create_date", currentdate);
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					// 附件表
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					// 日志表
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
				}
			} catch (Exception e) {
				System.out.println("附件未插入或修改");
			}
		} catch (Exception e) {
			e.printStackTrace();
			operationFlag = "failed";
		}
		return responseDTO;
	}
		
}

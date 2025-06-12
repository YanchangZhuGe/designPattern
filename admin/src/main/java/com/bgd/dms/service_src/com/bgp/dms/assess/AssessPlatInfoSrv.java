package com.bgp.dms.assess;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.json.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.bgp.dms.assess.IServ.IElementServ;
import com.bgp.dms.assess.IServ.IPlat_scoreSrv;
import com.bgp.dms.assess.IServ.impl.ElementServ;
import com.bgp.dms.assess.IServ.impl.Plat_scoreSrv;
import com.bgp.dms.assess.util.AssessTools;
import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.CommonUtil;
import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
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
import com.cnpc.jcdp.util.DateUtil;
import com.primavera.ws.p6.spread.SummarizedSpreadPeriod;

/**
 * project: �豸��ϵ��Ϣ������
 * 
 * creator: dz
 * 
 * creator time:2015-11-2
 * 
 * description:�豸���˲�ѯ��ط���
 * 
 */
@Service("AssessPlatSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class AssessPlatInfoSrv extends BaseService {

	public AssessPlatInfoSrv() {
		log = LogFactory.getLogger(DeviceAssessInfoSrv.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IElementServ elementServ = new ElementServ();
	private IPlat_scoreSrv scoreSrv = new Plat_scoreSrv();
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	/**
	 * �������Ҫ���б�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryElementList(ISrvMsg msg) throws Exception {
		String tipMsg = "";
		String methodID = "queryElementList";
		String modelID = msg.getValue("modelID");
		log.info(modelID);
		String scoreID = msg.getValue("scoreID");
		log.info("queryElementList scoreID=" + scoreID);
		log.info("queryElementList flag=" + msg.getValue("flag"));
		String assessname = msg.getValue("assessname");// ��������
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String pageSize = "200";
		PageModel page = AssessTools.getPage(msg, pageSize);
		List datas = null;
		String flag = AssessTools.valueOf(msg.getValue("flag"), "add");
		if ("up".equals(flag) || "view".equals(flag)) {
			log.info("queryElementList scoreID=" + scoreID);
			Map<String, Object> params = scoreSrv.findScoreReportByID(scoreID);
			datas = scoreSrv.findElementScoreList(scoreID, page);
			responseDTO.setValue("datas", datas);
			responseDTO.setValue("scoreID", scoreID);
			responseDTO = AssessTools.setParams(params, responseDTO);
			/*
			 * responseDTO.setValue("modelid", params.get("modelid"));
			 * if(responseDTO
			 * .getValue("modelid")==null||"".equals(responseDTO.getValue
			 * ("modelid"))){ responseDTO.setValue("modelid", 1); }
			 */

		}
		if ("add".equals(flag)) {
			datas = elementServ.findElementByModelID(modelID, assessname, page);
			String assessOrgName = msg.getValue("assess_name");
			String assessOrgId = msg.getValue("assess_org_id");
			responseDTO = AssessTools.setParams(msg, responseDTO);
			responseDTO.setValue("modelID", modelID);
			responseDTO.setValue("ADD_ASSESS_ORG_NAME", assessOrgName);
			responseDTO.setValue("ASSESS_ORG_ID", assessOrgId);
			
		}

		responseDTO.setValue("datas", datas);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		responseDTO.setValue("flag", flag);

		// responseDTO = AssessTools.setParams(msg, responseDTO);

		return responseDTO;
	}

	/**
	 * ���������嵥
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg createMarkScoreList(ISrvMsg msg) throws Exception {
		String tipMsg = "";
		String methodID = "createMarkScoreList";
		log.info(methodID);
		String modelID = msg.getValue("modelID");

		String scoreID = msg.getValue("scoreID");
		String assessname = msg.getValue("assessname");// ��������
		UserToken user = msg.getUserToken();

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String pageSize = "200";
		PageModel page = AssessTools.getPage(msg, pageSize);
		List datas = null;
		Map<String, Object> params = scoreSrv.findScoreReportByID(scoreID);
		params.put("username", user.getUserName());
		params.put("creator", user.getEmpId());
		datas = scoreSrv.findMarkedElementScoreList(scoreID, page);
		if (datas == null || datas.size() == 0) {
			tipMsg = "������û�������嵥��";
		} 
		responseDTO.setValue("datas", datas);
		responseDTO.setValue("scoreID", scoreID);
		responseDTO = AssessTools.setParams(params, responseDTO);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		log.info("modelID=" + responseDTO.getValue("modelID"));
		// responseDTO = AssessTools.setParams(msg, responseDTO);
		responseDTO.setValue("markMsg", tipMsg);
		responseDTO.setValue("methodID", methodID);
		responseDTO.setValue("flag", AssessTools.valueOf(msg.getValue("flag"), ""));
		return responseDTO;
	}

	/**
	 * ת������������ҳ��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg toMarkScoreSuggestion(ISrvMsg msg) throws Exception {
		String tipMsg = "";
		String methodID = "toMarkScoreSuggestion";
		log.info(methodID);
		String modelID = msg.getValue("modelID");
		String scoreID = msg.getValue("scoreID");
		String assessname = msg.getValue("assessname");// ��������
		UserToken user = msg.getUserToken();

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String pageSize = "200";
		PageModel page = AssessTools.getPage(msg, pageSize);
		List datas = null;
		Map<String, Object> params = scoreSrv.findScoreReportByID(scoreID);
		params.put("username", user.getUserName());
		params.put("creator", user.getEmpId());
		datas = scoreSrv.findMarkedElementScoreList(scoreID, page);
		if (datas == null || datas.size() == 0) {
			tipMsg = "������û�������嵥��";
		}
		responseDTO.setValue("datas", datas);
		responseDTO.setValue("scoreID", scoreID);
		responseDTO = AssessTools.setParams(params, responseDTO);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		// responseDTO = AssessTools.setParams(msg, responseDTO);
		responseDTO.setValue("markMsg", tipMsg);
		
		responseDTO.setValue("flag", AssessTools.valueOf(msg.getValue("flag"), ""));
		return responseDTO;
	}
	/**
	 * ��������������ҳ��
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addMarkScoreSuggestion(ISrvMsg msg) throws Exception {
		String tipMsg = "";
		String methodID = "addMarkScoreSuggestion";
		log.info(methodID);
		String modelID = msg.getValue("modelID");
		String scoreID = msg.getValue("scoreID");
		String assessname = msg.getValue("assessname");// ��������
		UserToken user = msg.getUserToken();

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String pageSize = "200";
		PageModel page = AssessTools.getPage(msg, pageSize);
		List datas = null;
		Map<String, Object> params = scoreSrv.findScoreReportByID(scoreID);
		
		params.put("username", user.getUserName());
		params.put("creator", user.getEmpId());
		params.put("modelID", modelID);
		params.put("scoreID", scoreID);
		params.put("REMARK_plat", msg.getValue("REMARK_plat"));
		Map requestMap = msg.toMap();
		Set keys = requestMap.keySet();
		for (Iterator iterator = keys.iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			params.put(key, AssessTools.valueOf(requestMap.get(key), ""));
		}
		datas = scoreSrv.findMarkedElementScoreList(scoreID, page);
		if (datas == null || datas.size() == 0) {
			tipMsg = "������û�������嵥��";
		}
	
		String assessList = msg.getValue("assessList");
		log.info("assessList=" + assessList);
		String group_detailList = msg.getValue("group_detailList");
		log.info("group_detailList=" + group_detailList);
		String assess_name = msg.getValue("assess_name");
		JSONObject assessObj = null;
		JSONObject detailObj = null;
		if (assessList != null) {
			if ("".equals(assessList.trim()) == false) {
				assessObj = new JSONObject(assessList);
			}
		}
		if (assessList != null) {
			if ("".equals(group_detailList.trim()) == false) {
				detailObj = new JSONObject(group_detailList);
			}
		}
		
		params.put("username", user.getUserName());
		params.put("creator", user.getEmpId());
		scoreID = scoreSrv.addSuggestionForPlatScore(params);
		if (assessObj != null) {

			org.json.JSONArray assessArray = assessObj.getJSONArray("assess");
			/**
			 * Ԫ�ؼ����������¼
			 */
			int assessArray_size = assessArray.length();
			for (int i = 0; i < assessArray_size; i++) {
				JSONObject assess = assessArray.getJSONObject(i);
				String elementReportID = scoreSrv.addSuggestionForElementScore(assess,
						params, scoreID);
				/**
				 * ��Ԫ�ؼ����������¼
				 */
				/*if (detailObj != null) {

					org.json.JSONArray detailsArray = detailObj
							.getJSONArray("details");
					int detailsArray_size = detailsArray.length();
					for (int j = 0; j < detailsArray_size; j++) {
						JSONObject detail = detailsArray.getJSONObject(j);
						String group_detail_assessID = detail
								.getString("group_detail_assessID");
						String detailID = detail
								.getString("group_detail_assessID");
						String assess_id = assess.getString("assess_id");
						if (group_detail_assessID.equals(assess_id)) {
							scoreSrv.saveDetailScore(detail, params,
									elementReportID);
						}
					}
				}*/
			}
			tipMsg = "�����������ɹ�";
			responseDTO.setValue("msg", tipMsg);
		}

		// responseDTO = AssessTools.setParams(msg, responseDTO);
		responseDTO.setValue("markMsg", tipMsg);
		
		responseDTO.setValue("flag", AssessTools.valueOf(msg.getValue("flag"), ""));
		return responseDTO;
	}
	public ISrvMsg createScoreReport(ISrvMsg msg) throws Exception {
		String tipMsg = "";
		String methodID = "createScoreReport";
		UserToken user = msg.getUserToken();
		String assessList = msg.getValue("assessList");
		log.info("assessList=" + assessList);
		String group_detailList = msg.getValue("group_detailList");
		log.info("group_detailList=" + group_detailList);
		String assess_name = msg.getValue("assess_name");
		JSONObject assessObj = null;
		JSONObject detailObj = null;
		if (assessList != null) {
			if ("".equals(assessList.trim()) == false) {
				assessObj = new JSONObject(assessList);
			}
		}
		if (assessList != null) {
			if ("".equals(group_detailList.trim()) == false) {
				detailObj = new JSONObject(group_detailList);
			}
		}
		Map params = msg.toMap();
		params.put("username", user.getUserName());
		params.put("creator", user.getEmpId());
		String scoreID = scoreSrv.saveScore(params);
		if (assessObj != null) {

			org.json.JSONArray assessArray = assessObj.getJSONArray("assess");
			/**
			 * Ԫ�ؼ����������¼
			 */
			int assessArray_size = assessArray.length();
			for (int i = 0; i < assessArray_size; i++) {
				JSONObject assess = assessArray.getJSONObject(i);
				String elementReportID = scoreSrv.saveElementScore(assess,
						params, scoreID);
				/**
				 * ��Ԫ�ؼ����������¼
				 */
				if (detailObj != null) {

					org.json.JSONArray detailsArray = detailObj
							.getJSONArray("details");
					int detailsArray_size = detailsArray.length();
					for (int j = 0; j < detailsArray_size; j++) {
						JSONObject detail = detailsArray.getJSONObject(j);
						String group_detail_assessID = detail
								.getString("group_detail_assessID");
						String detailID = detail
								.getString("group_detail_assessID");
						String assess_id = assess.getString("assess_id");
						if (group_detail_assessID.equals(assess_id)) {
							scoreSrv.saveDetailScore(detail, params,
									elementReportID);
						}
					}
				}
			}
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("scoreID", scoreID);
		responseDTO.setValue("msg", "������˱���ɹ�");
		return responseDTO;
	}

	public ISrvMsg updateScoreReportByID(ISrvMsg msg) throws Exception {
		log.info("updateScoreReportByID");
		UserToken user = msg.getUserToken();
		String assessList = msg.getValue("assessList");
		System.out.println("assessList == "+assessList);
		String assess_name = msg.getValue("assess_name");
		JSONObject assessObj = new JSONObject(assessList);
		String group_detailList = msg.getValue("group_detailList");
		log.info("assessList=" + assessList);
		log.info("group_detailList=" + group_detailList);
		JSONObject detailObj = new JSONObject(group_detailList);
		Map params = msg.toMap();
		params.put("username", user.getUserName());
		params.put("creator", user.getEmpId());
		String scoreID = scoreSrv.updateScore(params);
		org.json.JSONArray assessArray = assessObj.getJSONArray("assess");
		/**
		 * Ԫ�ؼ����������¼
		 */
		int assessArray_size = assessArray.length();
		for (int i = 0; i < assessArray_size; i++) {
			JSONObject assess = assessArray.getJSONObject(i);
			String elementReportID = scoreSrv.updateElementScore(assess,
					params, scoreID);
			/**
			 * ��Ԫ�ؼ����������¼
			 */
			org.json.JSONArray detailsArray = detailObj.getJSONArray("details");
			int detailsArray_size = detailsArray.length();
			for (int j = 0; j < detailsArray_size; j++) {
				JSONObject detail = detailsArray.getJSONObject(j);
				String group_detail_assessID = detail
						.getString("group_detail_assessID");
				String detailID = detail.getString("group_detail_assessID");
				String assess_id = assess.getString("assess_id");
				if (group_detail_assessID.equals(assess_id)) {
					scoreSrv.updateDetailScore(detail, params, elementReportID);
				}
			}

		}

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("scoreID", scoreID);
		responseDTO.setValue("msg", "�޸ĳɹ�");
		return responseDTO;
	}

	/**
	 * ���Ҫ���첽���ݲ�ѯ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessElementTreeInfo(ISrvMsg msg) throws Exception {
		String nodeid = msg.getValue("node");
		DeviceMCSBean deviceBean = new DeviceMCSBean();
		// 1. ��һ�ν���
		if ("root".equals(nodeid)) {
			// ��ѯ���ڵ�
			String sql = "select '~~0~0' as id,'false' as leaf,'���Ҫ���б���' as name,'' as code,0 as is_leaf,0 as node_level from dual ";

			List list = jdbcDao.queryRecords(sql.toString());
			Map dataMap = (Map) list.get(0);
			JSONArray jsonArray = JSONArray.fromObject(dataMap);
			ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);

			if (jsonArray == null) {
				outmsg.setValue("json", "[]");
			} else {
				outmsg.setValue("json", jsonArray.toString());
			}
			return outmsg;
		} else {
			// 3. �ּ����أ����ݴ����nodeid�õ���һ�����豸�����豸����
			String sql = "select assess_id || '~' || assess_level || '~' || assess_is_leaf || '~' || assess_seq as id,"
					+ "case assess_is_leaf when 0 then 'false' else 'true' end as leaf,"
					+ "assess_seq ||'��'||assess_name as name,assess_is_leaf,assess_level,assess_seq "
					+ "from dms_assess_plat_elements ";
			// �����ĸ���Ϣ����˳��ֱ��� device_id dev_code node_level is_leaf
			String[] keyinfos = nodeid.split("~", -1);

			if (keyinfos[0] != null && !"".equals(keyinfos[0])) {
				sql += "where assess_parent_id='" + keyinfos[0] + "' ";
			} else {
				sql += "where assess_parent_id is null ";
			}
			sql += "order by assess_seq nulls first ";

			List list = jdbcDao.queryRecords(sql.toString());
			JSONArray retJson = JSONArray.fromObject(list);
			ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);

			if (retJson == null) {
				outmsg.setValue("json", "[]");
			} else {
				outmsg.setValue("json", retJson.toString());
			}
			return outmsg;
		}
	}

	/**
	 * NEWMETHOD ��ѯ���Ҫ�����к��Ƿ����
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessSeqExist(ISrvMsg msg) throws Exception {
		log.info("getAssessSeqExist");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String assessSeq = msg.getValue("assessseq");
		String exist_tmp = "0";// �����ڱ�ʶ
		// �����
		StringBuffer assess_str = new StringBuffer().append(
				"select main.assess_name from dms_assess_plat_elements main ")
				.append("where main.bsflag = '0' and main.assess_seq='"
						+ assessSeq + "' ");
		Map existMap = jdbcDao.queryRecordBySQL(assess_str.toString());
		if (existMap != null) {
			exist_tmp = "1";// ����
		}
		responseMsg.setValue("existMap", existMap);
		responseMsg.setValue("existtmp", exist_tmp);
		return responseMsg;
	}
	
	/**
	 * ������������б� ��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAssessScoreListNew(ISrvMsg msg) throws Exception {
		log.info("queryAssessScoreListNew");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String model_name = msg.getValue("modelname");
		String employee_name = msg.getValue("employeename");
	 
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select s.*, m.model_name,e.employee_name"
				+"	from dms_assess_score s"
				+"	left join dms_assess_plat_model m"
				+"	on s.score_model_id = m.model_id"
				+"	and m.bsflag='0'"
				+"	left join comm_human_employee e"
				+"	on s.creator =e.employee_id"
				+"	and e.bsflag='0'"
				+"	where s.bsflag='0'");
			 

		if (StringUtils.isNotBlank(employee_name)) {
			querySql.append(" and e.employee_name like '%"+employee_name+"%'");
		}
		if (StringUtils.isNotBlank(model_name)) {
			querySql.append(" and m.model_type like '%"+model_name+"%'");
		}
//		if (StringUtils.isNotBlank(modelType)) {
//			querySql.append(" and m.model_type like '%"+modelType+"%'");
//		}
//		if (!DevConstants.COMM_COM_ORGSUBID.equals(user.getSubOrgIDofAffordOrg())) {
//			querySql.append(" and sub.org_subjection_id like '"
//					+ user.getSubOrgIDofAffordOrg() + "%'");
//		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by s.create_date desc ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ������������б�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAssessScoreList(ISrvMsg msg) throws Exception {
		log.info("queryAssessScoreList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String assessOrgName = msg.getValue("assessorgname");
		String assessUserName = msg.getValue("assessusername");
		String modelType = msg.getValue("modeltype");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select info.org_abbreviation as assess_org_name,"
				+ " d.coding_name as model_name,p.assess_start_date,p.assess_end_date,"
				+ " org.org_name as create_org_name,emp.employee_name as assess_user_name,"
				+ " p.create_date,p.assess_score_id from dms_assess_plat_score p "
				+ " left join dms_assess_plat_model m on p.assess_model_id = m.model_id and p.bsflag = '0'"
				+ " left join comm_coding_sort_detail d on d.coding_code_id = m.model_type and d.bsflag = '0'"
				+ " left join comm_org_information info on p.assess_org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_human_employee emp on emp.employee_id = p.assess_user_id"
				+ " left join comm_org_information org on org.org_id = p.create_org_id and org.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = p.assess_org_id and sub.bsflag = '0'"
				+ " where p.bsflag = '" + DevConstants.BSFLAG_NORMAL + "'");

		if (StringUtils.isNotBlank(assessOrgName)) {
			querySql.append(" and info.org_name like '%"+assessOrgName+"%'");
		}
		if (StringUtils.isNotBlank(assessUserName)) {
			querySql.append(" and p.assess_user_name like '%"+assessUserName+"%'");
		}
		if (StringUtils.isNotBlank(modelType)) {
			querySql.append(" and m.model_type like '%"+modelType+"%'");
		}
		if (!DevConstants.COMM_COM_ORGSUBID.equals(user.getSubOrgIDofAffordOrg())) {
			querySql.append(" and sub.org_subjection_id like '"
					+ user.getSubOrgIDofAffordOrg() + "%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by create_date desc ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * �������п���ģ����б�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAssessModelList(ISrvMsg msg) throws Exception {
		log.info("queryAssessModelList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String modelName = msg.getValue("modelname");
		String modelType = msg.getValue("modeltype");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select m.model_title,m.model_id,m.model_type,m.model_name,det.coding_name as model_type_name,"
				+ " m.model_version,info.org_name as create_org_name,emp.employee_name as creator_name,"
				+ " m.create_date,m.remark from dms_assess_plat_model m "
				+ " left join comm_coding_sort_detail det on det.coding_code_id = m.model_type and det.bsflag = '0'"
				+ " left join comm_org_information info on m.create_org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_human_employee emp on emp.employee_id = m.creator and emp.bsflag = '0'"
				+ " where m.bsflag ='" + DevConstants.BSFLAG_NORMAL + "' ");

		if (StringUtils.isNotBlank(modelName)) {
			querySql.append(" and m.model_name like '%" + modelName + "%'");
		}
		if (StringUtils.isNotBlank(modelType)) {
			querySql.append(" and m.model_type like '%"+modelType+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by create_date desc ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * ͨ��ģ��ID��ȡҪ�����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessElement(ISrvMsg msg) throws Exception {
		log.info("getAssessElement");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String model_id = msg.getValue("modelid");
		// ��ѯԪ�����ֱ�׼����
		String sql = "select e.assess_id,m.model_id,m.model_title,e.assess_name,e.assess_content,"
				+ " tmp3.standard_content,tmp4.standard_score from dms_assess_plat_element e"
				+ " left join dms_assess_plat_model m on e.assess_model_id = m.model_id and m.bsflag = '0'"
				+ " left join (select element_id, check_content as standard_content from (select tmp.element_id,tmp.check_content,"
				+ " row_number() over(partition by element_id order by length(check_content) desc) as seq"
				+ " from (select element_id,wmsys.wm_concat(check_content || ' <br>')"
				+ " over(partition by element_id order by check_content) as check_content"
				+ " from dms_assess_element_detail where bsflag = '0' and detail_flag = '0') tmp) tmp2 where tmp2.seq = 1) tmp3"
				+ " on e.assess_id = tmp3.element_id "
				+ " left join (select sum(standard_score) as standard_score, element_id from dms_assess_element_detail"
				+ " where bsflag = '0' and detail_flag = '0' group by element_id) tmp4 on e.assess_id = tmp4.element_id"
				+ " where e.bsflag='0' and m.model_id = '"
				+ model_id
				+ "'"
				+ " order by e.assess_seq";
		List<Map> list = jdbcDao.queryRecords(sql);
		List<Map> list1 = null;
		for (int i = 0; i < list.size(); i++) {
			// Map dataMap = (Map) list.get(i);
			// dataMap.get("assess_content").toString().replaceAll("��",";<br>");
			// dataMap.putAll(dataMap);
			// Map<String, Object> contentMap = new HashMap<String, Object>();
			// contentMap.put("assess_content",
			// list.get(i).get("assess_content").toString().replaceAll("��",str));
			// list.add(contentMap);
			// System.out.println(""+list.get(i).get("assess_content").toString().replaceAll("��",";<br>"));
			// String str =
			// list.get(i).get("assess_content").toString().replaceAll("��",";<br>");
			// list.add(dataMap);
			String sql1 = "select det.element_id,det.detail_id,det.check_item,det.check_content,"
					+ " det.detail_flag,det.standard_score from dms_assess_element_detail det"
					+ " where det.bsflag='0' and det.detail_flag = '1'"
					+ " and det.element_id = '"
					+ list.get(i).get("assess_id").toString() + "'";
			System.out.println("sql1 == " + sql1 + "     i==  " + i);
			list1 = jdbcDao.queryRecords(sql1);
			// System.out.println("========== "+list1.get(i).get("check_item").toString());
		}

		// ��ѯ���ż����Ŀ����

		responseDTO.setValue("datas", list);
		responseDTO.setValue("datas1", list1);
		return responseDTO;
	}

	/**
	 * ͨ��ģ��ID��ȡҪ����������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessElementDetail(ISrvMsg msg) throws Exception {
		log.info("getAssessElementDetail");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String elementid = msg.getValue("elementid");
		// ��ѯ���ż����Ŀ����
		String sql = "select det.element_id,det.detail_id,det.check_item,det.check_content,"
				+ " det.detail_flag,det.standard_score from dms_assess_element_detail det"
				+ " where det.bsflag='0' and det.detail_flag = '1'"
				+ " and det.element_id = '" + elementid + "'";
		List<Map> detList = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	
	/**
	 * ��ѯҪ��������ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessScoreInfoNew(ISrvMsg msg) throws Exception {
		log.info("getAssessScoreInfoNew");
		String score_id = msg.getValue("score_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append(" select s.*, m.model_name,e.employee_name"
						+"	from dms_assess_score s"
						+"	left join dms_assess_plat_model m"
						+"	on s.score_model_id = m.model_id"
						+"	and m.bsflag='0'"
						+"	left join comm_human_employee e"
						+"	on s.creator =e.employee_id"
						+"	and e.bsflag='0'"
						+"	where s.bsflag='0' and score_id='"+score_id+"'");
		Map assessScoreMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(assessScoreMap)) {
			responseDTO.setValue("data", assessScoreMap);
		}
		return responseDTO;
	}
	
	/**
	 * ��ѯҪ��������ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessScoreInfo(ISrvMsg msg) throws Exception {
		log.info("getAssessScoreInfo");
		String assessScoreId = msg.getValue("assessscoreid");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select info.org_name as assess_org_name,emp.employee_name as assess_user_name,"
						+ " d.coding_name as model_name,p.assess_start_date,p.assess_end_date,"
						+ " org.org_name as create_org_name,cremp.employee_name as creator_name,"
						+ " p.create_date,p.assess_score_id from dms_assess_plat_score p "
						+ " left join dms_assess_plat_model m on p.assess_model_id = m.model_id and p.bsflag = '0'"
						+ " left join comm_coding_sort_detail d on d.coding_code_id = m.model_type and d.bsflag = '0'"
						+ " left join comm_org_information info on p.assess_org_id = info.org_id and info.bsflag = '0'"
						+ " left join comm_human_employee emp on emp.employee_id = p.assess_user_id"
						+ " left join comm_human_employee cremp on cremp.employee_id = p.creator"
						+ " left join comm_org_information org on org.org_id = p.create_org_id and org.bsflag = '0'"
						+ " where p.assess_score_id = '"
						+ assessScoreId
						+ "' and p.bsflag = '"
						+ DevConstants.BSFLAG_NORMAL
						+ "' ");
		Map assessScoreMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(assessScoreMap)) {
			responseDTO.setValue("data", assessScoreMap);
		}
		return responseDTO;
	}

	/**
	 * ��ҳ��˵÷���ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIndexAssessScore(ISrvMsg msg) throws Exception {
		log.info("getIndexAssessScore");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String assess_type = msg.getValue("assessType");
		String sql = "select p.assess_score_id,info.org_abbreviation as assessorgname, p.assess_user_name,"
				+ " p.assess_start_date,p.assess_end_date,n.item_compre_score,n.check_sum_score"
				+ " from dms_assess_plat_score p left join comm_org_information info on p.assess_org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = p.assess_org_id and sub.bsflag = '0'"
				+ " left join (select sc.plat_score_id,nvl(sum(sc.item_compre_score), 0) as item_compre_score,"
				+ " nvl(sum(sc.check_sum_score) + sum(det.check_score), 0) as check_sum_score from dms_assess_element_score sc"
				+ " left join dms_assess_score_detail det on det.element_score_id = sc.score_id and det.bsflag = '0'"
				+ " where sc.plat_score_id in (select assess_score_id from (select row_number() over(partition by s.assess_org_id order by s.create_date desc) rn,"
				+ " s.assess_score_id from dms_assess_plat_score s left join dms_assess_plat_model m on s.assess_model_id = m.model_id and m.bsflag = '0'"
				+ " where s.bsflag = '0'  and m.model_type = '"
				+ assess_type
				+ "' and s.create_date is not null and s.assess_org_id is not null)"
				+ "  where rn = 1) group by sc.plat_score_id) n on p.assess_score_id = n.plat_score_id where p.bsflag = '0'"
				+ " and p.assess_score_id in ((select assess_score_id from (select row_number() over(partition by s.assess_org_id order by s.create_date desc) rn,"
				+ " s.assess_score_id from dms_assess_plat_score s left join dms_assess_plat_model mo on s.assess_model_id = mo.model_id and mo.bsflag = '0'"
				+ " where s.bsflag = '0' and mo.model_type = '"
				+ assess_type
				+ "' and s.create_date is not null and s.assess_org_id is not null) where rn = 1))";
		if (!DevConstants.COMM_COM_ORGSUBID.equals(user
				.getSubOrgIDofAffordOrg())) {
			sql += " and sub.org_subjection_id like '"
					+ user.getSubOrgIDofAffordOrg() + "%'";
		}
		sql += " order by item_compre_score desc";
		// String sql =
		// "select p.assess_score_id,info.org_abbreviation as assessorgname, p.assess_user_name,"
		// +
		// " p.assess_start_date,p.assess_end_date,800 as item_compre_score,900 as check_sum_score"
		// +
		// " from dms_assess_plat_score p left join comm_org_information info on p.assess_org_id = info.org_id and info.bsflag = '0'"

		// + " where p.bsflag = '0' "
		// + " order by item_compre_score desc";
		List<Map> list = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * NEWMETHOD ��ѯȫ��Ҫ���������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessModelType(ISrvMsg msg) throws Exception {
		log.info("getAssessModelType");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select t.coding_code_id as code,t.coding_name as note ")
			.append("from comm_coding_sort_detail t ")
			.append("where t.coding_sort_id ='" + DevConstants.DMS_ASSESS_PLAT_FATHER_CODE + "' ")
			.append("and t.bsflag='" + DevConstants.BSFLAG_NORMAL + "' order by t.coding_show_id ");
		List list = jdbcDao.queryRecords(sb.toString());

		JSONArray retJson = JSONArray.fromObject(list);			
		ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);			
		if(retJson == null){
			outmsg.setValue("json", "[]");
		}else {
			outmsg.setValue("json", retJson.toString());
		}			
		return outmsg;
	}
	/**
	 * NEWMETHOD ��ҳ���˺��̵�ʵʱ���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMonitorStateInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		Calendar cal = Calendar.getInstance();
	    Integer curYear = cal.get(Calendar.YEAR);
		String year =msg.getValue("year");
		if(StringUtils.isBlank(year)){
			year=curYear.toString();
		}
		String startdate=year+"-01-01";
	    String enddate=year+"-12-31";
	    if(Integer.parseInt(year)==curYear){
	    	Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			enddate = sdf.format(d);
	    }
		String orgSubId = msg.getValue("orgsubid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.org_id as duiorgid,n1.org_id as wtcorgid,n1.org_subjection_id as wtcsubid,'0' as state,'"
					   + startdate+"' as startdate,'"+enddate+"' as enddate,n.org_abbreviation as wtcname,t.team_id as duiorgname"
					   + " from comm_org_team t"
					   + " left join comm_org_information n on t.present_unit_id = n.org_id and n.bsflag = '0'"
					   + " left join comm_org_subjection n1 on n.org_id = n1.org_id and n1.bsflag = '0'"
					   + " where n1.org_subjection_id not like 'C105002%' and n1.org_subjection_id not like 'C105086%'"
					   + " and n1.org_subjection_id like '"+orgSubId+"%' ");	
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by n1.org_subjection_id");
		}
		List<Map> list = pureDao.queryRecords(querySql.toString());
		//��ȡ��Ŀ��Ϣ
		List<Map> proList = getProjectInfo(year,"0",orgSubId);
		//��ȡ������Ϣ
		List<Map> sqlList = getScoreSql();
		if(CollectionUtils.isNotEmpty(proList) && CollectionUtils.isNotEmpty(sqlList)){
			for(Map m:list){
				//С�ӵ�λ
				String mOrgId=m.get("duiorgid").toString();
				//��ȡС��������Ŀ
				List<Map> fProList=getProjectInfo(proList,mOrgId);
				if(CollectionUtils.isNotEmpty(fProList)){
					String stateFlag="0";
					for(Map fm:fProList){
						if("1".equals(stateFlag)){
							break;
						}
						//��Ŀid
						String fProjectInfoNo=fm.get("project_info_no").toString();
						for(Map sMap:sqlList){
							if("1".equals(stateFlag)){
								break;
							}
							stateFlag=getScoreState(sMap,fProjectInfoNo);
						}
					}
					m.put("state", stateFlag);
				}
			}
		}
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list.size());
		responseDTO.setValue("pageSize", list.size());
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD ��Ŀ���˺��̵�ʵʱ���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectMonitorStateInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String year =msg.getValue("year");
		String wtcOrgId =msg.getValue("wtcOrgId");//��̽��orgid
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t2.project_info_no as projectinfono,t2.project_name as projectname,'0' as state," 
				+ " t2.start_date as startdate,t2.end_date as enddate,t2.org_sub_id as orgsubid,t2.org_id as orgid "
				+ " from (select os.org_subjection_id || '%' as tonesubid "
				+ " from bgp_eps_code eps "
				+ " join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' and eps.bsflag = '0' "
				+ " where (eps.parent_object_id = '8ad891b1387dfd9b01387e0531af0002' or eps.parent_object_id = '8ad88271485f36be01486218b6d10431') "
				+ " and eps.org_id != 'C6000000000003' and eps.object_id != '8ad88271485f36be01486218b6d10431' and eps.object_id != '8ad891b1387dfd9b01387e147b36000d') t1, "
				+ " (select tp.project_info_no,tp.project_name,nvl(tp.project_start_time, tp.acquire_start_time) as start_date, "
				+ " nvl(tp.project_end_time, tp.acquire_end_time) as end_date,dy.org_subjection_id as org_sub_id,dy.org_id as org_id "
				+ " from gp_task_project tp "
				+ " left join gp_task_project_dynamic dy on tp.project_info_no = dy.project_info_no and dy.bsflag = '0' "
				+ " where tp.bsflag = '0' and tp.project_type = '5000100004000000001' and tp.project_name not like '%��Ŀ�ƻ�ģ��%' "
				+ " and ((to_char(nvl(tp.project_start_time, tp.acquire_start_time),'yyyy') = '"
				+ year
				+ "' or "
				+ " to_char(nvl(tp.project_end_time, tp.acquire_end_time),'yyyy') = '"
				+ year
				+ "' or "
				+ " tp.project_year = '"
				+ year
				+ "') or "
				+ " (tp.project_status <> '5000100001000000003' and tp.project_status <> '5000100001000000005'))) t2 "
				+ " where t2.org_sub_id like t1.tonesubid and t2.org_id = '"+wtcOrgId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t2.start_date");
		}
		List<Map> list = pureDao.queryRecords(querySql.toString());
		//��ȡ������Ϣ
		List<Map> sqlList=getScoreSql();
		if(CollectionUtils.isNotEmpty(list)){
			if(CollectionUtils.isNotEmpty(sqlList)){
				for(Map m:list){
					//��Ŀid
					String fProjectInfoNo=m.get("projectinfono").toString();
					String stateFlag="0";
					for(Map sMap:sqlList){
						if("1".equals(stateFlag)){
							break;
						}
						stateFlag=getScoreState(sMap,fProjectInfoNo);
					}
					m.put("state", stateFlag);
				}
			}
		}
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list.size());
		responseDTO.setValue("pageSize", list.size());
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD ָ�꿼�˺��̵�ʵʱ���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIndexMonitorStateInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String projectinfono =msg.getValue("projectinfono");
		//��ȡ������Ϣ
		List<Map> list=getScoreSql();
		if(CollectionUtils.isNotEmpty(list)){
			for(Map sMap:list){
				String stateFlag=getScoreState(sMap,projectinfono);
				sMap.put("state", stateFlag);
			}
		}
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list.size());
		responseDTO.setValue("pageSize", list.size());
		return responseDTO;
	}
	
	//����������λ������Ŀ��Ϣ
	public List<Map> getProjectInfo(List<Map> proList,String orgId){
		List<Map> fList=new ArrayList<Map>();
		if(CollectionUtils.isNotEmpty(proList)){
			for(Map map: proList){
				String _orgId=map.get("org_id").toString();
				if(orgId.equals(_orgId)){
					fList.add(map);
				}
			}
		}
		return fList;
	}	
	/**
	 * NEWMETHOD ��ҳ��ػ�ȡ����̽����Ŀ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public List<Map> getProjectInfo(String year,String monitorProType,String orgSubId){
		String proSql = "select tp.project_info_no, dy.org_subjection_id, dy.org_id "
				+ " from gp_task_project tp "
				+ " left join gp_task_project_dynamic dy on tp.project_info_no = dy.project_info_no and dy.bsflag = '0' "
				+ " where tp.bsflag = '0' and tp.project_country = '1' and (tp.project_type = '5000100004000000001' or tp.project_type = '5000100004000000009') "
				+ " and (to_char(nvl(tp.project_start_time, tp.acquire_start_time),'yyyy') = '"
				+ year
				+ "' or "
				+ " to_char(nvl(tp.project_end_time, tp.acquire_end_time),'yyyy') = '"
				+ year
				+ "' or "
				+ " tp.project_year = '"
				+ year
				+ "')";
				if(DevUtil.isValueNotNull(monitorProType)&&"1".equals(monitorProType)){
					proSql += " and tp.project_status <> '5000100001000000003' and tp.project_status <> '5000100001000000005' ";
				}else if(DevUtil.isValueNotNull(monitorProType)&&"2".equals(monitorProType)){
					proSql += " and (tp.project_status = '5000100001000000003' or tp.project_status = '5000100001000000005') ";
				}
				//�����װ�����񴦿���������Ŀ
				if(DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID.equals(orgSubId)){
					proSql += " and dy.org_subjection_id like 'C105%' and dy.org_subjection_id not like 'C105002%' and dy.org_subjection_id not like 'C105086%'";
				}else if(orgSubId.startsWith(DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID)
						&&orgSubId.length() > 7){
					proSql += " and tp.project_info_no in"
						    + " (select dui.project_info_id from gms_device_account_dui dui"
				            + " left join gms_device_account acc on acc.dev_acc_id = dui.fk_dev_acc_id"
				            + " where dui.project_info_id = tp.project_info_no and acc.owning_sub_id like '"+orgSubId+"%' )";
				}else{
					proSql += " and dy.org_subjection_id like '"+orgSubId+"%'";
				}
		//System.out.println("proSql == "+proSql);
		List<Map> proList = pureDao.queryRecords(proSql);
		return proList;
	}	
	/**
	 * NEWMETHOD ��ȡ����sql��Ϣ
	 * 
	 * @param 
	 * @return list
	 * @throws Exception
	 */
	public List<Map> getScoreSql(){
		String dSql = "select d.detail_id as indexid,d.check_content as indexname,"
					+ " d.spare3 as criterion,d.score_ceiling,d.score_floor"
					+ " from dms_assess_element_detail d"
					+ " where d.bsflag = '0' and d.if_monitor = '1'";
		List<Map> dList = pureDao.queryRecords(dSql);
		if(CollectionUtils.isNotEmpty(dList)){
			for(Map dMap:dList){
				String businessId = dMap.get("indexid").toString();
				String sql = ""; 
				//����sql
				String rSql = "select t.relation_id,t.conf_id,t.score_condition"
							+ " from comm_autoscore_relation t"
							+ " where t.bsflag = '0' and t.business_id='"+businessId+"'";
				Map rMap = jdbcDao.queryRecordBySQL(rSql);
				if(MapUtils.isNotEmpty(rMap)){
					String confId = rMap.get("conf_id") == null ? "" : (String) rMap.get("conf_id");
					String scoreCondition = rMap.get("score_condition") == null ? "" : (String) rMap.get("score_condition");
					if(DevUtil.isValueNotNull(confId)){
						//�Զ�������������Ϣ
						String cSql = "select t.conf_id,t.conf_content_type,t.conf_table_name,"
									+ " t.conf_column_name,t.conf_content"
									+ " from comm_autoscore_conf t"
									+ " where t.bsflag = '0' and t.conf_id = '"+confId+"'";
						Map cMap = jdbcDao.queryRecordBySQL(cSql);
						String fSql = "select t.conf_filter_id,t.connect_type,t.filter_column_type,t.query_type,"
									+ " t.date_type_format,t.filter_column_name,t.filter_column_value "
									+ " from comm_autoscore_conf_filter t"
									+ " where t.bsflag = '0' and t.conf_id = '"+scoreCondition+"'";
						List<Map> fList = jdbcDao.queryRecords(fSql);
						if(MapUtils.isNotEmpty(cMap)){
							Map gMap = new HashMap();
							gMap.put(cMap, fList);
							try {
								if(StringUtils.isNotBlank(scoreCondition)){
									sql = "select "+scoreCondition+" from ( "+CommonUtil.getAutoScoreSql(gMap)+" )";
								}else{
									sql = CommonUtil.getAutoScoreSql(gMap);
								}
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
					}
				}
				//System.out.println("sql == "+sql);
				dMap.put("sql", sql);
			}
		}
		return dList;
	}	
	/**
	 * NEWMETHOD ��ȡ����״̬ 0:���� 1������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String getScoreState(Map sMap,String projectInfoNo){
		String stateFlag = "0";
		//����sql
		if(DevUtil.isValueNotNull(sMap.get("sql").toString())){
			String scoreSql = sMap.get("sql").toString().replace("rp_project_info_no_vaule",projectInfoNo);
			if(scoreSql.indexOf("@@")!=-1){
				scoreSql = scoreSql.replace("@@", " not like ");
			}
			Map scoreMap = jdbcDao.queryRecordBySQL(scoreSql);
			if(MapUtils.isEmpty(scoreMap)){
				stateFlag = "1";
			}else{
				float score = Float.parseFloat(scoreMap.get("score_value")==null ? "0" : scoreMap.get("score_value").toString());
				//��������
				float scoreCeiling = Float.parseFloat(sMap.get("score_ceiling").toString());
				//��������
				float scoreFloor = Float.parseFloat(sMap.get("score_floor").toString());
				if(Float.compare(scoreCeiling, (float)0)>0 && Float.compare(scoreFloor,(float) 0)>0){
					if(Float.compare(scoreFloor,score) > 0 || Float.compare(scoreCeiling,score)<0){
						stateFlag = "1";
					}
				}
				if(Float.compare(scoreCeiling, (float)0)==0 && Float.compare(scoreFloor,(float)0)>0){
					if(Float.compare(scoreFloor,score) > 0){
						stateFlag = "1";
					}
				}
				if(Float.compare(scoreCeiling, (float)0)>0 && Float.compare(scoreFloor,(float)0)==0){
					if(Float.compare(scoreCeiling,score)<0){
						stateFlag = "1";
					}
				}
			}
		}
		return stateFlag;
	}	
	/**
	 * �����Ŀ�����Ϣ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProYearData(ISrvMsg msg) throws Exception{
		String sql = "select min(pro.project_year) as min_year from gp_task_project pro"
				   + " where pro.bsflag = '0'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		int minYear=Integer.parseInt(map.get("min_year").toString());
		Calendar cal = Calendar.getInstance();
	    int curYear = cal.get(Calendar.YEAR);
	    List<Map> list=new ArrayList<Map>();
	    for(int i=curYear;i>=minYear;i--){
	    	Map ymap=new HashMap();
	    	if(i==curYear){
	    		ymap.put("code", i);
	    		ymap.put("value", i+"��");
	    		ymap.put("selected", true);
	    	}else{
	    		ymap.put("code", i);
		    	ymap.put("value", i+"��");
	    	}
	    	list.add(ymap);
	    }
		JSONArray retJson = JSONArray.fromObject(list);			
		ISrvMsg outmsg = SrvMsgUtil.createResponseMsg(msg);			
		if(retJson == null){
			outmsg.setValue("json", "[]");
		}else {
			outmsg.setValue("json", retJson.toString());
		}			
		return outmsg;
	}
	/**
	 * NEWMETHOD ��ҳ���˺��̵�ʵʱ���new
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMonitorInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		Calendar cal = Calendar.getInstance();
	    Integer curYear = cal.get(Calendar.YEAR);
		String startDate = curYear.toString() + "-01-01";
	    String endDate = curYear.toString() + "-12-31";
		String orgSubId = msg.getValue("orgsubid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		//querySql.append("select t.org_id as wtcorgid,t.org_subjection_id as wtcsubid,'0' as state,'"
		//			   + startDate+"' as startdate,'"+endDate+"' as enddate,t.org_abbreviation as wtcname"
		//			   + " from bgp_comm_org_wtc t"
		//			   + " where t.org_subjection_id not like 'C105002%' and t.org_subjection_id not like 'C105086%'"
		//			   + " and t.org_subjection_id like '"+orgSubId+"%' ");	
		//if(StringUtils.isNotBlank(sortField)){
		//	querySql.append(" order by "+sortField+" "+sortOrder+" ");
		//}else{
		//	querySql.append(" order by t.org_subjection_id");
		//}
		//��ȡ������Ϣ
		List<Map> sqlList = getScoreSql();
		List<Map> list = pureDao.queryRecords(querySql.toString());
		
		//��ȡ��Ŀ��Ϣ
		List<Map> proList = getProjectInfo(curYear.toString(),"0",orgSubId);
		
		if(CollectionUtils.isNotEmpty(proList) && CollectionUtils.isNotEmpty(sqlList)){
			for(Map m:list){
				//С�ӵ�λ
				String mOrgId = m.get("wtcsubid").toString();
				//��ȡС��������Ŀ
				List<Map> fProList = getProjectInfo(proList,mOrgId);
				if(CollectionUtils.isNotEmpty(fProList)){
					String stateFlag="0";
					for(Map fm:fProList){
						if("1".equals(stateFlag)){
							break;
						}
						//��Ŀid
						String fProjectInfoNo=fm.get("project_info_no").toString();
						for(Map sMap:sqlList){
							if("1".equals(stateFlag)){
								break;
							}
							stateFlag = getScoreState(sMap,fProjectInfoNo);
						}
					}
					m.put("state", stateFlag);
				}
			}
		}
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list.size());
		responseDTO.setValue("pageSize", list.size());
		return responseDTO;
	}
	/**
	 * ������������б�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMinitorScoreList(ISrvMsg msg) throws Exception {
		log.info("queryMinitorScoreList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.org_id as wtcorgid,t.org_subjection_id as wtcsubid,"
						+ " t.org_abbreviation as wtcname from bgp_comm_org_wtc t"
						+ " where t.bsflag = '" + DevConstants.BSFLAG_NORMAL + "'");

		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.order_num ");
		}
		List<Map> subList = jdbcDao.queryRecords(querySql.toString());
		List<Map<String,Object>> datasList = new ArrayList<Map<String,Object>>();
		if(CollectionUtils.isNotEmpty(subList)){
			for(Map subMap:subList){
				subMap.put("ndghyls", this.getMonitorScore(subMap.get("wtcsubid").toString(), "ndghyls"));//��ȹ滮����ʵ
				subMap.put("zdxzyls", this.getMonitorScore(subMap.get("wtcsubid").toString(), "zdxzyls"));//�ƶ���������ʵ
				subMap.put("sbpzysgl", this.getMonitorScore(subMap.get("wtcsubid").toString(), "sbpzysgl"));//�豸�������չ���
				subMap.put("zctp", this.getMonitorScore(subMap.get("wtcsubid").toString(), "zctp"));//�ʲ�����
				subMap.put("sbfh", this.getMonitorScore(subMap.get("wtcsubid").toString(), "sbfh"));//�豸����
				subMap.put("sgys", this.getMonitorScore(subMap.get("wtcsubid").toString(), "sgys"));//�չ�����
				subMap.put("bygl", this.getMonitorScore(subMap.get("wtcsubid").toString(), "bygl"));//��������
				subMap.put("sbkq", this.getMonitorScore(subMap.get("wtcsubid").toString(), "sbkq"));//�豸����
				subMap.put("drdj", this.getMonitorScore(subMap.get("wtcsubid").toString(), "drdj"));//���˶���				
				subMap.put("yzjl", this.getMonitorScore(subMap.get("wtcsubid").toString(), "yzjl"));//��ת��¼
				subMap.put("tzsbgl", this.getMonitorScore(subMap.get("wtcsubid").toString(), "tzsbgl"));//�����豸����
				subMap.put("sbwx", this.getMonitorScore(subMap.get("wtcsubid").toString(), "sbwx"));//�豸ά��
				subMap.put("rcjc", this.getMonitorScore(subMap.get("wtcsubid").toString(), "rcjc"));//�ճ����
				subMap.put("sbjc", this.getMonitorScore(subMap.get("wtcsubid").toString(), "sbjc"));//�豸���	
				subMap.put("zcfcgl", this.getMonitorScore(subMap.get("wtcsubid").toString(), "zcfcgl"));//�ʲ�������
				subMap.put("sbbfgl", this.getMonitorScore(subMap.get("wtcsubid").toString(), "sbbfgl"));//�豸���Ϲ���
				subMap.put("xxxtjshyy", this.getMonitorScore(subMap.get("wtcsubid").toString(), "xxxtjshyy"));//��Ϣϵͳ�����Ӧ��
				//subMap.put("ygpxzsygl", this.getMonitorScore(subMap.get("wtcsubid").toString(), "ygpxzsygl"));//Ա����ѵ��֪ʶ����
				//subMap.put("gjycx", this.getMonitorScore(subMap.get("wtcsubid").toString(), "gjycx"));//�Ľ��봴��
				datasList.add(subMap);
			}
		}
		//List list = pureDao.queryRecords(querySql.toString());
		responseDTO.setValue("datas", datasList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ȡ����(������)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String getMonitorScore(String subOrgId,String type){
		int n = (int)(Math.random()*50);
		return n+"";
	}
	/**
	 * ��˾����ҳ���̵���ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHomeMinitorList(ISrvMsg msg) throws Exception {
		log.info("queryHomeMinitorList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String proYear = msg.getValue("proyear");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		//��ȡ����ָ��ID
		StringBuffer queryIndiSql = new StringBuffer();
		queryIndiSql.append("select d.detail_id,p.assess_name,d.check_content,d.monitor_type,d.monitor_pro_type,d.spare3"
						  + " from dms_assess_element_detail d"
						  + " left join dms_assess_plat_element p on d.element_id = p.assess_id"
						  + " left join dms_assess_plat_model m on p.assess_model_id = m.model_id"
						  + " where d.if_monitor = '1' and m.model_type = '"+DevConstants.DMS_ASSESS_MODEL_TYPE_WTC+"'"
						  + " order by p.assess_seq,d.detail_seq");

		List<Map> indiList = jdbcDao.queryRecords(queryIndiSql.toString());
		List<Map<String,Object>> datasList = new ArrayList<Map<String,Object>>();
		if(CollectionUtils.isNotEmpty(indiList)){
			for(Map subMap:indiList){
				subMap.put("tlmwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_TLMWTC_SUB_ID, proYear));//����ľ��̽��
				subMap.put("xjwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_XJWTC_SUB_ID, proYear));//�½���̽��
				subMap.put("thwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_THWTC_SUB_ID, proYear));//�¹���̽��
				subMap.put("qhwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_QHWTC_SUB_ID, proYear));//�ຣ��̽��
				subMap.put("cqwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_CQWTC_SUB_ID, proYear));//������̽��
				subMap.put("dgwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_DGWTC_SUB_ID, proYear));//������̽��
				subMap.put("lhwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_LHWTC_SUB_ID, proYear));//�ɺ���̽��
				subMap.put("hbwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_HBWTC_SUB_ID, proYear));//������̽��
				subMap.put("xxwtkfc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_XXWTKFC_SUB_ID, proYear));//������̽������
				subMap.put("zhwhtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_ZHWHTC_SUB_ID, proYear));//�ۺ��ﻯ̽��
				subMap.put("xnwtc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_XNWTC_SUB_ID, proYear));//������̽��
				subMap.put("dqygs", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_DQYGS_SUB_ID, proYear));//������̽һ��˾
				subMap.put("dqegs", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_DQEGS_SUB_ID, proYear));//������̽����˾
				subMap.put("zbfwc", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID, proYear));//װ������
				datasList.add(subMap);
			}
		}
		responseDTO.setValue("datas", datasList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		return responseDTO;
	}
	/**
	 * װ��������ҳ���̵���ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHomeZBMinitorList(ISrvMsg msg) throws Exception {
		log.info("queryHomeZBMinitorList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String proYear = msg.getValue("proyear");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		//��ȡ����ָ��ID
		StringBuffer queryIndiSql = new StringBuffer();
		queryIndiSql.append("select d.detail_id,p.assess_name,d.check_content,d.monitor_type,d.monitor_pro_type,d.spare3"
						  + " from dms_assess_element_detail d"
						  + " left join dms_assess_plat_element p on d.element_id = p.assess_id"
						  + " left join dms_assess_plat_model m on p.assess_model_id = m.model_id"
						  + " where d.if_monitor = '1'"
						  + " and m.model_type = '"+DevConstants.DMS_ASSESS_MODEL_TYPE_ZB+"'"
						  + " order by p.assess_seq,d.detail_seq");

		List<Map> indiList = jdbcDao.queryRecords(queryIndiSql.toString());
		List<Map<String,Object>> datasList = new ArrayList<Map<String,Object>>();
		if(CollectionUtils.isNotEmpty(indiList)){
			for(Map subMap:indiList){
				subMap.put("yqfwzx", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_YQFWZX_SUB_ID, proYear));//������������
				subMap.put("clfwzx", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_CLFWZX_SUB_ID, proYear));//������������
				subMap.put("zyfwzx", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_ZYFWZX_SUB_ID, proYear));//��Դ��������
				subMap.put("bjzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_BJZYB_SUB_ID, proYear));//������ҵ��
				subMap.put("dhzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_DHZYB_SUB_ID, proYear));//�ػ���ҵ��
				subMap.put("hbzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_HBZYB_SUB_ID, proYear));//������ҵ��
				subMap.put("lhzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_LHZYB_SUB_ID, proYear));//�ɺ���ҵ��
				subMap.put("tlmzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_TLMZYB_SUB_ID, proYear));//����ľ��ҵ��
				subMap.put("thzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_THZYB_SUB_ID, proYear));//�¹���ҵ��
				subMap.put("xqzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_XQZYB_CODE, proYear));//������ҵ��
				subMap.put("cqzyb", this.getMonitorState(subMap.get("detail_id").toString(), DevConstants.DMS_INDICATORE_CQZYB_SUB_ID, proYear));//������ҵ��
				datasList.add(subMap);
			}
		}
		responseDTO.setValue("datas", datasList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		return responseDTO;
	}
	/**
	 * ��̽������ҳ���̵���ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHomeWTCMinitorList(ISrvMsg msg) throws Exception {
		log.info("queryHomeWTCMinitorList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String orgSubId = msg.getValue("orgsubid");
		String proYear = msg.getValue("proyear");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		//��ȡ����ָ��ID
		StringBuffer queryIndiSql = new StringBuffer();
		queryIndiSql.append("select t.org_id as duiorgid,n1.org_id as wtcorgid,n1.org_subjection_id as wtcsubid,"
					   + " n.org_abbreviation as wtcname,t.team_id as duiorgname,n2.org_subjection_id as duisubid"
					   + " from comm_org_team t"
					   + " join comm_org_information n on t.present_unit_id = n.org_id and n.bsflag = '0'"
					   + " join comm_org_subjection n1 on n.org_id = n1.org_id and n1.bsflag = '0'"
					   + " join comm_org_subjection n2 on n2.org_id = t.org_id and n2.bsflag = '0'"
					   + " where n1.org_subjection_id not like 'C105002%' and n1.org_subjection_id not like 'C105086%'"
					   + " and t.bsflag = '0' and t.team_specialty = '0100100015000000017'"
					   + " and t.if_registered = '1' and n1.org_subjection_id like '"+orgSubId+"%'");

		List<Map> indiList = jdbcDao.queryRecords(queryIndiSql.toString());
		List<Map<String,Object>> datasList = new ArrayList<Map<String,Object>>();
		if(CollectionUtils.isNotEmpty(indiList)){
			for(Map subMap:indiList){
				subMap.put("kgys", this.getMonitorState(DevConstants.DMS_INDICATORE_KGYS_DET_ID, subMap.get("duisubid").toString(), proYear));//��������
				subMap.put("bygl", this.getMonitorState(DevConstants.DMS_INDICATORE_BYGL_DET_ID, subMap.get("duisubid").toString(), proYear));//��������
				subMap.put("sbkq", this.getMonitorState(DevConstants.DMS_INDICATORE_SBKQ_DET_ID, subMap.get("duisubid").toString(), proYear));//�豸����
				subMap.put("drdj", this.getMonitorState(DevConstants.DMS_INDICATORE_DRDJ_DET_ID, subMap.get("duisubid").toString(), proYear));//���˶���
				subMap.put("yzjl", this.getMonitorState(DevConstants.DMS_INDICATORE_YZJL_DET_ID, subMap.get("duisubid").toString(), proYear));//��ת��¼
				subMap.put("sbfh", this.getMonitorState(DevConstants.DMS_INDICATORE_SBFH_DET_ID, subMap.get("duisubid").toString(), proYear));//�豸����
				subMap.put("sgys", this.getMonitorState(DevConstants.DMS_INDICATORE_SGYS_DET_ID, subMap.get("duisubid").toString(), proYear));//�չ�����
				//subMap.put("tzsbgl", this.getMonitorState(DevConstants.DMS_INDICATORE_TZSBGL_DET_ID, subMap.get("duisubid").toString(), proYear));//�����豸����
				subMap.put("dzyqpk", this.getMonitorState(DevConstants.DMS_INDICATORE_DZYQPK_DET_ID, subMap.get("duisubid").toString(), proYear));//���������̿�
				subMap.put("dzyqhs", this.getMonitorState(DevConstants.DMS_INDICATORE_DZYQHS_DET_ID, subMap.get("duisubid").toString(), proYear));//������������
				datasList.add(subMap);
			}
		}
		responseDTO.setValue("datas", datasList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ȡ��������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String getMonitorState(String detailId, String subId, String proYear){
		Calendar cal = Calendar.getInstance();
	    Integer curYear = cal.get(Calendar.YEAR);
	    if(StringUtils.isBlank(proYear)){
	    	proYear = curYear.toString();
		}
		String startDate = proYear + "-01-01";
	    String endDate = proYear + "-12-31";
	    if(Integer.parseInt(proYear)==curYear){
	    	Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			endDate = sdf.format(d);
	    }
	    String stateFlag = "0";
	    //��ȡ������Ϣ
	  	Map sqlMap = getMonitorScoreSql(detailId);
	    if(DevUtil.isValueNotNull(sqlMap.get("monitor_type").toString(),"1")){//���˵�λ����Ŀ�޹�
	    	stateFlag = getMonitorScoreState(sqlMap,"",subId);
	    }else{
		    //��ȡ��Ŀ��Ϣ
		  	List<Map> proList = getProjectInfo(proYear,sqlMap.get("monitor_pro_type").toString(),subId);
		  	
			if(CollectionUtils.isNotEmpty(proList)){
				for(Map fm:proList){
					if("1".equals(stateFlag)){
						break;
					}
					//��Ŀid
					String proInfoNo = fm.get("project_info_no").toString();
					stateFlag = getMonitorScoreState(sqlMap,proInfoNo,subId);
				}
			}else{
				stateFlag = "2";//����Ŀ����2
			}
	    }
		return stateFlag;
	}
	/**
	 * NEWMETHOD �Ӽ��ָ����̵���ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySonMonitorInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String wtcSubId = msg.getValue("wtcsubid");//��̽��subid
		String fieldId = msg.getValue("fieldid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.detail_id,d.check_content,d.spare3,'0' state"
				+ " from dms_assess_element_detail d"
				+ " where d.element_id = '"+fieldId+"' and d.if_monitor = '1'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.detail_id");
		}
		List<Map> datasList = pureDao.queryRecords(querySql.toString());
		responseDTO.setValue("datas", datasList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��̽����Ŀ���˺��̵�ʵʱ���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectStateMonitorInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		Calendar cal = Calendar.getInstance();
	    Integer curYear = cal.get(Calendar.YEAR);
	    String year = "";
	    if(StringUtils.isNotBlank(msg.getValue("proyear"))){
	    	year = msg.getValue("proyear");
	    }else{
	    	year = curYear.toString();
	    }
		String startDate = year + "-01-01";
	    String endDate = year + "-12-31";
	    if(Integer.parseInt(year)==curYear){
	    	Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			endDate = sdf.format(d);
	    }
		String detailId = msg.getValue("detailid");
		String monitorProType = msg.getValue("monitorprotype");
		String wtcSubId = DevUtil.getWtcSubId(msg.getValue("wtcsubid"));//��̽��/װ����ҵ��subid
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pro.project_info_no as projectinfono,pro.project_name as projectname,"
					  + " '0' as state,pro.acquire_start_time as startdate,pro.acquire_end_time as enddate,"
					  + " n.org_abbreviation as duiname,dy.org_subjection_id as orgsubid,dy.org_id as orgid"
					  + " from gp_task_project pro"
					  + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no and dy.bsflag = '0'"
					  + " left join comm_org_information n on n.org_id = dy.org_id and n.bsflag = '0'"
					  + " where pro.bsflag = '0' and pro.project_country = '1' and (pro.project_type = '5000100004000000001' or pro.project_type = '5000100004000000009')"
					  + " and ((to_char(nvl(pro.project_start_time, pro.acquire_start_time),'yyyy') = '"+year+"'"
					  + " or to_char(nvl(pro.project_end_time, pro.acquire_end_time), 'yyyy') = '"+year+"'"
					  + " or pro.project_year = '"+year+"'))");
					  if(DevUtil.isValueNotNull(monitorProType)&&"1".equals(monitorProType)){//���겻������������Ŀ
						  querySql.append(" and pro.project_status <> '5000100001000000003' and pro.project_status <> '5000100001000000005' ");
					  }else if(DevUtil.isValueNotNull(monitorProType)&&"2".equals(monitorProType)){//�����������Ŀ
						  querySql.append(" and (pro.project_status = '5000100001000000003' or pro.project_status = '5000100001000000005') ");
					  }
					  if(DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID.equals(wtcSubId)){
						  querySql.append(" and dy.org_subjection_id like 'C105%' and dy.org_subjection_id not like 'C105002%' and dy.org_subjection_id not like 'C105086%'");
					  }else if(wtcSubId.startsWith(DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID)
								&&wtcSubId.length() > 7){
						  querySql.append(" and pro.project_info_no in"
								    + " (select dui.project_info_id from gms_device_account_dui dui"
						            + " left join gms_device_account acc on acc.dev_acc_id = dui.fk_dev_acc_id"
						            + " where dui.project_info_id = pro.project_info_no and acc.owning_sub_id like '"+wtcSubId+"%' )");
						}else{
							querySql.append(" and dy.org_subjection_id like '"+wtcSubId+"%'");
					  }
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by pro.acquire_start_time");
		}
		List<Map> proList = pureDao.queryRecords(querySql.toString());
		String stateFlag = "0";
		//��ȡ������Ϣ
		Map sqlMap = getMonitorScoreSql(detailId);
		if(CollectionUtils.isNotEmpty(proList)){
			if(MapUtils.isNotEmpty(sqlMap)){
				for(Map proMap:proList){
				//	if("1".equals(stateFlag)){
				//		break;
				//	}
					//��Ŀid
					String fProjectInfoNo = proMap.get("projectinfono").toString();
					stateFlag = getMonitorScoreState(sqlMap,fProjectInfoNo,wtcSubId);
					proMap.put("state", stateFlag);
				}
			}
		}
		responseDTO.setValue("datas", proList);
		responseDTO.setValue("totalRows", proList.size());
		responseDTO.setValue("pageSize", proList.size());
		return responseDTO;
	}
	/**
	 * NEWMETHOD �������Ŀ���˺��̵�ʵʱ���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDuiProStateMonitorInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String year = "";
		Calendar cal = Calendar.getInstance();
	    Integer curYear = cal.get(Calendar.YEAR);
	    if(StringUtils.isNotBlank(msg.getValue("proyear"))){
	    	year = msg.getValue("proyear");
	    }else{
	    	year = curYear.toString();
	    }
		String startDate = year + "-01-01";
	    String endDate = year + "-12-31";
	    if(Integer.parseInt(year)==curYear){
	    	Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			endDate = sdf.format(d);
	    }
	    String monitorProType = "";
	    String chkDesc = "";
		String duiSubId = msg.getValue("duisubid");
		String detailId = DevUtil.getMonitorDetailId(msg.getValue("typeid"));
		String detSql = "select d.spare3,d.monitor_pro_type"
				      + " from dms_assess_element_detail d "
				      + " where d.detail_id = '"+detailId+"'";
		Map detList = pureDao.queryRecordBySQL(detSql);
		if(MapUtils.isNotEmpty(detList)){
			monitorProType = detList.get("monitor_pro_type").toString();
			chkDesc = detList.get("spare3").toString();
		}		
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pro.project_info_no as projectinfono,pro.project_name as projectname,"
					  + " '0' as state,pro.acquire_start_time as startdate,pro.acquire_end_time as enddate,"
					  + " n.org_abbreviation as duiname,dy.org_subjection_id as orgsubid,dy.org_id as orgid"
					  + " from gp_task_project pro"
					  + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no and dy.bsflag = '0'"
					  + " left join comm_org_information n on n.org_id = dy.org_id and n.bsflag = '0'"
					  + " where pro.bsflag = '0' and pro.project_country = '1' and (pro.project_type = '5000100004000000001' or pro.project_type = '5000100004000000009')"
					  + " and ((to_char(nvl(pro.project_start_time, pro.acquire_start_time),'yyyy') = '"+year+"'"
					  + " or to_char(nvl(pro.project_end_time, pro.acquire_end_time), 'yyyy') = '"+year+"'"
					  + " or pro.project_year = '"+year+"'))");
					  if(DevUtil.isValueNotNull(monitorProType)&&"1".equals(monitorProType)){//���겻������������Ŀ
						  querySql.append(" and pro.project_status <> '5000100001000000003' and pro.project_status <> '5000100001000000005' ");
					  }else if(DevUtil.isValueNotNull(monitorProType)&&"2".equals(monitorProType)){//�����������Ŀ
						  querySql.append(" and (pro.project_status = '5000100001000000003' or pro.project_status = '5000100001000000005') ");
						}
					  if(DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID.equals(duiSubId)){
						  querySql.append(" and dy.org_subjection_id like 'C105%' and dy.org_subjection_id not like 'C105002%' and dy.org_subjection_id not like 'C105086%'");
					  }else{
							querySql.append(" and dy.org_subjection_id like '"+duiSubId+"%'");
					  }
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by pro.acquire_start_time");
		}
		List<Map> proList = pureDao.queryRecords(querySql.toString());
		String stateFlag = "0";
		//��ȡ������Ϣ
		Map sqlMap = getMonitorScoreSql(detailId);
		if(CollectionUtils.isNotEmpty(proList)){
			if(MapUtils.isNotEmpty(sqlMap)){
				for(Map proMap:proList){
					//��Ŀid
					String fProjectInfoNo = proMap.get("projectinfono").toString();
					stateFlag = getMonitorScoreState(sqlMap,fProjectInfoNo,duiSubId);
					proMap.put("state", stateFlag);
					proMap.put("chkdesc",chkDesc);
				}
			}
		}
		responseDTO.setValue("datas", proList);
		responseDTO.setValue("totalRows", proList.size());
		responseDTO.setValue("pageSize", proList.size());
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ȡ����sql��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public Map getMonitorScoreSql(String detailId){
		String dSql = "select d.detail_id as indexid,d.check_content as indexname,d.spare3 as criterion,"
				    + " d.score_ceiling,d.score_floor,d.monitor_type,d.monitor_pro_type"
					+ " from dms_assess_element_detail d "
					+ " where d.detail_id = '"+detailId+"'";
		Map dList = pureDao.queryRecordBySQL(dSql);//.queryRecords();
		if(MapUtils.isNotEmpty(dList)){
				String sql = ""; 
				//����sql
				String rsql = "select t.relation_id,t.conf_id,t.score_condition "
							+ " from comm_autoscore_relation t"
							+ " where t.bsflag = '0' and t.business_id='"+detailId+"'";
				Map rmap = jdbcDao.queryRecordBySQL(rsql);
				if(MapUtils.isNotEmpty(rmap)){
					String conf_id = rmap.get("conf_id") == null ? "" : (String) rmap.get("conf_id");
					String score_condition = rmap.get("score_condition") == null ? "" : (String) rmap.get("score_condition");
					if(!"".equals(conf_id)){
						//�Զ�������������Ϣ
						String csql = "select t.conf_id,t.conf_content_type,t.conf_table_name,t.conf_column_name,t.conf_content "
									+ " from comm_autoscore_conf t"
									+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
						Map map = jdbcDao.queryRecordBySQL(csql);
						String fsql = "select t.conf_filter_id,t.connect_type,t.filter_column_type,t.date_type_format,t.filter_column_name,t.query_type,t.filter_column_value "
									+ " from comm_autoscore_conf_filter t"
									+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
						List<Map> list = jdbcDao.queryRecords(fsql);
						if(MapUtils.isNotEmpty(map)){
							Map gmap = new HashMap();
							gmap.put(map, list);
							try {
								if(StringUtils.isNotBlank(score_condition)){
									sql = "select "+score_condition+" from ( "+CommonUtil.getAutoScoreSql(gmap)+" )";
								}else{
									sql = CommonUtil.getAutoScoreSql(gmap);
								}
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
					}
				}
				//System.out.println("sql == "+sql);
				dList.put("sql", sql);
		}
		return dList;
	}
	/**
	 * NEWMETHOD ��ȡ����״̬ 0:���� 1������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String getMonitorScoreState(Map monitorMap,String projectInfoNo,String subId){
		String stateFlag = "0";
		//����sql
		if(MapUtils.isNotEmpty(monitorMap)){
			String scoreSql = monitorMap.get("sql").toString();
			if(scoreSql.indexOf("?")!=-1){
				scoreSql = scoreSql.replace("?",subId);
			}
			if(scoreSql.indexOf("rp_project_info_no_vaule")!=-1){
				scoreSql = scoreSql.replace("rp_project_info_no_vaule",projectInfoNo);
			}
			
			//if(DevUtil.isValueNotNull(monitorMap.get("monitor_type").toString(),"1")){
			//	scoreSql = monitorMap.get("sql").toString().replace("?",subId);
			//}else{
			//	scoreSql = monitorMap.get("sql").toString().replace("rp_project_info_no_vaule",projectInfoNo);
			//}
			
			if(scoreSql.indexOf("@@")!=-1){
				if(DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID.equals(subId)){
					scoreSql = scoreSql.replace("@@", " like ");
				}else{
					scoreSql = scoreSql.replace("@@", " not like ");
				}
			}
			
			Map scoreMap = jdbcDao.queryRecordBySQL(scoreSql);
			if(MapUtils.isEmpty(scoreMap)){
				stateFlag = "1";
			}else{
				float score = Float.parseFloat(scoreMap.get("score_value")==null ? "0" : scoreMap.get("score_value").toString());
				if(Float.compare(score, (float)0) == 0){
					stateFlag = "1";
				}else{
					//��������
					float scoreCeiling = Float.parseFloat(monitorMap.get("score_ceiling").toString());
					//��������
					float scoreFloor = Float.parseFloat(monitorMap.get("score_floor").toString());
					if(Float.compare(scoreCeiling, (float)0)>0 && Float.compare(scoreFloor,(float) 0)>0){
						if(Float.compare(scoreFloor,score) > 0 || Float.compare(scoreCeiling,score)<0){
							stateFlag = "1";
						}
					}
					if(Float.compare(scoreCeiling, (float)0)==0 && Float.compare(scoreFloor,(float)0)>0){
						if(Float.compare(scoreFloor,score) > 0){
							stateFlag = "1";
						}
					}
					if(Float.compare(scoreCeiling, (float)0)>0 && Float.compare(scoreFloor,(float)0)==0){
						if(Float.compare(scoreCeiling,score)<0){
							stateFlag = "1";
						}
					}
				}
			}
		}
		return stateFlag;
	}
	/**
	 * //ɾ������
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delAssessScore(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String score_id=msg.getValue("score_id");
		String sql="update  dms_assess_score t  set bsflag='1'  where  t.score_id='"+score_id+"'";
		try {
			jdbcDao.executeUpdate(sql);
		} catch (Exception e) {
			// TODO: handle exception
			responseDTO.setValue("datas", "3");
		}
		responseDTO.setValue("datas", "0");
		return responseDTO;
	}
	/**
	 * ��������ҳ��
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateScore(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		 
		String  scoreData=msg.getValue("scoreData");
		String score_id=msg.getValue("score_id");
		//����޸���ɾ����ǰ�����ٱ���
		if(StringUtils.isNotBlank(score_id)&&!"null".equals(score_id)){
			String sql2="delete from dms_assess_score_element t where t.assess_score_id='"+score_id+"'";
			String sql3="delete from dms_assess_score_element_det t where t.element_score_id in (select t1.element_id from dms_assess_score_element t1 where t1.assess_score_id='"+score_id+"')";
			jdbcDao.executeUpdate(sql3);
			jdbcDao.executeUpdate(sql2);
			 
		}
		JSONObject jsonObject=new JSONObject(scoreData);
		org.json.JSONArray array = jsonObject.getJSONArray("datas");
		String sacoreyear=msg.getValue("sacoreyear");
		String sacoremonth=msg.getValue("sacoremonth");
		//�����޸�ʱ�� ���޸���
		if(StringUtils.isNotBlank(score_id)&&!"null".equals(score_id)){
			String sql="select *  from dms_assess_score t where  t.score_id='"+score_id+"'";
			Map dms_assess_score =jdbcDao.queryRecordBySQL(sql);
			dms_assess_score.put("MODIFY_DATE", DevUtil.getCurrentTime());
			dms_assess_score.put("MODIFIER", user.getEmpId());
			jdbcDao.saveOrUpdateEntity(dms_assess_score, "dms_assess_score");
		}else{
		//��������
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("SCORE_YEAR",sacoreyear);
		dataMap.put("SCORE_MONTH", sacoremonth);
		dataMap.put("SCORE_USER_ID", user.getEmpId());
		dataMap.put("SCORE_MODEL_ID", "239E5B34967G47CBE050580A80F80B8F");
		dataMap.put("CREATOR", user.getEmpId());
		dataMap.put("CREATE_DATE", DevUtil.getCurrentTime());
		dataMap.put("BSFLAG", CommonConstants.BSFLAG_NORMAL);
		score_id = (String) jdbcDao.saveEntity(dataMap, "dms_assess_score");
		}
		ArrayList<String> sqls=new ArrayList<String>();//��Ŷ���ָ����������sql
		Map<String,String> map=new HashMap<String,String>();//ȥ�ؼ���
		Map<String,String> mapId=new HashMap<String,String>();//ȥ�غ�һ��ָ�걣��IDӳ��
		for (int i = 0; i < array.length(); i++) {
			JSONObject obj=(JSONObject) array.get(i);
			String element_id= obj.getString("element_id");
			String name= obj.getString("name");
			map.put(element_id+name, element_id+"_"+name);
		}
		//����ȥ�غ�һ��ָ��
		 for (Map.Entry entry : map.entrySet()) {
			    String key = entry.getKey().toString();
			    String value = entry.getValue().toString();
			    Map<String, Object> element = new HashMap<String, Object>();
				element.put("ASSESS_ELEMENT_ID", value.split("_")[0]);
				element.put("ASSESS_SCORE_ID", score_id);
				element.put("BSFLAG", CommonConstants.BSFLAG_NORMAL);
				element.put("SCORE_ORG_ID", DevUtil.getWtcOrgId(value.split("_")[1]));
				element.put("SCORE_SUB_ID", DevUtil.getWtcSubId(value.split("_")[1]));
				String element_id = (String) jdbcDao.saveOrUpdateEntity(element, "DMS_ASSESS_SCORE_ELEMENT");
				mapId.put(key, element_id);
		}
		 
		//�����������ָ��
		for (int i = 0; i < array.length(); i++) {
			JSONObject obj=(JSONObject) array.get(i);
			String element_id= obj.getString("element_id");
			String name= obj.getString("name");
		    String sql="insert into DMS_ASSESS_SCORE_ELEMENT_DET (DET_ID,ELEMENT_ASSESS_ID,ELEMENT_SCORE_ID,DET_SCORE,BSFLAG,SCORE_ORG_ID,SCORE_SUB_ID) values('"+jdbcDao.generateUUID()+"','"+obj.get("detail_id")+"','"+mapId.get(element_id+name)+"','"+obj.get("value")+"','"+CommonConstants.BSFLAG_NORMAL+"','"+DevUtil.getWtcOrgId(obj.getString("name"))+"','"+DevUtil.getWtcSubId(obj.getString("name"))+"')";
		    sqls.add(sql); 
		}
		 
		String [] updateSql= (String[]) sqls.toArray(new String[sqls.size()]);
		jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		responseDTO.setValue("msg", "����ɹ�");
		return responseDTO;
	}
	
	/**
	 * ��ѯ����ά�޼�¼
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String score_id = msg.getValue("score_id");
		String querySql = "select * from dms_assess_score where score_id='"+score_id+"'";
 
		Map repairInfoMap = this.jdbcDao.queryRecordBySQL(querySql);
		responseDTO.setValue("nowYear", repairInfoMap.get("score_year"));
		responseDTO.setValue("month", repairInfoMap.get("score_month"));
		return responseDTO;
	}
	
	/**
	 * ��������ҳ��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMinitorScore(ISrvMsg msg) throws Exception {
		log.info("queryMinitorScore");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String score_id=msg.getValue("score_id");//����ID���ж��Ƿ��ѯ�����޸�
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		List<Map> datasList = new ArrayList<Map>();
		//�ж�����ӻ����޸�
		if(StringUtils.isNotBlank(score_id)&&!"null".equals(score_id)){//�޸Ĳ���
			String sql = "select t1.element_assess_id detail_id,p.assess_name,d.check_content,"
					   + " d.spare3,d.standard_score,d.element_id,assess_seq,"
					   + " sum(decode(t1.score_sub_id, 'C105002', det_score,null)) as gjktsyb,"
					   + " sum(decode(t1.score_sub_id, 'C105001005', det_score,null)) as tlmwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105001002', det_score,null)) as xjwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105001003', det_score,null)) as thwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105001004', det_score,null)) as qhwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105005004', det_score,null)) as cqwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105007', det_score,null)) as dgwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105063', det_score,null)) as lhwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105005000', det_score,null)) as hbwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105005001', det_score,null)) as xxwtkfc,"
					   + " sum(decode(t1.score_sub_id, 'C105008', det_score,null)) as zhwhtc,"
					   + " sum(decode(t1.score_sub_id, 'C105087', det_score,null)) as xnwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105092', det_score,null)) as dqygs,"
					   + " sum(decode(t1.score_sub_id, 'C105093', det_score,null)) as dqegs,"
					   //+ " sum(decode(t1.score_sub_id, 'C105086', det_score,null)) as shwtc,"
					   + " sum(decode(t1.score_sub_id, 'C105006', det_score,null)) as zbfwc"
					   + " from dms_assess_score_element_det t1"
					   + " left join dms_assess_score_element t2 on t1.element_score_id = t2.element_id"
					   + " left join dms_assess_score t3 on t3.score_id = t2.assess_score_id"
					   + " left join dms_assess_plat_element p on t2.assess_element_id = p.assess_id"
					   + " left join dms_assess_element_detail d on d.detail_id=t1.element_assess_id"
					   + " where t3.score_id = '"+score_id+"'"
					   + " group by element_assess_id,assess_name,check_content,d.spare3,"
					   + " d.standard_score,d.element_id,assess_seq order by p.assess_seq";
			datasList = jdbcDao.queryRecords(sql);
		}else{//��Ӳ���
		//��ȡ����ָ��ID
		StringBuffer queryIndiSql = new StringBuffer();
		queryIndiSql.append("select d.detail_id,p.assess_name,d.check_content,d.monitor_type,"
						  + " d.monitor_pro_type,d.spare3,d.standard_score,d.element_id"
						  + " from dms_assess_element_detail d"
						  + " left join dms_assess_plat_element p on d.element_id = p.assess_id"
						  + " left join dms_assess_plat_model m on p.assess_model_id = m.model_id"
						  + " where m.model_type = '"+DevConstants.DMS_ASSESS_MODEL_TYPE_WTC+"'"
						  + " order by p.assess_seq");

		List<Map> indiList = jdbcDao.queryRecords(queryIndiSql.toString());
	
		if(CollectionUtils.isNotEmpty(indiList)){
			for(Map subMap:indiList){
				subMap.put("gjktsyb", this.getMonitorScore(subMap.get("detail_id").toString(),subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(), "C105002"));//���ʿ�̽��ҵ��
				subMap.put("tlmwtc", this.getMonitorScore(subMap.get("detail_id").toString(),subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(), "C105001005"));//����ľ��̽��
				subMap.put("xjwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105001002"));//�½���̽��
				subMap.put("thwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105001003"));//�¹���̽��
				subMap.put("qhwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105001004"));//�ຣ��̽��
				subMap.put("cqwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105005004"));//������̽��
				subMap.put("dgwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105007"));//������̽��
				subMap.put("lhwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105063"));//�ɺ���̽��
				subMap.put("hbwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105005000"));//������̽��
				subMap.put("xxwtkfc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105005001"));//������̽������
				subMap.put("zhwhtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105008"));//�ۺ��ﻯ̽��
				subMap.put("xnwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105087"));//������̽��
				subMap.put("dqygs", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105092"));//������̽һ��˾
				subMap.put("dqegs", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105093"));//������̽����˾
				//subMap.put("shwtc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105086"));//���̽��
				subMap.put("zbfwc", this.getMonitorScore(subMap.get("detail_id").toString(), subMap.get("monitor_type").toString(),subMap.get("monitor_pro_type").toString(),"C105006"));//װ������
				datasList.add(subMap);
			}
		}
		}
		responseDTO.setValue("datas", datasList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ȡ�������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String getMonitorScore(String detailId,String monitorType,String monitorProType,String subId){
		Calendar cal = Calendar.getInstance();
	    Integer curYear = cal.get(Calendar.YEAR);
		String year = curYear.toString();
		String startDate = year + "-01-01";
	    String endDate = year + "-12-31";
	    if(Integer.parseInt(year)==curYear){
	    	Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			endDate = sdf.format(d);
	    }
	    String scoreValue = "";
	    //��ȡ������Ϣ
	  	Map sqlMap = getMonitorScoreSql(detailId);
	    if(DevUtil.isValueNotNull(monitorType)&&"1".equals(monitorType)){
	    	scoreValue = getMonitorScoreValue(sqlMap,"",subId,monitorType);
	    }else if(DevUtil.isValueNotNull(monitorType)&&"2".equals(monitorType)){
	    	scoreValue = "0";
	    }else{
		    //��ȡ��Ŀ��Ϣ
		  	List<Map> proList = getProjectInfo(year,monitorProType,subId);		  	
			if(CollectionUtils.isNotEmpty(proList)){
				for(Map fm:proList){
					//��Ŀid
					String proInfoNo = fm.get("project_info_no").toString();
					scoreValue = getMonitorScoreValue(sqlMap,proInfoNo,subId,monitorType);
				}
			}else{
				scoreValue = "0";//����Ŀ����
			}
	    }
		return scoreValue;
	}
	/**
	 * NEWMETHOD ��ȡ����
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public String getMonitorScoreValue(Map monitorSql,String projectInfoNo,String subId,String monitorType){
		String scoreValue = "0";
		//����sql
		if(MapUtils.isNotEmpty(monitorSql)){
			String scoreSql = "";
			if(DevUtil.isValueNotNull(monitorType) && "1".equals(monitorType)){
				scoreSql = monitorSql.get("sql").toString().replace("?",subId);
			}else{
				scoreSql = monitorSql.get("sql").toString().replace("rp_project_info_no_vaule",projectInfoNo);
			}
			
			if(scoreSql.indexOf("@@")!=-1){
				if("C105006".equals(subId)){
					scoreSql = scoreSql.replace("@@", " like ");
				}else{
					scoreSql = scoreSql.replace("@@", " not like ");
				}
			}
			
			Map scoreMap = jdbcDao.queryRecordBySQL(scoreSql);
			if(MapUtils.isEmpty(scoreMap)){
				scoreValue = "0";
			}else{
				scoreValue = scoreMap.get("score_value")==null ? "0" : scoreMap.get("score_value").toString();
			}
		}
		return scoreValue;
	}
	
	}

 


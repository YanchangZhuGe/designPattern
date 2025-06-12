package com.bgp.dms.check;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
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

public class CheckDevQuestion extends BaseService{
	public CheckDevQuestion() {
		log = LogFactory.getLogger(CheckDevQuestion.class);
}
private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	/**
 	* 查询验收问题列表
 	* @param isrvmsg
 	* @return
 	* @throws Exception
 	*/
	public ISrvMsg queryCheckQuestionInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckQuestionInfoList");
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
		String ck_cid = isrvmsg.getValue("ck_cid");// 验收单号
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select count(case when t.bsflag='0' then 1 end) count ,"+ 
				"count(case when t.question_info='已解决' and t.bsflag='0' then 1 end) count_finish,"+
				"case when count(case when t.bsflag='0' then 1 end)=0 then NULL else round((count(case when t.question_info='已解决' then 1 end)/count(case when t.bsflag='0' then 1 end)),2)*100||'%' end percent,"+
				" case when count(case when t.bsflag='0' then 1 end)=0 then NULL else round((count(case when t.question_info='已解决' then 1 end)/count(case when t.bsflag='0' then 1 end)),2)*100 end percent2,"+
				"t.ck_id, t.ck_cid, t.pact_num from dms_device_check_question t, dms_device_check c "+
				"left join comm_org_subjection t4 on c.ck_sector=t4.org_id "+
				"left join comm_org_information t5 on t4.org_subjection_id = t4.org_id "+
				"where t.ck_id = c.ck_id ");
		System.out.println(querySql);
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and t4.org_subjection_id  like '%" + orgSubId + "%' " );
			}
		}	
		querySql.append(" group by t.ck_id,t.pact_num,t.ck_cid having count(case when t.bsflag='0' then 1 end)>0");
		if (StringUtils.isNotBlank(ck_cid)) {
			querySql.append("and t.ck_cid like '%" + ck_cid + "%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by percent2,t.ck_id");
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
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String question_id = isrvmsg.getValue("question_id");// 问题追踪id
		String msql = "select t.* from dms_device_check_question t where t.question_id = '"+question_id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}


	/**
	 * NEWMETHOD
	 * 修改问题跟踪信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateCheckQuestionInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateCheckQuestionInfo");
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> strMap = new HashMap<String,Object>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		System.out.println("=============================================");
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String employee_id = user.getEmpId();
		String question_serctor = (String)map.get("question_serctor");
		String y_date = (String)map.get("y_date");
		String question_info = (String)map.get("question_info");
		String s_date = (String)map.get("s_date");
		String question_function = (String)map.get("question_function");
		String flag= (String)map.get("flag");
		String question_id=(String)map.get("question_id");//保存表主键
		String ck_id = (String)map.get("ck_id");
		System.out.println(flag);
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("update".equals(flag)){//修改操作
			Map umainMap=new HashMap();
			umainMap.put("ck_id", ck_id);//设备验收ID
			umainMap.put("question_id", question_id);//问题追踪ID
			umainMap.put("y_date", y_date);//年度
			umainMap.put("question_serctor", question_serctor);//问题解决单位
			umainMap.put("question_info", question_info);//问题描述
			umainMap.put("s_date", s_date);
			umainMap.put("question_function", question_function);
			umainMap.put("updator", employee_id);
			umainMap.put("modify_date", currentdate);
			umainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			ServiceUtils.setCommFields(umainMap, "question_id", user);
			jdbcDao.saveOrUpdateEntity(umainMap, "dms_device_check_question");
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		return responseDTO;
	}
	
	/**
 	* 查询验收问题信息列表
 	* @param isrvmsg
 	* @return
 	* @throws Exception
 	*/
	public ISrvMsg queryCheckQuestionList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckQuestionList");
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
		String ck_id = isrvmsg.getValue("ck_id");// 验收单号ID
		StringBuffer querySql = new StringBuffer();
		querySql.append("select q.*  "
				+ "from dms_device_check_question q "
				+ "where q.bsflag=0 and q.ck_id = '"+ ck_id + "'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 删除指定信息
	 */
	public ISrvMsg deleteCheckQuestionInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteCheckQuestionInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String question_id = isrvmsg.getValue("question_id");// 设备验收id
		try{
			String delSql = "update dms_device_check_question set bsflag='1' where question_id='"+question_id+"'";
			jdbcDao.executeUpdate(delSql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}


}

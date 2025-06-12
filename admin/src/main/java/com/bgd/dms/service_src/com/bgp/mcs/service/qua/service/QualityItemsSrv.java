package com.bgp.mcs.service.qua.service;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class QualityItemsSrv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	/**
	 * 公共 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveQuality(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sqls = reqDTO.getValue("sql");
		sqls = java.net.URLDecoder.decode(sqls,"UTF-8");
		System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			if(sql[i]!=null && !sql[i].trim().equals("")){
				jdbcTemplate.execute(sql[i]);
			}
		}
		return msg;
	}
	public void saveQualityBySql(String sqls) throws Exception {
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			if(sql[i]!=null && !sql[i].trim().equals("")){
				jdbcTemplate.execute(sql[i]);
			}
		}
	}
	/**
	 * 质量检查项编码，形成树
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getQualityCodes(ISrvMsg reqDTO) throws Exception{
		List list = new ArrayList();
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select t.coding_sort_id id, t.coding_sort_name name from comm_coding_sort t ")
		.append(" where t.bsflag='0' and t.coding_sort_id!='5000100100' and t.spare2 ='"+project_type+"'")
		.append(" and t.coding_sort_id like '50001001%' order by t.coding_sort_id asc");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i =0;list!=null && i<list.size();i++){
			Map map = (Map)list.get(i);
			if(map.get("id")!=null && !map.get("id").equals("")){
				String sortId = (String)map.get("id");
				String name = (String)map.get("name");
				String id_name = sortId+"_"+name;
				map.put("id_name", id_name);
				List tList = getQualityCodeDetail(sortId,project_type);
				if (tList != null && tList.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(tList);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", false);
				} else {
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}
				jsList.add(map);
			}
		}
		JSONArray json = null;

		json = JSONArray.fromObject(jsList);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json",json.toString());
		
		return msg;
	}
	public List getQualityCodeDetail(String sortId,String project_type) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select d.coding_code_id id,d.coding_name name from comm_coding_sort_detail d ")
		.append(" where d.bsflag='0' and d.coding_mnemonic_id='"+project_type+"'")
		.append(" and d.coding_sort_id = '").append(sortId).append("'")
		.append(" order by d.coding_code_id asc");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List tList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			String id_name = id+"_"+name;
			map.put("id_name", id_name);
			if(map.get("id")!=null && !map.get("id").equals("")){
				map.put("children", null);
				map.put("leaf", true);
				map.put("expanded", false);
				tList.add(map);
			}
		}
		return tList;
	}
	
	/**
	 * 质量检查项编码页面页面
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg toQualityCodes(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String sortId = reqDTO.getValue("sortId");
		String sortName = reqDTO.getValue("sortName");
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		List codeList = new ArrayList();
		if(sortId!=null && sortId.equals("quality")){
			StringBuffer sql = new StringBuffer();
			sql.append("select t.coding_sort_id code_id, t.coding_sort_id id, t.coding_sort_name name,t.sort_remark spare1 ,")
			.append(" decode(t.locked_if ,'1' ,'不可修改' ,'') locked_if ,decode(t.locked_if ,'1' ,'disabled=disabled' ,'') locked")
			.append(" from comm_coding_sort t where t.bsflag='0' and t.coding_sort_id!='5000100100' and t.spare2 ='"+project_type+"'")
			.append(" order by t.coding_sort_id");
			System.out.println(sql.toString());
			codeList = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
			page = jdbcDao.queryRecordsBySQL(sql.toString(), page);
		}
		else {
			StringBuffer sql = new StringBuffer();
			sql.append("select d.coding_code_id code_id, d.coding_code_id id, d.coding_name name,d.note spare1 ,")
			.append(" decode(d.locked_if ,'1' ,'不可修改' ,'') locked_if ,decode(d.locked_if ,'1' ,'disabled=disabled' ,'') locked")
			.append(" from comm_coding_sort_detail d where d.bsflag='0' and d.coding_mnemonic_id='"+project_type+"'")
			.append(" and d.coding_sort_id='").append(sortId).append("'")
			.append(" order by d.coding_code_id");
			System.out.println(sql.toString());
			page = jdbcDao.queryRecordsBySQL(sql.toString(), page);
		}
		codeList = page.getData();
		msg.setValue("datas", codeList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 保存质量检查项编码页面
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg saveQualityCodes(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String sortId = reqDTO.getValue("sortId");
		String id = reqDTO.getValue("id");
		String name = reqDTO.getValue("name");
		String spare1 = reqDTO.getValue("spare1");
		String status = reqDTO.getValue("status");
		if(sortId!=null && sortId.equals("quality")){
			Map map = new HashMap();
			map.put("modify_level", "02");
			map.put("coding_sort_name", name);
			map.put("coding_frame", "2,0");
			if(spare1==null || spare1.trim().equals("")){
				spare1 = "";
			}
			map.put("sort_remark", spare1);
			map.put("spare2", project_type);
			map.put("bsflag", "0");
			map.put("modifi_date", new Date());
			
			if(status!=null && status.trim().equals("modify")){
				map.put("coding_sort_id", id);
			}else{
				map.put("locked_if", "0");
				map.put("creator", user.getUserId());
				map.put("create_date", new Date());
				map.put("creator_id", user.getUserId());
			}
			Serializable uId =BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"COMM_CODING_SORT");
			if(status!=null && status.trim().equals("add")){
				StringBuffer sb  = new StringBuffer();
				sb.append("update comm_coding_sort t set t.coding_sort_id='")
				.append(id).append("' where t.coding_sort_id='").append(uId).append("' and t.spare2='"+project_type+"'");
				jdbcDao.executeUpdate(sb.toString());
			}
		}
		else {
			Map map = new HashMap();
			map.put("modify_level", "02");
			map.put("coding_sort_id", sortId);
			map.put("coding_code", "02");
			map.put("coding_name", name);
			map.put("coding_mnemonic_id", project_type);
			map.put("superior_code_id", "1");
			map.put("cite_if", "1");
			map.put("end_if", "1");
			map.put("edition_nameplate", "1");
			if(spare1==null || spare1.trim().equals("")){
				spare1 = "";
			}
			map.put("note", spare1);
			map.put("code_afford_org_id", user.getSubOrgIDofAffordOrg());
			map.put("bsflag", "0");
			map.put("modifi_date", new Date());
			System.out.println(map);
			if(status!=null && status.trim().equals("modify")){
				map.put("coding_code_id", id);
			}else{
				map.put("locked_if", "0");
				map.put("creator", user.getUserId());
				map.put("create_date", new Date());
				map.put("creator_id", user.getUserId());
			}
			Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"COMM_CODING_SORT_DETAIL");
			if(status!=null && status.trim().equals("add")){
				StringBuffer sb  = new StringBuffer();
				sb.append("update comm_coding_sort_detail t set t.coding_code_id='")
				.append(id).append("' where t.coding_code_id='").append(uId).append("' and t.coding_mnemonic_id ='"+project_type+"'");
				jdbcDao.executeUpdate(sb.toString());
			}
		}
		return msg;
	}
	/**
	 * 质量检查项类型得 --> 不合格项类型
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteCode(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String code_id = reqDTO.getValue("code_id");
		String sort_id = reqDTO.getValue("sort_id");
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		if(sort_id!=null && sort_id.trim().equals("quality")){
			StringBuffer sb = new StringBuffer();
			sb.append("delete comm_coding_sort_detail t ")
			.append(" where t.coding_sort_id='").append(code_id).append("' and t.coding_mnemonic_id='"+project_type+"'");
			jdbcDao.executeUpdate(sb.toString());
			sb = new StringBuffer();
			sb.append("delete comm_coding_sort t ")
			.append(" where t.coding_sort_id='").append(code_id).append("' and t.spare2='"+project_type+"'");
			jdbcDao.executeUpdate(sb.toString());
		}
		else{
			StringBuffer sb = new StringBuffer();
			sb.append("delete comm_coding_sort_detail t ")
			.append(" where t.coding_code_id='").append(code_id).append("' and t.coding_mnemonic_id='"+project_type+"'");
			jdbcDao.executeUpdate(sb.toString());
		}
		return msg;
	}
	/**
	 * 单炮评价--> 树
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getSingleShot(ISrvMsg reqDTO) throws Exception{
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		/*List list = new ArrayList();
		StringBuffer sb = new StringBuffer();
		sb.append("select t.coding_sort_id id, t.coding_sort_name name from comm_coding_sort t ")
		.append(" where t.bsflag='0' and t.coding_sort_id ='5000100100' ")//and t.spare2 ='"+project_type+"'
		.append(" order by t.coding_sort_id asc ");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i =0;list!=null && i<list.size();i++){
			Map map = (Map)list.get(i);
			if(map.get("id")!=null && !map.get("id").equals("")){
				String sortId = (String)map.get("id");
				String name = (String)map.get("name");
				List tList = getSingleShotDetail(sortId,project_type);
				if (tList != null && tList.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(tList);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", true);
				} else {
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
				}
				jsList.add(map);
			}
		}*/
		JSONArray json = null;
		
		List jsList = getSingleShotDetail("5000100100",project_type);
		
		json = JSONArray.fromObject(jsList);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json",json.toString());
		
		return msg;
	}
	public List getSingleShotDetail(String sortId,String project_type) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select d.coding_code_id id,d.coding_name name from comm_coding_sort_detail d ")
		.append(" where d.bsflag='0' and d.coding_sort_id = '").append(sortId).append("'")
		.append(" and d.coding_mnemonic_id='"+project_type+"' order by d.coding_code_id");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List tList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			if(map.get("id")!=null && !map.get("id").equals("")){
				map.put("children", null);
				map.put("leaf", true);
				map.put("expanded", false);
				tList.add(map);
			}
		}
		return tList;
	}
	/**
	 *文档树 -->物探处
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getFileTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String module_id = (String)reqDTO.getValue("module_id");
		String file_abbr = (String)reqDTO.getValue("file_abbr");
		if(file_abbr ==null || file_abbr.trim().equals("")){
			file_abbr = "";
		}
		String id ="";
		String name = "";
		List jsList = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select f.file_id id ,f.file_name name ,f.is_file isFile from bgp_doc_gms_file f  ")
		.append(" where f.bsflag = '0' and f.parent_file_id is null and f.is_template is null")
		.append(" and f.project_info_no is null and f.is_file = '0'");
		Map root = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(root==null){
			id = "8ad89177386fb69e01386fb871de0002";
			name = "东方地球物理公司";
			root.put("id", id);
			root.put("name", name);
			root.put("isFile", "0");
		}else if(root.get("id")!=null){
			id = (String)root.get("id");
			name = (String)root.get("name");
		}
		List tList = getFileFirstChild(module_id,file_abbr);
		if (tList != null && tList.size() > 0) {
			JSONArray jsonarray = JSONArray.fromObject(tList);
			root.put("children", jsonarray);
			root.put("leaf", false);
			root.put("expanded", true);
		}else {
			root.put("children", null);
			root.put("leaf", true);
			root.put("expanded", true);
		}
		jsList.add(root);
		JSONArray json = null;
		json = JSONArray.fromObject(jsList);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json",json.toString());
		
		return msg;
	}
	public List getFileFirstChild(String module_id,String file_abbr) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select f.file_id id ,f.file_name name ,f.is_file isFile from bgp_doc_folder_module t")
		.append(" left join bgp_doc_gms_file f on t.folder_id = f.file_id and f.bsflag='0'")
		.append(" where t.bsflag='0' and t.project_info_no is null and  t.module_id ='").append(module_id).append("'");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			map.put("checked", false);
			List tList = getFileTreeChild(id,file_abbr);
			if (tList != null && tList.size() > 0) {
				JSONArray jsonarray = JSONArray.fromObject(tList);
				map.put("children", jsonarray);
				map.put("leaf", false);
				map.put("expanded", false);
			} else {
				map.put("children", null);
				map.put("leaf", true);
				map.put("expanded", false);
				continue;
			}
			jsList.add(map);
		}
		return list;
	}
	public List getFileTreeChild(String fileId,String file_abbr) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select  t.file_id id, t.file_name name ,t.is_file isFile from bgp_doc_gms_file t ")
		.append(" where t.parent_file_id='").append(fileId).append("' and t.bsflag ='0' and t.org_subjection_id ='C105'");
		if(file_abbr !=null && !file_abbr.trim().equals("")){
			sb.append(" and t.file_abbr like '%"+file_abbr+"%' ");
		}
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			map.put("checked", false);
			List tList = getFileTreeChild(id,"");
			if (tList != null && tList.size() > 0) {
				JSONArray jsonarray = JSONArray.fromObject(tList);
				map.put("children", jsonarray);
				map.put("leaf", false);
				map.put("expanded", false);
			} else {
				map.put("children", null);
				map.put("leaf", true);
				map.put("expanded", false);
				continue;
			}
			jsList.add(map);
		}
		return list;
	}
	/**
	 *文档树 --> 小队
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	String org_subjection_id = "";
	public ISrvMsg getFileTeam(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		this.org_subjection_id = user.getSubOrgIDofAffordOrg();
		StringBuffer sb  = new StringBuffer();
		sb.append("select t.org_id ,t.org_name ,t.org_abbreviation ,s.org_subjection_id ")
		.append(" from comm_org_information t")
		.append(" left join comm_org_subjection s on t.org_id = s.org_id and s.bsflag='0'")
		.append(" where t.bsflag='0' and s.org_subjection_id = '").append(this.org_subjection_id).append("'");
		Map org = pureJdbcDao.queryRecordBySQL(sb.toString());
		String org_abbreviation = "";
		if(org!=null){
			org_abbreviation = (String)org.get("org_abbreviation");
		}
		String module_id = (String)reqDTO.getValue("module_id");
		List jsList = new ArrayList();
		Map root = new HashMap();
		root.put("id", this.org_subjection_id);
		root.put("name", org_abbreviation);
		root.put("isFile", "0");
		List tList = getTeamFirstChild(module_id);
		if (tList != null && tList.size() > 0) {
			JSONArray jsonarray = JSONArray.fromObject(tList);
			root.put("children", jsonarray);
			root.put("leaf", false);
			root.put("expanded", true);
		}else {
			root.put("children", null);
			root.put("leaf", true);
			root.put("expanded", true);
		}
		jsList.add(root);
		JSONArray json = null;
		json = JSONArray.fromObject(jsList);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json",json.toString());
		
		return msg;
	}
	public List getTeamFirstChild(String module_id) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select f.file_id id ,f.file_name name ,f.is_file isFile from bgp_doc_folder_module t")
		.append(" left join bgp_doc_gms_file f on t.folder_id = f.file_id and f.bsflag='0'")
		.append(" where t.bsflag='0' and t.project_info_no is null and  t.module_id ='").append(module_id).append("'");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			map.put("checked", false);
			List tList = getTeamChild(id);
			if (tList != null && tList.size() > 0) {
				JSONArray jsonarray = JSONArray.fromObject(tList);
				map.put("children", jsonarray);
				map.put("leaf", false);
				map.put("expanded", false);
			} else {
				map.put("children", null);
				map.put("leaf", true);
				map.put("expanded", false);
				continue;
			}
			jsList.add(map);
		}
		return list;
	}
	public List getTeamChild(String fileId) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select  t.file_id id, t.file_name name ,t.is_file isFile from bgp_doc_gms_file t ")
		.append(" where t.parent_file_id='").append(fileId).append("'")
		.append(" and t.bsflag ='0' and t.is_file='0'");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			String id = (String)map.get("id");
			String name = (String)map.get("name");
			map.put("checked", false);
			List tList = getTeamChild(id);
			if (tList != null && tList.size() > 0) {
				JSONArray jsonarray = JSONArray.fromObject(tList);
				map.put("children", jsonarray);
				map.put("leaf", false);
				map.put("expanded", false);
			} else {
				List files = getFiles(id);
				if (files != null && files.size() > 0) {
					JSONArray jsonarray = JSONArray.fromObject(files);
					map.put("children", jsonarray);
					map.put("leaf", false);
					map.put("expanded", false);
				}else{
					map.put("children", null);
					map.put("leaf", true);
					map.put("expanded", false);
					continue;
				}
			}
			jsList.add(map);
		}
		return list;
	}
	public List getFiles(String fileId) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select  d.file_id id, d.file_name name ,d.is_file isFile ")
		.append(" from ( select t.file_id , f.file_name ,f.parent_file_id ,f.is_file")
		.append(" from bgp_qua_files t")
		.append(" left join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag='0'")
		.append(" where t.bsflag ='0' and t.org_subjection_id ='").append(org_subjection_id)
		.append("' and t.project_info_no is null) d")
		.append(" where d.parent_file_id='").append(fileId).append("'");
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			map.put("checked", false);
			map.put("children", null);
			map.put("leaf", true);
			map.put("expanded", false);
			jsList.add(map);
		}
		return jsList;
	}
	/**
	 * 项目树
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getProjectTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String org_subjection_id = user.getSubOrgIDofAffordOrg();
		if(org_subjection_id == null){
			org_subjection_id = "null";
		}
		String project_info_no = reqDTO.getValue("projectInfoNo");
		
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select distinct t.project_info_no project_id, t.project_name , s.coding_code_id manage_id,s.coding_name manage_name ,")
		.append(" d.org_id , o.code_afford_org_id aff_id from gp_task_project t")
		.append(" join gp_task_project_dynamic d on t.project_info_no = d.project_info_no ")
		.append(" and d.bsflag ='0' and t.exploration_method = d.exploration_method ")
		.append(" join comm_org_subjection o on d.org_id = o.org_id and o.bsflag ='0'")
		.append(" join comm_coding_sort_detail s on t.manage_org = s.coding_code_id and s.bsflag = '0' ")
		.append(" where t.bsflag ='0'")
		.append(" and d.org_subjection_id like '").append(org_subjection_id).append("%'");
		if(project_info_no != null && !project_info_no.trim().equals("")){
			sb.append(" and t.project_info_no = '").append(project_info_no).append("'");
		}
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			map.put("children", null);
			map.put("leaf", true);
			map.put("expanded", false);
			jsList.add(map);
		}
		JSONArray json = null;
		json = JSONArray.fromObject(jsList);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json",json.toString());
		
		return msg;
	}
	/**
	 * 单炮评价--> 列表
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg toSingleShot(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sortId = reqDTO.getValue("sortId");
		String sortName = reqDTO.getValue("sortName");
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		List codeList = new ArrayList();
		StringBuffer sql = new StringBuffer();
		sql.append("select d.coding_code_id code_id, d.coding_code_id id, d.coding_name name,d.note spare1 ,")
		.append(" decode(d.locked_if ,'1' ,'不可修改' ,'') locked_if ,decode(d.locked_if ,'1' ,'disabled=disabled' ,'') locked")
		.append(" from comm_coding_sort_detail d where d.bsflag='0' and d.coding_mnemonic_id='"+project_type+"'")
		.append(" and d.coding_sort_id='").append(sortId).append("'");
		if(sortName!=null && !sortName.trim().equals("")){
			sql.append(" and d.coding_name like '%").append(sortName).append("%'");
		}
		sql.append(" order by d.coding_code_id asc");
		System.out.println(sql.toString());
		page = jdbcDao.queryRecordsBySQL(sql.toString(), page);
		codeList = page.getData();
		msg.setValue("datas", codeList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 单炮评价--> 保存
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg saveSingleShot(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		System.out.println(reqDTO.toMap());
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String sortId = reqDTO.getValue("sortId");
		String id = reqDTO.getValue("id");
		String name = reqDTO.getValue("name");
		if(name==null){
			name = "";
		}
		String spare1 = reqDTO.getValue("spare1");
		String status = reqDTO.getValue("status");
		Map map = new HashMap();
		map.put("modify_level", "02");
		map.put("coding_sort_id", sortId);
		map.put("coding_code", "02");
		map.put("coding_name", name);
		map.put("coding_mnemonic_id", project_type);
		map.put("superior_code_id", "1");
		map.put("cite_if", "1");
		map.put("end_if", "1");
		map.put("edition_nameplate", "1");
		if(spare1!=null){
			map.put("note", spare1);
		}
		map.put("code_afford_org_id", user.getSubOrgIDofAffordOrg());
		map.put("bsflag", "0");
		map.put("modifi_date", new Date());
		System.out.println(map);
		if(status!=null && status.trim().equals("modify")){
			map.put("coding_code_id", id);
		}else{
			map.put("locked_if", "0");
			map.put("creator_id", user.getUserName());
			map.put("creator", user.getUserName());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"COMM_CODING_SORT_DETAIL");
		if(status!=null && status.trim().equals("add")){
			StringBuffer sb  = new StringBuffer();
			sb.append("update comm_coding_sort_detail t set t.coding_code_id='")
			.append(id).append("' where t.coding_code_id='").append(uId).append("' and t.coding_mnemonic_id='"+project_type+"'");
			jdbcDao.executeUpdate(sb.toString());
		}
		return msg;
	}
	/**
	 * 单炮评价 --> 删除
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteSingleCode(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String code_id = reqDTO.getValue("code_id");
		String project_type = reqDTO.getValue("project_type");
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("delete comm_coding_sort_detail t ")
		.append(" where t.coding_code_id='").append(code_id).append("' and t.coding_mnemonic_id ='"+project_type+"'");
		System.out.println(sb.toString());
		jdbcDao.executeUpdate(sb.toString());
		return msg;
	}
	/**
	 * 不合格项记录 --> 列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getQualityItems(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		if(projectInfoNo==null){
			projectInfoNo = "";
		}
		String taskId = reqDTO.getValue("taskId");
		String taskName = reqDTO.getValue("taskName");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.org_id,org.org_abbreviation org_name, t.project_info_no, ")
		.append(" s.coding_sort_name quality_type, d.coding_name record_type, t.record_id,")
		.append(" decode(t.status,  '1', '整改中', '2', '合格', '3', '整改合格',")
		.append(" '4', '不合格') status, p.project_name ,t.task_id , t.unit_id ,t.task_name")
		.append(" from bgp_qua_item_records t")
		.append(" left join comm_coding_sort s on t.quality_type = s.coding_sort_id")
		.append(" left join comm_coding_sort_detail d on t.record_type = d.coding_code_id")
		.append(" left join comm_org_information org on t.org_id = org.org_id")
		.append(" left join gp_task_project p on t.project_info_no = p.project_info_no")
		.append(" where t.bsflag = '0'");
		sb.append(" and t.project_info_no = '").append(projectInfoNo).append("'");
		if(taskId==null){
			taskId ="";
		}
		sb.append(" and t.task_id = '").append(taskId).append("'");
		sb.append(" order by t.modifi_date desc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 得到不合格项列表详细信息
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getQualityItemsDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String recordId = reqDTO.getValue("recordId");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.record_id,t.org_id, org.org_abbreviation org_name, t.project_info_no, t.describe, ")
		.append(" t.quality_type ,t.record_type, t.unit_id, t.notes ,t.status , p.project_name ,")
		.append(" t.checker,u.user_name checker_name ,t.check_date,t.complete_date,t.task_id ,t.task_name")
		.append(" from bgp_qua_item_records t")
		.append("  left join comm_org_information org on t.org_id = org.org_id and org.bsflag='0'")
		.append(" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0'")
		.append(" left join p_auth_user u  on t.checker = u.user_id and u.bsflag='0'")
		.append(" where t.bsflag = '0'");
		
		sb.append(" and t.record_id = '").append(recordId).append("'");
		sb.append(" order by t.modifi_date");
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("qualityItemDetail", map);
		return msg;
	}
	/**
	 * （工序）
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getQualityType(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String type = reqDTO.getValue("qualityType");
		if(type ==null || type.trim().equals("")){
			type = "";
		}
		StringBuffer sql = new StringBuffer();
		sql.append("select t.coding_sort_id value, t.coding_sort_name label from comm_coding_sort t ")
		.append(" where t.bsflag='0' and t.spare2 ='质量检查项' ")
		.append(" and t.coding_sort_name like '%").append(type).append("%'")
		.append(" order by t.coding_sort_id");
		System.out.println(sql.toString());
		List qualityType = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		msg.setValue("qualityType", qualityType);
		
		return msg;
	}
	/**
	 * 工序名称 -->检查项类型
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRecordType(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String qualityType = reqDTO.getValue("qualityType");
		msg.setValue("qualityType", qualityType);
		StringBuffer sb = new StringBuffer();
		sb.append("select t.coding_code_id ,t.coding_name from comm_coding_sort_detail t")
		.append(" where t.bsflag = '0' ");
		if(qualityType!=null){
			sb.append("  and t.coding_sort_id ='").append(qualityType).append("'");
		}
		sb.append("  order by t.coding_code_id desc");
		List recordType = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		msg.setValue("recordType", recordType);
		StringBuffer select = new StringBuffer();
		for(int i =0;recordType!=null&&i<recordType.size();i++){
			Map map = (Map)recordType.get(i);
			String value = (String)map.get("codingCodeId");
			if(value!=null){
				String text = (String)map.get("codingName");
				select.append("<option value='").append(value).append("'>")
				.append(text).append("</option>");
			}
		}
		msg.setValue("option", select.toString());
		
		return msg;
	}
	/**
	 * 不合格项纪录 --> 列表/修改页面 --> 修改
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg editQualityItems(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String record_id = reqDTO.getValue("record_id");
		Map map = reqDTO.toMap();
		String infoKeyValue = "";
		map.put("bsflag", "0");
		map.put("project_info_no", project_info_no);
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		if (record_id == null || record_id.trim().equals("")) {// 新增操作
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_QUA_ITEM_RECORDS");
		return msg;
	}
	/**
	 * 质量检查 --> 删除
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteRecord(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String record_id = reqDTO.getValue("record_id");
		if(record_id!=null && !record_id.equals("")){
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_item_records t set t.bsflag ='1'")
			.append(" where t.record_id ='").append(record_id).append("'");
			jdbcDao.executeUpdate(sb.toString());
		}
		return msg;
	}
	/**
	 * 检查项汇总 --> 汇总列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRecordNameList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String objectName = reqDTO.getValue("objectName");
		String task_id = reqDTO.getValue("task_id");
		if(task_id == null || task_id.equals("")){
			task_id = "null";
		}
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		StringBuffer sb = new StringBuffer();
		sb.append("select d.coding_name record_name from comm_coding_sort t ")
		.append(" left join comm_coding_sort_detail d on t.coding_sort_id = d.coding_sort_id ")
		.append(" where t.bsflag = '0' and d.bsflag ='0' and t.spare2 ='质量检查项'")
		.append("  and  t.coding_sort_name like '%").append(objectName).append("%'")
		.append("  order by d.coding_code_id asc");
		List  list= BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		int index = task_id.indexOf(",");
		sb = new StringBuffer();
		if(index == -1){
			sb.append("select t.summary_id , t.record_name , t.record_num , t.unit_id ,t.notes ,")
			.append(" t.checker ,p1.user_name checker_name , t.check_date ,  t.summary_date ,")
			.append(" t.spare1 ,t.summarier ,p2.user_name summarier_name")
			.append(" from bgp_qua_record_summary t  ")
			.append(" left join p_auth_user p1 on t.checker = p1.user_id and p1.bsflag ='0'")
			.append("  left join p_auth_user p2 on t.summarier = p2.user_id and p2.bsflag ='0'")
			.append(" where t.bsflag = '0' and  t.object_name like '%").append(objectName).append("%'")
			.append(" and  t.task_id ='").append(task_id).append("'")
			.append(" and t.project_info_no ='").append(project_info_no).append("' order by t.record_num desc");
		}else{
			sb.append("select q.record_name ,q.record_num , decode(q.unit_id,',','',' ,','',q.unit_id) unit_id from (")
			.append(" select r.* ,(select  replace(substr(max(sys_connect_by_path(e.unit_id,';')),2),';',',')")
			.append(" from( select d.record_name ,d.record_num ,d.unit_id ,d.rn ,")
			.append(" lead(rn) over(partition by d.record_name order by d.rn) rn1")
			.append(" from(select  t.record_name ,t.record_num ,t.unit_id ,")
			.append(" row_number() over(order by t.record_name ,t.unit_id  desc) rn")
			.append(" from bgp_qua_record_summary t  where t.bsflag = '0' and  t.object_name like '%")
			.append(objectName).append("%' and  t.task_id in ('").append(task_id).append("')")
			.append(" and t.project_info_no ='").append(project_info_no).append("' ) d ) e")
			.append(" start with e.record_name = r.record_name and e.rn1 is null connect by e.rn1 = prior e.rn) unit_id ")
			.append(" from (select distinct  s.record_name , sum(s.record_num) record_num")
			.append(" from bgp_qua_record_summary s ")
			.append(" left join p_auth_user p1 on s.checker = p1.user_id and p1.bsflag ='0' ")
			.append(" left join p_auth_user p2 on s.summarier = p2.user_id and p2.bsflag ='0'")
			.append(" where s.bsflag = '0' and  s.object_name like '%").append(objectName).append("%'")
			.append(" and  s.task_id in ('").append(task_id).append("')")
			.append("  and s.project_info_no ='").append(project_info_no).append("' ")
			.append(" group by s.record_name order by s.record_name desc) r ) q order by q.record_num desc");
		}
		List recordNameList = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		if(recordNameList==null || recordNameList.size() <= 0){
			sb = new StringBuffer();
			sb.append(" select q.* ,(select substr(max(sys_connect_by_path(t.unit_id,',')),2) unit_id from ( ")
			.append(" select i.record_type ,i.unit_id ,i.rn ,lead(rn) over(partition by i.record_type order by i.rn asc) rn1 ")
			.append(" from (select r.record_type ,r.unit_id ,row_number() over(order by r.record_type ,r.unit_id desc) rn  ")
			.append(" from bgp_qua_item_records r where r.bsflag='0' and r.task_id in('").append(task_id).append("')")
			.append(" and r.project_info_no ='").append(project_info_no).append("') i ) t")
			.append(" start with t.record_type = q.record_type and t.rn1 is null connect by t.rn1 =  prior t.rn ) unit_id ")
			.append(" from ( select d.record_type ,s.coding_name record_name,count(d.record_type) record_num ")
		    .append(" from bgp_qua_item_records d ")
			.append(" left join comm_coding_sort_detail s on d.record_type = s.coding_code_id and s.bsflag='0'")
			.append(" where d.bsflag='0' and d.task_id in('").append(task_id).append("')  and d.project_info_no ='")
			.append(project_info_no).append("' group by d.record_type ,s.coding_name)q order by q.record_num desc");
			recordNameList = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
			for(int j = list.size()-1; j >= 0;j--){
				Map temp = (Map)list.get(j);
				String name = (String)temp.get("recordName");
				int i = 0;
				for(i =0;i<recordNameList.size() ;i++){
					Map map = (Map)recordNameList.get(i);
					String record_name = "";
					record_name = (String)map.get("recordName");
					if(record_name!=null && name!=null && record_name.equals(name) && !name.equals("")){
						list.remove(j);
						break;
					}
				}
				if( i == recordNameList.size()){
					temp.put("summaryId", "");
					temp.put("recordNum", "0");
					temp.put("unitId", "");
					temp.put("notes", "");
					temp.put("checker", "");
					temp.put("checkDate", "");
					temp.put("summarier", "");
					temp.put("summaryDate", "");
					recordNameList.add(temp);
				}
			}
		}
		msg.setValue("recordNameList", recordNameList);
		sb = new StringBuffer();
		sb.append(" select t.project_info_no,sum(distinct t.spare1) quality_num")
		.append(" from bgp_qua_record_summary t  ")
		.append(" where t.project_info_no ='").append(project_info_no).append("'")
		.append(" and t.bsflag='0' and t.task_id in('").append(task_id).append("')")
		.append(" and t.object_name like '").append(objectName).append("%'")
		.append(" group by t.project_info_no ");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		String quality_num = "0";
		if(map!=null ){
			if(map.get("quality_num")!=null && !map.get("quality_num").equals("")){
				quality_num = (String)map.get("quality_num");
			}
		}
		msg.setValue("quality_num", quality_num);
		return msg;
	}
	/**
	 * 检查项汇总 -->检查项列表--> 保存
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg saveCheckTable(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		Map map = reqDTO.toMap();
		System.out.println(map);
		String summary_id = (String)map.get("summary_id");
		String name = (String)map.get("record_name");
		if (summary_id == null || summary_id.trim().equals("")) {// 新增操作
			map.put("project_info_no", project_info_no);
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			map.put("bsflag", "0");
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_record_summary");
		} else {// 修改或审核操作
			SimpleDateFormat  df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date = df.format(new Date());
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_record_summary t set t.record_name='").append(name).append("'")
			.append(" , t.updator_id='").append(user.getUserId()).append("'")
			.append(" , t.modifi_date  = to_date('").append(date).append("','yyyy/MM/dd HH24:mi:ss')")
			.append(" where t.summary_id ='").append(summary_id).append("'");
			System.out.println(sb.toString());
			jdbcDao.executeUpdate(sb.toString());
		}	
		return msg;
	}
	/**
	 * 检查项汇总--> 不合格项目列表 --> 删除
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteCheckTable(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String summary_id = reqDTO.getValue("summary_id");
		StringBuffer sb = new StringBuffer();
		sb.append("update  bgp_qua_record_summary t set t.bsflag ='1' ")
		.append(" where t.summary_id='").append(summary_id).append("'");
		System.out.println(sb.toString());
		jdbcDao.executeUpdate(sb.toString());
		return msg;
	}
	/**
	 * 检查项汇总 -->汇总信息保存
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg saveSummary(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		Map map = reqDTO.toMap();
		System.out.println(map);
		String summaryId = (String)map.get("summary_id");
		String infoKeyValue = "";
		if (summaryId == null || summaryId.trim().equals("")) {// 新增操作
			map.put("project_info_no", project_info_no);
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			map.put("bsflag", "0");
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_record_summary");
		} else {// 修改或审核操作
			map.put("bsflag", "0");
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_record_summary");
		}
		return msg;
	}
	/**
	 * 单炮评价汇总  --> 汇总列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getShotList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String objectName = reqDTO.getValue("objectName");
		String task_id = reqDTO.getValue("task_id");
		if(task_id == null || task_id.equals("")){
			task_id = "null";
		}
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		StringBuffer sb = new StringBuffer();
		sb.append("select d.coding_name record_name from comm_coding_sort t ")
		.append(" left join comm_coding_sort_detail d on t.coding_sort_id = d.coding_sort_id ")
		.append(" where t.bsflag = '0' and d.bsflag ='0' and t.coding_sort_id ='5000100100'")
		.append("  order by d.coding_code_id asc");
		List  list= BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		int index = task_id.indexOf(",");
		sb = new StringBuffer();
		if(index == -1){
			sb.append("select t.summary_id , t.record_name , t.record_num , t.unit_id ,t.notes ,")
			.append(" t.checker ,p1.user_name checker_name , t.check_date ,  t.summary_date ,")
			.append(" t.spare1 ,t.spare2 ,t.spare3 ,t.spare4 ,t.summarier ,p2.user_name summarier_name")
			.append(" from bgp_qua_record_summary t  ")
			.append(" left join p_auth_user p1 on t.checker = p1.user_id and p1.bsflag ='0'")
			.append("  left join p_auth_user p2 on t.summarier = p2.user_id and p2.bsflag ='0'")
			.append(" where t.bsflag = '0' and  t.object_name like '%").append(objectName).append("%'")
			.append(" and  t.task_id ='").append(task_id).append("'")
			.append(" and t.project_info_no ='").append(project_info_no).append("' order by t.record_num desc");
		}else{
			sb.append("select q.record_name ,q.record_num , decode(q.unit_id,',','',' ,','',q.unit_id) unit_id from (")
			.append(" select r.* ,(select  replace(substr(max(sys_connect_by_path(e.unit_id,';')),2),';',',')")
			.append(" from( select d.record_name ,d.record_num ,d.unit_id ,d.rn ,")
			.append(" lead(rn) over(partition by d.record_name order by d.rn) rn1")
			.append(" from(select  t.record_name ,t.record_num ,t.unit_id ,")
			.append(" row_number() over(order by t.record_name ,t.unit_id  desc) rn")
			.append(" from bgp_qua_record_summary t  where t.bsflag = '0' and  t.object_name like '%")
			.append(objectName).append("%' and  t.task_id in ('").append(task_id).append("')")
			.append(" and t.project_info_no ='").append(project_info_no).append("' ) d ) e")
			.append(" start with e.record_name = r.record_name and e.rn1 is null connect by e.rn1 = prior e.rn) unit_id ")
			.append(" from (select distinct  s.record_name , sum(s.record_num) record_num")
			.append(" from bgp_qua_record_summary s ")
			.append(" left join p_auth_user p1 on s.checker = p1.user_id and p1.bsflag ='0' ")
			.append(" left join p_auth_user p2 on s.summarier = p2.user_id and p2.bsflag ='0'")
			.append(" where s.bsflag = '0' and  s.object_name like '%").append(objectName).append("%'")
			.append(" and  s.task_id in ('").append(task_id).append("')")
			.append("  and s.project_info_no ='").append(project_info_no).append("' ")
			.append(" group by s.record_name order by s.record_name desc) r ) q order by q.record_num desc");
		}
		List shotList = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		if(shotList == null || shotList.size() <= 0){
			for(int j = list.size()-1; j >= 0;j--){
				Map temp = (Map)list.get(j);
				temp.put("summaryId", "");
				temp.put("recordNum", "0");
				temp.put("unitId", "");
				temp.put("notes", "");
				temp.put("spare1", "0");
				temp.put("spare2", "0");
				temp.put("spare3", "0");
				temp.put("spare4", "0");
				temp.put("checker", "");
				temp.put("checkDate", "");
				temp.put("summarier", "");
				temp.put("summaryDate", "");
				shotList.add(temp);
			}
		}
		msg.setValue("shotList", shotList);
		sb = new StringBuffer();
		sb.append(" select t.project_info_no ,sum(distinct t.spare1) spare1 ,")
		.append(" sum(distinct t.spare2) spare2 ,sum(distinct t.spare3) spare3 ,")
		.append(" sum(distinct t.spare4) spare4")
		.append(" from bgp_qua_record_summary t  ")
		.append(" where t.project_info_no ='").append(project_info_no).append("'")
		.append(" and t.bsflag='0' and t.task_id in('").append(task_id).append("')")
		.append(" and t.object_name like '").append(objectName).append("%'")
		.append(" group by t.project_info_no ");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("shotMap", map);
		return msg;
	}
	/**
	 * 单炮评价汇总 -->汇总信息保存
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg saveShot(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		Map map = reqDTO.toMap();
		String summary_id = (String)map.get("summary_id");
		String infoKeyValue = "";
		if (summary_id == null || summary_id.trim().equals("")) {// 新增操作
			map.put("project_info_no", project_info_no);
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			map.put("bsflag", "0");
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_record_summary");
		} else {// 修改或审核操作
			map.put("bsflag", "0");
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			map.put("updator_id", user.getUserId());
			map.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_record_summary");
		}
		return msg;
	}
	/**
	 * 质量文档-->列表管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg toQuaFiles(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String file_type = reqDTO.getValue("file_type");
		String name = reqDTO.getValue("name");
		
		StringBuffer sb = new StringBuffer();
		sb.append("select t.file_id , t.file_name , t.creator_id , u.user_name, t.create_date ")
		.append(" from bgp_doc_gms_file t ")
		.append(" left join p_auth_user u on t.creator_id = u.user_id")
		.append(" where t.bsflag = '0' and u.bsflag = '0'");
		if(file_type==null){
			file_type = "GB";
		}
		sb.append(" and t.file_name like '").append(file_type).append("%'");
		if(name==null){
			name = "";
		}
		sb.append(" and t.file_name like '%").append(name).append("%'");
		sb.append(" order by t.modifi_date desc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List filesList = page.getData();
		msg.setValue("datas", filesList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}
	/**
	 * 质量文档--> 获得项目的质量文档列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getQuaFiles(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no =  reqDTO.getValue("project_info_no");
		String file_type = reqDTO.getValue("file_type");
		String name = reqDTO.getValue("name");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.qua_file_id ,t.file_id , f.file_name , f.creator_id , u.user_name, f.create_date ,")
		.append(" concat(concat(t.file_id,':'),f.ucm_id) ids from bgp_qua_files t ")
		.append(" left join bgp_doc_gms_file f on t.file_id = f.file_id ")
		.append(" left join p_auth_user u on f.creator_id = u.user_id")
		.append(" where t.bsflag = '0' and u.bsflag = '0' and f.bsflag='0' ");
		if(project_info_no !=null && !project_info_no.equals("")){
			sb.append(" and t.project_info_no = '").append(project_info_no).append("'");
		}else{
			sb.append(" and t.project_info_no is null and t.org_subjection_id = '").append(user.getSubOrgIDofAffordOrg()).append("'");
		}
		if(file_type==null){
			file_type = "%";
		}
		sb.append(" and f.file_name like '").append(file_type).append("%'");
		if(name==null){
			name = "";
		}
		sb.append(" and f.file_name like '%").append(name).append("%'");
		sb.append(" order by f.modifi_date desc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List filesList = page.getData();
		msg.setValue("datas", filesList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 质量文档 --> 保存管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveQuaFiles(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String file_id = reqDTO.getValue("file_id");
		String project_info_no = user.getProjectInfoNo();
		String infoKeyValue = "";
		Map map = new HashMap();
		map.put("bsflag", "0");
		map.put("file_id", file_id);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		map.put("creator_id", user.getUserId());
		map.put("create_date", new Date());
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		System.out.println(map);
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_files");
		infoKeyValue = id.toString();
		return msg;
	}
	/**
	 * 质量文档 --> 是否存在
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkIfExisTeam(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String file_id = reqDTO.getValue("file_id");
		if(file_id==null){
			file_id = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append(" select t.file_id from bgp_qua_files t ")
		.append(" where t.bsflag='0' and t.file_id ='").append(file_id).append("'")
		.append(" and t.project_info_no='").append(project_info_no).append("'");
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("checkIfExist", map);
		return msg;
	}
	/**
	 * 质量文档 --> 保存管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveQuaFilesTeam(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String file_id = reqDTO.getValue("file_id");
		String project_info_no = user.getProjectInfoNo();
		String infoKeyValue = "";
		Map map = new HashMap();
		map.put("bsflag", "0");
		map.put("file_id", file_id);
		map.put("org_id", user.getOrgId());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		map.put("project_info_no", project_info_no);
		map.put("creator_id", user.getUserId());
		map.put("create_date", new Date());
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		System.out.println(map);
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_files");
		infoKeyValue = id.toString();
		return msg;
	}
	/**
	 * 质量文档 --> 删除管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteQuaFiles(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String qua_file_id = reqDTO.getValue("qua_file_id");
		if (qua_file_id != null && !qua_file_id.trim().equals("")) {
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_files t set t.bsflag='1' ")
			.append(" where t.qua_file_id='").append(qua_file_id).append("'");
			System.out.println(sb.toString());
			jdbcDao.executeUpdate(sb.toString());
		}		
		return msg;
	}
	/**
	 * 工序检查计划 --> 得到责任人
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDutyPerson(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String project_type = user.getProjectType();
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		String object_id = reqDTO.getValue("object_id");
		if(object_id == null){
			object_id = "";
		}
		String name = reqDTO.getValue("name");
		if(name == null){
			name = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append(" select t.qua_plan_id , t.duty_person ,t.notes,t.check_person ")
		.append(" from bgp_qua_plan t ")
		.append(" where t.bsflag = '0' and t.object_id ='").append(object_id).append("'")
		.append(" and t.project_info_no='").append(project_info_no).append("'");
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("dutyPerson", map);
		
		List list = new ArrayList();
		sb = new StringBuffer();
		sb.append(" select s.detail_name coding_name from bgp_qua_coding_sort s where s.bsflag ='0' and s.sort_id like '50001001%' ")
		.append(" and s.project_info_no='"+project_info_no+"' and s.sort_name like '%").append(name).append("%'");
		list = jdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			sb = new StringBuffer();
			sb.append(" select d.coding_name from comm_coding_sort s join comm_coding_sort_detail d on s.coding_sort_id = d.coding_sort_id and d.bsflag ='0'")
			.append(" where s.bsflag ='0' and s.coding_sort_id like '50001001%' and s.spare2='"+project_type+"' and s.coding_sort_name like '%").append(name).append("%'");
			list = jdbcDao.queryRecords(sb.toString());
		}
		msg.setValue("setting", list);
		return msg;
	}
	/**
	 * 工序检查计划--> 保存
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg savePlan(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String project_type = user.getProjectType();//如果是综合物化探的业务需要保持setting字段的值，
		if(project_type!=null && project_type.trim().equals("5000100004000000002")){
			project_type = "5000100004000000010";
		}
		Map map = reqDTO.toMap();
		map.put("project_info_no", project_info_no);
		map.put("bsflag", "0");
		map.put("creator_id", user.getUserName());
		map.put("updator_id", user.getUserName());
		map.put("create_date", new Date());
		map.put("modifi_date", new Date());
		map.put("org_id", user.getEmpId());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(project_type!=null && project_type.trim().equals("5000100004000000009")){
			String name = map.get("object_name")==null ?"":(String)map.get("object_name");
			if(name!=null && !name.trim().equals("")){
				StringBuffer sb = new StringBuffer("delete bgp_qua_coding_sort t where t.project_info_no ='"+project_info_no+"' and t.sort_name like '%"+name+"%'");
				jdbcTemplate.execute(sb.toString());
				String setting = map.get("setting")==null ?"":(String)map.get("setting");
				String []detail_names = setting.split(";");
				int i = 1;
				sb = new StringBuffer();
				for(String detail_name:detail_names){
					detail_name = detail_name.trim();
					sb.append(" insert into bgp_qua_coding_sort(coding_sort_id,project_info_no,sort_id,sort_name,detail_name,order_id,creator,updator) ")
					.append(" values(lower(sys_guid()),'"+project_info_no+"',(select t.coding_sort_id from comm_coding_sort t where t.coding_sort_id like '50001001%' ")
					.append(" and t.coding_sort_name like '"+name+"%' and t.spare2 ='"+project_type+"' and rownum =1),'"+name+"','"+detail_name+"','"+(i++)+"','"+user.getUserName()+"','"+user.getUserName()+"'); ");
				}
				log.info(sb.toString());
				saveQualityBySql(sb.toString());
			}
		}
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_QUA_PLAN");
		return msg;
	}
	/**
	 * 质量事故上报 --> 列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getAccidentList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String org_subjection_id = reqDTO.getValue("org_subjection_id");
		if(org_subjection_id==null || org_subjection_id.trim().equals("")){
			org_subjection_id = user.getSubOrgIDofAffordOrg();
		}
		String projectInfoNo = reqDTO.getValue("project_info_no");
		String report_date = reqDTO.getValue("report_date");

		StringBuffer sb = new StringBuffer();
		sb.append("select t.accident_id , t.project_info_no ,p.project_name , ")
		.append(" t.org_id ,t.report_id , e.employee_name , t.report_date ,")
		.append(" (t.small_num-(-t.large_num)-(-t.great_num)-(-t.super_num)) accident_num")
		.append(" from bgp_qua_accident t ")
		.append(" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'")
		.append(" left join comm_human_employee e on t.report_id = e.employee_id and e.bsflag ='0'")
		.append(" where t.bsflag = '0'").append(" and t.org_subjection_id like'").append(org_subjection_id);
		if(org_subjection_id!=null && org_subjection_id.equals("C105")){
			sb.append("%'");
		}else{
			sb.append("%'");
		}
		if(report_date !=null && !report_date.trim().equals("")){
			sb.append(" and to_char(t.report_date,'yyyy-MM-dd') like'").append(report_date).append("%'");
		}
		if(projectInfoNo!=null && !projectInfoNo.equals("")){
			sb.append(" and t.project_info_no = '").append(projectInfoNo).append("'");
		}
		sb.append(" order by t.modifi_date desc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 质量事故上报 --> 填报日期是否存在
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkAccidentExist(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String report_date = reqDTO.getValue("report_date");
		String project_info_no = reqDTO.getValue("project_info_no");
		String org_id = reqDTO.getValue("org_id");
		String accident_id = reqDTO.getValue("accident_id");
		StringBuffer sb = new StringBuffer();
		sb.append(" select t.accident_id from bgp_qua_accident t ")
		.append(" where t.bsflag = '0' and t.report_date =to_date('").append(report_date).append("','yyyy-MM-dd')")
		.append(" and t.project_info_no='").append(project_info_no).append("'")
		.append(" and t.org_id='").append(org_id).append("'")
		.append(" and t.accident_id!='").append(accident_id).append("'");
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("existMap", map);
		return msg;
	}
	/**
	 * 质量事故上报-->保存
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAccident(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		String accident_id = reqDTO.getValue("accident_id");
		Map map = reqDTO.toMap();
		map.put("accident_title", "质量事故汇总表");
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(accident_id!=null && !accident_id.trim().equals("")){
			map.put("accident_id", accident_id);
		}else{
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_accident");
		
		return msg;
	}
	/**
	 * 质量事故上报-->详细
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAccidentDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String accident_id = reqDTO.getValue("accident_id");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.accident_id , t.org_id ,t.report_date , t.leader_id ,t.super_id , t.office_num , t.depart_id ,")
		.append(" t.charge_id , t.office_tel ,t.small_num ,t.small_loss ,p.project_name, ")
		.append(" t.large_num ,t.large_loss ,t.great_num ,t.great_loss ,t.super_num ,t.super_loss, ")
		.append(" t.nation , t.province ,t.corporation ,t.spare1 ,t.change_date ,t.change_id ,")
		.append(" t.change_note from bgp_qua_accident t")
		.append(" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag = '0'")
		.append(" where t.bsflag = '0'")
		.append(" and t.accident_id = '").append(accident_id).append("'");
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("accidentDetail", map);
		return msg;
	}
	/**
	 * 质量事故上报 --> 删除管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteAccident(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String accident_id = reqDTO.getValue("accident_id");
		if (accident_id != null && !accident_id.trim().equals("")) {
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_accident t set t.bsflag='1' ")
			.append(" where t.accident_id='").append(accident_id).append("'");
			System.out.println(sb.toString());
			jdbcDao.executeUpdate(sb.toString());
		}		
		return msg;
	}
	/**
	 * 质量事故报告单 --> 列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getAccidentReport(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String accident_id = reqDTO.getValue("accident_id");
		if(accident_id==null){
			accident_id = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select t.report_id ,t.accident_id ,o.org_abbreviation report_org ,")
		.append(" i.org_abbreviation accident_org ,t.accident_date ,t.accident_loss ,")
		.append(" t.describe ,t.situation ,t.reporter_id ,t.reporter_tel ")
		.append(" from bgp_qua_accident_report t ")
		.append(" left join bgp_qua_accident a on t.accident_id = a.accident_id and a.bsflag ='0'")
		.append(" left join comm_org_information o on t.report_org = o.org_id and o.bsflag='0'")
		.append(" left join comm_org_information i on t.accident_org = i.org_id and i.bsflag='0'")
		.append(" where t.bsflag = '0'").append(" and t.accident_id = '").append(accident_id).append("'")
		.append(" order by t.modifi_date desc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List reportList = page.getData();
		msg.setValue("datas", reportList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 质量事故报告单-->详细
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getReportDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String report_id = reqDTO.getValue("report_id");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.report_id ,t.accident_id ,t.report_org ,o.org_abbreviation org_name,")
		.append(" t.accident_org ,i.org_abbreviation  accident_name ,t.accident_date ,t.accident_loss ,")
		.append(" t.describe ,t.situation ,t.reporter_id ,u.user_name reporter_name ,t.reporter_tel ")
		.append(" from bgp_qua_accident_report t ")
		.append(" left join bgp_qua_accident a on t.accident_id = a.accident_id and a.bsflag ='0'")
		.append(" left join comm_org_information o on t.report_org = o.org_id and o.bsflag='0'")
		.append(" left join comm_org_information i on t.accident_org = i.org_id and i.bsflag='0'")
		.append(" left join p_auth_user u on t.reporter_id = u.user_id and u.bsflag='0'")
		.append(" where t.bsflag = '0'").append(" and t.report_id = '").append(report_id).append("'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("reportDetail", map);
		return msg;
	}
	/**
	 * 质量事故报告单 --> 是否发生质量事故
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg accidentHappened(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String subjection = user.getSubOrgIDofAffordOrg();
		StringBuffer sb = new StringBuffer();
		sb.append("select nvl(sum(t.small_num)-(-sum(t.large_num)) -(-sum(t.great_num))-(-sum(t.super_num)),0) num ")
		.append(" from bgp_qua_accident t")
		.append(" where t.bsflag = '0' and  t.org_subjection_id like'").append(subjection).append("'");
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("existMap", map);
		return msg;
	}
	/**
	 * 质量事故报告单-->保存
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveAccidentReport(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		String report_id = reqDTO.getValue("report_id");
		String index = reqDTO.getValue("index");
		if(index==null){
			index = "0";
		}
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(report_id!=null && !report_id.trim().equals("")){
			map.put("report_id", report_id);
		}else{
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_accident_report");
		msg.setValue("index", index);
		return msg;
	}
	/**
	 * 质量事故报告单 --> 删除管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteAccidentReport(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String report_id = reqDTO.getValue("report_id");
		if (report_id != null && !report_id.trim().equals("")) {
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_accident_report t set t.bsflag='1' ")
			.append(" where t.report_id='").append(report_id).append("'");
			System.out.println(sb.toString());
			jdbcDao.executeUpdate(sb.toString());
		}		
		return msg;
	}
	/**
	 * 计量设备检测 --> 列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getEquipmentList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		if(projectInfoNo==null){
			projectInfoNo = "";
		}
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
		//String report_date = df.format(new Date());
		String history_id = reqDTO.getValue("history_id");
		String equip_name = reqDTO.getValue("equip_name");
		StringBuffer sb = new StringBuffer();
		sb.append("select t.monitor_id , t.sort_id ,t.unite_code ,t.sort_code ,t.equip_id,  ")
		.append(" t.equip_name ,t.model_code ,t.measure ,t.accurate ,t.producor ,t.ident_code , ")
		.append(" t.depart depart_name ,t.facilities ,t.status ,t.detect_depart detect_name,")
		.append(" t.detect_cycle ,t.detect_date , t.valid_date ,spare1,")
		.append(" decode(t.detect_result,'1','合格','2','不合格') detect_result , t.abc ,")
		.append(" t.notes ,t.history_id ,t.org_id ,org.org_name ")
		.append(" from bgp_qua_monitor_equipment t ")
		.append(" left join comm_org_information org on t.org_id = org.org_id and org.bsflag ='0' ")
		//.append(" left join comm_org_information org1 on t.depart = org1.org_id and org1.bsflag ='0' ")
		.append(" where t.bsflag = '0' ")
		.append(" and t.project_info_no = '").append(projectInfoNo).append("'");
		if(history_id ==null || history_id.trim().equals("")){
			sb.append(" and t.history_id is null ");
		}else{
			sb.append(" and t.history_id ='").append(history_id).append("'");
		}
		
		sb.append(" and t.equip_name like'%").append(equip_name).append("%'")
		.append(" order by t.modifi_date asc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 计量设备检测 --> 填报日期是否存在
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkEquipmentExist(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String report_date = reqDTO.getValue("report_date");
		String project_info_no = reqDTO.getValue("project_info_no");
		StringBuffer sb = new StringBuffer();
		sb.append(" select t.accident_id from bgp_qua_equipment_history t ")
		.append(" where t.bsflag = '0' and t.report_date =to_date('").append(report_date).append("','yyyy-MM-dd')")
		.append(" and t.project_info_no='").append(project_info_no).append("'");
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("existMap", map);
		return msg;
	}
	
	/**
	 * 计量设备检测-->保存
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEquipment(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		if(project_info_no == null){
			project_info_no = "";
		}
		String monitor_id = reqDTO.getValue("monitor_id");
		Map map = reqDTO.toMap();
		map.put("project_info_no", project_info_no);
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(monitor_id!=null && !monitor_id.trim().equals("")){
			map.put("monitor_id", monitor_id);
		}else{
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_monitor_equipment");
		return msg;
	}
	/**
	 * 计量设备检测-->详细
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getEquipmentDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String monitor_id = reqDTO.getValue("monitor_id");
		if(monitor_id == null){
			monitor_id = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select t.monitor_id , t.sort_id ,t.unite_code ,t.sort_code ,t.equip_id, ")
		.append(" t.equip_name ,t.model_code ,t.measure ,t.accurate ,t.producor ,t.ident_code , ")
		.append(" t.depart ,t.facilities ,t.status ,t.detect_depart ,spare1,")
		.append(" t.detect_cycle ,t.detect_date , t.valid_date ,")
		.append(" t.detect_result , t.abc , t.notes ,t.history_id ,t.org_id ,org.org_name ")
		.append(" from bgp_qua_monitor_equipment t ")
		.append(" left join comm_org_information org on t.org_id = org.org_id and org.bsflag ='0' ")
		/*.append(" left join comm_org_information org1 on t.depart = org1.org_id and org1.bsflag ='0' ")
		.append(" left join comm_org_information org2 on t.detect_depart = org2.org_id and org2.bsflag ='0' ")*/
		.append(" where t.bsflag = '0' ").append(" and t.monitor_id = '").append(monitor_id).append("'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("equipmentDetail", map);
		return msg;
	}
	/**
	 * 计量设备检测 --> 删除管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteEquipment(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String monitor_id = reqDTO.getValue("monitor_id");
		if (monitor_id != null && !monitor_id.trim().equals("")) {
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_monitor_equipment t set t.bsflag='1' ")
			.append(" where t.monitor_id='").append(monitor_id).append("'");
			System.out.println(sb.toString());
			jdbcDao.executeUpdate(sb.toString());
		}		
		return msg;
	}
	/**
	 * 计量设备检测 --> 列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getHistorytList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		if(projectInfoNo==null){
			projectInfoNo = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select  t.history_id , t.report_title ,t.report_date ,t.report_code ,")
		.append(" t.report_maker , u.user_name maker_name ,t.org_id , org.org_abbreviation org_name")
		.append(" from bgp_qua_equipment_history t ")
		.append(" left join p_auth_user u on t.report_maker = u.user_id and u.bsflag ='0' ")
		.append(" left join comm_org_information org on t.org_id = org.org_id and org.bsflag ='0' ")
		.append(" where t.bsflag = '0' ")
		.append(" and t.project_info_no = '").append(projectInfoNo).append("'")
		.append(" order by t.report_date desc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	/**
	 * 计量设备检测-->详细
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHistoryDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String history_id = reqDTO.getValue("history_id");
		if(history_id == null){
			history_id = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select  t.history_id , t.report_title ,t.report_date ,t.report_code ,")
		.append(" t.report_maker ,t.org_id , org.org_abbreviation org_name")
		.append(" from bgp_qua_equipment_history t ")
		.append(" left join comm_org_information org on t.org_id = org.org_id and org.bsflag ='0' ")
		.append(" where t.bsflag = '0' ").append(" and t.history_id = '").append(history_id).append("'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("historyDetail", map);
		return msg;
	}
	/**
	 * 计量设备检测-->历史记录 
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAndSaveHistory(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		if(project_info_no==null ){
			project_info_no = "";
		}
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String history_id = reqDTO.getValue("history_id");
		if(history_id==null ){
			history_id = "";
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append("select t.history_id ,t.project_info_no ,t.report_title ,t.report_date ,t.report_code ,")
		.append(" t.report_maker ,t.org_id ,org.org_abbreviation org_name ")
		.append(" from bgp_qua_equipment_history t")
		.append(" left join comm_org_information org on t.org_id = org.org_id and org.bsflag ='0'")
		.append(" where t.bsflag='0' and t.project_info_no = '").append(project_info_no).append("'")
		.append(" and t.history_id='").append(history_id).append("' ");
		Map historyMap = pureJdbcDao.queryRecordBySQL(sb.toString());
		msg.setValue("historyMap", historyMap);
		return msg;
	}
	/**
	 * 计量设备检测-->历史记录 -->保存
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEquipHistory(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		if(project_info_no==null ){
			project_info_no = "";
		}
		String history_id = reqDTO.getValue("history_id");
		Map map = reqDTO.toMap();
		map.put("project_info_no", project_info_no);
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		map.put("bsflag", "0");
		if(history_id ==null || history_id.trim().equals("")){
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		System.out.println(map);
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_equipment_history");
		msg.setValue("history_id", uId.toString());
		return msg;
	}
	/**
	 * 质量分析会 --> 列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getMeetingList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		if(projectInfoNo==null){
			projectInfoNo = "";
		}
		String meeting_title = reqDTO.getValue("meeting_title");
		if(meeting_title==null){
			meeting_title = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select t.meeting_id ,t.meeting_title ,t.meeting_date ,")
		.append(" t.meeting_master ,u.user_name master_name , t.notes,")
		.append(" t.meeting_num ,t.org_id ,o.org_abbreviation org_name")
		.append(" from bgp_qua_meeting t")
		.append(" left join p_auth_user u on t.meeting_master = u.user_id and u.bsflag='0'")
		.append(" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0'")
		.append(" left join comm_org_information o on t.org_id = o.org_id and o.bsflag='0' ")
		.append(" where t.bsflag = '0' ")
		.append(" and t.project_info_no = '").append(projectInfoNo).append("'")
		.append(" and t.meeting_title like'%").append(meeting_title).append("%'")
		.append(" order by t.modifi_date desc");
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}
	
	/**
	 * 质量分析会-->保存
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMeeting(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		if(project_info_no == null){
			project_info_no = "";
		}
		String meeting_id = reqDTO.getValue("meeting_id");
		Map map = reqDTO.toMap();
		map.put("project_info_no", project_info_no);
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(meeting_id!=null && !meeting_id.trim().equals("")){
			map.put("meeting_id", meeting_id);
		}else{
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_meeting");
		return msg;
	}
	/**
	 * 质量分析报告-->保存
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveMeetingReport(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String report_id = reqDTO.getValue("report_id");
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(report_id!=null && !report_id.trim().equals("")){
			map.put("report_id", report_id);
		}else{
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_meeting_report");
		return msg;
	}
	/**
	 * 质量分析会-->详细
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMeetingDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String meeting_id = reqDTO.getValue("meeting_id");
		if(meeting_id == null){
			meeting_id = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select t.meeting_id ,t.meeting_title ,t.meeting_date ,")
		.append(" t.meeting_master ,u.user_name master_name , t.notes,")
		.append(" t.meeting_num ,t.org_id ,o.org_abbreviation org_name")
		.append(" from bgp_qua_meeting t")
		.append(" left join p_auth_user u on t.meeting_master = u.user_id and u.bsflag='0'")
		.append(" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0'")
		.append(" left join comm_org_information o on t.org_id = o.org_id and o.bsflag='0' ")
		.append(" where t.bsflag = '0' ").append(" and t.meeting_id = '").append(meeting_id).append("'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("meetingDetail", map);
		sb = new StringBuffer();
		sb.append("select t.report_id ,t.report_code ,t.report_num ,t.report_date ,t.work_area ,")
		.append(" t.line_num ,t.master_id , p1.user_name report_master, t.record_id ,p2.user_name record_name,")
		.append(" t.design_work ,t.complete_work ,t.surface ,t.stimulate ,t.technology ,t.manage_step ,")
		.append(" t.original_data ,t.sections ,t.proplem ,t.next_step ,t.supervise")
		.append(" from bgp_qua_meeting_report t")
		.append(" left join bgp_qua_meeting m on t.meeting_id = m.meeting_id and m.bsflag='0'")
		.append(" left join p_auth_user p1 on t.master_id = p1.user_id and p1.bsflag ='0'")
		.append(" left join p_auth_user p2 on t.record_id = p2.user_id and p2.bsflag ='0'")
		.append(" where t.bsflag = '0' ").append(" and t.meeting_id = '").append(meeting_id).append("'");
		Map report = pureJdbcDao.queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("reportDetail", report);
		return msg;
	}
	/**
	 * 质量分析会  --> 删除管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteMeeting(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String meeting_id = reqDTO.getValue("meeting_id");
		if (meeting_id != null && !meeting_id.trim().equals("")) {
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_meeting t set t.bsflag='1' ")
			.append(" where t.meeting_id='").append(meeting_id).append("'");
			System.out.println(sb.toString());
			jdbcDao.executeUpdate(sb.toString());
		}		
		return msg;
	}
	/**
	 * QC活动 --> 列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getQCList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		
		String qc_id = reqDTO.getValue("qc_id");
		msg.setValue("qc_id", qc_id);
		
		if(project_info_no==null){
			project_info_no = "";
		}
		String org_subjection_id = reqDTO.getValue("org_subjection_id");
		String qc_title = reqDTO.getValue("qc_title");
		if(qc_title==null){
			qc_title = "";
		}
		String pro_status = reqDTO.getValue("pro_status");
		if(pro_status==null){
			pro_status = "";
		}
		StringBuffer sb = new StringBuffer();
		sb = new StringBuffer();
		sb.append("select * from(select t.eps_id ,t.eps_name ,t.org_id , sub.org_subjection_id ,'").append(org_subjection_id).append("' subjection_id")
		.append(" from bgp_eps_code t join comm_org_subjection sub on t.org_id = sub.org_id and sub.bsflag='0'")
		.append(" where t.bsflag='0' and t.parent_object_id =(select c.object_id")
		.append(" from bgp_eps_code c where c.org_id ='C6000000000001')) org ")
		.append(" where org.subjection_id like concat(org.org_subjection_id,'%')");	
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(map!=null ){
			String wtc = "";
			if(map.get("eps_id")!=null && !map.get("eps_id").toString().trim().equals("")){
				wtc = (String)map.get("eps_id");
				wtc = wtc.substring(3);
			}
			int year = new Date().getYear()+1900;
			wtc = wtc +"-" +year;
			sb = new StringBuffer();
			sb.append("update bgp_qua_qc q ")
			.append(" set q.qc_code = concat(case when rownum<=9 then'").append(wtc).append("-00' when rownum <=99 then '").append(wtc).append("-0' else '' end,rownum)")
			.append(" where q.qc_id in( select t.qc_id  from bgp_qua_qc t")
			.append(" left join common_busi_wf_middle m on t.qc_id = m.business_id and m.bsflag='0'")
			.append(" left join wf_r_examineinst r on m.proc_inst_id = r.procinst_id ")
			.append(" where t.bsflag='0' and m.proc_status ='3' and t.org_subjection_id like'").append(user.getSubOrgIDofAffordOrg())
			.append("%') and q.bsflag ='0' and q.org_subjection_id like'").append(user.getSubOrgIDofAffordOrg()).append("%'");
			jdbcDao.executeUpdate(sb.toString());
		}
		
		sb = new StringBuffer();
		sb.append("select concat(rownum ,'') auto ,d.* from( select t.qc_id id ,f.file_id ,t.qc_code , v.version_ucm_id ucm_id, t.qc_title ,f.file_name name , t.qc_code relation ,")
		.append(" decode(wf.proc_status,'1','待审核','3','审核通过','4','审核不通过','未上报') pro_status ,i.org_abbreviation org_name ,")
		.append(" concat(concat(t.qc_id ,':'),wf.proc_status) id_proc from bgp_qua_qc t ")
		.append(" join comm_org_information i on t.org_id = i.org_id and i.bsflag ='0'")
		.append(" left join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag='0' join bgp_doc_file_version v   on f.file_id = v.file_id ")
		.append(" left join common_busi_wf_middle wf on t.qc_id = wf.business_id and wf.bsflag='0'")
		.append(" where t.bsflag='0' ");
		String year = reqDTO.getValue("year");
		if(year !=null && year.trim().equals("")){
			sb.append(" and t.qc_code like'%"+year+"%'");
		}
		if(pro_status!=null && !pro_status.equals("0") && !pro_status.equals("")){
			sb.append(" and wf.proc_status like'%").append(pro_status).append("%'");
		}
		if(qc_title!=null && !qc_title.equals("")){
			sb.append(" and t.qc_title like'%").append(qc_title).append("%'");
		}
		if(project_info_no!=null && !project_info_no.equals("")){
			sb.append(" and t.project_info_no ='").append(project_info_no).append("' order by t.qc_code) d ");
		}else{
			sb.append(" and t.org_subjection_id like '").append(org_subjection_id).append("%' order by t.qc_code) d ");
		}
		System.out.println(sb.toString());
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		page = jdbcDao.queryRecordsBySQL(sb.toString(), page);
		List recordList = page.getData();
		msg.setValue("datas", recordList);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		
		return msg;
	}
	/**
	 * QC活动-->保存
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveQC(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		if(project_info_no == null){
			project_info_no = "";
		}
		String qc_id = reqDTO.getValue("qc_id");
		Map map = reqDTO.toMap();
		map.put("project_info_no", project_info_no);
		map.put("bsflag", "0");
		map.put("updator_id", user.getUserId());
		map.put("modifi_date", new Date());
		map.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		if(qc_id!=null && !qc_id.trim().equals("")){
			map.put("qc_id", qc_id);
		}else{
			map.put("creator_id", user.getUserId());
			map.put("create_date", new Date());
		}
		System.out.println(map);
		Serializable uId = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_qua_qc");
		return msg;
	}
	/**
	 * QC活动-->详细
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getQCDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String qc_id = reqDTO.getValue("qc_id");
		if(qc_id == null){
			qc_id = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select t.qc_id ,t.qc_title ,t.start_date ,t.end_date ,t.reason ,")
		.append(" t.qc_master ,u.user_name master_name , t.notes ,p.project_name ,")
		.append(" t.qc_num ,t.org_id ,o.org_abbreviation org_name ,t.qc_code")
		.append(" from bgp_qua_qc t")
		.append(" left join p_auth_user u on t.qc_master = u.user_id and u.bsflag='0'")
		.append(" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0'")
		.append(" left join comm_org_information o on t.org_id = o.org_id and o.bsflag='0' ")
		.append(" where t.bsflag = '0' ").append(" and t.qc_id = '").append(qc_id).append("'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("qcDetail", map);
		return msg;
	}
	/**
	 * QC活动 --> 删除管理
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteQC(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String qc_id = reqDTO.getValue("qc_id");
		if (qc_id != null && !qc_id.trim().equals("")) {
			StringBuffer sb = new StringBuffer();
			sb.append(" update bgp_qua_qc t set t.bsflag='1' ")
			.append(" where t.qc_id='").append(qc_id).append("'");
			System.out.println(sb.toString());
			jdbcDao.executeUpdate(sb.toString());
		}		
		return msg;
	}
	/**
	 * QC活动-->通过qc_id 获得 文档的属性
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFileDetail(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String qc_id = reqDTO.getValue("qc_id");
		if(qc_id == null){
			qc_id = "";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select t.qc_id , f.file_id ,f.ucm_id")
		.append(" from bgp_qua_qc t")
		.append(" left join bgp_doc_gms_file f on t.qc_id = f.relation_id ")
		.append(" where t.bsflag = '0' and f.bsflag = '0' ").append(" and t.qc_id = '").append(qc_id).append("'");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		System.out.println(sb.toString());
		msg.setValue("fileDetail", map);
		return msg;
	}
	/**
	 * 单、多项目 -->质量通报 -->列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getNoticeList(ISrvMsg isrvmsg) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String file_name = isrvmsg.getValue("file_name");
		if(file_name == null){
			file_name = "";
		}
		String subjection_id = isrvmsg.getValue("subjection_id");
		if(subjection_id == null){
			subjection_id = "";
		}
		String relation_id = "notice:" + subjection_id;
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
		StringBuffer querySql = new StringBuffer("");
		querySql.append("select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,t.ucm_id ")
		.append(" from bgp_doc_gms_file t")
		.append(" where t.bsflag='0' and t.is_file='1'")
		.append(" and t.file_name like '%"+file_name+"%'")
		.append(" and t.relation_id like '"+relation_id+"%'")
		.append(" order by t.create_date desc");
		
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	/**
	 * 单、多项目 -->质量管理文件 -->列表
	 * @author xiaqiuyu
	 * @date 2012-6-6
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getManagementList(ISrvMsg isrvmsg) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String file_name = isrvmsg.getValue("file_name");
		if(file_name == null){
			file_name = "";
		}
		String subjection_id = isrvmsg.getValue("subjection_id");
		if(subjection_id == null){
			subjection_id = "";
		}
		String relation_id = "management:" + subjection_id;
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
		StringBuffer querySql = new StringBuffer("");
		querySql.append("select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,t.ucm_id ,i.org_abbreviation org_name ")
		.append(" from bgp_doc_gms_file t")
		.append(" join comm_org_subjection s on t.org_subjection_id = s.org_subjection_id and s.bsflag ='0'")
		.append("   join comm_org_information i on s.org_id = i.org_id and i.bsflag ='0'")
		.append(" where t.bsflag='0' and t.is_file='1'")
		.append(" and t.file_name like '%"+file_name+"%'")
		.append(" and t.relation_id like '"+relation_id+"%'")
		.append(" order by t.create_date desc");
		
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	/**
	 * eps树 --> 东方--物探处--项目
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getProjectTreeEps(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String checked = reqDTO.getValue("checked");
		String leaf = reqDTO.getValue("leaf");
		String org_id = user.getOrgId();
		if(org_id ==null){
			org_id ="";
		}
		String org_subjection_id = user.getSubOrgIDofAffordOrg();
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null || project_info_no.trim().equals("")){
			project_info_no = user.getProjectInfoNo();
		}
		
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("C105")){//点击的根节点
			sb = new StringBuffer();//物探处节点
			sb.append("select wtc.org_subjection_id id ,wtc.org_abbreviation name ,wtc.org_id ,'' project_info_no ,'true' eps ")
			.append(" from bgp_comm_org_wtc wtc")
			.append(" where wtc.bsflag = '0' and wtc.org_subjection_id like '"+org_subjection_id+"%' order by wtc.order_num");

			List root = pureJdbcDao.queryRecords(sb.toString());
			List list = new ArrayList();
			if(checked!=null && checked.trim().equals("true")){//是否显示复选框，是
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					if(org_subjection_id!=null && org_subjection_id.equals("C105") && leaf!=null && leaf.equals("true")){//东方用户，则物探处节点就是末级节点
						map.put("checked" ,false);
						map.put("leaf" ,true);
					}
					if(org_subjection_id!=null && !org_subjection_id.equals("C105")){//物探处用户
						map.put("expanded" ,true);
					}
					list.add(map);
				}
			}else{
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					if(org_subjection_id!=null && org_subjection_id.equals("C105") && leaf!=null && leaf.equals("true")){
						map.put("leaf" ,true);
					}
					if(org_subjection_id!=null && !org_subjection_id.equals("C105")){
						map.put("expanded" ,true);
					}
					list.add(map);
				}
			}
			json = JSONArray.fromObject(list);
		}else{//东方的下级节点，物探处节点的下级节点是否井中、浅海、深海有业务区分
			if(node!=null && node.trim().startsWith("C105")){//点击的是物探处节点
				sb = new StringBuffer();
				sb.append(" select e.project_type||':'||'"+node+"' id ,e.eps_name name ,e.org_id ,'"+node+"' project_info_no,'true' eps")
				.append(" from bgp_eps_code e join comm_org_subjection s on e.org_id = s.org_id and s.bsflag ='0'")
				.append(" where e.bsflag ='0' and s.org_subjection_id ='"+node+"' and e.parent_object_id !='8ad891b1387dfd9b01387e0531af0002' order by e.order_num");
				List temp = pureJdbcDao.queryRecords(sb.toString());
				if(temp == null || temp.size()<=0){ //该物探处节点是否有井中、浅海、深海有业务区分，否则直接显示项目级
					sb = new StringBuffer();
					sb.append("select distinct t.project_info_no id,t.project_name name ,d.org_id ,d.org_subjection_id project_info_no ,'false' eps")
					.append(" from gp_task_project t join gp_task_project_dynamic d on t.project_info_no = d.project_info_no ")
					.append(" and d.bsflag ='0' and t.exploration_method = d.exploration_method ")
					.append(" where t.bsflag ='0' and d.org_subjection_id like'").append(node).append("%' and t.project_father_no is null");
					List root = pureJdbcDao.queryRecords(sb.toString());
					List list = new ArrayList();
					if(checked!=null && checked.trim().equals("true")){
						for(int i =0;i<root.size() ;i++){
							Map map = (Map)root.get(i);
							map.put("checked" ,false);
							list.add(map);
						}
					}else{
						for(int i =0;i<root.size() ;i++){
							Map map = (Map)root.get(i);
							list.add(map);
						}
					}
					json = JSONArray.fromObject(list);
				}else{//该物探处节点是否有井中、浅海、深海有业务区分，是
					sb = new StringBuffer();
					sb.append(" select e.project_type||':'||'"+node+"' id ,e.eps_name name ,e.org_id ,'"+node+"' project_info_no,'true' eps")
					.append(" from bgp_eps_code e join comm_org_subjection s on e.org_id = s.org_id and s.bsflag ='0'")
					.append(" where e.bsflag ='0' and s.org_subjection_id ='"+node+"' and e.parent_object_id !='8ad891b1387dfd9b01387e0531af0002' order by e.order_num");
					List root = pureJdbcDao.queryRecords(sb.toString());
					json = JSONArray.fromObject(root);
				}
			}else if(node!=null && node.trim().indexOf(":")!=-1){//拓展业务节点
				String project_type = node.split(":")[0];
				node = node.split(":")[1];
				sb = new StringBuffer();
				sb.append("select distinct t.project_info_no id,t.project_name name ,d.org_id ,d.org_subjection_id project_info_no ,'false' eps")
				.append(" from gp_task_project t join gp_task_project_dynamic d on t.project_info_no = d.project_info_no ")
				.append(" and d.bsflag ='0' and t.exploration_method = d.exploration_method ")
				.append(" where t.bsflag ='0' and (t.project_status !='5000100001000000003' or t.project_status is null)")
				//.append(" where t.bsflag ='0' and t.project_status !='5000100001000000003'")
				.append(" and d.org_subjection_id like'").append(node).append("%' and t.project_type like'"+project_type+"%' and t.project_father_no is null");//t.project_father_no is null 显示年度项目
				List root = pureJdbcDao.queryRecords(sb.toString());
				List list = new ArrayList();
				if(checked!=null && checked.trim().equals("true")){
					for(int i =0;i<root.size() ;i++){
						Map map = (Map)root.get(i);
						map.put("checked" ,false);
						list.add(map);
					}
				}else{
					for(int i =0;i<root.size() ;i++){
						Map map = (Map)root.get(i);
						list.add(map);
					}
				}
				json = JSONArray.fromObject(list);
			}else{//年度项目的子项目
				sb = new StringBuffer();
				sb.append("select distinct t.project_info_no id,t.project_name name ,d.org_id ,d.org_subjection_id project_info_no ,'false' eps")
				.append(" from gp_task_project t join gp_task_project_dynamic d on t.project_info_no = d.project_info_no ")
				.append(" and d.bsflag ='0' and t.exploration_method = d.exploration_method ")
				//.append(" where t.bsflag ='0' and t.project_status !='5000100001000000003'")
				.append(" where t.bsflag ='0' and (t.project_status !='5000100001000000003' or t.project_status is null) ")
				.append(" and t.project_father_no like '").append(node).append("%'");
				List root = pureJdbcDao.queryRecords(sb.toString());
				List list = new ArrayList();
				if(checked!=null && checked.trim().equals("true")){
					for(int i =0;i<root.size() ;i++){
						Map map = (Map)root.get(i);
						map.put("checked" ,false);
						map.put("leaf" ,true);
						list.add(map);
					}
				}else{
					for(int i =0;i<root.size() ;i++){
						Map map = (Map)root.get(i);
						map.put("leaf" ,true);
						list.add(map);
					}
				}
				json = JSONArray.fromObject(list);
			}
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	public List getProjectChild(String subjection_id) throws Exception{
		List list = new ArrayList();
		StringBuffer sb  = new StringBuffer();
		sb.append("select distinct t.project_name name ,d.org_id ,d.org_subjection_id ,t.project_info_no project")
		.append(" from gp_task_project t")
		.append(" join gp_task_project_dynamic d on t.project_info_no = d.project_info_no ")
		.append(" and d.bsflag ='0' and t.exploration_method = d.exploration_method ")
		.append(" join comm_org_subjection o on d.org_id = o.org_id and o.bsflag ='0'")
		.append(" join comm_coding_sort_detail s on t.manage_org = s.coding_code_id and s.bsflag = '0' ")
		.append(" where t.bsflag ='0'")
		.append(" and d.org_subjection_id like'").append(subjection_id).append("%'");
		list = pureJdbcDao.queryRecords(sb.toString());
		List jsList = new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map = (Map)list.get(i);
			map.put("eps", "false");
			map.put("children", null);
			map.put("leaf", true);
			map.put("expanded", false);
			map.put("checked", false);
			jsList.add(map);
		}
		return jsList;
	}
}


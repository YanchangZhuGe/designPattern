package com.bgp.dms.autoscore;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.CommonUtil;
import com.bgp.dms.util.ServiceUtils;
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
public class AutoScoreSrv extends BaseService {

	public AutoScoreSrv() {
		log = LogFactory.getLogger(AutoScoreSrv.class);
	}
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 查询自动评分信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAutoScoreConfList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryAutoScoreConfList");
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
		String conf_table_type = isrvmsg.getValue("conf_table_type");// 配置表类型
		String conf_name = isrvmsg.getValue("conf_name");// 配置名称
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.user_name as updator_name"
				+ " from comm_autoscore_conf t "
				+ " left join p_auth_user_dms t1 on t.updator=t1.user_id "
				+ " where t.bsflag='0' ");
		// 配置表类型
		if (StringUtils.isNotBlank(conf_table_type)) {
			querySql.append(" and t.conf_table_type = '" + conf_table_type + "'");
		}
		// 配置名称
		if (StringUtils.isNotBlank(conf_name)) {
			querySql.append(" and t.conf_name like '%" + conf_name + "%'");
		}
		querySql.append(" order by t.modify_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询自动评分信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAutoScoreConfDetailList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryAutoScoreConfList");
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
		String confId = isrvmsg.getValue("confId");// 配置id
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*"
				+ " from comm_autoscore_conf_filter t "
				+ " where t.bsflag='0' and t.conf_id='"+confId+"'");
		querySql.append(" order by t.modify_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 获取自动评分配置表信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAutoScoreConfInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getAutoScoreConfInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String conf_id = isrvmsg.getValue("conf_id");
		// 查询自动评分数据
		String sql = "select t.*,t1.user_name as updator_name"
				+ " from comm_autoscore_conf t "
				+ " left join p_auth_user_dms t1 on t.updator=t1.user_id "
				+ " where t.bsflag='0' and t.conf_id='"+conf_id+"'";
		Map map=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * 获取自动评分信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAutoScoreInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getAutoScoreInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String conf_id = isrvmsg.getValue("conf_id");// 指标配置id
		//自动评分信息
		String msql = "select t.* from comm_autoscore_conf t where t.bsflag='0' and t.conf_id='"+conf_id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		//自动评分配置项信息
		String sql = "select t.*"
				+ " from comm_autoscore_conf_filter t"
				+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("data", map);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 新增或修改自动评分信息
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateAutoScore(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateAutoScore");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String conf_table_type=map.get("conf_table_type").toString();//配置表类型
		String conf_name=map.get("conf_name").toString();//配置名称
		String conf_content_type=map.get("conf_content_type").toString();//配置内容类型
		String conf_table_name=map.get("conf_table_name").toString();//配置表名称
		String conf_column_name=map.get("conf_column_name").toString();//配置查询列
		String conf_content=map.get("conf_content").toString();//复杂表配置内容
		String flag=map.get("flag").toString();//新增修改标志
		String confId="";//配置主键
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//保存操作
				Map mainMap=new HashMap();
				mainMap.put("conf_table_type", conf_table_type);
				mainMap.put("conf_name", conf_name);
				mainMap.put("conf_content_type", conf_content_type);
				mainMap.put("conf_table_name", conf_table_name);
				mainMap.put("conf_column_name", conf_column_name);
				mainMap.put("conf_content", conf_content);
				ServiceUtils.setCommFields(mainMap, "conf_id", user);
				confId = (String) jdbcDao.saveOrUpdateEntity(mainMap, "comm_autoscore_conf");
			}else{//修改操作
				confId=map.get("conf_id").toString();
				Map umainMap=new HashMap();
				umainMap.put("conf_id", confId);
				umainMap.put("conf_table_type", conf_table_type);
				umainMap.put("conf_name", conf_name);
				umainMap.put("conf_content_type", conf_content_type);
				umainMap.put("conf_table_name", conf_table_name);
				umainMap.put("conf_column_name", conf_column_name);
				umainMap.put("conf_content", conf_content);
				ServiceUtils.setCommFields(umainMap, "conf_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "comm_autoscore_conf");
			}
			for (Object key : map.keySet()) {
				//如果有需要删除的过滤信息，保存其删除sql
				if(((String)key).startsWith("del_tr")){
					Map delMap = new HashMap();
					delMap.put("conf_filter_id", (String)map.get(key));
					sqlList.add(CommonUtil.assembleDelSql("conf_filter_id",delMap,"comm_autoscore_conf_filter"));
				}
				if(((String)key).startsWith("conf_filter_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//保存生成的sql，主键为空值，保存否则修改
					if(null==map.get("conf_filter_id_"+indexStr) || StringUtils.isBlank(map.get("conf_filter_id_"+indexStr).toString())){
						Map aMap = new HashMap();
						String iuuid = UUID.randomUUID().toString().replaceAll("-", "");
						aMap.put("conf_filter_id", iuuid);
						aMap.put("conf_id", confId);
						aMap.put("connect_type", (String)map.get("connect_type_"+indexStr));
						aMap.put("filter_column_type", (String)map.get("filter_column_type_"+indexStr));
						aMap.put("date_type_format", (String)map.get("date_type_format_"+indexStr));
						aMap.put("filter_column_name", (String)map.get("filter_column_name_"+indexStr));
						aMap.put("query_type", (String)map.get("query_type_"+indexStr));
						aMap.put("filter_column_value", (String)map.get("filter_column_value_"+indexStr));
						aMap.put("creater", user.getUserId());
						aMap.put("create_date", "sysdate");
						aMap.put("updator", user.getUserId());
						aMap.put("modify_date", "sysdate");
						aMap.put("bsflag", "0");
						sqlList.add(CommonUtil.assembleSql(aMap,"comm_autoscore_conf_filter",new String[]{"create_date","modify_date"},"add",""));
					}else{
						Map uMap = new HashMap();
						uMap.put("conf_filter_id", (String)map.get("conf_filter_id_"+indexStr));
						uMap.put("connect_type", (String)map.get("connect_type_"+indexStr));
						uMap.put("filter_column_type", (String)map.get("filter_column_type_"+indexStr));
						uMap.put("date_type_format", (String)map.get("date_type_format_"+indexStr));
						uMap.put("filter_column_name", (String)map.get("filter_column_name_"+indexStr));
						uMap.put("query_type", (String)map.get("query_type_"+indexStr));
						uMap.put("filter_column_value", (String)map.get("filter_column_value_"+indexStr));
						uMap.put("updator", user.getUserId());
						uMap.put("modify_date", "sysdate");
						sqlList.add(CommonUtil.assembleSql(uMap,"comm_autoscore_conf_filter",new String[]{"modify_date"},"update","conf_filter_id"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//批处理操作
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 删除自动评分信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteAutoScoreInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteAutoScoreInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String conf_id = isrvmsg.getValue("conf_id");// 配置id
		try{
			//删除自动评分过滤表
			String delSql0 = "update comm_autoscore_conf_filter set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where conf_id='"+conf_id+"'";
			jdbcDao.executeUpdate(delSql0);
			//删除自动评分关联表
			String delSql1 = "update comm_autoscore_relation set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where conf_id='"+conf_id+"'";
			jdbcDao.executeUpdate(delSql1);
			//删除自动评分配置表
			String delSql2 = "update comm_autoscore_conf set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where conf_id='"+conf_id+"'";
			jdbcDao.executeUpdate(delSql2);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 查询自动评分关联信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAutoScoreRelationList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryAutoScoreRelationList");
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
		String assess_name = isrvmsg.getValue("assess_name");// 考核指标名称
		String conf_name = isrvmsg.getValue("conf_name");// 配置名称
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.conf_name as conf_name,t2.user_name as updator_name"
				+ " from comm_autoscore_relation t "
				+ " left join comm_autoscore_conf t1 on t.conf_id=t1.conf_id "
				+ " left join p_auth_user_dms t2 on t.updator=t2.user_id "
				+ " where t.bsflag='0' ");
		// 配置表类型
		if (StringUtils.isNotBlank(assess_name)) {
			querySql.append(" and t.assess_name like '%" + assess_name + "%'");
		}
		// 配置名称
		if (StringUtils.isNotBlank(conf_name)) {
			querySql.append(" and t1.conf_name like '%" + conf_name + "%'");
		}
		querySql.append(" order by t.modify_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 获取自动评分关联表信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAutoScoreRelationInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getAutoScoreRelationInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String relation_id = isrvmsg.getValue("relation_id");
		// 查询自动评分数据
		String sql = "select t.*,t1.conf_name as conf_name,t2.user_name as updator_name"
				+ " from comm_autoscore_relation t "
				+ " left join comm_autoscore_conf t1 on t.conf_id=t1.conf_id "
				+ " left join p_auth_user_dms t2 on t.updator=t2.user_id "
				+ " where t.bsflag='0' and t.relation_id='"+relation_id+"'";
		Map map=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * 新增或修改自动评分关联信息
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateAutoScoreRelation(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateAutoScoreRelation");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String conf_id=map.get("conf_id").toString();//自动评分配置id
		String assess_id=map.get("assess_id").toString();//自动评分考核id
		String business_id=map.get("business_id").toString();//业务id
		String assess_name=map.get("assess_name").toString();//考核指标名称
		String score_condition=map.get("score_condition").toString();//评分条件
		String flag=map.get("flag").toString();//新增修改标志
		//存放要保存，修改的sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//保存操作
				Map mainMap=new HashMap();
				mainMap.put("conf_id", conf_id);
				mainMap.put("assess_id", assess_id);
				mainMap.put("business_id", business_id);
				mainMap.put("assess_name", assess_name);
				mainMap.put("score_condition", score_condition);
				ServiceUtils.setCommFields(mainMap, "relation_id", user);
				jdbcDao.saveOrUpdateEntity(mainMap, "comm_autoscore_relation");
			}else{//修改操作
				String relationId=map.get("relation_id").toString();
				Map umainMap=new HashMap();
				umainMap.put("relation_id", relationId);
				umainMap.put("conf_id", conf_id);
				umainMap.put("assess_id", assess_id);
				umainMap.put("business_id", business_id);
				umainMap.put("assess_name", assess_name);
				umainMap.put("score_condition", score_condition);
				ServiceUtils.setCommFields(umainMap, "relation_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "comm_autoscore_relation");
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 删除自动评分关联信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteAutoScoreRelationInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteAutoScoreRelationInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String relation_id = isrvmsg.getValue("relation_id");// 关联id
		try{
			//删除自动评分关联表
			String delSql0 = "update comm_autoscore_relation set bsflag='1',updator='"+user.getUserId()+"',modify_date=sysdate where relation_id='"+relation_id+"'";
			jdbcDao.executeUpdate(delSql0);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 获取考核信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getAssessInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//自动评分配置项信息
		String sql = "select t.conf_id as id,t.conf_name as name "
				+ " from comm_autoscore_conf t"
				+ " where t.bsflag = '0' and t.conf_table_type='1' order by t.create_date ";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 获取考核项sql信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessItemSqlInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getAssessItemSqlInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String conf_id = isrvmsg.getValue("conf_id");// 配置id
		String sqlStr="";
		//自动评分配置项信息
		String sql = "select t.conf_id,t.conf_content_type,t.conf_table_name,t.conf_column_name,t.conf_content "
				+ " from comm_autoscore_conf t"
				+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
		Map map=jdbcDao.queryRecordBySQL(sql);
		String sql2 = "select t.conf_filter_id,t.connect_type,t.filter_column_type,t.date_type_format,t.filter_column_name,t.query_type,t.filter_column_value "
				+ " from comm_autoscore_conf_filter t"
				+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
		List<Map> list= jdbcDao.queryRecords(sql2);
		Map gmap=new HashMap();
		gmap.put(map, list);
		sqlStr=CommonUtil.getAutoScoreSql(gmap);
		System.out.println("sqlStr == "+sqlStr);
		responseDTO.setValue("data", sqlStr);
		return responseDTO;
	}
	
	/**
	 * 获取考核项得分信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getScoreInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getScoreInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String relation_id = isrvmsg.getValue("relation_id");// 关联id
		String sql=""; 
		//关联sql
		String rsql = "select t.relation_id,t.conf_id,t.score_condition "
				+ " from comm_autoscore_relation t"
				+ " where t.bsflag = '0' and t.relation_id='"+relation_id+"'";
		Map rmap=jdbcDao.queryRecordBySQL(rsql);
		String conf_id=rmap.get("conf_id") == null ? "" : (String) rmap.get("conf_id");
		String score_condition=rmap.get("score_condition") == null ? "" : (String) rmap.get("score_condition");
		//自动评分配置项信息
		String csql = "select t.conf_id,t.conf_content_type,t.conf_table_name,t.conf_column_name,t.conf_content "
				+ " from comm_autoscore_conf t"
				+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
		Map map=jdbcDao.queryRecordBySQL(csql);
		String fsql = "select t.conf_filter_id,t.connect_type,t.filter_column_type,t.date_type_format,t.filter_column_name,t.query_type,t.filter_column_value "
				+ " from comm_autoscore_conf_filter t"
				+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
		List<Map> list= jdbcDao.queryRecords(fsql);
		Map gmap=new HashMap();
		gmap.put(map, list);
		sql="select "+score_condition+" from ( "+CommonUtil.getAutoScoreSql(gmap)+" )";
		Map smap=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("data", smap);
		return responseDTO;
	}
	
	public static void main(String[] args) throws Exception{
		int score=0;
		Map map=new HashMap();
		Map kMap1=new HashMap();
		kMap1.put("id", "0");
		kMap1.put("conf_content_type", "0");
		kMap1.put("conf_table_name", "test_001");
		kMap1.put("conf_column_name", "* ");
		List list1=new ArrayList<Map>();
		Map smap1=new HashMap();
		smap1.put("connect_type", "and");
		smap1.put("filter_column_type", "string");
		smap1.put("filter_column_name", "type");
		smap1.put("query_type", "=");
		smap1.put("filter_column_value", "3");
		smap1.put("date_type_format", "");
		list1.add(smap1);
		Map smap2=new HashMap();
		smap2.put("connect_type", "or");
		smap2.put("filter_column_type", "number");
		smap2.put("filter_column_name", "id");
		smap2.put("query_type", "in");
		smap2.put("filter_column_value", "1,2,3,4");
		smap2.put("date_type_format", "");
		list1.add(smap2);
		map.put(kMap1, list1);
		Map kMap2=new HashMap();
		kMap2.put("id", "1");
		kMap2.put("conf_content_type", "0");
		kMap2.put("conf_table_name", "test_001");
		kMap2.put("conf_column_name", "* ");
		List list2=new ArrayList<Map>();
		Map smap21=new HashMap();
		smap21.put("connect_type", "and");
		smap21.put("filter_column_type", "date");
		smap21.put("filter_column_name", "u_date");
		smap21.put("query_type", ">");
		smap21.put("filter_column_value", "2013-03-12");
		smap21.put("date_type_format", "yyyy-mm-dd");
		list2.add(smap21);
		map.put(kMap2, list2);
		System.out.println(CommonUtil.getAutoScoreSql(map));
	}
}

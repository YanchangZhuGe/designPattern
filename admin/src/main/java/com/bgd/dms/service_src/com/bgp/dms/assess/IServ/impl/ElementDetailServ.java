package com.bgp.dms.assess.IServ.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import com.bgp.dms.assess.IServ.IElementDetailServ;
import com.bgp.dms.assess.util.AssessTools;
import com.bgp.dms.util.CommonUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class ElementDetailServ implements IElementDetailServ {
	ILog log = null;
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	public ElementDetailServ() {
		log = LogFactory.getLogger(ElementDetailServ.class);
	}
	@Override
	public void saveElementDetail(Map<String, Object> map) {
		// TODO Auto-generated method stub

	}

	@Override
	public void updateElementDetail(Map<String, Object> map) {
		// TODO Auto-generated method stub

	}

	@Override
	public void deleteElementDetailByID(String id) {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, Object> findElementDetailByID(String id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Map<String, Object>> findElementDetailByEleID(String eleId,String chk_name,PageModel page,String DETAIL_FLAG) {
		// TODO Auto-generated method stub
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		
		querySql.append("select DETAIL_ID DETAIL_ID, CHECK_CONTENT CHECK_CONTENT, ");
		querySql.append("CHECK_ITEM CHECK_ITEM,");
		querySql.append("STANDARD_SCORE STANDARD_SCORE from dms_assess_element_detail ");
		querySql.append("where ELEMENT_ID = '");
		querySql.append(eleId).append("' and DETAIL_FLAG='");
		querySql.append(DETAIL_FLAG).append("'");
		// 指标名称
		if (StringUtils.isNotBlank(chk_name)) {
			querySql.append(" and CHECK_CONTENT like '%" + chk_name + "%' ");
		}
		sql = querySql.toString(); 
		if(!"".equals(eleId)){
			page = pureDao.queryRecordsBySQL(sql, page);
		}
		
		List list = page.getData();
		return list;
	}
	/**
	 * 
	 * @param eleId
	 * @param types 0：评分标准  1：集团检查项目
	 * @return
	 */
	@Override
	public int getTotalScoreByEleID(String eleId,String DETAIL_FLAG) {
		// TODO Auto-generated method stub
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select sum(STANDARD_SCORE) s_score from ");
		querySql.append("dms_assess_element_detail where ");
		querySql.append("DETAIL_FLAG= '");
		querySql.append(DETAIL_FLAG).append("' and ");
		querySql.append(" ELEMENT_ID = '");
		querySql.append(eleId).append("' ");
		sql = querySql.toString(); 
		//log.info("getTotalScoreByEleID sql = " + sql);
		int s_score = 0;
		Map<String, String> m = jdbcDao.queryRecordBySQL(sql);
		s_score = Integer.parseInt(AssessTools.valueOf(m.get("s_score"), "0"));
		
		
		return s_score;
	}
	
	@Override
	public List findAllDetailsByModelID(String flag,String modelID) {
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		
		querySql.append("select d.DETAIL_ID DETAIL_ID, d.CHECK_CONTENT CHECK_CONTENT, ");
		querySql.append("d.CHECK_ITEM CHECK_ITEM,d.ELEMENT_ID ELEMENT_ID,");
		querySql.append("d.STANDARD_SCORE STANDARD_SCORE from dms_assess_element_detail d, ");
		querySql.append("dms_assess_plat_element e ");
		querySql.append("where d.DETAIL_FLAG = '");
		querySql.append(flag).append("' ");
		querySql.append(" and e.ASSESS_ID=d.ELEMENT_ID ");
		querySql.append(" and e.ASSESS_MODEL_ID='");
		querySql.append(modelID).append("' ");
		sql = querySql.toString();
		List list = pureDao.queryRecords(sql);
		return list;
	}
	
	@Override
	public List findAllDetailsByModelID(String flag,String modelID,String orgId) {
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		
		querySql.append("select d.DETAIL_ID DETAIL_ID, d.CHECK_CONTENT CHECK_CONTENT, ");
		querySql.append("d.CHECK_ITEM CHECK_ITEM,d.ELEMENT_ID ELEMENT_ID,");
		querySql.append("d.STANDARD_SCORE STANDARD_SCORE from dms_assess_element_detail d, ");
		querySql.append("dms_assess_plat_element e ");
		querySql.append("where d.DETAIL_FLAG = '");
		querySql.append(flag).append("' ");
		querySql.append(" and e.ASSESS_ID=d.ELEMENT_ID ");
		querySql.append(" and e.ASSESS_MODEL_ID='");
		querySql.append(modelID).append("' ");
		sql = querySql.toString();
		List<Map> list = pureDao.queryRecords(sql);
		if(CollectionUtils.isNotEmpty(list)){
			String orgSubId="";
			String oSql = "select sub.org_subjection_id "
					+ " from comm_org_subjection sub "
					+ " left join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag = '0' "
					+ " where sub.bsflag = '0' and inf.org_id ='"+orgId+"'";
			Map oMap=jdbcDao.queryRecordBySQL(oSql);
			if(MapUtils.isNotEmpty(oMap)){
				orgSubId=oMap.get("org_subjection_id")==null ? "":oMap.get("org_subjection_id").toString();
			}
			for(Map map:list){
				String detail_id=map.get("detail_id")==null?"":map.get("detail_id").toString();
				String score="0";
				Map smap=getScoreInfo(detail_id,orgSubId);
				if(MapUtils.isNotEmpty(smap)){
					if(null!=smap.get("score_value") && StringUtils.isNotBlank(smap.get("score_value").toString())){
						score=smap.get("score_value").toString();
					}
				}
				map.put("auto_score", score);
			}
		}
		return list;
	}
	public Map getScoreInfo(String businessId,String orgSubId){
		Map smap=new HashMap();
		String sql=""; 
		//关联sql
		String rsql = "select t.relation_id,t.conf_id,t.score_condition "
				+ " from comm_autoscore_relation t"
				+ " where t.bsflag = '0' and t.business_id='"+businessId+"'";
		Map rmap=jdbcDao.queryRecordBySQL(rsql);
		if(MapUtils.isNotEmpty(rmap)){
			String conf_id=rmap.get("conf_id") == null ? "" : (String) rmap.get("conf_id");
			String score_condition=rmap.get("score_condition") == null ? "" : (String) rmap.get("score_condition");
			if(!"".equals(conf_id)){
				//自动评分配置项信息
				String csql = "select t.conf_id,t.conf_content_type,t.conf_table_name,t.conf_column_name,t.conf_content "
						+ " from comm_autoscore_conf t"
						+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
				Map map=jdbcDao.queryRecordBySQL(csql);
				String fsql = "select t.conf_filter_id,t.connect_type,t.filter_column_type,t.date_type_format,t.filter_column_name,t.query_type,t.filter_column_value "
						+ " from comm_autoscore_conf_filter t"
						+ " where t.bsflag = '0' and t.conf_id='"+conf_id+"'";
				List<Map> list= jdbcDao.queryRecords(fsql);
				if(MapUtils.isNotEmpty(map)){
					Map gmap=new HashMap();
					gmap.put(map, list);
					try {
						if(StringUtils.isNotBlank(score_condition)){
							sql="select "+score_condition+" from ( "+CommonUtil.getAutoScoreSql(gmap)+" )";
						}else{
							sql= CommonUtil.getAutoScoreSql(gmap);
						}
						if(StringUtils.isNotBlank(orgSubId)){
							sql=sql.replace("?"," '"+orgSubId+"%' ");
						}else{
							sql=sql.replace("?", " '%%' ");
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					smap=jdbcDao.queryRecordBySQL(sql);
				}
			}
		}
		return smap;
	}
	@Override
	public List getTotalDetailsScoresByModelID(String DETAIL_FLAG,String modelID){
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select sum(d.STANDARD_SCORE) as STANDARD_SCORE,d.ELEMENT_ID ELEMENT_ID ");
		querySql.append("from dms_assess_element_detail d, ");
		querySql.append("dms_assess_plat_element e ");
		querySql.append("where d.DETAIL_FLAG= '");
		querySql.append(DETAIL_FLAG).append("' ");
		querySql.append(" and e.ASSESS_ID=d.ELEMENT_ID ");
		querySql.append(" and e.ASSESS_MODEL_ID='");
		querySql.append(modelID).append("' ");
		querySql.append("group by d.ELEMENT_ID");
		sql = querySql.toString();
		List list = pureDao.queryRecords(sql);
		return list;
	}
}

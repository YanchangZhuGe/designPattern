package com.bgp.dms.assess.IServ.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.assess.IServ.IPlat_scoreSrv;
import com.bgp.dms.assess.util.AssessTools;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class Plat_scoreSrv implements IPlat_scoreSrv {
	ILog log = null;
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	public Plat_scoreSrv() {
		log = LogFactory.getLogger(ElementDetailServ.class);
	}

	@Override
	public String saveScore(Map scoreMap) {
		log.info("saveScore");
		/**
		 * 接收模板级评审分数参数
		 */
		String modelID = AssessTools.valueOf(scoreMap.get("modelID"), "");// ASSESS_MODEL_ID
		log.info("modelID=" + modelID);
		String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
																				// 审核部门ID
		String orgname = AssessTools.valueOf(scoreMap.get("assess_name"),
				"");// ASSESS_ORG_NAME 审核部门名称
		String userid = AssessTools.valueOf(scoreMap.get("employee_id".toLowerCase()), "");// ASSESS_USER_ID
		String username = AssessTools.valueOf(scoreMap.get("employee_name".toLowerCase()),
				"");// ASSESS_USER_NAME
		String start_time = AssessTools
				.valueOf(scoreMap.get("startDate".toLowerCase()),
						AssessTools.getCurrentTime());// ASSESS_START_DATE
		String end_time = AssessTools.valueOf(scoreMap.get("endDate".toLowerCase()),
				AssessTools.getCurrentTime());// ASSESS_END_DATE
		String createOrgID = AssessTools.valueOf(scoreMap.get("CREATE_ORG_ID"),
				"");// CREATE_ORG_ID
		String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
		String REMARK = AssessTools.valueOf(scoreMap.get("REMARK"), "");// remark
	
		String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1 整改意见
		String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
		String sql = "";
		StringBuffer sqlbuBuffer = new StringBuffer();
		String id = jdbcDao.generateUUID();
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		sqlbuBuffer.append("insert into dms_assess_plat_score ");
		sqlbuBuffer.append("(");
		sqlbuBuffer.append("assess_score_id, assess_org_id, assess_org_name, ");
		sqlbuBuffer
				.append("assess_user_id, assess_user_name, assess_start_date,");
		sqlbuBuffer.append("assess_end_date, assess_model_id, create_org_id, ");
		sqlbuBuffer.append("creator, create_date, modifier, ");
		sqlbuBuffer.append("modify_date, bsflag, remark,");
		sqlbuBuffer.append("spare1, spare2");
		sqlbuBuffer.append(")");
		sqlbuBuffer.append(" values ");
		sqlbuBuffer.append("(");

		sqlbuBuffer.append("'").append(id).append("',");
		sqlbuBuffer.append("'").append(orgid).append("',");
		sqlbuBuffer.append("'").append(orgname).append("',");

		sqlbuBuffer.append("'").append(userid).append("',");
		sqlbuBuffer.append("'").append(username).append("',");
		sqlbuBuffer.append("to_date('").append(start_time)
				.append("','yyyyMMddhh24miss'),");

		sqlbuBuffer.append("to_date('").append(end_time)
				.append("','yyyyMMddhh24miss'),");
		sqlbuBuffer.append("'").append(modelID).append("',");
		sqlbuBuffer.append("'").append(createOrgID).append("',");

		sqlbuBuffer.append("'").append(creator).append("',");
		sqlbuBuffer.append("sysdate,");
		sqlbuBuffer.append("'',");

		sqlbuBuffer.append("null,");
		sqlbuBuffer.append("'0',");
		sqlbuBuffer.append("'").append(REMARK).append("',");

		sqlbuBuffer.append("'").append(spare1).append("',");
		sqlbuBuffer.append("'").append(spare2).append("'");

		sqlbuBuffer.append(")");
		sql = sqlbuBuffer.toString();
		log.info("sql=" + sql);
		jdbcTemplate.execute(sql);
		return id;
	}

	@Override
	public String updateScore(Map scoreMap) {
		// TODO Auto-generated method stub
		log.info("updateScore");
		/**
		 * 接收模板级评审分数参数
		 */
		String scoreID = AssessTools.valueOf(scoreMap.get("scoreID"), "");// ASSESS_SCORE_ID
		String modelID = AssessTools.valueOf(scoreMap.get("modelID"), "");// ASSESS_MODEL_ID
		
		log.info("scoreID=" + scoreID);
		String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
																				// 审核部门ID
		String orgname = AssessTools.valueOf(scoreMap.get("assess_name"),
				"");// ASSESS_ORG_NAME 审核部门名称
		String userid = AssessTools.valueOf(scoreMap.get("employee_id".toLowerCase()), "");// ASSESS_USER_ID
		String username = AssessTools.valueOf(scoreMap.get("employee_name".toLowerCase()),
				"");// ASSESS_USER_NAME
		String start_time = AssessTools
				.valueOf(scoreMap.get("startDate".toLowerCase()),
						AssessTools.getCurrentTime());// ASSESS_START_DATE
		start_time = "to_date('"+ start_time +"','yyyyMMddhh24miss')";
		String end_time = AssessTools.valueOf(scoreMap.get("endDate".toLowerCase()),
				AssessTools.getCurrentTime());// ASSESS_END_DATE
		end_time = "to_date('"+ end_time +"','yyyyMMddhh24miss')";
		String createOrgID = AssessTools.valueOf(scoreMap.get("CREATE_ORG_ID"),
				"");// CREATE_ORG_ID
		String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
		String REMARK = AssessTools.valueOf(scoreMap.get("REMARK"), "");// remark
		String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1 整改意见
		String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
		String sql = "";
		StringBuffer sqlbuBuffer = new StringBuffer();
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		sqlbuBuffer.append("update dms_assess_plat_score ");
		sqlbuBuffer.append("set ASSESS_ORG_ID ='").append(orgid).append("',");
		sqlbuBuffer.append("ASSESS_ORG_NAME ='").append(orgname).append("',");
		sqlbuBuffer.append("ASSESS_USER_ID ='").append(userid).append("',");
		sqlbuBuffer.append("ASSESS_USER_NAME ='").append(username).append("',");
		sqlbuBuffer.append("ASSESS_START_DATE =").append(start_time).append(",");
		sqlbuBuffer.append("ASSESS_END_DATE =").append(end_time).append(",");
		sqlbuBuffer.append("ASSESS_MODEL_ID ='").append(modelID).append("',");
		sqlbuBuffer.append("CREATE_ORG_ID ='").append(createOrgID).append("',");
		sqlbuBuffer.append("MODIFIER ='").append(creator).append("',");
		sqlbuBuffer.append("spare1 ='").append(spare1).append("',");
		sqlbuBuffer.append("spare2 ='").append(spare2).append("',");
		sqlbuBuffer.append("REMARK ='").append(REMARK).append("'");
		sqlbuBuffer.append(" where  ASSESS_SCORE_ID ='");
		sqlbuBuffer.append(scoreID).append("'");
		sql = sqlbuBuffer.toString();
		log.info("sql=" + sql);
		jdbcTemplate.execute(sql);
		return scoreID;
	}
	@Override
	public String saveElementScore(Map elementMap) {
		// TODO Auto-generated method stub

		return null;
	}

	@Override
	public void saveDetailScore(Map detailMap) {
		// TODO Auto-generated method stub

	}

	@Override
	public String saveElementScore(JSONObject assess, Map scoreMap,
			String plat_score_id) {
		// TODO Auto-generated method stub
		log.info("saveElementScore");
		String elementReportID = "";
		/**
		 * 接收元素级评审分数参数
		 */
		try {
			elementReportID = jdbcDao.generateUUID();
			String assess_id = AssessTools.valueOf(
					assess.getString("assess_id"), "");
			String singel_deduct = AssessTools.valueOf(
					assess.getString("singel_deduct"), "0");
			// String singel_deduct =
			// AssessTools.valueOf(assess.getString("singel_deduct"),
			// "0");//单项扣分
			String FACT_DESC = AssessTools.valueOf(
					assess.getString("FACT_DESC"), "");// //事实描述(记录)
			String start_time = AssessTools
					.valueOf(scoreMap.get("startDate".toLowerCase()),
							AssessTools.getCurrentTime());// ASSESS_START_DATE
			start_time = "to_date('"+ start_time +"','yyyyMMddhh24miss')";
			String end_time = AssessTools.valueOf(scoreMap.get("endDate".toLowerCase()),
					AssessTools.getCurrentTime());// ASSESS_END_DATE
			end_time = "to_date('"+ end_time +"','yyyyMMddhh24miss')";
			String DEDUCT_ACORE_DESC = assess.getString("DEDUCT_ACORE_DESC");// 扣分原因(记录)
			
			String CHECK_SUM_SCORE = AssessTools.valueOf(
					assess.getString("CHECK_SUM_SCORE"), "0");// 检查得分
			String S_STANDARD_SCORE_group = AssessTools.valueOf(
					assess.getString("S_STANDARD_SCORE_group"), "0");// S_STANDARD_SCORE_group
			String S_STANDARD_SCORE = AssessTools.valueOf(
					assess.getString("S_STANDARD_SCORE"), "0");// S_STANDARD_SCORE
			String REMARK = AssessTools.valueOf(assess.getString("REMARK"), "");// REMARK
			String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
			// 审核部门ID
			String orgname = AssessTools.valueOf(scoreMap.get("assess_name"),
			"");// ASSESS_ORG_NAME 审核部门名称
			String createOrgID = AssessTools.valueOf(
					scoreMap.get("createOrgID"), "");// CREATE_ORG_ID
			String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
			String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1
			String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
			String isMark = AssessTools.valueOf(assess.getString("isMark"), "");// spare2
			
			/**
			 * ITEM_FACT_SCORE_VALUE:要素实 际得分 ITEM_SUM_SCORE_VALUE:要素总分
			 * singel_deduct_VALUE:要素扣分 DEDUCT_ITEM_SCORE:要素扣分
			 * ITEM_COMPRE_SCORE: 要素综合得分 ITEM_SCORE_VALUE:单项得分
			 * ITEM_FACT_SCORE_VALUE = ITEM_SUM_SCORE_VALUE -
			 * singel_deduct_VALUE ITEM_COMPRE_SCORE_VALUE =
			 * ITEM_FACT_SCORE_VALUE/ITEM_SUM_SCORE_VALUE*1000
			 */
			double ITEM_SUM_SCORE_VALUE = Double.parseDouble(S_STANDARD_SCORE);
			log.info("ITEM_SUM_SCORE_VALUE=" + ITEM_SUM_SCORE_VALUE);
			double singel_deduct_VALUE = Double.parseDouble(singel_deduct);
			double ITEM_FACT_SCORE_VALUE = ITEM_SUM_SCORE_VALUE
					- singel_deduct_VALUE;
			log.info("ITEM_FACT_SCORE_VALUE=" + ITEM_FACT_SCORE_VALUE);
			double ITEM_COMPRE_SCORE_VALUE = 0;
			if (ITEM_SUM_SCORE_VALUE > 0) {
				ITEM_COMPRE_SCORE_VALUE = ITEM_FACT_SCORE_VALUE
						/ ITEM_SUM_SCORE_VALUE * 1000;
				log.info("ITEM_COMPRE_SCORE_VALUE=" + ITEM_COMPRE_SCORE_VALUE);
			}

			double ITEM_SCORE_VALUE = ITEM_FACT_SCORE_VALUE;
			/**
			 * ELEMENT_SCORE_VALUE:得分 ITEM_FACT_SCORE_VALUE: 要素实 际得分
			 * ITEM_SUM_SCORE_VALUE:要素总分 S_STANDARD_SCORE_group:标准分
			 * ELEMENT_SCORE_VALUE=ITEM_FACT_SCORE_VALUE/ITEM_SUM_SCORE_VALUE*
			 * S_STANDARD_SCORE_group
			 */
			double S_STANDARD_SCORE_group_value = Double
					.parseDouble(S_STANDARD_SCORE_group);
			double ELEMENT_SCORE_VALUE = 0;
			if(ITEM_SUM_SCORE_VALUE>0&&S_STANDARD_SCORE_group_value>0){
				ELEMENT_SCORE_VALUE = ITEM_FACT_SCORE_VALUE
						/ ITEM_SUM_SCORE_VALUE * S_STANDARD_SCORE_group_value;
			}
			
		
				String sql = "";
				StringBuffer sqlbuBuffer = new StringBuffer();
				sqlbuBuffer.append("insert into dms_assess_element_score ");
				sqlbuBuffer.append("(");
				sqlbuBuffer.append("score_id, element_id, plat_score_id, ");
				sqlbuBuffer
						.append("fact_desc, assess_org_id, assess_org_name, ");
				sqlbuBuffer
						.append("deduct_acore_desc, item_deduct_score, item_fact_score, ");
				sqlbuBuffer
						.append("item_compre_score, item_sum_score, item_score, ");
				sqlbuBuffer
						.append(" element_score, check_sum_score,");
				sqlbuBuffer.append("create_org_id, creator, create_date, ");
				sqlbuBuffer.append("modifier, modify_date, bsflag, ");
				sqlbuBuffer.append("remark, spare1, spare2,isMark ");
				sqlbuBuffer.append(")");
				sqlbuBuffer.append(" values ");
				sqlbuBuffer.append("(");

				sqlbuBuffer.append("'").append(elementReportID).append("',");
				sqlbuBuffer.append("'").append(assess_id).append("',");
				sqlbuBuffer.append("'").append(plat_score_id).append("',");

				sqlbuBuffer.append("'").append(FACT_DESC).append("',");
				sqlbuBuffer.append("'").append(orgid).append("',");
				sqlbuBuffer.append("'").append(orgname).append("',");

				sqlbuBuffer.append("'").append(DEDUCT_ACORE_DESC).append("',");
				sqlbuBuffer.append("").append(singel_deduct).append(",");
				sqlbuBuffer.append("").append(ITEM_FACT_SCORE_VALUE)
						.append(",");

				sqlbuBuffer.append("").append(ITEM_COMPRE_SCORE_VALUE)
						.append(",");
				sqlbuBuffer.append("").append(ITEM_SUM_SCORE_VALUE).append(",");
				sqlbuBuffer.append("").append(ITEM_SCORE_VALUE).append(",");

				
				sqlbuBuffer.append("").append(ELEMENT_SCORE_VALUE).append(",");
				sqlbuBuffer.append("").append(CHECK_SUM_SCORE).append(",");

				sqlbuBuffer.append("'").append(createOrgID).append("',");
				sqlbuBuffer.append("'").append(creator).append("',");
				sqlbuBuffer.append("sysdate,");

				sqlbuBuffer.append("'',");
				sqlbuBuffer.append("null,");
				sqlbuBuffer.append("'0',");

				sqlbuBuffer.append("'").append(REMARK).append("',");
				sqlbuBuffer.append("'").append(spare1).append("',");
				sqlbuBuffer.append("'").append(spare2).append("',");
				sqlbuBuffer.append("'").append(isMark).append("'");

				sqlbuBuffer.append(")");
				sql = sqlbuBuffer.toString();
				log.info("sql = " + sql);
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				jdbcTemplate.execute(sql);
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return elementReportID;
	}
	@Override
	public String updateElementScore(JSONObject assess, Map scoreMap,
			String plat_score_id) {
		// TODO Auto-generated method stub
		log.info("updateElementScore");
		String elementScoreID = "";
		/**
		 * 接收元素级评审分数参数
		 */
		try {
			
			elementScoreID = AssessTools.valueOf(
					assess.getString("ele_scoreID"), "");
			String assess_id = AssessTools.valueOf(
					assess.getString("assess_id"), "");
			String singel_deduct = AssessTools.valueOf(
					assess.getString("singel_deduct"), "0");
			String start_time = AssessTools
					.valueOf(scoreMap.get("startDate".toLowerCase()),
							AssessTools.getCurrentTime());// ASSESS_START_DATE
			start_time = "to_date('"+ start_time +"','yyyyMMddhh24miss')";
			String end_time = AssessTools.valueOf(scoreMap.get("endDate".toLowerCase()),
					AssessTools.getCurrentTime());// ASSESS_END_DATE
			end_time = "to_date('"+ end_time +"','yyyyMMddhh24miss')";
			// String singel_deduct =
			// AssessTools.valueOf(assess.getString("singel_deduct"),
			// "0");//单项扣分
			String FACT_DESC = AssessTools.valueOf(
					assess.getString("FACT_DESC"), "");// //事实描述(记录)
			String DEDUCT_ACORE_DESC = assess.getString("DEDUCT_ACORE_DESC");// 扣分原因(记录)
			String ITEM_FACT_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_FACT_SCORE"), "0");// 要素实际得分
			String ITEM_COMPRE_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_COMPRE_SCORE"), "0");// 要素综合得分
			String ITEM_SUM_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_SUM_SCORE"), "0");// 要素总分
			String ITEM_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_SCORE"), "0");// 单项得分
			
			String CHECK_SUM_SCORE = AssessTools.valueOf(
					assess.getString("CHECK_SUM_SCORE"), "0");// 检查得分
			String S_STANDARD_SCORE_group = AssessTools.valueOf(
					assess.getString("S_STANDARD_SCORE_group"), "0");// S_STANDARD_SCORE_group
			String S_STANDARD_SCORE = AssessTools.valueOf(
					assess.getString("S_STANDARD_SCORE"), "0");// S_STANDARD_SCORE
			String REMARK = AssessTools.valueOf(assess.getString("REMARK"), "");// REMARK
			
			String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
			// 审核部门ID
			String orgname = AssessTools.valueOf(scoreMap.get("assess_name"),
			"");// ASSESS_ORG_NAME 审核部门名称
			
			String createOrgID = AssessTools.valueOf(
					scoreMap.get("createOrgID"), "");// CREATE_ORG_ID
			String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
			String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1
			String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
			String isMark = AssessTools.valueOf(assess.getString("isMark"), "");// isMark
			/**
			 * ITEM_FACT_SCORE_VALUE:要素实 际得分 ITEM_SUM_SCORE_VALUE:要素总分
			 * singel_deduct_VALUE:要素扣分 DEDUCT_ITEM_SCORE:要素扣分
			 * ITEM_COMPRE_SCORE: 要素综合得分 ITEM_SCORE_VALUE:单项得分
			 * ITEM_FACT_SCORE_VALUE = ITEM_SUM_SCORE_VALUE -
			 * singel_deduct_VALUE ITEM_COMPRE_SCORE_VALUE =
			 * ITEM_FACT_SCORE_VALUE/ITEM_SUM_SCORE_VALUE*1000
			 */
			double ITEM_SUM_SCORE_VALUE = Double.parseDouble(S_STANDARD_SCORE);
			log.info("ITEM_SUM_SCORE_VALUE=" + ITEM_SUM_SCORE_VALUE);
			double singel_deduct_VALUE = Double.parseDouble(singel_deduct);
			double ITEM_FACT_SCORE_VALUE = ITEM_SUM_SCORE_VALUE
					- singel_deduct_VALUE;
			log.info("ITEM_FACT_SCORE_VALUE=" + ITEM_FACT_SCORE_VALUE);
			double ITEM_COMPRE_SCORE_VALUE = 0;
			if (ITEM_SUM_SCORE_VALUE > 0) {
				ITEM_COMPRE_SCORE_VALUE = ITEM_FACT_SCORE_VALUE
						/ ITEM_SUM_SCORE_VALUE * 1000;
				log.info("ITEM_COMPRE_SCORE_VALUE=" + ITEM_COMPRE_SCORE_VALUE);
			}

			
			/**
			 * ELEMENT_SCORE_VALUE:得分 ITEM_FACT_SCORE_VALUE: 要素实 际得分
			 * ITEM_SUM_SCORE_VALUE:要素总分 S_STANDARD_SCORE_group:标准分
			 * ELEMENT_SCORE_VALUE=ITEM_FACT_SCORE_VALUE/ITEM_SUM_SCORE_VALUE*
			 * S_STANDARD_SCORE_group
			 */
			double S_STANDARD_SCORE_group_value = Double
					.parseDouble(S_STANDARD_SCORE_group);
			double ELEMENT_SCORE_VALUE = 0;
			if(ITEM_SUM_SCORE_VALUE>0&&S_STANDARD_SCORE_group_value>0){
				ELEMENT_SCORE_VALUE = ITEM_FACT_SCORE_VALUE
						/ ITEM_SUM_SCORE_VALUE * S_STANDARD_SCORE_group_value;
			}
			
		
				String sql = "";
				StringBuffer sqlbuBuffer = new StringBuffer();
				sqlbuBuffer.append("update dms_assess_element_score ");
				sqlbuBuffer.append("set FACT_DESC='").append(FACT_DESC).append("',");
				sqlbuBuffer.append("ELEMENT_ID='").append(assess_id).append("',");
				sqlbuBuffer.append("ASSESS_ORG_ID='").append(orgid).append("',");
				sqlbuBuffer.append("ASSESS_ORG_NAME='").append(orgname).append("',");
				sqlbuBuffer.append("DEDUCT_ACORE_DESC='").append(DEDUCT_ACORE_DESC).append("',");
				sqlbuBuffer.append("ITEM_DEDUCT_SCORE='").append(singel_deduct).append("',");
				sqlbuBuffer.append("ITEM_FACT_SCORE='").append(ITEM_FACT_SCORE).append("',");
				sqlbuBuffer.append("ITEM_COMPRE_SCORE='").append(ITEM_COMPRE_SCORE).append("',");
				sqlbuBuffer.append("ITEM_SUM_SCORE='").append(ITEM_SUM_SCORE).append("',");
				sqlbuBuffer.append("ITEM_SCORE='").append(ITEM_SCORE).append("',");
				sqlbuBuffer.append("ELEMENT_SCORE='").append(ELEMENT_SCORE_VALUE).append("',");
				sqlbuBuffer.append(" CHECK_SUM_SCORE='").append(CHECK_SUM_SCORE).append("',");
				sqlbuBuffer.append("CREATE_ORG_ID='").append(createOrgID).append("',");

				sqlbuBuffer.append("REMARK='").append(REMARK).append("',");
				sqlbuBuffer.append("MODIFIER='").append(creator).append("',");
				sqlbuBuffer.append("spare1='").append(spare1).append("',");
				sqlbuBuffer.append("spare2='").append(spare2).append("',");
				sqlbuBuffer.append("isMark='").append(isMark).append("',");
				sqlbuBuffer.append("MODIFY_DATE=sysdate ");
				sqlbuBuffer.append("where  SCORE_ID='").append(elementScoreID).append("'");
				sql = sqlbuBuffer.toString();
				log.info("sql = " + sql);
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				jdbcTemplate.execute(sql);
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return elementScoreID;
	}
	@Override
	public void saveDetailScore(JSONObject detail, Map scoreMap,
			String elementReportID) {
		// TODO Auto-generated method stub
		String ELEMENT_DETAIL_ID;
		try {
			String SCORE_DETAIL_ID = jdbcDao.generateUUID();
			
			ELEMENT_DETAIL_ID = AssessTools.valueOf(
					detail.getString("ELEMENT_DETAIL_ID"), "0");
			
			String CHECK_SCORE = AssessTools.valueOf(
					detail.getString("CHECK_SCORE"), "0");// 检查得分
			String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
			
			String remark = AssessTools.valueOf(scoreMap.get("remark"), "");// remark
			String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1
			String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
			String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
			
			
			String sql = "";
			StringBuffer sqlbuBuffer = new StringBuffer();
			sqlbuBuffer.append("insert into DMS_ASSESS_SCORE_DETAIL ");
			sqlbuBuffer.append("(");
			sqlbuBuffer
					.append("SCORE_DETAIL_ID, ELEMENT_SCORE_ID, ELEMENT_DETAIL_ID,");
			sqlbuBuffer.append("CHECK_SCORE, CREATE_ORG_ID, CREATOR,  ");
			sqlbuBuffer.append("CREATE_DATE, MODIFIER, MODIFY_DATE, ");
			sqlbuBuffer.append("BSFLAG, REMARK, SPARE1,");
			sqlbuBuffer.append("SPARE2");
			sqlbuBuffer.append(")");
			sqlbuBuffer.append(" values ");
			sqlbuBuffer.append("(");

			sqlbuBuffer.append("'").append(SCORE_DETAIL_ID).append("',");
			sqlbuBuffer.append("'").append(elementReportID).append("',");
			sqlbuBuffer.append("'").append(ELEMENT_DETAIL_ID).append("',");

			sqlbuBuffer.append("").append(CHECK_SCORE).append(",");
			sqlbuBuffer.append("'").append(orgid).append("',");
			sqlbuBuffer.append("'").append(creator).append("',");

			sqlbuBuffer.append("sysdate,");
			sqlbuBuffer.append("'',");
			sqlbuBuffer.append("null,");

			sqlbuBuffer.append("").append('0').append(",");
			sqlbuBuffer.append("'").append(remark).append("',");
			sqlbuBuffer.append("'").append(spare1).append("',");

			sqlbuBuffer.append("'").append(spare2).append("'");
			sqlbuBuffer.append(")");
			sql = sqlbuBuffer.toString();
			log.info("sql = " + sql);
			JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
			jdbcTemplate.execute(sql);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}// 关联要素评分子表ID

	}
	@Override
	public void updateDetailScore(JSONObject detail, Map scoreMap,
			String elementReportID) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
				try {
					String  SCORE_DETAIL_ID = AssessTools.valueOf(
							detail.getString("SCORE_DETAIL_ID"), "");
					String CHECK_SCORE = AssessTools.valueOf(
							detail.getString("CHECK_SCORE"), "0");// 检查得分
					String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
					
					String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
					String remark = AssessTools.valueOf(scoreMap.get("remark"), "");// remark
					String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1
					String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
					String sql = "";
					StringBuffer sqlbuBuffer = new StringBuffer();
					sqlbuBuffer.append("update DMS_ASSESS_SCORE_DETAIL ");
					sqlbuBuffer.append("set CHECK_SCORE= '").append(CHECK_SCORE).append("',");
					sqlbuBuffer.append("CREATE_ORG_ID= '").append(orgid).append("',");
					sqlbuBuffer.append("MODIFIER= '").append(creator).append("',");
					sqlbuBuffer.append("spare1= '").append(spare1).append("',");
					sqlbuBuffer.append("spare2= '").append(spare2).append("',");
					sqlbuBuffer.append("remark= '").append(remark).append("',");
					sqlbuBuffer.append("MODIFY_DATE= sysdate");
					sqlbuBuffer.append(" where SCORE_DETAIL_ID='").append(SCORE_DETAIL_ID).append("'");
					
					sql = sqlbuBuffer.toString();
					log.info("sql = " + sql);
					JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
					jdbcTemplate.execute(sql);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}// 关联要素评分子表ID
		
	}
	@Override
	public Map<String, Object> findScoreReportByID(String scoreID) {
		// TODO Auto-generated method stub
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select model.MODEL_NAME as MODEL_NAME,model.MODEL_ID as modelID,");
		querySql.append("model.MODEL_TYPE as MODEL_TYPE, ");
		querySql.append("model.MODEL_TITLE as MODEL_TITLE, ");
		querySql.append("dms.ASSESS_SCORE_ID as scoreID, ");
		querySql.append("dms.ASSESS_ORG_ID as ASSESS_ORG_ID, ");
		querySql.append("dms.ASSESS_ORG_NAME as ASSESS_ORG_NAME, ");
		querySql.append("dms.ASSESS_USER_ID as ASSESS_USER_ID, ");
		querySql.append("dms.ASSESS_USER_NAME as ASSESS_USER_NAME, ");
		querySql.append("dms.ASSESS_START_DATE as ASSESS_START_DATE, ");
		querySql.append("dms.ASSESS_END_DATE as ASSESS_END_DATE, ");
		querySql.append("dms.CREATE_ORG_ID as CREATE_ORG_ID, ");
		querySql.append("dms.CREATOR as CREATOR, ");
		querySql.append("dms.CREATE_DATE as CREATE_DATE, ");
		querySql.append("dms.REMARK as REMARK, ");
		querySql.append("dms.SPARE1 as SPARE1, ");
		querySql.append("dms.SPARE2 as SPARE2 ");
		querySql.append("from dms_assess_plat_score dms  ");
		querySql.append("left join comm_org_information info ");
		querySql.append("on dms.create_org_id = info.org_id ");
		querySql.append("left join comm_human_employee emp ");
		querySql.append("on dms.CREATOR = emp.employee_id and emp.bsflag = '0'");
		querySql.append("left join DMS_ASSESS_PLAT_MODEL model ");
		querySql.append("on dms.ASSESS_MODEL_ID = model.MODEL_ID ");
		querySql.append("where dms.ASSESS_SCORE_ID = '");
		querySql.append(scoreID);
		querySql.append("' ");
		querySql.append(" order by create_date desc");
		sql = querySql.toString();
		//log.info("sql = " + sql);
		Map<String, Object> map = pureDao.queryRecordBySQL(sql);
		return map;
	}

	@Override
	public List<Map<String, Object>> findElementScoreList(String scoreID,
			PageModel page) {
		// TODO Auto-generated method stub
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dms.SCORE_ID as SCORE_ID,");
		querySql.append("dms.ELEMENT_ID as assess_id, ");
		querySql.append("dms.PLAT_SCORE_ID as PLAT_SCORE_ID, ");
		querySql.append("dms.FACT_DESC as FACT_DESC, ");
		querySql.append("dms.ASSESS_ORG_ID as ASSESS_ORG_ID, ");
		querySql.append("dms.ASSESS_ORG_NAME as ASSESS_ORG_NAME, ");
		querySql.append("dms.DEDUCT_ACORE_DESC as DEDUCT_ACORE_DESC, ");
		querySql.append("dms.ITEM_DEDUCT_SCORE as ITEM_DEDUCT_SCORE, ");
		querySql.append("dms.ITEM_FACT_SCORE as ITEM_FACT_SCORE, ");
		querySql.append("dms.ITEM_COMPRE_SCORE as ITEM_COMPRE_SCORE, ");
		querySql.append("dms.ITEM_SUM_SCORE as ITEM_SUM_SCORE, ");
		querySql.append("dms.ITEM_SCORE as ITEM_SCORE, ");
		querySql.append("dms.DEDUCT_ITEM_SCORE as DEDUCT_ITEM_SCORE, ");
		querySql.append("dms.ELEMENT_SCORE as ELEMENT_SCORE, ");
		querySql.append("dms.CHECK_SUM_SCORE as CHECK_SUM_SCORE, ");
		querySql.append("dms.CREATE_ORG_ID as CREATE_ORG_ID, ");
		querySql.append("dms.CREATOR as CREATOR, ");
		querySql.append("dms.CREATE_DATE as CREATE_DATE, ");
		querySql.append("dms.MODIFIER as MODIFIER, ");
		querySql.append("dms.MODIFY_DATE as MODIFY_DATE, ");
		querySql.append("dms.BSFLAG as BSFLAG, ");
		querySql.append("dms.REMARK as REMARK, ");
		querySql.append("dms.SPARE1 as SPARE1, ");
		querySql.append("dms.SPARE2 as SPARE2, ");
		querySql.append("dms.isMark as isMark, ");
		querySql.append("ele.ASSESS_NAME as ASSESS_NAME, ");
		querySql.append("ele.ASSESS_CONTENT as ASSESS_CONTENT ");
		querySql.append("from DMS_ASSESS_ELEMENT_SCORE dms  ");
		querySql.append("left join comm_org_information info ");
		querySql.append("on dms.create_org_id = info.org_id ");
		querySql.append("left join comm_human_employee emp ");
		querySql.append("on dms.CREATOR = emp.employee_id and emp.bsflag = '0'");
		querySql.append("left join DMS_ASSESS_PLAT_ELEMENT ele ");
		querySql.append("on dms.ELEMENT_ID = ele.ASSESS_ID ");
		querySql.append("where dms.PLAT_SCORE_ID = '");
		querySql.append(scoreID);
		querySql.append("' ");
		querySql.append(" order by ele.ASSESS_SEQ");
		sql = querySql.toString();
		log.info("sql=" + sql);
		page = pureDao.queryRecordsBySQL(sql, page);
		List list = page.getData();
		return list;
	}

	@Override
	public List<Map<String, Object>> findElementDetailScoreByEleID(
			String eleScoreID, String DETAIL_FLAG,PageModel page) {
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select score.SCORE_DETAIL_ID SCORE_DETAIL_ID, ");
		querySql.append("score.CHECK_SCORE CHECK_SCORE, ");
		querySql.append("score.ELEMENT_SCORE_ID ELEMENT_SCORE_ID, ");
		querySql.append("score.ELEMENT_DETAIL_ID ELEMENT_DETAIL_ID, ");
		querySql.append("score.SPARE1 SPARE1, ");
		querySql.append("score.SPARE2 SPARE2, ");
		querySql.append("score.REMARK REMARK, ");
		querySql.append("dms.CHECK_ITEM CHECK_ITEM, ");
		querySql.append("dms.STANDARD_SCORE STANDARD_SCORE, ");
		querySql.append("dms.CHECK_CONTENT CHECK_CONTENT from  ");
		querySql.append("DMS_ASSESS_SCORE_DETAIL score ");
		querySql.append("left join dms_assess_element_detail dms ");
		querySql.append("on score.ELEMENT_DETAIL_ID=dms.DETAIL_ID ");
		querySql.append("where score.ELEMENT_SCORE_ID = '");
		querySql.append(eleScoreID).append("' ");
		querySql.append("and dms.DETAIL_FLAG='");
		querySql.append(DETAIL_FLAG).append("' ");
		sql = querySql.toString();
		//log.info("sql=" + sql);
		page = pureDao.queryRecordsBySQL(sql, page);
		List list = page.getData();
		
		return list;
	}

	@Override
	public List<Map<String, Object>> saveScoreMarkList(String eleScoreIDs,
			String platID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List findMarkedElementScoreList(String scoreID, PageModel page) {
		// TODO Auto-generated method stub
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dms.SCORE_ID as SCORE_ID,");
		querySql.append("dms.ELEMENT_ID as assess_id, ");
		querySql.append("dms.PLAT_SCORE_ID as PLAT_SCORE_ID, ");
		querySql.append("dms.FACT_DESC as FACT_DESC, ");
		querySql.append("dms.ASSESS_ORG_ID as ASSESS_ORG_ID, ");
		querySql.append("dms.ASSESS_ORG_NAME as ASSESS_ORG_NAME, ");
		querySql.append("dms.DEDUCT_ACORE_DESC as DEDUCT_ACORE_DESC, ");
		querySql.append("dms.ITEM_DEDUCT_SCORE as ITEM_DEDUCT_SCORE, ");
		querySql.append("dms.ITEM_FACT_SCORE as ITEM_FACT_SCORE, ");
		querySql.append("dms.ITEM_COMPRE_SCORE as ITEM_COMPRE_SCORE, ");
		querySql.append("dms.ITEM_SUM_SCORE as ITEM_SUM_SCORE, ");
		querySql.append("dms.ITEM_SCORE as ITEM_SCORE, ");
		querySql.append("dms.DEDUCT_ITEM_SCORE as DEDUCT_ITEM_SCORE, ");
		querySql.append("dms.ELEMENT_SCORE as ELEMENT_SCORE, ");
		querySql.append("dms.CHECK_SUM_SCORE as CHECK_SUM_SCORE, ");
		querySql.append("dms.CREATE_ORG_ID as CREATE_ORG_ID, ");
		querySql.append("dms.CREATOR as CREATOR, ");
		querySql.append("dms.CREATE_DATE as CREATE_DATE, ");
		querySql.append("dms.MODIFIER as MODIFIER, ");
		querySql.append("dms.MODIFY_DATE as MODIFY_DATE, ");
		querySql.append("dms.BSFLAG as BSFLAG, ");
		querySql.append("dms.REMARK as REMARK, ");
		querySql.append("dms.SPARE1 as SPARE1, ");
		querySql.append("dms.SPARE2 as SPARE2, ");
		querySql.append("dms.isMark as isMark, ");
		querySql.append("ele.ASSESS_NAME as ASSESS_NAME, ");
		querySql.append("ele.ASSESS_CONTENT as ASSESS_CONTENT ");
		querySql.append("from DMS_ASSESS_ELEMENT_SCORE dms  ");
		querySql.append("left join comm_org_information info ");
		querySql.append("on dms.create_org_id = info.org_id ");
		querySql.append("left join comm_human_employee emp ");
		querySql.append("on dms.CREATOR = emp.employee_id and emp.bsflag = '0'");
		querySql.append("left join DMS_ASSESS_PLAT_ELEMENT ele ");
		querySql.append("on dms.ELEMENT_ID = ele.ASSESS_ID ");
		querySql.append("where dms.PLAT_SCORE_ID = '");
		querySql.append(scoreID);
		querySql.append("' ");
		querySql.append("and  dms.isMark='1' ");
		querySql.append(" order by ele.ASSESS_SEQ");
		sql = querySql.toString();
		log.info("sql=" + sql);
		page = pureDao.queryRecordsBySQL(sql, page);
		List list = page.getData();
		return list;
	}

	@Override
	public List findAllDetailScoreListByPlatScoreID(String flag,String scoreID) {
		String methodID = "findAllDetailScoreListByPlatScoreID";
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select score.SCORE_DETAIL_ID SCORE_DETAIL_ID, ");
		querySql.append("score.CHECK_SCORE CHECK_SCORE, ");
		querySql.append("score.ELEMENT_DETAIL_ID ELEMENT_DETAIL_ID,");
		querySql.append(" score.ELEMENT_SCORE_ID ELEMENT_SCORE_ID,  ");
		
		querySql.append("score.REMARK REMARK, ");
		querySql.append("score.SPARE1 SPARE1,");
		querySql.append(" score.SPARE2 SPARE2,  ");
		
		querySql.append(" dms.CHECK_ITEM CHECK_ITEM,  ");
		querySql.append("dms.STANDARD_SCORE STANDARD_SCORE,  ");
		querySql.append(" dms.CHECK_CONTENT CHECK_CONTENT ");
		querySql.append(" from  DMS_ASSESS_SCORE_DETAIL score ");
		querySql.append("left join dms_assess_element_detail dms ");
		querySql.append("on score.ELEMENT_DETAIL_ID=dms.DETAIL_ID ");
		querySql.append(" left join DMS_ASSESS_ELEMENT_SCORE eScore on ");
		querySql.append(" score.ELEMENT_SCORE_ID=eScore.SCORE_ID ");
		querySql.append("where ");
		querySql.append("dms.DETAIL_FLAG='");
		querySql.append(flag).append("' ");
		querySql.append(" and eScore.PLAT_SCORE_ID='");
		querySql.append(scoreID).append("' ");
		sql = querySql.toString();
		log.info(methodID + "sql=" + sql);
		List list = pureDao.queryRecords(sql);
		return list;
	}

	@Override
	public String addSuggestionForElementScore(JSONObject assess,
			Map<String, Object> scoreMap, String scoreID) {
		String methodID = "addSuggestionForElementScore";
		log.info(methodID);
		String elementScoreID = "";
		/**
		 * 接收元素级评审分数参数
		 */
		try {
			
			elementScoreID = AssessTools.valueOf(
					assess.getString("ele_scoreID"), "");
			String assess_id = AssessTools.valueOf(
					assess.getString("assess_id"), "");
			String singel_deduct = AssessTools.valueOf(
					assess.getString("singel_deduct"), "0");
			String start_time = AssessTools
					.valueOf(scoreMap.get("startDate".toLowerCase()),
							AssessTools.getCurrentTime());// ASSESS_START_DATE
			start_time = "to_date('"+ start_time +"','yyyyMMddhh24miss')";
			String end_time = AssessTools.valueOf(scoreMap.get("endDate".toLowerCase()),
					AssessTools.getCurrentTime());// ASSESS_END_DATE
			end_time = "to_date('"+ end_time +"','yyyyMMddhh24miss')";
			// String singel_deduct =
			// AssessTools.valueOf(assess.getString("singel_deduct"),
			// "0");//单项扣分
			String FACT_DESC = AssessTools.valueOf(
					assess.getString("FACT_DESC"), "");// //事实描述(记录)
			String DEDUCT_ACORE_DESC = assess.getString("DEDUCT_ACORE_DESC");// 扣分原因(记录)
			String ITEM_FACT_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_FACT_SCORE"), "0");// 要素实际得分
			String ITEM_COMPRE_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_COMPRE_SCORE"), "0");// 要素综合得分
			String ITEM_SUM_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_SUM_SCORE"), "0");// 要素总分
			String ITEM_SCORE = AssessTools.valueOf(
					assess.getString("ITEM_SCORE"), "0");// 单项得分
			
			String CHECK_SUM_SCORE = AssessTools.valueOf(
					assess.getString("CHECK_SUM_SCORE"), "0");// 检查得分
			String S_STANDARD_SCORE_group = AssessTools.valueOf(
					assess.getString("S_STANDARD_SCORE_group"), "0");// S_STANDARD_SCORE_group
			String S_STANDARD_SCORE = AssessTools.valueOf(
					assess.getString("S_STANDARD_SCORE"), "0");// S_STANDARD_SCORE
			String REMARK = AssessTools.valueOf(assess.getString("REMARK"), "");// REMARK
			String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
			// 审核部门ID
			String orgname = AssessTools.valueOf(scoreMap.get("assess_name"),
			"");// ASSESS_ORG_NAME 审核部门名称
			
			String createOrgID = AssessTools.valueOf(
					scoreMap.get("createOrgID"), "");// CREATE_ORG_ID
			String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
			String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1
			String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
			String isMark = AssessTools.valueOf(assess.getString("isMark"), "");// isMark
			/**
			 * ITEM_FACT_SCORE_VALUE:要素实 际得分 ITEM_SUM_SCORE_VALUE:要素总分
			 * singel_deduct_VALUE:要素扣分 DEDUCT_ITEM_SCORE:要素扣分
			 * ITEM_COMPRE_SCORE: 要素综合得分 ITEM_SCORE_VALUE:单项得分
			 * ITEM_FACT_SCORE_VALUE = ITEM_SUM_SCORE_VALUE -
			 * singel_deduct_VALUE ITEM_COMPRE_SCORE_VALUE =
			 * ITEM_FACT_SCORE_VALUE/ITEM_SUM_SCORE_VALUE*1000
			 */
			double ITEM_SUM_SCORE_VALUE = Double.parseDouble(S_STANDARD_SCORE);
			log.info("ITEM_SUM_SCORE_VALUE=" + ITEM_SUM_SCORE_VALUE);
			double singel_deduct_VALUE = Double.parseDouble(singel_deduct);
			double ITEM_FACT_SCORE_VALUE = ITEM_SUM_SCORE_VALUE
					- singel_deduct_VALUE;
			log.info("ITEM_FACT_SCORE_VALUE=" + ITEM_FACT_SCORE_VALUE);
			double ITEM_COMPRE_SCORE_VALUE = 0;
			if (ITEM_SUM_SCORE_VALUE > 0) {
				ITEM_COMPRE_SCORE_VALUE = ITEM_FACT_SCORE_VALUE
						/ ITEM_SUM_SCORE_VALUE * 1000;
				log.info("ITEM_COMPRE_SCORE_VALUE=" + ITEM_COMPRE_SCORE_VALUE);
			}

			
			/**
			 * ELEMENT_SCORE_VALUE:得分 ITEM_FACT_SCORE_VALUE: 要素实 际得分
			 * ITEM_SUM_SCORE_VALUE:要素总分 S_STANDARD_SCORE_group:标准分
			 * ELEMENT_SCORE_VALUE=ITEM_FACT_SCORE_VALUE/ITEM_SUM_SCORE_VALUE*
			 * S_STANDARD_SCORE_group
			 */
			double S_STANDARD_SCORE_group_value = Double
					.parseDouble(S_STANDARD_SCORE_group);
			double ELEMENT_SCORE_VALUE = 0;
			if(ITEM_SUM_SCORE_VALUE>0&&S_STANDARD_SCORE_group_value>0){
				ELEMENT_SCORE_VALUE = ITEM_FACT_SCORE_VALUE
						/ ITEM_SUM_SCORE_VALUE * S_STANDARD_SCORE_group_value;
			}
			
		
				String sql = "";
				StringBuffer sqlbuBuffer = new StringBuffer();
				sqlbuBuffer.append("update dms_assess_element_score ");
				sqlbuBuffer.append("set FACT_DESC='").append(FACT_DESC).append("',");
				sqlbuBuffer.append("ELEMENT_ID='").append(assess_id).append("',");
				sqlbuBuffer.append("ASSESS_ORG_ID='").append(orgid).append("',");
				sqlbuBuffer.append("ASSESS_ORG_NAME='").append(orgname).append("',");
				sqlbuBuffer.append("DEDUCT_ACORE_DESC='").append(DEDUCT_ACORE_DESC).append("',");
				sqlbuBuffer.append("ITEM_DEDUCT_SCORE='").append(singel_deduct).append("',");
				sqlbuBuffer.append("ITEM_FACT_SCORE='").append(ITEM_FACT_SCORE).append("',");
				sqlbuBuffer.append("ITEM_COMPRE_SCORE='").append(ITEM_COMPRE_SCORE).append("',");
				sqlbuBuffer.append("ITEM_SUM_SCORE='").append(ITEM_SUM_SCORE).append("',");
				sqlbuBuffer.append("ITEM_SCORE='").append(ITEM_SCORE).append("',");
				sqlbuBuffer.append("ELEMENT_SCORE='").append(ELEMENT_SCORE_VALUE).append("',");
				sqlbuBuffer.append(" CHECK_SUM_SCORE='").append(CHECK_SUM_SCORE).append("',");
				sqlbuBuffer.append("CREATE_ORG_ID='").append(createOrgID).append("',");

				sqlbuBuffer.append("REMARK='").append(REMARK).append("',");
				sqlbuBuffer.append("MODIFIER='").append(creator).append("',");
				sqlbuBuffer.append("spare1='").append(spare1).append("',");
				sqlbuBuffer.append("spare2='").append(spare2).append("',");
				sqlbuBuffer.append("isMark='").append(isMark).append("',");
				sqlbuBuffer.append("MODIFY_DATE=sysdate ");
				sqlbuBuffer.append("where  SCORE_ID='").append(elementScoreID).append("'");
				sql = sqlbuBuffer.toString();
				log.info("sql = " + sql);
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				jdbcTemplate.execute(sql);
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return elementScoreID;
	}

	@Override
	public String addSuggestionForPlatScore(Map<String, Object> scoreMap) {
		// TODO Auto-generated method stub
		log.info("addSuggestionForPlatScore");
		/**
		 * 接收模板级评审分数参数
		 */
		String scoreID = AssessTools.valueOf(scoreMap.get("scoreID"), "");// ASSESS_SCORE_ID
		String modelID = AssessTools.valueOf(scoreMap.get("modelID"), "");// ASSESS_MODEL_ID
		
		log.info("scoreID=" + scoreID);
		String orgid = AssessTools.valueOf(scoreMap.get("assess_org_id"), "");// ASSESS_ORG_ID
																				// 审核部门ID
		String orgname = AssessTools.valueOf(scoreMap.get("assess_name"),
				"");// ASSESS_ORG_NAME 审核部门名称
		String userid = AssessTools.valueOf(scoreMap.get("employee_id".toLowerCase()), "");// ASSESS_USER_ID
		String username = AssessTools.valueOf(scoreMap.get("employee_name".toLowerCase()),
				"");// ASSESS_USER_NAME
		String start_time = AssessTools
				.valueOf(scoreMap.get("startDate".toLowerCase()),
						AssessTools.getCurrentTime());// ASSESS_START_DATE
		start_time = "to_date('"+ start_time +"','yyyyMMddhh24miss')";
		String end_time = AssessTools.valueOf(scoreMap.get("endDate".toLowerCase()),
				AssessTools.getCurrentTime());// ASSESS_END_DATE
		end_time = "to_date('"+ end_time +"','yyyyMMddhh24miss')";
		String createOrgID = AssessTools.valueOf(scoreMap.get("CREATE_ORG_ID"),
				"");// CREATE_ORG_ID
		String creator = AssessTools.valueOf(scoreMap.get("creator"), "");// CREATOR
		String REMARK = AssessTools.valueOf(scoreMap.get("REMARK_plat"), "");// remark
		log.info("REMARK=" + REMARK);
		String spare1 = AssessTools.valueOf(scoreMap.get("spare1"), "");// spare1 整改意见
		String spare2 = AssessTools.valueOf(scoreMap.get("spare2"), "");// spare2
		String sql = "";
		StringBuffer sqlbuBuffer = new StringBuffer();
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		sqlbuBuffer.append("update dms_assess_plat_score ");
		sqlbuBuffer.append("set ASSESS_ORG_ID ='").append(orgid).append("',");
		sqlbuBuffer.append("ASSESS_ORG_NAME ='").append(orgname).append("',");
		sqlbuBuffer.append("ASSESS_USER_ID ='").append(userid).append("',");
		sqlbuBuffer.append("ASSESS_USER_NAME ='").append(username).append("',");
		sqlbuBuffer.append("ASSESS_START_DATE =").append(start_time).append(",");
		sqlbuBuffer.append("ASSESS_END_DATE =").append(end_time).append(",");
		sqlbuBuffer.append("ASSESS_MODEL_ID ='").append(modelID).append("',");
		sqlbuBuffer.append("CREATE_ORG_ID ='").append(createOrgID).append("',");
		sqlbuBuffer.append("MODIFIER ='").append(creator).append("',");
		sqlbuBuffer.append("spare1 ='").append(spare1).append("',");
		sqlbuBuffer.append("spare2 ='").append(spare2).append("',");
		sqlbuBuffer.append("REMARK ='").append(REMARK).append("'");
		sqlbuBuffer.append(" where  ASSESS_SCORE_ID ='");
		sqlbuBuffer.append(scoreID).append("'");
		sql = sqlbuBuffer.toString();
		log.info("sql=" + sql);
		jdbcTemplate.execute(sql);
		return scoreID;
	}

	

}

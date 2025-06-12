package com.bgp.gms.service.op.srv;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.poi.xssf.usermodel.*;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.util.OPCaculator;
import com.bgp.gms.service.op.util.OPCommonUtil;
import com.bgp.gms.service.op.srv.ProjectEvaluationUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class ProjectEvaluationSrv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	/**
	 * 公共 --> 保存
	 * author  xiaqiuyu
	 * date 2012-6-6
	 */
	public ISrvMsg saveValuesBySql(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sqls = reqDTO.getValue("sql");
		System.out.println(sqls);
		saveValuesBySql(sqls);
		return msg;
	}
	public void saveValuesBySql(String sqls){
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
	}
	/**项目评价的各项指标树，无项目关联
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 */
	public ISrvMsg getTemplateTree(ISrvMsg reqDTO) throws Exception{
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		String node = reqDTO.getValue("node");
		if(node == null || node.equals("root")){
			sb  = new StringBuffer();
			sb.append("select t.evaluate_template_id id ,t.evaluate_name ,t.evaluate_weight ,t.evaluate_standard ,t.formula_content,")
			.append(" case t.is_leaf when '1' then 'true' else 'false' end leaf ,t.is_leaf ")
			.append(" from BGP_OP_EVALUATE_TEMPLATE t ")
			.append(" where t.parent_id ='ROOT'");

			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}else{
			sb  = new StringBuffer();
			sb.append("select t.evaluate_template_id id ,t.evaluate_name ,t.evaluate_weight ,t.evaluate_standard ,t.formula_content,")
			.append(" case t.is_leaf when '1' then 'true' else 'false' end leaf ,t.is_leaf ")
			.append(" from BGP_OP_EVALUATE_TEMPLATE t ")
			.append(" where t.parent_id ='").append(node).append("'");

			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	public String getCodingCodeId(String project_info_no){
		String coding_code_id = "5000400001000000001";
		
		StringBuffer sb  = new StringBuffer("select t.evaluate_project_id from bgp_op_evaluate_project t ")
		.append("where t.project_info_no ='").append(project_info_no).append("'");
		List list = pureJdbcDao.queryRecords(sb.toString());
		
		return coding_code_id;
	}
	/**初始化该项目的项目评价指标信息
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 */
	public ISrvMsg initTemplateToProject(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String user_id = user.getUserId();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no = user.getProjectInfoNo();
		}
		StringBuffer sb  = new StringBuffer("select t.evaluate_project_id from bgp_op_evaluate_project t ")
		.append(" where t.project_info_no ='").append(project_info_no).append("'");
		List list = pureJdbcDao.queryRecords(sb.toString());
		if(list==null || list.size()<=0){
			String coding_code_id = getCodingCodeId(project_info_no);
			sb  = new StringBuffer();
			sb.append("select t.evaluate_template_id ,t.evaluate_name ,t.parent_id ,t.evaluate_weight ,t.formula_content ,t.cal_desc ,")
			.append(" v.base_value ,t.is_leaf from bgp_op_evaluate_template t")
			.append(" join bgp_op_evaluate_template_val v on t.evaluate_template_id = v.evaluate_template_id ")
			.append(" where t.is_leaf ='1' and v.coding_code_id ='").append(coding_code_id).append("'");
			list = pureJdbcDao.queryRecords(sb.toString());
			sb = new StringBuffer(); 
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(map!=null){
					String template_id = (String)map.get("evaluate_template_id");
					String parent_id = (String)map.get("parent_id");
					String evaluate_weight = (String)map.get("evaluate_weight");
					String formula_content = (String)map.get("formula_content");
					String cal_desc = (String)map.get("cal_desc");
					String base_value = (String)map.get("base_value");
					String isleaf = (String)map.get("is_leaf");
					sb.append("insert into bgp_op_evaluate_project(evaluate_project_id,template_id,parent_id,evaluate_weight,formula_content,")
					.append("cal_desc,project_info_no,org_id,org_subjection_id,base_value,creator,create_date,modifi_date,isleaf)values(")
					.append("(select lower(sys_guid()) from dual), '").append(template_id).append("','").append(parent_id).append("','")
					.append(evaluate_weight).append("','").append(formula_content).append("','").append(cal_desc).append("','")
					.append(project_info_no).append("','").append(org_id).append("','").append(org_subjection_id).append("','")
					.append(base_value).append("','").append(user_id).append("',sysdate,sysdate,'").append(isleaf).append("');");
				}
			}
			saveValuesBySql(sb.toString());
		}
		return msg;
	}
	/**项目评价的各项指标树，项目关联
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 */
	public ISrvMsg getProjectTemplateTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		String node = reqDTO.getValue("node");
		if(node == null || node.equals("root")){
			sb  = new StringBuffer();
			sb.append("select 'ROOT' id ,'项目评价结果' evaluate_name ,'100' evaluate_weight ,'' formula_content ,'' actual_value ,")
			.append(" round(sum(p.evaluate_score),3) evaluate_score,'' base_value ,'false' leaf ,'0' is_leaf")
			.append(" from bgp_op_evaluate_project p ")
			.append(" where p.project_info_no ='").append(project_info_no).append("'");
			
			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}else{
			sb  = new StringBuffer();
			sb.append("select tt.* ,case when tt.evaluation is null then round(tt.score,3) else tt.evaluation end evaluate_score from(")
			.append(" select t.evaluate_template_id id ,t.evaluate_name ,t.evaluate_weight ,p.formula_content ,round(p.actual_value ,3) actual_value,")
			.append(" (select round(sum(ep.evaluate_score),3) from bgp_op_evaluate_template et")
			.append(" left join bgp_op_evaluate_project ep on et.evaluate_template_id = ep.template_id ")
			.append(" and ep.project_info_no ='").append(project_info_no).append("'")
			.append(" start with et.parent_id = t.evaluate_template_id")
			.append(" connect by prior et.evaluate_template_id = et.parent_id) evaluation ,")
			.append(" p.evaluate_score score,p.base_value ,case t.is_leaf when '1' then 'true' else 'false' end leaf ,t.is_leaf")
			.append(" from bgp_op_evaluate_template t")
			.append(" left join bgp_op_evaluate_project p on t.evaluate_template_id = p.template_id ")
			.append(" and t.parent_id = p.parent_id and p.project_info_no ='").append(project_info_no).append("'")
			.append(" where t.parent_id ='").append(node).append("' order by t.evaluate_template_id asc) tt");

			List root = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	public ISrvMsg getProjectValue(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null){
			project_info_no = user.getProjectInfoNo();
		}
		if (project_info_no != null && !"".equals(project_info_no)) {
			ProjectEvaluationUtil util = new ProjectEvaluationUtil();
			StringBuffer sb = new StringBuffer();
			Map map = new HashMap();
			map = util.getFormulaValueIntoMap(map ,project_info_no);
			StringBuffer sql = new StringBuffer("select t.evaluate_template_id ,t.evaluate_name ,t.evaluate_weight ,t.cal_desc formula_content ,")
			.append(" t.low_score ,t.low_range ,t.high_score ,t.high_range ,v.base_value from bgp_op_evaluate_template t ")
			.append(" join bgp_op_evaluate_template_val v on t.evaluate_template_id = v.evaluate_template_id")
			.append(" where t.is_leaf='1' and v.coding_code_id ='5000400001000000001'");
			List list = pureJdbcDao.queryRecords(sql.toString());
			for(int i=0;list!=null && i<list.size();i++){
			//for(int i=0;list!=null && i<1;i++){
				Map listMap = (Map)list.get(i);
				if(listMap!=null){
					String evaluate_template_id = (String)listMap.get("evaluate_template_id");
					String formula_content = (String)listMap.get("formula_content");
					formula_content = changeFormulaContent(map ,formula_content);
					double actual = OPCaculator.excute(formula_content);
					double evaluation = 0;
					String evaluate_weight = (String)listMap.get("evaluate_weight");
					String base_value = (String)listMap.get("base_value");
					System.out.println((String)listMap.get("formula_content")+"****"+actual+"****"+base_value);
					String low_score = (String)listMap.get("low_score");
					String low_range = (String)listMap.get("low_range");
					String high_score = (String)listMap.get("high_score");
					String high_range = (String)listMap.get("high_range");
					double result = actual-Double.parseDouble(base_value);
					if(result < 0){
						if(low_range!=null && low_range.equals("0")){
							evaluation = getEvaluation(evaluate_weight ,low_score ,-result*100);
						}else if(low_range!=null && low_range.equals("3")){
							if(result >= -0.03){
								evaluation = Double.parseDouble(evaluate_weight);
							}else{
								evaluation = getEvaluation(evaluate_weight ,low_score ,(-result-0.03)*100);
							}
						}
					}else if(result > 0){
						if(high_range!=null && high_range.equals("0")){
							evaluation = getEvaluation(evaluate_weight ,high_score ,result*100);
						}else if(high_range!=null && high_range.equals("3")){
							if(result <= 0.03){
								evaluation = Double.parseDouble(evaluate_weight);
							}else{
								evaluation = getEvaluation(evaluate_weight ,high_score ,(result-0.03)*100);
							}
						}
					}else{
						evaluation = Double.parseDouble(evaluate_weight);
					}
					sb.append("update bgp_op_evaluate_project t set t.actual_value='").append(actual).append("' ,")
					.append(" t.evaluate_score='").append(evaluation).append("' where t.template_id='")
					.append(evaluate_template_id).append("' and t.project_info_no='").append(project_info_no).append("';");
					
				}
			}
			saveValuesBySql(sb.toString());
		}
		return msg;
	}
	public String changeFormulaContent(Map map ,String formula_content){
		while(formula_content.indexOf("{")!=-1){
			String code = formula_content.substring(formula_content.indexOf("{"), formula_content.indexOf("}")-(-1));
			String value = String.valueOf(map.get(code));
			code = code.replaceAll("\\{", "");
			code = code.replaceAll("\\}", "");
			formula_content = formula_content.replaceFirst(code, value);
			formula_content = formula_content.replaceFirst("\\{", "");
			formula_content = formula_content.replaceFirst("\\}", "");
		}
		return formula_content;
	}
	public double getEvaluation(String evaluate_weight ,String lower_high,double result){
		double score = 0;
		if(lower_high!=null && lower_high.indexOf("-")!=-1){
			lower_high = lower_high.substring(1);
			score = score -Double.parseDouble(lower_high);
		}else if(lower_high!=null && lower_high.indexOf("-")==-1){
			score = Double.parseDouble(lower_high);
		}
		double final_score = score * result;
		if(final_score > Double.parseDouble(evaluate_weight)/2){
			final_score = Double.parseDouble(evaluate_weight)/2;
		}else if(final_score < -Double.parseDouble(evaluate_weight)){
			final_score = -Double.parseDouble(evaluate_weight);
		}
		return Double.parseDouble(evaluate_weight)+ final_score;
	}
	
	
	
	
	
	public void justForSave(String project_info_no){
		Map<String, Double> mapBasicInfo = new HashMap<String, Double>();
		StringBuffer sb = new StringBuffer();
		/* 4、职工比重指标 = 实际职工人数/实际员工人数 */
		sb.append("select (select count(*) from view_human_project_relation t where (t.EMPLOYEE_GZ='0110000019000000001' or t.EMPLOYEE_GZ='0110000019000000002')")
		.append(" and t.project_info_no = '").append(project_info_no).append("') actual,(select count(*) from view_human_project_relation t ")
		.append(" where (t.EMPLOYEE_GZ='0110000059000000005' or t.EMPLOYEE_GZ='0110000019000000001' or t.employee_gz='0110000019000000002') and t.project_info_no = '")
		.append(project_info_no).append("') total from dual");
		Map map = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			String actual = (String) map.get("actual");
			String total = (String) map.get("total");
		}
		/* 实际完成炮数  */
		sb = new StringBuffer();
		sb.append("select sum(t.daily_acquire_sp_num)-(-sum(t.daily_jp_acquire_shot_num))-(-sum(t.daily_qq_acquire_shot_num)) sp_num from gp_ops_daily_report t")
		.append(" where t.bsflag ='0' and t.project_info_no = '").append(project_info_no).append("'");
		map = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			String sp_num = (String) map.get("sp_num");
		}
		/* 实际检波点数 */
		sb = new StringBuffer();
		sb.append("select sum(t.daily_survey_geophone_num) geophone_num from gp_ops_daily_report t")
		.append(" where t.bsflag ='0' and t.project_info_no = '").append(project_info_no).append("'");
		map = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			String geophone_num = (String) map.get("geophone_num");
		}
		/* 自然天数 */
		sb = new StringBuffer();
		sb.append("select (max(t.produce_date)-min(t.produce_date)-(-1)) produce_date from gp_ops_daily_report t")
		.append(" where t.bsflag ='0' and t.project_info_no = '").append(project_info_no).append("'");
		map = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			String produce_date = (String) map.get("produce_date");
		}
		/* 实际生产天数 */
		sb = new StringBuffer();
		sb.append("select count(*) produce_date from(select s.daily_no ,s.if_build from gp_ops_daily_report t")
		.append(" join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag ='0'")
		.append(" where t.bsflag ='0' and s.if_build in('1','2','3','4','5','6','9','e')")
		.append(" and t.project_info_no = '").append(project_info_no).append("' group by s.daily_no ,s.if_build)");
		map = pureJdbcDao.queryRecordBySQL(sb.toString());
		if(map!=null){
			String produce_date = (String) map.get("produce_date");
		}
	}
	
	public ISrvMsg uploadFile(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
        XSSFWorkbook wb = new XSSFWorkbook(new  FileInputStream("C:/Documents and Settings/admin/桌面/项目评价.xlsx"));
        XSSFSheet sheet = wb.getSheetAt(2); 
        XSSFRow row = sheet.getRow(2); 
        XSSFCell cell = row.getCell((short)1);
		return responseDTO;
	}
	
	
	
	/**生产模块 项目评价  开始
	 * 
	 * 公共 --> 保存
	 * author  xiaqiuyu
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDatasBySql(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sqls = reqDTO.getValue("sql");
		System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
		return msg;
	}
	public void saveDatasBySql(String sqls) throws Exception {
		//System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
	}
	/**
	 * 项目评价，项目模板树
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg getEvaluateTemplate(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String checked = reqDTO.getValue("checked");
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null || project_info_no.trim().equals("")){
			project_info_no = user.getProjectInfoNo();
		}
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){
			sb  = new StringBuffer();
			sb.append("select t.evaluate_template_id id,t.evaluate_template_name name,t.parent_id ,t.evaluate_weight ,t.evaluate_standard ,t.ordering,decode(t.is_leaf,'0','false','true') leaf")
			.append(" from bgp_pm_evaluate_template t where t.bsflag ='0' and t.parent_id ='ROOT' order by t.ordering asc");

			List list = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(list);
		}else{
			sb  = new StringBuffer();
			sb.append("select t.evaluate_template_id id,t.evaluate_template_name name,t.parent_id ,t.evaluate_weight ,t.evaluate_standard ,t.ordering,decode(t.is_leaf,'0','false','true') leaf")
			.append(" from bgp_pm_evaluate_template t where t.bsflag ='0' and t.parent_id ='").append(node).append("' order by t.ordering asc");

			List list = pureJdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(list);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	/**
	 * 项目评价，项目模板树
	 * 
	 * author xiaoxia 
	 * date 2012-6-6
	 * @param reqDTO
	 */
	public ISrvMsg saveEvaluateTemplate(ISrvMsg reqDTO) throws Exception{
		System.out.println("saveEvaluateTemplate");
		UserToken user = reqDTO.getUserToken();
		String user_name = user.getUserName();
		Map submit = reqDTO.toMap();
		String project_info_no = user.getProjectInfoNo();
		String sql = "delete from bgp_pm_evaluate_project t where t.project_info_no ='"+project_info_no+"';";
		saveDatasBySql(sql);
		sql = "select t.evaluate_template_id,t.evaluate_template_name,t.parent_id,t.evaluate_weight,t.evaluate_standard,t.cal_desc,t.is_leaf,t.ordering from bgp_pm_evaluate_template t where t.bsflag ='0' order by t.ordering";
		List list = pureJdbcDao.queryRecords(sql);
		for(int i=0;list!=null && i<list.size();i++){
			Map map = (Map)list.get(i);
			if(map!=null){
				//Map map1 = new HashMap();
				map.put("project_info_no", project_info_no);
				int evaluate_weight = Integer.valueOf((String)map.get("evaluate_weight"));
				String cal_desc = (String)map.get("cal_desc");
				double evaluate_score = Double.valueOf((String)submit.get(cal_desc));
				map.put("evaluate_score", evaluate_score);
				map.put("creator", user_name);
				map.put("modifier", user_name);
				System.out.println(map);
				Serializable id = jdbcDao.saveOrUpdateEntity(map, "bgp_pm_evaluate_project");
			}
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		return msg;
	}
	/**生产模块 项目评价  结束 */
}

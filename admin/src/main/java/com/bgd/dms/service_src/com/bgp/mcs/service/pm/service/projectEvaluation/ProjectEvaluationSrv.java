package com.bgp.mcs.service.pm.service.projectEvaluation;

import java.io.Serializable;
import java.util.*;

import net.sf.json.JSONArray;

import org.springframework.jdbc.core.JdbcTemplate;

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
}

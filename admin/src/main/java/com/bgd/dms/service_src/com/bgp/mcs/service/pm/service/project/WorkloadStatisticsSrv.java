package com.bgp.mcs.service.pm.service.project;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

public class WorkloadStatisticsSrv extends BaseService {
	
	public ISrvMsg getCompanyWorkload(ISrvMsg reqDTO) throws Exception{
		// 公司级(计算出各物探处下项目的工作量)
		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");
		
		List<Map> datas = new ArrayList<Map>();
		List<Map> designList = new ArrayList<Map>();
		List<Map> actualList = new ArrayList<Map>();
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		// 获取所有物探处
		String orgSubIdofAff = reqDTO.getValue("orgSubId");
		UserToken user = reqDTO.getUserToken();
		if(orgSubIdofAff == null || "".equals(orgSubIdofAff)){
			orgSubIdofAff = user.getSubOrgIDofAffordOrg();
		}
	
		DBDataService dbDataSrv = new DBDataService();
		List<Map> orgList = dbDataSrv.getOrganization(orgSubIdofAff);
		
		//设计数
		StringBuffer sql = new StringBuffer(" select sum(workload) as paodian,sum(workload_num) as gongli ,org_subjection_id, eps_name,oper_plan_type from ( ");
		sql.append("select workload ,workload_num , substr(a.org_subjection_id,0,length(b.org_sub_id)) as org_subjection_id , b.eps_name,a.oper_plan_type");
		sql.append(",to_char(to_date(record_month,'yyyy-MM-dd'),'MM-dd') as record_month");
		sql.append(",to_date(record_month,'yyyy-MM-dd') as data");
		sql.append(" from gp_proj_product_plan a ,(");
		sql.append(" select os.org_subjection_id as org_sub_id ,eps.eps_name as eps_name from bgp_eps_code eps");
		sql.append(" join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0' ");
		sql.append(" where eps.parent_object_id in(");
		sql.append(" select object_id as parent_object_id from bgp_eps_code where org_id = 'C6000000000001')");
		sql.append(" and os.org_subjection_id like'C105%') b");
		sql.append(" where a.bsflag = '0' and substr(a.org_subjection_id,0,length(b.org_sub_id)) = b.org_sub_id");
		sql.append(" and a.oper_plan_type in('colldailylist','measuredailylist','drilldailylist','surfacedailylist')");
		sql.append(") c group by(org_subjection_id,eps_name,oper_plan_type)");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		try{
			designList = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			//
		}
		if(orgList != null){
			if(designList != null){
				for(int i=0; i < orgList.size(); i++){
					Map map = orgList.get(i);
					for(int k=0; k < designList.size(); k++){
						Map dataMap = designList.get(k);
						String oper_plan_type = (String) dataMap.get("oper_plan_type");
						if (oper_plan_type == "colldailylist" || "colldailylist".equals(oper_plan_type)) {
							String value = "" + dataMap.get("gongli");
							map.put("colldailylist", value);
						}else if(oper_plan_type == "measuredailylist" || "measuredailylist".equals(oper_plan_type)){
							String value = "" + dataMap.get("paodian");
							map.put("measuredailylist", value);
						}else if(oper_plan_type == "drilldailylist" || "drilldailylist".equals(oper_plan_type)){
							String value = "" + dataMap.get("gongli");
							map.put("drilldailylist", value);
						}else if(oper_plan_type == "surfacedailylist" || "surfacedailylist".equals(oper_plan_type)){
							String value = "" + dataMap.get("gongli");
							map.put("surfacedailylist", value);
						}
					}
					if(map.get("colldailylist") == null){
						map.put("colldailylist", "0");
					}
					if(map.get("measuredailylist") == null){
						map.put("measuredailylist", "0");
					}
					if(map.get("drilldailylist") == null){
						map.put("drilldailylist", "0");
					}
					if(map.get("surfacedailylist") == null){
						map.put("surfacedailylist", "0");
					}
					datas.add(map);
				}
			}else{
				// 将各设计数值赋为0
				for(int i=0; i < orgList.size(); i++){
					Map map = orgList.get(i);
					map.put("colldailylist", "0");
					map.put("measuredailylist", "0");
					map.put("drilldailylist", "0");
					map.put("surfacedailylist", "0");
					datas.add(map);
				}
			}			
		}
		
		//实际日报数
		StringBuffer sql2 = new StringBuffer(" select t1.org_sub_id,t1.eps_name,t2.coll_value,t2.measure_value,t2.drill_value,t2.surface_value from ( ");
		sql2.append(" select os.org_subjection_id as org_sub_id ,eps.eps_name as eps_name from bgp_eps_code eps ");
		sql2.append(" join comm_org_subjection os on eps.org_id = os.org_id where os.bsflag = '0' ");
		sql2.append(" and eps.parent_object_id in(");
		sql2.append(" select object_id as parent_object_id from bgp_eps_code where org_id = 'C6000000000001')");
		sql2.append(" and os.org_subjection_id like'C105%') t1");
		sql2.append(" left join(");
		sql2.append(" select sum(coll_value) as coll_value,sum(measure_value) as measure_value,sum(drill_value) as drill_value,sum(surface_value) as surface_value,org_subjection_id from (");
		sql2.append(" select nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0) as coll_value");
		sql2.append(" ,nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0) as measure_value");
		sql2.append(" ,nvl(d.daily_micro_measue_point_num,0)+nvl(d.daily_small_refraction_num,0) as surface_value");
		sql2.append(",nvl(d.daily_drill_sp_num,0) as drill_value,d.produce_date as produce_date");
		sql2.append(" ,substr(d.org_subjection_id,0,length(b.org_sub_id)) as org_subjection_id");
		sql2.append(" from gp_ops_daily_report d , ( ");
		sql2.append(" select os.org_subjection_id as org_sub_id  from bgp_eps_code eps ");
		sql2.append("join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0'");
		sql2.append(" where eps.parent_object_id in(");
		sql2.append("  select object_id as parent_object_id from bgp_eps_code where org_id = 'C6000000000001')");
		sql2.append(" and os.org_subjection_id like'C105%') b");
		sql2.append("  where d.bsflag = '0'");
		sql2.append(" and produce_date >= to_date('").append(startDate).append("','yyyy-MM-dd') ");
		sql2.append(" and produce_date <= to_date('").append(endDate).append("','yyyy-MM-dd') ");
		sql2.append(" and substr(d.org_subjection_id,0,length(b.org_sub_id)) = b.org_sub_id  ");
		sql2.append("  ) ");
		sql2.append("  group by org_subjection_id  ");
		sql2.append(" ) t2 ");
		sql2.append(" on t1.org_sub_id = t2.org_subjection_id ");
		
		try{
			actualList = jdbcDAO.queryRecords(sql2.toString());
		}catch(Exception e){
			//
		}
		// 将数据转换成字符串
		List list = companyDataTransfor(datas, actualList);
		String collStr = "" + list.get(0);
		String measureStr = "" + list.get(1);
		String drillStr = "" + list.get(2);
		String surfaceStr = "" + list.get(3);
		int p_start = collStr.indexOf("<chart");
		if(p_start > 0){
			collStr = collStr.substring(p_start, collStr.length());
		}
		p_start = measureStr.indexOf("<chart");
		if(p_start > 0){
			measureStr = measureStr.substring(p_start, measureStr.length());
		}
		p_start = drillStr.indexOf("<chart");
		if(p_start > 0){
			drillStr = drillStr.substring(p_start, drillStr.length());
		}
		p_start = surfaceStr.indexOf("<chart");
		if(p_start > 0){
			surfaceStr = surfaceStr.substring(p_start, surfaceStr.length());
		}
		respMsg.setValue("collStr", collStr);
		respMsg.setValue("measureStr", measureStr);
		respMsg.setValue("drillStr", drillStr);
		respMsg.setValue("surfaceStr", surfaceStr);
		
		return respMsg;
	}
	
	public ISrvMsg getDepartmentWorkload(ISrvMsg reqDTO) throws Exception{
		// 物探处级 (计算出某物探处下项目的工作量)
		String subOrgId = reqDTO.getValue("subOrgId");
		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");
		
		Map<String,Object> mProjects = new HashMap<String,Object>();
		List<Map> designList = new ArrayList<Map>();
		List<Map> actualList = new ArrayList<Map>();
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//设计数
		StringBuffer sql = new StringBuffer(" select sum(workload) as paodian,sum(workload_num) as gongli, a.project_info_no, a.oper_plan_type, b.project_name ");
		sql.append(" from gp_proj_product_plan a , gp_task_project b");
		sql.append(" where a.project_info_no = b.project_info_no");
		sql.append(" and a.bsflag = '0' and b.bsflag = '0'");
		sql.append(" and a.oper_plan_type in('colldailylist','measuredailylist','drilldailylist','surfacedailylist')");
		sql.append(" and a.org_subjection_id like '").append(subOrgId).append("%'");
		sql.append(" group by(a.project_info_no,b.project_name)");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		try{
			designList = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			//
		}
		if(designList != null){
			//记录不同的项目
			
			// 循环行记录 将各值加到project中
			for(int i=0; i < designList.size(); i++){
				Map dataMap = designList.get(i);
				String projectInfoNo = (String) dataMap.get("project_info_no");
				String oper_plan_type = (String) dataMap.get("oper_plan_type");
				Map project = (Map)mProjects.get(projectInfoNo);
				if(project == null){
					project = new HashMap();
				}
				
				if (oper_plan_type == "colldailylist" || "colldailylist".equals(oper_plan_type)) {
					String value = "" + dataMap.get("gongli");
					project.put("colldailylist", value);
				}else if(oper_plan_type == "measuredailylist" || "measuredailylist".equals(oper_plan_type)){
					String value = "" + dataMap.get("paodian");
					project.put("measuredailylist", value);
				}else if(oper_plan_type == "drilldailylist" || "drilldailylist".equals(oper_plan_type)){
					String value = "" + dataMap.get("gongli");
					project.put("drilldailylist", value);
				}else if(oper_plan_type == "surfacedailylist" || "surfacedailylist".equals(oper_plan_type)){
					String value = "" + dataMap.get("gongli");
					project.put("surfacedailylist", value);
				}
				mProjects.put(projectInfoNo, project);
			}
		}
		
		//实际日报数
		StringBuffer sql2 = new StringBuffer("select a.project_name, a.project_info_no,b.coll_value,b.measure_value,b.drill_value,b.surface_value");
		sql2.append(" from gp_task_project a,(");
		sql2.append(" select sum(coll_value) as coll_value,sum(measure_value) as measure_value,sum(drill_value) as drill_value,sum(surface_value) as surface_value,project_info_no from ( ");
		sql2.append(" select nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0) as coll_value");
		sql2.append(" ,nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0) as measure_value");
		sql2.append(" ,nvl(d.daily_micro_measue_point_num,0)+nvl(d.daily_small_refraction_num,0) as surface_value");
		sql2.append(" ,nvl(d.daily_drill_sp_num,0) as drill_value,d.produce_date as produce_date");
		sql2.append(" ,d.project_info_no");
		sql2.append(" from gp_ops_daily_report d ");
		sql2.append(" where d.bsflag = '0'");
		sql2.append(" and d.org_subjection_id like '").append(subOrgId).append("%' ");
		sql2.append(" and d.produce_date >= to_date('").append(startDate).append("','yyyy-MM-dd') ");
		sql2.append(" and d.produce_date <= to_date('").append(endDate).append("','yyyy-MM-dd') ");
		sql2.append(" )  group by project_info_no");
		sql2.append(" )b");
		sql2.append("  where a.project_info_no = b.project_info_no");
		try{
			actualList = jdbcDAO.queryRecords(sql2.toString());
		}catch(Exception e){
			//
		}
		// 将mprojects 与实际数值actualList关联起来
		List list = departMentDataTransfor(mProjects, actualList);
		String collStr = "" + list.get(0);
		String measureStr = "" + list.get(1);
		String drillStr = "" + list.get(2);
		String surfaceStr = "" + list.get(3);
		int p_start = collStr.indexOf("<chart");
		if(p_start > 0){
			collStr = collStr.substring(p_start, collStr.length());
		}
		p_start = measureStr.indexOf("<chart");
		if(p_start > 0){
			measureStr = measureStr.substring(p_start, measureStr.length());
		}
		p_start = drillStr.indexOf("<chart");
		if(p_start > 0){
			drillStr = drillStr.substring(p_start, drillStr.length());
		}
		p_start = surfaceStr.indexOf("<chart");
		if(p_start > 0){
			surfaceStr = surfaceStr.substring(p_start, surfaceStr.length());
		}
		respMsg.setValue("collStr", collStr);
		respMsg.setValue("measureStr", measureStr);
		respMsg.setValue("drillStr", drillStr);
		respMsg.setValue("surfaceStr", surfaceStr);
		
		return respMsg;
	}
	
	public ISrvMsg getProjectWorkload(ISrvMsg reqDTO) throws Exception{
		// 项目级 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");
		
		Map project = new HashMap();
		List<Map> designList = new ArrayList<Map>();
		List<Map> actualList = new ArrayList<Map>();
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//设计数
		StringBuffer sql = new StringBuffer(" select sum(workload) as paodian,sum(workload_num) as gongli, a.project_info_no, a.oper_plan_type, b.project_name ");
		sql.append(" from gp_proj_product_plan a , gp_task_project b");
		sql.append(" where a.project_info_no = b.project_info_no");
		sql.append(" and a.bsflag = '0' and b.bsflag = '0'");
		sql.append(" and a.oper_plan_type in('colldailylist','measuredailylist','drilldailylist','surfacedailylist')");
		sql.append(" and a.project_info_no = '").append(projectInfoNo).append("'");
		sql.append(" group by(a.project_info_no,b.project_name)");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		try{
			designList = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			//
		}
		
		if(designList != null){
			// 循环行记录 将各值加到project中
			for(int i=0; i < designList.size(); i++){
				Map dataMap = designList.get(i);
				String oper_plan_type = (String) dataMap.get("oper_plan_type");
				
				if (oper_plan_type == "colldailylist" || "colldailylist".equals(oper_plan_type)) {
					String value = "" + dataMap.get("gongli");
					project.put("colldailylist", value);
				}else if(oper_plan_type == "measuredailylist" || "measuredailylist".equals(oper_plan_type)){
					String value = "" + dataMap.get("paodian");
					project.put("measuredailylist", value);
				}else if(oper_plan_type == "drilldailylist" || "drilldailylist".equals(oper_plan_type)){
					String value = "" + dataMap.get("gongli");
					project.put("drilldailylist", value);
				}else if(oper_plan_type == "surfacedailylist" || "surfacedailylist".equals(oper_plan_type)){
					String value = "" + dataMap.get("gongli");
					project.put("surfacedailylist", value);
				}
			}
		}
		//实际日报数
		StringBuffer sql2 = new StringBuffer("select a.project_name, a.project_info_no,b.coll_value,b.measure_value,b.drill_value,b.surface_value");
		sql2.append(" from gp_task_project a,(");
		sql2.append(" select sum(nvl(d.daily_acquire_sp_num,0)+nvl(d.daily_jp_acquire_shot_num,0)+nvl(d.daily_qq_acquire_shot_num,0)) as coll_value");
		sql2.append(" ,sum(nvl(d.survey_incept_workload,0)+nvl(d.survey_shot_workload,0)) as measure_value");
		sql2.append(" ,sum(nvl(d.daily_micro_measue_point_num,0)+nvl(d.daily_small_refraction_num,0)) as surface_value");
		sql2.append(" ,sum(nvl(d.daily_drill_sp_num,0)) as drill_value");
		sql2.append(" ,project_info_no");
		sql2.append(" from gp_ops_daily_report d ");
		sql2.append(" where d.bsflag = '0'");
		sql2.append(" and d.project_info_no = '").append(projectInfoNo).append("'");
		sql2.append(" and d.produce_date >= to_date('").append(startDate).append("','yyyy-MM-dd') ");
		sql2.append(" and d.produce_date <= to_date('").append(endDate).append("','yyyy-MM-dd') ");
		sql2.append(" group by project_info_no");
		sql2.append(" )b where a.project_info_no = b.project_info_no");
		try{
			actualList = jdbcDAO.queryRecords(sql2.toString());
		}catch(Exception e){
			//
		}
		// 将实际数值与设计值关联起来
		List list = projectDataTransfor(project, actualList);
		String collStr = "" + list.get(0);
		String measureStr = "" + list.get(1);
		String drillStr = "" + list.get(2);
		String surfaceStr = "" + list.get(3);
		int p_start = collStr.indexOf("<chart");
		if(p_start > 0){
			collStr = collStr.substring(p_start, collStr.length());
		}
		p_start = measureStr.indexOf("<chart");
		if(p_start > 0){
			measureStr = measureStr.substring(p_start, measureStr.length());
		}
		p_start = drillStr.indexOf("<chart");
		if(p_start > 0){
			drillStr = drillStr.substring(p_start, drillStr.length());
		}
		p_start = surfaceStr.indexOf("<chart");
		if(p_start > 0){
			surfaceStr = surfaceStr.substring(p_start, surfaceStr.length());
		}
		respMsg.setValue("collStr", collStr);
		respMsg.setValue("measureStr", measureStr);
		respMsg.setValue("drillStr", drillStr);
		respMsg.setValue("surfaceStr", surfaceStr);
		
		return respMsg;
	}
	
	private List companyDataTransfor(List<Map> design, List<Map> actual){
		List list = new ArrayList();
		Document document1 = DocumentHelper.createDocument();
		Document document2 = DocumentHelper.createDocument();
		Document document3 = DocumentHelper.createDocument();
		Document document4 = DocumentHelper.createDocument();
		Element root1 = document1.addElement("chart");
		Element root2 = document2.addElement("chart");
		Element root3 = document3.addElement("chart");
		Element root4 = document4.addElement("chart");
		root1.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root1.addAttribute("caption", "采集工作量");
		root1.addAttribute("xAxisName", "直属单位");
		root1.addAttribute("yAxisName", "炮点数");
		root1.addAttribute("showLabels", "1");
		root1.addAttribute("showValues", "0");
		root2.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root2.addAttribute("caption", "测量工作量");
		root2.addAttribute("xAxisName", "直属单位");
		root2.addAttribute("yAxisName", "接收线炮线公里数和");
		root2.addAttribute("showLabels", "1");
		root2.addAttribute("showValues", "0");
		root3.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root3.addAttribute("caption", "钻井工作量");
		root3.addAttribute("xAxisName", "直属单位");
		root3.addAttribute("yAxisName", "炮点数");
		root3.addAttribute("showLabels", "1");
		root3.addAttribute("showValues", "0");
		root4.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root4.addAttribute("caption", "表层调查工作量");
		root4.addAttribute("xAxisName", "直属单位");
		root4.addAttribute("yAxisName", "微测井小折射点数和");
		root4.addAttribute("showLabels", "1");
		root4.addAttribute("showValues", "0");
		
		Element categories1 = root1.addElement("categories");
		Element categories2 = root2.addElement("categories");
		Element categories3 = root3.addElement("categories");
		Element categories4 = root4.addElement("categories");
		Element designDataset1 = root1.addElement("dataset");
		Element designDataset2 = root2.addElement("dataset");
		Element designDataset3 = root3.addElement("dataset");
		Element designDataset4 = root4.addElement("dataset");
		designDataset1.addAttribute("seriesName", "设计炮点数");
		designDataset2.addAttribute("seriesName", "设计接收线公里数与设计炮线公里数的和");
		designDataset3.addAttribute("seriesName", "设计炮点数");
		designDataset4.addAttribute("seriesName", "微测井设计点数与小折射设计点数的和");
		Element actualDataset1 = root1.addElement("dataset");
		Element actualDataset2 = root2.addElement("dataset");
		Element actualDataset3 = root3.addElement("dataset");
		Element actualDataset4 = root4.addElement("dataset");
		actualDataset1.addAttribute("seriesName", "日完成炮点数");
		actualDataset2.addAttribute("seriesName", "日接收线公里数与日炮线公里数的和");
		actualDataset3.addAttribute("seriesName", "日完成炮点数");
		actualDataset4.addAttribute("seriesName", "微测井累积完成点数与小折射累积完成点数");
		if(actual != null){
			if(design != null){
				for(int i=0; i< actual.size(); i++){
					Map recordMap = actual.get(i);
					String epsName = "" + recordMap.get("eps_name");
					String orgSubId = "" + recordMap.get("org_sub_id");
					String coll_value = "" + recordMap.get("coll_value");
					String measure_value = "" + recordMap.get("measure_value");
					String drill_value = "" + recordMap.get("drill_value");
					String surface_value = "" + recordMap.get("surface_value");
					
					Element category1 = categories1.addElement("category");
					Element category2 = categories2.addElement("category");
					Element category3 = categories3.addElement("category");
					Element category4 = categories4.addElement("category");
					category1.addAttribute("label", epsName);
					category2.addAttribute("label", epsName);
					category3.addAttribute("label", epsName);
					category4.addAttribute("label", epsName);
					
					Element actualSet1 = actualDataset1.addElement("set");
					actualSet1.addAttribute("value", coll_value);
					actualSet1.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					//actualSet1.addAttribute("toolText", "abcdefg%");
					
					Element actualSet2 = actualDataset2.addElement("set");
					actualSet2.addAttribute("value", measure_value);
					actualSet2.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					Element actualSet3 = actualDataset3.addElement("set");
					actualSet3.addAttribute("value", drill_value);
					actualSet3.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					Element actualSet4 = actualDataset4.addElement("set");
					actualSet4.addAttribute("value", surface_value);
					actualSet4.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					
					// 取设计数值
					for(int k=0; k < design.size(); k++){
						Map designMap = design.get(k);
						String orgName = "" + designMap.get("org_name");
						if(epsName.equals(orgName) || epsName == orgName){
							String colldailylist = "" + designMap.get("colldailylist");
							String measuredailylist = "" + designMap.get("measuredailylist");
							String drilldailylist = "" + designMap.get("drilldailylist");
							String surfacedailylist = "" + designMap.get("surfacedailylist");
							
							Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");//[0-9]+(.[0-9]?)?+
							Matcher isNum1 = pattern.matcher(coll_value);
							Matcher isNum2 = pattern.matcher(colldailylist);
							if(isNum1.matches() && isNum2.matches() && !"0".equals(colldailylist)){
								double d = Long.valueOf(coll_value) / Long.valueOf(colldailylist) * 100;
								actualSet1.addAttribute("toolText", d + "%");
							}else{
								actualSet1.addAttribute("toolText", "0%");
							}
							isNum1 = pattern.matcher(measure_value);
							isNum2 = pattern.matcher(measuredailylist);
							if(isNum1.matches() && isNum2.matches() && !"0".equals(measuredailylist)){
								double d = Long.valueOf(measure_value) / Long.valueOf(measuredailylist) * 100;
								actualSet2.addAttribute("toolText", d + "%");
							}else{
								actualSet2.addAttribute("toolText", "0%");
							}
							isNum1 = pattern.matcher(drill_value);
							isNum2 = pattern.matcher(drilldailylist);
							if(isNum1.matches() && isNum2.matches() && !"0".equals(drilldailylist)){
								double d = Long.valueOf(drill_value) / Long.valueOf(drilldailylist) * 100;
								actualSet3.addAttribute("toolText", d + "%");
							}else{
								actualSet3.addAttribute("toolText", "0%");
							}
							isNum1 = pattern.matcher(surface_value);
							isNum2 = pattern.matcher(surfacedailylist);
							if(isNum1.matches() && isNum2.matches() && !"0".equals(surfacedailylist)){
								double d = Long.valueOf(surface_value) / Long.valueOf(surfacedailylist) * 100;
								actualSet4.addAttribute("toolText", d + "%");
							}else{
								actualSet4.addAttribute("toolText", "0%");
							}
							
							Element designSet1 = designDataset1.addElement("set");
							designSet1.addAttribute("value", colldailylist);
							designSet1.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
							Element designSet2 = designDataset2.addElement("set");
							designSet2.addAttribute("value", measuredailylist);
							designSet2.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
							Element designSet3 = designDataset3.addElement("set");
							designSet3.addAttribute("value", drilldailylist);
							designSet3.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
							Element designSet4 = designDataset4.addElement("set");
							designSet4.addAttribute("value", surfacedailylist);
							designSet4.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
						}else{
							continue;
						}
					}
				}
			}else{
				//设计数值为空
				for(int i=0; i< actual.size(); i++){
					Map recordMap = actual.get(i);
					String epsName = "" + recordMap.get("eps_name");
					String orgSubId = "" + recordMap.get("org_sub_id");
					String coll_value = "" + recordMap.get("coll_value");
					String measure_value = "" + recordMap.get("measure_value");
					String drill_value = "" + recordMap.get("drill_value");
					String surface_value = "" + recordMap.get("surface_value");
					
					Element category1 = categories1.addElement("category");
					Element category2 = categories2.addElement("category");
					Element category3 = categories3.addElement("category");
					Element category4 = categories4.addElement("category");
					category1.addAttribute("label", epsName);
					category2.addAttribute("label", epsName);
					category3.addAttribute("label", epsName);
					category4.addAttribute("label", epsName);
					
					Element actualSet1 = actualDataset1.addElement("set");
					actualSet1.addAttribute("value", coll_value);
					actualSet1.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					actualSet1.addAttribute("toolText", "0%");
					Element actualSet2 = actualDataset2.addElement("set");
					actualSet2.addAttribute("value", measure_value);
					actualSet2.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					actualSet2.addAttribute("toolText", "0%");
					Element actualSet3 = actualDataset3.addElement("set");
					actualSet3.addAttribute("value", drill_value);
					actualSet3.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					actualSet3.addAttribute("toolText", "0%");
					Element actualSet4 = actualDataset4.addElement("set");
					actualSet4.addAttribute("value", surface_value);
					actualSet4.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					actualSet4.addAttribute("toolText", "0%");
					
					Element designSet1 = designDataset1.addElement("set");
					designSet1.addAttribute("value", "0");
					designSet1.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					Element designSet2 = designDataset2.addElement("set");
					designSet2.addAttribute("value", "0");
					designSet2.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					Element designSet3 = designDataset3.addElement("set");
					designSet3.addAttribute("value", "0");
					designSet3.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
					Element designSet4 = designDataset4.addElement("set");
					designSet4.addAttribute("value", "0");
					designSet4.addAttribute("link", "j-inBrowse('"+orgSubId+"')");
				}
			}
		}
		list.add(document1.asXML());
		list.add(document2.asXML());
		list.add(document3.asXML());
		list.add(document4.asXML());
		
		return list;
	}
	
	private List departMentDataTransfor(Map<String,Object> design, List<Map> actual){
		List list = new ArrayList();
		Document document1 = DocumentHelper.createDocument();
		Document document2 = DocumentHelper.createDocument();
		Document document3 = DocumentHelper.createDocument();
		Document document4 = DocumentHelper.createDocument();
		Element root1 = document1.addElement("chart");
		Element root2 = document2.addElement("chart");
		Element root3 = document3.addElement("chart");
		Element root4 = document4.addElement("chart");
		root1.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root1.addAttribute("caption", "采集工作量");
		root1.addAttribute("xAxisName", "项目");
		root1.addAttribute("yAxisName", "炮点数");
		root1.addAttribute("showLabels", "1");
		root1.addAttribute("showValues", "0");
		root2.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root2.addAttribute("caption", "测量工作量");
		root2.addAttribute("xAxisName", "项目");
		root2.addAttribute("yAxisName", "接收线炮线公里数和");
		root2.addAttribute("showLabels", "1");
		root2.addAttribute("showValues", "0");
		root3.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root3.addAttribute("caption", "钻井工作量");
		root3.addAttribute("xAxisName", "项目");
		root3.addAttribute("yAxisName", "炮点数");
		root3.addAttribute("showLabels", "1");
		root3.addAttribute("showValues", "0");
		root4.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root4.addAttribute("caption", "表层调查工作量");
		root4.addAttribute("xAxisName", "项目");
		root4.addAttribute("yAxisName", "微测井小折射点数和");
		root4.addAttribute("showLabels", "1");
		root4.addAttribute("showValues", "0");
		
		Element categories1 = root1.addElement("categories");
		Element categories2 = root2.addElement("categories");
		Element categories3 = root3.addElement("categories");
		Element categories4 = root4.addElement("categories");
		Element designDataset1 = root1.addElement("dataset");
		Element designDataset2 = root2.addElement("dataset");
		Element designDataset3 = root3.addElement("dataset");
		Element designDataset4 = root4.addElement("dataset");
		designDataset1.addAttribute("seriesName", "设计炮点数");
		designDataset2.addAttribute("seriesName", "设计接收线公里数与设计炮线公里数的和");
		designDataset3.addAttribute("seriesName", "设计炮点数");
		designDataset4.addAttribute("seriesName", "微测井设计点数与小折射设计点数的和");
		Element actualDataset1 = root1.addElement("dataset");
		Element actualDataset2 = root2.addElement("dataset");
		Element actualDataset3 = root3.addElement("dataset");
		Element actualDataset4 = root4.addElement("dataset");
		actualDataset1.addAttribute("seriesName", "日完成炮点数");
		actualDataset2.addAttribute("seriesName", "日接收线公里数与日炮线公里数的和");
		actualDataset3.addAttribute("seriesName", "日完成炮点数");
		actualDataset4.addAttribute("seriesName", "微测井累积完成点数与小折射累积完成点数");
		if(actual != null){
			if(design != null){
				for(int i=0; i< actual.size(); i++){
					Map recordMap = actual.get(i);
					String projectName = "" + recordMap.get("project_name");
					String projectInfoNo = "" + recordMap.get("project_info_no");
					String coll_value = "" + recordMap.get("coll_value");
					String measure_value = "" + recordMap.get("measure_value");
					String drill_value = "" + recordMap.get("drill_value");
					String surface_value = "" + recordMap.get("surface_value");
					
					Element category1 = categories1.addElement("category");
					Element category2 = categories2.addElement("category");
					Element category3 = categories3.addElement("category");
					Element category4 = categories4.addElement("category");
					category1.addAttribute("label", projectName);
					category2.addAttribute("label", projectName);
					category3.addAttribute("label", projectName);
					category4.addAttribute("label", projectName);
					
					Element actualSet1 = actualDataset1.addElement("set");
					actualSet1.addAttribute("value", coll_value);
					actualSet1.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					Element actualSet2 = actualDataset2.addElement("set");
					actualSet2.addAttribute("value", measure_value);
					actualSet2.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					Element actualSet3 = actualDataset3.addElement("set");
					actualSet3.addAttribute("value", drill_value);
					actualSet3.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					Element actualSet4 = actualDataset4.addElement("set");
					actualSet4.addAttribute("value", surface_value);
					actualSet4.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					// 取设计数值
					Map designMap = (Map)design.get(projectInfoNo);
					if(designMap != null){
						String colldailylist = "" + designMap.get("colldailylist");
						String measuredailylist = "" + designMap.get("measuredailylist");
						String drilldailylist = "" + designMap.get("drilldailylist");
						String surfacedailylist = "" + designMap.get("surfacedailylist");
							
						Element designSet1 = designDataset1.addElement("set");
						designSet1.addAttribute("value", colldailylist);
						designSet1.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
						Element designSet2 = designDataset2.addElement("set");
						designSet2.addAttribute("value", measuredailylist);
						designSet2.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
						Element designSet3 = designDataset3.addElement("set");
						designSet3.addAttribute("value", drilldailylist);
						designSet3.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
						Element designSet4 = designDataset4.addElement("set");
						designSet4.addAttribute("value", surfacedailylist);
						designSet4.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
						
						Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");//[0-9]+(.[0-9]?)?+
						Matcher isNum1 = pattern.matcher(coll_value);
						Matcher isNum2 = pattern.matcher(colldailylist);
						if(isNum1.matches() && isNum2.matches() && !"0".equals(colldailylist)){
							double d = Long.valueOf(coll_value) / Long.valueOf(colldailylist) * 100;
							actualSet1.addAttribute("toolText", d + "%");
						}else{
							actualSet1.addAttribute("toolText", "0%");
						}
						isNum1 = pattern.matcher(measure_value);
						isNum2 = pattern.matcher(measuredailylist);
						if(isNum1.matches() && isNum2.matches() && !"0".equals(measuredailylist)){
							double d = Long.valueOf(measure_value) / Long.valueOf(measuredailylist) * 100;
							actualSet2.addAttribute("toolText", d + "%");
						}else{
							actualSet2.addAttribute("toolText", "0%");
						}
						isNum1 = pattern.matcher(drill_value);
						isNum2 = pattern.matcher(drilldailylist);
						if(isNum1.matches() && isNum2.matches() && !"0".equals(drilldailylist)){
							double d = Long.valueOf(drill_value) / Long.valueOf(drilldailylist) * 100;
							actualSet3.addAttribute("toolText", d + "%");
						}else{
							actualSet3.addAttribute("toolText", "0%");
						}
						isNum1 = pattern.matcher(surface_value);
						isNum2 = pattern.matcher(surfacedailylist);
						if(isNum1.matches() && isNum2.matches() && !"0".equals(surfacedailylist)){
							double d = Long.valueOf(surface_value) / Long.valueOf(surfacedailylist) * 100;
							actualSet4.addAttribute("toolText", d + "%");
						}else{
							actualSet4.addAttribute("toolText", "0%");
						}
					}else{
						Element designSet1 = designDataset1.addElement("set");
						designSet1.addAttribute("value", "0");
						designSet1.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
						Element designSet2 = designDataset2.addElement("set");
						designSet2.addAttribute("value", "0");
						designSet2.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
						Element designSet3 = designDataset3.addElement("set");
						designSet3.addAttribute("value", "0");
						designSet3.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
						Element designSet4 = designDataset4.addElement("set");
						designSet4.addAttribute("value", "0");
						designSet4.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					}
				}
			}else{
				//设计数值为空
				for(int i=0; i< actual.size(); i++){
					Map recordMap = actual.get(i);
					String projectName = "" + recordMap.get("project_name");
					String projectInfoNo = "" + recordMap.get("project_info_no");
					String coll_value = "" + recordMap.get("coll_value");
					String measure_value = "" + recordMap.get("measure_value");
					String drill_value = "" + recordMap.get("drill_value");
					String surface_value = "" + recordMap.get("surface_value");
					
					Element category1 = categories1.addElement("category");
					Element category2 = categories2.addElement("category");
					Element category3 = categories3.addElement("category");
					Element category4 = categories4.addElement("category");
					category1.addAttribute("label", projectName);
					category2.addAttribute("label", projectName);
					category3.addAttribute("label", projectName);
					category4.addAttribute("label", projectName);
					
					Element actualSet1 = actualDataset1.addElement("set");
					actualSet1.addAttribute("value", coll_value);
					actualSet1.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					actualSet1.addAttribute("toolText", "0%");
					Element actualSet2 = actualDataset2.addElement("set");
					actualSet2.addAttribute("value", measure_value);
					actualSet2.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					actualSet2.addAttribute("toolText", "0%");
					Element actualSet3 = actualDataset3.addElement("set");
					actualSet3.addAttribute("value", drill_value);
					actualSet3.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					actualSet3.addAttribute("toolText", "0%");
					Element actualSet4 = actualDataset4.addElement("set");
					actualSet4.addAttribute("value", surface_value);
					actualSet4.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					actualSet4.addAttribute("toolText", "0%");
					
					Element designSet1 = designDataset1.addElement("set");
					designSet1.addAttribute("value", "0");
					designSet1.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					Element designSet2 = designDataset2.addElement("set");
					designSet2.addAttribute("value", "0");
					designSet2.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					Element designSet3 = designDataset3.addElement("set");
					designSet3.addAttribute("value", "0");
					designSet3.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
					Element designSet4 = designDataset4.addElement("set");
					designSet4.addAttribute("value", "0");
					designSet4.addAttribute("link", "j-inBrowse('" + projectInfoNo + "')");
				}
			}
		}
		list.add(document1.asXML());
		list.add(document2.asXML());
		list.add(document3.asXML());
		list.add(document4.asXML());
		
		return list;
	}
	
	private List projectDataTransfor(Map design, List<Map> actual){
		List list = new ArrayList();
		Document document1 = DocumentHelper.createDocument();
		Document document2 = DocumentHelper.createDocument();
		Document document3 = DocumentHelper.createDocument();
		Document document4 = DocumentHelper.createDocument();
		Element root1 = document1.addElement("chart");
		Element root2 = document2.addElement("chart");
		Element root3 = document3.addElement("chart");
		Element root4 = document4.addElement("chart");
		root1.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root1.addAttribute("caption", "采集工作量");
		root1.addAttribute("xAxisName", "项目");
		root1.addAttribute("yAxisName", "炮点数");
		root1.addAttribute("showLabels", "1");
		root1.addAttribute("showValues", "0");
		root2.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root2.addAttribute("caption", "测量工作量");
		root2.addAttribute("xAxisName", "项目");
		root2.addAttribute("yAxisName", "接收线炮线公里数和");
		root2.addAttribute("showLabels", "1");
		root2.addAttribute("showValues", "0");
		root3.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root3.addAttribute("caption", "钻井工作量");
		root3.addAttribute("xAxisName", "项目");
		root3.addAttribute("yAxisName", "炮点数");
		root3.addAttribute("showLabels", "1");
		root3.addAttribute("showValues", "0");
		root4.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root4.addAttribute("caption", "表层调查工作量");
		root4.addAttribute("xAxisName", "项目");
		root4.addAttribute("yAxisName", "微测井小折射点数和");
		root4.addAttribute("showLabels", "1");
		root4.addAttribute("showValues", "0");
		
		Element categories1 = root1.addElement("categories");
		Element categories2 = root2.addElement("categories");
		Element categories3 = root3.addElement("categories");
		Element categories4 = root4.addElement("categories");
		Element designDataset1 = root1.addElement("dataset");
		Element designDataset2 = root2.addElement("dataset");
		Element designDataset3 = root3.addElement("dataset");
		Element designDataset4 = root4.addElement("dataset");
		designDataset1.addAttribute("seriesName", "设计炮点数");
		designDataset2.addAttribute("seriesName", "设计接收线公里数与设计炮线公里数的和");
		designDataset3.addAttribute("seriesName", "设计炮点数");
		designDataset4.addAttribute("seriesName", "微测井设计点数与小折射设计点数的和");
		Element actualDataset1 = root1.addElement("dataset");
		Element actualDataset2 = root2.addElement("dataset");
		Element actualDataset3 = root3.addElement("dataset");
		Element actualDataset4 = root4.addElement("dataset");
		actualDataset1.addAttribute("seriesName", "日完成炮点数");
		actualDataset2.addAttribute("seriesName", "日接收线公里数与日炮线公里数的和");
		actualDataset3.addAttribute("seriesName", "日完成炮点数");
		actualDataset4.addAttribute("seriesName", "微测井累积完成点数与小折射累积完成点数");
		if(actual != null){
			for(int i=0; i< actual.size(); i++){
				Map recordMap = actual.get(i);
				String projectName = "" + recordMap.get("project_name");
				String projectInfoNo = "" + recordMap.get("project_info_no");
				String coll_value = "" + recordMap.get("coll_value");
				String measure_value = "" + recordMap.get("measure_value");
				String drill_value = "" + recordMap.get("drill_value");
				String surface_value = "" + recordMap.get("surface_value");
					
				Element category1 = categories1.addElement("category");
				Element category2 = categories2.addElement("category");
				Element category3 = categories3.addElement("category");
				Element category4 = categories4.addElement("category");
				category1.addAttribute("label", projectName);
				category2.addAttribute("label", projectName);
				category3.addAttribute("label", projectName);
				category4.addAttribute("label", projectName);
					
				Element actualSet1 = actualDataset1.addElement("set");
				actualSet1.addAttribute("value", coll_value);
				Element actualSet2 = actualDataset2.addElement("set");
				actualSet2.addAttribute("value", measure_value);
				Element actualSet3 = actualDataset3.addElement("set");
				actualSet3.addAttribute("value", drill_value);
				Element actualSet4 = actualDataset4.addElement("set");
				actualSet4.addAttribute("value", surface_value);
				
				// 取设计数值
				if(design != null){
					String colldailylist = "" + design.get("colldailylist");
					String measuredailylist = "" + design.get("measuredailylist");
					String drilldailylist = "" + design.get("drilldailylist");
					String surfacedailylist = "" + design.get("surfacedailylist");
					
					Element designSet1 = designDataset1.addElement("set");
					designSet1.addAttribute("value", colldailylist);
					Element designSet2 = designDataset2.addElement("set");
					designSet2.addAttribute("value", measuredailylist);
					Element designSet3 = designDataset3.addElement("set");
					designSet3.addAttribute("value", drilldailylist);
					Element designSet4 = designDataset4.addElement("set");
					designSet4.addAttribute("value", surfacedailylist);
					
					Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");//[0-9]+(.[0-9]?)?+
					Matcher isNum1 = pattern.matcher(coll_value);
					Matcher isNum2 = pattern.matcher(colldailylist);
					if(isNum1.matches() && isNum2.matches() && !"0".equals(colldailylist)){
						double d = Long.valueOf(coll_value) / Long.valueOf(colldailylist) * 100;
						actualSet1.addAttribute("toolText", d + "%");
					}else{
						actualSet1.addAttribute("toolText", "0%");
					}
					isNum1 = pattern.matcher(measure_value);
					isNum2 = pattern.matcher(measuredailylist);
					if(isNum1.matches() && isNum2.matches() && !"0".equals(measuredailylist)){
						double d = Long.valueOf(measure_value) / Long.valueOf(measuredailylist) * 100;
						actualSet2.addAttribute("toolText", d + "%");
					}else{
						actualSet2.addAttribute("toolText", "0%");
					}
					isNum1 = pattern.matcher(drill_value);
					isNum2 = pattern.matcher(drilldailylist);
					if(isNum1.matches() && isNum2.matches() && !"0".equals(drilldailylist)){
						double d = Long.valueOf(drill_value) / Long.valueOf(drilldailylist) * 100;
						actualSet3.addAttribute("toolText", d + "%");
					}else{
						actualSet3.addAttribute("toolText", "0%");
					}
					isNum1 = pattern.matcher(surface_value);
					isNum2 = pattern.matcher(surfacedailylist);
					if(isNum1.matches() && isNum2.matches() && !"0".equals(surfacedailylist)){
						double d = Long.valueOf(surface_value) / Long.valueOf(surfacedailylist) * 100;
						actualSet4.addAttribute("toolText", d + "%");
					}else{
						actualSet4.addAttribute("toolText", "0%");
					}
				}else{
					Element designSet1 = designDataset1.addElement("set");
					designSet1.addAttribute("value", "0");
					Element designSet2 = designDataset2.addElement("set");
					designSet2.addAttribute("value", "0");
					Element designSet3 = designDataset3.addElement("set");
					designSet3.addAttribute("value", "0");
					Element designSet4 = designDataset4.addElement("set");
					designSet4.addAttribute("value", "0");
				}
			}
		}
		list.add(document1.asXML());
		list.add(document2.asXML());
		list.add(document3.asXML());
		list.add(document4.asXML());
		
		return list;
	}
}

package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;

public class CopyFatherProject extends Thread {
	
	private Map map = new HashMap();//处理参数
	
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	
	public Map getMap() {
		return map;
	}

	public void setMap(Map map) {
		this.map = map;
	}

	public CopyFatherProject(Map map){
		this.setMap(map);
	}

	 public void run() {
		 
		 //获取需要拷贝子项目的年度项目号
		 String project_father_no = map.get("project_father_no").toString();
		 String querySql = " select * from gp_task_project where project_info_no='"+project_father_no+"'";
		 List faproList = jdbcDao.queryRecords(querySql);
		 if(faproList!=null&&faproList.size()!=0){
			Map tempMap = (Map)faproList.get(0);
			Random r = new Random();
			Map fathproMap = new HashMap();
			fathproMap.put("project_id", "newProj_" + r.nextInt());// 更新project_id字段
			fathproMap.put("prctr", tempMap.get("prctr").toString());
			fathproMap.put("project_source", tempMap.get("projectSource").toString());
			fathproMap.put("view_type", tempMap.get("viewType").toString());
			fathproMap.put("project_business_type", tempMap.get("projectBusinessType").toString());
			
			fathproMap.put("project_type", tempMap.get("projectType").toString());
			fathproMap.put("build_method", tempMap.get("buildMethod").toString());
			fathproMap.put("project_status", tempMap.get("projectStatus").toString());
			fathproMap.put("project_name", tempMap.get("projectName").toString());
			fathproMap.put("acquire_end_time", tempMap.get("acquireEndTime").toString());
			fathproMap.put("design_end_date", tempMap.get("designEndDate").toString());
			fathproMap.put("modifi_date", tempMap.get("modifiDate").toString());
			fathproMap.put("create_date", tempMap.get("createDate").toString());
			fathproMap.put("acquire_start_time", tempMap.get("acquireStartTime").toString());
			
			fathproMap.put("acquire_start_time", tempMap.get("acquireStartTime").toString());
			fathproMap.put("design_start_date", tempMap.get("designStartDate").toString());
			fathproMap.put("project_year", tempMap.get("projectYear").toString());
			fathproMap.put("contract_amount", tempMap.get("contractAmount").toString());
			
			
			fathproMap.put("explore_type", tempMap.get("exploreType").toString());
			fathproMap.put("project_country", tempMap.get("projectCountry").toString());
			fathproMap.put("exploration_method", tempMap.get("explorationMethod").toString());
			fathproMap.put("is_main_project", tempMap.get("isMainProject").toString());
			fathproMap.put("market_classify", tempMap.get("marketClassify").toString());
			fathproMap.put("bsflag", tempMap.get("bsflag").toString());
			
			Serializable project_info_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fathproMap, "GP_TASK_PROJECT");//保存
			System.out.println(project_info_no);
		 }
	 } 
}

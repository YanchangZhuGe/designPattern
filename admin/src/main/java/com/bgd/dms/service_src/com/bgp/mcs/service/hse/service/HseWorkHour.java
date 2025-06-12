package com.bgp.mcs.service.hse.service;

import java.io.Serializable;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;

public class HseWorkHour {

	//HSE百万工时 ----求工时
	public void totalHours() throws Exception {
		
	/*
	 * 二级单位排序
	 * 		select t.org_sub_id, os.org_id, oi.org_abbreviation,t.order_num
  	 *		from bgp_hse_org t
  	 *		join comm_org_subjection os on os.org_subjection_id = t.org_sub_id
     *                       and os.bsflag = '0'
  	 *		join comm_org_information oi on os.org_id = oi.org_id
     *                         and oi.bsflag = '0'
 	 *		start with t.father_org_sub_id = 'C105' and t.org_sub_id not in ('C105083','C105082','C105080','C105079001')
	 *		connect by t.org_sub_id = prior t.father_org_sub_id 
	 *		order by t.order_num
	 * 
	 * BGP_HSE_ORG 最末级的单位
	 * select * from bgp_hse_org t where t.org_sub_id not in (select father_org_sub_id from bgp_hse_org)
	 * 
	 * 发生率统计公式：
	 *  “百万工时可记录事件发生率”等于“5.6.4 事故、事件报告、调查和处理”“事故记录”功能中所有记录中的伤亡人员三个合计数的合，加，“5.6.4 事故、事件报告、调查和处理”“事件信息报告”功能中“事件性质”为限工事件、医疗事件的记录中的受伤害人员四个伤害人数的合，再除以工时；
	 *	“百万工时损工伤亡发生率”等于“5.6.4 事故、事件报告、调查和处理”“事故记录”功能中所有记录中的伤亡人员三个合计数的合，除以工时；
	 *	“百万工时死亡事故发生率”等于“5.6.4 事故、事件报告、调查和处理”“事故记录”功能中所有记录中的伤亡人员死亡合计数，除以工时。
	 *	以上均为统计本行所属单位或下属单位相关记录、相关工时，合计行统计的是所属列相关总人数/合计行总工时。
	 * 
	 * 
	 * */	
		System.out.println("************************************************************************************************************");
		System.out.println("开始执行多项目的百万工时！！！");
		
		IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
		 RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		
		InetAddress addr = InetAddress.getLocalHost();
		String ip=addr.getHostAddress().toString();//获得本机IP
		
		String sql2 = "select to_char(sysdate,'day') week,to_char(sysdate-1,'yyyy-MM-dd') yesterday,to_char(sysdate,'yyyy-MM-dd') today  from dual";
		Map map2 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql2);
		String weekDay = (String)map2.get("week");
		String today = (String)map2.get("today");
		String yesterday = (String)map2.get("yesterday");
		if(weekDay.equals("星期一")){
			weekDay = "monday";
		}else if(weekDay.equals("星期二")){
			weekDay = "tuesday";
		}else if(weekDay.equals("星期三")){
			weekDay = "wednesday";
		}else if(weekDay.equals("星期四")){
			weekDay = "thursday";
		}else if(weekDay.equals("星期五")){
			weekDay = "friday";
		}else if(weekDay.equals("星期六")){
			weekDay = "saturday";
		}else if(weekDay.equals("星期日")){
			weekDay = "sunday";
		}
		
		int hours = 1;
		int allHours = 0;
		String sqlSub = "select * from bgp_hse_workhour_set where bsflag='0' and project_info_no is null";
		List subList = BeanFactory.getQueryJdbcDAO().queryRecords(sqlSub); 
		for(int j=0;j<subList.size();j++){
			Map subMap = (Map)subList.get(j);
			String subId = (String)subMap.get("subjectionId");
			allHours = 0;
			for(int i=1;i<7;i++){
				if(i==1){
					hours = 24;
				}else if(i==2){
					hours = 16;
				}else if(i==3){
					hours = 12;
				}else if(i==4){
					hours = 8;
				}else if(i==5){
					hours = 4;
				}else if(i==6){
					hours = 2;
				}
				String sql = "select * from bgp_hse_workhour_set ws left join bgp_hse_workhour_detail wd on ws.hse_workhour_id = wd.hse_workhour_id where ws.bsflag = '0' and ws.project_info_no is null and wd.type='"+i+"'  and ws.subjection_id='"+subId+"' order by ws.subjection_id asc";
				Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
				if(map!=null){
					String week = (String)map.get(weekDay);
					String people_num = (String)map.get("peopleNum")==""?"0":(String)map.get("peopleNum");
					if(week.equals("0")){
						allHours += Integer.parseInt(people_num) * hours;
					}
				}
			}
			
			String yesterdaySql = "select * from bgp_hse_workhour_all wa where wa.subjection_id='"+subId+"' and to_char(wa.create_date,'yyyy-MM-dd')='"+yesterday+"'";
			Map yesterdayMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(yesterdaySql);
			if(yesterdayMap!=null&&!yesterdayMap.equals("")){
				String workHour = (String)yesterdayMap.get("workhour")=="" ? "0" : (String)yesterdayMap.get("workhour");
				int yesterdayHours = Integer.parseInt(workHour);
				allHours  = allHours + yesterdayHours ;
			}
			
			double acc_all4 = 0;
			double eve_all4 = 0;
			double dieNum4 = 0;
			
			//根据subId算出该单位是第几层的，在选择事故时间中的，是基层单位还是下属单位
			String levelSql = "select t.org_sub_id,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105'  start with t.org_sub_id = '"+subId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			List levelList = BeanFactory.getQueryJdbcDAO().queryRecords(levelSql);
			String level = "fourth_org='";
			if(levelList.size()>2){
				level = "fourth_org='";
			}
			if(levelList.size()==2){
				level = "third_org='";
			}
			
			
			//事故记录中的伤亡人员和的SQL
			String	accSql4 = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and  an."+level+subId+"'";
			Map accMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql4);
			if(accMap4!=null&&!accMap4.equals("")){
				String die4 = (String)accMap4.get("die")=="" ? "0" : (String)accMap4.get("die");
				String harm4 = (String)accMap4.get("harm")=="" ? "0" : (String)accMap4.get("harm");
				String injure4 = (String)accMap4.get("injure")=="" ? "0" : (String)accMap4.get("injure");
				dieNum4 = Integer.parseInt(die4);
				acc_all4 = Integer.parseInt(die4)+Integer.parseInt(harm4)+Integer.parseInt(injure4);
			}
			//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
			String eveSql4 = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t."+level+subId+"' and t.event_property in ('1','2')";
			Map eveMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql4);
			if(eveMap4!=null&&!eveMap4.equals("")){
				String owner_num4 = (String)eveMap4.get("ownerNum")=="" ? "0" : (String)eveMap4.get("ownerNum");
				String out_num4 = (String)eveMap4.get("outNum")=="" ? "0" : (String)eveMap4.get("outNum");
				String stock_num4 = (String)eveMap4.get("stockNum")=="" ? "0" : (String)eveMap4.get("stockNum");
				String group_num4 = (String)eveMap4.get("groupNum")=="" ? "0" : (String)eveMap4.get("groupNum");
				eve_all4 = Integer.parseInt(owner_num4)+Integer.parseInt(out_num4)+Integer.parseInt(stock_num4)+Integer.parseInt(group_num4);
			}
			
				double accEvePercent4 = 0; 
				double accPercent4 = 0;				
				double diePercent4 = 0;
			if(allHours!=0){
				accEvePercent4 = (acc_all4+eve_all4)/allHours; //百万工时可记录事件发生率
				accPercent4 = acc_all4/allHours;				//百万工时损工伤亡发生率
				diePercent4 = dieNum4/allHours;				//百万工时死亡事故发生率
			}
			System.out.println(allHours);
			Map thirdMap = new HashMap();
			thirdMap.put("SUBJECTION_ID", subId);
			thirdMap.put("WORKHOUR", allHours);
			thirdMap.put("RECORD_PERCENT", accEvePercent4);
			thirdMap.put("INJURE_PERCENT", accPercent4);
			thirdMap.put("DIE_PERCENT", diePercent4);
			thirdMap.put("BSFLAG", "0");
			thirdMap.put("CREATOR_ID", ip);
			thirdMap.put("CREATE_DATE", new Date());
			thirdMap.put("UPDATOR_ID", "");
			thirdMap.put("MODIFI_DATE", new Date());
			
			pureJdbcDao.saveOrUpdateEntity(thirdMap,"BGP_HSE_WORKHOUR_ALL");
		}
		
		
		
		
		//二级单位添加   +  三级单位添加
		String secSql = "select t.org_sub_id, os.org_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where t.father_org_sub_id = 'C105' and t.org_sub_id not in ('C105083','C105082','C105080','C105079001') and t.org_sub_id not in (select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)   order by t.order_num";
		List secList = BeanFactory.getQueryJdbcDAO().queryRecords(secSql);
		for(int m=0;m<secList.size();m++){
			Map secMap = (Map)secList.get(m);
			String subjectionId = (String)secMap.get("orgSubId");

			String thirdOrgSql = "select * from bgp_hse_org t where t.father_org_sub_id='"+subjectionId+"'  and t.org_sub_id not in (select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)";
			List thirdList = BeanFactory.getQueryJdbcDAO().queryRecords(thirdOrgSql);
			for(int n=0;n<thirdList.size();n++){
				Map thirdMap = (Map)thirdList.get(n);
				String thirdOrgId = (String)thirdMap.get("orgSubId"); 
				
				String sumSql3 = "select sum(workhour) sum from bgp_hse_workhour_all wa where wa.bsflag='0' and wa.subjection_id like '"+thirdOrgId+"%' and to_char(wa.create_date,'yyyy-MM-dd') = '"+today+"' and wa.subjection_id in  ( select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)";
				Map sumMap3 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sumSql3);
				if(sumMap3.get("sum")==null||sumMap3.get("sum").equals("")){
					allHours = 0;
				}else{
					allHours = Integer.parseInt((String)sumMap3.get("sum"));
					System.out.println(allHours);
				}
				
				double acc_all3 = 0;
				double eve_all3 = 0;
				double dieNum3 = 0;
				//事故记录中的伤亡人员和的SQL
				String	accSql3 = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and  an.third_org='"+thirdOrgId+"'";
				Map accMap3 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql3);
				if(accMap3!=null&&!accMap3.equals("")){
					String die3 = (String)accMap3.get("die")=="" ? "0" : (String)accMap3.get("die");
					String harm3 = (String)accMap3.get("harm")=="" ? "0" : (String)accMap3.get("harm");
					String injure3 = (String)accMap3.get("injure")=="" ? "0" : (String)accMap3.get("injure");
					dieNum3 = Integer.parseInt(die3);
					acc_all3 = Integer.parseInt(die3)+Integer.parseInt(harm3)+Integer.parseInt(injure3);
				}
				//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
				String eveSql3 = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.third_org='"+thirdOrgId+"' and t.event_property in ('1','2')";
				Map eveMap3 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql3);
				if(eveMap3!=null&&!eveMap3.equals("")){
					String owner_num3 = (String)eveMap3.get("ownerNum")=="" ? "0" : (String)eveMap3.get("ownerNum");
					String out_num3 = (String)eveMap3.get("outNum")=="" ? "0" : (String)eveMap3.get("outNum");
					String stock_num3 = (String)eveMap3.get("stockNum")=="" ? "0" : (String)eveMap3.get("stockNum");
					String group_num3 = (String)eveMap3.get("groupNum")=="" ? "0" : (String)eveMap3.get("groupNum");
					eve_all3 = Integer.parseInt(owner_num3)+Integer.parseInt(out_num3)+Integer.parseInt(stock_num3)+Integer.parseInt(group_num3);
				}
				
				double accEvePercent3 = 0; 
				double accPercent3 = 0;				
				double diePercent3 = 0;
				if(allHours!=0){
					accEvePercent3 = (acc_all3+eve_all3)/allHours; //百万工时可记录事件发生率
					accPercent3 = acc_all3/allHours;				//百万工时损工伤亡发生率
					diePercent3 = dieNum3/allHours;				//百万工时死亡事故发生率
				}
				Map map3 = new HashMap();
				map3.put("SUBJECTION_ID", thirdOrgId);
				map3.put("WORKHOUR", allHours);
				map3.put("RECORD_PERCENT", accEvePercent3);
				map3.put("INJURE_PERCENT", accPercent3);
				map3.put("DIE_PERCENT", diePercent3);
				map3.put("BSFLAG", "0");
				map3.put("CREATOR_ID", ip);
				map3.put("CREATE_DATE", new Date());
				map3.put("UPDATOR_ID", "");
				map3.put("MODIFI_DATE", new Date());
				
				pureJdbcDao.saveOrUpdateEntity(map3,"BGP_HSE_WORKHOUR_ALL");
			}
			//百万工时求和
			String sumSql = "select sum(workhour) sum from bgp_hse_workhour_all wa where wa.bsflag='0' and wa.subjection_id like '"+subjectionId+"%' and to_char(wa.create_date,'yyyy-MM-dd') = '"+today+"' and wa.subjection_id in  ( select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is null)";
			Map sumMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sumSql);
			if(sumMap.get("sum")==null||sumMap.get("sum").equals("")){
				allHours = 0;
			}else{
				allHours = Integer.parseInt((String)sumMap.get("sum"));
				System.out.println(allHours);
			}
			
			double acc_all = 0;
			double eve_all = 0;
			double dieNum = 0;
			//事故记录中的伤亡人员和的SQL
			String	accSql = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and  an.second_org='"+subjectionId+"'";
			Map accMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql);
			if(accMap!=null&&!accMap.equals("")){
				String die = (String)accMap.get("die")=="" ? "0" : (String)accMap.get("die");
				String harm = (String)accMap.get("harm")=="" ? "0" : (String)accMap.get("harm");
				String injure = (String)accMap.get("injure")=="" ? "0" : (String)accMap.get("injure");
				dieNum = Integer.parseInt(die);
				acc_all = Integer.parseInt(die)+Integer.parseInt(harm)+Integer.parseInt(injure);
			}
			//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
			String eveSql = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.second_org='"+subjectionId+"' and t.event_property in ('1','2')";
			Map eveMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql);
			if(eveMap!=null&&!eveMap.equals("")){
				String owner_num = (String)eveMap.get("ownerNum")=="" ? "0" : (String)eveMap.get("ownerNum");
				String out_num = (String)eveMap.get("outNum")=="" ? "0" : (String)eveMap.get("outNum");
				String stock_num = (String)eveMap.get("stockNum")=="" ? "0" : (String)eveMap.get("stockNum");
				String group_num = (String)eveMap.get("groupNum")=="" ? "0" : (String)eveMap.get("groupNum");
				eve_all = Integer.parseInt(owner_num)+Integer.parseInt(out_num)+Integer.parseInt(stock_num)+Integer.parseInt(group_num);
			}
			
			
			double accEvePercent = 0; 
			double accPercent = 0;				
			double diePercent = 0;
			if(allHours!=0){
				accEvePercent = (acc_all+eve_all)/allHours; //百万工时可记录事件发生率
				accPercent = acc_all/allHours;				//百万工时损工伤亡发生率
				diePercent = dieNum/allHours;				//百万工时死亡事故发生率
			}
			Map secondMap = new HashMap();
			secondMap.put("SUBJECTION_ID", subjectionId);
			secondMap.put("WORKHOUR", allHours);
			secondMap.put("RECORD_PERCENT", accEvePercent);
			secondMap.put("INJURE_PERCENT", accPercent);
			secondMap.put("DIE_PERCENT", diePercent);
			secondMap.put("BSFLAG", "0");
			secondMap.put("CREATOR_ID", ip);
			secondMap.put("CREATE_DATE", new Date());
			secondMap.put("UPDATOR_ID", "");
			secondMap.put("MODIFI_DATE", new Date());
			
			pureJdbcDao.saveOrUpdateEntity(secondMap,"BGP_HSE_WORKHOUR_ALL");
		}
	System.out.println("多多多**********************************************************************************************");
	System.out.println("多项目的百万工时执行结束！！！");
	
	
	//单项目百万工时
	System.out.println("单单单*************************************************************************************************");
	System.out.println("开始执单项目的百万工时！！！");
		
	int singleHours = 1;
	int allSingleHours = 0;
	String slqProject = "select * from bgp_hse_workhour_set where bsflag='0' and project_info_no is not null";
	List projectList = BeanFactory.getQueryJdbcDAO().queryRecords(slqProject); 
	for(int j=0;j<projectList.size();j++){
		Map subMap = (Map)projectList.get(j);
		String subId = (String)subMap.get("subjectionId");
		String projectInfoNo = (String)subMap.get("projectInfoNo");
		allSingleHours = 0;
		
		//判断项目是否结束，项目结束不统计百万工时
		String projectIfStop = "select t.project_status from gp_task_project t where t.bsflag='0' and t.project_info_no='"+projectInfoNo+"'";
		Map mapProject = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(projectIfStop);
		if(mapProject!=null&&!mapProject.get("projectStatus").equals("5000100001000000003")){
			
		for(int i=1;i<7;i++){
			if(i==1){
				singleHours = 24;
			}else if(i==2){
				singleHours = 16;
			}else if(i==3){
				singleHours = 12;
			}else if(i==4){
				singleHours = 8;
			}else if(i==5){
				singleHours = 4;
			}else if(i==6){
				singleHours = 2;
			}
			String sql = "select * from bgp_hse_workhour_set ws left join bgp_hse_workhour_detail wd on ws.hse_workhour_id = wd.hse_workhour_id where ws.bsflag = '0' and ws.project_info_no is not null and wd.type='"+i+"'  and ws.project_info_no='"+projectInfoNo+"'";
			Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			if(map!=null){
				String week = (String)map.get(weekDay);
				String people_num = (String)map.get("peopleNum")==""?"0":(String)map.get("peopleNum");
				if(week.equals("0")){
					allSingleHours += Integer.parseInt(people_num) * singleHours;
				}
			}
		}
		}
		
		String yesterdaySql2 = "select * from bgp_hse_workhour_single wa where wa.project_info_no='"+projectInfoNo+"' and to_char(wa.create_date,'yyyy-MM-dd')='"+yesterday+"'";
		Map yesterdayMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(yesterdaySql2);
		if(yesterdayMap!=null&&!yesterdayMap.equals("")){
			String workHour = (String)yesterdayMap.get("workhour")=="" ? "0" : (String)yesterdayMap.get("workhour");
			int yesterdayHours = Integer.parseInt(workHour);
			allSingleHours  = allSingleHours + yesterdayHours ;
		}
		
		double acc_all4 = 0;
		double eve_all4 = 0;
		double dieNum4 = 0;
		
		//根据subId算出该单位是第几层的，在选择事故时间中的，是基层单位还是下属单位
		String levelSql = "select t.org_sub_id,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105'  start with t.org_sub_id = '"+subId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		List levelList = BeanFactory.getQueryJdbcDAO().queryRecords(levelSql);
		String level = "fourth_org='";
		if(levelList.size()>2){
			level = "fourth_org='";
		}
		if(levelList.size()==2){
			level = "third_org='";
		}
		
		
		//事故记录中的伤亡人员和的SQL
		String	accSql4 = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and an.project_info_no='"+projectInfoNo+"'";
		Map accMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql4);
		if(accMap4!=null&&!accMap4.equals("")){
			String die4 = (String)accMap4.get("die")=="" ? "0" : (String)accMap4.get("die");
			String harm4 = (String)accMap4.get("harm")=="" ? "0" : (String)accMap4.get("harm");
			String injure4 = (String)accMap4.get("injure")=="" ? "0" : (String)accMap4.get("injure");
			dieNum4 = Integer.parseInt(die4);
			acc_all4 = Integer.parseInt(die4)+Integer.parseInt(harm4)+Integer.parseInt(injure4);
		}
		//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
		String eveSql4 = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.project_info_no='"+projectInfoNo+"' and t.event_property in ('1','2')";
		Map eveMap4 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql4);
		if(eveMap4!=null&&!eveMap4.equals("")){
			String owner_num4 = (String)eveMap4.get("ownerNum")=="" ? "0" : (String)eveMap4.get("ownerNum");
			String out_num4 = (String)eveMap4.get("outNum")=="" ? "0" : (String)eveMap4.get("outNum");
			String stock_num4 = (String)eveMap4.get("stockNum")=="" ? "0" : (String)eveMap4.get("stockNum");
			String group_num4 = (String)eveMap4.get("groupNum")=="" ? "0" : (String)eveMap4.get("groupNum");
			eve_all4 = Integer.parseInt(owner_num4)+Integer.parseInt(out_num4)+Integer.parseInt(stock_num4)+Integer.parseInt(group_num4);
		}
		
			double accEvePercent4 = 0; 
			double accPercent4 = 0;				
			double diePercent4 = 0;
		if(allSingleHours!=0){
			accEvePercent4 = (acc_all4+eve_all4)/allSingleHours; //百万工时可记录事件发生率
			accPercent4 = acc_all4/allSingleHours;				//百万工时损工伤亡发生率
			diePercent4 = dieNum4/allSingleHours;				//百万工时死亡事故发生率
		}
		
		System.out.println("***************************************************************************************************");
		System.out.println("subId="+subId);
		System.out.println("workhour="+allSingleHours);
		System.out.println("accEvePercent4="+accEvePercent4);
		System.out.println("accPercent4="+accPercent4);
		System.out.println("diePercent4="+diePercent4);
		System.out.println("***************************************************************************************************");
		
		
		
		Map thirdMap = new HashMap();
		thirdMap.put("SUBJECTION_ID", subId);
		thirdMap.put("WORKHOUR", allSingleHours);
		thirdMap.put("RECORD_PERCENT", accEvePercent4);
		thirdMap.put("INJURE_PERCENT", accPercent4);
		thirdMap.put("DIE_PERCENT", diePercent4);
		thirdMap.put("BSFLAG", "0");
		thirdMap.put("CREATOR_ID", ip);
		thirdMap.put("CREATE_DATE", new Date());
		thirdMap.put("UPDATOR_ID", "");
		thirdMap.put("MODIFI_DATE", new Date());
		thirdMap.put("PROJECT_INFO_NO", projectInfoNo);
		
		pureJdbcDao.saveOrUpdateEntity(thirdMap,"BGP_HSE_WORKHOUR_SINGLE");
	}
	

	String secSingleSql = " select * from bgp_hse_org ho where ho.org_sub_id in ('C105063','C105005000','C105001002','C105005004','C105002','C105005001','C105001005','C105001003','C105008','C105007')  and ho.org_sub_id not in (select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is not null) order by ho.order_num";
	List secSingleList = BeanFactory.getQueryJdbcDAO().queryRecords(secSingleSql);
	for(int m=0;m<secSingleList.size();m++){
		Map secMap = (Map)secSingleList.get(m);
		String subjectionId = (String)secMap.get("orgSubId");

		//百万工时求和
		String sumSql = "select sum(workhour) sum from bgp_hse_workhour_single wa where wa.bsflag='0' and wa.subjection_id like '"+subjectionId+"%' and to_char(wa.create_date,'yyyy-MM-dd') = '"+today+"' and wa.subjection_id in  ( select subjection_id from bgp_hse_workhour_set ws where ws.bsflag='0' and ws.project_info_no is not null)";
		Map sumMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sumSql);
		if(sumMap.get("sum")==null||sumMap.get("sum").equals("")){
			allHours = 0;
		}else{
			allHours = Integer.parseInt((String)sumMap.get("sum"));
			System.out.println(allHours);
		}
		
		double acc_all = 0;
		double eve_all = 0;
		double dieNum = 0;
		//事故记录中的伤亡人员和的SQL
		String	accSql = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0' and an.project_info_no is not null and  an.second_org='"+subjectionId+"'";
		Map accMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql);
		if(accMap!=null&&!accMap.equals("")){
			String die = (String)accMap.get("die")=="" ? "0" : (String)accMap.get("die");
			String harm = (String)accMap.get("harm")=="" ? "0" : (String)accMap.get("harm");
			String injure = (String)accMap.get("injure")=="" ? "0" : (String)accMap.get("injure");
			dieNum = Integer.parseInt(die);
			acc_all = Integer.parseInt(die)+Integer.parseInt(harm)+Integer.parseInt(injure);
		}
		//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
		String eveSql = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.project_info_no is not null and t.second_org='"+subjectionId+"' and t.event_property in ('1','2')";
		Map eveMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql);
		if(eveMap!=null&&!eveMap.equals("")){
			String owner_num = (String)eveMap.get("ownerNum")=="" ? "0" : (String)eveMap.get("ownerNum");
			String out_num = (String)eveMap.get("outNum")=="" ? "0" : (String)eveMap.get("outNum");
			String stock_num = (String)eveMap.get("stockNum")=="" ? "0" : (String)eveMap.get("stockNum");
			String group_num = (String)eveMap.get("groupNum")=="" ? "0" : (String)eveMap.get("groupNum");
			eve_all = Integer.parseInt(owner_num)+Integer.parseInt(out_num)+Integer.parseInt(stock_num)+Integer.parseInt(group_num);
		}
		
		
		double accEvePercent = 0; 
		double accPercent = 0;				
		double diePercent = 0;
		if(allHours!=0){
			accEvePercent = (acc_all+eve_all)/allHours; //百万工时可记录事件发生率
			accPercent = acc_all/allHours;				//百万工时损工伤亡发生率
			diePercent = dieNum/allHours;				//百万工时死亡事故发生率
		}
		Map secondMap = new HashMap();
		secondMap.put("SUBJECTION_ID", subjectionId);
		secondMap.put("WORKHOUR", allHours);
		secondMap.put("RECORD_PERCENT", accEvePercent);
		secondMap.put("INJURE_PERCENT", accPercent);
		secondMap.put("DIE_PERCENT", diePercent);
		secondMap.put("BSFLAG", "0");
		secondMap.put("CREATOR_ID", "");
		secondMap.put("CREATE_DATE", new Date());
		secondMap.put("UPDATOR_ID", "");
		secondMap.put("MODIFI_DATE", new Date());
		
		pureJdbcDao.saveOrUpdateEntity(secondMap,"BGP_HSE_WORKHOUR_SINGLE");
	}
	System.out.println("单单单*************************************************************************************************");
	System.out.println("项目的百万工时执行结束！！！");
	
	
	}
	
	/*
	 * select level,t.* from bgp_op_cost_template  t
		start with parent_id = '01'
		connect by prior template_id = parent_id
	 * */
	//模板表中导入数据，每月的1号开始，创建新数据
	public void createEnvironmentManage() throws Exception {
		
		
		IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		
		String sql = "select t.org_sub_id, os.org_id,t.father_org_sub_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where t.father_org_sub_id in ( select org_sub_id from bgp_hse_org tt where tt.father_org_sub_id = 'C105') and t.environment_flag='1' order by t.order_num";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		for(int i=0;i<list.size();i++){
			Map mapOrg = (Map)list.get(i);
			String org_sub_id = (String)mapOrg.get("orgSubId");
			Map map = new HashMap();
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("STATUS", "0");
			map.put("TYPE","0");
			map.put("BSFLAG","0");
			map.put("CREATE_DATE", today);
			map.put("MODIFI_DATE", new Date());
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
			String hse_environment_id = id.toString();
			
			String sqlInsert = "insert into bgp_hse_environment_detail(hse_detail_id,project_name,unit,model_father_id,total_flag,order_num,hse_model_id,hse_environment_id) select sys_guid() hse_detail_id,project_name,unit,father_id model_father_id,total_flag,order_num,hse_model_id,'"+hse_environment_id+"' from bgp_hse_environment_model ";
			jdbcTemplate.execute(sqlInsert);
			
			String sqlUpdate = "update bgp_hse_environment_detail t  set t.father_id = (select hse_detail_id from bgp_hse_environment_detail d where d.hse_model_id = t.model_father_id  and d.hse_environment_id = '"+hse_environment_id+"') where t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_hse_environment_detail t set t.father_id = '101' where t.father_id is null and t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
		}
		
		String sql2 = "select t.org_sub_id, os.org_id,t.father_org_sub_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where  t.org_sub_id in ( select org_sub_id from bgp_hse_org tt where tt.father_org_sub_id = 'C105') and t.environment_flag='1' order by t.order_num";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		for(int i=0;i<list2.size();i++){
			Map mapOrg = (Map)list2.get(i);
			String org_sub_id = (String)mapOrg.get("orgSubId");
			Map map = new HashMap();
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("STATUS", "0");
			map.put("TYPE","1");
			map.put("BSFLAG","0");
			map.put("CREATE_DATE", today);
			map.put("MODIFI_DATE", new Date());
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
			String hse_environment_id = id.toString();
			
			String sqlInsert = "insert into bgp_hse_environment_detail(hse_detail_id,project_name,unit,model_father_id,total_flag,order_num,hse_model_id,hse_environment_id) select sys_guid() hse_detail_id,project_name,unit,father_id model_father_id,total_flag,order_num,hse_model_id,'"+hse_environment_id+"' from bgp_hse_environment_model ";
			jdbcTemplate.execute(sqlInsert);
			
			String sqlUpdate = "update bgp_hse_environment_detail t  set t.father_id = (select hse_detail_id from bgp_hse_environment_detail d where d.hse_model_id = t.model_father_id  and d.hse_environment_id = '"+hse_environment_id+"') where t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_hse_environment_detail t set t.father_id = '101' where t.father_id is null and t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
		}
		
		String sql3 = "select t.org_sub_id, os.org_id,t.father_org_sub_id, oi.org_abbreviation,t.order_num from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' where t.org_sub_id = 'C105' order by t.order_num";
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		for(int i=0;i<list3.size();i++){
			Map mapOrg = (Map)list3.get(i);
			String org_sub_id = (String)mapOrg.get("orgSubId");
			Map map = new HashMap();
			map.put("ORG_SUB_ID", org_sub_id);
			map.put("STATUS", "0");
			map.put("TYPE","2");
			map.put("BSFLAG","0");
			map.put("CREATE_DATE", today);
			map.put("MODIFI_DATE", new Date());
			Serializable id = pureJdbcDao.saveOrUpdateEntity(map,"BGP_HSE_ENVIRONMENT");
			String hse_environment_id = id.toString();
			
			String sqlInsert = "insert into bgp_hse_environment_detail(hse_detail_id,project_name,unit,model_father_id,total_flag,order_num,hse_model_id,hse_environment_id) select sys_guid() hse_detail_id,project_name,unit,father_id model_father_id,total_flag,order_num,hse_model_id,'"+hse_environment_id+"' from bgp_hse_environment_model ";
			jdbcTemplate.execute(sqlInsert);
			
			String sqlUpdate = "update bgp_hse_environment_detail t  set t.father_id = (select hse_detail_id from bgp_hse_environment_detail d where d.hse_model_id = t.model_father_id  and d.hse_environment_id = '"+hse_environment_id+"') where t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_hse_environment_detail t set t.father_id = '101' where t.father_id is null and t.hse_environment_id = '"+hse_environment_id+"'";
			jdbcTemplate.execute(sqlUpdate);
		}
		
	}
	
	
	
	
	
	
}

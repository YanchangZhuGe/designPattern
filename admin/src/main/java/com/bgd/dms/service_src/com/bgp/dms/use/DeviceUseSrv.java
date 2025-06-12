package com.bgp.dms.use;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

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
 * @author chenchong 2015.5.11
 *
 */
public class DeviceUseSrv extends BaseService{
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	
	public DeviceUseSrv(){
		log = LogFactory.getLogger(DeviceUseSrv.class);
	}
	/**	
	 * 获得机构主要设备利用率对比,输出成图表显示
	 * @return dateSets
	 */
	public ISrvMsg getUseRateForOrg(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		System.out.println("ccc--");
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		// 级别(默认为第一级)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//截取长度(编码规则是每级编码长度加3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree编码(默认为空，级别为第一级)
		String devTreeId = reqDTO.getValue("devTreeId");
		// 物探处
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 国内国外
		String country = reqDTO.getValue("country");
		if(StringUtils.isBlank(country)){
			country="";
		}
		// 开始时间
		String startDate = reqDTO.getValue("startDate");
		// 结束时间
		String endDate = reqDTO.getValue("endDate");
		String _startDate="";
		String _endDate="";
		if(StringUtils.isNotBlank(startDate)){
			_startDate=startDate;
		}else{
			_startDate=(currentYear+"-01-01").trim();
		}
		if(StringUtils.isNotBlank(endDate)){
			_endDate=endDate;
		}else{
			_endDate=currentDate;
		}
		StringBuilder sql = new StringBuilder(
				"select i.org_abbreviation as label,"
						+ " nvl(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),0) as userate "
						+ " from gms_device_dailyhistory dh left join comm_org_subjection s on s.org_subjection_id = dh.org_subjection_id "
						+"  left join comm_org_information i on i.org_id = s.org_id"
						+"  where (dh.org_subjection_id like 'C105002%' or"
						+"  dh.org_subjection_id like 'C105001005%' or"
						+"  dh.org_subjection_id like 'C105001002%' or"
						+"  dh.org_subjection_id like 'C105001003%' or"
						+"  dh.org_subjection_id like 'C105001004%' or"
						+"  dh.org_subjection_id like 'C105005004%' or"
						+"  dh.org_subjection_id like 'C105005000%' or"
						+"  dh.org_subjection_id like 'C105005001%' or"
						+"  dh.org_subjection_id like 'C105007%' or"
						+"  dh.org_subjection_id like 'C105063%' or"
						+"  dh.org_subjection_id like 'C105086%' or"
						+"  dh.org_subjection_id like 'C105006%')");
						
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// 国内国外
		if(StringUtils.isNotBlank(country)){
			sql.append(" and dh.country='"+country+"'");
		}
		// 开始时间
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append("  group by dh.org_subjection_id, i.org_abbreviation  order by dh.org_subjection_id ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String value = "0";//默认完好率
				set.addAttribute("label", map.get("label").toString());
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
				set.addAttribute("value", value);
		}
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 获取当前年度
	 * 
	 * @return
	 */
	public String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}

	
	/**
	 * 获取当前时间
	 * 
	 * @return
	 */
	public String getCurrentDate() {
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd");
		return dateFormat.format(now);
	}
	
	/**
	 * NEWMETHOD
	 * 项目综合数据查询
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProject(ISrvMsg msg) throws Exception {
		log.info("queryProject");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectName = msg.getValue("projectName");//项目名称
		String orgSubjectionId = msg.getValue("orgSubjectionId");//物探处
		String projectType = msg.getValue("projectType");//项目类型
		String projectYear = msg.getValue("projectYear");//项目年度
		String isMainProject = msg.getValue("isMainProject");//重要程度
		String projectStatus = msg.getValue("projectStatus");//项目状态
		String orgName = msg.getValue("orgName");//施工队伍
		String explorationMethod = msg.getValue("explorationMethod");//勘探方法
		String projectArea = msg.getValue("projectArea");//所属行政区域

		StringBuffer querySql = new StringBuffer();
		querySql.append("select p.*,dy.org_id as org_id22,(select t.coding_name  from comm_coding_sort_detail t"+
			" where t.coding_code_id = (select superior_code_id from comm_coding_sort_detail where coding_code_id = p.manage_org)) || ' ' ||  ccsd.coding_name as manage_org_name,sap.prctr_name as prctr_name,ct.project_name as pro_name,"+
			" p.design_end_date - p.design_start_date as duration_date,p6.object_id as project_object_id,"+
			" nvl(p.project_start_time, p.acquire_start_time) as start_date,nvl(p.project_end_time, p.acquire_end_time) as end_date,"+
			" dy.org_id,org.org_abbreviation as org_name,(case p.project_status when '5000100001000000001' then '1'"+
			" when '5000100001000000002' then '2' when '5000100001000000003' then '4' when '5000100001000000004' then '3'"+
			" when '5000100001000000005' then '5' else '6' end) pro_status,"+
			" case when dy.org_subjection_id like 'C105001005%' then '塔里木物探处' when dy.org_subjection_id like 'C105001002%' then '新疆物探处'"+
			" when dy.org_subjection_id like 'C105001003%' then '吐哈物探处' when dy.org_subjection_id like 'C105001004%' then '青海物探处'"+
			" when dy.org_subjection_id like 'C105005004%' then '长庆物探处' when dy.org_subjection_id like 'C105005000%' then '华北物探处'"+
			" when dy.org_subjection_id like 'C105005001%' then '新兴物探开发处' when dy.org_subjection_id like 'C105007%' then '大港物探处'"+
			" when dy.org_subjection_id like 'C105063%' then '辽河物探处' when dy.org_subjection_id like 'C105086%' then '深海物探处'"+
			" when dy.org_subjection_id like 'C105008%' then '综合物化处' when dy.org_subjection_id like 'C105002%' then '国际勘探事业部'"+
			" when dy.org_subjection_id like 'C105006%' then '装备服务处' when dy.org_subjection_id like 'C105003%' then '研究院'"+
			" when dy.org_subjection_id like 'C105017%' then '矿区服务事业部' else org.org_abbreviation end as owning_org_name_desc"+
			" from gp_task_project p "+
			" left join gp_task_project_dynamic dy on dy.bsflag = '0'  and dy.project_info_no =  p.project_info_no and dy.exploration_method =p.exploration_method"+
			" left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'"+
			" left join bgp_pm_sap_org sap on sap.prctr = p.prctr left join bgp_p6_project p6 on p6.project_info_no =  p.project_info_no and p6.bsflag = '0'"+
			" left join gp_workarea_diviede wd on wd.workarea_no = p.workarea_no and wd.bsflag = '0' "+
			" left join comm_org_information org on org.org_id = dy.org_id and org.bsflag = '0' left join gp_ops_epg_task_project ct on ct.project_info_no = p.spare2"+
			" where p.bsflag = '0'");
		
		if (StringUtils.isNotBlank(projectName)) {//项目名称
			querySql.append(" and p.project_name like '%"+projectName+"%' ");
		}		
		if (StringUtils.isNotBlank(orgSubjectionId)) {//物探处
			querySql.append(" and dy.org_subjection_id like '%"+orgSubjectionId+"%' ");
		}
		if (StringUtils.isNotBlank(projectType)) {//项目类型
			querySql.append(" and p.project_type like '%"+projectType+"%' ");
		}
		if (StringUtils.isNotBlank(projectYear)) {//年度
			querySql.append(" and p.project_year like '%"+projectYear+"%' ");
		}
		if (StringUtils.isNotBlank(isMainProject)) {//重要程度
			querySql.append(" and p.is_main_project like '%"+projectYear+"%' ");
		}
		if (StringUtils.isNotBlank(projectStatus)) {//项目状态
			querySql.append(" and p.project_status like '%"+projectStatus+"%' ");
		}
		if (StringUtils.isNotBlank(orgName)) {//施工队伍
			querySql.append(" and org.org_abbreviation like '%"+orgName+"%' ");
		}
		if (StringUtils.isNotBlank(explorationMethod)) {//勘探方法
			querySql.append(" and p.exploration_method like '%"+explorationMethod+"%' ");
		}
		if (StringUtils.isNotBlank(projectArea)) {//所属行政区域
			querySql.append(" and wd.region_name like '%"+projectArea+"%' ");
		}
		querySql.append("order by case "
				+ "when p.project_type = '5000100004000000001' then 1 "   //陆地项目
				+ "when p.project_type = '5000100004000000005' then 2 "   //地震项目
				+ "when p.project_type = '5000100004000000007' then 3 "   //陆地和浅海项目
				+ "when p.project_type = '5000100004000000002' then 4 "   //浅海项目
				+ "when p.project_type = '5000100004000000010' then 5 "   //滩浅海过渡带
				+ "when p.project_type = '5000100004000000006' then 6 "   //深海项目
				+ "when p.project_type = '5000100004000000011' then 7 "   //国际部
				+ "when p.project_type = '5000100004000000003' then 8 "   //非地震项目
				+ "when p.project_type = '5000100004000000008' then 9 "   //井中项目
				+ "when p.project_type = '5000100004000000009' then 10 "  //综合物化探
				+ "end,pro_status, p.project_year desc ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	
	
}

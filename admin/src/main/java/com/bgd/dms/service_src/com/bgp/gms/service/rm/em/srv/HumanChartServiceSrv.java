package com.bgp.gms.service.rm.em.srv;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * project: 东方物探生产管理系统
 *   
 * creator: 林彦博
 * 
 * creator time:2012-7-25
 * 
 * description:
 * 
 */
public class HumanChartServiceSrv extends BaseService {
	

	private static final String[] orgNames = { "C105001002%-新疆", "C105001003%-吐哈","C105001004%-青海" ,"C105005004%-长庆", "C105005000%-华北","C105063%-辽河","C105002%-国际部", "C105001005%-塔里木","C105005001%-新兴物探","C105007%-大港","C105006%-装备"};
	private static final String[] gzNames = { "0110000019000000001-合同化用工", "0110000019000000002-市场化用工","0110000059000000005-临时用工" ,"0110000059000000003-再就业", "0110000059000000001-劳务用工"};
	private static final String[] ageNames = { "25岁以下", "25-30岁","30-35岁" ,"35-40岁", "40-45岁","45-50岁","50-55岁","55-60岁","60岁以上"};
	private static final String[] eduNames = { "初中及以下", "技校","中专" ,"高中", "大学专科","大学本科","硕士研究生","博士研究生"};
	
	public ISrvMsg queryViewChart1(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
		
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select decode(t.spare7,'0','一线','1','境外','2','二三线','') label,sum(nums) value from ( ");
		sb.append("select h.spare7,count(h.spare7) nums from comm_human_employee e inner join  comm_human_employee_hr h on e.employee_id=h.employee_id and h.bsflag='0'  ");
		sb.append(" left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb.append(" where e.bsflag='0' and h.spare7 is not null and s.org_subjection_id like '").append(orgSubjectionId).append("%' ");
		sb.append(" group by h.spare7 ");
		sb.append("union all ");
		sb.append("select '0' spare7, count(1) nums from bgp_comm_human_labor l where l.bsflag='0' and l.owning_subjection_org_id like '").append(orgSubjectionId).append("%' ");
//		sb.append(" and l.if_engineer in ('0110000059000000003','0110000059000000001') and l.if_project = '1'  ");
		sb.append(" and ( l.if_engineer='0110000059000000003' or ( l.if_engineer in ('0110000059000000005','0110000059000000001') and l.if_project='1' )) ");
		sb.append(") t group by t.spare7 ");

		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("pieRadius", "98");
	    root.addAttribute("radius3D", "60"); 
        String[] colorParam = new String[]{"#FFA011,#FFA011","1E90FF,1E90FF","69bf5d,69bf5d","#FF335C,#FF335C","#CC00FF,#CC00FF","#FFFF00,#FFFF00","#00CCFF,#00CCFF"};
		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));
			set.addAttribute("color", colorParam[i]);
		}

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart2(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
		
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();
		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select t.employee_gz,d.coding_name label,t.nums value from ( ");
		sb.append("select h.employee_gz, count(1) nums from comm_human_employee e  ");
		sb.append("inner join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0' ");
		sb.append(" left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb.append("where e.bsflag = '0' and h.spare7 ='0' and s.org_subjection_id like '").append(orgSubjectionId).append("%' group by h.employee_gz ");
		sb.append("union all ");
		sb.append("select l.if_engineer employee_gz, count(1) nums from bgp_comm_human_labor l where l.bsflag = '0'  and l.if_engineer is not null ");
//		sb.append(" and l.if_engineer in ('0110000059000000003','0110000059000000001')  and l.if_project = '1' ");
		sb.append(" and ( l.if_engineer='0110000059000000003' or ( l.if_engineer in ('0110000059000000005','0110000059000000001') and l.if_project='1' )) ");
		sb.append("group by l.if_engineer ) t left join comm_coding_sort_detail d on t.employee_gz=d.coding_code_id and d.bsflag='0' ");

		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("pieRadius", "98");
	    root.addAttribute("radius3D", "60"); 
        String[] colorParam = new String[]{"#FFA011,#FFA011","#FF335C,#FF335C","1E90FF,1E90FF","69bf5d,69bf5d","#CC00FF,#CC00FF","#FFFF00,#FFFF00","#00CCFF,#00CCFF"};
		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));
			set.addAttribute("color", colorParam[i]);
		}

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart3(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select nvl(count(t.nums),0) nums from ( ");
		sb.append(" select (nvl(h.actual_end_date,sysdate)-h.actual_start_date) nums from bgp_human_prepare p  ");
		sb.append(" left join bgp_human_prepare_human_detail h on p.prepare_no=h.prepare_no and h.bsflag='0' ");
		sb.append(" left join comm_human_employee e on h.employee_id = e.employee_id  ");
		sb.append(" left join comm_human_employee_hr h1 on e.employee_id = h1.employee_id  ");
		sb.append(" left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag='0' ");
		sb.append("where p.bsflag='0' and e.bsflag='0' and h1.bsflag='0'   and s.org_subjection_id like '@orgid%'  ");//and h1.spare7='0'
		sb.append(" and h.actual_start_date >= to_date('").append(applyDate).append("-01-01', 'yyyy-MM-dd')");
//		sb.append("union all ");
//		sb.append("select (nvl(d.end_date,sysdate)-d.start_date) nums from bgp_comm_human_labor_deploy d ");
//		sb.append(" left join bgp_comm_human_labor l on l.labor_id = d.labor_id and l.bsflag='0' ");
//		sb.append(" where d.bsflag='0' and l.owning_subjection_org_id like '@orgid%'  ");
		sb.append(" ) t where 1=1 ");
		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
		String sql = sb.toString().replaceAll("@orgid", orgId);
		
		Map map1 = jdbcDAO.queryRecordBySQL(sql+" and t.nums <= 30 ");
		if(map1 != null && map1.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "30天");
			set.addAttribute("value", (String)map1.get("nums"));
		}
		
		Map map2 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 30 and t.nums <= 60  ");
		if(map2 != null && map2.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "60天");
			set.addAttribute("value", (String)map2.get("nums"));
		}

		Map map3 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 60 and t.nums <= 90  ");
		if(map3 != null && map3.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "90天");
			set.addAttribute("value", (String)map3.get("nums"));
		}

		Map map4 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 90 and t.nums <= 120  ");
		if(map4 != null && map4.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "120天");
			set.addAttribute("value", (String)map4.get("nums"));
		}

		Map map5 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 120 and t.nums <= 240  ");
		if(map5 != null && map5.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "240天");
			set.addAttribute("value", (String)map5.get("nums"));
		}
		
		Map map6 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 240  ");
		if(map6 != null && map6.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "240天以上");
			set.addAttribute("value", (String)map6.get("nums"));
		}
		
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart4(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
								
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select sum(case when  t.employee_gz='0110000019000000001' and t.person_status='0' then t.nums else 0 end ) n1, ");
		sb.append(" sum(case when  t.employee_gz='0110000019000000001' and t.person_status='1' then t.nums else 0 end ) n2, ");
		sb.append(" sum(case when  t.employee_gz='0110000019000000002' and t.person_status='0' then t.nums else 0 end ) n3, ");
		sb.append(" sum(case when  t.employee_gz='0110000019000000002' and t.person_status='1' then t.nums else 0 end ) n4  ");
		sb.append(" from (select  t.*from ( select nvl(h.person_status,0) person_status,h.employee_gz,count(e.employee_id) nums from comm_human_employee e ");
		sb.append(" inner join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0' ");
		sb.append("  left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0'  ");
		sb.append(" where e.bsflag = '0'  and h.person_status='0' and h.employee_gz is not null ");
		sb.append(" and s.org_subjection_id like '@' group by h.employee_gz,h.person_status order by  h.employee_gz,h.person_status ) t where t.person_status='0' " );
		sb.append(" union all   select '1' person_status, p.employee_gz,count(p.EMPLOYEE_ID )nums   from view_human_project_relation p  left join comm_coding_sort_detail d    on p.team = d.coding_code_id where  p.org_subjection_id  like '@'    and p.actual_start_date is not null and p.actual_end_date is null   and p.EMPLOYEE_GZ='0110000019000000001' group  by  p.employee_gz ");
		sb.append(" union all   select '1' person_status, p.employee_gz,count(p.EMPLOYEE_ID )nums   from view_human_project_relation p  left join comm_coding_sort_detail d    on p.team = d.coding_code_id where  p.org_subjection_id  like '@'    and p.actual_start_date is not null and p.actual_end_date is null   and p.EMPLOYEE_GZ='0110000019000000002' group  by  p.employee_gz ");	
		sb.append(" ) t ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("showSum", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "WRAP"); 
		root.addAttribute("numberSuffix", "人");
		
		for(int i=0;i<orgNames.length;i++){
			String name = orgNames[i].split("-")[1];
			Element categories = root.addElement("categories");
			Element category = categories.addElement("category");
			category.addAttribute("label", name);
		}
		
		Element dataset1 = root.addElement("dataset");
		Element dataset2 = root.addElement("dataset");
				
		Element dataSet11 = dataset1.addElement("dataSet");
		dataSet11.addAttribute("seriesName", "合同化不在岗");
		Element dataSet12 = dataset1.addElement("dataSet");
		dataSet12.addAttribute("seriesName", "合同化在岗");
		Element dataSet21 = dataset2.addElement("dataSet");
		dataSet21.addAttribute("seriesName", "市场化不在岗");
		Element dataSet22 = dataset2.addElement("dataSet");
		dataSet22.addAttribute("seriesName", "市场化在岗");
				
		for(int i=0;i<orgNames.length;i++){
			
			String value = orgNames[i].split("-")[0];
 
			String sql = sb.toString().replaceAll("@", value);
			Map map = jdbcDAO.queryRecordBySQL(sql);
			
			String n1 = "0";
			String n2 = "0";
			String n3 = "0";
			String n4 = "0";
			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}
			if(map != null && map.get("n3") != null){
				n3 = (String)map.get("n3");
			}
			if(map != null && map.get("n4") != null){
				n4 = (String)map.get("n4");
			}
			
			Element set1 = dataSet11.addElement("set");
			set1.addAttribute("value", n1);
			set1.addAttribute("link", "j-myJS1-"+"0110000019000000001_"+value);
			Element set2 = dataSet12.addElement("set");
			set2.addAttribute("value", n2);
			set2.addAttribute("link", "j-myJS-"+"0110000019000000001_"+value);
			Element set3 = dataSet21.addElement("set");
			set3.addAttribute("value", n3);
			set3.addAttribute("link", "j-myJS1-"+"0110000019000000002_"+value);
			Element set4 = dataSet22.addElement("set");
			set4.addAttribute("value", n4);
			set4.addAttribute("link", "j-myJS-"+"0110000019000000002_"+value);

		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart41(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
								
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				
		StringBuffer sb = new StringBuffer(" select sum(case when  t.employee_gz='0110000019000000001' and t.person_status='0' then t.nums else 0 end ) n1, ");
		sb.append(" sum(case when  t.employee_gz='0110000019000000001' and t.person_status='1' then t.nums else 0 end ) n2, ");
		sb.append(" sum(case when  t.employee_gz='0110000019000000002' and t.person_status='0' then t.nums else 0 end ) n3, ");
		sb.append(" sum(case when  t.employee_gz='0110000019000000002' and t.person_status='1' then t.nums else 0 end ) n4  ");
		sb.append(" from ( select nvl(h.person_status,0) person_status,h.employee_gz,count(e.employee_id) nums from comm_human_employee e ");
		sb.append(" inner join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0' ");
		sb.append("  left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0'  ");
		sb.append(" where e.bsflag = '0'  and h.spare7='0' and h.employee_gz is not null ");
		sb.append(" and s.org_subjection_id like '@%' group by h.employee_gz,h.person_status order by  h.employee_gz,h.person_status  ) t ");


		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "WRAP");   
		root.addAttribute("numberSuffix", "人");
				
		String sql = sb.toString().replaceAll("@", user.getSubOrgIDofAffordOrg());
		
		Map map = jdbcDAO.queryRecordBySQL(sql);
		
		String n1 = "0";
		String n2 = "0";
		String n3 = "0";
		String n4 = "0";
		
		if(map != null && map.get("n1") != null){
			n1 = (String)map.get("n1");
		}
		if(map != null && map.get("n2") != null){
			n2 = (String)map.get("n2");
		}
		if(map != null && map.get("n3") != null){
			n3 = (String)map.get("n3");
		}
		if(map != null && map.get("n4") != null){
			n4 = (String)map.get("n4");
		}
		
		Element set1 = root.addElement("set");
		set1.addAttribute("label", "合同化不在岗");
		set1.addAttribute("link", "j-myJS1-");
		set1.addAttribute("value", n1);
		
		Element set2 = root.addElement("set");
		set2.addAttribute("label", "合同化在岗");
		set2.addAttribute("link", "j-myJS2-");
		set2.addAttribute("value", n2);
		
		Element set3 = root.addElement("set");
		set3.addAttribute("label", "市场化不在岗");
		set3.addAttribute("link", "j-myJS1-");
		set3.addAttribute("value", n3);
		
		Element set4 = root.addElement("set");
		set4.addAttribute("label", "市场化在岗");
		set4.addAttribute("link", "j-myJS2-");
		set4.addAttribute("value", n4);
		
					
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}

	public ISrvMsg queryViewChart5(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select decode(t.spare7,'0','一线','1','境外','2','二三线','') label,sum(nums) value from ( ");
		sb.append("select h.spare7,count(h.spare7) nums from comm_human_employee e inner join  comm_human_employee_hr h on e.employee_id=h.employee_id and h.bsflag='0'  ");
		sb.append(" left join comm_org_subjection s on e.org_id = s.org_id  and s.bsflag = '0'  ");
		sb.append(" where e.bsflag='0' and h.spare7 is not null ");		
		sb.append("  and s.org_subjection_id like '@%'  ");
		sb.append(" group by h.spare7 ");
//		sb.append("union all ");
//		sb.append("select '0' spare7, count(1) nums from bgp_comm_human_labor l where l.bsflag='0' and l.if_project='1' and l.owning_subjection_org_id like '@%' ");
//		sb.append("and l.if_engineer in ('0110000059000000003','0110000059000000001') ");
		sb.append(") t group by t.spare7 ");

		List ulist = jdbcDAO.queryRecords(sb.toString().replaceAll("@", orgId));

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("showLegend", "0");
		root.addAttribute("pieRadius", "98");
	    root.addAttribute("radius3D", "60"); 
//		root.addAttribute("caption", "按线级结构分类占比");
        String[] colorParam = new String[]{"#FFA011,#FFA011","1E90FF,1E90FF","69bf5d,69bf5d","#FF335C,#FF335C","#CC00FF,#CC00FF","#FFFF00,#FFFF00","#00CCFF,#00CCFF"};
		
        for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));
			set.addAttribute("color", colorParam[i]);
		}

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart6(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select decode(t.spare7,'0','一线','1','境外','2','二三线','') label,sum(nums) value from ( ");
		sb.append("select h.spare7,count(h.spare7) nums from comm_human_employee e inner join  comm_human_employee_hr h on e.employee_id=h.employee_id and h.bsflag='0'  ");
		sb.append(" left join comm_org_subjection s on e.org_id = s.org_id  and s.bsflag = '0'  ");
		sb.append(" where e.bsflag='0' and h.spare7 is not null ");		
		sb.append("  and s.org_subjection_id like 'orgid'  ");
		sb.append(" group by h.spare7 ");
//		sb.append("union all ");
//		sb.append("select '0' spare7, count(1) nums from bgp_comm_human_labor l where l.bsflag='0' and l.if_project='1' and l.owning_subjection_org_id like 'orgid' ");
//		sb.append(" and l.if_engineer in ('0110000059000000003','0110000059000000001') ");
		sb.append(") t where t.spare7 = '@spare7' group by t.spare7  ");

		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		//root.addAttribute("caption", "按线级结构分类占比");
		
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "一线");
		dataset1.addAttribute("color", "78bce5");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "境外");
		dataset2.addAttribute("color", "f5d34b");
		Element dataset3 = root.addElement("dataset");		
		dataset3.addAttribute("seriesName", "二三线");
		dataset3.addAttribute("color", "69bf5d");
		
		for(int i=0;i<orgNames.length;i++){
			
			Element category = categories.addElement("category");
			category.addAttribute("label", orgNames[i].split("-")[1]);
			
			String sql = sb.toString().replaceAll("orgid", orgNames[i].split("-")[0]);
			
			for(int j=0;j<=2;j++){
				
				String newsql = sql.replaceAll("@spare7", j+"");
				
				Map map = jdbcDAO.queryRecordBySQL(newsql);
				
				String nums = "0";
				
				if(map != null && map.get("value") != null){
					nums = (String)map.get("value");
				}
				
				
				switch(j){
					case 0:  				
						Element set1 = dataset1.addElement("set");
						set1.addAttribute("value", nums);	
						break;
					case 1:									
						Element set2 = dataset2.addElement("set");
						set2.addAttribute("value", nums);
						break;
					case 2:									
						Element set3 = dataset3.addElement("set");
						set3.addAttribute("value", nums);
						break;
	
					default:break;
				}
								
			}
						
		}
		
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart7(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select d.coding_name label, sum(c.A1) value from (select a.* ");
		sb.append(" from (select count(t.employee_id) A1, h.employee_gz A3 ");
		sb.append(" from comm_human_employee t inner join comm_human_employee_hr h on t.employee_id = h.employee_id and h.bsflag = '0' ");
		sb.append(" left join comm_org_subjection s on t.org_id=s.org_id and s.bsflag='0' ");
		sb.append(" where t.bsflag = '0' and h.employee_gz is not null and h.spare7='0' and s.org_subjection_id like '@orgid%' group by h.employee_gz) a ");
		sb.append(" union all select b.* from (select count(l.labor_id) A1, l.if_engineer A3 ");
		sb.append(" from bgp_comm_human_labor l where l.bsflag = '0'  and l.if_engineer is not null  and l.owning_subjection_org_id like '@orgid%' ");
//		sb.append(" and ( l.if_engineer='0110000059000000003' or ( l.if_engineer in ('0110000059000000005','0110000059000000001') and l.if_project='1' )) ");
		sb.append(" group by l.if_engineer) b) c left join comm_coding_sort_detail d on c.A3=d.coding_code_id  group by d.coding_name ");
	

		List ulist = jdbcDAO.queryRecords(sb.toString().replaceAll("@orgid", orgId));

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("showLegend", "0");
		root.addAttribute("pieRadius", "95");		
		root.addAttribute("radius3D", "60"); 
//		root.addAttribute("caption", "按用工性质分类占比");
		
		String[] colorParam = new String[]{"1E90FF,FF0000","ff8c00,f5d34b","FF0000,FF0000","69bf5d,69bf5d","#CC00FF,#CC00FF","#FFFF00,#FFFF00","#00CCFF,#00CCFF"};
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));
			set.addAttribute("color", colorParam[i]);
		}

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart8(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
				
		String orgId = reqDTO.getValue("orgId");
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select d.coding_name label, sum(c.A1) value from (select a.* ");
		sb.append(" from (select count(t.employee_id) A1, h.employee_gz A3 ");
		sb.append(" from comm_human_employee t inner join comm_human_employee_hr h on t.employee_id = h.employee_id and h.bsflag = '0' ");
		sb.append(" left join comm_org_subjection s on t.org_id=s.org_id and s.bsflag='0' ");
		sb.append(" where t.bsflag = '0' and h.employee_gz is not null and s.org_subjection_id like '@orgid' group by h.employee_gz) a ");
		sb.append(" union all select b.* from (select count(l.labor_id) A1, l.if_engineer A3 ");
		sb.append(" from bgp_comm_human_labor l where l.bsflag = '0' and l.if_engineer is not null and l.owning_subjection_org_id like '@orgid' ");
		sb.append(" group by l.if_engineer) b) c left join comm_coding_sort_detail d on c.A3=d.coding_code_id  ");
		sb.append(" where c.A3 ='@employeeGz' group by d.coding_name ");
		
	
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		//root.addAttribute("caption", "按用工性质分类占比");

		
		Element categories = root.addElement("categories");
		
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "合同化用工");
		dataset1.addAttribute("color", "78bce5");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "市场化用工");
		dataset2.addAttribute("color", "f5d34b");
		Element dataset3 = root.addElement("dataset");		
		dataset3.addAttribute("seriesName", "临时用工");
		dataset3.addAttribute("color", "69bf5d");
		Element dataset4 = root.addElement("dataset");		
		dataset4.addAttribute("seriesName", "再就业");
		dataset4.addAttribute("color", "1e2f6e");
		Element dataset5 = root.addElement("dataset");		
		dataset5.addAttribute("seriesName", "劳务用工");
		dataset5.addAttribute("color", "de3d22");
		
		for(int i=0;i<orgNames.length;i++){
			
			Element category = categories.addElement("category");
			category.addAttribute("label", orgNames[i].split("-")[1]);
			
			String sql = sb.toString().replaceAll("@orgid", orgNames[i].split("-")[0]);
			
			for(int j=0;j<gzNames.length;j++){
				
				String newsql = sql.replaceAll("@employeeGz", gzNames[j].split("-")[0]);
				
				Map map = jdbcDAO.queryRecordBySQL(newsql);
				
				String nums = "0";
				
				if(map != null && map.get("value") != null){
					nums = (String)map.get("value");
				}
				
				
				switch(j){
					case 0:  				
						Element set1 = dataset1.addElement("set");
						set1.addAttribute("value", nums);	
						break;
					case 1:									
						Element set2 = dataset2.addElement("set");
						set2.addAttribute("value", nums);
						break;
					case 2:									
						Element set3 = dataset3.addElement("set");
						set3.addAttribute("value", nums);
						break;
					case 3:									
						Element set4 = dataset4.addElement("set");
						set4.addAttribute("value", nums);
						break;
					case 4:									
						Element set5 = dataset5.addElement("set");
						set5.addAttribute("value", nums);
						break;
					default:break;
				}
								
			}
						
		}

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}

	
	public ISrvMsg queryViewChart9(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		//上岗率人数递增
		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
				
		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		Calendar cal = new GregorianCalendar();
		cal.setTime(new Date());
		int monthnum = cal.get(Calendar.MONTH)+1;
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
	
		StringBuffer sb1 = new StringBuffer("");
		sb1.append(" select nvl(n1,0) n1,nvl(n2,0) n2,nvl(round((n1+n2)/(select count(1) from  ");
		sb1.append(" comm_human_employee e,comm_human_employee_hr h,comm_org_subjection s where e.employee_id=h.employee_id  ");
		sb1.append(" and e.org_id=s.org_id and e.bsflag='0' and h.bsflag='0' and h.person_status='0' and s.bsflag='0'  and s.org_subjection_id like '@orgid%' )*100 ,3),0) value from (  ");
		sb1.append(" select sum(case when t.employee_gz='0110000019000000001' then t.nums else 0 end) n1,   ");
		sb1.append(" sum(case when t.employee_gz='0110000019000000002' then t.nums else 0 end) n2 from (  ");
		sb1.append(" select h.employee_gz,count( distinct d.employee_id) nums  ");
		sb1.append(" from bgp_human_prepare_human_detail d ");
		sb1.append(" inner join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' ");
		sb1.append(" inner join comm_human_employee e on e.employee_id = d.employee_id ");
		sb1.append(" inner join comm_human_employee_hr h on e.employee_id = h.employee_id ");
		sb1.append(" inner join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb1.append(" where  e.bsflag = '0' and  h.bsflag = '0' and d.bsflag = '0'  and s.org_subjection_id like '@orgid%' and h.employee_gz is not null ");
		sb1.append(" and d.actual_start_date <= add_months(to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') - 1, 1)   ");
		sb1.append(" group by h.employee_gz ");
		sb1.append(" ) t ) ");

		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("sNumberSuffix", "%25");
		root.addAttribute("SYAxisMaxValue ", "100");
		root.addAttribute("numberSuffix ", "人");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "NONE");   
//		root.addAttribute("caption", "一线员工上岗率");
		
		Element categories = root.addElement("categories");

		
		for(int i=1 ; i<=12 ; i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", i+"月");
		}
		
		
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "合同化用工");
		dataset1.addAttribute("color", "78bce5");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "市场化用工");
		dataset2.addAttribute("color", "f5d34b");	 
		Element dataset3 = root.addElement("dataset");		
		dataset3.addAttribute("seriesName", "上岗率");
		dataset3.addAttribute("parentYAxis", "S");
		dataset3.addAttribute("showValues", "0");
		String sql = sb1.toString().replaceAll("@orgid", orgId);
	
		for(int i=1 ; i<=12 ; i++){
			
			String n1 = "0";
			String n2 = "0";
			String nums = "0";
			Map map = new HashMap();
			
			if(i<=monthnum){
				String newsql = sql.replaceAll("@nums", i+"");
				map = jdbcDAO.queryRecordBySQL(newsql);
			}

			

			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}
			
			if(map != null && map.get("value") != null){
				nums = (String)map.get("value");
			}
			
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", n1);
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", n2);
			Element set3 = dataset3.addElement("set");
			if(nums.equals("0")){
				nums="";
			}
			set3.addAttribute("value", nums);
						
		}
		
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart10(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		

		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		StringBuffer sb1 = new StringBuffer("");
		sb1.append(" select n1,n2,round((n1+n2)/(select count(1) from  ");
		sb1.append(" comm_human_employee e,comm_human_employee_hr h,comm_org_subjection s where e.employee_id=h.employee_id  ");
		sb1.append(" and e.org_id=s.org_id and e.bsflag='0' and h.bsflag='0' and s.bsflag='0'  and h.person_status = '0' and s.org_subjection_id like '@orgid' )*100 ,3) value from (  ");
		sb1.append(" select sum(case when t.employee_gz='0110000019000000001' then t.nums else 0 end) n1,   ");
		sb1.append(" sum(case when t.employee_gz='0110000019000000002' then t.nums else 0 end) n2 from (  ");
		sb1.append(" select h.employee_gz,count(d.employee_id) nums ");
		sb1.append(" from bgp_human_prepare_human_detail d ");
		sb1.append(" left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' ");
		sb1.append(" left join comm_human_employee e on e.employee_id = d.employee_id ");
		sb1.append(" left join comm_human_employee_hr h on e.employee_id = h.employee_id ");
		sb1.append(" left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb1.append(" where d.bsflag = '0' and e.bsflag='0' and h.bsflag='0' and s.org_subjection_id like '@orgid' and h.employee_gz is not null ");
		sb1.append(" and d.actual_start_date >= to_date('").append(applyDate).append("-01-01','yyyy-MM-dd')");//  and (d.actual_end_date <= sysdate or d.actual_end_date is null) 
		sb1.append(" group by h.employee_gz ");
		sb1.append(" ) t ) ");
		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("numberSuffix ", "人");
		root.addAttribute("sNumberSuffix", "%25");
		root.addAttribute("SYAxisMaxValue ", "100");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
	//	root.addAttribute("caption", "一线员工上岗率");
		
		Element categories = root.addElement("categories");
		
		for(int i=0;i<orgNames.length;i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", orgNames[i].split("-")[1]);
		}
		
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "合同化用工");
		dataset1.addAttribute("color", "78bce5"); 
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "市场化用工");
		dataset2.addAttribute("color", "f5d34b");	
		Element dataset3 = root.addElement("dataset");		
		dataset3.addAttribute("seriesName", "上岗率");
		dataset3.addAttribute("parentYAxis", "S");
		dataset3.addAttribute("showValues", "0");

		
		for(int i=0;i<orgNames.length;i++){
			
			String newsql = sb1.toString().replaceAll("@orgid", orgNames[i].split("-")[0]);
			Map map = jdbcDAO.queryRecordBySQL(newsql);
			
			
			String n1 = "0";
			String n2 = "0";
			String nums = "0";
			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}
			
			if(map != null && map.get("value") != null){
				nums = (String)map.get("value");
			}
			
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", n1);
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", n2);
			Element set3 = dataset3.addElement("set");
			if(nums.equals("0")){
				nums="";
			}
			set3.addAttribute("value", nums);
						
		}
		
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	
	public ISrvMsg queryViewChart11(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		

		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		Calendar cal = new GregorianCalendar();
		cal.setTime(new Date());
		int monthnum = cal.getActualMaximum(Calendar.MONTH); 
		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" ");	
		sb.append(" with month_t as (select to_char(add_months(to_date(to_char(sysdate, 'yyyy') || '01' || '01', 'yyyy-MM-dd') - 1, rownum),'yyyy-MM') mon ");
		sb.append("  from dual connect by rownum < 13) ");
		sb.append("  select t.mon,n1,n2,round((n1+n2)/(select count(1) from comm_human_employee e, comm_human_employee_hr h,comm_org_subjection s   ");
		sb.append("  where e.employee_id = h.employee_id and e.org_id=s.org_id and e.bsflag = '0' and h.bsflag = '0' and s.bsflag='0' ");
		sb.append("  and s.org_subjection_id like '@orgid%' and h.person_status='0'  )*100,2) n3  from ( ");
		sb.append("  select t.mon, sum(case when t.employee_gz='0110000019000000001' then t.nums else 0 end ) n1, ");
		sb.append("  sum(case when t.employee_gz='0110000019000000002' then t.nums else 0 end ) n2 from ( ");
		sb.append(" select distinct count(1) nums, p1.mon, p2.employee_gz  from month_t p1 ");
		sb.append("  left outer join(select distinct h.employee_gz,d.employee_id, ");
		sb.append("  to_char(d.actual_start_date,'yyyy-MM') actual_start_date, ");
		sb.append("  to_char(nvl(d.actual_end_date, sysdate),'yyyy-MM') actual_end_date ");
		sb.append(" from bgp_human_prepare_human_detail d  ");
		sb.append("  left join bgp_human_prepare p on d.prepare_no = p.prepare_no  and p.bsflag = '0'");
		sb.append("  left join comm_human_employee e on e.employee_id = d.employee_id ");
		sb.append("  left join comm_human_employee_hr h on e.employee_id = h.employee_id ");
		sb.append("  left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' ");
		sb.append("  where e.bsflag = '0' and h.bsflag = '0' and d.bsflag = '0'  and s.org_subjection_id like '@orgid%' and h.employee_gz is not null  ");
		sb.append("    and d.actual_start_date is not null ) p2  on 1 = 1 ");// and d.actual_end_date is   null
		
		//mon是当年的每个月yyyy-MM
		sb.append("   and p1.mon  >= p2.actual_start_date  ");
		//
		sb.append("   and p1.mon  <= p2.actual_end_date   ");
		//
		sb.append("  group by p1.mon, p2.employee_gz ");
		sb.append("  order by p1.mon) t group by t.mon order by t.mon ) t ");
		
		
		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("numberSuffix ", "人");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberSuffix", "人");
		root.addAttribute("sNumberSuffix", "%25");
		root.addAttribute("SYAxisMaxValue ", "100");
//		root.addAttribute("caption", "一线员工在岗率");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "none");   
		
				
		Element categories = root.addElement("categories");

		for(int i=1 ; i<=12 ; i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", i+"月");
		}
				
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "合同化用工");
		dataset1.addAttribute("color", "78bce5"); 
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "市场化用工");
		dataset2.addAttribute("color", "f5d34b"); 
		Element dataset3 = root.addElement("dataset");		
		dataset3.addAttribute("seriesName", "在岗率");
		dataset3.addAttribute("parentYAxis", "S");
		dataset3.addAttribute("showValues", "0");  
		
		String sql = sb.toString().replaceAll("@orgid", orgId);
		
		List list = jdbcDAO.queryRecords(sql);
		
		for(int i=0;i<list.size();i++){
			
			Map map = (Map)list.get(i);
			String n1 = "0";
			String n2 = "0";
			String n3 = "0";
			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}	
			if(map != null && map.get("n3") != null){
				n3 = (String)map.get("n3");
			}
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", n1);
			set1.addAttribute("link", "j-myJS2-"+"0110000019000000001_"+(i+1)+"_"+orgId);
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", n2);
			set2.addAttribute("link", "j-myJS2-"+"0110000019000000002_"+(i+1)+"_"+orgId);
			Element set3 = dataset3.addElement("set");
		
			if(n3.equals("0")){
				n3="";	 
			}
			set3.addAttribute("value", n3);
			
		}

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart12(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		

		String orgId = reqDTO.getValue("orgId");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
	
		StringBuffer sb1 = new StringBuffer(" ");
		sb1.append(" select n1,n2, round((n1+n2)/(select count(1) from comm_human_employee e, comm_human_employee_hr h,comm_org_subjection s  ");
		sb1.append(" where e.employee_id = h.employee_id and e.org_id=s.org_id and e.bsflag = '0' and h.bsflag = '0' and s.bsflag='0' ");
		sb1.append(" and s.org_subjection_id like '@orgid%' ");
		sb1.append(" ) , 2) value from ( ");
		sb1.append(" select sum(case when t.employee_gz='0110000019000000001' then t.nums else 0 end ) n1 ,");
		sb1.append(" sum(case when t.employee_gz='0110000019000000002' then t.nums else 0 end ) n2 from ( ");
		sb1.append(" select h.employee_gz,count(d.employee_id) nums");
		sb1.append(" from bgp_human_prepare_human_detail d ");
		sb1.append(" left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' ");
		sb1.append(" left join comm_human_employee e on e.employee_id = d.employee_id ");
		sb1.append(" left join comm_human_employee_hr h on e.employee_id = h.employee_id ");
		sb1.append(" left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb1.append(" where d.bsflag = '0' and e.bsflag='0' and h.bsflag='0' and s.org_subjection_id like '@orgid%'  and h.employee_gz is not null ");
		sb1.append(" and d.actual_start_date is not null  and (d.actual_end_date <= last_day(add_months(sysdate, -1)) or d.actual_end_date is null) ");
		sb1.append(" group by h.employee_gz ) t ) ");

		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("numberSuffix ", "人");
		root.addAttribute("sNumberSuffix", "%25");
		root.addAttribute("SYAxisMaxValue ", "100");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
	//	root.addAttribute("caption", "一线员工在岗率");
		
		Element categories = root.addElement("categories");
		
		for(int i=0;i<orgNames.length;i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", orgNames[i].split("-")[1]);
		}
		
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "合同化用工");
		dataset1.addAttribute("color", "78bce5"); 
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "市场化用工");
		Element dataset3 = root.addElement("dataset");		
		dataset2.addAttribute("color", "f5d34b");
		dataset3.addAttribute("seriesName", "在岗率");
		dataset3.addAttribute("parentYAxis", "S");
		
		
		for(int i=0;i<orgNames.length;i++){
			
			String newsql = sb1.toString().replaceAll("@orgid", orgNames[i].split("-")[0]);
			Map map = jdbcDAO.queryRecordBySQL(newsql);
			
			String n1 = "0";
			String n2 = "0";
			String nums = "0";
			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}			
			if(map != null && map.get("value") != null){
				nums = (String)map.get("value");
			}
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", n1);
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", n2);
			Element set3 = dataset3.addElement("set");
			set3.addAttribute("value", nums);
						
		}

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart13(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		

		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append(" select sum( case when t.employee_gz='0110000019000000001' then t.nums else 0 end) n1, ");
		sb.append(" sum( case when t.employee_gz='0110000019000000002' then t.nums else 0 end) n2 from ( ");
		sb.append(" select a.employee_gz,trunc(sum(nums)/count(1),0)+1 nums from (select distinct ");
		sb.append(" h.employee_gz, ");
		sb.append(" ( case when d.actual_end_date is null then  add_months(to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') - 1, 1) when  d.actual_end_date <= add_months(to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') - 1, 1) then add_months(to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') - 1, 1)  else d.actual_end_date  end) - ");
		sb.append(" ( case when  d.actual_start_date >= to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') then d.actual_start_date  else to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') end ) nums ");
		sb.append(" from bgp_human_prepare_human_detail d left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' ");
		sb.append(" left join comm_human_employee e on e.employee_id = d.employee_id  ");
		sb.append(" left join comm_human_employee_hr h on e.employee_id =  h.employee_id ");
		sb.append(" left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' ");
		sb.append(" where d.bsflag = '0' and e.bsflag='0' and h.bsflag='0' and h.spare7='0' and s.org_subjection_id like '@orgid%' ");
		sb.append(" and d.actual_start_date <= add_months(to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') - 1, 1) and (d.actual_end_date <= add_months(to_date('").append(applyDate).append("-@nums-01', 'yyyy-MM-dd') - 1, 1) or d.actual_end_date is null) ) a ");
		sb.append(" group by a.employee_gz) t ");
		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "none");   
	//	root.addAttribute("caption", "报告期内项目人员平均在项目工作天数");
		
		Element categories = root.addElement("categories");

		
		for(int i=1 ; i<=12 ; i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", i+"月");
		}
		
		
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "合同化用工");
		dataset1.addAttribute("color", "1381c0");    
		dataset1.addAttribute("anchorBorderColor", "1381c0");
		dataset1.addAttribute("anchorBgColor", "1381c0");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "市场化用工");
		dataset2.addAttribute("color", "fd962e");
		dataset2.addAttribute("anchorBorderColor", "fd962e");
		dataset2.addAttribute("anchorBgColor", "fd962e");
		
		String sql = sb.toString().replaceAll("@orgid", orgId);
		
		for(int i=1 ; i<=12 ; i++){
			
			String newsql = sql.replaceAll("@nums", i+"");
			
			Map map = jdbcDAO.queryRecordBySQL(newsql);
			
			String n1 = "0";
			String n2 = "0";
			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}	
				
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", n1);
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", n2);
						
		}
		

		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart14(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select count(1) nums from ( ");
		sb.append(" select e.employee_id,(trunc(nvl(d.actual_start_date,sysdate)-to_date('").append(applyDate).append("-01-01','yyyy-MM-dd'),0) +1) nums  ");
		sb.append(" from comm_human_employee e left join (select d.employee_id, d.actual_start_date, ");
		sb.append(" row_number() over(partition by d.employee_id order by d.actual_start_date asc) num ");
		sb.append(" from bgp_human_prepare_human_detail d  ");
		sb.append(" left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' ");
		sb.append(" where d.bsflag = '0') d on e.employee_id = d.employee_id and d.num = 1 ");
		sb.append(" left join comm_human_employee_hr h on e.employee_id =  h.employee_id  ");
		sb.append(" left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb.append(" where e.bsflag = '0' and h.bsflag='0'   and s.org_subjection_id like '@orgid%' ) t where 1=1  ");// and h.spare7='0'

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
		//root.addAttribute("caption", "一线待工人员统计表");
		
		String sql = sb.toString().replaceAll("@orgid", orgId);
		
		Map map1 = jdbcDAO.queryRecordBySQL(sql+" and t.nums <= 90 ");
		if(map1 != null && map1.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "3个月");
			set.addAttribute("color", "78bce5");
			set.addAttribute("value", (String)map1.get("nums"));
		}
		
		Map map2 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 90 and t.nums <= 180  ");
		if(map2 != null && map2.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "6个月");
			set.addAttribute("color", "f5d34b");
			set.addAttribute("value", (String)map2.get("nums"));
		}

		Map map3 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 180 and t.nums <= 240  ");
		if(map3 != null && map3.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "9个月");
			set.addAttribute("color", "69bf5d");
			set.addAttribute("value", (String)map3.get("nums"));
		}

		Map map4 = jdbcDAO.queryRecordBySQL(sql+" and t.nums > 240  ");
		if(map4 != null && map4.get("nums") != null){
			Element set = root.addElement("set");
			set.addAttribute("label", "12个月");
			set.addAttribute("color", "de3d22");
			set.addAttribute("value", (String)map4.get("nums"));
		}

		
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart15(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		String paramS = reqDTO.getValue("paramS");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		String setTeam = reqDTO.getValue("setTeam");
		String teamStr="";
		if(setTeam != null && !"".equals(setTeam) && !"null".equals(setTeam)){
			teamStr=" and h.set_team = '"+setTeam+"' ";
		}
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		// and h.employee_gz = '"+paramS+"'
		StringBuffer sb = new StringBuffer(" select count(h.employee_id) value,h.set_team,h.label from  (select  e.employee_id  ,case  when h.set_team is null then '1'  when d.coding_name is null then '1' else h.set_team end set_team,  nvl(d.coding_name,'其他') label ");
		sb.append(" from comm_human_employee e inner join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0'   ");
		sb.append(" left join comm_coding_sort_detail d on h.set_team=d.coding_code_id and d.bsflag='0' ");
		sb.append(" left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb.append(" where e.bsflag = '0' and h.person_status = '0' ");
		sb.append("  and s.org_subjection_id like '"+orgId+"%'  "+teamStr+" and h.EMPLOYEE_GZ='"+paramS+"' ) h group by h.set_team, h.label order by h.set_team ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
	 	root.addAttribute("labelDisplay", "WRAP");   
		root.addAttribute("numberSuffix", "人");
	//	root.addAttribute("caption", "一线用工存量资源统计");
		
		String sql = sb.toString().replaceAll("@orgId", orgId);
		
		List ulist = jdbcDAO.queryRecords(sql.replaceAll("@setTeam", setTeam));
		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));
			set.addAttribute("link", "j-getPostChart-"+(String)data.get("set_team"));			
		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChartPost15(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
		
		String orgId = reqDTO.getValue("orgId");
		String paramS = reqDTO.getValue("paramS");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		String setTeam = reqDTO.getValue("setTeam");
		
		if(setTeam == null || "".equals(setTeam)){
			setTeam = "0110000001000000020";
		}
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		// and h.employee_gz = '"+paramS+"'
		StringBuffer sb = new StringBuffer("select count(h.employee_id) value,h.set_post,h.label from  (select  e.employee_id  ,case  when h.set_post is null then '11'  when d.coding_name is null then '11' else h.set_post end set_post,  nvl(d.coding_name,'其他') label  ");
		sb.append(" from comm_human_employee e inner join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0'   ");
		sb.append(" left join comm_coding_sort_detail d on h.set_post=d.coding_code_id and d.bsflag='0' ");
		sb.append(" left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' ");
		sb.append(" where e.bsflag = '0' and h.person_status = '0' ");
		sb.append(" and h.set_team='@setTeam' and s.org_subjection_id like '"+orgId+"%'    and h.EMPLOYEE_GZ='"+paramS+"'  ) h group by h.set_post, h.label order by h.set_post ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
	 	root.addAttribute("labelDisplay", "WRAP");   
		root.addAttribute("numberSuffix", "人");
	//	root.addAttribute("caption", "一线用工存量资源统计");
		
		String sql = sb.toString().replaceAll("@orgId", orgId);
		
		List ulist = jdbcDAO.queryRecords(sql.replaceAll("@setTeam", setTeam));
		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));
			set.addAttribute("link", "j-myJS-"+(String)data.get("set_post"));			
		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart16(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		UserToken user = reqDTO.getUserToken();
		

		Map map = new HashMap();

		String applyDate = new SimpleDateFormat("yyyy-MM")
				.format(new Date());
		map.put("applyDate", applyDate);
		
		responseDTO.setValue("applyInfo", map);
		
		// 查询子表信息
		StringBuffer sql = new StringBuffer("");
		sql.append(" with temp_mon as (select d_month end_month, add_months(d_month, -1) + 1 start_month ");					
		sql.append(" from (select add_months(to_date(to_char(to_date('").append(applyDate).append("','yyyy-MM'), 'yyyy') || '0101', 'yyyymmdd') - 1, rownum) d_month from dual ");					
		sql.append(" connect by rownum < to_number(to_char(to_date('").append(applyDate).append("','yyyy-MM'),'MM'))+1) where D_MONTH < add_months(sysdate, 1)) ");
		
		sql.append(" select c.*,c.numbs1+c.numbs2+c.numbs3+c.numbs4+c.numbs5 numbs0, nvl(s.sum_human_cost,0) sum_human_cost,nvl(s.cont_cost,0) cont_cost,nvl(s.mark_cost,0) mark_cost,nvl(s.temp_cost,0) temp_cost,nvl(s.reem_cost,0) reem_cost,nvl(s.serv_cost,0) serv_cost,nvl(p1.const_month,0) const_month,to_number(to_char(to_date('").append(applyDate).append("','yyyy-MM'),'MM')) numbs   from (  ");					
		sql.append(" select project_info_no,project_name,trunc(sum(decode(employee_gz,'0110000019000000001',numbs,0)),0) numbs1,trunc(sum(decode(employee_gz,'0110000019000000002',numbs,0)),0) numbs2,trunc(sum(decode(employee_gz,'0110000059000000005',numbs,0)),0) numbs3,trunc(sum(decode(employee_gz,'0110000059000000003',numbs,0)),0) numbs4,trunc(sum(decode(employee_gz,'0110000059000000001',numbs,0)),0) numbs5 from (  ");					
		sql.append(" select p.project_info_no, p.project_name,t.employee_gz, sum(case when actual_end_date < start_month then 0 when actual_start_date > end_month then 0  ");					
		sql.append(" else (case when actual_end_date is null then end_month  when end_month > actual_end_date then ");					
		sql.append(" actual_end_date else end_month end) - (case when start_month < actual_start_date then actual_start_date ");					
		sql.append(" else start_month end)+1  end/to_number(to_char(end_month,'dd')))/to_number(to_char(to_date('").append(applyDate).append("','yyyy-MM'),'MM')) numbs ");					
		sql.append(" from gp_task_project p  ");					
		sql.append(" left join view_human_project_relation t on p.project_info_no=t.PROJECT_INFO_NO left join temp_mon m on 1 = 1 ");	
		sql.append(" where p.bsflag='0'  ");
		sql.append(" and p.project_status in ( @projectStatus )");
		sql.append(" GROUP BY p.project_info_no,p.project_name,t.employee_gz ) ");					
		sql.append(" group by project_info_no,project_name order by project_info_no ) c left join ( select s.project_info_no, ");					
		sql.append(" sum(nvl(s.sum_human_cost,0)) sum_human_cost, sum(nvl(s.cont_cost,0)) cont_cost, sum(nvl(s.mark_cost,0)) mark_cost, sum(nvl(s.temp_cost,0)) temp_cost, sum(nvl(s.reem_cost,0)) reem_cost, sum(nvl(s.serv_cost,0)) serv_cost ");					
		sql.append(" from bgp_comm_human_cost_act_deta s where s.org_subjection_id not like 'C105006%' and to_char(s.app_date, 'yyyy-MM') <= '").append(applyDate).append("' ");					
		sql.append(" group by s.project_info_no ) s on c.project_info_no=s.project_info_no ");					
		sql.append(" left join bgp_comm_human_cost_plan p1 on c.project_info_no=p1.project_info_no and p1.org_subjection_id not like 'C105006%' and p1.bsflag='0' order  by project_name ");					
					

	
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString().replaceAll("@projectStatus", " '5000100001000000001','5000100001000000002','5000100001000000004' "));
		List endlist = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString().replaceAll("@projectStatus", " '5000100001000000003','5000100001000000005'  "));
		
		responseDTO.setValue("list", list);
		
		responseDTO.setValue("endlist", endlist);
				
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart17(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
				
		String projectInfoNo = user.getProjectInfoNo();
				
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select d.coding_name label ,count(p.EMPLOYEE_ID) value ");
		sb.append("  from view_human_project_relation p ");
		sb.append("  left join comm_coding_sort_detail d on p.EMPLOYEE_GZ=d.coding_code_id ");
		sb.append("  where p.project_info_no = '").append(projectInfoNo).append("' and p.actual_start_date is not null    ");
		sb.append("  group by p.EMPLOYEE_GZ,d.coding_name ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
		//root.addAttribute("caption", "一线员工用工性质分析图");
		root.addAttribute("pieRadius", "98");		
		root.addAttribute("radius3D", "60");  
		String[] colorParam = new String[]{"FF0000,FF0000","ff8c00,f5d34b","1E90FF,FF0000","69bf5d,69bf5d","#CC00FF,#CC00FF","#FFFF00,#FFFF00","#00CCFF,#00CCFF"};
	 
		List ulist = jdbcDAO.queryRecords(sb.toString());
		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));
			set.addAttribute("color", colorParam[i]);
		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
	
	public ISrvMsg queryViewChart24(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String team = reqDTO.getValue("team");
		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select p.WORK_POST,d.coding_name label ,count(p.EMPLOYEE_ID) value ");
		sb.append("  from view_human_project_relation p ");
		sb.append("  left join comm_coding_sort_detail d  on p.WORK_POST=d.coding_code_id  ");
		sb.append("  where p.project_info_no = '").append(projectInfoNo).append("' ");
		
		if(team != null && team.length() > 0){
			sb.append("  and  p.TEAM = '").append(team).append("'");
		} 
		
		sb.append("  and  p.EMPLOYEE_GZ in ('0110000019000000001','0110000019000000002') ");
		
		sb.append("  group by p.WORK_POST,d.coding_name ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
//		root.addAttribute("caption", "项目岗位人员统计图");
		 
		List ulist = jdbcDAO.queryRecords(sb.toString());		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("link",  "j-getHumanList-"+data.get("work_post"));
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));

		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	
public ISrvMsg queryViewChart18(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String team = reqDTO.getValue("team");
		
		String employeeGz = reqDTO.getValue("employeeGz"); 
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select p.team,d.coding_name label ,count(p.EMPLOYEE_ID) value ");
		sb.append("  from view_human_project_relation p ");
		sb.append("  left join comm_coding_sort_detail d  on p.team=d.coding_code_id  ");
		sb.append("  where p.project_info_no = '").append(projectInfoNo).append("'  and p.actual_start_date is not null and p.actual_end_date is null   ");
		
		if(team != null && team.length() > 0){
			sb.append("  and  p.TEAM = '").append(team).append("' ");
		} 
		
		if(employeeGz != null || !"".equals(employeeGz)){ 
			sb.append("  and  p.EMPLOYEE_GZ = '").append(employeeGz).append("'");	 
		} 
		
		sb.append("  group by p.team,d.coding_name ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
//		root.addAttribute("caption", "项目岗位人员统计图");
		 
		List ulist = jdbcDAO.queryRecords(sb.toString());		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("link",  "j-getPostList-"+data.get("team"));
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));

		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
public ISrvMsg queryViewChartPost18(ISrvMsg reqDTO) throws Exception {
	
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
	
	String projectInfoNo = reqDTO.getValue("projectInfoNo");
	
	String team = reqDTO.getValue("team");
	
	String employeeGz = reqDTO.getValue("employeeGz");
	
	if(employeeGz == null || "".equals(employeeGz)){
		employeeGz = "%";
	}
	
	IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
	
	StringBuffer sb = new StringBuffer(" select p.WORK_POST,d.coding_name label ,count(p.EMPLOYEE_ID) value ");
	sb.append("  from view_human_project_relation p ");
	sb.append("  left join comm_coding_sort_detail d  on p.WORK_POST=d.coding_code_id  ");
	sb.append("  where p.project_info_no = '").append(projectInfoNo).append("'  and p.actual_start_date is not null and p.actual_end_date is null  ");
	
	if(team != null && team.length() > 0){
		sb.append("  and  p.TEAM = '").append(team).append("' ");
	} 
	
	sb.append("  and  p.EMPLOYEE_GZ like '").append(employeeGz).append("'");
	
	sb.append("  group by p.WORK_POST,d.coding_name ");

	Document document = DocumentHelper.createDocument();  		
	Element root = document.addElement("chart");
	root.addAttribute("bgColor", "F3F5F4,DEE6EB");
	root.addAttribute("formatNumberScale", "0");
	root.addAttribute("showValues", "1");
	root.addAttribute("baseFontSize", "12");
//	root.addAttribute("caption", "项目岗位人员统计图");
	 
	List ulist = jdbcDAO.queryRecords(sb.toString());		
	for(int i=0;i<ulist.size();i++){
		Map data = (Map) ulist.get(i);
		Element set = root.addElement("set");
		set.addAttribute("link",  "j-getHumanList-"+data.get("work_post"));
		set.addAttribute("label", (String)data.get("label"));
		set.addAttribute("value", (String)data.get("value"));

	}
		
	responseDTO.setValue("Str", document.asXML());
	
	return responseDTO;
}
	public ISrvMsg queryViewChart23(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String nums = reqDTO.getValue("nums");
		
		String team = reqDTO.getValue("team");
		
		String employeeGz = reqDTO.getValue("employeeGz");
			
 
		if(nums == null || "".equals(nums)){
			nums = "1";
		}

		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select p.WORK_POST,d.coding_name label ,count(p.EMPLOYEE_ID) value ");
		sb.append("  from view_human_project_relation p ");
		sb.append("  left join comm_coding_sort_detail d  on p.WORK_POST=d.coding_code_id  ");
		sb.append("  where p.project_info_no = '").append(projectInfoNo).append("'");
 
		if(team != null && team.length() > 0){
			sb.append("  and  p.TEAM = '").append(team).append("'");
		} 
		if(employeeGz != null || !"".equals(employeeGz)){
			sb.append("  and  p.EMPLOYEE_GZ = '").append(employeeGz).append("'");
		}

		sb.append(" and p.actual_start_date <= add_months(to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd') - 1, 1) ");// and (p.actual_end_date >= to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd') ) 

		sb.append("  group by p.WORK_POST,d.coding_name ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
//		root.addAttribute("caption", "项目岗位人员统计图");
		 
		List ulist = jdbcDAO.queryRecords(sb.toString());		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("link",  "j-getHumanList-"+data.get("work_post"));
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));

		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
    public ISrvMsg queryAddViewChart23(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String nums = reqDTO.getValue("nums");
		
		String team = reqDTO.getValue("team");
		
		String employeeGz = reqDTO.getValue("employeeGz"); 
 
		if(nums == null || "".equals(nums)){
			nums = "1";
		}
 
		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select p.TEAM,d.coding_name label ,count(p.EMPLOYEE_ID) value ");
		sb.append("  from view_human_project_relation p ");
		sb.append("  left join comm_coding_sort_detail d  on p.TEAM=d.coding_code_id  ");
		sb.append("  where p.project_info_no = '").append(projectInfoNo).append("'");
	 
		if(team != null && team.length() > 0){
			sb.append("  and  p.TEAM = '").append(team).append("'");
		} 
		if(employeeGz != null && !"".equals(employeeGz) && !"null".equals(employeeGz)){
			sb.append("  and  p.EMPLOYEE_GZ = '").append(employeeGz).append("'");
		}
		sb.append(" and p.actual_start_date <= add_months(to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd') - 1, 1)  ");//and (p.actual_end_date >= to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd')   )

		sb.append("  group by p.TEAM,d.coding_name ");

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("baseFontSize", "12");
//		root.addAttribute("caption", "项目岗位人员统计图");
		 
		List ulist = jdbcDAO.queryRecords(sb.toString());		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("link",  "j-selectPost-"+projectInfoNo+"_"+nums+"_"+data.get("team"));
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", (String)data.get("value"));

		}
			
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}

	public ISrvMsg queryViewChart19(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select sum(case when t.age<30 then 1 else 0 end)  n1,sum(case when t.age>=30 and t.age<40 then 1 else 0 end) n2, ");
		sb.append("  sum(case when t.age>=40 and t.age<50 then 1 else 0 end) n3,sum(case when t.age>=50 and t.age<60 then 1 else 0 end) n4,sum(case when t.age>=60 then 1 else 0 end) n5  from ( ");
		sb.append("  select e.employee_id, round(to_char(sysdate,'yyyy')-to_char(e.employee_birth_date,'yyyy')) age ");
		sb.append("  from comm_human_employee e, comm_human_employee_hr h ,comm_org_subjection s where e.employee_id = h.employee_id and e.org_id=s.org_id ");
		sb.append("  and e.bsflag = '0' and h.bsflag = '0' and s.bsflag='0' and h.spare7 = '0' and h.employee_gz is not null and s.org_subjection_id like '@orgid%' ");
		sb.append(" union all select l.labor_id employee_id, round(to_char(sysdate,'yyyy')-to_char(l.employee_birth_date,'yyyy')) age ");
		sb.append(" from bgp_comm_human_labor l   where l.bsflag='0' and l.if_engineer in ('0110000059000000003','0110000059000000001')  and l.owning_subjection_org_id like '@orgid%'  ) t ");
		

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart"); 
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("stack100Percent", "1");
		root.addAttribute("showXAxisPercentValues", "0");
		root.addAttribute("showSum", "0");
		root.addAttribute("numberSuffix", "人");
		
		Element categories = root.addElement("categories");
		
		for(int i=0;i<orgNames.length;i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", orgNames[i].split("-")[1]);
		}
		
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "30岁以下");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "30-40岁");
		Element dataset3 = root.addElement("dataset");		
		dataset3.addAttribute("seriesName", "40-50岁");
		Element dataset4 = root.addElement("dataset");		
		dataset4.addAttribute("seriesName", "50-60岁");
		Element dataset5 = root.addElement("dataset");		
		dataset5.addAttribute("seriesName", "60岁以上");
		
		
		for(int i=0;i<orgNames.length;i++){
			
			String newsql = sb.toString().replaceAll("@orgid", orgNames[i].split("-")[0]);
			Map map = jdbcDAO.queryRecordBySQL(newsql);
			
			String n1 = "0";
			String n2 = "0";
			String n3 = "0";
			String n4 = "0";
			String n5 = "0";
			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}	
			if(map != null && map.get("n3") != null){
				n3 = (String)map.get("n3");
			}
			if(map != null && map.get("n4") != null){
				n4 = (String)map.get("n4");
			}
			if(map != null && map.get("n5") != null){
				n5 = (String)map.get("n5");
			}

			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", n1);
			set1.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", n2);
			set2.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set3 = dataset3.addElement("set");
			set3.addAttribute("value", n3);
			set3.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set4 = dataset4.addElement("set");
			set4.addAttribute("value", n4);
			set4.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set5 = dataset5.addElement("set");
			set5.addAttribute("value", n5);
			set5.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
						
		}

		responseDTO.setValue("Str", document.asXML());
	
		return responseDTO;
	}
	
	
	public ISrvMsg queryViewChart20(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		UserToken user = reqDTO.getUserToken();
		String orgId = reqDTO.getValue("orgId");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		StringBuffer sb = new StringBuffer(" select ");
		sb.append(" sum(case when t.age<25 then 1 else 0 end) n1,round(sum(case when t.age<25 then 1 else 0 end)/count(1)*100,2) s1, ");
		sb.append(" sum(case when t.age>=25 and t.age<30 then 1 else 0 end) n2,round(sum(case when t.age>=25 and t.age<30 then 1 else 0 end)/count(1)*100,2) s2, ");
		sb.append(" sum(case when t.age>=35 and t.age<40 then 1 else 0 end) n3,round(sum(case when t.age>=35 and t.age<40 then 1 else 0 end)/count(1)*100,2) s3, ");
		sb.append(" sum(case when t.age>=40 and t.age<45 then 1 else 0 end) n4,round(sum(case when t.age>=40 and t.age<45 then 1 else 0 end)/count(1)*100,2) s4, ");
		sb.append(" sum(case when t.age>=45 and t.age<50 then 1 else 0 end) n5,round(sum(case when t.age>=45 and t.age<50 then 1 else 0 end)/count(1)*100,2) s5, ");
		sb.append(" sum(case when t.age>=50 and t.age<55 then 1 else 0 end) n6,round(sum(case when t.age>=50 and t.age<55 then 1 else 0 end)/count(1)*100,2) s6, ");
		sb.append(" sum(case when t.age>=55 and t.age<60 then 1 else 0 end) n7,round(sum(case when t.age>=55 and t.age<60 then 1 else 0 end)/count(1)*100,2) s7, ");
		sb.append(" sum(case when t.age>=60 then 1 else 0 end) n8,round(sum(case when t.age>=60 then 1 else 0 end)/count(1)*100,2)  s8 ");		
		sb.append("  from ( select e.employee_id, round(to_char(sysdate,'yyyy')-to_char(e.employee_birth_date,'yyyy')) age ");
		sb.append("  from comm_human_employee e, comm_human_employee_hr h ,comm_org_subjection s where e.employee_id = h.employee_id and e.org_id=s.org_id ");
		sb.append("  and e.bsflag = '0' and h.bsflag = '0' and s.bsflag='0' and h.spare7 = '0' and h.employee_gz is not null and s.org_subjection_id like '@orgid%' ");
		sb.append(" union all select l.labor_id employee_id, round(to_char(sysdate,'yyyy')-to_char(l.employee_birth_date,'yyyy')) age ");
		sb.append(" from bgp_comm_human_labor l   where l.bsflag='0' and l.if_engineer in ('0110000059000000003','0110000059000000001')  and l.owning_subjection_org_id like '@orgid%'  ) t ");
		

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart"); 
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numberSuffix", "%");
		
		String newsql = sb.toString().replaceAll("@orgid", orgId);
		
		Map map = jdbcDAO.queryRecordBySQL(newsql);
		
		for(int i=0;i<ageNames.length;i++){
			Element set = root.addElement("set");
			set.addAttribute("label", ageNames[i]);
			set.addAttribute("value", (String)map.get("s"+(i+1)));
			set.addAttribute("toolText", (String)map.get("n"+(i+1))+"人,"+(String)map.get("s"+(i+1))+"%");			
		}

		responseDTO.setValue("Str", document.asXML());
	
		return responseDTO;
	}

	

	public ISrvMsg queryViewChart21(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer(" select sum(case when t.employee_education_level = '0500100004000000012' then 1 else 0 end) n1, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000010' then 1 else 0 end) n2,  ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000008' then 1 else 0 end) n3,  ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000011' then 1 else 0 end) n4,  ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000005' then 1 else 0 end) n5,  ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000004' then 1 else 0 end) n6,  ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000002' then 1 else 0 end) n7,  ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000001' then 1 else 0 end) n8  ");
		sb.append("  from ( select e.employee_id,   case when e.employee_education_level is null then '0500100004000000012' when e.employee_education_level = '0500100004000000013' then '0500100004000000012' else e.employee_education_level end employee_education_level ");
		sb.append("  from comm_human_employee e, comm_human_employee_hr h ,comm_org_subjection s where e.employee_id = h.employee_id and e.org_id=s.org_id ");
		sb.append("  and e.bsflag = '0' and h.bsflag = '0' and s.bsflag='0' and h.spare7 = '0' and h.employee_gz is not null and s.org_subjection_id like '@orgid%' ");
		sb.append(" union all select l.labor_id employee_id, case when l.employee_education_level is null then '0500100004000000012' when l.employee_education_level = '0500100004000000013' then '0500100004000000012' else l.employee_education_level end employee_education_level ");
		sb.append(" from bgp_comm_human_labor l   where l.bsflag='0' and l.if_engineer in ('0110000059000000003','0110000059000000001')  and l.owning_subjection_org_id like '@orgid%'  ) t ");
		

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart"); 
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("stack100Percent", "1");
		root.addAttribute("showXAxisPercentValues", "0");
		root.addAttribute("showSum", "0");
		root.addAttribute("numberSuffix", "人");
		
		Element categories = root.addElement("categories");
		
		for(int i=0;i<orgNames.length;i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", orgNames[i].split("-")[1]);
		}
		
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "初中及以下");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "技校");
		Element dataset3 = root.addElement("dataset");		
		dataset3.addAttribute("seriesName", "中专");
		Element dataset4 = root.addElement("dataset");		
		dataset4.addAttribute("seriesName", "高中");
		Element dataset5 = root.addElement("dataset");		
		dataset5.addAttribute("seriesName", "大学专科");
		Element dataset6 = root.addElement("dataset");		
		dataset6.addAttribute("seriesName", "大学本科");
		Element dataset7 = root.addElement("dataset");		
		dataset7.addAttribute("seriesName", "硕士研究生");
		Element dataset8 = root.addElement("dataset");		
		dataset8.addAttribute("seriesName", "博士研究生");
		
		
		for(int i=0;i<orgNames.length;i++){
			
			String newsql = sb.toString().replaceAll("@orgid", orgNames[i].split("-")[0]);
			Map map = jdbcDAO.queryRecordBySQL(newsql);
			
			String n1 = "0";
			String n2 = "0";
			String n3 = "0";
			String n4 = "0";
			String n5 = "0";
			String n6 = "0";
			String n7 = "0";
			String n8 = "0";
			
			if(map != null && map.get("n1") != null){
				n1 = (String)map.get("n1");
			}
			if(map != null && map.get("n2") != null){
				n2 = (String)map.get("n2");
			}	
			if(map != null && map.get("n3") != null){
				n3 = (String)map.get("n3");
			}
			if(map != null && map.get("n4") != null){
				n4 = (String)map.get("n4");
			}
			if(map != null && map.get("n5") != null){
				n5 = (String)map.get("n5");
			}
			if(map != null && map.get("n6") != null){
				n6 = (String)map.get("n6");
			}
			if(map != null && map.get("n7") != null){
				n7 = (String)map.get("n7");
			}
			if(map != null && map.get("n8") != null){
				n8 = (String)map.get("n8");
			}
			
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", n1);
			set1.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", n2);
			set2.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set3 = dataset3.addElement("set");
			set3.addAttribute("value", n3);
			set3.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set4 = dataset4.addElement("set");
			set4.addAttribute("value", n4);
			set4.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set5 = dataset5.addElement("set");
			set5.addAttribute("value", n5);
			set5.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set6 = dataset6.addElement("set");
			set6.addAttribute("value", n6);
			set6.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set7 = dataset7.addElement("set");
			set7.addAttribute("value", n7);
			set7.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
			Element set8 = dataset8.addElement("set");
			set8.addAttribute("value", n8);
			set8.addAttribute("link", "j-myJS-"+orgNames[i].split("-")[0]);
						
		}

		responseDTO.setValue("Str", document.asXML());
	
		return responseDTO;
	}
	
	public ISrvMsg queryViewChart22(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		UserToken user = reqDTO.getUserToken();
		String orgId = reqDTO.getValue("orgId");
		
		if(orgId == null || "".equals(orgId)){
			orgId = user.getSubOrgIDofAffordOrg();
		}
		
		StringBuffer sb = new StringBuffer(" select sum(case when t.employee_education_level = '0500100004000000012' then 1 else 0 end) n1, ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000012' then 1 else 0 end)/count(1)*100,2) s1, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000010' then 1 else 0 end) n2,  ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000010' then 1 else 0 end)/count(1)*100,2) s2, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000008' then 1 else 0 end) n3,  ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000008' then 1 else 0 end)/count(1)*100,2) s3, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000011' then 1 else 0 end) n4,  ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000011' then 1 else 0 end)/count(1)*100,2) s4, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000005' then 1 else 0 end) n5,  ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000005' then 1 else 0 end)/count(1)*100,2) s5, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000004' then 1 else 0 end) n6,  ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000004' then 1 else 0 end)/count(1)*100,2) s6, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000002' then 1 else 0 end) n7,  ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000002' then 1 else 0 end)/count(1)*100,2) s7, ");
		sb.append(" sum(case when t.employee_education_level = '0500100004000000001' then 1 else 0 end) n8,  ");
		sb.append(" round(sum(case when t.employee_education_level = '0500100004000000001' then 1 else 0 end)/count(1)*100,2) s8 ");
		sb.append("  from ( select e.employee_id,   case when e.employee_education_level is null then '0500100004000000012' when e.employee_education_level = '0500100004000000013' then '0500100004000000012' else e.employee_education_level end employee_education_level ");
		sb.append("  from comm_human_employee e, comm_human_employee_hr h ,comm_org_subjection s where e.employee_id = h.employee_id and e.org_id=s.org_id ");
		sb.append("  and e.bsflag = '0' and h.bsflag = '0' and s.bsflag='0' and h.spare7 = '0' and h.employee_gz is not null and s.org_subjection_id like '@orgid%' ");
		sb.append(" union all select l.labor_id employee_id, case when l.employee_education_level is null then '0500100004000000012' when l.employee_education_level = '0500100004000000013' then '0500100004000000012' else l.employee_education_level end employee_education_level ");
		sb.append(" from bgp_comm_human_labor l   where l.bsflag='0' and l.if_engineer in ('0110000059000000003','0110000059000000001')  and l.owning_subjection_org_id like '@orgid%'  ) t ");
		

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart"); 
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numberSuffix", "%");
				
		String newsql = sb.toString().replaceAll("@orgid", orgId);
		
		Map map = jdbcDAO.queryRecordBySQL(newsql);
		
		for(int i=0;i<eduNames.length;i++){
			Element set = root.addElement("set");
			set.addAttribute("label", eduNames[i]);
			set.addAttribute("value", (String)map.get("s"+(i+1)));
			set.addAttribute("toolText", (String)map.get("n"+(i+1))+"人,"+(String)map.get("s"+(i+1))+"%");			
		}

		responseDTO.setValue("Str", document.asXML());
	
		return responseDTO;
	}
	
	
	
	public ISrvMsg queryHumanProjectView(ISrvMsg reqDTO) throws Exception {
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("s_project_info_no");
		String projectName = reqDTO.getValue("s_project_name");
				
		StringBuffer sb = new StringBuffer("select t.apply_team, t.post, t.apply_team_name, t.post_name, t.plan_number, t2.people_number,t3.prepare_number, ");
		sb.append(" t4.accept_num,t5.return_num,t6.pro_num ");
		sb.append(" from ( select p.apply_team_name, p.post_name, p.apply_team, p.post, sum(nvl(p.people_number, 0)) plan_number ");
		sb.append(" from (select d.apply_team, s1.coding_name apply_team_name, d.post,s2.coding_name post_name, d.people_number ");
		sb.append(" from bgp_comm_human_plan_detail d left join comm_coding_sort_detail s1 on d.apply_team = s1.coding_code_id and s1.bsflag = '0' ");
		sb.append(" left join comm_coding_sort_detail s2 on d.post = s2.coding_code_id and s2.bsflag = '0' ");
		sb.append(" where d.project_info_no = '").append(projectInfoNo).append("' and d.bsflag = '0') p ");
		sb.append(" group by p.apply_team_name, p.post_name, p.apply_team, p.post) t ");
		sb.append(" left join (select p.apply_team, p.post, sum(p.people_number) people_number ");
		sb.append(" from (select p.apply_team, p.post, p.people_number, r.project_info_no ");
		sb.append(" from bgp_project_human_requirement r left join bgp_project_human_post p on r.requirement_no = p.requirement_no ");
		sb.append(" and p.bsflag = '0'  where r.bsflag = '0'");
		sb.append(" union all ");
		sb.append(" select p.apply_team,p.post, p.people_number, r.project_info_no  from bgp_project_human_relief r ");
		sb.append(" left join bgp_project_human_reliefdetail p on r.human_relief_no = p.human_relief_no and p.bsflag = '0' ");
		sb.append(" where r.bsflag = '0' ");
		sb.append(" union all ");
		sb.append(" select p.apply_team, p.post, nvl(p.own_num, 0) + nvl(p.deploy_num, 0) people_number, r.project_info_no ");
		sb.append(" from bgp_project_human_profess r left join bgp_project_human_profess_post p on r.profess_no = p.profess_no ");
		sb.append(" where r.bsflag = '0') p where p.project_info_no = '").append(projectInfoNo).append("' group by p.apply_team, p.post ");
		sb.append(" ) t2 on t.apply_team = t2.apply_team  and t.post = t2.post ");
		sb.append(" left join ( select p.project_info_no, d.team apply_team, d.work_post post,count(d.employee_id) prepare_number ");
		sb.append(" from bgp_human_prepare_human_detail d left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' ");
		sb.append(" where p.project_info_no = '").append(projectInfoNo).append("' ");
		sb.append(" group by p.project_info_no, d.team, d.work_post) t3 on t.apply_team =t3.apply_team and t.post = t3.post ");
		sb.append(" left join ( select t.TEAM apply_team, t.WORK_POST post, count(t.EMPLOYEE_ID) accept_num from view_human_project_relation t ");
		sb.append(" where t.ACTUAL_START_DATE is not null and t.PROJECT_INFO_NO='").append(projectInfoNo).append("' group by t.TEAM, t.WORK_POST ) t4  ");
		sb.append(" on t.apply_team = t4.apply_team  and t.post = t4.post ");
		sb.append(" left join ( select t.TEAM apply_team, t.WORK_POST post, count(t.EMPLOYEE_ID) return_num from view_human_project_relation t ");
		sb.append(" where t.ACTUAL_END_DATE is not null and t.PROJECT_INFO_NO='").append(projectInfoNo).append("' group by t.TEAM, t.WORK_POST ) t5  ");
		sb.append(" on t.apply_team = t5.apply_team  and t.post = t5.post ");
		sb.append(" left join ( select t.TEAM apply_team, t.WORK_POST post, count(t.EMPLOYEE_ID) pro_num from view_human_project_relation t ");
		sb.append(" where t.ACTUAL_START_DATE is not null and t.ACTUAL_END_DATE is not null and t.PROJECT_INFO_NO='").append(projectInfoNo).append("' group by t.TEAM, t.WORK_POST ) t6  ");
		sb.append(" on t.apply_team = t6.apply_team  and t.post = t6.post  order by t.apply_team asc ");

		List<Map> list = jdbcDAO.queryRecords(sb.toString());
		
		msg.setValue("datas", list);
		msg.setValue("projectInfoNo", projectInfoNo);
		msg.setValue("projectName", projectName);
		
		return msg;		
	}
	
	public ISrvMsg queryHumanProjectList(ISrvMsg reqDTO) throws Exception {
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String applyTeam = reqDTO.getValue("applyTeam");
		String post = reqDTO.getValue("post");
		String flag = reqDTO.getValue("flag");
		
		StringBuffer sb = new StringBuffer("select t.EMPLOYEE_NAME,d1.coding_name employee_gz_name,d2.coding_name employee_education_level,t.EMPLOYEE_BIRTH_DATE,");
		sb.append(" d3.coding_name team_name,d4.coding_name work_post_name,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE ");
		sb.append(" from view_human_project_relation t left join comm_coding_sort_detail d1 on t.EMPLOYEE_GZ=d1.coding_code_id ");
		sb.append(" left join comm_coding_sort_detail d2 on t.EMPLOYEE_EDUCATION_LEVEL=d2.coding_code_id ");
		sb.append(" left join comm_coding_sort_detail d3 on t.TEAM=d3.coding_code_id ");
		sb.append(" left join comm_coding_sort_detail d4 on t.WORK_POST=d4.coding_code_id ");
		sb.append(" where t.PROJECT_INFO_NO = '").append(projectInfoNo).append("' ");
		sb.append(" and t.TEAM = '").append(applyTeam).append("'");
		sb.append(" and t.WORK_POST = '").append(post).append("'");
		
		if("1".equals(flag)){
			sb.append(" and t.ACTUAL_START_DATE is not null ");
		}else if("2".equals(flag)){
			sb.append(" and t.ACTUAL_END_DATE is not null ");
		}else{
			sb.append(" and t.ACTUAL_START_DATE is not null and t.ACTUAL_END_DATE is null ");
		}

		List<Map> list = jdbcDAO.queryRecords(sb.toString());
		
		msg.setValue("datas", list);
		
		return msg;	
	}
	
	public ISrvMsg queryOrgProjectHuman(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
//		String orgSubjectionId = user.getOrgSubjectionId();
		String orgSubjectionId = reqDTO.getValue("orgSub");
		String employeeGz = reqDTO.getValue("employeeGz");
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;
				
		StringBuffer sql = new StringBuffer("select t.* from (select  t.project_type,t.project_info_no,t.project_name,t.org_name,t.manage_org_name,  t.market_classify_name,count(r1.EMPLOYEE_ID) nn,sum(decode(r1.EMPLOYEE_GZ,'0110000019000000001',1,0)) n1, ");		
		sql.append(" sum(decode(r1.EMPLOYEE_GZ,'0110000019000000002',1,0)) n2 ");
		//sql.append(" , sum(decode(r1.EMPLOYEE_GZ,'0110000059000000005',1,0)) n3,sum(decode(r1.EMPLOYEE_GZ,'0110000059000000003',1,0)) n4, sum(decode(r1.EMPLOYEE_GZ,'0110000059000000001',1,0)) n5 ");
		sql.append("  from ( select distinct t.project_type, t.project_info_no,t.project_name,wmsys.wm_concat(oi.org_abbreviation) org_name , ccsd.coding_name as manage_org_name,  ccsd1.coding_name as market_classify_name from gp_task_project t ");
		sql.append(" inner join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0' ");
		sql.append(" and dy.org_subjection_id like '").append(orgSubjectionId).append("%' inner join comm_org_subjection s on dy.org_id=s.org_id and s.bsflag='0' ");
		sql.append(" left join comm_org_information oi on dy.org_id = oi.org_id    ");
		sql.append(" left join comm_coding_sort_detail ccsd on t.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ");
		sql.append(" left join comm_coding_sort_detail ccsd1 on t.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ");
		sql.append(" where t.bsflag='0'   ");
		sql.append(" and s.org_subjection_id like '").append(orgSubjectionId).append("%' ");
		sql.append(" group by t.project_info_no,t.project_name,ccsd.coding_name,ccsd1.coding_name,t.project_type) t left join view_human_project_relation_s r1 on t.project_info_no=r1.project_info_no   where r1.actual_start_date is not null and r1.actual_end_date is null and  r1.EMPLOYEE_GZ   ='"+employeeGz+"' ");
		sql.append(" group by t.project_info_no,t.project_name,t.org_name ,t.manage_org_name,  t.market_classify_name,t.project_type) t   where t.n1 !='0' or t.n2 !='0' or t.nn !='0'  order by t.nn desc ");
		
		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append(sql.toString());
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		
		List datas=BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(sql.toString()).append(")");
																								
		String totalRows = "0";
		Map countMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(humanSql.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		msg.setValue("datas", datas);
		msg.setValue("totalRows", totalRows);

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		msg.setValue("pageCount", pageCount);
		msg.setValue("pageSize", pageSize);
		msg.setValue("currentPage", currentPage);
		
		return msg;
	}
	
	public ISrvMsg queryMonthProject(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String nums = reqDTO.getValue("nums");	
		String employeeGz = reqDTO.getValue("employeeGz");
	 
	    String orgSubjectionId = reqDTO.getValue("org_sub");
		
		if(orgSubjectionId == null || "".equals(orgSubjectionId)){
			orgSubjectionId =user.getSubOrgIDofAffordOrg();
		}
		
		
		String applyDate = new SimpleDateFormat("yyyy").format(new Date());
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;
				
/*	旧sql	StringBuffer sql = new StringBuffer("select distinct t.project_type,t.project_info_no,t.project_name,oi.org_abbreviation org_name ,ccsd.coding_name manage_org,ccsd1.coding_name market_classify  ");		
		sql.append(" from ");
		sql.append(" bgp_human_prepare p join  bgp_human_prepare_human_detail d  on p.prepare_no = d.prepare_no ");
		sql.append(" left join gp_task_project t on p.project_info_no=t.project_info_no ");
		sql.append(" left join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0' ");
		sql.append(" left join comm_org_information oi on dy.org_id = oi.org_id ");
		sql.append(" left join comm_org_subjection s on dy.org_id=s.org_id and s.bsflag='0'  ");
		sql.append(" left join comm_coding_sort_detail ccsd on t.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ");
		sql.append(" left join comm_coding_sort_detail ccsd1 on t.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ");
		sql.append(" left join view_human_project_relation vpr   on vpr.PROJECT_INFO_NO=t.project_info_no  ");
		sql.append(" where t.bsflag='0'  ");
		sql.append(" and s.org_subjection_id like '").append(orgSubjectionId).append("%' and vpr.employee_gz='"+employeeGz+"' "); 
    	sql.append(" and vpr.actual_start_date <=  add_months(to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd') - 1, 1)  ");
    	sql.append("  and (vpr.actual_end_date >= to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd') or vpr.actual_end_date is null) ");
		sql.append(" and (d.actual_start_date <= add_months(to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd') - 1, 1) or (d.actual_end_date >= to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd')  or d.actual_end_date is null)) ");
		*/
		
		StringBuffer sql = new StringBuffer(" select t.*  from (select t.project_type,  t.project_info_no,  t.project_name,  t.org_name,  t.manage_org_name,  t.market_classify_name,  count(r1.EMPLOYEE_ID) nn,  sum(decode(r1.EMPLOYEE_GZ, '0110000019000000001', 1, 0)) n1,  sum(decode(r1.EMPLOYEE_GZ, '0110000019000000002', 1, 0)) n2  from (select distinct t.project_type,  t.project_info_no,  t.project_name,  wmsys.wm_concat(oi.org_abbreviation) org_name,  ccsd.coding_name as manage_org_name,  ccsd1.coding_name as market_classify_name  from gp_task_project t ");
		sql.append("  inner join gp_task_project_dynamic dy  on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0'  and dy.org_subjection_id like '").append(orgSubjectionId).append("%' ");
		sql.append("  inner join comm_org_subjection s  on dy.org_id = s.org_id  and s.bsflag = '0'  left join comm_org_information oi  on dy.org_id = oi.org_id  left join comm_coding_sort_detail ccsd  on t.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'  left join comm_coding_sort_detail ccsd1  on t.market_classify = ccsd1.coding_code_id  and ccsd1.bsflag = '0'  where t.bsflag = '0'  and s.org_subjection_id like  '").append(orgSubjectionId).append("%'  ");
		sql.append("  group by t.project_info_no,  t.project_name,  ccsd.coding_name,  ccsd1.coding_name,  t.project_type) t");
		sql.append("    left join view_human_project_relation  r1  on t.project_info_no = r1.project_info_no  where r1.actual_start_date <=  add_months(to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd') - 1, 1) ");  //and (r1.actual_end_date >= to_date('").append(applyDate).append("-").append(nums).append("-01', 'yyyy-MM-dd')  ) 
		sql.append("  and r1.EMPLOYEE_GZ = '").append(employeeGz).append("'  group by t.project_info_no,  t.project_name,  t.org_name,  t.manage_org_name,  t.market_classify_name,  t.project_type) t  where t.n1 != '0'  or t.n2 != '0'  or t.nn != '0'  order by t.nn desc");
	 
		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append(sql.toString());
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		
		List datas=BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(sql.toString()).append(")");
																								
		String totalRows = "0";
		Map countMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(humanSql.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		msg.setValue("datas", datas);
		msg.setValue("totalRows", totalRows);

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		msg.setValue("pageCount", pageCount);
		msg.setValue("pageSize", pageSize);
		msg.setValue("currentPage", currentPage);
		
		return msg;
	}
}

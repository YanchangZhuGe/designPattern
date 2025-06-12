package com.bgp.mcs.service.mat.service;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class MatChartServiceSrv extends BaseService{
	
	private static final String[] orgNames = { "C105001002%-�½�", "C105001003%-�¹�","C105001004%-�ຣ" ,"C105005004%-����", "C105005000%-����","C1050635%-�ɺ�","C105002%-���ʲ�", "C105001005%-����ľ","C105005001%-������̽","C105007%-���"};
	private static final String[] teamNames = {"0110000001000000008-���߰�","0110000001000000001-������","0110000001000000024-�꾮��","0110000001000000023-˾����","0110000001000000017-������","0110000001000000019-������","0110000001000000018-������","0110000001000000013-������"};
	private final static String LineAColor = "1381c0";
	private final static String LineBColor = "fd962e";
	private final static String LineCColor = "666666";
	public ISrvMsg queryViewChart1(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append("select 'ըҩ' label,'1091-1905' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%') and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�׹�' label,'1903' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select 'ȼ����' label,'0703' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'0703%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�Ŵ�' label,'36070205' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '��¼ֽ' label,'200103' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'200103%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '������' label,'32019904' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '���' label,'02-28-37-47-48-51-55-56-57-58' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and (i.coding_code_id like'02%'or i.coding_code_id like'28%'or i.coding_code_id like'37%'or i.coding_code_id like'47%'or i.coding_code_id like'48%'or i.coding_code_id like'51%'or i.coding_code_id like'55%'or i.coding_code_id like'56%'or i.coding_code_id like'57%'or i.coding_code_id like'58%') where d.bsflag='0' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '����' lable,'1091-1905-1903-0703-36070205-200103-32019904-02-28-37-47-48-51-55-56-57-58'mat_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and (i.coding_code_id like'1091%'or i.coding_code_id like'1905%'or i.coding_code_id like'1903%'or i.coding_code_id like'0703%'or i.coding_code_id like'36070205%'or i.coding_code_id like'200103%'or i.coding_code_id like'32019904%'or i.coding_code_id like'02%'or i.coding_code_id like'28%'or i.coding_code_id like'37%'or i.coding_code_id like'47%'or i.coding_code_id like'48%'or i.coding_code_id like'51%'or i.coding_code_id like'55%'or i.coding_code_id like'56%'or i.coding_code_id like'57%'or i.coding_code_id like'58%') where d.bsflag='0' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append(") )value from dual");
		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("showPercentInToolTip", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showPercentValues", "1");
		root.addAttribute("legendPosition", "RIGHT");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("numberSuffix", "��Ԫ");
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			if(Double.valueOf((String)data.get("value"))>0){
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", ""+Double.valueOf((String)data.get("value"))/10000+"");
			set.addAttribute("link", "j-drillwzzbxh-"+(String)data.get("mat_id")+"");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart2(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		String startDate = new java.text.SimpleDateFormat("yyyy-MM").format(new Date()); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map dataMap = new HashMap();
		double meanNUm=0;
		for(int i=0;i<orgNames.length;i++){
			String[] orgName = orgNames[i].split("-");
			StringBuffer sb = new StringBuffer("");
			sb.append("select case when a.w_price =0 then 0 else b.total_money / (a.w_price * 10000) end value from (select to_char(nvl(sum(decode(gp.EXPLORATION_METHOD,")
              .append(" '0300100012000000003',")
              .append(" gd.finish_3d_workload,")
              .append("'0300100012000000002',")
              .append(" gd.finish_2d_workload)) * nvl(max(pi.price_unit),0)/10000,")
              .append(" 0),'99999999.00') w_price,'"+orgName[0]+"' orgSubId")
              .append(" from rpt_gp_daily gd")
              .append(" left outer join gp_task_project gp")
              .append(" on gd.project_info_no = gp.project_info_no")
              .append(" left outer join bgp_op_price_project_info pi") 
              .append(" on gd.project_info_no = pi.project_info_no and pi.bsflag='0' and pi.node_code='S01021'")
              .append(" where gd.bsflag = '0' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')") 
              .append(" and gd.org_subjection_id like '"+orgName[0]+"') a inner join (select '"+orgName[0]+"' orgSubId,sum(d.total_money)total_money from GMS_MAT_TEAMMAT_OUT_DETAIL d where d.org_subjection_id like '"+orgName[0]+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')) b on a.orgSubId=b.orgSubId");
              
			  Map map = jdbcDAO.queryRecordBySQL(sb.toString());
			  dataMap.put(orgName[1], map.get("value"));
			  meanNUm += Double.valueOf(map.get("value").toString());
		}
		StringBuffer sbc = new StringBuffer();
		sbc.append("<chart palette='2'  showValues='0' decimals='3' formatNumberScale='0'>")
			.append("<set label='����ľ' value='"+dataMap.get("����ľ")+"' link='j-drillwyczxh-"+"C105001005"+"'/>")
			.append("<set label='�½�' value='"+dataMap.get("�½�")+"' link='j-drillwyczxh-"+"C105001002"+"'/>")
			.append("<set label='�¹�' value='"+dataMap.get("�¹�")+"' link='j-drillwyczxh-"+"C105001003"+"'/>")
			.append("<set label='�ຣ' value='"+dataMap.get("�ຣ")+"' link='j-drillwyczxh-"+"C105001004"+"'/>")
			.append("<set label='����' value='"+dataMap.get("����")+"' link='j-drillwyczxh-"+"C105005004"+"'/>")
			.append("<set label='����' value='"+dataMap.get("����")+"' link='j-drillwyczxh-"+"C105005000"+"'/>")
			.append("<set label='����' value='"+dataMap.get("����")+"' link='j-drillwyczxh-"+"C105005001"+"'/>")
			.append("<set label='���' value='"+dataMap.get("���")+"' link='j-drillwyczxh-"+"C105007"+"'/>")
			.append("<set label='�ɺ�' value='"+dataMap.get("�ɺ�")+"' link='j-drillwyczxh-"+"C1050635"+"'/>")
			.append("<set label='���ʲ�' value='"+dataMap.get("���ʲ�")+"' link='j-drillwyczxh-"+"C105002"+"'/>")
			.append("<trendlines><line startValue='"+meanNUm/10+"' displayValue='"+((double)((int)((meanNUm/10)*10000)))/10000+"' color='0000ff' valueOnRight='1' /></trendlines>")
			.append("</chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
		
	}
	public ISrvMsg queryViewChart3(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		UserToken user = reqDTO.getUserToken();
		
		String orgSubjectionId = "C105%";
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append("select '����ľ' lable,'C105001005' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105001005%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�½�' lable,'C105001002' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105001002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�¹�' lable,'C105001003' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105001003%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�ຣ' lable,'C105001004' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105001004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '����' lable,'C105005004' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105005004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '����' lable,'C105005000' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105005000%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '����' lable,'C105005001' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105005001%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '���' lable,'C105007' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105007%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�ɺ�' lable,'C1050635' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C1050635%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '���ʲ�' lable,'C105002' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d left join comm_org_subjection s on d.org_subjection_id=s.org_subjection_id where d.org_subjection_id like 'C105002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		
		List ulist = jdbcDAO.queryRecords(sb.toString());
		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("yAxisName", "��Ԫ");
		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("lable"));
			double num = ((double)((int)((Double.valueOf((String)data.get("value"))/10000)*100)))/100;
			set.addAttribute("value", ""+num+"");
			set.addAttribute("link", "j-drillwzxhxh-"+(String)data.get("org_subjection_id")+"");
		}	
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart4(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sb = new StringBuffer("");
//		sb.append("select d.coding_name lable,d.coding_code_id,sum(t.total_money)value from GMS_MAT_TEAMMAT_OUT t inner join comm_coding_sort_detail d on t.team_id=d.coding_code_id and d.bsflag='0'  where t.team_id is not null and t.project_info_no='"+projectInfoNo+"' and t.bsflag='0' group by d.coding_name,d.coding_code_id");
		sb.append("select tt.lable,tt.coding_code_id,nvl(tt.value,0)-nvl(dd.value,0) value from (select d.coding_name lable, d.coding_code_id, sum(t.total_money) value from GMS_MAT_TEAMMAT_OUT t inner join comm_coding_sort_detail d on t.team_id = d.coding_code_id and d.bsflag = '0' where t.team_id is not null and t.project_info_no = '"+projectInfoNo+"' and t.bsflag = '0' group by d.coding_name, d.coding_code_id) tt left join  (select d.coding_name lable, d.coding_code_id, sum(t.total_money) value from gms_mat_out_info t inner join comm_coding_sort_detail d on t.storeroom = d.coding_code_id and d.bsflag = '0' where t.storeroom is not null and t.project_info_no = '"+projectInfoNo+"' and t.bsflag = '0' group by d.coding_name, d.coding_code_id) dd on tt.coding_code_id=dd.coding_code_id");
		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("labelDisplay", "WRAP");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("yAxisName", "��Ԫ");
		
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			set.addAttribute("label", (String)data.get("lable"));
			set.addAttribute("value", ""+((double)((int)((Double.valueOf((String)data.get("value"))/10000)*100)))/100+"");
			set.addAttribute("link", "j-drillwzbzxh-"+(String)data.get("coding_code_id")+"");
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart5(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		String startDate = new java.text.SimpleDateFormat("yyyy-MM").format(new Date()); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb1 = new StringBuffer("");
		sb1.append("select 'ըҩ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%') and d.project_info_no='"+projectInfoNo+"'");
		sb1.append(" union all");
		sb1.append(" select 'ըҩ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%') and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		List list1 = jdbcDAO.queryRecords(sb1.toString());
		
		StringBuffer sb2 = new StringBuffer("");
		sb2.append("select '�׹�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%'and d.project_info_no='"+projectInfoNo+"'");
		sb2.append(" union all");
		sb2.append(" select '�׹�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%' and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		List list2 = jdbcDAO.queryRecords(sb2.toString());
		
		StringBuffer sb3 = new StringBuffer("");
		sb3.append("select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d  inner join gms_mat_teammat_out t on d.teammat_out_id=t.teammat_out_id and t.bsflag='0' inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'0703%'  and (t.plan_invoice_id is null or t.plan_invoice_id not in (select oi.out_info_id from gms_mat_out_info oi where oi.bsflag='0' and oi.project_info_no='"+projectInfoNo+"' )) and d.project_info_no='"+projectInfoNo+"'");
		sb3.append(" union all");
		sb3.append(" select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'0703%' and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		List list3 = jdbcDAO.queryRecords(sb3.toString());
		
		StringBuffer sb4 = new StringBuffer("");
		sb4.append("select '�Ŵ�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205'and d.project_info_no='"+projectInfoNo+"'");
		sb4.append(" union all");
		sb4.append(" select '�Ŵ�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205' and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		List list4 = jdbcDAO.queryRecords(sb4.toString());
		
		StringBuffer sb5 = new StringBuffer("");
		sb5.append("select '��¼ֽ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'200103%'and d.project_info_no='"+projectInfoNo+"'");
		sb5.append(" union all");
		sb5.append(" select '��¼ֽ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'200103%' and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		List list5 = jdbcDAO.queryRecords(sb5.toString());
		
		StringBuffer sb6 = new StringBuffer("");
		sb6.append("select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904'and d.project_info_no='"+projectInfoNo+"'");
		sb6.append(" union all");
		sb6.append(" select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904' and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		List list6 = jdbcDAO.queryRecords(sb6.toString());
		
		StringBuffer sb8 = new StringBuffer("");
		sb8.append("select 'С��Ʒ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id in ('07050101','07050102','07050105','07090104','07070104','07050106','07080109','07080107','07080101','07080201','07070107','17990501')  and d.project_info_no='"+projectInfoNo+"'");
		sb8.append(" union all");
		sb8.append(" select 'С��Ʒ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id in ('07050101','07050102','07050105','07090104','07070104','07050106','07080109','07080107','07080101','07080201','07070107','17990501') and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		List list8 = jdbcDAO.queryRecords(sb8.toString());
		
		StringBuffer sb7 = new StringBuffer("");
		sb7.append(" select '����' lable,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%')and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") )value from dual");
		sb7.append(" union all");
		sb7.append(" select '����' lable,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%') and to_char(d.create_date,'yyyy-MM-dd') like '"+startDate+"%'and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") )value from dual");
		List list7 = jdbcDAO.queryRecords(sb7.toString());
		
		StringBuffer sbc = new StringBuffer();
		sbc.append(" <chart showvalues='0'  numberPrefix='��' showSum='1' decimals='3' useRoundEdges='1' legendBorderAlpha='0'rotateYAxisName='0' yAxisNameWidth='16' yAxisName='��Ԫ' formatNumberScale='0'>")
		.append(" <categories><category label='ըҩ' /><category label='�׹�' /><category label='����' />")
		.append(" <category label='�Ŵ�' /><category label='��¼ֽ' /><category label='������' /><category label='С��Ʒ' /><category label='����' /></categories>")
		.append(" <dataset seriesName='�ۼ��������' color='AFD8F8' showValues='0'><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list3.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list4.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list5.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list6.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list8.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list7.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset>")
		.append(" <dataset seriesName='�����������' color='fd962e' showValues='0'><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list3.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list4.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list5.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list6.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list8.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list7.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset></chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
		
	}
	public ISrvMsg queryViewChart6(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append("select 'ըҩ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%')and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '�׹�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_teammat_out t on d.teammat_out_id = t.teammat_out_id and t.bsflag = '0' inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and (t.plan_invoice_id is null or t.plan_invoice_id not in (select oi.out_info_id from gms_mat_out_info oi where oi.bsflag = '0' and oi.project_info_no = '"+projectInfoNo+"')) and i.coding_code_id like'0703%'and t.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select 'С��Ʒ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_teammat_out t on d.teammat_out_id = t.teammat_out_id and t.bsflag = '0' inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and (t.plan_invoice_id is null or t.plan_invoice_id not in (select oi.out_info_id from gms_mat_out_info oi where oi.bsflag = '0' and oi.project_info_no = '"+projectInfoNo+"')) and i.coding_code_id in ('07050101','07050102','07050105','07090104','07070104','07050106','07080109','07080107','07080101','07080201','07070107','17990501') and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '�Ŵ�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '��¼ֽ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'200103%'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '�������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'37%'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'02%'or i.coding_code_id like'47%'or i.coding_code_id like'48%')and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '�������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'51%'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '�������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'57%'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '�ͱ�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'21%'and d.project_info_no='"+projectInfoNo+"'");
		sb.append("union all");
		sb.append(" select '���' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'02%'or i.coding_code_id like'47%')and d.project_info_no='"+projectInfoNo+"'");
		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("showPercentInToolTip", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showPercentValues", "1");
		root.addAttribute("legendPosition", "RIGHT");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("numberSuffix", "��Ԫ");
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			if(Double.valueOf((String)data.get("value"))>0){
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", ""+Double.valueOf((String)data.get("value"))/10000+"");
			}
			
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart7(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		String startDate = new java.text.SimpleDateFormat("yyyy-MM").format(new Date()); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb1 = new StringBuffer("");
		sb1.append("select 'ըҩ' label,nvl(sum(t.cost_detail_money),0) value  from view_op_target_plan_money  t where project_info_no = '"+projectInfoNo+"' and t.node_code ='S01001006001005'");
		sb1.append(" union all");
		sb1.append(" select 'ըҩ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%')and d.project_info_no='"+projectInfoNo+"'");
		List list1 = jdbcDAO.queryRecords(sb1.toString());
		
		StringBuffer sb2 = new StringBuffer("");
		sb2.append("select '�׹�' label,nvl(sum(t.cost_detail_money),0) value  from view_op_target_plan_money  t where project_info_no = '"+projectInfoNo+"' and t.node_code ='S01001006001002'");
		sb2.append(" union all");
		sb2.append(" select '�׹�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%'and d.project_info_no='"+projectInfoNo+"'");
		List list2 = jdbcDAO.queryRecords(sb2.toString());
		
		StringBuffer sb3 = new StringBuffer("");
		sb3.append("select '����' label,nvl(sum(t.cost_detail_money),0) value  from view_op_target_plan_money  t where project_info_no = '"+projectInfoNo+"' and (t.node_code = 'S01001006004001001' or t.node_code = 'S01001006004001002' or t.node_code = 'S01001006004001003001')");
		sb3.append(" union all");
		sb3.append(" select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_teammat_out t on d.teammat_out_id = t.teammat_out_id and t.bsflag = '0' inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and (t.plan_invoice_id is null or t.plan_invoice_id not in (select oi.out_info_id from gms_mat_out_info oi where oi.bsflag = '0' and oi.project_info_no = '"+projectInfoNo+"')) and i.coding_code_id like'0703%'and d.project_info_no='"+projectInfoNo+"'");
		List list3 = jdbcDAO.queryRecords(sb3.toString());
		
		StringBuffer sb4 = new StringBuffer("");
		sb4.append("select '�Ŵ�' label,nvl(sum(t.cost_detail_money),0) value  from view_op_target_plan_money  t where project_info_no = '"+projectInfoNo+"' and t.node_code ='S01001006001001'");
		sb4.append(" union all");
		sb4.append(" select '�Ŵ�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205%'and d.project_info_no='"+projectInfoNo+"'");
		List list4 = jdbcDAO.queryRecords(sb4.toString());
		
		StringBuffer sb5 = new StringBuffer("");
		sb5.append("select '������' label,nvl(sum(t.cost_detail_money),0) value  from view_op_target_plan_money  t where project_info_no = '"+projectInfoNo+"' and t.node_code ='S01001006001003'");
		sb5.append(" union all");
		sb5.append(" select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904%'and d.project_info_no='"+projectInfoNo+"'");
		List list5 = jdbcDAO.queryRecords(sb5.toString());
		
		StringBuffer sb6 = new StringBuffer("");
		sb6.append("select '���' label,nvl(sum(t.cost_detail_money),0) value  from view_op_target_plan_money  t where project_info_no = '"+projectInfoNo+"' and (t.node_code ='S01001004001002' or t.node_code ='S01001004001003')");
		sb6.append(" union all");
		sb6.append(" select '���' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like '37%' or i.coding_code_id like '47%'or i.coding_code_id like '48%'or i.coding_code_id like '02%'or i.coding_code_id like '51%'or i.coding_code_id like '28%'or i.coding_code_id like '55%'or i.coding_code_id like '56%'or i.coding_code_id like '57%'or i.coding_code_id like '58%')and d.project_info_no='"+projectInfoNo+"'");
		List list6 = jdbcDAO.queryRecords(sb6.toString());
		
		StringBuffer sb7 = new StringBuffer("");
		sb7.append(" select '����' lable,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%')and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") )value from dual");
		sb7.append(" union all");
		sb7.append(" select '����' lable,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%')and d.project_info_no='"+projectInfoNo+"'");
		sb7.append(") )value from dual");
		List list7 = jdbcDAO.queryRecords(sb7.toString());
		
		StringBuffer sbc = new StringBuffer();
		sbc.append(" <chart numberPrefix='��' showBorder='1' formatNumberScale='0'rotateYAxisName='0' yAxisNameWidth='16' yAxisName='��Ԫ'>")
		.append(" <categories><category label='ըҩ' /><category label='�׹�' /><category label='����' /><category label='�Ŵ�' /><category label='������' /><category label='���' /><category label='����' /></categories>")
		.append(" <dataset seriesName='�ƻ�' color='F6BD0F' showValues='0'><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list3.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list4.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list5.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list6.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list7.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset>")
		.append(" <dataset seriesName='ʵ��' color='AFD8F8' showValues='0'><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list3.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list4.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list5.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list6.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list7.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset></chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
	public ISrvMsg queryViewChart8(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append("select a.project_name,(case when a.w_price=0 then 0 else b.total_money/(a.w_price*10000) end)value from")
		.append("(select to_char(nvl(sum(decode(gp.EXPLORATION_METHOD,")
		.append(" '0300100012000000003',gd.finish_3d_workload,'0300100012000000002',")
		.append(" gd.finish_2d_workload)) * nvl(max(pi.price_unit),0)/10000,")
		.append(" 0),'99999999.00') w_price,gd.project_info_no,gp.project_name")
		.append(" from rpt_gp_daily gd left outer join gp_task_project gp")
		.append(" on gd.project_info_no = gp.project_info_no")
		.append(" left outer join bgp_op_price_project_info pi ")
		.append(" on gd.project_info_no = pi.project_info_no and pi.bsflag='0' and pi.node_code='S01021'")
		.append(" where gd.bsflag = '0' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')")
		.append(" and gd.org_subjection_id like '"+orgSubjectionId+"%'")
		.append(" group by gd.project_info_no,gp.project_name)a inner join ( select d.project_info_no,gp.project_name,sum(d.total_money)total_money from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gp_task_project gp on d.project_info_no=gp.project_info_no where d.org_subjection_id like '"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy') group by d.project_info_no,gp.project_name) b on a.project_info_no=b.project_info_no");
		
		List list = jdbcDAO.queryRecords(sb.toString());
		
		StringBuffer sbc = new StringBuffer();
		sbc.append("<chart palette='2'  showValues='0' decimals='3' formatNumberScale='0'>");
		for(int i=0;i<list.size();i++){
			Map map = (Map) list.get(i);
			sbc.append("<set label='"+map.get("project_name").toString()+"' value='"+map.get("value").toString()+"' />");
		}
		sbc.append("</chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
	public ISrvMsg queryViewChart9(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String year = reqDTO.getValue("year");
		if(year==null||year.equals("")){
			Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			year = sdf.format(d).toString().substring(0, 4);
		}
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append(" select d.project_info_no,gp.project_name,sum(d.total_money)total_money from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gp_task_project gp on d.project_info_no=gp.project_info_no and gp.bsflag='0'  where d.bsflag='0' and d.org_subjection_id like '"+orgSubjectionId+"%'   and (gp.project_year='"+year+"' or to_char(gp.acquire_start_time,'yyyy')='"+year+"' or to_char(gp.acquire_end_time,'yyyy')='"+year+"') group by d.project_info_no,gp.project_name");
		List list = jdbcDAO.queryRecords(sb.toString());
		StringBuffer sbc = new StringBuffer();
		sbc.append("<chart numberPrefix='��' showBorder='1' formatNumberScale='0'rotateYAxisName='0' yAxisNameWidth='16' yAxisName='��Ԫ'>");
		for(int i=0;i<list.size();i++){
			Map map = (Map) list.get(i);
			sbc.append("<set label='"+map.get("project_name").toString()+"' value='"+((double)((int)((Double.valueOf(map.get("total_money").toString())/10000)*100)))/100+"' />");
		}
		sbc.append("</chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
	public ISrvMsg queryViewChart10(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		String startDate = new java.text.SimpleDateFormat("yyyy-MM").format(new Date()); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb1 = new StringBuffer("");
		sb1.append("select 'ըҩ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%')and d.project_info_no ='"+projectInfoNo+"' ");
		sb1.append(" union all");
		sb1.append(" select 'ըҩ' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%')and d.project_info_no ='"+projectInfoNo+"' ");
		List list1 = jdbcDAO.queryRecords(sb1.toString());
		
		StringBuffer sb2 = new StringBuffer("");
		sb2.append("select '�׹�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%'and d.project_info_no ='"+projectInfoNo+"' ");
		sb2.append(" union all");
		sb2.append(" select '�׹�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%'and d.project_info_no ='"+projectInfoNo+"' ");
		List list2 = jdbcDAO.queryRecords(sb2.toString());
		
		StringBuffer sb3 = new StringBuffer("");
		sb3.append("select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'0703%'and d.project_info_no ='"+projectInfoNo+"' ");
		sb3.append(" union all");
		sb3.append(" select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'0703%'and d.project_info_no ='"+projectInfoNo+"' ");
		List list3 = jdbcDAO.queryRecords(sb3.toString());
		
		StringBuffer sb4 = new StringBuffer("");
		sb4.append("select '�Ŵ�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205'and d.project_info_no ='"+projectInfoNo+"' ");
		sb4.append(" union all");
		sb4.append(" select '�Ŵ�' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205'and d.project_info_no ='"+projectInfoNo+"' ");
		List list4 = jdbcDAO.queryRecords(sb4.toString());
		
		StringBuffer sb5 = new StringBuffer("");
		sb5.append("select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904'and d.project_info_no ='"+projectInfoNo+"' ");
		sb5.append(" union all");
		sb5.append(" select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904'and d.project_info_no ='"+projectInfoNo+"' ");
		List list5 = jdbcDAO.queryRecords(sb5.toString());
		
		StringBuffer sb6 = new StringBuffer("");
		sb6.append("select '���' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like '37%' or i.coding_code_id like '47%'or i.coding_code_id like '48%'or i.coding_code_id like '02%'or i.coding_code_id like '51%'or i.coding_code_id like '28%'or i.coding_code_id like '55%'or i.coding_code_id like '56%'or i.coding_code_id like '57%'or i.coding_code_id like '58%')and d.project_info_no ='"+projectInfoNo+"' ");
		sb6.append(" union all");
		sb6.append(" select '���' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like '37%' or i.coding_code_id like '47%'or i.coding_code_id like '48%'or i.coding_code_id like '02%'or i.coding_code_id like '51%'or i.coding_code_id like '28%'or i.coding_code_id like '55%'or i.coding_code_id like '56%'or i.coding_code_id like '57%'or i.coding_code_id like '58%')and d.project_info_no ='"+projectInfoNo+"' ");
		List list6 = jdbcDAO.queryRecords(sb6.toString());
		
		StringBuffer sb7 = new StringBuffer("");
		sb7.append(" select '����' lable,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and d.project_info_no ='"+projectInfoNo+"' ");
		sb7.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%')and d.project_info_no ='"+projectInfoNo+"' ");
		sb7.append(") )value,((select case when sum(d.mat_num) is null then 0 else sum(d.mat_num) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and d.project_info_no ='8ad878dd3a62928f013a63137ca50002' ) - (select case when sum(d.mat_num) is null then 0 else sum(d.mat_num) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%')and d.project_info_no ='8ad878dd3a62928f013a63137ca50002' ) )mat_num from dual");
		sb7.append(" union all");
		sb7.append(" select '����' lable,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and d.project_info_no ='"+projectInfoNo+"' ");
		sb7.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%')and d.project_info_no ='"+projectInfoNo+"' ");
		sb7.append(") )value,((select case when sum(d.mat_num) is null then 0 else sum(d.mat_num) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and d.project_info_no ='8ad878dd3a62928f013a63137ca50002' ) - (select case when sum(d.mat_num) is null then 0 else sum(d.mat_num) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and  (i.coding_code_id like '1901%'or i.coding_code_id like '1903%'or i.coding_code_id like '1905%'or i.coding_code_id like '0703%'or i.coding_code_id like '36070205%'or i.coding_code_id like '200103%'or i.coding_code_id like '32019904%')and d.project_info_no ='8ad878dd3a62928f013a63137ca50002' ) )mat_num from dual");
		List list7 = jdbcDAO.queryRecords(sb7.toString());
		
		StringBuffer sbc = new StringBuffer();
		sbc.append(" <chart numberPrefix='��' showBorder='1' formatNumberScale='0'rotateYAxisName='0' yAxisNameWidth='16' yAxisName='��Ԫ'>")
		.append(" <categories><category label='ըҩ' /><category label='�׹�' /><category label='����' /><category label='�Ŵ�' /><category label='������' /><category label='���' /><category label='����' /></categories>")
		.append(" <dataset seriesName='�ƻ�' showValues= '0' color='AFD8F8' ><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(0)).get("value"))/10000)*100)))/100+"' tooltext='�ƻ�,ըҩ,������"+(String)((Map)list1.get(0)).get("mat_num")+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list1.get(0)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(0)).get("value"))/10000)*100)))/100+"' tooltext='�ƻ�,�׹�,������"+(String)((Map)list2.get(0)).get("mat_num")+"��,{br}��"+((double)((int)((Double.valueOf((String)((Map)list2.get(0)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list3.get(0)).get("value"))/10000)*100)))/100+"' tooltext='�ƻ�,����,������"+((double)(int)(Double.valueOf((String)((Map)list3.get(0)).get("mat_num"))*100))/100+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list3.get(0)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list4.get(0)).get("value"))/10000)*100)))/100+"' tooltext='�ƻ�,�Ŵ�,������"+(String)((Map)list4.get(0)).get("mat_num")+"��,{br}��"+((double)((int)((Double.valueOf((String)((Map)list4.get(0)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list5.get(0)).get("value"))/10000)*100)))/100+"' tooltext='�ƻ�,������,������"+(String)((Map)list5.get(0)).get("mat_num")+"��,{br}��"+((double)((int)((Double.valueOf((String)((Map)list5.get(0)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list6.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list7.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset>")
		.append(" <dataset seriesName='ʵ��' color='F6BD0F' showValues='0'><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(1)).get("value"))/10000)*100)))/100+"' tooltext='ʵ��,ըҩ,������"+(String)((Map)list1.get(1)).get("mat_num")+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list1.get(1)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(1)).get("value"))/10000)*100)))/100+"' tooltext='ʵ��,�׹�,������"+(String)((Map)list2.get(1)).get("mat_num")+"��,{br}��"+((double)((int)((Double.valueOf((String)((Map)list2.get(1)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list3.get(1)).get("value"))/10000)*100)))/100+"' tooltext='ʵ��,����,������"+((double)(int)(Double.valueOf((String)((Map)list3.get(1)).get("mat_num"))*100))/100+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list3.get(1)).get("value"))/10000)*100)))/100+"' link='j-drillOiljhdbxh'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list4.get(1)).get("value"))/10000)*100)))/100+"' tooltext='ʵ��,�Ŵ�,������"+(String)((Map)list4.get(1)).get("mat_num")+"��,{br}��"+((double)((int)((Double.valueOf((String)((Map)list4.get(1)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list5.get(1)).get("value"))/10000)*100)))/100+"' tooltext='ʵ��,������,������"+(String)((Map)list5.get(1)).get("mat_num")+"��,{br}��"+((double)((int)((Double.valueOf((String)((Map)list5.get(1)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list6.get(1)).get("value"))/10000)*100)))/100+"'  link='j-drillMacjhdbxh'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list7.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset></chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
	public ISrvMsg queryViewChart11(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append("select 'ըҩ' label,'1091-1905' mat_id ,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%')and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�׹�' label,'1903' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '����' label,'0703' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'0703%'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�Ŵ�' label,'36070205' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '��¼ֽ' label,'200103' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'200103%'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '������' label,'32019904' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�������' label,'37' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'37%'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '������' label,'02-47-48' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'02%'or i.coding_code_id like'47%'or i.coding_code_id like'48%')and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�������' label,'51' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'51%'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�������' label,'57' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'57%'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '�ͱ�' label,'21' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'21%'and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		sb.append("union all");
		sb.append(" select '���' label,'02-47' mat_id, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'02%'or i.coding_code_id like'47%')and d.org_subjection_id like'"+orgSubjectionId+"%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("showPercentInToolTip", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showPercentValues", "1");
		root.addAttribute("legendPosition", "RIGHT");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("numberSuffix", "��Ԫ");
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			if(Double.valueOf((String)data.get("value"))>0){
			set.addAttribute("label", (String)data.get("label"));
			set.addAttribute("value", ""+Double.valueOf((String)data.get("value"))/10000+"");
			set.addAttribute("link", "j-drillwzzbxh-"+(String)data.get("mat_id")+"");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart12(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String matId = reqDTO.getValue("matId");
		String[] ids = matId.split("-");
		String codingCodeId ="";
			for(int i=0;i<ids.length;i++){
				if(i==ids.length-1){
					codingCodeId+="i.coding_code_id like'"+ids[i]+"%'";
				}
				else{
					codingCodeId+="i.coding_code_id like'"+ids[i]+"%'or ";
				}
			}
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sb = new StringBuffer("");
		if(ids.length>11){
			sb.append(" select '����ľ' lable,'C105001005' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105001005%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and("+codingCodeId+")and d.org_subjection_id like 'C105001005%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '�½�' lable,'C105001002' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105001002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and("+codingCodeId+")and d.org_subjection_id like 'C105001002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '�¹�' lable,'C105001003' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105001003%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and("+codingCodeId+")and d.org_subjection_id like 'C105001003%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '�ຣ' lable,'C105001004' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105001004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and("+codingCodeId+")and d.org_subjection_id like 'C105001004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '����' lable,'C105005004' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105005004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and("+codingCodeId+")and d.org_subjection_id like 'C105005004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '����' lable,'C105005000' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105005000%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and("+codingCodeId+")and d.org_subjection_id like 'C105005000%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '����' lable,'C105005001' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105005001%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and ("+codingCodeId+")and d.org_subjection_id like 'C105005001%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '���' lable,'C105007' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105007%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and ("+codingCodeId+")and d.org_subjection_id like 'C105007%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '�ɺ�' lable,'C1050635' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C1050635%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and ("+codingCodeId+")and d.org_subjection_id like 'C1050635%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
			sb.append(" union all");
			sb.append(" select '���ʲ�' lable,'C105002' org_subjection_id,((select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0' and d.org_subjection_id like 'C105002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") - (select case when sum(d.total_money) is null then 0 else sum(d.total_money) end value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and ("+codingCodeId+")and d.org_subjection_id like 'C105002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append(") )value from dual");
		}
		else
		{
			sb.append("select '����ľ' lable,'C105001005' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105001005%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '�½�' lable,'C105001002' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105001002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '�¹�' lable,'C105001003' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105001003%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '�ຣ' lable,'C105001004' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105001004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '����' lable,'C105005004' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105005004%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '����' lable,'C105005000' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105005000%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '����' lable,'C105005001' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105005001%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '���' lable,'C105007' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105007%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '�ɺ�' lable,'C1050635' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C1050635%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
			sb.append("union all");
			sb.append(" select '���ʲ�' lable,'C105002' org_subjection_id,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") where d.bsflag='0' and d.org_subjection_id like 'C105002%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy')");
		}
		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("showPercentInToolTip", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showPercentValues", "1");
		root.addAttribute("legendPosition", "RIGHT");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("numberSuffix", "��Ԫ");
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			if(Double.valueOf((String)data.get("value"))>0){
			set.addAttribute("label", (String)data.get("lable"));
			set.addAttribute("value", ""+Double.valueOf((String)data.get("value"))/10000+"");
			set.addAttribute("link", "j-drillwzzbxh-"+matId+":"+(String)data.get("org_subjection_id")+"");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart13(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String matId = reqDTO.getValue("matId");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String[] ids = matId.split("-");
		String codingCodeId ="";
			for(int i=0;i<ids.length;i++){
				if(i==ids.length-1){
					codingCodeId+="i.coding_code_id like'"+ids[i]+"%'";
				}
				else{
					codingCodeId+="i.coding_code_id like'"+ids[i]+"%'or ";
				}
			}
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sb = new StringBuffer("");
		sb.append("select p.project_name lable,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") inner join gp_task_project p on d.project_info_no=p.project_info_no and p.bsflag='0'and d.org_subjection_id like '"+orgSubjectionId+"%' where d.bsflag='0' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy') group by p.project_name");
		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("showPercentInToolTip", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showPercentValues", "1");
		root.addAttribute("legendPosition", "RIGHT");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("numberSuffix", "��Ԫ");
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			if(Double.valueOf((String)data.get("value"))>0){
			set.addAttribute("label", (String)data.get("lable"));
			set.addAttribute("value", ""+Double.valueOf((String)data.get("value"))/10000+"");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart14(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String matId = reqDTO.getValue("matId");
		String[] ids = matId.split(":");
		String[] matIds = ids[0].split("-");
		String codingCodeId ="";
			for(int i=0;i<matIds.length;i++){
				if(i==matIds.length-1){
					codingCodeId+="i.coding_code_id like'"+matIds[i]+"%'";
				}
				else{
					codingCodeId+="i.coding_code_id like'"+matIds[i]+"%'or ";
				}
			}
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sb = new StringBuffer("");
			sb.append("select p.project_name lable,case when sum(d.total_money) is null then 0 else sum(d.total_money) end value from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and ("+codingCodeId+") inner join gp_task_project p on d.project_info_no=p.project_info_no and p.bsflag='0'and d.org_subjection_id like '"+ids[1]+"%' where d.bsflag='0' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy') group by p.project_name");
		List ulist = jdbcDAO.queryRecords(sb.toString());

		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("showPercentInToolTip", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showPercentValues", "1");
		root.addAttribute("legendPosition", "RIGHT");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("numberSuffix", "��Ԫ");
		for(int i=0;i<ulist.size();i++){
			Map data = (Map) ulist.get(i);
			Element set = root.addElement("set");
			if(Double.valueOf((String)data.get("value"))>0){
			set.addAttribute("label", (String)data.get("lable"));
			set.addAttribute("value", ""+Double.valueOf((String)data.get("value"))/10000+"");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart16(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		String startDate = new java.text.SimpleDateFormat("yyyy-MM").format(new Date()); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb1 = new StringBuffer("");
		sb1.append("select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'07030102%'and d.project_info_no ='"+projectInfoNo+"' ");
		sb1.append(" union all");
		sb1.append(" select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'07030102%'and d.project_info_no ='"+projectInfoNo+"' ");
		List list1 = jdbcDAO.queryRecords(sb1.toString());
		
		StringBuffer sb2 = new StringBuffer("");
		sb2.append("select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'07030301%'and d.project_info_no ='"+projectInfoNo+"' ");
		sb2.append(" union all");
		sb2.append(" select '����' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'07030301%'and d.project_info_no ='"+projectInfoNo+"' ");
		List list2 = jdbcDAO.queryRecords(sb2.toString());
		
		StringBuffer sbc = new StringBuffer();
		sbc.append(" <chart numberPrefix='��' showBorder='1' formatNumberScale='0'rotateYAxisName='0' yAxisNameWidth='16' yAxisName='��Ԫ'>")
		.append(" <categories><category label='����' /><category label='����' /></categories>")
		.append(" <dataset seriesName='�ƻ�' showValues= '0' color='AFD8F8' ><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(0)).get("value"))/10000)*100)))/100+"' tooltext='�ƻ�,����,������"+(String)((Map)list1.get(0)).get("mat_num")+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list1.get(0)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(0)).get("value"))/10000)*100)))/100+"' tooltext='�ƻ�,����,������"+(String)((Map)list2.get(0)).get("mat_num")+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list2.get(0)).get("value"))/10000)*100)))/100+"'/>")
		.append(" </dataset>")
		.append(" <dataset seriesName='ʵ��' color='F6BD0F' showValues='0'><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(1)).get("value"))/10000)*100)))/100+"' tooltext='ʵ��,����,������"+(String)((Map)list1.get(1)).get("mat_num")+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list1.get(1)).get("value"))/10000)*100)))/100+"'/>")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(1)).get("value"))/10000)*100)))/100+"' tooltext='ʵ��,����,������"+(String)((Map)list2.get(1)).get("mat_num")+"KG,{br}��"+((double)((int)((Double.valueOf((String)((Map)list2.get(1)).get("value"))/10000)*100)))/100+"'/>")
		.append(" </dataset></chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
	public ISrvMsg queryViewChart17(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		
		String startDate = new java.text.SimpleDateFormat("yyyy-MM").format(new Date()); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb1 = new StringBuffer("");
		sb1.append("select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'02%'or i.coding_code_id like'28%'or i.coding_code_id like'37%'or i.coding_code_id like'47%'or i.coding_code_id like'48%'or i.coding_code_id like'51%')and d.project_info_no ='"+projectInfoNo+"' ");
		sb1.append(" union all");
		sb1.append(" select '������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'02%'or i.coding_code_id like'28%'or i.coding_code_id like'37%'or i.coding_code_id like'47%'or i.coding_code_id like'48%'or i.coding_code_id like'51%')and d.project_info_no ='"+projectInfoNo+"' ");
		List list1 = jdbcDAO.queryRecords(sb1.toString());
		
		StringBuffer sb2 = new StringBuffer("");
		sb2.append("select '�������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'55%'or i.coding_code_id like'56%'or i.coding_code_id like'57%'or i.coding_code_id like'58%')and d.project_info_no ='"+projectInfoNo+"' ");
		sb2.append(" union all");
		sb2.append(" select '�������' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end value,case when sum(d.total_money) is null then 0 else sum(d.mat_num) end mat_num  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'55%'or i.coding_code_id like'56%'or i.coding_code_id like'57%'or i.coding_code_id like'58%')and d.project_info_no ='"+projectInfoNo+"' ");
		List list2 = jdbcDAO.queryRecords(sb2.toString());
		
		StringBuffer sbc = new StringBuffer();
		sbc.append(" <chart numberPrefix='��' showBorder='1' formatNumberScale='0'rotateYAxisName='0' yAxisNameWidth='16' yAxisName='��Ԫ'>")
		.append(" <categories><category label='������' /><category label='�������' /></categories>")
		.append(" <dataset seriesName='�ƻ�' showValues= '0' color='AFD8F8' ><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(0)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset>")
		.append(" <dataset seriesName='ʵ��' color='F6BD0F' showValues='0'><set value='"+((double)((int)((Double.valueOf((String)((Map)list1.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append("<set value='"+((double)((int)((Double.valueOf((String)((Map)list2.get(1)).get("value"))/10000)*100)))/100+"' />")
		.append(" </dataset></chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
	/*
	 * �Ǳ���:������ת���
	 */
	public ISrvMsg queryViewChart15(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		
		
		StringBuffer sql = new StringBuffer("select a.data_dt,a.kczzcs_zb,round(a.kczzcs_sj,2)kczzcs_sj from (select * from DM_DSS.F_DP_MATERIEL_KCZZCS@DSSDB.REGRESS.RDBMS.DEV.US.ORACLE.COM t order by t.data_dt asc)a");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("labelDisplay", "ROTATE");
		root.addAttribute("slantLabels", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("palette", "2");
		
		Element trendlines = root.addElement("trendlines");
		Element line = trendlines.addElement("line");
		line.addAttribute("color", LineCColor);
		line.addAttribute("valueOnRight", "1");
		line.addAttribute("dashed", "1");
		line.addAttribute("thickness", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "ָ��");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "ʵ��");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);

		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("data_dt"));
			String dMonth = (String) map.get("data_dt");
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", (String) map.get("kczzcs_zb"));
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", (String) map.get("kczzcs_sj"));
				set1.addAttribute("anchorBgColor", LineAColor);
				set2.addAttribute("anchorBgColor", LineBColor);
				
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChart18(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String start_date = reqDTO.getValue("start_date")==null?"":reqDTO.getValue("start_date");
		String end_date = reqDTO.getValue("end_date")==null?"":reqDTO.getValue("end_date");
		
		
		StringBuffer sql = new StringBuffer("select t.outmat_date,sum(d.total_money)sj_value from gms_mat_teammat_out t inner join gms_mat_teammat_out_detail d on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.bsflag='0'and t.project_info_no='"+projectInfoNo+"'");
		if(!start_date.equals("")){
			sql.append(" and t.outmat_date>to_date('").append(start_date).append("','yyyy-MM-dd')");
		}
		if(!end_date.equals("")){
			sql.append(" and t.outmat_date<to_date('").append(end_date).append("','yyyy-MM-dd')");
		}
		sql.append(" group by t.outmat_date order by t.outmat_date asc ");
		StringBuffer sqlsj = new StringBuffer("select sum(d.total_money)sj_value  from gms_mat_teammat_out t inner join gms_mat_teammat_out_detail d on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' where t.project_info_no='"+projectInfoNo+"'and t.bsflag='0'");
		StringBuffer sqljh = new StringBuffer("select  sum(t.cost_detail_money)jh_value from view_op_target_plan_money  t where project_info_no = '"+projectInfoNo+"' and (t.node_code like 'S01001006001%' or t.node_code like 'S01001006002%' or t.node_code like 'S01001006003%' or t.node_code like 'S01001006004001%' or t.node_code like 'S01001004001001%' or t.node_code like 'S01001004001002%' or t.node_code like 'S01001004001003%' or t.node_code like 'S01001002004007%' or t.node_code like 'S01001003004001%' or t.node_code like 'S01001002004001%' or t.node_code like 'S01001002004002%' or t.node_code like 'S01001002004003%' or t.node_code like 'S01001003002%')");
		StringBuffer sqldate = new StringBuffer("select to_char(min(p.planned_start_date),'yyyy/mm/dd')start_date,to_char(max(p.planned_finish_date),'yyyy/mm/dd')finish_date,(to_date(to_char(max(p.planned_finish_date),'yyyy/mm/dd'),'yyyy-mm-dd')-to_date(to_char(min(p.planned_start_date),'yyyy/mm/dd'),'yyyy-mm-dd'))dates from bgp_p6_project t inner join bgp_p6_activity p on t.object_id=p.project_object_id where t.project_info_no='"+projectInfoNo+"'");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());
		Map listsj = jdbcDAO.queryRecordBySQL(sqlsj.toString());
		Map listjh = jdbcDAO.queryRecordBySQL(sqljh.toString());
		Map listdate = jdbcDAO.queryRecordBySQL(sqldate.toString());
		
		int dateNum = Integer.parseInt(listdate.get("dates")==""?"0":listdate.get("dates").toString());
		String sj_value_string = listsj.get("sj_value")==""?"0":listsj.get("sj_value").toString();
		String jh_value_string = listjh.get("jh_value")==""?"0":listjh.get("jh_value").toString();
		double sj_value = ((double)(int)((Double.valueOf(sj_value_string)/dateNum)*100))/100;
		double jh_value = ((double)(int)((Double.valueOf(jh_value_string)/dateNum)*100))/100;
		
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("numberPrefix", "��");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("yAxisName", "Ԫ");
		root.addAttribute("showLegend", "1");
		root.addAttribute("labelDisplay", "ROTATE");
		root.addAttribute("slantLabels", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("palette", "3");
		
		Element trendlines = root.addElement("trendlines");
		Element line = trendlines.addElement("line");
		line.addAttribute("color", LineCColor);
		line.addAttribute("valueOnRight", "1");
		line.addAttribute("dashed", "1");
		line.addAttribute("thickness", "3");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "ʵ������");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "ʵ��ƽ��");
		Element dataset3 = root.addElement("dataset");
		dataset3.addAttribute("seriesName", "�ƻ�ƽ��");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);
		dataset3.addAttribute("color", LineCColor);

		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("outmat_date"));
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", (String) map.get("sj_value"));
				set1.addAttribute("link", "j-drillsjxhxh-"+(String)map.get("outmat_date")+"");
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", String.valueOf(sj_value));
				Element set3 = dataset3.addElement("set");
				set3.addAttribute("value", String.valueOf(jh_value));
				set1.addAttribute("anchorBgColor", LineAColor);
				set2.addAttribute("anchorBgColor", LineBColor);
				set3.addAttribute("anchorBgColor", LineCColor);
				
		}
		responseDTO.setValue("Str", document.asXML());
		
		return responseDTO;
	}
	public ISrvMsg queryViewChartBI1(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String orgId = reqDTO.getValue("orgId");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append("select * from (select * from DM_DSS.F_DP_MATERIEL_WSCG@DSSDB.REGRESS.RDBMS.DEV.US.ORACLE.COM t order by t.data_dt desc) where rownum=1");
		Map map = jdbcDAO.queryRecordBySQL(sb.toString());
		StringBuffer sbc = new StringBuffer();
		sbc.append("<chart bgAlpha='0' bgColor='FFFFFF' lowerLimit='0' upperLimit='100' numberSuffix='%25' showBorder='0'  chartTopMargin='25' chartBottomMargin='25' chartLeftMargin='25' chartRightMargin='25' toolTipBgColor='80A905' gaugeFillMix='{dark-10},FFFFFF,{dark-10}' gaugeFillRatio='3' showValue='1'>")
		.append("<colorRange><color minValue='0' maxValue='"+Double.valueOf(map.get("wscg_zb").toString())*100+"' code='FF654F'/><color minValue='"+Double.valueOf(map.get("wscg_zb").toString())*100+"' maxValue='100' code='8BBA00'/></colorRange>")
		.append("<dials><dial value='"+Double.valueOf(map.get("wscg_sj").toString())*100+"' rearExtension='10'/></dials>")
		.append("<styles> <definition><style name='DialStyle' type='font' font='Verdana' size='42' color='CCCCCC' bold='1' /></definition><application> <apply toObject='Value' styles=' DialStyle ' /></application></styles>")
		.append("</chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
	public ISrvMsg queryViewChartBI2(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String orgId = reqDTO.getValue("orgId");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("");
		sb.append("select * from (SELECT * FROM DM_DSS.F_DP_MATERIEL_JZCGD@DSSDB.REGRESS.RDBMS.DEV.US.ORACLE.COM t order by t.data_dt desc) where rownum=1");
		Map map = jdbcDAO.queryRecordBySQL(sb.toString());
		StringBuffer sbc = new StringBuffer();
		sbc.append("<chart bgAlpha='0' bgColor='FFFFFF' lowerLimit='0' upperLimit='100' numberSuffix='%25' showBorder='0'  chartTopMargin='25' chartBottomMargin='25' chartLeftMargin='25' chartRightMargin='25' toolTipBgColor='80A905' gaugeFillMix='{dark-10},FFFFFF,{dark-10}' gaugeFillRatio='3' showValue='1'>")
		.append("<colorRange><color minValue='0' maxValue='"+Double.valueOf(map.get("jzcgd_zb").toString())*100+"' code='FF654F'/><color minValue='"+Double.valueOf(map.get("jzcgd_zb").toString())*100+"' maxValue='100' code='8BBA00'/></colorRange>")
		.append("<dials><dial value='"+Double.valueOf(map.get("jzcgd_sj").toString())*100+"' rearExtension='10'/></dials>")
		.append("<styles> <definition><style name='DialStyle' type='font' font='Verdana' size='42' color='CCCCCC' bold='1' /></definition><application> <apply toObject='Value' styles=' DialStyle ' /></application></styles>")
		.append("</chart>");
		responseDTO.setValue("Str", sbc.toString());
		return responseDTO;
	}
}

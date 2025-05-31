<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String project_status = request.getParameter("project_status");
	
	String endDate = request.getParameter("endDate");
	String affordOrgId = request.getParameter("affordOrgId");
	if(affordOrgId==null || affordOrgId.trim().equals("")){
		affordOrgId = "C105";
	}
	
	if(endDate == null || endDate.equals("")) {
		Date date = new Date();
		String temp = String.valueOf(date.getYear() + 1900);
		endDate = temp;
		temp = String.valueOf(date.getMonth() + 1);
		if(date.getMonth() + 1 <= 9) {
			temp = "0" + String.valueOf(date.getMonth() + 1);
		}
		endDate = endDate + temp;
		temp = String.valueOf(date.getDate() );
		if(date.getDate() <= 9) {
			temp = "0" + String.valueOf(date.getDate());
		}
		endDate = endDate + temp;
	}
	StringBuffer sb = new StringBuffer();
	StringBuffer sb2 = new StringBuffer();
	
	  sb.append("select team.team_id,team.present_unit_id ,p3.org_name present_unit_name ,")
		.append(" e.employee_name header_name, t.work_status,t.org_subjection_id org_sub_id ")
		.append("   from comm_org_team team left join (select gp.work_status, ")
		.append(" row_number() over(partition by gp.org_id order by gp.send_date desc) row_1, ")
		.append(" gp.org_id, gp.org_subjection_id  from rpt_gp_daily gp")
		.append("  where gp.org_subjection_id like '").append(affordOrgId).append("%' || '%'")
		.append(" and gp.send_date >= to_date(substr('" )
		.append(endDate).append("', 1, 4) || '-01-01', 'yyyy-MM-dd')")
		.append("  and gp.send_date <= to_date('")
		.append(endDate).append("', 'yyyy-MM-dd') and gp.bsflag = '0') t")
		.append("  on t.org_id = team.org_id and t.row_1 = 1 ")
		.append(" left join comm_human_employee e on team.header = e.employee_id and e.bsflag='0'")
		.append(" left join comm_org_information p3 on team.present_unit_id = p3.org_id and p3.bsflag='0'")
		.append(" left join comm_org_subjection os on team.org_id = os.org_id and os.bsflag='0'")
		.append("  where team.bsflag='0' and os.org_subjection_id like'").append(affordOrgId).append("%' ");
	System.out.println("1"+sb);
	if(project_status!=null && project_status.equals("stop")){
		sb.append(" and t.work_status in ('暂停（人员设备撤离）', '暂停（人员设备撤离)', '暂停','停工','结束')");
	}
	else if(project_status!=null && project_status.equals("run")){
		sb.append("  and work_status not in ('动迁','踏勘','结束','开工准备','暂停（人员设备撤离）','暂停（人员设备撤离)','暂停','停工')");
		
	}
	else if(project_status!=null && project_status.equals("prepare")){
		sb.append(" and work_status in ('开工准备','动迁','踏勘')");
	}
	else if(project_status!=null && project_status.equals("no")){
		sb2.append("select team.team_id,team.present_unit_id ,p3.org_name present_unit_name ,")
		.append(" e.employee_name header_name, t.work_status,t.org_subjection_id org_sub_id ")
		.append(" from comm_org_team team")
		.append(" left join (select gp.work_status,")
		.append(" row_number() over(partition by gp.org_id order by gp.send_date desc) row_1,")
		.append(" gp.org_id, gp.org_subjection_id")
		.append(" from rpt_gp_daily gp")
		.append(" where gp.org_subjection_id like '").append(affordOrgId).append("%' || '%'")
		.append(" and gp.send_date >= to_date(substr('" )
		.append(endDate).append("', 1, 4) || '-01-01', 'yyyy-MM-dd')")
		.append(" and gp.send_date <= to_date('")
		.append(endDate).append("', 'yyyy-MM-dd') ")
		.append(" and gp.bsflag = '0') t on team.org_id = t.org_id and t.row_1=1")
		.append(" left join comm_human_employee e on team.header = e.employee_id and e.bsflag='0'")
		.append(" left join comm_org_information p3 on team.present_unit_id = p3.org_id and p3.bsflag='0'")
		.append(" left join comm_org_subjection os on team.org_id = os.org_id and os.bsflag='0'")
		.append(" where team.bsflag='0' and team.org_id not in")
		.append(" (select team.org_id ")
        .append(" from (select gp.work_status, ")
	    .append(" row_number() over(partition by gp.org_id order by gp.send_date desc) row_1,")
	    .append(" gp.org_id,gp.org_subjection_id")
        .append(" from rpt_gp_daily gp")
        .append(" where gp.org_subjection_id like '").append(affordOrgId).append("%' || '%'")
		.append(" and gp.send_date >= to_date(substr('" ).append(endDate).append("', 1, 4) || '-01-01', 'yyyy-MM-dd')")
		.append(" and gp.send_date <= to_date('").append(endDate).append("', 'yyyy-MM-dd') ")
        .append(" and gp.bsflag = '0') t")
        .append(" left join comm_org_team team on t.org_id = team.org_id and team.bsflag='0'")
        .append(" left join comm_human_employee e on team.header = e.employee_id and e.bsflag='0'")
        .append(" left join comm_org_information p3 on team.present_unit_id = p3.org_id and p3.bsflag='0'")
        .append(" where row_1 = 1 ")
        .append(" and work_status in")
        .append(" ('采集', '踏勘', '暂停（人员设备撤离）','暂停（人员设备撤离)', '动迁', '开工准备', '钻井', '试验', '暂停', '停工', '测量', '正常'))")
	    .append(" and team.bsflag = '0' and os.org_subjection_id like'").append(affordOrgId).append("%' ")
	    .append(" and team.if_registered = '1'")
	    .append(" and team.team_specialty = '0100100015000000017'");
	}
	
	String sbSql = " and team.if_registered = '1' and team.team_specialty = '0100100015000000017' group by t.org_subjection_id,e.employee_name,t.work_status,team.team_id, team.present_unit_id, p3.org_name";
	String querySql = sb.toString();
	if(project_status!=null && project_status.equals("no")){
		querySql = sb2.toString();
		sbSql = "";
	}
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
<style type="text/css">
.ali_cdn_input{
	width: 180px;
	text-align: left; 
}

.ali_cdn_input input{
	width: 80%;
}

</style>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">队伍名称</td>
			    <td class="ali_cdn_input">
			    <input id="teamName" name="teamName" type="text" />
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_even" autoOrder="1" exp="<input type='hidden' name='rdo_entity_id' value='{org_sub_id}' id='rdo_entity_id_{org_sub_id}' />">序号</td> 
			      <td class="bt_info_odd" exp="{team_id}">队伍名称</td>
			      <td class="bt_info_odd" exp="{header_name}">队经理</td>
			      <td class="bt_info_odd" exp="{work_status}">状态</td>
			      <td class="bt_info_even" exp="{present_unit_name}">所在位置</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
		  </div>
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		var sqew = "<%=querySql+sbSql%>";
		debugger;
		cruConfig.queryStr = "<%=querySql+sbSql%>";
		cruConfig.currentPageUrl = "";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var teamName = document.getElementById("teamName").value;
				if(teamName!=''&&teamName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "<%=querySql%>"+" and team.team_id like '"+teamName+"%'" +"<%=sbSql%>";
					cruConfig.currentPageUrl = "";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("teamName").value = "";
	}
	
	
	function dbclickRow(shuaId){
		var retObj;
		if(shuaId!=null){
			popWindow("<%=contextPath%>/pm/projectmgr/viewTeamInfo.jsp?org_sub_id="+shuaId);
		}
	}

	
</script>

</html>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null||projectInfoNo==""){
		projectInfoNo = user.getProjectInfoNo();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<title>项目列表</title>
<script language="javaScript">
window.gudingbiaotou='true';
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	$("#table_box").css("height",$(window).height()*0.85);
	//setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})

cruConfig.contextPath =  "<%=contextPath%>";
function refreshData(){
	var sql ='';
		sql +="select t.submite_number,t.create_date,t.total_money,t.submite_id,u.user_name,o.org_abbreviation,d.coding_name from gms_mat_demand_plan_bz t inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id left join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id and d.bsflag='0'  where t.bsflag='0'and t.if_submit='1'and t.project_info_no='<%=projectInfoNo%>' order by t.create_date desc";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/panel/wtcwycz.jsp";
	queryData(1);
}
function openGis(submiteNumber){
	popWindow("<%=contextPath%>/mat/panel/teampanel/teamdlxz.jsp?submiteNumber="+submiteNumber,"800:600");
}
</script>
</head>
<body onload="refreshData()" style="background:#fff">
<div id="list_table">
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			        <td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="<a href='#'  onclick=openGis('{submite_number}')>{submite_id}</a>">计划编号</td>
					<td class="bt_info_even" exp="{coding_name}">班组</td>
					<td class="bt_info_odd" exp="{org_abbreviation}">队伍</td>
					<td class="bt_info_even" exp="{user_name}">创建人</td>
					<td class="bt_info_odd" exp="{total_money}">金额</td>
					<td class="bt_info_even" exp="{create_date}">创建时间</td>
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
			<div class="lashen" id="line"></div>
</div>
</body>
</html>
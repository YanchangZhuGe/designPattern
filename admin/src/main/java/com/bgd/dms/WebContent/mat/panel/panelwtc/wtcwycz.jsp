<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	if(orgSubjectionId==null||orgSubjectionId==""){
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
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
		sql +="select a.project_name,a.project_info_no,b.coding_name,b.total_money,round((case when a.w_price=0 then 0 else b.total_money/(a.w_price*10000) end),2)value from"
			sql+="(select to_char(nvl(sum(decode(gp.EXPLORATION_METHOD,"
				sql+=" '0300100012000000003',gd.finish_3d_workload,'0300100012000000002',"
					sql+=" gd.finish_2d_workload)) * nvl(max(pi.price_unit),0)/10000,"
					sql+=" 0),'99999999.00') w_price,gd.project_info_no,gp.project_name"
					 sql+=" from rpt_gp_daily gd left outer join gp_task_project gp"
					 sql+=" on gd.project_info_no = gp.project_info_no"
					 sql+=" left outer join bgp_op_price_project_info pi" 
					 sql+=" on gd.project_info_no = pi.project_info_no and pi.bsflag='0' and pi.node_code='S01021'"
					 sql+=" where gd.bsflag = '0' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')"
					 sql+=" and gd.org_subjection_id like '<%=orgSubjectionId%>%'"
					 sql+=" group by gd.project_info_no,gp.project_name)a inner join ( select d.project_info_no,sd.coding_show_id,gp.project_name,sd.coding_name,sum(d.total_money)total_money from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join (gp_task_project gp inner join comm_coding_sort_detail sd on gp.project_status=sd.coding_code_id) on d.project_info_no=gp.project_info_no" 
					 sql+=" where d.org_subjection_id like '<%=orgSubjectionId%>%' and d.bsflag='0' and gp.bsflag='0' "
					 sql+=" group by d.project_info_no,gp.project_name,sd.coding_name,sd.coding_show_id ) b on a.project_info_no=b.project_info_no";
		
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/panel/wtcwycz.jsp";
	queryData(1);
}
function openGis(projectInfoNo){
	popWindow("<%=contextPath%>/mat/panel/panelwtc/matChart3.jsp?projectInfoNo="+projectInfoNo,"800:600");
}
</script>
</head>
<body onload="refreshData()" style="background:#fff">
<div id="list_table">
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<a href='#'  onclick=openGis('{project_info_no}')>{project_name}</a>" >项目名称</td>
			      <td class="bt_info_even" exp="{coding_name}">项目动态</td>
			      <td class="bt_info_odd" exp="{total_money}" >物资消耗总额</td>
			      <td class="bt_info_even" exp="{value}" >万元产值消耗率</td>
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
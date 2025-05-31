<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String submiteNumber = request.getParameter("submiteNumber");
	String projectInfoNo = user.getProjectInfoNo();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
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
		sql +="select i.coding_code_id,i.wz_id,i.wz_name,i.wz_prickie,i.wz_price,t.demand_num from GMS_MAT_DEMAND_PLAN_DETAIL t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.bsflag='0'and t.project_info_no='<%=projectInfoNo%>'and t.submite_number='<%=submiteNumber%>' and (t.demand_num != t.use_num or t.use_num is null) order by i.coding_code_id asc,i.wz_id asc"
			
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/panel/teampanel/teamwzkc.jsp";
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
			      <td class="bt_info_odd" exp="{coding_code_id}" >物料组</td>
			      <td class="bt_info_even" exp="{wz_id}">物料编码</td>
			      <td class="bt_info_odd" exp="{wz_name}" >物料描述</td>
			      <td class="bt_info_even" exp="{wz_prickie}" >计量单位</td>
			       <td class="bt_info_odd" exp="{wz_price}" >单价</td>
			      <td class="bt_info_even" exp="{demand_num}" >数量</td>
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
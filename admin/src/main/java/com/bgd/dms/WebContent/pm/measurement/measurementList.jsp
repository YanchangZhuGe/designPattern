<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = request.getParameter("projectInfoNo").toString();
	String view_measurement = request.getParameter("viewmeasurement") != null ? request.getParameter("viewmeasurement"):"";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>测量测算</title>
</head>
<body style="background:#fff; overflow-y: auto;">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  
			  <tr>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd">序号</td>
			      <td class="bt_info_even">名称</td>
			      <td class="bt_info_odd">时间</td>
			    </tr>
			    <tr class = "even" ondblclick="dbclickRow($('#cs_flag').attr('value'))" id="csRow">
			      <td>1<input type="hidden" id="cs_flag" name="cs_flag" value="cs"/></td>
			      <td>测算表</td>
			      <td id="modifyDateCs"></td>
			    </tr>
			    <tr class = "odd" ondblclick="dbclickRow($('#qr_flag').attr('value'))" id="qrRow"">
			      <td>2<input type="hidden" id="qr_flag" name="qr_flag" value="qr"/></td>
			      <td>确认表</td>
			      <td id="modifyDateQr"></td>
			    </tr>
			  </table>
		  </div>
</body>
<script type="text/javascript">
function frameSize(){
	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	var project_info_no = "<%=project_info_no%>";
	
	$(document).ready(function(){
		var querySql = "select temp1.cs_modify_date,temp2.qr_modify_date from "
		               +"(select max(t.update_date) as cs_modify_date from bgp_pm_terrain_measure t where t.bsflag  = '0' and t.measure_confirm = '0' and t.project_info_no = '"+project_info_no+"') temp1,"
		               +"(select min(t.update_date) as qr_modify_date from bgp_pm_terrain_measure t where t.bsflag  = '0' and t.measure_confirm = '1' and t.project_info_no = '"+project_info_no+"') temp2 ";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas[0]){
			var cs_modify_date = queryOrgRet.datas[0].cs_modify_date != ""?queryOrgRet.datas[0].cs_modify_date:"未填写"; 
			var qr_modify_date = queryOrgRet.datas[0].qr_modify_date != ""?queryOrgRet.datas[0].qr_modify_date:"未填写";
			$("td[id=modifyDateCs]").html(cs_modify_date);
			$("td[id=modifyDateQr]").html(qr_modify_date);
		}

	})
	
	function dbclickRow(ids){
		//var project_info_no = $("#projectInfoNo").attr("value");
		//测算表
		if(ids=="cs"){
			popWindow('<%=contextPath%>/pm/project/queryMeasureListCs.srq?projectInfoNo=<%=project_info_no%>&measureType=0&viewmeasurement=<%=view_measurement %>','1300:680');
		}
		//确认表
		else if(ids=="qr"){
		  	popWindow('<%=contextPath%>/pm/project/queryMeasureListQr.srq?projectInfoNo=<%=project_info_no%>&measureType=1&viewmeasurement=<%=view_measurement %>','1300:680');
		}
	}

</script>
</html>
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getSubOrgIDofAffordOrg();
	//userId = "C105001";
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String codeId = "";
	codeId = request.getParameter("codeId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>

<body onload="refreshData();getTotalMoney()" style="background: #fff">
<div id="list_table">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td>&nbsp;</td>
				<td class="ali_cdn_name">金额:</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="total_money" name="total_money" type="text" readonly/></td>
			</tr>
		</table>
		</td>
		<td width="4"><img src="<%=contextPath%>/images/list_17.png"
			width="4" height="36" /></td>
	</tr>
</table>
</div>
<div id="table_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_info" id="queryRetTable">
	<tr>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
		<td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
		<td class="bt_info_odd" exp="{wz_name}">物资名称</td>
		<td class="bt_info_even" exp="{wz_prickie}">物资单位</td>
		<td class="bt_info_odd" exp="{wz_price}">物资单价（元）</td>
		<td class="bt_info_even" exp="{demand_num}">计划数量</td>
		<td class="bt_info_odd" exp="{demand_money}">计划金额（元）</td>
	</tr>
</table>
</div>
<table id="fenye_box_table">
</table>
</div>
</body>
<script type="text/javascript">

function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var id = getQueryString("id");
	var projectInfoNo = getQueryString("projectInfoNo");
	function refreshData(){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getRatioOtherList";
		cruConfig.submitStr ="value="+id+"&projectInfoNo="+projectInfoNo;
		queryData(1);
	}
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    } 
       function getTotalMoney(){
   		var num= 0;
   		var tab = document.getElementById("queryRetTable");
   		var rows = tab.rows;
   		for(var i=1;i<rows.length;i++){
   			cells = rows[i].cells;
   			var planMoney = 0;
   			if(cells[7].innerHTML !='&nbsp;'){
   				planMoney = cells[7].innerHTML;
   			}
   			num -=(-planMoney);
   		}
   		document.getElementById("total_money").value=Math.round((num)*1000)/1000;
   		} 
</script>

</html>


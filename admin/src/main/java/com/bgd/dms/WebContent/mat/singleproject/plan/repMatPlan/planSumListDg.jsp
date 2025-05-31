<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectName = user.getProjectName();
	
	String projectType = user.getProjectType();  //拓展   项目类型
	
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<title>可重复计划</title>
</head>

<body style="background: #fff" onload="refreshData()">
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
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td></td>
				<%if(projectType!=null&&projectType.equals("5000100004000000009")){ %>
	<!-- 			<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton> -->
				<%} %>
				<td></td>
				<td></td>
				<td></td>
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
		<td class="bt_info_odd"
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{planversions_id}' onclick='loadDataDetail();'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{wz_name}">物资名称</td>
		<td class="bt_info_even" exp="{demand_num}">需求总量</td>
		<td class="bt_info_odd" exp="{wz_price}">参考单价</td>
	</tr>
</table>
</div>
<div id="fenye_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	id="fenye_box_table">
	<tr>
		<td align="right">第1/1页，共0条记录</td>
		<td width="10">&nbsp;</td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
			width="20" height="20" /></td>
		<td width="50">到 <label> <input type="text"
			name="textfield" id="textfield" style="width: 20px;" /> </label></td>
		<td align="left"><img src="<%=contextPath%>/images/fenye_go.png"
			width="22" height="22" /></td>
	</tr>
</table>
</div>
<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
      </ul>
    </div>
   <div id="tab_box" class="tab_box">
<div id="tab_box_content0" class="tab_box_content">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="inquire_item6">项目业名称：</td>
		<td class="inquire_form6"><input id="projectName"
			class="input_width_no_color" type="text" value="<%=projectName %>" readonly /> &nbsp;</td>
		<td class="inquire_item6">&nbsp;计划开始时间：</td>
		<td class="inquire_form6"><input id="wz_prickie"
			class="input_width_no_color" type="text" value="" readonly /> &nbsp;</td>
		<td class="inquire_item6">&nbsp;物资名称：</td>
		<td class="inquire_form6"><input id="wz_name"
			class="input_width_no_color" type="text" value="" readonly /> &nbsp;</td>

	</tr>
	<tr>
		<td class="inquire_item6">原定工期：</td>
		<td class="inquire_form6"><input id="coding_code_id"
			class="input_width_no_color" type="text" value="" readonly /> &nbsp;</td>
		<td class="inquire_item6">&nbsp;计划结束时间：</td>
		<td class="inquire_form6"><input id="wz_price"
			class="input_width_no_color" type="text" value="" readonly /> &nbsp;</td>
		<td class="inquire_item6">&nbsp;需求数量：</td>
		<td class="inquire_form6"><input id="wz_prickie"
			class="input_width_no_color" type="text" value="" readonly /> &nbsp;</td>
	</tr>
</table>
</div>
</div>
</div>
</body>
<script type="text/javascript">
var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }
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
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var projectInfoNo = getQueryString("projectInfoNo");
	var taskObjectId = getQueryString("taskObjectId");
	function refreshData(){
		var sql ='';
		sql +="select b.wz_name,b.wz_id,sum(b.demand_num) demand_num,b.wz_prickie,b.wz_price from (select t.*,m.wz_name,m.wz_prickie,m.wz_price,m.note,c.code_name from gms_mat_demand_plan_detail t inner join gms_mat_demand_plan_bz bz on t.submite_number = bz.submite_number and bz.bsflag='0' and bz.if_purchase='2' inner join (gms_mat_infomation m inner join (gms_mat_coding_code c) on m.coding_code_id= c.coding_code_id  ) on t.wz_id = m.wz_id and m.bsflag='0'  and t.bsflag='0'  and t.project_info_no='"+projectInfoNo+"') b group by b.wz_name,b.wz_prickie,b.wz_price,b.wz_id";
			
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/plan/planMatList.jsp";
		queryData(1);
	}
	
	function toAdd(){ 
		  popWindow("<%=contextPath%>/mat/singleproject/plan/planItemListTo.jsp?taskObjectId="+taskObjectId+"&projectInfoNo="+projectInfoNo,'1024:800');
    }  
	
</script>

</html>


<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project = user.getProjectName();
	if(project == null ){
		project = "";
	}
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
<title>列表页面</title>
</head>
<body style="background:#fff" >
	<div id=tag-container_3>
      <ul id=tags class=tags>
        <li class="selectTag"><a href="#" onclick="getTab(this,0)">基准分值</a></li>
        <li><a href="#" onclick="getTab(this,1)" >文档</a></li>
        <li><a href="#" onclick="getTab(this,2)" >分类码</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">
			<div id="table_box" >
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
					<tr>
					  	<td class="bt_info_odd" autoOrder="1">序号</td> 
					  	<td class="bt_info_even" exp="{base_value}">基准分值</td>
					  	<td class="bt_info_odd" exp="{coding_name}">施工地形</td>
					  	<td class="bt_info_even" exp="{coding_sort_name}">施工类型</td>
					</tr>
				</table>
			</div>
			<div id="fenye_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				</table>
			</div>
		</div>
		<div id="tab_box_content1" class="tab_box_content" style="display: none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right">
			    <td>&nbsp;</td>
			    <%-- <auth:ListButton functionId="" css="tj" event="onclick='savePlan()'" title="JCDP_btn_submit"></auth:ListButton> --%>
			  </tr>
			</table> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				 
			</table>
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display: none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right">
			    <td>&nbsp;</td>
			    <%-- <auth:ListButton functionId="" css="tj" event="onclick='savePlan()'" title="JCDP_btn_submit"></auth:ListButton> --%>
			  </tr>
			</table> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				 
			</table>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	function refreshData(evaluate_template_id){
		cruConfig.queryStr = "select t.base_value ,d.coding_name ,s.coding_sort_name from bgp_op_evaluate_template_val t "+
		" left join comm_coding_sort_detail d on t.coding_code_id = d.coding_code_id and d.bsflag ='0'"+
		" left join comm_coding_sort s on d.coding_sort_id = s.coding_sort_id and s.bsflag ='0'"+
		" where t.evaluate_template_id ='"+evaluate_template_id+"' order by t.coding_code_id";
		cruConfig.pageSize = cruConfig.pageSizeMax;
		queryData(1);
	}
	
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
	
		for(i=0; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function frameSize(){
		setTabBoxHeight();
	}
	//frameSize(); 
</script>

</body>
</html>

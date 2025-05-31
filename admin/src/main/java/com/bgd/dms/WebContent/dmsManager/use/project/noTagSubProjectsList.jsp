<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = request.getParameter("projectInfoNo") != null ? request.getParameter("projectInfoNo") : "";
	String project_name = request.getParameter("projectName") != null ? java.net.URLDecoder.decode(request.getParameter("projectName"),"utf-8"): "";

	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}else{
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
	}
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	
	String action = request.getParameter("action");
	if("".equals(action) || action == null){
		action = "edit";
	}
	
	String projectType = request.getParameter("projectType");
	
	String projectFatherNo = request.getParameter("projectFatherNo");
	
	String projectYear = request.getParameter("projectYear");

%>
<html>
<head>
<script type="text/javascript">
var projectStatus1 = new Array(
		['5000100001000000001','项目启动'],
		['5000100001000000002','正在运行'],
		['5000100001000000003','项目结束'],
		['5000100001000000004','项目暂停'],
		['5000100001000000005','施工结束']
		);
var projectType1 = new Array(
		 ['5000100004000000001','陆地项目'],
		 ['5000100004000000008','井中项目'],
		 ['5000100004000000002','浅海项目'],
		 ['5000100004000000003','非地震项目'],
		 ['5000100004000000005','地震项目'],
		 ['5000100004000000006','深海项目'],
		 ['5000100004000000009','综合物化探'],
		 ['5000100004000000007','陆地和浅海项目'],
		 ['5000100004000000010','滩浅海过渡带']);
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

<title>无标题文档</title>
</head>

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name"><b>父项目名称:</b></td>
			    <td class="ali_cdn_input" colspan="4">
				    <span id="fatherProjectName" id="fatherProjectName"></span>
			    </td>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回项目列表"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <input type="hidden" id="orgSubjectionId" name="orgSubjectionId"  value="<%=orgSubjectionId %>" class="input_width" />
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}' id='rdo_entity_id_{project_info_no}' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
			      <td class="bt_info_odd" exp="{project_status}"  func="getOpValue,projectStatus1">项目状态</td>
			      <td class="bt_info_even" exp="{project_type}"  func="getOpValue,projectType1">项目类型</td>
			      <td class="bt_info_odd" exp="{manage_org_name}">甲方单位</td>
			      <td class="bt_info_even" exp="{start_date}">采集开始时间</td>
			      <td class="bt_info_odd" exp="{end_date}">采集结束时间</td>
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
<script type="text/javascript">
function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
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
	//debugger;
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "WsProjectSrv";
	cruConfig.queryOp = "querySubProjects";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var project_info_no = "<%=project_info_no%>";
	var project_name = "<%=project_name%>";
	var projectType = "<%=projectType%>";
	var projectFatherNo = "<%=projectFatherNo%>";
	var projectYear = "<%=projectYear%>";
	var orgId = "<%=orgId%>";

	$("#fatherProjectName").html(project_name);

	// 复杂查询
	function refreshData(){
		cruConfig.submitStr = "projectFatherNo="+projectFatherNo+"&projectType="+projectType+"&orgSubjectionId="+orgSubjectionId+"&projectYear="+projectYear+"&orgId="+orgId;
		queryData(1);
	}

	refreshData();
		
	function toBack(){
	    window.history.go(-1);		
	}
	
	function dbclickRow(ids){
		<%if(action.equals("view")){ %>
		location.href="<%=contextPath %>/pm/project/selectProject.srq?projectInfoNo="+ids;
		var name = document.getElementById("projectName"+ids).value;
		var longName = name;
		//alert(name.length);
		if (name.length > 6){
			name = name.substring(0,6)+"...";
		}
		parent.window.opener.setProject(longName, name);//.document.getElementById('projectName').innerHTML='<a href="#"  onclick="selectProject();" title="'+longName+'">'+name+'</a>';
 		//parent.window.opener.top.location.reload();
 	/* 	debugger;
 		var objs = parent.window.opener.top.frames['topFrame'].document.getElementById("tags").children;
 		for(var i =0;i<objs.length;i++){
 			var a = objs[i].children[0];
 			if(a.innerText=='经营管理'){
 				a.style.display = 'none';
 			}
 		} */
		parent.window.close();
		<%} else {%>
		popWindow('<%=contextPath%>/pm/project/multiProject/viewProject.jsp?projectInfoNo='+ids);
		<%} %>
		
	}
	
</script>

</html>

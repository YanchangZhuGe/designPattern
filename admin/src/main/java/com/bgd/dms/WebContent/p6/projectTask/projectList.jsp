<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>

<%@page import="com.cnpc.jcdp.common.UserToken"%>
 
<%
 
	String contextPath = request.getContextPath();
	String isSingle = request.getParameter("isSingle");
	String orgId = request.getParameter("orgId");
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String projectType= request.getParameter("projectType")==null?"":request.getParameter("projectType");
 
	if(projectType.equals("5000100004000000008")){
		response.sendRedirect(contextPath+"/p6/projectTask/ws/projectList.jsp?projectType="+projectType);
	}
	if(projectType.equals("5000100004000000006")){
		response.sendRedirect(contextPath+"/pm/dailyReport/multiProject/sh/projectList.jsp?projectType="+projectType);
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<title>项目列表</title>
<script language="javaScript">

function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})

var pageTitle = "项目列表";
cruConfig.contextPath =  "<%=contextPath%>";
var jcdp_codes_items = null;

function page_init(){

	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "P6ProjectSrv";
	cruConfig.queryOp = "queryjdListProject";
	cruConfig.submitStr = "isSingle=<%=isSingle %>&orgSubjectionId=<%=orgSubjectionId %>&orgId=<%=orgId %>&projectType=<%=projectType%>";
	cruConfig.currentPageUrl = "";
	queryData(1);
}
 
 
function clearQueryText(){

	document.getElementById("projectName").value = "";
	cruConfig.submitStr = "orgSubjectionId=<%=orgSubjectionId %>";
	queryData(1);
}

function simpleSearch(){
	var q_projectName = document.getElementById("projectName").value;
	cruConfig.submitStr = "projectName="+q_projectName+"&orgSubjectionId=<%=orgSubjectionId %>";
	queryData(1);
}


function JcdpButton0OnClick(){
     		
	ids = getSelIds('rdo_entity_id');
    var idss = ids.split(",");
    
    if(ids==''){
    	alert("请先选中一条记录!");
     	return;
    }
    var isSingle = "<%=isSingle %>";
	location.href = "<%=contextPath%>/p6/queryBaselineProject.srq?isSingle="+isSingle+"&projectObjectId="+idss[0]+"&wbsObjectId="+idss[1]; 
}

function dbclickRow(id){
	
	//加了目标项目的甘特图
	var idss = id.split(",");
	debugger;
	var orgSubjectionId = "<%=orgSubjectionId%>";
	var flag = "<%=isSingle %>";
	if(orgSubjectionId == "C105" && flag != "true"){
		parent.location.href="<%=contextPath%>/p6/showGantt.srq?projectObjectId="+idss[0]+"&wbsObjectId="+idss[1]+"&taskBackUrl=/p6/queryResourceAssignment.srq";
	} else {
		location.href="<%=contextPath%>/p6/showGantt.srq?projectObjectId="+idss[0]+"&wbsObjectId="+idss[1]+"&taskBackUrl=/p6/queryResourceAssignment.srq";
	}
}

var projectStatus1 = new Array(
		['5000100001000000001','项目启动'],
		['5000100001000000002','正在运行'],
		['5000100001000000003','项目结束'],
		['5000100001000000004','项目暂停'],
		['5000100001000000005','施工结束']
		);
var projectType1 = new Array(
		 ['5000100004000000001','陆地项目'],
		 ['5000100004000000002','浅海项目'],
		 ['5000100004000000003','非地震项目'],
		 ['5000100004000000004','井中地震'],
		 ['5000100004000000005','地震项目'],
		 ['5000100004000000006','深海项目'],
		 ['5000100004000000007','陆地和浅海项目']
		);

$(document).ready(lashen);

function loadDataDetail(ids){
	if(ids==''){ 
	    alert("请先选中一条记录!");
     	return;
	}
}

var type="<%=user.getProjectType()%>";

function openProjectHealth(projectInfoNo,flag){
	if(type=="5000100004000000009"){
		popWindow('<%=contextPath%>/pm/projectHealthInfo/wtDetail.jsp?healthInfoId='+projectInfoNo+'&flag='+flag,'1280:800');
	}else{
		popWindow('<%=contextPath%>/pm/projectHealthInfo/detail.jsp?healthInfoId='+projectInfoNo+'&flag='+flag,'1280:800');
	}
}
	
function openChart(projectInfo){
	var projectInfoArray = projectInfo.split(",");
	popWindow('<%=contextPath%>/pm/chart/pmChartFrame.jsp?projectInfoNo='+projectInfoArray[0]+'&projectType='+projectInfoArray[1]+'&multiProjectFlag=1','1280:800');
}

function openGis(projectInfoNo,time){
	popWindow("http://10.21.8.26/GeoCreator/Templete.html?projNo=8ad882723900a0d9013a10f3ac9e141a&time=2012-10-25&spType=cj&upstate=true&orgid=C6000000000001&orgsubid=C105&url=10.88.2.240:80","1280:800");
}
</script>
</head>
<body onload="page_init()" style="background:#cdddef">
<div id="list_table">
<div id="inq_tool_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <%if(isSingle != "true" && !"true".equals(isSingle)){ %>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
				    <input id="projectName" name="projectName" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <%} %>
			    <td>&nbsp;</td>
			    <%if(isSingle != "true" && !"true".equals(isSingle)){ %>
			    <%} %>
			    <auth:ListButton functionId="" css="jh" event="onclick='JcdpButton0OnClick()'" title="查看目标进度计划对比"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
	      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{object_id},{wbs_object_id}' id='rdo_entity_id_{project_info_no}' onclick=doCheck(this)/>" >选择</td>
	      <td class="bt_info_even" autoOrder="1">序号</td>
	      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
	      <td class="bt_info_even" exp="{project_status}"  func="getOpValue,projectStatus1">项目状态</td>
	      <%if(isSingle != "true" && !"true".equals(isSingle)){ %>
	      <td class="bt_info_odd" exp="<a href='#'  onclick=openChart('{project_info_no},{project_type}')>查看</a>" >日报数据分析</td>
	      <td class="bt_info_even" exp="<a href='#'  onclick=openGis('{project_info_no},{produce_date}')>查看</a>" >日报进度图</td>
	      <%} %>
	      <td class="bt_info_odd" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{pm_info}.jpg' alt='生产'  onclick=openProjectHealth('{project_info_no}','0') style='cursor: pointer;' width='14px' height='14px'/> " >生产</td>
	      <td class="bt_info_even" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{qm_info}.jpg' alt='质量'  onclick=openProjectHealth('{project_info_no}','1') style='cursor: pointer;'  width='14px' height='14px'/> " >质量</td>
	      <td class="bt_info_odd" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{hse_info}.jpg' alt='HSE' onclick=openProjectHealth('{project_info_no}','2') style='cursor: pointer;'  width='14px' height='14px'/> " >HSE </td>
	      <td class="bt_info_even" exp="{acquire_start_time}">采集开始时间</td>
	      <td class="bt_info_odd" exp="{acquire_end_time}">采集结束时间</td>
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
</html>
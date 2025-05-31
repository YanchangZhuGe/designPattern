<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectNo = user.getProjectInfoNo();
	String projectName = user.getProjectName(); 
	String orgName = user.getOrgName();
	String projectType = user.getProjectType();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<title>采集进度列表</title>
</head>

<body style="background:#fff" onload="initPageBody()">
		<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">  
			<tr class="even">
			    <td colspan="4" align = "left">
			        <% if("5000100004000000006".equals(projectType)){ %>
				        <span id="span_drill">&nbsp;&nbsp;</span>
						<a href="<%=contextPath%>/pm/dailyreport/queryAcquireProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>" id="a_collect"><font color="red">采集进度</font></a>
						<span id="span_collect">&nbsp;&nbsp;</span>
			        <% }else{ %>
				    	<a href="<%=contextPath%>/pm/dailyreport/querySurveyProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>" id="a_measure">测量进度</a>
			    		<span id="span_measure">&nbsp;&nbsp;</span>
						<a href="<%=contextPath%>/pm/dailyreport/querySurfaceProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>" id="a_surface">表层进度</a>						
				    	<span id="span_surface">&nbsp;&nbsp;</span>
			    		<a href="<%=contextPath%>/pm/dailyreport/queryDrillProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>" id="a_drill">钻井进度</a>
						<span id="span_drill">&nbsp;&nbsp;</span>
						<a href="<%=contextPath%>/pm/dailyreport/queryAcquireProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>" id="a_collect"><font color="red">采集进度</font></a>
						<span id="span_collect">&nbsp;&nbsp;</span>
						<a href="<%=contextPath%>/pm/dailyreport/queryTestProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>" id="a_experiment">试验进度</a>
					<%}%>
				</td>	
			</tr> 
		  	<tr class="tongyong_box_title">
			    <td class="inquire_item4">施工队伍：</td>
			    <td class="inquire_form4"><%=orgName  %></td>
		    	<td class="inquire_item4">项目信息：</td>
				<td class="inquire_form4"><%=projectName %></td>
			</tr> 
		</table>
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">施工日期:</td>
			    <td class="ali_cdn_input">
				<input id="queryDate" name="queryDate" type="text" readonly="readonly" class="input_width"/>
			    </td>
				<td class="ali_cdn_input">
			    	<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(queryDate,tributton2);"/>
				</td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{acquire_no}' id='rdo_entity_id_{acquire_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{line_group_id}">测线号</td>
			      <td class="bt_info_even" exp="{cons_date}">施工日期</td>
			      <td class="bt_info_odd" exp="<a href='<%=contextPath %>/pm/dailyreport/downloadAcquireFile.srq?fileType=sFile&acquireNo={acquire_no}&lineGroupId={line_group_id}&projectInfoNo=<%=projectNo %>'>查看</a>">S文件</td>
			      <td class="bt_info_even" exp="<a href='<%=contextPath %>/pm/dailyreport/downloadAcquireFile.srq?fileType=rFile&acquireNo={acquire_no}&lineGroupId={line_group_id}&projectInfoNo=<%=projectNo %>'>查看</a>">R文件</td>
			      <td class="bt_info_odd" exp="<a href='<%=contextPath %>/pm/dailyreport/downloadAcquireFile.srq?fileType=xFile&acquireNo={acquire_no}&lineGroupId={line_group_id}&projectInfoNo=<%=projectNo %>'>查看</a>">X文件</td>
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable" class="tab_line_height">
					  <tr>
					  	<td class="inquire_item4">施工日期：</td>
					    <td class="inquire_form4" id="item0_0"><input type="text" id="cons_date" name="cons_date" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">测线号/线束号：</td>
					    <td class="inquire_form4" id="item0_1"><input type="text" id="line_group_id" name="line_group_id" class="input_width" readonly="readonly"/></td>
					  </tr>
					</table>
				</div>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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
	cruConfig.queryService = "InputDailyProgressSrv";
	cruConfig.queryOp = "queryAcquireProgress";
	var projectNo = '<%=projectNo%>';
	
	function initPageBody(){	//根据项目类型初始化页面显示内容
		var projectType="<%=user.getProjectType()%>"; 
		if( !strIsNullOrEmpty(projectType) )
		{
			if( projectType=="5000100004000000001")	 // 陆地项目
			{
			}
			else if( projectType=="5000100004000000002" || projectType=="5000100004000000010")	// 浅海项目和滩浅海地震项目
			{ 
				/* //删除表层进度标签
				var a_surface = document.getElementById("a_surface"); 
				a_surface.parentNode.removeChild(a_surface);
				var span_surface = document.getElementById("span_surface"); 
				span_surface.parentNode.removeChild(span_surface);
				
				//删除钻井进度标签
				var a_drill = document.getElementById("a_drill");
				a_drill.parentNode.removeChild(a_drill);
				var span_drill = document.getElementById("span_drill"); 
				span_drill.parentNode.removeChild(span_drill); */
			}
			else if( projectType=="5000100004000000003")	// 非地震项目
			{ 
			}
			else if( projectType=="5000100004000000004")	// ××项目
			{ 
			}
			else if( projectType=="5000100004000000005")	// 地震项目
			{ 
			}
			else if( projectType=="5000100004000000006")	 // 深海项目
			{ 
			}
			else if( projectType=="5000100004000000007")	// 陆地和浅海项目
			{ 
			}
			else if( projectType=="5000100004000000008")	// 井中地震项目
			{ 
			}
			else if( projectType=="5000100004000000009")	// 综合物化探项目
			{
			}
		}
		refreshData();		
	}
	
	

	function refreshData(){
		cruConfig.submitStr = "projectInfoNo="+projectNo;	
		queryData(1);
	}
	
	function simpleSearch(){
		var queryDate = document.getElementById("queryDate").value;
		cruConfig.submitStr = "projectInfoNo="+projectNo+"&consDate="+queryDate;	
		queryData(1);
	}
	
	function loadDataDetail(ids){
		var retObj = jcdpCallService("InputDailyProgressSrv", "queryAcquireProgressById", "acquireNo="+ids);
		
		document.getElementById("cons_date").value= retObj.progressInfoMap.cons_date != undefined ? retObj.progressInfoMap.cons_date:"";
		document.getElementById("line_group_id").value= retObj.progressInfoMap.line_group_id != undefined ? retObj.progressInfoMap.line_group_id:"";
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath %>/pm/dailyReport/singleProject/editAcquireProgress.jsp?pageAction=Add');		
	}

	function toDelete(){
		var fileIds = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }	

	    var params = ids.split(',');    
	    for(var i=0;i<params.length;i++){
	    	fileIds = fileIds+","+params[i];
	    }
	    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("InputDailyProgressSrv", "deleteAcquireProgress", "acquireNos="+fileIds.substr(1));
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
	}
	
	
	//修改文档，文档版本
	
	function toEdit(){

	    ids = getSelIds('rdo_entity_id');

	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    if(ids.split(",").length > 1){
	    	alert("只能编辑一条记录");
	    	return;
	    }
	    
		popWindow('<%=contextPath %>/pm/dailyReport/singleProject/editAcquireProgress.jsp?pageAction=Edit&acquireNo='+ids);

	}
	
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
			}
		}

	}
</script>

</html>

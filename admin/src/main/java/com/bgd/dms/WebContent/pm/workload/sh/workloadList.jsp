<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page  import="java.net.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	String activityObjectIds = request.getParameter("taskObjectId") != null ? request.getParameter("taskObjectId"):"";
	String[] idArray = {};
	if(activityObjectIds != ""){
		idArray = activityObjectIds.split(",");
	}
	String activityNames = request.getParameter("taskName") != null ? request.getParameter("taskName"):"";
	String foward = request.getParameter("foward") != null ? request.getParameter("foward"):"";
	if("1" == foward || "1".equals(foward)){
		activityNames = request.getParameter("testTaskName") != null ? request.getParameter("testTaskName"):"";
	}
	String paramTaskNames = URLDecoder.decode(activityNames,"UTF-8");
	String[] nameArray = {};
	String newArray = "";
	if(paramTaskNames != ""){
		nameArray = paramTaskNames.split(",");
		newArray = "array";
	}
		 
	//activityNames = URLDecoder.decode(activityNames,"UTF-8");
	//activityNames = URLEncoder.encode(activityNames, "gbk");
	//activityNames = URLDecoder.decode(activityNames,"gb2312");
	//activityNames = URLDecoder.decode(activityNames,"gbk");
	//String[] activityObjectIdss = activityObjectIds.split(",");

%>
<html>
<head>
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
<script type="text/javascript">
	<%
	out.print("var activityNameArray=new Array(");
	for(int i=0;i<idArray.length;i++){
		out.print("['");
		out.print(idArray[i]);
		out.print("','");
		out.print(nameArray[i].substring(0,nameArray[i].indexOf("(")));
		out.print("'],");
	}
	out.print("[]);");
		out.print(""+foward);
	%>
</script>
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
			  	<!-- <td>当前操作的任务为<%=activityNames %></td> -->
			    <td>&nbsp;</td>
			    <!-- <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton> -->
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toUpdate()'" title="JCDP_btn_submit"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			<form action="<%=contextPath%>/pm/workload/updateWorkload.srq" method="post"  id="form1">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr><input type="hidden" value="<%=activityObjectIds %>"  id="activityObjectIds" name="activityObjectIds"/>
			    	<input type="hidden" value="<%=activityNames %>"  id="taskNames" name="taskNames"/>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{object_id}' id='rdo_entity_id_{object_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <!-- <td class="bt_info_odd" exp="{activity_name}" >任务名称</td> -->
			      <td class="bt_info_odd" exp="{activity_object_id}" func="getOpValue,activityNameArray">任务名称</td>
			      <td class="bt_info_even" exp="{resource_id}">工作量编号</td>
			      <td class="bt_info_odd" exp="{resource_name}">工作量名称</td>
			      <td class="bt_info_even" exp="<input id='planned_units_{object_id}' name='planned_units_{object_id}'  class='input_width' value='{planned_units}' />">计划工作量</td>
			    </tr>
			  </table>
			  </form>
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
<script type="text/javascript">

function frameSize(){
	//setTabBoxHeight();
	$("#table_box").css("height",$(window).height()*0.85);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

</script>

<script type="text/javascript">
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "WorkloadSrv";
	cruConfig.queryOp = "queryWorkload";
	var projectName="";
	var projectId="";
	var projectType="";
	var projectYear="";
	var isMainProject="";
	var projectStatus="";
	var orgName="";
	
	// 复杂查询
	function refreshData(){

		cruConfig.submitStr = "activity_object_id=<%=activityObjectIds %>";
		queryData(1);
	}

	refreshData();
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, "", "", "", "", "", orgSubjectionId);
	}
	
	function loadDataDetail(ids){
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	}
	
	function toUpdate(){
		var form = document.getElementById("form1");
		form.submit();
	}

	function toAdd(){
		var obj = {
				fkValue:"",
				value:""
			};
		//window.showModalDialog('<%=contextPath%>/pm/comm/selectWorkload.jsp',obj);
		window.showModalDialog('<%=contextPath%>/wt/pm/planManager/singlePlan/planning/selectWorkload.jsp?codingSortId=7200',obj);
		var retObj = jcdpCallService("WorkloadSrv", "saveWorkload", "resourceObjectIds="+obj.fkValue+"&activityObjectIds=<%=activityObjectIds %>");
		refreshData();
		
	}

	function toDelete(){
		//alert("暂时屏蔽删除功能");return;
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中至少一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WorkloadSrv", "deleteWorkload", "objectIds="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow('');
	}
	
	function dbclickRow(ids){
		
	}
	
	
</script>

</html>


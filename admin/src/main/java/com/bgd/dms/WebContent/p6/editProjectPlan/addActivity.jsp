<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.mcs.service.pm.service.project.P6ProjectPlanSrv"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.net.URLDecoder" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
    //获取当前的项目编号，作为树的最顶层
    //String root_folderId = request.getParameter("rootFolderId").toString();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo") != null ? request.getParameter("projectInfoNo").toString() : "";
	String parentWbsObjectId = request.getParameter("parentWbsObjectId") != null ? request.getParameter("parentWbsObjectId").toString() : "";
	String parentWbsName = request.getParameter("parentWbsName") != null ? request.getParameter("parentWbsName").toString() : "";
	String head = request.getParameter("head") != null ? request.getParameter("head").toString() : "";
	if(head != ""){
		head = URLDecoder.decode(head,"UTF-8");
	}
	if(parentWbsName != ""){
		parentWbsName = URLDecoder.decode(parentWbsName,"UTF-8");
	}
	P6ProjectPlanSrv planSrv =  new P6ProjectPlanSrv();

	Date createDate = planSrv.getp6Project(projectInfoNo);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	if(createDate==null){
		createDate=new Date();
	}
	String startDate = df.format(createDate);
	long temp = createDate.getTime();
	
	String endDate = df.format(temp+(3600*4*1000*24));

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>增加作业</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body>
<form name="form1" id="form1" method="post" action="<%=contextPath%>/pm/p6/addTask.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	<tr>
    	<td colspan="4" align="center">增加作业(名称和编号都不能重复)</td>
    </tr>
    <tr>
      	<td class="inquire_item4">WBS：</td>
      	<td class="inquire_form4">
      		<input type="text" name="wbs_name" id= "wbs_name" value = "<%=parentWbsName %>" class="input_width" readonly="readonly"/>
      		<input type="hidden" name="wbs_object_id" name="wbs_object_id" value="<%=parentWbsObjectId %>"/>
      		<input type="hidden" name="project_info_no" id="project_info_no" value="<%=projectInfoNo%>"/>
      	</td>
      	<td class="inquire_item4"><font color="red">*</font>作业名称：</td>
      	<td class="inquire_form4">
      	<input type="text" name="activity_name" id="activity_name" class="input_width" />
      	</td>
    </tr>
    <tr>
      	<td class="inquire_item4"><font color="red">*</font>作业编号：</td>
      	<td class="inquire_form4">
      	<input type="text" name="activity_id" id="activity_id" class="input_width" />
      	</td>
      	<td class="inquire_item4">责任人</td>
      	<td class="inquire_form4"><input type="text" name="activity_head" id="activity_head" readonly="readonly" class="input_width" value="<%=head %>" /></td>
    </tr>
    <tr>
      	<td class="inquire_item4"><font color="red">*</font>作业类型：</td>
      	<td class="inquire_form4">
					<select name='type' id="type" class='input_width'>
			      			<option value="Task Dependent">任务作业</option>
			       			<option value="Resource Dependent">独立式作业</option>
			       			<option value="Level of Effort">配合作业</option>
			       			<option value="Start Milestone">开始里程碑</option>
			       			<option value="Finish Milestone">完成里程碑</option>
			       			<option value="WBS Summary">WBS作业</option>
			       </select>      	
		</td>
      	<td class="inquire_item4">原定工期：</td>
      	<td class="inquire_form4"><input type="text" name="plannedDuration" id="plannedDuration" class="input_width" value="5"/></td>
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>计划开始日期：</td>
      	<td class="inquire_form4"><input type="text" name="plan_start_date" id="plan_start_date" class="input_width" readonly="readonly" value="<%=startDate %>"/>
      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_start_date,tributton1);" />
      	</td>
    	<td class="inquire_item4"><font color="red">*</font>计划结束日期：</td>
      	<td class="inquire_form4"><input type="text" name="plan_end_date" id="plan_end_date" class="input_width" readonly="readonly" value="<%=endDate %>"/>
      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_end_date,tributton2);" />
      	</td>
    </tr>
    
  </table> 
</div>
    <div id="oper_div">

     <span class="tj_btn"><a href="#" onclick="save()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
        
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";	
	
	getNextActivityCode();
	
	function cancel()
	{
		window.close();
	}
		
	
	function save(){
		if(checkForm()){
			var str = $("#form1").serialize();				
			var result = jcdpCallService("P6ProjectPlanSrv", "addTask", str);
			reload();
			window.setTimeout(newClose(),2000);
		}
	}
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("activity_name", "作业名称")) {		
			document.form1.activity_name.focus();
			return false;	
		}
		/*
		if (!isTextPropertyNotNull("plan_start_date", "计划开始时间")) {		
			//document.form1.plan_start_date.focus();
			//return false;	
		}
		if (!isTextPropertyNotNull("plan_end_date", "计划结束时间")) {		
			//document.form1.plan_end_date.focus();
			//return false;	
		}
		*/
		var start_date = $("#plan_start_date").val();
		var end_date = $("#plan_end_date").val();
		if(end_date < start_date){
			alert("开始时间不能大于结束时间");
			return false;
		}
		return true;
	}	

	function getNextActivityCode(){
		var str = "project_info_no=<%=projectInfoNo%>";
		var obj = jcdpCallService("P6ProjectPlanSrv", "getNextActivityCode", str);
		if(obj != null && obj.nextTaskId != "") {
			document.getElementById("activity_id").value = obj.nextTaskId;
		} 
	}

	function reload(){
		var ctt = top.frames['list'];
		if(ctt != "" && ctt != undefined){			
			ctt.mainTopframe.refreshTree('<%=parentWbsObjectId%>');
		}
	}
</script>

</html>
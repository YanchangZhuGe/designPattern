<%@page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.List"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	List humanMap = respMsg.getMsgElements("datas");
 
	int length = 0;
	if(humanMap != null && humanMap.size()>0){
		length = humanMap.size();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

 <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff;overflow-y:auto" onload="refreshData()">
 <form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
  	<div id="oper_div" align="center">
 		<span class="yd"><a href="#" onclick="copyEsimiDate()"></a></span>
    </div>
 <div id="list_table">
	<div id="table_box" >
	  <table width="99%" border="0" cellspacing="0" cellpadding="0"  id="queryRetTable">		
	     <tr>
	      <td class="bt_info_even" width="1%">序号</td>
	      <td class="bt_info_odd" width="5%">用工类型</td>
	      <td class="bt_info_even" width="6%">员工编号</td>
	      <td class="bt_info_odd" width="6%">员工姓名</td>
	      <td class="bt_info_even" width="5%">班组</td>
	      <td class="bt_info_odd" width="6%">岗位</td>
	      <td class="bt_info_even" width="7%">预计进入项目时间</td>
	      <td class="bt_info_odd" width="7%">预计离开项目时间</td>
	      <td class="bt_info_even" width="3%">预计天数</td>
	      <td class="bt_info_odd" width="7%">实际进入项目时间</td>
	      <td class="bt_info_even" width="9%">实际离开项目时间</td>
	      <td class="bt_info_odd" width="7%">人员评价<input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=length%>" />
	      
	      </td>
	     </tr> 		
	<% 	if(humanMap != null && humanMap.size()>0){
  				for(int i = 0;i < humanMap.size(); i++){
  					String className = "";
  					if (i % 2 == 0) {
  						className = "odd_";
  					} else {
  						className = "even_";
  					}
  					MsgElement msg = (MsgElement)humanMap.get(i);
  					Map record = msg.toMap(); 
       %>
    <tr>
   	 <td class="<%=className%>even" ><%=i+1%>
   	 <input type="hidden" name="fy<%=i%>relationNo" id="fy<%=i%>relationNo" value=""/>	
   	 <input type="hidden" name="fy<%=i%>szType" id="fy<%=i%>szType" value="<%=record.get("sz_type")%>" />	
	 <input type="hidden" name="fy<%=i%>typeParam" id="fy<%=i%>typeParam" value="<%=record.get("type_param") != null ? record.get("type_param"):""%>"/>
   	 <input type="hidden" name="fy<%=i%>spare2" id="fy<%=i%>spare2" value="<%=record.get("spare2") != null ? record.get("spare2"):""%>"/>		
   	 <input type="hidden" name="fy<%=i%>humanDetailNo" id="fy<%=i%>humanDetailNo" value="<%=record.get("human_detail_no")%>"/>		
   	 <input type="hidden" name="fy<%=i%>employeeHrId" id="fy<%=i%>employeeHrId" value="<%=record.get("deploy_detail_id")%>"/>	
   	 <input type="hidden" name="fy<%=i%>reorgId" id="fy<%=i%>reorgId" value="<%=(record.get("reorg_id") == null || "".equals(record.get("reorg_id")))?record.get("org_id"):record.get("reorg_id")%>"/>
   	 <input type="hidden" name="fy<%=i%>projectInfoNo" id="fy<%=i%>projectInfoNo" value="<%=record.get("project_info_no")%>"/></td>		
	 
   	 <td class="<%=className%>odd" ><%= record.get("type_name") != null ? record.get("type_name"):"" %>&nbsp;</td>
	 <td class="<%=className%>even" ><%= record.get("employee_cd") != null ? record.get("employee_cd"):"" %>&nbsp;</td>	
	 <td class="<%=className%>odd" ><%= record.get("employee_name") != null ? record.get("employee_name"):"" %><input type="hidden" name="fy<%=i%>employeeId" id="fy<%=i%>employeeId" value="<%=record.get("employee_id")%>"/>&nbsp;</td>	
	 <td class="<%=className%>even"><%= record.get("team_name") != null ? record.get("team_name"):"" %><input type="hidden" name="fy<%=i%>team" id="fy<%=i%>team" value="<%=record.get("team")%>"/>&nbsp;</td>
	 <td class="<%=className%>odd" ><%= record.get("work_post_name") != null ? record.get("work_post_name"):"" %><input type="hidden" name="fy<%=i%>workPost" id="fy<%=i%>workPost" value="<%=record.get("work_post")%>"/>&nbsp;</td>
	 <td class="<%=className%>even"><%= record.get("plan_start_date") != null ? record.get("plan_start_date"):"" %><input type="hidden" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate" value="<%=record.get("plan_start_date")%>"/>&nbsp;</td>
	 <td class="<%=className%>odd" ><%= record.get("plan_end_date") != null ? record.get("plan_end_date"):"" %><input type="hidden" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate" value="<%=record.get("plan_end_date")%>"/>&nbsp;</td>
	 <td class="<%=className%>even"><%= record.get("days") != null ? record.get("days"):"" %>&nbsp;</td>
	 <td class="<%=className%>odd" ><%= record.get("actual_start_date") != null ? record.get("actual_start_date"):"" %><input type="hidden" name="fy<%=i%>actualStartDate" id="fy<%=i%>actualStartDate" value="<%=record.get("actual_start_date")%>"/></td>
	 <td class="<%=className%>even"><input type="text" name="fy<%=i%>actualEndDate" id="fy<%=i%>actualEndDate" class="input_width"  value="<%= (record.get("actual_end_date") != null && !"".equals(record.get("actual_end_date"))) ? record.get("actual_end_date"):record.get("plan_end_date") != null ? record.get("plan_end_date"):"" %>" readonly="readonly"/>
	 <img src="<%=contextPath%>/images/calendar.gif" id="tributton40<%=i%>" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy<%=i%>actualEndDate',tributton40<%=i%>);" /></td>
	 <td class="<%=className%>odd" >
	 <%
	 if(record.get("type_param").equals("0")){
	 %>
	 <code:codeSelect name='<%=("fy"+String.valueOf(i)+"projectEvaluate")%>' option="employeeEvaluateLevel" addAll="true" selectedValue='<%=record.get("project_evaluate") != null ? (String)record.get("project_evaluate"):""%>' cssClass="select_width"/>&nbsp;
	 <%
	 }else{
	 %>
	 <div style="display:none;">
	 <input type="hidden" name="fy<%=i%>notes" id="fy<%=i%>notes"  style="width:70px;" value=""/>
	 <code:codeSelect name='<%=("fy"+String.valueOf(i)+"projectEvaluate")%>' option="employeeEvaluateLevel" addAll="true" selectedValue='<%=record.get("project_evaluate") != null ? (String)record.get("project_evaluate"):"1"%>' cssClass="select_width"/>&nbsp;
	 </div>
	 <%
	 } 
	 %>

 
	 </td>

	 </tr>
       <% } 
  				}%>
	  </table>
	</div>
    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</form>
</body>
 
<script type="text/javascript">
 
function copyEsimiDate(){
	
	var infoSize = document.getElementById("equipmentSize").value;
	var date1 = document.getElementById("fy0actualEndDate").value;
	var date2 = document.getElementById("fy0projectEvaluate").value;
	
	for(var i=0;i<infoSize;i++){
		document.getElementById("fy"+i+"actualEndDate").value=date1;
		document.getElementById("fy"+i+"projectEvaluate").value=date2;
	}
}

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm"); 
		form.action = "<%=contextPath%>/rm/em/saveZHumanReturn.srq";
		form.submit();
		newClose();
	}

}

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;

	for(var i=0;i<deviceCount;i++){
		
		var actualEndDate = document.getElementById("fy"+i+"actualEndDate").value;
		var projectEvaluate = document.getElementById("fy"+i+"projectEvaluate").value;
		var typeParam = document.getElementById("fy"+i+"typeParam").value;
		
		if(actualEndDate == ""){
			alert("请添加实际离开项目时间！");
			document.getElementById("fy"+i+"actualEndDate").onfocus="true";
			return false;				
		}else{
			var actualStartDate = document.getElementById("fy"+i+"actualStartDate").value;
			var days=(new Date(actualEndDate.replace(/-/g,'/'))-new Date(actualStartDate.replace(/-/g,'/')))/3600/24/1000;
			if(days<0){
				alert("实际离开项目时间应大于实际进入项目时间");
				document.getElementById("fy"+i+"actualEndDate").onfocus="true";
				return false;
			}
		}
		if(typeParam =="0"){
			if(projectEvaluate == ""){
				alert("请添加人员评价！");
				document.getElementById("fy"+i+"projectEvaluate").onfocus="true";
				return false;	
			}
		} 
		

	}

	return true;
}


</script>
</html>
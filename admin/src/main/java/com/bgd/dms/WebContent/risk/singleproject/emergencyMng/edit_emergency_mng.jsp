<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath(); 
	String risk_emergency_id = request.getParameter("emergencyId")!=null?request.getParameter("emergencyId"):"";
	System.out.println("the risk_emergency_id is:"+risk_emergency_id);
	String pageAction = request.getParameter("pageAction")!=null?request.getParameter("pageAction"):"";
	System.out.println("the page action is:"+pageAction);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应急管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body>
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	
  	<tr>
    	<td colspan="4" align="center">新增修改应急管理</td>
    </tr>
    <tr>
        <td class="inquire_item4">问题：</td>
      	<td class="inquire_form4"><input type="text" name="emergency_problem" id="emergency_problem" class="input_width" /></td>
    	<td class="inquire_item4">填报时间：</td>	
      	<td class="inquire_form4">
    	 <input type="text" name="reprot_create_date" id="report_create_date" class="input_width" readonly="readonly"/>	
      	</td>
    </tr> 
    <tr>
    	<td class="inquire_item4">状态：</td>
      	<td class="inquire_form4"><input type="text" name="emergency_status" id="emergency_status" class="input_width" /></td>
    	<td class="inquire_item4">发生日期：</td>
      	<td class="inquire_form4">
      	<input type="text" name="create_date" id="create_date" class="input_width" readonly="readonly"/>
      	<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(create_date,tributton1);" />
      	</td>
    </tr> 
    <tr>
        <td class="inquire_item4">责任人：</td>
      	<td class="inquire_form4">
      	<input type="text" name="res_person_name" id="res_person_name" class="input_width" readonly="readonly"/>
      	<input type="hidden" name="res_person_id" id="res_person_id" class="input_width" />
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectResPerson()" />  
      	</td>
    	<td class="inquire_item4">责任单位：</td>
      	<td class="inquire_form4">
      	<input type="text" name="res_org_name" id="res_org_name" class="input_width" readonly="readonly"/>
      	<input type="hidden" name="res_org_id" id="res_org_id" class="input_width" />
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectResOrg()" />  
      	</td>
    </tr>    
    <tr>
    	<td class="inquire_item4">原因：</td>
      	<td class="inquire_form4"><textarea rows="4" id="emergency_reason" name="emergency_reason"></textarea></td>
    	<td class="inquire_item4">过程：</td>
      	<td class="inquire_form4"><textarea rows="4" id="emergency_process" name="emergency_process"></textarea></td>
    </tr> 

</table>
</div>
    <div id="oper_div">
    	<auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>        
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	
	var nowDate = new Date();
	cruConfig.contextPath =  "<%=contextPath%>";
	var risk_emergency_id = "<%=risk_emergency_id%>";
	if('<%=risk_emergency_id%>'!=""&&'<%=risk_emergency_id%>'!='null'){
		getRiskEmergencyInfo('<%=risk_emergency_id%>');
	}	

	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("report_create_date").value = getYearValue()+"-"+getMonthValue()+"-"+getDateValue();
			document.getElementById("form1").action = "<%=contextPath%>/risk/addRiskEmergency.srq";
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/editRiskEmergency.srq?risk_emergency_id="+risk_emergency_id;
		}
	}
	
	function selectRisks(){
		window.open('<%=contextPath%>/risk/singleproject/emergencyMng/select_risk.jsp');
	}	
	
	function selectResPerson(){ 
		var risk_info={
		        fkValue:"",
		        value:""
		    };
		window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?multi=true&select=employeeid',risk_info,"dialogWidth=800px;dialogHeight=600px;resizable=1");
		document.getElementsByName("res_person_id")[0].value = risk_info.fkValue;
		document.getElementsByName("res_person_name")[0].value = risk_info.value;
	}
	
	function selectResOrg(){ 
		var risk_info={
		        fkValue:"",
		        value:""
		    };
		window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?multi=true&select=orgid',risk_info,"dialogWidth=800px;dialogHeight=600px;resizable=1");
		document.getElementsByName("res_org_id")[0].value = risk_info.fkValue;
		document.getElementsByName("res_org_name")[0].value = risk_info.value;
	}
	
	function getRiskEmergencyInfo(id){
		var retObj = jcdpCallService("riskSrv", "getRiskEmergencyInfo", "emergencyId="+id);
		
		document.getElementById("res_person_name").value= retObj.riskInfoMap.res_person_names != undefined ? retObj.riskInfoMap.res_person_names:"";
		document.getElementById("res_person_id").value= retObj.riskInfoMap.res_person_ids != undefined ? retObj.riskInfoMap.res_person_ids:"";
		document.getElementById("create_date").value= retObj.riskInfoMap.happen_date != undefined ? retObj.riskInfoMap.happen_date:"";
		document.getElementById("report_create_date").value= retObj.riskInfoMap.create_date != undefined ? retObj.riskInfoMap.create_date:"";
		
		document.getElementById("res_org_name").value= retObj.riskInfoMap.res_org_names != undefined ? retObj.riskInfoMap.res_org_names:"";
		document.getElementById("res_org_id").value= retObj.riskInfoMap.res_org_ids != undefined ? retObj.riskInfoMap.res_org_ids:"";
		
		document.getElementById("emergency_problem").value= retObj.riskInfoMap.emergency_problem != undefined ? retObj.riskInfoMap.emergency_problem:"";
		document.getElementById("emergency_status").value = retObj.riskInfoMap.emergency_status != undefined ? retObj.riskInfoMap.emergency_status:"";
		
		document.getElementById("emergency_reason").innerHTML= retObj.riskInfoMap.emergency_reason != undefined ? retObj.riskInfoMap.emergency_reason:"";
		document.getElementById("emergency_process").innerHTML = retObj.riskInfoMap.emergency_process != undefined ? retObj.riskInfoMap.emergency_process:"";

	}
	
	function refreshData(){
		document.getElementById("form1").submit();
	}
</script>
</html>
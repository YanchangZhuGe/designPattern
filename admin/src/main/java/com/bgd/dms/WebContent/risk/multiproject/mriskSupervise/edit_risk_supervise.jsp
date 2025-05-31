<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath(); 
	String risk_supervise_id = request.getParameter("riskSuperviseId")!=null?request.getParameter("riskSuperviseId"):"";
	System.out.println("the risk_emergency_id is:"+risk_supervise_id);
	String pageAction = request.getParameter("pageAction")!=null?request.getParameter("pageAction"):"";
	System.out.println("the page action is:"+pageAction);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>风险监控</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body>
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	
  	<tr>
    	<td colspan="4" align="center">新增修改风险监控</td>
    </tr>
    <tr>
        <td class="inquire_item4">风险类别：
        	<input type="hidden" name="risk_supervise_id" id="risk_supervise_id" value="<%=risk_supervise_id%>"/>
        </td>
      	<td class="inquire_form4">
      	    <input type="hidden" name="risk_type_id" id="risk_type_id" class="input_width" />
      		<input type="text" name="risk_type_name" id="risk_type_name" class="input_width" readonly="readonly"/>
      		<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectRiskType()"/> 
      	</td>
    	<td class="inquire_item4">二级风险：</td>
      	<td class="inquire_form4">
      		<input type="text" name="second_risk_type" id="second_risk_type" class="input_width" />
      	</td>
    </tr> 
    <tr>
    	<td class="inquire_item4">风险指标：</td>
      	<td class="inquire_form4">
			<textarea rows="4" id="risk_norm" name="risk_norm"></textarea>
		</td>
    	<td class="inquire_item4">需提供数据指标：</td>
      	<td class="inquire_form4">
      		<textarea rows="4" id="provide_data_norm" name="provide_data_norm"></textarea>
      	</td>
    </tr> 
    <tr>
    	<td class="inquire_item4">应用层面：</td>
      	<td class="inquire_form4">
      	 	<select name="use_area" id="use_area" class="select_width">
      			<option value="1">管理</option>
      			<option value="2">项目</option>
      			<option value="3">管理/项目</option>
      		</select>
      	</td>
    	<td class="inquire_item4">数据负责单位：</td>
      	<td class="inquire_form4">
	      	<input type="text" name="res_org_name" id="res_org_name" class="input_width" readonly="readonly"/>
	      	<input type="hidden" name="res_org_id" id="res_org_id" class="input_width" />
	      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectResOrg()" /> 
      	</td>
    </tr> 
    <tr>
        <td class="inquire_item4">数据负责人：</td>
      	<td class="inquire_form4">
	      	<input type="text" name="res_person_name" id="res_person_name" class="input_width" readonly="readonly"/>
	      	<input type="hidden" name="res_person_id" id="res_person_id" class="input_width" />
	      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectResPerson()" />  
      	</td>
    	<td class="inquire_item4">上报频率：</td>
      	<td class="inquire_form4">
 			<select name="report_rate" id="report_rate" class="select_width">
      			<option value="1">月度</option>
      			<option value="2">季度</option>
      			<option value="3">年度</option>
      		</select>
      	</td>
    </tr>    
    <tr>
    	<td class="inquire_item4">数据途径：</td>
      	<td class="inquire_form4">
	      	<input type="text" name="data_way" id="data_way" class="input_width" />
      	</td>
    	<td class="inquire_item4">备注：</td>
      	<td class="inquire_form4"><textarea rows="4" id="remark" name="remark"></textarea></td>
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
	
	cruConfig.contextPath =  "<%=contextPath%>";
	var risk_supervise_id = "<%=risk_supervise_id%>";
	if('<%=risk_supervise_id%>'!=""&&'<%=risk_supervise_id%>'!='null'){
		getRiskSuperviseInfo('<%=risk_supervise_id%>');
	}	

	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/addRiskSupervise.srq";
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/editRiskSupervise.srq";
		}
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
	
	function getRiskSuperviseInfo(id){
		
		var retObj = jcdpCallService("riskSrv", "getRiskSuperviseInfo", "riskSuperviseId="+id);
		document.getElementById("risk_type_id").value= retObj.riskInfoMap.risk_type != undefined ? retObj.riskInfoMap.risk_type:"";
		document.getElementById("risk_type_name").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		document.getElementById("second_risk_type").value= retObj.riskInfoMap.second_risk_type != undefined ? retObj.riskInfoMap.second_risk_type:"";
		document.getElementById("use_area").value = retObj.riskInfoMap.use_area != undefined ? retObj.riskInfoMap.use_area:"";
		document.getElementById("res_org_name").value= retObj.riskInfoMap.res_org_name != undefined ? retObj.riskInfoMap.res_org_name:"";
		document.getElementById("res_org_id").value= retObj.riskInfoMap.res_org_id != undefined ? retObj.riskInfoMap.res_org_id:"";
		document.getElementById("res_person_name").value= retObj.riskInfoMap.res_person_name != undefined ? retObj.riskInfoMap.res_person_name:"";
		document.getElementById("res_person_id").value= retObj.riskInfoMap.res_person_id != undefined ? retObj.riskInfoMap.res_person_id:"";
		document.getElementById("report_rate").value= retObj.riskInfoMap.report_rate != undefined ? retObj.riskInfoMap.report_rate:"";
		document.getElementById("data_way").value = retObj.riskInfoMap.data_way != undefined ? retObj.riskInfoMap.data_way:"";
		document.getElementById("risk_norm").innerHTML= retObj.riskInfoMap.risk_norm != undefined ? retObj.riskInfoMap.risk_norm:"";
		document.getElementById("provide_data_norm").innerHTML = retObj.riskInfoMap.provide_data_norm != undefined ? retObj.riskInfoMap.provide_data_norm:"";
		document.getElementById("remark").innerHTML = retObj.riskInfoMap.remark != undefined ? retObj.riskInfoMap.remark:"";
	
	}
	
	function refreshData(){
		document.getElementById("form1").submit();
	}
	
	function selectRiskType(){
		popWindow('<%=contextPath%>/risk/multiproject/mselect_risk_type.jsp');
	}	
	
	function setRiskType(arg){ 
		document.getElementsByName("risk_type_id")[0].value = arg[0];
		document.getElementsByName("risk_type_name")[0].value = arg[1];
	}
</script>
</html>
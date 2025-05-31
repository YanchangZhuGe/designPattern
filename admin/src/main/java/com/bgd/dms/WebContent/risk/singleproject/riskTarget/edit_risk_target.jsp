<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath(); 
	String target_id = request.getParameter("riskTargetId")!=null?request.getParameter("riskTargetId"):"";
	String pageAction = request.getParameter("pageAction")!=null?request.getParameter("pageAction"):"";
	System.out.println("the page action is:"+pageAction);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>风险识别</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body>
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	
  	<tr>
    	<td colspan="4" align="center">新增修改风险目标
    	<input type="hidden" name="target_id" id="target_id" class="input_width" value="<%=target_id%>"/>
    	</td>
    </tr>
    <tr>
		<td class="inquire_item4">风险类别：</td>
      	<td class="inquire_form4">
      	<input type="hidden" name="risk_type_id" id="risk_type_id" class="input_width""/>
      	<input type="text" name="risk_type_name" id="risk_type_name" class="input_width" readonly="readonly"/>
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectRiskType()" />      	 		
      	</td>
    	<td class="inquire_item4">目标名称：</td>
      	<td class="inquire_form4"><input type="text" name="target_name" id="target_name" class="input_width" /></td>
    </tr> 
    <tr>
        <td class="inquire_item4">风险承受度:</td>
 		<td class="inquire_item4"><input type="text" name="risk_bear_level" id="risk_bear_level" class="input_width" /></td>
    	<td class="inquire_item4">目标描述：</td>
      	<td class="inquire_form4">
			<textarea rows="4" cols="36" name="target_desc" id="target_desc" readonly="readonly"></textarea>
		</td>
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
	var risk_identify_id = "<%=target_id%>";
	if('<%=target_id%>'!=""&&'<%=target_id%>'!='null'){
		getRiskTargetInfo('<%=target_id%>');
	}	

	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/addRiskTarget.srq";
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/editRiskTarget.srq";
		}
	}
	
	function selectRiskType(){

		window.open('<%=contextPath%>/risk/singleproject/riskTarget/select_risk_type.jsp');
		//window.open('<%=contextPath%>/risk/singleproject/riskTarget/select_risk_type.jsp',risk_info,"dialogWidth=800px;dialogHeight=600px;resizable=1");
		
	}	
	
	function setRiskType(fkValue, value){ 
		document.getElementsByName("risk_type_id")[0].value = fkValue;
		document.getElementsByName("risk_type_name")[0].value = value;
	}
	function getRiskTargetInfo(id){
		var retObj = jcdpCallService("riskSrv", "getRiskTargetInfo", "targetId="+id);
		document.getElementById("risk_type_id").value= retObj.riskInfoMap.risk_type_id != undefined ? retObj.riskInfoMap.risk_type_id:"";
		document.getElementById("risk_type_name").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		document.getElementById("target_name").value = retObj.riskInfoMap.target_name != undefined ? retObj.riskInfoMap.target_name:"";
		document.getElementById("risk_bear_level").value = retObj.riskInfoMap.risk_bear_level != undefined ? retObj.riskInfoMap.risk_bear_level:"";
		document.getElementById("target_desc").innerHTML= retObj.riskInfoMap.target_desc != undefined ? retObj.riskInfoMap.target_desc:"";
	}
	
	function refreshData(){
		if(document.getElementById("risk_type_name").value == ""){
			alert("请选择风险类别 !");
			return;
		}
		document.getElementById("form1").submit();
	}
</script>
</html>
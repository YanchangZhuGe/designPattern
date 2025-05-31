<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath(); 
	String risk_identify_id = request.getParameter("riskIdentifyId")!=null?request.getParameter("riskIdentifyId"):"";
	System.out.println("the risk identify id is:"+risk_identify_id);
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
    	<td colspan="4" align="center">新增修改风险识别</td>
    </tr>
    <tr>
    	<td class="inquire_item4">名称：
    	<input type="hidden" name="risk_identify_id" id="risk_identify_id" class="input_width" value="<%=risk_identify_id%>"/>
    	</td>
      	<td class="inquire_form4">
      	<input type="text" name="risk_name" id="risk_name" class="input_width"/>
      	<input type="hidden" name="risk_id" id="risk_id" class="input_width" />
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectRiskBase()" />      	 		
      	</td>
    	<td class="inquire_item4">风险编号：</td>
      	<td class="inquire_form4"><input type="text" name="risk_number" id="risk_number" class="input_width" /></td>
    </tr> 
    <tr>
    	<td class="inquire_item4">风险承受度：</td>
      	<td class="inquire_form4"><input type="text" name="risk_bear_level" id="risk_bear_level" class="input_width" /></td>
    	<td class="inquire_item4">风险级别：</td>
      	<td class="inquire_form4"><input type="text" name="risk_level" id="risk_level" class="input_width"/></td>
    </tr> 
    <tr>
    	<td class="inquire_item4">风险影响程度：</td>
      	<td class="inquire_form4"><input type="text" name="influence_level" id="influence_level" class="input_width" /></td>
    	<td class="inquire_item4">风险可能性：</td>
      	<td class="inquire_form4"><input type="text" name="risk_probability" id="risk_probability" class="input_width"/></td>
    </tr> 
    <tr>
        <td class="inquire_item4">风险类型：</td>
      	<td class="inquire_form4">
      		<input type="hidden" name="risk_type_id" id="risk_type_id"/>
      		<input type="text" name="risk_type" id="risk_type" class="input_width" readonly="readonly"/>
      		<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectRiskType()" />      	 		
      	</td>
    	<td class="inquire_item4">风险描述：</td>
      	<td class="inquire_form4">
      	<textarea rows="3" cols="" id="risk_desc" name="risk_desc"></textarea>
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
	var risk_identify_id = "<%=risk_identify_id%>";
	if('<%=risk_identify_id%>'!=""&&'<%=risk_identify_id%>'!='null'){
		getRiskIdentifyInfo('<%=risk_identify_id%>');
	}	

	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/addMulRiskIdentify.srq?isMulti=1";
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/editMulRiskIdentify.srq";
		}
	}
	
	function selectRiskBase(){
		popWindow('<%=contextPath%>/risk/singleproject/riskIdentify/select_risk_base.jsp');
	}	
	
	function setRiskBase(arg){ 
		document.getElementsByName("risk_id")[0].value = arg[0];
		document.getElementsByName("risk_name")[0].value = arg[1];
		document.getElementsByName("risk_type")[0].value = arg[2];
		document.getElementsByName("risk_desc")[0].value = arg[3];
		document.getElementsByName("risk_type_id")[0].value = arg[4];
	}
	
	function selectRiskType(){
		popWindow('<%=contextPath%>/risk/multiproject/mriskBase/select_risk_type.jsp');
	}	
	function setRiskType(arg){ 
		document.getElementsByName("risk_type_id")[0].value = arg[0];
		document.getElementsByName("risk_type")[0].value = arg[1];
	}
	
	function getRiskIdentifyInfo(id){
		var retObj = jcdpCallService("riskSrv", "getRiskIdenfityInfo", "riskIdentifyID="+id);
		document.getElementById("risk_id").value= retObj.riskInfoMap.risk_id != undefined ? retObj.riskInfoMap.risk_id:"";
		document.getElementById("risk_name").value= retObj.riskInfoMap.risk_db_name != undefined ? retObj.riskInfoMap.risk_db_name:"";
		document.getElementById("risk_type").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		document.getElementById("risk_type_id").value= retObj.riskInfoMap.risk_type != undefined ? retObj.riskInfoMap.risk_type:"";
		document.getElementById("risk_level").value = retObj.riskInfoMap.risk_level != undefined ? retObj.riskInfoMap.risk_level:"";
		document.getElementById("risk_number").value= retObj.riskInfoMap.risk_number != undefined ? retObj.riskInfoMap.risk_number:"";
		document.getElementById("risk_bear_level").value= retObj.riskInfoMap.risk_bear_level != undefined ? retObj.riskInfoMap.risk_bear_level:"";
		document.getElementById("influence_level").value= retObj.riskInfoMap.influence_level != undefined ? retObj.riskInfoMap.influence_level:"";
		document.getElementById("risk_probability").value= retObj.riskInfoMap.risk_probability != undefined ? retObj.riskInfoMap.risk_probability:"";
		document.getElementById("risk_desc").innerHTML= retObj.riskInfoMap.risk_desc != undefined ? retObj.riskInfoMap.risk_desc:"";
	}
	
	function refreshData(){
		document.getElementById("form1").submit();
	}
	
	function checkForm(){ 	
		
		if (!isTextPropertyNotNull("doc_number", "文档编号")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}	
</script>
</html>
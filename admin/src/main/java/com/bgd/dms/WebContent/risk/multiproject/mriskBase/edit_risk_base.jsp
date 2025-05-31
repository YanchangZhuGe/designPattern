<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String riskBaseId = "";
	if(request.getParameter("riskBaseId")!=null && request.getParameter("riskBaseId")!=""){
		riskBaseId = request.getParameter("riskBaseId");
	}
    String pageAction = "";
    if(request.getParameter("pageAction")!=null&&request.getParameter("pageAction")!=""){
    	pageAction = request.getParameter("pageAction");
    }
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增编辑风险库</title>
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
    	<td colspan="4" align="center">
    	<input type="hidden" name="risk_base_id" value="<%=riskBaseId%>"/>
    	</td>
    	
    </tr>
    <tr>
    	<td class="inquire_item4">风险名称：</td>
      	<td class="inquire_form4"><input type="text" name="risk_db_name" id="risk_db_name" class="input_width" /></td>
    	<td class="inquire_item4">风险类别</td>
      	<td class="inquire_form4">
      		<input type="hidden" name="risk_type_id" id="risk_type_id" class="input_width" />
      		<input type="text" name="risk_type_name" id="risk_type_name" class="input_width" />
      		<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectRiskType()"/> 
      	</td>
	
    </tr>
    <tr>
        <td class="inquire_item4">涉及部门：</td>
      	<td class="inquire_form4">
      		<input type="hidden" name="org_id" id="org_id" class="input_width"/>
      		<input type="text" name="org_name" id="org_name" class="input_width" readonly="readonly"/>
      		<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectOrg()"/> 
      	</td>
    	<td class="inquire_item4">风险定义：</td>
      	<td class="inquire_form4">
			<textarea rows="5" cols="" name="risk_db_definition" id="risk_db_definition"></textarea>  	 		
      	</td>
		
    </tr>    
   <tr>
      	<td class="inquire_item4">风险表现：</td>
      	<td class="inquire_form4">
      		<textarea rows="5" cols="" name="risk_db_behave" id="risk_db_behave"></textarea>
      	</td>
      	<td class="inquire_item4">&nbsp;</td>
      	<td class="inquire_form4">&nbsp;</td>
   </tr>    
   <tr>
      	<td class="inquire_item4">关键成因：</td>
      	<td class="inquire_form4">
      		<textarea rows="5" cols="" name="risk_db_reason" id="risk_db_reason"></textarea>
      	</td>
      	<td class="inquire_item4">&nbsp;</td>
      	<td class="inquire_form4">&nbsp;</td>
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
	var risk_base_id = "<%=riskBaseId%>";
	var page_action = "<%=pageAction%>";
	var edit_type = "";
	if('<%=riskBaseId%>'!=""&&'<%=riskBaseId%>'!='null'){
		getRiskInfo('<%=riskBaseId%>');
	}	
	
	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/addRiskBase.srq";
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/editRiskBase.srq";
		}
	}
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("doc_number", "文档编号")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}		
	
	function refreshData(){
		document.getElementById("form1").submit();
	}
	
	function getRiskInfo(id){
		var retObj = jcdpCallService("riskSrv", "getRiskBaseInfo", "riskBaseId="+id);
		
		if(document.getElementById("risk_db_name") != null){
			document.getElementById("risk_db_name").value= retObj.riskInfoMap.risk_db_name != undefined ? retObj.riskInfoMap.risk_db_name:"";
		}
		if(document.getElementById("risk_type_id") != null){
			document.getElementById("risk_type_id").value= retObj.riskInfoMap.risk_type_id != undefined ? retObj.riskInfoMap.risk_type_id:"";
		}
		if(document.getElementById("risk_type_name") != null){
			document.getElementById("risk_type_name").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		}
		if(document.getElementById("org_id") != null){
			document.getElementById("org_id").value= retObj.riskInfoMap.org_id != undefined ? retObj.riskInfoMap.org_id:"";
		}
		if(document.getElementById("org_name") != null){
			document.getElementById("org_name").value= retObj.riskInfoMap.org_names != undefined ? retObj.riskInfoMap.org_names:"";
		}
		if(document.getElementById("risk_db_definition") != null){
			document.getElementById("risk_db_definition").innerHTML= retObj.riskInfoMap.risk_db_definition != undefined ? retObj.riskInfoMap.risk_db_definition:"";
		}
		if(document.getElementById("risk_db_behave") != null){
			document.getElementById("risk_db_behave").innerHTML = retObj.riskInfoMap.risk_db_behave != undefined ? retObj.riskInfoMap.risk_db_behave:"";
		}
		if(document.getElementById("risk_db_reason") != null){
			document.getElementById("risk_db_reason").innerHTML = retObj.riskInfoMap.risk_db_reason != undefined ? retObj.riskInfoMap.risk_db_reason:"";
		}
	}
	
	function selectRiskType(){
		popWindow('<%=contextPath%>/risk/multiproject/mriskBase/select_risk_type.jsp');
	}	
	
	function selectOrg(){
		var risk_info={
		        fkValue:"",
		        value:""
		    };
		window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?multi=true&select=orgid',risk_info,"dialogWidth=800px;dialogHeight=600px;resizable=1");
		document.getElementsByName("org_id")[0].value = risk_info.fkValue;
		document.getElementsByName("org_name")[0].value = risk_info.value;
	}
	
	function setRiskType(arg){ 
		document.getElementsByName("risk_type_id")[0].value = arg[0];
		document.getElementsByName("risk_type_name")[0].value = arg[1];
	}
</script>
</html>
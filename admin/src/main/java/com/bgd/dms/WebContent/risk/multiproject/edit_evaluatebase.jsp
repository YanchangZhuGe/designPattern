<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String parentId = "";
	if(request.getParameter("parentId")!=null && request.getParameter("parentId")!=""){
		parentId = request.getParameter("parentId");
	}
	String eidtRiskId = "";
	if(request.getParameter("id")!=null && request.getParameter("id")!=""){
		eidtRiskId = request.getParameter("id");
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
<title>新增编辑评价基础</title>
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
    	<input type="hidden" name="edit_risk_id" value="<%=eidtRiskId%>"/>
    	<input type="hidden" name="parent_risk_id" value="<%=parentId%>"/>
    	</td>
    	
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>新增：</td>
      	<td class="inquire_form4">
      		<select name="add_type" id="add_type" class="select_width" onchange="showInfo(this.value)">
      			<option value="0">数据</option>
      			<option value="1">节点</option>
      		</select>
      	</td>
    	<td class="inquire_item4"><font color="red">*</font>名称：</td>
      	<td class="inquire_form4"><input type="text" name="risk_name" id="risk_name" class="input_width" /></td>
	
    </tr>
    </table>
    <div id="showinfo" style="display:;">
    <table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
    <tr>
        <td class="inquire_item4">风险等级：</td>
      	<td class="inquire_form4">
      		<select name="risk_level" id="risk_level" class="select_width">
      			<option value="0" title="请选择">请选择</option>
      			<option value="1" title="风险很小，日常工作中极少关注或忽略">1-2低度</option>
      			<option value="2" title="风险较小，日常工作中偶尔关注">3-4较低</option>
      			<option value="3" title="一般风险，需要引起一般关注">5-10中度</option>
      			<option value="4" title="风险较大，需要引起高度关注">11-20高度</option>
      			<option value="5" title="风险很大，需要引起极大关注">21-25极高</option>
      		</select>
      	</td>
    	<td class="inquire_item4">风险类别：</td>
      	<td class="inquire_form4">
      	<input type="hidden" name="risk_type" id="risk_type" class="input_width"/>
      	<input type="text" name="risk_type_name" id="risk_type_name" class="input_width" readonly="readonly"/>
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectRiskType()" />      	 		
      	</td>
		
    </tr>    
   <tr>
   		<td class="inquire_item4">发生可能性:</td>
      	<td class="inquire_form4">
			<select name="risk_possibility" id="risk_possibility" class="select_width">
				<option value="0" title="请选择">请选择</option>
      			<option value="1" title="发生概率<5%,今后10年内发生的可能少于1次,一般情况下不会发生">1-几乎不可能</option>
      			<option value="2" title="发生概率5%-30%,今后5-10年内可能发生1次,极少情况下发生">2-不太可能</option>
      			<option value="3" title="发生概率30%-50%,今后2-5年内可能发生1次,某些情况下发生">3-可能</option>
      			<option value="4" title="发生概率50-95%,今后1年内可能发生1次,较多情况下发生">4-很可能</option>
      			<option value="5" title="发生概率>=95%,今后1年内至少发生一次,常常会发生">5-基本确定</option>
      		</select>
		</td>
      	<td class="inquire_item4">内容描述：</td>
      	<td class="inquire_form4">
      		<textarea rows="" cols="" name="risk_desc" id="risk_desc"></textarea>
      	</td>

   </tr>    
 
</table>
</div>
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
	var risk_id = "<%=eidtRiskId%>";
	var page_action = "<%=pageAction%>";
	var edit_type = "";
	if('<%=eidtRiskId%>'!=""&&'<%=eidtRiskId%>'!='null'){
		getRiskInfo('<%=eidtRiskId%>');
	}	
	
	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/addRisk.srq";
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/risk/editRisk.srq?editType="+edit_type;
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
		var retObj = jcdpCallService("riskSrv", "getRiskInfo", "riskID="+id);
		if(retObj.riskInfoMap.is_node != undefined){
			edit_type = retObj.riskInfoMap.is_node != undefined ? retObj.riskInfoMap.is_node:"";
			document.getElementById("add_type").value=retObj.riskInfoMap.is_node != undefined ? retObj.riskInfoMap.is_node:"";
			document.getElementById("add_type").disabled="disabled";
			if(retObj.riskInfoMap.is_node == "1"){			
				document.getElementById("showinfo").style.display="none";
			}else if(retObj.riskInfoMap.is_node == "0"){
				document.getElementById("showinfo").style.display="";
			}
		}
		
		if(document.getElementById("risk_name") != null){
			document.getElementById("risk_name").value= retObj.riskInfoMap.risk_name != undefined ? retObj.riskInfoMap.risk_name:"";
		}
		if(document.getElementById("risk_desc") != null){
			document.getElementById("risk_desc").innerHTML= retObj.riskInfoMap.risk_desc != undefined ? retObj.riskInfoMap.risk_desc:"";
		}
		if(document.getElementById("risk_type") != null){
			document.getElementById("risk_type").value= retObj.riskInfoMap.risk_type_id != undefined ? retObj.riskInfoMap.risk_type_id:"";
		}
		if(document.getElementById("risk_type_name") != null){
			document.getElementById("risk_type_name").value= retObj.riskInfoMap.risk_type != undefined ? retObj.riskInfoMap.risk_type:"";
		}
		if(document.getElementById("risk_level") != null){
			document.getElementById("risk_level").value = retObj.riskInfoMap.risk_level != undefined ? retObj.riskInfoMap.risk_level:"";
		}
		if(document.getElementById("risk_possibility") != null){
			document.getElementById("risk_possibility").value = retObj.riskInfoMap.risk_possibility != undefined ? retObj.riskInfoMap.risk_possibility:"";
		}
	}
	
	function showInfo(i){
		if(i == 0){
			document.getElementById("showinfo").style.display="";
		}else if(i == 1){
			document.getElementById("showinfo").style.display="none";
		}
	}
	
	function selectRiskType(){
		popWindow('<%=contextPath%>/risk/multiproject/mselect_risk_type.jsp');
	}	
	
	function setRiskType(arg){ 
		document.getElementsByName("risk_type")[0].value = arg[0];
		document.getElementsByName("risk_type_name")[0].value = arg[1];
	}
</script>
</html>
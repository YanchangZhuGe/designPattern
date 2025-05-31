<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId=user.getEmpId();	
	String projectInfoNo = request.getParameter("projectInfoNo");
	boolean projectSelect=true;
	if(projectInfoNo!=null){
		projectSelect=false;
	}
	String schemaId=request.getParameter("schemaId");
	if(schemaId==null){
		schemaId = "";
	}
	String org_subjection_id= user.getSubOrgIDofAffordOrg();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
  <title>技术方案对比</title>
 </head>
 
 <body style="background:#fff" onload="refreshData()">
 
 <iframe id="hidderIframe" name="hidderIframe" style="display: none"></iframe>
 
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  			<tr>
							<%
							if(schemaId!=null&&!"".equals(schemaId)){
								String[] schemas=schemaId.split(",");
								for(int i=0;i<schemas.length;i++) {
									String tempName=OPCommonUtil.getCostSchemaNameById(schemas[i]);
						  			%>
						  			<td width="10%">
						  			<input type="checkbox" name="selectSchemaName" value="<%=schemas[i]%>"><%=tempName%>
						  			</td>
								 <%} 
						    }
							%>
					<td>&nbsp;</td>
					<td>
					<span class='pass_btn'><a href='#' onclick='pass()' ></a></span>
					<span class='nopass_btn'><a href='#' onclick='notpass()' ></a></span>
					</td>
					<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="JCDP_btn_export"></auth:ListButton>
				</tr>
			</table>
			</td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
				</tr>
			</table>
			</div>
			<div id="fenye_box"  style="display:none">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
				  <ul id="tags" class="tags">
				  	<%int num=0;%>
				  		<li id="tag3_<%=num%>"><a href="#" onclick="getTab3(<%=num%>)">审批</a></li>
				  </ul>
			</div>
			<div id="tab_box" class="tab_box" style="overflow:hidden;height: 300px">
				<% num=0;%>
					<div id="tab_box_content<%=num%>" class="tab_box_content" style="overflow-x: hidden;height: 200px">
						<form id="CheckForm" name="Form0" action="" method="post">
							 	<wf:getProcessInfo/>
							 	<input type="hidden" id="checkedSchemaId" value="">
						</form>
					</div>
			</div>
</div>
</body>

<script type="text/javascript">
	//$(document).ready(readyForSetHeight);

	//frameSize();
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNo = '<%=projectInfoNo%>';
	cruConfig.queryService = "OPCostSrv";
	cruConfig.queryOp = "getCostSchemaContrastInfo"; 
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			refreshData();
		}
	}
	function refreshData(){
		debugger;
		var table = document.getElementById("queryRetTable");
		for(var i =table.rows.length-1;i>=0;i--){
			table.deleteRow(i);
		}
		table.insertRow(0);
		var row = document.getElementById("queryRetTable").rows[0];
		var projectInfoNo = '<%=projectInfoNo%>';
		if(projectInfoNo==null){
			projectInfoNo = document.getElementById("projectInfoNo").value;
		}
		var schemaId = '<%=schemaId%>';
		var if_workflow = 0;
		if(schemaId!=null && schemaId!=''){
			if_workflow = 1;
		}
		var retObj=jcdpCallService('OPCostSrv','getProjectSchema','projectInfoNo='+projectInfoNo+'&if_workflow='+if_workflow);
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null){
			var td = row.insertCell(0);
			td.setAttribute('class','bt_info_odd');
			td.setAttribute('exp',"{cost_name}");
			td.innerHTML = "施工因素";
			for(var i =0;i<retObj.datas.length;i++){
				var data = retObj.datas[i];
				with(data){
					var td = row.insertCell((i+1));
					var type = 'bt_info_even';
					if((i+1)%2==0){
						type ='bt_info_odd';
					}
					td.setAttribute('class',type);
					td.setAttribute('exp',"<font color='"+decision+"'>{cost_detail_money"+rowNum+"}</font>");
					td.innerHTML = "<A onclick=\"schemaDetail('"+costProjectSchemaId+"','"+projectInfoNo+"')\" href='#'>"+schemaName+" </A>";
					//td += "<TD class=bt_info_even exp=\"<font color='"+decision+"'>{cost_detail_money1}</font>\"></TD>";
				}
			}
		}
		debugger;
		cruConfig.submitStr = "projectInfoNo="+projectInfoNo+"&if_workflow="+if_workflow;
		queryData(1);
		var table = document.getElementById("queryRetTable");
		var cells = table.rows[22].cells;
		for(var i=0;i<cells.length;i++){
			debugger;
			cells[i].style.background="#96baf6";
			//cells[i].style.background="#ffc580";
		}
	}
    
    function getCheckedValues(name){
    	var objects=document.getElementsByName(name);
    	var checkedValue="";
    	for(var i =0;i<objects.length;i++){
    		var temp=objects[i];
    		if(temp.checked==true){
    			checkedValue+=temp.value+',';
    		}
    	}
    	if(checkedValue!=""){
    		checkedValue=checkedValue.substring(0,checkedValue.length-1);
    	}
    	return checkedValue;
    }
   function pass(){
			var form = document.getElementById("CheckForm");
			form.target="hidderIframe";
			document.getElementById("isPass").value="pass";
			var selectedValue=getCheckedValues("selectSchemaName");
			document.getElementById("checkedSchemaId").value= selectedValue;
			if(selectedValue==null || selectedValue==""){
				alert("请选择方案!");
				return;
			}
			form.action = "<%=contextPath%>/op/OpCostSrv/doCostSchemaInfo.srq?checkedSchemaId="+selectedValue;
			form.submit();
			setTimeout("closeHere()","2000");

	}
   
   function closeHere(){
		window.close();
	}
   
	function notpass(){
		document.getElementById("checkedSchemaId").value= getCheckedValues("selectSchemaName")
		var isFirst=document.getElementById("isFirst").value
		var form = document.getElementById("CheckForm");
		form.target="hidderIframe";
		document.getElementById("isPass").value="notPass";
		form.action = "<%=contextPath%>/op/OpCostSrv/doCostSchemaInfo.srq";
		form.submit();
		setTimeout("closeHere()","2000");
	}
	function schemaDetail(costProjectSchemaId,projectInfoNo){
		window.open("<%=contextPath%>/op/costMangerVersion/costManagerVersionDetail.jsp?costProjectSchemaId="+costProjectSchemaId+"&projectInfoNo="+projectInfoNo);
	}
	getTab3(0);
	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="";
		selectedTabBox.style.display="none";

		selectedTagIndex = index;
		
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="selectTag";
		selectedTabBox.style.display="block";
		if(index==0){
			var obj = document.getElementById("tab_box").style;
			obj.setAttribute("height","220px");
			var table_box = document.getElementById("table_box");
			table_box.style.display="block";
		}else{
			var table_box = document.getElementById("table_box");
			table_box.style.display="none";
			
			var obj = document.getElementById("tab_box").style;
			obj.setAttribute("height","550px");

			window.setTimeout("set_height("+index+")",1);
			
		}
	}
	function set_height(index){
		var obj = document.getElementById("tab_box_content"+index).style;
		obj.setAttribute("height","550px");
	}
	function exportExcel(){
		var projectInfoNo = '<%=projectInfoNo%>';
		if(document.getElementById("projectInfoNo")==null){
			projectInfoNo = '<%=projectInfoNo%>';
		}else{
			projectInfoNo = document.getElementById("projectInfoNo").value;
		}
    	var schemaId = '<%=schemaId%>';
		var if_workflow = 0;
		if(schemaId!=null && schemaId!=''){
			if_workflow = 1;
		}
    	
    	window.open("<%=contextPath%>/op/OPCostSrv/commExportExcel.srq?export_function=exportBanlance&project_info_no="+projectInfoNo+"&key_id="+if_workflow+"&file_name=技术经济一体化论证技术方案对比");
    }
	function loadDataDetail(ids){
		var table = document.getElementById("queryRetTable");
		var cells = table.rows[22].cells;
		for(var i=0;i<cells.length;i++){
			debugger;
			cells[i].style.background="#96baf6";
			//cells[i].style.background="#ffc580";
		}
	}
</script>
</html>
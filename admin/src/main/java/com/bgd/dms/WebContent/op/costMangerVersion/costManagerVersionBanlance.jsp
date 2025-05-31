<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId=user.getEmpId();	
	String projectInfoNo = request.getParameter("projectInfoNo");
	String come=request.getParameter("come");
	boolean projectSelect=true;
	if(projectInfoNo!=null&&come==null){
		projectSelect=false;
	}
	String schemaId=request.getParameter("schemaId");
	if(schemaId==null){
		schemaId = "";
	}
	String org_subjection_id= user.getSubOrgIDofAffordOrg();
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		Cookie[] cookies=request.getCookies();
		for(Cookie i : cookies){
			if("costProjectInfoNo".equals(i.getName())){
				projectInfoNo=i.getValue();
			}
		}	
	 }
	List<Map> listProjectInfo=OPCommonUtil.getVirtualProjectInfoData(org_subjection_id);
	for(Map map:listProjectInfo){
		if(projectInfoNo==null||"".equals(projectInfoNo)){
			projectInfoNo=(String)map.get("projectInfoNo");
		}
	}
	/* List<Map> list=OPCommonUtil.getVirtualProjectInfoData(org_subjection_id);
	for(Map map:list){
		if(projectInfoNo==null||"".equals(projectInfoNo)){
			projectInfoNo=(String)map.get("projectInfoNo");
		}
	} */
	//List<Map> listSchema=OPCommonUtil.getCostVersionData(projectInfoNo);
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
  <title>技术方案对比</title>
 </head>
 <body style="background:#fff" onload="refreshData()">
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  			<tr>
					  		<% if(projectSelect){%>
							<td width="5%" class="ali3">项目:</td>
							<td width="5%" class="ali1" >
								<SELECT id="projectInfoNo" onchange="refreshData()" name="projectInfoNo">
										<%
											for (Map map : listProjectInfo) {
										%>
										<OPTION value=<%=map.get("projectInfoNo")%><% if(projectInfoNo.equals(map.get("projectInfoNo"))){%> selected="selected" <%}%>><%=map.get("projectName")%></OPTION>
										<%
											}
										%>
								</SELECT>
							</td>
							<%}%>
							<td>&nbsp;</td>
							<% if(projectSelect){%>
							<td ><font color="blue">蓝色表示领导审批通过的方案;</font><font color="red">红色表示采集直接费用最高的方案;</font>
							<font color="green">绿色表示采集直接费用最低的方案</font></td>
							<auth:ListButton functionId="" css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton>
							<%} %>
							<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="JCDP_btn_export"></auth:ListButton>
						</tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
	</div>
	<div id="table_box" style="height: 530px">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" height="500px">
			<tr>
			</tr>
		</table>
	</div>
	<div id="fenye_box" style="display: none;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		</table>
	</div>
</div>
</body>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
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
	
	function schemaDetail(costProjectSchemaId,projectInfoNo){
		window.open("<%=contextPath%>/op/costMangerVersion/costManagerVersionDetail.jsp?costProjectSchemaId="+costProjectSchemaId+"&projectInfoNo="+projectInfoNo);
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
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-8);
</script>
</html>
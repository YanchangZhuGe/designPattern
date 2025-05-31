<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null){
		project_info_no = "";
	}
	String org_subjection_id = user.getOrgSubjectionId();
	if(org_subjection_id == null){
		org_subjection_id = "";
	}
	String org_name = user.getOrgName();
	if(org_name ==null){
		org_name ="";
	}
	Date date = new Date();
	int year = date.getYear()+1900;
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#fff"  onload="refreshData('');">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">统计年份</td>
						    <td class="ali_cdn_input"><select id="year" name="year" class="select_width">
						    <% for(int i = year ; i>=2002 ; i--){%>
							       <option value="<%=i %>" ><%=i %></option>
							<% }%>
								</select></td>
			 				<td class="ali_query">
							    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
						    </td>
						    <td class="ali_query">
							    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
							</td>
						    <td>&nbsp;</td>
						    <%-- <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton> --%>
					  	</tr>
					</table>
				</td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
			<table id="module"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 10px;" >
				<tr>
					<td colspan="8" align="center"><font size="5"><strong >HSE责任书统计（板块属性）</strong></font></td>
				</tr>
				<tr>
					<td align="center"><strong >序号</strong></td>
					<td align="center"><strong >单位(<span ><a href='#' onclick=refreshData('<%=org_subjection_id %>')><font color="blue"><%=org_name %></font></a></span>)</strong></td>
					<td align="center"><strong >签订对象</strong></td>
					<td align="center"><strong >野外一线</strong></td>
					<td align="center"><strong >固定场所</strong></td>
					<td align="center"><strong >科研单位</strong></td>
					<td align="center"><strong >培训接待</strong></td>
					<td align="center"><strong >矿区</strong></td>
				</tr>
				<tr>
					<td align="center"></td>
					<td align="center"><strong >合计</strong></td>
					<td align="center"></td>
					<td align="center"><span id="module_first"></span></td>
					<td align="center"><span id="module_fixed"></span></td>
					<td align="center"><span id="module_study"></span></td>
					<td align="center"><span id="module_train"></span></td>
					<td align="center"><span id="module_mine"></span></td>
				</tr>
			</table>
			<table id="task"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 10px;" >
				<tr>
					<td colspan="7" align="center"><font size="5"><strong >HSE责任书统计（作业性质）</strong></font></td>
				</tr>
				<tr>
					<td align="center"><strong >序号</strong></td>
					<td align="center"><strong >单位(<span ><a href='#' onclick=refreshData('<%=org_subjection_id %>')><font color="blue"><%=org_name %></font></a></span>)</strong></td>
					<td align="center"><strong >签订对象</strong></td>
					<td align="center"><strong >机关管理</strong></td>
					<td align="center"><strong >二线</strong></td>
					<td align="center"><strong >野外一线</strong></td>
				</tr>
				<tr>
					<td align="center"></td>
					<td align="center"><strong >合计</strong></td>
					<td align="center"></td>
					<td align="center"><span id="task_org"></span></td>
					<td align="center"><span id="task_second"></span></td>
					<td align="center"><span id="task_first"></span></td>
				</tr>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.pageSize = 1000;
var subjection_id ='';
//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
		
	}
	
	// 复杂查询
	function refreshData(org_subjection_id){
		var retObj = jcdpCallService("HseSrv", "queryOrg", "org_subjection_id="+org_subjection_id);
		if(retObj.returnCode =='0'){
				debugger;
			if(retObj.list!=null){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag=="0"){
						org_subjection_id = "C105";
					}else{
						if(len>1){
							if(retObj.list[1].organFlag=="0"){
								org_subjection_id = retObj.list[0].orgSubId;
							}else{
								if(len>2){
									if(retObj.list[2].organFlag=="0"){
										org_subjection_id = retObj.list[1].orgSubId;
									}
								}
							}
						}
					}
				}
				
				if(len>3){
					return;
				}
			}
		}
		subjection_id = org_subjection_id;
		if(subjection_id == null || subjection_id ==''){
			subjection_id = '<%=org_subjection_id%>';
		}else{
			var autoOrder = document.getElementById("module").rows.length-1;
			for(var i =autoOrder-1 ;i>= 2 ;i--){
				document.getElementById("module").deleteRow(i);
			}
			var autoOrder = document.getElementById("task").rows.length-1;
			for(var i =autoOrder-1 ;i>= 2 ;i--){
				document.getElementById("task").deleteRow(i);
			}
		}
		//subjection_id = 'C105081';
		var year = document.getElementById("year").value;
		cruConfig.cdtType = 'form';
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/orgAndRoles/module/apanage_list.jsp";
		var queryRet = jcdpCallService("HseOperationSrv", "dutyBookSummary", "subjection_id="+subjection_id+"&year="+year);
		if(queryRet.returnCode =='0'){
			if(queryRet.datas!=null){
				for(var i =0 ;i<queryRet.datas.length ;i++){
					var data = queryRet.datas[i];
					var autoOrder = document.getElementById("module").rows.length-1;
					
					var newTR = document.getElementById("module").insertRow(autoOrder);
				    var td = newTR.insertCell(0);
				    td.innerHTML = data.rownum;
				    td.rowSpan = '2';
				    
				    var org_id = data.org_id;
				    var org_subjection_id = data.org_subjection_id;
				    var org_name = data.org_name;
				    td = newTR.insertCell(1);
				    td.innerHTML = "<span ><a href='#' onclick=refreshData('"+org_subjection_id+"')>"+org_name+"</a></span>";
					td.rowSpan = '2';
					
				    td = newTR.insertCell(2);
				    td.innerHTML = "直线主管";
				    
				    td = newTR.insertCell(3);
				    td.innerHTML = data.master_1;
				    
				    td = newTR.insertCell(4);
				    td.innerHTML = data.master_2;
				    
				    td = newTR.insertCell(5);
				    td.innerHTML = data.master_3;
				    
				    td = newTR.insertCell(6);
				    td.innerHTML = data.master_4;
				    
				    td = newTR.insertCell(7);
				    td.innerHTML = data.master_5;
				    
				    autoOrder = document.getElementById("module").rows.length-1;
				    newTR = document.getElementById("module").insertRow(autoOrder);

				    td = newTR.insertCell(0);
				    td.innerHTML = "关键岗位员工";
				    
				    td = newTR.insertCell(1);
				    td.innerHTML = data.employee_1;
				    
				    td = newTR.insertCell(2);
				    td.innerHTML = data.employee_2;
				    
				    td = newTR.insertCell(3);
				    td.innerHTML = data.employee_3;
				    
				    td = newTR.insertCell(4);
				    td.innerHTML = data.employee_4;
				    
				    td = newTR.insertCell(5);
				    td.innerHTML = data.employee_5;
				    
					autoOrder = document.getElementById("task").rows.length-1;
					
					var newTR = document.getElementById("task").insertRow(autoOrder);
				    var td = newTR.insertCell(0);
				    td.innerHTML = data.rownum;
				    td.rowSpan = '2';
				    
				    var org_id = data.org_id;
				    var org_subjection_id = data.org_subjection_id;
				    var org_name = data.org_name;
				    td = newTR.insertCell(1);
				    td.innerHTML = "<span ><a href='#' onclick=refreshData('"+org_subjection_id+"')>"+org_name+"</a></span>";
					td.rowSpan = '2';
					
				    td = newTR.insertCell(2);
				    td.innerHTML = "直线主管";
				    
				    td = newTR.insertCell(3);
				    td.innerHTML = data.task_master_1;
				    
				    td = newTR.insertCell(4);
				    td.innerHTML = data.task_master_2;
				    
				    td = newTR.insertCell(5);
				    td.innerHTML = data.task_master_3;
				    
				    
				    autoOrder = document.getElementById("task").rows.length-1;
				    newTR = document.getElementById("task").insertRow(autoOrder);

				    td = newTR.insertCell(0);
				    td.innerHTML = "关键岗位员工";
				    
				    td = newTR.insertCell(1);
				    td.innerHTML = data.task_employee_1;
				    
				    td = newTR.insertCell(2);
				    td.innerHTML = data.task_employee_2;
				    
				    td = newTR.insertCell(3);
				    td.innerHTML = data.task_employee_3;
				    
				}
				if(queryRet.data!=null){
					var map = queryRet.data;
					document.getElementById("module_first").innerHTML = map.module_1;
					document.getElementById("module_fixed").innerHTML = map.module_2;
					document.getElementById("module_study").innerHTML = map.module_3;
					document.getElementById("module_train").innerHTML = map.module_4;
					document.getElementById("module_mine").innerHTML = map.module_5;
					document.getElementById("task_org").innerHTML = map.task_1;
					document.getElementById("task_second").innerHTML = map.task_2;
					document.getElementById("task_first").innerHTML = map.task_3;
				}
			}
		}
		
		$("#table_box").css("height",$(window).height()*0.90);
	}
	function simpleSearch(){
		refreshData(subjection_id);
	}
	
</script>
</html>
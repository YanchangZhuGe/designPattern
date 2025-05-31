<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>

<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

	//String orgSubjectionId = "C105";
	//if(request.getParameter("orgSubjectionId") != null){
		//orgSubjectionId = request.getParameter("orgSubjectionId");
	//}
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = request.getParameter("projectName");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	
	if(projectName == null || "".equals(projectName)){
		projectName = user.getProjectName();
	}
	
	WorkMethodSrv wm = new WorkMethodSrv();
	String 	buildMethod = wm.getProjectExcitationMode(projectInfoNo);
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>无标题文档</title>
</head>

<body style="background:#fff;overflow: scroll;">
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="sx" event="onclick='toRefresh()'" title="重新读取计划日效"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
<form id="form1" name="form1" action="" method="post">
<table width="100%" border="1" cellspacing="1" cellpadding="0" class="tab_line_height"  id="table">
<thead>
<tr class="bt_info" align="center">
<td colspan="7">
<%=projectName %>&nbsp;&nbsp; <span id="saveflag"></span>
<input type="hidden" value="" id="deleteId" name="deleteId"/>
</td>
</tr>
<tr align="center">
<td>序号</td>
<td>日期<input type="hidden" value="0" id="rowNum" name="rowNum"/></td>

<td id="drill_td">钻井计划日效(个)</td>
<td>采集计划日效(炮)</td>
<td>备注</td>
<td>删除</td>
</tr>
</thead>
<tbody>

</tbody>
</table>
</form>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

//$(document).ready(lashen);
</script>

<script type="text/javascript">
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	var buildMethod = "<%=buildMethod%>";
	//取计划日效      gp_proj_product_plan存在计划日效则显示  ，不存在则查 bgp_p6_workload 取默认的计划日效
	var retObj = jcdpCallService("WsDailyReportPlanSrv","queryDailyPlanWs","projectInfoNo=<%=projectInfoNo %>");
	if(retObj.hasSaved == "0"){
		$("#saveflag").html("<font color='red'>计划日效未保存</font>");
	}
	var lineNum = 0;
	var editFlag = false;

	if(retObj != null && retObj.drilldailylist != null){
		//钻井
		if(lineNum <= retObj.drilldailylist.length) {
			lineNum = retObj.drilldailylist.length;
		}
	}
	if(retObj != null && retObj.colldailylist != null){
		//采集
		if(lineNum <= retObj.colldailylist.length) {
			lineNum = retObj.colldailylist.length;
		}
	}
	
	if(retObj != null && retObj.allList != null){
		//所有
		if(lineNum <= retObj.allList.length) {
			lineNum = retObj.allList.length;
		}
	}
	
	document.getElementById("rowNum").value = lineNum;
	var total_measure = 0.0;
	var total_drill = 0.0;
	var total_coll = 0.0;

	
	for(var i = 0; i < lineNum; i++){
		var tr = document.getElementById("table").insertRow();
		if ( i % 2 == 0) {
			tr.className = "even";
		} else {
			tr.className = "odd";
		}
		
		
		var measureFlag = true;
		var drillFlag = true;
		var collectFlag = true;
		
		var rowNum = i;
		var lineId = "row_" + rowNum + "_";
		tr.id=lineId;	
		
		
		//序号
		tr.insertCell().innerHTML =(i+1);
		
		//计划日期
		tr.insertCell().innerHTML = retObj.allList[i].record_month+'<input type="hidden" name="record_month_'+i+'" id="record_month_'+i+'" value="'+retObj.allList[i].record_month+'" />';
		
		
		
	
		//钻井
		if(retObj.drilldailylist == null){
			drillFlag = true;
		} else {
			for(var j = 0; j < retObj.drilldailylist.length; j++) {
				if(retObj.allList[i].record_month == retObj.drilldailylist[j].record_month){
					//20130219 改成整数四舍五入
					if(retObj.drilldailylist[j].workload == ""){
						tr.insertCell().innerHTML = '<input type = "text" value="'+retObj.drilldailylist[j].workload+'" id="drill_'+i+'" name="drill_'+i+'"/><input type="hidden" id="drill_pro_plan_id_'+i+'" name="drill_pro_plan_id_'+i+'" value="'+retObj.drilldailylist[j].pro_plan_id+'"  />';								
					}else{
						if(!isNaN(parseFloat(Math.round(retObj.drilldailylist[j].workload))) && retObj.drilldailylist[j].workload != ""){
							total_drill += parseFloat(Math.round(retObj.drilldailylist[j].workload));
						}
						tr.insertCell().innerHTML = '<input type = "text" value="'+Math.round(retObj.drilldailylist[j].workload)+'" id="drill_'+i+'" name="drill_'+i+'"/><input type="hidden" id="drill_pro_plan_id_'+i+'" name="drill_pro_plan_id_'+i+'" value="'+retObj.drilldailylist[j].pro_plan_id+'"  />';								
					}
					drillFlag = false;
				} 
			}
		}
		if(drillFlag){
			tr.insertCell().innerHTML = '<input type = "text" value="" id="drill_'+i+'" name="drill_'+i+'"/>';
		}
		
		
		//采集
		if(retObj.colldailylist ==null){
			collectFlag = true;
		} else {
			for(var j = 0; j < retObj.colldailylist.length; j++) {
				if(retObj.allList[i].record_month == retObj.colldailylist[j].record_month){
					//20130219 改成整数四舍五入
					if(retObj.colldailylist[j].workload == ""){
						tr.insertCell().innerHTML = '<input type = "text" value="'+retObj.colldailylist[j].workload+'" id="collect_'+i+'" name="collect_'+i+'"/><input type="hidden" id="coll_pro_plan_id_'+i+'" name="coll_pro_plan_id_'+i+'" value="'+retObj.colldailylist[j].pro_plan_id+'"  />';							
					}else{
						if(!isNaN(parseFloat(Math.round(retObj.colldailylist[j].workload))) && retObj.colldailylist[j].workload != ""){
							total_coll += parseFloat(Math.round(retObj.colldailylist[j].workload));
						}
						tr.insertCell().innerHTML = '<input type = "text" value="'+Math.round(retObj.colldailylist[j].workload)+'" id="collect_'+i+'" name="collect_'+i+'"/><input type="hidden" id="coll_pro_plan_id_'+i+'" name="coll_pro_plan_id_'+i+'" value="'+retObj.colldailylist[j].pro_plan_id+'"  />';							
					}
					collectFlag = false;
				}
			}
		}
		if(collectFlag){
			tr.insertCell().innerHTML = '<input type = "text" value="" id="collect_'+i+'" name="collect_'+i+'"/>';
		}
		
		//备注
		tr.insertCell().innerHTML = "&nbsp;";
		
		//删除图标
		tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
	}
	if(lineNum >0){
		var tr = document.getElementById("table").insertRow();
		tr.id = "total_value";
		if ( lineNum+1 % 2 != 0) {
			tr.className = "odd";
		} else {
			tr.className = "even";
		}
		tr.insertCell().innerHTML = "&nbsp;";
		tr.insertCell().innerHTML = "&nbsp;总计:";
		if(isNaN(total_measure)||total_measure == 0){
			total_measure = 0;
		}else{
			total_measure = total_measure.toFixed(3);
		}
		
		tr.insertCell().innerHTML = '<input type = "text" value="'+total_drill+'" id="drill_total" readonly="readonly"/>';//钻井
		tr.insertCell().innerHTML = '<input type = "text" value="'+total_coll+'" id="collect_total" readonly="readonly"/>';//采集
		//备注
		tr.insertCell().innerHTML = "&nbsp;";
		//删除图标
		tr.insertCell().innerHTML = "&nbsp;";
	}





		
	
	function toAdd(){
		if(editFlag){
			alert('请先提交当前修改!');
			return;
		}
		editFlag = true;
		popWindow('<%=contextPath%>/pm/dailyPlan/selectDate.jsp?projectInfoNo=<%=projectInfoNo %>');
	}

	function toDelete(lineId){
		var rowNum = lineId.split('_')[1];
		var line = document.getElementById(lineId);	
		
		
		//钻井
		var drillProPlanId = document.getElementById('drill_pro_plan_id_'+rowNum);
		//采集
		var collProPlanId = document.getElementById('coll_pro_plan_id_'+rowNum);
		
	
		if(drillProPlanId != null){
			//删除数据库中现有记录
			document.getElementById('deleteId').value = document.getElementById('deleteId').value + "," +drillProPlanId.value;
		}
		if(collProPlanId != null){
			//删除数据库中现有记录
			document.getElementById('deleteId').value = document.getElementById('deleteId').value + "," +collProPlanId.value;
		}
		if( drillProPlanId == null && collProPlanId == null){
			//新增行 直接删除
			line.parentNode.removeChild(line);
		} else {
			line.parentNode.removeChild(line);
		}
		lineNum--;
		document.getElementById("rowNum").value = lineNum;
		
	}

	function toSearch(){
	}
	
	function toRefresh(){
		
		if(document.getElementById("rowNum").value == 0){
			alert("尚未分配工作量!");
			return;
		}
		
		//先把之前的数据从页面删除
		$("#table > tbody tr").remove();
		
		//先删除之前的计划日效，然后重新读取
		var retObj = jcdpCallService("WsDailyReportPlanSrv","refreshDailyPlanWs","projectInfoNo=<%=projectInfoNo %>");
		var lineNum = 0;
		var editFlag = false;
		//debugger;
		
		if(retObj != null && retObj.drilldailylist != null){
			//钻井
			if(lineNum <= retObj.drilldailylist.length) {
				lineNum = retObj.drilldailylist.length;
			}
		}
		if(retObj != null && retObj.colldailylist != null){
			//采集
			if(lineNum <= retObj.colldailylist.length) {
				lineNum = retObj.colldailylist.length;
			}
		}
		
		if(retObj != null && retObj.allList != null){
			//所有
			if(lineNum <= retObj.allList.length) {
				lineNum = retObj.allList.length;
			}
		}
		
		document.getElementById("rowNum").value = lineNum;
		var total_measure = 0.0;
		var total_drill = 0.0;
		var total_coll = 0.0;
		

		for(var i = 0; i < lineNum; i++){
			var tr = document.getElementById("table").insertRow();
			if ( i % 2 == 0) {
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			
			
			var measureFlag = true;
			var drillFlag = true;
			var collectFlag = true;
			
			var rowNum = i;
			var lineId = "row_" + rowNum + "_";
			tr.id=lineId;	
			
			
			//序号
			tr.insertCell().innerHTML =(i+1);
			
			//计划日期
			tr.insertCell().innerHTML = retObj.allList[i].record_month+'<input type="hidden" name="record_month_'+i+'" id="record_month_'+i+'" value="'+retObj.allList[i].record_month+'" />';
			
			
			
			
			//钻井
			if(retObj.drilldailylist == null){
				drillFlag = true;
			} else {
				for(var j = 0; j < retObj.drilldailylist.length; j++) {
					if(retObj.allList[i].record_month == retObj.drilldailylist[j].record_month){
						//20130219 改成整数四舍五入
						if(retObj.drilldailylist[j].workload == ""){
							tr.insertCell().innerHTML = '<input type = "text" value="'+retObj.drilldailylist[j].workload+'" id="drill_'+i+'" name="drill_'+i+'"/><input type="hidden" id="drill_pro_plan_id_'+i+'" name="drill_pro_plan_id_'+i+'" value="'+retObj.drilldailylist[j].pro_plan_id+'"  />';								
						}else{
							if(!isNaN(parseFloat(Math.round(retObj.drilldailylist[j].workload))) && retObj.drilldailylist[j].workload != ""){
								total_drill += parseFloat(Math.round(retObj.drilldailylist[j].workload));
							}
							tr.insertCell().innerHTML = '<input type = "text" value="'+Math.round(retObj.drilldailylist[j].workload)+'" id="drill_'+i+'" name="drill_'+i+'"/><input type="hidden" id="drill_pro_plan_id_'+i+'" name="drill_pro_plan_id_'+i+'" value="'+retObj.drilldailylist[j].pro_plan_id+'"  />';								
						}
						drillFlag = false;
					} 
				}
			}
			if(drillFlag){
				tr.insertCell().innerHTML = '<input type = "text" value="" id="drill_'+i+'" name="drill_'+i+'"/>';
			}
			
			
			//采集
			if(retObj.colldailylist ==null){
				collectFlag = true;
			} else {
				for(var j = 0; j < retObj.colldailylist.length; j++) {
					if(retObj.allList[i].record_month == retObj.colldailylist[j].record_month){
						//20130219 改成整数四舍五入
						if(retObj.colldailylist[j].workload == ""){
							tr.insertCell().innerHTML = '<input type = "text" value="'+retObj.colldailylist[j].workload+'" id="collect_'+i+'" name="collect_'+i+'"/><input type="hidden" id="coll_pro_plan_id_'+i+'" name="coll_pro_plan_id_'+i+'" value="'+retObj.colldailylist[j].pro_plan_id+'"  />';							
						}else{
							if(!isNaN(parseFloat(Math.round(retObj.colldailylist[j].workload))) && retObj.colldailylist[j].workload != ""){
								total_coll += parseFloat(Math.round(retObj.colldailylist[j].workload));
							}
							tr.insertCell().innerHTML = '<input type = "text" value="'+Math.round(retObj.colldailylist[j].workload)+'" id="collect_'+i+'" name="collect_'+i+'"/><input type="hidden" id="coll_pro_plan_id_'+i+'" name="coll_pro_plan_id_'+i+'" value="'+retObj.colldailylist[j].pro_plan_id+'"  />';							
						}
						collectFlag = false;
					}
				}
			}
			if(collectFlag){
				tr.insertCell().innerHTML = '<input type = "text" value="" id="collect_'+i+'" name="collect_'+i+'"/>';
			}
			
			//备注
			tr.insertCell().innerHTML = "&nbsp;";
			
			//删除图标
			tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
		}
		if(lineNum >0){
			var tr = document.getElementById("table").insertRow();
			tr.id = "total_value";
			if ( lineNum+1 % 2 != 0) {
				tr.className = "odd";
			} else {
				tr.className = "even";
			}
			tr.insertCell().innerHTML = "&nbsp;";
			tr.insertCell().innerHTML = "&nbsp;总计:";
			if(isNaN(total_measure)||total_measure == 0){
				total_measure = 0;
			}else{
				total_measure = total_measure.toFixed(3);
			}
			
			
			tr.insertCell().innerHTML = '<input type = "text" value="'+total_drill+'" id="drill_total" readonly="readonly"/>';
			
			tr.insertCell().innerHTML = '<input type = "text" value="'+total_coll+'" id="collect_total" readonly="readonly"/>';
			//备注
			tr.insertCell().innerHTML = "&nbsp;";
			//删除图标
			tr.insertCell().innerHTML = "&nbsp;";
		}
		
		
		if(retObj.hasSaved == "0"){
			$("#saveflag").html("<font color='red'>计划日效未保存</font>");
		}
	}
	
	function toSubmit(){
		var form = document.form1;
		form.action="<%=contextPath%>/ws/pm/dailyPlan/saveOrUpdateDailyPlan.srq";
		form.submit();
	}
	
	function getMessage(dates){
		var start_date = dates[0];
		var end_date = dates[1];
		
		var sArr = start_date.split("-");
		sArr[1] = parseFloat(sArr[1])-1;
		var sDate = new Date(sArr[0],sArr[1],sArr[2]);
		
		var eArr = end_date.split("-");
		eArr[1] = parseFloat(eArr[1])-1;
		var eDate = new Date(eArr[0],eArr[1],eArr[2]);
		
		//alert((eDate-sDate)/(1000*3600*24)+1);
		
		var array = document.getElementsByName('order');
		
		//debugger;
		var starLine = 0;//起始order号
		var endLine = lineNum - 1;//终止order号
		var addLineNum = (eDate-sDate)/(1000*3600*24)+1;//需要添加的行数 默认为两日期之差
		
		if(array.length == 0){
			
		} else {
			var n = array[0].value;//order号
			var record_month = document.getElementById("record_month_"+n).value;
			var records = record_month.split("-");
			records[1] = parseFloat(records[1])-1;
			var record_date = new Date(records[0],records[1],records[2]);//第一条记录
			
			if(record_date>sDate){
				//添加的开始日期大于第一行日期
				starLine = 0;//从第一行开始添加
			}
			
			n = array[array.length-1].value;
			record_month = document.getElementById("record_month_"+n).value;
			records = record_month.split("-");
			record_date = new Date(records[0],records[1],records[2]);//最后一条记录
			
			if(record_date<sDate){
				//添加的开始日期大于第一行日期
				endLine = lineNum - 1;//终止order号
			}
			
			for(var i=0; i<array.length;i++){
				n = array[i].value;//order号
				record_month = document.getElementById("record_month_"+n).value;
				if(record_month == start_date){
					starLine = n;
				}
				if(record_month == end_date){
					endLine = n;
				}
			}
		}
		
		var k = 2;
		for(var i=0; i<addLineNum; i++){
			var add = sDate.getTime()+(1000*3600*24*i);
		
			//sDate.setTime(add);
			var temp = convertDate(new Date(add));
			var flag = true;
			for(var j=0;j<lineNum;j++){
				//判断该行是否新增
				record_month = document.getElementById("record_month_"+j);
				if(record_month.value == temp) {
					//不新增行
					flag = false;
					break;
				}
			}
			//debugger;
		
			if(flag){
				
				var rowNum = k+lineNum;
				var lineId = "row_" + rowNum + "_";
				
				var tr = document.getElementById("table").insertRow(k);
				tr.id=lineId;	
				if ( k % 2 == 0) {
					tr.className = "even";
				} else {
					tr.className = "odd";
				}
				//行号
				tr.insertCell().innerHTML ='新增行';
				
				//日期
				tr.insertCell().innerHTML = temp+'<input type="hidden" name="record_month_'+(k+lineNum)+'" id="record_month_'+(k+lineNum)+'" value="'+temp+'" />';
				
				//钻井
				tr.insertCell().innerHTML = '<input type = "text" value="" id="drill_'+(k+lineNum)+'" name="drill_'+(k+lineNum)+'"/>';
				
				//采集
				tr.insertCell().innerHTML = '<input type = "text" value="" id="collect_'+(k+lineNum)+'" name="collect_'+(k+lineNum)+'"/>';
				
				//备注
				tr.insertCell().innerHTML = "&nbsp;";
				
				//删除图标
				tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
				
				k = k+1
			

			}
		
		}
		lineNum = lineNum +1;
		document.getElementById("rowNum").value = lineNum+k-2;
	}
	
	
	function convertDate(date){
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		var m;
		if(month < 10){
			m = '0' + month;
		} else {
			m = month;
		}
		var day = date.getDate();
		var d;
		if(day < 10){
			d = '0' + day;
		} else {
			d = day;
		}
		var s = year + '-' +m+'-'+d;
		return s;
	}
	
</script>

</html>


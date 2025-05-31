<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = request.getParameter("org_subjection_id");
	if(org_subjection_id ==null){
		org_subjection_id = user.getSubOrgIDofAffordOrg();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript">
	var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="table_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
		</table>
	</div>
</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_id = "";
	var file_name="";	
	// 复杂查询
	function refreshData(){
		var sql = " select eps.org_abbreviation org_name ,eps.org_id ,os.org_subjection_id from bgp_comm_org_wtc eps"+
		" join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0'"+
		" where eps.bsflag ='0' order by eps.order_num";
		var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+'&pageSize='+cruConfig.pageSizeMax);
		if(retObj!=null && retObj.returnCode=='0'){
			var queryRetTable = document.getElementById("queryRetTable");
			var k = 0 ;
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				if(retObj.datas[i]==null){
					changeTable("queryRetTable");
					break;
				}
				var data = retObj.datas[i];
				var org_name = data.org_name;
				var org_subjection_id = data.org_subjection_id;
				
				var tr_2 = queryRetTable.insertRow(k);
				var td_2 = tr_2.insertCell(0);
				td_2.innerHTML = "<a href='#' onclick=getDetail('queryRetTable','"+org_subjection_id+"')><font color='blue'>"+org_name+"</font></a>" ;
				
				i++;
				if(retObj.datas[i]==null){
					td_2 = tr_2.insertCell(1);
					td_2.innerHTML = "" ;
					
					changeTable("queryRetTable");
					break;
				}
				data = retObj.datas[i];
				org_name = data.org_name;
				org_subjection_id = data.org_subjection_id;
				td_2 = tr_2.insertCell(1);
				td_2.innerHTML = "<a href='#' onclick=getDetail('queryRetTable','"+org_subjection_id+"')><font color='blue'>"+org_name+"</font></a>" ;

				k++;
				changeTable("queryRetTable");
			}
		}
	}
	refreshData();
	function getDetail(company ,org_subjection_id){
		popWindow(cruConfig.contextPath + "/qua/dashboard/multiple/audit_wtc.jsp?org_subjection_id="+org_subjection_id,null,'内审计划');
	}
	function changeTable(table_name){
		var table = document.getElementById(table_name);
		for(var i =0 ;i<table.rows.length;i++){
			var tr = table.rows[i];
			for(var j =0 ;j< tr.cells.length;j++){
				if(i%2==0){
					tr.cells[j].align ='center';
					if(j%2==1) tr.cells[j].style.background = "#FFFFFF";
					else tr.cells[j].style.background = "#f6f6f6";
				}else{
					tr.cells[j].align ='center';
					if(j%2==1) tr.cells[j].style.background = "#ebebeb";
					else tr.cells[j].style.background = "#e3e3e3";
				}
			}
		}
	}
	function loadDataDetail(id){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase() =='td'){
			obj.parentNode.cells[0].firstChild.checked = 'checked';
		}
	}
</script>
</body>
</html>
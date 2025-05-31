<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String accident_id = request.getParameter("accident_id");
	if(accident_id ==null){
		accident_id = "";
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
<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}else{
			checked = true;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff;overflow-y: auto" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <%-- <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> --%>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{report_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)' /></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{report_org}">单位名称</td>
			  <td class="bt_info_even" exp="{accident_org}">事故发生单位</td>
			  <td class="bt_info_odd" exp="{accident_date}">事故发生时间</td>
			  <td class="bt_info_even" exp="{accident_loss}">预计直接经济损失(万元)</td>
			  <td class="bt_info_odd" exp="{reporter_id}">报告人</td>
			  <td class="bt_info_even" exp="<a href='#' onclick=reportShow('{report_id}')><font color='blue'>报表</font></a>">报表</td>
			</tr>
		</table>
	</div> 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getAccidentReport";
	function refreshData(){
		var id = '<%=accident_id%>';
		cruConfig.pageSize = cruConfig.pageSizeMax;
		cruConfig.submitStr = "accident_id="+id;
		queryData(1);
		resizeNewTitleTable();
	}
	refreshData();
	function loadDataDetail(){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase() =='td'){
			var tr = obj.parentNode;
			tr.cells[0].firstChild.checked = 'checked';
		}
	}
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function toAdd() {
		var id = '<%=accident_id%>';
		popWindow("<%=contextPath%>/qua/sProject/accident/reportEdit.jsp?accident_id="+id);
	}
	function toEdit() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var report_id = '';
		var id = '<%=accident_id%>';
		for (var i = 1;i<= objLen-1 ;i++){   
		    if (obj [i].checked==true) { 
		    	report_id=obj [i].value;
				popWindow("<%=contextPath%>/qua/sProject/accident/reportEdit.jsp?accident_id="+id+"&report_id="+report_id);
				return;
		  	}   
		} 
		alert("请选择修改的记录!")
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var report_id = '';
		var substr = '';
		if(window.confirm("你确定要删除?")){
			for (var i = objLen-1 ;i > 0 ;i--){  
				if (obj [i].checked==true) { 
					report_id=obj [i].value;
					var sql = "update bgp_qua_accident_report t set t.bsflag = '1' where t.report_id='"+report_id+"';";
					substr = substr + sql;
				}
			}
			var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+substr);
			if(retObj!=null && retObj.returnCode =='0'){
				alert("删除成功!");
			}
		} 
		refreshData();
	}
	function reportShow(report_id){
		popWindow('<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=qua_accident&noLogin=admin&tokenId=admin&KeyId='+report_id);
	}
	function renderNaviTable(tbObj,tbCfg){
	}
</script>

</body>
</html>

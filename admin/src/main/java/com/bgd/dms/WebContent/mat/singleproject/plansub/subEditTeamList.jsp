<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
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
</script>
<title>列表页面</title>
</head>
<body style="background:#fff; overflow:scroll;" onload='refreshData()'>
	<form name="form1" id="form1" method="post" action="">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'plan_id_{plan_detail_id}' id='rdo_entity_id' checked='checked'type='checkbox' value='{plan_detail_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{coding_name}">班组</td>
			      <td class="bt_info_even" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_odd" exp="{demand_num}">需求数量</td>
			      <td class="bt_info_even" exp="<input name='approve_num_{plan_detail_id}'  type='text' value='{approve_num}'/>">审批数量</td>
			      <td class="bt_info_odd" exp="{demand_date}">需求日期</td>
			    </tr>
			  </table>
			</div>
			<table  id="fenye_box_table">
			</table>
			</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	 var planInvoiceId = getQueryString("planInvoiceId");
	 function refreshData(){
	    	cruConfig.queryService = "MatItemSrv";
	    	cruConfig.queryOp = "getSubTeamLeaf";
			cruConfig.submitStr ="planInvoiceId="+planInvoiceId;
			//setTabBoxHeight();
			//$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box_table").height()-30);
			queryData(1);
		}
	function toSubmit(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    var values = '';
	    var tab =document.getElementById("queryRetTable");
	    var row = tab.rows;
	    for(var i=1;i<row.length;i++){
		    if(row[i].cells[0].firstChild.checked){
			    if(row[i].cells[0].firstChild.value !=null){
				    if(values == ''){
					    
				    	values= row[i].cells[0].firstChild.value+":"+row[i].cells[5].firstChild.value;
				    }else{
				    	values = values +','+ row[i].cells[0].firstChild.value+":"+row[i].cells[5].firstChild.value;
				    }
				    }
			}
	    }
	    var retObj = jcdpCallService("MatItemSrv", "saveTeamList", "planDetailId="+values);
	    
	    if(retObj.returnCode=='0'){
	    	alert("提交成功!");
	    	parent.refreshData();
		}else{
			alert("提交失败!");
		}
	}
</script>
</html>

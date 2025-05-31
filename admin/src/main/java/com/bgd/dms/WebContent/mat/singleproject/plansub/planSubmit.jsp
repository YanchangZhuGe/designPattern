<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>物资汇总编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload="refreshData()" class="odd_odd" style="overflow: visible;">
<form name="form1" id="form1" method="post" action="">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">

  	<tr>
    	<td colspan="4" align="center">送审计划编辑</td>
    </tr>
    <tr>
    	
    	<td class="inquire_item4">申请单号：</td>
      	<td class="inquire_form4"><input type="text" name="submite_number" id="submite_number" class="input_width" value="" readonly/></td>
      	<td class="inquire_item4">创建人：</td>
      	<td class="inquire_form4"><input type="text" name="creator_id" id="creator_id" class="input_width" value="" readonly/></td>
    </tr>
</table>
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td  align="left">汇总信息</td>
			</tr>
		</table>
		</td>
		<td width="4"><img src="<%=contextPath%>/images/list_17.png"
			width="4" height="36" /></td>
	</tr>
</table>
</div>
<div id="list_table">
<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'plan_id_{plan_id}' id='rdo_entity_id' type='checkbox' checked='checked' value='{plan_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{demand_num}">需求数量</td>
			      <td class="bt_info_odd" exp="{wz_price}">参考单价</td>
			      <td class="bt_info_even" exp="{have_num}">现有数量</td>
			      <td class="bt_info_odd" exp="{regulate_num}">可调剂数量</td>
			      <td class="bt_info_even" exp="{apply_num}">合计申请量</td>
			      <td class="bt_info_odd" exp="{plan_money}">计划金额</td>
			      <td class="bt_info_even" exp="{description}">物资说明</td>
			      <td class="bt_info_odd" exp="{code_name}">物资类别</td>
			    </tr>
			  </table>
			</div>
			<table  id="fenye_box_table">
			</table>
			</div>
    <div id="oper_div">
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
<td>
<span class="tj_btn"><a href="#"onclick="save()"></a></span> 
<span class="gb_btn"><a href="#"onclick="newClose()"></a></span>
</td>
</tr>
</table>
</td>
</tr>
</table>
</div>
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getPlanEdit";
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
	function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }
    var planInvoiceId = getQueryString("planInvoiceId");
    function refreshData(){
		cruConfig.submitStr ="planInvoiceId="+planInvoiceId;
		resizeNewTitleTable();
		queryData(1);
		showTitle(planInvoiceId);
	}
    function showTitle(value){
    	var retObj = jcdpCallService("MatItemSrv", "getplan", "laborId="+value);
    	document.getElementById("submite_number").value = retObj.matInfo.submiteNumber;
    	document.getElementById("creator_id").value = retObj.matInfo.userName;
        }
	function save(){
	    document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plansub/planSubmit.srq?matId="+planInvoiceId;
		document.getElementById("form1").submit();
	}
	/* 计算详细标签的大小，并可以改变大小 */
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

</script>
</html>
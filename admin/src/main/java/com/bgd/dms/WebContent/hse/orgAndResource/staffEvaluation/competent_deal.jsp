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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_evaluation_id = request.getParameter("hse_evaluation_id");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>新建项目</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body style="background:#fff"  onload="refreshData()">
<input type="hidden" id="hse_evaluation_id" name="hse_evaluation_id" value="<%=hse_evaluation_id %>"/>
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="bc" event="onclick='toUpdate()'" title="保存"></auth:ListButton>
			    <%-- <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton> --%>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
	    	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr >
			      	<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{hse_evaluation_staff}' onclick='loadDataDetail();'/>" >选择</td>
			     	<td class="bt_info_even" autoOrder="1">序号</td> 
			      	<td class="bt_info_odd" exp="<input type='text' name='staff_name' value='{staff_name}' class='input_width'/>">被评价人</td>
			      	<td class="bt_info_even" exp="{competent_deal}">不胜任情况的处置</td>
			      	<%-- <td class="bt_info_even" exp="<select name='competent_deal' class='select_width' ><option value='0' >请选择</option><option value='1' >再培训</option><option value='2' >调岗</option><option value='3' >离岗</option></select>">不胜任情况的处置</td> --%>
			    </tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
				    <td align="right">第1/1页，共0条记录</td>
				    <td width="10">&nbsp;</td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				    <td width="50">到 
				      <label>
				        <input type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			    </tr>
			</table>
		</div>
	</div>
</body>

<script type="text/javascript">
var hse_evaluation_id = '<%=hse_evaluation_id%>';
cruConfig.contextPath =  "<%=contextPath%>";
function frameSize(){
	setTabBoxHeight();
	
}
frameSize();
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}
//复杂查询
function refreshData(){
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "select s.hse_evaluation_staff, s.staff_name, " +
	" case s.competent_deal when '1' then '<select name=competent_deal class=select_width ><option value=0 >请选择</option><option value=1 selected=selected>再培训</option><option value=2 >调岗</option><option value=3 >离岗</option></select>'"+
						  " when '2' then '<select name=competent_deal class=select_width ><option value=0 >请选择</option><option value=1 >再培训</option><option value=2 selected=selected>调岗</option><option value=3 >离岗</option></select>'"+
	                      " when '3' then '<select name=competent_deal class=select_width ><option value=0 >请选择</option><option value=1 >再培训</option><option value=2 >调岗</option><option value=3 selected=selected>离岗</option></select>'"+
	                               " else '<select name=competent_deal class=select_width ><option value=0 >请选择</option><option value=1 >再培训</option><option value=2 >调岗</option><option value=3 >离岗</option></select>' end competent_deal"+
	" from bgp_hse_evaluation t"+
	" join bgp_hse_evaluation_staff s on t.hse_evaluation_id = s.hse_evaluation_id and s.bsflag='0'"+
	" where t.bsflag='0' and s.competent ='0' and t.hse_evaluation_id ='"+hse_evaluation_id+"'";
	cruConfig.currentPageUrl = "<%=contextPath%>/hse/orgAndResource/staffEvaluation/competent_deal.jsp";
	queryData(1);
}

function toUpdate(){  
	if(checkText0()){
		return;
	}
} 

function checkText0(){
	var obj = document.getElementById("queryRetTable");
	var autoOrder = obj.rows.length;
	if(cruConfig.totalRows<10){
		autoOrder = cruConfig.totalRows
	}
	
	var substr = "";
	for(var i=1;i<= autoOrder; i++){
		var tr = obj.rows[i];
		var hse_evaluation_staff = tr.cells[0].firstChild.value;
		var staff_name = tr.cells[2].firstChild.value;
		var competent_deal = tr.cells[3].firstChild.value;
		if(staff_name==""){
			alert("被评价人不能为空，请填写!");
			return true;
		}
		if(competent_deal=="0"){
			alert("不胜任情况的处置不能为空，请选择!");
			return true;
		}
		substr = substr + "update bgp_hse_evaluation_staff t set t.staff_name='"+staff_name+"' ,t.competent_deal='"+competent_deal+"' where t.hse_evaluation_staff='"+hse_evaluation_staff+"';";
	}
	if(window.confirm("您确定的保存修改?")){
		var obj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+substr);
	}
	return false;
}




</script>
</html>
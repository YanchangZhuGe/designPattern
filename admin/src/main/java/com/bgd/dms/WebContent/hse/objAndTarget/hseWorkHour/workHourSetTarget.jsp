<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubjectionId = user.getOrgSubjectionId();
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
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
<body >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_target_id" name="hse_target_id" value=""/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
		<table id="hourTable" width="100%" border="1" bordercolor="black" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
		     <tr align="center">
		     	<td colspan="4"><span style="font-size: 28px;font-family: Arial;float: center;padding-top: 11px;margin-bottom: 30px;">设置接团指标</span></td>
			  </tr>
		     <tr align="center">
		     	<td ></td>
		      	<td >百万工时可记录事件人数发生率</td>
		      	<td >百万工时损工伤亡发生率</td>
			    <td >百万工时死亡率</td>
			  </tr>
			  <tr align="center">
			  	<td>集团指标</td>
			  	<td><input type="text" id="record_percent" name="record_percent" value=""></input></td>
			  	<td><input type="text" id="injure_percent" name="injure_percent" value=""></input></td>
			  	<td><input type="text" id="die_percent" name="die_percent" value=""></input></td>
			  </tr>
		</table>
		</div>
	<div id="oper_div">
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
toEdit();
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
	
}

function submitButton(){
	
	var record_percent = document.getElementById("record_percent").value;
	var injure_percent = document.getElementById("injure_percent").value;
	var die_percent = document.getElementById("die_percent").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
	
	if(record_percent!=""){
		if (!re.test(record_percent)){
		       alert("百万工时可记录事件人数发生率请输入数字！");
		       return;
		}
	}
	if(injure_percent!=""){
		if (!re.test(injure_percent)){
		       alert("百万工时损工伤亡发生率请输入数字！");
		       return;
		}
	}
	if(die_percent!=""){
		if (!re.test(die_percent)){
		       alert("百万工时死亡率请输入数字！");
		       return;
		}
		}
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/workhour/hourSetTarget.srq";
	form.submit();
}

 


	function toEdit(){ 
		var checkSql="select * from bgp_hse_workhour_target where bsflag = '0'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
			
		}else{
			document.getElementById("hse_target_id").value = datas[0].hse_target_id;
			document.getElementById("record_percent").value = datas[0].record_percent;
			document.getElementById("injure_percent").value = datas[0].injure_percent;
			document.getElementById("die_percent").value = datas[0].die_percent;
		}
	} 



</script>
</html>
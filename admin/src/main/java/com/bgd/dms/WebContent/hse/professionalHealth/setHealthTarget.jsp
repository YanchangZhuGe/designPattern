<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

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
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
</head>
<body>
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_target_id" name="hse_target_id" value=""/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
				     <tr align="center">
				    	<td align="right" style="width: 30%;">职业健康体检率集团指标：</td>
				      	<td align="left" style="width: 70%;"><input type="text" id="health_target" name="health_target" class="input_width"   value=""/></td>
				     </tr>
				     <tr align="center">
				    	<td align="right" style="width: 30%;">职业病危害作业场所体检率集团指标：</td>
				      	<td align="left" style="width: 70%;"><input type="text" id="places_target" name="places_target" class="input_width"   value=""/></td>
				     </tr>
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
toEdit();

function submitButton(){
	var form = document.getElementById("form");
		if(checkText()){
			return;
		}
	form.action="<%=contextPath%>/hse/yxControl/saveHealthTarget.srq";
	form.submit();
}

function closeButton(){
	newClose();
}

function checkText(){
	var health_target = document.getElementById("health_target").value;
	var places_target = document.getElementById("health_target").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
	if(health_target!=""){
	    if (!re.test(health_target)){
	       alert("请输入数字！");
	       return true;
	    }
	}
	if(places_target!=""){
	    if (!re.test(places_target)){
	       alert("请输入数字！");
	       return true;
	    }
	}
	return false;
}

function toEdit(){
	var checkSql = "select * from bgp_hse_health_target where bsflag='0'";
	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	debugger;
	if(datas==null||datas==""){
	}else{
		document.getElementById("health_target").value=datas[0].health_target;
		document.getElementById("places_target").value=datas[0].places_target;
		document.getElementById("hse_target_id").value=datas[0].hse_target_id;
	}
}

</script>
</html>
<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%
response.setContentType("text/html;charset=utf-8");
  response.setHeader("Pragma","No-cache"); 
  response.setHeader("Cache-Control","no-cache"); 
  response.setDateHeader("Expires", 0);
  String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<title>无标题文档</title>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
	function viewProcessInfo(){
		window.parent.document.getElementById("list").src="<%=contextPath%>"+"/bpm/common/toGetSelfProcessList.srq";
	}
	
	$(function(){
		setTime();
		setInterval("setTime()",1000);
		setProcNums();
	});
	
	//时间日期
	function setTime(){
		var MyDate=new Date();
		var year = MyDate.getFullYear();
		var month = MyDate.getMonth();
		var day = MyDate.getDate();
		var hour = MyDate.getHours();
		var minute = MyDate.getMinutes();
		var second = MyDate.getSeconds();
		var text = year+"-"+(month+1)+"-"+day+" "+hour+":" +minute+":"+second;
	
		$('#a1').html(text);
	}
	
	function setProcNums(){
		retObj = jcdpCallService("WFCommonSrv", "getWFProcessList", "");
		$("#procSize").html("有"+retObj.totalRows+"流程待审批");
	}
</script>
<style type="text/css">
/*ul li{
	background: url(<%=contextPath%>/images/bg_white.png) no-repeat; 
	width: 217px; 
	height: 34px;
	text-align: left;
	display: inline;
	padding-left: 15px;
	padding-top: 2px;
}
ul li a{
	display: block;
	height: 100%;
	width: 200px;
	color: white;
	font-size: 18px;
	padding-left: 30px;
	padding-top: 3px;
}*/
#footbar{
    height:34px;
    line-height:34px;
    color:#9b9b9b;
    width:910px;
    overflow:hidden;
    margin:0px;
    padding:0px;
    text-align:center;
}
#footbar li {
    list-style-type:none;
    float:left;
    padding-left:10px;
    background: url(<%=contextPath%>/images/bg_white.png) no-repeat; 
    width: 217px; 
    height:34px;
}

#footbar a{
    height:34px;
    display:inline;
    float:left;
    padding-left: 30px;
    padding-right: 15px;
    text-decoration: none;
    color:#fff;
    font-size:16px;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
}
body{
	text-align: center;
}
</style>
</head>

<body>
<div class="foot_bg">
  <div id="foot" align="center">
  	<ul id="footbar">
  		<li><a id="a1" style="background: url(<%=contextPath%>/images/clock.png) no-repeat;"></a></li>
  		<li><a style="background: url(<%=contextPath%>/images/sun.png) no-repeat;" target="_blank" href="http://www.cnpc/gsxx/gsjs/Pages/tqyb.aspx">北京，晴，35~22℃</a></li>
  		<li><a style="background: url(<%=contextPath%>/images/icon3.png) no-repeat;">有新日报</a></li>
  		<li><a id="procSize" style="background: url(<%=contextPath%>/images/icon4.png) no-repeat;" onclick="viewProcessInfo()">有条流程待审批</a></li>
  	</ul>
  </div>
</div>
</body>
</html>

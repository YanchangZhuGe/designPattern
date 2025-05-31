<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
	
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.messager.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
<title>角标</title>
</head>
<body style="background: #cdddef; overflow-y: auto"  onload="loadTable()">
</body>
<!-- 右下角弹窗 -->
<style>
.lightbox{width:330px;
background:#FFFFFF;
border:#FFCC00 3px solid;
line-height:20px;
display:none; 
margin:0;}
.lightbox dt{background:#FFCC00;
padding:5px;}
.lightbox dd{padding:30px; 
margin:0;}
</style>
<!-- 右下角弹窗 -->
<input type="button" value=" 右下角弹窗效果 " id="idBoxOpen2" style="display:none;"/>
	<dl id="idBox2" class="lightbox">
	<dt><b>工作提醒消息</b><input align="right" type="button" value="关闭" id="idBoxClose2" />
	</dt>
	<dd>
		<a href="####" onclick='remind(0)' />
			<font id="font" color=red><u><div id = "showCount" ></div></u></font></a>
		<a href="####" onclick='remind(1)' />
			<font id="font4" color=red><u><div id = "showRecvCount" ></div></u></font></a>
		<a href="<%=contextPath %>/rm/dm/deviceAccount/devAccSyncIndex.jsp" />
			<font id="font1" color=red><u><div id = "showAddCount" ></div></u></font></a>
		<a href="<%=contextPath %>/rm/dm/EqDevOutForm/EqDevOutBaseInfoList.jsp" />
			<font id="font2" color=red><u><div id = "showMixCount" ></div></u></font></a>
		<a href="<%=contextPath %>/rm/dm/collDevOutForm/collDevOutBaseInfoList.jsp" />
			<font id="font3" color=red><u><div id = "showCollCount" ></div></u></font></a>
		<a href="####" onclick='remind(2)'/>
			<font id="font5" color=red><u><div id = "showRcjcOutTimeCount" ></div></u></font></a>
	</dd>	
	</dl>
<script>
function loadTable(suborg,account_stat){
	$$('idBoxOpen2').click();
}
(function(){
	//消息闪烁提醒
	var SLEEP = 500;
	font.INTERVAL = setInterval (function (){
		(typeof font.index) === 'undefined' ? font.index = 0 : font.index++;
			  font.color = [
			            'red', 'black'
			  ][font.index % 2];
		    }, SLEEP);
	font1.INTERVAL = setInterval (function (){
		(typeof font1.index) === 'undefined' ? font1.index = 0 : font1.index++;
			  font1.color = [
			            'red', 'black'
			  ][font1.index % 2];
		    }, SLEEP);
	font2.INTERVAL = setInterval (function (){
		(typeof font2.index) === 'undefined' ? font2.index = 0 : font2.index++;
			  font2.color = [
			            'red', 'black'
			  ][font2.index % 2];
		    }, SLEEP);
	font3.INTERVAL = setInterval (function (){
		(typeof font3.index) === 'undefined' ? font3.index = 0 : font3.index++;
			  font3.color = [
			            'red', 'black'
			  ][font3.index % 2];
		    }, SLEEP);
	font4.INTERVAL = setInterval (function (){
		(typeof font4.index) === 'undefined' ? font4.index = 0 : font4.index++;
			  font4.color = [
			            'red', 'black'
			  ][font4.index % 2];
		    }, SLEEP);
	font5.INTERVAL = setInterval (function (){
		(typeof font5.index) === 'undefined' ? font5.index = 0 : font5.index++;
			  font5.color = [
			            'red', 'black'
			  ][font5.index % 2];
		    }, SLEEP);
	//右下角消息框
	var timer, target, current,
		ab = new AlertBox( "idBox2", { fixed: true,
			onShow: function(){
				clearTimeout(timer); this.box.style.bottom = this.box.style.right = 0;
			},
			onClose: function(){ clearTimeout(timer); }
		});

	function hide(){
		ab.box.style.bottom = --current + "px";
		if( current <= target ){
			ab.close();
		} else {
			timer = setTimeout( hide, 10 );
		}
	}

	$$("idBoxClose2").onclick = function(){
		target = -ab.box.offsetHeight; current = 0; hide();
	};
	$$("idBoxOpen2").onclick = function(){ 
	    	document.getElementById("showCount").innerText="您有（1）个项目未进行返还!";
	    	ab.show();
	    	document.getElementById("showRecvCount").innerText="您有（2）个项目存在未接收的设备!";
	    	ab.show();
	    	document.getElementById("showAddCount").innerText="您有（4）台已转资但未同步设备!";
	    	ab.show();
	    	document.getElementById("showMixCount").innerText="您有（5）条设备出库(装备按台)单据未处理!";
	    	ab.show();
	    	document.getElementById("showCollCount").innerText="您有（6）条设备出库(装备按量)单据未处理!";
	    	ab.show();
	    	document.getElementById("showRcjcOutTimeCount").innerText="您有（7）条设备超期未做日常检查!";
	    	ab.show();
	};
})()
function remind(str){
	if(str == '0'){
		popWindow('<%=contextPath%>/rm/dm/panel/devcieHireList.jsp','980:520','-设备未返还项目列表');
	}else if(str == '1'){
		popWindow('<%=contextPath%>/rm/dm/panel/devcieRecvList.jsp','980:520','-设备未接收项目列表');
	}else if(str == '2'){
		popWindow('<%=contextPath %>/rm/dm/panel/devRcjcOutTimeInfo.jsp','980:520','-日常检查超期列表');
	}
}
</script>
</html>
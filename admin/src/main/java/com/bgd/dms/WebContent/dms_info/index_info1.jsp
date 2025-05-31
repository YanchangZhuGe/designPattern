<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
  UserToken user = OMSMVCUtil.getUserToken(request);
  if(user==null){
	  request.getRequestDispatcher("login.jsp").forward(request, response);
	  return;
  }
  response.setContentType("text/html;charset=utf-8");
  String contextPath = request.getContextPath();
  String orgsubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.messager.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
 
<title>设备寿命周期管理平台-综合物化探</title>
<style type="text/css">
	html,body { height:100%; margin:0; overflow-y:hidden;}
</style>
<script type="text/javascript"> 

</script>   
</head>
<body onload = "loadTable()">

<table width="100%" height="100%" cellpadding="0" cellspacing="0" >
  <tr valign="top">
  	<td width="9%"  id='aaa' style="height:100%"> 
  		<iframe id="navFrame" name="navFrame" title="" width="100%"  height="100%"  frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/ibp/auth2/dmsCollMenu.srq"></iframe>
  	</td>
  	<td width="73%"  id='bbb' style="height:100%;">
  		<iframe id="list" name="list" title="" width="100%" height="100%" frameborder="0" src="<%=request.getContextPath()%>/dms_info/content.jsp"></iframe>
  	</td>
  	<td width="18%"  id='ccc' style="height:100%;">
  		<iframe id="list" name="leftMenuFrame" title="" width="100%" height="754" frameborder="0" src="<%=request.getContextPath()%>/common/index/dmsMenu.srq"></iframe>
  	</td>
  </tr>
  </table>
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
<input type="button" value="右下角弹窗效果 " id="idBoxOpen2"  style="display:none;"/>
<dl id="idBox2" class="lightbox">
	<dt><b>工作提醒消息</b><input align="right" type="button" value="关闭" id="idBoxClose2" /></dt>
	<dd>
		<a href="####" onclick='remind(0)' />
			<font id="font" color=red><u><div id="showCount"></div></u></font></a>
		<a href="####" onclick='remind(1)' />
			<font id="font2" color=red><u><div id="showZBCount"></div></u></font></a>
		<a href="####" onclick='remind(2)' />
			<font id="font5" color=red><u><div id="showRecvCount"></div></u></font></a>
		<a href="####" onclick='remind(3)' />
			<font id="font6" color=red><u><div id="showZBRecvCount"></div></u></font></a>
		<a href="<%=contextPath %>/rm/dm/deviceAccount/devAccSyncIndex.jsp" />
			<font id="font1" color=red><u><div id="showAddCount"></div></u></font></a>
		<a href="####" onclick='remind(4)' />
			<font id="font2" color=red><u><div id = "showMixCount" ></div></u></font></a>
		<a href="####" onclick='remind(5)' />
			<font id="font4" color=red><u><div id="showCollCount"></div></u></font></a>
		<a href="####" onclick='remind(7)'/>
			<font id="font7" color=red><u><div id = "showScrapeApplyCount" ></div></u></font></a>
	</dd>
</dl>
<script>
function loadTable(){
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
	font6.INTERVAL = setInterval (function (){
		(typeof font6.index) === 'undefined' ? font6.index = 0 : font6.index++;
			  font6.color = [
			            'red', 'black'
			  ][font6.index % 2];
		    }, SLEEP);
	font7.INTERVAL = setInterval (function (){
		(typeof font7.index) === 'undefined' ? font7.index = 0 : font7.index++;
			  font7.color = [
			            'red', 'black'
			  ][font7.index % 2];
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
	}
	$$("idBoxOpen2").onclick = function(){
		var obj = jcdpCallService("DevCommRemind", "getDeviceHireProjectCount","orgSubId=<%=orgsubId %>");
		var str = obj.procount;
		
		if(str !="0" && str !=""){
		    document.getElementById("showCount").innerText="您有（"+str+"）个项目未进行设备返还!";
		    ab.show();
		}
		var noRecvObj = jcdpCallService("DevCommRemind", "getDevNoRecvProjectCount","orgSubId=<%=orgsubId %>");
		var recvcount = noRecvObj.procount;
		if(recvcount !="0" && recvcount !=""){
		    document.getElementById("showRecvCount").innerText="您有（"+recvcount+"）个项目存在未接收的设备!";
		    ab.show();
		}
	    
	    var dataEntity = jcdpCallService("DevCommRemind", "getDeviceSynsCount","orgSubId=<%=orgsubId %>");
	    var count = dataEntity.count;
	    if(count != "0" && count != ""){ 
	    	document.getElementById("showAddCount").innerText="您有（"+count+"）台已转资但未同步设备!";
	    	ab.show();	
	    }
	  //相关专家查询报废申请列表信息是否有待办信息
		var retObj = jcdpCallService("ScrapeSrvNew", "getScrapeInfoByEmployee", "");
		if(retObj.num>0){
			document.getElementById("showScrapeApplyCount").innerText="您有（"+retObj.num+"）条报废申请单单据未处理!";
	    	ab.show();
	    }
	}
	getFusionChart();
})()
function remind(str){
	if(str == '0'){
		popWindow('<%=contextPath%>/rm/dm/panel/devcieHireList.jsp','980:520','-设备未返还项目列表');
	}else if(str == '2'){
		popWindow('<%=contextPath%>/rm/dm/panel/devcieRecvList.jsp','980:520','-设备未接收项目列表');
	}else if(str == '3'){
		popWindow('<%=contextPath%>/rm/dm/panel/devcieRecvZBList.jsp','980:520','-设备未返还项目列表');
	}else if(str == '4'){
		popWindow('<%=contextPath %>/rm/dm/panel/devEqOutList.jsp?opr_state=0','980:520','-设备出库(装备单台)未处理单据列表');
	}else if(str == '5'){
		popWindow('<%=contextPath %>/rm/dm/panel/devCollOutList.jsp?opr_state=0','980:520','-设备出库(装备按量)未处理单据列表');
	}else if(str == '7'){
		popWindow('<%=contextPath %>/dmsManager/scrape/scrapeApplyListForEmp.jsp','980:520','申请单查询');
	}else{//装备服务处设备未返还的项目
		popWindow('<%=contextPath%>/rm/dm/panel/devcieHireZBList.jsp','980:520','-设备未接收项目列表');
	}
}
</script>
</html>
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
  String userId = user.getEmpId();
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
 
<title>设备寿命周期管理平台-装备服务处</title>
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
.lightbox{width:330px;background:#FFFFFF;border:#FFCC00 3px solid;line-height:20px;display:none; margin:0;}
.lightbox dt{background:#FFCC00;padding:5px;}
.lightbox dd{padding:30px; margin:0;}
</style>
<!-- 右下角弹窗 -->

<script type="text/javascript">
	function showWindowSize(){
		var img = document.getElementsByName('imgId');
		for(var i=0;i<5;i++){
		img[i].width=document.body.clientWidth;
		alert(document.body.clientWidth+"+"+document.body.clientHeight);
		img[i].height=document.body.clientHeight;
		}
	}

	function setEarthFrame(){
		$("earthFrame").height=document.body.clientHeight-60;
	}
	
	
</script>
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
		<a href="####" onclick='remind(4)'/>
			<font id="font2" color=red><u><div id = "showMixCount" ></div></u></font>
		<a href="####" onclick='remind(5)'/>
			<font id="font3" color=red><u><div id = "showCollCount" ></div></u></font>
		<a href="####" onclick='remind(3)'/>
			<font id="font6" color=red><u><div id = "showYzjlOutTimeCount" ></div></u></font></a>
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
	};
	$$("idBoxOpen2").onclick = function(){ 
	    var obj = jcdpCallService("DevCommRemind", "getDeviceHireProjectCount","orgSubId=<%=orgsubId %>");
	    var str = obj.procount;
	    if(str !="0" && str !=""){
	    	document.getElementById("showCount").innerText="您有（"+str+"）个项目未进行返还!";
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
	    if(count !="0" && count !=""){
	    	document.getElementById("showAddCount").innerText="您有（"+count+"）台已转资但未同步设备!";
	    	ab.show();
	    }
	    var dataUnCount = jcdpCallService("DevCommRemind", "getZBDevOutUntreCount","orgSubId=<%=orgsubId %>");
	    var mixcount = dataUnCount.mixcount;
	    if(mixcount !="0" && mixcount !=""){
	    	document.getElementById("showMixCount").innerText="您有（"+mixcount+"）条设备出库(装备按台)单据未处理!";
	    	ab.show();
	    }
	    var dataCollCount = jcdpCallService("DevCommRemind", "getZBCollOutUntreCount","orgSubId=<%=orgsubId %>");
	    var mixcollcount = dataCollCount.mixcollcount;
	    if(mixcollcount !="0" && mixcollcount !=""){
	    	document.getElementById("showCollCount").innerText="您有（"+mixcollcount+"）条设备出库(装备按量)单据未处理!";
	    	ab.show();
	    }
	  //可控震源运转记录超3天未做提醒仅仅授权李志明
	  if('<%=userId%>'=='8AEDD21723F8BBA0E0430A58F821BBA0'){
	    var yzjlOutTime = jcdpCallService("DevCommRemind", "getYzjlOutTimeCount","orgSubId=<%=orgsubId %>");
	    var yzjlOuttimecount = yzjlOutTime.outtimecount;
	    if(yzjlOuttimecount !="0" && yzjlOuttimecount !=""){
	    	document.getElementById("showYzjlOutTimeCount").innerText="您有（"+yzjlOuttimecount+"）台可控震源最近三天没有状态监测数据!";
	    	ab.show();
	    }
	  }
	//相关专家查询报废申请列表信息是否有待办信息
		var retObj = jcdpCallService("ScrapeSrvNew", "getScrapeInfoByEmployee", "");
		if(retObj.num>0){
			document.getElementById("showScrapeApplyCount").innerText="您有（"+retObj.num+"）条报废申请单单据未处理!";
	    	ab.show();
	    }	
	};
})()
function remind(str){
	if(str == '0'){
		popWindow('<%=contextPath%>/rm/dm/panel/devcieHireList.jsp','980:520','-设备未返还项目列表');
	}else if(str == '3'){//运转记录查询
		popWindow('<%=contextPath %>/rm/dm/panel/devYzjlOutTimeInfo.jsp','980:520','-运转记录超期三天列表');
	}else if(str == '4'){
		popWindow('<%=contextPath %>/rm/dm/panel/devEqOutList.jsp?opr_state=0','980:520','-设备出库(装备单台)未处理单据列表');
	}else if(str == '5'){
		popWindow('<%=contextPath %>/rm/dm/panel/devCollOutList.jsp?opr_state=0','980:520','-设备出库(装备按量)未处理单据列表');
	}else if(str == '7'){
		popWindow('<%=contextPath %>/dmsManager/scrape/scrapeApplyListForEmp.jsp','980:520','申请单查询');
	}else{
		popWindow('<%=contextPath%>/rm/dm/panel/devcieRecvList.jsp','980:520','-设备未接收项目列表');
	}
}
function kkzy_simpleSearch(){
	
}
function simpleSearch(){
		var bywx_date_begin=$("#start_date").datebox('getValue');
		var bywx_date_end=$("#end_date").datebox('getValue');
	 
		if(!bywx_date_begin){
			alert('请选择开始时间');
			return;
		}
		if(!bywx_date_end){
			alert('请选择结束时间');
			return;
		}
		if(bywx_date_begin>bywx_date_end){
			alert("开始时间不能大于结束时间!");
			return;
		}
		window.location="<%=contextPath%>/rm/dm/panel/devmainpanelOfGongsiZB.jsp?bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end+"&country="+$("#country").val();
}

 
 
function popDevList(dev_name,org_name){
		dev_name = encodeURI(dev_name);
		dev_name = encodeURI(dev_name);
		org_name = encodeURI(org_name);
		org_name = encodeURI(org_name);
	popWindow('<%=contextPath%>/rm/dm/deviceXZAccount/DevAccListUnUse_coll.jsp?dev_name='+dev_name+'&org_name='+org_name,'980:520','-闲置设备列表');
} 
 
//各个项目组震源数量导出
function exportDataDoc4(exportFlag){
	//调用导出方法
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var submitStr="";
    submitStr = "exportFlag="+exportFlag;
		var retObj = syncRequest("post", path, submitStr);
		var filename = retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname = retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location = cruConfig.contextPath
				+ "/rm/dm/common/download_temp.jsp?filename=" + filename
				+ "&showname=" + showname;
	}
	function popDevArchiveBaseInfoList(project_info_id){
		popWindow('<%=contextPath %>/rm/dm/kkzy/zytj/popDevArchiveBaseInfoList.jsp?project_info_id='+project_info_id,'1200:600');
	}
	 
 	 
     
     function changeAccount_stat(){
		$("#device_content tr[class!='trHeader']").remove();
	    var s_org_id = document.getElementsByName("s_org_id_wutan")[0].value;
  		var account_stat = $("#account_stat").val();
	    //加载主要设备基本情况统计表
		loadTable(s_org_id,account_stat);
	}
		//地震仪器数量获取图标
		function getFusionChart5(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "100%", "300", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/kkzy/getKkzyAmountAnal.srq");
			chart1.render("chartContainer5");
		}
		// 弹出子级可控震源数量统计分析信息
		function popSecondKkzyAmountAnal(useStat){
			popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/secondKkzyAmountAnal.jsp?useStat='+useStat,'800:572');
		}
		// 弹出其他震源信息
		function popOtherKkzyList(useStat){
			popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/otherKkzyList.jsp?useStat='+useStat,'800:572');
		}
</script>


</html>

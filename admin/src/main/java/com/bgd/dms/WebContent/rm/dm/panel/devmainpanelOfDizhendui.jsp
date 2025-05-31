<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>单项目统计首页</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">地震队机械设备统计</a><span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('dzdjxsbtj')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">地震队采集设备统计</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="gd"><a href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('dzdcjsbtj')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">

						</div>
						</div>
						</td>
					</tr>
					<tr>
						<td width="100%" colspan="3">
						<div class="tongyong_box">
						<div class="tongyong_box_title">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
								<td>
									<span class="kb" ><a
									href="#"></a></span><a href="<%=contextPath %>/rm/dm/panel/xiazua/devkaoqinyouliaoList.jsp" target="_blank">地震队机械设备考勤及油耗统计表</a>
									
								</td>
								<td class="ali_cdn_name">开始时间:</td>
							    <td class="ali_cdn_input"><input id="start_date" name="start_date" class="input_width" type="text" readonly/> </td>
							    <td >
						 	    <img src='<%=contextPath%>/images/calendar.gif' id='tributton_start_date' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(start_date,tributton_start_date);'/>
						 	    </td>
							    <td class="ali_cdn_name">结束时间:</td>
							    <td class="ali_cdn_input"><input id="end_date" name="end_date" class="input_width" type="text" readonly/></td>
							    <td >
						 	    <img src='<%=contextPath%>/images/calendar.gif'id='tributton_end_date' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(end_date,tributton_end_date);'/>
						 	    </td>
							    <td class="ali_cdn_name">牌照号:</td>
							    <td class="ali_cdn_input">
							    <input id="s_license_num" name="s_license_num" class="input_width" type="text"/></td>
							    
							    <td class="ali_query">
								    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
							    </td>
							    <td class="ali_query">
								    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_submit"></a></span>
							    </td>
							    <td class="ali_btn">
								    <span class="dc"><a href="#" onclick="exportDataDoc('dzdjxsbkqjyhtj')" title="导出excel"></a></span>
							    </td>
								</tr>
							</table>
							</div>
						<div class="tongyong_box_content_left"  id="chartContainer4" style="height: 250px;">
						</div>
						</div>
						</td>
					</tr>
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">地震队机动设备配备统计</a><span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('dzdjdsbpbtj')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer3" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">地震仪器损失情况</a>
							<span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('dzyqssqk')" title="导出excel"></a>
							</span>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer5" style="height: 250px;">

						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	
	function getFusionChart(){
		$$('idBoxOpen2').click();
		var retObj1 = jcdpCallServiceCache("EarthquakeTeamStatistics","getMachineryEquipmentStatistics","projectInfoNo=<%=projectInfoNo%>");
		var dataXml1 = retObj1.dataXML;
		var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId1", "100%", "250", "0", "0" );    
		myChart1.setXMLData(dataXml1);
		myChart1.render("chartContainer1");
		 
		var retObj2 = jcdpCallServiceCache("EarthquakeTeamStatistics","getCollEqSumStatistics","projectInfoNo=<%=projectInfoNo%>&drillLevel=2");
		var dataXml2 = retObj2.dataXML;
		var myChart2 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
		myChart2.setXMLData(dataXml2);
		myChart2.render("chartContainer2");
		
		var retObj3 = jcdpCallServiceCache("EarthquakeTeamStatistics","getMobileEquipmentStatisticsForTable","projectInfoNo=<%=projectInfoNo%>");
		var dataXml3 = retObj3.dataXML;
		$("#chartContainer3").append(dataXml3);
		//var myChart3 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartId3", "100%", "250", "0", "0" );    
		//myChart3.setXMLData(dataXml3);
		//myChart3.render("chartContainer3");
		
		//var myChart4 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId4", "100%", "250", "0", "0" ); 
		//myChart4.setXMLUrl("<%=contextPath%>/rm/dm/tree/geDeviceLiyongWanhaoStatistics.srq?projectInfoNo=<%=projectInfoNo%>");
		//myChart4.render("chartContainer4");
		simpleSearch();
		
		var retObj22  = jcdpCallServiceCache("DevCommInfoSrv", "getCompEqDestroy", "project_info_no=<%=projectInfoNo%>");
		var dataXml22 = retObj22.dataXML;
		$("#chartContainer5").append(dataXml22);
		
		<%-- var retObj5 = jcdpCallService("EarthquakeTeamStatistics","geAcquisitionEquipmentStatistics","projectInfoNo=<%=projectInfoNo%>");
		var dataXml5 = retObj5.dataXML;
		var myChart5 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId5", "100%", "250", "0", "0" );    
		myChart5.setXMLData(dataXml5);
		myChart5.render("chartContainer5"); --%>
	
		
	}
	
	function clearQueryText(){
		document.getElementById("start_date").value = '';
		document.getElementById("end_date").value = '';
		document.getElementById("s_license_num").value = '';
		simpleSearch();
		
	}
	function drillDownDevInfo(obj){
		//改成pop出来的形式
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDDevInfoDrillDownForTable.jsp?code='+obj,'800:600');
	}
	function drillteamdev(obj){
		//改成pop出来的形式
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDTeamDevInfoDrillDownForTable.jsp?code='+obj,'800:600');
		//var retObj = jcdpCallService("EarthquakeTeamStatistics","getTeamDevInfoDrillDownForTable","projectInfoNo=<%=projectInfoNo%>&code="+obj);
	}
	function popDevQueqinJianxiuDetail(obj){
		popWindow('<%=contextPath %>/rm/dm/panel/popDevQueqinJianxiuDetailForTable.jsp?code='+obj,'800:600');
	}
	function drillDownTeamDevInfoBack(){
		var retObj3 = jcdpCallService("EarthquakeTeamStatistics","getMobileEquipmentStatistics","projectInfoNo=<%=projectInfoNo%>");
		var dataXml3 = retObj3.dataXML;
		var myChart3 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );    
		myChart3.setXMLData(dataXml3);
		myChart3.render("chartContainer3");
	}
	function popCollEqStaticinfo(obj){
		//改成pop出来的形式
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDCollEqStaticinfo.jsp?code='+obj,'800:600');
	}
	function simpleSearch(){
		var startDate = document.getElementById("start_date").value;
		var endDate = document.getElementById("end_date").value;
		var licenseNum = document.getElementById("s_license_num").value;
		var retObj4 = jcdpCallService("EarthquakeTeamStatistics","geDevQueqinJianxiuStaticData","projectInfoNo=<%=projectInfoNo%>&startDate="+startDate+"&endDate="+endDate+"&licenseNum="+licenseNum);
		var dataXml4 = retObj4.dataXML;
		$("#chartContainer4").html("");
		$("#chartContainer4").append(dataXml4);
		}
	
	function exportDataDoc(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		if("dzdjxsbkqjyhtj"==exportFlag){
			var start_date=$("#start_date").val();
			var end_date=$("#end_date").val();
			var s_license_num=$("#s_license_num").val();
			submitStr = "projectInfoNo=<%=projectInfoNo%>&exportFlag="+exportFlag+"&start_date="+start_date+"&end_date="+end_date+"&s_license_num="+s_license_num;
		}else{
			submitStr = "projectInfoNo=<%=projectInfoNo%>&exportFlag="+exportFlag;
		}
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
</script>

<!-- 右下角弹窗 -->
<style>
.lightbox{width:300px;background:#FFFFFF;border:5px solid #ccc;line-height:20px;display:none; margin:0;}
.lightbox dt{background:#f4f4f4;padding:5px;}
.lightbox dd{ padding:20px; margin:0;}
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
	<dt><b>工作提醒消息</b><input align="right" type="button" value="关闭" id="idBoxClose2" /></dt>
	<dd>
		<a href="<%=contextPath %>/rm/dm/devback/backPlanMainInfoList.jsp" /><div id = "showCount"></div></a>
		<a href="<%=contextPath %>/rm/dm/collectDevBack/collect_devback_main.jsp" /><div id = "showCount2"></div></a>
	</dd>
</dl>
<script>
(function(){
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
	var obj  = jcdpCallServiceCache("DevInsSrv", "getDeviceHireDeviceCount", "projectInfoNo=<%=projectInfoNo%>");
    var devCount = "";      //单台项目未返还数
    var devCollCount = "";  //批量设备在数
    var showWindow = false;
    devCount=obj.deviceCount;   
    devCollCount=obj.deviceCollCount;
    
    if(devCount !="0" && devCount !=""){
   	    document.getElementById("showCount").innerText="还有"+devCount+"单台设备未进行返还,请尽快进行返还!";
   	    showWindow = true;
    }
    if(devCollCount !="0" && devCollCount !=""){
   	    document.getElementById("showCount2").innerText="还有"+devCollCount+"批量设备未进行返还,请尽快进行返还!";
   	    showWindow = true;
    }
    if(showWindow == true){ab.show();}
	 }
})()
</script>
<script type="text/javascript">
	function frameSize() {
		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>


<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	//月份信息
	String monthinfo = request.getParameter("monthinfo");
	String yearinfo=monthinfo.split("-")[0];
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title>
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
						<td width="99%">
							<div class="tongyong_box">
							<div class="tongyong_box_title"><span class="kb"><a
								href="#"></a></span><a href="#">主要设备完好率、利用率钻取
								</a><span class="gd"><a
								href="#"></a></span></div>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
		
								</div>
							</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			</td>
			<tr>
				<td>
				<fieldSet><legend>物探处名称</legend>
				<table style="width:95%" border="0" cellspacing="0" cellpadding="0" id="wutaninfo">
					<tr>
					<%
						for(int i=0;i<DevUtil.orgNameList.size()&&i<4;i++){
							String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
					%>
						<td><input type="checkbox" id="<%=tmpstrs[0]%>" name="orgcheckbox" value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%>&nbsp;</td>
					<%
						}
					%>
					</tr>
					<tr>
					<%
						for(int i=4;i<DevUtil.orgNameList.size()&&i<8;i++){
							String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
					%>
						<td><input type="checkbox" id="<%=tmpstrs[0]%>" name="orgcheckbox" value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%>&nbsp;</td>
					<%
						}
					%>
					</tr>
					<tr>
					<%
						for(int i=8;i<DevUtil.orgNameList.size()&&i<12;i++){
							String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
					%>
						<td><input type="checkbox" id="<%=tmpstrs[0]%>" name="orgcheckbox" value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%>&nbsp;</td>
					<%
						}
					%>
					</tr>
					
				</table>
				</fieldSet>
			</td>
			</tr>
			<tr>
				<td><input type="button" id="ok" value="更新" onclick="searchWutanMonthWanhaoLiyong()"></td>
			</tr>
		</table>
	<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	function getFusionChart(){
		var selectorg = "";
		var checkboxobjs = document.getElementsByName("orgcheckbox");
		for(var index=0;index<checkboxobjs.length;index++){
			if(checkboxobjs[index].checked == true){
				if(selectorg.length==0){
					selectorg += checkboxobjs[index].value;
				}else{
					selectorg += "~"+checkboxobjs[index].value;
				}
			}
		}
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "250", "0", "0" );
		//不要日期信息了，直接展现各物探处的对比图  
		myChart3.setXMLUrl("<%=contextPath%>/rm/dm/getCompLVMonth.srq?yearinfo=<%=yearinfo%>&orginfos="+selectorg+"&drillLevel=0");    
		myChart3.render("chartContainer2"); 
	}
	function searchWutanMonthWanhaoLiyong(){
		var selectorg = "";
		var checkboxobjs = document.getElementsByName("orgcheckbox");
		for(var index=0;index<checkboxobjs.length;index++){
			if(checkboxobjs[index].checked == true){
				if(selectorg.length==0){
					selectorg += checkboxobjs[index].value;
				}else{
					selectorg += "~"+checkboxobjs[index].value;
				}
			}
		}
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "250", "0", "0" );
		var retObj = jcdpCallService("DevCommInfoSrv","getCompLVMonth","yearinfo=<%=yearinfo%>&orginfos="+selectorg+"&drillLevel=0");
		var dataXml = retObj.xmldata;
		var startindex = dataXml.indexOf("<chart");
		dataXml = dataXml.substr(startindex);
		myChart3.setXMLData(dataXml);
		myChart3.render("chartContainer2"); 
	}
	function drillWutanMonthWanhaoLiyong(obj){
		//var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" ); 
		//var paramobj = obj.split("~",-1);
		//var retObj = jcdpCallService("DevCommInfoSrv","drillWutanMonthWanhaoLiyong","monthinfo="+paramobj[0]+"&orgsubid="+paramobj[1]+"&drillLevel=0");
		//var dataXml = retObj.xmldata;
		//myChart3.setXMLData(dataXml);
		//myChart3.render("chartContainer2"); 
		popWindow('<%=contextPath %>/rm/dm/panel/popWutanMonthWanhaoLiyongDrill.jsp?obj='+obj, '800:600');
	}
	function drillWutanMonthWanhaoLiyongBack(obj){
		var selectorg = "";
		var checkboxobjs = document.getElementsByName("orgcheckbox");
		for(var index=0;index<checkboxobjs.length;index++){
			if(checkboxobjs[index].checked == true){
				if(selectorg.length==0){
					selectorg += checkboxobjs[index].value;
				}else{
					selectorg += "~"+checkboxobjs[index].value;
				}
			}
		}
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "250", "0", "0" );
		var retObj = jcdpCallService("DevCommInfoSrv","getCompLVMonth","orginfos="+selectorg+"&drillLevel=0");
		var dataXml = retObj.xmldata;
		var startindex = dataXml.indexOf("<chart");
		dataXml = dataXml.substr(startindex);
		myChart3.setXMLData(dataXml);
		myChart3.render("chartContainer2"); 
	}
</script>
</html>


<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	
	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar.getInstance().getTime());
	int monthinfo = Integer.parseInt(monthinfostr);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
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
						<td width="100%" colspan="3">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备完好率、利用率年度分析</a>
							<select id="yearinfo" name="yearinfo" style="select_width" onchange="changeYear()">
								<%
									for(int j=0;j<3;j++){
										int showinfo = yearinfo-j;
								%>
								<option value="<%=showinfo%>"><%=showinfo%>年</option>
								<%
									}
								%>
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id2' onchange="changeOrg2()">
								<option value="">--请选择--</option>
							<%
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.orgNameList.size();i++){
									String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.orgNameList.size();i++){
										if(DevUtil.orgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
							</div>
						<div class="tongyong_box_content_left"  id="chartContainer2" style="height: 250px;">
			 
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备完好率、利用率分析</a>
							<select id="monthinfo" name="monthinfo" style="select_width" onchange="changeMonth()">
								<%
									for(int j=0;j<3;j++){
										int showinfo = yearinfo-j;
								%>
								<option value="<%=showinfo%>"><%=showinfo%>年</option>
								<%
									}
								%>
							</select>
							<span class="gd"><a href="#"></a></span>
							<select name='s_org_id6' onchange="changeOrg6()">
								<option value="">--请选择--</option>
							<%
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.orgNameList.size();i++){
									String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.orgNameList.size();i++){
										if(DevUtil.orgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
							</div>
						<div class="tongyong_box_content_left"  id="chartContainer3" style="height: 250px;">
			 
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

function getFusionChart(){
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWT.srq?orgstrId=<%=orgstrId%>");
	myChart2.render("chartContainer2"); 
	
	
	//先看当月的，可以查看历史月份的，加上时间条件
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/rm/dm/getWutanLiyongWanHaoWT.srq?orgstrId=<%=orgstrId%>");      
	myChart3.render("chartContainer3"); 
}
function changeYear(){
     var chartReference = FusionCharts("myChartId2");     
     var yearinfo = document.getElementsByName("yearinfo")[0].value;
     var s_org_id = document.getElementsByName("s_org_id2")[0].value;
     var orgstrId='<%=orgstrId%>';
     chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWT.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&orgsubId="+s_org_id);
}
function changeOrg2(){
    var chartReference = FusionCharts("myChartId2");
    var yearinfo = document.getElementsByName("yearinfo")[0].value;
    var s_org_id = document.getElementsByName("s_org_id2")[0].value;
    
    var orgstrId='<%=orgstrId%>';
    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWT.srq?orgstrId="+orgstrId+"&orgsubId="+s_org_id+"&yearinfo="+yearinfo);
}

function changeOrg6(){
    var chartReference = FusionCharts("myChartId3");
    var s_org_id = document.getElementsByName("s_org_id6")[0].value;
    var yearinfo = document.getElementsByName("monthinfo")[0].value;
    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getWutanLiyongWanHaoWT.srq?orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&yearinfo="+yearinfo);
}

function changeMonth(){
	var chartReference = FusionCharts("myChartId3");
    var s_org_id = document.getElementsByName("s_org_id6")[0].value;
    var yearinfo = document.getElementsByName("monthinfo")[0].value;
    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getWutanLiyongWanHaoWT.srq?orgstrId=<%=orgstrId%>&orgsubId="+s_org_id+"&yearinfo="+yearinfo);
}
</script>  
<script type="text/javascript">
	/**/function frameSize() {

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


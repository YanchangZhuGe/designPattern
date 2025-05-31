<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo= request.getParameter("projectInfoNo");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		projectInfoNo=user.getProjectInfoNo();
	}
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	projectInfoNo = "8ad8918f41ded5140141def8cfae0003";
	project_type = "5000100004000000009";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
	<div id="list_content">
	<%if(project_type!=null && (project_type.trim().equals("5000100004000000001") || project_type.trim().equals("5000100004000000008") || project_type.trim().equals("5000100004000000010"))){ %>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="49%">
								<div class="tongyong_box">
									<div class="tongyong_box_title">
										<a href="#">目标成本构成</a><span class="gd"><a href="#"></a> </span>
									</div>
									<div class="tongyong_box_content_left" id="chartContainer1" style="height: 230px;"></div>
								</div>
							</td>
							<td width="1%"></td>
							<td width="49%">
								<div class="tongyong_box">
									<div class="tongyong_box_title">

										<a href="#">目标成本和实际费用累计支出对比</a><span class="gd"><a href="#"></a> </span>
									</div>
									<div class="tongyong_box_content_left" id="chartContainer2" style="height: 230px;"></div>
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
									<div class="tongyong_box_title">
										<a href="#">直接材料费目标成本与实际对比图</a><span class="gd"><a href="#"></a> </span>
									</div>
									<div class="tongyong_box_content_left" id="chartContainer3" style="height: 230px;"></div>
								</div>
							</td>
							<td width="1%"></td>
							<td width="49%">
								<div class="tongyong_box">
									<div class="tongyong_box_title">

										<a href="#">直接人工费目标成本与实际对比图</a><span class="gd"><a href="#"></a> </span>
									</div>
									<div class="tongyong_box_content_left" id="chartContainer4" style="height: 230px;"></div>
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
									<div class="tongyong_box_title">
										<a href="#">机械使用费目标成本与实际对比图</a><span class="gd"><a href="#"></a> </span>
									</div>
									<div class="tongyong_box_content_left" id="chartContainer5" style="height: 230px;"></div>
								</div>
							</td>
							<td width="1%"></td>
							<td width="49%">
								<div class="tongyong_box">
									<div class="tongyong_box_title">

										<a href="#">QHSE费目标成本与实际对比图</a><span class="gd"><a href="#"></a> </span>
									</div>
									<div class="tongyong_box_content_left" id="chartContainer6" style="height: 230px;"></div>
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
							<td width="100%">
								<div class="tongyong_box">
									<div class="tongyong_box_title">
										<a href="#">其他直接费目标成本与实际对比图</a><span class="gd"><a href="#"></a> </span>
									</div>
									<div class="tongyong_box_content_left" id="chartContainer7" style="height: 230px;"></div>
								</div>
							</td>
						</tr>
					</table>
				</td>
				<td width="1%"></td>
			</tr>
		</table>
	<%}else if(project_type!=null && project_type.trim().equals("5000100004000000009")){ %>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">目标成本构成</a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer1"></div></div>
					</div>
				</td>
				<td width="1%"></td>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">目标成本和实际费用累计支出对比</a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer2"></div></div>
					</div>
				</td>
				<td width="1%"></td>
			</tr>
			<tr>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">成本工资</a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer3"></div></div>
					</div>
				</td>
				<td width="1%"></td>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">外雇工费</a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer4"></div></div>
					</div>
				</td>
				<td width="1%"></td>
			</tr>
			<tr>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">燃料费</a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer5"></div></div>
					</div>
				</td>
				<td width="1%"></td>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">房租费 </a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer6"></div></div>
					</div>
				</td>
				<td width="1%"></td>
			</tr>
			<tr>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">材料费</a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer7"></div></div>
					</div>
				</td>
				<td width="1%"></td>
				<td >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">HSE经费 </a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer8"></div></div>
					</div>
				</td>
				<td width="1%"></td>
			</tr>
			<tr>
				<td colspan="3" >
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">其他费用</a></div>
						<div class="tongyong_box_content_left" style="height: 230px;"><div id="chartContainer9"></div> </div>
					</div>
				</td>
			</tr>
		</table>
	<%} %>	
	</div>
	
	<script type="text/javascript">
function getFusionChart(){
	var project_type ='<%=project_type%>';
	if(project_type!=null && project_type=='5000100004000000009'){
		whtChart();
	}else{
		landChart();
	}
}
function drillxmtadb(obj){
	window.showModalDialog("<%=contextPath%>/op/costDashBoard/team2.jsp?projectInfoNo="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
}
function  drillxmtadt(obj){
	window.showModalDialog("<%=contextPath%>/op/costDashBoard/team8.jsp?parentId="+obj+"&projectInfoNo=<%=projectInfoNo%>",obj,"dialogWidth=800px;dialogHeight=600px");
}
function whtChart(){
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId1", "100%", "230", "0", "0" );
 	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetPieInfo.srq?projectInfoNo=<%=projectInfoNo%>&parentId=S01");
    myChart.render("chartContainer1");
	
    var nodeCode = ["S01","S01001","S01002","S01005","S01006","S01007","S01008","S01009"];//费用编码，表示那种费用
	for(var i in nodeCode){
		var str = "";
		myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "230", "0", "1");
	 	var retObj = jcdpCallServiceCache("OPCostSrv", "getWhtTargetActualInfo", "nodeCode="+nodeCode[i]+"&projectInfoNo=<%=projectInfoNo%>");
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			str = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(str);
	    myChart.render("chartContainer"+(i-(-2)));
	}
}
function landChart(){
	myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetPieInfo.srq?projectInfoNo=<%=projectInfoNo%>");
	myChart.render("chartContainer1");
	
	myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getCompareTargetActualInfo.srq?projectInfoNo=<%=projectInfoNo%>");
	myChart.render("chartContainer2");
	
	myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "230", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetActualInfo.srq?parentId=S01001006&projectInfoNo=<%=projectInfoNo%>");
	myChart.render("chartContainer3");
	
	myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId4", "100%", "230", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetActualInfo.srq?parentId=S01001001&projectInfoNo=<%=projectInfoNo%>");
	myChart.render("chartContainer4");
	
	myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId5", "100%", "230", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetActualInfo.srq?parentId=S01001004&projectInfoNo=<%=projectInfoNo%>");
	myChart.render("chartContainer5");
	
	myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId6", "100%", "230", "0", "0" );
	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetActualInfo.srq?parentId=S01001002&projectInfoNo=<%=projectInfoNo%>");
	myChart.render("chartContainer6");
	
	myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId6", "100%", "230", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetActualInfo.srq?parentId=S01001003&projectInfoNo=<%=projectInfoNo%>");      
	myChart.render("chartContainer7");
}
</script>  
</body>

</html>


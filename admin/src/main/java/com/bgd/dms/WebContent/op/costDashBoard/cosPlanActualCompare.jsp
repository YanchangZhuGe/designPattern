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
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td valign="top" id="td0">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<%if(project_type!=null && (project_type.trim().equals("5000100004000000001") || project_type.trim().equals("5000100004000000008") || project_type.trim().equals("5000100004000000010"))){ %>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">直接材料费预警分析</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer1"></div></div>
										</div>
									</td>
									<td width="1%"></td>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">直接人工费预警分析</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer2"></div></div>
										</div>
									</td>
									<td width="1%"></td>
								</tr>
								<tr>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">机械使用费预警分析</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer3"></div></div>
										</div>
									</td>
									<td width="1%"></td>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">QHSE费用预警分析 </a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer4"></div></div>
										</div>
									</td>
									<td width="1%"></td>
								</tr>
								<tr>
									<td colspan="3" >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">其他直接费用</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer5"></div> </div>
										</div>
									</td>
								</tr>
							</table>
							<%}else if(project_type!=null && project_type.trim().equals("5000100004000000009")){ %>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">成本工资</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer1"></div></div>
										</div>
									</td>
									<td width="1%"></td>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">外雇工费</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer2"></div></div>
										</div>
									</td>
									<td width="1%"></td>
								</tr>
								<tr>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">燃料费</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer3"></div></div>
										</div>
									</td>
									<td width="1%"></td>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">房租费 </a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer4"></div></div>
										</div>
									</td>
									<td width="1%"></td>
								</tr>
								<tr>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">材料费</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer5"></div></div>
										</div>
									</td>
									<td width="1%"></td>
									<td >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">HSE经费 </a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer6"></div></div>
										</div>
									</td>
									<td width="1%"></td>
								</tr>
								<tr>
									<td colspan="3" >
										<div class="tongyong_box" >
											<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">其他费用</a></div>
											<div class="tongyong_box_content_left" style="height: 250px;"><div id="chartContainer7"></div> </div>
										</div>
									</td>
								</tr>
							</table>
							<%} %>
						</td>
					</tr>
				</table>
			</td> 
		</tr>
	</table>
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
function whtChart(){
	//var type = new Array("one","two","five","six","seven","eight","nine");//,"two","five","six","seven","eight","nine"
	var nodeCode = ["S01001","S01002","S01005","S01006","S01007","S01008","S01009"];//费用编码，表示那种费用
	var project_info_no = '<%=projectInfoNo%>';
	for(var i in nodeCode){
		var str = "";
		var myChart = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId", "100%", "250", "0", "1");
	    var substr = "nodeCode="+nodeCode[i]+"&projectInfoNo=<%=projectInfoNo%>";
	 	var retObj = jcdpCallServiceCache("OPCostSrv", "getPlanActualCompareData", substr);
	 	if(retObj!=null && retObj.returnCode=='0'){
	 		if(retObj.Str!=null){
	 			str = retObj.Str;
	 		}
	 	}
	 	myChart.setDataXML(str);
	    myChart.render("chartContainer"+(i-(-1)));
	}
}
function landChart(){
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "250", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getPlanActualCompareData.srq?nodeCode=S01001006&projectInfoNo=<%=projectInfoNo%>");      
	myChart1.render("chartContainer1");
	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getPlanActualCompareData.srq?nodeCode=S01001001&projectInfoNo=<%=projectInfoNo%>");      
	myChart2.render("chartContainer2");
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "250", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getPlanActualCompareData.srq?nodeCode=S01001004&projectInfoNo=<%=projectInfoNo%>");      
	myChart3.render("chartContainer3");
	
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "250", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getPlanActualCompareData.srq?nodeCode=S01001002&projectInfoNo=<%=projectInfoNo%>");      
	myChart4.render("chartContainer4");
	
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId5", "100%", "250", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getPlanActualCompareData.srq?nodeCode=S01001003&projectInfoNo=<%=projectInfoNo%>");      
	myChart5.render("chartContainer5");
}
</script>  
</body>
</html>


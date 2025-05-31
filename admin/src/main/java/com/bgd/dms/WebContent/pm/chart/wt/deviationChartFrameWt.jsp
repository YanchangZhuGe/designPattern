<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	
	WorkMethodSrv wm = new WorkMethodSrv();
	List<String> expMethodStringList = wm.getProjectWorkMethodWtList(projectInfoNo);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #cdddef; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				<table width="99%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">偏离度</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 300px;">
			 
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="99%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%" align="center">
							<table width="100%" border="1" cellspacing="0" cellpadding="0">
								<tr class="bt_info">
									<td class="tableHeader">工序</td>
<!-- 									<td class="tableHeader">计量单位</td> -->
									<td class="tableHeader" >施工状态</td>
									<td class="tableHeader">施工线束</td>
									<td class="tableHeader" >设计工作量</td>
									<td class="tableHeader" >累积完成</td>
									<td class="tableHeader" >实际完成百分比(%)</td>
									<td class="tableHeader" >计划偏离度(%)</td>
									<td class="tableHeader">实际开始日期</td>
									<td class="tableHeader" >计划开始日期</td>
									<td class="tableHeader">实际完成日期</td>
									<td class="tableHeader" >计划完成日期</td>
								</tr>
							<%for(int k=0;k<expMethodStringList.size();k++){ 
								String expMethod = expMethodStringList.get(k);
							%>
								<tr class="odd" height="25px">
									<td id="tdMehtod_<%=expMethod%>"></td>
<!-- 									<td>工作量</td> -->
									<td id="tdStatus_<%=expMethod%>"></td>
									<td id="tdGroupLine_<%=expMethod%>"></td>
									<td id="tdDesignWorkLoad_<%=expMethod%>"></td>
									<td id="tdDailyWorkLoad_<%=expMethod%>"></td>
									<td id="tdFinishPercentage_<%=expMethod%>"></td>
									<td id="tdDeviation_<%=expMethod%>"></td>
									<td id="tdStartDate_<%=expMethod%>"></td>
									<td id="minDesignDate_<%=expMethod%>"></td>
									<td id="tdDate_<%=expMethod%>"></td>
									<td id="designDate_<%=expMethod%>"></td>
								</tr>
							<%} %>
							</table>
							</br>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
 function getFusionChart(){
 var expMethodStringList = '<%=expMethodStringList%>';
	 
 var retObj = jcdpCallService("ChartSrv","getDeviationWt","project_info_no=<%=projectInfoNo %>&exp_methods="+expMethodStringList);
 	var dataXml = retObj.Str;
 var gridData = retObj.gridData;
 	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
 	myChart1.setXMLData(dataXml);
 	myChart1.render("chartContainer1");

	if(gridData != null){
		for(var i=0; i< gridData.length; i++){
			var record = gridData[i];
			var expMethod = record.typeId;
			document.getElementById("tdMehtod_" + expMethod).innerHTML = record.typeName != undefined ? record.typeName:"";
			document.getElementById("tdStatus_" + expMethod).innerHTML = record.status != undefined ? record.status:"";
			document.getElementById("tdGroupLine_" + expMethod).innerHTML = record.groupLine != undefined ? record.groupLine:"";
			document.getElementById("tdDesignWorkLoad_" + expMethod).innerHTML = record.designWorkLoad != undefined ? record.designWorkLoad:"";
			document.getElementById("tdDailyWorkLoad_" + expMethod).innerHTML = record.dailyWorkLoad != undefined ? record.dailyWorkLoad:"";
			document.getElementById("tdFinishPercentage_" + expMethod).innerHTML = record.finishPercentage != undefined ? record.finishPercentage:"";
			document.getElementById("tdDeviation_" + expMethod).innerHTML = record.deviation != undefined ? record.deviation:"";
			document.getElementById("tdStartDate_" + expMethod).innerHTML = record.startDate != undefined ? record.startDate:"";
			document.getElementById("minDesignDate_" + expMethod).innerHTML = record.minDesignDate != undefined ? record.minDesignDate:"";
			document.getElementById("tdDate_" + expMethod).innerHTML = record.date != undefined ? record.date:"";
			document.getElementById("designDate_" + expMethod).innerHTML = record.designDate != undefined ? record.designDate:"";
		}
	}
}
 
 function myJs(myVar){
	 alert(myVar);
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


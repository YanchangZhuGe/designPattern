<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);

	if (user == null) {
		request.getRequestDispatcher("login.jsp").forward(request,
				response);
		return;
	}
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgSubId = user.getSubOrgIDofAffordOrg();
	response.setContentType("text/html;charset=utf-8");
	String contextPath = request.getContextPath();
	String topDivHight = "'350px'";
	String midDivHight = "'350px'";

	String topChartHight = "'320px'";
	String midChartHight = "'320px'";

	String topDivWidth = "'98%'";
	String midDivWidth = "'98%'";

	String topChartWidth = "'96%'";
	String midChartWidth = "'96%'";

	String chartUrl = contextPath + "/dmsManager/chartFrameSet.jsp";
	String title1 = "成本分析";
	String title2 = "投入分析";
	String title3 = "资产分析";
	String title4 = "效益分析";

	String label1_1 = "设备类别维修统计";
	String frameSetUrl1_1 = contextPath
			+ "/dmsManager/repair/statAnal/repairTypeAnal.jsp";
	String url1_1 = chartUrl + "?listUrl='" + frameSetUrl1_1 + "'";
	String RenderURL1_1 = contextPath +"/dms/repair/getRepairTypeChartData.srq";

	String label1_2 = "维修费用分布";
	String frameSetUrl1_2 = contextPath
			+ "/dmsManager/repair/statAnal/repairCostProAnal.jsp";
	String url1_2 = chartUrl + "?listUrl='" + frameSetUrl1_2 + "'";
	String RenderURL1_2 = contextPath + "/dms/repair/getRepairCostProportionChartData.srq";
	
	String label1_3 = "修费用趋势";
	String frameSetUrl1_3 = contextPath
			+ "/dmsManager/repair/statAnal/repairCostAnal.jsp";
	String url1_3 = chartUrl + "?listUrl='" + frameSetUrl1_3 + "'";
	String RenderURL1_3 = contextPath + "/dms/repair/getRepairCostChartData.srq";

	String label2_1 = "维修成本占收入比 ";
	String frameSetUrl2_1 = contextPath
			+ "/dmsManager/repair/statAnal/devCostProfitRateAnal.jsp?analType=cost";
	String url2_1 = chartUrl + "?listUrl='" + frameSetUrl2_1 + "'";
	String RenderURL2_1_params = "?analType=cost&orgSubId=orgSubId&amountYear=2015";
	String RenderURL2_1 = contextPath + "/dms/repair/getDeviceCostProfitRateChartData.srq" + RenderURL2_1_params;

	String label2_2 = "维修成本占利润比 ";
	String frameSetUrl2_2 = contextPath
			+ "dmsManager/repair/statAnal/devCostProfitRateAnal.jsp?analType=profit";
	String url2_2 = chartUrl + "?listUrl='" + frameSetUrl2_2 + "'";
	String RenderURL2_2_params = "?analType=profit&orgSubId=orgSubId&amountYear=2015";
	String RenderURL2_2 = contextPath + "/dms/repair/getDeviceCostProfitRateChartData.srq" + RenderURL2_2_params;

	String label3_1 = "设备完好率和利用率";
	String frameSetUrl3_1 = contextPath
			+ "/dmsManager/use/useAWh/deviceUseAWh.jsp";
	String url3_1 = chartUrl + "?listUrl='" + frameSetUrl3_1 + "'";
	String RenderURL3_1 = contextPath + "/dms/use/getDeviceUseAndWhole.srq";

	String label3_2 = "利用率变化趋势";
	String frameSetUrl3_2 = contextPath
			+ "/dmsManager/device/deviceYearUseRate.jsp";
	String url3_2 = chartUrl + "?listUrl='" + frameSetUrl3_2 + "'";
	String RenderURL3_2 = contextPath + "/dms/device/getYearUseRate.srq";

	String label4_1 = "主要设备基本情况统计表";
	String frameSetUrl4_1 = contextPath
			+ "/dmsManager/use/statAnal/mainEquiBasiStat.jsp";
	String url4_1 = chartUrl + "?listUrl='" + frameSetUrl4_1 + "'";

	String label5_1 = "公司设备占比";
	String frameSetUrl5_1 = contextPath
			+ "/dmsManager/plan/devDistribute/devCompanyRate.jsp";
	String url5_1 = chartUrl + "?listUrl='" + frameSetUrl1_1 + "'";
	String RenderURL5_1 = contextPath + "/dms/plan/devDistribute/getDeviceCompanyRate.srq";
	

	String label5_2 = "生产设备占比";
	String frameSetUrl5_2 = contextPath
			+ "/dmsManager/plan/devDistribute/devProduceRate.jsp";
	String url5_2 = chartUrl + "?listUrl='" + frameSetUrl1_2 + "'";
	String RenderURL5_2 = contextPath + "/dms/plan/devDistribute/getDeviceProduceRate.srq";

	String label5_3 = "野外采集单位资产占比  ";
	String frameSetUrl5_3 = contextPath
			+ "/dmsManager/plan/devDistribute/devFieldCapital.jsp";
	String url5_3 = chartUrl + "?listUrl='" + frameSetUrl1_3 + "'";
	String RenderURL5_3 = contextPath + "/dms/plan/devDistribute/getDeviceFieldCapital.srq";
	
	/**
	效益分析
	**/
	String label6_1 = "资产创效 ";
	String frameSetUrl6_1 = contextPath
			+ "/dmsManager/use/assetsIncome/assetsIncomeProfit.jsp?analType=profit";
	String url6_1 = chartUrl + "?listUrl='" + frameSetUrl6_1 + "'";
	String RenderURL6_1_params = "?analType=profit&orgSubId=orgSubId&amountYear=2015";
	String RenderURL6_1 = contextPath + "/dms/use/getAssetsIncomeOrProfitData.srq" + RenderURL6_1_params;

	String label6_2 = "资产创收";
	String frameSetUrl6_2 = contextPath
			+ "/dmsManager/use/assetsIncome/assetsIncomeProfit.jsp?analType=cost";
	String url6_2 = chartUrl + "?listUrl='" + frameSetUrl6_2 + "'";
	String RenderURL6_2_params = "?analType=cost&orgSubId=orgSubId&amountYear=2015";
    String RenderURL6_2 = contextPath + "/dms/use/getAssetsIncomeOrProfitData.srq" + RenderURL6_2_params;
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/cn/style.css" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" />
<link rel="stylesheet"
	href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>
<link
	href="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/css/style.css"
	rel="stylesheet" type="text/css" />
<link
	href="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/css/prettify.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
<script type="text/javascript"
	src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/prettify.js"></script>
<script type="text/javascript"
	src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/json2.js"></script>
<title>设备管理体系信息系统</title>
<style type="text/css">
html,body {
	height: 100%;
	margin: 0;
	overflow-y: hidden;
}

.tongyong_box_title {
	width: 100%;
	height: auto;
	background: url(<%=contextPath%>/dashboard/images/titlebg.jpg);
	text-align: left;
	text-indent: 12px;
	font-weight: bold;
	font-size: 14px;
	color: #0f6ab2;
	line-height: 22px;
}
.focus_tongyong_box_content_left {
	width:100%;
	height:auto;
	background:#eaf1f9;
	overflow:auto;
}
.focus_tongyong_box {
	width:100%;
	height:auto;
	float:left;
	border:1px #6dabe6 solid;
	background:#efefef;
	color:#666;
	font-weight:normal;
	font-size:13px;
	margin:0 auto;
	text-align:center;
	margin-bottom:8px;
}
#_content {
	width:auto;
	height:auto;
	/* background:#efefef; */
	margin-left:0px;
	margin-top:0px;
	
	/*margin-top:42px\9;
	margin-top:42px\0;
    *margin-top:42px;
	_margin-top:42px;*/
}
.h1 { width:100%; display:block; 
line-height:1.5em; overflow:visible; 
font-size:22px; 
text-shadow:#f3f3f3 1px 1px 0px, #b2b2b2 1px 2px 0
}
.vintage{
background: #EEE url(data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAIAAAAmkwkpAAAAHklEQVQImWNkYGBgYGD4//8/A5wF5SBYyAr+//8PAPOCFO0Q2zq7AAAAAElFTkSuQmCC) repeat;
text-shadow: 5px -5px black, 4px -4px white;
font-weight: bold;
-webkit-text-fill-color: transparent;
-webkit-background-clip: text }
.about {
  margin: 70px auto 40px;
  padding: 4px;
  width: 260px;
  font: 24px/36px 'Lucida Grande', Arial, sans-serif;
  color: #ffffff;
  text-indent: 12px;
	font-weight: bold;
  text-align: left;
  text-shadow: 0 -1px rgba(0, 0, 0, 0.3);
  background: #efefef;
  background: rgba(32, 32, 128, 0.6);
  border-radius: 0px;
  background-image: -webkit-linear-gradient(top, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.3));
  background-image: -moz-linear-gradient(top, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.3));
  background-image: -o-linear-gradient(top, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.3));
  background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.3));
  -webkit-box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.2), 0 0 6px rgba(0, 0, 0, 0.4);
  box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.2), 0 0 6px rgba(0, 0, 0, 0.4);
}
</style>
<script type="text/javascript">
/**
 * 在页面中显示图标
 tableIndex 表格id,所有表格都为一行
 tdIndex 列索引,即tr标签中td的索引
 chartType：图表类型
 chartUrl：图表请求的后台地址
 */
 function showChart(tableIndex,tdIndex,chartType,chartUrl){
	 var chartID = "ChartId" + tableIndex + "_" + tdIndex;
	 var chartDivID = "ChartContainer" + tableIndex + "_" + tdIndex;
	 var topChart = new FusionCharts(chartType, chartID, <%=topChartWidth%>, <%=topChartHight%>, "0", "0");
	 topChart.setXMLUrl(chartUrl);  
	 topChart.render(chartDivID);
 }

 /**
 js操作table
 动态添加table中的label,td内容等
 **/
 function createTable(tableIndex,trIndex,tdIndex,linkUrl){
	 
 }

 function getFusionChart(){
	var chartType_pie = "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf";
	var chartType_Column = "${applicationScope.fusionChartsURL}/Charts/Column3D.swf";
	var chartType_Column_3d = "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf";
	var chartType_line = "${applicationScope.fusionChartsURL}/Charts/MSLine.swf";
	//showChart(pageLocatioin,tableLocation,chartType,chartID,chartUrl);
	//设备类别维修统计 
	showChart("1","1",chartType_Column,"<%=RenderURL1_1%>"); 

	//维修费用分布
	showChart("1","2",chartType_pie,"<%=RenderURL1_2%>");
	
	//维修费用趋势 
	showChart("1","3",chartType_line,"<%=RenderURL1_3%>");
	
	//维修成本占收入比   
	showChart("2","1",chartType_Column,"<%=RenderURL2_1%>");
		
	//维修成本占利润比
	showChart("2","2",chartType_Column,"<%=RenderURL2_2%>");	
	
		
	/**
	设备投入分析
	**/
	//设备完好率利用率
	showChart("3","1",chartType_Column_3d,"<%=RenderURL3_1%>");	
	
	//利用率变化趋势 
	showChart("3", "2", chartType_line, "<%=RenderURL3_2%>");
		
	 /**
	 资产分析
	 **/
	//公司设备占比   
	showChart("5","1",chartType_pie,"<%=RenderURL5_1%>"); 
	
	//生产设备占比
	showChart("5","2",chartType_pie,"<%=RenderURL5_2%>");
	
	//野外采集单位资产占比   
	showChart("5", "3", chartType_pie, "<%=RenderURL5_3%>");
	
	//资产创效 
	
	showChart("6", "1", chartType_Column, "<%=RenderURL6_1%>");
    showChart("6", "2", chartType_Column, "<%=RenderURL6_2%>");
	}
</script>
</head>
<body onload="getFusionChart()"
	style="background: #ffffff; overflow-y: auto">

	<div id="dialog_wrap" style="background: #fff;"></div>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td id='ttt' height="80px"><iframe id="topFrame" name="topFrame"
					title="topFrame" width="100%" height="100%" frameborder="0"
					scrolling="no"
					src="<%=request.getContextPath()%>/common/index/header.srq"></iframe>
			</td>
		</tr>
		<tr>
	</table>


	<div id="_content" align="center" >
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td id='ttt3' height="10"
					style="height:10px;background:#F1F4F9;background-image:url(<%=contextPath%>/css/dms_home/images/yemei-yinying.png); background-position:center top; background-repeat: repeat-x;">
				</td>
			</tr>
		</table>

		<!--  图表行开始 每个table都是一行N列布局 开始 -->
		<!-- 第一部分标题 开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="about"><%=title1%></td>
			</tr>
		</table>
		<!-- 第一部分标题 结束-->
		<!-- 第一个表格开始 -->
		<table width="98%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<!--  第一列图表  开始-->
				<td width="33%" valign="top" >
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td>
					<div class="tongyong_box_title">
							<div>
								<a href="<%=url1_1%>" target="_blank"><%=label1_1%></a>
							</div>
							<div class="focus_tongyong_box_content_left" id="ChartContainer1_1"
								style="height: <%=topDivHight%>px;width: <%=topDivWidth%>;"></div>
						</div>
					</td>
					</tr>
					</table>
						
					
				</td>
				<!-- 第一列图表  结束-->
				<!-- 分隔符开始 -->
				<td width="1%"></td>
				<!-- 分隔符结束 -->
				<!--  第二列图表  开始-->
				<td width="33%" valign="top">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td >
						<div class="tongyong_box_title">
							<a href="<%=url1_2%>" target="_blank"><%=label1_2%></a> 
						</div>
						<div class="focus_tongyong_box_content_left" id="ChartContainer1_2"
							style="height: <%=topDivHight%>;width: <%=topDivWidth%>;" align="center"></div>
							</td>
					</tr>
					</table>
					
				</td>
				<!-- 第二列图表  结束-->
				<!-- 分隔符开始 -->
				<td width="1%"></td>
				<!-- 分隔符结束 -->
				<!-- 第三列图表  开始-->
				<td width="32%" valign="top" >
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td>
						<div class="tongyong_box_title">
							<div>
								<a href="<%=url1_3%>" target="_blank"><%=label1_3%></a> 
							</div>
							<div class="focus_tongyong_box_content_left" id="ChartContainer1_3"
								style="height: <%=topDivHight%>;width: <%=topDivWidth%>;"></div>
						</div>
					</td>
					</tr>
					</table>
				</td>
				<!-- 第三列图表  结束-->
			</tr>
		</table>
		<!--  图表 第一表格 结束 -->
		<!-- 第二个表格  开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<!--  第二表格、第一列图表  开始-->
				<td width="49%">
				<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td>
					
						<div class="tongyong_box_title">
							<div>
								<a href="<%=url2_1%>" target="_blank"><%=label2_1%></a>
							</div>
							<div class="focus_tongyong_box_content_left" id="ChartContainer2_1"
								style="height: <%=topDivHight%>;width: <%=topDivWidth%>;"></div>
						</div>
					
					</td>
					</tr>
					</table>
				</td>
				<!-- 第二表格、第一列图表  结束-->
				<!-- 分隔符开始 -->
				<td width="1%"></td>
				<!-- 分隔符结束 -->
				<!--  第二表格、第二列图表  开始-->
				<td width="49%">
				<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td  align="center">
					
						<div class="tongyong_box_title">
							<a href="<%=url2_2%>" target="_blank"><%=label2_2%></a>
							
						</div>
						<div class="focus_tongyong_box_content_left" id="ChartContainer2_2"  align="center"
							style="height: <%=topDivHight%>;width: <%=topDivWidth%>;"></div>
					
					</td>
					</tr>
					</table>
				</td>
				<!-- 第二表格、第二列图表  结束-->

			</tr>
		</table>
		<!--  第二表格 结束 -->

		<!-- 第二部分标题 开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class="about"><%=title2%></td>
			</tr>
		</table>
		<!-- 第二部分标题 结束-->
		<!-- 第三个表格  开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<!--  第三表格、第一列图表  开始-->
				<td width="49%">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td align="center">
						<div class="tongyong_box_title">
							<div>
								<a href="<%=url3_1%>" target="_blank"><%=label3_1%></a>
							</div>
							<div class="focus_tongyong_box_content_left" id="ChartContainer3_1"
								style="height: <%=topDivHight%>;width: <%=topDivWidth%>;" align="center"></div>
						</div>
					
					</td>
					</tr>
					</table>
				</td>
				<!-- 第三表格、第一列图表  结束-->
				<!-- 分隔符开始 -->
				<td width="1%"></td>
				<!-- 分隔符结束 -->
				<!--  第三表格、第二列图表  开始-->
				<td width="49%">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td align="center">
						<div class="tongyong_box_title">
							<a href="<%=url3_2%>" target="_blank"><%=label3_2%></a>
						</div>
						<div class="focus_tongyong_box_content_left" id="ChartContainer3_2"
							style="height: <%=topDivHight%>;width: <%=topDivWidth%>;" align="center"></div>
					</td>
					</tr>
					</table>
				</td>
				<!-- 第三表格、第二列图表  结束-->

			</tr>
		</table>
		<!--  第三表格 结束 -->

		<!-- 第四个表格  开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<!--  第四表格、第一列图表  开始-->
				<td width="100%">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td align="center">
						<div  id="ChartContainer4_1"
							style="height: '100%';width: <%=midDivWidth%>;" align="center">
							<iframe width="100%" height="500px"
								src="<%=contextPath%>/dmsManager/use/statAnal/mainEquiBasiStat.jsp"></iframe>
						</div>
					</td>
					</tr>
					</table>
				</td>
			</tr>
		</table>
		<!-- 第四个表格  结束-->

		<!-- 第三部分标题 开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="about"><%=title3%></td>
			</tr>
		</table>
		<!-- 第三部分标题 结束-->

		<!-- 第五个表格开始 -->
		<table width="98%" border="0" cellspacing="0" cellpadding="0" >

			<tr>
				<!--  第一列图表  开始-->
				<td width="33%" valign="top">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box" >
					<tr>
					<td align="center">
						<div class="tongyong_box_title">
							<div>
								<a href="<%=url5_1%>" target="_blank"><%=label5_1%></a>
							</div>
							<div class="focus_tongyong_box_content_left" id="ChartContainer5_1"
								style="height: <%=topDivHight%>px;width: <%=topDivWidth%>;"  align="center"></div>
						</div>
					</td>
			</tr>
		</table>
				</td>
				<!-- 第一列图表  结束-->
				<!-- 分隔符开始 -->
				<td width="1%"></td>
				<!-- 分隔符结束 -->
				<!--  第二列图表  开始-->
				<td width="33%" valign="top">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td align="center">
						<div class="tongyong_box_title">
							<a href="<%=url5_2%>" target="_blank"><%=label5_2%></a>
						</div>
						<div class="focus_tongyong_box_content_left" id="ChartContainer5_2"
							style="height: <%=topDivHight%>;width: <%=topDivWidth%>;" align="center"></div>
					</td>
			</tr>
		</table>
				</td>
				<!-- 第二列图表  结束-->
				<!-- 分隔符开始 -->
				<td width="1%"></td>
				<!-- 分隔符结束 -->
				<!-- 第三列图表  开始-->
				<td width="32%" valign="top">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td align="center">
						<div class="tongyong_box_title">
							<div>
								<a href="<%=url5_3%>"  target="_blank"><%=label5_3%>
								</a>
							</div>
							<div class="focus_tongyong_box_content_left" id="ChartContainer5_3"
								style="height: <%=topDivHight%>;width: <%=topDivWidth%>;" align="center"></div>
						</div>
					</td>
			</tr>
		</table>
				</td>
				<!-- 第三列图表  结束-->
			</tr>
		</table>
		<!--  图表 第五表格 结束 -->
		<!-- 第三部分标题 开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="about"><%=title4%></td>
			</tr>
		</table>
		<!-- 第三部分标题 结束-->
		<!-- 第6个表格  开始-->
		<table width="98%" border="0" cellspacing="0" cellpadding="0"
			>
			<tr>
				<!--  第6表格、第一列图表  开始-->
				<td width="49%">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box" >
					<tr>
					<td align="center">
						<div class="tongyong_box_title">
							<div>
								<a href="<%=url6_1%>" target="_blank"><%=label6_1%> 
								</a> 
							</div>
							<div class="focus_tongyong_box_content_left" id="ChartContainer6_1"
								style="height: <%=midDivHight%>;width: <%=midDivWidth%>;" align="center"></div>
						</div>
					</td>
			</tr>
		</table>
				</td>
				<!-- 第6表格、第一列图表  结束-->
				<!-- 分隔符开始 -->
				<td width="1%"></td>
				<!-- 分隔符结束 -->
				<!--  第6表格、第二列图表  开始-->
				<td width="49%">
					<table width="98%" border="0" cellspacing="0" cellpadding="0"  class="focus_tongyong_box">
					<tr>
					<td align="center">
						<div class="tongyong_box_title">
							<a href="<%=url6_2%>"  target="_blank"><%=label6_2%></a>
						</div>
						<div class="focus_tongyong_box_content_left" id="ChartContainer6_2"
							style="height: <%=midDivHight%>;width: <%=midDivWidth%>;" align="center"></div>
					</td>
			</tr>
		</table>
				</td>
				<!-- 第6表格、第二列图表  结束-->

			</tr>
		</table>
		<!--  第6表格 结束 -->
	</div>
</body>


</html>

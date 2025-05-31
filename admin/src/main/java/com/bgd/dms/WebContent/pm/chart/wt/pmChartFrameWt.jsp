<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	List<Map<String,Object>> expMethodList = wm.getProjectWorkMethodWt(projectInfoNo);
	List<String> expMethodStringList = wm.getProjectWorkMethodWtList(projectInfoNo);
	List datalist = wm.getDailyDateAnalysisWt(projectInfoNo,expMethodStringList);
	//int methodSize = expMethodStringList.size();
	Map dailyActivityMap = wm.getDailyActivityWt(projectInfoNo,expMethodStringList);
	//Map dailyCumulativeMap = wm.getDaysCumulativeWt(projectInfoNo,expMethodStringList);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%><html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<title>综合物化探日报数据分析</title>
<script type="text/javascript">

</script>
</head>
<body style="background: #cdddef; overflow-y: auto" >
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<% 
				for(int i=0;i<datalist.size();i++){
					Map map = (Map)datalist.get(i);
					String exMethodName = (String)map.get("exMethodName");
					String xmlData = (String)map.get("xmlData");
					String xmlData2 = (String)map.get("xmlData2");
					String chatInfo = (String)map.get("chatInfo");
					System.out.println(xmlData2);
				%>
								

				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr id="line1">
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#"><%=exMethodName %>日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div   id="chartContainer_<%=i%>_1"  style="height: 300px;overflow-x:hidden">
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#"><%=exMethodName %>累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div   id="chartContainer_<%=i%>_2"    style="height: 300px;overflow-x:hidden">
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
					<tr><td colspan="3"><div class="tongyong_box">
						<div class="tongyong_box_content_left"   id="chartInfo_<%=i %>" style="height: 35px;">
					</div></div></td></tr>
				</table>
				<script type="text/javascript">
				
				cruConfig.contextPath='<%=contextPath%>';
				var myChart1<%=i%> = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1<%=i %>", "100%", "100%", "0", "0" );    
				myChart1<%=i%>.setXMLData('<%=xmlData%>');						
				myChart1<%=i%>.render("chartContainer_<%=i%>_1");
				
				var myChart2<%=i%> = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2<%=i %>", "100%", "100%", "0", "0" );    
				myChart2<%=i%>.setXMLData('<%=xmlData2%>');						
				myChart2<%=i%>.render("chartContainer_<%=i%>_2");

				//alert('<%=chatInfo %>');
				document.getElementById("chartInfo_<%=i%>").innerHTML = '<table boder="0"  ><tr><td  ></td><td  >"<%=chatInfo%>"</td><td  ></td></tr><table>';
				//document.getElementById("chartInfo_<%=i%>").innerHTML = chatInfo;

						
				</script>
				<%
				}
				%>
		

				
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
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


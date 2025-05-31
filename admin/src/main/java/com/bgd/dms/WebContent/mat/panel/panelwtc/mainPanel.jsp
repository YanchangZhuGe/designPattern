<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.ArrayList,java.util.List"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();

	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2002; i--) {
		listYear.add(i);
	}
	 if(user.getSubOrgIDofAffordOrg().equals("C105")){
			request.getRequestDispatcher("/mat/panel/mainPanel.jsp").forward(request,response);
	 }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="<%=contextPath %>\mat\panel\panelwtc\wtcwycz.jsp?orgSubjectionId=<%=orgSubjectionId %>" target="_blank">物探处采集项目产值消耗率</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;overflow: visible;">
						<iframe src="<%=contextPath %>\mat\panel\panelwtc\wtcwycz.jsp?orgSubjectionId=<%=orgSubjectionId %>" marginheight="0" marginwidth="0" style="height:220px;width:100%;"></iframe>
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="<%=contextPath %>/mat/panel/matxiazuan/wuzixiaohao.jsp" target="_blank">各项目物资消耗情况</a>
						<select id="year" name="year" class="" onchange="changeYear()">
							<option value="" >请选择</option>
							<%for(int j=0;j<listYear.size();j++){%>
							<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
							<% } %>
						</select>年
						</div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer2"></div>   
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
						<td>
						<div class="tongyong_box">
							<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="<%=contextPath %>\mat\panel\panelwtc\wtcwzfhl.jsp?orgSubjectionId=<%=orgSubjectionId %>" target="_blank">计划符合率</a></div>
								<div class="tongyong_box_content_left" style="height: 220px;overflow: visible;">
								<iframe src="<%=contextPath %>\mat\panel\panelwtc\wtcwzfhl.jsp?orgSubjectionId=<%=orgSubjectionId %>" marginheight="0" marginwidth="0" style="height:220px;width:100%;"></iframe>
								</div>
							</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">主要物资消耗占比分析</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer4"></div>   
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
<script type="text/javascript">
	function getFusionChart(){
		var year = document.getElementById("year").value;
		var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "ChartId", "100%", "220", "0", "0" );    
		myChart2.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart9.srq?orgSubjectionId=<%=orgSubjectionId%>&year="+year);   
		myChart2.render("chartContainer2"); 
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "ChartId", "100%", "220", "0", "0" );    
		myChart4.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart11.srq?orgSubjectionId=<%=orgSubjectionId%>");       
		myChart4.render("chartContainer4"); 
	}

	function changeYear(){
		var year = document.getElementById("year").value;
		var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "ChartId", "100%", "220", "0", "0" );    
		myChart2.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart9.srq?orgSubjectionId=<%=orgSubjectionId%>&year="+year);   
		myChart2.render("chartContainer2"); 
	}


	 function drillwzzbxh(obj){
	    	popWindow("<%=contextPath%>/mat/panel/panelwtc/matChart4xz.jsp?orgSubjectionId=<%=orgSubjectionId%>&matId="+obj,'800:600');
	    }
</script>  
</body>
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();
	document.getElementById("year").value = "<%=d1%>";
	
	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>


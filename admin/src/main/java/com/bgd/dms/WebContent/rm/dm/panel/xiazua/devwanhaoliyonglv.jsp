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
	String orgstrId = user.getCodeAffordOrgID();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	
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
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>物探处级统计分析</title>
</head>
<body style="background: #cdddef; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备完好率、利用率</a>
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
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
							<%
								}
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
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 100%;">

						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
</div>
</body>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript">
	 cruConfig.contextPath="<%=contextPath%>";
	 function getFusionChart(){
	    
	    //主要设备完好率、利用率(物探处级) -- 先时时统计台账，出这个图
//	    var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "250", "0", "0" );
//	    var s_org_id2 = document.getElementsByName("s_org_id2")[0].value;    
//		myChart2.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompDevRatioChartWTNew.srq?orgstrId=<%=orgstrId%>&drilllevel=1"+"&orgsubId="+s_org_id2);
//		myChart2.render("chartContainer2"); 
		
		var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn2D.swf", "myChartId2", "100%", "250", "0", "0" );    
		myChart2.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompEqChart.srq");      
		myChart2.render("chartContainer2"); 
	}
	 
	 function changeYear(){
		    var chartReference = FusionCharts("myChartId2");     
		    var yearinfo = document.getElementsByName("yearinfo")[0].value;
		    var s_org_id = document.getElementsByName("s_org_id2")[0].value;
		    var orgstrId='<%=orgstrId%>';
		    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWTNew.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&orgsubId="+s_org_id+"&drilllevel=1");
		}
	 function changeOrg2(){
	     var chartReference = FusionCharts("myChartId2");
	     var yearinfo = document.getElementsByName("yearinfo")[0].value;
	     var s_org_id = document.getElementsByName("s_org_id2")[0].value;
	     var orgstrId='<%=orgstrId%>';
	     chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWTNew.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&orgsubId="+s_org_id+"&drilllevel=1");
	}
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


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	user.getSubOrgIDofAffordOrg();
	user.getCodeAffordOrgID();
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
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">万元产值物资消耗率</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer3"></div>  
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">物资消耗占比分析</a></div>
						<div class="tongyong_box_content_left" style="height: 220px;">
									<div id="chartContainer4"></div>   
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
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">物资集中采购度</a></div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="49%">
									<div id="chartContainer2"></div>  
									<p class="small">一级物资网上点击采购率</p>
								</td>
								<td width="1%"></td>
								<td width="49%">
									<div id="chartContainer5"></div> 
									<p class="small">单位二级物资集中采购度</p>  
								</td>
							</tr>
						</table>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="tongyong_box" >
						<div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">物资周转情况</a></div>
						<div class="tongyong_box_content_left">
							<div id="chartContainer5">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
									<tr>
									  	<td class="bt_info_odd" exp="<font size='5'><strong>{kczzcs_zb}</strong></font>" >库存物资周转指标</td>
									  	<td class="bt_info_even" exp="<font size='5'><strong>{kczzcs_sj}</strong></font>">累计库存物资周转次数</td>
									</tr>
								</table>
							</div>   
						</div>
					</div>
				</td>
			</tr>
		</table>
		</td>
		<td width="1%"></td>
	</tr>
</table>
</div>
<script type="text/javascript">
	var showNewTitle = false;
	cruConfig.contextPath = '<%=contextPath%>';
	function getFusionChart(){
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId", "100%", "220", "0", "0" );    
		myChart4.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart1.srq");   
		myChart4.render("chartContainer4"); 
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "ChartId", "100%", "220", "0", "0" );    
		myChart3.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart2.srq");   
		myChart3.render("chartContainer3"); 
		var myChart2 = new FusionCharts( "${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId2", "100%", "220", "0", "0" );    
		myChart2.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChartBI1.srq");      
		myChart2.render("chartContainer2"); 
		var myChart5 = new FusionCharts( "${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId2", "100%", "220", "0", "0" );    
		myChart5.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChartBI2.srq");      
		myChart5.render("chartContainer5"); 
		//var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "100%", "0", "0" );    
		//myChart4.setXMLUrl("<%=contextPath%>/mat/panel/getChart15.srq");      
		//myChart4.render("chartContainer4"); 
	}
	refresh();
	function refresh(){
		cruConfig.pageSize = cruConfig.pageSizeMax;
	    cruConfig.queryStr = "select a.kczzcs_zb,round(a.kczzcs_sj,2)kczzcs_sj from (select * from DM_DSS.F_DP_MATERIEL_KCZZCS@DSSDB.REGRESS.RDBMS.DEV.US.ORACLE.COM t order by t.data_dt desc) a where rownum=1";  
	    queryData(1);
	}
	function renderNaviTable(){
		}
	function createNewTitleTable(){
		return;
	}
    function resizeNewTitleTable(){
		
	}
    function drillwyczxh(obj){
    	popWindow('<%=contextPath%>/mat/panel/wtcwycz.jsp?orgSubjectionId='+obj,'800:600');
    }
    function drillwzxhxh(obj){
    	popWindow('<%=contextPath%>/mat/panel/matChart3xz.jsp?orgSubjectionId='+obj,'800:600');
    }
    function drillwzzbxh(obj){
    	popWindow('<%=contextPath%>/mat/panel/matChart2xz.jsp?matId='+obj,'800:600');
    }
</script>  
</body>

</html>


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
						<td width="49%" colspan="3">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">现场维修费用统计</a>
							<select name='s_org_id7' onchange="changeOrg7()">
							<%
								if("C105".equals(orgId)){
							%>
								<option value="">--请选择--</option>
							<%
								}
								if("C105".equals(orgId)){
								for(int i=0;i<DevUtil.proorgNameList.size();i++){
									String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
								}
								}else{
									for(int i=0;i<DevUtil.proorgNameList.size();i++){
										if(DevUtil.proorgNameList.get(i).indexOf(orgId)>=0){
											String[] tmpstrs = DevUtil.proorgNameList.get(i).split("-");
							%>
								<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
							<%
										}
									}
								}
							%>
							</select>
						</div>
						<div class="tongyong_box_content_left"  id="chartContainer7" style="height: 250px;">
			 
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
		//现场维修数据统计
		var s_org_id7 = document.getElementsByName("s_org_id7")[0].value;  
		var retObj7 = jcdpCallServiceCache("DevCommInfoSrv","getWxCostDataForWutan","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id7);
		var dataXml7 = retObj7.dataXML;
		var myChart7 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId7", "100%", "250", "0", "0" );    
		myChart7.setXMLData(dataXml7);
		myChart7.render("chartContainer7");
		
	}
	 
	 function changeOrg7(){
	     var chartReference = FusionCharts("myChartId7");
	     var s_org_id = document.getElementsByName("s_org_id7")[0].value;
		 var retObj7 = jcdpCallService("DevCommInfoSrv","getWxCostDataForWutan","orgstrId=<%=orgstrId%>&orgsubId="+s_org_id);
		 var dataXml7 = retObj7.dataXML;
		 chartReference.setXMLData(dataXml7);
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


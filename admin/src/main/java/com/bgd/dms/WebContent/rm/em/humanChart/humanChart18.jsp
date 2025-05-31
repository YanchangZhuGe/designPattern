<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
        <%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();

%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>

<div id="chart_CA7E649B28C170F6E0430A15082C70F6" style="width:100%;height:100%;"></div>
<code:codeSelect name='s_team' option="teamOps" addAll="true"  selectedValue='' onchange="changeTeam()"/>
<script type="text/javascript">

var myChartCA7E649B28C170F6E0430A15082C70F6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId1", "100%", "100%", "0", "0" );    
myChartCA7E649B28C170F6E0430A15082C70F6.setXMLUrl("<%=contextPath%>/rm/em/getChart18.srq?projectInfoNo=<%=projectInfoNo%>");        
myChartCA7E649B28C170F6E0430A15082C70F6.render("chart_CA7E649B28C170F6E0430A15082C70F6");  


function changeTeam(){
	 
    var chartReference = FusionCharts("myChartCA7E649B28C170F6E0430A15082C70F6");     
    var s_team = document.getElementsByName("s_team")[0].value;
    chartReference.setXMLUrl("<%=contextPath%>/rm/em/getChart18.srq?projectInfoNo=<%=projectInfoNo%>&team="+s_team);
}

</script> 

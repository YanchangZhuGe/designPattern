<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = request.getParameter("project_info_no");
	if(project_info_no==null ){
		project_info_no = user.getProjectInfoNo();
	}
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id==null ){
		org_subjection_id = "";
	}
%>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="qua_c640c21612a1d08ae0430a15082cd08a"  style="width:100%; height:100%; overflow:auto;"></div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "0");
	var org_subjection_id = '<%=org_subjection_id%>';
	var substr = "name=first&org_subjection_id="+org_subjection_id+"&middle=80&lowerLimit=60";
	if(org_subjection_id!=null && org_subjection_id !='C105'){
		substr = substr + '&wtc=wtc';
	}
	var retObj = jcdpCallServiceCache("QualityChartSrv", "chartByOrg", substr);
	var first ="<Chart bgColor='AEC0CA,FFFFFF' upperLimit='100' lowerLimit='60' majorTMNumber='5' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='105'  gaugeOriginX='140' gaugeOriginY='130' gaugeInnerRadius='25' formatNumberScale='1' numberSuffix='%25' displayValueDistance='20' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1'  pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000'> <colorRange><color minValue='60' maxValue='80' code='FF654F'/> <color minValue='80' maxValue='100' code='8BBA00'/></colorRange> <dials><dial value='80' borderAlpha='0' bgColor='000000' baseWidth='28' topWidth='1' radius='100' rearExtension='1'/> </dials><annotations> <annotationGroup xPos='140' yPos='131.5'> <annotation type='circle' xPos='0' yPos='2.5' radius='115' startAngle='0'  endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='dddddd,666666' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0'  showBorder='1' borderColor='444444' borderThickness='2'/><annotation type='circle' xPos='0' yPos='0' radius='110' startAngle='0' endAngle='180' fillPattern='linear' fillAsGradient='1' fillColor='666666,ffffff' fillAlpha='100,100'  fillRatio='50,50' fillDegree='0' /> </annotationGroup> </annotations></Chart>";
	if(retObj!=null && retObj.returnCode=='0'){
		if(retObj.Str!=null){
			first = retObj.Str;
		}
	}
	//first = decodeURI(decodeURI(first));
	myChart.setDataXML(first);
    myChart.render("qua_c640c21612a1d08ae0430a15082cd08a");
    function orgDetail(name){
		if(name!=null && name=='1'){
			popWindow("<%=contextPath%>/qua/dashboard/multiple/qualified_org.jsp");
		}else if(name!=null && name=='2'){
			popWindow("<%=contextPath%>/qua/dashboard/multiple/first_org.jsp");
		}
	}
    function wtcDetail(name){
    	var org_subjection_id = '';
    	var org_name = '';
    	var sql = " select eps.org_abbreviation org_name ,eps.org_id ,os.org_subjection_id from bgp_comm_org_wtc eps"+
		" join comm_org_subjection os on eps.org_id = os.org_id and os.bsflag = '0'"+
		" where eps.bsflag ='0' and eps.org_subjection_id ='<%=org_subjection_id%>' order by eps.order_num ";
	    var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+"&pageSize="+cruConfig.pageSizeMax);
	    if(retObj!=null && retObj.returnCode=='0'){
	    	if(retObj.datas!=null ){
	    		if(retObj.datas[0].org_subjection_id!=null){
	    			org_subjection_id = retObj.datas[0].org_subjection_id;
	    			org_name = retObj.datas[0].org_name;
	    		}
	    		
	    	}
	    }
		if(name!=null && name=='1'){
			window.open("<%=contextPath%>/qua/dashboard/multiple/qualified_project.jsp?org_subjection_id="+org_subjection_id+"&org_name="+encodeURI(org_name));
		}else if(name!=null && name=='2'){
			window.open("<%=contextPath%>/qua/dashboard/multiple/first_project.jsp?org_subjection_id="+org_subjection_id+"&org_name="+encodeURI(org_name));
		}
	}
</script>



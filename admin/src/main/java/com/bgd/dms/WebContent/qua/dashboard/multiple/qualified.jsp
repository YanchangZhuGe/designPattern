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
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="qua_c640c21612a1d08ae0431a15082cd09a"  style="width:100%; height:100%; overflow:auto;"></div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	var myChart = new FusionCharts("${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId", "100%", "100%", "0", "0");
	var org_subjection_id = '<%=org_subjection_id%>';
	var substr = "name=qualified&org_subjection_id="+org_subjection_id+"&middle=99.6&lowerLimit=99";
	if(org_subjection_id!=null && org_subjection_id !='C105'){
		substr = substr + '&wtc=wtc';
	}
	var retObj = jcdpCallServiceCache("QualityChartSrv", "chartByOrg", substr);
	var first ="";
	if(retObj!=null && retObj.returnCode=='0'){
		if(retObj.Str!=null){
			first = retObj.Str;
		}
	}
	//first = decodeURI(decodeURI(first));
	myChart.setDataXML(first);
    myChart.render("qua_c640c21612a1d08ae0431a15082cd09a");
    function orgDetail(name){
		if(name!=null && name=='1'){
			popWindow("<%=contextPath%>/qua/dashboard/multiple/qualified_org.jsp",'800:600');
		}else if(name!=null && name=='2'){
			popWindow("<%=contextPath%>/qua/dashboard/multiple/first_org.jsp",'800:600');
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



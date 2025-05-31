<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
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
<div id="qua_c640c21612a1d08ae0431a15082cd09a"  style="width:100%; height:100%; overflow:auto;">
	<iframe width="100%" height="100%" name="audit" id="audit" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
	<iframe width="100%" height="100%" name="company_2" id="company_2" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
</div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	var org_subjection_id = '<%=org_subjection_id%>';
	if(org_subjection_id!=null && org_subjection_id =='C105'){
		document.getElementById("company_2").style.display = 'block';
		document.getElementById("audit").style.display = 'none';
		document.getElementById("company_2").src = cruConfig.contextPath + "/qua/dashboard/multiple/audit_company.jsp";
	}else{
		document.getElementById("company_2").style.display = 'none';
		document.getElementById("audit").style.display = 'block';
		document.getElementById("audit").src = cruConfig.contextPath + "/qua/dashboard/multiple/audit_wtc.jsp?org_subjection_id="+org_subjection_id;
	}
</script>
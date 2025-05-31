<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
//地图
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//System.out.print(user.getSubOrgIDofAffordOrg());
%>
<center>
<img alt="" src="<%=contextPath %>/pm/chart/map1.png"  height="100%" onclick="alertChina();" style="cursor: pointer;vertical-align: middle;" />
</center>
<script type="text/javascript">

function alertChina(){
	
	var randomNumber = new Date().getTime();
	//A7地图
	//popWindow('http://10.88.2.240/OMS_Web_GPE/login.do?username=bgp_oa_erp_report&password=bgp_oa_erp_report&requestType=0&addr=/OMS_Web_GPE/gpe/projectReport/projectMap/main.jsp','1024:768');
	
	//BI地图正式环境 20130401
	//popWindow('http://10.88.248.133:7002/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>&random='+randomNumber,'1024:768');
	popWindow('http://10.88.248.131:7001/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>&random='+randomNumber,'1024:768');
	
	//BI地图正式环境
	//popWindow('http://10.88.248.131:7001/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>&random='+randomNumber,'1024:768');

	
	//BI地图测试环境
	//popWindow('http://10.88.248.133:7003/richfit/flexos/index.jsp?orgId=<%=user.getSubOrgIDofAffordOrg() %>&random='+randomNumber,'1024:768');
	
}

</script>  


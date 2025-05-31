<%@page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.oms.webapp.gpe.util.UUIDHexGeneratorReport" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getSubOrgIDofAffordOrg();// 组织机构隶属ID，用户数据过滤
	UUIDHexGeneratorReport geneId = new UUIDHexGeneratorReport();
	String procEName = geneId.generate();
	String oldProcEName = request.getParameter("oldProcEName");
	String oldProcVersion = request.getParameter("oldProcVersion");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>复制流程模板</title>
<style type="text/css">

	/* hide from ie on mac \*/
	html {
		height: 100%;
		overflow: hidden;
	}

	#flashcontent {
		height: 100%;
	}
	/* end hide */

	body {
		height: 100%;
		margin: 0;
		padding: 0;
	}

</style>

<script type="text/javascript">
	
	function getUserName() {
		return "<%=userName%>";
	}
	function getUserId() {
		return "<%=userId%>";
	}
	function getProcEName() {
		return "<%=procEName%>";
	}
	function getOldProcVersion() {
		return "<%=oldProcVersion%>";
	}
	function getOldProcEName() {
		return "<%=oldProcEName%>";
	}
	function returnToList(){
		window.location="<%=contextPath%>/pm/bpm/common/procManagerList.lpmd";
	}
	function showUserSelectArea() {
		var userInfo = {
	        fkValue:"",
	        value:""
	    };
		window.showModalDialog("<%=contextPath%>/common/selectUser.jsp",userInfo);
		thisMovie("ExternalInterfaceExample").UserClickHandler_ForJS(userInfo.fkValue, userInfo.value);
	}
	   
	function thisMovie(movieName) 
	{
		if (navigator.appName.indexOf("Microsoft") != -1) 
		{
			return window[movieName];
		} 
		else 
		{
			return document[movieName];
		}
	}
</script>      
</head>
<body>
	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
             id="ExternalInterfaceExample" width="100%" height="100%"
             codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
         <param name="movie" value="CopyWorkFlowDesigner.swf" />
         <param name="quality" value="high" />
         <param name="bgcolor" value="#869ca7" />
         <param name="allowScriptAccess" value="sameDomain" />
         <param name="wmode" value="opaque" />
         <embed src="CopyWorkFlowDesigner.swf" quality="high" bgcolor="#869ca7"
             width="100%" height="100%" name="ExternalInterfaceExample" align="middle"
             play="true" loop="false" quality="high" allowScriptAccess="sameDomain"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer">
         </embed>
     </object>
</body>

</html>

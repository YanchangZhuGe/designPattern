<%@page contentType="text/html;charset=GBK"%>
<%
	String contextPath = request.getContextPath();
	String procinstId = request.getParameter("procinstId");
	System.out.println("----------------->"+request.getParameter("procinstId"));

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>查看流程模板</title>
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

	function getProcinstId() {
        return "<%=procinstId%>";
    }
	function returnToList(){
		window.location="<%=contextPath%>/pm/bpm/common/procManagerList.lpmd";
	}
</script>

</head>
<body>
	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
             id="ExternalInterfaceExample" width="100%" height="100%"
             codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
         <param name="movie" value="ViewProcInst.swf" />
         <param name="quality" value="high" />
         <param name="bgcolor" value="#869ca7" />
         <param name="allowScriptAccess" value="sameDomain" />
         <embed src="ViewWorkFlowDesigner.swf" quality="high" bgcolor="#869ca7"
             width="100%" height="100%" name="ExternalInterfaceExample" align="middle"
             play="true" loop="false" quality="high" allowScriptAccess="sameDomain"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer">
         </embed>
     </object>
</body>

</html>

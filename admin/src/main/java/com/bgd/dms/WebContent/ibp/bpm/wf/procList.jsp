<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.Map"%>
   <%
     String contextPath=request.getContextPath();
     %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

		<link rel="stylesheet" type="text/css" href="../css/base.css">
		<link rel="stylesheet" type="text/css" href="demo.css">

		<script charset="UTF-8" src="<%=contextPath%>/XorkFlowInfo/js/XiorkFlowWorkSpace.js" language="javascript"></script>
		<script charset="UTF-8" src="<%=contextPath%>/XorkFlowInfo/src/name/xio/util/Array.js" language="javascript"></script>
		<script charset="UTF-8" src="<%=contextPath%>/XorkFlowInfo/src/name/xio/util/String.js" language="javascript"></script>
		<script charset="UTF-8" src="<%=contextPath%>/XorkFlowInfo/src/name/xio/html/Toolkit.js" language="javascript"></script>
		<script charset="UTF-8" src="<%=contextPath%>/XorkFlowInfo/src/name/xio/ajax/Ajax.js" language="javascript"></script>
		<script charset="UTF-8" src="index.js" language="javascript"></script>
		<script charset="UTF-8" src="deleteprocess.js" language="javascript"></script>
		
		
		<script>
		function updateProcess() {
		    name=document.getElementById("procid").value;
             window.open("updateprocess.jsp?procid=" + name, "", "dialogWidth:1000px;dialogHeight:1000px;center:yes;help:no;scroll:no;status:no;resizable:yes;");
           }
		
		</script>
<title>Insert title here</title>
</head>
<body>

查看模板Id：<input name="procid" id="procid" >    <input type="button" onclick="updateProcess()" value="查看">
</body>
</html>
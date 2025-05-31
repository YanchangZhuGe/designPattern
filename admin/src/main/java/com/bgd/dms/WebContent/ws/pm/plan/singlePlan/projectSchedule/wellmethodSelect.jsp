<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title></title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
</head>
<body>
	<div id="new_table_box_content">
		<div id="new_table_box_bg" style="overflow: hidden;">
			<div id="oper_div" style="padding-top: 150px">
				[<a href="<%=contextPath%>/ws/pm/plan/singlePlan/projectSchedule/wellmethod.jsp" >设计井中施工方法</a>]&nbsp;&nbsp;&nbsp;&nbsp;
				[<a href="<%=contextPath%>/ws/pm/plan/singlePlan/projectSchedule/wellmethodUsed.jsp" >实际井中施工方法</a>]
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
</script>
</html>
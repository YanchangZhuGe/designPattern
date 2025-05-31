<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String contextPath = request.getContextPath();
	String costProjectSchemaId=request.getParameter("costProjectSchemaId");
	String projectInfoNo=request.getParameter("projectInfoNo");
%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">


<LINK rel=stylesheet type=text/css href="<%=contextPath%>/css/cn/style.css">
<LINK rel=stylesheet type=text/css href="<%=contextPath%>/css/common.css">
<LINK rel=stylesheet type=text/css href="<%=contextPath%>/css/main.css">
<LINK rel=stylesheet type=text/css href="<%=contextPath%>/css/rt_cru.css">
<LINK rel=stylesheet type=text/css href="<%=contextPath%>/skin/cute/style/style.css">
<LINK rel=stylesheet type=text/css href="<%=contextPath%>/css/calendar-blue.css" media=all>
<LINK rel=stylesheet type=text/css href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css">

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_page.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/prototype_1.5.1.1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<style type="text/css">
.input_width_date_short {
	width:65%;
}
</style>
<script type="text/javascript">
	cruConfig.contextPath = "<%= request.getContextPath()%>";
	
	function submit(){
		var costType=document.getElementById("codeTemplateType").value;
		if(costType==""){
			alert("请选择模板类型");
		}else{
			var submitStr="projectInfoNo=<%=projectInfoNo%>&costType="+costType+"&costProjectSchemaId=<%=costProjectSchemaId%>";
			var retObject=jcdpCallService('OPCostSrv','saveProjectCostByTemplate',submitStr)
			top.frames('list').refreshTreeStore();
			var $parent = top.$;
			$parent('#dialog').remove();
		}
		
	}
</script>
<title>流程审核</title>
</head>
<body class="bgColor_f3f3f3">
<div class="tableWrap">
<table border="0" cellpadding="0" cellspacing="0"  class="table_form" width="100%">
	<tr>
		<td class="rtCRUFdName">费用模板类型</td>
		<td class="rtCRUFdValue">
			<code:codeSelect   name='codeTemplateType' option="costTemplateType" selectedValue=""  addAll="true"/> 
		</td>
		<td class="rtCRUFdName">&nbsp;</td>
		<td class="rtCRUFdValue">&nbsp;
		</td>
	</tr>
</table>
</div>
<div class="ctrlBtn">
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="center">
		<td align="center">
			<input class="btn btn_submit" onclick="submit()" type="button"/>
			<input class="btn btn_close" onclick="newClose()" type="button"/>
		</td>
	</tr>
</table>
</div>

</body>
</html>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();

	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	
	String projectFatherNo=request.getParameter("projectFatherNo")==null?"":request.getParameter("projectFatherNo");
	String projectFatherName=request.getParameter("projectFatherName")==null?"":java.net.URLDecoder.decode(request.getParameter("projectFatherName"),"utf-8");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
</head>
<body>
	<div id="new_table_box_content">
		<div id="new_table_box_bg" style="overflow: hidden;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
					<td class="inquire_item4">项目类型：</td>
					<td class="inquire_form4" id="item0_2">
						<select class="select_width" name="project_type" id="project_type">
							<option value='5000100004000000008'>井中项目</option>
							<option value='5000100004000000001'>陆地项目</option>
							<option value='5000100004000000007'>陆地和浅海项目</option>
							<option value='5000100004000000009'>综合物化探</option>
							<option value='5000100004000000010'>滩浅海地震</option>
						</select>
					</td>
				</tr>
			</table>
			<div id="oper_div">
				<span class="xyb_btn"><a href="#" onclick="next()"></a></span> 
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var orgId="<%=orgId %>";
	var projectFatherNo="<%=projectFatherNo %>";
	var projectFatherName="<%=projectFatherName%>";
	function next(){
		var projectType=document.getElementById('project_type').value;
		window.location = "<%=contextPath%>/ws/pm/project/multiProject/insertProject.jsp?projectFatherName="+encodeURI(encodeURI(projectFatherName))+"&projectFatherNo="+projectFatherNo+"&orgSubjectionId="+orgSubjectionId+"&orgId="+orgId+"&projectType="+projectType;
	}
</script>
</html>
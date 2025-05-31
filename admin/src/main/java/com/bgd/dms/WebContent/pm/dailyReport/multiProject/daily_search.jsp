<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	function refreshData(){
		var ctt = top.frames('list').frames[1];
		var project_name = document.getElementsByName("project_name")[0].value;
		var org_name = document.getElementsByName("org_name")[0].value;
		var project_status = document.getElementsByName("project_status")[0].value;
		var audit_status = document.getElementsByName("audit_status")[0].value;
		var project_type = document.getElementsByName("project_type")[0].value;
		ctt.refreshData(project_name, org_name, project_status, audit_status, project_type, "<%=orgSubjectionId %>");
		newClose();
	}
	//refreshData();
	//newClose();
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">项目名称:</td>
          <td class="inquire_form4"><input name="project_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">项目类型:</td>
          <td class="inquire_form4">
          		<select id="project_type" name="project_type" class="select_width">
          			<option value="">全部</option>
          			<option value='5000100004000000001'>陆地项目</option>
					<option value='5000100004000000007'>陆地和浅海项目</option>
          		</select>
		  </td>
        </tr>
        <tr>
          <td class="inquire_item4">项目状态:</td>
          <td class="inquire_form4"><code:codeSelect cssClass="select_width"   name='project_status' option="projectStatus"  selectedValue=""  addAll="true" /></td>
          <td class="inquire_item4">施工队伍:</td>
          <td class="inquire_form4"><input name="org_name" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">审批状态:</td>
          <td class="inquire_form4">
          		<select id="audit_status" name="audit_status" class="select_width">
          			<option value="">全部</option>
          			<option value="1">待审批</option>
          			<option value="3">审批通过</option>
          			<option value="4">审批不通过</option>
          		</select>
          </td>
          <td class="inquire_item4">&nbsp;</td>
          <td class="inquire_form4">&nbsp;</td>
        </tr>
      </table>
     
    </div>
    <div id="oper_div">
    	<auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
  </div>
</div>
</body>

</html>


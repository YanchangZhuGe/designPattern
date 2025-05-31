<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%> 
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
		var project_year = document.getElementsByName("project_year")[0].value;
		var project_type = document.getElementsByName("project_type")[0].value;
		var is_main_project = document.getElementsByName("is_main_project")[0].value;
		var project_status = document.getElementsByName("project_status")[0].value;
		var org_name = document.getElementsByName("org_name")[0].value;
		var second_main_project = document.getElementsByName("second_main_project")[0].value;
		ctt.refreshData(project_name, project_year, project_type, is_main_project, project_status, org_name, "<%=orgSubjectionId %>",'','',second_main_project);
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
          <td class="inquire_item4">项目年度:</td>
          <td class="inquire_form4"><input name="project_year" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">项目类型:</td>
          <td class="inquire_form4">
          	<input type="hidden" id="project_type" name="project_type" value="5000100004000000009" class="input_width" />
			<select class=select_width name="project_type_name" id="project_type_name" disabled="disabled">
				<option value='5000100004000000009'>综合物化探</option>
			</select>
          </td>
          <td class="inquire_item4">项目状态:</td>
          <td class="inquire_form4"><code:codeSelect cssClass="select_width"   name='project_status' option="projectStatus"  selectedValue=""  addAll="true" /></td>
        </tr>
        <tr>
	        <td class="inquire_item4">项目重要程度:</td>
	          <td class="inquire_form4">
	          	<select class=select_width name=is_main_project  id="is_main_project" >
	          		<option value="">--请选择--</option>
					<option value="0300100008000000001">集团重点</option>
					<option value="0300100008000000002">地区（局）重点</option>
					<option value="0300100008000000005">正常</option>
				</select>
	          </td>
	       	<td class="inquire_item6">二级单位重要程度：</td>
			<td class="inquire_form6">
				<select class=select_width name="second_main_project"  id="second_main_project" >
				    <option value="">--请选择--</option>
					<option value="5110000069000000001">物探处重点</option>
					<option value="5110000069000000002">物探处正常</option>
				</select>
			</td>
        </tr>
        <tr>
          <td class="inquire_item4">施工队伍:</td>
          <td class="inquire_form4"><input name="org_name" class="input_width" type="text" /></td>
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


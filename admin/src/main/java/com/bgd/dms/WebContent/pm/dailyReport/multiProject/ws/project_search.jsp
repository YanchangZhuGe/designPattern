<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%> 
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
	$(function(){
	    $("#project_type").change(function(){
	        if("5000100004000000008"==this.value){
	            $("#view_type_text").css('display','block'); 
	            $("#view_type_name").css('display','block'); 
	        }else{
	        	$("#view_type_text").css('display','none'); 
	            $("#view_type_name").css('display','none'); 
			}
	    })
	})
	
	function refreshData(){
		var ctt = top.frames('list').frames[1];
		var project_name = document.getElementsByName("project_name")[0].value;
		var project_year = document.getElementsByName("project_year")[0].value;
		var project_type = document.getElementsByName("project_type")[0].value;
		var is_main_project = document.getElementsByName("is_main_project")[0].value;
		var project_status = document.getElementsByName("project_status")[0].value;
		var org_name = document.getElementsByName("org_name")[0].value;
		var exploration_method = document.getElementsByName("exploration_method")[0].value;
		var view_type = document.getElementsByName("view_type")[0].value;
		ctt.refreshData(project_name, project_year, project_type, is_main_project, project_status, org_name, "<%=orgSubjectionId %>", exploration_method,view_type);
		newClose();
	}
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
          	<select class="select_width" name="project_type" id="project_type">
          		<option value="">--请选择--</option>
				<option value='5000100004000000008'>井中项目</option>
				<option value='5000100004000000001'>陆地项目</option>
				<option value='5000100004000000007'>陆地和浅海项目</option>
				<option value='5000100004000000009'>综合物化探</option>
				<option value='5000100004000000010'>滩浅海地震</option>
			</select>
          </td>
          <td class="inquire_item4">项目重要程度:</td>
          <td class="inquire_form4"><code:codeSelect cssClass="select_width"   name='is_main_project' option="isMainProject"   selectedValue=""  addAll="true" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">项目状态:</td>
          <td class="inquire_form4"><code:codeSelect cssClass="select_width"   name='project_status' option="projectStatus"  selectedValue=""  addAll="true" /></td>
          <td class="inquire_item4">施工队伍:</td>
          <td class="inquire_form4"><input name="org_name" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">勘探方法:</td>
          <td class="inquire_form4">
          	<select class=select_width name=exploration_method  id="exploration_method" >
          			<option value="">--请选择--</option>
					<option value="0300100012000000002">二维地震</option>
					<option value="0300100012000000003">三维地震</option>
					<option value="0300100012000000023">四维地震</option>
					<option value="0300100012000000028">多波</option>
			</select>
		  </td>
          <td class="inquire_item4"><div id="view_type_text" style="display:none;">观测类型:</div></td>
          <td class="inquire_form4"><div id="view_type_name" style="display:none;"> 
          	<select class=select_width name=view_type  id="view_type" >
          			<option value="">--请选择--</option>
					<option value="5110000053000000001">零偏VSP（Zero offset-VSP）</option>
					<option value="5110000053000000002">非零偏VSP（Offset-VSP）</option>
					<option value="5110000053000000003">Walkaway-VSP</option>
					<option value="5110000053000000004">Walkaround-VSP</option>
					<option value="5110000053000000005">3D-VSP</option>
					<option value="5110000053000000006">微地震井中监测</option>
					<option value="5110000053000000007">微地震地面监测</option>
					<option value="5110000053000000008">井间地震</option>
					<option value="5110000053000000009">随钻地震</option>
			</select></div>
		  </td>
          <td class="inquire_form4">&nbsp;</td>
        </tr>
      </table>
     
    </div>
    <div ic="oper_div">
     	<span class="tj"><a href="#" onclick="refreshData()"></a></span>
        <span class="gb"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>
<script type="text/javascript">

</script>

</html>


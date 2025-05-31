<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String projectType=request.getParameter("projectType")==null?"":request.getParameter("projectType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script language="javaScript">
	function refreshData(){
		var ctt = top.frames('list').frames[1];
		var project_name = document.getElementsByName("project_name")[0].value;
		var is_main_project = document.getElementsByName("is_main_project")[0].value;
		var org_name = document.getElementsByName("org_name")[0].value;
		ctt.refreshData(project_name, "", "<%=projectType%>", is_main_project, "", org_name, "<%=orgSubjectionId %>", "","");
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
          <td class="inquire_item4">项目重要程度:</td>
          <td class="inquire_form4"><code:codeSelect cssClass="select_width"   name='is_main_project' option="isMainProject"   selectedValue=""  addAll="true" /></td>
        </tr>
        
        <tr>
          <td class="inquire_item4">施工队伍:</td>
          <td class="inquire_form4"><input name="org_name" class="input_width" type="text" /></td>
          <td class="inquire_item4"></td>
          <td class="inquire_form4"></td>
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
<script language="javaScript">
var projectType="<%=projectType%>";
//根据传递不同项目类型参数 加载项目类型下拉框(zs修改)
var typeId=projectType.split(",");
for(var i=0;i<typeId.length;i++){
	querySql = "select t.coding_code_id,t.coding_name from comm_coding_sort_detail t where t.coding_code_id='"+typeId[i]+"' and t.bsflag='0'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas!=null && datas.length>0){
		$("#project_type").append("<option value='"+typeId[i]+"'>"+datas[0].coding_name+"</option>");
	}
}
</script>
</html>

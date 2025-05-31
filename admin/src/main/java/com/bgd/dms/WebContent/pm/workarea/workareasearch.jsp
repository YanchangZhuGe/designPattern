<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
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
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function refreshData(){
		var workarea_name = document.getElementsByName("workarea_name")[0].value;
		var start_year= document.getElementById("start_year").value;
		var basin= document.getElementById("basin").value;
		var surface_type= document.getElementById("surface_type").value;
		
		var s_filter = "";
		if(workarea_name!=""){
				s_filter = " and workarea like'%"+workarea_name+"%'";
		}
		if(start_year!=""){
			s_filter = s_filter + " and start_year='"+start_year+"'";
		}
		if(basin!=""){
			s_filter = s_filter + " and basin like'%"+basin+"%'";
		}
		if(surface_type!="" && surface_type!="0"){
			s_filter = s_filter + " and surface_type like'%"+surface_type+"%'";
		}
		
		if(s_filter.length > 0){
			s_filter = s_filter.substr(4);
		}
		top.frames('list').refreshData(s_filter);
		newClose();
	}
	
	function loadData(){
		var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");
		var selectTag = document.getElementById("surface_type");
		var itemAll = new Option("所有","0");
		selectTag.add(itemAll);
		if(retObj.surfaceType != null){
			for(var i=0;i<retObj.surfaceType.length;i++){
				var record = retObj.surfaceType[i];
				var item = new Option(record.coding_name.replace(/\-/g,"&nbsp;"),record.coding_code_id);
				selectTag.add(item);
			}
		}
	}
	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3" onload="loadData();">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">工区名称:</td>
          <td class="inquire_form4"><input name="workarea_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">年度:</td>
          <td class="inquire_form4"><input id="start_year" name="start_year" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">盆地:</td>
          <td class="inquire_form4"><input id="basin" name="basin" class="input_width" type="text" /></td>
          <td class="inquire_item4">地表类型:</td>
          <td class="inquire_form4"><select id="surface_type" class="select_width"></select></td>
        </tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="refreshData()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>
</html>


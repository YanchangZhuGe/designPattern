<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_id = request.getParameter("project_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>多项目-设备台账管理-可控震源查询-项目施工履历基本页面</title> 
 </head> 
  <body style="background:#F1F2F3;width:98%" onload="refreshData()">
  <input type="hidden" name="export_name"  id="export_name" value="施工履历基本信息"/>
      	<div id="list_table">
      	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			</table>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" >		
			     <tr>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{local_temp_low}℃">夜间气温</td>
					<td class="bt_info_even" exp="{local_temp_height}℃">白天气温</td>
					<td class="bt_info_odd" exp="{projecter}">项目长/组长</td>
					<td class="bt_info_even" exp="{work_hour}h">工作时刻</td>
					<td class="bt_info_even" exp="{surface}">主要地表特征</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
		 </div>
</body>
 
<script type="text/javascript">

$(function(){
	$(window).resize(function(){
		
		if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.75);
		}
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-10);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	});
})

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	var project_id = "<%=project_id%>";

	function refreshData(){
		  var str =" select pro.project_name,p.local_temp_low,p.work_hour,p.projecter,p.local_temp_height, p.surface from gms_device_zy_project p left join gp_task_project pro on pro.project_info_no=p.project_info_id left join comm_coding_sort_detail d on d.coding_code_id=p.surface where  p.project_info_id='"+project_id+"'";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
</script>
</html>
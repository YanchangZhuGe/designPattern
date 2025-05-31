<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	
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

  <title>生产接口</title> 
 </head>
<body style="background:#fff" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width: 100%">
    <div id="new_table_box_bg" style="width: 95%">
      
	  
	<div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="left">
		    <td class="inquire_item6" >项目ID</td>
			<td class="inquire_form6"><input name="project_info" id="project_info" class="input_width" type="text"  /></td>
			<td class="inquire_item6" >日期</td>
			<td class="inquire_form6"><input name="date_info" id="date_info" class="input_width" type="text"  /></td>
			</tr>
		  </table>
	  </div>
	  <fieldset><legend></legend>
	  	<div style="height:335px;overflow:auto">
	  	<table id="queryRetTable" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
			  <tr>  
			  	  <td class="bt_info_odd">类型</td>
				  <td class="bt_info_even">总数</td>
				  <td class="bt_info_odd">出勤数</td>
				  
			  </tr>
			  <tbody id="assign_body"></tbody>
		  </table>
		 </div>
	</fieldset>
	
	</div>
	  	
			  <div id="oper_div" style="margin-bottom:5px">
			 	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
			    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			  </div>
		
  </div>
	   
</div>
</form>
</body>
<script type="text/javascript"> 
	
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	function submitInfo(){
		if(!checks())
		{	
			return false;
		}
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveDeviceRepairInfo.srq?state=9&ids="+dev_appdet_id;
			document.getElementById("form1").submit();
			//var ctt = parent.frames('list').frames;	  
			//ctt.loadDataDetail(dev_appdet_id);

		}
	}
	function loadDataDetail(){
		//通过查询结果动态填充使用情况select;
		var projectInfoNo='<%=projectInfoNo%>';
		retObj = jcdpCallService("DevCommInfoSrv", "getKqInteface", "projectInfoNo="+projectInfoNo+"&dateinfo=2012-02-01");
		var size = $("#assign_body", "#new_table_box_bg").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#new_table_box_bg").children("tr").remove();
		}
		var kq_body1 = $("#assign_body", "#new_table_box_bg")[0];
		if (retObj.group != undefined) {
			for(var i=0;i<retObj.group.length;i++){
				
				var newTr=kq_body1.insertRow()
				
				
				newTd=newTr.insertCell();
				newTd.innerText=retObj.group[i].devtype; 
				var newTd1=newTr.insertCell();
				newTd1.innerText=retObj.group[i].zs; 
				var newTd2=newTr.insertCell();
				newTd2.innerText=retObj.group[i].devnum; 
				
			}
		}
		
		$("#assign_body>tr:odd>td:odd", '#new_table_box_bg').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#new_table_box_bg').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#new_table_box_bg').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#new_table_box_bg').addClass("even_even");
	}
</script>
</html>
 
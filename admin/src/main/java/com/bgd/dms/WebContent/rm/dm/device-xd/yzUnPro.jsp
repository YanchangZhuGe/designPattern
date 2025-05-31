<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String operation_info_id=request.getParameter("operation_info_id");
	String dev_appdet_id = request.getParameter("ids");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>运转记录</title> 
 </head>
<body style="background:#fff" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" >
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset><legend>设备信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  <tr>
					    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
		  </tr>
		  <tr>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
		  </tr>
		   <tr>
			<td class="inquire_item6">ERP设备编号</td>
			<td class="inquire_form6">
				<input id="dev_coding" name="dev_coding"  class="input_width" type="text" readonly/>
			</td>
		  </tr>
		  </table>
		  </fieldset>
		  <fieldset><legend>运转记录</legend>
		  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">里程(公里)</td>
			<td class="inquire_form6">
				<input id="mileage" name="mileage"  class="input_width" type="text" />
			<td class="inquire_item6">钻井进尺(米)</td>
			<td class="inquire_form6">
				<input id="drilling_footage" name="drilling_footage"  class="input_width" type="text" />
			</td>
		  </tr>
		  <tr>
		 	
		  	<td class="inquire_item6">工作小时(小时)</td>
			<td class="inquire_form6"><input id="work_hour" name="work_hour"  class="input_width" type="text" /></td>
			<td class="inquire_item6">填报时间</td>
				<td class="inquire_form6">
					<input type="text" name="modify_date" id="modify_date" value="" readonly="readonly" class="input_width"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(modify_date,tributton1);" />
				</td>
		  </tr>
		  
	  </table>
	  
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
	var dev_appdet_id='<%=dev_appdet_id%>';
	var operation_info_id='<%=operation_info_id%>';
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	function submitInfo(){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(document.getElementById("mileage").value != "")
		{
			if(!re.test(document.getElementById("mileage").value)){
				alert("里程必须为数字");
				document.getElementById("mileage").value = "";
				return;
			}
		}

		if(document.getElementById("drilling_footage").value != "")
		{
			if(!re.test(document.getElementById("drilling_footage").value)){
				alert("钻井进尺必须为数字");
				document.getElementById("drilling_footage").value = "";
				return;
			}
		}

		if(document.getElementById("work_hour").value != "")
		{
			if(!re.test(document.getElementById("work_hour").value)){
				alert("工作小时必须为数字");
				document.getElementById("work_hour").value = "";
				return;
			}
		}
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/bgpCommDeviceOperationUnInfo.srq?state=9&ids="+dev_appdet_id;
			document.getElementById("form1").submit();
		}
	}

	

	function loadDataDetail(){
		
		   var today = new Date();   
		   var day = today.getDate();   
		   var month = today.getMonth() + 1;   
		   var year = today.getYear();    
		   var date = year + "-" + month + "-" + day;   
		   document.getElementById("modify_date").value = date;   

		if(operation_info_id=="null"){
			var querySql="select dui.* from gms_device_account_unpro dui where dui.dev_acc_id='"+dev_appdet_id+"'" ;
			
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
// 			$("#mileage")[0].value=basedatas[0].mileage;
// 			$("#drilling_footage")[0].value=basedatas[0].drilling_footage;
// 			$("#work_hour")[0].value=basedatas[0].work_hour;
// 			$("#modify_date")[0].value=basedatas[0].modify_date;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#dev_coding")[0].value=basedatas[0].dev_coding;
			
		}else{
			var querySql="select info.*,dui.dev_name,dui.dev_coding,dui.dev_model,dui.self_num,dui.license_num from GMS_DEVICE_OPERATION_INFO info left join Gms_Device_Account_Unpro dui on dui.dev_acc_id=info.dev_acc_id where info.operation_info_id='"+operation_info_id+"'" ;
			
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			
			$("#mileage")[0].value=basedatas[0].mileage;
			$("#drilling_footage")[0].value=basedatas[0].drilling_footage;
			$("#work_hour")[0].value=basedatas[0].work_hour;
			$("#modify_date")[0].value=basedatas[0].modify_date;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#dev_coding")[0].value=basedatas[0].dev_coding;
		}
			
	}
	
</script>
</html>
 
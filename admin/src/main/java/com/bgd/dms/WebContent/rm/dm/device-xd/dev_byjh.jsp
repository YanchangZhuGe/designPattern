<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
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
  <title>设备保养计划制定</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" >
  <div id="new_table_box_content">
    <div id="new_table_box_bg" >
      <fieldset><legend>设备信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
			</td>
		  </tr>
		  <tr>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
		  </tr>
	  </table>	  
	  </fieldset>
	  <fieldset><legend>保养计划制定</legend>
		  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">累计里程(公里)</td>
			<td class="inquire_form6">
				<input id="mileage" name="mileage"  class="input_width" type="text" />
			<td class="inquire_item6">累计钻井进尺(米)</td>
			<td class="inquire_form6">
				<input id="drilling_footage" name="drilling_footage"  class="input_width" type="text" />
			</td>
		  </tr>
		  <tr>		 	
		  	<td class="inquire_item6">累计工作小时(小时)</td>
			<td class="inquire_form6"><input id="work_hour" name="work_hour"  class="input_width" type="text" /></td>
			<td class="inquire_item6">保养周期</td>
			<td class="inquire_form6">
				<select id="maintenance_cycle" name="maintenance_cycle" class="select_width"></select>
			</td>
		  </tr>
		   <tr>		 	
			<td class="inquire_item6">保养截止日期</td>
			<td class="inquire_form6" ><input name="timesheet_date" id="timesheet_date" class="input_width" type="text" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(timesheet_date,tributton3);"/>
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
	
	function submitInfo(){
		var maintenance_cycle = $("option:selected","#maintenance_cycle").text();
		if(document.getElementById("mileage").value == ""&&document.getElementById("drilling_footage").value==""&&document.getElementById("work_hour").value==""&&maintenance_cycle=="")
		{
			alert("必须选择一个保养类型！");
			return;
		}
		
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
	var timesheet_date=document.getElementById("timesheet_date").value;
	
	if(timesheet_date==""||timesheet_date==null)
		{
			alert("请选择保养截止日期!");
			return;
		}
		
		if(confirm("提交后数据不能修改，确认提交？")){
			//保养计划提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/savebyjhUnProInfo.srq?ids="+dev_appdet_id+"&byzq="+maintenance_cycle;
			document.getElementById("form1").submit();
		}
	}

	function loadDataDetail(){
		 var today = new Date();   
		   var day = today.getDate();   
		   var month = today.getMonth() + 1;   
		   var year = today.getYear()+1;    
		   var date = year + "-" + month + "-" + day;   
		   document.getElementById("timesheet_date").value = date;   
		var retObj,queryRet;
		//回填保养周期 liujb 2012-9-26
		var bysql = "select coding_name,coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000040' order by coding_show_id";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+bysql);
		retObj = queryRet.datas;
		if(retObj!=undefined && retObj.length>=1){
			//回填信息
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='byzq' id='byzq"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#maintenance_cycle").append(optionhtml);
		}
			var querySql="select dev_name,dev_model,self_num,license_num from gms_device_account_unpro pro where dev_acc_id='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
	}
	
</script>
</html>
 
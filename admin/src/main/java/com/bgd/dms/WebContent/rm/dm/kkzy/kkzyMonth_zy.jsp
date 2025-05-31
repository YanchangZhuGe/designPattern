<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String projectInfoNo=user.getProjectInfoNo();
	//保存结果 1 保存成功
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String info = null;
	if(respMsg!=null&&respMsg.getValue("info") != null){
		info = respMsg.getValue("info");
	}
    java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM");   
    String nowMonth=f.format(c.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title></title>
<style type="text/css">
#new_table_box_content {
width:auto;
height:888px;
border:1px #999 solid;
background:#cdddef;
padding:15px;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
	<div id="new_table_box" style="width: 100%">
		<div id="new_table_box_content" style="width: 100%;height: 100%">
			<div id="new_table_box_bg" style="width: 95%">
			<input id="projectInfoNo" name="projectInfoNo" type ="hidden"  value="<%=projectInfoNo%>"/>
			<input id="project_id" name="project_id" type ="hidden"  value=""/>
			<input id="local_temp" name="local_temp" type ="hidden"  value=""/>
				<fieldset><legend>项目信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		    <tr>
					  <td class="inquire_item6">填报月份：</td>
					<td class="inquire_form6" >
					<input id="fill_month" name="fill_month"  class="input_width" type="text"  value="<%=nowMonth %>" readonly onchange="check();"/>	
				<img src="/gms4/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(fill_month,tributton1);" />
					</td>
					  <td class="inquire_item6">组合方式：</td>
					<td class="inquire_form6" >
					<input id="combination" name="combination"  class="input_width" type="text"  />	<font   color=red>*</font>
					</td>
			</tr>
			  <tr>
								<td class="inquire_item6">本月最低气温</td>
								<td class="inquire_form6"><input id="local_temp_low"
									name="local_temp_low" class="input_width" type="text" />°C<font color=red>*</font></td>
								<td class="inquire_item6">本月最高气温</td>
								<td class="inquire_form6"><input id="local_temp_height"
									name="local_temp_height" class="input_width" type="text"
									onkeyup="this.value=this.value.replace(/\D/g,'')"
									onafterpaste="this.value=this.value.replace(/\D/g,'')" />°C<font color=red>*</font></td>
							</tr>
		    <tr>
					    <td class="inquire_item4">重要信息:</td>
					    	<td class="inquire_form6" >
					<input id="import_info" name="import_info"  class="input_width" type="text"  />	
					</td>
					 <td class="inquire_item4">本月主要在用的油水的型号、规格:</td>
					    	<td class="inquire_form6" >
					<input id="ilo_info" name="ilo_info"  class="input_width" type="text"  />	<font   color=red>*</font>
					</td>
			</tr>
			  <tr>
		     <td class="inquire_item4">人员动态信息:</td>
		    <td class="inquire_form4" colspan="3">
          <textarea id="person_info" name="person_info"  class="textarea" ></textarea>
          </td>
			</tr>
				  <tr>
		     <td class="inquire_item4">项目组的主要通讯地点、电话、邮件:</td>
		    <td class="inquire_form4" colspan="3">
          <textarea id="project_address" name="project_address"  class="textarea" ></textarea><font  color=red>*</font>
          </td>
			</tr>
	  </table>	  
	  </fieldset>
	  <fieldset><legend>可控震源信息</legend>
	    <div style="overflow:auto">
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
		       	  <td  class="bt_info_odd" ><input type='checkbox' id='hirechecked' name='hirechecked'/></td>
					<td  align="center" style='width:5%' class="bt_info_even">序号</td>
					<td align="center"  style='width:7%' class="bt_info_even">自编号</td>
					<td align="center"  style='width:10%' class="bt_info_odd" >设备型号</td>
					<td align="center"  style='width:15%' class="bt_info_even">控制箱体型号及版本号</td>
					<td align="center"  style='width:15%' class="bt_info_even">DGPS型号及版本号</td>
					<td  align="center"  style='width:10%' class="bt_info_even">本月工作小时</td>
					<td align="right"  style='width:10%' class="bt_info_even">累计工作小时</td>
					<td align="right"  style='width:10%' class="bt_info_even">性能描述</td>
					<td align="center"  style='width:15%' class="bt_info_even">备注</td>
				</tr>
				</table>
			   <div style="height:290px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
	  </fieldset>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
			
			</div>
		</div>
	</div>
	</div>
</form>
</body>
<script type="text/javascript">

	function frameSize() {
	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
function submitInfo()
{
	var combination = $("#combination").val();
	var ilo_info = $("#ilo_info").val();
	var project_address = $("#project_address").val();
	
	if(combination==""||project_address==""||ilo_info=="")
		{
		alert("请输入项目基本信息!");
		return;
		}
	
	//保留的行信息
	var count = 0;
	var line_infos;
	$("input[type='checkbox'][name='idinfo']").each(function(){
		if(this.checked){
			if(count == 0){
				line_infos = this.id;
			}else{
				line_infos += "~"+this.id;
			}
			count++;
		}
	});
	if(count == 0){
		alert('请录入可控震源信息！');
		return;
	}
	var selectedlines = line_infos.split("~");
	var wronglineinfos = "";
	for(var index=0;index<selectedlines.length;index++){
		var control_box = $("#control_box"+selectedlines[index]).val();
		var dgps_type = $("#dgps_type"+selectedlines[index]).val();
		var work_hour = $("#work_hour"+selectedlines[index]).val();
		var work_m_hour = $("#work_m_hour"+selectedlines[index]).val();
		if(work_hour == "" || work_m_hour == "" ){
			if(index == 0){
				wronglineinfos += (parseInt(selectedlines[index])+1);
			}else{
				wronglineinfos += ","+(parseInt(selectedlines[index])+1);
			}
		}
	}
	if(wronglineinfos!=""){
		alert("请设置第"+wronglineinfos+"行明细信息!");
		return;
	}
	
	
	
	document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveMonthInfo.srq?count="+count+"&line_infos="+line_infos;
	document.getElementById("form1").submit();
}

function refreshData()
{
	if('<%=info%>'!='null')
		{
		alert('<%=info%>');
		}
	if('<%=projectInfoNo%>'!='null')
		{
		var sql = "select project_status from gp_task_project p where p.project_info_no='<%=projectInfoNo%>'";
		var retObj1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
		if(retObj1!=null && retObj1.datas[0].project_status=='5000100001000000003'){
			// document.getElementById( "oper_div").style.display= "none";
		}
		}
	var baseData;
	 baseData = jcdpCallService("DevInsSrv", "getzyMonthReport", "");
	 if(baseData.projectMap!=null)
		 {
		$("#construction_method").val(baseData.projectMap.construction_method);
		$("#construction_parameter").val(baseData.projectMap.construction_parameter);
		$("#project_address").val(baseData.projectMap.project_address);
		$("#ilo_info").val(baseData.projectMap.ilo_info);
		$("#project_address").val(baseData.projectMap.project_address);
		$("#combination").val(baseData.projectMap.combination);
		$("#import_info").val(baseData.projectMap.import_info);
		$("#person_info").val(baseData.projectMap.person_info);
		$("#local_temp_height").val(baseData.projectMap.local_temp_height);
		$("#local_temp_low").val(baseData.projectMap.local_temp_low);
		 }
	 if(baseData.datas!=null)
		{
		 var a=1;
		for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
			innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[tr_id].dev_acc_id+"' size='16'  type='hidden' />";
			innerhtml += "<input name='sgll_id"+tr_id+"' id='sgll_id"+tr_id+"' value='"+baseData.datas[tr_id].sgll_id+"' size='16'  type='hidden' />";
			innerhtml += "<td style='width:6%'>"+a+	"</td>";
			innerhtml += "<td style='width:7%'><input name='self_num"+tr_id+"'  style='width:100%' id='self_num"+tr_id+"' value='"+baseData.datas[tr_id].self_num+"' size='9' /></td>";
			innerhtml += "<td style='width:10%'><input name='dev_model"+tr_id+"' style='width:100%'  id='dev_model"+tr_id+"' value='"+baseData.datas[tr_id].dev_model+"' size='9' /></td>";
			innerhtml += "<td style='width:15%'><input name='control_box"+tr_id+"' style='width:100%' id='control_box"+tr_id+"' value='"+baseData.datas[tr_id].control_box+"' size='24' /></td>";
			innerhtml += "<td style='width:15%'><input name='dgps_type"+tr_id+"' id='dgps_type"+tr_id+"' style='width:100%' value='"+baseData.datas[tr_id].dgps_type+"' size='24' /></td>";
			innerhtml += "<td style='width:10%'><input name='work_m_hour"+tr_id+"' style='width:100%' id='work_m_hour"+tr_id+"' onblur='checkSelf("+tr_id+")' value='"+baseData.datas[tr_id].work_m_hour+"' size='16' /></td>";
			innerhtml += "<td style='width:10%'><input name='work_hour"+tr_id+"' id='work_hour"+tr_id+"' value='"+baseData.datas[tr_id].work_hour+"' style='width:100%' size='16' onblur='checkSelf("+tr_id+")' /></td>";
			var name="performance_desc"+tr_id;
			if(baseData.datas[tr_id].performance_desc=="" ||baseData.datas[tr_id].performance_desc=='良好'){
				innerhtml += "<td style='width:10%'  align='left'><select id='"+name+"'     name='"+name+"'   > <option value='良好' selected>良好</option><option value='待查' >待查</option> <option value='待修' >待修</option></select> </td>";
			}else if(baseData.datas[tr_id].performance_desc=='待查'){
				innerhtml += "<td style='width:10%'  align='left'><select  id='"+name+"'     name='"+name+"'   > <option value='良好' >良好</option><option value='待查' selected >待查</option> <option value='待修' >待修</option></select> </td>";
			}else if(baseData.datas[tr_id].performance_desc=='待修'){
				innerhtml += "<td style='width:10%'  align='left'><select id='"+name+"'     name='"+name+"'     > <option value='良好' >良好</option><option value='待查' >待查</option> <option value='待修' selected >待修</option> </select></td>";
			}
			
			innerhtml += "<td style='width:15%'><input name='bak"+tr_id+"' id='bak"+tr_id+"' style='width:100%' value='' size='16' value='"+baseData.datas[tr_id].bak+"'  /></td>";
			a++;
			$("#processtable0").append(innerhtml);
			}
	
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
		}
	 
	 


	 
}


function check()
{
	var fill_month=document.getElementById("fill_month").value;
	var fill_month1="";
	var strs= new Array(); //定义一数组 
	strs=fill_month.split("-"); //字符分割 
	fill_month1=strs[0]+"-"+strs[1];
	document.getElementById("fill_month").value=fill_month1;
}
function checkSelf(num)
{
	var work_hour=document.getElementById("work_hour"+num).value;
	var work_m_hour=document.getElementById("work_m_hour"+num).value;
	//只能输入数字
	 var re = /^[0-9]+[0-9]*]*$/;   
	 if(work_hour.length>0)
		 {
    if (!re.test(work_hour))   
   	{   
        alert("请输入数字!");   
        document.getElementById("work_hour"+num).value="";
        document.getElementById("work_hour"+num).focus();   
       return false;   
    }
		 }
    if(work_m_hour.length>0)
	 {
	if (!re.test(work_m_hour))   
	{   
   alert("请输入数字!");   
   document.getElementById("work_m_hour"+num).value="";
   document.getElementById("work_m_hour"+num).focus();   
  return false;   
	}
	if(work_hour!="")
		{
	  if(Number(work_m_hour)>Number(work_hour))
		  {
		  alert("累计工作小时必须大于当月工作小时!");   
		   document.getElementById("work_hour"+num).value="";
		   document.getElementById("work_hour"+num).focus();   
		  return false;
		  }
	}
	 }
  
}


</script>
</html>
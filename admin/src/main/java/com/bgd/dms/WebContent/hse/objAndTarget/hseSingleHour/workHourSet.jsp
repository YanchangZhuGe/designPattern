<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubjectionId = user.getOrgSubjectionId();
	String projectInfoNo = user.getProjectInfoNo();
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_workhour_id" name="hse_workhour_id" value=""/>
<input type="hidden" id="project_info_id" name="project_info_id" value="<%=user.getProjectInfoNo()%>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table id="hourTable" width="100%" border="1" bordercolor="black" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					 <tr>
				    	<td class="inquire_item6">项目名称：</td>
				      	<td class="inquire_form6" colspan="3"><span id="project_name"><%=user.getProjectName() %></span></td>
				      	<td class="inquire_item6"><font color="red">*</font>开始统计时间：</td>
				      	<td class="inquire_form6" colspan="2"><input type="text" id="start_date" name="start_date" class="input_width"   value=""/>
				      		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_date,tributton1);" />&nbsp;
				      	</td>
				     </tr>
				     <tr align="center">
				     	<td >作业性质：</td>
				      	<td >24小时</td>
				      	<td >16小时</td>
					    <td >12小时</td>
					    <td >8小时</td>
					    <td >4小时</td>
					    <td >2小时</td>
					  </tr>
					  <tr>
					  	<td>员工数量</td>
					  	<td><input type="text" id="people_num_1" name="people_num_1" value=""></input></td>
					  	<td><input type="text" id="people_num_2" name="people_num_2" value=""></input></td>
					  	<td><input type="text" id="people_num_3" name="people_num_3" value=""></input></td>
					  	<td><input type="text" id="people_num_4" name="people_num_4" value=""></input></td>
					  	<td><input type="text" id="people_num_5" name="people_num_5" value=""></input></td>
					  	<td><input type="text" id="people_num_6" name="people_num_6" value=""></input></td>
					  </tr>
					  <tr id="relaxRow" valign="top" align="center">
					  	<td valign="center">休息状况：</td>
					  </tr>
					  <tr>
					  	<td>工时</td>
					  	<td colspan="6"></td>
					  </tr>
					</table>
				</div>
				
				<table>
					<tr>
						<td width="850px" align="center">
							<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
							<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
						</td>
						<td width="83px" align="right">
							<span class="jstj_btn"><a href="#" onclick="stopWorkHour()"></a></span>
						</td>
					</tr>
				</table>
				<!--
			<div id="oper_div" style="width: 500px; display:inline;">

						<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
						<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
					
			</div>
			<div id="oper_div" style="width: 433px; display:inline;">
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
			-->
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
	
}

	showWeek();
	
	function showWeek(){
		var table = document.getElementById("hourTable");
		var tr = document.getElementById("relaxRow");
		var td="";
		for(var i=1;i<7;i++){
			td = tr.insertCell(i);
			td.innerHTML = "<input type='checkbox' name='monday_"+i+"' id='monday_"+i+"' value='1'>星期一</input><br /><input type='checkbox' name='tuesday_"+i+"' id='tuesday_"+i+"' value='1'>星期二</input><br /><input type='checkbox' name='wednesday_"+i+"' id='wednesday_"+i+"' value='1'>星期三</input><br /><input type='checkbox' name='thursday_"+i+"' id='thursday_"+i+"' value='1'>星期四</input><br /><input type='checkbox' name='friday_"+i+"' id='friday_"+i+"' value='1'>星期五</input><br /><input type='checkbox' name='saturday_"+i+"' id='saturday_"+i+"' value='1'>星期六</input><br /><input type='checkbox' name='sunday_"+i+"' id='sunday_"+i+"' value='1'>星期日</input><br />";
		}
		toEdit();
	}
	

function submitButton(){
	var re = /^[0-9]+[0-9]*$/; 
	
	var start_date = document.getElementById("start_date").value;
	if(start_date==""){
		alert("开始统计时间为必填项，请选择日期");
		return;
	}else{
		var temp = start_date.split("-");
		var sdate = new Date(temp[0],parseInt(temp[1])-1,temp[2]);
		var today = new Date();
		if(sdate.valueOf()>today.valueOf()){
			alert("选择日期不得大于当前日期！");
			return;
		}
	}
	
	for(var i=1;i<7;i++){
		var people_num = document.getElementById("people_num_"+i).value;
		if(people_num!=""){
			if (!re.test(people_num)){
				alert("员工数量请输入数字且为整数！");
				return;
			}
		}
	}
	
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/workhour/hourSet.srq?isProject=2";
	form.submit();
}

	function stopWorkHour(){
		if(confirm("是否确认停止本项目百万工时统计？")){
			var retObj;
				 retObj = jcdpCallService("HseSrv", "stopWorkHour", "");
				 newClose();
		}
	}

 
	function toEdit(){ 
		for(var i=1;i<7;i++){
			var checkSql="select ws.hse_workhour_id id ,ws.start_date , wd.* from bgp_hse_workhour_set ws left join bgp_hse_workhour_detail wd on ws.hse_workhour_id = wd.hse_workhour_id where ws.bsflag = '0' and ws.project_info_no='<%=projectInfoNo%>' and wd.type='"+i+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
				
			}else{
				document.getElementById("start_date").value = datas[0].start_date;
				document.getElementById("hse_workhour_id").value = datas[0].id;
				document.getElementById("people_num_"+i).value = datas[0].people_num;
				var monday = datas[0].monday;
				var tuesday = datas[0].tuesday;
				var wednesday = datas[0].wednesday;
				var thursday = datas[0].thursday;
				var friday = datas[0].friday;
				var saturday = datas[0].saturday;
				var sunday = datas[0].sunday;
				if(monday=="1"){
					document.getElementById("monday_"+i).checked = true;
				}
				if(tuesday=="1"){
					document.getElementById("tuesday_"+i).checked = true;
				}
				if(wednesday=="1"){
					document.getElementById("wednesday_"+i).checked = true;
				}
				if(thursday=="1"){
					document.getElementById("thursday_"+i).checked = true;
				}
				if(friday=="1"){
					document.getElementById("friday_"+i).checked = true;
				}
				if(saturday=="1"){
					document.getElementById("saturday_"+i).checked = true;
				}
				if(sunday=="1"){
					document.getElementById("sunday_"+i).checked = true;
				}
			}
		}
	} 



</script>
</html>
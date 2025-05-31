<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	//增加，修改标志
	String flag=request.getParameter("flag");
	//设备检查id
	String id=request.getParameter("id");
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
  <title>设备检查</title> 
 </head>
<body style="background:#cdddef">
	<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
		<!-- 主键 -->
		<input  type ="hidden" id="inspection_team_id" name="inspection_team_id" class="input_width" />
		<div id="new_table_box" >
  			<div id="new_table_box_content">
    			<div id="new_table_box_bg" >
				    <fieldset>
					  	<legend>基本信息</legend>
					  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  		<tr>
							  	<td class="inquire_item6">检查日期：</td>
								<td class="inquire_form6">
									<input id="check_date" name="check_date"  class="input_width" type="text" readonly/>
									<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton1);"/>
								</td>
						  		<td class="inquire_item6">检查人：</td>
								<td class="inquire_form6">
									<input id="check_person" name="check_person" class="input_width" type="text"/>
								</td>
							</tr>
						  	<tr>
						  		<td class="inquire_item6">被检查班组：</td>
								<td class="inquire_form6">
									<select id="team_id" name="team_id" class="select_width" >
			          				</select>
								</td>
								<td class="inquire_item6"></td>
								<td class="inquire_form6"></td>
						  	</tr>
					 	</table>
					</fieldset>
					<fieldset>
						<legend>检查内容</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">班组制度执行情况：</td>
							    <td class="inquire_form6">
							     	<input type="radio"  name="system_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							     	<input type="radio"  name="system_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							     	<input type="radio"  name="system_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							    </td>
							</tr>
							<tr>
							 	<td class="inquire_item6">班组设备日常检查及保养情况：</td>
							    <td class="inquire_form6">
							     	<input type="radio"  name="check_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							     	<input type="radio"  name="check_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							     	<input type="radio"  name="check_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							    </td>
							</tr>
						    <tr>
						    	<td class="inquire_item6">班组设备使用情况：</td>
					      		<td class="inquire_form6">
							      	<input type="radio"  name="device_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							      	<input type="radio"  name="device_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							      	<input type="radio"  name="device_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						      	</td>
							</tr>
						   	<tr>
						    	<td class="inquire_item6">班组HSE设施完好情况：</td>
					      		<td class="inquire_form6">
						      		<input type="radio"  name="hse_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							      	<input type="radio"  name="hse_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							      	<input type="radio"  name="hse_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						      	</td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>整改内容</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  		<tr>
					  			<td class="inquire_item6">整改事项：</td>
								<td class="inquire_form6">
									<input name="modifi_project" id="modifi_project"  class="input_width" type="text"  />
								</td>
							  	<td class="inquire_item6">整改日期：</td>
								<td class="inquire_form6">
									<input id="modifi_time" name="modifi_time"  class="input_width" type="text" readonly/>
									<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(modifi_time,tributton2);"/>
								</td>
							</tr>
						  	<tr>
						  		<td class="inquire_item6">整改人员：</td>
								<td class="inquire_form6">
									<input id="modifi_person" name="modifi_person"  class="input_width" type="text" />
								</td>
								<td class="inquire_item6"></td>
								<td class="inquire_form6"></td>
						  	</tr>
						  	<tr>
							  	<td class="inquire_item6">备注：</td>
								<td class="inquire_form6" colspan="3">
									<textarea rows="2" cols="59" id="memo" name="memo" class="textarea" style="height:50px"></textarea>
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
	var flag='<%=flag%>';
	var id='<%=id%>';
	$(function(){
		var retObj = jcdpCallService("DevTeamCheckSrv", "getTeamInfo", "");
		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			for(var i=0;i<datas.length;i++){
				var data=datas[i];
				$("#team_id").append("<option value='"+data.id+"'>"+data.name+"</option>");
			}
		}
		//修改
		if(flag=="edit"){
			var retObj2 = jcdpCallService("DevTeamCheckSrv", "getDevTeamCheckInfo", "id="+id);
			if(typeof retObj2.data!="undefined"){
				var edata = retObj2.data;
				$(".input_width , .select_width , .textarea").each(function(){
					var temp = this.id;
					$("#"+this.id).val(edata[temp] != undefined ? edata[temp]:"");
				});
				//给检查内容赋值
				var system_situation = document.getElementsByName("system_situation");
				for(var s=0;s<system_situation.length;s++){
					if(system_situation[s].value==edata.system_situation){
						system_situation[s].checked = true;
					}
				}
				var check_situation = document.getElementsByName("check_situation");
				for(var s=0;s<check_situation.length;s++){
					if(check_situation[s].value==edata.check_situation){
						check_situation[s].checked = true;
					}
				}
				var device_situation = document.getElementsByName("device_situation");
				for(var s=0;s<device_situation.length;s++){
					if(device_situation[s].value==edata.device_situation){
						device_situation[s].checked = true;
					}
				}
				var hse_situation = document.getElementsByName("hse_situation");
				for(var s=0;s<hse_situation.length;s++){
					if(hse_situation[s].value==edata.hse_situation){
						hse_situation[s].checked = true;
					}
				}
				//班组不可修改
				$("#team_id").attr("disabled","disabled"); 
			}
		}else{
			$("#check_date").val(getCurrentDate());
			$("#modifi_time").val(getCurrentDate());
		}
	});
	
	function submitInfo(){
		if(flag=="edit"){
			//提交时，取消 班组 disabled属性
			$("#team_id").removeAttr("disabled"); 
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveOrUpdateDevTeamCheckInfo.srq?flag="+flag;
		document.getElementById("form1").submit();
	}
</script>
</html>
 
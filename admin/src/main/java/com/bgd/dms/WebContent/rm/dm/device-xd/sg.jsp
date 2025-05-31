<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_appdet_id = request.getParameter("ids");
	String accident_info_id=request.getParameter("accident_info_id");
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
  <title>事故记录</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:750px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:380px">
      <fieldset><legend>事故记录</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">事故名称</td>
			<td class="inquire_form6"><input name="ACCIDENT_NAME" id="ACCIDENT_NAME"  class="input_width" type="text" /></td>		    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input  type ="hidden" id="accident_info_id" name="accident_info_id" value="<%=accident_info_id%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
			</td>
			
		  </tr>
		  <tr>
		  <td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			</td>
			
		  </tr>
		  <tr>
		  <td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="PROJECT_NAME" name="PROJECT_NAME"  class="input_width" type="text" readonly/>
			</td>
			
		  </tr>
		  <!-- 
		   <tr>
		  <td class="inquire_item6">所属单位</td>
			<td class="inquire_form6"><input name="owning_org_name" id="owning_org_name"  class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">所在单位</td>
			<td class="inquire_form6">
				<input id="usage_org_name" name="usage_org_name"  class="input_width" type="text" readonly/>
			</td>
			
		  </tr>
		  <tr>
		  <td class="inquire_item6">使用情况</td>
			<td class="inquire_form6"><input name="using_stat" id="using_stat"  class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">技术状况</td>
			<td class="inquire_form6">
				<input id="tech_stat" name="tech_stat"  class="input_width" type="text" readonly/>
			</td>
		  </tr>
		   -->
		  <tr>
		  <td class="inquire_item6">损失金额(万元)</td>
			<td class="inquire_form6"><input name="accident_loss" id="accident_loss"  class="input_width" type="text"  /></td>
			<td class="inquire_item6">责任人</td>
			<td class="inquire_form6">
				<input id="accident_charge_person" name="accident_charge_person"  class="input_width" type="text" />
			</td>
		  </tr>
		  <tr>
		  <td class="inquire_item6">事故级别</td>
			<td class="inquire_form6">
			
			<code:codeSelect  cssClass="select_width"   name='accident_grade' option="accident_grade" selectedValue=""  addAll="true" />
			</td>
			<td class="inquire_item6">事故性质</td>
			<td class="inquire_form6">
				
				<code:codeSelect  cssClass="select_width"   name='accident_properties' option="accident_properties" selectedValue=""  addAll="true" />
			</td>
		  </tr>
		  <tr>
				<td class="inquire_item6">事故时间</td>
				<td class="inquire_form6">  
				     <input type="text" name=accident_time id="accident_time" value="" readonly="readonly" class="input_width"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(accident_time,tributton1);" /> 
				 </td>   
				<td class="inquire_item6">事故发生地</td>
				<td class="inquire_form6">  
				     <input type="text" name='accident_address' id='accident_address' value=""  class="input_width"/>
				 </td>     
		 </tr>
		  <tr>
		  <td class="inquire_item6">处理过程</td>
			<td class="inquire_form6" colspan="3">
			<textarea rows="2" cols="68" id="ACCIDENT_TREATMENT" name="ACCIDENT_TREATMENT" class="textarea"></textarea>
		
			</td>
		  </tr>
		  <tr>
			<td class="inquire_item6">备注</td>
			<td class="inquire_form6" colspan="3">
				<textarea rows="2" cols="68" id="SPARE1" name="SPARE1" class="textarea"></textarea>
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
	var accident_info_id='<%=accident_info_id%>';
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	function submitInfo(){
		if(!checks()){
			return false;
		}
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/bgpCommDeviceAccidentInfo.srq?state=9&ids="+dev_appdet_id;
			document.getElementById("form1").submit();
		}
	}

	

	function loadDataDetail(){
		if(accident_info_id=="null"){
			var querySql="select c.PROJECT_NAME,dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,d.coding_name as using_stat,sd.coding_name as tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from GMS_DEVICE_ACCOUNT_DUI b left join gp_task_project c on b.PROJECT_INFO_ID=c.project_info_no left join comm_coding_sort_detail sd on b.tech_stat=sd.coding_code_id left join comm_coding_sort_detail d on b.using_stat=d.coding_code_id where dev_acc_id='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#PROJECT_NAME")[0].value=basedatas[0].project_name;
			//$("#owning_org_name")[0].value=basedatas[0].owning_org_name;
			//$("#usage_org_name")[0].value=basedatas[0].usage_org_name;
			//$("#using_stat")[0].value=basedatas[0].using_stat;
			//$("#tech_stat")[0].value=basedatas[0].tech_stat;
		}else{
			var querySql="select a.*,b.dev_name,b.dev_model,b.self_num,b.license_num,c.PROJECT_NAME,b.owning_org_name,b.usage_org_name,d.coding_name as using_stat,sd.coding_name as tech_stat from BGP_COMM_DEVICE_ACCIDENT_INFO a left join GMS_DEVICE_ACCOUNT_DUI b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id left join gp_task_project c on b.PROJECT_INFO_ID=c.project_info_no left join comm_coding_sort_detail sd on b.tech_stat=sd.coding_code_id left join comm_coding_sort_detail d on b.using_stat=d.coding_code_id  where a.accident_info_id='"+accident_info_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#PROJECT_NAME")[0].value=basedatas[0].project_name;
			//$("#owning_org_name")[0].value=basedatas[0].owning_org_name;
			//$("#usage_org_name")[0].value=basedatas[0].usage_org_name;
			//$("#using_stat")[0].value=basedatas[0].using_stat;
			//$("#tech_stat")[0].value=basedatas[0].tech_stat;
			$("#accident_grade")[0].value=basedatas[0].accident_grade;
			$("#ACCIDENT_NAME")[0].value=basedatas[0].accident_name;
			$("#accident_properties")[0].value=basedatas[0].accident_properties;
			$("#accident_loss")[0].value=basedatas[0].accident_loss;
			$("#accident_charge_person")[0].value=basedatas[0].accident_charge_person;
			$("#ACCIDENT_TREATMENT")[0].value=basedatas[0].accident_treatment;
			$("#SPARE1")[0].value=basedatas[0].spare1;
			$("#accident_time")[0].value=basedatas[0].accident_time;
			$("#accident_address")[0].value=basedatas[0].accident_address;
		}	
	}
	function checks(){
		var reg = new RegExp("^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$");
		if($("#ACCIDENT_NAME")[0].value==""){
			alert("事故名称不可以为空");
			$("#ACCIDENT_NAME")[0].focus();
			return false;
		}
		if($("#accident_loss")[0].value==""){
			alert("损失金额不可以为空");
			$("#accident_loss")[0].focus();
			return false;
			
		}else{
			if(!reg.test($("#accident_loss")[0].value)){
				alert("损失金额的格式不正确！ 损失金额应为正浮点数");
				$("#accident_loss")[0].value="";
				$("#accident_loss")[0].focus();
				return false;
			}
		}
		if($("#accident_charge_person")[0].value==""){
			alert("请填写责任人");
			$("#accident_charge_person")[0].focus();
			return false;
		}
		if($("#accident_grade")[0].value==""){
			alert("请选择事故级别");
			$("#accident_grade")[0].focus();
			return false;
		}
		if($("#accident_properties")[0].value==""){
			alert("请选择事故性质");
			$("#accident_properties")[0].focus();
			return false;
		}
		return true;
	}
</script>
</html>
 
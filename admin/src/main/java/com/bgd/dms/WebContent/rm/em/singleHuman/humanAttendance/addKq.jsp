<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%>  
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%> 
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String employee_id = request.getParameter("ids"); 
	String projectInfoNo = user.getProjectInfoNo();
	
	String projectType=user.getProjectType();
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
	}
	
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	if(respMsg != null){
		message = respMsg.getValue("message");
	}
	String shuaId = "";
	if(respMsg != null){
		shuaId = respMsg.getValue("shuaId");
	}
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <title>人员考勤信息</title> 
 </head>
<body style="background:#fff"  >
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:750px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:380px">
      <fieldset><legend>人员考勤信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
					    
			<td class="inquire_item6">姓名</td>
			<td class="inquire_form6">
				<input id="employee_id" name="employee_id" type ="hidden" value="<%=employee_id%>"/>
				<input id="e_name" name="e_name" class="input_width"  type="text" readonly/>
			</td>
			<td class="inquire_item6">班组</td>
			<td class="inquire_form6"><input id="e_team" name="e_team"  class="input_width" type="text" readonly/></td>
		  </tr>
		  <tr>
			<td class="inquire_item6">岗位</td>
			<td class="inquire_form6">
				<input id="e_post" name="e_post"  class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">用工性质</td>
			<td class="inquire_form6"><input name="type_work" id="type_work"  class="input_width" type="text" readonly /></td>
		  </tr>
		  <tr>
		  <td class="inquire_item6">状态</td>
			<td class="inquire_form6">
				<select id="kqstate" name="kqstate" class="select_width" type="text">
						
					</select>
			</td>
			<td class="inquire_item6" >考勤日期</td>
			<td class="inquire_form6" ><input name="timesheet_date" id="timesheet_date" class="input_width" type="text" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(timesheet_date,tributton3);"/>
			</td>
		  </tr>
	  </table>
	  
	  </fieldset>
	</div>
			  <div id="oper_div" style="margin-bottom:5px">
			 	<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
			    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			  </div>
    </div>
    
</div>
</form>
</body>
<script type="text/javascript"> 
	var employee_id='<%=employee_id%>';
	
	var message = "<%=message%>";
	var shuaId="<%=shuaId%>";
	if(message != "" && message != 'null'){
		if(message=="保存成功!"){ 
			alert(message);
			//top.frames('list').loadDataDetail(shuaId);
			 top.frames('list').refreshData();
			newClose();
		}
		
	}
	
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
			document.getElementById("form1").action = "<%=contextPath%>/rm/em/addAttendancePage.srq?state=9";
			document.getElementById("form1").submit();
		}
	}

	

	  if(employee_id!=null){
		var querySql="select t.* from (select distinct t.EMPLOYEE_ID,t.EMPLOYEE_NAME,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'    left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id  and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where t.project_info_no =  '<%=projectInfoNo%>' and t.actual_start_date is not null    and t.EMPLOYEE_ID='"+employee_id+"' order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME ) t where 1=1 " ;
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#e_name")[0].value=basedatas[0].employee_name;
			$("#e_team")[0].value=basedatas[0].team_name;
			$("#e_post")[0].value=basedatas[0].work_post_name;
			$("#type_work")[0].value=basedatas[0].employee_gz_name;
  
			//通过查询结果动态填充资产状态select;
			var querySql="select * from comm_coding_sort_detail where coding_sort_id = '5110000052'   ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			datas = queryRet.datas;
			
			if(datas != null){
				for (var i = 0; i< queryRet.datas.length; i++) {
					document.getElementById("kqstate").options.add(new Option(datas[i].coding_name,datas[i].coding_code_id)); 
				}
			}
	   }
	function checks(){
		if($("#timesheet_date")[0].value==""){
			alert("考勤日期不可以为空");
			return false;
		}
		return true ;
	}
</script>
</html>
 
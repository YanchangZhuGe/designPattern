<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.Map"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%> 
<%@taglib prefix="auth" uri="auth"%>
 
<%
	String contextPath = request.getContextPath(); 
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request); 
	UserToken user = OMSMVCUtil.getUserToken(request);
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String curDate = format.format(new Date());
	String project_Id = user.getProjectInfoNo();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String plan_id = request.getParameter("plan_id"); 
	
	String costState = request.getParameter("costState");
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
</head>
<body  >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
	<div id="new_table_box_content">
    	<div id="new_table_box_bg">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
				<tr>
			     	<td class="inquire_item6">单号：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="plan_no" name="plan_no" value="系统自动生成" class="input_width" />
			       	</td>
			     	<td class="inquire_item6">项目名称：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="project_name" name="project_name"  style="width:280px;" value="<%=user.getProjectName()%>" />
			      	 
			      	</td>
			      	
			     </tr>
				 <tr>
				    <td class="inquire_item6">提交人：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="submitUser" name="submitUser" class="input_width"  value="<%=user.getUserName()%>"/> 
			      	</td>
			    	<td class="inquire_item6">提交日期：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="apply_date" name="apply_date"  style="width:280px;"   value="<%=curDate%>" readonly="readonly"/>
			      	</td>
		     	</tr> 
		     	<tr>
		    	<td class="inquire_item6"><font color="red">*</font>申请理由：</td>
		      	<td class="inquire_form6" colspan="3"><textarea id="spare3" name="spare3" class="textarea"></textarea></td>
		         </tr>

			</table>
			
			
		</div>
		<div id="oper_div" >
			<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
			<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
		</div>
	</div>
</div> 
</form>
</body>

<script type="text/javascript"> 
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

var plan_id ="<%=plan_id%>";
var projectInfoNo="<%=projectInfoNo%>";
var costState="<%=costState%>";

if (plan_id!="null" && plan_id !=null){
	document.getElementById("oper_div").style.display="none";
	
	var querySql2 = "select  c.apply_reason, c.cost_state ,decode(te.proc_status,  '1',  '待审批',  '3',  '审批通过',    '4',  '审批不通过',  te.proc_status) proc_status_name, c.plan_id, e.employee_name,  p.project_name,to_char(c.modifi_date,'yyyy-mm-dd hh:ss')modifi_dates,c.modifi_date,c.project_info_no,  (select wmsys.wm_concat(i.org_abbreviation)  from gp_task_project_dynamic d  left join comm_org_information i  on d.org_id = i.org_id  and i.bsflag = '0'  where p.project_info_no = d.project_info_no  and d.bsflag = '0') org_name,  nvl(c.plan_no, '申请提交后系统自动生成') plan_no,   te.proc_status   from  bgp_comm_human_plan_cost c  left join gp_task_project p  on p.project_info_no = c.project_info_no     and p.bsflag = '0'     left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'  left join comm_human_employee e  on c.creator = e.employee_id  and e.bsflag = '0'      where   c.cost_state = '"+costState+"'  and c.bsflag = '0'  and c.spare5 = '1'  and c.project_info_no = '"+projectInfoNo+"'     and c.plan_id='"+plan_id+"'   "; 
	var queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=1&querySql='+querySql2);
	var datas2 = queryRet2.datas;
	
	if(datas2 != null && datas2 !=""){ 
		//document.getElementById("plan_id").value=datas2[0].plan_id;
		document.getElementById("plan_no").value=datas2[0].plan_no;
		document.getElementById("project_name").value=datas2[0].project_name;
		document.getElementById("spare3").value=datas2[0].apply_reason;
		document.getElementById("submitUser").value=datas2[0].employee_name;
		document.getElementById("apply_date").value=datas2[0].modifi_dates;
		
	}	   
	 
}else { 
	document.getElementById("oper_div").style.display="block"; 
}
 
	function submitButton(){ 
		if(checkText0()){
			return;
		} 
		var spare3=document.getElementById("spare3").value;
		
		spare3 = encodeURI(spare3);
		spare3 = encodeURI(spare3);
		
		var planId = jcdpCallService("HumanCommInfoSrv","saveHumanPlanCostTwo","projectInfoNo=<%=projectInfoNo%>&costState=<%=costState%>&twoState=1&applyReason="+spare3);
		//var planId = jcdpCallService("HumanCommInfoSrv","submitSupplyHumanPlan","projectInfoNo=<%=project_Id%>&shenText="+encodeURIComponent(spare3));	
		if(planId.planId!=""){
			alert("保存成功!");
			closeButton();
		}
		
	}
	
	function closeButton(){
		var ctt = top.frames('list');
		ctt.refreshData();
		newClose();
	}
	
	  
	function checkText0(){
		var spare3=document.getElementById("spare3").value;
	 
		if(spare3==""){
			alert("申请理由不能为空，请填写");
			return true;
		}
		return false;
	}

</script>
</html>
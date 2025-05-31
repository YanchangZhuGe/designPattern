<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String userNamek = "";
	if(request.getParameter("userName") != null){
		userNamek = request.getParameter("userName");
	}
	String userGex = "";
	if(request.getParameter("userGex") != null){
		userGex = request.getParameter("userGex");
	}
	String laborId = "";
	if(request.getParameter("laborId") != null){
		laborId = request.getParameter("laborId");
	}
	String id = "";
	if(request.getParameter("id") != null){
		id = request.getParameter("id");
	}
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>计划内</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>
<body  onload="initialize();">
<form name="form" id="form"  method="post" action="" > 
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>						   
						  <td class="inquire_item6">姓名：</td>
				    	  <td class="inquire_form6">
				    	   <input type="text" id="employee_name" name="employee_name" class="input_width" style="color:gray;"   readonly="readonly" />
				   	        <input type="hidden" id="list_id" name="list_id" class="input_width" />
				      	    <input type="hidden" id="labor_id" name="labor_id" class="input_width" />
				         	<input type="hidden" id="bsflag" name="bsflag" value="0" /> 
				        	<input type="hidden" id="bl_status" name="bl_status" value="1" />
				        	</td>					  
						  <td class="inquire_item6">身份证号：</td>
				    	  <td class="inquire_form6">
				    	  <input type="text" id="employee_id_code_no" name="employee_id_code_no" class="input_width" style="color:gray;"   readonly="readonly"  />
				     </td>  		    	  
					  </tr>					  
						<tr>								 
						 <td class="inquire_item6"> 项目名称：</td>					 
						    <td class="inquire_form6"><input type="hidden" id="project_info_no" name="project_info_no" class="input_width" />
						    <input type="text" id="project_name" name="project_name" class="input_width"   />
						  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam1()"/>
						    </td>	
					     
					    <td class="inquire_item6"><font color="red">*</font>列入黑名单日期：</td>
					    <td class="inquire_form6">
					    <input type="text" id="list_date" name="list_date" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(list_date,tributton1);" />&nbsp  					    
					    </td>					    
						</tr>	 
					</table> 
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>列入黑名单原因：</td> 					   
					    <td class="inquire_form6"    ><textarea  style="width:486px;height:70px;" id="list_reason" name="list_reason"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td>   <td class="inquire_item6"> </td> 		 
					  </tr>
					  <tr>
					    <td class="inquire_item6"> 备注：</td> 					   
					    <td class="inquire_form6"    ><textarea  style="width:486px;height:70px;" id="notes" name="notes"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td>   <td class="inquire_item6"> </td> 				 
					  </tr>						  
					</table>
				</div>
			<div id="oper_div">
				<span class="bc_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var list_id='<%=id%>';

 function initialize(){
	 document.getElementsByName("employee_name")[0].value='<%=userNamek%>';
	 document.getElementsByName("employee_id_code_no")[0].value='<%=userGex%>';
	 document.getElementsByName("labor_id")[0].value='<%=laborId%>';
	 
 }
 
	function selectTeam1(){		
	  
	       var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
	       if(result!=""){
	       	var checkStr = result.split("-");	
		        document.getElementById("project_info_no").value = checkStr[0];
		        document.getElementById("project_name").value = checkStr[1];
	       }

	    
	}
	
	
	
	function checkJudge1(){
 	 
		var list_date = document.getElementsByName("list_date")[0].value;
		var list_reason = document.getElementsByName("list_reason")[0].value;		
	 
 		if(list_date==""){
 			alert("列入黑名单日期不能为空，请选择！");
 			return true;
 		}
 		if(list_reason==""){
 			alert("列入黑名单原因不能为空，请填写！");
 			return true;
 		}
   
 		return false;
 	}
 			
	
	
function submitButton(){ 	 
	if(checkJudge1()){
		return;
	} 
	var rowParams = new Array(); 
		var rowParam = {};				 
		var employee_name = document.getElementsByName("employee_name")[0].value;
		var list_id = document.getElementsByName("list_id")[0].value;
		var labor_id = document.getElementsByName("labor_id")[0].value;		
		var bl_status = document.getElementsByName("bl_status")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		
		var employee_id_code_no = document.getElementsByName("employee_id_code_no")[0].value;			
		var project_info_no = document.getElementsByName("project_info_no")[0].value;			
		var list_date = document.getElementsByName("list_date")[0].value;			
		var list_reason = document.getElementsByName("list_reason")[0].value;
		var notes = document.getElementsByName("notes")[0].value;		
		 
		rowParam['employee_name'] = encodeURI(encodeURI(employee_name));
		rowParam['labor_id'] = encodeURI(encodeURI(labor_id));
		rowParam['employee_id_code_no'] = encodeURI(encodeURI(employee_id_code_no));
		rowParam['project_info_no'] = encodeURI(encodeURI(project_info_no));		 		
		rowParam['list_date'] = encodeURI(encodeURI(list_date));
		rowParam['list_reason'] = encodeURI(encodeURI(list_reason));
		rowParam['notes'] = encodeURI(encodeURI(notes));		 		
 
	  if(list_id !=null && list_id !=''){
		    rowParam['list_id'] = list_id;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			rowParam['bl_status'] = bl_status;
	  }else{
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			rowParam['bl_status'] = bl_status;
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_COMM_HUMAN_LABOR_LIST",rows);	
		top.frames('list').frames('mainFrame').loadDataDetail(labor_id);	
		newClose();
	
}
 
 
	if(list_id !=null && list_id !=''){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		querySql = "select * from( select pt.project_name, pt.project_info_no, l.labor_id, l.employee_name, l.employee_gender, l.employee_id_code_no, lt.list_id, lt.list_reason, lt.list_date, lt.notes, lt.bl_status from bgp_comm_human_labor l left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id left join gp_task_project pt on lt.project_info_no = pt.project_info_no where lt.list_id is not null order by lt.create_date desc) d where d.list_id='"+list_id+"'"; 				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){		 
	              document.getElementsByName("employee_name")[0].value=datas[0].employee_name; 
	     		  document.getElementsByName("list_id")[0].value=datas[0].list_id; 
	     		  document.getElementsByName("labor_id")[0].value=datas[0].labor_id; 		
	     	      document.getElementsByName("bl_status")[0].value=datas[0].bl_status; 
	     	      document.getElementsByName("employee_id_code_no")[0].value=datas[0].employee_id_code_no; 			
	     		  document.getElementsByName("project_info_no")[0].value=datas[0].project_info_no; 		     		 
	     		  document.getElementsByName("project_name")[0].value=datas[0].project_name; 	
	     	      document.getElementsByName("list_date")[0].value=datas[0].list_date; 			
	     		  document.getElementsByName("list_reason")[0].value=datas[0].list_reason; 
	     		  document.getElementsByName("notes")[0].value=datas[0].notes; 		
	    
			}					
		
	    	}		
		
	}

</script>
</html>
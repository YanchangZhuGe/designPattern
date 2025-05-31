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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String attendance_id="";
	if(request.getParameter("attendance_id") != null){
		attendance_id=request.getParameter("attendance_id");	
		
	}
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();

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
<body   onload="queryCurrentState();listInfo();exitSelect();" >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>			 				   
					  <td class="inquire_item6"><font color="red">*</font>姓名：</td>
			        	<td class="inquire_form6">
			        	<input type="text" id="employee_name" name="employee_name" class="input_width"  readonly="readonly"  />	
				      	<input type="hidden" id="employee_id" name="employee_id" value="" />
			        	</td>
						  <td class="inquire_item6">SAP编号：</td>
				    	  <td class="inquire_form6">
				    	   	<input type="text" id="sap_number" name="sap_number" class="input_width"   readonly="readonly"  />		
						  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson()"/>
				         </td> 
					  </tr>					  
						<tr>

				    	  <td class="inquire_item6"><font color="red">*</font>开始时间：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="aa" name="aa" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="attendance_id" name="attendance_id"   />
						    <input type="text" id="start_time" name="start_time" onpropertychange="calDays()"  class="input_width"   readonly="readonly" />
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_time,tributton1);" />
						    </td> 
					        <td class="inquire_item6"><font color="red">*</font>结束时间：</td>					 
						    <td class="inquire_form6"> 
						    <input type="text" id="end_time" name="end_time" class="input_width"  onpropertychange="calDays()"  readonly="readonly" />
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(end_time,tributton2);" />
						    </td>	 
					  	</tr>
						
					  <tr>					  
					    <td class="inquire_item6">天数：</td>
					    <td class="inquire_form6">
					    <input type="text" id="days" name="days" class="input_width"   readonly="readonly" /> 
					     </td>
					   <td class="inquire_item6">目前状态：</td>
					    <td class="inquire_form6"> 
					    <select id="current_state" name="current_state" class="select_width" >
					    </td>
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
 var attendance_id='<%=attendance_id%>';
 var orgId='<%=orgId%>';
 var subId='<%=orgSubjectionId%>';

 	function checkJudge(){
 		var employee_name = document.getElementsByName("employee_name")[0].value; 
 		var start_time = document.getElementsByName("start_time")[0].value;
 		var end_time = document.getElementsByName("end_time")[0].value;
 		
		if(employee_name==""){
 			alert("姓名不能为空，请填写！");
 			return true;
 		} 
		if(start_time==""){
 			alert("开始日期不能为空，请填写！");
 			return true;
 		} 
		if(end_time==""){
 			alert("结束日期不能为空，请填写！");
 			return true;
 		} 
 		return false;
 	}
 	
 	function calDays(){
 		var startTime = document.getElementById("start_time").value;
 		var returnTime = document.getElementById("end_time").value;
 		if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
 		var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
 		if(days<0){
 			alert("结束时间应大于开始时间");
 			 document.getElementById("end_time").value="";
 			return false;
 		}else{
 			 var sDate=startTime;
 			 var eDate=returnTime;
 			 var sArr = sDate.split("-");
 			 var eArr = eDate.split("-");
 			 var sRDate = new Date(sArr[0], sArr[1], sArr[2]);
 			 var eRDate = new Date(eArr[0], eArr[1], eArr[2]);
 			 var result = (eRDate-sRDate)/(24*60*60*1000);
 			 document.getElementById("days").value=result;
 			return true;
 		}
 		}
 		return true;
 	}
 	
 	function selectPerson(){ 
	    var result=showModalDialog('<%=contextPath%>/rm/em/humanAttendance/selectHuman.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
	 
	    if(result!="" && result!=undefined){
	    	var checkStr=result.split(",");
	    	for(var i=0;i<checkStr.length-1;i++){
	    		var testTemp = checkStr[i].split("-");
	    		if(testTemp[6]=="正式工"){
		    		document.getElementById("employee_id").value=testTemp[0];
	    		} 
	    	    document.getElementsByName("employee_name")[0].value=testTemp[1];
	    	    document.getElementsByName("sap_number")[0].value=testTemp[5];
	    	  
	       	}	
	   }
	 }

 	function queryCurrentState(){ 
 		var HazardCenter=jcdpCallService("HumanLaborMessageSrv","queryCurrentState","");	 
 		var selectObj = document.getElementById("current_state");
 		document.getElementById("current_state").innerHTML="";
 		selectObj.add(new Option('请选择',""),0);
 		if(HazardCenter.detailInfo!=null){
 			for(var i=0;i<HazardCenter.detailInfo.length;i++){
 				var templateMap = HazardCenter.detailInfo[i];
 				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
 			}
 		}
 	}

 	
 	
function submitButton(){
	if(checkJudge()){
		return;
	}
 	   var rowParams = new Array(); 
		var rowParam = {};		 
		var attendance_id = document.getElementsByName("attendance_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value; 
		var employee_name = document.getElementsByName("employee_name")[0].value; 
		var sap_number = document.getElementsByName("sap_number")[0].value; 
		var start_time = document.getElementsByName("start_time")[0].value; 
		var end_time = document.getElementsByName("end_time")[0].value; 
		var days = document.getElementsByName("days")[0].value; 
		var current_state = document.getElementsByName("current_state")[0].value; 
		var employee_id = document.getElementsByName("employee_id")[0].value; 
 
		
		rowParam['org_sub_id'] = subId;
		rowParam['org_id'] = orgId;
		rowParam['employee_name'] = encodeURI(encodeURI(employee_name));
		rowParam['sap_number'] = encodeURI(encodeURI(sap_number));
		rowParam['start_time'] = encodeURI(encodeURI(start_time));
		rowParam['end_time'] = encodeURI(encodeURI(end_time));
		rowParam['days'] = days;
		rowParam['current_state'] = encodeURI(encodeURI(current_state));
		rowParam['employee_id'] = encodeURI(encodeURI(employee_id));
 
	  if(attendance_id !=null && attendance_id !=''){
		    rowParam['attendance_id'] = attendance_id;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
 
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_COMM_HUMAN_ATTENDANCE",rows);	
		top.frames('list').refreshData();	
		newClose();
	
}
 
 
function exitSelect(){  
	var selectObj = document.getElementById("current_state");  
	var aa = document.getElementById("aa").value; 
    for(var i = 0; i<selectObj.length; i++){ 
        if(selectObj.options[i].value == aa){ 
        	selectObj.options[i].selected = 'selected';     
        } 
       }  
   
}

 function listInfo(){
	if(attendance_id !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;	 
		querySql = "  select ha.attendance_id,ha.employee_name,ha.sap_number,ha.start_time,ha.end_time,ha.note,dl.coding_name as state_name,ha.current_state,ha.days,ha.bsflag,ha.employee_id,(trunc(nvl(ha.end_time,sysdate) - nvl(ha.start_time,sysdate) , 0)) v_day  from bgp_comm_human_attendance ha left join  comm_coding_sort_detail dl  on ha.current_state=dl.coding_code_id  and dl.bsflag='0'  where ha.bsflag='0'  and ha.attendance_id='"+attendance_id+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null&&datas!=""){			 
	            document.getElementsByName("attendance_id")[0].value=datas[0].attendance_id; 
	            document.getElementsByName("aa")[0].value=datas[0].current_state;
	            document.getElementsByName("employee_name")[0].value=datas[0].employee_name;
	            document.getElementsByName("sap_number")[0].value=datas[0].sap_number;
	            document.getElementsByName("start_time")[0].value=datas[0].start_time;
	            document.getElementsByName("end_time")[0].value=datas[0].end_time;
	            document.getElementsByName("aa")[0].value=datas[0].current_state; 
	            document.getElementsByName("days")[0].value=datas[0].days;
	            document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	            document.getElementsByName("employee_id")[0].value=datas[0].employee_id;
 
			}					
		
	    	}		
		
	 }
 }

</script>
</html>
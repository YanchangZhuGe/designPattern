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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	String drill_no="";
	if(request.getParameter("drill_no") != null){
		drill_no=request.getParameter("drill_no");	
		
	}
    String projectInfoNo ="";
	if(request.getParameter("projectInfoNo") != null){
		projectInfoNo=request.getParameter("projectInfoNo");	    		
	}

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择页面</title>
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
<body   onload="queryOrgs();>
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box" style="width:956px; height:565px;">
  <div id="new_table_box_content" style="width:956px; height:565px;">
    <div id="new_table_box_bg"   style="width:937px; height:490px; ">
				 <br>  
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>						   
					  <td class="inquire_item6">单位：</td>
			        	<td class="inquire_form6">
			        	<input type="hidden" id="o1rg_sub_id" name="o1rg_sub_id" class="input_width" />					     
				      	<input type="text" id="o1rg_sub_id2" name="o1rg_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
			        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
			        	<%} %>
			        	</td>
			          	<td class="inquire_item6">基层单位：</td>
			        	<td class="inquire_form6">
			        	 <input type="hidden" id="s1econd_org" name="s1econd_org" class="input_width" />
				    	  <input type="text" id="s1econd_org2" name="s1econd_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2s()"/>
			        	<%} %>
			        	</td> 
					    <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="p1articipants_ranges" name="p1articipants_ranges" value="" />
					     	<input type="hidden" id="c1reate_date" name="c1reate_date" value="" />
					      	<input type="hidden" id="c1reator" name="c1reator" value="" />
					      	<input type="hidden" id="b1sflag" name="b1sflag" value="0" />
					      	<input type="hidden" id="d1rill_no" name="d1rill_no"   />
					       	<input type="hidden" id="t1hird_org" name="t1hird_org" class="input_width" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="text" id="t1hird_org2" name="t1hird_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3s()"/>
					      	<%}%>
					     </td> 
					  </tr>	 
						<tr>								 
						   <td class="inquire_item6"><font color="red">*</font>应急预案：</td>
						    <td class="inquire_form6" colspan="5" >
						    <input type="text"    id="e1mergency_plan"  style="width:720px;" name="e1mergency_plan" value="" /> 
						    </td>
				 		   	    
						</tr>	
						<tr>								 
						   <td class="inquire_item6">参加人员范围：</td>
						    <td class="inquire_form6" colspan="5" >
						    <input type="checkbox"    id="p1articipants_range1"   name="p1articipants_range"  onclick="setDisAttr(this);"  value="全体员工" />全体员工
						    <input type="checkbox"    id="p1articipants_range2"   name="p1articipants_range"  onclick="setDisAttr1(this);"  value="应急人员" />应急人员
						    <input type="checkbox"    id="p1articipants_range3"   name="p1articipants_range"  onclick="setDisAttr2(this);"  value="直线管理人员" />直线管理人员
						    <input type="checkbox"    id="p1articipants_range4"   name="p1articipants_range"  onclick="setDisAttr3(this);"  value="HSE管理人员" />HSE管理人员
						    <input type="checkbox"    id="p1articipants_range5"   name="p1articipants_range"  onclick="setDisAttr4(this);"  value="新上岗转岗人员" />新上岗转岗人员
						    <input type="checkbox"    id="p1articipants_range6"   name="p1articipants_range"  onclick="setDisAttr5(this);"  value="外来人员" />外来人员
						    </td>
				 		   	    
						</tr>			 
					  <tr>	
						  <td class="inquire_item6"><font color="red">*</font>演练时间：</td>
						    <td class="inquire_form6"><input type="text" id="d1rilling_time" name="d1rilling_time" class="input_width"    />
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(d1rilling_time,tributton1);" />&nbsp;
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>演练类别：</td>
						    <td class="inquire_form6"> 
						    <select id="p1ractice_category" name="p1ractice_category" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >实战演练</option>
						       <option value="2" >桌面演练</option>  
							</select> 
						    </td>					   	      	
						    <td class="inquire_item6"><font color="red">*</font>参加人员数量 ：</td>
						    <td class="inquire_form6">
						    <input type="text" id="n1umber_participants" name="n1umber_participants" class="input_width"    onkeypress="return on_key_press_int(this)"  />    					    
						    </td>			
					  </tr>		
					  <tr>	
					   <td class="inquire_item6"><font color="red">*</font>主办部门 ：</td>
					    <td class="inquire_form6"><input type="text" id="h1ost_department" name="h1ost_department" class="input_width"    />
					    </td>
			 
				     </tr>		
					  
					</table> <br>
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>演练过程记录：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:60px;" id="d1rilling_process_record" name="d1rilling_process_record"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>		
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>效果评价：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:60px;" id="e1ffect_evaluation" name="e1ffect_evaluation"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>		
					  <tr>
					    <td class="inquire_item6">问题整改：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:60px;" id="p1roblem_corrected" name="p1roblem_corrected"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>		
					</table>
				 <br>
 
</div>		
 
		<div id="oper_div"  >
		<span class="tj_btn"><a href="#" onclick="addSelect1();submitButton1()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	
</div>
</div> 
</form>
</body>

<script type="text/javascript">
 var drill_no="<%=drill_no%>";
 var projectInfoNo='<%=projectInfoNo%>';
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}
function  setDisAttr(chkObj){  
	  var   chks=document.getElementsByName(chkObj.name);     
		if(chks[0].checked ==true){
			  chks[0].disabled   =  false;
			  chks[1].disabled   =  true;
			  chks[2].disabled   =  true;
			  chks[3].disabled   =  true;
			  chks[4].disabled   =  true;
			  chks[5].disabled   =  true;
		}
		if(chks[0].checked ==false){ 
			  chks[0].disabled   =  false;
			  chks[1].disabled   =  false;
			  chks[2].disabled   =  false;
			  chks[3].disabled   =  false;
			  chks[4].disabled   =  false;
			  chks[5].disabled   =  false; 
		}
			   
 } 
function on_key_press_int(obj)
{
	var keycode = event.keyCode;
	if(keycode > 57 || keycode < 46 || keycode==47)
	{
		return false;
	}else{
		return true;
	}
}
function   setDisAttr1(chkObj){  
	  var   chks=document.getElementsByName(chkObj.name);     
		if(chks[1].checked ==true){
			  chks[0].disabled   =  true;
			  chks[1].disabled   =  false;
			  chks[2].disabled   =  false;
			  chks[3].disabled   =  false;
			  chks[4].disabled   =  false;
			  chks[5].disabled   =  false;
		}
		if(chks[1].checked ==false){ 
			if(chks[2].checked ==false && chks[3].checked ==false && chks[4].checked ==false && chks[5].checked ==false ){ 
				  chks[0].disabled   =  false;
			}else{
				
				 chks[0].disabled   =  true;
			}
			 
		}
			   
}
function   setDisAttr2(chkObj){  
	  var   chks=document.getElementsByName(chkObj.name);     
		if(chks[2].checked ==true){
			  chks[0].disabled   =  true;
			  chks[1].disabled   =  false;
			  chks[2].disabled   =  false;
			  chks[3].disabled   =  false;
			  chks[4].disabled   =  false;
			  chks[5].disabled   =  false;
		}
		if(chks[2].checked ==false){ 
			if(chks[1].checked ==false && chks[3].checked ==false  && chks[4].checked ==false && chks[5].checked ==false ){ 
				  chks[0].disabled   =  false;
			}else{
				
				 chks[0].disabled   =  true;
			} 
		} 
}

function   setDisAttr3(chkObj){  
	  var   chks=document.getElementsByName(chkObj.name);     
		if(chks[3].checked ==true){
			  chks[0].disabled   =  true;
			  chks[1].disabled   =  false;
			  chks[2].disabled   =  false;
			  chks[3].disabled   =  false;
			  chks[4].disabled   =  false;
			  chks[5].disabled   =  false;
		}
		if(chks[3].checked ==false){ 
			if(chks[1].checked ==false && chks[2].checked ==false  && chks[4].checked ==false && chks[5].checked ==false ){ 
				  chks[0].disabled   =  false;
			}else{ 
				 chks[0].disabled   =  true;
			}
			 
		}
			   
}
function   setDisAttr4(chkObj){  
	  var   chks=document.getElementsByName(chkObj.name);     
		if(chks[4].checked ==true){
			  chks[0].disabled   =  true;
			  chks[1].disabled   =  false;
			  chks[2].disabled   =  false;
			  chks[3].disabled   =  false;
			  chks[4].disabled   =  false;
			  chks[5].disabled   =  false;
		}
		if(chks[4].checked ==false){ 
			if(chks[1].checked ==false && chks[2].checked ==false  && chks[3].checked ==false && chks[5].checked ==false ){ 
				  chks[0].disabled   =  false;
			}else{ 
				 chks[0].disabled   =  true;
			}
			 
		}
			   
}
function   setDisAttr5(chkObj){  
	  var   chks=document.getElementsByName(chkObj.name);     
		if(chks[5].checked ==true){
			  chks[0].disabled   =  true;
			  chks[1].disabled   =  false;
			  chks[2].disabled   =  false;
			  chks[3].disabled   =  false;
			  chks[4].disabled   =  false;
			  chks[5].disabled   =  false;
		}
		if(chks[5].checked ==false){ 
			if(chks[1].checked ==false && chks[2].checked ==false  && chks[3].checked ==false && chks[4].checked ==false ){ 
				  chks[0].disabled   =  false;
			}else{ 
				 chks[0].disabled   =  true;
			}
			 
		}
			   
}


	function queryOrgs(){
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.flag=="true"){
			var len = retObj.list.length;
			if(len>0){
				document.getElementById("o1rg_sub_id").value=retObj.list[0].orgSubId;
				document.getElementById("o1rg_sub_id2").value=retObj.list[0].orgAbbreviation;
			}
			if(len>1){
				document.getElementById("s1econd_org").value=retObj.list[1].orgSubId;
				document.getElementById("s1econd_org2").value=retObj.list[1].orgAbbreviation;
			}
			if(len>2){
				document.getElementById("t1hird_org").value=retObj.list[2].orgSubId;
				document.getElementById("t1hird_org2").value=retObj.list[2].orgAbbreviation;
			}
		}
	}
	
	function checkJudge1(){
 		var org_sub_id = document.getElementsByName("o1rg_sub_id2")[0].value;
		var second_org = document.getElementsByName("s1econd_org2")[0].value;			
		var third_org = document.getElementsByName("t1hird_org2")[0].value;			
		 
		var emergency_plan = document.getElementsByName("e1mergency_plan")[0].value;
		var drilling_time = document.getElementsByName("d1rilling_time")[0].value;		
		var practice_category = document.getElementsByName("p1ractice_category")[0].value;				
		var number_participants = document.getElementsByName("n1umber_participants")[0].value;		
		var host_department = document.getElementsByName("h1ost_department")[0].value;	
 		var drilling_process_record = document.getElementsByName("d1rilling_process_record")[0].value;		
		var effect_evaluation = document.getElementsByName("e1ffect_evaluation")[0].value;		
	  
		
 		if(org_sub_id==""){
 			document.getElementById("o1rg_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("s1econd_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("t1hird_org").value="";
 		}
 		if(emergency_plan==""){
 			alert("应急预案不能为空，请填写！");
 			return true;
 		}
 		if(drilling_time==""){
 			alert("演练时间不能为空，请选择！");
 			return true;
 		}
 		if(practice_category==""){
 			alert("演练类别不能为空，请填写！");
 			return true;
 		}
 
		if(number_participants==""){
 			alert("参加人员数量不能为空，请填写！");
 			return true;
 		}
		

		if(host_department==""){
 			alert("主办部门不能为空，请填写！");
 			return true;
 		}
		 

		if(drilling_process_record==""){
 			alert("演练过程记录不能为空，请填写！");
 			return true;
 		}
		  
		if(effect_evaluation==""){
 			alert("效果评价不能为空，请填写！");
 			return true;
 		}
		  
 		return false;
 	}
	

function submitButton1(){ 
	  
	if(checkJudge1()){
		return;
	}
	 
	var rowParams = new Array(); 
		var rowParam = {};			 
		var drill_no = document.getElementsByName("d1rill_no")[0].value; 
		var org_sub_id = document.getElementsByName("o1rg_sub_id")[0].value;
		var bsflag = document.getElementsByName("b1sflag")[0].value;
		var second_org = document.getElementsByName("s1econd_org")[0].value;			
		var third_org = document.getElementsByName("t1hird_org")[0].value;			
		var create_date = document.getElementsByName("c1reate_date")[0].value;
		var creator = document.getElementsByName("c1reator")[0].value;		
		
		var emergency_plan = document.getElementsByName("e1mergency_plan")[0].value;
		var drilling_time = document.getElementsByName("d1rilling_time")[0].value;		
		var practice_category = document.getElementsByName("p1ractice_category")[0].value;			
		var participants_range = document.getElementsByName("p1articipants_ranges")[0].value;		
		var number_participants = document.getElementsByName("n1umber_participants")[0].value;		
		var host_department = document.getElementsByName("h1ost_department")[0].value;	
 		var drilling_process_record = document.getElementsByName("d1rilling_process_record")[0].value;		
		var effect_evaluation = document.getElementsByName("e1ffect_evaluation")[0].value;		
		var problem_corrected = document.getElementsByName("p1roblem_corrected")[0].value;
		var project_no = document.getElementsByName("project_no")[0].value;		
		  
		  
		rowParam['org_sub_id'] =org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;		
		
		rowParam['drill_no'] = encodeURI(encodeURI(drill_no));
		rowParam['emergency_plan'] = encodeURI(encodeURI(emergency_plan));
		rowParam['drilling_time'] = encodeURI(encodeURI(drilling_time));
		rowParam['practice_category'] = encodeURI(encodeURI(practice_category));
		rowParam['participants_range'] = encodeURI(encodeURI(participants_range));
		rowParam['number_participants'] = number_participants;		 		
		rowParam['host_department'] = encodeURI(encodeURI(host_department));
		rowParam['drilling_process_record'] = encodeURI(encodeURI(drilling_process_record));
		rowParam['effect_evaluation'] = encodeURI(encodeURI(effect_evaluation));		 		
		rowParam['problem_corrected'] = encodeURI(encodeURI(problem_corrected));
		
		rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['modifi_date'] = '<%=curDate%>';		
		rowParam['bsflag'] = bsflag;
		rowParam['spare1'] = '2';   
		
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_EMERGENCY_DRILL",rows);	
		top.frames('list').refreshData();	
		newClose();
 
} 

function selectOrgs(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("o1rg_sub_id").value = teamInfo.fkValue;
        document.getElementById("o1rg_sub_id2").value = teamInfo.value;
    }
}

function selectOrg2s(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("o1rg_sub_id").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("s1econd_org").value = teamInfo.fkValue; 
		        document.getElementById("s1econd_org2").value = teamInfo.value;
			}
   
}

function selectOrg3s(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var third = document.getElementById("s1econd_org").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("t1hird_org").value = teamInfo.fkValue;
		        document.getElementById("t1hird_org2").value = teamInfo.value;
			}
}

 
function addSelect1(){ 
	   var certificate = document.getElementsByName("p1articipants_range");
		var certificate_no = "";
		for(var i=0;i< certificate.length;i++){
			if(certificate[i].checked==true){
				certificate_no = certificate_no + certificate[i].value + ";";	
			}
		} 
		document.getElementsByName("p1articipants_ranges")[0].value=certificate_no; 
	}
 


if(drill_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		 
		querySql = " select tr.project_no, tr.org_sub_id,  tr.drill_no,tr.emergency_plan,tr.drilling_time,tr.practice_category,tr.participants_range,tr.number_participants,tr.host_department,tr.drilling_process_record,  tr.effect_evaluation,tr.problem_corrected,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_EMERGENCY_DRILL tr   left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'     left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0'  and tr.drill_no='"+ drill_no +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 		   
	             document.getElementsByName("d1rill_no")[0].value=datas[0].drill_no; 
	    		 document.getElementsByName("b1sflag")[0].value=datas[0].bsflag;	     
	  		     document.getElementsByName("c1reate_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("c1reator")[0].value=datas[0].creator;	  
	    		 document.getElementsByName("o1rg_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("o1rg_sub_id2")[0].value=datas[0].org_name; 
	    		 document.getElementsByName("s1econd_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("s1econd_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("t1hird_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("t1hird_org2")[0].value=datas[0].third_org_name;	  
	    		 document.getElementsByName("p1articipants_ranges")[0].value=datas[0].participants_range; 
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;		
	    		    
	    		 var listValues=datas[0].participants_range; 
	    		 var check_unit_orgs = listValues.split(';'); 
	    		 var certificate = document.getElementsByName("p1articipants_range");			 		
				    for(var i=0;i< check_unit_orgs.length;i++)					        {
				    	var check_unit_org = listValues.split(';')[i]; 	
		  		    	for(var j=0;j< certificate.length;j++){
		  				if(certificate[j].value==check_unit_org){				  					
		  					certificate[j].checked=true;
			  					if(check_unit_org =="全体员工"){
			  						certificate[0].disabled   =  false;
			  						certificate[1].disabled   =  true;
			  						certificate[2].disabled   =  true;
			  						certificate[3].disabled   =  true;
			  						certificate[4].disabled   =  true;
			  						certificate[5].disabled   =  true; 
			  					}else{
			  						certificate[0].disabled   =  true;
			  						certificate[1].disabled   =  false;
			  						certificate[2].disabled   =  false;
			  						certificate[3].disabled   =  false;
			  						certificate[4].disabled   =  false;
			  						certificate[5].disabled   =  false; 
			  						
			  					}
		  				}
	  				 
		  		    	}
	  		       	}
		  	 				     
				 document.getElementsByName("e1mergency_plan")[0].value=datas[0].emergency_plan;
				 document.getElementsByName("d1rilling_time")[0].value=datas[0].drilling_time;		
				 document.getElementsByName("p1ractice_category")[0].value=datas[0].practice_category;	
				 document.getElementsByName("n1umber_participants")[0].value=datas[0].number_participants;		
				 document.getElementsByName("h1ost_department")[0].value=datas[0].host_department;	
			 	 document.getElementsByName("d1rilling_process_record")[0].value=datas[0].drilling_process_record;		
				 document.getElementsByName("e1ffect_evaluation")[0].value=datas[0].effect_evaluation;		
				 document.getElementsByName("p1roblem_corrected")[0].value=datas[0].problem_corrected;
	    			 
			}					
		
	    	}		
		
	}


</script>
</html>
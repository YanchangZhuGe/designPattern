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
	String train_drill_no="";
	if(request.getParameter("train_drill_no") != null){
		train_drill_no=request.getParameter("train_drill_no");	
		
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
<body   onload="queryOrgss();">
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box" style="width:956px; height:565px;">
  <div id="new_table_box_content" style="width:956px; height:565px;">
    <div id="new_table_box_bg"   style="width:937px; height:490px; ">
				   <br>
  
			<fieldset>
			<legend>
				应急培训
			</legend>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
				  <tr>						   
				  <td class="inquire_item6">单位：</td>
		        	<td class="inquire_form6">
		        	<input type="hidden" id="o2rg_sub_id" name="o2rg_sub_id" class="input_width" />					     
			      	<input type="text" id="o2rg_sub_id2" name="o2rg_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
		        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="s2electOrgs()"/>
		        	<%} %>
		        	</td>
		          	<td class="inquire_item6">基层单位：</td>
		        	<td class="inquire_form6">
		        	 <input type="hidden" id="s2econd_org" name="s2econd_org" class="input_width" />
			    	  <input type="text" id="s2econd_org2" name="s2econd_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
		        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="s2electOrg2s()"/>
		        	<%} %>
		        	</td> 
				    <td class="inquire_item6">下属单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="p2articipants_ranges" name="p2articipants_ranges" value="" />
				    	<input type="hidden" id="c2reate_date" name="c2reate_date" value="" />
				      	<input type="hidden" id="c2reator" name="c2reator" value="" />
				      	<input type="hidden" id="b2sflag" name="b2sflag" value="0" />
				    	<input type="hidden" id="project_no" name="project_no" value="" />
				      	<input type="hidden" id="train_drill_no" name="train_drill_no"   />
				       	<input type="hidden" id="t2hird_org" name="t2hird_org" class="input_width" />
				      	<input type="text" id="t2hird_org2" name="t2hird_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="s2electOrg3s()"/>
				      	<%}%>
				     </td> 
				  </tr>	 
				  
					<tr>								 
					   <td class="inquire_item6">参加人员范围：</td>
					    <td class="inquire_form6"  colspan="5" >
					    <input type="checkbox"    id="p2articipants_range1"   name="p2articipants_range"  onclick="setDisAttr(this);"  value="全体员工" />全体员工
					    <input type="checkbox"    id="p2articipants_range2"   name="p2articipants_range"  onclick="setDisAttr1(this);"  value="应急人员" />应急人员
					    <input type="checkbox"    id="p2articipants_range3"   name="p2articipants_range"  onclick="setDisAttr2(this);"  value="直线管理人员" />直线管理人员
					    <input type="checkbox"    id="p2articipants_range4"   name="p2articipants_range"  onclick="setDisAttr3(this);"  value="HSE管理人员" />HSE管理人员
					    <input type="checkbox"    id="p2articipants_range5"   name="p2articipants_range"  onclick="setDisAttr4(this);"  value="新上岗转岗人员" />新上岗转岗人员
					    <input type="checkbox"    id="p2articipants_range6"   name="p2articipants_range"  onclick="setDisAttr5(this);"  value="外来人员" />外来人员
					    </td>
			 		   	    
					</tr>			 
				  <tr>	
					  <td class="inquire_item6"><font color="red">*</font>参加人员数量：</td>
					    <td class="inquire_form6"><input type="text" id="n2umber_participants" name="n2umber_participants" class="input_width"    onkeypress="return on_key_press_int(this)" />
					    </td>
			 		    <td class="inquire_item6"><font color="red">*</font>学时：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="s2chool" name="s2chool" class="input_width" onkeypress="return on_key_press_int(this)"   />    个		
					    </td>					   	      	
					    <td class="inquire_item6"><font color="red">*</font>培训开始时间 ：</td>
					    <td class="inquire_form6">
					    <input type="text" id="t2raining_start_time" name="t2raining_start_time" class="input_width"     />    					    
					    </td>			
				  </tr>		
				  <tr>	
				   <td class="inquire_item6">主办部门 ：</td>
				    <td class="inquire_form6"><input type="text" id="h2ost_department" name="h2ost_department" class="input_width"   />
				    </td>
		 		    <td class="inquire_item6">培训小结：</td>
				    <td class="inquire_form6"> 
				    <input type="text" id="t2raining_summary" name="t2raining_summary" class="input_width"   />    		
				    </td>		 
			     </tr>		 
				</table> 
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>培训内容：</td> 					   
				    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:50px;" id="t2raining_content" name="t2raining_content"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>						  
				</table>
				</fieldset>
				<fieldset>
				<legend>
					应急演练
				</legend>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					<tr>								 
					   <td class="inquire_item6"><font color="red">*</font>应急预案：</td>
					    <td class="inquire_form6" colspan="3" >
					    <input type="text"    id="e2mergency_plan"  style="width:720px;" name="e2mergency_plan" value="" /> 
					    </td> 
					</tr>	 
				  <tr>	
					  <td class="inquire_item6"><font color="red">*</font>演练时间：</td>
					    <td class="inquire_form6"><input type="text" id="d2rilling_time"  name="d2rilling_time" class="input_width"  />
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(d2rilling_time,tributton2);" />&nbsp;
					    </td>
			 		    <td class="inquire_item6"><font color="red">*</font>演练类别：</td>
					    <td class="inquire_form6"> 
					    <select id="p2ractice_category" name="p2ractice_category" style="width:210px;" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >实战演练</option>
					       <option value="2" >桌面演练</option>  
						</select> 
					    </td>					   	      	
					   	
				  </tr>		
				  
				</table>  
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>演练过程记录：</td> 					   
				    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:50px;" id="d2rilling_process_record" name="d2rilling_process_record"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>效果评价：</td> 					   
				    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:50px;" id="e2ffect_evaluation" name="e2ffect_evaluation"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				  <tr>
				    <td class="inquire_item6">问题整改：</td> 					   
				    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:50px;" id="p2roblem_corrected" name="p2roblem_corrected"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				</table>
				</fieldset>
 
	</div>
		<div id="oper_div"  >
		<span class="tj_btn"><a href="#" onclick="addSelect2();submitButton2()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
  var train_drill_no="<%=train_drill_no%>";
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


	function queryOrgss(){
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.flag=="true"){
			var len = retObj.list.length;
			if(len>0){
				document.getElementById("o2rg_sub_id").value=retObj.list[0].orgSubId;
				document.getElementById("o2rg_sub_id2").value=retObj.list[0].orgAbbreviation;
			}
			if(len>1){
				document.getElementById("s2econd_org").value=retObj.list[1].orgSubId;
				document.getElementById("s2econd_org2").value=retObj.list[1].orgAbbreviation;
			}
			if(len>2){
				document.getElementById("t2hird_org").value=retObj.list[2].orgSubId;
				document.getElementById("t2hird_org2").value=retObj.list[2].orgAbbreviation;
			}
		}
	}
 

function s2electOrgs(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("o2rg_sub_id").value = teamInfo.fkValue;
        document.getElementById("o2rg_sub_id2").value = teamInfo.value;
    }
}

function s2electOrg2s(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("o2rg_sub_id").value;
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
		    	 document.getElementById("s2econd_org").value = teamInfo.fkValue; 
		        document.getElementById("s2econd_org2").value = teamInfo.value;
			}
   
}

function s2electOrg3s(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var third = document.getElementById("s2econd_org").value;
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
		    	 document.getElementById("t2hird_org").value = teamInfo.fkValue;
		        document.getElementById("t2hird_org2").value = teamInfo.value;
			}
}

function checkJudge2(){
	var org_sub_id = document.getElementsByName("o2rg_sub_id2")[0].value;
	var second_org = document.getElementsByName("s2econd_org2")[0].value;			
	var third_org = document.getElementsByName("t2hird_org2")[0].value;			
	 
	var emergency_plan = document.getElementsByName("e2mergency_plan")[0].value;
	var drilling_time = document.getElementsByName("d2rilling_time")[0].value;		
	var practice_category = document.getElementsByName("p2ractice_category")[0].value;				
	var number_participants = document.getElementsByName("n2umber_participants")[0].value;		
	var host_department = document.getElementsByName("h2ost_department")[0].value;	
		var drilling_process_record = document.getElementsByName("d2rilling_process_record")[0].value;		
	var effect_evaluation = document.getElementsByName("e2ffect_evaluation")[0].value;		
   
	var training_content = document.getElementsByName("t2raining_content")[0].value;					
	var number_participants = document.getElementsByName("n2umber_participants")[0].value;			
	var school = document.getElementsByName("s2chool")[0].value;		
	var training_start_time = document.getElementsByName("t2raining_start_time")[0].value;		

 
		if(org_sub_id==""){
			document.getElementById("o2rg_sub_id").value = "";
		}
		if(second_org==""){
			document.getElementById("s2econd_org").value="";
		}
		if(third_org==""){
			document.getElementById("t2hird_org").value="";
		}
	
		if(training_content==""){
			alert("培训内容不能为空，请填写！");
			return true;
		}
		if(number_participants==""){
			alert("参加人员数量不能为空，请选择！");
			return true;
		}
		if(school==""){
			alert("学时不能为空，请填写！");
			return true;
		}

	   if(training_start_time==""){
			alert("培训开始时间不能为空，请填写！");
			return true;
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

function submitButton2(){ 	 
	if(checkJudge2()){
		return;
	}
	var rowParams = new Array(); 
		var rowParam = {};	
 
 		var train_drill_no = document.getElementsByName("train_drill_no")[0].value; 
		var org_sub_id = document.getElementsByName("o2rg_sub_id")[0].value;
		var bsflag = document.getElementsByName("b2sflag")[0].value;
		var second_org = document.getElementsByName("s2econd_org")[0].value;			
		var third_org = document.getElementsByName("t2hird_org")[0].value;			
		var create_date = document.getElementsByName("c2reate_date")[0].value;
		var creator = document.getElementsByName("c2reator")[0].value;		
		
		var participants_range = document.getElementsByName("p2articipants_ranges")[0].value;
		var training_content = document.getElementsByName("t2raining_content")[0].value;		
		var number_participants = document.getElementsByName("n2umber_participants")[0].value;			
		var school = document.getElementsByName("s2chool")[0].value;		
		var training_start_time = document.getElementsByName("t2raining_start_time")[0].value;		
		var host_department = document.getElementsByName("h2ost_department")[0].value;			
		var training_summary = document.getElementsByName("t2raining_summary")[0].value;
		
		var emergency_plan = document.getElementsByName("e2mergency_plan")[0].value;
		var drilling_time = document.getElementsByName("d2rilling_time")[0].value;		
		var practice_category = document.getElementsByName("p2ractice_category")[0].value;	
 		var drilling_process_record = document.getElementsByName("d2rilling_process_record")[0].value;		
		var effect_evaluation = document.getElementsByName("e2ffect_evaluation")[0].value;		
		var problem_corrected = document.getElementsByName("p2roblem_corrected")[0].value;
		var project_no = document.getElementsByName("project_no")[0].value;		
		  
	  
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			 	
		
		rowParam['train_drill_no'] = encodeURI(encodeURI(train_drill_no));
		rowParam['participants_range'] = encodeURI(encodeURI(participants_range));
		rowParam['training_content'] = encodeURI(encodeURI(training_content));
		rowParam['number_participants'] = number_participants;		 		
		rowParam['school'] = school;
		rowParam['training_start_time'] = encodeURI(encodeURI(training_start_time));		
		rowParam['host_department'] = encodeURI(encodeURI(host_department));
		rowParam['training_summary'] = encodeURI(encodeURI(training_summary)); 
		rowParam['emergency_plan'] = encodeURI(encodeURI(emergency_plan));
		rowParam['drilling_time'] = encodeURI(encodeURI(drilling_time));
		rowParam['practice_category'] = encodeURI(encodeURI(practice_category)); 
		rowParam['drilling_process_record'] = encodeURI(encodeURI(drilling_process_record));
		rowParam['effect_evaluation'] = encodeURI(encodeURI(effect_evaluation));		 		
		rowParam['problem_corrected'] = encodeURI(encodeURI(problem_corrected));
 	 
		rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['modifi_date'] = '<%=curDate%>';		
		rowParam['bsflag'] = bsflag;  
		rowParam['spare1'] = '3';  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_TRAINING_DRILL",rows);	
		top.frames('list').refreshData();	
		newClose();
	
}
 
function addSelect2(){ 
	   var certificate = document.getElementsByName("p2articipants_range");
		var certificate_no = "";
		for(var i=0;i<certificate.length;i++){
			if(certificate[i].checked==true){
				certificate_no = certificate_no + certificate[i].value + ";";	
			}
		} 
		document.getElementsByName("p2articipants_ranges")[0].value=certificate_no; 
	}


if(train_drill_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		 
		querySql = " select  tr.project_no,tr.org_sub_id,  tr.train_drill_no,tr.training_content,tr.participants_range,tr.number_participants,tr.school,tr.training_start_time   ,tr.host_department,tr.training_summary,tr.training_attendance ,tr.emergency_plan,tr.drilling_time,tr.practice_category,tr.drilling_process_record,tr.effect_evaluation,  tr.problem_corrected,tr.drill_attendance ,tr.second_org,tr.third_org,ion.org_abbreviation as  org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_TRAINING_DRILL tr    left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'      left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left  join comm_org_information ion    on ion.org_id = ose.org_id    where tr.bsflag = '0'  and tr.train_drill_no='"+ train_drill_no +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 		   
	             document.getElementsByName("train_drill_no")[0].value=datas[0].train_drill_no; 
	    		 document.getElementsByName("b2sflag")[0].value=datas[0].bsflag;	     
	  		     document.getElementsByName("c2reate_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("c2reator")[0].value=datas[0].creator;	  
	    		 document.getElementsByName("o2rg_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("o2rg_sub_id2")[0].value=datas[0].org_name; 
	    		 document.getElementsByName("s2econd_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("s2econd_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("t2hird_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("t2hird_org2")[0].value=datas[0].third_org_name;	
	    	     document.getElementsByName("project_no")[0].value=datas[0].project_no;		
	    		    
	    		 document.getElementsByName("p2articipants_ranges")[0].value=datas[0].participants_range; 
	    		 
	    		 var listValues=datas[0].participants_range; 
	    		 var check_unit_orgs = listValues.split(';'); 
	    		 var certificate = document.getElementsByName("p2articipants_range");			 		
				    for(var i=0;i<check_unit_orgs.length;i++)					        {
				    	var check_unit_org = listValues.split(';')[i]; 	
		  		    	for(var j=0;j<certificate.length;j++){
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
				      document.getElementsByName("t2raining_content")[0].value=datas[0].training_content;
		    		  document.getElementsByName("n2umber_participants")[0].value=datas[0].number_participants;			
		    		  document.getElementsByName("s2chool")[0].value=datas[0].school;			
		    		  document.getElementsByName("t2raining_start_time")[0].value=datas[0].training_start_time;
		    		  document.getElementsByName("h2ost_department")[0].value=datas[0].host_department;
		    		  document.getElementsByName("t2raining_summary")[0].value=datas[0].training_summary;	 
					 document.getElementsByName("e2mergency_plan")[0].value=datas[0].emergency_plan;
					 document.getElementsByName("d2rilling_time")[0].value=datas[0].drilling_time;		
					 document.getElementsByName("p2ractice_category")[0].value=datas[0].practice_category;	 
				 	 document.getElementsByName("d2rilling_process_record")[0].value=datas[0].drilling_process_record;		
					 document.getElementsByName("e2ffect_evaluation")[0].value=datas[0].effect_evaluation;		
					 document.getElementsByName("p2roblem_corrected")[0].value=datas[0].problem_corrected;
	    			 
			}					
		
	    	}		
		
	}

</script>
</html>
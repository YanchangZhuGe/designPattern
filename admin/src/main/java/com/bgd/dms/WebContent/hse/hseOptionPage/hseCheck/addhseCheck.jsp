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
	
	String check_no="";
	if(request.getParameter("check_no") != null){
		check_no=request.getParameter("check_no");	
		
	}
	
    String projectInfoNo ="";
	if(request.getParameter("projectInfoNo") != null){
		projectInfoNo=request.getParameter("projectInfoNo");	    		
	}

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_accident_id ="";  
	if(resultMsg!=null){
	 hse_accident_id = resultMsg.getValue("hse_accident_id");
 
	}
	
	String isProject = request.getParameter("isProject");

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HSE检查</title>
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
<body  >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_accident_id" name="hse_accident_id" value="<%=hse_accident_id %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0"  id="oTb" class="tab_line_height" >	
				    
					    <tr>			 				   
					    <td class="inquire_item6">检查名称：</td>
					    <td class="inquire_form6"><input type="text" id="check_name" name="check_name" class="input_width" readonly="readonly" style="color:gray"  value="自动生成"/></td>				      	
				    	  <td class="inquire_item6">检查单位：</td>
				        	<td class="inquire_form6">
				        	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />				
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width" />
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>	        	 
				        	</td> 
					  </tr>			      
				      <tr>				
						   	<td class="inquire_item6">检查基层单位：</td>
				        	<td class="inquire_form6">
				        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
				 	      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	</td>	    	   
				    	 
					        <td class="inquire_item6">被检查单位：</td>
					      	<td class="inquire_form6">				    
					      	<input type="hidden" id="check_unit_id" name="check_unit_id" class="input_width"    />
					      	<input type="text" id="check_unit_org" name="check_unit_org" class="input_width"    readonly="readonly"/>
					      	<input type="hidden" id="check_unit_org2" name="check_unit_org2" class="input_width"    readonly="readonly"/>
					      	 <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
					      	</td>
					  </tr>		
					  <tr>			 				   
					    <td class="inquire_item6">被检查基层单位：</td>
				      	<td class="inquire_form6">				     
				     	<input type="hidden" id="check_roots_id" name="check_roots_id" class="input_width"    />
				      	<input type="text" id="check_roots_org" name="check_roots_org" class="input_width"    readonly="readonly"/>
				    	<input type="hidden" id="check_roots_org2" name="check_roots_org2" class="input_width"    readonly="readonly"/>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs2()"/>
				      	</td>
				        <td class="inquire_item6">被检查部门/部位：</td>					 
					    <td class="inquire_form6"> 
					    <input type="text" id="check_parts" name="check_parts" class="input_width"   />     </td>	 	  
			    	  
			    	  </tr>		  
				   		   			  
					  	<tr>
				        <td class="inquire_item6"><font color="red">*</font>检查类别：</td>					 
					    <td class="inquire_form6"> 
					    <select id="check_type" name="check_type" class="select_width" onchange="selectParam(this)">
					       <option value="" >请选择</option>
					       <option value="1" >日常检查</option>
					       <option value="2" >专项检查</option>
					       <option value="3" >联系点到位</option>
						</select>   </td>							
					    <td class="inquire_item6"><font color="red">*</font>是否承包商队伍检查：</td>
					    <td class="inquire_form6">
					    <select id="if_contractor_team" name="if_contractor_team" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="2" >否</option>	
						</select>  					 
					    </td>					    
						</tr>	
					  <tr>	
					  <td class="inquire_item6"><font color="red">*</font>领导带队：</td>
					    <td class="inquire_form6"> 
					    <select id="leadership_led" name="leadership_led" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="2" >否</option>					      
						</select>
					    </td>
					    <td class="inquire_item6">带队领导：</td>
					    <td class="inquire_form6">
					    <input type="text" id="led_leadership" name="led_leadership" class="input_width" />
					    </td>		
					  </tr>	
					  <tr id="trS" style="display:none;">				
					    <td class="inquire_item6">联系人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="contact" name="contact"    class="input_width"/>
					    </td>	
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>	
					  <tr>					   
					    <td class="inquire_item6"><font color="red">*</font>检查成员：</td>
					    <td class="inquire_form6" colspan="3">
					    <input type="text" id="check_members" name="check_members" style="width:500px;" class="input_width" />
						</td>
					  </tr>		
					  <tr>				
		 			    <td class="inquire_item6"><font color="red">*</font>检查开始时间：</td>
					    <td class="inquire_form6"><input type="text" id="check_start_time" name="check_start_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_start_time,tributton1);" />&nbsp;</td>
					    <td class="inquire_item6"><font color="red">*</font>检查结束时间：</td>
					    <td class="inquire_form6"><input type="text" id="check_end_time" name="check_end_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_end_time,tributton2);" />&nbsp;</td>
			 
					  </tr>					
					  <tr>				 
					    <td class="inquire_item6"><font color="red">*</font>检查级别：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				    	<input type="hidden" id="project_no" name="project_no" value="" />
				      	<input type="hidden" id="check_no" name="check_no"   />
				      	 <select id="check_level" name="check_level" class="select_width" onchange="selectName(this)">
					       <option value="" >请选择</option>
					       <option value="1" >公司</option>
					       <option value="2" >二级单位</option>	
					       <option value="3" >基层单位</option>
						</select>
				      	</td>
					    
					    <td class="inquire_item6">累计问题清单信息数量：</td>
					    <td class="inquire_form6"><input type="text" id="number_problems" name="number_problems" class="input_width"  style="color: gray;" value="累计问题整改信息数量"  readonly="readonly" /></td>
					  </tr>						  
					  
					</table>
					  
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var check_no='<%=check_no%>';
 var projectInfoNo='<%=projectInfoNo%>';
//键盘上只有删除键，和左右键好用
 function noEdit(event){
 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
 		return true;
 	}else{
 		return false;
 	}
 }

 	function queryOrg(){
 		if(check_no!=null && check_no!=""){
 		 	
 		}else{
	 		retObj = jcdpCallService("HseSrv", "queryOrg", "");
	 		if(retObj.flag=="true"){
	 			var len = retObj.list.length;
	 			if(len>0){
	 				document.getElementById("org_sub_id").value=retObj.list[0].orgSubId;
	 				document.getElementById("org_sub_id2").value=retObj.list[0].orgAbbreviation;
	 			}
	 			if(len>1){
	 				document.getElementById("second_org").value=retObj.list[1].orgSubId;
	 				document.getElementById("second_org2").value=retObj.list[1].orgAbbreviation;
	 			}
	 			 
	 		}
	 		
 		}
 	}
function selectName(selectName){	
	var selectname=selectName.options[selectName.selectedIndex].text ;
	var  startDate=document.getElementsByName("check_start_time")[0].value;		
	var  checkType=document.getElementsByName("check_type")[0].value;	
	
	if(selectname =="公司" ){  
		 document.getElementsByName("org_sub_id")[0].value="";
		 document.getElementsByName("org_sub_id2")[0].value="";
	
	}
	if(selectname =="二级单位" ){
		 document.getElementsByName("second_org")[0].value="";
		 document.getElementsByName("second_org2")[0].value="";
	}
	
	if(startDate!=""){
		var datePSe = startDate.split('-')[0];
		var datePSr = startDate.split('-')[1];
		var datePSt = startDate.split('-')[2];
		var datePSer=datePSe+datePSr+datePSt;
	}
    if(checkType=="1"){checkType="日常检查"}
    if(checkType=="2"){checkType="专项检查"}
    if(checkType=="3"){checkType="联系点到位"}
	 document.getElementsByName("check_name")[0].value=selectname+datePSer+checkType;

}
 	
function selectParam(selectParam){
	var selectparam=selectParam.options[selectParam.selectedIndex].text ;
	if(selectparam =="联系点到位"){			
		// document.all.oTb.rows[6].style.display="block";
		 document.getElementById('trS').style.display=''; 
		//document.getElementById( 'oTb ').rows[5].style.display= '';
	}else{
		 document.getElementById('trS').style.display='none'; 
		
	}
	
}

function checkJudge(){
	var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
	var second_org = document.getElementsByName("second_org2")[0].value;		
	 
	var check_type = document.getElementsByName("check_type")[0].value; 
    var if_contractor_team = document.getElementsByName("if_contractor_team")[0].value;
    var leadership_led = document.getElementsByName("leadership_led")[0].value;
    var check_members = document.getElementsByName("check_members")[0].value;
    var check_start_time = document.getElementsByName("check_start_time")[0].value;
    var check_end_time = document.getElementsByName("check_end_time")[0].value;
    var check_level = document.getElementsByName("check_level")[0].value;
	
		if(org_sub_id==""){
			document.getElementById("org_sub_id").value = "";
		}
		if(second_org==""){
			document.getElementById("second_org").value="";
		}
 
		if(check_type==""){
			alert("检查类别不能为空，请填写！");
			return true;
		}
		if(if_contractor_team==""){
			alert("是否承包商队伍检查不能为空，请选择！");
			return true;
		}
		if(leadership_led==""){
			alert("领导带队不能为空，请填写！");
			return true;
		}

		if(check_members==""){
				alert("检查成员不能为空，请填写！");
				return true;
			}
		if(check_start_time==""){
				alert("检查开始时间不能为空，请填写！");
				return true;
			}
		if(check_end_time==""){
				alert("检查结束时间不能为空，请填写！");
				return true;
			}
		if(check_level==""){
				alert("检查级别不能为空，请填写！");
				return true;
			}
	 
		return false;
	}
	
	


function submitButton(){ 
	if(checkJudge()){
		return;
	}
 
	var rowParams = new Array(); 
		var rowParam = {};			
		//debugger;
		var check_no = document.getElementsByName("check_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var project_no = document.getElementsByName("project_no")[0].value;		
		var check_level = document.getElementsByName("check_level")[0].value;	
		var check_unit_org = document.getElementsByName("check_unit_org")[0].value;
		var check_roots_org = document.getElementsByName("check_roots_org")[0].value;		
		var check_parts = document.getElementsByName("check_parts")[0].value;			
		var check_type = document.getElementsByName("check_type")[0].value;			
		var if_contractor_team = document.getElementsByName("if_contractor_team")[0].value;
		var contact = document.getElementsByName("contact")[0].value;
		var leadership_led = document.getElementsByName("leadership_led")[0].value;		
		var led_leadership = document.getElementsByName("led_leadership")[0].value;
		var check_members = document.getElementsByName("check_members")[0].value;		
		var check_start_time = document.getElementsByName("check_start_time")[0].value;			
		var check_end_time = document.getElementsByName("check_end_time")[0].value;			
		var check_name = document.getElementsByName("check_name")[0].value;
		var number_problems = document.getElementsByName("number_problems")[0].value;		 
		 var check_unit_id = document.getElementsByName("check_unit_id")[0].value;		
		 var check_roots_id = document.getElementsByName("check_roots_id")[0].value;		
		 
		if( number_problems =="累计问题整改信息数量"){			
			number_problems='0';
		}
		if(check_type =="3"){
			if(contact =="") {alert("检查类别为联系点到位，联系人必填！");	return;}		 
		}
		if(leadership_led =="1"){
			if(led_leadership =="") {alert("领导带队为是，带队领导必填！");	return;}		 
		}
			
		rowParam['org_sub_id'] =org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['check_level'] = check_level;
		rowParam['check_unit_org'] = encodeURI(encodeURI(check_unit_org));
		rowParam['check_roots_org'] = encodeURI(encodeURI(check_roots_org));
		rowParam['check_parts'] = encodeURI(encodeURI(check_parts));
		rowParam['check_type'] = encodeURI(encodeURI(check_type));		 
		rowParam['if_contractor_team'] = encodeURI(encodeURI(if_contractor_team));
		rowParam['contact'] = encodeURI(encodeURI(contact));
		rowParam['leadership_led'] = encodeURI(encodeURI(leadership_led));
		rowParam['led_leadership'] = encodeURI(encodeURI(led_leadership));		 
		rowParam['check_members'] = encodeURI(encodeURI(check_members));
		rowParam['check_start_time'] = encodeURI(encodeURI(check_start_time));
		rowParam['check_end_time'] = encodeURI(encodeURI(check_end_time));
		rowParam['check_name'] = encodeURI(encodeURI(check_name));
		rowParam['number_problems'] =number_problems;
		rowParam['check_unit_id'] = encodeURI(encodeURI(check_unit_id));
		rowParam['check_roots_id'] = encodeURI(encodeURI(check_roots_id));
		
		var isProject = "<%=isProject%>";

	  if(check_no !=null && check_no !=''){
	 
		    rowParam['check_no'] = check_no;
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			if(isProject=="2"){
				rowParam['project_no'] ='<%=projectInfoNo%>';
			}
	  }  				

		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_HSE_CHECK",rows);	
		top.frames('list').refreshData();	
		newClose();
 
}
function selectOrgs(){
	  var teamInfo = {
		        fkValue:"",
		        value:""
		    };
    var check_unit_org = document.getElementById("check_unit_org").value;
    window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
    if(teamInfo.fkValue!=""){
   	 document.getElementById("check_unit_org2").value = teamInfo.fkValue;
       document.getElementById("check_unit_org").value = teamInfo.value;
       document.getElementById("check_unit_id").value = teamInfo.fkValue;
   }
}

function selectOrgs2(){
	  var teamInfo = {
		        fkValue:"",
		        value:""
		    };
  var check_unit_org = document.getElementById("check_roots_org").value;
  window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
  if(teamInfo.fkValue!=""){
 	 document.getElementById("check_roots_org2").value = teamInfo.fkValue;
 	  document.getElementById("check_roots_id").value = teamInfo.fkValue;
     document.getElementById("check_roots_org").value = teamInfo.value;
    
 }
}

 

function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
        document.getElementById("org_sub_id2").value = teamInfo.value;
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("org_sub_id").value;
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
		    	 document.getElementById("second_org").value = teamInfo.fkValue; 
		        document.getElementById("second_org2").value = teamInfo.value;
			}
   
}


 

function selectTeam1(){
	
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("project_id").value = teamInfo.fkValue;
        document.getElementById("project_name").value = teamInfo.value;
    }
}

function checkText0(){
	var second_org=document.getElementById("second_org").value;
	 
	if(second_org==""){
		alert("二级单位不能为空，请填写！");
		return true;
	}
	 
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    if (!re.test(second_org))
   {
       alert("初步估计经济损失请输入数字！");
       return true;
    }
	return false;
}
 
	if(check_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "  select tr.project_no, tr.check_unit_id,tr.check_roots_id,tr.check_level, tr.org_sub_id,cl.sumnum,tr.check_no,tr.check_unit_org,tr.check_roots_org, tr.check_parts,tr.check_type,tr.if_contractor_team,tr.contact,tr.leadership_led, tr.led_leadership,tr.check_members,tr.check_start_time,tr.check_end_time,tr.check_name,tr.number_problems,tr.verifier,tr.verifier_time,tr.verifier_opinion,  tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name  from BGP_HSE_CHECK tr  left join ( select   count(check_detail_no) sumnum ,check_no  from   BGP_HSE_CHECK_DETAIL where check_no='"+ check_no +"' and bsflag='0' group by check_no) cl  on  cl.check_no=tr.check_no  left  join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left  join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left  join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0' and tr.check_no='"+ check_no +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 		   
	             document.getElementsByName("check_no")[0].value=datas[0].check_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	       		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;	    	
	     		 document.getElementsByName("check_level")[0].value=datas[0].check_level;
	    		 document.getElementsByName("check_unit_org")[0].value=datas[0].check_unit_org;
	    		 document.getElementsByName("check_roots_org")[0].value=datas[0].check_roots_org;		
	    		 document.getElementsByName("check_parts")[0].value=datas[0].check_parts;			
	    		 document.getElementsByName("check_type")[0].value=datas[0].check_type;			
	    		 document.getElementsByName("if_contractor_team")[0].value=datas[0].if_contractor_team;
	    		 document.getElementsByName("contact")[0].value=datas[0].contact;
	    	     document.getElementsByName("leadership_led")[0].value=datas[0].leadership_led;		
	    	     document.getElementsByName("led_leadership")[0].value=datas[0].led_leadership;
	    		 document.getElementsByName("check_members")[0].value=datas[0].check_members;		
	    		 document.getElementsByName("check_start_time")[0].value=datas[0].check_start_time;			
	    		 document.getElementsByName("check_end_time")[0].value=datas[0].check_end_time;			
	    		 document.getElementsByName("check_name")[0].value=datas[0].check_name;
	    		 document.getElementsByName("number_problems")[0].value=datas[0].sumnum;
	    		  document.getElementsByName("project_no")[0].value=datas[0].project_no;		
	      		  document.getElementsByName("check_unit_id")[0].value=datas[0].check_unit_id;	
	      		  document.getElementsByName("check_roots_id")[0].value=datas[0].check_roots_id;	
	      		  
		            if(datas[0].check_type !=""){
		            	if(datas[0].check_type =="3"){
		            		 document.getElementById('trS').style.display='';         	
		            	}
		            }
		    	}					
		
	    	}		
		
	}

</script>
</html>
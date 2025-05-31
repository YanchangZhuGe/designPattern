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
	
	String questions_no="";
	if(request.getParameter("questions_no") != null){
		questions_no=request.getParameter("questions_no");	
		
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
<title>问题清单</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
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
<body  onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_accident_id" name="hse_accident_id" value="<%=hse_accident_id %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>						   
						  <td class="inquire_item6">单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				        	<%} %>
				        	</td>					  
						  <td class="inquire_item6">基层单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="second_org" name="second_org" class="input_width" />
				    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	<%} %>
				        	</td>		    	  
					  </tr>					  
						<tr>								 
						  <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="questions_no" name="questions_no"   />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
					   	      	
					    <td class="inquire_item6"><font color="red">*</font>检查人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_people" name="check_people" class="input_width"   />    					    
					    </td>					    
						</tr>						
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>检查日期：</td>
					    <td class="inquire_form6"><input type="text" id="check_date" name="check_date" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton1);" />&nbsp;</td>
			 		    <td class="inquire_item6"><font color="red">*</font>被检查部门负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="check_person" name="check_person" class="input_width"   />    		
					    </td>
					  </tr>					  
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改期限：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="rectification_period" name="rectification_period" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_period,tributton2);" />&nbsp;</td>
					  </tr>	
					</table>
					<fieldset>
					<legend>
					问题描述项：
					</legend>
					<div id="tab_box_contentT" class="tab_box_content"  > 
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="60" id="buttonDis1" >
		                  <span class='zj'><a href='#' onclick='addLine2()'  title='新增'></a></span>&nbsp;&nbsp;
		                  <span class="bc"  onclick="toUpdate3()"  title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
		              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo1">
			          	<tr > 		 
				            <td  class="bt_info_odd"><font color=red>问题描述</font></td>
				            <td class="bt_info_even"><font color=red>体系要素号</font></td>		
				            <td  class="bt_info_odd">问题类别</td>			            
				            <td class="bt_info_even">问题性质</td>	
			          		<input type="hidden" id="equipmentSize1" name="equipmentSize1"   value="0" />
			          		<input type="hidden" id="hidDetailId1" name="hidDetailId1" value=""/>
			          		<input type="hidden" id="deleteRowFlag1" name="deleteRowFlag1" value="" />	          
			          		<input type="hidden" id="lineNum1" value="0"/>
			          		<TD class="bt_info_odd" width="5%">操作</TD>
			          	</tr> 
					          
			          </table>	 
			      
				</div>			
			    </fieldset>
			    <fieldset>
				<legend>
				整改要求：
				</legend> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改要求：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:550px;height:54px;" id="rectification_requirements" name="rectification_requirements"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					 
					</table>
					  </fieldset>
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
 var questions_no='<%=questions_no%>';
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
 		if(questions_no!=null && questions_no!=""){
 		 	
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
	 			if(len>2){
	 				document.getElementById("third_org").value=retObj.list[2].orgSubId;
	 				document.getElementById("third_org2").value=retObj.list[2].orgAbbreviation;
	 			}
	 		}
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

 	function selectOrg3(){
 	    var teamInfo = {
 	        fkValue:"",
 	        value:""
 	    };
 	    var third = document.getElementById("second_org").value;
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
 			    	 document.getElementById("third_org").value = teamInfo.fkValue;
 			        document.getElementById("third_org2").value = teamInfo.value;
 				}
 	}

 	function checkJudge(){
 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
		var second_org = document.getElementsByName("second_org2")[0].value;			
		var third_org = document.getElementsByName("third_org2")[0].value;			
		
		var check_people = document.getElementsByName("check_people")[0].value;
		var check_date = document.getElementsByName("check_date")[0].value;		
		var check_person = document.getElementsByName("check_person")[0].value;				
		var rectification_requirements = document.getElementsByName("rectification_requirements")[0].value;		
		var rectification_period = document.getElementsByName("rectification_period")[0].value;	
		
		
 		if(org_sub_id==""){
 			document.getElementById("org_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("third_org").value="";
 		}
 		if(check_people==""){
 			alert("检查人不能为空，请填写！");
 			return true;
 		}
 		if(check_date==""){
 			alert("检查日期不能为空，请选择！");
 			return true;
 		}
 		if(check_person==""){
 			alert("被检查部门负责人不能为空，请填写！");
 			return true;
 		}

		if(rectification_requirements==""){
 			alert("整改要求不能为空，请填写！");
 			return true;
 		}
		if(rectification_period==""){
 			alert("整改期限不能为空，请填写！");
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
		var questions_no = document.getElementsByName("questions_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;			
		
		var check_people = document.getElementsByName("check_people")[0].value;
		var check_date = document.getElementsByName("check_date")[0].value;		
		var check_person = document.getElementsByName("check_person")[0].value;					
		var rectification_requirements = document.getElementsByName("rectification_requirements")[0].value;		
		var rectification_period = document.getElementsByName("rectification_period")[0].value;			
		var project_no = document.getElementsByName("project_no")[0].value;		
		
		var isProject = "<%=isProject%>";
		
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			 
		rowParam['check_people'] = encodeURI(encodeURI(check_people));
		rowParam['check_date'] = encodeURI(encodeURI(check_date));
		rowParam['check_person'] = encodeURI(encodeURI(check_person));	 		
		rowParam['rectification_requirements'] = encodeURI(encodeURI(rectification_requirements));
		rowParam['rectification_period'] = encodeURI(encodeURI(rectification_period));
		
	  if(questions_no !=null && questions_no !=''){
		    rowParam['questions_no'] = questions_no;
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		  if(isProject=="2"){
		    rowParam['project_no'] ='<%=projectInfoNo%>';
		  }
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_LIST_QUESTIONS",rows);
		top.frames('list').refreshData();	
		newClose();
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

var problem_categoryP="";
var natureP="";
var system_elementsP="";
function addLine2(qdetail_nos,questions_nos,problem_dess,system_elementss,problem_categorys,natures,creators,create_dates,updators,modifi_dates,bsflags){
	
	var qdetail_no = "";
	var questions_no = "";
	var problem_des = ""; 
	var system_elements = "";
	var problem_category = ""; 
	var nature = "";
 
	var creator = "";
	var create_date = "";
	var updator = "";
	var modifi_date = "";
	var bsflag = "";
	
	if(qdetail_nos != null && qdetail_nos != ""){
		qdetail_no=qdetail_nos;
	}
	if(questions_nos != null && questions_nos != ""){
		questions_no=questions_nos;
	}
	if(problem_dess != null && problem_dess != ""){
		problem_des=problem_dess;
	}
	
	if(system_elementss != null && system_elementss != ""){
		system_elements=system_elementss;
	}
	if(problem_categorys != null && problem_categorys != ""){
		problem_category=problem_categorys;
	}
	if(natures != null && natures != ""){
		nature=natures;
	}
	 
	if(creators != null && creators != ""){
		creator=creators;
	}
	
	if(create_dates != null && create_dates != ""){
		create_date=create_dates;
	}
	if(updators != null && updators != ""){
		updator=updators;
	}
	if(modifi_dates != null && modifi_dates != ""){
		modifi_date=modifi_dates;
	}
	if(bsflags != null && bsflags != ""){
		bsflag=bsflags;
	}
	
	var rowNum = document.getElementById("lineNum1").value;	
	var tr = document.getElementById("hseTableInfo1").insertRow();
	
	tr.align="center";		

  	if(rowNum % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	

	tr.id = "row_" + rowNum + "_";  
	tr.insertCell().innerHTML = '<input type="hidden"  name="qdetail_no' + '_' + rowNum + '" value="'+qdetail_no+'"/>'+ '<textarea name="problem_des' + '_' + rowNum + '"  id="problem_des' + '_' + rowNum + '"    style="height:24px; width:240px;" class="textarea" >'+problem_des+'</textarea> '+'<input type="hidden"  name="questions_no' + '_' + rowNum + '" value="'+questions_no+'"/>'+	'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+	'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+	'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
	
	
	if(system_elements == ""){  
		 tr.insertCell().innerHTML='<select  style="width:80px;"    name="system_elements' + '_' + rowNum + '" id="system_elements' + '_' + rowNum + '"   >'+
		 '<option value="">请选择</option><option value="5110000047000000001" >5.1</option><option value="5110000047000000002">5.2</option><option value="5110000047000000003">5.3.1</option><option value="5110000047000000004">5.3.2</option><option value="5110000047000000005">5.3.3</option>'+
		 '<option value="5110000047000000006">5.3.4</option><option value="5110000047000000007" >5.4.1</option><option value="5110000047000000008">5.4.2</option><option value="5110000047000000009">5.4.3</option><option value="5110000047000000010">5.4.4</option><option value="5110000047000000011">5.4.5</option>'+
		 '<option value="5110000047000000012">5.4.6</option><option value="5110000047000000013" >5.4.7</option><option value="5110000047000000014">5.5.1</option><option value="5110000047000000015">5.5.2</option><option value="5110000047000000016">5.5.3</option><option value="5110000047000000017">5.5.4</option>'+
		 '<option value="5110000047000000018">5.5.5</option><option value="5110000047000000019" >5.5.6</option><option value="5110000047000000020">5.5.7</option><option value="5110000047000000021">5.5.8</option><option value="5110000047000000022">5.6.1</option><option value="5110000047000000023">5.6.2</option>'+
		 '<option value="5110000047000000024">5.6.3</option><option value="5110000047000000025" >5.6.4</option><option value="5110000047000000026">5.6.5</option><option value="5110000047000000027">5.6.6</option><option value="5110000047000000028">5.7</option></select>';
	 
	}else{
		getElementsList(system_elements);
		tr.insertCell().innerHTML = '<select  style="width:80px;"  name="system_elements' + '_' + rowNum + '" id="system_elements' + '_' + rowNum + '"  > '+system_elementsP+'</select>';
	}
	
	if(problem_category == ""){
		tr.insertCell().innerHTML = '<select  style="width:80px;"  name="problem_category' + '_' + rowNum + '" id="problem_category' + '_' + rowNum + '"  ><option value="">请选择</option><option value="违章指挥" >违章指挥</option><option value="违章操作">违章操作</option><option value="违反劳动纪律">违反劳动纪律</option><option value="监护失误">监护失误</option><option value="管理缺陷">管理缺陷</option></select>';
	}else{
		problemCategory(problem_category);
		tr.insertCell().innerHTML = '<select  style="width:80px;"  name="problem_category' + '_' + rowNum + '" id="problem_category' + '_' + rowNum + '"  > '+problem_categoryP+'</select>';
	}
	if(nature == ""){
		tr.insertCell().innerHTML = '<select  style="width:80px;"  name="nature' + '_' + rowNum + '" id="nature' + '_' + rowNum + '"  ><option value="">请选择</option><option value="特大" >特大</option><option value="重大">重大</option><option value="较大">较大</option><option value="一般">一般</option></select>';
	}else{
		natureF(nature);
		tr.insertCell().innerHTML = '<select  style="width:80px;"  name="nature' + '_' + rowNum + '" id="nature' + '_' + rowNum + '"  > '+natureP+'</select>';
	}
	

	var td = tr.insertCell();
	td.style.display = "";
	td.innerHTML = '<input type="hidden" name="order1" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
	
	document.getElementById("lineNum1").value = parseInt(rowNum) + 1;	
 
}

function getElementsList(selectValue){
	system_elementsP = '<option value="">请选择</option>';
	  var allTeamList=jcdpCallService("HseOperationSrv","queryElements","");	
 	if(allTeamList != null){
	for(var m = 0; m < allTeamList.detailInfo.length; m++){
		var templateMap = allTeamList.detailInfo[m];
		if(templateMap.value==selectValue){
			system_elementsP+='<option value='+templateMap.value+' selected="selected" >'+templateMap.label+'</option>';	
		} 
		system_elementsP+='<option value='+templateMap.value+'>'+templateMap.label+'</option>';	
	}	
	}
	
}



function problemCategory(selectValue){
	problem_categoryP='<option value="">请选择</option>'; 
		if(selectValue=='违章指挥'){
			problem_categoryP+='<option value="违章指挥" selected="selected" >违章指挥</option>';	
			problem_categoryP+='<option value="违章操作" >违章操作</option>';
			problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
			problem_categoryP+='<option value="监护失误" >监护失误</option>';
			problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>'; 
		}else if(selectValue=='违章操作'){
			problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
			problem_categoryP+='<option value="违章操作" selected="selected" >违章操作</option>';
			problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
			problem_categoryP+='<option value="监护失误" >监护失误</option>';
			problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>';
			
		}else if(selectValue=='违反劳动纪律'){
			problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
			problem_categoryP+='<option value="违章操作" selected="selected" >违章操作</option>';
			problem_categoryP+='<option value="违反劳动纪律"  selected="selected"  >违反劳动纪律</option>';
			problem_categoryP+='<option value="监护失误" >监护失误</option>';
			problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>';
		}else if(selectValue=='监护失误'){
			problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
			problem_categoryP+='<option value="违章操作" selected="selected" >违章操作</option>';
			problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
			problem_categoryP+='<option value="监护失误"  selected="selected"  >监护失误</option>';
			problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>';
		}else if(selectValue=='管理缺陷'){
			problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
			problem_categoryP+='<option value="违章操作" >违章操作</option>';
			problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
			problem_categoryP+='<option value="监护失误" >监护失误</option>';
			problem_categoryP+='<option value="管理缺陷"  selected="selected"  >管理缺陷</option>';
		}
	
}


function natureF(selectValue){
	natureP='<option value="">请选择</option>';
	if(selectValue=='特大'){
		natureP+='<option value="特大" selected="selected" >特大</option>';	
		natureP+='<option value="重大" >重大</option>';
		natureP+='<option value="较大" >较大</option>';
		natureP+='<option value="一般" >一般</option>';
	}else if(selectValue=='重大'){
		natureP+='<option value="特大"  >特大</option>';	
		natureP+='<option value="重大" selected="selected" >重大</option>';
		natureP+='<option value="较大" >较大</option>';
		natureP+='<option value="一般" >一般</option>';
	}else if(selectValue=='较大'){
		natureP+='<option value="特大" >特大</option>';	
		natureP+='<option value="重大" >重大</option>';
		natureP+='<option value="较大"  selected="selected" >较大</option>';
		natureP+='<option value="一般" >一般</option>';
	}else if(selectValue=='一般'){
		natureP+='<option value="特大" >特大</option>';	
		natureP+='<option value="重大" >重大</option>';
		natureP+='<option value="较大" >较大</option>';
		natureP+='<option value="一般" selected="selected" >一般</option>';
	}
	
	
}

function toUpdate3(){	
	var rowNum = document.getElementById("lineNum1").value;			
	var rowParams = new Array();
	var questions_nos = document.getElementsByName("questions_no")[0].value;		
	 if(questions_nos !=null && questions_nos !=''){
	for(var i=0;i<rowNum;i++){
		var rowParam = {};		  
		var qdetail_no =document.getElementsByName("qdetail_no_"+i)[0].value; 
		var questions_no =document.getElementsByName("questions_no_"+i)[0].value;
		
		var problem_des = document.getElementsByName("problem_des_"+i)[0].value;
		var system_elements = document.getElementsByName("system_elements_"+i)[0].value;
		var problem_category =document.getElementsByName("problem_category_"+i)[0].value;
		var nature = document.getElementsByName("nature_"+i)[0].value; 
		
		var creator = document.getElementsByName("creator_"+i)[0].value;
		var create_date = document.getElementsByName("create_date_"+i)[0].value;
		var updator = document.getElementsByName("updator_"+i)[0].value;
		var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
		var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
		if(qdetail_no !=null && qdetail_no !=''){ 
			rowParam['problem_des'] =encodeURI(encodeURI(problem_des)); 	
			rowParam['system_elements'] = encodeURI(encodeURI(system_elements));
			rowParam['problem_category'] = encodeURI(encodeURI(problem_category)); 
			rowParam['nature'] =encodeURI(encodeURI(nature)); 				
		    rowParam['questions_no'] = questions_no; 
		    rowParam['qdetail_no'] = qdetail_no;		    
		    
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;	
			
		}else{
			rowParam['problem_des'] =encodeURI(encodeURI(problem_des)); 	
			rowParam['system_elements'] = encodeURI(encodeURI(system_elements));
			rowParam['problem_category'] = encodeURI(encodeURI(problem_category)); 
			rowParam['nature'] =encodeURI(encodeURI(nature)); 
			
		    rowParam['questions_no'] = questions_nos;
			rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';	
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;		 
		}
			rowParams[rowParams.length] = rowParam; 

	}
		var rows=JSON.stringify(rowParams);			 
		saveFunc("BGP_LIST_QUESTIONS_DETAIL",rows);	
		top.frames('list').loadDataDetail(questions_nos);
 
  }else{			  
		  alert("请先选中一条记录!");
	     	return;		
  }				
	
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
	if(bsflag!=""){
		line.style.display = 'none';
		document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
	}else{
		line.parentNode.removeChild(line);
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
 
	if(questions_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "  select  tr.project_no,tr.questions_no	,tr.org_sub_id,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation as  org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'     where tr.bsflag = '0' and tr.questions_no='"+questions_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 
		   
	             document.getElementsByName("questions_no")[0].value=datas[0].questions_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;		  
	    		 	    		 
	    		document.getElementsByName("check_people")[0].value=datas[0].check_people;	
	    		document.getElementsByName("check_date")[0].value=datas[0].check_date;		
	    		document.getElementsByName("check_person")[0].value=datas[0].check_person;				
	
	    		document.getElementsByName("rectification_requirements")[0].value=datas[0].rectification_requirements;		
	            document.getElementsByName("rectification_period")[0].value=datas[0].rectification_period;					
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;
	    
			}					
		
	    	}	
		
		  document.getElementById("lineNum1").value="0"; 
		   querySql1 = "select qdetail_no,questions_no,problem_des,problem_category,system_elements,nature,creator,create_date,updator,modifi_date,bsflag   from BGP_LIST_QUESTIONS_DETAIL  where  bsflag='0' and questions_no='" + questions_no + "'  order by  modifi_date";
		   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
			if(queryRet1.returnCode=='0'){
			  datas1 = queryRet1.datas;	 
				if(datas1 != null && datas1 != ''){	  
					for(var i = 0; i<datas1.length; i++){										 
			       addLine2(datas1[i].qdetail_no,datas1[i].questions_no,datas1[i].problem_des,datas1[i].system_elements,datas1[i].problem_category,datas1[i].nature,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
			    		      
					}
					
				}
		    }	
		
	}

</script>
</html>
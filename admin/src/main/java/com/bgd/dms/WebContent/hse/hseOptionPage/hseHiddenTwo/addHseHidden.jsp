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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat formats = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String curDates = formats.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String hidden_no="";
	if(request.getParameter("hidden_no") != null){
		hidden_no=request.getParameter("hidden_no");	
		
	}
    String projectInfoNo ="";
	if(request.getParameter("projectInfoNo") != null){
		projectInfoNo=request.getParameter("projectInfoNo");	    		
	}

	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>隐患信息</title>
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
<body  onload="queryOrg();getHazardBig(); listInfo();exitSelect()" >
<form name="form" id="form"  method="post" action="" >
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
					    	<input type="hidden" id="aa" name="aa" value="" />
					       	<input type="hidden" id="bb" name="bb" value="" />
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="hidden_no" name="hidden_no"   />
					     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
				
					    <td class="inquire_item6"> <font color="red">*</font>作业场所/岗位：</td>
					    <td class="inquire_form6">
					    <input type="text" id="operation_post" name="operation_post" class="input_width"   />    					    
					    </td>					    
						</tr>						
					  <tr>	
					   				 
					    <td class="inquire_item6"> 识别方式：</td>
					    <td class="inquire_form6">  
					    <select id="identification_method" name="identification_method" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >集中识别</option>
					       <option value="2" >随机识别</option>
					       <option value="3" >专项识别</option>
					       <option value="4" >来访者识别</option>
					       <option value="5" >安全观察与沟通</option>
					       <option value="6" >工作安全分析</option>
					       <option value="7" >工艺安全分析</option>
					       <option value="8" >其它</option>
						</select> 		
					    </td>
					     <td class="inquire_item6"> </td>
					    <td class="inquire_form6"><input type="hidden" id="hidden_name" name="hidden_name" class="input_width"    /></td>	
					    
					  </tr>		
				 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>隐患危害类型（大类）：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="hazard_big" name="hazard_big" class="select_width" onchange="getHazardCenter()"></select> 	
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>隐患危害类型（小类）：</td>
					    <td class="inquire_form6"> 
					    <select id="hazard_center" name="hazard_center" class="select_width">
						</select> 			
					    </td>
					    </tr>	
 
					    <tr>
					    <td class="inquire_item6"> <font color="red">*</font>隐患级别：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="hidden_level" name="hidden_level" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >特大</option>
					       <option value="2" >重大</option> 
					       <option value="3" >较大</option>
					       <option value="4" >一般</option> 
						</select> 	
						 <td class="inquire_item6"><font color="red">*</font>隐患类别：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="hidden_type_s" name="hidden_type_s" class="select_width">
						       <option value="" >请选择</option>
						       <option value="民爆物品" >民爆物品</option>
						       <option value="交通伤害" >交通伤害</option> 
						       <option value="机械伤害" >机械伤害</option>
						       <option value="火灾" >火灾</option> 
						       <option value="触电" >触电</option> 
						       <option value="起重伤害" >起重伤害</option> 
						       <option value="水上作业" >水上作业</option> 
						       <option value="淹溺" >淹溺</option> 
						       <option value="灼烫" >灼烫</option> 
						       <option value="高处坠落" >高处坠落</option> 
						       <option value="坍塌" >坍塌</option> 
						       <option value="锅炉压力容器" >锅炉压力容器</option> 
						       <option value="环境" >环境</option> 						       
						       <option value="职业健康" >职业健康</option> 
						       <option value="职业禁忌症" >职业禁忌症</option> 
						       <option value="疫情" >疫情</option> 
						       <option value="中毒和窒息" >中毒和窒息</option> 
						       <option value="其他" >其他</option> 
							</select> 	
							 
						    </tr>	
						    <tr>
						    <td class="inquire_item6"> 是否新增：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="whether_new" name="whether_new" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >是</option>
						       <option value="2" >否</option> 
							</select> 	
						    </td> 
						    <td class="inquire_item6">识别人员类别：</td>
						    <td class="inquire_form6"> 
						    <select id="rpeople_type" name="rpeople_type" class="select_width">
						       <option value="" >请选择</option>
						       <option value="机关管理人员" >机关管理人员</option>
						       <option value="直线管理者" >直线管理者</option> 
						       <option value="HSE专业人员（管理和监督）" >HSE专业人员（管理和监督）</option>
						       <option value="操作岗位员工（合同化）" >操作岗位员工（合同化）</option> 
						       <option value="操作岗位员工（市场化）" >操作岗位员工（市场化）</option> 
						       <option value="季节性临时用工" >季节性临时用工</option> 
						       <option value="承包商员工" >承包商员工</option> 
							</select> 	
						    </td>
						    </tr>	
						    
						    <tr>
						    <td class="inquire_item6"> 识别人：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="recognition_people" name="recognition_people" class="input_width"   />    		
						    </td>

							    <td class="inquire_item6"> <font color="red">*</font>隐患存在原因：</td>
							    <td class="inquire_form6"> 
							    <select id="hidden_yuanyin" name="hidden_yuanyin" class="select_width">
							       <option value="" >请选择</option>
							       <option value="制度或操作程序缺陷" >制度或操作程序缺陷</option>
							       <option value="制度或操作程序未落实" >制度或操作程序未落实</option> 
							       <option value="未培训或培训效果不良" >未培训或培训效果不良</option>
							       <option value="设计缺陷" >设计缺陷</option> 
							       <option value="其他" >其他</option> 
								</select> 			
							    </td>
								  </tr>	
								  
								  <tr>
							    <td class="inquire_item6"><font color="red">*</font>上报日期：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="report_date" name="report_date" class="input_width"    readonly="readonly"/>
							   <div style="display:block;"> &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton1);" />&nbsp;</div></td>
							  
							  </tr>						    
					    
					     </table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>隐患描述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:450px;" id="hidden_description" name="hidden_description"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
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
 var hidden_no='<%=hidden_no%>';
 var projectInfoNo='<%=projectInfoNo%>';
	document.getElementsByName("report_date")[0].value='<%=curDates%>';
//键盘上只有删除键，和左右键好用
 function noEdit(event){
 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
 		return true;
 	}else{
 		return false;
 	}
 }

 	function queryOrg(){
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
 	
	function checkJudge(){
 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
		var second_org = document.getElementsByName("second_org2")[0].value;			
		var third_org = document.getElementsByName("third_org2")[0].value;			
		
		var operation_post = document.getElementsByName("operation_post")[0].value;
		var hidden_yuanyin = document.getElementsByName("hidden_yuanyin")[0].value;		
		var identification_method = document.getElementsByName("identification_method")[0].value;			
		var hazard_big = document.getElementsByName("hazard_big")[0].value;		
		var hazard_center = document.getElementsByName("hazard_center")[0].value;		
		var whether_new = document.getElementsByName("whether_new")[0].value;			 		
		var recognition_people = document.getElementsByName("recognition_people")[0].value;
		var report_date = document.getElementsByName("report_date")[0].value;		
		var hidden_level = document.getElementsByName("hidden_level")[0].value;					 
		var hidden_description = document.getElementsByName("hidden_description")[0].value;		
		var hidden_type_s = document.getElementsByName("hidden_type_s")[0].value;
		
 		if(org_sub_id==""){
 			document.getElementById("org_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("third_org").value="";
 		}
 

 		if(operation_post==""){
 			alert("作业场所/岗位不能为空，请填写！");
 			return true;
 		}
 		
 		
 		if(hidden_level==""){
 			alert("隐患级别不能为空，请填写！");
 			return true;
 		}
 		if(hidden_type_s==""){
 			alert("隐患类别不能为空，请填写！");
 			return true;
 		}
 		
 		if(hidden_yuanyin==""){
 			alert("隐患存在原因不能为空，请填写！");
 			return true;
 		}
 		
 		
		if(hazard_big==""){
 			alert("隐患危害类型大类不能为空，请填写！");
 			return true;
 		}
		if(hazard_center==""){
 			alert("隐患危害类型小类不能为空，请填写！");
 			return true;
 		}
		 
		if(report_date==""){
 			alert("上报日期不能为空，请填写！");
 			return true;
 		}
 
		if(hidden_description==""){
 			alert("隐患描述不能为空，请填写！");
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
		var hidden_no = document.getElementsByName("hidden_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;			
		
		var operation_post = document.getElementsByName("operation_post")[0].value;
		var hidden_name = document.getElementsByName("hidden_name")[0].value;		
		var identification_method = document.getElementsByName("identification_method")[0].value;			
		var hazard_big = document.getElementsByName("hazard_big")[0].value;		
		var hazard_center = document.getElementsByName("hazard_center")[0].value;		
		var whether_new = document.getElementsByName("whether_new")[0].value;			
 	 
		var recognition_people = document.getElementsByName("recognition_people")[0].value;
		var report_date = document.getElementsByName("report_date")[0].value;		
		var hidden_level = document.getElementsByName("hidden_level")[0].value;		
		var project_no = document.getElementsByName("project_no")[0].value;				
		var hidden_description = document.getElementsByName("hidden_description")[0].value;
		
		var rpeople_type = document.getElementsByName("rpeople_type")[0].value;	
		var hidden_yuanyin = document.getElementsByName("hidden_yuanyin")[0].value;	
		var hidden_type_s = document.getElementsByName("hidden_type_s")[0].value;

		var isProject = "<%=isProject%>";
 		if(hidden_no ==null || hidden_no ==''){
			if(hazard_big =="5110000032000000003"){
				var rowParamsA = new Array(); 
				var rowParamA= {};			
	 			rowParamA['org_sub_id'] = org_sub_id;
				rowParamA['second_org'] = second_org;
				if(isProject=="2"){
					rowParamA['project_no'] ='<%=projectInfoNo%>';
				}
				rowParamA['third_org'] = third_org;	
				rowParamA['sites_post'] = encodeURI(encodeURI(operation_post));
				rowParamA['hazard_class'] = encodeURI(encodeURI(hazard_center));
			    rowParamA['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParamA['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParamA['create_date'] ='<%=curDate%>';
				rowParamA['modifi_date'] = '<%=curDate%>';		
				rowParamA['bsflag'] = bsflag;
				rowParamsA[rowParamsA.length] = rowParamA; 
				var rowsA=JSON.stringify(rowParamsA);	 
				saveFunc("BGP_ILLEGAL_MANAGEMENT",rowsA);
				alert('选择隐患危害类型大类为行为性，已成功在违章管理中创建了一条违章记录！');
			}
 		}
		
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			
		
		rowParam['operation_post'] = encodeURI(encodeURI(operation_post));
		rowParam['hidden_name'] = encodeURI(encodeURI(hidden_name));
		rowParam['identification_method'] = encodeURI(encodeURI(identification_method));
		rowParam['hazard_big'] = encodeURI(encodeURI(hazard_big));		 		
		rowParam['hazard_center'] = encodeURI(encodeURI(hazard_center));
		rowParam['whether_new'] = encodeURI(encodeURI(whether_new));
				
		rowParam['recognition_people'] = encodeURI(encodeURI(recognition_people));
		rowParam['report_date'] = report_date;
		rowParam['hidden_level'] = encodeURI(encodeURI(hidden_level));
		rowParam['hidden_description'] = encodeURI(encodeURI(hidden_description));
		rowParam['rpeople_type'] = encodeURI(encodeURI(rpeople_type));
		rowParam['hidden_yuanyin'] = encodeURI(encodeURI(hidden_yuanyin));
		rowParam['hidden_type_s'] = encodeURI(encodeURI(hidden_type_s));
		
	  if(hidden_no !=null && hidden_no !=''){
		    rowParam['hidden_no'] = hidden_no;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';
			if(isProject=="2"){
				rowParam['project_no'] ='<%=projectInfoNo%>';
			}
			rowParam['bsflag'] = bsflag;
			rowParam['subflag'] = '0';
			
			
			
			
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_HSE_HIDDEN_INFORMATION",rows);	
		//top.frames('list').getTab3('0');	
		//top.frames('list').frames[0].refreshData();	
		top.frames('list').refreshData();	
		newClose();
}

function afterSave(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '保存成功';
	if(failHint==undefined) failHint = '保存失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		alert(successHint);
		//window.opener.refreshData();
		//window.close();
	}
}
 
//得到所有
 
function getHazardBig(){
	var selectObj = document.getElementById("hazard_big"); 
	document.getElementById("hazard_big").innerHTML="";
	selectObj.add(new Option('请选择',""),0);

	var queryHazardBig=jcdpCallService("HseOperationSrv","queryHazardBig","");	
 
	for(var i=0;i<queryHazardBig.detailInfo.length;i++){
		var templateMap = queryHazardBig.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	var selectObj1 = document.getElementById("hazard_center");
	document.getElementById("hazard_center").innerHTML="";
	selectObj1.add(new Option('请选择',""),0);
}

function getHazardCenter(){
    var hazardBig = "hazardBig="+document.getElementById("hazard_big").value;   
	var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);	

	var selectObj = document.getElementById("hazard_center");
	document.getElementById("hazard_center").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(HazardCenter.detailInfo!=null){
		for(var i=0;i<HazardCenter.detailInfo.length;i++){
			var templateMap = HazardCenter.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
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
 function exitSelect(){
	 
		var selectObj = document.getElementById("hazard_big");  
		var aa = document.getElementById("aa").value; 
		var bb = document.getElementById("bb").value;  
	    for(var i = 0; i<selectObj.length; i++){ 
	        if(selectObj.options[i].value == aa){ 
	        	selectObj.options[i].selected = 'selected';     
	        } 
	       }  
	    var hazardBig = "hazardBig="+ document.getElementById("aa").value;
	    var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);		 
		var selectObj2 = document.getElementById("hazard_center");
		document.getElementById("hazard_center").innerHTML="";
		selectObj2.add(new Option('请选择',""),0);

		if(HazardCenter.detailInfo!=null){
			for(var t=0;t<HazardCenter.detailInfo.length;t++){
				var templateMap = HazardCenter.detailInfo[t];
				selectObj2.add(new Option(templateMap.label,templateMap.value),t+1);
			}
		}
	    for(var j = 0; j<selectObj2.length; j++){ 
	        if(selectObj2.options[j].value == bb){ 
	        	selectObj2.options[j].selected = 'selected';     
	        } 
	       }  
	     
 }
 function  listInfo(){
	if(hidden_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "   select  tr.rpeople_type,tr.hidden_yuanyin,tr.hidden_type_s, tr.project_no,tr.org_sub_id,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date,tr.hidden_level,  tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_HIDDEN_INFORMATION tr    left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0' and tr.hidden_no='"+ hidden_no +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 
				 document.getElementsByName("hidden_no")[0].value=datas[0].hidden_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
	    		 
	    		    document.getElementsByName("operation_post")[0].value=datas[0].operation_post;
	    			document.getElementsByName("hidden_name")[0].value=datas[0].hidden_name;		
	    			document.getElementsByName("identification_method")[0].value=datas[0].identification_method;			
	    		    document.getElementsByName("hazard_big")[0].value=datas[0].hazard_big;		
	    		    document.getElementsByName("aa")[0].value=datas[0].hazard_big;	    		    
	    			document.getElementsByName("hazard_center")[0].value=datas[0].hazard_center;	
	    		    document.getElementsByName("bb")[0].value=datas[0].hazard_center;	
	    		    document.getElementsByName("whether_new")[0].value=datas[0].whether_new;				    	 		
	    			document.getElementsByName("recognition_people")[0].value=datas[0].recognition_people;
	    			document.getElementsByName("report_date")[0].value=datas[0].report_date;		
	    		    document.getElementsByName("hidden_level")[0].value=datas[0].hidden_level;		
	    		    document.getElementsByName("hidden_description")[0].value=datas[0].hidden_description;			
	    			document.getElementsByName("project_no")[0].value=datas[0].project_no;		    			    
	    		     	  
	    			 document.getElementsByName("rpeople_type")[0].value=datas[0].rpeople_type;	
	    			 document.getElementsByName("hidden_yuanyin")[0].value=datas[0].hidden_yuanyin;	
	    			 document.getElementsByName("hidden_type_s")[0].value=datas[0].hidden_type_s;
			}					
		
	    	}		
		
	}
 }
</script>
</html>
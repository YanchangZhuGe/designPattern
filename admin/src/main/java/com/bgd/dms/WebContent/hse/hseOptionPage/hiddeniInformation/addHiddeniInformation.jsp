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
	
	String hidden_no="";
	if(request.getParameter("hidden_no") != null){
		hidden_no=request.getParameter("hidden_no");	
		
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
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
				          	<td class="inquire_item6">二级单位：</td>
				        	<td class="inquire_form6">
				        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
					    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	<%} %>
				        	</td>    	  
					  </tr>					  
						<tr>								 
						  <td class="inquire_item6"><font color="red">*</font>基层单位：</td>
					      	<td class="inquire_form6">
					    	<input type="hidden" id="aa" name="aa" value="" />
					       	<input type="hidden" id="bb" name="bb" value="" />
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="hidden_no" name="hidden_no"   />
					     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					   
					    <td class="inquire_item6"><font color="red">*</font>作业场所/岗位：</td>
					    <td class="inquire_form6">
					    <input type="text" id="operation_post" name="operation_post" class="input_width"   />    					    
					    </td>					    
						</tr>						
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>隐患名称：</td>
					    <td class="inquire_form6"><input type="text" id="hidden_name" name="hidden_name" class="input_width"    /></td>					 
			 		    <td class="inquire_item6"><font color="red">*</font>识别方法：</td>
					    <td class="inquire_form6">  
					    <select id="identification_method" name="identification_method" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >集中识别</option>
					       <option value="2" >随机识别</option>
					       <option value="3" >专项识别</option>
					       <option value="4" >来访者识别</option>
						</select> 		
					    </td>
					  </tr>		
				 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>危害因素大类：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="hazard_big" name="hazard_big" class="select_width" onchange="getHazardCenter()"></select> 	
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>危害因素中类：</td>
					    <td class="inquire_form6"> 
					    <select id="hazard_center" name="hazard_center" class="select_width">
						</select> 			
					    </td>
					    </tr>	
					    
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>是否新增：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="whether_new" name="whether_new" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >是</option>
						       <option value="2" >否</option> 
							</select> 	
						    </td>
						    <td class="inquire_item6"><font color="red">*</font>识别人：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="recognition_people" name="recognition_people" class="input_width"   />    		
						    </td>
						    </tr>	
							  <tr>
							    <td class="inquire_item6"><font color="red">*</font>上报日期：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="report_date" name="report_date" class="input_width"    readonly="readonly"/>
							    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton1);" />&nbsp;</td>
							    <td class="inquire_item6"><font color="red">*</font>风险级别：</td>
							    <td class="inquire_form6"> 				 
                                <input style=" border-bottom-color:#3333FF; border-bottom-width:1px; background:transparent;  border-top-style:none;   border-left-style:none;   border-right-style:none;" type="text" id="risk_levels" name="risk_levels" value=""  onclick="openFile('')" readonly="readonly" />
 
							    </td>
							    </tr>	
								  <tr>
								    <td class="inquire_item6"><font color="red">*</font>整改状态：</td> 					   
								    <td class="inquire_form6"  align="center" > 
								    <input style=" border-bottom-color:#3333FF; border-bottom-width:1px; background:transparent;  border-top-style:none;   border-left-style:none;   border-right-style:none;" type="text" id="rectification_state" name="rectification_state" value=""  onclick="openFile('')" readonly="readonly" />
								 
								   </td>
								    <td class="inquire_item6"><font color="red">*</font>奖励状态：</td>
								    <td class="inquire_form6"> 
								    <input style=" border-bottom-color:#3333FF; border-bottom-width:1px; background:transparent;  border-top-style:none;   border-left-style:none;   border-right-style:none;" type="text" id="reward_state" name="reward_state" value=""  onclick="openFile('')" readonly="readonly" />
 				                   <a href='#' onclick=openFile('')  style="text-decoration:underline;" ><font color='blue' id="reward_state" > </font></a>
								    </td>
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

 	
function submitButton(){  
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
		var risk_levels = document.getElementsByName("risk_levels")[0].value;		
		var rectification_state = document.getElementsByName("rectification_state")[0].value;		
		var reward_state = document.getElementsByName("reward_state")[0].value;	
		var hidden_description = document.getElementsByName("hidden_description")[0].value;			
 
		if(hazard_big =="5110000032000000003"){
			var rowParamsA = new Array(); 
			var rowParamA= {};			
 			rowParamA['org_sub_id'] = org_sub_id;
			rowParamA['second_org'] = second_org;
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
			alert('选择危害因素大类为行为性，已成功在违章管理中创建了一条违章记录！');
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
		rowParam['report_date'] = '<%=curDate%>';
		rowParam['risk_levels'] = encodeURI(encodeURI(risk_levels));
		rowParam['rectification_state'] = encodeURI(encodeURI(rectification_state));		 		
		rowParam['reward_state'] = encodeURI(encodeURI(reward_state));
		rowParam['hidden_description'] = encodeURI(encodeURI(hidden_description));
		
	  if(hidden_no !=null && hidden_no !=''){
		    rowParam['hidden_no'] = hidden_no;
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
		  
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_HIDDEN_INFORMATION",rows);	
		//top.frames('list').getTab3('0');	
		top.frames('list').frames[0].refreshData();	
		newClose();
	
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
		
		querySql = "   select  tr.org_sub_id,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date,tr.risk_levels,  tr.rectification_state,tr.reward_state,tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HIDDEN_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0' and tr.hidden_no='"+ hidden_no +"'";				 	 
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
	    		    document.getElementsByName("risk_levels")[0].value=datas[0].risk_levels;		
	    		 	document.getElementsByName("rectification_state")[0].value=datas[0].rectification_state;		
	    			document.getElementsByName("reward_state")[0].value=datas[0].reward_state;	
	    		    document.getElementsByName("hidden_description")[0].value=datas[0].hidden_description;			
	    			 
	    		     	  
	    
			}					
		
	    	}		
		
	}
 }
</script>
</html>
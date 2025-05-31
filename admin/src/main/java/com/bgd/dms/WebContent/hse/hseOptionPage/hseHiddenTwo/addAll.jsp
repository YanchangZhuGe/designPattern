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
    String hiddenNo ="";
	if(request.getParameter("hiddenNo") != null){
		hiddenNo=request.getParameter("hiddenNo");	    		
	}
    String paramS ="";
	if(request.getParameter("paramS") != null){
		paramS=request.getParameter("paramS");	    		
	}
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<title>选择页面</title>
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
<body  onload="getRiskLevels();getControlEffect();" >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box" style="width:1000px; height:575px;">
  <div id="new_table_box_content" style="width:1000px; height:575px;">
    <div id="new_table_box_bg"   style="width:978px; height:520px; ">		   
	 <div id="type3" style="display:none">
			<fieldset>
			<legend>
				评价信息
			</legend>
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
	         	 <tr>	
				    <td class="inquire_item6"><font color="red">*</font>评价日期：</td>
				    <td class="inquire_form6"><input type="text" id="evaluation_date" name="evaluation_date" class="input_width"   readonly="readonly"  /></td>	 
				    <td class="inquire_item6"><font color="red">*</font>评价级别：</td> 					   
				    <td class="inquire_form6"  align="center" > 
			      	<input type="hidden" id="mdetail_no" name="mdetail_no" value="" />
				    <select id="evaluation_level" name="evaluation_level" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >公司</option>
				       <option value="2" >二级单位</option> 
				       <option value="3" >基层单位</option> 
				       <option value="4" >基层单位下属单位</option>  
					</select> 	
				    </td>
				    <td class="inquire_item6"><font color="red">*</font>评价人员：</td>
				    <td class="inquire_form6"><input type="text" id="evaluation_personnel" name="evaluation_personnel" class="input_width"    /></td>
				    </tr>	
					  <tr>						   	 
					    <td class="inquire_item6"><font color="red">*</font>主要评价方法：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="main_methods" name="main_methods" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >矩阵法</option>
					       <option value="2" >LEC</option> 
					       <option value="3" >HAZOP</option>
					       <option value="4" >专家评估法</option> 
					       <option value="5" >安全检查表法</option>
					       <option value="6" >默认为矩阵法</option> 
						</select>  
					    </td>					 	
					    <td class="inquire_item6"><font color="red">*</font>评价状态：</td>
					    <td class="inquire_form6"><input type="text" id="evaluation_state" name="evaluation_state" class="input_width"    value="未评价" readonly="readonly"       /></td>	 
					    <td class="inquire_item6"><font color="red">*</font>风险等级：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					       <select id="risk_levels" name="risk_levels" class="select_width"  ></select> 	
					    </td>
					    </tr>	
					    
					     <tr>	
					    <td class="inquire_item6"> <font color="red">*</font>危害后果：</td>
					    <td class="inquire_form6"><input type="text" id="harmful_consequences" name="harmful_consequences" class="input_width"    /></td>	 
					    <td class="inquire_item6"> </td> 					   
					    <td class="inquire_form6"  align="center" >  
					    </td>
					   <td class="inquire_item6"> </td> 					   
					    <td class="inquire_form6"  align="center" >  
					    </td>
					    </tr>	
					    
			        </table>
				 
				</fieldset><br>
		</div>
		 <div id="type2" style="display:none">
				<fieldset>
				<legend>
					整改信息
				</legend>
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >		
					    <tr>	
						  <td class="inquire_item6"><font color="red">*</font>整改状态：</td>
						    <td class="inquire_form6">
						    <select id="rectification_state" name="rectification_state" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >已整改</option>
						       <option value="2" >未整改</option> 
						       <option value="3" >正在整改</option>  
							</select> 
						    </td>	 	 
						    <td class="inquire_item6">整改措施类型：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="rectification_measures_type" name="rectification_measures_type" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >消除</option>
						       <option value="2" >工程/设计</option> 
						       <option value="3" >行政/程序</option> 
						       <option value="4" >劳保</option>   
							</select> 	
						    </td>   
						    <td class="inquire_item6"><font color="red">*</font>整改或监控措施：</td>
						    <td class="inquire_form6"><input type="text" id="rectification_measures" name="rectification_measures" class="input_width"    /></td>
						    </tr>	
							  <tr>								    	 
							    <td class="inquire_item6"><font color="red">*</font>控制后风险等级：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <select id="control_effect" name="control_effect" class="select_width">
							       
								</select>  
							    </td>							
					         <td class="inquire_item6"> 整改负责人：</td>
						    <td class="inquire_form6"><input type="text" id="rectification_head" name="rectification_head" class="input_width"    /></td>	 
						    <td class="inquire_item6">验收人：</td> 					   
						    <td class="inquire_form6"  align="center" > 
					            <input type="text" id="rectification_people" name="rectification_people" class="input_width"    /></td>	
							  </tr>	 
							  
							   <tr>								    	 
							   					
							    <td class="inquire_item6"><font color="red">*</font>整改完成时间：</td>
							    <td class="inquire_form6"><input type="text" id="rectification_date" name="rectification_date" class="input_width"    readonly="readonly"/>
							    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: pointer;" onmouseover="calDateSelector(rectification_date,tributton1);" />&nbsp;</td>
							  </tr>	 
							  
							  
					   </table>
					   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
						  <tr>
						    <td class="inquire_item6"><font color="red"></font>未整改原因：</td> 					   
						    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:758px; height:60px;" id="rectification_reason" name="rectification_reason"   class="textarea" ></textarea></td>
						    <td class="inquire_item6"> </td> 				 
						  </tr>		
						  <tr>  
						    <td class="inquire_item6"><font color="red"></font>整改计划：</td> 					   
						    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:758px; height:60px;" id="action_plan" name="action_plan"   class="textarea" ></textarea></td>
						    <td class="inquire_item6"> </td> 				 
						  </tr>	
						</table>	
				</fieldset><br>
		</div>
		 <div id="type1" style="display:none">
				<fieldset>
				<legend>
					奖励信息
				</legend>
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					    <tr>  
						  <td class="inquire_item6"><font color="red">*</font>奖励级别：</td>
						    <td class="inquire_form6">
						    <select id="reward_level" name="reward_level" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >公司</option>
						       <option value="2" >二级单位</option> 
						       <option value="3" >基层单位</option>  
						       <option value="4" >基层单位下属单位</option>  
							</select> 
						    </td>	 	 
						    <td class="inquire_item6"><font color="red">*</font>奖励金额(元)：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <input type="text" id="reward_amount" name="reward_amount" class="input_width"    />
						    </td>   
						    <td class="inquire_item6"><font color="red">*</font>兑现日期：</td>
						    <td class="inquire_form6">
						    <input type="text" id="cash_date" name="cash_date" class="input_width"  onchange="getNull(this.value)"  readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(cash_date,tributton2);" />&nbsp;</td>
						    </tr>	
							  <tr>								   	 
							    <td class="inquire_item6"><font color="red">*</font>奖励状态：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="reward_state" name="reward_state" class="input_width" value="未奖励"   readonly="readonly" />
							    </td>
							  </tr>	 
					   </table>
				</fieldset>
	     </div> 
</div>				 
		<div id="oper_div2" style="display:block;text-align:center; " >
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
		<span class="gb_btn"><a href="#" onclick="window.close()"></a></span>
		</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript"> 
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form'; 
var hiddenNo="<%=hiddenNo%>";
var paramS="<%=paramS%>";
document.getElementsByName("evaluation_date")[0].value='<%=curDate%>';	
var tempIds = paramS.split(",");
var id = "";
for(var i=0;i<tempIds.length;i++){
	id =tempIds[i];
	if(id=="1"){
	  document.getElementById("type3").style.display="block";
	}
	if(id=="2"){
		  document.getElementById("type2").style.display="block";
		}
	if(id=="3"){
		  document.getElementById("type1").style.display="block";
		}
}
 
function calMonthSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    false,
		singleClick    :    false,
		step	       :	1
    });
}
function getNull(valueS){ 		
	 
	if(valueS != null && valueS != ''  ){			
		  document.getElementsByName('reward_state')[0].value="已奖励";
	}

}

function getRiskLevels(){
	var selectObj = document.getElementById("risk_levels"); 
	document.getElementById("risk_levels").innerHTML="";
	selectObj.add(new Option('请选择',""),0);

	var queryHazardBig=jcdpCallService("HseOperationSrv","queryRiskLevels","");	
 
	for(var i=0;i<queryHazardBig.detailInfo.length;i++){
		var templateMap = queryHazardBig.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	 
}

function getControlEffect(){
	var selectObj = document.getElementById("control_effect"); 
	document.getElementById("control_effect").innerHTML="";
	selectObj.add(new Option('请选择',""),0);

	var queryHazardBig=jcdpCallService("HseOperationSrv","queryRiskLevels","");	
 
	for(var i=0;i<queryHazardBig.detailInfo.length;i++){
		var templateMap = queryHazardBig.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	 
}


function submitButton(){ 
		var mdetail_no = document.getElementsByName("mdetail_no")[0].value;
		var evaluation_date = document.getElementsByName("evaluation_date")[0].value;						 
	    var evaluation_level=document.getElementsByName("evaluation_level")[0].value;
		var evaluation_personnel=document.getElementsByName("evaluation_personnel")[0].value;		
		var main_methods=document.getElementsByName("main_methods")[0].value;				    			
	    var risk_levels=document.getElementsByName("risk_levels")[0].value;		
	    var harmful_consequences=document.getElementsByName("harmful_consequences")[0].value;		
	    
		var evaluation_state=document.getElementsByName("evaluation_state")[0].value;	    		 
		 var rectification_state=document.getElementsByName("rectification_state")[0].value;	 
		 var rectification_measures=document.getElementsByName("rectification_measures")[0].value;	    		    
		 var rectification_measures_type=document.getElementsByName("rectification_measures_type")[0].value;	
		 var rectification_date=document.getElementsByName("rectification_date")[0].value;
		 var control_effect=document.getElementsByName("control_effect")[0].value;		
		 
		 var rectification_head=document.getElementsByName("rectification_head")[0].value;			 			    			
		 var rectification_people=document.getElementsByName("rectification_people")[0].value;	
		 
		 var rectification_reason=document.getElementsByName("rectification_reason")[0].value;				    			
		 var action_plan=document.getElementsByName("action_plan")[0].value;					 
		 if(rectification_state =="2"){
			 if(rectification_reason ==""){
				 alert("整改状态选择未整改时,未整改原因必填!");
				 return;
			 }
			 if(action_plan ==""){
				 alert("整改状态选择未整改时,整改计划必填!");
				 return;
			 }
		 }
			var reward_level= document.getElementsByName("reward_level")[0].value;
			var reward_amount= document.getElementsByName("reward_amount")[0].value;		    
			var cash_date= document.getElementsByName("cash_date")[0].value;	
			var reward_state= document.getElementsByName("reward_state")[0].value;
	       if(reward_level==""){ 
	    	   reward_state="";
	       }
	var hiddenNos = hiddenNo.split(",");
	var id = "";
	var lengthH=hiddenNos.length-1
	for(var i=0;i<lengthH;i++){
		id =hiddenNos[i];		 
		if(id!=""){
			    var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_HIDDEN_INFORMATION&JCDP_TABLE_ID='+id +'&subflag=1';
			    syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
				var rowParams = new Array(); 
				var rowParam = {};		
    	     	rowParam['mdetail_no'] =  mdetail_no;	    			
    	     	rowParam['hidden_no'] =  id;
				rowParam['evaluation_date'] =  '<%=curDate%>';
				rowParam['evaluation_level'] = encodeURI(encodeURI(evaluation_level));
				rowParam['evaluation_personnel'] = encodeURI(encodeURI(evaluation_personnel));
				rowParam['main_methods'] = encodeURI(encodeURI(main_methods));
				rowParam['risk_levels'] = encodeURI(encodeURI(risk_levels));
				rowParam['harmful_consequences'] = encodeURI(encodeURI(harmful_consequences));
				
				
				rowParam['evaluation_state'] = encodeURI(encodeURI("已评价"));					

				rowParam['rectification_state'] =  rectification_state;
				rowParam['rectification_measures'] = encodeURI(encodeURI(rectification_measures));
				rowParam['rectification_measures_type'] = encodeURI(encodeURI(rectification_measures_type));
				rowParam['rectification_date'] = encodeURI(encodeURI(rectification_date));
				rowParam['control_effect'] = encodeURI(encodeURI(control_effect));
				
				rowParam['rectification_head'] = encodeURI(encodeURI(rectification_head));
				rowParam['rectification_people'] = encodeURI(encodeURI(rectification_people));
				
				rowParam['rectification_reason'] = encodeURI(encodeURI(rectification_reason));
				rowParam['action_plan'] = encodeURI(encodeURI(action_plan));
								
				rowParam['reward_level'] = encodeURI(encodeURI(reward_level));
				rowParam['reward_amount'] =reward_amount;
				rowParam['cash_date'] = encodeURI(encodeURI(cash_date));
				rowParam['reward_state'] = encodeURI(encodeURI(reward_state));
 		 
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';		
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';	
				rowParam['bsflag'] = '0';
			 			
			rowParams[rowParams.length] = rowParam; 
			var rows=JSON.stringify(rowParams);	 		 
			var path = getContextPath()+"/rad/addOrUpdateEntities.srq";
			submitStr = "tableName=BGP_HIDDEN_INFORMATION_DETAIL&"+"rowParams="+rows;
			if(submitStr == null) return;
	    	syncRequest('Post',path,submitStr);
		}
			
	  }
	alert('保存成功！');
	window.top.opener.refreshData();
	  window.close();
}
 

</script>
</html>
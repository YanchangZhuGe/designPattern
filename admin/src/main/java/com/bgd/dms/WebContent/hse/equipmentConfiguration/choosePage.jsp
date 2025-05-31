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
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
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
<body onload="queryOrg();queryOrgs()">
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box" style="width:956px; height:565px;">
  <div id="new_table_box_content" style="width:956px; height:565px;">
    <div id="new_table_box_bg"   style="width:937px; height:490px; ">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >			
				    <tr >   <td >  </td>    <td > 	  </td>	  </tr>		  
		 
				 	  <tr > 
					    <td   align="center"> <font color=black size="4px">计划外</font> 
					    <input type="radio" name="radioType" value="1" id="radioType1" onclick="radioValue()"/>
					    </td>
			 		    <td   align="center"><font color=black size="4px"> 计划内</font> 
					    <input type="radio" name="radioType" value="2" id="radioType2" onclick="radioValue()"/>  		
					    </td>
					  </tr>		  
					</table>
					 <br>
					 <div id="type1" style="display:none;">
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
					    	  <td class="inquire_item6">下属单位：</td>
						      	<td class="inquire_form6">
					 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
						      	<input type="hidden" id="create_date" name="create_date" value="" />
						      	<input type="hidden" id="creator" name="creator" value="" />
						       	<input type="hidden" id="spare1" name="spare1" value="1" />
						      	<input type="hidden" id="unplanned_no" name="unplanned_no"   />
						    	<input type="hidden" id="project_no" name="project_no" value="" />
						      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
						      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
						      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
						      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
						      	<%}%>
						      	</td> 
						  </tr>	
						 
							<tr>								 
							   <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
							    <td class="inquire_form6"><input type="text" id="facilities_name2" name="facilities_name2" class="input_width"     />
							    </td>
					 		    <td class="inquire_item6"><font color="red">*</font>数量：</td>
							    <td class="inquire_form6"> 
							    <input type="text" id="quantity2" name="quantity2" class="input_width"    onblur="calculateCost()" />    		
							    </td>					   	      	
							    <td class="inquire_item6"><font color="red">*</font>计量单位：</td>
							    <td class="inquire_form6">
							    <input type="text" id="measurement_unit2" name="measurement_unit2" class="input_width"   />    					    
							    </td>					    
							</tr>			 
						  <tr>	
							  <td class="inquire_item6"><font color="red">*</font>型号：</td>
							    <td class="inquire_form6"><input type="text" id="model_num2" name="model_num2" class="input_width"    />
							    </td>
					 		    <td class="inquire_item6"><font color="red">*</font>编号：</td>
							    <td class="inquire_form6"> 
							    <input type="text" id="numbers2" name="numbers2" class="input_width"   />    		
							    </td>					   	      	
							    <td class="inquire_item6"><font color="red">*</font>单价（元） ：</td>
							    <td class="inquire_form6">
							    <input type="text" id="price2" name="price2" class="input_width"  onblur="calculateCost()"   />    					    
							    </td>			
						  </tr>		
						  <tr>	
						   <td class="inquire_item6"><font color="red">*</font>合计（元） ：</td>
						    <td class="inquire_form6"><input type="text" id="aggregate_sum2" name="aggregate_sum2" class="input_width"  readonly="readonly"  />
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>购置负责人：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="acquisition2" name="acquisition2" class="input_width"   />    		
						    </td>					   	      	
						    <td class="inquire_item6"><font color="red">*</font>购置时间 ：</td>
						    <td class="inquire_form6">
						    <input type="text" id="acquisition_time2" name="acquisition_time2" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time2,tributton1);" />&nbsp;</td>		
					     </tr>		
						  <tr>	
						  <td class="inquire_item6"><font color="red">*</font>设备状态：</td>
						    <td class="inquire_form6">
						    <select id="equipment_state2" name="equipment_state2" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >在用</option>
						       <option value="2" >停用</option>		
						       <option value="3" >备用</option>
							</select>
						    </td>
						    <td class="inquire_item6"><font color="red">*</font>投入使用日期 ：</td>
						    <td class="inquire_form6">
						    <input type="text" id="put_use_date2" name="put_use_date2" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(put_use_date2,tributton2);" />&nbsp;</td>				   	      	
						    <td class="inquire_item6"><font color="red">*</font>有效时间截止到：</td>
						    <td class="inquire_form6">
						    <input type="text" id="valid_time2" name="valid_time2" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_time2,tributton3);" />&nbsp;</td>		
					     </tr>
					     <tr>	
					        <td class="inquire_item6"><font color="red">*</font>校验日期：</td>
						    <td class="inquire_form6">
						    <input type="text" id="check_date2" name="check_date2" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date2,tributton4);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>使用部门、班组或地点：</td>
						    <td class="inquire_form6"><input type="text" id="use_department2" name="use_department2" class="input_width"    />
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>使用负责人：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="the_use2" name="the_use2" class="input_width"   />    		
						    </td>				   	      	
						  </tr>		
						</table> <br>
						 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>备注：</td> 					   
						    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;" id="remark2" name="remark2"   class="textarea" ></textarea></td>
						    <td class="inquire_item6"> </td> 				 
						  </tr>						  
						</table>
				 <br>
				 <br>
				 <br>
			
			 </div>

			 
			 <div id="type2" style="display:none">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>						   
						  <td class="inquire_item6">单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="1org_sub_id" name="1org_sub_id" class="input_width" />
					      	<input type="text" id="1org_sub_id2" name="1org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdits(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
				        	<%} %>
				        	</td>				  
						  <td class="inquire_item6">基层单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="1second_org" name="1second_org" class="input_width" />
				    	  <input type="text" id="1second_org2" name="1second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdits(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2s()"/>
				        	<%} %>
				        	</td>		    	  
					  </tr>					  
						<tr>								 
						  <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
				 	      	<input type="hidden" id="1bsflag" name="1bsflag" value="0" />
					      	<input type="hidden" id="1create_date" name="1create_date" value="" />
					      	<input type="hidden" id="1creator" name="1creator" value="" />
					      	<input type="hidden" id="1equipment_no" name="1equipment_no"   />
					    	<input type="hidden" id="1spare1" name="1spare1" value="2" />
					    	<input type="hidden" id="1project_no" name="1project_no" value="" />
					      	<input type="hidden" id="1third_org" name="1third_org" class="input_width" />
					      	<input type="text" id="1third_org2" name="1third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdits(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3s()"/>
					      	<%}%>
					      	</td> 
					    <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
					    <td class="inquire_form6">
					    <input type="text" id="1facilities_name" name="1facilities_name" class="input_width"   />    					    
					    </td>					    
						</tr>		
						
						  <tr>	
						    <td class="inquire_item6"><font color="red">*</font>数量：</td>
						    <td class="inquire_form6"><input type="text" id="1quantity" name="1quantity" class="input_width"  onblur="calculateCost1()"   />
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>计量单位：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="1measurement_unit" name="1measurement_unit" class="input_width"   />    		
						    </td>
						  </tr>		
						  <tr>	
						    <td class="inquire_item6"><font color="red">*</font>单价（元）：</td>
						    <td class="inquire_form6"><input type="text" id="1price" name="1price" class="input_width"   onblur="calculateCost1()"/>
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>合计（元）：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="1aggregate_sum" name="1aggregate_sum" class="input_width"  readonly="readonly"  />    		
						    </td>
						  </tr>		
						
					  <tr>	
					  <td class="inquire_item6"><font color="red">*</font>购置负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="1acquisition" name="1acquisition" class="input_width"   />    		
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>计划购置时间：</td>
					    <td class="inquire_form6"><input type="text" id="splan_acquisition_time" name="splan_acquisition_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(splan_acquisition_time,tributton6);" />&nbsp;</td>
			 		    
					  </tr>					  
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>计划编制日期：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="splan_date" name="splan_date" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton7" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(splan_date,tributton7);" />&nbsp;</td>
					  </tr>	
					</table>
				 <br>
				 <br>
				 <br>		
		</div>

</div>		
		<div id="oper_div" style="display:none;">
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
		<div id="oper_div1" style="display:none;text-align:center; " >
		<span class="tj_btn"><a href="#" onclick="submitButton1()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

function radioValue(){  
	 l=document.getElementsByName("radioType")  
	 for(i=0;i<l.length;i++)  
	 {  
		 if(l[i].checked)  
		 {
		 	 if(l[i].value =='1'){
		 		 document.getElementById("type1").style.display="block";
		 		 document.getElementById("oper_div").style.display="block";
		 		 document.getElementById("type2").style.display="none";
		 		 document.getElementById("oper_div1").style.display="none";
		 	 }
			 if(l[i].value =='2'){
				 document.getElementById("type2").style.display="block";
		 		 document.getElementById("oper_div1").style.display="block";
		 		 document.getElementById("type1").style.display="none";
		 		 document.getElementById("oper_div").style.display="none";
			 }
			 			 
		 }
 
	 }  
	 
} 

function calculateCost(){
	var trainTotal=0;

	var quantity2 = document.getElementById("quantity2").value;
	var price2 = document.getElementById("price2").value;
  
	if(checkNaN("quantity2") &&  checkNaN("price2")){
		trainTotal = parseFloat(quantity2)*parseFloat(price2);
 
	 	}
	
	document.getElementById("aggregate_sum2").value=substrin(trainTotal);
}

 
function calculateCost1(){
	var trainTotal=0; 
	var quantity = document.getElementById("1quantity").value;
	var price = document.getElementById("1price").value;
  
	if(checkNaN("1price")  && checkNaN("1quantity")){
		trainTotal = parseFloat(quantity)*parseFloat(price);	 
	 	}		
	document.getElementById("1aggregate_sum").value=substrin(trainTotal);
}

 
function substrin(str)
{ 
	str = Math.round(str * 10000) / 10000;
	return(str); 
 }

function checkNaN(numids){

	 var str = document.getElementById(numids).value;
 
	 if(str!=""){		 
		if(isNaN(str)){
			alert("请输入数字");
			document.getElementById(numids).value="";
			return false;
		}else{
			return true;
		}
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
function queryOrgs(){
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.flag=="true"){
			var len = retObj.list.length;
			if(len>0){
				document.getElementById("1org_sub_id").value=retObj.list[0].orgSubId;
				document.getElementById("1org_sub_id2").value=retObj.list[0].orgAbbreviation;
			}
			if(len>1){
				document.getElementById("1second_org").value=retObj.list[1].orgSubId;
				document.getElementById("1second_org2").value=retObj.list[1].orgAbbreviation;
			}
			if(len>2){
				document.getElementById("1third_org").value=retObj.list[2].orgSubId;
				document.getElementById("1third_org2").value=retObj.list[2].orgAbbreviation;
			}
		}
	}

function checkJudge(){
		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
	var second_org = document.getElementsByName("second_org2")[0].value;			
	var third_org = document.getElementsByName("third_org2")[0].value;			
	
	var facilities_name2 = document.getElementsByName("facilities_name2")[0].value;
	var quantity2 = document.getElementsByName("quantity2")[0].value;		
	var measurement_unit2 = document.getElementsByName("measurement_unit2")[0].value;			
	var model_num2 = document.getElementsByName("model_num2")[0].value;		
	var numbers2 = document.getElementsByName("numbers2")[0].value;		
	var price2 = document.getElementsByName("price2")[0].value;			
	var aggregate_sum2 = document.getElementsByName("aggregate_sum2")[0].value;
	var acquisition2 = document.getElementsByName("acquisition2")[0].value;		
	var acquisition_time2 = document.getElementsByName("acquisition_time2")[0].value;			
	var equipment_state2 = document.getElementsByName("equipment_state2")[0].value;		
	var put_use_date2 = document.getElementsByName("put_use_date2")[0].value;		
	var valid_time2 = document.getElementsByName("valid_time2")[0].value;	
		var check_date2 = document.getElementsByName("check_date2")[0].value;			
	var use_department2 = document.getElementsByName("use_department2")[0].value;			
	var the_use2 = document.getElementsByName("the_use2")[0].value;			
	var remark2 = document.getElementsByName("remark2")[0].value;	
	
	
		if(org_sub_id==""){
			document.getElementById("org_sub_id").value = "";
		}
		if(second_org==""){
			document.getElementById("second_org").value="";
		}
		if(third_org==""){
			document.getElementById("third_org").value="";
		}
		if(facilities_name2==""){
			alert("设备设施名称不能为空，请填写！");
			return true;
		}
		if(quantity2==""){
			alert("数量不能为空，请选择！");
			return true;
		}
		if(measurement_unit2==""){
			alert("计量单位不能为空，请填写！");
			return true;
		}

	if(model_num2==""){
			alert("型号不能为空，请填写！");
			return true;
		}
	if(numbers2==""){
			alert("编号不能为空，请填写！");
			return true;
		}
	if(price2==""){
			alert("单价（元）不能为空，请填写！");
			return true;
		}
	if(aggregate_sum2==""){
			alert("合计（元）不能为空，请填写！");
			return true;
		}
	
		
	if(acquisition2==""){
			alert("购置负责人不能为空，请填写！");
			return true;
		}
	if(acquisition_time2==""){
			alert("购置时间不能为空，请填写！");
			return true;
		}
	if(equipment_state2==""){
			alert("设备状态不能为空，请填写！");
			return true;
		}
	if(put_use_date2==""){
			alert("投入使用日期不能为空，请填写！");
			return true;
		}
	if(valid_time2==""){
			alert("有效时间截止到不能为空，请填写！");
			return true;
		}
	if(check_date2==""){
			alert("校验日期不能为空，请填写！");
			return true;
		}
	if(use_department2==""){
			alert("使用部门、班组或地点不能为空，请填写！");
			return true;
		}
	if(the_use2==""){
			alert("使用负责人不能为空，请填写！");
			return true;
		}
	if(remark2==""){
			alert("备注不能为空，请填写！");
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
 		var unplanned_no = document.getElementsByName("unplanned_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;			
		var spare1 = document.getElementsByName("spare1")[0].value;		
		
		var facilities_name2 = document.getElementsByName("facilities_name2")[0].value;
		var quantity2 = document.getElementsByName("quantity2")[0].value;		
		var measurement_unit2 = document.getElementsByName("measurement_unit2")[0].value;			
		var model_num2 = document.getElementsByName("model_num2")[0].value;		
		var numbers2 = document.getElementsByName("numbers2")[0].value;		
		var price2 = document.getElementsByName("price2")[0].value;			
		var aggregate_sum2 = document.getElementsByName("aggregate_sum2")[0].value;
		var acquisition2 = document.getElementsByName("acquisition2")[0].value;		
		var acquisition_time2 = document.getElementsByName("acquisition_time2")[0].value;			
		var equipment_state2 = document.getElementsByName("equipment_state2")[0].value;		
		var put_use_date2 = document.getElementsByName("put_use_date2")[0].value;		
		var valid_time2 = document.getElementsByName("valid_time2")[0].value;	
 		var check_date2 = document.getElementsByName("check_date2")[0].value;			
		var use_department2 = document.getElementsByName("use_department2")[0].value;			
		var the_use2 = document.getElementsByName("the_use2")[0].value;			
		var remark2 = document.getElementsByName("remark2")[0].value;			
		var project_no = document.getElementsByName("project_no")[0].value;		
		
		var isProject = "<%=isProject%>";
		
 		if(equipment_state2 =="1"){
			if(put_use_date2 =="") {alert("设备状态为在用状态,投入使用日期必填");	return;}
			if(use_department2 =="") {alert("设备状态为在用状态,使用部门、班组或地点必填");	return;}
			if(the_use2 =="") {alert("设备状态为在用状态,使用负责人必填");	return;}
		}
 		if(valid_time2 ==""  && check_date2==""){alert("有效时间截止日期 或 校验日期 必须填一个！");return;	}
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			 		
		rowParam['facilities_name2'] = encodeURI(encodeURI(facilities_name2));
		rowParam['quantity2'] = quantity2;
		rowParam['measurement_unit2'] = encodeURI(encodeURI(measurement_unit2));
		rowParam['model_num2'] = encodeURI(encodeURI(model_num2));		 		
		rowParam['numbers2'] = encodeURI(encodeURI(numbers2));
		rowParam['price2'] = price2;
		rowParam['aggregate_sum2'] = aggregate_sum2;
		rowParam['acquisition2'] = encodeURI(encodeURI(acquisition2));
		rowParam['acquisition_time2'] = encodeURI(encodeURI(acquisition_time2));
		rowParam['equipment_state2'] = encodeURI(encodeURI(equipment_state2));		 		
		rowParam['put_use_date2'] = encodeURI(encodeURI(put_use_date2));
		rowParam['valid_time2'] = encodeURI(encodeURI(valid_time2));		
		rowParam['check_date2'] = encodeURI(encodeURI(check_date2));
		rowParam['use_department2'] = encodeURI(encodeURI(use_department2));
		rowParam['the_use2'] = encodeURI(encodeURI(the_use2));
		rowParam['remark2'] = encodeURI(encodeURI(remark2)); 
	    rowParam['creator2'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['updator2'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['create_date2'] ='<%=curDate%>';
		rowParam['modifi_date2'] = '<%=curDate%>';		
		rowParam['bsflag2'] = bsflag;
		rowParam['spare1'] = spare1;
		if(isProject=="2"){
			rowParam['project_no'] ='<%=projectInfoNo%>';
		}
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_EQUIPMENT_UNPLANNED",rows);	
		top.frames('list').refreshData();	
		newClose();
 
}
 

//键盘上只有删除键，和左右键好用
 function noEdit(event){
 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
 		return true;
 	}else{
 		return false;
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
 
function checkJudge1(){
	 var org_sub_id = document.getElementsByName("1org_sub_id2")[0].value;
	var second_org = document.getElementsByName("1second_org2")[0].value;			
	var third_org = document.getElementsByName("1third_org2")[0].value;			
	
	var facilities_name2 = document.getElementsByName("1facilities_name")[0].value;
	var quantity2 = document.getElementsByName("1quantity")[0].value;		
	var measurement_unit2 = document.getElementsByName("1measurement_unit")[0].value;			
	var price2 = document.getElementsByName("1price")[0].value;		
	var aggregate_sum2 = document.getElementsByName("1aggregate_sum")[0].value;		
	var acquisition2 = document.getElementsByName("1acquisition")[0].value;	
		var plan_acquisition_time = document.getElementsByName("splan_acquisition_time")[0].value;		
	var splan_date = document.getElementsByName("splan_date")[0].value;		
	 
		if(org_sub_id==""){
			document.getElementById("1org_sub_id").value = "";
		}
		if(second_org==""){
			document.getElementById("1second_org").value="";
		}
		if(third_org==""){
			document.getElementById("1third_org").value="";
		}
		if(facilities_name2==""){
			alert("设备设施名称不能为空，请填写！");
			return true;
		}
		if(quantity2==""){
			alert("数量不能为空，请选择！");
			return true;
		}
		if(measurement_unit2==""){
			alert("计量单位不能为空，请填写！");
			return true;
		}

	 
	if(price2==""){
			alert("单价（元）不能为空，请填写！");
			return true;
		}
	if(aggregate_sum2==""){
			alert("合计（元）不能为空，请填写！");
			return true;
		}
	 
	if(acquisition2==""){
			alert("购置负责人不能为空，请填写！");
			return true;
		}
	if(plan_acquisition_time==""){
			alert("计划购置时间不能为空，请填写！");
			return true;
		}
	if(splan_date==""){
			alert("计划编制日期不能为空，请填写！");
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
	 
		var equipment_no = document.getElementsByName("1equipment_no")[0].value;
		var create_date = document.getElementsByName("1create_date")[0].value;
		var creator = document.getElementsByName("1creator")[0].value;		
		var org_sub_id = document.getElementsByName("1org_sub_id")[0].value;
		var bsflag = document.getElementsByName("1bsflag")[0].value;
		var second_org = document.getElementsByName("1second_org")[0].value;			
		var third_org = document.getElementsByName("1third_org")[0].value;			
		var spare1 = document.getElementsByName("1spare1")[0].value;	
		
		var facilities_name = document.getElementsByName("1facilities_name")[0].value;
		var quantity = document.getElementsByName("1quantity")[0].value;		
		var measurement_unit = document.getElementsByName("1measurement_unit")[0].value;			
		var price = document.getElementsByName("1price")[0].value;		
		var aggregate_sum = document.getElementsByName("1aggregate_sum")[0].value;		
		var acquisition = document.getElementsByName("1acquisition")[0].value;	
 		var plan_acquisition_time = document.getElementsByName("splan_acquisition_time")[0].value;		
		var plan_date = document.getElementsByName("splan_date")[0].value;		
		var project_no = document.getElementsByName("1project_no")[0].value;	
		
		var isProject = "<%=isProject%>";
		
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			
		
		rowParam['facilities_name'] = encodeURI(encodeURI(facilities_name));
		rowParam['quantity'] = encodeURI(encodeURI(quantity));
		rowParam['measurement_unit'] = encodeURI(encodeURI(measurement_unit));
		rowParam['price'] = encodeURI(encodeURI(price));		 		
		rowParam['aggregate_sum'] = encodeURI(encodeURI(aggregate_sum));
		rowParam['acquisition'] = encodeURI(encodeURI(acquisition));
		rowParam['plan_acquisition_time'] = encodeURI(encodeURI(plan_acquisition_time));		 		
		rowParam['plan_date'] = encodeURI(encodeURI(plan_date));
		if(isProject=="2"){
			rowParam['project_no'] ='<%=projectInfoNo%>';
		}
	    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['create_date'] ='<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';		
		rowParam['bsflag'] = bsflag;
		rowParam['spare1'] = spare1;
					
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_EQUIPMENT_CONFIGURATION",rows);	
		top.frames('list').refreshData();	
		newClose();
 
}
 
//键盘上只有删除键，和左右键好用
function noEdits(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

function selectOrgs(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("1org_sub_id").value = teamInfo.fkValue;
	        document.getElementById("1org_sub_id2").value = teamInfo.value;
	    }
	}

	function selectOrg2s(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("1org_sub_id").value;
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
			    	 document.getElementById("1second_org").value = teamInfo.fkValue; 
			        document.getElementById("1second_org2").value = teamInfo.value;
				}
	   
	}

	function selectOrg3s(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("1second_org").value;
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
			    	 document.getElementById("1third_org").value = teamInfo.fkValue;
			        document.getElementById("1third_org2").value = teamInfo.value;
				}
	}

function checkText0s(){
	var second_org=document.getElementById("1second_org").value;
	 
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
 
</script>
</html>
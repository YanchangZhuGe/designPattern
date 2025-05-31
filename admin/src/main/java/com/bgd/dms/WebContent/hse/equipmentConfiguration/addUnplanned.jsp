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
	
	String unplanned_no="";
	if(request.getParameter("unplanned_no") != null){
		unplanned_no=request.getParameter("unplanned_no");	
		
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
<title>计划外(实施情况)</title>
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
<body>
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box" style="width:956px; height:565px;">
<div id="new_table_box_content" style="width:956px; height:565px;">
  <div id="new_table_box_bg"   style="width:937px; height:490px; ">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				    <br>
 
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
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="unplanned_no" name="unplanned_no"   />
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
						    <input type="text" id="quantity2" name="quantity2" class="input_width"   onblur="calculateCost()"  />    		
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
						    <input type="text" id="price2" name="price2" class="input_width"  onblur="calculateCost()"  />    					    
						    </td>			
					  </tr>		
					  <tr>	
					   <td class="inquire_item6"><font color="red">*</font>合计（元） ：</td>
					    <td class="inquire_form6"><input type="text" id="aggregate_sum2" name="aggregate_sum2" class="input_width"  readonly="readonly"   />
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
					    <td class="inquire_form6"><input type="text" id="use_department2" name="use_department2" class="input_width"   />
					    </td>
			 		    <td class="inquire_item6"><font color="red">*</font>使用负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="the_use2" name="the_use2" class="input_width"   />    		
					    </td>				   	      	
					  </tr>		
					</table>
				    <br>
				    <br>
		 
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>备注：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;" id="remark2" name="remark2"   class="textarea" ></textarea></td>
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
 var unplanned_no='<%=unplanned_no%>'; 
 var projectInfoNo='<%=projectInfoNo%>';
 
 function calculateCost(){
 	var trainTotal=0;

 	var quantity2 = document.getElementById("quantity2").value;
 	var price2 = document.getElementById("price2").value;
   
 	if(checkNaN("quantity2") &&  checkNaN("price2")){
 		trainTotal = parseFloat(quantity2)*parseFloat(price2);
  
 	 	}
 	
 	document.getElementById("aggregate_sum2").value=substrin(trainTotal);
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
		var project_no = document.getElementsByName("project_no")[0].value;		
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
		
	  if(unplanned_no !=null && unplanned_no !=''){
		rowParam['unplanned_no'] = unplanned_no;
		rowParam['creator2'] = encodeURI(encodeURI(creator));
		rowParam['create_date2'] =create_date;
		rowParam['updator2'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['modifi_date2'] = '<%=curDate%>';		
		rowParam['bsflag2'] = bsflag;
		rowParam['spare1'] = spare1;
	  }else{
	    rowParam['creator2'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['updator2'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['create_date2'] ='<%=curDate%>';
		rowParam['modifi_date2'] = '<%=curDate%>';		
		rowParam['bsflag2'] = bsflag;
		rowParam['spare1'] = spare1;
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
 
	if(unplanned_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "  select  tr.project_no,tr.unplanned_no, tr.facilities_name2,tr.quantity2,tr.measurement_unit2,tr.model_num2,tr.numbers2,tr.price2,tr.aggregate_sum2,tr.acquisition2,tr.acquisition_time2,tr.equipment_state2,tr.put_use_date2,tr.valid_time2,check_date2,use_department2,tr.the_use2,tr.remark2 ,tr.second_org,tr.third_org,oi3.org_abbreviation org_name,tr.creator2,tr.create_date2,tr.bsflag2,tr.org_sub_id, tr.spare1, oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_EQUIPMENT_UNPLANNED tr      left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id=tr.org_sub_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id = os3.org_id     where tr.bsflag2 = '0' and tr.unplanned_no='"+unplanned_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){			
	  
	             document.getElementsByName("unplanned_no")[0].value=datas[0].unplanned_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag2;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date2;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator2;		  
	    		 document.getElementsByName("spare1")[0].value=datas[0].spare1;			    			
	    		    document.getElementsByName("facilities_name2")[0].value=datas[0].facilities_name2;
	    		    document.getElementsByName("quantity2")[0].value=datas[0].quantity2;		
	    			document.getElementsByName("measurement_unit2")[0].value=datas[0].measurement_unit2;			
	    		    document.getElementsByName("model_num2")[0].value=datas[0].model_num2;		
	    			document.getElementsByName("numbers2")[0].value=datas[0].numbers2;		
	    			document.getElementsByName("price2")[0].value=datas[0].price2;			
	    		    document.getElementsByName("aggregate_sum2")[0].value=datas[0].aggregate_sum2;
	    			document.getElementsByName("acquisition2")[0].value=datas[0].acquisition2;		
	    			document.getElementsByName("acquisition_time2")[0].value=datas[0].acquisition_time2;			
	    			document.getElementsByName("equipment_state2")[0].value=datas[0].equipment_state2;		
	    			document.getElementsByName("put_use_date2")[0].value=datas[0].put_use_date2;		
	    			document.getElementsByName("valid_time2")[0].value=datas[0].valid_time2;	
	    	 		document.getElementsByName("check_date2")[0].value=datas[0].check_date2;			
	    			document.getElementsByName("use_department2")[0].value=datas[0].use_department2;			
	    			document.getElementsByName("the_use2")[0].value=datas[0].the_use2;			
	    			document.getElementsByName("remark2")[0].value=datas[0].remark2;			
		    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;	
			}					
		
	    	}		
		
	}

</script>
</html>
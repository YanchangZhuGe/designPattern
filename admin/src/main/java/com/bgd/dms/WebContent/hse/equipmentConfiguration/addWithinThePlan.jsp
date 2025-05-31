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
	
	String equipment_no="";
	if(request.getParameter("equipment_no") != null){
		equipment_no=request.getParameter("equipment_no");	
		
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
<title>计划内</title>
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
					      	<input type="hidden" id="equipment_no" name="equipment_no"   />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					    	<input type="hidden" id="spare1" name="spare1" value="2" />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
					     
					    <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
					    <td class="inquire_form6">
					    <input type="text" id="facilities_name" name="facilities_name" class="input_width"   />    					    
					    </td>					    
						</tr>		
						
						  <tr>	
						    <td class="inquire_item6"><font color="red">*</font>数量：</td>
						    <td class="inquire_form6"><input type="text" id="quantity" name="quantity" class="input_width"   onblur="calculateCost1()"   />
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>计量单位：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="measurement_unit" name="measurement_unit" class="input_width"   />    		
						    </td>
						  </tr>		
						  <tr>	
						    <td class="inquire_item6"><font color="red">*</font>单价（元）：</td>
						    <td class="inquire_form6"><input type="text" id="price" name="price" class="input_width"  onblur="calculateCost1()"  />
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>合计（元）：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="aggregate_sum" name="aggregate_sum" class="input_width"  readonly="readonly" />    		
						    </td>
						  </tr>		
						
						
					  <tr>	
					  <td class="inquire_item6"><font color="red">*</font>购置负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="acquisition" name="acquisition" class="input_width"   />    		
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>计划购置时间：</td>
					    <td class="inquire_form6"><input type="text" id="plan_acquisition_time" name="plan_acquisition_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_acquisition_time,tributton1);" />&nbsp;</td>
			 		    
					  </tr>					  
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>计划编制日期：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="plan_date" name="plan_date" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_date,tributton2);" />&nbsp;</td>
					  </tr>	
					</table>
					  
				</div>
			<div id="oper_div">
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
 var equipment_no='<%=equipment_no%>';
 var projectInfoNo='<%=projectInfoNo%>';
 
	function calculateCost1(){
		var trainTotal=0; 
		var quantity = document.getElementById("quantity").value;
		var price = document.getElementById("price").value;
	  
		if(checkNaN("price")  && checkNaN("quantity")){
			trainTotal = parseFloat(quantity)*parseFloat(price);	 
		 	}		
		document.getElementById("aggregate_sum").value=substrin(trainTotal);
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
	
	function checkJudge1(){
 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
		var second_org = document.getElementsByName("second_org2")[0].value;			
		var third_org = document.getElementsByName("third_org2")[0].value;			
		
		var facilities_name2 = document.getElementsByName("facilities_name")[0].value;
		var quantity2 = document.getElementsByName("quantity")[0].value;		
		var measurement_unit2 = document.getElementsByName("measurement_unit")[0].value;			
		var price2 = document.getElementsByName("price")[0].value;		
		var aggregate_sum2 = document.getElementsByName("aggregate_sum")[0].value;		
		var acquisition2 = document.getElementsByName("acquisition")[0].value;	
 		var plan_acquisition_time = document.getElementsByName("plan_acquisition_time")[0].value;		
		var splan_date = document.getElementsByName("plan_date")[0].value;		
		 
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
 			
	
	
function submitButton(){ 	 
	if(checkJudge1()){
		return;
	} 
	var rowParams = new Array(); 
		var rowParam = {};				 
		var equipment_no = document.getElementsByName("equipment_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;			
		var spare1 = document.getElementsByName("spare1")[0].value;	
		
		var facilities_name = document.getElementsByName("facilities_name")[0].value;
		var quantity = document.getElementsByName("quantity")[0].value;		
		var measurement_unit = document.getElementsByName("measurement_unit")[0].value;			
		var price = document.getElementsByName("price")[0].value;		
		var aggregate_sum = document.getElementsByName("aggregate_sum")[0].value;		
		var acquisition = document.getElementsByName("acquisition")[0].value;	
 		var plan_acquisition_time = document.getElementsByName("plan_acquisition_time")[0].value;		
		var plan_date = document.getElementsByName("plan_date")[0].value;		
		var project_no = document.getElementsByName("project_no")[0].value;		
		
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
 
	  if(equipment_no !=null && equipment_no !=''){
		    rowParam['equipment_no'] = equipment_no;
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			rowParam['spare1'] = spare1;
	  }else{
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			rowParam['spare1'] = spare1;
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_EQUIPMENT_CONFIGURATION",rows);	
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
 
	if(equipment_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "select cn.project_no, cn.org_sub_id, cn.equipment_no,cn.facilities_name,cn.quantity,cn.measurement_unit,cn.price,cn.aggregate_sum,cn.acquisition,cn.plan_acquisition_time,cn.plan_date , cn.facilities_name1,  cn.quantity1,cn.measurement_unit1,cn.model_num,cn.numbers,cn.price1,cn.aggregate_sum1,cn.acquisition1,cn.acquisition_time,cn.equipment_state,cn.put_use_date,cn.valid_time, cn.check_date,cn.use_department,cn.the_use,cn.remark,cn.second_org,cn.third_org,oi3.org_abbreviation org_name,cn.creator,cn.create_date,cn.bsflag,cn.spare1,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_EQUIPMENT_CONFIGURATION cn    left  join comm_org_subjection os1     on cn.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0' left  join comm_org_subjection os2     on cn.third_org = os2.org_subjection_id    and os2.bsflag = '0' left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id = cn.org_sub_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0'     where cn.bsflag = '0' and  cn.equipment_no='"+equipment_no+"'"; 				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 
		   
	             document.getElementsByName("equipment_no")[0].value=datas[0].equipment_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;		  
	    		 document.getElementsByName("spare1")[0].value=datas[0].spare1;		 
	    		 
	    		 document.getElementsByName("facilities_name")[0].value=datas[0].facilities_name;
	    		document.getElementsByName("quantity")[0].value=datas[0].quantity;		
	    		document.getElementsByName("measurement_unit")[0].value=datas[0].measurement_unit;			
	    		document.getElementsByName("price")[0].value=datas[0].price;		
	    		document.getElementsByName("aggregate_sum")[0].value=datas[0].aggregate_sum;		
	    		document.getElementsByName("acquisition")[0].value=datas[0].acquisition;	
	    	 	 document.getElementsByName("plan_acquisition_time")[0].value=datas[0].plan_acquisition_time;		
	    		 document.getElementsByName("plan_date")[0].value=datas[0].plan_date;				
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;	
	    
			}					
		
	    	}		
		
	}

</script>
</html>
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
	
	String emergency_no="";
	if(request.getParameter("emergency_no") != null){
		emergency_no=request.getParameter("emergency_no");	
		
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
<title>应急物资台账</title>
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
					      	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
					      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="emergency_no" name="emergency_no"   />
					       	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
	     			      	 <td class="inquire_item6"><font color="red">*</font>物资名称：</td>
							    <td class="inquire_form6">
							    <input type="text" id="supplies_name" name="supplies_name" class="input_width" />
							    </td>
					  </tr>					  
						<tr>
						 <td class="inquire_item6"><font color="red">*</font>物资类别：</td>
						    <td class="inquire_form6">
						    <select id="supplies_category" name="supplies_category" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >人身防护</option>
						       <option value="2" >医疗急救</option>
						       <option value="3" >消防救援</option>
						       <option value="4" >防洪防汛</option>
						       <option value="5" >应急照明</option>
						       <option value="6" >交通运输</option>
						       <option value="7" >通讯联络</option>
						       <option value="8" >检测监测</option>
						       <option value="9" >工程抢险</option>
						       <option value="10" >剪切破拆</option>
						       <option value="11" >电力抢修</option>
						       <option value="12" >其他</option>
							</select> 
						    </td> 
						    <td class="inquire_item6">型号/规格：</td>					 
						    <td class="inquire_form6"> 
						    <input type="text" id="model_num" name="model_num" class="input_width"  />
	 					    </td>	
					  </tr>
						
					  <tr>	 
					   <td class="inquire_item6"><font color="red">*</font>	数量：</td>
					    <td class="inquire_form6"><input type="text" id="quantity" name="quantity"    class="input_width"/></td>
					   <td class="inquire_item6"><font color="red">*</font>计量单位：</td>
					    <td class="inquire_form6"><input type="text" id="unit_measurement" name="unit_measurement"    class="input_width"/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>购置时间：</td>
					    <td class="inquire_form6">
					    <input type="text" id="acquisition_time" name="acquisition_time" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time,tributton1);" />&nbsp;</td>
					    </td>
					    <td class="inquire_item6">有效期截止至：</td>
					    <td class="inquire_form6">
					    <input type="text" id="valid_until" name="valid_until" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_until,tributton2);" />&nbsp;</td>
					    </td>		
					  </tr>					  
					 
					  <tr>
					    <td class="inquire_item6">校验期截止至：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_period_until" name="check_period_until" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_period_until,tributton3);" />&nbsp;</td>
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>存放位置：</td>
					    <td class="inquire_form6">
					    <input type="text" id="storage_location" name="storage_location"    class="input_width"/>
					    </td>		
					  </tr>			
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>保管人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="the_depository" name="the_depository" class="input_width" />
					    </td>
					   
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
 var emergency_no='<%=emergency_no%>';
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
 		if(emergency_no!=null && emergency_no!=""){
 		 	
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

	function checkJudge(){
 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
		var second_org = document.getElementsByName("second_org2")[0].value;			
		var third_org = document.getElementsByName("third_org2")[0].value;			
		
		var supplies_name = document.getElementsByName("supplies_name")[0].value;
		var supplies_category = document.getElementsByName("supplies_category")[0].value;			
		var quantity = document.getElementsByName("quantity")[0].value;			
		var unit_measurement = document.getElementsByName("unit_measurement")[0].value;
		var acquisition_time = document.getElementsByName("acquisition_time")[0].value; 	
		var storage_location = document.getElementsByName("storage_location")[0].value;
		var the_depository = document.getElementsByName("the_depository")[0].value;
		
		
 		if(org_sub_id==""){
 			document.getElementById("org_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("third_org").value="";
 		}
 		if(supplies_name==""){
 			alert("物资名称不能为空，请填写！");
 			return true;
 		}
 		if(supplies_category==""){
 			alert("物资类别不能为空，请选择！");
 			return true;
 		}
 		if(quantity==""){
 			alert("数量不能为空，请填写！");
 			return true;
 		}
 
		if(unit_measurement==""){
 			alert("计量单位不能为空，请填写！");
 			return true;
 		}
		if(acquisition_time==""){
 			alert("购置时间不能为空，请填写！");
 			return true;
 		}
		if(storage_location==""){
 			alert("存放位置不能为空，请填写！");
 			return true;
 		}
		if(the_depository==""){
 			alert("保管人不能为空，请填写！");
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
		var emergency_no = document.getElementsByName("emergency_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;		
		var project_no = document.getElementsByName("project_no")[0].value;		
		
		var supplies_name = document.getElementsByName("supplies_name")[0].value;
		var supplies_category = document.getElementsByName("supplies_category")[0].value;		
		var model_num = document.getElementsByName("model_num")[0].value;			
		var quantity = document.getElementsByName("quantity")[0].value;			
		var unit_measurement = document.getElementsByName("unit_measurement")[0].value;
		var acquisition_time = document.getElementsByName("acquisition_time")[0].value;
		var valid_until = document.getElementsByName("valid_until")[0].value;			
		var check_period_until = document.getElementsByName("check_period_until")[0].value;			
		var storage_location = document.getElementsByName("storage_location")[0].value;
		var the_depository = document.getElementsByName("the_depository")[0].value;
		if(check_period_until ==""){
			if(valid_until ==""){
				alert('有效期截日期不能为空！');return;
			}
		}	 
		if(valid_until ==""){
			if(check_period_until ==""){
				alert('校验期截日期不能为空！');return;
			}
		}
		
		rowParam['org_sub_id'] =org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org; 
		
		rowParam['supplies_name'] = encodeURI(encodeURI(supplies_name));
		rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category)); 
		rowParam['model_num'] =encodeURI(encodeURI(model_num)); 
		rowParam['quantity'] =quantity; 	 
		rowParam['unit_measurement'] = encodeURI(encodeURI(unit_measurement));
		rowParam['acquisition_time'] = encodeURI(encodeURI(acquisition_time)); 
		rowParam['valid_until'] =encodeURI(encodeURI(valid_until));	 
		rowParam['check_period_until'] = encodeURI(encodeURI(check_period_until));
		rowParam['storage_location'] = encodeURI(encodeURI(storage_location)); 
		rowParam['the_depository'] =encodeURI(encodeURI(the_depository));	
	 
	  if(emergency_no !=null && emergency_no !=''){
		  if(project_no !=null && project_no !='' ){
				rowParam['project_no'] =project_no;	
			}else{
				rowParam['project_no'] ='<%=projectInfoNo%>';
			}
		  
		    rowParam['emergency_no'] = emergency_no;
			//rowParam['creator'] = encodeURI(encodeURI(creator));
	    	//	rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
			rowParam['project_no'] ='<%=projectInfoNo%>';
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
		  
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_EMERGENCY_STANDBOOK",rows);	
		top.frames('list').frames[0].refreshData();	
		newClose();
  
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
 
	if(emergency_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "   select   tr.project_no,tr.org_sub_id,tr.emergency_no,tr.supplies_name,tr.supplies_category,tr.model_num,tr.quantity,tr.unit_measurement,tr.acquisition_time,  tr.valid_until,tr.check_period_until,  tr.storage_location,tr.the_depository  ,  tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_EMERGENCY_STANDBOOK tr   left  join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left  join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left  join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'     left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left  join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0'  and tr.emergency_no='"+emergency_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){	
	             document.getElementsByName("emergency_no")[0].value=datas[0].emergency_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	      		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;		    		 		 
	    		 document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;
	    		 
	    		document.getElementsByName("supplies_name")[0].value=datas[0].supplies_name;
	    		document.getElementsByName("supplies_category")[0].value=datas[0].supplies_category;		
	    		document.getElementsByName("model_num")[0].value=datas[0].model_num;			
	    		document.getElementsByName("quantity")[0].value=datas[0].quantity;			
	    		document.getElementsByName("unit_measurement")[0].value=datas[0].unit_measurement;
	    		document.getElementsByName("acquisition_time")[0].value=datas[0].acquisition_time;
	    		document.getElementsByName("valid_until")[0].value=datas[0].valid_until;			
	    		document.getElementsByName("check_period_until")[0].value=datas[0].check_period_until;			
	    		document.getElementsByName("storage_location")[0].value=datas[0].storage_location;
	    		document.getElementsByName("the_depository")[0].value=datas[0].the_depository;
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;		
			}					
		
	    	}		
		
	}

</script>
</html>
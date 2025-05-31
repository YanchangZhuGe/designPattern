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
	
	String material_no="";
	if(request.getParameter("material_no") != null){
		material_no=request.getParameter("material_no");	
		
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
<title>HSE相关物资验收</title>
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
<body   onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_accident_id" name="hse_accident_id" value="<%=hse_accident_id %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>			 				   
						  <td class="inquire_item6"> 单位：</td>
				    	  <td class="inquire_form6">
				    		<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				        	<%} %>
				        	</td>
						  <td class="inquire_item6"> 基层单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="second_org" name="second_org" class="input_width" />
				    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	<%} %>
				        	</td>
					  </tr>					  
						<tr>		
						  
				    	  <td class="inquire_item6"> 下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="material_no" name="material_no"   />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
				       
					    <td class="inquire_item6"><font color="red">*</font>物资名称：</td>
					    <td class="inquire_form6">
					    <input type="text" id="material_name" name="material_name" class="input_width"   />    					    
					    </td>					    
						</tr>	
						<tr>	
						 <td class="inquire_item6"><font color="red">*</font>使用单位/部门：</td>					 
						    <td class="inquire_form6"> 
						    <input type="text" id="use_unit" name="use_unit" class="input_width"   />     </td>
						    </tr>	
					  <tr>					  
					    <td class="inquire_item6"><font color="red">*</font>类别：</td>
					    <td class="inquire_form6"> 
					    <select id="material_type" name="material_type" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >应急物资</option>
					       <option value="2" >急救药品</option>
					       <option value="3" >劳保用品</option>
					       <option value="4" >安全防护设施</option>
					       <option value="5" >其他</option>
						</select>
					    </td>
					   <td class="inquire_item6"> 型号/规格：</td>
					    <td class="inquire_form6"><input type="text" id="material_model" name="material_model"    class="input_width"/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>数量：</td>
					    <td class="inquire_form6">
					    <input type="text" id="material_quantity" name="material_quantity" class="input_width" />
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>外观是否完好：</td>
					    <td class="inquire_form6">
					    <select id="if_good" name="if_good" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="2" >否</option>					      
						</select>
						</td>
					  </tr>					  
					  <tr>					
					    <td class="inquire_item6"><font color="red">*</font>标识：</td>
					    <td class="inquire_form6">
					    <select id="identification" name="identification" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >符合</option>
					       <option value="2" >不符合</option>					      
						</select>
					    </td>					 
					    <td class="inquire_item6"><font color="red">*</font>有效期截止至：</td>
					    <td class="inquire_form6"><input type="text" id="valid_until" name="valid_until" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_until,tributton1);" />&nbsp;</td>
			 
					  </tr>					
					  <tr>					
					    <td class="inquire_item6"><font color="red">*</font>验收人：</td>
					    <td class="inquire_form6"><input type="text" id="acceptance_people" name="acceptance_people" class="input_width" /></td>					 
					    <td class="inquire_item6"><font color="red">*</font>验收时间：</td>
					    <td class="inquire_form6"><input type="text" id="acceptance_time" name="acceptance_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acceptance_time,tributton2);" />&nbsp;</td>
					  </tr>						  
					  
					</table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"> 其他验收内容：</td> 	 				    
					    <td class="inquire_form6"  >
					    <input type="text" id="other_content" name="other_content" class="input_width" style="width:500px;" /></td>				 
					    <td class="inquire_item6"> </td>  
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>验收意见：</td>
					    <td class="inquire_form6"  >
					    <input type="text" id="opinion" name="opinion" class="input_width" style="width:500px;" /></td>				 
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
 var material_no='<%=material_no%>';
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
 		if(material_no!=null && material_no!=""){
 	
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
		var use_unit = document.getElementsByName("use_unit")[0].value;
		var material_name = document.getElementsByName("material_name")[0].value;		
		var material_type = document.getElementsByName("material_type")[0].value;	 
		var material_quantity = document.getElementsByName("material_quantity")[0].value;
		var if_good = document.getElementsByName("if_good")[0].value;
		var identification = document.getElementsByName("identification")[0].value;		
		var valid_until = document.getElementsByName("valid_until")[0].value;
		var opinion = document.getElementsByName("opinion")[0].value;			
		var acceptance_people = document.getElementsByName("acceptance_people")[0].value;			
		var acceptance_time = document.getElementsByName("acceptance_time")[0].value;	 

		
 		if(org_sub_id==""){
 			document.getElementById("org_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("third_org").value="";
 		}
 		
 		if(use_unit==""){
 			alert("使用单位/部门不能为空，请填写！");
 			return true;
 		}
 		if(material_name==""){
 			alert("物资名称不能为空，请选择！");
 			return true;
 		}
 		if(material_type==""){
 			alert("物资类别不能为空，请填写！");
 			return true;
 		}
  
		if(material_quantity==""){
 			alert("数量不能为空，请填写！");
 			return true;
 		}
		if(if_good==""){
 			alert("外观是否完好不能为空，请填写！");
 			return true;
 		}
		if(identification==""){
 			alert("标识不能为空，请填写！");
 			return true;
 		}
		
		if(valid_until==""){
 			alert("有效期截止至不能为空，请填写！");
 			return true;
 		}
		
		if(opinion==""){
 			alert("验收意见不能为空，请填写！");
 			return true;
 		}
		
		if(acceptance_people==""){
 			alert("验收人不能为空，请填写！");
 			return true;
 		}
		if(acceptance_time==""){
 			alert("验收时间不能为空，请填写！");
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
		
		var material_no = document.getElementsByName("material_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;					
		var use_unit = document.getElementsByName("use_unit")[0].value;
		var material_name = document.getElementsByName("material_name")[0].value;		
		var material_type = document.getElementsByName("material_type")[0].value;			
		var material_model = document.getElementsByName("material_model")[0].value;			
		var material_quantity = document.getElementsByName("material_quantity")[0].value;
		var if_good = document.getElementsByName("if_good")[0].value;
		var identification = document.getElementsByName("identification")[0].value;		
		var valid_until = document.getElementsByName("valid_until")[0].value;
		var other_content = document.getElementsByName("other_content")[0].value;		
		var opinion = document.getElementsByName("opinion")[0].value;			
		var acceptance_people = document.getElementsByName("acceptance_people")[0].value;			
		var acceptance_time = document.getElementsByName("acceptance_time")[0].value;
		var project_no = document.getElementsByName("project_no")[0].value;		
		
		
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			 
		rowParam['use_unit'] = encodeURI(encodeURI(use_unit));
		rowParam['material_name'] = encodeURI(encodeURI(material_name));
		rowParam['material_type'] = encodeURI(encodeURI(material_type));
		rowParam['material_model'] = encodeURI(encodeURI(material_model));		 
		rowParam['material_quantity'] = encodeURI(encodeURI(material_quantity));
		rowParam['if_good'] = encodeURI(encodeURI(if_good));
		rowParam['identification'] = encodeURI(encodeURI(identification));
		rowParam['valid_until'] = encodeURI(encodeURI(valid_until));		 
		rowParam['other_content'] = encodeURI(encodeURI(other_content));
		rowParam['opinion'] = encodeURI(encodeURI(opinion));
		rowParam['acceptance_people'] = encodeURI(encodeURI(acceptance_people));
		rowParam['acceptance_time'] = encodeURI(encodeURI(acceptance_time));
 
		var isProject = "<%=isProject%>";
		 
	  if(material_no !=null && material_no !=''){
		  
		    rowParam['material_no'] = material_no;
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
		saveFunc("BGP_HSE_MATERIAL",rows);	
		top.frames('list').refreshData();	
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
 
	if(material_no !=null&&material_no!=""){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = " select  tr.project_no, tr.second_org,tr.third_org,oi3.org_abbreviation as org_name, tr.material_no, tr.creator,tr.create_date,tr.bsflag, tr.use_unit,tr.material_name,tr.material_type,tr.material_model,tr.material_quantity,tr.if_good,tr.identification,tr.valid_until,tr.other_content,tr.opinion,tr.acceptance_people,tr.acceptance_time,oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_MATERIAL tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join  comm_org_information oi3 on oi3.org_id = os3.org_id  where tr.bsflag = '0' and tr.material_no='"+material_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null&&datas!=""){				 
		   
	             document.getElementsByName("material_no")[0].value=datas[0].material_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;	    	    
	    		  document.getElementsByName("use_unit")[0].value=datas[0].use_unit;
	     		  document.getElementsByName("material_name")[0].value=datas[0].material_name;
	    		  document.getElementsByName("material_type")[0].value=datas[0].material_type;		
	    		  document.getElementsByName("material_model")[0].value=datas[0].material_model;			
	    		  document.getElementsByName("material_quantity")[0].value=datas[0].material_quantity;			
	    		  document.getElementsByName("if_good")[0].value=datas[0].if_good;
	    	      document.getElementsByName("identification")[0].value=datas[0].identification; 
	    		  document.getElementsByName("valid_until")[0].value=datas[0].valid_until;	 
	    	      document.getElementsByName("other_content")[0].value=datas[0].other_content;
    		      document.getElementsByName("opinion")[0].value=datas[0].opinion;		
    		      document.getElementsByName("acceptance_people")[0].value=datas[0].acceptance_people;			
    		      document.getElementsByName("acceptance_time")[0].value=datas[0].acceptance_time;			
       		      document.getElementsByName("project_no")[0].value=datas[0].project_no;		
	    
			}					
		
	    	}		
		
	}

</script>
</html>
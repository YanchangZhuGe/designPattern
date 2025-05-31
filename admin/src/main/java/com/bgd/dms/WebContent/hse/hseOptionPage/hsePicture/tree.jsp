<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = (user==null)?"":user.getEmpId();
	String extPath = contextPath + "/js/ext-min";
	String father_id = request.getParameter("father_id");
	String sub_id = request.getParameter("sub_id");
	String org_subjection_id = request.getParameter("org_subjection_id");
	String org_type = request.getParameter("org_type");

	String org_sub_id = request.getParameter("org_sub_id");
	String second_org = request.getParameter("second_org");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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
<title></title>
<script type="text/javascript" language="javascript">
cruConfig.contextPath ="<%=contextPath%>";
var  org_id="<%=father_id%>";
var  org_subjection_id="<%=org_subjection_id%>";
var  org_type="<%=org_type%>";
var  org_sub_id="<%=org_sub_id%>";
var  second_org="<%=second_org%>";

function checkForm(){
	if(!notNullForCheck("file","机关图片")) return false;
	return true;
}
function checkFormA(){
	if(!notNullForCheck("fileA","单位图片")) return false;
	return true;
}
function checkFormB(){
	if(!notNullForCheck("fileB","基层单位图片")) return false;
	return true;
}

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}


function divShow(){
	if(org_type=='0'){
		document.getElementById("div1").style.display="block";
	}
	if(org_type=='1'){		
		document.getElementById("div2").style.display="block";
		var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and t.spare1='0'  ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		var datas = queryRet.datas;		
		if(queryRet.returnCode=='0'){
			if(datas != null && datas != ''  ){	
		 		 document.getElementsByName("mainIdA")[0].value=datas[0].pmain_id; 
			}
	    }
	}
	if(org_type=='2'){
		document.getElementById("div3").style.display="block";
		var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and t.spare1='1'  and  t.org_id='"+org_sub_id+"'  ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		var datas = queryRet.datas;		
			if(queryRet.returnCode=='0'){
				if(datas != null && datas != ''  ){	
			 		 document.getElementsByName("mainIdB")[0].value=datas[0].pmain_id; 
				}
		    }
		
	}
	
	
}



function save(){
	if(checkForm()){
		var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and  t.org_id like '%"+org_id+"%' and t.org_subjection_id like '%"+org_subjection_id+"%' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		var datas = queryRet.datas;		
		if(queryRet.returnCode=='0'){
			if(datas != null && datas != ''){	
				 document.getElementsByName("fileId")[0].value=datas[0].pmain_id; 
				 document.getElementsByName("ucmId")[0].value=datas[0].ucm_id; 
			}
		}
//	        var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
//			var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_HIDDEN_INFORMATION&JCDP_TABLE_ID='+hidden_no +'&subflag=1';
//		    syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息	
		
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/hse/toSaveProjectDoc.srq";
		form.submit();
		alert("上传成功!");
		newClose();
		parent.mainRightframe.page_init();	
	}
}

function saveB(){
	if(checkFormB()){
		 var idNull=document.getElementsByName("mainIdB")[0].value; //主表id
		 if(idNull==""){
			 alert("请先上传单位图片!");
		 }else{
			var querySql = " select t.mdetail_id,t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MDETAIL t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0'   and  t.org_id like '%"+org_id+"%'  and  t.org_sub_id='"+org_sub_id+"' and t.second_org='"+second_org+"' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			var datas = queryRet.datas;		
			if(queryRet.returnCode=='0'){
				if(datas != null && datas != ''){	
					 document.getElementsByName("fileIdB")[0].value=datas[0].mdetail_id; //子表id
					 document.getElementsByName("ucmIdB")[0].value=datas[0].ucm_id; 
				}
			}
	
			var form = document.getElementById("CheckForm");
			form.action = "<%=contextPath%>/hse/toSaveProjectDocB.srq";
			form.submit();
			alert("上传成功!");	newClose();
			parent.mainRightframe.page_init();
		//	parent.mainRightframe.toOption();
			//传主键id到one和oldOne页面上，进行实现截图定位保存
		 }
	}
}

function saveA(){
	if(checkFormA()){
		 var idNull=document.getElementsByName("mainIdA")[0].value;
			 if(idNull==""){
				 alert("请先上传机关图片!");
			 }else{
				var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and t.spare1='1' and  t.org_id like '%"+org_id+"%' and t.spare2='"+idNull+"' and t.org_subjection_id like '%"+org_subjection_id+"%' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				var datas = queryRet.datas;		
				if(queryRet.returnCode=='0'){
					if(datas != null && datas != ''){	
						 document.getElementsByName("fileIdA")[0].value=datas[0].pmain_id; 
						 document.getElementsByName("ucmIdA")[0].value=datas[0].ucm_id; 
					}
				}
		
				var form = document.getElementById("CheckForm");
				form.action = "<%=contextPath%>/hse/toSaveProjectDocA.srq";
				form.submit();
				alert("上传成功!");	newClose();
				parent.mainRightframe.page_init();
			//	parent.mainRightframe.toOption();
				//传主键id到one和oldOne页面上，进行实现截图定位保存
			 }
	}
}


</script>
</head>
<body onload="divShow()">
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data"> 
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;">
			<div id="div1" style="display:none">
			<fieldset>
			<legend>
			上传机关图片
			</legend>
			 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					 <tr>
					   <td class="inquire_item4"> </td>
			           <td class="inquire_form4"  colspan="2">
			           <input name="org_subjection_id" id="org_subjection_id" class="input_width" value="<%=org_subjection_id%>" type="hidden" />
			           <input name="father_id" id="father_id" class="input_width" value="<%=father_id%>" type="hidden" />
			           <input name="creatorId" id="creatorId" class="input_width" value="<%=userId%>" type="hidden" readonly="readonly"/>
			           <input name="fileId" id="fileId" class="input_width" value="" type="hidden" readonly="readonly"/>
			           <input name="ucmId" id="ucmId" class="input_width" value="" type="hidden" readonly="readonly"/>
			           <input name="org_type" id="org_type" class="input_width" value="<%=org_type%>" type="hidden" readonly="readonly"/>
			           </td>			
			     	  </tr>	 
		     	  
					 <tr>
			           <td class="inquire_form4"  colspan="3">
			           <input name="file" id="file" class="input_width" value="" type="file" />
			           <a href="" id="fileUrl" name="fileUrl" style="display:none">下载</a>     
			       	   <span class="tj_btn"><a href="#" onclick="save()"></a></span>
			           </td>			
			     	  </tr>	 
		     	  </table>
	     	 </fieldset><br>
	     	 </div>
	     	<div id="div2" style="display:none">
				<fieldset>
				<legend>
				上传单位图片
				</legend>
				 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_heightA">
						 <tr>
						   <td class="inquire_item4"> </td>
				           <td class="inquire_form4"  colspan="2">
				           <input name="org_subjection_idA" id="org_subjection_idA" class="input_width" value="<%=org_subjection_id%>" type="hidden" />
				           <input name="father_idA" id="father_idA" class="input_width" value="<%=father_id%>" type="hidden" />
				           <input name="creatorIdA" id="creatorIdA" class="input_width" value="<%=userId%>" type="hidden" readonly="readonly"/>
				           <input name="fileIdA" id="fileIdA" class="input_width" value="" type="hidden" readonly="readonly"/>
				           <input name="ucmIdA" id="ucmIdA" class="input_width" value="" type="hidden" readonly="readonly"/>
				           <input name="mainIdA" id="mainIdA" class="input_width" value="" type="hidden" readonly="readonly"/>
				           <input name="org_typeA" id="org_typeA" class="input_width" value="<%=org_type%>" type="hidden" readonly="readonly"/>
				           <input name="org_sub_idA" id="org_sub_idA" class="input_width" value="<%=org_sub_id%>" type="hidden" />
				           <input name="second_orgA" id="second_orgA" class="input_width" value="<%=second_org%>" type="hidden" />
				           </td>			
				     	  </tr>	 
			     	  
						 <tr>
				           <td class="inquire_form4"  colspan="3">
				           <input name="fileA" id="fileA" class="input_width" value="" type="file" />
				           <a href="" id="fileUrlA" name="fileUrlA" style="display:none">下载</a>     
				       	   <span class="tj_btn"><a href="#" onclick="saveA()"></a></span>
				           </td>			
				     	  </tr>	 
			     	  </table>
		     	 </fieldset><br>
		     	 </div>
		     	<div id="div3" style="display:none">
					<fieldset>
					<legend>
					上传基层单位图片
					</legend>
					 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_heightB">
							 <tr>
							   <td class="inquire_item4"> </td>
					           <td class="inquire_form4"  colspan="2">
					           <input name="org_subjection_idB" id="org_subjection_idB" class="input_width" value="<%=org_subjection_id%>" type="hidden" />
					           <input name="father_idB" id="father_idB" class="input_width" value="<%=father_id%>" type="hidden" />
					           <input name="creatorIdB" id="creatorIdB" class="input_width" value="<%=userId%>" type="hidden" readonly="readonly"/>
					           <input name="fileIdB" id="fileIdB" class="input_width" value="" type="hidden" readonly="readonly"/>
					           <input name="ucmIdB" id="ucmIdB" class="input_width" value="" type="hidden" readonly="readonly"/>
 
					           <input name="mainIdB" id="mainIdB" class="input_width" value="" type="hidden" readonly="readonly"/>
					           <input name="org_typeB" id="org_typeB" class="input_width" value="<%=org_type%>" type="hidden" readonly="readonly"/>
					           <input name="org_sub_idB" id="org_sub_idB" class="input_width" value="<%=org_sub_id%>" type="hidden" />
					           <input name="second_orgB" id="second_orgB" class="input_width" value="<%=second_org%>" type="hidden" />
					           
					           </td>			
					     	  </tr>	 
				     	  
							 <tr>
					           <td class="inquire_form4"  colspan="3">
					           <input name="fileB" id="fileB" class="input_width" value="" type="file" />
					           <a href="" id="fileUrlB" name="fileUrlB" style="display:none">下载</a>     
					       	   <span class="tj_btn"><a href="#" onclick="saveB()"></a></span>
					           </td>			
					     	  </tr>	 
				     	  </table>
			     	 </fieldset><br>
			     	 
		     	 </div>
	</div>
		  
</form>
</body>
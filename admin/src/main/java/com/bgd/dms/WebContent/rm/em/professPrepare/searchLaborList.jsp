<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionIdCode = user.getSubOrgIDofAffordOrg();
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgName = user.getOrgName();
	
	String rowid = request.getParameter("rowid");
	String projectType = request.getParameter("project_type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>JCDP_em_human_employee</title> 
<style type="text/css">
.select_height{width:250px;}
 
}
</style>
 </head>  
 <body style="background:#fff;overflow-y:hidden;" onload="refreshDataA();deployStatus_P();getApplyTeamA();">
 
   <div id="list_table"> 
	 
			 <div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="10%" >&nbsp;&nbsp;组织机构</td>
			    <td width="50%" >
			    <code:codeSelect name='s_org_id1' option="orgCommOps" addAll="true"  cssClass="select_height"    selectedValue=""  />
	 
			    </td>	
			    <td  width="5%" >
		   		<span class="cx"><a href="#" onclick="simpleSearchA()" title="JCDP_btn_query"></a></span>
				</td>
				<td  width="5%" >
				    <span class="qc"><a href="#" onclick="clearQueryTextA()" title="JCDP_btn_clear"></a></span>
				</td>
				  <td width="5%">
				  <span class="tj"><a href="#" onclick="JcdpButton0OnClickA()" title="提交"></a></span> 
				 </td>
			 	    
			  </tr>
			</table>									 
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			
			
			
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="s_employee_nameA" name="s_employee_nameA" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">身份证号</td>
			    <td class="ali_cdn_input"><input id="s_employee_cdA" name="s_employee_cdA" class="input_width" type="text"/></td>
				 <td class="ali_cdn_name">性别</td>
			    <td class="ali_cdn_input"><select id="s_employee_genderA" name="s_employee_genderA" class="select_width"><option value="">请选择</option><option value="0">女</option><option value="1">男</option></select></td>
			    <td class="ali_cdn_name">调配状态</td>
			    <td class="ali_cdn_input"><select id="s_deploy_status" name="s_deploy_status" class="select_width"><option value="">请选择</option><option value="0">未调配</option><option value="1">调配中</option><option value="2">已调配</option></select></td>				  
			
			  </tr>
			</table>									 
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设置班组</td>
			    <td class="ali_cdn_input"><select id="s_set_apply_teamA" name="s_set_apply_teamA" class="select_width"  onchange="getPostA()"></select></td>
			  	<td class="ali_cdn_name">设置岗位</td>
			    <td class="ali_cdn_input"><select id="s_set_postA" name="s_set_postA" class="select_width"></select></td>
			    <td class="ali_cdn_name">项目状态</td>
			    <td class="ali_cdn_input"><select id="s_person_statusA" name="s_person_statusA" class="select_width"><option value="">请选择</option><option value="1">在项目</option><option value="0">不在项目</option></select></td>			   	    
			  </tr>
			</table>									 
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			

			<div id="table_box" style="display:block;overflow-y:hidden">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">			    
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{employeeId}-{employeeName}-{qufen}-{ifProjectName}' id='rdo_entity_id_{employeeId}'  />" >
			      	<input type='checkbox' id='headChxBox' onclick="head_chx_box_changedA(this)"/></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{laborCategoryName}">用工分类</td>
			      <td class="bt_info_odd" exp="{employeeIdCodeNo}">身份证号</td>
			      <td class="bt_info_even" exp="{employeeName}">姓名</td>
			      <td class="bt_info_odd" exp="{employeeGenderName}">性别</td>
			      <td class="bt_info_even" exp="{age}">年龄</td>
			      <td class="bt_info_odd" exp="{orgNames}">组织机构</td>

			      <td class="bt_info_even" exp="{applyTeams}">设置班组</td>
			      <td class="bt_info_odd" exp="{posts}">设置岗位</td>
			      <td class="bt_info_even" exp="{years}">工作年限</td>
			      <td class="bt_info_odd" exp="{ifProjectName}">项目状态</td>
			      <td class="bt_info_odd" exp="{spareName}">调配状态</td>
			       <td class="bt_info_even" exp="{actualStartDate}">最近一次进入项目时间</td>
			       <td class="bt_info_odd" exp="{endDate}">最近一次离开项目时间</td>
			       <td class="bt_info_even" exp="{projectName}">最近一次上岗项目名称</td>
			     </tr>    			        
			  </table>
			</div>
				<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				  <tr>
				    <td align="right">第1/1页，共0条记录</td>
				    <td width="10">&nbsp;</td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				    <td width="50">到 
				      <label>
				        <input type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
				</div>
	 
 
</div>  
		  
</body> 

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";

	cruConfig.cdtType = 'form';
 
	cruConfig.queryService = "HumanCommInfoSrv";
	cruConfig.queryOp = "searchforLaborInfo";
	
	var str = "empId=<%=user.getEmpId()%>";
 
	var rowid = "<%=rowid%>";
	var org_id = "<%=orgSubjectionIdCode%>"; 
	var employee_name="";
	var employee_cd="";
	var post="";
	var employee_gender="";
	var set_apply_team="";
	var set_post="";
	var person_status="";
	var deploy_status="";
	var str = "";
	function clearQueryTextA(){
	      document.getElementById("s_employee_nameA").value="";
		  document.getElementById("s_employee_cdA").value=""; 
		 document.getElementById("s_employee_genderA").value="";
		 document.getElementById("s_set_apply_teamA").value="";
	      document.getElementById("s_set_postA").value="";
		  document.getElementById("s_person_statusA").value="";
		  document.getElementById("s_deploy_status").value="";
		  document.getElementsByName("s_org_id1")[0].value=org_id;
	}
	// 简单查询
	function simpleSearchA(){
 
		var s_employee_name = document.getElementById("s_employee_nameA").value;
		var s_employee_cd = document.getElementById("s_employee_cdA").value;
	 
		var s_employee_gender = document.getElementById("s_employee_genderA").value;
		var s_set_apply_team = document.getElementById("s_set_apply_teamA").value;
		var s_set_post = document.getElementById("s_set_postA").value;
		var s_person_status = document.getElementById("s_person_statusA").value;
		var s_deploy_status = document.getElementById("s_deploy_status").value;
		var s_org_id = document.getElementsByName("s_org_id1")[0].value;
 
		if(s_org_id!=''){
			org_id = s_org_id;
		}	
		if(s_employee_name!=''){
			employee_name = s_employee_name;
		}
		if(s_employee_cd!=''){
			employee_cd = s_employee_cd;
		}
	 
		if(s_employee_gender!=''){
			employee_gender = s_employee_gender;
		}
		if(s_set_apply_team!=''){
			set_apply_team = s_set_apply_team;
		}
		if(s_set_post!=''){
			set_post = s_set_post;
		}
		if(s_person_status!=''){
			person_status = s_person_status;
		}
		 
		if(s_deploy_status!=''){
 			deploy_status = s_deploy_status;
 		}
 		
	 
		cruConfig.submitStr = "org_id="+org_id+"&employee_name="+employee_name+"&employee_cd="+employee_cd+"&employee_gender="+employee_gender+"&set_apply_team="+set_apply_team+"&set_post="+set_post+"&person_status="+person_status+"&spare="+deploy_status;	

		  queryData(1);
	    	//禁用复选框不为  为调配状态
				var obj = document.getElementsByName("rdo_entity_id");   
		        for (i=0; i<obj.length; i++){   
		            //判斷obj集合中的i元素是否為cb，若否則表示未被點選     
		            	var pw=obj[i].value;    
		            	var pws=pw.split("-")[3];   
		            	if(pws!='不在项目'){
		            		obj[i].disabled=true;
		            	}
		            
		        }    
		        
	 
		 employee_name="";
		 employee_cd="";
		 post="";
		 employee_gender="";
		 set_apply_team="";
		 set_post="";
		 person_status="";
		 deploy_status="";
	 		
	
	}
	
	function refreshDataA(){
 
		simpleSearchA();
		cruConfig.currentPageUrl = "/rm/em/professPrepare/searchLaborList.jsp";		
		queryData(1);
		
	}

	
	function loadDataDetailA(ids){

		
	}

	 
	function JcdpButton0OnClickA(){
		
		ids = getSelIds('rdo_entity_id');

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		

		top.parent.dialogCallback('getMessage',[rowid,ids]);
		newClose();  
	}

	
	  function getApplyTeamA(){
	    	var selectObj = document.getElementById("s_set_apply_teamA"); 
	    	document.getElementById("s_set_apply_teamA").innerHTML="";
	    	selectObj.add(new Option('请选择',""),0);
	    	var parmType='projectType=<%=projectType%>';
	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP",parmType);
	    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
	    		var templateMap = applyTeamList.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	    	}   	
	    	var selectObj1 = document.getElementById("s_set_postA");
	    	document.getElementById("s_set_postA").innerHTML="";
	    	selectObj1.add(new Option('请选择',""),0);
	    }

	    function getPostA(){
	        var applyTeam = "applyTeam="+document.getElementById("s_set_apply_teamA").value;   
	    	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

	    	var selectObj = document.getElementById("s_set_postA");
	    	document.getElementById("s_set_postA").innerHTML="";
	    	selectObj.add(new Option('请选择',""),0);
	    	if(applyPost.detailInfo!=null){
	    		for(var i=0;i<applyPost.detailInfo.length;i++){
	    			var templateMap = applyPost.detailInfo[i];
	    			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	    		}
	    	}
	    }
	    
		function head_chx_box_changedA(headChx){
			var chxBoxes = document.getElementsByName("rdo_entity_id");
			if(chxBoxes==undefined) return;
			for(var i=0;i<chxBoxes.length;i++){
			  if(!chxBoxes[i].disabled){
					chxBoxes[i].checked = headChx.checked;	
			  }
			  
			}
		}
		
		function deployStatus_P(){  
			var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            //判斷obj集合中的i元素是否為cb，若否則表示未被點選     
	            	var pw=obj[i].value;   
	            	var pws=pw.split("-")[3];  
	            	if(pws!='不在项目'){
	            		//obj[i].checked = false;
	            		obj[i].disabled=true;
	            	}
	            
	        }    
	        
		}
	    
		
		
</script>




</html>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);

	String orgSubjectionId = user.getOrgSubjectionId();
	String orgName = user.getOrgName();
	
	String rowid = request.getParameter("rowid");
	String projectType = request.getParameter("project_type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>JCDP_em_human_employee</title> 
 </head> 
   
 <body style="background:#fff;overflow-y:hidden;" onload="refreshData();deployStatus_P();getApplyTeam();">
 
 <div id="tag-container_3">
 <ul id="tags" class="tags">
 <li class="selectTag" id="tag3_0" name="tag3_0"><a href="#" onclick="getTab()">正式工人员</a></li>
 <li id="tag3_1" name="tag3_1"><a href="#" onclick="getTab1()">临时工人员</a></li>
 </ul>
 </div>
 <div id="tab_box" class="tab_box"  >
 <div id="tab_box_content0" class="tab_box_content" style="background:#fff;width:840px;height:500px;overflow-x:hidden;"  >
  
      <div id="list_table"   >
      		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  
			    <td width="10%" >&nbsp;&nbsp;组织机构</td>
			    <td width="50%" >
			    <input type="hidden" value="" id="s_org_id" name="s_org_id"></input>
				<input type="text" value="" id="s_org_name" name="s_org_name"  style="width:400px;"  readonly="readonly"></input>  
			    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
			    </td>	
			    
			   	<td  width="5%" >
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td width="5%">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				  <td width="5%">
				  <span class="tj"><a href="#" onclick="JcdpButton0OnClick()" title="提交"></a></span> 
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
			    <td class="ali_cdn_input"><input id="s_employee_name" name="s_employee_name" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">员工编号</td>
			    <td class="ali_cdn_input"><input id="s_employee_cd" name="s_employee_cd" class="input_width" type="text"/></td>
				<td class="ali_cdn_name">岗位</td>
			    <td class="ali_cdn_input"><input id="s_post" name="s_post" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">性别</td>
			    <td class="ali_cdn_input"><select id="s_employee_gender" name="s_employee_gender" class="select_width"><option value="">请选择</option><option value="0">女</option><option value="1">男</option></select></td>
				
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
			    <td class="ali_cdn_input"><select id="s_set_apply_team" name="s_set_apply_team" class="select_width"  onchange="getPost()"></select></td>
			  	<td class="ali_cdn_name">设置岗位</td>
			    <td class="ali_cdn_input"><select id="s_set_post" name="s_set_post" class="select_width"></select></td>
			    <td class="ali_cdn_name">调配状态</td>
			    <td class="ali_cdn_input"><select id="s_deploy_status" name="s_deploy_status" class="select_width"><option value="">请选择</option><option value="0">未调配</option><option value="1">调配中</option><option value="2">已调配</option></select></td>				  
			  	<td class="ali_cdn_name">项目状态</td>
			    <td class="ali_cdn_input"><select id="s_person_status" name="s_person_status" class="select_width"><option value="">请选择</option><option value="1">在项目</option><option value="0">不在项目</option></select></td>			   	    
			  </tr>
			</table>									 
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			
			
			<div id="table_box" style="display:block;overflow-y:hidden">
			  <table width="90%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">			    
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{employeeId}-{employeeName}-{qufen}-{deployStatus}' id='rdo_entity_id_{employeeId}'  />" >
			      	<input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employeeCd}">编号</td>
			      <td class="bt_info_even" exp="{employeeName}">姓名</td>
			      <td class="bt_info_odd" exp="{employeeGenderName}">性别</td>
			      <td class="bt_info_even" exp="{age}">年龄</td>
			      <td class="bt_info_odd" exp="{orgName}">组织机构</td>
			      <td class="bt_info_even" exp="{reliefOrgName}">调配单位</td>
			      <td class="bt_info_odd" exp="{post}">岗位</td>
			      <td class="bt_info_even" exp="{setTeamName}">设置班组</td>
			      <td class="bt_info_odd" exp="{setPostName}">设置岗位</td>
			      <td class="bt_info_even" exp="{workAge}">工作年限</td>
			      <td class="bt_info_odd" exp="{personStatus}">人员状态</td>
			      <td class="bt_info_even" exp="{planEndDate}">预计离开项目时间</td>
			      <td class="bt_info_odd" exp="{deployStatusName}">调配状态</td>
			      <td class="bt_info_even" exp="{actualStartDate}">最近一次进入项目时间</td>
			      <td class="bt_info_odd" exp="{actualEndDate}">最近一次离开项目时间</td>
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
	 
      </div> 
 	 
 	 <div id="tab_box_content1" class="tab_box_content" style="display:none;background:#fff;width:840px;height:500px;overflow-x:hidden;overflow-y:hidden;" > 
 		<iframe width="100%" height="100%" name="selectLabor" id="selectLabor" frameborder="0" src="<%=contextPath%>/rm/em/professPrepare/searchLaborList.jsp?project_type=<%=projectType%>&rowid=<%=rowid%>" marginheight="0" marginwidth="0" >
 		</iframe>	
 	 </div>  
 	 
 	 </div>  
	 <script type="text/javascript">

	 	cruConfig.contextPath =  "<%=contextPath%>";

	 	cruConfig.cdtType = 'form';
	 	cruConfig.queryService = "HumanCommInfoSrv";
	 	cruConfig.queryOp = "searchforHumanInfo";
	 	
	 	var str = "empId=<%=user.getEmpId()%>";
	 	var obj=jcdpCallService("HumanCommInfoSrv","queryOrgId",str);	

	 	document.getElementById("s_org_id").value = obj.org.orgsubid;
	 	document.getElementById("s_org_name").value = obj.org.orgname;
	 	
	 	var rowid = "<%=rowid%>";
	 	var org_id = obj.org.orgsubid;	
	 	var employee_name="";
	 	var employee_cd="";
	 	var post="";
	 	var employee_gender="";
	 	var set_apply_team="";
	 	var set_post="";
	 	var person_status="";
	 	var deploy_status="";
	 	var str = "";
	 	
		function clearQueryText(){
		      document.getElementById("s_employee_name").value="";
			  document.getElementById("s_employee_cd").value="";
			  document.getElementById("s_post").value="";
			 document.getElementById("s_employee_gender").value="";
			 document.getElementById("s_set_apply_team").value="";
		      document.getElementById("s_set_post").value="";
			  document.getElementById("s_person_status").value="";
			  document.getElementById("s_deploy_status").value="";
			
		}
		
		
	 	// 简单查询
	 	function simpleSearch(){
	 		var s_org_id = document.getElementById("s_org_id").value;
	 		var s_employee_name = document.getElementById("s_employee_name").value;
	 		var s_employee_cd = document.getElementById("s_employee_cd").value;
	 		var s_post = document.getElementById("s_post").value;
	 		var s_employee_gender = document.getElementById("s_employee_gender").value;
	 		var s_set_apply_team = document.getElementById("s_set_apply_team").value;
	 		var s_set_post = document.getElementById("s_set_post").value;
	 		var s_person_status = document.getElementById("s_person_status").value;
	 		var s_deploy_status = document.getElementById("s_deploy_status").value;

	 		if(s_org_id!=''){
	 			org_id = s_org_id;
	 		}	
	 		if(s_employee_name!=''){
	 			employee_name = s_employee_name;
	 		}
	 		if(s_employee_cd!=''){
	 			employee_cd = s_employee_cd;
	 		}
	 		if(s_post!=''){
	 			post = s_post;
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
	 		
	 		
	 		cruConfig.submitStr = "org_id="+org_id+"&employee_name="+employee_name+"&employee_cd="+employee_cd+"&post="+post+"&employee_gender="+employee_gender+"&set_apply_team="+set_apply_team+"&set_post="+set_post+"&person_status="+person_status+"&deploy_status="+deploy_status;	

	 		 	
			  queryData(1);
			    	//禁用复选框不为  为调配状态
						var obj = document.getElementsByName("rdo_entity_id");   
				        for (i=0; i<obj.length; i++){   
				            //判斷obj集合中的i元素是否為cb，若否則表示未被點選     
				            	var pw=obj[i].value;    
				            	var pws=pw.split("-")[3];   
				            	if(pws!='0'){
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
	 	
	 	function refreshData(){
 
	 		simpleSearch();
	 		cruConfig.currentPageUrl = "/rm/em/professPrepare/searchOrgHumanList.jsp";		
	 		queryData(1);
	 		
	 	}

	 	
	 	function loadDataDetail(ids){

	 		
	 	}

	 	//选择组织机构
	 	function selectOrg(){
	 	    var teamInfo = {
	 	        fkValue:"",
	 	        value:""
	 	    };
	 	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+obj.org.orgid,teamInfo);
	 	    if(teamInfo.fkValue!=""){
	 	        document.getElementById("s_org_id").value = teamInfo.fkValue;
	 	        document.getElementById("s_org_name").value = teamInfo.value;
	 	    }
	 	}

	 	function JcdpButton0OnClick(){
	 		
	 		ids = getSelIds('rdo_entity_id');

	 		if (ids == '') {
	 			alert("请选择一条记录!");
	 			return;
	 		}		

	 		top.dialogCallback('getMessage',[rowid,ids]);
	 		newClose();  
	 	}

	 	
	 	  function getApplyTeam(){
	 	    	var selectObj = document.getElementById("s_set_apply_team"); 
	 	    	document.getElementById("s_set_apply_team").innerHTML="";
	 	    	selectObj.add(new Option('请选择',""),0);
	 	    	var parmType='projectType=<%=projectType%>';
	 	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP",parmType);
	 	    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
	 	    		var templateMap = applyTeamList.detailInfo[i];
	 				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	 	    	}   	
	 	    	var selectObj1 = document.getElementById("s_set_post");
	 	    	document.getElementById("s_set_post").innerHTML="";
	 	    	selectObj1.add(new Option('请选择',""),0);
	 	    }

	 	    function getPost(){
	 	        var applyTeam = "applyTeam="+document.getElementById("s_set_apply_team").value;   
	 	    	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

	 	    	var selectObj = document.getElementById("s_set_post");
	 	    	document.getElementById("s_set_post").innerHTML="";
	 	    	selectObj.add(new Option('请选择',""),0);
	 	    	if(applyPost.detailInfo!=null){
	 	    		for(var i=0;i<applyPost.detailInfo.length;i++){
	 	    			var templateMap = applyPost.detailInfo[i];
	 	    			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	 	    		}
	 	    	}
	 	    }
	 	    
	 		function head_chx_box_changed(headChx){
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
		            	if(pws!='0'){
		            		//obj[i].checked = false;
		            		obj[i].disabled=true;
		            	}
		            
		        }    
		        
			}
		    
			
			
	 </script>
	 <script type="text/javascript">


	 function getTab() {  
	 	var selectedTag=document.getElementsByTagName("li")[0];
	 	var selectedTag1=document.getElementsByTagName("li")[1];
	 	
	 	if(selectedTag!=null){
	 		selectedTag.className ="selectTag";
	 	}
	 	if(selectedTag1!=null){
	 		selectedTag1.className ="";
	 	}
	 	var selectedTabBox = document.getElementById("tab_box_content1")
	 	selectedTabBox.style.display="NONE";
	 	var selectedTabBox0 = document.getElementById("tab_box_content0")
	 	selectedTabBox0.style.display="BLOCK";
	 	
	 }

	 function getTab1() {  
	 	var selectedTag=document.getElementsByTagName("li")[0];
	 	var selectedTag1=document.getElementsByTagName("li")[1];
	 	
	 	if(selectedTag!=null){
	 		selectedTag.className ="";
	 	}
	 	if(selectedTag1!=null){
	 		selectedTag1.className ="selectTag";
	 	}
	 	var selectedTabBox = document.getElementById("tab_box_content1")
	 	selectedTabBox.style.display="BLOCK";
	 	var selectedTabBox0 = document.getElementById("tab_box_content0")
	 	selectedTabBox0.style.display="NONE";
	 	
	 }
	  
	 </script>
	 

		  
</body>
  

</html>
<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>传输用户</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.queryStr = "";
	cruConfig.cdtType = 'form';
	
　	function chooseTeam() 
　　{ 
		var resObj = window.showModalDialog('<%=contextPath%>/pm/transferuser/selectorg.jsp',window);
		updateteam(resObj);
　　		//popTeamWin = window.open('<%=contextPath%>/pm/transferuser/selectorg.jsp','example01','width=640,height=480,alwaysRaised=1,scrollbars=yes');
　　} 
	
	function chooseProject() { 
		var orgIds = document.getElementById("orgIds").value;
		var resObj = window.showModalDialog('<%=contextPath%>/pm/transferuser/selectprj.jsp?orgId='+orgIds,window);
		updateProjects(resObj);
		//window.open('<%=contextPath%>/pm/transferuser/selectprj.jsp?orgId='+orgIds,'example01','width=640,height=480,alwaysRaised=1,scrollbars=yes');
	}

	function updateProjects(index){
		var projectInfoNos = "";
		var projectNames = "";
		var count = index.length;
		
		if(index !=null && count > 0) {
			for (var i = 0; i < count; i++) {
			
				var subindex = index[i];
				var project = new Array(2);
				project = subindex.split(",");
				var projectInfoNo = project[0];
				var projectName = project[1];
				if(projectInfoNo == "0000"){
					continue;
				}
				
				if(i == count - 1)
				{
				    projectInfoNos=projectInfoNos + projectInfoNo;
				    projectNames=projectNames + projectName;					
				}else{
				
				    projectInfoNos=projectInfoNos + projectInfoNo+",";
				    projectNames=projectNames + projectName+",";	
			    }
			}
		}
		
		document.getElementById("projectInfoNos").value = projectInfoNos;		
		document.getElementById("projectNames").value = projectNames;					
	}
	
	
	function updateteam(index){
		var orgIds = "";
		var teamNames = "";
		var count = index.length;
		
		if(index !=null && count > 0) {
			for (var i = 0; i < count; i++) {
				var subindex = index[i];
				if(subindex==undefined){
					continue;
				}
				var team = new Array(2);
				team=subindex.split(",");
				var orgId = team[0];
				var teamName = team[1];
				
				if(i == count - 1)
				{
				    orgIds=orgIds + orgId;
				    teamNames=teamNames + teamName;					
				}else{
				
				    orgIds=orgIds + orgId+",";
				    teamNames=teamNames + teamName+",";	
			    }		
			}
		}
		document.getElementById("orgIds").value = orgIds;		
		document.getElementById("teamNames").value = teamNames;	
		document.getElementById("tr1").style.display="";
	}
		
 	function checkForm() {
        if (!isTextPropertyNotNull("transUserName", "用户名")) return false;
        if (!isTextPropertyNotNull("password", "密码")) return false;                 
        if (!isTextPropertyNotNull("password2", "确认密码")) return false;
        if (!isTextPropertyNotNull("teamNames", "队伍")) return false;
        if (!isTextPropertyNotNull("projectNames", "项目")) return false;
        
 	        
		if(!isLimitB50("transUserName","用户名")) return false;
		if(!isLimitB200("password","密码")) return false;
		if(!isLimitB200("password2","确认密码")) return false;
		
		var password = document.form0.password.value;
		var password2 = document.form0.password2.value;
		if (password!=password2){
			alert("密码和确认密码不一致，请重新输入！");
			return false;
		}

		var transUserName = document.getElementsByName("transUserName")[0].value;
		
		//检查用户名是否存在
		var retObj = jcdpCallService("TransferUserInfoSrv", "checkUserNameExist", "transUserName="+transUserName);
 	 	if(retObj.count !="0"){
 	 		alert("用户名:"+transUserName+"已存在!");
 	 		return;
 	 	}
 	 	//
 	 	var form = document.forms[0];
		form.action="<%=contextPath%>/gpe/insertTransferUser.srq";
		form.submit();
	}
</script>
</head>

<body>
<form name="form0"  action="" method="post">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  <tr>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;用户名：</td>
    <td class="inquire_form4"  colspan="3">
       	<input type="text" name="transUserName" value="" class="input_width"/>
       	
    </td>
  </tr>  
  <tr>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;密码：</td>
    <td class="inquire_form4" >
    	<input type="password" name="password" value="" class="input_width"/>
    	
    </td>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;确认密码：</td>
    <td class="inquire_form4" >
	    <input type="password" name="password2" value="" class="input_width"/>
    	
	</td>     
  </tr>   
  <tr>  
    <td class="inquire_item4">
    	<font color="red">*</font>&nbsp;队伍：
    	<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="chooseTeam();" />
    </td>
    <td class="inquire_form4" colspan="3">
    	<input type="hidden" name="orgIds" id="orgIds"/>
    	<input type="text" name="teamNames" id="teamNames" class="input_width" readOnly/>
    	
    </td>
  </tr>    
  <tr id="tr1"  style="display: none">
    <td class="inquire_item4">
    	<font color="red">*</font>&nbsp;项目：
    	<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="chooseProject();" />
    </td>
    <td class="inquire_form4" colspan="3">
    	<input type="hidden" name="projectInfoNos" id="projectInfoNos" />
	    <input type="text" name="projectNames" id="projectNames" class="input_width" readOnly/>
    </td>
  </tr>
  </table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="checkForm()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
</html>

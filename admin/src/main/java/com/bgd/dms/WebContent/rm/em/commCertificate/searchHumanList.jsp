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
 </head> 

 <body style="background:#fff;overflow-y:auto" onload="refreshData();getApplyTeam();">
      	<div id="list_table">
      		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
			    <td   width="8%" >组织机构</td>
			    <td   width="30%" >
			    <input type="hidden" value="<%=orgSubjectionId%>" id="s_org_id" name="s_org_id"></input>
				<input type="text" value="<%=orgName%>" id="s_org_name" name="s_org_name" style="width:250px;"  readonly="readonly"></input>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
 
			    </td>	
			    <td   width="5%" >	&nbsp;姓名</td>
			    <td   width="5%"><input id="s_employee_name" name="s_employee_name" style="width:100px;" type="text"/></td>
			    <td   width="8%">	&nbsp;员工编号</td>
			    <td  width="5%" ><input id="s_employee_cd" name="s_employee_cd" style="width:100px;"  type="text"/></td>
			   	<td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				<td width="6%">&nbsp;</td>
					 
				<auth:ListButton functionId="" css="tj" event="onclick='JcdpButton0OnClick()'" title="JCDP_btn_submit"></auth:ListButton>		    
			  </tr>
			</table>									 
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			
			<div id="table_box" style="height:100%;display:block">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">			    
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{employeeId}-{employeeName}-{orgId}-{orgName}' id='rdo_entity_id_{employeeId}'  onclick='chooseOne(this)' />" >
				  </td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employeeCd}">编号</td>
			      <td class="bt_info_even" exp="{employeeName}">姓名</td>
			      <td class="bt_info_odd" exp="{employeeGenderName}">性别</td>
			      <td class="bt_info_even" exp="{age}">年龄</td>
			      <td class="bt_info_odd" exp="{orgName}">组织机构</td>
			      <td class="bt_info_odd" exp="{post}">岗位</td>
			      <td class="bt_info_even" exp="{setTeamName}">设置班组</td>
			      <td class="bt_info_odd" exp="{setPostName}">设置岗位</td>
			      <td class="bt_info_even" exp="{workAge}">工作年限</td>
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
	cruConfig.queryOp = "searchforHumanInfo";
	
	var rowid = "<%=rowid%>";
	var org_id = "<%=orgSubjectionId%>";	
	var employee_name="";
	var employee_cd="";
	var str = "";

	// 简单查询
	function simpleSearch(){
		var s_org_id = document.getElementById("s_org_id").value;
		var s_employee_name = document.getElementById("s_employee_name").value;
		var s_employee_cd = document.getElementById("s_employee_cd").value;


		if(s_org_id!=''){
			org_id = s_org_id;
		}	
		if(s_employee_name!=''){
			employee_name = s_employee_name;
		}
		if(s_employee_cd!=''){
			employee_cd = s_employee_cd;
		}
			
		cruConfig.submitStr = "org_id="+org_id+"&employee_name="+employee_name+"&employee_cd="+employee_cd;	

		refreshData();
	      employee_name="";
		  employee_cd="";
		  str = "";
	}
	
	function clearQueryText(){
		  document.getElementById("s_employee_name").value="";
		  document.getElementById("s_employee_cd").value="";
 
	}
	function refreshData(){

		cruConfig.currentPageUrl = "/rm/em/commCertificate/searchHumanList.jsp";		
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
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
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

	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
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
		
	    function chooseOne(cb){   
	        //先取得同name的chekcBox的集合物件   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
	            //else  obj[i].checked = cb.checked;   
	            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
	            else obj[i].checked = true;   
	        }   
	    }  
</script>

</html>
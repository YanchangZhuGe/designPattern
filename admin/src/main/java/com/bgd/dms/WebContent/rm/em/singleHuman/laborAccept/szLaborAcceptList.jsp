<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	//String projectInfoNo = user.getProjectInfoNo();
	
	String projectInfoNo = request.getParameter("fatherNo");
	String laborCategory = request.getParameter("params");
	
	 
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

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
      	<div id="list_table">
      	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td  width="6%" >姓名：</td>
		    <td width="5%"  ><input  style="width:100px;" id="s_employee_name" name="s_employee_name" type="text"  /></td>
		    <td width="5%" >&nbsp;&nbsp;班组</td>
		    <td width="5%"  ><select   style="width:100px;"  id="s_apply_team" name="s_apply_team" onchange="getPost()"></select></td>
		    <td width="5%" >&nbsp;&nbsp;岗位</td>
		    <td width="5%" ><select   style="width:100px;"  id="s_post" name="s_post" ></select></td>
 
		    <td width="3%"  >
			    <select  style="display:none;" id="s_fen" name="s_fen" >
			       <option value="" >请选择</option>
			       <option value="1" >已分配 </option>
			       <option value="0" selected="selected" >未分配</option>						    
			    </select> 
			    <input type='hidden' id="szButton" name="szButton" value=""/>
		    </td>
		    
		    <td class="ali_query">
	    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
  		    </td>
		    <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			</td>

		    <auth:ListButton functionId="" css="tj" event="onclick='toSave()'" title="提交保存"></auth:ListButton>
		  </tr>
		</table>
		</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		  </tr>
		</table>
		</div>
		<div id="table_box" >
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
		     <tr>
		      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{labor_deploy_id}-{deploy_detail_id}-{labor_id}-{receive_no}' id='rdo_entity_id_{humanDetailNo}'/>" >
		       <input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"/></td>
		      <td class="bt_info_even" autoOrder="1">序号</td>			      
		      <td class="bt_info_odd" exp="{employee_name}">员工姓名</td>
		      <td class="bt_info_even" exp="{employee_id_code_no}">身份证号</td>
		      <td class="bt_info_even" exp="{cont_num}">劳动合同编号</td>
		      <td class="bt_info_odd" exp="{apply_team_name}">班组</td>
		      <td class="bt_info_even" exp="{post_name}">岗位</td>
		      <td class="bt_info_odd" exp="{start_date}">预计进入项目时间</td>
		      <td class="bt_info_even" exp="{actual_start_date}">实际进入项目时间</td>
		      <td class="bt_info_even" exp="{end_date}">实际离开项目时间</td>
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

		
	// 简单查询 
	function simpleSearch(){
		
		var s_employee_name = document.getElementById("s_employee_name").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;		
		var s_fen = document.getElementById("s_fen").value;   
		
		var str = "projectInfoNo=<%=projectInfoNo%>&szFather=0";
	     	str+="&laborCategory=<%=laborCategory%>";
		if(s_employee_name != ''){
			str+="&employee_name="+s_employee_name;
		}
		if(s_apply_team != ''){
			str+="&apply_team="+s_apply_team;
		}
		if(s_post != ''){
			str+="&post="+s_post;
		}
		if(s_fen != ''){
			str+="&sfen="+s_fen;
		}
		
		cruConfig.submitStr = str;			
		queryData(1);
		
	}

	function clearQueryText(){ 
		 document.getElementById("s_employee_name").value=""; 
		 document.getElementById("s_apply_team").value="";
		 document.getElementById("s_fen").value="";
	     var selectObj = document.getElementById("s_post");
	     document.getElementById("s_post").innerHTML="";
	     selectObj.add(new Option('请选择',""),0);
	     cruConfig.cdtStr = "";
	}
	
	
 
	
	function refreshData(){	  
		cruConfig.queryService = "HumanLaborMessageSrv";
		cruConfig.queryOp = "queryLaborAcceptReturnList";
		var str="projectInfoNo=<%=projectInfoNo%>&szFather=0&laborCategory=<%=laborCategory%>&sfen=0";
		cruConfig.submitStr =str;		
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
 
	function toSave(){ 
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
 		
		var tempIds = ids.split(",");		
		var detailNos = "";
		var employeeIds = "";		
		for(var i=0;i<tempIds.length;i++){			
			detailNos = detailNos + "," + "'" + tempIds[i].split("-")[0] + "'";
			employeeIds = employeeIds + "," + "'" + tempIds[i].split("-")[1] + "'";			
		}
		
		var sql1 = "update bgp_comm_human_labor_deploy t set t.project_father_no='<%=user.getProjectInfoNo()%>',t.modifi_date=sysdate where t.labor_deploy_id in ("+detailNos.substr(1)+") ";
 
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+detailNos);
		top.frames('list').refreshData();
		newClose();
	}
	
	 
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	
    function getApplyTeam(){
    	var selectObj = document.getElementById("s_apply_team"); 
    	document.getElementById("s_apply_team").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);

    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	
    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	
    	var selectObj1 = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj1.add(new Option('请选择',""),0);
    }

    function getPost(){
        var applyTeam = "applyTeam="+document.getElementById("s_apply_team").value;   
    	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

    	var selectObj = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
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
		if(headChx.checked){
			document.getElementById("checkall").value="1";
		}else{
			document.getElementById("checkall").value="0";
		}
	}
	

</script>
</html>
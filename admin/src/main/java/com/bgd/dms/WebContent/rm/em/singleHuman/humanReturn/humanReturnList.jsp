<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = user.getProjectInfoNo();
	
	String projectType = user.getProjectType();	
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
	}
	
	String paramsType = request.getParameter("params");
	String message = "";
	if(respMsg != null){
		paramsType = respMsg.getValue("params");
		message = respMsg.getValue("message");
	}
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
 
 <body style="background:#fff" onload="refreshData();getApplyTeam();setReturn()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">返还状态</td>
			    <td class="ali_cdn_input"><select id="yorn"  name="yorn" class="select_width">
			    	<option value="4" selected>未返还</option>
					<option value="3">已返还</option>
			    </select>
			    <input type='hidden' id="checkall" name="checkall" value="0"/>
			    </td>
			    <td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" onchange="getPost()"></select></td>
			    <td class="ali_cdn_name">岗位</td>
			    <td class="ali_cdn_input"><select class="select_width"  id="s_post" name="s_post" ></select></td>
			   	<td class="ali_query">
		    		<span class="cx"><a href="#" onclick="toSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    
			    <auth:ListButton functionId="" css="gl" event="onclick='toSerach1()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    <auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="JCDP_btn_import"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox'   {disasss}    name='rdo_entity_id' value='{human_detail_no}-{employee_id}-{zy_type}' id='rdo_entity_id'/>" >
				  <input type='checkbox' id='headChxBox'  onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employee_cd}">员工编号</td>
			      <td class="bt_info_even" exp="{employee_name}">员工姓名</td>
			      <td class="bt_info_odd" exp="{team_name}">班组</td>
			      <td class="bt_info_even" exp="{work_post_name}">岗位</td>
			      <td class="bt_info_odd" exp="{plan_start_date}">预计进入项目时间</td>
			      <td class="bt_info_even" exp="{plan_end_date}">预计离开项目时间</td>
			      <td class="bt_info_odd" exp="{actual_start_date}">实际进入项目时间</td>
			      <td class="bt_info_even" exp="{actual_end_date}">实际离开项目时间</td>
			      <td class="bt_info_odd" exp="{project_evaluate}">项目评价</td>
			      <td class="bt_info_even" exp="{zy_sf}">项目转移</td>
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
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">作业</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				    	    <td>作业名称</td>
				            <td>计划开始时间</td>
				            <td>计划结束时间</td>		
				            <td>原定工期</td>	
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				
		 	</div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "HumanCommInfoSrv";
	cruConfig.queryOp = "queryHumanAcceptReturnList";
	var message =  "<%=message%>";
	var projectTyp='<%=user.getProjectType()%>';
	
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("s_employee_name").value;
			refreshData(undefined, q_file_name);
		}
	}
	function setReturn(){
		if(message != "" && message != 'null'){
			alert(message);
		}
	}
	function toAdd() {	
		
		var yorn = document.getElementById("yorn").value;	
		
		if(yorn=='3'){
			alert("请选择未返还人员");
			return;
		}
		ids = getSelIds('rdo_entity_id');
		if(ids==''){ 
			alert("请先选中一条记录!");
		    return;
		}
			
//		if(document.getElementById("checkall").value=="1"){
//			var s_apply_team = document.getElementById("s_apply_team").value;
//			var s_post = document.getElementById("s_post").value;
//			var str = "projectInfoNo=<%=projectInfoNo%>&yorn="+yorn;
			
//			if(s_apply_team != ''){
//				str+="&apply_team="+s_apply_team;
//			}
//			if(s_post != ''){
//				str+="&post="+s_post;
//			}

//			popWindow('<%=contextPath%>/rm/em/queryHumanReturn.srq?'+str,'900:700');
//		}else{
			var tempIds = ids.split(",");		
			var detailNos = "";
			var employeeIds = "";		
			for(var i=0;i<tempIds.length;i++){		
				var zy_type_id= tempIds[i].split("-")[2] ;
			 
					detailNos = detailNos + "," + "'" + tempIds[i].split("-")[0] + "'";
					employeeIds = employeeIds + "," + "'" + tempIds[i].split("-")[1] + "'";		
			 
			}

			popWindow('<%=contextPath%>/rm/em/queryHumanReturn.srq?ids='+detailNos.substr(1)+'&zyType=1&projectInfoNo=<%=projectInfoNo%>&paramsType=<%=paramsType%>&pageSize='+tempIds.length,'900:700');

//		}
									
	}
	
	
	function refreshData(arrObj){		
		var yorn = document.getElementById("yorn").value;
		var str="projectInfoNo=<%=projectInfoNo%>&paramsType=<%=paramsType%>&yorn="+yorn;	
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
			str += "&"+arrObj[key].label+"="+arrObj[key].value;
		}		
		cruConfig.submitStr =str;
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		
		var yorn = document.getElementById("yorn").value;
		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;
		var str = "projectInfoNo=<%=projectInfoNo%>&paramsType=<%=paramsType%>&yorn="+yorn;
		
		if(s_apply_team != ''){
			str+="&apply_team="+s_apply_team;
		}
		if(s_post != ''){
			str+="&post="+s_post;
		}
		
		cruConfig.submitStr = str;	
		
		queryData(1);
	}
	
	function toSerach1(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanReturn/doc_search.jsp');
	}
	
	function toDownload(){
		var elemIF = document.createElement("iframe");  
		
		var iName ="正式工人员返还";  
		iName = encodeURI(iName);
		iName = encodeURI(iName);
	
		if(projectTyp!="" && projectTyp !="null"){
			if(projectTyp =="5000100004000000006"){  //深海模板
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanReturn/importHumanListRsh.xls&filename="+iName+".xls";
			}else if (projectTyp =="5000100004000000009"){  // 综合模板
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanReturn/importHumanListRzh.xls&filename="+iName+".xls";
			}else { //其他类型
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanReturn/importHumanListRld.xls&filename="+iName+".xls";
			}
		}
		
		
		elemIF.style.display = "none";  
		document.body.appendChild(elemIF);  
	}

	
	function importData(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanReturn/humanPlanImportFile.jsp?paramsType=<%=paramsType%>','700:600');
		
	}
	
    function loadDataDetail(ids){
  	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
		var querySql = "select rownum,p.* from (select a.name,a.planned_duration,a.planned_start_date,a.planned_finish_date , to_char(a.start_date,'yyyy-MM-dd')start_date,  to_char(a.finish_date,'yyyy-MM-dd') end_date  from bgp_comm_human_receive_process t left join bgp_p6_activity a on t.task_id=a.object_id and a.bsflag='0' where t.bsflag='0' and t.employee_id='"+ids.split("-")[1]+"' and t.project_info_no='<%=projectInfoNo%>') p ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);		
		var datas = queryRet.datas;
		
		deleteTableTr("planDetailList");
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
			
				var tr = document.getElementById("planDetailList").insertRow();		
				
	          	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
	
	          	
				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].start_date;
	
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].end_date;

				var array1 = datas[i].start_date.split("-"); 
				var array2 = datas[i].end_date.split("-"); 	
				var dt1 = new Date(); 
				dt1.setFullYear(array1[0]); 
				dt1.setMonth(array1[1] - 1); 
				dt1.setDate(array1[2]); 
				var dt2 = new Date(); 
				dt2.setFullYear(array2[0]); 
				dt2.setMonth(array2[1] - 1); 
				dt2.setDate(array2[2]); 	
				var distance = dt2.getTime() - dt1.getTime(); //毫秒数	
				var days = distance / (24 * 60 * 60 * 1000);//算出天数 
				
				var td = tr.insertCell(4);
				td.innerHTML = parseInt(days)+1;
			}
		}
  		
    }
    
	function toDelete(){
		
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
		if (!window.confirm("确认撤销返还吗?")) {
			return;
		}
		jcdpCallService("HumanCommInfoSrv","deleteDeleteSave","projectInfoNo=<%=projectInfoNo%>&ids="+ids);	

		refreshData();

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
	
</script>
</html>
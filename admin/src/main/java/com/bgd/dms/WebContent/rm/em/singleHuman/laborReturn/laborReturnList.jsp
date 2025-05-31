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
	String laborCategory = request.getParameter("laborCategory");
	String message = "";

	if(respMsg != null){
		laborCategory = respMsg.getValue("laborCategory");
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
			  	<td   width="6%" >返还状态</td>
			    <td   width="5%" ><select id="yorn"  name="yorn"  style="width:100px;" >
			    	<option value="4" selected>未返还</option>
					<option value="3">已返还</option>
			    </select>
			    </td>
			    <td  width="5%" >&nbsp;&nbsp;&nbsp;班组</td>
			    <td  width="6%" ><select style="width:100px;"  id="s_apply_team" name="s_apply_team" onchange="getPost()"></select></td>
			    <td  width="5%" >&nbsp;&nbsp;&nbsp;岗位</td>
			    <td  width="6%" ><select  style="width:100px;"   id="s_post" name="s_post" ></select></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				   <% 
			        if(!"5000100004000000009".equals(projectType)){
						  %>
				 <td>&nbsp;&nbsp;&nbsp;&nbsp;可接收剩余人数为:&nbsp;<label id="labelNum" name="labelNum" style="color:red;">0</label></td>
				 <%
					}else{
				 %>	
				 <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>	
				 
				  <%
					}
				  %>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id'  {disasss}   value='{labor_deploy_id}-{deploy_detail_id}-{labor_id}' id='rdo_entity_id_{humanDetailNo}'/>" >
			      <input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>			      
			      <td class="bt_info_odd" exp="{employee_name}">员工姓名</td>
			      <td class="bt_info_even" exp="{employee_id_code_no}">身份证号</td>
			      <td class="bt_info_even" exp="{cont_num}">劳动合同编号</td>
			      <td class="bt_info_odd" exp="{apply_team_name}">班组</td>
			      <td class="bt_info_even" exp="{post_name}">岗位</td> 
			      <td class="bt_info_odd" exp="{actual_start_date}">实际进入项目时间</td>
			      <td class="bt_info_even" exp="{end_date}">实际离开项目时间</td>
			        <td class="bt_info_odd" exp="{zy_sf}" >项目转移</td>
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
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
	cruConfig.queryService = "HumanLaborMessageSrv";
	cruConfig.queryOp = "queryLaborAcceptReturnList";
	var message =  "<%=message%>";
	var projectTyp='<%=user.getProjectType()%>';
	
	function head_chx_box_changed(headChx){
		var chxBoxes = document.getElementsByName("rdo_entity_id");
		if(chxBoxes==undefined) return;
		for(var i=0;i<chxBoxes.length;i++){
		  if(!chxBoxes[i].disabled){
				chxBoxes[i].checked = headChx.checked;	
		  }
		  
		}
	}
	function setReturn(){
		if(message != "" && message != 'null'){
			alert(message);
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

	function importData(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborReturn/humanPlanImportFile.jsp?laborCategory=<%=laborCategory%>','700:600');
		
	}
	
	function toAdd() {	
				
		var yorn = document.getElementById("yorn").value;	
		
		if(yorn=='3'){
			alert("请选择未返还人员");
			return;
		}
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
				
		var tempIds = ids.split(",");		
		var deployNos = "";
		
		for(var i=0;i<tempIds.length;i++){			
			deployNos = deployNos + "," + "'" + tempIds[i].split("-")[0] + "'";	
		}
	
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborReturn/add_laborReturnModify.jsp?laborCategory=<%=laborCategory%>&id='+deployNos.substr(1),'1000:800');

	}
	
	function toSearch(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborAccept/doc_search.jsp');
	}
	
	function refreshData(){ 
		
		var querySqlNum = "      select  nvl(sum(p.people_number),0) people_number, nvl(sum(p.audit_number),0) audit_number         from bgp_project_human_post p    inner join bgp_project_human_requirement r   on p.requirement_no = r.requirement_no    left join common_busi_wf_middle te           on te.business_id = r.requirement_no and te.bsflag = '0' and te.proc_status='3' where p.bsflag = '0'  and r.project_info_no =  '<%=projectInfoNo%>' ";
		var queryRetNum = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+querySqlNum);		
		var datas = queryRetNum.datas;
		
		var querySqlAdd = "     select distinct count(t.labor_deploy_id) labor_num    from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2    on t.labor_deploy_id = d2.labor_deploy_id   and d2.bsflag = '0'  left join bgp_comm_human_labor l    on t.labor_id = l.labor_id    where t.bsflag = '0'  and t.between_param  is null   and t.project_info_no = '<%=projectInfoNo%>'   and t.end_date is   null   ";
		var queryRetAdd = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+querySqlAdd);		
		var datasAdd = queryRetAdd.datas;
		
		var sumNum=datas[0].audit_number;
		var numJieshou=datasAdd[0].labor_num;
		  if(projectTyp!="5000100004000000009"){
		document.getElementById("labelNum").innerText=sumNum-numJieshou; 
		  }
		
		
		var yorn = document.getElementById("yorn").value;	
		var headChx = document.getElementById("headChxBox");	
		head_chx_box_changed(headChx);
 
		var str="projectInfoNo=<%=projectInfoNo%>&yorn="+yorn;		
	    	str+=" &laborCategory=<%=laborCategory%>";
		cruConfig.submitStr =str;		
		queryData(1);
	}

	
	function simpleSearch(){

		var yorn = document.getElementById("yorn").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;
		var str = "projectInfoNo=<%=projectInfoNo%>&yorn="+yorn;
	    	str+=" &laborCategory=<%=laborCategory%>";
		if(s_apply_team != ''){
			str+="&apply_team="+s_apply_team;
		}
		if(s_post != ''){
			str+="&post="+s_post;
		}
		
		cruConfig.submitStr = str;			
		queryData(1);
		
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

    function loadDataDetail(ids){
    	
  	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
		var querySql = "select rownum,p.* from (select a.name,a.planned_duration,a.planned_start_date,a.planned_finish_date ,to_char(a.start_date,'yyyy-MM-dd')start_date,  to_char(a.finish_date,'yyyy-MM-dd') end_date  from bgp_comm_human_receive_labor t left join bgp_p6_activity a on t.task_id=a.object_id and a.bsflag='0' where t.bsflag='0' and t.deploy_detail_id='"+ids.split("-")[1]+"' and t.labor_id='"+ids.split("-")[2]+"' ) p ";
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
		if (!window.confirm("确认删除吗?")) {
			return;
		}
				
		var tempIds = ids.split(",");		
		var deployNos = "";
		var detailNos = "";
			
		for(var i=0;i<tempIds.length;i++){			
			deployNos = deployNos + "," + "'" + tempIds[i].split("-")[0] + "'";	
			detailNos = detailNos + "," + "'" + tempIds[i].split("-")[1] + "'";	
		}
		
		var sql1 = "update bgp_comm_human_labor_deploy t set t.bsflag='1',t.modifi_date=sysdate where t.labor_deploy_id in ("+deployNos.substr(1)+") ";
		var sql2 = "update bgp_comm_human_deploy_detail t set t.bsflag='1',t.modifi_date=sysdate where t.deploy_detail_id in ("+detailNos.substr(1)+") ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+deployNos);
		var retObject = syncRequest('Post',path,"deleteSql="+sql2+"&ids="+detailNos);
		refreshData();

	}
	
	function toDeleteSub(){
		
		var task_id = document.getElementsByName("task_id");
		var str_task_id = "";
		var flag = true;
		if(task_id != null){
			for(var i=0;i<task_id.length;i++){
				if(task_id[i].checked == true){
					flag = false;
					str_task_id = str_task_id + "," + "'" + task_id[i].value + "'";	
				}			
			}
		}
		if(flag){
			alert("请选择一条记录");
		}else{
			if (!window.confirm("确认删除吗?")) {
				return;
			}
			
			var sql1 = "update bgp_comm_human_receive_labor t set t.bsflag='1',t.modifi_date=sysdate where t.receive_no in ("+str_task_id.substr(1)+") ";
			alert(sql1);
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+str_task_id);

		}
		
		refreshData();

	}
	
	function toDownload(){
		var elemIF = document.createElement("iframe");  

		var iName ="临时工人员返还";  
		iName = encodeURI(iName);
		iName = encodeURI(iName); 
	 
		if(projectTyp!="" && projectTyp !="null"){
			if(projectTyp =="5000100004000000006"){  //深海模板
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/laborReturn/importLaborListRsh.xls&filename="+iName+".xls";
			}else if (projectTyp =="5000100004000000009"){  // 综合模板
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/laborReturn/importLaborListRzh.xls&filename="+iName+".xls";
			}else { //其他类型
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/laborReturn/importLaborListRld.xls&filename="+iName+".xls";
			}
		}
		 
		
		elemIF.style.display = "none";  
		document.body.appendChild(elemIF);  
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
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null || project_info_no.trim().equals("")){
		project_info_no = "";
	}
	String object_name = request.getParameter("object_name");
	object_name = java.net.URLDecoder.decode(object_name, "UTF-8");
	if(object_name==null){
		object_name = "null";
	}
	String task_id = request.getParameter("task_id");
	task_id = java.net.URLDecoder.decode(task_id, "GBK");
	if(task_id==null){
		task_id = "null";
	}
	String object_id = request.getParameter("object_id");
	if(object_id==null){
		object_id = "null";
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff;overflow-y: auto" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<%if(object_name!=null && object_name.trim().equals("采集")){ %>
							<td class="ali_cdn_name">汇总类型:</td>
				    		<td class="ali_cdn_input">
								<select id="history_type" name="history_type" onchange="refreshData()" class="select_width">
									<option value="1">不合格项</option>
									<option value="2">单炮</option>
								</select>
							</td>
							<%}else if(object_name!=null && (object_name.trim().equals("人工场源电磁法") || object_name.trim().equals("天然场源电磁法"))){//适应综合物化探业务 %>
							<td class="ali_cdn_name">汇总类型:</td>
				    		<td class="ali_cdn_input">
								<select id="history_type" name="history_type" onchange="refreshData()" class="select_width">
									<option value="1">不合格项</option>
									<option value="2">资料</option>
								</select>
							</td>
							<%}else{ %>
							<td class="ali_cdn_name">汇总类型:</td>
				    		<td class="ali_cdn_input">
								<select id="history_type" name="history_type" disabled="disabled" class="select_width">
									<option value="1">不合格项</option>
								</select>
							</td>
							<%} %>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_CONTROL_003" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_CONTROL_003" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <%-- <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> --%>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{summary_history_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="<span onclick=view('{summary_history_id}')><a href='#'><font color='blue'>{summary_date}</font></a></span>">汇总日期</td>
			  <td class="bt_info_even" exp="{summarier}">汇总人</span></td>
			  <td class="bt_info_odd" exp="{check_date}"><span id="check_date">检查日期</span></td>
			  <!-- <td class="bt_info_even" exp="{checker}"><span id="checker">检查人</span></td> -->
			</tr>
		</table>
	</div> 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var task_id = "<%=task_id%>";
	var object_name ='<%=object_name%>';
	function refreshData(){
		var history_type = document.getElementById("history_type").value;
		if(history_type!=null && history_type=='2'){
			object_name = '单炮';
			document.getElementById("check_date").innerHTML = '评价日期';
		}else{
			object_name ='<%=object_name%>';
			document.getElementById("check_date").innerHTML = '检查日期';
		}
		cruConfig.pageSize = cruConfig.pageSizeMax;
		cruConfig.queryStr = "select distinct t.summary_history_id ,t.summary_date ,t.check_date ,"+
		" t.summarier from bgp_qua_summary_history t " +
		" left join bgp_qua_record_summary s on t.summary_history_id = s.summary_history_id and s.bsflag='0' " +
    	" where t.bsflag='0' and s.project_info_no ='<%=project_info_no%>' and s.task_id in('<%=task_id%>') and s.object_name like'%"+object_name+"%'";
		queryData(1);
		resizeNewTitleTable();
	}
	refreshData();
	function renderNaviTable(){}
	/* 详细信息 */
	function loadDataDetail(record_id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	}
	}
	/* 修改 */
	function newSubmit() {
		var obj = document.getElementById("record_id").value;
		var submitStr = "record_id="+obj;
		obj = document.getElementById("taskId").value;
		submitStr = submitStr + "&task_id=" + obj;
		var retObj = jcdpCallService("QualityItemsSrv","editQualityItems", submitStr);
		refreshCodeData(id,name,object_id);
	}
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
	
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function view(summary_history_id){
		var object_id = '<%=object_id%>';
		var name = encodeURI(encodeURI(object_name));
		popWindow('<%=contextPath%>/qua/sProject/summary/summaryEdit.jsp?summary_history_id='+summary_history_id+'&object_name='+name+'&task_id='+task_id+'&object_id='+object_id,'1000:670');
	}
	function toEdit() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var summary_history_id = '';
		var object_id = '<%=object_id%>';
		for (var i = 0;i< objLen ;i++){   
		    if (obj[i].checked==true) { 
		    	summary_history_id=obj [i].value;
		    	var name = encodeURI(encodeURI(object_name));
		    	popWindow('<%=contextPath%>/qua/sProject/summary/summaryEdit.jsp?summary_history_id='+summary_history_id+'&object_name='+name+'&task_id='+task_id+'&object_id='+object_id,'1000:670');
		    	return;
		    }
		}
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var summary_history_id = '';
		var substr = '';
		if(window.confirm('你确定要删除吗?')){
			for (var i = 0;i< objLen;i++){   
				if (obj[i].checked==true) { 
					summary_history_id=obj [i].value;
					substr = substr +"update bgp_qua_summary_history t set t.bsflag='1' where t.summary_history_id='"+summary_history_id+"';";
				}   
			}
	    	var retObj = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+substr);
			if(retObj.returnCode=='0'){
				alert("保存成功!");
				var ctt = parent.frames('history');
				ctt.refreshData();
			} 
		}
	}
	function frameSize(){
		//setTabBoxHeight();
		//$("#table_box").css("height",$(window).height());
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

</script>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String root_folderid = user.getProjectInfoNo();
	String flag = "";
	String measure = "";
	if(resultMsg != null){
		if(resultMsg.getValue("operationflag")!=null){
			flag = resultMsg.getValue("operationflag");
			if(measure != null){
				measure = resultMsg.getValue("emergencyMeasure");
			}
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>所有项目的应急管理</title>
</head>
<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>			    			    
			    <td class="ali_cdn_name">查询条件</td>
			    <td class="ali_cdn_input">
				    <select name="query_type" id="query_type" class="select_width">
			      		<option value="2">-请选择-</option>
			      		<option value="0">项目名称</option>
			      		<%--<option value="1">项目编号</option> --%>
			      	</select>
			    </td>
			    <td class="ali_cdn_input">
				<input id="query_text" name="query_text" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>		    			    
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{emergency_id}' id='rdo_entity_id_{emergency_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{emergency_status}">状态</td>
			      <td class="bt_info_even" exp="{emergency_problem}">问题</td>
			      <td class="bt_info_odd" exp="{org_abbreviation}">填报单位</td>
			      <td class="bt_info_even" exp="{user_name}">填报人</td>
			      <td class="bt_info_odd" exp="{project_name}">所属项目</td>
			      <td class="bt_info_even" exp="{happen_date}">发生时间</td>
			      <td class="bt_info_odd" exp="{create_date}">填报时间</td>
			      <td class="bt_info_even" exp="{emergency_flag}<input type='hidden' name='is_emergency_{emergency_id}' id='is_emergency_{emergency_id}' value='{is_emergency}'/>">应急确认</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">风险</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">监控</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">处理</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">备注</a></li>
				<li id="tag3_5"><a href="#" onclick="getTab3(5)">附件</a></li>
				<li id="tag3_6"><a href="#" onclick="getTab3(6)">编码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable" class="tab_line_height">
					  <tr>
					    <td class="inquire_item4">问题：</td>
					    <td class="inquire_form4" id="item0_0"><input type="text" id="emergency_problem" name="emergency_problem" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">状态：</td>
					    <td class="inquire_form4" id="item0_1"><input type="text" id="emergency_status" name="emergency_status" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item4">时间：</td>
					    <td class="inquire_form4" id="item1_0"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">责任人：</td>
					    <td class="inquire_form4" id="item1_1"><input type="text" id="res_person_names" name="res_person_names" class="input_width" readonly="readonly"/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item4">责任单位：</td>
					    <td class="inquire_form4" id="item2_0"><input type="text" id="res_org_names" name="res_org_names" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">原因</td>
					    <td class="inquire_form4"  id="item2_1"><textarea rows="4" id="emergency_reason" name="emergency_reason"></textarea></td>
					  </tr>		
					  <tr>
					    <td class="inquire_item4">过程：</td>
					    <td class="inquire_form4" id="item3_0"><textarea rows="4" id="emergency_process" name="emergency_process"></textarea></td>
					    <td class="inquire_item4">&nbsp;</td>
					    <td class="inquire_form4"  id="item3_1">&nbsp;</td>
					  </tr>			    
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="risks" id="risks" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
						监控
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable_1" class="tab_line_height">
					  <tr>
					    <td class="inquire_item2">处理：</td>
					    <td class="inquire_form2" id="item1_0">
					    <textarea rows="4" cols="50" id="emergency_measure" name="emergency_measure" readonly="readonly"></textarea>
					    </td>
					  </tr>			    
					</table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
			</div>
			
		  </div>
</body>

<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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
	cruConfig.queryStr = "";
	cruConfig.queryService = "riskSrv";
	cruConfig.queryOp = "getAllRiskEmergency";
	
	refreshData();
	
	function refreshData(){
		cruConfig.submitStr = "isMulti=1";	
		queryData(1);
	}
	
	var emergency_id = "";
	
	var flag = '<%=flag%>';
	if(flag !=""&&flag =="success"){

		var selectedTag0 = document.getElementById("tag3_0");
		var selectedTabBox0 = document.getElementById("tab_box_content0")
		selectedTag0.className ="";
		selectedTabBox0.style.display="none";
		var selectedTag1 = document.getElementById("tag3_1");
		var selectedTabBox1 = document.getElementById("tab_box_content1")
		selectedTag1.className ="";
		selectedTabBox1.style.display="none";
		var selectedTag2 = document.getElementById("tag3_2");
		var selectedTabBox2 = document.getElementById("tab_box_content2")
		selectedTag2.className ="";
		selectedTabBox2.style.display="none";
		var selectedTag4 = document.getElementById("tag3_4");
		var selectedTabBox4 = document.getElementById("tab_box_content4")
		selectedTag4.className ="";
		selectedTabBox4.style.display="none";
		var selectedTag5 = document.getElementById("tag3_5");
		var selectedTabBox5 = document.getElementById("tab_box_content5")
		selectedTag5.className ="";
		selectedTabBox5.style.display="none";
		var selectedTag6 = document.getElementById("tag3_6");
		var selectedTabBox6 = document.getElementById("tab_box_content6")
		selectedTag6.className ="";
		selectedTabBox6.style.display="none";
		
		var selectedTag3 = document.getElementById("tag3_3");
		var selectedTabBox3 = document.getElementById("tab_box_content3");
		selectedTag3.className ="selectTag";
		selectedTabBox3.style.display="block";
		document.getElementById("emergency_measure").innerHTML = '<%=measure%>';
	}
	
	function simpleSearch(){
		var query_type = document.getElementById("query_type").value;
		//选择了按项目名称或者项目编号
		if(query_type == "0"|| query_type == "1"){
			//项目名称
			if(query_type == "0"){
				var project_name = document.getElementById("query_text").value;
				if(project_name != ""){
						cruConfig.submitStr = "isMulti=1&projectName="+project_name;	
						queryData(1);					
				}else{
					alert("请填写项目名称!");
					return;
				}
			}
			//项目编号
			else if(query_type == "1"){
				var project_number = document.getElementById("query_text").value;
				if(project_number != ""){
						cruConfig.submitStr = "isMulti=1&projectNumber="+project_number;	
						queryData(1);
				}else{
					alert("请填写项目编号!");
					return;
				}
			}
			
		}else if(query_type == "2"){
			refreshData();
		}
	}
	
	function addMeasure(){
		if(emergency_id == ""){
			alert("请先选中一条记录!")
			return;
		}else{
			location.href="<%=contextPath %>/risk/addEmergencyMeasure.srq?emergencyId="+emergency_id+"&emergencyMeasureValue="+document.getElementById("emergency_measure").value;
		}
	}
	
	function toAdd(){
	  	popWindow('<%=contextPath%>/risk/singleproject/emergencyMng/edit_emergency_mng.jsp?pageAction=Add');
	}

	function toEdit(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    if(ids.split(",").length > 1){
	    	alert("只能编辑一条记录");
	    	return;
	    }
	    
	  	popWindow('<%=contextPath%>/risk/singleproject/emergencyMng/edit_emergency_mng.jsp?pageAction=Edit&emergencyId='+ids);
	}
	
	function toDelete(){
		var fileIds = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    var params = ids.split(',');    
	    for(var i=0;i<params.length;i++){
	    	fileIds = fileIds+","+params[i];
	    }

		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("riskSrv", "deleteRiskEmergency", "emergencyId="+fileIds.substr(1));
			queryData(cruConfig.currentPage);
		}
	}
	
	function dbclickRow(ids){
		popWindow('<%=contextPath%>/risk/singleproject/emergencyMng/edit_emergency_mng.jsp?pageAction=Edit&emergencyId='+ids);
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	function loadDataDetail(ids){
		
		emergency_id = ids;
		var retObj = jcdpCallService("riskSrv", "getRiskEmergencyInfo", "emergencyId="+ids);
		
		document.getElementById("attachement").src = "<%=contextPath%>/doc/multiproject/common_doc_list_eps.jsp?relationId="+ids;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=9&relationId="+ids;
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	    document.getElementById("risks").src = "<%=contextPath%>/risk/singleproject/riskEvent/risks_of_event.jsp?relationId="+ids+"&isMulti=1";

		document.getElementById("emergency_problem").value= retObj.riskInfoMap.emergency_problem != undefined ? retObj.riskInfoMap.emergency_problem:"";
		document.getElementById("emergency_status").value = retObj.riskInfoMap.emergency_status != undefined ? retObj.riskInfoMap.emergency_status:"";
		document.getElementById("res_person_names").value= retObj.riskInfoMap.res_person_names != undefined ? retObj.riskInfoMap.res_person_names:"";
		document.getElementById("res_org_names").value= retObj.riskInfoMap.res_org_names != undefined ? retObj.riskInfoMap.res_org_names:"";
		document.getElementById("create_date").value= retObj.riskInfoMap.create_date != undefined ? retObj.riskInfoMap.create_date:"";
		document.getElementById("emergency_measure").innerHTML= retObj.riskInfoMap.emergency_measure != undefined ? retObj.riskInfoMap.emergency_measure:"";
		document.getElementById("emergency_reason").innerHTML= retObj.riskInfoMap.emergency_reason != undefined ? retObj.riskInfoMap.emergency_reason:"";
		document.getElementById("emergency_process").innerHTML = retObj.riskInfoMap.emergency_process != undefined ? retObj.riskInfoMap.emergency_process:"";

		
		risk_ids = retObj.riskInfoMap.risk_ids != undefined ? retObj.riskInfoMap.risk_ids:"";
	}
	
	function toConfirm(){
		var fileIds = "";
	    ids = getSelIds('rdo_entity_id');    
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
     		return;
    	}	
	    var params = ids.split(','); 
	    for(var i=0;i<params.length;i++){
	    	fileIds = fileIds+","+params[i];
		    var risk_flag = document.getElementById("is_emergency_"+params[i]).value;
		    if(risk_flag == "1"){
		    	alert("有风险已确认，不能再确认！");
		    	return;
		    }
	    }
		    
		if(confirm('确定是风险吗?')){  
			var retObj = jcdpCallService("riskSrv", "confirmEmergency", "riskEmergencyId="+fileIds.substr(1));
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
	}
	
	function toCancelEmergency(){
		var fileIds = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    var params = ids.split(',');    
	    for(var i=0;i<params.length;i++){
	    	fileIds = fileIds+","+params[i];
	    }
		    
		if(confirm('确定取消应急吗?')){  
			var retObj = jcdpCallService("riskSrv", "cancelEmergency", "riskEmergencyId="+fileIds.substr(1));
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
	}
	
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		var qTable_1 = getObj('commonInfoTable_1');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
			}
		}

		for (var i=0;i<qTable_1.all.length; i++) {
			var obj = qTable_1.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
			}
		}
		
	}
</script>
</html>
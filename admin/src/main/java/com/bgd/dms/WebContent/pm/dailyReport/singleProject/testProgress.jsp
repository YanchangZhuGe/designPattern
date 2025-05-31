<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String orgName = user.getOrgName();
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
<title>试验进度列表</title>
</head>

<body style="background:#fff">
		<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">  
			<tr class="even">
			    <td colspan="4" align = "left">
			    	<a href="<%=contextPath%>/pm/dailyreport/querySurveyProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">测量进度</a>
		    		&nbsp;&nbsp;
					<a href="<%=contextPath%>/pm/dailyreport/querySurfaceProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">表层进度</a>						
			    	&nbsp;&nbsp;
		    		<a href="<%=contextPath%>/pm/dailyreport/queryDrillProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">钻井进度</a>
					&nbsp;&nbsp;
					<a href="<%=contextPath%>/pm/dailyreport/queryAcquireProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>">采集进度</a>
					&nbsp;&nbsp;
					<a href="<%=contextPath%>/pm/dailyreport/queryTestProgress.srq?projectInfoNo=<%=projectNo%>&projectName=<%=projectName%>&orgName=<%=orgName%>"><font color="red">试验进度</font></a>
				</td>	
			</tr> 
		  	<tr class="tongyong_box_title">
			    <td class="inquire_item4">施工队伍：</td>
			    <td class="inquire_form4"><%=orgName  %></td>
		    	<td class="inquire_item4">项目信息：</td>
				<td class="inquire_form4"><%=projectName %></td>
			</tr> 
		</table>
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">测线号/线束号:</td>
			    <td class="ali_cdn_input">
				<input id="lineGroupId" name="lineGroupId" type="text" class="input_width"/>
			    </td>
			    <td class="ali_cdn_name">试验点位置:</td>
			    <td class="ali_cdn_input">
				<input id="testPlace" name="testPlace" type="text" class="input_width"/>
			    </td>
			    
			  	<td class="ali_cdn_name">试验类型:</td>
			    <td class="ali_cdn_input">
				    <select name="testType" id="testType" class="select_width">
			      		<option value="">-所有-</option>
			      		<option value="1">系统试验</option>
			      		<option value="2">考核试验</option>
			      	</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{test_progress_no}' id='rdo_entity_id_{test_progress_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
				  <td class="bt_info_odd" exp="{test_type_value}">试验类型</td>
			      <td class="bt_info_even" exp="{test_date}">试验日期</td>
			      <td class="bt_info_odd" exp="{line_group_id}">测线号/线束号</td>
			      <td class="bt_info_even" exp="{test_place}">试验点位置</td>
			      <td class="bt_info_odd" exp="{source_type}">震源类型</td>
			      <td class="bt_info_even" exp="{total_test_sp_num}">试验合格炮数</td>
			      <td class="bt_info_odd" exp="{test_qualified_sp_num2}">试验总炮数</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">流程处理</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">备注</a></li>
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
					  	<td class="inquire_item6">试验类型：</td>
					    <td class="inquire_form6" id="item0_0"><input type="text" id="test_type" name="test_type" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">试验日期：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="test_date" name="test_date" class="input_width" readonly="readonly"/></td>
					  	<td class="inquire_item6">测线号/线束号:</td>
					    <td class="inquire_form6" id="item0_2"><input type="text" id="line_group_id" name="line_group_id" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">X坐标：</td>
					    <td class="inquire_form6" id="item1_0"><input type="text" id="test_point_x" name="test_point_x" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">Y坐标：</td>
					    <td class="inquire_form6" id="item1_1"><input type="text" id="test_point_y" name="test_point_y" class="input_width" readonly="readonly"/></td>
					  	<td class="inquire_item6">试验点位置:</td>
					    <td class="inquire_form6" id="item1_2"><input type="text" id="test_place" name="test_place" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">试验总炮数：</td>
					    <td class="inquire_form6" id="item2_0"><input type="text" id="total_test_sp_num" name="total_test_sp_num" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">试验合格炮数：</td>
					    <td class="inquire_form6" id="item2_1"><input type="text" id="test_qualified_sp_num2" name="test_qualified_sp_num2" class="input_width" readonly="readonly"/></td>
					  	<td class="inquire_item6">震源类型:</td>
					    <td class="inquire_form6" id="item2_2"><input type="text" id="source_type" name="source_type" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">试验内容：</td>
					    <td class="inquire_form6" id="item3_0">
						<textarea rows="3" cols="25" name="test_content" id="test_content" readonly="readonly"></textarea>
						</td>
					    <td class="inquire_item6">试验结论：</td>
					    <td class="inquire_form6" id="item3_1">
					    <textarea rows="3" cols="25" name="test_conclusion" id="test_conclusion" readonly="readonly"></textarea>
					    </td>
					    <td class="inquire_item6">备注:</td>
					    <td class="inquire_form6" id="item3_2">
					    <textarea rows="3" cols="25" name="notes" id="notes" readonly="readonly"></textarea>
					    </td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
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
	cruConfig.queryService = "InputDailyProgressSrv";
	cruConfig.queryOp = "queryTestProgress";
	var projectNo = '<%=projectNo%>';
	
	refreshData();

	function refreshData(){
		cruConfig.submitStr = "projectInfoNo="+projectNo;	
		queryData(1);
	}
	
	function simpleSearch(){
		var lineGroupId = document.getElementById("lineGroupId").value;
		var testPlace = document.getElementById("testPlace").value;
		var testType = document.getElementById("testType").value;
		cruConfig.submitStr = "projectInfoNo="+projectNo+"&lineGroupId="+lineGroupId+"&testPlace="+testPlace+"&testType="+testType;	
		queryData(1);
	}
	
	function loadDataDetail(ids){
		var retObj = jcdpCallService("InputDailyProgressSrv", "queryTestProgressById", "testProgressNo="+ids);
		
		document.getElementById("test_type").value= retObj.progressInfoMap.testTypeValue != undefined ? retObj.progressInfoMap.testTypeValue:"";
		document.getElementById("test_date").value= retObj.progressInfoMap.testDate != undefined ? retObj.progressInfoMap.testDate:"";
		document.getElementById("test_place").value= retObj.progressInfoMap.testPlace != undefined ? retObj.progressInfoMap.testPlace:"";
		document.getElementById("line_group_id").value= retObj.progressInfoMap.lineGroupId != undefined ? retObj.progressInfoMap.lineGroupId:"";
		document.getElementById("test_point_x").value = retObj.progressInfoMap.testPointX != undefined ? retObj.progressInfoMap.testPointX:"";
		document.getElementById("test_point_y").value= retObj.progressInfoMap.testPointY != undefined ? retObj.progressInfoMap.testPointY:"";
		document.getElementById("total_test_sp_num").value= retObj.progressInfoMap.totalTestSpNum != undefined ? retObj.progressInfoMap.totalTestSpNum:"";
		document.getElementById("test_qualified_sp_num2").value= retObj.progressInfoMap.testQualifiedSpNum2 != undefined ? retObj.progressInfoMap.testQualifiedSpNum2:"";
		document.getElementById("source_type").value= retObj.progressInfoMap.sourceType != undefined ? retObj.progressInfoMap.sourceType:"";
		document.getElementById("test_content").innerHTML= retObj.progressInfoMap.testContent != undefined ? retObj.progressInfoMap.testContent:"";
		document.getElementById("test_conclusion").innerHTML= retObj.progressInfoMap.testConclusion != undefined ? retObj.progressInfoMap.testConclusion:"";
		document.getElementById("notes").innerHTML= retObj.progressInfoMap.notes != undefined ? retObj.progressInfoMap.notes:"";
		
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=9&relationId="+ids;
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath %>/pm/dailyReport/singleProject/editTestProgress.jsp?pageAction=Add');		
	}

	function toDelete(){
		var fileIds = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }	

	    var params = ids.split(',');    
	    for(var i=0;i<params.length;i++){
	    	fileIds = fileIds+","+params[i];
	    }
	    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("InputDailyProgressSrv", "deleteTestProgress", "testProgressIds="+fileIds.substr(1));
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
	}
	
	
	//修改文档，文档版本
	
	function toEdit(){

	    ids = getSelIds('rdo_entity_id');

	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    if(ids.split(",").length > 1){
	    	alert("只能编辑一条记录");
	    	return;
	    }
	    
		popWindow('<%=contextPath %>/pm/dailyReport/singleProject/editTestProgress.jsp?pageAction=Edit&testProgressId='+ids);

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
		
		$("#test_content")[0].innerHTML = "";
		$("#test_conclusion")[0].innerHTML = "";
		$("#notes")[0].innerHTML = "";
	}
</script>

</html>

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
	
	String flag = "";
	String measure = "";
	if(resultMsg != null){
		if(resultMsg.getValue("operationflag")!=null){
			flag = resultMsg.getValue("operationflag");
			if(measure != null){
				measure = resultMsg.getValue("riskMeasure");
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
<title>风险识别列表</title>
</head>

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">风险确认</td>
			    <td class="ali_cdn_input">
				    <select name="is_risk_confirm" id="is_risk_confirm" class="select_width">
			      		<option value="2">-请选择-</option>
			      		<option value="0">否</option>
			      		<option value="1">是</option>
			      	</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    	<auth:ListButton functionId="" css="tj" event="onclick='toConfirm()'" title="JCDP_btn_confirmrisk"></auth:ListButton>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{risk_identify_id}' id='rdo_entity_id_{risk_identify_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{risk_number}">风险编号</td>
			      <td class="bt_info_even" exp="{risk_identify_name}">风险名称</td>
			      <td class="bt_info_odd" exp="{risk_type_name}">风险类别</td>
			      <td class="bt_info_even" exp="{risk_bear_level}">风险承受度</td>
			      <td class="bt_info_odd" exp="{risk_level}">风险评级</td>
			      <td class="bt_info_even" exp="{create_date}">创建时间</td>
			      <td class="bt_info_odd" exp="{is_risk}<input type='hidden' name='is_risk_{risk_identify_id}' id='is_risk_{risk_identify_id}' value='{risk_confirm}'/>">风险确认</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">措施</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">流程处理</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">分类码</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">备注</a></li>
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
					  	<td class="inquire_item6">风险名称：</td>
					    <td class="inquire_form6" id="item0_0"><input type="text" id="risk_name" name="risk_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">风险类别：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="risk_type" name="risk_type" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">风险评级：</td>
					    <td class="inquire_form6" id="item0_2"><input type="text" id="risk_level" name="risk_level" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">风险编号：</td>
					    <td class="inquire_form6" id="item0_3"><input type="text" id="risk_number" name="risk_number" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">风险承受度：</td>
					    <td class="inquire_form6" id="item0_4"><input type="text" id="risk_bear_level" name="risk_bear_level" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">创建时间:</td>
					    <td class="inquire_form6" id="item0_5"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">创建人:</td>
					    <td class="inquire_form6" id="item0_6"><input type="text" id="creator_name" name="creator_name" class="input_width" readonly="readonly"/></td>
					  	<td class="inquire_item6">风险影响程度</td>
					    <td class="inquire_form6"><input type="text" name="influence_level" id="influence_level" class="input_width" /></td>
					  	<td class="inquire_item6">风险可能性：</td>
					    <td class="inquire_form6" id="item0_7"><input type="text" name="risk_probability" id="risk_probability" class="input_width"/></td>	

					  </tr>		
					   <tr>
					    <td class="inquire_item6">风险描述：</td>
					   	<td class="inquire_form6" id="item0_7">
					    	<textarea rows="3" cols="" name="risk_desc" id="risk_desc" readonly="readonly"></textarea>
					    </td>
					  	<td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6">&nbsp;</td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6">&nbsp;</td>
					  </tr>			    
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable_1" class="tab_line_height">
					  <tr>
					    <td class="inquire_item2">处理措施：</td>
					    <td class="inquire_form2" id="item1_0">
					    <textarea rows="4" cols="50" id="risk_measure" name="risk_measure"></textarea>
					    </td>
					  </tr>	
					  <tr>
					  	<auth:ListButton functionId="" css="tj_btn" event="onclick='addMeasure()'"></auth:ListButton>
					  </tr>			    
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
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
	cruConfig.queryService = "riskSrv";
	cruConfig.queryOp = "getAllRiskIdentify";
	var risk_id_value = "";
	var flag = '<%=flag%>';
	if(flag !=""&&flag =="success"){
		var selectedTag0 = document.getElementById("tag3_0");
		var selectedTabBox0 = document.getElementById("tab_box_content0")
		selectedTag0.className ="";
		selectedTabBox0.style.display="none";
		var selectedTag1 = document.getElementById("tag3_1");
		var selectedTabBox1 = document.getElementById("tab_box_content1");
		selectedTag1.className ="selectTag";
		selectedTabBox1.style.display="block";
		document.getElementById("risk_measure").innerHTML = '<%=measure%>';
	}
	
	refreshData();

	function refreshData(){
		cruConfig.submitStr = "";	
		queryData(1);
	}
	
	function simpleSearch(){
		var is_risk_confirm = document.getElementById("is_risk_confirm").value;
		if(is_risk_confirm == "0"|| is_risk_confirm == "1"){
			cruConfig.submitStr = "riskConfirm="+is_risk_confirm;	
			queryData(1);
		}else if(is_risk_confirm == "2"){
			refreshData();
		}

	}
	
	function loadDataDetail(ids){
		var retObj = jcdpCallService("riskSrv", "getRiskIdenfityInfo", "riskIdentifyID="+ids);
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=9&relationId="+ids;
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		document.getElementById("risk_name").value= retObj.riskInfoMap.risk_db_name != undefined ? retObj.riskInfoMap.risk_db_name:"";
		document.getElementById("risk_level").value = retObj.riskInfoMap.risk_level != undefined ? retObj.riskInfoMap.risk_level:"";
		document.getElementById("risk_type").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		document.getElementById("create_date").value= retObj.riskInfoMap.create_date != undefined ? retObj.riskInfoMap.create_date:"";
		document.getElementById("creator_name").value= retObj.riskInfoMap.creator_name != undefined ? retObj.riskInfoMap.creator_name:"";
		document.getElementById("risk_desc").innerHTML= retObj.riskInfoMap.risk_desc != undefined ? retObj.riskInfoMap.risk_desc:"";
		document.getElementById("risk_number").value= retObj.riskInfoMap.risk_number != undefined ? retObj.riskInfoMap.risk_number:"";
		document.getElementById("risk_bear_level").value= retObj.riskInfoMap.risk_bear_level != undefined ? retObj.riskInfoMap.risk_bear_level:"";
		document.getElementById("risk_measure").innerHTML= retObj.riskInfoMap.risk_measure != undefined ? retObj.riskInfoMap.risk_measure:"";
		document.getElementById("influence_level").value= retObj.riskInfoMap.influence_level != undefined ? retObj.riskInfoMap.influence_level:"";
		document.getElementById("risk_probability").value= retObj.riskInfoMap.risk_probability != undefined ? retObj.riskInfoMap.risk_probability:"";
		
		risk_id_value = ids;
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath %>/risk/singleproject/riskIdentify/edit_risk_identify.jsp?pageAction=Add');		
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
		    var risk_flag = document.getElementById("is_risk_"+params[i]).value;
		    if(risk_flag == "1"){
		    	alert("有风险已确认，不能删除！");
		    	return;
		    }
	    }
	    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("riskSrv", "deleteRiskIdentify", "riskIdentifyId="+fileIds.substr(1));
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
	    
	    var risk_flag = document.getElementById("is_risk_"+ids).value;
	    if(risk_flag == "1"){
	    	alert("风险已确认，不能修改！");
	    	return;
	    }
	    
		popWindow('<%=contextPath %>/risk/singleproject/riskIdentify/edit_risk_identify.jsp?pageAction=Edit&riskIdentifyId='+ids);

	}
	
	function addMeasure(){
		if(risk_id_value == ""){
			alert("请先选中一条记录!")
			return;
		}else{
			location.href="<%=contextPath %>/risk/addRiskMeasure.srq?risk_identify_id="+risk_id_value+"&risk_measure_value="+document.getElementById("risk_measure").value;
		}
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
		    var risk_flag = document.getElementById("is_risk_"+params[i]).value;
		    if(risk_flag == "1"){
		    	alert("有风险已确认，不能再确认！");
		    	return;
		    }
	    }
		    
		if(confirm('确定是风险吗?')){  
			var retObj = jcdpCallService("riskSrv", "confirmRisk", "riskIdentifyId="+fileIds.substr(1));
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
		
		document.getElementById("risk_desc").innerHTML = "";
		
	}
</script>

</html>


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

			    <td>&nbsp;</td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{target_id}' id='rdo_entity_id_{target_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{target_name}">目标名称</td>
			      <td class="bt_info_even" exp="{risk_type_name}">风险类别</td>			      
			      <td class="bt_info_odd" exp="{risk_bear_level}">风险承受度</td>
			      <td class="bt_info_even" exp="{create_date}">创建时间</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">分解目标</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
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
					    <td class="inquire_item4">风险类别：</td>
					    <td class="inquire_form4" id="item0_0"><input type="text" id="risk_type_name" name="risk_type_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">目标名称：</td>
					    <td class="inquire_form4" id="item0_1"><input type="text" id="target_name" name="target_name" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item4">风险承受度:</td>
					    <td class="inquire_form4" id="item1_0"><input type="text" id="risk_bear_level" name="risk_bear_level" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">创建时间:</td>
					    <td class="inquire_form4" id="item1_1"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item4">目标描述：</td>
					    <td class="inquire_form4" id="item2_0">
					    	<textarea rows="4" cols="36" name="target_desc" id="target_desc" readonly="readonly"></textarea>
					    </td>
					    <td class="inquire_item4">&nbsp;</td>
					    <td class="inquire_form4">&nbsp;</td>
					  </tr>			    
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="targetbreak" id="targetbreak" frameborder="0" src="" marginheight="0" marginwidth="0" >
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
	cruConfig.queryOp = "getAllRiskTargets";
	var risk_id_value = "";
	var flag = '<%=flag%>';
	if(flag !=""&&flag =="success"){

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
		var retObj = jcdpCallService("riskSrv", "getRiskTargetInfo", "targetId="+ids);
		document.getElementById("targetbreak").src = "<%=contextPath%>/risk/singleproject/targetBreak/target_break_list.jsp?relationId="+ids;
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		document.getElementById("risk_type_name").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		document.getElementById("target_name").value = retObj.riskInfoMap.target_name != undefined ? retObj.riskInfoMap.target_name:"";
		document.getElementById("target_desc").innerHTML= retObj.riskInfoMap.target_desc != undefined ? retObj.riskInfoMap.target_desc:"";
		document.getElementById("create_date").value= retObj.riskInfoMap.create_date != undefined ? retObj.riskInfoMap.create_date:"";
		document.getElementById("risk_bear_level").value= retObj.riskInfoMap.risk_bear_level != undefined ? retObj.riskInfoMap.risk_bear_level:"";
		risk_id_value = ids;
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath %>/risk/singleproject/riskTarget/edit_risk_target.jsp?pageAction=Add');		
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
			var retObj = jcdpCallService("riskSrv", "deleteRiskTarget", "riskTargetId="+fileIds.substr(1));
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
	    
		popWindow('<%=contextPath %>/risk/singleproject/riskTarget/edit_risk_target.jsp?pageAction=Edit&riskTargetId='+ids);

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
		
		document.getElementById("target_desc").innerHTML = "";
		
	}
</script>

</html>


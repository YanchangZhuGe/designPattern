<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String nowDate = df.format(new Date());
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);

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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>选择风险库</title>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{risk_db_id}' id='rdo_entity_id_{risk_db_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 		      
			      <td class="bt_info_odd" exp="{risk_db_name}">风险名称</td>
			      <td class="bt_info_even" exp="{risk_type_name}">风险类别</td>
			      <td class="bt_info_odd" exp="{org_abbreviation}">涉及部门</td>
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
					  	<td class="inquire_item4">风险名称：</td>
					    <td class="inquire_form4" id="item0_0"><input type="text" id="risk_db_name" name="risk_db_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item4">风险类别：</td>
					    <td class="inquire_form4" id="item0_1"><input type="text" id="risk_type_name" name="risk_type_name" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item4">风险定义：</td>
					    <td class="inquire_form4" id="item1_0">
					    <textarea rows="4" cols="36" name="risk_db_definition" id="risk_db_definition" readonly="readonly"></textarea>
					    </td>
					    <td class="inquire_item4">风险表现：</td>
					    <td class="inquire_form4" id="item1_1">
					    <textarea rows="4" cols="36" name="risk_db_behave" id="risk_db_behave" readonly="readonly"></textarea>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item4">关键成因:</td>
					    <td class="inquire_form4" id="item2_0">
					    	<textarea rows="4" cols="36" name="risk_db_reason" id="risk_db_reason" readonly="readonly"></textarea>
					    </td>
					  	<td class="inquire_item4">&nbsp;</td>
					    <td class="inquire_form4" id="item2_1">&nbsp;</td>	
					  </tr>							    
					</table>
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
	cruConfig.queryOp = "getAllRiskBase";
	var risk_id_value = "";
	var risk_name_value = "";
	var risk_type_value = "";
	var risk_definition = "";
	var risk_type_id = "";
	
	refreshData();

	function refreshData(){
		cruConfig.submitStr = "";	
		queryData(1);
	}
	
	function loadDataDetail(ids){
		var retObj = jcdpCallService("riskSrv", "getRiskBaseInfo", "riskBaseId="+ids);
		
		document.getElementById("risk_db_name").value= retObj.riskInfoMap.risk_db_name != undefined ? retObj.riskInfoMap.risk_db_name:"";
		document.getElementById("risk_type_name").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";

		document.getElementById("risk_db_definition").innerHTML= retObj.riskInfoMap.risk_db_definition != undefined ? retObj.riskInfoMap.risk_db_definition:"";
		document.getElementById("risk_db_behave").innerHTML= retObj.riskInfoMap.risk_db_behave != undefined ? retObj.riskInfoMap.risk_db_behave:"";
		document.getElementById("risk_db_reason").innerHTML= retObj.riskInfoMap.risk_db_reason != undefined ? retObj.riskInfoMap.risk_db_reason:"";
		
		risk_id_value = ids;
		risk_name_value = retObj.riskInfoMap.risk_db_name != undefined ? retObj.riskInfoMap.risk_db_name:"";
		risk_type_value = retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		risk_definition = retObj.riskInfoMap.risk_db_definition != undefined ? retObj.riskInfoMap.risk_db_definition:"";
		risk_type_id = retObj.riskInfoMap.risk_type_id != undefined ? retObj.riskInfoMap.risk_type_id:"";
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function dbclickRow(ids){
		loadDataDetail(ids)
		top.dialogCallback('setRiskBase',[risk_id_value, risk_name_value,risk_type_value,risk_definition,risk_type_id]);
		newClose();		
	}
	
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
			}
		}
		
	}
</script>

</html>


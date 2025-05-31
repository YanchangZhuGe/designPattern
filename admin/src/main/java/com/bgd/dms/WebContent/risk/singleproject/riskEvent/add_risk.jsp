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
	String projectNo = user.getProjectInfoNo();
	String relation_id = request.getParameter("relationId").toString();
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
<title>选择风险</title>
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
			    <auth:ListButton functionId="" css="tj" event="onclick='selectRisks()'" title="JCDP_btn_selectRisk"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{risk_identify_id}:{risk_name}' id='rdo_entity_id_{risk_identify_id}' onclick=doCheck(this)/>" >选择</td>
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
					    <td class="inquire_item6">风险类别：</td>
					    <td class="inquire_form6" id="item0_0"><input type="text" id="risk_type" name="risk_type" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">风险名称：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="risk_name" name="risk_name" class="input_width" readonly="readonly"/></td>
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
					  	<td class="inquire_item6">风险描述：</td>
					    <td class="inquire_form6" id="item0_7">
					    	<textarea rows="3" cols="" name="risk_desc" id="risk_desc" readonly="readonly"></textarea>
					    </td>	
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
					    <textarea rows="4" cols="50" id="risk_measure" name="risk_measure" readonly="readonly"></textarea>
					    </td>
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
	cruConfig.queryOp = "getAllRiskIdentifyOfEvent";
	
	refreshData();

	function refreshData(){
		cruConfig.submitStr = "riskConfirm=1&relationId=<%=relation_id%>";	
		queryData(1);
	}
	
	function loadDataDetail(ids){
		var risk_identify_id = ids.split(":")[0];
		var retObj = jcdpCallService("riskSrv", "getRiskIdenfityInfo", "riskIdentifyID="+risk_identify_id);		
		document.getElementById("risk_name").value= retObj.riskInfoMap.risk_db_name != undefined ? retObj.riskInfoMap.risk_db_name:"";
		document.getElementById("risk_level").value = retObj.riskInfoMap.risk_level != undefined ? retObj.riskInfoMap.risk_level:"";
		document.getElementById("risk_type").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		document.getElementById("create_date").value= retObj.riskInfoMap.create_date != undefined ? retObj.riskInfoMap.create_date:"";
		document.getElementById("creator_name").value= retObj.riskInfoMap.creator_name != undefined ? retObj.riskInfoMap.creator_name:"";
		document.getElementById("risk_desc").innerHTML= retObj.riskInfoMap.risk_desc != undefined ? retObj.riskInfoMap.risk_desc:"";
		document.getElementById("risk_number").value= retObj.riskInfoMap.risk_number != undefined ? retObj.riskInfoMap.risk_number:"";
		document.getElementById("risk_bear_level").value= retObj.riskInfoMap.risk_bear_level != undefined ? retObj.riskInfoMap.risk_bear_level:"";
		document.getElementById("risk_measure").innerHTML= retObj.riskInfoMap.risk_measure != undefined ? retObj.riskInfoMap.risk_measure:"";
		
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function selectRisks(){
		var riskIds = "";
		var riskNames = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    var params = ids.split(',');    
	    for(var i=0;i<params.length;i++){
	    	riskIds = riskIds+","+params[i].split(":")[0];
	    }
	    var retObj = jcdpCallService("riskSrv", "addEventRisks","riskIds="+riskIds.substr(1)+"&eventId=<%=relation_id%>");
	    var ctt = top.frames('list');
	    ctt.frames["risks"].location.reload();
	    newClose();
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
			var retObj = jcdpCallService("riskSrv", "deleteRiskDeal", "riskDealId="+fileIds.substr(1));
			queryData(cruConfig.currentPage);
		}
	}
	
</script>

</html>


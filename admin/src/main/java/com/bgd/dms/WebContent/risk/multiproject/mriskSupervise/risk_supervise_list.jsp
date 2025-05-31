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
<title>风险监控列表</title>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{supervise_id}' id='rdo_entity_id_{supervise_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 		      
			      <td class="bt_info_odd" exp="{risk_type_name}">风险类别</td>
			      <td class="bt_info_even" exp="{second_risk_type}">二级风险</td>
			      <td class="bt_info_odd" exp="{risk_norm}" func="substr,0,5">风险指标</td>
			      <td class="bt_info_even" exp="{the_use_area}">应用层面</td>
			      <td class="bt_info_odd" exp="{the_report_rate}">上报频率</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">分类码</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
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
					    <td class="inquire_form6" id="item0_0"><input type="text" id="risk_type_name" name="risk_type_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">二级分类：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="second_risk_type" name="second_risk_type" class="input_width" readonly="readonly"/></td>
					  	<td class="inquire_item6">上报频率：</td>
					    <td class="inquire_form6" id="item0_2"><input type="text" id="the_report_rate" name="the_report_rate" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">应用层面：</td>
					    <td class="inquire_form6" id="item1_0"><input type="text" id="the_use_area" name="the_use_area" class="input_width" readonly="readonly"/></td>	
					  	<td class="inquire_item6">数据途径：</td>
					    <td class="inquire_form6" id="item1_1"><input type="text" id="data_way" name="data_way" class="input_width" readonly="readonly"/></td>	
					    <td class="inquire_item6">数据来源负责单位:</td>
					    <td class="inquire_form6" id="item1_2"><input type="text" id="res_org_name" name="res_org_name" class="input_width" readonly="readonly"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">数据负责人：</td>
					    <td class="inquire_form6" id="item2_0"><input type="text" name="res_person_name" id="res_person_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">风险指标：</td>
					    <td class="inquire_form4" id="item2_1">
					    <textarea rows="4" cols="30" name="risk_norm" id="risk_norm" readonly="readonly"></textarea>
					    </td>
					    <td class="inquire_item6">需提供的数据指标：</td>
					    <td class="inquire_form6" id="item2_2">
					    <textarea rows="4" cols="30" name="provide_data_norm" id="provide_data_norm" readonly="readonly"></textarea>
					    </td>
					  </tr>	
					  <tr>
					  	<td class="inquire_item6">备注：</td>
					    <td class="inquire_form6" id="item3_0">
					    <textarea rows="4" cols="30" name="remark" id="remark" readonly="readonly"></textarea>
					    </td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6" id="item3_1">&nbsp;</td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6" id="item3_2">&nbsp;</td>
					  </tr>							    
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>	
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
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
	cruConfig.queryOp = "getAllRiskSupervise";
	var risk_id_value = "";
	
	refreshData();

	function refreshData(){
		cruConfig.submitStr = "";	
		queryData(1);
	}
	
	function loadDataDetail(ids){
		var retObj = jcdpCallService("riskSrv", "getRiskSuperviseInfo", "riskSuperviseId="+ids);
		document.getElementById("attachement").src = "<%=contextPath%>/doc/multiproject/common_doc_list_eps.jsp?relationId="+ids;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=9&relationId="+ids;
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		
		document.getElementById("risk_type_name").value= retObj.riskInfoMap.risk_type_name != undefined ? retObj.riskInfoMap.risk_type_name:"";
		document.getElementById("second_risk_type").value= retObj.riskInfoMap.second_risk_type != undefined ? retObj.riskInfoMap.second_risk_type:"";		
		document.getElementById("the_report_rate").value= retObj.riskInfoMap.the_report_rate != undefined ? retObj.riskInfoMap.the_report_rate:"";

		document.getElementById("the_use_area").value= retObj.riskInfoMap.the_use_area != undefined ? retObj.riskInfoMap.the_use_area:"";
		document.getElementById("data_way").value= retObj.riskInfoMap.data_way != undefined ? retObj.riskInfoMap.data_way:"";
		document.getElementById("res_org_name").value= retObj.riskInfoMap.res_org_name != undefined ? retObj.riskInfoMap.res_org_name:"";		
		document.getElementById("res_person_name").value= retObj.riskInfoMap.res_person_name != undefined ? retObj.riskInfoMap.res_person_name:"";
		
		document.getElementById("risk_norm").innerHTML= retObj.riskInfoMap.risk_norm != undefined ? retObj.riskInfoMap.risk_norm:"";
		document.getElementById("provide_data_norm").innerHTML= retObj.riskInfoMap.provide_data_norm != undefined ? retObj.riskInfoMap.provide_data_norm:"";
		document.getElementById("remark").innerHTML= retObj.riskInfoMap.remark != undefined ? retObj.riskInfoMap.remark:"";
		
		risk_id_value = ids;
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath %>/risk/multiproject/mriskSupervise/edit_risk_supervise.jsp?pageAction=Add');		
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
			var retObj = jcdpCallService("riskSrv", "deleteRiskSupervise", "riskSuperviseIds="+fileIds.substr(1));
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
	    
		popWindow('<%=contextPath %>/risk/multiproject/mriskSupervise/edit_risk_supervise.jsp?pageAction=Edit&riskSuperviseId='+ids);
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
		
		document.getElementById("risk_norm").innerHTML = "";
		document.getElementById("provide_data_norm").innerHTML = "";
		document.getElementById("remark").innerHTML = "";
		
	}
</script>

</html>


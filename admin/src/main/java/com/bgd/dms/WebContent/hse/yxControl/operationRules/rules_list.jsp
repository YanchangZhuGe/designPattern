<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String org_name = user.getOrgName();
	String org_subjection_id = user.getOrgSubjectionId();
	if(org_subjection_id == null){
		org_subjection_id = "";
	}
	Date date = new Date();
	int year = date.getYear()+1900;
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/yxControl/operationRules/rules.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<style type="text/css">
#new_table_box {
	width:1280px;
	height:640px;
}
#new_table_box_content {
	width:1260px;
	height:660px;
	border:1px #999 solid;
	background:#fff;
	padding:10px;
}
#new_table_box_bg {
	width:1240px;
	height:600px;
	border:1px #aebccb solid;
	background:#f1f2f3;
	padding:10px;
	overflow:auto;
}
</style>
<title>无标题文档</title>
</head>
<body style="background:#fff"  onload="refreshData();">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
	    	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr >
			      	<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{rules_id}' />" >选择</td>
			     	<td class="bt_info_even" autoOrder="1">序号</td> 
			      	<td class="bt_info_odd" exp="{second_name}">单位</td>
			      	<td class="bt_info_even" exp="{third_name}">基层单位</td>
			      	<td class="bt_info_odd" exp="{rules_analy_date}">工作安全分析日期</td>
			      	<td class="bt_info_even" exp="{rules_check_date}">工作循环检查日期</td>
			    </tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">工作安全分析表</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作循环检查评估表</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">工作循环检查历史记录表</a></li>
		    </ul>
		</div>
		<div id="tab_box" class="tab_box">
			<input type="hidden" id="rules_id" name="rules_id" value=""></input>
			<div id="tab_box_content0" class="tab_box_content">
				<table id=""  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 10px;" >
					<tr>
						<td colspan="6" align="center"><font size="5"><strong >工作安全分析表</strong></font></td>
					</tr>
					<tr>
						<td colspan="1" align="right"><strong >记录编号：</strong></td>
					   	<td colspan="3"><input type="text" id="analysis_code" name="analysis_code" class="input_width" value=""/></td>
						<td align="right"><strong >日期</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td align="left"><input type="text" id="analysis_date" name="analysis_date" class="input_width"   value="<%=now %>" readonly="readonly"/>
	      				&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" name="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(analysis_date,tributton1);" />&nbsp;</td>
					</tr>
					<tr>
						<td align="center"><strong >部门</strong></td>
						<td align="center"><strong >工作任务简述</strong></td>
						<td rowspan="2" align="center">
							<div><input type="checkbox" name="analysis_type" value="1"/><strong >新的工作任务</strong></div>
							<div><input type="checkbox" name="analysis_type" value="2"/><strong >已做过的工作任务</strong></div></td>
						<td align="center" ><strong >分析人员</strong></td>
						<td align="center"><strong >许可证</strong></td>
						<td align="center"><strong >特种作业人员是否有资质证明</strong></td>
					</tr>
					<tr>
						<td align="center"><input type="text" id="analysis_depart" name="analysis_depart" value="" class="input_width"/></td>
						<td align="center"><input type="text" id="analysis_describe" name="analysis_describe" value="" class="input_width"/></td>
						<td align="center"><input type="text" id="analysis_employee" name="analysis_employee" value="" class="input_width"/></td>
						<td align="center"><input type="text" id="analysis_licence" name="analysis_licence" value="" class="input_width"/></td>
						<td align="center"><input type="text" id="analysis_task" name="analysis_task" value="" class="input_width"/></td>
					</tr>
				</table>
				<table id="analysis"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 0px;" >
					<tr>
						<td rowspan="2" align="center"><font color="red">*</font><strong >工作步骤</strong></td>
						<td rowspan="2" align="center"><strong >危害描述</strong></td>
						<td rowspan="2" align="center"><strong >后果及影响人员</strong></td>
						<td rowspan="2" align="center"><strong >现有的控制措施</strong></td>
						<td colspan="3" align="center"><strong >风险评价</strong></td>
						<td rowspan="2" align="center"><strong >建议改进措施</strong></td>
						<td rowspan="2" align="center"><div><strong >控制后风险等级、</strong></div>
							<div><strong >及是否可接受</strong></div></td>
						<td rowspan="2" align="center"><span class='zj'><a href='#' onclick='addAnalysis()' title='新增'></a></span></td>
						<%-- <auth:ListButton functionId="" css="zj" event="onclick=addAnalysis('')" title="JCDP_btn_add"></auth:ListButton> --%>
					</tr>
					<tr>
						<td align="center"><strong >可能性</strong></td>
						<td align="center"><strong >严重度</strong></td>
						<td align="center"><strong >风险值</strong></td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content">
				<table id="evaluate"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 10px;" >
					<tr>
						<td colspan="6" align="center"><font size="5"><strong >工作循环检查评估表</strong></font></td>
					</tr>
					<tr>
						<td align="right"><strong >操作程序名称：</strong></td>
					   	<td align="left"><input type="text" id="evaluate_name" name="evaluate_name" class="input_width" value=""/></td>
						<td align="right"><strong >班组长：</strong></td>
						<td align="left"><input type="text" id="evaluate_class" name="evaluate_class" class="input_width" value=""/></td>
						<td align="right"><strong >操作人员:</strong></td>
						<td align="left"><input type="text" id="evaluate_opearater" name="evaluate_opearater" class="input_width" value=""/></td>
					</tr>
					<tr>
						<td align="right"><strong >沟通交流时间：</strong></td>
						<td colspan="5"><input type="text" id="evaluate_discuss" name="evaluate_discuss" class="input_width" value=""/></td>
					</tr>
					<tr>
						<td colspan="3" align="center"><strong >沟通交流内容</strong></td>
						<td colspan="3" align="center"><strong >详细说明</strong></td>
					</tr>
					<tr>
						<td colspan="3" align="center"><strong >防护设备：  
						足够<input type="checkbox" name="evaluate_defend" value="1"/>&nbsp;&nbsp;&nbsp;&nbsp;不足<input type="checkbox" name="evaluate_defend" value="2"/>
						&nbsp;&nbsp;&nbsp;&nbsp;完好<input type="checkbox" name="evaluate_defend" value="3"/>&nbsp;&nbsp;&nbsp;&nbsp;有缺陷<input type="checkbox" name="evaluate_defend" value="4"/></strong></td>
						<td colspan="3" align="center"><input type="text" id="defend_describe" name="defend_describe" value="" class="input_width"/></td>
					</tr>
					<tr>
						<td colspan="3" align="center"><strong >工具获得：  容易<input type="checkbox" name="evaluate_get" value="1"/>	
							&nbsp;&nbsp;&nbsp;&nbsp;不易<input type="checkbox" name="evaluate_get" value="2"/></strong></td>
						<td colspan="3" align="center"><input type="text" id="get_describe" name="get_describe" value="" class="input_width"/></td>
					</tr>
					<tr>
						<td colspan="3" align="center"><strong >工具适用性：适用<input type="checkbox" name="evaluate_suit" value="1"/>	
							&nbsp;&nbsp;&nbsp;&nbsp;不适用<input type="checkbox" name="evaluate_suit" value="2"/></strong></td>
						<td colspan="3" align="center"><input type="text" id="suit_describe" name="suit_describe" value="" class="input_width"/></td>
					</tr>
					<tr>
						<td colspan="3" align="center"><strong >安全要求：  知道<input type="checkbox" name="evaluate_ask" value="1"/>	
							&nbsp;&nbsp;&nbsp;&nbsp;不知道<input type="checkbox" name="evaluate_ask" value="2"/></strong></td>
						<td colspan="3" align="center"><input type="text" id="ask_describe" name="ask_describe" value="" class="input_width"/></td>
					</tr>
					<tr>
						<td colspan="3" align="center"><strong >操作程序：  适用<input type="checkbox" name="operation" value="1"/>	
							&nbsp;&nbsp;&nbsp;&nbsp;不适用<input type="checkbox" name="operation" value="2"/></strong></td>
						<td colspan="3" align="center"><input type="text" id="operation_describe" name="operation_describe" value="" class="input_width"/></td>
					</tr>
					<tr>
						<td align="right"><strong >建议：</strong></td>
						<td colspan="5"><input type="text" id="evaluate_suggestion" name="evaluate_suggestion" class="input_width" value=""/></td>
					</tr>
					<tr>
						<td align="right"><strong >现场评估时间：</strong></td>
						<td colspan="5"><input type="text" id="evaluate_present" name="evaluate_present" class="input_width" value=""/></td>
					</tr>
				</table>
				<table id="evaluate1"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 0px;" >
					<tr>
						<td align="center"><strong >序号</strong></td>
						<td align="center"><strong ><font color="red">*</font>操作步骤</strong></td>
						<td align="center"><strong >偏差关键点</strong></td>
						<td align="center"><strong >程序缺陷与潜在风险</strong></td>
						<auth:ListButton functionId="" css="zj" event="onclick=addEvaluate1('')" title="JCDP_btn_add"></auth:ListButton> 
					</tr>
				</table>
				<table id="evaluate2"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 0px;" >
					<tr>
						<td colspan="7" align="center"><font size="5"><strong >修订建议</strong></font></td>
					</tr>
					<tr>
						<td align="center"><strong >序号</strong></td>
						<td colspan="4" align="center"><font color="red">*</font><strong >建议内容</strong></td>
						<td align="center"><strong >提出人</strong></td>
						<auth:ListButton functionId="" css="zj" event="onclick=addEvaluate2('')" title="JCDP_btn_add"></auth:ListButton> 
					</tr>
					<tr>
						<td align="right"><strong >填写人：</strong></td>
					   	<td align="left"><input type="text" id="evaluate_fill" name="evaluate_fill" class="input_width" value="<%=org_name%>"/></td>
						<td align="right"><strong >审核人：</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td align="left"><input type="text" id="evaluate_audit" name="evaluate_audit" class="input_width" value=""/></td>
						<td align="right"><strong >日期：</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td colspan="2" align="left"><input type="text" id="evaluate_date" name="evaluate_date" class="input_width" value="<%=now %>" readonly="readonly" />
						&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" name="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(evaluate_date,tributton2);" />&nbsp;</td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content2" class="tab_box_content">
				<table id="history"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 0px;" >
					<tr>
						<td colspan="7" align="center"><font size="5"><strong >工作循环检查历史记录表</strong></font></td>
					</tr>
					<tr>
						<td align="center"><strong >序号</strong></td>
						<td align="center"><strong ><font color="red">*</font>操作人员</strong></td>
						<td align="center"><strong >验证的操作程序</strong></td>
						<td align="center"><strong >执行日期</strong></td>
						<td align="center"><strong >执行情况</strong></td>
						<td align="center"><strong >备注</strong></td>
						<auth:ListButton functionId="" css="zj" event="onclick=addHistory('')" title="JCDP_btn_add"></auth:ListButton> 
					</tr>
					<tr>
						<td colspan="2" align="right"><strong >班组长：</strong></td>
					   	<td colspan="3" align="left"><input type="text" id="history_class" name="history_class" class="input_width" value="<%=org_name%>"/></td>
						<!-- <td align="right"><strong >日期：</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td> -->
						<td colspan="2" align="left"><input type="text" id="history_date" name="history_date" class="input_width" value="<%=now %>" readonly="readonly"/>
						&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" name="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(history_date,tributton3);" />&nbsp;</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
<script type="text/javascript">
function frameSize(){
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);


cruConfig.contextPath =  "<%=contextPath%>";
var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
		
	}
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			retObj = jcdpCallService("HseSrv", "queryOrg", "");
			if(retObj.flag!="false"){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag!="0"){
						querySqlAdd = " and t.second_org = '" + retObj.list[0].orgSubId +"'";
						if(len>1){
							if(retObj.list[1].organFlag!="0"){
								querySqlAdd = " and t.third_org = '" + retObj.list[1].orgSubId +"'";
							}
						}
					}
				}
			}
		}else if(isProject=="2"){
			querySqlAdd = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.rules_id ,t.second_org ,inf1.org_abbreviation second_name ,"+
		" t.third_org ,inf2.org_abbreviation third_name ,t.rules_analy_date ,t.rules_check_date " +
		" from bgp_hse_operation_rules t"+
		" join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id and sub1.bsflag='0'"+
		" join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag='0'"+
		" join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag='0'" +
		" join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag='0'"+
		<%-- " where t.bsflag ='0' and t.second_org like'<%=org_subjection_id%>%' "+ --%>
		" where t.bsflag ='0' "+querySqlAdd+" order by t.second_org desc";
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/yxControl/operationRules/rules_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/yxControl/operationRules/rules_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chk_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}
	
	function clearTable(){
		var obj = document.getElementById("analysis");
		for(var i=obj.rows.length-1;i>=2 ;i--){
			obj.deleteRow(i);
		}
		obj = document.getElementById("evaluate1");
		for(var i=obj.rows.length-1;i>=1 ;i--){
			obj.deleteRow(i);
		}
		obj = document.getElementById("evaluate2");
		for(var i=obj.rows.length-2;i>=2 ;i--){
			obj.deleteRow(i);
		}
		obj = document.getElementById("history");
		for(var i=obj.rows.length-2;i>=2 ;i--){
			obj.deleteRow(i);
		}
	}
	var rowIndex = 0;
	
	
	function loadDataDetail(shuaId){
		document.getElementById("rules_id").value =shuaId;
		var rules_id = document.getElementById("rules_id").value;
		var retObj = jcdpCallService("HseOperationSrv", "getOperationRules", "rules_id="+rules_id);
		if(retObj.returnCode =='0'){
			if(retObj.data!=null){
				var map = retObj.data;
				document.getElementById("rules_id").value =rules_id;
				document.getElementById("analysis_code").value =map.analysis_code;
				document.getElementById("analysis_date").value =map.analysis_date;
				document.getElementById("analysis_depart").value =map.analysis_depart;
				document.getElementById("analysis_describe").value =map.analysis_describe;
				var analysis_type = map.analysis_type;
				var obj = document.getElementsByName("analysis_type");
				for(var i =0;analysis_type!=null && analysis_type!=''&&i<obj.length;i++){
					var value = obj[i].value;
					if(analysis_type.indexOf(value)!=-1){
						obj[i].checked = true;
					}
				}
				document.getElementById("analysis_employee").value = map.analysis_employee;
				document.getElementById("analysis_licence").value =map.analysis_licence;
				document.getElementById("analysis_task").value =map.analysis_task;
				document.getElementById("evaluate_name").value =map.evaluate_name;
				document.getElementById("evaluate_class").value =map.evaluate_class;
				document.getElementById("evaluate_opearater").value =map.evaluate_opearater;
				document.getElementById("evaluate_discuss").value = map.evaluate_discuss;
				var evaluate_defend = map.evaluate_defend;
				var obj = document.getElementsByName("evaluate_defend");
				for(var i =0;evaluate_defend!=null && evaluate_defend!=''&&i<obj.length;i++){
					var value = obj[i].value;
					if(evaluate_defend.indexOf(value)!=-1){
						obj[i].checked = true;
					}
				}
				document.getElementById("defend_describe").value = map.defend_describe;
				var evaluate_get = map.evaluate_get;
				var obj = document.getElementsByName("evaluate_get");
				for(var i =0;evaluate_get!=null && evaluate_get!=''&&i<obj.length;i++){
					var value = obj[i].value;
					if(evaluate_get.indexOf(value)!=-1){
						obj[i].checked = true;
					}
				}
				document.getElementById("get_describe").value =map.get_describe;
				var evaluate_suit = map.evaluate_suit;
				var obj = document.getElementsByName("evaluate_suit");
				for(var i =0;evaluate_suit!=null && evaluate_suit!=''&&i<obj.length;i++){
					var value = obj[i].value;
					if(evaluate_suit.indexOf(value)!=-1){
						obj[i].checked = true;
					}
				}
				document.getElementById("suit_describe").value =map.suit_describe;
				var evaluate_ask = map.evaluate_ask;
				var obj = document.getElementsByName("evaluate_ask");
				for(var i =0;evaluate_ask!=null && evaluate_ask!=''&&i<obj.length;i++){
					var value = obj[i].value;
					if(evaluate_ask.indexOf(value)!=-1){
						obj[i].checked = true;
					}
				}
				document.getElementById("ask_describe").value =map.ask_describe;
				var operation = map.operation;
				var obj = document.getElementsByName("operation");
				for(var i =0;operation!=null && operation!=''&&i<obj.length;i++){
					var value = obj[i].value;
					if(operation.indexOf(value)!=-1){
						obj[i].checked = true;
					}
				}
				document.getElementById("evaluate_suggestion").value =map.evaluate_suggestion;
				document.getElementById("evaluate_present").value = map.evaluate_present;
				document.getElementById("evaluate_fill").value = map.evaluate_fill;
				document.getElementById("evaluate_audit").value =map.evaluate_audit;
				document.getElementById("evaluate_date").value =map.evaluate_date;
				document.getElementById("history_class").value =map.history_class;
				document.getElementById("history_date").value =map.history_date;
			}
		}
		retObj = jcdpCallService("HseOperationSrv", "getTablesList", "rules_id="+rules_id);
		if(retObj.returnCode =='0'){
			clearTable();
			if(retObj.analysisList!=null){
				var list = retObj.analysisList;
				loadAnalysis(list);
			}
			if(retObj.evaluate1List!=null){
				var list = retObj.evaluate1List;
				loadEvaluate1(list);
			}
			if(retObj.evaluate2List!=null){
				var list = retObj.evaluate2List;
				loadEvaluate2(list);
			}
			if(retObj.historyList!=null){
				var list = retObj.historyList;
				loadHistory(list);
			}
		}
	}
	function toAdd(){
		var obj = new Object();
		window.showModalDialog('<%=contextPath%>/hse/yxControl/operationRules/rules_add.jsp?isProject=<%=isProject%>',
				obj,'dialogWidth=1280px;dialogHeight=768px');
		refreshData();
	}
	
	function toEdit(){  
		var rules_id = document.getElementById("rules_id").value;
	  	if(rules_id==''|| rules_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	var obj = new Object();
		window.showModalDialog('<%=contextPath%>/hse/yxControl/operationRules/rules_add.jsp?isProject=<%=isProject%>&rules_id='+rules_id,
				obj,'dialogWidth=1280px;dialogHeight=768px');
	  	
	} 
	
	function toUpdate(){  
		var form = document.getElementById("form");
		if(checkText0()){
			return;
		}
		var rules_id = document.getElementById("rules_id").value;	
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var duty_year=document.getElementById("duty_year").value;
		var task=document.getElementById("task").value;
		var duty_module=document.getElementById("duty_module").value;
		var master_num=document.getElementById("master_num").value;
		var employee_num=document.getElementById("employee_num").value;
		var substr = 'second_org='+second_org+'&third_org='+third_org +
		'&fourth_org='+fourth_org+'&duty_year='+duty_year+'&task='+task +
		'&duty_module='+duty_module+'&master_num='+master_num+'&employee_num='+employee_num;
		if(rules_id!=null && rules_id!=''){
			substr = substr +'&rules_id='+rules_id;
		}
		var obj = jcdpCallService("HseOperationSrv", "saveDutyBook", substr);
		if(obj.returnCode =='0'){
			alert("保存成功!");
			refreshData();
		}
		
	} 
	
	function toDelete(){
 		var substr ="";
	    if(window.confirm('确定要删除吗?')){
	    	var id = document.getElementsByName("chk_entity_id");
			for(var i =0 ;i<id.length ;i++){
				if(id[i].checked == true){
					substr =substr + "update bgp_hse_operation_rules t set t.bsflag ='1' where rules_id ='"+id[i].value+"';";
				}
			} 
			var retObj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+substr); 
			refreshData();
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/yxControl/operationRules/rules_search.jsp");
	}
	
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
	
	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
				}
	   
	}
	
	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
	    if(teamInfo.fkValue!=""){
	    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
	        document.getElementById("fourth_org2").value = teamInfo.value;
		}
	}
	/* 输入的是否是数字 */
	function checkIfNum(event){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			return false;
		}
	}
</script>
</body>
</html>


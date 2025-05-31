<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String org_name = user.getUserName();
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null ){
		project_info_no ="";
	}
	String user_id = user.getUserId();
	if(user_id==null ){
		user_id ="";
	}
	String rules_id = request.getParameter("rules_id");
	if(rules_id==null){
		rules_id = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
	
	String isProject = request.getParameter("isProject");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/yxControl/operationRules/rules.js"></script>
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
	height:520px;
	border:1px #aebccb solid;
	background:#f1f2f3;
	padding:10px;
	overflow:auto;
}
</style>
</head>
<body onload="queryOrg()">
<input type="hidden" id="rules_id" name="rules_id" value="<%=rules_id %>"/>
<input type="hidden" id="project_info_no" name="project_info_no" value="<%=project_info_no %>"/>
<input type="hidden" id="user_id" name="user_id" value="<%=user_id %>"/>
<div id="new_table_box">
	<div id="new_table_box_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 0px;">
			<tr>
				<td class="inquire_item8"><font color="red">*</font>单位：</td>
		      	<td class="inquire_form8">
			      	<input type="hidden" id="second_org" name="second_org" class="input_width" value="C105083"/>
			      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
		      		<%} %>
		      	</td>
		     	<td class="inquire_item8"><font color="red">*</font>基层单位：</td>
		      	<td class="inquire_form8">
			      	<input type="hidden" id="third_org" name="third_org" class="input_width" value="C105072"/>
			      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
		      		<%} %>
		      	</td>
		    	<td class="inquire_item8"><font color="red">*</font>工作安全分析日期：</td>
		      	<td class="inquire_form8"><input type="text" id="rules_analy_date" name="rules_analy_date" class="input_width" value="<%=now %>" readonly="readonly"/>
		      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rules_analy_date,tributton1);" />&nbsp;</td>
	    		 <td class="inquire_item8"><font color="red">*</font>工作循环检查日期：</td>
		      	<td class="inquire_form8"><input type="text" id="rules_check_date" name="rules_check_date" class="input_width" value="<%=now %>" readonly="readonly"/>
		      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rules_check_date,tributton2);" />&nbsp;</td>
		    </tr>
		</table>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">工作安全分析表</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作循环检查评估表</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">工作循环检查历史记录表</a></li>
		    </ul>
		</div>
    	<div id="new_table_box_bg">
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" >
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
				<div id="tab_box_content1"  style="display: none;">
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
				<div id="tab_box_content2" style="display: none;">
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
		<div id="oper_div">
			<span class="tj_btn"><a href="#" onclick="submitButton(<%=isProject%>)"></a></span>
			<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
		</div>
	</div>
</div> 
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
var project_info_no = document.getElementById("project_info_no").value;
var user_id = document.getElementById("user_id").value;
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8 || event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}

	function queryOrg(){
		var retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.returnCode =='0'){
			if(retObj.list!=null){
				var len = retObj.list.length;
				if(len>0){
					document.getElementById("second_org").value=retObj.list[0].orgSubId;
					document.getElementById("second_org2").value=retObj.list[0].orgAbbreviation;
				}
				if(len>1){
					document.getElementById("third_org").value=retObj.list[1].orgSubId;
					document.getElementById("third_org2").value=retObj.list[1].orgAbbreviation;
				}
			}
		}
		//loadDataDetail();
	}
	refreshData();
	loadDataDetail();
	function closeButton(){
		window.close();
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
	
</script>
</body>
</html>
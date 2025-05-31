<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(d);
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n+1; i >= 2002; i--) {
		listYear.add(i);
	}
	String hse_assess_id = request.getParameter("hse_assess_id");
 	String action = request.getParameter("action");   
 	String  project = request.getParameter("project");
	if(project==null||project.equals("")){
		project = resultMsg.getValue("project");
	}
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
</head>
<body  onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_assess_id" name="hse_assess_id" value=""/>
<input type="hidden" id="project" name="project" value="<%=project%>"/>
<input type="hidden" id="remark_id" name="remark_id" value=""/>
<div id="new_table_box" >
  <div id="new_table_box_content" >
    <div id="new_table_box_bg" >
			<table id="" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr style="height: 50px;">
					<td align="center" colspan="6"><span style="font-size: 28px;font-family: Arial;padding-top: 11px;margin-bottom: 30px;">东方公司HSE绩效考核表</span></td>
				</tr>
				<tr>
				     	<td class="inquire_item6">单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
				      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				      	<%} %>
				      	</td>
				     	<td class="inquire_item6">基层单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				      	<%} %>
				      	</td>
				      	<td class="inquire_item6">下属单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
				      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td>
				     </tr>
				     <tr>
				    	<td class="inquire_item6">考核期：</td>
				      	<td class="inquire_form6">
					      	<select id="year" name="year" class="select_width">
						       	<option value="" >请选择</option>
								<%for(int j=0;j<listYear.size();j++){%>
								<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
								<% } %>
							</select>年
				      	</td>
				     	<td class="inquire_item6">季度：</td>
				      	<td class="inquire_form6">
				      		<select id="quarter" name="quarter" class="select_width" onclick="selectQuarter()">
					          <option value="" >请选择</option>
					          <option value="1" >第一季度</option>
					          <option value="4" >第二季度</option>
					          <option value="7" >第三季度</option>
					          <option value="10">第四季度</option>
						    </select>
				      	</td>
				    	<td class="inquire_item6">月份：</td>
				      	<td class="inquire_form6">
					      	<select id="month" name="month" class="select_width"  onclick="selectMonth()">
						       	<option value="" >请选择</option>
								<%for(int j=1;j<13;j++){%>
								<option value="<%=j %>"><%=j %></option>
								<% } %>
							</select>
				      	</td>
				     </tr>
				<tr>
					<td class="inquire_item6">姓名：</td>
					<td class="inquire_form6"><input type="text" id="assess_name" name="assess_name" value="" class="input_width" ></input></td>
					<td class="inquire_item6">岗位：</td>
					<td class="inquire_form6"><input type="text" id="assess_post" name="assess_post" value="" class="input_width" ></input></td>
					<td class="inquire_item6"><font color="red">*</font>考核日期：</td>
				    <td class="inquire_form6"><input type="text" id="assess_date" name="assess_date" class="input_width" value="<%=today %>" readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(assess_date,tributton);" />&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6" align="center" >
						<div ><span>员工 为HSE绩效所做的贡献</span><span class="zj" style="float: right;padding-right: 10px;"><a href="#" onclick="toGood()" title="JCDP_btn_add"></a></span></div>
					</td>
				</tr>
				
				<tr>
					<td colspan="6">
						<table id="goodTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height">
						<input type="hidden" id="goodNum" name="goodNum" value="0"></input>
							<tr align="center">
								<td>删除</td>
								<td>序号</td>
								<td>业绩指标</td>
								<td>分值</td>
								<td>完成情况</td>
								<td>得分</td>
							</tr>
							<tr align="center">
								<td>合计</td>
								<td></td>
								<td></td>
								<td><input type="text" id="all_score" name="all_score" class="input_width"></input></td>
								<td></td>
								<td><input type="text" id="all_get" name="all_get" class="input_width"></input></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="6" align="center">
						<div ><span>员工处分等级对应的经济处罚</span><span class="zj" style="float: right;padding-right: 10px;"><a href="#" onclick="toBad()" title="JCDP_btn_add"></a></span></div>
					</td>
				</tr>
				<tr>
					<td colspan="6">
						<table id="badTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height">
						<input type="hidden" id="badNum" name="badNum" value="0"></input>
							<tr align="center">
								<td>删除</td>
								<td>序号</td>
								<td>违反规章制度的事实</td>
								<td>违章等级</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="6">
						<table id="" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height">
							<tr>
								<td class="inquire_item6">最终处理结果：</td>
								<td class="inquire_form6"><textarea id="result" name="result" ></textarea></td>
								<td class="inquire_item6">扣奖比例或金额：</td>
								<td class="inquire_form6"><input type="text" id="punish_money" name="punish_money" class="input_width" value=""></input></td>
							</tr>
							<tr>
								<td class="inquire_item6">员工：</td>
								<td class="inquire_form6"><input type="text" id="assess_sign" name="assess_sign" class="input_width"  value=""></input></td>
								<td class="inquire_item6">时间：</td>
								<td class="inquire_form6"><input type="text" id="sign_date" name="sign_date" class="input_width"   value="" readonly="readonly"/>
						      		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton1);" />&nbsp;
						      	</td>
							</tr>
							<tr>
								<td class="inquire_item6">主管：</td>
								<td class="inquire_form6"><input type="text" id="leader_sign" name="leader_sign" class="input_width" value=""></input></td>
								<td class="inquire_item6">时间：</td>
								<td class="inquire_form6"><input type="text" id="leader_date" name="leader_date" class="input_width"   value="" readonly="readonly"/>
						      		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(leader_date,tributton2);" />&nbsp;
						      	</td>
							</tr>
							<tr>
								<td class="inquire_item6">上级主管：</td>
								<td class="inquire_form6"><input type="text" id="superior_sign"  name="superior_sign" class="input_width" value=""></input></td>
								<td class="inquire_item6">时间：</td>
								<td class="inquire_form6"><input type="text" id="superior_date" name="superior_date" class="input_width"   value="" readonly="readonly"/>
						      		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(superior_date,tributton3);" />&nbsp;
						      	</td>
							</tr>
							<tr>
								<td class="inquire_item6">备注：</td>
								<td class="inquire_form6" colspan="3"><textarea id="memo" name="memo" class="textarea"></textarea></td>
							</tr>
							<tr>
								<td class="inquire_item6">员工意见：</td>
								<td class="inquire_form6" colspan="3"><textarea id="assess_suggest" name="assess_suggest" class="textarea"></textarea></td>
							</tr>
							<tr>
								<td class="inquire_item6">上级主管意见：</td>
								<td class="inquire_form6" colspan="3"><textarea id="superior_suggest" name="superior_suggest" class="textarea"></textarea></td>
							</tr>
						</table>
					</td>
				</tr>		
			</table>
		</div>
		<div id="oper_div">
			<span id="submitButt" class="bc_btn"><a href="#" onclick="submitButton()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

var hse_assess_id = "<%=hse_assess_id%>";
var action ="<%=action%>";

cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
	
}

toEdit();

if(action=="view"){
	document.getElementById("submitButt").style.display="none";
}


function submitButton(){
//	var model_name = document.getElementById("model_name").value;
//	if(model_name==""){
//		alert("模板名称不能为空，请填写！");
//		return;
//	}
	if(checkText()){
		return;
	}
	
	var form = document.getElementById("form");
	var good_ids = "";
	var bad_ids = "";
	var good_orders = document.getElementsByName("good_order");
	//算出添加的多少行，并且value值
	for(var i=0;i<good_orders.length;i++){
		good_order = good_orders[i].value;
		if(good_ids!="") good_ids += ",";
		good_ids = good_ids + good_order;
	}
	
	var bad_orders = document.getElementsByName("bad_order");
	//算出添加的多少行，并且value值
	for(var i=0;i<bad_orders.length;i++){
		bad_order = bad_orders[i].value;
		if(bad_ids!="") bad_ids += ",";
		bad_ids = bad_ids + bad_order;
	}
	form.action="<%=contextPath%>/hse/assess/addAssessContent.srq?good_ids="+good_ids+"&&bad_ids="+bad_ids;
	form.submit();
}


function toGood(hse_content_id,targer,score,complete_status,get_score){
	var content_id = "";
	var targ = "";
	var sco = "";
	var compl = "";
	var get = "";
	if(hse_content_id != null && hse_content_id != ""){
		content_id=hse_content_id;
	}
	if(targer != null && targer != ""){
		targ = targer;
	}
	if(score != null && score != ""){
		sco = score;
	}
	if(complete_status != null && complete_status != ""){
		compl = complete_status;
	}
	if(get_score != null && get_score != ""){
		get = get_score;
	}
	var rowNum = document.getElementById("goodNum").value;	
	
	var table=document.getElementById("goodTable");
	var lineId = "row_" + rowNum;
	
	var tr = table.insertRow(table.rows.length-1);
	tr.align="center";
	tr.id=lineId;
	var td = tr.insertCell(0);
	td.innerHTML = "<input type='hidden' id='hse_good_id"+rowNum+"' name='hse_good_id"+rowNum+"' value='"+content_id+"' /><input type='hidden' id='good_bsflag"+rowNum+"' name='good_bsflag"+rowNum+"' value='0'/><input type='hidden' name='good_order' value='"+rowNum+"'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
	
	td = tr.insertCell(1);
	td.innerHTML = (Number(rowNum)+1);
	
	td = tr.insertCell(2);
	td.innerHTML = "<textarea id='target"+rowNum+"' name='target"+rowNum+"' value=''>"+targ+"</textarea>";
	
	td = tr.insertCell(3);
	td.innerHTML = "<input type='text' id='score"+rowNum+"' name='score"+rowNum+"' class='input_width' value='"+sco+"' onchange='totalScore()'></input>";
	
	td = tr.insertCell(4);
	td.innerHTML = "<textarea id='complete_status"+rowNum+"' name='complete_status"+rowNum+"' value=''>"+compl+"</textarea>";
	
	td = tr.insertCell(5);
	td.innerHTML = "<input type='text' id='get_score"+rowNum+"' name='get_score"+rowNum+"'  class='input_width' value='"+get+"' onchange='totalGet()'></textarea>";
	
	document.getElementById("goodNum").value = parseInt(rowNum) + 1;
	
}


function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	//取删除行的主键ID
	var table=document.getElementById("goodTable");
	var lineNum = document.getElementById("goodNum").value;
	document.getElementById("goodNum").value = parseInt(lineNum) - 1;
	var line = document.getElementById(lineId);		
	debugger;
	if(action=="edit"){
		document.getElementById("good_bsflag"+rowNum).value="1";
		line.style.display="none";	
	}else{
		table.deleteRow(line.rowIndex);
	}
}

function totalScore(){
	var good_orders = document.getElementsByName("good_order");
	var total_score = 0;
	//算出添加的多少行，并且value值
	for(var i=0;i<good_orders.length;i++){
		good_order = good_orders[i].value;
		var score =	document.getElementById("score"+good_order).value;
		score = Number(score);
		total_score = total_score + score;
	}
	document.getElementById("all_score").value=total_score;
}

function totalGet(){
	var good_orders = document.getElementsByName("good_order");
	var total_get = 0;
	//算出添加的多少行，并且value值
	for(var i=0;i<good_orders.length;i++){
		good_order = good_orders[i].value;
		var get = document.getElementById("get_score"+good_order).value;
		get = Number(get);
		total_get = total_get + get;
	}
	document.getElementById("all_get").value=total_get;
}

function toBad(hse_content_id,break_rule,rule_level){
	var content_id = "";
	var breakRule = "";
	var level = "";
	if(hse_content_id != null && hse_content_id != ""){
		content_id=hse_content_id;
	}
	if(break_rule != null && break_rule != ""){
		breakRule = break_rule;
	}
	if(rule_level != null && rule_level != ""){
		level = rule_level;
	}
	var rowNum = document.getElementById("badNum").value;	
	
	var table=document.getElementById("badTable");
	var lineId2 = "row2_" + rowNum;
	
	var tr = table.insertRow(table.rows.length);
	tr.align="center";
	tr.id=lineId2;
	var td = tr.insertCell(0);
	td.innerHTML = "<input type='hidden' id='hse_bad_id"+rowNum+"' name='hse_bad_id"+rowNum+"' value='"+content_id+"' /><input type='hidden' id='bad_bsflag"+rowNum+"' name='bad_bsflag"+rowNum+"' value='0'/><input type='hidden' name='bad_order' value='"+rowNum+"'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine2(\""+lineId2+"\")'/>";
	
	td = tr.insertCell(1);
	td.innerHTML = (Number(rowNum)+1);
	
	td = tr.insertCell(2);
	td.innerHTML = "<textarea id='break_rule"+rowNum+"' name='break_rule"+rowNum+"' value=''>"+breakRule+"</textarea>";
	
	td = tr.insertCell(3);
	td.innerHTML = "<input type='text' id='rule_level"+rowNum+"' name='rule_level"+rowNum+"'  class='input_width' value='"+level+"'></input>";
	
	
	document.getElementById("badNum").value = parseInt(rowNum) + 1;
}


function deleteLine2(lineId){	
	var rowNum = lineId.split('_')[1];
	//取删除行的主键ID
	var table=document.getElementById("badTable");
	var lineNum = document.getElementById("badNum").value;
	document.getElementById("badNum").value = parseInt(lineNum) - 1;
	var line = document.getElementById(lineId);		
	if(action=="edit"){
		document.getElementById("bad_bsflag"+rowNum).value="1";
		line.style.display="none";	
	}else{
		table.deleteRow(line.rowIndex);
	}
}




function toEdit(){
	debugger;
/*	if(action=="add"){
		
		var checkSql="select am.hse_model_id id,am.model_name,am.result,am.punish_money,mc.* from bgp_hse_assess_model am left join bgp_hse_model_content mc on am.hse_model_id = mc.hse_model_id and mc.bsflag='0' left join p_auth_user au on am.creator_id = au.user_id and au.bsflag='0' where am.bsflag='0' and mc.type='1' and am.hse_model_id='"+hse_model_id+"' order by mc.order_num asc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
				
		}else{
			document.getElementById("result").value=datas[0].result;
			document.getElementById("punish_money").value=datas[0].punish_money;
	
			for (var i = 0; i<datas.length; i++) {
				if(datas[i].hse_content_id!=""&&datas[i].hse_content_id!=null){
				toGood(
						"",
						datas[i].target ? datas[i].target : "",
						datas[i].score ? datas[i].score : "",
						datas[i].complete_status ? datas[i].complete_status : "",
						datas[i].get_score ? datas[i].get_score : ""
					);
				}
			}
			totalScore();
			totalGet();
		}
		
		var checkSql2="select am.hse_model_id id,am.model_name,am.result,am.punish_money,mc.* from bgp_hse_assess_model am left join bgp_hse_model_content mc on am.hse_model_id = mc.hse_model_id and mc.bsflag='0' left join p_auth_user au on am.creator_id = au.user_id and au.bsflag='0' where am.bsflag='0' and mc.type='2' and am.hse_model_id='"+hse_model_id+"' order by mc.order_num asc";
	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
		var datas2 = queryRet2.datas;
		if(datas2==null||datas2==""){
			
		}else{
			for (var i = 0; i<datas2.length; i++) {	
				if(datas2[i].hse_content_id!=""&&datas2[i].hse_content_id!=null){
				toBad(
						"",
						datas2[i].break_rule ? datas2[i].break_rule : "",
						datas2[i].rule_level ? datas2[i].rule_level : ""
					);
				}
			}
		}
	}
*/	
	debugger;
	
	var checkSql="select ha.*,ee.employee_name,au.user_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_assess ha left join comm_org_subjection os1 on ha.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ha.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on ha.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join p_auth_user au on ha.creator_id=au.user_id and au.bsflag='0' where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ha.modifi_date desc";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas==null||datas==""){
		
	}else{
		document.getElementById("hse_assess_id").value = datas[0].hse_assess_id;
		document.getElementById("second_org").value = datas[0].second_org;
		document.getElementById("third_org").value = datas[0].third_org;
		document.getElementById("fourth_org").value = datas[0].fourth_org;
		document.getElementById("second_org2").value = datas[0].second_org_name;
		document.getElementById("third_org2").value = datas[0].third_org_name;
		document.getElementById("fourth_org2").value = datas[0].fourth_org_name;
		
		document.getElementById("year").value =	datas[0].year;
		if(datas[0].type=="1"){
			document.getElementById("quarter").value = datas[0].quarter_month;
			document.getElementById("month").value = "";
		}else if(datas[0].type=="2"){
			document.getElementById("month").value = datas[0].quarter_month;
			document.getElementById("quarter").value = "";
		}
		document.getElementById("assess_name").value = datas[0].assess_name;
		document.getElementById("assess_date").value = datas[0].assess_date;
	}
	
	var checkSql3="select ha.hse_assess_id id,ha.assess_name,ha.assess_post,ha.assess_date,ha.result,ha.punish_money,ha.assess_sign,ha.sign_date,ha.leader_sign,ha.leader_date,ha.superior_sign,ha.superior_date,ha.assess_suggest,ha.superior_suggest,cr.remark_id,cr.notes,ac.* from bgp_hse_assess ha left join bgp_hse_assess_content ac on ha.hse_assess_id=ac.hse_assess_id and ac.bsflag='0' and ac.type='1' left join bgp_comm_remark cr on ha.hse_assess_id = cr.foreign_key_id and cr.bsflag='0' where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ac.order_num asc";
    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
	var datas3 = queryRet3.datas;
	if(datas3==null||datas3==""){
			
	}else{
		document.getElementById("assess_post").value = datas3[0].assess_post;
		document.getElementById("result").value=datas3[0].result;
		document.getElementById("punish_money").value=datas3[0].punish_money;
		document.getElementById("assess_sign").value=datas3[0].assess_sign;
		document.getElementById("sign_date").value=datas3[0].sign_date;
		document.getElementById("leader_sign").value=datas3[0].leader_sign;
		document.getElementById("leader_date").value=datas3[0].leader_date;
		document.getElementById("superior_sign").value=datas3[0].superior_sign;
		document.getElementById("superior_date").value=datas3[0].superior_date;
		document.getElementById("remark_id").value=datas3[0].remark_id;
		document.getElementById("memo").value=datas3[0].notes;
		document.getElementById("assess_suggest").value=datas3[0].assess_suggest;
		document.getElementById("superior_suggest").value=datas3[0].superior_suggest;

		for (var i = 0; i<datas3.length; i++) {
			if(datas3[i].hse_content_id!=""&&datas3[i].hse_content_id!=null){
			toGood(
					datas3[i].hse_content_id ? datas3[i].hse_content_id : "",
					datas3[i].target ? datas3[i].target : "",
					datas3[i].score ? datas3[i].score : "",
					datas3[i].complete_status ? datas3[i].complete_status : "",
					datas3[i].get_score ? datas3[i].get_score : ""
				);
			}
		}
		totalScore();
		totalGet();
	}
	
	var checkSql4="select ha.hse_assess_id id,ee.employee_name,ha.assess_post,ha.assess_date,ha.result,ha.punish_money,ha.assess_sign,ha.sign_date,ha.leader_sign,ha.leader_date,ha.superior_sign,ha.superior_date,ha.assess_suggest,ha.superior_suggest,cr.remark_id,cr.notes,ac.* from bgp_hse_assess ha left join bgp_hse_assess_content ac on ha.hse_assess_id=ac.hse_assess_id and ac.bsflag='0'  and ac.type='2' left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join bgp_comm_remark cr on ha.hse_assess_id = cr.foreign_key_id and cr.bsflag='0' where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ac.order_num asc";
    var queryRet4 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql4);
	var datas4 = queryRet4.datas;
	if(datas4==null||datas4==""){
		
	}else{
		for (var i = 0; i<datas4.length; i++) {	
			if(datas4[i].hse_content_id!=""&&datas4[i].hse_content_id!=null){
			toBad(
					datas4[i].hse_content_id ? datas4[i].hse_content_id : "",
					datas4[i].break_rule ? datas4[i].break_rule : "",
					datas4[i].rule_level ? datas4[i].rule_level : ""
				);
			}
		}
	}
	
	
} 


function queryOrg(id){
	var org_subjection_id = "";
	if(id!=null&&id!=""){
		var checkSql="select e.employee_id,os.org_subjection_id from comm_human_employee e join comm_org_subjection os on e.org_id=os.org_id and os.bsflag='0' where e.bsflag='0' and e.employee_id='"+id+"'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;	
		if(datas!=null&&datas!=""){
			var org_subjection_id = datas[0].org_subjection_id;	
		}
	}
	retObj = jcdpCallService("HseSrv", "queryOrg", "org_subjection_id="+org_subjection_id);
	if(retObj.flag=="true"){
		var len = retObj.list.length;
		if(len>0){
			document.getElementById("second_org").value=retObj.list[0].orgSubId;
			document.getElementById("second_org2").value=retObj.list[0].orgAbbreviation;
		}
		if(len>1){
			document.getElementById("third_org").value=retObj.list[1].orgSubId;
			document.getElementById("third_org2").value=retObj.list[1].orgAbbreviation;
		}
		if(len>2){
			document.getElementById("fourth_org").value=retObj.list[2].orgSubId;
			document.getElementById("fourth_org2").value=retObj.list[2].orgAbbreviation;
		}
	}
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

function checkText(){
	var second_org2=document.getElementById("second_org2").value;
	var third_org2=document.getElementById("third_org2").value;
	var fourth_org2=document.getElementById("fourth_org2").value;
	var year = document.getElementById("year").value;
	var assess_name = document.getElementById("assess_name").value;
	var assess_date = document.getElementById("assess_date").value;

	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(fourth_org2==""){
		document.getElementById("fourth_org").value="";
	}
	if(year==""){
		alert("年度不能为空，请选择！");
		return true;
	}
	if(assess_name==""){
		alert("被考核人不能为空，请选择！");
		return true;
	}
	if(assess_date==""){
		alert("考核时间不能为空，请填写！");
		return true;
	}
	return false;
}

function selectQuarter(){
	 var month = document.getElementById("month").value;
	 if(month!=""){
		 alert("季度和月份只能选择其一");
	 }
}

function selectMonth(){
	 var quarter = document.getElementById("quarter").value;
	 if(quarter!=""){
		 alert("季度和月份只能选择其一");
	 }
}


</script>
</html>
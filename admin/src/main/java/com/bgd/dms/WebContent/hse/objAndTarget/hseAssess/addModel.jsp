<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	
	String hse_model_id = request.getParameter("hse_model_id");
	String action = request.getParameter("action");
 
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
<body >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_model_id" name="hse_model_id" value=""/>
<div id="new_table_box" >
  <div id="new_table_box_content" >
    <div id="new_table_box_bg" >
			<table id="" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr>
					<td class="inquire_item6"><font color="red">*</font>模板名称：</td>
					<td class="inquire_form6" colspan="3"><input type="text" id="model_name" name="model_name" value="" class="input_width"></input></td>
				</tr>
				<tr>
					<td colspan="4" align="center" >
						<div ><span>员工 为HSE绩效所做的贡献</span><div style=""><span class="zj" style="float: right;padding-right: 10px;"><a href="#" onclick="toGood()" title="JCDP_btn_add"></a></span></div></div>
					</td>
				</tr>
				
				<tr>
					<td colspan="4">
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
								<td><input type="text" id="all_score" name="all_score"></input></td>
								<td></td>
								<td><input type="text" id="all_get" name="all_get"></input></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<div ><span>员工处分等级对应的经济处罚</span><div style=""><span class="zj" style="float: right;padding-right: 10px;"><a href="#" onclick="toBad()" title="JCDP_btn_add"></a></span></div></div>
					</td>
				</tr>
				<tr>
					<td colspan="4">
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
					<td>最终处理结果：</td>
					<td><textarea id="result" name="result" ></textarea></td>
					<td>扣奖比例或金额：</td>
					<td><input type="text" id="punish_money" name="punish_money"></input></td>
				</tr>		
			</table>
		</div>
		<div id="oper_div">
			<span id="submitButt" class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

var hse_model_id = "<%=hse_model_id%>";
var action ="<%=action%>";

cruConfig.contextPath =  "<%=contextPath%>";

toEdit();

if(action=="view"){
	document.getElementById("submitButt").style.display="none";
}


function submitButton(){
	var model_name = document.getElementById("model_name").value;
	if(model_name==""){
		alert("模板名称不能为空，请填写！");
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
	form.action="<%=contextPath%>/hse/assess/addModel.srq?good_ids="+good_ids+"&&bad_ids="+bad_ids;
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
	td.innerHTML = "<input type='text' id='score"+rowNum+"' name='score"+rowNum+"' value='"+sco+"' onchange='totalScore()'></input>";
	
	td = tr.insertCell(4);
	td.innerHTML = "<textarea id='complete_status"+rowNum+"' name='complete_status"+rowNum+"' value=''>"+compl+"</textarea>";
	
	td = tr.insertCell(5);
	td.innerHTML = "<input type='text' id='get_score"+rowNum+"' name='get_score"+rowNum+"' value='"+get+"' onchange='totalGet()'></textarea>";
	
	document.getElementById("goodNum").value = parseInt(rowNum) + 1;
	
}


function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	//取删除行的主键ID
	var table=document.getElementById("goodTable");
	var lineNum = document.getElementById("goodNum").value;
	document.getElementById("goodNum").value = parseInt(lineNum) - 1;
	var line = document.getElementById(lineId);		
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
	td.innerHTML = "<input type='text' id='rule_level"+rowNum+"' name='rule_level"+rowNum+"' value='"+level+"'></input>";
	
	
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
	var checkSql="select am.hse_model_id id,am.model_name,am.result,am.punish_money,mc.* from bgp_hse_assess_model am left join bgp_hse_model_content mc on am.hse_model_id = mc.hse_model_id and mc.bsflag='0' left join p_auth_user au on am.creator_id = au.user_id and au.bsflag='0' where am.bsflag='0' and mc.type='1' and am.hse_model_id='"+hse_model_id+"' order by mc.order_num asc";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas==null||datas==""){
		action="add";	
	}else{
		document.getElementById("hse_model_id").value=datas[0].id;
		document.getElementById("model_name").value=datas[0].model_name;
		document.getElementById("result").value=datas[0].result;
		document.getElementById("punish_money").value=datas[0].punish_money;

		for (var i = 0; i<datas.length; i++) {
			if(datas[i].hse_content_id!=""&&datas[i].hse_content_id!=null){
			toGood(
					datas[i].hse_content_id ? datas[i].hse_content_id : "",
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
		action="add";	
	}else{
		for (var i = 0; i<datas2.length; i++) {	
			if(datas[i].hse_content_id!=""&&datas[i].hse_content_id!=null){
			toBad(
					datas2[i].hse_content_id ? datas2[i].hse_content_id : "",
					datas2[i].break_rule ? datas2[i].break_rule : "",
					datas2[i].rule_level ? datas2[i].rule_level : ""
				);
			}
		}
	}
} 

</script>
</html>
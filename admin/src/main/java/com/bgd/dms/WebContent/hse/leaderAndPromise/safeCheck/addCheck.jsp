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
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2002; i--) {
		listYear.add(i);
	}
	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
	
	String hse_check_id = request.getParameter("hse_check_id");
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
<body <%if(action.equals("add")){ %> onload="queryOrg()" <%} %>>
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_check_id" name="hse_check_id" value=""/>
<input type="hidden" id="isProject" name="isProject" value="<%=isProject%>"/>
<div id="new_table_box" >
  <div id="new_table_box_content" >
    <div id="new_table_box_bg" >
			<table id="lineTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr>
					<td class="inquire_item6">单位：</td>
			      	<td class="inquire_form6" colspan="2">
			      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
			      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
			      	<%} %>
			      	</td>
			     	<td class="inquire_item6">基层单位：</td>
			      	<td class="inquire_form6" colspan="2">
			      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
			      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
			      	<%} %>
			      	</td>
			      	<td class="inquire_item6">下属单位：</td>
			      	<td class="inquire_form6" colspan="2">
			      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
			      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
			      	<%}%>
			      	</td>
				</tr>
				<tr>
					<td class="inquire_item6"><font color="red">*</font>观察人：</td>
					<td class="inquire_form6"><input type="text" id="check_person" name="check_person" value="" class="input_width"></input></td>
					<td class="inquire_item6"><font color="red">*</font>观察部位：</td>
					<td class="inquire_form6"><input type="text" id="check_part" name="check_part" value="" class="input_width"></input></td>
					<td class="inquire_item6"><font color="red">*</font>日期：</td>
					<td class="inquire_form6"><input type="text" id="check_date" name="check_date" class="input_width" readonly="readonly"/>
					&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton1);" />&nbsp;
					</td>
					<td class="inquire_item6"><font color="red">*</font>观察与沟通起止时间：</td>
					<td class="inquire_form6" colspan="2"><input type="text" id="safe_time" name="safe_time" class="input_width"/>
					</td>
				</tr>
				<tr align="center">
					<td rowspan="2">观察项目</td>
					<td colspan="2">人为行为</td>
					<td colspan="3">物的状态</td>
					<td>作业环境</td>
					<td colspan="2">管理</td>
				</tr>
				<tr id="checkProject" align="center">
				
				</tr>
				<tr id="problem">
					<td rowspan="2" align="center">存在问题</td>
				</tr>
				<tr id="otherName">
					
				</tr>
				<tr>
					<td>观察发现</td>
					<td colspan="4" valign="top">
						<table id="goodSafe" width="100%" cellspacing="0" cellpadding="0"  class="tab_line_height" >
							<input type="hidden" id="goodNum" name="goodNum" value="0"></input>
							<tr>
								<td>好的方面描述：</td>
								<auth:ListButton functionId="" id="zj" css="zj" event="onclick='toAddGood()'" title="JCDP_btn_add"></auth:ListButton>
							</tr>
						</table>
					</td>
					<td colspan="4" valign="top">
						<table id="notSafe" width="100%" cellspacing="0" cellpadding="0"  class="tab_line_height" >
							<input type="hidden" id="notNum" name="notNum" value="0"></input>
							<td>不安全行为或状态描述：</td>
							<auth:ListButton functionId="" id="zj" css="zj" event="onclick='toAddNot()'" title="JCDP_btn_add"></auth:ListButton>
						</table>
					</td>
				</tr>
				<tr align="">
					<td>员工意见与建议</td>
					<td colspan="8">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea id="check_suggest" name="check_suggest" cols="50"></textarea></td>
				</tr>
				<tr >
					<td>备注</td>
					<td colspan="8">如果观察项目未发现问题，请在观察项目后面的“□”内划“√”；如果观察项目存在问题，请在观察项前的“□”内划“√”；<br/>属于“存在问题”中“其他”类的观察项目，勾选“其他”并在下方文本框注明问题类别。</td>
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
var hse_check_id = "<%=hse_check_id%>";
var action ="<%=action%>";

var delProj = "";
var delProb = "";

cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

	function queryOrg(){
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
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


checkBox();
toEdit();

function checkBox(){
	var hse_project_id = "";
	var checkSql="select sd.coding_code_id,sd.coding_name,sd.superior_code_id,sp.hse_project_id from Comm_Coding_Sort_Detail sd left join bgp_hse_safecheck_project sp on sd.coding_code_id = sp.sort_id and sp.bsflag='0' and sp.hse_check_id = '"+hse_check_id+"' where sd.coding_sort_id = '5110000029' and sd.superior_code_id = '0'  and sd.bsflag='0' order by coding_show_id";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	var checkProject = document.getElementById("checkProject");
	for(var i=0;i<datas.length;i++){
		var td = checkProject.insertCell(i);
		hse_project_id = datas[i].hse_project_id;
		var str = "<input type='checkbox' id='project"+datas[i].coding_code_id+"' name='project' value='"+hse_project_id+","+datas[i].coding_code_id+"' onclick='selectCheckBox(\""+datas[i].coding_code_id+"\")' ";
		if(datas[i].hse_project_id!=null&&datas[i].hse_project_id!=""){
			str = str + "checked='true'";
		}
		str = str + "/>";
		td.innerHTML = datas[i].coding_name+str;
	}
	
	var hse_problem_id="";
	var problem = document.getElementById("problem");
	for(var i=0;i<datas.length;i++){
		var tdStr="";	
		var checkSql2 = "select sd.coding_code_id, sd.coding_name, sd.superior_code_id, sp.hse_problem_id from Comm_Coding_Sort_Detail sd left join bgp_hse_safecheck_problem sp on sd.coding_code_id = sp.sort_id and sp.bsflag = '0' and sp.hse_check_id='"+hse_check_id+"' where sd.bsflag = '0' and sd.superior_code_id = '"+datas[i].coding_code_id+"'  order by sd.coding_show_id";
	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize='+20);
		var datas2 = queryRet2.datas;
		for(var j=0;j<datas2.length;j++){
			hse_problem_id = datas2[j].hse_problem_id;
			tdStr = tdStr+"<input type='checkbox' id='problem"+datas2[j].coding_code_id+"' name='problem' value='"+hse_problem_id+","+datas2[j].coding_code_id+"' onclick='selectOtherName(\""+datas2[j].coding_code_id+"\")'  ";
			if(datas2[j].hse_problem_id!=null&&datas2[j].hse_problem_id!=""){
				tdStr = tdStr + "checked='true'";
			}
			tdStr = tdStr +"/>"+datas2[j].coding_name+"<br/>";
		}
		var td = problem.insertCell(i+1);
		td.vAlign="top";
		td.innerHTML = tdStr;
	}
	
	var otherName = document.getElementById("otherName");
	for(var i=0;i<datas.length;i++){
		var td = otherName.insertCell(i);
		td.innerHTML = "<input type='hidden' id='hse_other_id"+datas[i].coding_code_id+"' name='hse_other_id"+datas[i].coding_code_id+"' value=''><input type='text' id='other_name"+datas[i].coding_code_id+"' name='other_name"+datas[i].coding_code_id+"' value=''  disabled='disabled'/>";
	}
	selectCheckBox2();
	selectOtherName2();
}

if(action=="view"){
	document.getElementById("submitButt").style.display="none";
}


function submitButton(){
	
	var projects = getSelIds("project");
	var problems = getSelIds("problem");
	
	var ids ="";
	var goods = document.getElementsByName("goodOrder");
	for(var i=0;i<goods.length;i++){
		var good = goods[i].value;
		if(ids!="") ids += ",";
			ids = ids + good;
	}
	
	var ids2 = "";
	var nots = document.getElementsByName("notOrder");
	for(var i=0;i<nots.length;i++){
		var not = nots[i].value;
		if(ids2!="") ids2 += ",";
		ids2 = ids2 + not;
	}
	
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/check/addSafeCheck.srq?projects="+projects+"&&problems="+problems+"&&goods="+ids+"&&nots="+ids2+"&&delProj="+delProj+"&&delProb="+delProb;
	form.submit();
}



//项目复选框
function selectCheckBox(id){
	var selected = document.getElementById("project"+id);
	var selValue = selected.value;
	var ids = selValue.split(",");
	var project_id = ids[0];
	var checkSql2 = "select * from Comm_Coding_Sort_Detail where bsflag='0' and superior_code_id = '"+id+"' order by coding_show_id";
    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize='+20);
	var datas2 = queryRet2.datas;
	debugger;
	if(selected.checked){
		
		document.getElementById("other_name"+id).disabled=true;
		document.getElementById("other_name"+id).value="";
		for(var j=0;j<datas2.length;j++){
			document.getElementById("problem"+datas2[j].coding_code_id).disabled=true;
			document.getElementById("problem"+datas2[j].coding_code_id).checked=false;
			
			if(action=="edit"){
				var selValue = document.getElementById("problem"+datas2[j].coding_code_id).value;
				var ids = selValue.split(",");
				var problem_id = ids[0];
				if(delProb!="") delProb += ",";
				delProb += problem_id;
			}
		}
		if(action=="edit"){
			if(project_id!=""){
				delProj = delProj.replace(project_id,"");
			}
		}
	}else{
		for(var j=0;j<datas2.length;j++){
			document.getElementById("problem"+datas2[j].coding_code_id).disabled=false;
			var selValue = document.getElementById("problem"+datas2[j].coding_code_id).value;
			var ids = selValue.split(",");
			var problem_id = ids[0];
			delProb = delProb.replace(problem_id,"");
		}
		if(action=="edit"){
			if(delProj!="") delProj += ",";
			delProj += project_id;
		}
	}
}

//进入页面，项目复选框选中，下属问题都不可编辑
function selectCheckBox2(){
	var checkSql="select sd.coding_code_id,sd.coding_name,sd.superior_code_id,sp.hse_project_id from Comm_Coding_Sort_Detail sd left join bgp_hse_safecheck_project sp on sd.coding_code_id = sp.sort_id and sp.bsflag='0' and sp.hse_check_id = '"+hse_check_id+"' where sd.coding_sort_id = '5110000029' and sd.superior_code_id = '0'  and sd.bsflag='0' order by coding_show_id";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas!=null){
		for(var i=0;i<datas.length;i++){
			var selected = document.getElementById("project"+datas[i].coding_code_id);
			var checkSql2 = "select sd.coding_code_id, sd.coding_name, sd.superior_code_id, sp.hse_problem_id from Comm_Coding_Sort_Detail sd left join bgp_hse_safecheck_problem sp on sd.coding_code_id = sp.sort_id and sp.bsflag = '0' and sp.hse_check_id='"+hse_check_id+"' where sd.bsflag = '0' and sd.superior_code_id = '"+datas[i].coding_code_id+"'  order by sd.coding_show_id";
		    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize='+20);
			var datas2 = queryRet2.datas;
			if(selected.checked){
				for(var j=0;j<datas2.length;j++){
					document.getElementById("problem"+datas2[j].coding_code_id).disabled=true;
				}
			}else{
				for(var j=0;j<datas2.length;j++){
					document.getElementById("problem"+datas2[j].coding_code_id).disabled=false;
				}
			}
		}
	}
}


//点击“其他”复选框事件
function selectOtherName(id){
	debugger;
	var selected = document.getElementById("problem"+id);
	var selValue = selected.value;
	var ids = selValue.split(",");
	var problem_id = ids[0];
	if(selected.checked){
		if(action=="edit"){
			if(problem_id!=""){
				delProb = delProb.replace(problem_id,"");
			}
		}
	}else{
		if(action=="edit"){
			if(delProb!="") delProb += ",";
			delProb += problem_id;
		}
	}
	
	if(id=="5110000029000000060"||id=="5110000029000000053"||id=="5110000029000000042"||id=="5110000029000000037"||id=="5110000029000000033"||id=="5110000029000000023"||id=="5110000029000000018"||id=="5110000029000000014"){
		var selected = document.getElementById("problem"+id);
		var checkSql2 = "select * from Comm_Coding_Sort_Detail where coding_code_id = '"+id+"'";
	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize='+20);
		var datas2 = queryRet2.datas;
		if(selected.checked){
			document.getElementById("other_name"+datas2[0].superior_code_id).disabled=false;
		}else{
			document.getElementById("other_name"+datas2[0].superior_code_id).disabled=true;
			document.getElementById("other_name"+datas2[0].superior_code_id).value="";
		}
	}
}
//进入此页面，判断“其他”复选框，是否被选中
function selectOtherName2(){
	var checkSql = "select * from Comm_Coding_Sort_Detail sd where sd.coding_sort_id = '5110000029' and sd.coding_name = '其他' and sd.bsflag = '0' order by superior_code_id";
	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize='+20);
	var datas = queryRet.datas;
	
	
	for(var i=0;i<datas.length;i++){
		var selected = document.getElementById("problem"+datas[i].coding_code_id);
		var checkSql2 = "select * from bgp_hse_safecheck_other where sort_id='"+datas[i].coding_code_id+"' and bsflag='0' and hse_check_id='"+hse_check_id+"'";
		var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize='+20);
		var datas2 = queryRet2.datas;
		if(selected.checked){
			document.getElementById("other_name"+datas[i].superior_code_id).disabled=false;
			if(datas2!=null&&datas2!=""){
			document.getElementById("other_name"+datas[i].superior_code_id).value=datas2[0].other_name;
			document.getElementById("hse_other_id"+datas[i].superior_code_id).value=datas2[0].hse_other_id;
			}
		}else{
			document.getElementById("other_name"+datas[i].superior_code_id).disabled=true;
			document.getElementById("other_name"+datas[i].superior_code_id).value="";
		}
	}
}


function getSelIds(inputName){
	var checkboxes = document.getElementsByName(inputName);
	
	var ids = "";
	for(var i=0;i<checkboxes.length;i++){
		var chx = checkboxes[i];
		if(chx.checked){
			if(ids!="") ids += ",";
			ids += chx.value;
		}
	}
	return ids;
}

function toAddGood(good_ids,good_safes){
	var good_id ="";
	var good_safe = "";
	if(good_ids != null && good_ids != ""){
		good_id=good_ids;
	}
	if(good_safes != null && good_safes != ""){
		good_safe=good_safes;
	}
	
	var goodNum = document.getElementById("goodNum").value;	
	
	var goodTable=document.getElementById("goodSafe");
	var lineId = "row_" + goodNum;
	
	var tr = goodTable.insertRow(goodTable.rows.length);
	tr.id=lineId;
	var td = tr.insertCell(0);
	td.colspan = "2";
	td.innerHTML = "<input type='hidden' id='good_id"+goodNum+"' name='good_id"+goodNum+"' value='"+good_id+"' /><input type='hidden' id='good_bsflag"+goodNum+"' name='good_bsflag"+goodNum+"' value='0'/><input type='hidden' name='goodOrder' value='"+goodNum+"'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>&nbsp;&nbsp;<textarea id='good_safe"+goodNum+"' name='good_safe"+goodNum+"' value='' cols='50'>"+good_safe+"</textarea>";
	
	document.getElementById("goodNum").value = parseInt(goodNum) + 1;
}

function toAddNot(nots_ids,not_safes){
	var not_id ="";
	var not_safe = "";
	if(nots_ids != null && nots_ids != ""){
		not_id=nots_ids;
	}
	if(not_safes != null && not_safes != ""){
		not_safe=not_safes;
	}
	
	var notNum = document.getElementById("notNum").value;	
	
	var notTable=document.getElementById("notSafe");
	var lineId = "row_" + notNum;
	
	var tr = notTable.insertRow(notTable.rows.length);
	tr.id=lineId;
	var td = tr.insertCell(0);
	td.colspan = "2";
	td.innerHTML = "<input type='hidden' id='not_id"+notNum+"' name='not_id"+notNum+"' value='"+not_id+"' /><input type='hidden' id='not_bsflag"+notNum+"' name='not_bsflag"+notNum+"' value='0'/><input type='hidden' name='notOrder' value='"+notNum+"'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine2(\""+lineId+"\")'/>&nbsp;&nbsp;<textarea id='not_safe"+notNum+"' name='not_safe"+notNum+"' value='' cols='50'>"+not_safe+"</textarea>";
	
	document.getElementById("notNum").value = parseInt(notNum) + 1;
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	//取删除行的主键ID
	var goodTable=document.getElementById("goodSafe");
	var goodNum = document.getElementById("goodNum").value;
	document.getElementById("goodNum").value = parseInt(goodNum) - 1;
	var line = document.getElementById(lineId);		
	if(action=="edit"){
		document.getElementById("good_bsflag"+notNum).value="1";
		line.style.display="none";	
	}else{
		goodTable.deleteRow(line.rowIndex);
	}
}


function deleteLine2(lineId){		
	var rowNum = lineId.split('_')[1];
	//取删除行的主键ID
	var notTable=document.getElementById("notSafe");
	var notNum = document.getElementById("notNum").value;
	document.getElementById("notNum").value = parseInt(notNum) - 1;
	var line = document.getElementById(lineId);		
	if(action=="edit"){
		document.getElementById("not_bsflag"+notNum).value="1";
		line.style.display="none";	
	}else{
		notTable.deleteRow(line.rowIndex);
	}
}



function toEdit(){
	var checkSql = "select sc.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,sd.hse_discover_id,sd.good_safe from bgp_hse_safecheck sc  left join comm_org_subjection os1 on sc.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on sc.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on sc.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0'  left join bgp_hse_safecheck_discover sd on sc.hse_check_id=sd.hse_check_id and sd.bsflag = '0' and sd.type='1' where sc.bsflag='0' and sc.hse_check_id='"+hse_check_id+"' order by sd.modifi_date desc";
	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize='+20);
	var datas = queryRet.datas;
	if(datas==null||datas==""){
		action="add";	
	}else{
		document.getElementById("hse_check_id").value=datas[0].hse_check_id;
		document.getElementById("second_org").value=datas[0].second_org;
		document.getElementById("second_org2").value=datas[0].second_org_name;
		document.getElementById("third_org").value=datas[0].third_org;
		document.getElementById("third_org2").value=datas[0].third_org_name;
		document.getElementById("fourth_org").value=datas[0].fourth_org;
		document.getElementById("fourth_org2").value=datas[0].fourth_org_name;
		document.getElementById("check_person").value=datas[0].check_person;
		document.getElementById("check_part").value=datas[0].check_part;
		document.getElementById("check_date").value=datas[0].check_date;
		document.getElementById("safe_time").value=datas[0].safe_time;
		document.getElementById("check_suggest").value = datas[0].check_suggest;
		for (var i = 0; i<datas.length; i++) {	
			if(datas[i].hse_discover_id!=""&&datas[i].hse_discover_id!=null){
			toAddGood(
					datas[i].hse_discover_id ? datas[i].hse_discover_id : "",
					datas[i].good_safe ? datas[i].good_safe : ""
				);
			}
		}		
	}
	
	var checkSql2="select sc.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,sd.hse_discover_id,sd.not_safe from bgp_hse_safecheck sc  left join comm_org_subjection os1 on sc.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on sc.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on sc.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0'  left join bgp_hse_safecheck_discover sd on sc.hse_check_id=sd.hse_check_id and sd.bsflag = '0' and sd.type='2' where sc.bsflag='0' and sc.hse_check_id='"+hse_check_id+"' order by sd.modifi_date desc";
    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
	var datas2 = queryRet2.datas;
	if(datas2==null||datas2==""){
		action="add";	
	}else{
		for (var i = 0; i<datas2.length; i++) {	
			if(datas[i].hse_discover_id!=""&&datas[i].hse_discover_id!=null){
			toAddNot(
					datas2[i].hse_discover_id ? datas2[i].hse_discover_id : "",
					datas2[i].not_safe ? datas2[i].not_safe : ""
				);
			}
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
	var re = /^[1-9]+[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(fourth_org2==""){
		document.getElementById("fourth_org").value="";
	}
	return false;
}

</script>
</html>
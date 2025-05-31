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
	
	
	String hse_plan_id = request.getParameter("hse_plan_id");
	String action = request.getParameter("action");
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
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
<body <%if(action.equals("add")){ %> onload="queryOrg()" <%} %>>
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_plan_id" name="hse_plan_id" value=""/>
<input type="hidden" id="isProject" name="isProject" value="<%=isProject%>"/>
<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
<div id="new_table_box" >
  <div id="new_table_box_content" >
    <div id="new_table_box_bg" >
			<table id="lineTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr>
					<td class="inquire_item6" colspan="1">单位：</td>
			      	<td class="inquire_form6" colspan="3">
			      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
			      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
			      	<%} %>
			      	</td>
			     	<td class="inquire_item6" colspan="1">基层单位：</td>
			      	<td class="inquire_form6" colspan="5">
			      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
			      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
			      	<%} %>
			      	</td>
			      	<td class="inquire_item6" colspan="2">下属单位：</td>
			      	<td class="inquire_form6" colspan="9">
			      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
			      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
			      	<%}%>
			      	</td>
				</tr>
				<tr>
					<td class="inquire_item6" colspan="1"><font color="red">*</font>姓名：</td>
					<td class="inquire_form6" colspan="3"><input type="text" id="name" name="name" value="" class="input_width"></input></td>
					<td class="inquire_item6" colspan="1"><font color="red">*</font>级别：</td>
					<td class="inquire_form6" colspan="5">
						<select id="duty" name="duty" class="select_width">
					       	<option value="" >请选择</option>
							<option value="1" >局级</option>
					        <option value="2" >处级</option>
					        <option value="3" >科级</option>
					        <option value="4" >员工</option>
						</select>
					 </td>
					 <td class="inquire_item6" colspan="2">年度：</td>
					 <td class="inquire_form6" colspan="9">
						<select id="year" name="year" class="select_width">
					       	<option value="" >请选择</option>
							<%for(int j=0;j<listYear.size();j++){%>
							<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
							<% } %>
						</select>
					 </td>
				</tr>
				<tr>
					<td colspan="20" align="center" style="border-right-style: none;">计划内容</td>
					<auth:ListButton functionId="" id="zj" css="zj" event="onclick='toAddSelect()'" title="JCDP_btn_add"></auth:ListButton>
				</tr>
				
				<tr align="center">
					<td >删除</td>
					<td>序号</td>
					<td>行动</td>
					<td>价值和目的</td>
					<td>频次</td>
					<td>一月<input type="checkbox" id="january" name="january" value="" onclick="chenkBoxEvent('january');"/></td>
					<td>二月<input type="checkbox" id="february" name="february" value=""  onclick="chenkBoxEvent('february');"/></td>
					<td>三月<input type="checkbox" id="march" name="march" value="" onclick="chenkBoxEvent('march');" /></td>
					<td>季度自评</td>
					<td>四月<input type="checkbox" id="april" name="april" value="" onclick="chenkBoxEvent('april');" /></td>
					<td>五月<input type="checkbox" id="may" name="may" value=""  onclick="chenkBoxEvent('may');"/></td>
					<td>六月<input type="checkbox" id="june" name="june" value="" onclick="chenkBoxEvent('june');" /></td>
					<td>季度自评</td>
					<td>七月<input type="checkbox" id="july" name="july" value="" onclick="chenkBoxEvent('july');" /></td>
					<td>八月<input type="checkbox" id="august" name="august" value="" onclick="chenkBoxEvent('august');" /></td>
					<td>九月<input type="checkbox" id="september" name="september" value="" onclick="chenkBoxEvent('september');" /></td>
					<td>季度自评</td>
					<td>十月<input type="checkbox" id="october" name="october" value="" onclick="chenkBoxEvent('october');" /></td>
					<td>十一月<input type="checkbox" id="november" name="november" value="" onclick="chenkBoxEvent('november');" /></td>
					<td>十二月<input type="checkbox" id="december" name="december" value="" onclick="chenkBoxEvent('december');" /></td>
					<td>季度自评</td>
				</tr>	
			
				<tr id="lastLine">
					<td class="inquire_item6" colspan="3">与下级就完成情况进行沟通：</td>
					<td class="inquire_form6" colspan="18"><textarea id='complete_status' name='complete_status' cols="80"></textarea></td>
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

var hse_plan_id = "<%=hse_plan_id%>";
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


toEdit();
if(action=="view"){
	document.getElementById("submitButt").style.display="none";
}


function submitButton(){
	var form = document.getElementById("form");
		if(checkText()){
			return;
		}
	var ids = "";
	var orders = document.getElementsByName("order");
	for(var i=0;i<orders.length;i++){
		temp = orders[i].value; 
		var january = document.getElementById("january"+temp);
			if(january.checked){
				january.value="0";
			}else{
				january.value="1";
			}
		var february = document.getElementById("february"+temp);
			if(february.checked){
				february.value="0";
			}else{
				february.value="1";
			}
		var march = document.getElementById("march"+temp);
			if(march.checked){
				march.value="0";
			}else{
				march.value="1";
			}
		var april = document.getElementById("april"+temp);
			if(april.checked){
				april.value="0";
			}else{
				april.value="1";
			}
		var may = document.getElementById("may"+temp);
			if(may.checked){
				may.value="0";
			}else{
				may.value="1";
			}
		var june = document.getElementById("june"+temp);
			if(june.checked){
				june.value="0";
			}else{
				june.value="1";
			}
		var july = document.getElementById("july"+temp);
			if(july.checked){
				july.value="0";
			}else{
				july.value="1";
			}
		var august = document.getElementById("august"+temp);
			if(august.checked){
				august.value="0";
			}else{
				august.value="1";
			}
		var september = document.getElementById("september"+temp);
			if(september.checked){
				september.value="0";
			}else{
				september.value="1";
			}
		var october= document.getElementById("october"+temp);
			if(october.checked){
				october.value="0";
			}else{
				october.value="1";
			}
		var november = document.getElementById("november"+temp);
			if(november.checked){
				november.value="0";
			}else{
				november.value="1";
			}
		var december = document.getElementById("december"+temp);
		if(december.checked){
			december.value="0";
		}else{
			december.value="1";
		}
	}
	//算出添加的多少行，并且value值
	for(var i=0;i<orders.length;i++){
		order = orders[i].value;
		if(ids!="") ids += ",";
			ids = ids + order;
	}
	form.action="<%=contextPath%>/hse/plan/addSafePlan.srq?orders="+ids;
	form.submit();
}

function chenkBoxEvent(month){
//	var month = document.getElementById(month);
//	var month = "january";
	var orders = document.getElementsByName("order");
	for(var i=0;i<orders.length;i++){
		temp = orders[i].value;
		document.getElementById(month+temp).checked = document.getElementById(month).checked;
	}
}

function toAddSelect(){
//	var selected = window.showModalDialog("<%=contextPath%>/hse/leaderAndPromise/selfSafePlan/selectPlan.jsp","","dialogWidth=545px;dialogHeight=280px");

/*	var temp = selected.split(",");
	for(var i=0;i<temp.length;i++){
		var plan_action = "";
		if(temp[i]=="1"){
			plan_action="公共场所不吸烟";
		}
		if(temp[i]=="2"){
			plan_action="乘车系安全带，同时提醒他人";
		}
		if(temp[i]=="3"){
			plan_action="上下楼梯扶扶手";
		}
		if(temp[i]=="4"){
			plan_action="过街是有天桥的，一定走天桥";
		}
		toAddLine("",plan_action,"","","","","","","","","","","","","","","","","","");
	}
*/	
		
	for(var i=0;i<5;i++){
		toAddLine("","","","","","","","","","","","","","","","","","","","");
	}	


}


function toAddLine(hse_plan_detail_id,plan_action,plan_purpose,plan_times,january,february,march,april,may,june,july,august,september,october,november,december,first_quarter,second_quarter,third_quarter,fourth_quarter){
	var detail_id = "";
	var pl_action = "";
	var purpose = "";
	var times = "";
	var first = "";
	var second = "";
	var third = "";
	var fourth = "";
	if(hse_plan_detail_id != null && hse_plan_detail_id != ""){
		detail_id=hse_plan_detail_id;
	}
	if(plan_action != null && plan_action != ""){
		pl_action = plan_action;
	}
	if(plan_purpose != null && plan_purpose != ""){
		purpose = plan_purpose;
	}
	if(plan_times != null && plan_times != ""){
		times = plan_times;
	}
	if(first_quarter != null && first_quarter != ""){
		first = first_quarter;
	}
	if(second_quarter != null && second_quarter != ""){
		second = second_quarter;
	}
	if(third_quarter != null && third_quarter != ""){
		third = third_quarter;
	}
	if(fourth_quarter != null && fourth_quarter != ""){
		fourth = fourth_quarter;
	}
	var rowNum = document.getElementById("lineNum").value;	
	var lastLine = document.getElementById("lastLine");	
	
	var table=document.getElementById("lineTable");
	var lineId = "row_" + rowNum;
	
	var tr = table.insertRow(table.rows.length-1);
	tr.align="center";
	tr.id=lineId;
	var td = tr.insertCell(0);
	td.innerHTML = "<input type='hidden' id='hse_plan_detail_id"+rowNum+"' name='hse_plan_detail_id"+rowNum+"' value='"+detail_id+"' /><input type='hidden' id='bsflag"+rowNum+"' name='bsflag"+rowNum+"' value='0'/><input type='hidden' name='order' value='"+rowNum+"'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
	
	td = tr.insertCell(1);
	td.innerHTML = (Number(rowNum)+1);
	
	td = tr.insertCell(2);
	td.innerHTML = "<textarea id='plan_action"+rowNum+"' name='plan_action"+rowNum+"' value=''>"+pl_action+"</textarea>";
	
	td = tr.insertCell(3);
	td.innerHTML = "<textarea id='plan_purpose"+rowNum+"' name='plan_purpose"+rowNum+"' value=''>"+purpose+"</textarea>";
	
	td = tr.insertCell(4);
	td.innerHTML = "<input type='text' id='plan_times"+rowNum+"' name='plan_times"+rowNum+"' value='"+times+"' size='12'/>";
	
	td = tr.insertCell(5);
	td.innerHTML = "<input type='checkbox' id='january"+rowNum+"' name='january"+rowNum+"' value='' />";
	
	td = tr.insertCell(6);
	td.innerHTML = "<input type='checkbox' id='february"+rowNum+"' name='february"+rowNum+"'  value='' />";
	
	td = tr.insertCell(7);
	td.innerHTML = "<input type='checkbox' id='march"+rowNum+"' name='march"+rowNum+"' value='' />";
	
	td = tr.insertCell(8);
	td.innerHTML = "<select id='first_quarter"+rowNum+"' name='first_quarter"+rowNum+"'><option value=''>请选择</option><option value='1'>完成</option><option value='2'>未完成</option></select>";
	
	td = tr.insertCell(9);
	td.innerHTML = "<input type='checkbox' name='april"+rowNum+"' id='april"+rowNum+"' value='' />";
	
	td = tr.insertCell(10);
	td.innerHTML = "<input type='checkbox' name='may"+rowNum+"' id='may"+rowNum+"'  value='' />";
	
	td = tr.insertCell(11);
	td.innerHTML = "<input type='checkbox' name='june"+rowNum+"' id='june"+rowNum+"'  value='' />";
	
	td = tr.insertCell(12);
	td.innerHTML = "<select id='second_quarter"+rowNum+"' name='second_quarter"+rowNum+"'><option value=''>请选择</option><option value='1'>完成</option><option value='2'>未完成</option></select>";
	
	td = tr.insertCell(13);
	td.innerHTML = "<input type='checkbox' name='july"+rowNum+"' id='july"+rowNum+"' value='' />";
	
	td = tr.insertCell(14);
	td.innerHTML = "<input type='checkbox' name='august"+rowNum+"' id='august"+rowNum+"' value='' />";
	
	td = tr.insertCell(15);
	td.innerHTML = "<input type='checkbox' name='september"+rowNum+"' id='september"+rowNum+"'  value='' />";
	
	td = tr.insertCell(16);
	td.innerHTML = "<select id='third_quarter"+rowNum+"' name='third_quarter"+rowNum+"'><option value=''>请选择</option><option value='1'>完成</option><option value='2'>未完成</option></select>";
	
	td = tr.insertCell(17);
	td.innerHTML = "<input type='checkbox' id='october"+rowNum+"' name='october"+rowNum+"' value='' />";
	
	td = tr.insertCell(18);
	td.innerHTML = "<input type='checkbox' id='november"+rowNum+"' name='november"+rowNum+"' value='' />";
	
	td = tr.insertCell(19);
	td.innerHTML = "<input type='checkbox' id='december"+rowNum+"' name='december"+rowNum+"' value='' />";
	
	td = tr.insertCell(20);
	td.innerHTML = "<select id='fourth_quarter"+rowNum+"' name='fourth_quarter"+rowNum+"'><option value=''>请选择</option><option value='1'>完成</option><option value='2'>未完成</option></select>";
	
	
	document.getElementById("first_quarter"+rowNum).value = first;
	document.getElementById("second_quarter"+rowNum).value = second;
	document.getElementById("third_quarter"+rowNum).value = third;
	document.getElementById("fourth_quarter"+rowNum).value = fourth;
	
	if(january=="0"){
		document.getElementById("january"+rowNum).checked = true;
	}
	if(february=="0"){
		document.getElementById("february"+rowNum).checked = true;
	}
	if(march=="0"){
		document.getElementById("march"+rowNum).checked = true;
	}
	if(april=="0"){
		document.getElementById("april"+rowNum).checked = true;
	}
	if(may=="0"){
		document.getElementById("may"+rowNum).checked = true;
	}
	if(june=="0"){
		document.getElementById("june"+rowNum).checked = true;
	}
	if(july=="0"){
		document.getElementById("july"+rowNum).checked = true;
	}
	if(august=="0"){
		document.getElementById("august"+rowNum).checked = true;
	}
	if(september=="0"){
		document.getElementById("september"+rowNum).checked = true;
	}
	if(october=="0"){
		document.getElementById("october"+rowNum).checked = true;
	}
	if(november=="0"){
		document.getElementById("november"+rowNum).checked = true;
	}
	if(december=="0"){
		document.getElementById("december"+rowNum).checked = true;
	}
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
}

function createRow(html){
    var div=document.createElement("div");
    html="<table><tbody>"+html+"</tbody></table>"
    div.innerHTML=html;
    return div.lastChild.lastChild;
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	//取删除行的主键ID
	var table=document.getElementById("lineTable");
	var lineNum = document.getElementById("lineNum").value;
	document.getElementById("lineNum").value = parseInt(lineNum) - 1;
	var line = document.getElementById(lineId);		
	if(action=="edit"){
		document.getElementById("bsflag"+rowNum).value="1";
		line.style.display="none";	
	}else{
		table.deleteRow(line.rowIndex);
	}
}



function toEdit(){
	var checkSql="select sp.hse_plan_id id,sp.second_org,sp.third_org,sp.fourth_org,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,sp.name,sp.duty,sp.year,sp.complete_status,sd.* from bgp_hse_safeplan sp left join comm_org_subjection os1 on sp.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on sp.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on sp.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0' left join bgp_hse_safeplan_detail sd on sp.hse_plan_id = sd.hse_plan_id and sd.bsflag='0' where sp.bsflag='0' and sp.hse_plan_id='"+hse_plan_id+"' order by   sd.order_num  asc";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas==null||datas==""){
		action="add";	
	}else{
		document.getElementById("hse_plan_id").value=datas[0].id;
		document.getElementById("second_org").value=datas[0].second_org;
		document.getElementById("second_org2").value=datas[0].second_org_name;
		document.getElementById("third_org").value=datas[0].third_org;
		document.getElementById("third_org2").value=datas[0].third_org_name;
		document.getElementById("fourth_org").value=datas[0].fourth_org;
		document.getElementById("fourth_org2").value=datas[0].fourth_org_name;
		document.getElementById("name").value=datas[0].name;
		document.getElementById("duty").value=datas[0].duty;
		document.getElementById("year").value=datas[0].year;
		document.getElementById("complete_status").value=datas[0].complete_status;
		for (var i = 0; i<datas.length; i++) {		
			toAddLine(
					datas[i].hse_plan_detail_id ? datas[i].hse_plan_detail_id : "",
					datas[i].plan_action ? datas[i].plan_action : "",
					datas[i].plan_purpose ? datas[i].plan_purpose : "",
					datas[i].plan_times ? datas[i].plan_times : "",
					datas[i].january ? datas[i].january : "",
					datas[i].february ? datas[i].february : "",
					datas[i].march ? datas[i].march : "",
					datas[i].april ? datas[i].april : "",
					datas[i].may ? datas[i].may : "",
					datas[i].june ? datas[i].june : "",
					datas[i].july ? datas[i].july : "",
					datas[i].august ? datas[i].august : "",
					datas[i].september ? datas[i].september : "",
					datas[i].october ? datas[i].october : "",
					datas[i].november ? datas[i].november : "",
					datas[i].december ? datas[i].december : "",
					datas[i].first_quarter ? datas[i].first_quarter : "",
					datas[i].second_quarter ? datas[i].second_quarter : "",
					datas[i].third_quarter ? datas[i].third_quarter : "",
					datas[i].fourth_quarter ? datas[i].fourth_quarter : ""
				);
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
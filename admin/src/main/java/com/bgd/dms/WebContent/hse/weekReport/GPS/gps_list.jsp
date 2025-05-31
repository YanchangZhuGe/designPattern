<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getOrgSubjectionId();
	String userName = user.getUserId();
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	String subflag = request.getParameter("subflag");
	String action = request.getParameter("action");
	String organ_flag = request.getParameter("organ_flag");
	Date now = new Date();
	String sql = "select * from comm_org_subjection s join comm_org_information i on s.org_id = i.org_id and i.bsflag='0'  where s.bsflag='0' and s.org_subjection_id = '"+org_id+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	
	String orgName="";
	if(map!=null){
		orgName = (String)map.get("orgAbbreviation");
	}
	String isProject = request.getParameter("isProject");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<title>新建返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="">
<form name="form1" id="form1" method="post" action="">
<div id="list_table" style="height: auto;width:auto;overflow: hidden;">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td>&nbsp;周报时间：&nbsp;<%=week_date %>&nbsp;至&nbsp;<%=week_end_date %></td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" id="zj" css="zj" event="onclick='toAddLine()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title="保存"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
	</div>
      <fieldSet style="margin-left:2px"><legend>本单位信息</legend>
      <div id="week_box" style="overflow: scroll;">
      <table id="lineTable" width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input type="hidden" id="hse_common_id" name="hse_common_id" value=""></input>
      	<input type="hidden" id="hse_danger_id" name="hse_danger_id" value=""></input>
      	<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
        	<tr class="bt_info">
				<td rowspan="2">删除</td>
				<td rowspan="2">单位</td>
				<td colspan="7" >GPS使用信息</td>
				<td colspan="3">GPS监控信息</td>
			</tr>
			<tr class="bt_info">
				<td>现有安装台数</td>
				<td>本周工作台数</td>
				<td>正常</td>
				<td>不正常</td>
				<td>待修</td>
				<td>不正常原因</td>
				<td>采取措施</td>
				<td>违章统计(台)</td>
				<td>违章原因</td>
				<td>采取措施</td>
			</tr>
      </table>
      </div>
      </fieldSet>
  </div>
</form>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";

$("#week_box").css("height",$(window).height()-60);

$(function(){
	$(window).resize(function(){
		$("#week_box").css("height",$(window).height()-60);
	});
})	

var action="<%=action %>";
var org_id="<%=org_id %>";
var organ_flag = "<%=organ_flag%>";
var subflag="<%=subflag %>";
var hse_gps_ids = "";
if(subflag=="1"||subflag=="3"){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}
//if(action=="add"){
//	document.getElementById("bc").style.display="";
//	document.getElementById("zj").style.display="";
//}
toEdit();

function toAddLine(hse_gps_id,use_no,week_use_no,normal_no,wrong_no,fix_no,wrong_reason,wrong_step,rule_no,rule_reason,rule_step){
	
	var hse_gps_id  = hse_gps_id ? hse_gps_id : "";
	var use_no = use_no ? use_no : ""; 
	var week_use_no = week_use_no ? week_use_no : ""
	var normal_no = normal_no ? normal_no : "";
	var wrong_no = wrong_no ? wrong_no : "";
	var fix_no = fix_no ? fix_no : "";
	var wrong_reason = wrong_reason ? wrong_reason : "";
	var wrong_step = wrong_step ? wrong_step : "";
	var rule_no = rule_no ? rule_no : "";
	var rule_reason = rule_reason ? rule_reason : "";
	var rule_step = rule_step ? rule_step : "";
	
	var orgName='<%=orgName%>';
	
	var rowNum = document.getElementById("lineNum").value;	
	
	var table=document.getElementById("lineTable");
	var lineId = "row_" + rowNum;
	
	var autoOrder = document.getElementById("lineTable").rows.length;
	var newTR = document.getElementById("lineTable").insertRow(autoOrder);
	newTR.id = lineId;
	var tdClass = 'even';
	if(autoOrder%2==0){
		tdClass = 'odd';
	}
	
	var td = newTR.insertCell(0);
	td.innerHTML = "<input type='hidden' id='hse_gps_id"+rowNum+"' value='"+hse_gps_id+"' /><input type='hidden' name='order' value='" + rowNum + "'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
    
    td = newTR.insertCell(1);
    td.innerHTML = orgName;
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
    
    td = newTR.insertCell(2);
	td.innerHTML = "<input id='use_no"+rowNum+"' value='"+use_no+"' size='7'/>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
    
    td = newTR.insertCell(3);
    td.innerHTML = "<input id='week_use_no"+rowNum+"' value='"+week_use_no+"' size='7'/>";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
    
    td = newTR.insertCell(4);
	td.innerHTML = "<input id='normal_no"+rowNum+"' value='"+normal_no+"' size='7'/>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
    
    td = newTR.insertCell(5);
    td.innerHTML = "<input id='wrong_no"+rowNum+"' value='"+wrong_no+"' size='7'/>";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
    
    td = newTR.insertCell(6);
	td.innerHTML = "<input id='fix_no"+rowNum+"' value='"+fix_no+"' size='7'/>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
    
    td = newTR.insertCell(7);
    td.innerHTML = "<textarea id='wrong_reason"+rowNum+"'>"+wrong_reason+"</textarea>";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
    
    td = newTR.insertCell(8);
	td.innerHTML = "<textarea id='wrong_step"+rowNum+"'>"+wrong_step+"</textarea>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
    
    td = newTR.insertCell(9);
    td.innerHTML = "<input type='text' id='rule_no"+rowNum+"' value='"+rule_no+"' size='7'/>";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
    
    td = newTR.insertCell(10);
	td.innerHTML = "<textarea id='rule_reason"+rowNum+"'>"+rule_reason+"</textarea>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
    
    td = newTR.insertCell(11);
    td.innerHTML = "<textarea id='rule_step"+rowNum+"'>"+rule_step+"</textarea>";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	
	
//	var temp = "odd";
//	if(rowNum%2 == 0){
//		temp = "even";
//	} else {
//		temp = "odd";
//	}
//	var elem = createRow("<tr class="+temp+" id='"+lineId+"'><input type='hidden' id='hse_gps_id"+rowNum+"' value='"+hse_gps_id+"' /><td><input type='hidden' name='order' value='" + rowNum + "'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/></td><td>"+orgName+"</td><td><input id='use_no"+rowNum+"' value='"+use_no+"'/></td><td><input id='wrong_no"+rowNum+"' value='"+wrong_no+"'/></td><td><textarea id='wrong_reason"+rowNum+"'>"+wrong_reason+"</textarea></td><td><textarea id='wrong_step"+rowNum+"'>"+wrong_step+"</textarea></td><td><input type='text' id='rule_no"+rowNum+"' value='"+rule_no+"' /></td><td><textarea id='rule_reason"+rowNum+"'>"+rule_reason+"</textarea></td><td><textarea id='rule_step"+rowNum+"'>"+rule_step+"</textarea></td><td><textarea id='rule_analyze"+rowNum+"'>"+rule_analyze+"</textarea></td></tr>");
//	table.appendChild(elem);
	
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
	var hse_gps_id = document.getElementById("hse_gps_id"+rowNum).value;
	var rowNum2 = document.getElementById("lineNum").value;	
	var line = document.getElementById(lineId);		
	line.parentNode.removeChild(line);
	
	if(hse_gps_ids!="") hse_gps_ids += ",";
	hse_gps_ids += hse_gps_id; 
}


function toAdd(){ 
	
	var rowNum = document.getElementById("lineNum").value;	
	var orders = document.getElementsByName("order");
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/ 
	for (var i="0";i<orders.length;i++){
		var order = orders[i].value;
		var hse_common_id = document.getElementById("hse_common_id").value;
		var hse_gps_id = document.getElementById("hse_gps_id"+order).value;
		var use_no = document.getElementById("use_no"+order).value;
		var week_use_no = document.getElementById("week_use_no"+order).value;
		var normal_no = document.getElementById("normal_no"+order).value;
		var wrong_no = document.getElementById("wrong_no"+order).value;
		var fix_no = document.getElementById("fix_no"+order).value;
		var wrong_reason = document.getElementById("wrong_reason"+order).value;
		var wrong_step = document.getElementById("wrong_step"+order).value;
		var rule_no = document.getElementById("rule_no"+order).value;
		var rule_reason = document.getElementById("rule_reason"+order).value;
		var rule_step = document.getElementById("rule_step"+order).value;
		if(use_no!=null&&use_no!=""){
			if (!re.test(use_no))
			   {
			       alert("现有安装台数请输入数字！");
			       return ;
			    }
		}
		if(week_use_no!=null&&week_use_no!=""){
			if (!re.test(week_use_no))
			   {
			       alert("本周工作台数请输入数字！");
			       return ;
			    }
		}
		if(normal_no!=null&&normal_no!=""){
			if (!re.test(normal_no))
			   {
			       alert("正常台数请输入数字！");
			       return ;
			    }
		}
		if(wrong_no!=null&&wrong_no!=""){
			if (!re.test(wrong_no))
			   {
			       alert("不正常台数请输入数字！");
			       return ;
			    }
		}
		if(fix_no!=null&&fix_no!=""){
			if (!re.test(fix_no))
			   {
			       alert("待修台数请输入数字！");
			       return ;
			    }
		}
		if(rule_no!=null&&rule_no!=""){
			if (!re.test(rule_no))
			   {
			       alert("违章统计(台)请输入数字！");
			       return ;
			    }
		}
		var isProject = "<%=isProject%>";
		
		var jcdp_tables="[['bgp_hse_common'],['bgp_hse_week_gps','hse_common_id=bgp_hse_common']]"
		             +"&bgp_hse_common={'hse_common_id':'"+hse_common_id+"','week_start_date':'<%=week_date%>','week_end_date':'<%=week_end_date%>','org_id':'<%=org_id%>','subflag':'0',"
		           	 +"'bsflag':'0','modifi_date':'<%=now%>',updator_id:'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           	 if(action!="edit"){
		           	 	jcdp_tables = jcdp_tables+",'create_date':'<%=now%>','creator_id':'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           	 	if(isProject=="2"){
			           	 	jcdp_tables = jcdp_tables+",'project_info_no':'<%=user.getProjectInfoNo()%>'";
			           	 }
		           	 }
		           	 jcdp_tables = jcdp_tables +"}";
		           	jcdp_tables = jcdp_tables +"&bgp_hse_week_gps={'hse_gps_id':'"+hse_gps_id+"','use_no':'"+use_no+"','week_use_no':'"+week_use_no+"','normal_no':'"+normal_no+"','wrong_no':'"+wrong_no+"','fix_no':'"+fix_no+"','wrong_reason':'"+encodeURI(encodeURI(wrong_reason))+"','wrong_step':'"+encodeURI(encodeURI(wrong_step))+"','rule_no':'"+rule_no+"','rule_reason':'"+encodeURI(encodeURI(rule_reason))+"','rule_step':'"+encodeURI(encodeURI(rule_step))+"','gps_order':'"+order+"'}";
		
		var path = "<%=contextPath%>/rad/addOrUpdateMulTableData.srq";
		submitStr = "jcdp_tables="+jcdp_tables;
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		
		var checkSql="select c.hse_common_id id,d.* from bgp_hse_common c left join bgp_hse_week_gps d  on c.hse_common_id=d.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>' order by d.gps_order asc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			document.getElementById("hse_common_id").value=datas[i].id;
			document.getElementById("hse_gps_id"+order).value=datas[i].hse_gps_id;
		}
	}
	
	//删除已经删除的某条明细
	var retObj = jcdpCallService("HseSrv", "deleteDetail", "ids="+hse_gps_ids+"&table=bgp_hse_week_gps&key=hse_gps_id");
	
	if(orders.length==0){
		alert("保存成功");
	}else{
		afterSave(retObject);
	}
}

	//提示提交结果
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '保存成功';
		if(failHint==undefined) failHint = '保存失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
		}
	}
	
	function toEdit(){
		var checkSql="select c.hse_common_id id,d.* from bgp_hse_common c left join bgp_hse_week_gps d  on c.hse_common_id=d.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>' order by d.gps_order asc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		debugger;
		if(datas==null||datas==""){
			if(datas!=null&&datas!=""){
				document.getElementById("hse_common_id").value=datas[0].id;
			}
			action="add";	
			if(organ_flag=="0"){
				var checkSql3="select g.* from bgp_hse_common c join bgp_hse_org ho on c.org_id = ho.org_sub_id left join bgp_hse_week_gps g on c.hse_common_id = g.hse_common_id where to_char(c.week_start_date, 'yyyy-MM-dd') = '<%=week_date %>' and c.bsflag = '0' and c.subflag = '1' and ho.father_org_sub_id = '<%=org_id%>'";
			    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
				var datas3 = queryRet3.datas;
				if(datas3!=null&&datas3!=""){
					for (var i = 0; i<datas3.length; i++) {		
						toAddLine(
							"",
							datas3[i].use_no ? datas3[i].use_no : "",
							datas3[i].week_use_no ? datas3[i].week_use_no : "",
							datas3[i].normal_no ? datas3[i].normal_no : "",
							datas3[i].wrong_no ? datas3[i].wrong_no : "",
							datas3[i].fix_no ? datas3[i].fix_no : "",
							datas3[i].wrong_reason ? datas3[i].wrong_reason : "",
							datas3[i].wrong_step ? datas3[i].wrong_step : "",
							datas3[i].rule_no ? datas3[i].rule_no : "",
							datas3[i].rule_reason ? datas3[i].rule_reason : "",
							datas3[i].rule_step ? datas3[i].rule_step : ""
						);
					}
				}
			}else{
				toAddLine("","","","","","","","","","","");
			}
		}else{
			document.getElementById("hse_common_id").value=datas[0].id;
			for (var i = 0; i<datas.length; i++) {		
				
				toAddLine(
						datas[i].hse_gps_id ? datas[i].hse_gps_id : "",
						datas[i].use_no ? datas[i].use_no : "",
						datas[i].week_use_no ? datas[i].week_use_no : "",
						datas[i].normal_no ? datas[i].normal_no : "",
						datas[i].wrong_no ? datas[i].wrong_no : "",
						datas[i].fix_no ? datas[i].fix_no : "",
						datas[i].wrong_reason ? datas[i].wrong_reason : "",
						datas[i].wrong_step ? datas[i].wrong_step : "",
						datas[i].rule_no ? datas[i].rule_no : "",
						datas[i].rule_reason ? datas[i].rule_reason : "",
						datas[i].rule_step ? datas[i].rule_step : ""
					);
			}		
			action = "edit";
		}
	} 
	
	function toBack(){
		window.parent.parent.location='<%=contextPath%>/hse/weekReport/week_list.jsp?isProject=<%=isProject%>';
	}
</script>
</html>


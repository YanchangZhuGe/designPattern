<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String org_subjection_id = user.getOrgSubjectionId();
	String org_sub_id = request.getParameter("org_sub_id");
	
	String father_org_id = "";
	String sql = "select * from bgp_hse_org where org_sub_id='"+org_sub_id+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		father_org_id = (String)map.get("fatherOrgSubId");
	}
	
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
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
</head>
<body >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_law_id" name="hse_law_id" value=""></input>
<input type="hidden" id="org_sub_id" name="org_sub_id" value="<%=org_sub_id%>"></input>
<input type="hidden" id="modifi_date" name="modifi_date" value=""></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr align="left" height="20">
		    	<td id="showModifiDate">&nbsp;</td>
		        <td width="5"></td>
		    </tr>
		</table>
    
		<table id="queryTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
		<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
		<input type="hidden" id="orderNum" name="orderNum" value="1"></input>
		 <tr align="center">
	    	    <td class="bt_info_odd">序号</td>
	            <td class="bt_info_even">法律、法规和其他要求名称</td>
	            <td class="bt_info_odd">文件号或编号</td>		
	            <td class="bt_info_even">实施日期</td>
	            <td class="bt_info_odd">不适用</td>
	        </tr>
		</table>
	</div>
	<div id="oper_div">
	<%if(action==null||!action.equals("view")){ %>
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
	<%} %>
		<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
	</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

function submitButton(){
	
	var temp = "";
	var orders = document.getElementsByName("order");	
	for (var i=0;i<orders.length;i++){
		var order = orders[i].value;
		if(temp!=""){
			temp = temp+",";
		}
			temp = temp+order;
	}
	
	var ids = getSelIds("if_ok");
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/hseLawAndRequest/addLawAndRequestOrg.srq?temp="+temp+"&ids="+ids;
	form.submit();
	$("#new_table_box_bg").mask("请等待...");
}

function closeButton(){
	$("#new_table_box_bg").unmask();
	newClose();
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


function toUpload(){
	var obj=window.showModalDialog('<%=contextPath%>/hse/hseLawAndRequest/importFile.jsp',"","dialogHeight:500px;dialogWidth:600px");
	if(obj!="" && obj!=undefined ){		
		for(var j =1;j <document.getElementById("queryTable")!=null && j < document.getElementById("queryTable").rows.length ;){
			document.getElementById("queryTable").deleteRow(j);
		}
		
		var checkStr = obj.split(",");
		for(var i=0;i<checkStr.length-1;i++){
			var check = checkStr[i].split("@");  
			debugger;
			toAddLine(check[0],check[1],check[2],check[3]);
		}
		
	}
}


//保留小数后几位   四舍五入
function toDecimal(x) {   
    var f = parseFloat(x);   
    if (isNaN(f)) {   
        return;   
    }   
    f = Math.round(x*1000)/1000;   
    return f;   
}


function toAddLine(order_num,law,file_code,start_date,if_ok){
	
	var order_num2 ="";
	var law2 = "";
	var file_code2 = "";
	var start_date2 = "";
	var if_ok2 = "";
	
	if(order_num!=null&&order_num!=""){
		order_num2 = order_num;
	}
	if(law!=null&&law!=""){
		law2 = law;
	}
	if(file_code!=null&&file_code!=""){
		file_code2 = file_code;
	}
	if(start_date!=null&&start_date!=""){
		start_date2 = start_date;
	}
	if(if_ok!=null&&if_ok!=""){
		if_ok2 = if_ok;
	}
	
	
	var rowNum = document.getElementById("lineNum").value;	
	var orderNum = document.getElementById("orderNum").value;	
	
	var table=document.getElementById("queryTable");
	
	var lineId = "row_" + rowNum;
	var autoOrder = document.getElementById("queryTable").rows.length;
	var newTR = document.getElementById("queryTable").insertRow(autoOrder);
	newTR.id = lineId;
	var tdClass = 'even';
	if(autoOrder%2==0){
		tdClass = 'odd';
	}
	
	
	var td = newTR.insertCell(0);
	td.innerHTML = "<input type='hidden' name='order' value='" + rowNum + "'/><input type='hidden' id='order_num"+rowNum+"' name='order_num"+rowNum+"' value='"+order_num2+"'>"+orderNum;
	td.id = "orderNumber"+rowNum;
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	var td = newTR.insertCell(1);
	td.innerHTML = "<input type='hidden' id='law"+rowNum+"' name='law"+rowNum+"' value='"+law2+"'>"+law2;
	td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	
	td = newTR.insertCell(2);
	td.innerHTML = "<input type='hidden' id='file_code"+rowNum+"' name='file_code"+rowNum+"' value='"+file_code2+"'>"+file_code2;
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	td = newTR.insertCell(3);
	td.innerHTML = "<input type='hidden' id='start_date"+rowNum+"' name='start_date"+rowNum+"' value='"+start_date2+"'>"+start_date2;
	td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	td = newTR.insertCell(4);
	var checkBox = "<input type='checkbox' id='if_ok"+rowNum+"' name='if_ok' value='"+rowNum+"'";
	if(if_ok=="1"){
		checkBox = checkBox + " checked='true' ";
	}
	 	checkBox = checkBox + "/>"
	td.innerHTML = checkBox;
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
	document.getElementById("orderNum").value = parseInt(orderNum) + 1;
}

function toAddLineSelf(order_num,law,file_code,start_date){
	
	var order_num2 ="";
	var law2 = "";
	var file_code2 = "";
	var start_date2 = "";
	
	if(order_num!=null&&order_num!=""){
		order_num2 = order_num;
	}
	if(law!=null&&law!=""){
		law2 = law;
	}
	if(file_code!=null&&file_code!=""){
		file_code2 = file_code;
	}
	if(start_date!=null&&start_date!=""){
		start_date2 = start_date;
	}
	
	
	var rowNum = document.getElementById("lineNum").value;
	var orderNum = document.getElementById("orderNum").value;	
	
	var table=document.getElementById("queryTable");
	
	var lineId = "row_" + rowNum;
	var autoOrder = document.getElementById("queryTable").rows.length;
	var newTR = document.getElementById("queryTable").insertRow(autoOrder);
	newTR.id = lineId;
	var tdClass = 'even';
	if(autoOrder%2==0){
		tdClass = 'odd';
	}
	
	
	var td = newTR.insertCell(0);
	td.innerHTML = "<input type='hidden' name='order' value='" + rowNum + "'/><input type='hidden' id='order_num"+rowNum+"' name='order_num"+rowNum+"' value='"+orderNum+"'>"+orderNum;
	td.id = "orderNumber"+rowNum;
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	var td = newTR.insertCell(1);
	td.innerHTML = "<input type='text' id='law"+rowNum+"' name='law"+rowNum+"' value='"+law2+"' size='50'>";
	td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	
	td = newTR.insertCell(2);
	td.innerHTML = "<input type='text' id='file_code"+rowNum+"' name='file_code"+rowNum+"' value='"+file_code2+"' size='30'>";
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	td = newTR.insertCell(3);
	td.innerHTML = "<input type='text' id='start_date"+rowNum+"' name='start_date"+rowNum+"' value='"+start_date2+"' size='30'>";
	td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	td = newTR.insertCell(4);
	td.innerHTML = "<input type='hidden' id='if_ok"+rowNum+"' name='if_ok"+rowNum+"' value='2' /> <img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
	document.getElementById("orderNum").value = parseInt(orderNum) + 1;
}


function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	//取删除行的主键ID
	var line = document.getElementById(lineId);		
	line.parentNode.removeChild(line);
	changeOrder();
}


function changeOrder(){
	debugger;
	var orders = document.getElementsByName("order");	
	for (var i=0;i<orders.length;i++){
		var order = orders[i].value;
		document.getElementById("orderNumber"+order).innerHTML = "<input type='hidden' name='order' value='" + order + "'/><input type='hidden' id='order_num"+order+"' name='order_num"+order+"' value='"+(i+1)+"'>"+(i+1);
	}
	document.getElementById("orderNum").value = orders.length + 1;
}

toEdit();
function toEdit(){
	//本单位
	var checkSql="select la.org_sub_id,la.hse_law_id,to_char(la.father_modifi_date,'yyyy-MM-dd hh24:mi:ss') father_modifi_date from bgp_hse_law la where la.bsflag='0' and la.org_sub_id='<%=org_sub_id%>'";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	//上级单位
	var checkSql2="select la.org_sub_id,la.hse_law_id,to_char(la.modifi_date,'yyyy-MM-dd hh24:mi:ss') modifi_date,de.order_num,de.law_name,de.file_code,de.start_date,de.if_ok from bgp_hse_law la left join bgp_hse_law_detail de on la.hse_law_id=de.hse_law_id and (de.if_ok='2' or de.if_ok is null) where la.bsflag='0' and la.org_sub_id='<%=father_org_id%>' order by to_number(de.order_num) asc";
    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'pageSize=300&querySql='+checkSql2);
	var datas2 = queryRet2.datas;
	
	debugger;	
	if(datas==null||datas==""){
		if(datas2==null||datas2==""){
			document.getElementById("showModifiDate").innerHTML = "<font color='red'>上级单位还未填写！</font>";
		}else{
			debugger;
			document.getElementById("modifi_date").value = datas2[0].modifi_date;
			for(var i=0;i<datas2.length;i++){
				toAddLine(
						datas2[i].order_num ? datas2[i].order_num : "",
						datas2[i].law_name ? datas2[i].law_name : "",
						datas2[i].file_code ? datas2[i].file_code : "",
						datas2[i].start_date ? datas2[i].start_date : "",
						datas2[i].if_ok ? datas2[i].if_ok : ""
						);
			}
		}
	}else{
		var hse_law_id = document.getElementById("hse_law_id").value = datas[0].hse_law_id;
		document.getElementById("org_sub_id").value = datas[0].org_sub_id;
		if(datas2!=null&&datas2!=""){
			var modifi_date = datas2[0].modifi_date;
			var father_modifi_date =  datas[0].father_modifi_date;
			debugger;
			if(modifi_date==father_modifi_date){
				
				document.getElementById("modifi_date").value = datas[0].father_modifi_date;
				
				var checkSql3="select de.order_num,de.law_name,de.file_code,de.start_date,de.if_ok from bgp_hse_law_detail de where de.hse_law_id='"+hse_law_id+"' and (de.if_ok in ('','1') or de.if_ok is null) order by to_number(de.order_num) asc";
			    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'pageSize=300&querySql='+checkSql3);
				var datas3 = queryRet3.datas;
				if(datas3==null||datas3==""){
				}else{
					for(var i=0;i<datas3.length;i++){
						toAddLine(
								datas3[i].order_num ? datas3[i].order_num : "",
								datas3[i].law_name ? datas3[i].law_name : "",
								datas3[i].file_code ? datas3[i].file_code : "",
								datas3[i].start_date ? datas3[i].start_date : "",
								datas3[i].if_ok ? datas3[i].if_ok : ""
								);
					}
				}
			}else{
				document.getElementById("showModifiDate").innerHTML = "<font color='red'>上级单位已更新，更新时间："+datas2[0].modifi_date+"</font>";
				document.getElementById("modifi_date").value = datas2[0].modifi_date;
				for(var i=0;i<datas2.length;i++){
					toAddLine(
							datas2[i].order_num ? datas2[i].order_num : "",
							datas2[i].law_name ? datas2[i].law_name : "",
							datas2[i].file_code ? datas2[i].file_code : "",
							datas2[i].start_date ? datas2[i].start_date : "",
							datas2[i].if_ok ? datas2[i].if_ok : ""
							);
				}
			}
		}
		
		
		
//		var checkSql4="select de.order_num,de.law_name,de.file_code,de.start_date,de.if_ok from bgp_hse_law_detail de where de.hse_law_id='"+hse_law_id+"' and de.if_ok='2' order by to_number(de.order_num) asc";
//	    var queryRet4 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'pageSize=300&querySql='+checkSql4);
//		var datas4 = queryRet4.datas;
//		
//		debugger;
//		if(datas4==null||datas4==""){
//		}else{
//			for(var i=0;i<datas4.length;i++){
//				toAddLineSelf(
//						datas4[i].order_num ? datas4[i].order_num : "",
//						datas4[i].law_name ? datas4[i].law_name : "",
//						datas4[i].file_code ? datas4[i].file_code : "",
//						datas4[i].start_date ? datas4[i].start_date : ""
//						);
//			}
//		}
	
	}
}


</script>
</html>
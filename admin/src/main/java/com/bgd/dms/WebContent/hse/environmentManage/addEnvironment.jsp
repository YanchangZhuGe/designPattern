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
	
	String hse_environment_id = resultMsg.getValue("hse_environment_id");
//	String hse_environment_id = "8ad891df39c7984e0139c79b25920018";
	UserToken user = OMSMVCUtil.getUserToken(request);
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(d);
	
	String status = "";
	String sql = "select * from bgp_hse_environment where hse_environment_id='"+hse_environment_id+"'";
	Map map  = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		status = (String)map.get("status");
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
<body >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_environment_id" name="hse_environment_id" value="<%=hse_environment_id%>"/>
<div id="new_table_box" >
  <div id="new_table_box_content" >
    <div id="new_table_box_bg" >
			<table id="showTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr style="height: 50px;">
					<td align="center" colspan="7"><span style="font-size: 28px;font-family: Arial;padding-top: 11px;margin-bottom: 30px;">环境统计月报</span></td>
				</tr>
				<tr align="center">
					<td>代码</td>
					<td>项目</td>
					<td>计量单位</td>
					<td>本月数据</td>
					<td>全年累计</td>
					<td>累计同比增减量</td>
					<td>累计同比±%</td>
				</tr>
			</table>
		</div>
		<div id="oper_div">
			<%if(JcdpMVCUtil.hasPermission("F_HSE_ENVIRON_001", request)||JcdpMVCUtil.hasPermission("F_HSE_ENVIRON_003", request)){ %>
			<span id="submitButt" class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
			<%} 
			if(JcdpMVCUtil.hasPermission("F_HSE_ENVIRON_002", request)||JcdpMVCUtil.hasPermission("F_HSE_ENVIRON_004", request)){%>
			<span class="pass_btn"><a href="#" onclick="passButton()"></a></span>
			<span class="nopass_btn"><a href="#" onclick="noPassButton()"></a></span>
			<%} %>
			<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
		</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";

toEdit();

function submitButton(){
//	var model_name = document.getElementById("model_name").value;
//	if(model_name==""){
//		alert("模板名称不能为空，请填写！");
//		return;
//	}
	
	var status = "<%=status%>";
	if(status=="2"||status=="3"){
		alert("该记录已经提交或者审核通过，不能保存 ！");
		return;
	}
	
	var form = document.getElementById("form");
	var ids ="";
	var orders = document.getElementsByName("order");
	//算出添加的多少行，并且value值
	for(var i=0;i<orders.length;i++){
		order = orders[i].value;
		if(ids!="") ids += ",";
		ids = ids + order;
	}
	
	form.action="<%=contextPath%>/hse/yxControl/addEnvironmentManage.srq?ids="+ids;
	form.submit();
}

function closeButton(){
	refreshData();
	newClose();
}

function passButton(){
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/yxControl/passMethod.srq";
	form.submit();
}


function toShowTable(hse_detail_id,project_name,month_data,year_data,increase_data,increase_percent,unit,level,total_flag){
	
	var table=document.getElementById("showTable");
	debugger;
	var tr = table.insertRow(table.rows.length);
	var rowNum = tr.rowIndex-1	
	var lineId = "row_" + rowNum;
//	tr.align="center";
	tr.id=lineId;
	var td = tr.insertCell(0);
	td.align="center";
	td.innerHTML = "<input type='hidden' id='order' name='order' value='"+rowNum+"'/><input type='hidden' id='hse_detail_id"+rowNum+"' name='hse_detail_id"+rowNum+"' value='"+hse_detail_id+"' />"+rowNum;
	
	td = tr.insertCell(1);
	var aaa = "";
	if(level=="2"){
		aaa = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	}else if(level=="3"){
		aaa = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	}else if(level=="4"){
		aaa = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	}
	td.innerHTML = aaa + project_name;
	
	td = tr.insertCell(2);
	td.align="center";
	td.innerHTML = unit;
	
	td = tr.insertCell(3);
	td.align="center";
	var bbb = month_data;
	if(unit=="-"){
		bbb = "-";
	}else{
		if(total_flag!="1"&&total_flag!="2"){
			bbb = "<input type='text' id='month_data"+rowNum+"' name='month_data"+rowNum+"' value='"+month_data+"' onchange='ifNumber(\""+rowNum+"\")'/>"
		}
	}
 	td.innerHTML = bbb;
	
	td = tr.insertCell(4);
	td.align="center";
	var ccc = year_data;
	if(unit=="-"||unit=="%"){
		ccc = "-";
	}
	td.innerHTML = ccc;
	
	td = tr.insertCell(5);
	td.align="center";
	if(unit=="-"||unit=="%"){
		increase_data = "-";
	}
	td.innerHTML = increase_data;
	debugger;
	td = tr.insertCell(6);
	td.align="center";
	if(unit=="-"||unit=="%"){
		increase_percent = "-";
	}else if(increase_percent!=""&&increase_percent!=null){
		increase_percent = increase_percent+"%";
	}
	td.innerHTML = increase_percent;
	
}


function ifNumber(rowNum){		
	
	
	var month_data = document.getElementById("month_data"+rowNum).value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
	
	if(month_data!=""){
		if(!re.test(month_data)){
		       alert("请填写正确的数字！");
		       return true;
		    }
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





function toEdit(){
		var checkSql="select level, t.* from bgp_hse_environment_detail t where t.hse_environment_id = '<%=hse_environment_id%>' start with t.father_id = '101' connect by prior t.hse_detail_id = t.father_id ";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize=100');
		var datas = queryRet.datas;
		if(datas==null||datas==""){
				
		}else{
			for (var i = 0; i<datas.length; i++) {
				toShowTable(
						datas[i].hse_detail_id ? datas[i].hse_detail_id : "",
						datas[i].project_name ? datas[i].project_name : "",
						datas[i].month_data ? datas[i].month_data : "",
						datas[i].year_data ? datas[i].year_data : "",
						datas[i].increase_data ? datas[i].increase_data : "",
						datas[i].increase_percent ? datas[i].increase_percent : "",
						datas[i].unit ? datas[i].unit : "",
						datas[i].level ? datas[i].level : "",
						datas[i].total_flag ? datas[i].total_flag : ""
					);
				}
			}
		}
</script>
</html>
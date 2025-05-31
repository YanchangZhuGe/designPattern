<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userId = user.getEmpId();
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
	String message = "";
	if (resultMsg != null) {
		message = resultMsg.getValue("message");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<style type="text/css">
body,table, td {font-size:12px;font-weight:normal;}
/* 重点：固定行头样式*/  
.scrollRowThead{BACKGROUND-COLOR: #AEC2E6;position: relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:0;}  
/* 重点：固定表头样式*/  
.scrollColThead {position: relative;top: expression(this.parentElement.parentElement.parentElement.scrollTop);z-index:2;}  
/* 行列交叉的地方*/  
.scrollCR{ z-index:3;}
/*div 外框*/  
.scrollDiv {height:420;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%; }  
/* 行头居中*/  
.scrollColThead td,.scrollColThead th{ text-align: center ;}  
/* 行头列头背景*/  
.scrollRowThead,.scrollColThead td,.scrollColThead th{background-color:#94B6E6;background-repeat:repeat;}  
/* 表格的线*/  
.scrolltable{border-bottom:1px solid #CCCCCC; border-right:1px solid #8EC2E6;}  
/* 单元格的线等*/  
.scrolltable td,.scrollTable th{border-left: 1px solid #CCCCCC; border-top: 0px solid #CCCCCC; padding: 2px;}
.scrollTable thead th{background-color:#94B6E6;position:relative;}
</style>
<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";
var projectInfoNo = "<%=projectInfoNo%>";
var projectName = "<%=projectName%>";
var exportRows = new Array();
var message = "<%=message%>";
if (message != "" && message != 'null') {
	alert(message);
}
var posarray = new Array("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");
var index3 = 0;
function initData(){
	//加载数据 满覆盖
	var retObj3 = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_3dws_design&option=project_info_no='"+projectInfoNo+"'%20and%20bsflag='0'%20and%20data_type ='3'&order=border_break_point");
	if(retObj3.datas != null){
		for(var i=0;i<retObj3.datas.length;i++){
			var record = retObj3.datas[i];
			index3++;
			var record_id = record.wa3d_design_no;
			var pos = record.border_break_point;
			var xAxis = record.point_x;
			var yAxis = record.point_y;
			var bsflag = "0";
			
			var tr = document.getElementById("table3").insertRow();
			if(i % 2 == 1){  
				tr.className = "odd";
			}else{
				tr.className = "even";
			}
			var td = tr.insertCell(0);
			td.innerHTML = '<input type="text" value="' + pos +'" size="4" readonly>';
			var td = tr.insertCell(1);
			td.align="center";
			td.innerHTML = '<input type="text" value="' + xAxis +'" size="13" readonly>';
			var td = tr.insertCell(2);
			td.align="center";
			td.innerHTML = '<input type="text" value="' + yAxis +'" size="13" readonly>';
			var exportRow = {};
			exportRow["1"] = pos;
			exportRow["2"] = xAxis;
			exportRow["3"] = yAxis;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("initRows3").value = retObj3.datas.length;
	}else{
		toAdd3();
	}
}

function toAdd3(){
	if(index3 > 25){
		return;
	}
	var line = document.getElementById("line_3_" + index3);
	if(line != null){
		line.style.display = 'block';
		index3++;
		return;
	}
	var tr = document.getElementById("table3").insertRow();
	tr.id = "line_3_" + index3;
	var td = tr.insertCell(0);
	var posname = posarray[index3] + "2";
	td.innerHTML = '<input type="text" name="pos_3_' + index3 + '" value="'+posname +'" size="4" readonly>';
	var td = tr.insertCell(1);
	td.align="center";
	td.innerHTML = '<input type="text" name="xAxis_3_' + index3 +'" size="13">';
	var td = tr.insertCell(2);
	td.align="center";
	td.innerHTML = '<input type="text" name="yAxis_3_' + index3 +'" size="13">';
	index3++;
}
function importFile(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importBorderDesign.srq?isSea=y";
		document.getElementById("fileForm").submit();
	}
}
function checkFile(filename){
	var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
	type=type.toUpperCase();
	if(type=="XLS" || type=="XLSX"){
	   return true;
	}
	else{
	   alert("上传类型有误，请上传EXCLE文件！");
	   return false;
	}
}
function toDownload(){
	window.location.href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/dBorder/shborderDesign.xls&filename=shborderDesign.xls";
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "shborderDesign";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}

function frameSize(){
	setTabBoxHeight();
}

frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})
</script>
<title>工区设计边框</title>
</head>
<body style="overflow-y: auto; overflow-x: auto; height: 600px" onload="initData()">
	<form action="" id="fileForm" method="post"
		enctype="multipart/form-data">
		<table border="0" cellpadding="0" cellspacing="0" class="form_info"
			width="100%" style="margin-top: 0px;">
			<tr class="even" style="BACKGROUND-COLOR: #fff;">
				<td colspan="12" align="right"><font color=red>选择文件：</font> 
					<input type="file" id="fileName" name="fileName" size="30" /> 
					<auth:ListButton functionId="" css="dr" event="onclick='importFile()'" title="导入" />
					<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download" />
					<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel" />
				</td>
			</tr>
		</table>
	</form>
	<table width="100%">
		<tr>
			<td align="center"><font size="3"><%=projectName%>边框坐标</font></td>
		</tr>
	</table>
	<table width="100%">
		<tr class="">
			<td width="25%" align="center">偏前满覆盖边框</td>
		</tr>
		<tr>
			<td width="25%" valign="top" align="center">
				<table id="table3" width="100%" border="1">
					<input type="hidden" id="initRows3" value="0"/>
					<thead>
						<tr class="scrollColThead">
							<td width="20%">边界拐点</td>
							<td width="40%">&nbsp;X坐标&nbsp;</td>
							<td width="40%">&nbsp;Y坐标&nbsp;&nbsp;</td>
						</tr>
					</thead>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>
<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	if(resultMsg != null){
		message = resultMsg.getValue("message");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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
var message = "<%=message%>";

if(message != "" && message != 'null'){
	alert(message);
}


var exportRows = new Array();

function importFile(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineDesign.srq?workMethod=3&isSea=y";
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
	window.location.href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/lineDesign/shlinedesign.xls&filename=shlinedesign.xls";
}
function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "shlinedesign";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}

function deleteTableTr(tableID){
	var tb = document.getElementById(tableID);
    var rowNum=tb.rows.length;
    for (i=1;i<rowNum;i++)
    {
    	tb.deleteRow(i);
	    rowNum=rowNum-1;
	    i=i-1;
	}
}
function insetSpaceLine(start,rows){
	 for(i=start; i<rows; i++){
	 	var tr = document.getElementById("lineDesignTb").insertRow();
		if(i % 2 == 1){  
			tr.className = "odd";
		}else{
			tr.className = "even";
		}
		var td = tr.insertCell(0);
		td.innerHTML = "&nbsp;";
		var td = tr.insertCell(1);
		td.innerHTML = "";
		var td = tr.insertCell(2);
		td.innerHTML = "";
		var td = tr.insertCell(3);
		td.innerHTML = "";
		var td = tr.insertCell(4);
		td.innerHTML = "";
		var td = tr.insertCell(5);
		td.innerHTML = "";
		var td = tr.insertCell(6);
		td.innerHTML = "";
		var td = tr.insertCell(7);
		td.innerHTML = "";
	 }
}
function refreshData(){
	deleteTableTr("lineDesignTb");
	var retObj = jcdpCallService("LineGroupDesignSrv", "queryWa3dLineDesign", "projectInfoNo="+projectInfoNo);
	if(retObj.lineDesignList != null){
		for(var i=0;i<retObj.lineDesignList.length;i++){
			var record = retObj.lineDesignList[i];
			var tr = document.getElementById("lineDesignTb").insertRow();	
			if(i % 2 == 1){  
            	tr.className = "odd";
			}else{ 
				tr.className = "even";
			}
			
			//线束号
			var td = tr.insertCell(0);
			td.innerHTML = record.line_group_id + "&nbsp;&nbsp;";
			//起始炮点点号
			var td = tr.insertCell(1);
			td.innerHTML = record.shot_line_start_loc + "&nbsp;&nbsp;";
			//终止炮点点号
			var td = tr.insertCell(2);
			td.innerHTML = record.shot_line_end_loc + "&nbsp;&nbsp;";
			//测线设计长度
			var td = tr.insertCell(3);
			td.innerHTML = record.measure_design_len + "&nbsp;&nbsp;";
			//电缆数量及长度
			var td = tr.insertCell(4);
			td.innerHTML = record.cable_num_len + "&nbsp;&nbsp;";
			//炮点间隔
			var td = tr.insertCell(5);
			td.innerHTML = record.shot_interval + "&nbsp;&nbsp;";
			//检波点间距
			var td = tr.insertCell(6);
			td.innerHTML = record.receiving_track_num + "&nbsp;&nbsp;";
			//备 注
			var td = tr.insertCell(7);
			td.innerHTML = record.notes + "&nbsp;&nbsp;";
			
			
			var exportRow = {};
			exportRow["1"] = record.line_group_id
			exportRow["2"] = record.shot_line_start_loc;
			exportRow["3"] = record.shot_line_end_loc;
			exportRow["4"] = record.measure_design_len;
			exportRow["5"] = record.cable_num_len;
			exportRow["6"] = record.shot_interval;
			exportRow["7"] = record.receiving_track_num;
			exportRow["8"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
		if(retObj.lineDesignList.length < 10){
			// 补空行
			var start = retObj.lineDesignList.length;
			insetSpaceLine(start,10);
		}
	}else{
		insetSpaceLine(0,10);
	}
}
</script>
<title>线束设计</title>
<body style="background: #fff; overflow-y: auto" onload="refreshData()">
	<form action="" id="fileForm" method="post" enctype="multipart/form-data">
		<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top: 0px;">
			<tr class="even" style="BACKGROUND-COLOR: #fff;">
				<td colspan="12" align="right">
					<font color=red>选择文件：</font> <input type="file" id="fileName" name="fileName" size="30" />
					<auth:ListButton functionId="" css="dr" event="onclick='importFile()'" title="导入"></auth:ListButton>
					<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton> 
					<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
				</td>
			</tr>
		</table>
	</form>
	<table width="100%">
		<tr>
			<td align="center"><font size="3"><%=projectName%>勘探线束设计表</font></td>
		</tr>
	</table>
	<div id="scrollDiv" class="scrollDiv">
		<table id="lineDesignTb" width="100%" border="0" cellspacing="0"
			align="center" cellpadding="0" class="scrolltable">
			<thead>
				<tr class="scrollColThead">
					<td class="bt_info_even">测线号</td>
					<td class="bt_info_odd">起始炮点点号</td>
					<td class="bt_info_even">终止炮点点号</td>
					<td class="bt_info_odd">测线设计长度</td>
					<td class="bt_info_even">电缆数量及长度</td>
					<td class="bt_info_odd">炮点间隔</td>
					<td class="bt_info_even">检波点间距</td>
					<td class="bt_info_odd">备注</td>
				</tr>
			</thead>
		</table>
	</div>
</body>
</html>
</body>
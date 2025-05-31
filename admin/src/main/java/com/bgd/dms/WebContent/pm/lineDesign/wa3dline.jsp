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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getSubOrgIDofAffordOrg();
	String message = "";
	if(resultMsg != null){
		message = resultMsg.getValue("message");
	}
	Date nowDate= new Date();
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy");
	String nowYear =  dateFormat.format(nowDate);
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
var exportRows = new Array();

var message = "<%=message%>";
if(message != "" && message != 'null'){
	alert(message);
}

function importFile(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importShLineDesign.srq?";
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
            //序号
            //var td = tr.insertCell(0);
			//td.innerHTML = i+1;
			//td.innerHTML="<input type='checkbox' name='rdo_entity_id' value='"+record.group_design_no+"' id='rdo_entity_id_"+i+"'>";
			
			//线束号
			var td = tr.insertCell(0);
			td.innerHTML = record.line_group_id + "&nbsp;&nbsp;";
			//起始接收线号
			var td = tr.insertCell(1);
			td.innerHTML = record.receiving_line_start_line + "&nbsp;&nbsp;";
			//终止接收线号
			var td = tr.insertCell(2);
			td.innerHTML = record.receiving_line_end_line + "&nbsp;&nbsp;";
			//起始接收点点号
			var td = tr.insertCell(3);
			td.innerHTML = record.receiving_line_start_loc + "&nbsp;&nbsp;";
			//终止接收点 点号
			var td = tr.insertCell(4);
			td.innerHTML = record.receiving_line_end_loc + "&nbsp;&nbsp;";
			//起始炮线号
			var td = tr.insertCell(5);
			td.innerHTML = record.shot_line_start_line + "&nbsp;&nbsp;";
			//终止炮线号
			var td = tr.insertCell(6);
			td.innerHTML = record.shot_line_end_line + "&nbsp;&nbsp;";
			//起始炮点点号
			var td = tr.insertCell(7);
			td.innerHTML = record.shot_line_start_loc + "&nbsp;&nbsp;";
			//终止炮点点号
			var td = tr.insertCell(8);
			td.innerHTML = record.shot_line_end_loc + "&nbsp;&nbsp;";
			//炮排数
			var td = tr.insertCell(9);
			td.innerHTML = record.shot_array_num + "&nbsp;&nbsp;";
			//束线炮数
			var td = tr.insertCell(10);
			td.innerHTML = record.group_design_shot_num + "&nbsp;&nbsp;";
			//束线加密炮数
			var td = tr.insertCell(11);
			td.innerHTML = record.design_infill_sp_num + "&nbsp;&nbsp;";
			//设计总炮数
			var td = tr.insertCell(12);
			td.innerHTML = record.design_sp_num + "&nbsp;&nbsp;";
			//接收线数
			var td = tr.insertCell(13);
			td.innerHTML = record.receiveing_line_num + "&nbsp;&nbsp;";
			//检波点数
			var td = tr.insertCell(14);
			td.innerHTML = record.geophone_point + "&nbsp;&nbsp;";
			//偏前满覆盖面积
			var td = tr.insertCell(15);
			td.innerHTML = record.actual_fullfold_area + "&nbsp;&nbsp;";
			//炮点面积
			var td = tr.insertCell(16);
			td.innerHTML = record.shot_area + "&nbsp;&nbsp;";
			//检波点面积
			var td = tr.insertCell(17);
			td.innerHTML = record.geophone_area + "&nbsp;&nbsp;";
			//检波线长度
			var td = tr.insertCell(18);
			td.innerHTML = record.geophone_line_len + "&nbsp;&nbsp;";
			//炮线长度
			var td = tr.insertCell(19);
			td.innerHTML = record.shot_line_len + "&nbsp;&nbsp;";
			//总物理点数
			var td = tr.insertCell(20);
			td.innerHTML = record.total_point_num + "&nbsp;&nbsp;";
			//表层调查点数
			var td = tr.insertCell(21);
			td.innerHTML = record.design_surface_3d_sp_num + "&nbsp;&nbsp;";
			//备注
			var td = tr.insertCell(22);
			td.innerHTML = record.notes + "&nbsp;&nbsp;";
			
			var exportRow = {};
			exportRow["1"] = record.line_group_id
			exportRow["2"] = record.receiving_line_start_line;
			exportRow["3"] = record.receiving_line_end_line;
			exportRow["4"] = record.receiving_line_start_loc;
			exportRow["5"] = record.receiving_line_end_loc;
			exportRow["6"] = record.shot_line_start_line;
			exportRow["7"] = record.shot_line_end_line;
			exportRow["8"] = record.shot_line_start_loc;
			exportRow["9"] = record.shot_line_end_loc;
			exportRow["10"] = record.shot_array_num;
			exportRow["11"] = record.group_design_shot_num;
			exportRow["12"] = record.design_infill_sp_num;
			exportRow["13"] = record.design_sp_num;
			exportRow["14"] = record.receiveing_line_num;
			exportRow["15"] = record.geophone_point;
			exportRow["16"] = record.actual_fullfold_area;
			exportRow["17"] = record.shot_area;
			exportRow["18"] = record.geophone_area;
			exportRow["19"] = record.geophone_line_len;
			exportRow["20"] = record.shot_line_len;
			exportRow["21"] = record.total_point_num;
			exportRow["22"] = record.design_surface_3d_sp_num;
			exportRow["23"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
		if(retObj.lineDesignList.length < 10){
			// 补空行
			var start = retObj.lineDesignList.length;
			//var rows = 10 - retObj.lineDesignList.length;
			
			insetSpaceLine(start,10);
		}
	}else{
		// 补空行
		insetSpaceLine(0,10);
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
		//var td = tr.insertCell(0);
		//td.innerHTML="<input type='checkbox' name='rdo_entity_id' value='' id='rdo_entity_id_"+i+"' disabled='true'>";
		//td.innerHTML=i+1;
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
		var td = tr.insertCell(8);
		td.innerHTML = "";
		var td = tr.insertCell(9);
		td.innerHTML = "";
		var td = tr.insertCell(10);
		td.innerHTML = "";
		var td = tr.insertCell(11);
		td.innerHTML = "";
		var td = tr.insertCell(12);
		td.innerHTML = "";
		var td = tr.insertCell(13);
		td.innerHTML = "";
		var td = tr.insertCell(14);
		td.innerHTML = "";
		var td = tr.insertCell(15);
		td.innerHTML = "";
		var td = tr.insertCell(16);
		td.innerHTML = "";
		var td = tr.insertCell(17);
		td.innerHTML = "";
		var td = tr.insertCell(18);
		td.innerHTML = "";
		var td = tr.insertCell(19);
		td.innerHTML = "";
		var td = tr.insertCell(20);
		td.innerHTML = "";
		var td = tr.insertCell(21);
		td.innerHTML = "";
		var td = tr.insertCell(22);
		td.innerHTML = "";
	 }
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
	
function toDelete(){
	var cknum = 0;
	var objCkbox = document.getElementsByName('rdo_entity_id');
	var ids="";
	for(var i = 0; i < objCkbox.length; i++)
	{
    	if(objCkbox.item(i).checked == true){
    		cknum++;
    		//alert(objCkbox.item(i).value);
    		ids += ","+objCkbox.item(i).value;
    	}
	}
	if(cknum>0){
		//alert(ids.substr(1));
		ids = ids.substr(1);
	}
	else{
		alert("没有选择行!");
		return;
	}

	if(confirm('确定要删除吗?')){  
		var retObj = jcdpCallService("LineGroupDesignSrv", "deleteLineGroupDesign", "groupDesignNo="+ids);
		queryData(cruConfig.currentPage);
	}
	if(retObj.actionStatus=='ok'){
		alert("删除操作成功!");
		refreshData();
	}
}

function toDownload(){
	window.location.href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/lineDesign/wa3dlinedesign.xls&filename=wa3dlinedesign.xls";
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "wa3dlinedesign";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}
</script>
<title>线束设计</title>
</head>
<body style="background:#fff;overflow-y: auto" onload="refreshData()">
	<form action="" id="fileForm" method="post" enctype="multipart/form-data">
	<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;" >
	    <tr class="even" style="BACKGROUND-COLOR:#fff;">
	      			<td colspan="12" align="right">
	      			<font color=red>选择文件：</font>
	      	        <input type="file"  id="fileName" name="fileName" size="30"/>
	      	      <!-- <a style="color:red;" href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/lineDesign/wa3dlinedesign.xls&filename=三维勘探线束设计表.xls">下载模板</a>&nbsp;-->
	      	      <auth:ListButton functionId="" css="dr" event="onclick='importFile()'" title="导入"></auth:ListButton>
	      	      <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>   	       
	      	</td>
	    </tr>
	</table>
	</form>
<table width="100%">
<tr><td align="center"><font size="3"><%=projectName%>勘探线束设计表</font></td></tr></table>
<div id="scrollDiv" class="scrollDiv">
<table id="lineDesignTb" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
	<thead>
		<tr class="scrollColThead">
		<td class="bt_info_even">测线<br/>号</td>
		<td class="bt_info_odd">起始接收<br/>线号</td>
		<td class="bt_info_even">终止接收<br/>线号</td>
		<td class="bt_info_odd">起始接收<br/>点点号</td>
		<td class="bt_info_even">终止接收<br/>点点号</td>
		<td class="bt_info_odd">起始炮<br/>线号</td>
		<td class="bt_info_even">终止炮<br/>线号</td>
		<td class="bt_info_odd">起始炮<br/>点点号</td>
		<td class="bt_info_even">终止炮<br/>点点号</td>
		<td class="bt_info_odd">炮排<br/>数</td>
		<td class="bt_info_even">束线<br/>炮数</td>
		<td class="bt_info_odd">束线加密<br/>炮数</td>
		<td class="bt_info_even">设计总<br/>炮数</td>
		<td class="bt_info_odd">接收<br/>线数</td>
		<td class="bt_info_even">检波<br/>点数</td>
		<td class="bt_info_odd">偏前满<br/>覆盖面积</td>
		<td class="bt_info_even">炮点<br/>面积</td>
		<td class="bt_info_odd">检波点<br/>面积</td>
		<td class="bt_info_even">检波线长度</td>
		<td class="bt_info_odd">炮线长度</td>		
		<td class="bt_info_even">总物理<br/>点数</td>
		<td class="bt_info_odd">表层调查<br/>点数</td>
		<td class="bt_info_even">备注</td>
	</tr>
   </thead>
</table>
</div>
</body>
</html>
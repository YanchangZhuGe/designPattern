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
.tdNoWrap{white-space:nowrap;}
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
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importTechnologyComplete.srq?workMethod=03";
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
	var retObj = jcdpCallService("LineGroupDesignSrv", "queryTechnologyComplete", "projectInfoNo="+projectInfoNo);
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
			//td.innerHTML="<input type='checkbox' name='rdo_entity_id' value='"+record.object_id+"' id='rdo_entity_id_"+i+"'>";
			
			//测线号
			var td = tr.insertCell(0);
			td.className = "tdNoWrap";
			td.innerHTML = "&nbsp;" + record.target_zone_name + "&nbsp;&nbsp;";;

			//满覆盖首桩号
			var td = tr.insertCell(1);
			td.innerHTML = "&nbsp;" + record.target_zone_depth + "&nbsp;&nbsp;&nbsp;";
			//满覆盖首桩X坐标
			var td = tr.insertCell(2);
			td.innerHTML = "&nbsp;" + record.resolvable_throw_profile + "&nbsp;&nbsp;&nbsp;";
			//满覆盖首桩Y坐标
			var td = tr.insertCell(3);
			td.innerHTML = "&nbsp;" + record.resolvable_thick + "&nbsp;&nbsp;&nbsp;";
			//满覆盖尾桩号
			var td = tr.insertCell(4);
			td.innerHTML = "&nbsp;" + record.basic_frequency + "&nbsp;&nbsp;&nbsp;";
			//满覆盖尾桩X坐标
			var td = tr.insertCell(5);
			td.innerHTML = "&nbsp;" + record.bandwidth + "&nbsp;&nbsp;&nbsp;";
			  
			//备注
			var td = tr.insertCell(6);
			td.innerHTML = "&nbsp;" + record.notes + "&nbsp;&nbsp;";
			
			
			var exportRow = {};
			exportRow["1"] = record.target_zone_name 
			exportRow["2"] = record.target_zone_depth;
			exportRow["3"] = record.resolvable_throw_profile;
			exportRow["4"] = record.resolvable_thick;
			exportRow["5"] = record.basic_frequency;
			exportRow["6"] = record.bandwidth;		
			exportRow["7"] = record.notes;
			
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
    		ids = objCkbox.item(i).value;
    		break;
    	}
	}
	if(cknum>0){
		
	}
	else{
		alert("没有选择行!");
	}
	if(confirm('确定要删除吗?')){  
		var retObj = jcdpCallService("LineGroupDesignSrv", "deleteWa2dLineDesign", "objectId="+ids);
		queryData(cruConfig.currentPage);
	}
	if(retObj.actionStatus=='ok'){
		alert("删除操作成功!");
		refreshData();
	}
}
function toDownload(){
	window.location.href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/technologyComplete/technologyComplete.xls&filename=technologyComplete.xls";
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "technologyComplete";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}
</script>
<title>技术指标完成情况</title>
</head>
<body style="background:#cdddef;overflow-y:auto;overflow-x:auto;" onload="refreshData()" width="800px"> 
	<form action="" id="fileForm" method="post" enctype="multipart/form-data">
	<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;" >
	    <tr class="even" style="BACKGROUND-COLOR:#cdddef;">
	      			<td colspan="12" align="right">
	      			<font color=red>选择文件：</font>
	      	        <input type="file"  id="fileName" name="fileName" size="30"/>
	      	   
	      	      <auth:ListButton functionId="" css="dr" event="onclick='importFile()'" title="导入"></auth:ListButton>
	      	      <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>   	       
	      	</td>
	    </tr>
	</table>
	</form>
<table width="100%">
<tr><td align="center"><font size="3">  <%=projectName%>完成情况表</font></td></tr></table>
<div id="scrollDiv" class="scrollDiv">
<table id="lineDesignTb" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
	<thead>
		<tr class="scrollColThead">
		<td class="bt_info_even" nowrap>&nbsp;&nbsp;主要目的层名称&nbsp;&nbsp;</td> 
		<td class="bt_info_odd">目的层埋深(m)</td>
		<td class="bt_info_even" nowrap>可分辨断距(m)</td>
		<td class="bt_info_odd" nowrap>可分辨厚度(m)</td>
		<td class="bt_info_even">主频(Hz)</td>
		<td class="bt_info_odd" nowrap>频宽(Hz)</td>	 
		<td class="bt_info_even">备 注</td>
	</tr>
	</thead>
</table>
</div>
</body>
</html>
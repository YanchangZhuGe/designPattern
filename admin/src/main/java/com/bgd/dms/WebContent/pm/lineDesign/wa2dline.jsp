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
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineDesign.srq?workMethod=2";
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
	var retObj = jcdpCallService("LineGroupDesignSrv", "queryWa2dLineDesign", "projectInfoNo="+projectInfoNo);
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
			td.innerHTML = "&nbsp;" + record.line_group_id + "&nbsp;&nbsp;";;
			//检波点首桩号
			var td = tr.insertCell(1);
			td.innerHTML = "&nbsp;" + record.geophone_start_pile + "&nbsp;&nbsp;&nbsp;";
			//检波点首桩X坐标
			var td = tr.insertCell(2);
			td.innerHTML = "&nbsp;" + record.geophone_start_point_x + "&nbsp;&nbsp;&nbsp;";
			//检波点首桩Y坐标
			var td = tr.insertCell(3);
			td.innerHTML = "&nbsp;" + record.geophone_start_point_y + "&nbsp;&nbsp;&nbsp;";
			//炮点首桩号
			var td = tr.insertCell(4);
			td.innerHTML = "&nbsp;" + record.shot_start_pile + "&nbsp;&nbsp;&nbsp;";
			//炮点首桩X坐标
			var td = tr.insertCell(5);
			td.innerHTML = "&nbsp;" + record.shot_start_point_x + "&nbsp;&nbsp;&nbsp;";
			//炮点首桩Y坐标
			var td = tr.insertCell(6);
			td.innerHTML = "&nbsp;" + record.shot_start_point_y + "&nbsp;&nbsp;&nbsp;";
			//满覆盖首桩号
			var td = tr.insertCell(7);
			td.innerHTML = "&nbsp;" + record.fullfold_start_pile + "&nbsp;&nbsp;&nbsp;";
			//满覆盖首桩X坐标
			var td = tr.insertCell(8);
			td.innerHTML = "&nbsp;" + record.fullfold_start_point_x + "&nbsp;&nbsp;&nbsp;";
			//满覆盖首桩Y坐标
			var td = tr.insertCell(9);
			td.innerHTML = "&nbsp;" + record.fullfold_start_point_y + "&nbsp;&nbsp;&nbsp;";
			//满覆盖尾桩号
			var td = tr.insertCell(10);
			td.innerHTML = "&nbsp;" + record.fullfold_end_pile + "&nbsp;&nbsp;&nbsp;";
			//满覆盖尾桩X坐标
			var td = tr.insertCell(11);
			td.innerHTML = "&nbsp;" + record.fullfold_end_point_x + "&nbsp;&nbsp;&nbsp;";
			//满覆盖尾桩Y坐标
			var td = tr.insertCell(12);
			td.innerHTML = "&nbsp;" + record.fullfold_end_point_y + "&nbsp;&nbsp;&nbsp;";
			//炮点尾桩号
			var td = tr.insertCell(13);
			td.innerHTML = "&nbsp;" + record.shot_end_pile + "&nbsp;&nbsp;&nbsp;";
			//炮点尾桩X坐标
			var td = tr.insertCell(14);
			td.innerHTML = "&nbsp;" + record.shot_end_point_x + "&nbsp;&nbsp;&nbsp;";
			//炮点尾桩Y坐标
			var td = tr.insertCell(15);
			td.innerHTML = "&nbsp;" + record.shot_end_point_y + "&nbsp;&nbsp;&nbsp;";
			//检波点尾桩号
			var td = tr.insertCell(16);
			td.innerHTML = "&nbsp;" + record.geophone_end_pile + "&nbsp;&nbsp;&nbsp;";
			//检波点尾桩X坐标
			var td = tr.insertCell(17);
			td.innerHTML = "&nbsp;" + record.geophone_end_point_x + "&nbsp;&nbsp;&nbsp;";
			//检波点尾桩Y坐标
			var td = tr.insertCell(18);
			td.innerHTML = "&nbsp;" + record.geophone_end_point_y + "&nbsp;&nbsp;&nbsp;";
			
			 
			//一次覆盖首桩号
			var td = tr.insertCell(19);
			td.innerHTML = "&nbsp;" + record.first_number + "&nbsp;&nbsp;";
			//X坐标
			var td = tr.insertCell(20);
			td.innerHTML = "&nbsp;" + record.x_coordinate + "&nbsp;&nbsp;";
			//Y坐标
			var td = tr.insertCell(21);
			td.innerHTML = "&nbsp;" + record.y_coordinate + "&nbsp;&nbsp;";
			
			//一次覆盖尾桩号
			var td = tr.insertCell(22);
			td.innerHTML = "&nbsp;" + record.last_number + "&nbsp;&nbsp;";
			//X坐标
			var td = tr.insertCell(23);
			td.innerHTML = "&nbsp;" + record.last_x_coordinate + "&nbsp;&nbsp;";
			//Y坐标
			var td = tr.insertCell(24);
			td.innerHTML = "&nbsp;" + record.last_y_coordinate + "&nbsp;&nbsp;";
			
			//资料长度(km)
			var td = tr.insertCell(25);
			td.innerHTML = "&nbsp;" + record.data_workload + "&nbsp;&nbsp;";
			//微测井点数(点)
			var td = tr.insertCell(26);
			td.innerHTML = "&nbsp;" + record.micro_measue_num + "&nbsp;&nbsp;";
			//小折射点数(点)
			var td = tr.insertCell(27);
			td.innerHTML = "&nbsp;" + record.small_regraction_num + "&nbsp;&nbsp;";
			//大折射点数(点)
			var td = tr.insertCell(28);
			td.innerHTML = "&nbsp;" + record.big_regraction_num + "&nbsp;&nbsp;";			
			
			
			
			//满覆盖长度
			var td = tr.insertCell(29);
			td.innerHTML = "&nbsp;" + record.fullfold_len + "&nbsp;&nbsp;";			
			
			//实物工作量
			var td = tr.insertCell(30);
			td.innerHTML = "&nbsp;" + record.physical_workload + "&nbsp;&nbsp;";
			//炮线长度
			var td = tr.insertCell(31);
			td.innerHTML = "&nbsp;" + record.shot_line_len + "&nbsp;&nbsp;";
			//炮点个数
			var td = tr.insertCell(32);
			td.innerHTML = "&nbsp;" + record.sp_num + "&nbsp;&nbsp;";
			//检波线长度
			var td = tr.insertCell(33);
			td.innerHTML = "&nbsp;" + record.measuring_line_len + "&nbsp;&nbsp;";
			//检波点个数
			var td = tr.insertCell(34);
			td.innerHTML = "&nbsp;" + record.geophone_num + "&nbsp;&nbsp;";
			//备注
			var td = tr.insertCell(35);
			td.innerHTML = "&nbsp;" + record.notes + "&nbsp;&nbsp;";
			
			
			
			var exportRow = {};
			exportRow["1"] = record.line_group_id
			exportRow["2"] = record.geophone_start_pile;
			exportRow["3"] = record.geophone_start_point_x;
			exportRow["4"] = record.geophone_start_point_y;
			exportRow["5"] = record.shot_start_pile;
			exportRow["6"] = record.shot_start_point_x;
			exportRow["7"] = record.shot_start_point_y;
			exportRow["8"] = record.fullfold_start_pile;
			exportRow["9"] = record.fullfold_start_point_x;
			exportRow["10"] = record.fullfold_start_point_y;
			exportRow["11"] = record.fullfold_end_pile;
			exportRow["12"] = record.fullfold_end_point_x;
			exportRow["13"] = record.fullfold_end_point_y;
			exportRow["14"] = record.shot_end_pile;
			exportRow["15"] = record.shot_end_point_x;
			exportRow["16"] = record.shot_end_point_y;
			exportRow["17"] = record.geophone_end_pile;
			exportRow["18"] = record.geophone_end_point_x;
			exportRow["19"] = record.geophone_end_point_y;
			
			exportRow["20"] = record.first_number;
			exportRow["21"] = record.x_coordinate;
			exportRow["22"] = record.y_coordinate;
			exportRow["23"] = record.last_number;
			exportRow["24"] = record.last_x_coordinate;
			exportRow["25"] = record.last_y_coordinate;
			
			exportRow["26"] = record.data_workload;
			exportRow["27"] = record.micro_measue_num;
			exportRow["28"] = record.small_regraction_num;
			exportRow["29"] = record.big_regraction_num;
			
			exportRow["30"] = record.fullfold_len;
			exportRow["31"] = record.physical_workload;
			exportRow["32"] = record.shot_line_len;
			exportRow["33"] = record.sp_num;
			exportRow["34"] = record.measuring_line_len;
			exportRow["35"] = record.geophone_num;
			exportRow["36"] = record.notes;
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
		var td = tr.insertCell(23);
		td.innerHTML = "";
		var td = tr.insertCell(24);
		td.innerHTML = "";
		var td = tr.insertCell(25);
		td.innerHTML = "";
		

		var td = tr.insertCell(26);
		td.innerHTML = "";
		var td = tr.insertCell(27);
		td.innerHTML = "";
		var td = tr.insertCell(28);
		td.innerHTML = "";
		var td = tr.insertCell(29);
		td.innerHTML = "";
		var td = tr.insertCell(30);
		td.innerHTML = "";
		var td = tr.insertCell(31);
		td.innerHTML = "";
		var td = tr.insertCell(32);
		td.innerHTML = "";
		
		var td = tr.insertCell(33);
		td.innerHTML = "";
		var td = tr.insertCell(34);
		td.innerHTML = "";
		var td = tr.insertCell(35);
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
	window.location.href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/lineDesign/wa2dlinedesign.xls&filename=wa2dlinedesign.xls";
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "wa2dlinedesign";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}
</script>
<title>线束设计</title>
</head>
<body style="background:#cdddef;overflow-y:auto;overflow-x:auto;" onload="refreshData()" width="950px"> 

	<form action="" id="fileForm" method="post" enctype="multipart/form-data">
	<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;" >
	    <tr class="even" style="BACKGROUND-COLOR:#fff;">
	      			<td colspan="12" align="right">
	      			<font color=red>选择文件：</font>
	      	        <input type="file"  id="fileName" name="fileName" size="30"/>
	      	      <!--<a style="color:red;" href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/lineDesign/wa2dlinedesign.xls&filename=二维测线部署表.xls">下载模板</a>&nbsp;-->
	      	      <auth:ListButton functionId="" css="dr" event="onclick='importFile()'" title="导入"></auth:ListButton>
	      	      <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>   	       
	      	</td>
	    </tr>
	</table>
	</form>
<table width="100%">
<tr><td align="center"><font size="3">  <%=projectName%>测线部署表</font></td></tr></table>
<div id="scrollDiv" class="scrollDiv">
<table id="lineDesignTb" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
	<thead>
		<tr class="scrollColThead">
		<td class="bt_info_even" nowrap>&nbsp;&nbsp;测线号&nbsp;&nbsp;</td>
		<td class="bt_info_odd" nowrap>检波点<br>首桩号</td>
		<td class="bt_info_even" nowrap>X坐标</td>
		<td class="bt_info_odd" nowrap>Y坐标</td>
		<td class="bt_info_even" nowrap>炮点首桩号</td>
		<td class="bt_info_odd" nowrap>X坐标</td>
		<td class="bt_info_even" nowrap>Y坐标</td>
		<td class="bt_info_odd" nowrap>满覆盖首桩号</td>
		<td class="bt_info_even" nowrap>X坐标</td>
		<td class="bt_info_odd" nowrap>Y坐标</td>
		<td class="bt_info_even" nowrap>满覆盖尾桩号</td>
		<td class="bt_info_odd" nowrap>X坐标</td>
		<td class="bt_info_even" nowrap>Y坐标</td>
		<td class="bt_info_odd" nowrap>炮点尾桩号</td>
		<td class="bt_info_even" nowrap>X坐标</td>
		<td class="bt_info_odd" nowrap>Y坐标</td>
		<td class="bt_info_even" nowrap>检波点尾桩号</td>
		<td class="bt_info_odd" nowrap>X坐标</td>
		<td class="bt_info_even" nowrap>Y坐标</td>
		
        <td class="bt_info_odd"  nowrap>一次覆盖首桩号</td>
		<td class="bt_info_even" nowrap>X坐标</td>
		<td class="bt_info_odd" nowrap>Y坐标</td>
		
		<td class="bt_info_odd" nowrap >一次覆盖尾桩号</td>
		<td class="bt_info_even" nowrap>X坐标</td>
		<td class="bt_info_odd" nowrap>Y坐标</td>
		
		<td class="bt_info_even"  nowrap>资料长度(km)</td>
		<td class="bt_info_odd"  nowrap>微测井点数(点)</td>
		<td class="bt_info_even" nowrap >小折射点数(点)</td>
		<td class="bt_info_odd"  nowrap>大折射点数(点)</td>
						
		<td class="bt_info_even" >满覆盖长度(km)</td>
		<td class="bt_info_odd">实物工作量(km)</td>
		<td class="bt_info_even">炮线长度(km)</td>
		<td class="bt_info_odd">炮数(个)</td>
		<td class="bt_info_even">检波线长度(km)</td>
		<td class="bt_info_odd">检波点数(个)</td>
		<td class="bt_info_even">备 注</td>
	</tr>
	</thead>
</table>
</div>
</body>
</html>
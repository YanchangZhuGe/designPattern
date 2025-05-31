<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
%>
<html>
<head>
<title>项目情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
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
.scrollDiv {height:80%;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%; }  
/* 行头居中*/  
.scrollColThead td,.scrollColThead th{ text-align: center ;}  
/* 行头列头背景*/  
.scrollRowThead,.scrollColThead td,.scrollColThead th{background-color:#94B6E6;background-repeat:repeat;}  
/* 表格的线*/  
.scrolltable{border-bottom:1px solid #CCCCCC; border-right:1px solid #8EC2E6;}  
/* 单元格的线等*/  
.scrolltable td,.scrollTable th{border-left: 1px solid #CCCCCC; border-top: 1px solid #CCCCCC; padding: 1px;}
.scrollTable thead th{background-color:#94B6E6;position:relative;}
.td_head {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	text-align: center;
	vertical-align: middle;
	height:20px;
	line-height: 20px;
	background:#CCCCCC;
}
</style>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var projectInfoNo = "<%=projectInfoNo%>";
var projectName = "<%=projectName%>";
var bActive = false;
var team_name = "";
var dataRows = 0;
var insertIndex = 3;
var exportRows = new Array();

function activeInput(){
	if(bActive == true){
		return;
	}
	window.location.href="<%=contextPath%>/pm/lineCompleted/3dEdit.jsp";
    bActive = true;
}

function initData(){
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
		team_name = team_name.replace("东方地球物理公司"," ");
	}
	//加载数据
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_wa3d_group_finish&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
	if(retObj.datas != null){
		var allRows = retObj.datas.length;
		for(var i=0;i<retObj.datas.length;i++){
			var record = retObj.datas[i];
			var rowNum = i;
			var lineId = "row_" + rowNum + "_";
			var lineNum = parseInt(rowNum)+1;
			var tr = document.getElementById("lineTable").insertRow(insertIndex);
			insertIndex++;
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.id=lineId;
			// 单元格
			if(dataRows < 1){
				var td = tr.insertCell();
				td.rowSpan = allRows+1;
				td.innerHTML = team_name;
			}
			dataRows++;
			var td = tr.insertCell();
			td.className = "scrollRowThead";
			td.innerHTML = lineNum+'<input type="hidden" name="order" class="input_width" value="'+lineNum+'">';
			var td = tr.insertCell();
			td.className = "scrollRowThead";
			td.innerHTML = record.line_group_id+'<input type="hidden" name="line_group_id_'+rowNum+'" value="'+record.line_group_id+'">';
			tr.insertCell().innerHTML = record.measure_fullfold_area+'<input type="hidden" name="measure_fullfold_area_'+rowNum+'" value="'+record.measure_fullfold_area+'">';
			tr.insertCell().innerHTML = record.measure_shot_num+'<input type="hidden" name="measure_shot_num_'+rowNum+'" value="'+record.measure_shot_num+'">';
			tr.insertCell().innerHTML = record.full_fold_area+'<input type="hidden" name="full_fold_area_'+rowNum+'" value="'+record.full_fold_area+'">';
			tr.insertCell().innerHTML = record.record_num+'<input type="hidden" name="record_num_'+rowNum+'" value="'+record.record_num+'">';
			tr.insertCell().innerHTML = record.acceptable_product_num+'<input type="hidden" name="acceptable_product_num_'+rowNum+'" value="'+record.acceptable_product_num+'">';
			tr.insertCell().innerHTML = record.qualifier_ratio+'<input type="hidden" name="qualifier_ratio_'+rowNum+'" value="'+record.qualifier_ratio+'">';
			tr.insertCell().innerHTML = record.first_num+'<input type="hidden" name="first_num_'+rowNum+'" value="'+record.first_num+'">';
			tr.insertCell().innerHTML = record.first_ratio+'<input type="hidden" name="first_ratio_'+rowNum+'" value="'+record.first_ratio+'">';
			tr.insertCell().innerHTML = record.seconde_num+'<input type="hidden" name="seconde_num_'+rowNum+'" value="'+record.seconde_num+'">';
			tr.insertCell().innerHTML = record.seconde_ratio+'<input type="hidden" name="seconde_ratio_'+rowNum+'" value="'+record.seconde_ratio+'">';
			tr.insertCell().innerHTML = record.defective_product_num+'<input type="hidden" name="defective_product_num_'+rowNum+'" value="'+record.defective_product_num+'">';
			tr.insertCell().innerHTML = record.defective_product_ratio+'<input type="hidden" name="defective_product_ratio_'+rowNum+'" value="'+record.defective_product_ratio+'">';
			tr.insertCell().innerHTML = record.no_shoot_num+'<input type="hidden" name="no_shoot_num_'+rowNum+'" value="'+record.no_shoot_num+'">';
			tr.insertCell().innerHTML = record.no_shoot_ratio+'<input type="hidden" name="no_shoot_ratio_'+rowNum+'" value="'+record.no_shoot_ratio+'">';
			tr.insertCell().innerHTML = record.design_encrypt_sum_num+'<input type="hidden" name="design_encrypt_sum_num_'+rowNum+'" value="'+record.design_encrypt_sum_num+'">';
			tr.insertCell().innerHTML = record.infill_sp_num+'<input type="hidden" name="infill_sp_num_'+rowNum+'" value="'+record.infill_sp_num+'">';
			var record_construct_begin_end_date = record.construct_begin_end_date!="\"null\""?record.construct_begin_end_date:"";
			tr.insertCell().innerHTML = record_construct_begin_end_date+'<input type="hidden" name="construct_begin_end_date_'+rowNum+'" value="'+record_construct_begin_end_date+'">';
			var record_notes = record.notes!="\"null\""?record.notes:"";
			tr.insertCell().innerHTML = record_notes+'<input type="hidden" name="notes_'+rowNum+'" value="'+record_notes+'">'
			+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
			+'<input type="hidden" name="record_id' + '_' + rowNum + '" value=""/></td>';
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = lineNum;
			exportRow["3"] = record.line_group_id;
			exportRow["4"] = record.measure_fullfold_area;
			exportRow["5"] = record.measure_shot_num;
			exportRow["6"] = record.full_fold_area;
			exportRow["7"] = record.record_num;
			exportRow["8"] = record.acceptable_product_num;
			exportRow["9"] = record.qualifier_ratio;
			exportRow["10"] = record.first_num;
			exportRow["11"] = record.first_ratio;
			exportRow["12"] = record.seconde_num;
			exportRow["13"] = record.seconde_ratio;
			exportRow["14"] = record.defective_product_num;
			exportRow["15"] = record.defective_product_ratio;
			exportRow["16"] = record.no_shoot_num;
			exportRow["17"] = record.no_shoot_ratio;
			exportRow["18"] = record.design_encrypt_sum_num;
			exportRow["19"] = record.infill_sp_num;
			exportRow["20"] = record.construct_begin_end_date;
			exportRow["21"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("lineNum").value = retObj.datas.length;
		insertIndex = retObj.datas.length + 3;
		
		computeSum('measure_fullfold_area');
		computeSum('measure_shot_num');
		computeSum('full_fold_area');
		computeSum('design_encrypt_sum_num');
		computeSum('infill_sp_num');
		computeShotSum(0);
		document.getElementById("trlinesum").style.display = "block";
		
		var sumRow = {};
		sumRow["1"] = "";
		sumRow["2"] = "合计";
		sumRow["3"] = "";
		sumRow["4"] = document.getElementsByName("sum_measure_fullfold_area_val")[0].value;
		sumRow["5"] = document.getElementsByName("sum_measure_shot_num_val")[0].value;
		sumRow["6"] = document.getElementsByName("sum_full_fold_area_val")[0].value;
		sumRow["7"] = document.getElementsByName("sum_record_num_val")[0].value;
		sumRow["8"] = "";
		sumRow["9"] = "";
		sumRow["10"] = "";
		sumRow["11"] = "";
		sumRow["12"] = "";
		sumRow["13"] = "";
		sumRow["14"] = "";
		sumRow["15"] = "";
		sumRow["16"] = "";
		sumRow["17"] = "";
		sumRow["18"] = document.getElementsByName("sum_design_encrypt_sum_num_val")[0].value;
		sumRow["19"] = document.getElementsByName("sum_infill_sp_num_val")[0].value;
		sumRow["20"] = "";
		sumRow["21"] = "";
		exportRows[exportRows.length] = sumRow;
	}
}

function computeSum(colName){
	var orders=document.getElementsByName("order");
	var sumValue = 0.00;
	for(var i=0;i<orders.length;i++){
		var order = orders[i].value;
		var rowNum = order - 1;
		
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
		if(bsflag == "1"){
			continue;
		}
		var cellValue = document.getElementsByName(colName + "_" + rowNum)[0].value;
		if(cellValue.length > 0){
			sumValue += parseFloat(cellValue);
		}
	}
	sumValue = Math.round(parseFloat(sumValue)*100)/100;
	document.getElementsByName("sum_" + colName+"_val")[0].value = sumValue;
	document.getElementById("sum_" + colName).innerHTML = sumValue;
}

function computeShotSum(rowIndex){
	var orders=document.getElementsByName("order");
	var sumValue = 0;
	for(var i=0;i<orders.length;i++){
		var order = orders[i].value;
		var rowNum = order - 1;
		
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
		if(bsflag == "1"){
			continue;
		}
		var cellValue = document.getElementsByName("record_num_" + rowNum)[0].value;
		if(cellValue.length > 0){
			sumValue += parseInt(cellValue);
		}
	}
	document.getElementsByName("sum_record_num_val")[0].value = sumValue;
	document.getElementById("sum_record_num").innerHTML = sumValue;
	
	computePrcentage('acceptable_product_num','qualifier_ratio',rowIndex);
	computePrcentage('first_num','first_ratio',rowIndex);
	computePrcentage('seconde_num','seconde_ratio',rowIndex);
	computePrcentage('defective_product_num','defective_product_ratio',rowIndex);
	computePrcentage('no_shoot_num','no_shoot_ratio',rowIndex);
}

function computePrcentage(colName,colPrcentage,rowIndex){
	var orders=document.getElementsByName("order");
	var sumValue = 0;
	var prcentage = 0;
	var sumShotNum = parseInt(document.getElementsByName("sum_record_num_val")[0].value);
	
	var currentShotNum = document.getElementsByName("record_num_"+rowIndex)[0].value;
	var currentColValue = document.getElementsByName(colName + "_" + rowIndex)[0].value;
	var currentPrcentage = 0;
	if(currentColValue.length < 1){
		document.getElementsByName(colPrcentage+"_" + rowIndex)[0].value = "";
	}
	if(currentShotNum.length > 0 && currentColValue.length>0){
		currentShotNum = parseInt(currentShotNum);
		currentColValue = parseInt(currentColValue);
		
		if(colName == "no_shoot_num"){
			//空点张数
			currentShotNum += currentColValue;
		}
		if(currentShotNum > 0){
			//当前行的百分比
			currentPrcentage = currentColValue/currentShotNum*100;
			
			currentPrcentage = Math.round(currentPrcentage*100)/100;
		}
		document.getElementsByName(colPrcentage+"_" + rowIndex)[0].value = currentPrcentage;
	}
	
	for(var i=0;i<orders.length;i++){
		var order = orders[i].value;
		var rowNum = order - 1;
		
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
		if(bsflag == "1"){
			continue;
		}
		var cellValue = document.getElementsByName(colName + "_" + rowNum)[0].value;
		if(cellValue.length > 0){
			sumValue += parseInt(cellValue);
		}
	}
	if(colName == "no_shoot_num"){
		//空点张数
		sumShotNum += sumValue;
	}
	
	if(sumShotNum > 0){
		//汇总行的百分比
		prcentage = sumValue/sumShotNum*100;
		prcentage = Math.round(prcentage*100)/100;
	}
	document.getElementsByName("sum_" + colName+"_val")[0].value = sumValue;
	document.getElementById("sum_" + colName).innerHTML = sumValue;
	document.getElementsByName("sum_" + colPrcentage+"_val")[0].value = prcentage;
	document.getElementById("sum_" + colPrcentage).innerHTML = prcentage;
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "3dLineCompleted";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}

</script>
</head>
<body style="background:#fff;overflow-y:auto;overflow-x:auto;height:400px" onload="initData()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			    <td width="90%" align="center"><font size="3"><%=projectName%>项目测线完成情况统计表</font></td>
			    <td width="10%">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<tr>
			    		<td>&nbsp;<input type="hidden" id="lineNum" value="0"/></td>
			    		<auth:ListButton functionId="" css="xg" event="onclick='activeInput()'" title="JCDP_btn_edit"></auth:ListButton>
			  			<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
			  		</tr>
				</table>
				</td>
			   <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
</table>
<div id="scrollDiv" class="scrollDiv" >
<table id="lineTable" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
	<thead>
    <tr class="scrollColThead td_head">
      <td class="scrollRowThead scrollCR" colspan="3"></td>
      <td colspan="2">设计测线</td>
      <td colspan="14">实际完成情况</td>
      <td colspan="2"></td>
    </tr>
   <tr class="scrollColThead td_head">
      <td class="scrollRowThead scrollCR" colspan="3"></td>
      <td colspan="2"></td>
      <td colspan="2"></td>
      <td colspan="2">合格品</td>
      <td colspan="2">一级品</td>
      <td colspan="2">二级品</td>
      <td colspan="2">废品</td>
      <td colspan="2">空炮</td>
      <td colspan="2"></td>
      <td colspan="2"></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollRowThead scrollCR">队号</td>
      <td class="scrollRowThead scrollCR">序号</td>
      <td class="scrollRowThead scrollCR bt_info_even">测线号</td>
      <td>满覆盖面积</td>
      <td>炮数</td>
      <td>满覆盖面积</td>
      <td>炮数</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>设计加密</br>炮数</td>
      <td>完成加密</br>炮数</td>
      <td>施工起止日期</td>
      <td>备注</td>
    </tr>
    </thead>
    <tr class="even" style="display:block" id="trlinesum">
    	<td class="scrollRowThead scrollCR">合计   	
        <input type="hidden" name="sum_measure_fullfold_area_val" value=""/>
    	<input type="hidden" name="sum_measure_shot_num_val" value=""/>
    	<input type="hidden" name="sum_full_fold_area_val" value=""/>
    	<input type="hidden" name="sum_record_num_val"/>
    	<input type="hidden" name="sum_acceptable_product_num_val"/>
    	<input type="hidden" name="sum_qualifier_ratio_val"/>
    	<input type="hidden" name="sum_first_num_val"/>
    	<input type="hidden" name="sum_first_ratio_val"/>
    	<input type="hidden" name="sum_seconde_num_val"/>
    	<input type="hidden" name="sum_seconde_ratio_val"/>
    	<input type="hidden" name="sum_defective_product_num_val"/>
    	<input type="hidden" name="sum_defective_product_ratio_val"/>
    	<input type="hidden" name="sum_no_shoot_num_val"/>
    	<input type="hidden" name="sum_no_shoot_ratio_val"/>
    	<input type="hidden" name="sum_design_encrypt_sum_num_val"/>
    	<input type="hidden" name="sum_infill_sp_num_val"/>
    	</td>
    	<td class="scrollRowThead scrollCR">&nbsp;--&nbsp;</td>
    	<td id="sum_measure_fullfold_area"></td>
    	<td id="sum_measure_shot_num"></td>
    	<td id="sum_full_fold_area"></td>
    	<td id="sum_record_num"></td>
    	<td id="sum_acceptable_product_num"></td>
    	<td id="sum_qualifier_ratio"></td>
    	<td id="sum_first_num"></td>
    	<td id="sum_first_ratio"></td>
    	<td id="sum_seconde_num"></td>
    	<td id="sum_seconde_ratio"></td>
    	<td id="sum_defective_product_num"></td>
    	<td id="sum_defective_product_ratio"></td>
    	<td id="sum_no_shoot_num"></td>
    	<td id="sum_no_shoot_ratio"></td>
    	<td id="sum_design_encrypt_sum_num"></td>
    	<td id="sum_infill_sp_num"></td>
    	<td>&nbsp;--&nbsp;</td>
    	<td>&nbsp;--&nbsp;</td>
    </tr>
</table>
</div>

</body>
</html>

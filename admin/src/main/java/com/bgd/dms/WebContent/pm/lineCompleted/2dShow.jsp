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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
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
.scrollDiv {height:360;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%; }  
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
	window.location.href="<%=contextPath%>/pm/lineCompleted/2dEdit.jsp";
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
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_wa2d_line_finish&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
	
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
			td.innerHTML = record.line_id+'<input type="hidden" name="line_id_'+rowNum+'" value="'+record.line_id+'">';
			tr.insertCell().innerHTML = record.measure_fold_num+'<input type="hidden" name="measure_fold_num_'+rowNum+'" value="'+record.measure_fold_num+'">';
			tr.insertCell().innerHTML = record.measure_fullfold_start_pile+'<input type="hidden" name="measure_fullfold_start_pile_'+rowNum+'" value="'+record.measure_fullfold_start_pile+'">';
			tr.insertCell().innerHTML = record.measure_fullfold_end_pile+'<input type="hidden" name="measure_fullfold_end_pile_'+rowNum+'" value="'+record.measure_fullfold_end_pile+'">';
			tr.insertCell().innerHTML = record.measure_fullfold_kilo_num+'<input type="hidden" name="measure_fullfold_kilo_num_'+rowNum+'" value="'+record.measure_fullfold_kilo_num+'">';
			tr.insertCell().innerHTML = record.measure_shot_num+'<input type="hidden" name="measure_shot_num_'+rowNum+'" value="'+record.measure_shot_num+'">';
			tr.insertCell().innerHTML = record.profile_fold_num+'<input type="hidden" name="profile_fold_num_'+rowNum+'" value="'+record.profile_fold_num+'">';
			tr.insertCell().innerHTML = record.profile_fullfold_start_pile+'<input type="hidden" name="profile_fullfold_start_pile_'+rowNum+'" value="'+record.profile_fullfold_start_pile+'">';
			tr.insertCell().innerHTML = record.profile_fullfold_end_pile+'<input type="hidden" name="profile_fullfold_end_pile_'+rowNum+'" value="'+record.profile_fullfold_end_pile+'">';
			tr.insertCell().innerHTML = record.full_fold_len+'<input type="hidden" name="full_fold_len_'+rowNum+'" value="'+record.full_fold_len+'">';
			tr.insertCell().innerHTML = record.physical_shot_kilo_num+'<input type="hidden" name="physical_shot_kilo_num_'+rowNum+'" value="'+record.physical_shot_kilo_num+'">';
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
			var record_construct_begin_end_date =record.construct_begin_end_date!="\"null\""?record.construct_begin_end_date:"";
			tr.insertCell().innerHTML = record_construct_begin_end_date+'<input type="hidden" name="construct_begin_end_date_'+rowNum+'" value="'+record_construct_begin_end_date+'">';
			var record_notes = record.notes!="\"null\""?record.notes:"";
			tr.insertCell().innerHTML = record_notes +'<input type="hidden" name="notes_'+rowNum+'" value="'+record_notes+'">'
			+'<input type="hidden" name="record_id' + '_' + rowNum + '" value="'+record.wa2d_line_id+'"/>'
			+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>';
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = lineNum;
			exportRow["3"] = record.line_id;
			exportRow["4"] = record.measure_fold_num;
			exportRow["5"] = record.measure_fullfold_start_pile;
			exportRow["6"] = record.measure_fullfold_end_pile;
			exportRow["7"] = record.measure_fullfold_kilo_num;
			exportRow["8"] = record.measure_shot_num;
			exportRow["9"] = record.profile_fold_num;
			exportRow["10"] = record.profile_fullfold_start_pile;
			exportRow["11"] = record.profile_fullfold_end_pile;
			exportRow["12"] = record.full_fold_len;
			exportRow["13"] = record.physical_shot_kilo_num;
			exportRow["14"] = record.record_num;
			exportRow["15"] = record.acceptable_product_num;
			exportRow["16"] = record.qualifier_ratio;
			exportRow["17"] = record.first_num;
			exportRow["18"] = record.first_ratio;
			exportRow["19"] = record.seconde_num;
			exportRow["20"] = record.seconde_ratio;
			exportRow["21"] = record.defective_product_num;
			exportRow["22"] = record.defective_product_ratio;
			exportRow["23"] = record.no_shoot_num;
			exportRow["24"] = record.no_shoot_ratio;
			exportRow["25"] = record.design_encrypt_sum_num;
			exportRow["26"] = record.infill_sp_num;
			exportRow["27"] = record.construct_begin_end_date;
			exportRow["28"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("lineNum").value = retObj.datas.length;
		insertIndex = retObj.datas.length + 3;
		computeSum('measure_fullfold_kilo_num');
		computeSum('measure_shot_num');		
		computeSum('full_fold_len');
		computeSum('physical_shot_kilo_num');
		computeSum('record_num');
		computeSum('design_encrypt_sum_num');
		computeSum('infill_sp_num');
		computeShotSum(0);
		document.getElementById("trlinesum").style.display = "block";
		var sumRow = {};
		sumRow["1"] = "";
		sumRow["2"] = "合计";
		sumRow["3"] = "";
		sumRow["4"] = "";
		sumRow["5"] = "";
		sumRow["6"] = "";
		sumRow["7"] = document.getElementsByName("sum_measure_fullfold_kilo_num_val")[0].value;
		sumRow["8"] = document.getElementsByName("sum_measure_shot_num_val")[0].value;
		sumRow["9"] = "";
		sumRow["10"] = "";
		sumRow["11"] = "";
		sumRow["12"] = document.getElementsByName("sum_full_fold_len_val")[0].value;
		sumRow["13"] = document.getElementsByName("sum_physical_shot_kilo_num_val")[0].value;
		sumRow["14"] = document.getElementsByName("sum_record_num_val")[0].value;
		sumRow["15"] = "";
		sumRow["16"] = "";
		sumRow["17"] = "";
		sumRow["18"] = "";
		sumRow["19"] = "";
		sumRow["20"] = "";
		sumRow["21"] = "";
		sumRow["22"] = "";
		sumRow["23"] = "";
		sumRow["24"] = "";
		sumRow["25"] = document.getElementsByName("sum_design_encrypt_sum_num_val")[0].value;
		sumRow["26"] = document.getElementsByName("sum_infill_sp_num_val")[0].value;
		sumRow["27"] = "";
		sumRow["28"] = "";
		exportRows[exportRows.length] = sumRow;
	}
}

function computeSum(colName){
	var orders=document.getElementsByName("order");
	var sumValue = 0;
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
	var fromPage = "2dLineCompleted";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}

</script>
</head>
<body style="background:#fff;overflow-y:auto;overflow-x:auto;" onload="initData()" width="800px">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			    <td width="90%" align="center"><font size="3"><%=projectName%>项目测线完成情况表</font></td>
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
      <td class="scrollCR scrollRowThead" colspan="3"></td>
      <td colspan="5"></td>
      <td colspan="18">实际完成情况</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" colspan="3"></td>
      <td colspan="5">设计测线</td>
      <td colspan="4">满覆盖剖面</td>
      <td colspan="2">实际工作量</td>
      <td colspan="2">合格品</td>
      <td colspan="2">一级品</td>
      <td colspan="2">二级品</td>
      <td colspan="2">废品</td>
      <td colspan="2">空炮</td>
      <td colspan="2"></td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" >队号</td>
      <td class="scrollCR scrollRowThead" >序号</td>
      <td>测线号</td>
      <td>覆盖次数</td>
      <td>满覆盖点</br>首桩号</td>
      <td>满覆盖点</br>尾桩号</td>
      <td>满覆盖</br>公里数</td>
      <td>炮数</td>
      <td>覆盖次数</td>
      <td>满覆盖点</br>首桩号</td>
      <td>满覆盖点</br>尾桩号</td>
      <td>满覆盖公里数</td>
      <td>炮点公里数</td>
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
      <td>设计加</br>密炮数</td>
      <td>完成加</br>密炮数</td>
      <td>施工起止日期</td>
      <td>备注</td>
    </tr>
    <tr style="display:block;" id="trlinesum">
    	<td class="scrollCR scrollRowThead">合计
    	<input type="hidden" name="sum_measure_fold_num_val"/>
    	<input type="hidden" name="sum_measure_fullfold_kilo_num_val"/>
    	<input type="hidden" name="sum_measure_shot_num_val"/>
    	<input type="hidden" name="sum_full_fold_len_val"/>
    	<input type="hidden" name="sum_physical_shot_kilo_num_val"/>
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
    	<td class="scrollCR scrollRowThead">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--&nbsp;</td>
    	<td id="sum_measure_fold_num"></td>
    	<td></td>
    	<td></td>
    	<td id="sum_measure_fullfold_kilo_num"></td>
    	<td id="sum_measure_shot_num"></td>
    	<td></td>
    	<td></td>
    	<td></td>
    	<td id="sum_full_fold_len"></td>
    	<td id="sum_physical_shot_kilo_num"></td>
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
    	<td></td>
    	<td></td>
    </tr>
</table>
</div>

</body>
</html>

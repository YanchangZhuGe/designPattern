<%@page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String user_id = user.getUserName();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
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
#lineTable td{
	border: solid 1px block;
	align: center;
}
</style>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';

function toAdd(){
	var lineTable = document.getElementById("lineTable");
	var row = lineTable.insertRow();
	row.align = 'center';
	var td = row.insertCell(0);
	td.innerHTML = (lineTable.rows.length-2);
	
	var column = "line_no,exploration_method,accept_no,cross_direction,wire_direction,cover_num,"+
	"full_cover_start_end,full_cover,design_shot_num,shot_num,test_shot_num,empty_shot_num,empty_rate,first_qualified_rate,"+
	"first_waster_rate,second_qualified_rate,second_waster_rate";
	var columns = column.split(",");
	for(var k in columns){
		td = row.insertCell();
		td.innerHTML = "<input type='text' name='"+columns[k]+"' size='8' id=''/>";
	}
	td = row.insertCell();
	td.innerHTML = "<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(event)'/>";
}


function deleteLine(event){
	
	var rowIndex = event.srcElement.parentElement.parentElement.rowIndex;
	var row = document.getElementById("lineTable").rows(rowIndex);
	document.getElementById("lineTable").deleteRow(rowIndex);
	
	var update_sql = "update bgp_pm_line_completion t set t.bsflag ='1' where t.project_info_no ='<%=projectInfoNo %>' and t.line_completion_id ='"+event.srcElement.id+"';";
	var retObj = jcdpCallService("QualityItemsSrv", "saveQuality", "sql="+update_sql);
}

function initData(){
	var querySql = "select t.line_completion_id ,t.project_info_no ,t.line_no ,t.exploration_method ,t.accept_no ,t.cross_direction ,t.wire_direction ,t.cover_num ,"+
		" t.full_cover_start_end ,t.full_cover ,t.design_shot_num ,t.shot_num ,t.test_shot_num ,t.empty_shot_num ,t.empty_rate ,t.first_qualified_rate ,"+
		" t.first_waster_rate ,t.second_qualified_rate ,t.second_waster_rate from bgp_pm_line_completion t where t.bsflag ='0' "+
		" and t.project_info_no ='<%=projectInfoNo %>'    order by to_number(substr(t.line_no, 3,(INSTR(t.line_no,'-',2, 1)-3))  )"
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql))+'&pageSize=10000');
	if(retObj !=null && retObj.returnCode =='0' && retObj.datas !=null && retObj.datas.length >0){
		var lineTable = document.getElementById("lineTable");
		for(var i =0 ;i <retObj.datas.length; i++){
			var row = lineTable.insertRow(i-(-2));
			row.align = 'center';
			var td = row.insertCell(0);
			td.innerHTML = (i-(-1));
			
			var column = "line_no,exploration_method,accept_no,cross_direction,wire_direction,cover_num,"+
			"full_cover_start_end,full_cover,design_shot_num,shot_num,test_shot_num,empty_shot_num,empty_rate,first_qualified_rate,"+
			"first_waster_rate,second_qualified_rate,second_waster_rate";
			var columns = column.split(",");
			for(var k in columns){
				td = row.insertCell();
				td.innerHTML = retObj.datas[i][columns[k]];
			}
			var line_completion_id = retObj.datas[i].line_completion_id;
			td = row.insertCell();
			td.innerHTML = "<img id='"+line_completion_id+"' src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(event)'/>";
			/* row.ondblclick = function(){
				toModify(event);
			} */
		}
	}
}
function toModify(event){
	/* var row = event.srcElement.parentElement;
	row.align = 'center'; */
	var column = "line_no,exploration_method,accept_no,cross_direction,wire_direction,cover_num,"+
	"full_cover_start_end,full_cover,design_shot_num,shot_num,test_shot_num,empty_shot_num,empty_rate,first_qualified_rate,"+
	"first_waster_rate,second_qualified_rate,second_waster_rate";
	var columns = column.split(",");
	var lineTable = document.getElementById("lineTable");
	for(var i =2 ;i <lineTable.rows.length; i++){
		var row = lineTable.rows(i);
		row.align = 'center';
		for(var k in columns){
			td = row.cells[k-(-1)];
			var content = td.innerHTML;
			if(content.toLowerCase().indexOf("<input")==-1){
				td.innerHTML = "<input type='text' name='"+columns[k]+"' size='8' id='' value ='"+content+"'/>";
			}
		}
	}
}

function toSave(){
	var sql = "delete from bgp_pm_line_completion t where t.project_info_no ='<%=projectInfoNo%>';";
	var lineTable = document.getElementById("lineTable");
	for(var i = 2; i < lineTable.rows.length ; i++){
		var row = lineTable.rows[i];
		var cols = "";
		var values = "";
		for(var j =1; j< 18 ;j++){
			var cell = row.cells[j];
			if(cell.innerHTML.toLowerCase().indexOf("<input")!=-1){
				var input = cell.firstChild;
				cols = cols + input.name + ",";
				values = values + "'" + input.value + "',";
			}else{
				values = values + "'" + cell.innerHTML + "',";
			}
		}
		if(cols!=null && cols==''){
			cols = "line_no,exploration_method,accept_no,cross_direction,wire_direction,cover_num,"+
			"full_cover_start_end,full_cover,design_shot_num,shot_num,test_shot_num,empty_shot_num,empty_rate,first_qualified_rate,"+
			"first_waster_rate,second_qualified_rate,second_waster_rate,";
		}
		sql = sql +"insert into bgp_pm_line_completion(line_completion_id,project_info_no,"+cols+" creator,creator_date,updator,modifi_date,bsflag)"+
        "values(lower(sys_guid()),'<%=projectInfoNo%>',"+values+" '<%=user_id%>',sysdate,'<%=user_id%>',sysdate,'0');";
	}
	var retObj = jcdpCallService("QualityItemsSrv", "saveQuality", "sql="+sql);
	if(retObj !=null && retObj.returnCode =='0' ){
		alert("保存成功!");
	}
	refreshData();
}

function refreshData(){
	deleteTable("lineTable");
	initData();
}

function deleteTable(tableID){
	var tb = document.getElementById(tableID);
    var rowNum=tb.rows.length;
    for (var i= rowNum -1;i >=2;i--){
    	tb.deleteRow(i);
	}
}

function exportExcel(){
	var project_info_no = '<%=projectInfoNo%>';
	var file_name = encodeURI(encodeURI("<%=projectName%>测线完成情况表"))
	window.location.href="<%=contextPath%>/op/OPCostSrv/commExportExcel.srq?export_function=exportLine&project_info_no="+project_info_no+"&file_name="+file_name;
}

function importData(){
	popWindow(cruConfig.contextPath+"/op/ExcelImport.jsp?path=/op/OPCostSrv/commImportExcel.srq&import_function=importLine");
}

</script>
</head>
<body style="background: #fff; overflow-y: auto; overflow-x: auto;" onload="initData()">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2">
				<form action="" id="fileForm" method="post" enctype="multipart/form-data">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td >&nbsp;</td>
							<!-- <td><font color=red>选择文件：</font><input type="file" id="fileName" name="fileName" /></td> -->
							<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel" />
							<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="导入数据" />
							<auth:ListButton functionId="" css="tj" event="onclick='toSave()'" title="保存" />
							<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="增加" />
							<auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="修改" />
						</tr>
					</table>
				</form>
			</td>
		</tr>
		<tr>
			<td width="100%" align="center"><font size="3"><%=projectName%>测线完成情况表</font></td>
		</tr>
	</table>
	<div id="scrollDiv" class="scrollDiv">
		<table id="lineTable" width="100%" border="0" cellspacing="0" align="center" cellpadding="0" class="scrolltable">
			<tr align="center" >
				<td rowspan="2" class="bt_info_odd">序号</td>
				<td rowspan="2" class="bt_info_odd">线束（测线）</td>
				<td rowspan="2" class="bt_info_odd">勘探方法</td>
				<td rowspan="2" class="bt_info_odd">接收道数</td>
				<td colspan="2" class="bt_info_odd">炮间距(m)</td>
				<td rowspan="2" class="bt_info_odd">覆盖次数</td>
				<td rowspan="2" class="bt_info_odd">满覆盖点起止桩号</td>
				<td rowspan="2" class="bt_info_odd">满覆盖（km/km2）</td>
				<td rowspan="2" class="bt_info_odd">设计炮数</td>
				<td rowspan="2" class="bt_info_odd">完成炮数</td>
				<td rowspan="2" class="bt_info_odd">试验炮数</td>
				<td rowspan="2" class="bt_info_odd">空炮数</td>
				<td rowspan="2" class="bt_info_odd">空炮率%</td>
				<td colspan="2" class="bt_info_odd">初评</td>
				<td colspan="2" class="bt_info_odd">复评</td>
				<td rowspan="2" class="bt_info_odd">删除</td>
			</tr>
			<tr align="center" >
				<td class="bt_info_odd">横向</td>
				<td class="bt_info_odd">纵向</td>
				<td class="bt_info_odd">合格%</td>
				<td class="bt_info_odd">废品%</td>
				<td class="bt_info_odd">合格%</td>
				<td class="bt_info_odd">废品%</td>
			</tr>
		</table>
	</div>
</body>
</html>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	String projectType = "";
	if (request.getParameter("projectType") != null) {
		projectType = request.getParameter("projectType");
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgId();
	String project_info_no = request.getParameter("project_info_no");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE" />
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>

<style type="text/css"> 
.bt_info_odd {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	text-align: center;
	vertical-align: middle;
	height:30px;
	line-height: 30px;
	background:#96baf6
}
.bt_info_even {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	text-align: center;
	vertical-align: middle;
	height:30px;
	line-height: 30px;
	background:#a4c7ff
}
</style>
</head>
<body onload="loaddata()">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr>
<td align="center">
<select name="vw_sel" id="vw_sel">
	<option value='5110000053000000000'>零偏横波VSP</option>
	<option value='5110000053000000001'>零偏纵波VSP</option>
	<option value='5110000053000000002'>非零偏VSP</option>
	<option value='5110000053000000003'>Walkaway-VSP</option>
	<option value='5110000053000000004'>Walkaround-VSP</option>
	<option value='5110000053000000005'>3D-VSP</option>
	<option value='5110000053000000006'>微地震井中监测</option>
	<option value='5110000053000000007'>微地震地面监测</option>
	<option value='5110000053000000008'>随钻地震</option>
	<option value='5110000053000000009'>井间地震</option>
	<option value='5110000053000000010'>井地联合勘探</option>
	<option value='5110000053000000011'>其他</option>
</select>
<input type="button" value="添加" onclick="addvw()"/>
</td>
</tr>
</table>
<div class="lashen" id="line"></div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="vw">

</table>
<div id="oper_div">
	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
</div>
</body>
<script type="text/javascript">
var _table_index=1;
var _row_id=1;

function loaddata(){
	
	var rowidinloaddata=1;
	var retObj = jcdpCallService("WsProjectSrv", "queryViewType", "projectInfoNo="+"<%=project_info_no%>");
	var datas = retObj.datas;
	var vw = $("#vw");
	if(datas==null||datas==undefined){
		return ;
	}else{
		
		var flag1="";
		var flag2="";
		var outerId = "";
		var innerId = "";
		for(var i=0;i<datas.length;i++){
			
			var sel_val = datas[i].view_type_code;
			
			var td1innerhtml = "";
			var td2innerhtml = "";
			var td3innerhtml = "";
			var td4innerhtml = "";
			var td5innerhtml = "";
			
			if(sel_val=="5110000053000000000"){
				td1innerhtml="零偏横波VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000001"){
				td1innerhtml="零偏纵波VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000002"){
				td1innerhtml="非零偏VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000003"){
				td1innerhtml="Walkaway-VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000004"){
				td1innerhtml="Walkaround-VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000005"){
				td1innerhtml="3D-VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000006"){
				td1innerhtml="微地震井中监测";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000007"){
				td1innerhtml="微地震地面监测";
				td2innerhtml="接收线数(线)";
				td3innerhtml="道距(米)";
				td4innerhtml="总接收道数(道)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000008"){
				td1innerhtml="随钻地震";
				td2innerhtml="接收线数(线)";
				td3innerhtml="道距(米)";
				td4innerhtml="总接收道数(道)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000009"){
				td1innerhtml="井间地震";
				td2innerhtml="&nbsp;";
				td3innerhtml="&nbsp;";
				td4innerhtml="&nbsp;";
				td5innerhtml="&nbsp;";
			}else if(sel_val=="5110000053000000010"){
				td1innerhtml="井地联合勘探";
				td2innerhtml="&nbsp;";
				td3innerhtml="&nbsp;";
				td4innerhtml="&nbsp;";
				td5innerhtml="&nbsp;";
			}else if(sel_val=="5110000053000000011"){
				td1innerhtml="其他";
				td2innerhtml="&nbsp;";
				td3innerhtml="&nbsp;";
				td4innerhtml="&nbsp;";
				td5innerhtml="&nbsp;";
			}
			
			var table_tr_td1 = "";
			
			var inn = "";
			
			debugger;
			
			if(flag1==""&&flag2==""){
				flag1=datas[i].view_type_code;
				flag2=datas[i].seqno;
				rowidinloaddata=1;
				var tr = $("<tr id=vmrow_"+datas[i].seqno+"></tr>");
				tr.id="vmrow_"+datas[i].seqno;
				outerId = tr[0].id;
				var table =$("<table width=\"100%\" id=\""+datas[i].view_type_code+"_"+datas[i].seqno+"\" border=\"0\" name=\"view_type\" cellspacing=\"0\" cellpadding=\"0\"></table>");
				innerId = table[0].id;
				var table_tr = $("<tr id=\"row_"+rowidinloaddata+"\"></tr>");
				inn = table_tr[0].id;
				table_tr_td1 = "<td>"+td1innerhtml+"&nbsp;&nbsp;<input onclick=\"toAddRow('"+datas[i].view_type_code+"_"+datas[i].seqno+"')\" type=\"button\" value=\"添加\"/></td>";
			}else{
				if(flag1==datas[i].view_type_code&&flag2==datas[i].seqno){
					table_tr_td1 = "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
					rowidinloaddata++;
					var table_tr = $("<tr id=\"row_"+rowidinloaddata+"\"></tr>");
					inn = table_tr[0].id;
				}else{
					flag1=datas[i].view_type_code;
					flag2=datas[i].seqno;
					rowidinloaddata=1;
					var tr = $("<tr id=vmrow_"+datas[i].seqno+"></tr>");
					outerId = tr[0].id;
					var table =$("<table width=\"100%\" id=\""+datas[i].view_type_code+"_"+datas[i].seqno+"\" border=\"0\" name=\"view_type\" cellspacing=\"0\" cellpadding=\"0\"></table>");
					innerId = table[0].id;
					var table_tr = $("<tr id=\"row_"+rowidinloaddata+"\"></tr>");
					inn = table_tr[0].id;
					table_tr_td1 = "<td>"+td1innerhtml+"&nbsp;&nbsp;<input onclick=\"toAddRow('"+datas[i].view_type_code+"_"+datas[i].seqno+"')\" type=\"button\" value=\"添加\"/></td>";
				}
			}
			
			var table_tr_td2 = "<td>"+td2innerhtml+"<input id=\""+datas[i].view_type_code+"_"+datas[i].seqno+"_view_well_"+rowidinloaddata+"\" type=\"text\" value=\""+datas[i].view_well+"\"/></td>";
			var table_tr_td3 = "<td>"+td3innerhtml+"<input id=\""+datas[i].view_type_code+"_"+datas[i].seqno+"_view_point_"+rowidinloaddata+"\" type=\"text\" value=\""+datas[i].view_point+"\"/></td>";
			var table_tr_td4 = "<td>"+td4innerhtml+"<input id=\""+datas[i].view_type_code+"_"+datas[i].seqno+"_acquire_level_"+rowidinloaddata+"\" type=\"text\" type=\"text\" value=\""+datas[i].acquire_level+"\"/></td>";
			var table_tr_td5 = "<td>"+td5innerhtml+"<input id=\""+datas[i].view_type_code+"_"+datas[i].seqno+"_note_"+rowidinloaddata+"\"  type=\"text\" value=\""+datas[i].note+"\"/></td>";
			if(inn=="row_1"){
				var table_tr_td6 = "<td><input onclick=\"toDeleteRow('"+outerId+"')\" type=\"button\" value=\"删除\"/></td>";
			}else{
				var table_tr_td6 = "<td><input onclick=\"toDeleteRow2('"+innerId+"',this)\" type=\"button\" value=\"删除\"/></td>";
			}
			
			
			if(datas[i].view_type_code=="5110000053000000009"||datas[i].view_type_code=="5110000053000000010"||datas[i].view_type_code=="5110000053000000011"){
				table_tr_td1="<td width='19%'>"+td1innerhtml+"</td>";
				table_tr_td2="<td width='19%'>"+td2innerhtml+"</td>";
				table_tr_td3="<td width='19%'>"+td3innerhtml+"</td>";
				table_tr_td4="<td width='19%'>"+td4innerhtml+"</td>";
				table_tr_td5="<td width='19%'>"+td5innerhtml+"</td>";
			}
			table_tr.append(table_tr_td1);
			table_tr.append(table_tr_td2);
			table_tr.append(table_tr_td3);
			table_tr.append(table_tr_td4);
			table_tr.append(table_tr_td5);
			table_tr.append(table_tr_td6);
			
			table.append(table_tr);
			tr.append(table);
			if(i%2==0){
				tr.addClass("bt_info_odd");
			}else{
				tr.addClass("bt_info_even");
			}
			
			vw.append(tr);
		}
		
		_table_index=datas.length+1;
	}
	
}

function toSave(){
	debugger;
	var _tables = $("table[name='view_type']");
	var parms = "";
	for(var i=0;i<_tables.length;i++){
		var tableId = _tables[i].id;
		var vtcode = tableId.split("_")[0];
		var seq = tableId.split("_")[1];
		var _trs = $("table[id='"+tableId+"'] tr");
		
		for(var j=0;j<_trs.length;j++){
			
			var trId = _trs[j].id.split("_")[1];
			var view_well_name  = '#'+tableId+'_view_well_'+trId;
			var view_point_name  = '#'+tableId+'_view_point_'+trId;
			var acquire_level_name  = '#'+tableId+'_acquire_level_'+trId;
			var note_name  = '#'+tableId+'_note_'+trId;
			
			var view_well = $(view_well_name).val();
			var view_point = $(view_point_name).val();
			var acquire_level = $(acquire_level_name).val();
			if(vtcode=="5110000053000000009"||vtcode=="5110000053000000010"||vtcode=="5110000053000000011"){
				
			}else{
				if(view_well.length==0||view_point.length==0||acquire_level.length==0){
					alert("请输入必输入数据");
					return;
				}
			}
			var note = $(note_name).val();
			parms+=vtcode+"@"+view_well+"@"+view_point+"@"+acquire_level+"@"+note+"@"+seq+"|";
			
		}
	} 
	var substr = "projectInfoNo=<%=project_info_no%>&parms="+parms;
	var retObj = jcdpCallService("WsProjectSrv", "saveViewType", substr);
	var message = retObj.message;
	if(message!=null&&message=="success"){
		alert("保存成功");
		newClose();
	}
}


function addvw(){
	debugger;
	var sel_val = document.getElementById("vw_sel").value;
	//创建一个table
	var _table = document.createElement("table");
	var _tbody = document.createElement("tbody");
	_table.appendChild(_tbody);
	_table.id=sel_val+"_"+_table_index;
	_table.setAttribute("name","view_type");
	_table.setAttribute("name","view_type");
	_table.setAttribute("border","0");
	_table.setAttribute("width","100%");
	_table.setAttribute("cellspacing","0");
	_table.setAttribute("cellpadding","0");

	var row=document.createElement ("tr");
	row.id="row_"+_row_id;
	 
	var cell=document.createElement ("td");
	
	if(sel_val=="5110000053000000000"){
		cell.innerHTML="零偏横波VSP&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000001"){
		cell.innerHTML="零偏纵波VSP&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000002"){
		cell.innerHTML="非零偏VSP&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000003"){
		cell.innerHTML="Walkaway-VSP&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000004"){
		cell.innerHTML="Walkaround-VSP&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000005"){
		cell.innerHTML="3D-VSP&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000006"){
		cell.innerHTML="微地震井中监测&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000007"){
		cell.innerHTML="微地震地面监测&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000008"){
		cell.innerHTML="随钻地震&nbsp;&nbsp;<input type=\"button\" value=\"添加\" onclick=\"toAddRow('"+_table.id+"')\"/>";
	}else if(sel_val=="5110000053000000009"){
		cell.innerHTML="井间地震&nbsp;&nbsp;";
	}else if(sel_val=="5110000053000000010"){
		cell.innerHTML="井地联合勘探&nbsp;&nbsp;";
	}else if(sel_val=="5110000053000000011"){
		cell.innerHTML="其他&nbsp;&nbsp;";
	}
	
	row.appendChild (cell);
	if(sel_val=="5110000053000000007"||sel_val=="5110000053000000008"){
		cell=document.createElement ("td");
		cell.innerHTML="接收线数(线)<input type='text' id='"+_table.id+"_view_well_"+_row_id+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="道距(米)<input type='text' id='"+_table.id+"_view_point_"+_row_id+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="总接收道数(道)<input type='text' id='"+_table.id+"_acquire_level_"+_row_id+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="备注<input type='text' id='"+_table.id+"_note_"+_row_id+"'  />";
		row.appendChild (cell);
	}else{
		if(sel_val=="5110000053000000009"||sel_val=="5110000053000000010"||sel_val=="5110000053000000011"){
			cell=document.createElement ("td");
			cell.innerHTML="&nbsp;";
			cell.width="20%"
			row.appendChild (cell);
			
			cell=document.createElement ("td");
			cell.innerHTML="&nbsp;";
			cell.width="20%"
			row.appendChild (cell);
			
			cell=document.createElement ("td");
			cell.innerHTML="&nbsp;";
			cell.width="20%"
			row.appendChild (cell);
			
			cell=document.createElement ("td");
			cell.innerHTML="&nbsp;";
			cell.width="20%"
			row.appendChild (cell);
		}else{
			cell=document.createElement ("td");
			cell.innerHTML="观测井段(米)<input type='text' id='"+_table.id+"_view_well_"+_row_id+"' />";
			row.appendChild (cell);
			
			cell=document.createElement ("td");
			cell.innerHTML="观测点距离(米)<input type='text' id='"+_table.id+"_view_point_"+_row_id+"' />";
			row.appendChild (cell);
			
			cell=document.createElement ("td");
			cell.innerHTML="采集级数(级)<input type='text' id='"+_table.id+"_acquire_level_"+_row_id+"' />";
			row.appendChild (cell);
			
			cell=document.createElement ("td");
			cell.innerHTML="备注<input type='text' id='"+_table.id+"_note_"+_row_id+"'  />";
			row.appendChild (cell);
		}
		
	}
	
	cell=document.createElement ("td");
	
	cell.innerHTML="<input type='button' value='删除' onclick=\"toDeleteRow('vmrow_"+_table.id.split("_")[1]+"')\"/>";
	
	row.appendChild (cell);
	
	_tbody.appendChild(row);
	
	var vw = document.getElementById("vw");
	var vwrow = vw.insertRow();
	if(_table_index%2==0){
		vwrow.className="bt_info_odd";
	}else{
		vwrow.className="bt_info_even";
	}
	vwrow.id="vmrow_"+_table_index;
	vwrow.appendChild(_table);

	_table_index++;
	
}


function toAddRow(id){
	
	var tableId = id;
	var rowNum = $("#"+tableId+" tr").length;
	var row=document.createElement ("tr");
	row.id="row_"+parseInt(rowNum+1);
	var cell=document.createElement ("td");
	cell.innerHTML="&nbsp;";
	row.appendChild (cell);
	
	if(tableId.indexOf("5110000053000000008")!=-1||tableId.indexOf("5110000053000000007")!=-1){
		cell=document.createElement ("td");
		cell.innerHTML="接收线数(线)<input type='text' id='"+tableId+"_view_well_"+parseInt(rowNum+1)+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="道距(米)<input type='text' id='"+tableId+"_view_point_"+parseInt(rowNum+1)+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="总接收道数(道)<input type='text' id='"+tableId+"_acquire_level_"+parseInt(rowNum+1)+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="备注<input type='text' id='"+tableId+"_note_"+parseInt(rowNum+1)+"'  />";
		row.appendChild (cell);
	}else{
		cell=document.createElement ("td");
		cell.innerHTML="观测井段(米)<input type='text' id='"+tableId+"_view_well_"+parseInt(rowNum+1)+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="观测点距离(米)<input type='text' id='"+tableId+"_view_point_"+parseInt(rowNum+1)+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="采集级数(级)<input type='text' id='"+tableId+"_acquire_level_"+parseInt(rowNum+1)+"' />";
		row.appendChild (cell);
		
		cell=document.createElement ("td");
		cell.innerHTML="备注<input type='text' id='"+tableId+"_note_"+parseInt(rowNum+1)+"'  />";
		row.appendChild (cell);
	}
	
	cell=document.createElement ("td");
	
	cell.innerHTML="<input type='button' value='删除' onclick=\"toDeleteRow2('"+tableId+"',this)\"/>";
	
	row.appendChild (cell);
	
	cell=document.createElement ("td");
	cell.innerHTML="&nbsp;";
	row.appendChild (cell);
	$("#"+tableId+" tbody").append(row);
}


function toDeleteRow(rowid){
	$('#'+rowid).remove();
}


function toDeleteRow2(tableid,obj){
	var i=obj.parentNode.parentNode.rowIndex;
	document.getElementById(tableid).deleteRow(i);
}
</script>
</html>
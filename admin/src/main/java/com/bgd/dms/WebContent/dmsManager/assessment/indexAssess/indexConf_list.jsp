<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>指标配置列表信息</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">指标名称：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_index_name" name="index_name" type="text" class="input_width" />
					  			</td>
					  			<td class="ali_cdn_name">年度：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_index_year" name="index_year" type="text" class="input_width"  style="width:120px;" readonly="readonly" />
					   				<img width="20px" height="20px" id="cal_button" style="cursor: hand;" onmouseover="ySelector(q_index_year,cal_button);" src="<%=contextPath%>/images/calendar.gif" />
					  			</td>
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
								<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td style="width:40px;" class="bt_info_odd" exp="<input type='radio' name='rdo_entity_id' value='{indexconf_id}' id='rdo_entity_id_{indexconf_id}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{index_name}">指标名称</td>
					<td class="bt_info_even" exp="{index_year}">年度</td>
					<td class="bt_info_odd" exp="{updator_name}">创建人</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 
						<label>
							<input type="text" name="textfield" id="textfield" style="width:20px;" />
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab(0)">明细信息</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<fieldset style="margin-left:2px"><legend>指标基本信息</legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item6">指标名称：</td>
						  	<td class="inquire_form6" >
						  		<input type="text" id="index_name" name="index_name" class="input_width main" readonly="readonly"/>
						  	</td>
						  	<td class="inquire_item6">年度：</td>
						  	<td class="inquire_form6" >
						  		<input type="text" id="index_year" name="index_name"  class="input_width main" readonly="readonly"/>
						  	</td>
						</tr>			    				    
					</table>	
				</fieldset>
				<fieldset style="margin-left:2px;height:290px;"><legend>指标项信息</legend>
					<table  style="table-layout:fixed" width="100%" border="1" cellspacing="1" cellpadding="0" style="border-style:solid;"
						class="tab_info" id="commonInfoTable2">
						<tr>
							<td width="10%">序号</td>
							<td width="80%">指标项名称</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		setTabBoxHeight();
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "IndexAssessSrv";
	cruConfig.queryOp = "queryIndexConfInfoList";
	var path = "<%=contextPath%>";
	// 复杂查询
	function refreshData(index_name,index_year){
		var temp = "";
		if(typeof index_name!="undefined" && index_name!=""){
			temp += "&index_name="+index_name;
		}
		if(typeof index_year!="undefined" && index_year!=""){
			temp += "&index_year="+index_year;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","");
	
	
	//简单查询
	function simpleSearch(){
	 	var q_index_name = $("#q_index_name").val(); 
	 	var q_index_year = $("#q_index_year").val(); 
		refreshData(q_index_name,q_index_year);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_assess_date").value = "";
		document.getElementById("q_index_year").value = "";
		refreshData("","");
	}
	
	//双击事件
	function dbclickRow(ids){	
	}
	
	//新增
	function toAdd(){ 
		popWindow('<%=contextPath %>/dmsManager/assessment/indexAssess/indexConf_edit.jsp?flag=add','800:680');

	}
	//修改
	function toEdit(){ 
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
		popWindow('<%=contextPath %>/dmsManager/assessment/indexAssess/indexConf_edit.jsp?flag=update&indexconf_id='+ids,'800:680');
	}
	
	//删除
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("IndexAssessSrv", "deleteIndexConfInfo", "indexconf_id="+ids);
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
						return;
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						queryData(cruConfig.currentPage);
						$("#commonInfoTable2").empty();
						$("#commonInfoTable2").append("<tr><td width='10%'>序号</td><td width='80%'>指标项名称</td></tr>");
					}
				}
			}
		}
	}
	//点击tab页
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	var selected_id = "";//加载数据时，选中记录id
	var tab_index =0;//tab页索引
	//点击tab,显示具体tab
	function getTab(index){
		tab_index=index;
		getTab3(index);
		$(".tab_box_content").hide();
		$("#tab_box_content"+index).show();
		loadDataDetail(selected_id);
	}
	//加载单条记录的详细信息
	function loadDataDetail(ids){
		selected_id=ids;
		if(0==tab_index){
			$("#commonInfoTable2").empty();
			$("#commonInfoTable2").append("<tr><td width='10%'>序号</td><td width='80%'>指标项名称</td></tr>");
			//指标项序号
			_dorder = 1;
			var _dretObj = jcdpCallService("IndexAssessSrv", "getIndexConfInfo", "indexconf_id="+ids);
			if(typeof _dretObj.data!="undefined"){
				var _ddata = _dretObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(_ddata[temp] != undefined ? _ddata[temp]:"");
				});
			}
			if(typeof _dretObj.datas!="undefined"){
				var _ddatas = _dretObj.datas;
				insertTr("commonInfoTable2",_ddatas);
			}
		}
	}
	//选择年月
	function ySelector(inputField,tributton){    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
	//指标项序号
	var _dorder = 1;
	//添加指标项行
	function insertTr(id,datas){
		var fTable = document.getElementById(id);
		for(var i=0;i<datas.length && datas[i]!=null;i++){
			var map = datas[i];
			if(map!=null){
				with(map){
					var tr = fTable.insertRow(i+1);
					var td = tr.insertCell(0);
					td.innerHTML = _dorder;//序号					
					td = tr.insertCell(1);
					td.innerHTML = item_name;//指标名称
				}
				_dorder++;
			}
		}
	}
</script>
</html>


<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
	<title>采购计划信息</title>
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
					  			<td class="ali_cdn_name">采购单号：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_purc_num" name="purc_num" type="text" class="input_width" />
					  			</td>
								<td class="ali_cdn_name">采购类型：</td>
					  			<td class="ali_cdn_input">
					   				<select id="q_purc_type" name="purc_type" class="input_select">
										<option value="">请选择</option>
										<option value="Z006">设备采购计划</option>
										<option value="Z002">物资采购计划</option>
						    		</select>
					  			</td>
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
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
					<td style="width:40px;" class="bt_info_odd" exp="<input type='radio' name='rdo_entity_id' value='{purc_id}' id='rdo_entity_id_{purc_id}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{purc_num}">采购单号</td>
					<td class="bt_info_even" exp="{order_type_name}">采购类型</td>
					<td class="bt_info_odd" exp="{fill_date}">填报日期</td>
					<td class="bt_info_even" exp="{org_name}">所属单位</td>
					<td class="bt_info_odd" exp="{fill_per}">填报人</td>
					<td class="bt_info_even" exp="{proc_status}">单据状态</td>
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
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab(0)">单据明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab(1)">审批流程</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="100%" name="list" id="d_list" frameborder="0" src="<%=contextPath%>/dmsManager/plan/exePlan/purc_detail_list.jsp" marginheight="0" marginwidth="0" >
				</iframe>	
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="list" id="a_list" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
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
	cruConfig.queryService = "ExePlanSrv";
	cruConfig.queryOp = "queryPurcList";
	var path = "<%=contextPath%>";
	// 复杂查询
	function refreshData(purc_num,purc_type){
		var temp = "";
		if(typeof purc_num!="undefined" && purc_num!=""){
			temp += "&purcNum="+purc_num;
		}
		if(typeof purc_type!="undefined" && purc_type!=""){
			temp += "&purcType="+purc_type;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","");
	
	
	//简单查询
	function simpleSearch(){
	 	var q_purc_num = $("#q_purc_num").val(); 
		var q_purc_type = $("#q_purc_type").val(); 
		refreshData(q_purc_num,q_purc_type);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_purc_num").value = "";
		document.getElementById("q_purc_type").value = "";
		refreshData("","");
	}
	
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	
	
	//清空表格
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
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
			$("#d_list").attr("src","<%=contextPath%>/dmsManager/plan/exePlan/purc_detail_list.jsp?purcId="+ids);
		}
		if(1==tab_index){
			$("#a_list").attr("src","<%=contextPath%>/dmsManager/plan/exePlan/approval_list.jsp?businessId="+ids);
		}
	}
</script>
</html>


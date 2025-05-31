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
	<title>年度投资建议计划信息</title>
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
					  			<td class="ali_cdn_name">单号：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_apply_num" name="apply_num" type="text" class="input_width" />
					  			</td>
				   				<td class="ali_cdn_name">审批状态：</td>
				  				<td class="ali_cdn_input">
							   		<select id="q_apply_status" name="apply_status" type="text" class="select_width">
								    	<option value="">请选择</option>
								    	<option value="0">未提交</option>
								    	<option value="1">待审批</option>
								    	<option value="3">审批通过</option>
								    	<option value="4">审批未通过</option>
								    </select>
							  	</td>
							  	<td class="ali_cdn_name">年度：</td>
				  				<td class="ali_cdn_input">
							   		<input id="q_apply_year" name="apply_year" type="text" class="input_width"/>
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
								<auth:ListButton functionId="" css="tj" event="onclick='submitToAudit()'" title="提交"></auth:ListButton>
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
					<td style="width:40px;" class="bt_info_odd" exp="<input  type='radio' name='rdo_entity_id' value='{apply_id}_{apply_year}' id='rdo_entity_id_{apply_id}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{apply_num}">单号</td>
					<td class="bt_info_even" exp="{org_id_name}">所属单位</td>
					<td class="bt_info_odd" exp="{apply_year}">年度</td>
					<td class="bt_info_even" exp="{fill_per_name}">填报人</td>
					<td class="bt_info_odd" exp="{fill_date}">填报日期</td>
					<td class="bt_info_even" exp="{apply_status}">单据状态</td>
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
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab(0)">审批流程</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	});
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "YearPlanSrv";
	cruConfig.queryOp = "queryYearPlanList";
	var path = "<%=contextPath%>";
	
	// 复杂查询
	function refreshData(apply_num,apply_status,apply_year){
		var temp = "";
		if(typeof apply_num!="undefined" && apply_num!=""){
			temp += "&apply_num="+apply_num;
		}
		if(typeof apply_status!="undefined" && apply_status!=""){
			temp += "&apply_status="+apply_status;
		}
		if(typeof apply_year!="undefined" && apply_year!=""){
			temp += "&apply_year="+apply_year;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","","");
	
	
	//简单查询
	function simpleSearch(){
	 	var q_apply_num = $("#q_apply_num").val(); 
	    var q_apply_status = $("#q_apply_status").val();
	    var q_apply_year = $("#q_apply_year").val(); 
		refreshData(q_apply_num,q_apply_status,q_apply_year);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_apply_num").value = "";
		document.getElementById("q_apply_status").value = "";
		document.getElementById("q_apply_year").value = "";
		refreshData("","","");
	}
	
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	
	//新增
	function toAdd(){
		window.location.href='<%=contextPath %>/dmsManager/plan/yearPlan/require_report.jsp?flag=add';	
	}

	//修改
	function toEdit(){ 
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
	    var retObj = jcdpCallService("YearPlanSrv", "getApplyState", "applyId="+ids.split("_")[0]);
		if(retObj.data.proc_status=='1'){
			alert("您选择的记录中存在状态为'待审批'的单据,不能修改!");
			return;
		}
		if(retObj.data.proc_status=='3'){
			alert("您选择的记录中存在状态为'审批通过'的单据,不能修改!");
			return;
		}
		window.location.href='<%=contextPath %>/dmsManager/plan/yearPlan/require_report.jsp?flag=update&applyId='+ids.split("_")[0]+'&applyYear='+ids.split("_")[1];	
	}
	
	//删除
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
	    var retObj = jcdpCallService("YearPlanSrv", "getApplyState", "applyId="+ids.split("_")[0]);
		if(retObj.data.proc_status=='1'){
			alert("您选择的记录中存在状态为'待审批'的单据,不能删除!");
			return;
		}
		if(retObj.data.proc_status=='3'){
			alert("您选择的记录中存在状态为'审批通过'的单据,不能删除!");
			return;
		}
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("YearPlanSrv", "deleteYearPlan", "applyId="+ids.split("_")[0]);
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
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
	var selected_apply_year=""; //选中记录的申请年度
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
		selected_id=ids.split("_")[0];
		selected_apply_year=ids.split("_")[1];
		configProecessInfo();
		if(0==tab_index){
			//加载流程信息
			loadProcessHistoryInfo();
		}
	}
	
	//流程提交前配置流程关键信息
	function configProecessInfo(){
		var submitdate =getdate();
		processNecessaryInfo={
				businessTableName:"dms_yearplan_apply",
				businessType:"5110000181000000007",
				businessId:selected_id,
				applicantDate:submitdate,
				businessInfo:"年度投资建议计划申请"
		};
		processAppendInfo={
				applyId:selected_id,
				applyYear:selected_apply_year
		};
		
	}
	
	//提交流程
	function submitToAudit(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
		var retObj = jcdpCallService("YearPlanSrv", "getApplyState", "applyId="+ids.split("_")[0]);
		if(retObj.data.proc_status=='1'){
			alert("您选择的记录中存在状态为'待审批'的单据,不能提交!");
			return;
		}
		if(retObj.data.proc_status=='3'){
			alert("您选择的记录中存在状态为'审批通过'的单据,不能提交!");
			return;
		}
		 submitProcessInfo();
		 refreshData();
	}
	//获取日期
	function getdate() { 
		var now=new Date(); 
		y=now.getFullYear(); 
		m=now.getMonth()+1; 
		d=now.getDate(); 
		m=m <10? "0"+m:m; 
		d=d <10? "0"+d:d; 
		return  y + "-" + m + "-" + d ;
	}
</script>
</html>


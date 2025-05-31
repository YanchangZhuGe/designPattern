<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	String orgId= user.getOrgId();	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备明细</title>
<style type="text/css">
.pagination table{
	float:right;
}

.panel .inquire_item{
	text-align:right;
}
.inquire_form{
	width:180px;
}

.tab_line_height {
	border-color: #1C86EE;
 	border-style: dotted;
 	border-width: 2px;
	width:100%;
	line-height:24px;
	height:24px;
	color:#000;
	margin: 0;
    padding: 0;
}
.tab_line_height td {
	border-color: #1C86EE;
	border-style: dotted;
	line-height:24px;
	border-width: 1px;
	height:24px;
	white-space:nowrap;
	word-break:keep-all;
	margin: 0;
    padding: 0;
}
.panel .panel-body{
	font-size: 12px;
}
input,textarea{
	font-size: 12px;
}
</style>
</head>
<body>
	<!-- 最外层layout -->
	<div class="easyui-layout" data-options="fit:true" >
		<!-- 页面上半部分布局 -->
		<div id="north" data-options="region:'north',split:true" style="height:480px;">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="dev_grid"></table>
					<div id="tb2" style="padding:5px;height:auto">
						<div style="padding:1px;height:auto">						
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;设备名称：<input id="devname" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;规格型号：<input id="devmodel" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;ERP设备编号：<input id="devcoding" class="input_width query" style="width:100px;float:none;">
						</div>
						<div style="padding:1px;height:auto">						
							&nbsp;&nbsp;实物标识号：<input id="devsign" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;牌照号：<input id="licensenum" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							自编号：<input id="selfnum" class="input_width query" style="width:102px;float:none;">
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i>查询</a>
							<!-- <a href="####" class="easyui-linkbutton" onclick="searchManyData()"><i class="fa fa-filter fa-lg"></i>高级查询</a> -->
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i>清除</a>
							<!-- <a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-list fa-lg"></i>动态列</a> -->
							<div style="float:right;height:28px;">
								<a href="####" class="easyui-linkbutton" onclick='save()'><i class="fa fa-floppy-o fa-lg"></i>保 存</a>
			    				&nbsp;&nbsp;
			    				<a href="####" class="easyui-linkbutton" onclick='newClose()'><i class="fa fa-times fa-lg"></i>关 闭 </a>
		    				</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="win"></div>
</body>
<script type="text/javascript">
var queryParams;
var reurnValue = "";
var objdata = window.dialogArguments.pageselectedstr;

$(function(){
	//设置样式
	$(".only_read").attr("readonly","true");
	$(".only_read").css("border","0").css("color","blue").css("background-color","transparent");
	$("#detail tr").each(function(index){
		if(index%2==0){
			$(this).addClass("datagrid-row-alt");
		}		
	});
	//设备信息显示
	$("#dev_grid").datagrid({ 
		method:'post',
		nowrap:false,
		rownumbers:true,//行号 
		title:"",
		toolbar:'#tb2',
		border:false,
		striped:true,
		singleSelect:true,//是否单选 
		pagination:true,//分页控件 
		selectOnCheck:true,
		pageSize:200,
		pageList:[200, 300, 400, 500, 600],
		fit:true,//自动大小 
		fitColumns:true,
		columns:[[
			 	{field:'dev_acc_id',title:'主键',checkbox:true,align:'center',width:10},
			 	{field:'dev_name',title:'设备名称',align:'center',sortable:'true',width:30},
			 	{field:'dev_model',title:'规格型号',align:'center',sortable:'true',width:40},
			 	{field:'self_num',title:'自编号',align:'center',sortable:'true',width:30},
			 	{field:'dev_sign',title:'实物标识号',align:'center',sortable:'true',width:50},
			 	{field:'license_num',title:'牌照号',align:'center',sortable:'true',width:30},
			 	{field:'dev_coding',title:'ERP设备编号',align:'center',sortable:'true',width:30},
			 	{field:'own_org_name',title:'所属单位',align:'center',sortable:'true',width:50}   
		    ]],
		onClickRow:function(index,data){
		},
		onDblClickRow:function(index,data){
			//reurnValue = "";
			//reurnValue = data.dev_acc_id+"@";
			save();
		},
		onSelect: function(index,data){
		//	reurnValue += data.dev_acc_id+"@";
    	},
		onLoadSuccess : function(data1) {
        },
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=DevQZMaintianList&JCDP_OP_NAME=queryDevAccData"
	});
});
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	setFirstPage("#dev_grid");
	searchDevData();
}
//返回首页
function setFirstPage(ids){
    var opts = $(ids).datagrid('options');
	var pager = $(ids).datagrid('getPager');
	opts.pageNumber = 1;
	opts.pageSize = opts.pageSize;
	pager.pagination('refresh',{
		    	pageNumber:1,
		    	pageSize:opts.pageSize
	});
}
//查询及返回刷新
function searchDevData(){
	//组织查询条件
	var params = {};
	$(".query").each(function(){
		if($(this).val()!=""){
			params[$(this).attr("id")] = $(this).val();
		}
	});
	//必须条件
	queryParams = params;
	$("#dev_grid").datagrid('reload',queryParams);
}
//返回值
function save(){		
	var selected = $('#dev_grid').datagrid('getSelections');
    if (selected){
	    for(var i=0;i<selected.length;i++){
	    	reurnValue += selected[i].dev_acc_id+"@";
	    }
    }
    if (reurnValue == '') {
		$.messager.alert("提示","请选择一条记录!","warning");
		return;
	}
	window.returnValue = reurnValue;
	window.close();
}
//关闭按钮
function newClose(){
	window.close();
}
</script>
</html>
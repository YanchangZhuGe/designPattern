<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>供应商评价</title>
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
		<div id="north" data-options="region:'north',split:true" style="height:345px;">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="main_grid">
						<thead>
							<tr>
								<th data-options="field:'score_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'in_date',align:'center'" width="35">评价时间</th>
								<th data-options="field:'org_name',align:'center',sortable:'true'" width="90">组织机构</th>
								 
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;组织机构：<input id="useorgname" class="input_width query" style="width:80px;float:none;" readonly>
							<input id="usesubid" name="usesubid" class="query" type="hidden" />
							<a href='####' class='easyui-linkbutton' onclick='showOrgTreePage()'><i class='fa fa-sitemap fa-lg'></i>选择</a>
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<a href='####' class='easyui-linkbutton' onclick='toAddPage()'><i class='fa fa-plus-circle fa-lg'></i>添加</a>
							<a href='####' class='easyui-linkbutton' onclick='toEditPage()'><i class='fa fa-pencil-square fa-lg'></i>修改</a>
							<a href='####' class='easyui-linkbutton' onclick='toDelPage()'><i class='fa fa-trash-o fa-lg'></i>删除</a>
 
							<!-- <a href='####' class='easyui-linkbutton' onclick='expUserListExcel()'><i class='fa fa-file-excel-o fa-lg'></i>导出</a> -->
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="基本信息" style="padding:10px;">
                	<div id="mian_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
				 
                </div>
                </div>
                            
           	 </div>
		</div>
	</div>
	<div id="win"></div>
</body>
<script type="text/javascript">
var selectTabIndex = 0;
var currentId = "";
var queryParams;

$(function(){
	//设置样式
	$(".only_read").attr("readonly","true");
	$(".only_read").css("border","0").css("color","blue").css("background-color","transparent");
	$("#detail tr").each(function(index){
		if(index%2==0){
			$(this).addClass("datagrid-row-alt");
		}		
	});
	 
	//初始用户信息
	$("#main_grid").datagrid({ 
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
		fit:true,//自动大小 
		fitColumns:true,
		onSelect:function(index,data){
			currentId = data.score_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadMainInfo(currentId);
			}else if(selectTabIndex == 1){
				 
			}
		},
		queryParams:{//必需参数
			'orgsubid':'<%=orgSubId %>'
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=EquipmentSelectionApply&JCDP_OP_NAME=queryCompanyScore",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
        }		
	});
	 
});
//加载基本信息
function loadMainInfo(score_id){
	 	var retObj = jcdpCallService("EquipmentSelectionApply", "getCompanyScoreInfoByScoreId", "score_id="+score_id);
			debugger;
			if(typeof retObj.ids!="undefined"){
			$("#in_date").datebox('setValue',retObj.apply.in_date);
			$("#orgname").val(retObj.apply.org_name);
			$("#orgid").val(retObj.apply.in_org_id);
			var ids=retObj.ids.split(",");
			var names=retObj.names.split(",");
			var columns= [];
			var columndevname={};
			columndevname["field"]="coding_name";
			columndevname["title"]="指标";
			columndevname["width"]=20;
			columns.push(columndevname);
			var coding_code_id={};
			coding_code_id["field"]="coding_code_id";
			coding_code_id["title"]="id";
			coding_code_id["width"]=20;
			coding_code_id["hidden"]=true;
			columns.push(coding_code_id);
			for(var i=0;i<names.length;i++){
			$("#company_id").val($("#company_id").val()+ids[i]+",");
			var column={};
			column["field"]="aa"+ids[i];
			column["title"]=names[i];
			column["width"]=20;
			columns.push(column);
			}
	
   			 
    var dynamicTable = $('<table id="tbTest"></table>');
    //这里一定要先添加到currentTabPanel中，因为dynamicTable.datagrid()函数需要调用到parent函数
    $("#mian_detail").html(dynamicTable);
    dynamicTable.datagrid({  
   	    nowrap:false,  
		fitColumns:true,   
        columns:[columns ],
		singleSelect:true,
		showFooter: true
        });
        debugger;
        $("#tbTest").datagrid('loadData',retObj.datas);  
        $('#tbTest').datagrid('reloadFooter',retObj.footer);  
		}
}
 
//新增评价
function toAddPage(){
	editUrl = '${pageContext.request.contextPath}/dmsManager/modelSelection/editEvaluate.jsp';
	popWindow(editUrl,'1080:520',"-添加/修改评价信息");
}
//修改评价
function toEditPage(){
	var row = $('#main_grid').datagrid('getSelected');
	if (row){
		 editUrl = '${pageContext.request.contextPath}/dmsManager/modelSelection/editEvaluate.jsp?score_id='+row.score_id;
		 popWindow(editUrl,'1080:520',"-添加/修改评价信息");
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//删除评价
function toDelPage(){
	var row = $('#main_grid').datagrid('getSelected');
	if (row){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("EquipmentSelectionApply", "delCompanyScore", "score_id="+row.score_id);
					searchDevData();
					}
				});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

 
 
 
 
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	setFirstPage("#main_grid");
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
	params["usesubid"] = $("#usesubid").val();
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
// 选择组织机构树	 	 
function showOrgTreePage(){
	var returnValue={
		fkValue:"",
		value:""
	}
	window.showModalDialog("<%=contextPath%>/common/selectOrg.jsp",returnValue,"");
	$("#useorgname").val(returnValue.value);
	$("#usesubid").val(returnValue.fkValue);
	tipView('useorgname',returnValue.value,'bottom');
}
</script>
</html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String subOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>要素评分</title>
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
					<table id="assess_grid">
						<thead>
							<tr>
								<th data-options="field:'model_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'model_name',align:'center',sortable:'true'" width="60">模板名称</th>							
								<th data-options="field:'model_type_name',align:'center',sortable:'true'" width="30">模板类型</th>
								<th data-options="field:'model_version',align:'center',sortable:'true'" width="30">模板版本号</th>
								<th data-options="field:'creator_name',align:'center',sortable:'true'" width="30">创建人</th>
								<th data-options="field:'create_date',align:'center',sortable:'true'" width="20">创建时间</th>
								<th data-options="field:'remark',align:'center',sortable:'true'" width="20">备注</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;模板名称：<input id="modelname" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;审核类型：<input id="modeltype" class="input_width query" style="width:100px;float:none;">
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<easyuiAuth:EasyUIButton functionId="" className="fa fa-check-square fa-lg" event="JcdpButton0OnClick()" text="提交"></easyuiAuth:EasyUIButton>
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

$(function(){
	//设置样式
	$(".only_read").attr("readonly","true");
	$(".only_read").css("border","0").css("color","blue").css("background-color","transparent");
	$("#detail tr").each(function(index){
		if(index%2==0){
			$(this).addClass("datagrid-row-alt");
		}		
	});
	// 下拉框选择控件，下拉框的内容是动态查询数据库信息
 	$('#modeltype').combobox({ 
		url:'<%=contextPath%>/rm/dm/toGetAssessModelType.srq',
		editable:false, //不可编辑状态
		cache: false,
		panelHeight:'auto',
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     }); 
	//初始评审信息
	$("#assess_grid").datagrid({ 
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
		onClickRow:function(index,data){
			reurnValue = "";
			reurnValue = data.model_id+"~"+data.model_name+"~"+data.model_type+"~"+data.model_title;
		},
		onDblClickRow:function(index,data){
			reurnValue = "";
			reurnValue = data.model_id+"~"+data.model_name+"~"+data.model_type+"~"+data.model_title;
			JcdpButton0OnClick();
		},
		onSelect: function(index,data){
			reurnValue = "";
			reurnValue = data.model_id+"~"+data.model_name+"~"+data.model_type+"~"+data.model_title;
    	},
		onLoadSuccess : function(data1) {
        },
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=queryAssessModelList"
	});
});
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	$("#modeltype").combobox("setValue","");
	setFirstPage("#assess_grid");
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
	var modelTyle = $("#modeltype").combobox("getValue");
	if(modelTyle != '' && modelTyle != '请选择...'){
		params["modeltype"] = $("#modeltype").combobox("getValue");
	}	
	queryParams = params;
	$("#assess_grid").datagrid('reload',queryParams);
}
//返回值
function JcdpButton0OnClick(){		
	if (reurnValue == '') {
		$.messager.alert("提示","请选择一条记录!","warning");
		return;
	}
	window.returnValue = reurnValue;
	window.close();
}
</script>
</html>
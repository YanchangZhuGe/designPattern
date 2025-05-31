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
<title>物探队实时监控</title>
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
		<div id="north" data-options="region:'north',split:true" style="height:295px;">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="main_grid">
						<thead>
							<tr>
								<th data-options="field:'duiorgid',checkbox:false,align:'center',hidden:true" width="10">主键</th>
								<th data-options="field:'wtcname',align:'center',sortable:'true'" width="65">物探处</th>
								<th data-options="field:'duiorgname',align:'center',sortable:'true'" width="55">地震队</th>							
								<th data-options="field:'state',align:'center',sortable:'true'" formatter='showState' width="55">状态</th>
								<th data-options="field:'startdate',align:'center',sortable:'true'" width="40">开始时间</th>
								<th data-options="field:'enddate',align:'center',sortable:'true'" width="40">结束时间</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;&nbsp;正常：<img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="15px" height="15px"/>
							&nbsp;&nbsp;&nbsp;&nbsp;报警：<img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="15px" height="15px"/>
							&nbsp;&nbsp;&nbsp;&nbsp;无项目：<img src="<%=contextPath%>/pm/projectHealthInfo/headgray.jpg" style="cursor: pointer;" width="15px" height="15px"/>
					    	&nbsp;&nbsp;&nbsp;&nbsp;年度：<input name="year" class="input_width" id="year" style="width:150px;" />
						</div>
						<div style="float:right;height:28px;">
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
							<a href='####' class='easyui-linkbutton' onclick='exportExcel()'><i class='fa fa-file-excel-o fa-lg'></i>导出</a>
							&nbsp;&nbsp;&nbsp;&nbsp;
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="win"></div>
</body>
<script type="text/javascript">
var selectTabIndex  =0;
var currentId = "";
var queryParams;

$(function(){
	$('#year').combobox({ 
		url:'${pageContext.request.contextPath}/assess/toGetProYearJson.srq',
		editable:false, //不可编辑状态
		valueField:'code',   
		textField:'value'
		});
	//初始单台设备调配信息
	$("#main_grid").datagrid({ 
		method:'post',
		nowrap:false,
		title:"",
		toolbar:'#tb2',
		border:false,
		striped:true,
		singleSelect:true,//是否单选 
		selectOnCheck:true,
		pagination:false,
		fit:true,//自动大小 
		fitColumns:true,
		onClickRow:function(index,data){
		},
		queryParams:{//必需参数
			'orgsubid':'<%=orgSubId %>'
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=queryMonitorStateInfo",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess:function(){
			$("#main_grid").datagrid("autoMergeCells", ['wtcname']);
		}			
	});
});
//清空查询条件
function clearQueryText(){
	$("#year").combobox("reload");
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
	params["year"] = $("#year").combobox("getValue");
	params["orgsubid"] = '<%=orgSubId %>';
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//显示红绿灯
function showState(value,row,index){
	var duiorgid = row.duiorgid;
	if(value==0){
		return '<a href="####" onclick="popState(\'' + duiorgid+ '\',\''+$("#year").combobox("getValue")+'\')"><img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
	}else{
		return '<a href="####" onclick="popState(\'' + duiorgid+ '\',\''+$("#year").combobox("getValue")+'\')"><img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
	}
}
//钻取展示小队项目状态信息
function popState(orgid,year){
	window.top.$.JDialog.open('${pageContext.request.contextPath}/dms_info/projectScoreMonitor.jsp?orgid='+orgid+'&year='+year,{
       	win:window,
        width:980,
        height:480,
        title:"红绿灯显示",
		callback:'' //设置回调函数
     } );
}
</script>
</html>
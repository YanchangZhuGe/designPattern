<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String wtcSubId = request.getParameter("subid");
	System.out.println("wtcSubId == "+wtcSubId);
	String detailId = request.getParameter("detailid");
	String monitorProType = request.getParameter("monitorprotype");
	String proYear = request.getParameter("proyear");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>项目实时监控</title>
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
		<div id="north" data-options="region:'north',split:true,fit:true">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false"> 
					<table id="main_grid">
						<thead>
							<tr>
								<th data-options="field:'projectinfono',checkbox:false,align:'center',hidden:true" width="10">主键</th>
								<th data-options="field:'projectname',align:'center',sortable:'true'" width="100">项目名称</th>
								<th data-options="field:'duiname',align:'center',sortable:'true'" width="40">队伍</th>
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
						</div>
						<div style="float:right;height:28px;">
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-refresh fa-lg"></i> 刷新</a>
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
	//初始显示信息
	$("#main_grid").datagrid({ 
		method:'post',
		nowrap:false,
		title:"",
		rownumbers:true,//行号 
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
			'wtcsubid':'<%=wtcSubId %>',
			'detailid':'<%=detailId %>',
			'monitorprotype':'<%=monitorProType %>',
			'proyear':'<%=proYear %>'
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=queryProjectStateMonitorInfo"
	});
	$(".datagrid-header-rownumber").html('序号');//datagrid 添加序列
});
//查询及返回刷新
function searchDevData(){
	//组织查询条件
	var params = {};
	params["wtcsubid"] = '<%=wtcSubId %>';
	params["detailid"] = '<%=detailId %>';
	params["monitorprotype"] = '<%=monitorProType %>';
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//显示红绿灯
function showState(value,row,index){
	if(value==0){
		return '<img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="14px" height="14px"/>';
	}else{
		return '<img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="14px" height="14px"/>';
	}
}
</script>
</html>
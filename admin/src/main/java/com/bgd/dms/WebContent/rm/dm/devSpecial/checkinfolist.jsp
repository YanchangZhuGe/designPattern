<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String wtcSubId = request.getParameter("subid");
	String type = request.getParameter("type");
	String startdate = request.getParameter("startdate");
	String enddate = request.getParameter("enddate");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>日常检查</title>
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
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="100">设备名称</th>
								<th data-options="field:'dev_coding',align:'center',sortable:'true'"  width="55">ERP编码</th>
								<th data-options="field:'dev_sign',align:'center',sortable:'true'" width="40">实物标识号</th>
								<th data-options="field:'counts',align:'center',sortable:'true'" formatter='showState3' width="40">次数</th>
								 
							</tr>
						</thead>
					</table>
					 			
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
	//初始单台设备调配信息
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
			'type':'<%=type %>',
			'startdate':'<%=startdate %>',
			'enddate':'<%=enddate%>'
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=DevCommSrv&JCDP_OP_NAME=queryRiChangjcDList"
	});
	$(".datagrid-header-rownumber").html('序号');//datagrid 添加序列
});
 
 
function showState3(value,row,index){
	if(value>0){
	return '<a href="####" onclick="popState(\''+row.dev_acc_id+'\')">'+value+'</a>';
	}else{
	return 0;
	}
}
//钻取信息
function popState(dev_acc_id){
 	 
	window.top.$.JDialog.open('${pageContext.request.contextPath}/rm/dm/devSpecial/checkinfos.jsp?dev_acc_id='+dev_acc_id+'&startdate=<%=startdate%>&enddate=<%=enddate%>'
	,{
        win:window,
        width:980,
        height:480,
        title:"信息显示",
		callback:'' //设置回调函数
     } );
}
</script>
</html>
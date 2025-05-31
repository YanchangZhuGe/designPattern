<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgsubid")==null?user.getSubOrgIDofAffordOrg():request.getParameter("orgsubid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>要素监控</title>
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
		<!-- <div id="north" data-options="region:'north',split:true" style="height:365px;"> -->
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="main_grid">
						<thead>
							<tr>
								<th data-options="field:'duisubid',checkbox:false,align:'center',hidden:true" width="10">主键</th>
								<th data-options="field:'wtcname',align:'center',sortable:'true'" width="35">物探处</th>
								<th data-options="field:'duiorgname',align:'center',sortable:'true'" width="20">地震队</th>
								<th data-options="field:'kgys',align:'center',sortable:'true'" formatter='showState' width="20">开工验收</th>
								<th data-options="field:'bygl',align:'center',sortable:'true'" formatter='showState' width="20">保养管理</th>
								<th data-options="field:'sbkq',align:'center',sortable:'true'" formatter='showState' width="20">设备考勤</th>
								<th data-options="field:'drdj',align:'center',sortable:'true'" formatter='showState' width="20">定人定机</th>
								<th data-options="field:'yzjl',align:'center',sortable:'true'" formatter='showState' width="20">运转记录</th>
								<th data-options="field:'sbfh',align:'center',sortable:'true'" formatter='showState' width="20">设备返还</th>
								<th data-options="field:'sgys',align:'center',sortable:'true'" formatter='showState' width="20">收工验收</th>
								<!-- <th data-options="field:'tzsbgl',align:'center',sortable:'true'" formatter='showState' width="30">特种设备管理</th> -->
								<th data-options="field:'dzyqpk',align:'center',sortable:'true'" formatter='showState' width="30">地震仪器盘亏</th>
								<th data-options="field:'dzyqhs',align:'center',sortable:'true'" formatter='showState' width="30">地震仪器毁损</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;&nbsp;正常：<img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="15px" height="15px"/>
							&nbsp;&nbsp;&nbsp;&nbsp;报警：<img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="15px" height="15px"/>
							&nbsp;&nbsp;&nbsp;&nbsp;无项目：<img src="<%=contextPath%>/pm/projectHealthInfo/headgray.jpg" style="cursor: pointer;" width="15px" height="15px"/>
						</div>						
						<div style="float:right;height:28px;">
							年度：<input name="proyear" class="input_width" id="proyear" style="width:150px;" />
							&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="refDevData()"><i class="fa fa-refresh fa-lg"></i> 刷新</a>
							&nbsp;&nbsp;&nbsp;&nbsp;
						</div>
					</div>
				</div>
			</div>
		<!-- </div> -->
	</div>
	<div id="win"></div>
</body>
<script type="text/javascript">
var selectTabIndex = 0;
var currentId = "";
var queryParams;

$(function(){
	$('#proyear').combobox({ 
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
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=queryHomeWTCMinitorList",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
			$("#main_grid").datagrid("autoMergeCells", ['wtcname']);
        }			
	});
});
//刷新
function refDevData(){
	//组织查询条件
	var params = {};
	params["proyear"] = $("#proyear").combobox("getValue");
	params["orgsubid"] = '<%=orgSubId %>';
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//清空查询条件
function clearQueryText(){
	$("#proyear").combobox("reload");
	setFirstPage("#main_grid");
	searchDevData();
}
//查询及返回刷新
function searchDevData(){
	//组织查询条件
	var params = {};
	params["proyear"] = $("#proyear").combobox("getValue");
	params["orgsubid"] = '<%=orgSubId %>';
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//显示红绿灯
function showState(value,row,index){
	if(value==0){
		if(row.monitor_type == '1'){//考核单位的不能下钻到项目
			return '<a href="####"><img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
		}else{
			return '<a href="####" onclick="popState(\'' + $(this).attr("field") + '\',\''+row.duisubid+'\')"><img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
		}		
	}else if(value==2){
		return '<a href="####"><img src="<%=contextPath%>/pm/projectHealthInfo/headgray.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
	}else{
		if(row.monitor_type == '1'){//考核单位的不能下钻到项目
			return '<a href="####"><img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
		}else{
			return '<a href="####" onclick="popState(\'' + $(this).attr("field") + '\',\''+row.duisubid+'\')"><img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';	
		}
	}
}
//钻取展示项目指标信息
function popState(typeid,subid){
	var proyear = $("#proyear").combobox("getValue");
	window.top.$.JDialog.open('${pageContext.request.contextPath}/dms_info/projectWTCStateMonitor.jsp?typeid='+typeid+'&duisubid='+subid+'&proyear='+proyear,{
        win:window,
        width:980,
        height:480,
        title:"项目红绿灯显示",
		callback:'' //设置回调函数
     } );
}
</script>
</html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();	
	String start_date = new java.text.SimpleDateFormat("yyyy-MM").format(new Date())+"-01";
	String end_date = new SimpleDateFormat("yyyy-MM-dd")
	.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>日常检查统计</title>
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
								<th data-options="field:'detail_id',checkbox:false,align:'center',hidden:true" width="10">主键</th>
								<th data-options="field:'org_name',align:'center',sortable:'true'" width="25">物探处</th>
								<th data-options="field:'dt',align:'center',sortable:'true'" formatter='showState1'  width="20">电梯</th>
								<th data-options="field:'dc',align:'center',sortable:'true'" formatter='showState2'  width="20">电动单梁起重机</th>
								<th data-options="field:'cc',align:'center',sortable:'true'" formatter='showState3'  width="20">叉车</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">
							 
			 	   
							&nbsp;&nbsp;&nbsp;&nbsp;开始时间：<input name="start_date" id="start_date" class="input_width easyui-datebox" type="text" value="<%=start_date%>"  style="width:268px" editable="false" required/>
							&nbsp;&nbsp;&nbsp;&nbsp;结束时间：<input name="end_date" id="end_date" class="input_width easyui-datebox" type="text"  value="<%=end_date%>" style="width:268px" editable="false" required/>
							&nbsp;&nbsp;&nbsp;&nbsp;<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
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
			'sub_id':'<%=orgSubId %>',
			'start_date':$("#start_date").datebox('getValue'),
			'end_date':$("#end_date").datebox('getValue')
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=DevCommSrv&JCDP_OP_NAME=queryRiChangjcList",
		onDblClickCell: function(index,field,value){
		} 		
	});
});

 
function showState1(value,row,index){
	if(value>0){
			return '<a href="####" onclick="popState(\''+row.sub_id+'\',\'S1507\')">'+value+'</a>';
			 
	}else{
	return 0;
	}
}
function showState2(value,row,index){
	if(value>0){
		return '<a href="####" onclick="popState(\''+row.sub_id+'\',\'S07010201\')">'+value+'</a>';
	 
		 
	}else{
	return 0;
	}
}
function showState3(value,row,index){
	if(value>0){
	return '<a href="####" onclick="popState(\''+row.sub_id+'\',\'S080601\')">'+value+'</a>';
  
	}else{
	return 0;
	}
}
//查询及返回刷新
function searchDevData(){
	//组织查询条件
	var params = {};
	params["orgsubid"] = '<%=orgSubId %>';
	params["start_date"] = $("#start_date").datebox('getValue');
	params["end_date"] = $("#end_date").datebox('getValue'),
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
 
//钻取信息
function popState(subid,type){
	var startdate=$("#start_date").datebox('getValue');
	var enddate=$("#end_date").datebox('getValue');
	window.top.$.JDialog.open('${pageContext.request.contextPath}/rm/dm/devSpecial/checkinfolist.jsp?subid='+subid+'&type='+type+'&startdate='+startdate+'&enddate='+enddate,{
        win:window,
        width:980,
        height:480,
        title:"信息显示",
		callback:'' //设置回调函数
     } );
}
</script>
</html>
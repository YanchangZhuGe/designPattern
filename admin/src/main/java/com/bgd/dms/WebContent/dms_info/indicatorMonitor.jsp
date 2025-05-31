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
								<th data-options="field:'detail_id',checkbox:false,align:'center',hidden:true" width="10">主键</th>
								<th data-options="field:'monitor_type',align:'center',hidden:true">monitortype</th>
								<th data-options="field:'monitor_pro_type',align:'center',hidden:true">monitorprotype</th>
								<th data-options="field:'assess_name',align:'center',sortable:'true'" width="25">一级管理要素</th>
								<th data-options="field:'check_content',align:'center',sortable:'true'" formatter='showRemark' width="30">二级管理要素</th>
								<th data-options="field:'tlmwtc',align:'center',sortable:'true'" formatter='showState' width="25">塔里木物探处</th>
								<th data-options="field:'xjwtc',align:'center',sortable:'true'" formatter='showState' width="20">新疆物探处</th>
								<th data-options="field:'thwtc',align:'center',sortable:'true'" formatter='showState' width="20">吐哈物探处</th>
								<th data-options="field:'qhwtc',align:'center',sortable:'true'" formatter='showState' width="20">青海物探处</th>
								<th data-options="field:'cqwtc',align:'center',sortable:'true'" formatter='showState' width="20">长庆物探处</th>
								<th data-options="field:'dgwtc',align:'center',sortable:'true'" formatter='showState' width="20">海洋物探处</th>
								<th data-options="field:'lhwtc',align:'center',sortable:'true'" formatter='showState' width="20">辽河物探处</th>
								<th data-options="field:'hbwtc',align:'center',sortable:'true'" formatter='showState' width="20">华北物探处</th>
								<th data-options="field:'xxwtkfc',align:'center',sortable:'true'" formatter='showState' width="25">新兴物探开发处</th>
								<th data-options="field:'zhwhtc',align:'center',sortable:'true'" formatter='showState' width="25">综合物化探处</th>
								<th data-options="field:'xnwtc',align:'center',sortable:'true'" formatter='showState' width="25">西南物探处</th>
								<th data-options="field:'dqygs',align:'center',sortable:'true'" formatter='showState' width="25">大庆物探一公司</th>
								<th data-options="field:'dqegs',align:'center',sortable:'true'" formatter='showState' width="25">大庆物探二公司</th>
								<th data-options="field:'zbfwc',align:'center',sortable:'true'" formatter='showState' width="20">装备服务处</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;&nbsp;正常：<img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="15px" height="15px"/>
							&nbsp;&nbsp;&nbsp;&nbsp;报警：<img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="15px" height="15px"/>
							&nbsp;&nbsp;&nbsp;&nbsp;无项目：<img src="<%=contextPath%>/pm/projectHealthInfo/headgray.jpg" style="cursor: pointer;" width="15px" height="15px"/>
							<!-- &nbsp;&nbsp;&nbsp;&nbsp;其他物探处：<img src="<%=contextPath%>/pm/projectHealthInfo/headyellow.jpg" style="cursor: pointer;" width="15px" height="15px"/> -->
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
	//初始信息
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
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=queryHomeMinitorList",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
			$("#main_grid").datagrid("autoMergeCells", ['assess_name']);
            for(var i = 0; i < data1.rows.length; i++){
                if(data1.rows[i].spare3!= undefined){
                    var spare3 = data1.rows[i].spare3;
                }
                tipView('remark-' + i,spare3,'right');
            }
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
//查询及返回刷新
function searchDevData(){
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
//指标备注说明
function showRemark(value,row,index){
	return '<div id="remark-'+index+'" style="width:auto;">'+value+'</div>';
}
//显示红绿灯
function showState(value,row,index){
	if(value==0){
		if(row.monitor_type == '1'){//考核单位的不能下钻到项目
			return '<a href="####"><img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
		}else{
			return '<a href="####" onclick="popState(\'' + $(this).attr("field") + '\',\''+row.monitor_pro_type+'\',\''+row.detail_id+'\')"><img src="<%=contextPath%>/pm/projectHealthInfo/headgreen.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
		}		
	}else if(value==2){
		return '<a href="####"><img src="<%=contextPath%>/pm/projectHealthInfo/headgray.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
	}else{
		if(row.monitor_type == '1'){//考核单位的不能下钻到项目
			return '<a href="####"><img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';
		}else{
			return '<a href="####" onclick="popState(\'' + $(this).attr("field") + '\',\''+row.monitor_pro_type+'\',\''+row.detail_id+'\')"><img src="<%=contextPath%>/pm/projectHealthInfo/headred.jpg" style="cursor: pointer;" width="14px" height="14px"/></a>';	
		}
	}
}
//钻取展示项目指标信息
function popState(subid,monitorprotype,detailid){
	var proyear = $("#proyear").combobox("getValue");
	window.top.$.JDialog.open('${pageContext.request.contextPath}/dms_info/projectStateMonitor.jsp?detailid='+detailid+'&monitorprotype='+monitorprotype+'&subid='+subid+'&proyear='+proyear,{
        win:window,
        width:980,
        height:480,
        title:"项目红绿灯显示",
		callback:'' //设置回调函数
     } );
}
</script>
</html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>验收准备</title>
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
		<div id="north" data-options="region:'north',split:true" style="height:325px;">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="backapp_grid">
						<thead>
							<tr>
								<th data-options="field:'ck_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'ck_cid',align:'center',sortable:'true'" width="20">验收单号</th>
								<th data-options="field:'pact_num',align:'center',sortable:'true'" width="40">合同号</th>
								<th data-options="field:'count',align:'center',sortable:'true'" width="15">问题总数</th>
								<th data-options="field:'count_finish',align:'center',sortable:'true'" width="15">已解决数量</th>
								<th data-options="field:'percent',align:'center',sortable:'true'" width="15">解决百分比</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;验收单号：<input id="q_ck_cid" class="input_width query" style="width:120px;float:none;">
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="问题详情">
                	<table id="backinfo_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'question_id',checkbox:true,align:'center'" width="10">主键</th>
								<th nowrap="false"nowrap="false" data-options="field:'question_instruction',align:'center',sortable:'true'" width="20">问题描述</th>
								<th nowrap="false" data-options="field:'question_info',align:'center',sortable:'true'" width="40">问题状态</th>
								<th nowrap="false" data-options="field:'y_date',align:'center',sortable:'true'" width="15">预计解决时间</th>
								<th nowrap="false" data-options="field:'question_function',align:'center',sortable:'true'" width="15">解决办法</th>
								<th nowrap="false" data-options="field:'question_serctor',align:'center',sortable:'true'" width="15">问题解决单位</th>
								<th nowrap="false" data-options="field:'s_date',align:'center',sortable:'true'" width="15">实际解决时间</th>
							</tr>
						</thead>
					</table>
					<div id="tb3" style="height:28px;">
						<div style="float:right;height:28px;">
 
							<easyuiAuth:EasyUIButton functionId="wtgz_upd" className="fa fa-pencil-square fa-lg" event="toModifyMixPlanPage()" text="修改"></easyuiAuth:EasyUIButton>
						</div>						
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
var orgSubId = "<%=orgSubId%>";

$(function(){
	//设置样式
	$(".only_read").attr("readonly","true");
	$(".only_read").css("border","0").css("color","blue").css("background-color","transparent");
	$("#detail tr").each(function(index){
		if(index%2==0){
			$(this).addClass("datagrid-row-alt");
		}		
	});
	//如果有行被选中，则加载选中标签的内容
	$('#tab').tabs({
		onSelect: function(title,index){
			selectTabIndex=index;
			var row = $('#backapp_grid').datagrid('getSelected').ck_id;
			if(row){
				if(selectTabIndex==0){
					//验收设备
					loadMixCollInfo(row);
				}else if(selectTabIndex == 1){
					// 验收小组
					loadMixCollDetial(row);
				}
			}			
		}
	});
	//初始单台设备调配信息
	$("#backapp_grid").datagrid({
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
			currentId = data.ck_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadMixCollInfo(currentId);
			}else if(selectTabIndex == 1){
				// 保养项目
				loadMixCollDetial(currentId);
			} 
		},
		queryParams:{//必需参数
			'orgSubId':orgSubId
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckDevQuestion&JCDP_OP_NAME=queryCheckQuestionInfoList"
	});
	//初始化保养项目信息,消耗备件信息
	$("#backinfo_grid").datagrid({
		method:'post',
		rownumbers:true,
		toolbar:'#tb3',
		border:false,
		striped:true,
		singleSelect:true,
		pagination:true,
		fit:true,
		fitColumns:true
	});
});

//加载验收设备基本信息
function loadMixCollInfo(ck_id){
	$("#backinfo_grid").datagrid({
		queryParams:{'ck_id': ck_id},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckDevQuestion&JCDP_OP_NAME=queryCheckQuestionList",
	});
}
//修改
function toModifyMixPlanPage(){
	var row = $('#backapp_grid').datagrid('getSelected');
	var rows = $('#backinfo_grid').datagrid('getSelected');
	if (row){
		popWindow('${pageContext.request.contextPath}/dmsManager/check/question_edit.jsp?flag=update&question_id='+rows.question_id+'&ck_id='+row.ck_id ,'950:380','-修改验收准备');
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//清空查询条件
function clearQueryText(){
	$(".query").val("");
	setFirstPage("#backapp_grid");
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
	$("#backapp_grid").datagrid('reload',queryParams);
}

</script>
</html>
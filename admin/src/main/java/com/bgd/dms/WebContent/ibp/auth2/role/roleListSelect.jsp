<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = request.getParameter("userid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>角色明细</title>
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
					<table id="main_grid">
					<thead>
							<tr>
								<th data-options="field:'role_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'role_category_name',align:'center',sortable:'true'" width="25">角色分类</th>							
								<th data-options="field:'role_c_name',align:'center',sortable:'true'" width="60">角色名称</th>
								<th data-options="field:'role_e_name',align:'center',sortable:'true'" width="20">角色英文名称</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="padding:5px;height:auto">
						<div style="padding:1px;height:auto">						
							&nbsp;&nbsp;角色分类：<input id="rolename" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;角色名称：<input id="chrolename" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;英文名称：<input id="enrolename" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i>查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i>清除</a>
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
var userid = '<%=userId%>';
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
	//设备信息显示
	$("#main_grid").datagrid({ 
		method:'post',
		nowrap:false,
		rownumbers:true,//行号 
		title:"",
		toolbar:'#tb2',
		border:false,
		striped:true,
		singleSelect:false,//是否单选 
		pagination:true,//分页控件 
		idField:'role_id',
		selectOnCheck:true,
		pageSize:100,
		pageList:[100, 200, 300, 400],
		fit:true,//自动大小 
		fitColumns:true,
		onClickRow:function(index,data){
		},
		onDblClickRow:function(index,data){
			save();
		},
		onSelect: function(index,data){
    	},
		onLoadSuccess : function(data1) {
			//$("#main_grid").datagrid("autoMergeCells", ['role_category_name']);
        },
		queryParams:{//必需参数
			'userid':userid
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AuthEntitySrv&JCDP_OP_NAME=queryRoleDetInfo"
	});
});
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
	$(".query").each(function(){
		if($(this).val()!=""){
			params[$(this).attr("id")] = $(this).val();
		}
	});
	params['userid'] = userid;
	//必须条件
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//保存
function save(){
	var idinfos = [];
	var rows = $('#main_grid').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		idinfos.push(rows[i].role_id);
	}
    if (idinfos == '') {
		$.messager.alert("提示","请选择一条记录!","warning");
		return;
	}
    $.ajax({
        type: "POST",
        url:'${pageContext.request.contextPath}/rm/dm/ajaxSaveBySrvAndMethod.srq?JCDP_SRV_NAME=AuthEntitySrv&JCDP_OP_NAME=saveUserRoleInfo',
    	//url:"<%=contextPath%>/ibp/auth2/toSaveUserRoleInfo.srq?idinfos="+idinfos+"&userid="+userid,
        data:"idinfos="+idinfos+"&userid="+userid,
        dataType:"json",
        error: function(request) {
        	$.messager.progress('close');
        	$.messager.alert('提示','保存出错,请重新保存或稍后重试!<br/>如无法解决请联系管理员...','error');
        },
        success: function(data) {
        	$.messager.alert('提示','保存成功','info');
        	var indexFrame = top.document.getElementById('indexFrame');
            var list = indexFrame.contentWindow.document.getElementById('list');        	
            list.contentWindow.loadMainDetial(userid);
            newClose();
        	//$("#form1").ajaxStop(function(){
    	   // top.closeDialogAndRefresh(window,loadMainDetial,userid);
    	      //  	});
        	//var $parent = self.parent.$;
        	//$parent('#detail_grid').datagrid('reload',{'userid': userid});     	 
        }
    });
}
</script>
</html>
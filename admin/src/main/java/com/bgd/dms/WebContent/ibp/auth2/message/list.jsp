<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String zz_id = request.getParameter("zz_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/processresource.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>转资申请列表</title>
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
								<th data-options="field:'msg_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'content',align:'center',sortable:'true'" width="20">消息内容</th>
								<th data-options="field:'show_date',align:'center',sortable:'true'" width="15">展示到期时间</th>							
								<th data-options="field:'creater_name',align:'center',sortable:'true'" width="25">创建人</th>
								<th data-options="field:'create_date',align:'center',sortable:'true'" width="25">创建时间</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;消息内容：<input id="content" class="input_width query" style="width:90px;float:none;">
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float: right;margin-right: 40px;">
						<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
				    	<auth:ListButton functionId="" css="xg" style="margin:2px 26px;" event="onclick='toEdit()'" title="修改"></auth:ListButton>
				    	<auth:ListButton functionId="" css="sc" style="margin:2px 26px;" event="onclick='toDelete()'" title="删除"></auth:ListButton>
				    	</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs"  data-options="fit:true,plain:true,tools:'#tab-tools'">
				<div  title="附件">
				<table id="fileInfo" data-options="toolbar:toolbar">
					<thead>
						<tr>
							<th data-options="field:'file_id',checkbox:true,align:'center'" width="10">主键</th>
							<th nowrap="false" data-options="field:'file_name',align:'center'"  width="20">附件名称</th>
							<th nowrap="false" data-options="field:'create_date',align:'center'" width="25">创建时间</th>
						</tr>
					</thead>	
				</table>
				</div>
           	 </div>
           	 <div id="tab-tools">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="dowloadFile()"></a>
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
	//如果有行被选中，则加载选中标签的内容
	$('#tab').tabs({
		onSelect: function(title,index){
			selectTabIndex=index;
			var row = $('#main_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//附件信息
					loadFileList(row.msg_id);
				}
			}			
		}
	});
	//初始化转资列表信息
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
		pageList:[10, 50, 100, 200, 300],
		onClickRow:function(index,data){
			if(selectTabIndex==0){
				//附件信息
				loadFileList(data.msg_id);
			}
		},
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=queryMessageList",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
			for(var i = 0; i < data1.rows.length; i++){
                if(data1.rows[i].org_name!= undefined){
                    var orgname = data1.rows[i].org_name;
                }
                tipView('orgName-' + i,orgname,'top');               
            }
        }		
	});
	//初始化文件信息
	$("#fileInfo").datagrid({
		method:'post',
		rownumbers:true,
		toolbar:'',
		border:false,
		striped:true,
		singleSelect:true,
		pagination:true,
		fit:true,
		fitColumns:true	
	});
});
//加载附件
function loadFileList(msg_id){
	
	//var retObj = jcdpCallService("ucmSrv", "getAttachmentList","zzid="+zzid);
	//console.log(retObj);
	$("#fileInfo").datagrid({
		queryParams:{'msg_id': msg_id},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=getMsgFileList',
		onLoadSuccess : function(data) {
          for(var i = 0; i < data.rows.length; i++){
                if(data.rows[i].own_org_name!= undefined){
                    var orgname = data.rows[i].org_name;
                }
                tipView('orgName-' + i,orgname,'top');
            }
        }
	});
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
	$(".query").each(function(){
		if($(this).val()!=""){
			params[$(this).attr("id")] = $(this).val();
		}
	});
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//添加消息
function toAdd(){
	popWindow("<%=contextPath%>/ibp/auth2/message/msgAdd.jsp");
}
//修改消息
function toEdit(){     
	var items = $('#main_grid').datagrid('getSelections');
		    if(items.length==0){ 
		    	$.messager.alert("提示","请先选中一条记录!","warning");
	     		return;
		    }
		    var ids = items[0].msg_id;
		    popWindowAuto('<%=contextPath%>/ibp/auth2/message/msgAdd.jsp?flag=update&msg_id='+ids,'840:650','');
}
//删除消息
function toDelete(){
	var baseData;
	var items = $('#main_grid').datagrid('getSelections');
    if(items.length==0){ 
    	$.messager.alert("提示","请先选中一条记录!","warning");
 		return;
    } 
    
    var ids = items[0].msg_id;
    
	if(confirm('确定要删除吗?')){  
		
		var retObj = jcdpCallService("EquipmentSelectionApply", "deleteUpdateMsgInfo", "msg_id="+ids);	
		if(typeof retObj.operationFlag!="undefined"){
			var dOperationFlag=retObj.operationFlag;
			if(''!=dOperationFlag){
				if("failed"==dOperationFlag){
					alert("删除失败！");
				}	
				if("success"==dOperationFlag){
					alert("删除成功！");
					searchDevData();
				}
			}
		}
	}
}
function dowloadFile(){
	var items = $('#fileInfo').datagrid('getSelections');
	if(items.length==0){ 
		$.messager.alert("提示","请先选中一条记录!","warning");
			return;
	}
	 var ids = items[0].file_id;
	window.location = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ids;
}
</script>
</html>
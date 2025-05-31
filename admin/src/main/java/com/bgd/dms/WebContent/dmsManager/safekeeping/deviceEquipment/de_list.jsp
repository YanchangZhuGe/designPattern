<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String orgId = user.getCodeAffordOrgID();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>定人定机</title>
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
					<table id="mixcoll_grid">
						<thead>
							<tr>
								<th data-options="field:'dev_acc_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="20">设备名称</th>
								<th data-options="field:'dev_model',align:'center',sortable:'true'" width="20">规格型号</th>
								<th data-options="field:'license_num',align:'center',sortable:'true'" width="20">牌照号</th>
								<th data-options="field:'self_num',align:'center',sortable:'true'" width="20">自编号</th>
								<th data-options="field:'dev_sign',align:'center',sortable:'true'" width="20">实物标识号</th>
								<th data-options="field:'erp_id',align:'center',sortable:'true'" width="20">ERP设备编号</th>
								<th data-options="field:'alloprinfo',align:'center',sortable:'true'" width="20">操作手</th>
							</tr>
						</thead>
					 </table>
					 <div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">	
							&nbsp;&nbsp;设备名称：<input id="s_dev_name" class="input_width query" style="width:100px;float:none;">						
							&nbsp;&nbsp;规格型号：<input id="s_dev_model" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;牌照号：<input id="s_license_num" class="input_width query" style="width:100px;float:none;">	
							&nbsp;&nbsp;自编号：<input id="s_self_num" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;实物标识号：<input id="s_dev_sign" class="input_width query" style="width:100px;float:none;">						
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<a href="####" class="easyui-linkbutton" onclick="toModifyMixPlanPage()"><i class="fa fa-cog fa-lg"></i> 修改</a>
							<a href="####" class="easyui-linkbutton" onclick="expDataExcel()"><i class="fa fa-file-text fa-lg"></i> 导出</a>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="基本信息" style="padding:10px;">
                	<div id="mixcoll_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					 <tr>
						 <td class="inquire_item">设备名称：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_name" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">规格型号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_model" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">自编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="self_num" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">牌照号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="license_num" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">主机序列号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">出厂编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">出厂日期：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="producting_date" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">发动机号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="engine_num" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">底盘号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="chassis_num" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">资产状况：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="account_stat_desc" style="width:250px;" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">技术状况：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="tech_stat_desc" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">使用状况：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="using_stat_desc" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
				 </table>
                </div>
                </div>
                <div title="变更记录" >
					<table id="backinfos_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'operator_name',align:'center',sortable:'true'" width="15">操作手</th>
								<th nowrap="false" data-options="field:'createdate',align:'center',sortable:'true'" width="15">变更时间</th>
								<th nowrap="false" data-options="field:'change_reason',align:'center',sortable:'true'" width="30">变更原因</th>
								<th nowrap="false" data-options="field:'file_name',align:'center',sortable:'true'" formatter='useFormater' width="20">附件</th>
								<th nowrap="false" data-options="field:'change_file',align:'center',hidden:'true'" width="20">附件</th>
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
	$("#mixcoll_grid").datagrid('reload',queryParams);
}

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
			var row = $('#mixcoll_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//设置基本信息
					loadMixCollInfo(row.dev_acc_id);
				}else if(selectTabIndex==1){
					//附件
					loadDocList(row.dev_acc_id);
				}
			}			
		}
	});
	//初始单台设备调配信息
	$("#mixcoll_grid").datagrid({ 
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
		onSelect: function(index,row){
    		//TODO 事件响应代码；
        	loadMixCollInfo(row.dev_acc_id);
    	},
		onClickRow:function(index,data){
			currentId = data.dev_acc_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadMixCollInfo(currentId);
			}else if(selectTabIndex==1){
				//附件
				loadDocList(currentId);
			}
		},
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=DevOperatorList&JCDP_OP_NAME=queryOperatortain"
	});
	//初始化详细信息
	$("#mixinfo_grid").datagrid({ 
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
	//初始化保养项目信息,消耗备件信息
	$("#backinfos_grid").datagrid({
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

//修改
function toModifyMixPlanPage(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	if (row){
		popWindow('${pageContext.request.contextPath}/dmsManager/safekeeping/deviceEquipment/de_edit.jsp?ids='+row.dev_acc_id,'720:520','-修改维修内容');
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//加载信息
function loadDocList(dev_acc_id){
	$("#backinfos_grid").datagrid({
		queryParams:{'dev_acc_id': dev_acc_id},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=DevOperatorList&JCDP_OP_NAME=getOperatorList",
	});
}

//导出设备档案
function expDataExcel(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	window.location.href='<%=contextPath%>/dmsManager/safekeeping/toGetDevExcel.srq';
}

function loadMixCollInfo(dev_acc_id){
	if(dev_acc_id==""){
		 $(".mixcoll").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 //$.messager.progress({title:'请稍后',msg:'数据加载中....'});
	 $.ajax({
	        type: "POST",
	        url:'${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=DevOperatorList&JCDP_OP_NAME=getOperatortain',
	        data:{"dev_acc_id":dev_acc_id},
	        dataType:"json",
	        error: function(request) {
	        	//$.messager.progress('close');
	        	$.messager.alert('提示','查询数据出错...','error');
	        },
	        success: function(ret) {
	        	//$.messager.progress('close');
	        	var data = "";
	        	if(ret!=""){
	        		data = ret[0];
	        	}        		
	        	if(typeof data !="undefined" && data !=""){
	        		$(".mixcoll").each(function(){
	        			var temp = this.id;
	        			$("#"+this.id).val( typeof data[temp] != "undefined" ? data[temp]:"");
	        		});
	        	}else{
	        		$(".mixcoll").each(function(){
	        			$("#"+this.id).val("");
	        		});
	        	}
	        }
	 });
}

//清空查询条件
function clearQueryText(){
	$(".query").val("");
	setFirstPage("#mixcoll_grid");
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
	$("#mixcoll_grid").datagrid('reload',queryParams);
}

//现使用单位简写名称
function useFormater(value,row,index){
    if(value.length>0) {
       return '<a href="####" onclick="toDownload(\'' + row.change_file + '\')">'+value+'</a>'
   	}
}

function toDownload(fileid)
{
	window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+fileid;
}

</script>
</html>
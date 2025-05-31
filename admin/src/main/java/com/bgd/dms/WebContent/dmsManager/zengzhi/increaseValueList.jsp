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
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
<title>增值列表</title>
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
								<th data-options="field:'zz_info_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'valueadd_id',align:'center',sortable:'true'" width="20">增值单号</th>
								<th data-options="field:'valueadd_content',align:'center',sortable:'true'" width="55">增值内容</th>							
								<th data-options="field:'amount_money',align:'center',sortable:'true'" width="25">增值总金额(元)</th>
								<th data-options="field:'creater',align:'center',sortable:'true'" width="25">创建人</th>
								<th data-options="field:'create_date',align:'center',sortable:'true'" width="25">增值日期</th>
								<th data-options="field:'bsflag_desc',align:'center',sortable:'true'" width="25">状态</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;增值单号：<input id="valueid" class="input_width query" style="width:120px;float:none;">
							&nbsp;&nbsp;增值内容：<input id="valuecontent" class="input_width query" style="width:120px;float:none;">
							&nbsp;&nbsp;增值状态：
							<select id="valuestate" name="valuestate" class="select_width easyui-combobox" data-options="required:true,editable:false,panelHeight:'auto'" style="width:120px;" >
					    	    <option value="" selected="selected">--请选择--</option>
								<option value="1">创建</option>
								<option value="2">已申请</option>
								<option value="3">未增值</option>
								<option value="4">已增值</option>
					    	</select>
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="advanceSearchWindow()" ><i class="fa fa-filter fa-lg"></i> 高级查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="基本信息" style="padding:10px;">
                	<div id="base_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">增值单号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="valueadd_id" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">增值内容：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="valueadd_content" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">增值总金额：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="amount_money" class="input_width only_read basedet" />
					     </td>
					 </tr>
					 <tr>
					     <td class="inquire_item">创建人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="creater" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">增值日期</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="create_date" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">增值状态：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="bsflag_desc" class="input_width only_read basedet" />
					     </td>
					 </tr>
				 </table>
                </div>
                </div>
                <div title="单据明细" >
                	<table id="asset_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'zzd_id',align:'center',hidden:true" width="10">主键</th>
								<th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="25">设备名称</th>
								<th nowrap="false" data-options="field:'typbz',align:'center',sortable:'true'" width="20">规格型号</th>
								<th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="30">ERP设备编号</th>
								<th nowrap="false" data-options="field:'valueadd_money',align:'center',sortable:'true'" width="25">增值金额(元)</th>
								<th nowrap="false" data-options="field:'cg_order_num',align:'center',sortable:'true'" width="25">采购订单号</th>
								<th nowrap="false" data-options="field:'zzzjitem',align:'center',sortable:'true'" width="25">项目编号</th>
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
					//设置基本信息
					loadMainInfo(row.zz_info_id);
				}else if(selectTabIndex == 1){
					//单据明细信息
					loadDetialList(row.zz_info_id);
				}
			}			
		}
	});
	//初始化增值列表信息
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
				//设置基本信息
				loadMainInfo(data.zz_info_id);
			}else if(selectTabIndex == 1){
				//明细信息
				loadDetialList(data.zz_info_id);
			}
		},
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=queryIncreaseValueList",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
        }		
	});
	//初始化增值明细信息
	$("#asset_grid").datagrid({ 
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
//加载增值基本信息
function loadMainInfo(zzinfoid){
	if(zzinfoid==""){
		 $(".basedet").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.ajax({
	        type: "POST",
	        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=getIncreaseMainInfo',
	        data:{"zzinfoid":zzinfoid},
	        dataType:"json",
	        error: function(request) {
	        	$.messager.alert('提示','查询数据出错...','error');
	        },
	        success: function(ret) {
	        	var data = "";
	        	if(ret!=""){
	        		data = ret[0];
	        	}        		
	        	if(typeof data !="undefined" && data !=""){
	        		$(".basedet").each(function(){
	        			var temp = this.id;
	        			$("#"+this.id).val( typeof data[temp] != "undefined" ? data[temp]:"");
	        		});
	        	}else{
	        		$(".basedet").each(function(){
	        			$("#"+this.id).val("");
	        		});
	        	}
	       }
	 });
}
//加载增值明细
function loadDetialList(zzinfoid){
	$("#asset_grid").datagrid({
		queryParams:{'zzinfoid': zzinfoid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=queryIncreaseDevDet',
	});
}
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	$("#valuestate").combobox("setValue","");
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
	params["valuestate"] = $("#valuestate").combobox("getValue");
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//高级查询
function advanceSearchWindow(){
	window.top.$.JDialog.open('${pageContext.request.contextPath}/dmsManager/zengzhi/zvAdvanceSearch.jsp',{
        win:window,
        width:840,
        height:480,
        title:"增值-高级查询",
		callback:advanceSearchInfo //设置回调函数
     } ); 
}
//高级查询回调方法
function advanceSearchInfo(ret){
	var params = ret.params;
	//可选条件
	$(".query").each(function(){
		var val = params[$(this).attr("id")];
		if(typeof val !="undefined" && val!=""){
			$(this).val(val);
		}
	});
	
	queryParams = params;
	//重新查询转资列表
	$("#main_grid").datagrid('reload',params);
}
//接收单位全称
function orgNameFormater(value,row,index){
	if(value != "") {
	    return '<div id="orgName-'+index+'" style="width:auto;">'+value+'</div>';
	 }else{
	    return value;
	 }
}
</script>
</html>